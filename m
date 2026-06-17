Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1010CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E936B008C; Wed, 17 Jun 2026 13:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC6F26B0092; Wed, 17 Jun 2026 13:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91B0A6B0093; Wed, 17 Jun 2026 13:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60BED6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DA3081A046F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:06 +0000 (UTC)
X-FDA: 84890082732.27.6992508
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id C136AA0011
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VHosvTS6;
	spf=pass (imf15.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcF/ezXviocg3GvZpVWOTn7qX+/93xFFR8ZW0AUPUAg=;
	b=ewKsnIoCrwu86lrPax6xFoS2Bo9J34i+kTCEY/1KIK3GS/Q40VjJ83MgTr+804C9lR7dfX
	HpK4d0Kvwodavw+NzDLV+eZfErXT8kK9UH+mDxTxWbwjV5E8npVrlJ7/IH7QSitDfZAGw0
	PFpAau7B73KQ8xDb4Xi/aw+2k8C2Tc4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717164;
	b=z9D1Fwl1Dfs7Q9FWIPYTR3rA1vCABrmrjd5Cbhvq1XwPruX179XoeP93qRmIz4Fcz0Wqm6
	4TlbLP+PbMfpbtDzYDdBUjn2bR9Bae3x//oXocCq68vg6hMO0neaS4jE0H/ZsJwnmkcjOi
	w0UtthTwlvcQEUGIQwhahB0Gi8+vDXQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VHosvTS6;
	spf=pass (imf15.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HErIfs2404431;
	Wed, 17 Jun 2026 17:25:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=rcF/e
	zXviocg3GvZpVWOTn7qX+/93xFFR8ZW0AUPUAg=; b=VHosvTS6OkRCGBpqjw5AX
	LWPtu1MG3LVfQWNq19xf80DwNKnVAPdH16J2YdI68WQWxVMOGLMzuFbTZ/uwBlKA
	3FmQCzktSSRorMatBLfzZBuNADyQ985mpvEZ5HxGWAwJjYFEjFncApzMD/p7Cal6
	IKxi5/UbQga3gWYFCHN0vf/fyPof4bQ1I6IBOuYy3822RDk2dLT9zyi0+0wepp8Y
	gTfnqCHuJ4JsIRs0VAQyuIMfuOTpfwWkE/tUHpmOkuMCRichFYPG/jkReR35P5x0
	SV8BRSUyNTwmw+7Ds/G7Of+JljfrJdh38ddqCPm9rTrslFJ314QyfUFNvwahpaEj
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4euegd1cf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:25:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVOk003778;
	Wed, 17 Jun 2026 17:25:52 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-3;
	Wed, 17 Jun 2026 17:25:52 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 02/11] mm: factor out adjust_range_hwpoison() from hugetlbfs
Date: Wed, 17 Jun 2026 11:25:23 -0600
Message-ID: <20260617172534.1740152-3-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260617172534.1740152-1-jane.chu@oracle.com>
References: <20260617172534.1740152-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_02,2026-06-17_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 phishscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 lowpriorityscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606150000 definitions=main-2606170167
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfXx9/OCgXsRqDr
 2rEgKHXGec3T7N/G1vEpVJwAJjMfciadtAydtrL17ZfXMpoZQtPzu11/CQFUrVbyl7/c1wkICxG
 4aujPmD3We6K4LQQQ4i4pn8hQQuh9EBrWnuhpmtb1gftCCAe01YNj/pyvDdTKupL+cJ30pVUkwc
 dIvjXVVo9lVnu+baOnxwo5IcEu4y69jTAU7l6pSzLkmXHiBbU6dWW7z5euB4Rcw+zLNm0Xl8lIp
 vFwDh1v1jtO1FpwxiusWzia6fMvdXe3kVnyMBqEga9grVNgsf+jAcRKsTAwNEZEnNgTGKuWCTQT
 G8/uhdeaXmXPeHKre1b2aLw2DngOxjTMuaLzZYjj7uik557hv3IY7qnLcknWzQoXV1k88O53mo6
 kkl4wEPFmlUczh+rJ0mG0pwlfK7dlX+NtZGU3qGAHqldZ31dk55KygWaOwyHiWNNu2uiR0UGHD/
 16lEzo30FS0SrMP76OZkLD9vYCkyxw9tfcm5s7uM=
X-Proofpoint-GUID: RzfqjCgGdYn49Rhq-lRBmyrWXAaJ0bLh
X-Proofpoint-ORIG-GUID: RzfqjCgGdYn49Rhq-lRBmyrWXAaJ0bLh
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfX19grh2QRVWpX
 g1VTkw6fIHxiNtw6/sbOgcdMqi3/jPHhyeNi9cEk3MUH71HJf/wM5DPRMj1BYo2wHLZ8jSr0wC3
 3bQJ+gesNkfpbbAjbPyZBnlx3mUSVs6buhd2MuRpCnzDTrHXirha
X-Authority-Analysis: v=2.4 cv=GbMnWwXL c=1 sm=1 tr=0 ts=6a32d8a1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=ugIqsUL2P1XQeEjC6sYA:9 a=1CNFftbPRP8L7MoqJWF3:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C136AA0011
X-Stat-Signature: ef919hie3rmkcx7my5hepckid4uurzar
X-HE-Tag: 1781717164-622179
X-HE-Meta: U2FsdGVkX1+ITugejmNgnM/apY/RqLb9FpakJynXmuuSRKkXJGKsnUkgouqyjpYxRan26cyr5E7Vg8Q6/PYKWIJuTnBdr2HBVpdgQbqihHzyMkb4U/dt69kgz1bZmTo7QGqzc8JQzK8QeEUgh/iOWLnIK+nnxosljx+2Xzb1WVW3vArWuUsb/DRpEm7e8BhmB+uPr+5uV7rm4LL6cqsLVg+cfT5XnUzlmi6Av6N9OT/WiZQAkL0CkA5FPStnrUGI2gZpGCM2hV9zYYHtcdyy+7//JyV7VVxxpfdvWb4LX7Myql6AGQ9Y+KtLrieJ4K68H7B1H6SFyjAhVmNeBW9Q65wwYTxYM8FxiKKSIvG5qXxFaC27O6IF8V6FU9Gyn/XmxJiACecaZoK7odsL7WrFgkpkSNUmjDRK2yZHFWPwzzS68BdT0Dy1SLG769nZh/P4JuJOG+um9cfI6OpSjTA+O1H9muvW2wTMbRceKj0roz1FPrO5g+kkCY+NMv4J94Z1wnJtzXx2eHNe9V9fTOTX8ISNc3QNYHq1pRvnPIKYQ9hDSPY094XoLf9jmn5a77HdtwG6pVOOVN05fPDe27hCBJyJjpQQ5aZ3R1TGCO0TZ0zKSzwetZ7Jz1kfcgPeUUHlJ3wCPAaK5CdLzRRczJ2YMoaK7EHyeScGrFC0XBmHD0YeNdHlljh0MJmm5/id+HSdUI2W1gAtazEL9Zk/mL8RuH3ef3C1kAad78Yc3E385z2UBwI2mAED3IE1i4MzaPFr/9Z9RYAFQ7x+23KYHXfNsCZroO2OkEHySYtXZtAqFMpi7jtrxS1RRhyxp1BUd3XM1eZvLZZtdNZ27OuDjQkGnshNGQ388hXBVtMd9n8TfjWybZs8Q3WEaLD0Ecgt8Ov724XOWIQXL1aWufOCZknVap72fzfc+3zJYeGaSrJ6fHt/9rW0zrQqHZfhh6eFqbqMnGQx5KWrPKbqbtQQVBu
 1iQBia+t
 YtOtrr8eskRPh6nWzbw3sKEPYblNAW4EVVgQ8KxD8iqz9/nUo4S2a34SRp6zVB9Wt4KxIdAeYV3Q00Jupjcc1/gkFaS0LadYagvhiXWXk4gx2ZPD6WD/zC6RzS66/eluYL4eCW4Ak0dUewcsmmItVT8lm+nPr3YuJLaI5GxXtr0Yip6UmjmT+Pdu2ZyKcyfLjnHxmvfogR3xFcezw+TjTJ7NY/Dz2A1fGsvyjPUabym0BIUchBwLYTubFT5bFC6lGda/H0Bw2XMjZm8N3HHK3beCiH7QuIl5g3VZ3Dj/zhawXAAKwy1Qq291fXhd1BNj5mG8M/qZD0V9EJ3/tRIoW3LVwrGN94HKh2tGVmCaiRLyadBTGaA6FBKzjJeLZv9L4sp+PRyKXWuVd/fTNB82ac+/T8mxnK3kpoawcTp6gZ3qm9nnrMya3TZK2LEQqRbGm4iK8aV/xMQV/k+BPpm13NSnoNsC0v0MZey00
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The functionality and implementation of adjust_range_hwpoison() is
generic, so factor it out and make it ready for generic use.

[1] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 fs/hugetlbfs/inode.c    | 25 -------------------------
 include/linux/fs.h      |  2 ++
 include/linux/hugetlb.h |  5 -----
 mm/filemap.c            | 31 +++++++++++++++++++++++++++++++
 4 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 66520f7c53c6..f1f8c3f7388f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -187,31 +187,6 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
 	return mm_get_unmapped_area_vmflags(file, addr0, len, pgoff, flags, 0);
 }
 
