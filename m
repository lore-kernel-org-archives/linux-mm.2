Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A254CD13DE
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 18:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65696B0092; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEF836B0093; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04816B0095; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD0886B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:23:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E9C41A014B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:48 +0000 (UTC)
X-FDA: 84716045736.07.BC46562
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf27.hostedemail.com (Postfix) with ESMTP id 429B640014
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 18:23:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qa8Jn1ep;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777573426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/KWdKlKQczJErk+09cfrV9xYkG30E/YsEokv02NFI0=;
	b=Frd3Z4jQHmGg+L03PrtY5kq4qB+d8GasIb8D/yQ5G4BDoUhIcDkUK6aUcrjt/X4YHQcSN7
	kXfN/lZ9F7KuXBnYtlAIrtSG6MxnhMcBj1GkndeOsuO2jhLaTcYAMFb3LQ+6UNFukQy+xb
	+TRZ122Xzr0q4jWY4gczRmf9rSWGuQs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Qa8Jn1ep;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777573426; a=rsa-sha256;
	cv=none;
	b=NnQhwCwbHb9HfOj/bZITj6mWHyDc70Jm0ARoKLwBLcpOan0m2y/bINIlGbT0846VQmcF70
	nQr0m2/l2TRKYDBFZAM8BhcBFhPcf34Px9Oo7LsyAs8JBfFtJvqbDePKTbD1Njg+UcRHHF
	1fRh5i7PV5e6uG1OCHRb0Hw8BjrS1zQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777573426; x=1809109426;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GHkxm0wYYb4SrQQJzp26BvqDgj5d1MTHLdsthOQOpLE=;
  b=Qa8Jn1epO1/ON2poLV4g8yx59p9/ayCw5Xptfwq76ZxWEPGw7Y/tBnm4
   EUwojfXcurLe7CQ3UeYIAKN9mFKeA5S87VDBQj7KdKyYkA/HCfwVhQJbF
   xCnd/oPFEFOnhPb+jOT/vSU4J3NXk30NOwKAKk3ny64gRs9EH8yygOmsK
   yafD0lCGs2mSw7ITW7+3WkLV/d8D1zKx5c85OZ2IQIGGTZvwtgLQbFwDZ
   oust8UykpoV/o58l8sf9fGcOTl9kPuDwYShgU2/z+TRSduyb12emwOelI
   6GEDA5iirJ8vcMacnkNI2rHTEM1jUZJ+t6avt9e7THWLwk4Hw/IxG40Qn
   w==;
