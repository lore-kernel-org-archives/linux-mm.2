Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF51606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 08:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=g/dalwhO
Received: by kanga.kvack.org (Postfix)
	id 6360A6B05B5; Sun, 15 Nov 2026 03:10:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CB76B05B6; Sun, 15 Nov 2026 03:10:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522506B05B7; Sun, 15 Nov 2026 03:10:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 309326B05B5
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:10:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC71140619
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:10:22 +0000 (UTC)
X-FDA: 85436631084.25.65E61F3
Received: from mta1.migadu.com (out-164.mta1.migadu.com [95.215.58.164])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91DF8A0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:10:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/dalwhO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.164 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794730221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eftIXPPf9pXf1ylbm90M+/I8H9a+zbncFEcPQIjwOfY=;
	b=6689SSizs6s8QELj+QORC72LUHpXvxFyA45IqrNHjILutXybE+inj+bNCoH/64plRBJgYH
	Ttl3selt2lcbYjCm4LGnu3reXGmyFUuAQM6xNvsJmTzvpD0dgzL7v1Qc8BcHQS2hxAtnC8
	F75kVm7oRUd8PyUX5/6p4eorUbFZoc8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/dalwhO";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.164 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794730221;
	b=5+YeMd3Ri8nO7i3qImP3SVVxr5zZm76biyJryKcMlEJ4C0tClVBY451nJt2Z+PkYLFiXcu
	4XUera09JnMvZQz7i1GZjhplyb2mzSK8PKlhwXzumFSxB1rpHczDfcwMWcq8IjwwtCnBjT
	yCy2Y75yibidzB10hbkkJMEvO2BSHOA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ks9Q0ch7RjWGng/htsAt9i5kDZUQ9GU4wWCt+aHsq8M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794730219; v=1; x=1795335019;
 b=g/dalwhOy65C6OKo1Qzc3JAqZ/xkb0dSx5SWlC0iP0jDb6JGbD3u72+R9EZrtCJ3kaJvx6MV
 5Dyo/bdBqWLpwek/yW8b0xZA8LBi5rKGg3j5dQPsk81HoGZjvJlvQG6L0vJ6H9w/RC4Tiwr2Y31
 WF406BCUYMQQ8BG8mAL6TtaI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 582e74fec350fdd3;
	Sun, 15 Nov 2026 08:10:16 +0000
X-Mizu-Trace-ID: 582e74fec350fdd3
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH 2/3] mm/page_ext: support early allocation for SPARSEMEM
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <179472790175.1870365.16622132821657916911.b4-review@b4>
Date: Sun, 15 Nov 2026 16:09:55 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>,
 Sang-Heon Jeon <ekffu200098@gmail.com>,
 Mostafa Saleh <smostafa@google.com>,
 Ketan <ketan.kishore@oss.qualcomm.com>,
 Usama Arif <usama.arif@bytedance.com>,
 kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <DBDBD5E7-2938-4534-BB3A-35848C4821F3@linux.dev>
References: <20261114104150.58424-1-songmuchun@bytedance.com>
 <20261114104150.58424-3-songmuchun@bytedance.com>
 <179472790175.1870365.16622132821657916911.b4-review@b4>
