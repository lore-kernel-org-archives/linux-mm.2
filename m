Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54EC6C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C6A6B00B1; Thu, 31 Jul 2025 19:20:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FF86B00B3; Thu, 31 Jul 2025 19:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D625D6B00B4; Thu, 31 Jul 2025 19:20:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BF7DD6B00B1
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C6D881050
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:13 +0000 (UTC)
X-FDA: 83726130306.22.53E29EC
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8B8D714000C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=VXdxq89Z;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NiyUtsRc4plmi7vohRqdQjzwfkHQI38tOt31f5L5qaY=;
	b=ieC0mAicaXTbh83SNdpCh21WxqSzxBcuVpL4matax/NjnxzgtEMN6o2jtrVaPLNGOY+lNM
	IzA6izpNwt2zxYxrJf6xAXKt6WzNj/fURIJqkKGmgSuhZwfYtjIW/fSQbaY5I8Qr8c0ooM
	mAVya3jmtNu7jOnUHdSZsglYjKpJqjA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=VXdxq89Z;
	spf=pass (imf26.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004011; a=rsa-sha256;
	cv=none;
	b=hQ/hqTSZuz4hW5zeg7f43ReB7/2zHvy4Tm9auZVHUNyQFuk6Kj56fp3/tBw9SFbS4sgoBX
	pxVZ31VM/iQLUc/M6IVRFXpSQq2uwIalGoJJLefPKOI9EDPRJqPDOmkXIqFfCc/s3DzxBM
	ncq/CgfYHKyynN/jRsVY/VksgTc5Ay8=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-315f6b20cf9so267472a91.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004010; x=1754608810; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NiyUtsRc4plmi7vohRqdQjzwfkHQI38tOt31f5L5qaY=;
        b=VXdxq89Zmt9hukPVoD2WjoSxJjYBLuKczeKJkqjb0I4kTKGB8isFTPZM7Z6p2Xe4Wh
         zIx9MjtZZ8sCycXQHYR6vkTVAlfnwHILgl3x3WasSkVLSgX9uQo7lwEenE+c/r6aIL4c
         ooRrASQePt3fMlK+n1ndUnb17KcFdg+MOZQ1KrmOBePAhUyGSG4UGbfVqjqniQYkjz39
         EzpSbFTtvw6zmAgL6uAPJJ2vNrxSS1qO7N4svVqYiNauv1XQD4dCAA+plsc8iZqQ7tFe
         JOfanTu9TDo92/J8mVptXN7xNPqqarbuYXNylZAT4Ar6KKYoE9N5GyvFsNMCSQnyOsqy
         cxdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004010; x=1754608810;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NiyUtsRc4plmi7vohRqdQjzwfkHQI38tOt31f5L5qaY=;
        b=BZP3cdNkdRA/FOXWymwSaMAXsV66loRcFQ38KGzic7ZIbedxNeBYbueRTZjxcu5lQ5
         2a+/E9/Tr1V9mPTNrA8H0SfAaX92MQRrPOtxSEpBUhz7kN/dDGkixMZvdiVmcsvR3Vbm
         kPim96dcV0E1U2P2R3LyOAISM0CHxW1PSz982oAHfQMi4CCYTIqBRFSvb/5W9XcWCVsy
         V18GucYOKghPGFmDDPVbenHl6c3u1CXKc7gqDNt5qpOYJ6GTG0kpqSKzeN05VqjSScyw
         2z62bHYGJfyeJTWrbxTIf2u81vpHxJsOl5sFKCQYSDXNMZr6TbYk5h/27BIBJEBO9d3Z
         NJaw==
X-Forwarded-Encrypted: i=1; AJvYcCVz5VUJw4aWlshN+lABMyXWO5O/CbfFxhMVxzZ4Rg+VhVF9S9JKIXP9Vdesn2G9KcFfSh+sN6OkKA==@kvack.org
X-Gm-Message-State: AOJu0Yz+wBOz126AgMsgl+XrsMc4mWzFIPwqscrPxjm8JbxlTKXtNSkM
	SGZbV8T0KX0LHgPWT/YizheTJt1uh+GD1utorUI6hg9l5VyV9I5oJxi4wyt+Jr0X9qU=
X-Gm-Gg: ASbGncsyYAwPQ0TFAQeb/9v5y/eri4P6rbdqv2J+0UslYF9Q8a/RQWWFa4BkMjnj5cy
	YW0lKtYXvVnsSdBUk5fuWw8uzOE5WALD1vv4zGsJ7yYFAMbFyaWd6+FNzEMP/+lVyUkLaoJywAQ
	YdeIqSJZ78prb/5PR4f1eemVEJhxIY4j6SuSajOw5tROMyGWL/fj5Ky5nlrlu50yicPAsHj3t7T
	/An28o96tr2PdEn6M56iCWoZOpellUGrVkkl1dxjWzYIB170NYrQACsfaFFD+5hFLIqBwHK4Fne
	mMi4odOk3kElRmwQSFhcwfoT1U+z39KKlYcOE7DxyYnVjly/+EMb4EhiPd//jmcJbU+6Bun8qTg
	7STdxN0QQngGO6zo1IE/KEyLhMyKfcicGEkOsM5gHwNM=
X-Google-Smtp-Source: AGHT+IGsQ+Yskv/y5MNpAgASidKsFYh3eb6ZHby3u9rd3zq4em3ovN9Nd2iiF66hyV/9mYpjFM4iHQ==
X-Received: by 2002:a17:90b:3ec5:b0:313:bf67:b354 with SMTP id 98e67ed59e1d1-31f5dd124c2mr13479817a91.0.1754004010362;
        Thu, 31 Jul 2025 16:20:10 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:09 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:27 -0700
Subject: [PATCH v19 17/27] riscv/signal: save and restore of shadow stack
 for signal
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-17-09b468d7beab@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>, Andy Chiu <andybnac@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 4tbxhhaozau4iib9ujmru3zgc7yo8ggd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8B8D714000C
X-Rspam-User: 
X-HE-Tag: 1754004011-123287
X-HE-Meta: U2FsdGVkX18SmiGKJ4rmt0v2jGQ+/23JNdbfK1E3MmPe2u9xLna+10ipPdV7gUkUi/WcgMDxErc6+OZBtpitX1lagNcJC7TPHl9EQJY2pMWP16qbQSdJYlKRUFjHG7F8ZsKGbP0iUsrcxDLQefpZ/OdMY0S52K76djvn3sgyR5VwYmACkJylE4gyUKkIOgD0aol7PvH2dL21mRXuG2i8yqtVCbRYxq71l7wpf4RQxKh3MyPD85DUCICLDsybXDVph/1H65FWzJbM6W7WsdDzHBdDf2P47p0EnYPN2VTxvIbxuvUzJ0GmlbypJ+W3JrLqppul3vp3UH0G0CX0ZKru5zkDNzyvjGVJAJrEJ2bZuLMipRFnCDmIjZIyqTC4nfY0Bx7wHLikBfSZ5Reqr55V9CmqWDtJVnGIsHsWzX9zzGtqOQgozWIKyp300CJ6RYO+ogWC3vGqZo5CGC62wrUUDpOZYra0XFHJav7crqMBQnDWxFG5i0MGNmi8P0Icjavg9IItjnvMCnohCo8geRZLHt00tALwuxI5a/c+8sncx6/Y2YgjpXA8BsZ3gSgmFA+y+w0VI41WLRCfsn24B5Jb4r2UUyipJODDG1AYdk6PcwRenNmcT5utPq+kzQ7MVesLp7afm/xcWSZzJKxemq0Ee4e2npcKELz+dxbzN0bjHPUBDfRGDM9di+z0hESGO/Q85CId5WGr8d7DbvYnheh5tv4kaw84l8CteGw+AaDgFEACN17kFlNff0ghGDyxxPkuqYeHRouCuYHEIx0PVtviiLpmX4IvXiABL3cxIE3+CrjxkYMPX3Uzx1isKmqebtliH2cyPb4syEEpx73wrHTAvgV0E38bAB7cmlmtyQifH+8KpLuoC58D1x5/GvgzoHo9KqAdS6XMOd3qGz8NbNiTIlMtizbOiIulUv/m6LoteeBm0r4Wtneap1n9cT8J5e1kh2g6by6syQP7OPKMGSD
 l2dtimD5
 1l6VOCXglJJzG42y+u6GkIQkfWJIOLCcEySoYuJqvH+PAMwbb6KcqWdZs+pP3UCfWfYZAohf/X8Y5AuYu/EkplxenGsf81pVADKRKFlCbNK09tZr55rT+wV3IgGC6x5xyXVHXb6cRuJZW1Cc1XtcMrwM+GDTTkyb9KmrDVKusqwfEo2LEHNcJtXtxq3sreXMCmizXm+1A07wLn4UIzP4DJDavRpjgm1420L3jpOFZVnJj1m6L7b2CQczd32CVP+tnvsdvh3asJruunFZLISX7T4Dd+lTq0TTOvxj/eeSYJvzfr/T7m/CKWtRoZlNjPCg+Y0yVQHZUBJyPCrwZVrM/YW+ypBaLodUcdwD0GGRb5TBicIJoLAva336mjMbH7qdVywwU3LQJwEkvbR3n74C2UEvy2bYxE5+t3WQLBOIGRBtWRndXmhNGlMH7BCsA/29cEIVZZqXzrDJImGtOnfB0v5XPhFexLOssjvjvPj7hns4ouXDMdpef5BPkfo1T15xcyssS5RscnFJbxNgXJ9YMgAsv1jJOw+lENV1+QdHL+TVZ1qfY4l/5x1Tpaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Save shadow stack pointer in sigcontext structure while delivering signal.
Restore shadow stack pointer from sigcontext on sigreturn.

As part of save operation, kernel uses `ssamoswap` to save snapshot of
current shadow stack on shadow stack itself (can be called as a save
token). During restore on sigreturn, kernel retrieves token from top of
shadow stack and validates it. This allows that user mode can't arbitrary
pivot to any shadow stack address without having a token and thus provide
strong security assurance between signaly delivery and sigreturn window.

Use ABI compatible way of saving/restoring shadow stack pointer into
signal stack. This follows what Vector extension, where extra registers
are placed in a form of extension header + extension body in the stack.
The extension header indicates the size of the extra architectural
states plus the size of header itself, and a magic identifier of the
extension. Then, the extensions body contains the new architectural
states in the form defined by uapi.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h         | 10 ++++
 arch/riscv/include/uapi/asm/ptrace.h     |  4 ++
 arch/riscv/include/uapi/asm/sigcontext.h |  1 +
 arch/riscv/kernel/signal.c               | 86 ++++++++++++++++++++++++++++++++
 arch/riscv/kernel/usercfi.c              | 56 +++++++++++++++++++++
 5 files changed, 157 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index 98820d93c6e1..54add512a4dc 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -8,6 +8,7 @@
 #ifndef __ASSEMBLY__
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/errno.h>
 
 struct task_struct;
 struct kernel_clone_args;
@@ -34,6 +35,9 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+unsigned long get_active_shstk(struct task_struct *task);
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr);
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr);
 bool is_indir_lp_enabled(struct task_struct *task);
 bool is_indir_lp_locked(struct task_struct *task);
 void set_indir_lp_status(struct task_struct *task, bool enable);
