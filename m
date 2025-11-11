Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D08CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 15:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D29AC8E0007; Tue, 11 Nov 2025 10:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDA9C8E0002; Tue, 11 Nov 2025 10:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC9078E0007; Tue, 11 Nov 2025 10:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A787B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:56:56 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4239288CF9
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:56:56 +0000 (UTC)
X-FDA: 84098779632.22.33DFACC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3B6BB40005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:56:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762876614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+wOVHCwjCTKp66R7ucfYg0ohu+W1Y4sPrlqnEcbYBKg=;
	b=0mPt6tG/3vCIlwXkJYHdojppY6D2PJefcAxYYgIUwHBxpnyIj0w/X5SpII1ozMept1JNOW
	iXHFWJOkQkAdyJ1CUmGeLnL92Tvzj6jcu6I2SzTB57q4hZHzVf35o1VUU7PXrKnKqPSz8b
	cp1Ehgn0rnAkFG5w2Odxo0IqUFePF8I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf12.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762876614; a=rsa-sha256;
	cv=none;
	b=5VSgdH1r490YhpdGageERy0VyKLIr2jCe9eBXq2kDOy+V7HWkvcMBWWHPFGb1VeKIOGNY2
	Db+Ym0g/0JviHexlakxDrTd+ZCYURpe8I2MqUvFQaq/j7Gqr9NN6IuRSRSc5h54jNouuYQ
	2nln5ZMX10++AK0FNdQllmlfXN4Sy70=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5ECCC2F;
	Tue, 11 Nov 2025 07:56:45 -0800 (PST)
Received: from [10.57.38.153] (unknown [10.57.38.153])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 489953F63F;
	Tue, 11 Nov 2025 07:56:47 -0800 (PST)
Message-ID: <58fd1a6e-f2c4-421c-9b95-dea4b244a515@arm.com>
Date: Tue, 11 Nov 2025 16:56:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Ryan Roberts <ryan.roberts@arm.com>, linux-mm@kvack.org
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
 Peter Zijlstra <peterz@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
 xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <999feffa-5d1d-42e3-bd3a-d949f2a9de9d@arm.com>
 <cc9dc398-b9c5-4bb8-94ad-7e7f3ddd5b4f@arm.com>
 <824bf705-e9d6-4eeb-9532-9059fa56427f@arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <824bf705-e9d6-4eeb-9532-9059fa56427f@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B6BB40005
X-Stat-Signature: hz4e5bniqujdkab5hxcwfqtpaqxw9yee
X-Rspam-User: 
X-HE-Tag: 1762876614-9505
X-HE-Meta: U2FsdGVkX19/UghueSyaUD87ar80S09m8wfyvq9WagOzXqitahf/DFXXVbOw6uWIXmcMsGMqtF3lmYDAgnFGNU7SzAktrLZg+WNQRQYDTtxD0T+NWCSksi987fypp6sSLTqyRnCRxfgSpIneSkNVGCkWBrNghjRdz8xdtMa11It9jsU/hWDVMHBHAbqnlwAP8dmMM3VyMldmkCJRTittvAvsc6rgFbz6x4vJiPebBAQg2VRurI7NJlHy6Deb4RcsjnJZm2Xoacah0IkxF0ad6bW2VmI1bk/z6e5sMWWI3oSjk92AGmsXjrA7LDS8Dxgn2QzGtGRQxLswE2GF48dDgDf5n+op/n056ukuWrUydlgq94HS6TSFdtX83uH+t+Ur0Vkz0ZBaOcu4myCLsjXCA0LyzNPwFROr+nhVxCjWL2iwKfCWyIprirUSn+SZ3yXPHOVVHQTHSAidt6Hb98Igi0CZiu8vc7R5+zNCfmlBkl2PeylSGdCnfs0eLQ0cPEHrvPwtCaiygz/qFfl2Rg7ppCrWG0dU7RfZamtjefr9Rvcnb0VfMJhE4JhAZul9Ajlc5aYIy3dpXhiSqduT5R7tsAuzaalfvABVfGzlfgQih8EPfcxgtQi+fIDj3u3I6EhjdiPevOexGJaGNud4K0k1pD+EjWuRzYCUmNkv8p0/xVMRzeGVOZRQ5AVLNBoyiBcK5xaaUzGN2naJeQAvXbBREsyjb6utYrJiMln0uq2rgVIrim9kvvG4Owlgnhe2yZ6Ebq+JKkl/Z+FUuj7RNTuucuALRli7DScPAZH79JdNd0eh75lobSAndrLPq0ITXtNwXMe6H/VYSs0MS5M4HKe0dTzGbTgzLEAXQqTUZAlHQcuijCF/gpGfHb2e+GZ4V462C65gsDwCUDGbe6eBhduRGRaGeuWI1WbhTmhGxQxSIt73sOGxvzWIerFBKrIT9DoN+lN9u/9CNMx8OTr5EJs
 3xKPDBJm
 vOEGJOMfY5HCwpmz8oUT67HqRDtLqiuuYcshNNbfBFf1wKdsVAQiupdGfecTuapS/AcwPVDRA2o+IPaxw6LF4onkd55sv+MO/1vb7Mjcq96ZSn4yZney9viW42E29mHsoVk96p78WdThx3mPK7NlhjqsY6ELrRvah1M+TSMgmA9uDwb1rPXBY0hn0r6JCZiv2NmM2Evn4LWdfbkrEw7wD1q/PWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/2025 10:24, Ryan Roberts wrote:
