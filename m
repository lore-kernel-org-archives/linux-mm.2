Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D766C10F92EC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C83F6B0089; Tue, 31 Mar 2026 22:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978D16B008A; Tue, 31 Mar 2026 22:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E606B0092; Tue, 31 Mar 2026 22:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 779306B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:29:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942CE5946D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:29:31 +0000 (UTC)
X-FDA: 84608405742.05.735965E
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8B8762000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:29:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E184uyre;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775010570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+gopcYDxtZS/MQGedY6a0sVbuszfaaXXdUw6JqGvTg=;
	b=RL0OJoRbnxa6Mp/LxKMGvmi9w4XAYXxYoJWtwplz0ZXDlaWvShXXUs/iKhrjF+gMy97aFR
	krYeiPV3Xa5CFHDn4uIb7aTGyx+OK+Thu+wypZujJZSOA++N8aKDYqYOTLvKzOxzVvvgND
	mGx4ZKHD8v7mFdpf7tt8XHlnLcFhDOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775010570; a=rsa-sha256;
	cv=none;
	b=AuDwXJGLuF2Crf7Pjz+lIoxJvO9fbbk0s6fuNYdq61xUTXRksaVOXbAUveLf2c9GPC9uF+
	WjsmhXUn4lH4gvYMguAqA4gprNbD1tC7n044NHMmxBxnFGLXpmcsfpMtr5cA3T4beQvztY
	ZyyQzcisFAQ1MvkTq8F0nd2SNkZ/iKs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E184uyre;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775010567;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T+gopcYDxtZS/MQGedY6a0sVbuszfaaXXdUw6JqGvTg=;
	b=E184uyreOv+bMn3jPQ1UAdErOCUrE6k1+N1qtizL0LXUifPANyAGJovVuayaMu37IQE0MC
	m10n5cQ4a8X/7pCfoguypsbHG2jGz/rb4ysVeLi6Z+F5SYb0aA2TiKw+6cjr3TLlOdfpES
	lCy5ioMsijIYBDMdQQn7vTLP/oZW6cY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix preinited section_mem_map clobbering on
 failure path
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <81857888-b6aa-4f04-bfd7-e9365d62669d@linux.ibm.com>
Date: Wed, 1 Apr 2026 10:28:41 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Frank van der Linden <fvdl@google.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1ACF04AC-CC9B-4B29-8E3F-6609B5C1B09E@linux.dev>
References: <20260331113724.2080833-1-songmuchun@bytedance.com>
 <81857888-b6aa-4f04-bfd7-e9365d62669d@linux.ibm.com>
