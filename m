Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8390CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 19:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8F988E00C7; Mon,  3 Nov 2025 14:23:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D40188E0060; Mon,  3 Nov 2025 14:23:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55D18E00C7; Mon,  3 Nov 2025 14:23:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B45608E0060
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 14:23:44 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 612FE13A0E6
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:23:44 +0000 (UTC)
X-FDA: 84070270368.16.613A6CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91A4FC001B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 19:23:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9UT0S1a;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762197822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VU73K/1EslvMeIQk3g4ipwia/QceF7bjRApk//rXHwo=;
	b=I4letOVlBQXrrCHUT6/xAkcejHHgiDW6numTXiZKnOfwebknXzeJe7PMgksn1+WM40SjoM
	vKxHvUQAMS/3OKUvWua3Oqek3cBmOkAx3Wpf4GvLglawiw1nZJClv8aJVXVHbsyt0hLOR5
	t1cUztx4jkn5/CX3ah4T1AX+5C/SITY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c9UT0S1a;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762197822; a=rsa-sha256;
	cv=none;
	b=RDdV+eg2oKJBWW+Ise4LJNu0CK8t6COpBKj4QUi2a25A9sY6BgEJwt7irbD0cZdrPXw58m
	mqyGwP3cgol1A6K6ZKqsAa1zkw8HBzGgFmxxnG4cXNxmFyuprXEI6smpzoIXyrxnC7mXFf
	5IsJdBQGHP3+4td6Zi1UgspldUyS9kM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31D2D40763;
	Mon,  3 Nov 2025 19:23:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEBEC4CEE7;
	Mon,  3 Nov 2025 19:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762197821;
	bh=YF+Dh7k5RXyD8ZknLWrr6zckBVz5y8Jk5LVnJjqJxoY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=c9UT0S1aE+oyoVDfFS4tVvZUGvWl9HiC7/F+Cp66KCVA7C4GhH0PqNtoBTarCw3iW
	 r2P630kamF4JSjUnf0EzY4gdgF4lREKNM2+yjmeoTw3nLHhjxYDny/gqAjP3iNUL7a
	 JzIyQ1aRH3QyNtDz4IpxtL5MX/fDHZSJh77cPeKd7LS92GluG1GXIy1BpAiLFwvlox
	 cRJrDCtLOcgMqEzgJxz44Oa9sLKyl40ixdJjaMo6LOW9qbHf4ryeTRFym1qVmpu9UH
	 uIilWOADkYHyRHPzn2EvdQ0ZptspxmBomG3l6lNVoh9BMoIycP2QxAs9MQX9p7Fs9q
	 9DzIobQXg5JOg==
Message-ID: <a326d1eb-62f1-4add-8dc9-cea7d7e4ed3c@kernel.org>
Date: Mon, 3 Nov 2025 20:23:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] x86/xen: use lazy_mmu_state when
 context-switching
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, David Woodhouse <dwmw2@infradead.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-12-kevin.brodsky@arm.com>
 <c7c8a233-2103-4b48-b65e-ec81666d20e4@kernel.org>
 <285faae4-dab6-4819-847a-889bdf87d5d7@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <285faae4-dab6-4819-847a-889bdf87d5d7@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91A4FC001B
