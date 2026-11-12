Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E9C2606A339
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=kTsqIWN5
Received: by kanga.kvack.org (Postfix)
	id 368FE6B05B2; Thu, 12 Nov 2026 05:44:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3406C6B05CA; Thu, 12 Nov 2026 05:44:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FA36B05CB; Thu, 12 Nov 2026 05:44:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 03E7C6B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:44:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35952120548
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:09 +0000 (UTC)
X-FDA: 85426132218.22.D172D24
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id D468BC0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:44:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kTsqIWN5;
	spf=pass (imf28.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480247;
	b=YY1H52SNvht92+jq89wvH5XuOdHDJJmMHS3/5Fv4o/h8fZ/0kkKbFfN5+O4kcFRZY03hKU
	BlVbqlC83kz41bXhwmJEwraH+j2EXDEY8qa3LPnz2ugRWj2wVIoN4ehBCFwnDW7ZNgFHV9
	yTasdtx6VKhjDA3Vp3EJ5S2GXUOR3Vg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=kTsqIWN5;
	spf=pass (imf28.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tPVt/aU+A2sVokgBjAuMpT5U1lyKBduiFFPOAO3us6w=;
	b=Fva7jjiZAJNFh94XrR8t2FQg8L9ei3hAUMXSF2doLDlpOclBLRBJYoTsO1aZd0mu/AD8GU
	Pmd24t4xhn42PSMpr/BPwySxQ60EL8b1gfOWIJpPKmdo5hdfkljZGAhTi64THefuZuVXDG
	oCG7d1YDuoBinuPqZvE+Kt7dSeB3rnQ=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3714613eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480246; x=1795085046; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tPVt/aU+A2sVokgBjAuMpT5U1lyKBduiFFPOAO3us6w=;
        b=kTsqIWN5FcxrZ2KMxhpe7K4PekaKuzkRt54HN0jNgNxFriJJDnjNp7K8lo2UGi9ew+
         40ucV2Wh3uqwOUQiG673NWbdk5q/GurHRkBCYdcXaRY5WdH1hc9eixp/2awnCnpCXHLP
         H3+WNRupKr4SeyKnAs8/EgWSSzK2FTy83sPi5M9Goxa6AkHr36EGkGRi7xAR+DgOO0XA
         Ff9SHvcH33nEmS/6LW7pVPaDJSX4zxCx+WpyPb434ISiK/nDIA17O+pCe3X88OOhGsjF
         qJSuqchvtXgIepcap9gQsDghtRJAibRsev9yd0/b18qfXioghcbYkblJLRzLFUr6+X3l
         QL8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480246; x=1795085046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=tPVt/aU+A2sVokgBjAuMpT5U1lyKBduiFFPOAO3us6w=;
        b=eGyPaYWbZxeIyEs/guGUoehjDje+9VnhcLJGDADVKFX0ZJ163ghC/4bp3sM9drQhb1
         58B5U8vpHOTqInoQM2SDzTMqEAayX7k1A8x9qR8gauFeZi3ZnOIYkftrfZ8MwV7eicsl
         /qXuEsdpehXRIJBOvsUX3KiBn2mIwcI/7eW82w/RZl5T2eB5KC+xzn3FLwFrGr7mNgF4
         +OAdb5/KIlMNlWjJaXKkm4PvAVvFf33g2DS3YRaa3PlXdlD7p41Lk2fM8i2F9+/aYNHK
         PXjN/RduR9yNrRelMua8d9MZYpH69uxEnMG6suxdh57c9BQHCkQnIldFSmfgigwuIaQo
         n21g==
X-Forwarded-Encrypted: i=1; AL+hErFO6YsTo0jSe2HtLlilVpgPhqc9rmyw6ftH6v2DySvU14KKxhhNBkp3JuidVJDZe6IGv45tgOp4Rw==@kvack.org
X-Gm-Message-State: APuU4Z+42erwGiO3oc+f6Xfy45hWeh+aRlxgNnv7B/4ePx2qBpoubRiI
	ywGQF0QJfQRoBVE1jz+XewHpTBdmsYLxwaSrJILZrpIYXNY8H40Fng1st0vZarX4nE8=
X-Gm-Gg: AYBFou2G4l3mYoJvXS7NiSuHi9exI5kFHI9cnQW2x9EjmJlP6c24OiJIcGRcrXmSE2y
	2I6xUGgHOL1j+Fe1Kga8ynMJ1jFH1RxyiQ+TZfDmNdlnNZiPlhkuXeP/4mgFuRhlqx+JloDSi5i
	rXlYCrjOUbyvqPfuJ9AiYbzY57ju84SBc8pcnS6FhL8+mXrjI5ecpyyiNXSJFo+Tnb0WimE1V1M
	pYZx4BHgbcBz0xAbyVJGA+FlO61e2TAI8DLDCT+bLb6ZdV/QLUrIQVlxB1wT93axZDVpf+PvPBk
	nEnp/R84SC2SC/G9UCXHEgRp2XXi4OSiWJUQeRYPKwZsq/3ijQVMHzEOk0z9HeZMv6uK0lIYkVv
	+rU5Sn3MXQE5gCM7diYXIcnqJzaX0Wq+/KGBvMfSe7ZOLlA3+9RcyehtHplNOaOmAGYAGsGeQBV
	Exvjt+4cS4XprE0v0CG3Q64f3rsD2y3fb1l1APN8/Q7Ugo0qMW2W0CmSH6a3WqQd/N34Z94yZNu
	BtQkEoJwfWdJjltxkjVsWb+B/dfoRa7uUdZYBazTXrXGk2oEG9EaDLtsIQ/vvwxaeQPnCUWwgO6
	EstQg7YvJ3yGf0MiHL1fvMHTEEwUF/4ILHQuP9wRr/SleHh+8C6Tn3cxCj5jPhIZv6s=
X-Received: by 2002:a05:7301:d80b:b0:375:370e:f1ff with SMTP id 5a478bee46e88-37687214128mr6314130eec.35.1794480245214;
        Thu, 12 Nov 2026 02:44:05 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.43.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:44:04 -0800 (PST)
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
Subject: [PATCH v10 5/9] riscv: implement preemptible this_cpu add_return operations
Date: Thu, 12 Nov 2026 18:41:45 +0800
Message-Id: <20261112104149.38589-6-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20261112104149.38589-1-cuiyunhui@bytedance.com>
References: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D468BC0004
X-Stat-Signature: 9gh9u9dnf1tcdpi1q7fmm47hhdh7x8sw
X-Rspam-User: 
X-HE-Tag: 1794480246-684251
X-HE-Meta: U2FsdGVkX189oCz9zNxSW+uNy+NL+Tx8SqOEP2GMp7bpjG2TKGhdH0UlS9HSFAvuFIs1sEP53uc2UrllGfxFpidogqg/Bsnt8/fFw8KY/9LBMPVTSGLSb/b8XEMMLDuegsoqejNGzBJvff46+NIDb+NUQT2IZ5hevVA66T3U4Bs5/VlEqTTr+ivv9uyFQ1F+8+xmdeLiYh/X5DmzRyScndiOhEhNz9bWerkQSI5AzeggcLLcaBMRiUv++2332Mw6F/PADLWzNrQBuDmRA1bu09Ezpa/xLxXuyS2TCoMcaLtHyf4v9yV3ThMVksf3LyJfvDamAn1Vf+pDu7N7jTrcjAtbIk5LU438VC5D2m60AmQw59le1PR3jt7i+ns9pK/h0O7UBDuQSSC0VwGdwfJKVbh9IJkeDLw4ZUnUW50uAqJb+iZmyIvEi7bD8WpKWHJ0ucHFWz3NPDeYEZJK1E4ehXhdjU6QU3BDph1QEsgXk+TfaH+wPNjl5wjUlcCEpKAhAK++g11RI7UIBl3v3dtg67ioy8hEQs4ogRTyyKAFmWGObuM/L0Z41iEhXfQDs8PvBbTNWsN7U4hVl3JG6MohzliudKl/8FjwDMgiP1+Wz8xfDesgy17MKGBsdn4b5eHrN8XPnBoqRqt2fLkge3XkC+N2hcV2QYoWTXYRrLcSyRNozSe9dqGWHsnSqr9KrOThD3kScLAoBOB5YWKwhqqlvjrv76izoH68SV+teLN6HSu3zhXLKKyUYBKMnkfn04iRTIw1auU/t5oX7xxChqCdIFwbudxswvA8EgVYl8Gmc2rhhtAdKqRoRuQohOZ6AtP3eal1UCTTrBQOOJOWxqOljkOez3I+oLLTJuryMfpDx483c5cqHSTCNhFTdVBIvIShTsylXJbg13HopW5fzAmGFfyqxvPIfZgz2ZSt1G6+7ASmsBdW3d8TnoRH89TF7bvZLozd93AVbJVSLJl3v8m
 l4u2JqYM
 t/Y1IyWhCqsU3WCR7bBv/LQAvQnim1N4w8tHOn1tC2uDXp+m4X0Hth4Db9YD6/0ZqbDZpUKFY0xvKM9hFgyJkQ7CLXix3O2knUTMa6VhUFDE3ZyHw3lgUcdMCESh48lBEo2oe/9JEw8OOlD0FrUFXMLxWTOuJqI9Mta8OFsyOZxQWyDnCMID+uWVGHtBatCAd7nIVTKIp6ZAl7CnCUJnP+usm1GJU+xJ1Vo9pcN6ikxGkOCCj9bGaVM7E1OoXR63Uyv2IJieUz44L0PdYrNc8ZrfdysMASchffOysH1ZeDzB5OGaU7QCiKcp55DjEauF9Vk7/miq6ICvG/WDpYwxRgR6yF55XTz9oipaz3cfEYDJfGef4iTDT3Mu5VkNfd2M6EzsUUIF13J89K7olbPSH6d81HemL/gHAdTST5OKwqbKSJ6SiXULSfnZeuxHuth6UF31ssYNs5WokjlNgmI8C2oELNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Apply the recoverable per-CPU address handling to add-return operations.

Native-width AMOs return the old value, so derive the new value required
by the percpu API from the operand. Use Zabha for subword operations when
available, or a masked LR/SC sequence that returns the updated field.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 134 ++++++++++++++++++++++++++++++++
 1 file changed, 134 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 46eafa1ef02a1..9ff02f3811550 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -203,6 +203,129 @@ __PERCPU_8_16_OP_CASE(and, 16, .h, and, "and")
 __PERCPU_8_16_OP_CASE(or, 8, .b, or, "or")
 __PERCPU_8_16_OP_CASE(or, 16, .h, or, "or")
 
+static __always_inline u32
+__percpu_add_return_amo_case_32(void __percpu *pcp, unsigned long val)
+{
+	__PCPU_OP_CONTEXT();
+	u32 ret;
+
+	asm volatile (__PCPU_GPRS_BEGIN
+		"amoadd.w %[ret], %[val], 0(%[addr])\n"
+		__PCPU_GPRS_END
+		: [gprs] "=m" (__ti->pcpu_gprs),
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),
+		  [ret] "=&r" (ret)
+		: [pcpu_offset] "m" (__ti->pcpu_offset),
+		  [pcp] "r" (pcp), [val] "r" ((u32)val)
+		: "memory");
+
+	return ret + (u32)val;
+}
+
+#ifdef CONFIG_64BIT
+static __always_inline u64
+__percpu_add_return_amo_case_64(void __percpu *pcp, unsigned long val)
+{
+	__PCPU_OP_CONTEXT();
+	u64 ret;
+
+	asm volatile (__PCPU_GPRS_BEGIN
+		"amoadd.d %[ret], %[val], 0(%[addr])\n"
+		__PCPU_GPRS_END
+		: [gprs] "=m" (__ti->pcpu_gprs),
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),
+		  [ret] "=&r" (ret)
+		: [pcpu_offset] "m" (__ti->pcpu_offset),
+		  [pcp] "r" (pcp), [val] "r" ((u64)val)
+		: "memory");
+
+	return ret + (u64)val;
+}
+#endif
+
+static __always_inline unsigned long
+__percpu_add_return_8_16(void __percpu *pcp, unsigned long val,
+			 unsigned int bits)
+{
+	__PCPU_OP_CONTEXT();
+	const u32 field_mask = GENMASK(bits - 1, 0);
+	const unsigned long shift = PERCPU_8_16_GET_SHIFT(pcp);
+	const u32 mask = field_mask << shift;
+	const u32 val_trunc = val & field_mask;
+	void __percpu *pcp32 = PERCPU_8_16_GET_PCP32(pcp);
+	u32 old, new, field;
+	unsigned long ret;
+
+	if (IS_ENABLED(CONFIG_RISCV_ISA_ZABHA) &&
+	    riscv_has_extension_unlikely(RISCV_ISA_EXT_ZABHA)) {
+		if (bits == 8) {
+			asm volatile (__PCPU_GPRS_BEGIN
+				".option push\n"
+				".option arch, +zabha\n"
+				"amoadd.b %[ret], %[val], 0(%[addr])\n"
+				".option pop\n"
+				__PCPU_GPRS_END
+				: [gprs] "=m" (__ti->pcpu_gprs),
+				  [off] "=&r" (__off), [addr] "=&r" (__addr),
+				  [ret] "=&r" (ret)
+				: [pcpu_offset] "m" (__ti->pcpu_offset),
+				  [pcp] "r" (pcp), [val] "r" ((u8)val)
+				: "memory");
+			return (u8)(ret + val);
+		}
+
+		asm volatile (__PCPU_GPRS_BEGIN
+			".option push\n"
+			".option arch, +zabha\n"
+			"amoadd.h %[ret], %[val], 0(%[addr])\n"
+			".option pop\n"
+			__PCPU_GPRS_END
+			: [gprs] "=m" (__ti->pcpu_gprs),
+			  [off] "=&r" (__off), [addr] "=&r" (__addr),
+			  [ret] "=&r" (ret)
+			: [pcpu_offset] "m" (__ti->pcpu_offset),
+			  [pcp] "r" (pcp), [val] "r" ((u16)val)
+			: "memory");
+		return (u16)(ret + val);
+	}
+
+	asm volatile (__PCPU_GPRS_BEGIN
+		"0: lr.w %[old], 0(%[addr])\n"
+		"and %[field], %[old], %[mask]\n"
+		"srl %[field], %[field], %[shift]\n"
+		"add %[field], %[field], %[val]\n"
+		"and %[field], %[field], %[field_mask]\n"
+		"sll %[field], %[field], %[shift]\n"
+		"and %[new], %[old], %[inv_mask]\n"
+		"or %[new], %[new], %[field]\n"
+		"sc.w %[new], %[new], 0(%[addr])\n"
+		"bnez %[new], 0b\n"
+		__PCPU_GPRS_END
+		: [gprs] "=m" (__ti->pcpu_gprs),
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),
+		  [old] "=&r" (old), [new] "=&r" (new),
+		  [field] "=&r" (field)
+		: [pcpu_offset] "m" (__ti->pcpu_offset),
+		  [pcp] "r" (pcp32), [mask] "r" (mask),
+		  [shift] "r" (shift), [val] "r" (val_trunc),
+		  [field_mask] "r" (field_mask), [inv_mask] "r" (~mask)
+		: "memory");
+
+	return field >> shift;
+}
+
+static __always_inline u8
+__percpu_add_return_amo_case_8(void __percpu *pcp, unsigned long val)
+{
+	return __percpu_add_return_8_16(pcp, val, 8);
+}
+
+static __always_inline u16
+__percpu_add_return_amo_case_16(void __percpu *pcp, unsigned long val)
+{
+	return __percpu_add_return_8_16(pcp, val, 16);
+}
+
 #define _pcp_wrap(op, pcp, ...)						\
 ({									\
 	op(&(pcp), __VA_ARGS__);					\
@@ -256,6 +379,17 @@ __PERCPU_8_16_OP_CASE(or, 16, .h, or, "or")
 #define this_cpu_or_8(pcp, val)		_pcp_wrap(__percpu_or_amo_case_64, pcp, val)
 #endif
 
+#define this_cpu_add_return_1(pcp, val)					\
+	_pcp_wrap_return(__percpu_add_return_amo_case_8, pcp, val)
+#define this_cpu_add_return_2(pcp, val)					\
+	_pcp_wrap_return(__percpu_add_return_amo_case_16, pcp, val)
+#define this_cpu_add_return_4(pcp, val)					\
+	_pcp_wrap_return(__percpu_add_return_amo_case_32, pcp, val)
+#ifdef CONFIG_64BIT
+#define this_cpu_add_return_8(pcp, val)					\
+	_pcp_wrap_return(__percpu_add_return_amo_case_64, pcp, val)
+#endif
+
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef __PERCPU_8_16_OP_CASE
-- 
2.39.5


