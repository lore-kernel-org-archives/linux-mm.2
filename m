Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96375ED7B84
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D75F6B0095; Tue, 14 Apr 2026 04:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03A0F6B0096; Tue, 14 Apr 2026 04:22:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF58F6B0098; Tue, 14 Apr 2026 04:22:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEB106B0095
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:22:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7004C854D6
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:48 +0000 (UTC)
X-FDA: 84656470416.10.349D9CA
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3CC6640002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tCpMLFMx;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPQHHk1G3+UbX9ndrHFxBdN2tzOkHCyO7FB2/8YMMoI=;
	b=nwPPxbTd/NIhHiTqrVPHpMUS0v9pBkdRwKmKmdQ7hoFGN9FLspfybeYdtETmH93gWZO1PW
	JsNOvF8/VjgR6ncI9UFsYUJjmTW/al1Nq3hinXXE5LyYl39fWpIpkVOD0PyfWY0SCzeaqo
	tYbfIaMVrNRxCfM4V5fQqgVUKGOTJIQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154966; a=rsa-sha256;
	cv=none;
	b=or1g11DvVPm5sjwhqe+gvqWI9PI6NFGEN0QGOoIlySxSVzQcOw1eecZIz/m//zetJfSnPt
	qdnYp9BS7nOiua2uhZjNh4qZ/2o8qswvUDKeTpJ1Yzj2xu6nezgOyD3ZoZrWhsgOAu82UM
	pZSZaG3VzRADgmSulyX3NYoC07MN5QM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tCpMLFMx;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLISFG1859895;
	Tue, 14 Apr 2026 08:22:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jPQHHk1G3+UbX9ndr
	HFxBdN2tzOkHCyO7FB2/8YMMoI=; b=tCpMLFMxH9gVBM9BzYWudOnaQpsYUwgpC
	wCd9HpuAU3p3UhVVCbo5AJ9wEMiEvU+wVrkQ/bS2bWa+vJXtqlblFXsBJTUxxEJA
	1OuilwxTFPVnKMf1CRqRwViuBuyHakzXZ07XpMiHnBO39tYdWif7ETh7HSmL3YuU
	5mP3c2qTbPdMIyr/+rqyVALDdAUhh+W0bcQErNSfgFCVzOwHunMPOjB23KUAETI3
	GOHYO4J24G1jTM/POR+ODucphHt3ZEbk+8Q7KFAmqWeDAgUDWr3KJ9JweGUQFGDZ
	hefFojCfqSY4TiXeXa+OM1YIxEYgzrdYMoNNFtx8J3s+No+XQunqQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89p9pds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:37 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E3UBEf015158;
	Tue, 14 Apr 2026 08:22:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0msgrqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:36 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8MX8p51708318
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:33 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4617220043;
	Tue, 14 Apr 2026 08:22:33 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14CC92004B;
	Tue, 14 Apr 2026 08:22:29 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:28 +0000 (GMT)
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
Subject: [PATCH v5 03/14] selftests/mm: restore default nr_hugepages value via EXIT trap in hugetlb_reparenting_test.sh
Date: Tue, 14 Apr 2026 13:51:57 +0530
Message-ID: <e148e4232d4b802795751a7766fcce8884c6e3c7.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: rE0So6VxTRSr-JNZsHW_VohT8S-IPIVv
X-Proofpoint-ORIG-GUID: _c3onDjL4oP2oWKaZ33v_D6t8RMr7XNi
X-Authority-Analysis: v=2.4 cv=WbE8rUhX c=1 sm=1 tr=0 ts=69ddf94e cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=dU9eaedoi-733nYHt2kA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX8pR7Jq7VxSXV
 jwjTDKCAtn3iBPFdJ+IkeLmbXZl8xVgk44EEPCAPHg3DO2+l2i3skRw+p1OBJegKJdc5YMV+Pcf
 E6i5yCnYds+6Nf0k65RMmZjyx2DozJt9a5wGN16v2LHbnsZMIge6XgovPDwN3/dKOR7kkIe3RMH
 8a8ROHDrfAJAoH2GEmFJuFWUGDLShJNuY3fm48rFq6gnXBLixGF4oyViRtFrtBo4grTFDCIN2j7
 iWkDsdJ7ATbOe/6tC8Pivvt1NEeDpFb77HEfffAuitfgf+TzzGHhTkXQFJ51JhK5MOMxTWZgW0S
 1XR5NyAgAUF0Z6chLdEdwJpTM3pLzFAZ6x9InNSmOrq0HUG+5NjDsySPZxiSxP4yQH9tbkdXrDF
 LRuwxfmco0iOQ1ke9fFcGxL6Y9+pmjcCPCjLbrKoCle04cm3OaDoqFvUROCSYGAfnLI1L4ogZo1
 2KVKEdenIi/ASrDFS2A==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 adultscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Queue-Id: 3CC6640002
