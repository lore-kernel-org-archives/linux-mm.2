Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81888D47CC3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:12:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A97F56B0088; Fri, 16 Jan 2026 05:12:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4ED26B0089; Fri, 16 Jan 2026 05:12:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977B26B008A; Fri, 16 Jan 2026 05:12:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 853926B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:12:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EA6E413B2C5
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:45 +0000 (UTC)
X-FDA: 84337413090.26.579AC64
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf24.hostedemail.com (Postfix) with ESMTP id F362C180009
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="Y63Dk/S4";
	spf=pass (imf24.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768558364; a=rsa-sha256;
	cv=none;
	b=V1FzUnyKM9IkJfLrZFecMdb6CvS4FHx/NHI//IoVUWhC2JuZuVDV7HheppXoTkmXFqVXyw
	dST+iy6FS/3mMhdBpNX41VpnAYL2gLNX4czG9XqeduDhy/kSD4d8KRef41VKAQ+Pvfan1j
	EHrQY3KVqxLGPLT3JJMQM2qKkCmclDo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="Y63Dk/S4";
	spf=pass (imf24.hostedemail.com: domain of kundan.kumar@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=kundan.kumar@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768558364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=JAzX5xgjVm43mfj6cQjqFjI15Ts3QYdwTmH3kOjyoio=;
	b=hpO8p+lfq4uT3UPiWwje0ly5DvZEkcQjNKXvTqBHciOgHR1lgTB8N+8lHABpmwf8HDey69
	fWZ5cF5u9vAu5ijEF0WyQ3b6Hw120qIezAIMX51X7SHjpMmV1aw/87qmxD2BAxxqYCOtBs
	vu0G1ADxWNLJfn/Uj+ggqyPW6pDnCkE=
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260116101239epoutp031e15e4ea71ab25163b1042475f4ca6a9~LLnUhrC1P2778827788epoutp03q
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:12:39 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260116101239epoutp031e15e4ea71ab25163b1042475f4ca6a9~LLnUhrC1P2778827788epoutp03q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1768558359;
	bh=JAzX5xgjVm43mfj6cQjqFjI15Ts3QYdwTmH3kOjyoio=;
	h=From:To:Cc:Subject:Date:References:From;
	b=Y63Dk/S4sI4gCiKFfH3k6CzRe1T5TUwO2afyUr0BhQayz3gNVqGJDemun1t+b2Mf9
	 xEc29M5aQPhw02V7YELVgN/ud7LiDYYND4iXhBPmzckJu4zzJJ7VzrR3AcfqybHZAn
	 TtoJoA14TrxQiO0DpIpv7BsD+M6hdNeTELfDxBSI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260116101238epcas5p4c15d799da203f7f934c340c72e44f11e~LLnUDGRsh1433714337epcas5p40;
	Fri, 16 Jan 2026 10:12:38 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dswdd5hKmz3hhT4; Fri, 16 Jan
	2026 10:12:37 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4~LLnR0H4d90903009030epcas5p1a;
	Fri, 16 Jan 2026 10:12:36 +0000 (GMT)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260116101233epsmtip2bbc5466cb9511273e75408cb93992cbd~LLnO8r4Wh0748107481epsmtip2J;
	Fri, 16 Jan 2026 10:12:33 +0000 (GMT)
From: Kundan Kumar <kundan.kumar@samsung.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	willy@infradead.org, mcgrof@kernel.org, clm@meta.com, david@fromorbit.com,
	amir73il@gmail.com, axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, cem@kernel.org, wangyufei@vivo.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, gost.dev@samsung.com, kundan.kumar@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: [PATCH v3 0/6] AG aware parallel writeback for XFS
Date: Fri, 16 Jan 2026 15:38:12 +0530
Message-Id: <20260116100818.7576-1-kundan.kumar@samsung.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4
References: <CGME20260116101236epcas5p12ba3de776976f4ea6666e16a33ab6ec4@epcas5p1.samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F362C180009
X-Stat-Signature: j33mkz5w5a9gbnzyune6qkqy8kqoewoi
X-Rspam-User: 
X-HE-Tag: 1768558362-567326
X-HE-Meta: U2FsdGVkX1+HDoZtm0hWal33WdTJNI8qpqkOa/B3wP3plZrbHUWRsHIQKMjINWQ0h8d429vu3FmKjwuhGR0Kymly737LNJUOwneaD74yL+0ytFvs7XujOUcHscuq+B/fJnqT2+g43UbriMlPNAQ2SN1+TEwLpJNRgkuAdNXP5Zm9o+SbbwB/0vMxThkvJGoBDGyDCNenmbvfhtb1kPbhen181QIBxJp/AYztyHd/I95/ry3ueovP3Au/m/LfthEEENSYXig+e9+rlWdpqdSBXEN8M1uRMTLVRIND9/Gr0lGri0qy0UOY8aiUPVAxMm4sRSYuhza8smSWEcPseLWJn3EM6cLkQ5vXU+2OGXxBPh2At1V5vwH+a2VqdcMLwjiAMHeofNW18Paq/wRs2fxLjWn9PyIhsFrOt3Hig/cgqkDjUOdQUHNh2ATdL1sUaN5LmSy79DDO6MbPipYV5DGzPA24DFePDtJmRBuAkvilpQCbXc2wQ6ll8svo15p3ORlEitKvOt39tITy9H7uetVOJIlUhq56mUsMEIb+XdKrKHgjy5UIzojEs8DJVOdtXRlbdG3q2ndm9Qg15so93hxD90xLUmFonfXtBY2QYcRd94cuk1t/k1Seh5bhc4pbukd4jjRgMwHUjEOqaiEdxwWfHJBJ5GbNakpXgL4q+Wm8zpnNnx9f0irmD0PEjnA39IBe4boxPPRDUvM2tbiSsPG/4fAyu1tqzltgXcqCwreBo5fxTpSzYfMKMurBpcMsvkWoeUkicn63XSR7NhHNVsTH/8Je2pq4bUVjHDpPAontoONRS3lhIa17aPkdwmerIVjDTqRL75q69Kw6mHEToKGShK5lIvelierKMeaqoKIWtJHCiNE7MdKqzvZsuQ2g7VtPxC7OUu+MgyB89wHvcdBJKTNV9nnOgphZ3J46bA5X+bVfBVEH2MhmLDbw+AxHlBKjDHw8Zs7X3oSQLi+F74Q
 YJoi5b42
 BvtzAVjgmjGewnjJIlsZHP4Jraha5Nxn1it8KWdf8AGOLUPnRrX2uZopYFBJk9mBCbAwp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series explores AG aware parallel writeback for XFS. The goal is
to reduce writeback contention and improve scalability by allowing
writeback to be distributed across allocation groups (AGs).

Problem statement
=================
Today, XFS writeback walks the page cache serially per inode and funnels
all writeback through a single writeback context. For aging filesystems,
especially with high parallel buffered IO this leads to limited
concurrency across independent AGs.

The filesystem already has strong AG level parallelism for allocation and
metadata operations, but writeback remains largely AG agnostic.

High-level approach
===================
This series introduces an AG aware writeback with following model:
1) Predict the target AG for buffered writes (mapped or delalloc) at write
   time.
2) Tag AG hints per folio (via lightweight metadata / xarray).
3) Track dirty AGs per inode using bitmap.
4) Offload writeback to per AG worker threads, each performing a onepass
   scan.
