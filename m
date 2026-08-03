Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A612C55175
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 07:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546F36B009E; Mon,  3 Aug 2026 03:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51E766B009F; Mon,  3 Aug 2026 03:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BDA6B00A0; Mon,  3 Aug 2026 03:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9456B009E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 03:13:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C32ECA0625
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:13:34 +0000 (UTC)
X-FDA: 85059092748.24.2E4124E
Received: from va-2-113.ptr.blmpb.com (va-2-113.ptr.blmpb.com [209.127.231.113])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E97E40003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 07:13:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=codJXF7y;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785741211;
	b=Xa/ecsVK1ERT+Q1sv3Bi7AZeBoEwQQOxAAyXLv7IPlHVplfdujhYMC/pkjsTy5blrwhDws
	gMhjgDa6qH/w75WrUnmflxOp1jh6/GG+magjXftAc34+LYY+BWFF6TzilauokcVk1a0h4X
	q+KlZSxxJqeO9ZiV8//JLrJyI2TgbJ4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=codJXF7y;
	spf=pass (imf27.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.113 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785741211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NdI+a5QV2PO1JVHqbHPiO12lvnhARSugrgjYx4LQKM=;
	b=Ls46Gb6AFMhbqseltQSMoF7c7OA+S8Qaz2L1q51wc9KmLdVhjqsMmwZq/emh0xE/2+OIb7
	1QknCHJLjbw0vEaRY3T/X1YyItwRN80YwlE0IcaP4vqG3ljQKvv54v7UxaWbVdkFokkPXG
	A7KXn+nLm1yn9+q9tcxANa9I4RPaCl4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785741205; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=/NdI+a5QV2PO1JVHqbHPiO12lvnhARSugrgjYx4LQKM=;
 b=codJXF7y65AkdNReRLLLe0+Haqt7xmpCtF1D14X9cofjoXsd8B37OkJK9od5YigNunGvXK
 4xjGCBDBSb3KkPJTvLNYsU6EQ36Hhwaw9R1iKS4DsA/Mi41IRuqKXhpK2EnwAQaoXALC9T
 TTEJK1RsoxZ350Zzyet8W/NkYfTmotBWDJpc5/XRbu3Di9q7LqIS2A1+aYih0next75DJj
 bRrSgEDRKZZfk52WYpN8dT67ns/tvD4nJ1q9cX3VMTQ1WYRciMog5b32xzgzBtsrb4b3pl
 DnBNI5buM4XWWxXqv1WIgHOQOi/cvHRJf93f2UZMZOPL8yIXzo/6UhmAHrETgA==
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
X-Lms-Return-Path: <lba+26a703f93+639bfd+kvack.org+lizhe.67@bytedance.com>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v9 8/8] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Content-Transfer-Encoding: 7bit
Date: Mon,  3 Aug 2026 15:09:29 +0800
Message-Id: <20260803070929.86075-9-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260803070929.86075-1-lizhe.67@bytedance.com>
References: <20260803070929.86075-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5E97E40003
X-Stat-Signature: gux9p6oyi737ea9tnrreu8nisjkxommg
X-Rspam-User: 
X-HE-Tag: 1785741211-706474
X-HE-Meta: U2FsdGVkX19LOtBIJKqm6A47aI8uRl9RsnH5e9yZFmEB63oPF3FIzsVJTKY93cRNgThE22IE7LMrC1jh1F3ewUPPzndWzwr2foc/MELWjyLYYihkkhpYbdeYVpkl4MT7hogsrUNQZBQGA0abkx/Gi5SkXQb8EonqhPSipElzaGhp0h9+WhMwL+FpiLla/5CGbDfuu8TGfuMPyQRpgb5/GXbJvWMoDa1KEUwUlTkPXncvdS/GeENv6eo5zbCPLD9tAshjw+IZhfRuf7AFy2YXJTFIKo/C/9ps/dybZA64Fet5g1SQJ2uqNZXWP54LIFgkr8JsQxIRe8R7pW6PEaSf+ZN7dsGgi1r1iGA9m9ULHnFhpZbG+XpbhZ5a9cPlShi2D0ugjeyL7lYr/ZqESO3cVinKtA/jdkNh5VVfXDnAD8yXAi656vI9lk4jQb9ipV6Mzpt2EqZMqvAchOFyrYmVxlvuUvOKfBmWw85nE7kdvFQiWpNCWDXpZZ0yey/F+uJpUEFxqPy7HCHDkwLJ7iejyCh5F9iGDaGamVqJNQOd+PaJagFznEiloHI4B1iEO/fYmlE5tPOSL97T+ke/EiGqJz1/ca/nLi0kBmxLHOfLJfmhiogxN7/gzu2HDnnkZAYSXA7ybVIpbydR16ewqP8UrDj8fQWtMstUF+6LsBBfYtXkGdwIftPeU2409W5XoxhZ+KzIgiBIeMptuSPTML58MFx9qa0Y4ZahMguCNsuZ4BheNEqmNubLnNeDwhPj0MfrJ9Dt7aTvXjcN2KVRQLGcFPhAomnS9iMwJ35Sm1+agUJAcdDUOXujCq3skOtfyVLayrLWliWiUDr7IXA0+cVJrAzDwYJXNc/Xlwzx6fgC56ZAH0SP2yV6ovCPz0o0SSAWjMjTyxceBXx0zt6RNxbMgl9A78Tkw+x22bcgDLGoi/V/1ZWaP1War+AG2qNuouN2gLk9OUGJ8jdnGwsNUW4
 gYKwjltd
 gNhSg7e07tKyhgvWXlKl9DqH+UsWVvfV8TDwmDZWmI+tZm4Y75wdW/eghYJlfGFOtHolRFPrrQWI5/re1d4Sr8vooAv8ldV4FHZl4kd0HFM55ZFNvSNtYSjlY//MRWFd3aqFlB427WUM3o52H72nEM455reXeaU/2wMGa1/LsqzUF8ZoXhpGGSbwap8a9UUo0dZiQUwUZdoCtg/rYZnp8d0PNp1nlJmO06Xgvs7uo1P/GsVYXHlbuflx7GpeFShNwGzjF3lQNco438hsnJntVHGny0jP0jyoEL7V3jOYau6YKnVjknujkekijjg==
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

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 arch/x86/include/asm/string_64.h | 56 +++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/string_64.h b/arch/x86/include/asm/string_64.h
index 21ae515ae35a..bc6a9f34b346 100644
--- a/arch/x86/include/asm/string_64.h
+++ b/arch/x86/include/asm/string_64.h
@@ -82,7 +82,35 @@ int strcmp(const char *cs, const char *ct);
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 #define __HAVE_ARCH_MEMCPY_FLUSHCACHE 1
 void __memcpy_flushcache(void *dst, const void *src, size_t cnt);
