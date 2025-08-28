Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC467CA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:44:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED69A6B009D; Thu, 28 Aug 2025 03:44:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86476B009E; Thu, 28 Aug 2025 03:44:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D260B6B009F; Thu, 28 Aug 2025 03:44:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE9BE6B009D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:44:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5BCFD8531B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:44:40 +0000 (UTC)
X-FDA: 83825379120.28.FB9B4A4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 663FF100011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:44:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AOvqKnes;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756367076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhK+BxA/iOgcFdCxhcrFsJ9ic9ebRUg2wIpkT+UYj24=;
	b=IoaK27Xi/gpkZFsOVqjByaxnAA+jsBaRq/cyxjIzASrdGKU1TFp6MSJuVpyyMGuKerxaPw
	f8xFzZ0Hg8eJdzSS429WNIZXUeUF8fQVO6vfbSwyDoWRZz8m+w0JWmAEALqjpAc0DHg4xi
	TWVxjrxRf3+Uwxde2+27J8qmQ5+zd5k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AOvqKnes;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756367076; a=rsa-sha256;
	cv=none;
	b=KZJWJOMJmmknHbVi0zTTqmbtUqDZ9CqyCkVTsbnQFX3NmwaE2anu71C6zP6b9YkCCzquLR
	mCiVM/DnDo5sxksnQtTYSpSi00eCdYeDidgwB7RoSKejfhq7cJZ6j4P71CNus5vhaNg4Ss
	1AywjKJGivsPBAgjHPkGETGyc/wxxds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756367075;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dhK+BxA/iOgcFdCxhcrFsJ9ic9ebRUg2wIpkT+UYj24=;
	b=AOvqKnes9gqzin9m/GiLp/xZ3St+18a2v4Go7zxNoTzWh8U0tT0Yt41eG2ofqoRv1XpYyW
	TuCMlaCLNRfb7NhkVqtLJfPpzYgh8ewi3b6zLedhqbVjUDTbCB2YW0SqIdd9EGLN7kRLY3
	Cu8kphQLwXnhmDY00rVJDs3O0l3PeQg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-QyRoZ9q2O-iJA4n4ZQZ7vQ-1; Thu, 28 Aug 2025 03:44:32 -0400
X-MC-Unique: QyRoZ9q2O-iJA4n4ZQZ7vQ-1
X-Mimecast-MFC-AGG-ID: QyRoZ9q2O-iJA4n4ZQZ7vQ_1756367071
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cba0146f7aso290356f8f.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:44:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756367071; x=1756971871;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhK+BxA/iOgcFdCxhcrFsJ9ic9ebRUg2wIpkT+UYj24=;
        b=P3HO45BpJWpHq9PP44qjZKSkpltvs+/0KR5N1xn8nRED9R4E1BT9hL3o07AuBRKhNS
         vhFIs6mmcJuG8sTLj6OLMorwfYENrr6E+uS2u1K8uVlnQ2c1N4U0Ft8oypc9fzEUnrao
         Z2ibPIl6zo0bIfrYEi0cHB2xEaPz1d2IjcTxIMKJ1ZcA0TaX/IrxrI8j7pJKL7fAp3rb
         ABBf8i5X58tRZG9kuguN+r3LvaMIAwpG1omu2eKaPi3uPUBT6JAFAOrHVEj12HEM7rfB
         3SO1ArmxvA9KnaweAy7E90gu8AbQbTqLbh4DEzRP/EP7EG/qSTQGOXCPZ2Xe698odb7q
         jLiA==
X-Forwarded-Encrypted: i=1; AJvYcCXLDM6DANtaYeZV7c73U9IvXmuuTDJbCcbJxOuOG4fCnnByyoI1UGq+EN30uweSjdAF3+sU9BVAVQ==@kvack.org
X-Gm-Message-State: AOJu0YxSsUlnro/gv/J/xIzMRYcZUtUU520CCRXFueV3tbJMphLBisMP
	YzaqHez6faCA0qvQGpTJ8wvQXqU5gF0A9FmmzY+a9FdQdxBNAGPuWhwxejpTBBb+apbcCgcF3/3
	jJNeMeW3oVkCIsR1Q3mZ191okbKWGWl73/RV/z9XnQyynL1rsoKxR
