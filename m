Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52ECCCD98F3
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48EBA6B0093; Wed, 17 Jun 2026 13:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45EC86B0095; Wed, 17 Jun 2026 13:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3306B0096; Wed, 17 Jun 2026 13:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC16B0093
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58E6214047A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:13 +0000 (UTC)
X-FDA: 84890083026.12.F1B9A4D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4872916000B
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YqakzRFV;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=keeu02Fp3GttgS1mWUJNl7//OWMwchcp1IbJBKzOEDk=;
	b=PujzRon0pyCt5WHVCwriTLtEpMO5O9pUY5voKWyml8TpHOL0mVCKQz8F9x+t1Mw8i7sYRi
	n0OHF8Ugw/7qMYD2uU0L9S/aL4G1S98NGkBW5TPrW134xb2v0+bAB8wjigHl+d4cxctZRD
	QYcGo0Ufcmiunp/Kbbxr73FMo2nEVzU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YqakzRFV;
	spf=pass (imf08.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717171;
	b=EKO6l2EBHhdzpRJpZB48gegEt10lgL/gf4HsJESmO0cvR2t+sRmfWmgZkj6noEtk6dFWRp
	qO2mTzfHjsSE9lj8MprY8GkakX+eTmNjj0VDUBx87/lqwCIQ/29bgkzpFDR+kq+c8RVT7I
	iO/0yWiJf+Qt+oig9Lj3JYlghvIsBm4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsSup2367932;
	Wed, 17 Jun 2026 17:25:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=keeu0
	2Fp3GttgS1mWUJNl7//OWMwchcp1IbJBKzOEDk=; b=YqakzRFVl8+Hqy9z3KX66
	gGrectHUpL9WKupasXX6xSI0yA0t1GsTtmPMGM/vvo8b/2O9zQaaXyeHWByR19HB
	p4neJyQKgVeeDVBX+pbZbzLiEdRzZ8MYp49sxZQ6gjIZj6mb3rZor85isatIQyID
	OWvqE55QF9hyYlzwXaR+sbVWAIbo114XF2DesNfCFzbeQms61KuQa/vbSP/dfePC
	k3+E/+uT3fn25y/AWxQPdMqzTNBEkpam4lEbbwMfRMESi2oR/wElDGHi1cbqV4MV
	3aAUVfRZrBrRjFBH+DuoPg3j+kJF5eFijV7gJOHkIaDp1Zc4y5z2UCOqpTfdqwIB
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg31c3c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:25:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVOl003778;
	Wed, 17 Jun 2026 17:25:55 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-4;
	Wed, 17 Jun 2026 17:25:55 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 03/11] mm/filemap: add hwpoison handling to filemap_read()
Date: Wed, 17 Jun 2026 11:25:24 -0600
Message-ID: <20260617172534.1740152-4-jane.chu@oracle.com>
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
X-Authority-Analysis: v=2.4 cv=I8VVgtgg c=1 sm=1 tr=0 ts=6a32d8a5 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8
 a=bp1g5Iz1D7c7guLF1_8A:9 a=1CNFftbPRP8L7MoqJWF3:22 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Proofpoint-GUID: uXOmksX9GDaWEUnKmgnfQCd2euQz12WU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfX/uWkgVnRjjGc
 g8+RpAexXA/6ZOUXFvcWdHpQkC7xnjpnUL8yPkIKC/psTN9sHbwd4x9MQ97vE5iFn8Rbf3t8re+
 /aTL+hEgxZELnXIm86PxVnPKjtVhzuEHYzcf/w0/MvIf10zOP9w3CC0kp6XlnKz+AteQqJc911W
 lDUeBAGt7QdAmqFazSo/eZyh/u2HQhiBoZEEwiI4BJWadnlhc4qRQWaYvCYS8mjuZ2Iw1qEY9mo
 YOGc1p5LCICRpTj5OiS7TYvU+zMFsl7DiDXlto2Y7bsfk7NzMCz1NA56H0uSVdXh9EOc6CL1U9v
 o/N/CyaeBXJmDxUCZZG58Mh6Ez+Yp4jO23M/svIpmxVvmbg7fbipiGtDM3O4NVDojrTTEyn1qr7
 tXdu4kwmIuMwI3rGHpFBfYQRpgEYmo03omHCfVM6Bn+aGBDoGvaQ7XOsk0qdmr1X4O1nrGV9/Wf
 HGnSWGuu5tGI4c555ATGseKqliiQYJvcNmDrn2b0=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2NyBTYWx0ZWRfX1UonwiatnJwS
 WGpV8rDkik3ahZ4RxT4LexW0LHpobXFhxG85ArzXg06f0Ld+FhV3uMhhDuhV43aPyzca3FQXbtJ
 XZiKJyRnDy3ubWK1b6Fla7X7GLdpc3M1fblQ9al1xQcEz07LDIBn
