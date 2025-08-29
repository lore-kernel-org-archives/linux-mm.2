Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24DA8CA1001
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 14:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6110D8E000F; Fri, 29 Aug 2025 10:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9998E0001; Fri, 29 Aug 2025 10:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D70C8E000F; Fri, 29 Aug 2025 10:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 36A758E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 10:35:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D194B119AEC
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:35:03 +0000 (UTC)
X-FDA: 83830042086.26.95917DE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41B0E8000C
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 14:35:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fk8yoWI4;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756478101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfIlMYGAPM5qq+lZD1SPgFCFfaNMq7ewyyxdxPY6Oa8=;
	b=zvot63DQskEBbHbB8HxWXUudPNoqMtP340DpKOjhYKnywUHG5O6+wHdjarS7nj7s2Q/uzf
	htAlMwEETEmR5lGImL4uaF1Dm62kz6MSZl3AViQQ/kPiLydGAC8Gjyjh2PnnyLABbxt8aq
	KzXkLI9RlYfiD6s7nneYg3D5gqZZvMQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756478101; a=rsa-sha256;
	cv=none;
	b=OIEVjziTmqm4CZ+42UchLPGB/KcdnPfTDzzXf0VKIePcGfMCUdbwkEvrEvblwQvTeocO5h
	BlFVIv51UkGUFzS6hwRppGjlvsShKn+FhOWpuCHERITQa5s6TZFg1SXWhOrR+Lb89G2hE0
	p0M+R86NDbJ+RsqX8X1DnQ9PkrOhVBg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fk8yoWI4;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756478100;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=hfIlMYGAPM5qq+lZD1SPgFCFfaNMq7ewyyxdxPY6Oa8=;
	b=Fk8yoWI45OzxQ4GK5uEcwMSPdnKnmp1A0QiPt9LZ4jR6Zye2CVnnwhAPmg0b15V4UJQ6NY
	/hr+R2EToiafeI1PWxz/Fe+0g0ZF2J5BKaB0JlCR7X+CA43HvwD8xEFEyu1Xmegjd0NL60
	2lEBqPJs865j8WThOaoOtxwBpLgwk+c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-sPkJoFxUPDORTBdwFr-hhw-1; Fri, 29 Aug 2025 10:34:59 -0400
X-MC-Unique: sPkJoFxUPDORTBdwFr-hhw-1
X-Mimecast-MFC-AGG-ID: sPkJoFxUPDORTBdwFr-hhw_1756478098
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a1b05d31cso10806555e9.1
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756478098; x=1757082898;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hfIlMYGAPM5qq+lZD1SPgFCFfaNMq7ewyyxdxPY6Oa8=;
        b=WZ8mEcq260BJgiX/gS+3qye/t6fW8ayCt7HMRx7wRa0jSp/vwrdIJCe6IiZ+2Pnq6h
         oEMm3BU4rXmlx2PFWzEuyIGJtYcUh3h4lzyeb1Fx54aqQd6GemhhqVpO6usFrkHhOHx7
         AIs4f779e0bIJfgZtc/F5EGYi1zlavmuB88AUwoPMTXTBu81UFFjLA6f39f+kn/eAyFO
         i/MXwPHKUgyJUYFIKmgQICR6ypbw66S4kL2bMj/IlYAXTmUPbfA8v1m8kPfdZyR1kDhT
         6r0ZJIJPNUY8nPNsOE4tiehdcADUxHc7ltFOnKnqkRZIRDnWs1GLvkKc3bxjhQGzIbVC
         HZhw==
X-Forwarded-Encrypted: i=1; AJvYcCWwBOopzPPrlZtLgt7tWodos9JjADv7zdWd9H66uz8mN0CY9RL+YMSWD7C1O3levYn60WRAKQzP9g==@kvack.org
X-Gm-Message-State: AOJu0YzB0m6/IHbgv1wYLjdV7W6Oa5Sx4CUx9KcGBMHz9jCMoYOvRUXG
	p/1aKqTbemGna2fgUSgmb6E3rDPkEQtmI7VaUn3DkPb7CjtOWIIN45wIz8SmQZzx5GL9V7KjVpO
	NlzlEAvPMkmfD6O4ASdSXrxKmSOspG5yK+5OikNPaqaMUbO075824
