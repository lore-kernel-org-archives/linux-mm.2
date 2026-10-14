Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FE4CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 00:36:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798656B008C; Tue, 13 Oct 2026 20:36:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E986B0092; Tue, 13 Oct 2026 20:36:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D1F6B0095; Tue, 13 Oct 2026 20:36:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2D26B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 20:36:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BF100140391
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:36:23 +0000 (UTC)
X-FDA: 85319365446.27.0970458
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2B46180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 00:36:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qULhHkC3;
	spf=pass (imf24.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791938182;
	b=gsPfuKUE3iUOAAzMsaIT8WXs/9o6htzRx9kbckXtYmz0cyU4aKiew0bKhHT5RBNxJwEDn5
	7Ohcj1nM9E5QGaf29OCzyHM3s6innScwWjoucJSXeXlT3Ku5jaLn9imeeo5XXtkrcjtH1/
	8pCQhqTgJ92LuqhZOU9JyYMRm6DBpwg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=qULhHkC3;
	spf=pass (imf24.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791938182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e8l+LZqu+D+wbZzn73m1duCjP/mzQaKWa6FuilWnWdo=;
	b=GRTJ9zxO17zQRDITyrB3PVcyuFkRI2iZYZg2fjauFEqVv6IoR9LYnRsYeLuScNh6qV1R+a
	lNJa8t1tkgfGGmn+8pfDQNe8bAVu2DHec4paM47GcwxY99y2x+fJWhu9koiZLOkzDvqjRE
	BKZ8GffoY4E3CJQsTlSjxgsrtNO2elE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=e8
	l+LZqu+D+wbZzn73m1duCjP/mzQaKWa6FuilWnWdo=; b=qULhHkC3lWX1MFXNUu
	1Nl3gCE4E8ih+XfVGgfuP2T+5bB6eOzKU7TSKmNoIebiDc9wFn2102nWfE8ZnFrt
	SskUPGz90iJII+OEV/zrPsuqlD07b9POdlqGexSKZMSd4JLGExvw3WrFbLkzHyW/
	mHV+j3mixKIFDS7So9U1yv3+g=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD3_3p2zs5q5kSdEg--.1031S2;
	Wed, 14 Oct 2026 08:36:08 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memfd_luo: carry the exec-bit state in the preserved record
Date: Wed, 14 Oct 2026 08:35:58 +0800
Message-ID: <20261014003558.357783-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3_3p2zs5q5kSdEg--.1031S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxuw1rZFyUKryrKryUtw4Utwb_yoW3GF47pr
	ZxKr1rKr4kAFyIy3s7Zw18ZFyrZw4fJF15JryIgry8C3W5XrnIqF1S9Fy5WFyxAFnaga40
	qr4Y9rykuayDZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFq2NUUUUU=
X-Originating-IP: [2001:250:5828:4461:5d0:1f3:be4d:bdab]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9hgg52rOznjF7QAA3T
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2B46180006
X-Stat-Signature: b7f5a8tdiqouex69t5yxj5rsemmdw5u4
X-HE-Tag: 1791938180-106698
X-HE-Meta: U2FsdGVkX18PNgex4LV80j/MgDPEt9ze5+4TnC9ipg4hrFvd9OwIC2IGXnQ4Tg+0Mgv/4AYijU/MGJs1sIvaowfVBxUD2MZZ59ia6njhT5qfjez9oMIcccQ0Jod29qP+AiUXKP3JjEQpY3baG5+SA0NRRfLplIbp3zSW9JnMsJrh3BP/R3DXoFR5QT1oSZb3EEsDAsHGk08Fd+7T/1vINlz8ePANNt0wArn3XInZWZGghN2TKRPobF5yri8M8ndfU27W5Hz/fFCfVHRLiF7tG1ngvfpJk5E8wuvSVlcoBSvsZXuYRE7lgT4LpsYs1SBo32A+Tjdov6O3mswl+MEOaGQw4vQdUEucwSJBWm8WMy8tTZP51WBUgiSKK9wJ+ksejxBziOqurshxrGWFM2NwGb2uXq0Ua/6Iodlum4wCoOa/YH1A3viZKwEoOkkKOKPPI/uHtl+rUFiDzrydBkACInrYKQATXjN7PBduJbnDY5/v7g68GqVsAHCtftTSBt0xDfnAB8SEr3pVkhusR9V791Y1UZnzME4BLZFz78vqpWEId0DosxoY+s9idLCsnpFuLCT0Ej50GwS0zhfBlnJ13K8QSVjPIv57FDQig3A5R+AYHxqwtmNL6m4n401RSBBfS/gcqhsGMZWvBevcmEGc2JR5l6UBFCHxxgpqRWSJcYjMRf1LYlxGXCbFze/do1wCy4jWEgicNcnnrhEKq715XUYXmO9eMuTw++ML4kUzSFHd0jPPG34g0RxINEzov0e7vso5oSnoS4zfcQKiJ6ymAFiKmqubMrX1WcMTM7/oT4dQwmM11CW/lGmCZ3hQf2hhuaxB2f9CZaWQV/TbD5VhmUw2RQAhhTDU7Bb9LOzixtKa8H2KTvLMnL+Rg1n/J58zeMmwtvMahzc4zZ8jw1DSAILr5zCZfMi5TK6hkjAgl5cDK5eJetl4/WwQ7dI3PL8N1hraIYtW8vQ8lVdWM9M
 Ep6lCz4i
 KEJIo8j88+1gO7cLnK4uNnfZCoDy3AO4KKlDWA67cRcQQPeILapFa+3BErBOFyYAPTA6Te0Z1rl9pBOMFJLmZS05z53U2ke3f7XWnAu+qRvXc3tH5aJkqvKEp/BljEwhTdbE933nWIiC5tv5ryg8s2h/Tg0ssQz5l62wNswY0iWI4173igse911L3Z39rSGUkPBtJiuEsMWw6ol3mH4z4BlyyF4km8rCcylotD3spNSIqBR1XMqpTx5FZ1NHXleQci0ZRMOp1GMiMLyF3DbzhgeX7vJ8sAb57RJfYNlWSbS9F9ZcNsH3sqCzmtzX6U1RdTYTq63b49zzSPhu90xefGkG6UZgUgTMeEqwkAYuVhzpxtZ1XzH1P5gEiwNS5ifgnJlEpnqYw9zQh48o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

F_SEAL_EXEC freezes the exec bits as they are at sealing time: a memfd
becomes either permanently executable or permanently un-executable.
The preserved state of a memfd (struct memfd_luo_ser) carries the
seals but not the inode mode, and the restore path creates the file
with memfd_alloc_file("", MFD_ALLOW_SEALING) -- the default
(executable) mode -- without consulting the vm.memfd_noexec policy
(that policy is applied on the memfd_create() syscall path only).

A memfd sealed as un-executable is therefore restored as mode 0777
with F_SEAL_EXEC re-applied on top of it: the guarantee inverts.
Because the restored file is executable, memfd_add_seals() also
implies F_SEAL_WRITE, F_SEAL_FUTURE_WRITE, F_SEAL_SHRINK and
F_SEAL_GROW (the W^X rule), so the restored memfd comes back with its
write seals locked and its exec bits permanently irrevocable
(shmem_setattr() rejects any exec-bit change).  This is a functional
regression that needs no attacker: the owner's own pwrite() to the
memfd succeeds before the update and fails with EPERM after it.  The
inversion is also silent: F_GET_SEALS keeps reporting the seal.

Carry the fact in the existing ser->flags field, which commit
8a552d68a86e ("mm: memfd_luo: preserve file seals") added for exactly
this kind of extension ("Unused flag bits must be set to 0"): preserve
records whether the inode had exec bits, and retrieve reproduces them
by setting the mode of the fresh anonymous inode directly, before the
seals are re-applied -- the W^X rule in memfd_add_seals() looks at the
mode when it decides whether to imply the write seals, so the mode has
to be in place first.  The file is not published at that point, so no
other thread can observe the intermediate state.  Reusing the
MFD_NOEXEC_SEAL alloc flag was considered and dropped: it would
silently add F_SEAL_EXEC to memfds that never had it (a plain
non-executable memfd without the seal would come back with the seal
attached and its exec bits irrevocable), and it would couple the
restore to the current policy rather than to the state that was
preserved.  A record that does not say the bits were set is restored
without them -- which is what a memfd created under vm.memfd_noexec=2
looks like, and is also the safe reading for records written before
this bit existed.

With this, the round trip is exact: a NX memfd (0666 + 0x20) is
restored as 0666 + 0x20 and stays writable by its owner; a plain
non-executable memfd (0666, unsealed) stays 0666 and unsealed, its
exec bits still chmod-able; the baseline executable memfd stays 0777
and still execve's; and memfd_create() under vm.memfd_noexec=2 still
forces NX on fresh memfds.  No seal is invented for any of them.

Refusing to preserve memfds with F_SEAL_EXEC was considered and
rejected: with vm.memfd_noexec >= 1 every memfd created without an
explicit MFD_EXEC gets MFD_NOEXEC_SEAL forced on it (and = 2 refuses
the MFD_EXEC opt-out outright), so the refusal would disable the whole
preservation feature exactly on the systems that harden the most.
Preserving the full inode mode would be the alternative, but one bit in
the already-extensible flags field is sufficient and keeps the record
layout unchanged.

One point for the maintainers: a clear exec bit in a record is
ambiguous between "written before this bit existed" and "the bits were
clear", and both readings are safe -- the memfd comes back
non-executable, which is what a memfd created under vm.memfd_noexec=2
looks like.  For an old record it does change one case: an executable
memfd with F_SEAL_EXEC preserved by a kernel without this change is
restored as permanently non-executable instead of permanently
executable.  If that is not acceptable, the reading has to be tied to a
version bump instead: commit 8a552d68a86e ("mm: memfd_luo: preserve
file seals") already noted that new semantics may require one ("they
will need another version bump").

Measured on a QEMU live-update run (preserve -> kexec -> retrieve):
before the fix the restored NX memfd is mode 0777, seals 0x3e, execve
of its contents succeeds and the owner cannot write to it; with the
fix the same test reports the round trip exact (mode 0666, seals 0x20,
still writable, execve -> EACCES), a plain non-executable memfd comes
back 0666 with no seal and can be chmod'ed executable again, and the
baseline executable memfd and fresh memfds are unaffected.

Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
Assisted-by: Pi:glm-5.3-flash
Signed-off-by: Haolong Wang <18766350203@163.com>
---
 include/linux/kho/abi/memfd.h |  3 +++
 mm/memfd_luo.c                | 31 +++++++++++++++++++++++++++++--
 2 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..471cfe8a4616 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -87,6 +87,9 @@ struct memfd_luo_ser {
 	struct kho_vmalloc folios;
 } __packed;
 
+/* The execute bits were set on the memfd when its seals were applied. */
+#define MEMFD_LUO_FL_EXEC_BIT		BIT(0)
+
 /* The compatibility string for memfd file handler */
 #define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
 
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..950a43a4c328 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -300,6 +300,17 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	ser->size = inode_size;
 	ser->seals = seals;
 
+	/*
+	 * F_SEAL_EXEC freezes the exec bits as they are at sealing time, so
+	 * the restore has to reproduce them.  Record whether the inode had
+	 * exec bits here; the restore sets the mode of the fresh inode
+	 * accordingly before re-applying the seals.  ser is zero-initialized,
+	 * so a clear bit means the bits were clear (or the record predates
+	 * this flag -- the safe reading for those is also "no exec bits").
+	 */
+	if (inode->i_mode & 0111)
+		ser->flags |= MEMFD_LUO_FL_EXEC_BIT;
+
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
 	if (err)
@@ -533,8 +544,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	}
 
 	/*
-	 * The seals are preserved. Allow sealing here so they can be added
-	 * later.
+	 * F_SEAL_EXEC freezes the execute bits as they were when the seal was
+	 * applied, so the restore has to reproduce them.  A record that does
+	 * not say the bits were set is restored without them, which is what a
+	 * memfd created under vm.memfd_noexec=2 looks like and is also the safe
+	 * reading for records written before this flag existed.
 	 */
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
@@ -543,6 +557,19 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 		goto free_ser;
 	}
 
+	/*
+	 * Reproduce the exec bits before the seals are re-applied: F_SEAL_EXEC
+	 * freezes the bits as they were at sealing time, and the W^X rule in
+	 * memfd_add_seals() looks at the mode when it decides whether to imply
+	 * the write seals.  Setting the mode here, directly on the fresh
+	 * anonymous inode, is safe -- the file has not been published and no
+	 * other thread can reach it yet.
+	 */
+	if (ser->flags & MEMFD_LUO_FL_EXEC_BIT)
+		file->f_inode->i_mode |= 0111;
+	else
+		file->f_inode->i_mode &= ~0111;
+
 	err = memfd_add_seals(file, ser->seals);
 	if (err) {
 		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
-- 
2.56.0


