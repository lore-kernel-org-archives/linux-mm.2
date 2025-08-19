Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736F6CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 13:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F798E0037; Tue, 19 Aug 2025 09:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF6A8E0007; Tue, 19 Aug 2025 09:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC98B8E0037; Tue, 19 Aug 2025 09:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D59948E0007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 09:50:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9C5071407BA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:32 +0000 (UTC)
X-FDA: 83793641904.02.0068F4D
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB0D61A0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:50:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=c0HkI+GS;
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755611430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LwTW7izUdo6CYD8//HAPF56SDtcFaT3RKPdG1y/WRl0=;
	b=J5gtGTQmolEiYJuuWleMY9oD0mmjm2BLFANuHriojhaAd3vcHLnNUQ4j4oUmY5JijCSAXf
	27FAI7MTwgWL9tUsq7bEwsyum8Lzdb/PKJ0/1HvIF6l78gcXVkrWORrttcGnAxtdw5Bevv
	wCaPAO0cCxhZ2gmMiGfl9w3znguTfYI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=c0HkI+GS;
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755611430; a=rsa-sha256;
	cv=none;
	b=Jrj6ZoT7M4LDjUm+rjx0zTZH1LjbMT7Uk6HhfiFsHkiqrIjmQwzoEMC9NlKKUHXSz3czLc
	iu/LDudSjcZ0KKpf7JXd7m1NR2o4OqYr/u7fxD1Ao3jzNInQsJFRgLayj4JE2JbBBa53oA
	ZPqVYCQyb6m0MarrxDSHwt8FUUkpCMQ=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4746fd4793so1811141a12.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755611429; x=1756216229; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LwTW7izUdo6CYD8//HAPF56SDtcFaT3RKPdG1y/WRl0=;
        b=c0HkI+GSBrJmERsqsUW4ub8k0WYhjRUi9yb94ATzLxlqM6WMLg0dEk5hSpOGiOgMxO
         7ywFhDCjOkmJscCh/y/cSmuz3M27/alOc3TUPAVFtScOaJPI+YE2GvjFapOfOyNdl0YZ
         1qZxz6IEs0Lq59S9+lzQb0ECnkQYeiztdKzoyM19fmT/xQdqvlNSehRDxVL7geSdydkt
         8cge3NzM7v3YnEeg/YLZ/mXR/T8ktaa3Z5Kf2p+ULX5l2j/dxC+R3D/LEG8pG0Lw7Jyn
         XSDA1f8Ofs4Ty2koty+t+5bldPgjTMhL8Ah6XERWyWmEzLOU3PPxoiJohJRQsSF06gvb
         RWpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755611429; x=1756216229;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LwTW7izUdo6CYD8//HAPF56SDtcFaT3RKPdG1y/WRl0=;
        b=nlSV8+MXQvnJCXpyrNYDiuqbpHYLmrfavGrDr37Ax5uJD5LC7tYHFLm/+uDRFsgyBN
         ar6suSqZqKyvQ4oowBiIZ8ALookow9V31qEG0vEYxpitHXkD4cn6/B4xq6HmpmobIMaY
         5/uaFG8YOexVLZOvOzCMMwq2F2kFeK70ieZFv9vyqnejhruve1b9RczPVxhcgQKXQpDv
         IRqwFN9Bv4cJkaWKE62fiDlhKdaZiFfC+IKoSTFrXYyxv0qjuAyZAFwKgdeB16aDJ/gs
         i1KGSKRO2iwAt1OdFttQ4uYJ4MjKBkTt1eZzoK4zCa5tdduWP8gipdUfZ6VGGPmwYGYr
         BgAg==
X-Forwarded-Encrypted: i=1; AJvYcCUl5oBQ/eqZSvQw94aVRvsXmMQAgVEHc4RawCCCsRrB91RuFsGRkqSAes/xNTedBzJeOkSeQsqtSg==@kvack.org
X-Gm-Message-State: AOJu0YweY0jVNsgg5JNTAP5zgCAMMLc/VMJzZGo5VpqeR8xTnAoSQYYJ
	+z8YEhvuh/AdY3hFZpGFTZ/KG9RMMazhlN0kui2YQ+zHmRGnLIRg1zTwrO0mqKpvYEU=
