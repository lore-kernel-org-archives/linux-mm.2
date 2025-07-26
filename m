Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76C0CC83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 06:27:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB196B0088; Sat, 26 Jul 2025 02:27:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B2F6B0089; Sat, 26 Jul 2025 02:27:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439AF6B008A; Sat, 26 Jul 2025 02:27:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33D7E6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 02:27:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 779251A0A24
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:27:22 +0000 (UTC)
X-FDA: 83705433924.12.C8FD1DC
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf15.hostedemail.com (Postfix) with ESMTP id CB48EA0002
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:27:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fq2xnjNp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753511240; a=rsa-sha256;
	cv=none;
	b=MFneojrbkeG+O2y7H7qGrteBcHWNtOjRKsdw6b8XqV9bwRw5B6vG78462LSBt80xOu+NwI
	D9M6JtsTm6sfizEibN9qkZiEoNLnC/0sFZMXrsn37XW2vOSXxiEK7wJeFzC4bnOMLDFlRL
	SElMYda/R/OuvY5YE7yKpYwRZBqr5qc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fq2xnjNp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753511240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWe1h6lAgsNkrVeizukL0vDDaalZ++F813ABZF5oc44=;
	b=PdD6p4fbQaqIUlKIHgGh4rO86Hkt7jgyL90nO6YqhDEnbNLU28pE3Aqbjt9vkgm+xmn6wL
	DjGNK/IJLx6aWuciVNg0nXlZORwW7aJb33Et/XFFgTLejubJcOz9nQ9/kevgwQ5nq37WYM
	meew1YUaGYemgevJvTxe1J0J8XNTUwQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 7057E5C2989;
	Sat, 26 Jul 2025 06:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C91E9C4CEEF;
	Sat, 26 Jul 2025 06:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753511238;
	bh=LlIMTFVzXwdSlzjowza5NRuahl7DloIjtQs9FFDcY/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fq2xnjNp2Rnf6iAlZuKY1DeL5Taz3Wd30zVOYss8rTdrQFYNsNc7QchDwyboJt8MO
	 GyBnduAMMlNsE8pFM+5ks4z6k6V1Q2RKNUvUebb8ez9Dk91IZbgcxkBTqATFe8mruT
	 F99Rn3HFLCaODcvN0/FwBjHEpq31Kn5eyDzW/dj5r5P0sUBxDUJYgOFUF2H+2OXMD+
	 b0uHv/EensaRP3baa7pQtYIuc8JXI/UQX+u/sHXMOJv7/rcSM6jN0iAiHQTQj5ULlP
	 XjDMcwoXUT3oMirM6oHEboAxIgl2XJlfJ7zAX534y/jxfcJsjtNnBZ1ScfFvhmh9Hi
	 n1Xg4NOsRzPeQ==
Date: Fri, 25 Jul 2025 23:27:18 -0700
From: Kees Cook <kees@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hansg@kernel.org>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>, Brian Gerst <brgerst@gmail.com>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Andy Lutomirski <luto@kernel.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jan Beulich <jbeulich@suse.com>, Boqun Feng <boqun.feng@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, x86@kernel.org,
	kvm@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, kasan-dev@googlegroups.com,
	linux-kbuild@vger.kernel.org, linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org, linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH v4 0/4] stackleak: Support Clang stack depth tracking
Message-ID: <202507252322.8774CA6FCF@keescook>
References: <20250724054419.it.405-kees@kernel.org>
 <20250726004313.GA3650901@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726004313.GA3650901@ax162>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CB48EA0002
