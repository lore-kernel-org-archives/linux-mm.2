Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF30CA0EFC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26A5D8E0010; Thu, 21 Aug 2025 12:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242728E0001; Thu, 21 Aug 2025 12:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180DA8E0010; Thu, 21 Aug 2025 12:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05D918E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:46:40 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC50F160486
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:46:39 +0000 (UTC)
X-FDA: 83801343318.01.4964850
Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7575910000D
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:46:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=cUSP42xE;
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf05.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755794797; a=rsa-sha256;
	cv=none;
	b=TeBwQiHWxIOpM5XWiBUxzlqH0WqO712mnhE6XFXWCVZRrkVRhnnrcOXVUQINUUeqdhNmu4
	IJbsaccYDzlYttuqWCOZ3h+QsL3wxVAWnPoITi/INpi6lO1jPUq3/JyB/Rg4e7X1XRNUf0
	EcnBSXA2rmwEed0fzKwDZZswSYAHb9w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=hpe.com header.s=pps0720 header.b=cUSP42xE;
	dmarc=pass (policy=reject) header.from=hpe.com;
	spf=pass (imf05.hostedemail.com: domain of kyle.meyer@hpe.com designates 148.163.143.35 as permitted sender) smtp.mailfrom=kyle.meyer@hpe.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fUnaSevVJbXkTgu4uFDDfhr9K+M8eQzc/Tf4Cx+wAoU=;
	b=k812Es2HXmj3wBAdcCzgllLVi/2cs2oI7VnAQBg2o1FJQ8dBXOoM/3FcuvkY4rkqcaYdDR
	hFZ8sb3tU1pIbBF9xWWwh96BhvGrrnMg/4igIhokYKSPWXqE3r/J+nFAb+fWciaBMxM3YU
	scDfWtNcak/sFQWP861GaeK3CsXxS60=
