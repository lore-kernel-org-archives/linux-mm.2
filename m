Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF60C606A331
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UDtQZH6p
Received: by kanga.kvack.org (Postfix)
	id EA4D36B05B8; Mon,  9 Nov 2026 22:24:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E750E6B05B9; Mon,  9 Nov 2026 22:24:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3A96B05BA; Mon,  9 Nov 2026 22:24:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADD916B05B8
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:24:14 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4ECDFC085D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:24:14 +0000 (UTC)
X-FDA: 85417766028.19.55ED8D9
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE4CBC0002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:24:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UDtQZH6p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zxg/oHV6c7bTdjTEStCmT/9znR1pi4716FSd95ju8o=;
	b=ZVDlayBGWG1rhke52G4AKT5L2QPwCaLiWYbe1QkIENzjMNW4UMWyu6XECvnR06gn1ZKUu/
	MkO63Y7bDMTGazy042U42d3dnnftwFkzp9x7GtBlsIgAaAvuaPkRQAmugJqDgHTCCnKW7Z
	2w4CYOmwfxurob6C46XPPPSukUJYEw8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UDtQZH6p;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281052;
	b=2EEZuHJ8cEe9cFSXkY7HZdgTx6lRUZ5RP4jTkylyWpTVfGz2zOSY0V6p1xk7dF40tA1cNR
	+eXj79+rOb+F3PQgVrn7CAdXWX6byVI38fH4Vp0k0xMGfSVajX374evMjf/XW5tGtLAy5m
	lFsW4Fzv3l8Glf6N9JuMJsLhO61gZ8c=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AOwIJhgzOk7txoq52yOkZ0HGi+vTCQjqFm7cTO02lc0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794281049; v=1; x=1794885849;
 b=UDtQZH6poI6uKc9PBSA7zBkug/rsyHxmlpAm1bxuO52q3FmBOJtGqyL0N6xYSmd/1nbqi82u
 Ed75jq8nw2GHFHymGG/axmW8r5qEnU02KMymEOqm1aXNuN/91qlV9LaovMO1a9QF5F6Qyx84jnU
 n4Ip9kwIiNXN4i5hnEgCpfa4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id ca01e065db3b1e04;
	Tue, 10 Nov 2026 03:24:08 +0000
X-Mizu-Trace-ID: ca01e065db3b1e04
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 06/11] mm/hugetlb: initialize all struct pages for bootmem
 hugepages
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-204840@kernel.org>
Date: Tue, 10 Nov 2026 11:23:51 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 James Houghton <jthoughton@google.com>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2C89ED4A-9709-42AC-8DF2-3D7691475239@linux.dev>
References: <20261109095807.41547-1-songmuchun@bytedance.com>
 <20261109095807.41547-7-songmuchun@bytedance.com>
 <sashiko-outbox-204840@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE4CBC0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: frtoczhfhx3uttqeath9tnt4x3gzbeo1
X-HE-Tag: 1794281050-776291
X-HE-Meta: U2FsdGVkX1/uaFNzZqUpMXkmnCuuXcOwU1YiOF2CEGjXB0znaiv+RpX0VophyG46wNhmgzBQo+G1CKkPVqQSQi/2/H1TqfXyEItdQS2InCV8v9mnhDUU/Lfy01vFqeclU6LJbf+VoktJQDMrpH1OOu6fNmIaMbK1awtDyJEb8zL4jvFkVFeElAROzpz6ZyvovsU0FRrVnqIsEZP1wzb0SD9/S6w8STv7T9Hz3J0xdCShSlWkCHs5QK5SiqMvhiCh16KufTSDswJgl88FvHkJWgr/eCyegKhnB25IDV4O9wPUBs1aSMsi2Xfc22QGbvICyTvq6RGG/qEkaen4h1rSxxQrhhGtNp8vlOHmj5jOodWbxl4JlVDqX9RS+TbkAZ2cYPRi5lXlINDbG/PkttMW5YXVaXQwE7kv6FTqgGZcFnBTqZhKEeBH+sJ1tycrLQBqggGEqJVl3kFl9qXvdP2ZqKoXx/v3tQFO7Sb4vhDJyIrQAQ6mxAlpx53IGI9XyHBu6SxRoQUDK2XyuwxeF920ThXDYAsLsIgyPJ87b61+eBDY9sqZZo4d7S3RKYds6/hWZGtj6XWT1qxjeJkyAoOkbY4PSuDx12OMXWMcZ9dSkLdRyxs1/FlM0YqlyfeJyiT1q5MZAzrRj9Zd3/Jhj03zDSYkvcWetScRW46cz4up/LYjOZl8+bpd0fN8qwhzzbyAuVAr7LeklN/rXwlwmcxSw8XQAJocsnD2+lT/5DlVBnkgMUSC75w1wwTQI9ilha+Anfgm3/hQLQFFCRGnPCCyl+LM7RUq8BY0nPC5Ww51ZcFOVGMYPFTnlOpSP96mw1AR7VdJMfZUF0hIkGAA4YYsZ/axi5QMsJXkq1POCAgSZ0TIJtfem2Hr4MxEGOHZe7LiliUeZrwQv/iYKtW8BJXoD1BX1Enh2hBao0hpzBplyLo8u7/bVQKE38oRE+weFRo4lWtEDyc0IBwLjASGMm5
 8UdHZ1UP
 RcbvdHqxoN661hCyuwPr3aksny3SImxCQanFhljc/8EXIcgD3lyqojyWE1J5fa1zROx1GCqv6dhqQpcFSeQ5TvyqwWFmTKV6pKjJ+ipzJoMgeVrKe9ncGFquV9SVLBNVrh6HTqkvP9XbZPMOvjlsw1zRC9ubHanrvcHbBMaZuN2xtE0ZjhtDkSCYUklzs3b+IcM5HNnU2+cW1dsgC5s++TeAGY6kWoCD43hLrRFxv0DQ/3AWF/x530V4pbgKTLBmZjOp6fOoAPndmacC+9TZD095wzsadOTId+RxCLClPnMHtxQnTh7e5r+ZhfXjDUgtC40/DHW54jRJUbmXlREbVcoMttz6BveeK41xB8wZ5cEL/NoGzWHlxRVDyfA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 9, 2026, at 18:43, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Low] mm/hugetlb: hugetlb_folio_init_vmemmap() wipes KMSAN metadata =
