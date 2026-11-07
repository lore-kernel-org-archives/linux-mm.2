Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A706606A338
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 14:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZW8iWiaf
Received: by kanga.kvack.org (Postfix)
	id F24D56B05B2; Sat,  7 Nov 2026 09:43:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECD926B05B3; Sat,  7 Nov 2026 09:43:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC866B05B4; Sat,  7 Nov 2026 09:43:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE6C86B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 09:43:48 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1364640253
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:43:48 +0000 (UTC)
X-FDA: 85408592136.14.5104945
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6FADE180006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 14:43:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZW8iWiaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794062626;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OAYpy46b6wbcErw+CaAbbx+wExpS7qv+RwHh5NwjlQ=;
	b=e8CgeZIWuYZVCxnYZgQxBf8r9LN7bklbTH5aU6I3bIc4LxeBba8rcCSi4/0/fhAtPxzr4c
	034TlsItJj6C1SUDGyrV7LxvaVvlZIqGmDPv1XZ8jCighP94rogzZ1EVpbPqVzxVIi5p0R
	FUmvIiMj+grvglnEGLT4nBoxu9r5XHk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794062626;
	b=WCnsD1BTy19snsiFPFotqgwZV8biGZmoS9XUVBxEnX7kido2HzZNIPSWTXQKgKOH/L1hIB
	FCeDANXBdEjNLPG6bvkvi1Llnfg0eiNeOkWxk+4WpbJxGtYalzBksWyEksdZpUOMrL23eB
	AiF9zY6NPxUsAjIM3xZct3flWBMeT4g=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZW8iWiaf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B7C3060CFF;
	Sat,  7 Nov 2026 14:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06581F008A4;
	Sat,  7 Nov 2026 14:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794062625;
	bh=9OAYpy46b6wbcErw+CaAbbx+wExpS7qv+RwHh5NwjlQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZW8iWiafnmq50Uv5wgVr7u35mawYX3CH54rKcb/NqPlc17+rWKcEWDGS8pey9nO4O
	 CM5Hfeq12GL4UmOl6h6edRDbij0okJuuktmpk1TLitTX0igxLLR1ZmpRTtGJHdSOdh
	 c3pXyMZJs5GvKEqUMu9uyXT4pyMHqunw6dzsROfCq/30MTkcbBib+AFK7BMh7Aqmmz
	 bOc9o6gYvnvikG2B4vOjXo8EmF8UnBrtD+ZldmuJkF988PspgfLFH0T6IzkRnXID/K
	 GTexmR/JOQmmhvr2G2CSHJLOWYdjvOJj4iVsCpbzJ2XsZ5/nYbS6d416a5yHaqzFx8
	 hhrD6mxnUHO/A==
Message-ID: <sashiko-outbox-202966@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/memory: refuse to map page cache folios that are not
 uptodate
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kiryl Shutsemau" <kirill@shutemov.name>, "Andrew Morton" <akpm@linux-foundation.org>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>
Cc: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Hugh
 Dickins" <hughd@google.com>, "Chris Mason" <mason@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261106144323.3634477-1-kirill@shutemov.name>
