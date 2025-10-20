Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8223CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12E58E000D; Mon, 20 Oct 2025 09:39:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC31D8E0002; Mon, 20 Oct 2025 09:39:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A8D8E000D; Mon, 20 Oct 2025 09:39:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A55568E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:39:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E94B85068
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:39:00 +0000 (UTC)
X-FDA: 84018598440.23.03383A9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9DA0820005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:38:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CavuYdr9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760967537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tC/uGY9VXJ4FPTx9uG4dkHGa568FFAF0oxEiok6Nkw=;
	b=CjTUT/fAzW89Gne3rxD69K0dTWUGr7lNeiqumrjdYJwAvXOe7lTKxRA5wzW3mZRzrOVCMs
	jvA8ABGiEdbjytkC5joLn18mC50/H9+gGdHmbppuQvOCxT59KKk8XsHimnrIXgYJbw3Unu
	kwOe9nMy0TJ+J5OA1mj64R0g7W/ZCvk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CavuYdr9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760967537; a=rsa-sha256;
	cv=none;
	b=Alv8L5l1QBRMTWwbfryM20FuVJAEVbwkutjsWam58W7bZbKWIDfWXehQ6UFGppS/mXKSKk
	PoV9eezbsQhFBOQ9bGStxKjYVMs5RdGzT+Md2czrr2dmKx2Cf0lmg93eWbYUTFjxyqiU4h
	+/8m4ZbbMY8CDp9M0s8ntiF71+w4eu4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760967537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5tC/uGY9VXJ4FPTx9uG4dkHGa568FFAF0oxEiok6Nkw=;
	b=CavuYdr9wKRpWOnttp3+mEQfiQtgoGEC8bHpus/Kkw5AeBSbOAj8cm7dN7SXF7gF1zRNW6
	SA23kPtLPa990LfUNFzi2UgXs7g7+ywcL4zbNb1sZhl0hxgKojWvnDpFjNuliubHGEe4Ya
	v0GFEuiJTNq/qyZvzXiEUrXPkeSXga8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-oOi0HSE0Ot2uvZkvyQENYg-1; Mon, 20 Oct 2025 09:38:55 -0400
X-MC-Unique: oOi0HSE0Ot2uvZkvyQENYg-1
X-Mimecast-MFC-AGG-ID: oOi0HSE0Ot2uvZkvyQENYg_1760967535
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4710c04a403so49535995e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760967534; x=1761572334;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tC/uGY9VXJ4FPTx9uG4dkHGa568FFAF0oxEiok6Nkw=;
        b=fxlReAMK+UdcQLi8wArJBcshv4lwI8RaReNwzkmPe5HWNNcV+mnOKH8C67twLY+8jx
         BTeNDGHMNTtVJ4UfD5ciG/gh74B50QknbC+7sr7fAzWW+g5lVrKZrK9V6tMS+U9ctsHh
         Po0nag6+r7jFclZHnT0Aufll8PxFo7Nk7qnVD195UwLBV5pWp2vz5F6C8Hc3g2gChZkv
         988cgxFLpwC+d7OgyGsIWbUm/XFglgvCVtQRJBv+ZH5jx9VKq8Srf0fvk2umHie04x2T
         +y1Vuww2esTe3VUxj/K5ZttpAOZICNNeGRkm8PFhWhz0Bu+qYa9AmtHBSXk0DN5BF1sK
         Szsw==
X-Forwarded-Encrypted: i=1; AJvYcCWdz/YbcQ3CVdtfx070m1pluzqThISAVTmWAJTrtQFum5J6IEm2hu0/tUDYtDYWuEkxO3fbx1h13Q==@kvack.org
X-Gm-Message-State: AOJu0YywYIp5fgTvYd0fFom8XriSN2/sGTZBc/Hpq3WeOOMkhha4UCm0
	/fdLDqmli5zXzlf/kYVwobmrs5/UPaQmB/sfYJhq1T5Qa+SeINn4L3Eds1XdWXETGtGSdeDb9zr
	69CM+QbzjnCxBXMqEfLZUmE0D0vl7f222LyCyoeVUpakJvvb+k/nx
