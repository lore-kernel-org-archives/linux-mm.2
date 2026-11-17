Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBE0606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 05:09:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l4oeNBzI
Received: by kanga.kvack.org (Postfix)
	id 521746B05C5; Tue, 17 Nov 2026 00:09:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D21E6B05C7; Tue, 17 Nov 2026 00:09:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 399DC6B05C8; Tue, 17 Nov 2026 00:09:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 025006B05C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 00:09:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C2101602A7
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:30 +0000 (UTC)
X-FDA: 85443432900.06.DC4AE69
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id E2AE140006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 05:09:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4oeNBzI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794892169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qr4JFwG53XzED0ptwDX6mwXcUzulpjNzvDhvu01tYrY=;
	b=39djDyHeiB+xTsxlnHzBEx9yBqyeKCjTRsU9uR9HrEktKSQAEiudmQmwPUJKb+WrNAbsi0
	Gn2g1pf0N+bIOY0buSO9BgJF0y3+voVLr9lMXaAn8fWXOe3EST7jM6FrcTKPQ9lhqO8q8Q
	Ke1Qt8k1l7LWLCcvSpJQSU7BhJVmCEU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l4oeNBzI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794892169;
	b=7RdaT3npwsgetztK7K4BAxiAjcjkpye3oEgCAkHusEGTV60APBEuA3i9qqbUGuAulCUTW0
	VQKXejsrkoC8vEL1l9Qig6ylTSpqFMy3hxN/ZNwEYKHX6cDy2zk+R3rQa9LPOLE7MFZX+t
	lUta8h//aeCQOGDy48zvblIFbcFhfmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7676862738;
	Tue, 17 Nov 2026 05:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 984D41F000D4;
	Tue, 17 Nov 2026 05:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794892168;
	bh=qr4JFwG53XzED0ptwDX6mwXcUzulpjNzvDhvu01tYrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4oeNBzIZg/k0UEU2KET3uU2dgLdruZ9mzXzNOwTRTObem2IzGwdTzjfU0X6MN6uh
	 iU9vg0QxAeQUMfd/QbLcSE0pW7c9Y+1bvZ6Lcno0cthoWTW5Uvo0RqyNn8xQ0ItcMn
	 zZjeEN8hnhoFt0dsMlADj8u9XklzHyftVa+QGUfa3dtZhb1DeRCKPt6by+iMcqV6MB
	 IsaWRA38E6fC1vIik/lvrMQVqqij/LqVqS+XN5eZi7jAvXTioL4o6bpJkWOeMUvBeG
	 Ggu+6r8u+Y2v6GI4iLi+qF1aBWgL23g1Y/8bpEpDCh+yE6OWIwBxFdh6u0E+P56BSj
	 kwS3ODJ1hFuyQ==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
	linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
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
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [RFC PATCH 10/13] arch: Wire up rootns system calls
Date: Tue, 17 Nov 2026 07:08:38 +0200
Message-ID: <20261117050841.3289652-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117050841.3289652-1-jarkko@kernel.org>
References: <20261117050841.3289652-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: it9g9cm7dyquxm986p3aewuhq89dt5yg
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E2AE140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794892168-76244
X-HE-Meta: U2FsdGVkX19hhybkyoP/TRJT7EmMEjrVCcqp1E8NByrMZVnkdRRdhO6tq/mieT6OfNP7QeFexmkE6uvuYFiTr5/mRxDuk1EyXkxviO7Eze6n/SzdkVpaabjPeuy98K9JzYFAAxP/oESVzmm+9pfEPdVF80Xps89djfBjXYjsLgq/aHUZg83oggpM6EkXvRCVsanA/iqNFPJ7LachbZzVFhMIFf19HH6ucumP1f5voLJl0ApreTMM8MBu8uLIyt7h+4ZVR6lR9RE+NjTIYNWqXClBYG+uiMv5Ub0GUgWXFd3W3LXVaXhWoFuy8Ryh8iUh6j8GgO0ZdyJV0R+Th88Nfhia3lcTX7jr069eEkSz+1g/X6qrZgOk9pj8gdTaptU5xdgft679rLENBreUNcK3BfAeEcxQEHu/3t6iJem0/5+ChcBsyuUPLxGTYKEzaMD25X9H7oRnA2k+8SEkhGttDGyMQ1JOJYCFQErWRSPDBXHE7o0d220OXy0bfl/yMSILb3wbCMHZHFyLoks2TJDoIVxehmeCntfT06G3YkPWtkoHY5vOrbhKB8WGl86VpfzVBUUohjMlJguHfcWP41zlKfuhuywyc+4uwPG5ynHPQNNirTLLiFhhBioX2jq+iITDAfWaPq8a0yZOat7PH+WXNf5XT1xf2QEV4+Ubb8Kwzj3XxrKm+tzFFaCVPaHAjS9nrDGdsB8400/J+ptiABptrhjolxHga/nmzPG6o1bKmXNy7ZPbMC2MpWCgvT+7zxHU7zhh6fzNoGigUlgb0yzLHGo5p1NT0/JCf1XbDE8ZMgwWqe4S/9X2V+PAuS5mwJ+sGsKpZN2bGMCnWwGys7Yzg2VjciDBN6pRlWwq0VeE3mTi4inh1bto95NVxzs6mw4gLcLhJzx+c08bUVY3pJAJjQDseoTPBb+N1HW4tGgH0wh9RYccIEUKNwGJjA2RE0YwMzh7W6jVo8rITXkpBaD
 pCGn2zfD
 yy8YWoBqRSTh3l2xnvjB/o2vy5tTjETi8vkv+Jw5eKOB8a+Xj2B4qx4E/tCurPqYkiXN1kiOYATM/m5BM1hRsSH7FIY0UXHHYPmqwBebBU16phsZMhTuwyurhubU9j/TXjzS5WmTvjdPnhzog2dcCnG4X3KdLaIZvcn+VnzQA3anZYQaS0HRRXl5BB/a9MqFH/MwCi3kCV4Y2OOha3CcSGJTGrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that the core root namespace lifecycle and VFS mount-tree
