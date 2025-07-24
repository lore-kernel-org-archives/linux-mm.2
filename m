Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C17FC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C16F8E0048; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098268E004A; Thu, 24 Jul 2025 01:50:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9B38E0048; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C05ED8E004A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 79B97583E1
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:34 +0000 (UTC)
X-FDA: 83698083588.05.8B67EC4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id D10EF40005
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgWgAc1Z;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753336232; a=rsa-sha256;
	cv=none;
	b=Rx9RbKcKzyIjC5jIxB7gh7RDboAhlzTsuq3pS7TF8GbR3aHiIhA/TjTPjX96Is36FVKLO/
	uZNUdjE82Z/+ff6nXNKSOJ1wMEZhX6RjFUkdmVsAxzkTupu4PjmXcdi+YusP6jwpRh3RtH
	R8Z/TPLcIG12a7lNJyR+B9GJhE9dnAw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgWgAc1Z;
	spf=pass (imf27.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753336232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j17pn+//SHkaX8ONm+HlhNEvqzcDQ+QNAUfr7A3lEQ=;
	b=ghWNTRmpMEctEFCYUlcPNDl+jhDv+M6oexZxju/MtK3yRAxXczrvW4DW8jjVJZ/WdaSOuX
	LSk5PMvGUT96SgUVeDsCoJUX5UwB1QGIBDB3GH/HcRdTpgqroAc3EYuHWg1nWXP2pHRVS/
	4bzcdNg9cUMHzvFRTTU6owWuoeI9MyE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 68FF46114C;
	Thu, 24 Jul 2025 05:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC523C2BCB1;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753336230;
	bh=p+7YUBTmffdnZ8pKAPuZ2rzC3Zvp9P0MFRgY7Xz1ydU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgWgAc1Z4h7uumRs3FFTKmk6zT6WYc3ZB83iSXiAZCG3NFITyJRewAAhvM7SCdTB4
	 RxT11O3im9HodJy3iQHDCIux7eUlVSNQW6vtNOpk+XKga6Y6fSj/9wwhDqjvs9xFUF
	 rCGWpttB1snOwFhFvWshiFbzZcXiHhUf9pIp6AbINpGCNdRMNio67jDVRMKJBh7BuE
	 fdkdGJldi6mApzEQpFIUP62H0n6GbSbzIk9V1TPCmz4OwMw6YkG/4j38bPS4hFhKJ2
	 k2xWrnI6HQnV9XChu9iVDC9Tei62bf2nNEwWaweCdPI6/DaXZd3bddGMJWg3LAw2pQ
	 U8NDMsvEgKExw==
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kbuild@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-hardening@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
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
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
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
	x86@kernel.org,
	kvm@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v4 4/4] kstack_erase: Support Clang stack depth tracking
