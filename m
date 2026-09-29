Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C830CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FAA26B0095; Tue, 29 Sep 2026 04:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D20C6B00B6; Tue, 29 Sep 2026 04:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 712626B00B7; Tue, 29 Sep 2026 04:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB106B0095
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:22:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C9A8F80432
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:22:53 +0000 (UTC)
X-FDA: 85266109026.13.6D81FFE
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEA8180007
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:22:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sz0RinNF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790670172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zBg+5VBkyp2Y1TWNPP7zQmgWetEBkn4yYW+Phr6HGI=;
	b=TtuS+0L/HRCVhrS0kwN2r/4emEION6KrN3SdTTJYm7sNS5q54u7M9K+CIl8dspwpv8vWt3
	CqnWNBaoNAaIPMlM24x6G4McHyZcnrBLet+2RKiGvfBlEIrs+BYF1PCiDVbrLrIwc0Qh1S
	aFjXT5qR+HBqE69UnvSXe4i7obHvrP0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sz0RinNF;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790670172;
	b=Rc4W5PZVn4nAbMydGsZp4xORoAiBFe/liC+qC1pb1KVMjh9NefCKdZ1uc5+EZ7zuENhk5t
	rfXmNcTb8ZpTI2cyp1A1rHixktrUaMcxz+TsqcXINcByAtmsBWfdAeYEBg9ByH9UCggplt
	LePr+qEzSA8L85ciQzI3ylrdg9RWs08=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=on/JchLIm7ReTjkHsHsqt/RBkZgWaTOn8Aj08/8SF5A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790670170; v=1; x=1791274970;
 b=Sz0RinNFmiKdVAVddhMu3kIoX3ZxK28AKwddLyOdiX0cJJEgwsz5utrXn+KgFlmzUsIAn9fq
 U1KrdVB11KZb3o0NopaqAyq0Jhw0NupOCTn3A4ZP2TeSRUL66baUVhN4r8YkD0kk0egDPyTPW1B
 4sX9wI16Le8m2jpiqJti63M8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 94a06a54ff95dd08;
	Tue, 29 Sep 2026 08:22:50 +0000
X-Mizu-Trace-ID: 94a06a54ff95dd08
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v5 06/12] mm/sparse-vmemmap: set compound page order for
 device DAX
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <751f6586-625b-4485-9f27-409fdf38bf3e@kernel.org>
Date: Tue, 29 Sep 2026 16:22:29 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Jonathan Corbet <corbet@lwn.net>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-doc@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Lance Yang <lance.yang@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A77F22EE-0C10-483E-83D6-CC88D8485E88@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-7-songmuchun@bytedance.com>
 <751f6586-625b-4485-9f27-409fdf38bf3e@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspamd-Queue-Id: CEA8180007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zffn9axg8cbqha6wnp483pnzcdgqobw3
X-HE-Tag: 1790670171-352754
X-HE-Meta: U2FsdGVkX186bZ0a6Yl1X9CWTv3bH/Thn09z2qdwMSCvSNH6/v7qGKl+kMBQf4ZpRXZifthoSHm+XtZBDIJ6zVUT1oZVC3AwOFmLg1raH0hXb1Bc2kJv8J8YPJeO6pY/fUy0D9ojeYcb8jr7n6bMSKgIbFSfvnmmzVEmN78c5FykCRm9WCCtjvEcaT+IsOfLHiEjYbJ6g1wpSvxOnDkju5v0EqqrKvDh8IIE/RiFYfB9Nzvgb0wz6MdkSw7XSjvRbkpn2f7FprDTj3k/fWaFyM+g7pTDEJgtNv+ITCLJYMHvziCV8gWIkcwQ6p4ylI7j3puI85S0XRaGH2k5doDPgjBorCB656NWo2fDFrhBWDt8eIIDsaTcLuZVsdqD0PO7g0QiIgSaefDsHYeKH/vIshrGyuGNly+zVULISFCOZ2cZoO3J/Wb/qfFMwvAsUH3wF/PIiVAJAmoufmvqRbQbPdltBjVto+dvHGMSPxkmIxNaVh+WqK1heWCkskd712UzTycAMTAbHBnBtrXHTeqXZK6hVP1ssFGbmldNX60PAQDsEAFUO/TXfzjSKSpHAdwSQtV0v2y4eYFRC6Bn6mBZQkzhgj40gNhAHV9Jj5CPz1N34s5BXGJSDnuWB69AS6/mVr/roKvTJVoEzFT/sUQ1IpIlgl2Y47zradqDiVgo/pK6oa+KG6PRk7qrfP15VSiX0rW8IhmDuxhUDzAM8J73SHpysg7J9BQXxxqDmovT+lqUkGNxWVmDFQSw4hSGF5UL8x4a2JBW711AB04aIPFIZz+uRUvb0aJCEsKvuZ9SQ8FWFVDnJe/Z+DBKW/+5CBDKpWgP57oHfrjxepMghv1EFNbiOReHw0SHNcgetQBFuAYFihbcNp2VuFCMdKB/JSoBw2s0cRT+L3nX7HdIhxm7dOw9vsyX7EU7bJPkN1DSISLYyGDAYCQQvbPs+PgKi3Z5UO6wqTDmOozzMCpwvTc
 /ClMzfqe
 cSiWxgvntp0WO0vvejvpZQqttynSAiiVFY4zKl3/JDBpeWh6j/35n14Hn1bDWtn9YSwIBDlhLWh8tiqynGGLEKaHcp2DnJl2qepTESXi/ojZf42Ay2+LVOVI4K4vp62V0kLOeu2mBsvndoo0qmcJGjHN58V0Go80VxysZiEeimZWgCTtLq8Asm78HgzNoIJz4ZTGH4vdKDWknAzHaZllK+n1TslU7mkRsXUs7wFA6OOQyzwS5ssTtXFGycbuTTup4tBOEoUCdlIaTi3ZcxzgxHvZYbHm1Ry4dVFzql06miYz38E9Rvho0jjJrew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 29, 2026, at 15:30, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 9/27/26 04:54, Muchun Song wrote:
>> Device DAX can use vmemmap optimization only when a full section is
>> populated with a compound-page geometry. Record that geometry as the
>> compound page order in section metadata before populating the =
section, so
>> later vmemmap accounting and population decisions can use the section =
state
>> directly.
>>=20
>> Clear the compound page order when the section becomes empty again. =
Also
>> reject partial additions to a section that already has optimized =
vmemmap
>> mappings. compound_nr_pages() determines how many struct pages to
>> initialize with a section as the smallest granularity. A section =
therefore
>> cannot safely mix optimized and ordinary vmemmap layouts.
>>=20
>> Partial additions continue to use ordinary vmemmap population, so =
they do
>> not save vmemmap memory. Such additions are uncommon, and the lost =
saving
>> is negligible.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Acked-by: Qi Zheng <qi.zheng@linux.dev>
>> ---
>> v3:
>> - Update the subject and commit message to use compound page order
>>  terminology
>> - Use EOPNOTSUPP instead of ENOTSUPP
>>=20
>> v2:
>> - Explain why optimized and ordinary layouts cannot share a section
>>  (suggested by Qi Zheng)
>> - Collect Acked-by from Qi Zheng
>> ---
>=20
> [...]>
>> static struct page * __meminit section_activate(int nid, unsigned =
long pfn,
>> @@ -838,8 +840,13 @@ static struct page * __meminit =
section_activate(int nid, unsigned long pfn,
>> 	struct mem_section *ms =3D __pfn_to_section(pfn);
>> 	struct mem_section_usage *usage =3D NULL;
>> 	struct page *memmap;
>> + 	unsigned int order;
>> 	int rc;
>>=20
>> + 	order =3D vmemmap_can_optimize(altmap, pgmap) ? =
pgmap->vmemmap_shift : 0;
>> + 	if (nr_pages < PAGES_PER_SECTION && section_compound_order(ms))
>> + 		return ERR_PTR(-EOPNOTSUPP);
>=20
> Hm. Why should we support optimizing the vmemmap in case we fall into =
the same
> memory section as boot memory?
>=20
> In that case, there already is a memmap allocated during boot for the =
entire
> section. IOW, we really shouldn't mess with the vmemmap in case we =
have an early
> section.
>=20
> But maybe I am missing something and this is already disallowed?

Yes, this is already handled.

For a partial addition to a normal early section, after updating the
subsection map we return the existing boot-time memmap here:

	if (nr_pages < PAGES_PER_SECTION && early_section(ms))
		return pfn_to_page(pfn);

Therefore, neither section_set_compound_order_range() nor
populate_section_memmap() is called. The fully populated boot memmap is
simply reused, and no vmemmap optimization is attempted.

The check above handles the other case: if the section already has an
optimized vmemmap layout, as indicated by section_compound_order(ms),
a partial addition is rejected because we cannot mix optimized and
ordinary vmemmap layouts within one section. This also covers an early
section whose vmemmap was already optimized during boot.

Thanks,
Muchun


>=20
> --=20
> Cheers,
>=20
> David



