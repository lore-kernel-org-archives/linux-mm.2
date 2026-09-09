Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B29F7C79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 10:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6686B009E; Wed,  9 Sep 2026 06:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCE976B00A1; Wed,  9 Sep 2026 06:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABD906B00A5; Wed,  9 Sep 2026 06:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 864216B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 06:18:16 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1CC91A0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:18:15 +0000 (UTC)
X-FDA: 85193823750.13.0115BA2
Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 299F3100002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:18:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A9mOXGqG;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788949094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vqq1bLSj+HyikJMGO2+S/zPhjWI8z39VCLxfhn2Q3b0=;
	b=wJRMZGSYycMTh4U8xHCuuMxLVqf5gQbzeZe7uRF8N/OiDhRmrecew6pKXCXjK+pqJm+heA
	fcKGN2Gh8zLK0qTZ1DFobFuti5RtNrE8+/pSrttj33m/5h9O9LGn4gUD96jQOnyTos2Wp7
	nZNUB8ZMO/6KF9LTSKpNqp6/rob9Dso=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A9mOXGqG;
	spf=pass (imf05.hostedemail.com: domain of hughd@google.com designates 74.125.224.53 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788949094;
	b=QnRJnE2F0nXTUpnOZfopE5i26gKYJ/ra/liRbhdbs/gMbhcznPJq36cFIEquaGmE1jK4L1
	vZPM/4f5NUXne3GDojm+v3fwFKwvbR4hUHSyoodKHrCdzfJgct70hI5EDchYPeW2Y+GzuC
	aFC+Nef+xKTI46d1QQ0K/Ec/TirRMJ8=
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-66dbce0b639so4335053d50.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 03:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788949093; x=1789553893; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Vqq1bLSj+HyikJMGO2+S/zPhjWI8z39VCLxfhn2Q3b0=;
        b=A9mOXGqGNvxqdB1kTaSc/gb9jIyDFnTCCF2NhUGgKenGlElqg8f5Z3j1gLO+rekjc6
         eLksNwLaKjnmLJwZ0PEse7gF7CNKRvi4nxeZqqzTSrL3ewUl4hsBpyk9wIjHR5d4lvZX
         CuxDoDtycuY+6ff1efzWmvPNl7AHluIyengrmbEJPBCQ5WtKCr9d2JLtnOnZ2UEF4JZp
         jPaZmfNzMI5nDA/izDrU31HVcV8ztH+I2wrfXVyLTYkbVDAtU9Ob+uPCk7uIlY1Fph0f
         ya7Sm7+lrPHd/rGZJ5IqlztA3kGz3rYPVEeC70jhurvgj2KtDNQerYSYf8j3d0QinMdH
         q/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788949093; x=1789553893;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Vqq1bLSj+HyikJMGO2+S/zPhjWI8z39VCLxfhn2Q3b0=;
        b=mHWi1JLJgWWfuIGh8m2DVSfOlLPFn0u0ZtBxEhR0HeJihvXdXbnPiI5Fl83E4PPJ+o
         pqqxZT4y8hIDrbyuQ2cl7MGuW8m7id2k6kyWVAG0d6wj7YDiZu5nG+0IIf1cQeoqUPWj
         aFOdZ65q3XoEWw21egNUUoXLLFRP65qgUxxKRsmHG1imgMgoEBC7TZ0Xksnt0cBnVM0i
         ZtGKjl1pRCo+bY6Uwtpe1vWm7XDhTHgl2vu5Nnie1Wqnrt5ksNS0N6sa6YbhIetC6zCY
         MBO54dqr47ZKnvGl0bkT7QlfTk/Xwf8Ing0N/sjBHodNmOyERhPo0kzWwGbOIapNL4j+
         LjLw==
X-Forwarded-Encrypted: i=1; AKwUvBz5E3IMd2UPgu0oA0dxcNv+21BGD1MkR7rGUuhAxlaKhbU3tydeOPXmW72OodAlNIHGRVzddU2qJw==@kvack.org
X-Gm-Message-State: AFuF++keAn19jzelLdm+E7mi3r6oxBKbkmuN30dbVZ8qCwsITdsP7PH7
	vbCt1hhy5Wx/W9NWO1NQfQIIOqrI05mjxJrWCyQEyZffXksi4kg8QhG+C/XC4avaMg==
X-Gm-Gg: AYBFou0KovnfESCfNWKJk2+NP7GS8Zjpfhbvn6BVSSpZJyImwYIjJ5rTZuuia2dmytx
	Ybg5PaKpm2bsv0bZmBJzpzn4N0A8gxESERWcZVgMzLtLx2YgmdD1kG+4D2tsjvDnZhq83u+Xvud
	EEK2VoqQRasyh0mWEr6LKErUqXEQHyiUOFRNBILK8A5sQ+xSGkoDaxwmfcwupMxv6X3U1rF/G1b
	pJuiTlyjcSugB2V7L0o2UFiI1aL/t7OcZNggSWA2syEIdpWFg7WiO72mzWM7N3aIS1MFy1+phK8
	11UxVt2WfQKdPysIMaIrnq9HA3JyVgP3gA/cwHV5ulKa99K6+9M80f48YD3tFJ3XL0Sol+4sSgE
	b5NinHipfbB+wAHKtb4TFi19Q4WGOobrDMUSTcOcrcNBlcGS2AIg1KfDPpLCX0XeAQtV2D4GEnL
	mZ6OjQmtAZFbi1dLqyHpACUNC36rBY22S8b4u+lEZUOJEczxVmNlsUK24C1yZ2pIxdj+K/lPmNa
	lXOuk/Z5CyGjrqaCmTSpl+oyrS0UFqyDRhvrx4iyM4fcMsM0OvPeNkrTQs=
X-Received: by 2002:a53:ce92:0:b0:66c:c638:8e88 with SMTP id 956f58d0204a3-66fb58dcc41mr7649439d50.2.1788949092561;
        Wed, 09 Sep 2026 03:18:12 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66fb48d6ea5sm12216161d50.7.2026.09.09.03.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 03:18:11 -0700 (PDT)
Date: Wed, 9 Sep 2026 03:18:07 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, Alexandre Ghiti <alex@ghiti.fr>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Kiryl Shutsemau <kas@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
    Leonardo Bras <leobras.c@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>, 
    Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2 18/26] mm/fbatch: remove lru_add_drain() and _all() calls
 from various
