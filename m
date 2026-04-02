Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3DA0111224C
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 00:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04FC46B0089; Wed,  1 Apr 2026 20:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1D5D6B008A; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E093E6B008C; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC5986B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:34:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88E745750B
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:29 +0000 (UTC)
X-FDA: 84611744658.10.95F6C71
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5AFC21C000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 00:34:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=quK8IuPj;
	spf=pass (imf18.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775090067; a=rsa-sha256;
	cv=none;
	b=D5Hb7JmlbIxRxEfLt21UddhuDHeE88V+zCbX0jLQFHKn3GNVdsTOFkSf4apsU8FBmC8wjg
	le7ee34jQWh4s+Hfrd9ejmX4mBfAeaLk26u5FljYl6rVnO8Ni4/WNNkh9CFm6gF/2M5q56
	MyjKOLLcvVmfXgUv9ufAC0fUvCu8wxQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775090067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dOBYyv3A6fc59MBInXOI0qr/cp1C0Rbd5GSjFSiR/8=;
	b=byyVvkerozd12TUcoY2bn+zIMMaNubG9fSHJHPn/gvYgUNRw3DEjsJogRhdQso6TzXvd1I
	qulKDUi48z48RMinEQFVUT42PYmD1KPwwHPN2ssf51qlFmFUsc/e1LP/+WbGA4U18ocMxe
	g96z01usHDetkB61uF9P+omV5f6+9Y4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=quK8IuPj;
	spf=pass (imf18.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6320BoMn337829;
	Thu, 2 Apr 2026 00:34:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=2dOBY
	yv3A6fc59MBInXOI0qr/cp1C0Rbd5GSjFSiR/8=; b=quK8IuPj8pMGJ2T4vc4MN
	pnmoOWyz6blbF7KX9KRp1Gvwxqwh2nSS7jq7d5exuIM2kckY5ZLKXh3S/831nebe
	tyxfuuEgitUaDT8PaXXEA9+v/MK5Fxp2YiWv7vQ/MRjPHkQtPUXGZjC8qBj0HlaX
	XBla1rvIHB9YWYo6TxMAMvAiZ4PowpzhpO3wN2IkH66FgtHZETYV4nZakDu9ylpr
	3VNOxa/Kk9TXRXGM+23W1tFO+ppkHETKbWZ3q6J92PJmg2gmjz6QU8P1FatIGORY
	TAK1KhBWFFX4oIyojWqRJNJsfbLqNxoZ5LOB4uhrDKzcP6Xl2SvJJLgcm+CdEpmi
	w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5qjtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 631NwbJJ025980;
	Thu, 2 Apr 2026 00:34:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65ec222p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 02 Apr 2026 00:34:21 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6320YJ7e001596;
	Thu, 2 Apr 2026 00:34:20 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65ec221n-2;
	Thu, 02 Apr 2026 00:34:20 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
        Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, jannh@google.com, pfalcato@suse.de,
        Jason@zx2c4.com, shuah@kernel.org
Subject: [PATCH 1/2] mm: fix mmap errno value when MAP_DROPPABLE is not supported
Date: Wed,  1 Apr 2026 17:34:16 -0700
Message-ID: <20260402003417.438037-2-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402003417.438037-1-anthony.yznaga@oracle.com>
References: <20260402003417.438037-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-01_05,2026-04-01_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604020003
X-Proofpoint-GUID: 6Z-8Pd5rBCVrAJq5qnKIDBNWX2gY9RRO
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cdb98e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=8mUEbX9rbSpP1ZQJX6cA:9 a=ZXulRonScM0A:10
X-Proofpoint-ORIG-GUID: 6Z-8Pd5rBCVrAJq5qnKIDBNWX2gY9RRO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAyMDAwMyBTYWx0ZWRfXweGrWjXFhoe0
 ak8nteaYbA7rH44XhsjFSL3Vnm3ocduDOalfdsxapBJpsRioIrjg4wwkgS3ohRc0ulV393oajvf
 1HR96MjGTyrDxBVCqGRRuhCddYCrlX7Pav1Z3Y/f4G1MOuMLGmQOEbN5jAz3pnvyF3+6bErJ+ZD
 dAlGb7nacHB1sNJRq8fm44Cr0WutxsklpF7d1q9hB2Ch2j9kjTPhE1U6WAiSYMbk2fSKvHMMPe1
 315ekbd6rQNuhoHyXL1ztSlbI+9DMHlpOH1lOM0XNxlbNSy5gB82Q/Jns3KG9qivsmnX6XiQojb
 Npm3yPaQI8zwQxPFyGk/NXFS5V60knYVOTHILi8Gfo2n9VjSGE8fLEJTfLCZroUSFAeqhm+kuGh
 WBBZFfcuKzFEggR2yrLH3DmUp1IJHnJBzhdbSxkKp8zhJerK3nIRBGaExTYuLWT0lt+UTMBskdt
 a8wzKU3642+VqeUcjgA==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AFC21C000D
X-Stat-Signature: tg816hmb7gg35j3b8nfh9m3nha1xzgn4
X-HE-Tag: 1775090067-597049
X-HE-Meta: U2FsdGVkX1+p2DbkZuLFe/LHOn5mzhx0xTUm1+unxywrg/Gp9bvrrmLh4FYkpPYPxhcjx34K+8pyS1UfzXf9K7wBg5ydThJ9ci+1FL7i9ySN/dlh5Z65UPv40v8kdwNT8aVQBgiXbp1y8+rPJwvyL8cf2/qXKjf6JK271rJc2nvID6Pf689jDxjlsxzg8R5lRprkx2oCd8mxdGZDm8iRcpeWHcgnqayrDg7NwNKQksLhlCjqg/XOZoNVi63RJmtNMXzMLJltAmX5XXEcAhBAxNXPr4peOTiobet/rQGKjN4LC4Rn9JxZJ3dQ6PTWpmJK7MDysAYzMI64pgzA216D2Kw4XFvMyGa9IEmS3fhUPC1fGilN9QC3d3yYZHN4uizo+DkWsI/PxNDWgZrEwWTW6r8hcDZlrTH/OyqVTa9zUNditZsK7yzCd6siIqgQ7/qvbRB52f9LOV+YzSVEo3SkhwJnmiKn6OafLhwyQ0yPYJV7xIZ6/sF1o19oMO3LxiUWA/jVBGRBx6ncKgzc7c03idoCpxIKmglnD9rHKe96/EjRx2htdoc6lehwBFr8uekFzaJuELTeCTaPaov459qPRvmwQcSenIEkzWQXzKHoC9W9s/iNPEE16gsxxtJjVIBUm3FfZtCD59BGzpbQs2PlzL6yv151YlzoufcekqusiX4hqxEciFxS8WxL10g6XlKgQMHyqOGAkcqIGdSglpOUZtdOKipP2NlpH2C2a2ZEIGNPQVZKM+5QwZA2ibnhRdwrALaVqGfRXG8tQab9gAdWMaidYeybKPMgPrI22aU41oFhMIF7kDWifCmsbgPbH0LLDieyYBFU4zJKB8HtIYPDGk9lFTzwJTDsUZsAR5tcjO2r5BgvPic/HpJBPuc8gWeAXwGLT3BXB7rmslhQE6qMiaxLVvy2AW0h56LktUbpRSys3HDbCUYcrps81SZaWSWduUvxLJgUD7TzTLR/9JV
 ERzkXwYV
 CErj2crl2StqLmuALF7Wpuk22MfQfDy9MTNh4LaulePOgymuK1wHoEEWvgk1/mbWnbv/fv6cMLGZQ+pEw7S9LIP+YV1YzH6+sesWfF73263udKglTrUi6IuQM+chCxq3Gaaaxo2C2CZ62ETpmpoz5JuB0zr0W1GV0Yv3AnXX+ranwmGrVTIBYjFF4izOUYm+KtjLteTXDoGH8IWFVyd+yK4bAd0odf9l+zQI6AYbKm6z0lxH9Pn6lhl7vyQR+JqA+m4HQYr1AUK+kbntcDCqEjO4x1pwPgAdOdr2ZR3CMi7w3+iUCkX4IC7LD/VKTi1MDgNKdFo9i0PP4/DA=
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
checkpatch.pl has a warning to this affect.

Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
Cc: <stable@vger.kernel.org>
Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
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


