Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87850CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 02:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C046B0092; Wed,  7 Oct 2026 22:14:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719EE6B0096; Wed,  7 Oct 2026 22:14:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 604296B0098; Wed,  7 Oct 2026 22:14:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3F56B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 22:14:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE3D5140441
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:14:22 +0000 (UTC)
X-FDA: 85297839564.04.17D6BE4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0BEA9180003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:14:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cW3OC8/a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791425660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUUWn17KT8+7jjp2RfjC1mY2FecZ1lvMH6OaztmS8Jo=;
	b=iAmJXG1DUa69hkzf267ErtzUHo6aI2VPQTbLOJ5LEsiZy3Z7GTlINuRNQdmXdgP4FFkJgx
	ug+FSAj+Efcd7qbtJ73h/4+flK223rmS8vdoreaOd+wCIjGur9GvH8mQhzc0eoUilLl3dQ
	cnmQsz1a93bsAQqW/Csi15yIigmqoBQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="cW3OC8/a";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791425660;
	b=gmE7g6jvGiaSzfcPq5Q/z3EVL4w164/chGACWVOGHH64rpWmgp0vtruGLddpCLyp5ecCmq
	soIUudnwdBtleL9psnPIPgznvIYnky+WRCZEs4KPFU4P022in7fmnAWAS4JqAfay1js8EO
	b6Cs7c0TPWluhqTfCuZ0hX1VHYu/BW8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791425659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uUUWn17KT8+7jjp2RfjC1mY2FecZ1lvMH6OaztmS8Jo=;
	b=cW3OC8/a6JrPugVr4XjJIo/c6erYHqHq0OKEOAkrJHnzp/cnZjsZiyZVMP/ks95dVRuTDo
	vMMSpaQI6PtQwHJWq/xBu6oSR3qT5oFMTLjuX71MjLlEXlKxuwl15KgDp/hmTyBIv5gJxk
	ZkgkBHoqdcjGV4BxvhkaaxBfrN41nzE=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-_oKi94i6N0aaVTZ4XknBFQ-1; Wed, 07 Oct 2026 22:14:18 -0400
X-MC-Unique: _oKi94i6N0aaVTZ4XknBFQ-1
X-Mimecast-MFC-AGG-ID: _oKi94i6N0aaVTZ4XknBFQ_1791425658
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-9106fce784dso102842346d6.2
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 19:14:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791425658; x=1792030458;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uUUWn17KT8+7jjp2RfjC1mY2FecZ1lvMH6OaztmS8Jo=;
        b=1xFGgruDV3Yto+qVZIOgrk6iKKmYtL7qIqXuOcWJGE6wR5mvrPxr43Dnn5Sl+Xb0AH
         M3D17MCUK7chvQ4HDFxI05eEatdxGnNu39SR8w8gnG+roppx6yrFW36UEBiwgzALMetO
         TWUeEABFZRSU1EXjEqerjaE+Uji1t/51+t4bqLo3jewq2PJke+wYjw4F6yb8T705b9vn
         OMUsD6PgUALH3Pxn4rE2IGtfVomJqrtrQX/zQeqP66eVBtZR4FTaF2bT57yYWNG5NHsF
         uDVqMdVaSRNVJ2Srmb9OUGREfBNAjMgRrdxC78HBy0CEZeRos6rwUqJ5q4rjBg9ZB22r
         TIrQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFXi4j8hXFgSF6gpDnzQxRqp8j4KDzOw617e6LEvyG2UFa7HkFFSghpkh4dz78NFPjQr377s5mLg==@kvack.org
X-Gm-Message-State: AFq9FYKg/WdnbPowQ1Tys55JrdtmNtCfsKeEywNvcklIBJT5YE+/kOQw
	zvtw++BPWqe5k9c6B8y+a1t3JnUfnlw56zyUqQG83Kqpcc3jffq2C1q9jobqDu7GTU4XdhjUFhN
	svLOT1MMkn7ameKEljOzcEPQavgWqdLzBgxPQ63hh6ByP2xIM2Hte
