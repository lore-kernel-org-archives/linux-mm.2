Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC34D374AF
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 22:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A646B00AD; Fri,  5 Dec 2025 17:15:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B3E6B00AE; Fri,  5 Dec 2025 17:15:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A4B6B00AF; Fri,  5 Dec 2025 17:15:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC616B00AD
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:15:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE16D57F6A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:15:39 +0000 (UTC)
X-FDA: 84186825198.19.389052A
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf24.hostedemail.com (Postfix) with ESMTP id BC2E218000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:15:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kOxxZari;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764972937; a=rsa-sha256;
	cv=none;
	b=GC7oW3Qau8r6PbMT70wxR4DPPPMoCpiH+3LnDYpwkvoza/LXfBT8Pvtds/I1MM39hBEhTf
	irGIvEKol4daTJJAYdTeyIFZACtM//JPnCITE951CKABPQllb94TsHN7J7Z+6xeIOsIERJ
	qoFX8C9BCASQLi2shCzIYqlnAGwz6P0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kOxxZari;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764972937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v6uADHyrPwoSXxbUmXf8HVGm6kBMdxAZOGM1duysCo=;
	b=hGzs5l8Ky0ZppVspcIIqmE95DOsrc1oxWgoZhYifVPo9nMh56yxQOT/plMK+r8XWvp64jG
	S5d54vt0mgdICAhAYlUlJHcuVUjtL4/rTffIR4o5Mq6eAG9Dh3BfEo2eSVDZibjDQyEljx
	7GHm0+rZjf7BWFLv4FGqsQPOWV1rFyM=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso20646445e9.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 14:15:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764972936; x=1765577736; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5v6uADHyrPwoSXxbUmXf8HVGm6kBMdxAZOGM1duysCo=;
        b=kOxxZariQ6TLpD7FmZbsZzH2F7/05X78Z/Dr5oMgrZof+kxHorbBlOW0u13j7ZCcJ5
         i3m55198qR5fb9ZEDOYBKddIhxOW8ioC9mAsXGg0J4FzkH4RUuIT3Mn9SYnalXB6cPV8
         x/ijysYxkzLIVpuhlLDVmQ8o5biR9SCrTTkPkwEzu3ONbVCHxqK0ZyIkP6A1+Uo0PMYq
         XimXLb6ykMg7AFBuDOLaqn2m5YF1xhRmpFGHUsRWM5Sb8Q+ac5/O7yV6VJmUE9Mb2K82
         bafouIkNfpue56Ga+oVdc0XDjzFBigJS+8njItyeXmagGHj0dZnildVwlnJwCj0GesSC
         QOmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764972936; x=1765577736;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5v6uADHyrPwoSXxbUmXf8HVGm6kBMdxAZOGM1duysCo=;
        b=cY8aUQrN29WmnLvODT4JUdnLAXHnKhhACuz55s8AqVyiyHbY3ocSelc+vo6anEqsRK
         oVpTU4Q9ro7ieFQLXExLc+FCitEOstVjHZmG8UiqfUSJe60DSMy8v035cZEDjuUOXfsl
         deXWQp4QHVOoXJyJMAn+/nOOwB+ylm9xbAQol4UsmdaxTo0p6vWPBwKcnsn6HVtsqIFT
         XvumFRTl/yGE8+inRb9zFtwhwMjSUXhx3zT05Ars6Zae6oU6FZEY3uxk+5aREDqTe/h1
         o2VhPSRv5y0DVReKynKUJ4LotS6mqJrFEN6waugjIzyzmD5MAU1plzSqru+mnb0HizuB
         P2Ig==
X-Forwarded-Encrypted: i=1; AJvYcCUTGxMiGRhhyn5dMGbvUT00PKCQGhZ+otb7Pu0qRFBrDxSI87hw9afnPl6em7uw7EyD6UxqF6OWlg==@kvack.org
X-Gm-Message-State: AOJu0YwihXWUKlldh2nktFDRT/9HJbyhmuYkMd9I38/uZfNbRm3VBUDh
	NsxHvnpmvFj5lx0Trdj1xvpZFnShfu1GinfuXZ4/UM8ii6mmkaVQy5JP