References: <20261106144323.3634477-1-kirill@shutemov.name>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 14:43:44 +0000
X-Stat-Signature: 9bbajybkit6c4anmq5qxnxr5ajn5ye61
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FADE180006
X-HE-Tag: 1794062626-530668
X-HE-Meta: U2FsdGVkX18JqiPSSSSLm0t/+GelfVz8R9HvZrEBbE9UXd7w2bpGLckb54+px7ZLWTG1JSIqdfzLytB4O6l6F6bDwS4KnnNuxxVvlUE0uXM9d84dYmFfE/8JwWKXpuHXW3eUulM3UPzeni6AEF4jfJG7G/J+8frDcRfgGBDVWvE3z+09Z/W8G1gLXK7YUBxSYYpiMHi2qY/BFz4WfoYuC2Aob1tBM6N8B32BxP3raQblySl2g1m4EUJ8KILvi+nTXQiUf7nsJxLw764fuLwz6EHzY+pi2/lMKohcW8Uk4l45uQalGZ80VgraQqOD96iAk5IJJWGUJ48JAA37N0umgteXmMgpEWf5HWQTI8xJ08hqVWMDeBpzJ76mXCk1ZgIooKridJXP4jYBCaHZdxc5oaP+iJZa343p1bOo/Ydl1oLLUxvIl58qKWJwuuHA13ctuyR++EoOcpyR6xnwJL2xKlSgxeDkTCmfff9Wb05LlfqlVlBx+w6wmOA0DzCsw8CVrA3OcFSEzsNm8lzoa34GK2bmIs6ba+N8W+zu3G061spxNkJ51mntaGRXVxwinCwzGxJSGNxGJzHakSr3YLcPuSA2yNUNe6C6DSX81Zs3mUgS+OSsJ4dwQpEeigQBoLgu1i2gtxuLpRyeNx5bj7LaE/WzU5HKeYlyXI9GZbzwg7lcscdAFjAqFxTOMLPsLf8QzU9pPsHqRxEU1VWMEx8hm8yNSCJVphPq28L4pVnkLKDqQ1yRS+uITRsR3glEgUsoFOqG65BW7zcrLLd/oGXJ19RLwTGt8+5UUrymoA2np5HJ2k6HrALOGq71Ayfk1lzOkPWTCzQ3Y+VexRquA4Ns9WhpIY6pTbITXufYOlQ5GQA78Bt1Bu/ZJAPLX4AKdu0RoRPLqpWlOVeVcLaf68Vms9xcHiNE1ep5qQRxFcw0QxYejDGuyLPm1Nm+fycoocJ0jIKZDNVb16B7XHlkhLX
 5Hh/6VQC
 nU+xAoZIOYdiwQmcU89E6KpTdrQCaS9MW0sznMh1vkS/kVTOhpV7o05NPO6THfZ1tgIgvAtR/EmmbNqFEIw/OoOAd+dJjtAH80RQV3E+kWVpb+TywHuDm9TfjEtl0XvBiYCXY6kvgJ+lNbEtEG+al6WgzUcM3YuWL+iXSRACcZOxSnaywKBIKcDzPGfewGB9ZT/rtf+SoP1/Cja0kBn55MFzCA9S2pQGKq0JHGgrw7mu9/BHpJRwrO82Lqw9LSS9OThDG8sFQ202yfLbDfU27wZAm72nEUc5FpXVWQ0n8sSE/oP7lT8ouFCDH19jtqqtUQh68meMD6hz+QOQWKm1tu0iss9aT6HsbT5h/nPuuVOeAKupGBqNEZ6Ll4sisYcc8onS2uH/CMHJCOYiiy8xsladVlLVBmTXdeUYRou72Yqk87AFbdmQl/eoJauR75C2cehZD8dMEZ161Yg/f8uJINFW8x9m9RoHdCjcUgGpxz9rGqtdmyW2KD8/tM4wSrkeGcw7YtkufZE2AtVNqbX14at286c9TF6agexP22FFg8cwn+zMPuOqkGK+EuQDjDnAH6D3dxOfA8PhkWNptgE/sJ/6ovZpl3RPjF3Z8qT5xuE/VWFsS1M6A7U4I8qkNKxNk2slwKpYy2jSMQKHjFJrojr8VUf+BFes93ABv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm: user-triggerable WARN_ONCE in do_set_pmd() via
  MADV_COLLAPSE on fallocated shmem THP
- [Medium] mm: missing folio_test_uptodate() recheck in
  do_shared_fault() mkwrite path
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] mm/khugepaged: leak of vmf.prealloc_pte in set_huge_pmd() on
  fallback [1]
--

commit e25ea55c123127ec43866a765671bce4d1ee6150
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm/memory: refuse to map page cache folios that are not uptodate

This commit adds file_folio_not_uptodate() to warn and return VM_FAULT_SIGB=
US
in do_set_pmd() and finish_fault() if a page cache folio is mapped without
PG_uptodate set.

