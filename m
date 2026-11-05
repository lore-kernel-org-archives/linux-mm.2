Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC25606D812
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hpVNx9kv
Received: by kanga.kvack.org (Postfix)
	id 82EED6B05B9; Thu,  5 Nov 2026 00:15:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DECA6B05BB; Thu,  5 Nov 2026 00:15:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F49C6B05BC; Thu,  5 Nov 2026 00:15:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EF416B05B9
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:15:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4096340950
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:15:05 +0000 (UTC)
X-FDA: 85399901370.06.858561B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F8AF180005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:15:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpVNx9kv;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793855703;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ft12QEMagMn+rZpBJa3KHCLLuh49jFW/Xx5Q/JtWOfY=;
	b=NwgldB40QDRX6N+fsfoFfwSrS9lA1JcUBfnWfNbkrUqGEL5IdRKUPqZKvxgklCplBTeQgs
	pIsNi1JwE0tkAMYxFY1WQLhxqvPmud2wktCF7I3Sx6Fpn5EpxRs8rUGuAV0qvHnTi4dV9f
	Uj1bCV5X5K/M+mqnne8jW+1p1sazsjw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793855703;
	b=On7X+o3OvCmiFdPWq9y1vT4hL1gvB9410Ouv83dKFxnBqKgaNC5ISsDXaRi9LHDC5n/rCQ
	ID+jSs/TrnQe0RzVB6YJeX7dTIPVUyIIRXSBEytQLLiTDKKhdosC9ESUlbTAGIIsiA17Aq
	jxcf7EuCqQ2VBN9LoTGHF7f0yfFI5UQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hpVNx9kv;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2154F601DE;
	Thu,  5 Nov 2026 05:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460571F00A16;
	Thu,  5 Nov 2026 05:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793855702;
	bh=Ft12QEMagMn+rZpBJa3KHCLLuh49jFW/Xx5Q/JtWOfY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hpVNx9kvgpLJ/6O7ZIQKs8bK+nmZqpFJWhWRDM/EYSDP6qvDrn2JAOgvxFb5Xxttv
	 4/0ThvzGMM8Oecx3TBK/9A6shM3LpBw6hdccTMVfcP7U74RdCmWVq9Yes1tBW/coSn
	 OAN9+N2/83dNQEMLLiQiKURs+SXucu069Am3M4vkFVvtegOb+XN4ddHo0gmkiTNG8k
	 sYvryEMT7de7Y+icY3PB9qhjR+ioNzH/VPzPuuqZPNdbj1XyXBTdWmvhx7d8H+j8xJ
	 uyNH8HrRV9Jg/emcdoFRs0kO01YY1pj4FG73oMW3Tjm8JyVm3S8bdTQhOguaJe8q3H
	 WDgb9TPdSc3vQ==
