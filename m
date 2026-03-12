Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34ED3105A596
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7A66B00A1; Thu, 12 Mar 2026 08:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884B56B00A3; Thu, 12 Mar 2026 08:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75DCA6B00A4; Thu, 12 Mar 2026 08:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 614FD6B00A1
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:26:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 280451C1AA
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:27 +0000 (UTC)
X-FDA: 84537334014.01.8E9D774
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id C320110000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="W6RaLG/R";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AD4YswwSBlyZM8CT/6+uVVUNsQJ3n0kUdUVDGfHBlNM=;
	b=xiGv5MCnPjxWAlbyuWew1G3jzSkHPoKzFjKZ/yveEdO6hkCEGNSVRYOHk5vTBJRh6RgtmY
	bBaVOnf6Pv72QTqdnuZqHRukkQog+0c5S2HwjZLDl+ZxHsBb1evI49tMTVYVTt0UC+gvtR
	m2WvrHjRmOR42rRZ4LeVqDsa5fD0+w0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="W6RaLG/R";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318385; a=rsa-sha256;
	cv=none;
	b=WV8QVdO1GFzf1BS4+5GGo/Qs4AFuaF8CQHMFW46nBjW5G+tLBlTXWkWaroOgYlHNAUZenq
	Zr73xqaX0lNOEP0bVVPcLh2pmGR/C3voA6yHVos+livQYD/zJx3sOyKlG+IjJyJFwx2Ow1
	sciRF35YNQGIJo1YDZpKCCBHmLaxkLg=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMWUE82258884;
	Thu, 12 Mar 2026 12:26:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=AD4YswwSBlyZM8CT/
	6+uVVUNsQJ3n0kUdUVDGfHBlNM=; b=W6RaLG/Rx2Luyki6zAwxj6QKMY6zEMVwq
	7adaTRmsZCVHnBF7j6iYDCDFXbesd2PbWiTTO4ALbUMoV+RDFXXX1D7GSpI16Rlm
	XeNjGtci3tKQ4MTXejPE4sNHAOAJC7ksauu0CUOla8Y2tD/1LOA+OEya6kPVUtFJ
	e3HrSKavJSxY6+t7TuNO+lZnyioWWCMLDzfgsuANIyi01Z59r0TVTyWNW7AvHe6Q
	JZ8i+D2EDTqy3ylXp5B1BYZRt3WIGRw4AKhTRpxSre33lYnpQWXQeJouqQUGmIqH
	1h7WN9idnnRR1PgYwPpepSKIJu91Ii9mhJ+htBHH4CDCMWjXufpDw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh92akyc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9WIpN021245;
	Thu, 12 Mar 2026 12:26:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha9j8t8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:17 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQFBa31392302
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BBD62004E;
	Thu, 12 Mar 2026 12:26:15 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 590812004D;
	Thu, 12 Mar 2026 12:26:12 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:12 +0000 (GMT)
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
Subject: [PATCH v2 04/13] selftest/mm: fix cgroup task placement and tolerance in hugetlb_reparenting_test.sh
Date: Thu, 12 Mar 2026 17:55:31 +0530
Message-ID: <3b5b4275fed509e13567bba7471a9130bbfa6841.1773305677.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: ro5ADnmVeDd4DKT-m1CZS_3GlNFzwHim
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfXzVTbF9ADPPvl
 zRrPM0u0Tg+6kTAbg9VcdSYJOkBaEVgbCh5eFc17p2Uz0rUbh1+twHfF0kINCYfxHfIA7rCdDed
 LKKmt9nsg1bZ82YBRsnZt3q8J9FKkMQNcxgrW7tPz7gr0MROZZSz1SDN8T7sxxxWb37enhcRkea
 9OdNknKYtfyVK1+WEATO/W2Fq7Ok6tpccwWZk/BBFIcaRuih2oCt1wiWAFfaH6k84+kpHTIJ4di
 O32GL1rJ4gvS+hNpnkGX1502IfWeFtm0V1hDFcEFsdmfRwO0CdOCjYepI5D2Zq5xYzUEazZtX+M
 b97cZzTN1w0ojjNc2PYMJYgR+TjtdsCPXicODcHjNJ1szgNuxewq7WDwB50L65+kAmimfgJZ0By
 EDhfeqfPyyCzSvvr8lKT904IOTiwp/3Yp0dOdROCWJJgxN4mFyGul3AQzOeliGatZMBBW3dpVPN
 euBSF6rr5B8dSiTHh0w==
