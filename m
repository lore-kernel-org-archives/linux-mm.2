Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5833606A323
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ii+ToBK/
Received: by kanga.kvack.org (Postfix)
	id 9A4DD6B0A9F; Thu, 22 Oct 2026 21:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97C3D6B0AA0; Thu, 22 Oct 2026 21:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86B146B0AA1; Thu, 22 Oct 2026 21:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 575626B0A9F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:50:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5FD540367
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:12 +0000 (UTC)
X-FDA: 85352210664.28.B7C72BF
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf19.hostedemail.com (Postfix) with ESMTP id E8D691A0007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:50:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ii+ToBK/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5VOHmm+k0IBj8x+32bgCpnZFpHRZVbIyYT6tTI+jX8=;
	b=ssEI9BRcH3w4TmjXBuMB9kq/XXp5ZfKncQCHJCuHHpwW1MknIf/9MfJMr2Cb2YFwrT8oeJ
	tZsL3Xh/5yHBgqW7jxo+8BK75e62zwdf6l8dYnT0DuPRtVjvwvOYGGNPBiGmZ+nMiUk0FB
	Z2LKDYVzzTjr/vNltZGueHS6IJZ4shU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ii+ToBK/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720210;
	b=UG1JfI2z9wjt13AZaPjT6JZMHiRbLeD1fiu6xpm2AVVg5tv461ddUpy4xvAGJe6qYpzM/K
	7zXHAggOa83qBWrGf5+oaH7v38AdWy28Q47LtDO/WNvUWMgOhMDX1V9qSG6uwDCUi1J1Fx
	bqXwX0aVtHC3Zx3Oxm3MHYzpu88Yn30=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-353804b591eso743095eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792720210; x=1793325010; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=a5VOHmm+k0IBj8x+32bgCpnZFpHRZVbIyYT6tTI+jX8=;
        b=ii+ToBK/gEBt+wA6qGpIm+N56YqaGFPS9HtSlnxPeTdLK4ZjXOHboAm5teHdpYpzJ3
         1sIr2dBRVn72aq7YvxUdGex9y+CtxPeWK3y0+bOuXUd7ZIlTX3p/9pFUIEG4ZB327Nd1
         1ESyKCzHNG2pmTGgAmbWKQetkUWwkRJrApGaFjEuQPETEZp4d7CYAiRjZYm7IvBzvaIo
         q3Q7AXYFhtXo+XBcToSm+Opj9jBc05ThST9rLSfwjzYV0VP4/sj3aWrvFgoHyHxwnxku
         lLjoNRc0lXmlv/E49rTha1XkfAqL6qOG8cq4yCgKaiIS/xaW1DOJ+Ai3x1JMjcKC4kCp
         yymg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792720210; x=1793325010;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=a5VOHmm+k0IBj8x+32bgCpnZFpHRZVbIyYT6tTI+jX8=;
        b=vOn/vbIEU8Lt4B4m1OagvHxPphEcSKtgj4G/V0xAibpSJWlHdigmrYWZ6iZDcG/plA
         wHAZl7dpRPjXFNg2UyQd+5ykrTQWm1jCVYX+S4medqDplZ0ovXKTCh8LUvTvAFGG/1M6
         Bgi9HJB1/dJ9QzA76wudVrQlvE8eus7iNqRpmzkcIqvnbuVGxEtk4oTaGqnjwTg9pByU
         Bvfdu1vHB9hmZzCNFBEk8JkknbOxtQd1oSXywopi7S0m3RkRH90saOOGA9zWDpuqaOjF
         7fA/wQootaYS/FSgdLMarrCEaLPJs1uLx+zP7r7yGYavepz3BQk77C8ngG9oyNjVioK7
         LcGQ==
X-Forwarded-Encrypted: i=1; AKwUvBzSNsVJvJ/nhBsQW32qnytgp3pBYDPSog8Y00C2u1rmGS9YuQjjnyXiBOV/LCIX1FXr5HTEBhu03g==@kvack.org
X-Gm-Message-State: AFq9FYJAthxzlJh6oOgw26IFFX7R8yeD5lyXAXlxw0Vq7wwYpFA1xbaI
	CmvyzorZ/06ReIFIo42Q047SBg5e50WZ4pol/nLaGspacSSruPGBYCiu
