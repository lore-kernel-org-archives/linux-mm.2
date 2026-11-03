Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B56E8606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JaKHrHNu
Received: by kanga.kvack.org (Postfix)
	id 58CE76B05B7; Tue,  3 Nov 2026 14:31:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536C16B05B8; Tue,  3 Nov 2026 14:31:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474016B05B9; Tue,  3 Nov 2026 14:31:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A5376B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:31:54 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 750208054D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:54 +0000 (UTC)
X-FDA: 85394802948.09.B377668
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C98E84000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JaKHrHNu;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793734312;
	b=qPXjEtKX/pVw+rOCQmf93mNIA7Jda4SZ7ShoToY31SLweLxiQv7a/RwjFW7PuIszXYWhfI
	QRStuPCca6hm610rjhMuvhlet0C6c0oQXmoQEFZRrIJbzF1bgJO6Yx2p/Eoi6uUSikL+wP
	G6Yz/kso52VBR+nBoVTi8ANdw5I5zo4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JaKHrHNu;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LvmmTpDrXCUk/NdmM0vn3azIVToLtSYVFVymXzPmYPo=;
	b=Xr7KWzJAy0jtRKs0v/1ynUSvD53nH3J8nPEUzZ3/VzJ9CDQRGxAtkLhM1vwO8lFLGUCVAh
	+zhVPmwTF6ZFUGf3acwLHDA2Fr2+YUBJybftEhf03Q8ukWo1UUMxGIYB0X8QmV0g1XS3iL
	xHvW6YyabpWedVyVhHAQ6BtTwdabwGA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3889A60416;
	Tue,  3 Nov 2026 19:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDF61F00919;
	Tue,  3 Nov 2026 19:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734311;
	bh=LvmmTpDrXCUk/NdmM0vn3azIVToLtSYVFVymXzPmYPo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JaKHrHNuCAZSOxIpnP7Zsy/j/g+pV7aDeDXAFUCTAMTXk9j7SxIRKhO03b+PUyiGD
	 0Uf3gKPhI8eKQ7fCMxZw67UxPF7XjbX6Nd6mOV9sbBjR33ZfSPEgZubJi/IPPVbfaE
	 XkY1bJy+PDDwP3C/yV6eHPI31U7xUcEkOdeclubPZZjyfz0Ds/tzcEoI6wbpM+HGye
	 zBD0UbQA74rIHMz8QHmBQFTpD6YWH/ENT+zYPgW0vivQamAKpMX1YaSL+BvxeZ5f84
	 IXkTEVmA4pvHdq73YeFU9gfori1wXYfNSDznoU80hxcex2EPDSRirRUJeswosSQTUo
	 aQMfQWNRiCE8A==
