Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A4F0C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 19:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4806B00A2; Tue,  5 Aug 2025 15:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34F9C6B00A5; Tue,  5 Aug 2025 15:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EEAF6B00A7; Tue,  5 Aug 2025 15:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0961B6B00A2
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:40:08 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C64F3160144
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:07 +0000 (UTC)
X-FDA: 83743719654.11.6D6CADD
Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id EC2EF40008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:40:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BkpkecyQ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754422806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMI5Xwq0SqGXnmGRw5QTZMv+U2y6SNaFWej8c2zdngA=;
	b=cn4Qy0765ucqvjs01oY/KRi1S9ePy2S3fLsXr0pNWBUy2eFhBuSLEtJj1kKFQpcNVTzK+9
	D4hz253/jLoJbsdddagUF0Yk3grg93xaCbHEX+UI33nTv4X1m7SlgbhI0gb6yFaEBxBSj5
	u6Y1Kr9swLWuRaVcXRHtgrZcfWfnBDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754422806; a=rsa-sha256;
	cv=none;
	b=tKzv3ObxfXyqVYrk6Gl0P/vSPf7w75UflPNXLVXc+q3alJsult2eLiOm919Fz/PUL/TyjA
	FebV/pUEYMjiqe000Rxsu7ZeFONXauKhoCrTStirBjzGoo3EYuc4bBQCAmXMw7jAxOKFU5
	OVKfCmYqrlBWPNz5P7+dGjobRnu/0hU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=BkpkecyQ;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of jesse@rivosinc.com designates 209.85.222.169 as permitted sender) smtp.mailfrom=jesse@rivosinc.com
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7e6399d0654so318031585a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 12:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1754422805; x=1755027605; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CMI5Xwq0SqGXnmGRw5QTZMv+U2y6SNaFWej8c2zdngA=;
        b=BkpkecyQJ8ESiwxpekpDq3B8f8dwFTA16UOQf6xYwBVyynutO+ZVrd8pHs7gaMqI5v
         KTnsVitqJCGwUjohrpLkkqDtEapXrrU9s9gX+2nOWHyJX7Eevp/LozXpssovgmikovCb
         yNPZ/nN+f05ZQe4LkVhm8Ms8pIRMKXU/cM0HypApJPLAtp24CLlhbqxDrM3H/548SZn5
         2k9jf7R99M5PkQqVDDl2HdULhzvRshR4e7zJycqQx0569qAhbQ9pNVvKkB6bsEiAnN1Y
         zRGtY8v9NYawbWGXg8nbU7Zl6FrEdQ4JTe6DuY3LLFctAsQ8+oCccpKtzgxmN4tb9G3G
         az2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754422805; x=1755027605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CMI5Xwq0SqGXnmGRw5QTZMv+U2y6SNaFWej8c2zdngA=;
        b=vfzHyBemLpni6Tmyr3fB86UKUkSBA8ulFYhNZuZnQDlp6aCK+NhsCcEmtM9XtXhWOr
         IUFXYLoGcyafoqPeNbEnFC0Ro/uEgm9+Bv1CshdoIbNsZ+5wESQlntrD/aab/0thd6jp
         I5FGvFbRhnVpEC4SBqjxrUouEnAoeEV5TNiohinCdwWPLf8O4NIq6HNcEiVVLvo+dR+w
         CadkPGWNXX0fb8RtNdN1gjYWrqfwDc9Ir5p9B9cMQH27b36F5y5MXqPur7P8zMKVPC8w
         26OXJOC5LGFTZydzPLLRvhAop0zOuAO1muDFbM9zZ4fekLWkk3BRvJZXQULiWWV1QTIU
         jClw==
X-Forwarded-Encrypted: i=1; AJvYcCWDPGWscDoLFcdV9JK6ZBpaNgwFWt8LfBorZUALJtRKHLeFAHhk+iYrktBEY2Fn/KBEGo+yV7IX+g==@kvack.org
X-Gm-Message-State: AOJu0YzCwx5IDb+d7TquARB2pzmZm9Kt0uEYuIhnRO3JLOBRZTrujGFt
	2EjVfvMhAzcfrb3AjV8mcMbv131dAdAmAU1DbMUZ1KXIWh3SrdHI6E8W5R0kVaS5Rn0=
