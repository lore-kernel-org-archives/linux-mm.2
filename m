Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40B0A606A33B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 23:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HfTmLOUV
Received: by kanga.kvack.org (Postfix)
	id 4A7816B05CB; Tue, 17 Nov 2026 18:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FE56B05CC; Tue, 17 Nov 2026 18:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8386B05CD; Tue, 17 Nov 2026 18:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F39A66B05CB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 18:14:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCBEB1405C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:51 +0000 (UTC)
X-FDA: 85446167982.24.9F0B163
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 41CD41C0006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:14:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HfTmLOUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794957290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rnhD6tF7xb3gXg3a7yMK93SFhcbPvgN7PjvYAJdpiHc=;
	b=NYIOl/e+vUmY12AS+yVgO2mmPIfPH+Ekl8J8pnNiR7Rofe70dpw7dZh/FOcf+zilkRrqpJ
	ihTRengMxpJdyyHL5ZwrPiCQfIuNi5PAiV8XlzyGXfBe43N/GoGWDXk57P6xWjv4ALuRRH
	LO3x+EwvxCMiPDxHx5LTtTec4mbk4MU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HfTmLOUV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794957290;
	b=261i6pv5p5PGq0RcItSeTOxKEehL9s3K55sniNuvDIvRMqG2Abl1V8cvBSR/MELao2xPzv
	fP7+WE/UKMxZ/wnsCheGo1D/84LUtAg325iigU7YOvF5XCADhfrt1px+vcDTSARS4UixEF
	hMZMxBUg0vfenmNO+5YiFGtkZkg5KQw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 894C3448CE;
	Tue, 17 Nov 2026 23:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BBD881F000C8;
	Tue, 17 Nov 2026 23:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794957289;
	bh=rnhD6tF7xb3gXg3a7yMK93SFhcbPvgN7PjvYAJdpiHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HfTmLOUVS6gLgxvFdZvNX8G2CAu5/WmQ0zzV9SMNDABd5r92r2e74OYGuADjFyQSX
	 c3c0txaes/2fL/dYmbzFCEYqxsz54RB71iVUkA4iVkOWgaGIG/d+QmPdMq6acb91Qg
	 BJzeUEKu1KgvKN7QH9LrE8RktByfg+XkDXpdBWzBf+semaIkzVcH/ecVszvu/KqiUe
	 uHmLfa7tOwCwWSn1XjCfsDweCekGO9WnaambZntx6taoia/sGx5in2Vtc0oOO5wBSt
	 lFTagVBrZwwdBfC5R34DQkSNaGNtoNcNA150K7sPGnYOcIUUbg17eUblGB6iTwBuI9
	 D2ADlX6CEMsvw==
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
	Andy Lutomirski <luto@amacapital.net>,
	Ben Segall <bsegall@google.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	John Johansen <john.johansen@canonical.com>,
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
	Vlastimil Babka <vbabka@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: [RFC PATCH v2 10/13] arch: Wire up rootns system calls
Date: Wed, 18 Nov 2026 01:13:49 +0200
Message-ID: <20261117231352.3816603-11-jarkko@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261117231352.3816603-1-jarkko@kernel.org>
References: <20261117231352.3816603-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 41CD41C0006
X-Stat-Signature: f54gs6aaue5rgu6t6rcwhtza37pewiw3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794957290-184181
X-HE-Meta: U2FsdGVkX19E7xQKsi8ciUqZKE6+0Xfa0US/bgNmQmAAF4ziaoqNw0cs0a1WPjA/a5VmEaLQijBChIvagUHPuQyazTCPC3svcbV2/v3nfCPzoU15pCWvIFrARu/CMQAod0Em/2EdoClX1dFdf2C/m9AqSOLfKFiWwQ/HGpKjFtzyuT7IajCp1gJSo37SFSYt2+qUn0eQFOKrx/SwaVU1/XOFgRaynzl3Nr3akeDBLzKVvcIzH3avdeiqNMSjl9Pu0nWSBZekWvIwRpW7kmjzesEj6mqLUI2kc7Lt8Q44oCJgwLG3kmpySnm5QstR4CCC/6W1ArtpzY8ExbKiJDrAPBomzyArgWwcV3ijxqVH2+87oCPaqTEABkSQegtN3paB9xArQ8ozlDMf8RMxRGPBGeMyCoXy1u3IjlSoH5apfnw3vPwCBK3/uKziv7kQF40LnI/RJH5kPBXb0veFrGZCX3tsR12p4hVil/jm6H8XYKUQ9HJjlL5eHi3FaZbFpOq9vB0FsVrta4fyeMn8Mek+JBLyloJtXUPcREP8oCfNeAj8mEXXDxF19W7+VQKSVFDTneaHL02/hSZY3TC2+3b/wifCt3C6DTG8SazWneNNlfItVnl/tjvD5RgO8JGs5Z32qUjNQjaX0Ly63s/67lyjyZMFvvfYn6gdkvfx1q014YkA2N8I489BFwlglWSVz4pFzFBQJh1cm2t/davgCCcU5L4RtdvJiifY7gdEHyvd/ePAdc6ceGXPy2sYW5fqvhrio39iQX1bjF2ywo7WDpwEoQpO+w0SZqnqRfSUqaV6/Q5Es62kyn1cFlYVOPSndldOmIier+/qZdbXXRCPRwAYHxD1tyZP2fB/6q201Q0mtzs4T/08YM7nANO9BWmIl0QUPP9ecXWpPfOYa2b7hIgopp3zP6OXXjOtq8KokHTn2oSQDxKOGfmFJPEZDl6U5DFVsDA+7ypTM/DQULVc+ZS
 MesR7UnL
 OTvUnzgrui4Zr4H9UPIFIz/KeSMqToIDILe7Bl4aacWz8hn8SGa1bQz87WYLUG+/mqdUezXKisamVvZxlZntIXdXKHVuxVacH31mkS5Re17EL+hdwWWHasRySN/+1PcVx9cAB/iCYgdHu2yfuMMC4YDfc0wZM3R9U0zatGDU+8McpQ84Ga284jORP1Sa5CadyBDL1TWrQ86wS8UFYLf2qHSk4dEnaqKlcNBwb
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
index cfbb70039ff0..4cac51e4d370 100644
--- a/arch/powerpc/kernel/syscalls/syscall.tbl
+++ b/arch/powerpc/kernel/syscalls/syscall.tbl
@@ -563,3 +563,6 @@
 470	common	listns				sys_listns
 471	nospu	rseq_slice_yield		sys_rseq_slice_yield
 472	common	fchroot				sys_fchroot
+473	common	rootns_create			sys_rootns_create
+474	common	rootns_wait			sys_rootns_wait			compat_sys_rootns_wait
+475	common	rootns_kill			sys_rootns_kill
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


