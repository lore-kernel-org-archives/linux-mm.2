Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97128C87FC9
	for <linux-mm@archiver.kernel.org>; Tue, 29 Jul 2025 13:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 287DC6B0092; Tue, 29 Jul 2025 09:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EA56B0096; Tue, 29 Jul 2025 09:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1744A6B0099; Tue, 29 Jul 2025 09:52:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09B1A6B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 09:52:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B137140564
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:52:28 +0000 (UTC)
X-FDA: 83717441976.01.8759752
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf18.hostedemail.com (Postfix) with ESMTP id CAD011C000F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 13:52:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753797146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsK9L872Qkj26oGqeFB1SIud0TJmKPl61Td/yI0WZG4=;
	b=F3VtzMl3q3B7SWQqdUswDcbxhmHhZWCDP2x5ZR+mjJgTUUPaFBydTQmlp+yKHwV1gRMxaH
	4Tbsy/qMTK88PdAigugxSelueKFfFwSYJytr5PmtEoQiLdVB+CFDyxznEuPLJRx3VWZNy2
	YHDSLQPE5Hhi/eToHk40I1UMDAqh+cw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753797146; a=rsa-sha256;
	cv=none;
	b=1vy+LV9TbGuY/hKtuspE3LYxfthtqkWiGW3Dit/JHI+pYi6PnxadlyWgNGZX5Ag4EoB3En
	bI0ms9qRD47nr5t9okngEHsDwzvYYozZnuaNV3GbiK4BerqNXh++HuFNL5qf7JwaTdmXhf
	i6kMBTb2tk2R9CrvfM7avLVxPuvpi5A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf18.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4brxYM0kHTz2RVvZ;
	Tue, 29 Jul 2025 21:49:59 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 561E21A0188;
	Tue, 29 Jul 2025 21:52:20 +0800 (CST)
Received: from [10.174.176.250] (10.174.176.250) by
 dggpemf200018.china.huawei.com (7.185.36.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 29 Jul 2025 21:52:19 +0800
Message-ID: <ab6b06d6-d2e8-4695-9eda-5bfaf507c2f1@huawei.com>
Date: Tue, 29 Jul 2025 21:52:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/damon: add full LPAE support for memory monitoring
 above 4GB
To: SeongJae Park <sj@kernel.org>
CC: zuoze <zuoze1@huawei.com>, <akpm@linux-foundation.org>,
	<damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250726171616.53704-1-sj@kernel.org>
From: Quanmin Yan <yanquanmin1@huawei.com>
In-Reply-To: <20250726171616.53704-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.250]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: CAD011C000F
X-Stat-Signature: odf6gq7nkwu4stra9ocjwbm78yzaiuqy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753797145-192906
X-HE-Meta: U2FsdGVkX1+gWv3Rrx2QuBzpvGv4E66q+2WHwgERK/7Lppw4BDLs318JXaq6kjDV/dCm31PiWEZbpTdCQEtcpIs0mGBRUZh5vmioSpm+FV3Vakc3rXhaNEIyLZl3SK7BUcVIX0iYnjo6fnWcotdx5UcKTAgyAvLnmXloZS8Z3A5GkNIVoyjTv8IcQB5EaTR350zf71tViwIyYPMH/cjjkLQBxe5Hhk8GwdHWW2tXYqBhPOePk6MaXRJoNz3Dt16u944bWVUnjF+xS/n0QPnDCgfE7Pa2Mfr9CTSaDfd9LMIRpI1PjbmAgw7Ma+NHjjj4e/qaXQbpOg7dsjfcLcr1hzMFzpPHE4zFzq67uRNkOrk/2vvHLuU8q/eeYkjJzD7ow3AhRGULPgXZ1SGPFXRiDzJ/4QF+RiX3vv/jQ8nx/3upvBya6kRG7fmPptMkF6LhatLbOhVMhYqU3zENchQRzsDJEcQ0qrhs1EmCOSUKNmOQlVV65icm2Q6K21DfFDJkQLQ3BTcoWNT+Wq0f2iWy9lw0oW1PN2z9DOOTa8HutZaYJKx00rGGLHuujq2WIOzcOFe4Z2vMphsoT+HX4qTwrpdT+/5ld4MWt4BIBC+9+oSf07/OSBy2+/EHX8gwTdSBTYhRz0NmilUXmNNR6K7jIJrsul3cA378KQvVpPfd8xcvJGL0PSq37gLIpzPCg+QOAEU/SHUL5X5QP1DGuQ5Q7Gvw+CsSuPLC1HL9Hv2IEex3z/PvpN0juLGYBgOr1589O0SpZ1/xYP1WX3keM+gwRzJFYemXzOkquyDMAo2mfwRckP5IZHHAk8r4pXL+5JweXvFVH/fQOx9r8YspQiM9dJ+zN/Yk2Pbid3rcUv/u14mIme+bhWV0WjgTyfxCXFeM7FiUz9r1m1JyqUWOCBx2M3T8c69BcJwaS1mkEedkRyafHCw16K/xFwuR+eeUwgf7iQnatxCoBGUBnleWCyr
 fNTSwLWC
 6vLJuz4lwnuljfAStg8gJrz+q9YE54vtYdLQzt791ApBYgbJTb7E/7U07xsnY3AsgGADV2ndtPBdUx7ZTIiByxuHRvLetgTeGgH3z5nLMwIfKneHDYKonXC3rP8ohZXJBSQRUi1x4b6EOFCr7rBLdlAxWUucEZ72Bn8hc2hJ0boo4ku2fK5pVTVk7fu2ylqCvocfL9mo9gxSRf+QvereYgR15OOa1FwWiJdSLE4eDfUUldTh/jDioJPoW2v73EfUS9UE6d7gQY33uaAM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/27 1:16, SeongJae Park 写道:
> Hi Quanmin,
>
> On Sat, 26 Jul 2025 11:14:19 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
>
>> 在 2025/7/26 4:22, SeongJae Park 写道:
>>> On Fri, 25 Jul 2025 11:15:22 +0800 zuoze <zuoze1@huawei.com> wrote:
>>>
>>>> 在 2025/4/23 1:43, SeongJae Park 写道:
>>>>> On Tue, 22 Apr 2025 19:50:11 +0800 zuoze <zuoze1@huawei.com> wrote:
>>>>>
>>>>> [...]
>>>>>> Thanks for the patches - I’ve noted the RFC series and user-space
>>>>>> updates. Apologies for the delay; I’ll prioritize reviewing these soon
>>>>>> to verify they meet the intended tracking goals. Appreciate your
>>>>>> patience.
>>>>> No worry.  Please take your time and let me know if there is anything I can
>>>>> help.
>>>>>
>>>>> I think we can improve the user-space tool support better for usability.  For
>>>>> example, it could find LPAE case, set addr_unit parameter, and convert
>>>>> user-input and output address ranges on its own.  But hopefully the current
>>>>> support allows simple tests of the kernel side change, and we could do such
>>>>> improvement after the kernel side change is made.
>>>>>
>>>>>
>>>> Hi SJ,
>>>>
>>>> Apologies for the delayed response. We've verified your patch in our
>>>> environment and confirmed it supports LPAE address monitoring.
>>> No worry, thank you for testing that :)
>>>
>>>> However,
>>>> we observed some anomalies in the reclaim functionality. During code
>>>> review, we identified a few issues:
>>>>
>>>> The semantic meaning of damon_region changed after addr_unit was
>>>> introduced. The units in damon_addr_range may no longer represent bytes
>>>> directly.
>>> You're right, and this is an intended change.
>>>
>>>> The size returned by damon_sz_region() now requires multiplication by
>>>> addr_unit to get the actual byte count.
>>> Again, this is an intended change.  damon_sz_region() callers should aware this
>>> semantic and updated accordingly, if it could make a real problem otherwise.
>>> If you found such changes required cases that this patch series is missing,
>>> could you please list up?
>>>
>>>> Heavy usage of damon_sz_region() and DAMON_MIN_REGION likely requires
>>>> addr_unit-aware adjustments throughout the codebase. While this approach
>>>> works, it would involve considerable changes.
>>> It has been a while since I wrote this patch series, but at least while writing
>>> it, I didn't find such required changes.  Of course I should missed something,
>>> though.  As I mentioned above, could you please list such changes required
>>> parts that makes problem?  That would be helpful at finding the path forward.
>>>
>>>> What's your perspective on
>>>> how we should proceed?
>>> Let's see the list of required additional changes with why those are required
>>> (what problems can happen if such chadnges are not made), and discuss.
>> Hi SJ,
>>
>> Thank you for your email reply. Let's discuss the impacts introduced after
>> incorporating addr_unit. First of all, it's essential to clarify that the
>> definition of damon_addr_range (in damon_region) has changed, we will now use
>> damon_addr_range * addr_unit to calculate physical addresses.
>>
>> I've noticed some issues, in mm/damon/core.c:
>>
>>    damos_apply_scheme()
>>        ...
>>        unsigned long sz = damon_sz_region(r);  // the unit of 'sz' is no longer bytes.
>>        ...
>>        if (c->ops.apply_scheme)
>>            if (quota->esz && quota->charged_sz + sz > quota->esz)
>>                sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
>>                        DAMON_MIN_REGION);  // the core issue lies here.
>>            ...
>>            quota->charged_sz += sz;    // note the units.
>>        ...
>>        update_stat:
>>            // 'sz' should be multiplied by addr_unit:
>>            damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
>>
>> Currently, DAMON_MIN_REGION is defined as PAGE_SIZE, therefore aligning
>> sz downward to DAMON_MIN_REGION is likely unreasonable. Meanwhile, the unit
>> of sz in damos_quota is also not bytes, which necessitates updates to comments
>> and user documentation. Additionally, the calculation involving DAMON_MIN_REGION
>> requires reconsideration. Here are a few examples:
>>
>>    damos_skip_charged_region()
>>        ...
>>        sz_to_skip = ALIGN_DOWN(quota->charge_addr_from -
>>                        r->ar.start, DAMON_MIN_REGION);
>>        ...
>>        if (damon_sz_region(r) <= DAMON_MIN_REGION)
>>                        return true;
>>        sz_to_skip = DAMON_MIN_REGION;
>>
>>    damon_region_sz_limit()
>>          ...
>>        if (sz < DAMON_MIN_REGION)
>>            sz = DAMON_MIN_REGION;
> Thank you for this kind and detailed explanation of the issue!  I understand
> adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096' bytes, and it
> is not a desired result when 'addr_unit' is large.  For example, if 'addr_unit'
> is set as 4096, the access monitoring and operation schemes will work in only
>> 16 MiB granularity at the best.
>> Now I can think of two approaches, one is to keep sz in bytes, this requires
>> modifications to many other call sites that use these two functions (at least
>> passing the corresponding ctx->addr_unit. By the way, should we restrict the
>> input of addr_unit?):
>>
>>    damos_apply_scheme()
>>        ...
>>    -    unsigned long sz = damon_sz_region(r);
>>    +    unsigned long sz = damon_sz_region(r) * c->addr_unit;
>>        ...
>>    -    damon_split_region_at(t, r, sz);
>>    +    damon_split_region_at(t, r, sz / c->addr_unit);
>>
>> The second approach is to divide by addr_unit when applying DAMON_MIN_REGION,
>> and revert to byte units for statistics, this approach seems to involve
>> significant changes as well:
>>
>>    damos_apply_scheme()
>>        ...
>>        sz = ALIGN_DOWN(quota->esz - quota->charged_sz,
>>    -                    DAMON_MIN_REGION);
>>    +                    DAMON_MIN_REGION / c->addr_unit);
>>        ...
>>    update_stat:
>>    -    damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
>>    +    damos_update_stat(s, sz, sz_applied * c->addr_unit, sz_ops_filter_passed);
>>
>> These are my observations. What's your perspective on how we should proceed? Looking
>> forward to your reply.
> I think the second approach is better.  But I want to avoid changing every
> DAMON_MIN_REGION usage.  What about changing DAMON_MIN_REGION as 'max(4096 /
> addr_unit, 1)' instead?  Specifically, we can change DAMON_MIN_REGION from a
> global macro value to per-context variable (a field of damon_ctx), and set it
> accordingly when the parameters are set.
>
> For stats, I think the users should aware of the fact DAMON is working with the
> addr_unit, so they should multiply addr_unit to the stats to get bytes
> information.  So, I think the stats update in kernel is not really required.
> DAMON user-space tool may need to be updated accordingly, though.
>
> I didn't take time to think about all corner cases, so I may missing something.
> Please let me knwo if you find such missing things.

Hi SJ,

Apologies for the delayed response to this email. Following your suggested method,
I added implementation damon_ctx->min_region, and also uncovered additional
issues specific to 32-bit platforms. I've prepared a patch series, which is
currently under testing. I'll get back to you as soon as the verification is complete.

Thanks,
Quanmin Yan

>
> Thanks,
> SJ
>
> [...]
>

