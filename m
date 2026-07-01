Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F90C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EE066B00B1; Wed,  1 Jul 2026 05:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C5BB6B00B2; Wed,  1 Jul 2026 05:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DC856B00B4; Wed,  1 Jul 2026 05:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 277F66B00B1
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:09:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A481EC1688
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:09:53 +0000 (UTC)
X-FDA: 84939635466.26.C40DA4A
Received: from va-2-114.ptr.blmpb.com (va-2-114.ptr.blmpb.com [209.127.231.114])
	by imf27.hostedemail.com (Postfix) with ESMTP id BDBC840003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:09:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CyELo4zu;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896991;
	b=Lr+HPYwQfG7aef4pohWX3OI7aFhvvMJtUIVRcq2WAlFgLvJ98d+35j+LVuWr8EfyhS5CI+
	hZ2gtLkTQRB8S3HQoVdTf9vR4jwusGFY4j2cFzI9eCU4lwKcwcc0heHXCccEmjffJ1/1BO
	PIbhc8j4BRkILFIQLVFPyNcU23vWxmc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qr6nwqCt7/yTOu+m9nVzSsxkIglWb+obVZHYhyWIf1Y=;
	b=a4Fd4sL22Fc4VzfYNxyqIZCYhR7hObS03+GSCP0ke3WBC9jF+HJ30jqRArD3hSb5Zx+w6/
	e8aqZe0KpvRZCAXCayoY6M2feF7OLCMxKHhd9Xo5DLUKA6xzgbO/YdHCf/T0vK5lSR9IX/
	zUPz0NWWhPb9OaqzSYZWn8U5E6Ncsho=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=CyELo4zu;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896987; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=Qr6nwqCt7/yTOu+m9nVzSsxkIglWb+obVZHYhyWIf1Y=;
 b=CyELo4zux+0yoAuXHXovojmzaBzNWwwK7W763PJqdQwYlgEFoDN5oY3puIEyZt4ZglB00z
 ruVy2UDJVfIqfU5X32L5uOG+8GHF77JXAN+aKnUgLXfNbOCQf9jqjUIz7KqpLLbW/2ajkF
 xOU/oUswAHWFmjD3b993XoVuc2AyV6d3De+Qvikf/6mevkJVUtjo/Z6mYzJzAfAfscBTl0
 T6ZemKWY32fltNTKsUZe1p1Rx0fg6YmvdNMchZvjZpcmE465nbRfl/kuk7yPe2jhNBegoY
 xbqn73xTXCXgcYUAO2NFVCIKLDCUIsq2TxYHp/SsINhrQnmghI2E2p1V/WNQ4A==
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v5 7/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
Date: Wed,  1 Jul 2026 17:05:52 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260701090553.62691-8-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a44d959+7a3f41+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
X-Rspamd-Queue-Id: BDBC840003
X-Stat-Signature: zot11bk7kfqw1f387tw878wp7xpczoze
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782896991-290470
X-HE-Meta: U2FsdGVkX1/XqcsDI2F4uRcjBxB7j3OHz53vtlNWCnUIb21guzDgrSqZvjIowe9xOnRGpxip1Do8ziJtrYAFt7vo4LwUckRnYEDMxVEcU3ofgFZnAAOf4uftGDVKx6L4ajspA9iimNmSMpWfJZ8mnKcxmv08awwcJSjxTXizj1fjpja6U1Elvae5gv0b3uW6CBD6YPkw17hCsN/Tzs9tI3T5L/VMBGdtawmbzuGzzkSN4I2B1neHLNcrKldFw8xNfv4WFdGhMU4OVa8bEKDf36kpVW18TZS3vudUiGqcSJAhK5r8wabfR1mBZS/nXCGRZalh1VM4hX8jDXHJsr0NbV8k6+xQ61IpbmnZ2qZIGYCi/npOMuqAKkxuL9qKzi/FNFnxkB5+eTt9RJ+rg2TnsNJL6xtK6SkE8Cf+tbOBgm6XwEAQT1VXCBN6VLNHCkABen+ej2pC1Is9fLM/obla/Rt7J0zyi4zA+juXF1whR2Fg7k0MimI8dBJVl1j+hbcFzrY+3qaPkD0nqqbDIRllgEmAXin9sv6kAckx3Cp0uYmP4PqTe3ENfVrgW2cm6WM3ohQpnv+Rf1OOxD6QRBeqzizqXsiZU/mK+GXABZB/dZ9TxgNA2oR81unMNjAIfEV9g67GX5AO6VCcWrfhWL/wU9jgmsnwQpn5D/+GCcwEPXkGMYpY/5xnrpSduRMRWrrNvEBAXlMEM9UvSa7XJyUbpCOcbgtIBjpHvQvXM/kkerFSMAzvjqAJ8qVJTvndWKFcUhPhe/MyVn6T9sYBa4KpLeLXU4MG0c3VpKzSYVBZWuZg8ZEDBWU3oMYXwgdTUJG6ffNcOSoBglwrkdeFDnYMm0dPsM+USVEDRZ7IMClA9Tl3n4zlXcumAkfOETS3bWgmhTfzRhy6lKotYWDjXP3pR79Eu8/8llxHc8RSYq1VYHu5LQPT5fXK3Lcnf52ifibvJr3d0VTQYXpCXrUw+dE
 8Yo/eLl8
 AzDsDhyTUgDrrpz96EmfPfTk3KxvPqWHUJRldRiyC9DzvUMQPWJXKwdneaX9DWSvqYTR/prmapC6CL3OSYoE4HgMP2KSOenyrhUe1SzfXq+AGoIXY98354hkClghBoMOSds5b+iDrrdvF3bUuG0QsBVaecaETTqajlQC2eo/L209jupWzjuTMN/ZvcUFSklmXI8I5GITrxaniSwYKCTk89BfMBk/SNRLGMIJZ851NPwvJG8+YQvO8J1ZmlKkm3Gv/MzyMNkGTbZpuZRoOgwKTor2hLozmkZux4yBRTiN00Jd30TrNZ/oJv/ZemA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new x86 memcpy_nt() helper in this series maps to
