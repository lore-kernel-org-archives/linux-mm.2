Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEEBBCCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167B58006C; Mon, 27 Oct 2025 12:15:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118598000A; Mon, 27 Oct 2025 12:15:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAC78006C; Mon, 27 Oct 2025 12:15:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8AE88000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:15:29 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 850D65635F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:15:29 +0000 (UTC)
X-FDA: 84044394378.15.B5859B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA24AC0003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:15:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GbKIsKs4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761581727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1mHiJVhO+VjbMfqmTXKhoVt8EjIjofOvtpC7RQVTFk=;
	b=flC3rzdf9nu1hlZQxTYJCSAUFjC1AayyNeWDenIJIlaDQ+ppgO9E2Y2CCyc+alPLtizKo8
	CpxxHCaCcmzQ6hkSEU1O++AnpvtFNTBC+wGEDbvVDtKK9S2dTllh/NLdkwwU/wpjGVRFBi
	0a/Aivnf+0KxDt+/VWdaw1iMppt1Sl4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GbKIsKs4;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761581727; a=rsa-sha256;
	cv=none;
	b=5lAQeurv0LbZzSZJFGYeNG8RJIE4ImriT+n/txY0YbfHce9xqgcVLkKj+dn5+ZR0m+qSUL
	RLpuqZLWM0B+a7tXblE1lf+9zewSfB/ChX6xPzBaPdsmMZzAnG0NOJdye/ooj1yJnFBK/u
	WX3o46Ex7lhzalYn317lalTH4p+YRAU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761581726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Y1mHiJVhO+VjbMfqmTXKhoVt8EjIjofOvtpC7RQVTFk=;
	b=GbKIsKs4vt6SBigPjYpHDY1tQ2x4suaTfRw/U/lkZg6A8enCgf19H5XTDA6VP0ldo7hWC1
	8AqIq/aZzJUH0vuMQ2WdJe2WdG/BBoXXLQEQHJxU04oPr8xDA0W0i9EMNdTQJoG2nkTse6
	1wuPzsOtqF5hj6fbI42auFruRwv5iYo=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-113-R9cVQVW8OO2k_AAEHD3qIw-1; Mon, 27 Oct 2025 12:15:24 -0400
X-MC-Unique: R9cVQVW8OO2k_AAEHD3qIw-1
X-Mimecast-MFC-AGG-ID: R9cVQVW8OO2k_AAEHD3qIw_1761581723
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4770e0910e4so11689895e9.0
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 09:15:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761581723; x=1762186523;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y1mHiJVhO+VjbMfqmTXKhoVt8EjIjofOvtpC7RQVTFk=;
        b=Wkx9EPeFYL/2J8ZjA3/Sfh+nLvlloXKixSYMJpdF6JldumfzfQlNM3N0AcpCAB16GH
         0fjoBHOxPr8RB+kAQ3jjsLaRsOcdzKbXNpWHfQlM+l2fQQViQY9yeEq2bFBbOSZQtKD+
         IAEugSGbqZJo4h5vjKYRdMMrURZipV4PTqpqkcmnppMEH187UVbEe6skpDxSGLc1zhUi
         XsqX7DzqMkkHtCToYyhXkR5xQWe9+bWyfqW1FSUXHfRvDVZi794Isz6Gbe/JDjdStNMb
         W+vm0/yamoRYgQnJJjPRcgyhyFeOoMZWnD4lAmlz0nL3D5GdGwVbNYnAWJM3pTZr+fap
         es+g==
X-Forwarded-Encrypted: i=1; AJvYcCXQVJVPjqCnfQLTvVJ/6ATBm9kbdQqhoQ8VrX/bTWhXV5+SfYDXcGJKMnTXZT/fjHp6X3d8hCYYdA==@kvack.org
X-Gm-Message-State: AOJu0YzjUcdhp4dUVU19kEZu+Qhm9MemZ3CO2bFsYE9ABE9WlfVMMv/H
	PWm9gXBmE7vg25d4StcsOkVcF/UttSOlcmQUeuEamhGeEpYpcZTcPbwn4gY0yX3nuIF/4Q+RWGS
	YRhdMNoHrzB/XwQaJ2exM2OhhtiZk79a3ASUFOwL1RFXjfd2FrUdr
