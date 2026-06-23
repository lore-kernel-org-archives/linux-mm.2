Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 895F7CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6537C6B008C; Tue, 23 Jun 2026 06:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62BF36B0092; Tue, 23 Jun 2026 06:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544096B0093; Tue, 23 Jun 2026 06:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FEDB6B008C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:03:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A45E9120441
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:03:23 +0000 (UTC)
X-FDA: 84910739886.06.5AEF2C0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 864A514000F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:03:21 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eA0tg0G0;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782209002;
	b=zjhpa5KLacFiWY670tryz2ef0ad7rYJjQ0WZRzL+aeEXXvFrZK6JFHYir8gY98Qm1o9CHC
	f8vQy2JsbNnXH9QVdQ+MBaStMyMoCYCbOCTylZ35opdXMvW2zk04zRI12WofQ21eq4jCJg
	Srj2ejVvgl2achd7XfrJ+0Ayefsev7s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782209002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=teB/h5GADEtDsgjGHyFS32ITnjRyEtd1vgsZIJghlB0=;
	b=akvhMwc+/GH6IQ25zKXBLqc9txursUCVWciPmbpOF8ElJ5rLcW5V4B/xZkpeBIQC+SlI85
	mmsX1q01itImK4wilHyk27zszPq7UkU7NKWnPVpVgOIHAFNO8gWP6Y0MuWGZ+uLA0NkP3S
	+vNT8fYSuowf9himTlfIjlhAdcvCtuw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=eA0tg0G0;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D3B392F;
	Tue, 23 Jun 2026 03:03:15 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 024293F632;
	Tue, 23 Jun 2026 03:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782209000; bh=pMiJn9AVMsjDxLBSA9Pg+nfI5z/CtaYasU8faQqnI1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eA0tg0G0wJRnZHMeS0kxkbAelz4GKfw9hru5z2iUs20XNqFzhJchjvp/ndC6OVVwa
	 ZKShpTWy6IL4zS5q7DfTbmrxZLpNPp0Xrn8AHhPJh1AXMIKxrZ6H4qeFnEoQMhkVk+
	 oKXR/hdMc7vWpr4AJrrBU0+yruVXufNl1/am7s2E=
Message-ID: <9a80af3f-439c-43e6-a65d-66a58c482604@arm.com>
Date: Tue, 23 Jun 2026 15:33:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] mm/swapfile: Add batched version of
 folio_put_swap
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-9-dev.jain@arm.com>
 <17c5f031-17e5-44c3-b572-ee224cb294cd@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <17c5f031-17e5-44c3-b572-ee224cb294cd@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mgrpnatxkm1m96367c9idegrqask9sfb
