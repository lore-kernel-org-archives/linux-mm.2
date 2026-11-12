Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04C10606A896
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=fG0Y1uuO
Received: by kanga.kvack.org (Postfix)
	id 1E0B76B05C4; Thu, 12 Nov 2026 05:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8736B05C5; Thu, 12 Nov 2026 05:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080AE6B05C6; Thu, 12 Nov 2026 05:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7A256B05C4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:43:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1497D1604FA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:12 +0000 (UTC)
X-FDA: 85426129824.27.61AC0DB
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0B2861C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fG0Y1uuO;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480189;
	b=fR/B0XKt8dz4I53OVbK8T8AmWoM0C6frcK7b/5/+F0fnHUI1azd5Nw56lvtD/AwFQTVzHC
	ZHA8ivDK377C5zDTSX/8SnjhwEOEb+bDUugTGFP3Y2UKmvNqj/kF3uW0Pe8S0IADYeOamQ
	ik52yWsJsw0zshnCu/bJAkDDBlJtnls=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fG0Y1uuO;
	spf=pass (imf18.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FW2hvTJ6oKMdB56KMNh0AgfhMqiRWnu0NMMSe8aH5CM=;
	b=bR1gZ0BR6XkY9XMIPYZLOU+ylXYniAdB1ESPOczBCCq2FUAt0aSpkZnnqPFrYmQ+XEoBcb
	+2LDkGa++uexVCyOE7W8UiiJEQd5/aArtbdyUrE5BsZiVwSQhMlI7HQiRQO9sI3G533fZP
	M6gK03cuGfi79QOe9xcC5HVX1bQRDPs=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36a315ed211so776772eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:43:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480188; x=1795084988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FW2hvTJ6oKMdB56KMNh0AgfhMqiRWnu0NMMSe8aH5CM=;
        b=fG0Y1uuOs4EsxzUBh49cnxm+SNszVcJSWaIGHgTepxBkEPSRy174uqZqwRenYHbG7I
         A3wYL9fPrmTk+SPLkQzlo+J14oZAE5APYzeDHurY+kNgSs2c8WoQSJS4f0LJZwvmniSM
         jdLxwjEBE1ikF+2f+XUKpBp0ulFe0hQJJ65kh3U2rddm4zn6Ppv+e586+TlXhCrSuM8p
         NdPLM/t/1tsA0gKkTZzUBHVZbz32KPFsQRiLEh32JNUBF91Sms/4JVUCZUykg4ps69p6
         ewvj3uwMQiYfR/NCnLLZ1KZBbAdJYsElwyURf9xzo7R9lNOxNfAjrt2GwJYshq/yyNTP
         QeCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480188; x=1795084988;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=FW2hvTJ6oKMdB56KMNh0AgfhMqiRWnu0NMMSe8aH5CM=;
        b=Cys+5zluTi2LDWgFiDQutFFYPiN7Milj4uEIlkxh2PIZnPKpASYozJFMszDDhhJf8z
         kwHBlw3UZQmo41qjcZtn/ixceHseSj7LDQD4RUlxxJSN2IQhSiVERTSdYsoD6OoSfAZo
         HZd0CYtT9VL9li5vfOgppCJqGZJlU4iIffIfAwjrmnA5Ml4vbcCMsv8fIdDHW9XzONUS
         0i3jXBuB1y0rmnqsWi+EL0aSwHetpROro7/hx17MmK9MLoCZYhjuaDsfEjzB2CQyCHXG
         BOqWHNGpP8haSlJMf0jIPOCtWrpoC1Asft5T+8SXqHGd1TjiW7H1OCiQuDEG3CTXWdFB
         qSYA==
X-Forwarded-Encrypted: i=1; AL+hErEij6wOOWmh9z8/D3p2NZTEnAWfx2ArsGG1IK5yrAYnsJqORQqhrRqdvb/zaCcvpcB6yy6Tj7SrVA==@kvack.org
X-Gm-Message-State: APuU4Z8a4niCfJlzm9OTDwP9zeKx5ID1gN0zyjk67jM9pAM/IXK6bLs7
	6y7mA4Bvu/DuYqpqcfCq4C4GD8QTTw7u4tS2y8l4ROwWO4Rz6fIPpl/csTS18teCjF4=
X-Gm-Gg: AYBFou3gcPHZM+JH1p+C81X0bT7x4bP/qc3f/xttzTvA9C9qrF+RpZ5ClohSzV+vYdQ
	GDX4pRewL7YFKZvAe6MyJoBHO5fc0ugLhT8AYSX16sE5srDsPgR8H3bLzkoTYQk7u2T/Psyjujt
	3li7gjxRWdg+NO1zzDS2muGJh/azh6fyKvEFbXjk9PriF+DBV0k1y6qiBsawVNB8Q0VoQBNy4n1
	6Hi2CU5vYaaGLTTnbuq3sY0I+2ik1kLP66H97DZ7aWeUZLJSVef2SvX2OTV1bHhbYy/eVOGsMBw
	bWiWa5KhQHfkqew+YHAz7mnb132n45Zv7xih20JkQ4rX5I1thRfBrTtFXvmxekNzhyDZ5rlfWpB
	z8RvTdGNdYI3WdHRK0j2eZU/jhWPlnY4ufQ+YVSA7oquICAK+XFXY0vuY97Z3Vn2pgD4BnKEkdh
	MCmWqf5LX4HXrsxJGVjC3nvgx2+aFvOygOOBg1tCfndybRlqFpLeOzNQyI5HyQkOn8Egz3G3SQ0
	RS093VRqlCuA2YsXzDzv0VonUtm4wcYuZ41/kq2KexPoOaq4gJ+MA1joGb7+sFSd/Yz0cPrlJwx
	SY0KNc/nvey13yWa3C8Ka2u2CKMkaAx3mUWwlkeP5apelMIdI0JYXttDyzUCPzz3hDg=
X-Received: by 2002:a05:693c:639a:20b0:358:c5c9:2661 with SMTP id 5a478bee46e88-377dfd840aamr1856019eec.10.1794480187470;
        Thu, 12 Nov 2026 02:43:07 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.42.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:43:07 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	oleg@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	broonie@kernel.org,
	cuiyunhui@bytedance.com,
	dave@stgolabs.net,
	david.laight.linux@gmail.com,
	jszhang@kernel.org,
	tglx@kernel.org,
	conor.dooley@microchip.com,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v10 2/9] riscv: add infrastructure for preemptible this_cpu operations
