Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0F48606A329
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 06:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Ida8RXck
Received: by kanga.kvack.org (Postfix)
	id 058FA6B05B5; Sun,  1 Nov 2026 01:56:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 009C36B05B6; Sun,  1 Nov 2026 01:56:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3A756B05B7; Sun,  1 Nov 2026 01:56:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C23DC6B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 01:56:35 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13C15140742
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:56:35 +0000 (UTC)
X-FDA: 85385641950.20.CB235AB
Received: from mta1.migadu.com (out-233.mta1.migadu.com [95.215.58.233])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9515040003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 06:56:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ida8RXck;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793516193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v4B3Z+vyjFOZ3NXznu3UfBs3xYEdHpd7Ad18VpZadd8=;
	b=VPUafGBnsgi4kWGsp4cMHtnbqeJvV0IITcFBgW6HeqKcIkNoZCGjFDqCIfMuAExYklfCzq
	YMJjG3h/IQNn0JC7AzIquCvumLJh8FsIkS5Lw6+jmrYpUo8fiuH/Ue52nklOeaMTZ50VHR
	ouHfjWFgWyk9f/mgY+KiwlDXWTzBXF0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793516193;
	b=ukmD/0qSohKMICO96r0Xio4bPO6mkeUvuurZKKKUHX4MnISk5/pz7KJA8yYTf5cNlYa0hj
	HXjttzQiZzeuCNKYZ5aeS2Lu6VDs4NKjv3UJ0yTyeOGoGK6AIU9uKe8dh/kNSL2VOiefOj
	Cf3muJ1o9zv3C49uLsiHVpeUl4fdnxE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ida8RXck;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.233 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ZcO999B06qC4lUge9AN7c8raiSfFZnUwVxvBJv+yD9A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793516191; v=1; x=1794120991;
 b=Ida8RXcklakI58X5J5aWwWR3xSschDfni6YJ2+mEMKDUt/9qPBeXoYw7VCfe4nlSngI9KVbf
 mPaihqGsN01rwX7Rnq25/qST/RzSaTQKY6Ge/WGFqxUG5QN4ZSrlnBFESMUkO6MWYH/PNzI8yOa
 CMnMLO1bzHo7OVDoUA33ey14=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 12acc32e1bb7e80e;
	Sun, 01 Nov 2026 06:56:31 +0000
X-Mizu-Trace-ID: 12acc32e1bb7e80e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH 02/12] mm: hugetlb_vmemmap: unify
 VMEMMAP_{SPLIT,REMAP}_NO_TLB_FLUSH
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <86d9a986-58ea-44f5-a8af-514abff12c2a@linux.dev>
Date: Sun, 1 Nov 2026 14:56:15 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>,
 Lance Yang <lance.yang@linux.dev>,
 James Houghton <jthoughton@google.com>,
 David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <99503D05-0C4D-45E4-B5D6-EDD927838935@linux.dev>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
 <86d9a986-58ea-44f5-a8af-514abff12c2a@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9515040003
X-Stat-Signature: 7crfgp987xk63pnufr6nhk4owyxud3fa
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793516192-804977
X-HE-Meta: U2FsdGVkX1+sHHttgMlenjhwgXPVjWCoihiPyJELkkihvK/WgtKaCAtQyXwlMwKbHv12Q9ziwT3MzyQjm9QXPQ9G7eBvjifzhDB6kYCFz7L6zYTIvSTMc6EYsPjw1BtHPJE5QdRlZjNNhcNLlAyAHWRS4udYvU0XpLhCVmGZXXQ/YlOuOXbo4mzGDZsrbdvdGoNy12IQLZSvptGrwDCXELuaCnvKFW6iHH/H+6MrI6bIyYFPfOGsxOv3YuWzlyWMW0frnLTv7h4iS0/mCvcQ5T4vkPnkRRWEz99+/YdHlmI1AMLyuL8JTXZUGJgftHGRoxSi9rAZBECZpDCmVGeys8IEpViQSWrfVbGIPXWh8I84O0C44gvvhX8GGKZMQeNIW/DhzF+k41iRcMVS5zFrAQQPFlLtLJ6YIw3i6LTYb2la/SuU6kMzZOQx5akIQA/utx0d3glqzl9O+TfREQLoY5tF+192I7q7dCwhaHDWsYc78UUTK6rnzh1QwXSDjuwF47HsvKtEPirA2isxQJhh70/X8K7YbSEAElP4i9UWvXFI/ZRTQLmifWbcmEXfH+KzTDPTd9bu4UBgKggYpcK53mfp6ST7GviW415KKXFfr8LIALtbg/SSam3ICtA5UnLjMimx2FpVtitQt7aHyRGggC6ebOjqaIMzSZyQqip+Mv7dmsq8F2MGubFtyiJeSsd/5eIaqqQOq2wfuEfLxbNhvepHfQqsdlMVDD8wsyfqon4FLdVRXfketrPgRGP2xrNtsuqiMOnyzF7HkOgWFDPs98GdhXaz70q25vsbLta2NSFOqUk5AaH6Z4+zlzz2zRkFZ6pDXB/Due7NqbtWiGjLZ6hGGxOiFoNm5UNwvPtmmlGXu0zwoP9C6GpITyfm3gUhkBkXqote0liijhZU9B55ghiG9ULjOjuQyD0UhO8SdcVLQNlOyRnvIP4C5IghLHJPAZrA25/iBHoxVDv4m0W
 XxMCqJqn
 6vzTjp1YOMsCnekJJ8st18pLOcx0JKeGlOUQFHcQQ1w9gyfCh25Ku/ul2ARoFU7q10r7tUVhxIysKN4arm8GDeBsvcudHDYs8YI1xQL6VqLyx+UxitJXXyytzIPEBCDzq1BKtRwBNROEMQzKk5vJa6TIfhXm5eoWtleT2lgTn5tDSsgzSbt9DwH+c5O9IasxqRzuVDmFH/BklFnxJuBGCgnG3PkhtUSqNEL/zfgNJpTEI1k3WGvRABguJr6sKky6ldKbvDLyoGRLTBGBRwckTXIcMTd4BnNTlyE4G+eQGcdgdC4DUmPnT0lbzV7cg5gNHEPUQp3B40uci+WQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 1, 2026, at 14:22, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 10/20/26 7:58 PM, Muchun Song wrote:
