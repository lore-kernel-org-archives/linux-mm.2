Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2363CCD1A5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:43:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A12B8E0048; Fri, 24 Oct 2025 03:43:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251888E0042; Fri, 24 Oct 2025 03:43:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1408A8E0048; Fri, 24 Oct 2025 03:43:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 039178E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:43:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BA3313C370
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:43:37 +0000 (UTC)
X-FDA: 84032218074.06.8C29A3B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23096A0006
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:43:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ehCaHizW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761291815; a=rsa-sha256;
	cv=none;
	b=mHM/LyRrnijvi32IlGYmbzYl2xNJ+4fzc3xGeAppCDioAHiwJdaMXZLAafTz6/hfn3WQFW
	m7SL6K1iysoMq6+JBfTCh2RycDy4CQwBBhzZMohTdCGThYQ/KXJ+klEG6chGIKLHZ16/02
	bSOFcA7abpncQkvZLfJkJISVrv+PQ7E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ehCaHizW;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761291815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygtMJr7lCz2zBOJcy/xlUwclo5GLonX1M9l6w+G0o/Y=;
	b=2oHURuIanziYMzhHj/SAQfDnfsbiKrS5VKn6uLH7R3RLtsLkLLqo9Bfz3FRCGCFXn+wd/r
	/Xh1R5ipNlXbuX/Zc+UFMMTt662cH4Yg37i2K+fbdd6kLvqY3Nw0kPkzJrUYMOVAkNl4qO
	J8/2kG389OTl/e6GU1pcEuEaP1s3mjg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761291814;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ygtMJr7lCz2zBOJcy/xlUwclo5GLonX1M9l6w+G0o/Y=;
	b=ehCaHizWPvfx3H6AJRVMo70TmWHQ4TlPs3n5E5tl1J13dpj74W2v1KvgQXFxKoeEvFmRCt
	fWzTWYe6Rd+Tq8c9YWr5wmWGjZ12DvB21Q3nxUXHIQnCK04DXvl1YHh4h55wYJnCJph4KY
	Iobi7DkJUFBofOWgjDD0NwB8obiXT34=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-593-q5iUwkzQMfa_HdMgKkP3LQ-1; Fri, 24 Oct 2025 03:43:29 -0400
X-MC-Unique: q5iUwkzQMfa_HdMgKkP3LQ-1
X-Mimecast-MFC-AGG-ID: q5iUwkzQMfa_HdMgKkP3LQ_1761291808
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-428567f67c5so1083647f8f.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:43:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761291808; x=1761896608;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ygtMJr7lCz2zBOJcy/xlUwclo5GLonX1M9l6w+G0o/Y=;
        b=UTqKUVHclsHAahBFBcnbLuItqKZt/PX8oMX6mOFIN3sf4/l+UZZaNIZVRuVx/F55zt
         K6hP4mcg910QWqSma9+aLr05Z5lsReHYShb/L2I7hpse62OW1jSSRMCMhbvgPt7DzTp5
         frq+ciFxxkWkVPdrJLb3VjV0OZCZqermrFDIIYSoUgAamOSXrnmkdc8KI+Z3CmZZeo91
         frU4txwXwblcM/60qu3Dly5r9vtvqKCKo7VVA29CDYv3Av25hwj5cgBIhF8FHVaSsrgp
         GU/hZkS/YJTY/3760Trxr6Vk0QMJHG/k9kmIv8r8Rclfby88dqZ7fwbPc5Od+KjasWX8
         +myQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMd/WEPWHIC+4cgAL/k0mKsGsldqtXA06BhzFWmMyjnuXcTI1UArU1BN15o8KBK0Q5afuzy/8fCg==@kvack.org
X-Gm-Message-State: AOJu0YzstR4sEJ3e7f3IeFoj7p1Mteajak5pivECpRwnF4K0HihB8oh9
	as66Xtv17bqQ7tEmJUojjcjjKdgZw3SqdHxInhP++3gOqIM/IpBZZtSWL8s9WhUNuWJQwfKKedQ
	dq55foqug6svzF5Wwm94wMuPOPzpzmAyw3StDDkwl2SLDF+kVA2eI
X-Gm-Gg: ASbGncvVcIdUYta+N5O+DczyP5AmiQvUQEyLw3jM2gpWwuz2DdCN/5YEXibTd1uQOpl
	Gs3/UuqIbP8xnyeAo+QDxO1+w00FKUyKwg+dllH7k4Hfieh34oBMnzZpJGaWjGJENcchdtf7SG5
	jpLwEMFxi4kiG9tYdUgiJMfcXJ9fFG4zW304HIOQVOmfljxpXCYhizczlw6ZjoFmTAm+4piKQAz
	6c262ypvRo43Or2cqtTO1PaAKyeoqEXvPEQ8IJpLfIubXsdlfBohog7a4vU48AUUyo3Xd9BVUDZ
	+RMc2BapyakVPO9kZnNNoqgwHARzVbpYLcUk4Dm1epRw50+NWB63WKDRZaqWjZIJ9ctgKRM6M8M
	TiJnbbPTKcSNU3x1Ko33TV80R1/9v+1fffGPHVpdA+24kapX9VVZw8+bmsfuhsJgVhXHggMdLRu
	ht21ql0YbhAJGAzn4HX0vta4QeQM0=
