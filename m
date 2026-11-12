Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1112A606A333
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=apAB2/4e
Received: by kanga.kvack.org (Postfix)
	id 391166B05CD; Thu, 12 Nov 2026 05:44:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3691D6B05CE; Thu, 12 Nov 2026 05:44:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F4D6B05CF; Thu, 12 Nov 2026 05:44:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F26906B05CD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:44:47 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9019A120548
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:47 +0000 (UTC)
X-FDA: 85426133814.16.1A8DDA7
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id C1D0980002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="apAB2/4e";
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480285;
	b=qhUNEF4i7rkh8v8MIhFnGxlymd4NsWzaVD3t5CwY0gFyZE/33RBAwh2ap2JM08J5bEecsv
	Y/d/wUF6/H+JClcokC40gWgjnbnhrXA/NULtQW8gWIx8LwRW1+m43Vncgs41gp9IIjaDoZ
	UgZr9nZQGpiZ3auBm2xs85Q679DLgXs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="apAB2/4e";
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3OeTM1TzwuEgoxs5/RujJPoBJ6uQ7k0zO4x50L7a91Q=;
	b=nexjFoLafMHH6UFRkK1szFatfuspXkrobveJXwLdZHzLGOGx2VgPM2bhTraaW0FUYzyx5J
	TCFy6w9MDN0HKjwi8QvsnXiaCDolOdZEhj+H+PxKHhdzHsvH0tq0msnMKB7cKnLVmSEMpN
	b3EJMkXe4mNT8qJv+Rb8cW8Nk1L1ezU=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3712b6d9843so3999370eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:44:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480284; x=1795085084; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=3OeTM1TzwuEgoxs5/RujJPoBJ6uQ7k0zO4x50L7a91Q=;
        b=apAB2/4e6HBrHavHEExrRTmSrz1oMpN0KTA/2MA12sALml1dRD1uVqMlYHLN1hHn/0
         MwCWuo3wZsynbBf7ut213gTnBa1cQHWm7Q6AdE/yQueCav/4gQjy+KzLJE4AKf7+B0K5
         0vDMLrs6J5/CDEOOxNPwqRlZxZHdcT0wMhJt4lb093t8HgABPYWTyTeQbxdYJUkzVrim
         O9Q0+nX2hmPrxybwuaVkf2StZKBh5N9qNCmHU9z2ILInXq3hgmKfVZAnwpZZAEr7z80z
         jthjn0TFempEZXu760aATx0LI7P/Xh+9A8QgyBcZwoRFAKPoEgr9800RRsGtOWlgxco0
         LJxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480284; x=1795085084;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=3OeTM1TzwuEgoxs5/RujJPoBJ6uQ7k0zO4x50L7a91Q=;
        b=MLh+J8nkXHRPPqSrldjdGdtFkeRoo5l4sOiLQj9GIM+FQpi7nPiYSV/xZjtpbPELqV
         e51ZZoYriz9ceSZ4MGpXf03Aa0fi1hS1YuKV5L2F+8gkayad/iP3hJBSqd9G8aERxr2t
         0NqNTyTqdlMIB6ZVSKoAs8BcgQuI9PL98Ke1d+WuS9zTw92090KGMUDAibuMUuspWlDZ
         VFV36kxwpmRquH2WBdUWCywter+QIsAmfLESBQW3W+dM01d+dTI0zSrt+aPGV7yNQqfn
         u+QNXRiblmW7g85GxF3dCaJdZEbhW7Poo4RrGoY9zAIv0dFD1ykj6Th5xhnbQIhQepKv
         a/uA==
X-Forwarded-Encrypted: i=1; AL+hErFFCnlSPcoDeWChsAu1XL+jXRxA5s+FC1aHQcwrvff1gAHiiov0lJO6kwlDmHF1Zze9coKXMwA1yA==@kvack.org
X-Gm-Message-State: APuU4Z9V9OH25tcDMDlF9RSu8M2MI3rvmikG1Cdc4NHEPZWMFUnY0Ksb
	cu21mV4MChTFgu/4gIXg1bOPJHkX9urjA0v/BqfVLDzZ/bxDL53p2/75/uNDSaWGDwI=