Date: Wed, 23 Jul 2025 22:50:28 -0700
Message-Id: <20250724055029.3623499-4-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724054419.it.405-kees@kernel.org>
References: <20250724054419.it.405-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2299; i=kees@kernel.org; h=from:subject; bh=p+7YUBTmffdnZ8pKAPuZ2rzC3Zvp9P0MFRgY7Xz1ydU=; b=owGbwMvMwCVmps19z/KJym7G02pJDBmNJ5fsPnPUwKQyTLv6YDRX59942Z9pVg4x/Z3tr6sPL i8Lmbqoo5SFQYyLQVZMkSXIzj3OxeNte7j7XEWYOaxMIEMYuDgFYCLbGRj+55xsNLv8fgpvz+zJ 97Q2v1jyfM6aXx5r3h0o/XvrBVfaBhWG/34taus75nNe6jl2+9BH9ihD5yM7dLl817dcaviWpVx +gAsA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D10EF40005
X-Stat-Signature: bemjpurqwuh6jb4xg7yy8phcr9jcypzd
X-HE-Tag: 1753336232-147518
X-HE-Meta: U2FsdGVkX19GlcF+JUBTc9SPv1hebdkcyBbg6mmLalceJfcVo7WIyqdhkIPHTduahZ412x24zk1LfawQWlOcIcOeqdK2/7TiXYBUwVwAP6HlLmF8YvLl+Lk9PSA+w2Jd49eKQWBDG73T/8+TFGg6UNm73oa/ZoN/N0JDlC+oZFTDGJYTAZt+swXM9IudvUaACQUMqeD7jegtvyG87NuCx0nue0YuU/V/S8ZuHdCgv72eWE9DfNmIK+1OUV4z8cU/qhul3W7+nNwoFsJiBFhGaoWljg5SQcr45Yty5hhubcS1idZ03yjz0vpg+jg7DbNUQVhhewHaMt1drL9GFFhOEXPuPp3CRAq13nZw1UgWDz2JQ1DvZuZft/86hvrI6HhyoL44gh1ktE/6Os2lTvtxnTVPyJWOZEaZtTS/UxjA+RKRKdaVpi6PPThCTVu5yY5fisSADMYm0in5JeL2lAukRtQEOwiGhTMRmz2Ytv+Tr6qnkgAKFmG0NkQhGXYTCFvgOKF7BG9fhHD3N0Ki4+hWy/h0TW3ZEJ4M6uQB3suYQPlLWqshuIsbRH3f0umG6JNSUna1c1f3aLiSY9OsMPmCPU1CMITy/wo0D/DqygMQKJ5BZwCZbbUG9c1952+C1vWxrfHSJ4H2X+mrh7/bqvHnPb0q9+xm1Qf8fDyFDXYnSS/g2tL8K2T8MhQbWwHOSOkIKFn0L4H29ghIUbYYVLNt6FdsRSIKCHkHe7V/M7/vM1QYMUidsfn9ut/WR1KlL39Yt1j2XLIBsw07dk8ZWBJZVK1CkBW+Wt5q3LoCFaIBvhC1ozzr+6UEBe4AVAaiPvxKc7RNaWWKDrIsljQTdqRIgfPhe26rbbLvDwDZolO+2ZB52/AzYNA5+nU+d4NumotEpYw6ggyTDHoI6738OoqeGXUegL2bODQAFK8oyfXZZXyrO+l95J8mSNKc8MyLp/WB5jhSIk3x+NFpnhX5WFy
 VPXTf4Bt
 JbK3rtAWGvaOgKUuvUt1kqF3g6iqHclADJehT6EZAOX2ud9okZHaFkUq7CfEnFAhXbc4bBHue1hb3OeQlPrwjfw361QXL6DlmVHfjMOZ2e5qdzi06iSceuwfYa0gdSKfaW1txeyeOXnGD1BdkzPvgaz41ruFWaFax/idA3khPkCwD/EhuzFB2sv9po7HDwoRlAQvcww+jGj9god7+1gcZAI+n/S8FwqgGdWK8hPMFZS5uZXRwBsWDmKxeVx6Oy6abeoBNFMWbx6jZA0wqHrpIOr1FxPRyNBp+TmCcEi6s8ZxF7Owvhc+84RUvh+QBJakUUdc8j6X5DO2YFVyp2C+b3tqHPNNTC+CyG8yUWHSQkTWQiitPTVBwV/+kSuV8hsxnFqyg03bBK1Zb/LI3vfBPz9Cjq3nRrRxIIEiMN2XXEaZddxkJ2aAIZiBRjv5FBK+j8GFhmGNj4X78HzxooW6/XMFRfRD6W5Ccx65i7kr6iV/ohdzzygLJOOLgMCpsB/g6gvgAYRmwaGWWOMZkuK4Unv0iGLlcJSzo+kwEjqomog3BxiI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire up CONFIG_KSTACK_ERASE to Clang 21's new stack depth tracking
callback[1] option.

Link: https://clang.llvm.org/docs/SanitizerCoverage.html#tracing-stack-depth [1]
Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nicolas Schier <nicolas.schier@linux.dev>
Cc: Marco Elver <elver@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: <linux-kbuild@vger.kernel.org>
Cc: <kasan-dev@googlegroups.com>
Cc: <linux-hardening@vger.kernel.org>
---
 security/Kconfig.hardening    | 5 ++++-
 scripts/Makefile.kstack_erase | 6 ++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index f7aa2024ab25..b9a5bc3430aa 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -82,10 +82,13 @@ choice
 
 endchoice
 
+config CC_HAS_SANCOV_STACK_DEPTH_CALLBACK
+	def_bool $(cc-option,-fsanitize-coverage-stack-depth-callback-min=1)
+
 config KSTACK_ERASE
 	bool "Poison kernel stack before returning from syscalls"
 	depends on HAVE_ARCH_KSTACK_ERASE
-	depends on GCC_PLUGINS
+	depends on GCC_PLUGINS || CC_HAS_SANCOV_STACK_DEPTH_CALLBACK
 	help
 	  This option makes the kernel erase the kernel stack before
 	  returning from system calls. This has the effect of leaving
diff --git a/scripts/Makefile.kstack_erase b/scripts/Makefile.kstack_erase
index 5223d3a35817..c7bc2379e113 100644
--- a/scripts/Makefile.kstack_erase
+++ b/scripts/Makefile.kstack_erase
@@ -8,6 +8,12 @@ kstack-erase-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK_VERBOSE) += -fplugin-arg-stack
 DISABLE_KSTACK_ERASE := -fplugin-arg-stackleak_plugin-disable
 endif
 
+ifdef CONFIG_CC_IS_CLANG
+kstack-erase-cflags-y += -fsanitize-coverage=stack-depth
+kstack-erase-cflags-y += -fsanitize-coverage-stack-depth-callback-min=$(CONFIG_KSTACK_ERASE_TRACK_MIN_SIZE)
+DISABLE_KSTACK_ERASE  := -fno-sanitize-coverage=stack-depth
+endif
+
 KSTACK_ERASE_CFLAGS   := $(kstack-erase-cflags-y)
 
 export STACKLEAK_CFLAGS DISABLE_KSTACK_ERASE
-- 
2.34.1


