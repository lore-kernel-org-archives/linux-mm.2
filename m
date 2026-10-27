Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AA9606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DCQ/L2bM
Received: by kanga.kvack.org (Postfix)
	id A921B6B05B0; Mon, 26 Oct 2026 20:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40B76B05B1; Mon, 26 Oct 2026 20:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959586B05B2; Mon, 26 Oct 2026 20:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51B356B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:44:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 996621C425A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:44:52 +0000 (UTC)
X-FDA: 85366561224.30.DC4491D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C502E100005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:44:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DCQ/L2bM";
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793061890;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxrlTFF5NKiqGXulyA5fyoXEffuwPVdQDm0tPRVW1I0=;
	b=pr4Sdgvw1VRr3/zkWj0i/MwHLBFWbXlKf6nl3eArthwNydAnHdFaAiJo/CUbHjkUhtFGaU
	ODUzTlMaBdnah3d82m2EWMOhrjhGX9MYvXylSS8O0q49iYB1A3Uqlb7gnh5BrLYg+U9euu
	LwO21TIr8GuAxUKluiz4gmo++8GNFZs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793061890;
	b=wDS15ShJzfU9jvtTduIYNYypf9YGxwN/aCQL3i2gL3bcD80DRmkGbQUW+MzEDcuf7x2K1b
	xG6Cy+4z0t+Q0iCntUaaThjq0U+gDcs3AXJ/qKkNvUtJf811+d0upSCY8jCA2smrFlW3eR
	NrcAShOgoSevvgNlJ6Mop52pmYefNQU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DCQ/L2bM";
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E9E7243F0F;
	Tue, 27 Oct 2026 00:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B61E1F01825;
	Tue, 27 Oct 2026 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793061889;
	bh=JxrlTFF5NKiqGXulyA5fyoXEffuwPVdQDm0tPRVW1I0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DCQ/L2bMnhllG4DH6VfKqL+IXI5XrzYmev1zVmcUIsSe2qqbm6dUGN17cwgj9tmgV
	 toFjmQs/5927eHbGpH6w0l4Tg0xJAFiPOM77qgNt0b7FKf+WYPmJuA+to6U+WGvYXo
	 bpBt24dp21KGmr7pY8/LHPhVrWWLj/Pvq0rWe6PRi0GxEkn5F2LkaK4bqr/MLIhZ7e
	 OaIIhrZZtQtS/36HKzgOgHjL0UEjs8aQUGTQ7Zr8GDPnxT0CMOO5xxWgoyvfSiueIu
	 F+Km72zdFthWusyhnsvduY7clWkpX3QGYnyGkWYNwt2Y/RKGKsjDJmxnRZHaVpxb90
	 8pbbIAxkxfdfQ==
Message-ID: <sashiko-outbox-185967@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] tools/mm: rewrite show_page_info.py with modular
 design and new features
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Stephen Brennan" <stephen.s.brennan@oracle.com>, linux-mm@kvack.org, "Ye
 Liu" <liuye@kylinos.cn>
