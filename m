Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D143FC87FCE
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 00:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FB086B007B; Fri, 25 Jul 2025 20:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AC686B0089; Fri, 25 Jul 2025 20:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B096B008A; Fri, 25 Jul 2025 20:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 383C56B007B
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 20:43:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04222113BF8
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 00:43:33 +0000 (UTC)
X-FDA: 83704567548.26.A55D91F
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6FDD2A0003
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 00:43:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBaBfcy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of nathan@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753490612; a=rsa-sha256;
	cv=none;
	b=Wg2WdRXIf7naZZ2go8dvFruZ7Z8zgDyV5rEAw3apd18PX84goFAr0dMQOtqlX8Ei6We0qs
	shCMfFisH+GDhlteUWkpsf4KElMUY+nFRiwq4YmQXaWeACVp/3u+pNYUgP14Gtvs1v8FAq
	7DwPtLBQo0m7A5v40E7BzX6pgF7jgzI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBaBfcy8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of nathan@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=nathan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753490612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sAzsEOvW+OhZvMm5Zu/ODZB3aFKVogO7ESRBoesTkU=;
	b=Osqjj1omt4i1M0f0G5rlNTFM/n41B7TmXCyE2YytrgihanQibjLXZYMwTeXCogYeFgcchb
	iuSgfCRQ42rIJYTAYDYdNn5CB+7wjnss/C1DAJUicjBlfpFYV94jCxX+MuoKXpHurne5nS
	g1WOzsoSTVNPKe0n+xr59kOErSyzduo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 31FE3A567D6;
	Sat, 26 Jul 2025 00:43:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1170C4CEE7;
	Sat, 26 Jul 2025 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753490610;
	bh=FRa9xY4x5DiJRX0obptGEWaAk44wN8I8KzUTZYrUCjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kBaBfcy8cvOEOsPzmxHVilPiLtCGr+TDf8X/qOm2ye9g94waAiMThV6LQwkD5mGES
	 PDjLL+F1jsLeU64wJNGH2USu78DXOVIauVdSn5Za3ug6EyGqMkDWY68qx6CO1Gpj84
	 N2fKc/oxH+okv+yKP2JrlydnIbTVzpb6w9fxjXPvPbNQT1zbh2x+enrj7WanGNqURj
	 oluIdS5LRKkHy5qC/5rWJa6TJsIQMsqWbSs6k1imrXOBgatcUYq26mfwhTEKJwXKN7
	 wK8GX+boueI26+UPx4/MDOH6NBVBpUuOSwVrQlpds5FDuUw13v4g1+lMsu+qwH3eh6
	 5w2Rudv02W7cA==
