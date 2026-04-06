Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82E7EEF4ECA
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5486B00AD; Mon,  6 Apr 2026 05:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBCF26B00AF; Mon,  6 Apr 2026 05:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD36B6B00B0; Mon,  6 Apr 2026 05:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE69A6B00AD
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:25:26 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 89E43B84CB
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:26 +0000 (UTC)
X-FDA: 84627597852.26.789E722
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4A2FE20005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R1qgUStS;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSvmaAj6V5ARHCiQk029wh6wu3HanW0BDVcs/Uzd7Cs=;
	b=QoIK9YLPIWfGCregV+t8W9Z4/ulteU1tObqIimQCUip0vwoabhQCPfVcwFFwPYa9g+YirU
	Nna8Ln5q5l2xsH/RIFve1nmTOtBHGVFl0mqgXMTf/yRVgWL0B7CaQC7risODY0bYuRbG8Z
	TFIFQAL7Uu8XbYlQ+iUVeOAYYX6HDrM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467524; a=rsa-sha256;
	cv=none;
	b=rFzFjBDFWkqJR+te3dEXvQDBNoU1S1vMn9FJwaZVUFjZ7erFo7PiIQ2NUnjUjN4FJvzNNI
	m5AoWPPY0zPa9fMRs3tBEya2kPSJQawG0YfGhq3jFCIB91tI72m7jYLoMyZyPdH6/mUClM
	EitCkRsjEVY8RRU/MMcrk7STYTJilBc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R1qgUStS;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf03.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635EQPZC2819363;
	Mon, 6 Apr 2026 09:20:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CSvmaAj6V5ARHCiQk
	029wh6wu3HanW0BDVcs/Uzd7Cs=; b=R1qgUStS8RZ/VnFx9mLUUtsH5+qq1crIO
	pCMadfppUhwV15dRgz/CWGWT4LzSc0Zt6pO2abE+WoBj0QZKpC6bWU0M22vkUcMf
	p+rydwoDZdi2P1TURTA4LMhNlgXSZ5RFe4l+5POR5ohQVfiH4hQd/IP5OjBi2Y3/
	o45x6CLsiqEXRqh6Wd0fl6XfF28m4GKw3qFGkLjCTBLUDNCDIhwPkhw8fl+dkUvp
	Ye5DwitGqJDQTusMKkyJ7yjOFIHa+AE00zbeop/DnzZ+6Ja7Y9vXSp6Z4IldWnZA
	Rgm4F1HYAwC/cI9cVxALrFgEXjSjd1MgKOIvMmW5FORd+ETkpcEbA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dat9rdenx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:14 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365xCrv020514;
	Mon, 6 Apr 2026 09:20:13 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdync2w9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369K90R24183080
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A1B620043;
	Mon,  6 Apr 2026 09:20:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CFBC320040;
	Mon,  6 Apr 2026 09:20:05 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:05 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v4 07/15] selftests/mm: free dynamically allocated PMD-sized buffers in split_huge_page_test
Date: Mon,  6 Apr 2026 14:49:26 +0530
Message-ID: <a61c264c824d140a948db64b2e1036bc4229d163.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: F0fUoqfGsny2Ii1mqseYYZJuov0AU2po
X-Proofpoint-ORIG-GUID: -BTSCnmXb2KuszdYrQuMq8hlBjmqgjBL
X-Authority-Analysis: v=2.4 cv=bLYb4f+Z c=1 sm=1 tr=0 ts=69d37ace cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=-_7HawjV-lAcONoB0f4A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX45R/R63BZB0M
 N4kN9iZYf2Wd+fJiNbYB/PkWr4elj9brr2+1sQtJQE005JXM9XEWNh8HrZd6/GH44+1HWXr+RFK
 yC8rrT2gu8plX5gpd9SW+M9otqvQbpsTuAtjVVjoE1O5exeMMw6PPN8ecQDE3ftUW4Ytx6dqcij
 xrsDCPeYndmpS0ridYE5GalFNlU84cARlDhF7hqh5SQRQpF6PSAMDM4XodRjXBtuYJ/VYFMC82i
 U+tmYte0KC5TJ8erW88J5uAuc2bOcZEqp9Bf6EwghwC9Wgo/DLc3QZfX1P95dqu79ug9c64lr61
 UeFrwgC6PpqsLmj4eCDoZbEO77AZKzAIhPr1FNKd/NW7N+29IsuQVtqJir2JPZca5IvldW0uTOl
 5161Swyfhv8IxppT1By0JxBsyVsQazRa+3uOgJRiww4rH7nrsgKru+X2B2dYf8dX//RYjlc8YN/
 zkmcqyMJNs+0kqWw7Eg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 adultscore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2603050001
 definitions=main-2604060090