X-Gm-Gg: AYBFou3SJ4dvsE+UjIrqsXPaUuQVaKhUHvjIbyo9tV/RC4n4cZOuaj95q3REzqsYl+3
	gtTJWGy8MlbgT0ILrhq5g5MxxEZvjYlo2KZFewM+L9BmpMe42pjDJrQKZ9PrOhOtK/E7uLomr3K
	Wl8icpxPGwhn/u8j5kZqAovkAx9n4IyepoiDvsxRQuPJqD0OX3dg65nCd0lmNO7PdTkivjRP8Mf
	2egNy+VfH2TbDxGbBo4AN5oMUKBWAMM8mQMooplOiBfE/3yGPH+9K3q/tnbeHYqmed1uUnjb0rb
	Bz9KvZInUdbu35500dMiDSjdXEyrlUvGqn4S7wCUu+4Fe414/f1DcemfHMFdC1sivVhP44VnPbl
	5e13mKUwF0F0nu3XdgACtvvCTcJPRVbmlUByVb5ZdJHmL0Lyqw5wicaHyjP9eL3QpIQ1HJOXwR/
	LIdDiw7/pWCdY71yKPs1vJZhC29/mEEx3nQekL7EiSzctQMpFZOYvxk+8C3TBMSjd1FWXewQZAp
	Z6mYK2rhxagSqowUAq1sw0rGNkXLGRNp3eNfyPFthCcrUUaZSG+fPu/GnyQ7mBdotpQvT9joG/W
	TKro6S5HRLJTeB92yTgJaQDxeJKKFxZ1oH+KwQkpJNpZKsw5hciNUKhHDNHvBIhRVac=
X-Received: by 2002:a05:693c:6381:10b0:378:a35b:9e1c with SMTP id 5a478bee46e88-378a35b9e83mr512290eec.37.1794480284232;
        Thu, 12 Nov 2026 02:44:44 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.44.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:44:43 -0800 (PST)
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
Subject: [PATCH v10 7/9] riscv: implement preemptible this_cpu cmpxchg operations
Date: Thu, 12 Nov 2026 18:41:47 +0800
Message-Id: <20261112104149.38589-8-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y76f4yihaga8t8iqexz49gy9oxo73p6s
X-Rspamd-Queue-Id: C1D0980002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794480285-442643
X-HE-Meta: U2FsdGVkX19o49FktnNXaKPV2bW8j+20ACT7IjLcvdqtI5Unh3S/d3K1iY0ZAsyJPb1r9SxueC1dNbpZ/tdcWnmkSq+s30hX0rt73JjIW1XGptj5z8SbB+hMrR8Bg3bDtt2IldYlwAFOmdXiJAYZsR9V/UdYjMjoxw84OzGsQIgBIpCN+aWb7vVcpPygjIsuPJfGhDLemphiYaRorCmI+j6wBZXVbsLGN69HzAFx43JFDQdRJxzGb1GSSNMZy+9DsGnJ9l9fRnXDvVVGSEKaAPzCrbJnQ4OLPcJrlxX44cbo0kNSmIrP5cHNyqtFA5sZWoNvBXAfAdYACAeBRdAUIwavoEY5AS5g+nn6UYYuQvjwGEcUN3fstryS5pz1fIv7sqgnlcPKt4Mu2QdVpeDJOUOXFl0bv45AK0qbGYskcTZrTDbbJqeI9k19V2jKpK130I81QGKhTRkb4H63nNE+CGB0k5Ku87T2jQHaxh4U/7VdYEDICS/0ssfQxhlvQJpJTuJ6MDU8Lb2opt0TpDnUrGwWBzDdxwWqMqjZML65qbBwOPNd6aT8+LHlFtWPZjg58ANJM92DXrUvAMaEObWG1KTrdMh2beeT/cKji1CmfkpruVgkMz5nusYxNtI3DCntdOGk3T7QTo5NVZX3eSkmUrA1ZFE1Ab9fPj5VuNmym8Q3IYioK5Km+5ft0IY14jyjLo7WvRJM5cteGF8nWJiwDktyrGOSO+p8uEemT8mJRch7bahSn0OROkkk0c2lKpH9x815cObDfL2RsrYo03AuR1vd/+P/ZIaRXEQVWkiYiujQwaixRpfvWDbsDk3V2vdoEpkpLKE1G0idfztAc022UOGEOLQxqjv38ymRF5KMOpK5WgpuirP0fHIPRJ9EeoSwp/UHvkxrr48BisTtTx9jdsX3tBwO7GcnmS0Jy5m9ESbHPNbdLf5w4GMG3U+laft7hHz/+EzNIfbJ1ajcjo+
 Ja8PLEuL
 FcB/k+ATbvlWpqDorjDsG9KDmY4AQ2jtNP7x477uagl0sB+cBdCymCxT0005DxXflK2koqnXrzqK2EU4mwjHi2k/JrZgjK80lbZj4TgXHDcRAe1oSG2NDRRu33YsC7YZ2cEd55pmVUIH9qNzjb1KT4usPRqLvbklbH+CTGvxuaKKd3Y6xbpKQmbFjCh/5pHWxmtffWy3qqC5xwsmRZizoZBBEjfduDRlh5O6BNcT83G8Mh3wc/QSjTBWIGboG18Z68mVcV+JjdXou5o46gs2SJnFHMYC3JoHk2Fn5J8F9JPUes2SDBk8EGPkTTZVR2R3hGl2DuKk7qwksicrE4Dzqz+skVn9YY1H1y7QRki9/j3N/Y36yRlQCufb1FHw9L5q6zC68TNwb5T7bjp7ussqPxr2l5i9bnb2vHKm45jzgGzyjmPa/16T4tjjDBSwYjKctma0ZDEaUUOacxS6qZpFnC9VwgtHmkmfxJYGWjbeO3RR6WKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apply the recoverable per-CPU address handling to compare-and-exchange
