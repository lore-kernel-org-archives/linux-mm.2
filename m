Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 679AE606A329
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 03:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V15M1ULa
Received: by kanga.kvack.org (Postfix)
	id 576E06B03F6; Mon, 19 Oct 2026 23:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5285B6B03F8; Mon, 19 Oct 2026 23:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D816B03F9; Mon, 19 Oct 2026 23:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 133386B03F6
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 23:11:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE954404C5
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:11:56 +0000 (UTC)
X-FDA: 85341530232.04.FF5876A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6551B40003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 03:11:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V15M1ULa;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792465915;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nq6vIY5JklM2sXVxnREYWYLfWt+U+CEQrihdeKOzWv0=;
	b=PPox9l6Y2BeKcMynoMbdGeRTL1dM+SOhG5DI4aFGA74/tP3iKo3MAbhomafDQQRr+a54/J
	nrhUDzBWCoF8Dv6oZnApwKTeTo7YQ3SVRwxNH144Q4PV5XsjWtsYO8zWvVU6IV/RznL03a
	/NNC/O70SZzSCaHFIQDNrJ6xAjXFWtQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792465915;
	b=qKRF/25CaZbuomYsu7TPgd8OrNyQRIc9xEyiYdy6667nz2PhcLnFNOIXaXiDiVIEw9w1Tp
	CEzTLCrXCDE40S9PrFVR/vBvGw2ne/S2kci07m5IaaiqSZK9ij1pDH2CI3LHMuqPchoG5X
	0j+sK1Aaa5Gf6+/pzgwLKzPnIyDV+Yw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=V15M1ULa;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC8E760A59;
	Tue, 20 Oct 2026 03:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D5281F000C4;
	Tue, 20 Oct 2026 03:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792465914;
	bh=Nq6vIY5JklM2sXVxnREYWYLfWt+U+CEQrihdeKOzWv0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V15M1ULaaI8ymfeKae14p9jA+iiBeGRMTxwXJsyzH7i968prHjN1Aej448Zfnoh1G
	 mcsGqUBx/JiuhAVeMTJ+ZsDUgUx1QDkCBHqzms7XQX3aGjoSFz7ETp8vmyNEQLZ5P6
	 JZrXGFZZJi32oJVK+ZFzZnD9K1rDpiY4TVuHeI5AlCGMeL49lnCZmKrlIIvF7hxZ59
	 BjDplp4j5anV4/fLwW1Y6FG1VXeTdCEak6i2NP9eIziWv032qh9SxjD2MYkr0aOb/2
	 XJbwhdZAnaaYR8YjfAHIvdYbKsr1NpvmmlaokMRhwE+EBCaYHuI+mGgSXI3CbUYQN8
	 qalRrYsDDytIA==
Message-ID: <sashiko-outbox-178431@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] tools/mm: rewrite show_page_info.py with modular design
 and new features
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Stephen Brennan" <stephen.s.brennan@oracle.com>, linux-mm@kvack.org, "Ye
 Liu" <liuye@kylinos.cn>
