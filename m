Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A05BAE9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07DC26B008C; Wed, 18 Feb 2026 04:00:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F056B0092; Wed, 18 Feb 2026 03:59:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC11A6B0093; Wed, 18 Feb 2026 03:59:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBA956B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:59:59 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C46D140483
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:59:59 +0000 (UTC)
X-FDA: 84456980118.24.428DA76
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id ABCF4140004
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:59:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771405197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OfgLxq8Tn4dnn/VlYJmUDWEFyr0QG1xJvgTgp0EGuAs=;
	b=FfkLqCqWOUQP8fCFod3hP+Mmk7/ZrstTaKVQlLizyjHQb/4ZOjWe2InuOmKEtomgX0pdkV
	Xh+LjlDPsD+gftDUIFAlxg+nyMkC9VlfHHSJMDhoIyR4Nnlu8vuK5kQZG+Bpk67PaMt4mQ
	WpjT3zDTdfARQPnCJUUQytu2EYTwWtk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771405197; a=rsa-sha256;
	cv=none;
	b=Ht6PP48hW9uX2nX90yjIM3fIvtqglRz9YIUyUoG7/3MSFHAxR3t+hyO4Px8S7tIhhu9U65
	7dB4BrmrxzUTJY7OGB4jklBoL/XHXeyDPFvbC83jJaqnHqkrhCXvoG5uAtT4+HYtwl9VDu
	sWS5rquxPyNwImRmJ0GFV1fZ2VZmutI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7FC051477;
	Wed, 18 Feb 2026 00:59:50 -0800 (PST)
Received: from [10.57.81.199] (unknown [10.57.81.199])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 097443F62B;
	Wed, 18 Feb 2026 00:59:54 -0800 (PST)
Message-ID: <2241a26d-74cd-4d40-8b8a-2a6b74b21871@arm.com>
Date: Wed, 18 Feb 2026 08:59:53 +0000
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
 <aY4r0lL9oGE7tzJW@arm.com> <7de4f82a-5165-4d92-95f5-a28498ba8940@arm.com>
 <aZLzbwkjQP8KDym_@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aZLzbwkjQP8KDym_@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ao8jf5co3jx96tn5h1ffrsjbwye3nor6
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ABCF4140004
X-HE-Tag: 1771405197-686927
X-HE-Meta: U2FsdGVkX18Fcii7V2tYOdo+IjHtpvhfyHV/YPZUfx2P+W4LLTSdR0IP/wBb7lxG+uytNMaPa9EF4R442+mR1A94Uk08XlxNQ73+BahnW6NWFJxThsNumICXt+zM2gv7hPzNn28MBSHS+yc0CYLLfHGvM9TZ8b8yA1VuN79Sn1TLdYrWi3pfLPzjNBswrXAEVPLtHd4QcybutdvoM0abTafuA+KqRlKeGzEt51fufRK+1z+GhwoC4wYCKzFBMVDCLGBGB85ODQQ7deJN5jfl2YJl0geI5DcUtTGqw9MQeMrcHjuVEklLAzjl+oHzLI6rlXsrXXqXXFU4KsrlnIxE3t+dLgO9M6qoJsUiPqxQBkL2Utl2QPJmjUM5WufJvlP3dCymCc+tU6neIOyf1x+2YaFsHQ03P8zGMZYL09WSZlQo8iRp3Aj1WE1EaQ78nNCMXSCjj7gW2ssyA1b051rBSg/RnRjTkT+Y3V8tmCMGpE8yq8dbTMES86TQMSPkZyrWrlWkre582Gmj+HJYOaOV9ahogyFtQwOcCNxWuwtlWX+6OAPxeznlCy/D6NZM46Jst2pDgbcRUrVkbjfjBJGZ/HOBlX8TuPuJ/VlQPN/ne4ccoGGQtjfF6DIJe9fespvvDZUaNlEn5mmjUZPzti7jWnuOZK4RhBERuvtByQ+qOg4SSf9SPZfaKA+0lJcBf7olWbq3DtnooxOh5w16kKuvT189UrIE4lvfa/hzZHNalUiNFNPMx7W+82Ij3UwJQgoJXt2VbtjEdzEWC3urzZifzyaQW1D6h7cPbaJj/p27mA5SFnXt7rJCC4+wzcox7xxtmRFjt+dZkPcpqeVtJSl5ko3lWQsvLRqx4tFchwQScg213VzKXl7Qqs7gE2G5EvT283yTgtRAcLZhUqVRopxP9ASR8atmSc8jwb9jy5d/s5h6Xsos9u/2RnJZTnxjHvJ75T/7HefOhsCohrMAOR6
 7huDEiGE
 vRBBDzMzzgv3TzSwmagyfKwk61dtfrVfeXG8yANqsczClOSnJNsvvERh3CiDSMmA+nNkohN5DQjUzlcMVJ+nUI0fA0Z7zhCSHwNh2Uo/MGkUFjoxtdiy18+uYzfcuMO2E9OdKG17WUickelodmsGkRu4ly94Auv+PMJGtAkyVTJ2mOOYLccJ49CLNcsQe5LsYWxndwramg6Q5YQhTPzLgtPKhIJXOpGKfK9HeM8Da0aPF5Ft9DeE2yEahJwd54BJELXF8H1YVBND5v9aF/TLWOXmux3Osru+x0OCdnZ0F4ShLbiA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16/02/2026 10:37, Catalin Marinas wrote:
> On Thu, Feb 12, 2026 at 09:12:55PM +0000, Ryan Roberts wrote:
>> On 12/02/2026 19:36, Catalin Marinas wrote:
>>> On Thu, Feb 12, 2026 at 06:45:19PM +0000, Ryan Roberts wrote:
>>>> On 12/02/2026 17:54, Catalin Marinas wrote:
>>>>> On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
>>>>>> On Wed, Feb 11, 2026 at 3:29 PM Tejun Heo <tj@kernel.org> wrote:
>>>>>>> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
>>>>>>> ...
>>>>>>>> Overhead
>>>>>>>> ========
>>>>>>>> 1. Some extra virtual memory space. But it shouldn’t be too much. I
>>>>>>>> saw 960K with Fedora default kernel config. Given terabytes virtual
>>>>>>>> memory space on 64 bit machine, 960K is negligible.
>>>>>>>> 2. Some extra physical memory for percpu kernel page table. 4K *
>>>>>>>> (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
>>>>>>>> mapping area. A couple of megabytes with Fedora default kernel config
>>>>>>>> on AmpereOne with 160 cores.
>>>>>>>> 3. Percpu allocation and free will be slower due to extra virtual
>>>>>>>> memory allocation and page table manipulation. However, percpu is
>>>>>>>> allocated by chunk. One chunk typically holds a lot percpu variables.
>>>>>>>> So the slowdown should be negligible. The test result below also
>>>>>>>> proved it.
>>>>> [...]
>>>>>>> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
>>>>>>> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
>>>>>>> uses that outside preempt disable block (which is a bit odd but allowed),
>>>>>>> the end result would be surprising. Hmm... I wonder whether it'd be
>>>>>>> worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
>>>>>>> access global offset from local mapping and then return the computed global
>>>>>>> address. This should still be pretty cheap and gets rid of surprising and
>>>>>>> potentially extremely subtle corner cases.
>>>>>>
>>>>>> Yes, this is going to be a problem. So we don't change how
>>>>>> this_cpu_ptr() works and keep it returning the global address. Because
>>>>>> I noticed this may cause confusion for list APIs too. For example,
>>>>>> when initializing a list embedded into a percpu variable, the ->next
>>>>>> and ->prev will be initialized to global addresses by using
>>>>>> per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
>>>>>> head will be dereferenced by using local address, then list_empty()
>>>>>> will complain, which compare the list head pointer and ->next pointer.
>>>>>> This will cause some problems.
>>>>>>
>>>>>> So we just use the local address for this_cpu_add/sub/inc/dec and so
>>>>>> on, which just manipulate a scalar counter.
>>>>>
>>>>> I wonder how much overhead is caused by calling into the scheduler on
>>>>> preempt_enable(). It would be good to get some numbers for something
>>>>> like the patch below (also removing the preempt disabling for
>>>>> this_cpu_read() as I don't think it matters - a thread cannot
>>>>> distinguish whether it was preempted between TPIDR read and variable
>>>>> read or immediately after the variable read; we can't do this for writes
>>>>> as other threads may notice unexpected updates).
>>>>>
>>>>> Another wild hack could be to read the kernel instruction at
>>>>> (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
>>>>> return false if it's a read from TPIDR_EL1/2, together with removing the
>>>>> preempt disabling. Or some other lighter way of detecting this_cpu_*
>>>>> constructs without full preemption disabling.
>>>>
>>>> Could a sort of kernel version of restartable sequences help? i.e. detect
>>>> preemption instead of preventing it?
>>>
>>> Yes, in principle that's what we'd need but it's too expensive to check,
>>> especially as those accessors are inlined.
>>
>> Could we use bit 63 of tpidr_el[12] to indicate "don't preempt"? a sort of
>> arch-specifc preemption disable mechanism that doesn't require load/store...
> 
> As long as it doesn't nest with interrupts, in which case some refcount
> would be needed.
> 
> But I need to check Yang's emails to see whether the actual TPIDR access
> is problematic.

We can't set the bit atomically so we could still be prempted between the read
and write back. So this is no good. Ignore my rambling...

> 
>>> For the write variants with LL/SC, we can check the TPIDR_EL2 again
>>> between the LDXR and STXR and bail out if it's different from the one
>>> read outside the loop. An interrupt would clear the exclusive monitor
>>> anyway and STXR fail. This won't work for the theoretical
>>> this_cpu_read() case.
>>
>> Could you clarify that last sentence? - we don't need it to work for
>> this_cpu_read() because we don't need to disable preemption for that case, right?
> 
> Mostly right but there can be some theoretical scenario where a thread
> expects to be the only one running on a CPU and any sequence of
> modifications to a per-cpu variable to be atomic:
> 
> https://lore.kernel.org/r/aY4fQOgyx3meku3b@arm.com

Yeah, I saw that after posting this. Thanks for the education :)