X-Proofpoint-GUID: Z1Ci5jts4s5HrO4nDHlWVmCOzcTFcI99
X-Authority-Analysis: v=2.4 cv=XNk9iAhE c=1 sm=1 tr=0 ts=69b2b0eb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=xMJXvFkxX-leA7mnJxkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C320110000E
X-Stat-Signature: 9x5wghhgyrkduwrkbi6omxoa4hfaanqt
X-Rspam-User: 
X-HE-Tag: 1773318384-332369
X-HE-Meta: U2FsdGVkX1+DP8wGieW6af/OPiylv9v/u+0YuGOiNNfZAu2LVxlAtd81bz0FsxHQ5FfgslawrKBU0fJIAIUGIAWJ2KMvpXY7NOoQhUdYPgOY+M3SamTkp5An2oDkYEaLZOS1nXCMZBAYPQeZ8yDF91eLlSU4S1/3Wez+5BGiHVO0KhLsnNiwbtoGzUtPKnKZgH+v6WMo0blt7RAAcZKZerCcmlugnJXzQ5HnWU1++KW5aIFn35grsfd+z0fP/avcnyJdlcDduHNwtp03MFejz9/PtoRgzNd4mrkcEI6mZcHQeKLFalYdNJy48Sa46FX6PN2F9lT4O6F2M5Yp1qnwn4H3yuKTEsK+usmuBSlwP7hfQ7jpZ4SoSihZBZtJjWBDqV45O0KeXmWHu+MXJFcEk/3PloN8134D5oD6jyBY0SIdmv44/4XBKodKnL6VZU+EwiKup7WNSJ9YUHVXDf9DVGlJP6IyyOIBtncEr7YN/p4OsxWohh+7/jKSRdqzB9e+ok73tfxDe8XgnWnbAOKYZ04FUg6WHUhd5+vWsnNWtHuOB+5sXKyOdMY7lL5oMNJiiXPMPcTzza1rTfGZuF8U/u3/2bPu0il6L/BX3OzF7CYb1xJ4fjBCSGcjW7RJ+6RFcWO1VUpMLMXuKWQPSvy/7QEaVYVgmHkaNG+RlBSZrDfeTeSRrkFab6MzD1Z1DlDHx9V+DbOa/dxYiXtIZqXPHtQ6A85d3mDt5i9BrUX/SAz13aGAekPnBN1YtuGLtmt/jgDTNm0JrQtyeKPn5G2gSoly3PWbzjRAvDnEn8ApCOFt/1eHs6m4/2E+5qmmEcAr3YCVFIfR2XyapVq0Kkb4OGGSOODSna9E81vfUQNqsjJfwh48RrewDhJbjW6L8iqw7sDFDfRJ1Ll+VDelPm3j5CuCalU4wyq1HQKoIgn6VqTFO0ikz3v+JYERf+BtbX2iORtcY4/IRDed6lSzvdn
 4SV4Sd4T
 O0iukgBRPweDTv5/6JGaf/ssF/epSayQNZl+EmB33xoJhnvAZpoPIASBHM9iKceeL1QtjKKeBFMKlt7YiENT2xDFZ3eo1SgTT1akzVkCpRPowGH/ewxBQpfRGPsSk1WH9HogYXLUNZTeLlcw+j2yX1/u0UrhxwCNUcqn3rTQh1FRy+VM2HbjibK2N/81RgXjkan9skHADgG/1Zeopqjlt8Yo4RvEzWKNkvXd4y74HOfRc6w3hrudYkurOOUwrG79iyPoAm6eAK2TLC9wigH9i381aakwwoWlH24JFB6qaDHc+M1JURTpZuebqgtQRo+7RWrUt
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


