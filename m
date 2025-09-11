Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB96FCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 12:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EA78E000A; Thu, 11 Sep 2025 08:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DFA28E0002; Thu, 11 Sep 2025 08:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7528E000A; Thu, 11 Sep 2025 08:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 22E988E0002
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 08:52:17 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F2892160490
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:52:16 +0000 (UTC)
X-FDA: 83876957472.22.C8FC523
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id 82E6014000B
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 12:52:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VYEPdDH+;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757595134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dd82WTzveLoEWc+SAxXeYWtWd+6Kkfvmohrbf94Y17w=;
	b=UJz+yaiOz4Z7J5kFnu+PzvBbUaeQz2TMTkxNF3CKiX2UB7rItgDCK1Koq6rNdDhbdA28Ce
	DDxE0oMvaGyxIGi5wvjHpUtqjKqh2012zJufyss2o+2ynIeqzelOJmh+5bpEnE9xBcMjY9
	uuawFoG9SQ4jxSwUgwyGqLPNyJJGdgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757595134; a=rsa-sha256;
	cv=none;
	b=BaUudXt+HzsrMZwQAyNzQ85EXeZs15Daj0LbDIWnxDtmkKc1GiPocNCx2TQhywEa5zeOwQ
	tLCc/4K86HLQbPHhapNi4Cf1CVeN3avQI+fEazZwEkAq7WYXjfXUDYCEiS4PC87y9OkFdB
	7otE2aYkKOW0XwFUpAO+ouvwz/SiSlY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VYEPdDH+;
	spf=pass (imf26.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757595133;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Dd82WTzveLoEWc+SAxXeYWtWd+6Kkfvmohrbf94Y17w=;
	b=VYEPdDH+M4p3vP3btcNi/kSajTg0STrwiCp1guT6kG3mIusWhyn4CqLSo6xg75hCf+jxDY
	JnedQfZXGsobu+nNd1Tm7ZgjRbdRApAMHtJwh57cu2Sjp2el62K0ljloojQGgbUwWLBnoT
	/S9bPg8SxEHbIotDwkUGztuAl1Zq09g=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-404-xx_1j4hHML-pPp4b8sxlWA-1; Thu, 11 Sep 2025 08:52:12 -0400
X-MC-Unique: xx_1j4hHML-pPp4b8sxlWA-1
X-Mimecast-MFC-AGG-ID: xx_1j4hHML-pPp4b8sxlWA_1757595131
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45deddf34b9so11130385e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757595131; x=1758199931;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dd82WTzveLoEWc+SAxXeYWtWd+6Kkfvmohrbf94Y17w=;
        b=VhfnA3o7wWZHGls0+t6MjXQ5vPleEl2qsLDCu01arq5B2ZChWf5W2BnTXyg+/twnRD
         B98bVoPVZit6cX4KhUtvVFMjDz8zM1KLCOxuhf2Vvlm5MoBipdwznUfObVtbZppPZDnb
         yM71EzNUpsFev7x6pxxb0guCjkv+dMOrkR39vFfrQZoAgYRoOq6ezhIhHerK+XX4BuS8
         EB61bikkMMy+DKL1mDwoTagExzxWjfl+yr/0TWSf5nRUsYa8c+CpqRP5FTtJL2T9t+nq
         q5v0JEOYMjx756JWndRSH/aYrFBux85UT651A3zgbAeS4JyOHtxmM4rurEXM/GrIwMjc
         RVJA==
X-Forwarded-Encrypted: i=1; AJvYcCXMkYK7+truZzxpWsgI7gq+csNZRnoa/K19pzlSebt8L4iSvp0YCGhRiIsgRpNiVHTkCWMr8WEF3g==@kvack.org
X-Gm-Message-State: AOJu0YzzcPEqV+N9UWl0UrgupQPld52oQjYkOSm+/4LtHOF1x8vCm4gl
	8BjEpY5ayCD0FUFtcRSyrXeGcWXRBdxXs54VnV0aOboEjB0MyvSYC5Ik0aOSdLmYlKRAvVbDkZa
	N51ulHn1a5WLR21gVFCiu4X9JgJ0uk9gMuHegWJA5eTSOgNW9JiDk
X-Gm-Gg: ASbGnctvP9+E946cE486zh9VKMqHBmof/sidjDvvmTvEDe6lakEacWOQ7ivSv1bLfuN
	c7HV16kRAgycIhxhaam4ufXCCvs3lOyeIbrj4qXjvDlWbRoxV6gYZ8/TTWtKdGgerSYA9RF3cdu
	P105mVzaic90ZL/OW25SNtsmYs8U37FrTgprGbim+BlkG+pxKGeGMSsNezl2/6NOMJe8Do5dDhD
	Zg9AJjKlpeWbj694YuF3R/orzdublKLqqlwWL0bNoR8MjQqBkTQlNDaexxa3Xi1Mfqi2tihrxLP
	pzcQX/SO3ch1QKlh89C5x/m+n0patYrYIq5BK2Tc/nOmKv9I/5+pYyR+tG4UfCizXu76dkUAQNz
	4IE2mYp5nh1kXEqX+gQmNC13J3megvdO/UJLvdGEm56gLywCoCERJpeZwZC/z/oa2s18=
X-Received: by 2002:a05:600c:3550:b0:45d:dbf0:4831 with SMTP id 5b1f17b1804b1-45ee515f6dfmr2286495e9.0.1757595131478;
        Thu, 11 Sep 2025 05:52:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHx8VqogepbdXoOFaeQQ7CwFkbIB9lrJS7DEFIQ07QSyngRrxep0pNw8V/awV6BxQp5xwRxZg==
X-Received: by 2002:a05:600c:3550:b0:45d:dbf0:4831 with SMTP id 5b1f17b1804b1-45ee515f6dfmr2285965e9.0.1757595130906;
        Thu, 11 Sep 2025 05:52:10 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e032a0522sm22883275e9.0.2025.09.11.05.52.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 05:52:10 -0700 (PDT)
Message-ID: <244005a2-4796-4985-853e-f916bdfd096a@redhat.com>
Date: Thu, 11 Sep 2025 14:52:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v5 01/15] mm/zone_device: support large zone device private
 folios
