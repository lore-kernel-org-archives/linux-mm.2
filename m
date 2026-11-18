Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E70DC60A383D
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 19:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eDLBJCLq
Received: by kanga.kvack.org (Postfix)
	id 7CEC26B05C5; Wed, 18 Nov 2026 14:36:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5316B05C6; Wed, 18 Nov 2026 14:36:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66CCF6B05C7; Wed, 18 Nov 2026 14:36:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2661C6B05C5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:36:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C11F81A07DE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:30 +0000 (UTC)
X-FDA: 85449246540.29.03AEDD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1E2C81C0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:36:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDLBJCLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795030589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLySXlw2qkGSikQZcqQu4v/kKS57qhr6tNuPuE+peRQ=;
	b=CAeZDJz8dStjUZjPUOgaI52qM+2yj5SKI32Bgs0V0tOAWabmx7DrlC9j3I8gE/70FbAUUl
	EfNytrPRpI7dD1/mlYDaVoIhTvz35cx4XCEIXaO9B090FKk6KnGUjHKk2Ab/GMOz6c8I4Y
	2RcYoDLmXmozde5IEEN69bpNGt+3iok=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDLBJCLq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795030589;
	b=v072wH2hWcfDP8dR5dBKlCH/Z/rhdOlsWDaJreQZpzKh2xEggq+4KWuRcBHaVqCL7QfHBE
	7z5/twHFzHb6aiemE5req4RguCJedFCubfHqBcTJZT0poDIst3l6HOZsbRaKWuQ8lt5i8Y
	u2ZRTnafmL9oZodTD15uh+G3TtHF78A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 62E5C41855;
	Wed, 18 Nov 2026 19:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 97DDE1F000CE;
	Wed, 18 Nov 2026 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795030588;
	bh=RLySXlw2qkGSikQZcqQu4v/kKS57qhr6tNuPuE+peRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eDLBJCLqJZOJm6cw53EhFns4WkXQwt2jO2vrFHmGVWFB8SHeoqhP9ECawkioY/t43
	 FKoNMLI/B6NBAWq27Ycu6C8uQD3kiiOnDjUxmkSS1GUMVLwwxuhuqhlYOMct7uBjqu
	 J+PiTUrI6SYxSVQm+0g9xFfXZNSnzIaPi4898N8NSO51faXl9cYNpYgTi0NIH/emdp
	 eUJJX5wY7Nn2jqixOtSicGV+7Be+BgNjxsuDoMFGG6genRuaHNr3vgJsIedtMfk/AB
	 XT+9ODK9nizQ7zek5NC/2fVsdcAWB05Igm7aA1iCC46D6v3Bfw8kU5d8/BplUluMYM
	 fnyVoc2NpEeyw==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	John Johansen <john.johansen@canonical.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v3 10/13] arch: Wire up rootns system calls
Date: Wed, 18 Nov 2026 21:35:36 +0200
Message-ID: <20261118193539.240065-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118193539.240065-1-jarkko@kernel.org>
References: <20261118193539.240065-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1E2C81C0003
X-Rspam-User: 
X-Stat-Signature: rubqzdca5fxm78oz3bmy7une1grtygp3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795030588-257961
X-HE-Meta: U2FsdGVkX1+qBBXo8Stgwmg6i4zQRwj0nc7XMa0qbe243nPiS2/9dGagRT5DXtcs6CwVJklUSDoY6ELQa0LaEzs25gNg048yB3OBQx4oAaVKVi/ADnyScwhJGioRDQ3wbkXW6BVB4ioT0HLOfkESAjc4YKD5Lw1A0Nn0nTv2Msr1lXVNrSRSO6fy4+cy2THQP2OsziqzDa6hV88WBYOzvwWr6pm+lHsHGg0el/vkpFt710pJ7aj+ul8k83SpmAsK+AfzHJ1gG/eLqnK0QPNvaglGGB4Iapv9mhFcBpkeIZLFxvMIQdZSZ8VGGqunb2EuQEZ6eqPf4aHTz8YZmPuYWZ5ZQIdEkuAy/puUc/ncLT6EWXisEFbNoT1mavZZQ7h0gMjYVwfBB5tL8wgUVAYSDoF8PwDAkbYaXDUQyeBpksiOylDVUbqsTy6zhFP4lP1e89KX0nnWg1iWWZKpFC7gTJkbnLYroGDRVU3aaLPCY2apBnjZPPKk/9Af2crXOlJu63BLkiiKoXeI5fvmyebT3aVrjIsOTHoC5vPWpMHb0bTtipwOMBSh3Mhewr0sh8Qwh+9k58ajBZ1iPAEOaDtmkJZiEtNNQhV8bJQ6TbHEBnemtwAagO7JqfiYRz9jKv2v/1wUxHiwxrOcHr4sVn6YqaqIz91CP3X/7qIIKruHGWqDrVbpckMtXtsl/r8t+uf916yjRXfGpE5TOMfmWBBX0RFKjiu0aE7qjaAVUZPFKBs2Cw9Z4zr5J+R2KxyY2tR8DfMX0PPxLABGqwMgCVGrxOJ6iSKNSX/O3BCbMpgOWM/QTrUCOKfF0eq98/CrbwV5/w0aLbOID+D0Ri1X/s8R0W+BCPOUASCtwvtxX1wr2RJGnw+6hxXOke0EJFBi56yLdAmXC7TT3y+67tmZo6BOte3Mya6uKYl30nCQ9u1OqffHbjyVAzLqdi/jVtLjXosU7V4pVtNJ4PVc+mx1NJl
 paYNV5ZC
 SrSC8DHXHiZwKNILkmviBxhDu0VsBWOdrCQ5p+jZLf6qy+HAdfn5GOBZK8+nhRhPYejnpEJxdqbgTooEfkV1iNTe6WgZ+feMTq+G0rftOKsR8v2xddiRL6aOAvf96vZUGY7OKFBDGLpupFe5esvi7ENBf4uUc151BPk/OPfDRvk3sKvJVy59CiVlDY+DhjXHCOqOBY9rHgF2XF6XzS9u8BRKbVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that the core root namespace lifecycle and VFS mount-tree
