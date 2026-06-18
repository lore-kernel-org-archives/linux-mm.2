Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 187FDCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C20A6B00E0; Thu, 18 Jun 2026 05:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 126116B00DB; Thu, 18 Jun 2026 05:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E506B00E0; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B15D16B00DB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:38:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2152E406FC
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:59 +0000 (UTC)
X-FDA: 84892491558.10.3D29EAD
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf31.hostedemail.com (Postfix) with ESMTP id F1C6420003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:21:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MD2lNJp1;
	spf=pass (imf31.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781774517;
	b=1Qpr76em4tB3xAUfwTHKh6UanIU73ZBTmiJkc88iDvstlS9bh8PPQKCL6WZubre3MR5M8R
	7syrat9rVpCBwC7NdVjbMmDKDTn2Q9nIB9v8kuKZWvJxQHZNuVE8mv8gmb9Pc9USFNfV2V
	60CoX6NmVhg64iYxC+FngHJfzP4QYZU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MD2lNJp1;
	spf=pass (imf31.hostedemail.com: domain of tianruidong@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=tianruidong@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781774517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tou+gUoWEZe2fvebXTjOCap3tZyiNjWgYvWq5vHGM5w=;
	b=ROByILq01eFDX6P5XdyPZLRSGEHvffJnTVv5pOJ5HcfZqFn+s6mYi8KWxfYSpzD89ZNzAm
	yWbfaccx5oba6m37SkEkPIXeyuZ3M2hWTedzGOOyEdUFC5RXWUIaDLaKlRD1NeveZ6PUgQ
	vYd1nwiLsuTjqe0s6J+QqgU6VOdZx9U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781774510; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=tou+gUoWEZe2fvebXTjOCap3tZyiNjWgYvWq5vHGM5w=;
	b=MD2lNJp1vV6Shs41I1uQQrgEY57rNCTHvC7UABOAYSyRYEXj57Jn9T9gUyYhNKm9W3lpOte+ZcSnrULJFTJC8SGb8NTP92KUkumJQdHkIOxyTOU8wER5Q6KCnIKlQeBn3LbHqqIUYmuDKftlmSSdEunLYPzaEq/+NVWEAkpCfBs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=tianruidong@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0X56UStd_1781774505;
Received: from localhost(mailfrom:tianruidong@linux.alibaba.com fp:SMTPD_---0X56UStd_1781774505 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 18 Jun 2026 17:21:48 +0800
From: Ruidong Tian <tianruidong@linux.alibaba.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	rafael@kernel.org,
	tony.luck@intel.com,
	guohanjun@huawei.com,
	mchehab@kernel.org,
	xueshuai@linux.alibaba.com,
	tongtiangen@huawei.com,
	james.morse@arm.com,
	robin.murphy@arm.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	christophe.leroy@csgroup.eu,
	aneesh.kumar@kernel.org,
	naveen.n.rao@linux.ibm.com,
	tglx@linutronix.de,
	mingo@redhat.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	tianruidong@linux.alibaba.com
Subject: [PATCH v15 3/9] arm64: extable: merge UACCESS_ERR_ZERO and KACCESS_ERR_ZERO into ACCESS_ERR_ZERO
Date: Thu, 18 Jun 2026 17:21:17 +0800
Message-ID: <20260618092124.3901230-4-tianruidong@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
References: <20260618092124.3901230-1-tianruidong@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F1C6420003
X-Stat-Signature: pdiewfeyiqpw1g5tbxbzkqrnso7f7et7
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781774513-514770
X-HE-Meta: U2FsdGVkX1/XXGH25l7Ch7gMdatVfdXzBlOsRQkmKpWPWWsyCJ8fyvY0ObiktKrhZNlTqCjEBVdnuMaX2uIlXBuJKVglifjuBiJdupgsWtDiCw9+U7QqWdpzfK9k7a9ai8HoO6pIcmY+0UYgMTDMy1+xoZyLoBXoWJuT/5rsH59UIK43sWDD5q32IZJd8/7sXz/e95q+uYMkuHNTYJqfnyK9PZZ8ZUTbUrs5La8SdTJ6S+SuFcWuCicI9W0o3b0uwVhZI6FXBkc/mjxLQY2jZh9n9pHcFmI061rcGuSXMWx9nqPcCEsye+VEc/n3sntWEozFZe/cqBmVp5WLd3sIalsIyklAQ4sh6/O12sV/D3/QDTnJ2eL+cCeqYRSZqPrGaL6guV6HLbhyXY+armesE4DQDWcarcNiBOjoQdlpFqXyf4dEcq/IGNEKTwpoenDafFtyxY6f0aLwSSv/Y4P/81nsYRSSaZI0NOZ1EkvQd6l3YMstxwC2as0p2me8gYXgK7ZQfjB0/nFyaWVRKsIqt8aRKnJAYYUJQYTTg+he8zzd2Y4fObrU9xUeYyTxoNDZozzl760hCY8Sc/97lbMfwyFzY6fq3a+BuTcMSM9z1YHko1FzZ2Y1bP7tBcCzJofakrMz3dMCFVp+eLmyp+lUs/zn/bNbup/J4dUAc0HpcwQY4a7veEHO2UnKrIP0NjVkSOyjmzZ8wXftyhf8Ht2lya9O2SXu0xYoA0H1Bm8sQPcG8S5l23RSxf/f4tgKlTCz7+pNvHb4FfCvFsltWG7loLBbXdHDgP22qwisVJLKNd7oi2SRkhWlXGMF0WV2iTI7W4h1YYHXClFlMA5sWqKZ5D5HGxNU0dRRrTFGBX/k3I5f8DnDg7WnV1mCU+cI8ydKSVg7jhJ4Fg18eRzkVF6tXOGS5sO1BStZBt/4iDfFVyvBhFiLFZkt0Aph0iyarKdVjCaSbQFzInTjNiwQ3Ov
 0fvoLRaP
 Wh+WXl7y8RXrMDBmZYJ58pdHwq2owmyxRsTl6BV8+w4YCzDxxhL97QuNtlYg89XM8Quo3s71lfZIGUoVp0evrAl0l1fgOmBhVlItnBqnZqBwK+lZDcpPYbSzx/nUSdZ8hLAJYupW1/Huet8QYgED6f1wYzMAmcgvJiOqUv+xRS8pdFREAKsyuJ4gk23fTmUsxiejaXijN+JLDyjh9u9x2M5O66IBBTX0G34sYd4N96IN/qPfUT4VB7ItJ71E/1cf1tKV1UsgWui+z6xdQE8FHes+BDo0HF0hun+XM/1VQHV4qYvNcwZRt+XC3Mvfdkfi91PUeQ3flGUYQ7DEm+2/JVwRH6ZEmOj1NfiLzJHLfLvAemK2oEudUfzxRVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EX_TYPE_UACCESS_ERR_ZERO and EX_TYPE_KACCESS_ERR_ZERO have identical
handling in fixup_exception(): both unconditionally invoke
ex_handler_uaccess_err_zero() to set the error register to -EFAULT,
zero the destination register, and branch to the fixup address.

Merge them into a single EX_TYPE_ACCESS_ERR_ZERO to reduce redundancy
and renumber the subsequent types accordingly.

The _ASM_EXTABLE_UACCESS_ERR_ZERO and _ASM_EXTABLE_KACCESS_ERR_ZERO
helper macros are preserved as-is for caller readability, but both now
emit the unified EX_TYPE_ACCESS_ERR_ZERO type.

Signed-off-by: Ruidong Tian <tianruidong@linux.alibaba.com>
---
 arch/arm64/include/asm/asm-extable.h | 15 +++++++--------
 arch/arm64/mm/extable.c              |  7 +++----
 2 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index d67e2fdd1aee..06b19023939b 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -7,12 +7,11 @@
 
 #define EX_TYPE_NONE			0
 #define EX_TYPE_BPF			1
-#define EX_TYPE_UACCESS_ERR_ZERO	2
-#define EX_TYPE_KACCESS_ERR_ZERO	3
-#define EX_TYPE_UACCESS_CPY		4
-#define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	5
+#define EX_TYPE_ACCESS_ERR_ZERO		2
+#define EX_TYPE_UACCESS_CPY		3
+#define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	4
 
-/* Data fields for EX_TYPE_UACCESS_ERR_ZERO */
+/* Data fields for EX_TYPE_ACCESS_ERR_ZERO */
 #define EX_DATA_REG_ERR_SHIFT	0
 #define EX_DATA_REG_ERR		GENMASK(4, 0)
 #define EX_DATA_REG_ZERO_SHIFT	5
@@ -43,7 +42,7 @@
 
 #define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)		\
 	__ASM_EXTABLE_RAW(insn, fixup, 					\
-			  EX_TYPE_UACCESS_ERR_ZERO,			\
+			  EX_TYPE_ACCESS_ERR_ZERO,			\
 			  (						\
 			    EX_DATA_REG(ERR, err) |			\
 			    EX_DATA_REG(ZERO, zero)			\
@@ -96,7 +95,7 @@
 #define _ASM_EXTABLE_UACCESS_ERR_ZERO(insn, fixup, err, zero)		\
 	__DEFINE_ASM_GPR_NUMS						\
 	__ASM_EXTABLE_RAW(#insn, #fixup, 				\
-			  __stringify(EX_TYPE_UACCESS_ERR_ZERO),	\
+			  __stringify(EX_TYPE_ACCESS_ERR_ZERO),	\
 			  "("						\
 			    EX_DATA_REG(ERR, err) " | "			\
 			    EX_DATA_REG(ZERO, zero)			\
@@ -105,7 +104,7 @@
 #define _ASM_EXTABLE_KACCESS_ERR_ZERO(insn, fixup, err, zero)		\
 	__DEFINE_ASM_GPR_NUMS						\
 	__ASM_EXTABLE_RAW(#insn, #fixup, 				\
-			  __stringify(EX_TYPE_KACCESS_ERR_ZERO),	\
+			  __stringify(EX_TYPE_ACCESS_ERR_ZERO),	\
 			  "("						\
 			    EX_DATA_REG(ERR, err) " | "			\
 			    EX_DATA_REG(ZERO, zero)			\
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index 6e0528831cd3..76b18780f1f9 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -41,7 +41,7 @@ get_ex_fixup(const struct exception_table_entry *ex)
 	return ((unsigned long)&ex->fixup + ex->fixup);
 }
 
-static bool ex_handler_uaccess_err_zero(const struct exception_table_entry *ex,
+static bool ex_handler_access_err_zero(const struct exception_table_entry *ex,
 					struct pt_regs *regs)
 {
 	int reg_err = FIELD_GET(EX_DATA_REG_ERR, ex->data);
@@ -103,9 +103,8 @@ bool fixup_exception(struct pt_regs *regs, unsigned long esr)
 	switch (ex->type) {
 	case EX_TYPE_BPF:
 		return ex_handler_bpf(ex, regs);
-	case EX_TYPE_UACCESS_ERR_ZERO:
-	case EX_TYPE_KACCESS_ERR_ZERO:
-		return ex_handler_uaccess_err_zero(ex, regs);
+	case EX_TYPE_ACCESS_ERR_ZERO:
+		return ex_handler_access_err_zero(ex, regs);
 	case EX_TYPE_UACCESS_CPY:
 		return ex_handler_uaccess_cpy(ex, regs, esr);
 	case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
-- 
2.39.3