In-Reply-To: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
Message-ID: <3af1563f-1db3-5974-659a-41463ad7a4c9@google.com>
References: <e28f9a94-4339-f8ac-8301-6be3c9b5b7ce@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 299F3100002
X-Stat-Signature: x884tq18jfog3cpag9f5yo484h33ayx4
X-Rspam-User: 
X-HE-Tag: 1788949094-964429
X-HE-Meta: U2FsdGVkX18J4JWCCj4O0n4ZXvXjRGVUQLzOqG/uo9Y36xcEA3+642mvE5/4IRisDkeLNuRd02OMwx50j9HxV3jldMd9URdRA9yQJbn+BbV9Qse/qq5JSr3SLPIRJByZog80d0nrmywBYGL3O4Xl8JEF+4TZ6Nk7Uoxh8arCzCmHml+BfIfJiKM0cyvkQmS0fBSs/NwCdXERnI1L5+CXy4J5lMhV6Gf0dFUnU3ltkRoWn4bZwsBR9KyYlLkxinkcUhlorWkXYAScKZv10H8laFh+ToJOPR32g/KKOWXt4187oPyBj0oSB7H0ERNTSXOGPMqjY7H4LIuBEV3USiUa+6xJCuSDO2k5FkBNnl6wGoWos586I7fH9KwRpSyGhCInCwwz1/PhqECh3fnkvzM55KaL1tTIMZxAdtV7sapNlCiVfkmNPN++anrtsM5nnnLajY+yNNO+gFlO158IYoPPX1IZv+7r2gxz4gNABC4X9etln+8W88LwOAan5Ytz9cX7+/ks5bpIHvyv8Spo7C6pTDKunQGF/qo6qkHHgcvYAVKvbF1PfIvsDonWby/dYVt9Xh1e/E5dgAAn8zHf61iX2DlkQSuA2IIRIixJHUVaKC8LoAKdsUXnMAPofKG5SXJg0fBf06/bPbSdlcL3AGL8Qcrrqn84vYYhEsbsPO8g9T8d1LP5GALEZaQSCN4Z8DJAA3KTppdr/w/Bmbww/xpjhoJ4hYhoVbxCykJAn1G2E3Ci6JINRQQ3qQ6cQTVp/juwBdB+RMkIVzOXXLYKInmv6CludfPtqlRGICoershzVIFOgsCrJPAX5SJjHZNsBAELny3liIatkICoG0seKt5grNJnpJopR2RfsQbgTBqrQNwNYw39458S6OSJZ9zYLsViQs0jVnhRnKiJcaTN4gYjrNRmFkXY3j3T9Cph8MxBA68SPn2CuGe2LejpssVTOPWPwcLtU6sYauoAcOotNnO
 /K82+W+k
 dt49Tf42K7PyTa8t9BW9U6dhMu6ZE5dKgPGESohrGEDRjwDOKkNy6IWy0/lTa6fSNvHzQi+f5t6lfQTOLeG7TqeaNKtGgwBQj30Po9x/ae51NaNJgQquwsIfwiTGsHFzDbkrzIW7MP3ezv99CpjtJtHirYXZMpRMIb7o8MdqZzwWja97tcOrbAH8CADXVE7+tqfHDthEX0M8u5LjCMyjAPUTT2MurESU7/A8aCEry2bAtwDSqVRxLg/AqaJh7kWEgjoSGacI27lp2xftaAUFQoSVofaJX+62pZrcUzwUdcoCjPFo7LxoZOBshjPMjfIUl/QgoRBMaw7WMo/A9Zi5amEM3m1oXsdwaE3a4fvybk8h+JZn/DOzLiA/SuMtXDwgnUDbzhMnt0gSzZLtcT2aCBEAnny1NIMXJF4Iok7h1kmnpFLj540HXTG9BS7fQIG8ZnkWGGFz9u2Wxc/7ms0W3Spkn4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Splitting into little patches gets tedious: now that folios on per-cpu
