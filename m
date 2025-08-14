Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46FF3CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7A3690014D; Thu, 14 Aug 2025 07:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2AAE900023; Thu, 14 Aug 2025 07:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF32490014D; Thu, 14 Aug 2025 07:58:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98C65900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:58:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E957BA593
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:58:42 +0000 (UTC)
X-FDA: 83775216084.23.B01E028
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2C3B1C0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:58:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3jBrJfW;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755172720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S6CyIrjf4YqqLJY+4s0Qd98scsynUA9nztAJPe+a9Rs=;
	b=y7BOgAimeSSBuVn6Eh6+xcdb5pBjxxA4n7YqmglMR6uX8pU5p1jvSTJkQlKnY1z7BddMV2
	p3yO+dkUsMnHBBhizRpMVYJpftb6l6kouelghRK4isl+ZaGgjeQMAC+rp5gXmTiRAH6+VT
	V8ZKEv66AJIQEuYrS7ZpD0B/sCbbzxM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=W3jBrJfW;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755172720; a=rsa-sha256;
	cv=none;
	b=4ZkqPNAXxYmFNvW6MLHt62dMsRFAavm2VBIgpEkYkmajz0hwTrVtTXR17hmFH4LLZ2BN7t
	Haiwu59kisyYJDXKBaYUEmEoVVwKqFZpTQ2v/K/RO7jd0bOrpJuOCxqm22eyPpL+qWrngB
	aF+eWOr+PAU43GBvanoE/Gu+BcMfeXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755172719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=S6CyIrjf4YqqLJY+4s0Qd98scsynUA9nztAJPe+a9Rs=;
	b=W3jBrJfWJ7NShYhtnfNVDciiCI9dOcmKMVCEHqV0LFn/vZ0XqobXa1jYKsvF0MsuuerGa1
	7Ix5JnSeLmIk4hvk6bPsTHOgdslaAWaZC8xlNNtvIbLJb6MxMpG6KZunNZ/igalO9L9nyZ
	zuynjxmbdO+UlMhOxAogbFUDzkDz210=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-p7uRT45oPFuNXBxzLqU1yQ-1; Thu, 14 Aug 2025 07:58:38 -0400
X-MC-Unique: p7uRT45oPFuNXBxzLqU1yQ-1
X-Mimecast-MFC-AGG-ID: p7uRT45oPFuNXBxzLqU1yQ_1755172717
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0cb0aaso4262185e9.3
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:58:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755172717; x=1755777517;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S6CyIrjf4YqqLJY+4s0Qd98scsynUA9nztAJPe+a9Rs=;
        b=LbkKU8Lt7ljTtSdQxttMVAQr4bkYwD4o6VseiRyAMtW4j+s2MMmoFD/I1VdiEy9ZI7
         7Yy3F5cK7IDtgu9co9Ju3HJ5TRmbo2lpfZRaozeE6cxWQH7h6DjQndhBy0WOxeCX5UYb
         P+bscaspi1f1jX56LKqUsfYdXArehRt97ofUK2Nf3RYakzjpgN+hKETHJqLfaQHnSp67
         KJzwXucKgaadZ2YgcpDJLYHZNIf1cLtzp47ct3S/Q7ospQqZ8tDOdnM3NBDRDDrD1rmC
         CTr/jFmP7+Oyaj1zbxmfMJHgSyztmWTpxC9dJpy5jRRBwhWe0M3LlFny42e3BHpn/FPi
         8JtQ==
X-Gm-Message-State: AOJu0YyvBTodnZOskO69zUbxWRC03dkx1r1ghVWMTiXJFusuBDpPG1cE
	Kcfr0uson+KKIiobt3B1sWkyGw2CC6mpl4tFiSVYwzIPPRIuJUE77yN8l+16bNVSg17tet4klJ/
	UgPMP5f9iv9OFbrWyhMpVA8EtepNZ3Qhszon+88nJ9OqZhR7Hla+j