X-Gm-Gg: ASbGncthfo0MJK/td/IwUucO5WSydV6dYNz9dNZmN5JsMQxs9yr8yZdOP6W5qw2WoS+
	BhCrGu6eWDe0arlOWSeS5UFLnz3MRA898RGXOCm5HapqQc+aBRuWslsJyAYdCEg26YT4Qg/474R
	iRWq9cdhg9STXcEQSwVEgiN7gR+6np8pfOaH+AecSIrhoRnMwcQcPuKDtej0BHd07BqoKo4FaER
	bDpqwd/WRE+ideQR9sfK0uGmuDk7zZIVpOCVTqZrZbE3z8zBKLDRLN/FHjuCrZNEJUdsMkSm5G1
	LEc6yXzVDMwyZE7x5uK/5MGTcGcCtJIy7i+nWP9Ts4jQoGQyOg2soml4aQLDTHBUyIO5CUArKtG
	k0SoUxa8cv0XFk+o67L4FKrnV+4klc8AXIrvouQnkYOtBQ9bOe75rJm+/ip+9Ml58Ixo=
X-Received: by 2002:a5d:5d0a:0:b0:3b8:f358:e80d with SMTP id ffacd0b85a97d-3c5db8ab097mr18867022f8f.5.1756367070876;
        Thu, 28 Aug 2025 00:44:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXm6ZHFF1yBgYNSUrsi9TF+wDF8WO4dw6T2lJHPZ3voQni8d+w8tpOsvfzaL30mwHhRdMyBw==
