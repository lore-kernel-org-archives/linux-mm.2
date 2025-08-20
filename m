Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 694A6CA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55CE6B00CA; Tue, 19 Aug 2025 21:05:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A073F6B00CC; Tue, 19 Aug 2025 21:05:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5B06B00CD; Tue, 19 Aug 2025 21:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB886B00CA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 43605137DFF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:33 +0000 (UTC)
X-FDA: 83795342946.11.F64EE2E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2DC6E1A0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TJNxdG7n;
	spf=pass (imf19.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5c6gUgwZz1vea1f0Y4r0+NHJZn6xlXu4ov6LR/succ=;
	b=W7jfLE5eC+FjyyCJuZIB95XrkWFVVLTZrUX3KPkkf15qZnr8lNsbOqNwp3J1CwLMoDQbNt
	RorYezjCp6f4K7WSr+OB1g9WmUfhP/e03walpm5kfxK8vvm1gkHNwiqW2ql5748ozlZrOf
	GwNk6SdA8HAdjWYYmIerk5TFOeZkM68=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TJNxdG7n;
	spf=pass (imf19.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651931; a=rsa-sha256;
	cv=none;
	b=Nhz0QNsWRZO+RHB6DEUaAPy4ZQM9xdiw3+i09RXBY4XY453dtCl1Jfmc6q8KZ8REf4+Vg3
	ClfO/5gAqrVUimVUtKSlcz7nB5EDUoZ/ZW3KGFYAkLUyyAmzEeWypv+kAUJNHKIOfVlpmN
	zvOHjUsgcxQCR+09AUpIZW6jKBRbiDw=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBvvG004970;
	Wed, 20 Aug 2025 01:05:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=r5c6g
	UgwZz1vea1f0Y4r0+NHJZn6xlXu4ov6LR/succ=; b=TJNxdG7nIaxwt5fsrW9NJ
	0ZyCpVhhyouLb2tN3m6windeIj9P+Rnf6Ayt0iUxac2oE/fYgHtvDF+R7mH+M4u9
	kJZST3SwGl7GiZxoFHK0ix7/TuVbDqJSO593Tqoh9+EiIpXmf1Cph8QepIORlX33
	i5jfGLd/xRfWgY1Middf65v5/S5Y44QzLV0+FOX+PXu4L4vfUPkRvKGzVXs1DfLQ
	JsTTv5+TF11xOEnVQC8FsSR1WiqIXlM3LUwTNkvFX9QLu/yD/zx7E/mekk2jzRnt
	ngnbozolIbEHlyUCDJ0GKXwS66BF9St9J7hMFTqJxSn9IqduwRaMvs/7IxXspP8o
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqr8b5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNXLMI007358;
	Wed, 20 Aug 2025 01:05:07 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2a4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:07 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Nda011685;
	Wed, 20 Aug 2025 01:05:05 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-17;
	Wed, 20 Aug 2025 01:05:05 +0000
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
Subject: [PATCH v3 16/22] mm: pass the mm in vma_munmap_struct
Date: Tue, 19 Aug 2025 18:04:09 -0700
Message-ID: <20250820010415.699353-17-anthony.yznaga@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX/0m/BDOMomdc
 mjmcUu91DMOoaRioIccCUu/ZMLajNDbMYXYBa19rJLPyRf5+D7f1Q6tm1H7iPlpDp/PUkj6zEeh
 kOTM/Enzm2D+HZODMwqSlS8ot+iFWzmQ4CYqiHX+9NVanA6mIUUhE0vV7w/5MueGm0Z3Cm/7Bdw
 c1nMwb8yCVyEHLNDnFc0T6X3Ivlw6qiFTiwW4wVM5u5HjHL+tdRSwWRG9oRajZ1dKbMHSHhcryw
 jqEw4F/dVjEqsEWLfvRSf1dqXDoTPTnn6a75a8oNsJaoh2rgN+KV5IcqQFVme9WFzUfBMcl5Pa2
 6VVkJV3h2aT5rQKyX+Up5/TkdfMOp7N4nC1eMOKydpDMATxvqnMnUFgFBMWjJngqVuSRJ8hdBP/
 TYCr5kr/aabAjlzCUWsAseatQ5faiA==
X-Proofpoint-ORIG-GUID: GZpwVOy5OHxElfkRP804gWCLz5akPFy_
X-Proofpoint-GUID: GZpwVOy5OHxElfkRP804gWCLz5akPFy_
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a51f44 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=KjIxs5Qxk5BEPHft6hcA:9
 a=0bXxn9q0MV6snEgNplNhOjQmxlI=:19 a=UhEZJTgQB8St2RibIkdl:22
 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Stat-Signature: 8c51xiyhf5gfb6egf1x539mmdnsx8xyd
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DC6E1A0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1755651931-445315
X-HE-Meta: U2FsdGVkX19FCp8QWWO9cVDLh+EuQWYhBmKlxjgjCPpBkXV8mn1E7wJFfO/x3NVXXulrPdILcKH6GTC963u1vBawmeWzj5Cet8gcR/DkrGzTNQpCZqP/dYGDjmydfRzVjiH8s0M8wrj273TNJTGhqf/FUOI+MZrRtCOam/4GY4sUiTUhEkuYzonwKVf42PRB73YLboROvPwzfq1Leg3kVflb13cx32LSyMw47z0AgOPPWPH28654dgezX3VROOfvnCz/S8CoE6Rlqd49RY6zojZ+B2tYUeut00j8i5XMAhelXyhNo51Y3geQyuclYtV1gisObltWCFPpLjDCVznf3eFkjJYD7PugOnF0uTj2hUhNHCZik1MA+RUfpXM7HQA7VVFCnP0z7ZuqyJt8s1rT8i8C2gICh79f6wuTPMBBJNFxrVAUAgdNaDuhMOueci/x1NZJ6ShUyTQsKjB6mhRYOx0sgLBFltVq9pT8IV8OkhFZRi9JQNJmrcgQkSolJE5Tr+FLYjqv9XgXOoPVqIl2O24fZjEJp/nBUTUO0ahvsW5dD8CQby7oVQv0VvMZ1ZTq8YwK075p6jZYV0iVQDMO6rZS8R4uRKgUaRESRsjqFEFwOQxzxw7f+JfE7UyRDP4Rjvy1W2Opc35Lz9QBhxmkTFAc4qocVJacdPcmihXYBP4/rIEM1s6zvXybX4wq9u7beDSfvmSMIrv39K0hbrZLklAsH2QulK1SmaFnNKIKOkXXmXLu6Ododqt3UDpxTyVHoaEYfjWieeaF4gpYHeEmb41fk6srtbw/ju6A8KzzJdRoYZOeZeltGO+cvGoDw7+pDrShWWFTLf7F/94BDf9B1VlHm8hrx9YpCer5LmubLZpQXz/1UATyL/EYuYKNNWBWIAau7eN3RFiB3+iJclsd6MWHdjA9E+PyRbS6fi2TUqGvYB4UnBuyr3+xqhSIsHf+evCLApPOqIhQL580U4s
 k8VDFE7V
 X+YOwfGhkgP0MqBUmnO5n68aAopqTH7Dbw911kqKqtrdR+UxNopwaR2+6aAdOYz3x5U8u3/3mSGesKU48z7Ua7V2SwlbvriS7ANrcBFJ/Rl9yLn7gvzj/IRgsDouMk6WzpD3gqAk3vKG5K/ty+k3bjH/sCpbn09iuRMYT+e3nGggKKOQ7yaXfwIGDP7BqMDp5AhaaEqCRETxNdp2TsN5aJNoLuneb+wlvh1j69EC4/Is7sl5COuzHLU91+qOnqhwFfMzSquDJCgDL779nBQXoYy9mHWMcSEfg3djXB8kEHO0c491iitqXIHccBZ6OeYHO0bIFHuXXQ5duanhT1UJ3qSev0YvWAejhrG/R1NLKqJzW9oI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow unmap to work with an mshare host mm.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/vma.c | 10 ++++++----
 mm/vma.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index a7fbd339d259..c09b2e1a08e6 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1265,7 +1265,7 @@ static void vms_complete_munmap_vmas(struct vma_munmap_struct *vms,
 	struct vm_area_struct *vma;
 	struct mm_struct *mm;
 
-	mm = current->mm;
+	mm = vms->mm;
 	mm->map_count -= vms->vma_count;
 	mm->locked_vm -= vms->locked_vm;
 	if (vms->unlock)
@@ -1473,13 +1473,15 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
  * @start: The aligned start address to munmap
  * @end: The aligned end address to munmap
  * @uf: The userfaultfd list_head
+ * @mm: The mm struct
  * @unlock: Unlock after the operation.  Only unlocked on success
  */
 static void init_vma_munmap(struct vma_munmap_struct *vms,
 		struct vma_iterator *vmi, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end, struct list_head *uf,
-		bool unlock)
+		struct mm_struct *mm, bool unlock)
 {
+	vms->mm = mm;
 	vms->vmi = vmi;
 	vms->vma = vma;
 	if (vma) {
@@ -1523,7 +1525,7 @@ int do_vmi_align_munmap(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	struct vma_munmap_struct vms;
 	int error;
 
-	init_vma_munmap(&vms, vmi, vma, start, end, uf, unlock);
+	init_vma_munmap(&vms, vmi, vma, start, end, uf, mm, unlock);
 	error = vms_gather_munmap_vmas(&vms, &mas_detach);
 	if (error)
 		goto gather_failed;
@@ -2346,7 +2348,7 @@ static int __mmap_prepare(struct mmap_state *map, struct list_head *uf)
 
 	/* Find the first overlapping VMA and initialise unmap state. */
 	vms->vma = vma_find(vmi, map->end);
-	init_vma_munmap(vms, vmi, vms->vma, map->addr, map->end, uf,
+	init_vma_munmap(vms, vmi, vms->vma, map->addr, map->end, uf, map->mm,
 			/* unlock = */ false);
 
 	/* OK, we have overlapping VMAs - prepare to unmap them. */
diff --git a/mm/vma.h b/mm/vma.h
index 20fc1c2a32fd..4946d7dc13fd 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -51,6 +51,7 @@ struct vma_munmap_struct {
 	unsigned long exec_vm;
 	unsigned long stack_vm;
 	unsigned long data_vm;
+	struct mm_struct *mm;
 };
 
 enum vma_merge_state {
-- 
2.47.1


