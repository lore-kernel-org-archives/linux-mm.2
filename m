Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EB40CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 14:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDF248E0088; Mon,  3 Nov 2025 09:55:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90408E005A; Mon,  3 Nov 2025 09:55:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5798E0088; Mon,  3 Nov 2025 09:55:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C80E68E005A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:55:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FF9A56F92
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:55:37 +0000 (UTC)
X-FDA: 84069594714.07.717AD2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9E63C180015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:55:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjuerhJK;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762181734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0WzqQO9Zmq134QKu+hSLB1XK53Rv/DCN//Gw8a3WYGs=;
	b=N5kdFWWh8mq5SLomb5J+YsYSWuF8ZX5d93yraTMA3oKOfCGdu6xG70/MTPpFgELSWUuEIz
	NsHY1Ewvud4A5BH+ueG+RPX14nb1IDnyNf581n50FCLfZQ152etMYucLNEPY77VqXoYe1W
	P/XQKF9m3/xW7kCVDnv6MDKvi4XJzKw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VjuerhJK;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762181734; a=rsa-sha256;
	cv=none;
	b=ej4Ierb/zCJbBSenCFHdF5siWUsEPhb57g8xaw5XR8V4lm7GYyWCpVktqgxBNwpDcnrM1W
	VBQLEVmU5rWyK8scpfoLD+/yZDvQ8aDef/BIhKR/AUchcLRTjIgCeWrSFn1aLvbIMyspSq
	QJRrhvPVADgyJ/nQKgqUAHdljDzlKYU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762181734;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=0WzqQO9Zmq134QKu+hSLB1XK53Rv/DCN//Gw8a3WYGs=;
	b=VjuerhJK455B3NDFE+uh7WAofAixdRL/Dcmtri82+q6b15PDIyH1eH7Wz3+3YO1E4utHJi
	TSXONW/FRrHlFzNtQLMs7Bw95FL0Y8wLgdZKo+SoXUa6iVV5h4F40V1Z+IhuhEaesn8c9H
	1x6rfMQTh4HK+Z2zKWGtGTN2EP3QQpY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-93-XXqS0CMZMXCxhYYCIfZ-TQ-1; Mon, 03 Nov 2025 09:55:32 -0500
X-MC-Unique: XXqS0CMZMXCxhYYCIfZ-TQ-1
X-Mimecast-MFC-AGG-ID: XXqS0CMZMXCxhYYCIfZ-TQ_1762181732
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-475db4369b1so33268205e9.3
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 06:55:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762181732; x=1762786532;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0WzqQO9Zmq134QKu+hSLB1XK53Rv/DCN//Gw8a3WYGs=;
        b=PKYKMS89R7RSgAHUk2n0f/JRhsg6kWNYdyjuxOz+7nkjoEj7iGAOvEhH7ePXtmq6tk
         yUxtXkbmvIjUcTBefs6zuk+34WBThv81XCFyQwKIQaiqqsxjyO3DfHBKAv2H58qz8Aip
         jIsjMgr+FjG+ZD19CqfCvte1WWKPgipCR+5GuuX7RMpcfXL+8OvTXVMS0JfLNUzfuOsV
         en3MGJROKFEtPsj2GSMehwQIkgPZLk67g3HeEgHQRKJFdnE6QMHT35Wvi/zhUXHJ9paY
         Tx7WVHlme2Osr9FGy/9EX+Am7+x/YrxtsKUqHDhNd312eWENf/RMgJybKFo/IsnZsSpd
         2gJA==
X-Forwarded-Encrypted: i=1; AJvYcCU6ia4xlTh9JRmY3lKIjS+vF3tXaBRZkXp0ENV7FSM0Bitap8PiPBNEdHapowuvXtel4Nud4LdSZw==@kvack.org
X-Gm-Message-State: AOJu0Yy86OwpaT5ZXzV1TEJmGwovPPqgFH7PqALpQPr/YnCojNGH5UtU
	hZ3JcjgI2Nobuc9YzfM/nEbqmgEW9DdtI9w9oIBz4rSuSbD3PdfqBmTfrrT7B/PvF4gqufw2i4Y
	78WyNlRTEWsCxJEsqbff68m4a7O1FDc+oizghdS+hnpneNNd4RKXebMy8Kh2f
X-Gm-Gg: ASbGncsupLvjvaywxoZGLbiyVCsR+GzZVd5JO9eaOZrqi227R58fsqkL3DOkAxjNGcT
	uPNOT6kx4MIVhhATPC+POIWWFIyhefcqdy+lwhPeeMan7EafQOhlrkFf4Nb1z2s3nHE8/czFeto
	OsVoXC0VTEc20YxESQVocZdVoUAsMAAlLhO8GckYS4qYxVCH+cCb2C8FUUzTsVVKqUcwjJvST3d
	uIW+YV9adFdIlG51bMgyTUKU7nWN0EUqIUKlhG2eNkxUSR4sa0ouPNt9T+oDOK9jIj7NOr7KumI
	nNblqGzgB3eM20ckib/6pE0SS+betcG7ikMJpn/imAz9l0KWbjKSbS0tbO36yRrKTUyCyvG33PD
	Ilsay1qQdCDb1MGMuOup6c+cYj8nfPzrgtWENlqm1H0h9/vN5tbRV2DZtyHn17f5M10lDMbUCLs
	BkTG83oqOjPyFhiR9SmiXAWxzG6AQ=
X-Received: by 2002:a05:600c:5387:b0:46e:1b89:77f1 with SMTP id 5b1f17b1804b1-477307c23d9mr111671705e9.9.1762181731769;
        Mon, 03 Nov 2025 06:55:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFBFFG6Bi883yPPejUUpNWV+chJOJ2lKVCRZ8Gtx4+YPn4iAHTmqsol9jMA9A8ByuofUm5KYg==
