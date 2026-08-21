Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 771B9C5DF8E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9025B6B009D; Fri, 21 Aug 2026 07:52:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B23D6B009F; Fri, 21 Aug 2026 07:52:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A16A6B00A0; Fri, 21 Aug 2026 07:52:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6D06B009D
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:52:31 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2EA81A0424
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:30 +0000 (UTC)
X-FDA: 85125114060.22.B3A8A17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0488440002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlCpUL3Y;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyH7GKEaXuJ9X0Hbu/1Vcoc95AeKVCwNJoJJoiZxZMM=;
	b=KBoU7Eo9yyTA9hOD7vqxcnwkftHr94nDWTb51c7STuYbCRW/xywQY72mzjMtm07t2Bqdsd
	g1Rx+AbsoaiS6pJ5j62JYeqMdPHjgUd8TSXR3GlzOVCURORQ1MvSCSy8G/APLKDe2sqQ3Z
	966PNhCAn1jyDKje6x5sR0CsYyzBszY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313149;
	b=mytZcL6IoB+UuI1D3qb7rzo5tqHmBv8KLqHi7+NDkGTFNL0IFBYP6fkvbsVAjbYPYtA3bj
	DcYrph0Ojj+cJz3sPtYd2ptu+WjH4e9eABPvv/3LiIDs206kuQRZHljggb3mzZyvawnJqk
	9A8WvEckBIQLNAqMNgGjd+xa76CrERc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MlCpUL3Y;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51239401BF;
	Fri, 21 Aug 2026 11:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938691F00A3D;
	Fri, 21 Aug 2026 11:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313148;
	bh=tyH7GKEaXuJ9X0Hbu/1Vcoc95AeKVCwNJoJJoiZxZMM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MlCpUL3YHNY8i/T2KcFgMf4toxYa7wj+fj4gyNcySVoIzbBq5Lp8PDw5Y/nuQTvuP
	 RQmvVIruspYceHv0wZo73OJEWkoZTkqLvKI7bIvnXnpSuMdEmMZSyYgoltQlf3uLZY
	 O5cBd0VWSL1eJ+R08lZbZHVwKjmuoGTSP8Oo9pRKpc5C2ZHoMgO93/dOz43JilesGW
	 0OYNjlhDuT1tnrZzRjkxkXRBAQ0Z2oTgAEe8vnhzyAJcKJomWJ1vFZLOu069AA7bW6
	 cVgDg6gLk2Yq7TbScfCJ81zB+03MgTqq9K629rfzjclxmP7U22XNzctYoWgJz0UtHt
	 zGKNezjApUS+Q==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 21 Aug 2026 13:52:02 +0200
