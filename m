Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DAB16606C3F6
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i+I9pF8i
Received: by kanga.kvack.org (Postfix)
	id CE96A6B05D2; Fri, 20 Nov 2026 19:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99CE6B05D3; Fri, 20 Nov 2026 19:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3AEB6B05D4; Fri, 20 Nov 2026 19:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DEE76B05D2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:10:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DDB31C2FA6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:33 +0000 (UTC)
X-FDA: 85457194746.01.9B3BF30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 958D5140005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:10:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+I9pF8i;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219831;
	b=YseZM+l48Yga+LZiKNbXoUT9zHUooDojj7YefvlCS6pgytL0fiTj4hbcCebghgOFWSVg3y
	UYlwLHPRh4PBw3KXWluvdlNCq9yDr/4cvFs3xCOPDhxw9HsTxuBU+tB2IF2cgRxDFxJ1cm
	+PunjdcHSSQyIKvf/b4TZ0xC0ponWPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DViBjoiBEhcc+z9MHNo95Ypd4vzkhr9Bvmzcv5Vx5kY=;
	b=xxyYKG+J4f0yd2JdsTOyu1jKzhwCOgpBQwbEX6AK4Se5MVjiEmZvloha+Ka4ArxQbZ77I2
	6BymF8EpxGJdtMPok/7ZesccsoE9BetZ4xbf3AgExL6eyzOFMIblAeoC4mVAoxKgU6LlOz
	LaHcRR7f9npxAMTjDNxp7cDFwMDIj7I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i+I9pF8i;
	spf=pass (imf23.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 349CA622E0;
	Sat, 21 Nov 2026 00:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D6D951F000C6;
	Sat, 21 Nov 2026 00:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219830;
	bh=DViBjoiBEhcc+z9MHNo95Ypd4vzkhr9Bvmzcv5Vx5kY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i+I9pF8iXrTPLs7k7ojdz5xu+dk20AiZRB8zoRBdoJ1yck6+V4I9E4b1PZ5ZBNnhX
	 L3E3/eeOdilGdp6GFOTjsf1yymL44lHrzwJtHr0MT7QhjF6KgTpALHOTCFWLgR2ykj
	 utCL3x/GTFcnoOG8VByiGYYqw47HOZX3J5m3bPDtqPqwz1kA7eGZfSi3kgRd/scazS
	 9Ob4Y4vwzlYcrXXjgr4rXeuKVlL1hIw/3aiOMjEAGIakje6pkuABEci6260dQICe7d
	 zgnYbYzuNz6cXwmsb2t46gJZ4f0RnZlPXSTy1pMiWgGN6IqYpqB74+MsFHmhweqnDA
	 6E/5tjUSbz8Gg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v5 22/25] arch: Wire up rootns() system call
Date: Sat, 21 Nov 2026 02:08:41 +0200
Message-ID: <20261121000844.1863324-23-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 958D5140005
X-Stat-Signature: um4gzzzi36jw3dn6n56ck6o3asqprmgz
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795219831-806230
X-HE-Meta: U2FsdGVkX19Q6De73nNm95WhTq7aMCXOv+ZHRo4OECKt5+RfhPEOVuEk31JQTmMBJXeHMSP4ao3JV05AcQjyo1mWLi8eNlkqk6G2TS1uN31kdrOM1/yDmpPkDfnmEUr4WxBRvUOS+uR0tzalZ/whT5rNy4Kot3SLQzVYHJYeSBdlum9KNXlUbUu4v7xxQmoS3sY3xXSMxyvtFBheHwjy0/nL4B5JcChLmdovCUqLvNUayQkNekXjxAMb2A+Lw00K5El2EXxmduW2CLmgWRajag0L6hwL3+pPoPBhDYuTrRPlNNxmfjwBMTcO7tgmaXDIK8VjTEaqCxipOjkUMZWgQAZ7Z+eN4kyuz4Zyr1p6mLbprzl+Bxgaqbqr8y8rdQz4U+d8nK6AiJ9C0RuKjlA3xOIFYkzLMqatYRbn0knfpx7/rM01xAEWVVfIoDF88hwPTB7UKPTbtSsePe4ALgv9zvGUas4uFNNErYMpGeWVgvYv64rAkqKUZeLVtRQ56k2xWVRbvDYlb/2dkkjQYi96aBvW4pmVwbFe6WRsqjwrbHh/EqzbOzW9ogJWDQY0udCKO1qZYqzOHuPnKA574/S3NJkTXpHy6L/cHMD8y77K0MR5qkng9nhc0pCrbHFIVtTGGswr583PQBCaPabPVT65TWQpL8nE0nymDRKABz5S9Kl39ZSjoe298T9L0BJqVA9c+TQP3OeJb+yK6sq9DIGvmuFc3FY+R7ZBIjIVRKJxZfT28Lk2Bgq9cuEG+Fn3KOoFusX0W+RohH/iJPrhA2eq+LyQ6VR/HdqPUU6Y5Hiyr2HswqbGNdijo3uo0fewn8ipWYOysNDUgNvYuq5hTQnJ6X/ZHuLoUIeB1Dwo2e3QINt93Hwz7l7qq7enUFsKZcaIKtTbLmx1IaN5/U38l/8xE1pbZQ4IhUJVrZRI6qBkFu16mh7Eqy+BUWPZMRFXts1ShHa2wqzyy5c7AD5VKu3
 JDa7XjmI
 smYYAERyEbedDDyCuiPVtzfQ11Zgzijj5MwImLHm4GM9siFpSDj+piX9q3Ztwn4hLmWLPzD7dBZvmr76TcSxSG1FNwqyW1WqvTdIWQM8DWHKh7HgTGIGyC2ud+zVpIRq2w5youAqdaRH8yhpRU8vPFMR/wj/0zTsXZv9D/EkCU/h1gC7vXEGEZug8w/3XaYRXV6YaVLzNfdQ4Oq16GNUAuDHJWmk9bWk+jGQUqS/+MkcITZqRHb21+LXTZIlXvwdO7HC5Q6HjDnHFMPadolxIQ1AofN6KqD3W+fCf4aw20bl7Bh+xJKMnzJFL8C04jtAQp/zME0d/fepjfHFzJnI2r3MiM1rnUbw0LBlbtPsFggEifdO43rzIfrXgocJqFs2PZM+guFbPH5NfgH2geafVyrXKIkZAmEXB0p77sI42tc9J9FvTOnNNoHHSdAFw4rcwF30J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that the core root namespace lifecycle and VFS mount-tree
