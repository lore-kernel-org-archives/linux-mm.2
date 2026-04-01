Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC929FF4937
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 04:02:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39C5A6B0089; Wed,  1 Apr 2026 00:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 325D86B008A; Wed,  1 Apr 2026 00:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED1B6B0092; Wed,  1 Apr 2026 00:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0AFCE6B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 00:02:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DDEF140624
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:02:08 +0000 (UTC)
X-FDA: 84608639136.12.6D261D6
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf16.hostedemail.com (Postfix) with ESMTP id A0E6A180009
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:02:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b6EZ5nIA;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775016127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV8zvVRzNnwLvG8qVHUSGa4pUEQsoV9qthwjA8YsSM8=;
	b=BAo2OgLTUto9s1NYwPCUtM5UqzuH52tX/vGUeIzMZpVExwuUqrRspbXzc5nr892/yQZ3T1
	k6KYburyJQC8mtZsra66P2Q3CC34lX5eDSy/Z+EDw6nuYeVmXKTA1/Cag49XDq9Jlp11aq
	JU95rVPijc9GKtFNN+maDJEB7sYF7Lc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b6EZ5nIA;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775016127; a=rsa-sha256;
	cv=none;
	b=flyyzgZviRfgWR+GRK9N2Uly+T0m2D9AkIf1yPLosjN4LPtbPfzhQor4WZbnAQPPJ4B6p7
	MBJGrRzcEcOkLlKSeFH2CuFAbXRdxz7rsf23AuPoJ2uKjqK/0K2JjfOpaWvaAX3b2gWkmj
	FbKoBIBgWPxlr2WO5MdlDp5/rl6JHbA=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775016124;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xV8zvVRzNnwLvG8qVHUSGa4pUEQsoV9qthwjA8YsSM8=;
	b=b6EZ5nIAg6ohZy8JkXux89ixmSDOVqFviLjlxGWdpD+EDk4blym2q7gK5pwh+jlO9TNYf7
	9q4UOUwD092vuIxi5RpHWYeCo7XNVTzHpM+D4xfg0sdXGFNdWtut2TEcUQq6jut76QcnHw
	7D5Yy+o5ihlHbkbiunSsDYL+8DECJb4=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
Date: Wed, 1 Apr 2026 12:01:11 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Petr Tesarik <ptesarik@suse.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1742503A-F912-4AB6-AAF6-6CDB06829024@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
 <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 9cg6xhwx5nhysoepnxnf5pjew5par5p6
X-Rspamd-Queue-Id: A0E6A180009
X-Rspamd-Server: rspam09
X-HE-Tag: 1775016126-599122
X-HE-Meta: U2FsdGVkX1+N/7D3ZC/ue0i8d26I3btZvgij+G/fUZwDLJhIBaY7STkJl4RC63pZ+1LUiYLIF9KBHrUPbuKZIzc3UMYBiF8v+XTv8ky2PBfJYDnL6mRuFytefY7fFmUJvqt5FTyF3Hd+zXeIP4QmJYtui86rl5cV2U51xcE/CWRslcV4Jo0wnnIyOPU1Z19QTqyzjB8WnPayxTbMTmY1dCxMUzK7rPWs53IDW44E/OQBFiUdu+QUhXrzipEHfGGzW7bg7uU/4WZryt3zIIq0GAES2mM/SUZRKRrJB9t+0SbfJDhxV6IOr9ORYoUfP1OwF9C4FqnYuReFXV5dat3bLYVq1NTKzMX09INwyYQCLT0IFMQpNGnZcAUm7wYKwc6NmXzKPof3dTF4eHrn4WAcf40y/JGXC8xXGb500FkrEbVB5+z2gFRcUcwpPY7RakTtie5h3glUF6sM4uaVyKa1At2jBQlwHkCxxObHuo4gm9Qzpl91nSwesWI5vUHn5Jft+w5r9ff5MFC22lMoOli5lisM1ET/lSmv4OkpsRcB+Gx6A5qXMfRjW2LfLUihrcDaeNIWLEkDJTXYz7Ojq3HZPCrYwjjZlwXDzwVAc9Aaowkegd6DyPJvHOr916XKY3n/wyAqDZcbbyizONA9aBuwj1LvZQW1Z5dgE4XOzievGzYT58M1IJMgCMZPC2xhM0mcdrVGXvgCDPk/n38TzianQ5PFT91PuPYX9H/DERafqDvsiy6ggp1oeZz/THVLGUDrW+9dMRVN7tZpVAeZRo8vUf6ZGGglO+K4+LfuIY2hGl5uopnYnVgPAeMDw+uHb//R7DKXYt+czAkWCCLi0YQp5PR9+tTRVwStkhhuXo69kp7A4bOeUFQ4eRJc95g2w2wiKK82qlvrZZBBMDR/6DOXTRUexBCm+dDjQlqGp0vRGTWkD5MbR2H7f3hb44TCq0Oak5j3xb6SQFp8E2jv3In
 HH6q9Xxt
 4B8tNoyp7VNq/mejtj00wetPvF99ggeQq+kf3+rSMcEbGuwScZcPekm76XLa+c7E0Gg7vkFBv1wVB15RaYhY8Uy1Ig6EFOzHE1nKpfn28UZ1Lb5z+9+yMdtf9x35TGd4Q6UnG07Xo5R8u1NfdTOSF5u6dhkYWbXiX9BBLdn9uvvA/kEyH9awcel0eluk8juIbAJJByYa0IPvc9qFdnuWSkf8IfiZ3V2K+0GPoW1S4N4z1kD8RYmWsu5ree4g/vxyfdRwRxOik8mrs8jEmcokOzD13mUr607af672sxJRNanb65UQL5i/IuPVHi0z605DopLaXHMEQNUu2hLU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 10:57, Muchun Song <muchun.song@linux.dev> wrote:
>=20
>=20
>=20
>> On Apr 1, 2026, at 04:29, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>>=20
>> On 3/31/26 13:30, Muchun Song wrote:
>>> The comment in mmzone.h states that the alignment requirement
>>> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
>>> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
>>> a byte offset scaled by sizeof(struct page). Thus, the actual
>>> alignment provided by the second term is PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)).
>>>=20
>>> Update the compile-time check and the mmzone.h comment to
>>> accurately reflect this mathematically guaranteed alignment by
>>> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
>>> __ffs(sizeof(struct page)). This avoids the issue of the check
>>> being overly restrictive on architectures like powerpc where
>>> PFN_SECTION_SHIFT alone is very small (e.g., 6).
>>>=20
>>> Also, remove the exhaustive per-architecture bit-width list from the
>>> comment; such details risk falling out of date over time and may
>>> inadvertently be left un-updated, while the existing BUILD_BUG_ON
>>> provides sufficient compile-time verification of the constraint.
>>>=20
>>> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
>>> the smaller limit on all existing architectures.
>>>=20
>>> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of =
lower bits in the SPARSEMEM mem_map pointer")
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> ---
>>> include/linux/mmzone.h | 24 +++++++++---------------
>>> mm/sparse.c            |  3 ++-
>>> 2 files changed, 11 insertions(+), 16 deletions(-)
>>>=20
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 7bd0134c241c..584fa598ad75 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -2073,21 +2073,15 @@ static inline struct mem_section =
*__nr_to_section(unsigned long nr)
>>> extern size_t mem_section_usage_size(void);
>>>=20
>>> /*
>>> - * We use the lower bits of the mem_map pointer to store
>>> - * a little bit of information.  The pointer is calculated
>>> - * as mem_map - section_nr_to_pfn(pnum).  The result is
>>> - * aligned to the minimum alignment of the two values:
>>> - *   1. All mem_map arrays are page-aligned.
>>> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
>>> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
>>> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
>>> - *      worst combination is powerpc with 256k pages,
>>> - *      which results in PFN_SECTION_SHIFT equal 6.
>>> - * To sum it up, at least 6 bits are available on all =
architectures.
>>> - * However, we can exceed 6 bits on some other architectures except
>>> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are =
available
>>> - * with the worst case of 64K pages on arm64) if we make sure the
>>> - * exceeded bit is not applicable to powerpc.
>>> + * We use the lower bits of the mem_map pointer to store a little =
bit of
>>> + * information. The pointer is calculated as mem_map - =
section_nr_to_pfn().
>>> + * The result is aligned to the minimum alignment of the two =
values:
>>> + *
>>> + * 1. All mem_map arrays are page-aligned.
>>> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest =
bits. Because
>>> + *    it is subtracted from a struct page pointer, the offset is =
scaled by
>>> + *    sizeof(struct page). This provides an alignment of =
PFN_SECTION_SHIFT +
>>> + *    __ffs(sizeof(struct page)).
>>> */
>>> enum {
>>> SECTION_MARKED_PRESENT_BIT,
>>> diff --git a/mm/sparse.c b/mm/sparse.c
>>> index dfabe554adf8..c2eb36bfb86d 100644
>>> --- a/mm/sparse.c
>>> +++ b/mm/sparse.c
>>> @@ -269,7 +269,8 @@ static unsigned long =
sparse_encode_mem_map(struct page *mem_map, unsigned long p
>>> {
>>> unsigned long coded_mem_map =3D
>>> (unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
>>> -  BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>>> +  BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + =
__ffs(sizeof(struct page)),
>>> +  PAGE_SHIFT));
>>=20
>> If that would trigger, wouldn't the memmap of a memory section be
>> smaller than a single page?
>=20
> I don't think a memory section can be smaller than a page, because
> PFN_SECTION_SHIFT is defined as follows:
>=20
> #define PFN_SECTION_SHIFT (SECTION_SIZE_BITS - PAGE_SHIFT)
>=20
> Therefore, PFN_SECTION_SHIFT must be greater than PAGE_SHIFT. On =
powerpc,
> PFN_SECTION_SHIFT is 6, PAGE_SHIFT is 18 (the worst combination).
>=20
> Sorry, but I didn't understand what your concern is. Could you =
elaborate
> a bit more?

Sorry, I misread it earlier =E2=80=94 I thought it was about the memory
section size, but it's actually about the memmap size. Let me respond
again to your question. On the powerpc architecture, when =
PFN_SECTION_SHIFT
is 6 and PAGE_SHIFT is 18, it does seem that the memmap of a memory
section would be smaller than a single page.

Thanks.

>=20
>>=20
>> Is this really something we should be concerned about? :)
>>=20
>=20
> When we continuously increase SECTION_MAP_LAST_BIT, it may trigger =
issues,
> because I expect to catch problems as early as possible at compile =
time. That
> was the motivation behind my change.
>=20
> Thanks.
>=20
>> --=20
>> Cheers,
>>=20
>> David