installation are in place, expose rootns_create() (473), rootns_wait()
(474), rootns_kill() (475), and rootns_enter() (476) across all
architecture system call tables and asm-generic unistd.h.

Co-developed-by: David Howells <dhowells@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/alpha/kernel/syscalls/syscall.tbl      |  4 ++++
 arch/arm/tools/syscall.tbl                  |  4 ++++
 arch/arm64/tools/syscall_32.tbl             |  4 ++++
 arch/m68k/kernel/syscalls/syscall.tbl       |  4 ++++
 arch/microblaze/kernel/syscalls/syscall.tbl |  4 ++++
 arch/mips/kernel/syscalls/syscall_n32.tbl   |  4 ++++
 arch/mips/kernel/syscalls/syscall_n64.tbl   |  4 ++++
 arch/mips/kernel/syscalls/syscall_o32.tbl   |  4 ++++
 arch/parisc/kernel/syscalls/syscall.tbl     |  4 ++++
 arch/powerpc/kernel/syscalls/syscall.tbl    |  4 ++++
 arch/s390/kernel/syscalls/syscall.tbl       |  4 ++++
 arch/sh/kernel/syscalls/syscall.tbl         |  4 ++++
 arch/sparc/kernel/syscalls/syscall.tbl      |  4 ++++
 arch/x86/entry/syscalls/syscall_32.tbl      |  4 ++++
 arch/x86/entry/syscalls/syscall_64.tbl      |  4 ++++
 arch/xtensa/kernel/syscalls/syscall.tbl     |  4 ++++
 include/uapi/asm-generic/unistd.h           | 12 +++++++++++-
 scripts/syscall.tbl                         |  4 ++++
 18 files changed, 79 insertions(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/syscalls/syscall.tbl b/arch/alpha/kernel/syscalls/syscall.tbl
index 52e3538cc7df..a945b15abe6d 100644
--- a/arch/alpha/kernel/syscalls/syscall.tbl
+++ b/arch/alpha/kernel/syscalls/syscall.tbl
@@ -512,3 +512,7 @@
 580	common	listns				sys_listns
 581	common	rseq_slice_yield		sys_rseq_slice_yield
 582	common	fchroot				sys_fchroot
+583	common	rootns_create			sys_rootns_create
+584	common	rootns_wait			sys_rootns_wait
+585	common	rootns_kill			sys_rootns_kill
+586	common	rootns_enter			sys_rootns_enter
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index 55717ed32c27..a6df8f688a03 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -487,3 +487,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/arm64/tools/syscall_32.tbl b/arch/arm64/tools/syscall_32.tbl
index df2d1d82fb3c..0fee3f3a6f18 100644
--- a/arch/arm64/tools/syscall_32.tbl
+++ b/arch/arm64/tools/syscall_32.tbl
@@ -484,3 +484,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait		compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/m68k/kernel/syscalls/syscall.tbl b/arch/m68k/kernel/syscalls/syscall.tbl
index ba7a4d8903d0..db99316451d5 100644
--- a/arch/m68k/kernel/syscalls/syscall.tbl
+++ b/arch/m68k/kernel/syscalls/syscall.tbl
@@ -472,3 +472,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/microblaze/kernel/syscalls/syscall.tbl b/arch/microblaze/kernel/syscalls/syscall.tbl
index 76d7cbe2a133..fdd26eb61173 100644
--- a/arch/microblaze/kernel/syscalls/syscall.tbl
+++ b/arch/microblaze/kernel/syscalls/syscall.tbl
@@ -478,3 +478,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_n32.tbl b/arch/mips/kernel/syscalls/syscall_n32.tbl
index 9ae88e4eac61..3a81da7abd44 100644
--- a/arch/mips/kernel/syscalls/syscall_n32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n32.tbl
@@ -411,3 +411,7 @@
 470	n32	listns				sys_listns
 471	n32	rseq_slice_yield		sys_rseq_slice_yield
 472	n32	fchroot				sys_fchroot
+473	n32	rootns_create			sys_rootns_create
+474	n32	rootns_wait			compat_sys_rootns_wait
+475	n32	rootns_kill			sys_rootns_kill
+476	n32	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_n64.tbl b/arch/mips/kernel/syscalls/syscall_n64.tbl
index 83dc93a0712f..2c38f050d14e 100644
--- a/arch/mips/kernel/syscalls/syscall_n64.tbl
+++ b/arch/mips/kernel/syscalls/syscall_n64.tbl
@@ -387,3 +387,7 @@
 470	n64	listns				sys_listns
 471	n64	rseq_slice_yield		sys_rseq_slice_yield
 472	n64	fchroot				sys_fchroot
+473	n64	rootns_create			sys_rootns_create
+474	n64	rootns_wait			sys_rootns_wait
+475	n64	rootns_kill			sys_rootns_kill
+476	n64	rootns_enter			sys_rootns_enter
diff --git a/arch/mips/kernel/syscalls/syscall_o32.tbl b/arch/mips/kernel/syscalls/syscall_o32.tbl
index 9c62429c9b7b..3f0344992c20 100644
--- a/arch/mips/kernel/syscalls/syscall_o32.tbl
+++ b/arch/mips/kernel/syscalls/syscall_o32.tbl
@@ -460,3 +460,7 @@
 470	o32	listns				sys_listns
 471	o32	rseq_slice_yield		sys_rseq_slice_yield
 472	o32	fchroot				sys_fchroot
+473	o32	rootns_create			sys_rootns_create
+474	o32	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	o32	rootns_kill			sys_rootns_kill
+476	o32	rootns_enter			sys_rootns_enter
diff --git a/arch/parisc/kernel/syscalls/syscall.tbl b/arch/parisc/kernel/syscalls/syscall.tbl
index 88adc4016cce..1f3d051a9c56 100644
--- a/arch/parisc/kernel/syscalls/syscall.tbl
+++ b/arch/parisc/kernel/syscalls/syscall.tbl
@@ -471,3 +471,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/powerpc/kernel/syscalls/syscall.tbl b/arch/powerpc/kernel/syscalls/syscall.tbl
index cfbb70039ff0..610ceedd1a14 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,7 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/s390/kernel/syscalls/syscall.tbl b/arch/s390/kernel/syscalls/syscall.tbl
index 1b45e68a217b..e9c7021a07e1 100644
--- a/arch/s390/kernel/syscalls/syscall.tbl
+++ b/arch/s390/kernel/syscalls/syscall.tbl
@@ -399,3 +399,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/sh/kernel/syscalls/syscall.tbl b/arch/sh/kernel/syscalls/syscall.tbl
index ace068dff0de..c122ee2d7cd2 100644
--- a/arch/sh/kernel/syscalls/syscall.tbl
+++ b/arch/sh/kernel/syscalls/syscall.tbl
@@ -476,3 +476,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/sparc/kernel/syscalls/syscall.tbl b/arch/sparc/kernel/syscalls/syscall.tbl
index 5b9fe0e8140f..e7cfd43d616a 100644
--- a/arch/sparc/kernel/syscalls/syscall.tbl
+++ b/arch/sparc/kernel/syscalls/syscall.tbl
@@ -518,3 +518,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 2c172ef48dfd..c444d59d0267 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -478,3 +478,7 @@
 470	i386	listns			sys_listns
 471	i386	rseq_slice_yield	sys_rseq_slice_yield
 472	i386	fchroot			sys_fchroot
+473	i386	rootns_create		sys_rootns_create
+474	i386	rootns_wait		sys_rootns_wait		compat_sys_rootns_wait
+475	i386	rootns_kill		sys_rootns_kill
+476	i386	rootns_enter		sys_rootns_enter
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index d5b6045b0090..f331f1ddc330 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -397,6 +397,10 @@
 470	common	listns			sys_listns
 471	common	rseq_slice_yield	sys_rseq_slice_yield
 472	common	fchroot			sys_fchroot
+473	common	rootns_create		sys_rootns_create
+474	common	rootns_wait		sys_rootns_wait
+475	common	rootns_kill		sys_rootns_kill
+476	common	rootns_enter		sys_rootns_enter
 
 #
 # Due to a historical design error, certain syscalls are numbered differently
diff --git a/arch/xtensa/kernel/syscalls/syscall.tbl b/arch/xtensa/kernel/syscalls/syscall.tbl
index d354bb231796..7482743ea9b4 100644
--- a/arch/xtensa/kernel/syscalls/syscall.tbl
+++ b/arch/xtensa/kernel/syscalls/syscall.tbl
@@ -443,3 +443,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 5b7e77a7c736..2595346d3aac 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -867,8 +867,18 @@ __SYSCALL(__NR_rseq_slice_yield, sys_rseq_slice_yield)
 #define __NR_fchroot 472
 __SYSCALL(__NR_fchroot, sys_fchroot)
 
+/* kernel/rootns.c */
+#define __NR_rootns_create 473
+__SYSCALL(__NR_rootns_create, sys_rootns_create)
+#define __NR_rootns_wait 474
+__SC_COMP(__NR_rootns_wait, sys_rootns_wait, compat_sys_rootns_wait)
+#define __NR_rootns_kill 475
+__SYSCALL(__NR_rootns_kill, sys_rootns_kill)
+#define __NR_rootns_enter 476
+__SYSCALL(__NR_rootns_enter, sys_rootns_enter)
+
 #undef __NR_syscalls
-#define __NR_syscalls 473
+#define __NR_syscalls 477
 
 /*
  * 32 bit systems traditionally used different
diff --git a/scripts/syscall.tbl b/scripts/syscall.tbl
index 0ab531605120..f0e6d70b5260 100644
--- a/scripts/syscall.tbl
+++ b/scripts/syscall.tbl
@@ -413,3 +413,7 @@
 470	common	listns				sys_listns
 471	common	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
+476	common	rootns_enter			sys_rootns_enter
-- 
2.47.3