@@ -71,6 +75,12 @@ void set_indir_lp_lock(struct task_struct *task);
 
 #define set_indir_lp_lock(task) do {} while (0)
 
+#define restore_user_shstk(tsk, shstk_ptr) -EINVAL
+
+#define save_user_shstk(tsk, saved_shstk_ptr) -EINVAL
+
+#define get_active_shstk(task) 0UL
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/riscv/include/uapi/asm/ptrace.h b/arch/riscv/include/uapi/asm/ptrace.h
index a38268b19c3d..659ea3af5680 100644
--- a/arch/riscv/include/uapi/asm/ptrace.h
+++ b/arch/riscv/include/uapi/asm/ptrace.h
@@ -127,6 +127,10 @@ struct __riscv_v_regset_state {
  */
 #define RISCV_MAX_VLENB (8192)
 
+struct __sc_riscv_cfi_state {
+	unsigned long ss_ptr;   /* shadow stack pointer */
+};
+
 #endif /* __ASSEMBLY__ */
 
 #endif /* _UAPI_ASM_RISCV_PTRACE_H */
diff --git a/arch/riscv/include/uapi/asm/sigcontext.h b/arch/riscv/include/uapi/asm/sigcontext.h
index cd4f175dc837..f37e4beffe03 100644
--- a/arch/riscv/include/uapi/asm/sigcontext.h
+++ b/arch/riscv/include/uapi/asm/sigcontext.h
@@ -10,6 +10,7 @@
 
 /* The Magic number for signal context frame header. */
 #define RISCV_V_MAGIC	0x53465457
+#define RISCV_ZICFISS_MAGIC		0x9487
 #define END_MAGIC	0x0
 
 /* The size of END signal context header. */
diff --git a/arch/riscv/kernel/signal.c b/arch/riscv/kernel/signal.c
index a5e3d54fe54b..1bcda11e0680 100644
--- a/arch/riscv/kernel/signal.c
+++ b/arch/riscv/kernel/signal.c
@@ -22,11 +22,13 @@
 #include <asm/vector.h>
 #include <asm/csr.h>
 #include <asm/cacheflush.h>
+#include <asm/usercfi.h>
 
 unsigned long signal_minsigstksz __ro_after_init;
 
 extern u32 __user_rt_sigreturn[2];
 static size_t riscv_v_sc_size __ro_after_init;
+static size_t riscv_zicfiss_sc_size __ro_after_init;
 
 #define DEBUG_SIG 0
 
@@ -140,6 +142,62 @@ static long __restore_v_state(struct pt_regs *regs, void __user *sc_vec)
 	return copy_from_user(current->thread.vstate.datap, datap, riscv_v_vsize);
 }
 
