Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C39D6CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 10:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D396E8E000E; Tue,  7 Oct 2025 06:13:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11058E0005; Tue,  7 Oct 2025 06:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFF608E000E; Tue,  7 Oct 2025 06:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB6998E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:13:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6093E13A43D
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:13:52 +0000 (UTC)
X-FDA: 83970907104.01.3C346F8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD61A100014
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:13:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SH/+8aa9";
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759832030; a=rsa-sha256;
	cv=none;
	b=OsoaK7MyeNHpShiHZoO8XauYi5z/d7KB7IWxHk2QktntlXGzHi4NrTdLSY48LA01ytuPHl
	shzC0kJj40MLtf3syikjBX3nnj+5gQtl+PID/R++61cMo2ty7u/GwG5pWEj+beDE9kKqHJ
	vwLfEGZbdxIEudHtlBp8X546mSQuJz8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SH/+8aa9";
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759832030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dtANHMhn4NYfEUWXTBrWybwxcyGV7aE9tri3mnTg9D0=;
	b=mDWyqE/lrmGx3KARhv1O6IEcbuIddplqZ12M4/xuteAYAoM10V5aHyYFJ5xrmj6IayBLrr
	K2p5ujal+IKGpQwiYN1cPUhL5lxtVTYwZKbw5gLGXFRYaWf1T5UFL63TjRFHa88knudpkm
	0IXFQe4ofXGckM+mizcV1Sd9YT6QitM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759832029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dtANHMhn4NYfEUWXTBrWybwxcyGV7aE9tri3mnTg9D0=;
	b=SH/+8aa9Q+r9RjCYQCWtGMICENLS/wQLJUcNQODAurlhFOzf1I9N0WeWOlpEZRLuu6Fhgp
	LFuLyoOqiLSfn1d7Db2GyFQlxIv429LKfYh2yL6llPIYZ5fwgajwde/GjWJopHFpv8/zJK
	5CEUTUkpbipXnlcZwCyhKUh/VNrdtTw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-664-kwwpAS7bMCmGleHMeaQShQ-1; Tue, 07 Oct 2025 06:13:45 -0400
X-MC-Unique: kwwpAS7bMCmGleHMeaQShQ-1
X-Mimecast-MFC-AGG-ID: kwwpAS7bMCmGleHMeaQShQ_1759832024
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3f93db57449so3030377f8f.2
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 03:13:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759832024; x=1760436824;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dtANHMhn4NYfEUWXTBrWybwxcyGV7aE9tri3mnTg9D0=;
        b=ajIK0Lt2wRNlXp6wdca984+SP3oD9ZIhwU6usDkMqHKAhSjA03mNmOmzfwZu0y+v5G
         UsDK6F6Ew/4s0q0+5mrWmMHSCy15fsr7z9fuZzmeWe2f1qeUcT2euRz+AUAYf5muG5UT
         56TLYISyWp/01UrXSqMI0oO0GbNZ7OQDKhgJu7hBarZAMJgGvqJpuqq+Qnu86TRCKZm3
         /cTZ0f+afXhrh4I2h4IY3oi2Ndvb8oTLYGZVBeG4oqDDteNHtx5VtSXyJeLwviZ7BsaD
         U5WqD4VEdt5VOPw7DyjPOeyP25Hn2YWU4NG8UUHnLktH6I8MuhybOCQw7E4/XfVWl/vu
         umlw==
X-Forwarded-Encrypted: i=1; AJvYcCUcI9LC84Yj6fFpqzCvVCEhDBn8VTqBA5LC6IfX5B+koBGfYT/s5mci5R5SHnyZe8BNc8RGMr2+zg==@kvack.org
X-Gm-Message-State: AOJu0YyEMCdpJe15VqBrtIfkyBxlav4e4WgavX0mYIHYwmyIe3N95EYm
	E0FfchMIozq56zw+pyMMvJCL22WHLhjPLJlg9im5niYtE1YKS17E+lfXK/DDNLvbbwIe2S0Jmis
	dobyjQA3Vx5xlPNuMbM+JxoC8hB1XSEuxBgagpSMXhGrE1+IRSfSzUBPRaFLQ
