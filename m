Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6577C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 107886B00B4; Thu, 31 Jul 2025 19:20:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B7CF6B00B5; Thu, 31 Jul 2025 19:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E259E6B00B6; Thu, 31 Jul 2025 19:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C67FE6B00B4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 928E5114D39
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:19 +0000 (UTC)
X-FDA: 83726130558.21.E21A437
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id A49EDC0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JR34RYZV;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vv1pncyaii0eRn94le4SC/ImUZxnyr5HEUraE6PoZM=;
	b=A9faMdII2MFtnHHzTp7LXlONA8eQQQyiqdERXSmi9ERrbIn4HE62MfE/SZnnDRys0fA/af
	XLUhyLQ7utQcTPDYMMw/n+Gi7NvnlJvoNkmvVrNtZCriFYYhdG25kuRBNMEVGRd3wxYHsc
	GqHJIvO7zV9gNlG2jz+92BmaFLO2YNU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JR34RYZV;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004017; a=rsa-sha256;
	cv=none;
	b=EmL19c9cTQgYtEq7FnvqCiCJqEGVhb+DBdok2m6zD9dsAbYfvwEOd49nEZzCXKPcWsTQ5P
	7hIxfIcsLqOsRTvfW8lIDVg9jgkPqRMFVP4Azz/iEsdG4qsNeIeV7sbHv5haFTxtw3jUZk
	YAH4Aw3mSqLNN8b3qzKxxlb5WNIb2wg=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b2c4e46a89fso859318a12.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004016; x=1754608816; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2vv1pncyaii0eRn94le4SC/ImUZxnyr5HEUraE6PoZM=;
        b=JR34RYZVKnupa0g+io+oZ0t3MJZ2En03FQUus0y+Gk2yl9QXsTX14K700bQM+KYI3m
         TczrwEHpcBInSLAUsu+ipUQvN4ggtmCE5Nw+G36Gs1zSEMpDLfH+/5LoCB4gsULDhnGl
         9G0t8MCaLU2o3TRi+J+uY/9WSnchsaFf8TSaIl3nUl7D5MozBFA2PXwy+ErbZWBhamlA
         jyCq3OTgm3AHbjQd4y1rATfW1M5BU81AktMgSThHbUqJC8MRQ5A0jOpeluZ4IVIUcKLy
         YnawkwEhXrfWwjjc6wLSEdMg98azfNj7JxyzLlNEqxMGBcZ0erIABoHXImeaIxuHgHS/
         Oy8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004016; x=1754608816;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2vv1pncyaii0eRn94le4SC/ImUZxnyr5HEUraE6PoZM=;
        b=iHln+9exECJcTznMfTyqk8nkzvo9wYFkZoo1BtSXkVlAKs+6wVCeb8MOHEudMtAEr6
         rNP/wX7rbgdaYiEsqjYZmpzZnyzZqLgWSYlokUpEV3iSRXSMfKWfZw2qA9Mozwtn3bIg
         ZOTee54D0bqP18qrWMdoJkm/T501//qPCjXffJ4+TFgP4I+mf1mhWCofl1JWxvMG3kAT
         /T7MEfrox5hRNUFnvh5O7SbCDwuLvuHaSq8CjpPpfMjUgZEzPVmH6RtKYwHOY/zdHAz8
         NPkrNgvs89gcBXNupnVCqyHLrsDVGg1SDew1VyJjpfa5bIJ9pEjKJzgV20PX5T42yxdR
         7k/w==
X-Forwarded-Encrypted: i=1; AJvYcCVyeCfgB+Ygws/4lWklw2FPxKhc5WxCS0PhSutHXSAuMnN3fCJZwDs3bY2NUTFvLxzXc4QvvcUgQw==@kvack.org
X-Gm-Message-State: AOJu0Yy3Ka8SJbucZHmyLXNS4qFCf+zWp8PmEHpeaHlJEm3GekRX0BAy
	hwFuI3+2xhGRplh5rICUFWEYzEFLXzs/83dZ9aNiDqk5D24sgU9FV4XJz6OyNhPwV9A=
X-Gm-Gg: ASbGnct3rMLEFoV9S+2URe1NVNtGV5q0Zde5rLN9HUBjRufqdTaOI2day4EaU99goz8
	+s9t5GpwCwNOlPF8B7Rtx5XkAdBlkybT7LP0yH1+yRNf79iWmadXE1tm1Z6g0MZmihNlZqCCOMt
	20xK+FAN4Vfoo3J41Z+0boOaQooF3STfuqKMHoJ+G1Y4Y5xpYaq/PYxt3rD+hJKNU0v1BmDCnWB
	NVm774rFLmPrbhD2W59HqKHaAerSi04TDN6bZAH2nl2hdhBMeJ1V/wBi523GJcaEbTiyCPXelf1
	jFzF4flqIsXG2aV6Srdryp/NaWkx/CBv+ZqEs1P9qcVTEr1NPUXpCMcapNYeMguvlW5fPiYE4j/
	0GcQQmYYELOgwGKxJUPINAGbxh+yw+9sh
