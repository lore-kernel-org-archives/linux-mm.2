Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 664ABD232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 05:11:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879F66B0088; Fri,  9 Jan 2026 00:11:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 827646B0089; Fri,  9 Jan 2026 00:11:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726436B008A; Fri,  9 Jan 2026 00:11:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605166B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:11:50 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1B431AAFA0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:11:49 +0000 (UTC)
X-FDA: 84311253138.17.293B69B
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.66.162])
	by imf20.hostedemail.com (Postfix) with ESMTP id 056521C0007
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:11:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=aosc.io header.s=default header.b=MKmBQjpf;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of fearyncess@aosc.io designates 217.182.66.162 as permitted sender) smtp.mailfrom=fearyncess@aosc.io
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767935508; a=rsa-sha256;
	cv=none;
	b=M1AVqsKKKPbvtIbGhQMTuSZMnoDgpVuqMWuyU210hAXL8MtpFktePfHDGfB7AdLaT6hrG1
	rUjtmrm/auJgrZj8tzTu/RmH+xbhLOjDT0S90mnrYfQyWyOJOAbXhtSfFQSe3zJ59OXvxy
	19/519ahzo8H9RzSDxeiIUhVvda2KQU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=aosc.io header.s=default header.b=MKmBQjpf;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of fearyncess@aosc.io designates 217.182.66.162 as permitted sender) smtp.mailfrom=fearyncess@aosc.io
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767935508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=v/Fy4AITARxh2wJvTshydR2rSDzjkImzaXl4F/e3eHc=;
	b=7jcdS/n4pYADYZ7TmhtKALEAJFZZ9Lv77d36O6POJTrA/zF9PQanzGYwt/KN1VKXMQfxz/
	wqOobH+8X5jk4ieaI7viJqibmAoHuSiCZMAEDKNBj6zYlf3hYqobNC9zFeGHoh3MjctZjh
	4RMRYRNM8POcYGARCtPBbatAM/C/42g=
Received: from nf2.mymailcheap.com (nf2.mymailcheap.com [54.39.180.165])
	by relay2.mymailcheap.com (Postfix) with ESMTPS id 434793E877;
	Fri,  9 Jan 2026 05:11:46 +0000 (UTC)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
	by nf2.mymailcheap.com (Postfix) with ESMTPSA id 4B996400D4;
	Fri,  9 Jan 2026 05:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
	t=1767935504; bh=XUGcHWBeKsSGyKahv/f9EJ/2cAIemFw0hvMY1sSvpLA=;
	h=From:To:Cc:Subject:Date:From;
	b=MKmBQjpfw3rjzq1XIKddnhmvXl4W21WgFm7GKA2WJWuobYtzF5ETYkoBj70Jj8GhW
	 iPZfi6ThuPeUymAoQVr1kVKaGmROIxh/81TWsCWF0z0HTroQu+iKirfg0oJ1YwZ+Jl
	 jyEq0RexZEMVlx7+MKKp8jEhf5OYpr3p7c1h9ZVE=
Received: from Mir.wok.cipunited.com (unknown [130.162.235.122])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail20.mymailcheap.com (Postfix) with ESMTPSA id 3DAFC407DF;
	Fri,  9 Jan 2026 05:11:37 +0000 (UTC)
From: Lain Fearyncess Yang <fearyncess@aosc.io>
To: Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>
Cc: Kexy Biscuit <kexybiscuit@aosc.io>,
	Mingcong Bai <jeffbai@aosc.io>,
	"Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Arnd Bergmann <arnd@arndb.de>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: [PATCH] loongarch: wire up memfd_secret system call