X-Gm-Gg: ASbGnctrqVMepp2GkBiFAMQGfq9fYzaMTzLoLvmCEtlFFszxMDIs2b20N3HdVAkOTeK
	uLKMg+1ipP8ZhaU9E3XViJLPYI+gFPbJojVad9Yg7q1exVlrxWMY/Im+cV6VpdD35WLstLXZfXW
	u4jaxn/wUPAcVAEJppHYMGfZEJqQanTnWoRulLZdADVaNLrU+YnJBgnARfVhKB6Jvho3LX/J6mf
	WnzJpsjFlPCd86daq5wpW6dbq1RdoeowjC5exNVcU3KPQUI7d8+oBx202h2u0lSax6zzTQYsYqd
	ScZpqPPewnP8jrYyI2w4CrlCc5K6/sjySFIxWUrNGIrbRXan/hfU6kEZMCvrKMFzU4SyUEYXUsS
	ir+z2ccJNJXYwzgVTZtT6leJtHraH917tCcwXZDCcouTx0ImVC5Yc2CLz
X-Google-Smtp-Source: AGHT+IG3M4152x1Qa0AohjmhQrhbPKACbweaZeZYf2EtQOf2Ag/TgiWDxzHEJsq3FzMfjcT7SEZo1A==
X-Received: by 2002:a17:902:e545:b0:243:8f:6d7d with SMTP id d9443c01a7336-245e04e232fmr28790075ad.50.1755611429240;
        Tue, 19 Aug 2025 06:50:29 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.9])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2446d5533c4sm109937815ad.140.2025.08.19.06.50.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 19 Aug 2025 06:50:28 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	paul.walmsley@sifive.com,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	linux-mm@kvack.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH 2/2] riscv: introduce percpu.h into include/asm
Date: Tue, 19 Aug 2025 21:50:07 +0800
Message-Id: <20250819135007.85646-3-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20250819135007.85646-1-cuiyunhui@bytedance.com>
References: <20250819135007.85646-1-cuiyunhui@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB0D61A0002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: wc3z9ksn6fwrojh86ui5k46u34syigw1
X-HE-Tag: 1755611430-436810
X-HE-Meta: U2FsdGVkX1+l7WKjXcVaEsOpveY9UMW4z9tiizwJhl6gy7qCVNY7V7BrOIT/vHC/B1x5M9Vc445z+IugEFU1qujOC+wQWMvmH5fs6jS+9q1opX07P9aAwn1kXUYsMlZnFdm0j5tmmINighrr2EKSbpyMKRMZ/B20U4faPuj+qWtoua90nOzcMtHiOzDEQds4Hp9N31G53+ITls9EsH2mxYcfcg1CZWA8THs3vq7cSqDpplFleY6Wsg3rx9yrlNu4Hn61eecI3HZ4rG3IejDYHni4h1x8fw21n4qcf8m7vsOgKPmXSL1wJQjA3XJyRkRhGCdsxNhKVeN49yh52dUcqaPtLw8I1NTlcw+I2ZWuZujZlZE8M1kgbFFOpJK3Os37Z/bCgvohZ5n4TaXdwPdG/CwwIMUjA7/jFpJu4w/okItAAEjW28OxJL0zvCKYR+NDG6Mhs858BsYkSeXoXdpfs6ieuIfYQ6q80odGcoUSHCfyzOdTWSQtgyNS6MMZyAXpXv1SaPNN4AEUVMKKaA/GJugqiVtNLGg1tMDjDrWVgInqyz7paTxMaPNOeC0gDcj7NNHLC1SnPMVFRZt8VmIAfMAtJ+I/BvCazKWntICB2ivueCrT9o6medeJQWkJtINsd8Tr8SNzu+Nmg3SgC3FTwCGSmPpYO56qoIZGOXkfq9MVgKR894l+6EGynouPwgBDpTKjZd1u0HDYn4u08d+VZZcTbCpDBmxIuVKCVpYzIaSxnJBn87FXkmxyW0KOK90HJahxMrIV1eNbPhvH07uUBuy1Eb1/hJ+WexCA0NXFcZ0mz30XhVvCX7FhtUJkrCDUgxlTDw/ksacNyx/mQakCAwkTJRPKkkcnjIQ5lcxPu8er61nwH8iIMPhKnMPF9XJAHgGWHbd2mABHk7hHR6rx/gOoNHw6+DC4S8ruby0Pk0iN8W5RrKVxZnnVyR9KncQhtmWfip9+WXtrq4TDslR
 bR71lMOC
 z8mx73+ADaMIDs1tDsEVPFmPjZ4OsnqKBx+L2q0AuTWm7HyNMhzwJtiWJ6mystC/349XAr7VF35F+L8FNwEw/q4qTr8a/mgzDOY7GxMs3mvTrtcct+0cWjgBnRD0m+l9EwW2DjAnJLTML8RxYLDPG21BylbuqaLWqWCIPldQk5vEgtQabB1JS/hDaAzECqH/oaJl/sEjZ1ALHz3IqkIPUs/t8SmFxjnjk+gKPuY8XQtUTITyozD7C9NI6P/Tp5wlBQH5HZosBh03W+y4GeXA8n+fzho0T7RyZpEDtu90QQqD/wgPnlkVPCpBSHL2qDmKkLOKi9HsXkMIXvvGAQuQASP4sTxABWS+QAQKlTexW+frcLfzEQfwy3KF3iTi6f23BZg1Z
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Current percpu operations rely on generic implementations, where
raw_local_irq_save() introduces substantial overhead. Optimization
is achieved through atomic operations and preemption disabling.

