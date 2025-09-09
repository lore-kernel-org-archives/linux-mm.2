Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 655D5CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 15:19:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7BD88E000E; Tue,  9 Sep 2025 11:19:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C53AB8E0003; Tue,  9 Sep 2025 11:19:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69958E000E; Tue,  9 Sep 2025 11:19:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A56C28E0003
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:19:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96A5C86A92
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:19:50 +0000 (UTC)
X-FDA: 83870071740.08.7E925B1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4CA6E140004
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:19:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdDzvrBn;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757431188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InYbqwt9glvNL4C3LVQbjDo/hY87wVdMa3rsXOKx3FQ=;
	b=4vIK/I9iItjVTlQHgjF0wQiJAbH8eDa6PBKctQxkLHBn2Cq3XtCzqrYiiwJl4DJwh1mmC6
	4gJZLgZ6TPMJm3VP7HFNadi4OCDurUnuPkuZVRVUYrlINDS4+VOaF7AOqwEVX7bpFuDKdq
	sY2ZqERt606YlRSZYZLLkFJSpkgkwtE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AdDzvrBn;
	spf=pass (imf23.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757431188; a=rsa-sha256;
	cv=none;
	b=B7nanVMK1/TeiazKXN4M5xsePzGmYr5VHxVGjUHakaEd2TIlBr73FfJTFcK/UzfX63dkbV
	3ZDk7enpGnV/zPuYB1Y8UlazkKy08BeNijauqVj4jB79ncmqj75OjMdnUcnZ+si1i27kgM
	ImFagvk9euaIUkvw1m8bKphHtHrKxiM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431187;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=InYbqwt9glvNL4C3LVQbjDo/hY87wVdMa3rsXOKx3FQ=;
	b=AdDzvrBnFpIJgOgR6Li+L0FWpbCNSfsA9C2Bamwj+3jYNh8jIG5bcSmtzw5XKRXnVc1mLg
	+X3Vmd2gZpQFjh97ovKVBsbPFp9nQp/FBYJn1qgfFfB48GCjIIDF2s3BhrMOGKaOnnukQa
	sKzMm30cSpDi/S9I82NZwoKcktnkDCM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-659-iBcgtq6wN5WYJJjxvxRzag-1; Tue, 09 Sep 2025 11:19:46 -0400
X-MC-Unique: iBcgtq6wN5WYJJjxvxRzag-1
X-Mimecast-MFC-AGG-ID: iBcgtq6wN5WYJJjxvxRzag_1757431185
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b467f5173so40959185e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 08:19:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431185; x=1758035985;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=InYbqwt9glvNL4C3LVQbjDo/hY87wVdMa3rsXOKx3FQ=;
        b=F1sxBFSkGk8BNHvJbiTXt02u0Rj7w/S/MTtFIBu0VIG+lFDD2ldDrENkv5h92Bqd2p
         kTIqIqq/CM8DMgitWqyeccAno8Irs3lv5LeOH0Uxbt0gmJOwzLn6LEdpcCrj0q9HBFn3
         AZ8zjawkkllP9diDReUI+ziXj6TsyXh6G+RrSkjVwFZ7r/BooLRReLqRa0nddcNnykJv
         Domi6ILOd3LJSF0y2jfvP4LEXl2esm0SoWQIAhrPjw8D3VcnbPLaHWjOhcf4sQd4hhyy
         3/NsdF1RK9sLeHcpjuSEUgByqsqmyo4+bY5ffYKjHj4hPMfSQm0Qa/N73sRyC/KVPSKc
         9d+w==
X-Gm-Message-State: AOJu0Yz5dMnNEEmKY8afkBIJNKboTJiCSVvTYzeyIPM+db7USFlxAUuF
	yS8Tpzk1thMp4fLS1aRcFdUwk0pQt1YkyM3aXKca2cvvn7raw1vwV2Kwuzq1767sINUZrUhDYJq
	EM+RoVoRGmre9TKY7WIauAwx729x33HFsryLTIObNbNmsxwlB+4YE
X-Gm-Gg: ASbGncuSIpGU3va4OiTcuXoB6SveeauzRqIGc0/g8ANi9ppuYkAN1ocO7/yLEYeg3fh
	p0ritdNHiR+KMvfVFDj/7CZvoXvZOSwC1BfQTbGlLDTkYpHMKGGkKpT5wHUA9iI5WA1PDakdF8G
	syOEM0UJoJN4pIvDStElwlIVqipvVKNfMnu1XRK4l87wQChi+N95zX0EKYLZ2kljOHUjmY2aBEW
	HBfVsp5JQhZ33CvPQdbXGKHMR1UVGYK+hORJnwALrDbqLuQt8XtrXtVnvdOuPx/Ib/rNMH4swO1
	cks9TfMcVORK75K/fiJOBCJzQvOInsLHxTrOy8xgs4dLPOZsGYJxiNq4t2K4SSW1ze3nbRtwvtk
	WnLAkcvY+6qp2mFjdnFDOHbYsIcWXTv8TBabht1et41XIQ6pS6AR8cy72sSccCcbOr54=
X-Received: by 2002:a05:600c:4694:b0:45d:d908:dc02 with SMTP id 5b1f17b1804b1-45ddded9c21mr103637065e9.31.1757431184840;
        Tue, 09 Sep 2025 08:19:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1bljri4jY2JSQWXumU2Cl1Vy0YyVDFF7sGRN7NXMVP/WZtzyUJBsPOarkJX8Q2cJU6IwvCA==
X-Received: by 2002:a05:600c:4694:b0:45d:d908:dc02 with SMTP id 5b1f17b1804b1-45ddded9c21mr103635995e9.31.1757431182935;
        Tue, 09 Sep 2025 08:19:42 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfd8csm3255178f8f.11.2025.09.09.08.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 08:19:42 -0700 (PDT)
Message-ID: <283fc6d5-caca-4a67-916e-55246a5a4cbb@redhat.com>
Date: Tue, 9 Sep 2025 17:19:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/15] mm, swap: always lock and check the swap cache
 folio before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-6-ryncsn@gmail.com>
 <0bbda135-068a-45bd-afd6-3f5cdf4e570d@redhat.com>
 <CAMgjq7CsKYWzAD0Ev7q0cocQO8kOYLmhgLD0wk6AX-HUzWFJZQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7CsKYWzAD0Ev7q0cocQO8kOYLmhgLD0wk6AX-HUzWFJZQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sCVLbxG9U3p4G-Av4ojm-6EXNgJQucrEnHb5W8l0rIY_1757431185
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4CA6E140004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: n8fdu71xxqskea4pqcx7jwx3thnjpff9
X-HE-Tag: 1757431188-726887
X-HE-Meta: U2FsdGVkX19Tjr1kyf/iwqwS9oVMBhhikwGRrmlL9jo7H3Aprt9DS2U5N78+nnZQxyns2ngCVJrbsmIh1U+NAJKxo+3qhF4ewRsje0j9rnHk7WD1bPejD3TN4F5LSqL6rD83aU10dEFkTLCUs7Id6Mo6q8nqxyp8mVlNnkMXGr4fGvzAipq6pCtFh+r5OR+9EHs7WqaQdbinglkPPue6fIsJA0CwgeLTOo2jDX1Yr97wC90mZqCQsrN7qzxBNVPIV4fsD7gtIvwx8lLUgkTMiS97qcwc7prq+h7rav15PMBkccZRQ28s+dXScOqQjBSD6TAGqPeeCwq6sIQ1F3Rcw8F1XoHDoOv9j0UnmWzrW2MghrgUKncdjcNk+gRkGB9IFp7aKakvLs1YFPWAc/wMOoR/RLM9cSIOloR4gQC4mWXgkSVcOecv1b5JGADeuX+Y8ipQ4/5VuCwk+U4eIqxrVEsxyO9BMeFOZOvQIKOcYGCWNi+zM+KEZsIdwd1YxUDqz13uy5FG2KMIU/ZNPdXlUhSAUI3/8TJ+g308jLzLR5lfSOgwtlvQAZ2V7qhEQJDexVfHyqEUxTcvYTxFs7pXOuRSHIGFxBwcij6n9xNJn1g8rprWUE8a7yTjONtdmDqMRR7RuNIPN40TqKlSM2ww63ro16iiuTKdfkK8sgXtm/k7Yvxm4ExOoCnVAHPbdxdwzsRv71uHMCB0CUu8YWxTpaRJQafLX14AiUhUo0qgdEOYrYc5pE9a3/6MSRYjZd1eHSxrW25B1wVAWj3lm/NrV6G/W89lVa6Nq26NJtHSGuONo2LWLLDFRdLKTfJWdUwfpdEUg1Zj2K8+3tjWaJ6EauqBzUAADZSkkM1hffLbC3heZGNsI7KWm/+0m7IiEd3BFjoEqGj6hH78J+PglnR5yJOyZ1U9IVTuZ+kQqizPouLOYZc+X/7kUiUGSZdZGWDOAg8pS3ADmgJ8aDl4BDU
 iBjc8xsi
 pi3AuYKQz7zyh55IhFm5VnETgG7Q+W7Y+4BDngzjkUtKvABZnePdUobBr+L8MPd1KP3iJY6wwVy361ob9XLkuWCH8ukPy+DlKQjjdB6jf4/A9kUJ5kWL3uAB27p9t4orU+JiSy41kDsSwv/o3D+FGbYzsJMe840zkhVw3uHTx+GfYASdCAjG41Euuy9mpmb1qJ0Zdm/7dHoY1+wnw/3xGm5+0aGlGGrAAOyCgo7ClzjopSbgIEf203rvPpLxmfFPWkyVrmhHw4Qrit0OcBB7nxQoqGdv4i5e9anpN0ARW6Oig6EGmqJ7x11pa5ZsFtfZChPMxHBva/IB2B+1HJgkMO2avykMXepF7rwHlsXoTNf5lEUPdqYeLyvAeWWwjYs5m8JPuxAN59o9tLR0E7CJxV8cEuW+169uFQud7mX7q5JfHL3IYgNUB+lKdnhCzz7K8dzjX01hJcay8KoxqjVNgK9w+YFr7Q5OAb0ZHTh+jTCryeF4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 16:58, Kairui Song wrote:
> On Mon, Sep 8, 2025 at 10:08 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>
>>>
>>>                folio_lock(folio);
>>> +             if (!folio_matches_swap_entry(folio, entry)) {
>>> +                     folio_unlock(folio);
>>> +                     folio_put(folio);
>>> +                     continue;
>>> +             }
>>> +
>>
>> I wonder if we should put that into unuse_pte() instead. It checks for
>> other types of races (like the page table entry getting modified) already.
> 
> Doing this earlier here might help to avoid the folio_wait_writeback
> below? 

Why would we care about optimizing that out in that corner case?

And checking the folio right after locking seems to follow the
> convention more strictly.

I'd just slap it into unuse_pte() where you can return immediately and 
we don't need another duplicated

	folio_unlock(folio);
	folio_put(folio);
	continue;

-- 
Cheers

David / dhildenb


