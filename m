Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDABDCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 11:23:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030A28E0006; Thu,  4 Sep 2025 07:23:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 008938E0001; Thu,  4 Sep 2025 07:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E38F48E0006; Thu,  4 Sep 2025 07:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CFD668E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 07:23:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7981F531C8
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:23:00 +0000 (UTC)
X-FDA: 83851330920.24.F5A8D61
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DDD31C0007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:22:58 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DQ11H7GR;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756984978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T6sBE51cD4dDzXj0tiuFwEHoYZRwu7bL+L5xlYE0LlE=;
	b=4jJFiN9El3bT9rHfS0Xg+T0xzX3QzLn+AGXh24n1bV+llMNMXAh/1GJU5BHrlWtIaEOepd
	r+c0+5KVQKrn9KuTKauMXHBbuTtzr67gZ72KXN5UFH2HZh0eh4o+5jWW53gOAEvilGxKvI
	JgCXqkeZzB1prGEg+P1q1ExRlOg5dTc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DQ11H7GR;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756984978; a=rsa-sha256;
	cv=none;
	b=1tPTXyJvTJfTUHqoiBxN2LJNEGymNKvYBLZRxZaIFg8PU6AeW4pSEnvcFsRxm8GypW9mzq
	DDHcqqaDXR9zmzWV+/dJoCwNi+Y2DtPvezsbWqEIGf3OCUVyGn91MU5zQqPfK0LHBJUbH1
	B9nNTIQ2RHSE9e5G7C3emjQt4VUClBg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756984977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=T6sBE51cD4dDzXj0tiuFwEHoYZRwu7bL+L5xlYE0LlE=;
	b=DQ11H7GRH2tGq3Wd3wKyi+KbxVtURlKLHcEi7Fg+x0mTYXgm8iEcltC/g2U2vbpDQI4Tjn
	6104Bv18DcEDV8yMsakdNPt8jZoYSCzNH8qY1RXSo8XiIpQSBhmcg5DkufY22/ZJpgVr9u
	m/R3DiW9VJCr2O4dt93Sx+gmkZnJyeg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-SiUPoowzMAuHMWlYnfonNA-1; Thu, 04 Sep 2025 07:22:56 -0400
X-MC-Unique: SiUPoowzMAuHMWlYnfonNA-1
X-Mimecast-MFC-AGG-ID: SiUPoowzMAuHMWlYnfonNA_1756984975
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45cb4f23156so5323315e9.2
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 04:22:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756984975; x=1757589775;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T6sBE51cD4dDzXj0tiuFwEHoYZRwu7bL+L5xlYE0LlE=;
        b=raGtVs5LLG18bKAmNiGaSvqY+RNmgIfYEyEXBIeXt/v/GqdxjXAGj03t6VACmo39JA
         Sy1qjI7tSU0BWHuK15nwDzQLob1hdzntZpSCiNUoRu57pGrnksiX+4O5y7IAmJjfmE5Z
         71iY9u4d3K1kEz8PXfNhFVDjGoR0hhTxLLMYv5mzGX7egMnEefU/3MVN6syCeeGpO+kY
         NWF1MmPiX7+MUghuBAg7/z9re7bmLcv21yYMafbuhdCMI44jGab1cSIcuwrATtLpZ709
         hAxqOqZ4pv4IYoNU1CN+vUKpj3BBgkwyDBiZZaTG6nsvnHbhvcT7maayvSN+kfe/JwYE
         w02Q==
X-Gm-Message-State: AOJu0Yxh6p8WTuZyTQ1dgfk9CDWkhew40hk0MU8SmedMCBpLr98eowLy
	yKvVRGGDmPZ76u1/wZS3Qe04YJbGda+00EFRUAwiRbrxgTQ8lE2h0BakzzmkAP6D381DGoXxzxg
	2KR/vHYLb21dwyb0p9Z/+764O3EuHTNn6JRkHKNlegpJzFdrTGzrl31Zvv8Lh