X-Proofpoint-ORIG-GUID: uXOmksX9GDaWEUnKmgnfQCd2euQz12WU
X-Rspamd-Queue-Id: 4872916000B
X-Stat-Signature: yomea6w6jwrrwk3tp4zki7gts99wuaxn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781717171-114830
X-HE-Meta: U2FsdGVkX183SFwh13iTgBXinxtkG3zr5qe2O0fzLzFl7p6VRO+sFnihZ+IKizGK9ahS2b6YoqNxPjAoq8wIXXN/mkz7x04c6IAQ5fM7AE+36EV32Iq6b0XgRh+uxtM8mVcYA+6ykQtMP3JOGtZmhmDrpyQJZzmlvayFgbI49bT4TlXTZ91KRIpuTQ60lUWrQpPcBFEdX0hTvzPHg/kM+alqBcqKXuCf98ISXu791u150mndBH37bXWOGDk4b4K19aUGIJeVjSp/5DksUPEgu9W3WxByaBRDNIT9BZq87K11H/iIFMUeZHS5MUPHlR78AP9fWN4yK2WZzPug58Q2ybiX9sNE3//jIWnvCFkIzs7TSCXqR6vMMOGuA9a2bVF2ZdY9y42LBRm/4PzqWxfiqeG9Bj8CE7A0l1iRt/wCu8l+bcFVKiDBjOR9KcgD80ZiprEawQMusHlJMguD2AO0Z6DqDqKGiWQ0BzvFXju+l/laPERPyQp46triZyBvBNQEqVZVeZgpJ+rzd49QRbUqj47+VxzvIguJ0jqtKWsDbj69ljShrKTAFltI8+abIoZogppMd1eKcq4N71XR2dzHWaZFhC1pLcSvS4t8Pp+aqv5nA68AJxZmOz8U/cVdyme/4DPpANszApiyOJgragrzEbuCNWwG9xvOXh6yfxJl2e9uk15NHC+fvuy/plAcmQI4EToSE0kihQCLLIID1eyL5wxA9jL+CHTGtUZsmzggpKLpe7Z9iGrXm0+E3I9mpm8xKkSYJgcL8WdLTQitiv7HF8JwAJXCH7WvJVqAbnUk/0tnb5l+Grov/RkyPgC9RD3ZiklPcDBOpHFMU7v+9tdbk2JkCvd0YyogoU0axt6rkfMM7JykMFiPRr6drH4J55QFnmkh0CjbgsefRxdG13yF87hyn2pcz+7suCo+FpKuf4TXZ+UStuPDtH2eejBrsMFkvaOogtaRAwS4005p562
 t/Pz0Ntr
 +bz3ETD2SZPi8CqmW5ZtX0kzgEJbl+JqC2SwgpEaegwEAxhYSsn6bFoq2GEvFD/uw4vdTsHSrMMyPeSWCe/Elu9BHJkv5XYTklZqeI4/69915hiinzbaJoo6ABUhahPa+T8XgG/+43gxV9URkOQnM0McImJU3AI3BsQqDWC0q6YtoxEJx667CGASUhWiLgrF+rYX6nZal0K1tYzY3VTrJANJveDWLYa7aPpq9Kg51dPUN6L6mwtFmYHDE+zTYpqAk1JH7Chjh6iSaDdh97GSQLAoGv/MbpS9QVOZi44Harm9BK22Kk2li017To3W1eOXeJ/j3KrE9WieKR/leuaG+lqYSvHHR/WKzbNOcW/yhs3QyHMxjUqR4p4JtItwse/AXeueIoU3Z23I8mOexjDcpXxSQAHJjUZLTRD1gfnHuBQu8LuUWRwWd2FmFqilS7PxCPR+AF1qzR6Nk2ocfa1Ua4ouezo23hQeXtUap
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add hwpoison handling to filemap_read() such that .read_iter() could
make best effort copying data out of clean pages without risking
MCE in case page cache contains HWpoison.

[1] https://lore.kernel.org/linux-mm/aeZwAz6PcdlqSnJ2@casper.infradead.org/

Suggested-by: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 mm/filemap.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index a27ce4ad6247..df8543573570 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2475,6 +2475,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
 
 		if (!folio_batch_add(fbatch, folio))
 			break;
+		if (folio_contain_hwpoisoned_page(folio))
+			break;
 		if (!folio_test_uptodate(folio))
 			break;
 		if (folio_test_readahead(folio))
@@ -2871,6 +2873,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			size_t offset = iocb->ki_pos & (fsize - 1);
 			size_t bytes = min_t(loff_t, end_offset - iocb->ki_pos,
 					     fsize - offset);
+			size_t adjusted;
 			size_t copied;
 
 			if (end_offset < folio_pos(folio))
@@ -2885,13 +2888,22 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 			if (writably_mapped)
 				flush_dcache_folio(folio);
 
-			copied = copy_folio_to_iter(folio, offset, bytes, iter);
+			adjusted = bytes;
+			if (folio_contain_hwpoisoned_page(folio)) {
+				adjusted = adjust_range_hwpoison(folio, offset, bytes);
+				if (adjusted == 0) {
+					error = -EIO;
+					break;
+				}
+			}
+
+			copied = copy_folio_to_iter(folio, offset, adjusted, iter);
 
 			already_read += copied;
 			iocb->ki_pos += copied;
 			last_pos = iocb->ki_pos;
 
-			if (copied < bytes) {
+			if (copied < adjusted) {
 				error = -EFAULT;
 				break;
 			}
-- 
2.43.5


