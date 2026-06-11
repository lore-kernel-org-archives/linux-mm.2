Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A72F7CD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB9AD6B0005; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A636B008C; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3866B0005; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 828A56B0088
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:41:37 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F94B140244
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:41:37 +0000 (UTC)
X-FDA: 84866232234.22.60DAFB1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABCF9140004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:41:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="G8R/N8fq";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781149294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2MXeK/N/OwRrmCK72J9wvshsJl5VGxnckcTpkBJEuXs=;
	b=kEVSZSJKwlxW0vtvFaNmoufyUbg/QTA4Digwk9Vs3RTa79sfNBJ1IxBp+Rg9MpCzm3c6Mw
	5UCrJH/Q0/xnhXR9/Dqoe2WXSyMYl0Fx4tGrdPZSG8UrJ9MZNs48QDcLyLYagccu+VQ2Kb
	YM5muYg1xfTSOYXbdqC8/dOLylu5tm0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="G8R/N8fq";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781149294;
	b=nV1iDGhK9LPWqIXzRLGFhzz6THPGjxY21L9VpTzDjN7GaAbUduUnAe/PbEV7z8yiIWxsXm
	mQcSfWXx+qNhUy22MWfXy5rOHBYPDV251GgrFxoAv/nAAQcEITtUXHlfSMBt1Y1c3qmNXF
	pnF1f3S8i1C9PwFiz1WrXxXKTsqSqBc=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65AJu5lp4146614;
	Thu, 11 Jun 2026 03:41:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2MXeK/N/OwRrmCK72
	J9wvshsJl5VGxnckcTpkBJEuXs=; b=G8R/N8fqkMWE66u9GJT7uFIbSDRyPat82
	slJ09zFfXBBNtWYHBmWuVm+/WmFa8vRaf4luxexPyXr6Ed5Kere+Fh43hsvEnHii
	J34JFLsskfq06czObBRyvQlYq2qlK9PkaKcujtesaggIJ9nCyJW66laFX8FRRFq1
	HykRgOg4qM9a5/qlWlAYp7KkOAiP/bTBd3kQOsrkiHaryGr50FhrM5ukavrLbnkW
	dxo7RvFTxghGJFszCUg1mpGIlylSbLC7Aw7tof0UJR45hsrU5sE01oE+PifTpaez
	yoXNMT2BbYlnvrh9fMq1Tl83/i+R4/MV6ATZRhWr/8r5PQBLOk4nA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4eqe8c18x4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 65B3YlWW027309;
	Thu, 11 Jun 2026 03:41:22 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4eqe0a1f6m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jun 2026 03:41:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 65B3fISd49807692
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jun 2026 03:41:18 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BE9A20043;
	Thu, 11 Jun 2026 03:41:18 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1814620040;
	Thu, 11 Jun 2026 03:41:12 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.39.27.36])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jun 2026 03:41:11 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R . Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Balbir Singh <balbirs@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Alex Sierra <alex.sierra@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sayali Patil <sayalip@linux.ibm.com>, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v3 1/3] selftests/mm: allow PUD-level entries in compound testcase of hmm tests
Date: Thu, 11 Jun 2026 09:11:00 +0530
Message-ID: <20260611034102.1030738-2-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
References: <20260611034102.1030738-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfXxvrgIIXBIsXr
 GR40/jSJwYatx1+BKDG9g9ETTz3msalSpQhdaP6DfDoyKH9FVv0mR+mlLcUZxRCzIhhDgkFtPGj
 BRPKrq6WpJXQ8DAOLwWhili0atAng7Q=
