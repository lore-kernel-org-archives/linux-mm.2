Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2604ACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 08:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676208E0010; Wed,  8 Oct 2025 04:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625FB8E0002; Wed,  8 Oct 2025 04:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED238E0010; Wed,  8 Oct 2025 04:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3791E8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 04:08:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFDD6C0451
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:08:43 +0000 (UTC)
X-FDA: 83974220526.21.A151156
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79226180009
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 08:08:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ABb3eiDv;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759910921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qUJOe88Utm5QNIgMeCqO4mlDI62Txc3nSegvqhoAV8o=;
	b=r75PPJtj7/pwG+FTjtTfa8gbV0H8Egm44cIn2IaqDFLBvs8uJBFq0F9KgOhDRV6kKhwP7g
	QivjY1uNLzShDiRdqZVBlbVxl0GPlSMIaaTrHxfCa54Py1VU3YJo7iNezVNnLEJ27/Knxv
	Zg5jifY8P1JasboFjnGGipl6zThlfIM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ABb3eiDv;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759910921; a=rsa-sha256;
	cv=none;
	b=0hMNo5JR5PW5iZdIvAsrB0NcIMyvdjoZIwdPr4oaMgBWcfrbs3cWQevXXZh4McOA0DaIN/
	LWilTscXMeNvuBRirH+N/kEgOsTjUrQxQ1/DYD+9vSJJxZVUEv+0dLxREhsH7Yw/2ov54J
	cfnD9FdT3WkUhIJe1B9b8ETLg+EnNhA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759910920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=qUJOe88Utm5QNIgMeCqO4mlDI62Txc3nSegvqhoAV8o=;
	b=ABb3eiDvq7SNBofTwALI3bsy9DLnMArcnxQc5gJZ2s65nbh2tZgwXK2zJw8e67BXFuzXZl
	De/INLiSlVW6I+j5AaVHrR9mbgpqwBjbScRSARphZ1d6BVGo2GqZZ39phKyXt4pblLSTDL
	mn3U9bOTRM3erD+bKoKZ0roRypW6/70=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-l2kuCXevNZOL5Htiae5CTg-1; Wed, 08 Oct 2025 04:08:39 -0400
X-MC-Unique: l2kuCXevNZOL5Htiae5CTg-1
X-Mimecast-MFC-AGG-ID: l2kuCXevNZOL5Htiae5CTg_1759910918
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-401dbafbcfaso4318411f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 01:08:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759910918; x=1760515718;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qUJOe88Utm5QNIgMeCqO4mlDI62Txc3nSegvqhoAV8o=;
        b=A9O2fM5CFPPmBpOyOMEfEOxzGwWy6mx6zuqg/kgLWofu2rCO3v4lPYjO9YkHLJADlf
         mVWciKtd3iKK6s7PCITXjx1DHU8SoYLHl8dKt3Te3xOjpP7TYxhjZmiFfuCCBlMbpaQl
         /Jy7V9NmzTqCdtBzNvFpQ8+OKlDFOLyS48en8I8nTntT/cWge08lh3lZkFbv+a0WZHMt
         MCwRPGJcA/cHi5INcP/YH1OWEh6q99tU7sLPm/AOBM5momw5qD3/cJi41DqNZGq8tnlX
         N8tM23GaWbNkhqst3k+0E1R5MojmUOmKnjk6HhSlbpSj89+tSO23v2+HqctBptYCAp20
         SnIw==
X-Forwarded-Encrypted: i=1; AJvYcCVi/+TbCf+ZyFxSxnDcn56HbvUak76sKgFLAJCceLJtoP5Rt103SWJvyXrmGnrV7W17cs4NIXLeeg==@kvack.org
X-Gm-Message-State: AOJu0YyvNyCYYVqVv0BLWxbLuQLgCzTkMcDX1g3M8ue8RH38RQXih66N
	23BFcRuCPCY5rO+s8mMQaad/+rUJo07bHROaBZRBidIMxYRGXgy/MjzLJCrrpZl0/4Gp5cH+MQA
	4UxNgmf0UZJH2VBcDr931zqZirEiMNEaGDYR5iAItLveDNk15tmiW
