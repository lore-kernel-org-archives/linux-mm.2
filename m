Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E164ECCF9F1
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 10:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 441AC8E0140; Thu, 30 Oct 2025 06:29:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4190B8E0112; Thu, 30 Oct 2025 06:29:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356378E0140; Thu, 30 Oct 2025 06:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2364F8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 06:29:08 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D1704140969
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:29:07 +0000 (UTC)
X-FDA: 84054407934.01.027F870
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id B92548000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:29:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761820146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WGsanynM+bveV70EQ4nqT1sLG5kUc3lKFttAynF/olU=;
	b=Fn+La5X+ZxYijfEOpTq/dt+Khd87rKkKFTAJXiKCkaWXX/2mdZtDR5uGriBQQMc5DATpKX
	dSgY1eDT0H2Qre8eca9vOqBaVUU7dECZcxZMrmr47FsO0G1wtArc08vccZydGYkNV/yavd
	+zfe9iLJu5oJGvzPffJrsgJw18RF7AU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761820146; a=rsa-sha256;
	cv=none;
	b=vRRUgAHNG9b3RAIE55klYI9iD6s42XHkU9JJQ+GxLCc7WQt9qUxwU5UJMDk5RFTschNhlD
	lKHtXHknh1/OIkeI98j4+XqHWzr3SMXE7WzJ5j/C1UCNGXbPgTBObrv1LSaicygARFCsPR
	xD6MwhEIxm11jXAWCt+Ztjw0JOf3FLA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E08BE1EDB;
	Thu, 30 Oct 2025 03:28:56 -0700 (PDT)
Received: from [10.57.69.77] (unknown [10.57.69.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A8D363F66E;
	Thu, 30 Oct 2025 03:28:56 -0700 (PDT)
Message-ID: <d0767b70-5686-4f6e-8ca4-10b3f3ff3991@arm.com>
Date: Thu, 30 Oct 2025 11:28:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] mm: enable lazy_mmu sections to nest
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
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
 <20251029100909.3381140-8-kevin.brodsky@arm.com>
 <ef0cd4bc-1a37-4755-8957-d8a7e5c4564e-agordeev@linux.ibm.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <ef0cd4bc-1a37-4755-8957-d8a7e5c4564e-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 69119y9nskht1pr6ptmsprhn1wcrcezy
X-Rspam-User: 
X-Rspamd-Queue-Id: B92548000A
X-HE-Tag: 1761820145-468813
X-HE-Meta: U2FsdGVkX19NzK3BTZtePLF6u2FP18WTOw8MAD0F38sGcJtMBIryllJeJs2fbQcCWdkOVl7FID8JpZViooBI3Qm4hdHFYDXyK26u0bW14IoXlQrFnwQMjY2G3LW3+CTWmXknPmytN1LhVeV+tprWpDoYwRqdzxQp8d4Tm0yRd9/63GZ+d/qm7Yvpmmmw1R9TRazQEdZw5U93FwAxrocHdJ4Q/6FidCe3kJ/MFK+ZtioER5QMMma+e8XIn8DOsb4bPWMMxWX16F7ljgXbxUrHekRFed5n0npkvjfS4LsJOq8RTdXLOEUjSxdfelnq/kJwodiN++iNh4tATappmqIfuGrpINVjPMQPiqtTsTZIO+j+v86alxkjsfBUABNCfc4u2c5CX8qsJL2DLuT3RDz0cbkmDS9uvArRrIheeRrB5ZxACdPmKP/jbOsR1jlNvF04Cf/drjo2uJi1EB8uY8XUZch8uYS46mI4pZ5LqOKpjJhivh5978uZjEFKNw9TAKeemlc3H7xyhPS+PEQTSxD+QBhU2LywUKEcV/xwNWxD9C4LEqF/NAjBwiN3y9QeAQ446i+EmU3L1VYbKJ3tDbyso2BvdRksMy2QwrIzEyUeECvi+6VQnI5ylJLnBKOlRzyYYnVvOcgkx9ACh1GHV/CASru+943IS9jDQH+lxkLuVexfP3mVFhf5kk90WBovXs7/Qix3e2SlwEVzx21fPJt+Dlt8vctbxdgoaDY4LQqtjTuLru60HlK+oF/3ZE9NFJyS3Q7kpvl3iPbiqRmzbdhd+Ceh1n908sSIwPDAg7nog9ltEw8OA5Xjgvpt2txsQdRRhITfklSU8TL64YQK3sM1hsLGzz3cWBzLtyl0KZvWGu90QZd+QawoYV3/gu10zZ3SHapo4yqlSHFF2iEoJGhHMtmm49J0v42yoKIzCJ43LhmjT6tEhr54e0YdVxSk9Cp+aw7E9/dlWC9S+BLSw6y
 l0HSLgcC
 aazyY6uxtvBAWJF4Eg9HDCfeTb7hWMnADjYn43argb/cMGtKsmTpT4tG9Y74Mx/G/+0LMY8qg1a8su7O/R+wjc2JEiHUvxuQrSKIefYnQEmneRfenU5KaVpNV7eAQjZNOfVsvN/tF8wFDO2WYf8JtovPNVyKnyK8lDny+WBZE93xCS/sGIgrbfKswkq+wCzTpa71xWSOP1wtaMemjugOyyWu1GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/10/2025 17:41, Alexander Gordeev wrote:
> On Wed, Oct 29, 2025 at 10:09:04AM +0000, Kevin Brodsky wrote:
>
> Hi Kevin,
>
>> +#ifdef CONFIG_ARCH_HAS_LAZY_MMU_MODE
>> +static inline bool in_lazy_mmu_mode(void)
>> +{
>> +	return current->lazy_mmu_state.active;
> Whether (nesting_level > 0) is more correct check?
> Otherwise, it returns false while in paused mode.

That's exactly the intention. Lazy MMU is disabled while paused. The
users of that helper want to know if lazy MMU is currently enabled (to
decide whether to batch updates for instance); whether this is because
we are paused or not in any lazy_mmu section (nesting_level == 0) makes
no difference.

> May be check both nesting_level and active and also introduce
> in_lazy_mmu_paused_mode() right away to avoid any confusion?

Can you think of any situation where a caller would specifically want to
know that lazy MMU is paused?

- Kevin

