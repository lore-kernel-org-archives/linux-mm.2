Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B42CEACD2
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38CE38E001A; Fri, 14 Nov 2025 16:09:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E118E0005; Fri, 14 Nov 2025 16:09:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22BA08E001A; Fri, 14 Nov 2025 16:09:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF1D8E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:09:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 95225895B6
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:09:49 +0000 (UTC)
X-FDA: 84110454498.05.C40A2B9
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id E3ABF4000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:09:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=nIOokMcL;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763154588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2ue0i9Kn3tpKl7Mfn0W4IHLdPAlAjgfywYY9MFn3/w=;
	b=PI1XN+nr5k9ZDomfheYskRzcfZz9FEHLb9fm63EZqZ7VU+xYmSbIM3v9PY/Ww6osi6AnGT
	zf+T6pOlwaR0D9iep0X9MjTZKwvuqXWzpzAcil9tnfNcuAiBl9O2ufmRPnQDG0H+Bh6kfz
	k+cTGahPMuZLAtmW69kSNurmC6UTUF8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=zytor.com header.s=2025102301 header.b=nIOokMcL;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763154588; a=rsa-sha256;
	cv=none;
	b=SidYJJTVfiXFuJPhtx/hS3D2Ujvf6S7FEgIBabJlrL7cL+A0Cp+Spwx+I+ZEw6MriPdggL
	B6B0d1FddmXBb55+mJ3Y7dwDkXL0JyER5KDjRMX0u2c/0F0klNsUr4lqZ747tJ6N0uVT6Y
	/B+6jwxSyp7Y+6/cbBgdhrqI7V5rPU8=
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AEL8xhk2436810
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 14 Nov 2025 13:08:59 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AEL8xhk2436810
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763154542;
	bh=n2ue0i9Kn3tpKl7Mfn0W4IHLdPAlAjgfywYY9MFn3/w=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=nIOokMcL0nZVqs1kMOROePbzmN64KK9utodHI0BbQCAJYs0XDAh9jBT2gqtFuD3zM
	 Ai8zZ2wKaYwKWOLYjL16VqdC8RSTLXVZl1GvZ1Sc1xxHarPwcr9p3uQqa7MErjF41Z
	 1QNxXRXMtC0j1COezcBvSwdVlckIYcz9r3JMl7q3j7knmORqgvY9X0quSsTEu5ZV7X
	 kpVcuWxqnPVHbDK/iMNAsaSCdtmeYz0cqk0/FA+ytQzOvjMXUeeq4NP6ZLDu4PtW7K
	 ng4DxBUJF24K/23Ny8bXMFYjE/XaVNqwJh3qgms0qVJjz8Gehbuj02WFT1AiWs9AjA
	 u7oYTaR6IA3HA==
Message-ID: <c0f19f86-043b-470a-9196-06323974ac54@zytor.com>
Date: Fri, 14 Nov 2025 13:08:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
From: "H. Peter Anvin" <hpa@zytor.com>
To: Uros Bizjak <ubizjak@gmail.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112043730.992152-1-hpa@zytor.com>
 <20251112043730.992152-8-hpa@zytor.com>
 <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
 <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
 <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
 <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
Content-Language: en-US, sv-SE
In-Reply-To: <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E3ABF4000E
X-Stat-Signature: nu6bzgut67dugh79c5o6wd3ftbamsgcb
X-Rspam-User: 
X-HE-Tag: 1763154586-348074
X-HE-Meta: U2FsdGVkX1+GxNaSaxHw2IkENJBT8Ke+0p3a9ufjnJqX6RbpmJLBG8Vq8fTil8kTgZe84h4NjrawBMB8P5GyC3wJmSv2c4bV7mrj/+cW114ERGCXj1FXdhsDHRZJ4OW+YkHxJYrpDKQr3zdMryj1eh9fVb6CfQfGWr9OQCFOvHwOIK66LAdZl8L5R0Ux88+QIfCF7/UNF7tRY8bGJ841paQLBhjoDpjDP+5STTFraa0ziW+6gZ8xRXPuMg/M3Yiw8ikGH2PYNj543C1mzH5yop8NuPftrWOZDCx5YVEAzcd+hajligE0kIwi2ZpND8xeDzvxEpVPJbBhcX8x7pX3wvA+UcIoj7KQSq/dt3fGo/dBy9JCmycM6RIOhWr8yIaiqsNONLzsmwqdH8ofSCMOlX7rEtr4AwodqNaxiC2Ul7X9Z+GFhzXLxPRLhPJpAD7OUHalQJd8Z0quvnCUDgOILGIidn/T8pphpkH4a0e3cTOmXdDkbYbOo89mZZBqGXqchpRNrVV98shIsDHpjIiACIkntNDcosRtHtjWRq0TvJLCfwtwjx35Ji8XgVwlrnBL9mJvyM9KuAqMrlu/BTNhzaZ2/IwchEF6pUElXPY8S5EVkgN7wPr6uATp/PXS6koWiA+1Orp2CfGkg7v+HVM4IeBRIO+OAWQMQtm518R2ACxGwRJfRglTMDypIzUHQGu+gVuYsLWjTZFDFZ+GqO28+yGZKeAqxgfZYYEVXmNXWZXdJUZ9fjmgpyGZ7XXZkFysb5AfRYXil8mrx9cXTwgTp0V/4up60H68iuLs0RQ6USnlWYprd4Yrerneb/WQklW/Aj51DEuGEXzBSwvFpMFsQl/U3x1E/rya0o7f5K+WpgnsFtZ2Od+eXBn7cfY+d5yp52wdONWucSk0NI/ikv8HiIRR4IvhiblDQaFSuhmUZQ6eJIm6HKzfZapzqIQ++esBB9aUxRnKbtGyNadk6Tg
 Sah388I2
 2hpVCw0wQLfY2suMoPqlD9QpUPF2tqxa8lV/y7c4C3XUJdRkJiouyuHOBjbUcxbtQs67SBnrRb0WyM5QM4rwfnfC7PSq1kkbKSJ+clS2VarstLeMDf07vIm0pFT+1kAkrQ/pCiYfq4eAs1TbY1HraAZlVzD7x6gbY4nMvs+gx0SUlOzJuv0Y+kxkJh4sTuGxm6lngKW5+ckOj/yfozvi3oHJaOn61E6IQngzx5Oz+2Kfv6uMqj0oLBJnUfVjpU4OPHdsgeD3l2n4t0f8zkHc6TnDwQ2zEZw20Yekv0MAji8FcSX2xY6HDgcP6Jg/i7dj2rirMvYCwS0xiJvEkOB4nxYQumw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-13 20:40, H. Peter Anvin wrote:
> 
> For 64 bits, if you need frame pointer support *and* frob %rsp, using:
> 
> xchg %[arg],%%rbp
> <stuff>
> xchg %[arg],%%rbp
> 
> ... is probably easiest, with %[arg] in a register.
> 

Incidentally, ORC is one thing, but if you need DWARF information to be
correct for user space, it is definitely "fun".  With the xchg hack for 64
bits it is just a matter of using .cfi_def_cfa_register to change the frame
pointer around, but in the 32-bit case the best I could come up with was:

	.cfi_remember_state
	push %ebp
	.cfi_escape 0x0f,3,0x74,0,0x06	// CFA address in *%esp
	mov %eax, %ebp
	mov $syscall_no, %eax
	int $0x80
	pop %ebp
	.cfi_restore_state

Note that in both cases you need to *NOT* put in any of these CFI directives
when compiling without frame pointers (in which case you need to let gcc take
care of it if you want any hope of getting the CFI correct.)

	-hpa