Subject: [PATCH 1/6] coredump: select memory types to include
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-work-coredump-filter-v1-1-91f9a73ef03e@kernel.org>
References: <20260821-work-coredump-filter-v1-0-91f9a73ef03e@kernel.org>
In-Reply-To: <20260821-work-coredump-filter-v1-0-91f9a73ef03e@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=17987; i=brauner@kernel.org;
 h=from:subject:message-id; bh=swfUMBam/a8GOcCxALCqNMAsj5RQwWUKye2hNWQCWAU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR1WH9cb5sq8nztNEOvuvUfxa8xXioUjLjYXycqyLu+p
 TZ52ddNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABM5uJzhD0dtp4XKxCnnJ+7c
 7baMO12M1TnCkW959rvHksXLtU+nazMy7OsPefbiymv1/b/il93z/3xkn2PRD0nf2YXmpowt0S0
 PeAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: y67wajeuxfb44f7fxj9bzpwae93x4tyi
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0488440002
X-HE-Tag: 1787313148-463966
X-HE-Meta: U2FsdGVkX1+ybbNOf63kDdscQ3KzP3GCPdSV61jvB+eKEZ7kqqv/DCqZrEGg21Z0r7isW+FyvAKmBRe8mEa2MI5ZvLN9QLU9SJ7zNC+jhsJIW4wPCn5a8nRn1LQKidj2Trc0/JwCKTVYcQkgcuH5qHTe12Ry3t+p0sP++CmCePcilx1vrg+tysNh69j+79+869pxm9vgFGAu/XWZo7CtVnw4tAAzaT9qbBLZb1bxYV1dZk5dYmyDWG2LVcjdrKV6VNTSM3c6S/Lu2Lnov/5pIOsaTuotT1fPYbje1yMZ2kRTI/kNtpBUTLFg6V+2Hr6OZCZVdySuGQQ3SkHXMeydrmTXMkJzKAlSVtY4w2UWtsJuXKvSP1kdHVJvXc40Ifle3LoKb44lkhW1B12OGF58uWpEL25tkyoBq3LH7ArxoMfldzikuylRFFS9v5h3aaJJScpFKBHCm4MGsus2PaJ4lnYXYi5V840s8oauVPZm/logWsaocvw2W6s8HF0CJS8/7Sve1jw3OKhCTk2rjTFd2q5FkZ55cTs50MCbW0P4Yn/rRm+ISve9mKeYj7Yqbe9ArWDAinf+UJyDxF7EZCB4koDp1/T11OtSgt6vXLRq2reVW2+u5pkdJqA1lIeHvSS3UaGV3ColcKPLJGJ2W7ZAiwRtmJSqmEa1pxX64cUhCRGgCr5i9iwikQbNdrLXmt1U7AsDTjrTST6uwjR2zCmDI8WYPLf0F+Hzs8T7hxLtdE4wQyViHbVAPFgJehaWpVF7iMD47gV3Zq+OKyoMM3A0y1P93cujqh2jRcuYm8HHLF7wuEyxCMybZ7JlQHlVffNeIiY5IUyvo38qcFItjQUq9vl8DUqiCRVATh07td5nJfF9968qBrCCRKUu+nWayj70JTWFtfF0AHwUSPl9tRfMlu3eXTBT8chZbapiQL5sj1rWO1z8CJos8xKbqOBSTdwzmUfkK7KMU2mUuXUbcyr
 RvIsAlY3
 iYwaOwY/eaXny+4NRD+PruBhyd3o/xoCF2WeDn9JXQ0Z92GwqGeJ3Kef3UnUz0ufXoGatcjogTZK1Y1yj7Ci6oifg6tQy7umAua2eAYTPV/C8qZTVn+nygww6wUdFAGZCPBnN81VZs6epJ7AhVLLqScBKZ1UFytcm6cVLfrArZ5mfm+mBp42RYpASDH71c6OQx+Kl2ixg1xZmdhkUCS1lKl/FiGzqLQ26UTxhyxiaaPw93lJXiRJHv4ioog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently /proc/<pid>/coredump_filter determines what types of memory
are included in a coredump produced by <pid>. This is fairly static. The
coredump server has no easy way to configure what memory to dump even
though it can figure out all the necessary details to make an informed
decision.

Add a new COREDUMP_MEMORY_TYPES feature bit. If the coredump server
raises it the kernel will dump memory types raised in the
coredump_ack->memory_types member. Zero is valid and causes the creation
of a coredump that just includes the program headers and notes but no
memory apart from the mappings that are always dumped.

struct coredump_req gains @memory_types which is set to the default
memory types that are included in the coredump. This can be overridden by
raising bits in coredump_ack->memory_types. It also gains
@memory_types_mask which contains a bitmask of all memory types the
kernel knows about. A coredump server may only raise bits in
coredump_ack->memory_types that are raised in
coredump_req->memory_types_mask.

struct coredump_ack grows too. If COREDUMP_MEMORY_TYPES is raised in
@mask the kernel dumps the memory types set in the @memory_types mask.
Zero is valid and dumps no memory apart from the mappings that are
always dumped. A coredump server wanting to add or drop memory types
instead of outright replacing it should simply copy
coredump_req->memory_types and then mask off or raise types as needed.

