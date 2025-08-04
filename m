Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0E6C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 14:51:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE568E0006; Mon,  4 Aug 2025 10:51:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29EAF8E0001; Mon,  4 Aug 2025 10:51:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166F18E0006; Mon,  4 Aug 2025 10:51:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 029458E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 10:51:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AFEF716066B
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:51:33 +0000 (UTC)
X-FDA: 83739363666.25.24E636B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8993F1C0012
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 14:51:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYNUHHRI;
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754319091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=17C7FOSF4nv5DZMX7LJVuuFlGZvxqCMZkETDXsXXfKQ=;
	b=Upx/OgPGN+XRjHLamSkAMKwvAG5/1RO36C7WhLImivWdIlblLjFzb/GgfIg4p7J2EC+jgC
	0BW5MCp6KfFm/97PFwTndQ4HKmTUdiqNoOsQrXZyuIB8awhrUUrpBLPJvWY/GAacudWCT9
	rGjW3JhNNPyaKmEXi3eSZQQNbrhMXOI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754319091; a=rsa-sha256;
	cv=none;
	b=r7/xcoSNyO4dyOR8EoI0zTpOGsXo1pI6v7qamBsQ2lWb3B12NvxM1SwqJfbpP8uDxZxn98
	elVWFftzMPR4A4AwEPtAwR+PRtELvUCcAQnkzPsl9sWitZjUDFu6qsCt8TWsFcxag7CVJ4
	w6+mu04/fKeITzcUcx1oEq6FVj+OjHE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZYNUHHRI;
	spf=pass (imf18.hostedemail.com: domain of sidhartha.kumar@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=sidhartha.kumar@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 574D6Wjm018172;
	Mon, 4 Aug 2025 14:51:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=17C7FOSF4nv5DZMX7LJVuuFlGZvxq
	CMZkETDXsXXfKQ=; b=ZYNUHHRINx01eTzaQ+TA2cGENV/DdCwCQjhmI8aNldiJr
	YF+KSCV9t5cFfZD2M+yViESw56wdHriJPfszwYjguol86CkDEGu+UmbI5jGydQ6K
	Bd15sepWcs3bzKWVhqy5t4BemB94Z8XIYJJtnhGwsdUJiAKXV0X4PPek35U2D1C+
	EQ3uztjIl7b/2c2ldhElAnkr2rN2q1sEjqubZUnIq6NpHVFPGGvYwJbQKKzr7n36
	zIjJZDp3fnTBIqrwLV5yirh8XhUodXr3BVETGQ4jHKbGNJSsC7qlwuv6+sdC0z4/
	32+rpbHwGCKgbJOmumQjrDL1Yoo040MVcI/TnXy9w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 489aqfjs89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 14:51:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 574EURXT028937;
	Mon, 4 Aug 2025 14:51:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48a7qcqhtp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 04 Aug 2025 14:51:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 574EpKi3018772;
	Mon, 4 Aug 2025 14:51:20 GMT
Received: from sidhakum-ubuntu.osdevelopmeniad.oraclevcn.com (sidhakum-ubuntu.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.108])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48a7qcqhsx-1;
	Mon, 04 Aug 2025 14:51:20 +0000
From: Sidhartha Kumar <sidhartha.kumar@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, willy@infradead.org,
        vbabka@suse.cz, jannh@google.com, pfalcato@suse.de,
        lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH v2] mm/nommu: convert kobjsize() to folios
Date: Mon,  4 Aug 2025 14:51:17 +0000
Message-ID: <20250804145117.3857308-1-sidhartha.kumar@oracle.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-04_06,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2508040081
X-Authority-Analysis: v=2.4 cv=TrvmhCXh c=1 sm=1 tr=0 ts=6890c8ea cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=C5nWjwYK2z89P-DFk5UA:9
X-Proofpoint-GUID: KnLydMSgKGKV-E2Ab43IUgMOPHA-Y8WY
X-Proofpoint-ORIG-GUID: KnLydMSgKGKV-E2Ab43IUgMOPHA-Y8WY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA0MDA4MSBTYWx0ZWRfXyGh9MOuz/m/7
 mJqqyTyxT3nXL1PGuqzqmSKyzxf826aHtu1xMNCRQJWXSS1PuwqlWoQaiHcsTsIAJ5dPJPvble6
 4/WfkZH2W72Afon+imOVVw545pQLpIAdOHH4rV0MG6UptHIUnZY89pBeAVWrgEVqynjInhIqee4
 64GIDyXkndZJ69KKmpsIvzkAj39wpSx+r+6u9VJP4lB1X//HUZW9RUxN1AB2GwI79YTC+b4nq6L
 AEqDEokiddajfndpUyVwUz3iaPiNUxAs+j8muORk6JjoDGlCtlDgQBHHYOZmSOVuIOD5p2V21GQ
 kSPf7hzJPDo2kPAntuvPsMk96oocojRXzBuVXHcORZFmUw9A8dxWUqFVb013qPoSvvB4AC2cejL
 tym7qmX+E0UKnV2RZND3dTB4tMoMB5VqmxpkF1khmdt1hlnyH2ER7D4EVztQy4oVPF2Pakju
