Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6E6E606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 02:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cmViAYd5
Received: by kanga.kvack.org (Postfix)
	id CAA426B05B0; Wed,  4 Nov 2026 21:39:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AEF6B05B1; Wed,  4 Nov 2026 21:39:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B230A6B05B2; Wed,  4 Nov 2026 21:39:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86B8B6B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 21:39:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 44E4A1408CC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:38:59 +0000 (UTC)
X-FDA: 85399507998.04.2FA3A85
Received: from mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 30A0340002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 02:38:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cmViAYd5;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793846337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3l03Jx6ES0n3NXuG9mumrJ8xYBQNgZrk193Mf6WF3Q0=;
	b=fihMQom0TdfrAMbBGELO5VRUV59TdJWUiENCNz1fLW2OUHLa93/mpxoJ8kbAEV4coyV94S
	azi5Eu9Fj2bygko3g8o80SsEaWvR9F7GeAuRIRrpVNR8zN9qNRjS5qxnVtrM39ZlB1SCqP
	s4oVvUqCDubcdAadyxyQdjKQupIVyNE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793846337;
	b=DxLUZkQXES2bZADYmgXSYItI9SkC9+WDudst1W7EYgcfrP9WG4izY6Les8hZk7L2+VKMKt
	bXOJCvTRQlDLOyMzP8LVevw12Rr6KnDerLaVG/9Y8wrZzhllO4kB3d7WzNbQQrVqwRTGL7
	cRr3ptNWHKhh3ua6tRPpNRSPo/q0z94=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cmViAYd5;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=v45CDog2JRm1weUQFkof7B9qIVd7KYdFBRCOVPz0R4M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793846334; v=1; x=1794451134;
 b=cmViAYd5fxtad0Psx17cMQM6ajV0lFYY/g5Cq1u1OYYEh52bUkynG+0Ob+2EDMDgjLKz7iY2
 OvHu6645ritYLx9Rnoq3XM46f23r9t831zBugtWnJK4z8YdOezBW5kL+otkGYWGof2qiaMX+8AG
 xqmFe7BnoAa3p1rLgcIkbu3o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2a7c54c2f09cafbe;
	Thu, 05 Nov 2026 02:38:54 +0000
X-Mizu-Trace-ID: 2a7c54c2f09cafbe
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm/hugetlb: do not invoke the OOM killer when optimizing
 vmemmap
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261104133938.50974-1-zhangyili01@baidu.com>
Date: Thu, 5 Nov 2026 10:38:37 +0800
Cc: osalvador@suse.de,
 akpm@linux-foundation.org,
 David Hildenbrand <david@kernel.org>,
 kas@kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <6773CA2D-35EF-441D-A736-BBEA4A07B074@linux.dev>