X-Gm-Gg: ASbGncuBy/HbwxhH1VforwmNstQ73Mpf+NGAMrx6Qqz+5TyRpGNJUfbWOTegf2/ENSb
	zNZzi5FE1qAgdNZWNGAQI0kfR8OHwqcKRV+UnDcppc+DdHuzrLwwVeMCu/2FCwJN5kzO4deGglX
	rRKl99ltBRJukFA4JlFUeDwTLlxn2jm7uWZzL6n0d+nNkYagMh8TOxQT/cFvRZ8AKVrsZOdHJLA
	17bL2H7nJf7SLlpU6+vw2lozWH2bcvwTJTtHeDRXRZXt4I2AG7n5cSAUF8SN5p/5saXXWsLscKb
	PE758rsfwGjpYm4bnUbpBi3SrmiTTdQFttssGRRe4wW97PLazxQLVN5MU7baiEwGTQxTlmDtfBw
	phkukPS7BTfI4f6E3stNoBxuFbj1NznG3Of/yzYQ40Kt0S8jwNXO8S5x2P/1w0fqjs4J+//pSm+
	Cg1F7fLA==
X-Google-Smtp-Source: AGHT+IGslZriZ3OsEZBWmVfkk5oCBsMISvqP0jsnyJuJf09cg7efSarv3MBZUu5//ACqxd//7g3UxQ==
X-Received: by 2002:a05:620a:430a:b0:7e8:2e5:feb3 with SMTP id af79cd13be357-7e814cf9504mr90508985a.1.1754422804849;
        Tue, 05 Aug 2025 12:40:04 -0700 (PDT)
Received: from jesse-lt.jtp-bos.lab (pool-108-26-215-125.bstnma.fios.verizon.net. [108.26.215.125])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e67f7064b0sm717855685a.54.2025.08.05.12.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 12:40:04 -0700 (PDT)
From: Jesse Taube <jesse@rivosinc.com>
To: linux-riscv@lists.infradead.org
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Oleg Nesterov <oleg@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Jesse Taube <jesse@rivosinc.com>,
	Himanshu Chauhan <hchauhan@ventanamicro.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Conor Dooley  <conor.dooley@microchip.com>,
	Deepak Gupta  <debug@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Atish Patra <atishp@rivosinc.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Mayuresh Chitale <mchitale@ventanamicro.com>,
	Evan Green <evan@rivosinc.com>,
	WangYuli <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	Joel Granados <joel.granados@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Celeste Liu <coelacanthushex@gmail.com>,
	Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Nylon Chen <nylon.chen@sifive.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH 3/8] riscv: insn: Add get_insn_nofault