X-Gm-Gg: AYBFou3YfDMirikvwOpvhAiWPpqBiKi7Wtp+QUn0u2z33kI0xU0CJbxR/s9LdmZvure
	nqrjefTWP0tXFq3y8r/PJ/FhCzdL7irg9Ys3BoV54OQlFiJg8GzjGl+6wmUy3Tv0g2UMgZbJ0dd
	2H7MjPmJz8uUDLeg+vUjbRjvRq4+FJArkVDgUDsnmfTlfpwo9BNE/spF7mIt2UvISIe+JIIo01q
	ic2hZ20N8c5+NoOx+kCDIsjTeDyVujAXYdtem9HiwcYbmeR6+7ANYa9NaFw3bPnjJF6QVyCR/E3
	g8w1Z23lKA/Mm0f8XVK3lXKnkExiWWK4LpRX1eZYOP9bBptfPNVir8beHUujDB6d6OsMylbLcIF
	33Vw=
X-Received: by 2002:a05:6214:29cd:b0:919:952d:f5bf with SMTP id 6a1803df08f44-919978a1398mr75159316d6.57.1791425657674;
        Wed, 07 Oct 2026 19:14:17 -0700 (PDT)
X-Received: by 2002:a05:6214:29cd:b0:919:952d:f5bf with SMTP id 6a1803df08f44-919978a1398mr75158896d6.57.1791425657213;
        Wed, 07 Oct 2026 19:14:17 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91996d47f6dsm35515866d6.33.2026.10.07.19.14.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Oct 2026 19:14:16 -0700 (PDT)
