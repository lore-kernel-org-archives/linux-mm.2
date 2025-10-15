Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9F43CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 11:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D56748E0009; Wed, 15 Oct 2025 07:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2DE18E0002; Wed, 15 Oct 2025 07:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C43768E0009; Wed, 15 Oct 2025 07:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B2B908E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:31:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2536911A21B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:31:07 +0000 (UTC)
X-FDA: 84000132174.22.D57CC24
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id 802B510000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:31:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NaNGwYp+;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760527864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Z/k/0yOU6D9KEQMQESh6zvsydD3GAQoHVOx1GYmDvY=;
	b=iZ6VJH+U/QvIZzFKYeLkoMOyCs1dbARRS78g9tcXAhWlXoiBukZO7HZcMZ8JrKQ8pGja1F
	CfUY/zkB+a+THdB9i2lQbPK9j4FCZlDi4YflpNX46Rdqe9sG4UDtwTXuJLzWDIW66CfLrc
	hWkdLjc4OTPidYchVsRp1V5lcjmJ+7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760527864; a=rsa-sha256;
	cv=none;
	b=uykMV4D+SsxIy+gMd1u/VtmeF8lyrNys+iP3STPdSkFK8oaxlRDRpiul9bQ/w6zMV9olal
	hD9D0KgSKIDU3TmMfTNrpi0U12+5n/MUgVKnTsnhvzwC9ZzGM82ploTIMJ6tWQHODj6T/r
	fAJnwSVxt43rxQ9kB84sgau/NA8oiNU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NaNGwYp+;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760527863;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5Z/k/0yOU6D9KEQMQESh6zvsydD3GAQoHVOx1GYmDvY=;
	b=NaNGwYp+qQI/1MA24Co2DEq09RL2p0moIIrceauWWZfrWQeWZfLdcbosv+wkNCfMTioErE
	6DhBzQ3l+o8v4BBYYJ2KaCZew2JFW39wCY/RKYqU0NnczxLznZg8TQxnq3DzsAeV+C4vGo
	o87eb/ecvZyU3dzj63EWGuNit5hLit8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-475-pN3wqmmVP1OmyzHm6Voxrw-1; Wed, 15 Oct 2025 07:31:00 -0400
X-MC-Unique: pN3wqmmVP1OmyzHm6Voxrw-1
X-Mimecast-MFC-AGG-ID: pN3wqmmVP1OmyzHm6Voxrw_1760527859
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso358410f8f.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760527859; x=1761132659;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Z/k/0yOU6D9KEQMQESh6zvsydD3GAQoHVOx1GYmDvY=;
        b=xKzvVsYQvAb/QUu5NwkZtFWN7tp50fomXUf+Ciio4Un8z8Q4UPkkAlNt0H6S4jxy8N
         ytuZXy0/YjbQzyrSWGs9FqWLcUZL9j3/MN4SJgH1k7X7fJ+g3uxsCtQcp2gFcgwT3Ai2
         CXT0Ma1BZWm1hPyiKfxnrW8Zp1My6lqAFdtdq4mix04fQtcciSmVNONCkCzUdZYczf5L
         gVTDEwkXlkpae1V85T/dv2YBnlQkqO3GyD+dGHQT906l9hmCZobejUfQEvCsAF5pO7/I
         aq1w3Li3smQ7AmrmKq76BnglOWOi+x8wbyTo9moUVSdhidHm2SnRqZW0bW0mKw+W5FMF
         0rkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUTqN/5cevL9GDg/09YuQjhLME6PWAbUNngs6HAVO4kq8+YCmdRYl1JXvPbTuqpCf/5Ks1iwpz7tg==@kvack.org
X-Gm-Message-State: AOJu0YyQ0YQh9BKKyfUt9CMxtYFlURJlPR23PMD1FiiM2wqGnYsOmcuz
	ufvm0y5wFNryPVPuuz4BwrEq+7uf5xyXw8m0m/0hupFITSOkP/Rj8uFl9c+LAB/oWDxtxs63vT9
	a7Xav+tKi0NrIJlDWqKZ7jca4cE7k75kDekBT3BbJeDwKrzsBg4Zh
