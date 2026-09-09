Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB498C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22B06B0092; Wed,  9 Sep 2026 03:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D3916B0095; Wed,  9 Sep 2026 03:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C5216B0096; Wed,  9 Sep 2026 03:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B9976B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:44:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C44940119
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:44:51 +0000 (UTC)
X-FDA: 85193437182.04.56A1316
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6FF4C20002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:44:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MviTY7+Z;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788939889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwFYTYxXZAIhywuAYN38Sgz+1wU2nWZyoBVJV40vrso=;
	b=uwNLTNPj65BgqHs3UDAyqgvJ73lud3igspJLKQDxiwTM4ySdQaA2+abAHnNIvLg4Kvpwh9
	mRd+M8DPbV3tcm94VOn+sLjL62MV7QKbdoXfdh8csOHSBK9xgiHOiRnh/K/CAEmfPSu4tp
	kLLO9DCDVN6DrHcZCo7I8kAgwt3J5rs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788939889;
	b=qyMoDv0mjbtrKzx2h3RpU7kx7DACp2P8JtZNb7exbTj0gKkgAa0XGV+ItXO8UWJX6IDjOe
	MYNrjuaYQhAxpIa9iGD8+hfJfXJ8tMaw0F9SMT+eG3fVS/j66H1cUP731qWeL0+Vgjo0O7
	UvQYewItKK3spU4XoiLO6M9OmCdUrRo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MviTY7+Z;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A55F91576;
	Wed,  9 Sep 2026 00:44:44 -0700 (PDT)
