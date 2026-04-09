Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87877F36B96
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 23:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C60C6B008A; Thu,  9 Apr 2026 19:42:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4504D6B008C; Thu,  9 Apr 2026 19:42:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3178C6B0092; Thu,  9 Apr 2026 19:42:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17ED06B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:42:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BADE787FBA
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:19 +0000 (UTC)
X-FDA: 84640643598.12.0F628A4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9B784000D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 23:42:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AoWHHsun;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775778137; a=rsa-sha256;
	cv=none;
	b=MjG+hvdHeR4zwT+2zwFJ0IWAIiiafcB92sbp+txZJN+I0M/i/DyBeBESpaA6YUsKewzylT
	RERC5PvJ+RD5rzrHpzVBO1Z6rDfTZSg90Ml+qD28DMgsBXltcjam1X6b4K9WFZtyLwZAkW
	WWGodWZlOmyUuEMraldU03Ki0zhSJeM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=AoWHHsun;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf01.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775778137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bSdH7wFkyRhLWs186r5SR78aocqTaV/GzyoUPrXLjk=;
	b=K9xurNJKMM3nn6JJSncAfkkzUkXXDxTurBGXhngrTcG0xykLkBm09AMvfTqawHKNnLsgvq
	ycanb8trJLjDnffTe9M1QZJGz/y1bnOyRtjl05sqVYe6EjE4MDVFJtAO4NDe+yh37zbkkI
	nWIduuI65wD9q1OJQSA1hhngMzPEtds=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 639JtbOH2622470;
	Thu, 9 Apr 2026 23:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=8bSdH
	7wFkyRhLWs186r5SR78aocqTaV/GzyoUPrXLjk=; b=AoWHHsun5ZXP6mgIdevJ2
	/x4Vay6xnXivohkycC9rUla+VY+cq6FcWLxpN5WhF/hP5qSK0dmQgzWYFM2Rm0d9
	Ri34VQknDfBVT6+me4aQPauPBs86CIjY+VsZi7F7GsmOonXlG+YbWzsd4artgYX9
	YzFMLVW9TzcnkjrLVFt4cU4+QhUQD8rs3aunRIOGiZ2jLIggn7aZ/fr9z95Yj18Y
	kf8fimjc+BHyP1DTlrC+WqWxtwxawwFKyyfctdQgKoacHfPyrqAE7ijVm71W5E9h
	69uhGlmcAyudylJms553npqpGKHVX5S+0p0UaPCdPZa7tk8hI27Y+lEwpo4N01WF
	g==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqarraj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 639MIPEW040165;
	Thu, 9 Apr 2026 23:42:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4dcmnbj4s2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 23:42:12 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 639Ng6Yp038323;
	Thu, 9 Apr 2026 23:42:11 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4dcmnbj4pp-3;
	Thu, 09 Apr 2026 23:42:11 +0000
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
        osalvador@suse.de
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net,
        skhan@linuxfoundation.org, hughd@google.com,
        baolin.wang@linux.alibaba.com, peterx@redhat.com, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
Date: Thu,  9 Apr 2026 17:41:53 -0600
Message-ID: <20260409234158.837786-3-jane.chu@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
References: <20260409234158.837786-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-09_04,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 spamscore=0
 phishscore=0 suspectscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090218
X-Proofpoint-ORIG-GUID: YxPnX_y4GOJbFM-UZwzBQo-qk-_L2LKM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDIxOSBTYWx0ZWRfXw/6/hbDq4Zg+
 Hhgqe7uyoifxrd/JdXy93ZlJMmAxTYK3TXWPB5TrGjzSjyDOmKjoXInr9UkzVV13UIXh9pt/jMU
 7lTW+/+/fJ/qdtonakcpijzdOO7Dv05dLF18pB2PXo2ST2653U5VUqAzUAyIL2Osn2udnjk6Kg6
 XKZoeMhRwyZ7PjE8RXpbNV3YRa8F9Ly06ebv7jhYu0ZnzTV5j3dRX/ZB4DNhZOfEFjerjhwWwu/
 s8UxibS59sSyqinlveAP4CcJ+T0Oa8urLxBfQ2ymdFRWJAtiyLyQn9qszSowdegI7zsn8e7pAgG
 5sa/h2mFVTZiIFs9UObkVUIpJUqvwQ/JKl2txLr3ZQwMEd6LF21cCEmnYTx0jQQ1eubeiBc8F+d
 ssEwpXhfUgxDkJxlXHLLJozyQZZx5vV0BKwBzX32OLTbfnySkr2kANw6+vhU5Uitw7caflwi/Kl
 viqG6qBkuTiOUMiDZgg==
