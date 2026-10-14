Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4791CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:52:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 080E56B008C; Tue, 13 Oct 2026 23:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031906B0092; Tue, 13 Oct 2026 23:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E616A6B0095; Tue, 13 Oct 2026 23:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B04A06B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:52:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E552A7EE2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:51 +0000 (UTC)
X-FDA: 85319860542.23.F421135
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9A939180003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZQbRvVAj;
	spf=pass (imf16.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791949969;
	b=N3EbK2LynEB88DyLjE/z9nCUhz1qdoo3eXg6tcaJxL+NNiIEBmRbhnHqFpC/lt6Npom3Wa
	TxR72IffXy2fIMRMm1hXLG1o8tMIgFqNdIuSsGWOarzHIHYT03nOSY9Nl419S1/8iBntys
	eR4/BOofybkeKYvVVojQWpzmDWTdNTs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ZQbRvVAj;
	spf=pass (imf16.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791949969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=js/e1ndjE4YknrvPw7rPrmCq/UssefpiXbufbqKGf20=;
	b=Z9cH62MW7ZciKiPPGrRuD6Qhm6YcvcDI7aZLoSMmB+LM6jw9KrFva4VdQM2zdB+oJpYefs
	RVrayhJm3FEbO5CwsyB37LkdEBehw56snNp9IUEczedsVEE9rgDfZw0ma/Vq25/Y/TZC1y
	Rdc40EOcI92xVzTEZteQNVCj1Gx63K4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=js
	/e1ndjE4YknrvPw7rPrmCq/UssefpiXbufbqKGf20=; b=ZQbRvVAjWcwUXEIzj8
	mbo36WFaiGadHLgyGEsd4wNmgHabubfyPGd5XA9O1B+Ag0LuQFXRw3Egvyp8zlq8
	0tfUwN9xnFfJC4jdhCPHdVaUAC8NPQTrCs83AO+7PBN4u3DWkiaNI2pU+YRPTZut
	eSuWscwxY84i4rUg5crr5g0dA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBncnaF_M5qUtfjEQ--.37990S2;
	Wed, 14 Oct 2026 11:52:38 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/3] mm/memfd_luo: preserve the sealed exec-bit state; reject kernel-private shmem files
Date: Wed, 14 Oct 2026 11:52:25 +0800
Message-ID: <20261014035228.473825-1-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBncnaF_M5qUtfjEQ--.37990S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxtw47Zr18Cr18KFWrZw1rXrb_yoW3AFW7pr
	Z8Kwn8Cw4kGFyIv3yxAw10vFyrAw4fAF4YgrsFgr18Can8WFnIqFyI9a4j9FyUArsaga42
	qF4Uury8Ca1UArJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFE__UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC1Aivd2rO-IhOZgAA38
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A939180003
X-Rspam-User: 
X-Stat-Signature: f3brz6ybjmkaqrp4ytg3ya46y7atwohf
X-HE-Tag: 1791949968-507228
X-HE-Meta: U2FsdGVkX1+K7sLQMH4/6xJPhXpIBQbYNZzcVvfzUKZAn5GC8BJRrFmZbVENHA00JcC0khieKk90qhwy4VfcYa5c+XAWjLOXkW94q3ME1y7WdoZ4+UxvcvRTr1Am6y2/FubVNiDuCeyGWU1dnWITWmE2HNo1Xrt4ZbdTM2W1g4Isk6pHfTmtPrG0fIuqyBpb/cUea+mslbjiwBK4eKOdeaKxwt5xkHnfZKVFBl/ekfPVTlFQDj/yMVI+Q8k2bJ5GuE42NjkMWSMe9GRkqryF1DmYycuJDdhUfLr4ZUMSzuTjUcvEpcuVRYJUHpALZnWBOJ51At6E8KPCBhTWA2hDfXrFT/npG4tsQUXkvW4BxeI7r0Tcci/HI7fWhHEYrODkOyILViIcbM09EPTjQ8KWP5WIBTekz6BKjTvYeA6vsvUwHjM4TdVdXI0TdyRl+6Gvj3umlOv2wMmbuSyO1BdidAuj0PP65wBqvTB4qB1kIn0Wwe4AbN6R7xYd78Met8TV+jD2asn37MwslkZRsGt1aV66SxmPm5r9t3H/h8rKPHQdOUzdHN4OWvtBV+GOsdvm7Ylnud56zSCnid1QvXQVIbTHSpDwStZU8j1WiN44M0OthXFLW++2GgZlwilUn22+KpKUT5H6UzPwGI8cqclFGaRcyG3L5vjkbMv8YsX+jGXl1vTnw13mfwDVNpHeJHB5Eiy5MRon9Vd1sqk8RhODWDwYfy976ZhVTB8JHQh5G1HMIO/QlpBHKqc+FqXzLclytH+ovq3lBbuBj0rwIelocDPQ3A7aZBj2+1HsVvgshKkDyvCN/MuFkTsYoRKvewjQN7u2SdSBpbed59cZQs0cPNhLEOhoACXWh1x4PkuasBHXe/zDIvtEu/YS0cN+9QkRmv457JP4QJM6F6sVrZWyjG5qlkAl4272mbSkizgVQ48bUE7vQMJbRGifmNW6bq2vLUeukqGSUdzpn7OeLWY
 oIKuSp04
 iziDS1gISuYZXZo29zMUlBxo81Yh5+CAzXeoCo7IGLgdh+GFiHsMX4RUlttGIWcIOe4W6slLxd5BynsYnGO/F/4NIgyMUAh3+hictvAFzFdK/W4szstlcbRl180evCLPGgph8hDcw6TeHsXe+NoG9kaYirbsyy0wxPm4asEQqXKS+zIkpG8buGZPfXBs0epBkcxhrH41xwUeboKKAN3up7Ak+S0cqaJ8CexqI58LOktWgPElrG+zePVfJRL174C47sV5ppLoXXXFs9W5+5nurvmCj1XhAkFeElCC+8BWKFnIQQHNgl9uvvEkzGFzpnQ+Gt5ZUGGgHOgxGDscrFcj4vq/M7T87LwXU0LdVxjkYBeqbg+KEO81m3k7LwJi4au+FaEV+O/QEXwpFBBQ4xyHvKIZw5HMyNQsFrWCy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Previous revisions:
  https://lore.kernel.org/all/20261014003558.357783-1-18766350203@163.com/
  https://lore.kernel.org/all/20261014031254.432582-1-18766350203@163.com/

Sashiko reviewed v2: the folio-release patch came back clean ("no issues.
It looks great!"), while the exec-bit patch got one report that holds up.
The handler's can_preserve() accepts any unlinked shmem file, and SysV SHM
segments are unlinked shmem files -- a segment descriptor obtained through
/proc/<pid>/map_files/ goes straight into the preservation path.  That
matters because preservation updates shmem_inode_info.flags under the inode
lock, while SHM_LOCK and SHM_UNLOCK update SHMEM_F_LOCKED in the same word
through shmem_lock(), serialized by ipc_lock_object() instead: two
read-modify-write cycles on one word with no common lock, so either the
frozen bits or SHMEM_F_LOCKED can be lost.  The mismatch is older than this
series (the pre-existing SHMEM_F_MAPPING_FROZEN bit has it too), so v3
starts with a small preparatory patch that rejects kernel-private
(S_PRIVATE) shmem inodes; real memfds are created without that flag.  The
other two patches are unchanged from v2.

Patch 1 is the new one: can_preserve() now also requires
!IS_PRIVATE(inode).  shmem_kernel_file_setup() is what marks kernel-private
objects, which covers SysV SHM, big_key payloads, the XFS buffer and scrub
files and the anonymous /dev/zero mapping file, so the check drops exactly
those.  It deliberately does not narrow the handler to memfd_create()
objects: unlinked non-private shmem files stay eligible, they are simply
not part of the race, because SHMEM_F_LOCKED is only maintained for SysV
segments.

Patch 2 carries the user/group/other execute bits in the record and takes
the final sample -- execute mask, seals and file position -- in freeze()
under the inode lock, freezing that state against shmem_setattr(),
shmem_set_acl() and memfd_add_seals() until the transition is committed or
rolled back, and it rejects records with flag bits this version does not
know.  The record version becomes "memfd-v3" and a read-only "memfd-v2"
reader is registered next to it.

Patch 3 releases the preserved folios when retrieve() fails, by sharing the
cleanup with memfd_luo_finish().  It predates the exec-bit work and carries
a Fixes tag of its own.

Changes since v2:
 - new patch 1/3: reject S_PRIVATE shmem inodes in can_preserve(), which
   removes the handler's exposure to the flags read-modify-write race with
   SHMEM_F_LOCKED (reported by Sashiko AI review)
 - patch 2/3 and 3/3 are unchanged from v2

Changes since v1:
 - Record the user/group/other execute bits separately instead of one "some
   execute bit was set" flag: an execute mask of 0100 was restored as 0111,
   inverting the guarantee this series is about.
 - Take the final sample of the execute mask and the seals in freeze(),
   under the inode lock, and freeze that state for the rest of the
   transition.
 - Reject records with flag bits this version does not know.
 - Bump the record version to "memfd-v3" and keep reading "memfd-v2"
   records through a read-only handler.
 - Release the preserved folios when retrieve() fails (now patch 3/3).
 - selftest: an execute mask of 0100 with its full 0x3e seal set, a memfd
   without execute bits (MFD_NOEXEC_SEAL: mask 0000, seal set 0x20, still
   writable), and a skip when vm.memfd_noexec forbids MFD_EXEC.

On record versions.  The flags cannot tell "the execute bits were clear"
apart from "the writer did not know about the flags", so records written
before the flags existed have to be told apart by the version string, which
is compared with strcmp().  The version is therefore bumped and a read-only
handler for "memfd-v2" is registered next to the current one:

  record writer   reading kernel and handler     result
  old v2          old kernel, v2 handler         default executable mode
  old v2          new kernel, legacy v2 reader   no execute bits
  new v3          new kernel, v3 handler         exact exec mask and seals
  new v3          old kernel                     no handler, -ENOENT

The legacy handler only reads records written by an older kernel: its
.can_preserve() always returns false, so it is never selected for an
outgoing preservation and every new record is serialized as "memfd-v3"; a
"memfd-v3" record is never handed to it either, because the compatible
strings have to match exactly.  If registration of the legacy v2 reader
fails, the already registered v3 handler is unregistered as well, so the
kernel never ends up with only one of the two handlers registered.

Row two is a one-time behaviour change for records written by a kernel
without these flags: an executable memfd preserved by such a kernel comes
back without execute bits.  That is the safe reading, but it is not what
the old reader did -- it never looked at the flags at all, it restored the
default (executable) mode -- so the change applies to every such record,
not only to the ones that were sealed with F_SEAL_EXEC.  Without the
version bump an old kernel would instead read a new record, ignore the
flags and restore the default executable mode, undoing exactly the
guarantee this series restores; with "memfd-v3" it has no matching handler
at all, so the deserialization of that session fails with -ENOENT instead
of the memfd being restored wrongly.

Two things I could not close here, both written down in the patches:

 - f_pos can still change after freeze().  The LUO file API has no global
   userspace quiescence before .freeze() runs, so this needs a
   framework-level answer rather than a memfd one.
 - If kho_restore_vmalloc() fails, the folio array cannot be walked and the
   folios stay reserved; that API is not failure-atomic and cannot be
   retried after a partial failure.  A KHO-side fix or an allocation-free
   discard/iterator API would close it.

Testing:
 - the kernel builds from this tree with the liveupdate selftest config
   (plus TMPFS_POSIX_ACL and TMPFS_XATTR, so that the new ACL path is
   compiled); mm/memfd_luo.o, mm/shmem.o and mm/memfd.o build without
   warnings
 - QEMU live-update round trip (preserve -> kexec -> retrieve) with the new
   selftest, on a kernel built from this revision: PASSED -- the memfd with
   execute mask 0100 and seal set 0x3e comes back with the same mask and
   seal set, and the memfd without execute bits comes back with mask 0000,
   seal set 0x20, data intact and writable
 - the same test against a kernel without the exec-bit change: "execute
   mask changed across kexec: 0111 != 0100"
 - the admission patch, measured on the same tree with
   CONFIG_CHECKPOINT_RESTORE and CONFIG_SYSVIPC enabled so that a SysV
   segment descriptor is reachable (memfd_luo is the only file handler
   registered in that configuration):

     kernel                SysV SHM fd        memfd     unlinked tmpfs
     without patch 1/3     accepted (0)       accepted  accepted
     with patch 1/3        -ENOENT (errno 2)  accepted  accepted

   the segment descriptor comes from /proc/self/map_files and reads back as
   "/SYSV00000000 (deleted)"; the memfd and the unlinked tmpfs file are the
   controls that show the ioctl path still works and that the check is
   limited to kernel-private files
 - checkpatch.pl --strict on the series: 0 errors, 0 warnings
 - not covered by the run: the freeze-time rejection (it happens inside the
   reboot() path, so userspace cannot observe it) and the ACL path at
   runtime

Haolong Wang (3):
  mm/memfd_luo: reject kernel-private shmem files
  mm/memfd_luo: carry the sealed exec-bit state in the preserved record
  mm/memfd_luo: release preserved folios when retrieve fails

 include/linux/kho/abi/memfd.h                 |  24 +-
 include/linux/shmem_fs.h                      |  20 ++
 mm/memfd.c                                    |   6 +
 mm/memfd_luo.c                                | 247 +++++++++++++++---
 mm/shmem.c                                    |  35 ++-
 .../selftests/liveupdate/luo_kexec_simple.c   | 208 +++++++++++++++
 6 files changed, 496 insertions(+), 44 deletions(-)

-- 
2.56.0


