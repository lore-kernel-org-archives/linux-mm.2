Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7648CA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DDF6B008A; Fri,  9 Oct 2026 23:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DE46B008C; Fri,  9 Oct 2026 23:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3DEC6B0095; Fri,  9 Oct 2026 23:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8456C6B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:43:47 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1EA75A8393
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:43:47 +0000 (UTC)
X-FDA: 85305322494.23.B062601
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf12.hostedemail.com (Postfix) with ESMTP id D837140004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:43:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="knhHF/JD";
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791603825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPMsSbn+X287AkmXHu+Myu3LsKJD6Xma5zbMLCbaM+Y=;
	b=RDxF9uR/RsqhXfz9DkGk9NzXOs9wBM/Z7r9a6ms4obNWIgwXWR89xRax1U8O8/3V4GE9Nf
	1Ms4y2olv6u9UdEoXZQPbRz0jI4EGuKMgvhiohiaL/3Tj6EESDOHwdcB9ZRI6veg+P95MH
	nf4s33vDmv0IQilTGAllHQdqfY3xHOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791603825;
	b=HytAR2gwqKZBKELoqPQYekYMLbdExwNKEITAfmTsQOaGCuKunkOiYvZm2/UFRFUqDBkOXq
	L3YmSSikMFPlYMKW4euhRBR3Y5+yIVB7DlLBUsTnM3h72D02JX7MDzvEaBBklEOdJRwLbi
	3jV0iM95aFjt89k5qFxg1FdgfcfYrE8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="knhHF/JD";
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=e2Gg2A0pOiUOVFvGVHWV6wr7kkqR+muGcjituStXuzA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791603823; v=1; x=1792208623;
 b=knhHF/JDy9lkKxtZQnxgn3u7UyjAyvUOTckxSbLlK7a1iULv3C7sntUsb9k9jijBoEqjPsVM
 glo48k56/pu9rwM90gWWg3q6OH00dLjyEQldwtk9MV10cDWKYN/Fz1G82iksnDzUo8iWdJ3p3Nw
 lAciycb8CyOb7GiowS9UrO94=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 14bbb4f2a2970250;
	Sat, 10 Oct 2026 03:43:43 +0000
X-Mizu-Trace-ID: 14bbb4f2a2970250
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 4/4] arm64/mm: fix destructor for unconstructed hotplug
 page tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <d47bdf83-1db4-4601-a516-7e23488ea9cf@kernel.org>
Date: Sat, 10 Oct 2026 11:43:23 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org,
 osalvador@suse.de,
 dave.hansen@linux.intel.com,
 luto@kernel.org,
 peterz@infradead.org,
 tglx@kernel.org,
 mingo@redhat.com,
 bp@alien8.de,
 x86@kernel.org,
 hpa@zytor.com,
 catalin.marinas@arm.com,
 will@kernel.org,
 mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org,
 pjw@kernel.org,
 palmer@dabbelt.com,
 aou@eecs.berkeley.edu,
 alex@ghiti.fr,
 linux-riscv@lists.infradead.org,
 agordeev@linux.ibm.com,
 kevin.brodsky@arm.com,
 bjorn@rivosinc.com,
 apopple@nvidia.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DDFF90A3-86D7-42D6-844A-5D29A44BAB4D@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-5-songmuchun@bytedance.com>
 <d47bdf83-1db4-4601-a516-7e23488ea9cf@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D837140004
