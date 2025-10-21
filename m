Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A3B6CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 09:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9EB18E0016; Tue, 21 Oct 2025 05:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FD38E0002; Tue, 21 Oct 2025 05:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F008E0016; Tue, 21 Oct 2025 05:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF3F8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 05:14:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BFAE58E69
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:14:48 +0000 (UTC)
X-FDA: 84021561456.29.526F504
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1319DA0008
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 09:14:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j7ojGWKc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761038086;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jucTygVBOurdtHPEkVo9cYmOwKMehtOeQ9jBrxiOFXs=;
	b=Jx/tn4xquBQS/qMZJHyiWgDq/y4/oCkr0R4A/FDOk7aXBupOy+1PQnUz9XkWmR7s7jd+Hz
	Y2yXDjz0M1TZAtZQT/IpStK2aw6jFYqKG8384VE9s5X+Bqeal/qYg2/4+TFGp+T7pVlsZy
	uxbhiOm7HLF1zkSuqPM9pW3l5ZzqT1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761038086; a=rsa-sha256;
	cv=none;
	b=XopqHjWukI8NLsWuzPvsQZujBkk0n77wk5dGvcuFLbPCtLFlEzAvkamW2IrHvRb+CENwOX
	3ImsmqRQBm4CzmEiEUJUsq/vZElTnPzIM5Vf4mX2VsU044hSYIIexHtlMIIL2O6M+Ui9TD
	0iEV/yp7ZGgbdE2F0173amDRGNMick0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=j7ojGWKc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b3c2db014easo1177273666b.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 02:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761038084; x=1761642884; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jucTygVBOurdtHPEkVo9cYmOwKMehtOeQ9jBrxiOFXs=;
        b=j7ojGWKcv1KzUpNnVB3u2yi1BPTZfBNPk99LKvBaMmLOyH8I7Ei7DOQ2/4jhP0Zisz
         SzaF2fsjzViAlECmLIQDfgaxqEj4CkH3QnFppqUl6bfL9yah/dBrZbQD/WMncueFAFdm
         bBnS5Bw7wrIj4hBxQxX9XqbYrFSumtbquxy9FFHFtGvooMs3R7UGumPi1s9PnmNa1rhq
         MhuP+2i2/XarNcZdrNoRaDukfJOrqVdXIXU/ZF+8I9j8dFGJniWAukYkG2SIfbAD28fQ
         N20gWTzMBCiMK9S7M362LaNkSFJkL8VGFDDJLC+0EdUXk67jjJFr6ZQTOOekD/0X6vrc
         Dyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761038084; x=1761642884;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jucTygVBOurdtHPEkVo9cYmOwKMehtOeQ9jBrxiOFXs=;
        b=kaotqAF17fICIMyPd99b7TvxGhUoXyghnTA28wo7fTYkJx0xv0744KVe+8jQWNIlEt
         B0PtzEkT8wy82KWHHMJCquM1N4iaK9ns7pYgniF1MmJIJydgKIBb8P0yg9Pk4TxlBpRu
         rNAVMRcyQ6hFpfUtqzH/wxVThVtCHNLTV6uEPo+WN9ABqQKLo1pReEJ0bLl+tp4Ocfzp
         CfLd4uJXLJwBX9VUk0CCiOBRyaTS9WrKFLe1NIYC6uiTsfbvqkYnabEbzQkkK9nzer36
         5CfKc0YDoqY6kPT+fQQJ/5aAqIyuoDyWHmjOm41x31Xw/Da65Hz0jBbIja5Tgw8oACai
         nIVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVNSoZtdh9IHPfbA715zfYnClsBpiuPdsfotdj5m4FwrIkAW0ND4gi784HOSvvft4LCGjSZ9+C6ow==@kvack.org
X-Gm-Message-State: AOJu0Yzciu+VPmkOBDLwp8DvgIOKgzlnnErOJ1uuSzNyNhbz/yw+S2ay
	e7EFBitiAfFtp93kfavRrCmYrMSgZQvK5QpGP4qBNbYu0BcwsMkoVAgy
