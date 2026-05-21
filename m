Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB319CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C34C6B00A0; Thu, 21 May 2026 02:48:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552E36B008A; Thu, 21 May 2026 02:48:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43BE76B00A2; Thu, 21 May 2026 02:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2B50C6B00A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E8AE614053C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:46 +0000 (UTC)
X-FDA: 84790499052.27.25979C7
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id A895920003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SMEWPbgT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf31.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mC2WsYZfhgVjdLpYp2qK3XgGPT458/2QAjeD/0bOqxw=;
	b=532Rng9HBucLNV9ZRJwU9PiVSnxJMRGIZ8Yum4MhBCCEbbAKOaGTANHnOI/Wo5CGIYQcfs
	vF0L5SQkBUtp6XOrWQTKfi98whkAaPuU97MndGZTcDa+hWz1UClTWHJkKWaGAfUBdBrc2q
	tYz4gThTH9PJfKIngUdzdH0Sq1m2Ico=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346124; a=rsa-sha256;
	cv=none;
	b=fn16Mo4HrnUcBta3KhVocaIkHD7zhUhf+Nf0SFon1kiqogd0JcowSACrPoil5ru6vFenMa
	stQXCmn1LxJDC5fN4RrOSoqDCLYwDlLKIOVZhjm12RQ3ENbObva1dOP8KUfFK1PLAKmIPd
	Gul/vC8jdenQGu9Rg8HXbJ4ZspAaF70=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=SMEWPbgT;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf31.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64L3Rbem470901;
	Thu, 21 May 2026 06:48:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mC2WsYZfhgVjdLpYp
	2qK3XgGPT458/2QAjeD/0bOqxw=; b=SMEWPbgTyM5wyew5lTu8NAJx9d+ebSpXB
	j/6L/aBpfB5Ichn7I7IhD/zVBm9GXDEqMoFAkkskOtx/NGYvzIeubkhwCa9hffsM
	g5t5+NP4Sq0qOCgdgKLrimXRDN9ZDFccnGrDB6T6wErcG3V5HFU2jKGO7shWVQw5
	UfrvqBXF9qpEPrgHv9MtCQigRo1RA9uQespQflZjNQCjCDM7Wsa7+T2b173eMaDb
	/SQ0ZkeI/7wMvE9bEHxZ9AcGZfGGffkcw6RFyqMA44ZUPUp5Y+Zn2Z1BXh21BD20
	yNzj9e/87sOSmMyN4D9wTCnVRYppjzAYJHO1eZz38JRzHTRCyjhgg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88mcev-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6dAnF009772;
	Thu, 21 May 2026 06:48:36 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhtrqj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:36 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mWiS48824700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5B1F720043;
	Thu, 21 May 2026 06:48:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2358520040;
	Thu, 21 May 2026 06:48:29 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:28 +0000 (GMT)
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
Subject: [PATCH v7 12/13] selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Thu, 21 May 2026 12:17:52 +0530
Message-ID: <93441f34f7ef5add47d1a130d03daa79e21b5050.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 9VugsKY05zg6rR89hxxUeUzNOm6O2Il9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX4t8Jzc0Vb+Sa
 bpotnjv6nEyj/qlLGcHQccm5Pk7hpHTlMBHL2JDGIrIS2R2gxJkcabnXCqJrX5yMKchE9jSylsG
 4XL7naaEzCDEjkdSs3k0KB35rfidjrR+dObof2YChC11469dkDCkPBHiVlzq1SHzH22EG/Vk7jC
 iOxAJjMjOufSlhYwytjq2Y6iEpP22ZKHGCKcKpofEZax9knM8fAojDsYkLB9FsFhyAwQebCZzPW
 cIPXZ0QKP33ST6wii0cJAKzv5VPVCWZ5cfDRuupfh3FQezcmCvFkaCafmKB1QXvgLrD1p89qwQU
 e705WGrVNBy5WO5DqmgTPRAtOL+NAYHFq390h7B6OCb+O6LqyxahAxHyKPEqeQfw/ExtlcWTMe/
 0DaPjMy06R3ljrEs+SeG20Z75yRA01ZeB3kQqNmFe6PVTSDJTa1Tm7ux7/g3qCd220jbXVjC4bl
 BKmEV8Oujq9hvxLD+Fw==
