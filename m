Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C0CF433DD
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 03:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 584346B0005; Wed, 15 Apr 2026 23:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E66B6B0089; Wed, 15 Apr 2026 23:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AE576B008A; Wed, 15 Apr 2026 23:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23D466B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:39:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AB79E13AA2C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:51 +0000 (UTC)
X-FDA: 84663014982.01.85F21A6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92F994000A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:39:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WZAzhYZB;
	spf=pass (imf04.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776310789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkK/gpx2ErjKx3G2Uq6ljwesXsbQnQRoVjdIPtDsVIE=;
	b=tHOtw0Qv1RlM3LffMRK5TnqovVCEXJzcjq9mPbIKJ7st07qrcxa/YPhboz1uOMxKE2JaR7
	uYsiIqt0duVT1MQPGxLJ/d347KMKGU3lpBF+yTLJNQVG+ngUQ72S42nF6nFF6u6lTe4E/0
	3qvchygzWn/2/KxUjnBkWz/KlM3YyNI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=WZAzhYZB;
	spf=pass (imf04.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776310789; a=rsa-sha256;
	cv=none;
	b=iSxRjYX7TQjYbfV5VZBAwmm0FiSaF/Tqk9TKFqgzde8lKlLj6sefo/5DERP5FopZaZZqjf
	p+QAGNX8ja0vqI3Ab0wRrbUuiA+CY6CSJYw/5uVsaOObuofDIEkhqvqqC8upycx5QNZu8l
	nXGPm2m2xNfnuUx1DoOiKaCNG1uJg6o=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FJMNkf4004959;
	Thu, 16 Apr 2026 03:39:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=pkK/g
	px2ErjKx3G2Uq6ljwesXsbQnQRoVjdIPtDsVIE=; b=WZAzhYZBfpYwKkbsIUCkg
	whxSOEUnkW5X7Srp4Dh2IbEyYW6RWS8CBllJnWPrQqYtnPQECdApZPCZ7PPNAODZ
	evIOr124PGjil4nZIz8ZBnG5RoG2fFsWx3gn43edq+14NueIU8ItJdJ8XvpcID/c
	JNPpFq8RnQhOp7Zz1akjX8ockP+4MrC0g5H2II8n6yT23+buqYFD5jcwivyxe1Gy
	5/lfRWnPq5ZUQJ0KapiCwhD42NZjTdkWnlQbcM4B+aQWmpSrEwQCSg5DrcfijAx7
	dQpBlswnAhSAeiIt8WLA6IVW9h38xnqQM+deo9jgsUH/YlsC+rVB0z+3S5adpNUS
	A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh867excv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63G3dXDm022548;
	Thu, 16 Apr 2026 03:39:44 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7npq7mb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 03:39:44 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 63G3dgit023193;
	Thu, 16 Apr 2026 03:39:43 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dh7npq7k1-2;
	Thu, 16 Apr 2026 03:39:43 +0000 (GMT)
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH v4 1/3] mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Wed, 15 Apr 2026 20:39:37 -0700
Message-ID: <20260416033939.49981-2-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416033939.49981-1-anthony.yznaga@oracle.com>
References: <20260416033939.49981-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 suspectscore=0 mlxlogscore=991 bulkscore=0
 mlxscore=0 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2604070000 definitions=main-2604160031
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDAzMSBTYWx0ZWRfXweU741C/7Ah1
 DOj0Fk5yXEwNdLh7itYMd2mOGH8YuqklOnzqdmtYx4bTXjZzsmc+QeLBOVHfUdGpEbXuyXd5D0e
 HmoLx8qZmI8b+FOVTP2fyV1CzYJhzr7bqEsqfcecf9tfOvwv4UsGChhKgVKy6dEE4648NK9Jg2f
 8WPRZpQuM51Gz9OefmRiF2Z2o0MK9QtxBbtzBP8IcWfha8WnjoBPCpaPtiNCZIfdDrFNxKBmIEW
 Y/q5MHwVq/ZSFr8fWBA3lm/HqUcwC8cMGyY1YU2IcVsPbhc2JNNFV/eYYeYFtWDTZkf5wueLdla
 04ZE7A4DAHpNl289b25rWzyGHfKt90OoMVmq1cKCcKesWPTXR7hWmxkdf1Vup0NogGF08OCNkzH
 ZUsYl+ySjy/zodfwh+6at6+XAEySdrvceThnSVoElPrmho4xbtZCzVSoEZG1WWdhn28FLtLD7BB
 GvXLx0XCJ8ymUYadzDeAF1s/P5qBYUBjRfXKaKUQ=
X-Authority-Analysis: v=2.4 cv=cbjiaHDM c=1 sm=1 tr=0 ts=69e05a01 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=Dv_WXUeMNy8hEQbTb70A:9 cc=ntf awl=host:12291
X-Proofpoint-GUID: CsDO3YR0k8f9eD17oFOBMn50UdVXwONW
X-Proofpoint-ORIG-GUID: CsDO3YR0k8f9eD17oFOBMn50UdVXwONW
X-Stat-Signature: nzk5x11qxjf7idoyiqe6tbrg4ig1hbap
X-Rspamd-Queue-Id: 92F994000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776310789-969905
X-HE-Meta: U2FsdGVkX1+BCgEoDMt9vHPAL/datIDz98kCroUI8Lt9bE8n+P0Hlrme4Qp/VOrq8xuuiPFRENsCh8pFwWOlUTKD16NNZrlxlNAFsG6aeUDnSyTUUWKOR1jf4FRGGlABcYoeWyhxOR/ANl6kw31C8vSF0X5bkBKn5zkgtqYHRrdFkT4ok2BCw8C+kuyB5lZgNAhU80gv/pZbJ+Hjl8ZWizYCoYRVu9sB3Q9mlYDvNHBnYgONnv23XCt+zoBHLPFPSWfSRIFjXXpCT2celGnNDu0ASplqIWaNXFk85fwWKBNI0C37/P4E+xC3uBmmjDnDnyQB3/6thUoSnp19To/W0vtLkK5nGNUNc4DPCBlHJd7170bJgW73QP5+NDjX3Xeu0l5iZvzZGujv60pVg7vfUAo/8GR3YKpJ/T5jnGSq9Ure8DeOM4c0C8jXRSig+jUmf0jFgJIDedhVkWjwcEnXdj9r0QtyN6dxOjXKkWtIONUr9py1TyFPdDj0Z8gjscELD4ntPK4u+Qc1ma0azhpiS/oCoHUQxEtqM0xNqcK+zL1ytexCxJ/ISaUZtTHO5t6OhHyH1IyUMF/m9jrU7X9Iu8WhJmtff3uGhxkNcex2DoRQlpBJ3PqVnzJnf8L8/S8udlmn2+/kjUR67spbeSiUvaYFW46Uvkh9KNd0Jv+AoByG+squlXBYp3stCtDtEi/8hBFIDU9tKmCH4X/Ck0hJaxMZ+NzolZ0cTqvRcG94IEu9sM0XB8Ct2thW07Wi1K2YsCn9wlbtqgbTOGnYZyPuAIgQM2cwOTfmxPN+iET+fRGgu5njet6oCr94bQi8tIa3AOaLgv3WSNR50uZ0IN+lBJV7r9b6blKDzrpikyF8xCKfVOVYGbrKkYirulRnkPFQw8hOWQjJt/rCEJYiBSkVqbT7bWonBk0NdyUtaFjNgFGe1eGLp4piU+203UfDNFfn1akzRCd+ccNUrOcu2oB
 l8Ho1ezU
 961QbaKq/t6PXGaCOoBfbUCOvfC+BLlTNT5MXS0vDqxbW8rHaa5hsVtKDyTVsRdvAQ9yYI4g+fWZUhAL/j0Cvl6eS9+5KuszR2+wmUkJTMVIiFOD2RI4p+Zrrhp3720g4aE53q2A7xY/WK1N7r91ZEhNC5Vp2apd25niupxPmY2CxNUGtorHGMKe3IEOF5w+GO/prX5dDc0m00ur2svbd7hM05FF1Bx3RLnqAsAwE+BMVg9/8mXCQ4F7+M1AzhSWQr5w6p3Q2K82wd4hChnKdtg2UaqKIk5+MlYeCF8JGw5uwtzz2Eb+NKd5aFSzVI9WwqdV+yR/bM6suNMkldBrS4tRQ/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On configs where MAP_DROPPABLE is not supported (currently any 32-bit
config except for PPC32), mmap fails with errno set to ENOTSUPP.
However, ENOTSUPP is not a standard error value that userspace knows
about. The acceptable userspace-visible errno to use is EOPNOTSUPP.
checkpatch.pl has a warning to this effect.

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Cc: <stable@vger.kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reported-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 5754d1c36462..2311ae7c2ff4 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -504,7 +504,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			break;
 		case MAP_DROPPABLE:
 			if (VM_DROPPABLE == VM_NONE)
-				return -ENOTSUPP;
+				return -EOPNOTSUPP;
 			/*
 			 * A locked or stack area makes no sense to be droppable.
 			 *
-- 
2.47.3


