Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C58CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40B4A8E0066; Thu,  9 Oct 2025 03:22:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB718E0002; Thu,  9 Oct 2025 03:22:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CC68E0066; Thu,  9 Oct 2025 03:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1027F8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:22:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97BE6468B5
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:22:26 +0000 (UTC)
X-FDA: 83977732692.09.DDB6939
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 437D3180006
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:22:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fcjEUCxZ;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759994544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR0GPPrQth8s1EL9fLV4+qP3WUCAWdzIUfVSZ9j+y5w=;
	b=PshgvyG0q+zkRsW8U9G+zo2vNE7UaVXfjchh3G1Ywqqj/RCZyz+rz6p1UTdN5k8wj9pk90
	dyy2xrO8lq5Pcrzlin/GkL5Udoi3SEhGVAye6Zzhyy8XBkcihrZSmNb7hS/1QaF3eHPzhz
	LEV7/yDhGRWl5t1cYkC6GYGqSew+WQo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fcjEUCxZ;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759994544; a=rsa-sha256;
	cv=none;
	b=ri2Z/NXQNByPYXGi5IsvLkFuVbGELY5gGwuUrES3936mb52aUkaHlSznKC5Xur/BFNbm4L
	Iv7L12ePih1cXxH6nCpieOPIqYYuLgurZWFSdRBlDUOpzeNgLwvAtvIJ72V6UE68TPrPAj
	W7hjSpMpE1IMxN2iybD/U1KmCqzxz0c=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759994543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=NR0GPPrQth8s1EL9fLV4+qP3WUCAWdzIUfVSZ9j+y5w=;
	b=fcjEUCxZ7cy2E9VIZbQC4f/PlIPi5iBDfiRqsyCRNMduZp6FMvcxmSE7I8kyDBJgj6yLHt
	QCsB9mEqcTz1FC5sxQ7mGW9xOiLvBYo0Jt/+0qXTt1/+MRU4sqiThLy5sVFtTCS7NN2BaL
	gzcghKqCz7QmkqjXQVqNi3f6EfGzEeo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-172-2mX7_SrjNFqXsxGyt-sdyw-1; Thu, 09 Oct 2025 03:22:22 -0400
X-MC-Unique: 2mX7_SrjNFqXsxGyt-sdyw-1
X-Mimecast-MFC-AGG-ID: 2mX7_SrjNFqXsxGyt-sdyw_1759994541
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3ed9557f976so531307f8f.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 00:22:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759994541; x=1760599341;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NR0GPPrQth8s1EL9fLV4+qP3WUCAWdzIUfVSZ9j+y5w=;
        b=Wt1tHqF2C3ow3J6SLqzkcmhFIOAT+3+Ic1VFYdFIvm1e5OIK8qplFrHqOjzQfXrAh2
         os9p8Gvr5XAAut+fOGZ7E9X0DZbU6mEBkFK/RGJ8e8R1WRnbTQ5B44kWA4g9PMUCJBAy
         v8GGeZh5ttjOBSFspC+fhV7NJBZwJGeAWS/GXOJ8uMfcCNYblqdMjiFOLZPGNI+75YO6
         kemr1ATArIHRt45YSiDTHU7ZyOI2cAHvV/CgeFzHwbNImopteazUDrHX9B+8fWuGEwi7
         80IuBLT+JiC5Lqif7mxp0FWld7SKN7Lqp2ZVp+Vea2oXRKsUJDFiYBTDHgG9coUtybe+
         +fIA==
X-Forwarded-Encrypted: i=1; AJvYcCX4JBH/nRc8HcPtcEg/jDN79MvphWpKkeyTWSMMcWGKXZ9wXq6b/R5xIzVRxfMOXWVIOK0ZBKpC4Q==@kvack.org
X-Gm-Message-State: AOJu0YzZ4UuWHfcgbxH3rYZGF7C6lHF/DeMuldn50ZOCV4rV2ej9Pcvv
	YVl0T0Vvb0RxI6k6o59rX4DG9yQTum1WACD7ig2B/oQmRY7cW+E9c0EwmFSmGp/Zwk2yfaESSXe
	ZLXZjmRMDYIJtvKgyilobDlUeTVlUlo+OkYuj3ZFb3y/X4TFDCpND
