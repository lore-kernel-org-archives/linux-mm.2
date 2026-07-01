Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396DFC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 09:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF646B00AE; Wed,  1 Jul 2026 05:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28FCC6B00B0; Wed,  1 Jul 2026 05:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD406B00B1; Wed,  1 Jul 2026 05:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED2316B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 05:09:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 864B41A022A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:09:30 +0000 (UTC)
X-FDA: 84939634500.29.9B878FD
Received: from va-1-113.ptr.blmpb.com (va-1-113.ptr.blmpb.com [209.127.230.113])
	by imf05.hostedemail.com (Postfix) with ESMTP id A60F2100005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 09:09:28 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Q1K7xKup;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782896968;
	b=BOtQDv657tToRaz4GqhlUDoj0oBqlmSLWJ4kvB6VWMl6tsv5iQU6ftuBBWpJIyOjxAeido
	3er6FuuJ86sMwh4om5x/vWkM2JjBFfgS9Tz0WgpDL4I+f9ypTH7Bmx5+wumLKe0/0CXmKH
	zP4ctA1eRUVGthQvub8uoKOmn7u76Io=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782896968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EChoIRhSwBKjl45mE0KYtfQBcAG6r3vpLScAhY4aGho=;
	b=TQOJ3emXAqbEnImonKswE8d5v7VeQuMwTDdFe1MpwT/Myc2z9cpVW0Q8DvdBbpajMfLXkH
	oQGNoCOrqlNlTxaD0YftLtM3DQjt7a42NPwzyK10rcEu8nxUl1WJmEOWcK4F0FTYvVlhjE
	VHq1hUkV+CJcV8NAnITFYuOYBOfUi/0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=Q1K7xKup;
	spf=pass (imf05.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782896964; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=EChoIRhSwBKjl45mE0KYtfQBcAG6r3vpLScAhY4aGho=;
 b=Q1K7xKupQgvsLGWwTJeT4z95PsQq+f0qhQs/5RFf+q+HMObCkLcVxWwSg8m/LX3hxbvBqI
 OOqXyVvh4GkwImqh1SjFXQEnROhT5WdEVxLUo5wo+aeJOJd6GaIeXkRGWG31uxZzJFepwC
 9Z4fF/dJDnVVOGE68KhDW2M4HGU69mThyOZY8fyv8rKJ1ghPX+5TSCTfD45Yq6zw9nvwnz
 FIEWtdB2sLzqKIahJ9eBGwKCOrh66KTasj/tkp1HVhafMmxwMLvs/b5ngPrA1ZjL+nZAzi
 m0gRzPxBGVQH/RtgUd79U+DTmAeTC6pzSm1TAC+8c6dffaftVsK4XGuKB94UGw==
Date: Wed,  1 Jul 2026 17:05:51 +0800
Message-Id: <20260701090553.62691-7-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a44d942+e1807c+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
References: <20260701090553.62691-1-lizhe.67@bytedance.com>
In-Reply-To: <20260701090553.62691-1-lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>
Subject: [PATCH v5 6/8] string: introduce memcpy_nt() helpers
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Stat-Signature: 9dgp9inod9r1jxppgc3ma7w389a16i7x
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A60F2100005
X-HE-Tag: 1782896968-327268
X-HE-Meta: U2FsdGVkX1/kTp73G0zyJYCq8qKBGT/A7OcmtErRlaUjYd2LWglyntU/Uf3PARB5yqoFNp7P1SDrIQ9NbqTbpLAmkPsQkLXEcsGKu4knzuhNYh+jikPYObOsRx9/ggZAYI0U/d0ZYgt7CDfL65mPVZ47XZhKIjlpuDpnO5x8h0AhBmjigoM0lSEPOGOCYU9NijhWQoENvUS7DeJ1WllhjjtQmoAOOkuSHmy2UBLMI4HgDCFLs/DSUa06KX2IjYBnJ2W999atgYx6z/5hTlAAQ6j/BJaF7IBTbPgBMydbwdGsduGfvrfasn9gLgUEMia2OqwqlWLXVLsdOhX5SxDzPiCP7T7OsBeT+zbahUI75jqNO2ZmIJ1Q0KOjMEkjP3c1R8dCWBRr+D9hMNqEV46x1ijeNB/X1NCoBJ/cQWQWkKSCultTDEQSoyE0I9viMZKUGhYwuiT7IQ2l88KSItpADf9iTzcDaf08WRSDt5OMjNaUQGGACbSrwkuPkZVtiUdIT7qmPfjXJsMONIjQM8ToFdDW674nJNz1bS3ET+La98M7MkDnypuTgbic5OJk/oNkS0rSeSAwOeBQBfXCqhsIchNtVwJeH/kR3pLIZ1G8Bf8FcpfC8FZIMbEsJtuq95JxOTKieaRi9Sd6yJGuhSAgDw3OlaK2Z2HmdyGIzMEBvxIIUfOrRYKP4wQNnfiEN9SORx+LpR7XGy7Nv9FDEQIr3MIMs6xClrgCZE+2gWh6dklcBr78eD7LyHnPi3x5dOsild+5MZp127/mnPbG7frxgAecmigdaDzFO4aEnMEYsGCaOJ4JNj+QxJCXXn0rSz/urthQ+5z0SypUdobSb5J5xfA8V7F0FpIpU5NkpD11GZGWYuNS7+5cXFxVnLoxi5g84X3MFRi7JWJHOVFwY4bc6eo85j1MvVnJtrG0LSNx/NfFd3EylcKOB9AoGeWvdnQLRnGEF1PrNB4zvypj1ke
 GucWUkyP
 8PeWf87zoFIFcbU/+M+RpWQbRdtu0Spulel8wf5Lcs6qFg3HkcMm1BcJSFPhXCRM+b9mu7kwhZMJXic7mJsNlidlGoL2TU2vKlEdL+VhafeD+daHyz7OMpb/GvgP8xj6hEf//f+9wqqEXah+9eK1MKgQ3mT5GW0vKRGLLjEyP6MGE7idLjhg5G3VC3dDj4v9AwhfdpZt+LxHPxD6EeE7HLCZf7jNEJhIXKGhthFhdVVpGpH7g7cA8tpfccGf3BOVSfkbNTM2g9+PStCr5Zwqx+YpWRITBfv80kiUerfIsrW3DCfcYAor8WdX9Fg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce memcpy_nt() and memcpy_nt_drain() for write-once copy sites
that want a named non-temporal copy primitive plus an explicit ordering
point. On x86, place the arch-visible wrapper in
arch/x86/include/asm/string_64.h and map it to the existing
memcpy_flushcache() backend plus sfence. Architectures that do not
override the helper fall back to memcpy() and a no-op drain in
include/linux/string.h.

The immediate user is the ZONE_DEVICE template-copy path. That path
populates struct page descriptors in a write-once pattern, so most
destination cachelines are not expected to be reused immediately after
the copy. A regular cached memcpy() can therefore incur avoidable
write-allocate traffic and pollute the cache with data that has little
near-term reuse.

This interface lets callers request that non-temporal-copy semantics
directly, while x86 simply reuses the existing memcpy_flushcache()
backend instead of adding another generic memcpy-like wrapper with
extra selection policy above it.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 16 ++++++++++++++++
 include/linux/string.h           | 18 ++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 4635616863f5..6f36abedc56a 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -100,6 +100,22 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 	}
 	__memcpy_flushcache(dst, src, cnt);
 }
+
+#define __HAVE_ARCH_MEMCPY_NT 1
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
+static __always_inline void memcpy_nt_drain(void)
+{
+	asm volatile("sfence" : : : "memory");
+}
 #endif
 
 #endif /* __KERNEL__ */
diff --git a/include/linux/string.h b/include/linux/string.h
index 5702daca4326..5165763ab812 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -278,6 +278,24 @@ static inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
 }
 #endif
 
+#ifndef __HAVE_ARCH_MEMCPY_NT
+/*
+ * memcpy_nt() requests a non-temporal copy when the architecture has a
+ * suitable backend. Callers must follow it with memcpy_nt_drain()
+ * before later normal stores that need to be ordered after the copy.
+ * Architectures that do not override it fall back to memcpy() and a
+ * no-op drain.
+ */
+static inline void memcpy_nt(void *dst, const void *src, size_t cnt)
+{
+	memcpy(dst, src, cnt);
+}
+
+static inline void memcpy_nt_drain(void)
+{
+}
+#endif
+
 void *memchr_inv(const void *s, int c, size_t n);
 char *strreplace(char *str, char old, char new);
 
-- 
2.20.1

