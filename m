Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01556CD5BAC
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 09:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8C26B0093; Fri, 22 May 2026 05:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A0996B0096; Fri, 22 May 2026 05:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD016B0098; Fri, 22 May 2026 05:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9026B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:05:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 175591C061D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:05:49 +0000 (UTC)
X-FDA: 84794473218.17.6E33101
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73C7740008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:05:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B49aNU7k;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779440747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NVGJAwjRYdYLDsgDMYCGdkDCjTx9lBBzpo10EYl6JA=;
	b=63VP0lOiW5mrZDexcM4onegFUkuLMl25tZQbi/n57Tng8VU9f1ykhJ8x0Uw9DfXiv36P9K
	ZnMVoojsH40rQRB2k/P1esRUOwGdcOlnvTdBem+1uRLjdsje7CRsL2wFIq3RjL/iRXYrQp
	jQG8igyGJ9U6b+v/CYM1/ENEpDj692A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B49aNU7k;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779440747; a=rsa-sha256;
	cv=none;
	b=7ezhmKeKMY60JilwnHfUJ/4j9TrmKoLyUS6xmqBXUE09i45yKvSEhCpDN7k/fwjkbVnEkn
	ogqa1R/pmAan6KWJnL+aeTWgltsAYp7zM3Gj9GXYInUYqaWLP6+yXskaOlHoCr5SO8HVq/
	Z20WCxFeoswBBwMnxJiHU0XlyL72RhI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779440744;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NVGJAwjRYdYLDsgDMYCGdkDCjTx9lBBzpo10EYl6JA=;
	b=B49aNU7k6CX1dZenwrn+rErfz6tvzbRfrKIkl8CoNbbMplacayg0mtXqthPft0rU8/bFpZ
	PZ3rd7X3CeHi5njAUJSgw90RlK8XzisAA7J9jS/U3TYejrLiUFpEQVX0Oz2l9XLPIihRrd
	S95uIFSihKgrGC5Zwx0FLO/KNTCWnJk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 13/69] mm/hugetlb: Refactor early boot gigantic
 hugepage allocation
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <177944019668.3663073.6529634450029926963.b4-review@b4>
Date: Fri, 22 May 2026 17:05:05 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 Ackerley Tng <ackerleytng@google.com>,
 Frank van der Linden <fvdl@google.com>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D8D2C0F7-7B60-46FF-BE1E-8CBF941D4744@linux.dev>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-14-songmuchun@bytedance.com>
 <177944019668.3663073.6529634450029926963.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 73C7740008
X-Stat-Signature: n7tkio1s1afjyytiy9tepzy47har837f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779440747-455291
X-HE-Meta: U2FsdGVkX19BmFzSVGioMTibW2rJhp5HLdgjWgj/E5FneNlgE2xNHcXzQyZQ4CO7fqw8BZPt4+KhXW31Um3g+KsQVjnTiDYJfQ+8F38iyLI762/KiIEc/6eo6OS437rmg83FKGgUSWKLipVaXnXginVDQ7EE129cGhtq/bUsozOBStWJHu1R2Rg18Cdk6jzqqUuI70zo3VLHlH3JF9irRGGIM9Eszoc8D/P822MojEOtodMfnf1sHtA5Xce80yjhymQj68YG5/+NkVcAJMC86ccMkTU6FDh4ObjhcsR08EumjRnnB8e/nxfVK7RxqMxV4IBc7e9paKi24kVqYkQ3ktjvZgE+QRyBf+q5D+tAYfxQWOZFSiyuP8Kz47pKZWXX4ifNWaWM1Q52WS1HSpuJMupAnGRbYQsZ80luAoWmeXXT6bScwwTHa9LFM5TTuqD4ZgsmIfscOxmB6U2GgERXK1OPEYo52OrGI9BxETTmd8x0+Jo4GiM3jHtOCMTwWQRO0ycoQxK16uSojEHxOC/balU50GIiKOHZeo8uZEQ3/iN5h3hg+US3zIaHge+sEKnNbm03lRYyCpAaaR0VkozfYCv/zJvp4si3GwMymoVr+Z9Kje1EZdSNmhxREXm7xors7vDWXeP1kQfUeJz6v6OO4YdnY3UhqqsQ8jtx7HpuMA9VeT/g2OKrFfpG5awt7cUWO3b/1QjvW+/9BshyPXvbomvFm35CcApeRnaXYGUF7ztYAtOKqfA9PXlh5npztIcOy3EFy+og15vuB7nlihLXHVlRMK3KjLwH6z/GsAIA4Hbu20154xBWnLV36gZB79gj2Wf3TyiC4emKwBLJYHh8xbennj9n49v2i1zppiLmYbVsjE50HwE9dMQb696wQLahC4xP2/acNuN0390+Om9QaliYxbviegI9UPpP4QElWLQ4dkUIYCqy46+9DtBehai13kaYxvUX9WaAzogapqJ
 q7a7zbH/
 VqOr8AmVkn14eRg2EPzBc+NPDF2dBpbksBPR77LydKXJuQbrSQhxPMoPiwXADgzHWNQyvLwSsCSUW0Is24anF2FypLfYMYZrjZ7leIyNv5k8nPGBkurqhUTHY7dD6vWWymB6QJtMxKIqqz8aTOZAELlhP/13oe3zJy4xE4YGyCsnLHzJn4NTEHjirwFyspqfW6YMcVfVbPGSEBhWOsveS3V1akZzfgSpTd128rGo1m/aM0MjPp8Vl1CfcDnkXlLqj1tahrhdegGc6UYmv9LljuEt9v58zBGph28GA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 16:56, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Wed, 13 May 2026 21:04:41 +0800, Muchun Song =
<songmuchun@bytedance.com> wrote:
>> diff --git a/arch/powerpc/mm/hugetlbpage.c =
b/arch/powerpc/mm/hugetlbpage.c
>> index 558fafb82b8a..ff8c5ec831bb 100644
>> --- a/arch/powerpc/mm/hugetlbpage.c
>> +++ b/arch/powerpc/mm/hugetlbpage.c
>> @@ -104,17 +104,14 @@ void __init pseries_add_gpage(u64 addr, u64 =
page_size, unsigned long number_of_p
>> }
>> }
>>=20
>> -static int __init pseries_alloc_bootmem_huge_page(struct hstate =
*hstate)
>> +static __init void *pseries_alloc_bootmem_huge_page(struct hstate =
*hstate)
>> {
>> struct huge_bootmem_page *m;
>=20
> This can be void *m and powerpc code does not need to know about =
struct
> huge_bootmem_page at all and its declaration can be moved out of
> include/linux

Make sense.

>=20
> Other than that
>=20
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

Muchun.

>=20
> --=20
> Sincerely yours,
> Mike.
>=20


