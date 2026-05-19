Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAA30CD5BA4
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09BF06B008C; Tue, 19 May 2026 09:14:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04CC26B0092; Tue, 19 May 2026 09:14:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D8B6B0093; Tue, 19 May 2026 09:14:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D62276B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:14:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E67B71C0F6E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:14:50 +0000 (UTC)
X-FDA: 84784214340.06.143294B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69BB3140010
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:14:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NmV99rN8;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779196488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xYip3+Ws9lw4cpdgrl7SfSSzS0ynQwK4dAkAviqi5Tc=;
	b=hc2RhBZefa1VqB7OYD3XLzM+zZlCkoegFuYhps3NKwwKu2EKXL26JEI4onbqqXvsyyZyVy
	KNI+Kr80AkhVP5rRfR6JvjDJqwAbOGWnjle2KK5dd3bAHhCnWoCbdvaVpJCngA35CjLQGH
	iEiFKQRCHdzAQ0Nc1rtDzfwB4P/rYlw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NmV99rN8;
	spf=pass (imf23.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779196488; a=rsa-sha256;
	cv=none;
	b=Lk2rchM8Tgf6nM5fSw9B/crtB5znIOR880KP9cQaFapkicfN1D5/AXViK4+JN7QmgWZ7pC
	6Xf0fg2prne+74vSZhyGhiYSL/uNAkt0+p6GnKWe4uBBtIEyuhIzmTki9RPcQqvo+l+rQw
	kIJ9+b70vr9tKMKLnC0827n3gQYp2Fc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779196487;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xYip3+Ws9lw4cpdgrl7SfSSzS0ynQwK4dAkAviqi5Tc=;
	b=NmV99rN8d2i6dZdddh7Gk6eSRrFBeE+y6J0Wyqzk12dLpi/4CPHk1sVBw5irdOEPy63M8Q
	hlCVOmOwxmjZUdnHolL/TEY71CMeuMnvOwHtDdZ/QhJrz8c3hYpfH6+XB6w4Yx4WANUSqo
	SPaSY0nwobOzLdYt3UXSSuvYHbg+fUk=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-Bj0yrH9OPfGkmwLuYpfT6g-1; Tue, 19 May 2026 09:14:46 -0400
X-MC-Unique: Bj0yrH9OPfGkmwLuYpfT6g-1
X-Mimecast-MFC-AGG-ID: Bj0yrH9OPfGkmwLuYpfT6g_1779196486
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-8b5f089a5c3so114716386d6.3
        for <linux-mm@kvack.org>; Tue, 19 May 2026 06:14:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779196486; x=1779801286;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYip3+Ws9lw4cpdgrl7SfSSzS0ynQwK4dAkAviqi5Tc=;
        b=N/FaEt2A/b7QlN2giVUACdNiOW68QEnumWHamtZHE2aYpgoc++FqOCFYNWAkxGw/ih
         dzfH/AwSDFMi7w9aYI1//B5EwcFJX1rSLFaMBplqfkZM6jz7m4eU5gMQidqo/FmafEG1
         ii/qGuiQCUitA1Fuxo/n++nF8qj+faHyy5E0XcrsFl5knk1euW/qC3u79yLqWAYEf/so
         DnrjlysUazeeBOyqTHMHSnzgREOWqSK8uXtiveyE78WXxKxVLRQQ2AESupe5kFUClQqX
         CDmaAb8oDijewhdbelkZ8ukhpEd1tmF9wQ5SgBenChYe9hk04/7xzWzRf/yU5cVQd9FJ
         lEjw==
X-Forwarded-Encrypted: i=1; AFNElJ+ndrEmBH0R9j3wnTFbUPLl7LxAcrYob+SIJ9VB95jksSS9HRpEUMmgY9UOPgFd/6i2eU274AbrmQ==@kvack.org
X-Gm-Message-State: AOJu0YwV9I4CYsBUN8gSeGJOWMjO2lHw6SsKBVDMaOF0GdfldAruBBCt
	eFc45JhPYLBN+bYtfzNOXWQxG7eLbYMlhULVlCajP5qFj8cZMVVkbxMkCYseWNUSFL7dqLD5vFt
	+IXR5m5B8xKh+2Kbk09exGgpGzi8R1vz6PG9vMv5RKgOgiS67xM5O
X-Gm-Gg: Acq92OGe+6ec1gcw5eTTT+qiyXjL5twGHxIQlWZGRPgj8BV9IP1XC2tkmF1FaFlWXeg
	qRFIwVTpFplN9fANSZGZE9uS6uZ71FuFB+JJxjilUrJbMCQvfiO7V7r2UZxQO0YQkji4e8yr5ee
	HWiYd2Vya8HpX5XZzzVgmsb7Fq4hAajVDwR13rs9RMvygoIwfH7Y9OtQYAM+74QfNiMXgfr7+h0
	e/czsZ4dNfa0wkQMWDxuAF9Rfe49cWjZdQa9jVlde2bNlJrGSPNgEbhhlQEeQmUkJ9Bfst3XOlW
	4JkMr5sxNdKToSnyyPkP6hkweh5gVCZADa1pVJ+1rzZfUJFXldb7xNyiMym7bV+ogq1UIpVem2t
	R10bZoB+drRWGY8VEfakJxwnJ
X-Received: by 2002:ac8:7f8a:0:b0:515:189c:e0f8 with SMTP id d75a77b69052e-5165a04a50emr267407001cf.17.1779196485778;
        Tue, 19 May 2026 06:14:45 -0700 (PDT)
X-Received: by 2002:ac8:7f8a:0:b0:515:189c:e0f8 with SMTP id d75a77b69052e-5165a04a50emr267406201cf.17.1779196484951;
        Tue, 19 May 2026 06:14:44 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456b6856sm163535441cf.7.2026.05.19.06.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 06:14:44 -0700 (PDT)
Message-ID: <3e300090-bc25-4ee1-a0f9-5e92d5200378@redhat.com>
Date: Tue, 19 May 2026 09:14:33 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, corbet@lwn.net,
 tsbogend@alpha.franken.de, maddy@linux.ibm.com, mpe@ellerman.id.au,
 agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
 gor@linux.ibm.com, x86@kernel.org, dave.hansen@linux.intel.com,
 djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <1f4bccaf-6472-4e4c-92d0-28ac05f6f838@redhat.com>
 <20260517124149.90033-1-lance.yang@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260517124149.90033-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: J5a2gI1jbOmDfQaNvHQP52NlJ_-E4DoJBqZvOymdiXk_1779196486
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 69BB3140010
X-Stat-Signature: n18y3ne7iej8riq1o6o5m5pth76y3xuk
X-HE-Tag: 1779196488-774951
X-HE-Meta: U2FsdGVkX19kBzR/ZoxOfKfr+lyBEP2hkguyyxiuzQqjeNwaLhrbixAEQQwiEAltRZw6sIg7+thIh2CC54oTb3jtmsLlKsVMv4QLXCMPbtOg03wLJApjxgTIPGMiuDpwGQSgeSJbtbPUlOI433+KvEUcv6n91wTEec32GdWHLSjiWO4jzzkoDf5API+BX7/j6Ou4XTNsPsVhxEsSd/XtFJIpAGZBWqnZjDoyozP/kBsmSUdFLsIY4YpEhkka78z8SRp4UWwkNXNOBVTnoTHRpglHOFZuMprOIYc/eryaJKJnLrjWfwxxEtJeQrwmtjdxPHEU1q+5yPFnuely6A0Ocds7WA49cs418VTFxyXLp3y9mZXacLbAk4o3P9bDK09E2Ua7z5ukqy8nRuQr1IEhQu6STVueKNzjTDanV2jN4KbOLxdQQXtHqZXinJEPjx2Z0kOQd1smxLE5csGDLpzE/467K7CgvNgmtJk+0+kUOO46t2paorXreZM1Pu25qdWIJH2bYuE8koqserul0rwdRBPiAwC5gXJZCz/7YeqIfxS+tsiQipIx058umi2iW1aohWoX/xNlun/PCKFUC3IYXNXOyT56cRvVtzR7sp1S36n3lJpAEj5JVKEGa+SwM0jNC8KvuVnAQk4Wwo0lmle4zciCQPjyFrCHLlkSZ2uznoprLzmq8HNqySXffxSBgUT1lcLHcm2iLjPpGxHihZp3arIj7hKoUYR5XdH4BB8bHxINdKKGcSkp5M2BCNSXA2jHOuoiKkrBH7ubDnkA24px6MjLsZGUAz070OmyFOjTkeB4ssAOtWfkdNcMRm5Z9/MfdeoBxT98iNnDoCRAcOAlOuKlKor9g768IVgad78zedj2WNYPRgNtKdj3XDuK1aarpuyIYAo/mBhDxFbp1Nhb4edE0HmkIMC/TFcnjGR7Tw1Mg+CnxECBzv3XXXUrZbELvEBURB5Tg+GSXUm7kUM
 6lMOV8Z3
 4x3so3FKokQ4fnmeNCiLB4+aW0nqe0SbN/B6bOWY2c7UzVbuelIqUQCcGXHl8Rm0J3CshJlhVf2YxDobILjxyEpthErJUOioprMGIFvhh1UDPGhX6TaiW+NWkl6TBiVLlSiLm6SDNRzG33eqKW3vWv7yWN/XIkRcWMmG5BBIhwa1Dg/JIo7nA9Phxhqdryd18zwSIVsO3Nl8r/nXYCoxlbRATrQXHy/JkWra2JwJOM2FXT2u6+Q/uflsx7g8z+Dqw3TdMNS0VKFXbTJc2TXbsK/6V1Gtc3IHwCYqlpcxG0rZvI/q6V3P5fwdAM4zCoU1aH4dzG41mL/ljzdhN8OclSh/S2KvqPTcUSf52kWrdHZ8RVrHP4B5eV8REVTXy+gM3rby6bBHntFn82QVOHWbdy598UjFGpicefu6NGY71KnJZGB95TuZ3O0Gk4Lbn3yozFasKynrIB6GobrAzMvhG6YdANf1KGHQ9fnHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-17 08:41, Lance Yang wrote:
> 
> On Wed, May 13, 2026 at 10:18:48PM -0400, Luiz Capitulino wrote:
>> On 2026-05-13 11:36, David Hildenbrand (Arm) wrote:
>>> On 5/1/26 21:18, Luiz Capitulino wrote:
>>>> Currently, we have two helpers that check for PMD-sized pages but have
>>>> different names and slightly different semantics:
>>>>
>>>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>>>     enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>>>     implements this helper, it actually checks if the CPU supports
>>>>     PMD-sized pages
>>>>
>>>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>>>     by the hardware, but it just returns a cached value acquired with
>>>>     has_transparent_hugepage(). This helper is used in fast paths
>>>>
>>>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>>>> which is intended to replace both has_transparent_hugepage() and
>>>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>>>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>>>> It always returns a cached value, so it can be used in fast paths.
>>>
>>> Oh, one more thing: what will be the semantics regarding
>>> CONFIG_TRANSPARENT_HUGEPAGE?
>>>
>>> I assume it will only return true if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
>>> correct?
>>>
>>> That is, for example, relevant for patch #2.
>>>
>>> We could later change these semantics, but for now we should be very clear about
>>> what it means.
>>
>> I intended to decouple the API from CONFIG_TRANSPARENT_HUGEPAGE,so my
>> goal was to return true as long as PMD-sized pages are supported[*]. If
>> arch_has_pmd_leaves() is not implemented by the arch, we default to
>> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE, not CONFIG_TRANSPARENT_HUGEPAGE.
> 
> After patch #07, what still confuses me a bit is that the arch hoooks for
> arch_has_pmd_leaves() still seems to be guarded by
> CONFIG_TRANSPARENT_HUGEPAGE, not CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE ..
> 
> For example, x86 only define arch_has_pmd_leaves() when
> CONFIG_TRANSPARENT_HUGEPAGE=y, Same for s390 and mips, unless I missed
> something.
> 
> So is the intended meaning:
> 
> "this arch can support PMD leaves"
> 
> or
> 
> "this CPU actually supports PMD leaves"
> 
> ?
> 
> If it's the second one, shouldn't the arch_has_pmd_leaves hooks move
> out of the CONFIG_TRANSPARENT_HUGEPAGE guards as well?

Yes, Sashiko caught this as well. I'll fix this for v5.

>> Now, do you mean to say that the API should still be tied to
>> CONFIG_TRANSPARENT_HUGEPAGE? If yes, why?
>>
>>   * Sashiko found out that the current arch_has_pmd_leaves()
>>     implementation for x86 (and possibly the other archs) is guarded by
>>     CONFIG_TRANSPARENT_HUGEPAGE, so we may return true without the
>>     hardware check. But that's a bug
> 
> Not sure whether that bug can actually happen ...
> 
> But decoupling them looks cleaner to me :)
> 
> CONFIG_TRANSPARENT_HUGEPAGE controls whether THP code is built, while
> arch_has_pmd_leaves() is about PMD-leaf capability.

Agreed.