Message-ID: <sashiko-outbox-195925@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 7/8] mm/gup: walk multiple PTEs per follow_page_pte()
 call
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rik van Riel" <riel@surriel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Yuan-Hao Hsu" <aa9736195201@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261102193026.3860700-8-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-8-riel@surriel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:31:51 +0000
X-Stat-Signature: 9ehy4txyes8x3gybn83zh3opkp96r45a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C98E84000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793734312-718477
X-HE-Meta: U2FsdGVkX19IsmTpHSQECyStxIIo5Lr85HZ3MpVfiVSY4NMSzORVbgrCiYOfCpzDw/bZt24UlzaLdX18kousOorzjJg0C5Un+ZFsYB8bbZYdp8Ziy/4bK/z52uv3wv9AsOqr192q3I9xd3FIp0S/vsyvMly4/8Kh6Tei7Mh13ghbGi3Vn9Wjt5J+/l2Dmxftd8sglAHlbr4lpnWmtjFb0wh1Ho3LZJFX6zbvG0S2Hq1O3W6awPK2QLyTzPQvQIeBnAggm9fwFhEqKxhbjKNZmYJivkP5y8/U0BG5dhUEBpf1SIcRJaFfnMjg/VHun0xv7JCV5lGLuKCYQWYtV79vsvUti0oAYVKu45g/omOlKTEQbQS7K41biiEg7GczK9KX5rXerlbK7+vwq/fuIscPEkl58I0rr+s+1boVpSTvznEiF0d4cy+jQBQK02JtwyFGTlVnwY3oT9I0UNGY/Erukbsf0D6RquuDFHkL9htA0DWmOqBYURZC+B6lFPE97qphejg/LX3BTwnAgY6+TA9K6aPIg/vPiSL0QpnTk79NPXxExRr8QKFyegCeGd6ZiGHZe4/Pjb/XxRSdyEz7ZPuPUrStG4l4OVwciQAUaBjMcBlEW0frbd4k4RrqFpE7U5EIyzBC8B04HQx5Zj+iePA9ZDan3oDlxq2gA1/TDIgA5aH9Z820N+Yz8udCtFk0wxqzuzh7ZmZ0lq1MGItyANDYnEli72aYqCRxI0h/K2boGOLLHan66hcMrqMuHiMKkbtq15aRHz6bNVWIOGHK16wIh5cGcTzJrGO8CyErRCbAEmftu3MWM0vcm79ee5bMyZqD+p7u1xA4yPtVXaZDdEGoG4NZ0lzfQTXwP6/PlD7iJ9N+O2U/R1qvBCgP8cAE0tfiCa/f8+uUzD9ioWGFG4I+gjlEzoymtLXxagQUDyO5YEFWs3jmfKWdOcrSBTWpah5so30XYqujCTVjVOD2Y6D
 a5LYj7+K
 eUsYGg3IwBTBBZ9mMV4kko0qBo/F517Zsicj6nJLDRGq39R9GCp/KWzQGdGV3onw29NCquIeHo2XOrR1OoqLfvE+T+1PbQ1G+E3++DYezVpLxchQIm2EM7W0cWa6nIxzrWmz9oDZ0eE3WVnDqt5rENboH7gYmd15C2ITDmW8NXUSQpnHP2WssoJHGQ2A2HX67K66/EZiM6l/eKu994n3t/zWB2ZsxAZLLjoLx91yNpTpqqCZIxDYA3Fe/mb13W7pjIPtibs1Bx8Ba/ZbnZ1PvauZX05Ju1plARUVgFzEsQThMv2mhG4Cvjc2yoM7JsUPvNNug7pWCvLXjxVPFh5TcyZvrtZOzBljf71YeDa8GBzYL66ZPGmq3k2B/B+nvyALC2fQ5gfLFZsVLjiw1egGokrlbZAlRt3A+RWDBBEt1UFbBB7SDAoZvya3osnHKndz7F7PI9dZ0RrUf6RhLoy4AeUr90mlJkwiN1HieN1TlqwuAduR7Kz4pW3I0g9jTcux1MzoUhiyS+CiW+6FhNiklg9K68OhDYpYHNcMj4udsr6VkahevoRLOWc9sC3rBF0nP6fMAxvenbralzn+t6HKUZqKh/g+an/gWvOkS8E+Hgj5BJXeOOhlRvF3o5uCRnxJtlFbny2TIF1uKeHvtvv4SeqPUfMD6GmfHATZVcM32B4w8ECU=
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
- [Critical] mm/gup: follow_page_pte() walks past PTE table end on 2-level =
page tables
- [Medium] mm/gup: unsigned long overflow of end in follow_page_pte() cause=
s retry loop
--

commit 88431cb08ef25a5abdfb0b14be61fbed0f5a8113
Author: Rik van Riel <riel@surriel.com>

mm/gup: walk multiple PTEs per follow_page_pte() call

This commit updates follow_page_pte() to walk all PTEs from the starting
address up to the page table, VMA, or request end boundary under a single
PTE lock acquisition, flushing the collected pages after dropping the lock.

