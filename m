Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279ED10F931A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 02:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948546B008A; Tue, 31 Mar 2026 22:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91FED6B0092; Tue, 31 Mar 2026 22:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85CD16B0095; Tue, 31 Mar 2026 22:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79FFB6B008A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 22:47:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 469EB1B7EE3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:47:57 +0000 (UTC)
X-FDA: 84608452194.13.341CAFB
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CDF5180003
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 02:47:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TAAfoIZf;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775011675; a=rsa-sha256;
	cv=none;
	b=DM68XenlSL8OKL05PWgLcwuoTQOHqKXdXhUzPXALU3cqrIR+ZwrBfBOBuYdZ0Il4/m2P//
	cv02ngX3el6QspCGLD3wFtPkuIkTYd/hVGTVn4uaoraAJlEF8ddFXhjrhXtriVo8E2cwmO
	EI1ZvVZbmlS5/newjuj/3R4NVfM/0FI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775011675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=487xEtTeyex03qkCiMEHTXJ1TpxhwGZlPZ51KtMUovs=;
	b=plSdlOhOt6Menaf1rbkzGMLXfAQxew9j1cXq5rH5BKQVgfJbwOQbwxMDKJ5oA6ZF4Q5o/m
	B/wmi1FBDNZxc0T4WvCImJpmw6qxTfjdxeWu63A7TQfzQTpEkmRQhc1kCMk4BSmN/UHvsh
	6CCZV4+aWDRT3rXJvaHWcD9uVBxpFYM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TAAfoIZf;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775011673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=487xEtTeyex03qkCiMEHTXJ1TpxhwGZlPZ51KtMUovs=;
	b=TAAfoIZfWAXt61KDYmsy2oYy6slMzxTI2rGBKdZ0p3214RjmJ7zCmrmA5zddannA97lcRs
	SfVhKdPn7UnoLrT1Al9nhyelBzYFhYBJ91jRCg4gzzcGbsramRVMdW6NrZp/PxpQD8CRqB
	5HaN4sE6bAyStJ0qlCw9KpvCBruYTYU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm/sparse: fix BUILD_BUG_ON check for section map
 alignment
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260331130717.d42b64e5179c4c814bc523ea@linux-foundation.org>
Date: Wed, 1 Apr 2026 10:47:16 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 David Hildenbrand <david@kernel.org>,
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
Message-Id: <13BC146A-993F-4105-9BE7-56A8691A2E61@linux.dev>
References: <20260331113023.2068075-1-songmuchun@bytedance.com>
 <20260331130717.d42b64e5179c4c814bc523ea@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7CDF5180003
X-Stat-Signature: nidd1omj4rf4ckrkhqrx4nihc8qacm1u
X-HE-Tag: 1775011675-72335
X-HE-Meta: U2FsdGVkX18vNFlgedjOBh6wkzHeNEaNi01tVJ8HFmK4IFCgkegBGUGlAgJseeID+Btc3vuLiFnU3wVFxHA8LSkhHr9X7dD2jSudzMUcaYvgdw+AUF7UD3el7+O9fiy/+cn+YS+cJ95RdX/iK8aAS1AQ6Bqh1wRTFM2BSHVs6D0qNNDzP/z1+30whpssoSj3K0ANlMoqu2dzACiTE7q9+K8xZxhQYj+pkzQ21n6l9D6QaIaQ0KmG6QehPHnNcJnNsFYxSueQQwP17/Uo+o9p0L0XKHhVGpWWw9Q3crOr8/3A+VU4Vzd7p445YZd004uHmo9rxZxuy1PCzZet+qaiGjZt0DgQugCWodiJY85dk8g55yjH8PiktZ8UEodFbWO0lq7645XIngY8KznmRi18OAXCMeE1nnM2O1VsHvB/tkOyvZBjmtd+1n2RgIEnC6DQKdKwvkHkwlmLveA5gIyXVw2h1UGGQufUkuCTlqUtA0xBqBZ+V5YHA1hXzizoiNsuFtYSmrtKOVzfelEli51WAxrRjRbtJxeau9oVWve2R1RVtWWxlTVh2zOi+KEMi6g7hfSq8+YX2xOvki2tEAVcROzyaJeZmMY4P6lobkM5/pKe1Yfk2u6nnKI4Q9rFWX8X2+HXlmsAa85DgbjwOGJdt8Lm00/tSJDVJMbKUjgcnRoWvBS/PMv8c0J2tIBWrwlFc51HeNLZzryI277zLRm6TdO+l/dq1gU8jXyykR9/NiTYxae7ILdDSi8ImjkmsKmZTVti0zomCFU0rGcY2bVL24QqIrgne5XbUVBcMHQeK+xQOynyyQf6sXn86zwBWlT4szYJBYi+Y3aqR5QZyInzR3548FiN8jOcW2lBn9GASIOGTqLxhfjZEeUzh3M2kQpmheqjSZrHAOnjV2ukWgqi8S1xxHarX/3wTd41zOxXHLQ+rboJAB6mqFQ1Ux8t//g4YnFXTUNumlDxrvn7f3Z
 8y/7eATo
 s77CDidYKyw5fM0ZBp8gm9/4cVS8N5j7TGkJRBzPaah9GcuyQ5SrgTrRHiTW4prThYeumA4wB2UnQ5prJDDsqNDg1qQXc1uKqbgGiEpvPNNdzB/DZYfkWHJtfVVoVLZZ0S3as4/50CsKk0CrQz21tLr5xCTaeXZndI22JZygxMCy79r1KsEtVjrw1o5aXMKWeRRBB9C1tbKOiP1Y5iYmmz7JHQMn1hSqPs8sSfEobDUG6uSvx8QSMpF2e1p72ekvw+UKUnX56HitVw5ed9beJnERsKuRi96nhLz71H9wZwhPVq3LelKTfXgRZ63t9+lH946fY9iKq/pZq15EECWGfoTTmApB5IJ1qMyTof5Ato4JTpmVor4hdCd9Lew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 1, 2026, at 04:07, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 31 Mar 2026 19:30:23 +0800 Muchun Song =