Received: from [10.164.19.55] (unknown [10.164.19.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D03233F7D8;
	Wed,  9 Sep 2026 00:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788939888; bh=e0GeJfmPR3dEFuahjfyooZC9yXysPHFN3AqMe/t6B0g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MviTY7+Zb3AHyiEuaB23vkmKxvrKArbkgIEqsKKk8ZshASCZPMVCi/N1ozgdgo60c
	 R28LyHubWCuXzanBwgpBPI41IkZIvnA95GHwUS7trb0oUwadfFU/RtfC7QsSfeYjIV
	 DzLy1DiPrGkxv4aj0jV2QZYZ4FiwDo1vpTJw2U7Y=
Message-ID: <f4edb66c-1891-4d7b-83c2-d8251715fadd@arm.com>
Date: Wed, 9 Sep 2026 13:14:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, baolin.wang@linux.alibaba.com,
 shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260901054358.4049095-1-dev.jain@arm.com>
 <20260901054358.4049095-5-dev.jain@arm.com>
 <CAGsJ_4zWPXoJ5kiLoVcq1YHv6WcmjPEssTUs4OT15iNRob3_rQ@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4zWPXoJ5kiLoVcq1YHv6WcmjPEssTUs4OT15iNRob3_rQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6FF4C20002
X-Stat-Signature: wbz7ow8hpjxhfkgpyeqzncef5js97ki1
X-Rspam-User: 
X-HE-Tag: 1788939889-294108
X-HE-Meta: U2FsdGVkX1+NhVAug3ZA1BX5U+ia0s5br0YJttuGdKJacDFiU72LiakCemMSCK2SXJSt4tyjwJHFq6jaK1toq7fBtADzLVLdk/YCn7FwWpTRoEdwPDOl9lLTdCfikO4RCgTvkFLNPpTLBIM3NmDuiuMZBhXjPrEW2L62CJC2bkgOieBYTkR19lpMHoCe8xba6ovU4OaUsCyVzXDIVd1DRln2XlzUHKTtX8aCEW72b8Xe5euo26fvEvq6GbZwxxKxR6JNCjrK06aG2JVq2lFp/t4DGRIklLjILhrXVFhWFg3G/owMACnxXJ32gS2mbg9v1v5gleqrqY7wM4XU/NuytNxBR0IjESI6tISH8o9baOyVJvmDppvswHxdvh9jy3WKVCyQNF98aIttZ6qHmu0oE7quMAjtXMjYNFTgwkn/k6h9LfoaqqXZop7/LofeRRZEEacYa18Di53LQlVK6bKI8eIpk9Wxu0cmjq9TJCceknlnM5qkKduXISsjrsTyF0/TnwnHi+LMjxDtc2kttsAe0+adkZxOFBQJFLEo4UyHywCbyAm1jlCmWznjDtPC9fBt/b11+9ZrCNxv63u5IwYIXfSTu1Vrne4PK4E5n9K0lx4BL/D449cXC0tbwfz75ryxUs2/meMKv45D6S5EPSBfZx+l/8beLWxGUm5p16EFWoKwCEptLmK8Uwir6i4b6b8BxJeMVhZT1cilcdsjhxaUhJb8e3Y3ztA0KoaTiu0qHGAuyYw8VLzbVxx0aDeNQU4viHD6Jaa0NrqkouiJSp9GUzPkwE6Yf4TucZiA3lTpJjTOM1dTvxWnhrp9lvSchrqQl/tlB6WiYBgbPVrekGgguDirAQTnZk1AoLEMMEsMjQz/7thM9s/8hiZZ8Me9JlFut18E8vf6CRd5cXhU5UHXRpAbvk0sL9MJKetyDiYPl3Pkdrz5Jd1TwebPI+MuYoOYwpghHZ5qnemmCSjBtWj
 eBx9RP5z
 d9DvoX6uIjo5rRTvy7oqkB6IUpQcWurSRTI24LkO6pGjtJ7LKBzJzKQivf4RO4c3blDdChWLjAz7KIu/GJ2Vp0nNBJzC/Rmv2aKg0F0z+KO7m5oWcUtcKV/thUXhe1Lm81nxBgPRmBJsg+nciRf2jRr2L/4xeUoTvH9YV1JGXV4RqCUv/2YIKsEJQLeBfQ5MD3sEcYNry9GxyxXaG70Hnr7i4mgrwSZsl354s2vFfWrILyqV0PX9/hQ7pmJkbhLhtqaVHnl4n29CV7nOoLvnFBFj9vGFiLZa0ODl/gaw3aoZAzR2+X2RdKbfjJhVDwI8EdtL2dOWb+tZF4Nn3GtZXd+RloEk72UmeH1dRi9GYTF8N3Tf31sp/zTgQ5TZPZbAbW3qcAtbhS2nPrLOVIMnh9rb1jA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/09/26 2:49 am, Barry Song wrote:
> On Tue, Sep 1, 2026 at 1:44 PM Dev Jain <dev.jain@arm.com> wrote:
>>
>> To enable batched unmapping of anonymous folios, we need to handle the
>> sharing of exclusive pages. Hence, a batched version of
>> folio_try_share_anon_rmap_pte is required.
>>
>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
>> batch of nr_pages. Refactor the function such that the clearing of the bit
>> can be done at one place without duplication.
>>
>> Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
>> from the PMD path, but currently we only clear the bit on the head page.
>> Retain this behaviour by setting nr_pages = 1 in case the caller is
>> folio_try_share_anon_rmap_pmd.
>>
>> While at it, convert nr_pages to unsigned long to future-proof from
>> overflow in case P4D-huge mappings etc get supported down the road.
>> I haven't made such a change in each function receiving nr_pages in
>> try_to_unmap_one - perhaps this can be done incrementally.
>>
>> Add two WARN's: check that the batch is entirely exclusive (for PMD
>> callers, need to check only head page), and that there are only
>> PTE/PMD paths converging into __folio_try_share_anon_rmap.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/rmap.h | 56 ++++++++++++++++++++++++++++++--------------
>>  1 file changed, 39 insertions(+), 17 deletions(-)
>>
>> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
>> index 0b332770abeed..320f9f14f6020 100644
>> --- a/include/linux/rmap.h
>> +++ b/include/linux/rmap.h
>> @@ -706,17 +706,23 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>>  }
>>
>>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>> -               struct page *page, int nr_pages, enum pgtable_level level)
>> +               struct page *page, unsigned long nr_pages, enum pgtable_level level)
>>  {
>> +       /* device private folios cannot get pinned via GUP. */
>> +       const bool pinnable = !folio_is_device_private(folio);
>> +
>>         VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>>         VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>> +
>>         __folio_rmap_sanity_checks(folio, page, nr_pages, level);
>>
>> -       /* device private folios cannot get pinned via GUP. */
>> -       if (unlikely(folio_is_device_private(folio))) {
>> -               ClearPageAnonExclusive(page);
>> -               return 0;
>> -       }
> 
> Somehow, I feel the early return for
> `folio_is_device_private(folio)` is more readable. Can we keep it?
> Then we can avoid many `if (pinnable)` checks later.
> 
>> +       VM_WARN_ON_ONCE(level > PGTABLE_LEVEL_PMD);
> 
> Maybe the below would be better, as it avoids depending on the
> exact value of `PGTABLE_LEVEL_PMD` and above.
> 
> VM_WARN_ON_ONCE(level != PGTABLE_LEVEL_PTE && level != PGTABLE_LEVEL_PMD);

Can do this.


> 
>> +
>> +       /* We only clear anon-exclusive from head page of PMD folio. */
>> +       if (level == PGTABLE_LEVEL_PMD)
>> +               nr_pages = 1;
>> +
>> +       VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page, true) != nr_pages, folio);
>>
>>         /*
>>          * We have to make sure that when we clear PageAnonExclusive, that
>> @@ -760,29 +766,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>>          * so we use explicit ones here.
>>          */
>>
>> -       /* Paired with the memory barrier in try_grab_folio(). */
>> -       if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
>> -               smp_mb();
>> +       if (likely(pinnable)) {
>> +               /* Paired with the memory barrier in try_grab_folio(). */
>> +               if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
>> +                       smp_mb();
> 
> If we return early for `!pinnable`, shouldn't we be able to avoid
> this? Is the reason you don't do the early return that you want to
> batch the `folio_is_device_private(folio)` case as well? If so,
> that seems sensible.

Yes.


> 
> Is this a real use case that you're supporting with your patchset?
> 
>>
>> -       if (unlikely(folio_maybe_dma_pinned(folio)))
>> -               return -EBUSY;
>> -       ClearPageAnonExclusive(page);
>> +               if (unlikely(folio_maybe_dma_pinned(folio)))
>> +                       return -EBUSY;
>> +       }
>> +
>> +       for (;;) {
>> +               ClearPageAnonExclusive(page);
>> +               if (--nr_pages == 0)
>> +                       break;
>> +               page++;
>> +       }
> 
> Maybe ?
> 
>      while (nr_pages--)
>          ClearPageAnonExclusive(page++);

Was following the pattern elsewhere ... I vaguely remember the
for (;;) being faster for some reason?

> 
> Best Regards
> Barry


