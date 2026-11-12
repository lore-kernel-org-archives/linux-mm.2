Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F562606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=dcVeGkuz
Received: by kanga.kvack.org (Postfix)
	id 7016C6B05B8; Thu, 12 Nov 2026 08:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8956B05BC; Thu, 12 Nov 2026 08:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF966B05BF; Thu, 12 Nov 2026 08:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2F26B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:21:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63D251A05DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:21:49 +0000 (UTC)
X-FDA: 85426529538.22.1185BAE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 874D520002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:21:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dcVeGkuz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794489707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjqczUye1MVwPqhaOlQgDiP5yhV0lWKaPzJ6WzQm5OE=;
	b=mIfr/108DHeQa+qoFNEm63pIJuf531gLAmV/o/bSYBXoPcraVRlhKAbMvShvw/CjeOgKNu
	LhOYx/j45hYT1iEqH9BLQmI1+ZgoWczM2WpVtf1kaWpBH5ET5NSLA8ppbSuQMhpQLFzhP6
	ALe0AxtZorEKqEospTRL6GVzUT4OBBk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794489707;
	b=y+Po/n3leZrIF0qhDFB/Vc4nAVIiFaSUb8SKXMA5mBOrdzQaUvA5r/0zuVa3XpDxrJvUgn
	eDJweRq4LzSMAHCGssXWxyJVRhJOUOkDoY7xaF30MfYqtcTukRiwi8mhMVV1GB3vlTay1q
	Nr4PUG1kACOJi5mTAIKuAqXa5LSRImk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dcVeGkuz;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63726165C;
	Thu, 12 Nov 2026 05:21:43 -0800 (PST)
Received: from [10.57.59.183] (unknown [10.57.59.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 193F63FA7A;
	Thu, 12 Nov 2026 05:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794489706; bh=HfYryOQX0VfevLVVawDWgNmplypwK1zuJ64tPBf60Vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dcVeGkuz8JRTli4xPVnr0cneyHwitzpVLR6K5+VmuJc5TLTZ3SfUxK00ybswx7BHw
	 ZABhy4k+P+PlalTjxCNRVuyEB+uUvxZ5kl4kQRedzTz5e4bpIBQT65bhwnQBBCJ2k7
	 rstlfOYgzutGXSfnrukT/eNGHieeTuBJwM+G1P/I=
Message-ID: <e1cbaf1c-940e-4298-a5f7-dcfbe12ec7dc@arm.com>
Date: Thu, 12 Nov 2026 14:21:37 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 19/22] arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES
 switches
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-19-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207333@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207333@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: icshd46abapoiwtxoc6qs8bd3j16hs4k
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 874D520002
X-HE-Tag: 1794489707-248615
X-HE-Meta: U2FsdGVkX184ALrZf+e2FDdQ59YtsTuUFzKlgcFQQmjeRnB83GKLSBlL9aXGhVD/MCfEBJtiAamNMFOyvqobOynEQpHYZgAYhUPCLZhdC+9gOWOf5QCcFb/hSqvk1pT8W/vNHjOWca8QTE751xUmgjTKfgKdZu0yk5+JbwEW8p/bZf9/raANRHyawmJGUDcec8IUDhxj1rff9JevprW4Uoh6RzWZ9GDb5cMN2KTmrUJqdJPI0GCQV/5lJ1yg+8AD1nwoh97J+h24oOIkneFRwG61ZHdNwbj/eiAzVmPuMPRgIIVHOF0gtiKHOmz6xl0Mr6dhug9guW6RK8wObCG73hzp4TLaFIshtCNIZ0U0XrvO8SI/YxLBqxu3JOVOmjtcyeomj9pEoO8NbZI5UGIwiZLYzINAMh9RA3MdKuM1FqVcKHcDJbReZQSzpG8MZ4Jpeit8QeFUl9tM406SZiIXXPyNpHbQEshJe5GxWJ8n9uXj4dszhF7+SjUynj9cM//x5H2+zS4y/u5V94CXSjbdy6wm6jOyzPL3n4EGNjPCQP45mTWXxkoyebg5Qs/R4AeEljnHMZpmkW8zOatlQSNeEXisi4jorKRfF5iR0knWCrTJQisfKbrBQHBLq/AsqXn1gvqa1h29Rlyc6qiScjpUPMqvKTLj9U33z8he6SJY7UDC0/cVu/9MT9FXlfAiw82tpM3Nt7B2zzWj7MSrFmIFSVDnVWi8u0UP2eZnAvjP/DpeN1k1L2Rzpk4Pa42sju1tX70KVN96y4cgveau+r/zRVbgAlej+qxHFJGaZvJapvpidXIJ6A76aPrkyQWH9QqHiJmu8L6fQogRFl2e2r3VF5p+wQ2YOQ2y+Qqy7GBgTGn4qHAY7cBAvI9PMRYaqbIN2i1mQlmgc6+S9Ngq0ZI2WQaGeeca/7yZjKZ+aInLgxID8ZY2+beuDdrnQvWj6ot3IV9C1BjbqNS5Mero37I
 5DH3sWhP
 PewMtSMXECTkbWdu/2P2RQNzviGBM4IK2Iu4ZJB+S6Z5zpSphUz0nG/118ERto64v7fsLpQMI+OcdCv7qKI8ExB3AN2ycyLHlwr6tvi4sMCtpB6HRZB/ZMaqec18wjAYFogShe/c4tMWOD4AC56c2epLM5Fcr2f8bktWkNUqGLvUy631mCCZkqXvn1L7j6oL3ENKmqofXy+fAMzVXhU5SvthabVe3jJu83iXPBXGvc5BQBkxOj9JiFDOl+yMm9H/pr36gRIpnObbWPJiKV7yr5uvcngLmM6ZzCmb4NbVrV0Pa4QTHTKUem8otsU4Uj2uSIlOKHnFhVQ7kPzyOUDY7wvtfKkMfkN/il+rUig7ZBn+Osi4q3+GmiRnblVKoyz7392DUKa3nfZJPol/tHPeSSWOqqFZpkjj5W+Cra04IWPIF7yxb3wvnxVKEO2Z8lDtup+TVPmrUifDPAzar3oUNHFIZSg63sh0g0KY5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] arm64: kpkeys: POR_EL1 desync with is_lazy_mmu_mode_active()
