Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61846606A682
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rZs7aKch
Received: by kanga.kvack.org (Postfix)
	id 7F48C6B0685; Tue, 24 Nov 2026 06:18:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5796B0687; Tue, 24 Nov 2026 06:18:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BBA46B0688; Tue, 24 Nov 2026 06:18:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48A446B0685
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:18:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCB64A88FC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:18:31 +0000 (UTC)
X-FDA: 85469764422.03.C56195C
Received: from mta0.migadu.com (out-236.mta0.migadu.com [91.218.175.236])
	by imf19.hostedemail.com (Postfix) with ESMTP id 31F7F1A000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:18:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rZs7aKch;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795519110;
	b=j6vEX+09S0Hupc1n84Mbu+GxKN1t0Ta4f7N4JKDM3VLdQd805vhi41j7WwpwwcD7XM4I5e
	Jbse4XDxEFmvqB1/VYsEX1thVC//KjFFH95Xe99ySteGLJ/ugkNdptoxJM2uyfpVWz2RJ0
	DwHXvTd5yZQMT66Qs69W4s6l1tZj7B0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795519110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFTAQXzJPmG7VROXVdiQ9pfVfbpHSsS1PwNgCR+b54w=;
	b=dLgfz+xlw/GdijLBEKB6N8fMf09xZMte+SICtC4qWEbSujc2pEF/zn9vGO6/AhIBmcrheQ
	kbhkR/h0sCvZvn+qs8Y9b8YXrfrW1Py99XylCdavIwKn/7JWlhdSNs6ogCADDzEoBuguK3
	0MLH4BM5ksAahJJ1AOrbhqLJO5L2LDU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rZs7aKch;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.236 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=y42ceMjaFxWiqxybsUmhWAVQHVb2z+bt3IKEjNc/dFs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795519106; v=1; x=1796123906;
 b=rZs7aKchIvt6rQWUeIu97yVA43PUKrk9rqEJfkxTVEKOCwchQOVi8CGKUa3bLvQjVySnQPYb
 ehp/QKvi4NS4ZHprqajdTJv6k+VBMbqCH2wnCv7Ax478+dApBUHRFHujveieBzK7h1BihJinYHs
 sNsamAyMa1t72OMl0ooabWO8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2c945a36ab831988;
	Tue, 24 Nov 2026 11:18:25 +0000
X-Mizu-Trace-ID: 2c945a36ab831988
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 1/6] mm/hugetlb_vmemmap: remove the vmemmap savings boot
 message
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <sashiko-outbox-231028@kernel.org>
Date: Tue, 24 Nov 2026 19:18:09 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lance Yang <lance.yang@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <72671D69-0C65-4C1F-A685-2DEFEE1E9FC5@linux.dev>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
 <20261124110530.3004071-2-songmuchun@bytedance.com>
 <sashiko-outbox-231028@kernel.org>
