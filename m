Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A25CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 10:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FE9C8E000E; Tue, 11 Nov 2025 05:27:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5D58E0002; Tue, 11 Nov 2025 05:27:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 513B28E000E; Tue, 11 Nov 2025 05:27:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3DF848E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 05:27:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CC02E4C155
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:27:38 +0000 (UTC)
X-FDA: 84097949796.25.1142068
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id 04143100006
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 10:27:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sjb5S7mK;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762856857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCozD/S14h9YyVEvZtzrw1OeE8+mwrBwtubAIDfZfYw=;
	b=4APMQ6QFgeVN0HiYQSzQXJ9oKcQrsBGxtrgmlQPAnXsnpkKQ8vD0C1gR0xVSZf5swtIzee
	/8TNhOWkEisHtPCYxO1pzGtfsMoWkLMYEPYcpcNevdq1d+7TLe67hGtbxGz7kSGWHqAkd2
	crqhFEykNL0t0lLavnggrsbgTfYLMww=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sjb5S7mK;
	spf=none (imf05.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762856857; a=rsa-sha256;
	cv=none;
	b=wul6afNE8F7OP/HXvYEgdPEGS321FiQYm4I9rJsOX7xrVM2a6VIN/uiswD/GujtDsq3V2P
	rplxGHMoPRP6Is67Cl+ASsmqzx8sgocLyjaetwA1eUHVsbfYC+W41VhhBoDUgeoi7qDt8E
	yau7KHm5PGwQakHHRoJkWZfmVD1PBis=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iCozD/S14h9YyVEvZtzrw1OeE8+mwrBwtubAIDfZfYw=; b=sjb5S7mK2brT+EtiKy3b3jYsHd
	lNYMJRyT9YAluzwMc8XiVCT6lDbgLRAv3jkpzWQaIvSJiMVlTu0KB7Qeb3Zp7tud9XR4oQJS5GTtM
	wxeAFYkz/k6xVOXGOnLOFp9YHVm0W6z8GlyCJCZZ0wJOYVI7CnH4Pv0pgFsU4MylNjQJoXiWiA6Fm
	P+slWCcWrcvHBNtm3WSymnLMQIyuEJ2LWAiciGDcRLeuqppHzpm5GiYI/g2u4LGqNQC2HfcFNFeCC
	75V0Liz50oP+KjQ1uk1/50UGtZ/pFqw6GrHY0kVXbojzKRFWy6yONwogjg7nInxJrfnb8JC+dZ5/6
	MghJ6MCA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIlaq-00000003ivE-1kUw;
	Tue, 11 Nov 2025 10:27:20 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 455A4300328; Tue, 11 Nov 2025 11:27:19 +0100 (CET)
Date: Tue, 11 Nov 2025 11:27:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, kaleshsingh@google.com, kbingham@kernel.org,
	akpm@linux-foundation.org, nathan@kernel.org,
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de,
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com,
	kees@kernel.org, baohua@kernel.org, vbabka@suse.cz,
	justinstitt@google.com, wangkefeng.wang@huawei.com,
	leitao@debian.org, jan.kiszka@siemens.com,
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com,
	ubizjak@gmail.com, ada.coupriediaz@arm.com,
	nick.desaulniers+lkml@gmail.com, ojeda@kernel.org,
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com,
	glider@google.com, mark.rutland@arm.com, trintaeoitogc@gmail.com,
	jpoimboe@kernel.org, thuth@redhat.com, pasha.tatashin@soleen.com,
	dvyukov@google.com, jhubbard@nvidia.com, catalin.marinas@arm.com,
	yeoreum.yun@arm.com, mhocko@suse.com, lorenzo.stoakes@oracle.com,
	samuel.holland@sifive.com, vincenzo.frascino@arm.com,
	bigeasy@linutronix.de, surenb@google.com, ardb@kernel.org,
	Liam.Howlett@oracle.com, nicolas.schier@linux.dev, ziy@nvidia.com,
	kas@kernel.org, tglx@linutronix.de, mingo@redhat.com,
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com,
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org,
	rppt@kernel.org, will@kernel.org, luto@kernel.org,
	kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 15/18] x86/kasan: Handle UD1 for inline KASAN reports