X-Gm-Gg: ASbGnctA83J74KmPegh8H3kNAY/dPGxTWj6SjRC24+K7D5YZS/wKAm/dIJ5vwo3S+Dr
	Ip5f7EPhc4LEigPmRmDeJRXNsR1/LmWelf6zF5TZedBjAA1ceGW5NnsD/zSJtbjQNEJ3hQg1ITw
	TXkaOPMllNxNkLTHWLeGf56FKaYox+8ZtOx4bNES1pAl/NfczuKGHZtXkRJ2z37Fm51oSTlyfbO
	KWh7y7/9XyLQ2sjYfoGCL/kiISmdmMSsoeRIgED/TAvCoCosUnszN/VXHFe8ev/uqGbPX+WEJmo
	1X3HgIgZkU/mHL0lIpYup4dT0FvJJkZ8AYM78VdxbhgJ2zUq3jsv61S37rvyw2CfrU9jKzy1Qa2
	LFO1ucK1I
X-Received: by 2002:a5d:5f84:0:b0:3ee:1578:3181 with SMTP id ffacd0b85a97d-4266e8de444mr4275623f8f.49.1759994540827;
        Thu, 09 Oct 2025 00:22:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3pZJrfQfix+9KKt4WdXWXcZ6zm7mHa+Vng4C8E+STUwzM8VHEo7EV1uD0vgxW+NxE9Pp9bw==
X-Received: by 2002:a5d:5f84:0:b0:3ee:1578:3181 with SMTP id ffacd0b85a97d-4266e8de444mr4275568f8f.49.1759994540323;
        Thu, 09 Oct 2025 00:22:20 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9d62890sm68237045e9.14.2025.10.09.00.22.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 00:22:19 -0700 (PDT)
Message-ID: <d3fc12d4-0b59-4b1f-bb5c-13189a01e13d@redhat.com>
Date: Thu, 9 Oct 2025 09:22:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (bisected) [PATCH v2 08/37] mm/hugetlb: check for unreasonable
 folio sizes when registering hstate
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
 linux-kernel@vger.kernel.org
