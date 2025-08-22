Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D197CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E4588E007D; Fri, 22 Aug 2025 04:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995728E0056; Fri, 22 Aug 2025 04:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D7C8E007D; Fri, 22 Aug 2025 04:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB498E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:36 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19E141406B1
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:36 +0000 (UTC)
X-FDA: 83803704432.05.1194D58
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf16.hostedemail.com (Postfix) with ESMTP id 559CA180005
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Vqqzialm;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851014; a=rsa-sha256;
	cv=none;
	b=ep8IJkB9xv8CHvtu/H+HE1xfrzePPG6oxyjN05uK1vBC8e9Xh5CghY56IWdirbxchZA54S
	s6pPZQECvQASefrlj1DqEIS+E05zoRWZ1vQ45h3m2QBO9owpYvuxagdupYCoxjcg9h57HG
	R+KkMb2gWHsEDKjUvB7cqhUTVbm9qrY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Vqqzialm;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAUyAK5flnACgu6L0ZUmdj46/dvGaDDed41Ka5MO9KQ=;
	b=KieRIl2oDPHaJ74nKIQ+mbO0EBbrhxa2WH0CzOciDdV3btiYU+oSwxOSy8GICtKFRHSw4R
	eEUFUV/HKp1vEf6xKkv971AD1I+FZedwLOQq4jyQPYAqVaXkdf2F7ZhJ18aBOgIXq4Bcp7
	mVetTb9wGFnFIzKDEG4FI90ccJUJ7vw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755851012;
	bh=6J5PSXxqtGmjRoT5d0cfiijsJ6CAzjFznigi7LNiQE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vqqzialm4g5wrtv4tvyw9MWWk2aTcdXQRG/VnvvvKbnIolO8f8llGOC4Oc6EVk4BN
	 XM9SJgbGlENhJR55OH6sBWy3cuyX5s//oWsx8t4qNIo7DDmccDvzX8FWuyEJ/SvIX/
	 UIRQzy1GoYwa/2d2Exavog6avBcMun0Tslwrn1CX64BdpOyMfGQxgMefXXVlRkSiTu
	 GvO0r4vVX028IQWvhrdiPZ0keGQKh6Zk9+NVXJdH4TC3LXdbdTs6pcIpcdc/vSZ48S
	 bTYiBDOB4vR9KrDQOnhiRVV/SbnAU/+HiIG9x7/AqJPe6wrPSuqJpoLqJT5o3wOlgJ
	 Nv1Ox3SSXTWhw==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id BA4FC17E12DF;
	Fri, 22 Aug 2025 10:23:26 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 6/8] selftests/mm: Fix unused parameter warnings for different architectures
Date: Fri, 22 Aug 2025 13:21:03 +0500
Message-ID: <20250822082145.4145617-7-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 559CA180005
X-Stat-Signature: jntcetq3geckntqschh3j5jktc6mo8u4
X-Rspam-User: 
X-HE-Tag: 1755851014-61829
X-HE-Meta: U2FsdGVkX185k8Yzv8nGr0eZvudLY1R8Vnvk0TJEeQW+SruBveiYnrADvxpmBnZE6sJQ+mB86s+iJgZNi53lgkWuTkruIVyXN+aJ1nQwwWHdT8i6F/lbS6H+Q8bfsr2wexzMVXcaw9/vdM+gx5qS8RmSflVb8puW/zP0cWV1oej0+2vl04Y7p0CgqSMlCfOSqT2eGez4/jKETAGgiLmfhdeyNEm44u2YU9VDJltDDDfS9XN/4H9hjcbk04sibF2JcN1w4MMSuyLQ/5k2NJw8rM2uZQImEjpnkKGEGghOJo9fMHmnXt5fZn2DCVtZv+vpgLDCu7CuCZhhPg5Ocr1756R0ppvS8mEQW/AQ5uHg5djkiSqPYWxucgK1yu3AMzREysw1lJDYwEfZxZXYe0UmXNAeIm6BRiSWhsBxoaHFGEb4khBX7WUZS9YFeZU2N3DL06FqvD2Ibu7IF30PmeNmPFLW3qPjIJsyhyq3WH0O5YXMUnmYq0kWkHIU34mrrYwxPWzdlZe8mfp7rp43Whg0679kjMvvO/Xtio3dIl6IGoZcLRFQeB+PywxN99GReWyBV1lkZQ7o73X9H9GbCBQhCUovXuYV7F1OglOgGco/lk9BgWMDk5Fl1EmUEc9QEtSLjt8KEmDszqOaXOmq+tcRfhJ1fCsNDuRmDfKDxhWJA1fs6c4vfdwSwwMtydGp/Bfa4xn1dW4nZz+sYQgEoUzrsDn+ZKgci01mVq2XYFM+gxmPKZHV0E3U0w+BFSH+DmSacmv5SmWcVi9QNFSNJDzyDqCkoYL7pfziUwO8WZbnwBoK67c2njqovi+kWTusexIiqcZD8XNtFt3iD6pBq5oPb2db7bjqDNFmYxlTogeGlnOGxAex7S7Q+nztHKIkD876hCZJhg0X1e+xTOcNp9TpjR5XV4UUn/QuOWuD9Xkmvn9qTotlJEseAQymvkuY1LuYIF6GXmqQI7nrda6kEsq
 8oPEnhu0
 VwI96eKhOA/zXue6n5PlfeWV2V1SN0DiwYAOOzG0oiZOFWo8YD+0uRy66HxPv1X80cu8A0jIr3cSVaHRwDBNP36gaI1lAw6uKt0expo+I/WsGjqdtSegi1oVVlupv0VhWeHJijmqxmfE2wQr69NMXFDWqfpj5E2ty0nGPZVy4TOs+Ons8hmJvpJ06rAv53h3HGnpZhexzsm3ChClrO/IzX880jL/Lp2jQ1rojsek5IxPEuhsooNW3kqw96VLgNPiEDNoJPtJt+ehSFWcDQMlepFOfnaZdVygig3Al07cFQFNkO38=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are functions which have unused arguments for different
