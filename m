Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49083C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1138E004B; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9783C8E004A; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79D238E004B; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68C5E8E004A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D6151602AF
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:35 +0000 (UTC)
X-FDA: 83698083630.11.57964A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6800940007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooTp5DYa;
	spf=pass (imf01.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753336233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8D4LxVY5xiBAnCpq4qjYfypcmK3R7vRmG4YyK+yYkI=;
	b=6ysD7dWwz7XOocafsrbEolrgi7aBL2eGeTfugs776dJRVAlW3rE53CnfZmfvhPYkkH1VIE
	OZz3Wu0d1p0gF+7mZar7Eh7g0oKxtxQ7yjSLKnUKXKnQxXGbtAh9BwS5s2GjjJTd/bUuuA
	cxlyUut4bIufwjaWUX329ZVXLo23HHM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753336233; a=rsa-sha256;
	cv=none;
	b=Wo0Otu9DFxvU7M3Lwxm4QdbTqXO10N9PpuVSsozeN7C9aluxtVIEQYbjk82r8OdPwR+hRL
	rpnKlIJkiYG7gwwVZHwnkFG0U/uRDuPJsfXjqg8BvSnyZy2nE5YvOHBSmFM2nV5UN2NPLc
	+EPEXkEebGzobIMPqZ4iu+pN1RFeeio=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ooTp5DYa;
	spf=pass (imf01.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FA8E46587;
	Thu, 24 Jul 2025 05:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F08C19421;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753336230;
	bh=9V+bffTinVGVEjmw6TF+C5G0YfQpy53YZa3Wm2q7aj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ooTp5DYalG+7sCY7UY80o0GaKZMJuJsxJyjGuabcQLgPm5nuSMqxAePrfT7GjvhdK
	 oF9fORgAmBuhwOhWaT/I1eVzeHaxvCjNnvP3mFcCVtrohHTelgnJB8AxJRHMej+Mg4
	 NFDjdV1sYJAqwLAHAKG+Pc7P7tPoem5TaSnEds9YldJcU6sAmB42ruRa5SIZpDw1hv
	 cKr4I8Z7LDvwzyqdEhc2lYfeETzrrTMLlCXC7ApBabnc8CBhH419Ml2t43642mwJKw
	 GdpLf5pCI2siQYBJvR4jNh/zgf/ZyAdgBMjqYlW1WxwimCTLeg3bNom27bS+51Pyca
	 3cu5ZswAR3k0w==
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	kasan-dev@googlegroups.com,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Len Brown <lenb@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	Juergen Gross <jgross@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Kirill A. Shutemov" <kas@kernel.org>,
	Roger Pau Monne <roger.pau@citrix.com>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Usama Arif <usama.arif@bytedance.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	Thomas Huth <thuth@redhat.com>,
	Brian Gerst <brgerst@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Changyuan Lyu <changyuanl@google.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Jan Beulich <jbeulich@suse.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Bibo Mao <maobibo@loongson.cn>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kbuild@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v4 3/4] init.h: Disable sanitizer coverage for __init and __head
Date: Wed, 23 Jul 2025 22:50:27 -0700
Message-Id: <20250724055029.3623499-3-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724054419.it.405-kees@kernel.org>
References: <20250724054419.it.405-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2887; i=kees@kernel.org; h=from:subject; bh=9V+bffTinVGVEjmw6TF+C5G0YfQpy53YZa3Wm2q7aj4=; b=owGbwMvMwCVmps19z/KJym7G02pJDBmNJxdz3tX005Y/rnL4YOLkChWuJ+9Wl0ZxtHAnf5w+4 +zlC8f3dZSyMIhxMciKKbIE2bnHuXi8bQ93n6sIM4eVCWQIAxenAEzkYR0jQ3OLrmDdCpsGS/2v XwqtbKYZz2RJ7Lh0a141x9MPJVGnpzIydBStU54v9Wp98GqlzKdyYSda/YzleKsypsy4O3tZzgI uBgA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6800940007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 97dp7ety9axmfbas3kikta83xsc14hqr
X-HE-Tag: 1753336233-487611
X-HE-Meta: U2FsdGVkX1++3cKp9YFtSC3V5wbzlNb5jzov7EAwpJ7J9zigOKFg6SGraEOcg63tllBScdlbcibheaN7YsiX2n8fMLKx//7hnYQmAfTRR59RQe1R/xi1au513LiJ5uhNP+6/mSrYvlKFMRCt+6/6EmIc/2JeL5DKDWGGVZq+UwtMEN+cOvjKh85ogzFJmHjVNE4IQD6mWDiBCtSvwzR1cIQQ9SW+RcDQUHwEzV++brfchkPdURIQasQ8RfWKJdE2tisLIKxsbIdyzdgG3ZNH1/en6ngogJsjqdHu/uAprLU+GhmrAQOn6u2nk2BmoSVRn9KESvDaKYiZTucmaX4ZiALAH077efF63Flo2jgX/k4eJFFe8DEyqNBWCYYe7ettyXPieH3iTMHzY5eX6U+h7RE2x+sgZGEsBlnQwK/jopUzvyoKK6yJhIwH+np/AhHZ/ygJ4Efj4It6af4VorbjzKDyzUR2j34dBda+se5z/JNg0JiDGk/dpPka2qiHynP1rzHd6D4qBVr0RqZVgM4AaooJWFo/GPefLXA33glZx04cnWFP9ey6nMvJ797LnuJXfoT4IRyuEQhEhH6ICmTnE/Pt+wdBL1ykMc7zU2kTMSZeJK4D47fNu15dBvgskBkj5+9+WcfJvXl+0AElDJQOLcmiq/PNw4vo7xN2NNPAdlDfXDWbhAOGaYhgQYl3yrxWSHlW8qkA67RgoslygC7SurY94Jjvd/Z9psu19owtzzlJRAxl/j0MzV1Z1WsrUo3aAYvK6DHLEdeuUAOW9rXRtA5LqRHPS1cn0mKp2jM8flniX0Q7b0rvcxxZsEEeGx7ESr45q/RJnGFbJ5JajHtXozLBhmovEmpO4qBbNv/rIUODl6rLeuq7uF9lO1qOWj59zcIswoZsTr7JKJ9sD9NtAX1NGGioTn4/tb1+QmKY2UC23CmyQadlxyJcazq7pAu6Nxczoj8n91VL5837soW
 SvtKAoSd
 yFUHmLHi/G46EoqcK9hs6lsh7CAxfs5jtWirHlmbwx4Aw2GhNW29TdoWVx6dPH03brDva/evKSGZJC5uMXCmqgQ1gH+bB9THKAanvUkTDnqHVyk1fWwUQkueaHqwXHG9Dx57AUvzSIkNxwU8cViDqbptibhSg8PopkZlmDY50MW/Rq9u7sDb/C0htPwkuxg7d7jU/deHhr/m5ZuCsaGkxuaQNNjGxbEL1Ufqbz5l65xZXJNSZXR/oEbd73MGHisf8srOZnygsROtH3xXBUVLvNjWSNu87wnfCoYFhitvLQOFSxcIdOA2C4dVVSiZED/o8YdPZzJTC+9WFPPz32QSCr0Z2DlkOuu+bTD0wPSGvR/pzX3UaJX52k6eiIzXrUig+hZQbX50aj8Br1OusCywSW00HSBuMYmIKVZo05SsCO34hqr4JLxvNm+KJoI9xLFLiF7x15RlBzNGqg0y/T/LdM27m1HmFQW/84cOATifJ92ZVj/U16wgazW/W6SebUBzLmDkjZ6XodnpXhQOT6d9vSSm1kMbon7RH3nxZNLMtVdC9sR/NVI5oGz7nT7sLt+ieR+jgcAU/Hg3/OKZlOd1oDcqW5vMnRx3ppvIKkEQ9e/Fqr8qyZa7TloWJF7ebTB4ao2rk2Pu3dRj/l+Fs1bljs6/H2h6R8hkyOMMf7XXIoeSt5dWTqYzds1VYriraV2V9inUCSOgYCVuKjC2LLg8pJ2HK8x+nXCf/LX9MFL54GcoBktL+pWk0JK60awW/OjFEeTZor45zHpRlr3+Ury+ghTXPdMyqxrjVR1h444JMJ/q/vgvRAZAogNgATQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While __noinstr already contained __no_sanitize_coverage, it needs to
be added to __init and __head section markings to support the Clang
implementation of CONFIG_KSTACK_ERASE. This is to make sure the stack
depth tracking callback is not executed in unsupported contexts.

The other sanitizer coverage options (trace-pc and trace-cmp) aren't
needed in __head nor __init either ("We are interested in code coverage
as a function of a syscall inputs"[1]), so this is fine to disable for
them as well.

Link: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/kcov.c?h=v6.14#n179 [1]
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: <kasan-dev@googlegroups.com>
---
 arch/x86/include/asm/init.h | 2 +-
 include/linux/init.h        | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/init.h b/arch/x86/include/asm/init.h
index 8b1b1abcef15..6bfdaeddbae8 100644
--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -5,7 +5,7 @@
 #if defined(CONFIG_CC_IS_CLANG) && CONFIG_CLANG_VERSION < 170000
 #define __head	__section(".head.text") __no_sanitize_undefined __no_stack_protector
 #else
-#define __head	__section(".head.text") __no_sanitize_undefined
+#define __head	__section(".head.text") __no_sanitize_undefined __no_sanitize_coverage
 #endif
 
 struct x86_mapping_info {
diff --git a/include/linux/init.h b/include/linux/init.h
index ee1309473bc6..c65a050d52a7 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -49,7 +49,9 @@
 
 /* These are for everybody (although not all archs will actually
    discard it in modules) */
-#define __init		__section(".init.text") __cold  __latent_entropy __noinitretpoline
+#define __init		__section(".init.text") __cold __latent_entropy	\
+						__noinitretpoline	\
+						__no_sanitize_coverage
 #define __initdata	__section(".init.data")
 #define __initconst	__section(".init.rodata")
 #define __exitdata	__section(".exit.data")
-- 
2.34.1


