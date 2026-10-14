Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52FB7CA9EBD
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 03:52:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFCA36B0092; Tue, 13 Oct 2026 23:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4B76B0095; Tue, 13 Oct 2026 23:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C176F6B0096; Tue, 13 Oct 2026 23:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DAA86B0092
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 23:52:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A759403E2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:52 +0000 (UTC)
X-FDA: 85319860584.04.CE85194
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1D9961C0006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:52:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QOqxztTa;
	spf=pass (imf18.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791949970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7I4Ah0JVOQm1OSF3+TCarpY5Fjoooqn/9uhkbG0e7FE=;
	b=krtNOYZVDMo4c1nGPhq0ZdYHxJZ+QN8ak9Upo117EhwdigeychpGv21cyF8FEeyMCVuVex
	7J7Z/ZgDAFRgcjo1u7PLOIv8cP8MOmH2Ob1tK3O37263GAlcYxod+P6Wpyw6SEMVHEPCqq
	umE4BxW20Joj9cFkHsQ0oWJT31WxPG8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=QOqxztTa;
	spf=pass (imf18.hostedemail.com: domain of 18766350203@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=18766350203@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791949970;
	b=Vf3YApp552p4Qmr3HqzT+TDh1vWjWoLtUOHYQ0GR4c2tBrEjefGoIYyvyG3F7Y83UjD9dG
	p2aLtqkGR5MAjSBoNkEd+/9XJFAjDS9PaGm+gGuuHdHUXEpEYUs8uhlNxbkXx/B0RTFsIv
	Rr9E349zccdw9B0iTbsL8ndCDg0GdZA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=7I
	4Ah0JVOQm1OSF3+TCarpY5Fjoooqn/9uhkbG0e7FE=; b=QOqxztTaHU/KDDMRWs
	qdZKtJ2toFL5dv+B5weTvnVzxv2avWG41VGnDWsahaetTdIh0sO6FsWMAgyNIBmc
	gUIQf9aYxmyy06DWRCrQHYEovx/ZVyCJabckLRg4o/t/NpySTtzEpcSHWKoWm4W6
	tjKwe9RVueeEhgAEMlz4U4zZQ=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgBncnaF_M5qUtfjEQ--.37990S3;
	Wed, 14 Oct 2026 11:52:41 +0800 (CST)
From: Haolong Wang <18766350203@163.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] mm/memfd_luo: reject kernel-private shmem files
Date: Wed, 14 Oct 2026 11:52:26 +0800
Message-ID: <20261014035228.473825-2-18766350203@163.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014035228.473825-1-18766350203@163.com>
References: <20261014035228.473825-1-18766350203@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgBncnaF_M5qUtfjEQ--.37990S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxAw1UXF4rZF4xZFWDKw48WFg_yoW5Kw1Dpr
	Z5K3WrCay8KFyI9a97Ar109asYva1fAF4agrZ0gw17C3WvvrnIqFyI9FyUuF4UJrZ5WFyY
	qr4YkryakF4UAr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07URmh7UUUUU=
X-Originating-IP: [2408:8418:c22:8000:1bbd:2550:438b:167e]
X-CM-SenderInfo: jpryllawtvijiqt6il2tof0z/xtbC0wmvd2rO-IlSxAAA3F
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1D9961C0006
X-Rspam-User: 
X-Stat-Signature: 6fu5k7kg8zb95ibn7w8bd5jj8jigax5t
X-HE-Tag: 1791949968-332215
X-HE-Meta: U2FsdGVkX1+eZXUsMLWo+USg3n/6OLQoU9grosSSe3TjQ0e9l+V6TSvf3eO10zNfdGsyhUsfcMcPjnP1tFGZ3eu2i0/j8TV4iI1LKmouJV5w/EHafxi1fyrGTrr5qkHwxgYVM1i7VjcxzhvfV2cLHOf9p9Zqff/uQKqGJy+DQHwm2mdjZiuBtXtque4nEoePe54pdWPTmuysev4Z6+6wYMIxuCP5K+osUH3N2pPW8dfg0skXCS2O/oh8KjC1Jahzp4SuWd7yVP1KV4zn9KCUSOO+JvVjK88A6ko7cLnFH1kFFvM+4PilnoybW21Dk5m41gvJuNRmQgNpkTKU8e7w1Q7L4d2+XDLnY5oOHZWs2pR1xgIX+C7TG3Qx2hIC91C065UOdS/auaMW9oXyaz1AqNI4jxiuq6me+WJcGNDwiANvcgMyrp+h+kr2f36Xv1/diTaeqcTnu98Z8Iqhi49YSnVOw7v46zfcmTQjdCmGbBuTQ5h0nT1oDprwpKhSHCpZvdS9lgds/kQcUBW7RXTHOXyicxzSwf7DM+6WvHP2EZAfkjqFG4ppzQM7t8dX5L00ysdZdPp15LSSXZtEiFa4Cp8XawBD4yLnKixqbEbMC6/ln1Vq7WRSu7LRRkWAweYl8cyepbdxI+XmvimHDKLFvouHkVcFZMKj19qtsKIHKECYo2qvFWWoLEgC5O1CAEhaY6e1uaDiv1yZgnbjcryKxJujxKXod0A5zalh5g5ObLXbu84PKoRdAfPVBP3hwVkxBnwEMAFOkYfHMc7JlLWcprNRhFltTsUmZthG6IS4jfUkYo1ZDpKDRh6bY0SydYinUFhMzE5eYhh7MG5KDwAjordBRV0nDtuZdpcZPtNck1S5Aes2VPr6Xci7iaGrM9RYWpXMvclLNmDdeCPeQt05JuszVopjF0e7X2T92cTmuNaAKoI685KKv7DOAKW6M2YMn0e4oXoAdkiGlCcitK8
 hYavHnrA
 SwrSjWbVNIOvt/Tcvhri6pvFVp467gcYzoy1iQHABZ5HBbaUWIukuFUle8Q8ja9ssm/PK6UExnMRLs8hQIlMijou9xRH6w/oca7G6FvklbGcGGXqhIDGYOrwSqmSCblrRucdqK0JXYAzdCrLh8jHD/wXpJMi4b2TfXLQo2Ta9aO6NCzLPq/Df11bvoPEFU9Q774f7A3kmtTOmBTrordAp7beetTrK0G28xVX+3z9ko6qHJQc6TyRm3exz+pZrxYRqqG0puQGrC4wxpeq1S9SEH1ARyj4VfGqvYDzBBvOn/aph2pNufyM+xNpWZYNqzPDbTVRo3RemYBWW1LgUN9x0e1hJGvztd8el08mEoR8krPhSfG135Auz7vkMXZHn+/7+q+e9TqDpGHpMIa0T7+MbQORdjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

memfd_luo_can_preserve() accepts any unlinked shmem file.  That includes
SysV SHM files, which are created with shmem_kernel_file_setup() and
marked S_PRIVATE: a privileged process can obtain a file descriptor for
an attached segment through /proc/<pid>/map_files and hand that
descriptor to LUO.

The preservation path then updates SHMEM_I(inode)->flags under the inode
lock when it sets SHMEM_F_MAPPING_FROZEN, while SHM_LOCK and SHM_UNLOCK
update the same word through shmem_lock(), serialized by
ipc_lock_object() instead.  Two read-modify-write cycles on one word with
no common lock can lose either the LUO frozen bit or SHMEM_F_LOCKED, so
the frozen state the handler depends on may quietly not be in effect.
The seal-state freeze this series adds (SHMEM_F_SEAL_STATE_FROZEN) has
the same synchronization requirement.

Reject S_PRIVATE shmem inodes from the memfd LUO handler.  Real memfds
are created with shmem_file_setup() without S_PRIVATE, while
shmem_kernel_file_setup() deliberately uses the flag for kernel-private
objects: SysV SHM, big_key payloads, the XFS buffer and scrub files, and
the anonymous /dev/zero mapping file.  Those must not be preserved as
memfds, and dropping them also removes the only concurrent writer of that
flags word from the handler's reach, so no shmem-wide locking change is
needed here.

The predicate is deliberately not narrowed to memfd_create() objects:
unlinked non-private shmem files stay eligible.  SHMEM_F_LOCKED is only
maintained for SysV segments, so they do not share this race and keep
being preserved as before.

Measured with QEMU runs on this tree, with CONFIG_CHECKPOINT_RESTORE and
CONFIG_SYSVIPC enabled and liveupdate=on, so that a descriptor for a
segment is reachable; memfd_luo is the only file handler registered in
that configuration:

  kernel                SysV SHM fd        memfd     unlinked tmpfs
  without this patch    accepted (0)       accepted  accepted
  with this patch       -ENOENT (errno 2)  accepted  accepted

The SysV descriptor came from /proc/self/map_files and reads back as
"/SYSV00000000 (deleted)"; the memfd and the unlinked tmpfs file are the
controls that show the ioctl path still works and that the check is
limited to kernel-private objects.  The SysV case is the same guarantee
that the pre-existing SHMEM_F_MAPPING_FROZEN bit relies on, so the
mismatch is older than this series; atomic flag updates or a shared lock
would be a change across shmem and ipc, and this patch removes the
handler's exposure to it instead.

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/all/sashiko-outbox-170776@kernel.org/
Assisted-by: Pi:glm-5.3-flash
Signed-off-by: Haolong Wang <18766350203@163.com>
---
 mm/memfd_luo.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..6f8b84530995 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -582,7 +582,12 @@ static bool memfd_luo_can_preserve(struct liveupdate_file_handler *handler,
 {
 	struct inode *inode = file_inode(file);
 
-	return shmem_file(file) && !inode->i_nlink;
+	/*
+	 * shmem_kernel_file_setup() marks kernel-private files S_PRIVATE.  In
+	 * particular, SysV SHM updates SHMEM_I(inode)->flags under its IPC lock,
+	 * which does not serialize with the inode lock used by LUO.
+	 */
+	return shmem_file(file) && !IS_PRIVATE(inode) && !inode->i_nlink;
 }
 
 static unsigned long memfd_luo_get_id(struct file *file)
-- 
2.56.0


