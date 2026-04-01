Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DB9D10F931A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C5056B0089; Tue, 31 Mar 2026 22:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C496B008A; Tue, 31 Mar 2026 22:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9086B0092; Tue, 31 Mar 2026 22:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D58D6B0089
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:58:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B31A61B7EDE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:58:46 +0000 (UTC)
X-FDA: 84608479452.24.A98448E
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id B5F03160003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:58:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wPiUAKIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775012325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGAPZr3EqqXhyUedH8cqtwqO0Rww30lEki3EFr3OscU=;
	b=xvEfyX3M4VrBjzIK2e447YFqUtwGNE7CLIHTLvVjE5w4AWGmK/HlwCRPwTyuPLKiz4eUEG
	TVAQoLxqLGWmq/tzjMSLdWr1Khbm0Z3iMJ8+n89iW16RmsItOPo4fHt48H7Urn8cOlZevq
	sN68IpAMJ+iXHrW/uZcbksXkP9aSTfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775012325; a=rsa-sha256;
	cv=none;
	b=3SNHKJgnzfHf45mxhKaJHaDlG4MfDWea51PD7HwgXnTHR73xWrMde3ZL/bqCOrnLIIv20d
	oLOq0AHTTP70g1B6HAT/inWU6ud9oOMTMZ7xWH6dBaRX3lVkTQjnTR3bDGkJyEs3lh26hr
	CRfV4kAeIYXq9zn4v3SVKo2/PVhyyIE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wPiUAKIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775012322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wGAPZr3EqqXhyUedH8cqtwqO0Rww30lEki3EFr3OscU=;
	b=wPiUAKIlzxCAjdWH5n4LbCKggMw2WuOiXlxuWWCoWYivIp7iqE0F/qR99fKKKybEMPP32X
	tc0vAIZzVbk7iNWdH87lCn4a/fGfHTHmKOAwOpCVIC6GebymsbZGsTe+7ASpM5j0feaYJE
	dmtljwHe/lkpnuTK7TmMNEVvHtY2ylY=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
Date: Wed, 1 Apr 2026 10:57:58 +0800
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
Message-Id: <7C90E910-D229-4F60-A62D-E893A89D58F2@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <32789381-f860-4b60-a1e1-4c97f6ed08b1@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B5F03160003
X-Stat-Signature: ud99garn6hf3eubbaf773bzfbpengytd
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775012324-693949
X-HE-Meta: U2FsdGVkX18KH4SJIc9evTuWrAArbEGeTGuo4GZdwk72dA/+SU3FueCt1QtozTUJhUS61cDVLsaZ9Oz+14f/zbgMu5qDhG0nCqBIPbH1HwGe+eIocIazTInE6BOvOtgISvXUxYE9QQy5IIekkdXh2ix1EAiTENvN9tuv65e5GNoX+tnvI3Yj0J17LMOxFWC+0gOyiEi1EChZntPs9n7FmR+T1f/6ILcWzxMQ2HGfEB0/+n4YA1iYPvtVqalD8y4hOyT+hlhDMaKcQiD3AA3RgE2CrAd2KJ5SmaS5aM4pz9aoNrMtbp3yOdXqBAKTIRJ+DukGgPlFHQ0omW9Wmt7PXxvYlWXu/EdZeXhw3AikU3sOSyTgnt0g/EZEg0q5Rc9TtwUjh6U57NUk/bj1ziae+WykTYRvWm72aBFZUlJcCcO1Wkei9l/1DwRVIp0mJi5wSehlVc66gPzkjcS/fpVWyMZ2B9zlivWMuG5WkvNjRsAdghGGnHQEaPB8iweYt6pHi+xQzpC0OV3Cm+BLh+Asi8H8puAZo1MFFsbGyTPi/fbgxaCYdejEjvvZyKL3KluPTqQq4NGrItFG39eHPq6C5HZ7oAqPMnLYLAOpdNbhj407/m1htk93t3rxxCh0LHIrmJ8MwQa1bFDB8V8IpSr0A7XutK7V8Dxufng6ddms0dM+PUEEN48Hhe2b3bz2Y/CnPko6mqQCkDzqztP4HxD0rG8QHvLj8hNda4hPBOmfpTmAqxITXJPxt/w5m4IgWRHFG0QkLw+VM7bplT0iSKPfGMK+GOVFSSf9kimyCHYri14TuE3Sva6N6icrI1A87HrYvtFsHXDPI5VGzsbmynRThucNNkahBQClk3kvoi39Wnh75FkQW8Yn4Xa+gF9zsQZU99WCUPpZ5RkGFBUbMsFzG0W4XVPMJClR/Udh5SDAfMNp7bwIG7G7RADsk/KNws89NzVsQd4qtu5IWaoiTef
 qqB/8zdw
 VTk2ofUbxomCeTd1k2j7dPZ1Qaaka7GTn/DebmvFOv5K8uSsqkaUTWuAjSwfuZ4mBv8nkM5ZK0uFT8HpeUDTn0o1UEO0x7AuohROR07yh9Dz1boMlRdTjk8CrHNI76h4vNeYeZtHWMeGIEpddZcgBvAX7U23EdNiU9swXl/0kr5ifKwnyTzrukx6pV4o8LkjE90T2chNuNjqyxd9O+CD6+SGCsbMnZtywdTPi2N8xAx4aeFdBQ3e3jAR5pkDQhWzNI7yEQnRqW44yGKSo3ea8gSrg7VQtmaJnVzZH6BOW4X8EwWwrDtNsSopAOypO7kHTE6sApdV9EG/0biE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 04:29, David Hildenbrand (Arm) <david@kernel.org> =
