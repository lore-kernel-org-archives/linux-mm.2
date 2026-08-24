Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4713C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A478A6B00A4; Mon, 24 Aug 2026 12:06:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F1C6B00A6; Mon, 24 Aug 2026 12:06:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EFF6B00A4; Mon, 24 Aug 2026 12:06:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 558416B00A4
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:06:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E3E971601B0
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:17 +0000 (UTC)
X-FDA: 85136639994.15.F9E8841
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 336FB80002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:06:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n5AF6xbs;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787587576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L02kQfqAeUsqYN28ygq/uT1km8M9I1rJFmuynPo4IKc=;
	b=ZtonMJsJMwVWcVDw1bu/PCJGlExhhUcRZc1bboIX+H+7KOGJ7iqP3AEXT/wtOex0iFKdm4
	F2HohxmaoHFwbiqSGSAhnx5zYKKYDtZomRV3HEPzUOUgpnO8DwYYXy3VJERfILAHZJTkGx
	6vTs2dOImx0IjY+YIu8XTg01owVTPA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=n5AF6xbs;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787587576;
	b=JF1Q94AXSL9RxVO8UoR+f5Ux9BNow56cONn2I0LxThyhaIUVi/Sp9dFTn6hTlCVICikza6
	m6PsXxK+/CUzWrl/uC3RO/4zK7Q89CBaPBrCipQTnAHf244N3L/E7P7ewmVM9CSOJE0BFz
	/ZkfYkEVmGEr6qMY854mAcUKvua+2FQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BE991AC1;
	Mon, 24 Aug 2026 09:06:11 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 102303F85F;
	Mon, 24 Aug 2026 09:06:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787587575; bh=Eti3rTlv+cxAVxk1vV0UCcKrMWkCOHT4UCvaZN/ysVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5AF6xbsvYOJDb232Qg50DCemCE4qaYKTCUYp0BZbfqNZ6nujWbXQrRHrQjDCm99n
	 akrUnA9aq9/VXusaTW0mhrDpjwetDpb7unbe70ZAAywW7Ln4KarRk8gPk63sHOgK51
	 kLE5ugmLz2WbYPD7/SK3iKuatOMbzXplh0cSB1Mg=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-arm-kernel@lists.infradead.org (moderated list:ARM64 PORT (AARCH64 ARCHITECTURE)),
	linux-kernel@vger.kernel.org (open list),
	bpf@vger.kernel.org (open list:BPF [GENERAL] (Safe Dynamic Programs and Tools)),
	linux-mm@kvack.org (open list:MEMORY MANAGEMENT - CORE)
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH 7/7] bpf: Batch TCO handling in string kfuncs
Date: Mon, 24 Aug 2026 17:04:53 +0100
Message-ID: <20260824160523.3907021-9-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260824160523.3907021-1-usama.anjum@arm.com>
References: <20260824160523.3907021-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 336FB80002
X-Stat-Signature: hkn856r5hkw6s9ky3fxkyxb1rkjee7ti
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787587575-907120
X-HE-Meta: U2FsdGVkX1/fCLfY2pKh2sN3yjKKbgTzqJE0RBAibOeWQQkXbzsaA0nR3nDxTkmc6tzYsZTit7iHqvdzBpK00o928aQWSuogjGAMCa4R1d3zn89trp9cdHyFj1sa1v3RunZMFYjqsF+DfLt7+G+NhfrDKuNc73nMuQF5uRrmYc89FIMo0q7gtUOA3f/gLXys9j9mzwXDunW+Z8MiRuDpwTo6FQGBq5KcsS3B6B+bAcgHDekhxiWyDMotU6lC6oQNGMJ6GVSOYDwxWkXaYIxS94tPL187Ny7YevjmXfxkguovQstvhYMRAF+W8GJkPyGpvfyHMXtO9jj1Yf02gWThClezxEjM4Sd96Nn0Jq7sTsGfS2d0D/1KjdJMausXdWlytf6WlAj3JHtRIZwMkdxznBoSjV+4V3Z8c6RimHTm2DPt7CdU+FlvDaA8vg2xDLhN5AHzG7wLdYQUyfhFMVO1eTR8eON4S8ZYqh8ZXXFojm6syqe8bSqtrbUNpkGNp5xbuxA0TiMfkESwuISoe5HpSbnjTW0sXhLRQDdDcGnhu9v0cQnW5jJgyfqg12j2hNCjZckBqCKqkq8+hn5pSMbDDyqCYlrJojg+uw6BPIJA5gb9fsAfL0s1xsSLR9FV3FNeR3+ZJ3wcjKZOoE7ZXJjbVTQfAwAVE3B9zVRKTjG7r7rV5NrkBJ4j3KwGVMhA6xiu8SdlSRNTmtdDXdcPalnBMfpkb999aLk9dH/v3gMqZoA+PLKCpBlEa76UpSnVVQr6NIcpymDGbJ/111XN4sp4ix7GWRAzjzAObGXQCjGN7FSAzDTt7OW2ORx3w4VnHeEF6BwmZqCrmuMmJVwDVzMrkaE5kwNpkleAgchW58f9SItGbW4kYKklf86XVEVHCBLBB1tfYpcJdYGDBKXkElYh40ix0Iqq3ZrUtm0RLbyxYUsTHL+WAfr9SWIOOCR1UDenfhOR34WBlFrM99drMz1
 pyemiUjJ
 Iz9PpAmUeIJFdi/iASAJNisH5F3ufG+qBSJpIq4fhIlUrAJpFn4X53e9VX1XebggJ/db6Ib/0sUgvY1kcD9dGURsqIkgyR3zyhFF3xbDPv/RJyxbl3ovZWqWMmo6N7T8aJ731j94/kFCe1bG1lAsb80E/jswPw+Vq5yrkR9p+1B8UdVnADkzZqZVEvDTRtY6yax5lIQPt7tkkqpYmbV43wQusjs3NYWcl8h6mmHn/tBZcSo7NMy8re6kTQxsfABKyqD0RBYmMhBfjLNtFCeHewSTa5oBXz7RMThYh3FA8CD0CkE8rp/k68dCWwG0cxXvaQMx6mCj8ptCJGF/6haYkkcRRx/Ergfb3Kl08A047JJyBvT+DHBPE5GVe0F36hCRA6i7LLj2ZSjnExx2K++aQDKrduQ+aCDe812iu6kRuCzedrTmDx20g5WCMdSP39645cQEGiG5iuii8M8xUWw1fsJbHQOdkuqI8OBA/9WSn6SXmyPRehtD8dSMhYU13Fek+mgM04UnlvIbmIIw3QPeH32u650G+LNOtj7QP3DJNRqsDjkRbzbj9InpT3rhqvSAPwoHTFRESAUc+0wVET2oLCtdANLe4uVKB4mprCEHNlt2YAz6TZIq9hV0yABTK2B2AVNnKyGLk1YhWZhG95N7eMKky+lr9q5cZHvVJz1f+dKYU73tg0v+EevIWswmG8BitGbNQCLMssD7N/FJjBSYr2QWqR0/vsKVzuSmzzLFi893a2YuwAnyGQHL6wIMXqP59gfpnPbiECGZWlyxAwLuwNPuBRcdA/JG2ZMAEWWez2sFZjw2gF89yqfrDQ8N6ZrHa0E7uXtx8/XTHyn0q0z7XGa6MB6YPahG6sAvb3D0isjzxnWhiRF/NiTIv91ec+bEZrH5UDyrPTocdGvpyK8pbX0m9pID20YJYqrhgqR2LAezJwrRXXQgUHEEatV6kkEyxtTib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BPF string kfuncs cannot rely on NUL termination, so they scan memory with
