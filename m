Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF03CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E314D8E0013; Mon, 18 Aug 2025 03:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E092B6B00CB; Mon, 18 Aug 2025 03:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF7868E0013; Mon, 18 Aug 2025 03:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBE6C6B00CA
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:47:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 096DA139052
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:47:07 +0000 (UTC)
X-FDA: 83789097294.09.27D7ADA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B83FC80008
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:47:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GOQGfgl4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANc6RhPEo50rD5jXj4835QWtun/c5zMhU0XzbsSt4/4=;
	b=Wlgx3heH4YGtUJXuP243XKIzLopISbjKspuOgZxYbYaRohadvJO9hsDM3fivj31oXYJZoB
	JmK7OMzHM/Xf78h/WkQsKplwk0mZcsXtDV6wfTVIScEDtND4taybkZXybBJfwsKLJd3aVj
	whWJmXZr9xkx0kVfZZjtRaK78yjcjRc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GOQGfgl4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503224; a=rsa-sha256;
	cv=none;
	b=YF9R1RO1RaWN0/dv0Z3hzh+w8CCD+vbjoVnvL8npLHmBFAwBJgHPKACnTcRGoVLoBNJ+RA
	IpiJROpfcFjuevkkxpXyXnGoaIDbOf8GN8hJpt8Na+hiF1SI5YSzfE9MVERCl13UGAaFe3
	6CqO/+hyB3uri5nJH+P72CNTtCqM4mg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755503224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ANc6RhPEo50rD5jXj4835QWtun/c5zMhU0XzbsSt4/4=;
	b=GOQGfgl4qpkmabc2V+33TnSYZnLBKu+Q46+gMr4T2ILAh6whTu033t3sTDz4Qvxcq3w85o
	54pr4RxyXOp9alFtclQ0ikB2NfsIbdS+WVa+Xp+4rLI2+AdNN4LeXcJRi9RGWYL0TG0oqO
	LsOl8Z5cDOr8UDoYVYJFP7H16OYxoTE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-4db6xomuMsyW5NCLaCvEYA-1; Mon, 18 Aug 2025 03:47:02 -0400
X-MC-Unique: 4db6xomuMsyW5NCLaCvEYA-1
X-Mimecast-MFC-AGG-ID: 4db6xomuMsyW5NCLaCvEYA_1755503222
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso19289705e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 00:47:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755503221; x=1756108021;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ANc6RhPEo50rD5jXj4835QWtun/c5zMhU0XzbsSt4/4=;
        b=D5iMdLjsNERucp8K5mURVvBOIYY6JmYjsys7Gf7ov1Rq5BUkmcn6PJpAtcVuVFWov1
         oXVsxigTjlFiAti+locYjROXm7lkdrBQPlbkLborDW7JYs3atPL5UadQQOzYXWQoYNlU
         1lVb3/weDUTfHreIZOtV0i+yf+Y3pDuNTJTeF8zdQ27DdizBoHBgZeyPO1Sl5VeWqRng
         0PzE0UmyD7znaBttmZKpNZNwg5sm3oD68rrV63MVenCZr61XuEb9NqedWDdNQ1GLXF1t
         h2BM3rU4bNF/mST2SvXJuwmjM4qYOKhqm0KLD18RLbN+Zi8tCMC3JWs1VZheWhTwA96R
         QXrw==
X-Forwarded-Encrypted: i=1; AJvYcCUZHDM+n8SRMPFsVqlGGL7p1NcnpQ+nHiW9uzaeOTF9+fGaVUkBZT23bxi/2v1DdjwOj16TerE9tA==@kvack.org
X-Gm-Message-State: AOJu0YzIng+UHGKhLCVg6IAhAycpD/wOmBwmih7AxZRUB4JRh+blIvRD
	xDhasT0q2bVyM3OQZCvNXFup3NJYEjEMl0epSLm5dj95Rfa0wJNj4SdNPgp9t/p23NAgeUH+JSM
	crPy8WexAlcXRNeVxCc58813Q5CwtvX/RqBKwsCQjjVCf+V2TU854
