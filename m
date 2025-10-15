Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0782BCCD194
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 17:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49BB68E0057; Wed, 15 Oct 2025 13:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C338E0039; Wed, 15 Oct 2025 13:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362648E0057; Wed, 15 Oct 2025 13:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26B068E0039
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:45:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D82B8160251
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:45:33 +0000 (UTC)
X-FDA: 84001075746.20.7F30352
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4378F80017
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:45:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BBN3pAyD;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760550331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLZxA+ljz7oJNZ1TjoOfUTrV/UOD29CuOiwMJY5S7oE=;
	b=ZKpARQzHFK77pE5L33bqDdIfGCod/ZGCx3Kq7qzSw/Vc1kUxGyVuQP+dGCezK8k528Eolc
	XEbFv5bPIsTFLUpwN22dgc0liODEvghK4k93AxvMMQaXsw9InAkWFF5qWpofHMNW7Zth7K
	pu75MWTDMsr0n8A5WkxVzzdfLf6GIjs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BBN3pAyD;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760550331; a=rsa-sha256;
	cv=none;
	b=A+GcpRQxMI9e/WVBAnEHUB+PaGdAfHIkNCopQEhi39etwCp1Bw4AFl2Eozs10FQkRi7kMO
	mhNMTSNf8dbp89fXUosYRlyHUzRSD059PPUADIIeHrob27w6aFT3onRUWa1W4thQG43ff6
	MYZA22BPkuLLSKYemAsLEaaWy2UTQl0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760550330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dLZxA+ljz7oJNZ1TjoOfUTrV/UOD29CuOiwMJY5S7oE=;
	b=BBN3pAyDjCGlmkAb8baNPOBqes3JYoOstWnhwUGldGFFhZ0+i6sfB2M/IDbMwILAboDO0y
	1wYIbzaSVEDb4KevKsp6JrpMdJOF47txinNy2QYDYwJPMXZvGOkMAZDp5AfQOKfJyx/LY7
	OlnoPL2SF35uMwAEXbHG3VGTpcWJ6fg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-621-DEaiqyZuPkePL5dWXE1-XA-1; Wed, 15 Oct 2025 13:45:28 -0400
X-MC-Unique: DEaiqyZuPkePL5dWXE1-XA-1
X-Mimecast-MFC-AGG-ID: DEaiqyZuPkePL5dWXE1-XA_1760550327
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-46e39567579so34648935e9.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 10:45:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760550327; x=1761155127;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dLZxA+ljz7oJNZ1TjoOfUTrV/UOD29CuOiwMJY5S7oE=;
        b=Duj43MJTCp00A1TfxBpRPniDgjMY3AZUcwkYpYlzclrPATzgRYZX1Ckbz84VIajiqS
         SJ1Eg0PBpuq0BtSYTnmhhphUyVsWdp7r7KOjIz6Vs0B2fGGbgzPA87auDIpJtGREjc7k
         4SvmJJn6uMwAf7DPLMyAkA57BpbiDBXNIbUV5NadcPW45+hYYkbxiFsVwpvTfFjsKPxx
         coAuRa4R536t7aMti9sJLQbGCSxMLOpoeHjCOVM9SxUCdSdJ9asp0oKeFt9wsmw1C7ra
         KOdKfkDktdg/jdvVHBK/l2ptI1RNIRc4a1bjgXVYrvBntQ+Vca+Bl4Lx440tJPs8WkPL
         HOnw==
X-Forwarded-Encrypted: i=1; AJvYcCUm12EiQIvp5yx5s8zrF90GssnDvTuKgX5+3btrUlbeAGb4o1Z4UVqJ0GtpKknNrSPvnbg2wvF0Ag==@kvack.org
X-Gm-Message-State: AOJu0Yx/z+ow637roXKOguCqsFZDPx72mu65q0O8e6G/Gm3wjxTVO48K
	7PNW72I2ceks4Faa7//UNWVYQWd60llIc2AyBtf0QaBbBwLNtEBznZPCCGk0zD3uQLhTZ+qLZse
	FLE4uyGbZZWPQAwBkn46nRogQlsofApdKkY3xkg0mUjM3c3GcdflK
X-Gm-Gg: ASbGncu/1BPgMEFMq2Lk3+ufGTSRt7BUBxHipy3RxBPccbhJsi6tzhRFhjHQcMZ7wYM
	YnPisfpeSd9qTxAttUOLEnbO4mjBllczAYAR0NPseZDLDQKFJvsVZZVfoVvYF7cB15zZ3gePHOk
	RC5B6k/cpPMa4k5B1esS7w4dC4lzhRUNZi6Cob7Zh7pdjSWco1CnGV2pZOAdjC6gFAKcDCJZGYp
	/yEFett1Ivh8/XY/wCzlnxudeo3Go3D99x6BYH4SOylCFz9EqbG0l040PamDHlZ3Wjq2sfa1aL+
	dJQ3dZmB2CYb5lpQNzcYkXwbk35p42VWQmjy7fGVTT0Nzwx3S+geoKAR/uUi5D1DnmCUor+b1K4
	mifHOgm82oHilvM0Qyzwalbt7F55MYoAIPj1wfXQKudPNS/SvgyGPH8We2xngdjWC8epj
X-Received: by 2002:a05:600c:8b06:b0:471:803:6a26 with SMTP id 5b1f17b1804b1-47108036a8fmr17471715e9.37.1760550327016;
        Wed, 15 Oct 2025 10:45:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4T5Ap8EXZYWy2qYOfU2rzsWmGCIzeVF/YMfjysrqYbRfdcLKrdF7tD3r5K8P5b79864Vx6Q==
