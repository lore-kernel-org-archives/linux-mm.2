Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70016C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 05:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE36F8E0049; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B478F8E0048; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A349A8E0049; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93ADC8E0048
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 01:50:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 43A1780232
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:34 +0000 (UTC)
X-FDA: 83698083588.12.357694C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C421A000B
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 05:50:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s29zubue;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753336232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWEmAXSsSqp0aOqLizAGvUyWWzoVjGCWN3V0l/bYucM=;
	b=0CxV87ytb3Y+1Sd5XM9JHyp1zoAg/T1+R95piuIpCIpC1LIQcihMnSXLZU9kucLVRGMNOt
	mNyKkklt3j9bMKt7ASVru6QvfNcrGZarcBgAD5jdKrIPQb7jOjrwggO0luyjcUYcLXKGxz
	HhTQMTO6tclrVjQuAHRzilZAcNOwurs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753336232; a=rsa-sha256;
	cv=none;
	b=LTPE0qeVscKhUJwhldZCqeocP5XfU3zYthhiNa6biGtjK+lqwEDQcR+bVJ4Hie4M+jw+Iz
	lgio52ThnDcXvp2s0P31SHLuChq3kcQ/mjua8DhVEkEhByCM1MueH58OLhaPkI/rm+accm
	ogiU8XiAvrwC3h9ZIJFZpQ5LQeXPt1k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s29zubue;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B0D1846538;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50F18C4CEF8;
	Thu, 24 Jul 2025 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753336230;
	bh=HjxWaeaCv8M/oL9GQSiYPTHDkhtk+DTRYh358m2uH3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s29zubuefnI+LBjVqZ9vpCGlu5Y5WvluYyoGkQGyTns5h1ASI0ONXsaMz96AIkRXI
	 cZ6ofUY5AV/ts56FD7h4Y1bDIuQLpyBShwLCqHUW8DfnoPw2vQJCqzlbBvLEe9bAOI
	 kxQ0p30UKRiDezURaIGb+gVISD37zXrkYV5ryEw6lEsNnY69EOXcRhYpYb1D80YLxn
	 I+zACitAelI7J9mGOrR/C6kNqZ5T5TmrV+gQX0mkg7goDAphZEna6azIrtOhh7fcjB
	 Z+KIemqogOSqAlWLzBYa9uUGf/kIwnqbXHcE1N7vHH7V81ftidRhNtlb3B2IzsvdA6
	 8adJrtZ2w9B2Q==
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <kees@kernel.org>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	James Morse <james.morse@arm.com>,
	Oza Pawandeep <quic_poza@quicinc.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
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
	x86@kernel.org,
	kvm@vger.kernel.org,
	ibm-acpi-devel@lists.sourceforge.net,
	platform-driver-x86@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-efi@vger.kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-kbuild@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-security-module@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v4 1/4] arm64: Handle KCOV __init vs inline mismatches
