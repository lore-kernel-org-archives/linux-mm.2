Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C96FF885A
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 212F66B00A9; Mon,  4 May 2026 04:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4C46B00AA; Mon,  4 May 2026 04:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08D1E6B00AB; Mon,  4 May 2026 04:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA31B6B00A9
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:30:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 838118CDB4
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:30:42 +0000 (UTC)
X-FDA: 84729066324.04.9023B73
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id D3CA54000A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:30:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Oxby+El0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883440; a=rsa-sha256;
	cv=none;
	b=mCFv9KAtEnFLiB9R7BWVF1KzhGktYydJw3dCajhuG7CEaWf19p2DpJVc6HmPseY0ptEoGG
	yX7+qGIQTLRKb35ndy0O1mE3DXeMK4/bt2DfdDhgGGDZTpyn2YxIEwujq9g29xaNugDg1l
	I7oEFb8SH/tcWhYJTOnjwQ5bb0DDibI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Oxby+El0;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udzwYhTawzSzNQvyJpDKM0o+od4uW9MOHNJ2PUBQYQ0=;
	b=nQyGp6qKLg1kaRopLBS+AxgSNUKDoKpkItlZzq3+/fgZD7TdpFD2cbjLi9xqlLtn6UTehS
	fMojZUq6pzIve+sT4DXGk/NERTEFsVA9HknDRC4+C9e0TjYU5KFVGGJOapm8jfdjlReoHS
	CKe0abubA7BhJ7SI5dEwPQ3JdBVhZsM=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64466bKZ347004;
	Mon, 4 May 2026 08:25:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=udzwYhTawzSzNQvyJ
	pDKM0o+od4uW9MOHNJ2PUBQYQ0=; b=Oxby+El0Pp4s0EdXUR98RyUNRIfQOrYy3
	pzQAOx4IkvMRs8b+k0bGwpxPR2JHG6iQSbOZ6g1xiPQb/OnCwDXJF6Fg63O2ez7V
	7++vWf6xXm3Jj/XHMDyGaooUS6169fjQ3BZ79o+dcT9lEJe1stXynOrcNSkWvjcs
	70np21cYPuTtC5GS+3hguKyWtgDeGr8giK50iwJUuM5kJa3tGcRggZGWsY4/92fO
	4Sl6g+6SLJqHQKsJveWdewoisUckO4VELLiUH3dmnpyvCKW0Hya3y+4THTBhkZly
	hGgJpmK2K0XrLzRKbNlyx6VoBPBg4ea5plsV2cJ4pXTamHORhGk8w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4e3rj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:27 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOJx023544;
	Mon, 4 May 2026 08:25:26 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvve8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PMw016974094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:22 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A98B02004B;
	Mon,  4 May 2026 08:25:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7734020040;
	Mon,  4 May 2026 08:25:19 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:19 +0000 (GMT)
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
Subject: [PATCH v6 05/14] selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
Date: Mon,  4 May 2026 13:54:42 +0530
Message-ID: <02b37fe7c40a6be0cd6064c6eb70c83680ce04d9.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX6fwUAXzLn8Wg
 gM1UPeQpfoh9urHFpsMgwjs4Xm7BkcS453CNno8NIrXOxkJ+OOySmtO5UQX8j9KbVM8gSvDLN1G
 seQEfKyNoLtswGJDVmDRC86B9g4+6HSmQLVDzr46Vd8YUoFRgPIGC7l76C7qu0mjLe2Z/W85AV4
 Lep6vVH+nEliWN3TxOlEOecHAfh303VO4eIuocVBw16mrPfHO7mygrVzN+nZZk1g6C/AfKA2ndm
 iqegq6/FvFDqTUPTn8gqPNbVIqqPoAc1ILXHTqrrlBCT/pAdzcd/m92rzVtlD4g11va43p68WLJ
 pBrTtXVsfJ9C0MGL53lIv4opoQcsxgctnYGSA/LMf1Uk8Zea38pMYryufVepKqz18VVRHSKHdCH
 j5Iv2KTX/l7eKej2j4BGMwZP9RgJ6b9tf+K0hCRxH2MtALOsSf0mTPUqyIksFpuOLQ0hxsDbnXL
 NDSPWi0jB+M8UEjr88g==
