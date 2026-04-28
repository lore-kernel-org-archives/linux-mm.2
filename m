Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3054BFF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 07:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C676B0088; Tue, 28 Apr 2026 03:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD276B008A; Tue, 28 Apr 2026 03:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3F46B008C; Tue, 28 Apr 2026 03:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC786B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 03:57:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3595A042C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:57:53 +0000 (UTC)
X-FDA: 84707210826.10.89D0A08
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1976740006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 07:57:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I67jg08K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777363072; a=rsa-sha256;
	cv=none;
	b=lnOUmhLlpz+g4AWskIx8Gd2GZJZ+WEBvL6FLDP8bAngoGPj/nMDiEQOkZUSmEAw/1W/syI
	zVf/PlCl7lxeQgk5W/5YFXNPXh5R+2mOV3/8Q1/Ps5TfQk6S7KGeobuddV5x/8YXWl9cQf
	QFJaxb9PKp2AepS78jJsm/xEYSlvlrs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I67jg08K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777363072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UMRaGncdlPYxN1RUUBUZsd/r+eI8zgEI90AUf2jmcXs=;
	b=jR3ky3Q1qDbZmpwYxZuLjlTmiUZbeccSZ0+az5FL7mYEwy9mDGHbb4dIUBZY0tyfHuSCi4
	2L6siDAEjBu8Y81UbMBjQNBEg5R1UFj2TT27UQxq2phiVUQz/7BBCi15qg3U4SXgQSdoXC
	BiFN8l0NDQRvazg+FxzRo+d7gG5FUos=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777363069;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UMRaGncdlPYxN1RUUBUZsd/r+eI8zgEI90AUf2jmcXs=;
	b=I67jg08K9MTWM+Rp0bC6VtfePNqxPPzYzJsPNEI3p5ur2b9K7XYdnKpkBR9fRfkr25oVEB
	n7JBacRYfngy9IR6h1JqBxK5g8RyaKSpCCjzpueX4BqCLTDPbfnWzDTLB54qC7dANsXAcZ
	zy96Z+6MjUTC8/9l1AerSvNuUO+cALA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBilACQByFLa-hi@kernel.org>
Date: Tue, 28 Apr 2026 15:57:23 +0800
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
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C4BACC0-0BEF-4F38-BC8D-1B2A8584AEC8@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
 <96DB49C7-A7C2-4F53-8321-FF4A4ECDFF95@linux.dev>
 <afBilACQByFLa-hi@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: uynakpa6bmodw1nw7wgzpmrzgbeewkn4
X-Rspam-User: 
X-Rspamd-Queue-Id: 1976740006
X-Rspamd-Server: rspam07
X-HE-Tag: 1777363071-619022
X-HE-Meta: U2FsdGVkX1+Zj51soBKT+GCjEZucO6xXuqJIC/u4nrpdCMF+K2wN4VuFqp1So176hI278HLS9I0adTmMpBvdMRSylC+Ym5hP8mo/Bi7lTfpFJv2eUq7l06K4NdZ0+X90lzMZLO33r2VLMczN3Au9guJ2wLkY8WwxVbG1DkGfICfkYPDvab58A2SjdvDFq5bfPEMjQ6pUNbzGYbbHCAtItpSNhU0DaESCrc9BiU82OE3k5ub48hfJP5/ygXteBEOoFxD7TcH8+2X3SlKfJFnTBROqlBwsdBK3XLRsLFlx2EXfFCb1JByAPUK3pshpH3eXjMHIGCDdax1WYFQjKtxdAij3wUpw0hr8C432YG//QaTr6UKSD6ebty3fzeZXO5dy2lLnCp1OLnwsdfYVftfO4Krv5zAOh8BS5KnwomqhlLXYq4lJNQKYVkvjwoVCqJbJeWFvEBw/ueV2IViSg28zFXXv4dtgeOdTxDcCo1tsfQS4kyVuPoIBpuvT0kqss5CjbUqsH/WO0AsDeveqDGTRwh9Omcvwd5guBAwenWrNHwoV9Ek4q+Z3ILqhX71yR4KbdnjHImDyMpvyAoIWhG+kZEUUwpy3mHsACngWz42GjgvsXRGFBE1P6BrRYiKBHC8OuAwH0tgxkJhU+zF7pVSxEaWfeWMCy18Y8HOzI6ZdNQZjlROQOuI4hXGShgXSgbz7I87Ja7TmMwkS5JX1+erEoTTlI9MKmIH3/vTcy35v99A1Z0X+YNj+sxVt3IYef6qghvbkjxavPlc6Mpl/ETfJwlSFEQkHASfgPyc/BfuTVoHPrK8wNh0ttlJrWflw9eA80H0wHDZzK4w1lFWsM3Y8vk9Oz8L0XZLC2RsMVSna5AmhGR6SsUrjVIBThk51rCqUVfpR5hFJ1+mr/jMzQZqw7nZHBon7km4yIGglcjNZAkb5fqkcza1RoOiFZfWuFgqBgoIplFztDp1BUVVmWtD
 EEmb+F6G
 LCbRgZwZ7ttducCbdSniJUjNxjNPmXxUtn6ry75MbmR4R+aRVpqigAvL63BZYVhhFVJwg0/pZo6Tr7fB66oVXkwLsWzm08IBobbSAJi1YdAkbkS7jLtjHlV4+j4AQXXpKrE0exaVz3Zkh0c+4B6YB3K+2PCg4e74XXo0pcprznKnANP//auLFkvnZEQ8rdk28B5MDHmyfAYyM864glxO1TEhTsrKUjsnSDrwwGNx07Xf6DX+zVxH0RCMT4QfP2foxakZiMT6w3XzMkiEXEpb+wvYsjfSZeSLdparwRWgpLTJtWCi3rERMvxGVNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:32, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,
>=20
> On Tue, Apr 28, 2026 at 03:02:14PM +0800, Muchun Song wrote:
>>=20
>>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>>> index effdac6b0ab1..5c12b979a618 100644
>>>> --- a/mm/sparse.c
>>>> +++ b/mm/sparse.c
>>>> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>>>   unsigned long map_count)
>>>> {
>>>> unsigned long pnum;
>>>> -  struct page *map;
>>>> -  struct mem_section *ms;
>>>> -
>>>> -  if (sparse_usage_init(nid, map_count)) {
>>>> -  pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
>>>> -  goto failed;
>>>> -  }
>>>>=20
>>>> +  if (sparse_usage_init(nid, map_count))
>>>> +  panic("The node[%d] usemap allocation failed\n", nid);
>>>=20
>>> Please consider using memblock_alloc_or_panic() in =
sparse_usage_init(), it
>>> would simplify the code even more.
>>=20
>> Hi Mike,
>>=20
>> Yes. I have several more updates for v2. Please hold off on reviewing
>> the current version to avoid wasting your time; I=E2=80=99ll send the =
new one
>> over shortly.
>=20
> Thanks for the heads up!
> I'll stop for now :)

Thanks for the quick response!

To clarify, the first few patches didn't change much, so your feedback
on those is still very relevant and much appreciated. The major updates
are in the later parts of the series, so I'm glad I caught you before
you spent time on those.

I=E2=80=99ll get the new version shortly.

Thanks again!

>=20
>> Thanks.
>=20
> --=20
> Sincerely yours,
> Mike.