X-Stat-Signature: wo3mqcyb43x4ozxfp1k4fumhxqnqxoa5
X-Rspam-User: 
X-HE-Tag: 1762197822-18141
X-HE-Meta: U2FsdGVkX1+QP7qsrUMtzDct4AILuCIoozGcLyDfPQuyRYrDkPu9DuUjGNv3eFDT/VPHpz7SGB//dc8lgOfSGuFh1mBs/kqTZpNkxCpZXD4gxcEZJirMSv5j0POibjYL/VstapCQBUj315LdBX4bLuI4aJB3NmpKZt4sjEO/C8YvO/BXyhsBNhIdnLxxEnbRImQCPjjsloVI9KneyP5jDTbPAU9sN+1pT+2xDxqjwFToINGxiqMSqGDVurQYpbzXziBuj35z73WTTuGg9TbZvzCWE1duq9tCMEZwGsXAtQ4OS5KSS3Xar7I5onk47VLoxkoBRv+4Z8UR5P9RFZ8YYEArS+/lkxK3Igl1QDL+zSQr1/WqjuijhpndPGiHDdAOY0Ks/9vKgPQf8YATJSmuHxTi03lgNn/CZKiZZKdRseboG5QoaaD0oEVC9Qsk16Sc2ftGYx5M3YI0ogBWHfNDYbo873pcOJ7jweaRZp8akG5t0TN8ivi9nzCh7G/cLNPvs0VywTwBj2lOGW13lVYk1JVYa1nmqNcRsPo44wsU+ULaN9aRNMO1tsB26sFdhVDffTt7dSh3TyQeAaTMWUa6KMa2W4QVR3AIeAJ89oQ9d+syynoH4XCIcIi5ZYtxInsp8Bz4CvTHsbrZHOzLTIBevWTI5WFJKdqZ3zJEyeT26mJKxWSOjxycrzDkxQ/7m5nLfKHZzhQ9Qh3c7I4mE+rNs+tzp4BGBHVgE52ijdy0CQ5fO+zpMor82I8uWF+Cp/hm7jTpXPwZLJEbVsyjkW1sto/O/eo62l29YpfsiZc4srGVFD8fNakHoexK+Pm08zjzHHV2dtwpSvGOlk55XO07YI5mwDFiPt2cDUB+ZCf0z+SY0DJa/f3iUxrlTTy1DiobxfjjJHrc8LKGXAiBcw7Ov8MpZl3i4242cRwwXUXfbqUZIgU3FN3eZ9uwmO2yujoR+1iFF22vst6AhyRcPec
 dvuHkFmL
 YfmGDpKJ/uXR/7ehgjXkXcgVkrMQESO3bheHnMXGkKekGomX42LniNIZg6KxTVOh7q9fbAoOMN28lvra/03NepiV2ujKia6iXJlkE2L1aQYwuI5AIgjBXFkUt0NYp1yDuzWe7gEvlhkVU7YqVGgV3uqBZNWavaElj0vp94OzeNYz2LJGQgavRPGEJu8LPYz/4B2q5hfFlPCBPY62aww+0OC0dgL1PARwF3sXrB73vp5tpAe4iiyw7pzWpsPMQdT47kU2TbpHG1llfkzkDtZmQOBlBgdokCaHTcMz2rmfI5UhyHrgCOkGOlhmmwqQlbMY1xerfqbCkuPojiz9/ARHCCPUXPVhsteWvrR5oBsEhNjwOI+4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.11.25 19:29, Kevin Brodsky wrote:
> On 03/11/2025 16:15, David Hildenbrand (Red Hat) wrote:
>> On 29.10.25 11:09, Kevin Brodsky wrote:
>>> [...]
>>>
>>> @@ -437,7 +436,7 @@ static void xen_end_context_switch(struct
>>> task_struct *next)
>>>          xen_mc_flush();
>>>        leave_lazy(XEN_LAZY_CPU);
>>> -    if (test_and_clear_ti_thread_flag(task_thread_info(next),
>>> TIF_LAZY_MMU_UPDATES))
>>> +    if (next->lazy_mmu_state.active)
>>
>> This is nasty. If in_lazy_mmu_mode() is not sufficient, we will want
>> to have a separate helper that makes it clear what the difference
>> between both variants is.
> 
> in_lazy_mmu_mode() operates on current, but here we're operating on a
> different task. The difference is more fundamental than just passing a
> task_struct * or not: in_lazy_mmu_mode() is about whether we're
> currently in lazy MMU mode, i.e. not paused and not in interrupt
> context. A task that isn't scheduled is never in lazy MMU mode -
> lazy_mmu_state.active is just the saved state to be restored when
> scheduled again.
> 
> My point here is that we could have a helper for this use-case, but it
> should not be used in other situations (at least not on current). Maybe
> __task_lazy_mmu_active(task)? I do wonder if accessing lazy_mmu_state
> directly isn't expressing the intention well enough though (checking the
> saved state).


Likely there should be a

/**
  * task_lazy_mmu_active - test whether the lazy-mmu mode is active for a
  *			  task
  * @task: ...
  *
  * The lazy-mmu mode is active if a task has lazy-mmu mode enabled and
  * currently not paused.
  */
static inline bool task_lazy_mmu_active(struct task_struct *task)
{
	return task->lazy_mmu_state.active;
}

/**
  * in_lazy_mmu_mode() - test whether current is in lazy-mmu mode
  *
  * Test whether the current task is in lazy-mmu mode: whether the
  * interrupts are enabled and the lazy-mmu mode is active for the
  * current task.
  */
  static inline bool in_lazy_mmu_mode(void)
  {
+	if (in_interrupt())
+		return false;
+
  	return task_lazy_mmu_active(current);
  }


Something like that. Maybe we can find better terminology.

-- 
Cheers

David

