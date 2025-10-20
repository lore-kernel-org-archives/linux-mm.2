Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC681CCD1B3
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9EB8E002A; Mon, 20 Oct 2025 16:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B898E000E; Mon, 20 Oct 2025 16:54:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 414488E002A; Mon, 20 Oct 2025 16:54:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D03A8E000E
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:54:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39FA1402DF
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:07 +0000 (UTC)
X-FDA: 84019694934.28.A3D3766
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf14.hostedemail.com (Postfix) with ESMTP id E7ADC10000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:54:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Xgajb+Rp;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760993646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
	b=OOmx9FyRclZy62WXIr5c55NY/jdgqVg8Il4Rn74RD3Q2dL0EwQwU96lTwl7mp19UYZ7X4d
	cGsIuJE+5WWHf8Dby6uxbDAgasL+RwpKiySjkNgm47aj2v+jHr7QmCLoP8ne8CjtIaMcOG
	2IimIKx36OqzavHAWqEScuZB/XCr/YM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Xgajb+Rp;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760993646; a=rsa-sha256;
	cv=none;
	b=Ocv/YeWxubpoJDq+nBlIQyV/b1cnboun/ivamSlC4VnWjwOrxUqs6OQrNfqDffs9I1Jkvs
	F3b9TAU1WT6wDBtWAM08ZxoueQfLHEP/p1zU+By1uTuszTV1l+xigcqJagW02yiG+yKKax
	Y2gzkR7tATup0707kk5cV+qCAslleYU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-7841da939deso4485156b3a.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760993645; x=1761598445; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=Xgajb+RplTtw24Xw//stjSq5uegRnnFpBWaqLwFJUa6LCmr5zWZ5/fmTv+mDvsK5jr
         OjDkXDUSLpA043+IKtqbnZ7w1Z9JewSt0dTV1KTWfVWhlenaIub/Cu3PZcWuoG0BLqPj
         R7jsr0sOYwMtqrgd2RGo5H3IGouHiQO5Y6Lt+P7FAL0cWt+16kdlG3BD46QgSHzHfmvL
         W/u7X6qYwJI1RkLuf9OOuo8k0Rc9aiYDzM89i/xDVEkFrrPRHfrO3XRetQWD2wh/oV0u
         U3H+10i3SlTtYMr2F97wIebkchZc5m3XUbOwlWKNPj0YaQfGcnL0bcp022qWOBs/Tx8P
         vnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993645; x=1761598445;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ujHqL1CkFocnxfBg/TilHgsDv7qqfxACnquN+j6SpiE=;
        b=FNUrpes0wOqeflE1lg0vYJuVJKgcQU7/slfJ9/QoN88B+9kqdmGunV7vy8LqZBHnEZ
         VKLP1u9b4OeVS5rK10ySt5F+VpR3iw583QJmdp/sxOi1umqBy0N4t9hg/PaaJrFgAyQr
         A9BS9YKSFAm4l4R9ThLqSKGsnNN4imVAs4a/Db4lEEW4n3QUJU29hKxNkaJ0MbJr+0B1
         d8DjGwuw5c29fevKtisDCdNarWVk76VPFo3eypvH0GseqILyk2Y1qzz9caJhKXTdAvSh
         DRoOwhfaWwAJ9YS4grx+gVx6jj3zLALLrh9P44L2w/ewOQwRVo4Nof/jGtoXTEDPbmOv
         5VAw==
X-Forwarded-Encrypted: i=1; AJvYcCVrYUjVgox1HqpvNdCN2zvsXIQhENngW9ZARJwjmAEGeMPdboQao53v9SA8H0uhy6SgE4uBNkn9bg==@kvack.org
X-Gm-Message-State: AOJu0YyAVkwJC1M1FJ59MMH3bMidZyOQojq+Pkm5XwZp9+/cF7agETGm
	ykk9vwTTzdp/HKFVWBKkO88pVjyjxnglwwAqRjMbSY1T15GzAkId/NmvsZtB5l5QYgw=
X-Gm-Gg: ASbGnctXwxSTWZMCVUAMtedBoHZ55i2ai36oMay2RE1FvXjXCurlO523FzWLlQk3Nd8
	hRZsHuAvf7p039JiCZ1vOGXKfBbey9c8onlJK6lq1Xyd7pEucdPpdv9cHWcdJ0bXw34VrRZha+q
	j7rQ40v6b5yaQ9KcT6eF6Xo8DEkgCjANAh/Fu+Iyi9hf2r6PEGoJU+HJVDxRHQ0TyD+f+AqsktD
	uNiPiE+DIgaY9wOejPUXrrXhjs6KqKgcQa90U/jpz5vCMCkcxp4VN+DIh/Ig02kDaCcNB/YdwKI
	WDqU2MFzWOGervPDkDVoNOm/Tn6cQX381aHngiCk5NEI8NE+4N0X9tClDdqM1m0aBUd0km3RCaM
	6zyvgiQYG+Y9+s/j4tWIOGIHJm9N1cfki6hLYRsHm4COe8i+XZqAsCRYmS9g5KwSe+IyKtp8mGT
	L/mj6BIeVAag+B79Oan3zU