operations. Providing this_cpu_cmpxchg() also allows asm-generic to derive
this_cpu_try_cmpxchg().

Use Zacas where available and LR/SC otherwise. Keep masked subword operands
XLEN-wide so RV64 LR.W sign extension does not affect the comparison, and
use typed helpers to separate asm-generic from the architecture cmpxchg
macro expansion.

Link: https://lore.kernel.org/r/20260826010748.zphu3wh2hlm4t4o2@offworld
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 140 ++++++++++++++++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 810f4c5eaa508..4d2fc10cbdab1 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -401,6 +401,123 @@ __percpu_xchg_case_##sz(void __percpu *pcp, unsigned long val)		\
 
 __PERCPU_8_16_XCHG_CASE(8, .b)
 __PERCPU_8_16_XCHG_CASE(16, .h)
+
+#define __PERCPU_CMPXCHG_CASE(sz, lr_sfx, sc_sfx, cas_sfx)		\
+static __always_inline unsigned long					\
+__percpu_cmpxchg_case_##sz(void __percpu *pcp, unsigned long old,	\
+			   unsigned long new)				\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	const long cmp = (long)(s##sz)(u##sz)old;			\
+	unsigned long rc;						\
+	u##sz ret = (u##sz)old;						\
+									\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZACAS) &&			\
+	    IS_ENABLED(CONFIG_TOOLCHAIN_HAS_ZACAS) &&			\
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZACAS)) {	\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			".option push\n"				\
+			".option arch, +zacas\n"			\
+			"amocas" #cas_sfx " %[ret], %[new], 0(%[addr])\n"	\
+			".option pop\n"					\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [ret] "+&r" (ret)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp), [new] "r" ((u##sz)new)	\
+			: "memory");					\
+	} else {							\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			"0: lr" #lr_sfx " %[ret], 0(%[addr])\n"		\
+			"bne %[ret], %[old], 1f\n"			\
+			"sc" #sc_sfx " %[rc], %[new], 0(%[addr])\n"	\
+			"bnez %[rc], 0b\n"				\
+			"1:\n"						\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [ret] "=&r" (ret), [rc] "=&r" (rc)		\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp), [old] "r" (cmp),		\
+			  [new] "r" ((u##sz)new)			\
+			: "memory");					\
+	}								\
+									\
+	return ret;							\
+}
+
+__PERCPU_CMPXCHG_CASE(32, .w, .w, .w)
+#ifdef CONFIG_64BIT
+__PERCPU_CMPXCHG_CASE(64, .d, .d, .d)
+#endif
+
+/*
+ * Use XLEN-wide masks to clear the upper bits of an RV64 sign-extended
+ * LR.W result before comparing a high byte or halfword.
+ */
+#define __PERCPU_8_16_CMPXCHG_CASE(sz, sfx)				\
+static __always_inline unsigned long					\
+__percpu_cmpxchg_case_##sz(void __percpu *pcp, unsigned long old,	\
+			   unsigned long new)				\
+{									\
+	__PCPU_OP_CONTEXT();						\
+	const unsigned long shift = PERCPU_8_16_GET_SHIFT(pcp);		\
+	const unsigned long field_mask = PERCPU_8_16_GET_MASK(sz);	\
+	const unsigned long mask = field_mask << shift;			\
+	const unsigned long old_field = (old & field_mask) << shift;	\
+	const unsigned long new_field = (new & field_mask) << shift;	\
+	void __percpu *pcp32 = PERCPU_8_16_GET_PCP32(pcp);		\
+	unsigned long ret32, tmp, rc;					\
+	u##sz ret = (u##sz)old;						\
+									\
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&			\
+	    IS_ENABLED(CONFIG_RISCV_ISA_ZACAS) &&			\
+	    IS_ENABLED(CONFIG_TOOLCHAIN_HAS_ZACAS) &&			\
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA) &&	\
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZACAS)) {	\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			".option push\n"				\
+			".option arch, +zacas, +zabha\n"		\
+			"amocas" #sfx " %[ret], %[new], 0(%[addr])\n"	\
+			".option pop\n"					\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [ret] "+&r" (ret)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp), [new] "r" ((u##sz)new)	\
+			: "memory");					\
+	} else {							\
+		asm volatile (__PCPU_GPRS_BEGIN				\
+			"0: lr.w %[ret], 0(%[addr])\n"			\
+			"and %[tmp], %[ret], %[mask]\n"			\
+			"bne %[tmp], %[old], 1f\n"			\
+			"and %[tmp], %[ret], %[inv_mask]\n"		\
+			"or %[tmp], %[tmp], %[new]\n"			\
+			"sc.w %[rc], %[tmp], 0(%[addr])\n"		\
+			"bnez %[rc], 0b\n"				\
+			"1:\n"						\
+			__PCPU_GPRS_END					\
+			: [gprs] "=m" (__ti->pcpu_gprs),		\
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),	\
+			  [ret] "=&r" (ret32), [tmp] "=&r" (tmp),	\
+			  [rc] "=&r" (rc)				\
+			: [pcpu_offset] "m" (__ti->pcpu_offset),	\
+			  [pcp] "r" (pcp32), [mask] "r" (mask),		\
+			  [old] "r" (old_field),			\
+			  [new] "r" (new_field),			\
+			  [inv_mask] "r" (~mask)			\
+			: "memory");					\
+									\
+		ret = (ret32 & mask) >> shift;				\
+	}								\
+									\
+	return ret;							\
+}
+
+__PERCPU_8_16_CMPXCHG_CASE(8, .b)
+__PERCPU_8_16_CMPXCHG_CASE(16, .h)
 #define _pcp_wrap(op, pcp, ...)						\
 ({									\
 	op(&(pcp), __VA_ARGS__);					\
@@ -421,6 +538,15 @@ __PERCPU_8_16_XCHG_CASE(16, .h)
 					     (unsigned long)(val));	\
 })
 
