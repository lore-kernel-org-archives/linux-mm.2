Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C3BCA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 18:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DE98E0002; Mon,  8 Sep 2025 14:57:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BEB58E0001; Mon,  8 Sep 2025 14:57:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AD4F8E0002; Mon,  8 Sep 2025 14:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 193A38E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:57:13 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD35E160292
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:57:12 +0000 (UTC)
X-FDA: 83866990704.13.5A14EE8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 58CC7A0012
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 18:57:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UzwEIOs0;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757357830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6vSTNVrcBkqUOtYgT0oDRMWn0UpSBEKrwO/eVE7uvA=;
	b=YbgMCoVh9BvxkntXx+sAflRWbdwHPFbDfNyUZwAeV5SpdV4xqnX5+qegWZRNxVm65y769t
	KEEFK1ZCgi1jLpFR7P8JutIq434OCd3nPU2BT7mLylMBHJz/LfBwSBNZ0k19B/7i3WFFrv
	rZLiyu+SFqBj/IPSSskcKc+UDo7Ql1w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UzwEIOs0;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757357830; a=rsa-sha256;
	cv=none;
	b=4pF2NrcX90XBDFaINtW+KSwgJ27r0HLaHABZkawWSrsXo9q2od+PUC59GbhIZldfC2yVMG
	3GetBAn7TSVUzXQh3U1tFtCGkHKNi9nl6K5aitrOl/2/5xtrTHPUBPXXfhoH+9LKI+vM4M
	3MlDJ6LLtACtOZhx6s4UYhIVnDOH2LQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757357829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=/6vSTNVrcBkqUOtYgT0oDRMWn0UpSBEKrwO/eVE7uvA=;
	b=UzwEIOs0LA0BlQZ/nghjWYkLBbSLtMJUTunOJ4QBtA4yONYHneVODseaIidTkGhEFWCTOl
	qnCUqVeD81TnJ5kVBq2C0Y8qdX8GOJhduBzNpwyd6vZNpuzfg55lcTMMvKsOdA1TkMvZDv
	aDwJcz6cqtPnicJnq/zW7VWh+tDfcAY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-4tMoBRcMNfyAWMnUDqHY5w-1; Mon, 08 Sep 2025 14:57:08 -0400
X-MC-Unique: 4tMoBRcMNfyAWMnUDqHY5w-1
X-Mimecast-MFC-AGG-ID: 4tMoBRcMNfyAWMnUDqHY5w_1757357827
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45dd9a66c3fso6947575e9.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 11:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757357827; x=1757962627;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/6vSTNVrcBkqUOtYgT0oDRMWn0UpSBEKrwO/eVE7uvA=;
        b=V8Vn6lR/3knk6uIqay7l5F1i6d7j+ubOKdwaJ2vnLG1lqu8jtE8rk1JDr7MiDnd1bE
         GwIcL6J+UAW4XBomOMBur7h0Q90snjzMDbzPceln5JdH2Khwhz1vpr2SRXD6omeNwYuW
         Hk+VN7y66DFzCO4O6dk327sWYjlAHMiCMQmcUUJ/BKKe1FdgdhjufSh7Gg+G+dIHezLB
         iMt2RMrck4PnhciDxEi4a4iRlByGGfIr7kS0g/xbPyWyOe7h9CFl8pezxRZqXaP5v6By
         Z4yXNv51A9nHLHpczjf41eb45UpN7eS3Mfmr2emuM/0cteRFckQ75QjzgIhbTF1SdUPq
         y94Q==
X-Gm-Message-State: AOJu0YyEfc43UdE1yzW5arm51omNQDGd2Z4qXxLUA+2AtaKF6FePCq/g
	2hyd1p9ci4IkY7JIu9bf1PB/2kREiDz/uSbG/oyLZa7uQizFhByKQcSmdtbpQc6nukSRmQ3xx2s
	DoGxdeVJm8xVrPUXi0NWL/WAoGVlpQUJva6K0LsVCpromMXGCocpkKtfR0dYM
X-Gm-Gg: ASbGncurNM7Zdc+a8kDf3UkQUXzndA6NULIlr5dXNJIMfuL1m2aQkpTjaQBZGyWVTbc
	ncit+qIDQAp1A/fGUKeHpVwrULAw3o/t7rPYzR4Ywv8ADkTSQ++vq+N97GlSLbdN5e9m3/F0OXH
	NWaSLCvZFQra8Y27Bv1DwSiH2W55Gc0kwziDDfQiz1Fh5vfHRolAFAGK80b086efEAGxrpHrR7v
	ce6LHIXZ73PwM/J9Oq3lMQ8248qjvBmgVTkQhy/P8P2pJ7RuSsQqzxwTNa/rV+ePLASq2IhSV6m
	xZ3+FmWYh5yvvrozng1cLl7LeUnaG0PcGJT2rPy6YDOwSfFmvq2h1+cOnniA8ErN2nmxohQLA1Z
	u4K7DNhVjo8zwv88zyE5glkB14mOt9yw6gI1RXMPrcUvADNgpzz0N+UdhtEHl2aYI
X-Received: by 2002:a05:600c:3b25:b0:45b:9a41:5d58 with SMTP id 5b1f17b1804b1-45dddea60cbmr76990335e9.4.1757357827237;
        Mon, 08 Sep 2025 11:57:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHMJ0GGxwh3oeV2eV70rsaXBo1rPWymSWdTyIC4vUdXPJoOeK1yq5259NgE2CBjzaiZhI4Zpg==
