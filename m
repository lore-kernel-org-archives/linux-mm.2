Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D47C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:05:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBFB6B0092; Mon, 24 Aug 2026 12:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7ACF26B0095; Mon, 24 Aug 2026 12:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA086B0096; Mon, 24 Aug 2026 12:05:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481056B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:05:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0FD2801C9
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:53 +0000 (UTC)
X-FDA: 85136638986.23.72B68C0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id B174AA000A
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:05:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MzfdHSGU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnnChx9iCPsiFb6C13+bXpD7uMgqURtwnyfYPAvxctw=;
	b=mxXV2KrQ4FgHJ9fIMLDHpZSeE6GJPHQErtuGbvjszz6qlZ59mjMVkpz6BEpWpnSm71KQjk
	eIPzBBh1Xzi3b/8ZBDxjRuco67E5VjUVnD3tIwLE/evbctdRHUskP21UX+epknM6LmiwTA
	EOwI2euivSMWBnOCS7y4ER15lKUpuPU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MzfdHSGU;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587552;
	b=t5c0Mj48lCnrCHRFPzevildz2wnnS948N0Bvupm3MxtgpWH74gR2Pk0cB6xEgYydZ4VXFx
	ZhZYt/irZIyxnSt2Rx/hrQMNfZcUTefLTBYdbZcvKCLKUmEZqaidkgqyrsqWk3VbILt/gg
	EZzV8TU4pIYOzzniQiCExniClw8q6+Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C63FC1756;
	Mon, 24 Aug 2026 09:05:46 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 67FFE3F85F;
	Mon, 24 Aug 2026 09:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587550; bh=z3HgR5JrV87UUef5omwF+7GRZHLLMVnWFEywPKlYZN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzfdHSGUI4MR4hpSZEjGYjwit9tca6UiDVjwbEHbeT9dUPE7UHQ86d+HRFpo98vex
	 uwdglyCvZ9EqcSEXQhaNrCFd3FdwW9vV37RTPRQ7R85BMRMoAFvajoPp1TuM/0tmJ7
	 7w742yIUkmItIqYVPtE8QtBTxCTTT7GLQC3vNQVc=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 1/7] arm64: uaccess: Add batched kernel nofault accessors
