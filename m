Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF86CAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 13:09:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 381E28E0010; Mon,  8 Sep 2025 09:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 331F48E000E; Mon,  8 Sep 2025 09:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221178E0010; Mon,  8 Sep 2025 09:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0E1758E000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:09:33 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5E38138B08
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:09:32 +0000 (UTC)
X-FDA: 83866114584.16.1E3F0E7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3D4FDA0016
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 13:09:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gILwwbE3;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757336970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eB7yatq5EqoBSnA27Lv1hI77502SZNq+gzJVQ8jsFR0=;
	b=P86GfaGgN472RGg8m5giHdXMM+Wammdg4K0vuLTzx3ZWMaVe6qMeLgSyq3wFnJB8cp74NJ
	svW2VQ6m6Y5bIas50XTsp0bmmYde0cXpJY3OyAk+OGqSdlCkCSWIpcDR7i4wnCEBjy400y
	OaYXUWyR1coIHR1eWHq9emcCq27fgVY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gILwwbE3;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757336970; a=rsa-sha256;
	cv=none;
	b=8iqae894Tj5galK7eH18+beOD37B/te5DnvADqg/xiW6veSjUnidfzLIseiRZYLM92Fy/C
	jl8EEpQdYLkyl7ZHFSYK7sBhVLsJ3CHsH40RGgwWEED559dCfwL1PaM5UXrqidsjcloFmX
	8fWpN2MtauCFtBcb3Fu87e8twrFI+pA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757336969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eB7yatq5EqoBSnA27Lv1hI77502SZNq+gzJVQ8jsFR0=;
	b=gILwwbE3vcdy8EpcyTeGdnFYXjErP4fOzNk7INBvOABHzOI9vJK58a8JmxKMvfrG3Bh5PK
	qURFqzZnlhz8CFj30MuBDL+AvgjxXhu+QgzLfCQ9FTAli/Fcosq2IKfLw8b331SMNDuVgw
	DBGEcJ/KVv9E6BB/KU4if5yBl5DJ1lk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-orXerZTTOqqPVB1-PwA3EQ-1; Mon, 08 Sep 2025 09:09:28 -0400
X-MC-Unique: orXerZTTOqqPVB1-PwA3EQ-1
X-Mimecast-MFC-AGG-ID: orXerZTTOqqPVB1-PwA3EQ_1757336967
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3e61deaf253so1398442f8f.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 06:09:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757336967; x=1757941767;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eB7yatq5EqoBSnA27Lv1hI77502SZNq+gzJVQ8jsFR0=;
        b=Wfts7QeiGgYWFP4e5AkMsz58sEvXGitDAV08GSNMsbvN7FvHlnQn1Z4rZzSSEPjKNG
         7RzbWm/IywnBq6DaU52N8QV7mK4hh2AP/2BCzhw/VYNqpobXlQPVgl47PtgZ40XVSqJA
         OZJ24GljBchLWvBGOeSkp/whflmJWuvndjSVqm02MhtsX5Ty2zeIuG2liOUX0uM+Nast
         Qr3kTvL5udj9ht8QkLgydyu5MEuUxla881Ng+iMcV06Rzp0OPRzXa2GEx1SIvgXVhSwx
         UpjBlexy6nII3HUWI2xpEt44ACeM0UFSRdknkTait2jv2w0kz0+HeEfKtdnSV7yUSpBN
         +yRw==
X-Forwarded-Encrypted: i=1; AJvYcCUl1UrDmOLIy4d7U0M7bPKimFzWbmSbqrdV7trd1vskkqjhs7QcxJaK9embeCqiUJSStsDiM56QrA==@kvack.org
X-Gm-Message-State: AOJu0YxbwG508VCw4jN+eyzFWyOZ2TIS6ZTY6wQ85QwkBdePB+GMcxTb
	aoJ8LKZTnhJ2L6fVlEUU8UbMwuUFbQ4EkaBFhwiWgp7kR4aGf8jw8OnSbwL+mG3EIpBWE0Ho38R
	Pt7NJ8k4qOm4w13or+sGPcUPu2Ys3xVBhzJzYZMUSRZyPdYw+uwas
