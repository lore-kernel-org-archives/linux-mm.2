Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAADDCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 10:26:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3098E001F; Wed,  8 Oct 2025 06:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27B0B8E0005; Wed,  8 Oct 2025 06:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A268E001F; Wed,  8 Oct 2025 06:26:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 024FE8E0005
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 06:26:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1F8051A044B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:26:33 +0000 (UTC)
X-FDA: 83974567866.29.5D6FDEF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DA67010000D
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:26:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9rudwuc;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759919190; a=rsa-sha256;
	cv=none;
	b=ufvBm2AKqsYnPpOpcx+aWlAgCsNJ8+CrzLmd31JbtDs8mGJ2S50Er6lsff+fr5aVTczydq
	mFqlJ+cHOHtHtHgyTNDD7jkLLgoPCj/jHqNc23ztDejHrZZoTTkJQrgou2T9CyIzLyhPk4
	/cdurBFXdHP2kHeWRrJF9j4xlj0TsiY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V9rudwuc;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759919190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXwIJjBpKXO7E8fE5tUdln6v7OvJUq+AnJH9CrFMoFc=;
	b=rgBEP5PlF7Fqy3sP80iobNMZQgJ6AILPa3yiaeeEPNfwz+udjqqpDccbYs1SnIf3Meo7zL
	yLB9nb58KO7flwa+vu3GNmdDLFqLQInhUErJGeLhPkfTIBwYvewVYq20nOB1eThx/3COaq
	6qJvxOni83AZ+mx5t5OPG1tRbe45NYg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759919190;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UXwIJjBpKXO7E8fE5tUdln6v7OvJUq+AnJH9CrFMoFc=;
	b=V9rudwuc3ISmIvpDWOfuFw5cFZ1YbG6mpPalQh5lthnY8H7uPhdsOQ3dSw5WP1fhDrynV4
	cJRqdiKhmYFNwQ3R5rcthoVOGfhvbqj5PqmtkdtaUSzqtwR/lt4EEqUHLwP1uYQLY6vUuA
	WJTuMVprL7jxFFkK4MnCPFPeqJ9+dJ8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-CKEFsYM_POK-JaZ2jYzvuA-1; Wed, 08 Oct 2025 06:26:28 -0400
X-MC-Unique: CKEFsYM_POK-JaZ2jYzvuA-1
X-Mimecast-MFC-AGG-ID: CKEFsYM_POK-JaZ2jYzvuA_1759919188
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ed9557f976so4913038f8f.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 03:26:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759919187; x=1760523987;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UXwIJjBpKXO7E8fE5tUdln6v7OvJUq+AnJH9CrFMoFc=;
        b=htYpaeJZPmxAFFkeQOINLfNgAnh3RpJAxltJkuKGii3E+h1KEM+TC8eI0FZba0zeKf
         xwMLv/gqPWZ1AY5hLi/boxRZerrEgKAH1xiLEFDKnXaFA2AEL+l9NV0NxQdtxLnLOxZ3
         DIB6NzshWBp+191vJ5iSvh7cEnTBwSB2zGWuh5BOLHSPRrkmlIrI/bFcbGgnMzi9x/2w
         WtDLGW7kBHOkFuu/lJ2PtPLZByA2C5zB2dOqu+U6tdqstwAdxv48mJxb4ijBuUCwNBff
         nIIaqxl47kvtXCGz0R2AmLaMvQbsVUQD/7aRGKaCUWidLOIzkRcTLrCpHMEZOKHb2OMD
         +FKw==
X-Gm-Message-State: AOJu0YzDj30P/8T9BCMfwyvupxheBi1yFLyKG2v9Hk2FwpfWmG2WLspW
	FF8vtqNuaph4K6PZ6jWGrja70s9gwJOaRxLt9iDxaxY++W/v0AAYnMeith1G353m2dfpIcvzk4T
	5ePOMxiupFH0+XjPQ0k8k1xnrnmsIoDQW7cxtRwb84hv2vi+miqBd6eer9KUE
X-Gm-Gg: ASbGncvKnBgrZ6VYokoNLygodNGDtOrwzAjYfLcZApqbuW3U3cWJMLlKdGGVP1McfG0
	XTCYqd8lQUCURAqGiB0xudfjkgXnhYYDC/3zi7x1vccRElUfCy7tD5ZAoCZtqKjOTl7r6r/+g4M
	tToXHHH6taaFkmgJjEl/BkaYS3F8PXdupeDrpfq2K53dJ1iNw/2NuNMyTaS9v+p5A5uVUyYFPsn
	bcGcyemFafHZ7soCZ6NMJF6EIpw6cGZdSiO9BZJ6meqW7jwcDI5RMlJN6PyoaxnodCwivscOjBX
	49NtJJcN6ZxjP71ECuHQoOIjnxx6dtgHYa6tRvoKm2tiiVXkCT+0FXQc48PShn+L9PrNs+Zc3WY
	a285rUhYP
X-Received: by 2002:a05:6000:2681:b0:3fe:1d64:1871 with SMTP id ffacd0b85a97d-4266e8de136mr1541009f8f.43.1759919187622;
        Wed, 08 Oct 2025 03:26:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHHSAhzc7EBO8Wv+Pho47zVV3pMt7ReDYmrIJqLkk48WveXox1GZPXN3xqLxQ5wez5fCeuzgw==
