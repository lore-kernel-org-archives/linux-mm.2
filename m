Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4996CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 01:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3048E6B0005; Tue, 26 May 2026 21:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC346B008A; Tue, 26 May 2026 21:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F18B6B008C; Tue, 26 May 2026 21:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DDEB6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 21:43:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C84D6C1D66
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:43:05 +0000 (UTC)
X-FDA: 84811501530.12.E2A0574
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id F20A8100008
	for <linux-mm@kvack.org>; Wed, 27 May 2026 01:43:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlIwSpdl;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779846184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fHAP+dXRYZTfGDBp++y6CzrTTEWIHFIL88enGg73+U=;
	b=wqIhTfPPspd1Hn+5v8tH/16AGyo8IRcsDI0Gm2B45cyvkhkGRLp6TIjk/4T+qWpyAvUYwA
	DjrADOqJSTJ+4j+/vZTk+J+jIQZphmh0lynt0IXzNB1r91D2XCKuZX8X9rVqTipzOu+NiH
	QUZps0z/lJ9fZBn+4z6C1FLLfCY37bg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jlIwSpdl;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779846184; a=rsa-sha256;
	cv=none;
	b=dirlqIgfNLThv6wNlY6kG//zglbVlw2Z9N2mfD/fYXzw6N6avKDiOvoj999gtyEFOodh08
	sJHAbIVCmJsuLCVyvCn8LmTAq6di901CSKhPZeN90cVmouruxOPXFp+zYxs6LPYPhCSJu+
	3YkGVShYGOmmwUCLaJg6cgn8ptNN1Po=
Date: Wed, 27 May 2026 09:42:54 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779846181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8fHAP+dXRYZTfGDBp++y6CzrTTEWIHFIL88enGg73+U=;
	b=jlIwSpdlreKSpJiPJIJXN3tq/5wWkEDhReZkiz33cL2TG4g0BUmL8/wp5MBt85mFCMEHqw
	H/S9TlvOOE8WKvXtIuwl8/lDMkK+FtYRZbgES6thaBMrVzGG6M+eXviZGZBuZ2OQQ0JreJ
	yyB4VQJ8QZTG4xjO5Mx0BZYjSKNjuMc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 4/4] mm: swap: filter swap allocation by memcg tier
 mask
Message-ID: <ahZMHmMbhnNPspQj@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-5-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-5-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F20A8100008
X-Stat-Signature: une1fs8zmp3167ekze6fwgbeb19cz65c
X-HE-Tag: 1779846183-427812
X-HE-Meta: U2FsdGVkX1+xdVk3hEZAGuYnhFxO6VDqqP67OOpuEBMVb6IAHZTkjMtxgyKGO32tk5Ye3vnzDFS3e009XMr4exdmqmzQdpcp+W4ozQo5J5x9fSqton+YfuJJW3c3zKahDNNRYKyhZHgKHZzFjuH2YRu4J+Q2UJkKSyCiLS1QBxWORk23JNNjgeVOtwcD2MLTT8ya6fGuTlF+DfhUwWSIVb1BfX3MSqXN1b1H5ihuySijPlHEKFcW/znBWXru50vUvZQtHg4puxiN1q8voAEtvKx7LYJVkw0R9gsYGooY7I/MvgiVW2FeuMYZ2UCY/Oxbs3Skz4DHKwWYS9W7FLRJTzZGkbKdGfsi6qHkDoe7fpUUrVi44qlNzokh4luW/eX7gNXTDN23TIOnNR2vf3gF8W8EC7HSzeKyU1yFpO8bvGoof//ajwp1ChgIFIbE/Y8/Uwc44RaDWXWtepb5tmampN8KXw0FBxAd+sebDxpgnk1XTdwWIFUSTfwjKPPXX5BcMU8AoaD4GzYZtFUQvOtnZW/TG2539DjPhbnUIbT0/AMSCP5hSLuZq9X9pj8SXELpACnIJDtHn0XO4JU8oUqjDIciw2RId8eirZXAwieBsQdJ6Z9gKwutbFbCphIXfJK8xXrpkV67jc6B4Wi6noPJh6BOdv71vnRuXgoNnkITc1VuEsyD0HYc+Dpc58PKqS6trRrVEBWzQ8CJEg+wfE5LxkzJfHJE/p6JxAgusMlxWdT8Y6/BoGn1utsTcepT3369N0Azei6hPYUshaY1425/fYFc/jcs7bnY5YOJAE9idOAC+snLxtfbZUtYjZM/MzIEjugOQs6XY4VTy4IysqJGMwk+CRfemqza9+BUZqZ7XdDvWvvx+IpqmIXJL4hXGuZ6gQXe6mI+nuHDqkY4H+YHHC1Sp8HNx3hH5L5u4u6iBsUUsJSv5Pixm8tOhhA77FIjcmJCm7dgL9hdnKcx3xB
 sKdWSYDN
 f/b1XzST9bs7tlwcsLat2ygHjH+uQRsaTyDRo4ZsY2wxk7qO8EL5R7vsN9gp7S77CglmGflEvYy6xvGWqePJG/yMoRez0P75Tj7sO39Wn8XA3vwEEJuW4g59RU4RcGEkhMLJOCbjYP1ktTu+rdQ4xGjVTrMtFJN4zFSaM+3Oj/eSacy40FqQxdwTgE6n5IE/iDPrrTLGWja3Zr17y8Pkk6thrUJWkOHBo6yoBEn3iBkYghwmUQlxCeQItmMXmzURpoD833X6H0n8EcUI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