installation are in place, expose rootns() (474, 584 on Alpha) across
all architecture system call tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      | 1 +
 arch/arm/tools/syscall.tbl                  | 1 +
 arch/arm64/tools/syscall_32.tbl             | 1 +
 arch/m68k/kernel/syscalls/syscall.tbl       | 1 +
 arch/microblaze/kernel/syscalls/syscall.tbl | 1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl   | 1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl   | 1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl   | 1 +
 arch/parisc/kernel/syscalls/syscall.tbl     | 1 +
 arch/powerpc/kernel/syscalls/syscall.tbl    | 1 +
 arch/s390/kernel/syscalls/syscall.tbl       | 1 +
 arch/sh/kernel/syscalls/syscall.tbl         | 1 +
 arch/sparc/kernel/syscalls/syscall.tbl      | 1 +
 arch/x86/entry/syscalls/syscall_32.tbl      | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl      | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl     | 1 +
 include/uapi/asm-generic/unistd.h           | 6 +++++-
 scripts/syscall.tbl                         | 1 +
 18 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 9384d59a44dc..2087b83d6d2c 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -513,3 +513,4 @@
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
 583	common	userns_set_idmap		sys_sys_userns_set_idmap
+584	common	rootns				sys_sys_rootns
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 6130366b7681..93e609de0bad 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index 3fcc7899fd08..5dd5172b5118 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -485,3 +485,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index 5607635bd4bd..4fa5db7d1e62 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -473,3 +473,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 97ee93f42fac..5bfe96f7ec5c 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -479,3 +479,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index da4ed57a91d3..e664ef0d1e56 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -412,3 +412,4 @@
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
 473	n32	userns_set_idmap		sys_sys_userns_set_idmap
+474	n32	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 5e9839b6b389..725c0e5a5ab8 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_sys_userns_set_idmap
+474	n64	rootns				sys_sys_rootns
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 290c1b61be47..2c8472b83d23 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -461,3 +461,4 @@
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
 473	o32	userns_set_idmap		sys_sys_userns_set_idmap
+474	o32	rootns				sys_sys_rootns
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index fc0fa917eb92..0a32c40cfcbe 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index d12e49022b23..d2fd229b8da8 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	nospu	rootns				sys_sys_rootns
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index dc427811d30d..8251cad9530d 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index e62ac9acc7ad..13105c503bf6 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index df074bf322c4..7542448ab4eb 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 243a3f55834d..35cb517befbf 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_sys_userns_set_idmap
+474	i386	rootns			sys_sys_rootns
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f11700e3af65..387ca7628bae 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_sys_userns_set_idmap
+474	common	rootns			sys_sys_rootns
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index 1d28de95915f..f9869ffeeed1 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 695eac2d356b..726b39b6b47c 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/rootns.c */
+#define __NR_rootns 474
+__SYSCALL(__NR_rootns, sys_rootns)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0dddd465d1c5..1670f575d3e4 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_sys_userns_set_idmap
+474	common	rootns				sys_sys_rootns
-- 
2.47.3


