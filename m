Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8E87CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26C7A8018D; Tue, 28 Oct 2025 13:16:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C9F8013F; Tue, 28 Oct 2025 13:16:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1334A8018D; Tue, 28 Oct 2025 13:16:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F16058013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:16:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7AB9388B02
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:16:15 +0000 (UTC)
X-FDA: 84048176310.23.040DF2D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 12289C0009
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:16:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UyINh0x/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761671773; a=rsa-sha256;
	cv=none;
	b=vtZCmGADf4wEKhhHf51Zm/5rdgeUty5wBFZMpzEcNqA3x3IvNz7W/otBruqLEl9z+a5Vaz
	M9ghqM3O38M+MqPru4cTXFPwi2zQrVzXON1CFeS/35HabPRyuaJWTVb/ECmsjGmOFzaizB
	RGrfWhzPlRHEwY79Xv9e/0IyRuWaLXk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="UyINh0x/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf22.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761671773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OZZJmYzbni2EVKfNXfjvDYvkFMG8WiEx1VqOApMIszw=;
	b=fJCjDIv9C0L9+KPgC+IcS1A5s7HdBLC6yJrfpJ8t2VW1wMNiH8c3lU4kcuFE2Sa4wYcRy0
	LBAnS0YwWpa07ALx5shsHvuAhmLML1NmdNoCN+v9yRXv1A/xMF1L+KgWxRLl3G3RWN1RPN
	MbFV+IPF8c4oBnRKuJ83Ds+L4hglch0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761671772;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OZZJmYzbni2EVKfNXfjvDYvkFMG8WiEx1VqOApMIszw=;
	b=UyINh0x/5Ac6xE6hUZKbjn5w/v3/jfm9FWy4mMQrQs8MLpVXPERDj42hPzbA63JcziOx1N
	YG4AgZlCrB8V48GuXvaJQLqozlIGv2pqusjXTJjmJCHbCrNWD6I9hvGJ64mhyhdgeFB6MZ
	LYt3I/7ZR8aiWXWD2T1XR0gECYC+Jx8=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-443-Td4LKdnePJKgoHzhePK7XQ-1; Tue, 28 Oct 2025 13:16:10 -0400
X-MC-Unique: Td4LKdnePJKgoHzhePK7XQ-1
X-Mimecast-MFC-AGG-ID: Td4LKdnePJKgoHzhePK7XQ_1761671770
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-87c146f81cdso169073316d6.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:16:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761671769; x=1762276569;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OZZJmYzbni2EVKfNXfjvDYvkFMG8WiEx1VqOApMIszw=;
        b=kijBPm6XY9DHnUnZJaAQVBHuaFF52bOkAKp6E/sShA6mZW3XT5lkOzJkzXeDXFS+rx
         iqWLkIvHf4LnbfJFC3F64cjPLBK5I+BSIpwrjr4OMT0Oir5wZOIkRS3aXTQ1JltoFz/l
         gNbcP7Ct1DUw/KCEQSOdlWMsWIgjf9yN+K4xi06fuSn92w0lW2M0lTWOU85H0FRED+ab
         HnJXvHk2//OJz9rD5A426PaFyjqH0rrL7eMNL1OBqupGquitAJ+49fzD+NeIyMKtyZCa
         z/M0PTkLzgrecFq3N9Sm5mEV6LdZ5Hf0a0T52WFtcP3m2l0V6pNLomZVa0vZ+MUaSHWf
         zMQw==
X-Forwarded-Encrypted: i=1; AJvYcCVZWBW3U+aXZaonn6vAABsk4EIjpesjNiERCcku9tw7L99cyOAtjqUNz7ZBOJpkaNIJmdtiewr0tw==@kvack.org
X-Gm-Message-State: AOJu0YxpbYbaTIgdF6qIjptj6PK8NshiUewkJKPdYJFbjSbUa54k0RpB
	gdTHTkUToo8abZUur+TKtyPB0TTT3INbx6LQktpoA4mHOrdpMzn9SawZ1iJ1TvspF0ttZdJiXyT
	liZGpJArnm3Nue0reg+Su6hvYGONoAtSePGd2FpJ0ps02vDsN4o9VVlMHmoce
