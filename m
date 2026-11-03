Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAA14606A336
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g2fbHA7I
Received: by kanga.kvack.org (Postfix)
	id CBE526B05BF; Tue,  3 Nov 2026 03:47:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C707D6B05C6; Tue,  3 Nov 2026 03:47:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B606C6B05BF; Tue,  3 Nov 2026 03:47:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 834DB6B05C5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:47:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B391340375
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:47:15 +0000 (UTC)
X-FDA: 85393178430.27.D8323E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 29F341A0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:47:13 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2fbHA7I;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695634;
	b=RSuhErO+irEqF80Le7eTGr0EOqShJO1FoODThqMyGDuf2CL54gAYi+n8URyQMlI9QKLWeE
	Z8ia/MBTVJwnQxF6MyihN7e+m9FSW6QiIpyI2WmP+h4iomaCW5pLULIn2MdWdFCOJMJ51z
	h6jrr37p4fwH6KRTNI8eL2xOgzH5bCI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=g2fbHA7I;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695634;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7svOX2+4cz3PeA+PJRZ/vKGeL98v6w/jntdXi/ANXak=;
	b=SOI6XssIUaTqeiGm9ol+sTF6BIU4FfEqENT30gpH8FW85KKY5GdkgQiTMIom+zJjdIjiAr
	2zJTr5q7rP7L4tqDRBSW/Pd6/WoSMZI/rJ786qJmYYNNdx15wk7HkWaa5xHxJlnBZp0WDl
	/BeIMO/o+dgkS6eLbgvq+u5balR+vYs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ED6160008;
	Tue,  3 Nov 2026 08:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF34B1F000C1;
	Tue,  3 Nov 2026 08:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793695633;
	bh=7svOX2+4cz3PeA+PJRZ/vKGeL98v6w/jntdXi/ANXak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g2fbHA7Izsee1eiQbdG7Hw4ljEb6KPtd2N/u6Md2HSySFLu1uRLivjzgUNvstcHrj
	 V8C6210N264iXM/DmJhKbpPyn55ibAXxomFG9zj5esYmYxhqaqfZHZ6wP809f+kWyN
	 oogqj3BVPFZJ+98uH/SGi5L4ITTh+HcCiqyQ3EzjHocrwncPBlUU8TVGoKUz9nP2zx
	 enKESSKxtMlv+jaCGNFs3ADQv1XjOb0YXuPV5fRX/FZHu7vBINbLCPHggQ9xGwjHib
	 XwNZ3pdq8zvDIxAcBSIjTXirYQPYGJIITBAtNL3ioAdDGC8fu4g2QMEKBKc+sOQsLu
	 nemeaqQRT4Jyg==
Message-ID: <sashiko-outbox-194875@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/4] mm: hugetlb: skip CMA when direct reclaim is
 disallowed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Qi Zheng" <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, azpijr@gmail.com
Cc: linux-mm@kvack.org, "Qi Zheng" <zhengqi.arch@bytedance.com>
In-Reply-To: <325d33655f29a2799a0859c788c48625feeb85f1.1793692578.git.zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
 <325d33655f29a2799a0859c788c48625feeb85f1.1793692578.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:47:12 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 29F341A0008