> Apply memcg tier effective mask during swap slot allocation to
> enforce per-cgroup swap tier restrictions.
> 
> In the fast path, check the percpu cached swap_info's tier_mask
> against the folio's effective mask. If it does not match, fall
> through to the slow path. In the slow path, skip swap devices
> whose tier_mask is not covered by the folio's effective mask.
> 
> This works correctly when there is only one non-rotational
> device in the system and no devices share the same priority.
> However, there are known limitations:
> 
>  - When non-rotational devices are distributed across multiple
>    tiers, and different memcgs are configured to use those
>    distinct tiers, they may constantly overwrite the shared
>    percpu swap cache. This cache thrashing leads to frequent
>    fast path misses.
> 
>  - Combined with the above issue, if same-priority devices exist
>    among them, a percpu cache miss (overwritten by another memcg)
>    forces the allocator to round-robin to the next device
>    prematurely, even if the current cluster is not fully
>    exhausted.
> 
> These edge cases do not affect the primary use case of
> directing swap traffic per cgroup. Further optimization is
> planned for future work.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
>  mm/swapfile.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index d5abc831cde7..8734e5d26b08 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1352,15 +1352,22 @@ static bool swap_alloc_fast(struct folio *folio)
>  	struct swap_cluster_info *ci;
>  	struct swap_info_struct *si;
>  	unsigned int offset;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	/*
>  	 * Once allocated, swap_info_struct will never be completely freed,
>  	 * so checking it's liveness by get_swap_device_info is enough.
>  	 */
>  	si = this_cpu_read(percpu_swap_cluster.si[order]);
> +	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
> +		!get_swap_device_info(si))
> +		return false;
> +
>  	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
> -	if (!si || !offset || !get_swap_device_info(si))
> +	if (!offset) {
> +		put_swap_device(si);
>  		return false;
> +	}

The whole patch looks good to me except of one nitpick. Is it a lille
cleaner with below tiny adjustment?

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2864cd8c2da9..cdf453bf6b80 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1359,15 +1359,12 @@ static bool swap_alloc_fast(struct folio *folio)
 	 * so checking it's liveness by get_swap_device_info is enough.
 	 */
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
-	if (!si || !swap_tiers_mask_test(si->tier_mask, mask) ||
-		!get_swap_device_info(si))
+	if (!si || !swap_tiers_mask_test(si->tier_mask, mask))
 		return false;
 
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!offset) {
-		put_swap_device(si);
+	if (!offset || !get_swap_device_info(si))
 		return false;
-	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {

>  
>  	ci = swap_cluster_lock(si, offset);
>  	if (cluster_is_usable(ci, order)) {
> @@ -1379,10 +1386,14 @@ static bool swap_alloc_fast(struct folio *folio)
>  static void swap_alloc_slow(struct folio *folio)
>  {
>  	struct swap_info_struct *si, *next;
> +	int mask = folio_tier_effective_mask(folio);
>  
>  	spin_lock(&swap_avail_lock);
>  start_over:
>  	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> +		if (!swap_tiers_mask_test(si->tier_mask, mask))
> +			continue;
> +
>  		/* Rotate the device and switch to a new cluster */
>  		plist_requeue(&si->avail_list, &swap_avail_head);
>  		spin_unlock(&swap_avail_lock);
> -- 
> 2.34.1
> 

