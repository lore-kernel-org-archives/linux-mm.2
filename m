Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D87D0C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAB06B0099; Mon,  3 Aug 2026 03:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D826E6B009B; Mon,  3 Aug 2026 03:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFA36B009D; Mon,  3 Aug 2026 03:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A111A6B0099
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:12:56 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3568160630
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:12:55 +0000 (UTC)
X-FDA: 85059091110.11.8F9169B
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id EF9F840005
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:12:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kby7+P2L;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
	b=Lxyp9YFnusiSYqHMTS3w1IaXjZz0HQQaVPDjCiq7xodEisArVYrMd6pf2wwStYvHe3cZFA
	7NvvIBdZkAVmtC0PayesgaTfKZ+7HN7Fe5qZKyNFwrZkdjN9jy9uYjAZqWPnKlFZczuaVg
	aboCR8K3tBomn8OgDMelU2v77u/zrXM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=kby7+P2L;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741174;
	b=RCq+9YAiZ9KLOdfmM3fAyVwwRZ6o6CtD3l7yXZzcTA0jVPaFPjAb2QnMVP7lj0eopywwFa
	WUvW3fUFQlmc3shK56l6wcp60Vo9IyNQVKJbqud9VAWdvqt6+6KPeRHx5EI+v+Rlji8Q5d
	ot5ZBQglfoBbTvBVmxn8vT1s/8oLD+U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741164; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=vLcTykUrPpLwId0/keP/ANeuOzuTtpvXBhogtTbcEIQ=;
 b=kby7+P2LbKzf1D+nXY4FmdwPY7Sx0WOhk9A1T60Wt+AWOH4JTLo7Yk+zKb+2g66Z5fjo9s
 NemsFflpgqiCqKP4Lr81eAIdyA6MhtfknaR+0KhR73b1mwpoyRecycdT7QiePNBz2IFbRU
 OGdsWMdD5E3l9929VE2djjsRMo4TKXwEulZ7B93s8qzKlvpOBez9En4HifkZYkf6RIe14Y
 6Y3E7aa/kzrcXjo74fjAB4qA7EJgipTDfPXvZYVqtdl7VXmldCleY5qwsrH57Q6oxe+lpW
 EjJvxxYhu4HEkp9zJu2m0Zv08U/N9jLPo1DQl5zvtfH1ECFVshxFdnHrfUmwYw==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Subject: [PATCH v9 6/8] string: introduce memcpy_nontemporal()
Mime-Version: 1.0
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20260803070929.86075-7-lizhe.67@bytedance.com>
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Date: Mon,  3 Aug 2026 15:09:27 +0800
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a703f6a+300415+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Rspamd-Queue-Id: EF9F840005
X-Rspamd-Server: rspam01
X-Stat-Signature: dqj81o9u8geygqpa93yhb9mx3ahwmnkc
X-HE-Tag: 1785741173-6115
X-HE-Meta: U2FsdGVkX1+ptRIjxq9/HDQBySfZ7OcfY1AdIJEL/r07KXuhM86Lz3Fth59Kj9zFHG3UnHAThZmI7IDxI+rv2HU5HEhZace/hTLDU+0W9sGKtwbTym+Qn8bgBBlsNrgO3kwmDxgFWkYKgmc7Z1oTGyh22TrPxPIC5mspt44nqB643AicP8I2FY0xLyWJKIV/1DFQDH/Uh6zUKJUTBQ7id2apd8Bho7U+ARmu/26R7sqHRNHyKS08PHJycA31D0XPArGbQh5ZZyB0FB/hrC+n5jwvt+f9wTPj+pJukUPK1eUtGt/4auK2XFYMgN48cIgp8LKyAuuT6N31CYgWWV/zTcycKsdBDjpSTIYOr9fE+8NvVHnmweb1DdRbbz+oNUSHS9ZpXyMH7VdnJqwG93u3Kctj9ETKQvAKPvajE60RQO3QdxLStoqcXVJQMzELI+rXe6teND0VuSi8j8wM91aVISftMK9BW3yC6WkhTe/M2zSPwuJhxmALGncWyLgb8rh4g9FB4wKOVM6Jz3SpUgxPUASl/JgGgFnwuas3FB5Di1Ud2mDjMfU5WU6DI7dyByA9FfHBo2CkzMCegSRINT9QN58dQRs3VlucX4ocqRqGUD8iOxsprYEu4QOKfTeYQ8OZnzVbB6Llc/ps06FSRmU0pEYQKxpuN4MngQR4IgIYT4Hwy5siV0No4nxmSLUcq7vUqKtV8SJAd2Jh7ijSgOfzpVqWb5i9OSh3mZS3/rBuB5/e+34/Im2puVo9rMsTKkQBcyz7+Ns+RllD+iPpyc9MG5EuVfep4GnzaVNSVYWjc/N5y92ZG6TkGcsKhc1Lblc4UKBJQITuFJiiGaa3New3mibE5jkTF5bc2QLMUBj95xYzaJa8C5b6hyRN8dhWOQmuy2NosDKewXtpHJAElSt7K6lihl/o9A7kebY/aLCfLcr4jwCwyAEaFYF3IrhzT8mnUcYkLsARyPaxCAPfc5b
 bFoN0MAh
 1dJ9YocqgO1W3v4vdaf87SfSPEcKGeGZvhrT+5zSux7vIo9+AXyUpkJvOuSL/sR48HsEaty7oJN5FFEtPlT7ML3e695VviZV7fZtdxRSICUFqgifsmcwmdqLYe1f/xQ2GnwvUklYmSdXRBCpqu9kPIjwiHpBXnL0RsaOYZ/yp23VczzsCXerndJQHdOQkg/v/KE6CheUHQllU4FRfKsmQ2BYi5TD+T0qnwQIroGrM6VkOmWrgfOvLRSrpNpEgHpT7hOU7rTvKGQUqYErpOcWNuaOcNyJenz6I5gflNs57Pyn8h4DrxMkJLI88pj10xwIndsPklFK+kb57oM6XZYCL+JgT5pZtzpMgYdQKkStKMic/erwf7DBzxaNndO10qDIKcS0/4pXTZmmFVTUUDpWrVcpm0HxpaURd8N71
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