X-Google-Smtp-Source: AGHT+IGfZ7roCHqqLvq86oqYETDqaL6chXFhK00KJMSB4VLMUqAx4JH53/1HIyht5vrREGoIidkmfQ==
X-Received: by 2002:a17:90b:1801:b0:31f:9114:ead8 with SMTP id 98e67ed59e1d1-320fb75cd21mr863889a91.6.1754004016435;
        Thu, 31 Jul 2025 16:20:16 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:16 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:29 -0700
Subject: [PATCH v19 19/27] riscv/ptrace: riscv cfi status and state via
 ptrace and in core files
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-19-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 34ua1ibwory9k64j3bosnnnpy56t9ont
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A49EDC0003
X-Rspam-User: 
X-HE-Tag: 1754004017-821897
X-HE-Meta: U2FsdGVkX1/klowUd517Qwz+ILjy6PiewSURxfhmPge0L4rTiF1QmC+l4ll/G3T50HYV8PsMGpmegPqQ09AJ8m6Kb6hKED2Be19wt0VB00UqWtj1RIRPSwNq4MSonqfItln8RO2N1rNH5PJhaj9kMHYVmaBrrXPkx+r0/Qc3sA/ddhk5ZW/NtY+4z99QTuFCsoVH/kQDLL56iV0NB5rwjGK53ahk84cQPE7z9PC6Uy1qsiTCzqIWbM2oQUVM2KZ6Mb+EkmNFpODX1pyt7HfLlJ1ha3f4OFbiyc/MWwLSMT09on6aWBzrjXn2wig32YgAu+OH2x29CJAyWqm7lWnepG3YdcLGiAhmTnc+8UYH8WskJK07ZSspgeyzwT7TzhW9BUYi5SJxUME5daTYbEMHCvicUF3y9jcev4p3ipbjNsM286aW4navmVvhERW+Pyn9cDnO41rXDCc7BgPFfIs5JhSswWbOifMiKVon+OlG51fGpYRxoQ2YHYYE2jxaaFQiMziMXJb+5uBPJwnrtMIIP9stWKmmQjmvlvzImp7hGZWMgcKYQR8ZALmBQqJYw8VpTvOHwTVvM8czvId3BgFYIM/BCGrjSebcd1TvaYE3ftP8PHKLle6sd8iv+lpNt5Flzk5YeFVIbmN2b6/XG6dFr1TCB4n42/+uQt3SFhjmv/zH9qImq9MppiPNkVrl8aKNYH/oBtQ9M3GBPOjkimlV1sEXRUciyFV0iDUxaaA4JfzZgRzQtqXk/eHeg+/3rOVto2Rz3TqajflPW9dXAIbxD1nPT8JyUHNixZANHdXqKdMQPmfAg45NpqOdpJWFajgJivQWxjVa7EVKAVrz+iWn4j/jg+XP7B5sSYasNjWUQbZA2ENwCNPjo+ZpgpsZ1d2PYu5AZq1hU9eHvp4v6p8jW8T6taet+1ZhvnjpY8X9nt+ZjCMq0CDW8wbh5CfxTVNpO8lLrCLIFa9TdNquxpr
 Q+u4TWPM
 1/4QcC12zp3oWZEEEX9UhzdJSq7yidVt/vkgVW0x4vN34fJrKpG7tP31jT6hYR+dgMufocFZpQt3F81fYku1J+EyCJcdObBI4cn824HKYDQ/jQhtt0ilrosXQ+F0Rbr5fmYVOAYU36378ugcfypLCPil2xjD1WKQrTElTDuVzkeJLE3DnN2Xcgj9k1f2F5xRYSVQ47g1xI9X69VFAn/I30TqF2kFFxRSSqkT+JlaaN0bfa3c9pPqg6ih18tP416KJNW02V/rDJ3fsdLCck23XbyZSbWvOUs/jxiA0XTQtkSMIQL42vlN5wCEVYExVef1kxDPmrRbHPk8YWrpd8bm5c8vTz0t4XoEAcFSE56jrgYN31OIS8rfxair5irO937CfP8QuiZ+Pmkn2TgXcBV84fHwJVQQziAbeu40EmEgo3oj+aWpAfS/J+b6t+fOGSV4ybFKm58YpontWZ4HlEkP61ruIpLDqG2oHnmxTkHvej5OE4l3jvdpoll3lNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a new register type NT_RISCV_USER_CFI for risc-v cfi status and