X-Gm-Gg: ASbGncuk4o7y/YeLEWYid7E6FuVGcIb/u8AEmOlHSUaJpIYDDIdiVCBlAx3P10axCAo
	71oIbasjN74U+7eTsz0LVBjmOCeAjo+Cg1zN2GHUt7tKezRttxJvb2oW81kKSzjyisFmPADy2Mo
	RwHWgqw2cmD39N+j0/qz8vNrivPkaZC0YJbgOCXjPWzzep5JgIBqLrxn9JXmo28zERKobC79mdI
	VJzq+VvwS1UsaUK3HYlM3Qbt3JA8KZ0fkHlih4vEAMNYIHyaxWa9FrFRDPrkDx3HC2CS6vQ0pQP
	RzqsmFWtRAYK2QWKeobu6kdzsw9oVHd1QhLxSQEzjLZUJLCdjb6TW++QPjO2aJU=
X-Received: by 2002:a05:6000:4210:b0:3d8:3eca:a97d with SMTP id ffacd0b85a97d-42666aa6616mr22166652f8f.11.1760527859046;
        Wed, 15 Oct 2025 04:30:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFguZEaqi/jRginEMwVRewSaFVL/7VilJANti58M6frRSMd9G5w7tuwQnsaJ2mb3RaoyUSgWw==
X-Received: by 2002:a05:6000:4210:b0:3d8:3eca:a97d with SMTP id ffacd0b85a97d-42666aa6616mr22166625f8f.11.1760527858610;
        Wed, 15 Oct 2025 04:30:58 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-426ce582abcsm28770018f8f.17.2025.10.15.04.30.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 04:30:58 -0700 (PDT)
