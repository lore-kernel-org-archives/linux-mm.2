Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A979CD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:40:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFDA56B009B; Tue, 26 May 2026 23:40:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA64B6B009D; Tue, 26 May 2026 23:40:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2876B009E; Tue, 26 May 2026 23:40:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B9796B009B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:40:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 612D912048C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:38 +0000 (UTC)
X-FDA: 84811797756.16.C6E48B5
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf22.hostedemail.com (Postfix) with ESMTP id BFF7FC0007
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oFjOk4qQ;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853236; a=rsa-sha256;
	cv=none;
	b=OPw5m0otdc0IIzVFyzWYrjDoqF5r+YZrq8yuEvM1oDY6KHcpKH6XlfXG1j+ZkIgRFF5Tbx
	wutmv0WcfKA9VToRl12rMmQnXXET16t21gA/yImUcSvmlOFK9QKhuKY+X+3GgSmWQATQ5c
	i+yyBZ/D3xkMtpEkJdMFJehfFznymsg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=oFjOk4qQ;
	spf=pass (imf22.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJpm339USLr3ZYM719LtoiE3fktdOEdjk2CrZTZZdLc=;
	b=nINEPbRkO6qxvipJ4yY7Ky4SP2panmM0KjltT++JCADGruOphBSGqdkMhXiblXpBcHPenJ
	4jcpuIukIZvVRGtmATEoFgH4iwuZv42eVyAr9ISeZ79sw16WPQY3sYgC5EDIkFhLH6pnZk
	r85jxpvSeepEkZa++qEP1fjlu7r9qRg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853232; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=kJpm339USLr3ZYM719LtoiE3fktdOEdjk2CrZTZZdLc=;
 b=oFjOk4qQhMiG8po92VVLk9UGTEdsfPyQrFr9BomK8iJHh708mm9zzBxXZQ6TVZIJm6acg+
 pIOrHYW0J5avxnddrvuFXKJva1Hi+xwp5A/qPyVKdyQjqt4cR3TNoZX0enxsAL5kVNRoY+
 fF+DTM/v0oDf5lilrLp4RORkejPyj2yzi2LOow2oCJpj4j9J7SgfFXi3FfBsn32FhodHg0
 4vMLfjj2BgxfOzbLegZ0IR8ofrkFe6bw3FkWVMdJ0onztcyzil8mPQB4J9YdZh/S0hHn+t
 lc0us9jWcHzpFKiTWTavFA8FZaudtlu9tNRdj3/ZhzMQWoJms+gFIQsbYBrceQ==
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v3 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Message-Id: <20260527033636.28231-8-lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:35 +0800
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a1667ae+880a19+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BFF7FC0007
X-Stat-Signature: eajwcy9bjgps74ie18864r3w76bzimwb
X-HE-Tag: 1779853236-697267
X-HE-Meta: U2FsdGVkX1+0/ezxmXO0fk2L/vzdOAVTaMbJ1SAtb3V5T5gCo4M4CYy6ofq7zZwS8Xw4BygbrUe4O9CZxUd+fVcIsWYoBg3VGxyty7+TvWCsbJHblq6okmE3xe6ysd6pFNODru+BAHHkIox9zQDijj3D+c/UcPBxhWEnQCIrHpwyfUmON/yls2gfvbz9rGtnQae5dfLd3NgqVQ3OnByiXMF5TFlTEfNLV7PvxRXCSVSTPTNNdMC5Mo9PZ19l9kOnTKw5DGSmPwTFpYFEVh2eXD+CcEUQ1jQodMfXWx1QeOhRKXdV1QYA1rfcupOtOD12gx4/YHxbzr67bmEiknB3B647u36Ebaoy/56Mi1T3nxQBNss321xZOX1zrLuKOR2ZpsEHDmc2S04DEP8XAoQ2ZT0+xcrl1LF+6Rz/KsFpuGKloaCLwcrLue+LuZ7FxH4yHIKu1mXu2fTsm71GGYebm3OVahUuByuRKb6dHcRFjDPhdxiZJzT+hUwSm2ub0AIWTOUwqdk5kQipIBAAxQehrcs4ejmKUeqjwR//ViWF2yjwH6Oqpr/09WPoqFyCmOqIAs3DPyXpeBEaCo780Pw1FEudWXpu3YpMv56YMoHrqeUrVG3Cf7espxU23eY6OXpEJgJUb3moQ0o7yA+RiWcLeqffZME49Z9+sXN/xJEI+EMMlcA+ABoq2Zh8KtMclJoRamXaOx86h+vqu48eOf/pgTm1tcYw5pMO2B6m4glXcVChUOiFZ7eEtR0Vl2+9uGocya+Pc4ncRHQsG3p8kM2TJMDxN//c/AOI9q3swHo6V8oIbmKTv3ydjT8pqKWDUgF7Sguh1FaBeRQE2nFEzntDJJpsrqiwpfwvI1YYmuls4ASr2cQiDbetaiY7WtOsFWG/3vHh8rwoz0oQAT00K/JoRROo6rV22QdxX36oUQLJJlVcw2Iw7rf/2Ui0pqkSpyKUtp0uK2oOE/pVtVqr1Eh
 G83YCd1l
 xX+3eiAWSqLsBP4vIrP22FdMdUvzhzYbfpSg5IZiiLqFk38gafc06FYKupK6fOm4dTsu+IYH5IP+36Y3FuYfipl73O+bn4FoKMExiwDBt+RfmH6z5zXFwEnX/ap2rABxxMJwolTCyt7sm5f1GTZxsDYeze1KlZMMlrjg9MHlaeNsRk4G57Mdjabfxmcjt+Nhld8FoAcY9oRiO5sTpM1vFIsScBEHB0jgoA5g9drtW2DknrcaxwEDdNBKqKm6M/MrgV1sLREq0OmOrCjNvFFQfI1HATSloYawR81fyc2Y9gRNXuAFFUfYspBtxEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small constant-sized flushcache copies currently fall back to
__memcpy_flushcache() unless they are exactly 4, 8, or 16 bytes.

Factor the existing inline movnti sequences into small helpers and
extend the fixed-size fastpath coverage to 24..96 bytes for naturally
aligned transfers. This keeps common struct-page-sized copies on the
inline path for the upcoming memcpy_streaming() user, while still
falling back to __memcpy_flushcache() for unaligned or uncommon sizes.
Zero-length copies return immediately.

Issue the fixed-size stores in ascending address order so
write-combining sees a forward stream.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 125 ++++++++++++++++++++++++++-----
 1 file changed, 107 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 0b57e9e6f3db..8e6fca0185ee 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,24 +82,6 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
-{
-	if (__builtin_constant_p(cnt)) {
-		switch (cnt) {
-			case 4:
-				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
-				return;
-			case 8:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				return;
-			case 16:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
-				return;
-		}
-	}
-	__memcpy_flushcache(dst, src, cnt);
-}
 
 /*
  * Only reuse memcpy_flushcache() for transfers that can stay entirely
@@ -123,6 +105,113 @@ static __always_inline int memcpy_flushcache_nt_safe(const void *dst,
 	return cnt == 4 && !(d & 3) && !(s & 3);
 }
 
+static __always_inline void memcpy_flushcache_4(void *dst, const void *src)
+{
+	asm volatile("movntil %1, %0"
+		     : "=m"(*(u32 *)dst)
+		     : "r"(*(const u32 *)src)
+		     : "memory");
+}
+
+static __always_inline void memcpy_flushcache_8(void *dst, const void *src)
+{
+	asm volatile("movntiq %1, %0"
+		     : "=m"(*(u64 *)dst)
+		     : "r"(*(const u64 *)src)
+		     : "memory");
+}
+
+static __always_inline void memcpy_flushcache_16(void *dst,
+						 const void *src)
+{
+	memcpy_flushcache_8(dst, src);
+	memcpy_flushcache_8(dst + 8, src + 8);
+}
+
+static __always_inline void memcpy_flushcache_32(void *dst,
+						 const void *src)
+{
+	memcpy_flushcache_16(dst, src);
+	memcpy_flushcache_16(dst + 16, src + 16);
+}
+
+static __always_inline void memcpy_flushcache_64(void *dst,
+						 const void *src)
+{
+	memcpy_flushcache_32(dst, src);
+	memcpy_flushcache_32(dst + 32, src + 32);
+}
+
+/*
+ * Keep common fixed-size copies on the inline movnti path when they can
+ * stay entirely on aligned non-temporal stores. Issue the stores in
+ * ascending address order so write-combining sees a forward stream.
+ */
+static __always_inline int memcpy_flushcache_small(void *dst,
+						   const void *src,
+						   size_t cnt)
+{
+	char *d = dst;
+	const char *s = src;
+
+	if (!memcpy_flushcache_nt_safe(dst, src, cnt))
+		return 0;
+
+	switch (cnt) {
+	case 4:
+		memcpy_flushcache_4(d, s);
+		return 1;
+	case 8:
+		memcpy_flushcache_8(d, s);
+		return 1;
+	}
+
+	if (cnt & 8) {
+		memcpy_flushcache_8(d, s);
+		d += 8;
+		s += 8;
+		cnt -= 8;
+	}
+
+	switch (cnt) {
+	case 16:
+		memcpy_flushcache_16(d, s);
+		return 1;
+	case 32:
+		memcpy_flushcache_32(d, s);
+		return 1;
+	case 48:
+		memcpy_flushcache_32(d, s);
+		memcpy_flushcache_16(d + 32, s + 32);
+		return 1;
+	case 64:
+		memcpy_flushcache_64(d, s);
+		return 1;
+	case 80:
+		memcpy_flushcache_64(d, s);
+		memcpy_flushcache_16(d + 64, s + 64);
+		return 1;
+	case 96:
+		memcpy_flushcache_64(d, s);
+		memcpy_flushcache_32(d + 64, s + 64);
+		return 1;
+	}
+
+	return 0;
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src,
+					      size_t cnt)
+{
+	if (!cnt)
+		return;
+
+	if (__builtin_constant_p(cnt) && memcpy_flushcache_small(dst, src, cnt))
+		return;
+
+	__memcpy_flushcache(dst, src, cnt);
+}
+
 #define __HAVE_ARCH_MEMCPY_STREAMING 1
 static __always_inline void memcpy_streaming(void *dst, const void *src,
 					     size_t cnt)
-- 
2.20.1