@memory_types must be zero if COREDUMP_MEMORY_TYPES isn't raised.
COREDUMP_MEMORY_TYPES requires COREDUMP_KERNEL and an ack of at least
COREDUMP_ACK_SIZE_VER1 bytes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 Documentation/filesystems/proc.rst |   4 ++
 fs/coredump.c                      | 114 +++++++++++++++++++++++++++++--------
 include/linux/coredump.h           |   4 +-
 include/uapi/linux/coredump.h      |  70 ++++++++++++++++++++++-
 4 files changed, 165 insertions(+), 27 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2ccd5b2dfdd3..3a309e8ee96b 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -1962,6 +1962,10 @@ For example::
   $ echo 0x7 > /proc/self/coredump_filter
   $ ./some_program
 
+If the coredump socket protocol is used a coredump server can select memory
+types to include dynamically. See COREDUMP_MEMORY_TYPES in
+include/uapi/linux/coredump.h.
+
 3.5	/proc/<pid>/mountinfo - Information about mounts
 --------------------------------------------------------
 
diff --git a/fs/coredump.c b/fs/coredump.c
index 7b568d25887c..ec9359e382ea 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -759,10 +759,39 @@ static inline bool coredump_sock_send(struct file *file, struct coredump_req *re
 	return ret == sizeof(*req);
 }
 
-static_assert(sizeof(struct coredump_req) == COREDUMP_REQ_SIZE_VER0);
-static_assert(sizeof(struct coredump_ack) == COREDUMP_ACK_SIZE_VER0);
+static_assert(sizeof(struct coredump_req) == COREDUMP_REQ_SIZE_VER1);
+static_assert(sizeof(struct coredump_ack) == COREDUMP_ACK_SIZE_VER1);
 static_assert(sizeof(enum coredump_mark) == sizeof(__u32));
 