Date: Thu, 12 Nov 2026 18:41:42 +0800
Message-Id: <20261112104149.38589-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yj8h5woyedn36nubqhefwqqfup7s4mz3
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0B2861C000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480188-195747
X-HE-Meta: U2FsdGVkX1/ZUqj2vpxnTpVyJ+cEtbRZ2N0/ZhnUMXRfkgFRJxFW7OsLXjRmnGuK9Npymrg+g3jXiW1DMPxzWCQRyBnFUA9R1HPFEgaLlvbvN2kJuAwromxKd+50m+1vYXKH+QHYRijwPD0oOLHBUStIaaMr2cJ5TeDANPJnYzO8fWBNUx0A9UCu0oVKr1Y81UUGnRH5VHaXtc7S60bEyAkTrWsHmh0SCe0sK5a8FeSRJwzYLR3QByY3FwH4XzAB7hipvxMwq7Qjm2ZoPMHh3lttXdGW9QRjsvwYDk4Zsvb5BCJGezFDq9eKzlY1q5E05pcL5cvwVgtOIErWaNbaZm8X64Ik2sfAp0ujLgxv8KMeRnAhn2qxGSEq+QGlj5LlRXShp2j4S9d0+oa9kFKlp3w2lIn87WGvzLhgMW4Sa7GSonhG5ElRgav4KyIeFksyqHcu74nZYSetSoyo5L7UNFJMOxy0uEhsLCZ0LPAyUl2BmO8qr+ZnYwhJCWiS6VohjWUTjkubmbv593zLIWQ5SsWdTk7dd6iFGqo8jWTZh579uBVRxQFCDBpa9t3iTyRjeZdZnvjHsnzLeUzy6cVGg2/dog2DIciQKKojqkxdcdReclTY2vg4DzM/DMXltsR8iMuKOee8owk4oDp8qGJEpovXp/woD4EXBr7KkheVQNHpEVxgyk/0yfPWhNMR5vY7Ibv8XMjgSkYDwa7KzVHLvTtN7rt6+FAOtlPk+jqY5tUx8rnzVWRLtw+SRje5s3L5wH3TjJVTg2iz/cSWjS4EoOjqA1pew7m+WKPlIYE2X5BpTM2jUlorVTUDo2lQVWV7y0qCSIQd/VK4WzC6fPlKUxFdeNfyxfYoKcdihtvsRu3HYPZjrC344B1ehan3WsGpoytYtg/N42bg7OtUoUws8TeJl3p4iCndEzztc9U6dNJhs3LwA42aaOAdjUdsitEPx5HgWKQg9tnniehhaH1
 TthL0UGh
 Ezb7Y3dBDFmUd0gR1j+tcExzoDty7qxLwVhCHOxBFj6zVp1ILWCYtw+/pLEO3TJ6uqWQuXZXpJwXjIoF0OdwLv4xr0m0SET/UqDkWVY0x/Bx9u1WW6IzyEkc93MyO693BkdRhOvP0voWn4+glrTtIUFZz8/Sfwx9UMUDS2Y1NkGifxMkEjKZz78Qv8dxqRaexKEhs+LB07mqDcr4DRpENHzNcEi/tke8HvLXMLPk5p0/t4nxQaKxg5zDVUYfXMIO4FfxZ5RWyY7EBIBaAQ+uM4I9Kjl9rFIg9n4z4UVECkrIaBPi7zu4LIPwmKwGsn7xlcXQuJdqHble2giKTFiOQpNqlivyIYqm/xveLxfT0LAV/exkOJUyuDoWd1LcUurkb5inhiRuHmchUZJ+8itsfKycYVqjMckKm1GK+oXSeVzUuFcqdrecjJvBJKblgEYf8HEvudq8FB5DsUhJWRX+abYkcutVGF0i0uZXw6rLOl0SP9Vyafni/VMCMua9uRQHHy4wU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V does not provide architecture-specific this_cpu operations, so
