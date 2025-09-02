Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6E07CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 07:47:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162C98E0006; Tue,  2 Sep 2025 03:47:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ACF8E0001; Tue,  2 Sep 2025 03:47:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050758E0006; Tue,  2 Sep 2025 03:47:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E84B58E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 03:47:21 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5AD97140B30
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:47:21 +0000 (UTC)
X-FDA: 83843529882.08.3F4E0FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F3781C000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 07:47:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UJ5H10dD;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756799239; a=rsa-sha256;
	cv=none;
	b=Ct8E60YMK9d3juEulydgiEwYkWmyuz5N8+hVZoaijH4fJ2B97mnPB7TK5EsNVE5lMzif88
	QmoUKz34D25Zt23/hFyqC1Hfzzea2mAexi8gPbg1CAuhK8LLKoe/6Q0bO9pc/zdnYs93u5
	dl50tCPC6IePpJdw2A0/n7doKB/MNMk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UJ5H10dD;
	spf=pass (imf18.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756799239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/4+KrprKnhg+r5+Fo2oRDqAy0SsBH27suggL0lHmufQ=;
	b=yx0zAEgcwpRmE4CXxwbZIwnC5RJd9srS0TzyhjSU7LPHRqiWPMNDRh/Sn4B6Ab1rADJ2Ad
	uEU5t25T324NJaTztJSB9JEm372ll7a7TY3vplMH1YSVFdK9PV8NsBkKRGTcJ2eGiEZgQ/
	7s2seDFrcfhfboSoMwWHlaTVdixhDfA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756799238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/4+KrprKnhg+r5+Fo2oRDqAy0SsBH27suggL0lHmufQ=;
	b=UJ5H10dDaxuAh7DFnawu6CeKFkldsp6tq7IkK5LdEMeMSJR9YiFTuAZZFMsCdixvKsXee8
	iMQpjsLnqLWfJgWh2iHlOJ5umZlebTT99pVZh9pdFsNie/SJt3OfMmOHJe9Ez3PAwe4leg
	12xXkbRc5cCWdqsodHTKvFz7K77DqtM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-YgjsOkPiOwWNq91M_R7hIg-1; Tue, 02 Sep 2025 03:47:15 -0400
X-MC-Unique: YgjsOkPiOwWNq91M_R7hIg-1
X-Mimecast-MFC-AGG-ID: YgjsOkPiOwWNq91M_R7hIg_1756799234
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45b71eef08eso25808445e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 00:47:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756799234; x=1757404034;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/4+KrprKnhg+r5+Fo2oRDqAy0SsBH27suggL0lHmufQ=;
        b=OmUpMx+M0ajASWXLtTcnL7GwBv99P9tdF/ZxiQTl9uAym4rzJBpQVs1uHooZXiixEn
         h18xhuaz3UQkT4GZBBl/NDjzYktEj64ekNyOFVO53zWJNJI7/e8u9FRLFE3BQnKtqhnh
         N53Cj/rKpdMn/ZH5cwZAV4l1jKFx8HCP0GgvhMpYNoZAzcoamRv44a2uXx62Zyh5fKVL
         hPEiKatSEql7WBtUgYwQzOkVnxlFHBUKYrg0ntbGfR43FuCxa2hQ9v1IJ50BZpwJJi9n
         J54MH4QbKQ7P300S1yCY2vKOMDv1pGdyUt+eiZuQSxJKN0drzuv+71sQixei5gH5gi4A
         6ojw==
X-Forwarded-Encrypted: i=1; AJvYcCWuJrRexSAxx05q9Wl8+aAlhbAOpUEzXI1nEO128cJ1d/Q9Ir/RTKgvmA9BTjizBNsl0tktllqFqA==@kvack.org
X-Gm-Message-State: AOJu0YyZlf1rAXoc3BTkYjTJuYnIcC0mmvu7w6om2aHTtOBps2JopJk8
	1x889whZ7Y1UoWisaYXLHXTWHhoOXJ67zxOhWjBVmbOL0nC0HL+CGCub4ZxE1HZ7agv7m8IIJT/
	KEgiHebEJMcgDJMtZ7aCr4XYFEt47nADK3+UB3IHyB4gc6pqZpWwx
X-Gm-Gg: ASbGncvZLAwMEEkVOOmlvgzzR1QewU37hYQzmKJm0Di1bhDZ0PmTsE2wf0QUWlst8LU
	sGtBJfptPZGapi6Pkr8Tozohi3Uk63oMGlpNncnpPV35SzdpfBFQnxKFBiOQrftxzKqvQ13xrV6
	ulx642HnBRTVh91Y4aNSZpoqZ7uPCTAul3PqsaxNgTEZGpJy66EUX1gbXgRGD8CMqCnEZUaP9t/
	NKXEVYWl6ncURH5kgQkZQSp0qOUWqPhiSosdCLhMXqOjTGforEYvBJqLyxDXYENxsI7xfDXOVH2
	54OT2x3+X9h7hZYz9KVfdPKY/+8Sc4TIVNl3YE0AWM1BFPEO7X5LB424Q2eP/1/7nIocVfw8dQr
	DEEJ1yBLEisj53CR9ft0B37NZfrh2rAs+TH3A80BO81fctPfSW3ukGCpVXYFMcNZzSbc=
X-Received: by 2002:a05:600c:3b10:b0:45b:8f38:8d36 with SMTP id 5b1f17b1804b1-45b8f388f6bmr44479965e9.30.1756799233973;
        Tue, 02 Sep 2025 00:47:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEt1OMCMxMuZz3NTfIMn17uDdKvWrBYIwYKm/WN6Ey6uFnwE8fHSRWuKYnNl/2ZQ0QtqM12cg==
X-Received: by 2002:a05:600c:3b10:b0:45b:8f38:8d36 with SMTP id 5b1f17b1804b1-45b8f388f6bmr44479705e9.30.1756799233521;
        Tue, 02 Sep 2025 00:47:13 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1f:3f00:731a:f5e5:774e:d40c? (p200300d82f1f3f00731af5e5774ed40c.dip0.t-ipconnect.de. [2003:d8:2f1f:3f00:731a:f5e5:774e:d40c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b88007a60sm69425185e9.8.2025.09.02.00.47.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Sep 2025 00:47:13 -0700 (PDT)
Message-ID: <4741951d-59f2-4485-afda-51d554d103f2@redhat.com>
Date: Tue, 2 Sep 2025 09:47:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/memremap: Remove unused get_dev_pagemap()
 parameter
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20250902051421.162498-1-apopple@nvidia.com>
 <20250902051421.162498-2-apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250902051421.162498-2-apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l8Yrykoo_WBmpliU9NJe-0pMTU8Y39S1UBedLMnjeXI_1756799234
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F3781C000F
X-Stat-Signature: t5tkfh1fzrjbqgwzig6c151ks1fjnuut
X-Rspam-User: 
X-HE-Tag: 1756799238-339588
X-HE-Meta: U2FsdGVkX187gDWabZbu6dW4AiRyOI5dvMjS0bTBsJpqDiRK96w5x7iG2937IyiFBqdu1KPclB1w6G8+uBCDTsKUfTeAlMrAdxWqOVkVjf2xUcu316K6D5ZG+fgysny1zByMBNmF/a0+52+RcWGqTnG84/VslDseOxsxq6kjy4IFxPbWG8pVHdogoVXIfR03ST1rssmzA9FPBU2XNrWY1YISZi9aFT0Jx4U4KU/LXKEtz9htNRA8DaGkJEfHT6PEjfA8IxqRt0IDioAKUTXernVO2khAok4LPBHXNrgzuq81z6KI5xZrSg8YyzYpaOgGwuzGXr3eP9W4xIDQU6JwFqoMUp1kgyHo02kdRpguRMWexsw0EIC9b0rTjqEPFigMlw46+fcgvfHiPMPYhQhLUOkOMiXJJuvSAPEiWU2gLozqUuiDEdg8eCnJgc5YFwneXAzoUhVRX3wL/Yxq7rBCegwjL/QcXqpV4/EpIKb3GbuiTZQe2gLecdKe2RLnJOK/jgOOD+0oa9RIRpT3UStzwfyJQ8xkWFOiWLzyU9B8qY+7QN/gpvDFUvtKoKrmHxfnQUglkqG31sVlf2tp08tVtW6ZSXEVhvT3VPtvjc38kSmYeCMxhRfT0v5P4+JEtV6Yt6UhG08bAlvaiH8LgIgjheZ1Hhp1f3JDDUXp+WvwJXSQFQ4S+P6oCSL0L9JY5X9P3Mjd+xUNtr6XHnJvj7dO9vcek/BrkfvTphfxioY/dWg1SvIBV05maZNDhA1ueBxsXYiNDR7VgSsmvxTkvDmW3O3WuUpD9TiiTgj01KmeK8QspLRxqg4529Tl1312GSD6/izFFbtkhlZvPG3bn5wG1tCYzTHOEeU1AFOel6pzdBFBLr1eoiWUJoTHKNq8MY1lSfzlyiFAjF6MOZTcJsD6MHSEzm/NO8AyX6OXokeRM7Tlvho38GCvVewx/2UzBWL/ldXBfBoaOt3KIhuJLbC
 tchBd0mS
 A13+qto//Swxm8VkVK+4C0F8YTkdp4d4nXPtO5wkA2IveOcEV3YgIMo928XKiKF5LKz4bUAL5BMlvvpACs93QunRLGRQI/2WJfTedO42L8tghXLgzzJl+o0MI1tC6swjaj61GIY65/eUMiDmChMRqxZYK/HnsvYuEW7RGofWiPZIPk9OIPTAlkG31oOqgCF+mfoA74HFYhn/YQ943eDoVHOlASU4N7Cp14LFDVazUmEDKcZ4UbCyNjFSiPPVmLgSFkJRSaZuKb5v9RehtnKJ5CjPx+aSi5YTjRpE0tHkyofX1Nil5k+0zIlQWvRhDR9iMnh8kw7mvMCdYXkxQbmCkM/jbCEyQ5QsOhWJ9lYlflQH+ivBP+56JYAtTWdHUAkqT5focvW5/c9unwa6V+jgMyzF9rCPiJwX7YQMozItTQFk924qyWxV0aByhxovJVW2sOMhLbIipFoX9XZxmLsuUHOhLYS94mFJCM7ehQViMx1vTXDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 07:14, Alistair Popple wrote:
> GUP no longer uses get_dev_pagemap(). As it was the only user of the
> get_dev_pagemap() pgmap caching feature it can be removed.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---

Thanks!

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