X-Gm-Gg: ASbGnctiMPTP5RWmxBdKDDF5T+VF12Yfy0cB4QOyI5+H9O+C5nML1emxVJiT+bTkEvD
	FzuchJE48NFrvLzqGVwlmjRVpMXgHuAfrX+zclVvUlHlWyYyKGGOmLUS+hleD0neW8E+vDe6d8d
	fsRssGORwwKVS3pdvBV7kueU5M1M4wOmyFaO2voIJFpywiBYZNw75B951uVqF55ByJVvuZIT20j
	FFT6GJxsMU9qgi6ETAIAVE0xCo/NgZXJX+7B8YNiFB0jLBBXl/Nj/G8/WlpCngELj/Mqz7att6I
	/LxT+QnDNBnUh42gQQlRx0enJJCrI0oLLTiEnrPYIv/FFSwf7Voez5OiC0T/hforXCbssZKsP4u
	B319rcqus
X-Received: by 2002:a05:6000:43c5:10b0:3e4:64b0:a776 with SMTP id ffacd0b85a97d-425671b26cbmr8332530f8f.52.1759832023879;
        Tue, 07 Oct 2025 03:13:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG0WEYQCR6DFeiJ0wRMWYGtCd1TfooQstoN/GViL2/1Ggzolv2CmH4LWn2geZLc+8nvNyFrpA==
X-Received: by 2002:a05:6000:43c5:10b0:3e4:64b0:a776 with SMTP id ffacd0b85a97d-425671b26cbmr8332514f8f.52.1759832023401;
        Tue, 07 Oct 2025 03:13:43 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ab0sm24803534f8f.52.2025.10.07.03.13.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Oct 2025 03:13:42 -0700 (PDT)
Message-ID: <4c3b148e-9019-40db-8ca8-2166ef011c75@redhat.com>
Date: Tue, 7 Oct 2025 12:13:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] bad error return in walk_hugetlb_range()
To: Dan Carpenter <dan.carpenter@linaro.org>, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org
References: <aOC9HP6nB0C45QnS@stanley.mountain>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aOC9HP6nB0C45QnS@stanley.mountain>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WzQvKSAXlKaW68FKaj5dqNAx6n2JKjp_wBSfRBcfK00_1759832024
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: zx8memtxdp5jumswqzatmnhfcm5yi65d
X-Rspamd-Queue-Id: DD61A100014
X-Rspamd-Server: rspam09
X-HE-Tag: 1759832029-721808
X-HE-Meta: U2FsdGVkX19AwHz1Dr97Xuczk/aJdGJ9b9Z/v5K61xYswA8lVFnSu6Rr7mnmiIjW/zriSw7kZd6stiRSj8cHBppNuAJzOnWF/GhXLlA4V4QgPiKO/tSkV4Ae2a4VMtdDWIEg6SK96mmrKga2VrjeAIg2R0eAZtnBMIR1c3M3KkRTV9iW1lehlZegfq3z6S4RObpgPfVODgB+JxQzxDrZjdoS+bN1EbNiybAA2fUdDKDB6Mg+VIBPHIUdXNG08FKlDLhlZfHG1lYypsmLEwocYroOA/c1tDWpjeEm1W+18V7T2GgtXt1TqJ1PhU7skur0tXFaaCHb3edKLkIVq9uO2VyeGWCFebQf0n16uGf9OAHB+GQdxWlGqY1G+0BWgPsfwDYVqEBR8UsXvTnLydtE7M2Dk3+ayOqezN1TVympxNQ0H5wAWQ55zzr8TXqttlSyUtkloPgNhVGgyMDeoZFwZwOJl+EZpJlapfCkFC4je2ABwuN1NIojhI4MXRBQI/5tK9bdhRFcFKAEiMkuuKXh06i3ZYBT1+Uyl5ymDnS+SHFzSnJG38wFPLLbaq9+C4/EiKCFCLYpRDPrvXnyL3XzD5FoNf6Ny0t5tcwNDsbem55GW5DoLHH9J9TsgDDRmsYjX9+Xrv8//Khmk7oe5CuLRwm8TWRoN7rVSs6OoLrt+Ad3jzsNI+LRl/f96wZMPX2+TQ+kt0ZxTM1Sy57Aq/mIxGEC5T3LCrmoJhLhG4IU0IRSfmPhgdYTUWHa3tR3arGJiN6trAZna9waWww0cbC+lKlD9b/YQkv9zR7/ojyUd4NCkuYIkET5wUMNFHiCMCw0Uz0T6HeNZ+/k0DicnZuo1+lgSzEo/plCv9YY50S9bp8NGyyvr4HfvXHwunaox1wCANetVKpleXX0hSLocfWwXlcFiEkjKb1MNxvROZd1qfFKEsgNGC/rCBD2kqONMfckNTy7Hbg2nD89BC/AJ62
 6CztHNV2
 sREp2idj/nuRL5GB9cHbkfKbIm23qIM01W5HpS+vSTS7d4EbdZ9v8r+XPkGEg+vXJiR6wlMJ1hWEGYUrBtO50K+0xuqvY0iDf9JrP7UayaIMsFG/hIkyLDr1Ctc9r6lJz3fykDd3o7lCRI9DmhGYQkN6xnShtKRkdm25tBKKID5oeJwmvEkrTY+boLL6SrHqfHi9oCKcRAbPfDmdayRsqerb2rSMLTtXc0+fwENs50psBj/fWbHNTX0gT1PVYMR4dbfsLQqSOYfxvJakexPh96s2x+1osxaCZqQcd/M7ojHVLTsJR2KsaAuY2bMurn0Qp0Fg9TFBP8uauGG6EXWCTyCAt5sQpmaAJ3thyjUR+vcYfd4ynt1cnpOU2URVvZ5cBQjxjEgKSSrtcAs5gTkv57GLVKXuGoBj1rQuUNvFYHMg2MxwOIVqhRP1i2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.10.25 08:22, Dan Carpenter wrote:
> This is really old code.  I think it's a bug in hugetlb.
> 
> 	drivers/gpu/drm/xe/xe_gt_pagefault.c:353 pf_queue_work_func()
> 	warn: passing positive error code 's32min-(-12),(-10)-(-1),1' to 'ERR_PTR'
> 
> mm/pagewalk.c
>     319  static int walk_hugetlb_range(unsigned long addr, unsigned long end,
>     320                                struct mm_walk *walk)
>     321  {
>     322          struct vm_area_struct *vma = walk->vma;
>     323          struct hstate *h = hstate_vma(vma);
>     324          unsigned long next;
>     325          unsigned long hmask = huge_page_mask(h);
>     326          unsigned long sz = huge_page_size(h);
>     327          pte_t *pte;
>     328          const struct mm_walk_ops *ops = walk->ops;
>     329          int err = 0;
>     330
>     331          hugetlb_vma_lock_read(vma);
>     332          do {
>     333                  next = hugetlb_entry_end(h, addr, end);
>     334                  pte = hugetlb_walk(vma, addr & hmask, sz);
>     335                  if (pte)
>     336                          err = ops->hugetlb_entry(pte, hmask, addr, next, walk);
> 
> The ->hugetlb_entry() is implemented by two functions which return
> true/false instead of error codes.  Smatch thinks this 1 value gets
> propagated back to pf_queue_work_func() and results an an Oops.
> 
> The two problem functions are hwpoison_hugetlb_range() and
> pagemap_hugetlb_range() which returns PM_END_OF_BUFFER from
> add_to_pagemap().

hwpoison_hugetlb_range() seems to behave just like hwpoison_pte_range(), 
returning "1" if check_hwpoisoned_entry() returned "1" -- if we found 
the entry with the problematic PFN and can just abort.

Staring at kill_accessing_process() that ends up calling these 
walk-functions, that seems to be correct. The value is converted to 
0/-EHWPOISON, all good.


pagemap_hugetlb_range() can indeed return either 0 or PM_END_OF_BUFFER 
obtained from add_to_pagemap().

But that's the same behavior as pagemap_pte_hole()/pagemap_pmd_range(), 
so that's nothing hugetlb-specific.

pagemap_read() does the
	ret = walk_page_range(mm, start_vaddr, end, &pagemap_ops, &pm);

After the loop, it does

if (!ret || ret == PM_END_OF_BUFFER)
	ret = copied;

So I don't immediately seeing anything wrong with that?

-- 
Cheers

David / dhildenb