X-Gm-Gg: ASbGncsKV6z3A66ErtUJeVRkLaWh8RgVGwCs0G0Vms6ZzeS0QKTviaa2ogh+y2m4YFg
	NgCHUfRf678l6nxwFikozzN1LQLCjrQ2Z0P1V+KniPTYWK8KE97z/EMGBryMoy9Zmg9orK0xCDJ
	noTmj1QkXyyb1dUmL6dQHV+jOOzMSow/VoAZQdEs3DkGenU/Ww/aQ7nUX1DmXvo58VZBR6uAxHD
	nPmE30wPpbRc03dgnJdcwdJf4sUhx+gtPoJDvus4gEbA0oZbPjN2jl/u/zp8W2qs1lFnPoVHIBJ
	p8KXCMLhpmdTENTwjXBGt+dFDeJOjpO7gOQk7npXRlWrv+b4COxlDHDZeD2bquvYlwamCfSLx48
	+n/EX2IwB3bCTQ72z1XYa9hF8XO8sTaESPD+gFcVKcZz+wRGClDNcTb+ANzIMeFF/s+cSTOi9/q
	EabbcUhRZ1gsoY7w/gu/F96i5IFAKgikcf8XhWZ4whIcnGXPPgfZjvlE99RQ1nazd04pc2BG6a8
	ggimbP29I9u
X-Google-Smtp-Source: AGHT+IGr0mJ0TQEJhtTmxbJJqr1Gb9Tqe8as+0pV6SSOhQvHyMjjnnr6lXkpXvUuRzvQDw1saw/9CA==
X-Received: by 2002:a05:600c:4fd6:b0:471:1765:839c with SMTP id 5b1f17b1804b1-47939e1e42fmr5286815e9.20.1764972935942;
        Fri, 05 Dec 2025 14:15:35 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d222491sm11419404f8f.22.2025.12.05.14.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 14:15:35 -0800 (PST)
Message-ID: <af9cf69f-c66b-48ea-8617-f4fcd1bc797a@gmail.com>
Date: Fri, 5 Dec 2025 22:15:34 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] mm: Change the interface of prep_compound_tail()
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-2-kas@kernel.org>
 <77d1911d-7b67-41c0-933e-b2a0810cf3b4@gmail.com>
 <gdkhm6ckcrwy6ezetpb6u2m4sfdeqsf4ftg2vb557zipvdepyh@u4f6pyrompd7>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <gdkhm6ckcrwy6ezetpb6u2m4sfdeqsf4ftg2vb557zipvdepyh@u4f6pyrompd7>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC2E218000D