+/* Every memory type this kernel knows. */
+#define COREDUMP_MEMORY_ALL						\
+	(COREDUMP_MEMORY_ANON_PRIVATE | COREDUMP_MEMORY_ANON_SHARED |	\
+	 COREDUMP_MEMORY_FILE_PRIVATE | COREDUMP_MEMORY_FILE_SHARED |	\
+	 COREDUMP_MEMORY_ELF_HEADERS |					\
+	 COREDUMP_MEMORY_HUGETLB_PRIVATE | COREDUMP_MEMORY_HUGETLB_SHARED | \
+	 COREDUMP_MEMORY_DAX_PRIVATE | COREDUMP_MEMORY_DAX_SHARED)
+
+#define COREDUMP_MEMORY_TYPE_BIT(mmf) BIT((mmf) - MMF_DUMP_FILTER_SHIFT)
+static_assert(COREDUMP_MEMORY_ALL == (MMF_DUMP_FILTER_MASK >> MMF_DUMP_FILTER_SHIFT));
+static_assert(COREDUMP_MEMORY_ANON_PRIVATE ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_ANON_PRIVATE));
+static_assert(COREDUMP_MEMORY_ANON_SHARED ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_ANON_SHARED));
+static_assert(COREDUMP_MEMORY_FILE_PRIVATE ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_MAPPED_PRIVATE));
+static_assert(COREDUMP_MEMORY_FILE_SHARED ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_MAPPED_SHARED));
+static_assert(COREDUMP_MEMORY_ELF_HEADERS ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_ELF_HEADERS));
+static_assert(COREDUMP_MEMORY_HUGETLB_PRIVATE ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_HUGETLB_PRIVATE));
+static_assert(COREDUMP_MEMORY_HUGETLB_SHARED ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_HUGETLB_SHARED));
+static_assert(COREDUMP_MEMORY_DAX_PRIVATE ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_DAX_PRIVATE));
+static_assert(COREDUMP_MEMORY_DAX_SHARED ==
+	      COREDUMP_MEMORY_TYPE_BIT(MMF_DUMP_DAX_SHARED));
+
 static inline bool coredump_sock_mark(struct file *file, enum coredump_mark mark)
 {
 	struct msghdr msg = { .msg_flags = MSG_NOSIGNAL };
@@ -804,11 +833,14 @@ static inline void coredump_sock_shutdown(struct file *file)
 static bool coredump_sock_request(struct core_name *cn, struct coredump_params *cprm)
 {
 	struct coredump_req req = {
-		.size		= sizeof(struct coredump_req),
-		.mask		= COREDUMP_KERNEL | COREDUMP_USERSPACE |
-				  COREDUMP_REJECT | COREDUMP_WAIT |
-				  COREDUMP_RECORDS | COREDUMP_SPARSE,
-		.size_ack	= sizeof(struct coredump_ack),
+		.size			= sizeof(struct coredump_req),
+		.mask			= COREDUMP_KERNEL | COREDUMP_USERSPACE |
+					  COREDUMP_REJECT | COREDUMP_WAIT |
+					  COREDUMP_RECORDS | COREDUMP_SPARSE |
+					  COREDUMP_MEMORY_TYPES,
+		.size_ack		= sizeof(struct coredump_ack),
+		.memory_types		= cprm->memory_types,
+		.memory_types_mask	= COREDUMP_MEMORY_ALL,
 	};
 	struct coredump_ack ack = {};
 	ssize_t usize;
@@ -873,6 +905,30 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 		return false;
 	}
 
+	if (ack.mask & COREDUMP_MEMORY_TYPES) {
+		/* The memory types need the whole field. */
+		if (usize < COREDUMP_ACK_SIZE_VER1) {
+			coredump_sock_mark(cprm->file, COREDUMP_MARK_MINSIZE);
+			return false;
+		}
+
+		/* The memory types only select what the kernel writes. */
+		if (!(ack.mask & COREDUMP_KERNEL)) {
+			coredump_sock_mark(cprm->file, COREDUMP_MARK_CONFLICTING);
+			return false;
+		}
+
+		/* Refuse unknown memory types. */
+		if (ack.memory_types & ~req.memory_types_mask) {
+			coredump_sock_mark(cprm->file, COREDUMP_MARK_UNSUPPORTED);
+			return false;
+		}
+	} else if (ack.memory_types) {
+		/* Like @spare the field must be zero when it isn't used. */
+		coredump_sock_mark(cprm->file, COREDUMP_MARK_UNSUPPORTED);
+		return false;
+	}
+
 	/* Record header scratch; a bvec can't point at the stack. */
 	if (ack.mask & COREDUMP_RECORDS) {
 		cprm->record_hdr = kmalloc_obj(*cprm->record_hdr);
@@ -880,6 +936,10 @@ static bool coredump_sock_request(struct core_name *cn, struct coredump_params *
 			return false;
 	}
 
+	/* The server's selection replaces the task's entirely. */
+	if (ack.mask & COREDUMP_MEMORY_TYPES)
+		cprm->memory_types = ack.memory_types;
+
 	cprm->mask = ack.mask;
 	return coredump_sock_mark(cprm->file, COREDUMP_MARK_REQACK);
 }
@@ -1200,6 +1260,10 @@ static void do_coredump(struct core_name *cn, struct coredump_params *cprm,
 	}
 }
 
+#define COREDUMP_TASK_MEMORY_TYPES(mm)                         \
+	((__mm_flags_get_word((mm)) & MMF_DUMP_FILTER_MASK) >> \
+	 MMF_DUMP_FILTER_SHIFT)
+
 void vfs_coredump(const kernel_siginfo_t *siginfo)
 {
 	size_t *argv __free(kfree) = NULL;
@@ -1211,8 +1275,8 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
 		.limit = rlimit(RLIMIT_CORE),
-		/* Snapshot MMF_DUMP_FILTER_* (unlocked) and dumpable for the dump. */
-		.mm_flags = __mm_flags_get_word(mm),
+		/* Snapshot the memory types (unlocked) and dumpable for the dump. */
+		.memory_types = COREDUMP_TASK_MEMORY_TYPES(mm),
 		.dumpable = task_exec_state_get_dumpable(current),
 		.vma_meta = NULL,
 		.cpu = raw_smp_processor_id(),
@@ -1746,15 +1810,15 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 }
 
 #define DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER 1