kernel nofault loads. With Hardware Tag-Based KASAN in asynchronous or
asymmetric mode, every arm64 load sets and clears PSTATE.TCO.

Use bare loads and hold one nofault region across each string operation.
The scope guard restores TCO before page faults are enabled again on every
exit, including an access fault.

A character comparison performs two nofault loads. For N compared
characters, the number of dynamic MSR TCO executions therefore falls from
4N to 2.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 kernel/bpf/helpers.c | 35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 3574a9a5721ec..f8c557161584e 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -3726,7 +3726,8 @@ __bpf_kfunc void __bpf_trap(void)
  *
  * Since strings are not necessarily %NUL-terminated, we cannot directly call
  * in-kernel implementations. Instead, we open-code the implementations using
- * __get_kernel_nofault instead of plain dereference to make them safe.
+ * __get_kernel_nofault_bare under guard(__kernel_nofault_bare)() to make them
+ * safe.
  */
 
 static int __bpf_strncasecmp(const char *s1, const char *s2, bool ignore_case, size_t len)
@@ -3742,9 +3743,10 @@ static int __bpf_strncasecmp(const char *s1, const char *s2, bool ignore_case, s
 		return 0;
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < len && i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&c1, s1, char, err_out);
-		__get_kernel_nofault(&c2, s2, char, err_out);
+		__get_kernel_nofault_bare(&c1, s1, char, err_out);
+		__get_kernel_nofault_bare(&c2, s2, char, err_out);
 		if (ignore_case) {
 			c1 = tolower(c1);
 			c2 = tolower(c2);
@@ -3843,8 +3845,9 @@ __bpf_kfunc int bpf_strnchr(const char *s__ign, size_t count, char c)
 		return -ENOENT;
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < count && i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&sc, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&sc, s__ign, char, err_out);
 		if (sc == c)
 			return i;
 		if (sc == '\0')
