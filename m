Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B4EC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC27A6B00C0; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B950C6B00C1; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD1976B00C4; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0256B00C0
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25872120183
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:16:14 +0000 (UTC)
X-FDA: 84991059468.25.74DBF6F
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 31A0C40006
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:16:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etgzWdvj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784121372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srO3k5jRIT7j/Rini580mlp+14o/AyomRtsZhtG4hCI=;
	b=T8X9jEQJ+Pn8SI65ndx5ZwAVE7GAkmgQZN9bat7WFVpINzDt7t3N/Y4kn+Haqv5QYJvks+
	RpgTcUDStBPOUn/T4UKveTx9oYIQbtbDaurtAn/pvhA7/pMjXvHe8xPYxODa8IqYuChHSl
	ljm5JX7it9BG4cYJjKCsj1l8XoDV46c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=etgzWdvj;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784121372;
	b=ifFq0ql6pqlORfcI8JpwlRHIkpPh/NqzQPoPnwIejCsCV2cjIcVg4++6cZF4T16muFQOGw
	unXAFeR8VFbY0KLc7oyO2P/PKqsViJ8eDjaBBv7zM49JOMQJkCYpU3JaTkgL4hJvSvvifM
	hKyyz0ObcN/nFWMAOnyU9WLz/K5CXAE=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784121370;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=srO3k5jRIT7j/Rini580mlp+14o/AyomRtsZhtG4hCI=;
	b=etgzWdvjNC1TMDtVDX+x9Q5g2sIxuMpIdwS50okxqRoHDutTxG5dTtClX8s+ENM5MZy+PZ
	qwhf+NGbyHv+Qkh3M07BQIC3pLkxfDd3KElnXMJj7tgajcptqov2RuWkSj0sMRJ3njeP9k
	MkpMp+Y15IHhczLN3FGWTbSYiqeq7+c=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH 01/17] mm/sparse: drop power-of-2 size requirement for
 struct mem_section
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260715103445.31b2f727@pumpkin>
Date: Wed, 15 Jul 2026 21:15:45 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <71E70E00-98A1-4769-A167-5F4CB59EC96B@linux.dev>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-2-songmuchun@bytedance.com>
 <20260715103445.31b2f727@pumpkin>
To: David Laight <david.laight.linux@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 31A0C40006
X-Stat-Signature: 5pb81bt9rpug86tjq3c6hcmsjrob35yd
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784121372-923889
X-HE-Meta: U2FsdGVkX19U8GEX8WSMYhN58o7NdKmGZCwzRtse/XXRz/lRy35x5vazx1Ne2LpP4qa7Dv19o1wpe+86enahDOol3h8IhuO0Sa8d6eBXzevjy/Ye4YiPfGGmbtfu7mVonyxcNwlWQ9Mc2E5PH0o6fUKOFn7ib7+Dqzqds9wkeekUnNGIihEPW2OPbMHjRBFG5hyoxGLamnPqZ2zYRJxtA0vtzN1Cdkig9h2atYkZbg+BgvMCMssl9yVGX3EYwb27naHoPU65IGxlAjlVH/c7DszSsPv5NrTKDfQZfuPk5yYPs9AwdwK1eveNYToYqsMcooC7Dw8zzRGB/bLyQ63uWld+EgtkJ7Nk1sgsf2cfxzIQkb1QMgOnf2857vkG2FMNJJbLVwyhhVoMBTfXQY2G8CQSM9yRn9Yeo8L7/+0dBJ72TcTxujdUGShRTnhgWA9wLCpYkmNyP9LCr4BTI3hD2KqTfDV8/dSC7EUTaeiaA387Y1CLbrb9WU7UJZR23cfjSu2tJfsapWAEKaaGbXI6exiS9I52aXKryzxKOe2795bv5s8/0eT5AukezuBn607H0+MBPu1Pm2AQFgzvq6EPomM0Wv0Uo3kqXTtjGDkKffxntSz/3kjTpWoYhK0+2K3k3Gtd8+wjg394GxbeavavHiu2lVJi0rOec/1ZnCO/ztrgvYPLuCRcvzoi73x2E0uHiXpIWlOc4sJTVNUtcr/0G0X0Xap46FB3KDV3Jz6qdXhqNF5lZgiy2ocEFK3gkHxla9AI2KmVsllklwkuGcPEExfANFHZPPX5zMiRY5QBcAUTdAUY3FhhKlpPM2mXFA0bE6/Gx3JTpuMXmy63Bjz4LDwba168fMNuMOlm9LFQCRX0rPY7tOnXKfo2Clw3yXcnAYg8Dyonvdgk5uA29LVPf1Mn9Ut7dlheMUejTURyuqJBi8hDVmFq7NwlReBesAoO/XO0K2spqLmqxPZHrSV
 ue/87tYq
 ssQ3sqC/J94sbTgKvUh/FuQd2VDq3pQxuOTup8Thg4WVSe9tSGwLu66+Xl+JVCrhx6mkUpEFGisA/kUy2gkXaGxo15D4/DdvW2B+AA1sC6LG2KhBwAICAASmjrlU7Xh6209DSm7wla/Z0pgtuDMYJBXazo7em/xKc9RlLqvP7u5rxKLGfc028FZ4i6aBOkmoOsXkiitAdKBBC9LyDTjGdvbkBdDQU3+Bbcp/dnrZ9JxiJBDv3LZLBN/HHYRFLkadAeVeIdUTvTInfCwdW800ASRoSi4nHLorPWcGm8NNKeC+YT7ozHTH3VVyDtL87i+X0GDuyYE1jpTC3/gpHrd6W7djHGpIURBXnaYfTpCmejUT9IK/TcI//9PG+7IV12v5WkLTY2NjsALs1i1JxxgxFk0kIKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 15, 2026, at 17:34, David Laight <david.laight.linux@gmail.com> =
