Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F550EEA851
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CDB66B0088; Thu, 12 Feb 2026 16:13:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C026B0089; Thu, 12 Feb 2026 16:13:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A7B6B008A; Thu, 12 Feb 2026 16:13:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 334FE6B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:13:03 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B9C491B3D7D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:13:02 +0000 (UTC)
X-FDA: 84437054604.21.D2DEF99
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 884268000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:13:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770930781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eaFi1gVHvcXE92NBfGsSvq1HmSaXJhUF6yf5SpeHq9E=;
	b=S9M+XSVegddqHio1FVsQm97xaZNVbOcHH1DJ4GMItP6Qi0Jva92jdFKiM9jzjiIlBlnF5z
	70MyXqvsW2gm93SvNeL0OLo0CSaSTXfDGE4DPYWtMzloD6jxrWbYWHV2jfEimfSa/XdyCt
	w7dE9sl223idbOgh2qnW7EcaraBNGTk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770930781; a=rsa-sha256;
	cv=none;
	b=Jcej8+e0z8jLf8O1boSsvfWMW2AfveyDyowJ6YWaJPOG6VR+m+y2LGYOGzOpg4GnxWMjij
	COjiwsn7DxQrGJbZLBwimtSDq7HNOPMz3JJWNqup/ljGdCVKbFN3nQVp4S+vYXXskNeOjd
	lwou1a9fl53FSKnF/JOiPtRtqAY0ONI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19321339;
	Thu, 12 Feb 2026 13:12:53 -0800 (PST)
Received: from [10.57.80.130] (unknown [10.57.80.130])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 88FE53F632;
	Thu, 12 Feb 2026 13:12:57 -0800 (PST)
Message-ID: <7de4f82a-5165-4d92-95f5-a28498ba8940@arm.com>
Date: Thu, 12 Feb 2026 21:12:55 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Yang Shi <shy828301@gmail.com>, Tejun Heo <tj@kernel.org>,
 lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
 "Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
 urezki@gmail.com, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
 <aY4Ty6G6A3478_JS@arm.com> <82420c8c-d7b0-4ebf-870f-a6061fa4428f@arm.com>
 <aY4r0lL9oGE7tzJW@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aY4r0lL9oGE7tzJW@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 884268000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 5gpyayw9weoaq8hykyae5t7ozyoc91da
X-HE-Tag: 1770930780-425582
X-HE-Meta: U2FsdGVkX18WR7P6DlQELFFepm6euWwyXVKl8ovUFiWUfF4n+VG8pemKLBSZFHCFCoc4eKJ6vl+AUJR5VyJl1JKSztt9qrRfmG2eAdjEnWp1mAgScgUilCWTQT2DHmgC31xLrXoCqkngrbdXkD2i9qQ8Ywui7A1drafMMGdlJThPDF9oUX5BpsZMq5lP+7V34S5wrTebC9NECSCe46e5aW0dC7rn1KepproVRk4BKCODLhr+vDoyS6nT+fx2CXKjggE1CBkyx3tnBEl/6YQiKFIo+m5oHR84jSY9rRxzaQ6g8aUTjbMWQsp5NlYfwwFvE9s1ZEsOc2iCb1dLfDpYNWz976lD0K/Kap8kakm3fS8ZU4/OYWYrMyfKstpw0DBDSRRqcbCjgPDR9s9JUA8lSvDYC8YpcbLMYYOIW1TDKCxqnD8o7Dh881es759Gh1+MY+LziarggGQLfH0Ev/0UPl+K/Ri6UQFcmq4sLvpApv2vBDLL1/dguK+19bFiI4d6WTut7W+9qzsbf0XOzxNOtG0cIDUXsSDNXLggwpWbL18DTBc0y2541fwqpaq5vFPFTLQTHsO0ULOX9uUcem/5mgOO2+eddcxygQR7IrOQc7cALGqczFJorqqzCzDhBOBjVULTscyWKJIPdF46KSXUb/mL+Q1ugooGkQx0tYkgv+sYeePXmOH/BRxGxxvVzMUqotG/FDPAYSaHTfdOAvU2fN4NpyjmzHNC7OK17tiPluzjVTgfqRGEmPbUdLw1bfd+KLXFA7y6NXcpbpvVJOr6wUaSX6/LS4fpJ2kujAM1fcLdXjvBVKSp+Hn84tTpqq0Uc6sQCgba9ABUGBqBwNNCL7YMZqUXGWjwmjuARGsEo/jkfV62ar+6n/GAp3+aIbhR/i3BT+Khmt58LZThaU9svtWBwE0UKdK9mswQ3VanjpQuuMUPt2U4tSpzCpSIPMQCrTt2appkDTHRKiYhUOn
 y13C4fvF
 m4aJm56989BznD0i00STfkfACm3OXJMQmBi2GQqlRMJmGQeWNKsLp74GspJzk8Q7cyT52TWgID09o/FqE0kxdiVJrzmh/rW9XABWw0mJC6HIvsfwk59VIBGZ1GR7nEwNztENnhSm68G99uvvnp6zfrTA24nMO3nU5criP3/HVlh7IV5BPPeM6MvFgopqSnTIST1J/0Ej8oUdRRR4VB+q2Te2RMxhqEqeEJKr80JELCMZNbZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/02/2026 19:36, Catalin Marinas wrote:
> On Thu, Feb 12, 2026 at 06:45:19PM +0000, Ryan Roberts wrote:
>> On 12/02/2026 17:54, Catalin Marinas wrote:
>>> On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
>>>> On Wed, Feb 11, 2026 at 3:29 PM Tejun Heo <tj@kernel.org> wrote:
>>>>> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
>>>>> ...
>>>>>> Overhead
>>>>>> ========
>>>>>> 1. Some extra virtual memory space. But it shouldn’t be too much. I
>>>>>> saw 960K with Fedora default kernel config. Given terabytes virtual
>>>>>> memory space on 64 bit machine, 960K is negligible.
>>>>>> 2. Some extra physical memory for percpu kernel page table. 4K *
>>>>>> (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
>>>>>> mapping area. A couple of megabytes with Fedora default kernel config
>>>>>> on AmpereOne with 160 cores.
>>>>>> 3. Percpu allocation and free will be slower due to extra virtual
>>>>>> memory allocation and page table manipulation. However, percpu is
>>>>>> allocated by chunk. One chunk typically holds a lot percpu variables.
>>>>>> So the slowdown should be negligible. The test result below also
>>>>>> proved it.
>>> [...]
>>>>> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
>>>>> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
>>>>> uses that outside preempt disable block (which is a bit odd but allowed),
>>>>> the end result would be surprising. Hmm... I wonder whether it'd be
>>>>> worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
>>>>> access global offset from local mapping and then return the computed global
>>>>> address. This should still be pretty cheap and gets rid of surprising and
>>>>> potentially extremely subtle corner cases.
>>>>
>>>> Yes, this is going to be a problem. So we don't change how
>>>> this_cpu_ptr() works and keep it returning the global address. Because
>>>> I noticed this may cause confusion for list APIs too. For example,
>>>> when initializing a list embedded into a percpu variable, the ->next
>>>> and ->prev will be initialized to global addresses by using
>>>> per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
>>>> head will be dereferenced by using local address, then list_empty()
>>>> will complain, which compare the list head pointer and ->next pointer.
>>>> This will cause some problems.
>>>>
>>>> So we just use the local address for this_cpu_add/sub/inc/dec and so
>>>> on, which just manipulate a scalar counter.
>>>
>>> I wonder how much overhead is caused by calling into the scheduler on
>>> preempt_enable(). It would be good to get some numbers for something
>>> like the patch below (also removing the preempt disabling for
>>> this_cpu_read() as I don't think it matters - a thread cannot
>>> distinguish whether it was preempted between TPIDR read and variable
>>> read or immediately after the variable read; we can't do this for writes
>>> as other threads may notice unexpected updates).
>>>
>>> Another wild hack could be to read the kernel instruction at
>>> (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
>>> return false if it's a read from TPIDR_EL1/2, together with removing the
>>> preempt disabling. Or some other lighter way of detecting this_cpu_*
>>> constructs without full preemption disabling.
>>
>> Could a sort of kernel version of restartable sequences help? i.e. detect
>> preemption instead of preventing it?
> 
> Yes, in principle that's what we'd need but it's too expensive to check,
> especially as those accessors are inlined.

Could we use bit 63 of tpidr_el[12] to indicate "don't preempt"? a sort of
arch-specifc preemption disable mechanism that doesn't require load/store...

> 
> For the write variants with LL/SC, we can check the TPIDR_EL2 again
> between the LDXR and STXR and bail out if it's different from the one
> read outside the loop. An interrupt would clear the exclusive monitor
> anyway and STXR fail. This won't work for the theoretical
> this_cpu_read() case.

Could you clarify that last sentence? - we don't need it to work for
this_cpu_read() because we don't need to disable preemption for that case, right?

Thanks,
Ryan


