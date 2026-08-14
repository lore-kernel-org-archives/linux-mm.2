Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D94C5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79EF06B02FC; Fri, 14 Aug 2026 06:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756EF6B02FD; Fri, 14 Aug 2026 06:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 664586B02FE; Fri, 14 Aug 2026 06:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 460D56B02FC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:37:19 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C7EFF14040A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:37:18 +0000 (UTC)
X-FDA: 85099522956.19.75491FB
Received: from mta1.migadu.com (out-25.mta1.migadu.com [95.215.58.25])
	by imf11.hostedemail.com (Postfix) with ESMTP id D5C5740002
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:37:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A4dofpUH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.25 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786703837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OKQ5KPa7dB6PadOpOkfFoM7C4DfT+F8m/eFidCTkeQA=;
	b=GRwXd1TzWXYTYU8qlc4xsu1l927YhZg6DBi07BVSDbZ4BzkLszWHZ6AxcM8ZmF5F0fzaUk
	OcsGZbXknU4Xk9h1NBcNyvCe5YgCuGFd4F0SJ4fIaDfGoaC6JtRkDz5edi/nhasR/y65Fu
	I+ignTOeQQep0Ygiv2K2tMvMg9w2WSU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A4dofpUH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.25 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786703837;
	b=4EkWpSAikBo9syjnxYcuGLyCdHvpJySVKlKsQKTHr9z7wbDJp8uhLJ1SbGbIJgtj1T6n69
	ZdW5BKIUxbqsvx1Y4dHvuJo8WWCi1/ac7zEX6ZzqEiOzowu0E2NNBuGWFtEQR4igcA5cTa
	cjxzRyiL8rJyRWN7I//0+YcPmRaC9Pk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QiLSPI+MPmY1LDSvHHQGw63yDUWEXiMCfHcerMNBDt0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786703833; v=1; x=1787308633;
 b=A4dofpUHhchwEeUszJTtMKVFgOF0QiZa4aH2obDU7IdY9TPywGR5Ujlari6kW0Wyeuny0oHW
 DlEP6N+kTEiDVRJ+mHMV6vjiu3fV3I9XF38A2XsaN7HBoIaEINn42nmyMcEdiwfNbM0kb7jWVg5
 NBrl71rBvJlYK/i24YpyOodk=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (77.97.51.77)
	by smtp.migadu.com with ESMTPS id 61f550f3f67deb7c;
	Fri, 14 Aug 2026 10:37:13 +0000
X-Migadu-Flow: FLOW_OUT
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 14 Aug 2026 11:37:11 +0100
Message-Id: <DKOLND2TRB15.2Y8DKB3ZKEYAY@linux.dev>
To: "Yosry Ahmed" <yosry@kernel.org>, "Brendan Jackman"
 <jackmanb@google.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand"
 <david@kernel.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike Rapoport"
 <rppt@kernel.org>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo Stoakes"
 <ljs@kernel.org>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <x86@kernel.org>, "Sumit Garg" <sumit.garg@oss.qualcomm.com>, "Will Deacon"
 <will@kernel.org>, <rientjes@google.com>, "Kalyazin, Nikita"
 <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, "Itazuri, Takahiro"
 <itazur@amazon.co.uk>, "Andy Lutomirski" <luto@kernel.org>, "David Kaplan"
 <david.kaplan@amd.com>, "Thomas Gleixner" <tglx@kernel.org>, "Patrick
 Bellasi" <derkling@google.com>, "Reiji Watanabe" <reijiw@google.com>, "Sean
 Christopherson" <seanjc@google.com>
Subject: Re: [PATCH v3 13/26] mm: introduce freetype_t
From: "Brendan Jackman" <brendan.jackman@linux.dev>
X-Mailer: aerc 0.21.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-13-6f5729aa9832@google.com>
 <anJmOMqCVugycC9x@google.com>
