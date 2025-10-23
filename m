Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7B23CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 19:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2750E8E0003; Thu, 23 Oct 2025 15:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2259E8E0002; Thu, 23 Oct 2025 15:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EE348E0003; Thu, 23 Oct 2025 15:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBD858E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 15:53:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 91F19C0A1F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:53:00 +0000 (UTC)
X-FDA: 84030427320.23.3F66CAA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13B37A000C
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 19:52:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OrsR79zP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761249178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lu8DXyr9e+174zCCLKyjaz62dq3PQM0ss4FpqXHktAg=;
	b=UpUWFDSTVdXRLSJKmGDnIcPpLQpNO0rFGbhOgWxStv0fbsKHfaCiod4LDN0w0uZhMe75+j
	B+F32noJ3lGJ+KC5Y6uEQFD8u0hNKJvZX/X0P462H6zhTylaQAeEKWo9TtGBgvE97P40SI
	0UQALoH8GZALCy2GnH3Jtee3kF/iVpY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761249178; a=rsa-sha256;
	cv=none;
	b=eI8J6ILSaZFjx6S3njo0V4QYYWe1RQkypHbuyYGk+xB2Kn/bL69XfzpM0c+wGCCLonbxv4
	eY6DbqFxr8iotjmQYkNkJ/+rz1TLbzabrL0Jutj0fRRHO4R42Gq66eddunqvf+zTmPAwDt
	wA5CseDGQVnXmnVaRA3tv57bKK50OtU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OrsR79zP;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761249177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lu8DXyr9e+174zCCLKyjaz62dq3PQM0ss4FpqXHktAg=;
	b=OrsR79zPxDTTcYjCpvym0L/LCuSjCZ19rXRX5x8xIg/IjiFD0Z+U1rgYVoQ52wuAFh3i5I
	YkUuNoQ6KaveSHE0yExl6xi8FkrL/HMGvz6wRae/OZlTy3CdzMGbVEa5aAh/ukn/KOI3R2
	71Fado/B76mpKrT7Vp34fQ9JgHCU1lQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-164-WZ-yEHAUNtW3_ZCNXR8SrQ-1; Thu, 23 Oct 2025 15:52:56 -0400
X-MC-Unique: WZ-yEHAUNtW3_ZCNXR8SrQ-1
X-Mimecast-MFC-AGG-ID: WZ-yEHAUNtW3_ZCNXR8SrQ_1761249175
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ef9218daf5so556154f8f.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:52:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761249175; x=1761853975;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lu8DXyr9e+174zCCLKyjaz62dq3PQM0ss4FpqXHktAg=;
        b=IUu+iqHwVvQm6FoVJoDHAFpVBZAyuwo6oyTzAZv4/1nhuXpW/6WAazsWQEoWHvASEE
         EJ+jpodHw5kKgAcO3XWPEpX0p1VOJ9fSyFW4ViyrHMwWt6h6m+whYKiYC67VW9l1TZk/
         4yN7B2LlL7AAGR+/OJtAKayghWEWJJlro/BUYMQ/eNZgV7DK9Gau3DUOqu6e80NQDmty
         7zq/9jSoki4zhz6MVjU++8meEAzjYIFOp+8cjclJds09xDzwPQOjtqbOJo/ZMT5udLGf
         iPZzUCxPXeSrtN+XDgZu7fRVyFFJehRbbpRJXvP2LQ5HyBl7fWZLrnBvKjJaUR9vEaMi
         56iw==
X-Forwarded-Encrypted: i=1; AJvYcCUbJu22m4QiWTM9c7fzZPw5GE00Gtr4/+9FX9jzB/DgNfo5/3mam9F61FKVqftIPGY/GesXNqsU4g==@kvack.org
X-Gm-Message-State: AOJu0Yy1chYuyfqoJCcTnlg9Er9K8jkwkEgiG2MlPuLO50ua7ExFgdue
	9JZvRTcbEr5+kLqILKmEfc7zsX9VudBg92HHB+tCmqNm1k56rCLsgkhYvRSbWP+753sF9iRUQf8
	Dd8x4+c/Y269YSEZX1hE/08fGO/5SLhXqg8ghTo43ZvLj6gnwI2Fc
