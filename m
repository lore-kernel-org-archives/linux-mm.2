Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533D1CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDC036B0096; Wed,  3 Jun 2026 04:07:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B66326B0098; Wed,  3 Jun 2026 04:07:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54D76B0099; Wed,  3 Jun 2026 04:07:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90CE06B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:07:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53C374015F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:07:49 +0000 (UTC)
X-FDA: 84837872658.25.68BA576
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf11.hostedemail.com (Postfix) with ESMTP id 504A84000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:07:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DY8IyGlf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gRJ/J0Nb17+iEYOrMVREQ16d2zbIiv+jVQRVIwQKMg0=;
	b=cHaSXycjLikxT3vh/Zn1GdgO8bPjVbsQQNn2BImvdMVLHcZ4dJ5hTZqs0SOf+SRnelqlm+
	zpkicoHAyKdJ/BOTCo2kxRDX0jzq7N0hciO4dnJBLYtLe6vy08TkSb5ygxBKMBxY/T5lAZ
	SYNdGeECdzLeEEuWjUSjYOzvK0InzLk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=DY8IyGlf;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474065;
	b=A3qH0A4IdffMCrcIJJwMXFsp45W/b0o4NRCP5mmssUTUm3g8ASWK0Gzfkd2HO2PuLtw0LJ
	zsakpwcskYoI8PNqHpYWOdplwM5nqaNF0+GtciAu+uYOBTdiBlwxmij01OF6VOR48znQSF
	gZH9KGm0PBJspKTP0ZtbgY0Cp1iFx5Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780474060; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gRJ/J0Nb17+iEYOrMVREQ16d2zbIiv+jVQRVIwQKMg0=;
 b=DY8IyGlfDIbErGRpMLd2GbNSQ0wKMYL+JMCmE+96KGPSSbrZlfhkLnyDGYM3SOH+h8AiUF
 hQwvyWFcZ/9KOaZOs92RwkHcfZg7/83AxJ04PkHwOr+NqRe39v8cJR1cQqeC63ltHGzFex
 6gqO6j2oHCfeBvyWGG8X1oY3yjuyX0ZNos8GLt2WXgBqzsHNTLhRu1f5RVsGMs6hlT5H2c
 zmznI2/xYdoQr+aD2b6JiKcskE8WnsUeydP1Ek/eITaxGIS0YJ3Gjz8AWZkoiBK65pfTAY
 /8mlpQVzMVLVMj5lnTuJUgYHMOrnaJZLLEV9oERCJyRcm/DnN6CHUoCzzyviPQ==
Date: Wed,  3 Jun 2026 16:01:51 +0800
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1fe0cb+9cc51b+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v4 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260603080152.64728-8-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1twycf6cxgtxynac8n1pmzn1z8ff5otb
X-Rspamd-Queue-Id: 504A84000D
X-HE-Tag: 1780474065-13474
X-HE-Meta: U2FsdGVkX18WUjoQ4JD2A0zB1fNn5VBYLG6NYJtKhGugYNtSszP55MfQCrAsBgYFZIIQlIrBmKaenf4MkYJD4CBO1xzr3qXFNPTqk5aD7ktwEm7xyg2g6MMPBnd2YIO0+BmH0+e30MxiPTPEUVFzXexwshFxFJg9bUuvLkTj58he+h5o5hgQw3thqodjqCC1vA3sOYWKgxjisLcaoy3EOm204z1nfvAwQBrPq70gSSQUIgVH/b6I11h6oLvrKkRbf02AXDqcz2c4TkRPSHSwSJ4QruYui/nPnsCc4VIzYVYnemZMGfzLQazaLCnm1NExC8pCauWRPp/Sp0NddNJKxnI7+ElBgwbeCkO1hzebrnGIrHzbZpw4uthFW4b2Ah6Ahok3lEVs8ao1EEEs6vZv5SlquzmYK1d3c4EdqIwTAPVnCAReqtDxCCjW3RNHrygAzqN+piVDwoiO4oBqd22iT9vTouQQFW8mo1MzEJYX3yO1TGujolKybBkdT82/r7BXhl4Cd2brpi9HdhCz3Dv9Nfv6pYoCp1yS0QHQPwtkQsD8zzLcrAbyHoYGlkSrBlyzz6axrxs5fE2o3nGgaAlLFIySKEwKeyLmWUKXboAM7ru+9lqOcTw9aMT+EeHh4IsEMgmDhoWy7D75s7Qw3TYoNlvyzgCXKnisb04VY5rgKqhTjO7DszXxpHWyWuhfhjgAtY0/GBtd8QUVXmDZkouWikzm4QLH1XNjtkiAxxEEF6VZbf/K1mgKmZ71GPkX54bfGHkFtKn87Bfmr1bjyyFYSGRjj7/UqnaLFkzA1LULRBbxDishfvW3jiTNX6i4B5devvFa9N3jMCZXausKe4M3jzNu06eNCUfCj70ktwFnt9+TH15JGd+deBctGajI8cH1jndqdMLBLJZ+ynnrn8u9At/eTfLNmdLAZrJV9ILe6M+4rh0DpezSMppfLiRscH7A0EQnAjo/Do9ZgtMOq71
 hcP0Rm0Q
 nAh3v0DnqToTOuGXMmLlYLqab/48bp1V8cYJRmHLYqZWKJhMVQO9RrmfMz6EnCffI1P6DJ8mboC9Jo8OLE4m7xBBX3loXEhlgxX/3avdQtq1PGVstEIS8JAzbr9r3OKawTCDnDcEZF13FJKpQSy+jOUeWJcs0O2gPQC0hNLIo0Z9p4mtStY9ipoPSRzB+/8p8jSeGamJ2PU9wdeJHFXHU5Evkb6VlmxGoIRSBiVq1CqECUd+vp/g9eqyXkWZP5OD4aqBSf+kfBl8sHw1cdh2JNP12Br33io06m1hjjimy5syN178yOSkjsNV8HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Small constant-sized flushcache copies currently inline only the 4, 8,