X-Gm-Gg: ASbGnctfJvT3zcS/qYwdsV+mu94ukUMy+Lzu3CQvU5/jXngExmj2xRM8gnrA3B7VV1k
	VlINQ7khvVQC5bvbNIRIsacxYOsqvsQas01cUHho84KFmj2rPt4zSXzmJOxlMBk9rNI7Nnd83D6
	gT5hJGz1kX3kFaT/DFnGbqRYlSApL54w2m9+0P3hPPMyyY9d+5dFKZiDMWm8xzkT05ERIsi3hq0
	Ry2GI3U9pIb9U3IjuDck4XPU9y2VgiEG+6M4K47gLt4jECtaHXppcfkcKsIGwb4f9Jc+y3Ml99N
	gJ2cowDwYViC0nrwkv6LICIHmebC51P8dONRavbeLihzEn+inABaq+1jaY+RrwGz4cBxh62NpRk
	Et3wv/7w6KqpNYrqFRzACfhsw460Vl7KFSzt0ehDintLQiq3A4m7NVLZztKtSwKCA
X-Received: by 2002:a5d:5d82:0:b0:3e3:5166:e098 with SMTP id ffacd0b85a97d-3e63736f7e7mr5576550f8f.17.1757336967060;
        Mon, 08 Sep 2025 06:09:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEiYFgngxAXgT4Go5511IJKu0xHmBuhnWeb/Br+tBYfFuPdCYNIOJjBBUAXrdUS1YwoE0FAWA==
X-Received: by 2002:a5d:5d82:0:b0:3e3:5166:e098 with SMTP id ffacd0b85a97d-3e63736f7e7mr5576494f8f.17.1757336966470;
        Mon, 08 Sep 2025 06:09:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34494776sm41332226f8f.61.2025.09.08.06.09.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 06:09:26 -0700 (PDT)
Message-ID: <22a9dd3e-0755-4f7f-a59c-a79a52871f56@redhat.com>
Date: Mon, 8 Sep 2025 15:09:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] selftests/mm: fix va_high_addr_switch.sh failure
 on x86_64
To: Chunyu Hu <chuhu@redhat.com>, akpm@linux-foundation.org,
 shuah@kernel.org, linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com