+#define COREDUMP_MEMORY_TYPE_INCLUDE(types, type) \
+	((types) & COREDUMP_MEMORY_##type)
 
 /*
  * Decide how much of @vma's contents should be included in a core dump.
  */
 static unsigned long vma_dump_size(struct vm_area_struct *vma,
-				   unsigned long mm_flags)
+				   u64 memory_types)
 {
-#define FILTER(type)	(mm_flags & (1UL << MMF_DUMP_##type))
-
 	/* always dump the vdso and vsyscall sections */
 	if (always_dump_vma(vma))
 		goto whole;
@@ -1764,18 +1828,22 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 
 	/* support for DAX */
 	if (vma_is_dax(vma)) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(DAX_SHARED))
+		if ((vma->vm_flags & VM_SHARED) &&
+		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(DAX_PRIVATE))
+		if (!(vma->vm_flags & VM_SHARED) &&
+		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, DAX_PRIVATE))
 			goto whole;
 		return 0;
 	}
 
 	/* Hugetlb memory check */
 	if (is_vm_hugetlb_page(vma)) {
-		if ((vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_SHARED))
+		if ((vma->vm_flags & VM_SHARED) &&
+		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_SHARED))
 			goto whole;
-		if (!(vma->vm_flags & VM_SHARED) && FILTER(HUGETLB_PRIVATE))
+		if (!(vma->vm_flags & VM_SHARED) &&
+		    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, HUGETLB_PRIVATE))
 			goto whole;
 		return 0;
 	}
@@ -1787,25 +1855,27 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 	/* By default, dump shared memory if mapped from an anonymous file. */
 	if (vma->vm_flags & VM_SHARED) {
 		if (file_inode(vma->vm_file)->i_nlink == 0 ?
-		    FILTER(ANON_SHARED) : FILTER(MAPPED_SHARED))
+			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ANON_SHARED) :
+			    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, FILE_SHARED))
 			goto whole;
 		return 0;
 	}
 
 	/* Dump segments that have been written to.  */
-	if ((!IS_ENABLED(CONFIG_MMU) || vma->anon_vma) && FILTER(ANON_PRIVATE))
+	if ((!IS_ENABLED(CONFIG_MMU) || vma->anon_vma) &&
+	    COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ANON_PRIVATE))
 		goto whole;
 	if (vma->vm_file == NULL)
 		return 0;
 
-	if (FILTER(MAPPED_PRIVATE))
+	if (COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, FILE_PRIVATE))
 		goto whole;
 
 	/*
 	 * If this is the beginning of an executable file mapping,
 	 * dump the first page to aid in determining what was mapped here.
 	 */
