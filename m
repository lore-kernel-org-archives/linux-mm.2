Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9AECA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 02:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F826B0088; Tue, 19 Aug 2025 22:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06366B0089; Tue, 19 Aug 2025 22:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1BFF8E0011; Tue, 19 Aug 2025 22:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C086A6B0088
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 22:18:10 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15AEBC0302
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:18:10 +0000 (UTC)
X-FDA: 83795525940.27.EC8DA13
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 03EDF1C0004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:18:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWQsvBL0;
	spf=pass (imf21.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755656288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vzGmxD04TI1mSj9V+t8aruaidXWI36zruInJlfX4dNY=;
	b=oVg3fRUxUv2miraqucklbPkjHKmyWm+u7aCZCeR3EouYJPBILM+nJY/Mg29oRxNa3p1Nrm
	B1kg8Dlywz1QxpOLNLRjwo40etQ4v9dyy2B631nZLZ/CbrsCAEv/LwIF9ahDv0MzR/HLUJ
	nyIxnFgqaAQFfTh79+CSQWxRlECECvs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eWQsvBL0;
	spf=pass (imf21.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755656288; a=rsa-sha256;
	cv=none;
	b=rDvHTa4T6cnEKZANCRxONxTC72MGWVAWm0MBCuQOET90iFdQ96oOMpbC7AQJHzcYa4DsgM
	RQ4epi/3j+kzg9TL9aqhlmS0dy5t5fe9WiIMRC0ePA1zcOURKvV9G/9VOUsFIlGiJpvEju
	8/FaXPI0NFS7Y/1fWas1puly1U3jOUM=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCUxL017628;
	Wed, 20 Aug 2025 01:04:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=vzGmx
	D04TI1mSj9V+t8aruaidXWI36zruInJlfX4dNY=; b=eWQsvBL0w0HGsmRYPf6QJ
	nKgKCB0Ak6IKgVB31Cwbq4ZFRGACcRwkED1X9KA/yjb8SIGcNRrk5Dzeb4hf2GbE
	SJF78ULl3t8V1t4EdUl4TsrZ3viw4H3AjsYtAkWPv6QcEjwFs6JurtluZbJnqgZG
	w7NeF3RniN/YQ4PI4XWF6FtIv/2XVU1pvkAyxso3d15RgS4wYHQsM7bZN/N4Ert+
	nh8Zw2rAdvM0v7eLENDcFtuw+EmcCr/SYIiUaSFtKbiNz+gzrje+YuVvlTKPpk79
	9D8Tc0gN9RCjcSKvZaFiNv+HatM6FUqK8SoX0Fa9uA8gXFVIibcD71jtER1ETWmg
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ttg8bu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNsqtx007279;
	Wed, 20 Aug 2025 01:04:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29qj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:33 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdA011685;
	Wed, 20 Aug 2025 01:04:32 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-4;
	Wed, 20 Aug 2025 01:04:31 +0000
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
Subject: [PATCH v3 03/22] mm/mshare: make msharefs writable and support directories
Date: Tue, 19 Aug 2025 18:03:56 -0700
Message-ID: <20250820010415.699353-4-anthony.yznaga@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX6nrVr8GQuiM2
 KpjmSaQeCD+L4Xo8HZem/Sq+wiCbpltxbCytOR+N8x61m38VYPq6poGPjOnGit/hsZYn8ivdRgF
 bY5K+BX2GWQk6V1LjuiSqrdzBsKYtKOb44Uf/vAL/OjS4aY5Ilq4yLEEacafLde7CuWUTVvqH2P
 1furpmQ6sPJr71xRnjQ8XqEY8N8V18arQD7y6SGMZlQBkspOKSx1nTanvVEWmXMfxt9ZddnzjW+
 KMKf8+WjGcVZnYnNDFAys09xbO0fKtzCWwU151mf1HZDyB90k3kE0aaCrgqKvFTlqpbJAa9LzKI
 exHqAx/dG6oABfEE2CBw+NrYTwuadPkrDFv2YqrZawWDcEsiHyp79EuoAsCQb33VofrnXTWMjYc
 EGpUw5V/ABbuV5d98GU7IUMv7B8dOQ==
X-Proofpoint-GUID: wwEvDZgrz76BuuzQ800K3COTnMBSVo6E
X-Proofpoint-ORIG-GUID: wwEvDZgrz76BuuzQ800K3COTnMBSVo6E
X-Authority-Analysis: v=2.4 cv=V94kEeni c=1 sm=1 tr=0 ts=68a51f22 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=-pbL9rYvnyYrJvq5bQ8A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Queue-Id: 03EDF1C0004
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ze1mrexc44f8j3attcyi5ow8u7yow5e8
X-HE-Tag: 1755656287-288013
X-HE-Meta: U2FsdGVkX1+fe2iGoBcVRDIdbKnp9Il1CPt250wlHDPP7S03yWmD9gy+ATAkclIK+FgIQLXDYxnZ7sI7e9w+B7EGHRFQRWh60Ju/2V8QDjgx+d/m7Cx4N38yUjCmtnlEq56rBRxpbDZ01MfL3JMXmj9QryN0Xjo3Fdb9Y/ok0SJ7PH8/PAiV8SDe4jMu/UV9sEMoAds9mR0IbSMH8TkC4sBOR/L5xzVieEiLxqCUfFKuRuf1M279HIE0V72FYaKx1B7fCi10EP8F8WrhXExH4udQQewxOfd1H5uX04n2Jp17FOEsKArKej1UTefxYKH3yPGmpYG53parrvi90TUGmyScl0AIz9F2cfGzx4b8kXMB84C9S5OCaL6BfachRYmxdc4Yjzh6chJdS2gKV5dXq8gdMNJlmiCi2DzDDH3E7dJE0oZpke3tE+3bVRin1JQdDH6+XrlTg2wx3TrCZSc1uJAva94+feiNfk0nHK2ZvTJUz8uY6hQ26kP9DePchb31Ng7CPZMQVvK0Ts3frVpLAGAWyLGyY8zP9TuFH524yxu8uWvRiyfPYbK5ax9uzuhwjgkS0pJ0yEom4qpDg59t9SBRiNJPKGuRRuP9gnTGNghAXUnOtxbrDJPEC4Q5ORfWFK9R/2rB5AL3cTCtqiA9md+c2NfQA9t7uFiCt9EWXwf1aaOu5mprbuSEMFV5M4hjSOY3WdihT4+oWcxFv+0vy+jNXthvtFHbJZZzysZirK9x1R5A09Ait0+6G7q+TnSnHXd1/Wt7ajdw2xgJKfq2E0jgFDfgT1cHI+fSYPNY915P6A95iG4f0TXBe3nuDPiYVa59ycHK9VFPHYIkINTEUlT0Xsf5f3Y7rZ4U/8RoPom3qL5S/gUtp1O7ixyte26NtRN2FSFlAAgz+6aOq+99IQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Khalid Aziz <khalid@kernel.org>

Make msharefs filesystem writable and allow creating directories
to support better access control to mshare'd regions defined in
msharefs.

Signed-off-by: Khalid Aziz <khalid@kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mshare.c | 116 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 115 insertions(+), 1 deletion(-)

diff --git a/mm/mshare.c b/mm/mshare.c
index d666471bc94b..c43b53a7323a 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -19,14 +19,128 @@
 
 const unsigned long mshare_align = P4D_SIZE;
 
+static const struct inode_operations msharefs_dir_inode_ops;
+static const struct inode_operations msharefs_file_inode_ops;
+
 static const struct file_operations msharefs_file_operations = {
 	.open			= simple_open,
 };
 
+static struct inode
+*msharefs_get_inode(struct mnt_idmap *idmap, struct super_block *sb,
+			const struct inode *dir, umode_t mode)
+{
+	struct inode *inode = new_inode(sb);
+
+	if (!inode)
+		return ERR_PTR(-ENOMEM);
+
+	inode->i_ino = get_next_ino();
+	inode_init_owner(&nop_mnt_idmap, inode, dir, mode);
+	simple_inode_init_ts(inode);
+
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_op = &msharefs_file_inode_ops;
+		inode->i_fop = &msharefs_file_operations;
+		break;
+	case S_IFDIR:
+		inode->i_op = &msharefs_dir_inode_ops;
+		inode->i_fop = &simple_dir_operations;
+		inc_nlink(inode);
+		break;
+	default:
+		iput(inode);
+		return ERR_PTR(-EINVAL);
+	}
+
+	return inode;
+}
+
+static int
+msharefs_mknod(struct mnt_idmap *idmap, struct inode *dir,
+		struct dentry *dentry, umode_t mode)
+{
+	struct inode *inode;
+
+	inode = msharefs_get_inode(idmap, dir->i_sb, dir, mode);
+	if (IS_ERR(inode))
+		return PTR_ERR(inode);
+
+	d_instantiate(dentry, inode);
+	dget(dentry);
+	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
+
+	return 0;
+}
+
+static int
+msharefs_create(struct mnt_idmap *idmap, struct inode *dir,
+		struct dentry *dentry, umode_t mode, bool excl)
+{
+	return msharefs_mknod(idmap, dir, dentry, mode | S_IFREG);
+}
+
+static struct dentry *
+msharefs_mkdir(struct mnt_idmap *idmap, struct inode *dir,
+		struct dentry *dentry, umode_t mode)
+{
+	int ret = msharefs_mknod(idmap, dir, dentry, mode | S_IFDIR);
+
+	if (!ret)
+		inc_nlink(dir);
+	return ERR_PTR(ret);
+}
+
 struct msharefs_info {
 	struct dentry *info_dentry;
 };
 
+static inline bool
+is_msharefs_info_file(const struct dentry *dentry)
+{
+	struct msharefs_info *info = dentry->d_sb->s_fs_info;
+
+	return info->info_dentry == dentry;
+}
+
+static int
+msharefs_rename(struct mnt_idmap *idmap,
+		struct inode *old_dir, struct dentry *old_dentry,
+		struct inode *new_dir, struct dentry *new_dentry,
+		unsigned int flags)
+{
+	if (is_msharefs_info_file(old_dentry) ||
+	    is_msharefs_info_file(new_dentry))
+		return -EPERM;
+
+	return simple_rename(idmap, old_dir, old_dentry, new_dir,
+			     new_dentry, flags);
+}
+
+static int
+msharefs_unlink(struct inode *dir, struct dentry *dentry)
+{
+	if (is_msharefs_info_file(dentry))
+		return -EPERM;
+
+	return simple_unlink(dir, dentry);
+}
+
+static const struct inode_operations msharefs_file_inode_ops = {
+	.setattr	= simple_setattr,
+};
+
+static const struct inode_operations msharefs_dir_inode_ops = {
+	.create		= msharefs_create,
+	.lookup		= simple_lookup,
+	.link		= simple_link,
+	.unlink		= msharefs_unlink,
+	.mkdir		= msharefs_mkdir,
+	.rmdir		= simple_rmdir,
+	.rename		= msharefs_rename,
+};
+
 static ssize_t
 mshare_info_read(struct file *file, char __user *buf, size_t nbytes,
 		loff_t *ppos)
@@ -106,7 +220,7 @@ msharefs_fill_super(struct super_block *sb, struct fs_context *fc)
 	inode->i_ino = 1;
 	inode->i_mode = S_IFDIR | 0777;
 	simple_inode_init_ts(inode);
-	inode->i_op = &simple_dir_inode_operations;
+	inode->i_op = &msharefs_dir_inode_ops;
 	inode->i_fop = &simple_dir_operations;
 	set_nlink(inode, 2);
 
-- 
2.47.1


