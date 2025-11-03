Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04C5CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 398788E00BC; Mon,  3 Nov 2025 13:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3487E8E00B8; Mon,  3 Nov 2025 13:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 237FE8E00BC; Mon,  3 Nov 2025 13:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1046D8E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:08:59 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A25E01A02BE
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:08:58 +0000 (UTC)
X-FDA: 84070081956.08.10CD41E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF7E74000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:08:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oMupISCSYd/eNzrdMLFaLu2UlclpMU6/awU7/8GJBY0=;
	b=ysIlynFr/tJFLKyobwVVmD0TOM/JMCugoQKq4o6hVh4R40kVPuKBV7iRLnAToHNSfYxHDe
	Hd9cQtNUSfP9IHBmZ2DeY1KGNFCUgfRYHvKAN8nfEerS/C0A1dzFqZQI+kI6Wb0PANtRqx
	5UbFealcptK3K7du24/+0Y5Ificfotk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193337; a=rsa-sha256;
	cv=none;
	b=shrYhgHGbOYqbdm+cXCHi5d2PMTAQfJsV5MOJRRStC/6xRnzv+Maa9QrPrphT/1lVr1ct8
	jtg8pDCm5X8KFUdCI6TsUeN79DXUJbxxwR95ka1ZLV7t4+AAEOsCFTgzVw3fV9wFBwhKIz
	Y2sHamN6fMq7NWlx/Y8M6aGbfd6NUjs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DBAF2A6B;
	Mon,  3 Nov 2025 10:08:48 -0800 (PST)
Received: from [10.1.30.16] (unknown [10.1.30.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 463A43F694;
	Mon,  3 Nov 2025 10:08:48 -0800 (PST)
Message-ID: <1965fe85-3734-45e9-af89-651c65845e8a@arm.com>
Date: Mon, 3 Nov 2025 18:08:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
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
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <ae1236da-2647-4d53-bf4d-ff8fc32eb734@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <ae1236da-2647-4d53-bf4d-ff8fc32eb734@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: EF7E74000E
X-Stat-Signature: aangqzk1fhtm7zuuebk6m9gm6m15cr3w
X-HE-Tag: 1762193336-148736
X-HE-Meta: U2FsdGVkX1+y9v2ikCXjq1AnWETbdFZK1oODSve+rzFs+iWO0SbXr0KMPAjgdk+tjCsuv+OmvHwantNL8BsaA2kGqMKsib9PoIXM+RqXHno4/pE/7wgRcSD5NXxGNC8fkiu9/46m+WMLhnecvsMmvaCnwSdOMaCR7pOwf7bQieZz+ofh6E4HbpJEAcZw1lyFEO+v1zgre/YCdrpB1/5ETwSoVG3o+TjLc7N392jg3vumOXfHTY2pIpDPh+JWope2OVSeJM8i45ylVTuu1gktyFYr/SAOXwI+W9PNE1pnlNSohdkUol02L6zVMN9dYi41PvnjLQKzIEQfgYg4GWNmcX9/61ZwLzC8Bd5NLSmZEjAnjHTZiiHlxEto6dgA5wSH666APaQbnxWLOm4LXIw4oqjFuxEWz3LqwrSjuRkRBj9bFYh7UeDkp77ilZPvtDBR5uVPpwH+sQfFaCtLijWYj3Nk9fvYvKi9v84NHene22H9p+cn0xGwpe+sqjJ6sJevuMeKMPXT3cXC9YO9iftfwjWHhq2p2z8hZCZNYAQmLtmlSnI5F5JqykDkgveplEutfCLsbfzFVYU2ipc+pIrVM9ZMb+317Bg4fv9VF1KOVqBiYH+JNglts3hkcvczTzOUMLzK22L48/NhDEHukHSczSCxp++ViS5AMmR9KcnQOMDUqYtopkFFtopgI3Qf3+OV+kLzovWMO9YAG9ot4SjL8BUOXspLQwQVZ5YB3VFelG7JZ9v9m/xkcJEafqWy5wH6qEG1WcMqf77BvMU06G6MYrM5qxY9tS5SPtvcrGJ/nMDsQv8VCanuH0M5ADKgpdtVAS/XWqEmgph4iUhGvwfu/EiJTkWLLhlnCg3wplqcPDIySTm5wnl816/mBFTQKaC2+13XNw6KCm6mtq1prnocyHomnjsx2pdF8/Qpukbo8EX9kaulBDiu61J9MR911KDowWhDMkLWjEznoIHDrER
 Kyjrewul
 QBBdIgZ3TepDfe6tP5r3UVZ98EMMOhOdfAAg+QNeXBsa3qsg9LSxXQXVWlb+edI55Bd/K79jwsQNkUg7Va09ovSXAG4IWdYJmL4AE7Y9w1fBz7FL5kObzzr96x1gpaSHdAtLthwlhYH6gn4gZOwJaWGVJW0zawIV8YW2vf+qa3AJ1aGLjWBlkx+kdiGNJrKaweJztvtzAY6/6J9VH65kme2rsTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/11/2025 12:22, David Hildenbrand wrote:
>
>>   static inline void lazy_mmu_mode_pause(void)
>>   {
>> +    struct lazy_mmu_state *state = &current->lazy_mmu_state;
>> +
>> +    VM_WARN_ON(state->nesting_level == 0 || !state->active);
>> +
>> +    state->active = false;
>>       arch_leave_lazy_mmu_mode();
>
> Just one question:
>
> Don't we want to allow for pause/resume when not enabled? Would seem
> valid to me, because pause/resume code should actually not worry about
> that, right?

This does sound sensible, thanks for the suggestion. The initial goal
was to allow functions that know they're called with lazy MMU enabled to
be able to pause it temporarily if they need batching disabled. But we
could generalise this to: if you know batching would break things, then
you can preemptively add a pause/resume pair, and it won't do anything
unless you're called with lazy MMU enabled.

I also like this as this removes an invalid usage situation - now as
long as you have balanced enable/disable and pause/resume calls, you're
good. Will make that change in v5.

- Kevin

>
> if (!state->nesting_level) {
>     VM_WARN_ON(state->active);
>     return;
> }
> VM_WARN_ON(!state->active);
> state->active = false;
> arch_leave_lazy_mmu_mode();
>

