Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBA1F3C27D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7706B008C; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556E06B0092; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BC06B0093; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 304466B008C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:50:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E26B48BF5D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:55 +0000 (UTC)
X-FDA: 84529684470.04.4F57F94
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82948C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:50:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WLBhDIdz;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AD4YswwSBlyZM8CT/6+uVVUNsQJ3n0kUdUVDGfHBlNM=;
	b=Y7hxAM1T29D0Ji6yICelblaPJ+MXLP9mp0bthopzsQQNKG/nhlLqc1RO4WBv7IhWbYmKqa
	J+IDrHNGGlJ8+9U2lZY7GrubeAu6udUm5Cs822OXcQIndK2uWwOmiDLhoGxcQ4Kt1vTg3j
	kkCkyM5xsu3+CjQ0EFZJRNnHR70Q434=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WLBhDIdz;
	spf=pass (imf28.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136253; a=rsa-sha256;
	cv=none;
	b=6MJ9iOrYnCJQJfUU10qEHx4g0IUXkMpy8YbIKh3Txx9sQZvFL6XkLJssMp0rzOm+MwFjrm
	8P8QJ1dum62Kis8ZnTZv++eQQU0C66vaRZA6PoJdDBC1ktXM5v3XaNtwJNHWerwbAky3M9
	7mG6/PDqxqCC55cLZgjjTC6TVx8d6BU=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A99T6i1605875;
	Tue, 10 Mar 2026 09:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AD4YswwSBlyZM8CT/
	6+uVVUNsQJ3n0kUdUVDGfHBlNM=; b=WLBhDIdzdO80EQ3iVn1fjB/93mdBttJfV
	SDVL4Ten8f+Z50lCzcgP9SI9HYr7bSIth396Ps9y4UGVbWbr20GAs+Vmmj47HNHY
	FNv4vrB5fSWXGVhftVFHY5IPAZYUDNxcUNJxCMbbrxFKpKyLxE2mGaYmMjm4qFCZ
	sG9p+MpOcrsxOainaB+k3XzQG26vufNcLZELMeyPe71Jb+ZOGBZWYcbTQQD6ijvC
	idWGz6K9bVImUewFilB66R47i3HKOZObRTdWh7qGvUUy07O9iq0iYLDvwlKZEs7U
	M08VuIxFyv+ZWuVsSBWIoMZbZaRKCP5nnpXa90Jnei+9RkTL8MLPw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcuya9cw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:47 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A6FAn8023022;
	Tue, 10 Mar 2026 09:50:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ct8ng1gh6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:50:46 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9oiHU17301884
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:50:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0FAE12004B;
	Tue, 10 Mar 2026 09:50:44 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 401652004F;
	Tue, 10 Mar 2026 09:50:41 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:50:41 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Liam.Howlett@oracle.com, Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH 04/13] selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
Date: Tue, 10 Mar 2026 15:19:22 +0530
Message-ID: <f3e1599ae0235e0c41bc1033a3d90fb71d2e3cab.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=EK4LElZC c=1 sm=1 tr=0 ts=69afe977 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=xMJXvFkxX-leA7mnJxkA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX4RbQ4n/m2AHh
 HzRxWYVayAdcXxfI3vN4RYgrxw0I4HRsvuSj4hxoA7twlDxWG7ATuNSUCmH7O3HNLQMNfoSqAVZ
 Cpy6/upFfuYWyRjdEderNODDOg0efCCO7wy4rgeukjEL7bSjSrHCrvXzWGU0YfGTColE6huRKhr
 tNTN38RDcdf5V9hVmfVvGcBD13D0kCdbybcUal2qrMnnyZkdkeV2GcantLHYJHAuDRXT4Zu3uEl
 FQPP3+Y6hdp5ZJ5sduBI6QrfnXJKE3QUuk91JfSVHJ2n0YvFPYxVUhBYrpGSd/1hMcGNQlKIStZ
 +tiOTZKqsQ6mBHCJUiHnAB15LOESNi5M8WBZ8GUJnFHmK2av/QsMR9DPJTXLSxdz9MVRAbIH8AA
 zmIsK1E/WZEiaxXanM5T/st9QjrHhcudCmIow8q5kCa2seqN+rf0V2Hvw8cjwRcCvE+5larET02
 61I7NBnmhvXvJ6aPT6A==