Cc: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-9-david@redhat.com>
 <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3e043453-3f27-48ad-b987-cc39f523060a@csgroup.eu>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: OhHHC9MXm0_D-w3Y9wwMdk_9_NWz2VnRrdd2FFPKNk4_1759994541
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e7yz8pg9oo1od5936981czk4cowjcqe1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 437D3180006
X-HE-Tag: 1759994544-812218
X-HE-Meta: U2FsdGVkX18eBJxMWSaLZMSwUl6mlz8rGRPkUumVIAAQJLQSAuq1hmpRAkmOy0XFXWSW9ZSVewxxbbG/eebWdfRXOa1s+ze2XOiQjhJVJDCptq+EgVgxyFvoIGGYEjaRqAhEGE9I/2qmaLWeQONkkBX9xodKLcupYLWUDrATT+i1d7AwKxMMnGPWt/M/X5aIF/bNdR9oaRlRLLQqMg6T3suwTsFN3kchsEgQpC8FgDs4LJOrENg9L6/RHskt51roRxi2Lxf+EEG1eAgmLjWUrxxgc/yssnn5DwHb2hp/Mvb2RZaojrSs7Ed/x2AMHk5iDGS4oKXlOZEbadZyjdf42Y5ExAYaiTB4Gjwg5uDbulmcuz2emgnoHrwgqCZK7mnTCc3gdl3SRZofJ9QgvVjFr7qaouP7uD1NhzWoaR7f3B3HZZLo6u/PHr9SRlO5Rak/vSmtgOHFrPsbW/T6Seqg5n3sCyCa20GCOmN/7IpfojT5KvJsuugraGbH4kXOYiITka7FZZGSlEcdOvsGpkuxOrDiU9uuddVNa3HCY9PGGv0t4QDB/EuR6sCybLj+1s+7iNvp+u8R/f4P7tIKGUFh0uUvr+PiD9TscFwh7SGy5FPfViHDFSyjV0FNSq4/cj4ZFU9PeCVkEcOjsyxPf6ZoLorGgo3MvPqhYkvcQvY4V1C89g/MJdUGQr269OPFzQE2romqFpsGFa6eRM0SSJq9HOrTEzo/nQ6m1oNivMdV9orAqPPrcL0NA4XjZVK9OpYr6H3l42AXITSZ7KvAkZrJDmBkdOIO34ZtpXqxMA8x6z09H32H/D7Gizejum4ll95DSRXe72E2cn/oF7CGaWIzCXxbqnB6AftxTO6sNmVndHp8uTI/5eAE+5NIk5misjmjrpyyYc/xP6wANQ3qpeJK6Z7zDc4eLvKBs59otbDDWwVNiv5SYv+3JzbOBS7jo35je76hXrQ6AUrfVMLrIXR
 l3f26jFG
 m92YjwsxfWRCJmbR6sLYhtGclFAttfu2I2ZegdOnWusj3TCi16A0tk5nlwSbJ+TPshTa8KqE14sRnltfvp+V+GCnTJFHjt1uuzZpTjHp/QyISaMDpbPJ49KnC9AgrImY4mO5cEF08fWeUEv9WC0/3Q1NBlwU7CZl5uk3ftGWIxQH0Kw+Wa6H/s/pZjcpSihXq3ZUXRVSDPn33iqgWPzLKlAvQWDHCShXaRsVijOcNQLwVUmOabpo3RBMtNDRVC2CJn+zMu1pTFkTN2oO+TyjUja8HrHTvZwrIkuX+Hm6x7OgnBkuXZhJfDXusMhVfEHW0EGF/wy2qXF/cZgzMoBHKrXTtwOf3KlSXk1PyK+CUeapdHgslJLG2iWDUlyu1LrcTBh2PY3w64s8xKFzYc7nkGrYMF4HLZjrxXjYP6d6mZuCgd4EV098dOIJcoj1qx8FdpOv5U9QgqnShxcF7sdgOAwu8bvyeBmXDJ6d5ayeHpjn8FUjVpmw9SQF/Ze1ew6lOa3IE/ag3OmChh2y5jgfg4mRBgol5AgTUt6HatdeEj+/P0sQ6r7Y6eV+ypatwD0KARN1p3QQ3VkPfvgqmM029pCUvz6+Cp7HNuztoVu+ulzOVW4s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.25 09:14, Christophe Leroy wrote:
> Hi David,
> 
> Le 01/09/2025 à 17:03, David Hildenbrand a écrit :
>> Let's check that no hstate that corresponds to an unreasonable folio size
>> is registered by an architecture. If we were to succeed registering, we
>> could later try allocating an unsupported gigantic folio size.
>>
>> Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
>> is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
>> to use a BUILD_BUG_ON_INVALID() to make it compile.
>>
>> No existing kernel configuration should be able to trigger this check:
>> either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
>> gigantic folios will not exceed a memory section (the case on sparse).
>>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> I get following warning on powerpc with linus tree, bisected to commit
> 7b4f21f5e038 ("mm/hugetlb: check for unreasonable folio sizes when
> registering hstate")

Do you have the kernel config around? Is it 32bit?

That would be helpful.

[...]

>> ---
>>    mm/hugetlb.c | 2 ++
>>    1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 1e777cc51ad04..d3542e92a712e 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
>>    
>>    	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
>>    			__NR_HPAGEFLAGS);
>> +	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
>>    
>>    	if (!hugepages_supported()) {
>>    		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
>> @@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
>>    	}
>>    	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
>>    	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
>> +	WARN_ON(order > MAX_FOLIO_ORDER);
>>    	h = &hstates[hugetlb_max_hstate++];
>>    	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
>>    	h->order = order;

We end up registering hugetlb folios that are bigger than 
MAX_FOLIO_ORDER. So we have to figure out how a config can trigger that 
(and if we have to support that).

-- 
Cheers

David / dhildenb


