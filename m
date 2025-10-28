Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39B12CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 15:59:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989BB8016F; Tue, 28 Oct 2025 11:59:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 939A18013F; Tue, 28 Oct 2025 11:59:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8024E8016F; Tue, 28 Oct 2025 11:59:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6F98013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:59:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EDB31A04A2
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:59:22 +0000 (UTC)
X-FDA: 84047982564.25.AD3DA7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 82A5940013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:59:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0Rjdky4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761667160; a=rsa-sha256;
	cv=none;
	b=x6Q191kM6jWQsqn3OEHa2Cx9WYbQ97qh+OfdktOjchCX5Tml5C0CyH6a0XO55MclXrgmMB
	qKSVz/iuLDyHXGzpGmlcE3590+PZhP6xaWhS1T4gwV9FSLRV7F15VX5KOs8VpB1f3A9KWe
	ao/vOovarSbL35U519dtshY3iuJDQQo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h0Rjdky4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761667160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQvOkt2E+3y+uo1WdteSodshUamGy1TODkc+zOeJre8=;
	b=RbaIGe9WxTLt8vm50pieXpzzIXdSZzAKEUtv3qMgOGjOK5FJqChPXB8QrKzPvketshocgA
	yVb3ecAN3M0Fjtw+SPA5BMoOW9rVrDbkprKpuK86nAHwvpTcVlkEsXOMnxmil4JXln3S6n
	VDbU2mIcH3bjeIWTN2zgyqLRcKUjaWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D8A8614A7;
	Tue, 28 Oct 2025 15:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55CEC4CEE7;
	Tue, 28 Oct 2025 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761667159;
	bh=SDRIuqWM2TI7GYT8HdCkn7TBcJvTMa+nGGBd4kxLWaU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h0Rjdky40XtCVRjoUUWv5rLiJ9ZMpCagJKFXeyfzHOGEHTGw9bKgoBDki9igeNVWF
	 hxxzLvARw99/t5f4Lqs+Dj5fZyVuN3fZZCRfCFM55ZeACJS/rijOr6rAqCQE7Hwid1
	 QyXcKn0xMZDkHD1ajCbuYBSCn+ENYdvO5PJWUuqfmfteG28nQwGE4UO2KHjBeLwl2c
	 hE32PRBdNnuYpqH0YyIEEpoBXAGIkGRuRSDfPq/9QdewsKj3LtsQ6g4eJFxD5TaKJO
	 HpEpDWwMqwcXSfnux9kuKahgFba9EgaGpASx7PAIM38ag+Pw/+fgAan6RlnvKpPKM4
	 jLUxM6PBiYL0w==
Date: Tue, 28 Oct 2025 16:59:16 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Valentin Schneider <vschneid@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rcu@vger.kernel.org,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
	linux-arch@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Jason Baron <jbaron@akamai.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Han Shen <shenhan@google.com>, Rik van Riel <riel@surriel.com>,
	Jann Horn <jannh@google.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Clark Williams <williams@redhat.com>,
	Yair Podemsky <ypodemsk@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Daniel Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v6 27/29] x86/mm/pti: Implement a TLB flush
 immediately after a switch to kernel CR3
Message-ID: <aQDoVAs5UZwQo-ds@localhost.localdomain>
References: <20251010153839.151763-1-vschneid@redhat.com>
 <20251010153839.151763-28-vschneid@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251010153839.151763-28-vschneid@redhat.com>
