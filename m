Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83FACA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 091EC6B00B2; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069438E0001; Tue, 19 Aug 2025 21:05:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E99E66B00B4; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D02576B00B2
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91A7A80DC6
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:07 +0000 (UTC)
X-FDA: 83795341854.01.61D04A1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 57C9C40002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qx3zTwpE;
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQFnq88K9K4MmLcnD5W2me3DfjuW88ktErhJymD1WnQ=;
	b=493/0B96AOlM4FVgvxi3EsXDosUUvt2UFh725xoDyid6MBn9bY7Ot9aOjDvw64gYS0spxe
	VoatcpsAbPVTPv2sv8dVzAfx2qFuHa7ibcRlSfj+w3Ee3uqDAfoBUFPQwZ4zi+kZM9z6PQ
	+VfsQtp/j4izYXj2v+lTzdrVnQUQ++U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Qx3zTwpE;
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651905; a=rsa-sha256;
	cv=none;
	b=0ait7LMYOJIG2peP46g6hHhEk8sAMk/8fDfuEb5ZG88ttZzZDDacyPyXabliHvlywsWvda
	WW12fE4BiRF1hssrBV9lVIUk8FhM0tYJDj+lbSvvWgR5SfbhPVrmiTWC1NULQI4JOjilV6
	hX6E4/HRiiin6JJRuyh/V3/1IRdRQTw=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCHN2012275;
	Wed, 20 Aug 2025 01:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=fQFnq
	88K9K4MmLcnD5W2me3DfjuW88ktErhJymD1WnQ=; b=Qx3zTwpEPQiJbr5opLwnj
	wmakVtwduCmaE3tTazo7NJUMAQCEHfLwh7/zfEi1FrWDp2Vyff1swsmjQJBz87zj
	OAfNy32xhgUU9kOHk8s7RpobXBdEdY+yOvJaWo/BNTS9HGwocgV6O8pXxTCChtrG
	rZwz2r4wnyN571Uo8xFztiEtXDAyr+UK4OPRZBPzJzOBdObLKE8k4aVKjoXZVNQK
	D8+MD8pxuZcp7k4rSuQSMC4a/t8pYWx5JOMI/iGx4wxkli24AaMDti/E0VD8F/a5
	DYVCSKIqyRn8bJqVxiK9LodcEIykI2AC9sxpYuuS8CuEynLfXThTFnMotro2nkd1
	A==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0trr8dq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JN314f007380;
	Wed, 20 Aug 2025 01:04:36 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29rq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:35 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdC011685;
	Wed, 20 Aug 2025 01:04:34 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-5;
	Wed, 20 Aug 2025 01:04:34 +0000
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
Subject: [PATCH v3 04/22] mm/mshare: allocate an mm_struct for msharefs files
Date: Tue, 19 Aug 2025 18:03:57 -0700
Message-ID: <20250820010415.699353-5-anthony.yznaga@oracle.com>
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
X-Proofpoint-ORIG-GUID: cHfUWM3KGiFs7FJoiOuwHErwqfvdF0rU
X-Proofpoint-GUID: cHfUWM3KGiFs7FJoiOuwHErwqfvdF0rU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX+V+sG7is/uC0
 FR8t0L4s8S37T0jKbVUSzYW6Vn+KN5uC9PmxNS7i0HKw54PL2u8Qp/FFBHiTpwOsLkWb+9Mx9Q2
 hJ6NgARxnInuZ+mJmpbVfRngMlyviPDYAmmiQTCNKzP0kHb38TJSe90pNUE77CtzcJGanBgACoD
 SSWuuT6/F2qkhR2P3HcNz5zSvKYFy9KFBoT+Zxg+/1wQdGgb6K4Ckaz9o/owAOOcsUVZpOGBK6l
 Kkz00FvgZWY2B9zMQSZOzcK5auVBWnCmmqu8Nq9YoO6P6xo5c3uJlYSlx+9a5iFb4Fm0o0UOCik
 KqIHJhthilO7tzm7Ja7Co3S24Yy/AgarEGSvpi3RD3pTF5GHiqCZFJYn4JK6Ot/+VAVkCEOheFK
 rAvygBTEBSS88CrUSVjGknuTdiV1/w==
