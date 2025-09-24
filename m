Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E93DDCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 11:51:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4890C8E000A; Wed, 24 Sep 2025 07:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A528E0001; Wed, 24 Sep 2025 07:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301798E000A; Wed, 24 Sep 2025 07:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1AEDB8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 07:51:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6922C04AA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:41 +0000 (UTC)
X-FDA: 83923979202.25.3A588CE
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id D6199A0006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:51:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PT4FkMix;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758714699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
	b=3r5uAgtyts9E3S60Zm47+TK87FmIYA5jR9ehjelaaNMglKVSSLKwaOQD1u7YnvlLuATzwI
	UukCSkPDCTupu8P+U/ZrjPRg0nlgL2i55H0JLuVVETtlmKii1DYtgLC58qvJES8QpPS3xi
	8BxdVZUT8ARBQzgDX9sd1psFax/GkOk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PT4FkMix;
	spf=pass (imf15.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758714699; a=rsa-sha256;
	cv=none;
	b=CZtkrbL+Jj9X3iIYgkzankS5jpUydgTqKB2XRlIHjj6BPwpMPz1u0OhgUbYE6rucTUT8ON
	qXnbJmxPXYY0W2kvchBQekRjZ7CuzlDGeMD9GtJA/tt50V+PsNvqJm39t0dKwI0dgVDW/f
	8h8obIWJjU8SGl1XZmJbtF1w/7s8FUs=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b550a522a49so5858359a12.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 04:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758714698; x=1759319498; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=PT4FkMixbAkRcKoPFJjPqOTdVd2xiLCtoAAdn0CNH365Pow5UatEJc06ks88xnk5sb
         t8xC6k696ytyOQCKRCYk/9hF7gCB09S1XNFiB2ZfXKLiEAoE/k43ZWYlcjAWQYkGf0WI
         cRFWc33RyT8SrH2QcNgnfTRiZ8SHWisFeng20cXC44BNUSSeZRC9Hna8NkhjD77V7otB
         N3R/DKlDBjms+/yMmR95fw4tcGcqRodtTO11uvkfaX6mO5zt2b6DTnMNeSiWXdRZsQop
         2LbBzm+1reG4isc9oe6sSg2mA1jUtf629iCYyO8egYHaTjWYC+f0u6scxhHEA86z9dQt
         d0mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758714699; x=1759319499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=dVdkThvyA5NQcVwAlhTKMeFyjFZ+88NlF0rXXV6fnAUuANDskjlEP2v3nxaeOxy12c
         g97+ozOSxgJGCorke0yxDaMPND1HbQt2baquVPmyfFZm7TrOup7eFNFlsPO5SsaBNkGX
         JWgvpTiDjZ4PePqyfqypUHpKE+Nbg5aZIW7fE82dyuTFRIyEbFUrT48bvu+tO+dDpcWi
         md8Om2Iaaymi7yrFpr07TnN/lGs4lZhFCUroUTwuR77rYmFqWxFJ2l658ng9cOwGrBmx
         u/GdcyihCU9UMHGSNRE+qvB5sYRk4R518dffsWacbg2MM3Tv9Sd1px82jBfDymgFQAxk
         ABhA==
X-Forwarded-Encrypted: i=1; AJvYcCWFUkBdk4+L4KgrVpl2zIIrKm7xvEt9b3Cv/gyHo7c20Pp18YaSuR77ZiZpkpnp1SVAIoncR1sLcA==@kvack.org
X-Gm-Message-State: AOJu0YxEF9Gl+ds8BxjoNFvaQiLwRjfEuCeygaGmGP2/FS58F4KVhVfc
	5Xml1KjA9MR1ZHUVCeMbL/VbVFeRDG32L/sq5iC53ezWeVAptpb1ewvH
X-Gm-Gg: ASbGnctcQI5LIQIYz2aiRX65xRCUwMYLnQZJifV9/d2jV9nYoMDQrBR1s0yi5IPED/G
	9K+G420m1g62SULwoyNRgH4hq597sLIMybwZqBic+/gT1iKbEoMEyDIx3gFdJ5hKLeDb4iiIUuK
	ee2gnJcUVCU3Pt7zhyHBg98M/op3Jb7dj5dQOeQJudAfn1bn8kCKWVq381WMFiOmnCVHIQZW0E6
	9XyvtjxHY5eLT+FpsVK1vI1AE1ReNKVI3872pfVuxV/Jk73lhMbVwBWLJN4d2LHdbKxTCUMvKhl
	6PtlVcPwJvhHE+zAZ1nWGhjhGk4p1YUNmetHcynvvqvO6Xl+24kScD4ALED8qpeWuwdAsLbTigG
	gsliwz2U0l0D027Mecozy3dljzA==
X-Google-Smtp-Source: AGHT+IG/EKwaM+3gU157JNyS6wHErjZO6bA9JznZI6WJMDF06Hw4cNxGz96VpIRBiZT5EDGg8kv3BA==
X-Received: by 2002:a17:903:2ac5:b0:24c:cb60:f6f0 with SMTP id d9443c01a7336-27cc836c460mr70569105ad.58.1758714698477;
        Wed, 24 Sep 2025 04:51:38 -0700 (PDT)
Received: from localhost ([23.142.224.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-26980310ff8sm185687145ad.110.2025.09.24.04.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 04:51:37 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v5 01/23] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Wed, 24 Sep 2025 19:50:44 +0800
Message-ID: <20250924115124.194940-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6199A0006
X-Rspamd-Server: rspam05
X-Stat-Signature: y846nnp64bcd41i1ykf6k7xew4dsny39
X-Rspam-User: 
X-HE-Tag: 1758714699-147375
X-HE-Meta: U2FsdGVkX19J3qGetZqu3uy0PnbvMTRhDlfCJYNMZRP3gZk2Ug6smmk2GIKoCHfGv10upmQ8QmcGWCgWuIfinHOMGPuZuAe4RQ6GR357nVRtegJmRqFcE1WBjwths2ScK6GzRSwvZRhx56XJFvPp1Op1YVn5XhDhFOl7UsMO/6mxODiu04FDANWlBc37jyO+zUGsap8UsMSFbwGmoF4l0iPhPtzKn/JQA4fBPpud89+fQe1dEfbECUPb1kC9YLLofDL5msYIoRRtHs1AJXoO9veIMo0kUieb141Ay+3wGVtXwYEeFwAbo/Nl7Z2go3X2AVNJyMloOYERr+bvcRzQRsUapZK5amQd5x0VQU/3TWmjrx3vQHd25XSVzTPKJAOX5d3RcItN+SngJUonEbNwi4jp5ZrDE263O42boHyUEqi8rFRr8T8fIXGjy8tC/J9Z9lop/ntIIb8ZkKIVt5HUNOyUPpczeVvAZv+stmuQePCEkqtHtu3E/30lw1501laETALs1TDZoM24AYUXyolGqU+QbNT/lSqISN6M2w+RUAeKOqaYK9i9Ej3RkPjFr0yJCJEk6QwRJswNdiuDBmm3Q4yTL2kuikLyaz5V6peHLdyjJlK5grv/SgwMNQBWRynDXuPQGvT32wxaDIXp/uIZ/ZUu3psaspkukOYbI85hFYE6eziWwalPmR3o5vJgNsT4JLIret5wx6Qjfh6KyMy6bTjYR/QhSI4O8X8HOGD1+/xjpsVMF1eeiGBav2ftf8MNKhyFUPb9W7rBfGXm37V1ZL++KnDibI6HCEAHRm9soMvJYYl788BFnSyxTSlo7c4bFgax5bEhs5KxfzuQCvsMrycOVR1tpxtiNHot0RLD/rC8YR64XVtnrUa3GjRgPIj0hO1z+nnJh55f4XrIA2XgkK+HfuLnN9PhBEp3LstMCgG/mUBl7uZ+h4X9jT4cWBaP6gLI3uZDDC2lgpD1F0c
 JgAXWV4i
 c6hOx5fLnj2bi2oXXOjzijrzN+iHUtB/u7ZkqlmizfpR+cRVcuJCiuoCXizpVi45BA/qTrghJ5d/YBDbcewNsBYJiGC9chrVXoTE1zKThlZJlDmF1w0+y6NBX+x3Jdr0vzgumcFavazZSI3+hsobpD8Vh9N3p86Ltn+Aqjqad4eeZBcxiav6XOyM1UFDDmhpqF6BfXo72FuJX9OCL1Cqvnbby3AfSIWVeN0vcWiHGP05bJp89wJCGKqhmNKqN5W7OOwo/XF7LwThxl5aIuOIrDE81SkMfGTDUH8DNn+/iwfpIAflYvuCpmR4tSl8mxdBCXgYXIgYePWCgtLoNocysrm+61d/IDBxAsuKwZvuwys44N7xhLIYyHgkmdWc10CEi6cqlDYvoJ3V9W7G5gMRLgaUp+zpifAKzu/arSV1rgJn8KO5H+oRYyhhD2WwTNNhd5U5zYGDZXA56nhaFAe3ahaK7ReIchOD8WmejCsRbV7S+Twvr5UoQTX4sbETqQ7dvFrCT+hv6+xo5Ybv0WgbKvCICdMQBCl27O+U3QqXc5OnAzjG3+axyJ3yYZciXHlh16DB0xZEnskw3cInmvdBhmWNHA+WB6XO2z/TfWnZQUFW2LfYzQdtFrpP5TgjP7xzFjeYZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate breakpoint management to reduce code duplication.
The diffstat was misleading, so the stripped code size is compared instead.
After refactoring, it is reduced from 11976 bytes to 11448 bytes on my
x86_64 system built with clang.

This also makes it easier to introduce arch_reinstall_hw_breakpoint().

In addition, including linux/types.h to fix a missing build dependency.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
---
 arch/x86/include/asm/hw_breakpoint.h |   6 ++
 arch/x86/kernel/hw_breakpoint.c      | 141 +++++++++++++++------------
 2 files changed, 84 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/hw_breakpoint.h b/arch/x86/include/asm/hw_breakpoint.h
index 0bc931cd0698..aa6adac6c3a2 100644
--- a/arch/x86/include/asm/hw_breakpoint.h
+++ b/arch/x86/include/asm/hw_breakpoint.h
@@ -5,6 +5,7 @@
 #include <uapi/asm/hw_breakpoint.h>
 
 #define	__ARCH_HW_BREAKPOINT_H
+#include <linux/types.h>
 
 /*
  * The name should probably be something dealt in
@@ -18,6 +19,11 @@ struct arch_hw_breakpoint {
 	u8		type;
 };
 
+enum bp_slot_action {
+	BP_SLOT_ACTION_INSTALL,
+	BP_SLOT_ACTION_UNINSTALL,
+};
+
 #include <linux/kdebug.h>
 #include <linux/percpu.h>
 #include <linux/list.h>
diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index b01644c949b2..3658ace4bd8d 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -48,7 +48,6 @@ static DEFINE_PER_CPU(unsigned long, cpu_debugreg[HBP_NUM]);
  */
 static DEFINE_PER_CPU(struct perf_event *, bp_per_reg[HBP_NUM]);
 
-
 static inline unsigned long
 __encode_dr7(int drnum, unsigned int len, unsigned int type)
 {
@@ -85,96 +84,112 @@ int decode_dr7(unsigned long dr7, int bpnum, unsigned *len, unsigned *type)
 }
 
 /*
- * Install a perf counter breakpoint.
- *
- * We seek a free debug address register and use it for this
- * breakpoint. Eventually we enable it in the debug control register.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * We seek a slot and change it or keep it based on the action.
+ * Returns slot number on success, negative error on failure.
+ * Must be called with IRQs disabled.
  */
-int arch_install_hw_breakpoint(struct perf_event *bp)
+static int manage_bp_slot(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long *dr7;
-	int i;
-
-	lockdep_assert_irqs_disabled();
+	struct perf_event *old_bp;
+	struct perf_event *new_bp;
+	int slot;
+
+	switch (action) {
+	case BP_SLOT_ACTION_INSTALL:
+		old_bp = NULL;
+		new_bp = bp;
+		break;
+	case BP_SLOT_ACTION_UNINSTALL:
+		old_bp = bp;
+		new_bp = NULL;
+		break;
+	default:
+		return -EINVAL;
+	}
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
+	for (slot = 0; slot < HBP_NUM; slot++) {
+		struct perf_event **curr = this_cpu_ptr(&bp_per_reg[slot]);
 
-		if (!*slot) {
-			*slot = bp;
-			break;
+		if (*curr == old_bp) {
+			*curr = new_bp;
+			return slot;
 		}
 	}
 
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return -EBUSY;
+	if (old_bp) {
+		WARN_ONCE(1, "Can't find matching breakpoint slot");
+		return -EINVAL;
+	}
+
+	WARN_ONCE(1, "No free breakpoint slots");
+	return -EBUSY;
+}
+
+static void setup_hwbp(struct arch_hw_breakpoint *info, int slot, bool enable)
+{
+	unsigned long dr7;
 
-	set_debugreg(info->address, i);
-	__this_cpu_write(cpu_debugreg[i], info->address);
+	set_debugreg(info->address, slot);
+	__this_cpu_write(cpu_debugreg[slot], info->address);
 
-	dr7 = this_cpu_ptr(&cpu_dr7);
-	*dr7 |= encode_dr7(i, info->len, info->type);
+	dr7 = this_cpu_read(cpu_dr7);
+	if (enable)
+		dr7 |= encode_dr7(slot, info->len, info->type);
+	else
+		dr7 &= ~__encode_dr7(slot, info->len, info->type);
 
 	/*
-	 * Ensure we first write cpu_dr7 before we set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 * Enabling:
+	 *   Ensure we first write cpu_dr7 before we set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
 	 */
+	if (enable)
+		this_cpu_write(cpu_dr7, dr7);
+
 	barrier();
 
-	set_debugreg(*dr7, 7);
+	set_debugreg(dr7, 7);
+
 	if (info->mask)
-		amd_set_dr_addr_mask(info->mask, i);
+		amd_set_dr_addr_mask(enable ? info->mask : 0, slot);
 
-	return 0;
+	/*
+	 * Disabling:
+	 *   Ensure the write to cpu_dr7 is after we've set the DR7 register.
+	 *   This ensures an NMI never see cpu_dr7 0 when DR7 is not.
+	 */
+	if (!enable)
+		this_cpu_write(cpu_dr7, dr7);
 }
 
 /*
- * Uninstall the breakpoint contained in the given counter.
- *
- * First we search the debug address register it uses and then we disable
- * it.
- *
- * Atomic: we hold the counter->ctx->lock and we only handle variables
- * and registers local to this cpu.
+ * find suitable breakpoint slot and set it up based on the action
  */
-void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+static int arch_manage_bp(struct perf_event *bp, enum bp_slot_action action)
 {
-	struct arch_hw_breakpoint *info = counter_arch_bp(bp);
-	unsigned long dr7;
-	int i;
+	struct arch_hw_breakpoint *info;
+	int slot;
 
 	lockdep_assert_irqs_disabled();
 
-	for (i = 0; i < HBP_NUM; i++) {
-		struct perf_event **slot = this_cpu_ptr(&bp_per_reg[i]);
-
-		if (*slot == bp) {
-			*slot = NULL;
-			break;
-		}
-	}
-
-	if (WARN_ONCE(i == HBP_NUM, "Can't find any breakpoint slot"))
-		return;
+	slot = manage_bp_slot(bp, action);
+	if (slot < 0)
+		return slot;
 
-	dr7 = this_cpu_read(cpu_dr7);
-	dr7 &= ~__encode_dr7(i, info->len, info->type);
+	info = counter_arch_bp(bp);
+	setup_hwbp(info, slot, action != BP_SLOT_ACTION_UNINSTALL);
 
-	set_debugreg(dr7, 7);
-	if (info->mask)
-		amd_set_dr_addr_mask(0, i);
+	return 0;
+}
 
-	/*
-	 * Ensure the write to cpu_dr7 is after we've set the DR7 register.
-	 * This ensures an NMI never see cpu_dr7 0 when DR7 is not.
-	 */
-	barrier();
+int arch_install_hw_breakpoint(struct perf_event *bp)
+{
+	return arch_manage_bp(bp, BP_SLOT_ACTION_INSTALL);
+}
 
-	this_cpu_write(cpu_dr7, dr7);
+void arch_uninstall_hw_breakpoint(struct perf_event *bp)
+{
+	arch_manage_bp(bp, BP_SLOT_ACTION_UNINSTALL);
 }
 
 static int arch_bp_generic_len(int x86_len)
-- 
2.43.0