X-Gm-Gg: ASbGncunh/0//UyYk6N27Fyn2pmrvt0gXawD961/+ekKw71IpajVlcUI4Gw3mGRFBcG
	AdREhdvRJMflM63MeZWo/0j5WgYb7rWYa480hLvKPBTajprjnnc+2sQ2IhIfWxA0yJGTzf6U/2q
	Hqe6ZzLwEXaFA/UIIgVhifiXjPnywinxw4emqj0vmifvbeHvbsGSy0FXHsTggmJ3AwxBMea4pBH
	v7EzIIz1aDG49IaE8Lqdcx/jersZALhTrpHhR94buByaD+hvEjQGBMl0XBxEPX3ZGO9g+yfLXaU
	xkkCz6I7kudY2Rzl9Z9bVLJCbm3iifw2AzLydwCx5Bd6r/7wxkwHyNE5M6ThXxprJAfb6+sQB2P
	7XF/kANPtWliSgPLKcpUc95ooFKaWVgkPpuH1y5hqQOMc06DTRQa/vcwornJ6h33XeLrPTVPEy+
	Q=
X-Google-Smtp-Source: AGHT+IFMouRjEsRqn1SVbkPDaqrl+sBgGU6MSu2a+JydYjBrrEpOKFPhPIgQPYv2kKpjyKDWdDlPeQ==
X-Received: by 2002:a17:907:7f8a:b0:b3e:151b:849b with SMTP id a640c23a62f3a-b647493fa43mr2071260566b.33.1761038084113;
        Tue, 21 Oct 2025 02:14:44 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6aaf93a32asm573319066b.51.2025.10.21.02.14.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 02:14:43 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:14:43 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, David Hildenbrand <david@redhat.com>
Subject: Re: [RFC PATCH v2] page_alloc: allow migration of smaller hugepages
 during contig_alloc
Message-ID: <20251021091443.5ggfmvl5jwyknjnv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251020210816.1089910-1-gourry@gourry.net>
 <20251021012533.56rdl6v76plkw4nl@master>
 <E787AD03-DC67-4B5C-8BF6-C79F3C583D00@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E787AD03-DC67-4B5C-8BF6-C79F3C583D00@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: 1319DA0008
X-Rspamd-Server: rspam02
X-Stat-Signature: fcie8azkorw9ukq48jux6ury5gsydeiu
X-HE-Tag: 1761038085-874701
X-HE-Meta: U2FsdGVkX1+0PJDg5rOWL8ORmPWKLAIYS5LEgmHDIWS60Jnkn4JOEVCwOolsG8JcS7t7Q84K1CeSAsCJPU4WNd4OFzVnYyxRo9M+z9wkLZEZ9ej1xiU8/TX5WP/4rNwWgLtOYZUD9dUEKx+EXlrUvNyK9mu+nG9D8sFePknhYtkTEatdXz3++0uMAL4nxCx3oumiD0w3CVJdihBp7bNr20atfMuacui+4519oQABqTS1rh5GBmw1R4I62TRcJmc61t1UP25ljakNsfXv+z8RJ2wk414HYNLqUHXMwvl8cuvI6P/zPCdeWKHWc8tJ3wQDrpwIM74xubxn5Wm8+7TProTvlZzFlk92w1WmLdHwuMRst0cbKC4+pldVgWM6ZJXnJR8tAYBxQN1lzKjSE/2bIzkpPch4L381+6ShxPUj5ORCF0rSof7fD4FtHT48mNufVZCtg8ki8ojC7yoAfojn+sDn1kx0F57XQLylWsHJ8oB37/DwOApTfrSjyDPDLkH/ERO1rK04DgVNMp15Ww3qsF6yOfLbQY3t1NdwwzniTUCGCIccPj0SR2btD+4fbVs5YInei4qAWtuAwBDRtiz3MtB/7idg+2PeY4hlR1X+D4JYkSmRDI1ov0J9EHFZOnwgQJ12E294i9Zz8vdwkadd7Z3jtdqqoXzoABc6Zd6UrUPzxmdK7WRhK1AXZSNmGtw92TSrBZHkW6douU625w9e/fanrqNt5IDvbZRS5HYPq1hB54K3xbShsLxeTfqGtmLyhIUPh2kxmdR+Sr6VhVofzCcjwVFwBGHBVmDhkt86GTTnYzAqEelSelXbILwgaIUAnEGDbeTWDg6x40qSuWM2mHG4Nq5hxnMWu10YAcuT22hhmp8L8mFfQJXh29j2UFRU9W7/SObPMVVazAtTfSsmo4ZNOBFX5e7z8BR9MsNKnOrn2ZU0qnjXP7m8svbDTb5KzPObb8xLNtFMtKZubYl
 eUUf2vLQ
 ULfqHW7Og9uSj++d+Kt63QDuQf5RPXYhV6n0MzHlhhSX/DoJ7GLhFBil3ollCTcHG+xT4r0iLvCpofL9XggqAERnsM/ygDJqXSQaKBng/ojrJxAh6bMvH6OjL70T3dUzzKY8asKOa0XiX1zttpQfzz/QZqx84+9dHgSXmQrhPtPIyq7mE3xhY1Zz2YnzZ/mJOQLj/NoSewYMfRL1emUGcCng3wWLb0Suq5RFdwmPpbR3ztEdzFdqusUN1UZ4TUYpD/lO/VnIRTYn4FWzkNEVXKGKUfPkotV70H+DZfXzLVpyyKjbFkUNw/uPLe1pquvf1bfohu2Vgl5vw/cr3x3Td1rP7m7qgP95nwXXWFiwsjixphVerMTQgMOIGhrWgqWwK2A3dVhJsDsFSNJxmC9d+pevu6YtcIvK6x3Nyqt0lgQsqP3YZJifGVwn0AlsUiSdAi/2Z00iW4KwnFNEEFafPdaKumT9ioSRUdLsepl2R0C1FZnVFsCIyK4U/8MALFcrFUveMO5y3CYwmi1n7SA9rxaGS04pQUTStg4kSPv6w8/f8t+AzKExLW0+XrPt27HYIR5D8NItD2SHh1Kfm2YQAi84+aX+SqDNer/XG7qnPcTGOYQbed2patPwCZvuggeg1F7l4eE03W7J4OsO5OS4M+5/8mWLgn8E3Vfn0JjNdrccBLswnqA42mS0iSFYTlYWa6vT61ln/Nh5xiYKfowaqCF68EYRoTqxS/ewDDDHPDcVsRoSLAwwPfs6xjwQGthUa1guM/9cXMUjfKRwRR6vnMzujsTs3jDRsLxJ5mZkIxVYnVnDvRyccmU6t05PadnsJrYkwy+Wlam72k5pPIkakfStsP7aGQcRFuRZnzY93qy3w0j7HJCZbwp35h4nD7WsL6rKJJAraqZmEqnhi3W5Xoyvlyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:28:18PM -0400, Zi Yan wrote:
>On 20 Oct 2025, at 21:25, Wei Yang wrote:
>
>> On Mon, Oct 20, 2025 at 05:08:16PM -0400, Gregory Price wrote:
>>> We presently skip regions with hugepages entirely when trying to do
>>> contiguous page allocation.  Instead, if hugepage migration is enabled,
>>> consider regions with hugepages smaller than the requested allocation.
>>>
>>> Compaction `isolate_migrate_pages_block()` already expects requests
>>
>> isolate_migratepages_block() ?
>>
>>> with hugepages to originate from alloc_contig, and hugetlb code also
>>> does a migratable check when isolating in `folio_isolate_hugetlb()`.
>>>
>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>> Signed-off-by: Gregory Price <gourry@gourry.net>
>>> ---
>>> mm/page_alloc.c | 15 +++++++++++++--
>>> 1 file changed, 13 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index 600d9e981c23..da2e65bf63e3 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -7048,8 +7048,19 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>>> 		if (PageReserved(page))
>>> 			return false;
>>>
>>> -		if (PageHuge(page))
>>> -			return false;
>>> +		if (PageHuge(page)) {
>>> +			unsigned int order;
>>> +
>>> +			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
>>> +				return false;
>>> +
>>> +			/* Don't consider moving same size/larger pages */
>>> +			page = compound_head(page);
>>> +			order = compound_order(page);
>>
>> How about using folio_large_order(page_folio(page)) ?
>
>See the discussion at https://lore.kernel.org/linux-mm/609E7E01-33A6-4931-AC89-1F4B2944FB64@nvidia.com/ about reading folio order without locking.
>

I took another look at this.

The above code is expanded to:

  page = _compound_head(page);
  order = compound_order(page);
      folio = page;
      test_bit(PG_head, &folio->flags.f);
      return folio_large_order(folio);

If we use

  order = folio_order(page_folio(page))

It is expanded to:

  folio = _compound_head(page);
  folio_test_large(folio)
      folio_test_head(folio)
          test_bit(PG_head, &folio->flags.f)
  return folio_large_order(folio);

These two seems expanded to the same code.

Maybe we can use folio_order() here?

>>
>>> +			if ((order >= MAX_PAGE_ORDER) ||
>>> +			    (nr_pages < (1 << order)))
>>> +				return false;
>>> +		}
>>> 	}
>>> 	return true;
>>> }
>>> -- 
>>> 2.51.0
>>>
>>
>> Generally LGTM
>>
>> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
>>
>> -- 
>> Wei Yang
>> Help you, Help me
>
>
>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

