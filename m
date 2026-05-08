Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52770CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 09:08:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D7CD6B0125; Fri,  8 May 2026 05:08:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 789386B0126; Fri,  8 May 2026 05:08:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F056B0127; Fri,  8 May 2026 05:08:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5872C6B0125
	for <linux-mm@kvack.org>; Fri,  8 May 2026 05:08:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0284F1607A5
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:08:33 +0000 (UTC)
X-FDA: 84743676948.17.47D3764
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id CE299A000A
	for <linux-mm@kvack.org>; Fri,  8 May 2026 09:08:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WPh3yUoF;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778231312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=998AzUHkBd2MHjoPernwnRkOgC5TCEI3RLAhgvrlDps=;
	b=6fCgNEfhdt71hrkK/2ATOgyyVZteu8LoHaSDsUuIxYDjVPI3nl5qCgD4saF9fK8opRcz7m
	529pAQNB8blGQVYVqEEwHVBH5RZ6Aug2W8xbEO1T8nAlgFrcElIh9KyV9FI4lhdgyBCoYK
	wec+gduiLlo3ZtD0Txep2yudtTrFbaE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=WPh3yUoF;
	spf=pass (imf25.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778231312; a=rsa-sha256;
	cv=none;
	b=p2o4sk1DSul/umYS9xkP+M+vJP5ZT9UY8SW+xLlw27z+lThNhTzWCf5y5ofOJSO4kv3LMD
	cXO9FX7jBFiQP0ayxmRRkhW8GKEdI337FpkRHS1TMmFOI8YIdyots5W49Row41n0HEDgZa
	i7h58r/U10PDF/xxphnxhwp8cwarepY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56CD51AC1;
	Fri,  8 May 2026 02:08:25 -0700 (PDT)
Received: from [10.57.35.71] (unknown [10.57.35.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F04523F7B4;
	Fri,  8 May 2026 02:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778231310; bh=998AzUHkBd2MHjoPernwnRkOgC5TCEI3RLAhgvrlDps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WPh3yUoFMFj8+b6NrCFhAXEvHu9aundhUOnMwNWD2QHqLVB/wfS7QiwL+0BDpm4RF
	 NSMUNZAiTkWs+ukXKE7RyPNfyloPQoejZ2iApXnQrGF7MghSNxsyc0kXZ3cJwCG8wd
	 Yjtv0h4b+w7/JhHBBOSnR+TQIO25g+ipSooZj9r0=
Message-ID: <775a5fd2-394d-4409-81d3-4dc6ef8209f0@arm.com>
Date: Fri, 8 May 2026 11:08:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/xen: Fix lazy mmu handling across context switch
To: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
 linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org
Cc: mmarek@invisiblethingslab.com,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, xen-devel@lists.xenproject.org
References: <20260508080514.454607-1-jgross@suse.com>
 <5cb54bd1-5981-4a46-9083-f7b527ca342f@suse.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <5cb54bd1-5981-4a46-9083-f7b527ca342f@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE299A000A
X-Rspamd-Server: rspam06
X-Stat-Signature: otzi1czd16mmmzch549pczx5gpcfucpk
X-HE-Tag: 1778231311-817190
X-HE-Meta: U2FsdGVkX19PoO5ICQ//XZ5UWZArye7uFJRbt5lf4GDfrMAxYrL/zKtqfoEDR/7ErkDVB68YPlhLz/5OwnG37i8DM1/7nF/FFrcWrxbLcL8zyopqcn1a0I7p8itKNJrR5jtCnklyfgLY8ibFjfIf1mWM/MEboQW9tVXV3DL2MMUKhirJ7Izqc72pEuLGTnWB6Hs8vcsqvDytcSWcxTw0guQiaarvDmL9ePHs42fBzSG/Dg5hSfGRU435pQLLxiK/q6Z3WDdKdOzVqHLAoWOorSOfiWQXYQW07n0+OWfmD4ztjWPFkld0V0UnRboE9XWHw7mo/EqyTIqvIzNJUnjJz62aKvq+r4uBsZL3+oLUSSFtYtm+HFu+kSt2UJg/9U7DxpUF/AdJo9WnOWhJ0wGIZ5tLWUEznRimmGx8qzzDVUhViG9I/QQI7g5/n9WlzNRrbyyqEnXGQj+ejzHOL0tyNAu/yoVdWNa3DH7l80ZMiIifzcAgPyYo+83hupHiArevaAw+LdkVSOVHr1cmm8+Ic3Q7fJDdjsFJMbINNcgRGyZQWmHlapB0oDqa21waRgzunAjthCDsVKdSdLTzCRN1mrdAAbyd3c9Sl+geC0PZvLfPk1ObaSPUK4UtzGH+CwI/uNE3KW5G0hwRuTlJ4x7l25GNety78L3aSPdKa1BtO0VQ7SLmJPLhkeZuCdsVV12Bj/1uB7EllCLavQSRRQ8LKyTRpSElxPx8cKv2xB0VzBZvVAGiZ4/rGYnfShr0QnCGIiG1Us78VtCkaoq+K7LNeXzq+mVWa5F19wDHzhopJxBTP1RuIOZzVBaJYZIlQxZWPwHJVmLw4hA9v7R15m6AAq4zW6IGDw2K0WsWpEoikqw5nY38LPeBg0w2X4ZciXHWoao6TWcZr4FchWJhaVZRwjRsPHKpBfn6725lmOGmN1uCgIdAWuAc5dsNdCIs4h4WWO7n+cE52UixcQMdvG6
 7Rw4rlW4
 jVD6xiuM45NEaxN5mlcAz7tCG8I5Q8xKBIDCFTqCROOG+2xOJmebnO3AgCY6OUFL2mX7UrHYpTRDpsqpJ3HrhHkzGzLVcDbMaNStZC3XXoYCF+8KkO8yzEY1SQ95k5wyxsCUnwPvDZUmn7JrRqDzFBsxQCA6d5qg4LDAvLxjyndzasxG18Nf8S6Ou/nZjS4zc4dlGYms0SYACV1pVueO2FcWkLI2fTYuanpwgpEDo6iXkB2JVqdoTafXUSmKF3GksddjaIxtm66ylW/U4fe/Mznfu+2WPRPpxewHgMEm5TMtI+X/OyzMmBm4W+l0gao1k1nc0nt2uErsSM9Nlh+9FESvIDFNv/O3ZTCDS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/05/2026 10:33, Jürgen Groß wrote:
> Please disregard this patch. It isn't fixing the real problem.

That's what I would expect, see below.

>
> On 08.05.26 10:05, Juergen Gross wrote:
>> The recent rework of mmu lazy mode has resulted in problems when
>> running as a Xen PV guest. Enabling lazy mmu mode for the new context
>> during context switch is done from the arch_end_context_switch() hook,
>> but when calling this hook current hasn't been changed yet, so the
>> lazy mmu mode state of the wrong task is modified.

Currently xen_end_context_switch() checks if next has lazy MMU mode
enabled and if so calls arch_enter_lazy_mmu_mode(), i.e.
enter_lazy(XEN_LAZY_MMU). This does *not* modify any task state, rather
it writes to the xen_lazy_mode percpu variable.

I've thought about this from various angles when reworking lazy MMU, and
the conclusion I made is that arch_{start,end}_context_switch() have no
reason to change any task state. On arm64, for instance, we do nothing
at all on context switching, since everything lazy MMU-related is
tracked in task_struct and therefore already switched.

Xen is trickier because it tracks lazy MMU/CPU state in a percpu
variable, so these hooks do need to do something about it. This is
entirely Xen-internal though, and there's no reason to be calling
generic functions like lazy_mmu_mode_pause() that modify task state.

The idea behind commit 291b3abed657 ("x86/xen: use lazy_mmu_state when
context-switching") is that TIF_LAZY_MMU_UPDATES now duplicates
lazy_mmu_state in task_struct and we can therefore replace the former
with the latter. More specifically, the assumption is that
TIF_LAZY_MMU_UPDATES is set if and only if the task has been scheduled
out and __task_lazy_mmu_mode_active(task) is true.

Clearly there is something wrong with this assumption, but I still can't
put my finger on it. For now I would suggest reverting this commit if
that solves the issue Marek reported; the intention was not to introduce
any functional change, but only a (minor) optimisation.

- Kevin

>>
>> Additionally it is much cleaner to use lazy_mmu_mode_pause() and
>> lazy_mmu_mode_resume() in the Xen context switch hooks, as it avoids
>> conditionals in those hooks.
>>
>> In order not having to add another hook to be called after switching
>> current, modify lazy_mmu_mode_resume() to use a new sub-function which
>> takes a task pointer as parameter. This new sub-function can then be
>> used in the xen_end_context_switch() hook.
>>
>> Fixes: 291b3abed657 ("x86/xen: use lazy_mmu_state when
>> context-switching")
>> Signed-off-by: Juergen Gross <jgross@suse.com>
>> ---
>>   arch/x86/xen/enlighten_pv.c |  7 ++-----
>>   include/linux/pgtable.h     | 33 ++++++++++++++++++++++++---------
>>   2 files changed, 26 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
>> index ed2d7a3756ce..67bb6bf6d240 100644
>> --- a/arch/x86/xen/enlighten_pv.c
>> +++ b/arch/x86/xen/enlighten_pv.c
>> @@ -424,9 +424,7 @@ static void xen_start_context_switch(struct
>> task_struct *prev)
>>   {
>>       BUG_ON(preemptible());
>>   -    if (this_cpu_read(xen_lazy_mode) == XEN_LAZY_MMU) {
>> -        arch_leave_lazy_mmu_mode();
>> -    }
>> +    lazy_mmu_mode_pause();
>>       enter_lazy(XEN_LAZY_CPU);
>>   }
>>   @@ -436,8 +434,7 @@ static void xen_end_context_switch(struct
>> task_struct *next)
>>         xen_mc_flush();
>>       leave_lazy(XEN_LAZY_CPU);
>> -    if (__task_lazy_mmu_mode_active(next))
>> -        arch_enter_lazy_mmu_mode();
>> +    lazy_mmu_mode_resume_task(next);
>>   }
>>     static unsigned long xen_store_tr(void)
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index cdd68ed3ae1a..83a099bf2038 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -326,6 +326,28 @@ static inline void lazy_mmu_mode_pause(void)
>>           arch_leave_lazy_mmu_mode();
>>   }
>>   +/**
>> + * lazy_mmu_mode_resume_task() - Resume the lazy MMU mode for a
>> specific task.
>> + *
>> + * Like lazy_mmu_mode_resume() below, but with a task specified.
>> + * Must be called only by lazy_mmu_mode_resume() or during context
>> switch.
>> + * Must never be called in interrupt context.
>> + *
>> + * Must match a call to lazy_mmu_mode_pause().
>> + *
>> + * Has no effect if called:
>> + * - While paused (inside another pause()/resume() pair)
>> + */
>> +static inline void lazy_mmu_mode_resume_task(struct task_struct *task)
>> +{
>> +    struct lazy_mmu_state *state = &task->lazy_mmu_state;
>> +
>> +    VM_WARN_ON_ONCE(state->pause_count == 0);
>> +
>> +    if (--state->pause_count == 0 && state->enable_count > 0)
>> +        arch_enter_lazy_mmu_mode();
>> +}
>> +
>>   /**
>>    * lazy_mmu_mode_resume() - Resume the lazy MMU mode.
>>    *
>> @@ -341,15 +363,8 @@ static inline void lazy_mmu_mode_pause(void)
>>    */
>>   static inline void lazy_mmu_mode_resume(void)
>>   {
>> -    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> -
>> -    if (in_interrupt())
>> -        return;
>> -
>> -    VM_WARN_ON_ONCE(state->pause_count == 0);
>> -
>> -    if (--state->pause_count == 0 && state->enable_count > 0)
>> -        arch_enter_lazy_mmu_mode();
>> +    if (!in_interrupt())
>> +        lazy_mmu_mode_resume_task(current);
>>   }
>>   #else
>>   static inline void lazy_mmu_mode_enable(void) {}
>

