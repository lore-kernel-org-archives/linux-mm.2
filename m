Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0EA1CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:10:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E7D08E00F1; Tue, 14 Oct 2025 08:10:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0982C8E000D; Tue, 14 Oct 2025 08:10:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F174E8E00F1; Tue, 14 Oct 2025 08:10:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC20B8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:10:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 77E71C0915
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:07 +0000 (UTC)
X-FDA: 83996601654.23.EB34D05
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB55640014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GRcgBlLY;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf01.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760443805; a=rsa-sha256;
	cv=none;
	b=D+0xIelRr53Wh1yDTSK9he+UCmKJ/UuAj7cFIFJx9bnLRA/MUB4sVg+WfH+CdBovtlAHEI
	K/AMD1YdIxxyK3xcNBbLrrT039Pc2Dd89dWGBdWMMqpbK+DmQOTxH1488BF9SJ7Qx34a98
	wqEof1NQ0Za3sTvKjx04TxdxP6+sw/k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=GRcgBlLY;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf01.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.34 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760443805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=7WbTo3b87TcBxeQcwDkocdqHlwUoY6jjO0nBtSk6L5U=;
	b=1aXWPDCUY9sg7iIRhVM2ec7qr36iTSEfKq78cykWkGlHmz0MFzsOXlW1N8iV/kmYnCq1Gv
	35SWPMsudZqV/lk8pYr/Evz13dvOUvx4WxlVesazGLHuDseLV8sKzmu04UVJexcfGb5Oz1
	x4D1QyplXqlTCnf8BfVbaA4G6ngZOqk=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251014121001epoutp04d02d83fd1556e859922384a104d79203~uWk9i2B9m0829908299epoutp04F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:10:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251014121001epoutp04d02d83fd1556e859922384a104d79203~uWk9i2B9m0829908299epoutp04F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1760443801;
	bh=7WbTo3b87TcBxeQcwDkocdqHlwUoY6jjO0nBtSk6L5U=;
	h=From:To:Cc:Subject:Date:References:From;
	b=GRcgBlLYxNu87I3PvSMG6Dx4PrFFyrG/RwaZ+XidMJv3bxIM44VDHh+QVtLc5Pw9C
	 GiGm5dW8gvNVYONT8gjs7Xd1iA/+vWtfqSMcuDuW8Q4aj04aU7i1BMiFKRToOouOQs
	 hlA59dPlHXulx17FxQl9mpUdsD33M3kevmK8n1nU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251014121000epcas5p370ee92deffaec925758512149fbf2723~uWk81_YMw2693726937epcas5p3q;
	Tue, 14 Oct 2025 12:10:00 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.87]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cmChR48YXz3hhTB; Tue, 14 Oct
	2025 12:09:59 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9~uWk7KDAhS1888418884epcas5p2o;
	Tue, 14 Oct 2025 12:09:58 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251014120942epsmtip1ad7d573cabebcfc48960eafa87bdb869~uWkscrJqS1240212402epsmtip1J;
	Tue, 14 Oct 2025 12:09:42 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com,
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
	gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, linux-mm@kvack.org,
	gost.dev@samsung.com, kundan.kumar@samsung.com, anuj20.g@samsung.com,
	vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v2 00/16] Parallelizing filesystem writeback