X-Gm-Gg: ASbGncuhVOviHFKEmP2j2ZJ218Y5DAOmukhy1+SE31ilHgj98rvpf09wsfRwSj1NqPL
	KlXceiY8x1dsT7SAa/gz/nCmsjS/7WZtTWFnMEJsaJALkDEewA+uDjigCBbdgwOwAx9rqFZe1Dz
	6JJXJLfwRFGVA/ii1SYQHx/zSAsGg7lBPekYxI3qyu21UAlayFQ/Q+Wb7UQezGAQcQapqqeYjLs
	U6R3lHj+XEE/Xotw9YkCjtSpJsXPPHOwHJ45ghZuCbU9jpMzyw79uLG0sneKlYGqCEPsX62dXN9
	tsz+MrF+XuIPPRdVO9k7f34fHYpvBeLw0DrWgGHB4lX8VuP8JBCyKrTZNXDIB3orgNFLiogxwvA
	3C6c4PCamWtp7svaXbC3GJNP9JZZc2iw1sOSO0QYUDCGimOVExejPyouqOKf8CC/b
X-Received: by 2002:a05:600c:198f:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b517a0878mr226234125e9.13.1756478097784;
        Fri, 29 Aug 2025 07:34:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3hDIii8NDV0DOXAzXIiOEtkQMZGVVDdgA6IYT462PNDojHGD9AgX58jP+bTVewU8uKeROaQ==
X-Received: by 2002:a05:600c:198f:b0:459:db7b:988e with SMTP id 5b1f17b1804b1-45b517a0878mr226233525e9.13.1756478097177;
        Fri, 29 Aug 2025 07:34:57 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f0d32a2sm134907275e9.9.2025.08.29.07.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 07:34:56 -0700 (PDT)
Message-ID: <62fad23f-e8dc-4fd5-a82f-6419376465b5@redhat.com>
Date: Fri, 29 Aug 2025 16:34:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 21/36] mm/cma: refuse handing out non-contiguous page
 ranges
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexandru Elisei
 <alexandru.elisei@arm.com>, Alexander Potapenko <glider@google.com>,
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
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-22-david@redhat.com>
 <b772a0c0-6e09-4fa4-a113-fe5adf9c7fe0@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <b772a0c0-6e09-4fa4-a113-fe5adf9c7fe0@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DBH6iNE5BV1KmV1YVUwWeMGPsXHFPOxqjin9P_aAK28_1756478098
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41B0E8000C
X-Stat-Signature: df17p1da8k7kwyhky46877fx5xo9dwsk
X-HE-Tag: 1756478101-426716
X-HE-Meta: U2FsdGVkX18Ossh1ufeOX83DSMoNy0Qek92koqqrdEdvxSeY+rWjROuyFpmcwhqcG4kO/7Ta0aWp8ov3Lt2Q3/CBFgasNdD5q0Fu0kB3AU+CYPfjzM6ia6wfHy6Fb0tV8lCiKIioe4OffRQ+iRVzdTTqx5JhSQ6PlrYiBUvrHga/KD5TrkfEQzg43pbolJzgr3+UzlQuSlV94VlPiwg6RDfHwj8EQSshDS72qJKvPa8fodCp84kphG3sRxgEjC6jhAXn6GCzt/lYG3Rb1Vs6ShdTlcdmUOzZjso2Km6Sletu3Xl2Z9PIBO8dGT9l24VoI3clwzelmjRaVzxKugs9ET/qvPe10H/2xVJY0mgFN/NjVtPpjtL4lyPInvXUMh6W7jrfJj6ZeSSd+dCOJbp7o5ZqTT8mwBX1dYnUo8R0s3Q2ZeAXqlt5F1GYWNYnYjsp4bbDbt5UJ7ldFm7Kp0FOxn63KvBe3jHDnlWBXjZT1oO5a5sdQ/AdaGqoiJyMKDrla1ByBcxmuViAnPnTScYG4T2DacGsWFmxt+CHazuhm0gwzLNDi8aBiaHZZEsg8dhxNtTC95dVPZIuVe62UMMAP6uUZ0fizJV/0t0dP5NIs1flEh4V65gdUnrLmLvLk17Fo4rozKeF/03L7vt97Icv3H5PuNcQrqKnGzWo42x4gCa+678AKkEHjLImRzwaHw2whZshl36vawa8vKzD5DZ2l6VuaGXekrMhIgzFV2H8kkhydLALxbgVJrUMIJG8gOu5RDUqPecjlRWKpkIsh00aOlA0s8mYz2WCUGep/xEpgsolUXxKV3vB8P+O2FKjGa2hYCzpUblLjIi8drHGP5/YB1DkVD7xpD3/nRlxD4W62Xf0s6KylfRckwvzPuZYrWuSIqSrCjN4YJ8RaWUKO886a6tLlPM47z82EZsGrKHL1LCfVBIJ583bIP8CzTEwNNcjqK4pu2aKDaHytYxDact
 hFZ6YSQk
 l37bksmxNgLh36kK0DMADjLmViiq2295UXiLHlVDviwXaltJb1P5fP9qva3LZnJ1qaRqTd+dXV6bZMJEhDtNh1xJs8B+zpXVy2y5fn7cCqKapD8dM5nWWi0T7nX+rebBRGxt/DUFuy4yXWUIW1AHJS6kCcfWGkZSAI+hHEkgvf3jRwOybdJVwgcQ8x41VxnFpYetdOuXS6E5e8XahkCKEIm/cDl7I40f4hPzTf0HQY15DhwvR1TZej116qw3117vVS61ERg1hh1L3XYgw7dckC2oOXUHUWf1wnuO0VCteM34AqfHNKtVntO4TS8WXDuf63oZyOt0EMpZuGIqNxxyK4Pz8ro22tBpgA/T20ncqVa5sPACm+7sl+DmFV4YuDDsWPQhnLMswpVTXk9oHa/7CSZvJE8rpI+9dWT5b/Q+BfD4OKOWmUdxFrjIiBf8luN94Ksq0o3eJdfLyYvAmnB0Ro+eFSvncXkwePAZnmw7x94FkXkyicYZExhfIbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 19:28, Lorenzo Stoakes wrote:
> On Thu, Aug 28, 2025 at 12:01:25AM +0200, David Hildenbrand wrote:
>> Let's disallow handing out PFN ranges with non-contiguous pages, so we
>> can remove the nth-page usage in __cma_alloc(), and so any callers don't
>> have to worry about that either when wanting to blindly iterate pages.
>>
>> This is really only a problem in configs with SPARSEMEM but without
>> SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
>> cases.
> 
> I'm guessing this is something that we don't need to worry about in
> reality?

That my theory yes.

> 
>>
>> Will this cause harm? Probably not, because it's mostly 32bit that does
>> not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
>> look into allocating the memmap for the memory sections spanned by a
>> single CMA region in one go from memblock.
>>
>> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
>> Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> LGTM other than refactoring point below.
> 
> CMA stuff looks fine afaict after staring at it for a while, on proviso
> that handing out ranges within the same section is always going to be the
> case.
> 
> Anyway overall,
> 
> LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
> 
>> ---
>>   include/linux/mm.h |  6 ++++++
>>   mm/cma.c           | 39 ++++++++++++++++++++++++---------------
>>   mm/util.c          | 33 +++++++++++++++++++++++++++++++++
>>   3 files changed, 63 insertions(+), 15 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index f6880e3225c5c..2ca1eb2db63ec 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
>>   extern unsigned long sysctl_admin_reserve_kbytes;
>>
>>   #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
>>   #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>>   #else
>>   #define nth_page(page,n) ((page) + (n))
>> +static inline bool page_range_contiguous(const struct page *page,
>> +		unsigned long nr_pages)
>> +{
>> +	return true;
>> +}
>>   #endif
>>
>>   /* to align the pointer to the (next) page boundary */
>> diff --git a/mm/cma.c b/mm/cma.c
>> index e56ec64d0567e..813e6dc7b0954 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>>   				unsigned long count, unsigned int align,
>>   				struct page **pagep, gfp_t gfp)
>>   {
>> -	unsigned long mask, offset;
>> -	unsigned long pfn = -1;
>> -	unsigned long start = 0;
>>   	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
>> +	unsigned long start, pfn, mask, offset;
>>   	int ret = -EBUSY;
>>   	struct page *page = NULL;
>>
>> @@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>>   	if (bitmap_count > bitmap_maxno)
>>   		goto out;
>>
>> -	for (;;) {
>> +	for (start = 0; ; start = bitmap_no + mask + 1) {
>>   		spin_lock_irq(&cma->lock);
>>   		/*
>>   		 * If the request is larger than the available number
>> @@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>>   			spin_unlock_irq(&cma->lock);
>>   			break;
>>   		}
>> +
>> +		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
>> +		page = pfn_to_page(pfn);
>> +
>> +		/*
>> +		 * Do not hand out page ranges that are not contiguous, so
>> +		 * callers can just iterate the pages without having to worry
>> +		 * about these corner cases.
>> +		 */
>> +		if (!page_range_contiguous(page, count)) {
>> +			spin_unlock_irq(&cma->lock);
>> +			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
>> +					    __func__, cma->name, pfn, pfn + count - 1);
>> +			continue;
>> +		}
>> +
>>   		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>>   		cma->available_count -= count;
>>   		/*
>> @@ -821,29 +835,24 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>>   		 */
>>   		spin_unlock_irq(&cma->lock);
>>
>> -		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
>>   		mutex_lock(&cma->alloc_mutex);
>>   		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
>>   		mutex_unlock(&cma->alloc_mutex);
>> -		if (ret == 0) {
>> -			page = pfn_to_page(pfn);
>> +		if (!ret)
>>   			break;
>> -		}
>>
>>   		cma_clear_bitmap(cma, cmr, pfn, count);
>>   		if (ret != -EBUSY)
>>   			break;
>>
>>   		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
>> -			 __func__, pfn, pfn_to_page(pfn));
>> +			 __func__, pfn, page);
>>
>> -		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),
>> -					   count, align);
>> -		/* try again with a bit different memory target */
>> -		start = bitmap_no + mask + 1;
>> +		trace_cma_alloc_busy_retry(cma->name, pfn, page, count, align);
>>   	}
>>   out:
>> -	*pagep = page;
>> +	if (!ret)
>> +		*pagep = page;
>>   	return ret;
>>   }
>>
>> @@ -882,7 +891,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>>   	 */
>>   	if (page) {
>>   		for (i = 0; i < count; i++)
>> -			page_kasan_tag_reset(nth_page(page, i));
>> +			page_kasan_tag_reset(page + i);
>>   	}
>>
>>   	if (ret && !(gfp & __GFP_NOWARN)) {
>> diff --git a/mm/util.c b/mm/util.c
>> index d235b74f7aff7..0bf349b19b652 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
>>   {
>>   	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
>>   }
>> +
>> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>> +/**
>> + * page_range_contiguous - test whether the page range is contiguous
>> + * @page: the start of the page range.
>> + * @nr_pages: the number of pages in the range.
>> + *
>> + * Test whether the page range is contiguous, such that they can be iterated
>> + * naively, corresponding to iterating a contiguous PFN range.
>> + *
>> + * This function should primarily only be used for debug checks, or when
>> + * working with page ranges that are not naturally contiguous (e.g., pages
>> + * within a folio are).
>> + *
>> + * Returns true if contiguous, otherwise false.
>> + */
>> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
>> +{
>> +	const unsigned long start_pfn = page_to_pfn(page);
>> +	const unsigned long end_pfn = start_pfn + nr_pages;
>> +	unsigned long pfn;
>> +
>> +	/*
>> +	 * The memmap is allocated per memory section. We need to check
>> +	 * each involved memory section once.
>> +	 */
>> +	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
>> +	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
>> +		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
>> +			return false;
> 
> I find this pretty confusing, my test for this is how many times I have to read
> the code to understand what it's doing :)
> 
> So we have something like:
> 
>    (pfn of page)
>     start_pfn        pfn = align UP
>          |                 |
>          v                 v
>   |         section        |
>          <----------------->
>            pfn - start_pfn
> 
> Then check page + (pfn - start_pfn) == pfn_to_page(pfn)
> 
> And loop such that:
> 
>    (pfn of page)
>     start_pfn                                      pfn
>          |                                          |
>          v                                          v
>   |         section        |         section        |
>          <------------------------------------------>
>                          pfn - start_pfn
> 
> Again check page + (pfn - start_pfn) == pfn_to_page(pfn)
> 
> And so on.
> 
> So the logic looks good, but it's just... that took me a hot second to
> parse :)
> 
> I think a few simple fixups
> 
> bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> {
> 	const unsigned long start_pfn = page_to_pfn(page);
> 	const unsigned long end_pfn = start_pfn + nr_pages;
> 	/* The PFN of the start of the next section. */
> 	unsigned long pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
> 	/* The page we'd expected to see if the range were contiguous. */
> 	struct page *expected = page + (pfn - start_pfn);
> 
> 	/*
> 	 * The memmap is allocated per memory section. We need to check
> 	 * each involved memory section once.
> 	 */
> 	for (; pfn < end_pfn; pfn += PAGES_PER_SECTION, expected += PAGES_PER_SECTION)
> 		if (unlikely(expected != pfn_to_page(pfn)))
> 			return false;
> 	return true;
> }
> 

Hm, I prefer my variant, especially where the pfn is calculated in the for loop. Likely a
matter of personal taste.

But I can see why skipping the first section might be a surprise when not
having the semantics of ALIGN() in the cache.

So I'll add the following on top:

diff --git a/mm/util.c b/mm/util.c
index 0bf349b19b652..fbdb73aaf35fe 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1303,8 +1303,10 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
         unsigned long pfn;
  
         /*
-        * The memmap is allocated per memory section. We need to check
-        * each involved memory section once.
+        * The memmap is allocated per memory section, so no need to check
+        * within the first section. However, we need to check each other
+        * spanned memory section once, making sure the first page in a
+        * section could similarly be reached by just iterating pages.
          */
         for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
              pfn < end_pfn; pfn += PAGES_PER_SECTION)

Thanks!

-- 
Cheers

David / dhildenb