Date: Wed, 23 Jul 2025 22:50:25 -0700
Message-Id: <20250724055029.3623499-1-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250724054419.it.405-kees@kernel.org>
References: <20250724054419.it.405-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2121; i=kees@kernel.org; h=from:subject; bh=HjxWaeaCv8M/oL9GQSiYPTHDkhtk+DTRYh358m2uH3A=; b=owGbwMvMwCVmps19z/KJym7G02pJDBmNJxevUIqUu+2x4F/fOofGOacvWqgmvnqeLJv0JeJDL usnHfXgjlIWBjEuBlkxRZYgO/c4F4+37eHucxVh5rAygQxh4OIUgIn41TAyrHh499h001Vid05L Nkw14RZx7siKejb92THeWXEx6x9PFmT4K1OTc6Ms/eTviZ93fAuV7N800326HO/5hfY1V14Gh4a 0MAEA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5m84wqburdza8ngdfepk56k1bmmnqg3c
X-Rspamd-Queue-Id: 6C421A000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753336232-581037
X-HE-Meta: U2FsdGVkX1/lI35ehNVLKX/VxDdoWJPDM8TRiQ3AOM1GZY50yJggj9Xw4V/D5vV+KVly7yMF7YrJ8K9y4FP4iWdSjOiXI40NJfWNlS3V9Z2gf3MwVessj2OZFgzecw5CFuqoRq01TlHnH5CTu0oy/gNpEjtEnD4uzSvCV8fe78Pt2GhD21+b0VyfZB3OzyDrwi7UCfYdVM2XuEsCy7Hy1vHb8wp2twx2FJyj8bsWHDFPOAe3hiUgd1Xf/kWbhP3EWQtA+3/I31W6VCXQf1g1/y/CPJi7WeOxEOtYmc0QFZjoz8dmRwTjGfAFZ7tBEjR7xMAXiN/EgEp/YvIcv/E+dlc4Vz/N8V0RUXwzg1+BfVUJSeUhO2u4e1E+fEPcC9Z61UHC/3eN0H3hzwdC/pOgnLCnfD96F7f3vXTFJmszjMNO2fs5Ux4htPIr4UD+zuU+P5YXQWsjFa4yN9j/Emm9TIz3afF9oDG+yCUJX5wcXNmW3lnC8PQVSmlkx2sg6Kw5ynP3uhDdCQpGboRLz8X4QECbv0/9TKpNjDpHjDRoPeNRW1+O4lGWBcPvEeT4vUy80c8l46bgK+jK3jWEeGYCmuP5EaD4mg7G7rXR/xXrBgx2/HhAh3GdkIaZiynbD3ZaPbPB6mNJ8+dhL4gmrN9iGG3zrWoWQ9ayAFRKGTaFNwY5Ixyfc/Aypq5yXSXDnvHlPXHXhA8LHIOswp6aU1maR0/piBLMy7uIeEsYHhwSVAQlDfMO4yazEQ/EWrRTwSTBgNw80U5BND8cnnxMZNr5NWu68GAaKL1UOZG5u9zkgHAZ609jcmapIOOLHr9iUOIvt8ENHsvlX7C0rCxPScWvXNhUJXed2XpMXGD0fsYQhqziwgYArSm5sYWgAfrgWUMesY61eSAkgd2ANGRzraQyo+jgaVE7rDgxKlOhZBGishdjDjyZU3lf2QPxEJ2ewqyrCgdEYk3K8gCCpwT2cKf
 nEy33NVz
 Gp76afnKUbYrzBHhT9SxbXSoEPtCCT+Wao+qm7WjvIvzPfFXcX5dL9Ybn27qvEhRM5WqKFEwbLwStxPAkaZsHF2kcOaT737WJ4J41WlT7D+mCH5xVmc3VnpjihdOySM45lJ3kBDxA9VO2FlV3Lhh/X6uhHaWihGOtlysQmGcvGuW3vspeLqztfVBdSDTW5YMwUtkE0WpElhJMo9w3eeiHbMhutJpXNlOVi/pQhGn7qLgOzB380sZhKHmEYaL4Hv59hgDsvPCwMQvyRhMMx6VFR0GBm7gUy0/BgQOQH1a9O19SzJAkpm414XUAfRQnaKhCDvOFoB+W+1EdCXsRqEawu+C0aZ9scjsgKWWeDdtkLDDRJecLbd4QmJ3DrjsBGAFp7G7Eh6CH2/S2NYD7vVGtw5ZfRoIipCshMt77bUF/FIPUlGGs66l0nTQGDg2XLayoAIDd0XaWNpoh3Uhx5i1lyqPHuJVOjqXrC4GmG2rdGsdEVazm5XiEKVIHoy5QZL3/eUxQWZaf0zoyplswFlBGVUg+wWZX4NxKsFBX9gGeE3dUnLr8UIWiYoLu+jf8ErAqYTMmqHa5VS0SA8yCzmgjzOeIAbrpeVClF87Plva8bZ5pExnj2X1s8gjIkzsUQoFbbTmT+xjzQxesnys=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GCC appears to have kind of fragile inlining heuristics, in the
sense that it can change whether or not it inlines something based on
optimizations. It looks like the kcov instrumentation being added (or in
this case, removed) from a function changes the optimization results,
and some functions marked "inline" are _not_ inlined. In that case,
we end up with __init code calling a function not marked __init, and we
get the build warnings I'm trying to eliminate in the coming patch that
adds __no_sanitize_coverage to __init functions:

WARNING: modpost: vmlinux: section mismatch in reference: acpi_get_enable_method+0x1c (section: .text.unlikely) -> acpi_psci_present (section: .init.text)

This problem is somewhat fragile (though using either __always_inline
or __init will deterministically solve it), but we've tripped over
this before with GCC and the solution has usually been to just use
__always_inline and move on.

For arm64 this requires forcing one ACPI function to be inlined with
__always_inline.

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc: James Morse <james.morse@arm.com>
Cc: Oza Pawandeep <quic_poza@quicinc.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: <linux-arm-kernel@lists.infradead.org>
---
 arch/arm64/include/asm/acpi.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index a407f9cd549e..c07a58b96329 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -150,7 +150,7 @@ acpi_set_mailbox_entry(int cpu, struct acpi_madt_generic_interrupt *processor)
 {}
 #endif
 
-static inline const char *acpi_get_enable_method(int cpu)
+static __always_inline const char *acpi_get_enable_method(int cpu)
 {
 	if (acpi_psci_present())
 		return "psci";
-- 
2.34.1