Date: Tue, 14 Oct 2025 17:38:29 +0530
Message-Id: <20251014120845.2361-1-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com>
X-Stat-Signature: x441z74hm7hdtkorjda41g6u78i3xjzd
X-Rspamd-Queue-Id: AB55640014
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760443804-201390
X-HE-Meta: U2FsdGVkX1/AfiKthm/ROvDTdpUuLTkO0t3mZo2+LySGiuILtZCnWXIrRCdSUKlMhox60uwMD38172u1+OC5atkTUGqdgxy9Tv/80oGLUrLvw8WtNH/mBc3HE6faU2ogovZTDBicG05nW3VyU0BPewYm8Dg7LzsnJ7a9tMClhAxpfUl9WJyRnOJ19rnDptBajqMDNyLJwy2dmaO8vP78/Xjm6REnNvj4U8FL0PPlNbven/xC5Fd58ZSK7CyUYUGXOgBwVPS7ZOh/afAXttjANLoyZssVr/dZUX0KH/6HN9SU3v6+ni7VpnzoGZUWbO8QdqNmzM9xoIbIxdmfzamV8G+77yq5SD9SnNhEUAJDLBWQs7diXgMsgZ6tZjYAVWWXplAMRRZJLluJRykaT4pbmiKy0sCrVJ/8uRcBWqNFAx4I1aORfP1Ty+MgtWpjZEVCfBmfSpJ9F0Bf2alWnc0kRGFa/VqjTPampEa5rtglyIrVqv9+MmbV792Xcj+TyCIWL9ID22SsuU+xg3whB0qtJ/IIJoOHxjOGK4Cb6ELf+KtaF8k4+pNvdIeGAuSegkrevUM1Hv0A8PP8l9pnjJjrMAuiqGo0aizbiGYlHwCKl9epjnHJRBwpVdaHa9moDfDPoIkuUtqNSrJXWLcvMKpiOroMWTyhsrp+0wSodZ72JCrBOsplR9OcqNi+9mO6vQpKNBMYJTINkRAz605zqTFTISEqZVF1Z9/fKc3kLlF2WlTVtQFFWTNlvpmYQ9u+d6eTkTho7Fjj7/Sq6gUdoyK+BIdTUI7JlRro2KVQczUM+6qMjZ77aGLky5SqwAmLTkaGNjl+wfN102GJYR+rX1qvqaaOkT35JVmrggOnodj35fsPsjBsnV747bMEDOxfjytKc9oQ7nO7HCNHNa7WF2I1YWfVIcrMIShQYZdQLMdoaQK3XXoIxXJj5WJl8FqQ2wTZZMBNF5EyuDse2A9kSlS
 UOtddKLH
 woxwownXNEvopM5gUADKGVcJz5fo4wH/TSponj0V8ZBs/D/fDlSTg1yUCdKzCXgSo+3T5mpdQm7m+Hfygyc7asU6Fg7W5O1LsatmHBAxGJ4t2dtdklqUd08pknWxguRvn2LtTcge/A0zsYvsgNsk4Qt4QKnG9D6F6MiXQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, pagecache writeback is performed by a single thread. Inodes
are added to a dirty list, and delayed writeback is triggered. The single
writeback thread then iterates through the dirty inode list, and executes
the writeback.

This series parallelizes the writeback by allowing multiple writeback
contexts per backing device (bdi). These writeback contexts are executed
as separate, independent threads, improving overall parallelism. Inodes
are distributed to these threads and are flushed in parallel.

This patchset applies cleanly on v6.17 kernel.

Design Overview
================
Following Jan Kara's suggestion [1], we have introduced a new bdi
writeback context within the backing_dev_info structure. Specifically,
we have created a new structure, bdi_writeback_context, which contains
its own set of members for each writeback context.

struct bdi_writeback_ctx {
        struct bdi_writeback wb;
        struct list_head wb_list; /* list of all wbs */
        struct radix_tree_root cgwb_tree;
        struct rw_semaphore wb_switch_rwsem;
        wait_queue_head_t wb_waitq;
};

There can be multiple writeback contexts in a bdi, which helps in
achieving writeback parallelism.

struct backing_dev_info {
...
        int nr_wb_ctx;
        struct bdi_writeback_ctx **wb_ctx;
...
};

FS geometry and filesystem fragmentation
========================================
The community was concerned that parallelizing writeback would impact
delayed allocation and increase filesystem fragmentation.
Our analysis of XFS delayed allocation behavior showed that merging of
extents occurs within a specific inode. Earlier experiments with multiple
writeback contexts [2] resulted in increased fragmentation due to the
same inode being processed by different threads.

To mitigate this issue, we ensure that an inode is always associated
with a specific writeback context, allowing delayed allocation to
function effectively.

Number of writeback contexts
============================
We've implemented two interfaces to manage the number of writeback
contexts:
1) Sysfs Interface: As suggested by Christoph, we've added a sysfs
   interface to allow users to adjust the number of writeback contexts
   dynamically.
2) Filesystem Superblock Interface: We've also introduced a filesystem
   superblock interface to retrieve the filesystem-specific number of
   writeback contexts. For XFS, this count is set equal to the
   allocation group count. When mounting a filesystem, we automatically
   increase the number of writeback threads to match this count.

Resolving the Issue with Multiple Writebacks
============================================
For XFS, affining inodes to writeback threads resulted in a decline
in IOPS for certain devices. The issue was caused by AG lock contention
in xfs_end_io, where multiple writeback threads competed for the same
AG lock.
To address this, we now affine writeback threads to the allocation
group, resolving the contention issue. In best case allocation happens
from the same AG where inode metadata resides, avoiding lock contention.