X-Stat-Signature: eomw6fh5jjaa4yy8zkkf55zzqu7se9ih
X-Rspamd-Queue-Id: 82A5940013
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761667160-292057
X-HE-Meta: U2FsdGVkX18HUfEOOCNgAeTPvBQRljPfx0M3TXSkRIZDwLHsX25M3naNpnQ5GfNMxp4XKyvHUKcyYuRUmIfBHrkTlVmc4vecO7shSVBtxQZQXvlnjZDvuCRnjvT0hlX3wuxDATNzoW2APEqDACTRPmu8mzZWceHqILmhVQaOlRFn7xfbL++BXGDYryAu2KNIdsRJSWkN+eQ+uPcoSxYssDCZwNumDQkv3bdeRyuEKpjCnifDGa4ehbY/LRL8uzICuR728JSa6G+2S65t0yCz9vbe8pc2JyX6WqriqFL9224PPrPnkmc17IJT8yc9uK8ZJDh0I/o8i0S8br5nrT5PIlmZ4MHeo+7jZc3aufjCw3lTmAVnCw2h+/IRBlseEmbvFcDtnNcOHFeaf+zxx0MzczwYsalJiMK63u9HFHi0MQXa3L2MaiMZypsTwWxbPy8/uul5ukE9kyyE0Co2dIkBGp/IfE8lmzR7R0AY0UZp2lW1gqQJX4DDm8xNEOWQfC90roh0v2+EiAecfvytiveyTcgfs1ORdSUUMAN9Y2ZEwZG0s7gM+H4ek9UtI550dBJKU7A5aXv2Ybww3chLSS17dp0f+qZfo7+gqp0mQvajemBL3uA77U882dCHYiRAr8z2bZ+l+61BhIBww9VMPv23+y+xYoN/UoqeRVCftTDbexECVJBQGcmr5SYYQgn3KYWXCHB9sDq4EMZRqklPLn2M7VzuKIQj4qMMgmERfCofN41OJfPz9MXMKyvtrBYH1tuKFAiqjh04BzBjWHAAM5ATaqbm8hSH4uAQahBeuHsXeJy/tOjQkvEjlCMCzt2afkL/Uo9aU6N+Zrm/cehtpT8ogMqtq6I7DqQMXgkpKF8QrtpKfdq20Fy+80qVxy4N/7jceMkApLSTebzjra7LGiwdjtC3whjo406XExvnziiFnZ1dH9sHXvcUne70BDPqvwDTby9lQGeb4ScaU6BIzoh
 QB9QUq8p
 Cs9S0g0JUoar+QyNLUzPgftGMlXOTaUrxwefvHDyptuQPvozECvduNIPoG1IH3LDTGhOKKuoO3uKuxTDBHB8hyVxVobHQwEf9v+RLLoRAEe122pPgxQ5YTDnCoQmtZxQ+QKVDZ/71rmqcHJjRikfkNxeQ5amqSYDQitgJfxfLG7R/d2rcE1tzkgFdc3NAULnJ1aKLXwzmLQdOVcUY1YdLsZC0gkZzG0GTJPNLVY+6wpcfqXASbVhBxDF/YEhs5QnxDbjCT20WJrv2ZvQh5bMHB/xsXxkHX68JUDyNT2cenj1Ntg9oQy5YXwoZk+7LIsymWUQjmjxGUg1l8JvqwdpLntiQGg25iW5C3LYNbX2C4A/9FCtQafC7VmvDpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Oct 10, 2025 at 05:38:37PM +0200, Valentin Schneider a écrit :
> Deferring kernel range TLB flushes requires the guarantee that upon
> entering the kernel, no stale entry may be accessed. The simplest way to
> provide such a guarantee is to issue an unconditional flush upon switching
> to the kernel CR3, as this is the pivoting point where such stale entries
> may be accessed.
> 
> As this is only relevant to NOHZ_FULL, restrict the mechanism to NOHZ_FULL
> CPUs.
> 
> Note that the COALESCE_TLBI config option is introduced in a later commit,
> when the whole feature is implemented.
> 
> Signed-off-by: Valentin Schneider <vschneid@redhat.com>
> ---
>  arch/x86/entry/calling.h      | 26 +++++++++++++++++++++++---
>  arch/x86/kernel/asm-offsets.c |  1 +
>  2 files changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/entry/calling.h b/arch/x86/entry/calling.h
> index 813451b1ddecc..19fb6de276eac 100644
> --- a/arch/x86/entry/calling.h
> +++ b/arch/x86/entry/calling.h
> @@ -9,6 +9,7 @@
>  #include <asm/ptrace-abi.h>
>  #include <asm/msr.h>
>  #include <asm/nospec-branch.h>
> +#include <asm/invpcid.h>
> 
>  /*
> 
> @@ -171,8 +172,27 @@ For 32-bit we have the following conventions - kernel is built with
> 	andq    $(~PTI_USER_PGTABLE_AND_PCID_MASK), \reg
>  .endm
> 
> -.macro COALESCE_TLBI
> +.macro COALESCE_TLBI scratch_reg:req
>  #ifdef CONFIG_COALESCE_TLBI
> +	/* No point in doing this for housekeeping CPUs */
> +	movslq  PER_CPU_VAR(cpu_number), \scratch_reg
> +	bt	\scratch_reg, tick_nohz_full_mask(%rip)
> +	jnc	.Lend_tlbi_\@

I assume it's not possible to have a static call/branch to
take care of all this ?

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

