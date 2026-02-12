Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B71EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F0F6B0088; Thu, 12 Feb 2026 13:42:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FEB6B0089; Thu, 12 Feb 2026 13:42:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290546B008A; Thu, 12 Feb 2026 13:42:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17E406B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:42:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7B8D1401C6
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:42:02 +0000 (UTC)
X-FDA: 84436674084.24.02B4DDB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 040C6A0008
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:42:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770921721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FGdfYkqUuM5ZODcuG0s6v6iykiHiy/2nPGDDVGWXcfw=;
	b=G011uQRdEDMWOyqS17JYZq6fY0eQuJLFVDmWLeGrQCvMehMI6ePUqxDaBEKGjsjBEFjihB
	zjt9mZPWiD2Y3VPZ//mVXNUIbwTSGkFoZ5A0uGmLQIc/b+jC5xpeHMzq4by7lvfgIGOZV7
	UTRqxKqrSyKS2zP5xNAgvmjjXFZ7bVY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770921721; a=rsa-sha256;
	cv=none;
	b=D6olvFPtnsoes7nM/J7WKl/h+yUA+gXQK6H7APdAd8aeVpF7B+pRlsiV1spJGIcg1QWtJx
	TRIl/OW4yXZH53wJBRKasl0Pyyv8PEdzT1RGOvDxaUyJLFYNVYPIlWpK/9LrTLioUifwAZ
	GSSXVfsaAHBndNEAtXug2D4A+O8Z6H0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8FE9D339;
	Thu, 12 Feb 2026 10:41:53 -0800 (PST)
Received: from [10.57.80.130] (unknown [10.57.80.130])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8732A3F63F;
	Thu, 12 Feb 2026 10:41:58 -0800 (PST)
Message-ID: <5a648f49-97b1-4195-a825-47f3261225eb@arm.com>
Date: Thu, 12 Feb 2026 18:41:57 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Content-Language: en-GB
To: Yang Shi <shy828301@gmail.com>, lsf-pc@lists.linux-foundation.org,
 Linux MM <linux-mm@kvack.org>, "Christoph Lameter (Ampere)" <cl@gentwo.org>,
 dennis@kernel.org, Tejun Heo <tj@kernel.org>, urezki@gmail.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Yang Shi <yang@os.amperecomputing.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ta9wjryi6pftwmxhqy1hbqghgipgukm8
X-Rspamd-Queue-Id: 040C6A0008
X-Rspam-User: 
X-HE-Tag: 1770921720-503022
X-HE-Meta: U2FsdGVkX1+7B42gX0iSP2AqOXWwxYYx2Mtxvs9QtX8FVDINCpsYfCJUABz087tFoV3tHEgLpEBDpViac+Bz0EirYISF2xXZ9EYKrWQ/rI7bJmDBERMTelFbwdX5ZsrfGh4g4hYaOvoCcPJhvmftRb3+7FQrE0/dI4B0EDt92q+/tZV+F2DNGyI6lWtOQ02n5kU1AxmYwJLfRbHPyZ8IlF7nqgYhC4KWTjDZIiwYvtcSfpH9oeLqTqhcHMUpuOO30A3DaP9jw05RSYHM1Ups7tlulrD+RpKmoHqBzpg2mysTH1fiQ29VMVr2ZJh2TQ0Pye/VCsWpfqdLsSv6jbN0EHo2guGTJoVa4nuuxzK45P3dMt1sCcZuWGzquPIBcZuZJnvEpJ9JnAYvoICG5xNoI1GX4GLYhTZy1yZ51v4oMuqNp1Ip7J6rIT39LLJYFdbbGM+sIGGwOtaS9fr5DBrDqbqnz7z+S2Txxdx6hbOyLERwk0QvICrGSl5/L4hC6gkmdUGYR+gqYa1uh6LQPu4QjPeiBIBtTO/5xuhfv02MykqTRhBWzsGQbEmpas7Y9/3rd0gfFm5f+JX9nMxecY5NRByRpXgG2rqjdLzdZ8JMlzGf3gMOjkypqRRRa7b5p2lENEM8j++w5p2GxtTGBPUkZVOK4yiBlm7vang/6aZkM6GEppy02wczHO9X0P/ulFzERHcEJGhpMH8uFCCfjjaQLNmwGEBdrcN7l9GCB9slBs+bkk2xrQYYMNKfMFWDbN+d2uaqAEQW+1YSuk4ZXAMFa0FxoqsyO4Nfyts9+DVIUgp1asuDTw5zG1+beIeUCww8mCppJpshRNFSDlQ6dnnxEcjp39rcbqSicCslzkgrooS6QOdVGX0tTWDZ/v2ykxWzrWvlSERQbwY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/02/2026 23:14, Yang Shi wrote:
> Background
> =========
> The APIs using this_cpu_*() operate on a local copy of a percpu
> variable for the current processor. In order to obtain the address of
> this cpu specific variable a cpu specific offset has to be added to
> the address.
> On x86 this address calculation can be created by prefixing an
> instruction with a segment register. x86 can increment a percpu
> counter with a single instruction. Since the address calculation and
> the RMV operation occurs within one instruction it is atomic vs the
> scheduler. So no preemption is needed.
> f.e
> INC %gs:[my_counter]
> See https://www.kernel.org/doc/Documentation/this_cpu_ops.txt for more details.
> 
> ARM64 and some other non-x86 architectures don't have a segment
> register. The address of the current percpu variable has to be
> calculated and then that address can be used for an operation on
> percpu data. This process must be atomic vs the scheduler. Therefore,
> it is necessary to disable preemption, perform the address calculation
> and then the increment operation. The cpu specific offset is in a MSR
> that also needs to be accessed on ARM64. The code flow looks like:
>     Disable preemption
>     Calculate the current CPU copy address by using the offset
>     Manipulate the counter
>     Enable preemption

By massive coincidence, Dev Jain and I have been investigating a large
regression seen in a munmap micro-benchmark in 6.19, which is root caused to a
change that ends up using this_cpu_*() a lot more on the path.

We have concluded that we can simplify this_cpu_read() to not bother
disabling/enabling preemption, since it is read-only and a migration between the
2 ops vs after the second op is indistinguishable. I believe Dev is planning to
post a patch to list soon. This will solve our immediate regression issue.

But we can't do the same trick for ops that write. See [1].

[1] https://lore.kernel.org/all/20190311164837.GD24275@lakrids.cambridge.arm.com/

> 
> This process is inefficient relative to x86 and has to be repeated for
> every access to per cpu data.
> ARM64 has an increment instruction but this increment does not allow
> the use of a base register or a segment register like on x86. So an
> address calculation is always necessary even if the atomic instruction
> is used.
> A page table allows us to do remapping of addresses. So if the atomic
> instruction would be using a virtual address and the page tables for
> the local processor would map this area to the local per cpu data then
> we can also create a single instruction on ARM64 (hopefully for some
> other non-x86 architectures too) and be as efficient as x86 is.
> 
> So, the code flow should just become:
> INC VIRTUAL_BASE + percpu_variable_offset
> 
> In order to do that we need to have the same virtual address mapped
> differently for each processor. This means we need different page
> tables for each processor. These page tables
> can map almost all of the address space in the same way. The only area
> that will be special is the area starting at VIRTUAL_BASE.

This is an interesting idea. I'm keen to be involved in discussions.

My immediate concern is that this would not be compatible with FEAT_TTCNP, which
allows multiple PEs (ARM speak for CPU) to share a TLB - e.g. for SMT. I'm not
sure if that would be the end of the world; the perf numbers below are
compelling. I'll defer to others' opions on that.

Thanks,
Ryan


