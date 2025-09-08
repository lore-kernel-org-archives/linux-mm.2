Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5E3CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 039288E0007; Mon,  8 Sep 2025 08:21:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C2D8E0003; Mon,  8 Sep 2025 08:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3D38E0007; Mon,  8 Sep 2025 08:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE1898E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:21:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7950EC0142
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:21:26 +0000 (UTC)
X-FDA: 83865993372.22.CE126B5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D9DB180006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:21:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/viAak5";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334084; a=rsa-sha256;
	cv=none;
	b=IZOMHfkvnzpLOzSQjpVKeF2GK6KUryArnrQdeA2JOcoRXdlu/fh0aO/sXVZuxeqbep8pic
	0HwAVBDjjJnIlQcLM+DxjMqiyHKy2976u7pCirDrWpccFRonHVXjemrRk8XQawIzf4Cgn+
	b4d1xptfdyTjPO81piwLLgV9Sn9Nifg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="X/viAak5";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b4LGF6/6A+Ec1kKIYxFDi7dxUU3JUaFn3tA0l45b07A=;
	b=tzTCYQkVRwJurgF5m5DSrSjvV6WcYLGC6wfLYmXfRk/0GOkiApQvj7hsDJm3iuCtJYHORV
	RD81onYC3sYqSGCaMpJrVABNBigajSGAYQdkxXpZNOuB7I4cWopaMDbbqtGjpMjPqmdNuV
	QoDCav5k1LVjgnETHIUMnaWlvGfq8yU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757334083;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=b4LGF6/6A+Ec1kKIYxFDi7dxUU3JUaFn3tA0l45b07A=;
	b=X/viAak5wY5dhICcjNlil7cDmIc6CLKvcSANeC8x/tWafZzFdOdxfbd4zf8SdQmKsDBFFS
	Cgmjf9Mau/P7bUbQTwGn4nqNOsA1XXwr7Y9lFHl17oiIPLvl3+94Ad8oFb4rRaDvMwsKuI
	TH+XlMNJg1HyipqaU8gZKyxeKpIZT0s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-35-1qJhNCnWOJGYzc05ZaJmdg-1; Mon, 08 Sep 2025 08:21:20 -0400
X-MC-Unique: 1qJhNCnWOJGYzc05ZaJmdg-1
X-Mimecast-MFC-AGG-ID: 1qJhNCnWOJGYzc05ZaJmdg_1757334079
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so30266895e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:21:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757334079; x=1757938879;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b4LGF6/6A+Ec1kKIYxFDi7dxUU3JUaFn3tA0l45b07A=;
        b=tGwUhn+hJZKYE10VfuE6MnWRQW4XPijeB5J9Epb0tMZFOhf0yFAHE66e7Wj41P9/3S
         MNeboSZHD1ZU1LqURFhvYu8/SOoUN+wRLlrq/ZNlfQQ+AJYmD7xlj+UuDR6IelrhR308
         bqBlpkYfh1R4q9v1ucAE7x5ADoD+rg49PuksT9Wg5uNfGqmMk+s1OdN/DAuF/g3hK8NW
         b8JLqGL8Yy3XhGJLZT3LnLleNLk6b2hl/TIhKokKPxzBOOpJK1mAW3gr37NHwBZ9j8Mc
         Nr1ojvl1+Le2aB6ah0hVgcNqGC6xZU+wbG4Z9p228REsK8jKzVCbMbpCKgKvhgjqOK41
         TBrQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrHJMB4dZpkOdSxesVup1yKDYMb5UtevPS3YBqnyL8rYv3irpxtMXOAicPyWGlwIQ4deFrZdPYKQ==@kvack.org
X-Gm-Message-State: AOJu0YyhuBWaInm7/qG4VTERiRW0eZUSJyVPZa+7K0RYtzTeATb204pi
	kb0f+jevkcLA0L9MFga3N5fbEp4RQmI8LZxnb7uq58Eu1xmX3GocREmsj8MpiQLJEYRwTEnT9Ja
	M63ek/gY1+5J5zdVQjo0RHMLBo/6h1Lr8xc1J9jMsxwK4WdIIy+O9
X-Gm-Gg: ASbGncuL/ceD0DikU0TONC2pm9TUHZRv7+14WC6epJGt96KuO1e6jnsrIjqVsZDMlyW
	9rahosVeqG+PUZuFCm4JK0PyzdtvTjKrwxwePvdLt2BDmqQMeXtzUWTYFOj1qU6ldU9TNBH8VLy
	T2ztmifQXoOB9fyK0HOmFVS0pZ8FjcaTCBdfXuPfQSlhdEOb/PiOF559ln8UDoT6zUZONtSLork
	SYDo5JWnQptAx3QOawuDUy/2h0IGlEUHYPqnxwwIwCGd8QhKvkAKkkRcguhefum5XKOrERbzVLN
	abMWFE67aSLq/dqvvBwlxUXN6NEjolDsh56D5y1wRslBnUXXiDzvRu4VTLOaA+81OmR5U/IC+33
	hJXrvv0CD6ZgHRJMf9I64OyjryPkGJu3OoPVB+IBc5VlroDJZwT/YMavY6Ev+OS3T
X-Received: by 2002:a05:600c:4f4a:b0:45c:b523:5a09 with SMTP id 5b1f17b1804b1-45dde21d0c0mr67037445e9.16.1757334079238;
        Mon, 08 Sep 2025 05:21:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEOfP/PckjNKVTxCMvCkIOKSMsum91MTyZE+ZCSe31JnH0/HVLXj8wHIDxlH9JiUcB3ZBOyuw==
