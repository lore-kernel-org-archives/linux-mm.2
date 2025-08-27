Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA01CA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 12:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 954E98E014B; Wed, 27 Aug 2025 08:37:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9045A8E0147; Wed, 27 Aug 2025 08:37:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CCD18E014B; Wed, 27 Aug 2025 08:37:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6228D8E0147
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 08:37:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 070C01A060D
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:37:42 +0000 (UTC)
X-FDA: 83822488764.04.FB080D5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 850FD40007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 12:37:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvavPMxV;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756298259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BekZV8acLe6XPanRTSGME8kaWo7JU8sPojrFX72nbps=;
	b=NJd1aAD2jTHfeEz6qkUnREncSW4ODUb4yPm1TrkVx1bte0x6EoYLJcJ24RG+CGaDb6/r7B
	HiR6rM8m+ACdzpiZxgLJViF7pSFRjo/xAVHa7hoiK8ZdKy9mobzxVZ5tUGnl8PTzeoTRmi
	8TA7jYj15nzlqI4SulHRXj7ujn1ErYE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JvavPMxV;
	spf=pass (imf01.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756298259; a=rsa-sha256;
	cv=none;
	b=rUABRsqD3eOx2dOgmyQSK+PD0MNr6gv62xCDEWoEHkHrXTiurhMc7RBluMPDoZzxH8eNfD
	vuMLhA6U4hNXd0sMxkShHzmpFlkp7ooATiyyqh+dlwKyIjdX4gvT6mDjRYc/RR3yrY53iw
	sGrS7+/aBYhQbe4xf4pjFr9zNgpJJMM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756298258;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=BekZV8acLe6XPanRTSGME8kaWo7JU8sPojrFX72nbps=;
	b=JvavPMxVOYoFm6LZpCoDnr+8Ae6t3mBLxOksKWbXfMu1uAzZb9IvjKVnG4Ys439N41ZFkl
	Y/7WfQGPyfSvEF7GPT+SI5A8u3ealoNbF4ZUnB1eBqr/EF20pMKKtEFca3tfax++DB0WuZ
	dGwH3J8VNm53EFSKhZZn5egEalePfgY=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-121-9PtWTzVLP7igJZewTuadTA-1; Wed, 27 Aug 2025 08:37:37 -0400
X-MC-Unique: 9PtWTzVLP7igJZewTuadTA-1
X-Mimecast-MFC-AGG-ID: 9PtWTzVLP7igJZewTuadTA_1756298257
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-4b109bccebaso184771731cf.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 05:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756298257; x=1756903057;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BekZV8acLe6XPanRTSGME8kaWo7JU8sPojrFX72nbps=;
        b=fygE9DsonCPxP7ZI8qtRn4SNDH/Thevrux0Kdc4en0FpdZe0pGDlwDJ5HT1BSZfBn2
         3CzHamOnv1HcNBqf/OY216xoNADkJs6Yq/oUTLNh0Ez7tHp4YoREsJrxoR6oLBI6DKSq
         +40XD2PUyDoQlPKQTj+MoSLCrdZb8tqoR3LPtubWmmO7G3V8andls2BNsld2en0RJDYb
         0vXLvQP43k3CrG+ORLJvezcBGUwH1cB05YiOw6yd3bQetHJ4Lnir6cbKdbIWPyOrZ05i
         SmWTzNd9SJw6IRvO2f9dM+GU4xVR/Qm+HLttly3zWizBqjO8eiUhw/PWwje+06DinHTR
         moOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqVENaqgNwImQYB/wwe5nE1fj0SQCDqtVQvV4i4iCouhEqnYYLnIy3UT2m5jKTjj4fxAtSSA1SFg==@kvack.org
X-Gm-Message-State: AOJu0YzAFNdwOj4Diqcii2ql3xLmb8CWz9AmF697HapZKSY3otb3vGJs
	r7o8X/pwdRD5fRdOWuCe9S0wf7fI077U3GtQr52mD3BQvtvnq6Tac9eMACI8pqhgwUA43NuEmDg
	+G6OqRyItZxG8ZltGQ3ZEpUbVOkhudV1c/rGobiCZiFgauxfrun1K
X-Gm-Gg: ASbGncuEk0My+ozSQac/zCos8iGguKUnsZmji9Wz9qmQWU88JbMnRTXdLumV7EoWkDP
	JeTp841FbLqRXZFuu9LRydIWEo5ZTop1UYQASkHepad7O4LMp/ok7Dvc5quEXgrqPIF5BVibtWD
	wwEK9U38sGaz4Pf7e5SKRrh8k1JYuzNr78bZrLSWtcfoBtpHHHvAaQSJ5Lvd7+xt4NS6s0gZxMG
	n4lh5ZGnbDBvatJPl32mfgJCt/nIZxjHRpJhsv7PVH/5geDJ6oxnPBjkOsH2w5BB82rrBMZJxej
	YIPqpKfuI+11+TxcLt6zhYJOVhNEpnDb26fypqcdT2SuD9zSRKvTeBy3GAiPhA==
X-Received: by 2002:a05:622a:4d4b:b0:4b2:8ac4:ef5c with SMTP id d75a77b69052e-4b2aab54f8dmr255688511cf.83.1756298256740;
        Wed, 27 Aug 2025 05:37:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGCaRz0DFPdm+ggNf6XYwNumadLV8B3S6sxDmsY6ms9bErbv7MeZlbQ0d8SlCK29jOlIm7Qw==
X-Received: by 2002:a05:622a:4d4b:b0:4b2:8ac4:ef5c with SMTP id d75a77b69052e-4b2aab54f8dmr255688031cf.83.1756298256148;
        Wed, 27 Aug 2025 05:37:36 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b2b8de8061sm91568041cf.32.2025.08.27.05.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Aug 2025 05:37:35 -0700 (PDT)
Message-ID: <b276a150-92f3-408c-b146-7408b68ec778@redhat.com>
Date: Wed, 27 Aug 2025 14:37:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
To: "Li,Rongqing" <lirongqing@baidu.com>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "osalvador@suse.de" <osalvador@suse.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "giorgitchankvetadze1997@gmail.com" <giorgitchankvetadze1997@gmail.com>
Cc: "Xu,Wenjie(ACG CCN)" <xuwenjie04@baidu.com>
References: <73da268715754133b787f22e016a903c@baidu.com>
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
In-Reply-To: <73da268715754133b787f22e016a903c@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: fi_72n5Elhim9s6zkqWmUSHmRmP6ju2M8wayxcHfegQ_1756298257
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 850FD40007
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d85g5t8i7rchttq7adm5eb4ji8onmyyd
X-HE-Tag: 1756298259-287195
X-HE-Meta: U2FsdGVkX19gbxdPCC+XHxbKMCF5LDVok/6JMCwBeYCfWeNd+iRQesNX9ouh5XY329aof7eLx8xwu6pBi5seagW9JVR1fDru0YZ6yDQ6dxkfRT94Y8FDIHcXEaH5qIY8PhtzeUK//JPSX6qRZY1YviOk1RhKg6d0S0W5MCG0O/gNIc90U6ue0hFevIVw+W3S7q7OieFBTdCYTKcpM9UN5VcZnJt+VjD2trSnhMs4GDaVCmQzq/6WqaHy5MKp7YiQbOYbch4+vulb9eq0pn39Ac98JvB359qG2SHrAmqycY4ruf5VoQfqO8Fv7GBLkXrpGfm2fEQimLPZqv7vfnnKI6QVn2yoPRv9bhro/XjCdL9G8348GDGY9GLI5AWdEdX9ocZItmPqg3q/JpU3lwGflsigAbEPiw9W4yL/SZGqwy2xWM7893WSY+Eh6kU3BntsS8h7h7d2JcctgHqI7Q2jAesxxMYTCZdLQ22I5zxGlRJ6FeFjYxbNAWtmOWVlPR26zUDj88x3hwznUidYyjb2M/ElZMPvHT4oJAc+/TKO8i9k40Gg1g5pt28rLvbThgHUZAHkdJPjTmFLJgHvnU21gUHuJ1Nw/KbDJmqBmuMt3mj+/cWCUaA7jTH8cECUnpBIQBG8bk10pPZVdfZ0PGo3UyUYdfKvc19T8M7M/As/Q7k6r9Knbw4eC7+TsVdHA7zU08j79TQgDk2GHqJJ38bm45t6RFiZNEpZ6OPV6G8MISVt8Yde7qLh0zak2yzI/gxoZxfTzqpRgpT5VWFjD6Leb4OA9HT3mMSska4KEh4SjxlxSlVAOhty2kfozfzif1Urvf9CjuKaSVAMhwdY7o/ejae6GxTYJ2tvk0A0Llv/vCgbGgihL+mm6JWs5yLRsOcuWaQXuaKrLPx+HyxBemfBY8IJlL/s0ywZdNdIEX34EVQ0XSiguxjzbG54HK5qXCaaAHWLAQaLYn523jIjyoi
 MyZGrq3D
 0yBzi05aPm6Lq6GLfHWescFbNHjllTq7wBmFaLNeDwfCwjVPuHVEIgkHlzIVKsRS1S44D2yhWu6CT5VzpZ68uMJdo6svEW2t5ZeWRApPiAUohpEefrOeWktjrV2rN1wDL8O8NK/XDH2yXG90kVJ6rUuLwIg39krTzVBXQ53jnQR6NFJcTEXsZcMORs67P5F50oZeGISqZ8kqlwbGr4dayoRFiTcLd3uz5PKYbHzsFQlT9A3OKwEbftJ75ytTm7ujWDuFkC7DwQj27JeUAGmqbrByKa+T/3kWNgmME7M8LpFC5zWX64vO8UJCO0RKqOXYRMDpwB1RMeKqk7NrE95mVvMecpeDaQYMXUzGeLkagYy3OeZDc95ECPtCHx+KNtVA5TSKTEuKdUbQaAvBxZ4qhdZffY8wn1i1SvkIFM4I7F0xV9QP/iEtjLhEgoLMrpL1LT4uKRAVBQ5xRqA4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 27.08.25 14:33, Li,Rongqing wrote:
>> Not sure if something like the following could fly:
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c index
>> 1f42186a85ea4..dfb4d717b8a02 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3595,8 +3595,6 @@ static unsigned long __init
>> hugetlb_pages_alloc_boot(struct hstate *h)
>>           unsigned long jiffies_end;
>>
>>           job.thread_fn   = hugetlb_pages_alloc_boot_node;
>> -       job.start       = 0;
>> -       job.size        = h->max_huge_pages;
>>
>>           /*
>>            * job.max_threads is 25% of the available cpu threads by default.
>> @@ -3620,10 +3618,24 @@ static unsigned long __init
>> hugetlb_pages_alloc_boot(struct hstate *h)
>>           }
>>
>>           job.max_threads = hugepage_allocation_threads;
>> -       job.min_chunk   = h->max_huge_pages /
>> hugepage_allocation_threads;
>>
>>           jiffies_start = jiffies;
>> -       padata_do_multithreaded(&job);
>> +       /* TODO: comment why we retry and how it interacts with
>> vmemmap op. */
>> +       while (h->nr_huge_pages != h->max_huge_pages) {
>> +               unsigned long remaining = h->max_huge_pages -
>> + h->nr_huge_pages;
>> +
>> +               job.start       = h->nr_huge_pages;
>> +               job.size        = remaining;
>> +               job.min_chunk   = remaining /
>> hugepage_allocation_threads;
>> +               padata_do_multithreaded(&job);
>> +
>> +               if (hugetlb_vmemmap_optimizable(h))
>> +                       break;
> 
> It should be:
>             if (!hugetlb_vmemmap_optimizable(h))
>                       break;

Very right.

-- 
Cheers

David / dhildenb