X-Gm-Gg: AYBFou3hikKzU1mofbOKMvqOwL0O6QiXTJR4Hdx30gnidCP199pRr0bEUGtLL0fNtlo
	Lzact/XBMD6HMt4/3hfRRvV6Tssbf1/ujFTIPPxNTLzG44+rMHwpl5DDYLusLVcKcYQkkYnrXKi
	GYxVrH2QsRa/sxhwAJsd1hQ+G2yc3C57alZo5v8ataAAcBcMJZL0FvfX9y79J5L4PqrifL2j6id
	nzDXFEC+PhvnM+yrkAIbGCyPss8W+FFyzTO0O7E75qgl0tFaTzBcSkoSIVYCm3qSB+cvLHWisq7
	lBJVuvrRS3FZhb/4AYN7IfZD3Ts0DIVy5oLJcuOp51OLwTBo0cGCZrSsMNzXggZPOJ8QuuJCQWI
	d5pGfM5rQKZoz2ZMNjZyDphhG3wDBJCYvbhURT8vWbAK9mDq3zSg47mn1Z+/glE3aUmtMuicGya
	ab3lQd9Vo5hv5wSc8Bq3ZBXHwMROslrUgv9WgslENQKtgLSiPEIqg7Wb8vxL6e629Grx2ySBeyC
	4DArBXE+zJsJlp4qmy/dzrnn/1CHkAc8ADK+OvUSLfZoftGhonD
X-Received: by 2002:a05:7300:fe81:b0:33c:e74:4624 with SMTP id 5a478bee46e88-369d977beeamr1247908eec.27.1792720209507;
        Thu, 22 Oct 2026 18:50:09 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369d9c0e60dsm1971091eec.2.2026.10.22.18.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 18:50:09 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 23 Oct 2026 09:49:48 +0800
Subject: [PATCH v2 1/2] word-at-a-time: check the first byte in
 load_unaligned_zeropad()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261023-bug-word-at-a-time-zeropad-kasan-v2-1-be0ecfbae847@gmail.com>
References: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
In-Reply-To: <20261023-bug-word-at-a-time-zeropad-kasan-v2-0-be0ecfbae847@gmail.com>
To: Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
 Marco Elver <elver@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, Peter Collingbourne <peter@pcc.me.uk>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: E8D691A0007