X-Gm-Gg: ASbGnctatEv/sCPqz4eAFddWxrg5UtAMefpVEdc64TlMRtw6h1s8TBN5UsnjUJqz9n/
	gUnspZPbbQYgCwHUMIuwxIe0rLhECq+QzQa9v8Xattt98FRHOGcm7sTUA0lN2/1/ASj6k7JI9Eb
	c1rbezRltI5264Su3qtln/UpV6d3kv6KiLsYh6KCtmHvduZWpJ3mJAWqzMfRgBvWK+K1mGiBSeU
	2oUAEHqaxc1wrjv1icHcMMswPDcaHN9wbxV+m5JicYMdboL/EFul3c3bx2lPO5rBXWGCt6qzmZF
	q4bFytlbE9SJ1XFxePEWAuv8fQhv42qv6qf3NbqKV4jonSTI4J3JmrN6odxTnF9/t8wM5oyw9RU
	SFqUR4+u4xUqB9rA3JhGI+s9/nGxQtKFGtQFSxVEi02DFaKjR25UbOT0vavTHG4uV
X-Received: by 2002:a05:600c:a59c:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45b8556a7b7mr104954995e9.12.1756984974948;
        Thu, 04 Sep 2025 04:22:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFotbW0tTtxgiVC86xUn2CQ9eYPgHLbL8gGa/aV9eAb0Zgp0Vi+qknrxQoXkSbzUA1guX22Tg==
X-Received: by 2002:a05:600c:a59c:b0:459:d645:bff7 with SMTP id 5b1f17b1804b1-45b8556a7b7mr104954845e9.12.1756984974577;
        Thu, 04 Sep 2025 04:22:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:1e00:ce4c:be3:97b3:6587? (p200300d82f251e00ce4c0be397b36587.dip0.t-ipconnect.de. [2003:d8:2f25:1e00:ce4c:be3:97b3:6587])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d1007c0dc8sm25733498f8f.53.2025.09.04.04.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Sep 2025 04:22:53 -0700 (PDT)