X-Stat-Signature: 4cfe5zexq1on651jequzmcd1psgrs8c3
X-Rspam-User: 
X-HE-Tag: 1764972937-473871
X-HE-Meta: U2FsdGVkX19jmW1ryvJnR5RzeZYrLJf7VMbzdhtiDn1oZ2ODB+NIUeYBKPWTz6/iWI2FNHoK5sVyLYfjzvk/Dj/ZiKGdwsTLZ+56jchnnX9nXSXyMcN7hlZBskmuzepXXC9uITlXh8M/aj274Ml7eJln2WoVe8jT7cF2DfsxOsCiEFV7ZrI61JcGi/4AqHYZkprZpZqphUnL908rHQyheg6ELPUzF36xDlvC8oahBo3qmm2S+Sl3Uh6ahGUXdPUPkB44GGInWTZdbZmp5Ynl1eDQVpm3KlerTtfc2E7ScZbWII4U8MRKfnlQbAtqB6mW5WYVBd54HnCf5YMKQj7KAgffHNotK3idIKQYRRD7iywRrqnF2gWJKEYqiTCntNRo4Q4n82m+AynINReoaY3LUH/6XuqyGF77/MDqllkkXFCaxbS+5ZRe+rhkPdaQlh6gfhwcZTO6ZqGZ1fobVvNqe01GYr4DNW7QXy994AzADwCRwOFO0kyVh8oUWxPuqKzO5eD1e4UHpJJZDhswfKzi93lauXqiDeYve9Yq4CSO3zgbPa6Fe0EhmDM1w1zagZO8XHHMnJ9oMaotxk074srPrjv1IieBbbaHJWnDBUeYx6D0lcqPEd5TndBF/YaLjyV8ylYmvmKlvPjJo3Ymd7OL9Wm9xKrLaF3Ltt2MIZQTwaykXx7ApzqI1jy5/qO+lRfWz2zQr4Rzob8xLuuADIVxLYL12STbSEn8msZCQWgmBtl1Vx+5w/ToFmBxKUjQixL+yFcPAwx5XSPdnU0YYNtdnsgkvNl9U8337/0Kq5TR1aHYfwhAZ44Pq3OJGxw+MC9YTggJ0/m7318XrSgG0jo9HwsZ142TqmZRaTDT/siJnXR9zSXos8Ll7xDXOAhGbls8TiQiDDOh0BxENzqpJIBWxCZ6R3fyFFUD3NsJP/3eTnXRXdqUpktrEp0ysOqUBbLeeobDnp4ZmrjC4l4Yf6+
 tICV7UQ1
 v+Gnh7hrkTco9x3jzBTvuH1pme/N4Pa4EmCm8wqi1dk31TkWjXznaW1Ja+AhqoUmAYDQIRUmjWB4WaM9Yn2Vw52QDS58PlpVl/NShWkEWWQ3bIpLR//dOZIS78DgSTl+4o4pZlp17IQz44Rj8jVuotlL9wwVcfY355yTPe0cfZyDEk35vMbdX6hDnpc3xFBtEEXEXHnuBiCMlXVF91W0dWlDF/f3L2dmSwu7ZXuYyHiStFKRaQlNRyMBkgzoCw72W3L2qo8klCdgKaY5WFe6YVkaiKjoY6KCJjERD2DNafEnl1niFQgN4Rsp0a69g9qQGcDG5Es4OsFMbfEosGBg8gCbX8s00q+xcd3UQxrHrjqqs9ayS9RAxFEIQYF3sTtQKz/qOd8bblzNyjM3t2PwsEpcvGDpoRtTXn1r3DZWB1bEhTxKr7LBJ9bEFk25t+kLh75moRSOSjTntbWijO0/KBzwey6RQafO6XGDLVgQb36/aHGJpk9YvbwPqyErnd4wBezfqZVMP9JMLToqDl+gUaLnLDn+I102SgGXaOoNcMC9bIL3cyTltUOClPb93Y0dgMBgxoTm8f8iCTSA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 22:10, Kiryl Shutsemau wrote:
> On Fri, Dec 05, 2025 at 09:49:36PM +0000, Usama Arif wrote:
>>
>>
>> On 05/12/2025 19:43, Kiryl Shutsemau wrote:
>>> Instead of passing down the head page and tail page index, pass the tail
>>> and head pages directly, as well as the order of the compound page.
>>>
>>> This is a preparation for changing how the head position is encoded in
>>> the tail page.
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>>  include/linux/page-flags.h |  4 +++-
>>>  mm/hugetlb.c               |  8 +++++---
>>>  mm/internal.h              | 11 +++++------
>>>  mm/mm_init.c               |  2 +-
>>>  mm/page_alloc.c            |  2 +-
>>>  5 files changed, 15 insertions(+), 12 deletions(-)
>>>
>>> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
>>> index 0091ad1986bf..2c1153dd7e0e 100644
>>> --- a/include/linux/page-flags.h
>>> +++ b/include/linux/page-flags.h
>>> @@ -865,7 +865,9 @@ static inline bool folio_test_large(const struct folio *folio)
>>>  	return folio_test_head(folio);
>>>  }
>>>  
>>> -static __always_inline void set_compound_head(struct page *page, struct page *head)
>>> +static __always_inline void set_compound_head(struct page *page,
>>> +					      struct page *head,
>>> +					      unsigned int order)
>>
>> I can see that order is used later, I think patch 4, but probably this patch might cause a
>> build warning as order is unused? Might be good to integrate that into the later patch?
> 
> Is there warning for unused function parameters?

ah I havent tried actually building, but I thought unused args would complain. If it doesnt,
should be ok.
> 
> I think it will blow up whole kernel, no?
> 
>> Other nit is, do we want const for head here? (Its not there before, but might be good to add).
> 
> Sure, can do.
> 


