Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3106BC83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 21:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664C56B0088; Sat, 26 Jul 2025 17:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C366B0089; Sat, 26 Jul 2025 17:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 551F46B008A; Sat, 26 Jul 2025 17:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43F6A6B0088
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 17:48:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98864C0B3B
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 21:48:03 +0000 (UTC)
X-FDA: 83707754046.03.D69B472
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id D657C140004
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 21:48:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fLV+aIK/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753566482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpEW/IT9jhTobSNbCvdFZFzFslfquWaEscBQfdtNojw=;
	b=lZzmLTT4v6swdE/irN2eK1tlaq+xUi5ogRArYuP6Zvnh4BuxJV1sXIQxj3/V1YpPdV0v6A
	1zbyBjmsYpnvK/28HxQNzSSYqvNS6e3tM7JhQmhRoGMrH2oSFOgODEdxivTs2U0cpT9dpe
	uZth9IY8WD/YZee0eNHSkjhhwzcgjWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753566482; a=rsa-sha256;
	cv=none;
	b=8lRE+nDM7HNEPoqINVmofwBCwk5YzAJrbOp8XTAMi4GTbdXNaa3s12nZPvayp/YVtxBkvw
	V16SoGL1WicDBV2jnwT3lxzMikkuuI8Qa9CVC3iMzNaPKYuBQMAT03SrSt/7YZkePBo4h5
	ys25/84KJH8HF/Ldlmoj8hTeWlX8L7Y=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fLV+aIK/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE3AD45B23;
	Sat, 26 Jul 2025 21:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D861C4CEED;
	Sat, 26 Jul 2025 21:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753566479;
	bh=/eYVX8SoAB6x3E1/nt7tNV75VsKCSwlna2pvOjAdRkY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fLV+aIK/Vze5Yi37yRjGGquqtluZaj6oEyf8QVw+wrbGGLvpPqO/3VWgN6Q1uJ3EQ
	 QH0nRrCHz1m2MVaid0DwO/ZAreS3vZit+HvBLazabv8sPBvyPMeFsxbcwMrKLtctLL
	 j3NuYhUDBuP296I9Gm2LbU3o4w0jf03jgW1XCsrOoQO/rnS2XvncxSS5g/BxbXsPUY
	 cZFoUBccYezObyf23E1vFbZZhbN05/QUjpb9Nu6YNxWPCEvwX+Xct1jvhL6BlIkWyO
	 EQM6085jWFo3sxIkJ4QMkSe5eI9/li5cIvDNYY225Ouro0eBfYuV1C42m7ggGqabpt
	 /L2PyqAmEpzaQ==
Date: Sat, 26 Jul 2025 14:47:59 -0700
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
Message-ID: <202507261446.8BDE8B8@keescook>
References: <20250724054419.it.405-kees@kernel.org>
 <20250726004313.GA3650901@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726004313.GA3650901@ax162>
X-Rspamd-Queue-Id: D657C140004
X-Stat-Signature: iz9td1arx4j5i8phwd8cyj817hmezj1c
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753566481-817382
X-HE-Meta: U2FsdGVkX1/zgvtivgq484WEvzPbrjUeC5bmlr/yOurEO1qoL4Z7UFTSpxyUGxGkYzRL8gwav7xovm07TN2J5GLwrzB3Jo1c+Lb+m3PSw2fPc0r4Ae84hj3mrdMhaX73vaHKS4++AosGKKh2aj2SpjvB24s8As7MfFi7sl4avRPMgoA6qYr3pVlFdBRTMpv3bVsCXqYxRsZlHVHrB/Wdr62XgzYQ+MIrWlByI7LBWrnD1Qu3iRnjY41dz7ADw+1MSmxRO5Wl1B9BwuHf0XBnyUEf8ItzEh7fKKYAaawISNcuhARN+wpanYL22HgtTTLA9xcHcPn74KhpqiYK6torSfnIqOOGxnd1yKZfB68VIh6sQ9+JxeZbkZ1MDdij3g/8z+5bClSCkPPvJVjODGzA2DD/xDSGLds6P1U/F4rJSNjCWPIJwlMCRPefI7wJ12cWKF4phaysCnR+wMoA9X+SwHe/OR3oFsJi9SWBFP5HVw0H446lBZFJaBs4KiXiCaufJ1YQzIzlc/V1BCOIFvUiZOpixDATXP9Uv5LUAWVTkqkXGLUX1rkGqlf0YDkRJnawtiFzPA8s5+kX621AzV/e2PIVcaoGSQsaeA70WhVxmOMZ20H4C/XLwT5SCUII5Q0VjpWP7PGujH3CMbiux1QGxNVhdr/2QjscKVZFo/u6yzbbD2b721WF909ppN5JKkbQfZVOMVg5Mw/FB+S/0PchhB3D9ZC1YGbMe4kYM1sN4qxAevnBw92za1/I8x9lXjw/sBtORcxfmFtmnYDKNREKgapm5SQyMWIeOdozxSu97MIwHnzXUtfQ4DMdsZFPqCicQbqp8sCe5PeiPuokFKEQhvEM9v187Yn5r5M+GMQ85TlJdlP4aCW/Awc2Xt1J6fuzdCaG/0JNybMoqdMRuuF8NbHhJoTD8t7fBu1ipQ3X2FvNkz2SGEGmoiIQOJHw96cqvXdWuJrKmIOQvFM7fO6
 EteBG0sk
 aPqQ9GQvSBC3HKFaAnwQzwhK7KLa0YOhxY5NjsD1j5fjlUfov+saoCb/vJ4W2ABPAKavOqWxrXJ2f71/wiC0oTU9oSVot1yVv8f1XyTqCHdwWqZsvBsk4KDVOO+3aWTVtEssPj0YU+DS3BX0SglzJnPUxJBZiqk6D6BuVWYvQB0zx3MKiyY5r7A0zUTBa6VFKWq70pSON4BZ3XmlWskYolSbLb5msQPEJ0WW92cTpZddZswsdxz7PkMVnvi3X/7QxvPeWn3fJwYwq20yctqZMm9ioo4MPC0itutJRcGOlA8C9kQ4Cw6/J+LTINiKdUEC8RXB9YfFKEQp/FtZBzdxr0tj7BPWXR8qPbe+0Jz6oeQAisH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 05:43:13PM -0700, Nathan Chancellor wrote:
>   ld.lld: error: undefined symbol: __sanitizer_cov_stack_depth
>   >>> referenced by atags_to_fdt.c

Proposed fix:
https://lore.kernel.org/lkml/20250726212945.work.975-kees@kernel.org/

>   kernel/kstack_erase.c:168:2: warning: function with attribute 'no_caller_saved_registers' should only call a function with attribute 'no_caller_saved_registers' or be compiled with '-mgeneral-regs-only' [-Wexcessive-regsave]

Proposed fix:
https://lore.kernel.org/lkml/20250726212615.work.800-kees@kernel.org/

>   In file included from kernel/fork.c:96:
>   include/linux/kstack_erase.h:29:37: error: passing 'const struct task_struct *' to parameter of type 'struct task_struct *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
>      29 |         return (unsigned long)end_of_stack(tsk) + sizeof(unsigned long);
>         |                                            ^~~
>   include/linux/sched/task_stack.h:56:63: note: passing argument to parameter 'p' here
>      56 | static inline unsigned long *end_of_stack(struct task_struct *p)
>         |                                                               ^

Proposed fix:
https://lore.kernel.org/lkml/20250726210641.work.114-kees@kernel.org/

Thanks for the reports! :)

-Kees

-- 
Kees Cook