X-Authority-Analysis: v=2.4 cv=AsTeGu9P c=1 sm=1 tr=0 ts=69d83955 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=RD47p0oAkeU5bO7t-o6f:22 a=yPCof4ZbAAAA:8 a=aC9wH1do4BV7vRM6I0AA:9
X-Proofpoint-GUID: YxPnX_y4GOJbFM-UZwzBQo-qk-_L2LKM
X-Stat-Signature: a5xhtd1ozcqs6sg3bhxefpq1txo8d8uf
X-Rspamd-Queue-Id: A9B784000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775778137-26129
X-HE-Meta: U2FsdGVkX18L0l7jnIt5cWyf5sDACR8+jOcMmKmMGXzCq1FT8SRx7+H3hFdJBL6Jh6sSX5mJwNxktNfSnORmHIdS6wptqkRswpy5DHqG3quAWlQsWaDezT4RwxEBJS+0WVScBkorgxLsjbD0Mzfd0sTv8tkBCMoYHY/TROHj6et0Gm42o3S8EQ95S2k4YlCb/ODOSkS/3dhgMNwQaixRZ3o55NJP7GiYONPSIUyyt1MRXAweDHEi6iMf5nshV5wfGNei7mzZyca27Eqgr02FoCQYJzZd9+3xtqmoEFn62HdLjveSVI04jrFQ2H8F0JAtBHzbr1lxfFc9jo8rKDyc2o8a+o4oVWMsWBHWPV4D1JE/HShEnIyuUvVy733ADK06oQsW1HwI4D6s5ZRvVHiCQcCTbz1wQQk4ipwYsJZl6ziNTj/j+f23ALSXU4UfXQJVaghq+n0cB6VTVtErI6v9DhmgdZ2/vPLL1OBJKjVsWYnjOcCmUFbAPNYH5wdKpWsWcxqF5ipaZDQCScHjW7agA6uT06PxxzWVygYf/0YcPt2uS5Y6oNPh6kCpCim9A0GrZF6Yiy5u8iJWxBVQflHLvqroiBSaJifFRECMhf2sWVw58aPYi6ZV/GxkTWWsSkuY9jDiN6T3BAEijPoIss7YY91n9uHY0PC8ScHJiYdZY/lFPgVc10v7j6JX64dPEisTRoiffqOTlwHNfBHdHtvZfQYcOZ2PKn5hpTfeZsjsNhLK53XsWYZ/WDEwyemMmOXm11XUOzbEBNOYiN10D7xC3zCLGmAjqihRzdY9MN+NFR2L8bMUNGlkmW5wbrY9aKP69hS1J/BjC5zHYsc1U2fPMYHQYLfw/bUGkhNzxfPZ6i1eXIuZ240Isusqbm4uF7JtivULherP5+aR1uN8llrDPg+BBGKd/fEqz79yPyObpo7YPTCi0+xCQAiaVNQjsLcI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hugetlb_linear_page_index() is just linear_page_index() converted from
base-page units to hugetlb page units.

Open-code that conversion at its remaining call site in
mfill_atomic_hugetlb() and drop the helper.

No functional change intended.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/hugetlb.h | 17 -----------------
 mm/userfaultfd.c        |  3 ++-
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c64c6e5e50f5..71691a2b6855 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -792,23 +792,6 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
-/**
- * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
- *				 page size granularity.
- * @vma: the hugetlb VMA
- * @address: the virtual address within the VMA
- *
- * Return: the page offset within the mapping in huge page units.
- */
-static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
-		unsigned long address)
-{
-	struct hstate *h = hstate_vma(vma);
-
-	return ((address - vma->vm_start) >> huge_page_shift(h)) +
-		(vma->vm_pgoff >> huge_page_order(h));
-}
-
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 2c565c7134b6..c053aa4389b6 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -573,7 +573,8 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
+		idx = linear_page_index(dst_vma, dst_addr);
+		idx >>= huge_page_order(hstate_vma(dst_vma));
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
-- 
2.43.5