In-Reply-To: <anJmOMqCVugycC9x@google.com>
X-Stat-Signature: w9ahs4bz9frg4zujspicb6tcgu73z5dr
X-Rspamd-Queue-Id: D5C5740002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786703834-199552
X-HE-Meta: U2FsdGVkX1+GXJNq+09GEGQMW6lQ1pJYm28XMBxziZ/S4411lN8YfhvfiSvj3zB/goUxhk1v9tu0xTj20LdvExtQCL5F2tUj8yAj9t6lRsjAU+FAKkBtOllBoSqKg7Sf41eYNlA/jvwdYnXvYWOw9zgD0jsIxHe/CRw/SqoszL2OCxZThEQQ9LqlMfsZ/kC2xE6ntdIUVz0dwFLdLvjBAVvqbtU9nkH2tVKwcuwFqF0elaECdld7GJoHPu6GwhLpUIBUJLipEtXHPH3HeoDLHyunLgjvYEO0xa5Cf423VXn+nEyAYPwOW1nGF4RLbkt2Ik35wt6nrbJ6/HmHJsa8vN97GdmP5Hra+6tsNr966/6YCl7vcbMsOdOYUx0NcKKd6w/Mro9Zj9duK2UMOlEW+FnZnvecpPu0Khau+rRIMXg7Lkkdmfh/Ry0nuq3GJTONcp54iMURQ9p3NFvykNNJzbkBu86/ygjAsaAMkLvSQNqDDHrj4u6cIlpBZZt9yWpmg4zSqzyaKOpX8A4Y3czu3EvshmsLXU/8G7XiQCen/rBW46tM/LwF4m4Fbt3PlvZr9ApR7WdSdK0g3Jfo9Tu5QRwCfl0qqp4v0Fy162z4ZEpsLNx+T6uT42qDSt7OZlrhsl5ZWo0BLghwIpDB4kJbmQhAsg7ERdd2VPbCYbkNIJ9fS5HblgHRSaWhc8+IjSIvzuWDqKKaS4cHBV8zUjsFrJucRo7ykLVszxCjQzER689lgB3ueNazN6j3T+eQChBsFvUZENpcKXTAWJ7JzeNy+BI36wcie9aXQdETfG1dVsiUqMeujybH7Sj3vd8qrhMYSkEMpdmT9efT0F8euh1kqSW+BZuupPT6BQ/iomgpOChH+FC/OTKjfSbt/InQBw9THtndJjfr1Ces34Cp5DP6CP/tCIkmRk81ogfBrlDXCZpGLJUmbdK+YGknvkccNiH1zCmlFmG8tq5/6UArSA4
 ZNOSqwi0
 7qum19qqs65p2wX+B6S1t7PEQk7UnT9qGoaTp6sGKszAQkO4oAYE9B/exFMulP1k70DCLjEzrTeo6gXwk+WKeP0XouAhgsaz8oKP7wzviwPs63fkP23Jkgs3o5inA/0HgPq5XihVvVOKlJGwWD72pfbuDSUeEScx5/0Jha9JuSN25jeeAY0AituhTnzDol2pRcAQUP4Z0wrVhIOgc9rNNk5xiSoW+LDmVhSOfmzoy67TFwvEZM+mwGCCHbGmK7QTOroga3E3+3kzu3Ucj676FmbSFaY6OJUL8azpQRph2qER3lu5ukag6cT0svaI36OQeYMj7b+waQY1FvFq5VLsj0zN2BjzEkylcyWWeeJcpjFjmb513AKytm0cMYz/RWjHu7QWAwTOqRUgINuESpI1lPVtt07AuTlQt1Lig
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Aug 4, 2026 at 11:23 PM BST, Yosry Ahmed wrote:
>> @@ -179,24 +180,62 @@ static inline bool migratetype_is_mergeable(int mt=
)
>> =20
>>  #define for_each_free_list(list, zone, order) 				\
>>  	for (order =3D 0; order < NR_PAGE_ORDERS; order++) 		\
>> -		for (unsigned int __type =3D 0; 				\
>> -		     __type < MIGRATE_TYPES &&				\
>> -			(list =3D &(zone)->free_area[order].free_list[__type], 1); \
>> -		     __type++)
>> +		for (unsigned int __idx =3D 0; 				\
>> +		     __idx < NR_FREETYPE_IDXS &&			\
>> +			(list =3D &(zone)->free_area[order].free_list[__idx], 1); \
>> +		     __idx++)
>> +
>> +static inline freetype_t migrate_to_freetype(enum migratetype mt,
>> +					     unsigned int flags)
>> +{
>> +	freetype_t freetype;
>> +
>> +	/* No flags supported yet. */
>> +	VM_WARN_ON_ONCE(flags);
>> +
>> +	freetype.migratetype =3D mt;
>> +	return freetype;
>> +}
>> +
>> +static inline enum migratetype free_to_migratetype(freetype_t freetype)
>> +{
>> +	return freetype.migratetype;
>> +}
>> +
>> +/* Convenience helper, return the freetype modified to have the migrate=
type. */
>> +static inline freetype_t freetype_with_migrate(freetype_t freetype,
>> +					       enum migratetype migratetype)
>> +{
>> +	return migrate_to_freetype(migratetype, freetype_flags(freetype));
>> +}
>> =20
>>  extern int page_group_by_mobility_disabled;
>> =20
>> +freetype_t get_pfnblock_freetype(const struct page *page, unsigned long=
 pfn);
>> +
>>  #define get_pageblock_migratetype(page) \
>>  	get_pfnblock_migratetype(page, page_to_pfn(page))
>> =20
>> +#define get_pageblock_freetype(page) \
>> +	get_pfnblock_freetype(page, page_to_pfn(page))
>> +
>>  #define folio_migratetype(folio) \
>>  	get_pageblock_migratetype(&folio->page)
>> =20
>>  struct free_area {
>> -	struct list_head	free_list[MIGRATE_TYPES];
>> +	struct list_head	free_list[NR_FREETYPE_IDXS];
>>  	unsigned long		nr_free;
>>  };
>> =20
>> +static inline
>> +struct list_head *free_area_list(struct free_area *area, freetype_t typ=
e)
>> +{
>> +	int idx =3D freetype_idx(type);
>> +
>> +	VM_WARN_ON(idx < 0);
>> +	return &area->free_list[idx];
>
> Should we return NULL here if idx < 0 instead of an out of bounds
> access?

TBH my descending order of preference is:

1.

BUG_ON(idx < 0);
return &area->free_list[idx];

2.

if (WARN_ON(idx < 0)) // OR VM_WARN_ON
  return NULL;
return &area->free_list[idx];

3.

VM_WARN_ON(idx < 0);
return &area->free_list[idx];

4.=20

return &area->free_list[idx];

But I suspect[0] Vlastimil (and Linus) would order it the exact opposite
way.

[0]: https://lore.kernel.org/all/bd36e972-8900-4476-a66b-4dc218b21a4d@kerne=
l.org/

And I care more about making Vlastimil (and Linus) happy than this tiny
detail of the code, so I'll defer to him. The current style is a
compromise, but maybe it's just a compromise that makes nobody happy.