X-Received: by 2002:a05:6000:2681:b0:3fe:1d64:1871 with SMTP id ffacd0b85a97d-4266e8de136mr1540982f8f.43.1759919187164;
        Wed, 08 Oct 2025 03:26:27 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6c3esm29607923f8f.1.2025.10.08.03.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 03:26:26 -0700 (PDT)
Message-ID: <41e7c36a-1349-4973-b133-316c823ead36@redhat.com>
Date: Wed, 8 Oct 2025 12:26:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
To: Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>,
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Ying Huang <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com>
 <CAMgjq7DGy_ZmPqcqUO6s5BN381Zuee_g3KWjVqM3amLhpwE=2g@mail.gmail.com>
 <CAKEwX=PLfQCWZV7i9YP9UvcTmnHZXr635t3BX9D2uLEVr-Fnqw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAKEwX=PLfQCWZV7i9YP9UvcTmnHZXr635t3BX9D2uLEVr-Fnqw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9fAxqheGA9Wq8QNQ6ws90P2-b_o3qlW223b12gEuCPY_1759919188
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: puhxohjuyyw64spa3b7thskcymjexwse
X-Rspamd-Queue-Id: DA67010000D
X-Rspamd-Server: rspam09
X-HE-Tag: 1759919190-323299
X-HE-Meta: U2FsdGVkX189RWgnqUkMgzdytKtiXltjD0izKQofPgIFt0dueKf94z7SBd0V56ux19d7YY+KLTb/ZO6X2oE8NyWT92rgZbxSZrQF5weR34WXoZcFu9xOCRrOuGUc1Zypm5rCG8warQ3bTo9i2nwG8ZSmnIlR/CrT5mpA+eKdma6iTUeymnlVId1Jj62MhPgDEirCCchq3iS+lhFHY5tu3ATkIaGMlN8nxVC4+nPGtdBUcE30a94EAO+/LK+DLamjqTeFHWHpLPlkm7vagc5d69h5rt0BTjGDBONJZT+8Qc1G6ZOajLj1zHGeqZ+oAbisjtc6zmUQMsjILTTCEs2mIfhIePpCsFX0usM1NfeZv2ev9oCNRgdvgdSEyOFIedwQJxWlyuf7urFpG1ndkEnL3KGOrA8P+npyQJZ4yHwgU4pbhJvP/U4aZZV4nnNMCra1DsiSxnwOS1rrMFzO+GKpdPIGQHidmbq9t4696UNE3D8LAUSiBRTVhUjKQrb937DvSBAEMmlWjfixCoro9unTS3+oFMMEX/Zuzga3nmqmVSjBwNBFWtE04vLsP7aHfgowKDB1dUvZTrFT+ZOehzW0w3LBLAHPog84vEoeEuOERoKtdZ5TWma+bzYe+sOQk4/nc65OwFCTMqVxa2/S1B/KHiD8UrTGz6TLQIXf1C/nOwAOAo/a5p8lnRwD3wUeAHBAGjRFLNwjB+ehLjHummehR1FZ1/KepQO2Zj24CMUJdJowWucFlJsfXZW9qEkaFlqN7NfeZaowfEZZNghyLdvsfAI+GfXBkovtg9zaaxteRHUbLFXFNdI7ol+TdrM80KJMD2Hyc9IY470YdvRhu+uCHKIvXv2nqoAcnUftGS+MPxp2crIzqdiLQHVERK9zb15C8st5zdfOI0W87AlE/Me4QHlfJEuSeP6zjzkNw1FqdG0KK5slMgcdtaLRSuWMvDzgYAWcCwehz/KhWFUkTb4
 WujggTiD
 zCXSf1f0B0tB8ujVEOVcPhfCJlZ7xfBFzRsLZo4H1A41o6Slb5qKDpxK/kUKqwTWL0IJk/qJRIiu2CnjIpqmmYR/DrhpfyvYJzVqo9qMZfQv7Ocr8HgRhAIFoU+O+N1YD6SJ5MSvNVCvqv0bLKUsnZI5ShQ31+jyJ3Q4gRnd1czdxV+Vo+4jFmJcv4aj3mCr6q26OzmxJ40tBc+Mq8STeBe4ILXP08HTjSqqHkwtdR2d0NQBidHaU9XgTvwIJYywaaGSeh1MY2qn2+Rhf4G0iHBK1XHb3mv4nnB/gg5hSQECaylNBnwm9u6hnwz/8ofu/QDMmKxVz9tohZfqICMuvSUNDWypUF4ahcXvEZ4KvdxEOii4B1n5AvMXD8MWehs7Fc7Vb5gh82IDsp9ab82BJeB6+mdYtMRIYDWPXhTqPbxAvNKQNGQ6DuRpwQGoYJcze7z9phAX6gcCZEeI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> diff --git a/mm/swapfile.c b/mm/swapfile.c
>>> index 732e07c70ce9..534b21aeef5a 100644
>>> --- a/mm/swapfile.c
>>> +++ b/mm/swapfile.c
>>> @@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
>>>    * Context: Caller needs to hold the folio lock.
>>>    * Return: Whether the folio was added to the swap cache.
>>>    */
>>> -int folio_alloc_swap(struct folio *folio, gfp_t gfp)
>>> +int folio_alloc_swap(struct folio *folio)
>>>   {
>>>          unsigned int order = folio_order(folio);
>>>          unsigned int size = 1 << order;
>>
>> One trivial issue for myself, I better update the kerneldoc too...
>> sorry about this:
>>
> 
> LGTM, with the kerneldoc update:
> 
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> 

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


