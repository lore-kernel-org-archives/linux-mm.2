Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B3810BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373496B0092; Fri, 27 Mar 2026 03:17:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB506B00D1; Fri, 27 Mar 2026 03:17:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01AC06B00D4; Fri, 27 Mar 2026 03:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E48D96B00D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:17:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC80C13C3CF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:41 +0000 (UTC)
X-FDA: 84590987922.10.92A1BBC
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4AB961A0005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:17:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MeFWO7Zm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRRRjYlWxAolMESkMa1LtUUUU2Rcp6x5tvyIVsuFgbE=;
	b=s+gFqdXOYv5R3aCj6avS8SkHVv2XECPBhlTodeOAwcfK5h8yt0vgspFAzJrliu+keOzGpy
	HhCjUFKK0AKvkW6/SPYpWChOwBWmm9XAi8Ch1Pv2qohbsqK200N8a/8G/zlRXl1lMj+H+D
	lQsf+tGEVXlMxWzH0ZVniSiUnXKWMyo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595859; a=rsa-sha256;
	cv=none;
	b=ue6XDgGqzuJezMJ6vXpVHgky45EQitp7TCM5NhmYc9uyTnY0nTkDr42syPXNmcyXntnolj
	wb4fUB+92K8pZzVgHWM3StFL3iTzky2kW/V2GFsg1UBP7A7LrBFNmJEayBJhOCMkHs2VNA
	K0Mlu7tYVV7tpwKCXPTEefb4De3ZRhM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=MeFWO7Zm;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QNaHvu3599991;
	Fri, 27 Mar 2026 07:17:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fRRRjYlWxAolMESkM
	a1LtUUUU2Rcp6x5tvyIVsuFgbE=; b=MeFWO7ZmasnjfsQ9JZC+ealf6rAYQGsCt
	jLxSQF0Eb1NY1EVl1pEpk0ED6/qpwO36/ZMi9wjrrUclGD4izc6YldukJKK2+Pfw
	cFXnMb9rmJTYB2+UZ9rDpAg8oNFzSIWY6m1FHLgp1V0p212/38fPOYi8OTB0NEhx
	I0XgxulgS9n+qpBZGwtNxUgP+4xYFmAYEgNTIu08HknvvPR/JL76lF64Eh9tq+n1
	3YSlLuGmKopXiSiy5z9IJxHZYKD6JJoY7Lzyh2kdaGk7fZu1ul7R0nBlwt787Boo
	xdED2Zs2rAdXXxkOqaxTqX60wplI+SGLO1L5hktLkuC64iNh2vUgA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ktv7us2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:33 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R703lh012185;
	Fri, 27 Mar 2026 07:17:32 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkeaa4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:17:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7HUEb42729946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:17:30 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7D10D2004D;
	Fri, 27 Mar 2026 07:17:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4203720043;
	Fri, 27 Mar 2026 07:17:27 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:27 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v3 04/13] selftest/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
Date: Fri, 27 Mar 2026 12:45:58 +0530
Message-ID: <1ac1cac332a692e8d2dd70922bb09c0582340143.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: nClAz5ZwK--x8O9PZsjdr8Q-McgxQ6Fp
X-Authority-Analysis: v=2.4 cv=aMr9aL9m c=1 sm=1 tr=0 ts=69c62f0d cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=VzA434MTnXPm7y74YIgA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA0OSBTYWx0ZWRfX+g1VmU4Asptm
 ANGogRNCkIBLPD3mUxT7GW3ywiXj58+b1eTDUb7FthFEpZgPNfc+AQhpol+hc/9J/B48Bq5UZb2
 740knBX9CusAkQGHpmu06rDOAZcqdQiulVEnUaN2Yic5CEEM/GDUg0YF260s8fDJvhi+wmHT0Oq
 Ws5szmbYeeRI0y9CWCwsKr7NaSmHoHh3mlUbj2xBYtBqYa3sv6UtlNxSdE/a/LAGqu6pM9TsF/C
 jBvN09Fcl/8sYWil9QFNv8+oGBPk486GDaFdsOFBHlXaq2s0sQZhmpZV4Z961HNvND6ejTcWA7z
 Nmi0+MqkiSak6+ROVsme10ab4frCQNPsXoe3ut4VUUpVPM53pclPzNomXrym0DbnzA+FW6pZqOE
 mJil+RdcI9w39xXkFke+CJDFyDFStGw7BR/5sCrbwianQjAFkeaC977yjGJSeJ9YbdjFCTPprvb
 Gzawrg2bQ4uihEP5lIw==