In-Reply-To: <20261019-show_page_info_refactor-v1-1-42518e2d7de7@linux.dev>
References: <20261019-show_page_info_refactor-v1-1-42518e2d7de7@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 20 Oct 2026 03:11:53 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6551B40003
X-Stat-Signature: g6zj91zmx8am8n9rmuj5mfdqwqd515np
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792465915-865585
X-HE-Meta: U2FsdGVkX1+pSz9nYVAFM8EhS1uWGUHCr8CSNhXWzhwfna1RlECdhGGoz8XYPqGAM/jKPrPKdcCmfYOxl7OTDGfBonqReQduM4gqmIxzpxiuWyFwDDrrAhlwl4dCgzVCPECJg77jlU+nCY/6sjAb/09YYHCFZxMuBPainNUKlUIKYBx/GW1s6z3DVkeW/cRp0JjlOS97s9WaoNHy3La+We+jCFM4WcLDFR5JKYx9j7kmtfxwxYp7NBj2S0q7cyaZIUnFEi7vgHnNoUL+bEaBIXfTbt91sdCC51sJbPS79QClimw5zho49ISqacP46YjyRQ1MPvYFZ/kqm3DU1nl7ttTEcKKjfOg2XQZZV9ZBfrJIuHOPNAnB/YpPtZO+z1tOKgIGEl4JLyEODSkXvpdChlhMcflZZEjXc1JHTucAaU3nUFgZU6VovRNv9VPIismgPxqD40Juse+Qbkf02ILEusj3uiuUwznGVXb3eMo+rwugZU89UmgR4UtqWQXecXn4ddcJdkVZyiPQI3VxkaEXdYR6LAw7By/X5BI7cqWfOZwimUyy2qxe181lPBZoYLbHA5Enc6b2TGQNMFD+OlVrg8Y6SP97sUkP8pqfytkTcnzMTB+M9U51GomAxaeZV77SPPtjyVhX3qoR9JGQPOMQNzxf7cx+EGuQmmuy6wNM/G+y3+tQiDi5V6/Y4CWtC6YKufjd6Z89J4oNAuRnK39vfESM+4Acuvmf/FDMo3wKx/vVVnT77IZeX37Y986MpgWxjZzmp0bCo/altaSnpeMBcTOjPjJHvgsU6UVvA/IXNrHJyywn6QJnCXjfDI5+o6cdU4iyK5hAkCzV6vVwBP+AeE66SlLCpL4MrpH26bFDh4z/GW1u6sG5+Iqt12ashjLkvOhibCBTzj296+Ki1fo+2xh8yFr4uZdUL1B4MBPHLoG6QlN5sGS3t6zEsQ7D6rqKgre/BcmOAK8bIaMh0O/
 HLgB+y7X
 YaGjygtwhhKQ2wEupdPUcaU68CFDxj+A90E8i4mMuiEeH0qqitABj96ubAX8i3pQ/mxQExTisRMiqsAWWZzHt9evWkJA08OCYzI5/S1XbHMov3suy2SnvTa5auLAj6kbvq8bogcSk7QetvtNc8ZKBfd2MdSYuXo8EiOV7jNghUHeAi/0XZOqDPT7IsC2u8u+gCe2AR39okZX5oMYiKIqz1MxzHEwAl5tRra/uC9GhdAgowSlXIdIhXCN+jWuwcOi04XxDqlCknTSXcDnZy45uUODqroriiaN0Zdf6RqAyWkynK+uO4Ob8ePGHc6vjovqXjH8opIKRpl4NO0/sDfPkVYcLsM+XlOR7E7KvbVwmz/lXyQDSvXp8jZF+BoWgVB5w8vNBR1jtARYOiotYjvmYmGZEQyZz1sUntngh4wE5783rBYDbn3gQKEp9m8otXuzCHsEnXiuBT9LckcWjZr06UhWnWSSNAdWLU5w3MDtgYW553sykFy6/uInNiha5Py5adBAPBy/lHjVJ2Kpqv1qvgyQG5aDkuUCGWOFMJRGo4DzQa0QjblP3ACrlDVxFzTDmtO4R+7YWK791BfPqiBSWRLmv4H2HQm4gpsqs9EOO/P448Js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential issue(=
s) to consider:
- [Medium] tools/mm: broken page_type bitfield decoding in _page_type()
- [Medium] tools/mm: incorrect rmap resolution in get_rmap_info() and _rmap=
_fields()
- [Medium] tools/mm: broken swap cache detection in _page_fields() and _swa=
pcache_info()
- [Medium] tools/mm: unmasked upper PTE bits and non-present PTE decoding i=
n _walk_page_table()
- [Low] tools/mm: wrong slab stride and tail page access in _scan_page_type=
s()
--

commit 16444b1496af4eed07be39cdba3cef7d0140f1da
Author: Ye Liu <liuye@kylinos.cn>

tools/mm: rewrite show_page_info.py with modular design and new features

This commit rewrites tools/mm/show_page_info.py into modular field-collector
functions, adds multiple input modes (--pfn, --page, --user, --selftest), a=
nd
introduces rmap, PTE walk, NUMA node/zone, page type, and memcg inspection
features.

> diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
> index c46d8ea283d7d..eea1f8b8fa9fc 100644
> --- a/tools/mm/show_page_info.py
> +++ b/tools/mm/show_page_info.py