Date: Fri,  9 Jan 2026 13:10:51 +0800
Message-ID: <20260109051054.188030-1-fearyncess@aosc.io>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: mq4gubxedc9asb1rehmw9qursn84693w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 056521C0007
X-HE-Tag: 1767935507-949953
X-HE-Meta: U2FsdGVkX19U/Eg21xYxdgA8MnCHxT/4I+A69g1DUoNtYzgAhUiJuxtHbqCP9OF7T/lITWEpB51wFRAIw8UTiMARqCr10Sde1OXyS1sAUMsiNwgYTMjYFjkH4IivcVST2hkPmDRDvxG0fAobtezgsAmNso4+BTXkJUxw8vbDkiRdsOOMDDySrtNhxR0hAB0fkBvUdIgRRe2xjwoOF7hgtb6zGQt7KOS+ZZzkT31IidSv1TPVIEiai4UTDFQ3DCB0bxIa95cBP7slIqDubuH8Ptas1sDG3LLe5uZptBEA/8kUt3UgQBoKUX/p/Hm56mtR1+edM1JBCcG1yHmdX0uYncHjw44PSSz6B14UpTpEQmTZqrE+vSFEwfQ9jvajVa24S7R4u63yBoPX9TeVBg/OuYvtMe+RUs+cBw1K0Si5ZL3pbJ/rCWlfqdl5OB7nAi/k+onk4R5o9I8Bs6bU0A8O5+eom30WSpnGnKVDysnuIIcbw2CY7ZxQRm8s33iZxc8GO8Ye3CMyTGHBT1uWGeAH/1/5bVxEw5ffy29Qv78+dlrG2yHXjxEIlvi4J8Hkmsr/39o14CMkG19Wkc0j0uLUpEvnsyS8BlpGJRQ3XbUkkKn90ZXvAlDvF5QybHO3kCRhxIHJTw4O/zUfVDiZ8O38r4wJgQssU3ap72nXpQI1DrVZcw024Tnmq45r1XKFe373DLdA6AIgzjMk1+h/pKOA1USmLk4CAhdI9Huqq7Kd9ZlXba05VWL6IdKShWmIuMbvkH0+D+WV0o3EFRwfuc/uKC+bh1ND0ANpDyG3yIDALJj3tsZ8p0k85ZpxyAkbqdO2I1emPocWNBjDFHUBSYVHEs6ihmXgfwV643+VHn4MxRZBwlZfxsneuBhBLJXrR/BbpbcsMZe1kTPGpF94QZlmr1e5iL1GmfEZxnAeGmTS+xVIuXvGmGPclhgZVXc67NSo7nRtGBw2Zl3P2lrC4fL
 KPnatW0b
 e/Kcwyuj+7uIF4cPbYx6yM30gfFzC+gROT5GMwRVavCl8S7r+Jk3iFrKHYLJyDeot45VLzI3wXF8aKUJ47lAnotNIUZlrrPtSPxhnXFtZv1gKIWJ7a7uQny6l+U0tKeybE2AIDZrOQ3Zi0thF9CjwHeY1YdQskeZmxjpqbtVEz0On/CSAGhv9OjzK45XaEAYQELuWVbhHSHp/LKOJrA5BMv/2CN5qpTRSvmRP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lain \"Fearyncess\" Yang" <fearyncess@aosc.io>

LoongArch supports ARCH_HAS_SET_DIRECT_MAP, therefore wire up the
memfd_secret system call, which depends on it.

Signed-off-by: Lain "Fearyncess" Yang <fearyncess@aosc.io>
---
 arch/loongarch/include/asm/unistd.h     | 1 +
 arch/loongarch/kernel/Makefile.syscalls | 6 +++---
 tools/testing/selftests/mm/Makefile     | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/unistd.h b/arch/loongarch/include/asm/unistd.h
index e2c0f3d86c7bd..e7649c1582482 100644
--- a/arch/loongarch/include/asm/unistd.h
+++ b/arch/loongarch/include/asm/unistd.h
@@ -10,5 +10,6 @@
 
 #define __ARCH_WANT_NEW_STAT
 #define __ARCH_WANT_SYS_CLONE
+#define __ARCH_WANT_MEMFD_SECRET
 
 #define NR_syscalls (__NR_syscalls)
diff --git a/arch/loongarch/kernel/Makefile.syscalls b/arch/loongarch/kernel/Makefile.syscalls
index cd46c2b69c7fd..6360381baf931 100644
--- a/arch/loongarch/kernel/Makefile.syscalls
+++ b/arch/loongarch/kernel/Makefile.syscalls
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
 
-# No special ABIs on loongarch so far
-syscall_abis_32 +=
-syscall_abis_64 +=
+# Add memfd_secret explictly for la64 and la32
+syscall_abis_32 += memfd_secret
+syscall_abis_64 += memfd_secret
diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index eaf9312097f7b..79582438efc4d 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -72,7 +72,7 @@ TEST_GEN_FILES += madv_populate
 TEST_GEN_FILES += map_fixed_noreplace
 TEST_GEN_FILES += map_hugetlb
 TEST_GEN_FILES += map_populate
-ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64))
+ifneq (,$(filter $(ARCH),arm64 riscv riscv64 x86 x86_64 loongarch32 loongarch64))
 TEST_GEN_FILES += memfd_secret
 endif
 TEST_GEN_FILES += migration
-- 
2.52.0


