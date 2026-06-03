Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF204CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 08:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5246A6B0093; Wed,  3 Jun 2026 04:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D5296B0095; Wed,  3 Jun 2026 04:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4806B0099; Wed,  3 Jun 2026 04:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2A61E6B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 04:07:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DFEEC1201F6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:07:09 +0000 (UTC)
X-FDA: 84837870978.15.F9E11F6
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	by imf30.hostedemail.com (Postfix) with ESMTP id C3EC780014
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 08:07:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=U4dMfXKX;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780474028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QbTAW4+JtusN/1ajk2i57VFeY4ZMdb/3rGS57KirNj4=;
	b=Oz+slKWd+I+WNNEtYAuu9iBa7y1cvGarJ1THipHamn82DcE7xYGEmH2Q5VlgxI7R2PYBl7
	FT/Hoi1u4rFj28jok8s8IfbqDayiC7taAHwLlLdsYdzsBg0Q76p0OQ/oO00MkiuzFqAJw/
	M0IxeY75j/hv1tccXQQDOGC5c7nAmz4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780474028;
	b=1CrMkdzgG6RxPa69tmohNUGXpobKFXZsXD940DaNHInwH5jqzj8433rHvPXgbh4WEVnleU
	ESujbukJrgb8mS+5/3WE5XDiOTWIfAD/8FuJ2wcYlbJ6MFK6zP1xS6qXNEtWud7u3gxjfj
	h1ZZ1kpsAYehbZS7JUghCsJIGY4C25Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=U4dMfXKX;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1780474023; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=QbTAW4+JtusN/1ajk2i57VFeY4ZMdb/3rGS57KirNj4=;
 b=U4dMfXKXNBR99SZJTA3fZeC7T+ReleTpxNpkP5iVjZwBtp1OeC6g2aTZGuDRc+eJwpED+i
 NY6uRJ1TGh20Ek4WJOxe1ZtTdNydHqNmQ7+CcoK3Eq3zLcc4rD8MoKZoIfeF79HUymeyev
 UQ/4IXBCLuG8l0mcM5JLX8xABZaAKFw3ZZRdrbZCGjHx0xiAmiGAeMrMdvFFYu19TVH+RS
 xxacHLnKPIRxM6D+0iuqSgRAqq5/ccz1Twu+4Q/m95WqO4bV+DHwiLb/G63thl5jc+0J+4
 nJkB4DiJ8wR07xqGb1Zl1lIiOrD4UoHnqIeFHvnxcqo+/gMATzvX4xToDNsBuA==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Date: Wed,  3 Jun 2026 16:01:50 +0800
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
References: <20260603080152.64728-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a1fe0a5+a1ada7+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Subject: [PATCH v4 6/8] string: introduce memcpy_streaming() helpers
Message-Id: <20260603080152.64728-7-lizhe.67@bytedance.com>
In-Reply-To: <20260603080152.64728-1-lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Queue-Id: C3EC780014
X-Rspam-User: 
X-Stat-Signature: ib6cjenq14gg5sddybday46gcu8ym5c7
X-Rspamd-Server: rspam08
X-HE-Tag: 1780474027-767494
X-HE-Meta: U2FsdGVkX1+iATjtHza6IAJIzya/kvSBFpjJZwnN7l4cJPTpQzbrN3biT8fZRtMrDQOd+HUHdQn6V/Dy1Elud6WJIXmA4KKPUXcPyr0317gnZrg0LKMHmuftieIjdEJ5tsAfDwNLkfPs6IXYsYBsZYB70Rp3zsog0iUTPCBHbMs51m94Cle3zEQjJ6DlvhmSWHUtEwyFAW3CXvkiJJ7FSpWl+MQYwPUwSIj9EmZT+MMZ6hJQMT6LmlF8nWLaTC1Srv9s7koi5M5pu6OiSxaQOfKpS+jACj3xukA4tH1yrmRJbLgEm4eKq2crQ7L/4fh+BXa/1oYZybNmpSCvPkXKTKWupBXG9qm7NuTyvXkGaRYHrqQ+kvW/MZJNtg9UtSBBu8++TQhEFVNAAPa1r9g+2KVbzhO0E91/Q/nFfDBPgSBGQ/9Re4/3Jqy8fjMKGirA/MpuF71vF9FIR1z1xHU7YFJqX0cSLCajQ8cZx4ah6VE6MAfg39YKmaql8BmPY4NZDC7MM1PjX2L1IFYgK+MgKbAT9Tl+QgGM6ZytpTBsL3QGLER8LOR/+4mIpspPc4l+0OxK0ya/TAjPuDnl3jcLDY2pjYDfLtqbkyjrDf2xHBRl+JlV03oysiWo4E32eG/RwaAxsCun3O3YEepb9JmiORE5lZElNR3xafrxSTMwkEwZGp9T+yui+sZTtlYbg18sWxRJMBc+DDbJlhU3frmu6zqAzOIBj8UYmHWJdOfjiz2qrIayl7Ns1BqSu6+b8ZVHeCcFm3rJjJJb3abMbIVbZgDv7qHmLBMym6DpYmPBSY5ai3V1XYvWRrVo/JStgUJp6us19rKtjujxJSdG0bxBYHptQ1Fj3F+KZgnDypYrkRDDuy8LjGRRRX5r1fjjaw0sU1RgRUfiYqJHeaTL28V0U15MPyc9dzHJIvpn77yUSYFX22mv0SSSC5U7NBnO+oacScs6yneNvLBaihyKB2z
 awPA9qxx
 1SuRrtj5hI7TQrjgt1BZI0yl73wQXZzt2Dybs6YG/bRBK645YosAV0u30eG5zEZjhldGvOh4cYvJBZYFpF68XBtFmnP1xQ8K0KNNo3LxKVrREMR7pcwsS6vb2N7kAY8Nph1qfFkJHPuahLSqJ6w8e7ipWUupDUoMkb5j8LwOB5+kp042DO03ag+wkmFbQo9UZeNND8//HsxdoNnIAlcY60LfUQ7w6PEn9uBGw8kVl0hKSAfuwEAGxvRqaeRz2PVZ868PvTEDWxKMFSyj+WeaVUPrODPfkS+d94VvOzHUid5bnaRl+BVZtSYrqRQ==
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
 arch/x86/include/asm/string_64.h | 32 ++++++++++++++++++++++++++++++++
 include/linux/string.h           | 20 ++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..aee63108577f 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -4,6 +4,7 @@
 
 #ifdef __KERNEL__
 #include <linux/jump_label.h>
+#include <linux/align.h>
 
 /* Written 2002 by Andi Kleen */
 
@@ -100,6 +101,37 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+/*
+ * Only map memcpy_streaming() to memcpy_flushcache() when the destination
+ * is already 8-byte aligned and the size can be handled without cached
+ * head/tail fragments in __memcpy_flushcache().
+ */
+static __always_inline bool memcpy_flushcache_nt_safe(const void *dst,
+						      size_t cnt)
+{
+	unsigned long d = (unsigned long)dst;
+
+	return cnt && IS_ALIGNED(d, 8) && IS_ALIGNED(cnt, 4);
+}
+
+#define __HAVE_ARCH_MEMCPY_STREAMING 1
+static __always_inline void memcpy_streaming(void *dst, const void *src,
+					     size_t cnt)
+{
+	if (!cnt)
+		return;
+
+	if (memcpy_flushcache_nt_safe(dst, cnt))
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

