Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7056DD339B6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361106B0027; Fri,  5 Dec 2025 13:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F0786B0028; Fri,  5 Dec 2025 13:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201116B0029; Fri,  5 Dec 2025 13:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E62E6B0027
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DB4F112D6D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:20 +0000 (UTC)
X-FDA: 84186275040.12.5492D5F
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id E0E3D1A000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="NmaBOa/O";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959839; a=rsa-sha256;
	cv=none;
	b=lNLz7OXdQTOB7EHFhljVZcmNCKqcaDZ9maggu9CKTScnll6wa2F8/DRbkrz2CkdEgk8U4T
	ADbUGkQAFel5tOWeCrKKcqWKDq3L+skzVd3KU/2m0wz5cHc6iIuQVR1DQtf8Gsyn1Tf+8g
	c4cRGTV9menOo7BRLhjOKy+YEGuN0jE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b="NmaBOa/O";
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
	b=IncoGHPJF6EAGz4B9ZGU1kmMN7W3yKdwIa9H7SIG+GTi+plObHXISJYlr8/wr8TIILmOtE
	9SEXzjW+VOJt1LE9otY31dJo5k2JzaZ1zon9FV7eH1Hj4Qfki1+iMSfoHrxJ1DusjH/9ot
	mpufmhjA7rup1dVtGzFosBn4wmLQvzs=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bc8ceb76c04so1631364a12.1
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959838; x=1765564638; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
        b=NmaBOa/OudrCbxVZlRnwutWsy5DFrOarkBSwJKhWfobDn/8qrmq1BZg2EaUyq6rsjP
         2LXukosr+aoCKCATzZuvYAWozeekqateEditAYRQRrW3AnPWPBdbSqOQJoUvAdflNLJa
         Q8tWvOHk4+xXc5YoPEAIQAzgBo3hD4JqSfn3NaDq63hf46ciZojamJWIOSzwVPbGw/3c
         vtsBK3PLr43+1Vt5lAW714g8lDDC1RoUDhzFbJgjPMOd+Ltda/zpLO63dJ1Y2KiJzw0O
         Mz6M3q6hH1tf8K0Dc7jjaTfZVV8Cdzb4TfR21xeD9GeHHeqnOCrzEy4xZlzpoZGqqj5G
         A66A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959838; x=1765564638;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mHOUzGluaxo3JyDkvm0DelDdzPjfzrCQtbG2RJzIJW4=;
        b=AO1n74TPizeSmpOMv7NelJQZnLjkm0VJQh2zXNKD8zY1Ob5vBqTKEkt4rDE4whim5g
         6U5MS8xvyGMsKNCBRBCd6gTltq+fOXpJ65tL0LxhkU2s+y6Ac7ZttbKvsXZrjKRMyUUL
         twALsDS4QunQ1va82EnFtlqITeKYp82XuaasIiyKKDuNENm2wC9kTBx0xemVyimm7t+d
         OGKHfCwIqOiLxzV9zgttNMX5XTBRU5T3knRvMpVEYuvSw2Sr0NY1yXKCdlr8P1QOloJJ
         9e2/oUdo9tNy31Jm1FClnbzDHMZJpt0iyYtlYWhY/sc748YxpVAnKLGxv762PqL7j9ZJ
         uNnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzNtMX2HyCmgL+4zNI36zQDaLrPr+FgwaGcLQMA7KzMd8C7kMcJdW/OsGhIigGXnoyM3aeqxUU+g==@kvack.org
X-Gm-Message-State: AOJu0YxvrhB7tvCcx05dBwm4oOhFPPoctXxUh2ShBBZ8TncR4VXBRC3p
	B4sQX3Nf5Bz4thEzgwi5VEvQ4j3wQLRELU+h0PA9hthr9v/kCafv5oouYAPg5VTgx+w=