To: Donet Tom <donettom@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: dfw5xpocpk1bckrzr7xhqcipeha3tu3d
X-Rspamd-Queue-Id: 8B8762000B
X-Rspam-User: 
X-HE-Tag: 1775010569-595623
X-HE-Meta: U2FsdGVkX1+HJrcmFruSbh9Qp0Bnv8P+AuajXoWg5kArhH6grP5V86BW5XygDO56IwOlvh7OmAmRyMS/tkdeXUlspyrzmboaB8wr+EIx0IXOE9hVV0vaS4Ua+FG26Mpxi75k/MOR2ZQTf7upk9VBQHciKiHzqI4byAlC4vkbMdzAYTEGtfdnERw8LrO3CPQYx60/IZ8fpJK4e9i1yK0zCnpaXuAy+Gzt9ouGgHT7LCFvnYcZecpwx+oUSOLa9YBbJnCBOGKbPK22SKLjzw3xNIv7iL73swqteAifsDJVcCE/lqWe4d+oYs+wTFSLlZCFVdR7QLz+JLw0EpCg1qgwOi8daZSZk+DZiYXDztjdsRH1KIlhT9dJpkEE6xyrXR2pSJtE5s0QNzydNhszcGMnACQneLtosvCEk81vtFmAdvtAfb5cIl70O5GycGF4rKQiUuFd1jJsWu71FKVBLRmbz35Yxkn9beAWggshIISY4ANZHsw0L6JZgnjjS+QhigWzL5cG72AZ9Z5yjE7HKHxNGOi7aeM5n4e44y2nDvbuQx7H+nNUlwU8JBaXS3dpcoGP7HfOEi0yBQ+7DMtmFP2nHxZBJjeo6URxb98qdU/qy9x50jh7H5q/RuFEiU+JsXru2I09T0R77Uyi/bt55ejpfiN+IzxuFqGaUYCC2u+yx2zQncFf6H2d8oeWUgh3B35FyfOl7tSjBsVS3SqMf02DZwAjvg6Xj6E85f5RL+6pA5BGjiCyt7gYNnk4RJY2QgIvaQPCtJQL7vVCL4+8fpqhWugWizJ2p9fQjolQHnTbNvkSr6Aqz9hzuJzGnI700NAC4bwXKugJBTUDZhPjGHnaaIu00vKrQH9FujBlF/NrKyszVGdvtsRNhZgMjBiL9Q5+1z2UheO6buoEi6My+KzuSL+doJfl5xdxCRbWwDlypk2XhtOP25KR1sSQQPMvKi10ne6h6+twBdxWaoHiTb5
 n0CpQltY
 kFbhJybG1bpFlVw4nNv9c3AQSNADZwjXBxP2KJMtgJV/VtU26CXrY58QeyfRpJSmZiCV0F/XGwo+AATUJlDRNnU86hBCUvwArXbRipyyBTwwoeG0pHDPWENMOtZQXEzofNKgFHV0VxcInqdOrzIXQwK5w2KsV1k31KN7p4+nu0W8G4U4bseGkDW4x7wxWV5ePwTyIxfj4h64pWEUdyeN9YpU09XiBtgb3/CD7m2ACJBTB1xTnfeaXDOypbTzfamvSj4OUgP/gL6HbMzwfEa0Bufx6I17m7uZHreCa783ZCHyHsECTMSMCcyPaM6dwLQT2IbqxohSnae09N/A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 02:34, Donet Tom <donettom@linux.ibm.com> wrote:
>=20
> Hi Muchun

Hi,

>=20
> On 3/31/26 5:07 PM, Muchun Song wrote:
>> sparse_init_nid() is careful to leave alone every section whose =
vmemmap
>> has already been set up by sparse_vmemmap_init_nid_early(); it only
>> clears section_mem_map for the rest:
>>=20
>>         if (!preinited_vmemmap_section(ms))
>>                 ms->section_mem_map =3D 0;
>>=20
>> A leftover line after that conditional block
>>=20
>>         ms->section_mem_map =3D 0;
>>=20
>> was supposed to be deleted but was missed in the failure path, =
causing the
>> field to be overwritten for all sections when memory allocation =
fails,
>> effectively destroying the pre-initialization check.
>>=20
>> Drop the stray assignment so that preinited sections retain their
>> already valid state.
>>=20
>> Fixes: d65917c42373 ("mm/sparse: allow for alternate vmemmap section =
init at boot")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  mm/sparse.c | 1 -
>>  1 file changed, 1 deletion(-)
>>=20
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index c2eb36bfb86d..3a14b733bf71 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -584,7 +584,6 @@ static void __init sparse_init_nid(int nid, =
unsigned long pnum_begin,
>>   ms =3D __nr_to_section(pnum);
>>   if (!preinited_vmemmap_section(ms))
>>   ms->section_mem_map =3D 0;
>> - ms->section_mem_map =3D 0;
>=20
>=20
> This looks correct to me.
>=20
> I have a couple of questions:
>=20
> 1. As I understand, section_mem_map initially stores the nid
>    during early boot, and later it stores a pointer to an
>    array of struct page. In sparse_init_nid(), the struct page
>    array is stored in section_mem_map via
>    sparse_init_early_section(). If
>    __populate_section_memmap() fails, we are  clearing the nid
>    stored in section_mem_map right?

Right.

>=20
> 2. Another question: if sparse_init_nid() fails for some
>    sections, there is no retry mechanism to add them again,
>    correct?

Right.

>=20
> 3. when ms->section_mem_map is set to 0
>    for a pre-initialized section, does it only affect the
>    pre-initialization check, or could it lead to other issues?
>=20

Only affect pre-initialization. No other issues.

Thanks.

>=20
> - Donet
>=20
>>   }
>>  }



