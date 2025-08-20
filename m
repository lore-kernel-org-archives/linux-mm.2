Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C94FCA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C230D6B00B0; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E2D6B00B3; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05C18E0001; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83C266B00B1
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6F2FB8114
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:06 +0000 (UTC)
X-FDA: 83795341812.11.8E254BB
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id A0D8C8000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=chRqHdL3;
	spf=pass (imf02.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvtSU8joP13kEFVRuIji2CS52l0yNsMc//UfkvDFdGU=;
	b=m8MO8LtBijWkGGiOu2VL2moJNDfUUFLJ3KJH3mQUFH7zoPDugu0s63kODvLcL9HwHn83nU
	2TY3+QjbNSe3jhx4cnE9KTroX6p7e+eaTTYIL35PLyTpsn12R1hGBVLsHSx+dJZE+uTIPH
	M8WAqLuqH6f2YBRISZ05gN3HHHk4t/E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=chRqHdL3;
	spf=pass (imf02.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651904; a=rsa-sha256;
	cv=none;
	b=CFiE5lqgMQpYoMhlZ9EnZT/UAidHmqcNYrmk5bZi6rckfPP0Qs4xJX0qBiwluz24CEgfxH
	+MFSw+C8PPoEb0bbyC3jpvWriL1DLEdsh36+wYdk0mwsUrruO3otXs+hviR9ZI7Hm9RtGy
	0UItsMA2F9EPW0X4CvSOfyhIa1lL+2M=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBntf004717;
	Wed, 20 Aug 2025 01:04:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=gvtSU
	8joP13kEFVRuIji2CS52l0yNsMc//UfkvDFdGU=; b=chRqHdL30O/eJPJFelYIF
	JxRhsujjXC0JG/oz9/MU5CeqTekl999B56TQbX8LfmRMQBmg3rQn0O2/7XD8OGre
	kBCg84rUXr3D8TeMSJxqHyPScVo/5uNq/kKaagc8u8oe+YwQSW6IZjYXtu+phYQN
	ufvs6aXscoBag76SiGkOoUgknXMK56YgqJFwlnEy0r2m5XirmpM9efE5HQfKGnSb
	FfpImDr2IJHNd9b9GBjYH+qgmaj/vG8JhZG6W0yY1F3g14BALk3pG5VHoX6Z+86i
	otDMMSxlOPjI4xSZpnxTMq1Pk/wdC30PX0vCpCnhiJsx49iJXEqQ9tPiQ+LTel6N
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqr8aq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JN39eS007104;
	Wed, 20 Aug 2025 01:04:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Nd6011685;
	Wed, 20 Aug 2025 01:04:26 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-2;
	Wed, 20 Aug 2025 01:04:26 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 01/22] mm: Add msharefs filesystem
Date: Tue, 19 Aug 2025 18:03:54 -0700
Message-ID: <20250820010415.699353-2-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXxAv3h/m+MTfc
 0ptiIARYa95maJCEZqJrG3tLLfGpL+aAvAx5WUp1c4PkyP4lb9O2BjnTaVHBUz7+VrN6M2X8Odl
 /9giLrBYnZUEDrpCesHEZOlRkw1P5OBPFkRxms3GEYaLOFD78Uo8BxIQKjsaT8z5IbGiIgwiWy0
 fN6x5Cu2SJbcRrRaX9KjHMIw1aUI8DMevMqW3DsLJduVto3IfZr3FwThOQdIByR0qKOb5V18kUv
 X7hTq4VMAuoDTt3LolBTn4BF7FbEJ+kkuHfMXBT3iWtuCiTPcoj/ADRlBbAuirJiwkNWSPhlcDG
 KfHWFnvVrQOdKanevXFtxI0EPCSzYgC7PaRTBFgculdg6jYyEnPjJkMEORformFhMkzIXg285lM
 GhlZJFYkk7/nK/ZLzIcIL5P8NkG//Q==
X-Proofpoint-ORIG-GUID: yRHOcQOSeDi0JpjdrasRvx-vwL1WmHeC
X-Proofpoint-GUID: yRHOcQOSeDi0JpjdrasRvx-vwL1WmHeC
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a51f1c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=Mf_uHGjaqS_lSwFvvQkA:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A0D8C8000B
X-Stat-Signature: cis874hbkjdjrpcop33aumh43rntj6jz
X-Rspam-User: 
X-HE-Tag: 1755651904-33039
X-HE-Meta: U2FsdGVkX1/obpmuVH0NwDu+2EPdmLEqc6ee2QCg27FlAUEcssjVo9GOsYJzNv8ekrBI4yu3BAM2r+BsAoB2I9Y8qchAWxtQQJFQLBUUb+W6hp/RwCl4ATDdr8aY4h5gMXEAdu0ZeEh3HV8ieCFYlL4m94eAqiBZHIvyg4E6jtFOit8d/G5hwoBTj98ucyWMjqWS+eulRMz6OwEp7o6SWFPzlwb3woC75fw5xAEuejsaHmpKF98/dhdRym/8VXBSH8OH+iM/1M38/RO0yu3QX1OZhnG3XqlnyajvPMp/t1yO39qh8YzUBNmO5VmlhwxMZ/Wq3vYydKVtp4cghAtvwjq8xfuLB9FBjhvXw3ejQdrr4Fz7CPwzpl+OGT2DQechiTGkWVqkgN0Ywh2/pBtRYBL4H1ULId14/cMWgmyOQ2QAPCMs5NnNwC9AM80sonBocCE/DMgfXwCi2WbH41vsRcb/PfEONeVQhVwksVSzFYAw5Yh41HiC/34nFSVIH9nfbwJtTW+RbsWqMqSGxu1yTdXp9YmHOtr8wFNVdYdGq+TLf71EXWFChaASBQ92i/WwjRfw6ElfwrwROJ/sUJz+83o6z+VJT/rm6ZHj465yHulxtrj7ccoY+Tq0/+AitHHLk8JiCor9CJu4xwAPHuYvoh4vXO4hxyFglDDvePOhSQ88YCHrG7oxU2TiDLmNhdMumSFTuMFrYnBhZc5S9FoqjD7E0i60cJrKrJwISEAm/VgDfOxWt0xnEjPQGxHaw3rcxFJWO9Kx2i0E/uvRS/Lg8dKsfknZBLqQ2GE2WvMuxNIV55VDqPATT70VJiubcT6Hvk/ULCZzjgls//l5YTWxuA7+9fzm6sqmft67Jb+RVAAqh+PT1837+54liONPYcazc4UjSgagJJBBLQIhVvj+yktX5ymozDj/MaVs+oPspJPGpA+xMsfMvbltuTA4zsE0gEao8346EQCl6EoQ4KG
 DQAUdVFk
 jswNIOaY6IAr4y6wGMELdFKTAKJyALMejR4ORj8AQH7Hd+Wj354RnGrwcF1iuOyXbLrJiveQIEl25vz6/Vm72SqKsx5QOjRB8VGNnFWJxhKJlvuUN1nrlNA9NKtAphiOpp/a/vyi9h4w+MSqQ3JPY+WsuG/DmKGh85E2AAqODYwYuvmlW0aT4Rc/C4Gx/nX9iWxFnNBEmS/zjyP79tbnGvHqEHW4j5AtP9ZC8y61FHdylHqxWutEkAxmSavzbbXptbEhGoY7YHFokF0vccOgGVaimXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Khalid Aziz <khalid@kernel.org>

Add a pseudo filesystem that contains files and page table sharing
information that enables processes to share page table entries.
This patch adds the basic filesystem that can be mounted, a
CONFIG_MSHARE option to enable the feature, and documentation.

Signed-off-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 Documentation/filesystems/index.rst    |  1 +
 Documentation/filesystems/msharefs.rst | 96 +++++++++++++++++++++++++
 include/uapi/linux/magic.h             |  1 +
 mm/Kconfig                             | 11 +++
 mm/Makefile                            |  4 ++
 mm/mshare.c                            | 97 ++++++++++++++++++++++++++
 6 files changed, 210 insertions(+)
 create mode 100644 Documentation/filesystems/msharefs.rst
 create mode 100644 mm/mshare.c

diff --git a/Documentation/filesystems/index.rst b/Documentation/filesystems/index.rst
index 11a599387266..dcd6605eb228 100644
--- a/Documentation/filesystems/index.rst
+++ b/Documentation/filesystems/index.rst
@@ -102,6 +102,7 @@ Documentation for filesystem implementations.
    fuse-passthrough
    inotify
    isofs
+   msharefs
    nilfs2
    nfs/index
    ntfs3
diff --git a/Documentation/filesystems/msharefs.rst b/Documentation/filesystems/msharefs.rst
new file mode 100644
index 000000000000..3e5b7d531821
--- /dev/null
+++ b/Documentation/filesystems/msharefs.rst
@@ -0,0 +1,96 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=====================================================
+Msharefs - A filesystem to support shared page tables
+=====================================================
+
+What is msharefs?
+-----------------
+
+msharefs is a pseudo filesystem that allows multiple processes to
+share page table entries for shared pages. To enable support for
+msharefs the kernel must be compiled with CONFIG_MSHARE set.
+
+msharefs is typically mounted like this::
+
+	mount -t msharefs none /sys/fs/mshare
+
+A file created on msharefs creates a new shared region where all
+processes mapping that region will map it using shared page table
+entries. Once the size of the region has been established via
+ftruncate() or fallocate(), the region can be mapped into processes
+and ioctls used to map and unmap objects within it. Note that an
+msharefs file is a control file and accessing mapped objects within
+a shared region through read or write of the file is not permitted.
+
+How to use mshare
+-----------------
+
+Here are the basic steps for using mshare:
+
+  1. Mount msharefs on /sys/fs/mshare::
+
+	mount -t msharefs msharefs /sys/fs/mshare
+
+  2. mshare regions have alignment and size requirements. Start
+     address for the region must be aligned to an address boundary and
+     be a multiple of fixed size. This alignment and size requirement
+     can be obtained by reading the file ``/sys/fs/mshare/mshare_info``
+     which returns a number in text format. mshare regions must be
+     aligned to this boundary and be a multiple of this size.
+
+  3. For the process creating an mshare region:
+
+    a. Create a file on /sys/fs/mshare, for example::
+
+        fd = open("/sys/fs/mshare/shareme",
+                        O_RDWR|O_CREAT|O_EXCL, 0600);
+
+    b. Establish the size of the region::
+
+        fallocate(fd, 0, 0, BUF_SIZE);
+
+      or::
+
+        ftruncate(fd, BUF_SIZE);
+
+    c. Map some memory in the region::
+
+	struct mshare_create mcreate;
+
+	mcreate.region_offset = 0;
+	mcreate.size = BUF_SIZE;
+	mcreate.offset = 0;
+	mcreate.prot = PROT_READ | PROT_WRITE;
+	mcreate.flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED;
+	mcreate.fd = -1;
+
+	ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate);
+
+    d. Map the mshare region into the process::
+
+	mmap(NULL, BUF_SIZE,
+		PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+
+    e. Write and read to mshared region normally.
+
+
+  4. For processes attaching an mshare region:
+
+    a. Open the msharefs file, for example::
+
+	fd = open("/sys/fs/mshare/shareme", O_RDWR);
+
+    b. Get the size of the mshare region from the file::
+
+        fstat(fd, &sb);
+        mshare_size = sb.st_size;
+
+    c. Map the mshare region into the process::
+
+	mmap(NULL, mshare_size,
+		PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+
+  5. To delete the mshare region::
+
+		unlink("/sys/fs/mshare/shareme");
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index bb575f3ab45e..e53dd6063cba 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -103,5 +103,6 @@
 #define DEVMEM_MAGIC		0x454d444d	/* "DMEM" */
 #define SECRETMEM_MAGIC		0x5345434d	/* "SECM" */
 #define PID_FS_MAGIC		0x50494446	/* "PIDF" */
+#define MSHARE_MAGIC		0x4d534852	/* "MSHR" */
 
 #endif /* __LINUX_MAGIC_H__ */
diff --git a/mm/Kconfig b/mm/Kconfig
index 4108bcd96784..8b50e9785729 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1400,6 +1400,17 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+config MSHARE
+	bool "Mshare"
+	depends on MMU
+	help
+	  Enable msharefs: A pseudo filesystem that allows multiple processes
+	  to share kernel resources for mapping shared pages. A file created on
+	  msharefs represents a shared region where all processes mapping that
+	  region will map objects within it with shared page table entries and
+	  VMAs. Ioctls are used to configure and map objects into the shared
+	  region.
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index ef54aa615d9d..4af111b29c68 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -48,6 +48,10 @@ ifdef CONFIG_64BIT
 mmu-$(CONFIG_MMU)	+= mseal.o
 endif
 
+ifdef CONFIG_MSHARE
+mmu-$(CONFIG_MMU)	+= mshare.o
+endif
+
 obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page-writeback.o folio-compat.o \
 			   readahead.o swap.o truncate.o vmscan.o shrinker.o \
diff --git a/mm/mshare.c b/mm/mshare.c
new file mode 100644
index 000000000000..f703af49ec81
--- /dev/null
+++ b/mm/mshare.c
@@ -0,0 +1,97 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Enable cooperating processes to share page table between
+ * them to reduce the extra memory consumed by multiple copies
+ * of page tables.
+ *
+ * This code adds an in-memory filesystem - msharefs.
+ * msharefs is used to manage page table sharing
+ *
+ *
+ * Copyright (C) 2024 Oracle Corp. All rights reserved.
+ * Author:	Khalid Aziz <khalid@kernel.org>
+ *
+ */
+
+#include <linux/fs.h>
+#include <linux/fs_context.h>
+#include <uapi/linux/magic.h>
+
+static const struct file_operations msharefs_file_operations = {
+	.open			= simple_open,
+};
+
+static const struct super_operations mshare_s_ops = {
+	.statfs		= simple_statfs,
+};
+
+static int
+msharefs_fill_super(struct super_block *sb, struct fs_context *fc)
+{
+	struct inode *inode;
+
+	sb->s_blocksize		= PAGE_SIZE;
+	sb->s_blocksize_bits	= PAGE_SHIFT;
+	sb->s_maxbytes		= MAX_LFS_FILESIZE;
+	sb->s_magic		= MSHARE_MAGIC;
+	sb->s_op		= &mshare_s_ops;
+	sb->s_time_gran		= 1;
+
+	inode = new_inode(sb);
+	if (!inode)
+		return -ENOMEM;
+
+	inode->i_ino = 1;
+	inode->i_mode = S_IFDIR | 0777;
+	simple_inode_init_ts(inode);
+	inode->i_op = &simple_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	set_nlink(inode, 2);
+
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int
+msharefs_get_tree(struct fs_context *fc)
+{
+	return get_tree_nodev(fc, msharefs_fill_super);
+}
+
+static const struct fs_context_operations msharefs_context_ops = {
+	.get_tree	= msharefs_get_tree,
+};
+
+static int
+mshare_init_fs_context(struct fs_context *fc)
+{
+	fc->ops = &msharefs_context_ops;
+	return 0;
+}
+
+static struct file_system_type mshare_fs = {
+	.name			= "msharefs",
+	.init_fs_context	= mshare_init_fs_context,
+	.kill_sb		= kill_litter_super,
+};
+
+static int __init
+mshare_init(void)
+{
+	int ret;
+
+	ret = sysfs_create_mount_point(fs_kobj, "mshare");
+	if (ret)
+		return ret;
+
+	ret = register_filesystem(&mshare_fs);
+	if (ret)
+		sysfs_remove_mount_point(fs_kobj, "mshare");
+
+	return ret;
+}
+
+core_initcall(mshare_init);
-- 
2.47.1