Message-ID: <11295e45-c1ca-40d6-9d21-dd118cc1bce0@redhat.com>
Date: Wed, 7 Oct 2026 22:14:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 07/14] mm: shmem: allow THP support determination at
 folio allocation time
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <f74ada750d1910f8ea7e55955eb0c330747b93d4.1789695931.git.luizcap@redhat.com>
 <b63f546b-ee92-46c3-85bd-bc64dbaae367@kernel.org>
 <0162d0f5-8e75-458b-a0a1-6071f46d4b35@redhat.com>
 <a14c2287-8d7f-468d-b0d4-1d445d2be277@linux.alibaba.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <a14c2287-8d7f-468d-b0d4-1d445d2be277@linux.alibaba.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: SoTzzaasrxtOH5vRyR2sBgtpjS0l19IpzoOK3roFCrk_1791425658
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0BEA9180003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: au1fjikj19g5dkqrjmzbicmiks7utu6p
X-HE-Tag: 1791425659-456753
X-HE-Meta: U2FsdGVkX1/RPRHBInJDYQApQ63RantvTssR2S0WRCewlo9hHu0hd5MW0+zfHN0JHGLFa9HZoXhAfZoqOTReFcnw8LPCB3OSJmW/RG5UlEnGMtaBF4RYVoITShIYvt2ghQYdgj9a7EnrfP47yh+6rx4TgE0BCdzhSW4ZdPqPA0YQtzjfII+E3ej53BGErO+VoCLC386Nah0HzYpaH0368v6nMTuYEzufABYwtrqpjTi+yncDGwiMFMXT34g5ZSSAOkEo4B/oUyC5NUEmtTqyM0hSwC25cL+DoQjKBx/SFw3CVb6FCeE0L7pk/IbWDc5nQpvuSakWRTTTA3bY2FpAN8c2DcOrjyM2frsDck9oylWAJoFrdM2nX5j8tIpLn1LlDoy4c+JhRMSdrPoIhAeA/QcTciwaA7CvVjlimijBk0rvTtjrnetOO+VFthyNOaEPSmmiNBk0HDUCBzAVIN/5VgbJrEG3Btamn7lJm6tIcOcuQz8JgyupJ3tnUqFJIQld02E1WpMXBW5gBQ7x2tPqzn0aAtU1SmxNavtw76r7s4Y3i9CD1x9AyaFIryCAfvmHnrKvlxaYKmroCVtLr4OUG+VLwqimWD8r41SC9X07iahBTPbqBc3szQJ29Dwzj9AHCpBMJF/7wKrYJEOGmj9kVpVQTTX1dKha5nNZ8axxqdXJtgZmQUUO4oHEj7kN15CIk2bcJbJvpcV7vuPL7DqziDzAc4EZFv+ia4OIjpiDJ3NgWEZyVhqvtwsgu/W5W1pDAHpxjiPpzLDUr+GWHp/YcG0fq8z7YS07QNOmIT8fKJShqbFL3GBNta79rGX+tPp1n1OMKVxc15tL+vTKgZLYBDvlx+jqUe6wsHPrfqv4w0g9YMTNylllEkAB+TBwyaX/ig9vUvAAqsPXuzP+oQ7PsW7+WA+pJlsTvr8CJNw9hJV8nKjM7DqUTZKGqzDcRnyztwQQsubCeAP3FQUjFsm
 lXS7mKi5
 TPoMveOYvitt9jxOjEfiE69yHiJqyUyvBRJiijMkSh016/e+UzJ+AnPLFzT6KuFuDCMrY9vXBHcbmGfMi4LVHTQVUlySJkksjTNOxz63942dJyI56w3JKQ7TnxrUkZBehGm1d+exWHc12ecEYEvmw4+M7g7zOVI1ntmnCzaKp1Or8LRXtaWQlsRsgrcbrcrEw1t6GKvT7MUG4kE3opazyJ0XQx8GkjDki+cZ/LuczpY22HXfYqidz6xdcqlerxGRt3HOeG6hOxvxXEakb4zw8uy30Hc87L8jP+ZXIu4wu+935iz6+LbLMigVUhaCF22agRlybLRk3Ls/hacqNkTWjw3zHFIOLJ+2H6pghcMdoJYGWXOHLFQIWfpfMDcfeTfUcTpin
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/7/26 9:50 PM, Baolin Wang wrote:
> 
> 
> On 10/3/26 11:09 PM, Luiz Capitulino wrote:
>>
>>
>> On 10/2/26 3:23 PM, David Hildenbrand (Arm) wrote:
>>> On 9/18/26 03:45, Luiz Capitulino wrote:
>>>> In order to enable THP support in shmem today, besides the user
>>>> configuration required, the CPU must support PMD-sized pages. This
>>>> is the case because of the following has_transparent_hugepage()
>>>> usage:
>>>>
>>>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>>>    if the CPU supports PMD-sized pages
>>>>
>>>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>>>    the code block calling has_transparent_hugepage(), the
>>>>    has_transparent_hugepage() call is exclusively checking if the CPU
>>>>    supports PMD-sized pages
>>>>
>>>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>>>> in all cases, shmem can determine THP size support at folio allocation
>>>> time. Therefore, drop the has_transparent_hugepage() usage listed above
>>>> while keeping the CONFIG_TRANSPARENT_HUGEPAGE checks.
>>>>
>>>> Additionally, we need to check if PMD size order is supported in
>>>> shmem_getattr(). Use pgtable_has_pmd_leaves() for that.
>>>>
>>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>   mm/shmem.c | 9 +++++----
>>>>   1 file changed, 5 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index 776dff8a848e..930657d05375 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -690,7 +690,7 @@ static int shmem_parse_huge(const char *str)
>>>>       else
>>>>           return -EINVAL;
>>>> -    if (!has_transparent_hugepage() &&
>>>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>>>>           huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>>>>           return -EINVAL;
>>>> @@ -1524,6 +1524,8 @@ static int shmem_getattr(struct mnt_idmap *idmap,
>>>>       generic_fillattr(idmap, request_mask, inode, stat);
>>>>       orders = shmem_huge_global_enabled(inode, 0, 0, false, NULL, 0);
>>>
>>> I'm curious: why is that not handled inside shmem_huge_global_enabled() ? If PMD
>>> order is impossible (well, okay, it is possible, but we simply cannot map these
>>> things through PMDs), I would expect that we never list them as "enabled".
>>
>> Yes, you're right. What about renaming current shmem_huge_global_enabled() to
>> __shmem_huge_global_enabled() and then having:
>>
>> static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index,
>>                            loff_t write_end, bool shmem_huge_force,
>>                            struct vm_area_struct *vma,
>>                            vm_flags_t vm_flags)
>> {
>>      unsigned int orders;
>>
>>      orders = __shmem_huge_global_enabled(inode, index, write_end,
>>                           shmem_huge_force, vma, vm_flags);
>>      if (!pgtable_has_pmd_leaves())
>>          orders &= ~BIT(PMD_ORDER);
>>
>>      return orders;
>> }
>>
>> Would this be acceptable?
> 
> Not a fan of re-adding the wrapper. I think you could refer to the changes to shmem_allowable_huge_orders() in patch 14 and filter out the 'disabled_orders' in shmem_huge_global_enabled() directly.

OK, I'll look into doing this.