+static long save_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err = 0;
+
+	if (!is_shstk_enabled(current))
+		return 0;
+
+	/*
+	 * Save a pointer to shadow stack itself on shadow stack as a form of token.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments. Any
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err |= save_user_shstk(current, &ss_ptr);
+	err |= __put_user(ss_ptr, &state->ss_ptr);
+	if (unlikely(err))
+		return -EFAULT;
+
+	return riscv_zicfiss_sc_size;
+}
+
+static long __restore_cfiss_state(struct pt_regs *regs, void __user *sc_cfi)
+{
+	struct __sc_riscv_cfi_state __user *state = sc_cfi;
+	unsigned long ss_ptr = 0;
+	long err;
+
+	/*
+	 * Restore shadow stack as a form of token stored on shadow stack itself as a safe
+	 * way to restore.
+	 * A token on shadow gives following properties
+	 * - Safe save and restore for shadow stack switching. Any save of shadow stack
+	 *   must have had saved a token on shadow stack. Similarly any restore of shadow
+	 *   stack must check the token before restore. Since writing to shadow stack with
+	 *   address of shadow stack itself is not easily allowed. A restore without a save
+	 *   is quite difficult for an attacker to perform.
+	 * - A natural break. A token in shadow stack provides a natural break in shadow stack
+	 *   So a single linear range can be bucketed into different shadow stack segments.
+	 *   sspopchk will detect the condition and fault to kernel as sw check exception.
+	 */
+	err = __copy_from_user(&ss_ptr, &state->ss_ptr, sizeof(unsigned long));
+
+	if (unlikely(err))
+		return err;
+
+	return restore_user_shstk(current, ss_ptr);
+}
+
 struct arch_ext_priv {
 	__u32 magic;
 	long (*save)(struct pt_regs *regs, void __user *sc_vec);
@@ -150,6 +208,10 @@ struct arch_ext_priv arch_ext_list[] = {
 		.magic = RISCV_V_MAGIC,
 		.save = &save_v_state,
 	},
+	{
+		.magic = RISCV_ZICFISS_MAGIC,
+		.save = &save_cfiss_state,
+	},
 };
 
 const size_t nr_arch_exts = ARRAY_SIZE(arch_ext_list);
