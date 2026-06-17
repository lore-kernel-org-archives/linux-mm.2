Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A6C8CD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 17:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770076B009F; Wed, 17 Jun 2026 13:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745C46B00A0; Wed, 17 Jun 2026 13:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E8076B00A1; Wed, 17 Jun 2026 13:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 361296B009F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:26:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ACAE7A04ED
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:34 +0000 (UTC)
X-FDA: 84890083908.15.82BF19E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 889DF140014
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 17:26:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZEmUIIVT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781717192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AADwJEegnLaSovYbQ21oISFVKWqrD8KXOckyXaDfEOI=;
	b=6sucMzdxY2GbG8V7tgiNuORrflMXHdRH8HN1v9faXv0YMHHuF1PzlMOFVEFX4LOX8K5w5J
	s1VeIbZDPCyhVI786mH+bZpZL0VXEqqBYsbh4pHQwfX7mYZUXJRjMpu5iRNWkxmuKvm7SG
	gNIRefN1ETyJ0AK65tFzXzA67Sy0uTw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZEmUIIVT;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf26.hostedemail.com: domain of jane.chu@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=jane.chu@oracle.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781717192;
	b=qSGk5B8N0S5dHd76leNsDPkngNgpFWzVeMjy8OLGeuTBSAneXzPvayyB9GppueLL+xxHZR
	xrWFx5JACCG2n53skGjN0kd2O/BdsoHToamsAo8F0kns8YCxwMT+yEifl/z4Tp8550Laut
	dQUAUw/OYqgPOpuP3XvQh3cFzrWOCVI=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65HEsKB22481211;
	Wed, 17 Jun 2026 17:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=AADwJ
	EegnLaSovYbQ21oISFVKWqrD8KXOckyXaDfEOI=; b=ZEmUIIVT/S/GZgA7jY+hI
	EuwVglcwDgO3Z3gNfSvU/oaZoPPRRaKbWLqnFdObcuocmLXvRrvJYMMSEh/5ts4v
	ix4TVehP4ewZH7GnreIFVWyryBO9ubidmDSLA/MBD3FOoBpWZec9KWF1WbRD/7Fi
	NZXoPe3DTt//FTkDLtP+wv3en3eX21IxxZbE/SAJ/mrotYHE5jLsYUgt05WISY4d
	nFVJXhWO+D+ZkxiGk9Nk81BB1JdPcPITyi15Dh5d49sGu7zNKO7JZdgGoBxExtxf
	CRCRDg2DNSh1gjOVhC3aEBzc8MX2h7PucX9yLIPvrOunKx5HVElRpmK3EleW+62I
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eueg2hch8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jun 2026 17:26:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 65HHNVP4003778;
	Wed, 17 Jun 2026 17:26:18 GMT
Received: from brm-x62-16.us.oracle.com (brm-x62-16.us.oracle.com [10.80.150.37])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4eudvc0wgy-10;
	Wed, 17 Jun 2026 17:26:18 +0000 (GMT)
From: Jane Chu <jane.chu@oracle.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
        brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
        david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
        linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
        rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 09/11] hugetlb: remove the hugetlb_linear_page_index() helper
Date: Wed, 17 Jun 2026 11:25:30 -0600
Message-ID: <20260617172534.1740152-10-jane.chu@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX1YxMXz1sh4ji
 3Xmx9wIW7m+FRpxr32JpNRN2sSCTr4KEd8D5RSRo2I26uuKZFrgPbG2kcP/UU0UXoCTX5tLwp+u
 yIQi0z+txBiJsfnSngGnnVD+AlWDHhKRWgPaRDliERXpbMAvEAuVQViQuYMDxkUtNGILT8afaJv
 m1j85294NvI+HvgLPhnlfavtJk/9crcafupPtuoAfDSuvdCoc2HYFvuhnxS1uBRcyB5f9rWgsy+
 EABiJhGLisyBPyAEDbONV1EodH78xSmNMk+N8X38oWxzvOeBMHNs5KOQUJcfX0YnDPomM+ZvT1Y
 k1g3vV9Z+WMQap85ds0x0EvzWvTzwiu7BH9sJDVJg71KQH3CoU28zLq266PyDCLxtpPkLaFoKe2
 0h7w76PLEHS1EEfPFSI7oWFnNdWj/vZ9DcrVZRRpFQZMxR/TJFBKJPRiy8scjiN4iHZJzTHRvVg
 UBgqkcNote9Thuu6UEmSt89fC/smvgvkdRF1Crz4=