architectures. Separate the code for each architecture and move #ifdef
arch outside these functions.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 tools/testing/selftests/mm/mseal_test.c       |  8 +++++--
 .../selftests/mm/pkey_sighandler_tests.c      | 21 ++++++++++++++++---
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index 005f29c86484e..4c2a232796866 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -131,17 +131,21 @@ static unsigned int __read_pkey_reg(void)
 	return pkey_reg;
 }
 
+#if defined(__i386__) || defined(__x86_64__) /* arch */
 static void __write_pkey_reg(u64 pkey_reg)
 {
-#if defined(__i386__) || defined(__x86_64__) /* arch */
 	unsigned int eax = pkey_reg;
 	unsigned int ecx = 0;
 	unsigned int edx = 0;
 
 	asm volatile(".byte 0x0f,0x01,0xef\n\t"
 			: : "a" (eax), "c" (ecx), "d" (edx));
-#endif
 }
+#else
+static void __write_pkey_reg(u64 __always_unused pkey_reg)
+{
+}
+#endif
 
 static unsigned long pkey_bit_position(int pkey)
 {
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index eb4ef8532c0bf..bfa88fe188f66 100644
--- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
+++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
@@ -41,11 +41,12 @@ static siginfo_t siginfo = {0};
  * syscall will attempt to access the PLT in order to call a library function
  * which is protected by MPK 0 which we don't have access to.
  */
+#ifdef __x86_64__
 static __always_inline
 long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 {
 	unsigned long ret;
-#ifdef __x86_64__
+
 	register long r10 asm("r10") = a4;
 	register long r8 asm("r8") = a5;
 	register long r9 asm("r9") = a6;
@@ -53,12 +54,26 @@ long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 		      : "=a"(ret)
 		      : "a"(n), "D"(a1), "S"(a2), "d"(a3), "r"(r10), "r"(r8), "r"(r9)
 		      : "rcx", "r11", "memory");
+	return ret;
+}
 #elif defined __i386__
+static __always_inline
+long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long __always_unused a6)
+{
+	unsigned long ret;
+
 	asm volatile ("int $0x80"
 		      : "=a"(ret)
 		      : "a"(n), "b"(a1), "c"(a2), "d"(a3), "S"(a4), "D"(a5)
 		      : "memory");
+	return ret;
+}
 #elif defined __aarch64__
+static __always_inline
+long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
+{
+	unsigned long ret;
+
 	register long x0 asm("x0") = a1;
 	register long x1 asm("x1") = a2;
 	register long x2 asm("x2") = a3;
@@ -71,11 +86,11 @@ long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
 		      : "r"(x0), "r"(x1), "r"(x2), "r"(x3), "r"(x4), "r"(x5), "r"(x8)
 		      : "memory");
 	ret = x0;
+	return ret;
+}
 #else
 # error syscall_raw() not implemented
 #endif
-	return ret;
-}
 
 static inline long clone_raw(unsigned long flags, void *stack,
 			     int *parent_tid, int *child_tid)
-- 
2.47.2