X-Gm-Gg: ASbGncumilwXMDcaPL7eAnDICSWeWsGV1tdvVLz5Mb+k3IkVTqLWh2B9noQyx8JhtkD
	vPaRJRGtcV1zT/6G2/VbfJNfzZHI/P6ieFd9Q4F4kslFPaO35Sji1Rv82RwjrrUdOMBattHTtqj
	ZqjlEtmR+ThIdTj3wsgqRjgO6C3Pn3qD9MCNwuC7KIW9MZZRJe4b9dV7QUUlv/VYYanvvMI1MD4
	C2LMm4wmWRx1b1LOmn5Y5GfUqXI0780T44umxvisQIjuDX/ooMZuzr/QY4mws96q+dm7GumEm1b
	H3S6w4luFC7miZlRN0LEmj3HV5MccTY0cx9YMQ3gqiRKL7C8wJSlLrUf5tpJesLObGnXMb4+knX
	chVm0KZ9wmbG/VW9Ixa3MLAyis9GFU8WdbUSAwwx8HEm+ML1hAjXVo3kths1Ndd187udtxfqxKV
	uDUTiWf0LVefOJwMXzWEHV
X-Google-Smtp-Source: AGHT+IGLTrrCtXcGmmxnDoQfXwx9uhsFmgpb9j2ScxkIjH1KZoJge0J7eqrQSHZ8u0fnDLyVdyXpGg==
X-Received: by 2002:a05:7300:3aa8:b0:2a4:3593:c7c8 with SMTP id 5a478bee46e88-2abc70f7fbdmr100006eec.8.1764959837647;
        Fri, 05 Dec 2025 10:37:17 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:17 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:00 -0800
Subject: [PATCH v25 14/28] riscv: Implements arch agnostic indirect branch
 tracking prctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-14-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=5844;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=BmRDk5kl415SSdS7KRLKb7mvXOYSjIyVafSykDVbYjI=;
 b=0zO7j0dPtUSFG/lEXOF3IOd6jYK0QALrQ6LO0ubQF3ObfnkufB6JTzH+xs4ToxaCsHBJt1br9
 Jo1/5p6QUJWCaW75Afzjyv0Z03HwU5JIU43/ILV7VZuSzWQmUyfX0O2
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0E3D1A000E
X-Stat-Signature: tokq3nhsf6qyh8eosjfm9wf6duqkxy7x
X-Rspam-User: 
X-HE-Tag: 1764959838-275003
X-HE-Meta: U2FsdGVkX19uoIgQWOkTtBl+QtsaXbRMhAXqdJ6XGQQe6FEmz+VQhWeo95b8+2YX4cECcpaIeTmDSg1OJ6HYcTfPwe8zGNj/AxRk2+zc287yLo7GG3Xfs4hrk/LtO6mDp1UyTPncyrV7iQmwOw+FhC2IKjNtknVXmLdwYzHqpyQlnHtucmVuD3CT5wXlay+2PEFqdJSnNdsnyW1pfYWXN8PJMPXAQR7XGO07TYW0BdmyeZcFnJYQgLAkI2CvHFx1dv5/xTYW9NyCRYvrZawSd8AW85cejmYfxUyxS/rDZECx3jeHyGSjLrUXGJ1k4rRyEOspdQZ7jIcAZDQauhR15MVBl201FTBD7QeZ5nJua571pE7vvFlMGGxZPsqPb9meTXUP1CTS/DxU45kARMurtYlH9bm11dBzcZprikfDxmTPRroxFl1YghCU55nWtMN8rC42PeIsx0UCehCHJdB//BRsZpnZm/T39NTIgQ3Kv5LlZEH93LIclFQTTYQnn9f5uovE1+4e4CxT7Hg5eeHKFd+5F05ni5pBeFCB8x4g69H+gFqrnt4m58Pvb6Q0JPFnuZnEHScJoWqc2CT2fATExRSzlu8JQMUeIHthlXStiAWZ/zZA9TpM2Ms92ssQWe24XBlrbsV5mHpx5kXA7AAFcVCT+GWjzkZOV/IRk6LwJkjhC32T2DCBxCExBvCzGMRKYOstjvS2gmSXrdK2MWTM2NeP4Cf3jiTMbzUgpTnaTPOBzghYGGlBfUD6qYLy1u6hcqZAFYV1xJZ5wrgyi+aaK3ZbHGjM5u1ZldkfKF4//MVLewGnfnGtS/v5jAgeRm57QprlV5VBccn4TRfqLNExBx3JP0lryWPKuhj96u/9yoihtTzMEXZnLd1qLUxpR1ZNHa3AhDTY+UA2zhDxypCx0bKktW6eqIGxXWIkdQMxaWArPbUEn25Ns7PbyTIXH+wfKkgnjQ2KJgjeqQRsxNy
 C8XBZtzN
 nywJObRHrwYUz/GUWbLnPzOFSMiXTyXyTQ9U0gD5NaJ3BcaKHT8kkRIKwbtUeeaeQ7Ig/rJQ+9CPWrHfQRVkstWicwEgLgHaxrBHMTvtZ/5pMVB/Fdaszu0LBFi8aD5u072NUsm1iSVc1PPdCIHQKt+Lxy1+Tu8FpTWjgRaODSjStC3i+2ZhQ8TVbZnnfcqFRCd9DugGzZBLyIsJNGW19hCUuD2sQCryMlPcTJDPye9byYIefmZVRV6Glvp+Ol9EK79P2XhPBJkM3snJk6kKrgtCpTA+ygkpfxWsSPSVWAxPOqunbCbSQZLk6hztBt5k/zD4PUWaOSelzsa29uPQsmxXdxPTvjo95Ush5u+vaaFOX5Cnd5fqbEQyHuY0qjEi0o/zYzkKCu265aebdQjr2fBBa3oxCL6NhVmcXGSLjZXz2nehytflcgUsUUUKLXIO34PpizkkX1dsWSXDD1VjtJcvBrP1QnXTUn96xpAEZz00oMbyTrr47TPBsNKIQL4ej9VocV2hoXaYdAYGoxP9PSJ/ZzPRWs8MGeUK1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prctls implemented are:
PR_SET_INDIR_BR_LP_STATUS, PR_GET_INDIR_BR_LP_STATUS and
PR_LOCK_INDIR_BR_LP_STATUS

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/usercfi.h | 14 +++++++
 arch/riscv/kernel/entry.S        |  4 ++
 arch/riscv/kernel/process.c      |  5 +++
 arch/riscv/kernel/usercfi.c      | 79 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 102 insertions(+)

diff --git a/arch/riscv/include/asm/usercfi.h b/arch/riscv/include/asm/usercfi.h
index d71093f414df..4501d741a609 100644
--- a/arch/riscv/include/asm/usercfi.h
+++ b/arch/riscv/include/asm/usercfi.h
@@ -16,6 +16,8 @@ struct kernel_clone_args;
 struct cfi_state {
 	unsigned long ubcfi_en : 1; /* Enable for backward cfi. */
 	unsigned long ubcfi_locked : 1;
+	unsigned long ufcfi_en : 1; /* Enable for forward cfi. Note that ELP goes in sstatus */
+	unsigned long ufcfi_locked : 1;
 	unsigned long user_shdw_stk; /* Current user shadow stack pointer */
 	unsigned long shdw_stk_base; /* Base address of shadow stack */
 	unsigned long shdw_stk_size; /* size of shadow stack */
@@ -32,6 +34,10 @@ bool is_shstk_locked(struct task_struct *task);
 bool is_shstk_allocated(struct task_struct *task);
 void set_shstk_lock(struct task_struct *task);
 void set_shstk_status(struct task_struct *task, bool enable);
+bool is_indir_lp_enabled(struct task_struct *task);
+bool is_indir_lp_locked(struct task_struct *task);
+void set_indir_lp_status(struct task_struct *task, bool enable);
+void set_indir_lp_lock(struct task_struct *task);
 
 #define PR_SHADOW_STACK_SUPPORTED_STATUS_MASK (PR_SHADOW_STACK_ENABLE)
 
@@ -57,6 +63,14 @@ void set_shstk_status(struct task_struct *task, bool enable);
 
 #define set_shstk_status(task, enable) do {} while (0)
 
+#define is_indir_lp_enabled(task) false
+
+#define is_indir_lp_locked(task) false
+
+#define set_indir_lp_status(task, enable) do {} while (0)
+
+#define set_indir_lp_lock(task) do {} while (0)
+
 #endif /* CONFIG_RISCV_USER_CFI */
 
 #endif /* __ASSEMBLER__ */
diff --git a/arch/riscv/kernel/entry.S b/arch/riscv/kernel/entry.S
index 8410850953d6..036a6ca7641f 100644
--- a/arch/riscv/kernel/entry.S
+++ b/arch/riscv/kernel/entry.S
@@ -174,6 +174,10 @@ SYM_CODE_START(handle_exception)
 	 * or vector in kernel space.
 	 */
 	li t0, SR_SUM | SR_FS_VS
+#ifdef CONFIG_64BIT
+	li t1, SR_ELP
+	or t0, t0, t1
+#endif
 
 	REG_L s0, TASK_TI_USER_SP(tp)
 	csrrc s1, CSR_STATUS, t0
diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index a137d3483646..49f527e3acfd 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -163,6 +163,11 @@ void start_thread(struct pt_regs *regs, unsigned long pc,
 	set_shstk_status(current, false);
 	set_shstk_base(current, 0, 0);
 	set_active_shstk(current, 0);
+	/*
+	 * disable indirect branch tracking on exec.
+	 * libc will enable it later via prctl.
+	 */
+	set_indir_lp_status(current, false);
 
 #ifdef CONFIG_64BIT
 	regs->status &= ~SR_UXL;
diff --git a/arch/riscv/kernel/usercfi.c b/arch/riscv/kernel/usercfi.c
index 0b77b812e4d7..a384ce9ed25c 100644
--- a/arch/riscv/kernel/usercfi.c
+++ b/arch/riscv/kernel/usercfi.c
@@ -72,6 +72,35 @@ void set_shstk_lock(struct task_struct *task)
 	task->thread_info.user_cfi_state.ubcfi_locked = 1;
 }
 
+bool is_indir_lp_enabled(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_en;
+}
+
+bool is_indir_lp_locked(struct task_struct *task)
+{
+	return task->thread_info.user_cfi_state.ufcfi_locked;
+}
+
+void set_indir_lp_status(struct task_struct *task, bool enable)
+{
+	if (!cpu_supports_indirect_br_lp_instr())
+		return;
+
+	task->thread_info.user_cfi_state.ufcfi_en = enable ? 1 : 0;
+
+	if (enable)
+		task->thread.envcfg |= ENVCFG_LPE;
+	else
+		task->thread.envcfg &= ~ENVCFG_LPE;
+
+	csr_write(CSR_ENVCFG, task->thread.envcfg);
+}
+
+void set_indir_lp_lock(struct task_struct *task)
+{
+	task->thread_info.user_cfi_state.ufcfi_locked = 1;
+}
 /*
  * If size is 0, then to be compatible with regular stack we want it to be as big as
  * regular stack. Else PAGE_ALIGN it and return back
@@ -370,3 +399,53 @@ int arch_lock_shadow_stack_status(struct task_struct *task,
 
 	return 0;
 }
+
+int arch_get_indir_br_lp_status(struct task_struct *t, unsigned long __user *status)
+{
+	unsigned long fcfi_status = 0;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is enabled on the task or not */
+	fcfi_status |= (is_indir_lp_enabled(t) ? PR_INDIR_BR_LP_ENABLE : 0);
+
+	return copy_to_user(status, &fcfi_status, sizeof(fcfi_status)) ? -EFAULT : 0;
+}
+
+int arch_set_indir_br_lp_status(struct task_struct *t, unsigned long status)
+{
+	bool enable_indir_lp = false;
+
+	if (!cpu_supports_indirect_br_lp_instr())
+		return -EINVAL;
+
+	/* indirect branch tracking is locked and further can't be modified by user */
+	if (is_indir_lp_locked(t))
+		return -EINVAL;
+
+	/* Reject unknown flags */
+	if (status & ~PR_INDIR_BR_LP_ENABLE)
+		return -EINVAL;
+
+	enable_indir_lp = (status & PR_INDIR_BR_LP_ENABLE);
+	set_indir_lp_status(t, enable_indir_lp);
+
+	return 0;
+}
+
+int arch_lock_indir_br_lp_status(struct task_struct *task,
+				 unsigned long arg)
+{
+	/*
+	 * If indirect branch tracking is not supported or not enabled on task,
+	 * nothing to lock here
+	 */
+	if (!cpu_supports_indirect_br_lp_instr() ||
+	    !is_indir_lp_enabled(task) || arg != 0)
+		return -EINVAL;
+
+	set_indir_lp_lock(task);
+
+	return 0;
+}

-- 
2.45.0