X-Proofpoint-ORIG-GUID: nsocRD-UhZ-GCoaVCj8_XEVJj2D_UOIq
X-Proofpoint-GUID: cWw37LaJLFRDrRdP35Z8bqy0X4bxkhUz
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f857f8 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=fW5kwVfrStG9UF1TlMAA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605040087
X-Stat-Signature: ae59kaeeppned6dp77xsukjmonfxbtjo
X-Rspam-User: 
X-Rspamd-Queue-Id: D3CA54000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1777883439-77959
X-HE-Meta: U2FsdGVkX1/v7TTL8n7SYrNTrKQNQLPwglQNyRx4dOsD37TC7RZfCtcGUoIH60KqJw5QabWimha8H76yrvPkUjEgKluxTy7508o4g5VvatcaDJc7FoofcN34kmYRSiLMcoZR5xanwT3fbgNimkw/wp2xzStc8Gh3GZoQY9x+K0gLfXN1tDIs5JmA6zgKYBCG8+XrlK2vMNlYp4mNbro8YAsH+YpuQCjcnFbuo1NUabEGLVlKvoAhhB8aCLKQ/kDRhZZVlgJh+cQwCT3Rp7NVHMkQcc+uNrkIeQepG10J4CyR6E9TZGRkt8FLvfbATw5a0DiQ/wVfM1mx2c+hjMa7QeAvKaj0bml2KkHPNl8zQfSvOAdgdj6cKAGp5taxqe9lfgbPCkd5KJB637LORSdmMGBH0kBnV0dYEz9RMGQYNQdQag7jL4Wl+nI4SAl1i9Kcpew7RbsS3XbW5HPcpnyWJXWSdfCWAY7O3wzA2SA1f/Qc6I5uoKzBSE0D0GpiEpxgqFYX0kSc2kDG+d18M6p897W7DX/hxqRzE86QFcseTKOBHezIv69O6b/0u6fP3a26LUxZuJFwrPmknOpIBJ6N3MyUSOeVgF+kE7m3Gr5m8v5LuQnWm8cIVQ0yjbfF+EfgUv6NfrPaPAXvfmd14VdVyZR7mdaXNl/FKdfuh1GfothHwffPAzhok8tp8flohVw9b8QkOn4tUTnYRCI0WZtMxgjtQ8cCJGMqLP810lxYqgkgfMDLbU/Oa8l1cOjaP+rVQIwrIpILzVppldOULUxnmOeolNcxOwhbEUIA5VsQxiM0T5srczGhxXYaHJreYJXYSNR8TkwsA0dGvukk9U9i59LX5LTd6H5/nUUICYAhXpI9NOlW4D3xBlXxkCss2PVF35ie1LWqQM8hujDiqW9g+XRHSvLFLpSAoajnWYUkI+yzd47RRpH1y2cORoPukWt5/o4KyM1/FRPBTa4CuLL
 fqxYSAZv
 JDgHq9/p38fQNkibhNDjdMRnBnk48X/190QnI8yvMP3fdzOsL3tkudTVM0o4ROS6tP+7mcQcq37csG7phzjUr6OTM+2K28rqtqVcG6WP5/Q5EdoPLBKXR8Ad7OK8HaGrzetoNp7ViabirYbZmesUL92NF5pAT+AIdCqWBU7RCjMOIZBSRH9s0yO+nBS5cEmeLQtMDdybxb4GAVhYmXqOuqYArXKYRsBjaKESnsNbmf6gGieksTfywRKluTxrGIaynivpY1Z0MbQSdkzasRCDGveL4EkJNgUBajInwGMFNVlYvLieBs7s9XPv5ZZf2bQaBsCcYX906bl9ob7L/n9H/z403FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test currently moves the calling shell ($$) into the target cgroup
before executing write_to_hugetlbfs. This results in the shell and any
intermediate allocations being charged to the cgroup, introducing noise
and nondeterminism in accounting. It also requires moving the shell back
to the root cgroup after execution.