X-Proofpoint-GUID: qs7GHM6fPp2f7DHNK26s1pCgdYKy4xYY
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0eaac5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8
 a=RKaXm5X2BghK_eAo6iIA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210062
X-Rspam-User: 
X-Rspamd-Queue-Id: A895920003
X-Rspamd-Server: rspam04
X-Stat-Signature: kx56t3m1717dfkf97shfd1fcip31id3s
X-HE-Tag: 1779346124-177546
X-HE-Meta: U2FsdGVkX1/X+8xgx97k1bMxoc/Fwv/wp9U0GpHdK5SJpJi6vJxVbJITqwFzWJcDh1zs9iMWLvC0AaDeXeCfKT20I2BFMMRZClAIpEu5lUwhPMRKSUmjTxchsixXSK0IQrgmVDyAFoNHL8kDhX0Ts5VvP0DxVpLVT80V6wlpy2gx7P+Eg8FHqHvnhqKmS8TkPxyWg6RrQ01d9id0+B7ZiYiBNpthWRE73UMTqAbWRj3RXog7BcffPBh//S9UjKhYwvUvkc0eXdidIAHTXcCnRdwZlm82h8SOkqw035dp+TFEmSqZ2fbLQDcc7JkwFIv3JEjIsN0w7HAtconk7M+URqz1SGl8oQ1SReaASdOpZkOO5NbeV3A5QXFHtw8RFgX6GA4l5BDzXuYO8ISF9tYEFFYnEnifJXd1uyN8fKncaG+rcFhIxEXzL7qb89v/+TvnasXp6yUhYWFw0GseUoj972a0L9tAjP7DCFpdus5003MqzQV/sLNwUgMisr2YvZFDpRiVJ6lftUcMfSdpata5HkxkinYPqRdgDJ98ZmTz3BezffN9aBgrsKbxCPTOaJC2URxudjVXJ9q4eVSdvxaSbA0DcTaidU7CY+SBfmHo6BOy2MM0TKZD4BqNfX+7vd9h85v77lMm7FM+NvT2BNL30SfqWXnby6F8cqVZ4nO0nSqG5zYLIx2RB3K1eAkYOWZDPuo1pcoWXlckCnzmqBYqdfdkspYH5LGXRDkuRnwIMNqdZoH4Bb+3ziu2Mt05/WbUtvBGMOxGKHzH/mireWVd6EBSRIidcwq8FF/riYPLwqzB7U7F2XgteDRSfWSUqhsapKXecssW9NQiTeLaNfvv+GJS5AC169e3S8eZYE8MKvmpBTWo/71yemS2Wm/JwGyEQgj07TIj0RHVlv/g4O/kE7AScJ3Tzys7P5I7ktv9C/uh72u/1jlZD0dTOJerUIOXzPW6G7rhJJVCP9TLm54
 nk7K2O9T
 YbwudYmE8KND+3Cl9Dly+sMR0Ill374HQF4rKx4gqpz2m3ngisbVCEdrdF7fg8+xl/nXeekiVHyMgEBt4gkYWjiwRgB6576dnfXVFFZ1PIgjQsxDwKdwMkqcf+kseIW5U/Wc0Qtbw0vnnJoyTDlcZZDRY8EPK3GD5TiXKC9OXvkPOAWLaigdiKBv3Duz+iSOJ0kgYIbYaVJfj+rS+XsJR0GqnJWl8tpdA/wdw3TeuOOV7TLCqJNZtvBSm6BaUCRUZoTK9lK7YooYQtG9d0FKX+Ybtn1Ge2Jc79wKkvRfiOv0mTtselQX3yhbEOe+OMUz+8CVK6gP5dz3eWUePaJxwIsF/7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

run_vmtests.sh contains special handling to ensure the hwpoison_inject
module is available for the memory-failure tests. This logic was
implemented outside of run_test(), making the setup category-specific
but managed globally.

Move the hwpoison_inject handling into run_test() and restrict it
to the memory-failure category so that:
1. the module is checked and loaded only when memory-failure tests run,
2. the test is skipped if the module or the debugfs interface
(/sys/kernel/debug/hwpoison/) is not available.
3. the module is unloaded after the test if it was loaded by the script.