[ ... ]

> +def _vma_owner(vma, folio_index, page_size):
> +    """Extract (pid, comm, vm_start, vm_end, mm_ptr, vaddr) from a VMA."=
""
> +    mm_ptr =3D vma.vm_mm
> +    owner =3D mm_ptr.read_().owner.read_()
> +    vaddr =3D vma.vm_start.value_() + \
> +        (folio_index - vma.vm_pgoff.value_()) * page_size
> +    return (owner.pid.value_(), owner.comm.string_().decode(),
> +            vma.vm_start.value_(), vma.vm_end.value_(), mm_ptr, vaddr)
> +
> +
> +def get_rmap_info(page):
> +    """Find processes that map this page via reverse mapping."""
> +    results =3D []
> +    head =3D compound_head(page) if PageCompound(page) else page
> +    mapping =3D head.mapping.value_()
> +    if mapping =3D=3D 0:
> +        return results
> +
> +    page_size =3D prog["PAGE_SIZE"].value_()
> +    try:
> +        folio_index =3D head.__folio_index.value_()
> +    except (AttributeError, FaultError):
> +        folio_index =3D 0
> +
> +    try:
> +        if mapping & 0x1:
> +            # Anonymous page: walk anon_vma interval tree.
> +            # Note: this returns all VMAs sharing the anon_vma, which may
> +            # include VMAs that don't actually map this page. The PTE wa=
lk
> +            # distinguishes actual mappings (shows "not present" otherwi=
se).
> +            anon_vma =3D Object(prog, "struct anon_vma *", mapping & ~3)
> +            for avc in rbtree_inorder_for_each_entry(
> +                "struct anon_vma_chain", anon_vma.rb_root.rb_root, "rb"):
> +                try:
> +                    results.append(
> +                        _vma_owner(avc.vma.read_(), folio_index, page_si=
ze))
> +                except FaultError:
> +                    continue
> +        else:
> +            addr_space =3D Object(prog, "struct address_space *", mappin=
g & ~3)
> +            for vma in rbtree_inorder_for_each_entry(
> +                "struct vm_area_struct", addr_space.i_mmap.rb_root,
> +                "shared.rb"):
> +                try:
> +                    vma_pgoff =3D vma.vm_pgoff.value_()
> +                    vma_pages =3D (vma.vm_end.value_() -
> +                                 vma.vm_start.value_()) >> 12
> +                    if vma_pgoff <=3D folio_index < vma_pgoff + vma_page=
s:
> +                        results.append(
> +                            _vma_owner(vma, folio_index, page_size))
> +                except FaultError:
> +                    continue
> +    except (FaultError, AttributeError):
> +        pass
> +
> +    return results

[Severity: Medium]
Are there a few issues in how get_rmap_info(), _vma_owner(), and
_rmap_fields() resolve reverse mappings?

First, for KSM pages, FOLIO_MAPPING_KSM (0x3) sets both FOLIO_MAPPING_ANON
(0x1) and FOLIO_MAPPING_ANON_KSM (0x2) in head.mapping, where mapping & ~3
points to a struct ksm_stable_node rather than a struct anon_vma. Checking
only mapping & 0x1 causes get_rmap_info() to cast a ksm_stable_node pointer
to struct anon_vma * and walk it as an anon_vma rbtree.

Second, in _vma_owner(), vaddr is calculated using vma.vm_pgoff:

    vaddr =3D vma.vm_start.value_() + \
        (folio_index - vma.vm_pgoff.value_()) * page_size

For anonymous pages, folio->index (__folio_index) is relative to
vma_start_anon_pgoff(vma) ((vma->__vm_anon_pgoff_hi << 32) |
vma->__vm_anon_pgoff_lo), not vma->vm_pgoff. For COW anonymous pages in
MAP_PRIVATE file-backed VMAs (such as writable data/bss segments of ELF
binaries), vma->vm_pgoff is the file offset while folio_index is vaddr >>
PAGE_SHIFT, producing a bogus vaddr outside the VMA. In addition, the
anonymous branch in get_rmap_info() does not check whether folio_index falls
within the VMA's anonymous pgoff range, so for split or adjacent VMAs shari=
ng
an anon_vma, _vma_owner() computes a vaddr outside avc.vma, and vma_find(mm,
vaddr) in _rmap_fields() resolves a different VMA instead of avc.vma.

Third, show_page_state() passes head instead of page to _rmap_fields(head,
fields, ...), and get_rmap_info() uses head.__folio_index without adding the
tail-page offset (page_to_pfn(page) - page_to_pfn(head)). When inspecting a
tail page of a compound page, _rmap_fields() computes vaddr and walks the
page tables for the head page instead of the target subpage, and misses VMAs
that only map a subrange of a large folio starting after head.__folio_index.
Also, the file-backed branch hardcodes >> 12 when computing vma_pages inste=
ad
of dividing by page_size.

[ ... ]

> +def _page_type(page):
> +    """Decode page->page_type field via enum pagetype discovery."""
> +    try:
> +        pt =3D page.page_type.value_()
> +    except AttributeError:
> +        return None
> +    try:
> +        enum_type =3D prog.constant("PGTY_buddy").type_
> +        for name, value in enum_type.enumerators:
> +            if value =3D=3D pt:
> +                return name[5:]  # strip PGTY_ prefix
> +    except (LookupError, AttributeError):
> +        pass
> +    return None

[Severity: Medium]
Does _page_type() ever match real typed pages, or does it misclassify normal
mapped pages instead?

In include/linux/page-flags.h, enum pagetype defines 8-bit constants
PGTY_buddy (0xf0) through PGTY_mapcount_underflow (0xff), and FOLIO_TYPE_OPS
stores the type in bits 24..31 of the 32-bit page->page_type field:

    enum pagetype {
        /* 0x00-0x7f are positive numbers, ie mapcount */
        /* Reserve 0x80-0xef for mapcount overflow. */
        PGTY_buddy              =3D 0xf0,
        ...
        PGTY_mapcount_underflow =3D 0xff
    };

    static inline bool page_type_has_type(int page_type)
    {
        return page_type < (PGTY_mapcount_underflow << 24);
    }

Because _page_type() compares the unshifted 32-bit pt directly against value
(0xf0..0xff), real typed pages (whose page_type is 0xf0000000..0xf8ffffff,
such as 0xf5000000 for PGTY_slab in the commit message's Tests 5-7) never
match. Conversely, because page->page_type shares a union with atomic_t
_mapcount, any normal user-mapped page whose _mapcount happens to be between
0xf0 and 0xff (240..255) will match value =3D=3D pt and be falsely reported=
 as a
typed page.

Also, even if pt is shifted right by 24 bits, PGTY_mapcount_underflow (0xff)
is an enumerator in enum pagetype and will match normal unmapped pages where
page_type is 0xffffffff (_mapcount =3D=3D -1) unless excluded, and _base_fi=
elds()
passes page rather than head to _page_type(), whereas tail pages of compound
typed folios have page_type =3D=3D UINT_MAX.

[ ... ]

> +def _walk_page_table(mm, vaddr):
> +    """Walk 4-level page table. Returns list of (level, entry_pa, entry_=
val).
> +
> +    Note: only supports x86_64 4-level paging (48-bit VA). Does not supp=
ort
> +    5-level paging (LA57, 57-bit VA) where an additional P4D level exist=
s.
> +    """
> +    page_mask =3D ~(prog["PAGE_SIZE"].value_() - 1)
> +    entries =3D []
> +    try:
> +        def _read(table_va, idx):
> +            return prog.read_word(table_va + idx * 8)
> +
> +        base_va =3D mm.pgd.value_()
> +
> +        # PGD
> +        pgd_idx =3D (vaddr >> 39) & 0x1FF
> +        pgd_val =3D _read(base_va, pgd_idx)
> +        pgd_pa =3D virt_to_phys(prog, base_va).value_() + pgd_idx * 8
> +        entries.append(("PGD", pgd_pa, pgd_val))
> +        if not (pgd_val & 1):
> +            return entries
> +
> +        # PUD
> +        pud_table_pa =3D pgd_val & page_mask
> +        pud_idx =3D (vaddr >> 30) & 0x1FF
> +        pud_val =3D _read(phys_to_virt(prog, pud_table_pa).value_(), pud=
_idx)
> +        entries.append(("PUD", pud_table_pa + pud_idx * 8, pud_val))
> +        if not (pud_val & 1):
> +            return entries
> +        if pud_val & (1 << 7):
> +            return entries  # 1GB huge page
> +
> +        # PMD
> +        pmd_table_pa =3D pud_val & page_mask
> +        pmd_idx =3D (vaddr >> 21) & 0x1FF
> +        pmd_val =3D _read(phys_to_virt(prog, pmd_table_pa).value_(), pmd=
_idx)
> +        entries.append(("PMD", pmd_table_pa + pmd_idx * 8, pmd_val))
> +        if not (pmd_val & 1):
> +            return entries
> +        if pmd_val & (1 << 7):
> +            return entries  # 2MB huge page
> +
> +        # PTE
> +        pte_table_pa =3D pmd_val & page_mask
> +        pte_idx =3D (vaddr >> 12) & 0x1FF
> +        pte_val =3D _read(phys_to_virt(prog, pte_table_pa).value_(), pte=
_idx)
> +        entries.append(("PTE", pte_table_pa + pte_idx * 8, pte_val))
> +    except FaultError:
> +        pass
> +    return entries
> +
> +
> +def _pte_fields(mm, addr, fields):
> +    """Collect page table entries via page table walk."""
> +    if prog.platform.arch !=3D Architecture.X86_64:
> +        return
> +    entries =3D _walk_page_table(mm, addr)
> +    for i, (level, pa, val) in enumerate(entries):
> +        if not val:
> +            fields[level] =3D "not present"
> +            continue
> +        if i =3D=3D len(entries) - 1:
> +            # Final entry (PTE or huge page): show decoded flags
> +            flags =3D '|'.join(n for n, m in _PTE_FLAGS if val & m)
> +            fields[level] =3D f"{hex(pa)} =3D> {hex(val)} ({flags})"
> +        else:
> +            # Intermediate level: just address =3D> value
> +            fields[level] =3D f"{hex(pa)} =3D> {hex(val)}"

[Severity: Medium]
In _walk_page_table(), won't page_mask =3D ~(prog["PAGE_SIZE"].value_() - 1)
leave upper bits (such as bit 63 NX or bits 52..62) set in pud_table_pa,
pmd_table_pa, and pte_table_pa?

Because Python integers have arbitrary precision, ~(4096 - 1) evaluates to
-4096, where all bits >=3D 12 are 1. If an intermediate PGD, PUD, or PMD en=
try
has NX (bit 63) or software bits set, masking with page_mask retains those
high bits and passes an invalid physical address to phys_to_virt(), raising
FaultError and aborting the page table walk.

Also, in both _pte_fields() and _rmap_fields(), the loop checks if not val:
to detect non-present entries. When an entry is non-zero but does not have
the PRESENT bit (bit 0) set (such as a swap PTE, migration entry, or
PROT_NONE entry), val is non-zero, so the code decodes swap/migration bits
against _PTE_FLAGS as if it were a present hardware PTE.

[ ... ]

> +def _swapcache_info(head):
> +    """Get swap entry value if page is in swap cache."""
> +    # drgn does not provide a PageSwapCache() helper, so we check the
> +    # decoded page flags string for PG_swapcache.
> +    flags_str =3D str(decode_page_flags(head))
> +    if "PG_swapcache" not in flags_str:
> +        return None
> +    try:
> +        return hex(head.private.value_())
> +    except (AttributeError, FaultError):
> +        return "Unknown"
> +
> +
> +def _page_fields(head, fields):
> +    """Collect non-slab page fields (refcount, mapping, anon/file, etc.)=
."""
> +    mapping =3D head.mapping.value_()
> +    fields["Page Mapping"] =3D hex(mapping)
> +
> +    if mapping =3D=3D 0:
> +        fields["Page Anon/File"] =3D "Unmapped"
> +        refcount =3D head._refcount.counter.value_()
> +        if refcount > 0:
> +            fields["Page Refcount"] =3D refcount
> +            fields["Page Mapcount"] =3D head._mapcount.counter.value_()
> +        return
> +
> +    fields["Page Refcount"] =3D head._refcount.counter.value_()
> +    fields["Page Mapcount"] =3D head._mapcount.counter.value_()
> +
> +    lru =3D _lru_type(head)
> +    if lru:
> +        fields["LRU"] =3D lru
> +
> +    swap =3D _swapcache_info(head)
> +    if swap:
> +        fields["Swap Entry"] =3D swap

[Severity: Medium]
Can _page_fields() and _swapcache_info() miss actual swap-cache pages while
misidentifying non-swapbacked file pages as swap-cache pages?

In _page_fields(), returning early when mapping =3D=3D 0 skips both _lru_ty=
pe()
and _swapcache_info(). However, shmem folios in the swap cache and unmapped
anonymous swap-cache folios have mapping =3D=3D NULL (0), so their LRU stat=
e and
Swap Entry will never be shown.

Meanwhile, in include/linux/page-flags.h, PG_swapcache is an alias for
PG_owner_priv_1 (the same bit number as PG_checked), and
folio_test_swapcache() requires both folio_test_swapbacked(folio) and
PG_swapcache. Because drgn's decode_page_flags() emits all enum pageflags
names for each set bit, any non-swapbacked filesystem page with
PG_owner_priv_1 / PG_checked set has "PG_swapcache" in decode_page_flags().
Without checking PageSwapBacked(head) in _swapcache_info(), filesystem
head.private values will be reported as Swap Entry.

[ ... ]

> +    # Show VMA and PTE details for first 2 mappings (--pfn/--page mode o=
nly)
> +    if not show_detail:
> +        return
> +    detail =3D min(2, len(rmap))
> +    for i in range(detail):
> +        pid, comm, s, e, mm, vaddr =3D rmap[i]
> +        prefix =3D f"Rmap {pid} " if detail > 1 else ""
> +        try:
> +            vma =3D vma_find(mm, vaddr)
> +            fields[f"{prefix}VMA"] =3D hex(vma.value_())

[Severity: Medium]
What happens in _rmap_fields() if the first two rmap entries belong to the
same process (same pid)? Since prefix only includes pid, won't the second
iteration overwrite the first entry's keys in fields?

[ ... ]

> +def _scan_page_types():
> +    """Scan all pages and categorize by type. Returns {type: page} dict.=
"""
> +    from drgn.helpers.linux.mm import for_each_page
> +
> +    objexts_flag =3D prog.constant("MEMCG_DATA_OBJEXTS").value_()
> +    mask =3D prog.constant('__NR_MEMCG_DATA_FLAGS').value_() - 1
> +    base_stride =3D prog.type("struct slabobj_ext").size
> +    stride =3D base_stride * 2 if _slab_obj_ext_has_codetag() else base_=
stride
> +
> +    found =3D {}
> +    needed =3D ["anon", "file", "compound_anon", "compound_file",
> +              "slab_multi", "slab_single", "slab_no_objcg", "uncharged"]
> +
> +    for page in for_each_page(prog):
> +        try:
> +            head =3D compound_head(page) if PageCompound(page) else page
> +
> +            if PageSlab(head):
> +                if page.memcg_data.read_() & objexts_flag:
> +                    try:
> +                        slab =3D cast("struct slab *", head)
> +                        if slab.obj_exts_needs_objcg.value_():
> +                            n =3D _count_distinct_memcg(page, stride, ma=
sk)

[Severity: Low]
In _scan_page_types(), shouldn't the PageSlab(head) block use head rather
than page when reading memcg_data and calling _count_distinct_memcg(), and
compute the stride per slab via _slab_obj_ext_stride(slab)?

For tail pages of compound slabs, memcg_data and slab.objects live on head,
not page. Also, computing a single fixed stride outside the loop skips the
slab.obj_exts_in_object check that _slab_obj_ext_stride(slab) performs when
SLAB_OBJ_EXT_IN_OBJ is used.

[ ... ]

> +            if page.memcg_data.read_() =3D=3D 0:
> +                if "uncharged" not in found:
> +                    found["uncharged"] =3D page
> +                continue

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261019-show_page_=
info_refactor-v1-1-42518e2d7de7@linux.dev?part=3D1

