Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD65960A5BC8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CSP8/SLw
Received: by kanga.kvack.org (Postfix)
	id D07DB6B05D6; Sat, 21 Nov 2026 20:19:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7E36B05D7; Sat, 21 Nov 2026 20:19:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F436B05D8; Sat, 21 Nov 2026 20:19:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83FB56B05D6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:19:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BAE4A8220
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:51 +0000 (UTC)
X-FDA: 85460998182.13.216D709
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 79AA140005
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:19:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CSP8/SLw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795310389;
	b=bXpc1b43pUK8C4tLQf/+FtDTy/IxaeoHjyBn8hz3+7r6QsRyZlB51C0wIo86EX7f9uagY2
	6ktyNfU8n2dPaBfLBSgIVUA7NE15RA+26NQWWAKx6svfi8E03wjWh71soAd01YGP4nQQ6w
	XNGCG1e3+aZfEXn12bImwJfzz5RcS3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795310389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PRa/Z4N97Xs3mX/qNh7M9bbsE39tiqxbHLlAZExaAw8=;
	b=b1Z4/0tewHsSHRFNNeOFBMGaheOZeo8WqQU8RJiJKdQ+EFynctrQ8FOwpkh16UgASOzQEs
	hG6drlHM9KFv+08EuW0hfzniTGavB0Y/xmXcTqIAWLm5cNUAaTlX1Xv1K5kykAs/aCWYeY
	Bq10Cq4C3i63ajQLqDQUPueLlI0snuc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CSP8/SLw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id EBA8761B79;
	Sun, 22 Nov 2026 01:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EECF01F000E0;
	Sun, 22 Nov 2026 01:19:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795310388;
	bh=PRa/Z4N97Xs3mX/qNh7M9bbsE39tiqxbHLlAZExaAw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSP8/SLw0/pvy7YCDF4gSY+Ry/Hi7tWxmcKW+8hYOQqeYmZcXY1yLmYZKmuKkO9KS
	 5F0EK6LsGG8iEIUnYtG2AkvPjTo7CHHIwYADZYOHoZAYnxww2tq7HRbytgtabF3c8C
	 M6eFafM0n3PyUz1IUz7GDweh4oMgAlhSa1dRxocqBGGq429ZS6MeVx89BWHD1EHWfQ
	 qRaQr7DhxfiY6oPhASWGARcZqcf83Qztql3o8hQz/GTK2erRIMXT096Iw7y1gmLRAC
	 gX3+ltTezUb8qawkLbu+z5nlSkv3VHSAPaVv6mBLKxwv/hlQ4Cb2yh5DgIU9l+9pQp
	 m9GkI1up2vC3Q==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	bpf@vger.kernel.org,
	containers@lists.linux.dev,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>,
	Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v6 23/26] arch: Wire up userland_open() system call
Date: Sun, 22 Nov 2026 03:18:06 +0200
Message-ID: <20261122011809.2667684-24-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261122011809.2667684-1-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 79AA140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1orq51nkess8r8tnj9izo6cqh7yxerth
X-Rspam-User:
X-HE-Tag: 1795310389-48208
X-HE-Meta: U2FsdGVkX19ipE3f3vnK79n9rbH9TDK9NzuNgcAbUJzYUsEwvUpGVZkZAtky/h7FQ91ixeuEocSImplc0MVOQG8BAPznryVG5/wTNbwKVcuXGIo4DjKuLsIOEmu/R3FDxWOMM8w9bz4YWMtcYy2AZd2MVCgIIv5m38FoyV1jSqCo/5ds4ZHy6wAQX636TqKgl8V0kJnwL/QkRC3J4X/U1HXAOv4+264nnYn5Nm+WOUhxe2ROmW+eDUBitlMoQuwj2WQ5qroh3Rlq12rDCuaeoY+ZbSuD3HUcOYJ2IeJHYIyflGdsm1b/yc4ldVUUYUzBPk1iCWwIOxKM6tBdwW3pv+qag+skdRzAVWmAAx3OxiE9S7hAfPaTyha21txfX6qkwhM7cofoJoTtUdQjnQlTQkiarctjgjQeoNI68NuewOv2VxOL9cKjgjwPxOVYoQroB1wiraXHCGs3kHj1nGW1IxGQTII8LeBaVcWJJzFdc4YIzwAM7R7GgO2m/BrTV7XSNxW4MUUX2ueZx0u94r48st1Jp2u+1Jd0ts26ns2ZgFTe62rZRv1jAF6lxV/ZMca/nxiNgWwNCQgXrbFLd+lqdmfUB1FlMbjzwK5bAc6z6qKMyQJILyf3OqyM1dvr8l6CIdhfVge0Ijmq0kEW2RyKk7e0aXMfnt7ACUw/TimEkQbHpBJuoGyihrgOy3Kv3rNodefniFPUK4AsJuJKnqgh2uMcYYnhwm6jdPA0ErlZivyA8/q5Xrrq5iWO8zhiPLiMJszj07Z1EnUXJ+XwxZV5vCzntr/MaZoQQ3B5IDwq3Ek0vprpa6di1KGR7jUrqqlmYCk1Cv+PRXozb8ck6xcwMMMMTgDONWzANsgWblLU+uFzbhuCPrvbBxPrA09SbnMIWH3rc+crQpYp+lvW4gSRtKma7UKQNQMDkHKC5t8Syfn5m4R8jYAi5VwVGi8A6JvAs0IOdrlSe8P/PKmvfX8
 a36oOzed
 WSsMBRNWHcHbviOvWMScPd2r55FQ3npHLthW0+HlK6wjWP3l2oFIBrDl28aDC/ryuIdpNJwZ7TSownjlBad4wXBlMkXg7itfmLwgwc4zPZid1fqiSDfkwv/wgHRCWRWjgZKtM6rLrnhqLFA9jhN16zm2Dqm7dVCqe81QaG6fDIKTOpS9J5ve2jQSC0gCiZxlpHC/fbs3y+KQdGG339CJaIicsC9bfyNx3Nxd6V6hA4vUCCyE3EBd4Vy585ZrnuF0+5UKiGSfAMadoV91GgdnXjP8jrzinG+2gvZJLbWwy9eghXIqI6UMbErB+0KnWEPKeiyIcPi7u4RgkYDZED6FIjLeFv53C03xMZnUusJ8hcZeewkZqGjpG1Cs3s/kw2lwheN0QZR40yFF+zMrR1WVl6+QyyGEH/wpMTCtI8NndhzBsdm3Fb7/5uSHHIhHAV0nV9y03QTf1/zw3R2TtGA2nAqbRInJu8k41r+uC1z+kZk/EFDw3+3PJSPntnQcsMGsiiQyjmRsqtDZB616YFQWg81Llbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that userland lifecycle and VFS mount-tree installation are in
