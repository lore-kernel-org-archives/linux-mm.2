Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428FBCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36FF46B00D8; Mon, 19 Oct 2026 08:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 320F46B00DC; Mon, 19 Oct 2026 08:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25DAE6B00DD; Mon, 19 Oct 2026 08:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 050346B00D8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:32:33 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8B14BC04DC
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:32:33 +0000 (UTC)
X-FDA: 85339314186.06.E7FDC52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id DEB2C8000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:32:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9MpVQTY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792413151;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AACT0ekiVx44u4Qo6s5WCyf5aAq57KHnjKhe0+ZImQo=;
	b=ODhuRB46QUIJ0ZOFl9ZyQay9BXxtsqiBAOl30/20N63WvjyCPUBuSiTuiSqlNgzNr9t8NN
	xJZ6qLpp4ResaVYXE9CKZsRzaQrv38gY9QbUS5gBIUdcEPnoBobrBE/hmO7VWxMSqy4MqO
	PnNgxP8YaNyi0xaSIimLECeZGybwETM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792413151;
	b=ijvIQHyJLUqEv2hPaKPT7ibeO3DZrYChD5vaQql9SuAuC8vIqhCFI0Ru5on9nz2G4gmssd
	ndOXTzSPbNwpzZiVX90WNfD1ga3OefAQDR6fwCh7UkLjThYiVwOgw1fYcXhPkDWN2Y0GrR
	E/MnLU/6wHDkdUxr3nI9j+F/uCRC6dY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R9MpVQTY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 649BD60136;
	Mon, 19 Oct 2026 12:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890271F000C4;
	Mon, 19 Oct 2026 12:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792413151;
	bh=AACT0ekiVx44u4Qo6s5WCyf5aAq57KHnjKhe0+ZImQo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R9MpVQTYjnC4gxAvJ+8c6M36sXTPKfgU0tSJPt3iDVFHHHCyBd07oUs17uz+j71dR
	 qUuAi+Ccz1VeWc0H/zeILeaDe/zkzpGfYZW4Ed+T70Q/858o0AgdB7gPF1mQc2uotP
	 Z8ikw6UpUuopBHTJCbOQYSzCQoWULKX0MCYysNpB9aGQuSZqMCakv14tLEPRGKyC1I
	 hRTicEBU5jo19CMnOKO0LRFaHEewlG3OSJD+JWM4HW8fM/b+hr02Qn7H04rs4pa44U
	 fvZQXi/05ZWyNJK+t71fMTIPi6UWQJ5jSZ/0l9t5IwfzY4TtyEOPimStzEzEIs5lGp
	 5xGaa6hcw+8cw==
Message-ID: <sashiko-outbox-177071@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/ksm: keep soft-dirty and uffd-wp when merging a page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Samarth Narang" <samarth.colleges@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>
Cc: "Xu Xin" <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Peter
 Xu" <peterx@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261018122957.526467-1-samarth.colleges@gmail.com>
