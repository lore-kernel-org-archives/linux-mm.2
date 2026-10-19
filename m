Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 165C9CCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EF56B0250; Mon, 19 Oct 2026 09:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176836B0252; Mon, 19 Oct 2026 09:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C986B0253; Mon, 19 Oct 2026 09:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D48F76B0250
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:16:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB71DA7A54
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:16:00 +0000 (UTC)
X-FDA: 85339423680.15.40AB4A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 306A080002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:15:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H1e/DJ+V";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792415759;
	b=fEJfB+YHqj/6RL0CUSu2mtyTmjlr/4qtzpM2YOIA23OA1LDvN5rktsFuL0WlaG3cwS7Qfu
	h3i3lkPWudoU1fNkiWaoHfrTHxW5IJXte8iewTyb5pahTAfR5W61OGyCIOeE8aZ/7vxhFy
	YY0IDUzlMBI4IYdzN/ZzzQIIA0enE0w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="H1e/DJ+V";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792415759;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ6GDejbQw+Hx67AksDcOL8yiO170gbtoBW5hx7hRAA=;
	b=FYQxnjlo17EF0QC2FM0703WmQbmLU4nC7aL+K6rIt70BywwDrQmjte85Id5YOOEheAsPQz
	2XhOWHbhAgd1fSbcvmVtY0ORSISIFpRY3/M145Fl5nTgnWvQSykrA+3/UqiKcOqznJ7/pV
	BPY9//t3W3CWyAHo91/kLYfrAi7AETI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 609C040B65;
	Mon, 19 Oct 2026 13:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2AC1F000C4;
	Mon, 19 Oct 2026 13:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792415758;
	bh=dZ6GDejbQw+Hx67AksDcOL8yiO170gbtoBW5hx7hRAA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H1e/DJ+VIL42Alipe3RNxCLpnLMwDXYH+aRuquqtD12B6kLje007QsWR51AB49KBA
	 83+jYX+t62pJ8/wXV0tY/qNAi6KSr5tMUMBGogDBTTkGAno85Qs6hPr+oSs6Cai6kq
	 UgoFDlUQfoQM+sKgoBmx2XX9riOIyuELuexGH+kJJu98pUM084dXIPe9PxLBPbAZDG
	 I1BjZlhWeyhkhAsaW4tULkMzQqNVxS9nCTKA5XCSW42FIH8e3etRlASrRzBxxaQMzd
	 1sVL6HxUWAZDpkqMdsBaedpuKG6fRbqQZYSilCzA2HTIb6VaqOqzBh9Rg503s/suhY
	 OkTXgaFs2q+aA==
Message-ID: <sashiko-outbox-177114@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
Reply-To: sashiko-reviews@lists.linux.dev
To: "Samarth Narang" <samarth.colleges@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>
Cc: "Xu Xin" <xu.xin@linux.dev>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Peter
 Xu" <peterx@redhat.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, linux-mm@kvack.org
