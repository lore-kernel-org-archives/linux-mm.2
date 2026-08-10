Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B673FC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0D886B009F; Mon, 10 Aug 2026 08:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBDA96B00A0; Mon, 10 Aug 2026 08:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3F86B00A1; Mon, 10 Aug 2026 08:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01C46B009F
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:24:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44063A0CA9
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:24:20 +0000 (UTC)
X-FDA: 85085277480.09.965B818
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5325C14000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:24:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ASgSwMih;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
	b=jTuUwBzt+ky5Tr6C168Or9NnQ38qcz7RV9kIXZdFWY6PPKKCCIiWJKNxQmAlpSaRVZfAtZ
	QpQJA8ODl3cEYQyI1H9p6GU9iseEu3AIbdLdOqvGtZYipRFn1UccyZuwIq+0PV9RgJVEf6
	5R3LxNhaRLsoQcPaJp3Shb5V9UbecC0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ASgSwMih;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf23.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364658;
	b=D/Gv8ZsLiMUZPKl2HmtJmwKj/z3JiW67xXKWYbPL1wHZyVgg9OPo8kK+y0jG2EfiGaZdFe
	+MDinVWmMZ7rrJ2kT+y/0gZuhahARcVbOTn3m6IV+fpkLdAe7tKumWPj4ZIkFTA1dGwHT5
	9NteeNbY8/bcpEF5fwtBNWxTjA7mywM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364653; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
 b=ASgSwMihzIWUeCxi5uX8/oVqtNEpF9OANN0v5um83LWOXccOe/rN12Kxvt1QlZQEQ9I1NZ
 MJ+FCcLP5p2j7n6TrQjbHAdz4km/pmeS6XUmBuqjjqFikZwQ9MaeAWnmuriQW+i3EDe4G1
 RowrgxetzsBgCxXFh3gWxlVaFAErV7TCWSI3KBm+xDxa3/06KDUbn5/zIqZGN4R9AFsTZv
 gGKgMBa2cU9bTJp4MzVKShu7RiI85L9mQzI5a6U5wb11DN8bdVwFI/yzcpdfqCRUHTDjBM
 xh0sgD9eo+kx/wGGXYaU2B+TxDmQzpkcq16MQBZ+DgtQczgDB3E0O3Zko3ee7Q==