Since RISC-V does not support lr/sc.b/h, when ZABHA is not supported,
we need to use lr/sc.w instead, which requires some additional mask
operations. In fact, 8/16-bit per-CPU operations are very few. The
counts during system startup are as follows:
Reads: 8-bit: 3, 16-bit: 3, 32-bit: 1531, 64-bit: 471
Writes: 8-bit: 4, 16-bit: 3, 32-bit: 32, 64-bit: 238
Adds: 8-bit: 3, 16-bit: 3, 32-bit: 31858, 64-bit: 7656
Add-Returns: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 2
ANDs: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 0
ANDNOTs: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 0
ORs: 8-bit: 0, 16-bit: 0, 32-bit: 70, 64-bit: 0

hackbench -l 1000:
Reads: 8-bit: 3, 16-bit: 3, 32-bit: 1531, 64-bit: 2522158
Writes: 8-bit: 4, 16-bit: 3, 32-bit: 34, 64-bit: 2521522
Adds: 8-bit: 3, 16-bit: 3, 32-bit: 47771, 64-bit: 19911
Add-Returns: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 2
ANDs: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 0
ANDNOTs: 8-bit: 0, 16-bit: 0, 32-bit: 0, 64-bit: 0
ORs: 8-bit: 0, 16-bit: 0, 32-bit: 70, 64-bit: 0