X-Stat-Signature: p6nwb8s7sd88tj6fkfitysthm8z1k4rb
X-HE-Tag: 1753511240-123818
X-HE-Meta: U2FsdGVkX18zVSbvMN7pdcBscbzMCEFtyJ4dKPmBCjiNzPMEj8ARHOqsOgg+04nSLDJ6/lj+IIFWflea0ZCzRm5HVzDkCR3xdSg2suiElbw2zTPfTLlrO+fgkYOUThnsgSf3zGbgnQNPIA6U7JjZJ3N75Yy3AujXg0IRuh1wCXpE5sMx6SEVyUuUoXO9Sc6rLwn6cda+SiDsXaia5nkqPKNX6enCkErWh5336XesBS9sUoVRtfDmRcusTdg4qtSYXP+mC/Ds2LxpKZkrsZ3yRE+y54oMqVDbH+gRKTDrpP4hZGvOCOr+1dnM5hqtuUxXHKiSXTsGgor1WjIDiFyag6ejE2gItTrtC3haskBXxs7NkoP9Ot0WovzSyc3Pa1+Q506wwqMKgDjJ/UjFRsXDnKW1TWDi2bsp0aAuNyGboDSp42f9F64UiX6uSDCxOU2QyQP4d3y/Ni+lxySOooWC3jFc3twQE/nBaGiKtICO/x7YAV2Q++5lDN6kdZMLtqnA/BdaReeFoKjUg61O3AEnz1U5i1JWgevEpOMXFYZzxavMOCaSlYjgyDhEUL/gsNnKj+ugpLT5IgwpVkm4tDMyfk1Y8DCPLRZ25RrJ55sLsMydnlOpBXRBDIZEmfzyzEv3EJnQAWF0F7wmfYOvZDhXn9XWxLRFAWjcjRvhbWtuaBPvvg1+AH6rXZkRuue37tqBRf3PKr2eiCYVSVxiMhwtTLcHLKPVth5RKPsM/8mlwDiqWVNbX9GHt5Ula8F1XplJGkhm3BhPkCZCr59Wapcq7MOqxNkSk0ozWRp3BeAUrcS84miodJb3QsUO4XFHnaBGEEsvc49n9/8clggBrS88ufJgPxHdZKfTrwebT3igetI1Itaa1sEM791EZwCLhOCXfWeRcFzgweqmS3wSJSBmztS0ZjMVusbcV7/z0il89zkXaduiZx0+JwLfiouswiE8juCBUygHz8WCNX3o5xL
 a4xYzyqV
 Lqh3NF/2L6HivrUO9fBrrMK2UzzpLeRIn56/W/zC2/kc2xSM/f5L6Wo6/XSNOUwawpCl8sbJ31U0kWZiXkbKSc1nwgTOZc7YcSKVIVKasGpgUAqAgVkttzPTNtAgThktzok4qSEVrhZtu9lqVxdBUvtWFtr1vftDxM3qJ7WlgDoy7i1exvysD/z2ws1aZK6JzZYk6tU6KMsc51pY23Zj08e97zxEQ1XwP0iOe5aY7x+oM8h4/RcIhO/hDEo6GGcyTh/IzDatPHZ52dkruCaXBimbsVlPBRr93Zi4DkaYtmJbBzMINuUALwEDu8VmsoiU5fBnpqnilLx58XLSt9woNGvjSShyN+OuQY+SaEsSEh19zl/nnyEmf7OBVQiYpRbbqaoC5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 05:43:13PM -0700, Nathan Chancellor wrote:
> A few build issues that I see when building next-20250725, which seem
> related to this series.

AH! Thank you for letting me know!

> 1. I see
> 
>   ld.lld: error: undefined symbol: __sanitizer_cov_stack_depth
>   >>> referenced by atags_to_fdt.c
>   >>>               arch/arm/boot/compressed/atags_to_fdt.o:(atags_to_fdt)
>   make[5]: *** [arch/arm/boot/compressed/Makefile:152: arch/arm/boot/compressed/vmlinux] Error 1
> 
> when building ARCH=arm allmodconfig on next-20250725. The following diff appears to cure that one.

Ah-ha perfect. Yes, that matches what I was expecting to fix it, I was
just about to start working on it, but you beat me to it. :) The same
was reported here:
https://lore.kernel.org/all/CA+G9fYtBk8qnpWvoaFwymCx5s5i-5KXtPGpmf=_+UKJddCOnLA@mail.gmail.com

> 2. I see
> 
>   kernel/kstack_erase.c:168:2: warning: function with attribute 'no_caller_saved_registers' should only call a function with attribute 'no_caller_saved_registers' or be compiled with '-mgeneral-regs-only' [-Wexcessive-regsave]
> [...]
> when building ARCH=i386 allmodconfig.

Oh, hm, I will figure that out.

> 3. I see
> 
>   In file included from kernel/fork.c:96:
>   include/linux/kstack_erase.h:29:37: error: passing 'const struct task_struct *' to parameter of type 'struct task_struct *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
>      29 |         return (unsigned long)end_of_stack(tsk) + sizeof(unsigned long);
>         |                                            ^~~
>   include/linux/sched/task_stack.h:56:63: note: passing argument to parameter 'p' here
>      56 | static inline unsigned long *end_of_stack(struct task_struct *p)
>         |                                                               ^
> 
> when building ARCH=loongarch allmodconfig, which does not support
> CONFIG_THREAD_INFO_IN_TASK it seems.

Oh, eek. Yeah, I'll need to make an explicit dependency I guess? ("How
did this ever work?")

Thanks again!

-- 
Kees Cook