References: <20261104133938.50974-1-zhangyili01@baidu.com>
To: Yili Zhang <zhangyili01@baidu.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 30A0340002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: a18x85xzgihx8u9n3oigixhem3iwe5zz
X-Rspam-User: 
X-HE-Tag: 1793846336-546159
X-HE-Meta: U2FsdGVkX1+zSszsaLIfVhvk6xvSgDPNwek2LoMMHKowwwnUCGYPRayaPqdkg9Z1UYqKT7nW7g7+5myPB/NOIzf6wdK7atQvXXB93/K2Oh0x7nQej/ht+DfJsk3ATJFM2ly0fuR53HMftxYW+7L5bPuJ6DVnJOx883lKcGCkY70LRzDvF0VTiFU3HP0oR0BRchv0JYuDfCtaQAAz+HhyrtxWl2DFdDYGTnrKiObN9167Uqlm8HNR/0j738ujuFUVm1EzIrT23ezahVffbhn5HVpcnREk3Mmwh/I+NgYX72wxNUw1qsfKpyctU8pHl6NRaohDu0ycR2u1Vbo0cdvz1bxggZ+MbJzzsz+yEzF24CuDtkK3tBxp603ZZg+z/U4L9CfQhEiSKfXdVmpnh6fXT+NhbPE8ROnm4J5UDGOAqyHvujhP/ur+4MJhh8fSE0DXECZJKdo8J9MgsjwifTYApLbz5foqBr3ylhtaFsa1dkXF3xrm4kouyMI5rUUV3SQ2uNqqNRjwgQMYOJ7dHcFZWFcbfiLtYDYthmCq+SDKw6xfvPdIrxoyL4uP7bkDfD4DdP/j47pcgrJ2sshP4ktzyTIbkaTSh1pxsX6f4bAzIYD2BiSmX99JbKvdS32Uhllgz8c6AYODCP9MdBFwpfS7B3qid52uMSOqmEYRh72jfogZRf5vOWaxH33rmhG7lVpfugFBJUocCQafW6OqiTccsvPkmW9LxI+iTj1Dim17GOFRlCpS6tQyC/5NhwBZXIeeyXMlsT7dth7UWdgK1C3KKKc+/85tvcvowYghFVDTmEXgeCs4usu7XHPauAIwaLVgLufs11WUebClIO7qPey4A1zrJsgfxXcMD5FpphoRFxY/ioM5DkKcAK/zVM/7tnYk1qrp4zIp2tHIvFkjuzODbUylveYBIHu4dMzbESW+BHtmIYpFX1CYTgYLSoyfTX7CGxngoL3iBflXfTMfTSV
 kYmTBv2L
 5XhBBlTzy9YKqgQr3tkyeSR8Tm7p6/YssBmhvyrEpZVvr+yIm2c3UA5G+tcSAfho4aj0/NvTXDbVR2P/FGkhhAMaN9OmrW09ZFLioSW4B1CF3GxjfoUndIDrKplXHGlsmO3y25bluRVS/Kaw3SYJS50TgqAhZS9ygVYduGyYMhe6QSe9/oVXfBa8V5OY/caG23NhAkCbiRNLm9HXmkXXo9cMezwscyDk4JUO5iPwaJ5t7ULFnqR2CJCp7blQ5nf1rt89ihhKLK52+bez9zaHNLRVFyC1MUhsulbDqe8JjLMYUgh+fj9IEd36/2t/fAe7V8WRHBDS9zV4XVtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 4, 2026, at 21:39, Yili Zhang <zhangyili01@baidu.com> wrote:
>=20
> Boot-time hugepage allocation is designed to drain all free memory and
> let the vmemmap optimization reclaim vmemmap pages, so that more
> hugepages can be allocated afterwards:
> hugetlb_pages_alloc_boot_node() flushes the folios accumulated so far
> once si_mem_available() drops to zero, and hugetlb_pages_alloc_boot()
> keeps retrying as long as progress is being made.  The allocation is
> parallelized with padata and runs on many threads at once.
>=20
> The page that will back the new head struct page of a folio being
> optimized is allocated with a bare GFP_KERNEL mask in
> __hugetlb_vmemmap_optimize_folio():
>=20
> vmemmap_head =3D alloc_pages_node(nid, GFP_KERNEL, 0);
>=20
> Once the workers have consumed all free memory, this allocation enters
> the OOM path.  During boot-time allocation, at the do_one_initcall()
> stage, there are no user processes yet, so out_of_memory() finds
> nothing to kill and panics:
>=20
>  Out of memory and no killable processes...
>  Kernel panic - not syncing: System is deadlocked on memory
>  CPU: 74 UID: 0 PID: 1 Comm: swapper/0
>  Call Trace:
>    vpanic+0x32f/0x360
>    panic+0x57/0x60
>    out_of_memory+0x581/0x590
>    __alloc_pages_slowpath.constprop.115+0x97d/0xed0
>    __alloc_frozen_pages_noprof+0x303/0x330
>    __alloc_pages_noprof+0xa/0x20
>    __hugetlb_vmemmap_optimize_folio+0xa3/0x210
>    __hugetlb_vmemmap_optimize_folios+0x190/0x230
>    prep_and_add_allocated_folios+0x16/0x90
>    hugetlb_pages_alloc_boot_node+0x152/0x180
>    padata_mt_helper+0x5b/0xb0
>    padata_do_multithreaded+0x294/0x3a0
>    hugetlb_hstate_alloc_pages+0x2e1/0x3b0
>    hugetlb_init+0x3b5/0x640
>    do_one_initcall+0x49/0x200
>=20
> Optimizing the vmemmap is best-effort by design: on allocation =
failure,
> __hugetlb_vmemmap_optimize_folios() frees the vmemmap pages reclaimed
> from the folios it has processed so far and retries once, and folios
> that still cannot be optimized are put into the pool unoptimized by
> prep_and_add_allocated_folios().  The worst outcome of a failure is a
> higher vmemmap overhead and, as a consequence, fewer hugepages being
> allocated (along with a warning) - waking up the OOM killer is never
> the right thing to do here.  Note that the same code also runs for
> runtime hugepage allocations, where an OOM invocation may kill an
> unrelated process instead of failing the optimization gracefully.
>=20
> The head page is a vmemmap page, and every other vmemmap page
> allocation involved is prepared to fail gracefully:
> vmemmap_alloc_block() - which vmemmap_shared_tail_page() also uses
> to allocate the shared tail vmemmap pages - uses
> GFP_KERNEL|__GFP_RETRY_MAYFAIL|__GFP_NOWARN, and
> alloc_vmemmap_page_list() uses GFP_KERNEL|__GFP_RETRY_MAYFAIL.
>=20
> Align it with the other vmemmap page allocations by using the same =
mask
> that vmemmap_alloc_block() uses for vmemmap pages, so that a failure
> returns -ENOMEM to the caller instead of going through the OOM path.
>=20
> This was observed on a 384-CPU machine with ~1.5TiB of RAM booting
> with a hugepages=3D reservation close to the total memory size and
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON=3Dy, where the boot
> panicked intermittently, depending on how the parallel allocation
> workers interleaved.

A really detailed analysis, but also lengthy (I think it's generated =
from
AI, It really should be trimmed before sending because the issue is very
obvious and easy to understand).

>=20
> Fixes: c0b495b91a47b ("mm/hugetlb: refactor code around vmemmap_walk")
> Signed-off-by: Yili Zhang <zhangyili01@baidu.com>
> ---
> mm/hugetlb_vmemmap.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 0057fa2a16a8..3a759b930ed9 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -499,6 +499,7 @@ static int __hugetlb_vmemmap_optimize_folio(const =
struct hstate *h,
> {
> 	unsigned long vmemmap_start, vmemmap_end;
> 	struct page *vmemmap_head, *vmemmap_tail;
> +	gfp_t gfp_mask =3D GFP_KERNEL | __GFP_NOWARN | =
__GFP_RETRY_MAYFAIL;

Thanks for fixing, but I realized that I've already fix it here [1], and =
I didn't
realize it's a real production issue. If you don't mind, I could add =
your Reported-by,
and make it a very small fix patch so that it can be backported more =
easily.

[1] =
https://lore.kernel.org/all/20261104023510.260766-5-songmuchun@bytedance.c=
om/

Thanks,
Muchun

> 	int nid, ret =3D 0;
>=20
> 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
> @@ -525,7 +526,7 @@ static int __hugetlb_vmemmap_optimize_folio(const =
struct hstate *h,
> */
> 	folio_set_hugetlb_vmemmap_optimized(folio);
>=20
> -	vmemmap_head =3D alloc_pages_node(nid, GFP_KERNEL, 0);
> +	vmemmap_head =3D alloc_pages_node(nid, gfp_mask, 0);
> 	if (!vmemmap_head) {
> 		ret =3D -ENOMEM;
> 		goto out;
> --=20
> 2.27.0
>=20