X-Google-Smtp-Source: AGHT+IE9a+p4gNntL9Yr4pKUHTjGYyxFT7rSvoBoMzMJVF66u7Twee/tCo6lMxMG7nRGc0QWm7CxRQ==
X-Received: by 2002:a05:6a20:7483:b0:2cd:a43f:78fb with SMTP id adf61e73a8af0-334a8618514mr18898624637.48.1760993644661;
        Mon, 20 Oct 2025 13:54:04 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a22ff1591dsm9453867b3a.7.2025.10.20.13.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:54:04 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:53:42 -0700
Subject: [PATCH v22 13/28] prctl: arch-agnostic prctl for indirect branch
 tracking
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-13-9ae5510d1c6f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-9ae5510d1c6f@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Queue-Id: E7ADC10000C
X-Rspamd-Server: rspam03
X-Stat-Signature: 8gjistndcqwf39thxiutoimj7yz6x9qp
X-HE-Tag: 1760993645-594571
X-HE-Meta: U2FsdGVkX19rh+ZLefqMBx0thBu5MWpQUBkx+BpHDJfEaP2LRNCeGDCr8Fg7LPosvJyDF7wiMYBBrgdnMWMahWXjfO8WWBQFRHTqEbF51RDpxw1xmqBLOhWmvUO1Jny7av4Febu2NHqKtEs19xrOHRDE9FM+/vyovm5riTRigo4CVv8+Vem5/C9XjKJXnCud5+RjcPdlvnn0Nen5OnFly8TTlqa1mKMeTMMjvYwLdD+z7Zkix4gWyqKL948FyVmN8Jzbu3Dwu0qPyBoqTwWvszZGXciq4tiChNJ642t0hBN+C4FvLxLRQZURFAQDFFY5AhhGXc+dBayrltSJlLq4bfkMYtPmof6nOzYjlYbnzsUSfwW8kwQIAtzJyuXIuXmk5owNqeo8dFc7SOU9J7FyCNjNEJ+sNn8fEeaxdVka7kQFjZP8GEIAs7/6ZgOeYtxS2F/bkQ0nRUqSHxWIV7Vu8SSfUZmAbqKUyovMAVWd/R6LPQojNbFLV+qUfcdCZIKmyFf6vBIRHFgJYxlACoHCstyp0WAT9aNwrav2QEybKcYc+Kj0JeLf0gSHtJzq7Y+reLEauF5+wMB7ZTQ/e4UOmSO1azUSH6Q+x9+4FKhjPB7O8rmy4qw8x2HRFosoT92B1X9FMpBRMPap+FGybAfoIFsN1Wc0aRYZby1Qa5D7tTWp3U1TQZOm13BTtMtzllO37FJr2zQUF9tDvQMDlJwTdRbzgXYAEpU0u+C6JVd7DRP4kO0s8nTGzOUjHWSeA70zZ5C6WiMYUs86E2OxvH3Cd1ZzTrqwsU5PVrYpTHRSBOli7nhbwglou+CIOEK3log/fe8frhQi7BG/RLKDy1hsxXY9hG264ACyNZXh2enXQNKp47DE/4K0F3yZoc+rBC+iqFrxuYf6oiuas8h0Ce1m+QdIdFMh56LUVz8mXjncLbYGd4/OkqAKNkdTkATepzuhQIsXfzJwV/lVkKe0cXj
 m2QcoqMO
 vSE9a3K77yfdDSw/KRANsd/bNu6O4deedYNnl4aU7xUwUz1+QD4a4J8Kg0DBHmNFdHKeKKQ4fbg9IZ06yQMOIxB+RlwMsPnMA/hfRsQJbuIVK7O3Ey/rIUP/w8faVvnHkKI0QMln6WYdAycO9jz96BIevRIjt5eCdFufkX0v8pg8fQxT+3RD+jlF6dzJJBziTzTD5RROvwOReSwRfAi6uKcKIPSnnxVOcnz/YYLWrvoKcouQ4jx4PqVUxRdaHdDipeY5W+g5r0TDPcb9gS2NmZKFtZe4JQ4KV78RtOzWa9mjXFJMhoJVpGHyqDS3WbnCxdgFGWTFm4cJLj0Jg6l2xwdkb7DuEWVqleVU2DPvcZjMPy/qn++XyLbO7t/CnlfrwOzzasQfLDWo0Td8beucrwOS83IjPYKGQFOt7aYbquai9dyBNuh2RUK3PqxKezy6U0iSKPMvsqz/BjI3P9roWXOygjIb5HOm/0qoM1oKoJ4f+KIAk6o5QQpKfwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three architectures (x86, aarch64, riscv) have support for indirect branch