X-Gm-Gg: ASbGnctq0oy17UA9854Yyaa+ouFgGbKBOPmLxQnEY1RhPLBK2tPlQia0rfHNRmnYEm2
	f8Yb2aqJU7ZlyqmW0hxlSWuo+Tfpf0GVziGikULXcljw/mYg55ieGjjhlPFwl2K8K7fWsPTbSmC
	vuqPfanVsUB7vdR8xQBN3IP3VrKjlm39zEbEcK9bV+GeHLvlva2dgSshuSWZ/VGB4RsSIWcH7H4
	Z7KpTmeBnjUUPoOC2sJ1Qiea/rDn65sTept1qM8CptAnnW+fBn3/B3qTOOZS8NyVW7HM978oYtN
	2xpPyjR0rbeEyGDczqs6/oVMfPx4le+tnPT7nb90LDwWAPGT80bzlHPuxjzD6M7xBp1zwMTrrAA
	fVUUbMbtewkhELsI9EjBueLX9SZ+2lBSNJEJVVu1dmwX+0SIFHsf+nVyuBcKLkX0xccg=
X-Received: by 2002:a05:600c:8707:b0:459:d709:e5d4 with SMTP id 5b1f17b1804b1-45a1b7f97e4mr25823845e9.0.1755172716741;
        Thu, 14 Aug 2025 04:58:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHnTJ7OQUUPJMLaKm4e5+nylDrhBVz+H3qBHTUN1WjfjmjXZMLcTEV56/pD5bx4GRIA+CWe7g==