5) Workers filter folios and submit folios which are tagged for its AG.

Unlike our earlier approach that parallelized writeback by introducing
multiple writeback contexts per BDI, this series keeps all changes within
XFS and is orthogonal to that work. The AG aware mechanism uses per folio
AG hints to route writeback to AG specific workers, and therefore applies
even when a single inode’s data spans multiple AGs. This avoids the
earlier limitation of relying on inode-based AG locality, which can break
down on aged/fragmented filesystems.

IOPS and throughput
===================
We see significant improvemnt in IOPS if files span across multiple AG

Workload 12 files each of 500M in 12 directories(AGs) - numjobs = 12
    - NVMe device Intel Optane
        Base XFS                : 308 MiB/s
        Parallel Writeback XFS  : 1534 MiB/s  (+398%)

Workload 6 files each of 6G in 6 directories(AGs) - numjobs = 12
    - NVMe device Intel Optane
        Base XFS                : 409 MiB/s
        Parallel Writeback XFS  : 1245 MiB/s  (+204%)

These changes are on top of the v6.18 kernel release.

Future work involves tighten writeback control (wbc) handling to integrate
with global writeback accounting and range semantics, also evaluate
interaction with higher level writeback parallelism.

Kundan Kumar (6):
  iomap: add write ops hook to attach metadata to folios
  xfs: add helpers to pack AG prediction info for per-folio tracking
  xfs: add per-inode AG prediction map and dirty-AG bitmap
  xfs: tag folios with AG number during buffered write via iomap attach
    hook
  xfs: add per-AG writeback workqueue infrastructure
  xfs: offload writeback by AG using per-inode dirty bitmap and per-AG
    workers

 fs/iomap/buffered-io.c |   3 +
 fs/xfs/xfs_aops.c      | 257 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_aops.h      |   3 +
 fs/xfs/xfs_icache.c    |  27 +++++
 fs/xfs/xfs_inode.h     |   5 +
 fs/xfs/xfs_iomap.c     | 114 ++++++++++++++++++
 fs/xfs/xfs_iomap.h     |  31 +++++
 fs/xfs/xfs_mount.c     |   2 +
 fs/xfs/xfs_mount.h     |  10 ++
 fs/xfs/xfs_super.c     |   2 +
 include/linux/iomap.h  |   3 +
 11 files changed, 457 insertions(+)

-- 
2.25.1