@@ -3897,8 +3900,9 @@ __bpf_kfunc int bpf_strchrnul(const char *s__ign, char c)
 		return -ERANGE;
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&sc, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&sc, s__ign, char, err_out);
 		if (sc == '\0' || sc == c)
 			return i;
 		s__ign++;
@@ -3929,8 +3933,9 @@ __bpf_kfunc int bpf_strrchr(const char *s__ign, int c)
 		return -ERANGE;
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&sc, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&sc, s__ign, char, err_out);
 		if (sc == c)
 			last = i;
 		if (sc == '\0')
@@ -3964,8 +3969,9 @@ __bpf_kfunc int bpf_strnlen(const char *s__ign, size_t count)
 		return 0;
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < count && i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&c, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&c, s__ign, char, err_out);
 		if (c == '\0')
 			return i;
 		s__ign++;
@@ -4014,12 +4020,13 @@ __bpf_kfunc int bpf_strspn(const char *s__ign, const char *accept__ign)
 	}
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&cs, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&cs, s__ign, char, err_out);
 		if (cs == '\0')
 			return i;
 		for (j = 0; j < XATTR_SIZE_MAX; j++) {
-			__get_kernel_nofault(&ca, accept__ign + j, char, err_out);
+			__get_kernel_nofault_bare(&ca, accept__ign + j, char, err_out);
 			if (cs == ca || ca == '\0')
 				break;
 		}
@@ -4058,12 +4065,13 @@ __bpf_kfunc int bpf_strcspn(const char *s__ign, const char *reject__ign)
 	}
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < XATTR_SIZE_MAX; i++) {
-		__get_kernel_nofault(&cs, s__ign, char, err_out);
+		__get_kernel_nofault_bare(&cs, s__ign, char, err_out);
 		if (cs == '\0')
 			return i;
 		for (j = 0; j < XATTR_SIZE_MAX; j++) {
-			__get_kernel_nofault(&cr, reject__ign + j, char, err_out);
+			__get_kernel_nofault_bare(&cr, reject__ign + j, char, err_out);
 			if (cs == cr || cr == '\0')
 				break;
 		}
@@ -4090,9 +4098,10 @@ static int __bpf_strnstr(const char *s1, const char *s2, size_t len,
 	}
 
 	guard(pagefault)();
+	guard(__kernel_nofault_bare)();
 	for (i = 0; i < XATTR_SIZE_MAX; i++) {
 		for (j = 0; i + j <= len && j < XATTR_SIZE_MAX; j++) {
-			__get_kernel_nofault(&c2, s2 + j, char, err_out);
+			__get_kernel_nofault_bare(&c2, s2 + j, char, err_out);
 			if (c2 == '\0')
 				return i;
 			/*
@@ -4102,7 +4111,7 @@ static int __bpf_strnstr(const char *s1, const char *s2, size_t len,
 			 */
 			if (i + j == len)
 				break;
-			__get_kernel_nofault(&c1, s1 + j, char, err_out);
+			__get_kernel_nofault_bare(&c1, s1 + j, char, err_out);
 
 			if (ignore_case) {
 				c1 = tolower(c1);
-- 
2.47.3