> [...]
>
>>>> +		state->active = true;
>>>> +		arch_enter_lazy_mmu_mode();
>>>> +	}
>>>>  }
>>>>  
>>>>  static inline void lazy_mmu_mode_disable(void)
>>>>  {
>>>> -	arch_leave_lazy_mmu_mode();
>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>> +
>>>> +	VM_WARN_ON_ONCE(state->nesting_level == 0);
>>>> +	VM_WARN_ON(!state->active);
>>>> +
>>>> +	if (--state->nesting_level == 0) {
>>>> +		state->active = false;
>>>> +		arch_leave_lazy_mmu_mode();
>>>> +	} else {
>>>> +		/* Exiting a nested section */
>>>> +		arch_flush_lazy_mmu_mode();
>>>> +	}
>>>>  }
>>>>  
>>>>  static inline void lazy_mmu_mode_pause(void)
>>>>  {
>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>> +
>>>> +	VM_WARN_ON(state->nesting_level == 0 || !state->active);
>>> nit: do you need the first condition? I think when nesting_level==0, we expect
>>> to be !active?
>> I suppose this should never happen indeed - I was just being extra
>> defensive.
>>
>> Either way David suggested allowing pause()/resume() to be called
>> outside of any section so the next version will bail out on
>> nesting_level == 0.
> Ignoring my current opinion that we don't need pause/resume at all for now; Are
> you suggesting that pause/resume will be completely independent of
> enable/disable? I think that would be best. So enable/disable increment and
> decrement the nesting_level counter regardless of whether we are paused.
> nesting_level 0 => 1 enables if not paused. nesting_level 1 => 0 disables if not
> paused. pause disables nesting_level >= 1, resume enables if nesting_level >= 1.

This is something else. Currently the rules are:

[A]

// pausing forbidden
enable()
    pause()
    // pausing/enabling forbidden
    resume()
disable()

David suggested allowing:

[B]

pause()
// pausing/enabling forbidden
resume()

Your suggestion is also allowing:

[C]

pause()
    // pausing forbidden
    enable()
    disable()
resume()

> Perhaps we also need nested pause/resume? Then you just end up with 2 counters;
> enable_count and pause_count. Sorry if this has already been discussed.

And finally:

[D]

pause()
    pause()
        enable()
        disable()
    resume()
resume()

I don't really mind either way, but I don't see an immediate use for [C]
and [D] - the idea is that the paused section is short and controlled,
not made up of arbitrary calls. A potential downside of allowing [C] and
[D] is that it makes it harder to detect unintended nesting (fewer
VM_WARN assertions). Happy to implement it if this proves useful though.

OTOH the idea behind [B] is that it allows the caller of
pause()/resume() not to care about whether lazy MMU is actually enabled
or not - i.e. the kasan helpers would keep working even if
apply_to_page_range() didn't use lazy MMU any more.

>>>> +
>>>> +	state->active = false;
>>>>  	arch_leave_lazy_mmu_mode();
>>>>  }
>>>>  
>>>>  static inline void lazy_mmu_mode_resume(void)
>>>>  {
>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>> +
>>>> +	VM_WARN_ON(state->nesting_level == 0 || state->active);
>>> Similar argument?
>>>
>>>> +
>>>> +	state->active = true;
>>>>  	arch_enter_lazy_mmu_mode();
>>>>  }
>>>>  #else
>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>> index cbb7340c5866..11566d973f42 100644
>>>> --- a/include/linux/sched.h
>>>> +++ b/include/linux/sched.h
>>>> @@ -1441,6 +1441,10 @@ struct task_struct {
>>>>  
>>>>  	struct page_frag		task_frag;
>>>>  
>>>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>> +	struct lazy_mmu_state		lazy_mmu_state;
>>>> +#endif
>>>> +
>>>>  #ifdef CONFIG_TASK_DELAY_ACCT
>>>>  	struct task_delay_info		*delays;
>>>>  #endif
>>>> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_struct *tsk)
>>>>  	return task_index_to_char(task_state_index(tsk));
>>>>  }
>>>>  
>>>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>> +static inline bool in_lazy_mmu_mode(void)
>>>> +{
>>>> +	return current->lazy_mmu_state.active;
>>>> +}
>>>> +#else
>>>> +static inline bool in_lazy_mmu_mode(void)
>>>> +{
>>>> +	return false;
>>> Just pointing out that this isn't really a correct implementation:
>>>
>>> lazy_mmu_mode_enable()
>>> ASSERT(in_lazy_mmu_mode()) << triggers for arches without lazy mmu
>>> lazy_mmu_mode_disable()
>>>
>>> Although it probably doesn't matter in practice?
>> I'd say that the expectation is invalid - lazy MMU mode can only be
>> enabled if the architecture supports it. In fact as you pointed out
>> above the API may be called in interrupt context but it will have no
>> effect, so this sequence would always fail in interrupt context.
> Yep, but previously there was no way to query the current state so it didn't
> matter. Now you have a query API so it might matter if/when people come along
> and use it in unexpected ways.

I suppose the best we can do is document it alongside those helpers
(David has already suggested some documentation, see patch 11).

>> Worth nothing that in_lazy_mmu_mode() is only ever called from arch code
>> where lazy MMU is implemented. I added the fallback as a matter of
>> principle, but it isn't actually required.
> Yes, I agree that's the intent. I'm just wondering if it's possible to enforce
> that only arch code uses this. Perhaps add some docs to explain that it's only
> intended for arches that implement lazy_mmu, and don't define it for arches that
> don't, which would catch any generic users?

Yep sounds like the best option - a lot less risk of misuse if it can't
be called from generic code :) The build would still succeed on arch's
that implement it, but the kernel CI should catch such calls sooner or
later.

- Kevin