place, expose userland_open() (474, 584 on Alpha) across all
architecture system call tables, asm-generic unistd.h, and the mirrored
copies under tools/.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl              | 1 +
 arch/arm/tools/syscall.tbl                          | 1 +
 arch/arm64/tools/syscall_32.tbl                     | 1 +
 arch/m68k/kernel/syscalls/syscall.tbl               | 1 +
 arch/microblaze/kernel/syscalls/syscall.tbl         | 1 +
 arch/mips/kernel/syscalls/syscall_n32.tbl           | 1 +
 arch/mips/kernel/syscalls/syscall_n64.tbl           | 1 +
 arch/mips/kernel/syscalls/syscall_o32.tbl           | 1 +
 arch/parisc/kernel/syscalls/syscall.tbl             | 1 +
 arch/powerpc/kernel/syscalls/syscall.tbl            | 1 +
 arch/s390/kernel/syscalls/syscall.tbl               | 1 +
 arch/sh/kernel/syscalls/syscall.tbl                 | 1 +
 arch/sparc/kernel/syscalls/syscall.tbl              | 1 +
 arch/x86/entry/syscalls/syscall_32.tbl              | 1 +
 arch/x86/entry/syscalls/syscall_64.tbl              | 1 +
 arch/xtensa/kernel/syscalls/syscall.tbl             | 1 +
 include/uapi/asm-generic/unistd.h                   | 6 +++++-
 scripts/syscall.tbl                                 | 1 +
 tools/include/uapi/asm-generic/unistd.h             | 6 +++++-
 tools/perf/arch/arm/entry/syscalls/syscall.tbl      | 1 +
 tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl | 1 +
 tools/perf/arch/powerpc/entry/syscalls/syscall.tbl  | 1 +
 tools/perf/arch/s390/entry/syscalls/syscall.tbl     | 1 +
 tools/perf/arch/sh/entry/syscalls/syscall.tbl       | 1 +
 tools/perf/arch/sparc/entry/syscalls/syscall.tbl    | 1 +
 tools/perf/arch/x86/entry/syscalls/syscall_32.tbl   | 1 +
 tools/perf/arch/x86/entry/syscalls/syscall_64.tbl   | 1 +
 tools/perf/arch/xtensa/entry/syscalls/syscall.tbl   | 1 +
 tools/scripts/syscall.tbl                           | 1 +
 29 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 60d330a51476..2d66a28b610d 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -513,3 +513,4 @@
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
 583	common	userns_set_idmap		sys_userns_set_idmap
+584	common	userland_open			sys_userland_open
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index d055515e98cd..4d2608f907de 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index a18982ead3bf..2f3e7a4686bf 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -485,3 +485,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index e89ec7d54b8c..ad1b3326c478 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -473,3 +473,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 0dfcd6f9e4e7..4a9f4e1e7e31 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -479,3 +479,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 882ff15f3e6d..7483d569dcb0 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -412,3 +412,4 @@
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
 473	n32	userns_set_idmap		sys_userns_set_idmap
