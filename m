Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C26ECA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:35:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74D8E6B0023; Fri, 12 Sep 2025 08:35:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724BB6B0026; Fri, 12 Sep 2025 08:35:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63A106B0028; Fri, 12 Sep 2025 08:35:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 560026B0023
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:35:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6460186D62
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:35:50 +0000 (UTC)
X-FDA: 83880544860.23.A880D73
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9499A40003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:35:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C+7TX9oq;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vl4F3QETQ6Qmt3iYKAH8GUoCSTGHR7l04Sg9h/MZCJE=;
	b=kJ0V9Xg/QPjuJ5AZmJ616uIqDCdFvpmp2CWu8Qc5ZHTQ9ylncsi7lvGjZoaE5c1pzXtNN3
	eAKCWSwQAd+63BjCv2sUdVAbZGyQfQz1iB6cFOdXS2sX9FTjhK1RXA/2SRDxHUwBhYmzep
	gKRD69rpeVbgSsaJjxtT+06V3nFXiEk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680548; a=rsa-sha256;
	cv=none;
	b=xavCXeSTDE9kYPHLKExljfL3bOKjOtsJVDj+ymaVHZMVdWl8z8FqSogaGA+JsUKKb5g7ZV
	7/9AWyEfqQuEnxngxfBBXwTkwZEQaUlVRINt7g7hFo2rSisoPfnP9cZPdQArhqsB6lpeIk
	i2jx6BmxUBi0I6YAD/gNOdaO9kiyrJM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=C+7TX9oq;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757680546;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vl4F3QETQ6Qmt3iYKAH8GUoCSTGHR7l04Sg9h/MZCJE=;
	b=C+7TX9oqLrppOBbv0t16W93Jb5oOgC1Btl7zBitJYbOFuUy2ceKkmTc35wa0osncv8DLt2
	UDunEMw9PeHKyqkddSd/95wh+j0WBnp1ybYrP2uz3ZNx4v7Z7XcBBG10Q9dvBYie2QrbsF
	HkI5d/noJ4motv/7s198c5ihsYOybTo=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-dCEOa8pSP9emRcs2bfOjmA-1; Fri, 12 Sep 2025 08:35:45 -0400
X-MC-Unique: dCEOa8pSP9emRcs2bfOjmA-1
X-Mimecast-MFC-AGG-ID: dCEOa8pSP9emRcs2bfOjmA_1757680544
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so17620345e9.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:35:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680544; x=1758285344;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vl4F3QETQ6Qmt3iYKAH8GUoCSTGHR7l04Sg9h/MZCJE=;
        b=talexC0AZduUWNwAl6g525+vYLawT5jMYKGJaQRnVyIoz7Nb/pbM7vnaLyWR2VYGTE
         Jm0Pt0tOvyeXq6mcQthNldz0wjoil/8EfhgcYpiUhwBivqsiywuQSaJvn5K2sEuBOqpB
         4BUlWIUbhj/qixB+jZv1suFPlu1kGktUcKkQS0fiWPvFm3/oL/T8+GHEO0jLm2mXprn4
         hMzQNj0NktuLHmVFuV5Y/vpv4jXzhxT8e/crRxOxmHBjbZss9VgxrI2ZyXi2LqokeGfs
         e615aOgyM8jmGuM4yjpoWESCq68orDJKXrz0GrjWNIWd9DqRInN0eTW3izybh1nhgzRD
         7VqA==
X-Forwarded-Encrypted: i=1; AJvYcCWSc7ZcMKTKe7CES9OUNQTSNX5yI+5mamCLPDKo2FLfIC3zk1co13zz6YUji576jm1YRXgdKgcOHw==@kvack.org
X-Gm-Message-State: AOJu0YzsNZQTw7izZRNFTI4vW1GHM+H6BhW28ReSDZ/3Qbkb+JjUIh9t
	GouJPQ4NrOhHCO8ACi/BoxoRuH/wcawoYMtkmcWgvQUoqD4mDNr/fNwNdMghyxM2JYlzIbj7GgN
	HHaJOz9d4FCMHJp9ldvw9OZ/SE4A32uHHCHIxDOA1JgHwLyPPUrDS
X-Gm-Gg: ASbGnctS5Sd0AQVdq6lLRuqS9oLr8IRihB1cNOhfaNmtDAQ0aS/Jn7ux/my+Dv3ohTB
	dVIKpyr1vVknrmXSw4XnjYQGq6n/H3s5Q4QO2M2sahn1YRDPy7wqfHRmAuxevE0glssQM55SY8r
	3uYl1VIShJwRtwgCWLbfJW/n8OGObVCfNdA5rRY0VGu7kHnob5FccYJd4Vh6tvXSBfy9qsiIF5m
	kSqT7/m3V0huGMgDwFoH4yI9R/4RSe89duaWQwngHmcvDez2qNwR7szNX/0xNAYbLxRu2a3yc0w
	qxENCeNmugQG5cT8jhWVEZLEkSb5B5S0rcBJ7JIUmpyCT7bT7NxekWoFI0VwECxnUqycKbFZj0J
	LriNH7TOcKzro3+Zbd4sSTXgWCsU/xcYBYu0ppwKHF5rqymTmzE64n5tUbRJV6McMMq0=
