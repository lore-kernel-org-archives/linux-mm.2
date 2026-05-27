Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E502DCD5BC9
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B2E76B0098; Tue, 26 May 2026 23:40:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5647B6B0099; Tue, 26 May 2026 23:40:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A0876B009B; Tue, 26 May 2026 23:40:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3810B6B0098
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:40:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0AB7D14041F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:19 +0000 (UTC)
X-FDA: 84811796958.21.84EED23
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf17.hostedemail.com (Postfix) with ESMTP id 272EE40004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:40:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BUEMh2TY;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779853217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7+PWjKsjsPUzsocI71Frs9HaxpL6NKJS1KqgSbi3hg=;
	b=KxPUog121xwIXGR5oJ/vyfNynzxQyV6dcEPYccs6z6c/rwwnfOgsjCUkJOCNgHbCPcZVS3
	ruW38O+8UtL9iyEW8cl7GjmfzMYtsej5v4yYkHMFQ48U/OxH3pOzJw33r/IiQtfMCTTfc4
	WVX/3Tq3bYDwuqFztR85uRFhqwi4z5Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779853217; a=rsa-sha256;
	cv=none;
	b=QWHWiOvtKyN/yfHxbMSMiUic4XXVDbyHgNJUcNqcHbQjG4kOGN6DivR1qWx0B436RlNzjF
	JdznNZu1W6DQjb6qfr1h8xdlCzaJuF1en2sT/7MlVWjMNxHnRrnUxzOk3Jf6MmzP78iVRo
	SiPUlLb76hj78THR9siUJuZVJ9iFbLw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=BUEMh2TY;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779853212; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=F7+PWjKsjsPUzsocI71Frs9HaxpL6NKJS1KqgSbi3hg=;
 b=BUEMh2TYjUvViIEzA4OVL4DIw7FAUWHcxv50JsV/OnTOKYPtsojjsDSOpJ+5NXHqC0DNF7
 43q5D4BojNXqZqn6p8JmhG8F/CjIO7HihfQKb03RNHnBWUaymYlD9exW5m/uRiGHIQQk2H
 HLW1gGk0fXVQX5I/HujSCb9chz8qRhx8d8yE6mZtm3mdau4lzXeCZ7VHcpFAvochsFayiY
 Ac6wPehFGakMqWKSRy6ZQs6T9mhRx2g3uK3xnhSlzQWDQEgdBTX+gDPWks6nLJKh2LIsBV
 9fF0ZYQWni0CUSz8/E1CqGb1d+U3jFykG4p/0cSNyOOPXEeutgtyYEWoL8SANg==
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260527033636.28231-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a16679b+87296c+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	"Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 27 May 2026 11:36:34 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
References: <20260527033636.28231-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Subject: [PATCH v3 6/8] string: introduce memcpy_streaming() helpers
Message-Id: <20260527033636.28231-7-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam11
X-Stat-Signature: 1iqft9mm658g9yjspdxszdrq5q4wu4qb
X-Rspamd-Queue-Id: 272EE40004
X-Rspam-User: 
X-HE-Tag: 1779853216-169828
X-HE-Meta: U2FsdGVkX19IPBE3Krk552uYU2yAv4HD2o0BY4DzBfZelKHMHfDfzIF09kxZ5Eq7qR6fcBzZOpK07edkuE66ebDaYGQjKqF8dpNj8LAYp27yIVxuLFx5z/BgWPZsUKwmUyp7cefl09ZFTlsRH//wUj5/g+xRuieb3TDgjdzoCuwATmTdqMEshtvARreIySAel/TF4DRzwB1fEUM7HHtYuokZ7Bq0H0t7PoxpCkMluIUnvgRqndLQm4RftBDkoZtxoS4yABEWpLcwMnYjEbHxQ3mduYI4MJhavwoGaNHqiHjUlfpbVFAzzAw1EBLZPfMZ0KOuogm8B8vsI5p1tYvb6cdcMUqbF49Iaq4rVCMIGTHioXU4rps84DSam2IcSt1uGq5M+gV0C54Er9ymfHWpqQgiertfLLTf4Lns9NSJwpiG8NJ0O83WUirqOzPTukhdS2yZ50DsR05aQD+UCx+wB7X5DCJ+9zylj8tdn24WVPQ32lBYQvDt26ZXyznZIWd+DpiTIH8yzVf1c/T41HmRpOScGhj+VBpT43hr8cqboyBHEvrHjQJxVGvdVGH9WP2Rj+Qykj4zwT0PruJlsDOyDXpKTTiq2S1qF4RCWk3/6RHMxGxQyessLjC/BfPbRFwSoX2WTnuu1jtJh7NbE7dZXCDcH0HDwtf4B2L1ROXoGCcWLy6STG9jlBRUu415w785NZpPXxvPROOnWh6dsLmMgzr9OxJsnWNb9LkCiLNRodz1OSK3c3V2zd9VBGELt6BLMYL/nJAXYRNmwVcKRuECW7JL76yRSvMOPIATyu4UN64wpTLiAKfzUuijSA7TuW3/RDxvGVAl6jDqClDYHB1q7luLlqs9+WfW2YXF9lUkpyaiIWHOE1LzZYdFztnzfkkhWAZc2FIsKWQaVKiJJZKt445lhH/LOSTXl/MV+C7/GEqOApY7x1ZdrOIdTepVeRolemtwtECI+vb8N5FuxUv
 DDZvPHwg
 ZJ9Glue71RQfqB0BP6r3XK3M+cr9dDUSnPOCNUqsF3QXR5TpDE0ap8PLiZPJompjfgbmlNfCYKo1feIVB3BFiEKiQHY8oVaLqqThT2cMpMxHy+wusIYfKOSBZFewC8IOn6RFqyoWc6m/O0dkPCr19+oKzG0bkk4r3ofsXIKu0UpGhR7GlGvJF6oW5sFv069YHaE4TvdKlGdvlZXlrYPVDGIkdRxZ4RyQjP2xEWnDejwcs8VMbBA5HMISqVz1rGmDk+UPtwL23DfwX2JcbQWRkcrr4Yt/oSQo9Cawz6S36Rdm8FETd2n3J/FvdYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a generic memcpy_streaming() interface for write-once copy