memcpy_flushcache(), and the ZONE_DEVICE fast path uses that primitive
for constant-sized struct page template copies.

memcpy_flushcache() currently inlines only the 4, 8, and 16-byte
cases. Larger constant-sized copies fall back to __memcpy_flushcache()
even when the destination is naturally aligned. Extend the inline
movnti coverage to 32, 48, 64, 80, and 96 bytes so the struct
page-sized copies used by that path can stay on the inline
non-temporal store path instead of dropping into the out-of-line
helper.

Factor the store sequences into 8/16/32/64-byte helpers, keep the
existing 4/8/16-byte cases handled directly in memcpy_flushcache(),
issue the stores in ascending address order, and leave all other sizes
on __memcpy_flushcache().

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 80 +++++++++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 6f36abedc56a..95ef2d481418 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -4,6 +4,7 @@
 
 #ifdef __KERNEL__
 #include <linux/jump_label.h>
+#include <linux/align.h>
 
 /* Written 2002 by Andi Kleen */
 
@@ -82,8 +83,81 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
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
 {
+	memcpy_flushcache_32(dst, src);
+	memcpy_flushcache_32(dst + 32, src + 32);
+}
+
+/*
+ * Keep the additional aligned fixed-size cases on the inline movnti path.
+ * Leave the existing 4/8/16-byte cases handled directly in
+ * memcpy_flushcache() so their code generation stays unchanged.
+ */
+static __always_inline int memcpy_flushcache_large(void *dst,
+						   const void *src,
+						   size_t cnt)
+{
+	char *dptr = dst;
+	const char *sptr = src;
+
+	if (!IS_ALIGNED((unsigned long)dst, 8))
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
 	if (__builtin_constant_p(cnt)) {
 		switch (cnt) {
 			case 4:
@@ -97,7 +171,11 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
 				return;
 		}
+
+		if (memcpy_flushcache_large(dst, src, cnt))
+			return;
 	}
+
 	__memcpy_flushcache(dst, src, cnt);
 }
 
-- 
2.20.1