+#define _pcp_wrap_cmpxchg(op, pcp, old, new)				\
+({									\
+	__auto_type __pcp_ptr = &(pcp);					\
+									\
+	(TYPEOF_UNQUAL(*__pcp_ptr))op(__pcp_ptr,			\
+					     (unsigned long)(old),	\
+					     (unsigned long)(new));	\
+})
+
 #define this_cpu_read_1(pcp)	_pcp_wrap_return(__percpu_read_8, pcp)
 #define this_cpu_read_2(pcp)	_pcp_wrap_return(__percpu_read_16, pcp)
 #define this_cpu_read_4(pcp)	_pcp_wrap_return(__percpu_read_32, pcp)
@@ -480,11 +606,25 @@ __PERCPU_8_16_XCHG_CASE(16, .h)
 #define this_cpu_xchg_8(pcp, val)	_pcp_wrap_xchg(__percpu_xchg_case_64, pcp, val)
 #endif
 
+#define this_cpu_cmpxchg_1(pcp, o, n)					\
+	_pcp_wrap_cmpxchg(__percpu_cmpxchg_case_8, pcp, o, n)
+#define this_cpu_cmpxchg_2(pcp, o, n)					\
+	_pcp_wrap_cmpxchg(__percpu_cmpxchg_case_16, pcp, o, n)
+#define this_cpu_cmpxchg_4(pcp, o, n)					\
+	_pcp_wrap_cmpxchg(__percpu_cmpxchg_case_32, pcp, o, n)
+#ifdef CONFIG_64BIT
+#define this_cpu_cmpxchg_8(pcp, o, n)					\
+	_pcp_wrap_cmpxchg(__percpu_cmpxchg_case_64, pcp, o, n)
+#define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
+#endif
+
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef __PERCPU_8_16_OP_CASE
 #undef __PERCPU_XCHG_AMO_CASE
 #undef __PERCPU_8_16_XCHG_CASE
+#undef __PERCPU_CMPXCHG_CASE
+#undef __PERCPU_8_16_CMPXCHG_CASE
 #undef PERCPU_8_16_GET_SHIFT
 #undef PERCPU_8_16_GET_MASK
 #undef PERCPU_8_16_GET_PCP32
-- 
2.39.5