Date: Tue,  5 Aug 2025 12:39:50 -0700
Message-ID: <20250805193955.798277-4-jesse@rivosinc.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250805193955.798277-1-jesse@rivosinc.com>
References: <20250805193955.798277-1-jesse@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EC2EF40008
X-Stat-Signature: 9ftxozgb3fx9ibaqg7r4qiqx8746gd3j
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754422805-713039
X-HE-Meta: U2FsdGVkX1+NmYF+YkJvYY2TOSZtIXhQJpqyyT93jgnjC4pA/MoM2jyKEBHQrhE8kosqsxlEdlufF+rRdbeFCeGNGoIk9l3Ll8bXAIACnvwT7Oae0i4kJ4A9AyINrwfsD4xghF65rd20bdpWjG+blc1Cjgp4QNe3cQegQ7lRFDHmnyq03X91aRS0bgfkOkq3n40WAnZkKeCS4qWN6EpPTAANzha0mha3Z3n4LhBiOoF1RZsj0KlyNYZ6b50PPQkAm7QGzS+tDMshVk5DwHywh4g/pxDwqsXno1dQtfzBTEs5iO0Tr1hsSP2igYdchb26ThfphoouAaMSyPTZF30mboRU+doXVSuA1f/manay8w2ro0BS0u0BNj45XAzWjk+kn0BC4674sCgl9FRVLBoP/jf+0Zz4tTa38qdkthdBaaN+ct0n+OOse8gTXhAMUP+BUW9PhLAg7jriX1zhx6H9hE6k19/cJWzGCJ4ntyUurg/5iaVp1EXXtpvHJOFCAKRSj4Q38C/4flPzBGQR2DqiVgN67xHqo9lgFRaW8KUq9lW5L2rd0K6i0ZnTID5YGuK4S3kFmdSLGAl2q0fpoRf1dh6NOSvZ7bpoVzv7Hxe4pS7JZES/ZIjureNpMwpQ+J3uXoixcT0gcd+TGjyqpkGlKNFbmTKzf6GnkNWUVOoS/0td5H1F0L121In2AXLRZByHeRpI7jvg/ejtewOmG8oyd/6HfKsUn9h8yT8ZTbwGKAPbbGfaGI7eJgDIeKm2G/ax5fZc+y1XNlGxiMnubBnLSQKqKn/1Kg+MKdyWvE5Do38lIkLK5LHFi2DklmdODYxammOKkzqGdmB9Qv2AdjPeRqYxeeWD5XI1WQt1GKwAtYy7Bud6Cx+tT4TZWA+PlIskOlCRwwxLBhdJc4sFl1LJdet6jBztOEhbl/s00NRvrow24drQNt56i40chnvMv5dLRBoHQg4pWzAau6CMRJb
 6TpH45pc
 WJZgqODElC4wlh1BsSxW93+E8xjpwuMYtW9CSb0u70eCixhwNwHSDQxW2jliAW+GTneo6c3e0GQ4fbfQJfdLr0TOm1BTbxy/5Kt1E0ZaGCnTI0PsftTMDTvfSs5rcF9aOqkM8Ic57Gx3w2i4fD7RX28zxScK+Lh8/i+PaUfdWxtBeJHY3TzUP2Wz9I0zTp61So0U68ggkGUbc0xqfDgA8ryVwH6l4whGzSawJBZsFtxffPUPw1lvnzuwKxSYHs09n98uzBtDufUzmYAzGsNkhElrZ6RRNRH6Mc3g/K5cmlxM2P9V9hLinyquRwherO//ktT/iQzDVFolspL08KS2pruZUc6m7F4ZgrvwfijBd5IiMxUSVyuyW6K+PKPo4I7gtkb9OMbpMrDaFMkN8ckL8lxS2kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_insn_nofault uses get_insn with pagefaults dissabled, allowing it to
be called in an atomic context.

Signed-off-by: Jesse Taube <jesse@rivosinc.com>
---
Unsure if copy_from_kernel_nofault is an acceptable replacement for
direct dereference in __read_insn.

RFC -> V1:
 - Add new function instead of using copy_from_user_nofault
---
 arch/riscv/include/asm/insn.h |  1 +
 arch/riscv/kernel/insn.c      | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index ba74e5b8262c..f87e0a48f786 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -553,6 +553,7 @@ static inline void riscv_insn_insert_utype_itype_imm(u32 *utype_insn, u32 *itype
 #include <asm/ptrace.h>
 
 int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn);
+int get_insn_nofault(struct pt_regs *regs, ulong epc, ulong *r_insn);
 unsigned long get_step_address(struct pt_regs *regs, u32 code);
 
 #endif /* _ASM_RISCV_INSN_H */
diff --git a/arch/riscv/kernel/insn.c b/arch/riscv/kernel/insn.c
index dd2a6ef9fd25..c8f77c0093c9 100644
--- a/arch/riscv/kernel/insn.c
+++ b/arch/riscv/kernel/insn.c
@@ -2,6 +2,9 @@
 /*
  * Copyright 2025 Rivos, Inc
  */
+
+#include <linux/uaccess.h>
+
 #include <asm/insn.h>
 #include <asm/ptrace.h>
 #include <asm/uaccess.h>
@@ -74,6 +77,17 @@ int get_insn(struct pt_regs *regs, ulong epc, ulong *r_insn)
 	}
 }
 
+int get_insn_nofault(struct pt_regs *regs, ulong epc, ulong *r_insn)
+{
+	int ret;
+
+	pagefault_disable();
+	ret = get_insn(regs, epc, r_insn);
+	pagefault_enable();
+
+	return ret;
+}
+
 /* Calculate the new address for after a step */
 unsigned long get_step_address(struct pt_regs *regs, u32 code)
 {
-- 
2.43.0


