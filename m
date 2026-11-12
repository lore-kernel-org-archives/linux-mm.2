Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B0E606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Phs5Xjjy
Received: by kanga.kvack.org (Postfix)
	id ABD8F6B05CB; Thu, 12 Nov 2026 05:44:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94586B05CC; Thu, 12 Nov 2026 05:44:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AAA46B05CD; Thu, 12 Nov 2026 05:44:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAD16B05CB
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:44:29 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B39A1A0570
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:28 +0000 (UTC)
X-FDA: 85426133016.07.059C808
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 92AED1A0002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Phs5Xjjy;
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480266;
	b=WnmEXPZFd7oaucwtIvbr4zEASfh1QlU7MgKAyBtKXng3HjTkBN1Cqf9UQAOcER6mClhAvW
	m47JMWIqp1gO9uU+de3/n/g3ACbh1ybkTG2/k2Uj1n3rXoUz+kXmq3AjM0HUL8kxqbAydC
	KtQg6qFkkbRIl5cm95r/FyPm9rmpK8s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Phs5Xjjy;
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c+0NQhm/2dySRhzukgerkWXzp7x9hEGESn4jnFASt64=;
	b=G4/X2UnxfqAshdoFmi0Z0h6HuefVm9aDnR5z5mhC9q/q+lAuFTUrpU3pEaJa9pdncZ20Wd
	3y62MACK/4fu5opLU8ZKMrL4SrbGMu/t1hNR7I1J5FTZVo1Er8Ug7XuK+D3lrrOwkanMlG
	MCscMn+/meLioXwvJl7KiMzvJm19O3k=
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-372bdb942dbso5286141eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480265; x=1795085065; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=c+0NQhm/2dySRhzukgerkWXzp7x9hEGESn4jnFASt64=;
        b=Phs5XjjyiLD6bxU/zW3f+wuEzddZ1l7Cf/xRek6sXTQd290+78QUPyWVZ03hpE6gNm
         /3av5kgeKOfuoW3jOsWR434ygf34ycr5E7ITpnDpoy09wbc+0oxRIgdTZokCe7LaQucE
         WmqKKhaBInafKuf7RSuOGcP2xMlWEx5BuDpdD//aBWysB/WLAu6+97KHftV10+BO6evg
         qEVIw8n6ra2tJKHGJcT+yVpJGmDD+84SzvQjgiuoJkEEaKAyiHZut+66H5m3kPKCsLIC
         I8PdLI8Cdmuj2fE3aegX2GlBkHFkQOTyId+uKzuhsJJlmUmSToFdkMfvL3tJdECCzvHQ
         ws0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480265; x=1795085065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=c+0NQhm/2dySRhzukgerkWXzp7x9hEGESn4jnFASt64=;
        b=VU6t2/tK2FWummDhur3PMq4ArPsg/vuVApnylQ5eqK5rCWDwlrRyhL7zMfezVHbXMi
         /w0/KY45CcJ2YGLibvyp3r+VqddcVH/4xad+uAvQWqcs22TWuTXfA9Q7IT/U8S8f+ZQU
         pEjf2nSUpYuMRR6/KbCQLodoe5oYF6Dkp9VjY7PDk3HKGGv5co7zGaHyAUaub4RhxfGg
         Q1WHGhqFUhjBHPtcs+ENLI8RFBTKx8olmMp+bB/On1+HRR8lTaSRuCZhUM7ck8W/vdpp
         /lpGGv1OiRVk6T1aLYeYGmKdGz7HMxqJ3qhsm9Qdtxwitp3l677kAcdPDkzEove9Jqvt
         NBIw==
X-Forwarded-Encrypted: i=1; AL+hErGD72kLSPDRKoMjW6PNcI1fbN+H956IYHLzRdYZD156CozNawoHUeMFtW/L7zQcjs1a8yVwzmMO+Q==@kvack.org
X-Gm-Message-State: APuU4Z82avCVxRbN69FRmp9qhk8XRfdfXDjMbsuFHWP28UI9y1k7i3tl
	C61RDnDH2QyrUAOsvt41XpFHNGjBNs7ZwEpqYbopc1H4+N6hFvqBkhsk/mMRbaedK/Y=
