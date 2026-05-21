Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F12CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FB096B0093; Thu, 21 May 2026 02:48:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2A16B0095; Thu, 21 May 2026 02:48:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E89B6B0096; Thu, 21 May 2026 02:48:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBC86B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C50E6A053D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:27 +0000 (UTC)
X-FDA: 84790498254.01.B3F0618
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id 73AFF4000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eMB8yAFv;
	spf=pass (imf17.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9bpngp4LuWeNJI7hhOZ15/SZJ6KlaN1MsO0YmwThcC0=;
	b=zMqrDEVM7EzAuT2AIILyrwnaH8s6kvve70wJK7bifpkcEczIcnhz2H8hvPflg4KGFkVg10
	9oedxo6BEEJczvhI+ZsxpzyNCwNRaryzA8o0tOCeUIH+H05ef18UakRwxdydejshAoIv+9
	AsR5Oz1jL5BMgR0sHgHdwCiFnkLZmgg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=eMB8yAFv;
	spf=pass (imf17.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346105; a=rsa-sha256;
	cv=none;
	b=JxR87lmC+w7NHsLUpSA1I/hONVuPQ4lEU/x9WpYjjutsTZAnAzDu20hNec3e+yI3iZvC+J
	+ZOJBHR5C6oVOE1DADYHC5BX6bAfZv+NN017IABtFk1HDdsAAU3IAaEHY2vpoAk164VZVO
	mRJewhhIt5UEeJ4455qXPmOVwIS2qTE=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L2v5It3972669;
	Thu, 21 May 2026 06:48:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9bpngp4LuWeNJI7hh
	OZ15/SZJ6KlaN1MsO0YmwThcC0=; b=eMB8yAFvqWJ8icmRD3+8j++Y5KumPwpXN
	dE4ST32ynNHWqTQBaiA4BArpZaUBQm2yoQWDDj0Jcs6DaVByMx7W7F5VwNrb283T
	Da4uwu9T5/CcVtXaXtCGC3IbxLmSfqwVowlIrXO6UBPrSyl/YdCDZJ7lx73nXZN2
	W5V3W8oD+GcP7IRRPaFNKLLR7vQCru14y3xdo/auLrkcBCFWTHhm4EG6EU+vW6rx
	wJxIeBS77kRJOEghNsE6UOsnMqTSOaCwtuie7aT5etSMgqNwYmneKhkJJCcYXCtI
	6K6UKSmw/n6CEYsgmVsx0jcn44fMeZogrwnAZG57aPttaer6gdipQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y5k68-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:09 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6d40A003561;
	Thu, 21 May 2026 06:48:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754gjksw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6m4Om48824598
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:04 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5C012004D;
	Thu, 21 May 2026 06:48:04 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E015620040;
	Thu, 21 May 2026 06:48:01 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:01 +0000 (GMT)
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
Subject: [PATCH v7 04/13] selftests/mm: fix hugetlb pathname construction in hugetlb_reparenting_test.sh
Date: Thu, 21 May 2026 12:17:44 +0530
Message-ID: <837ce751965c93f74c95d89587debf1e93281364.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX8tCfmpVxwOYZ
 fNCRcgg19UxXoHi3+n4Wk4wqYjkM4vVVHlB84htGCdm2YQqRngrIfI/EZxflS9TcY17B9zUNyNZ
 DX8AH21HzYFsoFeZ1hyfPHiU62oTjq9wi88K88sckV3IZk9VijWyefuLX39fYbkMQZDYh+EvEJy
 GmkLk3LIqtWkYBnIHpMrJeoaeGh1jtcqFTJHrMgeekHnWIAImH5K7ssc4e7C/EWkyto1IQPTgOS
 4ZmlDqs4AZ/otw06NW/OOwKsXhWZC8vg5K6Eh6NQAQi58wP9bhnQNj6FpN/ozqvmzb3Bz32aYKr
 ylLkPOSYdwVJxZtrRwZlQDTCyIFBjOKzwsREtEa0bfo8LTnOJDj1DRL8ebfi6s2xwq7Z6SJHEcG
 76gq0lbspWEy13PMkBKKxQqk6Ue5HjA4mTb4jTmc7OK57gaoL/SOKn9PSb+QmxuTBxWJgYc2x8h
 1YTPeg8E8lZpySM12wg==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0eaaa9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ikd4Dj_1AAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=7yu59zDboRqKFyXxuvEA:9
X-Proofpoint-ORIG-GUID: pICns9u6T883Qo12vo5EruQsdOhLvWbs
X-Proofpoint-GUID: CYXlI0-YC_WZTxCdHj1tzX9j09-hsPxm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210062
X-Stat-Signature: cgnkqcdxj8begjfg6ctybh7ng3ch5ppk
X-Rspamd-Queue-Id: 73AFF4000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779346105-274153
X-HE-Meta: U2FsdGVkX19/MAfIOamG4Q2p6oqc2ND7/W5/HM55UU5Tf7dJjsc3pns/TiJXk9Hd12yiMay5t9+0HjOa88GwFnjR+uaTEDkK5lEZZyUK9Tehz3FfRsTrDXycy8YEJxM0U4+yiHrOBTvdLhdv0P9Wx5Vi0UqQTSktLRd4BbGH4VC+qLA7+ecotPpKlYjMVsHhCoEYfPEYiwDnBBM+sKatY6zcOhcWAVRYEf4IXw9ljz4h2SXvdP2VQscSLyMosJ67EdUNCSeMhxJWRVaq8Kyhx95ca1BBk6lVkQoCiMCX6imn/g4QkGz96zo2NGfQA9Z+dsvnIYbOawT8Ka4vIYKqu53r5zs76vBuYT/FC+7eHganR1H4mf6nveCH0vJZBFWw5/LEdtnlVmDiLCrlNjiGuLHzeiFktyPYTcEFn5GTVIAmBxilU+/5d3zmUvzO1cwSEztA7+loKli51/JWD85oAF+Ed9GkvzDKFDH6ZYis5aZ+fGGTiCltfzGMMTzmx00BZlzUeL0S+Wfb12xzgkjRIgx47zBa/Fcpc7prTpBxRSIzxDuGguPvNYLTtC9Z1mlQ28askRZ/AogGLuiFgH7oYZc8+CKI64obayZ5sNmeCUHOnuTi7l73loLVNorGdV8AiMc/PY2HA+dFQ92jxVytmdbe0OdVBwN8v4IUA9++YbLF6Hr1LctDkO57Gf0Qp6AdLdebv8ZZCzfHfc8yTeIsoSEeJSZY+0rheTsTZitGskXb1psnbU2sUrsDSQLDF7wpNy3yL6+qKDBtirHkrqYUFLrOnwbLoONtN54U1XM5D2BTZ2yg07ccXzGGKxEq34pMadMuDUhg/NptEfK28OqGRJ0sFUpKLiIJGQIPZF4FUWNtcaBDe8UQ0B1cZkAo9/s7BOhxYzVKAJqW9yEyHJ9Iewg/XjC08L4Jqmry4Qst3kkifXfHKmcJUxs+0Z6tJqlRikreqCc+ZWeb0vuAPUL
 rzseRHsJ
 lOM0l9q7HHeNA5gm2T+SseUDeUlyv9qSonkB/rPbpooOxr7btgWfloo5L8CDB/qOF5Ekd6Qu4uL78Jf2QJPqX8odaa7RyNroAYYJm8zxDNm72RT1BGYwPdTA8HfZfyyAzIqCKQ1nyclDzz2+7YpASwId6Z+5NIShpY0rn9wTczqIGGACU8NeWAOC6sVeW0rDigkqxCfkNLVGGAqykFXtJSGg+QeY9f/zPGkfbWVVU0SjMgxaILLgkRa2lJ6c2ag/NaaWedY2wSwYSK8flqT8zRXLG/Us5+vM4GEZmTK4DI83V6hrvvYcMTc6xypptT5mDwuCyfviba8uX71SGE6CRn1uyKFe2yAcSyCn2u0G1xsYaO3i//4EnoUYpvGf4rYlExyeYjnwqovJv+7ECvAJ8Gh6lEqeZKlFwZSTGYOhTWOGF+67oKDLQEWT1N0MmgrnrynShO8JQcY3qNl0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_reparenting_test.sh script constructs hugetlb cgroup
memory interface file names based on the configured huge page size. The
script formats the size only in MB units, which causes mismatches on
systems using larger huge pages where the kernel exposes normalized
units (e.g. "1GB" instead of "1024MB").

As a result, the test fails to locate the corresponding cgroup files
when 1GB huge pages are configured.

Update the script to detect the huge page size and select the
appropriate unit (MB or GB) so that the constructed paths match the
kernel's hugetlb controller naming.

Also print an explicit "Fail" message when a test failure occurs to
improve result visibility.

Fixes: e487a5d513cb ("selftest/mm: make hugetlb_reparenting_test tolerant to async reparenting")
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 .../selftests/mm/hugetlb_reparenting_test.sh       | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 11f914831146..d724b6e45432 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -48,6 +48,13 @@ function get_machine_hugepage_size() {
 }
 
 MB=$(get_machine_hugepage_size)
+if (( MB >= 1024 )); then
+  UNIT="GB"
+  MB_DISPLAY=$((MB / 1024))
+else
+  UNIT="MB"
+  MB_DISPLAY=$MB
+fi
 
 function cleanup() {
   echo cleanup
@@ -88,6 +95,7 @@ function assert_with_retry() {
     if [[ $elapsed -ge $timeout ]]; then
       echo "actual = $((${actual%% *} / 1024 / 1024)) MB"
       echo "expected = $((${expected%% *} / 1024 / 1024)) MB"
+      echo FAIL
       cleanup
       exit 1
     fi
@@ -108,11 +116,13 @@ function assert_state() {
   fi
 
   assert_with_retry "$CGROUP_ROOT/a/memory.$usage_file" "$expected_a"
-  assert_with_retry "$CGROUP_ROOT/a/hugetlb.${MB}MB.$usage_file" "$expected_a_hugetlb"
+  assert_with_retry \
+	  "$CGROUP_ROOT/a/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_a_hugetlb"
 
   if [[ -n "$expected_b" && -n "$expected_b_hugetlb" ]]; then
     assert_with_retry "$CGROUP_ROOT/a/b/memory.$usage_file" "$expected_b"
-    assert_with_retry "$CGROUP_ROOT/a/b/hugetlb.${MB}MB.$usage_file" "$expected_b_hugetlb"
+    assert_with_retry \
+	  "$CGROUP_ROOT/a/b/hugetlb.${MB_DISPLAY}${UNIT}.$usage_file" "$expected_b_hugetlb"
   fi
 }
 
-- 
2.52.0