From: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260810122057.30447-7-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c2ec+aeb699+kvack.org+lizhe.67@bytedance.com>
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v10 6/8] string: introduce memcpy_nontemporal()
Date: Mon, 10 Aug 2026 20:20:55 +0800
X-Mailer: git-send-email 2.45.2
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5325C14000B
X-Stat-Signature: use66mr1xjttockgpem4ebzb46exx6tm
X-Rspam-User: 
X-HE-Tag: 1786364658-542679
X-HE-Meta: U2FsdGVkX1/pl4iJwGWTJQ+9ue4VcYfrvH20uNk335gHGz/j1Gw2Q8CoNNEWLE8bDdlOgWAK5ToBgBCQgULb58k9ZImpvVAzpibFaJd1CU0Ub3YB+IjygiRqtBixriHTuy+FyEGJby4Kw4Z7PwKerrUE0y24ZOOUJm1HAsvXM3UwmeooirPxBFta6MW3Vcbx5yWZpqTtZgfn8mCWDPNR3OyKElFkv/K8Y1u3l4zUTrzXV463ixH+2CKwTKxVMmahLlsVcLD/IUqz4wUB9Zu7UhplQ11072+17wmoPdI1LrmfRbqVka3jb+WjIaY4WsscUSNR2xFIRmsp9ket4gCAAXnVUJpVtcnndKZV99h2XeXLkcmTgFwy7uyBXcO6958wG/tRlJjMdZda/4+fTubLYeD69eq2oLEm/I1NW12g7gha4ZzEv6L16sYkHKe94KmxPDT5TFYf+rQrGj9ipFgZqAMyW2o8ExJyhsC3su6fWBvW2M3PgawSGF+wTNvBFoL98nxhJarJYN+BoiD1qn1rp2PgXcWiRDS69DpD20SOpflTrWF1OlSHU+hI42qs3hnldW7fcnrpprIJF0jKUctJRyG6PxFWf8smPsnKax++0xCrYJUIETtAbwHLAH3Cvn0IqkrAGfJSrWSuIILe/CxzW8PuforD+Burf+sGpg6z9VHoc3Adasj3nik5N/J9xbc8QMTuJi6yZqRD1nx6/SSspRNOzE4FzG11cujBMSlPyVR7bPgU+f8GHvlAgJpNL0wP+dmoUfAonCUacsteRimrXWt1y9WqRqnhk+1/es9IUobvi0syLu+UnOYwpWH11sVoZiXZvIBrOnRGlpyvUURkv5Y+vgMtZSUx/3OKvVKUOfR3i00ZV5eh6uyeW2ZeNYsWzWpCSd+9NYTbB2FH9YihcbBC92UdRZrHDfWdK29ZY8O/1yPWsw1J9dKzkLLbL+keEyELolspjNKPNBQCglm
 aK/ww9DM
 m8SX1Dau6uWBgXUao2SdLdWEufiRY5/saevND8cwbUs4r/m8BFbhYvWdGChVZaB3w95zq92qY6heQIX8r8UWIOdzKKDvST0/4p6M3qPAwieeQazY58olcusw8s3mVDh7K5xj6cX0j8HyedQy8Tm0Wh9Ez4I6xfjgOgJN5w+w6FGcTNYQU/RhaS0QrtDJlro54GKaLgwx1458nRkEUuxFQkCVVTWPWJIhXBoqy61EWCXb+SOaGgI2JtgV49UBiZN/3U5vGHlAfmqWFwpWgsfyVRu2Ei89HSSzH1ukBOt25d8/d2daCXX0/VidafsoAdPrznkx2GheLxoGi9nYV1xArxi5HnIgGPq4e1BCurG6v+4rrPbZ302/z0FKU/WYm32Vl6IcWQgAfnh6wH3R+dzCZIcPNxrVU8d4RKNiy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce memcpy_nontemporal() for write-once copy sites that want a
named non-temporal copy primitive.

On x86_64, override the helper in arch/x86/include/asm/string_64.h using
the usual self-macro pattern, next to the existing memcpy_flushcache()
backend that memcpy_nontemporal() wraps.

include/linux/string.h provides the generic memcpy_nontemporal()
fallback as

  #define memcpy_nontemporal(dst, src, len) \
	((void)memcpy(dst, src, len))

instead of an inline wrapper, so architectures without a specialized
backend keep the usual memcpy() FORTIFY coverage when the compiler can
still see object sizes at the original call site. It also makes the
memcpy_nontemporal() API uniformly void, matching memcpy_flushcache()
and the x86 backend, so callers cannot accidentally depend on a return
value on fallback architectures.

memcpy_nontemporal() is only a copy primitive. It does not imply a drain
or a publication barrier. Callers that use it before a producer-consumer
or device-visible handoff must provide the required ordering at that
handoff point.

The immediate user is the ZONE_DEVICE template-copy path. It populates
struct page descriptors in a write-once pattern, so a regular cached
memcpy() can incur avoidable write-allocate traffic and cache pollution
for data with little near-term reuse.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 12 ++++++++++++
 include/linux/string.h           | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..21ae515ae35a 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -100,6 +100,18 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define memcpy_nontemporal memcpy_nontemporal
+/*
+ * Reuse the existing x86 flushcache backend as the non-temporal copy
+ * primitive.
+ */
+static __always_inline void memcpy_nontemporal(void *dst, const void *src,
+		size_t cnt)
+{
+	memcpy_flushcache(dst, src, cnt);
+}
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/string.h b/include/linux/string.h
index 5702daca4326..6cb5cdd01158 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -278,6 +278,19 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef memcpy_nontemporal
+/*
+ * memcpy_nontemporal() requests a non-temporal copy when the
+ * architecture has a suitable backend. Architectures without a
+ * specialized backend fall back to memcpy(). Keep this as a
+ * function-like macro so the compiler can still see the original
+ * memcpy() call site and preserve the usual FORTIFY coverage when
+ * object sizes remain visible there, while keeping the API void.
+ */
+#define memcpy_nontemporal(dst, src, len) \
+	((void)memcpy(dst, src, len))
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
-- 
2.20.1