X-Proofpoint-GUID: aWkKOPYTflOioW1srNbD4X76iJFqi4P5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 bulkscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270049
X-Rspamd-Queue-Id: 4AB961A0005
X-Stat-Signature: ciz6xmuh3inbgafreaumzh7319ib5gx8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774595859-829132
X-HE-Meta: U2FsdGVkX1+aJVF1MILWJXiNNEjEmsEEbhmCcuap6azRI22HRf6oCxX0KSLl/CrnEm1UuEsnZ3FEc65JPZL6maCfEdynrJ/xJP0j+HpBoxh1et3v4wCF+e71LBxV6mw0l/SBEbO1RrOMlm534s+60bx3NN3Cw/FDfPfGhUJiKIMYhfALHcvkDphmBTJx+quS8UtQEcEuSTbcfL56zGa/k/+zZT2KQCyeIWOw7x9iU4FPiBojWXNEOIx1g2At5qVgYhJTdKL8ZkVRYHUDgi/xXOANjJJkHpuYcvqaGplvQ1yeGKkzidpuVDH3q+AJMC53QZHn7U0AqtMxnO9MZmCK21FFdUlUHw6Vn5jWN9fmBdCf/xzmpU3NQckMTQ2hm/gIF28lOgH7G01a1MseJzA7abIcWKdG/rJaVd2Anjyr0uiMjXnog8NBdY/sA6P+EO2SiIZV+Nu7Z88OPJqt+FhYQ/Y71JxQuxJ6aa8uwZuyONyP5Bzc+br7VQI+WzTGziF94yy0LWc1N7K2yNAs+hB7XbaOQDZDKXw9yIkiv+OkAuV2Kk+fKcltQkzMPKnn+Xa+oikGb1cMO+piYzRdMXDxvyXDVP1lv0gx4He48Bp2AI5vgkXq9qq1+nGJ+No8JB6AFCPpK45MUyzMTxs014IX8+K2i/V025l6FPA+da3M9wp6gctKSg92ZhLNFBV3GqVkS6/paXHKoAh0O7SViYBN4YuB2rvQuDyXKs95MpG3oG/4KQaso5qoFER3K+wfLxA2Mr1Y3EzfAIkzAMpCogLmsIk69+Ytw2kqJZJIIMlAZUQovA0sPsjZPIgI5uCbkDVGman8OzclS82V1Skw9HbQfU244D51YrFMrHAa3W8+mvAr+RcIhfG5RHYOMvreSlN/ag5qEaqp8n69QO4Ajjs/QOXjOkyC8w8ndhEHSmCtws2xGnRqRQov2XeNs3fpOi6PaBthTwSijQy7labrulY
 Vzi2eGBf
 iODp20cuR64AVYhadObINZYjOZJFgduEXgmcQI9twaB8ruh988nrdrmo1h90yfzvREKb3uw/yOPqRW1YVSVa05KM8iEDEhaXjW6zulCL/cEv2hhrZGkffdhg4WCzmxcHB6vtDrsxIcDDyUpX6REAg4i4KE5u/39IfX1ihtDC9Nhj64+ajfQEVu+AORTQonghbtSin7v4dT9LWmzOa0+P5vcpT/bfNj/7SryyLaFv7J7ZtUN4KGsfMRzmDjesKx7gCkSpXybJ+zq4wSBXIfe6bkUXyGqyani4CPf3isZ7i1GebwVhQ97vfLMMIsRa61ZDawvdaHmjErm7h7vCShdB4l8j/IDKRrIyB4++BJgP9DF7/D3QvQJ91rCYQlwMSDewcKkJPSebYXX7iY7KZmIq/HLjiLlI/AiLIiabf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Launch write_to_hugetlbfs as a separate process and move only its PID
into the target cgroup before waiting for completion. This avoids moving
the test shell itself, prevents unintended charging to the shell, and
ensures hugetlb and memcg accounting is attributed only to the intended
workload.

Add a short delay before the hugetlb allocation to avoid a race where
memory may be charged before the task migration takes effect, which
can lead to incorrect accounting and intermittent test failures.

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
 .../testing/selftests/mm/write_to_hugetlbfs.c |  5 ++-
 2 files changed, 22 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 073a71fa36b4..1e87ac67d43e 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -104,22 +104,17 @@ function assert_with_retry() {
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
@@ -153,18 +148,17 @@ write_hugetlbfs() {
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
+  # Spawn write_to_hugetlbfs in a separate task to ensure correct cgroup accounting
+  ./write_to_hugetlbfs -p "$path" -s "$size" -m 0 -o -d & pid=$!
+  echo "$pid" > "$cg_file"
+  wait "$pid"
   echo
 }
 
@@ -202,21 +196,21 @@ if [[ ! $cgroup2 ]]; then
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
@@ -230,16 +224,16 @@ echo write
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
 
diff --git a/tools/testing/selftests/mm/write_to_hugetlbfs.c b/tools/testing/selftests/mm/write_to_hugetlbfs.c
index ecb5f7619960..6b01b0485bd0 100644
--- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
+++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
@@ -83,7 +83,7 @@ int main(int argc, char **argv)
 	setvbuf(stdout, NULL, _IONBF, 0);
 	self = argv[0];
 
-	while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
+	while ((c = getopt(argc, argv, "s:p:m:owlrnd")) != -1) {
 		switch (c) {
 		case 's':
 			if (sscanf(optarg, "%zu", &size) != 1) {
@@ -118,6 +118,9 @@ int main(int argc, char **argv)
 		case 'n':
 			reserve = 0;
 			break;
+		case 'd':
+			sleep(1);
+			break;
 		default:
 			errno = EINVAL;
 			perror("Invalid arg");
-- 
2.52.0


