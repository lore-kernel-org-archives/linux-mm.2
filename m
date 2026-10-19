Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79D6CCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF7D36B009D; Sun, 18 Oct 2026 21:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDC16B00DA; Sun, 18 Oct 2026 21:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE46B6B00DB; Sun, 18 Oct 2026 21:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 861896B009D
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:58:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 079521205F7
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:33 +0000 (UTC)
X-FDA: 85337716548.15.2BFC02A
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1EAAE40004
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ula1KJE+;
	spf=pass (imf04.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wabN2RpcS9yTy4X+yFbisN0o21RKH0fyf1fEhCrMYgc=;
	b=kltzpS/wAdFlHZ4ajiu/OOVVlsJgKGIA/d1w4UDlXH14hqdo+Ejs0bYKUNZTlb0AknuNdV
	bRx18yMnzYu8sEEdaVWECSdtZSAM2nkfw++EhyUS0Q8ciU8rnGaNGqenCesdDAlhZb3CKU
	0BWantdbAHwS0FTWIKb+/kjg7GApWfM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ula1KJE+;
	spf=pass (imf04.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375112;
	b=kxoGcNizTPp9F+OZX/QrznLqJ3MbViDGevxX5GTYXHyUav4O7mJtJJa5Zii8upFzZgYsm6
	hcTpgfavGNZSiAjyvNlwJEz3iMxo6rG+RfIulnjK7wsIOcAn5D1BITiErh6yFFW+aEuMcV
	Q4tnxv1UHngOHQgeQPqpGtqG/H50ww8=
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-35d0be18c71so2911728eec.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792375111; x=1792979911; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wabN2RpcS9yTy4X+yFbisN0o21RKH0fyf1fEhCrMYgc=;
        b=Ula1KJE+7YnCangfPdy4vXJkPEyHnXP3DTNo/pc4srq+mszNHtfMsD8zDEDdjT0hWd
         RD+CAjtoOApvDoJU5FlP/1ZayxphJT0Nhb4BttkqxI6DdExNx9AQCcPMSRSMS1jaFL6J
         beNszTJGOaM9wt99aT/3Q6+j+/Phq3slCLuzoGydjM5RDKt1pkcfep2Nc4C5KcqymT89
         MM+5yg8ZVqX9tOkIXTVdjRSFKhgESx4OjpoItdPsrNcGeSOvKLA5iiiZ8wSUKHk7JD7P
         B5gX36NDrjn6XPSog+ok1U/2Tpp1KWfWgJ9WHCi8iS2MXblcN4HxUo0rXhXU7vBq8Qco
         akvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375111; x=1792979911;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wabN2RpcS9yTy4X+yFbisN0o21RKH0fyf1fEhCrMYgc=;
        b=gsgaqFmK0BDZvDUIKnlMGr6Pxa6r+tzu0fFw/+Du98RjhYD2F9NwDZimCSQX5Jwnk1
         yvtTxfqxr2CCVYiJkYIu+WD80mqInB74XkmXdGL6JHN98KUB/HwHSR6D8IexG9YcukrK
         hP9XaxtivEAGNqyayI1H5mfZLwtXwQVf3KhzkBZo+mPhgSjmrYvxOptof7B/s2NCD5DM
         mHzoTfL3OG6jkkZyyhA7oqiO61Vlo8QRvgX/R0Fg/H91A000j4sHZx81f3kcU/BZRLE+
         4gqqQLiprrZHE2kf4P/pro+gkBTbjEOFUeErTq/X6ynmlObdKy2TSXfDw2b6V+UVGvoc
         ChlA==
X-Forwarded-Encrypted: i=1; AKwUvBwZS4yn8EZLblKTGrewSK9+ItJFMpQXU6qVA/n+sIegD2mUQSn+iZYTU9Dkdh+7urwQuQ6Nnk+2tw==@kvack.org
X-Gm-Message-State: AFq9FYKlyOt2o2o2UoP6+BLerpweCDg3Sp9vp60yOshVn+CY/sqg8qyK
	K2Pm5GyFVyT4GRFDfUinAx4NHvWACC5RyHnnhRk4J0sBnVsY0QPiuqJ4
X-Gm-Gg: AYBFou2qeGRTzisfoX8KfXoYCsrIe+gdNyvw4qbJJgglQGPIxA5+qkX2Bz5wQo0S0ow
	jJp5ZBm5R0vK0WA/5SJCs+UxUcGVLGEIU0Uy1c77efh6SkMwMLSE83AyRrE4UkHkuNQDo0WDx6a
	8lSeHUZ8pB+mJqUcbD5GHsNbrP3z45oFSHot+vrncYIuVA1z6DKGvRdFeVtr5BJvohdsLMZw3tD
	T0fmOucWCw3DsGHX+0Q08idpZJsv8D6HQGpdB88dnehRHAZVMcoFsXnX8TNOPqdTA0WKRqvmAoH
	IWsaYCF5AvCB6brlaIP1pUrQzDex1H5MOmQemqKEGFOoLK1Oc97HcdbhX9pW8UhKDtjv9Qp5mMS
	zwEgxWVEcgZlmy4Sll2+anI8vmmhjZgaWa8ZGQLLue6yMhgTT7BkBQ7y7jipKQIfX73tu+33nne
	WcKttpoH1U04bRIq65EBTOZuw6Wn1wkh3scBP/RKDqkQSP2gtYqMFEKV+7aH6uyO542GR1nrk4D
	bvP
X-Received: by 2002:a05:701b:4202:20b0:146:5f73:d45b with SMTP id a92af1059eb24-1850be495b5mr8924712c88.3.1792375110248;
        Sun, 18 Oct 2026 18:58:30 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831ba424a6sm24177311c88.17.2026.10.18.18.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:58:29 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Mon, 19 Oct 2026 09:58:09 +0800
Subject: [PATCH 1/2] word-at-a-time: check the first byte in
 load_unaligned_zeropad()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261019-bug-word-at-a-time-zeropad-kasan-v1-1-f21a3ed6a477@gmail.com>
References: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
In-Reply-To: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
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
X-Stat-Signature: rn35ssehqwbzzipmobb7ziojibggw1pp
X-Rspamd-Queue-Id: 1EAAE40004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792375111-392217
X-HE-Meta: U2FsdGVkX1+cjmE1dJJX+vV50HHdqML1LgxrAGm9AxNIysjcCI5plLOOtxaHfcA7RX6Id95lWkxcEqZRmA3csBoI7AzSXQhQVBk9ECch9UtN6YeSJKDxuqz/8W1wyDz89YaxtdwoNDVW4saIS48GW5k64ZlqupJpaYreA3/tEM/Hhur95YBGC8RuLaj81+kD0JBTQctOScXrQEKCYJS2m8thS2PFJvKl3mvJ9kKATjTeD+PRM06yyda+hxnTCBKzcwr7AwZqUWarHWaXwO2QK+oCRKrMEFbY6/vXCMWXSLcPygwRV2kNW22hPSDnNYXnL/OSM7MhLohW99UPjj7YzxsV6SVXk6+mHzzjMCWaPpGzD6eR7owPlKwIMJWRsyeGWoCeZyvKBygPoxrWMlzMj7jZDANuXYoNWTdRlcDDJ96gg8aAunSSv5MVy7ou8X7UDfr2Y2nuenoI4/+UMO9UtecabmvQrSP5mx1R7ZdVM7gHfyw5w1bbpuZF0hMf7cGtPVhu92bcFatr51Ih2xSJ0+4RIryL34qkUmLJoL9IQRocAxOw/sg868Ht502iaktAU/u99zj43lisOoysymtcyhQTJw8l46mHNV0lFJk9fD4ymeKpiq7FWQC9YOrZWfDuDF25C8dbHEq7xoDVWfNRJMcZjNvhujACYdRsUEDfjmu05HcVAW6ru/BLtZBc3BQrFEZvjU4h0yak5FV6qom3WjyYmhzpKKSAEKaHkcF2sZRMb0B6TMxXTIwmJXN32zN4S+7rGyy7bfPAiJ9ZP3/h6zH0au63EQN2JtQXSvEP9gGysZEyy9KViR17qF/wcnBol9pxqGch51IPnOQGt3jUjyzpD4AqCLTWlATDiGkhCl1kMcEFYNdww1WuxZ0nqVIsak+1APIrmV24OmN1ZVewJWbVDOvYbrWVmwi4P1WdeW7aVP1R/P8DbXmEzNk4KuLV0qM7XGk5iq9/R+TZc8a
 rTS7V4J8
 a30QggDkcunFw0bcmY+FUTG1Gb25cD7CZbWsXYR5oeikr7/i83B2k4eICtW4hR32hKlBbRpNVmR9MjqMMcJenlVUVZicStH5xr6yE3rMRBsqqVuJfXtMYAwa++CYpR5VzCUZQMQ+fgQxnDWfd2abojhuqz+iaB4vmTmqvc1aMQ+lPyfDVf64dFXhcYppvzP0CKPB9gLvKNQZYnIU/niZh/ulO8YQ0VRxkxZP2Ti2OrgMN4Pqnjo+xCKVI0Gl/OfN28SKm1fkn4lmFTgBJbuWiZLG7EVuq8hpojJhaU8+7/NP4JiAn2xj2InMTsMtIfq3nejakT0U/GZ60Ade1f5F/3TkfKnbItFc54vlP8bcxK4sa7lUtjPnnQMG1s0XfVTbUm4JonHXznRg6MwBOzn7Kp574KqP3rJhHwB/6yF+qnPFoTZIj7R4+/3V5ebKF6T114daGxcDxJGflqFftMKpBtDjQ7guP1PCr8Tcoycd8m1CNjp1Ue7rbaXSK2c3mo4Y6Hw51BHZA9FKMkmBO8SqNPjxPEo7OQwRUXNj29YqVWDUS7kfOrPvI8SBPgwAJpAjN/o85ixRmRH1Zb3Rqevg3wLS4/Z7igUyxjO9T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

Check the first byte at the start of load_unaligned_zeropad() on every
architecture, as read_word_at_a_time() does. All callers only load a
word whose first byte belongs to the string or buffer they read, so
the check does not flag their intended reads past the end. Add no-op
stubs for the powerpc selftest that builds the header in user space.

Suggested-by: Peter Collingbourne <peter@pcc.me.uk>
Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 arch/arm/include/asm/word-at-a-time.h                           | 7 +++++++
 arch/arm64/include/asm/word-at-a-time.h                         | 7 +++++++
 arch/powerpc/include/asm/word-at-a-time.h                       | 6 ++++++
 arch/riscv/include/asm/word-at-a-time.h                         | 6 ++++++
 arch/s390/include/asm/word-at-a-time.h                          | 6 ++++++
 arch/x86/include/asm/word-at-a-time.h                           | 6 ++++++
 tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h | 3 +++
 tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h | 3 +++
 8 files changed, 44 insertions(+)

diff --git a/arch/arm/include/asm/word-at-a-time.h b/arch/arm/include/asm/word-at-a-time.h
index 5023f98d8293d..f672aad2e30e6 100644
--- a/arch/arm/include/asm/word-at-a-time.h
+++ b/arch/arm/include/asm/word-at-a-time.h
@@ -56,6 +56,9 @@ static inline unsigned long find_zero(unsigned long mask)
 #include <asm-generic/word-at-a-time.h>
 #endif
 
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
+
 #ifdef CONFIG_DCACHE_WORD_ACCESS
 
 /*
@@ -69,6 +72,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret, tmp;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	ldr	%0, [%2]\n"
diff --git a/arch/arm64/include/asm/word-at-a-time.h b/arch/arm64/include/asm/word-at-a-time.h
index 824ca6987a516..11ecca99057aa 100644
--- a/arch/arm64/include/asm/word-at-a-time.h
+++ b/arch/arm64/include/asm/word-at-a-time.h
@@ -40,6 +40,9 @@ static inline unsigned long zero_bytemask(unsigned long bits)
 #include <asm-generic/word-at-a-time.h>
 #endif
 
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
+
 /*
  * Load an unaligned word from kernel space.
  *
@@ -51,6 +54,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	__mte_enable_tco_async();
 
 	/* Load word from unaligned pointer addr */
diff --git a/arch/powerpc/include/asm/word-at-a-time.h b/arch/powerpc/include/asm/word-at-a-time.h
index 54653a8634149..49c6a1f65c493 100644
--- a/arch/powerpc/include/asm/word-at-a-time.h
+++ b/arch/powerpc/include/asm/word-at-a-time.h
@@ -5,6 +5,8 @@
  * Word-at-a-time interfaces for PowerPC.
  */
 #include <linux/bitops.h>
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
 #include <linux/wordpart.h>
 #include <asm/asm-compat.h>
 #include <asm/extable.h>
@@ -168,6 +170,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret, offset, tmp;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	asm(
 	"1:	" PPC_LL "%[ret], 0(%[addr])\n"
 	"2:\n"
diff --git a/arch/riscv/include/asm/word-at-a-time.h b/arch/riscv/include/asm/word-at-a-time.h
index 3802cda71ab7e..fb7e2904dd7fd 100644
--- a/arch/riscv/include/asm/word-at-a-time.h
+++ b/arch/riscv/include/asm/word-at-a-time.h
@@ -11,6 +11,8 @@
 
 #include <asm/asm-extable.h>
 #include <linux/bitops.h>
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -60,6 +62,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	/* Load word from unaligned pointer addr */
 	asm(
 	"1:	" REG_L " %0, %2\n"
diff --git a/arch/s390/include/asm/word-at-a-time.h b/arch/s390/include/asm/word-at-a-time.h
index eaa19dee76994..59393cf065964 100644
--- a/arch/s390/include/asm/word-at-a-time.h
+++ b/arch/s390/include/asm/word-at-a-time.h
@@ -3,6 +3,8 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
 #include <linux/wordpart.h>
 #include <asm/asm-extable.h>
 #include <asm/bitsperlong.h>
@@ -52,6 +54,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long data;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	asm_inline volatile(
 		"0:	lg	%[data],0(%[addr])\n"
 		"1:	nopr	%%r7\n"
diff --git a/arch/x86/include/asm/word-at-a-time.h b/arch/x86/include/asm/word-at-a-time.h
index 422a47746657a..1319e1d87a9c4 100644
--- a/arch/x86/include/asm/word-at-a-time.h
+++ b/arch/x86/include/asm/word-at-a-time.h
@@ -3,6 +3,8 @@
 #define _ASM_WORD_AT_A_TIME_H
 
 #include <linux/bitops.h>
+#include <linux/kasan-checks.h>
+#include <linux/kcsan-checks.h>
 #include <linux/wordpart.h>
 
 struct word_at_a_time {
@@ -71,6 +73,10 @@ static inline unsigned long load_unaligned_zeropad(const void *addr)
 {
 	unsigned long ret;
 
+	/* open-coded instrument_read(addr, 1), as in read_word_at_a_time() */
+	kasan_check_read(addr, 1);
+	kcsan_check_read(addr, 1);
+
 	asm volatile(
 		"1:	mov %[mem], %[ret]\n"
 		"2:\n"
diff --git a/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h b/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h
new file mode 100644
index 0000000000000..000c92de6baf2
--- /dev/null
+++ b/tools/testing/selftests/powerpc/primitives/linux/kasan-checks.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* There is nothing for KASAN to check in user space. */
+#define kasan_check_read(p, size)	((void)(p), (void)(size))
diff --git a/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h b/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h
new file mode 100644
index 0000000000000..39c97bc15531e
--- /dev/null
+++ b/tools/testing/selftests/powerpc/primitives/linux/kcsan-checks.h
@@ -0,0 +1,3 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* There is nothing for KCSAN to check in user space. */
+#define kcsan_check_read(p, size)	((void)(p), (void)(size))

-- 
2.43.0


