Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3595CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 01:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3B28E006B; Thu, 18 Sep 2025 21:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3A28E0008; Thu, 18 Sep 2025 21:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1018E006B; Thu, 18 Sep 2025 21:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D8428E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:49:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D8D011DEF47
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:49:52 +0000 (UTC)
X-FDA: 83904318624.04.8170F9F
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id 72E7840002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:49:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cWumoCAA;
	spf=pass (imf27.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758246590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fv0q4qA7eP0AR3sRC9OtS2AhAgZlyXcwAsWIEHWfVRE=;
	b=6JegxwUTExG+mlTYjc0NTGUb3qc41ZbDA1+j7UDGAMn5vyHPhuh6696EGPY9tJ6C4i18aw
	64axdLbi0RS6PeeVuI0URusGAsSQ4A+9zb4DiGtLim7LR6zOhEtNpRO+hqbYUlC7yGJBSm
	Na/kDD9AotW1f5v32fDnDZbnL/MCJlc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cWumoCAA;
	spf=pass (imf27.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758246590; a=rsa-sha256;
	cv=none;
	b=k32QGz0AucL9XxVPBkPJq23MbSsIpcZFfNl9QgQa+65yx2Nx2L8LmdWpKDJ7pSK5HbrtIL
	r3+gDFBR7jZymjlZqBBYTOaY3PXFTQ6+Wy1FUbTx9rlLVb0ZSbIYcelilytm78ScY+lI8l
	TkEMROSymRh6mWpve3+BHyz4kJ8VFLA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758246586; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Fv0q4qA7eP0AR3sRC9OtS2AhAgZlyXcwAsWIEHWfVRE=;
	b=cWumoCAA8KHCFLCM8kx64UYS4cVvThdeP1JqggBuxBPBluurT1MsBYsl8XeNbMlcGXACIpjnR9QRNbQ24H6kgeIMTSK5OO3AOU3JQzNNkeoe6p6PIwmbdhXEhjG40MDZXqnKq4+36A5iNe7cyyq26A9jOYWMvbEtoPWcL/BO4wg=
Received: from 30.246.178.33(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0WoHtPDa_1758246583 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 09:49:44 +0800
Message-ID: <c06b1e71-2b9e-4863-a000-357010f4db64@linux.alibaba.com>
Date: Fri, 19 Sep 2025 09:49:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: Kyle Meyer <kyle.meyer@hpe.com>, jane.chu@oracle.com,
 "Luck, Tony" <tony.luck@intel.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
 surenb@google.com, "Anderson, Russ" <russ.anderson@hpe.com>,
 rppt@kernel.org, osalvador@suse.de, nao.horiguchi@gmail.com,
 mhocko@suse.com, lorenzo.stoakes@oracle.com, linmiaohe@huawei.com,
 david@redhat.com, bp@alien8.de, akpm@linux-foundation.org,
 linux-mm@kvack.org, vbabka@suse.cz, linux-acpi@vger.kernel.org,
 Shawn Fan <shawn.fan@intel.com>
References: <20250904155720.22149-1-tony.luck@intel.com>
 <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3>
 <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3>
 <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
 <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
 <aL8rIgSImDh7Nj7E@hpe.com>
 <7d3cc42c-f1ef-4f28-985e-3a5e4011c585@linux.alibaba.com>
 <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <CACw3F50hU3BCP=A++Dx_V=U8PKvsTvTa1=krULxfQdeK2kVBrw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 72E7840002
X-Rspamd-Server: rspam05
X-Stat-Signature: to3zzqce1oo4qrnderqaa3t7aubxzex3
X-Rspam-User: 
X-HE-Tag: 1758246589-935238
X-HE-Meta: U2FsdGVkX19TzzCEi6AmgMkQNYPjKWNK2C/ybJ+NIzObHkR/wN6Pc56DCCr8Q9ZwPZyVmRTPmCvF21c5r/kdJelSfygu/zoYYk/3f3iwQJ0WFEnzYQoOKWT5zf51XesKGTbcTYKKm1elK1zc4cxtFyK9wsa+DTXZSNYcieAkRSB06z/xXI8jkb/QteGvoCy6Zoom6yqzMpW0mjpUrP1L5XpvkDbnLM51uUnScNr2Vi5higmNj9UwK2YQ1U/JQGsDKML+DAdhzuohaZLIJs4nVSchluOJIF1sey9nxNv36J0BTajskZ6T8TekwgR3Q6/iYfezIPX9NGjLd1856avf0BwAU0lsx5yxAO76/47s0prWPkW2nCrNcbOXZRHYGrO44caPuS5Q3+oVwbXEqgOEEjSaNu0VWO9M1iZLPLI25F8gVtCp/kWHyEDMRjeEGjphEvwtGr5oy0Dw9BS5BVWcfwLiSATaRNabXRbB1hdKDMs59O8p70cQQx9Hngc9L7jshQ7BtIxgJKW441edfbkoXqiBt/7JwLmYY0LtQp9IPQZ7l/+jRBwh12AU7bfzHxswDuFtQ/NJvWaty2HirrsdxjeOtYeG6957bygPC+qh/S0q+TJi83z4BpVS2Aju0XTr48OPjAGv7tEbipMEMPlbtDdmA0zVfIPu9ZPgCcC1H/aosbJ+qSRKPROB7RXfl9U9HAUywAuzi+SyXZvsOmLJZdUhKaxRjpbGJHNh3Qu2Ui2BRFWC6HaoVYvydAtoZIYuRt+CGXTVnPkxUR8KTvVKsPbySf7PINTHJfJL1qYHCfC1CbozXyt8YI8DRPRkWlxzKORDOW4rfEYolqWgXumcnQzUocjv/jKMXx2VSDhfaq2bNNhwjEShUrT9dN6hs13rLHUYn8rYyMqoMTVlUZUlwqGAIbHu/3kykGQu+6GIGa1BYFCYY+8xJflIaKI8EQWIa+SGrlrZoZLtXM421Zq
 Q7F10kXC
 YkCbSajHL6WnFdyAxeyh49CG9wzfuWQxVBmbhxe0KAn4k2YazqAUYbkhk3jsUu0G43YHfSBkn/gvTgJT1vbA8JycmDJnEkS8J2+ckKYBUY9oDAcb4wfuPczOJZXfykMtwMISP5K5mcUYiVH/0NNOchZBeNYF6rhWStcvh1XWJ0qjGioutFd1IiumQMt6ORnsaQt8Ak+bzCxe+Am2unGoxKtJnjNvM+n2F5qIdwG4f09X2L+iwhi/WIbsOaEsBDaNRtLqnpoKWC0RnaxBuALiPt6MB7hDL6Kv/7CU5z8dCcTWKhqkspmOCnFYZAITol2af7yhlrFPiVQxKWgVRWvxU+lXaYASRkaLhp9EjHkJH9F+WhWuU7Izp7jANAhWBJ5bWn+ZGSxHF8L0p0TS+0ToUYW/TM6xKR9DlC7X4kmpzczfnHMvYfcXajc3a4oo0rMkzriN5IgIh2we/kAmrUo8q2HScLuXoFLNYbb7Mb09u7zJ+3rs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/9/18 23:43, Jiaqi Yan 写道:
> On Wed, Sep 17, 2025 at 8:39 PM Shuai Xue <xueshuai@linux.alibaba.com> wrote:
>>
>>
>>
>> 在 2025/9/9 03:14, Kyle Meyer 写道:> On Fri, Sep 05, 2025 at 12:59:00PM -0700, Jiaqi Yan wrote:
>>   >> On Fri, Sep 5, 2025 at 12:39 PM <jane.chu@oracle.com> wrote:
>>   >>>
>>   >>>
>>   >>> On 9/5/2025 11:17 AM, Luck, Tony wrote:
>>   >>>> BIOS can supply a GHES error record that reports that the corrected
>>   >>>> error threshold has been exceeded. Linux will attempt to soft offline
>>   >>>> the page in response.
>>   >>>>
>>   >>>> But "exceeded threshold" has many interpretations. Some BIOS versions
>>   >>>> accumulate error counts per-rank, and then report threshold exceeded
>>   >>>> when the number of errors crosses a threshold for the rank. Taking
>>   >>>> a page offline in this case is unlikely to solve any problems. But
>>   >>>> losing a 4KB page will have little impact on the overall system.
>>
>> Hi, Tony,
>>
>> Thank you for your detailed explanation. I believe this is exactly the problem
>> we're encountering in our production environment.
>>
>> As you mentioned, memory access is typically interleaved between channels. When
>> the per-rank threshold is exceeded, soft-offlining the last accessed address
>> seems unreasonable - regardless of whether it's a 4KB page or a huge page. The
>> error accumulation happens at the rank level, but the action is taken on a
>> specific page that happened to trigger the threshold, which doesn't address the
>> underlying issue.
>>
>> I'm curious about the intended use case for the CPER_SEC_ERROR_THRESHOLD_EXCEEDED
>> flag. What scenario was Intel BIOS expecting the OS to handle when this flag is set?
>> Is there a specific interpretation of "threshold exceeded" that would make
>> page-level offline action meaningful? If not, how about disabling soft offline from
>> GHES and leave that to userspace tools like rasdaemon (mcelog) ?
> 
> The existing /proc/sys/vm/enable_soft_offline can already entirely
> disable soft offline. GHES may still ask for soft offline to
> memory-failure.c, but soft_offline_page will discard the ask as long
> as userspace sets 0 to /proc/sys/vm/enable_soft_offline.
> 

I see. Thanks.

>>
>>   >>
>>   >> Hi Tony,
>>   >>
>>   >> This is exactly the problem I encountered [1], and I agree with Jane
>>   >> that disabling soft offline via /proc/sys/vm/enable_soft_offline
>>   >> should work for your case.
>>   >>
>>   >> [1] https://lore.kernel.org/all/20240628205958.2845610-3-jiaqiyan@google.com/T/#me8ff6bc901037e853d61d85d96aa3642cbd93b86
>>   >
>>   > If that doesn't work for your case, I just want to mention that hugepages might
>>   > still be soft offlined with that check in ghes_handle_memory_failure().
>>   >
>>   >>>>
>>   >>>> On the other hand, taking a huge page offline will have significant
>>   >>>> impact (and still not solve any problems).
>>   >>>>
>>   >>>> Check if the GHES record refers to a huge page. Skip the offline
>>   >>>> process if the page is huge.
>>   >
>>   > AFAICT, we're still notifying the MCE decoder chain and CEC will soft offline
>>   > the hugepage once the "action threshold" is reached.
>>   >
>>   > This could be moved to soft_offline_page(). That would prevent other sources
>>   > (/sys/devices/system/memory/soft_offline_page, CEC, etc.) from being able to
>>   > soft offline hugepages, not just GHES.
>>   >
>>   >>>> Reported-by: Shawn Fan <shawn.fan@intel.com>
>>   >>>> Signed-off-by: Tony Luck <tony.luck@intel.com>
>>   >>>> ---
>>   >>>>
>>   >>>> Change since v2:
>>   >>>>
>>   >>>> Me: Add sanity check on the address (pfn) that BIOS provided. It might
>>   >>>> be in some reserved area that doesn't have a "struct page" which would
>>   >>>> likely result in an OOPs if fed to pfn_folio().
>>   >>>>
>>   >>>> The original code relied on sanity check of the pfn received from the
>>   >>>> BIOS when this eventually feeds into memory_failure(). That used to
>>   >>>> result in:
>>   >>>>        pr_err("%#lx: memory outside kernel control\n", pfn);
>>   >>>> which won't happen with this change, since memory_failure is not
>>   >>>> called. Was that a useful message? A Google search mostly shows
>>   >>>> references to the code. There are few instances of people reporting
>>   >>>> they saw this message.
>>   >>>>
>>   >>>>
>>   >>>>    drivers/acpi/apei/ghes.c | 13 +++++++++++--
>>   >>>>    1 file changed, 11 insertions(+), 2 deletions(-)
>>   >>>>
>>   >>>> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
>>   >>>> index a0d54993edb3..c2fc1196438c 100644
>>   >>>> --- a/drivers/acpi/apei/ghes.c
>>   >>>> +++ b/drivers/acpi/apei/ghes.c
>>   >>>> @@ -540,8 +540,17 @@ static bool ghes_handle_memory_failure(struct acpi_hest_generic_data *gdata,
>>   >>>>
>>   >>>>        /* iff following two events can be handled properly by now */
>>   >>>>        if (sec_sev == GHES_SEV_CORRECTED &&
>>   >>>> -         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
>>   >>>> -             flags = MF_SOFT_OFFLINE;
>>   >>>> +         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
>>   >>>> +             unsigned long pfn = PHYS_PFN(mem_err->physical_addr);
>>   >>>> +
>>   >>>> +             if (pfn_valid(pfn)) {
>>   >>>> +                     struct folio *folio = pfn_folio(pfn);
>>   >>>> +
>>   >>>> +                     /* Only try to offline non-huge pages */
>>   >>>> +                     if (!folio_test_hugetlb(folio))
>>   >>>> +                             flags = MF_SOFT_OFFLINE;
>>   >>>> +             }
>>   >>>> +     }
>>   >>>>        if (sev == GHES_SEV_RECOVERABLE && sec_sev == GHES_SEV_RECOVERABLE)
>>   >>>>                flags = sync ? MF_ACTION_REQUIRED : 0;
>>   >>>>
>>   >>>
>>   >>> So the issue is the result of inaccurate MCA record about per rank CE
>>   >>> threshold being crossed. If OS offline the indicted page, it might be
>>   >>> signaled to offline another 4K page in the same rank upon access.
>>   >>>
>>   >>> Both MCA and offline-op are performance hitter, and as argued by this
>>   >>> patch, offline doesn't help except loosing a already corrected page.
>>   >>>
>>   >>> Here we choose to bypass hugetlb page simply because it's huge.  Is it
>>   >>> possible to argue that because the page is huge, it's less likely to get
>>   >>> another MCA on another page from the same rank?
>>   >>>
>>   >>> A while back this patch
>>   >>> 56374430c5dfc mm/memory-failure: userspace controls soft-offlining pages
>>   >>> has provided userspace control over whether to soft offline, could it be
>>   >>> a more preferable option?
>>   >
>>   > Optionally, a 3rd setting could be added to /proc/sys/vm/enable_soft_offline:
>>   >
>>   > 0: Soft offline is disabled.
>>   > 1: Soft offline is enabled for normal pages (skip hugepages).
>>   > 2: Soft offline is enabled for normal pages and hugepages.
>>   >
>>
>> I prefer having soft-offline fully controlled by userspace, especially
>> for DPDK-style applications. These applications use hugepage mappings and maintain
>> their own VA-to-PA mappings. When the kernel migrates a hugepage to a new physical
>> page during soft-offline, DPDK continues accessing the old physical address,
>> leading to data corruption or access errors.
> 
> Just curious, does the DPDK applications pin (pin_user_pages) the
> VA-to-PA mappings? If so I would expect both soft offline and hard
> offline will fail and become no-op.
> 

I think these does. We encountered this problem in older kernel
versions. However, since it's application-specific behavior, I agree
that using enable_soft_offline for userspace control is a good solution.

Thanks.
Shuai