X-Stat-Signature: pzqj4carw4z8t4wzjwp45eb7uksijajq
X-Rspam-User: 
X-HE-Tag: 1793695633-760858
X-HE-Meta: U2FsdGVkX1+eOr480I5XVpnpP+QaaPKc6FaLDbK9hfaEieZ3pDLxQwfe5WQuhbnoiXNJYqfEyHxnadrfKlJ4aK1CrnlPgfV9pnCZb2jnCE21lA7a8teYL3VC+jZPlCMsmrg3WA0jCU7vKP+SsRcdGn2bWHgSFGiWYV2CTQkY3mlk3WOCMY/thJ4J6Ip/6SaCHqhnfa6RFRPciqmh8FinvFUYHG+lz+MoHLCzXETSQKMJx+/sZRyvByt5aTUlBzNeC4iyYay/5sHDkDxj0Ov1zA7J7etOHTG7UXcTF//PHR5NIM6ItY6Q2KDw0Y3oQtc6VgH3FlUAMaKCQeyetySoqJtMJ5J8iWIEp5ZLx7TpG4v5mbwuEPJJz1jIFqX/wzVMQqWGILIPH+S/m+xW4RHC9zi6Jm1FipzgYUIknhhR5DSZwH/nDTi0hk0gkpE1OqOfgccXZ3YAC2KBrvTtUgGbzH3ecuGN/xlUaKtOxjfoJr+0+pgPA2XblAf7FlYO+RxEXH6wIgI5Z0Qwp3wvkdATICGqZGhmspOEb8fqNvjk4RcXHqJ4C7FWnhRIrzgERHDWE6FnMeTYp+cGhVnDgQuyCttyH+qe3NCvVhXH05zhCHoFDbSUZC2VnkdlMCE/jts3Isq9JWXf9Lgc5jO+hipNyOknscGESP3tSO7858jKsFgLQGQE+oibI1L5lpec0yaYUgjdXDBMKzKkbfNorLD8hkpZWJmMwhZ/n8WGclmkFx0x5Jx4L41lLrt9IjYuSSM5dnLvsFhrSZ6MtVXzFzGYKsucSPp5zSxH6ib8giu5Ht6A24UK7iuAlTTCbRTuHR7P5qTGZecqYLRKdrC+FB8E9t8awNjyrkrfUlA5MkQMFrUP3UoXfPnm95iGe9aUuInjuJlj7b3AKeVFN7Wch68NBMg4UIDzeBWR/OleqKIfHTZ3IQp8XBjL+WGx8/RK0UZx/Wxb8keuxFmn3LZQxeB
 TYvSaUuP
 eNK0msjA4f+eYnwBTti8wOUFlaasiiwPPjr71a2wRmCXYPqeV5wyYTjlsqsk83em4DCeg+D+4I5EZ6781wjVT/z+SFmZy1f2MZ/bwfDkgcZDMbu4TjEGllUS3nOBIYnnJCHLr+k/HdoXtd1HJiSSeho6AZGkpLcIvBep6z8OqFXZhcBMirFb1mXVMzaiR9e7kN8mwB7qgH9vKHnweTJvZkIbL6dCr20+WUBDwPqKwi+PVl0rUhtEXLbzERFObXoM2X40I228NLMbvk+E8rH7jcsmAtJeP6dwbo141SEn4HL1pIlHBI1KlFtHd6Kuapg7KIULTQh4pQU6+0bCK0PjKAcaWgZmDtf7I9jMdDH0hHgkko/TEcchkemSBukIGGOugb1lJwudfke2WgqZFmem+/8g/s0nElZJM76rblmLAqIOd7ltE6ZbVZJgWkxHgAhErRT60v7pIDoWXHA7XCFLJFeq72R8K6Cx03QX804I3Ie++xDw4OFwJ2dF1zzYiClK5qzHbZsP9RKPEVVZc75wzBAKReoawpApJDas1T/yGJWXPYxeOHGffflYEUoOopI25Gb3hm32WFY3m3sxFLgW4bIrDEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm: hugetlb: hugetlb_cma_alloc_frozen_folio() breaks MPOL_PREFER=
RED_MANY
--

commit c96d52d66d643a77abaa96a17e392b7ab0f36ccd
Author: Qi Zheng <qi.zheng@linux.dev>

mm: hugetlb: skip CMA when direct reclaim is disallowed

This commit updates hugetlb_cma_alloc_frozen_folio() to return NULL when
gfpflags_allow_blocking(gfp_mask) is false, avoiding direct reclaim inside
cma_alloc_frozen_compound() when __GFP_DIRECT_RECLAIM was cleared by the
caller.

> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index dde1c866406fb..90f8d718a1f16 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -59,7 +59,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order,=
 gfp_t gfp_mask,