X-CSE-ConnectionGUID: haWwJZIvTUuPh/8HKYu8GA==
X-CSE-MsgGUID: qqNDtqFPRFGtnSbRdVL86Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82388995"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="82388995"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:41 -0700
X-CSE-ConnectionGUID: j8ntlywORQaX6R++juekDw==
X-CSE-MsgGUID: VDeEfBTvQ664s14Kaz6mMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="231532218"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 11:23:41 -0700
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
Subject: [PATCH v3 2/6] mm: Introduce zone_maybe_fragmented_in_shrinker()
Date: Thu, 30 Apr 2026 11:23:31 -0700
Message-Id: <20260430182335.2132382-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260430182335.2132382-1-matthew.brost@intel.com>
References: <20260430182335.2132382-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ry79mi3cq7infyjnkyygummhbf1b3rf
X-Rspamd-Queue-Id: 429B640014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777573426-286681
X-HE-Meta: U2FsdGVkX1+mrR6gHqhWzZ+sUjFjhec5MJHwoHFd2kggO6IYVdNFrexgma9Pvz8jbcC5TemrTbZe6zVxwwkHW+bGQZ/It4Q4AFVTM3bk22ex7yGjveHrcpey6PY0hQI9noHsD95Uh/L11Svi6DVsnyLEJlkaYwm+YoKL9I0E9EzTF9a1JKsVCqeqIgM6AzkZ7tgHPzsdip3FRt7RjUEceV0UQI+n8p2mHu2rl9eS0zTFILoFGYkVXigJ8M3gG40p46qwAS2+xEG76XnPZ8DUd0jXGOfrrdXhFPJbykTTp9Bb99j5FJx3mQmeAWfb4I/s3zhsESqap5FG/75DoPkZsssUroykrut+HnLMip/Lhl65GqbksA8x4qylJR8eisuzVbfg8BPV8BLEsrcbGQ8hA6l3OOsBMBmW/goSb9E58fUxfSU/uz/yWeFEGMdXn8jOF5tpo4QjGK6gqI4OpeEwoBTiC/9O+7fw2p64MOUikqwdocC8pnuUIdDlxkGigryLLFRXS+GINf5QqRBba4m2dlmPikYMgCi+u6PW22e5Uh6ykCO7zwgTQpFwewKiSfXbB0X+XKO95BWol2rdCKob+ELtfaO4P+mFreyG8H754vwPP7m68VmnSiCdkg073BF0bD06m32DEhJdXJf5Ys64CuAM8tCJskee+DFhuxIzXD2FsE3WJPas0xeV22gTtLDq3/xylvbb61HvDJqCG4paCY56gm9JKWhvU6GJ+Gw5hGNUQF6TVFdKkw3rEAl8bwv0r3sxJUEMWLpTMrJcsROMSu14Qa5XcCVTAusWxPvc0Z28rv3ZZGzWM2ecXdQQBD/sAc4fpsVLRiQT6MERvg4mZVo56kjNqQgrGNR+X3hMc4+cIgodTMMTb1M1kFT8CmJFbsV8CoYl+l35jxhWOPGkvcQozyhQsxII2EQoDDF5x+Ui7Hj7QYNpBvVMEk90dtm6HBfiKWPtNkYXBZ1xvC1
 mMMfc3Ds
 UG27/tGoEFGv6fRAmfGEzBAIrReMef7TulN5Lacs7xiq42T4tNUgze3yunrf9xzrbajMMKHrTgu1e1LC0Ihkwb0wwYHqWrVUkEHQbKFLrWzxA3d3krvLqVGx4kN68M8DqAZuKHU82O2tz1+8leaAhLYcZjMzXXltD/wclTtBECmLOdmuyTd44wZHGgDZ35l4qVt4Sedq68/f5ttf8n+1CQjhfZ1a+hitsmp4m3SVV8LK7ArinXEq4tdNGYkt+3VZCKHYx/YoTJHvK77TtLD/Lsbodlp+FrMOa4wVOTQ0eqFqfKCrxMYcOP4bftCJjk/1o4MmjH0sHMviiPPP8QwVqZaHxL2fe/pjIeV6L/PC6uhoonkvoq0Y7PSdd9Q41DcosizxxHfkyVfn21xOXQRhDuiE1vzeOKxtP94TxQxrEmS5alaqOcFiv2Kv2yrQs3kR7WHSrAEr9Fq1noFHC349h9D46OKZxTboM319DuwGS4bMFnHhsDSWqYFiqrGsQHvLtSDKE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce zone_maybe_fragmented_in_shrinker() as a lightweight helper to
allow subsystems to make coarse decisions about reclaim behavior in the
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

v3: s/zone_appear_fragmented/zone_maybe_fragmented_in_shrinker (David
    Hildenbrand)
---
 include/linux/vmstat.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index 3c9c266cf782..1ad48f70c9d9 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -483,6 +483,18 @@ static inline const char *zone_stat_name(enum zone_stat_item item)
 	return vmstat_text[item];
 }
 
+static inline bool zone_maybe_fragmented_in_shrinker(struct zone *zone)
+{
+	/*
+	 * Simple heuristic: if the number of free pages is more than twice the
+	 * high watermark, this may suggest that the zone is heavily fragmented.
+	 * When called from a shrinker, aggressively evicting memory in this case
+	 * may do more harm to overall system performance than good.
+	 */
+	return zone_page_state(zone, NR_FREE_PAGES) >
+		high_wmark_pages(zone) * 2;
+}
+
 #ifdef CONFIG_NUMA
 static inline const char *numa_stat_name(enum numa_stat_item item)
 {
-- 
2.34.1


