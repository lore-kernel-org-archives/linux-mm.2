Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E276CA9EBD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:53:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8219A6B0095; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786776B0099; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AEAC6B0095; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 103726B0096
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:52:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86CF0A041E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:53 +0000 (UTC)
X-FDA: 85319860626.16.04662A5
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by imf21.hostedemail.com (Postfix) with ESMTP id B3EA31C0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WhRSSLsb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf21.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791949971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8JnXAIap3aOxApSUaMZBVWmAhCs7y08UjaH2BAQYRPs=;
	b=fLKjKxukOzLi88/TscbjcirNaEMK0gNO1q4V2yk/AHVDQewtt9YnuEJrLYk9T2OLnINVO5
	0E2GCLBsv1dS04QvaAAMuAN6U5MD2ZB0KqaAhmcG+ov0nvnNE/ZnTFiDWaitHb+tAIsUVh
	Ib+PDkgILjje6MnxqtyC8wOutRGEmpM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WhRSSLsb;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf21.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.2 as permitted sender) smtp.mailfrom=18766350203@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791949971;
	b=KC3bC9yTkDP3+dowA6CLXYnEAFbAVa1BjEdHY6+9oVzZETYwFExi16gb9X1k1e8MXMAY/O
	B+a7h4C6b/11cSYQwY4iwSLWp6fl2JulM0Kb/IitOu+6NtK5jMZzk/LSpTyn8Cwuf2ruy+
	eYzgkZA5Fe4kRtev7pCAMvh72wsfwes=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=8J
	nXAIap3aOxApSUaMZBVWmAhCs7y08UjaH2BAQYRPs=; b=WhRSSLsbz5Ykqj5GE0
	r6oPHptTiaYOz4/l8YHNWli7X+a/skuaVIiRPDEmpYBiJ3e4g4rn8YG7PM5zNJtB
	YJTv+FjaT+Z4jQeefYTc50EFwcJOcVAghHfB7e590nJVpI/cc7u9ypkf2Ok56Sgz
	l/FeJZVUmJ3GFpdx8WMasnA0k=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBncnaF_M5qUtfjEQ--.37990S4;
	Wed, 14 Oct 2026 11:52:41 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] mm/memfd_luo: carry the sealed exec-bit state in the preserved record
Date: Wed, 14 Oct 2026 11:52:27 +0800
Message-ID: <20261014035228.473825-3-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014035228.473825-1-18766350203@163.com>
References: <20261014035228.473825-1-18766350203@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBncnaF_M5qUtfjEQ--.37990S4
X-Coremail-Antispam: 1Uf129KBjvAXoWfur1xJr13Xr4Utw1fAr4ruFg_yoW5CryDZo
	WFqwsxXr48Kr13Gas8GF18Gry3Wa4kur13Jw1FvrW5CFnFqryjy347uFW3Jay3Xr1Yq39x
	A34xXa1UGF9ayFn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU3CD7UUUUU
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC1Aqvd2rO-IpOigAA3Q
X-Stat-Signature: hmp5px9h7psggi19xamqwz6uqk3ggiob
X-Rspam-User: 
X-Rspamd-Queue-Id: B3EA31C0004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791949970-384480
X-HE-Meta: U2FsdGVkX1+eaoSJ81OTiRWo5a/TkylSwOPn8LupQ/FMUlszE6QP/9MfjC6VkjfHf4GVjcf73jdrdxW2hVROuRtXE2MnT0QZRyZXI48cRgggISt5HNYHfu5VblF6KSbUu3+6otyCnddeSYf2zz8j1vBjusxJgR+ZMxIR+VDT4wEbwN8Cak8ZX1Dc3EJBAZbycxHGssH6oiL5ia/LkP3EXRf3A6T8/p5uGeS8RHXYIIp4fj2gr+CqjU3YlDTEgb6yO5CzWqN6jQxx+XzdGdTEP4X2q+/Ely/hwJpWhh7AQopNFeXrnFjrZDuVvyinuBGERnAPyes95wgnW2lQjjBQOLwMl/8vM6hYDPHa+MPy6TM0MmAPgLy5o8PQ2/91Oe3kfr9DLYw30+v5GhWt+4XPmH/h8/evEIiZTnfzAVmRtB5M5UJd/oQIvtmxVW+CotV4lUqpuNlFsTtfOEYkDu4OhEHbRlo8u2cgUfbv3XNHp4rZZNvQRy9NYolFVxOJfM7ZLje1l6XAsW+/8uAq/UKPivUhQnsO9ycvUnIDjXU1h8SEz944M2IRMP596UeHBxSW+EjP0Jco6r+4EJ+7BXYE1Iq/xLC7qAEjvu2qfks67LTQu3B5yErCeCTZo6oylIseX6k0h8oogr272j1LCJNhtllp3eAvFtn2XZa5ntQtGULQv0DzmQayRVJ9Vyx0aNVM63yka6QVoQ9UvDiEgyk2YF0xUeWUtmgUCIbUD/OoCwJDQbitRwY96Tgn8hu/prcn6Mtq8rO87Q6pWfQCxQJ66pgjYalRFV+LQdPMVeRV3+LNUxl6jxvGLOkf6nm3ErYWaETKxOYpv92hJvHCk7CBX9JVjk8BMBBsBEnobN2nMWxn1KzBXutzkg3MJr6zcDc8vNBUjgl8qQ7y8hV/B3UHZl7UzhoXeBK1lrCThcYSBgAMYW7niIpBb7jH9U9CnDmnoe5npPl4nuNofVjuAhq
 ku17VQiN
 J2to3trzrBo+c4NwvC0idrv9Qv2NBFl0LbnvItROXLm/7tSBVbzw2kFmJpAMqZVIN2MLIrJgWEKZcQiUmidCUEY2lwZ9dxuAPrKyrk4Ppxiqh0Yv83szhzbzpNQsxaawWimnRQoHqufYxYA0xvOKpUlyafPHeu/6lAxxg1p554MI1JnI/0zpDfOelppho5zcDcW3KC+CvDAlFkNK8RBOSgjiXGWmtEQfSC28QNe+jmV86AUbE7K9N+EifDrlMDYPpusCRbt7I1IWaz597APgefQj6fbydOg+1VGu6YUHx8tWSLATsFRNYEGkw9B84JdMWEpTTT9KrNpm+X2DuaOwS9L6TVDLKHW0bEVa3ZGbVPX7F5lcbx0CdBCW98dT3hfzzqePmTziH0Ac7JYWsBg2oxL1zDtb9xNhLXYy6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