>  	const nodemask_t *nmask;
>  	unsigned int cpuset_mems_cookie;
> =20
> -	if (!hugetlb_cma_size)
> +	if (!hugetlb_cma_size || !gfpflags_allow_blocking(gfp_mask))
>  		return NULL;

[Severity: Medium]
Does returning NULL from hugetlb_cma_alloc_frozen_folio() whenever
!gfpflags_allow_blocking(gfp_mask) break MPOL_PREFERRED_MANY for gigantic
surplus HugeTLB allocations?

In mm/hugetlb.c, alloc_buddy_hugetlb_folio() implements MPOL_PREFERRED_MANY
as a two-pass allocation:

mm/hugetlb.c:alloc_buddy_hugetlb_folio() {
	if (mpoli->mode =3D=3D MPOL_PREFERRED_MANY) {
		gfp_t gfp =3D gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);

		folio =3D alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
						    nodemask);

		/* Fallback to all nodes if page=3D=3DNULL */
		nodemask =3D NULL;
	}

	if (!folio) {
		folio =3D alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
						    nodemask);
	}
}

This reaches hugetlb_cma_alloc_frozen_folio() via:

  alloc_buddy_hugetlb_folio()
    -> alloc_surplus_hugetlb_folio()
      -> alloc_fresh_hugetlb_folio()
        -> only_alloc_fresh_hugetlb_folio()
          -> alloc_gigantic_frozen_folio()
            -> hugetlb_cma_alloc_frozen_folio()

On the first pass, __GFP_DIRECT_RECLAIM is cleared while nodemask points to
the preferred nodes (pol->nodes), and on the second pass nodemask is cleared
to NULL. Because hugetlb_cma_alloc_frozen_folio() now returns NULL on the
first pass, it never sees the MPOL_PREFERRED_MANY nodemask.

In mm/hugetlb.c:alloc_gigantic_frozen_folio():

	folio =3D hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
	if (folio)
		return folio;

	if (hugetlb_cma_exclusive_alloc())
		return NULL;

	folio =3D (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
							  nid, nodemask);

When hugetlb_cma_exclusive_alloc() is false, returning NULL from
hugetlb_cma_alloc_frozen_folio() on the first pass falls through to
alloc_contig_frozen_pages() on the preferred nodes, bypassing the dedicated
hugetlb_cma pool on the preferred nodes in favor of non-CMA memory.

When hugetlb_cma_exclusive_alloc() is true (or when non-CMA allocation fails
on the preferred nodes), the first pass returns NULL and the second pass
invokes hugetlb_cma_alloc_frozen_folio() with nodemask set to NULL. Since
mm/mempolicy.c:policy_nodemask() leaves *nid as numa_node_id() when
pol->home_node is NUMA_NO_NODE:

mm/mempolicy.c:policy_nodemask() {
	case MPOL_PREFERRED_MANY:
		nodemask =3D &pol->nodes;
		if (pol->home_node !=3D NUMA_NO_NODE)
			*nid =3D pol->home_node;
		break;
}

hugetlb_cma_alloc_frozen_folio() on the second pass tries
hugetlb_cma[numa_node_id()] and then iterates cpuset_current_mems_allowed
from node 0, allocating from non-preferred CMA nodes even when preferred
nodes in pol->nodes have free CMA pages.

Prior to commit 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()"),
cma_alloc_folio() forwarded gfp_mask down to alloc_contig_frozen_range(),
where __alloc_contig_verify_gfp_mask() preserved the cleared
__GFP_DIRECT_RECLAIM bit so CMA on the preferred nodemask was tried on the
first pass without entering direct reclaim. Would forwarding gfp_mask to
cma_alloc_frozen_compound() (in mm/cma.c) preserve both the non-reclaiming
first pass and the MPOL_PREFERRED_MANY nodemask?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793692578.gi=
t.zhengqi.arch@bytedance.com?part=3D3

