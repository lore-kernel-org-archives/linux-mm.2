Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20DD0EEA84A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E066B0088; Thu, 12 Feb 2026 13:45:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE5B6B0089; Thu, 12 Feb 2026 13:45:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B2F6B008A; Thu, 12 Feb 2026 13:45:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52B416B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:45:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0CBCE57A91
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:45:25 +0000 (UTC)
X-FDA: 84436682610.15.116A884
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C79940011
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:45:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770921923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=y3buP9FrIt7beFoDHpxqkItF0f47xXf2T5DMZ9CokOc=;
	b=o1qtLoLE69H2bIHLzzr7t/HuG4e6r++JR8iXPi3MlvZuFdobkvbXdfUYpJ21aOn1a9Iq2d
	CBF5o0xQTGUdNmsamgzMLEJ+IMJC6mNtYKwv+1WY/X/valJASBrtXN1pbXBZiuiPF076X0
	R7rQ9BqVfbnV4wENGSz2Gpi4GmOJ9qE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770921923; a=rsa-sha256;
	cv=none;
	b=ZaEjIO9Pf+6HmzhZzb2udsPdlbSPkNBpaEj2b9qEK+IsoIgct+GMIf3c735azQi4NYF82/
	abHtEDTJcNtVo9871PZVPj7EPywrwPMYQfRvArPDbnL//3dWziaJOFM2OtzQRFMTk5D447
	8Jwdj7TCi0OAKBooNfK711xe4LeRxHk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A359D497;
	Thu, 12 Feb 2026 10:45:15 -0800 (PST)
Received: from [10.57.80.130] (unknown [10.57.80.130])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 97D9A3F63F;
	Thu, 12 Feb 2026 10:45:20 -0800 (PST)
Message-ID: <82420c8c-d7b0-4ebf-870f-a6061fa4428f@arm.com>
Date: Thu, 12 Feb 2026 18:45:19 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>, Yang Shi <shy828301@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, lsf-pc@lists.linux-foundation.org,
 Linux MM <linux-mm@kvack.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 dennis@kernel.org, urezki@gmail.com, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
 <aY4Ty6G6A3478_JS@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aY4Ty6G6A3478_JS@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: w94xskkoi8ezsm371jfbfisfbbt8d3m4
X-Rspam-User: 
X-Rspamd-Queue-Id: 0C79940011
X-HE-Tag: 1770921922-319936
X-HE-Meta: U2FsdGVkX196MO+J19jPfWDwUML8qIZqbIJ1TTvntleB3aihfnTtAfruJ2gqj/Ub8qnKQz1eBNP5wj48WC9w7E2/98vZYCX79zuQetTs+d7wHoWooI5BnhIZJntCPSxre/iVIeggy4cBVkG1Qgmaftap3H7jrNG0ZKINUQd+VnFf9OOEiBUsXqOFSDGjT0MeYoudqcqnGthl7t0CmFkytggddo4o8dh6L07VtqFtBFhrsTfMj3ozIIZhlSvB4KWQnVNjU87cseCZpPOSnJziQQRSxJpx/H9cZHJBC6hbmlIlCOF4f4ZyaKl2S6toSqrhGAmzzd4lyaQbn7VkDHy/nXg5oPdh5WgtZLl1sWforhOEhWwb2yQ8xLMeQbQPFin2hng0ZVNlKsfz82uOFjsgJA+eJHXPn/qSyzsWI8v7JwY2RVnQMGYUZLJxbYR0Ir2kazJ5+9dT6eX7+JC4ElTVldz90dmUulak+wjCna4jpi4nWK65XSg+EQFJ/lctBhTury9M1h1pRdAewGFpz9NaEr8X0R2Z89X5vwOngc1Rw67MXE74O8UehqmUy7LiURGq2rhNeXM9Ap3gyJtXqBHloJ+dr4AdCC2+H6QYNNGEb70JpovqT8i8Rayt90lhBdlB4q0EfwUxE0yZT6a+muT15HAe/1ZkQ3qNvJEhxE71Lksfyjntplue1WL+ngrhAtmNh1FF6JyVWIjg29EaixnQhzV0UlUushNnisPSWxjs4oViJe4MEHBHsjEues1vTms/doAlUtKIRVPySHmujRNj5uqzSRF9IJbkMCazvCNb/Y0by9K/e+TFtnNJs7gMC0N44AaOj0yR93VwG1mnqKk2VlgfFrYV/UqLSCMQbNUC9FdNxSjHgPOHY+S1BfM6QiGm4pCv87H/FBqTltejjrT+SJ42uTIbS5O/tH2XsqhKBc30bq2oVkCNUvCTKW7hROeD0Ptjv4qH8mwfLRmpS6L
 QCcbAISS
 2BYdACQUirtEDILpTtsLBKSrP5sTcg5hK9kcQCKIwCuEAMlDZG6aHvKRQe2j3TOd2Nz7gwVLy14IpRk+mZrKa+VKa6Y7jSfMSaH1Irh+0ZQf651+wKmpGkPYw3NQpu0Bo5KPSu3U3TXxg9cddZkCqjdwr0ZLhb5B4R0tor+OjqMo3/vbGSCNzQqm73VMxmzmlshnus1bB6SISZZxI9VsjSkOwGKY/ANasfhh76b0+htz4D+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/02/2026 17:54, Catalin Marinas wrote:
> On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
>> On Wed, Feb 11, 2026 at 3:29 PM Tejun Heo <tj@kernel.org> wrote:
>>> On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
>>> ...
>>>> Overhead
>>>> ========
>>>> 1. Some extra virtual memory space. But it shouldn’t be too much. I
>>>> saw 960K with Fedora default kernel config. Given terabytes virtual
>>>> memory space on 64 bit machine, 960K is negligible.
>>>> 2. Some extra physical memory for percpu kernel page table. 4K *
>>>> (nr_cpus – 1) for PGD pages, plus the page tables used by percpu local
>>>> mapping area. A couple of megabytes with Fedora default kernel config
>>>> on AmpereOne with 160 cores.
>>>> 3. Percpu allocation and free will be slower due to extra virtual
>>>> memory allocation and page table manipulation. However, percpu is
>>>> allocated by chunk. One chunk typically holds a lot percpu variables.
>>>> So the slowdown should be negligible. The test result below also
>>>> proved it.
> [...]
>>> One property that this breaks is per_cpu_ptr() of a given CPU disagreeing
>>> with this_cpu_ptr(). e.g. If there are users that take this_cpu_ptr() and
>>> uses that outside preempt disable block (which is a bit odd but allowed),
>>> the end result would be surprising. Hmm... I wonder whether it'd be
>>> worthwhile to keep this_cpu_ptr() returning the global address - ie. make it
>>> access global offset from local mapping and then return the computed global
>>> address. This should still be pretty cheap and gets rid of surprising and
>>> potentially extremely subtle corner cases.
>>
>> Yes, this is going to be a problem. So we don't change how
>> this_cpu_ptr() works and keep it returning the global address. Because
>> I noticed this may cause confusion for list APIs too. For example,
>> when initializing a list embedded into a percpu variable, the ->next
>> and ->prev will be initialized to global addresses by using
>> per_cpu_ptr(), but if the list is accessed via this_cpu_ptr(), list
>> head will be dereferenced by using local address, then list_empty()
>> will complain, which compare the list head pointer and ->next pointer.
>> This will cause some problems.
>>
>> So we just use the local address for this_cpu_add/sub/inc/dec and so
>> on, which just manipulate a scalar counter.
> 
> I wonder how much overhead is caused by calling into the scheduler on
> preempt_enable(). It would be good to get some numbers for something
> like the patch below (also removing the preempt disabling for
> this_cpu_read() as I don't think it matters - a thread cannot
> distinguish whether it was preempted between TPIDR read and variable
> read or immediately after the variable read; we can't do this for writes
> as other threads may notice unexpected updates).
> 
> Another wild hack could be to read the kernel instruction at
> (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
> return false if it's a read from TPIDR_EL1/2, together with removing the
> preempt disabling. Or some other lighter way of detecting this_cpu_*
> constructs without full preemption disabling.

Could a sort of kernel version of restartable sequences help? i.e. detect
preemption instead of preventing it?