Similar IOPS decline was observed with other filesystems under different
workloads. To avoid similar issues, we have decided to limit
parallelism to XFS only. Other filesystems can introduce parallelism
and distribute inodes as per their geometry.

IOPS and throughput
===================
With the affinity to allocation group we see significant improvement in
XFS when we write to multiple files in different directories(AGs).

Performance gains:
  A) Workload 12 files each of 1G in 12 directories(AGs) - numjobs = 12
    - NVMe device BM1743 SSD
        Base XFS                : 243 MiB/s
        Parallel Writeback XFS  : 759 MiB/s  (+212%)

    - NVMe device PM9A3 SSD
        Base XFS                : 368 MiB/s
        Parallel Writeback XFS  : 1634 MiB/s  (+344%)

  B) Workload 6 files each of 20G in 6 directories(AGs)  - numjobs = 6
    - NVMe device BM1743 SSD
        Base XFS                : 305 MiB/s
        Parallel Writeback XFS  : 706 MiB/s  (+131%)

    - NVMe device PM9A3 SSD
        Base XFS                : 315 MiB/s
        Parallel Writeback XFS  : 990 MiB/s  (+214%)

Filesystem fragmentation
========================
We also see that there is no increase in filesystem fragmentation
Number of extents per file:
  A) Workload 6 files each 1G in single directory(AG)   - numjobs = 1
        Base XFS                : 17
        Parallel Writeback XFS  : 17

  B) Workload 12 files each of 1G to 12 directories(AGs)- numjobs = 12
        Base XFS                : 166593
        Parallel Writeback XFS  : 161554

  C) Workload 6 files each of 20G to 6 directories(AGs) - numjobs = 6
        Base XFS                : 3173716
        Parallel Writeback XFS  : 3364984

Testing using kdevops
=====================
1. fstests passed for XFS all profiles.
2. fstests passed for EXT4 and BTRFS also, these were tested for sanity.

Changes since v1:
 - Parallel writeback enabled for XFS only for optimal performance
 - Made writeback threads affined to allocation groups
 - Increase the number of writebacks threads to AG count at mount
 - Added sysfs entry to change the number of writebacks for a
   bdi(Christoph)
 - Added a filesystem interface to fetch 64 bit inode numbers (Christoph)
 - Made common helpers to contain writeback specific changes, which were
   affecting f2fs, fuse, gfs2 and nfs (Christoph)
 - Changed name from wb_ctx_arr to wb_ctx (Andrew Morton)

Kundan Kumar (16):
  writeback: add infra for parallel writeback
  writeback: add support to initialize and free multiple writeback ctxs
  writeback: link bdi_writeback to its corresponding bdi_writeback_ctx
  writeback: affine inode to a writeback ctx within a bdi
  writeback: modify bdi_writeback search logic to search across all wb
    ctxs
  writeback: invoke all writeback contexts for flusher and dirtytime
    writeback
  writeback: modify sync related functions to iterate over all writeback
    contexts
  writeback: add support to collect stats for all writeback ctxs
  f2fs: add support in f2fs to handle multiple writeback contexts
  fuse: add support for multiple writeback contexts in fuse
  gfs2: add support in gfs2 to handle multiple writeback contexts
  nfs: add support in nfs to handle multiple writeback contexts
  writeback: configure the num of writeback contexts between 0 and
    number of online cpus
  writeback: segregated allocation and free of writeback contexts
  writeback: added support to change the number of writebacks using a
    sysfs attribute
  writeback: added XFS support for matching writeback count to
    allocation group count

 fs/f2fs/node.c                   |   4 +-
 fs/f2fs/segment.h                |   2 +-
 fs/fs-writeback.c                | 148 +++++++----
 fs/fuse/file.c                   |   7 +-
 fs/gfs2/super.c                  |   2 +-
 fs/nfs/internal.h                |   2 +-
 fs/nfs/write.c                   |   4 +-
 fs/super.c                       |  23 ++
 fs/xfs/xfs_super.c               |  15 ++
 include/linux/backing-dev-defs.h |  32 ++-
 include/linux/backing-dev.h      |  79 +++++-
 include/linux/fs.h               |   3 +-
 mm/backing-dev.c                 | 412 +++++++++++++++++++++++++------
 mm/page-writeback.c              |  13 +-
 14 files changed, 581 insertions(+), 165 deletions(-)

-- 
2.25.1


