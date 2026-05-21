Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 003EACD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69FF86B00B3; Thu, 21 May 2026 00:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678106B00B4; Thu, 21 May 2026 00:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58ED46B00B5; Thu, 21 May 2026 00:04:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4932A6B00B3
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:04:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10100160FFF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:55 +0000 (UTC)
X-FDA: 84790086150.02.88F68B3
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id 707684000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=g97XaaPN;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sicZWKG3rnoRbRKtoOQyKoCtsso6gsJrl+5CfarRJY4=;
	b=o5GQ4LlRPJcaOe1+U1NCpfaDJ6AyQhfJUru7g308AeTxBr8QINwLJp5kerLZGFs1XlKX8/
	0gtuSsiPHsYxWjLcqwdrByZuxJsiF7FaWMJVpslq7JxYbsX0LVADcw4gHj9ouI79aRGD3H
	rGIpKnMOx0cNfcBA4wkRm1TnPE1qpgI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=g97XaaPN;
	spf=pass (imf07.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336293; a=rsa-sha256;
	cv=none;
	b=FJrCasfyVWjvqeELBqvcUcP99EBWa9URR7pI7cVKGKMmEXzhINqDi1ieQsY4iKFasebqLm
	Rxdax2RD9nHvs0IKX0u8VYRVCZ6oAq0e/e7FcSYcZ6a7SbosDGKkSFRYbNYXPVGXSTh/ks
	AefmkZwxPXeYqd80ax42e5TQ4hNjHb8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336287; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=sicZWKG3rnoRbRKtoOQyKoCtsso6gsJrl+5CfarRJY4=;
 b=g97XaaPNiPJ3647z+V3QwvP0CO4Yc0HqfORoTCIKvFrimoqzaQkV1bvtnTRKOh/jY23kMa
 mMgrYAo4Cf6oswf4s7OQR832ytKyoXWXboJ36Ckxnl+KGmG1IpwejnG3Ay8RBH3ibJDH9a
 uhcHAxmCuRn1i42TfFCt4ASTlbTFjopmx1V81JSU32X9yv3UKClJT4EW+56+nZ3YbrtbCS
 OmXAlr0yWRj0Swco3HPuGWGnwq7Xtto0I2NT8drOzpF57VDe8rsb9b+76M6GzqdXyPvZic
 NDpdMTKmVZp0FAmdibr58dne/Q2Jb5Xej/1xsiD0LuIud1gXtLDXQid5HTzXMg==
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a0e845d+569575+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Thu, 21 May 2026 12:01:23 +0800
X-Mailer: git-send-email 2.45.2
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
Subject: [PATCH v2 6/7] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Message-Id: <20260521040124.10608-7-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: 707684000A
X-Stat-Signature: ghdumjduyk55omofkqyipoqefyyrjyjk
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779336293-596922
X-HE-Meta: U2FsdGVkX1/hoUuXevhC1XY2VSXjkdQiczYI8DQCzBqrplzk9Mgizron7YJbHV3YF8wo4gt33diTz7s5Tqf5B2aVwLLt5dajYgBZYN4OJvV2R4vDvwOp8VqMGcR+gPlGUCiJyo8TYYX7OygANMmmDMrHfn4WMfkUQe5tCwPJACZKTWckrien6zeqADgUYyw5ff1l4GZpQUBWDwFlPEWTxu0OQKKPfWUsvelf4O1my/d2dOBksNYzVEH9DhdMxFtrQPGfVPdS/sXVcr15c1qxXHvTLIf8c4q7Li3V4SZkAZ/plK3x64EQoUZRUbhbcMy8ms5oG2UEQ8cWjDM+p0KERHREa9glVPkNLUgMgMT8L6+XrMI/9Lr1jh//FvRKF2/tk3K3oo1s+PQnCfTNLO/LTVLxCy7wJBatnjXni7QMevFLwMAiwqlD788V0fBW1iqGM1nT+HoenGuU1si6LurAXDlx8kZtErszifNA3jFnmx75x79WsKOEAZEwI1fc2sprwZ7DMsb/a3HsAvhE6pf5RL06eMk5onWtHOa3aSVY4vNVwD2nIozUN4Mz7brVtcYUyrfq1ql3Lmi+Q78tZngCCJOifEKwqdR+wMvFJt0saLEc0W7eWVx3pDC0fiptPv1v1dVAunPEju+/G3jTqaMGQbdoCZXj1HFHY5H5RCK4gOi71wj4otwPEyLqT9v+10+4AJmiiHsT9CjRm4R0ns+04lBw+3UXEfK+2umkDWwLPulcPCD55RX91JetapMTEaoHIt8bqrWjN2DXzBdu4+gliN8plNaSPg6AlI4REJ2DPNvLCzlgKt8C5VPKzKdb2854G4DzYPnwx6T+K9dzw8AenLivXaTtDLGfHbSSrOjMR5M6wBzYtvov37bU4CkDIgNnvW0Y6vRA7OzEklnX5hEjhf6gyciO6AA/yUv6f4gEbnuNj6l01ZZ80u6K8hzEdA97LnCUdsBxRe9dA9I1Udd
 hx1NytjU
 pM74GPjFT/2oJena/4TJGmLqwRpcwu5Y9t/ECP/LVN6soVSJN9Bg21cgL4sq+dYAYjo47rOpIERabqk16h90YCC/+r6mkUVrDOfqxT2vtXs7aU9GfuHz1/R6qKnGT6usCqSRGsvMJA13ulqec3nEWaHSFa4WJ8cuQ0pJsQqSlm8ygtcfV0J4oSLyzZK7vCclqqpKf6nzAG/Lu7UnL5Fx49ha8FlDukMQrUZ+6YfjMYuyZ1yZY8qTYb8SMQqT8FjHN/fBimVhjxsLim2qagr+FgHondYgTwvWqL69tjhm88uao4q+X8+08/EcWtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small constant-sized flushcache copies currently fall back to
__memcpy_flushcache() unless they are exactly 4, 8, or 16 bytes.

Factor the existing inline movnti sequences into small helpers and
extend the fixed-size fastpath coverage to 24..96 bytes. This keeps
common struct-page-sized copies on the inline path for the upcoming
memcpy_streaming() user, while still falling back to
__memcpy_flushcache() for uncommon sizes.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 87 +++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 15504b844f1e..94dc92f287f3 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,22 +82,81 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+static __always_inline void memcpy_flushcache_4(void *dst, const void *src)
+{
+	asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
+}
+
+static __always_inline void memcpy_flushcache_8(void *dst, const void *src)
+{
+	asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
+}
+
+static __always_inline void memcpy_flushcache_16(void *dst, const void *src)
+{
+	memcpy_flushcache_8(dst, src);
+	memcpy_flushcache_8(dst + 8, src + 8);
+}
+
+/*
+ * Keep common fixed-size copies on the inline movnti path instead of
+ * dropping into the generic helper.
+ */
+static __always_inline int memcpy_flushcache_small(void *dst, const void *src,
+						   size_t cnt)
 {
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
+	switch (cnt) {
+	case 96:
+		memcpy_flushcache_16(dst + 80, src + 80);
+		fallthrough;
+	case 80:
+		memcpy_flushcache_16(dst + 64, src + 64);
+		fallthrough;
+	case 64:
+		memcpy_flushcache_16(dst + 48, src + 48);
+		fallthrough;
+	case 48:
+		memcpy_flushcache_16(dst + 32, src + 32);
+		fallthrough;
+	case 32:
+		memcpy_flushcache_16(dst + 16, src + 16);
+		fallthrough;
+	case 16:
+		memcpy_flushcache_16(dst, src);
+		return 1;
+
+	case 88:
+		memcpy_flushcache_16(dst + 72, src + 72);
+		fallthrough;
+	case 72:
+		memcpy_flushcache_16(dst + 56, src + 56);
+		fallthrough;
+	case 56:
+		memcpy_flushcache_16(dst + 40, src + 40);
+		fallthrough;
+	case 40:
+		memcpy_flushcache_16(dst + 24, src + 24);
+		fallthrough;
+	case 24:
+		memcpy_flushcache_16(dst + 8, src + 8);
+		fallthrough;
+	case 8:
+		memcpy_flushcache_8(dst, src);
+		return 1;
+
+	case 4:
+		memcpy_flushcache_4(dst, src);
+		return 1;
 	}
+
+	return 0;
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+{
+	if (__builtin_constant_p(cnt) && memcpy_flushcache_small(dst, src, cnt))
+		return;
 	__memcpy_flushcache(dst, src, cnt);
 }
 
-- 
2.20.1