In-Reply-To: <20261019010934.697895-1-samarth.colleges@gmail.com>
References: <20261019010934.697895-1-samarth.colleges@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 19 Oct 2026 13:15:57 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 306A080002
X-Stat-Signature: kgiq9hmzmc3pfxwnjk6so9kkr1aq4iee
X-Rspam-User: 
X-HE-Tag: 1792415759-742984
X-HE-Meta: U2FsdGVkX18cihYjRLL+AnJyeKat8fKBmw8D5UUh13BtwBsvKXwQCw7CAenmSsLkm0ZvCSrD8HQd0BYrs4BlJcJISQaG9mPMOZZjc8Z2SoENay+TsUWC/O+LrUtbKrWH3h6N+vonszFERnpqskvCnnJBads7msOX9a65H+IWpTxsMUKCS2JzZSYOl5mCfeu3OAePGUL8xeYjnXFItXXyvsvszPuhIhSOyAtdptFZCe+KtWx2vHFz7EVY6n5OeTtnzJnNWMVwY80vdSP1f3j8NG6BIt7UEiVeKTpehlrFUrt9ccCS3eewI39p5UYLOYYD2WIjpIuwRFXz0H57TA2Dn+akQSK0olpDD3HalG0ZuusrYWLGvxMwn47dL7Ge7SwW8DWtnwmeZ0SGIT92zx4de/qEfvMh1SA1l50w/onl5+DZ7w97uS6NiuHBYSbKpXJJN8KdTQZC22eErlAiAxFngUljfIoFmMmy7arkSBBDLFXljIM0YO7r5BkrNTZS9s9b5kr8Rf665HI5EWVpLcx7CtED/A+QFyVnA8fDHjJtdcwMQxVL6uzYFPMJVZRchAMu0K9TW/yQ3WOFdDwV0DIhflLWIAlDeXhPEsXdhYDJIZNbbkAOrG6dCTanbeUBzrpXQDCMa+mMReK/qk4tOrEDXBkkopMqVynxYS/L1fSzZE7yyJALFdCvKhEj/XYu2GsFAjMHksdld179TjojCGTSfxyQ0c33CxksoJDNbv32/tfbUDJjSmz/KNLlVJcEWAh7snQCTPqTpKQMnXAUj4tEZjORHYL+AljFq6K+UgRRxRnkl6ZU+KvHcev7/pyHb3YbjPfJfbsUFWMLttZ0BH3xnYrRMKS3YW1hMeR3iY+znRyz5C0n5ZP4hJ8LkE+UYz9+kzRviVo91VHvLsHmlw4dp1tbK4WZDD90Z/a3v0Sbn7pQcRVG5VD8ueuD19w63u5cvzfBazuVH5D6bqNWC4K
 Pj0+LGT0
 aYDMoAPhiUsPsGxSzO2XzMhNZU6bnYCpmK4GdS6TmaPrYGK3M4wNLs/rgrwU3vIu854ARHUlpIKTcqpirKZ/dJkos+ve5w8ALvuzwaG0s7W2Y+nwnJc1yswvTdnQ60GYJNB3uTBR1aHcMKo92Q3+TmaxUXbjXjeSq0tY75FJEADzpr1GShb+iay8TZ9jwVMVXhjpFZFn4e59SWE+6Y+37ne20iRSQNFHviIpK/7Kc4ldIgrZlaDnhPTXXWF4/7dX+Xea/TcMKw91z5virHhew3UTE/9yuZ5EQQ9Y1tjZhRhvfhtHYa2zRH1zIdMl0/kT3YKjnQ2EFHT40E2wbarFtiYxFs8mU9MLBJLcN9S9GBkQ2+eEHnItIJwKc4x6dY4EqX8UlkSYYuFU3P642AoJAYvjsCoGG/2sV7K5zVYgz0EcCXQad96/8X6CvCDBC4IxHyzoUIFG5WB1tSdls0AuFMVG7aD2C6OrGRkBvQPLWR0zxwXPss3gk1G3HlZfRP/ayM48nn9UsnTriZ/67/wu5HSs7iW38Llu0sxZghaZlPK2AxMhWoup9KSYjaGAMu2O6E37U5JXCVNYL6BKTAsqQAC1Q6hDf7sRNBOBiTw7+b4QXkPUP+3TjQ+RdjSA6I4s7iN0Ha/SvMLHS6IUFrouLiHi9DnGsrJKI8cDl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] mm/ksm: installing PAGE_NONE in replace_page() breaks break_ksm() =
on RWP PTEs
- [Medium] mm/ksm: replace_page() sets soft-dirty on clean KSM zero-page PT=
Es
--

commit e9f8ba7271894cc9b005a46048d0bcc61cff0fff
Author: Samarth Narang <samarth.colleges@gmail.com>

mm/ksm: keep soft-dirty and uffd-wp when merging a page

This commit preserves the soft-dirty and userfaultfd bits when replace_page=
()
installs a KSM PTE in place of an anonymous page. For VMAs registered with
userfaultfd RWP, it also modifies the new PTE with PAGE_NONE when the uffd =
bit
is set.

> diff --git a/mm/ksm.c b/mm/ksm.c
> index dbfb8f98b1892..de144fa07c493 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
[ ... ]
> @@ -1463,6 +1464,17 @@ static int replace_page(struct vm_area_struct *vma=
, struct page *page,
>  		dec_mm_counter(mm, MM_ANONPAGES);
>  	}
> =20
> +	/*
> +	 * Preserve soft-dirty and uffd bits when replacing the page.
> +	 * Restore PAGE_NONE for RWP-protected PTEs.
> +	 */
> +	if (pte_soft_dirty(orig_pte))
> +		newpte =3D pte_mksoft_dirty(newpte);

