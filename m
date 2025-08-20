Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A27AACA0EE6
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B2A8E000D; Tue, 19 Aug 2025 21:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB558E0001; Tue, 19 Aug 2025 21:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C9F08E000D; Tue, 19 Aug 2025 21:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0866C8E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:46 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5BA8138022
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:45 +0000 (UTC)
X-FDA: 83795343450.01.A17F5BD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id AACB14000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T60BrX8Q;
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=infP1lJZ7Ka8IX5+GWUINM3qKZZWXr34+Aqn/QJlI4Q=;
	b=NDr8NMyPZ5KtFA93jMK07B0fAPfGbXfk5RehZswatPz53hyk8hGZBbYXMphkKTpj3cPoTL
	h8waa2JCvra+KYQ4xjSb7vMV95j8Z+1M9DKxmWGWE71c54epauSYiPBVLW1426MY/MyD/3
	OYpOuqkFHQ/Mm1zYAx6P/lIp51vvMxk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651943; a=rsa-sha256;
	cv=none;
	b=3nxYOWlmzg2CK6sj2obS9/f93sxQeyDYy+jAkF08yF0T2T/xDHY2EihI/u3XN8Fnc+FOSB
	lWc2S/TWWjSccrK8LrS0hUJfl3w2VkMHRcRmn/MyZbKR8Sw3i6TlzHDIqRAs6JFPIBb6q9
	vkoTznyjob/jAA0aCODnVpIT0XoummU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=T60BrX8Q;
	spf=pass (imf17.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBnpF005373;
	Wed, 20 Aug 2025 01:05:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=infP1
	lJZ7Ka8IX5+GWUINM3qKZZWXr34+Aqn/QJlI4Q=; b=T60BrX8QOrU3Uf13MxnNg
	ONRGEb9jRBgXTNgFlp27/vPFA3Dft51qeT+l6NwTHT0YitxzvIwigPTTQrRLf3Xk
	94CK5Yvtx2hCcpmJlO+v2VqpY1g6bgJhkueU624LEwsmf0VaZk0vPO+Y2fjhaIoR
	R/Ev7R1vhM9XmTq5PeDG7zbFm4toh5mneAmIg0dPn4VeNcN+xhwK8/m/BzFRe56v
	vh81AHOU3f45rYG8+bs2NSULQlnzhEX4NeGXTJkN8hxlpQABkFvi3DpvPmgtonk3
	YcOSJoJhkw1ZBuUT0ZSXfD0Ahq26CLLtDrNkndXrcgw59eiiqCe7/EO0D/PAeOmO
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tsr858-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNPt9O007235;
	Wed, 20 Aug 2025 01:05:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2aba-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:20 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Ndk011685;
	Wed, 20 Aug 2025 01:05:19 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-22;
	Wed, 20 Aug 2025 01:05:19 +0000
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
Subject: [PATCH v3 21/22] mm/mshare: provide a way to identify an mm as an mshare host mm
Date: Tue, 19 Aug 2025 18:04:14 -0700
Message-ID: <20250820010415.699353-22-anthony.yznaga@oracle.com>
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
X-Proofpoint-GUID: z9by1qV16PLcYdBxBbw-tvoWMv6AlGCh
X-Authority-Analysis: v=2.4 cv=S6eAAIsP c=1 sm=1 tr=0 ts=68a51f52 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=mFgWS2ekddffsZ1b:21 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8
 a=VYm1j9aar4kuMGX0MzQA:9 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-ORIG-GUID: z9by1qV16PLcYdBxBbw-tvoWMv6AlGCh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX2xGjmgVR1QC5
 CZxdsBOHh4VIMmGeNE7QLyPjvtpWcFHeWyInZ0UEuuhQnz7P8txovb5Y99DBRMzfiJ0RDJlQeYW
 l4jo3Ytu6EwXuM8t67BbQdUmDe4h5MKDLFMIrafpTX84pFg6eRwgkQeI50hmp1Ynv0bpGJzaDhJ
 AKJYann+OnPJTpyvrCvWS2RhvBMbJD31ka/eFH0Gh4ilzT33PBJCKHNtUw0t0pdTImPtWzNG2Bv
 f635KwsF4kOxiSZwieU1/YLmiNkucPbbRWYueRGhcNedL1a77dY+n0keJUxAlU7PWDVscTaQ9xG
 reT/oj9b0hLszWvN8I/RzrHZTwWuwJOrvZY6ZS07V4fAGxt+UPi/pSsyjG0WPB2+5v9CdD5OLpX
 G+iDse/42ToobEW6TQ1/7NAtBx5zcg==
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AACB14000B
X-Stat-Signature: qbtqdxj6z46am96uii1fwx83m47f17ua
X-Rspam-User: 
X-HE-Tag: 1755651943-991885
X-HE-Meta: U2FsdGVkX1/XmzJRWZX0BWoab/5RXv8yf+cONOa5Xn3SmJeAfkXfOJ5QDMnIJhDE0n03SwWJo5iz2gx7YjptCuVir8JzKqExjokwR5XwPqeh5HxuX0zSDv0SClXwFdPNWBvrZaXc0tVTBpsitXNuioFsTlHhcGTW7bXHjz2QvbwW1kxvo3FHUl7jUNCmaQUpFQRdkkVBrerscfS3CJwKEbF7XizX4GINX6ipSVEKPy0NBskps5WuMgvugQ3JgR8AJi2jMZFMO1M+AZB9JLEik3ygwWDkbS2SCwpSiSo86jGJ2+dwskec3ZllCNm7hpqhH8Mt8OCZKGft7GOQ9zDTLZzksrA3k8AGt8TkGW9WB3zamfVs0M6XUDUJyC/4MR3o+HxhnMETuHLsSM4uj9UdfzH4H7yTZthTbS/2jNKknEhobLFh2OMJEoVyh5ybJiqcZnjigO693Ly/W48cnF3RlqsUQzX7BWzb9uZD3/4hbRwzgW9Q9kZlJrnEc+u4MISboYv4DD8KwnyGvG0oqzufHwA51P3d2h02iopM5ghye7aMom3fWAR0VoIKqWHXb2uGyFMS0AbyAwCHd2y7SlKsXQDzZlJ+6alo8Qc7Q+HLnLBvj3upbKATVkVx979MQoxA8tMdw0g8DCuck8WGfczc1lP090Md247Soakc6+t9Nk+YLoKVpVAIPWhU8GID3ki3AdKRDlpY2Bu2Jd9Rgq2pjN+H2QOw2OPsRgo/5Hgu0TVbdmHnsiLw9yrzzIL7A81oSc4AfM4LGqdZfAdkw/QbW9gmQnLpCBhxYu6xEtOWJgMM3MhUnNJg4mG5EokORNeaJtB79smbDlsg0H4T0Vp7tkR8uQpY2zjJt3n+Bq7EQqYKqDBb+x7dARHK1x2AlhcCEzDrJAk/5p/7KwErtWD1kRrEKAXGn+PZpNbPl+pPMNS8OiYq4F1K4Kl74YomqpgwTALftpJv/kODpfhs0p4
 iWjv8nOU
 gFWiIsOvJkM9koU/iH4CcsczoFtblVx3c+GB3+KsL3WO0uXJcVhx4ReEB8sl8Q++ig3LP3VBZux+vtD4ogmvx+BmqxHaDPi7WYhLXyF8TKrQ3buFcfY9xrzFfkrcR/3cODubW1NnqLJK7NZAfY3cdnnRlImEQb8y6I9nIgYbfbe07kklnHH+7srk3zySTdqUAaz1nWfxBZBP4xk85vqo2KsHIQzQ3y0saJFQawCDBkq1Ch3V/XpT/1kcWNa44OAOPyp94nhvz1GO2HwQwSExbC7pUDseMmxXC4gCZv7/NdmAD460=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new mm flag, MMF_MSHARE.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mm_types.h | 2 ++
 mm/mshare.c              | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index da5a7a31a81d..4586a3f384f1 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1847,6 +1847,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	_BITUL(MMF_TOPDOWN)
 
+#define MMF_MSHARE		32	/* mm is an mshare host mm */
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/mm/mshare.c b/mm/mshare.c
index ddcf7bb2e956..22e2aedb74d3 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -578,6 +578,7 @@ msharefs_fill_mm(struct inode *inode)
 	if (!mm)
 		return -ENOMEM;
 
+	mm_flags_set(MMF_MSHARE, mm);
 	mm->mmap_base = mshare_base;
 	mm->task_size = 0;
 
-- 
2.47.1