>> VMEMMAP_SPLIT_NO_TLB_FLUSH and VMEMMAP_REMAP_NO_TLB_FLUSH do not
>> describe fully independent choices. A split-only walk can defer the
>> PMD-split flush to a later global flush, and a remap-only walk can
>> defer the final remap flush. However, when a PMD split is followed
>> by PTE remapping, the split flush must happen before the PTEs are
>> changed, because stale large-page translations must not overlap with
>> new small-page translations that map different physical pages.
>> Replace the two flags with a single VMEMMAP_REMAP_NO_TLB_FLUSH flag.
>> Keep split-only walks able to defer the flush, but force the split
>> flush whenever a remap_pte callback is present. Callers that batch
>> HVO work can still defer the final remap flush and issue their own
>> global flush.
>> Current callers keep the same flushing behavior.
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>>  mm/hugetlb_vmemmap.c | 15 +++++++++------
>>  1 file changed, 9 insertions(+), 6 deletions(-)
>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>> index 1105aa925acc..8b3abb562599 100644
>> --- a/mm/hugetlb_vmemmap.c
>> +++ b/mm/hugetlb_vmemmap.c
>> @@ -42,10 +42,8 @@ struct vmemmap_remap_walk {
>>  	struct list_head	*vmemmap_pages;
>>    -/* Skip the TLB flush when we split the PMD */
>> -#define VMEMMAP_SPLIT_NO_TLB_FLUSH	BIT(0)
>> -/* Skip the TLB flush when we remap the PTE */
>> -#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(1)
>> +/* Skip the TLB flush while updating the vmemmap page tables. */
>> +#define VMEMMAP_REMAP_NO_TLB_FLUSH	BIT(0)
>=20
> Since this flag is now also used by the split-only path, the
> VMEMMAP_REMAP_NO_TLB_FLUSH name is somewhat misleading. Moreover, the
> flag does not suppress every TLB flush, as the PMD-split flush is =
still
> mandatory when remapping follows.

Yeah, good point.

>=20
> Would VMEMMAP_DEFER_TLB_FLUSH better describe its semantics? It

I think so.

> indicates that flushes which can be safely batched are deferred, =
without
> implying that all TLB flushes are skipped.

I'll change it along side with the comment to:

  /* Defer safely batchable TLB flushes to the caller. */
  #define VMEMMAP_DEFER_TLB_FLUSH       BIT(0)

Thanks.

>=20
> Thanks,
> Qi
>=20
>>  	unsigned long		flags;
>>  };
>>  @@ -85,7 +83,12 @@ static int vmemmap_split_pmd(pmd_t *pmd, struct =
page *head, unsigned long start,
>>  		/* Make pte visible before pmd. See comment in =
pmd_install(). */
>>  		smp_wmb();
>>  		pmd_populate_kernel(&init_mm, pmd, pgtable);
>> -		if (!(walk->flags & VMEMMAP_SPLIT_NO_TLB_FLUSH))
>> +		/*
>> +		 * Modern MMUs allow overlapping TLB entries with =
different mapping
>> +		 * granularities only if they map the same physical =
address. So
>> +		 * remapping must not proceed without first flushing the =
TLB.
>> +		 */
>> +		if (walk->remap_pte || !(walk->flags & =
VMEMMAP_REMAP_NO_TLB_FLUSH))
>>  			flush_tlb_kernel_range(start, start + PMD_SIZE);
>>  	} else {
>>  		pte_free_kernel(&init_mm, pgtable);
>> @@ -272,7 +275,7 @@ static int vmemmap_remap_split(unsigned long =
start, unsigned long end)
>>  {
>>  	struct vmemmap_remap_walk walk =3D {
>>  		.remap_pte	=3D NULL,
>> -		.flags		=3D VMEMMAP_SPLIT_NO_TLB_FLUSH,
>> +		.flags		=3D VMEMMAP_REMAP_NO_TLB_FLUSH,
>>  	};
>>    	return vmemmap_remap_range(start, end, &walk);
>=20


