Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49D8ACAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 06:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A0F728002D; Thu, 18 Sep 2025 02:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951268E0093; Thu, 18 Sep 2025 02:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8190C28002D; Thu, 18 Sep 2025 02:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF638E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 02:00:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 06F9987528
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:00:20 +0000 (UTC)
X-FDA: 83901321000.17.4A60087
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9C64FA0007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:00:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BzezfuIM;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758175217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Egs9MORsMvaYVbs9QUFPAzXFwITcR+mUkRUBRDXNcgc=;
	b=X1vJBv1+Xt4hwIPsRxVenyhUidxZjgh8BZBoyIEI+h4EfI0pg+ost+2E3eNfNQK3wSkk25
	6zx5TsuzHRNhPqMRHWfdiTi0yx7K0oOM1diIJg4IwnYEKpASz2v6p84DopdmuxpmgGzNsy
	UXb/YCphvLnUhAjw5GA+GehoLAbIVPs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758175217; a=rsa-sha256;
	cv=none;
	b=dIhv1L6J1fHEbZUu0F/jHr87mDF9Ji1soXiUrJ2B/itOYv3k9qR22AxxgQD2aAg9+Xe/QH
	vFx1DTZ+YPimDq0Me5e3qTj4emsCFj26FZdN3B1sUs9R2tAAG+rrwHSLLTNQ1n0mYpgtLR
	rgh5VY8DQnIBzxSXDuniVh+gJ/WfsHY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BzezfuIM;
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758175217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Egs9MORsMvaYVbs9QUFPAzXFwITcR+mUkRUBRDXNcgc=;
	b=BzezfuIMlZa5jjsG+IEiBcPKklsulzAfZTag3xaNSRXIwfiIdphExwGfESypNWtebkww6x
	KFrdyOZNfF/SdD1XIKXCYQPcYNWrwoHz1uJwzthXrzF2wbUb6UNFs+UP+uVVteuCZXEn3p
	Gvu4y0XxIWNIiTuMldy9jaTs7LfQrrE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-CZ3ZqVAEPQi_kLHomfoHnA-1; Thu, 18 Sep 2025 02:00:15 -0400
X-MC-Unique: CZ3ZqVAEPQi_kLHomfoHnA-1
X-Mimecast-MFC-AGG-ID: CZ3ZqVAEPQi_kLHomfoHnA_1758175214
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45dd5c1b67dso2114295e9.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 23:00:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758175214; x=1758780014;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Egs9MORsMvaYVbs9QUFPAzXFwITcR+mUkRUBRDXNcgc=;
        b=WV2XVcCtSsI4WoRUaHR8oaPhD+SnoRj9aj0mP1acV4NNO3o8u+3OlwT98M+rSRakHx
         n/0EaAOwR2QFLlsDDoWHx5BMEPPKmVEmU7DrxhU4P0LxuLKOvhjSLWZZFTd9EYdkmPu7
         dEJR0UIAG3MvwYaQOc7KHnyXImTc5prXfIhs9KdToVm5yo5thHWjoOQx5ut15DJdOSOP
         m6KOPbFFmJU8acAoe79QUbs1T7mGQMCXkuEGe66Jmojb0ysIMDsF5VGJPOqXWPtxJBQT
         YeOdahO9gz+6j7f29EDc7m3RZFoKSgPZDbKDNgsm4oBj5hLB7ry9YJmnr/A7brZb9MsM
         VHmA==
X-Forwarded-Encrypted: i=1; AJvYcCXwrRCDiNAo4GxeoJKSYWwUhnDIYt2wxt4hZghVddMVrvmVWHDhnFekZRCsjtTrTQKQX144X5G1vg==@kvack.org
X-Gm-Message-State: AOJu0YxRTGZNybp/S1Oef5UnogV8pEPpXxZ6sgvLd6KxWAx5vxiJugTk
	gCpL761Ss865Z/CyFcybeKTU7kMhqBbmkNdguSSqPBkDY7Nh4nBIcX2d60MAB09UAW1sF86gumi
	cOZHreRnPdFPK2gUtw789VOq0EbzXLcF/ccJtc75L6tRaLIn2drOm