Date: Mon, 24 Aug 2026 17:04:46 +0100
Message-ID: <20260824160523.3907021-2-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B174AA000A
X-Stat-Signature: edj9okqteocbhs4jop8uqf3d5jay8xes
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787587551-506517
X-HE-Meta: U2FsdGVkX18rA4YEnMF4TYsph9WNOH0S6/ipj1F9kGGOEx8bs/JrDhS/MOJ1wedfWz4bpaMryYKLq17tpmPuZUb6iVyfqCL/A3f0YceRFIx/8XQjL+hBa17CIjUsdIKAr4PVdSAxipizCP4rgwm6MDkd2gl0sKNxJSfYQR9IkrbJAIp8/povyehuMm+2kmIG28c/FXtemRns5H2TZEB/VVDIf00RTgTw89ONa/wcSQHo/yTU8/yfelWThT/dRq+ObtDHRM4krTftK5Es7us7PV+LkirCTMHV8KnZ+sk888EEIlDDmoweVgmuTiShR+wLnjv7w2H2gd7DgNSUTMVB3GXIt+zLyWOST2IMpziBXx94EwjM9sDmjZluEaz3ZlTZpie0nYEa5prwLuXNN2KN7oq6RRUNr8b/Y0/7Xl0ceEA8Mcte3S11GeDq7SnorbMYsbAMeY/Fn1Er1mk0SPdMqVoEPk2rK0c4NEBuu0TXROez3lGkaLkzKA/aWCDFRYNkvIYkzhdAC41IB1DtUGLjPopQd5vQRpfaD+YJKe6Z8zCL7DgbOSMDqbZ0PI1QnSDxA36m0JmCjxhUpQ0H037wMLFq+O/ZTTkqWg99/f9Yk9mpGcY7so8E38VI/in2JRlZ2hZ99oCu0L+5ixQfdyNbC3GoLy4yuuFI3alVcX9h9kIdDmaQ+FIGxsHZzOj2kHUa1l1UMtMuX824toU1Pvtf7OFT2dnSQ9HsfEPbHOrmYG6gg6WaDmXxgmKGV2nj4RvKfQAOBvDjgwbRqhd0O+bKSClrxODJ+pfJyhZwEWzxUh/H7+jkFqEJzDQ1lIkUCdg8kmMIxOrRzJDqJWvJrgjDx+wTLMYtMRrk647mhWdodrQpPWK8BoF2oTAERG7J5DNbm72Sy5269r6onRhtsqLaMjIp+k0QhO955JT7Ywis24C04kbQOgRSIyOUhVZ4sVh86Ywrgm00Lk/old7sIJA
 fNb2aODs
 xwRooqcuCmog+MfSDSLGWMNtbAZpT2iTS5UC4W1iIKjXDYKvhAurven1+Fl+708yfsoFcgZ0bPsxhy66JcnMmDZWxQfG6kYk5gsjrIrTFtEFjdqkY4GJ+6SgdMW3Kl64405mTPtRVga5qvRKvvowKhX/vZB9xX7/8g3JoY+lNf17DZsA4BabtEBf28L5PIS+LxLAx3H9oywMTkASPj8PaFSr8/ULdbawkJtDZoipuQq5i3fCUtRM7EoXjhC/SgVbAywh8dnov62WTnfPZynOqDLlpirgeiK26nA2O/kHUMDxbrCCEwk7qk2iwmovDfNsrApH1bgnIbxfBOXDZZse6OExN/RBdYWlym3fJJCL9PW90MCLtv3V8YR0CGmxC8jhcW0o8p76l/Z2MfNt31zeMP9K3/C4UsjhTiQ6XzmcUqiPrICt4rZ53IEzogcD/4kYjnGRmeXxuX1Z1MYsRUnWJXe97PsKE/eH6SZq8roGn8AwmzisGrbsIByMlNGiedcDA60IT3LYqyZpIgyIsUPuHf4AB1vDHyyDZKa6zxMCRf6S7LrY1K0SmpQpf9LhUbRZL1aj3gcsS6swErWEVlWmUbvDRN8YSqNqGb4nxhhDfjbrrGOZgWgEIMu5guyl6GYeL5uTTCo1Df/MN7bdbszhTH7tK0mz5BqkYq3hinIvGXgDp1S7dE32TO9SGcvCN4bS/y1NJC7Mj8GejumN7l6jpce+rCXH9dv8ep0FNeRz3AYARHxsbDBycSMdDKE3Y9hJkV4OvbHS4XcjO0j8nUKv4GriM2mijPxBDUT6WgtlAy8uSM3uKpn+dwp9r6YQUBzCGg21GVru81winAw/qXQ837mxCgoDidVvNqFoBH04cbiTMyl9E9Xfuu6V38lsX0KduJwfLzR6gV0HfdTVjrV/mLldULYjPLBcEA4kGGJozZxy24gGcPbLHrK75pqFeytp3jwFF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With Hardware Tag-Based KASAN in asynchronous or asymmetric mode, arm64
sets and clears PSTATE.TCO around every kernel nofault load or store. A
loop pays that cost for every access even though tag checking can stay
disabled until the operation finishes.

Separate TCO management from the fault-tolerant access and add begin and
end hooks for callers that want to batch several accesses. Keep the
existing accessors self-contained, and provide aliases and no-op hooks
for architectures that do not need special handling.