Spawn a helper process that joins the target cgroup and
exec()'s write_to_hugetlbfs. This ensures that only the workload is
accounted to the cgroup and avoids unintended charging from the shell.

The test currently validates both hugetlb usage and memory.current.
However, memory.current includes internal memcg allocations and
per-CPU batched accounting (MEMCG_CHARGE_BATCH), which are not
synchronized and can vary across systems, leading to
non-deterministic results.

Since hugetlb memory is accounted via hugetlb.<size>.current,
memory.current is not a reliable indicator here. Drop memory.current
checks and rely only on hugetlb controller statistics for stable
and accurate validation.

Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/hugetlb_reparenting_test.sh  | 42 ++++++++-----------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index d724b6e45432..95f517c3bd16 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -105,22 +105,17 @@ function assert_with_retry() {
 }
 
 function assert_state() {
-  local expected_a="$1"
-  local expected_a_hugetlb="$2"
-  local expected_b=""
+  local expected_a_hugetlb="$1"
   local expected_b_hugetlb=""
 
-  if [ ! -z ${3:-} ] && [ ! -z ${4:-} ]; then
-    expected_b="$3"
-    expected_b_hugetlb="$4"
+  if [ ! -z ${2:-} ]; then
+    expected_b_hugetlb="$2"
   fi
 
-  assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
   assert_with_retry \
 	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
-  if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
-    assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
+  if [[ -n "$expected_b_hugetlb" ]]; then
     assert_with_retry \
 	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
@@ -154,18 +149,17 @@ write_hugetlbfs() {
   local size="$3"
 
   if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/$cgroup/cgroup.procs
+    cg_file="$CGROUP_ROOT/$cgroup/cgroup.procs"
   else
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.mems
     echo 0 >$CGROUP_ROOT/$cgroup/cpuset.cpus
-    echo $$ >"$CGROUP_ROOT/$cgroup/tasks"
-  fi
-  ./write_to_hugetlbfs -p "$path" -s "$size" -m 0 -o
-  if [[ $cgroup2 ]]; then
-    echo $$ >$CGROUP_ROOT/cgroup.procs
-  else
-    echo $$ >"$CGROUP_ROOT/tasks"
+    cg_file="$CGROUP_ROOT/$cgroup/tasks"
   fi
+
+  # Spawn helper to join cgroup before exec to ensure correct cgroup accounting
+  bash -c 'echo $$ > "$1"; exec ./write_to_hugetlbfs -p "$2" -s "$3" -m 0 -o' _ \
+	  "$cg_file" "$path" "$size" & pid=$!
+  wait "$pid"
   echo
 }
 
@@ -203,21 +197,21 @@ if [[ ! $cgroup2 ]]; then
   write_hugetlbfs a "$MNT"/test $size
 
   echo Assert memory charged correctly for parent use.
-  assert_state 0 $size 0 0
+  assert_state $size 0
 
   write_hugetlbfs a/b "$MNT"/test2 $size
 
   echo Assert memory charged correctly for child use.
-  assert_state 0 $(($size * 2)) 0 $size
+  assert_state $(($size * 2)) $size
 
   rmdir "$CGROUP_ROOT"/a/b
   echo Assert memory reparent correctly.
-  assert_state 0 $(($size * 2))
+  assert_state $(($size * 2))
 
   rm -rf "$MNT"/*
   umount "$MNT"
   echo Assert memory uncharged correctly.
-  assert_state 0 0
+  assert_state 0
 
   cleanup
 fi
@@ -231,16 +225,16 @@ echo write
 write_hugetlbfs a/b "$MNT"/test2 $size
 
 echo Assert memory charged correctly for child only use.
-assert_state 0 $(($size)) 0 $size
+assert_state $(($size)) $size
 
 rmdir "$CGROUP_ROOT"/a/b
 echo Assert memory reparent correctly.
-assert_state 0 $size
+assert_state $size
 
 rm -rf "$MNT"/*
 umount "$MNT"
 echo Assert memory uncharged correctly.
-assert_state 0 0
+assert_state 0
 
 cleanup
 
-- 
2.52.0