X-Received: by 2002:a5d:5d0a:0:b0:3b8:f358:e80d with SMTP id ffacd0b85a97d-3c5db8ab097mr18866962f8f.5.1756367070322;
        Thu, 28 Aug 2025 00:44:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f28:c100:2225:10aa:f247:7b85? (p200300d82f28c100222510aaf2477b85.dip0.t-ipconnect.de. [2003:d8:2f28:c100:2225:10aa:f247:7b85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cd2e01dd9dsm4501230f8f.60.2025.08.28.00.44.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Aug 2025 00:44:29 -0700 (PDT)
Message-ID: <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
Date: Thu, 28 Aug 2025 09:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com> <aLADXP89cp6hAq0q@kernel.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aLADXP89cp6hAq0q@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 2CcXmKL2UN-az-5Z6uA7ypGPvhn60lGXHl9ze9TQgv0_1756367071
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 663FF100011
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eiesmrscou6kh6jjbys4k7q9kpmk9m3f
X-HE-Tag: 1756367076-979610
X-HE-Meta: U2FsdGVkX19iS9wAdvjgQc19nHMvj790Yr+FxKMeblh1wtRl7P2UNQKqoMNcvaZ6zPY1bdaDE/vgT1PegWYsVLfT4Gjl6zh8VfgzTrCoMxkX1ommnD9BjUM+3711xvyk3yNxrLhL5f3KczlK/wu7xnox6hpYbpVL1k896nqUFMKVl1B4WJQOG75kCrOawUN/TLpNdzV7twaevVI9i2116nhHFEhXqjdUtMpEApCUiPKFH6HN4IeB78oj3tGjGhj6Bct2HS2jrT8ZxNz2VTkMx/A2UN2VwlAjvdV/9wSdeU0aap5PGijP6naDEMO4jh3XLVCl8OCzVd7rwYFH0/adC6qIJ9QjMh/RFJtdvkJeUSxDhi7/bllzKs1n0W9JiiJJfrHxC6EgZet8N8HloxPIEYD8GB5PRA8JW66rA9kCT8VRpzHyLjTC22DHXF9WMMU9vuOXotC8T6C5sfFTOQ71I3f801PNyrCDqLF8RV0G4e7QZoJX3FnZIeeQm6MK2VDPPBEvNhUBjH32qZ483zIvjh4WoOAv2GuWnlyQAbLXhureSqx4jbTifYEKI8aVXU0+DBl4OKEYAllp++74zRUrp/FAltBGRThBZ8wR8NAn3WMYhJP4nw7OHZz+8yYVQAutzDFD5ttjdqSO/V30lvBYflUcEFVhmZPUgUuS9J5CteOYgmfYd52N4ApEQidasGwUkQYxf0+kTkkc9wiJM+8See5fwjKEiwXUkOoM6NxbmjMF8njZvTi4bKTobLQ9UrCrT1T8aYFuu9v7sLhgAv9VxPf3iJR3KVte/rGzJhLsJnYSWPFgWlhdFZY3HY/QmhKzej7KO60K4Kzsd1W6mRdhOOCaOsdpYLFdlaxTHjItsMQSDgQFMsadQUkSnkoK6RM/zpuLUvSZz3/LhpXQKbnNmbI4np4BtWlDO0+h9XyOhDC7pm7fkzn7+iEOGpyquMFH3f2sExd7Ybc51KuKkQe
 xB/OiXb/
 RcCrfjU+CPz0CsEkfl1SxdCEmi5W4amzXQA8Km6/sK8PeYp8zAuvzU+c/RGEu67ZCPSjZrooE0KxHDVN47CBrMiYI0SlFwvGT7L1NCU4xRHnb3NIJ1JDpHcMcY1LV55h6AY+BvXrm3Yq9pH/XO//KBXRcmT6bgljiCoIxa2EHC0JvD2pp2OcmedF7L52wtUBsBdOym3SWPBMsDvsoYJrZe6VEV11a4taciGaNcTOeXd85snkhsZwPrTZZGbS1bpjpTfAqBrRdGb0BPJg984wOXeOlu+VrXjrAoL1sz/wtjcxOljzBe7AJ1irIKcPvopQ3UgMJwcy394BDyKM3dig26HZH1eiPGzSw+jMF3EnxaOQ2+36LLUxaZjRrbCx85XvZ0edCNsyWpV4OwWdThr5/M62sAdDdMzzWsZtWi/kbC+wYSxp0LkTNP8H6Jr7A8WZz0ZV12jF8KcWqftSIL9d9miIdLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 09:21, Mike Rapoport wrote:
> On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
>> We can now safely iterate over all pages in a folio, so no need for the
>> pfn_to_page().
>>
>> Also, as we already force the refcount in __init_single_page() to 1,
>> we can just set the refcount to 0 and avoid page_ref_freeze() +
>> VM_BUG_ON. Likely, in the future, we would just want to tell
>> __init_single_page() to which value to initialize the refcount.
>>
>> Further, adjust the comments to highlight that we are dealing with an
>> open-coded prep_compound_page() variant, and add another comment explaining
>> why we really need the __init_single_page() only on the tail pages.
>>
>> Note that the current code was likely problematic, but we never ran into
>> it: prep_compound_tail() would have been called with an offset that might
>> exceed a memory section, and prep_compound_tail() would have simply
>> added that offset to the page pointer -- which would not have done the
>> right thing on sparsemem without vmemmap.
>>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/hugetlb.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 4a97e4f14c0dc..1f42186a85ea4 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3237,17 +3237,18 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>   {
>>   	enum zone_type zone = zone_idx(folio_zone(folio));
>>   	int nid = folio_nid(folio);
>> +	struct page *page = folio_page(folio, start_page_number);
>>   	unsigned long head_pfn = folio_pfn(folio);
>>   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>> -	int ret;
>> -
>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; pfn++) {
>> -		struct page *page = pfn_to_page(pfn);
>>   
>> +	/*
>> +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
>> +	 * so these pages are completely uninitialized.
> 
>                               ^ not? ;-)

Can you elaborate?

-- 
Cheers

David / dhildenb


