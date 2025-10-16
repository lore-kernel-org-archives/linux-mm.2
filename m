Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C01B5CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 08:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12BBC8E0014; Thu, 16 Oct 2025 04:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103708E0002; Thu, 16 Oct 2025 04:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F34358E0014; Thu, 16 Oct 2025 04:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1FBB8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 04:59:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AABE1860CF
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:59:37 +0000 (UTC)
X-FDA: 84003379194.13.8D6E84A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5ECBBA0007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 08:59:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AWWcVjys;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760605175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kapyuiv8tsDIKt44CfN5IZYLsxk7UX5m2+M0d9ZIPEg=;
	b=rELzErhyv5EdQUluvAVkoQ6SyB5w6D8VU4OMM8UbAFUlKOrNEM2OeUUuF4jKwy48W20tiA
	ZV2+cCV4kXOxB7vFtKV4edUNRkvU9QSlKaFEPK+tA1sEcZcZRkNtcUO6Cdq+mQ3H/nGH5E
	/hpv/xyD0ROdDYPXkP5mk+lAr8zQvOc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760605175; a=rsa-sha256;
	cv=none;
	b=z3poCXBvvm3w2LkngJ8iIDi6oZOIjUGb850A0dXunzgQNWv7QzKOWzb1xgprHo7GWZ5KG8
	13+bnNKKGjG7QFSt4gF46Yx7FQi2FQy5ruKdkmNOukPw20QEbcv06FGHvL1hVl9NnCe2eM
	M9YxcV4or0gq4baJ4oJu5UtkY/EGtdI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AWWcVjys;
	spf=pass (imf25.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760605174;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=kapyuiv8tsDIKt44CfN5IZYLsxk7UX5m2+M0d9ZIPEg=;
	b=AWWcVjysErbI2FLhIcuv8cPBizf9DMJ/68wDw1yRA+ywzzW7CSzob0+qaQQ3gqMx/ys9Qm
	K4/SjRPGH42AXKWXx/VTPNPSiZ2qqTcpb6zM4SxUbBekQBfLlFQXaar+aGDFnUv91Zzra1
	rwG+TxuYWgiJW3TeXzXGk3kfPrr4Ksw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-aF8pieClM1m24WEFuYvfcw-1; Thu, 16 Oct 2025 04:59:07 -0400
X-MC-Unique: aF8pieClM1m24WEFuYvfcw-1
X-Mimecast-MFC-AGG-ID: aF8pieClM1m24WEFuYvfcw_1760605145
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47113dfdd20so1250155e9.1
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:59:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760605145; x=1761209945;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kapyuiv8tsDIKt44CfN5IZYLsxk7UX5m2+M0d9ZIPEg=;
        b=BmTT0Mtsy9FzXdY+q/RzjR7BA6FqhHiU6O9jDhGEtBKYh0MnHh9ngV2PslnmkKrjkY
         PbcRci3nKy0aof09suwDIpfybIrmZeTTxVMc7nFYeofkRUgwXSeF4xh+m/wqjcVldR/U
         aVpyRaTBhCgrg49qfW9BLX6KY2pYJpwjJ2mk2Yj12YOFALzGWjxSn/0nGHuutbWs03iG
         xBVGUgjchvIwEuSIvmp3kYHRZmvrzGKutgXZqCeg4ckVX4ZHZNH7U2gXT8zQXOciREae
         JowZi8CrTdGkysCoxYdg2RJwCB9vyZ7V3HpFLelD6PUIuKnKO30EjokpUrNBCo+uJjp0
         BjxA==
X-Forwarded-Encrypted: i=1; AJvYcCUFFL6R9V+BtF4ZbEu6tQFoA6eQ2syk2ymntNWu7bbL0aTV+0Jm8h83e410nF0zZqRhFSwd97QIPg==@kvack.org
X-Gm-Message-State: AOJu0YxPpKRcFD7mKjc9s9rxLn04ac+dV7Sgh8JUuRguSypcrZ1b34PW
	Z6AVSA5LRUWXpJ251PfhbAX2PP4NbGH6BWXKAFQiE33pbXH6Jvrpf40T5FUTcDytjpc7lDOTqxk
	tZUeaGua0fbLaSxBoKys2SGcQ4oU67ScU2bccuPen1n2ap3qy8oUF
X-Gm-Gg: ASbGncsCdzjAIxMikLXn3O3LOPA4anSl7QJGR81um3m8taKwRUMGEVySmhGM9RfbSRQ
	f1FmfEeBItO8z5Znac5tuVZsDlybRjY0FgWS6gAAWWNPSmAWMV1JTmCpruqDNcp6LxDK7B86Sq6
	8MX5sgYqLrWZ1VkgWqrKv5AMA7m9o7C2JAenjYmuhQblU9LcFdABRLNgA1NwQg+64DX+2P3amhX
	Y6oNMebw7M0+Rm+NMRL+NYhxO0GbpNxwpeCngKan//jghAvi5H2JVggrKWMJSXoH5q7bO8q2vDJ
	jvhWELuzcrhTSuCWygMtcU++9atP2ijtvM8tHrhIVvXnnL7IRW6GVsYBpcEdnACT5Q3kR1N10t0
	PX5YPhLOsjLdYewOFtKHuIJJHtclKw1IR/MaIeiWEqWVjvFb8j+U2XmyKuO56Ii39Vq0eT0AhUV
	is+6MjcAQ9JwbNUx29/mPN38qHDCQ=
X-Received: by 2002:a05:600c:c4b8:b0:471:a98:998d with SMTP id 5b1f17b1804b1-4710a989a70mr15406305e9.12.1760605144906;
        Thu, 16 Oct 2025 01:59:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0u7pM/I5UH2Tdmf79ws175Qz9y0o5UXmeZBEsLNdrgt2fV/TSg5wXNlsc+YKlMr/W4eYM/g==
X-Received: by 2002:a05:600c:c4b8:b0:471:a98:998d with SMTP id 5b1f17b1804b1-4710a989a70mr15406125e9.12.1760605144496;
        Thu, 16 Oct 2025 01:59:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144c82b8sm13134415e9.15.2025.10.16.01.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 01:59:03 -0700 (PDT)
Message-ID: <1f7c3b59-3276-4f6e-946b-5f6ac9807e93@redhat.com>
Date: Thu, 16 Oct 2025 10:59:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge
 pmd
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Yang Shi <yang@os.amperecomputing.com>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Anshuman Khandual
 <anshuman.khandual@arm.com>, Yicong Yang <yangyicong@hisilicon.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Kevin Brodsky <kevin.brodsky@arm.com>,
 Yin Fengwei <fengwei_yin@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
 <20251013092038.6963-2-ying.huang@linux.alibaba.com>
 <4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
 <87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
 <d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
 <87bjm7lh4u.fsf@DESKTOP-5N7EMDA>
 <3fc642be-b8f3-4fcb-b13c-3359cd52e921@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3fc642be-b8f3-4fcb-b13c-3359cd52e921@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QslCk5r4vicpuEybw_wZxBX-l0K-0M0g7oX_hObTpC4_1760605145
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: e1qa6wgkwxzdh783t1s8yay3ak3i1sy8
X-Rspam-User: 
X-Rspamd-Queue-Id: 5ECBBA0007
X-HE-Tag: 1760605175-953627
X-HE-Meta: U2FsdGVkX18FdGQ4mVeej7ev1mg6D31B0h2NmTiD+62RZ54ztRAEuzIBKuk3sx6OVphgsFAsSPnGorexAN8Ur76xq3QroMWgOhQAhJ7L+VlvjVD1b7PqrQMXvREej55j4Lcclrzw0KoY6e8RButLR+3XmppdnJeNh9bS0SXOt2iK594H3cRjGnJYycM/bMumk5p7s2T1C+BbagqQ05l+YT0QVtweDNG0ftY9TKt5R0B/VAcl2Edl5es4ww1INO7i3vfX5QjNqg00vfrHdJCkxHK4KRFvXgBSzhjcQEPYh65p1tS3SGKbi2jzEUNsmGGr8ln3wxP4YGY5MamWVm9CZYEbdUmKTlfQqQJHTK+JO2Dh2fCXrhYXkDS2AjbDIo0CQ5PI8ITq4MKNn8EREkqf9K3nOpuN11mceL8TlbcOiJObJs7QGPTx9sf9WdDJ9GUx4BEmPXg5iyZ3NBjjBItPaOWsgDz9qzU5Z0lCRP27fKUuFauzDNj5muwSELlrQCwKLSHNVTdCJ3xhNLm+Fp0xhqMST3b5oK15oODVXP7qeZODAQBBt3dtL5VfyRhAQW8UZJiP9vfb9ecY7RNh2JSJpU1wfEMMoNf55XOJqWNbVoa9Y50qvdLLwHvmqXyXwBnlbk+Hiu2RPFkfZRxWNHFjYmcMKwdFEWrtsXAPIOQHumh1V3d/S/+MeLCUYkCTRizwfEcpyFhxovXR+v0TrVGp2AZxskqa3pn/0GKt/+pBB7W+8Z7T9EEZ66I3f40F+nrdh13StEno8ALSey5RGg1lJ94wse92szzxvePquxmjNU769d5/Pvd5ZPjKhyLxOP4QKdijHD26lKZtVSOUlb8vugcePzBipelKb+qkUKGjMmWorMgIaWmR+ujh4Yit1TTK57+0yWDvvoDdDs+pq6QcyeoHv8MOUyXwLKELQokN84RfvR1sQO76cU0FNDXJTQ5cWtJU2iFEgq/vXAG8pSd
 yTOhd9X5
 jprdFojkGWlhODJsCRRDsdd5aSIxgp3jOljXRIp0Kvvs0BBr3mAKCIvZbxa1M7j/mHJRRGgKlfnVOiHAl83o4NxZx3TmU4BRpGu40PogTAnKsfZrXJqeqc08fcrk+0WF1QEkn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.10.25 10:25, Lorenzo Stoakes wrote:
> On Thu, Oct 16, 2025 at 10:22:57AM +0800, Huang, Ying wrote:
>> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:
>>
>>> On Wed, Oct 15, 2025 at 04:43:14PM +0800, Huang, Ying wrote:
>>> OK this is great, let's put it all in the kdoc for the new shared spurious
>>> faulting function! :) and additionally add it to the commit message.
>>
>> Sure.  Will do it in the next version.
> 
> Thanks!
> 
>>
>> [snip]
>>
>>>>>>
>>>>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>>>>> index 32e8457ad535..341622ec80e4 100644
>>>>>> --- a/include/linux/pgtable.h
>>>>>> +++ b/include/linux/pgtable.h
>>>>>> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>>>>>>   #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
>>>>>>   #endif
>>>>>>
>>>>>> +#ifndef flush_tlb_fix_spurious_fault_pmd
>>>>>> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
>>>>>> +#endif
>>>>>
>>>>> flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
>>>>> flush_tlb_page() - why do we just do nothing in this case here?
>>>>
>>>> Because all architectures do nothing for the spurious PMD page fault
>>>> fixing until the [2/2] of this series.  Where, we make it necessary to
>>>> flush the local TLB for spurious PMD page fault fixing on arm64
>>>> architecture.
>>>>
>>>> If we follow the design of flush_tlb_fix_spurious_fault(), we need to
>>>> change all architecture implementation to do nothing in this patch to
>>>> keep the current behavior.  I don't think that it's a good idea.  Do
>>>> you agree?
>>>
>>> Yeah probably we should keep the same behaviour as before, which is
>>> obviously, prior to this series, we did nothing.
>>>
>>> I guess in the PTE case we _always_ want to flush the TLB, whereas in the
>>> PMD case we otherwise don't have any need to at the point at which the
>>> spurious flush is performed.
>>>
>>> But from your explanation above re: the stale TLB entry this _only_ needs
>>> to be done for architectures which might encounter this problem rather than
>>> needing a TLB flush in general.
>>>
>>> Given we're generalising the code and one case always flushes the TLB and
>>> the other doesn't maybe it's worth putting a comment in the generalised
>>> function mentioning this?
>>
>> I'm not sure whether it's a good idea to document architecture behaviors
>> in the general code.  The behavior may be changed architecture by
>> architecture in the future.
> 
> Right, but we are unconditionaly doing a TLB flush in the PTE case but not PMD
> so let's document that to be clear :)

Agreed! That's a big benefit of merging the code, it sticks out what is 
not common already.

-- 
Cheers

David / dhildenb