read-modify-write operations use generic fallbacks that disable local
interrupts. Disabling preemption around each architecture-specific
operation would avoid the interrupt-off region, but would still add
preemption-count bookkeeping and a reschedule check to the common path.

Use the recoverable-GPR scheme employed by arm64 so the operations can
remain preemptible. Record the registers used for per-CPU address
generation and repair them on exception return if the task migrated.

Exception entry saves and clears the active state so handlers can use
per-CPU operations independently. Keep this protocol in common assembly
macros so NMI-like entry paths which bypass handle_exception, such as SBI
Supervisor Software Events, can preserve an interrupted operation.

The existing exception return path clears LR/SC reservations, so an
interrupted LR/SC sequence retries after its saved address is repaired.

Suggested-by: David Laight <david.laight.linux@gmail.com>
Link: https://lore.kernel.org/r/20261108213254.67805ef0@pumpkin
Suggested-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://lore.kernel.org/r/avG07pmpcLGkq5i-@xhacker
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/asm.h         | 19 ++++++++++++
 arch/riscv/include/asm/percpu.h      | 43 ++++++++++++++++++++++++++++
 arch/riscv/include/asm/ptrace.h      | 15 ++++++++++
 arch/riscv/include/asm/thread_info.h |  1 +
 arch/riscv/kernel/Makefile           |  1 +
 arch/riscv/kernel/asm-offsets.c      |  2 ++
 arch/riscv/kernel/entry-common.c     | 32 +++++++++++++++++++++
 arch/riscv/kernel/entry.S            | 10 +++++++
 8 files changed, 123 insertions(+)
 create mode 100644 arch/riscv/kernel/entry-common.c

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index 06ac38f733b0a..57af10a936d9b 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -81,6 +81,25 @@
 
 /* Common assembly source macros */
 
+/*
+ * Save and clear the active per-CPU GPR state on exception entry. Entry
+ * paths which bypass handle_exception, such as SBI Supervisor Software
+ * Events (SSE), must pair this with pcpu_gprs_exit around their handlers.
+ */
+.macro pcpu_gprs_entry tsk regs tmp
+	lhu \tmp, TASK_TI_PCPU_GPRS(\tsk)
+	REG_S \tmp, PT_PCPU_GPRS(\regs)
+	sh zero, TASK_TI_PCPU_GPRS(\tsk)
+.endm
+
+/*
+ * Restore the saved state before resuming the interrupted context. tmp must
+ * contain PT_PCPU_GPRS from the interrupted frame.
+ */
+.macro pcpu_gprs_exit tsk tmp
+	sh \tmp, TASK_TI_PCPU_GPRS(\tsk)
+.endm
+
 /*
  * NOP sequence
  */
diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index faf9a75ec66d7..59f7d44f7d3fe 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -3,12 +3,55 @@
 #ifndef __ASM_PERCPU_H
 #define __ASM_PERCPU_H
 
+#include <linux/bits.h>
+#include <linux/stringify.h>
 #include <linux/thread_info.h>
 