References: <20250908124740.2946005-1-chuhu@redhat.com>
 <20250908124740.2946005-2-chuhu@redhat.com>
 <20250908124740.2946005-3-chuhu@redhat.com>
 <20250908124740.2946005-4-chuhu@redhat.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZoEEwEIAEQCGwMCF4ACGQEFCwkIBwICIgIG
 FQoJCAsCBBYCAwECHgcWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaJzangUJJlgIpAAKCRBN
 3hD3AP+DWhAxD/9wcL0A+2rtaAmutaKTfxhTP0b4AAp1r/eLxjrbfbCCmh4pqzBhmSX/4z11
 opn2KqcOsueRF1t2ENLOWzQu3Roiny2HOU7DajqB4dm1BVMaXQya5ae2ghzlJN9SIoopTWlR
 0Af3hPj5E2PYvQhlcqeoehKlBo9rROJv/rjmr2x0yOM8qeTroH/ZzNlCtJ56AsE6Tvl+r7cW
 3x7/Jq5WvWeudKrhFh7/yQ7eRvHCjd9bBrZTlgAfiHmX9AnCCPRPpNGNedV9Yty2Jnxhfmbv
 Pw37LA/jef8zlCDyUh2KCU1xVEOWqg15o1RtTyGV1nXV2O/mfuQJud5vIgzBvHhypc3p6VZJ
 lEf8YmT+Ol5P7SfCs5/uGdWUYQEMqOlg6w9R4Pe8d+mk8KGvfE9/zTwGg0nRgKqlQXrWRERv
 cuEwQbridlPAoQHrFWtwpgYMXx2TaZ3sihcIPo9uU5eBs0rf4mOERY75SK+Ekayv2ucTfjxr
 Kf014py2aoRJHuvy85ee/zIyLmve5hngZTTe3Wg3TInT9UTFzTPhItam6dZ1xqdTGHZYGU0O
 otRHcwLGt470grdiob6PfVTXoHlBvkWRadMhSuG4RORCDpq89vu5QralFNIf3EysNohoFy2A
 LYg2/D53xbU/aa4DDzBb5b1Rkg/udO1gZocVQWrDh6I2K3+cCs7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20250908124740.2946005-4-chuhu@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: PtNaTqGHInYh0WBWimlYK17_jc7K5LRxRd-jlpAjDnY_1757336967
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o9jf4kdrw5pdnp41o4ch4d8bbs4q5r48
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D4FDA0016
X-Rspamd-Server: rspam01
X-HE-Tag: 1757336970-554962
X-HE-Meta: U2FsdGVkX1/ovgmaxVMvRljKocVsbo5yN1UIOAFC53OPP61CIWiQdjQqbnVkF/Xc2vVfQw5JdNR+MozSJHk9FAvcvtjZ393d9XSc/35g6ellzaD+C4mZBM7AvG2G1x2sXIaIompA0Mo1vBvKgzaimEWSonQm2Hl11kOLSYKa8dlztufTWXvyXeA5ySc6jq4mt88U4XiH8utkZuw3vRdaCMQqjSlCYycggT8t797mkzqdBEHS2mIHScOpXKAb1rbW6MmMzNLmQ+7YfavSjhuB5NA4U8BTT5hMMeIvf58ibTgAzX/e+1XKwOkxog8Ww0zgwqsEV4upvRtxPf/sBFEjOTQaoguAm5pZ+6wB0jKUHrao6g1fW7BXW5yMFvbveW4dY+I7PI84ma0Ur5gmjDDcr23IPqku6wNTmcXz6RsIui+5V/Eo5rgP4+EeopBVmhZEdjXHF6t/RrM72unw4WpIUdgYRvBdRn5Ek7WuZdDBW8l0sbkt/2zHlGxxwWvvbV92t7Uxd5BPATh8QiioGWUzJpazRCkEzeXGFs+V8h0qbIKsIj16aFy9PWH9biCISIDV3n4DSsmnj88ptqFX70logedtCK9Fiugc0R0XanzH2UfwL2QS7m2pzsh2LxQgHTy3DRWHUNOyFETNfigaF8yRlM4DLBfIXhu2bxhb0qu22lFsWjIfRlJ+UHJfNUhPIloVSS9SsMLP+voCg2DE/XJ1GHZLIoury5jwZh15rJPQOMeWHfFPeN6OzCirZPUOsirHyUs4DShOyz0Czo42veNPHL2bxztoVprGRmD/V0xW1XOyAXapZ6EXQ7UUH6meV/gh9HxEsWJLI5ToYrtjwUJWgdoUndU37rzaHb/Hl+nNEmhaYjs3VuMfGtgW2LXvzW6RZL858/uzPgQ6Cez+43kCpavcSC2yTuIYQiazCf6GhNgwU8jfxDy1BMFRzAknNSVSruuwtxFcPLzoFxszs/0
 dhIAP6Kb
 sgja32bd4wQfnHLGx4PWstU0NXO0qaY8AhLWnAkXPiEFR4BWtV99fk7GbymGunGndkc5SumxxaiDQxNPtpAgdtqDnPzJQCkXZrBoH/i1JnPlQ69D45+Mtzi9aiAavOonSD2w8izb51S2gZKupFi/lF6hgL8CCqZdADlqJuMra8yaYTa3lhOUSUpBdZWosq1DXqBFxwVJ7S7/qZ8pDkO12bpFGD0MeDkhI6NSqdAxf2HfDhnsTbQxbZNZATfyH6VAhu16cNvAMecPe9bpnU0NqouZQKaeBBlFGZX+58WRsg5XU18PwWRI3Q/+4O/MBcUUWHcRyR9d7pAlIaMt1KBIY7uH+pU0G6h7mBrVX8nSLxS61tt3nwiKB35nzbLAqJttnhO6RSmH7Ei86b43qP/BBM65p9w5jFTYJY84UmWY9Bxde93r/YSHMmRBbJAR/E2PzeqKDpPiX4CfFWbN/1LRGcw6Fxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 14:47, Chunyu Hu wrote:
> The test will fail as below on x86_64 with cpu la57 support (will skip if
> no la57 support). Note, the test requries nr_hugepages to be set first.
> 
>    # running bash ./va_high_addr_switch.sh
>    # -------------------------------------
>    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
>    # mmap(addr_switch_hint - pagesize, (2 * pagesize)): 0x7f55b60f9000 - OK
>    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
>    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
>    # mmap(NULL): 0x7f55b60f9000 - OK
>    # mmap(low_addr): 0x40000000 - OK
>    # mmap(high_addr): 0x1000000000000 - OK
>    # mmap(high_addr) again: 0xffff55b6136000 - OK
>    # mmap(high_addr, MAP_FIXED): 0x1000000000000 - OK
>    # mmap(-1): 0xffff55b6134000 - OK
>    # mmap(-1) again: 0xffff55b6132000 - OK
>    # mmap(addr_switch_hint - pagesize, pagesize): 0x7f55b60fa000 - OK
>    # mmap(addr_switch_hint - pagesize, 2 * pagesize): 0x7f55b60f9000 - OK
>    # mmap(addr_switch_hint - pagesize/2 , 2 * pagesize): 0x7f55b60f7000 - OK
>    # mmap(addr_switch_hint, pagesize): 0x800000000000 - OK
>    # mmap(addr_switch_hint, 2 * pagesize, MAP_FIXED): 0x800000000000 - OK
>    # mmap(NULL, MAP_HUGETLB): 0x7f55b5c00000 - OK
>    # mmap(low_addr, MAP_HUGETLB): 0x40000000 - OK
>    # mmap(high_addr, MAP_HUGETLB): 0x1000000000000 - OK
>    # mmap(high_addr, MAP_HUGETLB) again: 0xffff55b5e00000 - OK
>    # mmap(high_addr, MAP_FIXED | MAP_HUGETLB): 0x1000000000000 - OK
>    # mmap(-1, MAP_HUGETLB): 0x7f55b5c00000 - OK
>    # mmap(-1, MAP_HUGETLB) again: 0x7f55b5a00000 - OK
>    # mmap(addr_switch_hint - pagesize, 2*hugepagesize, MAP_HUGETLB): 0x800000000000 - FAILED
>    # mmap(addr_switch_hint , 2*hugepagesize, MAP_FIXED | MAP_HUGETLB): 0x800000000000 - OK
>    # [FAIL]
> 
> addr_switch_hint is defined as DFEFAULT_MAP_WINDOW in the failed test (for
> x86_64, DFEFAULT_MAP_WINDOW is defined as (1UL<<47) - pagesize) in 64 bit.
> 
> Before commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> functions"), for x86_64 hugetlb_get_unmapped_area() is handled in arch code
> arch/x86/mm/hugetlbpage.c and addr is checked with map_address_hint_valid()
> after align with 'addr &= huge_page_mask(h)' which is a round down way, and
> it will fail the check because the addr is within the DEFAULT_MAP_WINDOW but
> (addr + len) is above the DFEFAULT_MAP_WINDOW. So it wil go through the
> hugetlb_get_unmmaped_area_top_down() to find an area within the
> DFEFAULT_MAP_WINDOW.
> 
> After commit cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*}
> functions").  The addr hint for hugetlb_get_unmmaped_area() will be rounded
> up and aligned to hugepage size with ALIGN() for all arches.  And after the
> align, the addr will be above the default MAP_DEFAULT_WINDOW, and the
> map_addresshint_valid() check will pass because both aligned addr (addr0)
> and (addr + len) are above the DEFAULT_MAP_WINDOW, and the aligned hint
> address (0x800000000000) is returned as an suitable gap is found there,
> in arch_get_unmapped_area_topdown().
> 
> To still cover the case that addr is within the DEFAULT_MAP_WINDOW, and
> addr + len is above the DFEFAULT_MAP_WINDOW, make the addr hint one
> hugepage lower, so that after the align it's still within DEFAULT_MAP_WINDOW,
> and the addr + len (2 hugepages) will be above DEFAULT_MAP_WINDOW.
> 
> Fixes: cc92882ee218 ("mm: drop hugetlb_get_unmapped_area{_*} functions")
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
>   tools/testing/selftests/mm/va_high_addr_switch.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/va_high_addr_switch.c b/tools/testing/selftests/mm/va_high_addr_switch.c
> index 896b3f73fc53..bd96dc3b5931 100644
> --- a/tools/testing/selftests/mm/va_high_addr_switch.c
> +++ b/tools/testing/selftests/mm/va_high_addr_switch.c
> @@ -230,10 +230,10 @@ void testcases_init(void)
>   			.msg = "mmap(-1, MAP_HUGETLB) again",
>   		},
>   		{
> -			.addr = (void *)(addr_switch_hint - pagesize),
> +			.addr = (void *)(addr_switch_hint - pagesize - hugepagesize),

Wouldn't it be more deterministic to do the alignment/rounding ourselves?

(void *)(ALIGN_DOWN(addr_switch_hint - pagesize), hugepagesize)

Unfortunately we don't have an ALIGN_DOWN helper available yet.

We could just move the one in pkey-helpers.h into vm_util.h


But now I realize that, likely,

	.addr = (void *)(addr_switch_hint - hugepagesize),

would just work and be aligned?

-- 
Cheers

David / dhildenb