> diff --git a/mm/gup.c b/mm/gup.c
> index 9e7eb8a323bbf..67e20b326be6e 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -937,44 +937,67 @@ static long gup_lookup_pte(struct vm_area_struct *v=
ma, unsigned long address,
>  	return 0;
>  }
> =20
> +/*
> + * Walk the PTEs from the start address to the end of this page table or=
 VMA,
> + * whichever comes first, and commit every page found.
> + *
> + * A failure on the first PTE is returned to the caller. A failure after=
 that
> + * is a short read; __get_user_pages() retrying the read will get the er=
ror.
> + *
> + * Return: the number of pages stored in @pages, 0 when no mapping exist=
s at
> + * the start address, or a negative errno for a failure on the first PTE.
> + */
>  static long follow_page_pte(struct vm_area_struct *vma,
> -		unsigned long address, pmd_t *pmd, unsigned int flags,
> -		struct page **pages)
> +		unsigned long address, unsigned long end, pmd_t *pmd,
> +		unsigned int flags, struct page **pages)
>  {
>  	struct mm_struct *mm =3D vma->vm_mm;
>  	bool need_no_page_table =3D false;
> -	struct page *page;
> +	pte_t *ptep, *orig_ptep;
> +	unsigned long walk_end, base;
> +	unsigned long nr =3D 0;
>  	spinlock_t *ptl;
> -	pte_t *ptep, pte;
> -	long ret;
> +	long ret =3D 0;
> =20
> -	ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
> +	orig_ptep =3D ptep =3D pte_offset_map_lock(mm, pmd, address, &ptl);
>  	if (!ptep)
>  		return no_page_table(vma, flags, address);
> -	pte =3D ptep_get(ptep);
> =20
> -	ret =3D gup_lookup_pte(vma, address, ptep, pte, flags, &page);
> -	if (!ret && page) {
> +	base =3D address;
> +	walk_end =3D min(pmd_addr_end(address, end), vma->vm_end);

[Severity: Critical]
Can this walk past the end of the mapped page table on 2-level page tables?

In mm/gup.c, __get_user_pages() calls follow_page_mask() ->
follow_p4d_mask() -> follow_pud_mask() -> follow_pmd_mask() ->
follow_page_pte(), passing end down without clamping it via pgd_addr_end(),
p4d_addr_end(), or pud_addr_end():

mm/gup.c:follow_page_mask() {
	...
	if (pgd_none(*pgd) || unlikely(pgd_bad(*pgd)))
		ret =3D no_page_table(vma, flags, address);
	else
		ret =3D follow_p4d_mask(vma, address, end, pgd, flags, pages);
	...
}

When the pmd level is folded on 2-level page table configurations,
include/asm-generic/pgtable-nopmd.h defines pmd_addr_end() as a no-op:

#undef  pmd_addr_end
#define pmd_addr_end(addr, end)			(end)

As noted in folio_pte_range() in mm/memory.c:

	/*
	 * We cannot use pmd_addr_end(), as it does not clamp reliably. To
	 * avoid wraparounds, compute using the inclusive end.
	 */
	const unsigned long upper =3D min(pmd_end - 1, vma->vm_end - 1) + 1;

Because pmd_addr_end(address, end) evaluates to end on 2-level page tables,
walk_end is only bounded by min(end, vma->vm_end). When a VMA and the
requested range [address, end) span across a top-level page directory entry
boundary, will the loop increment ptep past the end of the page table mapped
by pte_offset_map_lock()?

> +
> +	for (; address < walk_end; address +=3D PAGE_SIZE, ptep++) {

[Severity: Medium]
What happens in follow_page_pte() if end wraps around unsigned long to 0 or
a value less than or equal to address?

In mm/gup.c, __get_user_pages() computes end without clamping or saturating:

mm/gup.c:__get_user_pages() {
		...
		nr =3D follow_page_mask(vma, start, start + nr_pages * PAGE_SIZE,
				      gup_flags, pages ? &pages[i] : NULL);
		if (!nr || nr =3D=3D -EMLINK) {
			ret =3D faultin_page(vma, start, gup_flags,
					   nr =3D=3D -EMLINK, locked);
			switch (ret) {
			case 0:
				goto retry;
		...
}

Callers of the slow-path pin/get entry points, such as
process_vm_rw_single_vec() in mm/process_vm_access.c calling
pin_user_pages_remote(), can pass a valid start address near the top of the
address space (for example on architectures where the user address space
reaches the last page before wraparound) with nr_pages such that
start + nr_pages * PAGE_SIZE overflows unsigned long.

When end wraps around to a value <=3D address, pmd_addr_end(address, end) a=
nd
walk_end evaluate to end <=3D address. Doesn't the loop in follow_page_pte()
then execute zero iterations and return 0 even when a valid present page is
mapped at address, causing __get_user_pages() to call faultin_page() and
spin in the goto retry loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102193026.3860=
700-1-riel@surriel.com?part=3D7