fbatches no longer hold an extra reference (and have the lru flag set),
most calls to lru_add_drain(), and more importantly lru_add_drain_all(),
should be removed.

Remove lru_add_drain() from compact_zone().
Remove lru_add_drain_all() from compact_nodes() and compact_store().
Keep lru_add_drain_cpu_zone() in compact_zone(): it was always a bit of
a hack, a cheap way to get a local_lock() around pcp drain_pages_zone().

Remove lru_add_drain() and lru_add_drain_all() from generic_fadvise(
POSIX_FADV_DONTNEED), but still retry once on failure; remove outdated
comment line from mapping_try_invalidate().

Remove every lru_add_drain() and lru_add_drain_all() from khugepaged.c.

Remove lru_add_drain_all() from KSM's scan_get_next_rmap_item() restart.

Remove lru_add_drain() from wp_can_reuse_anon_folio() and do_swap_page().

Remove lru_add_drain(), lru_add_drain_all() from migrate_device_unmap().

Keep lru_add_drain()s in mm/gup.c populate_vma_page_range() and
faultin_page_range(): good housekeeping after a bulk operation.

Keep lru_add_drain()s in mm/madvise.c: the ones after a bulk op probably
do want to "Push any new pages onto the LRU now", and update the stats;
the ones before a bulk op may be trying to stabilize initial conditions,
or to minimize draining under ptlock.

Keep lru_add_drain_all() in memcg-v1's mem_cgroup_force_empty():
it probably does want to push onto the LRU and update the stats.

Keep lru_add_drain() after bulk op in mlock_vma_pages_range(), partly
for "Unevictable kB" accuracy; but remove the lru_add_drain() before it.