In-Reply-To: <20261026-show_page_info_refactor-v3-1-cc74947cbb8b@linux.dev>
References: <20261026-show_page_info_refactor-v3-1-cc74947cbb8b@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 00:44:49 +0000
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C502E100005
X-Stat-Signature: k9hcngibbo1b8nzhu7potjcguy1yekut
X-Rspam-User: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793061890-52011
X-HE-Meta: U2FsdGVkX18HCVsiKqJ6nyktN92YFkLNcRiXgXj+5SzUadEgRqkQdjOGo9U5Jyc0QopdFmpRX1CkpKc45VKXEIMDsGi7HM6X4j8SiEtMHaFSqATH/hjaz6genj1PxVpTU4MNhQqcu1HmnShqHcY6xWsvy9AdzsgrcAhMskRcIFN1mdWU5NLCBS1ByXzjo5mclKhUSF1WJKHWOXh7LxLGuPx8L17eQ9EbntScZjrVQHKMzw+ynXA0AdW4vKtLTDoV+wcAjh+owNaKDmY6ZMbANBaTvMC46ggeAhI7LHUVU8zKByB41+JNbxfl/tk+pHFcVGXoMqf9rW7MM9UtNKg+lo7SJA5+fx7u827jIhnjUfsXA8dXKyiv/a9IGNNNNNtHCAW6NmucWLU8gr0rcaT6jhXLtrhOTaFB2dUeDyUpqResXyc0ZHa60+NQ6rNPhg7nXG3dGDrkXHq9ouA4Sa0G0RoTkepu1WQ55N7rNz2MnkhQk5Iu/JAOeEeGVoaSvUFPsA8JfT+Xr2N6rJfybgHkhkH9V1Q+oa0L3lhJLdYZezfU97/Ndrb8vj+1uVkqFM/ii2UpkAFGFC7MFBSeL6//LyUuNv8K0jaE238KULi/d7Ot9GqKqjJZoobSCWP8NAT/vlw66m9rVULOmHwPsy8BHZIFu0UclSl5SdvYa3V9Smonjake/3l8lxIb1rz4atSfjXYLUWV68ftVcIB4j19r60fRk86Gxb156n0zh/s7KBhj7bsEw9pmfmRAwbXu1c9NVzKNxZhchGeY/wIi52cYpVTk8y2VvhqXZzk0XeLSwWKb5R2lfE20+fo/ENtNRZw5n8DkQ7x7M0KjxpvngWO2Bs1NPPuOCC8tp44l7G32uz9bR97Q6GXijf2F/F5+OVCrfJOK0Xbjs8iX1eDzqLytjG4iHE3wc6tZ3z+GTLt03bxziiO3qOP3V3hgHQf+5mUZQpX7r5cwPOJkTS7PVhs
 zJeugWE6
 eEnHl+4RU51L0vCWJuIuIzscCJ8pH/n6WrYkpcT/ijNYNjoPvN7ljJ5eFCT0QiJ3sZdDgLpIRuo3UT5a8BY+EVlozw7n/XRt/mzWiyx98s6mgtoIVV7RML5h89bmLajZnly4R7DM5c1vwIslU5scDP/+TNaktrsYkdrI12yAlCuoNTD8/CS+ylJwOiXkOhCjWUPmoRf8IrxcxwrdIamdThrBQwzQIf8Of4LzdDgs9r2fZ8TzJVYPvzjxRUdZVnkoOR6HXIhb144nJ+5V7DRyCiGJXR6j7IOxgSIXP0DLPlCRZPDvb8QfsOs+MdQquNbn4vLE0pZWqfAsdygGG9bA2lnQpeWVIwmX7ZegyxEdE6kE2Wg+zgKIsMaX76icT72GXxdftIldBZHtmt++tK6CfX4Z2vD7U0D38pT3rSWZLnqgslgFmuUtXGdsAZLckZdVdDPtDzLJr90Gg3KiSunqEiw12s8Y2L3uWLLdY5sI9Ofp6SNcW+sgxDk1TXixrA+0zmfOwTSVZVneGK9GpVUIFAVlKrDEr1DL5127T4rkmSaJjvFbKl7mhNTyj/bUCLs3lvhvN8MLHsqNYyP5LUYothCerpbhd5aAn3/VSggyI+fQQxK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] tools/mm: _page_node_zone() aborts NUMA loop on NULL node_data e=
ntry
- [Medium] tools/mm: _vma_anon_pgoff() skips __vm_anon_pgoff_lo on 32-bit k=
ernels
- [Medium] tools/mm: _page_fields() reads overlaid _mapcount on typed pages
--

commit ec6f474f80e4b1d78e13f090397c77cad2bd92c4
Author: Ye Liu <liuye@kylinos.cn>

tools/mm: rewrite show_page_info.py with modular design and new features

This commit rewrites tools/mm/show_page_info.py into a modular field-collec=
tor
architecture, adds --pfn, --page, --user, and --selftest modes, fixes slab,
memcg, and compound page handling, and adds reverse mapping, PTE walk, and
zone/node lookups.

> diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
> index c46d8ea283d7d..4334094739035 100644
> --- a/tools/mm/show_page_info.py
> +++ b/tools/mm/show_page_info.py
> @@ -4,166 +4,902 @@

[ ... ]

> +# ----------------------------------------------------------------------=
-----
> +# Reverse mapping (rmap)
> +# ----------------------------------------------------------------------=
-----
> +
> +def _vma_anon_pgoff(vma):
> +    """Get anon pgoff for a VMA (vma_start_anon_pgoff)."""
>      try:
> -        print(f'PID: {pid} Comm: {task.comm.string_().decode()} mm: {hex=
(mm)}')
> +        hi =3D vma.__vm_anon_pgoff_hi.value_()
> +        lo =3D vma.__vm_anon_pgoff_lo.value_()
> +        return (hi << 32) | lo
> +    except AttributeError:
> +        return vma.vm_pgoff.value_()

