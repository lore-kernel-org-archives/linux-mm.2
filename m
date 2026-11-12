Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77EB3606A894
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Xs6m1ihU
Received: by kanga.kvack.org (Postfix)
	id 9850B6B00EF; Thu, 12 Nov 2026 05:45:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 935FE6B05B0; Thu, 12 Nov 2026 05:45:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8244E6B05CE; Thu, 12 Nov 2026 05:45:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6138E6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:45:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F2F28804DE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:06 +0000 (UTC)
X-FDA: 85426134612.01.7B7C629
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38442100003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:45:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xs6m1ihU;
	spf=pass (imf05.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=INpeTcchLLbS0psUlyWopVBCXTqH0HdLEcZJcLgnzp8=;
	b=Lsn/IVXyIxCSa8Fv8kdHMGwSyKAX8tF2lpLMHleSQIGMl4/H4BxSTc/evbGB5AFoTdzSJF
	IRD9doVYkP1Wd9M+bvCK1MTnqbjDmVRJG1DNjT4AdBzuvm5dBs9TTqGZOq2wnYco58dxA4
	dc942l8GWWE2iQGxhIjWDMaiZkz+i3I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480305;
	b=U0rnkYMWE8UONxDWn9rKeluKS5ltyFWF4bRGkkODJFK5YsD9D7Efox/ex5O2Ypvj0B6aLU
	Yh+UhPpWJuJtkr2vd/3awKnfuM8WnaGtXeCjtCrObRftkIhX0MlGcW8zkjMnQG/MKhT1fp
	WSCJch2pTvNaHzl3QuSPp6+mZ/8dMBY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xs6m1ihU;
	spf=pass (imf05.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1a3c08d6928so6810575c88.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:45:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480304; x=1795085104; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=INpeTcchLLbS0psUlyWopVBCXTqH0HdLEcZJcLgnzp8=;
        b=Xs6m1ihUwiB5rNZ3gEHpywVD3uRwBGQnhLHhTUwjrGf8jz2L9d7lm1Bt7zg2Rx1Rrt
         rLI2jCJ37FNaV/HUPte0u1UMs6YFK+N0PC0ikiIoY6XuOghp4gY7FnFLmg51N7wtu7LE
         WNAFLosRJxFEbumXbl2UmPNOunbqxRq8ajMoYUFBwEbGycuF9kwgjxXB+wwAlUM7RP+B
         r3niu5g/plk138O8eopBoZ2EeBMFOlUh76xzA3hIhnziFwVxIlLpoOLSk1rzcqVMoDmD
         y3C79t/1SLa7gxc1RUg9GZSijnNjLIox2JhXJw3NeKxfak8aEoXrNUZSsSpYjDvYWwHA
         OXhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480304; x=1795085104;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=INpeTcchLLbS0psUlyWopVBCXTqH0HdLEcZJcLgnzp8=;
        b=h63AHKgLhRUUG3p3QiOkukLQu4eH2dpdo92nRsJ8CtgzXYPZbSYxnWczSISZGdeU1A
         RpG7PAOTi+lkKSR38GnTa9A7K1XwvUu3olvHUKjisXmPtKgFGtVBUovKRnZcvN/yT/Ii
         xJy3a2rgiifS1289Ld+VIyfruWBy/SstditY8IM8oKI7pnW5W/lBZbS8KbEwckqjTMMd
         TaZeKS0TJNlWpyXc0JvsSYKAzV33FcCucn0egNoQ2Qv24N2+xns35H05YtCem3QuP1oe
         GFywFPZwaCTgXl3fHBEjuCu713MHOm+dFYYzKMG/MKRapKuSYsT1i66/kDP1s7ssqdpI
         m86Q==
X-Forwarded-Encrypted: i=1; AL+hErGm1DNdd1aL0Tyhth4PUcYRkxkZP3X+lxY+hdau3uohS5QwZ/6+eCVbyADQbquT9/5JXmL4JDv0oA==@kvack.org
X-Gm-Message-State: APuU4Z8PbY8X2UxnCJ4Fj868emVIQbDwvRgF1l7Fl3jHBTq3oeP7fVDu
	KEVMRrFcqoSHFXaw4StNndq7KoEdxYbKeMJPoYby/p1CRdbJO1EBSj12v3NL4yvTz5o=
X-Gm-Gg: AYBFou2LdpyX8wF0p9JYyWbwZnyl1zkJ5tew5l8g1PbR5bNdRm8Ky2mMP4vt8jPP7zQ
	WgpVRJs6UWUXC1yOtjzvWvN8UQfrDpP4MlzcK018cKH+mib8eTQDuPPhibuqeHCIV9giM6lSoxR
	IcBCfG18z3R6UnFkt5/Eih4UO0b1RYGB+/UlwAWaYWLDNMWN6zJ/bSQVwJNq/s4uOnPcz6CiBWM
	1oAwopEVpV/DR3TS+IjujBIHJGeb23XNQhAb7ceI41zZBp4fdp6SvDimvveVO3qMQ28e+qS6O5e
	dIx7+U8zu8j2S3hxpzmC62Bu/oiV10vQ4OVcyGlMbYwGPbowSJc4mH/W7jcCjSIMwtmqX3QBSp/
	Dv3goHtawtX2LkI+YsqBpb/ADVqnq1CNqM7jYLtLrdKPc1VWvqkDldJro2DLgjQ1tHBRrx0DUni
	PbzyrNsja8qKscnoXmr5jtRuOYk+dHznw4KXDGuFhFmK4rCk+2r5Wrg6hqa05VfZOvHyYT+1w5F
	dGVQiRHtrqNTecVT8BQELNhGZraR703PN7rWJwAI92EgMIJfJREqgNsAz5Z/ddHd0ij/G/9wllV
	+rNuHJJRCljtPz8dn54g2MZRardLaTD4kpWPllm/m6zlfJV7whGfm7SS2Ilm8k8Kggs=
X-Received: by 2002:a05:701a:ca05:b0:166:5552:780a with SMTP id a92af1059eb24-1b3c02f379amr4916378c88.8.1794480303681;
        Thu, 12 Nov 2026 02:45:03 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.44.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:45:02 -0800 (PST)
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
Subject: [PATCH v10 8/9] riscv: implement preemptible this_cpu cmpxchg128
Date: Thu, 12 Nov 2026 18:41:48 +0800
Message-Id: <20261112104149.38589-9-cuiyunhui@bytedance.com>
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
X-Rspamd-Server: rspam09
X-Stat-Signature: 55xxhw61cxgkqjddath4aw5pmptqwxqo
X-Rspamd-Queue-Id: 38442100003
X-Rspam-User: 
X-HE-Tag: 1794480305-829365
X-HE-Meta: U2FsdGVkX18Ph00pcGdxFojD+wx4euW4p4yUjlmUvqOsfZSNpX5qVr+aOXkoAeCAQ1nKqX3nWJAKBfSiic6qe8iItaCFJFYz/xxSn37G0s2DeSG5+shstuRD2f4Ot5yIny5UEnCRpXhoQDAYERb7PvpUX6ecl7FoFOw5iJvd/fvsvG444gg7JYSi5zrCbXROL3rfGOUmTXHOGDcjByY3MJuYmNp6454E9SKdCh9Zr2kQRMud7qvA0pzHZTzv38m02KdAaY7dgX05VqQzsrcFT4kAgNju9O7Ql+SMMyRx3JPVXwll2faCLPp+mdVUKwB1IAUtRXGytTc9SGJBs/AStmXOukyTZoRzHSQjmDxx2NL6JVemqscG44i0F0U7/PLNPRiC9KoNZWuanD5pV2qspsrZ4Xse/OJTrUaXo7SWmoks9VzA8Oh418nIEk88bQjWadnDoNWq4nri3YSe+2Ez7+mSn3G85UukbBKSAr2hvqVg7S9paGswyNix9evp+260qJg2M6Y31APwVEoaPJYB0Qu4cRpR0vqHbQ3+y7LB64QJyX2NMKlQdpvSG+lBgTyyBwSI3IYHp5Dtoy0e8LJHQwIXE8toAc8E6gjoiNQIDibhMHGYy3briOyQWYA/1UbfrVujay5RzFfn+y5DDou9SrI3OVmt0pRDZV2XnTMc8enhcbr88KbmPf574TF7NeZF4WUwPHbjKPftpvdMGuAbJnqbz6Gis+3F91R6sBUufO1GIKjfpjuw+NTK1Jw3sH/NsH3PWOsgBLA+ocDStqkbOTHp/jPEQhkA6zheBedMeGL68ITKAGSgZZXvaOrXJdaADqc+s7Cm+g6DRh+AE7OopwaHbjBA2UeuJg9IV0k90uLGH9HA+CwJ0oapnc9dJ46XfdyQ7um7QclRORGIzI3Ny9xX+MTkAkS/4rJ6+1HnzsB5tepIgTHtN/OhhX7W6euaNhJzBw3vUWofEtOsx8V
 9TISxD9C
 bSKoElfvVCNNPn/b2KR62Bq6jJ13Wgx4crz4gWEEPhYyeD0K7y5Tc/j7dBvr1pHGZAUGSO7VM6O1STq3xMkAigmS4MC9K3PfwW0o4Sucf89lehDU4ca8gkmQex27JdjSWEAd3af/njUy6SLQYiMnMVRqZxSvDWfDlISfWQeb9/aARbR74IAWeVwK/v1ubhSd/65yBP51Idxkh3xB4QOQIyIli8xP1EOD8mU9wU0x1I4jJES7+N4dHOEGquoCHUZ51TCw0N1B6kawdtMTKYBez89YY3LPdBnn5FD6QgRO5geHkit4bRl5geLh9QcmZqZjHEpackrIg9Xa07IyRGHdUGlJeWK/leg5MCdTrOl8rpu75/7UOxF/kTd5wXb+sJ7d5B1Y7DpigshLaNAzxYugl+W/Gq5uwFlh26YlqelBHCAG6UFmZefRWkaLh3XJMAKeayz+WUaN6OGc/PU97OvVAOaJI/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Extend the preemptible compare-and-exchange support to 128-bit values on
systems with native AMOCAS.Q support.

AMOCAS.Q implicitly consumes register pairs, so keep both halves of the new
value in fixed registers even when either half is zero. Retain the
local-IRQ-protected fallback when native cmpxchg128 is unavailable.

Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 arch/riscv/include/asm/percpu.h | 66 +++++++++++++++++++++++++++++++++
 1 file changed, 66 insertions(+)

diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/percpu.h
index 4d2fc10cbdab1..1d35fc89eeeb2 100644
--- a/arch/riscv/include/asm/percpu.h
+++ b/arch/riscv/include/asm/percpu.h
@@ -9,10 +9,12 @@
 #include <linux/thread_info.h>
 
 #include <asm/asm.h>
+#include <asm/cmpxchg.h>
 #include <asm/cpufeature-macros.h>
 #include <asm/current.h>
 #include <asm/gpr-num.h>
 #include <asm/hwcap.h>
+#include <asm/irqflags.h>
 
 #define __my_cpu_offset (((struct thread_info *)current)->pcpu_offset)
 
@@ -518,6 +520,65 @@ __percpu_cmpxchg_case_##sz(void __percpu *pcp, unsigned long old,	\
 
 __PERCPU_8_16_CMPXCHG_CASE(8, .b)
 __PERCPU_8_16_CMPXCHG_CASE(16, .h)
+
+#ifdef system_has_cmpxchg128
+static __always_inline u128
+__percpu_cmpxchg128_case(void __percpu *pcp, u128 old, u128 new)
+{
+	__PCPU_OP_CONTEXT();
+	union __u128_halves old_halves = { .full = old };
+	union __u128_halves new_halves = { .full = new };
+
+	register unsigned long new_lo asm("t1") = new_halves.low;
+	register unsigned long new_hi asm("t2") = new_halves.high;
+	register unsigned long old_lo asm("t3") = old_halves.low;
+	register unsigned long old_hi asm("t4") = old_halves.high;
+
+	asm volatile (__PCPU_GPRS_BEGIN
+		".option push\n"
+		".option arch, +zacas\n"
+		"amocas.q %[old_lo], %[new_lo], 0(%[addr])\n"
+		".option pop\n"
+		__PCPU_GPRS_END
+		: [gprs] "=m" (__ti->pcpu_gprs),
+		  [off] "=&r" (__off), [addr] "=&r" (__addr),
+		  [old_lo] "+&r" (old_lo), [old_hi] "+&r" (old_hi)
+		: [pcpu_offset] "m" (__ti->pcpu_offset),
+		  [pcp] "r" (pcp), [new_lo] "r" (new_lo),
+		  [new_hi] "r" (new_hi)
+		: "memory");
+
+	return ((u128)old_hi << 64) | old_lo;
+}
+
+static __always_inline u128
+__percpu_generic_cmpxchg128(void __percpu *pcp, u128 old, u128 new)
+{
+	unsigned long flags;
+	u128 *ptr;
+	u128 ret;
+
+	flags = arch_local_irq_save();
+	ptr = (u128 *)((__force unsigned long)pcp +
+			 __my_cpu_offset);
+	ret = *ptr;
+	if (ret == old)
+		*ptr = new;
+	arch_local_irq_restore(flags);
+
+	return ret;
+}
+
+static __always_inline u128
+__percpu_cmpxchg128(void __percpu *pcp, u128 old, u128 new)
+{
+	if (system_has_cmpxchg128())
+		return __percpu_cmpxchg128_case(pcp, old, new);
+
+	return __percpu_generic_cmpxchg128(pcp, old, new);
+}
+#endif
+
 #define _pcp_wrap(op, pcp, ...)						\
 ({									\
 	op(&(pcp), __VA_ARGS__);					\
@@ -618,6 +679,11 @@ __PERCPU_8_16_CMPXCHG_CASE(16, .h)
 #define this_cpu_cmpxchg64(pcp, o, n)	this_cpu_cmpxchg_8(pcp, o, n)
 #endif
 
+#ifdef system_has_cmpxchg128
+#define this_cpu_cmpxchg128(pcp, o, n)					\
+	_pcp_wrap_return(__percpu_cmpxchg128, pcp, (u128)(o), (u128)(n))
+#endif
+
 #undef PERCPU_RW_OPS
 #undef __PERCPU_AMO_OP_CASE
 #undef __PERCPU_8_16_OP_CASE
-- 
2.39.5


