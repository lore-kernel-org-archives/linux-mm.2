Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1C4C53219
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63896B00DE; Mon, 27 Jul 2026 08:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A0E6B00DF; Mon, 27 Jul 2026 08:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D793B6B00E0; Mon, 27 Jul 2026 08:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B2996B00DE
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:37:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 204A9A073D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:58 +0000 (UTC)
X-FDA: 85034508636.27.BC4E4FF
Received: from va-2-111.ptr.blmpb.com (va-2-111.ptr.blmpb.com [209.127.231.111])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2CED380004
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:37:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mdgLSgPW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785155876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KbqR+I8FS5y6RR72nDD58GEAE+Ku54boR4Q6mpg4Crs=;
	b=bh6YeUHuIX5xkCSUfGUR8WwckohdwSketujp2fV1iaZfoNrQXdKY+vTYcfBkBD6X65jjCF
	xIk6vgl7U1Nk3jQb0HotBQWLx3wu28PkGv/3K7SlT6TJSmS+PlOq6watATulUZgtLw9TFw
	7tU827BWUFmwNWIJnF5QB8B67qlIEV4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=mdgLSgPW;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.231.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785155876;
	b=MQRZWb+5NJe6Gdtky94WV6duA0hyJSFT0IxelcHSLyN8GUsCfeIk5+wz0KZLPUU4WqmRQE
	qqv0gtkUFmOYVxM8IE+6Msy54u0kGs23UFCZmzWiq3W49Aw2vzqGnwjlZATgiThI2hNG8E
	MiEU298jkzpWLrbA5t/+MuOBWUSK0ao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1785155869; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=KbqR+I8FS5y6RR72nDD58GEAE+Ku54boR4Q6mpg4Crs=;
 b=mdgLSgPWkTvD6UeGP1UOja1m9uh8Z7abdaOOI9e9zcL453M7B8rHW/P8qWGR8EPlieOfDh
 oQ20WthNzwzcu8wHUNBkGw5Hk2BjYGln3lTLgLJKEwh0f2Vws6Vm+2IkWEYHIAl7MeoZbK
 zT/XaJXs4AUhwk/cUMwbVQlPn8Yc69HsFr/74q5isAuANxt36YsgLksEDW0Wiq/oBQK2K+
 gmSaYu+penDmTHxziiYEO/NMnUb7JNZSWj6CbmmLXNjCNwYqHg5PMbYB7omwtmAopPhMnv
 HmEwK+05cGsHYyBjuoMO8bJnifbB5Ad0VLXV34SsTGhO3pYugYvsIBmzSZQdDg==
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v8 7/9] x86/string: extend memcpy_flushcache() fixed-size fastpaths
Message-Id: <20260727123429.5673-8-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2
X-Lms-Return-Path: <lba+26a67511b+19acc5+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
References: <20260727123429.5673-1-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 27 Jul 2026 20:34:27 +0800
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
In-Reply-To: <20260727123429.5673-1-lizhe.67@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2CED380004
X-Rspam-User: 
X-Stat-Signature: azmcdk6e5yx4k93q58gkp1atwc7xj8u8
X-HE-Tag: 1785155876-631591
X-HE-Meta: U2FsdGVkX1/cUyHU+rm2KqzzODt9p1hT0U6OR3U3avK+l8028EdA1K40nZoPUl9CSsD2XTavca2gOPqgtE0XjWCZ5MekjyBFDKzQ9c1/hxCXHqgUuuEz8rE31CG/usXixqiVT/Y5uatA5C8KJJ/ZNhZao7+849U2bzPBNy0pJm8J1eg2wbc3owqI/sifTmf0MaWEN3Zs7nyhYG1RkCBrcbZB8a7Bu+Zlw+eXBqwbMcJvITES37HyGzWYhWYwsn7r/pTdwDH7vdqNHjj9DHlrdTKbWuJV5i/kbJsY6YqhC37angVzxFYI8TWnMmj3k4+ll0wUBDMecJ4j0g2zztEE8b2dEOTZOk/ok/U30DnuaS44ujHkzfPWE3ylbmVmljLzVKl1WBShxqjwMZ59iphX/rnHkvUAaHXHXaZG7ZY1rHWUqc9LS23paklyYMBfwgjTEy3KZD3DcbGmnHMSKJ7Dn7AhsAB4BQ9kRsuoWvtzyYqNOMWxCsmWszvgg6btyCdt6QjwBMlVJqzTnq96uSplIOGcqYS7x5KNB2mHMy42jl+cVyNO+ib8FRGMFUNrIw288eGC/8TPoiRQlNLt4PIXxiGxQ525hu/s6VyhrPoU8f2mBE0cslUTI+sw4fQwoxQGEQpn518VBkyW//ekHZhwy+dmkCbkib7Jd8mW8KUJAsEUSWHCWsPqo0UGd9EVz3+oxOdYbDsuNdWvxnp4WI0us2dhw8QJhwjNiGXwjrBOcPC8+8Un9Xqvqnkdre7T0z/ctRVaN96ZcqqLjHecvL5ICbWhfRauSjGUiXecoSI0lsqhOChsqVdfTXWX0m3AAmqaZo9R+rVBYmG1kf9N57V/il+tspYlhmvfzUCLp+apSWeh8J+rv0J5asBVr4kCki5xs2Baiq5pT3/7FmwGLZAF4kBQTgs0/1us5KFPbh+WjBnt4OYe3aYVX/E4IwwHY8+FtLeIQBz6dYliGJSi8Ax
 gg1EUc5x
 st3L+Nxf7Q1vw+caaxS9mwRHKBhKIrL67T7A5MYv35roPHFvrLe9YC8T/ptMBsnjAdwftXCVhFl7deyGSFpA+7Qd4yRGc0nSVa2qHRVsfl06TJRqv/4giwubYH58kDvaeKBD6Ew9VWKwtWEuHV1fNOkawZHFDsw5rSs2irtiuvIhuLMyYGB4/3cE436HLu1TNDYiLy3YPqGMYV5QsIrzEK5PdxcbMwCjZpfoCuKO+qdw1d5n9tIyhtYM3Xz7X8we0iWIkBq7pNzoKcLMRnE3xW8fyoQbLuDxLdfdalVQ/nGBs9CR6vUIYDJXHnA==
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

These new fixed-size cases follow the existing memcpy_flushcache()
fixed-size MOVNTI cases. The existing 4/8/16-byte cases already use
MOVNTI without a separate destination alignment check.

The movnti_8()/16()/32()/64() helpers keep the "memory" clobber
intentionally. The destination memory operand describes the MOVNTI
destination, but it does not express the broader compiler-scheduling
constraint that this path wants: keep the fixed-size copy as a compact
sequence of streaming stores and avoid moving unrelated memory accesses
into the middle of that sequence.

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

The correctness rationale for not adding a separate destination
alignment check is that these cases follow the existing 4/8/16-byte
memcpy_flushcache() MOVNTI cases, and I did not find Intel SDM text
requiring an 8-byte aligned destination for MOVNTI.

The microbenchmark is only the performance motivation for keeping
these small constant-size copies in the inline path.

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

