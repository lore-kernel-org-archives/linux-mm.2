Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B08CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 09:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEF2E8E001A; Wed, 10 Sep 2025 05:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC6E28E0003; Wed, 10 Sep 2025 05:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E1A8E001A; Wed, 10 Sep 2025 05:09:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B30D88E0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:09:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 78C438567A
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:18 +0000 (UTC)
X-FDA: 83872766796.17.21654FB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 118F7A0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:09:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XE1/dD9M";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757495356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tTNgFDBJshMShsKKr7JoAqLRJC/3PHrKgQgN+0T2LAs=;
	b=1ONN0biCWq+LCxAScwlGpDFah7xhPbagnc2oG6RnbWoRovO1G39y4gimTY5NRO10OtboJO
	1Cc8Y4kBCMTg2GAU4dxuZQphP5lybtdpfZB5BvqzpHDN7J755SkMkoi5jtQx0NdtvdJvka
	2F68QzqKDUVQWpfllJPLkCkgHNA5EkU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="XE1/dD9M";
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757495356; a=rsa-sha256;
	cv=none;
	b=qyWK2tlsnFDiQsPxsjGtSLdrW6ziiM/b9b38CtDxir0i4m31KSN+MfjRzVEfiNyxkBfwVQ
	zRQmo+DSlsosjvKVLKv/OVHu8ol54ti5e5lhSI9sDHe1TnyizBT9/pBj/zrPZyUxop9S/n
	QEM4nioeKrzpaJA7HqaBg73hx7sUY9U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757495355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tTNgFDBJshMShsKKr7JoAqLRJC/3PHrKgQgN+0T2LAs=;
	b=XE1/dD9MuuNRY7l94c0BnThK7LAZCHXCChycmnjudbioo9UxV83xP4Bp09i/L/dg4AXsz0
	gZbWTN0iQeph6Rs78c5uyNzhGgdaY42S4zF2A6F9Co0dTaCO8n2UZo7unO2h4Rh4A/mXEL
	nLC7S87dHZzVP4XgwLim48E2XsLvYU4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-G9C7Lqi3PyWjCNb0z1DVBQ-1; Wed, 10 Sep 2025 05:09:14 -0400
X-MC-Unique: G9C7Lqi3PyWjCNb0z1DVBQ-1
X-Mimecast-MFC-AGG-ID: G9C7Lqi3PyWjCNb0z1DVBQ_1757495353
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45b9a856d58so51700745e9.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 02:09:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757495353; x=1758100153;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tTNgFDBJshMShsKKr7JoAqLRJC/3PHrKgQgN+0T2LAs=;
        b=j9hQkks4SPXBZL0/QmP0Hnj8V0lwyaHZt7BAIa/HzS1WcUtYki56Pzs8hG+KdNEmaT
         JjYV9eS3WCB+pMc/m1u2zjlYdrxD7buNBU84jXbHjYAEADLUIoop7EhRp91J/zuCwAzL
         7EHcvVxVVGhaKOai3Ml23iRcOvXt0bCx9XAMnTg72XSfciatRlNK2n32+4BEdN2TW74g
         JUDJBb/0OGUN7XTcT/6BSYdR6P38hBBbudYJqAjV+4qNfBLiJtqS6VVfNfGyRb+4l1+i
         myj3xFf1jUyl6FD3mhddHIV+bddKcD4hCDEP8g5uVaa2sQ+naFDlCyBcZ2gpnlkmaVaz
         M/hA==
X-Forwarded-Encrypted: i=1; AJvYcCWPA2iU9Q/dfnei1AbR0SIniUxb3KXZ9ZEKVo6K1VKwIVDxB89zIrJHWydfjOrg7eSo6Zanoeo6KA==@kvack.org
X-Gm-Message-State: AOJu0YzIbo8TGIzlSQeBHB0JmYk1qkjkEfDjshqTSKcKd7RGO8SIkVcY
	nIz2nlKNHrpF+b0ml4hYFg11TIOFt50ThgCP1V6oQSaSOD8vxgGEchDyW4TuON0/23GYkQPBeAW
	elSXZjdfRu3Slp9XBmVfakSxcg5EOPmXCZnGSxhE4a7pDMtGzgIh8
X-Gm-Gg: ASbGnctH2eyyCyyIyN1WgTTdE6fAqX1yuCMHtAggEguHMRHYzu7GaT0YCswtFOl54AZ
	VzteBuNL83jbjkdfJ81OUqHfrbSCEcW/cb5FpheF3VxvT713xLUMqYNaLLyFUdKNSCJAxHHUAqZ
	tdvVLKTCOdngIlju5JhuNvjNai5Kjn+wBCs+oZZfBHOgAqgLtJE9I80I7WP/eaK94SLt9MFlsiG
	uUkSbHFxMcsWsrc7JPCzUy9mtBGQ0UUAa2v5REXdT+WnucV/sf/47hHUFtNJry6yij5PU4LpR2O
	SGioyHyEZerPssHqJfno/6MZFswsqwpa9TcWTnZD9eWT6gcaZoJxsEAQ8oyxPERlqnkuGDJ9QT1
	379QxbDikSRaKda3/l0L67xObQc5FiqTofor4J+Y8C4ltAyo5aIvTZE7oTpms7BdiSAc=
X-Received: by 2002:a05:600c:1f87:b0:45c:17a:4c98 with SMTP id 5b1f17b1804b1-45dddebfab9mr127597125e9.19.1757495352838;
        Wed, 10 Sep 2025 02:09:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFTz8v2ml6j4Meo+4Bxvl5aRHnzamEhWFdxrtd/cMtm0FrmC4Ofx4NSzU59gCksg8a3qNFCw==