state. Intentionally both landing pad and shadow stack status and state
are rolled into cfi state. Creating two different NT_RISCV_USER_XXX would
not be useful and wastage of a note type. Enabling, disabling and locking
of feature is not allowed via ptrace set interface. However setting `elp`
state or setting shadow stack pointer are allowed via ptrace set interface
. It is expected `gdb` might have use to fixup `elp` state or `shadow
stack` pointer.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/ptrace.h | 30 ++++++++++++
 arch/riscv/kernel/ptrace.c           | 95 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/elf.h             |  2 +
 3 files changed, 127 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index 659ea3af5680..63e18ee2e050 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -131,6 +131,36 @@ struct __sc_riscv_cfi_state {
 	unsigned long ss_ptr;   /* shadow stack pointer */
 };
 
+#define PTRACE_CFI_LP_EN_BIT	0
+#define PTRACE_CFI_LP_LOCK_BIT	1
+#define PTRACE_CFI_ELP_BIT	2
+#define PTRACE_CFI_SS_EN_BIT	3
+#define PTRACE_CFI_SS_LOCK_BIT	4
+#define PTRACE_CFI_SS_PTR_BIT	5
+
+#define PTRACE_CFI_LP_EN_STATE		(1 << PTRACE_CFI_LP_EN_BIT)
+#define PTRACE_CFI_LP_LOCK_STATE	(1 << PTRACE_CFI_LP_LOCK_BIT)
+#define PTRACE_CFI_ELP_STATE		(1 << PTRACE_CFI_ELP_BIT)
+#define PTRACE_CFI_SS_EN_STATE		(1 << PTRACE_CFI_SS_EN_BIT)
+#define PTRACE_CFI_SS_LOCK_STATE	(1 << PTRACE_CFI_SS_LOCK_BIT)
+#define PTRACE_CFI_SS_PTR_STATE	(1 << PTRACE_CFI_SS_PTR_BIT)
+
+#define PRACE_CFI_STATE_INVALID_MASK	~(PTRACE_CFI_LP_EN_STATE | \
+					  PTRACE_CFI_LP_LOCK_STATE | \
+					  PTRACE_CFI_ELP_STATE | \
+					  PTRACE_CFI_SS_EN_STATE | \
+					  PTRACE_CFI_SS_LOCK_STATE | \
+					  PTRACE_CFI_SS_PTR_STATE)
+
+struct __cfi_status {
+	__u64 cfi_state;
+};
+
+struct user_cfi_state {
+	struct __cfi_status	cfi_status;
+	__u64 shstk_ptr;
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/kernel/ptrace.c b/arch/riscv/kernel/ptrace.c
index ea67e9fb7a58..933a3d26d33c 100644
--- a/arch/riscv/kernel/ptrace.c
+++ b/arch/riscv/kernel/ptrace.c
@@ -19,6 +19,7 @@
 #include <linux/regset.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
+#include <asm/usercfi.h>
 
 enum riscv_regset {
 	REGSET_X,
@@ -31,6 +32,9 @@ enum riscv_regset {
 #ifdef CONFIG_RISCV_ISA_SUPM
 	REGSET_TAGGED_ADDR_CTRL,
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	REGSET_CFI,
+#endif
 };
 
 static int riscv_gpr_get(struct task_struct *target,
@@ -184,6 +188,87 @@ static int tagged_addr_ctrl_set(struct task_struct *target,
 }
 #endif
 
+#ifdef CONFIG_RISCV_USER_CFI
+static int riscv_cfi_get(struct task_struct *target,
+			 const struct user_regset *regset,
+			 struct membuf to)
+{
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	memset(&user_cfi, 0, sizeof(user_cfi));
+	regs = task_pt_regs(target);
+
+	if (is_indir_lp_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= PTRACE_CFI_LP_EN_STATE;
+		user_cfi.cfi_status.cfi_state |= is_indir_lp_locked(target) ?
+						 PTRACE_CFI_LP_LOCK_STATE : 0;
+		user_cfi.cfi_status.cfi_state |= (regs->status & SR_ELP) ?
+						PTRACE_CFI_ELP_STATE : 0;
+	}
+
+	if (is_shstk_enabled(target)) {
+		user_cfi.cfi_status.cfi_state |= (PTRACE_CFI_SS_EN_STATE |
+						  PTRACE_CFI_SS_PTR_STATE);
+		user_cfi.cfi_status.cfi_state |= is_shstk_locked(target) ?
+						 PTRACE_CFI_SS_LOCK_STATE : 0;
+		user_cfi.shstk_ptr = get_active_shstk(target);
+	}
+
+	return membuf_write(&to, &user_cfi, sizeof(user_cfi));
+}
+
+/*
+ * Does it make sense to allowing enable / disable of cfi via ptrace?
+ * Not allowing enable / disable / locking control via ptrace for now.
+ * Setting shadow stack pointer is allowed. GDB might use it to unwind or
+ * some other fixup. Similarly gdb might want to suppress elp and may want
+ * to reset elp state.
+ */
+static int riscv_cfi_set(struct task_struct *target,
+			 const struct user_regset *regset,
+			 unsigned int pos, unsigned int count,
+			 const void *kbuf, const void __user *ubuf)
+{
+	int ret;
+	struct user_cfi_state user_cfi;
+	struct pt_regs *regs;
+
+	regs = task_pt_regs(target);
+
+	ret = user_regset_copyin(&pos, &count, &kbuf, &ubuf, &user_cfi, 0, -1);
+	if (ret)
+		return ret;
+
+	/*
+	 * Not allowing enabling or locking shadow stack or landing pad
+	 * There is no disabling of shadow stack or landing pad via ptrace
+	 * rsvd field should be set to zero so that if those fields are needed in future
+	 */
+	if ((user_cfi.cfi_status.cfi_state &
+	     (PTRACE_CFI_LP_EN_STATE | PTRACE_CFI_LP_LOCK_STATE |
+	      PTRACE_CFI_SS_EN_STATE | PTRACE_CFI_SS_LOCK_STATE)) ||
+	     (user_cfi.cfi_status.cfi_state & PRACE_CFI_STATE_INVALID_MASK))
+		return -EINVAL;
+
+	/* If lpad is enabled on target and ptrace requests to set / clear elp, do that */
+	if (is_indir_lp_enabled(target)) {
+		if (user_cfi.cfi_status.cfi_state &
+		    PTRACE_CFI_ELP_STATE) /* set elp state */
+			regs->status |= SR_ELP;
+		else
+			regs->status &= ~SR_ELP; /* clear elp state */
+	}
+
+	/* If shadow stack enabled on target, set new shadow stack pointer */
+	if (is_shstk_enabled(target) &&
+	    (user_cfi.cfi_status.cfi_state & PTRACE_CFI_SS_PTR_STATE))
+		set_active_shstk(target, user_cfi.shstk_ptr);
+
+	return 0;
+}
+#endif
+
 static const struct user_regset riscv_user_regset[] = {
 	[REGSET_X] = {
 		.core_note_type = NT_PRSTATUS,
@@ -224,6 +309,16 @@ static const struct user_regset riscv_user_regset[] = {
 		.set = tagged_addr_ctrl_set,
 	},
 #endif
+#ifdef CONFIG_RISCV_USER_CFI
+	[REGSET_CFI] = {
+		.core_note_type = NT_RISCV_USER_CFI,
+		.align = sizeof(__u64),
+		.n = sizeof(struct user_cfi_state) / sizeof(__u64),
+		.size = sizeof(__u64),
+		.regset_get = riscv_cfi_get,
+		.set = riscv_cfi_set,
+	},
+#endif
 };
 
 static const struct user_regset_view riscv_user_native_view = {
diff --git a/include/uapi/linux/elf.h b/include/uapi/linux/elf.h
index 819ded2d39de..ee30dcd80901 100644
--- a/include/uapi/linux/elf.h
+++ b/include/uapi/linux/elf.h
@@ -545,6 +545,8 @@ typedef struct elf64_shdr {
 #define NT_RISCV_VECTOR	0x901		/* RISC-V vector registers */
 #define NN_RISCV_TAGGED_ADDR_CTRL "LINUX"
 #define NT_RISCV_TAGGED_ADDR_CTRL 0x902	/* RISC-V tagged address control (prctl()) */
+#define NN_RISCV_USER_CFI	"LINUX"
+#define NT_RISCV_USER_CFI	0x903		/* RISC-V shadow stack state */
 #define NN_LOONGARCH_CPUCFG	"LINUX"
 #define NT_LOONGARCH_CPUCFG	0xa00	/* LoongArch CPU config registers */
 #define NN_LOONGARCH_CSR	"LINUX"

-- 
2.43.0


