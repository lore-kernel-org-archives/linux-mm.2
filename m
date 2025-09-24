Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0027CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44AF68E0011; Wed, 24 Sep 2025 08:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 422418E0001; Wed, 24 Sep 2025 08:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338028E0011; Wed, 24 Sep 2025 08:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 244248E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:32:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BEC8A11ACA3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:32:09 +0000 (UTC)
X-FDA: 83924081178.03.1C4848A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 64CE0120011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:32:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fq60GKxA;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758717127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxDPC3N2WqjlWNs99FhY5LFBBOFWE7WmpuWkOT+s240=;
	b=lY4rBHBNeeASa4cen2epEcq7HYbWl7Ql+r+AJ9qJsF16e7dqv/Pvqwy/+zGtPrBOpBDqNK
	OBF8EiurYp3tXhE4Te69y9NQMf8YWJ8FtREne4ACXHHV8KCqPMfcn767G7J9mIGyhnDUmj
	Zq5bR8rZ1gVBIgwjWy8CIQoA712F2l8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758717127; a=rsa-sha256;
	cv=none;
	b=s0KWlbv8UGd0QfDODAN9il8G/0kGg5kV53b6T+wrsNHQ8XzenwmYqqzwzRI3IcXuF1yOBo
	Z9+OvbMSWpLioHEYQaxPsQwQE8ktQHSjBObQyh3sUq8ZBzV63ZjAbq0BClm18vYdg+v6b7
	1LWwcWaJswa25G+pTR+DvBWQbqbB8P4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fq60GKxA;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758717126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nxDPC3N2WqjlWNs99FhY5LFBBOFWE7WmpuWkOT+s240=;
	b=Fq60GKxAQwDNUv1kbt/VOGNx3B9hh073Cmb2bGNTdKNS6YE/CAc/gQBBcpU1sIquj/MsX6
	5nHOFIAt0sLcssAow9i+eUiqSZCyI05WS6iCibT58G1gZarPPmnTaon6c3Qr7Ud5TR0rD0
	U4Lolgx7YmbVo22U5BKgHx5Rw07a7s0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-7J5pFT4iMlKgsA-7jeabtg-1; Wed, 24 Sep 2025 08:32:03 -0400
X-MC-Unique: 7J5pFT4iMlKgsA-7jeabtg-1
X-Mimecast-MFC-AGG-ID: 7J5pFT4iMlKgsA-7jeabtg_1758717123
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e870614b86so1758432785a.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:32:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758717123; x=1759321923;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxDPC3N2WqjlWNs99FhY5LFBBOFWE7WmpuWkOT+s240=;
        b=dMD35JL7wCHFb4j++m+2OQztfqaKYW3t0Jf7Vpa0b9JefBdPPjO6IZm10lruwckkNV
         /1/OEyMqsSUeBzaxzNMqy8mhqaPmWpV4KFPH/+gdVlUTP6j4SM06vmQFe179UKtklKow
         O4z7cktVEsQDnyAR1DVYDXAAiARzf7lSNofVh1y01n1bTfCLIhyoHK11rDw6sgpq9ZGF
         +uiu2mPBCM0NRDMurSFBLH0Tj/pIOCcwHXFAkPfLBR0evp0etIAHIIJfcTgPzHBh5qe2
         puXXmcqt9Y/iYQBT12WTZUzES3Nymu+i9aSo855R2+uzrSBkCofDAERaT9Y6wQmdbP4j
         v0Xg==
X-Gm-Message-State: AOJu0YzEDPOfcU8ZQDmc7CiD9KXeGObL3GxvjYUV+nmSUPrNcMwMOvnH
	5GA5qqEj3pdZSwe5+h9TOaF4tUTwpHabLs20+kkPxuAHkvM+IlN/sZVvuzXQczvXYJrLTIVNw8y
	Wr6tXGRQ6eihII9eGEkE4rB/1qzTmDWXhKnHY933zM3XWfUYZ6qTD