Message-ID: <sashiko-outbox-198588@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/4] mm: hugetlb: fix cpuset violations in gigantic
 surplus allocations
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qi Zheng" <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev
Cc: linux-mm@kvack.org, "Qi Zheng" <zhengqi.arch@bytedance.com>
In-Reply-To: <046fd77e49ee8bb35e3bcc4104b9275d2e72ea5e.1793850539.git.zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <046fd77e49ee8bb35e3bcc4104b9275d2e72ea5e.1793850539.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 05:15:01 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: gzabuxn6dtudaqd9dam4xes5m64yutra
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9F8AF180005
X-Rspam-User: 
X-HE-Tag: 1793855703-404538
X-HE-Meta: U2FsdGVkX1/PkDHqqNvZ3rQ4s/oyTG5dHtceRU45nt+rLPrRCo3hk+e/n5HlSK5kDJpeqL9aFge3rnVGEtv1NLnXbXFYZkWpC2lTe6S7jD+F0sxBvL7JHiV8PD6ZBc2d/r9dXnxq1drKlgCE7RRVleGw6VCvdZSLtfkHhp16gmfsClfz5mlY6rg+8BzTyTxtDJC2WuoLwanguu8i4Bkxd9Vgddx0Za9z1LbHbLASxX68QolHqwEHR7mDjK2inC4ber/bSOJR7CMv7Zoht4DgyM+HZM/v6mRvtN7Ei7MOrwC1jsrsgjUymuULqfsO3KKRQnvivY0Mp3s/kmzxjLhjFhJhEMFHjdlWyRFRKLMIGOFc1019N4qHzcOe6CV2nPRRDA6OVVjkydzn+DuhLYNWhXkMv+2zchG8jXnaO+mBm9gvRTMgMp0zNwyoC7P2HMJWihrpVr/WLusMOnMwqNDI2KNYUNosjbLn1eZVizFp5n7r9ZYUe4SiF3cbcHY9bvunCtK3wUXAfxQZ+bSd9Ndxo0F8LZJH+hnuyRlq/PeNKYBK4f76XTsVlxw8EhFXXnamE/ZuApmXgGDGC5kcGWQ05dXzDS1tUULt2VPwHtfgQ+WM60eRIgBfe7sgoCQgQlCNUdbbQjCuIznIj4I2o71fyv/OlC1b0sX5sMQGZ+/35mxIYiXS97fuv/cD862kQbtIPrjIff7RdOVgi8F8LAD4FjlLHw/jV1KkwEbVmw7xU0FLk5ivUROuMCEmMHzVEwNsu0x0y/HasBzxBCuVdkksk10IXJiyp2diDs4O8cUh+TKatRcXsZvDOjV06kQqzGt1oP8OJkGaCDqXPDzOTW7PvBA2ZZG76V20KiT4/MlrY/+4XixZsMnt8o8Bm9FEO1absieEzSXfSdfzx1sVNMy6JTVHCth2PcHoUzgcT6+xoTa8TqHtqqr3cirS2RajameX6WI32/inlWqNdKnSI9B
 tiECV2me
 7AEgf7r6+JtsAtfkhWy7+TFD+TsSx7PEyssixRgzmc3zk6eOmDMig0uzCIUnMIKahE5psvQFT3rfHywu6b+jXFKj9fWo8wjPIquUp2W1uh6GDz+oaU00YAJbkX77Q4lYIZD2v0BPcUDus5MHafulBEqQ+T4/sHxS5t2refxVpWGFOVL2i0vj+gccY/ySnDlU211qLhhhjdDnmmuh2GV7SBoIfd7hWClqrp/VhrPJwjGNhijNFhfW7lKJpXIbwGkXPWqImJBGIx6ql+OQX/Qe7lSV3oJMhxItpHM3tN9OuZMLfnH2HTIJ6hPOEkf/OF8I3KwH+9i1m3GX8ZJMnqX+N0OhoJgtyt0IPYhCkcZvcXNUO5m0Dl0ycfsSrmP6j5EFTMKBLJplt6pCvfgoair+opnjRwAGzYkovLy/T1NTMpnnQ9q7cYdh5YGHiYJWqNXEz3DGaeeaBp8Iv/knHKfYi63a6Tkl/RlZI5fOFwfbzOF17piTaX4kGKixBFM4IfEoZ64Kev1yuZ4c+3kweMBLM+STEY7taFzw139dVbG5eOCj76ylesZMofxITsT1b8wjW6ZQ82GI1QtErOVcOxRN0v9ZT4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm: hugetlb: empty nodemask passed in alloc_buddy_hugetlb_folio()
- [Medium] mm: hugetlb: MPOL_BIND violation in alloc_buddy_hugetlb_folio() =
on cpuset race
--

commit 6e27dfcfc4f6238bea6b6e8639c15188d8d94295
Author: Qi Zheng <qi.zheng@linux.dev>

mm: hugetlb: fix cpuset violations in gigantic surplus allocations

This commit intersects the allocation nodemask in alloc_buddy_hugetlb_folio=
()
with cpuset_current_mems_allowed so gigantic surplus hugepage allocations do
not allocate from nodes outside the current task's cpuset. It also retries
failed allocations if cpuset_current_mems_allowed changes during the attemp=
t.

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6fba92b0f6749..09b64f7c11dd2 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2181,22 +2181,33 @@ struct folio *alloc_buddy_hugetlb_folio(struct hs=
tate *h,
>  		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
>  {
>  	struct folio *folio =3D NULL;
> -	nodemask_t *nodemask =3D mpoli->nodemask;
> +	nodemask_t alloc_nodemask;
> +	unsigned int cpuset_mems_cookie;
> +
> +retry:
> +	cpuset_mems_cookie =3D read_mems_allowed_begin();
> +	alloc_nodemask =3D cpuset_current_mems_allowed;
> +	if (mpoli->mode =3D=3D MPOL_BIND && mpoli->nodemask &&
> +	    nodes_intersects(*mpoli->nodemask, alloc_nodemask))
> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
> =20
>  	if (mpoli->mode =3D=3D MPOL_PREFERRED_MANY) {
>  		gfp_t gfp =3D gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> =20
> +		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
>  		folio =3D alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
> -						    nodemask);
> +						    &alloc_nodemask);

[Severity: Medium]
What happens here when an MPOL_PREFERRED_MANY policy's nodemask is disjoint
from cpuset_current_mems_allowed (for example, after moving a task or
non-leader thread to a cpuset on different NUMA nodes, since
mpol_rebind_preferred() does not remap pol->nodes)?

Unlike the MPOL_BIND branch above, this path does not check whether the
intersection is non-empty before calling alloc_surplus_hugetlb_folio() with
&alloc_nodemask. When alloc_nodemask is empty:

1. For gigantic hugepages, alloc_surplus_hugetlb_folio() performs a wasted
   pass through CMA and alloc_contig_frozen_pages() with an empty nodemask.

2. For non-gigantic hugepages, alloc_surplus_hugetlb_folio() ->
   alloc_fresh_hugetlb_folio() -> only_alloc_fresh_hugetlb_folio() ->
   alloc_buddy_frozen_folio() -> __alloc_frozen_pages_noprof() fails the fa=
st
   path and enters __alloc_pages_slowpath(). In check_retry_cpuset():

   mm/page_alloc.c:check_retry_cpuset() {
   	if (cpusets_enabled() && ac->nodemask &&
   			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
   		ac->nodemask =3D NULL;
   		return true;
   	}
   }

   Because cpuset_nodemask_valid_mems_allowed() returns false for an empty
   nodemask, check_retry_cpuset() treats it as a raced MPOL_BIND nodemask,
   resets ac->nodemask to NULL, and restarts __alloc_pages_slowpath() with
   __GFP_DIRECT_RECLAIM masked off. That wakes kswapd across all nodes via
   wake_all_kswapds() with ac->nodemask =3D=3D NULL, attempts an allocation=
 on
   non-preferred fallback cpuset nodes at ALLOC_WMARK_MIN before the normal
   fallback pass at ALLOC_WMARK_LOW with reclaim/compaction runs, and
   increments HTLB_BUDDY_PGALLOC_FAIL in alloc_buddy_frozen_folio() if that
   first pass fails.

Should the first-pass alloc_surplus_hugetlb_folio() call be guarded by
if (nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask)) so that an
empty intersection skips straight to the cpuset fallback pass?

