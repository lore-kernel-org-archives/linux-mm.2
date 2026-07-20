Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771E7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:07:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F7D16B00B3; Mon, 20 Jul 2026 08:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF766B00B4; Mon, 20 Jul 2026 08:07:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50C576B00B5; Mon, 20 Jul 2026 08:07:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D87F6B00B3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:07:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0C9FA00FE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:07:40 +0000 (UTC)
X-FDA: 85009030680.13.2404813
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf17.hostedemail.com (Postfix) with ESMTP id C37D840004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:07:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=A47XnSxm;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784549258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03h9QJRQ38dlV/nJWkLzpVtuC5RS5+G1+uFcq5bFKQ8=;
	b=VLvn53jQ82G7Dis5URIJGwXUPOhl+NS0Ug5SjRr4po/0k4sTCFmJ6Mts7i70fNFu8tPwhg
	FLn1KAmg0AA1YUbGctmRhz2zXEpc8UtrdxzV+bewzJZnODUhH+2qp+aM+ESpPJuckrCjvz
	n7f0HcX67XbteXB8gV0/NkPxJGf3fPQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=A47XnSxm;
	spf=pass (imf17.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784549258;
	b=SKxr5nynTkUxKCLP6E1a9JSZ7mzD6zx4wAtm5DevEv36hcaJitEaJX3s9gtek+MiujPY0q
	J6YJOChAzf/lzaYwiuzgnARMxsLH8ucJFa3Q8o9s8KMHKR66++hmixI1TA4oG9wdEPu4D9
	/U5IS2n4eqzlNqVfvxbew7/YesYt75Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1784549253; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=03h9QJRQ38dlV/nJWkLzpVtuC5RS5+G1+uFcq5bFKQ8=;
 b=A47XnSxmMgnDWlpq6lEWGeKigMZtiy1HPFSkL7TsMrpwJHSnEL1NjNzZ4bwPTN9gJr0qtM
 njA03pcbtMdfSKWcNHGoo9+Fm7l7WHw/HsrKxFodFB6SQdzO1Pjv/pcvjmBJgNfN3bqvv7
 Qzep3Hy/ALtENiYIvEOFoNa/p0TxEkJQJ+eEX5pLPVcURRPVgkbRPWhPp3T1YMHRNYj+bk
 NHWSfQ0/XofclPbpe5uBr+0GQBJymieBhUQQCn4/EPQFCtwcv+9Hq3EZqq/IZjyVT9W6G/
 bPcv+687Azb/+IiH3A6Sjitx/UewCeNyHKg3TOCFuZkbz4tzX5iceVHSc6J+vg==
Message-Id: <20260720120259.1545-9-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
In-Reply-To: <20260720120259.1545-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: git-send-email 2.45.2
References: <20260720120259.1545-1-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5e0f84+2d2d8d+kvack.org+lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<rppt@kernel.org>, <tglx@kernel.org>, <muchun.song@linux.dev>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v7 7/9] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Date: Mon, 20 Jul 2026 20:02:57 +0800
X-Rspamd-Queue-Id: C37D840004
X-Rspam-User: 
X-Stat-Signature: nsw151w6xq7uzm34bytwjfx4zjdu36fd
X-Rspamd-Server: rspam04
X-HE-Tag: 1784549258-437503
X-HE-Meta: U2FsdGVkX1/ViXeQ9cIZCndHofUXbL0A9t8PKgzn8jvfkMc0EqKAiRlmAbc6QCBomjRUCHqzFI1swcDLaPvq2PD8Aldda0DslnZ4P+w6PTI1CuQsnoSrUC86urgMy3zCvHz/wCYfgb82l7g/IDC2HTzIcZ2iCh+Tn8WE0balZKf/n0VJNkXdFt6vFsyjirDXunhEOVdnbLLu/olBLYEzUKSaJZ6uEuCtaiLXo3KBFBxbq/yHnvXHQfWnDAXF5kIS1DNudq+lcN9OC4I6r3dLiZEV+j8/L5Tz2UqRpeEfbhMTfIOEsV5OmQshe1iQCQNiWnSiAbmC5gQhO7i+cbgRM+aTNZbcF7i/pKZII29EP1JtnptHQq2DZ5qHmoTc8Wp58Vl1pyxButgdnEM+JNDAb42bT6vJOu+i6EelwKNft+SaEPQXltHfBxNdlhxv8AP9IoLXNhXrMhvKYWOnoqsvYhbT4qdvLnydxUkqJXVYI0Ujv9fPlkhOF2aS0crVVTFqYMAYLuuOYiuqCXgfVwUJ8QHZoQLBcNsu1aIo1iQU7RJygIjnO8+BS6cQ9pf2ynbJR/FinW4gWfOhNk33lVDr0znGJBddU5JS5237Pi+X4dqKxc408fTNSRsF363tfVC0CD07Nv/R4WE+I9jXoNKD1hRkWRvXn6r5Nm6HIDfFDsi1j7CbQIbCbWgL4/3tybZjLc4g2N3vIOFZzpqSjmyq+dgxkSuW7aEZLYP9t1OSu3zlks+di+QGZ7mkaHnwycFWh0zt1vq4M24sSMVNcI8JUlbnG+EFYP5/C1LCAXLt7CesecQXg25IektkQ5TytbFjvGvSdWLyFNW/4cRuHYsZrhTupMgO12dA+V0LVLQUGw+i8kq4Z46dxfwIWbtU5JyFCjBpK/HPJmrCVaPyj7GF3Qwx3CEzOQGhkzCI/9hgDMQdhwgoRbZBu5O6bq3ThcaD9T7SqCkZNk9SCO6fCRO
 GHSXaH35
 p7V6436yqloQZ8xVqNqn2DNhBcFTlS/2iv4oxDhJ03J0teqL1oTQ+J13fouIwDSyQ9rx+nJOZBLRXDsjaho7fOJoQrroXAkrzrzUndF1DZJrwKjNAehxPWnWSPgMrOdCKWuNB7OFW85i27pEouJBuf4fCk8rxZT+5X7cxmHSa27K2KK5aYnDtKZJlWke6e8w2FvrvfZ6ZIohNR3NHbE3InePuHH1aHpxki19pXzqwVZ1sX7MyHV+wNCJc9iDxiYj+pxebbL6pE4gi2uBm9gkju3mYKaqB+SRdhqAYa+ojs1X6bcIvrXX5amipUEsbaSEjNJ4g0HFY5XI52iTEyvKJ+Ne0xQd8Bi+ubzUbxJiO18eshO+/jK/Ciet60msocRD5m2CLXivXJy35lfdKnx0/1EhlaBloDD7nYgZP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The new x86 memcpy_nontemporal() helper in this series maps to