X-Rspamd-Queue-Id: 4A2FE20005
X-Stat-Signature: swr6pcbxezewj4qjea948tftx9h75gd6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775467524-302949
X-HE-Meta: U2FsdGVkX1/8XkLi8XRJp2z/tfmZcACkxykbufGH/9/WuUYzZTE4ymJYxKhIci3HDjf2baNRMHdFr2EJacmii9j74FLfO8q6+ipwWG55jI4BJCmtIoXf4MST39LzhPIrA0KcIoSCmcK0O7paqIIl4pJJL5sP/93ktsKfNdsB4Pj0eRtofi9g8AlhvZZ7Yrs3c1fQ1wbsC8Q3DRKrMqrcbEnZYdl65BkjecDc8W1XcekDG/fkRhZIkRUGKVmhh5UIAJXXIYMTqAVo+ioYe6Qgl/mOCStarJXKS1XbSIMH7G1Or3ULgz6YmOiTf7ePwIUi6YUzdnpk4P82MJh+RlNtIezk95xdJZend/SCdKjqNOH5bpSP9R0DVCjCRO0k8hGuD9ffBCyLUudp7tsNhK2Q6dDViDChODKxEaHjJJfyixN1bY7OVDw4TCDmEvmtvGnfOud2CumIxTXgah/d2N7lGl/oaLE194ZZriYACtbbmGYGthRwTp6U4blRPoI1mowE+cw494PvnYpBnMQ0yatRmo8tXGc8kz+rEaqUXRTSGxoADWiRfbNGFXhn+F1zhuC/N/DYwT4EBNO6RcTOnbtyVGdmSgUoN/SQRux/m4Xo7Cf1Kqhf2NlVKVk/s9phhWTFKAWG9L2++Rj9MqD92Lvdc0pPMFmpdJigBwCiA6vV/kl4gPhtHGFCCk2gbq36pHYMTPltXs5+3a54a996KpcdjDl6L1idI1p56LkLlKCm5mPHHSxOAB+fT/S6OSPg8Z3phgUpYW5RYVjavctj2VFm4pmrYUOoQT6jXzB9TPBnMiz9z0zyeK1hDM2lOfFnS+8zadkSOCCicx+mi6OMcsMF5MqzoUeKe3eaYw1vbHdGGOa92xuYNzNstVvw+aDOgRQehIFfRLltJsH6oVlYuXXeTgh8F7Oyf/JfZ9URneWKEFuaOhfQTEqOfw5p3u5AdPT1PJKtvN7TKXs9ruUYZ/V
 wdMfKIUY
 2APIKugNv84rwl/FJFrfzoSgtiWTP6BpZp88CuXdkb9AY4eBhXyw6gGp4MTBjBaS1sgr8IUER9wdp9Bgz61VjAsYS8LLf/OiCudfVjdRF7YyAiY07Qc0eUmzaAiwtbfYIgt3tsVLvnmpMHyqViOHwJRBHVVL1v0UUaOV+09UT5nfwCh1ducoG07/5Y31BRh9kh52DM+ltaOsxzHxWDFC6R0S5eU2DnMP+OzRXpAt6Sq7AgEH9H26+1T+L0zaKdJ9O3SjPIMLLkHj6Tfa1ho58PFj3SKASp0PiRPNbMGMOIIdcPWsVlC0hBU54qIoRVFZYwpvu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dynamically allocated buffers of PMD size for file-backed
THP operations (file_buf1 and file_buf2) were not freed on
the success path and some failure paths. Since the
function is called repeatedly in a loop for each split order,
this can cause significant memory leaks.

On architectures with large PMD sizes, repeated leaks
could exhaust system memory and trigger the OOM killer
during test execution.

Ensure all allocated buffers are freed to maintain
stable repeated test runs.

Fixes: 035a112e5fd5 ("selftests/mm: make file-backed THP split work by writing PMD size data")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/split_huge_page_test.c       | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index 57e8a1c9647a..98319cfaf9a8 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -487,12 +487,15 @@ static void split_file_backed_thp(int order)
 	unsigned long size = 2 * pmd_pagesize;
 	char opts[64];
 	ssize_t num_written, num_read;
-	char *file_buf1, *file_buf2;
+	char *file_buf1 = NULL, *file_buf2 = NULL;
 	uint64_t pgoff_start = 0, pgoff_end = 1024;
 	int i;
 
 	ksft_print_msg("Please enable pr_debug in split_huge_pages_in_file() for more info.\n");
 
+	if (!tmpfs_loc)
+		ksft_exit_fail_msg("mkdtemp failed\n");
+
 	file_buf1 = (char *)malloc(pmd_pagesize);
 	file_buf2 = (char *)malloc(pmd_pagesize);
 
@@ -508,8 +511,10 @@ static void split_file_backed_thp(int order)
 	snprintf(opts, sizeof(opts), "huge=always,size=%lu", size);
 	status = mount("tmpfs", tmpfs_loc, "tmpfs", 0, opts);
 
-	if (status)
-		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
+	if (status) {
+		ksft_print_msg("Unable to create a tmpfs for testing\n");
+		goto out;
+	}
 
 	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
 	if (status >= INPUT_MAX) {
@@ -561,10 +566,13 @@ static void split_file_backed_thp(int order)
 
 	status = umount(tmpfs_loc);
 	if (status) {
-		rmdir(tmpfs_loc);
-		ksft_exit_fail_msg("Unable to umount %s\n", tmpfs_loc);
+		ksft_print_msg("Unable to umount %s\n", tmpfs_loc);
+		goto out;
 	}
 
+	free(file_buf1);
+	free(file_buf2);
+
 	status = rmdir(tmpfs_loc);
 	if (status)
 		ksft_exit_fail_msg("cannot remove tmp dir: %s\n", strerror(errno));
@@ -577,8 +585,10 @@ static void split_file_backed_thp(int order)
 	close(fd);
 cleanup:
 	umount(tmpfs_loc);
-	rmdir(tmpfs_loc);
 out:
+	free(file_buf1);
+	free(file_buf2);
+	rmdir(tmpfs_loc);
 	ksft_exit_fail_msg("Error occurred\n");
 }
 
-- 
2.52.0