References: <20261018122957.526467-1-samarth.colleges@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 12:32:30 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DEB2C8000B
X-Stat-Signature: 7nq5xzi1k3fcpxhzzwjp85u76cy9e1rp
X-Rspam-User: 
X-HE-Tag: 1792413151-391759
X-HE-Meta: U2FsdGVkX1/zv3qtJo++xPTU2wu/YZqBxvS4R/Xjcvitxprc5w8fSLkfCjEwomaA6q000KtnqpfDpz5t2jGc9Gfw4Z9mDYj6P+JKvVtAGTMIr32+JCpCHk/nV4bk1xiRtWa75eGMzy3cNg4xtWqy4f+v7Tvb1O7vjsShz1Yx+1x9no8+eDmuugKKfRHpvSmLpuWSu3aNMS8oNpdqZNWNbXoGPWhq8ODJB0YhTh26l5G2DdB2sLiITaFMtanNcD/a8+OzRSdu22BT8ed5tNRTzbAgeQMUM5JWu1GEnWvCJQw4QORdlx0DwNBim4h66z23fNTQBFlzBoOod7C+VT8HuuaK9KfjXCHm8CnMEnW24qRr7lJoGbUoLGRnr6uTEZnEUlUqHqlt5SkyoQO5rQ4gExrS/25JNAmJlwkQL0mnHRc/n44M+ZeVb1QwjOxeYwzN/YaxMpqY4gu2fBHB6YZHZpmDTkad/Z7Wg5Zmv1iCsHkReQvaXPtHAevRGinQTFGw4nqoG73LlSFEl3EkpfluTdqSQGSbXkLFL9+wOVXPMHmheT8gyzUdxu1Fet2gUbR00a6Aj/wxoa0OtXba2h0Zla0u2JFJBMk3nxBbBSsFC09nwTEWfwtTIEJx+OnFVCz4ct3fMudPDaGBlnm/404MpfURQJfYIlrardxVxAiYfUeDK9BCwKS3cLk8v8+F36p/xizJmDyXnZz0xV2RIPwZnTO+vWFf8W22hTyp2EcJMiZLprsuqKEWjMpWuJmXFLWw0i79uktKwbowYYG3EXDWqcRCOe2OtRDvmu3GVMgLjUA1JOThDT8sl7Z/iq5qyu+IgEVHfZ2Ef5Q5zMfpPTiYD1a1DJXtG7h3L6K274hXU/c9rJHkfUBCE5NoE+pXQ+0fu7kty7MDG5Hqav6AwBa5srkSG9OJrsou3sP6+0n2b0wUgGWl3q3EA4iR310zdv9i1BnxTp1ZBYOJ3UD0Jar
 CM6uy4Lz
 VJefzOKMKUjmFmJtkOcULmQZTdBmbCSUNRdvvJ2bVnK5khImpB0G5LeQ+7kBgKWAiX3FBfLmmjjpyrimdIW6nJnIEVSkMU2MxOQiFJvC/mpJiFiM+oFnuWe+Mwam+NZgQ1f5Sxi3LwyI6R7SOyUl7Vf2JOLVivirXn8nuGQSTNCC9e4a6QSpVBYd6ugzr4UHb5iU0NRD9JWaVhwCr7j/V2XMjqKFoZOK8u1xrp8RzEvlguIxkpm1E63Qup7GrpXpxsv68xCrOw8oiCaVROYdPGb/gBr5X1jIYtLdzB0DLtCN0sj05I+0sG0wKkE9l9rNOdACP3XiJl4x/yizBTaa6L6UGdmR6SLPTkZ0nmgIk/hZ6OFeOlIv4SJsK6SOK1B5B7goirNfAiE062KgYF+2Zc/TMdhKAZIlVvj7hGId85lRltNPukqkh4mFfB1/3fb5W7jXWZREWp0aX1eruW9QAttShDmPHKA+RKuZJb6KGQHMLNcXCEKhSMIoqm0n0YTN8mhM5RdLxxsJ/eurvQkYtQp+IME3IuVzoovRiO1Vq23K1eA11KJBATDPFApVAAmeMJuw4RVjFIu1JQxnU5nsGoHS9JrGLYtMbixqY36+0/5Ondmz1KG8vNI2AsU8u4B0jmgyTBG1URjoKvETJW7sG3xB/4yDm886yElyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/ksm: broken FAULT_FLAG_UNSHARE in break_ksm() on uffd-rwp KSM P=
TEs
- [Medium] mm/ksm: replace_page() spuriously sets soft-dirty on KSM zero pa=
ges
--

commit a0c91d60795a1c981863694b2d5797c97c36486f
Author: Samarth Narang <samarth.colleges@gmail.com>

mm/ksm: keep soft-dirty and uffd-wp when merging a page

This commit preserves the soft-dirty and userfaultfd bits from the
original PTE when replace_page() installs a KSM page, and restores
PAGE_NONE permissions on VM_UFFD_RWP VMAs.

> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..b0d0555aa1b57 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
[ ... ]
> @@ -1463,6 +1464,18 @@ static int replace_page(struct vm_area_struct *vma=
, struct page *page,
>  		dec_mm_counter(mm, MM_ANONPAGES);
>  	}
> =20
> +	/*
> +	 * The old PTE may carry soft-dirty and uffd-wp state that tracks writes
> +	 * to this address. Make sure to preserve these bits in the new PTE.
> +	 * On a uffd-rwp VMA, also restore PAGE_NONE.
> +	 */
> +	if (pte_soft_dirty(orig_pte))
> +		newpte =3D pte_mksoft_dirty(newpte);