X-Rspamd-Queue-Id: 8993F1C0012
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nw3hotouyfu6tjnprsrudng3jhn83w3g
X-HE-Tag: 1754319091-105175
X-HE-Meta: U2FsdGVkX180JAlOhPwJvfHb76ChLyfSdiT8QsK0PLSllBXletHWbBoll1aY0Ii364ggoZAD3/h7FAaaOntdOo9WvW9Yo9QMSC/5ILHk/RyoZ3/bOlNBsScFUbc9G1KzzR9BcQZcSlrdBLfGMHJR+4E9miRfeOE9eI9KpYG/Q6rh/CBMlsSx0upkbDDmjeRdO8LlA4qHilfWS7aWs6W2i1OT06bwOjgv/zQ7GYQ6o+v0L6c8YQzfawZj6H8j8s5UInZ1jVFHIGPJCFePzKDjggCGUNgexqIHc+Qs3fv4V3lGKZF/z5s9c9o497XvAvjfSjbXORm1wFLJ6/I2tho52eJLUMgUSElVpQ8UnNgEZuRBRYqJbNbj7kjvcQPmoI4yD0ojxng0fTawr/HdizLqbDR5tp9LxoPQpjXoZqEqx0krniZpXUikrczn9k+RLf6Mp3j27wR6eXPzdKDTsrCvcUensOhStGxr0zgbQLwkSma4ZV0/Bbjz066ZWayud9OIEmx9XVNR9ZXLiKVm41UpT9U/I09Kb3vW+JR61GeZrEVq+rk/fm68rf2vgwVaVpwl6DGoGfKPMe3YHvLrbL7UOGGF/gMCooWpvsKbW8ouFobGOLzyvbIQwpOKp8xw4Bro9MAgHyEFC8TA5ou03pla2JAOtS3YOoqRzsrfpOy+PFkQMrpIrukn8mr68OmSDUTZOcJjL2fWy9pixzCftyTXbr1R5GQ10gJBuKIY19OUR/g+AqL5j3tmqx5xHNjMG4J0uz8QeIyLs97Gbl532GNeO+Vub1xr2SQ3tIXxl88RJ00ZHmW7NP7uAZGVU3p1o5z69qT8eyLtIYMBM/FdHCgDpkPQFm/GVDL2/HHtctvM3FbWfqg/R+vbuYL5ehZANWm0TwPebKIz01Vf/MSOyGPQ7Q9cyml27z4SGSCn8Tgl6Ej1e0eEVo9MIzFCVDeaV0t08oz6mDDuVpfKBvCC0YA
 LTYEvWp+
 /jnXuhATuSNpzo2TF6+JGschuMAKoQ0rlIwRQuYPhX3kOo1xnGwM9+i+hYpRVCh1uxmu67XBf5SA8VU0aCUta96bNjAfqFjGLFR28Vrbaes7G20DhYkJxUBc7zveXS1B+axk5EorljK29m+sdj/zJW7giGCuChNQCGuYr5dA3n5fOylx75jLXgfA9m4KTnBQOuQhA2vfyXkqC6ho8jMdtSlm0snJabfdrQy5Q5/q3yLrc9hOqkVqQlIX0GJxKlUYGWR0eQsaI8unL1ndBzk3X9LNdVqTxWuexRv8k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simple folio conversion to remove a user of PageSlab() and
PageCompound().

Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
---
v1 -> v2:
	change "compound folio" to "large folio" in comment per SJ

 mm/nommu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 07504d666d6a..75548fae28f7 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -64,7 +64,7 @@ const struct vm_operations_struct generic_file_vm_ops = {
  */
 unsigned int kobjsize(const void *objp)
 {
-	struct page *page;
+	struct folio *folio;
 
 	/*
 	 * If the object we have should not have ksize performed on it,
@@ -73,22 +73,22 @@ unsigned int kobjsize(const void *objp)
 	if (!objp || !virt_addr_valid(objp))
 		return 0;
 
-	page = virt_to_head_page(objp);
+	folio = virt_to_folio(objp);
 
 	/*
 	 * If the allocator sets PageSlab, we know the pointer came from
 	 * kmalloc().
 	 */
-	if (PageSlab(page))
+	if (folio_test_slab(folio))
 		return ksize(objp);
 
 	/*
-	 * If it's not a compound page, see if we have a matching VMA
+	 * If it's not a large folio, see if we have a matching VMA
 	 * region. This test is intentionally done in reverse order,
 	 * so if there's no VMA, we still fall through and hand back
-	 * PAGE_SIZE for 0-order pages.
+	 * PAGE_SIZE for 0-order folios.
 	 */
-	if (!PageCompound(page)) {
+	if (!folio_test_large(folio)) {
 		struct vm_area_struct *vma;
 
 		vma = find_vma(current->mm, (unsigned long)objp);
@@ -100,7 +100,7 @@ unsigned int kobjsize(const void *objp)
 	 * The ksize() function is only guaranteed to work for pointers
 	 * returned by kmalloc(). So handle arbitrary pointers here.
 	 */
-	return page_size(page);
+	return folio_size(folio);
 }
 
 void vfree(const void *addr)
-- 
2.43.0


