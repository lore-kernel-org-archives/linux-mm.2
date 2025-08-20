Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635C5CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4696B00B3; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8CD26B00B4; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A545A6B00B5; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 806F66B00B3
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49873C02ED
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:08 +0000 (UTC)
X-FDA: 83795341896.12.E218B8F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1532210000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R6Ykf47M;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+H+sA2wbapk0bAi60LM8rU+Rifb31fILDaW1a9nREQ=;
	b=OhVopUdKxcP2RkDDTpfi+a1KwcX9In+jU9rDpb657BGRYYcmaFhrX8vJerinwyiGvMnAF3
	TE/5SR1lGB8h9Wc78OoTSbB1Z8pUSGUbX8RXdJNZyNxz/Qk1KF9GN1By5Aey1bp5OAFB0d
	SMJ32wX+9fFJGOL5gtrQd/bPYe90kcs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=R6Ykf47M;
	spf=pass (imf05.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651906; a=rsa-sha256;
	cv=none;
	b=Vaj2SsrH4Hae5uXI9xbrGJPe7UJUHvRdSdmVlM0fhsdnBWijiiHXvdFs26KYpbBovg7vr6
	bWSJOyPqhDxDSjVs4qLaQVCRHdT9MZ0ty7DlZbBzpxXUb2E8ysx9scgB1xAxAhx57WWw2l
	zCoxRyCKEcR4o7xCHl1k1SGX7WvHVLI=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCEq1012242;
	Wed, 20 Aug 2025 01:04:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=x+H+s
	A2wbapk0bAi60LM8rU+Rifb31fILDaW1a9nREQ=; b=R6Ykf47MjXhvjC985/OeR
	XVQkGZBP3q1CQ9WiaQXraupQua32LyA7cZULB8GPAWTmTSwLS/qCk3YMf3nP/45M
	pjVR4W74u+wlnNz2O0D0Z7sbGmtLyw6gh0ZFvQRoWFLs3SmKGGmy5vHHCGbAiPww
	SetDygntZgUFHaqH9mFwG6ukU915Us+9e8ro+95jFBh3IQKcwB8Q4Iujl276LowT
	xXfZpbZ7bC6pPv6J1uNa1QKFuzxNCrN+6gH9eRdQpetPz5dBGB+DmlaVl9bh3e1n
	KE/RDgiMpk/TM839b0GUCVQDr3PecQjKbl7pG9Ftk8lMyqx+GR+ps5gDClnaJGQF
	w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0trr8dt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNXLM8007358;
	Wed, 20 Aug 2025 01:04:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29sf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:38 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdE011685;
	Wed, 20 Aug 2025 01:04:37 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-6;
	Wed, 20 Aug 2025 01:04:37 +0000
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
Subject: [PATCH v3 05/22] mm/mshare: add ways to set the size of an mshare region
Date: Tue, 19 Aug 2025 18:03:58 -0700
Message-ID: <20250820010415.699353-6-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=920
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-ORIG-GUID: LHUwwBAlFDOKUZ1C5Oa7Uw7vETmGP-xi
X-Proofpoint-GUID: LHUwwBAlFDOKUZ1C5Oa7Uw7vETmGP-xi
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXx3Dliz+VYorm
 6jh3wb507jjHEcFE0clu3pt9XherMgo3M8okFWpuLKVV3v18+WVZ9MrDLbAbNSh/rBYC+oeCTEi
 mUV7mFEwJlu7igr87w1/qX5BoID8gLdojVVlJQTiCuEQHuXK9NokfAKVqP6lQGfewsWqZLgDOZ2
 rAd9lsgKVUgfAoXSXYHf8xUSyADucGmPpyt1Y5Kacq+MuA6gZ7ajiyxcJX2n9r2UYE6StbhnxeQ
 bkLJTtYhBQ33OksTNqeY5QvhgeI4HBqrDcSuRdnPIeiAIEtcoek17PrwPPFoG+lYv8qK6suKaru
 MYgTMkAoC+5KcYgWUMAG3AlNEhb0EO4Sud42kXQuLcCNXsfk9xXsmwS2kXMAhqzbOvcwSxvNVr/
 7WtJTJSbNs4sxi3ttoA9MzxGJtmOlA==
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a51f27 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=RpjSixA7iQhGN-bV:21 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8
 a=HTk2KgwdMEbdErbPyz8A:9 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 1532210000B
X-Rspam-User: 
X-Stat-Signature: wfftjw6mizddhwghjt1rq71ru7xwsyd5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755651905-162394
X-HE-Meta: U2FsdGVkX190Y7TxLO98v/tjYWcqss8DqoJZSmRkkiWetM8RSzC/M1iq7Ke3t1M1R1FTg5WKY+sE2N+gTITLqhQF+MWlhkcVn/ffB3rvxySU2jz0S7WA91ksrBFdzst4ItQTpB3lPCBuBp0sW5wrVjJIVSi/EoHggOsw0rHwyDTZlDPI5i+0Hg2Nk8JiwSY6XoWlRbd7Y90yZsQwPDhDIaDfGF43aWszcbj1f1ojlIohZeRmP8O/v4xvm2ct3KmfnzfLghpruKBSHInWeWnE13TqqgGh5qMuVBwUGoW+iz6t6ZrIEfN/kc1ynXwx81DSBLWRhUYv5YUdaf3otgFBbt+dTtHWyxQtj1xGkKoyMD8C/sntYIOxrDKp7w6WCfSEmB6iN2b06jiYF4f1gfjI+SxlLanHOZxfDg37rlNe42v9NQQW1Au+1UBLrR+PWbbDCX3C/VBKxUulvzTDwKxyBkE1LuW1EX5pDRnhrvF6gx9LYv6c6v66oz5z+W2OYVqfSMjFeMQGFwLeJs/19SgzIutkXbGYalfOCySoGKsmpLHxCkmBFY7OkYvZ1q8X03Ldmtd6i9F9GFdRGdYB3qAdIANvXPRQEXu1/X8xvCce+lTmdFRgTmihsMwzRqi3yypiH8lWu02b8JoNJF/GDdJQeqIxtKkLfAmC8ew9cbIddeWQXlHpTPgeMVIAa71QeYKJX/Zh8gxS/YYjStgfJi4M1Fym4Ylxs/uov3xJIIBQAiM0AYwMRA24lZR/qaG2VeIbvxmDER+3qwXtv+ztn1iJ96BozaTmmAjZilwJ9s8ryxMg/InBo30EEUdb304EBxsG1hiw9JcWfTbcPcyUsZfhUwPvVGjm/g9+Mu/NkV2sEHMEDpxYP0/OWpUkHlqhBA0AO5kIIOfhjqu1hRA7B8nEzaBGW2NMFOyTKmDzOJ7yekljJRoxuCuFEhX81qp41TTfYd4owMKrL/XE9uLi1wX
 QAiplXQX
 Tt0P8eOB5Pk1oZF6VuxBNE1o1LDyGUrmGm+q6CmZZIhfkyMRg+sS0ChE49zbM1pRrlPeGFFL4/oEuPFRYsopPnTE1mY5/8BY3cbVMzvWV5acps99ZrASJX0IwH6P8k0RCemTcaxTBKGA4w+I63QWDuE9A7yY5AmCVrcpoODrpKgKJuxNjPPSrKnTa6mXXx6ICZ9JwuiOH4MgaynceA+s9PWCgzYuI9dyyEO48y9rfvAGRVR7Y898Sa8jvVxq66LeUKOpy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add file and inode operations to allow the size of an mshare region
to be set fallocate() or ftruncate().

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mshare.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 86 insertions(+), 1 deletion(-)

diff --git a/mm/mshare.c b/mm/mshare.c
index 400f198c0791..bf859b176e09 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -16,19 +16,78 @@
 #include <linux/fs.h>
 #include <linux/fs_context.h>
 #include <uapi/linux/magic.h>
+#include <linux/falloc.h>
 
 const unsigned long mshare_align = P4D_SIZE;
 
+#define MSHARE_INITIALIZED	0x1
+
 struct mshare_data {
 	struct mm_struct *mm;
 	refcount_t ref;
+	unsigned long size;
+	unsigned long flags;
 };
 
+static inline bool mshare_is_initialized(struct mshare_data *m_data)
+{
+	return test_bit(MSHARE_INITIALIZED, &m_data->flags);
+}
+
+static int msharefs_set_size(struct mshare_data *m_data, unsigned long size)
+{
+	int error = -EINVAL;
+
+	if (mshare_is_initialized(m_data))
+		goto out;
+
+	if (m_data->size || (size & (mshare_align - 1)))
+		goto out;
+
+	m_data->mm->task_size = m_data->size = size;
+
+	set_bit(MSHARE_INITIALIZED, &m_data->flags);
+	error = 0;
+out:
+	return error;
+}
+
+static long msharefs_fallocate(struct file *file, int mode, loff_t offset,
+				loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	struct mshare_data *m_data = inode->i_private;
+	int error;
+
+	if (mode != FALLOC_FL_ALLOCATE_RANGE)
+		return -EOPNOTSUPP;
+
+	if (offset)
+		return -EINVAL;
+
+	inode_lock(inode);
+
+	error = inode_newsize_ok(inode, len);
+	if (error)
+		goto out;
+
+	error = msharefs_set_size(m_data, len);
+	if (error)
+		goto out;
+
+	i_size_write(inode, len);
+out:
+	inode_unlock(inode);
+
+	return error;
+}
+
 static const struct inode_operations msharefs_dir_inode_ops;
 static const struct inode_operations msharefs_file_inode_ops;
 
 static const struct file_operations msharefs_file_operations = {
 	.open			= simple_open,
+	.fallocate		= msharefs_fallocate,
 };
 
 static int
@@ -128,6 +187,32 @@ msharefs_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	return 0;
 }
 
+static int msharefs_setattr(struct mnt_idmap *idmap,
+			    struct dentry *dentry, struct iattr *attr)
+{
+	struct inode *inode = d_inode(dentry);
+	struct mshare_data *m_data = inode->i_private;
+	unsigned int ia_valid = attr->ia_valid;
+	int error;
+
+	error = setattr_prepare(idmap, dentry, attr);
+	if (error)
+		return error;
+
+	if (ia_valid & ATTR_SIZE) {
+		loff_t newsize = attr->ia_size;
+
+		error = msharefs_set_size(m_data, newsize);
+		if (error)
+			return error;
+
+		i_size_write(inode, newsize);
+	}
+
+	setattr_copy(idmap, inode, attr);
+	return 0;
+}
+
 static int
 msharefs_create(struct mnt_idmap *idmap, struct inode *dir,
 		struct dentry *dentry, umode_t mode, bool excl)
@@ -182,7 +267,7 @@ msharefs_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 static const struct inode_operations msharefs_file_inode_ops = {
-	.setattr	= simple_setattr,
+	.setattr	= msharefs_setattr,
 };
 
 static const struct inode_operations msharefs_dir_inode_ops = {
-- 
2.47.1