+474	n32	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index daa95049baef..fe5c3ab9ffa7 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_userns_set_idmap
+474	n64	userland_open			sys_userland_open
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9e0040399fef..233e0b6850ae 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -461,3 +461,4 @@
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
 473	o32	userns_set_idmap		sys_userns_set_idmap
+474	o32	userland_open			sys_userland_open
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index b77482e68d1a..7c251ea35d4c 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -472,3 +472,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index 973562f20a94..b07ab66144b5 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	nospu	userns_set_idmap		sys_userns_set_idmap
+474	nospu	userland_open			sys_userland_open
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 19d7b234b31b..4daa1f92e171 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index 252e6f9aa04c..df51ac4faaf4 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 1263d0e825c1..3db2b5a99b1f 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 0f8c81c584e0..68e3e01c8751 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_userns_set_idmap
+474	i386	userland_open		sys_userland_open
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 5452b7567bf8..f8ad4c72a86e 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_userns_set_idmap
+474	common	userland_open		sys_userland_open
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index f10b491c873c..b87586ff006c 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 695eac2d356b..201335a08837 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/userland.c */
+#define __NR_userland_open 474
+__SYSCALL(__NR_userland_open, sys_userland_open)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 7ba073cc0e80..c3d07ff911a7 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/include/uapi/asm-generic/unistd.h b/tools/include/uapi/asm-generic/unistd.h
index 695eac2d356b..201335a08837 100644
--- a/tools/include/uapi/asm-generic/unistd.h
+++ b/tools/include/uapi/asm-generic/unistd.h
@@ -871,8 +871,12 @@ __SYSCALL(__NR_fchroot, sys_fchroot)
 #define __NR_userns_set_idmap 473
 __SYSCALL(__NR_userns_set_idmap, sys_userns_set_idmap)
 
+/* kernel/userland.c */
+#define __NR_userland_open 474
+__SYSCALL(__NR_userland_open, sys_userland_open)
+
 #undef __NR_syscalls
-#define __NR_syscalls 474
+#define __NR_syscalls 475
 
 /*
  * 32 bit systems traditionally used different
diff --git a/tools/perf/arch/arm/entry/syscalls/syscall.tbl b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
index d055515e98cd..4d2608f907de 100644
--- a/tools/perf/arch/arm/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/arm/entry/syscalls/syscall.tbl
@@ -488,3 +488,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
index daa95049baef..fe5c3ab9ffa7 100644
--- a/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
+++ b/tools/perf/arch/mips/entry/syscalls/syscall_n64.tbl
@@ -388,3 +388,4 @@
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
 473	n64	userns_set_idmap		sys_userns_set_idmap
+474	n64	userland_open			sys_userland_open
diff --git a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
index 973562f20a94..b07ab66144b5 100644
--- a/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/powerpc/entry/syscalls/syscall.tbl
@@ -564,3 +564,4 @@
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	nospu	userns_set_idmap		sys_userns_set_idmap
+474	nospu	userland_open			sys_userland_open
diff --git a/tools/perf/arch/s390/entry/syscalls/syscall.tbl b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
index 19d7b234b31b..4daa1f92e171 100644
--- a/tools/perf/arch/s390/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/s390/entry/syscalls/syscall.tbl
@@ -400,3 +400,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/sh/entry/syscalls/syscall.tbl b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
index 252e6f9aa04c..df51ac4faaf4 100644
--- a/tools/perf/arch/sh/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sh/entry/syscalls/syscall.tbl
@@ -477,3 +477,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
index 1263d0e825c1..3db2b5a99b1f 100644
--- a/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/sparc/entry/syscalls/syscall.tbl
@@ -519,3 +519,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
index 0f8c81c584e0..68e3e01c8751 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_32.tbl
@@ -479,3 +479,4 @@
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
 473	i386	userns_set_idmap	sys_userns_set_idmap
+474	i386	userland_open		sys_userland_open
diff --git a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
index 5452b7567bf8..f8ad4c72a86e 100644
--- a/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/tools/perf/arch/x86/entry/syscalls/syscall_64.tbl
@@ -398,6 +398,7 @@
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
 473	common	userns_set_idmap	sys_userns_set_idmap
+474	common	userland_open		sys_userland_open
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
index f10b491c873c..b87586ff006c 100644
--- a/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
+++ b/tools/perf/arch/xtensa/entry/syscalls/syscall.tbl
@@ -444,3 +444,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
diff --git a/tools/scripts/syscall.tbl b/tools/scripts/syscall.tbl
index 7ba073cc0e80..c3d07ff911a7 100644
--- a/tools/scripts/syscall.tbl
+++ b/tools/scripts/syscall.tbl
@@ -414,3 +414,4 @@
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
 473	common	userns_set_idmap		sys_userns_set_idmap
+474	common	userland_open			sys_userland_open
-- 
2.47.3