X-Authority-Analysis: v=2.4 cv=Qp4HHVyd c=1 sm=1 tr=0 ts=68a51f24 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=eZrgD7rVaXJ09-4h1GUA:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 57C9C40002
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: q8m8ywcb3sgkhwwexksuf6ctycn3uwui
X-HE-Tag: 1755651905-619818
X-HE-Meta: U2FsdGVkX19okrUUsFNvptVOMCIacgGoq7mdi7NFoZMu6qJusWbgLjJJz5g2ssR9q/PgaJfFdAZVjNKHi9oPTzd6SCwpv221X5SGDRc21FEQMKycPogUt1gIK8g0/e1/69TwhkYbXPif+wiGlBW7W9JFVwNDD4+J6nPajuZC5UUGplRbGpK9I9U7IthB2NgBVULbsR435FsXgdf+PteJWLdnnxQfq2ofqylaj1JJqg4WDCCp2JvpxCYh1godM4bXl64l/3bNZUP0RLUG1EIom+XBj7ClqLJdpyv0sd9bOh7X1UVi+nDNt1kejLM6aDFOA3Rp1ffQy5q+9L5RrAt7Q4TQ5HNtqKyGqWlaDFUBrHimTTxdODXrMpnTyRhp7d9uer2opBZmoBHfQxxOVS1yOMFvt08AIfYAeES8C+pMeGFYWY4t52Jh4WCz6MJGCl63g0/8KbdeRVKEz376i/QHLQXuiDJBOXq14v4tytbzijf7z+zwSQD867H5SGmwQANrp5C8MRW0ilh9EJVPJDm8IyElHybi7rAJy5fbXzFLV0pdLobrTG5NP3h5ptoXrOWCClJLbe+kAKIHWn06VzaFpCElvn1pW6/0sk6L5wQ7IIL4JlSkyTJaSBWP5Iu43DL1/VwntB9+bPlzYP2V+UhytzyWL1ZyhHA1kMMuOxcULLXFn0Jr63cUYaqOESDExdaObMxhht8G6UGwCDvTU82OkuQw2uwhFeCQRrLa7lPxnwjuOzWOczKzeD8zsRM+Dacl8MoJ08YotcdSmhFG00cUPu0PfckLrHrGJTZbR72pxXBHLHulG7e4b/rn4AGx5bEiNpjy/ZsPaxtij4CVpJKclxlBRbzmqZyt1qDB+b37i+IpKIJb4EpYvkVfHoLPvhecKfFAVzWoRIHidebBCB4Whfbz8eclqu8ReEc+US3aAOT+6sB6FYpbufb6Nz6z2TKsy/M+6A6u547mFGSEn2T
 c0kKs5LS
 xgPNlPfHN7FeMHHtoa7CAVCZSS6jTyzXiDLEPnmtJuKSwTB46rW59/X/qdya7KAJ9XvTjwZscOKEnEGUddpgLg80Cl5eFi3ipK7L0Tb0mhyFwgTlmvqJGP+Hb5+0H0RH5PkFQ77tUjGeWFsTqWc5SJajFConJo7oqXNoZhrUio9i0x07SFcD+AUVRDLP6FodLwasI5Uvye+11p32v4Wt9xwoqC7GgGNcVDso8laGzGrk8SF0t9vW0tANCRwzSYy8YdutrP5UP/jKCcqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a new file is created under msharefs, allocate a new mm_struct
to be associated with it for the lifetime of the file.
The mm_struct will hold the VMAs and pagetables for the mshare region
the file represents.

Signed-off-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mshare.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/mm/mshare.c b/mm/mshare.c
index c43b53a7323a..400f198c0791 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -19,6 +19,11 @@
 
 const unsigned long mshare_align = P4D_SIZE;
 
+struct mshare_data {
+	struct mm_struct *mm;
+	refcount_t ref;
+};
+
 static const struct inode_operations msharefs_dir_inode_ops;
 static const struct inode_operations msharefs_file_inode_ops;
 
@@ -26,11 +31,55 @@ static const struct file_operations msharefs_file_operations = {
 	.open			= simple_open,
 };
 
+static int
+msharefs_fill_mm(struct inode *inode)
+{
+	struct mm_struct *mm;
+	struct mshare_data *m_data = NULL;
+	int ret = -ENOMEM;
+
+	mm = mm_alloc();
+	if (!mm)
+		return -ENOMEM;
+
+	mm->mmap_base = mm->task_size = 0;
+
+	m_data = kzalloc(sizeof(*m_data), GFP_KERNEL);
+	if (!m_data)
+		goto err_free;
+	m_data->mm = mm;
+
+	refcount_set(&m_data->ref, 1);
+	inode->i_private = m_data;
+	return 0;
+
+err_free:
+	mmput(mm);
+	kfree(m_data);
+	return ret;
+}
+
+static void
+msharefs_delmm(struct mshare_data *m_data)
+{
+	mmput(m_data->mm);
+	kfree(m_data);
+}
+
+static void mshare_data_putref(struct mshare_data *m_data)
+{
+	if (!refcount_dec_and_test(&m_data->ref))
+		return;
+
+	msharefs_delmm(m_data);
+}
+
 static struct inode
 *msharefs_get_inode(struct mnt_idmap *idmap, struct super_block *sb,
 			const struct inode *dir, umode_t mode)
 {
 	struct inode *inode = new_inode(sb);
+	int ret;
 
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
@@ -43,6 +92,11 @@ static struct inode
 	case S_IFREG:
 		inode->i_op = &msharefs_file_inode_ops;
 		inode->i_fop = &msharefs_file_operations;
+		ret = msharefs_fill_mm(inode);
+		if (ret) {
+			iput(inode);
+			inode = ERR_PTR(ret);
+		}
 		break;
 	case S_IFDIR:
 		inode->i_op = &msharefs_dir_inode_ops;
@@ -141,6 +195,19 @@ static const struct inode_operations msharefs_dir_inode_ops = {
 	.rename		= msharefs_rename,
 };
 
+static void
+msharefs_evict_inode(struct inode *inode)
+{
+	struct mshare_data *m_data = inode->i_private;
+
+	if (!m_data)
+		goto out;
+
+	mshare_data_putref(m_data);
+out:
+	clear_inode(inode);
+}
+
 static ssize_t
 mshare_info_read(struct file *file, char __user *buf, size_t nbytes,
 		loff_t *ppos)
@@ -158,6 +225,7 @@ static const struct file_operations mshare_info_ops = {
 
 static const struct super_operations mshare_s_ops = {
 	.statfs		= simple_statfs,
+	.evict_inode	= msharefs_evict_inode,
 };
 
 static int
-- 
2.47.1