wrote:
>=20
> On 3/31/26 13:30, Muchun Song wrote:
>> The comment in mmzone.h states that the alignment requirement
>> is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
>> pointer arithmetic (mem_map - section_nr_to_pfn()) results in
>> a byte offset scaled by sizeof(struct page). Thus, the actual
>> alignment provided by the second term is PFN_SECTION_SHIFT +
>> __ffs(sizeof(struct page)).
>>=20
>> Update the compile-time check and the mmzone.h comment to
>> accurately reflect this mathematically guaranteed alignment by
>> taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
>> __ffs(sizeof(struct page)). This avoids the issue of the check
>> being overly restrictive on architectures like powerpc where
>> PFN_SECTION_SHIFT alone is very small (e.g., 6).
>>=20
>> Also, remove the exhaustive per-architecture bit-width list from the
>> comment; such details risk falling out of date over time and may
>> inadvertently be left un-updated, while the existing BUILD_BUG_ON
>> provides sufficient compile-time verification of the constraint.
>>=20
>> No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
>> the smaller limit on all existing architectures.
>>=20
>> Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of =
lower bits in the SPARSEMEM mem_map pointer")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> include/linux/mmzone.h | 24 +++++++++---------------
>> mm/sparse.c            |  3 ++-
>> 2 files changed, 11 insertions(+), 16 deletions(-)
>>=20
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 7bd0134c241c..584fa598ad75 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -2073,21 +2073,15 @@ static inline struct mem_section =
*__nr_to_section(unsigned long nr)
>> extern size_t mem_section_usage_size(void);
>>=20
>> /*
>> - * We use the lower bits of the mem_map pointer to store
>> - * a little bit of information.  The pointer is calculated
>> - * as mem_map - section_nr_to_pfn(pnum).  The result is
>> - * aligned to the minimum alignment of the two values:
>> - *   1. All mem_map arrays are page-aligned.
>> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
>> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
>> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
>> - *      worst combination is powerpc with 256k pages,
>> - *      which results in PFN_SECTION_SHIFT equal 6.
>> - * To sum it up, at least 6 bits are available on all architectures.
>> - * However, we can exceed 6 bits on some other architectures except
>> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are =
available
>> - * with the worst case of 64K pages on arm64) if we make sure the
>> - * exceeded bit is not applicable to powerpc.
>> + * We use the lower bits of the mem_map pointer to store a little =
bit of
>> + * information. The pointer is calculated as mem_map - =
section_nr_to_pfn().
>> + * The result is aligned to the minimum alignment of the two values:
>> + *
>> + * 1. All mem_map arrays are page-aligned.
>> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest =
bits. Because
>> + *    it is subtracted from a struct page pointer, the offset is =
scaled by
>> + *    sizeof(struct page). This provides an alignment of =
PFN_SECTION_SHIFT +
>> + *    __ffs(sizeof(struct page)).
>>  */
>> enum {
>> SECTION_MARKED_PRESENT_BIT,
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index dfabe554adf8..c2eb36bfb86d 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -269,7 +269,8 @@ static unsigned long sparse_encode_mem_map(struct =
page *mem_map, unsigned long p
>> {
>> 	unsigned long coded_mem_map =3D
>> 		(unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
>> - 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>> + 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + =
__ffs(sizeof(struct page)),
>> + 						PAGE_SHIFT));
>=20
> If that would trigger, wouldn't the memmap of a memory section be
> smaller than a single page?

I don't think a memory section can be smaller than a page, because
PFN_SECTION_SHIFT is defined as follows:

	#define PFN_SECTION_SHIFT	(SECTION_SIZE_BITS - PAGE_SHIFT)

Therefore, PFN_SECTION_SHIFT must be greater than PAGE_SHIFT. On =
powerpc,
PFN_SECTION_SHIFT is 6, PAGE_SHIFT is 18 (the worst combination).

Sorry, but I didn't understand what your concern is. Could you elaborate
a bit more?

>=20
> Is this really something we should be concerned about? :)
>=20

When we continuously increase SECTION_MAP_LAST_BIT, it may trigger =
issues,
because I expect to catch problems as early as possible at compile time. =
That
was the motivation behind my change.

Thanks.

> --=20
> Cheers,
>=20
> David