This localizes category-specific setup and makes the test flow
consistent with other per-category preparations.

While updating this logic, fix the module availability check.
The script previously used:

        modprobe -R hwpoison_inject

The -R option prints the resolved module name to stdout, causing every
run to print:

        hwpoison_inject

in the test output, even when no action is required, introducing
unnecessary noise.

Replace this with:

        modprobe -n hwpoison_inject

which verifies that the module is loadable without producing output,
keeping the selftest logs clean and consistent.

Also, ensure that skipped tests do not override a previously recorded
failure. A skipped test currently sets exitcode to ksft_skip even if a
prior test has failed, which can mask failures in the final exit status.
Update the logic to only set exitcode to ksft_skip when no failure has
been recorded.

Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 62 +++++++++++++++--------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 043aa3ed2596..8c296dedf047 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -180,6 +180,9 @@ pretty_name() {
 # Usage: run_test [test binary] [arbitrary test arguments...]
 run_test() {
 	if test_selected ${CATEGORY}; then
+		local skip=0
+		local LOADED_HWPOISON_INJECT_MOD=0
+
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
 		if [ ${CATEGORY} == "thp" -o ${CATEGORY} == "hugetlb" ]; then
@@ -194,13 +197,45 @@ run_test() {
 			fi
 		fi
 
+		# Ensure hwpoison_inject is available for memory-failure tests
+		if [ "${CATEGORY}" = "memory-failure" ]; then
+			# Try to load hwpoison_inject if not present.
+			HWPOISON_DIR=/sys/kernel/debug/hwpoison/
+			if [ ! -d "$HWPOISON_DIR" ]; then
+				if ! modprobe -n hwpoison_inject > /dev/null 2>&1; then
+					echo "Module hwpoison_inject not found, skipping..." \
+						| tap_prefix
+					skip=1
+				else
+					modprobe hwpoison_inject > /dev/null 2>&1
+					LOADED_HWPOISON_INJECT_MOD=1
+					if [ ! -d "$HWPOISON_DIR" ]; then
+						echo "hwpoison debugfs interface not present" \
+							| tap_prefix
+						skip=1
+					fi
+				fi
+			fi
+
+		fi
+
 		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
 		printf "%s\n%s\n%s\n" "$sep" "$title" "$sep" | tap_prefix
 
-                ("$@" 2>&1) | tap_prefix
-                local ret=${PIPESTATUS[0]}
+		if [ $skip -eq 1 ]; then
+			local ret=$ksft_skip
+		else
+			("$@" 2>&1) | tap_prefix
+			local ret=${PIPESTATUS[0]}
+		fi
+
+		# Unload hwpoison_inject if we loaded it
+		if [ "${LOADED_HWPOISON_INJECT_MOD}" = "1" ]; then
+			modprobe -r hwpoison_inject > /dev/null 2>&1
+		fi
+
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -210,7 +245,9 @@ run_test() {
 			count_skip=$(( count_skip + 1 ))
 			echo "[SKIP]" | tap_prefix
 			echo "ok ${count_total} ${test} # SKIP" | tap_output
-			exitcode=$ksft_skip
+			if [ $exitcode -eq 0 ]; then
+				exitcode=$ksft_skip
+			fi
 		else
 			count_fail=$(( count_fail + 1 ))
 			echo "[FAIL]" | tap_prefix
@@ -422,24 +459,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
 CATEGORY="rmap" run_test ./rmap
 
-# Try to load hwpoison_inject if not present.
-HWPOISON_DIR=/sys/kernel/debug/hwpoison/
-if [ ! -d "$HWPOISON_DIR" ]; then
-	if ! modprobe -q -R hwpoison_inject; then
-		echo "Module hwpoison_inject not found, skipping..."
-	else
-		modprobe hwpoison_inject > /dev/null 2>&1
-		LOADED_MOD=1
-	fi
-fi
-
-if [ -d "$HWPOISON_DIR" ]; then
-	CATEGORY="memory-failure" run_test ./memory-failure
-fi
-
-if [ -n "${LOADED_MOD}" ]; then
-	modprobe -r hwpoison_inject > /dev/null 2>&1
-fi
+CATEGORY="memory-failure" run_test ./memory-failure
 
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
-- 
2.52.0