X-Gm-Gg: ASbGncuEH6BQSfvVHvs3s3H+7GmkPOr0waGD3cua0IUoPLn2y+Dnrl0dJmhUEldH/+r
	OXW7S0I6hvLI0LpbJHMmUnmlwapVbN9mpZcWq+Y9kH2ef96R6BCsN59zGAj3KRjMfhwJ/s/bcGn
	qDzk9q0aov/MYl9QV2ggXfhYS9LFH/QvJah2JQ13XJwBEIr4lSY+4ZtU/5sb8mviO1/xdVAtB/g
	kRHusREy+5Hw8jy9azVhCKfJ3wA5siReQ++gtOfVScVK+tV595hKSH5AUC2LDvEpfzStJ/6j8bO
	Zea1bWRU5+UBODrcA2zWXWYRhsZVkLNaOvVDkCAdnJCebX2GA2R6fUlLCGXjq6zhfPQHNEfxM9O
	nQKBFL1US28tHblDcoCgh8Qeu/u2dwK/oHT+bbjFXuOqtMo+pUPfw6y7NxhXt2ZrPrg==
X-Received: by 2002:a05:620a:319b:b0:84a:568:b7d3 with SMTP id af79cd13be357-8517370024bmr640303785a.74.1758717122870;
        Wed, 24 Sep 2025 05:32:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGU15mmr+4FrFEuvbHzmbfHN1dEwcBROdLoWHPYj5RplChD/U2Nd74SiOjXAk6SjarpxJnJ8Q==
X-Received: by 2002:a05:620a:319b:b0:84a:568:b7d3 with SMTP id af79cd13be357-8517370024bmr640299285a.74.1758717122380;
        Wed, 24 Sep 2025 05:32:02 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4cc0b7734d8sm45780151cf.53.2025.09.24.05.31.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 05:32:01 -0700 (PDT)