> =20
> -		/* Fallback to all nodes if page=3D=3DNULL */
> -		nodemask =3D NULL;
> +		/* Fallback to all nodes allowed by the current cpuset */
> +		alloc_nodemask =3D cpuset_current_mems_allowed;
>  	}
> =20
> -	if (!folio) {
> +	if (!folio)
>  		folio =3D alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
> -						    nodemask);
> -	}
> +						    &alloc_nodemask);
> +
> +	if (!folio && unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
> +		goto retry;

[Severity: Medium]
Can pre-intersecting alloc_nodemask with cpuset_current_mems_allowed cause
non-gigantic surplus allocations to violate MPOL_BIND or use a stale nodema=
sk
when cpuset_current_mems_allowed changes concurrently?

alloc_buddy_hugetlb_folio() is used for both gigantic and non-gigantic
surplus hugepage allocations. For non-gigantic hugepages,
alloc_surplus_hugetlb_folio() calls into __alloc_frozen_pages_noprof() ->
__alloc_pages_slowpath() -> check_retry_cpuset(), which expects ac->nodemask
to be the raw policy nodemask rather than a nodemask pre-intersected with an
earlier snapshot of cpuset_current_mems_allowed:

1. Suppose a VMA MPOL_BIND policy has *mpoli->nodemask =3D {0, 2} and
   current->mems_allowed is initially {0}, so alloc_nodemask is computed as
   {0}. If current->mems_allowed changes to {1, 2} while the thread enters
   __alloc_pages_slowpath(), check_retry_cpuset() sees that ac->nodemask ({=
0})
   no longer intersects current->mems_allowed ({1, 2}), even though the raw
   MPOL_BIND mask ({0, 2}) still intersects {1, 2} on node 2.
   check_retry_cpuset() then clears ac->nodemask =3D NULL and restarts the
   slowpath, which can allocate a folio on node 1 (allowed by the new cpuset
   {1, 2}, but forbidden by MPOL_BIND {0, 2}). Because folio is non-NULL,
   !folio && unlikely(read_mems_allowed_retry(cpuset_mems_cookie)) does not
   trigger a retry, and the folio from node 1 is returned.

2. In the MPOL_BIND check at the top of alloc_buddy_hugetlb_folio():

   	if (mpoli->mode =3D=3D MPOL_BIND && mpoli->nodemask &&
   	    nodes_intersects(*mpoli->nodemask, alloc_nodemask))
   		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);

   *mpoli->nodemask is read twice. If mpoli->nodemask points to a task
   mempolicy (current->mempolicy->nodes), a concurrent
   cpuset_change_task_nodemask() -> mpol_rebind_task() ->
   mpol_rebind_nodemask() can update pol->nodes between nodes_intersects()
   and nodes_and(), leaving alloc_nodemask empty.

3. For MPOL_DEFAULT (where nodemask was previously NULL), passing
   &alloc_nodemask (for example {0, 1}) into __alloc_frozen_pages_noprof()
   means that if current->mems_allowed changes to {1, 2} during
   __alloc_pages_slowpath(), check_retry_cpuset() sees a non-empty
   intersection on node 1 and loops in the slowpath with ac->nodemask still
   restricted to {0, 1}, preventing slowpath retries from considering newly
   allowed node 2.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793850539.gi=
t.zhengqi.arch@bytedance.com?part=3D4

