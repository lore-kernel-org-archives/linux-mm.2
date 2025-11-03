Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C43CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 090F98E00C0; Mon,  3 Nov 2025 13:29:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0693C8E00B8; Mon,  3 Nov 2025 13:29:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7DF8E00C0; Mon,  3 Nov 2025 13:29:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC47B8E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:29:13 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75B1587C61
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:29:13 +0000 (UTC)
X-FDA: 84070132986.21.A60B909
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id BDEB718000C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:29:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762194551; a=rsa-sha256;
	cv=none;
	b=tLuVl+Y4OJdA2Bh3jU8Hx0D+U7slY6dzTDcq3lk1/nOfq6JTzc9pTH5Pook4EyHYMazUqH
	XOSXqp+hILRFPdKsbUwjN6Il0xpmCG+st5Kf3kY2XvxPeNKjgnNVN62BwREfJxYdg3T0WZ
	lQQ3NBECWmKq8GXERwyuH5VA49Lo+FY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762194551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PejloQnKGuK3bpH0pnM/kdDvHB2ShDka/sYljxbJywo=;
	b=wdfJHtwkFq128W5UtRw7B42vHmnFcvKvTA1RoAK9YWWSouatY0USf2dthAbg/SV69IPAuj
	vvLd5wRD22daBEv26tO8cFDVDJwqiRTYFMQP8djFtlhYZJ7Z92fGkgMy1CP6bDRDbkP0j4
	Uoy7+sPF4WTif5ZQpiTJqRNoU/9l+7Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD0752A6B;
	Mon,  3 Nov 2025 10:29:02 -0800 (PST)
Received: from [10.1.30.16] (unknown [10.1.30.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 191F33F694;
	Mon,  3 Nov 2025 10:29:02 -0800 (PST)
Message-ID: <285faae4-dab6-4819-847a-889bdf87d5d7@arm.com>
Date: Mon, 3 Nov 2025 18:29:00 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] x86/xen: use lazy_mmu_state when
 context-switching
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, linux-mm@kvack.org
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
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <c7c8a233-2103-4b48-b65e-ec81666d20e4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDEB718000C
X-Rspamd-Server: rspam07
X-Stat-Signature: exutj4a7adf4z6o7awo8bam8zwhnfrjq
X-Rspam-User: 
X-HE-Tag: 1762194551-613079
X-HE-Meta: U2FsdGVkX1+5GPwLaE+YY4tfqNImetnPWjpwOyshYhOA7RittxYxbF/k4OfKwq2hpGauPzEEZ9cREDeIdrV9CdZw7nIOgbP7R5RdKNDOHj2799jl64Lh0YoXU6EpzEqAQQo/gSMIL63v11JrDW6nmKT2QCxUDww5uetD+Gg96RYfReeL2Tb7CRqxkB3frnieo5/wTr1BsZdg94jArSccnIW4Zlaqr//Xwo3eUA5olubMs8BFsz+WXaUM+vFGePJ0qWpAxNDy50xK/YrpjqfdtPOrkM4IQwcSdPBxGk1jh2APic3P3zniXOygjML6shDFUP/nK+epTtK6KJ9k5FpiFDA7/7wUiDIXO5Dw67j1pDRzrahJfXuNLdSwHibTIFPOn3nIls4Q3ule5COv23/5ZKgd69JNDgtECCGjknXEsJ4fLYieBDmCq02q8SRN4iQOTCqaqMgDbso5bQXoitPsP+jqajM8iyNSROWihaUXLv7vV7HITmIHMbBR7dFttXN0VJOqWjKw/2ejoqdM0nPzewttU7QYaVuR30bYW3ySiXRNfkk1O1eHjXYkHe0gfDVqDaGXJNkdJ44yKwaIj3hz/wC304hMJK8Bou/C4jatOLI3bbmDBatYePwa7q1Jo3XCvdHEL1W2stbNU1AnYXAs9U8e9gBkrVZ8h7o5NovYAqwy3C7TT9jJykCkyM80hLw+NJ7z9pFjhkaDCr1XDKSMJMmckXxAoeplNTN1DaH+2PYZnno1DrGIWBfrA+7SEsgdwV76bj72gEcphlctBTloxm7Wqx/YJPgZtyL/sfdoW4xZyTzWSkodXRfkFIYmp2q9CNz3kPUKG/dW5ZLT3H9H3vq197fyawMonHiqCsPzPgDJQ8/bKS0/a3SHcIQOTu5tG59ZxTZieDUnNbCENLfqjVMgcUsc+VlLx4dalJ16Oo8b/rbi3YHMbuMLwllqpSDZy1Hg/WmW2HlrUoRy/l1
 4DePAE0S
 wFTlEEHgH7qg6XEaSZ5lP4hvABhhjEEapVOHJeavi3ea4gFAv+uIZBiUIPoMoV+fTvDHmTiM8b8c5t87WwX6H4hEOqWhR/ToARLi5k3R/jGZ95Sxe5aVTT1mlelLBUDx8j7y2fi8unTtLlDUu37PBJ3XJbiuuliXescZ5YRz/9gq+8lLmjKzq/OJK1RjfMbCvmvcf7D3kcsfM1mq8H/JBbAIcSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03/11/2025 16:15, David Hildenbrand (Red Hat) wrote:
> On 29.10.25 11:09, Kevin Brodsky wrote:
>> [...]
>>
>> @@ -437,7 +436,7 @@ static void xen_end_context_switch(struct
>> task_struct *next)
>>         xen_mc_flush();
>>       leave_lazy(XEN_LAZY_CPU);
>> -    if (test_and_clear_ti_thread_flag(task_thread_info(next),
>> TIF_LAZY_MMU_UPDATES))
>> +    if (next->lazy_mmu_state.active)
>
> This is nasty. If in_lazy_mmu_mode() is not sufficient, we will want
> to have a separate helper that makes it clear what the difference
> between both variants is.

in_lazy_mmu_mode() operates on current, but here we're operating on a
different task. The difference is more fundamental than just passing a
task_struct * or not: in_lazy_mmu_mode() is about whether we're
currently in lazy MMU mode, i.e. not paused and not in interrupt
context. A task that isn't scheduled is never in lazy MMU mode -
lazy_mmu_state.active is just the saved state to be restored when
scheduled again.

My point here is that we could have a helper for this use-case, but it
should not be used in other situations (at least not on current). Maybe
__task_lazy_mmu_active(task)? I do wonder if accessing lazy_mmu_state
directly isn't expressing the intention well enough though (checking the
saved state).

- Kevin