wrote:
>=20
> On Thu,  2 Jul 2026 17:38:05 +0800
> Muchun Song <songmuchun@bytedance.com> wrote:
>=20
>> struct mem_section is currently forced to a power-of-2 size so the
>> section-to-root lookup can use a mask instead of a modulo.
>>=20
>> That requirement adds configuration-dependent padding, especially =
with
>> CONFIG_PAGE_EXTENSION, just to preserve the lookup scheme.
>>=20
>> Drop the constraint and use a plain modulo for the lookup instead. =
The
>> divisor is constant, so the generated code remains cheap while =
avoiding
>> the extra padding. It also removes an unnecessary layout constraint
>> from the type.
>=20
> This has a side effect of changing the size of the 'section' from
> PAGE_SIZE to something 'a bit smaller' when CONFIG_PAGE_EXTENSION
> is defined.
> I don't think it actually matters, the allocation is done by:
>=20
> static noinline struct mem_section __ref *sparse_index_alloc(int nid)
> {
> 	struct mem_section *section =3D NULL;
> 	unsigned long array_size =3D SECTIONS_PER_ROOT *
> 				   sizeof(struct mem_section);
>=20
> 	if (slab_is_available()) {
> 		section =3D kzalloc_node(array_size, GFP_KERNEL, nid);
> 	} else {
> 		section =3D memblock_alloc_node(array_size, =
SMP_CACHE_BYTES,
> 					      nid);
>=20
> so the size might get rounded up to PAGE_SIZE anyway.

I'm not sure I really understand what you mean. You might be asking =
whether
the reduction in the size of the `mem_section` structure does not =
actually result
in memory savings? If so, please let me explain clearly. As you =
mentioned, the
size of memory allocated each time here should be PAGE_SIZE. Before the
modification, one page could hold 4096/32 =3D 128 `struct mem_section` =
instances;
with the modified code, the number of `struct mem_section` instances =
that can fit
is 4096/24 =3D 170. Therefore, the range of memory sections that a =
PAGE_SIZE can
cover has increased 32%.

Please let me know if I didn=E2=80=99t get your point.

>=20
> I also suspect that '% 24u' might be enough slower than '% 32u' to
> generate a measurable performance drop.
> (It doesn't matter whether you do '& 31' or '% 32u'.)

David, I agree that % 24u is slower than % 32u =E2=80=94 the latter maps =
to =E2=80=98and', while the
former requires a multiply-shift sequence. However, since the divisor is =
a constant,
the compiler should uses the magic multiplier approach at -O2, which is =
~3-5 cycles
instead of 1. So I think the per-lookup overhead is real but small.

Thanks for your review.

Muchun

>=20
> 	David


