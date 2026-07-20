Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3527C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A64B46B00B2; Mon, 20 Jul 2026 08:07:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3C336B00B3; Mon, 20 Jul 2026 08:07:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954D26B00B4; Mon, 20 Jul 2026 08:07:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4516B00B2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:07:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E45A0160
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:07:19 +0000 (UTC)
X-FDA: 85009029798.13.D68CDC9
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10A62A0014
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:07:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UVkkQAHM;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0OG9QWc77q/zAL8FPrnNLiG/3kvsdhyOefV1kn8AAY=;
	b=wJ3vE/gmffkXswoENLYQRJ0ozs9bGM9TPCbVSDYa++6vNrxe7oJyrxP98AYpi5lY9/rOqI
	Z76pm1YCpINs8oACEQ64JTHiwFxrM1Cgp0rXugvSDtP5w9aTXj3FF3tw83L5lehueKWNQ7
	8evgqd2ozuQeG7a2bmB6lsolsg7M0nU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549238;
	b=UzLzwwUpX/MjcZrERC2vwVdqZ0HkdRRBMWC7hSAMD3aVO1DCo29fEYddAiQBFoqd1FgGaN
	9Fu8LqM8Csz1GILkgfp8VvBLvVWyXA2N6/Ly4k8DcMTqsKXa0bxSMAIW6/+9H4u5hVYqbm
	wraCGkobP9QO/V9anPRthDxqinn9PiQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=UVkkQAHM;
	spf=pass (imf25.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549233; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=D0OG9QWc77q/zAL8FPrnNLiG/3kvsdhyOefV1kn8AAY=;
 b=UVkkQAHMLAeDzlYg/0cLIGmCA4LcXbccTSAL29whzLZDcvB/FJuYzSRR2qZXK/c9qfX1J4
 xDzH5LR6rEgEsGl/xwJV27XpLvQNi/pZxds54Bhtd5aXLoVNOZ2cz4KrpdzKiKJ3v6vr0k
 V/G2fxSK1gRST59EGJ/RTkGZIW69NCrmwqB3QImNdqjcJlN1y8De/nR8pLtWVRnxvUUuTX
 LOrkHBpkcLe8fcvtvO35hX6omqToioenJV6oAnKv4pOQf5cnjbp6nXE2/n+9G/WK5RFi7G
 fEskuZoGK8lyaB8uBWmCI5iFVg41C83OCONbajDf5gWH2EEoJD1x6uAfgpXcvw==
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v7 6/9] string: introduce memcpy_nontemporal()
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
X-Lms-Return-Path: <lba+26a5e0f6f+3f9282+kvack.org+lizhe.67@bytedance.com>
Message-Id: <20260720120259.1545-8-lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 20 Jul 2026 20:02:56 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 10A62A0014
X-Stat-Signature: 6fj348qtyi6hgtgdn1bmgu4k4mh3qhio
X-HE-Tag: 1784549237-289379
X-HE-Meta: U2FsdGVkX1+UO+1cVY4f+d3N4/VnR83T9nxDCWhYgq2iF0vKbEza6HdnznJdNQJA7FAFZMxzRnrTxWwNrt9LSz2KpibkJnjer2jhy7CAh73iNTRDlwcMd9k+F/ZCau3aYLbd+jCeWkO9QfAVZFtU4e0J5b/i1S2SNGd9ylQufqAl1wy3cns0wnMun/lZnEM2aiO3LDNE7DtnsO27YhyHOEzZPTvmxYLo5gyo2Xwo5x+b6aCpTYPB20dF5OyJj1E+7Kmny1Ew/zyNLlIELCy59Wq1BjvyEfqD3SBCw9ZQa3tvbqH0juJ1eDPmaNW9Y1Oe/QswpNLWZsbS0/pi0pB2wOWwJVDAOw0JyuWrLixePFU72qh7DDPAixIAnotRTcDakRHUu3fSTvPgfMocf6T589I//yJm8O2MCHYf5qXmE3KqCROdM6qLMLyuhnAO/AJRi8t9oIO/oLhwqYjgkUBou894K+xZL784hDSJpSbtPfMCEpj3PcC7LY1LsHf1TXECNiq97jSQPRL2lCigX4/PN1a3gBD7CqqX4yv8dqxV8YgroOFAz1YB99+TzoHf1oduz6TI4YB6q4Y6GerGKqIxJ3GDo2bA6wGdpBZQlAdEJM1UbfSPmIgjEiNLxZUdtg2B9g/wEC7E8zUklLybEesKPxsbrcenVg8tAob2sYHzxNlGTKf98/tQKG+3Y35Pc41n+kZQl3/6cS2pplYZfzxiLS3thjN2Ph10A2RPV1Qt2GBs+Wshl+rhzfL3fr9NSXNESoqwIAGKrtMyZhBYA//KkW/vY9NNF9ijBSPcxevPGUJocG91j2sS8pWModz4zUuhG/dbLmm/+qTn3G3nWuXsN/aZ1qquOx9jYg79YUFFB1yhlqz8OSKJVMB/t5Wnl+RV9f77PFUzDiyJL0yjf/DOj+k7pndkByf7WWLTTVeqce542Y8bVAbqoByGJUrHpDuyxQr88pRO0dsBusvwrNk
 dCipEA6R
 /XLt1FC+it8LfFD8I3tAtuscOP8H03k6+nqWGpp+gFd+61IaZDjsxUHmHxRSnQJis5CLN+kfCsiX2li/B8k2n6i54sJR5tH9/vct3EtO49LQP/ufm1ZSyrO2nc6LU5QWyzJaDcf8LcNR9s0UhbWloHSIXZhMn0ZMI7RNqttopfZtJSX9NQbgIlWG3jUJF5Zcxlrlt4CpiQxuI/jk7Qoq8ucLfjQz48eClzM4qOPGloER9zsGKtlWMUyEv38qOj2mRQFBNYEwaCya6kKGIHmpZ7frBzNmY+3uCtSR9ZoCFI1mhMtnP1bX+rLLQJw==
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

  #define memcpy_nontemporal memcpy

instead of an inline wrapper, so architectures without a specialized
backend keep the usual memcpy() FORTIFY coverage when the compiler can
still see object sizes at the original call site.

The immediate user is the ZONE_DEVICE template-copy path. It populates
struct page descriptors in a write-once pattern, so a regular cached
memcpy() can incur avoidable write-allocate traffic and cache pollution
for data with little near-term reuse.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 12 ++++++++++++
 include/linux/string.h           | 12 ++++++++++++
 2 files changed, 24 insertions(+)

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
index 5702daca4326..9815c08867d7 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -278,6 +278,18 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef memcpy_nontemporal
+/*
+ * memcpy_nontemporal() requests a non-temporal copy when the
+ * architecture has a suitable backend. Architectures without a
+ * specialized backend fall back to memcpy(). Keep this as a macro alias
+ * so the compiler can still see the original memcpy() call site and
+ * preserve the usual FORTIFY coverage when object sizes remain visible
+ * there.
+ */
+#define memcpy_nontemporal memcpy
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
-- 
2.20.1