Date: Fri, 25 Jul 2025 17:43:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Kees Cook <kees@kernel.org>
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
Message-ID: <20250726004313.GA3650901@ax162>
References: <20250724054419.it.405-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250724054419.it.405-kees@kernel.org>
X-Stat-Signature: krzosuug5gd1yrxc7wj9t13ax8yr41q5
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FDD2A0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753490612-834706
X-HE-Meta: U2FsdGVkX19+hGlpaeySs45v7vQ+M6rfYXjq7M9RxqUrnRWI22xxBEHuxcsg0Kf8VhFULgqevleYjqw01Ye4ivNFMDXNcDBsNU2W57psQE+GMv9W9CXoE9qtIzgwcFllUq2gzeTAElK3UwXDkYGo0VPkWeK34h11wJrMlH7PQcCZQKRVvPTsqzhJ8n4o6HV04cCrtOIwoTgflwM5HIp/AqWTDUMA5zS3J63sRp2hep19Luri8GZi23BnTdj4W3H93c3nn9tfJZ43L5h90CLqhrqkIowH4XoF+eAJqSr69cSw4B92bvEjrVpvzxDF3ohMMe4BLKIYeBmTTBm+dr1iIfybJ3yL1jhkDSDV23gwV322fCLwG0gzKJjLXjAXUvbuCWzF7s6i1tDo2YY6RfeExjh9yfrgrHS7FSWvmAlGge/+xqx7x3XQVduIzr+BmJBenYh+8r+XiygRlD3AYoPnoY3r3Egtv73SIrFjx9vLQLGgHC7RB7JMnd8PbCo0NpJP31o3hicEziZc0aDXX/Lu4hDDtDbw7zsJxipHZELaFLrRTZ5EFhBz77dZ+bGcUOpD5htxwU4SWMKMeDTet4YL+JVzPVVLG1pXtRbz9wOGTFDA3ziwLJMVJpBzQT7eB6nXhaDRkUulm6Bmkws6EJ0Y8A8sVcBzneV1lIgWJx9RuOE5KVNO3STw5qoS0+7wkldgx/AWXgeyM+tP6APgXDP6DDBskRsi8Nq4zylg1I8ctmbNWknmxq5UAeVCILXm0E7vbRVubhubRyZNiHK0oEuuU2TsiAGhvNffBiA+Iy7NUEQFgfe4vv5F1VARnQ8+2C30LGEYLjgKZNk+/Vp3MNGdI0vDo2q9fbf8AgPqEu/viW7OI+aIW03mX7ks4WTmef3Yc1XtdWSNvQpLcpAiezxfsV0Cv0BYT/aAmnnswJoiMlb+avAi+JD/RpvAijkkidYHx6Y5CsW3KVU3RgxRRJk
 YDwcRAgW
 dvNON4J12fz+jUpI5SJtT/m4SmUf9u5qVCBsmgoO+YCo4jw9eQuZ4Tl9B+hElJ7H/lW7tC1NMyHBK/F+lr77WiwR4gMys1qcksp6hHi8otl3KRiXthpAGL2F9FcbcCcTHmKLi6FaapWBSeePfPYqbWRD6vGsc3CFaMC6kPg/4bzbWCVhsUGud/KO+FwqO0ToHJwpHkfuuKmIy3fD6x7MRTYe3EGjkWlWsmxQs8gNysxWwfA+INbWpJtkgn3L4K/awHBxqhBRqslMgro8I/OhVSlwl5PfNnnaUMpWY/obrKH0V+A5lIl/J6PgeB1d3J/AKudA1ERtJ5WaeoAf0N5sRqVrWzpzYI5NqDOMxHG26i4QzrrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kees,

On Wed, Jul 23, 2025 at 10:50:24PM -0700, Kees Cook wrote:
>  v4:
>   - rebase on for-next/hardening tree (took subset of v3 patches)
>   - improve commit logs for x86 and arm64 changes (Mike, Will, Ard)
>  v3: https://lore.kernel.org/lkml/20250717231756.make.423-kees@kernel.org/
>  v2: https://lore.kernel.org/lkml/20250523043251.it.550-kees@kernel.org/
>  v1: https://lore.kernel.org/lkml/20250507180852.work.231-kees@kernel.org/
> 
> Hi,
> 
> These are the remaining changes needed to support Clang stack depth
> tracking for kstack_erase (nee stackleak).

A few build issues that I see when building next-20250725, which seem
related to this series.

1. I see

  ld.lld: error: undefined symbol: __sanitizer_cov_stack_depth
  >>> referenced by atags_to_fdt.c
  >>>               arch/arm/boot/compressed/atags_to_fdt.o:(atags_to_fdt)
  make[5]: *** [arch/arm/boot/compressed/Makefile:152: arch/arm/boot/compressed/vmlinux] Error 1

when building ARCH=arm allmodconfig on next-20250725. The following diff appears to cure that one.

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index f9075edfd773..f6142946b162 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -9,7 +9,6 @@ OBJS		=
 
 HEAD	= head.o
 OBJS	+= misc.o decompress.o
-CFLAGS_decompress.o += $(DISABLE_KSTACK_ERASE)
 ifeq ($(CONFIG_DEBUG_UNCOMPRESS),y)
 OBJS	+= debug.o
 AFLAGS_head.o += -DDEBUG
@@ -96,7 +95,7 @@ KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 
 ccflags-y := -fpic $(call cc-option,-mno-single-pic-base,) -fno-builtin \
 	     -I$(srctree)/scripts/dtc/libfdt -fno-stack-protector \