X-Gm-Gg: ASbGncvXY96v/xN4C0B2uty4LMkO0nLbI/gg2yypW1NSZfoFaIEyf4iP6p+BmnLS4fN
	8indLjOxGsr7DU1Gfx1AOt+FVhQq/C5dLTr4IPijgHOS8o5ZTrQmHIf8tyP4veP0k/4wX6iXkNp
	rY9Il2aeCyI9fLWsYBWjW6fh+wh4s8n5jlE6BuoEkrv5JI/P27cL6uTke7MxKL/JyHKueRIVHA3
	WNF0xEjJK8pxRLj//cfPCrtV6O9lh/b+oDTZO0fH6UbIzq3nQxSJgHjmHMYwwuBO3I69OI0gV+a
	lcD5StthvWKPHKYeSxt/opeIXtFwq9w6R88J/l+WAJZC6nxJcsQUO6w0HVRRPfj/AtVA2t9i7TE
	VacCCqnYzLKTB7dkz1xfYkxwJ/N0urbCTxmcGO61dWY67bne+eByjYzTCTtC0k3X/pmBS
X-Received: by 2002:a05:600c:1d0c:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-46207d632c5mr43159145e9.30.1758175213610;
        Wed, 17 Sep 2025 23:00:13 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHBPDGFO1ZJKbSLPlQU6hrKmvukZl3bWN2+07Z4T7xEVSYJLDlgI5/VEDLbR+swq1LiPRI1Nw==
X-Received: by 2002:a05:600c:1d0c:b0:458:c059:7db1 with SMTP id 5b1f17b1804b1-46207d632c5mr43158595e9.30.1758175212983;
        Wed, 17 Sep 2025 23:00:12 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f07:dd00:ca9c:199e:d2b6:9099? (p200300d82f07dd00ca9c199ed2b69099.dip0.t-ipconnect.de. [2003:d8:2f07:dd00:ca9c:199e:d2b6:9099])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-464eadd7e11sm26175745e9.0.2025.09.17.23.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 23:00:12 -0700 (PDT)