> diff --git a/mm/memory.c b/mm/memory.c
> index 6fe0b7dab927c..ff2f2deff761e 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5674,6 +5674,22 @@ static vm_fault_t __do_fault(struct vm_fault *vmf)
>  	return ret;
>  }
> =20
> +/*
> + * A page cache folio that is not uptodate holds data that was never rea=
d in
> + * or cleared, and mapping it leaks stale memory to userspace. The calle=
rs are
> + * expected to check, so treat a hit as a kernel bug and refuse the mapp=
ing.
> + */
> +static bool file_folio_not_uptodate(struct folio *folio)
> +{
> +	if (likely(folio_test_uptodate(folio)))
> +		return false;
> +	/* Driver pages from ->fault() never get PG_uptodate */
> +	if (folio_test_anon(folio) || !folio->mapping)
> +		return false;
> +	WARN_ONCE(1, "refusing to map a page cache folio that is not uptodate\n=
");
> +	return true;
> +}
> +
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  static void deposit_prealloc_pte(struct vm_fault *vmf)
>  {
> @@ -5714,6 +5730,9 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct =
folio *folio, struct page *pa
>  		return ret;
>  	page =3D &folio->page;
> =20
> +	if (file_folio_not_uptodate(folio))
> +		return VM_FAULT_SIGBUS;
> +

[Severity: Medium]
Can madvise(MADV_COLLAPSE) on an unmapped, fallocated PMD-order shmem folio
still reach do_set_pmd() and trigger the WARN_ONCE() in
file_folio_not_uptodate()?

When shmem_fallocate() allocates a PMD-order folio via shmem_get_folio_gfp()
with SGP_FALLOC, it leaves PG_uptodate clear until first use.  During
MADV_COLLAPSE, collapse_scan_file() sees is_pmd_order(folio_order(folio)) a=
nd
returns SCAN_PTE_MAPPED_HUGEPAGE without checking folio_test_uptodate(folio=
):

mm/khugepaged.c:collapse_scan_file() {
    ...
		if (is_pmd_order(folio_order(folio))) {
			result =3D SCAN_PTE_MAPPED_HUGEPAGE;
			failed_pfn =3D folio_pfn(folio);
			/*
			 * PMD-sized THP implies that we can only try
			 * retracting the PTE table.
			 */
			folio_put(folio);
			break;
		}
    ...
}

collapse_pmd() then skips collapse_file() and calls
try_collapse_pte_mapped_thp(), which locks the folio and calls set_huge_pmd=
()
-> do_set_pmd() without checking folio_test_uptodate(folio) either.  An
unprivileged user on a tmpfs mount with huge pages enabled can trigger this
WARN_ONCE() and cause MADV_COLLAPSE to fail with -EINVAL.

[Severity: High]
This problem wasn't introduced by this patch, but can set_huge_pmd() leak
vmf.prealloc_pte [1] when do_set_pmd() falls back after allocating it?

On architectures where arch_needs_pgtable_deposit() is true, do_set_pmd()
allocates vmf->prealloc_pte via pte_alloc_one() before taking pmd_lock(), a=
nd
returns VM_FAULT_FALLBACK if *vmf->pmd is no longer pmd_none():

mm/memory.c:do_set_pmd() {
    ...
	if (arch_needs_pgtable_deposit() && !vmf->prealloc_pte) {
		vmf->prealloc_pte =3D pte_alloc_one(vma->vm_mm);
		if (!vmf->prealloc_pte)
			return VM_FAULT_OOM;
	}

	vmf->ptl =3D pmd_lock(vma->vm_mm, vmf->pmd);
	if (unlikely(!pmd_none(*vmf->pmd)))
		goto out;
    ...
}

If a concurrent operation that does not take the folio lock (such as
madvise_guard_install() or mfill_atomic() on a private VMA) populates the P=
MD
before pmd_lock(), do_set_pmd() returns VM_FAULT_FALLBACK with
vmf.prealloc_pte still allocated, and set_huge_pmd() returns SCAN_FAIL with=
out
calling pte_free().

>  	/*
>  	 * Just backoff if any subpage of a THP is corrupted otherwise
>  	 * the corrupted page may mapped by PMD silently to escape the
> @@ -5849,6 +5868,16 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>  	unsigned long addr;
>  	bool needs_fallback =3D false;
> =20
> +	/*
> +	 * Check the folio ->fault() returned. For CoW that is the source of the
> +	 * copy; DAX CoW has none.
> +	 */
> +	if (vmf->page) {
> +		folio =3D page_folio(vmf->page);
> +		if (file_folio_not_uptodate(folio))
> +			return VM_FAULT_SIGBUS;
> +	}

[Severity: Medium]
Can a shared writable fault hit the WARN_ONCE() and VM_FAULT_SIGBUS in
finish_fault() if PG_uptodate is cleared while the folio is unlocked for
->page_mkwrite()?

In do_shared_fault(), __do_fault() returns a locked uptodate folio, which is
then unlocked before calling do_page_mkwrite().  While the folio lock is
dropped, writeback error handling on filesystems such as ext4
(mpage_release_unused_pages()), ecryptfs (ecryptfs_writepages()), or ntfs
(ntfs_compress_write()) can call folio_clear_uptodate() without removing the
folio from folio->mapping:

CPU0                                    CPU1
do_shared_fault()
  __do_fault()
  folio_unlock(folio)
                                        ext4_do_writepages()
                                          mpage_map_and_submit_extent()
                                            mpage_release_unused_pages()
                                              folio_clear_uptodate(folio)
  do_page_mkwrite()
    iomap_page_mkwrite()
      folio_lock(folio)
      return VM_FAULT_LOCKED
  finish_fault()
    file_folio_not_uptodate(folio)      <-- WARN_ONCE + VM_FAULT_SIGBUS

Unlike f2fs_vm_page_mkwrite() or gfs2_page_mkwrite(), handlers such as
filemap_page_mkwrite(), iomap_page_mkwrite(), and block_page_mkwrite() (as
well as do_page_mkwrite() itself) re-lock the folio and check folio->mappin=
g,
but do not recheck folio_test_uptodate(folio) to retry the fault with
VM_FAULT_NOPAGE.

[1] https://sashiko.dev/#/bug/linux-d0498ac5-724c-4edc-8408-65bd846cca7a

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106144323.3634=
477-1-kirill@shutemov.name?part=3D1