<songmuchun@bytedance.com> wrote:
>=20
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
>> ...
>>=20
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -269,7 +269,8 @@ static unsigned long sparse_encode_mem_map(struct =
page *mem_map, unsigned long p
>> {
>> unsigned long coded_mem_map =3D
>> (unsigned long)(mem_map - (section_nr_to_pfn(pnum)));
>> - BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
>> + BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + =
__ffs(sizeof(struct page)),
>> + PAGE_SHIFT));
>> BUG_ON(coded_mem_map & ~SECTION_MAP_MASK);
>> return coded_mem_map;
>> }
>=20
> In mm-stable this was moved into mm/internal.h's new
> sparse_init_one_section().  By David's 6a2f8fb8ed2d ("mm/sparse: move
> sparse_init_one_section() to internal.h")

Got it. I see it.

>=20
> I did the obvious thing:

Thank you for your work for me.

>=20
> include/linux/mmzone.h |   24 +++++++++---------------
> mm/internal.h          |    3 ++-
> 2 files changed, 11 insertions(+), 16 deletions(-)
>=20
> --- =
a/include/linux/mmzone.h~mm-sparse-fix-build_bug_on-check-for-section-map-=
alignment
> +++ a/include/linux/mmzone.h
> @@ -2068,21 +2068,15 @@ static inline struct mem_section *__nr_t
> extern size_t mem_section_usage_size(void);
>=20
> /*
> - * We use the lower bits of the mem_map pointer to store
> - * a little bit of information.  The pointer is calculated
> - * as mem_map - section_nr_to_pfn(pnum).  The result is
> - * aligned to the minimum alignment of the two values:
> - *   1. All mem_map arrays are page-aligned.
> - *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
> - *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
> - *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
> - *      worst combination is powerpc with 256k pages,
> - *      which results in PFN_SECTION_SHIFT equal 6.
> - * To sum it up, at least 6 bits are available on all architectures.
> - * However, we can exceed 6 bits on some other architectures except
> - * powerpc (e.g. 15 bits are available on x86_64, 13 bits are =
available
> - * with the worst case of 64K pages on arm64) if we make sure the
> - * exceeded bit is not applicable to powerpc.
> + * We use the lower bits of the mem_map pointer to store a little bit =
of
> + * information. The pointer is calculated as mem_map - =
section_nr_to_pfn().
> + * The result is aligned to the minimum alignment of the two values:
> + *
> + * 1. All mem_map arrays are page-aligned.
> + * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest =
bits. Because
> + *    it is subtracted from a struct page pointer, the offset is =
scaled by
> + *    sizeof(struct page). This provides an alignment of =
PFN_SECTION_SHIFT +
> + *    __ffs(sizeof(struct page)).
>  */
> enum {
> SECTION_MARKED_PRESENT_BIT,
> --- =
a/mm/internal.h~mm-sparse-fix-build_bug_on-check-for-section-map-alignment=

> +++ a/mm/internal.h
> @@ -972,7 +972,8 @@ static inline void sparse_init_one_secti
> {
> unsigned long coded_mem_map;
>=20
> - 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
> + 	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + =
__ffs(sizeof(struct page)),
> + 					        PAGE_SHIFT));
>=20
> /*
>  * We encode the start PFN of the section into the mem_map such that
> _
>=20
> (boy that's an eyesore on an 80-col xterm!)



