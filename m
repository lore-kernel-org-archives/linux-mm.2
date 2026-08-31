Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D8F8C61DE2
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:20:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963CF6B00A1; Mon, 31 Aug 2026 07:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EDE56B00A2; Mon, 31 Aug 2026 07:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCD46B00A3; Mon, 31 Aug 2026 07:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 581936B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:20:32 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D61CFC0432
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:31 +0000 (UTC)
X-FDA: 85161321462.10.E96AE84
Received: from va-2-112.ptr.blmpb.com (va-2-112.ptr.blmpb.com [209.127.231.112])
	by imf03.hostedemail.com (Postfix) with ESMTP id D63F120002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:20:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qWbZE25+;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W3mTk0uO3fJ8loj8Vy9eCiD36YUSNCrm55bF0bJb8Z0=;
	b=oymimjCpbPiX3R1Gl2OQwKshdKiFl9em5lMVn0OGH/OixekwYXNBUaCaoGIC+wRpb2+S/R
	gV+vyJKcyjNMU+yvrZYa4Lf61Pv3VErQVhIok17CKE/giXSyShEjMQcWKtDR7o3c5HnE0/
	ZgK1G98fyqH2ZcBqI2YULsC28sMNWT0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175230;
	b=QbNyu8+lYb6I/GSZK3Sl6cp+WHwTd7NbZY94U8k16KWiKboxEsTugkM//aywIVgafCRF5r
	Y6z5deIKSx9HZw1vd8InWe9RXGkNVQ+YGHDP3EVFA2n/B7KSnbrFrNFh9/6sNUFaf215Kx
	wMoMquPfyIxxUEnC4VQhE7tFLxV2PA0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=qWbZE25+;
	spf=pass (imf03.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.112 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175224; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=W3mTk0uO3fJ8loj8Vy9eCiD36YUSNCrm55bF0bJb8Z0=;
 b=qWbZE25+Fl/NO3nw9RCvnXO4dihmAdjyq8obIx9OzGhqChQoZCJxhpFItIo7yZKOHm8Dqp
 hn5MsrQa6e1Dn1qbScw3plQ6afOWl3995LkplFaD32gJ7kaBZP3vXXaiw3dlOaoRboNJot
 zzZxOH9zgKiUO5RU86qHZ/d0jaA/FyR3j1FiEfl/9qcZ7u9F3tmuCmTpttEONG6ftWx2y1
 /MjVpCSQg5dKcXUTuyIkDuf/vHItBM08K5AofmSqCAD3M+T9ZLIKUu1GJogzSztN3H/aMZ
 UnehlEqzfbyOLbimAK44vg9maKpRQXiJbhTLCLVG/srG/BloRX725Ad9XXfyxw==
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Subject: [PATCH v11 7/7] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Date: Mon, 31 Aug 2026 19:16:38 +0800
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a956377+09a041+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Message-Id: <20260831111638.76012-8-lizhe.67@bytedance.com>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D63F120002
X-Stat-Signature: tp1ruanakpffbqgzw16bmjc4wwat58e3
X-HE-Tag: 1788175229-488026
X-HE-Meta: U2FsdGVkX190yxuvjBvgBSwiYizZF/etptaAB9grvTeYRuNOq1COCsFXHPq5p6Znitn0gkKEyGaAT/uS+5okkUKwy0ipLmCGJ9RLT6pWml5pp0Hgjd1CXJ5inRCRqB4OL1/FdXx1cNgr5n+zYFRoKmWAlTpCnvF8KwkjcGoXUovvh4K+bJNWT0EPrwK1mKd2nQj/QCd0S7yoT4tXrrl9oRXfPXCowaqeCIACBiHlJ/mT2ZTyMRRM0KeM6cYQnqn6XyLYirxTv0YNzKuy6mmME/xC7nhoeoxgVSXrc1HCU9IQ+ZCHUrZrcX6nB1ZuyJe30M6pyrOLRniaP8N+jYVVSqPG+GPHTfL4FbEKYTr83iWAGf2XnSSVyfaXu2SQUmEeB8PouedvJkJlfla83deHmW/ZsGcz5QKLLyCEkgBRHb0CwZtYzoAEUpgDeY4EiqUx5pG6GBDVgiL4kp2GCfL/lBFVlqWeCoqnFU4o0cmpe3i9HMkpFalveUKGkEANfyYOGDOB+r1Ir0eFEzCfNm8sxNJ1/dSk6RGydd405dUIdWlSSu6l4cLOLaBbGSro8lLRg1mb90ZqdT4evHzWBeVgHLxqHK+vuEI2B/KtzrDnGIkVtu/ibsvlPxxoZJnflvr9zUSlumtlncLaHisXYi5MmEYvx2t/i1VeEhNM+kipcMbeOSTpIeIWaeqEKBgcqSiCFwlpDPRFCChqR2Mpln8poplKjsiVDpUhDw++BJB2m2eWPe8nSHeAxWPbJmxYhjznCED3ajGaU7WcdSMKj8UeQTBDyLhW81aJQ4js3mEwdJt2IP8XvKEKnmu9qwDBjks2e++lvO0vX+8+X5Nikq66CIS3FK0p/89nS7oA3g3wdR2D5cmVFQvsYjeAlLaJcgsvvbQdNzWpGrKNaSMcRa0ORLyXyYo+5eIMWNkM/YZxqMNjb4U8iAmu7DJVmvLHqnrKL3fhy2zfB9jF9HHkzEc
 s668ZnMz
 8O/lQT+khMZkyMpCZCLBKxoT8zIK7EdgIZL6cE0Xjvp9wtmPM1AGfnIKfwB/wuF30EAJfW1em7ebI2AKptWT/HJO2eOy3q8X0kDnYMYsFrb3AjvFj6YoaobaLtwDJv4dxRkccXTzlcY3bpbXkHy3lN3PCY/LHHld1YKJVBCLCEnVhMueRwExqsXuHzQnbMWAQ2xehxFlzVLJ+O7K8zoIMgEF8HdHZk2Vg9sf5SffIJlDJcoYUdwd6wdcMN4Pl/sG4gx36h5n4r+2X54sgS0x2j5X4gr32qy6uuIli0V+SRfYfhvl9Bpz52o/Cdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The x86 memcpy_nontemporal() helper maps to memcpy_flushcache(), and the
ZONE_DEVICE template-copy path uses it to copy one struct page at a
time.

The relevant copy size is sizeof(struct page). On x86_64, the base struct
page layout is 64 bytes. Adding either the KMSAN metadata pointers or an
out-of-flags last_cpupid field can make it 80 bytes after alignment, and
enabling both can make it 96 bytes.

memcpy_flushcache() currently only has inline fixed-size cases for 4, 8,
and 16 bytes. As a result, these constant-sized struct page copies fall
through to __memcpy_flushcache() even though the compiler knows the copy
size at the call site.

Add fixed-size MOVNTI cases up to 96 bytes so the ZONE_DEVICE
template-copy path can keep these struct page copies in the inline
memcpy_flushcache() path.

This matters for ZONE_DEVICE memmap initialization because the copy
happens once per initialized struct page. For a 100 GB fsdax namespace
with map=dev, this is about 25 million struct page copies during nd_pmem
binding or rebinding.

Tested in a VM with a 100 GB fsdax namespace device configured with
map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
server.

Test procedure:
Rebind the nd_pmem and dax_pmem drivers 30 times and collect the memmap
initialization time from the pr_debug() output of
memmap_init_zone_device().

With memcpy_nontemporal() used by the ZONE_DEVICE template-copy path:
  Average of rebinds for nd_pmem driver: 150.40 ms
  Average of rebinds for dax_pmem driver: 161.83 ms

With this x86 fixed-size fastpath patch applied:
  Average of rebinds for nd_pmem driver: 71.93 ms
  Average of rebinds for dax_pmem driver: 87.37 ms

This further reduces the average memmap initialization time measured
during rebind by about 52.2% for nd_pmem and 46.0% for dax_pmem.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
---
 arch/x86/include/asm/string_64.h | 71 +++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 21ae515ae35a..831d3dda3b38 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,23 +82,64 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
+
+static __always_inline void movnti_4(void *dst, const void *src)
+{
+	asm volatile("movntil %1, %0"
+		     : "=m"(*(u32 *)dst)
+		     : "r"(*(const u32 *)src)
+		     : "memory");
+}
+
+static __always_inline void movnti_8(void *dst, const void *src)
+{
+	asm volatile("movntiq %1, %0"
+		     : "=m"(*(u64 *)dst)
+		     : "r"(*(const u64 *)src)
+		     : "memory");
+}
+
+static __always_inline void movnti_16(void *dst, const void *src)
+{
+	movnti_8(dst, src);
+	movnti_8(dst + 8, src + 8);
+}
+
+static __always_inline void movnti_32(void *dst, const void *src)
+{
+	movnti_16(dst, src);
+	movnti_16(dst + 16, src + 16);
+}
+
+static __always_inline void movnti_64(void *dst, const void *src)
+{
+	movnti_32(dst, src);
+	movnti_32(dst + 32, src + 32);
+}
+
+static __always_inline void memcpy_flushcache(void *dst, const void *src,
+					      size_t cnt)
 {
-	if (__builtin_constant_p(cnt)) {
-		switch (cnt) {
-			case 4:
-				asm ("movntil %1, %0" : "=m"(*(u32 *)dst) : "r"(*(u32 *)src));
-				return;
-			case 8:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				return;
-			case 16:
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
-				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
-				return;
-		}
+	if (!__builtin_constant_p(cnt))
+		return __memcpy_flushcache(dst, src, cnt);
+
+	/*
+	 * The relevant fixed-size copies here are the x86_64 struct page sizes:
+	 * 64, 80, and 96 bytes. Keep 32-byte and 48-byte copies inline as well
+	 * instead of sending those nearby fixed-size cases back to
+	 * __memcpy_flushcache().
+	 */
+	switch (cnt) {
+	case 4:  movnti_4(dst, src); break;
+	case 8:  movnti_8(dst, src); break;
+	case 16: movnti_16(dst, src); break;
+	case 32: movnti_32(dst, src); break;
+	case 48: movnti_32(dst, src); movnti_16(dst + 32, src + 32); break;
+	case 64: movnti_64(dst, src); break;
+	case 80: movnti_64(dst, src); movnti_16(dst + 64, src + 64); break;
+	case 96: movnti_64(dst, src); movnti_32(dst + 64, src + 64); break;
+	default: __memcpy_flushcache(dst, src, cnt); break;
 	}
-	__memcpy_flushcache(dst, src, cnt);
 }
 
 #define memcpy_nontemporal memcpy_nontemporal
-- 
2.20.1

