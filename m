Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AC8CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:30:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3AD28003A; Thu, 18 Sep 2025 11:30:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 573B28E00F6; Thu, 18 Sep 2025 11:30:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 462B928003A; Thu, 18 Sep 2025 11:30:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 301368E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:30:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DBBF2C0246
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:30:07 +0000 (UTC)
X-FDA: 83902756854.29.C7A3F30
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 84C8020008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:30:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758209406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XK2IhyKZnZW9qeR5LuEW76gdLYeK5oITDYIZuRfy8cw=;
	b=hXa8Anz3WB2oQNyHq3Ntc9/+8Au0cMUTh/wZ3Nbi4Sb7QwV6ND9BG+/PKUFvg6XNseoXEQ
	fbIJ98C4GR9XJ3UunYXUdhgGRuyZGqdDelnW8xHMlCKUidk6DLuh0QuL2vi9msd/7SB4me
	4HJtgQSuo91H/2x0tNLmkrPrXlFbJXU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758209406; a=rsa-sha256;
	cv=none;
	b=G8Y9/4XAJ6YfynYoKBAzSsE7HBxy786Yb2E47/tgBcdonNxvL19Kz3N+3jYzTXGvQHM8pV
	ujf8B60RiXBpZYsVVDbc0cCNEFyiBzqpSBwyqQ9UW3yR+H4eBitnwiNKUAhpIgh8QoVmkE
	oZGgVgoMkwpX4ePxw/Ghw8g9dK8LzY8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 474C3176C;
	Thu, 18 Sep 2025 08:29:56 -0700 (PDT)
Received: from [10.1.33.171] (XHFQ2J9959.cambridge.arm.com [10.1.33.171])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 563263F66E;
	Thu, 18 Sep 2025 08:30:02 -0700 (PDT)
Message-ID: <960fbbba-8018-4e42-b1fd-6ed96c148007@arm.com>
Date: Thu, 18 Sep 2025 16:30:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 5/5] arm64: kprobes: call set_memory_rox() for kprobe
 page
Content-Language: en-GB
To: Yang Shi <yang@os.amperecomputing.com>,
 Catalin Marinas <catalin.marinas@arm.com>
Cc: will@kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, ardb@kernel.org, dev.jain@arm.com,
 scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-6-yang@os.amperecomputing.com>
 <aMv_nhEuCSHKp5J6@arm.com>
 <22732cbe-20f8-4d1e-b086-e34d0f9bbb35@os.amperecomputing.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <22732cbe-20f8-4d1e-b086-e34d0f9bbb35@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 84C8020008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1iz6bmry4r9zino3ohcn4oekmbcahd1h
X-HE-Tag: 1758209405-525925
X-HE-Meta: U2FsdGVkX1+pUjwG2JIswFIYM6a1uY0Ih8wXePtrC+QwQTy64WbZRlIU5rVvaQ29uwe3WnFPa9e+ybjz62DSer+G0rwxGrRDEo00EDcS5Z9gn8MOwJ0AspfO1hAwNVDFafX8nU52/f5YLpuAmvPIAo1+bLpmHA/Motnu2ve8WxMCwGKCrWS6DR5+enswo+pFpKG6xYotk1YVQQ4GNPQ6Jy/2gxNv+EppHY7uU85DI31z2WCUpdytM8wMZpdmsetzzUM/Y5ecmOIgtgGzSMj4pyJ/QzXxZ4IWGLYQKLEbFEXABECAVIshsxw9TZbmkk1cFEOPmDY08LK5vmQ43vzH4w58GjP3ucbE/peidVKLqSfgSRUtWY1ypk1Y924MyPc+dzBzxfLmRxShvFNTX4S4YzVM4bowjQIySpjrX66wL51r0VQsapx+vZ9kQHqj1fTUqdrvYVYts2hb1C0b/wlmikwNNzbAFpj/Hs0VpVWA3DYb/zcVxAzelGy5Zyhf9oN0LeZUtYN2rSHSoDJOvU9NGjZ/OcHl3CkzJmtAKLST93eyHSTV8i7DMONkmEo1Rr3H+yV6JyorsRFHC5BErfmrRIRJtQ5BJ1eL8hTjIkKjRoBlh9HiXa9Psz0Z5kIcwIdTR1+I2onV66L4ShI97Maqk3bDrI5evQT+HWGLQTiGww2qS/oeLBMQNHwK+JswkuJv8nc5znwmXNm/0AehGNPR6DKhwvOa1lShV4afU7h8tWGTBx1/AQ9XgsQwSgR97PhutGzssHNP/3SHoOTdgz7rbCLoa1xhcf04veqXwC1nWwDaPiZVKKAcxZ8/CzQrhqzP/DdbdgHvlwd71ZAA6H/i2wNmm9kbieyi3uUzF/kG10G4WU5hMX4LmOj6MwaP1txoCQezQgTjhK4jJbg5UjcCln3C/F/VTedhkXHW64NIha5xp1Y+7GANRfbXAcOsMRQDq2RSIMSGXcCwc3vRv1H
 52q+zgzB
 EXGYndZQ1/IdLNvVnaNb6CBTdAGC47o9/qHW2eGsqBDG8XJKzCI+/lBeBq1Rhw9itsJ/6VXJCtNBDTRt7vJ1l/Q1wz3aiKnknnrA4fKqCMydFBJCnu4/Y3LpNcRyzlL4QQRPB4IUeM+GKmM7jtFNDFSwFgGU/BIJIo5a1rKf8pVPXZPZkjDjdM7hMn0VsBNlq4muxD/KC7Wp+ebezASxBSUOZC2DVji1hMRw67lleJC0mgQXY6rkrZZGvjQQYIqyOfkjgDWpieh10XIujPoaMGRexWi5q2a1IbDOqxjVuw5MbZA4UHUZAE2iYyw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 16:05, Yang Shi wrote:
> 
> 
> On 9/18/25 5:48 AM, Catalin Marinas wrote:
>> On Wed, Sep 17, 2025 at 12:02:11PM -0700, Yang Shi wrote:
>>> The kprobe page is allocated by execmem allocator with ROX permission.
>>> It needs to call set_memory_rox() to set proper permission for the
>>> direct map too. It was missed.
>>>
>>> And the set_memory_rox() guarantees the direct map will be split if it
>>> needs so that set_direct_map calls in vfree() won't fail.
>>>
>>> Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
>>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>>> ---
>>>   arch/arm64/kernel/probes/kprobes.c | 12 ++++++++++++
>>>   1 file changed, 12 insertions(+)
>>>
>>> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/
>>> kprobes.c
>>> index 0c5d408afd95..c4f8c4750f1e 100644
>>> --- a/arch/arm64/kernel/probes/kprobes.c
>>> +++ b/arch/arm64/kernel/probes/kprobes.c
>>> @@ -10,6 +10,7 @@
>>>     #define pr_fmt(fmt) "kprobes: " fmt
>>>   +#include <linux/execmem.h>
>>>   #include <linux/extable.h>
>>>   #include <linux/kasan.h>
>>>   #include <linux/kernel.h>
>>> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>>>   static void __kprobes
>>>   post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs
>>> *);
>>>   +void *alloc_insn_page(void)
>>> +{
>>> +    void *page;
>> Nit: I'd call this 'addr'. 'page' makes me think of a struct page.
> 
> Sure.
> 
>>
>>> +
>>> +    page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
>>> +    if (!page)
>>> +        return NULL;
>>> +    set_memory_rox((unsigned long)page, 1);
>> It's unfortunate that we change the attributes of the ROX vmap first to
>> RO, then to back to ROX so that we get the linear map changed. Maybe
>> factor out some of the code in change_memory_common() to only change the
>> linear map.
> 
> I want to make sure I understand you correctly, you meant set_memory_rox()
> should do:
> 
> change linear map to RO (call a new helper, for example, set_direct_map_ro())
> change vmap to ROX (call change_memory_common())
> 
> Is it correct?
> 
> If so set_memory_ro() should do the similar thing.
> 
> And I think we should have the cleanup patch separate from this bug fix patch
> because the bug fix patch should be applied to -stable release too. Keeping it
> simpler makes the backport easier.
> 
> Shall I squash the cleanup patch into patch #1?


Personally I think we should drop this patch from the series and handle it
separately.

We worked out that the requirement is to either never call set_memory_*() or to
call set_memory_*() for the entire vmalloc'ed range prior to optionally calling
set_memory_*() for a sub-range in order to guarrantee vm_reset_perms() works
correctly.

Given this is only allocating a single page, it is impossible to call
set_memory_*() for a sub-range. So the requirement is met.

I agree it looks odd/wrong to have different permissions in the linear map vs
the vmap but that is an orthogonal bug that can be fixed separately.

What do you think?

Thanks,
Ryan


> 
> Thanks,
> Yang
> 
>>
>> Otherwise it looks fine.
>>
> 