Message-ID: <20251111102719.GH278048@noisy.programming.kicks-ass.net>
References: <cover.1761763681.git.m.wieczorretman@pm.me>
 <8b0daaf83752528418bf2dd8d08906c37fa31f69.1761763681.git.m.wieczorretman@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b0daaf83752528418bf2dd8d08906c37fa31f69.1761763681.git.m.wieczorretman@pm.me>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 04143100006
X-Stat-Signature: peydio9qmcj3cn17k1bu7fobxbu5st3g
X-Rspam-User: 
X-HE-Tag: 1762856855-126219
X-HE-Meta: U2FsdGVkX1/AmSAT50fK+boGRs1IFY3kAd/boaHIJ/fHKm+/dvkqp4vkFRFEO+vJqiLTTQIC8dOc4PvepkvWKPCA0sLLDf40cGNJ19K2wYDL1+YQ2FtC5wUiVhLn0G5Whf5oMXORjH7T6GTnAtKP3/jiIks1DHTnw6PbZB6Iux30909uLIfNHN66/SlJqpJCoIPE2FNzam1rEWstTELqvoQ5UmlCGjm/CBEWTBb6iOPTCOrUYp0uWlC7k9dwrxWnEr8Md31nOhfaBhNopt9Pfpl4Je6pRRV1ugju54cKqffw3esjrIRclRVDQzpE3vjorIDrccKvh4jMFDDnfQiKwW8R4GJ0SzFjm8Nood1HqjmceYTI1gVTjyA0pDXXjZtpev8AFYtN9v/OKCk0IpgXzYV5P09NqM5bAx8gHb5xA4mlk6rDREsm+edmB7Xv8gG1j0iNA4fTlEK/0F2ID5o900BcXexVT+tervVLo33cLqlggonD4Ytf7gUzNy3TDmIRZm/CnkFSGVnEsRSrTcoC6kSuhJ16s2IsG+5vBNTs+VUjdvLBeV1Za9M4xoY1hjxzyDQkJPjKgIGLbTkf9P1h8sQznRB3wCyEAcUyPaqW5hdvmi2zlZypdfKYkx2hTroNANnVxpbFgSz7eX5iMv8k9cvAOQqVoSg9KN2tGxFQode6TFM847M2h10g9UJGSPb6j7P3wL2Pbzj7zieOzyS6mxINfsj/rH2hBAK9rdmeUQkRyupinzNCoPkHXzvFzsc0j5nB6x+OQAPCS5UIAzb/bYlvuxViAio6upo9/LksMa/OAR5MKIHCnJ73BxxDnt31g0DecTEqgAOXbxMp919wQweHajhnARuBbn/6FrD49e+Gk9+TTRh8prUsJ/EPoG/e64IP66B3NUsSoKEBK6ox3VR94l0lEsd/EyOYI2/9M3Mzat9XLqTbFFXnyJD84gSf5Q9ulnKYxqM9uxmFPTt
 VRXUK9/Y
 moQUL7s9aYw998SuRW99cSVK6NTPcOPvRSMR9zly/kJOdrpRLsYU5nk+5yW4Xpi7wICjNlQ1Oz1aBFr61vMel0OvnNUAOt+iK7a4Wm7Z/VXuNrVRo64Lvj/D93lWaEFVfuiolVggGoU2QisdTJmhdhE57FhyjqWIUhOqCyOFXptqtTiJ4YEOIGb15ZCLRWJVwOFATo4hGIpmrCbqUFf/AurTcEP7gRZX98sK4ncKvi+/rR4UFEf6UG/6cX3w95aCppT0X6G72hV9zFywri81+pC3SgpOsXpMmWY/iQbPS29jyXUUiBin0KkcAsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 08:09:51PM +0000, Maciej Wieczor-Retman wrote:
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
> 
> Inline KASAN on x86 should do tag mismatch reports by passing the
> metadata through the UD1 instruction and the faulty address through RDI,
> a scheme that's already used by UBSan and is easy to extend.
> 
> The current LLVM way of passing KASAN software tag mode metadata is done
> using the INT3 instruction. However that should be changed because it
> doesn't align to how the kernel already handles UD1 for similar use
> cases. Since inline software tag-based KASAN doesn't work on x86 due to
> missing compiler support it can be fixed and the INT3 can be changed to
> UD1 at the same time.
> 
> Add a kasan component to the #UD decoding and handling functions.
> 
> Make part of that hook - which decides whether to die or recover from a
> tag mismatch - arch independent to avoid duplicating a long comment on
> both x86 and arm64 architectures.
> 