installation are in place, expose rootns_create() (473), rootns_wait()
(474), and rootns_kill() (475) across all architecture system call
tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      |  3 +++
 arch/arm/tools/syscall.tbl                  |  3 +++
 arch/arm64/tools/syscall_32.tbl             |  3 +++
 arch/m68k/kernel/syscalls/syscall.tbl       |  3 +++
 arch/microblaze/kernel/syscalls/syscall.tbl |  3 +++
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  3 +++
 arch/mips/kernel/syscalls/syscall_n64.tbl   |  3 +++
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  3 +++
 arch/parisc/kernel/syscalls/syscall.tbl     |  3 +++
 arch/powerpc/kernel/syscalls/syscall.tbl    |  3 +++
 arch/s390/kernel/syscalls/syscall.tbl       |  3 +++
 arch/sh/kernel/syscalls/syscall.tbl         |  3 +++
 arch/sparc/kernel/syscalls/syscall.tbl      |  3 +++
 arch/x86/entry/syscalls/syscall_32.tbl      |  3 +++
 arch/x86/entry/syscalls/syscall_64.tbl      |  3 +++
 arch/xtensa/kernel/syscalls/syscall.tbl     |  3 +++
 include/uapi/asm-generic/unistd.h           | 10 +++++++++-
 scripts/syscall.tbl                         |  3 +++
 18 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 52e3538cc7df..c7bec286deff 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,6 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	rootns_create			sys_rootns_create
+584	common	rootns_wait			sys_rootns_wait
+585	common	rootns_kill			sys_rootns_kill
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..59f78bf991c9 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..8ef57696c6a8 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait		compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..36eb16ae659f 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..54739d61a9ee 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..f0a58c6b4516 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,6 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	rootns_create			sys_rootns_create
+474	n32	rootns_wait			compat_sys_rootns_wait
+475	n32	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..c1d2774c6283 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,6 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	rootns_create			sys_rootns_create
+474	n64	rootns_wait			sys_rootns_wait
+475	n64	rootns_kill			sys_rootns_kill
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..99a753234dbf 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,6 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	rootns_create			sys_rootns_create
+474	o32	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	o32	rootns_kill			sys_rootns_kill
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..f3bac8085491 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..7ab1948f76b7 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,6 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	nospu	rootns_create			sys_rootns_create
+474	nospu	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	nospu	rootns_kill			sys_rootns_kill
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..7f8cd4147860 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..9bfcb96dcdeb 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..a847f4cbea3a 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..e49c96692038 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,6 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	rootns_create		sys_rootns_create
+474	i386	rootns_wait		sys_rootns_wait		compat_sys_rootns_wait
+475	i386	rootns_kill		sys_rootns_kill
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..d6f7fb7be172 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,9 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	rootns_create		sys_rootns_create
+474	common	rootns_wait		sys_rootns_wait
+475	common	rootns_kill		sys_rootns_kill
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..268c0d577788 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..571db09eb571 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,16 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/rootns.c */
+#define __NR_rootns_create 473
+__SYSCALL(__NR_rootns_create, sys_rootns_create)
+#define __NR_rootns_wait 474
+__SC_COMP(__NR_rootns_wait, sys_rootns_wait, compat_sys_rootns_wait)
+#define __NR_rootns_kill 475
+__SYSCALL(__NR_rootns_kill, sys_rootns_kill)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 476
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..e9ff99c03b2b 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,6 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
-- 
2.47.3