X-Authority-Analysis: v=2.4 cv=AYCB2XXG c=1 sm=1 tr=0 ts=6a2a2e64 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=HVGCuyRmRnZzIc_11p0A:9
X-Proofpoint-GUID: J5UEU4C4qU65iafWaAk5H4F8HPmtDoGR
X-Proofpoint-ORIG-GUID: Eh7ueyuKhYUPUC1uy7GRqEaxyGCuesve
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDAzMiBTYWx0ZWRfX5pcD7aFI/Kon
 4zR8zaRyIjKrWNE0MJk0QtNwmT555dISFh33lo0E4EiFV6sONYMYzvO5G9e04ciGoFU98cyXN7B
 dXEV0wB1F/J+AV2D72jRz5nnMrGQehc8u+jtMhXCMnpXekqI37/5WPxbnoGmProjNVj35fyYjRW
 AeO9Kh52suWxfEv4KURFVEJ+9inSLSMwQfmIHA7kUS28fp2DPpi2/pWeszCUB4s+893NYha9se4
 5jHQI5ysjtTYcrHksoBa9PGooTkxAe4yjqKUFm5BNYmElfDJZErLNwiLy9trFsq0YvI/cgbicpQ
 iZM+nq5kOrF6KhebPwq/ok64MdCpus+6+rQR/mNybpi4qMF9X8AJv32Ietn67Fs8NX8q2+mOeca
 g8CFjW2rfpnpm/8LKEePZUqIjNH47F8Kg9FOx5OEx1NqGQUowQuNADopzLWvA0iWfRc8bRPf0ms
 gN2fQN3zt8vuAdd4WxQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606040000 definitions=main-2606110032
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5krhfrrrr31dsk6kaysr5jdfmo45xtxj
X-Rspamd-Queue-Id: ABCF9140004
X-HE-Tag: 1781149294-592782
X-HE-Meta: U2FsdGVkX1/63EVt1o//4WLNAeNKZkY8avHoPR5gzOpkF8oztDCVZHXaKORI1sMuOiWvFs801mw5Yree0QjWUJReXNwXIO8KL/anhim8zfaVw1hp7PKIcUeamW7kqz1fLajmHtbLkSzCiFY+Bs/reFjMQYz4C5qmViW0Ua/TKJcoMsFIswTi68BmNenXVfES3sfhnDgC3AepCg8H/u3BNw78kf5s6ByhiGU2FMHit7inGJzl3aSYVLx8FajteyuiUKAhRT9z8DY1ubMnO5KEqnwkus4DgN+o6Ld5HhXlUQmsx+O2iQLyESqW/eGzbcTXTIMGvieOHnUuXGRU+UpGDMLypeXjckaN5qOfFdzl064l4bOg1JdEMFVrFMuWazWUxH1TIZgFzhYw4AVBALGyXkKflQuyL5/3QrLSaiCWbnLoagJkQ5eR/Mmp71Gs8SYhJyoIxq6K6B5FJzwNXIBlWYhZQ5WFLW33WJUordPY1/VrEYXwNoq9WSSfV0ZxbAnQOeZl8CdQ21qb/N2MAumFYz6XOJNs0Ru8VRZFLC1/pCOcZGkvLIpLhFF8XsObzipA4ZELyA8TjrTcRMlb/uHUMxShdSDwokh/TvJHt3Ad3OPtVCcZ9wT49xFt8Pv+zpAD9t5GHhbUpVQ0B1B3oXipMyvdL89ebDxeNZBOaD99Ruq5nItD4DYzg/qcWZXb8ySdetb7PuZFFujPcFET6kf55dRED8i/XLgm3YOKq4+7Ef0z3Qzcam1AVsPlMQ22RtTmH5tF7//L0pxl78Atp7oBNs5AgdfOTRQVFEms+OfvPcYJAhLzaKmdAQy/okIxxAlqmLiZ/5kQUNmomw+vtfuTtEXbaH6qeZcpH0nEuCSqyE5bottaT7GejdjXnO+t2ePQ88ERBlvyrJRGY4Xeax5jRlMZ93BtH8KxINmOOprEuIFzy6Y+zD3GK5cVDh1ddBu9qPD68h8YkjJWJdzTa1J
 w0WB4R9Z
 w9i2evu7pMrJgiYvsckESHhMpwZQU9OjAJaGb1gKD9GWmXrtlek0nKcDSjpBzh+nZ+yflcDWxa5DPKTslyFi9H4BHi0Ivat9wSaR95KSMzCrMTI2ebFVzK7gKG8h4hPWoz2Y+iu4KMGMu+yfIEbWka1ad4X89DiHkls2DNOER/odriWfY7iTCKWGEd/x+BorstlZzOXpkUCqoTWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sayali Patil <sayalip@linux.ibm.com>

The HMM compound testcase currently assumes only PMD-level mappings and
fails on systems where default_hugepagesz=1G is set, because the region
is then reported by the device at PUD level.

Determine the mapping level (PMD or PUD) the device reports for the first
page of the range and require every page to match that level exactly via
ASSERT_EQ(). This accepts PUD-level mappings while preserving the
expected/observed protection values printed on failure, and rejects a
fragmented mapping that mixes PMD- and PUD-level entries within the same
range (which a per-page OR check would have let pass).

Fixes: e478425bec93 ("mm/hmm: add tests for hmm_pfn_to_map_order()")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hmm-tests.c | 32 +++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 46e0c8c921c3..deb6a7485650 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1602,8 +1602,8 @@ TEST_F(hmm2, snapshot)
 }
 
 /*
- * Test the hmm_range_fault() HMM_PFN_PMD flag for large pages that
- * should be mapped by a large page table entry.
+ * Test the hmm_range_fault() handling of large pages (PMD or PUD)
+ * that should be mapped by a large page table entry.
  */
 TEST_F(hmm, compound)
 {
@@ -1613,6 +1613,7 @@ TEST_F(hmm, compound)
 	unsigned long default_hsize = default_huge_page_size();
 	int *ptr;
 	unsigned char *m;
+	unsigned char prot;
 	int ret;
 	unsigned long i;
 
@@ -1648,11 +1649,20 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw.  The region is backed by a single huge
+	 * page that the device reports either at PMD or at PUD level depending
+	 * on the configured default hugepage size.  Determine that level from
+	 * the first page and require every page in the range to match it
+	 * exactly, so that a fragmented mapping mixing levels (or a missing
+	 * large-page bit) is still caught and reported with its actual value.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_WRITE |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_WRITE |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	/* Make the region read-only. */
 	ret = mprotect(buffer->ptr, size, PROT_READ);
@@ -1663,11 +1673,17 @@ TEST_F(hmm, compound)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);
 
-	/* Check what the device saw. */
+	/*
+	 * Check what the device saw after mprotect(PROT_READ).  Same
+	 * approach as above: determine the mapping level from the first
+	 * page and require every page to match it exactly.
+	 */
 	m = buffer->mirror;
+	prot = HMM_DMIRROR_PROT_READ |
+	       ((m[0] & HMM_DMIRROR_PROT_PUD) ? HMM_DMIRROR_PROT_PUD :
+						HMM_DMIRROR_PROT_PMD);
 	for (i = 0; i < npages; ++i)
-		ASSERT_EQ(m[i], HMM_DMIRROR_PROT_READ |
-				HMM_DMIRROR_PROT_PMD);
+		ASSERT_EQ(m[i], prot);
 
 	munmap(buffer->ptr, buffer->size);
 	buffer->ptr = NULL;

base-commit: 801c5efa788952095586d076fed1ea4902facff8
-- 
2.54.0