sites that can fall back to memcpy() when no architecture-specific
optimization is available, or when an architecture-specific backend
cannot safely handle a given transfer.

Add memcpy_streaming_drain() alongside it so callers can separate the
copy primitive from any required ordering point. On x86, use
memcpy_flushcache() and sfence only for aligned transfers that can stay
entirely on the non-temporal store path; otherwise fall back to memcpy()
so the generic API does not expose flushcache semantics on cached
head/tail fragments.

Callers are responsible for invoking memcpy_streaming_drain() before
later normal stores that must be ordered after the streaming copy.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 40 ++++++++++++++++++++++++++++++++
 include/linux/string.h           | 20 ++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..0b57e9e6f3db 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -100,6 +100,46 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+/*
+ * Only reuse memcpy_flushcache() for transfers that can stay entirely
+ * on its non-temporal store path. Fall back to memcpy() for zero-length
+ * copies and for unaligned transfers so the generic streaming API does
+ * not expose flushcache semantics on cached head/tail fragments.
+ */
+static __always_inline int memcpy_flushcache_nt_safe(const void *dst,
+						     const void *src,
+						     size_t cnt)
+{
+	unsigned long d = (unsigned long)dst;
+	unsigned long s = (unsigned long)src;
+
+	if (!cnt)
+		return 0;
+
+	if (cnt >= 8)
+		return !(d & 7) && !(s & 7) && !(cnt & 7);
+
+	return cnt == 4 && !(d & 3) && !(s & 3);
+}
+
+#define __HAVE_ARCH_MEMCPY_STREAMING 1
+static __always_inline void memcpy_streaming(void *dst, const void *src,
+					     size_t cnt)
+{
+	if (!cnt)
+		return;
+
+	if (memcpy_flushcache_nt_safe(dst, src, cnt))
+		memcpy_flushcache(dst, src, cnt);
+	else
+		memcpy(dst, src, cnt);
+}
+
+static __always_inline void memcpy_streaming_drain(void)
+{
+	asm volatile("sfence" : : : "memory");
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/string.h b/include/linux/string.h
index b850bd91b3d8..a4c2d4347f58 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -281,6 +281,26 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef __HAVE_ARCH_MEMCPY_STREAMING
+/*
+ * memcpy_streaming() is for write-once copy sites that may use
+ * non-temporal stores on some architectures. Callers must follow it
+ * with memcpy_streaming_drain() before later normal stores that need to
+ * be ordered after the streaming copy. Implementations may fall back to
+ * memcpy() when a specialized backend cannot safely handle the given
+ * transfer, and backends that use regular cached stores can make the
+ * drain a no-op.
+ */
+static inline void memcpy_streaming(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+}
+
+static inline void memcpy_streaming_drain(void)
+{
+}
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
-- 
2.20.1