X-Rspam-User: 
X-Rspamd-Queue-Id: 864A514000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782209001-614492
X-HE-Meta: U2FsdGVkX18+EDZi0sE4Cta+uIGZPV0hDlOq32wiYMsGeY1fUAMErCDesseb/Q1A/TzJX1Y/meabzfkxs0cfNKJXY5GszD4xtdDO1urBA8jBsfpvUBLsZEDf21E5P8Yt67/h54DZethUNrEMePWbTHzyMAr4Ul5Hznf5rtV8WSTMvxzZn1N7gEmqIch8e75uSsPcdx2WeSk9he51Cwwvjvr3dqVXR+EZ24n4GBB5oFrJikFmUPCc+n4BPpvXDAYacaRU1qmND1bT531ta0RfNHZhjC+pEDW/btEget5D4+pTQJkVmAVozB/fcFeBFUnjwkdGJLers0LDdZhYsmGKnPYUCyazEV3k242TPYgmrufbWzHC7f9i+zOrO/KL2txXdE7JT4Vh19MSBKUgrEYQCEYfD2JyjwTewa0X6+LlVn/XXtBjROMYSGkwCEae9VaoF525rg40zsdmnZBj7dfybem73ga8Z1LaNCYbUvC+NhuMQuIST4WkNdNatBupxYROZnH5VK+Ke5eGVu3GcEUP4oPvKUinFQtgZLZC7FRY08GIM3kf4UPnaoi4LZVmCW9WO6qIeA5stOaqUwMbkvK9CFAYhkSmIM1yQzA6mi6JIAgDH9IpZdw0hDzR889Ud98O01r3UYGY1ROa6CK6oQjXcCAa9WddFGTpGgf2sURZO3d9YWXgH4BZZwb8Btu/NDDcgvDCBmbOPdMQJattLewIj082dVbpAnTbvtjly0ojczgAeIUZpFocogCemrNR7h6zZOElNvPp9v8932UpO50LSzZEYgdGD5ZrDxu/Pe5VpTZenCbEnf4+XDwzuO4qUrf6hLq5YQgGzvJ3uHNisW+vOzLfRqznQ8tW2fdCFTIBVSeRA8AiaXUsYMmBHzIYz8tyib+2uvUTcrJUr/EYNd7F8BsDdt7vIVffusGoGp/xcmU3lEBCWt+NZEp0uOJRn/RA3v6AM7uK9qbiPUbwi41
 EJzmwNWK
 02Z2vlR4a7PkmLK0bE8Qw4VOc4NF+bD4+kuJhnvZ1GUBw+Uq0KXlbhEzFPNs7XbMnZhYYnNxxlFRp27Xvp7zopPuRBtItlOMt4AjeCzqPeE1kM36DmtL+xJsZWQoWP7WUNtfRfdbDXEZLpnKucFSkTg5jDYSRNQwNVQDJcUQDOr2EEubXlh5k7cJjgWDMiaeyYwtvdH5Ri3wdEuXZVebh7x45/yExaF2xsBgTpVKkORwl1HApz63HIvt6AIxdjLlXtfVjTq9u8sweDAU1QBD0OT31pM9vfg/cjlllZ9X+Pikzu2c6n94I+HW896LC/IhI84SskPVKyw3JmtlXYcoDky1b5kd3g6DhEfCX7qzy0/F0QX1fkFcgqZWb8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/06/26 7:24 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
>> that folio_put_swap already can handle a subset of this: nr_pages == 1 and
>> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
>>
>> Currently we have a not-so-nice logic of passing in subpage == NULL if
>> we mean to exercise the logic on the entire folio, and subpage != NULL if
>> we want to exercise the logic on only that subpage. Remove this
>> indirection: the caller invokes folio_put_swap_pages() if it wants to
>> operate on a range of pages in the folio (i.e nr_pages may be anything
>> between 1 till folio_nr_pages()), and invokes folio_put_swap() if it
> 
> "between 1 and folio_nr_pages()" ?

Ok.

> 
>> wants to operate on the entire folio.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> 
> [...]
> 
>> +++ b/mm/swap.h
>> @@ -208,7 +208,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>>  int folio_alloc_swap(struct folio *folio);
>>  int folio_dup_swap_pages(struct folio *folio, struct page *page,
>>  			 unsigned long nr_pages);
>> -void folio_put_swap(struct folio *folio, struct page *page);
>> +void folio_put_swap_pages(struct folio *folio, struct page *page,
>> +			  unsigned long nr_pages);
> 
> Nit \tab\tab (same below)
> 
>>  
>>  /* For internal use */
>>  extern void __swap_cluster_free_entries(struct swap_info_struct *si,
>> @@ -397,7 +398,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
>>  	return -EINVAL;
>>  }
>>  
> 
> 
> [...]
> 
>>  
>>  	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
>>  }
>> @@ -2499,7 +2497,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>>  		new_pte = pte_mkuffd_wp(new_pte);
>>  setpte:
>>  	set_pte_at(vma->vm_mm, addr, pte, new_pte);
>> -	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
>> +	folio_put_swap_pages(swapcache,
>> +			     folio_file_page(swapcache, swp_offset(entry)), 1);
>>  out:
>>  	if (pte)
>>  		pte_unmap_unlock(pte, ptl);
> 
> 
> We could consider having a simple folio_put_swap_page() helper. But maybe most
> of these will be converted to batching in the long run either way.

Yep.

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

> 