Received: from pps.filterd (m0150245.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDWkwk032561;
	Thu, 21 Aug 2025 16:46:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pps0720; bh=fUnaSevVJbXkTgu4uFDDfhr9K+M8eQzc/Tf4C
	x+wAoU=; b=cUSP42xEqwFjRXaOMpKctocd+FI7jJym7/qx2Uadv26jo5Q4yUXjV
	AsyJSMQWLlDO7HzEdRP3I42oW4s0nYBXY+ctcJ7s11drqtQYipv5y7duHeZu7XKs
	unKW+CFDAvPukAXl1U0uAqhbActnEZOZDVTcPatTeAjBWwsPZiIb1kLISFughU3R
	CjBJ668cRGGHcVdxIdo6BRI2tnDcIe2AhyiN5wRz6iiK7SKSDDvGuIPZymUha5ML
	6TvQ0H2Ig7KolGJ8eQc/rker6LOGry/zRR3LITfrGepxzHz0AMn64e+ZMdYflBvq
	XgO0nPOUu9BOM+qxkFboUEs30OyWbmd3A==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 48nyktcgks-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 Aug 2025 16:46:03 +0000 (GMT)
Received: from p1lg14885.dc01.its.hpecorp.net (unknown [10.119.18.236])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id BE8681317E;
	Thu, 21 Aug 2025 16:46:01 +0000 (UTC)
Received: from dog.eag.rdlabs.hpecorp.net (unknown [16.231.227.36])
	by p1lg14885.dc01.its.hpecorp.net (Postfix) with ESMTP id 227BB806495;
	Thu, 21 Aug 2025 16:46:00 +0000 (UTC)
Received: by dog.eag.rdlabs.hpecorp.net (Postfix, from userid 48777)
	id 9F9EF300A7CBA; Thu, 21 Aug 2025 11:45:59 -0500 (CDT)
From: Kyle Meyer <kyle.meyer@hpe.com>
To: akpm@linux-foundation.org, david@redhat.com, tony.luck@intel.com,
        bp@alien8.de, linmiaohe@huawei.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
        rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        nao.horiguchi@gmail.com, jane.chu@oracle.com, osalvador@suse.de,
        Kyle Meyer <kyle.meyer@hpe.com>
Subject: [PATCH] mm/memory-failure: Do not call action_result() on already poisoned pages
Date: Thu, 21 Aug 2025 11:44:45 -0500
Message-Id: <20250821164445.14467-1-kyle.meyer@hpe.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIxMDEzNyBTYWx0ZWRfX86dp1AjTaBTA
 vsn7i9VNlVA9yRA8b1YVFhpaYrGPhPzIQnvytlwiWnECD4mOv0sHCsfY5+GIV3yx+22gXDxtCFK
 9ApcUlDdssy1HrKYc99CdopWpiVNCqmulZYWZKxul1+FKILvLh0hfK1BYn7MoNLyOyR+PZIQDvm
 jXEgsc6qhrDYk37vncCTI4lEe/jgoliJYj5lWyZAV/OMBhA4qg2JQArmvHrvgFHUFr7H0x3oHCt
 YUoBfLltvwhhbourVvz8njeslmAZmHq4j5HL/ex3VW6IaI7FrGv1wIgCtrrriBVDKtR4A9r98NG
 8cNsldJ193kA4Slsbt9IgR7Qaxc+tQFOEvRiyXMnfl22ElvT5l1aYLZzELtzLSJDRZveQwUAKfG
 kXDcqAKzjv+K2T0tp1VvQ2vghQ9WN7pawdsz1PhGvdyPlj1dTGgCarVktK+Pdt+x9cYfEyyh
X-Authority-Analysis: v=2.4 cv=Ke2LcQYD c=1 sm=1 tr=0 ts=68a74d4b cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=2OwXVqhp2XgA:10 a=MvuuwTCpAAAA:8 a=t3O-YQAXfeJ1jdMRbXsA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: Q9Y7qVEh7pnZNRpL-0IN5rxEWREnYZUd
X-Proofpoint-GUID: Q9Y7qVEh7pnZNRpL-0IN5rxEWREnYZUd
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 phishscore=0 clxscore=1011 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2508110000 definitions=main-2508210137
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 7575910000D
X-Stat-Signature: yodn71pj4ah8t37jbt64dttiw8oay4eo
X-HE-Tag: 1755794794-304873
X-HE-Meta: U2FsdGVkX1+NhXKmBFqsDIJBo5md9H10ExMwuar0ukro5Ahv8v4tQ9bwptifS9jPgzunZ2Y0TVTgyfy7zpg0F8M2Nym7ry+eN6MZRf935YvaBIZLQphK6sVFwi0/Pa70iEg+zGUWDjAw9sxhaKZSaLipJf5VuNiiHvVOPcoq3l3Rxo4U6DdtnivHekg74rdpEa3f0KJMG/U8Qww532wuGYimx4oXcdwaZejeyeGyy9zXgMS+G0tZHekwmeXA3mBWuVKeKBaU+mm5XpnGWo+k+PdLy83l2sCewhhw6ePMAWcVU+yQaujYTnOZ4AIXBgp/64m7I0fa6lHuIPkcMFnm34xnh7Qk3dj33PlptLJzgt7mvN4zYxHVVdEPWSGS2IiS4EtizWNUhdFyToUSF75XOkXJEspcB4Dhe20GxY6SUA7FzmvJ4wnH1fEL91g3MAzTxTCNYRv4I+AhHBrWEHN0V99EU+QM+5KXZ2f4UK5DBD6NOVSKCWtStVcnKVrZnkqyHeKAb9zKbQNUILRcHgb37Kk7lfx2VnUKMNZPXvWQKYtFim56r2NRYdC4Kym0vszzYdU/GTSz2k9k4KfG80f3cBZUa4Ljz3d7YpgkIQ9OREvfsT1oUa0420WdZU4vpZVAT6CSrIrc5vG6hOMSC5p3ZJ1cx7p9qeSyuLTNzFRO7RDEjnlkJ0ac825eAUB0wzLieC0sFeiNrlpYRV/pVfxleg4r6ZCprtevX1thPWXxmLNKRv7v2wxav6RDOcqkCbK0gxrdCpJOtIojdjyOyUqZyW6hnmpTH0wluqFEZdilLmqTIHlkJC7JsrY1QI9y8nZYwdJ9pqd2y+q0c1C6wg3whxYel905nsz8OWbNv0JCE/vuT9zgeIjwUy3UFEiUvi11M2K+dWtE8kvv3seDfuyzxP9pjGH7XYZ4shwnADcIM1gODCnOjrDmUucRxd9kXnpoDpn9TyKC6yOX2RUM0pH
 pSEfAcgo
 o2oyYcmgBRUEk8QUBpspPBS8GdGXjKf1OuesC/dgBW6BwRdkJPSyVAzd3V/eM/bTzikZsehK1qLx8VWYr6zUE8xjBV1OH+V19bmGgP+Tz7RmH6ratUhQs1ML3if5SIhNoaClUr9ArZ2q4kdJKqT0PIXfLUV7nGsICQjab6hK/0Qd6OZWI/xed0SJKpDq2tcNqdxvqnOgnN7ZLoZ9B2JNHJcNnaHHot6u4ls8m30dp9lt6xdDxqpxhcGbbRefilQiKcfw3w7w32xZSUmkyACOtgGbda9Q4CnHN2sikCTiDiF3+eJK4q2VDB8GvjIHZp5JsTIv5no2SCyZHN7c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Calling action_result() on already poisoned pages causes issues:

* The amount of hardware corrupted memory is incorrectly incremented.
* NUMA node memory failure statistics are incorrectly updated.
* Redundant "already poisoned" messages are printed.

Do not call action_result() on already poisoned pages and drop unused
MF_MSG_ALREADY_POISONED.

Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
---
 include/linux/mm.h      | 1 -
 include/ras/ras_event.h | 1 -
 mm/memory-failure.c     | 3 ---
 3 files changed, 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..09ce81ef7afc 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4005,7 +4005,6 @@ enum mf_action_page_type {
 	MF_MSG_BUDDY,
 	MF_MSG_DAX,
 	MF_MSG_UNSPLIT_THP,
-	MF_MSG_ALREADY_POISONED,
 	MF_MSG_UNKNOWN,
 };
 
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index c8cd0f00c845..f62a52f5bd81 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -374,7 +374,6 @@ TRACE_EVENT(aer_event,
 	EM ( MF_MSG_BUDDY, "free buddy page" )				\
 	EM ( MF_MSG_DAX, "dax page" )					\
 	EM ( MF_MSG_UNSPLIT_THP, "unsplit thp" )			\
-	EM ( MF_MSG_ALREADY_POISONED, "already poisoned" )		\
 	EMe ( MF_MSG_UNKNOWN, "unknown page" )
 
 /*
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index e2e685b971bb..7839ec83bc1d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -948,7 +948,6 @@ static const char * const action_page_types[] = {
 	[MF_MSG_BUDDY]			= "free buddy page",
 	[MF_MSG_DAX]			= "dax page",
 	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
-	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
 	[MF_MSG_UNKNOWN]		= "unknown page",
 };
 
@@ -2090,7 +2089,6 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
 		if (flags & MF_ACTION_REQUIRED) {
 			folio = page_folio(p);
 			res = kill_accessing_process(current, folio_pfn(folio), flags);
-			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		}
 		return res;
 	} else if (res == -EBUSY) {
@@ -2283,7 +2281,6 @@ int memory_failure(unsigned long pfn, int flags)
 			res = kill_accessing_process(current, pfn, flags);
 		if (flags & MF_COUNT_INCREASED)
 			put_page(p);
-		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
 		goto unlock_mutex;
 	}
 
-- 
2.50.1