X-Gm-Gg: ASbGncsUa9d0vkHj5p0B0sirnUUE/GHwYzZHymXSe+KqeaVErMe66i2N5Wlji6tiARI
	68No64gZKaBcTbx6KqhliAzzI6jtSM1T3qkDrhslUHJn5iPHezB5DIa7adnyI3hFb0op6VVgq+t
	155c2nlcArTrIkmQid4DZ3q2TzrAizfmvH1E0tFDIg3EAwfXqhBjHnfehqQ3F/wGJ6SMUe7oHdB
	TSZu0MDDaoX3TX/FUocjoLd5lmu2+VHc9KtyRYsEfJFG8uKKovOsJgmucy6OXdj8qraIC2Q+aGG
	DDAyXC9FXx7RHeJvGx8ygyeGkz2LWAutbxm4cwjBt5ja8/y84w9EkDUkvefSFkRzzOkpBFofK7M
	MUzcw6glA4H2LaLQ7IOlqVrcur5esJIgGfQSgaAg5AQQPfSS4Mpg2XO6ouWUcp805EjoV3fRK12
	3lWFZ1Zig4WVEI5xiWzCvqZzYwioU=
X-Received: by 2002:a05:600c:8b30:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-47717dfc627mr1792095e9.13.1761581722846;
        Mon, 27 Oct 2025 09:15:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyCGbC2aHxxDVeGlz+puR5Je01gbqwwjxfThnaNAQY+WhG+9Kt2kQaSj/jxsx1EWiCDG1sjQ==
X-Received: by 2002:a05:600c:8b30:b0:456:1a69:94fa with SMTP id 5b1f17b1804b1-47717dfc627mr1791545e9.13.1761581722398;
        Mon, 27 Oct 2025 09:15:22 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b79absm14855116f8f.3.2025.10.27.09.15.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 09:15:21 -0700 (PDT)
