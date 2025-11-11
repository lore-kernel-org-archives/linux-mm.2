Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86763CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 17:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE36C8E000C; Tue, 11 Nov 2025 12:03:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABAA08E0002; Tue, 11 Nov 2025 12:03:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7ED8E000C; Tue, 11 Nov 2025 12:03:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9021B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 12:03:24 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 409831386F8
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:03:24 +0000 (UTC)
X-FDA: 84098947128.29.3565411
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0329EC0018
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 17:03:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762880602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aua8l6YRNgQP+NPu3nML7Xo2TxY8EffMn9iRDXN1Nuw=;
	b=0qzwbGdW21Mhni0B5E9juZ+F8OFpMoKsLznj66p2DMos6imoOnW4K9hZPfvdmDDDO6hB7w
	AtQ9Fh1jsL0S/FNDjV/e4UTmfBPaP7zweSai6wGswXAUQ+unMPW4By06fO3GhVglQBGyGS
	G/4sGk2UMRBWLWgW2GhT5kID+ifelXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762880602; a=rsa-sha256;
	cv=none;
	b=8hcrKelJ4uLLPW5UF9ck274e8DGxKnTG/OG63RV9NxYruZys1H2uP18XlmyAXMqCfbR8n9
	IzK5Vjn/MUl6tzF9aRVY1wUmOWGl1ttcHc9B38eeQA0VOJzlxSsqMU/HMJ1pKxmMUe/bn5
	EQImPx58heOQSPkqz75pVIdSFygF+LY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32480497;
	Tue, 11 Nov 2025 09:03:13 -0800 (PST)
Received: from [10.1.31.216] (XHFQ2J9959.cambridge.arm.com [10.1.31.216])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 106E43F5A1;
	Tue, 11 Nov 2025 09:03:15 -0800 (PST)
Message-ID: <8f70692c-25a9-4bd0-94ab-43ab435e4b1b@arm.com>
Date: Tue, 11 Nov 2025 17:03:14 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
Content-Language: en-GB
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
 <58fd1a6e-f2c4-421c-9b95-dea4b244a515@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <58fd1a6e-f2c4-421c-9b95-dea4b244a515@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 0329EC0018
X-Stat-Signature: e3emqyz78pbxnrxi3j3urm5nzu77koo7
X-HE-Tag: 1762880601-274173
X-HE-Meta: U2FsdGVkX1+LiFetcDyUK2Xa8Y3g5sXbkx1la/OZU5YwpCbij8hRVwpGZd2tZzQ0t8eDTvpOAr8jPUXiVRELFiru5zzrnBhIt0qcrRN47Kzc+KrFS400MbNwWr8lvYJ7vwUkflCsLJaYXSIG4WLmuUUSuAAthZy4tH9wYU1nbrGdwZ5OhyH7hpzMnppy5zaDntamFcIldQOHLIWwwQFC+lzhKBz5u/DTJiRv/YZEn8LlGmPHDXMqgnDF+hCZsQdpqYpvdU4sWQ7qZ4p1k6sZ4YZDHTt2DwDjHIkn3zVyx+gYlX4oQ1woi2tdCg5TMmqwhIKzLgcXjzf1X6RkZqHrtrMZXuguw49jvT8YEfUeA1/eT6owq5azCemR3jpKkrgnTx8dNCk4ur0TCkkd+fPBlZxnighpIEDCQT4NTSq4b0FnOnc1l/RVT7NgXPaj2th2rRJpTGayFS8KN113t9VZAHVLLedVbmY4asxCHSZiHTAUFZflGgnoCx0/+8+XXbGAYl0EhVb0gZdh3e+xjZeBOQAmu9Ho7NRcSbSbe3bTtyoEaetmy0P+N5/CURe2lok/OseiykxTjgbrrhoimb50Iw870mF6uFRIUumCPEbNd9weXBsNJXCkDU0W9PCcKrmCjbsn5+KjtRdQ+tzJ+6jK1x7zhzpa+I1dA241Dr62iBZB7E9g9EI50DECkaD7Dch5hJautFzg6MY0660ZAaudcK7nezsQCYANDqQc1UerImdprCAuIFPfV2wVKUVJ4UrwVP6k8NgcYpqBpfqGwDAx5zYk31JVYTGCIs4jbB1IwM1Nj2PJYVq5W3MjLLi5TORj752mxXYqpWv8v7UowF0J5B9JqwyGfzx/0L0N+I5mp5wL3GGpTUcZN5ieMbtufOZ2Dytn5y4+GEqYpvFFPBT1R4QAC9+B5MNedEAo2YgaGcJw+lA4E9LzEDEHmOVsTExRI1iE5hhONMHRUjmaqV9
 Ci4nPjhv
 dgEnEO/jINyB4cqpV5gjbMx1THTQprF/bOaMTsatNu7/fi05YZZT54mvp0+l3OE0EhrtqE5sKOKNT/JKG4P3g9iLJ6MfMzhkWRWFMrpVDseWyeLmD2bnzal/xvQqEePaZGqwMnDw3Lznc9L9BwblnjUtb6YZSc+wT/39sJZSkizbRI804n7KChRIjWDtYgRfIlP4LE8K0caJ0nGpfRWH4tkelMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/11/2025 15:56, Kevin Brodsky wrote:
> On 11/11/2025 10:24, Ryan Roberts wrote:
>> [...]
>>
>>>>> +		state->active = true;
>>>>> +		arch_enter_lazy_mmu_mode();
>>>>> +	}
>>>>>  }
>>>>>  
>>>>>  static inline void lazy_mmu_mode_disable(void)
>>>>>  {
>>>>> -	arch_leave_lazy_mmu_mode();
>>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>> +
>>>>> +	VM_WARN_ON_ONCE(state->nesting_level == 0);
>>>>> +	VM_WARN_ON(!state->active);
>>>>> +
>>>>> +	if (--state->nesting_level == 0) {
>>>>> +		state->active = false;
>>>>> +		arch_leave_lazy_mmu_mode();
>>>>> +	} else {
>>>>> +		/* Exiting a nested section */
>>>>> +		arch_flush_lazy_mmu_mode();
>>>>> +	}
>>>>>  }
>>>>>  
>>>>>  static inline void lazy_mmu_mode_pause(void)
>>>>>  {
>>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>> +
>>>>> +	VM_WARN_ON(state->nesting_level == 0 || !state->active);
>>>> nit: do you need the first condition? I think when nesting_level==0, we expect
>>>> to be !active?
>>> I suppose this should never happen indeed - I was just being extra
>>> defensive.
>>>
>>> Either way David suggested allowing pause()/resume() to be called
>>> outside of any section so the next version will bail out on
>>> nesting_level == 0.
>> Ignoring my current opinion that we don't need pause/resume at all for now; Are
>> you suggesting that pause/resume will be completely independent of
>> enable/disable? I think that would be best. So enable/disable increment and
>> decrement the nesting_level counter regardless of whether we are paused.
>> nesting_level 0 => 1 enables if not paused. nesting_level 1 => 0 disables if not
>> paused. pause disables nesting_level >= 1, resume enables if nesting_level >= 1.
> 
> This is something else. Currently the rules are:
> 
> [A]
> 
> // pausing forbidden
> enable()
>     pause()
>     // pausing/enabling forbidden
>     resume()
> disable()
> 
> David suggested allowing:
> 
> [B]
> 
> pause()
> // pausing/enabling forbidden
> resume()
> 
> Your suggestion is also allowing:
> 
> [C]
> 
> pause()
>     // pausing forbidden
>     enable()
>     disable()
> resume()

I think the current kasan kasan_depopulate_vmalloc_pte() path will require [C]
if CONFIG_DEBUG_PAGEALLOC is enabled on arm64. It calls __free_page() while
paused. I guess CONFIG_DEBUG_PAGEALLOC will cause __free_page() ->
debug_pagealloc_unmap_pages() ->->-> update_range_prot() -> lazy_mmu_enable().

Arguably you could move the resume() to before the __free_page(). But it just
illustrates that it's all a bit brittle at the moment...

> 
>> Perhaps we also need nested pause/resume? Then you just end up with 2 counters;
>> enable_count and pause_count. Sorry if this has already been discussed.
> 
> And finally:
> 
> [D]
> 
> pause()
>     pause()
>         enable()
>         disable()
>     resume()
> resume()
> 
> I don't really mind either way, but I don't see an immediate use for [C]
> and [D] - the idea is that the paused section is short and controlled,
> not made up of arbitrary calls. 

If my thinking above is correct, then I've already demonstrated that this is not
the case. So I'd be inclined to go with [D] on the basis that it is the most robust.

Keeping 2 nesting counts (enable and pause) feels pretty elegant to me and gives
the fewest opportunities for surprises.

Thanks,
Ryan

> A potential downside of allowing [C] and
> [D] is that it makes it harder to detect unintended nesting (fewer
> VM_WARN assertions). Happy to implement it if this proves useful though.
> 
> OTOH the idea behind [B] is that it allows the caller of
> pause()/resume() not to care about whether lazy MMU is actually enabled
> or not - i.e. the kasan helpers would keep working even if
> apply_to_page_range() didn't use lazy MMU any more.
> 
>>>>> +
>>>>> +	state->active = false;
>>>>>  	arch_leave_lazy_mmu_mode();
>>>>>  }
>>>>>  
>>>>>  static inline void lazy_mmu_mode_resume(void)
>>>>>  {
>>>>> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
>>>>> +
>>>>> +	VM_WARN_ON(state->nesting_level == 0 || state->active);
>>>> Similar argument?
>>>>
>>>>> +
>>>>> +	state->active = true;
>>>>>  	arch_enter_lazy_mmu_mode();
>>>>>  }
>>>>>  #else
>>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>>> index cbb7340c5866..11566d973f42 100644
>>>>> --- a/include/linux/sched.h
>>>>> +++ b/include/linux/sched.h
>>>>> @@ -1441,6 +1441,10 @@ struct task_struct {
>>>>>  
>>>>>  	struct page_frag		task_frag;
>>>>>  
>>>>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>>> +	struct lazy_mmu_state		lazy_mmu_state;
>>>>> +#endif
>>>>> +
>>>>>  #ifdef CONFIG_TASK_DELAY_ACCT
>>>>>  	struct task_delay_info		*delays;
>>>>>  #endif
>>>>> @@ -1724,6 +1728,18 @@ static inline char task_state_to_char(struct task_struct *tsk)
>>>>>  	return task_index_to_char(task_state_index(tsk));
>>>>>  }
>>>>>  
>>>>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>>>>> +static inline bool in_lazy_mmu_mode(void)
>>>>> +{
>>>>> +	return current->lazy_mmu_state.active;
>>>>> +}
>>>>> +#else
>>>>> +static inline bool in_lazy_mmu_mode(void)
>>>>> +{
>>>>> +	return false;
>>>> Just pointing out that this isn't really a correct implementation:
>>>>
>>>> lazy_mmu_mode_enable()
>>>> ASSERT(in_lazy_mmu_mode()) << triggers for arches without lazy mmu
>>>> lazy_mmu_mode_disable()
>>>>
>>>> Although it probably doesn't matter in practice?
>>> I'd say that the expectation is invalid - lazy MMU mode can only be
>>> enabled if the architecture supports it. In fact as you pointed out
>>> above the API may be called in interrupt context but it will have no
>>> effect, so this sequence would always fail in interrupt context.
>> Yep, but previously there was no way to query the current state so it didn't
>> matter. Now you have a query API so it might matter if/when people come along
>> and use it in unexpected ways.
> 
> I suppose the best we can do is document it alongside those helpers
> (David has already suggested some documentation, see patch 11).
> 
>>> Worth nothing that in_lazy_mmu_mode() is only ever called from arch code
>>> where lazy MMU is implemented. I added the fallback as a matter of
>>> principle, but it isn't actually required.
>> Yes, I agree that's the intent. I'm just wondering if it's possible to enforce
>> that only arch code uses this. Perhaps add some docs to explain that it's only
>> intended for arches that implement lazy_mmu, and don't define it for arches that
>> don't, which would catch any generic users?
> 
> Yep sounds like the best option - a lot less risk of misuse if it can't
> be called from generic code :) The build would still succeed on arch's
> that implement it, but the kernel CI should catch such calls sooner or
> later.
> 
> - Kevin