+#include <asm/asm.h>
 #include <asm/current.h>
+#include <asm/gpr-num.h>
 
 #define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
 
+#define PCPU_GPR_PCP_SHIFT	0
+#define PCPU_GPR_PCP		GENMASK(4, 0)
+#define PCPU_GPR_OFF_SHIFT	5
+#define PCPU_GPR_OFF		GENMASK(9, 5)
+#define PCPU_GPR_ADDR_SHIFT	10
+#define PCPU_GPR_ADDR		GENMASK(14, 10)
+
+#define __PCPU_GPR_NUM(gpr)	".L__gpr_num_" gpr
+
+#define __PCPU_GPRS_VALUE						\
+	"("								\
+		"(" __PCPU_GPR_NUM("%[pcp]")  " << " __stringify(PCPU_GPR_PCP_SHIFT) ") | "	\
+		"(" __PCPU_GPR_NUM("%[off]")  " << " __stringify(PCPU_GPR_OFF_SHIFT) ") | "	\
+		"(" __PCPU_GPR_NUM("%[addr]") " << " __stringify(PCPU_GPR_ADDR_SHIFT) ")"	\
+	")"
+
+#define __PCPU_GPRS_ASSERT_DISTINCT					\
+	".if ((" __PCPU_GPR_NUM("%[pcp]") " == " __PCPU_GPR_NUM("%[off]") ") || "	\
+	      "(" __PCPU_GPR_NUM("%[pcp]") " == " __PCPU_GPR_NUM("%[addr]") ") || "	\
+	      "(" __PCPU_GPR_NUM("%[off]") " == " __PCPU_GPR_NUM("%[addr]") "))\n"	\
+	".error \"PCPU GPRs overlap\"\n"				\
+	".endif\n"
+
+/*
+ * Mark a region where the per-CPU offset and address registers may need to
+ * be rewritten by exception return after migration.  The three registers
+ * must remain distinct for the whole region.
+ */
+#define __PCPU_GPRS_BEGIN						\
+	__DEFINE_ASM_GPR_NUMS						\
+	__PCPU_GPRS_ASSERT_DISTINCT					\
+	"li %[off], " __PCPU_GPRS_VALUE "\n"				\
+	"sh %[off], %[gprs]\n"						\
+	REG_L " %[off], %[pcpu_offset]\n"				\
+	"add %[addr], %[pcp], %[off]\n"
+
+#define __PCPU_GPRS_END							\
+	"sh zero, %[gprs]\n"
+
 #include <asm-generic/percpu.h>
 
 #endif /* __ASM_PERCPU_H */
diff --git a/arch/riscv/include/asm/ptrace.h b/arch/riscv/include/asm/ptrace.h
index addc8188152f7..ceff8f63bc866 100644
--- a/arch/riscv/include/asm/ptrace.h
+++ b/arch/riscv/include/asm/ptrace.h
@@ -53,6 +53,8 @@ struct pt_regs {
 	unsigned long cause;
 	/* a0 value before the syscall */
 	unsigned long orig_a0;
+	/* Active preemptible per-CPU operation, if any. */
+	unsigned long pcpu_gprs;
 };
 
 #define PTRACE_SYSEMU			0x1f
@@ -145,6 +147,19 @@ static inline unsigned long regs_get_register(struct pt_regs *regs,
 	return *(unsigned long *)((unsigned long)regs + offset);
 }
 
+static inline void regs_set_register(struct pt_regs *regs,
+				     unsigned int offset, unsigned long val)
+{
+	if (unlikely(offset > MAX_REG_OFFSET))
+		return;
+
+	/* Register x0 is represented by the first, read-only slot. */
+	if (offset)
+		*(unsigned long *)((unsigned long)regs + offset) = val;
+}
+
+void noinstr riscv_pcpu_regs_fixup(struct pt_regs *regs);
+
 /**
  * regs_get_kernel_argument() - get Nth function argument in kernel
  * @regs:       pt_regs of that context
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index f10ba62b61016..51c4076763c1b 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -63,6 +63,7 @@ struct thread_info {
 	long			user_sp;	/* User stack pointer */
 	unsigned long		syscall_work;	/* SYSCALL_WORK_ flags */
 	unsigned long		pcpu_offset;
