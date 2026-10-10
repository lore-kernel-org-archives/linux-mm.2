Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8942ECA6004
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:44:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A286B0095; Fri,  9 Oct 2026 23:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70AAA6B0096; Fri,  9 Oct 2026 23:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61FF56B0098; Fri,  9 Oct 2026 23:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 426286B0095
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:44:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C526AC072A
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:44:46 +0000 (UTC)
X-FDA: 85305324972.16.F1E1A0F
Received: from mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id A5F12120004
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:44:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLC1yd49;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791603885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9jIPl6+yPgGMdnU4k2Tdgn8WLjevkl4iMb4e9aDeR0=;
	b=vjdE630b8FpTR18peVJQvuZQW85Z1t4xk1nQdi5hUGmvDNYpzX+V2nV315TQ5ih1y2CWna
	/99eqAXU56IVgjuh8hTIBm92nRwpzwH+EQU759vZ+cVNgxsJ8RTgaVUvPzPt5amY3bFLii
	IZAflndp4TQ+x1DteyqJQVI4vwDGP8w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLC1yd49;
	spf=pass (imf29.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791603885;
	b=qK1vx3cetv0ZBL2VcPjmIos1AF87Iqg/ZSo+Yk6jCsqxcPcL0JNHph8R4w8g/hfVJeTmA6
	GTSqRqhbifekNtoYm1ZHj1LiC1fOJ2Xu6TWfMEV3bq7CVW7EJIfQVoHDeuXR3UaFEnYZ5m
	l8BnvW4BFJwmLAKSiZOxQ1BV/Z8JNfQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0fo0QMf0rjH7MV2/iuitzfDF1YtJ7sax/S4uxQhGa9o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791603883; v=1; x=1792208683;
 b=ZLC1yd49raPT2YE6fJK39fORSvmhoQ+qRo6TIfUNdICyeTRbOIPSyf7weuspuE38vRpSN4gb
 p6+0ej03LOD1jJNcm2KNzO7FGkozS57yvKefcmGG1STBSvbFYc8ZxVErWpNN3aCs/mFJRy4WJMv
 XBuUAQiDHwREqPS/v3U3almI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 468dd143d2755872;
	Sat, 10 Oct 2026 03:44:43 +0000
X-Mizu-Trace-ID: 468dd143d2755872
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 1/4] x86/mm: fix missing pgtable destructor for vmemmap
 tables
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <1a0f51d9-7931-45a3-ab36-e0642c199a37@kernel.org>
Date: Sat, 10 Oct 2026 11:44:26 +0800
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
Message-Id: <062E1067-B11D-4BF7-A2BA-C71B599A805C@linux.dev>
References: <20261008073021.2512665-1-songmuchun@bytedance.com>
 <20261008073021.2512665-2-songmuchun@bytedance.com>
 <ECC604FF-E74D-43B1-9105-A6683EEDE558@linux.dev>
 <1a0f51d9-7931-45a3-ab36-e0642c199a37@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A5F12120004