Message-ID: <3ffda308-1210-4760-bac0-ba5b019c0e2a@redhat.com>
Date: Wed, 24 Sep 2025 14:31:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm: thp: use folio_batch to handle THP splitting
 in deferred_split_scan()
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758618527.git.zhengqi.arch@bytedance.com>
 <782da2d3eca63d9bf152c58c6733c4e16b06b740.1758618527.git.zhengqi.arch@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <782da2d3eca63d9bf152c58c6733c4e16b06b740.1758618527.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 36YvyLuDvbDkSDYqOxpCkrdetKAvFdxQZI620pka-JE_1758717123
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64CE0120011
X-Stat-Signature: 7e3chxq6bgirrf31s7n1mx1q7r6597pg
X-Rspam-User: 
X-HE-Tag: 1758717127-254630
X-HE-Meta: U2FsdGVkX1/g1vu4I7NJao8nlEIvbA5g+MTPDE8clxGvV/rMEw/4Wmu2tBHe7LPr9w/fiLaY7l19UMpM60byUktlLMnXX6aL0zyCSyxgC5lrMOPqtWpuY0jRK7nh+fZeIodAcicj8gyE0ukc2i+uQ5aUlTHGwMvEwzniE7wPlCC9eu1eiDFiG/dcKU0Zu1rUGhd/SNrCqdSUIhT2kz0NCYfDGbORuD1lWIdyG8Pr+7MW5Ym9G3PRcf0xfJ43kf5Qiyaw/DoPWippNX9IACTjE4sToPwQTzi4HVFDvNO3Loa4idaBU2jCilxkMQbhFfg4olsgWTx5Xx20HxIvI/KexsUfacQ1gvJ/hhRnO6Jz76XiL9b8pBEt81PLuxXRRm8FeAHtYDklR+/bkvsBFFWZWJix0nPVKQLGA6bwixUyD8xygLwQk/mzNgeoRtIgA6E5OduUWoXlDmKJiqZ8I/x6ojpntm0VR1a6JZddxUDup4voGtZppN5AL8sy16UnILXMYnNNkuu5EV/LioMgQiabIGvEKh/5mv4zwWjw4Xc62bRrkdi/5FO08TU9DuSVthTmzNUY7xtoxp1PpgLwF+JSl6a4Ql8QxLRtEM37HajWoy1X3vFwrSnLUp6pZUQmivnoQjjB0dljWYGVF0VCzTvQe2xOcMf2IFgT9KHIoJb/KNLs0bb/p5d4IJi31woAHTHQTxw7zMgBU47qozN2NyzFCKeNeDlcXCcOrfT019OYmd09i40i24Uku2hwpCuk4WFhSPe7ovZ8jMQem07KhuAB6SrF8UpZoB+FM4EXCEVFUR2psxj5eRKBcCCFSteAGxKLjYf6QzXfsROJukFu3gPqp/R5bMrWNoM8QH6PltGb24f9sE6GDc19wykLVI92zmpzJBZQ8PjoyRF6HhvBEt9YlJD5ixSHg8oXo4hMtSgKeOV1urCOGlhyXjlUIAmibIb7hIRMzH0McRr5s2vGXu2
 /aaajj5D
 01eSclZ2fVFImxg0vKMn/CTGOL4GhxNrDX6MpQ/WaLBVNrhJSGDApZLV3VB0+4Rqy/FE3C+59e+UBcoVNu/uszR9gwv9A1Ju1oDkSOuocylrXKxtLTHlvySmVDF4a+Qq8jzFgv9FyAQHBDczjHJflYJ0Abm4FTCoH7UiSMHZ8wrCfFSZg+zAMeuRKLfRmSNcJ6ADW5XxkCJYR0wbIJ3trGKRxCHnK3xDZYZVtvVUIYBGxmKWSr8oxqBb4spKkn3OtnENVHfF65FO8t/6HhLEiONWzwamDl3s7yoXAAUDQb2J45JOROeVbpNvXLNcFPP2iZzMs10NIs1mZgGjfMfHlWZCRF3+kEWPlF8COUG+Q2xt6bdVnnmebQRkHTWn7V0lhKE481DlHvJV0xXvLduqmu0yOvINofn/RLhwdoqxJ8FoHqgq8wbVudR7znxqtuzfj5KFXkVsAKLDr1C+fA6fsCKrYCm2mBpo6gKfSUjMKiKzHO9NUlsrvESuD3gXFoCHrRqoVOAC+UX3ycFSCyWPsD/Bodx/kVtc2N1gK+ROZnTvAjWqY1D7Ur1qnRVaZVE1hAont2xDY1A2F63pnulOaFN3TTPFeQ6kcgZZk9jFXQrKOsRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23.09.25 11:16, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> The maintenance of the folio->_deferred_list is intricate because it's
> reused in a local list.
> 
> Here are some peculiarities:
> 
>     1) When a folio is removed from its split queue and added to a local
>        on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>        updated, leading to an inconsistency between it and the actual
>        number of folios in the split queue.
> 
>     2) When the folio is split via split_folio() later, it's removed from
>        the local list while holding the split queue lock. At this time,
>        this lock protects the local list, not the split queue.
> 
>     3) To handle the race condition with a third-party freeing or migrating
>        the preceding folio, we must ensure there's always one safe (with
>        raised refcount) folio before by delaying its folio_put(). More
>        details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>        split queue not partially_mapped"). It's rather tricky.
> 
> We can use the folio_batch infrastructure to handle this clearly. In this
> case, ->split_queue_len will be consistent with the real number of folios
> in the split queue. If list_empty(&folio->_deferred_list) returns false,
> it's clear the folio must be in its split queue (not in a local list
> anymore).
> 
> In the future, we will reparent LRU folios during memcg offline to
> eliminate dying memory cgroups, which requires reparenting the split queue
> to its parent first. So this patch prepares for using
> folio_split_queue_lock_irqsave() as the memcg may change then.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---

Nothing jumped at me

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


