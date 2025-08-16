Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7372ACA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117966B0485; Sat, 16 Aug 2025 00:03:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFDA6B0486; Sat, 16 Aug 2025 00:03:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 005066B0487; Sat, 16 Aug 2025 00:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6C5E6B0485
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:03:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA2C4B8B46
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:03:05 +0000 (UTC)
X-FDA: 83781275130.17.827E87A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E98E40005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:03:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j9Td8sW2;
	spf=pass (imf12.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PMcQ23ZFIrS4lFSR/NDkPpS8Eu4jYkAwRz0zhZuUv6k=;
	b=CYJ4DDv8o4qdYnQ1kWP9dOWwzPikImw4xLGpawXgSqw7d3Asx+xrcVbZWQxivCBtIbkPjz
	r3igGnOcfPBe+1Mr87+sgDr1x/jzFbczSKxnSGVPGouU0Qdm9uNMhoEnoX5PBZeJF6UYnj
	rnTs6jY7AeOhDJEsfbV6plx5ELeJjn8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=j9Td8sW2;
	spf=pass (imf12.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316983; a=rsa-sha256;
	cv=none;
	b=u6yc3c6o+XQW8Q5EAda9V8lFiQ/HeCeR9rz8jH1kVYqnuF/6qBHLyN8VEzJuRgAGC+9DCY
	8Lp3/P6xc0gO0VKxk3tMUJHEareGvtGvaGAZS2EKMw3CErdlRKJ1fl85YDNtqkqFDS+wFY
	MWCpxL+Ivtt/clOvoCQpi5WdYx6AoCU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G304XN027324;
	Sat, 16 Aug 2025 04:02:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=PMcQ23ZFIrS4lFSR/
	NDkPpS8Eu4jYkAwRz0zhZuUv6k=; b=j9Td8sW2STyOO/pbDydh8RUjN5ieShndq
	VG+a+Rq3OgI0/GBFva3YHlrJaAv7B5SPDl8KyUvI20BkonUdXEKSf3lMlGxLG2PC
	oMrgKgFh8OT4kqcoGZr9oXfURLdTgKRjJtrzhjkEkG52yq7Afj9KqPanH6X2pUGv
	5DmVqyaqtoABEKJed83ay+Lj4hGJe4kEFBM6MDAAqA110Ke2ffKGKLs37D9U1UcY
	sPcwgdXSfUyx+IC/fR5bT4Uo7d7aX6w+FpXLkaCO9LrKqdPnf+FNfHQY2h7k3BCM
	ZL+5dBFm97XxGaPFEErBcmr7ok3pcUbr+7ODtLbzbWVmdCC+83xbw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhnxr46j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:58 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G42vcS004763;
	Sat, 16 Aug 2025 04:02:57 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhnxr46e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G1TB5j020615;
	Sat, 16 Aug 2025 04:02:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48ehnqbrv4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:02:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G42qLp49873340
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:02:52 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 225C920043;
	Sat, 16 Aug 2025 04:02:52 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04A7420040;
	Sat, 16 Aug 2025 04:02:41 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:02:40 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 7/7] selftests/mm: skip hugepage-mremap test if userfaultfd unavailable
Date: Sat, 16 Aug 2025 09:31:13 +0530
Message-ID: <20250816040113.760010-8-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbqJzJ55 c=1 sm=1 tr=0 ts=68a002f2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=Ikd4Dj_1AAAA:8
 a=9-ECl0np4EkliaZUNCgA:9
X-Proofpoint-ORIG-GUID: DsoJurbOVixvCwG9hjw2GXYFWuwatWgd
X-Proofpoint-GUID: nGAL8WzpqwAdoD_KGG-f6QOBx5h3cC75
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfX7wdgCsGcsdTN
 Y3TlhNndkcy962LcryatPdwy4CAd45T+YeL7jbdV2QSxLkMIImqqkQP3LET3Mbmh2so6bemJigL
 xyV/zceGJTnBYfffdQMiAc6qbHAVvMXBEW389ndib7IeVFNsdBCRVNsmUSReml2suKuwuZmzDzR
 vuj2nuMstzWIYhiuEwOSv33eJw4HavKdNfEkEavIhprAgbdBWSptXiO5cKabtue7JlJOMId8ygd
 FdJ3NYLcqfNijYJ/5/jj5jNY+WK9AlmqoPdGvjZ3wmPu1jTW5XsZWVloaFlS/mEon16h592mazQ
 MXlMR/IeY1GbRy6SyjMkZw7H9MzaQ88C0RQYz2+Z7fNrzwWDfp8fAferO4U6ZYGAk47IyDQ2QsQ
 LQxUg0WK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6E98E40005
X-Stat-Signature: m9zfj86eu8gitzfymtrbsbbgijtdu3n9
X-Rspam-User: 
X-HE-Tag: 1755316983-564051
X-HE-Meta: U2FsdGVkX1+tmhm4vAKfz0C4UozwvJ+T/nv7EwoB04Dopzq9oCfy2+qImAAs/QRAZpKiYpXcpOK8SPNRIoRUzQ2dDxzHwg/aQIVQvH10nc/TBWT+BdOXMaY6hOHcCzp7447n4amPai58zUAndrs6gX6u5O7wk1db9jncSPR0XGEtp1cvI1kip6A5TXYYJhx6YxOBkmKHbajOGl3LXAzr5KvgZBwHt77RgnX3/Ce6xRM5t7VNmt1+joCNtYsAxK1s9ISE3S7TApC4GLZs197eVMXHo/aQcLiBqsqTDHXY5pbWidI7ALsHEnIMICZogdCKdLHkOsdStYcd6skllXKqXTKQxUhOfaAV75GTwM4xVtlbTB6MEGp+vewawJhMGIkEEAdeA5Gj0y5LdO5r+Po6cfE7I4V1gqe7eIUBz4GUBh3jbch1Zat4yHOUqF2WTA+J4KYqNtAiP9mjDeaVrqlyQlS+eGoEF+49nwnN/3zoy25BHH6cnLWMACNGNp2si2S4fcNKob/Pjj+5N09O4DATd0XG8VhNAOvFgbPTki91NXogmcNr9OPt9WfhGCqR0RjXkwRiDmzTqbomt5Zm5htj71aFRFWRRBy8oisZUm7ph2CpN290Q8qcN23vPXfxEJVPLsC84YomgXU/YwjqCO7LPIOxiCeBmyAbZDZFGumFZk8Mnb2W6ZcR4+Q496oubtgGIHDqUPbqb5EDu3DrebTdkoSECb8BY3PcOmTsWv3yUClEtrcqdm7mQd1B1+c6fxAK/zqnhCdtVRjA5F3m+HXr0rlVWMav7PLUzysFKCwurm6YTjcW9HVe7fIzK3WfiuW4c20Qa/IlY/94TDVHGC86bf41B0WYb/mUChqISD65ntc+LDJOuc1PIZ228wtkFjb6d0D95Kl0yc9udHJab8U8fxD7XhpJU0DkFzsuWTkvHDgah9lNtOG6dX4h86WMJT0s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gracefully skip test if userfaultfd is not supported (ENOSYS) or not
permitted (EPERM), instead of failing.  This avoids misleading failures
with clear skip messages.

--------------
Before Patch
--------------
~ running ./hugepage-mremap
...
~ Bail out! userfaultfd: Function not implemented
~ Planned tests != run tests (1 != 0)
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
~ [FAIL]
not ok 4 hugepage-mremap # exit=1

--------------
After Patch
--------------
~ running ./hugepage-mremap
...
~ ok 2 # SKIP userfaultfd is not supported/not enabled.
~ 1 skipped test(s) detected.
~ Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0
~ [SKIP]
ok 4 hugepage-mremap # SKIP

Co-developed-by: Donet Tom <donettom@linux.ibm.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
 tools/testing/selftests/mm/hugepage-mremap.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
index c463d1c09c9b..2bd1dac75c3f 100644
--- a/tools/testing/selftests/mm/hugepage-mremap.c
+++ b/tools/testing/selftests/mm/hugepage-mremap.c
@@ -65,10 +65,20 @@ static void register_region_with_uffd(char *addr, size_t len)
 	struct uffdio_api uffdio_api;
 
 	/* Create and enable userfaultfd object. */
-
 	uffd = syscall(__NR_userfaultfd, O_CLOEXEC | O_NONBLOCK);
-	if (uffd == -1)
-		ksft_exit_fail_msg("userfaultfd: %s\n", strerror(errno));
+	if (uffd == -1) {
+		switch (errno) {
+		case EPERM:
+			ksft_exit_skip("Insufficient permissions, try running as root.\n");
+			break;
+		case ENOSYS:
+			ksft_exit_skip("userfaultfd is not supported/not enabled.\n");
+			break;
+		default:
+			ksft_exit_fail_msg("userfaultfd failed with %s\n", strerror(errno));
+			break;
+		}
+	}
 
 	uffdio_api.api = UFFD_API;
 	uffdio_api.features = 0;
-- 
2.47.1