X-Stat-Signature: ndp8mg35nczd7tpwhzi6itoiw55ged4c
X-HE-Tag: 1791603884-69462
X-HE-Meta: U2FsdGVkX1+dDGYAgTL9AZiGnRSKQ980FMFFl88pAIso9H1N/B2EVQxckqiVPaISa4DkWAG/qLEpNhME4sqILWR8m+SKVWhA0Z0Zjk8LIyY/1GGEfveG1u8wGedwcfbvtGxwUrWzpNTWxBIrfmJFv17MLP/DfKpLWp1l97n3rh1oaGLg3d1Om9whV8/3f7tsUC9mgkPWhHD0bU5LbQPR+td0aX2Yq12TQq7nd6jC7Jk3hsUHij+WON7NsfcsoDnu7QyKeUakJcoOpL0sJki2Doz+bOhQK0fAWIwNvMgqfNSFqxwlpvdztVyMvcemboo5+p0A4PTF4L+qWEYFibSjqK8ipIR3Pu8Fx1abOVUqAHKR1kRvfgJFJ7TuD2VXZqMb4hbUCuC6bUICaxh3x9QJgTsyHrHMf+P1fpuVQemSc5j8kH4SfyVQ6EpKMRfrT0UshRrGhd8sO1mphsz++vqRIQE175YmFjLxjOQxwgDDOxV1PUMG2wTuBgsq/lhupXi1Upqyg9XEAaaEk+RLeZrRWkAWjVTlv/N8/8fGxAoSltGKsHfBPHG5Agp9B0sBR94ww87Bpi6q4hVXfgngpygSf85OXVsjir8ec9uX+UYYhBoTOL7Q4v5FAOmKY8Dog/FF8fpumfi+nfKagzPbdG3ebQIRaY7PgMbSYT/ZolmXidEYtO8WaH9cLibBGEaC2DVTW9z7mBLYkXimJmxW+PTf+IIpfLl8g7q1bAniy2nMasr38xmP+bb2yPBb707qXajwu4xSjBfXc6hXbitD16oKcmfw0Pw8IaBlruSEF8ltfli2Aa0j9ftuPSXym6JZqL/WyY8F2jxn0bd28HiEAzK9jUhLM7mCBJ6HB4COmGGDPIpSqsj9Wdn1ZUm0hbQgYvrPddpCqvb2vQOI11eyCgDw7oWiGu2RxHNtW48FPjOhuxR+Fb9MxOCig6PvKXPgkbZ9M03moVWKKWLO3HeiQan
 V8naE5/3
 magOYq5azXKeS1/pscutww/2JMO9QpHqRUSwrCLRZbP5qU8zWOQ6a2151z6X4I3kztvGeC933jxv7O3Bu/qf7wOteOdzZqq5luLaeiWgz/TFc0lBeHgbO5VY2IWz0UhCoelu2C/9lMl9nAf/0rODbNMnS+9iIQb91exbHRZHlYuQ2Q+YerpCUdBNyCNq0JiUBsT8K8Tlcy9sLqoMnIBuv75tW4cMsd4h0rmmJBryoozFfoIP88n/v6sfR09wSAsMQJyGSTnGXfflascD42/AKsarekQ5xmNEjCeMYhaSVTgFPXHMJMhqtuuKSi8W+fZYMTsnO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Oct 10, 2026, at 04:29, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 10/8/26 10:32, Muchun Song wrote:
>>=20
>>=20
>>> On Oct 8, 2026, at 09:30, Muchun Song <songmuchun@bytedance.com> =
wrote:
>>>=20
>>> Since commit 49f599666420 ("mm: call ctor/dtor for kernel PTEs"),
>>> pte_alloc_one_kernel() runs the page-table constructor for kernel =
PTE
>>> tables.
>>>=20
>>> HugeTLB vmemmap optimization uses pte_alloc_one_kernel() when =
splitting
>>> a PMD. Restoring the vmemmap backing pages does not collapse the PTE
>>> table, so a later memory hot-remove eventually frees that table =
through
>>> free_pagetable(). That path currently calls pagetable_free() =
directly
>>> without decrementing NR_PAGETABLE.
>>>=20
>>> Use PageTable() to identify constructor-backed tables and run the
>>> matching destructor before freeing them. Keep reserved and
>>> constructor-free tables on their existing paths. This also prepares
>>> vmemmap teardown for generic runtime allocations through the normal
>>> pgalloc helpers.
>>>=20
>>> Fixes: 49f599666420 ("mm: call ctor/dtor for kernel PTEs")
>>> Cc: stable@vger.kernel.org
>>> Assisted-by: LLM
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> arch/x86/mm/init_64.c | 2 ++
>>> 1 file changed, 2 insertions(+)
>>>=20
>>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>>> index 70e682180291..a3ea627157ab 100644
>>> --- a/arch/x86/mm/init_64.c
>>> +++ b/arch/x86/mm/init_64.c
>>> @@ -1003,6 +1003,8 @@ static void __meminit free_pagetable(struct =
page *page)
>>> {
>>> 	if (PageReserved(page))
>>> 		free_reserved_page(page);
>>> +  	else if (PageTable(page))
>>> +  		pagetable_dtor_free(page_ptdesc(page));
>>=20
>> Sashiko mentioned that kernel page table pages and vmemmap pages are
>> freed to the buddy allocator before their parent entries are cleared
>> and before the TLB is flushed, creating a dangling pointer window.
>>=20
>> That's a a real but pre-existing issue, I will not fix that in this
>> series.
>=20
> Memory is getting removed, concurrent access to directmap+vmemmap is =
not
> expected unless BUG I think. That should make this less critical I =
think ...
> (except speculation? not sure if that applies)

Agree. So, I will ignore this.

Thanks,
Muchun

>=20
> --=20
> Cheers,
>=20
> David