tracking feature in a very similar fashion. On a very high level, indirect
branch tracking is a CPU feature where CPU tracks branches which uses
memory operand to perform control transfer in program. As part of this
tracking on indirect branches, CPU goes in a state where it expects a
landing pad instr on target and if not found then CPU raises some fault
(architecture dependent)

x86 landing pad instr - `ENDBRANCH`
arch64 landing pad instr - `BTI`
riscv landing instr - `lpad`

Given that three major arches have support for indirect branch tracking,
This patch makes `prctl` for indirect branch tracking arch agnostic.

To allow userspace to enable this feature for itself, following prtcls are
defined:
 - PR_GET_INDIR_BR_LP_STATUS: Gets current configured status for indirect
   branch tracking.
 - PR_SET_INDIR_BR_LP_STATUS: Sets a configuration for indirect branch
   tracking.
   Following status options are allowed
       - PR_INDIR_BR_LP_ENABLE: Enables indirect branch tracking on user
         thread.
       - PR_INDIR_BR_LP_DISABLE; Disables indirect branch tracking on user
         thread.
 - PR_LOCK_INDIR_BR_LP_STATUS: Locks configured status for indirect branch
   tracking for user thread.

Reviewed-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/cpu.h        |  4 ++++
 include/uapi/linux/prctl.h | 27 +++++++++++++++++++++++++++
 kernel/sys.c               | 30 ++++++++++++++++++++++++++++++
 3 files changed, 61 insertions(+)

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 487b3bf2e1ea..8239cd95a005 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -229,4 +229,8 @@ static inline bool cpu_attack_vector_mitigated(enum cpu_attack_vectors v)
 #define smt_mitigations SMT_MITIGATIONS_OFF
 #endif
 
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status);
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status);
+int arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status);
+
 #endif /* _LINUX_CPU_H_ */
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 51c4e8c82b1e..9b4afdc85099 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -386,4 +386,31 @@ struct prctl_mm_map {
 # define PR_FUTEX_HASH_SET_SLOTS	1
 # define PR_FUTEX_HASH_GET_SLOTS	2
 
+/*
+ * Get the current indirect branch tracking configuration for the current
+ * thread, this will be the value configured via PR_SET_INDIR_BR_LP_STATUS.
+ */
+#define PR_GET_INDIR_BR_LP_STATUS      79
+
+/*
+ * Set the indirect branch tracking configuration. PR_INDIR_BR_LP_ENABLE will
+ * enable cpu feature for user thread, to track all indirect branches and ensure
+ * they land on arch defined landing pad instruction.
+ * x86 - If enabled, an indirect branch must land on `ENDBRANCH` instruction.
+ * arch64 - If enabled, an indirect branch must land on `BTI` instruction.
+ * riscv - If enabled, an indirect branch must land on `lpad` instruction.
+ * PR_INDIR_BR_LP_DISABLE will disable feature for user thread and indirect
+ * branches will no more be tracked by cpu to land on arch defined landing pad
+ * instruction.
+ */
+#define PR_SET_INDIR_BR_LP_STATUS      80
+# define PR_INDIR_BR_LP_ENABLE		   (1UL << 0)
+
+/*
+ * Prevent further changes to the specified indirect branch tracking
+ * configuration.  All bits may be locked via this call, including
+ * undefined bits.
+ */
+#define PR_LOCK_INDIR_BR_LP_STATUS      81
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/sys.c b/kernel/sys.c
index 8b58eece4e58..9071422c1609 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2388,6 +2388,21 @@ int __weak arch_lock_shadow_stack_status(struct task_struct *t, unsigned long st
 	return -EINVAL;
 }
 
+int __weak arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
+int __weak arch_lock_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	return -EINVAL;
+}
+
 #define PR_IO_FLUSHER (PF_MEMALLOC_NOIO | PF_LOCAL_THROTTLE)
 
 static int prctl_set_vma(unsigned long opt, unsigned long addr,
@@ -2868,6 +2883,21 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_FUTEX_HASH:
 		error = futex_hash_prctl(arg2, arg3, arg4);
 		break;
+	case PR_GET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_get_indir_br_lp_status(me, (unsigned long __user *)arg2);
+		break;
+	case PR_SET_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_set_indir_br_lp_status(me, arg2);
+		break;
+	case PR_LOCK_INDIR_BR_LP_STATUS:
+		if (arg3 || arg4 || arg5)
+			return -EINVAL;
+		error = arch_lock_indir_br_lp_status(me, arg2);
+		break;
 	default:
 		trace_task_prctl_unknown(option, arg2, arg3, arg4, arg5);
 		error = -EINVAL;

-- 
2.43.0


