Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F72EF4ECB
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE346B0096; Mon,  6 Apr 2026 05:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F076B0098; Mon,  6 Apr 2026 05:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30006B0099; Mon,  6 Apr 2026 05:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BDE8B6B0096
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:20:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6116E1A0310
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:47 +0000 (UTC)
X-FDA: 84627586134.04.4F4C116
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA60040008
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VrdErJcX;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467245; a=rsa-sha256;
	cv=none;
	b=oHKSt+zG3lLC3jjZ9TT8HZFyrKYDDNENh3wPeGMsLJWe6lfor1eI4IuPOrK7KvuuSssMM+
	mIzryYGpaszQ/kllDy3lGO/G0C3qYtqfHmRmPXOa41asZ+Yg9VKSQDrSqI5TBH4HiRiwYa
	xi5DgcMJXOqoXn4Z5DTdPdeNAjR7SBw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JNtZN4fc3fipI4yf8pu4qS2Gj54ni0NC4icf3M6AOi8=;
	b=eXSM2DDUg5rzNT/iH49tOiJCN2X6P/S6arZ7iTPSnBc135d0OyA0+uCGKo8CPnhw2wfEDC
	fJ+wSzFiHC9FAwGBYKKPlGv/KYsplEkonNQ4BjtOZwK4Yw5nLU260jqJNxczlqIx7k2UKC
	m6rM3f++HaM1OzjVEkaPHR6rZ40M+O4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VrdErJcX;
	spf=pass (imf12.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6357VDPg2060321;
	Mon, 6 Apr 2026 09:20:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=JNtZN4fc3fipI4yf8
	pu4qS2Gj54ni0NC4icf3M6AOi8=; b=VrdErJcXzFnKrj1X2SdixJ8NqvqAI+FHU
	MQkHqTdrNwMcgPLap7BftiIhZjQyasphfdKdphjtEik4Pd1KDhJtYxV2e1vN0HbH
	FeTjzTsxLz2Z5hacl0yxeZ4o9IYeSGdt5okgPDRBSJTMTnofUMuNTR8C+bXy5a1m
	xrmxTk/U7L2r1tenDRzX4OWcBfvjwK/PvghtQKZbDwV2olp9D2+XLcBPTpm8XnKC
	QH239u5lP/NqodtXTFngALMmVnqX7cD3EPGq0f8VW3c3HrEIbEtgSuw+oxHPnkeb
	UIEJkjs45YQPGXV9Cir0R+RWBz4gV4Xrn5fd/tpeuejyLJs4LKeBg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datc2nwk1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6365YIxO020122;
	Mon, 6 Apr 2026 09:20:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dbdync2xf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:20:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369KVbK35717560
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:20:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E561820040;
	Mon,  6 Apr 2026 09:20:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2B4820043;
	Mon,  6 Apr 2026 09:20:27 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:20:27 +0000 (GMT)
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
Subject: [PATCH v4 13/15] selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Mon,  6 Apr 2026 14:49:32 +0530
Message-ID: <8ef8640092004d143fe80e6fc32ea8d30a9080de.1775466330.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfX3oslSqiFf+LQ
 p6SaJ1Q3vw9BSrU0PRFLFDRhkKrZ/n64kViRHF+jfc8/ldlHAFDpmwKctEzTiCpJeBsLr0ufUxl
 1qJV9d7Y64QtR9Y2zkyzMI7BLwlJkx8cJmaxLvSpmKO63EHMJ85raAn35PX6sB5EdSfd20/FHqK
 TPIOUdE3UBJ2LYKMz7E+KBB+Ecw88HOmNDWAVuH7Rzg5rXEbe9SUFbUxcPtly4cYILEOh2LL4CU
 368D+pch/KIY1GINjcomiIVEYJ9F6NS27gICBIa4NDWJKgivnU3z9ZpuGG9hTEUT/oF/ISK3qjK
 Nm3uNGPX+3onphblaXscmT2EyOqtJcU4bq9b2w3Yh8SkKaVk1TGDKq9D9VEbGJtgmgR4p/u4Np2
 cZlQp+oCmeMA+/EiaICc0YweZXTdYIl6KbglhwlohGCfmVqQnolsiUNH4N2W//UN0aaYjiLBJOB
 pRsTMCrHZPdqiNSGx0g==
X-Proofpoint-GUID: QYU5me-PA449jhZ1jmNCEMx5dtqm78Fn
X-Proofpoint-ORIG-GUID: l6L2mecNU6czOwdTVez3C-q7FeG_yKkj
X-Authority-Analysis: v=2.4 cv=HJvO14tv c=1 sm=1 tr=0 ts=69d37ae4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=w_JUWIshtjp1QPcyv1YA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EA60040008
X-Stat-Signature: e7o98u3fe1obsj4fus31km6hye6q7qbb
X-HE-Tag: 1775467244-759047
X-HE-Meta: U2FsdGVkX19k8pnvgEKSe0CtUznYqeDWYA5FChk/BVMVUhyjjRlVGZgnQTfbnS0SwY893DXcU3ryuso5/IaUTutylYHEozNPk5pQw33e4hpGUc/m52jQIrOCqR9O7hGjrKacmqAylPEtjZZjOQ++dwk0+9yGj1Ek8jknvuJSw17waFEfkCglk30NIigBXvBQa47JjQ8fXrW5YsLjyoIq0Hdl++oQhVws4fdY3T3bupu8QcX+5YqUDeyN8xuz6OmpRFUHMRm2NTsTp1f7p5nNvdjwn5OYqEur6VXHOJZWb7x60SgMB5rP2fk2KboF/lo52nhlTOtHMjyLkZgP6N7H1koipDu77g5ne1D4/t8rxRGu3/u5hLLdAFTY4PbTIJS4xKX8Vsy9tt2tjz/5UCcABy3xqVGuypcaxgdcxfdwlYUD4/8zBqMBmSBBYtBa2RVFA8RskBzm+hXRLyi0VG/gA3/qbacJ1/A/E5SX8A8fuhYrlle0w26pW5M89CwMDsMRVNJia/M2Q0wh7Pr7r4y+LOsex7hPNhRThsIJFkRp4ZmTsGwrv3ltkYAkYAM9bxae/1KPl4ZcfmPgQXg46UkmfD2+GOziUVgt7+KkU6ghgxeQ7wbkCgMfJMAN2HgvvHV/UMPaY7oVIvFsXV8YMZ9QEYpzTfK9fqweNbkFcW/A3AujUUSaW9btkdiGCP8/P+9AZJioS/HBQJPtMqF9U7J5lv3UZRxVHP9W5A1jfi8QU07CWxoDfd+bfwzwuqzTbZjjUcO/R7cRaRcpK9DjJsC8GxXDjAftizdWKxupzxIcnkBhDTFZgpQrodZ/4xeLrNRaHlZXKR3SBnIu9kVohV0mcOdHYJDzgfTNFesXFANXi92TD8jbyYkIl7gLljcIyjP9dFuKt6flgDgMhq7OgE79/gd79Wf03Z6A6HhTdz/cTAabbSoNGJtGHjzlc23XLCQ+cYuDF8D1YXK0j14xUbH
 C+xudt9A
 hOOZVUscTaxSWIJ+Bu+e3MuLC49OVW+iqu2P1O+BnH28KbHRNlbYZ/1vPbdXmiz0hicHtJnCZfdvPXK4XLkW0aPM8aOKeg5AqXJVJAyX/zlBGXBt5pIsPN3txFcEyEteqVZ6SPKRMF+TC+sllHdIN1hl51CHaUDXFC313koid5ZX56poN0YEc5WIxDGsxA0Lfbr4t7YpuO8Pv53m4Xw6cyzVQnlB518Mg6B1plm4Qj9VmvzUTEXMYpMexCDe3/ZXrS3r+foMD0uvsoi+vQ6iBHpH1/H3GbZjLu8Cni76pWn9NkNJ47vStKgtqKrocW18Sa0fb
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
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 52 ++++++++++++++---------
 1 file changed, 33 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index afdcfd0d7cef..17c9bd910c47 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -235,6 +235,7 @@ pretty_name() {
 run_test() {
 	if test_selected ${CATEGORY}; then
 		local skip=0
+		local LOADED_MOD=0
 
 		# On memory constrainted systems some tests can fail to allocate hugepages.
 		# perform some cleanup before the test for a higher success rate.
@@ -250,6 +251,28 @@ run_test() {
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
+					LOADED_MOD=1
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
@@ -261,6 +284,12 @@ run_test() {
 		else
 			local ret=$ksft_skip
 		fi
+
+		# Unload hwpoison_inject if we loaded it
+		if [ -n "${LOADED_MOD}" ]; then
+			modprobe -r hwpoison_inject > /dev/null 2>&1
+		fi
+
 		count_total=$(( count_total + 1 ))
 		if [ $ret -eq 0 ]; then
 			count_pass=$(( count_pass + 1 ))
@@ -270,7 +299,9 @@ run_test() {
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
@@ -529,24 +560,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
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
 
 if [ "${HAVE_HUGEPAGES}" = 1 ]; then
 	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


