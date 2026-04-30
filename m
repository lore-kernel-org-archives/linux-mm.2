Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D882CD342C
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58E636B008C; Thu, 30 Apr 2026 15:18:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0B76B0092; Thu, 30 Apr 2026 15:18:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42E3C6B0093; Thu, 30 Apr 2026 15:18:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5916B008C
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:18:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDC7E14012A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:21 +0000 (UTC)
X-FDA: 84716183202.12.FD6213C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id BD5E740007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:18:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GfoCMg5p;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777576700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S/KWdKlKQczJErk+09cfrV9xYkG30E/YsEokv02NFI0=;
	b=yglQQlahxpbh9tREGDLe/YkARdVnGlCaBNz8tTWclT81gL6ggcX9WFN8rpgHOZIxNFDi5p
	u4mfgTadsEYF9Hb1WgX/fhPMq6uqZjKtm0TICmdSASwmAoiV3x7i8Wo+PF9ntoiUORq8U3
	x1yLJUPa7V2rt2Z7yxHtNnU5JEjBomM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777576700; a=rsa-sha256;
	cv=none;
	b=EVU7LA2AGyeHvcZDVLupkzFBxzdMuMo8enXijV0HP9bRHAVX12nWbpMWnbSiBc1tmLtiBE
	F9ilj1kpZ5PWP4dsxU9Gw8utqv3sejCtwyzBCvXT6+Auv7PttyrLev9SmmUVXYzPJp0P5n
	bw545LbfZFTqxV1R15AlI56QvOM9mBM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GfoCMg5p;
	spf=pass (imf27.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777576700; x=1809112700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GHkxm0wYYb4SrQQJzp26BvqDgj5d1MTHLdsthOQOpLE=;
  b=GfoCMg5p5n4t1lr9TYUOOeG/I7tGKR1Py1uTyB+uquqPYtkWZpM1v8uK
   ODSvjfwJYayzyAwdwsGswacxtmNsqQAeRLqS0RxwxPPzsSALXZXYykdvX
   1Rfa2e+KQu1dUk+AzYMNndVIiGNamdOSi1mPaVELvelCpHDCzFjlpD2dG
   eOTUgv97d25ZnEXvdZOH6UTZoSEvKiR2idey3B5Eln11TLdIiEOKpvSUP
   lN580qRSKOnaQi8FMRKD68mU+FSqXr7IkhN2vsKMhC9ndKLm+NOGw/LeV
   FPZ8apyt9sGWWld76CTRifHqClyfqMblxh25SSI/82uvEP36L00dj+sxG
   Q==;
X-CSE-ConnectionGUID: 2GYhObkRSneAlG9DgYc60w==
X-CSE-MsgGUID: AYUhM2oJSXWVlRUyJuqv+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="77706745"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="77706745"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
X-CSE-ConnectionGUID: md5b2HFPSdm+DLB6+IWNBA==
X-CSE-MsgGUID: eTWfpT+ETRezIfA8iUbD8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="233801145"
Received: from gsse-cloud1.jf.intel.com ([10.54.39.91])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:18:14 -0700
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
Subject: [PATCH v4 2/6] mm: Introduce zone_maybe_fragmented_in_shrinker()
Date: Thu, 30 Apr 2026 12:18:05 -0700
Message-Id: <20260430191809.2142544-3-matthew.brost@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260430191809.2142544-1-matthew.brost@intel.com>
References: <20260430191809.2142544-1-matthew.brost@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD5E740007
X-Stat-Signature: k8djknkxohsj11uof4x3higgz76y7mz9
X-Rspam-User: 
X-HE-Tag: 1777576699-282696
X-HE-Meta: U2FsdGVkX180P37/AZ94RYt+HopwUk/p1GKs1npEuG/j1PCdMgtJNKq+VJKftCILn8CVjNgaYDmNirYgI/nh4Fa8hI74+Y6uZ0hHOpo6g2/UxzH142VK0pwY2vCMbgmlzft0PaiIq52GiwIpVyBYYEFHOLL68xElCP5PUkRtzrBz7c3ACFQrhCGLrYXquXlmmRnQOUmsOo2qcltsCAoXtK3GEK4JoTTV4SewzRs/fZBexbhpbAVUL5yBdcqtvKUVj1yGEd+mk/k6c0XcN2iWigdyzX9YE72ml6LXzlrln6+RGB6DBN8z98bGKwZiXYiW3U5pCBcZu0/WWVWl+BI+3TAbiIYNmxrdE2wOFaNtb+qLLtILT2PYjX+Zy9vZKBTwsNOlY1loCPxkc8DCAXh7bInem4s3mye/gB6FKi3YDriMVLtScqrbE5lsOHh/Qm9TApWlr6dKJMYPUmo5/D+9z8N9M6zRZMhCabWo/PTXHsWt/9SHOKQjcBhRgQXodooCRv7zqgvKupSKE/s5ApEKJy7gINcl8YbWj02FZWDxQSnTUbGa82N9o0is0cuxN7WqkCNdNr8GBtvMLxSX8CMeBUYa64L7AGrXlNsRbaUhnzK21hTgnpM1D9OJ6EABtCSeqeIVpxrOhOGFdUxZ2lHjX9NJtY/B9WaMuf3XSXKoq8PnjRCK0sbCugzH6xwDoIUbKSRIN4UEQWyPCJdXCqmOiBk1IdmFB7b2m0HEN0LY4/0h9lUVCKFES4Jjp0kOZx4uUYn3Dz3EMVJNBdh/9rAGHDYLnszlKKF8c/0RQO/orape+liFrXCrb+QQvMRXtzbNWxJcyN0yILK90mQsd9B3ISaqlH6auHHRqFr/FL70ui2b5o4XtU2U9Amx4+EGxAkayJ/IUdDTJ12c5rLHUjLzozJzv+RX4fGygMOUFP/MPARSsjbNECu9bM4x/2oF2a/YSFYkR8tS4GW0MotGQGT
 kQkTB48y
 WK+iu9UUgyaN7uDKdHt1Qf/fPjCGoJ9xDx1A2BXuxYOkyk+iSNJv6HFM4ZIyFemd48oY/edVAK7FaPdwb2AkwOVfGWP/20aK76RAzU74Bv/yuiYY37mjNKnGhJtxz3AH3USUMSn1kkx+n+dxZTjlZOxDY4+RjcVvGrp3gboKNxZCS3g7TjERH17AjRCFmRsPmt1/+TUY7rzS1LVR6diwu091mb/d6A4Kx72ffN3zsWSIqN/uqg3yLbVjnVhzBIOUmKUeonoCEjuRer/8D828VsfV/JzdoIdd8y0y2+1IQ733DWsZXcIzLQvvxAAv4A4PuV2RLHIxE56fZ+3+ZA9eC7vI/tQMXRMMoOMyz88kTXSwPcTYD4x+49m+7qeVATyhJTh1i4ymorqQIwkEHww7gzJfkUQpAeq4fZ3+NXSNrrDQEHegMzwBfHrsLxfj43L3h3ZnBV1PiDNz2/nHUN9Y7C90adroAP5eiCfIRC/OdyHcTO4zFAJi4r9MOc1ck5cBgjXhNHJULTMXHNnL8jAYiBNtm5AHMm8KihU6sxi/WSXDA9zhCxxZa679yJvVU4OkZ/O+xPingAoKvwb71Xgl2DXVNbtJwM94pnMnctF7SMcqUwpKzM0lq0R6TxQqZBY5woPWZ
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


