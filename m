Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCEEEFF885A
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:07:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350146B0096; Tue, 28 Apr 2026 23:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300186B0098; Tue, 28 Apr 2026 23:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EF646B0099; Tue, 28 Apr 2026 23:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ACAE6B0096
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:07:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B9B9E1605B1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:07:06 +0000 (UTC)
X-FDA: 84710106852.03.31589A6
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf09.hostedemail.com (Postfix) with ESMTP id DBDB4140013
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:07:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aL08m9g9;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777432025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NhojB57CLlcZgK90/1HI+G25tK+txX7jWmOanRsdL0M=;
	b=Xncv9QFC2RzzzDOvFzvtDlgZZGWBPdkEqoZAj75U4E0E0uxuU9QZxnQi3GFlOTjoXYuuzb
	2Ww6m173RyNoxlLjKd4lo4qh1fGzuLH8mDbrrJR4tBVugN9Ll5daALI7HupOYk6DLwj8l3
	1a10XrNVzCmtgVdVtwSC4hLxwuqs87M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aL08m9g9;
	spf=pass (imf09.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777432025; a=rsa-sha256;
	cv=none;
	b=LZhOHrmTmk2l7GTDpurOfjYyt2TrWZdo1njj2F72xCxlrVW0qt5HFaSUZBI3jLYO63HG0q
	26o/JGj/LPteu2kS+TB9aWMF63tmakMhl97wm4RORNUYeCFYGybGSJi/BgmwCFy7Kq6uWG
	yBBhxaechgIbyIBIx/eJXvJodnbLcc0=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777432022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NhojB57CLlcZgK90/1HI+G25tK+txX7jWmOanRsdL0M=;
	b=aL08m9g9shhLJMe46gCutiIdCVuOgIS44YbIr4/G/lym4ejJlYaBtoK8OFFXojy/meT57h
	XQSPG9BJOku37RiHe/4aPLkzIyCWLUD3d4elxp7qHwkTWbJ5yujze5lnUR0eKglPtLPAoJ
	fSOfc5E92JJcr5+/W7LdWSgyudYnvCU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 10/49] mm: move subsection_map_init() into sparse_init()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBcckUTQt-7xPPN@kernel.org>
Date: Wed, 29 Apr 2026 11:06:15 +0800
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
Message-Id: <DFB372BA-A262-4507-9280-7C0072280CC4@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-11-songmuchun@bytedance.com>
 <afBcckUTQt-7xPPN@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DBDB4140013
X-Stat-Signature: 6wdc4qygkfndegeu68b1bgjcgkt6zeiw
X-HE-Tag: 1777432024-227403
X-HE-Meta: U2FsdGVkX18NmBjziVB8dGW2s8GWo6ltPJiOwXCgaUqiYoYgg6HMiuJm6Io5LADty+EmppV9BNtG8lvdPy0t5eCsFULAIN9voZoXdwwQXkYKHaUplxYKJwVhvfAHU3SHFBwgrQQzae0AukJzxXz7VH2lGOoaWGSgB9jEXAL8N+d/+Lbazcu6QVsAo+7QbosO5ScuKWKf4TdF4y2zDRIBISeeY/NwXoCLWZmGuCCBhWCVOtfzid6/G3dBdXhQG+sxYRFRlqLh5rqlXyg4vv8bf1rZCegIJoRb5geCokCagTSrOWDfNBeiJbM5YOlFkK5ZEsSdDm+ZSZ7ID2FgvWIsW1uXcesJdR4BySQE1ZNelT24vJTXAA/Oj+LE67m49qlxlJEvJD5iSQP9rnLoaEn5g3n8uoGkGSzxtfKxDsPFzTpKcUdNRSV5iz/ttCecG9BbTyhb5xR8tZY1aSFBxsESTOftjshEYJs9vrDwDNZAF2aRxAkf2QaVWHaNjK0LDOmSjKdlnnztK1acSeKEPRHp4RUGpxNTLxwtEnDNB2UkBFZH8l+rV8ZkhZ6a8lDk9kikqfKk1PShuMzK9a+4APcmCznjG1jmvG6Bb6UPtoSo/twECOiWLdMH6lLzgB/RjQGcWuiBAL3dWNG3PkzAfo6PGSyFvuKBL0E7EFD2OOfpEi2NCCUr2hXsMSULkSskcvRIEgxrdpnjx9D3xvS9JYLXxoSCvemZMxcElYQOx+iVgq3kOaRwQ0ZSxB11m0OlImyN6rUqGK3XJCPaPkl4qaufj3FvCqNtJ4BuJeVFQdtYOt7B8jcMRF/Ps9GvMvY6t76dF6JD+tz3/zkOmC4hN/wb75A+fyR72I1iAwB4xXaFGpbkfkWXF3mBMfrLFhWsC2CSKIbCxvYPd7P55wNrEUNaHU8UMU5BYTWZTSrp3Eh3Pa+IC16v4aa0qYKhdAe3tuHf+87GX5ZQ3OD84VZ8ac1
 qtK/yKMN
 X8wuqjkrG9vQUAgzhZ+l3cnRo2Cxd991KSa1OSXxyXfHkVmmn8h2TpuqzmivYakJGBofTBzhtQKFziD4HKrI6g7cAfzlLeozI9Uh0SwvQ7+rZahbXYdrjDUAvSOg7Js0sAM0MB06qD4A0gEv8ccdV8E27L9ejhI0v2yEp/fAbsVpfzeYeH8wOmGaxACIzIn3SgEnSZBk+yynm47DoGu93ZRFP5vSFTdzv30E3URVXEue6ydTkrex/Pra9l1ufoWTQRWXy6gY7sFpFbaNUifCY0vJjcd0yYJeXLlcw4O3qBtViO0ZnVwE9GCLa9CzdAxOXT0rtQQqC+vmnoZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:06, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Sun, Apr 05, 2026 at 08:52:01PM +0800, Muchun Song wrote:
>> Move the initialization of the subsection map from free_area_init()
>> into sparse_init(). This encapsulates the logic within the sparse
>> memory initialization code.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

>=20
>> ---
>> mm/internal.h       |  5 ++---
>> mm/mm_init.c        | 10 ++--------
>> mm/sparse-vmemmap.c | 11 ++++++++++-
>> mm/sparse.c         |  1 +
>> 4 files changed, 15 insertions(+), 12 deletions(-)
>>=20
>> diff --git a/mm/internal.h b/mm/internal.h
>> index edb1c04d0617..d70075d0e788 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1004,10 +1004,9 @@ static inline void sparse_init(void) {}
>>  * mm/sparse-vmemmap.c
>>  */
>> #ifdef CONFIG_SPARSEMEM_VMEMMAP
>> -void sparse_init_subsection_map(unsigned long pfn, unsigned long =
nr_pages);
>> +void sparse_init_subsection_map(void);
>> #else
>> -static inline void sparse_init_subsection_map(unsigned long pfn,
>> - 	unsigned long nr_pages)
>> +static inline void sparse_init_subsection_map(void)
>> {
>> }
>> #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>=20
> I side note: we might want to split out mm/sparse.h and also move some
> declarations from include/linux/mmzone.h there.

I think we can do that in a separate series for cleanup only.

Thanks.