X-Stat-Signature: 3epmqdrgparunzburej9icspizogf5so
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792720210-199979
X-HE-Meta: U2FsdGVkX19d6rYbKtuBza2tbU+ORn1IoGkj0DD1rnkCi2TL+2jwrEJ7Zk8SzQz3qS+emv6x3VurkywnrzYkyON4wzGwsyY+bH2lpOqE47+dwQmbVdY8d1NQgZYrknTVVJSCx0N79qQglwCh8tzcC11u/zs28A0prozPH1FGlTWgEKIdv3lx1lId3fpYtWW/9Tf2ryu7ke3gldzEqJw0zxA2MU6j1XcOELvv3ZRA2qAw/bW/lR+kE+wiA2ywkgSIuwIzLvY5vn23+4r6T6WMifRRYdUp2I7IK/8kUx65+Q0pnJEfnlkrLEqBBzQ78lsvXhnJReILPaZG0HUvEypcMIH7CcT2uf7d1oq6TwvH7iiQPPbIwmPohpgWEppP9HDcILanlOTWuhYvm7kWUv89e9rolEYqEILm9kJyu97gn3NCTDREqbg92FIg9gSjrPKt/xcDN3A/d2Nyy1zXIt5nTtjj3OANK4qtu6v2TwEOmZpfR8vBvyPg8g3VjOUHN3+GvvNOHg4d/RlSbT7w1CHxAKGPXvQ+eDxQt7IZIg5y3Iua7K9qX0mCk1g7hWDOjyv9aAiqxSoBBvqBOH0AFMpBiGpXauPneLKJgVsOwRCRZF2n8+g4mtiVcvay3ly778PJDakYPr7fEELEVOvGUvkzx4mupOPT9B2wBfKPvhRN3Ei9lghPlJ7zphmtZ6tlS4jkio3M0AnHYmC1k+6zoQ9ZR9Kbp9J2tTfnCW/efVh/ozOIAfilQT+q9zhp34C2t3ZxRgWcHC6AP+XCM/htr8ehADsJZcEiogkCgrquU/deDq0VnLi8VLig68hRfbX4DPS4IEMFVOEiHfODaoYvgWxzJYf0Twx2y0uxqrUfmFAirtmau5bG6T7Ydj6vd1c6WikKPmszJYLYX6YJqKxl6MwOGnKBbC0ldO6yGrEl3kqJQ1zhwaTb80Mqzbir/Y/+SXaFng0iaQ72mCus1LQrvpW
 oXRcCSwe
 TnPQMGpm0ZQZDnjww885Pe/cIuv0aVQVfckPbynFqVBhF6Lkqh3GXZMSksACVJbVc+L9IebB7g1QEeFo2z6zhjJmmOKutSBorsgx1jsrSFXpkifsdZVVln6bi9lUbjEJLcXs/s0dy9ZokrbGjwwHNHlhdK0B7ugMTrFtu3gDbn/qeLmaLWMDXsY0/OT1IdpUmrz79cnO/p4FkdxVbRs1GLxUCKlk/4mTjslcuXF3NceYGsHtt8BDiqAVdwyNi/9C7hSF7YogqmL5ltRvnyc6BTYZ4MBTF9tSW+ZBtpDmzxcPNyOGUKOoW6fsUr4UUdY78VC7X8kS2obQaLN349KnCxkCAKPuNmnYtgo2OA5ocbZ1tSYPwvpipcRByrcpA+J5jxiFSGbIV3n9yOvupJ+29vZhPnB667pCKw15w91JaGW1oQDmN8VmaGjQAv127f68+2R0bpv1Nov3EiGThtz8bsDm6J5rVGJ84/o1ok351soDfDX1/dR+GURnvTsB3SX1ELt5f4RQgm+WOkGqDnsddlIv3BZFZflHRbUvG+Q1KjsRnYtyF6gNdcJA9At4Xs8vPAGK8qO5p7mtvqzt4/kvmx4mtz9DpD1jyVSKg63DpPy5aT/+SGC3tTyeF3rGrdPUqo9/+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

load_unaligned_zeropad() reads a word that may run into an unmapped
page and recovers through an exception fixup. It does the word loads of
sized_strscpy() and of the name compare in dentry_string_cmp(), path
components in hash_name() and hashlen_string(), and the trailing bytes
in x86's csum_partial().

It is inline assembly on every architecture that implements it, so
KASAN and KCSAN never see these loads, while read_word_at_a_time() at
least checks the first byte of each word. A use-after-free or
out-of-bounds read of a name handed to path lookup goes unreported, and
so does strscpy() reading from a bad source, which the kasan_strings
KUnit case expects to be reported. On x86_64 with generic KASAN:

  KASAN and string KUnit suites      failures
                                  before    after
  CONFIG_FORTIFY_SOURCE=n              1        0
  CONFIG_FORTIFY_SOURCE=y              1        0

Check the first byte with instrument_read() at the start of
load_unaligned_zeropad() on every architecture, as read_word_at_a_time()
does. All callers only load a word whose first byte belongs to the
string or buffer they read, so the check does not flag their intended
reads past the end. Add a no-op instrument_read() for the powerpc
selftest that builds the header in user space.

Suggested-by: Peter Collingbourne <peter@pcc.me.uk>
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Reviewed-by: Marco Elver <elver@google.com>
---
 arch/arm/include/asm/word-at-a-time.h                           | 5 +++++
 arch/arm64/include/asm/word-at-a-time.h                         | 4 ++++
 arch/powerpc/include/asm/word-at-a-time.h                       | 4 ++++
 arch/riscv/include/asm/word-at-a-time.h                         | 4 ++++
 arch/s390/include/asm/word-at-a-time.h                          | 4 ++++
 arch/x86/include/asm/word-at-a-time.h                           | 4 ++++
 tools/testing/selftests/powerpc/primitives/linux/instrumented.h | 3 +++
 7 files changed, 28 insertions(+)

diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index 5023f98d8293d..361771f178699 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -56,6 +56,8 @@ static inline unsigned long find_zero(unsigned long mask)
 #include <asm-generic/word-at-a-time.h>
 #endif
 
+#include <linux/instrumented.h>
+
 #ifdef CONFIG_DCACHE_WORD_ACCESS
 
 /*
@@ -69,6 +71,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret, tmp;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	ldr	%0, [%2]\n"
diff --git a/arch/arm64/include/asm/word-at-a-time.h b/arch/arm64/include/asm/word-at-a-time.h
index d7a3b69dc8c6f..37d45e716c11a 100644
--- a/arch/arm64/include/asm/word-at-a-time.h
+++ b/arch/arm64/include/asm/word-at-a-time.h
@@ -8,6 +8,7 @@
 #include <linux/uaccess.h>
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -45,6 +46,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	__mte_enable_tco_async();
 
 	/* Load word from unaligned pointer addr */
diff --git a/arch/powerpc/include/asm/word-at-a-time.h b/arch/powerpc/include/asm/word-at-a-time.h
index 54653a8634149..1660b2e3e3a8f 100644
--- a/arch/powerpc/include/asm/word-at-a-time.h
+++ b/arch/powerpc/include/asm/word-at-a-time.h
@@ -5,6 +5,7 @@
  * Word-at-a-time interfaces for PowerPC.
  */
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 #include <asm/asm-compat.h>
 #include <asm/extable.h>
@@ -168,6 +169,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret, offset, tmp;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm(
 	"1:	" PPC_LL "%[ret], 0(%[addr])\n"
 	"2:\n"
diff --git a/arch/riscv/include/asm/word-at-a-time.h b/arch/riscv/include/asm/word-at-a-time.h
index 3802cda71ab7e..761fa2734b7f5 100644
--- a/arch/riscv/include/asm/word-at-a-time.h
+++ b/arch/riscv/include/asm/word-at-a-time.h
@@ -11,6 +11,7 @@
 
 #include <asm/asm-extable.h>
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -60,6 +61,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	" REG_L " %0, %2\n"
diff --git a/arch/s390/include/asm/word-at-a-time.h b/arch/s390/include/asm/word-at-a-time.h
index 0b7779c8d5a4e..f3caa4959cc87 100644
--- a/arch/s390/include/asm/word-at-a-time.h
+++ b/arch/s390/include/asm/word-at-a-time.h
@@ -3,6 +3,7 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 #include <asm/asm-extable.h>
 #include <asm/bitsperlong.h>
@@ -52,6 +53,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long data;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm_inline volatile(
 		"0:	lg	%[data],0(%[addr])\n"
 		"1:\n"
diff --git a/arch/x86/include/asm/word-at-a-time.h b/arch/x86/include/asm/word-at-a-time.h
index 422a47746657a..5374e08372253 100644
--- a/arch/x86/include/asm/word-at-a-time.h
+++ b/arch/x86/include/asm/word-at-a-time.h
@@ -3,6 +3,7 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/instrumented.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -71,6 +72,9 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* Check only the first byte, the rest may lie past the object */
+	instrument_read(addr, 1);
+
 	asm volatile(
 		"1:	mov %[mem], %[ret]\n"
 		"2:\n"
diff --git a/tools/testing/selftests/powerpc/primitives/linux/instrumented.h b/tools/testing/selftests/powerpc/primitives/linux/instrumented.h
new file mode 100644
index 0000000000000..114ef9284f69b
--- /dev/null
+++ b/tools/testing/selftests/powerpc/primitives/linux/instrumented.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* There is nothing for KASAN or KCSAN to check in user space. */
+#define instrument_read(p, size)	((void)(p), (void)(size))

-- 
2.43.0


