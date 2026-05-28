Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B587CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:57:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92CC36B00AE; Thu, 28 May 2026 05:57:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 904516B00B0; Thu, 28 May 2026 05:57:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FD56B00B1; Thu, 28 May 2026 05:57:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 729266B00AE
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:57:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 459741C06BA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:57:17 +0000 (UTC)
X-FDA: 84816375714.09.BD0CC35
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6D9BE180004
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:57:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=DhSwfSV5;
	spf=pass (imf24.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daeNay/B7krhkGaOXcpEKi+TINPHP/xa1Qaj59GhpT8=;
	b=5beE6G8waoJ9zYU2Ddj56Orf/YmMnS04EeQjt2sew7Zbz/CgAXLAplV6xNtCQLri6lzz7G
	LorLXQ6n+CxnX/+dkf63QGhmM4zTOfuDwpCLG6m5lISVaWDfN86NKNzsx+9C7xcj8uUNFT
	Bdw1cqSuTX9A6V6mRMnEM9KhMODo5S8=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=DhSwfSV5;
	spf=pass (imf24.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962235; a=rsa-sha256;
	cv=pass;
	b=AuEmECxfh7d956Yke1PnvIDXXPaaGXGEKlcBMr/KAeiNzv6Df0efuboBkO8SeDtZuf7EYG
	SKO+UQtPk3np4gbzcfIMis9xld1zNt4Kgr6wQObT+E2SPPUyV7/4o1mr1VxU6C/XIYvixt
	6GX79gU8lg41+uq1SBf7MkULvLGVpfA=
ARC-Seal: i=1; a=rsa-sha256; t=1779962051; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=mcw8OsKXKqqUZExZTfgJV8uxJ+tTUcrqPFqDJc+RjTr6dwtZ8YBIsocF7BTtYSH76cjUpBrpaD2CMCi5+pPs3lWv0bUFxthgQRyEActcciCWbq9vd4FKLoFjCF2kiVJclqdwe276aU9yuyKr1P3YGCtsU5I/OerV9S5jFp0+tdM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962051; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=daeNay/B7krhkGaOXcpEKi+TINPHP/xa1Qaj59GhpT8=; 
	b=KSi0NYjp+lU4rA8L1T6YaXxF0xn8z5PMQELBeMPsQQmEHeOXDceccXAYVtWVaFkHbMcUPjxPJH/ha/27fGRl4XlZMTJaSGEKsnVkOaOmijyrDmlXL3doS0Q9DG6FfMDa6Qkl1BRA6Tr7+BfTHwJrk6CNIxHVy4qoduoBhmWOpqw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962051;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=daeNay/B7krhkGaOXcpEKi+TINPHP/xa1Qaj59GhpT8=;
	b=DhSwfSV5fxHbEYfKY8w+TuhtwRb0Pn50kcNXlaE1NvCJZDMBaPSi2c2/30I7VZzb
	gm05H/saGHdvUT0KvMDvopE6rQAU9a5sd3LSdf0K9qFEu3T85aWpTitVZNTUsXlI+7s
	DiiWTbt81HFYOFZbCChrAJ2XuzjwiDn0/qf0p6bc=
Received: by mx.zohomail.com with SMTPS id 1779962049658625.4597262662478;
	Thu, 28 May 2026 02:54:09 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 09/13] Documentation: describe spawn templates
Date: Thu, 28 May 2026 17:52:30 +0800
Message-ID: <20260528095235.2491226-10-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D9BE180004
X-Stat-Signature: psng3s3tprjkn5jdeyy6u5hncj1gw8t4
X-HE-Tag: 1779962235-406415
X-HE-Meta: U2FsdGVkX18RtpcojOFJ1uLm9oMy9+jnwKTy98f4Tbge1WHL6M9kwkoZv4o/GkyP/BIAwNW4RnMIAq41HXAmoBr6AciKDaHo4Tw09lgub1joVS69ziHwqN2n97mnka+Fm8hO5ZTC9r4u//QJWdpj8hch/prwrrkJW8xDTWP/nb3FZq0j0hy+U/0Er5ZN19rBRpAuISUva4dt6wc24buBP6u15XG6aGiXVdlgywedvOERxuG3SatxNI6jDLWxVwrE2tEALCaYWF8SOoq/htlpowKy+MZ8faUqnbkXwkzbAT40hPKXORq/5zLWxzcX6Gkwy4sxDmZdOuB6DrOramLPh4Wv3bVVP5VRCBFb3TV56j313nwbPLuzIFzHP0zwPfimBXqap3vhI6vh75givRk1RyhgVvJufBOut7dOD0Cz3xXGlzkvBkU0oy6hTIYYPiM46pnJFeYxN40RV8x7CteiP3HyyErlSNxZ7EoiRetr4rZ1jsZ3XOPjaLYyTvDWZmma1b9xVFb3qpdm+309au00TTQiNg/OGVnWG6W8SSMgWAJp0Iwlxb7Fm/RwKygs/+EPC0VEvedB6TnPECVGegoSA3FgxF3meQ0KOKYQ+NgyhbUevpjbgTlnIRSNKGI/K8YcobGJ8HFjpGQ3a++q+Y6mDMgbUmXudD8DA1A86WUDxa5FGiOdao+cpuCRHtQIePB1AaV2SCAWTRqpmWV4rWQvRBIV/ys2BeW6hQzPmwIQ9EqwkUKbLdireEyj4h3bE/JIs0f1u3JJsGdvbMpoAiOGmt36RFvDFblyhIMfxHs8vJRt9HA2RBk+RJVnNXniz39ZdYraLLzkUemm+2JpSzLP8FMQCg05+TeVm51xfQJOufisn2360I8dtd2AdYQtXiT2zs9g/PBdkN101nvwQgKEEsFu4bS3fB9QvDQ1MwmwTilpUk4jEv7IhwmD5F5r5wQapnCCRIM8KOAsdN9pvTZ
 mCpluTIa
 Qk9G5qRXPYdmdzid98ehmkV10+rGvrAyTpttLZzDgqNgBNcjI+5gpkCFLsYiMjuPG/9Yjc84girO4YBWX62xTM53idx+arcxylc2qsN9IkZnGl6K3v16OzcA++rgP7M4ud9ciFd0FXuCnl9q+6tMoWMEvUZIfhS6hckNsb+pyXViOCzRKqVxvHMzO4G7fMlNGKW20o4y2FgocKlXPOh98A27RAI7mBJDhKpF2vdVHHSFfqY5J5fnQgEasTjPaOy2HMLBaic4do+jC+KcCqquBn3AYW90TstnXVzFR2u7G2pyhygQ+ohuQEUTe5/UwJMI/oMT5rSaLYQGCXpK12EmlgB9oY7pfHnAxwd6rT/c6hSsEgS0FdkXN8dMAg80mb9ftAc/DFge/0xOzX1zrP7tY9ny+fmAno8mD5Vof3PPRvEqWBPKnMlYwiI4CV/dGdh3dHC4gBCVcoxyCQXRfkThCOLIAopbQa5pDlPQRrhhQhsSMNyFqlcpQlUrBKOZL0L4FsGJQpL3zLvlX28w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the spawn_template userspace ABI, fd lifetime, per-spawn
actions, default fd-closing behavior, security model, invalidation, and
cached ELF metadata. Keep workload-specific benchmark details out of the
kernel documentation.

Add the spawn template files to the exec/binfmt MAINTAINERS entry so the
documentation, UAPI, internal header, and implementation are covered in
the same patch.

Signed-off-by: Li Chen <me@linux.beauty>
---
 Documentation/userspace-api/index.rst         |   1 +
 .../userspace-api/spawn_template.rst          | 141 ++++++++++++++++++
 MAINTAINERS                                   |   2 +
 3 files changed, 144 insertions(+)
 create mode 100644 Documentation/userspace-api/spawn_template.rst

diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index a68b1bea57a85..28520d16d3862 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -22,6 +22,7 @@ System calls
    ioctl/index
    mseal
    rseq
+   spawn_template
 
 Security-related interfaces
 ===========================
diff --git a/Documentation/userspace-api/spawn_template.rst b/Documentation/userspace-api/spawn_template.rst
new file mode 100644
index 0000000000000..0396d292fd17d
--- /dev/null
+++ b/Documentation/userspace-api/spawn_template.rst
@@ -0,0 +1,141 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============
+Spawn templates
+===============
+
+``spawn_template`` is a userspace-controlled interface for workloads that
+repeatedly start the same executable with different arguments, environment, and
+file-descriptor setup.
+
+Userspace creates a template fd for an executable with
+``spawn_template_create()``.  Later calls to ``spawn_template_spawn()`` create a
+new child from that template and return both a pid and a pidfd.  The child still
+executes through the normal ``execve`` path.  The template only lets the kernel
+reuse metadata that is safe to reuse after revalidation.
+
+This is intended for launchers, shells, and agent runtimes that already know
+which tools are hot.  The kernel does not decide policy for names such as
+``rg``, ``git``, or ``sed``.  Userspace should keep its existing spawn path as a
+fallback for unsupported files, invalidated templates, and policy decisions.
+
+This RFC version supports ELF executable templates only.  Scripts, binfmt_misc
+targets, and other non-ELF formats are expected to use the fallback path.
+
+Template lifetime
+=================
+
+``spawn_template_create()`` takes ``struct spawn_template_create_args`` and
+returns a template fd.  The fd is an ordinary file descriptor backed by an
+anonymous inode.  Closing the fd releases the template.
+
+Userspace can identify the executable either by an existing executable fd or by
+path.  Exactly one of ``execfd`` and ``filename`` must be supplied.  Passing
+``SPAWN_TEMPLATE_CREATE_CLOEXEC`` sets ``O_CLOEXEC`` on the returned template
+fd.
+
+Creating a template for an unsupported executable format fails.  For this RFC
+that means non-ELF executables fail template creation rather than becoming a
+partially cached template.
+
+Create-time fd actions are not supported.  ``actions`` and ``actions_len`` in
+``struct spawn_template_create_args`` are reserved and must be zero.  File
+descriptor numbers are per-process state, so reusable fd actions would be
+ambiguous once the creating process changes its fd table.
+
+Spawning
+========
+
+``spawn_template_spawn()`` takes a template fd and
+``struct spawn_template_spawn_args``.  ``argv`` and ``envp`` point to the normal
+userspace argument and environment vectors for the new image.  ``pidfd`` points
+to an ``int`` in userspace where the kernel stores the new pidfd.  The syscall
+return value is the new pid on success.
+
+A successful ``spawn_template_spawn()`` return means the child has been created
+and the pidfd has been installed.  After that point, per-spawn action failures
+or exec failures are reported by the child exit status, not by changing the
+syscall return value.  The syscall itself returns a negative errno only for
+errors detected before child creation, such as bad arguments, a bad template
+fd, stale executable identity, or clone failure.
+
+Per-spawn actions run in the child before exec.  They are intended for the same
+kind of setup that ``posix_spawn_file_actions_t`` commonly performs:
+
+``SPAWN_TEMPLATE_ACTION_CLOSE``
+  Close one fd.
+
+``SPAWN_TEMPLATE_ACTION_DUP2``
+  Duplicate one fd to another fd, optionally with ``O_CLOEXEC``.
+
+``SPAWN_TEMPLATE_ACTION_FCHDIR``
+  Change the child's current working directory to an open directory fd.
+
+``SPAWN_TEMPLATE_ACTION_OPEN``
+  Open a path using ``struct open_how`` and install it at ``newfd``.
+
+``SPAWN_TEMPLATE_ACTION_CLOSE_RANGE``
+  Apply ``close_range()`` to a child fd range.
+
+``SPAWN_TEMPLATE_ACTION_SIGMASK``
+  Set the child signal mask.
+
+``SPAWN_TEMPLATE_ACTION_SIGDEFAULT``
+  Reset selected signal dispositions to ``SIG_DFL``.
+
+By default, the child closes all inherited file descriptors above standard
+error after the requested actions have run.  Passing
+``SPAWN_TEMPLATE_SPAWN_INHERIT_FDS`` keeps the traditional inheritance model.
+Launchers for untrusted or secret-bearing workloads should prefer the default.
+
+Security model
+==============
+
+``spawn_template_spawn()`` is not a shortcut around ``execve`` security.  Each
+spawn still reaches the normal binary handler and credential commit path, so
+permission checks, LSM hooks, secure-exec handling, and ``no_new_privs`` remain
+part of execution.
+
+The template fd does not grant ambient authority to unrelated tasks.  The
+current implementation requires the caller to have the same credential object
+that created the template.  Passing the fd with ``SCM_RIGHTS`` is therefore not
+enough to delegate spawn authority after credentials have changed.
+
+The kernel pins the executable inode against writes while the template exists.
+An in-place writer therefore fails while a template fd is alive.  A package
+manager can still replace a tool with a rename; a path-created template then
+sees that the absolute path resolves to a different executable and spawn fails
+before creating a child.  Userspace can close the old template fd and create a
+new one after such an update.
+
+Each spawn revalidates cached identity metadata before using template metadata.
+The key includes device, inode, size, mode, owner, ctime, and mtime.
+Path-created templates re-open the path before child creation and reject reuse
+if the path now names a different executable.
+
+Cached metadata
+===============
+
+For ELF executables, the template caches only the main executable ELF header,
+program headers, and executable identity key.  The cached program headers are
+used to avoid repeated metadata reads for hot executables after the executable
+identity has been revalidated.
+
+The cache does not include the shared-library dependency graph.  Shared
+libraries are found by the userspace dynamic linker after exec and depend on
+userspace policy such as ``LD_LIBRARY_PATH``, ``RPATH``, ``RUNPATH``,
+``/etc/ld.so.cache``, mount namespaces, and secure-exec state.  The kernel
+therefore does not try to duplicate dynamic-linker policy in a spawn template.
+
+Errors and fallback
+===================
+
+If template creation reports an unsupported format, or if spawn reports a stale
+template before child creation, the caller should use its existing spawn
+implementation.  A launcher may also drop the template fd and create a new
+template after a failure.  Once spawn has returned a pid, the caller should
+observe child success or failure by waiting on the pid or pidfd.
+
+The interface is designed so ordinary tools do not need to be modified.
+Runtimes that already centralize process launch can opt in one executable at a
+time and preserve their existing fallback behavior.
diff --git a/MAINTAINERS b/MAINTAINERS
index ea4134a188779..3e737097940f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9728,7 +9728,9 @@ M:	Kees Cook <kees@kernel.org>
 L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
+F:	arch/x86/entry/syscalls/syscall_64.tbl
 F:	Documentation/userspace-api/ELF.rst
+F:	Documentation/userspace-api/spawn_template.rst
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
-- 
2.52.0