X-Received: by 2002:a05:600c:8b06:b0:471:803:6a26 with SMTP id 5b1f17b1804b1-47108036a8fmr17471545e9.37.1760550326646;
        Wed, 15 Oct 2025 10:45:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fab3703adsm180321265e9.0.2025.10.15.10.45.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 10:45:26 -0700 (PDT)
Message-ID: <2c2a9527-e52b-46db-ac8b-b13f4ba6d0cb@redhat.com>
Date: Wed, 15 Oct 2025 19:45:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: mprotect: avoid unnecessary struct page
 accessing if pte_protnone()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-3-wangkefeng.wang@huawei.com>
 <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <db3fedc0-6ed3-429d-b124-d1e67992d6f8@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1Fec0CNM_4wRvlU5_3th4TCQOQJEjV_ocJsGlVjy8wU_1760550327
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yzzgznysqp1nszph5errbfhxzfgfubxj
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4378F80017
X-HE-Tag: 1760550331-979369
X-HE-Meta: U2FsdGVkX1+nNBADkGUIAwc5qBJTjOdoz28WaeEUXWLmdZWB40SSjCM6Ir15W82O8LuQMo2KCbNhqtSL/E2kjM0QdWYzyXQua6AUMzk3MuFfLwo86W7sRW01drPClam+KbNNF8/RCfh85YQqCO8v4PX9MqEH83XsyDNyxliosmkeL80jU76XA4QkbOLOJW9wD/ESgYwqOTUQPQoCyBZ3cSzqnWjy7a6EEib//uyqF8DOO6wXuDT5BNIENduc01E89s96p2umsWOCsBr0Wz7K7D/5/se3xXMo7toPIEJUbL9eNwf3H2MwAtYVYirD1imh6Heq/0UO/W4JHSGgkmkj+iLce4PGkESyhogaV2+TTD9P9s6ZoNWgVu7o5/spmUwNQoxyZQ1tAozBRIxLZF1/ipLEsjCzRBpWp+j0nV4v786sSZZfGtFUwUuASd+pfcC/m3Er1Sb2ThtS+Td64FFGa4dzHMwAL/qeNjlkcB6YdhoSzeRP+ftXZ1YRNUs/UMiMxoL/hR3b84g8ycx7Oa5QCbFRuJq7VHO+qFIL6EnzBcsAbhCPfOZzqdLGn/zyplJiXxf0yoq5YMK8kNsS/ZczCux9fxxG4dAfOBdKfC5o8xibGcB5IVJSE/d5FgstX3sEJ0joZROJbWhXFWQPjfdWH/wZKl21Ldrkkp/1e4fGlYDwVHylk2kRPEn0TQ5MJd8bfQQ++nVPdhg+6BvU4Cf076TeGLd3ve3nPSSBYWaH6jO3zP6J5X+HENfYt7BpOnJHjFChQZg1m71Suf5iYnT4w/RriZmUQfFf0FjVxRM1M8bxM3cRYxKkk4C9NjMBcceHcLDTKOud+fiF+cSBdkCHd27uY3quOXIsL96Lch/n8th6EPlhvnIKAwl30yVY5O3nw2X2w92b5QAJ9e18JORvlY+Pb5sowKTuhQX5OW1MEARMcgxUQg1mBGwoy/DtejCstpc9QG+/tol3DFshUNW
 U77fIrMA
 fb2Cu3YLs8gD77XueAZ9XCg2f5DzX6qyrmhoqxpDsFyW5a+DUI0Up38Wxe5byYIklg5T72XH71TBwgRsxfk8/BzHJSTG31SvHOTIvHOfQDCB4SNgNSxhenCHqvn4SALQURlbjOqBtfImWx3u726cHazkYe+Kqf8WOgsNANvVqLFEdOZPJG2Q6gFTlaz10nQ7X9oCxoTZP7reGKMVvQseZcjqwcdH5VUBMlWb6t88V9oYj+9kA7Git5CD9l3gXL7hyLW0ql8mzsLrk/SYv6R3gq8j2Io8e1Y24q/WqNDwGG7QTt8l+TAzFCQlNX+wb204a3XtL4FDY/jDO9M2Sdhbi7KFQMMX4Q3M8FRJFzpQsZ2bQUzpmGjM8l2xtuuQPe5Xjqix3lrudxTjsrDsCNayfc9cTlhcq6TZ1zlhwNL9cdV6fplFoax2NvhBmG6NL5589oS9Bu2Wzpz7tlkfD20hJjyUOM3+gC2DCxAXX9u3gn6qh0FTIRCu/pcgipYEMx8MmvnQHqkum4DTFNGOWYj7vqF2aLHyR3nqi3qcurWlI+sOKXLC5HjuTcrMHYEowVGbrxGUR2Os37gNpglha9EZxovXP3jJdhRYPgtB6AwMoxbGOZyYLsQsmyo1bDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 17:43, Lorenzo Stoakes wrote:
> On Wed, Oct 15, 2025 at 08:35:15PM +0800, Kefeng Wang wrote:
>> If the pte_protnone() is true, we could avoid unnecessary struct page
>> accessing and reduce cache footprint when scanning page tables for prot
>> numa, the performance test of pmbench memory accessing benchmark
>> should be benifit, see more commit a818f5363a0e ("autonuma: reduce cache
>> footprint when scanning page tables").
> 
> Hm should benefit? But you've not tested it? Seems like rather than
> guessing you should actually give data. Otherwise I don't know why we're
> referencing a benchmark.

I guess it might be harder to quantify, but theoretically it makes sense 
to me to just skip in any case.

... and it enables patch #3, which is nice :)

-- 
Cheers

David / dhildenb