and 16-byte cases. Larger constant sizes fall back to
__memcpy_flushcache() even when the destination is naturally aligned.

Factor the movnti sequences into 4/8/16/32/64-byte helpers and extend
the inline fastpath coverage to the additional aligned constant sizes
32, 48, 64, 80, and 96 bytes. Keep the existing 4/8/16-byte cases
handled directly in memcpy_flushcache() so they do not pick up the
extra alignment gating used by the larger fixed-size helpers.

Because memcpy_streaming() maps aligned transfers to
memcpy_flushcache(), these additional fixed-size cases also stay on
the inline movnti path for that helper.

Issue the stores in ascending address order so write-combining sees a
forward stream. Keep all other sizes on __memcpy_flushcache(), and keep
zero-length copies returning immediately.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 122 ++++++++++++++++++++++++++-----
 1 file changed, 104 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index aee63108577f..16d1aac2da24 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -83,24 +83,6 @@ int strcmp(const char *cs, const char *ct);
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
  * Only map memcpy_streaming() to memcpy_flushcache() when the destination
@@ -115,6 +97,110 @@ static __always_inline bool memcpy_flushcache_nt_safe(const void *dst,
 	return cnt && IS_ALIGNED(d, 8) && IS_ALIGNED(cnt, 4);
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
+ * Keep the additional aligned fixed-size cases on the inline movnti path.
+ * Leave the existing 4/8/16-byte cases handled directly in
+ * memcpy_flushcache() so they do not pick up the extra alignment gating
+ * used by the larger fixed-size helpers.
+ */
+static __always_inline int memcpy_flushcache_large(void *dst,
+						   const void *src,
+						   size_t cnt)
+{
+	unsigned long d = (unsigned long)dst;
+	char *dptr = dst;
+	const char *sptr = src;
+
+	if (!IS_ALIGNED(d, 8))
+		return 0;
+
+	switch (cnt) {
+	case 32:
+		memcpy_flushcache_32(dptr, sptr);
+		return 1;
+	case 48:
+		memcpy_flushcache_32(dptr, sptr);
+		memcpy_flushcache_16(dptr + 32, sptr + 32);
+		return 1;
+	case 64:
+		memcpy_flushcache_64(dptr, sptr);
+		return 1;
+	case 80:
+		memcpy_flushcache_64(dptr, sptr);
+		memcpy_flushcache_16(dptr + 64, sptr + 64);
+		return 1;
+	case 96:
+		memcpy_flushcache_64(dptr, sptr);
+		memcpy_flushcache_32(dptr + 64, sptr + 64);
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
+	if (__builtin_constant_p(cnt)) {
+		switch (cnt) {
+		case 4:
+			memcpy_flushcache_4(dst, src);
+			return;
+		case 8:
+			memcpy_flushcache_8(dst, src);
+			return;
+		case 16:
+			memcpy_flushcache_16(dst, src);
+			return;
+		}
+
+		if (memcpy_flushcache_large(dst, src, cnt))
+			return;
+	}
+
+	__memcpy_flushcache(dst, src, cnt);
+}
+
 #define __HAVE_ARCH_MEMCPY_STREAMING 1
 static __always_inline void memcpy_streaming(void *dst, const void *src,
 					     size_t cnt)
-- 
2.20.1

