Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 835D2606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 23:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DPFSzklS
Received: by kanga.kvack.org (Postfix)
	id ADC2E6B00EF; Mon,  9 Nov 2026 18:24:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8CC46B05B0; Mon,  9 Nov 2026 18:24:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C9B6B05B1; Mon,  9 Nov 2026 18:24:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67F786B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:24:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1B4AF1A0873
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 23:24:20 +0000 (UTC)
X-FDA: 85417161480.27.226ACF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 35DE120002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 23:24:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DPFSzklS;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794266658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYLTUEr3KcsmorvXUyUc9odvTYuXILr61fltDodOWZM=;
	b=JJWew3pM4vddNPRzfJv9ErbY1onLDIMOQjzQ+qFIp45JO9uRVWrTXhfqyeIfSOQlzNXuRG
	6XTS6dKYIU3/8SQmDkBwDuahn0AtYaGpmvKoOyfWZewp9cP4Z39X4BZF156v6OpgFzffVP
	GQxdf0svQZ/cHmae14FaltA9MUoo0i4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794266658;
	b=7Wpv2TFLnQPZJBmAogclMW8lTwGr/Pq/SjlHBuNKzivEJplI8XRlGV0r2v30w06cVBTOk5
	hrO3HawZJDds0nYiO66YHcm72DBr4ydmffu2ORNJWGBXn/k89a8jyRiAS5ub7sKjUMFEb3
	hHnP/uWOxD5KkdCVqlDVSGJV0FB7gVQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DPFSzklS;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7438141453;
	Mon,  9 Nov 2026 23:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD6D51F0089F;
	Mon,  9 Nov 2026 23:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794266656;
	bh=NYLTUEr3KcsmorvXUyUc9odvTYuXILr61fltDodOWZM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DPFSzklS2gUNO06UEJB85q5gP8Rup2PF/SVj8HYqythdmmE9zFLDQXZ6Vqk8Zafiz
	 tuA3iiOfNDjgI7Fot8g2bHPAQDtig+sBOy0bPw84iU53OwOmXSwWpm5+8CMOTvxEZD
	 Adu+++wwF/rAu0X54viIjAcfzWj/hpE4VnTYhFas=
Date: Mon, 9 Nov 2026 15:24:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Ghiti <alexghiti@meta.com>
Cc: Kairui Song <ryncsn@gmail.com>, Alexandre Ghiti <alex@ghiti.fr>, Barry
 Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm, swap: only prefer nonfull clusters on
 synchronous devices
Message-Id: <20261109152415.f7bb160e4089a17f15c8f42c@linux-foundation.org>
In-Reply-To: <CAEmasaWMKsBSQ_LrewZc3f6a2u15WARAk25AKWjS4oFy8yciCA@mail.gmail.com>
References: <20261105155032.240457-1-alex@ghiti.fr>
	<20261105155032.240457-2-alex@ghiti.fr>
	<CAMgjq7DpCCiEK00Es7yU_i_wyf7NU4fFN7QFO_RptF9tGvPZWA@mail.gmail.com>
	<CAEmasaWMKsBSQ_LrewZc3f6a2u15WARAk25AKWjS4oFy8yciCA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 35DE120002
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: om8jw7ab96xpchdd7u4qpuyyca6odtmr
X-Rspam-User: 
X-HE-Tag: 1794266658-960514
X-HE-Meta: U2FsdGVkX19PXkHGa8NxRRryLYVIXGVnF5vLGrKMjQmJxBiRMynrs8+ASAUZS8vwaVMDMP2M0h9k2yD4SI3y7C7ISRII/kaZhiqsM2yhwY489mAEspoxVQUbMJ4y1NUiPWz76KzGmah94BfzXgyQVKBUmPrnK95E3eg1CkXzXYUygJAtq0GHyrH/3WrSjKUAppXpw3OFOnnvBACPdSc1IIIwcC877UJ0FiNnNrb+8wRDX8aysMx7/KH5EI1dj8aGj8MrOfC4Z1JKyvG27vJg0at7tfR9o4NRh3pl43RCPxLl1aoQyfmF+Oplp2hkHCCiSQzSSnVPiV48yeao1nXYICckbDibdG6nOLraj7BybZIb+pmear78S8p8bo+C9/M4PEp7JgrS+ZFpN9iPTHQa4+cY2PR0x+voGwhRBnI8y7U2uFs52TuNi7sIUusHYJJ0Q/v4TjrAqrUQmTwDUMsjq6lO0u6DazWOWKqBtSl/mfNyDakJI3HqtlIkidWF/OtceW2f8TTPImCp7joboJUyF4UoUrRgIs85Kdd+8bemzXZsi59Ht2VkIjtSZVUcUY9O5LKFT1OhUIO6XGx0GanzQW9cPoVqVs73l6QngBAL0kxWcyZuEsZ5OCC+ui3QDLFhGxYjUn3L93qaWV6cdtVUlMrwtmlm4Fl+0U0U4cYTzasrs0FFVEst6NHyWXFNhr5065eoJLdJhjWElw8lJrMwz3dLLJ4raQAkf37h6bowucAUCozdKdkfIFX34XJ5u99Fpmn5XSF2IEpTR0cFUWWExkvy7x7qNV6ZI4Li94RFPdlSBZbPseDSgkSET2bG+AAZ/dIcSXjWaFiKowuqM8YfNg1sN0GjyARypmL3i4L2gqOm9yce/bXJUAniUh6OCZKteiuboCxFyqyIpkTLtk5yowhhtHdSCLvbVOACthV5O4K6gxT4syVOl7i0RHHbTkc+0z1xnJnSwlmt9Zrgoqw
 siY9Wil6
 od5HCC+dLxWNgWiF2kG4HNzBj4Etke2Izyrb9AP8RKj00pxpVZWMwDDiQIYTYqHr1C48zegk09+BWT0NC5GUy5HX7LLwOz/YERYGbbUWIRHNl35fyj0dDIh4zOLkasqsoBWZ/w1DDf1bulTboE+3w3ywnngLpoLBvYXB5/DSmz+pNTnveyxWcb8QZ4tqwo6lB1zh6qde/zo/FMVn3r5vRta8/b9nX69J+gLu2F087Vp9xK1/C23YA71+KIEOPajvcf+XR8PutYgCOdlGWJldh9mAsc+klqssHxb9+pgLSAaAt735466aOOrK0lb09esw7QHd/YOXlSdLos8A8Dvp4GzPmjU1/8cIdeEpVptDq7OJk1+s0QtRL5RKDbIr+8yWMWFa0k6xmf300YcY2x6MCf/PjOzFoGHYBDh+LZlv2Ov9BqosmEvKiovHReguZCaDe7qWq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 10:00:45 +0100 Alexandre Ghiti <alexghiti@meta.com> wrote:

> > The patch itself looks good to me.
> >
> > Acked-by: Kairui Song <kasong@tencent.com>
> 
> Thanks,

Thanks all.

Please avoid single-patch patch series?  Present them as a unified
singleton.

Here's what I ended up with.  Please check.


From: Alexandre Ghiti <alex@ghiti.fr>
Subject: mm, swap: only prefer nonfull clusters on synchronous devices
Date: Mon, 09 Nov 2026 15:18:32 -0800

Commit 9a42aed48421 ("mm, swap: prefer nonfull over free clusters") made
the allocator fill nonfull clusters before taking free ones on swap
devices without discard.  Commit 3cedb745d354 ("mm: clarify the
folio_free_swap() for do_swap_page()") frees the swap slot on an exclusive
write fault.  Such faults now leave holes in formerly full clusters,
putting those clusters back on the nonfull list.  Reclaim allocates slots
one folio at a time, scattering a batch across the holes instead of
producing mergeable writes.  Later swapin can also require more read
requests.

On a mysql/sysbench workload in a 256 MiB memcg swapping to an NVMe
partition, 7.3 compared with the previous version produced 59% more device
read requests and 27% more write requests per transaction.  Throughput was
unchanged without iocost and fell 19% with iocost.

Prefer free clusters first on nonsynchronous devices, preserving
contiguous swap slots for merging I/O.  Keep nonfull-first on synchronous
devices such as zram: they do not merge I/O, and filling holes saves free
clusters for large folios.  Keep free-cluster preference on discard
devices to spread writes.

In the same workload, v2 reduced read requests per transaction by 14% and
write requests by 48% against its base kernel.  Throughput was unchanged
without iocost and improved 33% with iocost.  The RFC's batch-aware
allocator also improved this workload, but this policy needs no batch
information from reclaim.  Reverting the slot-freeing change would keep
swap space pinned under dirty pages; a proposed 50% swap-usage cutoff for
free-cluster preference was arbitrary and would stop helping as swap
filled.

The 7.0 to 7.2 kernels retained the swap slot after a write fault as a
side effect of 4b34f1d82c65 ("mm, swap: free the swap cache after folio is
mapped").  The observed regression requires both 9a42aed48421 and
3cedb745d354; stable backports should target trees containing both.

Link: https://lore.kernel.org/r/20261105155032.240457-1-alex@ghiti.fr
Link: https://lore.kernel.org/r/20261105155032.240457-2-alex@ghiti.fr
Link: https://lore.kernel.org/r/20261022145615.2184343-1-alex@ghiti.fr
Link: https://lore.kernel.org/r/CAMgjq7BFbXEKEt9faj_rg5AStfLkpJ0j57EQOOJ+L3-w2xRvtg@mail.gmail.com
Fixes: 9a42aed48421 ("mm, swap: prefer nonfull over free clusters")
Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Kairui Song <kasong@tencent.com>
Acked-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: <stable@vger.kernel.org>
---

 mm/swapfile.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/mm/swapfile.c~mm-swap-only-prefer-nonfull-clusters-on-synchronous-devices
+++ a/mm/swapfile.c
@@ -973,6 +973,17 @@ static bool __swap_cluster_alloc_entries
 	return true;
 }
 
+/*
+ * Prefer a new cluster over a nonfull one if the device needs discard, to
+ * spread out the writes, or if it is not synchronous, to keep the slots
+ * of a swapout batch contiguous so that its writes can be merged.
+ */
+static bool swap_prefer_free_cluster(struct swap_info_struct *si)
+{
+	return (si->flags & SWP_PAGE_DISCARD) ||
+	       !(si->flags & SWP_SYNCHRONOUS_IO);
+}
+
 /* Try use a new cluster for current CPU and allocate from it. */
 static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 					    struct swap_cluster_info *ci,
@@ -1143,11 +1154,7 @@ static unsigned long cluster_alloc_swap_
 	}
 
 new_cluster:
-	/*
-	 * If the device need discard, prefer new cluster over nonfull
-	 * to spread out the writes.
-	 */
-	if (si->flags & SWP_PAGE_DISCARD) {
+	if (swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
@@ -1159,7 +1166,7 @@ new_cluster:
 			goto done;
 	}
 
-	if (!(si->flags & SWP_PAGE_DISCARD)) {
+	if (!swap_prefer_free_cluster(si)) {
 		found = alloc_swap_scan_list(si, &si->free_clusters, folio, false);
 		if (found)
 			goto done;
_