X-Stat-Signature: n8s7doxsbs5bbns1axkeu88acgdrwabr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776154966-868590
X-HE-Meta: U2FsdGVkX1/ZiUN2f4K4OMa9fvwNPEhXti2bNFhiMHTpHAsMwkM51CVep1eS/g1QSRcrGRice6IUXGafIl85dWFeE1qv6t405Co+PsEMt4qAGmtgSQgwx0Clz+u1XcLTN4m+NUmku2SpqrF1vciBMRDBUmiDadkCfIWhwhVUqZ0gP0gguIFPLMUuCiz4wxCwUD8GmGxuGifOL1iCT/FVu03TMIGA2SuGQiKODCrPYp/N8HG22ohnCWQoVwSfC8i7KmyXSLQmHXmfhkCGcIlxx/DszDHRsp3ohhAJs3HUfVo21zyLgrgP4UCMFhmfHfEhtrtyyaYJY4JSPbF0WU+X2fGWKZ7uWNyKRehcDN78ILcYwbxfRzg+en6nT6ttyIKj6i3iA6TyLKgp3pgnown9OwemkvnmSpgXP5GreJT0ji3dGrzKLkEAKz17M3deMSGyNBz9FXHdbeiDR3qTkMaPWMMNDirNPJFAUOsigwJZ6MG0BLabwu0M0xk3ehRKDdYn/218XTdYUX9bZvdKxdWhePtu7Cjx6N53uUl77yGYc5l0gAzItA2WpMZfE3wWH6m2F5FvjQJn8nfrvt2Bmoz+5P4V1iN5wu5Hq+VFYTeJxSp47+ohIesO1jwpbut80oUAzTUn99wDELpbgMD1I4ZwSG+ms0ownY2wsgWwfjSkRqJY7UTXih+w2s0jLzmytZfjkbG227hamsh3cIvqPC4afe4sLzD11QYqxkdiOBv6NWSnaUMkH268PV1G8uP/BJzQ0BjgUQRbjOQhhiKEq1G462BJGQ0LzbmR/VWA/OSDNf6WSjmAyhXoKpTjAq3iJVylrayztc9BDY6QD9zXDTOlCLto40O5wjKdOHNN/vvCgd+auzChtQ8d4GCgnmbzEsQ+d/5R2PPbzD4QYdPscQ11WkgPJI7EJL0rLNdI0IwvfN+e8E35dZVK6+cCmg3z4/rRIzzxkBu1FDiYs+mENwI
 NUxSwfK4
 Y0ZAw4ilhref7xDel3LBP18kJ2AwHRzD/hFEK41UZ8Pd+NGVYgHzYs5AdOvQtmTpMbA3ci8T4HjCVsnzL4CrfgNC6OtBTTcGsW/Sa4FUH120AGIb7mdpNwojd6YPq56jWFv5mBfOklVYW+CyVoaOBgnuVclY33bjXYEJtAr/ne0lozQebFzl6wneWLP/SpeInrAvFn4YFOgq5BgqnWbJeEDW07ssDa68begfuvQ8FR8MAMQCfyJji5TRA/CSBxnJspPeMVSCQt078vCTM7z5O0mplynMgaO3mfs+CBMIspSMV4wYgk576XDjnZLUQMofdzAb3mmLIOpfHKKr7GetveQ5ToZd3zevV7wGiwQqec0lAO4pNGNKrylwdriALjYrYehnoG9tuziDMw5fhdrj4wO02XhmxJDQAVtJjSgUnOcJf8Osl95plKnrZPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test modifies nr_hugepages during execution and restores it from
cleanup() and again reconfigure it setup, which is invoked multiple
times across test flow. This can lead to repeated
allocation/freeing of hugepages.

With set -e, failures in cleanup (e.g., rmdir/umount) can also
cause early exit before restoring the original value at the end.

Move restoration to a single EXIT trap so the original value is
restored reliably on all exit paths while avoiding repeated churn.

Fixes: 585a9145886a ("selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 0dd31892ff67..7ddb370e1572 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -12,6 +12,8 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT
+
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -56,7 +58,6 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
@@ -240,4 +241,3 @@ if [[ $do_umount ]]; then
   rm -rf $CGROUP_ROOT
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