memcpy_flushcache(), and the ZONE_DEVICE fast path uses that primitive
for constant-sized struct page template copies.

The immediately relevant x86_64 sizeof(struct page) values here are 64,
80, and 96 bytes. memcpy_flushcache() currently inlines only the 4, 8,
and 16-byte cases, so even those constant-sized struct page copies fall
through to __memcpy_flushcache().

Add 32, 48, 64, 80, and 96-byte MOVNTI sequences to the main fixed-size
switch so those constant-sized copies can stay on the inline path.
Factor the larger sequences into movnti_8()/16()/32()/64() helpers so
the switch can reuse them without duplicating the inline assembly.
While the ZONE_DEVICE template-copy path only needs 64/80/96-byte
copies, keep 32-byte and 48-byte copies inline as well rather than
sending those nearby fixed-size cases back to __memcpy_flushcache().

A microbenchmark compared two memcpy_flushcache()-style helpers that
shared the same generic body and differed only in whether
32/48/64/80/96-byte copies stayed in the fixed-size switch or were
redirected to __memcpy_flushcache() when the destination was not 8-byte
aligned. The timed interval covered the copy loop only; wmb() was used
only to separate rounds.

In pseudo-code, the two variants were:

variant A:
	switch (len) {
		case 32:
		case 48:
		case 64:
		case 80:
		case 96:
			do fixed-size MOVNTI stores;
			return;
		default:
			generic __memcpy_flushcache()-style body;
	}

variant B:
	switch (len) {
		case 32:
		case 48:
		case 64:
		case 80:
		case 96:
			if (!IS_ALIGNED(dst, 8))
				goto generic_path;
			do fixed-size MOVNTI stores;
			return;
		default:
	generic_path:
			generic __memcpy_flushcache()-style body;
	}

For offsets 1..7 averaged, keeping those sizes in the fixed-size
switch took about 0.410/0.411/0.426/0.426/0.428 us per
32/48/64/80/96-byte copy, while redirecting the same cases to
__memcpy_flushcache() took about 0.962/0.956/0.923/0.998/1.001 us.

Based on that measurement, keep these new cases in the main
memcpy_flushcache() fixed-size switch without a separate
alignment check.

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