> diff --git a/arch/x86/include/asm/kasan.h b/arch/x86/include/asm/kasan.h
> index 396071832d02..375651d9b114 100644
> --- a/arch/x86/include/asm/kasan.h
> +++ b/arch/x86/include/asm/kasan.h
> @@ -6,6 +6,24 @@
>  #include <linux/kasan-tags.h>
>  #include <linux/types.h>
>  #define KASAN_SHADOW_OFFSET _AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
> +
> +/*
> + * LLVM ABI for reporting tag mismatches in inline KASAN mode.
> + * On x86 the UD1 instruction is used to carry metadata in the ECX register
> + * to the KASAN report. ECX is used to differentiate KASAN from UBSan when
> + * decoding the UD1 instruction.
> + *
> + * SIZE refers to how many bytes the faulty memory access
> + * requested.
> + * WRITE bit, when set, indicates the access was a write, otherwise
> + * it was a read.
> + * RECOVER bit, when set, should allow the kernel to carry on after
> + * a tag mismatch. Otherwise die() is called.
> + */
> +#define KASAN_ECX_RECOVER	0x20
> +#define KASAN_ECX_WRITE		0x10
> +#define KASAN_ECX_SIZE_MASK	0x0f
> +#define KASAN_ECX_SIZE(ecx)	(1 << ((ecx) & KASAN_ECX_SIZE_MASK))
>  #define KASAN_SHADOW_SCALE_SHIFT 3

> diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
> index 6b22611e69cc..40fefd306c76 100644
> --- a/arch/x86/kernel/traps.c
> +++ b/arch/x86/kernel/traps.c
> @@ -179,6 +179,9 @@ __always_inline int decode_bug(unsigned long addr, s32 *imm, int *len)
>  	if (X86_MODRM_REG(v) == 0)	/* EAX */
>  		return BUG_UD1_UBSAN;
>  
> +	if (X86_MODRM_REG(v) == 1)	/* ECX */
> +		return BUG_UD1_KASAN;
> +
>  	return BUG_UD1;
>  }
>  
> @@ -357,6 +360,11 @@ static noinstr bool handle_bug(struct pt_regs *regs)
>  		}
>  		break;
>  
> +	case BUG_UD1_KASAN:
> +		kasan_inline_handler(regs);
> +		handled = true;
> +		break;
> +
>  	default:
>  		break;
>  	}

> +void kasan_inline_handler(struct pt_regs *regs)
> +{
> +	int metadata = regs->cx;
> +	u64 addr = regs->di;
> +	u64 pc = regs->ip;
> +	bool recover = metadata & KASAN_ECX_RECOVER;
> +	bool write = metadata & KASAN_ECX_WRITE;
> +	size_t size = KASAN_ECX_SIZE(metadata);
> +
> +	if (user_mode(regs))
> +		return;
> +
> +	if (!kasan_report((void *)addr, size, write, pc))
> +		return;
> +
> +	kasan_die_unless_recover(recover, "Oops - KASAN", regs, metadata, die);
> +}

I'm confused. Going by the ARM64 code, the meta-data is constant per
site -- it is encoded in the break immediate.

And I suggested you do the same on x86 by using the single byte
displacement instruction encoding.

	ud1	0xFF(%ecx), %ecx

Also, we don't have to use a fixed register for the address, you can do:

	ud1	0xFF(%ecx), %reg

and have %reg tell us what register the address is in.

Then you can recover the meta-data from the displacement immediate and
the address from whatever register is denoted.

This avoids the 'callsite' from having to clobber cx and move the address
into di.

What you have here will work, and I don't suppose we care about code
density with KASAN much, but it could've been so much better :/



