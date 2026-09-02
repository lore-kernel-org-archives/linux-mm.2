Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BE32C61DD3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 02:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2809C6B0088; Tue,  1 Sep 2026 22:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 231DE6B008C; Tue,  1 Sep 2026 22:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147656B0092; Tue,  1 Sep 2026 22:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E4A026B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 22:34:50 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 522ED40693
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:34:50 +0000 (UTC)
X-FDA: 85167254340.21.9A68B99
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf20.hostedemail.com (Postfix) with ESMTP id 62E291C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:34:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xs9w9dsD;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788316488;
	b=I7EkFFhup8HpXpAmvVQVJ6ihVWwDe9sRCGxWSZNAZJofQ1139oX5yuqTzqLA0WYCpirB4X
	Qppz5LM1d0864I18ksdaCwdHOEpEYzwTuZ2HCfJIn7ykLSKpauxUVXvYfa7/nZNM/IqAyR
	azb/f32Qor+1dRkqaUKYeBUdY7X2B1s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xs9w9dsD;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788316488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2ZO4JyQfYg3YFJgj1rtHn543boKrzvkS+tanZwl4YA=;
	b=JVn6ZG2gFA63qcW7Bym84xbX2BdFQM3nqFff+FDRgIIPpzKWmd3wl5ozCV2NgLZUz5CNbg
	elFAdgGovk9c5fnlxxk+cD/MlHJVlbOoR8Lg7BEws8gcEDwdCwK+S2cS/gqt9/18wQ0sZ4
	BGX/el4Wno3F0sg6vwZy3ND320OH0gQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788316483; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d2ZO4JyQfYg3YFJgj1rtHn543boKrzvkS+tanZwl4YA=;
	b=xs9w9dsDnkQlsftYzciQ6IHVw8gNnfXGp3CE82PQbZ0y7Ev/Mvk7h4vHbK/krOIHoR4FJYBKuxZEyO+zZVVO9QBMFtRjK0zIRYCRESyKNXxgNLC3kL5rfFC7Eucjtsd0x30Yfa7cTfdEL7yx+ZN/Z9jJPBEFLl+xGq8shMxy4XQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0XAAqVXz_1788316480;
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAAqVXz_1788316480 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 02 Sep 2026 10:34:40 +0800
Message-ID: <ee0f3f47-f6c0-4b3c-807c-db80385db3b8@linux.alibaba.com>
Date: Wed, 2 Sep 2026 10:34:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/damon/ops-common: use a page-aligned address in
 damon_ptep_mkold()
To: SJ Park <sj@kernel.org>, Nathan Gao <zcgao@amazon.com>
Cc: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, david@kernel.org, ryan.roberts@arm.com
References: <20260902001142.107226-1-sj@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260902001142.107226-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 62E291C0005
X-Stat-Signature: 158pw59m3wrjcop84hjimiq5quikpkz5
X-HE-Tag: 1788316486-668796
X-HE-Meta: U2FsdGVkX1/FapzzN69PlVOE4/TgmlnuU8xMGifETU3H5zUcWn5w5mBv8/asmBqUkpeLQF/O3B1jZNKlUcV1FjVRpYTzZ2Flst0E2RKdSkhmmlk9/vw7+bcJUjdOF6ZrLh3u3GyLpK7JtowT+E2OW079rI9lByYPTA/UVdfBIgmLiD++Y3MxCuSacUO9BlcpAzNpJRhHsGOU5N1XHFZOswCxybj9m5fFxXJjiFYF8quSeLY8C5+yEaxvCpBwKrzi4149UyjS5YJ57DfLq8nE7d07GzT//KoF0EmDYPMlWz/jYYuCLr38Rg6zypviomk+j/1s/av9D0P0l8+EOZ1lm+KvdCunbTZEyjk88bksIr3NO2PgdAmUsm1U+I0q40faKpWqGLvpShS4kP7FLP7kWjnGMfayt7Ps68zUuCQZrfm3BTTCa2fcVk7CmrIF+hF9AK/V/JouKk6+w3l2mnylQQh2cyt5pvz9IPup0WZrkUCGjWze1/87qzrpg/MGPXAcCWjesTWtGad9ZTspqziS2suoJZudxYd/4SqPimAlKfAT3ry2avkJQ6v1D3rHahnbdO3zTsP8Xy4FVXZK1TfeGaj4Of0PgYho4VWmBH8mfCILXD5lygWqkqZlfWlUtpArFKOynWZ/KXxRV9x6xKF2JYyfK7Wau8qs//bdgoYatVegPQRMCLg7GXbSGSBtYKoRx14k76WRPBypr9/N3y2ex+1nNr7ssUwMe00DFm0rKM3lbC+bDQELMHtLEVAt8v283jMOhPcGB5V1NWzyaV85nKge7ISvbN+a14tLp/jmLclBlMGPOl1adR55v4rFcNd6ubq1fqmfOuW1OZEuaE1mmP1bbBhRzQ33GiktXPphx5c2M7bwhU5yL4t5PWrgS/DDz09SoCcrNfYvKvSZiY/iuEx0k0Qde/sHRr/s6bZezcuphqCiqr8t6/OWsIYDdY8rj8vWYOmtjW/HPKRaRE+
 htYoGMa2
 V9oHjAICc6aq2K7PDjCNjnTgp/pFPPMog+MLFnD0FbXTOLOeUU9RrQTsfLu603pf5idjDXIcs9kaxibywGOZk95DuDG1KLz+8hpe35LuOpFpSy8ps4giKOdkVB8nE6jUOY9jFKwygfEyoxBQe2GPO1VjlHrN5TMXISOGJO9E/Cl9nW7Ejf00Luxl8PlQNrNf4DbZuQN7PsPtobflQTdctryO4ZosOByg7Cqyk0xrb6qG+d8FCwR4/qvbMaEHW8hEeYZw07/vs20zy6wSAFvi7B4I5iPkCF47ZaorblkttzW2boVw9x+Uhwv1V1KhpZbMT16b6Hi36keXxabs0GewhhxPD/IOhhJDtbQsGvupXgxkTQD41hNjwkxdpug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 8:11 AM, SJ Park wrote:
> On Tue, 1 Sep 2026 13:10:01 -0700 Nathan Gao <zcgao@amazon.com> wrote:
> 
>> __damon_va_prepare_access_check() picks a random byte address within the
>> region and stores it in r->sampling_addr. damon_va_mkold() passes it into
>> a page table walk, which hands it to damon_ptep_mkold() as the address of
>> the page to sample:
>>
>>    damon_va_mkold(mm, r->sampling_addr)
>>      damon_va_walk_page_range(mm, addr, addr + 1)
>>        damon_mkold_pmd_entry()
>>          damon_ptep_mkold(pte, vma, addr)
>>            ptep_test_and_clear_young(vma, addr, pte)
>>            mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)
>>
>> For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
>> clearing of the young flag for large folios"), the contpte helper walked
>> exactly CONT_PTES entries from the aligned-down page table pointer and
>> used @addr only to pass down to each entry, so an unaligned value was
>> harmless:
>>
>>          ptep = contpte_align_down(ptep);
>>          addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
>>          for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)
>>
>> Now the range to walk is derived from @addr instead: end = addr +
>> nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
>> page of a contpte block, the sub-page offset puts end just past the
>> block boundary, so the round-up lands a whole block further and the
>> walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
>> the last block in a page table page, those entries are past the end of
>> that page, so the walk writes into the page that follows.
> 
> I just wanted to call out again that I'm wondering if we could restore the
> unaligned address support in the helper.  E.g., as a very dirty hack that I can
> imagine off the top of my head,
> 
> '''
> --- a/arch/arm64/mm/contpte.c
> +++ b/arch/arm64/mm/contpte.c
> @@ -30,6 +30,7 @@ static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
>                                               unsigned long *end, pte_t *ptep,
>                                               unsigned int nr)
>   {
> +       *start = PAGE_ALIGN_DOWN(*start);
>          /*
>           * Note: caller must ensure these nr PTEs are consecutive (present)
>           * PTEs that map consecutive pages of the same large folio within a
> '''
> 
> I and Nathan have no strong clue, so we are looking for Baolin and others'
> opinion.
> 
> While waiting for the opinions, I and Nathan agree we should stop bleeding with
> a pinpoint hotfix change in DAMON.

Thanks for the reporting.

IMO, we could let the arch low-level functions handle the alignment of 
addr, but that would also require changing functions like 
contpte_clear_young_dirty_ptes(), contpte_set_ptes() and so on, which 
would cause a lot of churn? (they also assume that addr is page aligned).

Since the arch low-level functions basically assume that addr is 
page-size aligned, and the addr handling in the mm core is also mostly 
page-size aligned, I think the caller guaranteeing that addr is 
page-size aligned is a reasonable fix. So:

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