X-Rspam-User: 
X-Stat-Signature: 7muktugcy18kgsky6cx8g8sohx37xkys
X-HE-Tag: 1791603824-847699
X-HE-Meta: U2FsdGVkX1/MuMp1H8fO1s+AIyuJ2YpGyAsvvF9gBivqMVOPZC8jwnvYQhBvyIIVwOUVXMtRAIelJmiOavK+kjH5Q6Tl4AGfGfzFQaEtMbhgPWN9V/eMUNqEnPLOaVSdZfQ4ELXwkKYRTN42m54XDdquxd2xEh2Pf/w4V/FIEbByzv92usGb9BppGSA01TV0MAracpiQ3URHxcXqvedCVvRMkbIq0d6xZ5Fr4cD71cULdg/EhXp5+hkgJacq+QisGNcVcip9iFskTXm7l075m7l/DcAHoLAy6hgiHa6ahN7vfBPU/RrPwhbQMqp7ek+gg0AP4DU24T283gh7lbOfHoz1Kp2942aFtZTSjS7ztMLDA2UP4td7LdqPN7eRUe0aVFV6M4bVV3RK7zhc5Vv5fXo2/lP3OHkl/OURkcri3FoW0qFVZTokP+uUkqAv1/qbMNbuGOpzD6Uk6Q34vXrVHQHE2cbAhE2GZXmlBHfpplcs/a3mYSq1ZFnH5LNW01A0wl/ifM7O+T+/3Umb2e4bsLsdBabL9Z8wPOd2uLiyAWteCglmZymWE7ZLx6c9nrZvS4WFlRqx5tRmoly6bwQTzCPwnqr1M7ULKAKu0QWv1IUEVofMfd6v+fUbWA8RpmRY110VDjX2K/KYWLd+StCSqTD/Wpde3LkiMU54/STquXY5xsxQiVt1U3PHw4QjV27fUVlEohk7onrspeuG5+pwvYMRc+FXkRkPb7JSceJ0zjQzzh9Tx7sJ2nJpgr1hT5EjJWImO0AftJmw3WmhBImVNpSK8ilHbBX/R3lqTa+1u6DaDKFEorbOl3wIR/K+sXLRomIVG1r529vuG9kSgPAVfqLe9nAevF9TTBIMBX6qWToBqWIyw1htZWstlRjpWYsuuPkPATxaFJTeQxhVGzabgKJQ4R617ofWf5HdIrIWQSLAZ2tBABq0yPOqlKapTpHWFUBBcf6NVvDiJOMWi0O
 i+rxIwfg
 NF6a6Ozn6h0a90KIF4Gawx6HKLhmawG1mpzbBn5AKA4Rwd1iuVh3rOlVu8sIQlmjzyosIHehoKYOcJhVIWTATcepEBhzH/Zp2E5XUHqXv2s500lUBbr9LUAPL4y3nPqyFD0JHEDW1p7J4kwNBKxJjQu+mG1uTL09r2xvHLCnaK9YT2decb8nPgqq+wfqdwOarWBm2klAR7/sG2wEtD8RH7A8gE5/upRxQYBswN1YIFJCXzEwFZxhTq9nlCZocp5JBeItjh54gxLB9zJB0hCHjog750keWd2Dw4Rqh6Z7WxXCo3nmnDEzy1vcQQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:43, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/8/26 09:30, Muchun Song wrote:
>> Commit c594b83457cc ("arm64: mm: call pagetable dtor when freeing
>> hot-removed page tables") made free_hotplug_pgtable_page()
>> unconditionally run the page-table destructor. This matches page =
tables
>> allocated by the arm64 mapping code, which runs the corresponding
>> constructors.
>>=20
>> However, arm64 also uses the generic sparse-vmemmap population code.
>> Runtime intermediate page tables allocated by that code do not run a
>> page-table constructor.
>=20
> Why do we have that inconsistency? It seems to cause pain :)

Ha, yeah, it's a bit painful :)

I think it's because the arch folks didn't realize that vmemmap =
population
does not run a page-table constructor.

But the inconsistency is temporary =E2=80=94 I deliberately kept it so =
the bug fixes
are easier to backport. After those fixes land, I'll follow up with the
unified series, which will make vmemmap population run a page-table
constructor.

>=20
>> Freeing one during memory hot-remove therefore
>> runs a destructor without a matching constructor and corrupts
>> NR_PAGETABLE accounting.
>>=20
>> Use PageTable() to run the destructor only for page-table pages whose
>> constructor initialized them. This keeps the arm64-created page-table
>> lifecycle balanced while safely freeing constructor-free vmemmap =
tables.
>>=20
>> Fixes: c594b83457cc ("arm64: mm: call pagetable dtor when freeing =
hot-removed page tables")
>> Cc: stable@vger.kernel.org
>> Assisted-by: LLM
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> arch/arm64/mm/mmu.c | 3 ++-
>> 1 file changed, 2 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
>> index 7343ac9294f8..688b33095651 100644
>> --- a/arch/arm64/mm/mmu.c
>> +++ b/arch/arm64/mm/mmu.c
>> @@ -1495,7 +1495,8 @@ static void free_hotplug_page_range(struct page =
*page, size_t size,
>>=20
>> static void free_hotplug_pgtable_page(struct page *page)
>> {
>> - 	pagetable_dtor(page_ptdesc(page));
>> + 	if (PageTable(page))
>> + 		pagetable_dtor(page_ptdesc(page));
>> 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
>=20
> That results in a __free_pages() for  ones allocated by sparse-vmemmap
> population code. Are we sure that's the right thing to do?

Good point. free_hotplug_pgtable_page() is used to free intermediate
page-table pages, so pagetable_free() is the more appropriate interface
here.

>=20
> This is all so inconsistent and confusing :(

Yeah, so I'm working on removing these inconsistencies.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



