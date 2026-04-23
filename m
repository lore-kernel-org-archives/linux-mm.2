Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98DCEFAD41C
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 05:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AEB56B008A; Thu, 23 Apr 2026 01:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0382E6B008C; Thu, 23 Apr 2026 01:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68DD6B0092; Thu, 23 Apr 2026 01:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D09056B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 01:57:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C68C8B96D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:57:10 +0000 (UTC)
X-FDA: 84688762620.20.65772EE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf06.hostedemail.com (Postfix) with ESMTP id 57634180005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:57:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HYgeWlsD;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776923828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKy0TTohZJFaJlYslJnrwjkg2kLIx4mMligqmSxDtQ0=;
	b=d6iQ7Rc/J1i3d6vPofhSncVZClCPVZkVr1yDt8oeW1c1YiNLGm4WsoHSzdWSm3w4JwnGO/
	uGQ1/Q87QkqZ3COPXolv8Am2+Wy+WeWLt9LBF7LN6+exq8cAD1/T2Lt/B68Wjeyi4ym9WI
	6+vnGAxyVwm5qDVaC7Zk3WIlQ1hwPic=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HYgeWlsD;
	spf=pass (imf06.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776923828; a=rsa-sha256;
	cv=none;
	b=ZH3eQsD+nWayeHo5o5CRJb2yjZNDh82v9WAgRzaibibITwKokD2Ftz+xe4uhPFt+JU6E/p
	M9p1FzV+Aof67IQvMrokGHnMSQv7Cbh41fQUENkE+/Te0acwr4dZG/J2uPAz6V8JP2+SR6
	crEVz+nh83T7gR6tnHnxwAz0dHyD6+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776923828; x=1808459828;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X0WxjIbHx5z6Rxp6kXcxclzwuMByqWEn9gesMvle8Ng=;
  b=HYgeWlsDhgKs7kUryvwxUoSHKy4LaGLnBSalm0YsOQiTY83/w0641IH9
   zsWc+FMckVH3FEydwK1hBu+hdAg+5x+5AxicK69IFZOZ9dqOImeg0MbPx
   2p+qHIpVnvLFb/NXdyB3FgNP4+4afE0N3XOYhCG7eQ1kYlGMj/xzx/sZg
   zZly+jDkRqRtaOWmNtl6eosi/MkwR3vIfs/5xFyykLXtrRPf2X4qqrQ8Y
   xH5TWDkaikU9oc3dgqcAyxBs/FwdC5WgK7NxAfxnhW/VoSjSiq6cqQzdB
   udsUy8uvQjjo65P5gQarVw/BzH/t3BtrowGpKPE7XgdkVJ/9SV8I5hp4w
   Q==;
X-CSE-ConnectionGUID: 5k2gtKUrQf61JJwTMhPF2g==
X-CSE-MsgGUID: /go2Oq/sSpSuKkEWa6NWAg==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="89273760"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="89273760"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 22:57:02 -0700
X-CSE-ConnectionGUID: p8YasWqfSRiLJkJEpizvtQ==
X-CSE-MsgGUID: 8WOmptFtRWWVyY54GAlCVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="255853890"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2026 22:57:02 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
Date: Wed, 22 Apr 2026 22:56:52 -0700
Message-Id: <20260423055656.1696379-2-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260423055656.1696379-1-matthew.brost@intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: foohat449azkszsmt5ukqz9sdp7f11dx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57634180005
X-HE-Tag: 1776923828-243882
X-HE-Meta: U2FsdGVkX19v20KFE68UvJEP1b1kzM6bqxJU7eJuTEFfPzFZQJfL7ifG6QhdQ7hpAuoaRiVgbBvPOEPpCGWOLaVYYLnHgPhJGK9vyr6m77o9ZECwRPvdZczcSrPgSNau9H71qgksVXdWTLZg9lSrKHD2HvEhAQaiyMTFax03IV6f+8lMLrpGPCi4hIpzZmq6n8PRuAwqwTH1EOx5TTswRRffkjSxeIdUCt+ZLaL+QEEQO7ARts9pFQySU4DkII483eiutT6IjoQZCIVnHn9wPKG4xNqSC7fWMyr6Pe0qpm4c/zQkJ0YTUfb2cM1q4iamxqz+70EEIFUch9VZ/I1pO7g/wxhODE1fvzHzRk4unKpjURPrz9HrWnoQvv8VomPf+pIZLO+qYMds9HVk8EUi1MJhj3eEtq6zbMLYSBjMue0pYpQQdW1UYHBpfcksTDst9j95HinH6SWgO0urtVSoo5CMD1u9urrmP3WPsFGh6+vU3a6OdiVJDo6G1gQS7m7F6QsbBvjdMRRN0bjlHJxZVaMxBikPTt+qAJNUem7oqbNSLmaNdBjur/+ik5FuezLr2H/gm+3w2c9QCY4xR+LewHfxgGtjYFwwgTkqg6WHBeXm6wub22V6wE/2jofd9amSY2zC94HtO8HRruRUE5e09rdS0hlcsamFOWGVzU6fkqVBdBJCrKn2NQal8p003Y0qFmwBW1dsWpFNVTe/LY9/8y5fraqkBhPMT8Nrz2EhRZLlGgEz6UAtI0eHQgAcYnBlJc6L+n2rnqWaq36Sf4Ly2pSOxEqhi+EdeloNxX0f7lK1/424myoKllwPkVLye/32EUlWDmbRyiRQ0ti3maqxDlclyXuVTIa2n8S4sIxgLCj03z9xrf2AufuUcyZofkmkzbC2AjYZQrXDHxw7IxyNXK2oztPdz4b/BAm9/QMgsQuZM+waBP2d0PlQFfc1LyW+bMCstPabkEMjrhampbt
 gIWYiqrk
 6Cm6tSRRU3c24ovtvh1QRdrNeK4aeiRth2PxaXk6dE3XY7VB8egmQkNjeTOjJ36fZpJkXzzfe2VqWIYh2tjOMRZmTcaqvLEZWropi88C/hh9UJsiHbO5KsX8ckYZjlaWgAw2alFJS0+PjJsG3szqMwzW9G/f2BsEhOxC0ZEsCvzRKI+2sz2uiE/L8NhQFxg+lIjPcN1FmIEAxQJunJyUsdCCbhF3bj8mW2J9UfOdSW3cwYI/nvPgArhgOsoXpjhKSMiX/u0Ysp9VSsDMFAiH5C/TfH7XjCQ06j8TC94Evb2O41+lWmqYZ8EagAgqQ3KjJhLdN1v9nJPpT4Eiw501AGmh8eGudBuiIfXtEVrHAfjR6Rriz2wayk1qOR2teo17N4jbat2O1DoIP0Px6591OBntisQZPL7i/iXGB+awTYq0Yjj8d+FYsUxbuvWe2OkRl7vYtLN96tySJa+TiCdR1RUXlQ+Sar2F6NcbdJotNPz4dTpWAfcCg7BB8LWw753pGqeJ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce zone_appears_fragmented() as a lightweight helper to allow
subsystems to make coarse decisions about reclaim behavior in the
presence of likely fragmentation.

The helper implements a simple heuristic: if the number of free pages
in a zone exceeds twice the high watermark, the zone is considered to
have ample free memory and allocation failures are more likely due to
fragmentation than overall memory pressure.

This is intentionally imprecise and is not meant to replace the core
MM compaction or fragmentation accounting logic. Instead, it provides
a cheap signal for callers (e.g., shrinkers) that wish to avoid
overly aggressive reclaim when sufficient free memory exists but
high-order allocations may still fail.

No functional changes; this is a preparatory helper for future users.

Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
---
 include/linux/vmstat.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..568d9f4f1a1f 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
 	return vmstat_text[item];
 }
 
+static inline bool zone_appears_fragmented(struct zone *zone)
+{
+	/*
+	 * Simple heuristic: if the number of free pages is more than twice the
+	 * high watermark, this strongly suggests that the zone is heavily
+	 * fragmented when called from a shrinker.
+	 */
+	if (zone_page_state(zone, NR_FREE_PAGES) > high_wmark_pages(zone) * 2)
+		return true;
+
+	return false;
+}
+
 #ifdef CONFIG_NUMA
 static inline const char *numa_stat_name(enum numa_stat_item item)
 {
-- 
2.34.1