Message-ID: <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
Date: Thu, 18 Sep 2025 08:00:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
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
In-Reply-To: <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QVDhZZcMOF7dcgEIqynYbCw1TDTkj4XFl91DaS-MMdg_1758175214
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9C64FA0007
X-Stat-Signature: ydmqb5g6aaw8ryqekry9xtfbtdwe7fga
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758175217-106746
X-HE-Meta: U2FsdGVkX19QM686g3c+ijLnqltBAggR6esXsAlUhuQj7wGCituZZxfIxkWEW+9PHsy+6ilBmrCo2TVXAYUIAqASkOUfQnK5zl0QqjoZfKl5WkwS8d+Si55VXHdZ9v+ryIUIe7ktLSWxMF7CwYMrHgxuxCJgFp3tKQ0p7TTDhVwBI1IQCg4RO3K/Pxj2q6OYiGd+rYzKMMfAKKL8ZNhqc1JltvAPdtz9akpDC/Bk+lgUsGSN4v8Ji8XqAI03/r/cf8x3U/6eHU672VSqvz+NWCE0j4uEZ3k+CWmQGQZVxnPRzRmsj2nCYC9feAMW2aHYNcDSjDYjhpojCKXtct+3spYM0DzvKJXprXqG6G28vNO4YwgKsIgw9FIVjoHQNP2y/YZti8bLiF/enteAZ2dHROdkgDMN9GxUnbhuufaqyDbYO0d93gQJC0fFHHbBEh5XLiORfIBUSv3JKGihzEbHomgkbkGW9an10cKD9ziBnbvhmnMZSxVGiCAflEuuI6taukjrCnYWsUHTuEnq/2H7n3xEwWDWp6ibwwo+GBfyPJuNzEJl4g2kFV1HYznk4aeNV7CyxOAjHVzHYsCWA2AKyokbT04UhKbsu7OiN1aEhunwUMQkpDOKhNVr+aNT9ccJvN7CV5g6i8Kp/QVk/QA/rsbrjNi/eD3DHF6lDvxPYrGYCmeqZWoptDPryYay4V1GDhK1H/yp/JSX3RhZWCjrDek8cnjOd/HKzk+vpnpi0npW793JLMYRgy5qIe/w3GZjFtpBO1cXQv3GdlGW7oE3ukHxRRfHO+j8+ktQt5rLcCyy/CerFdACwVrsc1qKQpmUKG1wQYSW8c0zW0B8ILIJwm4aQ5bIn1JF5Oqxi3xpQS362mxrSxXIuaKIyrNMwneEe78GmPfC2RZP+411CuUdk8eojX0BnZRUx1lV8m3WjXEgdFwFHkuPZ6qeeyypWTQFZhm/jETIdD6zK7FyuRP
 Q6TmB/RX
 2hq+PdrsV/a4fz02t4Hl9D3mkOM1cdWy7cp4pTOk57C6eMwvG3cU71xS/AhPl5vJYnjg/fzEj3uOapktz456gb2kjfp2T00NIWOUyyP+rRrCMi+I/2lOErU1RWUgXejwfpZSApxaUYTrl0aQ+GWERUvvlrvh4djBbC4c0O+YB/wBhKqto5sokczuNKq8KVCbXo22AgRNLsJrXw26U9Q7h6RwlEuMGyY9J8wKm06yv/Vk9oHPCslxPE/iUCqvJtBSyP15YSXauP2kiHAFiT4o03uXahMwQCxRXYQgJ2XZGQhDhLoOohvbjCaKr2lKu0ZZVy5YaUz+z4T32LbqBZoUFkhZIOu1t1RAkM2vcpUEnrwOXiui3ABH3VCO0Yvi6hb+w9HKqw8vtTUmMS6SxXZlD5kXKY8+mEO17hHV82l3g5yDUCdzhtJBqwdqLpEgDjUP4oflq383yIp/28olKfA++O+xfdGDRX/l0xxewQEb6XpUDgTrYKbwwgZ17mzKKsViYu4Ds
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.09.25 05:46, Baolin Wang wrote:
> The folio_test_private() check in pageout() was introduced by commit
> ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from
> a history tree[1]). As the commit message mentioned, it was to address
> the issue where reiserfs pagecache may be truncated while still pinned.
> To further explain, the truncation removes the page->mapping, but the
> page is still listed in the VM queues because it still has buffers.
> 
> In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
> data=journal") seems to be dealing with a similar issue, where the page
> becomes dirty after truncation, and it provides a very useful call stack:
> truncate_complete_page()
>        cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>        do_invalidatepage()
>          ext3_invalidatepage()
>            journal_invalidatepage()
>              journal_unmap_buffer()
>                __dispose_buffer()
>                  __journal_unfile_buffer()
>                    __journal_temp_unlink_buffer()
>                      mark_buffer_dirty(); // PG_dirty set, incr. dirty pages
> 
> In this commit a2b345642f530, we forcefully clear the page's dirty flag
> during truncation (in truncate_complete_page()).
> 
> Now it seems this was just a peculiar usage specific to reiserfs. Maybe
> reiserfs had some extra refcount on these pages, which caused them to pass
> the is_page_cache_freeable() check. With the fix provided by commit a2b345642f530
> and reiserfs being removed in 2024 by commit fb6f20ecb121 ("reiserfs: The
> last commit"), such a case is unlikely to occur again. So let's remove the
> redundant folio_test_private() checks and related buffer_head release logic,
> and just leave a warning here to catch such a bug.
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/vmscan.c | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index f1fc36729ddd..930add6d90ab 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio, struct address_space *mapping,
>   		return PAGE_KEEP;
>   	if (!mapping) {
>   		/*
> -		 * Some data journaling orphaned folios can have
> -		 * folio->mapping == NULL while being dirty with clean buffers.
> +		 * Is it still possible to have a dirty folio with
> +		 * a NULL mapping? I think not.
>   		 */

I would rephrase slightly (removing the "I think not"):

/*
  * We should no longer have dirty folios with clean buffers and a NULL
  * mapping. However, let's be careful for now.
  */

> -		if (folio_test_private(folio)) {
> -			if (try_to_free_buffers(folio)) {
> -				folio_clear_dirty(folio);
> -				pr_info("%s: orphaned folio\n", __func__);
> -				return PAGE_CLEAN;
> -			}
> -		}
> +		VM_WARN_ON_FOLIO(true, folio);
>   		return PAGE_KEEP;
>   	}
>   


-- 
Cheers

David / dhildenb


