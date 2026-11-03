Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E92606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QHK18UtU
Received: by kanga.kvack.org (Postfix)
	id 143186B05BE; Tue,  3 Nov 2026 03:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C866B05BF; Tue,  3 Nov 2026 03:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030DE6B05CB; Tue,  3 Nov 2026 03:20:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE5686B05BE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:20:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54CC21A0335
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:20:33 +0000 (UTC)
X-FDA: 85393111146.23.87C9E41
Received: from mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
	by imf21.hostedemail.com (Postfix) with ESMTP id 33D891C0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:20:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QHK18UtU;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694031;
	b=hA+Y74qkekInbafkpDOJCS/bJlDuKBcp4u59qr2cWNEPy0+Lw4md+flotJk0sIOMaf+TD7
	RQzQAHz8L5mwp1hnivUIHZN6f0CSUlkAFjN9EeSQPwqFh17MILHPuZkNv+78udyNk6H35a
	uqu7805dRgmC7IG9lOHf9mJ14ism7GI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QHK18UtU;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.23 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zCkHC4ldGehHgXmc8PYBcbJF+ptQMne1mLzrRO9u6FE=;
	b=J7TZdJ2TawRCutoGXSWMVSpJfnI2X7zR7XfoMBlVWA2tJbGL/e0ZNT3hN4TQXzbXpOox6k
	KYRaKY2GYkkhCtIBG/UDJSKWGauNrGchUFyCgNreCD+57hZ5u3GGrO9/evE/oj9ihCnFVu
	/znEuUxTBXgbLCBW9XJI0GmhZjcZsFU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7sNvMkbEx+a1OkL8MgmFgxz6woP3TroOTg1/h23FhUQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793694029; v=1; x=1794298829;
 b=QHK18UtUyFjL6+OUFWeKwTgo9ixBKwumR0nZOBLeg61m+PLeHC0kXKGBRRLnhCyNQvMRAG+f
 7re6sXizIs92Vv9iOs93eayGillaAvIKFPkPG3KA0xrSwGFxonC2dxwf5PdOEn1Nk8QIfuLQbWd
 0Jlf76yMhvljXBWEYCs6OPhU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id d5aaef5f702bfade;
	Tue, 03 Nov 2026 08:20:26 +0000
X-Mizu-Trace-ID: d5aaef5f702bfade
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH] mm/hugetlb: fix validation of unsupported HugeTLB orders
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-194806@kernel.org>
Date: Tue, 3 Nov 2026 16:20:08 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 WANG Xuerui <kernel@xen0n.name>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CDC3B454-CBB4-428D-A97F-B3B8414BBC07@linux.dev>
References: <20261103023831.1805473-1-songmuchun@bytedance.com>
 <sashiko-outbox-194806@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 33D891C0005
X-Stat-Signature: n9drnb8csckwmwb1igkc54gdpe6mjhor
X-Rspam-User: 
X-HE-Tag: 1793694030-158088
X-HE-Meta: U2FsdGVkX1+M2hZBYKpg3kJ87sPEIcYWUJJr5t/1EObpiQ7b8bbZUDFHZbDVICR+PpIVy0Wlmpz9rBVF4/O5VVSSwZNTX2HLd9mSc+DBt0LQH9OMPQprHETl6OS/VOJcREoeJ7h+mVjgWsTk7HPb3jDsX98iKLcmvTUy8qCKoxBdLMIFSGh5A0bVALNSmNeF47Vwq/5IsPKIyTCSKQNAQ0MjNDKbxuKBoJj23YdJV+5+1t4OTGEnq/OzkQGJ/xmyeBE4UoM4z4+6gqjnIexuw9JUPz5uPHLoYbIzCAQZTy+JlXfhJBHhq5eLYelr0c68ZarqwWxfBkqJZ+g6RlJRDYtTUQb/YjE3PDjZEQ1W5YmHp/43IpeVBXDO1SrceLlxHuUaAjf230GcQL+ONi+biIjwruKVATExNFIDsh/H99Qd8t7H38xj9//MNsqffnr+qVzKqvIDsojjM8yAdJCuAk5ETyujtbcrD67kYiGDf07443Rsdwvvqyxt70dERHyzOTehm4JT/bsWo0WTTtEcrHgzhvA70KWuSwcGukb4BBYf5loMgeZB3DjeY7kYBQISgP42VZMOi2BpFuDs8/eJ7XjAh+AXNERkzheGDfK7FlOgZLpkYV/rZTwbmUbQMxD49ApmykGuY2McIzOkycppySz2Je7CCMiU7GTjMFaq8+W3sI7HeRE9AHQsasi0YNEswxmYLjp1R0woidXAtdRFBBHvkFGWnGNkMppAfwljQV7o0jNHlthyetcc0lSFrQH21F1QvwZG+f68OxVP1uk+hNe/VMrnlFwcl5DicqwpZOAXgC8oJl+t3XdnWHbcNQVX05sUze8HfXbfcKSIxzMQzJP2G3M159d6aNQkwj7eeIhZUg8ISsm+tS06JS1JyjdykZlsphIFS2bjUUEp2AsHEuf2Q7Isida/qZEZZRyy6Ajziid2kC67S27piIi3lmWaxIQFNoAgdfSOohZgBq1
 CMukiAZ2
 zxAitekjUdMKAdp1WowCrly4oHVySt53/yh5o6HVxjI8Np4+Nvc6xoYf2fxyXFonaWd3wCrWDGfD0i/cSRfAnOqo0bBtW1xrQGTsJE0wpLKP9RZApwSR48NVadr3HUfdc+g7taBybIJP3XxIQD5EBSo0EgwWNFmabf29/mIYcEeeZQ7y/pMbSUS166+U0RzeLZDzmadX5s3bkgIWSD9PG8YKmBeHDPNMWbmrc7G6D/LcnGanrY4Cby/W6VZEuWvo7ixtHWEWADNUUMQCZWxnW9IvmRFeivBgMa23OBCClG3QejKd7At+Hd7h6N32deAr09SrjLy/H/nzlnm9uBDmFTx7RePP9WdoaHBIKt1/130SpNYshiNjG2daoVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 3, 2026, at 16:13, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential =
issue(s) to consider:
> - [High] mm/hugetlb: boot BUG_ON() in hugetlb_init() when HPAGE_SHIFT =
is 0 on powerpc
> --
>=20
> commit 83959b12982c256d20ca0de51021b3beae201569
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb: fix validation of unsupported HugeTLB orders
>=20
> This commit replaces BUILD_BUG_ON_INVALID() with MAYBE_BUILD_BUG_ON() =
in
> hugetlb_init() so that configurations where HUGETLB_PAGE_ORDER exceeds
> MAX_FOLIO_ORDER are rejected at build time when constant or via =
BUG_ON() at
> runtime otherwise.
>=20
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index ff9dbfbc7a961..e21ac667694bd 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4181,7 +4181,7 @@ static int __init hugetlb_init(void)
>>=20
>> 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE =
<
>> 			__NR_HPAGEFLAGS);
>> -	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>> +	MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>=20
> [Severity: High]
> Will placing MAYBE_BUILD_BUG_ON() before the hugepages_supported() =
check in
> hugetlb_init() trigger a boot BUG_ON() on architectures like PowerPC
> Book3S-64 when huge pages are unsupported at runtime?

Yeah, it's easy to fix, but I'll wait another day before updating =
it=E2=80=94just
in case others have feedback.

Thanks,
Muchun

>=20
> On CONFIG_PPC_BOOK3S_64, arch/powerpc/include/asm/page.h defines =
HPAGE_SHIFT
> as a runtime unsigned int variable:
>=20
>    extern unsigned int hpage_shift;
>    #define HPAGE_SHIFT hpage_shift
>    ...
>    #define HUGETLB_PAGE_ORDER (HPAGE_SHIFT - PAGE_SHIFT)
>=20
> Because hpage_shift is not a compile-time constant, =
MAYBE_BUILD_BUG_ON()
> expands to a runtime BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER).
>=20
> When huge pages are not supported by the platform or are disabled at =
boot
> (for example, when hugetlbpage_init_defaultsize() in
> arch/powerpc/mm/book3s64/hugetlbpage.c finds no supported huge page =
sizes),
> hpage_shift remains 0, which hugepages_supported() checks:
>=20
>    static inline bool hugepages_supported(void)
>    {
>            if (hugetlb_disabled)
>                    return false;
>=20
>            return HPAGE_SHIFT !=3D 0;
>    }
>=20
> Evaluating HUGETLB_PAGE_ORDER before checking hugepages_supported() =
computes
> (0U - PAGE_SHIFT) in unsigned int arithmetic, wrapping around to a =
large
> unsigned value that exceeds MAX_FOLIO_ORDER and hits BUG_ON().
>=20
> Should MAYBE_BUILD_BUG_ON(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER) be =
moved
> after the if (!hugepages_supported()) block in hugetlb_init(), similar =
to how
> hugepage_init() in mm/huge_memory.c checks has_transparent_hugepage() =
before
> evaluating MAYBE_BUILD_BUG_ON(HPAGE_PMD_ORDER > MAX_PAGE_ORDER)?
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261103023831.1805473-1-songmuchun@bytedan=
ce.com?part=3D1