To: sashiko-reviews@lists.linux.dev
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 31F7F1A000B
X-Stat-Signature: ftp1w97wrirf5k487z7ajm7nerk6gqf5
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795519107-638419
X-HE-Meta: U2FsdGVkX1/enFxb0UBheZp2TiM47l6oNnogSb+e4dIfUuhkMcBTIR8x3hfB7b6hcaqDPuC6I8Jy8n0DRO2kczl6dYV8dM5SJNe94uxRXf3q2OlNRUaRymnD/TzC8Xs6i9K799dW3VRp5fA0ozkxX91O2nN77K+m0+KuI1p3BbmoXenej/bVEc56PJk8MXX/mKitUpFYKc2WM8g7nXN9bH950mPcat3JokxnD6uCbk1SBE/Qh0SekDmL465rnL6qMRbFYmvvkNVHeppB/WZEo1qbilHh+fnUt3MMSY0Fk6id4q+ckCV3Q/++kZ76YO83qtFoXFwBtlDUjfHn9dKHOmTWBaV/KR9AeK2jThHkzZG2SfwI2Nlm5LNiuVph1uC31ZV1UoiEuwkdjsl97PkCI69QZdxlqEbVjW/aLLhToIzutN4Q8LXqsNcAMCIATRGSxuKzt9v1pI3l2NChG+GvfhHie+4r3K6y8HyrPpe6f3JdJirSWbYLpPIBWW0ZvYTjcmvRpiDwQ6jCAoHdcf4oMio3nM9XBY9Yku1EoTPyVRnciXTHL+mudcFK6EHAhj3dQxpSq1jAj2FxTiXVt6LPf9ONcY5x+535hWtvbfP6MvxTTi1XSxWcowkQxOVdOi1aYqhicLDeeE6qASaCeUTtpiWOYz40dpbRscRdWx9GRwsSCDS/rHA3k3w/8S6QAvbSJ2UYZGF5xzFhw+jpXx7YQgBoIAaNCsGTExB6d1LKm9i+GV8Fl5fLpkdMd0YIJz0MYVfFSviVidlXMtgc1FjZZBnmQBTnQmbaT0FJdFUF0oP7lqy7NmHaxEgZmLQuLF06IDNVLwSWT1Rjjr5FBU2pKE534IKUPq/7UP4uy/5jxwATXlYury9pPX2t513ViHjFPL6oQCGx5UV76l0UBx6sw68nEomKiw1DLtwi8ZgR6VB+aV78NBb+SM/Bh86PetF9oqYcEgNZ3VrHiMkqYya
 /5Tu6A5S
 MJZQLqRaqSvPGoHBYtlETeOEqHpYZ/Az58tdI/oMyn/s+9RPu4Pc0b7jDA96DwO97ZIUwiKAg8IQCVbwGTVftjAnX2Z2AQwMBkSAD0Gxn2SwP4ZNu7G7FQTrefgi84+I+89BZVsbgvptb134ByifhS9roFKvXavHmGgnrek9ceYi8PiyQALC7J0u63HZ/+YOTzCrNWIQgkVHBJ1KF8IWqFXRVYhjxtSM2EVEci3O46v4ij/BU5Ok/Bxfp23R2zI2WsvVEImtChlakh+91R8GZB4nx+fDVYg5gks8q/7Bmz1xcp8EH2uDNfmY67Keno9M+qtCKXB7isz/KjI6N2S8i2V+RlUIoKTpK803EQMeDCIWnmNaZ1Un937LfmLPrYtYr8CAgCyjphQZM4sCuuQmqGUcrIgTdSKYFc+QoJFF8Ee1ZghqArPrIwKTBYsm09j2Du2r/OVdH6LAoEmI46A5rXldTc1f8dg/zPzg/LT+sS1DIWwPfd5qi+Aa6w3qFBCE7Vlri5Gx+pGOsDDovGMkoO0FADMDpw7oQF/FtQC66DTvwo7T8obrXTCAQJhVOLeV8k79b7hIokLT4RPx+Di4+QEWCuIjw19m4tNQfzVN932nz0ZI1cSgSDPtxgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 24, 2026, at 19:16, sashiko-bot@kernel.org wrote:
>=20
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: missing const in !CONFIG_HUGETLB_PAGE huge_page_order()
>  stub
> --
>=20
> commit 852c6ee3c3138346a4a6991f35b8658e23f3cb65
> Author: Muchun Song <muchun.song@linux.dev>
>=20
> mm/hugetlb_vmemmap: remove the vmemmap savings boot message
>=20
> This commit removes the boot message reporting potential HugeTLB =
vmemmap
> savings along with hugetlb_vmemmap_optimizable_size(), and updates
> hugetlb_vmemmap_optimizable() to check vmemmap_optimizable_order() via
> huge_page_order().
>=20
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 0d5414392d870..b5b877ed5b92c 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -812,7 +812,7 @@ static inline unsigned long huge_page_mask(struct =
hstate *h)
>> 	return h->mask;
>> }
>>=20
>> -static inline unsigned int huge_page_order(struct hstate *h)
>> +static inline unsigned int huge_page_order(const struct hstate *h)
>> {
>> 	return h->order;
>> }
>=20
> [Severity: Medium]
> Should the !CONFIG_HUGETLB_PAGE stub of huge_page_order() in
> include/linux/hugetlb.h also take a const struct hstate *h?

Yes, and easy to fix.

>=20
> hugetlb_vmemmap_optimizable(const struct hstate *h) is defined outside
> #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP and now passes h to
> huge_page_order(h) behind an IS_ENABLED() check.  When a file such as
> mm/memory-failure.c includes mm/hugetlb_vmemmap.h with
> CONFIG_MEMORY_FAILURE=3Dy and CONFIG_HUGETLB_PAGE=3Dn, calling the =
non-const
> stub triggers a -Wdiscarded-qualifiers warning (or build failure with
> CONFIG_WERROR=3Dy).
>=20
> --=20
> Sashiko AI review =C2=B7 =
https://sashiko.dev/#/patchset/20261124110530.3004071-1-songmuchun@bytedan=
ce.com?part=3D1