X-Received: by 2002:a05:600c:4f4a:b0:45c:b523:5a09 with SMTP id 5b1f17b1804b1-45dde21d0c0mr67037165e9.16.1757334078820;
        Mon, 08 Sep 2025 05:21:18 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd2df4c8dsm171199905e9.15.2025.09.08.05.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:21:18 -0700 (PDT)
Message-ID: <84d3ab47-a960-4709-b127-ffbb8d85ac23@redhat.com>
Date: Mon, 8 Sep 2025 14:21:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 07/15] mm, swap: tidy up swap device and cluster info
 helpers
To: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
 <20250905191357.78298-8-ryncsn@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250905191357.78298-8-ryncsn@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Mzr98yoLAm3BGA3rxOKtWVpg8F2eZCF3oa-gkWZn83c_1757334079
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D9DB180006
X-Stat-Signature: ryxwktp6bqj1xzxeazfodqgr3od5j3dn
X-HE-Tag: 1757334084-91856
X-HE-Meta: U2FsdGVkX1+hCXPrw8vg1TtJRNLAYkEm9Je7F9Pn2T4Hla/UpQAeZ6z1gtgtBwsMaqanrdRZbrkoAXsASEdhs2MHvWcUNjIUYK3TNpDtFsPmRJ7lSfHxbAW/kc7G+26gC7Muif0nxunnOWE+MNpGC4ZtJgJurMAogKBLIhjxdt0Oro1OYPBgy5bJmQEAW3L2V1SxDxPJQfz5RNCpHDlLohSfGmhnRUwpt3keQjWdcQTPj1UqkBcgG97YjG4NO8//VhAO9IoFtBiQf75OWPCwzeXdMmpKK52jXY9R6+pZxQOOufT2tnD1NnIFcAcR3zG+fSW3NBnDSF+hQBnwBRZgsKqX/ty+xN7u71cdy/xeBskbyycoqqsRxD/dMSPwKQGJ1Vt+HwCmPQllAiGk27nmxMcaC0STgi9zyHzIehDSKdMnKzAvCHi+wUCDhzXasnDFD0vRswZTJSrRgRXrKxi4Yg3fl/hBphMmlciIkMq3efrZFtgrLC9nJk5CnTJ/UjQrOIDUto/GTUlb2QunWZ1H5UNTraIUv0AKeaRObdphCZHV7vLIcoU9YgOaYHPMhtchrA2Wi7ETaG+num/RKzUd8je827i5q/XklmfqkFk/TiLuR5VI4Nu6G1x7uhmFeCyWZBOYRVPWxCnP4r5NDssQ7QXJyqX15hTbQn+bXhjYi4ik3XaWEfbfkCqlkItdYvQEs1BRFVB+x9OqmkoqTkIkTKh2hECdWiE7H+SllM+FbizvqUFzl4wbXroOd3YnI0J5IJBJvOdWq2QWM/nP7hm0eFFoCKZwlcc9axfOoB1WOxIr5LxESj1LKXf8t+PoriDlayWiaXcRcRy/Or4ey+XZdh1vntPTHtlFDUd8fIJpSJ9KYBQ+xHo3L3B6hZNosa7Rx6fi67MPEp3EX39k7p7ZZpyTnQ2w1COFkgw+lktv3HR2GBMWO4x/DDwFTBAr3A6Shimf8bB9xvQJDgx00zl
 34xeUfeK
 r9sZ4SfMOPTzYLEfp46RFmNGd6Al1PCm4/P4aXY9rtsV1mkVYZAgaRDvSrOrXgTC88tFwP8VD2TqrZrDNZWUTt77WT7t+b1F+Bx2sbnHmMFJ9uohz6rScDV5SDWlGoplXyf4dzKMZfnj4G+3MEk03/7mjRKotD9C4IVEncf072ziwEjoMuCDL7dG0ArmTEcYEd62vgmjJ1pzi4rSfIdTyL4r3e3PQ9rq7GoDYN+A7HdZQ2xW6lUcpT/4TsTIOR8K7lfTEKIaVy1FjuqyOEpi13Cig3gz5j83m+mGj434KoJ6OrsWjViOmhjn/Hmql42PwvfFMWyEtvv7vex6V2mnQNghsEYCFZhekBf7bHCjapiupFQ8lJwP1whP1lrFtjX6LfzSRxsb45pZCBlrtFt+iN+0fupNm6/5hWx6YR7EF4sgBrnPhbMeR86cDevVTJ/0Ib5D1Wu4AUXfAyoaSED7NhSRoGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05.09.25 21:13, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> swp_swap_info is the most commonly used helper for retrieving swap info.
> It has an internal check that may lead to a NULL return value, but
> almost none of its caller checks the return value, making the internal
> check pointless. In fact, most of these callers already ensured the
> entry is valid and never expect a NULL value.
> 
> Tidy this up and shorten the name. If the caller can make sure the

"Tidy this up and improve the function names." ?

> swap entry/type is valid and the device is pinned, use the new introduced
> __swap_entry_to_info/__swap_type_to_info instead. They have more debug
> sanity checks and lower overhead as they are inlined.
> 
> Callers that may expect a NULL value should use
> swap_entry_to_info/swap_type_to_info instead.
> 
> No feature change. The rearranged codes should have had no effect, or
> they should have been hitting NULL de-ref bugs already. Only some new
> sanity checks are added so potential issues may show up in debug build.
> 
> The new helpers will be frequently used with swap table later when working
> with swap cache folios. A locked swap cache folio ensures the entries are
> valid and stable so these helpers are very helpful.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