Message-ID: <c4a9af3d-498d-4b4e-957d-a5cab0caca79@redhat.com>
Date: Mon, 27 Oct 2025 17:15:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
To: Jason Gunthorpe <jgg@ziepe.ca>, Gregory Price <gourry@gourry.net>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
 Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Leon Romanovsky <leon@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Pedro Falcato <pfalcato@suse.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, kvm@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F> <20251027161146.GG760669@ziepe.ca>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251027161146.GG760669@ziepe.ca>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YYDeCRlUkFlZYTorUCxxAoposCZQ5Iq_MjBlqElIAkY_1761581723
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EA24AC0003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 8zewzqi8x358ycggrie88c8orsqxxs5p
X-HE-Tag: 1761581726-8848
X-HE-Meta: U2FsdGVkX1//9aC2BtDH3n8Cu9mvmxJ/3XN65VYbJMiAjaXk37jHlmVGNZyamz2HjxAMRqPnKYOgqXrfOy0uZqSM3HvFMXidToN13sfMiYNASAf5O5iLElefPL9fsSYZvj7uSG/6phcMeDUz6mB1N1iI2cyOopR/N32HdFn7A4GjVVv25CmCGj6HHp5pvTTPq8IwNOLv6gB2BwTYO5rhhAtT6PrUe9serKPgNQSaJBu9gFsGGbbrTp1KcJ3IBy4OLnOmtVl0vErqovug0kCw8LCLkRgq8SBoN3J8B0aU+Q6NURoIxnGrwf0Xb8Z7YUab9hsViStB2Pvzs3bSCxY+PcPGIgmSAiJQfg1FXCIhfyLRg8UVGccGaKEJZUggrehzoQC4aKFgNPQJyZgIUPTWwJXRW8QU0tMSFAykiWhkkbNsCFuNUF2hshrWdXQzo+Q4h212x1scQDhU7C75Nb9Zy5cdqkAvq3Mg+S2VSECObZDHaGdGF0jJ7Cbppjmrby7uI3CKi2lqAfofsB/VNkkVM16JrADFNQjfncJv+Jmskw9FNRwQGzazpgT5LjAlmGWg+wTx9DIyVYI/NNMJNF4ErS+RIsgcqjUq+b6qQoOBv1ZA+rhgafKXHkdaDiY6ZTjdfcQKp6w4F4/kWuP0viaPkbzSN6Z15bQLsa7ClQQXI6Uu687EgGRoI9bn9wNVkhSrmWHIajuTSahKEaAYMhqBu0DABzro4rTryuhV3ezFCPu6YSWzLGTaKkHzHkYAs1w+2cyFaWnHAt0Sq8lSt3XS+WstDGUH0Lv1y8Pc2nL5YuE571wCNnzWYtu65F41AkzeU6obbkqC6ZrsZFJvvepreHOmcvo3VgvXe9u7J7AKxbXfvFeO2dxnkMtPiuZGYHT9lKsOyhjMuZot5xssLbm1O3hdn3XNIXwLbkj5fcaSMLShs9b7vyoYQnSj2kzBx/TUpilcDeNZU1FPFTpyHHO
 M5xolyJS
 FSmoX6N2rx2aPyVx3gaX4rKRPQFuMM7kVrmiGWSZPIO+O8THpiE/nRq/aZkIU57J2xt/2jLHkb1Msa2lB+sptmqfto+g2MfnSXCBJFGEKRsh9zk7yhZqI0NXDVpMqlfV8oN/+9/CQjb/Ok+YzvIgjpPHfx6caQ2slCn+PVCyV4pqKA9CnheRJ4LJaPOsduYx8bvyVCiH78/6opPHYaAWV46Zvz/EnK3FV59EHUjVbu4ytYDHIfej1hd2LPKi2uUFaTEVuD0LIDT3RQSayNamRh0uiIrSgwabhTBxydtD5Ajtxwr7erHEf+SBNrD+mgTbw60RXlBiHCAva43lEshI9SLEWfjkcaE0LLppMUW1YyS81blFtPbziVqkI5R1fuUFmj43d83sKKR1a578naK3HSknSWmvbOY7hjk+A7K4hMpZtt4JfQaDGMKmnCzaHTQceoEYhlDTZVuyv7h9DpeHSt6fdtsoTOBI9lQeMn17hvuLn2xB5y/gpsgk63wm05x3BTDSw8wfOOkv0pTuNmE97hKDJySrzML6fHS43aZxGvFK5Lo5rE5BofLYb35zE7LTAQh5GMRYxTVVQCXxELQvXEB1fLGvhQsP1f/JsNiF6JGDdFksB9gAWGP7MyZBNniOjycvfyATFb9ZazYEbd/etQ5K4LXCsnuOshcnn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.10.25 17:11, Jason Gunthorpe wrote:
> On Fri, Oct 24, 2025 at 04:37:18PM -0400, Gregory Price wrote:
>> On Fri, Oct 24, 2025 at 09:15:59PM +0100, Lorenzo Stoakes wrote:
>>> On Fri, Oct 24, 2025 at 03:12:08PM -0400, Gregory Price wrote:
>>>
>>> So maybe actually that isn't too bad of an idea...
>>>
>>> Could also be
>>>
>>> nonpresent_or_swap_t but that's kinda icky...
>>
>> clearly we need:
>>
>> union {
>> 	swp_entry_t swap;
>> 	nonpresent_entry_t np;
>> 	pony_entry_t pony;
>> 	plum_emtry_t beer;
>> } leaf_entry_t;
>>
>> with
>>
>> leaf_type whats_that_pte(leaf_entry_t);
> 
> I think if you are going to try to rename swp_entry_t that is a pretty
> good idea. Maybe swleaf_entry_t to pace emphasis that it is not used
> by the HW page table walker would be a good compromise to the ugly
> 'non-present entry' term.

Something like that would work for me.

-- 
Cheers

David / dhildenb


