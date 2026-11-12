Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0C6606A8A3
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=F2VzDmJB
Received: by kanga.kvack.org (Postfix)
	id A1E8C6B05C9; Thu, 12 Nov 2026 05:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F7546B05CA; Thu, 12 Nov 2026 05:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90D0F6B05CB; Thu, 12 Nov 2026 05:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0A66B05C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:43:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0338BC0531
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:49 +0000 (UTC)
X-FDA: 85426131420.20.C4CEFAC
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id E5A90C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:43:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F2VzDmJB;
	spf=pass (imf28.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nqm7dJauvOPXMBy5M8ojEh1xFc+cOfNZAYHc3ZE6qCY=;
	b=ebq0OEqmZW7HYzw/zHp0zsCe6cRHDtTnMCJgydVAdpO+/e1ix5/f5yoQHK3eO5lCVjmelE
	JmSezl4IV6rpKua6+DAPh/0m+6DOFlcJiNTn10AjJn0w8vTe8ktwJQe/bwyMJKG3krbeRh
	9HRBn5IHrvbyp+FacW59/p+rSNM+8fs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480228;
	b=TgEbRpjBGBTnQXOdYviSQBUX85eIuawi0xyNwmerGCTYcAViF5TKuOoEeUZlWqnBn/p+X4
	WmNJKSuhvJ95kMHxeKeKHlDtQsEBwdPypDAmbQnSeniNp1ngmdJI0HHa+Q7115fxqayp1v
	UGWVX9KBdawrzw5GJAb9JLUK4YRVtzo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F2VzDmJB;
	spf=pass (imf28.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-37600b0db49so662915eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480227; x=1795085027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Nqm7dJauvOPXMBy5M8ojEh1xFc+cOfNZAYHc3ZE6qCY=;
        b=F2VzDmJByd+mcno61XvjxPMe4c4LZngAjgTdBqrq/2ddnig4CJYmZYElIFALrK/3m9
         5EM/VD2uTk+UsHqbyPcLXH/uukrw3p8ZN2gWe59yV3c2pkTulKoG39RAnCmjEeiI0BwE
         KNtWiwcxoyYxYgniecxbyE3wgwhlqhRvgmg6bnx2o8ni6xatZ+xxpkjJS1LTYFiWOoCS
         pdILF6soe9KMr0QV3vFFEUmL4woDHd4jcwAvh5H6eObKNOsaP3vsjcqQY9Y8wo8KGFeo
         rc7EDaITCJ12//WOeIOjbQPKijYKCc63OT/gNzqecdDam+SzSBtodLT+xDYj3grZuTOa
         xv4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480227; x=1795085027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Nqm7dJauvOPXMBy5M8ojEh1xFc+cOfNZAYHc3ZE6qCY=;
        b=ksCKwqyt3/zucj+CBPbShuk9dwu2Q9s7Em507kINpouWXxxVIWKxS9/0G2IodaHDMr
         QEcsYEUSmnTmdTMHbllAAwJRfT2+FixleZ0hBVufI1S7ZHyls4cv1kPTr2gjevlqZcR/
         G7SgVanr0I5aBOa/CX4PfS+sM3O8a2FfwHgo+bTj8GePUC9/YfQ/4jH5MHIAWbQgsXPj
         yAx5Afh1Idq3ChG1mmh282ENLg/byJ1Ota7fNDAfVyjB1/RG/5j749GR4jg+hp3b5MRh
         J+n0P3KteLbbr/KE5hK/JHkAUUmFMOgSQBOuQ80+Kz6NaHTPdx6ErfL+cvtYkbwerDck
         o1ig==
X-Forwarded-Encrypted: i=1; AL+hErG3udfXtOR154pbS6g01Kpkzuw5GrcPukBUKxxWAYZBe3lPbAiJO1unxCcUUyihJDRXu//6fgojGA==@kvack.org
X-Gm-Message-State: APuU4Z+lwi8041E50xmQmw76M+krRTCTFkZZlOq/DWFMhF2bFCCFz/CJ
	acLUIot7nGUuiqnBaOH4KpAGoqPxfEICjwuNQLgkM3csaPcUfcXGHGFCJFFDM7+cGSY=
X-Gm-Gg: AYBFou2lv9rO27cv6AKbXOojZ/HA2mi8UVhqvm48PUqD4TzkAdeRHgls+FWDNxNv6ZU
	FR5EwV6KNfQrCT8RBk7kluIlToMI3C+q1DRr1ayhBl4oyW75c1ZTIo0DWlwERik+L51EyI8IPmQ
	8lKHV7fPU96QOm7iup6KYmz612qy16Ah1Aq10oUS7IXbB4yZ/zCnwLE7fX5zLr3K3LpTOKQYpYn
	amZ6mmsE1gswbdBP9pUKr6Tg0w39/RhCFdUJOq+9u0BMugBDMeBqX6cL7V60sNV/Vd+KV2lWNHD
	Wdf0lbQ1cnxBlhu8fEzYFpTkYdRaCRG3YcPo51SNuc++fdFdkVOdi4j6E9QWIYw0X7mRjbJaAU5
	EvTsFJ+ifN6XPVg9nlISn68nhdP+nmpaxVTRtR7RsnLCEork8s5lWqb+5Z3z5B9kLhUL91gIfDy
	TY5WqtJ+R6xjBTZFGqZ6X6DcnDptnK2V3W7Y4mDqoOW8f+CKv0OtKWpBxkOV9j9IAG4BV6xardH
	a+pzijl4x1OKfLQtyzE93MR/FQgvI2lMocrhoRIEL4YbFi4OYGF1G+6JAaHXaiuMJQOCb3iwvPx
	FEobF9/tjpYDadLgSMLOs5TQH1A9Ce+atbaZr9AbqHQhZve8mDfbDRuPtbxftd7/UG0=
X-Received: by 2002:a05:7300:560d:b0:36c:a1bc:6102 with SMTP id 5a478bee46e88-377db5d8963mr1895745eec.0.1794480226338;
        Thu, 12 Nov 2026 02:43:46 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.43.27
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:43:45 -0800 (PST)
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
Subject: [PATCH v10 4/9] riscv: implement preemptible this_cpu void RMW operations
Date: Thu, 12 Nov 2026 18:41:44 +0800
Message-Id: <20261112104149.38589-5-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: zzta5ejhzsbg43wgg15tmm17bhd9gfy5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E5A90C0004
X-Rspam-User: 
X-HE-Tag: 1794480227-978645
X-HE-Meta: U2FsdGVkX19fVpvhRYapXOWquuF1FmLeATSgTYqItl+SFqt8aG1raXq0qda4sR8Wr7PyQmnCMcMEmweEGy+d55JBSw4/RhpnLQEJcXghhtfHh6q1gi/oFTyhyHZw3MI7qR8mDnTJ1B74ajisPNhnvQ4NNJRBqrGbS5LbTyzbzL+0/BziLS8NSN8U/rlxns8QKAiirXa7Vp/JQPnJ+2Le3I8bAnox8wsgm48sPDm5id6ERGbFPrm31mRaekeIs17NwzxuqJgutEI9xP+3xroafwPpjuA/56hrl2Or4dBgJ5IY7z7tuVDpZTi6uZQMh5v5V4X8OzLsN+jrqUDcwfqIdIwV3mnaCsDlDbsK8jJBjRvMDIOo5PeNDQrr1PEsu17Lak7hoZGnnC2BcbBpKf5JQVj+0Np5Pr8doq3s7eBmiz0se/lvs9TJ2YSuEaimSq4FreQj8kCjHzz3vY8huvOOQODmVh8dVw9gTBJUMhF8bMmtZNQx41lWBMZWkpHXiLJn1Ps7jBWUHneuYxHFcza+NVN1W5fOYsgoaluw7SGFOQsyKi4lhFqTCjBHNNmK9NhUUl2kbQNORNR20ZqtXhbOoMaW+mMzPNkCBdTWMEnlmFmPRs1vHpCjuE7YxD86EA7/OP5MHYlAziAi6mwgF6HmGEr1AvB/N26rarEIpNmsmtKfD1ewpRO+/ScczNSl2l7iJQJy+6YcqRVeIwlvaK8O4f755VbzhTAugA8xVKxWsTQr9AShCL+eJzul53J27fxK3ukzGdqzRxsm/4i8f2ecVwyBbdcDnGWP4DjHyGaQSmEnm7CqcFuifx1pcWq401/sb/XaLw8bKhLUQsAuCr4Wek12jTRn3c57WI28RF4Yb4YLDBpBh8nehF4cM/bezzupOcGNo9xkF3nAQRHSY3atw4iuMxCU4l3MEntmS0V090CgBjp3y2d6eag4QuEYBkb9wT629rP6s0o5zNH5ukJ
 BIzYxv8H
 khsEPtq4dxikNxpPu3/lfDVwjWISM5LkuMq88pEFiXl7AHfkNP2MAGPhbuEbaOoKFUA50awiHwxJvgEtdNsjovIaSoXEY37ie9J8sIjl9/pssOgf2Xrq53a0G7hjA9WNNSLqL0jC2iYC6CToKeXe4GBq6OBnx/9ADLJK+yxDjp1ycnQLv5eookWf8dl+kNda3RA01T9E1wigqSIMSc0IAhvpk+fxlGKWUHW6JkZ/rzWVoMJSg0UcjnWm9EbpVGKlVS6O2QtU8g1fN6hvDR4Ti8PBLkRkujXznIkLjth7svpHlkIwkTyZXwYS9SmBr8Qnx1eatTnDhbf8LFpXdtTcm7uyqD3AiePuXvtCihImqJTYWQdqR6qUxZsIxrq0u9dv0vvuxGeOrriUvO+fQNjHQQqCS5MhANUTeIt3Q/+TWoaDnt7K2Xh9QF7wYH3HevWh5jLvKJz1yl8DNTGGf5CK2BzYqNaHqSkuT1Ml8bPEXzRRQhtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apply the recoverable per-CPU address handling to void read-modify-write
operations.

Use relaxed AMOs for native-width operations, and Zabha or a masked LR/SC
sequence for subword operations. Use value-returning AMOs even when the old
value is unused so CPU-local operations remain likely to execute near the
CPU.

Link: https://lore.kernel.org/r/20260826010748.zphu3wh2hlm4t4o2@offworld
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 127 ++++++++++++++++++++++++++++++++
 1 file changed, 127 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index ae7c123a48093..46eafa1ef02a1 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -9,8 +9,10 @@
 #include <linux/thread_info.h>
 
 #include <asm/asm.h>
+#include <asm/cpufeature-macros.h>
 #include <asm/current.h>
 #include <asm/gpr-num.h>
+#include <asm/hwcap.h>
 
 #define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
 
@@ -102,6 +104,105 @@ PERCPU_RW_OPS("ld", "sd", 64)
 PERCPU_RW_OPS("lw", "sw", 32)
 #endif
 
+/*
+ * Use value-returning AMOs even when the old value is unused.  Avoiding x0
+ * as rd makes an AMO more likely to execute near the CPU, which better suits
+ * CPU-local data that is commonly accessed again by the same CPU.
+ */
+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)			\
+static __always_inline void						\
+__percpu_##name##_amo_case_##sz(void __percpu *pcp, unsigned long val)	\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	u##sz tmp;							\
+									\
+	asm volatile (__PCPU_GPRS_BEGIN					\
+		"amo" #amo_insn #sfx " %[tmp], %[val], 0(%[addr])\n"	\
+		__PCPU_GPRS_END						\
+		: [gprs] "=m" (__ti->pcpu_gprs),			\
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),		\
+		  [tmp] "=&r" (tmp)					\
+		: [pcpu_offset] "m" (__ti->pcpu_offset),		\
+		  [pcp] "r" (pcp), [val] "r" ((u##sz)val)		\
+		: "memory");						\
+}
+
+__PERCPU_AMO_OP_CASE(.w, add, 32, add)
+__PERCPU_AMO_OP_CASE(.w, and, 32, and)
+__PERCPU_AMO_OP_CASE(.w, or, 32, or)
+
+#ifdef CONFIG_64BIT
+__PERCPU_AMO_OP_CASE(.d, add, 64, add)
+__PERCPU_AMO_OP_CASE(.d, and, 64, and)
+__PERCPU_AMO_OP_CASE(.d, or, 64, or)
+#endif
+
+#define PERCPU_8_16_GET_SHIFT(pcp)					\
+	(((__force unsigned long)(pcp) & 0x3) * BITS_PER_BYTE)
+#define PERCPU_8_16_GET_MASK(sz)	GENMASK((sz) - 1, 0)
+#define PERCPU_8_16_GET_PCP32(pcp)					\
+	((void __percpu *)((__force unsigned long)(pcp) & ~0x3UL))
+
+#define __PERCPU_8_16_OP_CASE(name, sz, sfx, amo_insn, op_insn)		\
+static __always_inline void						\
+__percpu_##name##_amo_case_##sz(void __percpu *pcp, unsigned long val)	\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	const u32 field_mask = PERCPU_8_16_GET_MASK(sz);		\
+	const unsigned long shift = PERCPU_8_16_GET_SHIFT(pcp);		\
+	const u32 mask = field_mask << shift;				\
+	const u32 val_trunc = val & field_mask;				\
+	void __percpu *pcp32 = PERCPU_8_16_GET_PCP32(pcp);		\
+	u32 old, new, field;						\
+	u##sz tmp;							\
+									\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&			\
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {	\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			".option push\n"				\
+			".option arch, +zabha\n"			\
+			"amo" #amo_insn #sfx " %[tmp], %[val], 0(%[addr])\n"	\
+			".option pop\n"					\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [tmp] "=&r" (tmp)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp), [val] "r" ((u##sz)val)	\
+			: "memory");					\
+	} else {							\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			"0: lr.w %[old], 0(%[addr])\n"			\
+			"and %[field], %[old], %[mask]\n"		\
+			"srl %[field], %[field], %[shift]\n"		\
+			op_insn " %[field], %[field], %[val]\n"		\
+			"and %[field], %[field], %[field_mask]\n"	\
+			"sll %[field], %[field], %[shift]\n"		\
+			"and %[new], %[old], %[inv_mask]\n"		\
+			"or %[new], %[new], %[field]\n"			\
+			"sc.w %[new], %[new], 0(%[addr])\n"		\
+			"bnez %[new], 0b\n"				\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [old] "=&r" (old), [new] "=&r" (new),		\
+			  [field] "=&r" (field)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp32), [mask] "r" (mask),		\
+			  [shift] "r" (shift), [val] "r" (val_trunc),	\
+			  [field_mask] "r" (field_mask),		\
+			  [inv_mask] "r" (~mask)			\
+			: "memory");					\
+	}								\
+}
+
+__PERCPU_8_16_OP_CASE(add, 8, .b, add, "add")
+__PERCPU_8_16_OP_CASE(add, 16, .h, add, "add")
+__PERCPU_8_16_OP_CASE(and, 8, .b, and, "and")
+__PERCPU_8_16_OP_CASE(and, 16, .h, and, "and")
+__PERCPU_8_16_OP_CASE(or, 8, .b, or, "or")
+__PERCPU_8_16_OP_CASE(or, 16, .h, or, "or")
+
 #define _pcp_wrap(op, pcp, ...)						\
 ({									\
 	op(&(pcp), __VA_ARGS__);					\
@@ -134,7 +235,33 @@ PERCPU_RW_OPS("lw", "sw", 32)
 	_pcp_wrap(__percpu_write_64, pcp, (unsigned long)(val))
 #endif
 
+#define this_cpu_add_1(pcp, val)	_pcp_wrap(__percpu_add_amo_case_8, pcp, val)
+#define this_cpu_add_2(pcp, val)	_pcp_wrap(__percpu_add_amo_case_16, pcp, val)
+#define this_cpu_add_4(pcp, val)	_pcp_wrap(__percpu_add_amo_case_32, pcp, val)
+#ifdef CONFIG_64BIT
+#define this_cpu_add_8(pcp, val)	_pcp_wrap(__percpu_add_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_and_1(pcp, val)	_pcp_wrap(__percpu_and_amo_case_8, pcp, val)
+#define this_cpu_and_2(pcp, val)	_pcp_wrap(__percpu_and_amo_case_16, pcp, val)
+#define this_cpu_and_4(pcp, val)	_pcp_wrap(__percpu_and_amo_case_32, pcp, val)
+#ifdef CONFIG_64BIT
+#define this_cpu_and_8(pcp, val)	_pcp_wrap(__percpu_and_amo_case_64, pcp, val)
+#endif
+
+#define this_cpu_or_1(pcp, val)		_pcp_wrap(__percpu_or_amo_case_8, pcp, val)
+#define this_cpu_or_2(pcp, val)		_pcp_wrap(__percpu_or_amo_case_16, pcp, val)
+#define this_cpu_or_4(pcp, val)		_pcp_wrap(__percpu_or_amo_case_32, pcp, val)
+#ifdef CONFIG_64BIT
+#define this_cpu_or_8(pcp, val)		_pcp_wrap(__percpu_or_amo_case_64, pcp, val)
+#endif
+
 #undef PERCPU_RW_OPS
+#undef __PERCPU_AMO_OP_CASE
+#undef __PERCPU_8_16_OP_CASE
+#undef PERCPU_8_16_GET_SHIFT
+#undef PERCPU_8_16_GET_MASK
+#undef PERCPU_8_16_GET_PCP32
 #undef __PCPU_OP_CONTEXT
 
 #include <asm-generic/percpu.h>
-- 
2.39.5