[Severity: Medium]
When ksm_use_zero_pages is enabled and replace_page() merges a zero-filled
page whose soft-dirty bit was cleared, earlier in replace_page() the zero-p=
age
PTE is constructed with pte_mkdirty():

    newpte =3D pte_mkdirty(pte_mkspecial(pfn_pte(page_to_pfn(kpage), vma->v=
m_page_prot)));

On architectures such as x86, pte_mkdirty() sets both _PAGE_DIRTY and
_PAGE_SOFT_DIRTY:

arch/x86/include/asm/pgtable.h:pte_mkdirty() {
	pte =3D pte_set_flags(pte, _PAGE_DIRTY | _PAGE_SOFT_DIRTY);

	return pte_mksaveddirty(pte);
}

Without an else branch calling pte_clear_soft_dirty(newpte) (similar to
remove_migration_pte() in mm/migrate.c), won't clean pages merged with the =
KSM
zero page end up falsely marked soft-dirty in /proc/<pid>/pagemap?

> +	if (pte_uffd(orig_pte))
> +		newpte =3D pte_mkuffd(newpte);
> +	if (pte_uffd(orig_pte) && userfaultfd_rwp(vma))
> +		newpte =3D pte_modify(newpte, PAGE_NONE);

[Severity: High]
How does installing a KSM PTE with PAGE_NONE and the uffd bit interact with
break_ksm() when unmerging KSM pages (via ksm_madvise() for MADV_UNMERGEABL=
E,
prep_move_vma() during mremap(), __ksm_del_vma(),
unmerge_and_remove_all_rmap_items(), or break_cow())?

break_ksm() invokes handle_mm_fault() with FAULT_FLAG_UNSHARE |
FAULT_FLAG_REMOTE (and without FAULT_FLAG_ALLOW_RETRY):

mm/ksm.c:break_ksm() {
	do {
		...
		ret =3D handle_mm_fault(vma, addr,
				      FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
				      NULL);
	} while (!(ret & (VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | VM_FAULT_OOM)));
}

In handle_pte_fault(), the pte_protnone() check runs before the
FAULT_FLAG_UNSHARE check and dispatches to do_uffd_rwp():

mm/memory.c:handle_pte_fault() {
	if (pte_protnone(vmf->orig_pte) && vma_is_accessible(vmf->vma)) {
		if (userfaultfd_pte_rwp(vmf->vma, vmf->orig_pte))
			return do_uffd_rwp(vmf);
		return do_numa_page(vmf);
	}
}

1. In synchronous RWP mode (!userfaultfd_rwp_async(vmf->vma)), do_uffd_rwp()
calls handle_userfault(vmf, VM_UFFD_RWP). Because FAULT_FLAG_ALLOW_RETRY is
not set, handle_userfault() triggers the CONFIG_DEBUG_VM warning for missing
FAULT_FLAG_ALLOW_RETRY and returns VM_FAULT_SIGBUS. break_ksm() then exits =
its
loop and returns 0, leaving the KSM page (and any subsequent KSM pages in t=
he
range) still mapped after MADV_UNMERGEABLE, mremap(), or VMA teardown.

2. In asynchronous RWP mode (userfaultfd_rwp_async(vmf->vma)), the first
iteration of break_ksm() runs do_uffd_rwp(), which restores vma->vm_page_pr=
ot,
clears the uffd bit, and marks the PTE young, and the second iteration
unshares the page via do_wp_page() -> wp_page_copy(), silently stripping RWP
protection during an internal KSM unmerge.

3. Even if handle_pte_fault() were to reach wp_page_copy() directly for
FAULT_FLAG_UNSHARE, wp_page_copy() copies pte_uffd(vmf->orig_pte) onto entry
built from vma->vm_page_prot without restoring PAGE_NONE when
userfaultfd_rwp(vma) is true:

mm/memory.c:wp_page_copy() {
		if (unlikely(unshare)) {
			if (pte_soft_dirty(vmf->orig_pte))
				entry =3D pte_mksoft_dirty(entry);
			if (pte_uffd(vmf->orig_pte))
				entry =3D pte_mkuffd(entry);
		}
}

Does FAULT_FLAG_UNSHARE in handle_pte_fault() and wp_page_copy() need to
handle RWP-protected PTEs before KSM merges them with PAGE_NONE?

> =20
>  	flush_cache_page(vma, addr, pte_pfn(ptep_get(ptep)));
>  	/*

[]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019010934.6978=
95-1-samarth.colleges@gmail.com?part=3D1