-	     -I$(obj)
+	     -I$(obj) $(DISABLE_KSTACK_ERASE)
 ccflags-remove-$(CONFIG_FUNCTION_TRACER) += -pg
 asflags-y := -DZIMAGE
 
--

2. I see

  kernel/kstack_erase.c:168:2: warning: function with attribute 'no_caller_saved_registers' should only call a function with attribute 'no_caller_saved_registers' or be compiled with '-mgeneral-regs-only' [-Wexcessive-regsave]
    168 |         BUILD_BUG_ON(CONFIG_KSTACK_ERASE_TRACK_MIN_SIZE > KSTACK_ERASE_SEARCH_DEPTH);
        |         ^
  include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        |         ^
  include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^
  include/linux/compiler_types.h:568:2: note: expanded from macro 'compiletime_assert'
    568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^
  include/linux/compiler_types.h:556:2: note: expanded from macro '_compiletime_assert'
    556 |         __compiletime_assert(condition, msg, prefix, suffix)
        |         ^
  include/linux/compiler_types.h:549:4: note: expanded from macro '__compiletime_assert'
    549 |                         prefix ## suffix();                             \
        |                         ^
  <scratch space>:97:1: note: expanded from here
     97 | __compiletime_assert_521
        | ^
  kernel/kstack_erase.c:168:2: note: '__compiletime_assert_521' declared here
  include/linux/build_bug.h:50:2: note: expanded from macro 'BUILD_BUG_ON'
     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: " #condition)
        |         ^
  include/linux/build_bug.h:39:37: note: expanded from macro 'BUILD_BUG_ON_MSG'
     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
        |                                     ^
  include/linux/compiler_types.h:568:2: note: expanded from macro 'compiletime_assert'
    568 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
        |         ^
  include/linux/compiler_types.h:556:2: note: expanded from macro '_compiletime_assert'
    556 |         __compiletime_assert(condition, msg, prefix, suffix)
        |         ^
  include/linux/compiler_types.h:546:26: note: expanded from macro '__compiletime_assert'
    546 |                 __noreturn extern void prefix ## suffix(void)           \
        |                                        ^
  <scratch space>:96:1: note: expanded from here
     96 | __compiletime_assert_521
        | ^
  kernel/kstack_erase.c:172:11: warning: function with attribute 'no_caller_saved_registers' should only call a function with attribute 'no_caller_saved_registers' or be compiled with '-mgeneral-regs-only' [-Wexcessive-regsave]
    172 |         if (sp < current->lowest_stack &&
        |                  ^
  arch/x86/include/asm/current.h:28:17: note: expanded from macro 'current'
     28 | #define current get_current()
        |                 ^
  arch/x86/include/asm/current.h:20:44: note: 'get_current' declared here
     20 | static __always_inline struct task_struct *get_current(void)
        |                                            ^
  kernel/kstack_erase.c:173:37: warning: function with attribute 'no_caller_saved_registers' should only call a function with attribute 'no_caller_saved_registers' or be compiled with '-mgeneral-regs-only' [-Wexcessive-regsave]
    173 |             sp >= stackleak_task_low_bound(current)) {
        |                                            ^
  arch/x86/include/asm/current.h:28:17: note: expanded from macro 'current'
     28 | #define current get_current()
        |                 ^
  arch/x86/include/asm/current.h:20:44: note: 'get_current' declared here
     20 | static __always_inline struct task_struct *get_current(void)
        |                                            ^

when building ARCH=i386 allmodconfig.

3. I see

  In file included from kernel/fork.c:96:
  include/linux/kstack_erase.h:29:37: error: passing 'const struct task_struct *' to parameter of type 'struct task_struct *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
     29 |         return (unsigned long)end_of_stack(tsk) + sizeof(unsigned long);
        |                                            ^~~
  include/linux/sched/task_stack.h:56:63: note: passing argument to parameter 'p' here
     56 | static inline unsigned long *end_of_stack(struct task_struct *p)
        |                                                               ^

when building ARCH=loongarch allmodconfig, which does not support
CONFIG_THREAD_INFO_IN_TASK it seems.

Cheers,
Nathan