X-Received: by 2002:a05:600c:8707:b0:459:d709:e5d4 with SMTP id 5b1f17b1804b1-45a1b7f97e4mr25823375e9.0.1755172716300;
        Thu, 14 Aug 2025 04:58:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f44:3e00:9fca:7d89:a265:56f3? (p200300d82f443e009fca7d89a26556f3.dip0.t-ipconnect.de. [2003:d8:2f44:3e00:9fca:7d89:a265:56f3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1c6be10esm19816845e9.3.2025.08.14.04.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Aug 2025 04:58:35 -0700 (PDT)
Message-ID: <226e21a5-8a8e-43a0-bf5f-12a761f49a27@redhat.com>
Date: Thu, 14 Aug 2025 13:58:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/7] mm: memory: add mTHP support for wp
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, glider@google.com, elver@google.com,
 dvyukov@google.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, shuah@kernel.org,
 richardcochran@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.or
References: <20250814113813.4533-1-vernon2gm@gmail.com>
 <20250814113813.4533-7-vernon2gm@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250814113813.4533-7-vernon2gm@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jUzTD86VlBNJsteH6vLl6mk3cHMi_oLYIC2d2qWOygo_1755172717
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F2C3B1C0002
X-Rspam-User: 
X-Stat-Signature: o8rqbnkmpzzdf736fis6zd8qkc3r55fe
X-Rspamd-Server: rspam09
X-HE-Tag: 1755172719-925815
X-HE-Meta: U2FsdGVkX1+GhJhDUOFEMyJbY/A+qPJSGEG2ar/YFjmcYbB9BQdSTRNHiR51khkRq3vpEACH8wueZ0rHhmxtUUkkRsPXyMSBVFQ+a3eBUCxe/95KiqFyPoultz4bVO65VN7qfcLWJWKG1GyEfgT2PIyNWy1CGwVQjsNVG44CP5KHpNRzEwt/EoZArhErC6+ax8pjUiIw8w1wCcuPOoV6FN0cKSvn4/a56zvq0906e3mCshhrqdp4YVyiRt5d4oRsFvxJ/ltazkl7vFqBsBsGFOh127aZBYHb+gpidWHpV1PsyAg+M9DlcJR5xTmvBInLxBnTHe3dmkEXcEvOStemctUjYZoKBfwdHSfrQLQW9SgOj2SoDRHVIYxKI3MnsH/txTRkZUKApIsdrrqCKPtRgsZF52KugKil3QJRaVLX8WES5sHocqm6phJEemK20Qg6v3ODXrL7xwVWQg4WGw2JQX9SSzGlDYvB/0rREuaZv4MwGNBtKCTgUkoV7zrKmlbzT38mR0qZ8ekdAIsIoRAchDuWfmDhK4xJr4O8Cf4th6qZaXpj/mlPC9VR3TfAnytk6nXP7fwG3XwhWIDk9tUBo/EP4L/2DZR7ie4M+JcseQsMGGdWxNP7OQbP/vhBYzSIalEX0KRV7H3AhI7l+3Vr9aO2MaFk2Dq3iqIcUhsQx9E6tGIM1rGPOy7ZtNtYQLd5Cpv1e7dDrFymWMwT0u603R4lKerUdmxfPQ+ZRKKfGFWeDLvE1up+bZVoukCEW0dku9z9vWLNDEd+TpAA9L6FvN9h353pF0Td1bEwSV11oOpT7hh/Lr8F1BJqITQuZIuJd+hpk3EdJ40sodtyti2sdbkCOO96bRzkSmkv1sXqD9rhThZK9smyeJUbbqTGrgLbfdW5HS3IrDVvJGEwpi3mqdNjIY50O76lkOfnGx3gEVmfiv/ziFq9cZ8XF7d0jpt1QHD1CI9qnHkVmbUwHyr
 5AIx5kdP
 KbDqGTl07+n0BICo/FzXNtDbD1k95pjAi0JhPtZPnCvKO8F8Rfppx0qP9/jZIy1ud/gzlZlJNzbSonjWdC/ugL0ozSSqGIZcSI1vlMW9dim8cB1wsV6n5EV72gd6OraEgOGs3PGjE4gM3j4aHnwBH9//zYLHriLwjyQ+myPfI8CpkFpRhMuLmwiqTBMDCEkfR5OnJSfXV6nPI2tYUo4H2qp8glrbWFDZTaqXgcnIHl0nQRJnKIIFOLpbLd6Tnly1g4fpJd0/p3f4n37Tl6/2zMw3rs9KEQV9lgyhRmby4HLH5pH6JJP94pRfJMXBUUSfo08QA4RbPOPs7Ml/NOQHIf/R29j1sPpB1Qt9LsWCZA/hvgIw102dGVLynidUI6eWiibAsHgh2dc9X6oLnTh/e+OznPpSgP/yynWWUTijBXhmF4Rj0d26sf+kKxcmE+nMfZa5r7R4Hu2GKRDJkGWHYJPVaQWLvcb5GxnL1WgtCdNKkzQgfS8HYZHIOiwvkk1JYxts8PwW+NDoi8Co=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.08.25 13:38, Vernon Yang wrote:
> Currently pagefaults on anonymous pages support mthp, and hardware
> features (such as arm64 contpte) can be used to store multiple ptes in
> one TLB entry, reducing the probability of TLB misses. However, when the
> process is forked and the cow is triggered again, the above optimization
> effect is lost, and only 4KB is requested once at a time.
> 
> Therefore, make pagefault write-protect copy support mthp to maintain the
> optimization effect of TLB and improve the efficiency of cow pagefault.
> 
> vm-scalability usemem shows a great improvement,
> test using: usemem -n 32 --prealloc --prefault 249062617
> (result unit is KB/s, bigger is better)
> 
> |    size     | w/o patch | w/ patch  |  delta  |
> |-------------|-----------|-----------|---------|
> | baseline 4K | 723041.63 | 717643.21 | -0.75%  |
> | mthp 16K    | 732871.14 | 799513.18 | +9.09%  |
> | mthp 32K    | 746060.91 | 836261.83 | +12.09% |
> | mthp 64K    | 747333.18 | 855570.43 | +14.48% |

You're missing two of the most important metrics: COW latency and memory 
waste.

Just imagine what happens if you have PMD-sized THP.

I would suggest you explore why Redis used to recommend to disable THPs 
(hint: tail latency due to COW of way-too-large chunks before we do what 
we do today).

So staring at usemem micro-benchmark results is a bit misleading.

As discussed in the past, I would actually suggest to

a) Let khugepaged deal with fixing this up later, keeping CoW path
    simpler and faster.
b) If we really really have to do this during fault time, limit it to
    some order (might even be have to be configurable).

I really think we should keep CoW latency low and instead let khugepaged 
fix that up later. (Nico is working on mTHP collapse support)

[are you handling having a mixture of PageAnonExclusive within a folio 
properly? Only staring at R/O PTEs is usually insufficient to determine 
whether you can COW or whether you must reuse].

-- 
Cheers

David / dhildenb


