Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02C5FC88E6E
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70D86B008C; Mon, 14 Sep 2026 11:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A6A6B0092; Mon, 14 Sep 2026 11:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D20AD6B0093; Mon, 14 Sep 2026 11:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8E1C6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:51:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3CE74801AF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:51:21 +0000 (UTC)
X-FDA: 85212807162.16.8C88499
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf30.hostedemail.com (Postfix) with ESMTP id 834B780004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:51:19 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ncVV43Vo;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789401079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eU9VXoF1KJeJ9qFFfIMdTfngvLjdefOLFWals6AtDzc=;
	b=NCPh+LrimRAuBQVHF4KcpMALJfxL8F8zU6MaQo5HHAelAtIDj+018DjHe4BnQOreiYgW48
	4/FxC404sqnGHcEDh8K8B7eT7kLBlrpmMfra8tYdDUT7MZzFS3Fk0b7jK1pZsyZNgu2WWb
	RbEyiOivFtcmBN9cnoje7dWqZZFg+7o=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ncVV43Vo;
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789401079;
	b=PTSr62XXTO5qALLYhUfBNnb4vz5Fk/lv1qEWQ0Kk64tGbmeqtj/XnW/TCPCvrfoNoEVchv
	O62NjOYnLAu9QRy2n7entEadTLEi9EYnZ4UX8zVIOXFz3iSqBWlH9gV2uBhHrCmCU0iP8h
	jNplMRCfhvXQod0FBfHcchpI8jTEdHk=
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939656ff6d9so254986585a.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789401078; x=1790005878; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eU9VXoF1KJeJ9qFFfIMdTfngvLjdefOLFWals6AtDzc=;
        b=ncVV43VorP7JU9gNMQ6z3L69vSPC4oQIq+pAe6fDN+hvzHPBsY/xjeETaO0yC53rzY
         K4SGi4C9RSCtTOyVOFxXImrYA7ZUPVbdoHiWpS7C2+jVN+nBdV+Vq/FQH6Vuzh4K/af7
         LCmqdNGjsCe6cVVohKzP/u19LxjoCTW1cIo6C6x4G3Tkl3IFJnJN6JpRBHbNGiKGjURf
         9FSBtXvoQMpSnUY/wBL2XCfLM50DrXY++oqK8EuTX+2pU3KYbEJEngb9nIBHmCVKQ1vy
         0Nir2FIwRZ6l7h4vDx8jVnDvKEV45yIbG65BBnGYhmScXVnbkA/ksmGo4/QHvdHgL3Rg
         Qvhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789401078; x=1790005878;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eU9VXoF1KJeJ9qFFfIMdTfngvLjdefOLFWals6AtDzc=;
        b=a52gwcodG3r3kvPE8PTjDk122H5jIFw3y3RBdLdgQU19DI98BMntAajBE9tjVPtEp5
         skDjk7vlos1Z9UAkwSIpCm6XfoeZzqfyskSzldus2iIoVE7YlQm6tKhO5U9UEPt/Zs1g
         FQhOtMD9JiSR/rQZCPjbG3/y7pbBrX8Rxj5PsSFoghgdRAnZu2QHZBzTdk8smx219Xwv
         +v5T+p4V97L0mwQifuKFrWsgOshv3tEGlgrRZ5m3vqI3GCKrgayAxvmxpPxLee7umczj
         NA2TyHBb/HJjwOXJdcTcclGSI9NEgP3y7/O/k3eUiI7g2HWk9cRYJVGpdd7lRayl1XVB
         ULVg==
X-Gm-Message-State: AFuF++mC8A7OSKmeJ4++ZE2JlyhqOfrU6A/A5ZYKnyJWo3+bRRBmrP/u
	eJWGIgoEbgP8t2ts1cXx1GKhZip67EuP4sVR1pIR6xltygfa/JVqDkJAGp5uQjaEZUIQOI2YA0c
	rhlVh