A context switch re-enables tag checking, so a batched region must not
schedule. Continue to evaluate accessor arguments before overriding TCO,
as those expressions may block.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 arch/arm64/include/asm/uaccess.h | 71 ++++++++++++++++++++++++--------
 include/linux/uaccess.h          | 16 +++++++
 2 files changed, 69 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 9f5bd9c69c249..1a14eb2a51dce 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -270,28 +270,43 @@ do {									\
 #define get_user	__get_user
 
 /*
- * We must not call into the scheduler between __mte_enable_tco_async() and
- * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
- * functions, we must evaluate these outside of the critical section.
+ * Nofault load without TCO management for use inside a
+ * __begin/__end_kernel_nofault_bare() region.
  */
-#define __get_kernel_nofault(dst, src, type, err_label)			\
+#define __get_kernel_nofault_bare(dst, src, type, err_label)		\
 do {									\
 	__typeof__(dst) __gkn_dst = (dst);				\
 	__typeof__(src) __gkn_src = (src);				\
 	do { 								\
 		__label__ __gkn_label;					\
-									\
-		__mte_enable_tco_async();				\
 		__raw_get_mem("ldr", *((type *)(__gkn_dst)),		\
 		      (__force type *)(__gkn_src), __gkn_label, K);	\
-		__mte_disable_tco_async();				\
 		break;							\
 	__gkn_label:							\
-		__mte_disable_tco_async();				\
 		goto err_label;						\
 	} while (0);							\
 } while (0)
 
+/*
+ * We must not call into the scheduler between __mte_enable_tco_async() and
+ * __mte_disable_tco_async(). As dst and src may contain blocking functions,
+ * evaluate them before overriding TCO.
+ */
+#define __get_kernel_nofault(dst, src, type, err_label)			\
+do {									\
+	__label__ __gkn_tco_err;					\
+	__typeof__(dst) __gkn_tco_dst = (dst);				\
+	__typeof__(src) __gkn_tco_src = (src);				\
+	__mte_enable_tco_async();					\
+	__get_kernel_nofault_bare(__gkn_tco_dst, __gkn_tco_src, type,	\
+				     __gkn_tco_err);			\
+	__mte_disable_tco_async();					\
+	break;								\
+__gkn_tco_err:								\
+	__mte_disable_tco_async();					\
+	goto err_label;							\
+} while (0)
+
 #define __put_mem_asm(store, reg, x, addr, label, type)			\
 	asm goto(							\
 	"1:	" store "	" reg "0, [%1]\n"			\
@@ -366,28 +381,48 @@ do {									\
 
 #define put_user	__put_user
 
-/*
- * We must not call into the scheduler between __mte_enable_tco_async() and
- * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
- * functions, we must evaluate these outside of the critical section.
- */
-#define __put_kernel_nofault(dst, src, type, err_label)			\
+/* Nofault store without TCO management; see __get_kernel_nofault_bare. */
+#define __put_kernel_nofault_bare(dst, src, type, err_label)		\
 do {									\
 	__typeof__(dst) __pkn_dst = (dst);				\
 	__typeof__(src) __pkn_src = (src);				\
 									\
 	do {								\
 		__label__ __pkn_err;					\
-		__mte_enable_tco_async();				\
 		__raw_put_mem("str", *((type *)(__pkn_src)),		\
 			      (__force type *)(__pkn_dst), __pkn_err, K);	\
-		__mte_disable_tco_async();				\
 		break;							\
 	__pkn_err:							\
-		__mte_disable_tco_async();				\
 		goto err_label;						\
 	} while (0);							\
-} while(0)
+} while (0)
+
+/*
+ * We must not call into the scheduler between __mte_enable_tco_async() and
+ * __mte_disable_tco_async(). As `dst` and `src` may contain blocking
+ * functions, we must evaluate these outside of the critical section.
+ */
+#define __put_kernel_nofault(dst, src, type, err_label)			\
+do {									\
+	__label__ __pkn_tco_err;					\
+	__typeof__(dst) __pkn_tco_dst = (dst);				\
+	__typeof__(src) __pkn_tco_src = (src);				\
+	__mte_enable_tco_async();					\
+	__put_kernel_nofault_bare(__pkn_tco_dst, __pkn_tco_src, type,	\
+				     __pkn_tco_err);			\
+	__mte_disable_tco_async();					\
+	break;								\
+__pkn_tco_err:								\
+	__mte_disable_tco_async();					\
+	goto err_label;							\
+} while (0)
+
+/*
+ * A context switch re-enables tag checking, hence the no-scheduling
+ * requirement for a bare nofault region.
+ */
+#define __begin_kernel_nofault_bare()	__mte_enable_tco_async()
+#define __end_kernel_nofault_bare()	__mte_disable_tco_async()
 
 extern unsigned long __must_check __arch_copy_from_user(void *to, const void __user *from, unsigned long n);
 #define raw_copy_from_user(to, from, n)					\
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index eddbbb65ccc4f..7ae1854673471 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -637,6 +637,22 @@ do {							\
 
 #endif  /* !__get_kernel_nofault */
 
+/*
+ * Architectures may use the begin/end hooks to establish state shared by a
+ * sequence of bare nofault accesses. Every path out of the region must call
+ * the end hook. The region, including expressions passed to the bare
+ * accessors, must not call into the scheduler.
+ */
+#ifndef __get_kernel_nofault_bare
+#define __get_kernel_nofault_bare	__get_kernel_nofault
+#define __put_kernel_nofault_bare	__put_kernel_nofault
+#endif
+
+#ifndef __begin_kernel_nofault_bare
+#define __begin_kernel_nofault_bare()	do {} while (0)
+#define __end_kernel_nofault_bare()	do {} while (0)
+#endif
+
 /**
  * get_kernel_nofault(): safely attempt to read from a location
  * @val: read into this variable
-- 
2.47.3


