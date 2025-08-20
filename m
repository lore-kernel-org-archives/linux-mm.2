Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A5FCA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4076B00D4; Tue, 19 Aug 2025 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73F56B00D5; Tue, 19 Aug 2025 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3BE86B00D6; Tue, 19 Aug 2025 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BF72E6B00D4
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FE59583E2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:44 +0000 (UTC)
X-FDA: 83795343408.18.B5C4BAF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 737ED14000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CK7XsvN6;
	spf=pass (imf26.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U4HJJF0kT82Axkedvm6cvuJARVtxnZRVAJyk6ERDIjM=;
	b=s54pkwEp/Ggr8GJQTLPXalNgqMSXlWs96amgej0nevGPUduijINF73C+YL+7dZVL3i+tmW
	PA9RiT0Sw3Jh4YeRwmLszjU4mPNhJvgAlbW3Qh/SrDPvFIa825BGRLOfxAgvlUD38Dvp6H
	xTOWKjhO2oQ64IYOmMtwjszdWtv3Sq0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=CK7XsvN6;
	spf=pass (imf26.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651942; a=rsa-sha256;
	cv=none;
	b=RaeZ/ETO7AKHkKIp1T/jvOWbcANVdw3amchINcZR9dDmDIK1RNrS1KyIXXoOZr9ZqHroGa
	yPncT+KVHtturSrGvOEiMX5fHdaJk5PU3p/OIm+BcP8tfHUS5zMG1aBaNdvPlPdPfwDiHw
	ME9A1jn58DCShyeEwnGDtispXHp5Qe4=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBnPc004722;
	Wed, 20 Aug 2025 01:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=U4HJJ
	F0kT82Axkedvm6cvuJARVtxnZRVAJyk6ERDIjM=; b=CK7XsvN6rvcD7Zupjeg5X
	Ndh9sJleqGacn6JLqO0fgZv0/6AtmxRPDx+lDH8kFekLdygetxOw5o3j5Rt1iPQh
	Ltt6ZMlZVPAVN4vlUZFTXR6w1+7jTfjszbbnOj82K8TrH/8oWp8fg/VxbrdHzLbg
	v8VuBryVrG8t5YxXk18NwaA2KnwOOr/PRWhXjF3/1m79K921+ER0kiolxV5Gbi6Z
	ym7K/+z7L9hncg/66izRvioYM5ByowrjcrcfIzs6rNpQyZJWXguG5mWk5Gp0Dq6y
	e2ZfCqLFgf4xEgFqn9IcVgprLCYYAWA+7aqhzNIq0fw1uNE5SYpgvNTHTd3ZGUUx
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqr8bb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JN39es007104;
	Wed, 20 Aug 2025 01:05:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2a9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:18 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Ndi011685;
	Wed, 20 Aug 2025 01:05:17 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-21;
	Wed, 20 Aug 2025 01:05:17 +0000
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
Subject: [PATCH v3 20/22] mm/mshare: support mapping files and anon hugetlb in an mshare region
Date: Tue, 19 Aug 2025 18:04:13 -0700
Message-ID: <20250820010415.699353-21-anthony.yznaga@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX2k3PXK72Qe4k
 1dRywlpIWn1TF8G6IA+amQjnns06VIRSoOhrhwH97/DPeZopg7zbcy+1zz2ERVjTJnPe5qapaM0
 1XYINXRshxWmpVav31HI94SLLMD67TA2bw/pzEYyjy4louZ8Cp5zPXfaO6zdxtJ/R6s7Cw/XWti
 p2hEu764Ge4PpFzMOlp4B9qpKkO7cJlfoYYhz0X8OF9zxj9XPCF19VFZS7GVgDaZSHLQOAPOOZU
 y2xNNNKCWkDmL0HwEMwfFTRgMUWxoxLQAclotjuUD3b5ijsInTXUixM1N5XSnYX/0hjqNF80Vq8
 1xYkuYqU2XMsGkxREnhSute87OMnlobolzbWxyut2Bx6/Fb9fAGemSOknKcogxkxJ4aChj6Dt2C
 SYqmcQq5Mrtfmy5gqz3PmPmcsfJJyw==
X-Proofpoint-ORIG-GUID: OZAPdZWoBtvoOPQXRPTcW7j3zLPp_reX
X-Proofpoint-GUID: OZAPdZWoBtvoOPQXRPTcW7j3zLPp_reX
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a51f4f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=fqiw4W1tFLHFuho4Wq4A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 737ED14000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5zqfr84qdh94ccenuu4wjt54ghk9b8zp
X-HE-Tag: 1755651942-463677
X-HE-Meta: U2FsdGVkX18aF0mLGvFUIpmB6r01mNADUIRwnMlg0cfIJtvLFivAcGoCYRJdry8fWNG2KiT6r/iqnWQhhFWbBG82GKlfNYHHsaKuqHbDufVATdVP72wySYHzLEl/atx961XTCxGzX0J36Y/qJxoTh57fWiaYttbF90x2mAXObS/hSvrhScdVTuoHyqgvdIl2/MmNwisuG9fyRW50KHjg1n55MU+7PT1Q2K9Sc0XjvzlaiCm/sdBXoS88irmIhPyoHCi6roJ0GPFQIskSwBdBWUGruxeapzE1OEgy51CVhBOk9xDRKonN1nS7yWGEobKSE9s3P2ZCunBDrUOSetwf/RdxzqcGKavTVT2/+cGpOL/NODtnCl4l8N2aGvIrjyqWtkDOdb2s6Fqcc5vZLnp7c5xFt3UHSl5Xr99iyR0c04nXTaLpRLxY4aTBOnN/b3pcySEwt8Skaao/CLT4nRXpAUWn5RhsMNS/MqLzEsCbWn4nJDfl9Lcgz6hXNzVAkvX4HzriKAWG3FGOdEL3HIoF8SH3qi2W9qIKExp5jgpf+x0lC36nn5xfMiJ2dbIoeJ+VDT/pgpD4pi+qL3SG8UcuuK6PPMSfdn8lItm5E69IlQnc9+PfeMzN7HmoeJzLqDXgIXs0JDvNhczRDUwHFkO5TmFKvP1ZNFMPz9o8AdsoyYb4ABz1OUY9f9GFo0DSG38cEHSz6VwvJi7mCU1g4Zwz1Gu0tDixGmHE4dDuB5r1Nj+4SET9yiJCsue1ZRwK6504llkFXWxvrJ6LWGo+dplOWXDh9E2/zdXBbRXEBFcPtddQfEw87pT08JfVqv3RJiBDrb/fPX3u1LnxsnwIGQjy/V0HSZAEhRov2dJeAAIuNDZLB9e2tD6XtIEMcK2d9P50RQxYimQxzvCFvh/c2uMhoT+/9d8/nXdfmFM6aCDRVlc6P9s6ZKW3CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The astute reader will notice that the code is largely copied from
ksys_mmap_pgoff() with key differences being that mapping an mshare
region within an mshare region is disallowed and that the possibly
modified size is checked to ensure the new mapping does not exceed
the bounds of the mshare region.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mshare.c | 71 +++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 63 insertions(+), 8 deletions(-)

diff --git a/mm/mshare.c b/mm/mshare.c
index b1e02f5e1f60..ddcf7bb2e956 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -14,8 +14,10 @@
  *
  */
 
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/hugetlb.h>
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/mshare.h>
@@ -345,12 +347,15 @@ msharefs_get_unmapped_area(struct file *file, unsigned long addr,
 				pgoff, flags);
 }
 
+static const struct file_operations msharefs_file_operations;
+
 static long
 msharefs_create_mapping(struct mshare_data *m_data, struct mshare_create *mcreate)
 {
 	struct mm_struct *host_mm = m_data->mm;
 	unsigned long mshare_start, mshare_end;
 	unsigned long region_offset = mcreate->region_offset;
+	unsigned long pgoff = mcreate->offset >> PAGE_SHIFT;
 	unsigned long size = mcreate->size;
 	unsigned int fd = mcreate->fd;
 	int flags = mcreate->flags;
@@ -359,37 +364,87 @@ msharefs_create_mapping(struct mshare_data *m_data, struct mshare_create *mcreat
 	unsigned long mapped_addr;
 	unsigned long addr;
 	vm_flags_t vm_flags;
+	struct file *file = NULL;
 	int error = -EINVAL;
 
 	mshare_start = m_data->start;
 	mshare_end = mshare_start + m_data->size;
 	addr = mshare_start + region_offset;
 
-	if ((addr < mshare_start) || (addr >= mshare_end) ||
-	    (addr + size > mshare_end))
+	/*
+	 * Check the size later after size has possibly been
+	 * adjusted.
+	 */
+	if ((addr < mshare_start) || (addr >= mshare_end))
 		goto out;
 
 	/*
-	 * Only anonymous shared memory at fixed addresses is allowed for now.
+	 * Only shared memory at fixed addresses is allowed for now.
 	 */
 	if ((flags & (MAP_SHARED | MAP_FIXED)) != (MAP_SHARED | MAP_FIXED))
 		goto out;
-	if (fd != -1)
-		goto out;
+
+	if (!(flags & MAP_ANONYMOUS)) {
+		file = fget(fd);
+		if (!file) {
+			error = -EBADF;
+			goto out;
+		}
+		if (is_file_hugepages(file)) {
+			size = ALIGN(size, huge_page_size(hstate_file(file)));
+		} else if (unlikely(flags & MAP_HUGETLB)) {
+			error = -EINVAL;
+			goto out_fput;
+		} else if (file->f_op == &msharefs_file_operations) {
+			error = -EINVAL;
+			goto out_fput;
+		}
+	} else if (flags & MAP_HUGETLB) {
+		struct hstate *hs;
+
+		hs = hstate_sizelog((flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+		if (!hs)
+			return -EINVAL;
+
+		size = ALIGN(size, huge_page_size(hs));
+		/*
+		 * VM_NORESERVE is used because the reservations will be
+		 * taken when vm_ops->mmap() is called
+		 */
+		file = hugetlb_file_setup(HUGETLB_ANON_FILE, size,
+				VM_NORESERVE,
+				HUGETLB_ANONHUGE_INODE,
+				(flags >> MAP_HUGE_SHIFT) & MAP_HUGE_MASK);
+		if (IS_ERR(file)) {
+			error = PTR_ERR(file);
+			goto out;
+		}
+	}
+
+	if (addr + size > mshare_end)
+		goto out_fput;
+
+	error = security_mmap_file(file, prot, flags);
+	if (error)
+		goto out_fput;
 
 	if (mmap_write_lock_killable(host_mm)) {
 		error = -EINTR;
-		goto out;
+		goto out_fput;
 	}
 
 	error = 0;
-	mapped_addr = __do_mmap(NULL, addr, size, prot, flags, vm_flags,
-				0, &populate, NULL, host_mm);
+	mapped_addr = __do_mmap(file, addr, size, prot, flags, vm_flags,
+				pgoff, &populate, NULL, host_mm);
 
 	if (IS_ERR_VALUE(mapped_addr))
 		error = (long)mapped_addr;
 
 	mmap_write_unlock(host_mm);
+
+out_fput:
+	if (file)
+		fput(file);
 out:
 	return error;
 }
-- 
2.47.1


