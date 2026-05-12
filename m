Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3D06CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60626B0088; Tue, 12 May 2026 04:57:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11276B0092; Tue, 12 May 2026 04:57:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF2A6B0093; Tue, 12 May 2026 04:57:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BC6C36B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:57:30 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 47578140444
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:57:30 +0000 (UTC)
X-FDA: 84758164260.22.5F6571D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 577B3160006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:57:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oQuZ1+9y;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=exHNqN7SuHkjc1J7V8Xz/V+f6xoMrx77gpwCilB+r5k=;
	b=Hp9e0XOeEkebDoyT1yXiZgFB9urQqXDKiODwArLg9qhsLN42X38Y+N1NZk1/OEpG7ITVgQ
	/23LRueWumkG02DCG5R7iUOOP4aDkDchEBaKvlP7lwUAga1md8oodHbLKJAutdm25sV6la
	+n3QcLMhb5SwjaR9814ONWSBqTvnJgE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oQuZ1+9y;
	spf=pass (imf08.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576248; a=rsa-sha256;
	cv=none;
	b=M4bSf4S1vigLoPO1toVy0l1W+fGyR20g9akpo0p/j3pozxGu6i1HJM8GjIpQZZYuEeLtBC
	ZBIGSj33slWETHhya2eBoCxaVW+mnjCX9JSqJbKpfSZvpque6rkvjfhPeyPmsiXs9LLfhw
	Kt95ndMvl914C+1+Z64b6Lqe7l1Ibjs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EF79915A1;
	Tue, 12 May 2026 01:57:21 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1F48D3F7B4;
	Tue, 12 May 2026 01:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778576247; bh=ChJGA8LJhtHGwF4qm4tizGPdjMCvlIvG7xBdDCEg95I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oQuZ1+9yFi50Rsv7mmsP4lWaV+RKoCsk4wEHAGmAipxTmjuw0wEUW7j8cW2ePUlyL
	 zpTWLWyKQ5H5j7wJpGKIMMLudbND9quGPUtePYeI/N4omzukw+uPrro6sJTT8DEQgr
	 +Fhv0/Dj9zcaE0CwfmXGY8c+vuiR1hJjcgDX5Ue0=
Message-ID: <b560fb07-ce58-4b34-b53c-499704e9a199@arm.com>
Date: Tue, 12 May 2026 14:27:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/9] mm/rmap: Add batched version of
 folio_try_share_anon_rmap_pte
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-9-dev.jain@arm.com>
 <95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5k84j9owfgn493se914i1k9upiqff5bo
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 577B3160006
X-Rspam-User: 
X-HE-Tag: 1778576248-885098
X-HE-Meta: U2FsdGVkX1/88nC8b5DDbWStE/DPvOd4pJI4wHWuIXFRxFsUE+/EqwhJiX53Ei/a/tDlaaIXMvvA9NmIIwpAkUQlzY8BT500D8PICjW30hwL1ftDFBAIX7OWfJwICMYPi+Nwe6qYTjYmmLaBSXyGwfxI95IjdjPiFpZbqZ+sMwI6hMCSPg4a0tObSGN38giA2LiK+9ysmeYBWW/CLCFO6gUSYP+Uy4eWzVTe/gkOeFJYRYbzDzcwka/E9oxSePvilPMS7nz5hINI/1Ok5ESwuxv5J9ixRwj/Dkk+52xpQ9Y0p9HDnf18wHxb3DSXls0iB3t9Oqp8ifjDD84XA+QjqV7WTMlPJGqdjnYV1Q0dgsmPu3iMIyAgLqnadS3ThwwHhYDytleSF/KWUukBLGCLEGrHhgCKIYHWd86G5WJV6qyQ+u8WHfn0EttQbSrKsRy9JwN1S6pcCb4t/b5pmUI/lKRXiRoW40Wa37eRjM8uRsBnvvJOs7B7iZldrG1dVmboO6LZqUC6rVVs9EA0iOQg9SoWu2Fv45ICavbC4sa0UMgf1UXt52b5D8ukcbDvHllGD1GM8AtIPbO7Vg9Srylu9Cx8NhzKFDZP3PAyOTJGoKd4FZEK2lV6B6Kh6XDDOYVY1c7poXBhfTVtX/WKuvIHF9GENc5RY3h24Fq0jbszEQOvl49Yi0JsrYRhLEA7FQv4Gj8swdLsQRSjuBG31Qnsm2ruaQagJ+QiPhPQtKXuZ1aHAs14G3tfo832c/DRBLl7909Aa9Wqd4/QEFXE1oApgCnKprB/fHBWjHWRWk9OhIr6NCmjqKjrsntdTv78WNOSIVr8bf0Yjplh2NImyg0OMllTeXC3VISZvletJCF/Pes2X/GXL5fRGtfVPKRmxDqK358GOEsqTXcw40TBi+4bXmv0pO1xAwiIrDKq4Qgp8MBrVNcYDyxBhO8T7BK/OfSnM/Nc0a/vZqxFunIUtez
 iv7/Kjq2
 n0PcjqwZd2LzQHbrfwwFVSgvWPi27oo3vZZs7wr9kySnJgOC+RZtddhf9BEY0Mg2ZOC2XipZaHKiCUco03ne8cE/hwhrKNGIC0tMuv9l6MsoBAIc4JAdZgZrBnAxRBQ4gPbtMy9R8BQgsc9RXXGrAFkjL65tUiPliJjouu4j8K2vmTGp4iOOON6Hl371O7cYiY4aVjT/fSmCYy3ChW88qH9ZOObgJ2Essd+nLxkdCmscJBmdCMihQSxiXYrgN9XmO6dR1MmXYVymbW9SgBS2Yavsia0O1W13gnA00HBuW9UPLINulP6ZeriISg0R7hPIcF9pJRTh2tUE0ixNqS4xt9lQ/029fIaApeQCYvxh0exzjNb78VG1/qZhJ4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/05/26 1:43 pm, David Hildenbrand (Arm) wrote:
> On 5/6/26 11:45, Dev Jain wrote:
>> To enable batched unmapping of anonymous folios, we need to handle the
>> sharing of exclusive pages. Hence, a batched version of
>> folio_try_share_anon_rmap_pte is required.
>>
>> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
>> to do some rmap sanity checks. Add helpers to clear the PageAnonExclusive
>> bit on a batch of nr_pages. Note that __folio_try_share_anon_rmap can
>> receive nr_pages == HPAGE_PMD_NR from the PMD path, but currently we only
>> clear the bit on the head page. Retain this behaviour by setting
>> nr_pages = 1 in case the caller is folio_try_share_anon_rmap_pmd.
>>
>> While at it, convert nr_pages to unsigned long to future-proof from
>> overflow in case P4D-huge mappings etc get supported down the road.
>> I haven't made such a change in each function receiving nr_pages in
>> try_to_unmap_one - perhaps this can be done incrementally.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  include/linux/mm.h   | 11 +++++++++++
>>  include/linux/rmap.h | 27 ++++++++++++++++++++-------
>>  2 files changed, 31 insertions(+), 7 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 31e27ff6a35fa..0b77329cf57a4 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -243,6 +243,17 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
>>  	return page - &folio->page;
>>  }
>>  
>> +static __always_inline void folio_clear_pages_anon_exclusive(struct page *page,
>> +		unsigned long nr_pages)
>> +{
>> +	for (;;) {
>> +		ClearPageAnonExclusive(page);
>> +		if (--nr_pages == 0)
>> +			break;
>> +		++page;
>> +	}
>> +}
> 
> Something called folio that doesn't consume a folio is odd. I'd prefer we don't add this.
> 
> Is there a chance to simply change __folio_try_share_anon_rmap, so we get a single loop
> inline?
> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..5a1c874b2112 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -708,16 +708,13 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
>  static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>                 struct page *page, int nr_pages, enum pgtable_level level)
>  {
> +       /* device private folios cannot get pinned via GUP. */
> +       const bool pinnable = !folio_is_device_private(folio);
> +
>         VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
>         VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
>         __folio_rmap_sanity_checks(folio, page, nr_pages, level);
>  
> -       /* device private folios cannot get pinned via GUP. */
> -       if (unlikely(folio_is_device_private(folio))) {
> -               ClearPageAnonExclusive(page);
> -               return 0;
> -       }
> -
>         /*
>          * We have to make sure that when we clear PageAnonExclusive, that
>          * the page is not pinned and that concurrent GUP-fast won't succeed in
> @@ -760,19 +757,21 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
>          * so we use explicit ones here.
>          */
>  
> -       /* Paired with the memory barrier in try_grab_folio(). */
> -       if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
> -               smp_mb();
> +       if (pinnable) {
> +               /* Paired with the memory barrier in try_grab_folio(). */
> +               if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
> +                       smp_mb();
>  
> -       if (unlikely(folio_maybe_dma_pinned(folio)))
> -               return -EBUSY;
> +               if (unlikely(folio_maybe_dma_pinned(folio)))
> +                       return -EBUSY;
> +       }
>         ClearPageAnonExclusive(page);
>  
>         /*
>          * This is conceptually a smp_wmb() paired with the smp_rmb() in
>          * gup_must_unshare().
>          */
> -       if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
> +       if (pinnable && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
>                 smp_mb__after_atomic();
>         return 0;
> 
> 

Okay this is better! I'll do this.



