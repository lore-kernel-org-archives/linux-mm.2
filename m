Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0303CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3D3D8E000E; Tue, 19 Aug 2025 21:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEDB88E0001; Tue, 19 Aug 2025 21:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB5878E000E; Tue, 19 Aug 2025 21:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A50A68E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7061C1602C8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:50 +0000 (UTC)
X-FDA: 83795343660.25.44F5214
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F28640002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bOYPhJ4w;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bF0MGWFgVsHJanG/wrNJY+QDnxV4S15/3lSafFI64CE=;
	b=R2w+roofOADiy+DmCgLRQYNw3KlwQO8rU/8k9midFmWwN6kJGJOcAJ2P+woGgFS8ZYKUzA
	NP51J5kkKQFtdSoiaq4juIyv79NuOpbQpDG56PrL6MlQmPeWMYeM3PT0zuEpuhqlrrdyU/
	Rz8jt9hkqMZFdZ8X5Iu0voH8fOVIZIo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bOYPhJ4w;
	spf=pass (imf11.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651948; a=rsa-sha256;
	cv=none;
	b=KlVZMUSy565PVp9EvM+phKn/7CjU8LUnQDrheHi4n0tqkJ4YjH9Px3pRSrhUC6HRzxcC8l
	T7Vm27zdyGduKDswrjVTA/RFobCWYJFiSN39RZKGIiEwcyb5XhbzZx0S2uczKlpuNTbLUe
	jv+yciaLDjqwWA0flho3lUV3mc1sUzY=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLBnPd004722;
	Wed, 20 Aug 2025 01:05:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=bF0MG
	WFgVsHJanG/wrNJY+QDnxV4S15/3lSafFI64CE=; b=bOYPhJ4wSBJ3+LEczXzz2
	LjzyGjAu7Aw3Gke1934IsvA7v9qpf14b3z/96Zys+wT16tpp2cS9cB5IdTQsxXV0
	ykw5MIEQ9x0wPMootWonN8E1tm68NzSwgrbXNKTf2bF109gL1+Mfm2NmyILAd+1W
	gYePZd0tlcJzUX7gALfyxk5lIZ3ZKV+h3kyjzlJK+cV0n2gQxwe5CZ119oVuTjIZ
	xTVTft4VUOX8qP0Re6Aw77CaVEc9f/xBFGhV4qncpEFZdVyb8OmzYYIfoGPPonJj
	WnWk+9yLE6wsikWSidseeGDA10bA10XaxDrxDRHTvWz3VFVbYH6N+y/Nq6tT59Hb
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqr8be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JN39ew007104;
	Wed, 20 Aug 2025 01:05:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q2acd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:05:23 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14Ndm011685;
	Wed, 20 Aug 2025 01:05:22 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-23;
	Wed, 20 Aug 2025 01:05:22 +0000
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
Subject: [PATCH v3 22/22] mm/mshare: charge fault handling allocations to the mshare owner
Date: Tue, 19 Aug 2025 18:04:15 -0700
Message-ID: <20250820010415.699353-23-anthony.yznaga@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfX8TOJSK7gz1xM
 dGsozF7c7go5Ju4nHoshqHdFX1NHqMX18M//9z4kt8ozI/FP8YlrREkk3LCNpCOE025+N3Td/09
 djZcCpnIvQl2nVR4R4sqbQTm+kGb1ICe2+vC1DHrbJeUX3muutedLqFYN9Ec6rynDCjB9393Y3x
 0fw8hMivk6YuhOK7pJ9mpVSVb5vIHdCOEttnWoZNihWgjHB9w94Muo/WyE5RMO3bzsGwt9sWL6J
 qlwbakYBsxoUdiRqsJ0c5cbZzNbZaFQEi8pnlusV+mJVXwrHIQwPgV1ExsU+X/iZU4xg+HnGKsk
 L/pEE5/A0aZWhPYysUqEPkrj0/AGS35RPuuYAV2bAvm/jbc+yS5Ymih5NdkRuaETtIyM/+Oypv0
 E/xDksS0eZDii/keOaR1WsMBzEaavw==
X-Proofpoint-ORIG-GUID: _RaWCOjm3DSPcPOQ-pG-pfNqWr3YDQob
X-Proofpoint-GUID: _RaWCOjm3DSPcPOQ-pG-pfNqWr3YDQob
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a51f54 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=cleBvi95ZpQhKa3SDf4A:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6F28640002
X-Stat-Signature: dip944ab35s4rb3pmohii4ruwkaq4rpr
X-Rspam-User: 
X-HE-Tag: 1755651948-24696
X-HE-Meta: U2FsdGVkX1+xmAhOG2DzcPckHZA/2VYEF4Q2MABkWavPhz9JcmtSR7+/cH/CxTwf19rrHPN8brOK0CY3QJE23OzzwWdFAXTvJ7FUNxVJKW5x0ofw9t+I7RAn1Rhl6SfJfc22HV7Q3XvwpjeDEUxkrmv51K84eBWnrYwwvTd15OKVddgm/ydg1oieO72n/lzEUBc6e+U8+3goQUZ9oCF+jwxY4+ksc6AsIDzSCze2UMqKQ+lNAzBNurpW8vfTR4giKjkIYhMnOHRDkjgHdmoVqsLmCO1IJ/0HisjVoJkzXm46gjV2AuFmJgyL7rR8X3HawnfOBh2FSRsrDDnoNLLIy10sO6ArG5cqX2oUXnH9Gh5/fXSLECXbiUvwZB6apjJWz5NgDTHAq7Dgjjsd2ivFj+DVvze1aiRwuuI9uohZHRBu5exSvokqucpBBPP6LpscpD9bok7LpQnucgn4BERGWBTP8dKGZVqrULXCX4BbaOcg9ujwGrQCXtQ8qzENOICX5MaskzqDGIBgM+56uqLzcv8L8QJfhdO+WMzL0G6UHOCVTUrQ8ecNDFav6qNIet3cegXVUHZTxpiV8bJI1JCc2McIfrIIB9gOJoIUBvwIV5Ig0ekCpi1mxA2g0fTXbhVCMt735giMyX5mPsYtWvHgTFhK3K6M/M/0sWz5DK8lL8kJC3ny+eMMuDLhnh0zbws6F9eFj4ka4X1ooNXr2amYGjWHr4+z2dvJ6lSLKpuw9cGIQSkrSyRDForVGfjQ4WL7MlprBXy9IjYLMjipA9nVpxjd1dPcN9y1RgYp9VJyVS5SPFyx0C0wN+FsbTOtQ1oZoe8hmkwosryLZziVjik5z/udj5ehyfZ8A1XOnE0M51nKz5cpdH5CsXSBBjMiQOcqiJ8k+rnAGB8Sn6wGUkwH/wcA7PFGzi4zVwHBWtf+9UHeQUMR7XoqztPp/4xaWQFpfvn4RyEUFg0hqDfLQt+
 Z0yOr7bU
 yCE/QdHydWcEpPv/5e6X2IXMGxQoRr48CXg/H8u0frNykmS+hUdfXvaFjLpzOlmVAR/NHW819MFAThm9XcjxhiiC7oG9LXnyJ5PzU9CIZRzx9oGKZNeJ6m9PdZlhzfuQ/MSD7MiOFFfUXuZ+Z65+Nn3YPbSs6vxxa/TTwcwtF9U+N+Tx/EdyJdXX+HDZRBDTiXKSG/c18ZFsM+aCVBDpzSmyPkn0mO7RIo+Yd9cnSPiQpOzl16ljJQkVBZVMIDbzxaL3XiPDMfEvklKs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When handling a fault in an mshare range, redirect charges for page
tables and other allocations to the mshare owner rather than the
current task.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 mm/memory.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 177eb53475cb..127db0b9932c 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6468,9 +6468,17 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	struct mm_struct *mm = vma->vm_mm;
 	vm_fault_t ret;
 	bool is_droppable;
+	bool is_mshare = mm_flags_test(MMF_MSHARE, mm);
+	struct mem_cgroup *mshare_memcg;
+	struct mem_cgroup *memcg;
 
 	__set_current_state(TASK_RUNNING);
 
+	if (unlikely(is_mshare)) {
+		mshare_memcg = get_mem_cgroup_from_mm(vma->vm_mm);
+		memcg = set_active_memcg(mshare_memcg);
+	}
+
 	ret = sanitize_fault_flags(vma, &flags);
 	if (ret)
 		goto out;
@@ -6530,6 +6538,11 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 out:
 	mm_account_fault(mm, regs, address, flags, ret);
 
+	if (unlikely(is_mshare)) {
+		set_active_memcg(memcg);
+		mem_cgroup_put(mshare_memcg);
+	}
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(handle_mm_fault);
-- 
2.47.1


