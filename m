Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91591EB362C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 20:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D034A6B0005; Mon,  2 Mar 2026 15:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1406B0089; Mon,  2 Mar 2026 15:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAFD66B008A; Mon,  2 Mar 2026 15:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9EA26B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:10:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CE63B81A6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:10:33 +0000 (UTC)
X-FDA: 84502215546.28.8F4AE27
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 260182000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 20:10:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FXTMu1kA;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772482231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YXHDmRAJblDSr/w50pZwQvB4W3B++p0nNeeyprSaq/8=;
	b=md2NxAI7TYNISsLc/0mzlf/kFFR1+5PFLv26dUePDLO+P5pSICU1oSy6vCqFtQ40KO4MIP
	pNTpoCV8HTY+p/DZq1wwuYoxPdjM64VtmLga9F2rQzpTycjr57ZFNOLWHss/B6p2NPfLPK
	e+zNHFl083SAzqIJuxo2xg3RucV4iy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772482231; a=rsa-sha256;
	cv=none;
	b=262dpJWYcc+yl4sPdfqmb1K2YuRbZN0d5fqYbwNtQD3VGHofJh99d/D5v0KginM17Oo3dH
	wbvsM8crCWj3GTrLu5lbbxkpgUDnJUht1pFYC+/4MJIEiAoeSYNlAitPDFB5Rzif509KEN
	ZRhTJVKJOj81NCwIl0l3mh5KLKD+SQw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FXTMu1kA;
	spf=pass (imf03.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622IHmIF1634555;
	Mon, 2 Mar 2026 20:10:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=YXHDmRAJblDSr/w50pZwQvB4W3B++
	p0nNeeyprSaq/8=; b=FXTMu1kAfZ4RicZOUMGvxNl8da7oOgR8DbsDjhUPkNbvv
	yvYGASonEYFZbK4yJ0mY4cCcNiZeKFxncdobuT5V6jhuSFM8VbR+6du0UPFNawSP
	aaHLc5ZCiWoqwZCsgNTUzKgaWR8ZXGZQofPWHn5gE/HAM+zZ5idSUiVcdz1R15g2
	gIW0/pYCdKzGyWkSdmB+blF22zVodwQVP4Nb7TvtShkWb8sySy78nnWqFiFCSKuR
	A7xUKa7afzhSeWyG/FyKP5iQEtWuoVYQHDIALv/B9necioBoHjxvsm4ZHMi+z5HL
	jn2Hnsssj1JOsLG+I5WSP4La5A12EvyLMgtT6NqoA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cnfpj062d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 20:10:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622I983t029717;
	Mon, 2 Mar 2026 20:10:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ckpt9e0en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 20:10:23 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 622KAM7F009395;
	Mon, 2 Mar 2026 20:10:22 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4ckpt9e0db-1;
	Mon, 02 Mar 2026 20:10:22 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        skhan@linuxfoundation.org, corbet@lwn.net, hillf.zj@alibaba-inc.com,
        linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation: fix a hugetlbfs reservation statement
Date: Mon,  2 Mar 2026 13:10:15 -0700
Message-ID: <20260302201015.1824798-1-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_04,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 adultscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020154
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDE1NSBTYWx0ZWRfX/aRjviUkUNsS
 ubwvcAFlejuDW0gxuCKMqKHXv6qHw60BP3pyimBglmlcgu8qnPolrB4WKtuoiEunG1RPBJ+lBWn
 kbCunwB1Xq4niYZ+fnqNRw+aoEk2QYduNuoMuVvplWJWapvD4ekDdGAF5vxkx3HGWKcWfAK6+2u
 AC7K0cZ6Bjfp7uRMtNan49sNCz+A13qXnO463vZGFs5tPH85GnN07kXm2QxJLOPt0vztB1MvTIj
 TABxTkltFz+bkKYa0MgLV3y+OV9CGkzMA6FYYuNieNkCO525yF2pB1xCCdyo4Jb0BZYWEUZaDU9
 Bzkz1RQQ5I7jida80mIg+oOylmCtH88JIjIWT4NLy0LV6uXnjmmbIqxX7aPObrviG2Lef/afxKa
 cEUf+qzNLr/a8JvKaVuPuSxJ0O2QL+JMrQ3n5w/zgAEEG/VU6koBAfjXB8+4jVwu66mxUvaL34P
 XTfhiSNxtVfThD68tHQ==
X-Proofpoint-GUID: MxYdjxIQBqfr7kRa_UJU7v7ptt2NEbdO
X-Proofpoint-ORIG-GUID: MxYdjxIQBqfr7kRa_UJU7v7ptt2NEbdO
X-Authority-Analysis: v=2.4 cv=JPM2csKb c=1 sm=1 tr=0 ts=69a5eeb0 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=7Gl3-_t3PgB9XO-mQDs3:22 a=yPCof4ZbAAAA:8 a=A5wE46Q82j-DBPHovb4A:9
 a=FWFfLhjteEdX4JCrYqk8:22
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 260182000C
X-Stat-Signature: xwf3nwf8fzg18mc3dkj5emau3mogo6qs
X-Rspam-User: 
X-HE-Tag: 1772482230-752822
X-HE-Meta: U2FsdGVkX19qAWSGPeJfXpabeF9uhl6mTTtpyzGVC9wHtItZOK/cdD6Pn04Hpkgl+7QvZhpozwn+hCBGj/zJItbf3pqhCaZJDzNXgX91hQH7mK9SuMuDpNFHTxG7lP2b/OlWp32Sw/XPw94fVwcXTGK2UGODUbhfUzyyrrrh+7oQ29+Jo0WrZs28nlmuHya7oF+qZ/oJw/qFZeErVUUnDM7QfGnUQwOj8P1VDey6ANqF0v31IsVZ5mvBsg3xmfzDaYaZ6w2fGyPoPglFugrrg5cs3hkgZOffWVqunX2Xrqo6disQ328IAv42ct8wWeljgIMvOOl2tj2FGiFnEICyMKWWPm3UkLoBdCb4ud4/9ixbQMSzDCtUcVJPLo4fQ7YXT1NGZRXeDvyszahJoQNwUNsZ9j3ERqfehh9dYdLWond+pbmhS6ZaslMlS4R1Bu/L9FGhK0VYG09vjqBT1DuzMEST6B2miz79yL6K3EQpx/G980o9R+J9V2yBaZbEgwCYPcX4AbMgsza8aolkmk9MFewgfHH46uQS0nGoWJN5Jx1SUlYLsHgLxrGuwNXfrlLxIDkW2i89ytwk+gZhfZte9rhY/Mfd7UmP7iFODCVruS3WW5UFLmh3cq0J2xQMV9S1m7JayILoLAAC64/VuXoLz4w+kp5hgSAqqHIXslOP/3+hHWPZnJ4Ae/sqjeVsnWY1vdEaxJNbm8rFhDYPzqJ+pNRr84M2ZMqFGrXj/4pmQDF2Zm4YzAg+qtjMtzGeJciTIYxVZegoq3URRQ1ZJBCeUYCNHCm0RWjip98hatufrggtqPhK53+wpyG892H0Ajb3JytNr2uvmrMvU2IXWlDO0veSGMa/zFNP7OFhV/K7+ixJZeU1Dqwr61hA3s3P4CmY5BptxvHkMQN64CQq4znZRR14ppwJZiJdQFf75o/PGLKx+a7rHCHfg15QcT5lNbA/eL9Sq4GhKnuqxj5s4/M
 /4YHqg6Q
 fsdB0OGeM4aD4blsyuLPWGY7/Le5ZnisYnpvxsZhYamoj+TpgjbC7hw39QUrs+jEDTvNIZ0yQKpw+lymXFEWgz8oQLrIWKuTqcre4oSzF0HMaleLqOvqM2JqvHqL00/+t69X05lisV6WkZyk4Q3imiVxLYVV+47PIJ2J8nUKO3JhraitTamx9IXikt+BRuNsSjsLWRFQdAMXjxfZfQmds8s1c8wxuQw3gEIPIi1feHk/cjvtXiYu6YcAb6iCQuPdwBuEmRhQO37tTu4QFQmAJSssiDD/oIHJmxJzITiJh0hCfUbMExPfID2PTBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Documentation/mm/hugetlbfs_reserv.rst has
	if (resv_needed <= (resv_huge_pages - free_huge_pages))
		resv_huge_pages += resv_needed;
which describes this code in gather_surplus_pages()
	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
	if (needed <= 0) {
		h->resv_huge_pages += delta;
		return 0;
	}
which means if there are enough free hugepages to account for the new
reservation, simply update the global reservation count without
further action.

But the description is backwards, it should be
	if (resv_needed <= (free_huge_pages - resv_huge_pages))
instead.

Fixes: 70bc0dc578b3f ("Documentation: vm, add hugetlbfs reservation overview")
Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 Documentation/mm/hugetlbfs_reserv.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/mm/hugetlbfs_reserv.rst b/Documentation/mm/hugetlbfs_reserv.rst
index 4914fbf07966..a49115db18c7 100644
--- a/Documentation/mm/hugetlbfs_reserv.rst
+++ b/Documentation/mm/hugetlbfs_reserv.rst
@@ -155,7 +155,7 @@ are enough free huge pages to accommodate the reservation.  If there are,
 the global reservation count resv_huge_pages is adjusted something like the
 following::
 
-	if (resv_needed <= (resv_huge_pages - free_huge_pages))
+	if (resv_needed <= (free_huge_pages - resv_huge_pages)
 		resv_huge_pages += resv_needed;
 
 Note that the global lock hugetlb_lock is held when checking and adjusting
-- 
2.43.5


