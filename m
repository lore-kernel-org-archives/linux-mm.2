Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5563C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:03:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55FCB8E0002; Thu, 31 Jul 2025 12:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5105C8E0001; Thu, 31 Jul 2025 12:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FF9E8E0002; Thu, 31 Jul 2025 12:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5E88E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:03:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9E3480949
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:52 +0000 (UTC)
X-FDA: 83725030704.09.4F98F95
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5E464A001C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:03:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ZsmT9zUa;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753977830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFRUod1LETsg74Qkt/8QptMDoryWw/7mPsDdQJpyJMA=;
	b=tmoI12YYJ6t3m+w1ArhkTtvl3HHZPwybu+zliOD3ODiRUPMSjZoMp9/Vypu2kDn8EFYnmv
	x3KK9DOo2gvjClkHd0rgs7AWYFBsTEX/9VcjDmMgzzC9JzRX/yWKr4W/S6jCtopRn7ucIN
	RePDgDW/L1JoxEavXodPUU3azFokdTI=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=ZsmT9zUa;
	spf=pass (imf25.hostedemail.com: domain of usama.anjum@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753977830; a=rsa-sha256;
	cv=pass;
	b=IlqLZchKIS0h65oHERqKhZhiwF0+lMeA0m70scj+zdo6vLs0nScRFfh09TQPUL5soARzAa
	qNuIPGreTITB7FPqs6BhfttaE+LY4KYxQeM8m3Ay2wph2xuTEzslo3LucHCDdBfLkbBqXz
	PKH1dF8h4RKaYeVzbnDRNQLHhwWh1pA=
ARC-Seal: i=1; a=rsa-sha256; t=1753977814; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=C8v46k7DZVPWHrtdnDxx+B1H9e3oTQQKoEUlihOcuoykiizMGZ2DuqpH3we2WhGi7B06TVkV+KxBAn0Bf8Fj+ir6MoKr2VVwLoP0nh4MQoHE+4wSRmwlYaf0FZdGEAkWIks+x82voM8CpPcilzent9OSDf09xaBaOLXtx8D/AaE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1753977814; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=tFRUod1LETsg74Qkt/8QptMDoryWw/7mPsDdQJpyJMA=; 
	b=MSsRQc1CLGXH5lgzPf8W7exC2qpS0QWtdYvRRMzl9SAI2NYNP7n03MbgtFNyauldv7AD4ZhneCPEuAmAvo3lzb/I1Ffxzwq0uT+wJ5a8oWEPLS//I6jfg4xDJ8NndXxRJZMWZNjzy1uUcAzKeTW/2BeUuoVk97WBXCZBImcLqk8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass header.from=<usama.anjum@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1753977814;
	s=zohomail; d=collabora.com; i=usama.anjum@collabora.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-Id:Message-Id:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Reply-To;
	bh=tFRUod1LETsg74Qkt/8QptMDoryWw/7mPsDdQJpyJMA=;
	b=ZsmT9zUa5eWfbbvDyMVVzPqiFsPJdSkNGak9DUUGi7MDW7luOQuACxcj91V2ZB10
	mcRtFG1ppOtRtNPjOd2+lfUbSqHSBT6vuXujVItCwKkDrSEy3NuoVgBpcfSL8v/ncVG
	HfPcQj2c8TIlbrD+kWPj1ezLf3vtU13lfwmTy0hg=
Received: by mx.zohomail.com with SMTPS id 1753977811994182.64658106567913;
	Thu, 31 Jul 2025 09:03:31 -0700 (PDT)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Andrew Morton <akpm@linux-foundation.org>,
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
	Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v2 8/8] selftests/mm: Fix unused parameter warnings for different architectures
Date: Thu, 31 Jul 2025 21:01:32 +0500
Message-Id: <20250731160132.1795351-9-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250731160132.1795351-1-usama.anjum@collabora.com>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E464A001C
X-Rspamd-Server: rspam06
X-Stat-Signature: 1idih83s4qnabjqxwwm6by336ni37gik
X-HE-Tag: 1753977830-802462
X-HE-Meta: U2FsdGVkX19bUHOaFczl4fjLZDPl2UMJH8MfDs7XA7dbOqVxkMkyeWctUVIauQlfxiRbc5Yvov/jNCHefFjjPmHe8rDNtJZTBgf7xSceqMMY0GuH/JN1ayYG9um45zQA3xgS8nwf1lC6zw1oYhfDg4eB3D2kKC4DeSrn+7EoixElqGmjigJOD28E1cKarhykuX9m8STIMVW77C5BAvwCE7shO+a5D367J4AXtnhkTRMCbT95iIJaOlvKdhHMk5+H9iQ5eS7fHuk3tzHmJHKf4UnbczZ1NkSfXoKlq05NtUwhkYXl+mIqOlbTQtcK9UTcAlWykrccVn8mjRWZkp6eJZX2ke0IostFC/T6MXv8d7MGp6NXcl9+DV0mkwj3/g+dt0y8Ts0VnMWQnPtEc7vQqMDt269UobS1gaGbqmVQPNa8rpQIP1P4YmiJXIG6Aw9srn/IffqT2cXEPouJXLmnq4rcKsQUPHLVadL0c2HKJJ5pin1nC7W14tKZcW4xN4Fomz7KYSfqzgyH6W/GgCMJzmrjulAgmVFl0uqFrFfiqdL9E1U9C8zJ52iud0XJSI3mDPTKxOXLvSvX7x3+xl04shJ4dclWGaZyMsbrN3hQy8Nr7q7+AO2BGqXQu2p/cYK1N5zxOJNixMwOWCcpGTgoG5Y5oMOez3b7rRScClHwqyvmMLa0wWUjeY58DIV3T98/k3i9c9fShNaXXL3HuaHY1zlADafYQr5uhcefXJbLYUg/AyLTzM1b3kHjQBX9NiWLAYSf78YQZ5vtgN45vx87DVF1+k/TqlMsCO6rBZJTfoSVsSONKk4gFgtL/cMDJbKJ1/toPMBSD+FSSthNcnkbubINlzBmSS/vZec7c2unMA2WCOQSGXzOosK7gGulj5u5+jGgrg/e8aPEOkcoDoT07xilJpF7EbWnpp5lkuwprulgTpXyYpHcyuuQj6Fh24/7i59EZBo6AsHwdAs2tGi
 W2DVHEU1
 BgYCUF4xfhcTfX9iPnLNz4XrBhXk0HzuqnXobwjLZ3WwxnJRLdOjkH2L9qDzH9Pa3Rb1QX82AQ3lXk0xT1DizB+qcNUi6Cnb18aPCvYorBy8oD2F9ZYh4ireorsJKKrHvZ1HG0lIXnMiDC0TNqDysoUkxjuw3kBs1AF84fh9qmO7uq7qa4NINf9My7QalBu4CLiMErCzGD9VTAY+L5qE880D5y0IRXYBbozpf00bj4KtEqAn6qV5k0C/KuN3Mlvld9v5OX5rqv+drYImsQNFmKl84Ms1VSpwqRFqrJV0eb+JaVS6ABYak556mzTmXBs2n/FjpVvqIDEpLL1pi97VskCaR+CMwAVZ5Zx765+VMzzrBtWfaonOzl5Sbz0jkdp1Orovg
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
index 34c042da4de27..af49f72e1f465 100644
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
+static void __write_pkey_reg(u64 __unused pkey_reg)
+{
+}
+#endif
 
 static unsigned long pkey_bit_position(int pkey)
 {
diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
index 638477494ff3a..68f106d0876a7 100644
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
+long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long __unused a6)
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
2.39.5