Keep lru_add_drain()s in swap_cluster_readahead(), swap_vma_readahead():
they do want to "Push any new pages onto the LRU now" (akpm 2.5.46).

Keep lru_add_drain()s and lru_add_drain_all() throughout mm/vmscan.c:
it works on LRUs, so it does need folios to be on an actual LRU.

Signed-off-by: Hugh Dickins <hughd@google.com>
---
 mm/compaction.c     | 12 +-----------
 mm/fadvise.c        | 17 +----------------
 mm/khugepaged.c     | 11 -----------
 mm/ksm.c            | 12 ------------
 mm/memory.c         | 14 ++------------
 mm/migrate_device.c |  9 ---------
 mm/mlock.c          |  1 -
 mm/truncate.c       |  1 -
 8 files changed, 4 insertions(+), 73 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1290b9170cb2..5944094253b0 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2652,9 +2652,6 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
 
 	trace_mm_compaction_begin(cc, start_pfn, end_pfn, sync);
 
-	/* lru_add_drain_all could be expensive with involving other CPUs */
-	lru_add_drain();
-
 	while ((ret = compact_finished(cc)) == COMPACT_CONTINUE) {
 		int err;
 		unsigned long iteration_start_pfn = cc->migrate_pfn;
@@ -2969,9 +2966,6 @@ static int compact_nodes(void)
 {
 	int ret, nid;
 
-	/* Flush pending updates to the LRU lists */
-	lru_add_drain_all();
-
 	for_each_online_node(nid) {
 		ret = compact_node(NODE_DATA(nid), false);
 		if (ret)
@@ -3036,12 +3030,8 @@ static ssize_t compact_store(struct device *dev,
 {
 	int nid = dev->id;
 
-	if (nid >= 0 && nid < nr_node_ids && node_online(nid)) {
-		/* Flush pending updates to the LRU lists */
-		lru_add_drain_all();
-
+	if (nid >= 0 && nid < nr_node_ids && node_online(nid))
 		compact_node(NODE_DATA(nid), false);
-	}
 
 	return count;
 }
diff --git a/mm/fadvise.c b/mm/fadvise.c
index b63fe21416ff..f788a5020384 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -143,27 +143,12 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		if (end_index >= start_index) {
 			unsigned long nr_failed = 0;
 
-			/*
-			 * It's common to FADV_DONTNEED right after
-			 * the read or write that instantiates the
-			 * pages, in which case there will be some
-			 * sitting on the local LRU cache. Try to
-			 * avoid the expensive remote drain and the
-			 * second cache tree walk below by flushing
-			 * them out right away.
-			 */
-			lru_add_drain();
-
 			mapping_try_invalidate(mapping, start_index, end_index,
 					&nr_failed);
-
 			/*
-			 * The failures may be due to the folio being
-			 * in the LRU cache of a remote CPU. Drain all
-			 * caches and try again.
+			 * Retry if any failures, in case they were transient.
 			 */
 			if (nr_failed) {
-				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
 			}
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75639298efc2..d09f848d3591 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1236,10 +1236,6 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 	if (pte)
 		pte_unmap(pte);
 
-	/* Drain LRU cache to remove extra pin on the swapped in pages */
-	if (swapped_in)
-		lru_add_drain();
-
 	result = SCAN_SUCCEED;
 out:
 	trace_mm_collapse_huge_page_swapin(mm, swapped_in, referenced, result,
@@ -2320,8 +2316,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 					result = SCAN_FAIL;
 					goto xa_unlocked;
 				}
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
 			} else if (folio_trylock(folio)) {
 				folio_get(folio);
 				xas_unlock_irq(&xas);
@@ -2335,8 +2329,6 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 				page_cache_sync_readahead(mapping, &file->f_ra,
 							  file, index,
 							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
 				folio = filemap_lock_folio(mapping, index);
 				if (IS_ERR(folio)) {
 					result = SCAN_FAIL;
@@ -2975,8 +2967,6 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 	bool wait = true;
 	enum scan_result result = SCAN_SUCCEED;
 
-	lru_add_drain_all();
-
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3208,7 +3198,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->progress = 0;
 
 	mmgrab(mm);
-	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
 		enum scan_result result = SCAN_FAIL;
diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..890e2c51106d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2625,18 +2625,6 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		advisor_start_scan();
 		trace_ksm_start_scan(ksm_scan.seqnr, ksm_rmap_items);
 
-		/*
-		 * A number of pages can hang around indefinitely in per-cpu
-		 * LRU cache, raised page count preventing write_protect_page
-		 * from merging them.  Though it doesn't really matter much,
-		 * it is puzzling to see some stuck in pages_volatile until
-		 * other activity jostles them out, and they also prevented
-		 * LTP's KSM test from succeeding deterministically; so drain
-		 * them here (here rather than on entry to ksm_do_scan(),
-		 * so we don't IPI too often when pages_to_scan is set low).
-		 */
-		lru_add_drain_all();
-
 		/*
 		 * Whereas stale stable_nodes on the stable_tree itself
 		 * get pruned in the regular course of stable_tree_search(),
diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..e9e2199ba5e9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4313,9 +4313,6 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
 static bool wp_can_reuse_anon_folio(struct folio *folio,
 				    struct vm_area_struct *vma)
 {
-	const bool maybe_in_lru_cache = !folio_test_lru(folio);
-	const bool in_swapcache = folio_test_swapcache(folio);
-
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && folio_test_large(folio))
 		return __wp_can_reuse_large_anon_folio(folio, vma);
 
@@ -4326,16 +4323,9 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	 *
 	 * KSM doesn't necessarily raise the folio refcount.
 	 */
-	if (folio_test_ksm(folio) ||
-	    folio_ref_count(folio) > 1 + maybe_in_lru_cache + in_swapcache)
+	if (folio_test_ksm(folio))
 		return false;
-	if (maybe_in_lru_cache)
-		/*
-		 * We cannot easily detect+handle references from
-		 * remote LRU caches or references to LRU folios.
-		 */
-		lru_add_drain();
-	if (folio_ref_count(folio) > 1 + in_swapcache)
+	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
 		return false;
 	if (!folio_trylock(folio))
 		return false;
diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 009bfa8b212d..7ece4ca0654a 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -575,11 +575,8 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 	struct folio *fault_folio = fault_page ?
 		page_folio(fault_page) : NULL;
 	unsigned long i, restore = 0;
-	bool allow_drain = true;
 	unsigned long unmapped = 0;
 
-	lru_add_drain();
-
 	for (i = 0; i < npages; ) {
 		struct page *page = migrate_pfn_to_page(src_pfns[i]);
 		struct folio *folio;
@@ -600,12 +597,6 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
 
 		/* ZONE_DEVICE folios are not on LRU */
 		if (!folio_is_zone_device(folio)) {
-			if (!folio_test_lru(folio) && allow_drain) {
-				/* Drain CPU's lru cache */
-				lru_add_drain_all();
-				allow_drain = false;
-			}
-
 			if (!folio_isolate_lru(folio)) {
 				src_pfns[i] &= ~MIGRATE_PFN_MIGRATE;
 				restore++;
diff --git a/mm/mlock.c b/mm/mlock.c
index 97134eff6b56..971430e6251e 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -424,7 +424,6 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	vma_start_write(vma);
 	vma_flags_reset_once(vma, new_vma_flags);
 
-	lru_add_drain();
 	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
diff --git a/mm/truncate.c b/mm/truncate.c
index 4151f7a167e3..7ea5d513f76a 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -571,7 +571,6 @@ unsigned long mapping_try_invalidate(struct address_space *mapping,
 			 */
 			if (!ret) {
 				deactivate_file_folio(folio);
-				/* Likely in the lru cache of a remote CPU */
 				if (nr_failed)
 					(*nr_failed)++;
 			}
-- 
2.51.0