X-Gm-Gg: AYBFou39sLrll1ZH9KRUh/jdJmOuvzicWSd42OaaavUEMnoDM4g6s7TX/3kHc9M7wYO
	M9NrrwuIkJac51M3/hlNGnEvHh+T9Px5lKygxgnwyLX1po7bz+pIgkR9TJjzQ1SLqYGBLMK4I9U
	0e6mcfU+cBQPCyh2vcRy0qIc5k9PKV2lJtt88C1TcbV+JyIoPhuxULy2TPwfshWUGip0TnjHk67
	QmZ3s+Y5EvY/g/6pnYyFhD3QIfkTTs0ufIdKmRhWVRMOY/9vyge3TNPXOStcSLdJL2uKra/PoTJ
	dKNKgx3m4ocjohUykkXm/Bd57HYJ7qFTPDU9sp/Py5uRdTbtUpWwcWOltwbImRiaxbmEdoXDRPt
	w2+QtAprt7p1N6SyiYi9kPCCyqSoYAMwQ+Q3/WEuMHZF58qwPmv6z7wnOGrqrb/7HDV+zkjYyx3
	0KgAzXx/UhF4nPEzl1/6I3aCwcp7MKm+k5Cv1Ua30YFo011phoMbt/YXCx3HJKKkwwLOqrhW5cD
	ko77lA7HyaV10Wzt4QOXWX9VSD9UvlEEyY/Y5RuZhov84Y/bOOwkhOTpBRtWZGdmlBSOOENP7Oa
	JUnKCCEIkKMjMXIuTsv4xzTx8RN1DmdKs3Bk3t5IL1ihFgBDDfUd/YYrJxTFYq81OdWLlHCF0Xe
	/IO2Q3Wlv87qr