>   on entry/exit
> --
>
> commit 1b260fb8242fe345fd5e4bdc00ba9a4272383991
> Author: Kevin Brodsky <kevin.brodsky@arm.com>
>
> arm64: kpkeys: Batch KPKEYS_CTX_PGTABLES switches
>
> This commit batches KPKEYS_CTX_PGTABLES context switches across lazy MMU
> sections by switching POR_EL1 when entering and leaving lazy MMU mode and
> skipping per-write guard switches while lazy MMU mode is active.
>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index 5f46d4cb38828..5e958531e6abe 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -43,10 +43,44 @@
>>  
>>  #ifdef CONFIG_KPKEYS_HARDENED_PGTABLES
>>  KPKEYS_GUARD_COND(kpkeys_hardened_pgtables, KPKEYS_CTX_PGTABLES,
>> -		  kpkeys_hardened_pgtables_enabled())
>> -#else
>> +		  kpkeys_hardened_pgtables_enabled() &&
>> +		  !is_lazy_mmu_mode_active())
>> +
>> +static inline void kpkeys_lazy_mmu_enter(void)
>> +{
>> +	if (!kpkeys_hardened_pgtables_enabled())
>> +		return;
>> +
>> +	current->thread.kpkeys_state_lazy_mmu =
>> +		kpkeys_enter_context(KPKEYS_CTX_PGTABLES);
>> +}
> [Severity: Medium]
> Can a synchronous exception between updating current->lazy_mmu_state and
> switching SYS_POR_EL1 cause a fatal permission fault when writing to page
> tables?

Sashiko already reported this on RFC v9. What I concluded is that this
is very unlikely - we shouldn't get a (non-fatal) synchronous exception
in that window. The one plausible case is kprobes, and I guess the
answer to that one is: don't put a kprobe there :) (We can't easily
enforce this though as NOKPROBE_SYMBOL() doesn't work for inlined
functions.)

A more serious concern is that since RFC v7, POR_EL1 is no longer reset
on exception entry, because that doesn't play well with lazy MMU mode
either [1]. If we found a way for lazy MMU mode to be fully disabled
while exceptions are handled, then it should address both concerns at
the same time.

- Kevin

[1]
https://lore.kernel.org/linux-hardening/7dc9485d-a822-494d-9384-4a973c782c11@arm.com/

> lazy_mmu_mode_enable() and __task_lazy_mmu_mode_resume() mark
> current->lazy_mmu_state active before calling arch_enter_lazy_mmu_mode():
>
> include/linux/pgtable.h:lazy_mmu_mode_enable() {
>     ...
> 	if (state->enable_count++ == 0)
> 		arch_enter_lazy_mmu_mode();
> }
>
> On arm64, synchronous kernel exceptions (such as kprobes or KFENCE page
> faults) do not set NMI, hardirq, or softirq bits in preempt_count(), so
> in_interrupt() remains false and is_lazy_mmu_mode_active() returns true:
>
> lazy_mmu_mode_enable()
>   state->enable_count++ (0 -> 1)
>   <synchronous exception, e.g. kprobe / KFENCE fault>
>     ...
>       __set_pte_nosync()
>         guard(kpkeys_hardened_pgtables)()
>           is_lazy_mmu_mode_active() == true  <-- skips POR_EL1 switch
>         WRITE_ONCE(*ptep, pte)               <-- unhandled EL1 permission fault
>   arch_enter_lazy_mmu_mode()
>     kpkeys_lazy_mmu_enter()
>
> Because is_lazy_mmu_mode_active() is already true while SYS_POR_EL1 still
> maps KPKEYS_PKEY_PGTABLES as read-only, both a nested
> lazy_mmu_mode_enable() and guard(kpkeys_hardened_pgtables)() skip
> switching SYS_POR_EL1, and the page table write faults.
>
> A symmetric window exists in lazy_mmu_mode_disable() and
> __task_lazy_mmu_mode_pause(), where enable_count or pause_count is updated
> before arch_leave_lazy_mmu_mode() restores SYS_POR_EL1.  A synchronous
> exception in that window that enters a nested lazy_mmu_mode_enable() sees
> SYS_POR_EL1 already set to KPKEYS_CTX_PGTABLES and overwrites
> kpkeys_state_lazy_mmu.entered_context with false, causing the outer
> kpkeys_lazy_mmu_exit() to leave SYS_POR_EL1 writable.