on
>  head page
> --
>=20
> commit e4e80712cfb9bd9a2f1df0a9b2aae1625edb6829
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb: initialize all struct pages for bootmem hugepages
>=20
> This commit marks the entire boot-time gigantic hugepage as noinit in
> memblock and initializes the head struct page alongside the tail =
struct
> pages in hugetlb_folio_init_vmemmap().
>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ff6f837b6df01..d2aaad235458e 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3216,15 +3216,7 @@ static bool __init =
alloc_bootmem_huge_page(struct hstate *h, int nid)
>> 		list_add_tail(&m->list, &huge_boot_pages[nid]);
>> 		m->flags |=3D HUGE_BOOTMEM_ZONES_VALID;
>> 		hugetlb_vmemmap_optimize_bootmem_page(pfn, =
huge_page_order(h));
>> -		/*
>> -		 * Only initialize the head struct page in =
memmap_init_reserved_pages,
>> -		 * rest of the struct pages will be initialized by the =
HugeTLB
>> -		 * subsystem itself.
>> -		 * The head struct page is used to get folio information =
by the HugeTLB
>> -		 * subsystem like zone id and node id.
>> -		 */
>> -		memblock_reserved_mark_noinit(__pa((void *)m + =
PAGE_SIZE),
>> -				huge_page_size(h) - PAGE_SIZE);
>> +		memblock_reserved_mark_noinit(__pa(m), =
huge_page_size(h));
>> 	}
>>=20
>> 	return true;
>> @@ -3255,22 +3247,23 @@ static void __init =
hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>> }
>>=20
>> static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
>> +					      unsigned long pfn,
>> 					      struct hstate *h,
>> +					      enum zone_type zone, int =
nid,
>> 					      unsigned long nr_pages)
>> {
>> -	int ret;
>> +	struct page *head =3D &folio->page;
>>=20
>> 	/*
>> 	 * This is an open-coded prep_compound_page() whereby we avoid
>> 	 * walking pages twice by initializing/preparing+freezing them =
in the
>> 	 * same go.
>> 	 */
>> -	__folio_clear_reserved(folio);
>> +	__init_single_page(head, pfn, zone, nid);
>=20
> [Severity: Low]
> Under CONFIG_KMSAN=3Dy, does calling __init_single_page() on head here =
wipe
> head->kmsan_shadow and head->kmsan_origin after kmsan_init_shadow() =
has
> already populated them?

This is a pre-existing KMSAN issue introduced by commit fde1c4ecf916 =
("mm:
hugetlb: skip initialization of gigantic tail struct pages if freed by =
HVO").

That commit already reinitialized the tail struct pages after
kmsan_init_shadow(), potentially clearing their KMSAN metadata pointers. =
This
series extends the same behavior to the head page. I think the complete =
KMSAN
fix should be handled separately for both head and tail pages.

So, I will not fix it in this series.

Thanks.

>=20
> During mm_core_init(), kmsan_init_shadow() allocates and installs =
KMSAN
> metadata for all memblock.reserved ranges, including =
MEMBLOCK_RSRV_NOINIT
> regions:
>=20
> mm/kmsan/init.c:kmsan_init_shadow() {
> 	...
> 	for_each_reserved_mem_range(loop, &p_start, &p_end)
> 		kmsan_record_future_shadow_range(phys_to_virt(p_start),
> 						 phys_to_virt(p_end));
> 	...
> }
>=20
> When page_alloc_init_late() later runs gather_bootmem_prealloc_node() =
->
> hugetlb_folio_init_vmemmap() -> __init_single_page() ->
> memmap_init_page_common() -> mm_zero_struct_page(head) (and similarly =
via
> memmap_init_compound_page_frozen() in commit "mm/hugetlb: use common
> compound page initialization helper"), the entire struct page is =
zeroed,
> leaking those shadow and origin pages and leaving head->kmsan_shadow =
and
> head->kmsan_origin as NULL (extending the existing tail-page behavior =
in
> hugetlb_folio_init_tail_vmemmap() to the head page).
>=20
> If the bootmem gigantic folio is later freed to the buddy allocator at
> runtime, kmsan_free_page() hits KMSAN_WARN_ON(true) and subsequent
> allocations from the first pageblock cause a NULL pointer dereference =
in
> kmsan_alloc_page().
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261109095807.41547-1-songmuchun@bytedance=
.com?part=3D6


