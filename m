Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE68CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 04:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2EE36B00B2; Thu, 21 May 2026 00:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8B76B00B3; Thu, 21 May 2026 00:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCEB76B00B4; Thu, 21 May 2026 00:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD1D76B00B2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 00:04:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6898F4035F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:32 +0000 (UTC)
X-FDA: 84790085184.13.6C06B5F
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5B441C0006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 04:04:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EA4VpO6r;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779336270; a=rsa-sha256;
	cv=none;
	b=2EmZTnxyvoqgUSEwyYCjZ4izBPWsYx8/l5P6zBis5ceLNF/wPe7PD6f+RO4HqKkirLb8/1
	7jZi4+yyLMeXI4dnAtumaA5Zk7yd3Ozsw/ZMSlDe3X+WUIN6L2KBjp4D4uqCl4Q88GwoFU
	hn3n36w98D7JuivZqYw1AWnJDWvAtwY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EA4VpO6r;
	spf=pass (imf21.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779336270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9TVpMbLVKEQZRuZT9zKl5Z3AjyKm+f5ptKPy8P2UEQ=;
	b=5/YJ2BphIaWDFkf5tVx5N2JWRxKTDczKRi8D33YL707BcPatQJ9xqq3MXRljeB7oFw8vCo
	vehv+m9i33ERQQTEnyRcLJWhVwobUZLfxLJw8BTTcqm1hlalSWZat4VPoyUt21Vn+75nCh
	2YxmJi02O5E0Ke1ucL/YH4HXuR89M3g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779336266; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=r9TVpMbLVKEQZRuZT9zKl5Z3AjyKm+f5ptKPy8P2UEQ=;
 b=EA4VpO6ra8HpDmB1WeSCujlUe50Ak9dOdMDG7jb8NQvtDGoNMzLP45SkTgr4nE9UMNWIv4
 ddNKS2KrGi3t6ejQAr/YT346Y8HNUKwJjn1G6xQdwKaoIp5l3vukfZyo5YXTwSoQgKTUfh
 SRRur+i8ySagziSCUlKdbD4P3TMsDkGrpokbhq3zZIUm6IRapXjZalCtjmHvyn40069Eyi
 FlUeQpSrvUzmfNwvJq4Xq2my4rcq1CIZOeGFXmuwiiPSsrK+BD/VnOxsWiaQzyS6kqFlpn
 8Ifc3Sx+lDTAfyiNoG1LI2XHVp1mMX0qGM1KGBoIrTWJaMUnkp7cVk0wdPT5rQ==
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Cc: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <lizhe.67@bytedance.com>, <x86@kernel.org>, 
	<linux-hardening@vger.kernel.org>
Date: Thu, 21 May 2026 12:01:22 +0800
To: <apopple@nvidia.com>, <akpm@linux-foundation.org>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<mingo@redhat.com>, <rppt@kernel.org>, <tglx@kernel.org>, 
	<kees@kernel.org>
Subject: [PATCH v2 5/7] string: introduce memcpy_streaming() helpers
Message-Id: <20260521040124.10608-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a0e8448+5c1ad7+kvack.org+lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C5B441C0006
X-Rspamd-Server: rspam03
X-Stat-Signature: nmd4ft1km5sc1ifrhqz4c1h6k8sq9mg6
X-HE-Tag: 1779336270-210930
X-HE-Meta: U2FsdGVkX19B6bLKEiuT6g6glNNUsEG+uYe7aXo04h7PhAoM/ajjVkLX6SNJtm86x6RjK1FNeblnoyJmpsUEtAzSIuiWTjiufSbC2lxvqR1GJlipX3N4bKEePMeuZ8DT0UhzYgu9wNy2joirlD+Q4IK8caqb6PawYfcbPxX/8y3HOwLhRoIQpugaHQASD30/d3jHUzUvbGVHKwx5CJHfcsrCy6iyJNomGrYZ5z1NFUbuq3BPxw8fwFHMRSM2YZLQjUgxt+BwB0O+qnnwYw53H+omHWItoy0h7Uj9qcV+fYFt2ocwNksLIU62RBmzceL33D1QDmgoW8w37uD8mynlybkrTMdrp9AlutVamQHz3ut29PLLbiGctNkslYRtZImZTpVdNYcdfKHO5M2nVegXuioXG9fUf69WyiglMTX7qwRubROrUGeJ0R4RY2bH2VWJxG+SpoGvHNp81NNgHUYdJEbHIE5zmG+uekiMxjQtPk40Gwi/NtmF7JJKUNv6QQp2ObJyQN0xPxF0y5Smv1pL5TnZp3HUb3tHeW0TNnsKP1BX+y3HkquvcCHDpSY427kFZ3qq6Z7xnh/7uXM1OF3CNmYovrCkTbL4WSBMfau/PpGUzmRIA+eNJRp3iiTt4o2YHIaMHj5JkJl9yGMVgB+YE8AoJAHDmOzSR1EZ+zZrcinKwxhHpGS386+QdwU9H64OZ8ibV2ERpCAoNG4wG7vXVSX9CP4GzGhiUPL6ksFwDAxnhbZCePP6qgFUG9m8L1fnhXI0l1/ryfCSbIW4ziPMGr+jTUoi6ik9ELrXWWKaZL/9wXCnltLivWN+1UIy3Raps0KfB+wDqtpXadtwiMfn2lH4H6Ed8tQACvJaXxjkHQ1v+9dFMLKUdl2r3T8FYeY563lxRoWu+Y2tiV84PaIJBrJHr5C0XkYnv+XjWDgL05z2kgmt54CiLwjVgU4GtEqhmE78PCeXeWLBp5IDdl1
 3GUCs1TX
 H3MwJLjsV/cKOKmJq/mtJDnUhFXYZsxsCdVIj/eZYOOqitWUPOZXETopXA7bvVEZpXsgu4Cje1g3cmA0blUseyb02+yz27lAsHWj8sowzT/GyJmMgZOrsonqTTzspJgBI8CT1fBsIgOE+LaDtRCfApJAdDOaPGV6lAU8nksTXOUWVdN6g/a+hJCphQddPucCr7KDbN35GW6DKVofzRRL4YbkR/vOMcoS1eov2uusAbL4tM90wn8Lue2/eQqjL+Qo6DLggUucSKvnVyC1gUudD33qIO+gMUusjSJAgf4NqKj1C950sBomOyWMgAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a generic memcpy_streaming() interface for write-once copy
sites that can fall back to memcpy() when no architecture-specific
optimization is available.

Add memcpy_streaming_drain() alongside it so callers can separate the
copy primitive from any required ordering point. On x86, wire the helper
to memcpy_flushcache() and sfence so common code can request a streaming
copy without embedding x86-specific movnti details.

Callers are responsible for invoking memcpy_streaming_drain() before
later normal stores that must be ordered after the streaming copy.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 13 +++++++++++++
 include/linux/string.h           | 18 ++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..15504b844f1e 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -100,6 +100,19 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define __HAVE_ARCH_MEMCPY_STREAMING 1
+static __always_inline void memcpy_streaming(void *dst, const void *src,
+					     size_t cnt)
+{
+	memcpy_flushcache(dst, src, cnt);
+}
+
+static __always_inline void memcpy_streaming_drain(void)
+{
+	asm volatile("sfence" : : : "memory");
+}
+
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/string.h b/include/linux/string.h
index b850bd91b3d8..ba029be9c187 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -281,6 +281,24 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef __HAVE_ARCH_MEMCPY_STREAMING
+/*
+ * memcpy_streaming() is for write-once copy sites that may use
+ * non-temporal stores on some architectures. Callers must follow it
+ * with memcpy_streaming_drain() before later normal stores that need to
+ * be ordered after the streaming copy. Implementations that use regular
+ * cached stores can make the drain a no-op.
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

