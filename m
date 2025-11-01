Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EEC8CCF9F0
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 12:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0208E0091; Sat,  1 Nov 2025 08:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0915E8E0068; Sat,  1 Nov 2025 08:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9AC08E0091; Sat,  1 Nov 2025 08:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D29B48E0068
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 08:05:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5AED7C087B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:05:40 +0000 (UTC)
X-FDA: 84061908840.26.018B226
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6353C0009
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 12:05:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R3OomEQS;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761998738;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMG4ZrGhtDivlDXT9Lf+Em5Cw+QAoMNy/XfdlpySJK0=;
	b=z4Ww9vX6OaQWc0vvXYOhc1X6ocQvhoshHIMf3ZgKnmfIusNSt7NQkynI7Znzcfd7rkuEwI
	XPlYiTmPZ9EwVDwHXAMZFD807O7QRA2M+Q2A81yZyLL+m8o7QW/WTk4oggN3AoeLNeRwZF
	yXDjXkOa/VxfWXExTXFWdcCArTfEOro=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R3OomEQS;
	spf=pass (imf10.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761998738; a=rsa-sha256;
	cv=none;
	b=jzClbzeWl2Ob7PKavBXflIClS/rAfeol2ghgYMEljsrdOFCNa4V3Lv/XstChj7coqh5K5W
	QRFoSHakwQMZTCrLdEikO4rixK4hLJm0hCL2Mbm2WtXERqXc8OKJpy0zVeQr1UCWmxeCCM
	PAkh8MwIQwMYgk7g4Jf2lb0wOSqBtD4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761998737;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kMG4ZrGhtDivlDXT9Lf+Em5Cw+QAoMNy/XfdlpySJK0=;
	b=R3OomEQSi205HBBbecAHzGWrPl8pHj/FPmcUyYufGgr0tfQqvRg0tayrkFn8hsG7G5xtUe
	8MmGWoxYvHnpheR8kYRCJITSHsjM14SEDoqgMbxiMWEPJ7EYSyK8KSGa8L/6vSsIbtivos
	XO39WSe8MxutZ+WnhHeGM/9bvCgS/rQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-460-2lKg5mbZOMqDPwy0UrqTDg-1; Sat, 01 Nov 2025 08:05:36 -0400
X-MC-Unique: 2lKg5mbZOMqDPwy0UrqTDg-1
X-Mimecast-MFC-AGG-ID: 2lKg5mbZOMqDPwy0UrqTDg_1761998735
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-476b8c02445so24808925e9.1
        for <linux-mm@kvack.org>; Sat, 01 Nov 2025 05:05:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761998735; x=1762603535;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kMG4ZrGhtDivlDXT9Lf+Em5Cw+QAoMNy/XfdlpySJK0=;
        b=DKMOTRVdeMsVoJMtindSFUIvVP9Km/mNzRlKLuW5zru58AVBPqS6WLx7Q3UcXo+LVO
         ws8E4DNjYpDDHUdTO1dKAC804rk46xhhwKU0KA9GM+DMsjrpCvVEbyr0JsrSIoFzC78d
         YHMGLQ1diaCHt4cW7UOnJ8VA/sGbr/Fd3Oqw3/kbsp88yg0jafKxp+qb3iZ5Ze6K+xTW
         tWgt7YysunDODN3wkTtZOx6f22zLDnSZd+Of1jPe74O3WhvAwHUK9t2/wwGjSYkM0p/S
         4BOIh1iN3S4dft9rChBBafz8YXqXOv0KR0RAiLRmwiR9lYAb2Tl6LOUHaUz8t7doI2HN
         w8UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCN8K3WZKsMZTgTeEqCAPkU9HOMil+uC7oWWMjiWZ3dsBp/gLaEnIWqru10DcboTn9b7A2V8zSKw==@kvack.org
X-Gm-Message-State: AOJu0YxDRSjz9g98bqH+a3/DMvTYHmdWD4rpWgopwf36tCD+8Hl3KFox
	FRjEDtX37pa331MrgDU3Ks2h0bj03ZM8eocdz2BT7PmLABKdG3YwQvPwX+e4SjmHqd/kHRZ+sQj
	O1UleY56U0/S3LtjYo6bUDpP6n0grjDUiku0PsX6OnSJIITqyKB60
X-Gm-Gg: ASbGncvI81W2uw0S2bqxTdZxNspiRZ+tVehuNLtRoLyt5PoR6oEwJKrxvmAv2R3QvmS
	e9Y450XY632kVeQDrYttfPwv7d0EU/Qy5uV0/wVpNzfc1mK6RICl0vcvu/MyME+s3MOtgYfW0fH
	9mJJjP/v0S9n0bOVfuCAaRlX5xVw5fGhM8W0gYeQjnm+3Nrbxq39TikxreDkv9frFfUkKnkFIz2
	7rNm9sclvuQpcNDe6HyMpLoA/pFUhnBc6pTbnmIKcBtm9ukixS4Oh5Ll+SxDrJ+v76q9i699Gp6
	8r55TuQ6NV5F3HMiFRIFtBwob71Gkomj/erlCoZEtEkMD4jj2vvTMYC9CGDOeGqidCnia+TvegM
	OSN9YztX04H82usBmUxHQKg0jrE6knMYimd/kinEa8td/2E8Uw929a/LiyW/qQrCE7JDPpXI4XN
	eqdFIaOMIQrcW3yhir300p1Omht9k=
X-Received: by 2002:a05:600c:3e8f:b0:475:dac3:699f with SMTP id 5b1f17b1804b1-477307c1470mr61733625e9.9.1761998734812;
        Sat, 01 Nov 2025 05:05:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEswSMAFiCrNpu5lyiFxKzugAwsfKeFqrIXw4LJyG0OxPKZu66BGogk4vu+xHj3Hhqm/A5QqQ==
X-Received: by 2002:a05:600c:3e8f:b0:475:dac3:699f with SMTP id 5b1f17b1804b1-477307c1470mr61733085e9.9.1761998734330;
        Sat, 01 Nov 2025 05:05:34 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169? (p200300d82f3f4b00ee138c225cc5d169.dip0.t-ipconnect.de. [2003:d8:2f3f:4b00:ee13:8c22:5cc5:d169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4773c374f84sm45678605e9.0.2025.11.01.05.05.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Nov 2025 05:05:33 -0700 (PDT)
Message-ID: <07861e97-757c-48b2-829c-d1b1b5df81a0@redhat.com>
Date: Sat, 1 Nov 2025 13:05:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/12] powerpc/64s: Do not re-activate batched TLB
 flush
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-2-kevin.brodsky@arm.com>
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
In-Reply-To: <20251029100909.3381140-2-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0umK7p0wREwVkXS5SmLi_-4NhkSUh2HG674g6FR7mqU_1761998735
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9uexfi6sq6syz1k1cn6ikxzmq68u5s8a
X-Rspamd-Queue-Id: D6353C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761998737-453402
X-HE-Meta: U2FsdGVkX18Uf5v1O4wFjerxddFDJOAWgEYrAc+OJtaYF+v6wK59BD0dE7iE62/Yr3mFVqTWgSFH/vn6A7DTX3yM/+OKC2vNGnhbWFpf7jRt4TpJvhaM/5GXZ+qlsZkviYuYoCNKkNytIlNt2tEp/5qYt6ccge/W3HjBjm4K2pebYsaIq7VxmY0SpE/VmflXVpV8AKX1xn5TjJKRzy8Ctrowf5L6y5aOYUy8SAjzyTNzExbC3RYkl6LaBrlIM+PaSYBFNxSgxuVixUiBB/U4vS8yYXlu1tQvv1oXLpCjwcdsZ0sUVtgkQSLyrObzuzf/mmWiFhqv1D7ZigHeiZzb3DXdhU0cRf+oZSE/hFXMuYn+rHHPNoNX4pEqiYACjFxolSs0ORob3hEkrikK83lhPBgj5Zg2CeuNsNPJW3n6ynDXmy/73Kvn5LdsUCez0lkCW3CxwpR5yntHa0jkvIdMHkfVwQ2Q6Qpv2Yfz1j4kBaH37VTd48mxPdx+IKMnNYHCEmC/h7pi5u4ZuWc1RP7VtneWyfANGqnGFdECjK7nH/aJ9iKG8797AcMsf39qu3ks/4ByoWYcq67MB0EbxlAX9p0v+h54cgdP7TsSW8C+UGgRShirqJgmVKglYcQPWmkHBn68c5PiBe0zHbVTlPvxPHnWrlMdc+vCINe6ULGOEi/kKzB+H0BnG9ZD3V5dS4SI03LYSrAuPLmXGdd5DtNYTNY14eOMcyQOZACSYrcla6dVbQ8ksHVEQEbC44IEa83XZfohR9h54ElBguwE+m0Goc6bQreWlef4qVje+6V7c1lG01LpSt9t4AKN4VbqmSFzn48Jm7q7a//atB4vweJuDi3Yn/bpmOgxuvUZEeLzs6bJl6Rfv6P4En8zOI4YKGj5GOEgHnqZsafuzvSlnsSj20YFnY4mnaAbpO960pm45DvuQeNdO+e04QkN8fei1bTstF2ziHdYZpGltkzkW2z
 4LrfUqUp
 Ezf/RjXQnRgKSy7sBp2wWJtrulD+EK46MH4RsyykVUHdhXRsoIrzf1mp+saBUyZQif6APdO4mNOIDsheCOrJvLCYmbjJ1Qc5nBmfNgsi456tRRaBni4CwbGapvwLScziGoncQTrpsnYjf7vfkDdE0ophfX9ylHBlbai7WuzjWDHf33XN9Nkec19AaA8p2s0wd2+jP8xClrAskIfrKo1p8btItfeag11QJw9nAfCHbwQ7OhA2J1rYckK7GUR6AjTGAh4wPicZB8lCdFCoLITbqkkS2ttKlVp5HbI+3yRcFYp7pcZcGwoOUSiJ2BYP3tKnlOGuCFeDgOgid9lk42qJ9lzzyx82bWH84gp1ywJHN7HQbKBLg8b+PXyV3oV9LN0B6bQBS+OLFMRRnnnZr03+B8ezMh8QUThrZQaGUiXIqC3v9ovs6QPOWQw4ua6iEYm9FFCL2tPH8Yud8mtF9H9arccEQZ96bx1TWb9vZAB1nYW9hJOfXjjsJC2/8edW1qOZ1sMRFvuVXZ8ootIZidNi+BAG15yvxTlKsz8NBB0hMSTZl+BI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29.10.25 11:08, Kevin Brodsky wrote:
> From: Alexander Gordeev <agordeev@linux.ibm.com>
> 
> Since commit b9ef323ea168 ("powerpc/64s: Disable preemption in hash
> lazy mmu mode") a task can not be preempted while in lazy MMU mode.
> Therefore, the batch re-activation code is never called, so remove it.
> 
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