X-Gm-Gg: ASbGncvjjDlUrywYk+KupJ0sXpRtYyMw1F16ufbl48isO2rJmwTLR17fFfzbYZdjWsx
	G4fZHgXv1NU1UH8Uytb+PEXFm6Io84HMyx98IXi9XMv1/mZ7ec5r8ArYl6H0OmYKNbH3d98iZo5
	8mfeHaTiV+xZNZqEctOe1NrBq4hxxnW/UZq6+VeX5a/3cGPJ28flTAbmiWFC9uABv8m/FywNhys
	WlY7DE7iEStaU0Lv9+ZsyJo80IxdW832grTv+eYScCkU60R8J6bci+DmJ7sCIM4pML7rukBobEj
	a8h1j8BPyelr34/WNpdJh5PmruAlaXL/YxRydUvzf/m2IUIXhxLd8vbOAqjnxHs90cao4NytiJH
	AkuebseRummTlmlTFcl8lv8uzEhLM2OVCWVhGLKbtAkGctPIo4dJYpNBE4NEUOUQt
X-Received: by 2002:a05:600c:19d2:b0:458:bf0a:6061 with SMTP id 5b1f17b1804b1-45a2185d9edmr93404415e9.24.1755503221609;
        Mon, 18 Aug 2025 00:47:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEKPm6IowLUkn7DYPzwgOTcOq2lC8kbIh5Hz5Bf3s8GHVwBYUdG5D9jiFOJIouRSYR7/+vYCA==
X-Received: by 2002:a05:600c:19d2:b0:458:bf0a:6061 with SMTP id 5b1f17b1804b1-45a2185d9edmr93404205e9.24.1755503221196;
        Mon, 18 Aug 2025 00:47:01 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f22:600:53c7:df43:7dc3:ae39? (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6d89b9sm168546025e9.12.2025.08.18.00.47.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 00:47:00 -0700 (PDT)
Message-ID: <fc444f71-849c-48b1-8a1a-9bea6410ca8e@redhat.com>
Date: Mon, 18 Aug 2025 09:46:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH][v2] mm/hugetlb: early exit from
 hugetlb_pages_alloc_boot() when max_huge_pages=0