X-Received: by 2002:a05:6000:1445:b0:429:8d0f:e91 with SMTP id ffacd0b85a97d-4298d0f101fmr2145786f8f.3.1761291808125;
        Fri, 24 Oct 2025 00:43:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHuzdzaDgFKtnHrcm/Lod7mOzyuAWHQUr2N7K0uuanDY4JiUSZCT2EploISrXTL5ZI5AMbDFw==
X-Received: by 2002:a05:6000:1445:b0:429:8d0f:e91 with SMTP id ffacd0b85a97d-4298d0f101fmr2145765f8f.3.1761291807710;
        Fri, 24 Oct 2025 00:43:27 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429898adda1sm7943559f8f.29.2025.10.24.00.43.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 00:43:27 -0700 (PDT)
Message-ID: <9c1450ba-ade4-4236-8d3e-c5658a3a26c3@redhat.com>
Date: Fri, 24 Oct 2025 09:43:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC, PATCH 0/2] Large folios vs. SIGBUS semantics
To: Dave Chinner <david@fromorbit.com>, Andreas Dilger <adilger@dilger.ca>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, linux-mm <linux-mm@kvack.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251020163054.1063646-1-kirill@shutemov.name>
 <aPbFgnW1ewPzpBGz@dread.disaster.area>
 <d7s4dpxtfwf2kdp4zd7szy22lxrhdjilxrsrtpm7ckzsnosdmo@bq43jwx7omq3>
 <aPoTw1qaEhU5CYmI@dread.disaster.area>
 <AF891D9F-C006-411C-BC4C-3787622AB189@dilger.ca>
 <aPshzHsqp2Srau5T@dread.disaster.area>
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
In-Reply-To: <aPshzHsqp2Srau5T@dread.disaster.area>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jxWLNWv6p7aCcUod44l0SFchrT8N03a-bvPf6_j8lBs_1761291808
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23096A0006
X-Stat-Signature: h6o6oee1rubze9xo4zjurjsghxcxkioh
X-HE-Tag: 1761291814-164879
X-HE-Meta: U2FsdGVkX1+wDb6usDcEXiCTXdrVWreJtSt3HB+2Te7jcCrUAAhcDVVKXdjvx4hi9AEWklRvCXp2LB7uc0SprD5cmpebzKzs7GX9DjUhVgE3uK3mQB1B5yn6TqqBPwbW7VnsAuYoSFApPzdu5hIj/FPfxz7tNz5TcfopQbVVaUSqairBYAIsr9HTWc07Ml5Xr0SbJyijg2B2ehXcaRfO6nxA+/XQL5OQfIbNqenF4vcgR9eYuV9L06bVo8BYmjjX9Q9HeEP3Em2bSsmT3uKY4q0tQToavI813kCSBo76/HNenWqqDG3npn/joOkQVRAuD/qqwSzz1jRG037dkduOygkElu6qU1FzEGEnb/Zu++zUWJhTiZYIhZC3C+/i73BMaz7ZXb7dnwfaLWYP3mdtp2viD25fThsmi3myuDkSdurNq+BamkjoyUgy8qkjBQBKjQ5/dRgmvxsFCIQ3qc71BWeInwtdAEmZ6bJ1jtslLclf9/P/jW55faapwIXF9nc1WxtmAWr/vi1t5oOXlNWf3VLMtWntcPU3lRL8ABdkuM0QEnTcSfhJo1mljH9+TpUx/oZzTeLCHSZ7o3aNz+11skgZJsBYxEVZGj3BNBZONg62MXvNqX/WeQFtvKVxt8UhvDnFlhgKThqCiIuZgzdeuZcCUK0+b9QnHOE2t4QzvUYSnh1twbKsqGgPOiPt6qyWprpUJGkivjHeUlFMiMtIgyELhWuexFW+tUY28IEEDP/eKKHpFI4K09w1LQRcy1JMUtWB+3gAeEkj3IZJHDWKKdRTnsAngZ6n2Cg6eVGakAKxCnIWhdaTz5abqtLIALrBLjGQDWev5TFj/r664PtiM1qDwVwE1t/2fJT43MCEt01hup2m79dxvsA2tfIMisUme9bzajRGvDbl37I8sX+DUYpmi4scZZcE1QZFPnmAUJwgYudjJiHn4ti1L2p5F/yOS5oboULfFHdRGo4F6wc
 AddJS/AU
 bgygNFjp6dx5Mf/J6RHFRRXytMUMLs7t1L4aktbiPof2S2GdF56qo+FybgaVPBm7zPRg1JUC7oGysV0XrMlb7egBUViNLLOQa00aPdv5WFabzRXGokFx9ybfmq5zuBNaTpXt5h9aphmmmAkXCJt6ppyVfPsseuAal6s2z8nC3zN7HTXsfm9pl/FsXyUPPdg464mPdyw2KN9pfEbAT9dGMHjBOYEm0mYdgLvheZgfYCd0+KjQTbkSOdSwfni8ehNMacWnlz/8rElUkP3SXbmqsi4MdEgasmTmZ8iMM/zUHzotV9RYTDCpdFOulEatpr0Na5ArxdSCNAH7h2RQstfDQVEYAMUUejV72+y4iN3U6Q+CmK2NB9i5uryrEDiO+i1PeJ0JKTHGBt/qlwoZ89/kyHop9bw2YoIdlNYArtuQFFZdOS/ah59rl0LZkUDc3+kfCX1PqILBEojI2CghXfBt1wpcntNSfO2nZ9rQuB6b5tLwAU/3G4qRIuTwn0MgqF1fHpOR0AhJmmHTKpIwzxfQzeWJ2fA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 08:50, Dave Chinner wrote:
> On Thu, Oct 23, 2025 at 09:48:58AM -0600, Andreas Dilger wrote:
>>> On Oct 23, 2025, at 5:38 AM, Dave Chinner <david@fromorbit.com> wrote:
>>> On Tue, Oct 21, 2025 at 07:16:26AM +0100, Kiryl Shutsemau wrote:
>>>> On Tue, Oct 21, 2025 at 10:28:02AM +1100, Dave Chinner wrote:
>>>>> In critical paths like truncate, correctness and safety come first.
>>>>> Performance is only a secondary consideration.  The overlap of
>>>>> mmap() and truncate() is an area where we have had many, many bugs
>>>>> and, at minimum, the current POSIX behaviour largely shields us from
>>>>> serious stale data exposure events when those bugs (inevitably)
>>>>> occur.
>>>>
>>>> How do you prevent writes via GUP racing with truncate()?
>>>>
>>>> Something like this:
>>>>
>>>> 	CPU0				CPU1
>>>> fd = open("file")
>>>> p = mmap(fd)
>>>> whatever_syscall(p)
>>>>   get_user_pages(p, &page)
>>>>   				truncate("file");
>>>>   <write to page>
>>>>   put_page(page);
>>>
>>> Forget about truncate, go look at the comment above
>>> writable_file_mapping_allowed() about using GUP this way.
>>>
>>> i.e. file-backed mmap/GUP is a known broken anti-pattern. We've
>>> spent the past 15+ years telling people that it is unfixably broken
>>> and they will crash their kernel or corrupt there data if they do
>>> this.
>>>
>>> This is not supported functionality because real world production
>>> use ends up exposing problems with sync and background writeback
>>> races, truncate races, fallocate() races, writes into holes, writes
>>> into preallocated regions, writes over shared extents that require
>>> copy-on-write, etc, etc, ad nausiem.
>>>
>>> If anyone is using filebacked mappings like this, then when it
>>> breaks they get to keep all the broken pieces to themselves.
>>
>> Should ftruncate("file") return ETXTBUSY in this case, so that users
>> and applications know this doesn't work/isn't safe?
> 
> No, it is better to block waiting for the GUP to release the
> reference (see below), but the general problem is that we cannot
> reliably discriminate GUP references from other page cache based
> references just by looking at the folio resident in the page cache.

Right. folio_maybe_dma_pinned() can have false positives for small 
folios, but also temporarily for large folios (speculative pins from 
GUP-fast).

In the future it might get more reliable at least for small folios when 
we are able to have a dedicated pincount.

(there is still the issue that some mechanisms that should be using 
pin_user_pages() are still using get_user_pages())

> 
> However, when FSDAX is being used, trucate does, in fact, block
> waiting for GUP references to be release. fsdax does not use page
> references to track in use pages - the filesystem metadata tracks
> allocated and free pages, not the mm/ subsystem. There are no
> page cache references to the pages, because there is no page
> cache. Hence we can use the difference between the map count and the
> reference count to determine if there are any references we cannot
> forcibly unmap (e.g. GUP) just by looking at the backing store folio
> state.

We can do the same for other folios as well. See folio_expected_ref_count().

Unexpected references can be from GUP, lru caches or other temporary 
ones from page migration etc.

As we document for folio_expected_ref_count() it's racy for mapped 
folios, though: "Calling this function on a mapped folio will not result 
in a stable result, because nothing stops additional page table mappings 
from coming (e.g.,fork()) or going (e.g., munmap())."

It only works reliably on unmapped folios when holding the folio lock.


-- 
Cheers

David / dhildenb


