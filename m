Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A475EEF4EC9
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:25:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5846B00A9; Mon,  6 Apr 2026 05:25:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176B76B00AD; Mon,  6 Apr 2026 05:25:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08CC36B00AF; Mon,  6 Apr 2026 05:25:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF8AD6B00A9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:25:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B03FB140354
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:20 +0000 (UTC)
X-FDA: 84627597600.23.2D42742
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf09.hostedemail.com (Postfix) with ESMTP id 637BF140007
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:25:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nWMmeEwC;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=02TqPKdDkja2MpVuMCfvhJ458T3TTNRCHN+YZuDZHV4=;
	b=S2HX5VC8yYUA8U9BxFDRIUdCrqEJD+NRPPS0HT0h2Wzt4/vKHoDqOefFYqXYXxImAJjfAX
	pWaZr2c4gPT4oTIJYxRUgp5DRZ88vnEfCctdzv43uxhGTTkycjolh5JoWpbeYNMDfKaG1R
	U5wN25wlUHIUk7cxUY3fymYam/ZIP/c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467518; a=rsa-sha256;
	cv=none;
	b=mRXTHj5y0zVedHa9HZrCATirzeN3eEr2qRJnPXXSZdeEwYggmF1eadEQeitBD9jkVOal+q
	pSf4p9slafuc0t2aGysOYNWpLcXG3V1JXk72AYNo08V0kCaw54hjLaAtJAd7YNQAbf/R2n
	pcRKr3DFs/DlE0Edj7ugCcLz7gDOXgs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nWMmeEwC;
	spf=pass (imf09.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635JItm83401733;
	Mon, 6 Apr 2026 09:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=02TqPKdDkja2MpVuM
	CfvhJ458T3TTNRCHN+YZuDZHV4=; b=nWMmeEwC4XC456PgD1gYYt4ejtHvvwFSD
	nQkVNZYCL5pYZkSyMqu+NFE5PnxBsX/CKE+Od6p9SuC/MdLyAA7YpS58vLhpqd3s
	JwOtLdLsJa0ZvST1ea5KM5o9rTBZa/uDfj78xZel3qhGDPaLDDWOcx7Myx+PGg4s
	y/ZovTlEg5YxN9FQjMAIZmYsFHW/+v7BXHEQC9DA9DL3lyk6x7c7FucMgRs1ncu6
	+tv8I9CLfx3j/omeWPbCNFfy0cDqG+MFVGhh+ptIoRyWrscj32eH8BA2LU2foRPc
	4iu0rHhFX4idgEAxKzgtTaO+4/bOldwzLD0jwl95/ZwVfJB32g6lw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dar2gdnxv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63661WNL022892;
	Mon, 6 Apr 2026 09:20:05 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbefkc0vv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:05 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369K15h45351312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B875020043;
	Mon,  6 Apr 2026 09:20:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 422A520040;
	Mon,  6 Apr 2026 09:19:58 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:19:58 +0000 (GMT)
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
Subject: [PATCH v4 05/15] selftests/mm: fix cgroup task placement and drop memory.current checks in hugetlb_reparenting_test.sh
Date: Mon,  6 Apr 2026 14:49:24 +0530
Message-ID: <9c395e89454325ac8a3f93f191e5238214103551.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: XsY-ZtQhlx9BN500-tgNidd91_t8gsDr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX7ThhIelpwuLz
 ytrnXuZ9c2L6NXvWwzrjFzlgVqi6boKVUllyPHnbzSKcmCDBWhvHgPLhh+BB1i9YMtFNBVcIpdh
 8b8jE9A806hHhGlwlknSwJRKCr/KihU1DrjRgjCh3lJPeX2+ebUdS2L2KH5zkU5due2KGWmrcWY
 k0NDe2mqpEXoXmUaU6oMjaMIocdStzVvsurTOLWKIAvUcGuwvpeIOZhoOkD2iZ4dKJ1fK+ziJXs
 CVlAI8aCvuHX2OmYKwjKqjGMo8UeJ2KNsCa2nVLXOBitV2nwg4KktILuElKnD8jASIpBoi+H7Uk
 pI2NUUaQieMjI1UurzOKOpFQqfvC1CmY8s9tndU/K7eyw1gzwFvd2GJnLtsK1aTBJ6KjZT4+WEC
 xtz15vSkAHdOLs+CcYIL/4LGABzSlK75ww5pXY+oeFH5eRPlnHXEgK/LFj1Dvl3CqyRwtylCJrr
 70iB61rJhTTp7IF0Gyw==
X-Authority-Analysis: v=2.4 cv=b+u/I9Gx c=1 sm=1 tr=0 ts=69d37ac7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=8tHZRRs_kCUVPtXYaVMA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-ORIG-GUID: MoOBKZyzIcJoG71OrRn6y-5oOM0A1wyO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 lowpriorityscore=0
 impostorscore=0 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Server: rspam12
X-Stat-Signature: 4zb4perj69x6h6p4scir7zmwk1za4x5g
X-Rspamd-Queue-Id: 637BF140007
X-Rspam-User: 
X-HE-Tag: 1775467518-948961
X-HE-Meta: U2FsdGVkX1/og3BvPPgTPLm9/h1daVQ1DhHjRP+18a5SSjUPy9dDllJPRzLI/qrtNbe4sV/59pQBQGuFqYPhXTr7xdvFuH9ImjFD/Jo3dEtP0W3ETk3EPICTyBlww/r84YAhV+06rTu37SpIXKe57GlC/3gR80xccYS7uDmSltuYjssKzvVW9sqbj+4ZU5jZ0kFOp/VsJ81OAcJ3ODhGA5KeiTv4lvpSgJsoRMkfSrNdQfk8EwMkJIMsOVyUYL77G4USh7VYX8OggHmQvd212W0I7ThsSND7oLFHM5ek/M69CMquGvtBNok7gjArOe0dBQ0PkzWyN3Vrqvm46Pm8NuwSILLiYkgfL61kFLbVkB9dOXvH3wE0QMeBA54tqfvgbTcSwU3/NaXmx6iNX0A8L/tve4la71gaYSvf0U9jdo1Gl4oip1Hf1Pbyk32HmeoSKQm1FJaZKD892Qj1gCS+25nHeNaeYT4IALe3isIb7WKl/fCDHDSmtq3CbOkEupVLtDbCeXMhdoq8i7wCJrT31oI1kaSkJbejzT8pmJwWYcjdZjOkMDwelvzYa7gJlNMhPDr1mpT09Ezx2W/XhzXEW9GU90d2H/F3uJ4ajckcw93h7XcNxLE2x8h1yiivG7NVZt0LpxCkwIj+MBf1HzgAeylaDQxAS3TUjudDzXAUvIA1MX3coA31DZD31FynDRUP8OkNzHuwyC+7hbbl5qQfULrcj+hP0fk/MVTq0CTMvDZVffdpdI2WrAkSVoH5DZw9bFzj3zBRXdv4G9MeDPkOh+/WiAsj1triAkMZ8qkeeDe1lQL0SjqMz0MPjDnMZ6ZC4PJ6SfQYAoMjFPLMA1d4truAwox1mbMdoRXJN39LCNGTqib0o1x8sGk/r8xKcIyo+g0A3RBxdC4QNYnhBKpcxPgqSLC1uL7RfRMQO44Vjlfh0q8/tlAGSIkmeSeHmGKNT5TPJx9dsueAuI6kLej
 pOYoiI3C
 zQoUUtyzh1t0VMDNruRTBeqT+g89FnVngfU3LJhYt/ImUvtAJw3raSKEkrQaEA4hVvGvS62l935Up1BvirL47+EcIJnWmF/L68+bSauvMDNF99kggTAW95fYNwarVgUrsCgLejCMUbDZdDkf6nzguDfsVD0IkCw/tma7afe6vt4guhvr/Uh/47vWBA9AVKqlWtdZ2fmEIbDLXnPSoTlYmgIqy2+X/BnceAV3qUObzYEQsANWEk63vK1WSlQDnJDl2/KFODyn9fNWJF5nmvaGjEam5YKv5C3TWrHMm14d5js5F9B5V2803mVy3Kdb6nLRMg0OjnpnlQwQNRpv6eZDZe48EXBc+Vgb2dFvU
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
 .../selftests/mm/hugetlb_reparenting_test.sh  | 41 ++++++++-----------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 00f3f3cd8909..014201cb6427 100755
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
@@ -154,18 +149,16 @@ write_hugetlbfs() {
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
+  bash -c "echo \$\$ > '$cg_file'; exec ./write_to_hugetlbfs -p '$path' -s '$size' -m 0 -o" & pid=$!
+  wait "$pid"
   echo
 }
 
@@ -203,21 +196,21 @@ if [[ ! $cgroup2 ]]; then
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
@@ -231,16 +224,16 @@ echo write
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


