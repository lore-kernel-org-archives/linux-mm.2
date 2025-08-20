Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12F99CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96CCC6B00C5; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91BF36B00C7; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4676B00C8; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5CF0B6B00C5
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C5481602C2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:28 +0000 (UTC)
X-FDA: 83795342736.30.CAAAF7C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1DC8940006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sgpRAyWw;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9L4mKjeGA5OyWK8/K1NWQvE53M9E3W4TNz8fycuQ5CQ=;
	b=Q4K8I230mTTW8I3TFnzR/E5Wk31Naxzk+pmWnXcklT0LwwlMWPZqu/ENuhDx+LUe/vLMEP
	EiKAh74ofsJCZXKFREDWWjkse57GOijXRlyOctAw81WphWOoE86YDLV0GZaVGkk/Ab+i2w
	cJEU2bLhAcZ/fqAAUaiTk3nEeAIVyV8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651926; a=rsa-sha256;
	cv=none;
	b=hTrcwQLS/TaLDYRkHhf6chmcLH5mTu3ZBWT5Xt2fQcW0QXA325Lkx4ATXcN3rjsYpe0IXB
	77YFFRRaguc5nT40b7piYnuYMBIBUOePYp0RvVpWL++tXDM81yRau7H+/tqBiJLkVKkK7m
	b6H25sisGcsrHlJEAD3MohXiO8YV8Eo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sgpRAyWw;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCHQM028221;
	Wed, 20 Aug 2025 01:04:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=9L4mK
	jeGA5OyWK8/K1NWQvE53M9E3W4TNz8fycuQ5CQ=; b=sgpRAyWwR+4TxZS77Pv5L
	tgfjsj36FrQShtOvaWE1EKMDedetv9gjtQb2i/mDPxzLObU9kSms/jiMJPoHxgyc
	/gj6FAco0ZyI8fwy+IlkiFbctnFoEXApIwVg38Y6P7DBLLLkNpH8LkOq2bsS8ARJ
	IMMkNpLqo/ZKVsQmoDRu37awClhkyxdLpqznfi8WePpokF7EMaNfdqs8HcWGQfsZ
	NjBHTmb6YEhhdgTdsHgBj1btzELw5YvMemlqmBAnguxDeOkRT09yUwKlGTR2a7zD
	g40KsVeOUhbo84S4FRxPjZ48XJbOY5mR+fs1UmNHZJEI4afelYI5AviWgvMQgJvG
	g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tt08bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNWIUI007267;
	Wed, 20 Aug 2025 01:04:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:46 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdK011685;
	Wed, 20 Aug 2025 01:04:45 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-9;
	Wed, 20 Aug 2025 01:04:45 +0000
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
Subject: [PATCH v3 08/22] mm/mshare: flush all TLBs when updating PTEs in an mshare range
Date: Tue, 19 Aug 2025 18:04:01 -0700
Message-ID: <20250820010415.699353-9-anthony.yznaga@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=YvRWh4YX c=1 sm=1 tr=0 ts=68a51f2f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=0InV0jWQfKTt0iU26UwA:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Proofpoint-GUID: tBA8mk8grAxjezx5ksHcHYHuEzgvJI8t
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NiBTYWx0ZWRfXzCjnlAcKDkxl
 M/W3GCTi3Cck0tQGb9R4qooCLskGa3VkpOpP1pf05OmPWvaJ4/I3KFOr2i+jRYpiUjl9h2+I7Zm
 r+MHQ41Jz7B3jRarYNRwg1IS1+nXFLIinc7PIhYtdbe8cvHEXjrMrbNdaHNXdHc31hYsW0MVJJP
 aYitiektuIMWnkwGeXWhA2XJYGQ1OW47P3nMNmgGH+93OqRxBzEZEMjKx6Z17oOiLCRSX891ssA
 fVkubZUw/W3QdfS064dz2uCg5T34F/+oC4JjhtEKFsd3pklDXl3GTfV79URq/kRGVpfpQgl/A8R
 Vxv7SsSsXg7ynDPsmQ3t9pHRH5fI+tcrfSK0jLh3Un6YRPiyhs1vrU/5En5Q2lE1bqoPSqWlv+8
 Oa6w1RHw3jA0PIujvZ5D7VWqENudvw==
