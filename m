Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0D01CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 11:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC7D8E01EF; Fri, 15 Aug 2025 07:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17D508E01EC; Fri, 15 Aug 2025 07:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06C918E01EF; Fri, 15 Aug 2025 07:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E906E8E01EC
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:45:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 901381A011B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:45:02 +0000 (UTC)
X-FDA: 83778810444.02.254B78F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 41FBF1C0007
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:45:00 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TzpN/hjP";
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755258300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoWrtxZKHP46PuU52n+MBoU/cYPThUo0BkEpIvYfLjk=;
	b=KnYIFwY9/zURI1exrDubNhXw3HPgpl59WzszWxOhPbadbNcgmItoCrCTo1/bKUAW4qiyg3
	cP8MpWoNjvkzkfMp4a5ln1ILfXiw6EuDDUrKlIDtO7GQQV0k+26cU7IaPS48E7HulW4sFC
	tO/p+zBZe6DA1Gp5z8kUVkv4Dz917T4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TzpN/hjP";
	spf=pass (imf20.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755258300; a=rsa-sha256;
	cv=none;
	b=idl/tpsGTVf2aBVm28uLFu80uW3EEYdstB4z9o2XPIATWyGfiLiH1038eY8uzpDwFsuq3p
	3pb03Ppp1rqoTQUHrIKNzBIXWu7o1YOFK+1zXEJMgW53ZJISYVHxpMyzg18NsBfnYvPBTT
	Acxn4DugeovXWM/5ZMXoyo6/Tbk3sa0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755258299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YoWrtxZKHP46PuU52n+MBoU/cYPThUo0BkEpIvYfLjk=;
	b=TzpN/hjP9a2FWJIfws37n9FhLRX3y+OtT50PF28GE32e0vc62v6xCk/u/A0NvUnheohSAL
	vwPzBzy09o9fxkefJjorrkRMZyIx4SEeTQD++YIaqFWwJ53In8Z35cjGRrynzdBseZXx51
	YKi2Nvs7sebH3puGa+Q2iRaXO3+Kgwo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-606-X-oi9sk-NyqtsYUlXyN48Q-1; Fri, 15 Aug 2025 07:44:58 -0400
X-MC-Unique: X-oi9sk-NyqtsYUlXyN48Q-1
X-Mimecast-MFC-AGG-ID: X-oi9sk-NyqtsYUlXyN48Q_1755258297
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-55ce524a96aso1054509e87.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 04:44:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755258297; x=1755863097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YoWrtxZKHP46PuU52n+MBoU/cYPThUo0BkEpIvYfLjk=;
        b=oyZXjRy9qigHxFfOZPDnLk4wPat05GtoFPG6rl2K3DkVf02m0mRsPUIBte7hcQxt6H
         2kyGNNz099CXW0dISB+U10zql9PMsekzK723ZitKRZ1O6lpGAS/0RO6q86Y0Tm9doyV5
         D7KgO7+AeX9seK0HosEBDuG9BYYfwxwXBYVbJKR1ap2B075YZ/y6T445Swpm80Q3o8ha
         4MpxJo4seWVDZtB6Fau3j2H2GR6TglB25iXSSLfd0m7s1vA7PVT4dHoCHJJFSdDniWh7
         b4tRIo8H2mWvDAbyYZctA1SPHpFQYICKGk8qkBj7JpCOT1lDzNXQnaCJD2uHAPpl1J5H
         me9g==
X-Forwarded-Encrypted: i=1; AJvYcCWzs0kdKYPw3yOZmMMe/RvnLJcTAmFs6dpaX+rLwuchOiDevTGklR6rit17JXPEgfRpnb0fA04cmA==@kvack.org
X-Gm-Message-State: AOJu0YwQrJ3hIzSayK9I3ez+4t2+Yh3FXgeTQjbeZeKBzZrrXyxgzvxe
	FBFF/zctANgswHUHY9HE0m9d3NpgH9LT7lJtV4FU8xRlaf25RnPBRiEqtpwotn3XOzrxgbpxkb5
	7AJ93NsX8NrG9+kyvX4m78xNIuQNw9l9COlgekrQDzDe5GjCSbMc=
X-Gm-Gg: ASbGnctxnMWPduaV6jaNste6NsUtYt9HmdYI4uj75kJOcgXzZuH7acvm0M8YisazQZW
	6lHULJXFJT+fLWgRrbVJqwTI5G4wdJfXi9fCLWBfKFWe6YmMS4CDh4V8yCpghaQKbhJClNpTrW3
	2fsKAHldTPPuXLetyUYGORdAd87K0xIhspDReyivKt5uWwvRkokIa8P0Ir7fq1+czFsIORJ61vE
	uKXA9ooNCSusUO8R+r1q+UMHR/TvIjbAQEEixlbZSQa9bulavN10PtaybTcxwJVzvM4jxNvAzax
	DSvBvel4EGKpwAgIC8ItyotWKLLObwuqEbWPXi8dxMqH3QhXYp6qAYDs+Mw2pTWmOg==
X-Received: by 2002:a05:6512:3b96:b0:55c:e6be:d632 with SMTP id 2adb3069b0e04-55ceea3faebmr400607e87.1.1755258296816;
        Fri, 15 Aug 2025 04:44:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF3D3NMqi0KpJZph6yZf3k5y3mxGkKOd0EHNuLEzJEbyBl6SKYpmYQlIaH9LALZ3KS2+RknGg==
X-Received: by 2002:a05:6512:3b96:b0:55c:e6be:d632 with SMTP id 2adb3069b0e04-55ceea3faebmr400602e87.1.1755258296301;
        Fri, 15 Aug 2025 04:44:56 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef35fb71sm240902e87.53.2025.08.15.04.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 04:44:55 -0700 (PDT)
Message-ID: <c629f600-94c9-4cda-990c-83e429a2b9a1@redhat.com>
Date: Fri, 15 Aug 2025 14:44:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] Migrate on fault for device pages
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky <leonro@nvidia.com>,
 Alistair Popple <apopple@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <e57cfe5e-2031-422f-9c50-f5a03a467cb3@nvidia.com>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <e57cfe5e-2031-422f-9c50-f5a03a467cb3@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3F4lVTX3SA348lgpnX9NCPVb9AnpLGdbQPJ6XkakUtc_1755258297
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41FBF1C0007
X-Stat-Signature: r7jrkxbeqcnnu9ku7xtbmcnsex3b8g81
X-Rspam-User: 
X-HE-Tag: 1755258300-286890
X-HE-Meta: U2FsdGVkX1/csgOZLahnd77vNuINAz/CIa5dpS7SbGZKc/zo17KDjFZdGc9a2NaX4WB76PJQU3VRVAuLSZ7UmuG32HDhxwHif5ksXccPDuFmDWmBYrnzUH8Uy8aolcputNIwKo2rUO1R0A9qm0e0NWUCZ2kGLU5IeexLYdsi3boQZUs9NnJrebMQ3bqfcfw8p13YaSoIKIdL8lRlxqfmiZyyHqsfwbNiajljmsu3vpfXR0UwWcneaH6VkZw42yZWguXatNtUf6wqlkuuc9l5cXHV5EpcZnaZq8N9WjWZxzRGzW9FkpGnm1OI/zt3gOy/YOCz4Ecgc/QOlg0c9m9VgbaRxegpeLkcUBM4V9j/Qc+LsepYpPDoNNOTQEx3S62kqLOuDFguf+w1MM6qa3EruPCxiURdOwbW15cRdo7uTiN+k5g6SFRsrggAGJ1EEyRr26bM/vNqzvBUy52usuxGgrEz2GsVkgbXdTrpzrDuPPTDewN5zijTpT8T6FkH4UoT5iirtk9iwZfl3bcR6JJNgIrOt1DoKBgLArTAAlgqZUf/pCOxy/2jVTyL3LZ0hWdJ8NuVsNEAjxYUKOMTcjFxszaeWpTpS5fOwsBjnvnyM9dVrzeQcUGHZrNJnrFz3iYYM3GgfTcSvBE02uW+cqrEs5FVFnJ6L5yYwnOwypjpDNBiJhLqfqDFqyXaouaOtAmlOHfiRnuN2CXZJAlP7L9CTO++ImyxcikGwshjVdqsxJsj7DHORJZT92rtXSxdlhFLYoIxA6zwG23k8PKHrLxh0w93PWWUYcmbb7NKPxFYRSpSj9hum09kj1DuGcEs+Sow16dMk/j5yXj2MLxWrO2MZ6nZRvIXsNWtwpk2YDFpZMePUUlEsda4HQMrzR8YIacQqWfTaYqM8OnkY5xVIGdDY/STt+ZudIUR6CcL7geO+ZIBYWrUQY5kqfkl27WZGBMbWv//txADObfhkGZO1lr
 yyc1Seik
 2bq8/riU2f+GNySIFSqrfrJCSsFoxH5wWX4PWL8HBMPRz2s+V6Jv1WDrowDMxOlxz5kWrADs7mQliUN/j29NU/gfqxdssiK3cn9bIGgc05t7mXw1huJqW9gI3f3xDJpT4zB9v9rHZDnnKs0DxflpjaSOGbroIwSKvxX30fI+1OGf7BrpcGc7qOkSa81DCQO/TEwyM3HDmUJQItng3cq0LgwitfxHw6Aort6XiYmiSyUqnKqy0T395nX9/BvjtFRJ+NZtB3v2sMp13DiLf+zNW0mr5Px9AYBF0fLSVUBZLr19F9HaqnUlbSYJa4p3htHgf74zv34DBqqOwxNnnhFwG9C/MH4BLByK20++Mu3pn5bTwtsshfXm86F7sSXSdD27ZADbdJFsuPj6AtE+ySfdVepUmMNKJRf0u+bMS+zji5CC6Xr65Cdma0mzidvL1e2alrO20ePlvBocgt8mRklSjOz9Co6syeXHrPD6lzOKvUwVxBAxj1rh/zuf6pL5Qdo5BPrBy83s+ydMEifAM1szehyhZjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/15/25 14:36, Balbir Singh wrote:

> On 8/14/25 17:19, Mika Penttilä wrote:
>> As of this writing, the way device page faulting and migration
>> works is not optimal, if you want to do both fault handling
>> and migration at once.
>>
>> Being able to migrate not present pages (or pages mapped with incorrect
>> permissions, eg. COW) to the GPU requires doing either of the following
>> sequences:
>>
>> 1. hmm_range_fault() - fault in non-present pages with correct
>>    permissions,etc.
>> 2. migrate_vma_*() - migrate the pages
>>
>> Or:
>>
>> 1. migrate_vma_*() - migrate present pages
>> 2. If non-present pages detected by migrate_vma_*():
>>    a) call hmm_range_fault() to fault pages in
>>    b) call migrate_vma_*() again to migrate now present pages
>>
>> The problem with the first sequence is that you always have to do two
>> page walks even when most of the time the pages are present or zero page
>> mappings so the common case takes a performance hit.
>>
>> The second sequence is better for the common case, but far worse if
>> pages aren't present because now you have to walk the page tables three
>> times (once to find the page is not present, once so hmm_range_fault()
>> can find a non-present page to fault in and once again to setup the
>> migration). It also tricky to code correctly.
>>
>> We should be able to walk the page table once, faulting
>> pages in as required and replacing them with migration entries if
>> requested.
>>
> The use case makes sense to me, but isn't the sequence always going
> to be racy, by the time the pages are faulted in, there could be
> others that have been marked non-present or do you intend to lock
> all pages during this operation?
>
> Balbir

Yes the pages are "collected", so locked and ref taken as soon as faulted in.

--Mika

>