[Severity: Medium]
When ksm_use_zero_pages is enabled, the zero-page branch just above in
replace_page() constructs newpte using pte_mkdirty():

mm/ksm.c:replace_page() {
	if (!is_zero_pfn(page_to_pfn(kpage))) {
		...
	} else {
		newpte =3D pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->vm_=
page_prot)));
		...
	}
}

On architectures with CONFIG_HAVE_ARCH_SOFT_DIRTY, pte_mkdirty() sets both
the hardware dirty bit and _PAGE_SOFT_DIRTY:

arch/x86/include/asm/pgtable.h:pte_mkdirty() {
	pte =3D pte_set_flags(pte, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);

	return pte_mksaveddirty(pte);
}

If pte_soft_dirty(orig_pte) is false when merging with the KSM zero page,
won't _PAGE_SOFT_DIRTY remain set on newpte unless there is an else branch
calling pte_clear_soft_dirty(newpte) (similar to remove_migration_pte() in
mm/migrate.c)?

> +	if (pte_uffd(orig_pte))
> +		newpte =3D pte_mkuffd(newpte);
> +	if (pte_uffd(orig_pte) && userfaultfd_rwp(vma))
> +		newpte =3D pte_modify(newpte, PAGE_NONE);

[Severity: High]
How does this interact with KSM unmerging via break_ksm() (called from
madvise(MADV_UNMERGEABLE), __ksm_del_vma(), break_cow(), and
unmerge_and_remove_all_rmap_items())?

When replace_page() installs a KSM page or KSM zero page with
pte_mkuffd(newpte) and PAGE_NONE on a VM_UFFD_RWP VMA, break_ksm()
subsequently tries to unshare it by calling handle_mm_fault() with
FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE (and without
FAULT_FLAG_ALLOW_RETRY):

mm/ksm.c:break_ksm() {
	do {
		ksm_page =3D walk_page_range_vma(vma, addr, end, ops, &addr);
		if (ksm_page <=3D 0)
			return ksm_page;
		ret =3D handle_mm_fault(vma, addr,
				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
				      NULL);
	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
	return (ret & VM_FAULT_OOM) ? -ENOMEM : 0;
}

However, handle_pte_fault() checks pte_protnone() and
userfaultfd_pte_rwp() before checking FAULT_FLAG_WRITE |
FAULT_FLAG_UNSHARE:

mm/memory.c:handle_pte_fault() {
	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
			return do_uffd_rwp(vmf);
		return do_numa_page(vmf);
	}
}

In synchronous RWP mode (!userfaultfd_rwp_async(vma)), do_uffd_rwp() calls
handle_userfault(vmf, VM_UFFD_RWP), which warns under CONFIG_DEBUG_VM
because FAULT_FLAG_ALLOW_RETRY is missing and returns VM_FAULT_SIGBUS.
break_ksm() then terminates its loop and returns 0 without unmerging the
KSM page (leaving KSM pages mapped after clearing VM_MERGEABLE or freeing
rmap_items).

In asynchronous RWP mode (userfaultfd_rwp_async(vma)), the first loop
iteration in break_ksm() runs do_uffd_rwp() and strips _PAGE_UFFD and
PAGE_NONE without unsharing, and the second iteration unshares the page via
do_wp_page() -> wp_page_copy() with RWP protection lost.

Also, in wp_page_copy(), the unshare path preserves pte_mkuffd(entry) on
top of vma->vm_page_prot, but does not restore PAGE_NONE when
userfaultfd_rwp(vma) is true:

mm/memory.c:wp_page_copy() {
		if (unlikely(unshare)) {
			if (pte_soft_dirty(vmf->orig_pte))
				entry =3D pte_mksoft_dirty(entry);
			if (pte_uffd(vmf->orig_pte))
				entry =3D pte_mkuffd(entry);
		}
}

Should FAULT_FLAG_UNSHARE bypass do_uffd_rwp() in handle_pte_fault() and
restore PAGE_NONE in wp_page_copy()?

> =20
>  	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
>  	/*
>  	 * No need to notify as we are replacing a read only page with another

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261018122957.5264=
67-1-samarth.colleges@gmail.com?part=3D1