X-Received: by 2002:a05:600c:1f87:b0:45c:17a:4c98 with SMTP id 5b1f17b1804b1-45dddebfab9mr127596905e9.19.1757495352381;
        Wed, 10 Sep 2025 02:09:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f17:9c00:d650:ab5f:74c2:2175? (p200300d82f179c00d650ab5f74c22175.dip0.t-ipconnect.de. [2003:d8:2f17:9c00:d650:ab5f:74c2:2175])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7521bfd08sm5935249f8f.4.2025.09.10.02.09.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Sep 2025 02:09:11 -0700 (PDT)
Message-ID: <b5169886-1216-4d49-85f1-437ad7063fd3@redhat.com>
Date: Wed, 10 Sep 2025 11:09:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: skip report_hugepages() output when no
 hugepages configured
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250910090316.3406-1-lirongqing@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250910090316.3406-1-lirongqing@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G5ansXJ1HOQ9CvlFrOcBgG-sGGLQIi3kSjLqPCU1KCU_1757495353
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 118F7A0004
X-Stat-Signature: s54cdyj7hsqw8atydu3twbbd31purotn
X-HE-Tag: 1757495355-558249
X-HE-Meta: U2FsdGVkX1+qkT6kIH9dRsRPFEGiU8ekK2ADNLUKZqf9qC7mU5LK8KhPS3yf2wSLniGMcdFuH7htXpumG+TIs2HncKKRa1In57aXzT6abpNC5fEGn3A9pu5onTswXcmIiWFzKQUbot8BarWWXyyUevhL5sLM/BaJut0b5v+102R7cTU1wpv2B44S7Kq8mnWKQI50qd5r+aBNYkYnYlYmsQDO4RDUov29yu8OWG3nfZRE/m3j3oKVktNzCZl8ruI5DxbHAIGXh4kXwUCJpRBOlB3YUsQ63pmiUvaAuJzBrVPU8wthS6F7AJ2n3WSCOLO6rwu/vqK4Jmr3iXdWWgo57QAmHziay4DkrSdvoDWNXMW62fWhYB8tGoVvwGSyScsUMKUgY/zR2h3NhnpnSwLuin46KshfRdziEp5weh2+FV1HQh7kx1M+s5y1JjKQKBTAT07jkZrX0Dkz4FqqoMzmEblz9aqOHFRKNNgepdKdDwee2+arqMid9LjhryQbWdGD7Khpfxd+X3hqhvV2bGHwkT5pov0huWNlQUzpWsYlt7AAS3jN0PNEtaORP0Ov7yToGkRQ8meAC14t0ClLHeCQns+SZ2pegKll0cp+YsieY9f1UeZKF/4oADWEtRZ6bc5oRLsjadihJLkU9dsu1RslqpoX0eoZRVKIPmyjzwA/1pxLstPK+I2Y+VxCOYkWClUx6i/oVFIsh84DBOAABzWTzUG3b5AjBghK3qUyo1gUPmCAitCk3SODNUGCUmcGrIM2D/lCIKJ9pLFjj0xApmg1LxujXrmhiMXo3Rj+breG1s87gkyX92pkcdHWPy29gqO9thfkXY7+sVLUs6WH8Ox+KO/apRD6IbN9bcgsLXYwPfLZwE35wkWSbAh5GpnFN/QgMPf1FoQawfSAUJz3Md4cFXqG8oWY6j10Y0rdWobUMoo36IeK4ymWp0lBLjfBUAMOeoNENJZzDcgFjGhRpIs
 IWShugFG
 CGsPgzD9qLSymUaauHI1D8OTxc6TMsvdVg1fE8pCS//bzOGPhYYielZf4qcDY8HwN0bBjHq+YSuUzE3yLNcX5qmhFZ7DIHY0UcdWkvCUO3W2YnFktl+WRbOrwRFe1nmJvJoWD2XtD2/N2AEWBfPXMAz9eRZgIojE+llZ6tIr8EEcmKefjawHabjxOTFd4YEWdOP/OY7wK0eM4hywgrc0xjHnXP+NA6qL3DBIq/00FkA5GEqa/iwIpCtRyK5EOrAVZo/FioTX3pi1ujZs4zWSJGbH1t8paEFnUswzcUQgRGI3jZwqKaMQHpFwsyj1CgpOmHIYcFdCLUXqOZYXpZ/DbDqi1KqyTO2+Juetmh+gTCPBjVl+3k/+pjYS3njyN6tWFM2Fo63nxt6U/6xx8WwU7jB/IhKqw2m57AjBumOFNB/58tPu0dMv+1eqbsEx8LnkKGp2aOFP7MlvLiA11Z2F3VTqq6chvwX2C3BNbvfihntLmoEkurxZr7PKl3DzBHhYrB6bZtLzPu67OSkI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10.09.25 11:03, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> Avoid unnecessary report_hugepages() output and processing when
> max_huge_pages is 0. This eliminates redundant log messages for
> unconfigured hugepage sizes and saves CPU cycles during boot.
> 
> Before this change, the kernel would always print registration messages
> even for hugepage sizes with zero pre-allocated pages:
> 
> [    4.118953] HugeTLB: registered 2.00 MiB page size, pre-allocated 0 pages
> [    4.122920] HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
> [    4.126920] HugeTLB: registered 1.00 GiB page size, pre-allocated 0 pages
> [    4.130920] HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB page
> 
> Now these messages are suppressed when no pages are configured.

Well, there is valuable information in there, especially given that we 
can allocate these hugetlb pages later.

So I think we want to keep printing that information.

-- 
Cheers

David / dhildenb


