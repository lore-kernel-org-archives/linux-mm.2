Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC971606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 00:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OIx38B1u
Received: by kanga.kvack.org (Postfix)
	id A4EB66B05B3; Fri, 20 Nov 2026 19:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1486B05B4; Fri, 20 Nov 2026 19:09:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89FD86B05B5; Fri, 20 Nov 2026 19:09:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA0E6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:09:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3690A0270
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:10 +0000 (UTC)
X-FDA: 85457191260.14.5BA473E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0EDECC0009
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:09:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIx38B1u;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795219749;
	b=4wQMraTwnDOCO9GlJSan6OUUwrHuDemxtovTB9VRS+DWtgIU2P/UAonZMtcN9dc72zufZ1
	Wcdbs5HGGX2ntVDWlF/RNd7PVuAHiYr/vX39yz4C+3ZE8nbGX7naMUHAW2yIyUYoy+tEyn
	LLFIGpEJ0bYZctz+pK09WLDJSmOKBLo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795219749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdMFQd5iWnE0etuNgaG+P1V3IRtO+2edlHDd0w1oiXI=;
	b=oU5EtAJ91ncg3eBMLWrM3RMt3XB7cqFYr92eut3uBnil1XeeaQBxvdW55gd7ELvATIR9sF
	zPWUJekhemCSWGY/0WSKxP58CyMLey1oXyG24zD937cByuA/kXIbkMLf3n2nAC6ZCW1sAQ
	cMmheP3g69tx8SGaZXHx8auW+DlxUo4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OIx38B1u;
	spf=pass (imf10.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id D89BB44219;
	Sat, 21 Nov 2026 00:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 35F191F000C6;
	Sat, 21 Nov 2026 00:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795219747;
	bh=xdMFQd5iWnE0etuNgaG+P1V3IRtO+2edlHDd0w1oiXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OIx38B1u3nJnanXh/hKXPskEKfSxQGZ8uO6Ie5n7ZxFtDVKyfnWoZ2ygDZt0krBMn
	 Eb6WU2mgP3mRzYddEvT/UfzihFtsZQDmPQZM20BNgroAvtd5M8uhQZawsiACv24KkD
	 m/T7osBk+AjPsA3WKfhe2eW82P7pqjW9AIXjhU4Q8vrhXLr53dri75w9xjL783IGV5
	 ptVzBO48eq+CcnchCH82rcsmNSeVP5q4CSSrG2HEPzRzWVBRYTMFbdt3cK5QMlHV2K
	 RgVdRbWc6+ARVMok7ImDzyr4yYRczYlNWV3Z8WmtjZTfnmYmR/tzBrAJqzN6U7dCkx
	 5O/btILf6z72g==
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
Subject: [RFC PATCH v5 03/25] arch: Wire up userns_set_idmap() system call
Date: Sat, 21 Nov 2026 02:08:22 +0200
Message-ID: <20261121000844.1863324-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121000844.1863324-1-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0EDECC0009
X-Stat-Signature: bjnufchi9zs1s6g3k5ur5kimp7ptemnx
X-Rspam-User:
X-HE-Tag: 1795219748-967727
X-HE-Meta: U2FsdGVkX1+ruvGg50sQBvbBmBioM2ilB58Hv6VGlnoD903UPKAZ37KFvh+yBAXVrVT47KxuS8hJgfO83lv5CZZ/tWU82xi8z7C3KQTGs17qe8Y2cpuIT6UQCc7MraR7RL/7sV7wIOVGBY7l7OlT3m1+ko1LMcOfhoeuvizF8pJOa1YGi3Vym6vQqzLSeAWg5awoxBJl6H+tJ9oYYjL6zLy8AeyNjLgqOLxy5dT4FJJeKzpvPzcJC7hXomqo32CYlvLmgVw84x8rj7+Kz/ZzGV56RhAj1l06dY5WGihTmGrSW5wr0GweGT52ypmBIH6cHfP/UgbHTzmu6j3UeowQrK74nuN5O9ZyRMUD5CBZbGVMvJVPzMNqrDIYAxK7YkftqQVVQe//vvLP9fzA9tqyKkxY07fDjC/W8m/9reEkuPSC35/yiJl/Z01qgEaIUcDcFiG1Kt+ggh+rvhbPoXf8sKN7O1B/SL4JzAlUbcC3mBVUjZhENqwCuEMk1dwHCGH0qJ0XGPienHZnfJYvLfk2wHOzpw1igQUmlzamO1uRLaAAW2esamEmz1YdPMvuho7PTIBMvP4oisccH3D34B0xyDJ1oK3kgqyFdrqrf9zgpeLIR/nnW456T8E8+krUdbIUTP1/Bqak8B9425cItLNpa0Q58SXPJkwxEK5631IeOn3KJXg+FcVHLfGDTwfDYUd3czA1vnAf4J1ZsZENsLXaOYlMLBX1a9/7/eDrbbeHg3/4bY+ustmUo16CZXrWXD6uin/yeFc0owAQoviAc7bbxel9jrl03Y/qOkMI5BOYWxNDNjiy5zpDFYk03IwDSEUPzIL1H99Y/DW9DHstgT6czlg5qsMpDRb9NjdRF5VZTYltPJBf7yMwiCM2YHJBoaJRdeECGupxV5X32Mal7SIs88c1LTZlcWE/ZLEHDMBi9rOtDugzELDqV59zKqRsou0fyStATonHGfq8Q7yH9Dl
 bdcxkwaa
 FA2/WhquZUcDDy3i85DWx9Bntj+i/Csl1yeno5AYPR8aOg9rzOa2Ia8Je3GFUey5T16aZkV3lVXN93M8o1MHvuI/ZfvNom/DNOEu3fQpB5gZxrCVyGaTTYkVfiybblwl4MggJ6V8KvNIWsN1WUOvQIqG6U0aeMQ/Q0W+rnOO7A83jBmYOgDyN5uG0hQOzm5tDU69pt5I/Rpb0fhaMviS44utEnXQwOhFBKIRe2SyDCPXfYUyjtCPwgDQRHoAGGtMDdPdntHLGNVxmU9VFPqGT0F6nVbOY4X9KxSmGuBAyG95OQKv9oGKOUXkXDzdW05nfQbVXBkzQCiazw5t0/fT5rK36Uvy0RI6dA5EoZ8LYX667ChRpA6S4xY0zTp5C88GnHIZKruCDu8/jDaJW7eXerG3WJNWj7zFFS9rx2vQLyuFKsi8H01XicN9XzYHS9JtW7brH2lEsDUsqx1OZ287XShvPLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Expose userns_set_idmap() (473, 583 on Alpha) across all architecture
system call tables and asm-generic unistd.h.

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
index 52e3538cc7df..9384d59a44dc 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,4 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..6130366b7681 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..3fcc7899fd08 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..5607635bd4bd 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..97ee93f42fac 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..da4ed57a91d3 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,4 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..5e9839b6b389 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,4 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..290c1b61be47 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,4 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..fc0fa917eb92 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..d12e49022b23 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,4 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..dc427811d30d 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..e62ac9acc7ad 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..df074bf322c4 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..243a3f55834d 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,4 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	userns_set_idmap	sys_sys_userns_set_idmap
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..f11700e3af65 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,7 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	userns_set_idmap	sys_sys_userns_set_idmap
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..1d28de95915f 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..695eac2d356b 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,12 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/user_namespace.c */
+#define __NR_userns_set_idmap 473
+__SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 474
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..0dddd465d1c5 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,4 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	userns_set_idmap		sys_sys_userns_set_idmap
-- 
2.47.3