-	if (FILTER(ELF_HEADERS) &&
+	if (COREDUMP_MEMORY_TYPE_INCLUDE(memory_types, ELF_HEADERS) &&
 	    vma->vm_pgoff == 0 && (vma->vm_flags & VM_READ)) {
 		if ((READ_ONCE(file_inode(vma->vm_file)->i_mode) & 0111) != 0)
 			return PAGE_SIZE;
@@ -1821,8 +1891,6 @@ static unsigned long vma_dump_size(struct vm_area_struct *vma,
 		return DUMP_SIZE_MAYBE_ELFHDR_PLACEHOLDER;
 	}
 
-#undef	FILTER
-
 	return 0;
 
 whole:
@@ -1907,7 +1975,7 @@ static bool dump_vma_snapshot(struct coredump_params *cprm)
 		m->start = vma->vm_start;
 		m->end = vma->vm_end;
 		m->flags = vma->vm_flags;
-		m->dump_size = vma_dump_size(vma, cprm->mm_flags);
+		m->dump_size = vma_dump_size(vma, cprm->memory_types);
 		m->pgoff = vma->vm_pgoff;
 		m->file = vma->vm_file;
 		if (m->file)
diff --git a/include/linux/coredump.h b/include/linux/coredump.h
index b252bb2843b3..74af57b9406b 100644
--- a/include/linux/coredump.h
+++ b/include/linux/coredump.h
@@ -32,8 +32,8 @@ struct coredump_params {
 	const kernel_siginfo_t *siginfo;
 	struct file *file;
 	unsigned long limit;
-	/* MMF_DUMP_FILTER_* bits, snapshot of mm->flags at dump start. */
-	unsigned long mm_flags;
+	/* COREDUMP_MEMORY_* types to dump, the task's or the server's. */
+	u64 memory_types;
 	/* Snapshot of dumpable at dump start. */
 	enum task_dumpable dumpable;
 	int cpu;
diff --git a/include/uapi/linux/coredump.h b/include/uapi/linux/coredump.h
index f3771861ca48..6d0c53b534ea 100644
--- a/include/uapi/linux/coredump.h
+++ b/include/uapi/linux/coredump.h
@@ -16,6 +16,9 @@
  *                    requires COREDUMP_KERNEL
  * @COREDUMP_SPARSE: describe the holes in the coredump as zero records
  *                   instead of transferring them; requires COREDUMP_RECORDS
+ * @COREDUMP_MEMORY_TYPES: dump the memory types in
+ *                          coredump_ack->memory_types instead of the ones
+ *                          the task selected; requires COREDUMP_KERNEL
  */
 enum {
 	COREDUMP_KERNEL		= (1ULL << 0),
@@ -24,6 +27,37 @@ enum {
 	COREDUMP_WAIT		= (1ULL << 3),
 	COREDUMP_RECORDS	= (1ULL << 4),
 	COREDUMP_SPARSE		= (1ULL << 5),
+	COREDUMP_MEMORY_TYPES	= (1ULL << 6),
+};
+
+/**
+ * coredump memory types
+ * @COREDUMP_MEMORY_ANON_PRIVATE: anonymous private memory
+ * @COREDUMP_MEMORY_ANON_SHARED: anonymous shared memory
+ * @COREDUMP_MEMORY_FILE_PRIVATE: file-backed private memory
+ * @COREDUMP_MEMORY_FILE_SHARED: file-backed shared memory
+ * @COREDUMP_MEMORY_ELF_HEADERS: the first page of a file-backed private
+ *                               mapping that starts an ELF file
+ * @COREDUMP_MEMORY_HUGETLB_PRIVATE: hugetlb private memory
+ * @COREDUMP_MEMORY_HUGETLB_SHARED: hugetlb shared memory
+ * @COREDUMP_MEMORY_DAX_PRIVATE: DAX private memory
+ * @COREDUMP_MEMORY_DAX_SHARED: DAX shared memory
+ *
+ * A bitmask of memory types a coredump may request to be included. New
+ * memory type bits must ensure that they do not steal memory from an
+ * existing one so a coredump server will continue to get the same
+ * coredumps even if a new bit is introduced.
+ */
+enum {
+	COREDUMP_MEMORY_ANON_PRIVATE	= (1ULL << 0),
+	COREDUMP_MEMORY_ANON_SHARED	= (1ULL << 1),
+	COREDUMP_MEMORY_FILE_PRIVATE	= (1ULL << 2),
+	COREDUMP_MEMORY_FILE_SHARED	= (1ULL << 3),
+	COREDUMP_MEMORY_ELF_HEADERS	= (1ULL << 4),
+	COREDUMP_MEMORY_HUGETLB_PRIVATE	= (1ULL << 5),
+	COREDUMP_MEMORY_HUGETLB_SHARED	= (1ULL << 6),
+	COREDUMP_MEMORY_DAX_PRIVATE	= (1ULL << 7),
+	COREDUMP_MEMORY_DAX_SHARED	= (1ULL << 8),
 };
 
 /**
@@ -31,6 +65,8 @@ enum {
  * @size: size of struct coredump_req
  * @size_ack: known size of struct coredump_ack on this kernel
  * @mask: supported features
+ * @memory_types: the memory types the task selected
+ * @memory_types_mask: the memory types this kernel knows
  *
  * When a coredump happens the kernel will connect to the coredump
  * socket and send a coredump request to the coredump server. The @size
@@ -49,15 +85,27 @@ enum {
  * struct coredump_ack the kernel knows. Userspace may only send up to
  * coredump_req->size_ack bytes to the kernel and must set
  * coredump_ack->size accordingly.
+ *
+ * @memory_types is set to the default memory types that are included in
+ * the coredump. This can be overridden by raising bits in
+ * coredump_ack->memory_types.
+ *
+ * @memory_types_mask contains a bitmask of all memory types the kernel
+ * knows about. A coredump server may only raise bits in
+ * coredump_ack->memory_types that are raised in
+ * coredump_req->memory_types_mask.
  */
 struct coredump_req {
 	__u32 size;
 	__u32 size_ack;
 	__u64 mask;
+	__u64 memory_types;
+	__u64 memory_types_mask;
 };
 
 enum {
 	COREDUMP_REQ_SIZE_VER0 = 16U, /* size of first published struct */
+	COREDUMP_REQ_SIZE_VER1 = 32U, /* memory_types and memory_types_mask added */
 };
 
 /**
@@ -65,6 +113,8 @@ enum {
  * @size: size of the struct
  * @spare: unused
  * @mask: features kernel is supposed to use
+ * @memory_types: memory types to dump, only with COREDUMP_MEMORY_TYPES
+ *                 in @mask
  *
  * The @size member must be set to the size of struct coredump_ack. It
  * may never exceed what the kernel returned in coredump_req->size_ack
@@ -74,15 +124,30 @@ enum {
  * The @mask member must be set to the features the coredump server
  * wants the kernel to use. Only bits the kernel returned in
  * coredump_req->mask may be set.
+ *
+ * If COREDUMP_MEMORY_TYPES is raised in @mask the kernel dumps the
+ * memory types set in the @memory_types mask. Zero is valid and dumps
+ * no memory apart from the mappings that are always dumped.
+ *
+ * Note that memory a task excluded via MADV_DONTDUMP is always left
+ * out. A coredump server wanting to add or drop memory types instead of
+ * outright replacing it should simply copy coredump_req->memory_types
+ * and then mask off or raise types as needed.
+ *
+ * Note that @memory_types must be zero if COREDUMP_MEMORY_TYPES isn't
+ * raised. COREDUMP_MEMORY_TYPES requires COREDUMP_KERNEL and an ack of
+ * at least COREDUMP_ACK_SIZE_VER1 bytes.
  */
 struct coredump_ack {
 	__u32 size;
 	__u32 spare;
 	__u64 mask;
+	__u64 memory_types;
 };
 
 enum {
 	COREDUMP_ACK_SIZE_VER0 = 16U, /* size of first published struct */
+	COREDUMP_ACK_SIZE_VER1 = 24U, /* memory_types added */
 };
 
 /**
@@ -90,11 +155,12 @@ enum {
  *
  * The kernel will place a single byte on the coredump socket. The
  * markers notify userspace whether the coredump ack succeeded or
- * failed.
+ * failed. After any marker other than COREDUMP_MARK_REQACK the kernel
+ * closes the connection and no coredump is generated.
  *
  * @COREDUMP_MARK_MINSIZE: the provided coredump_ack size was too small
  * @COREDUMP_MARK_MAXSIZE: the provided coredump_ack size was too big
- * @COREDUMP_MARK_UNSUPPORTED: the provided coredump_ack mask was invalid
+ * @COREDUMP_MARK_UNSUPPORTED: the provided coredump_ack mask or memory types were invalid
  * @COREDUMP_MARK_CONFLICTING: the provided coredump_ack mask has conflicting options
  * @COREDUMP_MARK_REQACK: the coredump request and ack was successful
  * @__COREDUMP_MARK_MAX: the maximum coredump mark value

-- 
2.53.0


