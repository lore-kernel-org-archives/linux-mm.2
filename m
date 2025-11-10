Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE5C6CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 06:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218278E0006; Mon, 10 Nov 2025 01:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8918E0002; Mon, 10 Nov 2025 01:12:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B7578E0006; Mon, 10 Nov 2025 01:12:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EDE138E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 01:12:13 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9373D140C38
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:12:13 +0000 (UTC)
X-FDA: 84093677346.04.47840AF
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf22.hostedemail.com (Postfix) with ESMTP id 988C9C000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 06:12:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyAN4c8D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762755132; a=rsa-sha256;
	cv=none;
	b=J1G/qOUtsSXve1jwu5/DB5sygGI/s2LDwtSuBghW694t2rolBsbT/+QclN4bl0xfTD9Y2O
	eflB90c6iGgCrEby+uQXShOu62RLNcSvx7pKE7WF0Hz2SIWHkFLyUB8w6nfaAvMo2TZnVj
	LbFKci1F/auHAH+cB6e+luAJ0nnmtZY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyAN4c8D;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762755132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TVI42Ht4KJq3XQAXSl87HHit5RIvDqcfLhp3PfZoCwg=;
	b=1ABJw4vRfskqY5QVQ81VjGkDueRROfGUqIq9heEYLJZ+3VRpkCnJqXrcK0Eko98nm6exAl
	3PZSZs46w0zTuT9lotpR7jEczclVAYmsPyu+yOEvyeEPdcpiJBPMIWEklYMt1DEH+yM7/z
	ByGGb44/fRXeopwBhcDHXRvk/FJF1pY=
Message-ID: <79ba4e0c-eac8-420e-b6b2-b7cdede5dcfc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762755129;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TVI42Ht4KJq3XQAXSl87HHit5RIvDqcfLhp3PfZoCwg=;
	b=pyAN4c8DF7ukkFGezZGvuyGuPkdtfhlCZrR120hxx6n2B1ZrtYQFeoh9xaUxAvVhlX2p5R
	mH+pNLp+RF8MNwIpi7g0gd++ZzHw9smbam92okspni+o12Co6uwIClrFQrzMrsLPO8NZXe
	ZSadIjKfb+qAhPAwJ2VlAmxj3HswspY=
Date: Mon, 10 Nov 2025 14:11:54 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry> <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo> <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
 <aRF7eYlBKmG3hEFF@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRF7eYlBKmG3hEFF@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 988C9C000A
X-Rspamd-Server: rspam07
X-Stat-Signature: bhjf189o43nte3ga15wfewsuk61madgq
X-Rspam-User: 
X-HE-Tag: 1762755131-939998
X-HE-Meta: U2FsdGVkX18vh45A2Jrcl23pv4Km0G9mPJ1UCG4mbkJi5KH1Tp/eLx+kLbS7QQRFHPWfwMqikMfbwM5JNwyYKO5pW22WLlQiE98a+THasht0rLJ/BXUdGUT4p6piMdKE3Zfcca4TBX3SmTN+qF9z8+5Zh+JEhhdx9Zsx6NhXt/9Ximxbr8jn3g6YE+Af8BzO0/7S5iu7y+odjRwBt6nvB5nXgBhU2i5PIxmIR622AimwiGx3EPlBQULxEW44LXH/fZnqN4SznT0GNlrVrL7Xk8P+D2uf/bW3Y3LP2b851esr5FVspRhkW2ulMzW2gOzXK7l+60uSMkBQcC5v9dH8/CJD0JRgM6byTi6GJWs2jRiLBzlSi7W7B/KgV9zbv5vXku08zAeMBTRvPmbC51xz1XVL0zxNcmdNaEPkwFHOdITORfNEsn/u5ooPJqNCnSD1ta8avU5eWbhZBnkU51nbzrQdRVjk3M+JkvSXIrM0PENwgnJ6VsbwY+Ztlw/hEeg/LfGDZVg98HhsXj0KJ72Aq8iTpM0BI8jmc1c80z5IrRd6fvNF+xlR7GvMS+PQu2UCsmdaFLXAk8OHdhw3sDLsjxzYPRpRr9WbNbMA/kC60fjRmWZvccwjPyHBQTTS/dhuOhWZxMg+aicE/Nm503ETa087KUAos6InVi/YfqGYw9dz3YI6E1Hu9WElsn+sQRn6tToljIrzR+Bpc77kABRraID7eMkY0EvhioH60+MgE+TyMOpuITJthpKBrabgyTMuT5PXjy55Cu4Y/5vqcbDzU/Sirmd1VwvVKe9PM8VTv5hNTOvNbQ2HJDGf17UIBLBxOD7yoCJ/Tdw8pp/TNMDSbb6SsCHw3hUf8y6KBwMyajsWvVTipPQ4RVu3VUHM3FNN2qnESqzQKCZWT6Kz0iAkFelbNGJtRr3oFj3xoGYsg6LvXQ6B4t5dN4T3M5UqqZ4ELrb53k2Do8SF9nynxzX
 YlA0pkb9
 WYyMa6v+QQq8gxxdgNCJVFcsccdDGGjyy6oMbmL4ob5PP/qIzWZ0Fqa+rD5ZH9DjNIuvM52z65lgHS3q1w5dha2B9aB/2H3bn4+BuPsZv2W5tOqs0+/lZvfH9BWjT7q+E+QHXjMy/VwHaAS7dVj4y1LLGh23hI+j89dM3I65yNBbicAFNTtwjt//XapcW9riXW4VuMDwjH5cjH2eHXLsx1VmfPaCVjWnsk5SPxwzZ1TxmlxKQEdMCt2Kt7ThP4EEnSYHN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/25 1:43 PM, Harry Yoo wrote:
> On Mon, Nov 10, 2025 at 12:30:06PM +0800, Qi Zheng wrote:
>>
>>
>> On 11/10/25 10:13 AM, Harry Yoo wrote:
>>> On Fri, Nov 07, 2025 at 10:32:52PM -0800, Shakeel Butt wrote:
>>>> On Fri, Nov 07, 2025 at 10:20:57PM +0900, Harry Yoo wrote:
>>>>>
>>>>> Although it's mentioned in the locking documentation, I'm afraid that
>>>>> local_lock is not the right interface to use here. Preemption will be
>>>>> disabled anyway (on both PREEMPT_RT and !PREEMPT_RT) when the stats are
>>>>> updated (in __mod_node_page_state()).
>>>>>
>>>>> Here we just want to disable IRQ only on !PREEMPT_RT (to update
>>>>> the stats safely).
>>>>
>>>> I don't think there is a need to disable IRQs. There are three stats
>>>> update functions called in that hunk.
>>>>
>>>> 1) __mod_lruvec_state
>>>> 2) __count_vm_events
>>>> 3) count_memcg_events
>>>>
>>>> count_memcg_events() can be called with IRQs. __count_vm_events can be
>>>> replaced with count_vm_events.
>>>
>>> Right.
>>>
>>>> For __mod_lruvec_state, the
>>>> __mod_node_page_state() inside needs preemption disabled.
>>>
>>> The function __mod_node_page_state() disables preemption.
>>> And there's a comment in __mod_zone_page_state():
>>>
>>>> /*
>>>>    * Accurate vmstat updates require a RMW. On !PREEMPT_RT kernels,
>>>>    * atomicity is provided by IRQs being disabled -- either explicitly
>>>>    * or via local_lock_irq. On PREEMPT_RT, local_lock_irq only disables
>>>>    * CPU migrations and preemption potentially corrupts a counter so
>>>>    * disable preemption.
>>>>    */
>>>> preempt_disable_nested();
>>>
>>> We're relying on IRQs being disabled on !PREEMPT_RT.
>>
>> So it's possible for us to update vmstat within an interrupt context,
>> right?
> 
> Yes, for instance when freeing memory in an interrupt context we can
> update vmstat and that's why we disable interrupts now.

Got it.

> 
>> There is also a comment above __mod_zone_page_state():
>>
>> /*
>>   * For use when we know that interrupts are disabled,
>>   * or when we know that preemption is disabled and that
>>   * particular counter cannot be updated from interrupt context.
>>   */
> 
> Yeah we don't have to disable IRQs when we already know it's disabled.
> 
>> BTW, the comment inside __mod_node_page_state() should be:
>>
>> /* See __mod_zone_page_state */
>>
>> instead of
>>
>> /* See __mod_node_page_state */
>>
>> Will fix it.
> 
> Right :) Thanks!
> 
>>> Maybe we could make it safe against re-entrant IRQ handlers by using
>>> read-modify-write operations?
>>
>> Isn't it because of the RMW operation that we need to use IRQ to
>> guarantee atomicity? Or have I misunderstood something?
> 
> I meant using atomic operations instead of disabling IRQs, like, by
> using this_cpu_add() or cmpxchg() instead.

Got it. I will give it a try.

Thanks,
Qi

> 