X-Gm-Gg: ASbGncv1/QD/zeJrbRZDWGhHZHglTnVtGW5ZEZuQWUEp1zpcLUXmr/2A/BMSFg57zmH
	MVxn8rx8YOQA3pcoGyW9UGDxQjYzkhTpkd3o46m/AxDUZ4l9o1FdxXx2KWT4pVoB6eaQmT86UoN
	qGz30s9u9tElOqVBG4wNdrKHV4DjUoz+xf8A3MyFblacUfN+rjyc6fSOoUQLOf+tpFUBzNWpE2I
	W9i37celHzZFa0CulfgpH9NwnLX2ZLjPje9X5cN/1HQN+vLeapdTwD6TNGp9JI0iyfxgFR9/0S2
	+p5Iq67Ze5y5J8fRLc7bH4A4QWYWLary7W7RAiUXIHt+YNTEm0E+icbmwIRRB48fyMR5WEkL6pU
	sSJ/tsdQC
X-Received: by 2002:a05:6000:230e:b0:425:76e3:81c5 with SMTP id ffacd0b85a97d-4266726c314mr1495470f8f.17.1759910918429;
        Wed, 08 Oct 2025 01:08:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHeXMx3ZBbvp7+9qSDMAqpT3IYsrp+qNxlZMMZPXXl0yLI8Wog+oOvMr+BPXNZWvH4I9ELECQ==
X-Received: by 2002:a05:6000:230e:b0:425:76e3:81c5 with SMTP id ffacd0b85a97d-4266726c314mr1495424f8f.17.1759910917942;
        Wed, 08 Oct 2025 01:08:37 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fa9bf87c1sm27190025e9.3.2025.10.08.01.08.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Oct 2025 01:08:37 -0700 (PDT)
Message-ID: <27e002e3-b39f-40f9-b095-52da0fbd0fc7@redhat.com>
Date: Wed, 8 Oct 2025 10:08:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 mm-new 03/11] mm: thp: add support for BPF based THP
 order selection
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, Johannes Weiner
 <hannes@cmpxchg.org>, usamaarif642@gmail.com,
 gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>,
 David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>,
 21cnbao@gmail.com, Shakeel Butt <shakeel.butt@linux.dev>,
 Tejun Heo <tj@kernel.org>, lance.yang@linux.dev,
 Randy Dunlap <rdunlap@infradead.org>, bpf <bpf@vger.kernel.org>,
 linux-mm <linux-mm@kvack.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