X-Proofpoint-GUID: mCP2mb1eWo_shJd4iEsgXWCesxVYrpo2
X-Proofpoint-ORIG-GUID: 5_wfKN4kDDtWIMfGK8yytkqVhKAP8RKh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 suspectscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603100081
X-Rspamd-Queue-Id: 82948C0005
X-Stat-Signature: uf9jp5dh59y6dksjr1jgwsq58bi8sqk3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773136253-616942
X-HE-Meta: U2FsdGVkX193L8v9LP4iFTw4gbWsDSNziNoawjL3aULfn8bbeilAA8inPm2u64ybSbYTTjKStn3oSiqVBxXJh+jLoVynk/ojobsL2PzCCssC1DfiwRKIS07df1iuiJxLzsKqO/iOG7XWcdsP9pbv27LeF2spAFAiS6HxuXMy4zxOUCT3XLovyvSbm8nLrfQTpxTejSj4iMrBwuh65YM5y1sxLfsvjR3PyFxIjFnSiOh1XorLio9O1uz/ZXBTbWAVG0G66oZuVwUeJQdHrqYXbG2Z+TUVj5gVqvZmrLLaayzk3s7vxfbd+s1yKUbQahyWOSpCwESSGXGw8742OdD401DuWNdBzLYH5wtiGN9+S5ybEzBbjCzyD2zR5NkH9/3zwxecM8iQ48EZqFW5UqTS4DDB92Ro6b4/FoN016+NWgOa5rariHYYQs+jw6ykzNvzAPeup2VOmyBjaG3p3eLHGBWguzQZ8P/NoYeZKVBbnL9rK4l+2FVSsM0OIjz51g/JBjlms2oeY6Qtz6f+jFp036mNtYlfPSGTzOOMmhjiYYW4COVcKrJH+vG8KCghh3BjGssbxLV2pg0o4IoBaMpPldhEzum+80UivrqUmmfnbnsmPwsT/1uEbUaoetDBoprZcwMDr3P0HyXzdFW5ZEp1TsHLHCoDpqwrUO7Y7OCfU+GwFt/bA3GWoOe6JZoz2CzDHfOmm4PfL2gv9N+9TlGBlEM3JKWDykv0ad4XFfP8WXp9TQse34ZnOqKiH6zlBzpJJpe6yCaH97mGE7EnsdzGHNwI8fH0Cs2nkOiJnqYimc8lde7CETBUU/PDoK3MAFZZ4ODBMpwcvnlnOwjWJzYmHtDC6EquGn1rTxwZw4Gar6JKKBOVMtXWCqwY6sieBATwgmct2fYXzmMTagX5rDD1AI/1Q55JKBBZEttEwVppRZ7tPb+QsKXRQCaVBH0P0LVW32hdKqhaQunWyRfwCFw
 fai2MiZz
 iPzKO1fGSMNKLmoGwmSaiUCn4kvC7nP4jQQ9PC654El5imMg5V/wfVgxtwulR/Bq3oWm5Gp2y5PXpZndqIEbt/di4ryxTNu8raE9ch5Az8gNLfPzwSAnZyyPvr73o1jvfC7vLhRNTLMWJfy6JsyHMW5M8aajVbw0t6pRoY6Zxu1P7sbWcDlYtNwn3Wcpa6DmlqtUcyAskTB+szwobwfKJc133OS4bKfKzP9xkFYfP3rXW8u8hIYr6Wn30eS6EkAs3qIEHJLsIs/3kFzzn4H+moezdlyWr/N2DhzTDSqesL8oviL4oAvw2OgxLM7bVSAlCPi3M
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

Also increase the assert_with_retry() tolerance from 7MB to 8MB. With
MEMCG_CHARGE_BATCH=64U and a 64K base page size, per-CPU batching can
result in up to 8MB of temporary charge being attributed to the parent.
The previous 7MB threshold could be exceeded, causing false failures;
raise the limit to cover the maximum expected batched charge.

Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/hugetlb_reparenting_test.sh    | 17 ++++++++---------
 tools/testing/selftests/mm/write_to_hugetlbfs.c |  5 ++++-
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 073a71fa36b4..9c79ad69e4c6 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -70,7 +70,7 @@ function cleanup() {
 function assert_with_retry() {
   local actual_path="$1"
   local expected="$2"
-  local tolerance=$((7 * 1024 * 1024))
+  local tolerance=$((8 * 1024 * 1024))
   local timeout=20
   local interval=1
   local start_time
@@ -153,18 +153,17 @@ write_hugetlbfs() {
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


