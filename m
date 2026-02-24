Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE0AE9B262
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 12:57:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43356B0088; Tue, 24 Feb 2026 07:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AD06B0089; Tue, 24 Feb 2026 07:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D51126B008A; Tue, 24 Feb 2026 07:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF15E6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:57:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 579321A0127
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:57:40 +0000 (UTC)
X-FDA: 84479351880.02.B993AAB
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D75E1C0006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:57:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjE5rZYu;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771937858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ITpSuVeZjMjGUgIfLU7ZsbRR7wBeR6IvfybRhh1i/bA=;
	b=p6PcgBu+YrmbKfxD+tih72YYOXTmw+L9oGnW2EMQ/qKJg/rCgowhv/MCa+3AI/XdANSHPg
	MkABW1w5jLh3f3ZYixCCG7cXxGXjSHykhjv+wOX5AriHJyIU3VeAj8GV9tiAWMpkhgYfaR
	ewy4wiQM2xIbBCOTmSICeSd2i9a63T4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771937858; a=rsa-sha256;
	cv=none;
	b=JIMtDyUCSjmf74uNVVWqWbbqpZhfGzDsxcrmFtU3JsDm8fRsoa5rYdgpLtaPJD8WfIiAxZ
	0igjslHWApOSz5Qdw18o5ZlCRRN0EuGf8Pa8qL17U7Je9f/CCvTcja1WqZEFxNVdiKjqeG
	GoOUhRIH7Gs9iAVKPQBvYMWkHTet6EI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjE5rZYu;
	spf=pass (imf20.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d48e0326-a746-40ca-95d4-aff2c457877b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771937856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ITpSuVeZjMjGUgIfLU7ZsbRR7wBeR6IvfybRhh1i/bA=;
	b=UjE5rZYub6kFQCuKL9HCjr8WrgA2E5IALHbCXt1HuCtdYZE/De3cHoC2nJqXM7So6YI0EO
	sjhCFAVk+eCZ9rfDWbHJMUGzXokBUfAXFfzEsMD/7sWorxccVdHJ/jVZcUHrhcPu1GXOcm
	ZLtfPwIGxCb+wG05xRf7QHW2bc3qLZI=
Date: Tue, 24 Feb 2026 20:57:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Content-Language: en-US
To: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
 <5cc90e7a-ae32-4352-8e0b-2eee5a5ee122@linux.dev>
 <20260224123538.GW1282955@noisy.programming.kicks-ass.net>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260224123538.GW1282955@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: og7r7dzfcyphr7dxsdxqk9mpiphc3sd1
X-Rspamd-Queue-Id: 6D75E1C0006
X-Rspam-User: 
X-HE-Tag: 1771937858-329809
X-HE-Meta: U2FsdGVkX18w2fQdzDgYE8yCARirMAEULOafPAHcw2Ey/wPi0b4BVFiC+0/74dkkJFSRbV5v5Ivv7ji1GGh/YN9O19PFuS2M/vtfsu07fnIRAfzSl5UxVqJP84ZPaKk8DHz5j5jls25xnls0sfJY67c8bdTK5+h/g1N831nxbQcHdVo4V8zpyv4FXAF3DlBZAJDBqTvEbtt+LFZjyZRjSOOJKqjCoyVhjSSiEfHr80jCnQkWFYBcCCcYRw2JW9wlpO4purRULVoyMehnHhR/Hu6TW+d/aktC3UNU2CFQtBIvWuh+z8A8TbhIesbzwnwusDWoWUJgQJmklDUITCnvtPDcOknW1vJEkaQWRw3ZJMjsAJBF7cGH1EVZhH/pb06qX51yXTDlfGYtsPCJ+8bJ1vCxZddqISvz23ZUn8CP6XedkBZiOnOnMs07PFGbOwhpE+sA7f8gtAcooHGwPS72cmSQBlEBMsjt3fMcI70A2gObLoUMwp9Z7T4rCxcEKiORTEDvLNRVVVld7R31sLPg3VTb/vwZR2zB0/MychUUNROkWdO+P3p2GDtUTN/ul1x+d/1A0xkrshJ02291xeAgff6TbG6xQIlT1AbRkymvWCa1YgSK8zhIhzpiXHwT0KZbx1crtBHvLsNYChgyxbRvRvS1j8tS88ctbc7G2pgj1M708FDnq8xpVkb714RG5CxasSlVbLHq+GSw+OQqz5hbK1IWy4GcMQXwYNjFDmHax4m12GWMiE2I9wfYPP1MEewKPgNBhaPTg4ZU6273BnPLmyyicjgbyEnpu9ldRbuq3u7tZPkh6f6itUMKjnotgrTGbkylpSQFQfrlwqkYLFpCQUWYaDF21SKziKXyPxmaLtE56+hNEsLrsaF9fjhZSPYG2mYRliALwc+HwgSBji6Anb0eo0RggBGhISgbrLGW/XB7GWhFjxTVmJFUyz6f+U/dVNvYbi6wGkhkVVgBAQe
 absp8QYH
 m6vkkiyKWxxBPGjIWeH47/nD9iE5sJl1j5pCdKe32uXsW1dfDOMyJfAnOSeVwubfEtVU0KAO7mTJFLXeb1SI4hSHG5pM69VUWCD64WH5eOj9PgcWSZsJd0TLDjxOm0hYhtLo/ewPb0KpUrbsx/x0mgKeurtNPPqyXsNRNZiGK8dVob+1mBzpFfR0rcvAmJaR4ivn2UbjWyds0w3x1isC2jVwKCk9XziT+i3B+vX7s8aVzmq+1AlfOlf+sAnltEupEPNBe4r/WqC7jRe6TMk/3zRKoRhPPR3EWnhsbNJWiZ70oSHyVEWqDS5fy7v+cnBGp5arx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/24 20:35, Peter Zijlstra wrote:
> On Tue, Feb 24, 2026 at 08:18:46PM +0800, Lance Yang wrote:
>>
>>
>> On 2026/2/24 19:41, Peter Zijlstra wrote:
>>> On Tue, Feb 24, 2026 at 11:07:00AM +0800, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> When freeing page tables, we try to batch them. If batch allocation fails
>>>> (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
>>>> batching.
>>>>
>>>> On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
>>>> tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
>>>> process is unmapping memory. IPI broadcast was reported to hurt RT
>>>> workloads[1].
>>>>
>>>> tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
>>>> (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
>>>> local_irq_disable(), which is also an RCU read-side critical section.
>>>>
>>>> This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
>>>> period (synchronize_rcu()) instead of IPI broadcast. This provides the
>>>> same guarantee as IPI but without disrupting all CPUs. Since batch
>>>> allocation already failed, we are in a way slow path where sleeping is
>>>> acceptable - we are in process context (unmap_region, exit_mmap) with only
>>>> mmap_lock held. might_sleep() will catch any invalid context.
>>>
>>> So sending the IPIs also requires non-atomic context, so change there.
>>
>> Yeah, you're right!
>>
>>> What isn't explained, and very much not clear to me, is why
>>> tlb_remove_table_sync_one() is retained?
>>
>> Good point. tlb_remove_table_sync_one() is still needed in:
>>
>> 1) khugepaged (mm/khugepaged.c) - after pmdp_collapse_flush()
>> 2) tlb_finish_mmu() (tlb.h) - when tlb->fully_unshared_tables
>> 3) ...
>>
>> These are not slow paths like batch allocation failure. This patch only
>> converts this obvious slow path first.
>>
>> I'm working on converting the remaining callers as well, but not with
>> RCU, looking at other options (e.g. targeted IPI).
> 
> OK, so with that addition to the Changelog,
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks for taking time to review!

