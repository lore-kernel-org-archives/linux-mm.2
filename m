Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A531CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0638E003A; Mon, 10 Nov 2025 11:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6605A8E0003; Mon, 10 Nov 2025 11:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5026C8E003A; Mon, 10 Nov 2025 11:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6428E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:36:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA09B85A63
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:48 +0000 (UTC)
X-FDA: 84095251296.19.7E3ACBA
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id CD7CA12000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:36:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXf7SqLi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792606; a=rsa-sha256;
	cv=none;
	b=MxeNpsHE67LT6v508046DSDObOrjKQJdoNGPbToUrgX0fMIhOql4s2NI4Wv66zx861YC/d
	Rf4uJjsAokC4BO6QI19nhq6ssSlzv6SN6h/4Vwh2IaSn89ndE6tT1kJaBcjNxAde+FG/H3
	xeFbqLqI7FdEK/rrC/c6yRY9bgZT/YA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dXf7SqLi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
	b=tDEatZIJRPA7bcuWXXnMey0h9o2O4PmugnArb4b2dNstHWsRswmEma8h55DOahm9KEZFOi
	se9irPsrWdMgjL23NflgSIj2ze+fUUKxOBcBiu1Rdj/80mkxe2JWYvWjp7UpyUJNcw7bV8
	KXwYBvwW64DTZxMOsKJgZ4cc/3nwsK4=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7a59ec9bef4so3560235b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792606; x=1763397406; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=dXf7SqLiBuesJBeLzWWSkHTn5NzHxxxSLq1T5XupBgXlCKxnTDND1rKAvCbceAiukM
         Z3LG3XYB3nbUbypzSR0W7DUtPKD7CU8a4YIhqZ33ZIKmtaONxRSpdpHyUd+vH88Bro9y
         0gVXDN4mFdtg+bZsgCo5jVHuOysRlF1B9ebFTopeUeridmoBQ0WsbqsIFWlsqNDXidx+
         DIKRqEL+0gaP7XPJl4Wc1diLrDnSmNbxxmHxOLE1MRTNGj38izkmV755PdoDAnmx8UZS
         1TSnUixW3AvG52pfAwIO9iJO8muCpnpzYE8d+1q4WPZ78V17SJZyQKekMMm/aftSwPsr
         D0uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792606; x=1763397406;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kk8QwiK6ueKhbPm+iybiDp/pMjWX1cNh1XEGnvIxiQI=;
        b=i5vIGOJV88wbeTSQbRJSlEBi2Wmq2C/s4KYuxrrFz0xJFecycq7EKMf3iIDAKXswSP
         PcnmCYCfEFudq5XuRl9cQGQCHNiaWcwknIUTD9+AUX2Z8yaJMfRf7FI+fnJ428KJuLhV
         Rof6OCZsqAc7KcKIdLhUYUIIEdNMUy5HQ/hjJkoy1LFqjU3CSWCMJxiSXU14ASVH495a
         BvRCY3GiZ760K322x/6n7doj53dKLneLg2ec6fYhpGOHVFflyMBXbRk60AsGrdwuGBiC
         PvEn2gEIcKy7Pho/LpvxgVy0t/x5azNCG+dtpsGZBPBAWEu8sjxP1oqveNwW3bN+NgdA
         jTbw==
X-Forwarded-Encrypted: i=1; AJvYcCWJxY/PGoS3NLGsW/n0fyrSv+7tPEaaOF90w3SGrtrDE7sVNZM6++0XHYuQljyWEiDO3vaKqoch6A==@kvack.org
X-Gm-Message-State: AOJu0Yxn3013UrgVaQMxun4yH5up6KRbs0ET9/tf8T1BUJ0lM4mKzIaL
	xyv55Kl9G9WBcbKCYgB0+y1Dh6DS1dWbeZINQp7rbsGppz6EE6yB4B1i
X-Gm-Gg: ASbGncuGmAUurEvSNziwqRx+yRSUHVY/EP5IOK40SQCDTOED45mycFaOfy/1fiXisNk
	oZujmk6lmbXsU+ki0Qxi66LmSm0lOBG2h3SQoEMBGB7QBxuaP64FKiKO51460APkMRHxgpssHD2
	WP0ryWBNhK44oZdbEOXJ0MhP7Jkw/xj8YD3DWK01TgisD4chVn28nBId0QS0fRxfu/NgZqsOKde
	Gz60yRP9TDHmVnonI1F8dYsUWoE2VoL+MbT527rMZwvGZJfsNvTJEhY0O0mIIqCVSwWaarWeKWL
	O1A4NqZcfRZdF1/1MQ8WJW1Et25Xz/omy7sDaxfyxAWntR8VdFZCASwBOS+yapXJxdpMv+OAfow
	OSL7nLE7BQ5gr85G3wbs+CZ+UsAwVKJI/EhfTHxpVLFeeOSqHxtJ/e+TLzWiori5ZipnybRn8JC
	Yi9GeVplenGrQ=