To: Balbir Singh <balbirs@nvidia.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: damon@lists.linux.dev, dri-devel@lists.freedesktop.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
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
References: <20250908000448.180088-1-balbirs@nvidia.com>
 <20250908000448.180088-2-balbirs@nvidia.com>
 <8c5267ec-cc85-4eff-b890-eb705472e2b2@redhat.com>
 <f98d3149-9cc1-4211-af8f-e49547134b8c@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <f98d3149-9cc1-4211-af8f-e49547134b8c@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iyTcz-NR3XHTWHaV6bGXgfqBBIk04kGRp1o8nSjXa3E_1757595131
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xp6z1uerkiymmynrtiw898y1ncpfjqwy
X-Rspam-User: 
X-Rspamd-Queue-Id: 82E6014000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757595134-651142
X-HE-Meta: U2FsdGVkX19PKgPES+g+XF5mqgDwVGvirZ/jOvmVer0blaKFosuF87M/ZPzutJofesUBJhuG8AH2BYHqdGJGRJJpsOVzareipfhw3T1Rrj9xOVWAEWEisSx4N8SL/vd+DBlwBXUSjexp9MovAUtbF4hN1wSz7kzM5mIc3CRpVvL6riMsubEgadZo2Em3+l7Pgb2nq4Y/EeWjvVihd6NENoxA98/QyUVkYyQK2xM+TrZTxDHyveMfvtaG3uq2eFYVER3z7Sfy7m324snPl7FA6OGZuSahi+oK9VMwz+WeWnWiJB20CqyU191hhSa/8sHxxE1jKOsm3Xa1iE28CEocXeZTwkQozP2P9vQbDvCT8TTFuXVjscVfTMBnvTXlcSaTBXUZ8zC4vqnIzTdMwTGzX8+FpysmjjTeRwrzDH2Gbk+XEkZAl3CAhZM5nm0teUYj8XgaWN31sRsDNlJTm01hfrC5VgeIUnqSBrCWF2uOGybb/j8esEO8Nw4paVwlpy9Ce6J4qiLf4mP3gUN4kCBXPsJRdZKxO8RP50lAUwDLjlIO8LM0gBfal3XXtsa1J6wKS8XDNkHheGlh1g/Rch1AKMiKo2Z6Jii8IxHYY9M8wcQ+ulICDZq4gTfej8jMVAKg6ixh9OKxx6f+Rgi210kzEPobPg0k2f1t2o3ouOlTmkeXmr2u7X3R5UHmJJ5zSnl9WvOTUY01b0C2ACEwAiY7wmCT04VkNyczW5OwjwW3g42NTLw2JaMxu8is7O09U1zYo0UJnErDuJdxxJcZTorbp3HlmOmuwiwOqA9Vtawmv+6y4EisAwrXPnP8EV6PRlmiGwGN58ONwIoC1Y49J8hAKA/2lQFk5X3iRxh6PSkixqj2KGwCc+Er6sZ0xfHRcVcJcGHe/HiTE8/vgzJokqFxXv+5YmlVBY0lwzw3e4VmP9VQh/nNSAthB8q6MO3+jG02aExmP3johABLtHN9M6Z
 ReEFKaPe
 wBRFVdECkzejt2Ek7+1q1e6qMJJrp+t/1mz4CVZzhRg2x3diehkl95aTksNN+icVom9Zlt3SrL6ZgBALjf5Jvj4gv/270zsIYHgo/Tlxo8UWvzb6nG+26FCHhMJQlMcDlgfpMoXQ5LlDFqYU+EJG4B7Zhd29rjNacWQJ2vjHw+eTnK5X3PhS0SC9N4W8EvtENLbaEO2B+Y07aGP5pAO3nqClCV7fafaVin1b6x3SuHZzgfEJlhiNM5wmBll2op1RVzWOHkA5MPoIJKV1C/75YHgrkYC4vXADeXZ5e8mNKp7wp7Z9RrAlgEAcglvrYGPsF9OCGDp2Hgtyhx/ygNXNWRUiYVnsEvQNKinlKDYqiX2WjexN6h/DITpO1DSZrLWHnU1W/Gy3OC75CoQW44TKkFyMFUHMymo/G3DuGWvTniptcZfqfLgnqK16ykNToIlM+Vfz5JQZVMIwlLHPeasp5bmnU4YPJhgVdcxDgY47/ELOMZfl/J5jj0v0vCSWeFd28IssjbfIfv3noQzJXTRMXjD/AfmLUbjKYAvnqnZ1glPFgISVEntF+iqPwqt6X0aJm3W+VWuNSpzTnLp2DJUWf/1QdxzCklvIyuB3Dwt9+lPaqxSyipsdB86mjQ/hK3F1jbyp9YkGxnzUxJQ2k/CIlkEXGjELfSMyQzYbrWyNC7c6fgrt2n8DSAd6QQdRPBywfBhScK3fqL5sAp7IjmmddA2E8MNqW73KK4huZ4y572Lh2GDlsJ4ci43jQMOjjRyxLWoQi0AWabdtrJ3Gcmj7sxEp68NS0s6wrKONJUKiwdaHp1jTMFYGo7CZA/D8DQo5YeygExOL0ok2qhG7qG+Jt8Ma1RMU9xwJB6ob/kUgDgMXRCcKsX7hDqsC5RITdeuXYfaJnnIKYko8m3nJc58I5QxUWR6EiuwPCcw6xS1U0mITeWEin0vv2H6yXjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 14:49, Balbir Singh wrote:
> On 9/11/25 21:45, David Hildenbrand wrote:
>> On 08.09.25 02:04, Balbir Singh wrote:
>>> Add routines to support allocation of large order zone device folios
>>> and helper functions for zone device folios, to check if a folio is
>>> device private and helpers for setting zone device data.
>>>
>>> When large folios are used, the existing page_free() callback in
>>> pgmap is called when the folio is freed, this is true for both
>>> PAGE_SIZE and higher order pages.
>>>
>>> Zone device private large folios do not support deferred split and
>>> scan like normal THP folios.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
>>> Cc: Rakie Kim <rakie.kim@sk.com>
>>> Cc: Byungchul Park <byungchul@sk.com>
>>> Cc: Gregory Price <gourry@gourry.net>
>>> Cc: Ying Huang <ying.huang@linux.alibaba.com>
>>> Cc: Alistair Popple <apopple@nvidia.com>
>>> Cc: Oscar Salvador <osalvador@suse.de>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
>>> Cc: Nico Pache <npache@redhat.com>
>>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Barry Song <baohua@kernel.org>
>>> Cc: Lyude Paul <lyude@redhat.com>
>>> Cc: Danilo Krummrich <dakr@kernel.org>
>>> Cc: David Airlie <airlied@gmail.com>
>>> Cc: Simona Vetter <simona@ffwll.ch>
>>> Cc: Ralph Campbell <rcampbell@nvidia.com>
>>> Cc: Mika Penttilä <mpenttil@redhat.com>
>>> Cc: Matthew Brost <matthew.brost@intel.com>
>>> Cc: Francois Dugast <francois.dugast@intel.com>
>>>
>>> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
>>> ---
>>
>> You missed my comments of this patch in v3.
>>
> 
> Hi, David
> 
> Looks I missed your comments, just checked those were largely about alignment and
> integrating the code for DEVICE_COHERENT and DEVICE_PRIVATE cases into similar looking
> bits for zone device folio free and code-alignment. I'll take a look and update as needed.

Yes, and the confusing folio->mapping = NULL that I cannot connect to 
THP support.

-- 
Cheers

David / dhildenb