X-Received: by 2002:a05:600c:5387:b0:46e:1b89:77f1 with SMTP id 5b1f17b1804b1-477307c23d9mr111671475e9.9.1762181731304;
        Mon, 03 Nov 2025 06:55:31 -0800 (PST)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4772fcf7d07sm89155805e9.9.2025.11.03.06.55.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 06:55:30 -0800 (PST)
Message-ID: <db6d8b2e-6941-4e90-b49d-7a37d4f80959@redhat.com>
Date: Mon, 3 Nov 2025 15:55:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/debug: fix missing space in case statement
To: Zhang Chujun <zhangchujun@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: vbabka@suse.cz, linux-mm@kvack.org
References: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
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
In-Reply-To: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: r0k-7_83N6jZ_cQSa8E-uIy9MmDd45lAPbQ8c4zLcIg_1762181732
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9E63C180015
X-Stat-Signature: qxdtrexuanpupqkadqyfy3edajpmxhw7
X-Rspam-User: 
X-HE-Tag: 1762181734-523258
X-HE-Meta: U2FsdGVkX198uQ4L8Ftn72parMMk7IldZtzB1juf6ZZ/GaELeDKvTSoY4p4iYcEi7EBJ+AU85CmvNswGHSTJEaYU6t5rdw2XhlNi2qg2Fb8JTx3cnt0iIhz6fDnD/HBTh8vDQD0ss2qBQ0qISDQVk5T9I9YM3O3p6xbJGCJisYe4NMvWXbKyL4yyRH6Jr1zMpk4sofwCzuYc4bwsPfD3P/GCKQPEw7VqCRolJP8Z82u5+ep32gqgQPqY7W1vuj+Eh7H/Z+q3C9OZ03VjgglFku/+0O9+eA76I1PBGsf3bTNA9NDgD3a7gg1TeLDDD1uLvC15o4S+8ZzlPZm5L1UFgM0/D9Un0lv6MEpzqfgfLL0eJqwlq4BsNIKEirVqkW7u5bq2XjHQpGp5lruEC9O4r2/WE9NJeukLAyJQ6be7/CPmIuQxLi0R+knFGnrQ6Mldng1Z//gNoacm0hrQVcCo9AaUW0+kjDVtGlMozqNlsXJoZmgXxF3u5gREhf2A1UcaQ6AdC4QchQwLGVQynpE8/XpfWB00bs0WaJ/+5Y13Frc68GydRqpr4x2gqdrKnIdGRmyYuQxQYBNRh1nWEv7ypZm58Uz5xlF+bZKF9CZ11Jd0s8l+o+64fvmLAFttpoI+o+NFhKUpjy053hxH1aTg55HMpFdG7yGYw0QBmtUhm1QXjx2GoHO1hhjD6NwpeY0fJ4TjNEGaqGU7AiA3aLMDMTezyu2BNhCDV6Bb/8ewiy+unhiN3w5r009InCS6Cvy/oPgxTdIYcySds72EC70aKKQLo65NDL6VtONZtYAS0XNE4psbUkdpM4GB4dlv6PQ/EY56la1ivX9vI5HYapctYHQU0exgWXelE2LhKjCcbJ9YlMtw5YuMbrIlYJUircg3LsrWu+PcTg2mTC2Jodde3GMCWz6auCUPyJn5qBfQ3HF6LwcdIeWQoXUseGJ4WCCBu8XcoIf4JO1aj9tMhtW
 z7h6DWwj
 kUD4SCci5KGNSaCi1wQt4Cdrzn9ENnnbuXC1aNsrzIaejmz6yJ953tIa9pqorRTfPuw61dwfWv4qs6VmARNpE6lbCFo64Y5if0uUAmwwHcyfIxqpFgELgStBAy2shPJqIQIVBuklIzWG91fx74zgtn5ChCJdqjhhQar6n8RhQ07htp11nWYbXqzOX10ZbeDEQCaUqZj4o7HosY6KqINMQAXzSg3VF6n4PHvVzg6FzOgmFhdESsnIj7d6CCG3eaiNYXULPXs/sSxgC4tDRzliKv7u0XeD8JfR02tFxr+AOHRpyUr9zwRros09NbFgXbeInsCiVniOS+DnMUpV5P3d2g2/YAneTjvpb99jEbg2+GR+PAqBgAWGa0DG6qbwKyXP96a5nhHP5pOJf2oEpaFdESnuLkH7mQAujl07m+2HysyG0icbJ6tKaOuE2fxMBl7sdmTVMzvH6eHKphGhdrs9MAPqWubHvbKyy+EWp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 07:59, Zhang Chujun wrote:
> In the setup_vm_debug() function, the case statement for 'p' option
> is written as 'case'p':' without a space between 'case' and the
> character constant. While this is syntactically valid C, it violates
> the Linux kernel coding style, which requires a space after 'case'.
> This patch adds the missing space to comply with coding standards.
> 
> Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
> 
> diff --git a/mm/debug.c b/mm/debug.c
> index 64ddb0c4b4be..d860864063be 100644
> --- a/mm/debug.c
> +++ b/mm/debug.c
> @@ -327,7 +327,7 @@ static int __init setup_vm_debug(char *str)
>   
>   	while (*str) {
>   		switch (tolower(*str)) {
> -		case'p':
> +		case 'p':

Acked-by: David Hildenbrand <david@redhat.com>

Surprised that this compiles.

-- 
Cheers

David