X-Received: by 2002:a05:600c:6d41:b0:45b:47e1:ef68 with SMTP id 5b1f17b1804b1-45f21208123mr19824215e9.35.1757680543676;
        Fri, 12 Sep 2025 05:35:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEN/oqbYA0X7f4pVcp67reuoA98LJhkZr0rCtEodluWIHcTYO0r2jSI0s6HquK2fSwltZexZQ==
X-Received: by 2002:a05:600c:6d41:b0:45b:47e1:ef68 with SMTP id 5b1f17b1804b1-45f21208123mr19823715e9.35.1757680543157;
        Fri, 12 Sep 2025 05:35:43 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f20:da00:b70a:d502:3b51:1f2d? (p200300d82f20da00b70ad5023b511f2d.dip0.t-ipconnect.de. [2003:d8:2f20:da00:b70a:d502:3b51:1f2d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037b922csm65908345e9.15.2025.09.12.05.35.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:35:42 -0700 (PDT)
Message-ID: <175479c6-d43f-48b1-8fb5-c78a555cd315@redhat.com>
Date: Fri, 12 Sep 2025 14:35:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] selftests/mm: Add -Wunreachable-code and fix warnings
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 Leon Romanovsky <leon@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: kernel@collabora.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>
References: <20250912123025.1271051-1-usama.anjum@collabora.com>
 <20250912123025.1271051-2-usama.anjum@collabora.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250912123025.1271051-2-usama.anjum@collabora.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3u9vvheQ6ysFF01iTTuewyoKis15ezw-N34GxJG810A_1757680544
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5bt9ge86sniuniccc3m54c9wbx31fjge
X-Rspamd-Queue-Id: 9499A40003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757680546-345854
X-HE-Meta: U2FsdGVkX18zgVf06/7rhXYUwoRBpLjtd42fZRKt/E6/1PuRfhmSreOyG0SyxE0xhWH67ChQgbf1HXud91eVMGkm/b2zl1WXZU4kN/a4SlWBZIuFR4wkUYQS1T6vEr+bXVKdltdq98GkTRnyxdf393Fr66EiKQZvn+cUPdqCQWUI+BVB7IL4aWJB+xizy/yKzDAmzO+RE0qIeSoFnF8EPwwwBImgNkE3u4kiLpbHpSSDEglGkuWpPCa7MyzVlE+i6cKaG6eW3rYaX5SX2BVQ4ALyuljYk8HKt05s9IkdHf2+C8iVcgvPskDOuieaHqeJdVI9t+FTR/i8QC52kvL62YzJa55ucbX/hrtczlu5J4MyaqQ27CdkJvix1cZIpPrLpkPpM7m7d5iOn5vulwayYWb/OxIFMpZjWaZw4kVWcvBY2ESRFTm0DRn2x6HAikIhcSpNRj3sxnGmAC8oHMdVpn3cQfoU5rnHTIuMJ2P8O+iJ4AGEChhUJvafsm62OfvLF1QmDSwEBacSiHk+J63WpBHa5yyX8b5mAeQAKUPrJxpBTu2i5SonAnmdkasdUVYpCRfZPHJ6KwGeCHCNVchMoJMfmtKZjL6P2BKSbuGg+qJf1lJWZ0d/E0i+MxuYHZsC6fl0KJXRovu5FxLqKroFoNq1otP2FGFiTqygz0fUngHUZTPVJDqEHDGGYmEgCHoeos50rLwHdY4VS2Pd0fQdJI0JsFfx/1RBD78GFzbu7hAa1KGvA9KVQ2Jr6kZinIFk0IJiqBk1pxq/xgbUnmstyhll+ruXSfdFNdeheBzz5SO3rXLpH8GtKejK3rN8v7cxUcL5X4Glk1Z8bQeYhpfwQIhFR6/BQCbKrVs3Yhyo016yOebsBaYEvH59WRtH1+Lxk3YbNAWf5RUnTJ653gkinV1w2Z+5mR0DZ6FCUPXIPDvxdD9wMHvj3yBgLp3kBBi4zKFGEWyRAcUmV6o5U9C
 hdcRWduv
 A77LGyRTnYPivAL8csbsQ90HC9KFIgABmfM73z12YN1a08CQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12.09.25 14:30, Muhammad Usama Anjum wrote:
> Enable -Wunreachable-code flag to catch dead code and fix them.
> 
> 1. Remove the dead code and write a comment instead:
> hmm-tests.c:2033:3: warning: code will never be executed
> [-Wunreachable-code]
>                  perror("Should not reach this\n");
>                  ^~~~~~
> 
> 2. ksft_exit_fail_msg() calls exit(). So cleanup isn't done. Replace it
>     with ksft_print_msg().
> split_huge_page_test.c:301:3: warning: code will never be executed
> [-Wunreachable-code]
>                  goto cleanup;
>                  ^~~~~~~~~~~~
> 
> 3. Remove duplicate inline.
> pkey_sighandler_tests.c:44:15: warning: duplicate 'inline' declaration
> specifier [-Wduplicate-decl-specifier]
> static inline __always_inline
> 
> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
> Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---


Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