References: <20250930055826.9810-1-laoar.shao@gmail.com>
 <20250930055826.9810-4-laoar.shao@gmail.com>
 <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 41nsnQfacuDR97jpcEjmpxkQuUbxPCU4i1Z6pq4lkPY_1759910918
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s8ed7f8goaseddts9kb46k1ydxpuzthc
X-Rspamd-Queue-Id: 79226180009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759910921-100547
X-HE-Meta: U2FsdGVkX18lYrIZeIFoNHzM/WUwYnrj/sQUDKsvI+oOLUM2UDEIlFE3kZ4n+HSnn7ckXNdsXpTL2mbrAazhTTmW78s94mhzfaLaB6rR3Czvw0iv79EDrGqxxoUzV18v9H5JR8Ane9yU0MJgRncDOLr9vDij6XwRmNpsCF5PG3PR605zmwOGEVdcSmbd0b3W594NoTuLVSC6zhRpoZwwqX6aCgyCBWPw10i2fDrzuQGjogCZTK99J3kCLTaOsZxBzZcbwlnwFiai/3qS4v0OqNaSVy2QDM4Nmj3xS6UUKjMb6l+182vitpzNuUN6RuMvnomGzvAkLiuA4mpnE/aKZ1OyFa1Ot94F/ntJFQnz2h8Dlu0h1b82X4f57ecU9O6/vlmnnd2BZQitJKqNeywTqTuhLipJbkxw/Sf6M6DQRzoVyIxMk2ktlgLy9+6k3efLHvxL1e8q/C5rZwGJSFvMUzGbgNJP78dFffhzDnypigpvXZ1N+vV7u0r85Yb2v+4QVrTKLtOCOSBXm+6ZjY3L8bsYhiAGMLBD43BxCVxRQ2+3WDfumLJaLr+kSf+l5hQCsDTizeRzgZcWEGHCMjmUam47JzLmNMZWmBwyC1oGdSSy78NuAhQjq1HDFztxscG3aHaIlt9AbohFLpqZombYKOq3KS2lFJ8mgZ1ZHIOKRI3elznrGF3bqxet+0EcQLtXN4oq9BiZZ5PeqSm0U0rutFo9MmmHuJ1dB6wqZ32kIuh+V++B26AOnyWygywmPBS+9NY1ZHBzca5CHhLhEPoIpXhoxwMp+xdFwswYigpclkZ/SyegnHdBkYs+nqYUrcDZR6/SfXpQaNHJsRfkI8WRQFgBUjkYvgaurkCsfHmpial0Q0GpRTXt88AhsuqegyKqahl1mQwqu+6Z8YOKtlg8xHkTZfTbNnLpXwT0kVJ9TJ+woMFVIWGr3/JjruV2dHcKyZgZ1uIXdLifMTG9fPP
 YtYFS0ZC
 BWinLEAVOrBmkXwDMDP8+FHMosr/jDBtSgAaotZe/YrBSmZJwfjo1EAph9BdpGu5Drm28GMfUVSqDC7OZeC8gxPYVHzc5n//tNrd8j0xR/5H1seoCEmAe8YrLoXGQWpVOn+WzI6hVE8wZSUvYAf/Fri2i3nq5ltcZmmalPk4Xl39WNVo3h8FUDj+8wvaphkOG1LDRpER3Dv2zqNsIclJpHF0NdVWUSxpKxR8EH9e41Wk9GxDeL66CKk1nOXxdSTgASix3EvePEEKzYcmzJUBCdaFntJdhwPoVFfCBadHkuWUNwNWOD+e0SkgIhbPtO8lA16qSAxe61VUBz0/iUCgNw1Sm16lwukTEr9hCH2sWLLgSv0HiZ3JWogAmis9fEc0qAYpcnarl3Sm3Js20Z8OUF18dna3GpoISykXos1M9gCSNRTsyPIUWqcslIjdppKLMPLGbzulWY+qxakdVaF/0gX9GfBpQ7x8KhcHbfUIRmvKn6v1135Gcs0+gxO1KGtV5+2Ll
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.25 04:18, Alexei Starovoitov wrote:
> On Mon, Sep 29, 2025 at 10:59 PM Yafang Shao <laoar.shao@gmail.com> wrote:
>>
>> +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
>> +                                     enum tva_type type,
>> +                                     unsigned long orders)
>> +{
>> +       thp_order_fn_t *bpf_hook_thp_get_order;
>> +       int bpf_order;
>> +
>> +       /* No BPF program is attached */
>> +       if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
>> +                     &transparent_hugepage_flags))
>> +               return orders;
>> +
>> +       rcu_read_lock();
>> +       bpf_hook_thp_get_order = rcu_dereference(bpf_thp.thp_get_order);
>> +       if (WARN_ON_ONCE(!bpf_hook_thp_get_order))
>> +               goto out;
>> +
>> +       bpf_order = bpf_hook_thp_get_order(vma, type, orders);
>> +       orders &= BIT(bpf_order);
>> +
>> +out:
>> +       rcu_read_unlock();
>> +       return orders;
>> +}
> 
> I thought I explained it earlier.
> Nack to a single global prog approach.

I agree. We should have the option to either specify a policy globally, 
or more refined for cgroups/processes.

It's an interesting question if a program would ever want to ship its 
own policy: I can see use cases for that.

So I agree that we should make it more flexible right from the start.

-- 
Cheers

David / dhildenb