X-Google-Smtp-Source: AGHT+IH1f+r1UrU5gIs1h7VugOnmhHceXLBGuSuO4vWp4ORB3huGtoQpeyNaf5f88WRoFNvTTkca/Q==
X-Received: by 2002:a05:6a20:6a06:b0:334:a901:c052 with SMTP id adf61e73a8af0-3539e635fd9mr11647011637.0.1762792605556;
        Mon, 10 Nov 2025 08:36:45 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ba902c9d0d4sm12765118a12.36.2025.11.10.08.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:36:45 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 01/27] x86/hw_breakpoint: Unify breakpoint install/uninstall
Date: Tue, 11 Nov 2025 00:35:56 +0800
Message-ID: <20251110163634.3686676-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CD7CA12000A
X-Rspamd-Server: rspam07
X-Stat-Signature: 7q5848myxp8punhkd7gdd4umy5ck43cg
X-Rspam-User: 
X-HE-Tag: 1762792606-259944
X-HE-Meta: U2FsdGVkX183aw3nrsWDdMMw2wrxCUOS9A69VDuLCXKb+fdck2EmQdKwjfRnlj3oIFy21g4SEGTbh0V4Vdtkmo4R1KiN/ArXnw9j8+vMspDSkPwufJ6FYKcvEQoKwMmLoTo8jksar0WPw31ahAr0bvgFVvCeX4mcr25yUdEARilBLf+pvJmxskc6WO1cABWdbBMQV6947ZuDSpZCPXmTjWVGY0Drh4lnT9b5EMO6bqitHjPS9cO7Iv+01x00TNKCF0apbqlzHFojkv4ENNUX151uHO5Ryc/i5gpuL6SEI0C7SCPzXmO1WIJGK0kKpY0Y5clj9Vm1rBAGVdCFXnVVjOlpDAalgNsiuRcJ05uKSYDWWUhAp9zsQW10Wcr/OGql3PgXhxzuGgKHXtmc69JstZzs4tO9BM4eXwxEHEgB+tYpb+QXKQw1h5pG0nI8a0GrPjKBi/ITSPy0x9OGpdRXTMMNLY2AVhGkmolEA+xQcguQK/1f63+BhE3wA7TZwu/mLXhhOsBfJolbZmKdRkW0v2zs33owkSMEZMlV3oFSsXWLjQRWSmDGVJXGOsDiElzkPT9oUg5O0Ko+9P7nrQV0jgDlAOM/cNcUlUmkl9XQSseHdEV+zJxt4GOS2t3Vv0uUsYRnJKalqM1NU+vP0aHc/Z4Zhpf7huZN+E/7IcmQRHlxxTjLvay5VtFi9cVlm6jHSsl1peBeM8ACgddCvKcgD6uwqPG17yJ8QWWQnR6CfY1KCVnJ1f0gN/mw2YWMgGsGtagdzuFj/OywFHO4qQrxfOPUaxNsx2naL4RZD0N8JkLe84Pui34m5rNqBsugY1zz3fJsaXKnwwh6W/zR6q+jgnA8a1FiAgGK1FW8AR5rwdQCvhh/MPRapHMO9ZRWs594koyaT2bo/q0M1DIGPU9HUe2lCV1yp+aURj0ohXYdg9d27tGSrjDOgF0GM4HW7an8oZ6+jK0Irh6kk9H5NBk
 mR9b9ltV
 5Gv2aAKURIP9o5phjMYP00e+G1LH+fWKmONuYgyWWXXQbbSOf/D9MZ1AwatlHtLOQOdpihoVifvNk33Ik197klZi683eEJayCZgLT74D3MskAg4weHVH3NlZ9NVh8gUVSDXHgXwQrpm66pBcRM7S02L4js5i2AVmWzJ2LKXcG7tkNTwFUHSEo9ykemHp8oEVpZREeRbm19KOw/paiAK7REjKktJQga4yOf4GqDh04zxct7v4Y8uf6mDvrY4XbR1+ePUctaR/cCB/IzpQ+yiFOSnzYsVgbKrP5r0uVaoQj5ZPesUwd8wAhJYwlMIGZtTvjuA1EMynGcFieKlY9VsgKO8rdFrEG4WUjRRq3JXJClcDFw4ToEN6FkiTRXEwV5H7vJT8sbZr25YIrj+TF4eTOwMk5YSKak+/H686YN0UYImA5bqwtZ0boROSIJluJuUlWAW8l1warNgEZbdJYfTFtnVMwtQNu+6fZDFvgwpYhG7KBGa7NpiG3uYGecqWIJH5TuKj1HL9PM4NAoK3m7IT1E6HI8lo3NjvyDc6H33+cIoTqVGw+PbwRlPjXI0iNQ9MajRipwDdVHU0XSBxYPcT843oMhQewyD3Fe3TowvJWrKHKHLvYu5ucaXISkGSvWsgaiFYX
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