X-Gm-Gg: ASbGncv9RRTTOHvXv5C536/+H//9ADPsSxHWFUzhmAdxIxiVXzQaK1ydFg/XPwk4T9A
	EKk5F7f0/CB9lFw2IvVfHZafNGrVI7yGumS3ZYzM6P0lDCaNgPjFh8o0qMeeVuUhZGcD8vONUIh
	mdbrjMBu13fenkQ49aD0aYd7ZQ0IUA3Z8X/DpHapY0KoksKSfS9dcFtldv1ebBIBbOTDIdYOopz
	nghWuwjS69VkUTR4X0dFx7eRvlQJIkj2eSMzhi0k/heLl3g9ZIux6EWBvCvlhzxw7bvvP58OB4w
	7MPDxMv5lPUhPTE7WbebsNGBXLkA+wDaRxvOS4lEVRBDGguOdRMmK/hKwe2+HLy8VpZef3xz+Uk
	sYaLkTg8O365w03sIjsRS4u81B7hJEaNA/bV6JVKto84tBmnqhohzgS+LfCLKRWO/vO9I7egq4i
	NKjj0vGnhwGGnh1MS+ncTJnjmS/u0=
X-Received: by 2002:a05:6000:2911:b0:3eb:df84:62e with SMTP id ffacd0b85a97d-42704d7e9f9mr18404390f8f.3.1761249174875;
        Thu, 23 Oct 2025 12:52:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7U9VemhLNzul4GpnpOHuDDlV+F0CKxszXYKlJ5dnYJh0XFPFjlnxCdm5Nc2+v3zIM+vRJGA==
X-Received: by 2002:a05:6000:2911:b0:3eb:df84:62e with SMTP id ffacd0b85a97d-42704d7e9f9mr18404377f8f.3.1761249174285;
        Thu, 23 Oct 2025 12:52:54 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429897ff3f5sm5656361f8f.22.2025.10.23.12.52.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 12:52:51 -0700 (PDT)
Message-ID: <73b274b7-f419-4e2e-8620-d557bac30dc2@redhat.com>
Date: Thu, 23 Oct 2025 21:52:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/13] mm: introduce generic lazy_mmu helpers
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
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
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-7-kevin.brodsky@arm.com>
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
In-Reply-To: <20251015082727.2395128-7-kevin.brodsky@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rZBl_VSJgXDLpfzGRh1GmTAjjICAChCNM7bfg8wXuoQ_1761249175
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: d1iuimarai84ut9k36tfrk5odiyhzyqj
X-Rspam-User: 
X-Rspamd-Queue-Id: 13B37A000C
X-HE-Tag: 1761249177-145578
X-HE-Meta: U2FsdGVkX19c7DhUsi38qTZldkICpy1T3SgdRxV+PfyKd6yJ+GcIHRRSpbl+iwl/PYzIzSdZStligUxrelx4mB2xzfxciQabmRg5qROxPJUU5FDvR41QDFMgCCJmyhzi1EHysUGCOFW+dzcnRYoE+wV3G3tWO3xmh++cwEAhKaDcEfux4Xf55WrNmbVpDJWQ6M3llFYh8pfb2CTby33ROihCvy0Kjo2H2QQVjHGJL76m+A2ZhydjGsDjTIpfiUhRn8Pddyi3wOgl0fBINat7gBFJz6LY2TR71dN6MB8/dUoBp+aDOUjtcQ4BomvwyTC0I9pMVgNaLEF/Hfbd/6Nzk2hVAlOzJtEoXM4F2YFx+H4uk694QMiZX6md4liB2oSW/7s5O+A9DQKUwyaypJDb0/opeGaGhAlcX+p4UvvzmMB2sm9lrQLQh+0J6IxXm8TfuvIqiafI2bQVfa+ia4Op8rd0DfATU9QHf+OcJ91t09LjbVS0Piw+qRjATwfvhZ8Tkye5a+PN3Fum+F+WtVHJA79o5E3dS72LaQO4DbORvVsJgngJVr8poaMdo9y/crs1Mfe1hs129F+LlP24XXaGoFkHuBHkq7paNK6jqdt0zAPsyuo1RTbidoHxbmuNZubjeGVCINd10DnpSjHaaUtcQOg0MMTX9EwAXtx3fV6BgWl+IyceyR8gDCoCiPHOCMhe/T0OP+GTLKauTiB2PNN/CvnBb1MVWI/qA+YRJKh2KbRUvmo+nTs0MQBv3vRIMjlFJoFRuIhviRVSvF1Dr8dYT0dorARPjT4KhPekU/TGnIzlc8o9MK18JZe1elMIe6t7/W9Qjv+ZD0Xiig4hb74vzATj0YUbGSH/pFRFKMFGUBbGFNOaoA3fz0btwM/taF210gRVNtPZ1j1cJ4OYTpxtnyCc1I+fjU0N3GZKnuWfseQ06sme2eC0LykzYEP4VtPWRREgp5N8/R9b+f/dFYk
 fHD7UlMd
 1aVd3M2UnwiKHU9Mgd3UjiGnm4ztj/vUdDvs+ssbrLHsM5cdjo05gFTkPTKrOv3QQjOy4oxvS5fH4UPkaqnh1QhP8HQKB1ebshA1Xy9Zi1R5mvARVLktm8TFG/yaanPgSwLH99jva5ojVcNaEOUxNS8UwU/8kEqueSwA4/1CgYNPw2u7Wy/G5Y5QZnXBplyWhFbpGpBt1wRoonKgin40yghd9vL3mS+uNd3tLVfVCPTViJlxLBGFXkaTMR+u3jVanTe+1iad0vpSRHVjQ2M/xmqxdd2mcueadO7oaMlRX9o6m2FpdF4PgwlGteWGK1Di93RuxCkqPc1YZkMxXyng7Adbkzr6jd7GOtf5dxHoGJR7kA9JX+2ZJ3VWv6fPrAlakinHGFmL01ItMLbQ8QEYPT1JzDXsMNTcvnFUOVH2KoD7JcLaUEar7ILlQOEQfMxKmvBztTkKEs9vm3ypOP2uJq45HpPhFDmdwGkX6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15.10.25 10:27, Kevin Brodsky wrote:
> The implementation of the lazy MMU mode is currently entirely
> arch-specific; core code directly calls arch helpers:
> arch_{enter,leave}_lazy_mmu_mode().
> 
> We are about to introduce support for nested lazy MMU sections.
> As things stand we'd have to duplicate that logic in every arch
> implementing lazy_mmu - adding to a fair amount of logic
> already duplicated across lazy_mmu implementations.
> 
> This patch therefore introduces a new generic layer that calls the
> existing arch_* helpers. Two pair of calls are introduced:
> 
> * lazy_mmu_mode_enable() ... lazy_mmu_mode_disable()
>      This is the standard case where the mode is enabled for a given
>      block of code by surrounding it with enable() and disable()
>      calls.
> 
> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>      This is for situations where the mode is temporarily disabled
>      by first calling pause() and then resume() (e.g. to prevent any
>      batching from occurring in a critical section).
> 
> The documentation in <linux/pgtable.h> will be updated in a
> subsequent patch.
> 
> No functional change should be introduced at this stage.
> The implementation of enable()/resume() and disable()/pause() is
> currently identical, but nesting support will change that.
> 
> Most of the call sites have been updated using the following
> Coccinelle script:
> 
> @@
> @@
> {
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_enable();
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_disable();
> ...
> }
> 
> @@
> @@
> {
> ...
> - arch_leave_lazy_mmu_mode();
> + lazy_mmu_mode_pause();
> ...
> - arch_enter_lazy_mmu_mode();
> + lazy_mmu_mode_resume();
> ...
> }
> 
> A couple of cases are noteworthy:
> 
> * madvise_*_pte_range() call arch_leave() in multiple paths, some
>    followed by an immediate exit/rescheduling and some followed by a
>    conditional exit. These functions assume that they are called
>    with lazy MMU disabled and we cannot simply use pause()/resume()
>    to address that. This patch leaves the situation unchanged by
>    calling enable()/disable() in all cases.

I'm confused, the function simply does

(a) enables lazy mmu
(b) does something on the page table
(c) disables lazy mmu
(d) does something expensive (split folio -> take sleepable locks,
     flushes tlb)
(e) go to (a)

Why would we use enable/disable instead?

> 
> * x86/Xen is currently the only case where explicit handling is
>    required for lazy MMU when context-switching. This is purely an
>    implementation detail and using the generic lazy_mmu_mode_*
>    functions would cause trouble when nesting support is introduced,
>    because the generic functions must be called from the current task.
>    For that reason we still use arch_leave() and arch_enter() there.

How does this interact with patch #11?

> 
> Note: x86 calls arch_flush_lazy_mmu_mode() unconditionally in a few
> places, but only defines it if PARAVIRT_XXL is selected, and we are
> removing the fallback in <linux/pgtable.h>. Add a new fallback
> definition to <asm/pgtable.h> to keep things building.

I can see a call in __kernel_map_pages() and 
arch_kmap_local_post_map()/arch_kmap_local_post_unmap().

I guess that is ... harmless/irrelevant in the context of this series?

[...]


-- 
Cheers

David / dhildenb