Message-ID: <cc278ae0-ecfd-4385-a497-eb2a35fa662f@redhat.com>
Date: Wed, 15 Oct 2025 13:30:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: Kefeng Wang <wangkefeng.wang@huawei.com>, Dev Jain <dev.jain@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Liam.Howlett@oracle.com,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
 <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
 <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
 <77fe5471-ed9a-4448-8a0c-75e41729bec4@redhat.com>
 <c5f19802-3d40-4e0e-a9ab-1de64b6869e8@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <c5f19802-3d40-4e0e-a9ab-1de64b6869e8@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sHfzUQfLHErqRaH-_OqAvDlc8O0k7-F9H7KS8kaTwcQ_1760527859
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: ap43wxrm5cppd13wtnedhpeamafpy5gu
X-Rspam-User: 
X-Rspamd-Queue-Id: 802B510000A
X-HE-Tag: 1760527864-185039
X-HE-Meta: U2FsdGVkX19DytN0ItY/OQhAtxhRfBHRHCH8LGPYU888cq0AyNECko9F441Tox9I7WAeAGDWa0OmQfkVf0u5VZz8kuegdlnED9YWDht3aaLahKepWOiVxhTrQf/9OKcfwSpQqQmdG5EYzJS0ZnuWa0r/sVjmRJ/VfZpUSlKdxBRBwKEXXAglJNpDc078deF8yyoZ+EbWpzA3fr09gQXeq6VQ30WYEuqCb+wV3KaupF1BFuZyvyecSsqPNklUnUC4GZ+1OsG4lzKT94fP0/TOuUd6b1THDiD1pb15Vqy43AUia1vB7h7uv50GOTjYOI8bPBo6oGi6FHtjvor5oXK4vfYzDdnf+J1HWDJs/rDjsOI1Drm9PtpGMOz9Fmdw1WPRLvK9UIM09lfel7U9r+PF34ZwsyfIxwwXnsAYRBsejyR2A7b+ddhnQ/nj0H5nLdHh9AgoQZK2yLWkxXurONMvzCBruVDB/4SYXtr5lFLgKBS2Wn90rN2PmTo4AwFlQcMmBWPPm8fAQrCKAQWBM7juzpFrmQv5YYMUAtiHPc59DkTQaqplHWsKcIW0QACZjB5eQnsAR9y2WPoH6bV3gfALRT66zJyJMgtmQmymhpVd2Q4prUL+FyNpF/+vEyXfl7lrPW7l1ieHaILcavZDeRvNsZ92L99sdk4P4fd1dItbOyNJqYD79FLVtOk1RI8s4D0YQ/rvW9UdWKA8MYMFtXiQ62i/wnWHN9gEGCv+kQG8cUW9N/h81vkIsw8cDtVt4W9hTNDdDZtlhsj0HRTVyoPBJJ7h21oRINdnHyYNfvqWKNV63uw5Hc5j3wDyjlfUzE6EQjOv8E1VouDXfqPtdnE9+UoQJpl8/UoZChydLPtnQv0T0tHmQhZkuEBI5rg09OJKgPrA8BKDha9Qqvah+c5ZGnzaIjn029XcS1AUjQKNazZyLUIF1cx0K7pSOIHXPvFlMrwdFuQX1RNDpGJ0FT6
 IM6yi3h5
 fXDJLT5bIHiwLvPp5zsX51ulCF6ceBr1PEq9KeU+JbyVUFuWmV23hZdZ5YSvi4zWd5NNp7sFSnqbzbAccHMCvb+GYTynPFLLm5mFRssm/bkLUJ8zKRfihGghyGof14C8k7uD5mf33hTolxNqvxPx34zBrCu+goJrWpXzajjLydWPozPFHS98fEMtSP4l5xgPX57oMG6RkenJ20tMv7jUBgLJGJd2rhkBHq1yA5j+V3plWCUrlpV1IHk03QFHaX2wgbMMxaYpDmNybiZnAViFIvYl3NJNQZ7wblBV+ECCIxYj9hg/StZ3h0505ateKcRaVpv42U+60MW9rLdTxLdTcf+sMH8rLuwH9H4BTeOd3xWSnQaFfRZ4b3KIHldMKQ8XACGKFcq/8qfcmwrDSuv7qbxWK2bsrX3t2c1bIGa2IYeldIMGFZGkdRBpzXzPVoYD83Gp4+AfdnDwkwD1g1Kiu3I1eV4SW2jI0kv/3QvrVa1pijzjp0NXhJS4zCPkLE/QFsli/VLIvrahJ7AjB7V/LI0SJhqaN2PwejjxC8xVZ3THh7h2+g7nmludKr9BHRGBVn+nl67GLZrmu947DpfyURxYTuKornIkaTkyvPt4a0Olu92OTXm31eiKftw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 13:04, Kefeng Wang wrote:
> 
> 
> On 2025/10/15 17:54, David Hildenbrand wrote:
>> On 15.10.25 11:21, Kefeng Wang wrote:
>>>
>>>
>>> On 2025/10/15 15:30, Dev Jain wrote:
>>>>
>>>> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>>>>> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
>>>>> ret by directly return value instead of goto style.
>>>>>
>>>>> The folio skip checks for prot numa should be suitable for pmd
>>>>> folio too, which helps to avoid unnecessary pmd change and folio
>>>>> migration attempts.
>>>>>
>>>>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>
>>>> In the review of my mprotect pte batching series, reviewers had
>>>> noted that the branch "if (folio_use_access_time(folio))" in
>>>> folio_skip_prot_numa() did not belong there - it should be done
>>>> outside of the function. But I see that that would duplicate a line
>>>> now that this function has two users. So in light of that, would you
>>>> mind changing the name of this function to
>>>> folio_skip_or_process_prot_numa()?
>>>>
>>>
>>> The name is a bit long, and it only update access_time not change the
>>> pte, so maybe we leave it as is?
>>
>> Any such name might make the return value weird (which indicates whether
>> to skip) I'm afraid.
>>
>> We could invert the meaning and call it something like
>>
>>       folio_apply_prot_numa()
>>
>> And return whether we have to protect it.
>>
>> Maybe that's better? Other naming suggestions welcome :)
>>
> 
> That's better, or folio_needs_prot_numa() as there are already some
> similar names with folio_needs_ prefix ?

Yeah, why not. Then we can also add kerneldoc to describe that it will 
adjust the access time if the function returns true.

-- 
Cheers

David / dhildenb


