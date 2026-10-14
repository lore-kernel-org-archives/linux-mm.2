Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9F0CC6B1C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391036B0095; Tue, 13 Oct 2026 23:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31A8C6B0096; Tue, 13 Oct 2026 23:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1944C6B0098; Tue, 13 Oct 2026 23:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B92B96B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:13:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 131781403C9
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:18 +0000 (UTC)
X-FDA: 85319760876.20.78880C2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3E9CEC0004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:13:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=d9Ej44Yy;
	spf=pass (imf22.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791947596;
	b=Y4zU9QVkqNWq1ntixgsi9yE+iIIQnl9RsE3rJap4mHGFBp4b/5Cf+UzQj7UAns+hSjGmg8
	21zCNxtofbNZ6f0o6s1NVQMSJq5sLKREKiQn2DmGrXLiq15sWRsmPEMwedMMJ0Dp3CUxB6
	c1mOxneRMVjP0a+Mk3o8EsIKAUlza7U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=d9Ej44Yy;
	spf=pass (imf22.hostedemail.com: domain of 18766350203@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791947596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTP94GKH0Y6WYDtNmZqgB1Ql0ZcA9eDUJn+U1GN/7R0=;
	b=xLQ2zsDh9CSTtNzQTkZK4U7KwgAxAUkiBhxa1aTzwVNq+6zI5H1jiXWQAVM9dE+9m6qQmJ
	a7sxu2I/1vVbUPtII4ffpLo0nDTtfpbz7lCSMslDrf0gdYW2WJMo0s4bLzALmeZ304kjnn
	ll9Kle5esOy+xIMzAGu++pMJ6Nr7xjg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=eT
	P94GKH0Y6WYDtNmZqgB1Ql0ZcA9eDUJn+U1GN/7R0=; b=d9Ej44YyGNOSE3X4C0
	IDf1bjkl/vL/Xq5J9lRz6Ez0GXo9R+UT6uHKSIjuyzGcuYqVua1XgMz002E36RIO
	9r7Ji8pmGMkCpJnZnDyNxhT9vyyUGR+Mlmp1LEaCFwvHG9+Up1DqL+3yx1ZRxkse
	mTbP8hkUSbjCkdDabcS8juB6w=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wD330I_885q6IC7Eg--.21712S3;
	Wed, 14 Oct 2026 11:13:06 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] mm/memfd_luo: carry the sealed exec-bit state in the preserved record
Date: Wed, 14 Oct 2026 11:12:53 +0800
Message-ID: <20261014031254.432582-2-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014031254.432582-1-18766350203@163.com>
References: <20261014031254.432582-1-18766350203@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD330I_885q6IC7Eg--.21712S3
X-Coremail-Antispam: 1Uf129KBjvAXoWfur1xJr13Xr4Utw1fAr4ruFg_yoW5CryDZo
	WFqwsxXr48Kr13Gas8GF18Gry3Wa4kur13Jw1FvrW5CFnFqryjy347uFZxJay3Xr1Yq39x
	A34xXa1UGF9ayFn5n29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUxhiSDUUUU
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC9gJbI2rO80JOJQAA3y
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E9CEC0004
X-Stat-Signature: kbgho1wxsriqkki81t9yhthekrewu3h5
X-HE-Tag: 1791947594-367389
X-HE-Meta: U2FsdGVkX18iZbVjpdWp0tmKhDRgnn4PlczdLytO7hkpUfpggb8VXbnfbzG50lIYsDdn/yEnVJG9GyCc2r9yahY5n3irYOrYwEngJM8R4W7sdNe/MJZ6OKBB99pmpHiPn+tIrjAVL/GPlMCO6nP37XxF8Y33c+/sj5tghl4efdroAbK9ALMd/gRPE+deNhTJ+xn/cfxeKbUgTqSDgI80p8im85EHNy1SbzsWdTP9v29Rt0TXNyHuzutmqabuPVSvRpkk7sG3BLMzS39i1nfHoVAKB2sW/ptny79SZKEPlsC9v6Sh/ndE0xi1vA83GmF6E9z10CDflCIrVVk3/4kOS5hJX0/nSCKAA8WockD20o697H7ZElhoJqDT+lCTGBfngyp4RCDyfnW6G5brcm4bl+JYvwntZnhLNR/V+4RqA5uuvd3xD9T0OUpgs3aN7y630UOZxKD7NFuJdzhZSxJ2dlDQ7UX9i8psXccgK1uCKiR6sD7RXKoj6qw5g3tK0OcANiJRfj5C+tAIsI63BxThmydw6XHU1FIjnUvDTE5P5LQgE5g77cMqhFZCMNBW0rJ0UJnju+tUzxCoH/bMEywNeEe5+siRW8hIRd0hpwXf9fj79Eihf+ADedXg86NhQ/87PRSbOGvZ3U6bwCLXc8CEKte9f5KzPv1ucgd38tZTTcy9JMINybSZkUbxyHcJFfua1Caw2Rciks52Xmp8AF7m23UW5SU/jB+SZ0/XFEuOBQCfrIKm6lYLtsNQ0NLwKjNRY4Tw/jT5aTH3TG5jOv05KtNlbX/QJu1xPd2kaGVg/EiAZ/qQzEtWaZIKTZ/uMDQFEPffUsTzbwI5uEXlabW0kLuLHky7O6eWTGCeZyWBMk87IoR37KUBj01E6GxD2c22GMMTaUW6eAWy0+Aien593oAcLIj7m+AdXy6CPTAwdXgPWLxFBpJsa3jZUNg2IcY5Lfm2KfM5BwhGjNyorNu
 Ysnvb+YF
 DUSJA5vVtHj92opZ4e7n28UnlYRjk22B5874fF97mntH37rBVjiVAWblZl+3i4dfSUciTpb2DtcYVXqMVV+IkJtYRfcRM7OorTM2fMf40Y1WT9SjQHpgl0w/zihOTgfyUAsHi3YVuIqIyVi5XWGiUJGSm7DB2KS7rEmfDQdY2kbXQh+pQT4tQemfj3TWcgCt56PJkYQbGKpJpcA52pqa8Yj2dM3yav3B+lJ/oRADsFOA+r6/yyJS6AW04HKWcOXIL0LkVdFGy9ChTFhn+f26bB7OCjHYu72pD70HmBcapyNWZU/O4UTgXXimqw68DEGtD0ExQUBddE+J9QkTV+um4bdZWR63oW4mUuOfRwc36y7UyP/2IoJNvsnWdTyix9qo1vFiSOfgaOCfhF2KsmNsN8w863HFWyyK9i7o1
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
index 59de210bee5f..6fa086fe809b 100644
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
@@ -592,6 +688,7 @@ static unsigned long memfd_luo_get_id(struct file *file)
 
 static const struct liveupdate_file_ops memfd_luo_file_ops = {
 	.freeze = memfd_luo_freeze,
+	.unfreeze = memfd_luo_unfreeze,
 	.finish = memfd_luo_finish,
 	.retrieve = memfd_luo_retrieve,
 	.preserve = memfd_luo_preserve,
@@ -606,15 +703,62 @@ static struct liveupdate_file_handler memfd_luo_handler = {
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