F_SEAL_EXEC freezes the execute bits as they are at sealing time: a memfd
becomes permanently executable or permanently un-executable, bit by bit.
The preserved state of a memfd (struct memfd_luo_ser) carries the seals
but not the inode mode, and the restore path creates the file with
memfd_alloc_file("", MFD_ALLOW_SEALING) -- the default 0777 -- without
consulting the vm.memfd_noexec policy (that policy is applied on the
memfd_create() syscall path only).

A memfd whose execute mask was 0000 and whose seal set was F_SEAL_EXEC is
therefore restored with an execute mask of 0111 and F_SEAL_EXEC
re-applied on top of it: the guarantee inverts, and it is the seal that
made the memfd safe.  Because the restored file is executable,
memfd_add_seals() also implies F_SEAL_WRITE, F_SEAL_FUTURE_WRITE,
F_SEAL_SHRINK and F_SEAL_GROW (the W^X rule), so the restored memfd comes
back with its write seals locked and its execute mask permanently
irrevocable (shmem_setattr() rejects any exec-bit change).  This is a
functional regression that needs no attacker: the owner's own pwrite() to
the memfd succeeds before the update and fails with EPERM after it.  The
inversion is also silent: F_GET_SEALS keeps reporting the seal.

Carry the state in the existing ser->flags field, which commit
8a552d68a86e ("mm: memfd_luo: preserve file seals") added for exactly
this kind of extension ("Unused flag bits must be set to 0"): preserve
records the user/group/other execute bits separately, retrieve restores
the exact mask on the fresh anonymous inode before the seals are
re-applied -- the W^X rule in memfd_add_seals() looks at the mode when it
decides whether to imply the write seals, so the mode has to be in place
first -- and a record with flag bits this version does not know is
rejected with -EOPNOTSUPP.  The file is not published at that point, so
no other thread can observe the intermediate state.  Only the execute
bits are carried: the read/write bits are not preserved today, so they
keep coming back at their 0666 default (0777 minus the execute bits).

A single "some execute bit was set" flag was considered first and
dropped: it turns an execute mask of 0100 (mode 0700) into 0111, which is
the very inversion this change is about, and it is the case
tools/testing/selftests/memfd/memfd_test.c asserts against.  Reusing the
MFD_NOEXEC_SEAL alloc flag was also considered and dropped: it would
silently add F_SEAL_EXEC to memfds that never had it (a plain
non-executable memfd without the seal would come back with the seal
attached and its execute bits irrevocable), and it would couple the
restore to the current policy rather than to the state that was
preserved.  A record that does not say a bit was set is restored without
it -- which is what a memfd created under vm.memfd_noexec=2 looks like,
and is also the safe reading for records written before these flags
existed (they are read through a separate handler, see "Record versions"
below).

The memfd stays usable between preserve() and freeze(): the frozen
mapping only pins down the size and the folios, while the file position,
the execute bits (as long as F_SEAL_EXEC is not set) and the seals can
still change.  A seal added after preserve() would not be in the record,
and a chmod() that clears the execute bits would be lost, turning the W^X
state of the restored file around.  freeze() is the last point at which
the record can be updated before it is handed to the next kernel, so it
re-samples the execute mask, the seals and the file position under the
inode lock that memfd_add_seals(), shmem_setattr() and shmem_set_acl()
also take, and, in the same critical section, freezes that state for the
rest of the transition: a change made after the sample cannot diverge
from the record either.  The state is cleared again by the new .unfreeze
callback when the update is rolled back, and defensively by unpreserve().
A file that gained seals this version does not know fails the freeze,
which aborts the live update instead of handing over a stale record.  The
ACL path is included because an access ACL rewrites inode->i_mode from
posix_acl_update_mode() without going through shmem_setattr(); the same
hole lets an access ACL rewrite the execute bits of a memfd that
F_SEAL_EXEC is supposed to protect, which is a pre-existing issue and is
left to a separate report.