-static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t cnt)
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
 	if (__builtin_constant_p(cnt)) {
 		switch (cnt) {
@@ -96,8 +124,34 @@ static __always_inline void memcpy_flushcache(void *dst, const void *src, size_t
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)dst) : "r"(*(u64 *)src));
 				asm ("movntiq %1, %0" : "=m"(*(u64 *)(dst + 8)) : "r"(*(u64 *)(src + 8)));
 				return;
+			/*
+			 * The relevant fixed-size copies here are the
+			 * x86_64 struct page sizes: 64, 80, and 96 bytes.
+			 * Keep 32-byte and 48-byte copies inline as well
+			 * instead of sending those nearby fixed-size
+			 * cases back to __memcpy_flushcache().
+			 */
+			case 32:
+				movnti_32(dst, src);
+				return;
+			case 48:
+				movnti_32(dst, src);
+				movnti_16(dst + 32, src + 32);
+				return;
+			case 64:
+				movnti_64(dst, src);
+				return;
+			case 80:
+				movnti_64(dst, src);
+				movnti_16(dst + 64, src + 64);
+				return;
+			case 96:
+				movnti_64(dst, src);
+				movnti_32(dst + 64, src + 64);
+				return;
 		}
 	}
+
 	__memcpy_flushcache(dst, src, cnt);
 }
 
-- 
2.20.1