X-Proofpoint-GUID: LPAL_NDFZwyz429ZSGzojPt7Rvb_VSAr
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDE2OCBTYWx0ZWRfX3qoKo5Cefkw5
 SbMTTphCCkTl+lUxOl7aEUBIU89GtsYLpHGZVUuZAcyZXX1RmyU2ye5FWi8iT3hNHiHQAtpZXC9
 d8UQ0afqYabqzzHQkq4sVuvfYCU2cSaXYdCW5J/5qZRNrlaVxCvu
X-Proofpoint-ORIG-GUID: LPAL_NDFZwyz429ZSGzojPt7Rvb_VSAr
X-Authority-Analysis: v=2.4 cv=UY1hjqSN c=1 sm=1 tr=0 ts=6a32d8bc b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x0eKOSpe3m1H3M0S9YoZ:22 a=yPCof4ZbAAAA:8 a=lddk_7-pFbXPVCeMFioA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12312
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: x3em8a637kjrsoh3bg8c8q9hm16ugc16
X-Rspamd-Queue-Id: 889DF140014
X-HE-Tag: 1781717192-577626
X-HE-Meta: U2FsdGVkX19114Llatpk9E11LJfz387clMdbqn/ybHV2oYuGmBEi/RnT1kjvRgX8DwcLHJBTTlqbNwmGeUJWy8dtnv7bYHn7YrRhTzIUZdsW43P9GDLVbph/t8Irgs5ZoEZ3xhwzQ6bohM0e5EIqSSFc7M+6hI3pkccjxPWl3jfD8V5c+t8KklsobGFUfM9R0FZ6RKMrzuFyi7y+rILUpJrBZOwBRiZjg9+mQCnaxEUDHWgUDo2Yj96CrTN/7Pf4w0mNry/jAc1TLYEQ9luQk8Icel9yVzS8zs4fF7nNDvJmBm2s/UjRi9SxX0n/h/gfGybaYlLDQawHMaFZGVy7NRfm+aFYQQpuuE79LNLhJF3puwiITJ/MqfHwC7dnnkhyd9mphyc0mpDzCi47yRWXdTP74QwbdG40JMYarJDxOovgrhTOh1oO79NpqEtg5C8F+4qGRrms1IZksHm8giQeAjJDtjImEj3qcxcOy7q6kmXAptcmBaCR2scW7Q1G+iTuOL94z+ne0R/Odn5PO1eVKvSi+BsXKOr1sqwhcxNcKdaRPmQTSJzJGavANtYWO+TEYwAFsOYxf3IS0aUtkgrsMw24/M8EtzFITDT8KjoT1OJsEdTP85zQoIDyXNiIlvUUzqKPREs1vQYhASLlWidI4BohekCy5YNWYeqiWcuDiFuFXLjzfiENOlzrbrUIddrz27Tv/1mYIhqESByGFUNmHfdFjjJ9N98cA1JMghx9VUGClNgX0l87Bbk5z1DzAP+1Vy+ec7LIkqEkvgP8FM87NAvaPvUK7052T+gHQ22YuBqyXhJpjwZQNuprn8aKrzu1QfzjKnqoVsSGAA3iwXb/udFJB7tQOXJalLWudaCDS9girpTwM4beFukll0334YjupSRYMB1lQMNfG5Xm1ITNiUTPFTdqRVADbQcWCH08zwWxPLDnZZ9OD5+fd0qKiaG0mmHXqLyBy4ewHvn+c0Y
 owS9EnLY
 /KRedY+dqXL4d1+i1rrs2PGtvl1QlwK64ZHs0VhfWm6HTRkamhnnLiyvtJQq9S8BEKGL83avBb4wVDY3KcoXIR3zznhPchY7e0ijrXa2oHUxsQo558hu/4/Snu4lLfndHlMvLiHrLaZfzJStdnORjrCb7n+6tDW/DWNL2nxiTCUq6rzP9vblNxW3g2fJklHFp1WJrfozSdFg2YdvE+tGlnaU82AGsGpFf8QhNamhlAdh0t+blvS894c/XTO/OluBdWlGoB3in55ldps90tNoFlPf5l+l6E6VlQKCK+n2ftfZwogMMhae5FGrxwDVXm4Vz49V9ObaYX4r92sBaytI/32RdzScIxIe57PjF6yZmX123RwJhSICuMzQk9dRC6AW91kiNjHHVLAcZBnc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No one is calling hugetlb_linear_page_index(), so remove it.

Signed-off-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/hugetlb.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index e78d0f706681..e5a459a6e4b2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -787,23 +787,6 @@ static inline unsigned huge_page_shift(struct hstate *h)
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
-- 
2.43.5