With this, the execute mask and the seal set round-trip exactly: a memfd
without execute bits (execute mask 0000, seal set 0x20, which is what
MFD_NOEXEC_SEAL and vm.memfd_noexec=2 produce) comes back with the same
execute mask and seal set and stays writable by its owner; a memfd whose
execute mask was 0100 and whose seal set was 0x3e (F_SEAL_EXEC plus the
write seals the W^X rule implies) is restored with the same execute mask
and seal set, instead of an execute mask of 0111; a plain non-executable
memfd (0666, unsealed) stays unsealed with chmod-able execute bits; the
baseline executable memfd stays 0777 and still execve's; and
memfd_create() under vm.memfd_noexec=2 still forces NX on fresh memfds.
No seal is invented for any of them.

Measured on a QEMU live-update run (preserve -> kexec -> retrieve) with
this selftest: the memfd whose execute mask was 0100 and whose seal set
was 0x3e comes back with the same execute mask and the same seal set, and
the memfd without execute bits comes back with mask 0000, seal set 0x20,
its data intact and still writable by its owner.  The same test against a
kernel without this change reports "execute mask changed across kexec:
0111 != 0100".

Refusing to preserve memfds with F_SEAL_EXEC was considered and rejected:
with vm.memfd_noexec >= 1 every memfd created without an explicit MFD_EXEC
gets MFD_NOEXEC_SEAL forced on it (and = 2 refuses the MFD_EXEC opt-out
outright), so the refusal would disable the whole preservation feature
exactly on the systems that harden the most.  Preserving the full inode
mode would be the alternative, but three bits in the already-extensible
flags field are enough to reproduce the state F_SEAL_EXEC protects, and
the record layout is unchanged.

Record versions.  The flags cannot tell "the execute bits were clear"
apart from "the writer did not know about the flags", so a record written
before the flags existed has to be told apart by the version string, which
is compared with strcmp().  The version is therefore bumped to
"memfd-v3" and a read-only handler for "memfd-v2" is registered next to
the current one:

  record writer   reading kernel and handler     result
  old v2          old kernel, v2 handler         default executable mode
  old v2          new kernel, legacy v2 reader   no execute bits
  new v3          new kernel, v3 handler         exact exec mask and seals
  new v3          old kernel                     no handler, -ENOENT

The legacy handler only reads records written by an older kernel: its
.can_preserve() always returns false, so it is never selected for an
outgoing preservation and every new record is serialized as "memfd-v3";
a "memfd-v3" record is never handed to it either, because the compatible
strings have to match exactly.

The second row is a one-time behaviour change for records written by a
kernel without these flags: an executable memfd preserved by such a kernel
comes back without execute bits.  That is the safe reading, but it is not
what the old reader did -- it never looked at the flags and restored the
default (executable) mode -- so it is a change for every such record, not
only for the ones sealed with F_SEAL_EXEC.  Without the version bump an
old kernel would instead read a new record, ignore the flags and restore
the default executable mode, undoing exactly the guarantee this patch
restores; with "memfd-v3" it has no matching handler at all, so the
deserialization of that session fails with -ENOENT instead of the memfd
being restored wrongly.

Changes in v2:
 - record the three execute bits separately: a single "some execute bit
   was set" flag restored an execute mask of 0100 as 0111
 - take the final sample of the execute mask and the seals at freeze()
   time: the memfd stays usable between preserve() and freeze(), so a
   change in that window used to be lost (reported by Sashiko AI review)
 - freeze that state for the rest of the transition (shmem_setattr(),
   shmem_set_acl(), memfd_add_seals()), cleared by .unfreeze on rollback
 - reject records with flag bits this version does not know
 - bump the record version to "memfd-v3" and keep reading "memfd-v2"
   records through a read-only handler: flags == 0 is read as "no execute
   bits", which is a one-time change for the executable memfds written by
   an older kernel
 - selftest: an execute mask of 0100 with the full 0x3e seal set, a memfd
   without execute bits (MFD_NOEXEC_SEAL, seal set 0x20, still writable),
   and a skip when vm.memfd_noexec forbids MFD_EXEC
 - document the execute bits the record carries and the restrictions that
   apply once the update is committed to

Fixes: 8a552d68a86e ("mm: memfd_luo: preserve file seals")
Assisted-by: Pi:glm-5.3-flash
Signed-off-by: Haolong Wang <18766350203@163.com>
---
 include/linux/kho/abi/memfd.h                 |  24 +-
 include/linux/shmem_fs.h                      |  20 ++
 mm/memfd.c                                    |   6 +
 mm/memfd_luo.c                                | 162 +++++++++++++-
 mm/shmem.c                                    |  35 ++-
 .../selftests/liveupdate/luo_kexec_simple.c   | 208 ++++++++++++++++++
 6 files changed, 437 insertions(+), 18 deletions(-)

diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
index 08b10fea2afc..f773dd95401d 100644
--- a/include/linux/kho/abi/memfd.h
+++ b/include/linux/kho/abi/memfd.h
@@ -87,7 +87,29 @@ struct memfd_luo_ser {
 	struct kho_vmalloc folios;
 } __packed;
 
+/*
+ * The execute permission bits are packed in user/group/other order.  A record
+ * with none of these flags set is restored without execute permissions, which
+ * is also the safe interpretation for records written before these flags
+ * existed.
+ */
+#define MEMFD_LUO_FL_EXEC_USR		BIT(0)
+#define MEMFD_LUO_FL_EXEC_GRP		BIT(1)
+#define MEMFD_LUO_FL_EXEC_OTH		BIT(2)
+#define MEMFD_LUO_FL_EXEC_MASK		(MEMFD_LUO_FL_EXEC_USR | \
+					 MEMFD_LUO_FL_EXEC_GRP | \
+					 MEMFD_LUO_FL_EXEC_OTH)
+#define MEMFD_LUO_ALL_FLAGS		MEMFD_LUO_FL_EXEC_MASK
+
 /* The compatibility string for memfd file handler */
-#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
+#define MEMFD_LUO_FH_COMPATIBLE		"memfd-v3"
+/*
+ * Records written before the execute-bit flags existed.  They carry no flag
+ * bits and are restored without execute permissions: the flags cannot tell
+ * "the execute bits were clear" and "the writer did not know about the flags"
+ * apart, and restoring without them is the safe reading.  The current kernel
+ * still accepts these records but never writes them.
+ */
+#define MEMFD_LUO_FH_COMPATIBLE_V2	"memfd-v2"
 
 #endif /* _LINUX_KHO_ABI_MEMFD_H */
diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index e729b9b0e38d..40e1ce87c30e 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -32,6 +32,12 @@ struct swap_iocb;
  * isn't directly visible to userspace.
  */
 #define SHMEM_F_MAPPING_FROZEN	BIT(2)
+/*
+ * Disallow changes to the seal set and execute bits captured by the final LUO
+ * snapshot.  This is set only for the reboot transition and is cleared if the
+ * transition is rolled back.
+ */
+#define SHMEM_F_SEAL_STATE_FROZEN	BIT(3)
 
 struct shmem_inode_info {
 	spinlock_t		lock;
@@ -208,6 +214,20 @@ static inline void shmem_freeze(struct inode *inode, bool freeze)
 		SHMEM_I(inode)->flags &= ~SHMEM_F_MAPPING_FROZEN;
 }
 
