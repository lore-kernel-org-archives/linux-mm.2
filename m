Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBFC3C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 11:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016826B009B; Thu,  9 Jul 2026 07:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2F626B009D; Thu,  9 Jul 2026 07:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6F0D6B009E; Thu,  9 Jul 2026 07:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C03776B009B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:28:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51C02166FC5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:12 +0000 (UTC)
X-FDA: 84969014424.03.123DF9A
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf26.hostedemail.com (Postfix) with ESMTP id 654CD140009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 11:28:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ELW3/md9";
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783596490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtpXPQ/H4ZBimfcBe1xu9rcXWfMUV2ijOuTMHAq22Iw=;
	b=fISIzllHFCQReR8VV2aLorieLOGwxBLgllE3q4UehB8SqLrHjNn7YSxyikJRwcnLBfyFKn
	sO+snixZhOSmwzbDvdKT7YnTbehQimrzXEGkOGxpxmFjQmlCLzTOwX60tZ0i/G4PKSgLCH
	DZq6eDXUsvkiZLVMp6/VySoRgG+dNcs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="ELW3/md9";
	spf=pass (imf26.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783596490;
	b=pvonz1k9qGLRo+Ok8GEMQw/vyVnNZd4FE0M3/jSHAsyxQw6VndNUaK7HsNJJlaiiOHwYJW
	aAZJXacL82O467y28/gtkCpZ1YKP5shEUlo8AiIlT9Pl/M5z1o8vX+bDWsFnpgVDVpHEw4
	RXYgHONQcmt7GG/wYBSdOLK03TdpLTg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783596485; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=gtpXPQ/H4ZBimfcBe1xu9rcXWfMUV2ijOuTMHAq22Iw=;
 b=ELW3/md9IJpgFdhsKU8JS+ciQKPN6fAoW0iwiX0zhksg+SyIgwN3pkanfW/P7hXgXluMHi
 iMIBrgRa6sPPLLmgH0XyrSIf8bv1/tH/lcQEOAOZaaDzT0s54p388hF7IBqvu2cldP8ww8
 Oc4g/hbliSy4VUgVpNLH32so6VOGHKM3z1IfQmvVcjEy/+fnDfggu6hHkngPUoP1BHvCd/
 rXSmpVIn3nTGwjWpqNuc2TXnaMLz2g85mcukNeBZp5VRzgcmeQYJhFzZ0tsFiHvgr5kzf6
 zmxMxuPhkgDzXRc6oAeQX8VwBRCaLEOFLJHpcOiYhkiE0SdmSMZ5nLx/ECgQaA==
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Date: Thu,  9 Jul 2026 19:25:18 +0800
In-Reply-To: <20260709112520.24857-1-lizhe.67@bytedance.com>
References: <20260709112520.24857-1-lizhe.67@bytedance.com>
Subject: [PATCH v6 6/8] string: introduce memcpy_nt() helpers
Message-Id: <20260709112520.24857-7-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a4f85c3+ae44bf+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<lizhe.67@bytedance.com>, <x86@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Stat-Signature: ffu9bfchbyq54bc3azkeq4s63oeek76z
X-Rspamd-Queue-Id: 654CD140009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783596490-692052
X-HE-Meta: U2FsdGVkX18y5A12/9n3Yz2+AmsOBM/7BkjHQu3mtrSrKojnfGV7VYH8lD4fJv4m2Zr/XAlOU4I3JRuXyGiDOi6DJw1WluMIAq5kSKJWfs6xpQobqLTGn3zEQtv00HcWvNcknnZGH4bz75p2OxcoQlVz0oeRW/6hfkqKYM268zrRfXXkIfqTjThgJHf82zarCQdl1FB5YzkGlzE8UEEWwdat3GL5c/ii72umpGnMLn7ylRyoRDlxI+mzkkgszMUFMroryGE6FA5xs+lTUsOlQXJ7TNUIUNGSxzH0c+Qa7z1ojNQT6vjcslJgoWUJ+Tf0wdoSYg6Uhw9tmYyyj9SDkvjThedTiJ/mmB5PKfk0JiklsSI1UB3GpHqXYrlJQACAH6zYTFLYrf8SyPeQe0SyPNZHvSOu1vNI+xezKXiOryUjyXl+tiq/2GzeXmAUKmAw4m0hRPwFhFUiRKlsHS547zKLWLu1XxbJH544ADdO2DOlX6cKY1lUvxKpzgXjCzi+AifP4wNo2n5z1XUy41PpLyh3hVy1V/+Uu1fReghk/W7XLOO5Ut+zIImAwOKJvVDW8DzeQMaeFJV3Ys4qBk1U+A6VpnvQTlYhQgCM8gUOWL+W4BQFvbZItl2ynLS6g6eC3f8ZqloSMX1qGygOUUeoAawhFjOdLTL8hnQfxbSsmDK5XX8fLwymVGs90Dt/QYLLToiJ1yCGi2FttEmZ2JU/R7SMwCaO2NRhadQzAVZADnUNP2X7j2DK7TU4wW80vHRy6fcB5Arbzpov8e/aavhcTin/QCT36QKlQVvi5AjpBcBAAl6fHJNMCi/Ucf8h4EdCkEDaXshCgbw5Wo7NEuNG/rDlPSNdngrtBkruZ9ti3XgFSsmtfcVjvuOXRCQUx0SDgO2eGiriqPabiP7SwNnLXE8eqDjcCCm0jG7hlN7PMJzDURqVZnZmlRPqGf0070JbZs1H0gPrvUZybVTnaSq
 uTHBI+85
 wPlfskKPTF/I2DpuQEPnpyXjBkmUQFhmHKjVuO8aTRM+Yd316VrYNBxoj8ou5RwomPyzDO9FWYwCpPgduVKCJjvTUEPKhoQdAnBu+cuh5nBv1GVylg2yUWiDp0EqSDxYvOS6brmYLaN2VCccheCrQQ3BfLFfy3oFMNpAWsMB31lQswD9+BqjwzUV8J3kfV+OVRj6btPLrgXFc1rezwUVREPJVi/iB6iI1HsNedy3ufgPX+Ym4aaO8MwieHjwMe7JZsPKvHKKwQjoSYVCmnL72oLXFcK9uYQtjYqO5Ibjye21hubwiLcekLDri+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce memcpy_nt() and memcpy_nt_drain() for write-once copy sites
that want a named non-temporal copy primitive plus an explicit drain
step.

On x86_64, override both helpers in arch/x86/include/asm/string_64.h
using the usual self-macro pattern, next to the existing
memcpy_flushcache() backend that memcpy_nt() wraps. The x86_64
implementation maps memcpy_nt() to memcpy_flushcache() and uses wmb()
for memcpy_nt_drain(), because that backend issues MOVNTI stores and
callers need an ordering point before later normal stores that depend
on those writes becoming visible.

include/linux/string.h provides the generic fallback under
memcpy_nt() as plain memcpy() and leaves memcpy_nt_drain() empty, so
architectures that do not override memcpy_nt() do not pay an
unconditional barrier. Architectures that later grow a specialized
memcpy_nt() backend can override memcpy_nt_drain() with whatever
drain primitive their memory-ordering rules require.

The immediate user is the ZONE_DEVICE template-copy path. It populates
struct page descriptors in a write-once pattern, so a regular cached
memcpy() can incur avoidable write-allocate traffic and cache
pollution for data with little near-term reuse.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 22 ++++++++++++++++++++++
 include/linux/string.h           | 23 +++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..6cb9e0ac7fa0 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -4,6 +4,7 @@
 
 #ifdef __KERNEL__
 #include <linux/jump_label.h>
+#include <asm/barrier.h>
 
 /* Written 2002 by Andi Kleen */
 
@@ -100,6 +101,27 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define memcpy_nt memcpy_nt
+/*
+ * Reuse the existing x86 flushcache backend as the nt copy primitive.
+ * Callers pair it with memcpy_nt_drain() when later stores must be
+ * ordered after the copy.
+ */
+static __always_inline void memcpy_nt(void *dst, const void *src, size_t cnt)
+{
+	memcpy_flushcache(dst, src, cnt);
+}
+
+#define memcpy_nt_drain memcpy_nt_drain
+static __always_inline void memcpy_nt_drain(void)
+{
+	/*
+	 * Order the prior MOVNTI stores issued by memcpy_flushcache()
+	 * before later normal stores.
+	 */
+	wmb();
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/string.h b/include/linux/string.h
index 5702daca4326..a109b2f86ca6 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -278,6 +278,29 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef memcpy_nt
+/*
+ * memcpy_nt() requests a non-temporal copy when the architecture has a
+ * suitable backend. Architectures that do not override it fall back to
+ * memcpy().
+ */
+static inline void memcpy_nt(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+}
+#endif
+
+#ifndef memcpy_nt_drain
+/*
+ * Callers use memcpy_nt_drain() before later normal stores that need to
+ * be ordered after memcpy_nt(). Architectures without a specialized
+ * backend can leave it empty.
+ */
+static inline void memcpy_nt_drain(void)
+{
+}
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
-- 
2.20.1