@@ -202,6 +264,12 @@ static long restore_sigcontext(struct pt_regs *regs,
 
 			err = __restore_v_state(regs, sc_ext_ptr);
 			break;
+		case RISCV_ZICFISS_MAGIC:
+			if (!is_shstk_enabled(current) || size != riscv_zicfiss_sc_size)
+				return -EINVAL;
+
+			err = __restore_cfiss_state(regs, sc_ext_ptr);
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -223,6 +291,16 @@ static size_t get_rt_frame_size(bool cal_all)
 			total_context_size += riscv_v_sc_size;
 	}
 
+	if (is_shstk_enabled(current))
+		total_context_size += riscv_zicfiss_sc_size;
+
+	/*
+	 * Preserved a __riscv_ctx_hdr for END signal context header if an
+	 * extension uses __riscv_extra_ext_header
+	 */
+	if (total_context_size)
+		total_context_size += sizeof(struct __riscv_ctx_hdr);
+
 	frame_size += total_context_size;
 
 	frame_size = round_up(frame_size, 16);
@@ -359,6 +437,11 @@ static int setup_rt_frame(struct ksignal *ksig, sigset_t *set,
 #ifdef CONFIG_MMU
 	regs->ra = (unsigned long)VDSO_SYMBOL(
 		current->mm->context.vdso, rt_sigreturn);
+
+	/* if bcfi is enabled x1 (ra) and x5 (t0) must match. not sure if we need this? */
+	if (is_shstk_enabled(current))
+		regs->t0 = regs->ra;
+
 #else
 	/*
 	 * For the nommu case we don't have a VDSO.  Instead we push two
@@ -487,6 +570,9 @@ void __init init_rt_signal_env(void)
 {
 	riscv_v_sc_size = sizeof(struct __riscv_ctx_hdr) +
 			  sizeof(struct __sc_riscv_v_state) + riscv_v_vsize;
+
+	riscv_zicfiss_sc_size = sizeof(struct __riscv_ctx_hdr) +
+			  sizeof(struct __sc_riscv_cfi_state);
 	/*
 	 * Determine the stack space required for guaranteed signal delivery.
 	 * The signal_minsigstksz will be populated into the AT_MINSIGSTKSZ entry
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 2ebe789caa6b..8bc3e1e3f712 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -52,6 +52,11 @@ void set_active_shstk(struct task_struct *task, unsigned long shstk_addr)
 	task->thread_info.user_cfi_state.user_shdw_stk = shstk_addr;
 }
 
+unsigned long get_active_shstk(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.user_shdw_stk;
+}
+
 void set_shstk_status(struct task_struct *task, bool enable)
 {
 	if (!cpu_supports_shadow_stack())
@@ -169,6 +174,57 @@ static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
 	return 0;
 }
 
+/*
+ * Save user shadow stack pointer on shadow stack itself and return pointer to saved location
+ * returns -EFAULT if operation was unsuccessful
+ */
+int save_user_shstk(struct task_struct *tsk, unsigned long *saved_shstk_ptr)
+{
+	unsigned long ss_ptr = 0;
+	unsigned long token_loc = 0;
+	int ret = 0;
+
+	if (saved_shstk_ptr == NULL)
+		return -EINVAL;
+
+	ss_ptr = get_active_shstk(tsk);
+	ret = create_rstor_token(ss_ptr, &token_loc);
+
+	if (!ret) {
+		*saved_shstk_ptr = token_loc;
+		set_active_shstk(tsk, token_loc);
+	}
+
+	return ret;
+}
+
+/*
+ * Restores user shadow stack pointer from token on shadow stack for task `tsk`
+ * returns -EFAULT if operation was unsuccessful
+ */
+int restore_user_shstk(struct task_struct *tsk, unsigned long shstk_ptr)
+{
+	unsigned long token = 0;
+
+	token = amo_user_shstk((unsigned long __user *)shstk_ptr, 0);
+
+	if (token == -1)
+		return -EFAULT;
+
+	/* invalid token, return EINVAL */
+	if ((token - shstk_ptr) != SHSTK_ENTRY_SIZE) {
+		pr_info_ratelimited(
+			"%s[%d]: bad restore token in %s: pc=%p sp=%p, token=%p, shstk_ptr=%p\n",
+			tsk->comm, task_pid_nr(tsk), __func__, (void *)(task_pt_regs(tsk)->epc),
+			(void *)(task_pt_regs(tsk)->sp), (void *)token, (void *)shstk_ptr);
+		return -EINVAL;
+	}
+
+	/* all checks passed, set active shstk and return success */
+	set_active_shstk(tsk, token);
+	return 0;
+}
+
 static unsigned long allocate_shadow_stack(unsigned long addr, unsigned long size,
 					   unsigned long token_offset, bool set_tok)
 {

-- 
2.43.0


