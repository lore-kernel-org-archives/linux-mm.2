Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A52CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:04:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46E178E000D; Wed, 24 Sep 2025 07:04:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446308E0001; Wed, 24 Sep 2025 07:04:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 334B48E000D; Wed, 24 Sep 2025 07:04:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1DCD28E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:04:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0B7CC04E9
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:04:18 +0000 (UTC)
X-FDA: 83923859796.26.696FC38
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C6E81180010
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:04:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LxuEm00k;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758711856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrljuIrpmbITb85jGMlf+AU3g1TLxbNe5fHByQmiOw4=;
	b=5yAyIcySlQjYj2D83hzIFwG4Ew38eg/WeFzfLDlO6ldgagU7qC25gQ5YvS/8k1iOr+BYFM
	GRu6dmhRBwpY7NlDiwvkuzsueNAbgSNeW9Pa2LJS6j0PpRjhrb0ImrfL9E0H0AE78twbwg
	h7Z/9HMV1G0nmn7h7BpJZph3/NlKH/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758711856; a=rsa-sha256;
	cv=none;
	b=tXrlW2g2YfwuZvn4bhd8f1XbKAcBnkGZBjFN+muhUhSWlR8IiP0i1tGWgAcm8ogpevkZO+
	TJ3fu3t1jipjSBWdjRgy587G6MmmVcn3KWzWVcwR/aklmVBTvp9B14xaTifGoH8jYxgeQl
	oli/Ng9574IpAJ/ij8rAQiJe1biSbm0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LxuEm00k;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758711854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mrljuIrpmbITb85jGMlf+AU3g1TLxbNe5fHByQmiOw4=;
	b=LxuEm00kX9gseM2gkfSaQow0iT+GHXGXbhscl9wskZSYzS3i3UmbFmxIbUCSGt3sxJGwAl
	ZHyqak9LYk6pGcw49n+LG3k6VLAI1QX2EYq7Vd4PcVPwgyPsDyArgxtvVQPO9BT3wu4wJJ
	aW3trNlgJ9O9e4p69gHkg7DO5wH6q7Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-3MTtB-8sMmiOtmr0p1j2qw-1; Wed, 24 Sep 2025 07:04:12 -0400
X-MC-Unique: 3MTtB-8sMmiOtmr0p1j2qw-1
X-Mimecast-MFC-AGG-ID: 3MTtB-8sMmiOtmr0p1j2qw_1758711852
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e19ee1094so25615485e9.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:04:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758711851; x=1759316651;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mrljuIrpmbITb85jGMlf+AU3g1TLxbNe5fHByQmiOw4=;
        b=KiB4RZVS/AywVvKfZYdvpZTdKGVeV5Ks0UhcgJ/4S9DD9apO2VmH0/y9L9S1m4l4pO
         gRzDm4lku41FN483j1yGeB12fArYGoxQzXaSKrKu52z8+lpv7WTZX8oNA7FCPDdUvPTI
         FRrESAa+oKZiHDybXld32CjToWIn5vuBsejR32pfcbLAmFSQEkh0j2qBw/53aP8iRNc5
         g2g7e6nwTmbEtgJJfV4S8kZQY31Gc7fqjhPaVsWuJmnyQ1NemxlVefcd/ZgiOqm8gcTi
         vF9GSvh7Ye+xszSFsI1zqupM5J9BTeIwpEDHqsfxpVW+GnWHhPuhDpJgqhZa4o3KQfJn
         4FLw==
X-Forwarded-Encrypted: i=1; AJvYcCXANupNMyG2b+tC/0yMm2MgyluNIs7TEF2yIZCc7eFOCRLyRwpy3fULGQbtxHf6Lw8Gerv7jFWa/A==@kvack.org
X-Gm-Message-State: AOJu0Yxs8bD8fOpWVFwlkmIF05byM8M9J3mfMQhZwtHUuMVc6qVOHQRQ
	YKdcVsT5icq6qwHQq1O6YpvcudsxlxGcPD3GWfUJKFGe//17fYbsRtoB1OSTpgMVVKNjF+uSiiU
	ppg13y85Jp9NNR3yIrI9dS150PDbwmlNM107J2MHR2gBJ/z1DB/iU