X-Received: by 2002:a05:693c:4007:b0:369:f420:8679 with SMTP id 5a478bee46e88-37687211c14mr5675144eec.38.1794480264921;
        Thu, 12 Nov 2026 02:44:24 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.44.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:44:24 -0800 (PST)
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
Subject: [PATCH v10 6/9] riscv: implement preemptible this_cpu xchg operations
Date: Thu, 12 Nov 2026 18:41:46 +0800
Message-Id: <20261112104149.38589-7-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: s4tyszdd4xqxet5jwerqja3kbmturbcz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92AED1A0002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480266-563344
X-HE-Meta: U2FsdGVkX1+xyzwd0RNwvQbnptuX2WGhWP0kEGudd2auS7ojlga7jGOe8AiO55eXektpaAYHAIQMxILTR7egQGN/Hbm4VfszvcrdH5jBLG70FgYMIyE0k6qdM2YRgvLV8JpXzsOa5KCnxDU7n9JeQs7T4BRzF95xc1/8mWhFxREIFM2AO8gS9Ia9LJmu5S0rmX1fxsNncs79kdgNulsUW0JzGPqg1JV1q9h8eXJGUuDXYUrxin7Ms6in0K3oOntJ2H0ZAAMFAmP9d7ONV8ymWnlxaQ11t4KJmPMLThuXrETjGxuaf5YijHHhyiqRVZMBifsmkyANkTpiETtt7T6b6cn0AxAjvbsLej1gE/s8F1izbyJTJHeTFVe/6XCK5aBg/TT/537ocHWupVd4dbA7E5kaRGx4gG6GoB+S6YpPt0DA5cXoQLjhPxmX18eQCfCfTUZyBdzjeHYMB535dZn7qT1mmrsUz8PntJuxNTxJOLRx42jA9Y/7zpVKaSFqlO1fFq1mJkKJuaLSmSR07Q3NSF1xGBSd8kQ7pTCXpvItRQOR9CY+IN9x4QgOLPgH3r5JPzSWzWZIq1Tsdc0XhBiHMKMHOlE5Zr0siF/APSzcFSnaZv6J7ZdAYrD4s1ZWhLj/XS5Tv3R7vY+NRymgyRPmT7oDWieGVfmJsK8GMH2QAVfiELIxn9PclPmq4yyD4tdgDQ+dmIm1FU6rA5tAXWRxPFyKPhOXsobthloXraMuJC2tnDmgqh+cuCUAdnMQIqh/WgRo0LvERazOOvMRPip2HNLIIgh5GfTltzg0jMEFvOktbrtQ8gvBc/DNhYEZoLtewQelMmZ/NMrxY3Uyb2iRqGRZ8YoZMsv8uNdNQ/iiHtZR7CBX6LH50rM2gS99RSpo/49ht39iJG6fdP1LdAe55Kwtb4AEf+TR4Nd0aFjwuaJgeq3onALiKLl31W5b4xru4gB4JWsmK+YegnUjy56
 fu1O6JTz
 QQRCoa0iGXGb7ZzXpFTkDoGgaRztdgQ3PVnLJAPvSJUcowzu/JdHdKxT6depKnXaorOgLgl0yZnZhDsXedHGolGCsHaQdR0HUI6Yc0IMrhZBRNP+X2MW4sozn8FRUCpQ/zaPU40qSXLlTrRT9X+pj+GILB8w7XqrpMc5GF9IH0F1l1R3BnwO+HfC56LCqa1SvompTk2lzkfiJMaMkeS5ayLsJAgpbBTmM/Z/PRmX9sfD9cG7TWCE0rr/D8K9vrl8f8T0O33xINkwK55qtdnmXddDx3P7c/fj3IG9jgsnaKXYarHoRl4urdQoorlFj8OpP8ze4pY3WRy5DrrhJBWfCM6RxbL2fRZ2rciHDWII9ZQbtWs2CYfPlm89LVAlb3uYHNArzwh3jQQjzurMtaU6i7f3JsSQSIr8lfdn0eyIULZ2CEWa7wWOyrNQLgk4SvDUQCttizgf1O5dcbQiHO57VsaXyCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apply the recoverable per-CPU address handling to exchange operations.

Use AMOSWAP for native-width and Zabha subword operations. Where Zabha is
unavailable, use a masked LR/SC sequence that preserves neighboring fields
in the same word.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 92 +++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 9ff02f3811550..810f4c5eaa508 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -326,6 +326,81 @@ __percpu_add_return_amo_case_16(void __percpu *pcp, unsigned long val)
 	return __percpu_add_return_8_16(pcp, val, 16);
 }
 