Based on this, 8bit/16bit per-CPU operations can directly fall back to
the generic implementation.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 138 ++++++++++++++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 arch/riscv/include/asm/percpu.h

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
new file mode 100644
index 0000000000000..5a1fdb37a8056
--- /dev/null
+++ b/arch/riscv/include/asm/percpu.h
@@ -0,0 +1,138 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __ASM_PERCPU_H
+#define __ASM_PERCPU_H
+
+#include <linux/preempt.h>
+
+#define PERCPU_RW_OPS(sz)						\
+static inline unsigned long __percpu_read_##sz(void *ptr)		\
+{									\
+	return READ_ONCE(*(u##sz *)ptr);				\
+}									\
+									\
+static inline void __percpu_write_##sz(void *ptr, unsigned long val)	\
+{									\
+	WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);				\
+}
+
+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
+static inline void							\
+__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)		\
+{									\
+	asm volatile (							\
+		"amo" #amo_insn #sfx " zero, %[val], %[ptr]"		\
+		: [ptr] "+A" (*(u##sz *)ptr)				\
+		: [val] "r" ((u##sz)(val))				\
+		: "memory");						\
+}
+
+#define __PERCPU_AMO_RET_OP_CASE(sfx, name, sz, amo_insn)		\
+static inline u##sz							\
+__percpu_##name##_return_amo_case_##sz(void *ptr, unsigned long val)	\
+{									\
+	register u##sz ret;						\
+									\
+	asm volatile (							\
+		"amo" #amo_insn #sfx " %[ret], %[val], %[ptr]"		\
+		: [ptr] "+A" (*(u##sz *)ptr), [ret] "=r" (ret)		\
+		: [val] "r" ((u##sz)(val))				\
+		: "memory");						\
+									\
+	return ret + val;						\
+}
+
+#define PERCPU_OP(name, amo_insn)					\
+	__PERCPU_AMO_OP_CASE(.w, name, 32, amo_insn)			\
+	__PERCPU_AMO_OP_CASE(.d, name, 64, amo_insn)
+
+#define PERCPU_RET_OP(name, amo_insn)					\
+	__PERCPU_AMO_RET_OP_CASE(.w, name, 32, amo_insn)		\
+	__PERCPU_AMO_RET_OP_CASE(.d, name, 64, amo_insn)
+
+PERCPU_RW_OPS(8)
+PERCPU_RW_OPS(16)
+PERCPU_RW_OPS(32)
+PERCPU_RW_OPS(64)
+
+PERCPU_OP(add, add)
+PERCPU_OP(andnot, and)
+PERCPU_OP(or, or)
+PERCPU_RET_OP(add, add)
+
+#undef PERCPU_RW_OPS
+#undef __PERCPU_AMO_OP_CASE
+#undef __PERCPU_AMO_RET_OP_CASE
+#undef PERCPU_OP
+#undef PERCPU_RET_OP
+
+#define _pcp_protect(op, pcp, ...)					\
+({									\
+	preempt_disable_notrace();					\
+	op(raw_cpu_ptr(&(pcp)), __VA_ARGS__);				\
+	preempt_enable_notrace();					\
+})
+
+#define _pcp_protect_return(op, pcp, args...)				\
+({									\
+	typeof(pcp) __retval;						\
+	preempt_disable_notrace();					\
+	__retval = (typeof(pcp))op(raw_cpu_ptr(&(pcp)), ##args);	\
+	preempt_enable_notrace();					\
+	__retval;							\
+})
+
+#define this_cpu_read_1(pcp)		_pcp_protect_return(__percpu_read_8, pcp)
+#define this_cpu_read_2(pcp)		_pcp_protect_return(__percpu_read_16, pcp)
+#define this_cpu_read_4(pcp)		_pcp_protect_return(__percpu_read_32, pcp)
+#define this_cpu_read_8(pcp)		_pcp_protect_return(__percpu_read_64, pcp)
+
+#define this_cpu_write_1(pcp, val)	_pcp_protect(__percpu_write_8, pcp, (unsigned long)val)
+#define this_cpu_write_2(pcp, val)	_pcp_protect(__percpu_write_16, pcp, (unsigned long)val)
+#define this_cpu_write_4(pcp, val)	_pcp_protect(__percpu_write_32, pcp, (unsigned long)val)
+#define this_cpu_write_8(pcp, val)	_pcp_protect(__percpu_write_64, pcp, (unsigned long)val)
+
+#define this_cpu_add_4(pcp, val)	_pcp_protect(__percpu_add_amo_case_32, pcp, val)
+#define this_cpu_add_8(pcp, val)	_pcp_protect(__percpu_add_amo_case_64, pcp, val)
+
+#define this_cpu_add_return_4(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_32, pcp, val)
+
+#define this_cpu_add_return_8(pcp, val)		\
+_pcp_protect_return(__percpu_add_return_amo_case_64, pcp, val)
+
+#define this_cpu_and_4(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_32, pcp, ~val)
+#define this_cpu_and_8(pcp, val)	_pcp_protect(__percpu_andnot_amo_case_64, pcp, ~val)
+
+#define this_cpu_or_4(pcp, val)	_pcp_protect(__percpu_or_amo_case_32, pcp, val)
+#define this_cpu_or_8(pcp, val)	_pcp_protect(__percpu_or_amo_case_64, pcp, val)
+
+#define this_cpu_xchg_1(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_2(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_4(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+#define this_cpu_xchg_8(pcp, val)	_pcp_protect_return(xchg_relaxed, pcp, val)
+
+#define this_cpu_cmpxchg_1(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_2(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_4(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+#define this_cpu_cmpxchg_8(pcp, o, n)	_pcp_protect_return(cmpxchg_relaxed, pcp, o, n)
+
+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
+
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+({									\
+	typedef typeof(pcp) pcp_op_T__;					\
+	u128 old__, new__, ret__;					\
+	pcp_op_T__ *ptr__;						\
+	old__ = o;							\
+	new__ = n;							\
+	preempt_disable_notrace();					\
+	ptr__ = raw_cpu_ptr(&(pcp));					\
+	ret__ = cmpxchg128_local(ptr__, old__, new__);			\
+	preempt_enable_notrace();					\
+	ret__;								\
+})
+
+#include <asm-generic/percpu.h>
+
+#endif /* __ASM_PERCPU_H */
-- 
2.39.5


