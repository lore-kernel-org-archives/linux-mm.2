Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6353EC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:19:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D1B6B009E; Mon, 31 Aug 2026 07:19:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FF46B009F; Mon, 31 Aug 2026 07:19:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3713F6B00A0; Mon, 31 Aug 2026 07:19:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0177E6B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:19:44 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B9BBA3F05
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:19:44 +0000 (UTC)
X-FDA: 85161319488.20.4CF374F
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf02.hostedemail.com (Postfix) with ESMTP id 86E3880005
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:19:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WKffv7O1;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
	b=16qA2PFBQ8sNawGuz5BeNqVTW4DXB+Klaq1GzSae5ONMKeCbexP1RSAJX0yMJrO4eb1Qh6
	TPyhiv5+bM0sJdfPiZYWc+Apje85JjhR295qIUG3ApRAa24lT2rvRoXOD7N9zCH1oAIrkp
	G6EVwCUNa73tIwG8x6OJqNYFP4p0mMg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=WKffv7O1;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175182;
	b=GFgNn0IA/RTCBPs8BgrEAdzpttGOVr/Y5asDKi6UAEwCr/oeQBeppO7h5q3BSN/YDMaD+T
	sodV+h5z0KqIpKkq+35AwR0VeiCLfcILdTv/rBz5GYordsQg2S2ys/k17VZ0WNJr3oEnyn
	KW8U1hhDXnoIJGa/QRvWIlcQt4gclCI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175177; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
 b=WKffv7O1sbRM1osAyUrOPj/LcydRazz9CfJLkbVjpmCjPFMacahd0G5PQSYJHm4qKtCnuH
 QMuTPfJyQ4UjmUO9r8iaNPmXzxu3JIN19GsSQZR3oqwutp6VWYc4KBM05Cy3PdjipoPAAm
 4QCcIqvVZ87FFuju5c2m3mLZTr3nLm2eaYhZKrNYgwl7ZICl5LahpjZEx1RHQNGOfWNLNq
 3PNxUtelRsAzeZQyZE6onsENE33a6A47eArJ5+BimgZRRmLVf+x58bN9SiCO1drI9WpNZq
 dqVb6LspxuL2e9iy1zbvq5owwS/bs2HBwdxvoGj3MtjrZdnrjfSZp+6luKxp2A==
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a956348+018218+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Date: Mon, 31 Aug 2026 19:16:36 +0800
Content-Transfer-Encoding: 7bit
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v11 5/7] string: introduce memcpy_nontemporal()
Message-Id: <20260831111638.76012-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 86E3880005
X-Stat-Signature: yyzn3a6gyp9k45tgxc5uind6sfmzqur6
X-Rspam-User: 
X-HE-Tag: 1788175182-473238
X-HE-Meta: U2FsdGVkX19PDHmr29Qn3S0coQ9FxwaS8k1zIYcyUzgcW9mPQFQ093YTsuq+yQga+Q912LvREFdMs8Kr4WvXfx2RqHKo2IIuUXNzNqtxOvsLogn3SIl38cQfxN5rMgq2wrbEz+ypgjhDKvqidnTd0PrIceuAC6hACaW0wU1BbacRPER4pPsk8hATSlxhKrE0uP4pLOmwjEnKJ/ptRwZBzWla+djYDfHC/qS58N+GmvpAzfPvmTu1vjsUNaW2OF16SDpYNT2aNxMrwZCwUSSLji9T6FqZP8Yk/jZkff35hBKdK5aYJ5m/0mdXx+dEjeZeFeeoHQXfyAmzFb+iBDiea+UyzB9vrRz8ssOYXvh5teQu1XL7HC4Di0x6gXy18W0yS0b+riT9XyFg1P6E4lVGEW7BtualcgFGyNvd2bvr2nWZFhw1s9O+81z6e1Xnm/IMh7iXSmsFK2g71o5e1AcJeMgs0ge8iC4TNK2rU2o1pUeYcu1yewtKe+7VSgG2W0ghAHpFtfYDvmUSxN1Made0jqRQ59+OFl0NDTfhNaIqUo1oSA0vftI2EIxFWWQlN5hGGBUvpQVkhzDSwUqyh9W4eSCwV40I5VYHN7zvRyhWjYr9vyf3don2VNQRbAYke00wAuPWytrZSiHaZI+ZNKZbEQVQF7PL13bCxvYzLcd25atNPeJod1j8oVPpgtFitWSXn/YF7TGJm0ZfiF84QkId5oqyKmyB2dHV8lEoB/Pp9cyV/51WFdMrYwxsFdC+nOcYIK7WEs6zEQhNGOC9JdPSLnGub4FzAepWXDDlbo/T6IN5ACJ8AA6pJYDyBzUv2JI8IJDho8bpXqQB8dE4FMCOX5K7Uo3apWDCgrmw5P31bDgAIMxdzRIuoAmi+86ZpbpLHzKCjLn3xzT3vv2OEbVVNbShSiXuMnd5/LLlAqfN8LRSfiR1JW/sIKjAxRiHFYQ67D0vnwWGIAsfrubE23l
 PJDSDDyk
 basTKXE/omF36oxsudcwj97yUwzlFibTHftAB7EdXPvzjcgKORQq+awL/9NnTN4Yhjs4WWPNy6R0BFdD2PHz5YPgb2AEEPV6NKXLUng9PO/Nl/HT1N1EiGE2mfZgfUWgjt9seONMrBiDeG+pCGnKAMdCJRF+ZcFTwwLMVIwcRscxXZtQyBLjFbFleQ4i/tPup2YtSfSkFUV60j2QXa1/eGUyS765QyzTWuSbRSh4ltnpI8DBZfXoKhDriHtS+6yG5pqU9LM4QmwN0Gm7qXn0gfGIbuYeL4mPO4mKYCELGvn5PRg8kKVm8KeTHyA==
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

