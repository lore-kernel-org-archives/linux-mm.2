Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED26C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8CA76B00DB; Mon, 27 Jul 2026 08:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64486B00DD; Mon, 27 Jul 2026 08:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7BAD6B00DE; Mon, 27 Jul 2026 08:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 946A46B00DB
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:37:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A6BA140700
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:35 +0000 (UTC)
X-FDA: 85034507670.18.AE2C4EA
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62131100005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GSFclNsg;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
	b=p+QoPAlaNRViDaKqycKateaM+o5c2AUqTH3hlDvlO+5YmNyGmLQ+AHlHPtAdJ2qNeUwe9F
	6LmW3537KlEDwoIHQY5R9xH95L9OEncLpgSPx3HM4KyW43zSuEfxshRFgAAZDgSxPbt3TW
	M80jXVHMf1OxoT5P+HY4KMRCY97Kdno=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GSFclNsg;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155853;
	b=4t5C5YOcfTZbj0mRVELFZt45oZwEzNXaOO3VnH+kFIJ/vWANPHzAPZ24vyS001tqp4GwZJ
	0CZKrN6vX05YHkUmN+I/Zsyr2ACOrlSRyIMPxB/YrJutbgNeVW8vdionMJV3Lx0kOadq2T
	hKr4NOeYf+v+Qmr1yWCaz+xL8mKbf3A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155848; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
 b=GSFclNsglDCGfGJRdtvcdheDSfTeFeYjIqDZSrsm9iA6KPjhFnN1yvwWa8BPA5rIOeiPL5
 3miHH4FA51hOjkqDaFULrWOnHQNwn4StQFiyXXL9dQ8r7ugtRtraI6gLN9zGOZt62oh34b
 DGBBtVqtZUnN/nMEjlsx3N63YjfLxCyu5ibwHQb3h1w5kMsV3cSP9N+Iuh9e8mEKUbXpXy
 K+KVqNFJtpj7mLXz4PqblUTlBThRsl2GS8P+9VOALLVZbPrCNg7FucUWP0ubCbVGGIXFnX
 e868MmEVIj9iEwGoldWT5e+CJzWgip2Grj3SbbCcSPH5fJXLLdRIr0eWmehtnQ==
Content-Transfer-Encoding: 7bit
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 27 Jul 2026 20:34:26 +0800
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260727123429.5673-7-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a675107+7e340e+kvack.org+lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v8 6/9] string: introduce memcpy_nontemporal()
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 62131100005
X-Stat-Signature: eijtqyqkon1p3m7zoihu66sm5gpdjxxr
X-HE-Tag: 1785155853-944928
X-HE-Meta: U2FsdGVkX1+07Qu02eT4WZjzSBckfDAf8o3YOfl9eNZ7HB8JlXFazBJ2XU7AWzkBTO1TtVmzEll5wNQYF7Yy6C8MVWGF8KApOv3LttMblVThQ7KeVymSlc326iBGn+BZP02i2+rAT5pBLlTvdZJdf0BpYjI0s+VWcQFMyzWQlWfrZ2yRO1Qqar4w8gg6W0qMLixYNU+wzk8Dnw9sQ7U0C5SDlD3GVqEqdYFheBpXTopcvjkMAHQlObjQa7eGbTMw1FxcyTbIQ7Fd2oOwz5Uqu7CMfN5HVhw1pPAiqoAePcrhpAoQ1X4GUodxhFZwLK0RON+37lvunNgUHHjD6hOiJzPGV4Y6/I5zfah42gNs+ePRYygnAIoSKMR3EYVgySllHWnCeQ7ay7ANFSSzC/STaxdYjx9OOjYjk9Yyi1mkTLfC97il1nn3hRgdMPqT5r9jXvOnFy0tpW+XA15EYvyDI6P1XgGusAHBQtTOXnvA3ezjbuhYENDug6c9IhcGg2nGjnLYGcke+HqjIucvZplWCxXGhgREUi5D6m2Rx1v3CC3ko9qtbBt8BL5lgaCUOjCm83xXtrfgw2axs2t1JA9zif9jUPCl6DYjQdq4shZFdcjd1E3bQiFGFcTokgpJhAEXtn6n5Xo82JNdwxbYJ5sFwOWRTx2Ex9Jvr/ibdJxadZS7sGlTds++u5r41Hauk+K/fOyiJ9E7kmV6yjGGbBvpwWp/sqBDTnUiNwLAmNUvSWKIbm8KPi813eXFJjfftS9g2r8AlSobmmspTi59pfhoBINKiINDQrm5T8immY8hKiejMVFCjdQ6Un14gKJWW9duf0NVGgXbEPgG8hsrvfqHY6QTJgPd7AaVn+fP5rlSVy8DPpukIxV77ctGUnzEMOCUfT1cko1vFGJyYjSCqUlZQ0V8cHVO8NXSZW0GFha2b3vZjW4E4kd7Fntler89q93xM3IkZakR8zcTb6VXfsN
 SJTv1fxN
 /6TTtWtkpC7dH9hZunXC+mvlpCLysBnshtS12WkVlmZwiGsN9KHY/IfKfY9jNKg2pLdBnJSZnkqA/PLCuo09uTR7jYFMO3W96Eyv6ug1vbYjJT2YtjGCN02sawnFVihABrEX5pYJG4Y7DvIvlElWHBk8aSC1DXgRgx+685b/lvFPZUBOAr2e2ENEb5OwjxaP/8yNW4H1kDdxur/pyxH/K5j3cCU65Aj4yk73Z6pLEDm9QQWH6hfbGG19qKllq7s1vc7sLwh+77iV6q4+R20t2HhM/2mYq0V0iw7Xmf6OMehjkBUW/h3KPY8dhXg==
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