+/* Must be called with inode lock taken exclusive. */
+static inline void shmem_freeze_seal_state(struct inode *inode, bool freeze)
+{
+	if (freeze)
+		SHMEM_I(inode)->flags |= SHMEM_F_SEAL_STATE_FROZEN;
+	else
+		SHMEM_I(inode)->flags &= ~SHMEM_F_SEAL_STATE_FROZEN;
+}
+
+static inline bool shmem_seal_state_frozen(struct inode *inode)
+{
+	return SHMEM_I(inode)->flags & SHMEM_F_SEAL_STATE_FROZEN;
+}
+
 /*
  * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
  * beyond i_size's notion of EOF, which fallocate has committed to reserving:
diff --git a/mm/memfd.c b/mm/memfd.c
index abe13b291ddc..578ac31ed1a9 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -278,6 +278,12 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 		goto unlock;
 	}
 
+	/* LUO has taken its final snapshot; do not let the seal set diverge. */
+	if (shmem_file(file) && shmem_seal_state_frozen(inode)) {
+		error = -EPERM;
+		goto unlock;
+	}
+
 	if (*file_seals & F_SEAL_SEAL) {
 		error = -EPERM;
 		goto unlock;
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6f8b84530995..333502ea3735 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -50,6 +50,16 @@
  *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
  *   is maintained.
  *
+ * Execute Permission Bits
+ *   The user, group, and other execute bits are preserved individually. This
+ *   is required to faithfully restore the state protected by ``F_SEAL_EXEC``.
+ *
+ * .. note::
+ *    A record written by an older kernel (``memfd-v2``) does not carry the
+ *    execute bits.  It is restored without execute permissions, which is the
+ *    safe reading: an executable memfd preserved by such a kernel comes back
+ *    non-executable, and the next update records the exact state.
+ *
  * Seals
  *   File seals set on the memfd are preserved and re-applied on restore.
  *   Only seals known to this LUO version (see ``MEMFD_LUO_ALL_SEALS``) may
@@ -84,6 +94,35 @@
 
 #include "internal.h"
 
+static void memfd_luo_record_exec_mode(struct memfd_luo_ser *ser, umode_t mode)
+{
+	u32 flags = 0;
+
+	if (mode & 0100)
+		flags |= MEMFD_LUO_FL_EXEC_USR;
+	if (mode & 0010)
+		flags |= MEMFD_LUO_FL_EXEC_GRP;
+	if (mode & 0001)
+		flags |= MEMFD_LUO_FL_EXEC_OTH;
+
+	ser->flags &= ~MEMFD_LUO_FL_EXEC_MASK;
+	ser->flags |= flags;
+}
+
+static umode_t memfd_luo_restore_exec_mode(u32 flags)
+{
+	umode_t mode = 0;
+
+	if (flags & MEMFD_LUO_FL_EXEC_USR)
+		mode |= 0100;
+	if (flags & MEMFD_LUO_FL_EXEC_GRP)
+		mode |= 0010;
+	if (flags & MEMFD_LUO_FL_EXEC_OTH)
+		mode |= 0001;
+
+	return mode;
+}
+
 static int memfd_luo_preserve_folios(struct file *file,
 				     struct kho_vmalloc *kho_vmalloc,
 				     struct memfd_luo_folio_ser **out_folios_ser,
@@ -300,6 +339,14 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 	ser->size = inode_size;
 	ser->seals = seals;
 
+	/*
+	 * F_SEAL_EXEC freezes each execute permission bit independently, so
+	 * preserve the complete user/group/other execute mask.  A record with no
+	 * execute flags is restored without execute permissions, which is also
+	 * the safe interpretation for records written before these flags existed.
+	 */
+	memfd_luo_record_exec_mode(ser, inode->i_mode);
+
 	err = memfd_luo_preserve_folios(args->file, &ser->folios,
 					&folios_ser, &nr_folios);
 	if (err)
@@ -323,7 +370,9 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
 
 static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 {
+	struct inode *inode = file_inode(args->file);
 	struct memfd_luo_ser *ser;
+	int seals;
 
 	if (WARN_ON_ONCE(!args->serialized_data))
 		return -EINVAL;
@@ -331,14 +380,47 @@ static int memfd_luo_freeze(struct liveupdate_file_op_args *args)
 	ser = phys_to_virt(args->serialized_data);
 
 	/*
-	 * The pos might have changed since prepare. Everything else stays the
-	 * same.
+	 * The file is still usable between preserve() and freeze(), so its mode
+	 * and seals can differ from the values recorded by preserve().  Take the
+	 * final snapshot under the inode lock shared with memfd_add_seals(),
+	 * shmem_setattr(), and shmem_set_acl(), then freeze those state fields
+	 * before dropping the lock.  This closes the window in which a later
+	 * chmod(), ACL update, or F_ADD_SEALS could otherwise diverge from the
+	 * state handed to the next kernel.
 	 */
+	inode_lock(inode);
+
+	seals = memfd_get_seals(args->file);
+	if (seals < 0) {
+		inode_unlock(inode);
+		return seals;
+	}
+
+	/* The file must not have gained seals that this version does not know. */
+	if (seals & ~MEMFD_LUO_ALL_SEALS) {
+		inode_unlock(inode);
+		return -EOPNOTSUPP;
+	}
+
+	memfd_luo_record_exec_mode(ser, inode->i_mode);
+	ser->seals = seals;
 	ser->pos = args->file->f_pos;
+	shmem_freeze_seal_state(inode, true);
+
+	inode_unlock(inode);
 
 	return 0;
 }
 
+static void memfd_luo_unfreeze(struct liveupdate_file_op_args *args)
+{
+	struct inode *inode = file_inode(args->file);
+
+	inode_lock(inode);
+	shmem_freeze_seal_state(inode, false);
+	inode_unlock(inode);
+}
+
 static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 {
 	struct inode *inode = file_inode(args->file);
@@ -348,6 +430,7 @@ static void memfd_luo_unpreserve(struct liveupdate_file_op_args *args)
 		return;
 
 	inode_lock(inode);
+	shmem_freeze_seal_state(inode, false);
 	shmem_freeze(inode, false);
 
 	ser = phys_to_virt(args->serialized_data);
@@ -520,14 +603,16 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct memfd_luo_folio_ser *folios_ser;
 	struct memfd_luo_ser *ser;
 	struct file *file;
+	umode_t exec_mode;
 	int err;
 
 	ser = phys_to_virt(args->serialized_data);
 	if (!ser)
 		return -EINVAL;
 
-	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
+	/* Make sure the record only contains state supported by this version. */
+	if ((ser->seals & ~MEMFD_LUO_ALL_SEALS) ||
+	    (ser->flags & ~MEMFD_LUO_ALL_FLAGS)) {
 		err = -EOPNOTSUPP;
 		goto free_ser;
 	}
@@ -543,6 +628,17 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 		goto free_ser;
 	}
 
+	/*
+	 * Reproduce the exact execute mask before the seals are re-applied:
+	 * F_SEAL_EXEC freezes each execute bit, and the W^X rule in
+	 * memfd_add_seals() looks at the mode when deciding whether to imply the
+	 * write seals.  The fresh anonymous inode has not been published, so no
+	 * other thread can observe this intermediate state.
+	 */
+	exec_mode = memfd_luo_restore_exec_mode(ser->flags);
+	file->f_inode->i_mode &= ~0111;
+	file->f_inode->i_mode |= exec_mode;
+
 	err = memfd_add_seals(file, ser->seals);
 	if (err) {
 		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
@@ -597,6 +693,7 @@ static unsigned long memfd_luo_get_id(struct file *file)
 
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
+	.unfreeze = memfd_luo_unfreeze,
 	.finish = memfd_luo_finish,
 	.retrieve = memfd_luo_retrieve,
 	.preserve = memfd_luo_preserve,
@@ -611,15 +708,62 @@ static struct liveupdate_file_handler memfd_luo_handler = {
 	.compatible = MEMFD_LUO_FH_COMPATIBLE,
 };
 
+/*
+ * Reads records written before the execute-bit flags existed.  Those have no
+ * flag bits and are restored without execute permissions (see the note on
+ * old records in the DOC section above).  can_preserve() never claims a file,
+ * so an outgoing preservation is always written by the handler above and
+ * never as "memfd-v2".
+ */
+static bool memfd_luo_can_preserve_v2(struct liveupdate_file_handler *handler,
+				      struct file *file)
+{
+	return false;
+}
+
+static const struct liveupdate_file_ops memfd_luo_file_ops_v2 = {
+	.freeze = memfd_luo_freeze,
+	.unfreeze = memfd_luo_unfreeze,
+	.finish = memfd_luo_finish,
+	.retrieve = memfd_luo_retrieve,
+	.preserve = memfd_luo_preserve,
+	.unpreserve = memfd_luo_unpreserve,
+	.can_preserve = memfd_luo_can_preserve_v2,
+	.get_id = memfd_luo_get_id,
+	.owner = THIS_MODULE,
+};
+
+static struct liveupdate_file_handler memfd_luo_handler_v2 = {
+	.ops = &memfd_luo_file_ops_v2,
+	.compatible = MEMFD_LUO_FH_COMPATIBLE_V2,
+};
+
 static int __init memfd_luo_init(void)
 {
-	int err = liveupdate_register_file_handler(&memfd_luo_handler);
+	int err;
+
+	err = liveupdate_register_file_handler(&memfd_luo_handler);
+	if (err) {
+		if (err != -EOPNOTSUPP) {
+			pr_err("Could not register luo filesystem handler: %pe\n",
+			       ERR_PTR(err));
+			return err;
+		}
+
+		return 0;
+	}
 
-	if (err && err != -EOPNOTSUPP) {
-		pr_err("Could not register luo filesystem handler: %pe\n",
-		       ERR_PTR(err));
+	err = liveupdate_register_file_handler(&memfd_luo_handler_v2);
+	if (err) {
+		liveupdate_unregister_file_handler(&memfd_luo_handler);
+
+		if (err != -EOPNOTSUPP) {
+			pr_err("Could not register the memfd-v2 record reader: %pe\n",
+			       ERR_PTR(err));
+			return err;
+		}
 
-		return err;
+		return 0;
 	}
 
 	return 0;
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..55f4dbd429eb 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1326,11 +1326,10 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 	if (error)
 		return error;
 
-	if ((info->seals & F_SEAL_EXEC) && (attr->ia_valid & ATTR_MODE)) {
-		if ((inode->i_mode ^ attr->ia_mode) & 0111) {
-			return -EPERM;
-		}
-	}
+	if ((attr->ia_valid & ATTR_MODE) &&
+	    ((info->seals & F_SEAL_EXEC) || shmem_seal_state_frozen(inode)) &&
+	    ((inode->i_mode ^ attr->ia_mode) & 0111))
+		return -EPERM;
 
 	if (S_ISREG(inode->i_mode) && (attr->ia_valid & ATTR_SIZE)) {
 		loff_t oldsize = inode->i_size;
@@ -1394,6 +1393,24 @@ static int shmem_setattr(struct mnt_idmap *idmap,
 	return error;
 }
 
+#ifdef CONFIG_TMPFS_POSIX_ACL
+static int shmem_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
+			 struct posix_acl *acl, int type)
+{
+	struct inode *inode = d_inode(dentry);
+
+	/*
+	 * An access ACL can rewrite the inode's execute bits without going
+	 * through shmem_setattr().  Once LUO has captured its final seal/mode
+	 * snapshot, reject that alternate mutation path as well.
+	 */
+	if (type == ACL_TYPE_ACCESS && shmem_seal_state_frozen(inode))
+		return -EPERM;
+
+	return simple_set_acl(idmap, dentry, acl, type);
+}
+#endif
+
 static void shmem_evict_inode(struct inode *inode)
 {
 	struct shmem_inode_info *info = SHMEM_I(inode);
@@ -5156,7 +5173,9 @@ static const struct inode_operations shmem_inode_operations = {
 	.setattr	= shmem_setattr,
 #ifdef CONFIG_TMPFS_XATTR
 	.listxattr	= shmem_listxattr,
-	.set_acl	= simple_set_acl,
+#ifdef CONFIG_TMPFS_POSIX_ACL
+	.set_acl	= shmem_set_acl,
+#endif
 	.fileattr_get	= shmem_fileattr_get,
 	.fileattr_set	= shmem_fileattr_set,
 #endif
@@ -5184,7 +5203,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
-	.set_acl	= simple_set_acl,
+	.set_acl	= shmem_set_acl,
 #endif
 };
 
@@ -5195,7 +5214,7 @@ static const struct inode_operations shmem_special_inode_operations = {
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
-	.set_acl	= simple_set_acl,
+	.set_acl	= shmem_set_acl,
 #endif
 };
 
diff --git a/tools/testing/selftests/liveupdate/luo_kexec_simple.c b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
index d7ac1f3dc4cb..30836043f894 100644
--- a/tools/testing/selftests/liveupdate/luo_kexec_simple.c
+++ b/tools/testing/selftests/liveupdate/luo_kexec_simple.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define _GNU_SOURCE
 
 /*
  * Copyright (c) 2025, Google LLC.
@@ -8,16 +9,211 @@
  * across a single kexec reboot.
  */
 
+#include <fcntl.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
+
+#include <linux/memfd.h>
+
 #include "luo_test_utils.h"
 
+#ifndef F_SEAL_SHRINK
+#define F_SEAL_SHRINK 0x0002
+#endif
+#ifndef F_SEAL_GROW
+#define F_SEAL_GROW 0x0004
+#endif
+#ifndef F_SEAL_WRITE
+#define F_SEAL_WRITE 0x0008
+#endif
+#ifndef F_SEAL_FUTURE_WRITE
+#define F_SEAL_FUTURE_WRITE 0x0010
+#endif
+#ifndef F_SEAL_EXEC
+#define F_SEAL_EXEC 0x0020
+#endif
+#ifndef MFD_NOEXEC_SEAL
+#define MFD_NOEXEC_SEAL 0x0008U
+#endif
+
+/*
+ * F_SEAL_EXEC implies the write seals when the memfd has execute bits (the
+ * W^X rule in memfd_add_seals()), so a memfd that was chmod()ed to 0700
+ * before F_SEAL_EXEC was added ends up with exactly this seal set.
+ */
+#define F_WX_SEALS	(F_SEAL_EXEC | F_SEAL_SHRINK | F_SEAL_GROW | \
+			 F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)
+
 #define TEST_SESSION_NAME "test-session"
 #define TEST_MEMFD_TOKEN 0x1A
+#define TEST_EXEC_MEMFD_TOKEN 0x1B
+#define TEST_NX_MEMFD_TOKEN 0x1C
 #define TEST_MEMFD_DATA "hello kexec world"
 
 /* Constants for the state-tracking mechanism, specific to this test file. */
 #define STATE_SESSION_NAME "kexec_simple_state"
 #define STATE_MEMFD_TOKEN 999
 
+static void create_and_preserve_exec_memfd(int session_fd)
+{
+	struct liveupdate_session_preserve_fd arg = {
+		.size = sizeof(arg),
+		.token = TEST_EXEC_MEMFD_TOKEN,
+	};
+	int mfd, seals;
+
+	mfd = memfd_create("exec-mode-test", MFD_ALLOW_SEALING | MFD_EXEC);
+	if (mfd < 0) {
+		/* vm.memfd_noexec=2 refuses the MFD_EXEC opt-out. */
+		if (errno == EACCES)
+			ksft_exit_skip("vm.memfd_noexec forbids MFD_EXEC\n");
+		fail_exit("memfd_create for execute-mode test");
+	}
+
+	if (fchmod(mfd, 0700) < 0)
+		fail_exit("fchmod for execute-mode test");
+	if (fcntl(mfd, F_ADD_SEALS, F_SEAL_EXEC) < 0)
+		fail_exit("F_ADD_SEALS for execute-mode test");
+
+	/* The execute bits pull in the write seals: record the whole set. */
+	seals = fcntl(mfd, F_GET_SEALS);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS for execute-mode test");
+	if (seals != F_WX_SEALS)
+		ksft_exit_fail_msg("execute-mode seals 0x%x != 0x%x\n", seals,
+				   F_WX_SEALS);
+	ksft_print_msg("[STAGE 1] exec-mode memfd: execute mask 0100, seals 0x%x\n",
+		       seals);
+
+	arg.fd = mfd;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0)
+		fail_exit("preserve execute-mode memfd");
+
+	close(mfd);
+}
+
+static void restore_and_verify_exec_memfd(int session_fd)
+{
+	struct liveupdate_session_retrieve_fd arg = {
+		.size = sizeof(arg),
+		.token = TEST_EXEC_MEMFD_TOKEN,
+	};
+	struct stat st;
+	int mfd, seals;
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
+		fail_exit("retrieve execute-mode memfd");
+	mfd = arg.fd;
+
+	if (fstat(mfd, &st) < 0)
+		fail_exit("fstat execute-mode memfd");
+	if ((st.st_mode & 0111) != 0100)
+		ksft_exit_fail_msg("execute mask changed across kexec: 0%o != 0100\n",
+				   st.st_mode & 0111);
+
+	seals = fcntl(mfd, F_GET_SEALS);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS for execute-mode test");
+	if (seals != F_WX_SEALS)
+		ksft_exit_fail_msg("seals changed across kexec: 0x%x != 0x%x\n",
+				   seals, F_WX_SEALS);
+
+	ksft_print_msg("[STAGE 2] exec-mode memfd: execute mask 0%o, seals 0x%x\n",
+		       st.st_mode & 0111, seals);
+
+	close(mfd);
+}
+
+/*
+ * The originally reported case: a memfd without execute bits and with
+ * F_SEAL_EXEC (what memfd_create(MFD_NOEXEC_SEAL) and vm.memfd_noexec=2
+ * produce) has to come back without execute bits, with the same seal set, and
+ * still writable by its owner -- F_SEAL_EXEC must not drag in the write seals
+ * for a memfd that has no execute bits.
+ */
+static void create_and_preserve_nx_memfd(int session_fd)
+{
+	struct liveupdate_session_preserve_fd arg = {
+		.size = sizeof(arg),
+		.token = TEST_NX_MEMFD_TOKEN,
+	};
+	struct stat st;
+	int mfd, seals;
+
+	mfd = memfd_create("nx-mode-test", MFD_ALLOW_SEALING | MFD_NOEXEC_SEAL);
+	if (mfd < 0)
+		fail_exit("memfd_create for NX-mode test");
+
+	if (fstat(mfd, &st) < 0)
+		fail_exit("fstat for NX-mode test");
+	if (st.st_mode & 0111)
+		ksft_exit_fail_msg("NX-mode memfd has execute bits (0%o)\n",
+				   st.st_mode);
+
+	seals = fcntl(mfd, F_GET_SEALS);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS for NX-mode test");
+	if (seals != F_SEAL_EXEC)
+		ksft_exit_fail_msg("NX-mode seals 0x%x != 0x%x\n", seals,
+				   F_SEAL_EXEC);
+
+	if (pwrite(mfd, TEST_MEMFD_DATA, sizeof(TEST_MEMFD_DATA) - 1, 0) !=
+	    sizeof(TEST_MEMFD_DATA) - 1)
+		fail_exit("NX-mode memfd is not writable");
+
+	ksft_print_msg("[STAGE 1] NX-mode memfd: execute mask 0000, seals 0x%x\n",
+		       seals);
+
+	arg.fd = mfd;
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg) < 0)
+		fail_exit("preserve NX-mode memfd");
+
+	close(mfd);
+}
+
+static void restore_and_verify_nx_memfd(int session_fd)
+{
+	struct liveupdate_session_retrieve_fd arg = {
+		.size = sizeof(arg),
+		.token = TEST_NX_MEMFD_TOKEN,
+	};
+	char buf[sizeof(TEST_MEMFD_DATA)] = {0};
+	struct stat st;
+	int mfd, seals;
+
+	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg) < 0)
+		fail_exit("retrieve NX-mode memfd");
+	mfd = arg.fd;
+
+	if (fstat(mfd, &st) < 0)
+		fail_exit("fstat NX-mode memfd");
+	if (st.st_mode & 0111)
+		ksft_exit_fail_msg("NX memfd came back executable: execute mask 0%o\n",
+				   st.st_mode & 0111);
+
+	seals = fcntl(mfd, F_GET_SEALS);
+	if (seals < 0)
+		fail_exit("F_GET_SEALS for NX-mode test");
+	if (seals != F_SEAL_EXEC)
+		ksft_exit_fail_msg("NX memfd seals 0x%x != 0x%x\n", seals,
+				   F_SEAL_EXEC);
+
+	if (pread(mfd, buf, sizeof(buf) - 1, 0) != sizeof(buf) - 1)
+		fail_exit("pread NX-mode memfd");
+	if (strcmp(buf, TEST_MEMFD_DATA))
+		ksft_exit_fail_msg("NX memfd data changed: %s\n", buf);
+
+	if (pwrite(mfd, "x", 1, 0) != 1)
+		ksft_exit_fail_msg("NX memfd is not writable by its owner\n");
+
+	ksft_print_msg("[STAGE 2] NX-mode memfd: execute mask 0000, seals 0x%x, writable\n",
+		       seals);
+
+	close(mfd);
+}
+
 /* Stage 1: Executed before the kexec reboot. */
 static void run_stage_1(int luo_fd)
 {
@@ -40,6 +236,12 @@ static void run_stage_1(int luo_fd)
 			  TEST_MEMFD_TOKEN);
 	}
 
+	ksft_print_msg("[STAGE 1] Preserving mode 0700 + F_SEAL_EXEC memfd...\n");
+	create_and_preserve_exec_memfd(session_fd);
+
+	ksft_print_msg("[STAGE 1] Preserving NX (no execute bits) + F_SEAL_EXEC memfd...\n");
+	create_and_preserve_nx_memfd(session_fd);
+
 	close(luo_fd);
 	daemonize_and_wait();
 }
@@ -68,6 +270,12 @@ static void run_stage_2(int luo_fd, int state_session_fd)
 		fail_exit("restore_and_verify_memfd for token %#x", TEST_MEMFD_TOKEN);
 	close(mfd);
 
+	ksft_print_msg("[STAGE 2] Verifying exact execute-mode round trip...\n");
+	restore_and_verify_exec_memfd(session_fd);
+
+	ksft_print_msg("[STAGE 2] Verifying NX round trip...\n");
+	restore_and_verify_nx_memfd(session_fd);
+
 	ksft_print_msg("[STAGE 2] Test data verified successfully.\n");
 	ksft_print_msg("[STAGE 2] Finalizing test session...\n");
 	if (luo_session_finish(session_fd) < 0)
-- 
2.56.0


