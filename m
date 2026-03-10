Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE81F41808
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 09:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793346B00A2; Tue, 10 Mar 2026 05:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E4276B00A1; Tue, 10 Mar 2026 05:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C5166B00A2; Tue, 10 Mar 2026 05:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3760A6B00A0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 05:51:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 02C361B820C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:21 +0000 (UTC)
X-FDA: 84529685604.22.C1569C7
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FA5414000A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 09:51:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UiOFILfC;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773136279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mFZ5GFeFVXZ38R8twOevOvM1H9fWi9PYppF6Ptlmi5E=;
	b=cL4ceVaCOAhg2SxEQ5eZ5K71qrXUsv2PuC+KKOD86j2eP3m7qelXRUnZcMgmeQ/mkCLuou
	/u10ULnFTT2WumWNJ7it4rkuspUU/8IgJIH8XgKJAM7UPGOUQtHh9zEviZRenaMBu0Qr4k
	YDvCuzF1OGefjjq0yGimIYySAqJaThM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UiOFILfC;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773136279; a=rsa-sha256;
	cv=none;
	b=iqkoQWxgbztx9JHIrlU+wLJHRyql/YbpBHrNnlZ57sT4RTZXCSBDulK3hU729mkL3thmMZ
	Vr5P12ksZh/GVRTuHih39p8vAIIpvu5iLbBAJOhFDrtYUqxZMH/FVVNZel+TNex7qlQ35e
	uM9xhQkWBX1ZGHrOzR0TAZZOS3sklyw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62A8l1K71614605;
	Tue, 10 Mar 2026 09:51:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mFZ5GFeFVXZ38R8tw
	OevOvM1H9fWi9PYppF6Ptlmi5E=; b=UiOFILfC5J3Ab17X3gGxflsmQcBDijtMm
	r44NfBJjw2SLt4W2HbZsIpAKUdsFCn8I/0xxFv9ZfD3uWw5vx+J+bcJNzuYWHXmW
	pfTas1CJ3UP+gyjz1m/ybEgbREH8Rgu1Xezab+W/yaypC1e6BHoBpj/G0FewjshF
	DuCw1FiKpkpTwc+yR8uQ+IWIKA9hkZawXOu2ofOBBlvuPmi/5sOyogDKczuJVBpI
	20VoSTrhCvG9/WS1vFzYGBewjOkI3uCJFpK/yZ3JtlqAyGWj+/Uxt6WUKG5f7fWr
	0hp5DOHIAMsvf7w2OvUZrxFw5yn5SyznRvL7NujOkI3GY10jhDG7Q==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvra0ep-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:13 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62A6293T021150;
	Tue, 10 Mar 2026 09:51:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4crxbsrphf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Mar 2026 09:51:12 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62A9pANE45678902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Mar 2026 09:51:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8C5F2004E;
	Tue, 10 Mar 2026 09:51:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 100DE20043;
	Tue, 10 Mar 2026 09:51:08 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Mar 2026 09:51:07 +0000 (GMT)
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
Subject: [PATCH 12/13] selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Tue, 10 Mar 2026 15:19:30 +0530
Message-ID: <832afc6c34a784ca433b506622cdc98fe9540f79.1773134177.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773134177.git.sayalip@linux.ibm.com>
References: <cover.1773134177.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEwMDA4MSBTYWx0ZWRfX2CrdpGMRQims
 RElM+X/zRjmzCOo7XKlYXylZy9a8VZNg5q2KepbArMXRW6xAv+D6mYxYpqhiSbygkSetCWnNMr9
 5dBreRxvOqtUCWgZ2JqpvxjibbZiMW6snkaxEvluIZpreXbpS7nA9o5BJyi40wzpIx7EacupNum
 YwXh+WRxVMVvyLFLEIRrOu2BK5lHQyYr85oOsUxwNhbZR0U2dBAf6UfPy238yJDVl5Res+gU2Rd
 xTmTBY5lvC2aRhkvbiI7h6qqu5bEUN8f7LWn4utZWOo+tFh1PJ4V/Uk7D6dYh0T11m6Cmb6yy4I
 K2TnOdmWrf7svYaF6QuxA4gwndcqv9/SBvwjAIXclo53szESLusB4mOE5yiIlDxGaKJOH60qYSH
 i/IB+ggXCe5witT3mDBw/NVUIQYPdhSfJ9hbA4zgM9mDzUXGOcuWRrLEUotsLfwWuEXOZnDVZJQ
 dORMxeCYQrOxJ95FDXg==