X-Gm-Gg: ASbGncsGdbmT/M9mOPTpIn4oKSV7X/MMmLWpMvX4roAKiocH6slcHli+OscDk/hicki
	Iu2cv6YNhEWE7p1krLG23muCGjZnmYDS8qKn7emw48DGXzM9n7vcOLCE7Pdqm4PwwTq40YJK/SO
	WJcupmbMtZdpKoCAlEM9I3wtnLC2met36U4duFptgdr8wTmHfGwonDIYCinZKBV5RCT9LfFx+Y3
	Eg8u6ooXueS07RbC8YWVUKUSo7t7mmtMNYXJovMDP4mxLC7WbJ38IMNEcEt+JkSKBTVLBJj7zbt
	jmVO1hg0qqIgxJkVNkiDokHUsakENbgY5pNtBaiPTt0V64aVg//cMiKctxw7oeX6xLC2IL1Fj1w
	1MMqAGd4iumz38uKjuv/z9Rflj6slF7upm3fD3vEzbc4Q/WpyDuQa+do1zWvyl9syI3s6WfWkjU
	kHC0auybviU0wItBnjGcju7GU6huo=
X-Received: by 2002:a05:600c:458b:b0:46e:39da:1195 with SMTP id 5b1f17b1804b1-471178784d9mr98839335e9.3.1760967534589;
        Mon, 20 Oct 2025 06:38:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGepqmkf6jIiTFaPcmnOYY+Gdon85DDAF9CdDj4VMCh5+Pwm1vTVXFcPwvks7Anlx+3zXJPaQ==
X-Received: by 2002:a05:600c:458b:b0:46e:39da:1195 with SMTP id 5b1f17b1804b1-471178784d9mr98839045e9.3.1760967534120;
        Mon, 20 Oct 2025 06:38:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47154d382d8sm148916235e9.12.2025.10.20.06.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:38:53 -0700 (PDT)
Message-ID: <8d25f625-2588-4b56-bd7c-355a2df09442@redhat.com>
Date: Mon, 20 Oct 2025 15:38:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM
 CORE section