X-Proofpoint-ORIG-GUID: tBA8mk8grAxjezx5ksHcHYHuEzgvJI8t
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DC8940006
X-Stat-Signature: gkmzj6f4ekfjwaiddbezza7ubyytaysg
X-Rspam-User: 
X-HE-Tag: 1755651925-106418
X-HE-Meta: U2FsdGVkX192ErGW3REZhTj18ZOoiWYQBZzv3xNT1CYnfWrugWPE/to0zKgJK9B5R0ISxNSAG1+Qkb/pFLCc4M5FaVAEQpfs9qOb1Vb4SA6jb6KHg3YmvhPyl6QL0DHWsb7qLOqUIBVLsTA4fNZOEKO+LQoGz2fGEt82Oc9jkjV0rQMKlmlV73Y46bDnswRIGMWw4Qq8ArM/K1a5koe7de3g8eQnzAX3oMPE/4VcaNmQhUwzEmR09UkgT18kYYwxB3qzfcrfe5U+W0E6YuplXSMc93fEWWY/A+jV2vM3IvkKU1vIuLQLuCCx4ZNPef+0lY2M4W7A0LoXL4LXepQJQymX31V08BFhZhZ6Mad1mt+vuzv5+TZwKv3ItvC0yS51APyuzTcee24ppLMFXp14OUz3YuZPBoesejgFd5n/dSTkXG3HL5jmrJfIJFVXU80i+ApyLme0iZVA5WF0PTfjsl8KsPKW6coW+Ci5xa6rr9S40FddTZam10T19ETQOn61JN2J7cHo+mzmaWVHgn6dy9avY65cnQ6iB7HUkRAKzPE5hHOTL0ObR/ou71Qm1ece3UDKpeTptOI4PaGYNCMNGXZmEOn3vxqCkX2Yl7J+44DN5ZhldVpokG4vW/Ghyu6iQK6ZQyejuJ/4tvF1jNs9PO0+6Lze9S8YdhymRss0BFZrpD0xUBU05DLBrj63g2A3DZai281HJgwWle+GswezOMZW1QkJC9oG6Df3n8keeerId6REitW0lQyv0npCUwGqc9nAaQORpFR6/Yd1yQv6Rruu3ObQB1aw5+tOd2ja5q1Jvh8VZyZrXU7f71Z8c3cluTlv90Kyy76PpOfQjY0s+69HfvuPDGeOUauDJjBguI8RK4wttA4EgHenBxHKS9HGmPTrBX65YLObaJ4+iBjNFZYDcwzoznIGupe8DRmlM1ZPe6+xuwwJsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unlike the mm of a task, an mshare host mm is not updated on context
switch. In particular this means that mm_cpumask is never updated
which results in TLB flushes for updates to mshare PTEs only being
done on the local CPU. To ensure entries are flushed for non-local
TLBs, set up an mmu notifier on the mshare mm and use the
.arch_invalidate_secondary_tlbs callback to flush all TLBs.
arch_invalidate_secondary_tlbs guarantees that TLB entries will be
flushed before pages are freed when unmapping pages in an mshare region.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/mshare.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/mm/mshare.c b/mm/mshare.c
index e0dc42602f7f..be7cae739225 100644
--- a/mm/mshare.c
+++ b/mm/mshare.c
@@ -16,8 +16,10 @@
 #include <linux/fs.h>
 #include <linux/fs_context.h>
 #include <linux/mman.h>
+#include <linux/mmu_notifier.h>
 #include <uapi/linux/magic.h>
 #include <linux/falloc.h>
+#include <asm/tlbflush.h>
 
 const unsigned long mshare_align = P4D_SIZE;
 const unsigned long mshare_base = mshare_align;
@@ -30,6 +32,7 @@ struct mshare_data {
 	unsigned long start;
 	unsigned long size;
 	unsigned long flags;
+	struct mmu_notifier mn;
 };
 
 static inline bool mshare_is_initialized(struct mshare_data *m_data)
@@ -37,6 +40,16 @@ static inline bool mshare_is_initialized(struct mshare_data *m_data)
 	return test_bit(MSHARE_INITIALIZED, &m_data->flags);
 }
 
+static void mshare_invalidate_tlbs(struct mmu_notifier *mn, struct mm_struct *mm,
+				   unsigned long start, unsigned long end)
+{
+	flush_tlb_all();
+}
+
+static const struct mmu_notifier_ops mshare_mmu_ops = {
+	.arch_invalidate_secondary_tlbs = mshare_invalidate_tlbs,
+};
+
 static int mshare_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
 {
 	return -EINVAL;
@@ -238,6 +251,10 @@ msharefs_fill_mm(struct inode *inode)
 		goto err_free;
 	m_data->mm = mm;
 	m_data->start = mshare_base;
+	m_data->mn.ops = &mshare_mmu_ops;
+	ret = mmu_notifier_register(&m_data->mn, mm);
+	if (ret)
+		goto err_free;
 
 	refcount_set(&m_data->ref, 1);
 	inode->i_private = m_data;
-- 
2.47.1