X-Gm-Gg: AYBFou3Of85A265cA4Kx2xLFQnM5BqWyZbtSs4wcADdeO8R1O1BQIkvcadZqskoY61w
	TPCBJ3/wotUq30VNl1JUkCz/TPaFPaVvqhU6H4RAmqMqfwPZvxK3z9k5pzmoSL1tZKWZhCPGuvm
	LyOJFtq9MR1utTCTSkFs3M4UqPMrUAb7lFXImM8KvCAAnC3hBSEPlXFMyQBBmCU13MEazTCi+pQ
	iOqmPGqJQXOTbdyunNKafo7fJ7pPhT8V9yJFb/jN5h9AbY/XznREEofq6uNMXQU5/Rdw3U93txT
	+R/C/2AFzETDcIAa36u/SHT2lHCKZgJh/YIbdSrMYJQqBfBWK6bKrxikQ5CGc0ao4RQdf5jcrdo
	kBW2hf1c7w2L8+m5Dla4RyqtK9IWa2iRYITXeRCgOJdYQWCh9eRHdalDdy0dtJKj3GdkGU9C+l/
	UyazuMk20W4HNoYStKEu0VfVX6xJC7ikzsDZC7pn3BPcYkYAwhONWt52LFTjG6ninnDbeeBxadT
	uWCjp818ZzhCSKMCgTIHHtstB/93WB4R7U33hn/pOLdq68eBJBVLKQCp4x8zuTXIMkKByw=
X-Received: by 2002:a05:620a:4626:b0:939:e6a7:dc with SMTP id af79cd13be357-93a29bfd291mr439988785a.52.1789401078460;
        Mon, 14 Sep 2026 08:51:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93a2d4514c7sm155963085a.28.2026.09.14.08.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 08:51:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: [PATCH] mm/page_alloc: let the bulk and folio allocators carry alloc_flags
Date: Mon, 14 Sep 2026 11:51:14 -0400
Message-ID: <20260914155115.439742-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 834B780004
X-Stat-Signature: zqz5nkqbwgpoh8gsfh535axjqp98qzgm
X-Rspam-User: 
X-HE-Tag: 1789401079-537770
X-HE-Meta: U2FsdGVkX19k8Kdo35gNlZtLoXpTTQ7wml5U9LFIRjeleQaCOJOo8s7Mutdur8JyX0Ahjko+BqdK6ssAyFjpljnZdGbJODaWeXDPzO9NwwmQQe52W5nr70iYOHzSUb7fiRgj84vDN4KQjxxayg1rH7iRZUmM2dHTOcHaviR7zZz3bXTgPpQe28iUBNnIg+zXX/pSHTOUo/I8nlCQcJOR3XUlt7wyz4f00D4tf5s3hbFzdbb99eARKWXwg3R+XR630uaAzfSe3jO1JMn0U6zKt3NLMvGyAM6tn7TmSA0s1w/M40rl09cbW7vrzn0wzLAiDNMvpeWmrtmPyYO5Zy4py8VOhbIfVl6ltDmA4j+aJbyWlub1Xe4OpSfjbDATrBL1qwZLTcHX6qkPSg0pEeg3HGHfQWR4iNUWRctSRqeNLae+KDjO0F/uynrYqpmovYxNH4tGcapDF77fm2G/8PFBINF4/C/llQJTfE+k2FtS0EAXhow7K74q2FYf6r9KyilYcWYL6ZaRwT6EWrqj7eIrMWrCRy/2mVV+MVH6UNE80h/zzfs3miXNSkCYwyun+yKgLxmOE+MU5wfCDGoidtvDiIjEqvsX5TrUp2yXHnyVqVCIZwcAOGT8funb5d7cvXZO7zUfkMDpPJrN0QzY/LDpKMd3f1XLb2HHo3aJNq425NKEf3jibRiWBasRtl2tj+1t/tCZg6cF4ecLERxFi4xaLrFyruTAJVRCe0oGC1jF8/V4hUPqU6IW6b3K/thBkUtafT+pSi+mwFtL65E4L8f0fWc24Mptpue5ddn4bd/y1FXiRBNyymu0qefqFlZ+O2Y5KmICW4n/btyNwSGNVUC7OCmHMSdrJvJZ7uUTgnS8lx3jAIYDAv5CQ6QDVhPJbVMDJ7Vrbnk1+LuVhOCQuDP84Tr7Z+Y4Czkf3j4dQAFawgayBO03Mls+fn/2rh9WkaS6vnNhY87OCMraeFVI7lz
 8toRm2o5
 RIL7J0jFKU7HOGU9TgIu3RdtEOOYaN8pNxkRYZpqlAVhue6xsPYVGTMC8JBdlH8E3woHhKrr0aaa2g4iB3C/4yKyhr5cJFHwOtOHKE1XM8ug5wF1HYL+AtU15/7DL/6Oa/6sKngLmHclTlRqXg/pl+pQEm145c3khAofDjYVp1oN371PFawdchyRVaCcCtEN1HJYVuZYl4CN5r/q0aUp709oeNyeoh6utZ1HpBJ1aw2+g/rDS1AUwcw329a/hHBtxmjGYRs3ZzTqFOIJZJL1tMdpQ+QJG4mCXLrpYEjlc2Zx3AFyLuPPT5Np5vrB949p9IzzF5Jr9c3eRL7ohImi1b+/t3/kIZHyAtsmQy0fyjZgEmaX1G3IYpEn/gKlT/aBqcWxrSwqr2PGdpCXX/GY/fFEYKgG+huMkSfs6B00vSv9Agv33ehiYmnfjP4ZKvTuCzpms10GEnC/k1PkW0iB1noS+4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__alloc_pages_noprof() takes an explicit alloc_flags, but the bulk and