[Severity: Medium]
On 32-bit kernels (!CONFIG_64BIT), will _vma_anon_pgoff() skip reading
__vm_anon_pgoff_lo and fall back to vma.vm_pgoff instead?

In include/linux/mm.h:vma_start_anon_pgoff(), __vm_anon_pgoff_lo is always
present in struct vm_area_struct while __vm_anon_pgoff_hi is only defined
under CONFIG_64BIT:

    static inline pgoff_t vma_start_anon_pgoff(const struct vm_area_struct =
*vma)
    {
        pgoff_t pgoff =3D 0;

    #ifdef CONFIG_64BIT
        pgoff +=3D vma->__vm_anon_pgoff_hi;
        pgoff <<=3D 32;
    #endif
        pgoff +=3D vma->__vm_anon_pgoff_lo;
        return pgoff;
    }

When show_page_state() -> _rmap_fields() -> get_rmap_info() calls
_vma_anon_pgoff() on a 32-bit kernel, accessing vma.__vm_anon_pgoff_hi rais=
es
AttributeError before vma.__vm_anon_pgoff_lo is read. For MAP_PRIVATE
file-backed VMAs with COW anonymous pages, returning vma.vm_pgoff uses the
file offset rather than the anonymous page offset, causing get_rmap_info() =
and
_vma_owner() to miss the VMA in the range check or compute the wrong virtual
address.

[ ... ]

> +def _page_node_zone(page):
> +    """Find node ID and zone name via PFN range lookup.
> +
> +    Uses prog["node_data"] which is x86-specific. Falls back to
> +    contig_page_data for UMA (single-node) systems. May return
> +    (-1, "Unknown") on architectures where neither symbol exists.
> +    """
> +    pfn =3D page_to_pfn(page).value_()
> +    max_zones =3D prog.constant("__MAX_NR_ZONES").value_()
> +    try:
> +        nr_nodes =3D prog["nr_node_ids"].value_()
> +        node_data =3D prog["node_data"]
> +        for nid in range(nr_nodes):
> +            try:
> +                pgdat =3D node_data[nid].read_()
> +            except (IndexError, FaultError):
> +                continue
> +            for zid in range(max_zones):
> +                zone =3D pgdat.node_zones[zid]
> +                start =3D zone.zone_start_pfn.value_()
> +                spanned =3D zone.spanned_pages.value_()
> +                if spanned and start <=3D pfn < start + spanned:
> +                    return nid, zone.name.string_().decode()
> +    except (KeyError, FaultError):
> +        pass

[Severity: Medium]
What happens in _page_node_zone() on a NUMA system when an earlier slot in
node_data[nid] is NULL (for example, an offline or unpopulated node)?

node_data[nid].read_() reads the pointer element from the node_data array a=
nd
returns a valid drgn pointer Object with value 0x0 without raising FaultErr=
or.
When the inner loop then evaluates zone.zone_start_pfn.value_(), dereferenc=
ing
the NULL pgdat raises FaultError outside the inner try block.

That FaultError is caught by the outer try/except block, which aborts
iteration over all remaining NUMA nodes and causes _page_node_zone() to ret=
urn
(-1, "Unknown") for pages on higher-numbered nodes. Should this check if
not pgdat: continue after reading node_data[nid]?

[ ... ]

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
> +        lru =3D _lru_type(head)
> +        if lru:
> +            fields["LRU"] =3D lru
> +        swap =3D _swapcache_info(head)
> +        if swap:
> +            fields["Swap Entry"] =3D swap
> +        return
> +
> +    fields["Page Refcount"] =3D head._refcount.counter.value_()
> +    fields["Page Mapcount"] =3D head._mapcount.counter.value_()

[Severity: Medium]
In _page_fields(), can reading head._mapcount.counter.value_() report bogus
negative values for non-slab typed pages?

In struct page, page_type and _mapcount share a union. When show_page_state=
()
inspects a non-slab page that has a page_type (where _page_type(head) is not
None, such as PGTY_table, PGTY_hugetlb, PGTY_zsmalloc, or PGTY_large_kmallo=
c),
_page_fields() still reads head._mapcount.counter.value_() and prints the r=
aw
PGTY_* bit pattern as a large negative integer (for example, -218103809 for
0xf2ffffff on PGTY_table).

Should _page_fields() skip "Page Mapcount" when _page_type(head) is not Non=
e?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-show_page_=
info_refactor-v3-1-cc74947cbb8b@linux.dev?part=3D1