X-Proofpoint-GUID: L4RR84Cg68OZjg6O2hsxkmISFRLM4WbV
X-Proofpoint-ORIG-GUID: 2GJK7lkJexS3_-jhQzeHAovAC4WSrcIv
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69afe991 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=DyNJ62oFE8-pT6vY3_0A:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603100081
X-Rspamd-Queue-Id: 9FA5414000A
X-Stat-Signature: e6d9drxx4kyr3zm3g81iuraeq36jc63a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773136279-117788
X-HE-Meta: U2FsdGVkX1+l3mh2cbyf88sFFgd1fORmmOzFuVBbBOs1jhOmCzfGNpdirzTs/EsgMNVxgB0iiQrOXERthEbhwK7JT7aJxwq6UKiuxlwvID6FiJljJrRjDan57xE4qqud3b+K+/+63cDY3p5b9FPLFRUkueq6+mtodzZb5a8kGd1CU1CvTj2xXGQ3Wi7ldDYnFs8ZJ4u15Gzx07LVM0MzIq8kcHIDXlUa//PO1c9vq6AQ9ReofkIHGNfsoGbHCwlMcNKkz1JTeyxErqtOC/4rwDydzdM/vpdwHsvC0wq1q44vT9OJRNChIaDaoKqL5QQkB2j/fTyx6mjKFAIXxSfhy2CP8/Nf7YP1ZqUZvsD7FKTEAsqmLl/rLlh1NoMNhT3+AmIHdF9e74xF6KuFQ+qJzQuoPv1cus/0zRyGcenYfjYSyxLbUPv/LueBDQzChW6m93gx+F2yxLsIK7ohf48c9cURrhpI+sL83LlL12CMs3H/UrRcAcaETNFH32vTv9Clnrl9bE1UkNdHz4jl4DB4hIHaAuehrv2ZZ63ivip6lMYhCtAA6lNE66wJHJxXbjf8BlO3ICFWa+Uh6S5u8e3F+4GU9dj4mu+QgHSaxwwXzWNhneSUozrsP2jgPa6+QQ/ukFI4CWlcgjEkx3CO8JGnpIgqNkDmZnWJUxaFnrEmPh/y6M5AIb69KPU02UkgIx4AMhy6dlW35Ruk57eREhejkMDgSMhtK+kSRIcS0AvFEL9irppQNa0k/sDN0lrRRfShZTNLHuTuCyFOT1NPvOWnuLsyLtKRFjdtkCia6rgKUD0ddE9t7+SyC1z4SmNh7XyuxYh0ztOBcZ6TARg0AnH2Jhm+ngCd2EP+3KFuFzQ2XW2FMawsoK4Bf8KtEXOG53LXS6Tb6Skr5o7MHHGDVSq2wa9Gk0PPOYx29XaTKrg9ymp3GUk6Eo/fC/uS3CH4N1GcKAwW5Rea+inj5C4e/Yr
 C6v887PB
 hCjTU7Ih7zbcKvk+nX+i0RFEyzhwa3WKklE6Ui+9BtPFToHfSIo8qbIQP0V8QLysKxz50JwwCBkBBCDHZ5bJ+ImjcuGrhQE7bexOYAba0PzZib2CnAYKhbBDJ42OnV3O0Mpe+GNQXFJuaXwPCnRFPtyG8SfhEWodzZze4rEPU6npkHZ5b5CrHtxE1BBtKN89uY2agQQy7Q9mfq1VpKx624x/9snRtPdjc16JoI4U8DZ6FYAkZVsmuu2ledC56YoKdIB7deBbzre8F3Lkjxqn5MC+1jj0y+vbMpFXUTd05qWy1UX1GMXMLODlqh911cdB2hfSlNbhTmK17ufb0l5QDby9LwLRoAnYeE8D4o9ddIQrhu6sz5+SnLvH3VPbcJEhXexEHKLAKkdZJV8Jbq6HqjKLAkEtXC0m0M4+h
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

Fixes: ff4ef2fbd101 ("selftests/mm: add memory failure anonymous page test")
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 46 ++++++++++++++---------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index 7273c3e18227..7f3a3027cd9a 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -250,6 +250,27 @@ run_test() {
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
+				fi
+			fi
+
+			if [ ! -d "$HWPOISON_DIR" ]; then
+				echo "hwpoison debugfs interface not present" | tap_prefix
+				skip=1
+			fi
+		fi
+
 		local test=$(pretty_name "$*")
 		local title="running $*"
 		local sep=$(echo -n "$title" | tr "[:graph:][:space:]" -)
@@ -261,6 +282,12 @@ run_test() {
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
@@ -540,24 +567,7 @@ CATEGORY="page_frag" run_test ./test_page_frag.sh nonaligned
 
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