folio entry points do not, so callers cannot select allocator behaviour
(e.g. an alternate zonelist) through them.

Thread alloc_flags through both, matching __alloc_pages_noprof(), and
keep the flag-carrying primitives mm-internal (page_alloc.h) so the
public gfp.h wrappers stay flag-free:

 - add __alloc_pages_bulk_noprof(gfp, ..., alloc_flags) in page_alloc.h
   alloc_pages_bulk_noprof() becomes a wrapper passing ALLOC_DEFAULT

 - give __folio_alloc_noprof() an alloc_flags parameter and moves
   __folio_alloc_node_noprof() moves into page_alloc.h
   __folio_alloc_noprof() is no longer exported

No functional change: every caller passes ALLOC_DEFAULT.

Cc: Brendan Jackman <brendan.jackman@linux.dev>
Signed-off-by: Gregory Price <gourry@gourry.net>
---

Brendan this will conflict mildly with your ALLOC_UNMAPPED work,
because you add an init_alloc_flags call in alloc_pages_bulk_noprof :
https://lore.kernel.org/linux-mm/20260726-page_alloc-unmapped-v3-20-6f5729aa9832@google.com/

I wanted to pull this out ahead to try to deal with the conflict.

 include/linux/gfp.h | 13 +------------
 mm/khugepaged.c     |  2 +-
 mm/migrate.c        |  2 +-
 mm/page_alloc.c     | 46 ++++++++++++++++++++++++++++++---------------
 mm/page_alloc.h     |  8 ++++++++
 5 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 872bc53f32ec..a327e58c313f 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -204,10 +204,6 @@ static inline void arch_free_page(struct page *page, int order) { }
 static inline void arch_alloc_page(struct page *page, int order) { }
 #endif
 
-struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask);
-#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
-
 unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 				nodemask_t *nodemask, int nr_pages,
 				struct page **page_array);
@@ -252,14 +248,7 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 	dump_stack();
 }
 
-static inline
-struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
-{
-	warn_if_node_offline(nid, gfp);
-
-	return __folio_alloc_noprof(gfp, order, nid, NULL);
-}
-
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid);
 #define  __folio_alloc_node(...)		alloc_hooks(__folio_alloc_node_noprof(__VA_ARGS__))
 
 /*
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0d8cd44b14c5..431c2e610b39 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1193,7 +1193,7 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
-	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
+	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask, ALLOC_DEFAULT);
 	if (!folio) {
 		*foliop = NULL;
 		count_collapse_event(order, THP_COLLAPSE_ALLOC_FAILED,
diff --git a/mm/migrate.c b/mm/migrate.c
index 7e3a81f06974..8e1c25a6f750 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2229,7 +2229,7 @@ struct folio *alloc_migration_target(struct folio *src, unsigned long private)
 	if (is_highmem_idx(zidx) || zidx == ZONE_MOVABLE)
 		gfp_mask |= __GFP_HIGHMEM;
 
-	return __folio_alloc(gfp_mask, order, nid, mtc->nmask);
+	return __folio_alloc(gfp_mask, order, nid, mtc->nmask, ALLOC_DEFAULT);
 }
 
 #ifdef CONFIG_NUMA_MIGRATION
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d977b8bf7245..f4ceec8cf77e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5151,8 +5151,8 @@ static inline bool prepare_alloc_pages(gfp_t gfp_mask, unsigned int order,
  * @page_array were set to %NULL on entry, the slots from 0 to the return value
  * - 1 will be filled.
  */
-unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
-			nodemask_t *nodemask, int nr_pages,
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+			int preferred_nid, nodemask_t *nodemask, int nr_pages,
 			struct page **page_array)
 {
 	struct page *page;
@@ -5160,8 +5160,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	struct zoneref *z;
 	struct per_cpu_pages *pcp;
 	struct list_head *pcp_list;
-	struct alloc_context ac;
-	unsigned int alloc_flags = ALLOC_WMARK_LOW;
+	struct alloc_context ac = { .alloc_flags = alloc_flags };
+	unsigned int fastpath_alloc_flags = alloc_flags | ALLOC_WMARK_LOW;
 	int nr_populated = 0, nr_account = 0;
 
 	/*
@@ -5202,7 +5202,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
 	gfp = current_gfp_context(gfp);
-	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
+	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &fastpath_alloc_flags))
 		goto out;
 
 	/* Find an allowed local zone that meets the low watermark. */
@@ -5210,7 +5210,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
+		if (cpusets_enabled() && (fastpath_alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
 		}
@@ -5220,16 +5220,17 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			goto failed;
 		}
 
-		cond_accept_memory(zone, 0, alloc_flags);
+		cond_accept_memory(zone, 0, fastpath_alloc_flags);
 retry_this_zone:
-		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
+		mark = wmark_pages(zone, fastpath_alloc_flags & ALLOC_WMARK_MASK) +
+		       nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				fastpath_alloc_flags, gfp)) {
 			break;
 		}
 
-		if (cond_accept_memory(zone, 0, alloc_flags))
+		if (cond_accept_memory(zone, 0, fastpath_alloc_flags))
 			goto retry_this_zone;
 
 		/* Try again if zone has deferred pages */
@@ -5261,7 +5262,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 			continue;
 		}
 
-		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
+		page = __rmqueue_pcplist(zone, 0, ac.migratetype, fastpath_alloc_flags,
 								pcp, pcp_list);
 		if (unlikely(!page)) {
 			/* Try and allocate at least one page */
@@ -5289,11 +5290,19 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	return nr_populated;
 
 failed:
-	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, ALLOC_DEFAULT);
+	page = __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask, alloc_flags);
 	if (page)
 		page_array[nr_populated++] = page;
 	goto out;
 }
+
+unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
+			nodemask_t *nodemask, int nr_pages,
+			struct page **page_array)
+{
+	return __alloc_pages_bulk_noprof(gfp, ALLOC_DEFAULT, preferred_nid,
+					 nodemask, nr_pages, page_array);
+}
 EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
 
 /*
@@ -5484,13 +5493,20 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 EXPORT_SYMBOL(alloc_pages_node_noprof);
 
 struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
-		nodemask_t *nodemask)
+		nodemask_t *nodemask, unsigned int alloc_flags)
 {
 	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
-					preferred_nid, nodemask, ALLOC_DEFAULT);
+					preferred_nid, nodemask, alloc_flags);
 	return page_rmappable_folio(page);
 }
-EXPORT_SYMBOL(__folio_alloc_noprof);
+
+struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
+{
+	warn_if_node_offline(nid, gfp);
+
+	return __folio_alloc_noprof(gfp, order, nid, NULL, ALLOC_DEFAULT);
+}
+EXPORT_SYMBOL(__folio_alloc_node_noprof);
 
 /*
  * Common helper functions. Never use with __GFP_HIGHMEM because the returned
diff --git a/mm/page_alloc.h b/mm/page_alloc.h
index b9259deddb59..23fc79ce97b6 100644
--- a/mm/page_alloc.h
+++ b/mm/page_alloc.h
@@ -258,6 +258,14 @@ struct page *__alloc_pages_noprof(gfp_t gfp, unsigned int order, int preferred_n
 		nodemask_t *nodemask, unsigned int alloc_flags);
 #define __alloc_pages(...)			alloc_hooks(__alloc_pages_noprof(__VA_ARGS__))
 
+struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int preferred_nid,
+		nodemask_t *nodemask, unsigned int alloc_flags);
+#define __folio_alloc(...)			alloc_hooks(__folio_alloc_noprof(__VA_ARGS__))
+
+unsigned long __alloc_pages_bulk_noprof(gfp_t gfp, unsigned int alloc_flags,
+		int preferred_nid, nodemask_t *nodemask, int nr_pages,
+		struct page **page_array);
+
 extern void zone_pcp_reset(struct zone *zone);
 extern void zone_pcp_disable(struct zone *zone);
 extern void zone_pcp_enable(struct zone *zone);
-- 
2.55.0


