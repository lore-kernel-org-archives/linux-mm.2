Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B73B8C5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE8366B00A2; Mon, 10 Aug 2026 08:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C71856B00A3; Mon, 10 Aug 2026 08:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60366B00A4; Mon, 10 Aug 2026 08:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 813986B00A2
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:25:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02236120118
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:25:18 +0000 (UTC)
X-FDA: 85085279958.21.F621B2C
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 28D9A40008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:25:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RB3opE5L;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786364717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZuj0HlrM29RM25pBmz0Kgx3giTvhF2mK+AyOkzDqng=;
	b=3LYK7tSFuaQxlahFM1gUvy8N527Gbau61IHYDLsyidC9oc78w3/qLo0A/ADcE9e6J/VduJ
	JWGVNpNrXt0WMuDTFRPMKqW/pMgg8TryX1SyiBDu2Yfvtp8zCUNOb9Ss5czWMnzjoe2ZDH
	kG7pPS4OHAM3sZggEiC8b9jzhyexl/w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=RB3opE5L;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786364717;
	b=aZ4LrsKM+nNLR2GxYZWT/dqb6rQK2OadloOKNWOQ3ag47k1iIObbtBNZK5gCiN3BEB11MI
	MpHgnEM2yGGWpcIl4eTYgVz77Z3QS04QVM/IxY0dLqd8YomhXB/B00/bKJB4iDlfTPV+bc
	seg1b26lxIUcBpchIJuPsj0sPCQnAeg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1786364711; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=TZuj0HlrM29RM25pBmz0Kgx3giTvhF2mK+AyOkzDqng=;
 b=RB3opE5LVCgkGE5rfHDkFT1Tfq+6NbTyih9BYBYGaPHlL59rpvKi/WxrX/7pluVH19X6a6
 kfxyru4nPf9HKjT/U3NI6n6XdHdIcX5KcZcv6rtMw83BgJdxsSEv7ZWArjTPg6CgvoNkPn
 MKKd3FLTVoZ22AESQi0sg4BpYhjYa9bzolWzFWUUmTq6r0ebZZ3AWRdbUnAjyWKQDtWbU1
 M9FAYokMUFydSyZvy7AiUYMXTToOW9tyMODipuvWabQ85+nzDQ17egsbGWBJPH5VeZ7g8Z
 ODApinJa6WrdmrxR9tF5a2b35KJ0OSq4FsCNPdYt+6P8j5eSW41Tufs6UBvNew==
Message-Id: <20260810122057.30447-9-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20260810122057.30447-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
Subject: [PATCH v10 8/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
X-Mailer: git-send-email 2.45.2
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 10 Aug 2026 20:20:57 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260810122057.30447-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26a79c326+476966+kvack.org+lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 28D9A40008
X-Stat-Signature: rtfpuj7ymbrrkzin9jh1i71c6rddi75a
X-Rspam-User: 
X-HE-Tag: 1786364716-432699
X-HE-Meta: U2FsdGVkX19sN7x3+HfO6cN+5apajKXi2iWEFxWpSn+jNTDcL+5A2/pwOaGZHf48+2Spg9xjS/IOeurKKWqhrWGOmzrgp7BGfrv+ON2kpN1ydoIG65CTgYFc/zF8R5O2CtvG+nfN1HvlAx06XyD7xN/366erU1kIJ5rbr6cuUI9I5e+Dy4bAIwcjWYQsNCIiol/4h6Ek0tC1ACm1yflNvvt4jayaVMHgBGCbB0dhSgEp7Ej2qwtDzK+wBB0/E6O3BqmKYqBG3IjILsBjfohqrdCzoUHNq4tCDSRp1p7xa0A6F8iF/jLi0+89iMydSY5MHENi32R+krkU5B3dbkUHFU1GG4Ltzl0CucbChp7dvzviG1oZ8cxAUoy3lhNKNwDn7j6CCj5tg94w82+rwF/CNU0H6ZtBfP7pNNH8Za9HQ1olIwM5gkDLKxvRNb3P9j5mqoAP/fgir8kRkVUPcl5G6qIvmt/CJhqCWda5qLei4dRCb4j6iRSxr7HPgSJ/L52NeAssHqyECVWnWvjnamcRQy6rG40sVvVa1QleZWxGrfCGwGLhEcB1EHs8Cte0o3hQ8z9mlc++Jnncv4ENmRyjLLHS7ykSpz770DPjqwlqnWy4HNBHhH76V59mzlcop+7YorYAqKqLNqY7jo+uwpNpFJOeuQl1PuPAFQMquoF3ttJHRhGPcDmGBT32mDir+GzUAM2akwNgoVNMSkPN7FVGAi41Jkkv2N6dnVjgSfyieJqYalXp9JeCemUMGhbE1qmu+QG0oCCzg7MptFEwTEUxVQmL1VlFrad5DZQthkHVZ2F0JUMVu3HsV0X4IgKFHEj5sQJVI5zs1vXRHEuYgh+sSkgcUMKQm6TeTrEZujHAHWYRxew2MKxPujp/6MCdglUtfbMcsCzUFDG2BAPRfHIzEPvjpStAvNsmohKPy/XvJj2CLJLz4z1g6e818b4FQCRTP5/cBXj59NujSirNp0H
 EMUQvAnz
 89Zp/pZV9ir4Vj1+J6Segf6YAWRzy7+q8rul2jXHeOBraeWsW+X0m3qbbxJ/iIrnpvlA1W8fXFGnLfzsj6tZ/DHeUfF5fQbsLIPAtyi6FZmj0Lxn12q39Ox1b6bdj0oSTJ+BF4H/NA60FfY2pFE8+iGPqC/elaWZHHT7smgOhDlLMxXpP0ky6PeMmotgWYTWqn8FXijdC5HAAH01ojPptT8V3J+0HYMh0p5o9p1N5VCMas7kIR0zKFQWIFbe/jBOW+6y/UrO3npsvGjxNLqPNN3Dpjw1oRtf4PKE+H55ejV60F/kiilGvHQC4HQ==
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
  Average of rebinds for nd_pmem driver: 150.83 ms
  Average of rebinds for dax_pmem driver: 153.55 ms

With this x86 fixed-size fastpath patch applied:
  Average of rebinds for nd_pmem driver: 96.79 ms
  Average of rebinds for dax_pmem driver: 119.04 ms

This further reduces the average memmap initialization time measured
during rebind by about 35.8% for nd_pmem and 22.5% for dax_pmem.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
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