To: Mike Rapoport <rppt@kernel.org>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 91DF8A0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: tfnwijzujsq6snxqog7u8jreo7sqdp96
X-HE-Tag: 1794730220-525365
X-HE-Meta: U2FsdGVkX18nktNbAPcFgKpXZ87AFFbPCpf3UHv/I2MC+YS1aySzXl5af2Mk73S09grtZcQzbPmcq5ARJOPAuWBbGhnEIihEp5bIQJkJyZAzEDrVON9DvkCUkuMsryR5c+Mngknqh3oayDchjuiEbIxeSy1zFGu0WwgJapsyFc9qu37lnDKZ/JL3DNHMUapyxY1keUyN4O6MIkWJtFrUlyTBXCo6i2UeQih/mRKGhUz3zhxOCvM4Hgs6RsPYRu0hNeEKeD4NRVIEuuXdnp2VCUP6ltn1Mrh1LXH7NQc6Em739yP2YEXwcJwejVJ3P8zv7Fbhg1UjXQFVKVvEcVFZo+iNUNeiseyLn2HukDaWN06MgJl9uccLHlUm4UCw/tJZHhfu4f5+mrlHDHGIY/tyFSH7gqKsgsOoBw5NpyoC32CTNxQbFkTx6u3nHoMucBvxgsx5qCvoRBp76AVNklPnw06fJtJy94AvaFBWyo4cafe72GQIceXjB0AENfbEP1DCLOxxtZWo4K9Fmx2+pwcQr6hZoZGLAwdYJzubROo5E6JLQtaVYif63p2mLeVx5Kqe8xV7ciJC8IxrG/rQnh+9MIsBX2Q/iEYteg8AbyVO+Wez3wjWymMagWUFtU3FtRH8LPBmVJgfL/01JVLpe6HmsEQBJ6sk3vKcXUlzVN2kxRxYm7PPbCk7tffPgExpundh5QMRNy3QYq/hNBD2hqGcOFjFtEfr6ng0Snr+NSMJe0qYLhh1T61T9w6P3RRIUvE4NlQOs/p1hHMJKgN2p/W18M00sGFk3UiXRtr8dJa0YKmJMkEQo6aWw3ny5t/eBWd/wKd0GUKRhn9PnhKShapUmtxvNpkLAXaqGZXMjHle0syBRiuoKYE5e2sJC4L/vL/A5u5UzjsM19cgdpASGY6+kMHDS27U+6IZkHAM8qDUR7IAF4/pSEtGkQMFvXLWy4dOEnPWfT/iPIvItyt1Sp7
 fEd/xQpB
 7hvkmsTbMZCLsHpWi1iVUZs6aCZWfltMm/Gp2V4XobvrDryjDya7tWXLU9WjAYjlqmRKLhkn4KmN3vY2PSwU4cQ2MK2VKTz+xmfEcZr07s9q1Jhf3OIQoZCzcErnx5fqMFZF5khaHDtFbacGEI38n2lOVK066khKEjnF7+Qwav2HAKu0QKIqs+igoxJYZLHh+UpFD+2wFnJCvUpkidwOpUVutYuAtDDrsa4ATLighXZ2YBj9sPtjNo8YuvrUYPuC0UiIPXpiM/lCHD6kKF8UjKU3lpyZjgVoVjc0wB1Y9XcaeORmnXVewrsi7bOOVCESEAZv+I/OYz2d3REoqDa6+07AKGCVOQSw+ZNsMgrHov8EfQis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 15, 2026, at 15:31, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> Hi Muchun,

Hi Mike,

>=20
>> Moving KMSAN's per-page metadata into page_ext requires page =
extensions
>> to be available when kmsan_init_shadow() runs, before memblock is =
freed.
>> FLATMEM page extensions are available by then, but SPARSEMEM normally
>> allocates them later from the page or vmalloc allocators.
>>=20
>> Add need_early so clients can request SPARSEMEM section backing from
>> memblock during page_ext_init_early().
>=20
> Can't we just always allocate page_ext for early sections from =
memblock?

That would be simpler. I checked the page_ext history but could not find =
a
documented reason for treating boot-time SPARSEMEM sections differently =
or
for avoiding memblock allocation there.

I agree with your suggestion. I will remove need_early and allocate
page_ext from memblock for boot-time SPARSEMEM sections whenever any =
client
needs it.

>=20
>> Use page_ext_init() as the common late path for client callbacks.
>> KMSAN starts requesting early page extensions in the following patch.
>>=20
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/page_ext.h | 26 +++--------
>> mm/mm_init.c             | 11 +----
>> mm/page_ext.c            | 99 =
++++++++++++++++++++++++++++++----------
>> 3 files changed, 82 insertions(+), 54 deletions(-)
>>=20
>> +static __ref void *alloc_page_ext(size_t size, int nid)
>> {
>> 	gfp_t flags =3D GFP_KERNEL | __GFP_ZERO | __GFP_NOWARN;
>> 	void *addr =3D NULL;
>>=20
>> +	if (!slab_is_available()) {
>> +	addr =3D memblock_alloc_try_nid(size, PAGE_SIZE, 0,
>> +       			      MEMBLOCK_ALLOC_ACCESSIBLE, nid);
>> +	if (addr)
>> +		memmap_boot_pages_add(size / PAGE_SIZE);
>> +		return addr;
>> +	}
>> +
>> 	addr =3D alloc_pages_exact_nid(nid, size, flags);
>=20
> And unrelated to this patch, do we really need to try an allocation =
from
> buddy rather than always use vmalloc?
>=20

=46rom my perspective, I don't think it's necessary at all. The only =
real
benefit to allocating from the buddy might be better performance =
compared
to vmalloc, but do we actually care about performance here? It doesn't =
look
like this is on the hot path, so I don't think it's necessary. We can =
remove
it to simplify the code. I can make that a separate cleanup.

Thanks,
Muchun

> --=20
> Sincerely yours,
> Mike.