+#define __PERCPU_XCHG_AMO_CASE(sfx, sz)					\
+static __always_inline unsigned long					\
+__percpu_xchg_case_##sz(void __percpu *pcp, unsigned long val)		\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	u##sz ret;							\
+									\
+	asm volatile (__PCPU_GPRS_BEGIN					\
+		"amoswap" #sfx " %[ret], %[val], 0(%[addr])\n"		\
+		__PCPU_GPRS_END						\
+		: [gprs] "=m" (__ti->pcpu_gprs),			\
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),		\
+		  [ret] "=&r" (ret)					\
+		: [pcpu_offset] "m" (__ti->pcpu_offset),		\
+		  [pcp] "r" (pcp), [val] "r" ((u##sz)val)		\
+		: "memory");						\
+									\
+	return ret;							\
+}
+
+__PERCPU_XCHG_AMO_CASE(.w, 32)
+#ifdef CONFIG_64BIT
+__PERCPU_XCHG_AMO_CASE(.d, 64)
+#endif
+
+#define __PERCPU_8_16_XCHG_CASE(sz, sfx)				\
+static __always_inline unsigned long					\
+__percpu_xchg_case_##sz(void __percpu *pcp, unsigned long val)		\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	const u32 field_mask = PERCPU_8_16_GET_MASK(sz);		\
+	const unsigned long shift = PERCPU_8_16_GET_SHIFT(pcp);		\
+	const u32 mask = field_mask << shift;				\
+	const u32 new_field = (val & field_mask) << shift;		\
+	void __percpu *pcp32 = PERCPU_8_16_GET_PCP32(pcp);		\
+	u32 old, new, rc;						\
+	u##sz ret;							\
+									\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&			\
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {	\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			".option push\n"				\
+			".option arch, +zabha\n"			\
+			"amoswap" #sfx " %[ret], %[val], 0(%[addr])\n"	\
+			".option pop\n"					\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [ret] "=&r" (ret)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp), [val] "r" ((u##sz)val)	\
+			: "memory");					\
+		return ret;						\
+	}								\
+									\
+	asm volatile (__PCPU_GPRS_BEGIN					\
+		"0: lr.w %[old], 0(%[addr])\n"				\
+		"and %[new], %[old], %[inv_mask]\n"			\
+		"or %[new], %[new], %[new_field]\n"			\
+		"sc.w %[rc], %[new], 0(%[addr])\n"			\
+		"bnez %[rc], 0b\n"					\
+		__PCPU_GPRS_END						\
+		: [gprs] "=m" (__ti->pcpu_gprs),			\
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),		\
+		  [old] "=&r" (old), [new] "=&r" (new), [rc] "=&r" (rc)	\
+		: [pcpu_offset] "m" (__ti->pcpu_offset),		\
+		  [pcp] "r" (pcp32), [inv_mask] "r" (~mask),		\
+		  [new_field] "r" (new_field)				\
+		: "memory");						\
+									\
+	return (old & mask) >> shift;					\
+}
+
+__PERCPU_8_16_XCHG_CASE(8, .b)
+__PERCPU_8_16_XCHG_CASE(16, .h)
 #define _pcp_wrap(op, pcp, ...)						\
 ({									\
 	op(&(pcp), __VA_ARGS__);					\
@@ -338,6 +413,14 @@ __percpu_add_return_amo_case_16(void __percpu *pcp, unsigned long val)
 	(TYPEOF_UNQUAL(*__pcp_ptr))op(__pcp_ptr, ##args);		\
 })
 
+#define _pcp_wrap_xchg(op, pcp, val)					\
+({									\
+	__auto_type __pcp_ptr = &(pcp);					\
+									\
+	(TYPEOF_UNQUAL(*__pcp_ptr))op(__pcp_ptr,			\
+					     (unsigned long)(val));	\
+})
+
 #define this_cpu_read_1(pcp)	_pcp_wrap_return(__percpu_read_8, pcp)
 #define this_cpu_read_2(pcp)	_pcp_wrap_return(__percpu_read_16, pcp)
 #define this_cpu_read_4(pcp)	_pcp_wrap_return(__percpu_read_32, pcp)
@@ -390,9 +473,18 @@ __percpu_add_return_amo_case_16(void __percpu *pcp, unsigned long val)
 	_pcp_wrap_return(__percpu_add_return_amo_case_64, pcp, val)
 #endif
 
+#define this_cpu_xchg_1(pcp, val)	_pcp_wrap_xchg(__percpu_xchg_case_8, pcp, val)
+#define this_cpu_xchg_2(pcp, val)	_pcp_wrap_xchg(__percpu_xchg_case_16, pcp, val)
+#define this_cpu_xchg_4(pcp, val)	_pcp_wrap_xchg(__percpu_xchg_case_32, pcp, val)
+#ifdef CONFIG_64BIT
+#define this_cpu_xchg_8(pcp, val)	_pcp_wrap_xchg(__percpu_xchg_case_64, pcp, val)
+#endif
+
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef __PERCPU_8_16_OP_CASE
+#undef __PERCPU_XCHG_AMO_CASE
+#undef __PERCPU_8_16_XCHG_CASE
 #undef PERCPU_8_16_GET_SHIFT
 #undef PERCPU_8_16_GET_MASK
 #undef PERCPU_8_16_GET_PCP32
-- 
2.39.5