Message-ID: <1607fb76-ee10-4ee8-ad9a-ffc99987cf55@redhat.com>
Date: Thu, 4 Sep 2025 13:22:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove mlock_count from struct page
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>
References: <20250903191041.1630338-1-willy@infradead.org>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250903191041.1630338-1-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jDjJkr48gHjcLVlhAzWhO8DP1DQG223GPGIzY30rFaY_1756984975
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zyhu4wf6wdoro1n4mj7jptxkggozpdkp
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DDD31C0007
X-Rspamd-Server: rspam05
X-HE-Tag: 1756984977-692791
X-HE-Meta: U2FsdGVkX18YcqmEmh4zwUzf2u/IPlyYKologE/Xf9RrdRiPkLIBqUUUpo6YqBGj2n/c6yVwlologHDdU8D4f60fsyQkOv4DEbBbXn4UHEAEqYKjc/oq95sEU8M9Roh6aV6N5j3S/VTLl+HKTN1tFwO/GSzUm3BpliJ9PEDMLFV64Z2AsTPaj6LSW3EHT5oPVbmLRGZbiUymrAFX0JCzkIKS01VZT7Xl80EBi9BNe6G70uYeAyrO6QE/GZQAJoBRoO1GfJ85cSYjgJ8cbWbUZbjkzZhsDACugJEj53xj20EG54wkwptyVfV/rt0qQ6oziMUdgW9DvyLKdZaE9smGhnDSxdu1t9gLsgcPG5ESljNyLUXphEr5RwMTQj+7ElGTsmeCBhsKzk+LvcI/rKcvdAyQWtEL1ADKePqXI6yASXtOh4kH6nV1eJ+JAO7nSXbyBZxdQyFhmrB9j65K1QzmfrAXUyrthpGKoyxEjL1raF8iXrKBpDLWYlSALO1pCX5tar18tjDkBQvmA3CXMehz4xBjVXloK4MRmnBevbas2EIQ3i+H2eFSCK4boHIlxRYOcYfOJQ1kdEVF5g0kQfHxPOTLuItRYKDYuqhMO1shni33HQLXn3p8EM+juPZhiwSIcHHnTzqlAEO9bmNbQQIjsW+kPpZf+DGIQgtf+dLqVVOpFO0Ddpkxly8iLrxZpHSgynu5YsUOHL7bGC0QPfI1tHU7wDaMLlsyx0LCCfwj0zFbZa2Ulzy3gHfNFcig5G+xVQABucMdkAf+RoZPLv0uDogyJmfuB5vVJ2w2GwO/e7URlFljkI7HL4KKt8XW4SixnhLm+IBvrvwrxESXnmvZ+YzlKT0NhLWQDM0H2fNPDt6jhes2LdSUTrkYGphhD5Xg7yodTTyIjaxh94fawVk+G6g0p3IaYK6B8djF0lt9RQJmojENDfI3XvBnTXhdGVAIvRHTHFrGnkty311Rgd+
 xLxtsTYM
 n3NI1HHV0sCS/FsPBUIoq2DYfL7XxgAa1ZFvCGZ6YijNbKWKpGg9gO5qmRrJlydQO5MJm80JClW/IqRnJJX0U5H5a4jLphcp/hogIT40kA5BLBaGLIAjvv9/Y23Mn8JTf0ljhYanx2hGDQ0Q7RVjcPBkYHaMNAdAPykiKrqegKI2oafv2V3DOGB62fUmpFxgns4WYFeI6BUxFBuvZv5SXAoHNwWtWzIX0O+ln4Qek+MK73EyypzWGMerIgI/EJ5m47ZNr2zrucxdK6SIZhia4fNcH17S0JQ0OBgU4z57f6gzQ3d745MbsKKUGW9vWeg4TrN815v7ECNZmR3EzQibRQasrdJJmzaqObZpQMwapsy9QnBAXm+0NnvAePL4g17FcxuLKfVQM4kgLH9hYzQocJn6RQ3uf4gx5UvS8gfcv3qCuJrjK1fdU0Z0AoMyinHZow04HBhH6JvTZbygyaLpPA0woR1Gi2X27s+/bwsqivn+jd111cUUpqlqZqH5mGgCphLYdcckV8s0I/QBFCXvU0pZjkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.09.25 21:10, Matthew Wilcox (Oracle) wrote:
> All users now use folio->mlock_count so we can remove this element of
> struct page.  Move the useful comments over to struct folio.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>   include/linux/mm_types.h | 10 ++--------
>   1 file changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d934a3a5b443..34205313a839 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -94,14 +94,6 @@ struct page {
>   			union {
>   				struct list_head lru;
>   
> -				/* Or, for the Unevictable "LRU list" slot */
> -				struct {
> -					/* Always even, to negate PageTail */
> -					void *__filler;
> -					/* Count page's or folio's mlocks */
> -					unsigned int mlock_count;
> -				};
> -
>   				/* Or, free page */
>   				struct list_head buddy_list;
>   				struct list_head pcp_list;
> @@ -391,7 +383,9 @@ struct folio {
>   			union {
>   				struct list_head lru;
>   	/* private: avoid cluttering the output */
> +				/* For the Unevictable "LRU list" slot */
>   				struct {
> +					/* Avoid compound_head */
>   					void *__filler;
>   	/* public: */
>   					unsigned int mlock_count;

mm/mlock.c:      * will call mlock_vma_folio() and raise page's mlock_count:

Should probably fixed up as well.


Documentation/mm/unevictable-lru.rst also seems to talk about pages and 
mlock_count, but that probably needs a bigger rework to only talk about 
folios.

-- 
Cheers

David / dhildenb


