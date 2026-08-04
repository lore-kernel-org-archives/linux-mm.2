Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D9A0C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09F0B6B0107; Tue,  4 Aug 2026 10:47:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051916B010A; Tue,  4 Aug 2026 10:47:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9266B010B; Tue,  4 Aug 2026 10:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C80286B0107
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:39 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E63781C0049
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:14 +0000 (UTC)
X-FDA: 85063320468.25.25622C2
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf23.hostedemail.com (Postfix) with ESMTP id E8B75140009
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pENtFhKN;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXdQdLXk3DZj8XyxfTld1Y9wOF/hPoBLP3p20wObD2s=;
	b=Cd0lxWpZIbcw9OlFRwpfUsoZsmBiQjYjGG+5NkST122M1MZVFN2LpzpTdwFbAoZpb/4nuY
	QJQbgERypWmzUKkVgR1EN4KkpZGX/MexQLPemowXchTmznooULNVGfELW7Xa0EAMA1ywEH
	VzysU7TKTtDqIy4WcGyheBQHJ9UBmRo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pENtFhKN;
	spf=pass (imf23.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841873;
	b=ck+NhrMeuCT0dMOOh/Kja/w13vLbvNpqFI7ZtDf6ITXrbCNTzK9TVLkaZeTr7tytaEs8NZ
	UZXMlyhS8yhQ8KyDo8VoeEl8aCn6OeGBPLbh/PTS9QO5lxmYZliPAPR7UUhIlZiiG32nNk
	xNtJDP+ntcOplI8lAp6/sbe4ijjTgnk=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785841870;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXdQdLXk3DZj8XyxfTld1Y9wOF/hPoBLP3p20wObD2s=;
	b=pENtFhKNVLZQk5LpJk8jZHmxaccxVINc33LymFRkBbJY8kjTIhsyWiV7F4a1geeoeqDsr3
	hU9LqndipGiSVW6Dx9Vgs0uVDns4+LDEZpCaGP+k8HLGqY66bZv5Uq84a+/zctG5BjtOfC
	kHBwhDM6bQH3QOyNa4203XiB7nbXyFw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/sparse: keep mem_section_usage_size() internal
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <9314195a-2704-42da-8251-d2df618d630e@kernel.org>
Date: Tue, 4 Aug 2026 19:10:50 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <06FBFFEA-BFC6-4F97-BE21-0574FA3FACA7@linux.dev>
References: <20260804100114.16627-1-songmuchun@bytedance.com>
 <9314195a-2704-42da-8251-d2df618d630e@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E8B75140009
X-Stat-Signature: mntq438awtwegr6yq55cpcqmkx3ynbwq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785841872-372191
X-HE-Meta: U2FsdGVkX19ubyvoifPVxFsLVhCMuQrIFh5pwNeaZ+gJcaTZpZxOcSGmqgMaPok0Q9XeGGH0ZgCabal+0iae1XEU0KsMsYCanjEb03qcrnIFgu1HEuWuLgu6Eq70tLJmq5d2Pc86QUsa+WpkJcoIhH8pcTrPASQmIkcmizUryNoPq7BcScp3S7scSTRC5kkgP4BfDutffswjGnTn1IPOdYaodcA1LYr9LPeftu8Y2zPheT2OCUyuxSKl1dnuh5sRwEPEvg7ToV6gl9BjYTReKagymnbbEaYOtY5vBOOyMZm41y8x3+Z6XSXBshZo1NDj1HSxoI1M+U2na7F9y444FcIh40eoKbqEYQNN5hOojfOFk2+kgH19nxfBzXa91bskcUOarhPd5chQutgc5BMqoZ76+gnBonFlosv9y1TiZLLF2vHnu/YTW+WtbSu71FmJ5oSKAgOjXYZMYfkDl//KUtU3AwIbOOAjIxv9q7grBWNtNWq7eyxYS61nXXiDeCBH0n9KOOkA6xXpTxLsYRf9/+nivnxbE7EgkgZvrCdz0LuolebRqNfNcLkQm91cMNpBZ4E++chhcg3rdEUQ5rtdr7r3T/Hf2cB4pkc0YX3KfSiYjRWihilIj1KpIt7ke/IFpUNAjGLbDeP+GelB24g6x6fLSzoOsAJ2xwMEetFfr+2xuwbBfxEtE5LBojHtAgZ+/fo5COuGutTCmQzemxHcthd/HC/mRNHe4X1Vqq7/Na7O5xsUpSUSukUd0WxC+8yLHko48r36qLP+DkBUepQi5DIT2sIWYNaEsayWMo7NQeWZ4H+ucCDOZg4DFcRtoJjNI4ylLIa5YKHdHKjntHbh0B6EjnqvLKslVCkjk9XX9RCzPtPB1TYr+Y3b0+YXHnmSxtq/ay0g8ac2cTG/tnPK7D8AzVSs1OXi2iCddTKInhQebIFo7fGlbHkxyCpzoJ7QFPLRP40gVnCXZfEeKrI
 Jnn8BiyS
 R91f3dK0TeWVHTOjr1UKNzyUDpKl79svz1gMRKxmDOKeGvGrEXdK2xkZvGGXhgPcjSD9HRYZSRrEqV9w/PAVuHiNY6WcFI0caeGORl+6vzVz5oNHkUiiUbQAOApyvdIqVulPhf/OxwfP5PaZeexHE7gNWuSnXp2xduiRbIUp7KNUhYpDPvwna4QWPGOx1lFBUDRYsnz+mepXToeARyTBrfirQPnHWsfHXQAgP3zvV49X4nPPeMdtpaI/8W54aIWb0Mh9A+Pve5J7peNiYmGON0CevAfo95oovPxdVMCqGOzvXqW2xho5rgdktZxHTEL3yZNjCsgQBj/mlauI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 4, 2026, at 18:09, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 8/4/26 12:01, Muchun Song wrote:
>> mem_section_usage_size() is only needed by sparsemem implementation =
code,
>> but declaring it in mmzone.h makes the helper visible to all mmzone.h
>> users.
>=20
> Worth mentioning that
>=20
> commit ae751d567baa08342e5e34b378b72a6f9b2cfada
> Author: David Hildenbrand (Arm) <david@kernel.org>
> Date:   Mon May 11 16:05:34 2026 +0200
>=20
>    mm/bootmem_info: stop marking mem_section_usage as MIX_SECTION_INFO
>=20
> Remove the last external user.

Will do.

>=20
>>=20
>> Move the helper to sparse.h so sparse.c and sparse-vmemmap.c can =
share
>> it through the internal header. While doing so, calculate the =
allocation
>> size with struct_size(), which ties the expression to the =
pageblock_flags
>> trailing array instead of open-coding the struct header plus bitmap =
size.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/mmzone.h |  1 -
>> mm/sparse.c            | 10 ----------
>> mm/sparse.h            |  6 ++++++
>> 3 files changed, 6 insertions(+), 11 deletions(-)
>>=20
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index a26c8b855222..86891163e0ef 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2070,7 +2070,6 @@ static inline struct mem_section =
*__nr_to_section(unsigned long nr)
>> #endif
>> return &mem_section[root][nr & SECTION_ROOT_MASK];
>> }
>> -extern size_t mem_section_usage_size(void);
>>=20
>> /*
>>  * We use the lower bits of the mem_map pointer to store a little bit =
of
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index 704a9dec2b9a..46458e5300e2 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -213,16 +213,6 @@ static void __init memblocks_present(void)
>> memory_present(nid, start, end);
>> }
>>=20
>> -static unsigned long usemap_size(void)
>> -{
>> - 	return BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS) * sizeof(unsigned =
long);
>> -}
>> -
>> -size_t mem_section_usage_size(void)
>> -{
>> - 	return sizeof(struct mem_section_usage) + usemap_size();
>> -}
>> -
>> #ifdef CONFIG_SPARSEMEM_VMEMMAP
>> unsigned long __init section_map_size(void)
>> {
>> diff --git a/mm/sparse.h b/mm/sparse.h
>> index 95aa031213f2..4960a17b706f 100644
>> --- a/mm/sparse.h
>> +++ b/mm/sparse.h
>> @@ -47,6 +47,12 @@ static inline void __section_mark_present(struct =
mem_section *ms,
>>=20
>> 	ms->section_mem_map |=3D SECTION_MARKED_PRESENT;
>> }
>> +
>> +static inline size_t mem_section_usage_size(void)
>> +{
>> + 	return struct_size((struct mem_section_usage *)NULL, =
pageblock_flags,
>> +			   BITS_TO_LONGS(SECTION_BLOCKFLAGS_BITS));
>> +}
>=20
> There is struct_size_t() that avoids the manual "NULL" trick.

I hadn't noticed that API before. Thanks for the heads-up.

I'll send a v2 to fix this.

Muchun,
Thanks.

>=20
> --=20
> Cheers,
>=20
> David