X-Gm-Gg: ASbGnctn46r6jE4yS4cd6uAYzxo0huQ2aQSLqCLWRJ7k5Td1RWvsIDLUgGlyfqOF5kO
	ax+UpqcCZeS2lx/x1Px50v479FUTyNnOLvqXizHkYic87WEhQUkvbLxFvB5DtVX/WlHgL7q9YY0
	AlaAM8GEWW8PX61LmDG3Wvsqrwy4m0HBgkhCKczKUTEMy0VjuhR+kJJxVpwhiRttYluF0nqSjvS
	ENLa00lphe8tg3zCevI3RYgSY+NqXyI6DF28PdL1IzgfU9dsaAAHfj0Dx7/8Afag8qZuBRGIBPp
	WJJYF9fgRaoxANdIrcwlqMUnjgOQG9bHKcPXrVhB6PBem6Z/WnohYsM9H/jXgc8gkrnpt76w/t3
	4mkBZKWP9bDg08vUPEl2CRe8o1ZI0eWFpxMnmOn/S4nWcf9VCztuIiayRTRBU65kzvw==
X-Received: by 2002:a05:600c:1c08:b0:46d:d6f0:76d8 with SMTP id 5b1f17b1804b1-46e1dac9fcemr74296465e9.35.1758711851514;
        Wed, 24 Sep 2025 04:04:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExYOxpci5QLmPvizPk29ikl+FA6dmszx1aCY/b5DkFPNIURQjjjajZAf2da25kjbr5619Hpw==
X-Received: by 2002:a05:600c:1c08:b0:46d:d6f0:76d8 with SMTP id 5b1f17b1804b1-46e1dac9fcemr74296065e9.35.1758711851051;
        Wed, 24 Sep 2025 04:04:11 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab6a514sm26958575e9.22.2025.09.24.04.04.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 04:04:10 -0700 (PDT)
Message-ID: <c7a2ad6e-68cb-4689-b72e-6e7ebfcf5e64@redhat.com>
Date: Wed, 24 Sep 2025 13:04:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v6 01/15] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, damon@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Ralph Campbell <rcampbell@nvidia.com>,
 =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Francois Dugast <francois.dugast@intel.com>