+	unsigned short		pcpu_gprs;
 #ifdef CONFIG_SHADOW_CALL_STACK
 	void			*scs_base;
 	void			*scs_sp;
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index f54c336bf547c..bf786d5dd4de3 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -52,6 +52,7 @@ obj-y	+= alternative.o
 obj-y	+= cpu.o
 obj-y	+= cpufeature.o
 obj-y	+= entry.o
+obj-y	+= entry-common.o
 obj-y	+= irq.o
 obj-y	+= process.o
 obj-y	+= ptrace.o
diff --git a/arch/riscv/kernel/asm-offsets.c b/arch/riscv/kernel/asm-offsets.c
index f4f7ee976cd94..38f246a691c60 100644
--- a/arch/riscv/kernel/asm-offsets.c
+++ b/arch/riscv/kernel/asm-offsets.c
@@ -39,6 +39,7 @@ void asm_offsets(void)
 
 	OFFSET(TASK_TI_CPU, task_struct, thread_info.cpu);
 	OFFSET(TASK_TI_PCPU_OFFSET, task_struct, thread_info.pcpu_offset);
+	OFFSET(TASK_TI_PCPU_GPRS, task_struct, thread_info.pcpu_gprs);
 	OFFSET(TASK_TI_PREEMPT_COUNT, task_struct, thread_info.preempt_count);
 	OFFSET(TASK_TI_KERNEL_SP, task_struct, thread_info.kernel_sp);
 	OFFSET(TASK_TI_USER_SP, task_struct, thread_info.user_sp);
@@ -130,6 +131,7 @@ void asm_offsets(void)
 	OFFSET(PT_STATUS, pt_regs, status);
 	OFFSET(PT_BADADDR, pt_regs, badaddr);
 	OFFSET(PT_CAUSE, pt_regs, cause);
+	OFFSET(PT_PCPU_GPRS, pt_regs, pcpu_gprs);
 
 	OFFSET(SUSPEND_CONTEXT_REGS, suspend_context, regs);
 
diff --git a/arch/riscv/kernel/entry-common.c b/arch/riscv/kernel/entry-common.c
new file mode 100644
index 0000000000000..023d856b1679b
--- /dev/null
+++ b/arch/riscv/kernel/entry-common.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/bitfield.h>
+#include <linux/compiler.h>
+#include <linux/percpu.h>
+
+#include <asm/current.h>
+#include <asm/ptrace.h>
+
+/*
+ * If the interrupted context had an active per-CPU operation, rewrite its
+ * saved offset and address registers for the CPU on which it will resume.
+ */
+void noinstr riscv_pcpu_regs_fixup(struct pt_regs *regs)
+{
+	unsigned long pcpu_offset = __my_cpu_offset;
+	unsigned long gprs = regs->pcpu_gprs;
+	unsigned long pcp;
+	unsigned int reg_pcp;
+	unsigned int reg_off;
+	unsigned int reg_addr;
+
+	reg_pcp = FIELD_GET(PCPU_GPR_PCP, gprs);
+	reg_off = FIELD_GET(PCPU_GPR_OFF, gprs);
+	reg_addr = FIELD_GET(PCPU_GPR_ADDR, gprs);
+
+	/* pt_regs offset zero represents x0, followed by x1 through x31. */
+	pcp = regs_get_register(regs, reg_pcp * sizeof(unsigned long));
+	regs_set_register(regs, reg_off * sizeof(unsigned long), pcpu_offset);
+	regs_set_register(regs, reg_addr * sizeof(unsigned long),
+			  pcp + pcpu_offset);
+}
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 628b85e3915a7..65298ac828959 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -198,6 +198,8 @@ SYM_CODE_START(handle_exception)
 	REG_S s4, PT_CAUSE(sp)
 	REG_S s5, PT_TP(sp)
 
+	pcpu_gprs_entry tp sp s0
+
 	/*
 	 * Set the scratch register to 0, so that if a recursive exception
 	 * occurs, the exception vector knows it came from the kernel
@@ -281,6 +283,14 @@ SYM_CODE_START_NOALIGN(ret_from_exception)
 	move a0, sp
 	call riscv_v_context_nesting_end
 #endif
+	REG_L t0, PT_PCPU_GPRS(sp)
+	beqz t0, .Lpcpu_regs_restored
+	move a0, sp
+	call riscv_pcpu_regs_fixup
+	REG_L t0, PT_PCPU_GPRS(sp)
+.Lpcpu_regs_restored:
+	pcpu_gprs_exit tp t0
+
 	REG_L a0, PT_STATUS(sp)
 	restore_userssp s3, a0
 	/*
-- 
2.39.5