X-Received: by 2002:a05:600c:3b25:b0:45b:9a41:5d58 with SMTP id 5b1f17b1804b1-45dddea60cbmr76990195e9.4.1757357826810;
        Mon, 08 Sep 2025 11:57:06 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd05faa9esm100620145e9.3.2025.09.08.11.57.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 11:57:06 -0700 (PDT)
Message-ID: <8cfd4c47-ada4-482d-a46a-29f7ddbe40b4@redhat.com>
Date: Mon, 8 Sep 2025 20:57:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] ptdesc: Convert __page_flags to pt_flags
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Vishal Moola <vishal.moola@gmail.com>
References: <20250908171104.2409217-1-willy@infradead.org>
 <20250908171104.2409217-2-willy@infradead.org>
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
In-Reply-To: <20250908171104.2409217-2-willy@infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: s9vJH2rBGW4B2yX0rPqtfYwXxMcu4J6oL3ddGXvbsJ4_1757357827
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 58CC7A0012
X-Stat-Signature: tf7gqchbrqxrf5e173hf6gxuwffwfjpu
X-HE-Tag: 1757357830-125594
X-HE-Meta: U2FsdGVkX18eZH9pVfy0m2vLpOnMcVa/QOimr35AI/Z4qEQ1Zx3TqF79hX7AeAl79OmuwdsgK5zXPgzsUZaodWJ7GEDWeTD/jeiikX08jcB3Q9NytBn6C8LnsUt1I92bbiIroBPr1MFCXZq374oXjHY7JfltG6gFcUio8r2Ptwao8Z4+cdn+6n9C1Xv1iqYu7clMFBj6RreyJzz73fKI7p0IJE/oNdOIIoWgMeRazjmQdYNvZE7aHV8KypoiWm7VlOG0tfjh07Kwl2/7nXQIvNCRYTZjvuoChvYanpi9gZctwmvchxKO8T12bowWfw4kYWz3Vir7Eg3GBpoG84Qr0RH/+6m2AEYJRtvMda8RAtbcsaB0a0iYwlzWjx5/QHCsMOpkcY03kGLr817bv0lUxgbSeaKIMX+Tc82CBWHeEq9MBbqDxLSmOYWMHMdiH1zpVofy+DD7NogGVVU811oe4CXsIY0RR5Tesp2QsgOgseD0NEu2nqqejDQcVKTCzhjqZKBPWUPbTnZ8ErwRQIj0sPNu1QsIhsI4RrXFpSG9nVH+41FSuxOU55jlovmwNflE13gJ18UvVQNSXc1KaXFLVSnGG6UV0V/clYwIHp3ahf8ewgqO6uO3n/T/huqdYOfrFB3WfMcjeogddDCwsSCewxd2+bftFAxtziLkZvhE93AQT9h4+AaFBeF7tNHZV6i0Podq5J/EL5dYrbbixxS6OzSPv8Yjt651+Bdah06H2CEBTfmeVmZf+igFo79Ah1vl0bwtLIXn0FLo3exH+KahLytStG5SWVFHJe0+cVHXsxyFyjUSWfcF57Q0X389oEUo/GDvLahElhoDAlLXIYnHBH92rH/liahRVUq19owTsSmnakfovwoYrKW1+CmBt84vS3kj+8ZviTupJgaywzL3xsRdiAyd8T1vLsacrgB7UKdjU8vupxJXqL1CqGKraPqm3mF8Gqiq36iKMNWLSjP
 up6d/spr
 yDSVG1AkD6+7tYHROlv+K0SK710ayM+gcHGEeLTvDMgqQ6cD1CbBgKs5RFXXtRtqt6WHaKG30w4wUrCtnUTKu8FAHbvi45CvUJjszDKfV7rYRwpikJYE7XVB9zLo95YXUqLspDzjdmLLFPIj5n+dWqNOYgAcOPErYANEbowLfhTfgj6CxxELe+fPyP6G+Jx1TB/nzf+ThBrxZ2QxezcRwyZ4JGMwg8pv0zGBBylrIv3LgtNgNkyEWdR0mg32SJMJYeax8GRIHgTSlaCMf/GugenjnWHzEhHJLH5PXsjiGDkX10dngufHZB6NkOam4pg6HVOX5gM8trD/ZCFckG4HRZ5N4AXs8BWLI2mx+90a5FoF1qXvt5qmofNbZBLRxvXLFemHQr54x1sumq1CvN6g9sXW39i5oTXgesRTahD1jJcjGaU7AlUlq9gu9xutzS351N24BgwzJ3zetva1RiVM78dbMkIoTSv2d8AVJLL7rk1OamGKa5IRvZX1gNqlUymJ4WJEoimb5A9TZ2K3xJsWhey7VyqGYGjvasTDtyrvmD7Qh4f4k3UIZHV8NZJtcGLfF7c3J4GlK1VksB+Vidr4T3bZhH6COAS6hFI97OnJdgh6uHi+EsrjIprquhYhz6VWsBXo2BMRwV0x3XQ4BNlA8fUh2lEZv+2Yu7dtaexNzDmukYaU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 19:11, Matthew Wilcox (Oracle) wrote:
> Use the new memdesc_flags_t type to show that these are the same
> bits as page/folio/slab and thesefore have the zone/node/section
> information in them.  Remove a use of ptdesc_folio() by converting
> pagetable_is_reserved() to use test_bit() directly.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