To: Harry Yoo <harry.yoo@oracle.com>, SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
References: <20251019072509.9488-2-harry.yoo@oracle.com>
 <20251019220737.1431-1-sj@kernel.org> <aPXoJWM8oC-P1a0q@hyeyoo>
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
In-Reply-To: <aPXoJWM8oC-P1a0q@hyeyoo>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: TujBG3HBt-L9fxVfo3sEJPOhPeXfa3jyD6QT5k5160Q_1760967535
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9DA0820005
X-Rspamd-Server: rspam03
X-Stat-Signature: 5mmodn3r5soq76zxkkcq11hqza1yyjt6
X-HE-Tag: 1760967537-176979
X-HE-Meta: U2FsdGVkX1+aIg4Dp2UCrwrQspaRUqwkDoAh7F6jZeZgTml+n5xGN72KvK3TNxm2UMBiapLXy8yJl7OdPs6N0jwxyNR/Om3drNCgichPw4UjRw8spne2+S/fNNvoNhNCo3Zb4eOxEpEjXptIdcr98bxdoAKbr41tSGsw5NA/T7iArt6Ti+jlWOlsBZY1W7PXgx/m7IXHlYLsbxjKksivwBkLHSixJUXPlCc4mo8px3ghhE1t1orFnS2mNSoSPbyY1i7nd+D02Yh6mE/fDdp7OGSqTp5JNcRmue2Fim5j5fw+xZHLCo4WyWgSGEo8AANnLAPNcYwFuB8ceyxvo3CImuMQuGpYx+wSlujUJ4MKWFSl6vu31LK18hmWRha5mgPbdEwMaSHaZbTbpjeLTHIYxQoTYsFUxrrfA/EZQo/8o1yTOw3FeJ09sfPsg+zr4U0ffXWe873WRpX+m5VzqK4FnWULbUwaUOPHv7Zwx62riKOCGX26heKSUtPknWUE6cPQUNAuC20wje7t3cp6YJfNPFEdMX0vxFOTxCeiLeaFQu7XUuN3KD56ppSXkbe9gZhwkL+ZW/HPgAEMKUCD7BXnCB5Vmd+bzO80/zcS56dT66Ez9wAh2WfHVacjdhRuFSJdrwWnueTMO+UYUwcfv1dFiSjAs4diruDVfh1BDZNY38aZwO6FZSTD21iduJF/nOeqjl05qfD/s8gGLrU/PD7OdMe6P6xhU1JwSsZuNW+XUOQmx/NQ3qIehxSrHv4JFhRC5qS2Wqj4cqDTlmE7Fs46LrCC5pZT4ehpvAf13kkfoaY4R5b1GKI9RpgCDzRARUUckqLCrYgY90pXMwHheas+bKTNLcPWDjVDa4FjV8RFiLBXJX66NOYSYu6zwuAxhTUrH0FmdFqxRBD2ebkmagyvydtd+xlKkUbPk8fDTiLA9EJlAiBymkn16ehn9K0Y0MOIJc5qhwCsVEI3H7gPUyX
 FIf1w5Ht
 HMoWh6YT7hfxRM/ldTGI/qUBjIQ4aEBgr09zDVpBQbnrA+cknPVT8Q9OktX9ZwzO25WfX4lhV7fFPQvA6jEcUX1WUMRu+o9MMzE4nFtURe26OwvaF4VaYdRYwPTSvaMmJEakbGK0I58rQjga21sKAWnuavCB/H2ja03iIowGPdxvEaNugSWPu42t94+eyyIdBhJLQEAmuDoCWajwBtEn3FWyoh2hIjx4PJnLptmXfuy3BtjP4zOs554OL60pGyzXoEZdJeVpDHJhPof2t38HJJdVYzCViScK8T7JRSUWFZ9Pm/1aIULAEMGPUVGg8fYlyfGcmnIpll6NOJnMByOy86BuqOhkGPloTQRqZfrO3O485AzGapfUhF0d8tNnytAqbI0nFgGc0lTRzbYAKn3TYh/LoovHWYOW7BaGY//gx9FPKiisj8oX5DxqHyaD/xH0TnNfKCOa2EBEY886fYVSIxi5jL3bK56I+Sn0cNFt1iZHbjW5dgJ5If51zD275aAAAG1Fn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.10.25 09:43, Harry Yoo wrote:
> On Sun, Oct 19, 2025 at 03:07:36PM -0700, SeongJae Park wrote:
>> On Sun, 19 Oct 2025 16:25:08 +0900 Harry Yoo <harry.yoo@oracle.com> wrote:
>>
>>> Since include/linux/pgtable.h is already listed in the MM CORE section,
>>> add it to the section as well to keep it maintained by the appropriate
>>> maintainers.
>>>
>>> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
>>
>> Acked-by: SeongJae Park <sj@kernel.org>
> 
> Thanks!
> 
>>> ---
>>>   MAINTAINERS | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 46126ce2f968..dedb9525c2bc 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
>>>   F:	include/linux/mmu_notifier.h
>>>   F:	include/linux/pagewalk.h
>>>   F:	include/linux/pgtable.h
>>> +F:	include/linux/pgalloc.h
>>
>> Nit.  Should we alphabetically sort?
> 
> TBH I have no idea.
> 
> I thought only subsystem names should be alphabetically sorted?

I think we usually try to sort alphabetically here.

-- 
Cheers

David / dhildenb