References: <20250916122128.2098535-1-balbirs@nvidia.com>
 <20250916122128.2098535-2-balbirs@nvidia.com>
 <882D81FA-DA40-4FF9-8192-166DBE1709AF@nvidia.com>
 <f026c5a1-ec51-4fa5-bc58-c2d690f9248c@nvidia.com>
 <87F52459-85DC-49C3-9720-819FAA0D1602@nvidia.com>
 <891b7840-3cde-49d0-bdde-8945e9767627@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <891b7840-3cde-49d0-bdde-8945e9767627@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3bDllwija40sCDtMliE2ODMBGMDRH15Yc9HhnZBRsYU_1758711852
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6E81180010
X-Stat-Signature: waa1ewh7wnnq7c17e7whazyzqmjz9jwu
X-Rspam-User: 
X-HE-Tag: 1758711854-573435
X-HE-Meta: U2FsdGVkX1+IliXBndagWiAIcXJEDji6Jx+FUCcFSgxsgnbLsMMONkYzP6i9pumwofOXR8rJbMokLmbsQgyP1wjVuPEZ8OdR+hN8aMZU7KIFBPAJNCLw45X+5oR14TiRhFRH/2hsMkA5c/zZqXQxfBDVqNeswgFaJyJDA2fQ4Wzh3K/82iQzUc+Qm9/pSwccFuDB9gbp1xAFDvPTVldvSJxLP2iy2/NrltQ/sQNRQsG76sO7Y5j0l6UL2hM78q/kZ3woc21Ghwb7HBFoXQvYW5hy4guVzuYM5lUPttVDNnp/YOxrLxnk0BPFsYTPlyl/HuMq25YuxLd6+aROvMAoHbqBoie9HJRyMyKRUcnIv3V/br8jvS4xGXvC7EuwWse8+pFMsOVFum5VpFQoKF7BIe94jBkxyeAQu058Y1lcQxqvGg3tGCMFuiOAnZnn6HfUUXRhlgztGfPKA4tHjX7Vth0jP7G2ry3j8JD58D41T/ceM//B9KjHJktKoFT4UZ/jn03Gd2y8BKjvnSPn6zQA4oNqbfsYFFnURnx4zRDPV41Rw8oBEM/WpfoLbhZ8ncHBMLdQfZry8Yaaot7oOHTprYx6H16I6FSEN+crRixt04mX6OccdpBv/mSRb1Zo4cta7V11wJ5jTj2F3kjQkWxgGmmmwEaD91EW5WXXP2mWR2gEYzFYMxTNhMxJXjDvSuMKUeQsho1CS5oA5nYb6xOphAm47IroiND1X4PZu/PrNnqkxiGkSVEhuruILTXDqgQlSSG00he93CyGAyvnTGCe3H5hk2jaTwEnuLjMlZkBVYOo0IFXPhwtyJVr6+02njzVYMgxJyFuycpLCSx5FIyfetpPs9rZyyowfAmRqFFoGDJdl3x6NXNqW8OGox1cRe/X03TrwoUKnFquyTjzfPjYNx9Xsxl/79nZDeN8wIQVb0h1Z6bAZQoyBDGurcxIqivXPkfvrDBItBEKQxvlwkz
 PsbhZMO+
 UQ+beujZngVFNTPNV8XLI2vzvaIMuoqQmnpyVx+nDp5N5iM+sBaRsrw8aEX4leKNGBdLTG6oLp3VJcJlABGN8MkECw7pIXe0ZsuBSDa9uZATNHeU8SFxjDk9Gkxbf+Cp2Bd7YjQsIQlgA7mJ8dwolgf7N89NdvV+oQ8iUb0ADrdVLOWwjA7fxwxoYnyuerAOeel6cSiM5JJFLkjTCjPaTtdl1S7+5tyghTs+XTNPJ0oJ8hHJL7tJspAdFnoYIu0V6WyO30Irw5vyXibZ7ZXyltNugVPEN7XH7S787VbyvntfUg7jNxi62TjksFJJBuZdDnrvQK66rcd4Jv/5oo2K+blvh+oOd7aiR+1kr43ejY0Odry6x0GKoZxHyMFLEE0f3cYYrg24Vb1bNaewxmEC+AvZ50XLzKkooKo0XNS0wK+wpp1+Jak2CBdKObMBJPSMHl2RU/9wn1FZA+h4B+5LofSzekFylNRPb/GO5RAiHBm74yk7J4HyCcqtjQesMIbY17UZj2POWiGESIwAB78GGNqWG4EpYrIRxwIdKUKxRfY5uyMDuh4AdT8MEhJgZzdn/39Q4XmcvHKH36V58cEpecCJeJ66OOnB/VIkU9t428e/sbYEHRegIqZnT54/zEJZY6GiuS7D1sA/6VAcstYiUZM1vMTmFlCsOcaJ3brnwTMdYS9nvpt9GDdVcaY/XsV5uyhfz9YJzy8vOwzNqz/zrqMyICFcRkp4JgGUsb4i7d5C/zElxe4zj8/UEH53/pwC0hL+XfRNS5qUM3PtfxXSWJhdWVHrvnWdG9DqcW+CJYy57fh0dqKy7bkRtryHjjp+L3zJc6UYsirIPaKbTgQ0W5MDYxC2QBujNXCYGsxz0XKgdFDi3FqCKCsbfSA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 05:47, Balbir Singh wrote:
> On 9/19/25 23:26, Zi Yan wrote:
>> On 19 Sep 2025, at 1:01, Balbir Singh wrote:
>>
>>> On 9/18/25 12:49, Zi Yan wrote:
>>>> On 16 Sep 2025, at 8:21, Balbir Singh wrote:
>>>>
>>>>> Add routines to support allocation of large order zone device folios
>>>>> and helper functions for zone device folios, to check if a folio is
>>>>> device private and helpers for setting zone device data.
>>>>>
>>>>> When large folios are used, the existing page_free() callback in
>>>>> pgmap is called when the folio is freed, this is true for both
>>>>> PAGE_SIZE and higher order pages.
>>>>>
>>>>> Zone device private large folios do not support deferred split and
>>>>> scan like normal THP folios.
>>>>>
>>>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>>>> Cc: David Hildenbrand <david@redhat.com>
>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>>>> Cc: Byungchul Park <byungchul@sk.com>
>>>>> Cc: Gregory Price <gourry@gourry.net>
>>>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>>>> Cc: Alistair Popple <apopple@nvidia.com>
>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>>>> Cc: Nico Pache <npache@redhat.com>
>>>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>>> Cc: Barry Song <baohua@kernel.org>
>>>>> Cc: Lyude Paul <lyude@redhat.com>
>>>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>>>> Cc: David Airlie <airlied@gmail.com>
>>>>> Cc: Simona Vetter <simona@ffwll.ch>
>>>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>>> ---
>>>>>   include/linux/memremap.h | 10 +++++++++-
>>>>>   mm/memremap.c            | 34 +++++++++++++++++++++-------------
>>>>>   mm/rmap.c                |  6 +++++-
>>>>>   3 files changed, 35 insertions(+), 15 deletions(-)
>>>>>
>>>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>>>> index e5951ba12a28..9c20327c2be5 100644
>>>>> --- a/include/linux/memremap.h
>>>>> +++ b/include/linux/memremap.h
>>>>> @@ -206,7 +206,7 @@ static inline bool is_fsdax_page(const struct page *page)
>>>>>   }
>>>>>
>>>>>   #ifdef CONFIG_ZONE_DEVICE
>>>>> -void zone_device_page_init(struct page *page);
>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order);
>>>>>   void *memremap_pages(struct dev_pagemap *pgmap, int nid);
>>>>>   void memunmap_pages(struct dev_pagemap *pgmap);
>>>>>   void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
>>>>> @@ -215,6 +215,14 @@ struct dev_pagemap *get_dev_pagemap(unsigned long pfn);
>>>>>   bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
>>>>>
>>>>>   unsigned long memremap_compat_align(void);
>>>>> +
>>>>> +static inline void zone_device_page_init(struct page *page)
>>>>> +{
>>>>> +	struct folio *folio = page_folio(page);
>>>>> +
>>>>> +	zone_device_folio_init(folio, 0);
>>>>
>>>> I assume it is for legacy code, where only non-compound page exists?
>>>>
>>>> It seems that you assume @page is always order-0, but there is no check
>>>> for it. Adding VM_WARN_ON_ONCE_FOLIO(folio_order(folio) != 0, folio)
>>>> above it would be useful to detect misuse.
>>>>
>>>>> +}
>>>>> +
>>>>>   #else
>>>>>   static inline void *devm_memremap_pages(struct device *dev,
>>>>>   		struct dev_pagemap *pgmap)
>>>>> diff --git a/mm/memremap.c b/mm/memremap.c
>>>>> index 46cb1b0b6f72..a8481ebf94cc 100644
>>>>> --- a/mm/memremap.c
>>>>> +++ b/mm/memremap.c
>>>>> @@ -416,20 +416,19 @@ EXPORT_SYMBOL_GPL(get_dev_pagemap);
>>>>>   void free_zone_device_folio(struct folio *folio)
>>>>>   {
>>>>>   	struct dev_pagemap *pgmap = folio->pgmap;
>>>>> +	unsigned long nr = folio_nr_pages(folio);
>>>>> +	int i;
>>>>>
>>>>>   	if (WARN_ON_ONCE(!pgmap))
>>>>>   		return;
>>>>>
>>>>>   	mem_cgroup_uncharge(folio);
>>>>>
>>>>> -	/*
>>>>> -	 * Note: we don't expect anonymous compound pages yet. Once supported
>>>>> -	 * and we could PTE-map them similar to THP, we'd have to clear
>>>>> -	 * PG_anon_exclusive on all tail pages.
>>>>> -	 */
>>>>>   	if (folio_test_anon(folio)) {
>>>>> -		VM_BUG_ON_FOLIO(folio_test_large(folio), folio);
>>>>> -		__ClearPageAnonExclusive(folio_page(folio, 0));
>>>>> +		for (i = 0; i < nr; i++)
>>>>> +			__ClearPageAnonExclusive(folio_page(folio, i));
>>>>> +	} else {
>>>>> +		VM_WARN_ON_ONCE(folio_test_large(folio));
>>>>>   	}
>>>>>
>>>>>   	/*
>>>>> @@ -456,8 +455,8 @@ void free_zone_device_folio(struct folio *folio)
>>>>>   	case MEMORY_DEVICE_COHERENT:
>>>>>   		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->page_free))
>>>>>   			break;
>>>>> -		pgmap->ops->page_free(folio_page(folio, 0));
>>>>> -		put_dev_pagemap(pgmap);
>>>>> +		pgmap->ops->page_free(&folio->page);
>>>>> +		percpu_ref_put_many(&folio->pgmap->ref, nr);
>>>>>   		break;
>>>>>
>>>>>   	case MEMORY_DEVICE_GENERIC:
>>>>> @@ -480,14 +479,23 @@ void free_zone_device_folio(struct folio *folio)
>>>>>   	}
>>>>>   }
>>>>>
>>>>> -void zone_device_page_init(struct page *page)
>>>>> +void zone_device_folio_init(struct folio *folio, unsigned int order)
>>>>>   {
>>>>> +	struct page *page = folio_page(folio, 0);
>>>>
>>>> It is strange to see a folio is converted back to page in
>>>> a function called zone_device_folio_init().
>>>>
>>>>> +
>>>>> +	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>> +
>>>>>   	/*
>>>>>   	 * Drivers shouldn't be allocating pages after calling
>>>>>   	 * memunmap_pages().
>>>>>   	 */
>>>>> -	WARN_ON_ONCE(!percpu_ref_tryget_live(&page_pgmap(page)->ref));
>>>>> -	set_page_count(page, 1);
>>>>> +	WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
>>>>> +	folio_set_count(folio, 1);
>>>>>   	lock_page(page);
>>>>> +
>>>>> +	if (order > 1) {
>>>>> +		prep_compound_page(page, order);
>>>>> +		folio_set_large_rmappable(folio);
>>>>> +	}
>>>>
>>>> OK, so basically, @folio is not a compound page yet when zone_device_folio_init()
>>>> is called.
>>>>
>>>> I feel that your zone_device_page_init() and zone_device_folio_init()
>>>> implementations are inverse. They should follow the same pattern
>>>> as __alloc_pages_noprof() and __folio_alloc_noprof(), where
>>>> zone_device_page_init() does the actual initialization and
>>>> zone_device_folio_init() just convert a page to folio.
>>>>
>>>> Something like:
>>>>
>>>> void zone_device_page_init(struct page *page, unsigned int order)
>>>> {
>>>> 	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
>>>>
>>>> 	/*
>>>> 	 * Drivers shouldn't be allocating pages after calling
>>>> 	 * memunmap_pages().
>>>> 	 */
>>>>
>>>>      WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order));
>>>> 	
>>>> 	/*
>>>> 	 * anonymous folio does not support order-1, high order file-backed folio
>>>> 	 * is not supported at all.
>>>> 	 */
>>>> 	VM_WARN_ON_ONCE(order == 1);
>>>>
>>>> 	if (order > 1)
>>>> 		prep_compound_page(page, order);
>>>>
>>>> 	/* page has to be compound head here */
>>>> 	set_page_count(page, 1);
>>>> 	lock_page(page);
>>>> }
>>>>
>>>> void zone_device_folio_init(struct folio *folio, unsigned int order)
>>>> {
>>>> 	struct page *page = folio_page(folio, 0);
>>>>
>>>> 	zone_device_page_init(page, order);
>>>> 	page_rmappable_folio(page);
>>>> }
>>>>
>>>> Or
>>>>
>>>> struct folio *zone_device_folio_init(struct page *page, unsigned int order)
>>>> {
>>>> 	zone_device_page_init(page, order);
>>>> 	return page_rmappable_folio(page);
>>>> }
>>>>
>>>>
>>>> Then, it comes to free_zone_device_folio() above,
>>>> I feel that pgmap->ops->page_free() should take an additional order
>>>> parameter to free a compound page like free_frozen_pages().
>>>>
>>>>
>>>> This is my impression after reading the patch and zone device page code.
>>>>
>>>> Alistair and David can correct me if this is wrong, since I am new to
>>>> zone device page code.
>>>> 	
>>>
>>> Thanks, I did not want to change zone_device_page_init() for several
>>> drivers (outside my test scope) that already assume it has an order size of 0.
>>
>> But my proposed zone_device_page_init() should still work for order-0
>> pages. You just need to change call site to add 0 as a new parameter.
>>
> 
> I did not want to change existing callers (increases testing impact)
> without a strong reason.
> 
>>
>> One strange thing I found in the original zone_device_page_init() is
>> the use of page_pgmap() in
>> WARN_ON_ONCE(!percpu_ref_tryget_many(&page_pgmap(page)->ref, 1 << order)).
>> page_pgmap() calls page_folio() on the given page to access pgmap field.
>> And pgmap field is only available in struct folio. The code initializes
>> struct page, but in middle it suddenly finds the page is actually a folio,
>> then treat it as a page afterwards. I wonder if it can be done better.
>>
>> This might be a question to Alistair, since he made the change.
>>
> 
> I'll let him answer it :)

Not him, but I think this goes back to my question raised in my other 
reply: When would we allocate "struct folio" in the future.

If it's "always" then actually most of the zone-device code would only 
ever operate on folios and never on pages in the future.

I recall during a discussion at LSF/MM I raised that, and the answer was 
(IIRC) that we will allocate "struct folio" as we will initialize the 
memmap for dax.

So essentially, we'd always have folios and would never really have to 
operate on pages.

-- 
Cheers

David / dhildenb


