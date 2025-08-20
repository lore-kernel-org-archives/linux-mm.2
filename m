Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE01CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7E16B00D2; Tue, 19 Aug 2025 21:05:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 488676B00D3; Tue, 19 Aug 2025 21:05:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3514D6B00D4; Tue, 19 Aug 2025 21:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 207916B00D2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1BFF1DC66C
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:39 +0000 (UTC)
X-FDA: 83795343198.08.FAFDEB7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id C51B08000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kqZ1Qy60;
	spf=pass (imf30.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNBhoc+YcWSTKbxc9VAOMiT6S5zpt8f2lVNd6yhPsGs=;
	b=JAfb1uaDym0+9I81zBC4uc/Sa5ZMKqYfh0X0+vSFjDosaIcL9uraKPa/ofU2Bmr9cez+DI
	jUcE3QkqVQzTQlQ0bHfKRMoVhYY0l5+68B4SxnXSCY3SYXSam48wWm89Y9NQOwRwsBNMDr
	afa2dK1eJbEK9wM04SbLejDA7VdfEMI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kqZ1Qy60;
	spf=pass (imf30.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651937; a=rsa-sha256;
	cv=none;
	b=2hwgczfCRsMSH4d/iaPtU7SdQyrXLuKcCTOZIobJiRdhpBfU9AJkv15FgpkF2/JwGmE6S2
	vp9Vn3g8GhcjMJ2UysAYGT15vZd6cwzWRS9yGsn4V+IkrG0iGkF6K2XfoIY07p69eyCAoy
	nODRVnkjyRHE7Y/3RORvou9ts8lJsM8=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLC7Jg006874;
	Wed, 20 Aug 2025 01:05:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=GNBho
	c+YcWSTKbxc9VAOMiT6S5zpt8f2lVNd6yhPsGs=; b=kqZ1Qy60fgqJijj34CYnH
	mnn8DCBFkvJ8aDaasVhFhShGR4dHPh1Mvx0KesTuKOA2zROjrhn71WJedww8WxtX
	kbAMmdurLhcCwKbBYCoNL9FCaQHEtlDSWT8kKmpKo1GgdJTnfRJr1qOQbo34pLpn
	/n6XScPHYwTjF+qgLWoJRJuvZcga1Fl921ChfcT84r6WYs95cyRB8QO3vPgYlL1k
	s7yTn7DvGY8GvFVh1hvj68p23sOdR3JBMhzlV9GYw066Qcp3T3ko0d6mBIZELu6h
	9e3rG1m1+hxRxPe9W0jMNKE0g/R539B3BzxjhFEorfGEWrBGvz9Qvq1z7ZASPo0E
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr854-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNwUoL007361;
	Wed, 20 Aug 2025 01:05:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2a6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:12 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Nde011685;
	Wed, 20 Aug 2025 01:05:11 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-19;
	Wed, 20 Aug 2025 01:05:10 +0000
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
Subject: [PATCH v3 18/22] mm/mshare: Add an ioctl for mapping objects in an mshare region
Date: Tue, 19 Aug 2025 18:04:11 -0700
Message-ID: <20250820010415.699353-19-anthony.yznaga@oracle.com>
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
X-Proofpoint-GUID: 6KYLXE3TpaFgkOXiCEvekb2ffu_D24DL
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a51f49 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=EF7ItLl7AAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=JfrnYn6hAAAA:8 a=gkfpIXjfDrXi2JZSh4AA:9 a=lqcHg5cX4UMA:10
 a=KzV_IjdM9kfMg8rc9Rf7:22 a=1CNFftbPRP8L7MoqJWF3:22 a=UhEZJTgQB8St2RibIkdl:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: 6KYLXE3TpaFgkOXiCEvekb2ffu_D24DL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX+xKyLrwWzz+S
 DkBTmG7J0OyaAKxYPFlj+zmqZqkYUQsJBWCr0l7NpA6HStjKdLnelBOuauFwZHNl1KMK+FU2aag
 IM7UTYQSxuaqF3XoTGeLQWlhJGBQgQz+ig1fvMNqUKl/J7JUpydagUZP53hbjErCPC/UKuUiF6r
 6xnSMQXe6fknnuIH8H6FGDxT5cQbuEc0iyQDzDpJyyezoy9e9QbZ6QBz5YsqjKmoppIYUgk1cmS
 SjobAvchPfXIfHnRH8+RlCJNOo4S1vP2WwLhTFufqvycrf78FhGwXTA0jemhAtJq79rNimtwz/I
 ntyHr4mrdVf0gPiNjA+gTolI5/s5/ZJ4fHYQ0WINLUy30aueKHUIPqg8fzIXTekxzHzgjRzTfwW
 CmUog9/8KoeuRkB/tzd7fpYBWjP66A==
X-Rspamd-Queue-Id: C51B08000E
X-Rspam-User: 
X-Stat-Signature: uz76zsjoyp4nn8yq4zp7drtnr3eig6kg
X-Rspamd-Server: rspam09
X-HE-Tag: 1755651937-464420
X-HE-Meta: U2FsdGVkX19wd8LCn09PId0az47ReMXp+kfBdPatC9bMFKblb/5VXnyIIDHNcxUSqXNyMUangOnRiYmBeKf+lb6ffNvhjAM+96ydSbh2460UgjMGM7G5XuQjg83ujWtW8H902HrC3MWuOfXohCne3v75X8NN0tcJ+NL7eiJ9sJ+/gD3pW4ust8FF6cOhwWb1vN1Evam9IY50sPf9oCiMrDU2QwRiis5TUkwRwszEZaxJ0aipshbgATnz4gRMBgbsgW7XyvAHVg5vpz6KomqWzLaiNa6JmYwRo0z+B+6DLvbxHA9OgrT7QlbqJTOD78lPSJYkdxMfVyTYw9H4/sWC7eJAWqwBBcj0f7KgM3SwEDN6TmL5yTzmoWWRbkr+QnlnP+uvXu9XQX1f07Tfnno8/U1qGPnoYSDusVDcMu/1SNmuCCfUQN9ZWfHBVzalh82ZFUZFDOtNAF5MQ+E99XCVNbmqSYdwbpD7q49bRs1zPvSJ8wZZPLFjSgJMqc+2AZiM+yAltu5aTdKemikURisGLGT9Zsns0vD+sGFoWhF3VSvw9Z/hUqnE/+ULIE08z/9cMJDLpAfe6VYG6PCHrM1U4L3a/QqFRD83WDEgd0KXhLLYgwOdTwW70upexHIKHQopIo3rhLz60gTvAu6M1NVcLsKOL6FaKKMOeKuTAhtvodqRZ/Gsn4fd0gC0qi4x/TRXQCxk6m9/MdCoa3xbItUIKrZD3uF8IMiO6DDpT2a5swkbp4v6k2ccG0IlB7UUMsRfcRO7inAUSGR/H+Q54hEM/IuT/qrdBNcup5yg4c4ydktb2UbCMI/wjmu+WnCOgdkj9mfm8OEMcvioIt3o9x1xJTyrbltAn6dI8HJFBDLSi4RPwIbg86rnrTNzLB1FJ8TZH29mHy6jmk7bM8PBDTitLmP9HtHwP5hYkpDHdSVOAG75DgoQot4pNDSqKM9pPn+TRuSK/1o+x9gWsEnz+Ix
 xC6kaNSz
 XpR2Kf3XlSoGbUuG6VlAABKg84aNgJ+6EQUt6DHnaEeDzR9sqTe9uPsLlJ09GVkUMyqbwU7bEib3Evlv/MiLbFEG1h6Vcm7CjrR1DxcZ95667z+fqjqsC3S+haTalqreLVC0h562sz9FxfKlVpsaYIaEozPjKoleZ868ung1Unlfolw4bBw5UW4ZuZmDdbTU/TGUKOPHUH9IEYbsdeCmvYSXB0hZADVeFK8JNxuY46Pn+v1kSPuo9A9PlUH4G9RqcgAXPmR2EusCbH08pgpioWqBvMQcfavaRCSo9qY2Z0fdmhdTJKWMpjtysCof2rB8lIejHASQLbplxGaBgcATVaYMw0UU6royWhZleAyKsUmHzWYk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Khalid Aziz <khalid@kernel.org>

Reserve a range of ioctls for msharefs and add an ioctl for mapping
objects within an mshare region. The arguments are the same as mmap()
except that the start of the mapping is specified as an offset into
the mshare region instead of as an address. System-selected addresses
are not supported so MAP_FIXED must be specified. Only shared anonymous
memory is supported initially.

Signed-off-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 include/uapi/linux/msharefs.h                 | 31 ++++++++
 mm/mshare.c                                   | 76 ++++++++++++++++++-
 3 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 include/uapi/linux/msharefs.h

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 406a9f4d0869..cb7377f40696 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -308,6 +308,7 @@ Code  Seq#    Include File                                             Comments
 'v'   20-27  arch/powerpc/include/uapi/asm/vas-api.h                   VAS API
 'v'   C0-FF  linux/meye.h                                              conflict!
 'w'   all                                                              CERN SCI driver
+'x'   00-1F  linux/msharefs.h                                          msharefs filesystem
 'y'   00-1F                                                            packet based user level communications
                                                                        <mailto:zapman@interlan.net>
 'z'   00-3F                                                            CAN bus card conflict!
diff --git a/include/uapi/linux/msharefs.h b/include/uapi/linux/msharefs.h
new file mode 100644
index 000000000000..ad129beeef62
--- /dev/null
+++ b/include/uapi/linux/msharefs.h
@@ -0,0 +1,31 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * msharefs defines a memory region that is shared across processes.
+ * ioctl is used on files created under msharefs to set various
+ * attributes on these shared memory regions
+ *
+ *
+ * Copyright (C) 2024 Oracle Corp. All rights reserved.
+ * Author:	Khalid Aziz <khalid@kernel.org>
+ */
+
+#ifndef _UAPI_LINUX_MSHAREFS_H
+#define _UAPI_LINUX_MSHAREFS_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/*
+ * msharefs specific ioctl commands
+ */
+#define MSHAREFS_CREATE_MAPPING	_IOW('x', 0,  struct mshare_create)
+
+struct mshare_create {
+	__u64 region_offset;
+	__u64 size;
+	__u64 offset;
+	__u32 prot;
+	__u32 flags;
+	__u32 fd;
+};
+#endif
diff --git a/mm/mshare.c b/mm/mshare.c
index 8a23b391fa11..ebec51e655e4 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -10,6 +10,7 @@
  *
  * Copyright (C) 2024 Oracle Corp. All rights reserved.
  * Author:	Khalid Aziz <khalid@kernel.org>
+ * Author:	Matthew Wilcox <willy@infradead.org>
  *
  */
 
@@ -19,6 +20,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/mshare.h>
 #include <uapi/linux/magic.h>
+#include <uapi/linux/msharefs.h>
 #include <linux/falloc.h>
 #include <asm/tlbflush.h>
 
@@ -308,7 +310,7 @@ msharefs_get_unmapped_area(struct file *file, unsigned long addr,
 	if ((flags & MAP_TYPE) == MAP_PRIVATE)
 		return -EINVAL;
 
-	if (!mshare_is_initialized(m_data))
+	if (!mshare_is_initialized(m_data) || !mshare_has_owner(m_data))
 		return -EINVAL;
 
 	mshare_start = m_data->start;
@@ -343,6 +345,77 @@ msharefs_get_unmapped_area(struct file *file, unsigned long addr,
 				pgoff, flags);
 }
 
+static long
+msharefs_create_mapping(struct mshare_data *m_data, struct mshare_create *mcreate)
+{
+	struct mm_struct *host_mm = m_data->mm;
+	unsigned long mshare_start, mshare_end;
+	unsigned long region_offset = mcreate->region_offset;
+	unsigned long size = mcreate->size;
+	unsigned int fd = mcreate->fd;
+	int flags = mcreate->flags;
+	int prot = mcreate->prot;
+	unsigned long populate = 0;
+	unsigned long mapped_addr;
+	unsigned long addr;
+	vm_flags_t vm_flags;
+	int error = -EINVAL;
+
+	mshare_start = m_data->start;
+	mshare_end = mshare_start + m_data->size;
+	addr = mshare_start + region_offset;
+
+	if ((addr < mshare_start) || (addr >= mshare_end) ||
+	    (addr + size > mshare_end))
+		goto out;
+
+	/*
+	 * Only anonymous shared memory at fixed addresses is allowed for now.
+	 */
+	if ((flags & (MAP_SHARED | MAP_FIXED)) != (MAP_SHARED | MAP_FIXED))
+		goto out;
+	if (fd != -1)
+		goto out;
+
+	if (mmap_write_lock_killable(host_mm)) {
+		error = -EINTR;
+		goto out;
+	}
+
+	error = 0;
+	mapped_addr = __do_mmap(NULL, addr, size, prot, flags, vm_flags,
+				0, &populate, NULL, host_mm);
+
+	if (IS_ERR_VALUE(mapped_addr))
+		error = (long)mapped_addr;
+
+	mmap_write_unlock(host_mm);
+out:
+	return error;
+}
+
+static long
+msharefs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
+{
+	struct mshare_data *m_data = filp->private_data;
+	struct mshare_create mcreate;
+
+	if (!mshare_is_initialized(m_data))
+		return -EINVAL;
+
+	switch (cmd) {
+	case MSHAREFS_CREATE_MAPPING:
+		if (copy_from_user(&mcreate, (struct mshare_create __user *)arg,
+			sizeof(mcreate)))
+			return -EFAULT;
+
+		return msharefs_create_mapping(m_data, &mcreate);
+
+	default:
+		return -ENOTTY;
+	}
+}
+
 static int msharefs_set_size(struct mshare_data *m_data, unsigned long size)
 {
 	int error = -EINVAL;
@@ -398,6 +471,7 @@ static const struct file_operations msharefs_file_operations = {
 	.open			= simple_open,
 	.mmap			= msharefs_mmap,
 	.get_unmapped_area	= msharefs_get_unmapped_area,
+	.unlocked_ioctl		= msharefs_ioctl,
 	.fallocate		= msharefs_fallocate,
 };
 
-- 
2.47.1