-/*
- * Someone wants to read @bytes from a HWPOISON hugetlb @folio from @offset.
- * Returns the maximum number of bytes one can read without touching the 1st raw
- * HWPOISON page.
- */
-static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
-		size_t bytes)
-{
-	struct page *page = folio_page(folio, offset / PAGE_SIZE);
-	size_t safe_bytes;
-
-	if (is_raw_hwpoison_page_in_folio(page))
-		return 0;
-	/* Safe to read the remaining bytes in this page. */
-	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
-	page++;
-
-	/* Check each remaining page as long as we are not done yet. */
-	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
-		if (is_raw_hwpoison_page_in_folio(page))
-			break;
-
-	return min(safe_bytes, bytes);
-}
-
 /*
  * Support for read() - Find the page attached to f_mapping and copy out the
  * data. This provides functionality similar to filemap_read().
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfb..3876d5beda58 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3052,6 +3052,8 @@ int generic_write_checks_count(struct kiocb *iocb, loff_t *count);
 extern int generic_write_check_limits(struct file *file, loff_t pos,
 		loff_t *count);
 extern int generic_file_rw_checks(struct file *file_in, struct file *file_out);
+bool is_raw_hwpoison_page_in_folio(struct page *page);
+size_t adjust_range_hwpoison(struct folio *folio, size_t offset, size_t bytes);
 ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *to,
 		ssize_t already_read);
 extern ssize_t generic_file_read_iter(struct kiocb *, struct iov_iter *);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a9846f043712..218284e80451 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1078,11 +1078,6 @@ void hugetlb_register_node(struct node *node);
 void hugetlb_unregister_node(struct node *node);
 #endif
 
-/*
- * Check if a given raw @page is HWPOISON in a folio of any kind
- */
-bool is_raw_hwpoison_page_in_folio(struct page *page);
-
 static inline unsigned long huge_page_mask_align(struct file *file)
 {
 	return PAGE_MASK & ~huge_page_mask(hstate_file(file));
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..a27ce4ad6247 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2753,6 +2753,37 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 	}
 }
 
+/**
+ * adjust_range_hwpoison - adjust clean readable range to avoid hwpoison.
+ * @folio: folio that contains hwpoison(s).
+ * @offset: bytes into the folio where subsequent read starts.
+ * @bytes: number of bytes wish to read.
+ *
+ * Return: adjusted total number of bytes starting off @offset that can be
+ * safely read from the @folio.
+ */
+size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
+		size_t bytes)
+{
+	struct page *page = folio_page(folio, offset / PAGE_SIZE);
+	size_t safe_bytes;
+
+	if (is_raw_hwpoison_page_in_folio(page))
+		return 0;
+
+	/* Safe to read the remaining bytes in this page. */
+	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
+	page++;
+
+	/* Check each remaining page as long as we are not done yet. */
+	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
+		if (is_raw_hwpoison_page_in_folio(page))
+			break;
+
+	return min(safe_bytes, bytes);
+}
+EXPORT_SYMBOL_GPL(adjust_range_hwpoison);
+
 /**
  * filemap_read - Read data from the page cache.
  * @iocb: The iocb to read.
-- 
2.43.5