To: Andrew Morton <akpm@linux-foundation.org>, jane.chu@oracle.com
Cc: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250814102333.4428-1-lirongqing@baidu.com>
 <08cc4405-948a-446e-b198-5745c32f9ee1@oracle.com>
 <20250817195945.a845d2f5c045e4f60b07469f@linux-foundation.org>
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
In-Reply-To: <20250817195945.a845d2f5c045e4f60b07469f@linux-foundation.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M1PlSzGU1poIKWGrXldWP4O_DuHT9iweDh7uuOcoNMA_1755503222
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B83FC80008
X-Stat-Signature: ij3dy77y6t4r5h17c6wh4iiyou86ihfx
X-Rspam-User: 
X-HE-Tag: 1755503224-209614
X-HE-Meta: U2FsdGVkX18Un//lvKKE1tAubJVr9wN7MikVGG9EQLReGE5gbrbI70kaLHY3V9Vas2vWwHcFJSl2eJsRwydOuplM1XL0F7sSzA/zeBLISbKWPAfOB7Yh1CvfqvaOUVCArvXiCJBShQnW8o/DoReH4T+qkk+yvZiXMfGsIb6kl6DU1a3WubT/E+nWb2RxfcsvBBo4liVbyU0+9bBRw3bjI4dDfKirCnL5T0/SU4jw6jLc+uaAQM7teIhgcApTtLFIeU14rLXoyZ4OVUnQPGdphRpuIa24uG4T9p7lOf8aSvLxCUhz/Xk/6LiD5IjEZ+bDFPrYpupLCeVEakLb2n7glWXPt88i4KdLnl6s96LAMuD+lGe1Zhgh2Rh8l7JyiVnBiJays0I0rYCfiziJMDPkG37v66PgrU/pIiyIS3kEvhcJPOEwtK033Oc5bupdEJGMpepKth6JTvZ+ikT+Telh+c4mAmb5CpIjYBy+gBzusSEQ2cwCOatSiJXDrcXkNeRkQRXReFzNPnv8XSxxenTfN7zQh5quVdlH+nY6JgKa8J8v9HUcE6CVXIi+B6wm7f+lFWbzQGrQ7QPJGpbMcJnN1rn+uBQYRBbJplNlTq+z/g7nw6SUTxWl94fFBeWtcExFhRneyWZWzmjpm5gqrhkhjA2+NsJwkfNnmX9wMr3YJ6Q1pdyxlDA1ZIYioY9pR75vUQavFbCNwRbP26XoJ29SdlIWYmVvIDwWVYxNVM/CNK4h2yrie36Jmf8K9IvOWsmHSMRLgnoOpBBWKNbDZvIEKI8XUzmksf2xcrtHlQpvn+IrUHkC2la/KInMIzqEiJNDPMTSXMX7/r6S1SpAo3wViCvjC0wgnyngO4wHfvzNUWIBe93+c6U1B/XufaDFMibrPZwZFu1zGU4HCZwK2BWXBkUkunLqqF/30WYDWswSX53z18AFKgvjzP2mwG4HNPNq5W8BUdmwsrec0sPM9XF
 /cLFVYWN
 wxytAD3tJUtJStxvglF0hJJcP89gkp9S9a7lUs1yd1E37AXCFiX0mnWpEWE8UrUXFYqiWQWWgfODrP1N5pzTaA9C4OUvqGpB+hQZDs+mLMNK3NOzofLPbFy97VSR/OJJtzuPagXovMv+hCVVeC0Fe8rCOabmDAz3PrCrcRteA9rTAUQEUOe2HT3E3HPXPJM7qNH2L7y+Q25xK3NGCHyPRrDAAk2ocZVDh4vJkIAEXi8Nm0bctB6HDLIBetdTF74wDAYACxgVmjeWrGengqcKNA0euPKRSpXZ2oKhslc9YTnTB8EgAFd4Djk62oWe7XkSHnXTLVLm1aWaHBFcIhV6n3WNP2TL0Hrt1qgKWHd+gRhHO86woWwz1yYOEwc3HWF3H9dVA20Be7hknFoxnGlKywl8UafBbjni2rgeqvdpdW3MHxw0BhsaCvPm/9hVyoXzQfQFTrc1SKx9zXLyOZo8n8i4VW7cjo1MAhrw7EBnfkxGMRYNQuzXxYI1t4+cXjq3ba2Qc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.08.25 04:59, Andrew Morton wrote:
> On Sun, 17 Aug 2025 19:21:54 -0700 jane.chu@oracle.com wrote:
> 
>>
>> On 8/14/2025 3:23 AM, lirongqing wrote:
>>> From: Li RongQing <lirongqing@baidu.com>
>>>
>>> Optimize hugetlb_pages_alloc_boot() to return immediately when
>>> max_huge_pages is 0, avoiding unnecessary CPU cycles and the below
>>> log message when hugepages aren't configured in the kernel command
>>> line.
>>> [    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32
>>>
>>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>>> ---
>>> diff with v1: adding the reduced log messages in commit header
>>>
>>>    mm/hugetlb.c | 3 +++
>>>    1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 753f99b..514fab5 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
>>>    		return;
>>>    	}
>>>    
>>> +	if (!h->max_huge_pages)
>>> +		return;
>>> +
>>>    	/* do node specific alloc */
>>>    	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
>>>    		return;
>>
>> Looks good.  Could you add stable: ?

Can you elaborate why you think this is stable material?

> 
> Sure, I did that.

I don't think this is stable material, but for the change itself

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