X-Gm-Gg: ASbGncvhspiFfmH9C6n7ezp1bV1L49NWM8TZ05r/MhO7F7gQf64ieSLEAxoyud0DWxV
	DSpSzn22GxZjCnsNrqMdVxSLbgVr1GmakYWIsZaymRgxhagy1TukGNADR1C7DdGBhZsLIRJPTpo
	kXXshqRjfKoV1facHx65BUwh3U/PwWoeWhvKO/Gm4bCPj8L2Igk2JOOfvQa9b5mAYDNQpT3pk0/
	hdSf7ez7vNi0qzWT4lUzzA8eWTrlsYxr3sLs3n9xqT5PZ3NCeuVVxzoI6B3S5++XvgDlSK4EYZ0
	fXyPMBhEoSdlkcvYj01iYUhIXbAYg0M0qx6N2FNXkaA7fpzFUtq2FZmKV22u9+r7hOS0+KrjAuJ
	4IA==
X-Received: by 2002:a05:6214:20c4:b0:87c:20f1:359c with SMTP id 6a1803df08f44-88008764b84mr5742926d6.11.1761671769315;
        Tue, 28 Oct 2025 10:16:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGJPAT5x1RqJKPB3Gg2m0808ux1QN3Uf5oB2BMADrFvGcoIldW5zFHxqfitjG7zUSDb9gzyhQ==
X-Received: by 2002:a05:6214:20c4:b0:87c:20f1:359c with SMTP id 6a1803df08f44-88008764b84mr5742396d6.11.1761671768836;
        Tue, 28 Oct 2025 10:16:08 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.125.126])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48d91a2sm81157926d6.17.2025.10.28.10.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Oct 2025 10:16:08 -0700 (PDT)
Message-ID: <4f522b65-1ab8-4725-8da7-3f071e7919c1@redhat.com>
Date: Tue, 28 Oct 2025 13:15:57 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: hugetlb: fix HVO crash on s390
To: Heiko Carstens <hca@linux.ibm.com>,
 Joao Martins <joao.m.martins@oracle.com>
Cc: osalvador@suse.de, akpm@linux-foundation.org, david@redhat.com,
 aneesh.kumar@kernel.org, borntraeger@linux.ibm.com, mike.kravetz@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-s390@vger.kernel.org
References: <20251028153930.37107-1-luizcap@redhat.com>
 <50d815a1-8384-4eaa-8515-19d6c92425b3@oracle.com>
 <20251028161426.35377Af6-hca@linux.ibm.com>
 <5c72e064-9298-490e-b05a-16be6b5590b7@oracle.com>
 <20251028170251.11688Aa3-hca@linux.ibm.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20251028170251.11688Aa3-hca@linux.ibm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: pvCXnuNQVuigifH_Toxv90rkrZR13da_SceeIuzl3gw_1761671770
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g3f67g6p736mz8ozmmfjc39w7jwoge77
X-Rspamd-Queue-Id: 12289C0009
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761671772-808807
X-HE-Meta: U2FsdGVkX1/ks4D/9JAykOcpPvpKyrF5LMkxN6XrllLbW9xpnhFa1W6VgWqgq8geyTTE4FiwLs8cDEYQwAqSnyOsQvEqYVB09yqfFGB0L8pbypdiDXXqhwwbc9ajCuaA0L5Qc8jthSLK0/+LV9ZaPYPKlwTswLd+aQDHjMOuAMeCW2BheTNd6odNX3dbxycY1wGOIsC6b+VGrprcYQZf5H2fkmrZZL1hkHtxjwy0u4H+rfqyuiFOrYp/6uiEELBpCRhg7Bo1H54jZsmBeqzeONp0G5lZcWskLp1/S8XJEDQGHkhiCk8TNk7a6tybHQ2nd2Uj6kDks59aJ+IcQn6LdavDOkHu+uIUq1wXVs39Wc4/TYBWpmM+mzyUzZe9ZYNP5R0qKF3zl9Rlw3VxsjEiuJX1TD7PStjE8XK3/Hks7XyLKQ58CKHorx0o3sZ7x2LyBarYdx0a4Lvj8WtEq+EqCWCWVkutv0rVzHEmvm3uyHIV4dqL4kqOSXLDXoQyklwppaRNytO9zXQ3IZ2feRa/+sOu9lZtbuCgJNZ5mIBDQBaZ0/U2uyV5T3dyXFrNyFeyymClRrpbs15ye/5vaNBQSglMYbEFAjBdDp7Gou31hW9dffM+IN2umWj8vXjelWuHmMo+xpnMOwD5W13kjo+5rxzRRX65OgpAGkGWsTN0vcqM5jbvVsXWUJDwjMS5aNqNNh2gvyEd2i1PFNvLNPMvxIQhjylBA2lV3VDqWvauWmoGqxuV3Dt9ojXCLKrz46F1l7zVWOQSWMZ7o7Ubayd6d2F9gN/ympq4F7DNxqjTWBrf+nUK+jvcYySlU1usr9FoZeUmwYTENSg0DcH4TTXenSkwyIFphip5o6Rb8BExi7wfHemmkh/YUcnmyg9Nu0Nr5h0p9PuUVQD4XfJV7JDsqRF++JfzaERLblKoQsmcrNdfQ8k5v3ey+Vju/z6Ba5rYosD6CXfOzXVOOdQuztJ
 +0gnTPc2
 TFZvlnyRd8KYmNWWP037QKMHH2Lfds2q918mEMcK+6tzuAi1u7P+H8OeJ6+KVI+34zQHNjKke1vule8DyBHeo8oPBMGaQ9GPVknwvlhU9ztlNbRybBvixRItoNd2mMkTcaSwmIgIAbC/kxKx/xtgIEQd9FkSzsA4TJ0eXLTGDQrJB4gYw2n0Y/NJFdS0xZFarqw7Ea02EatmiahsQ40Tks1bDh8FaenLboLrd+fMbxldrRcI5gmGO9bm33PkpIMUeKkhzl1m4m6WWHA/TB2E0MIqLndfRUPpd5Ai+BDoPvfL59eJrs/EjtUqhiMlliYyyGOml1X4zNEPaqiqMrDrl1CiOZZ2c5DZjah4o+H3I389lLxdIaszhfatt/kz3aif4jfWUL+U4T9ujh0EB/rWG9dijuhjI7NMcGpWHoE4gWiZjZwD6A99PGIUmX1Gxxp3jr9p9htXu9nzNZoYFnOk2QlXQBuwlGuEYmxV+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-10-28 13:02, Heiko Carstens wrote:
> On Tue, Oct 28, 2025 at 04:48:57PM +0000, Joao Martins wrote:
>> On 28/10/2025 16:14, Heiko Carstens wrote:
>>> On Tue, Oct 28, 2025 at 04:05:45PM +0000, Joao Martins wrote:
>>>>> +static inline void vmemmap_flush_tlb_all(void)
>>>>> +{
>>>>> +#ifdef CONFIG_S390
>>>>> +	__tlb_flush_kernel();
>>>>> +#else
>>>>> +	flush_tlb_all();
>>>>> +#endif
>>>>> +}
>>>>> +
>>>>
>>>> Wouldn't a better fix be to implement flush_tlb_all() in
>>>> s390/include/asm/tlbflush.h since that aliases to __tlb_flush_kernel()?
>>>
>>> The question is rather what is flush_tlb_all() supposed to flush? Is
>>> it supposed to flush only tlb entries corresponding to the kernel
>>> address space, or should it flush just everything?
>>>
>> The latter i.e. everything
>>
>> At least as far as I understand
>>
>>> Within this context it looks like only tlb flushing for the kernel
>>> address space is required(?)
>>
>> That's correct. We are changing the vmemmap which is in the kernel address
>> space, so that's the intent.
>>
>> flush_tlb_all() however is the *closest* equivalent to this that's behind an
>> arch generic API i.e. flushing kernel address space on all CPUs TLBs. IIUC, x86
>> when doing flush_tlb_kernel_range with enough pages it switches to flush_tlb_all
>> (these days on modern AMDs it's even one instruction solely in the calling CPU).
> 
> Considering that flush_tlb_all() should be mapped to __tlb_flush_global()
> and not __tlb_flush_kernel() on s390.

You're right.

> However if there is only a need to flush tlb entries for the complete(?)
> kernel address space, then I'd rather propose a new tlb_flush_kernel()
> instead of a big hammer. If I'm not mistaken flush_tlb_kernel_range()
> exists for just avoiding that. And if architectures can avoid a global
> flush of _all_ tlb entries then that should be made possible.

Should we take a v2 doing your suggestion above for now and work on
the tlb_flush_kernel() idea as a follow up improvement? At least we
go from crashing to flushing more than we should...


