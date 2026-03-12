Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361CB105A591
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:27:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95EEE6B00B3; Thu, 12 Mar 2026 08:27:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925FE6B00B5; Thu, 12 Mar 2026 08:27:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836326B00B6; Thu, 12 Mar 2026 08:27:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 716EE6B00B3
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:27:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4890E1B6FF7
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:27:00 +0000 (UTC)
X-FDA: 84537335400.05.EBE0C7B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id D4371180003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:26:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="C/0eh1RB";
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773318418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4e5DFl5siWIhnuxgccuPdSzyDnLoJB3bmNN+u1miYM=;
	b=PXF5djuU12U/t/swdzcffLdc7uM5IRVX8VR+ET2zjJhGZ2x6MYnrip6Itxa5cPmHrKPtKX
	67/3tBSAlN2EP7Pjq+9d/dZ+M/o+FkNpkr74c81QXYjobF8ZQXUEeq2YfeM3mbw48yK8hy
	e/Bw1rOaWuam0XMNA4X7AUQGaSlJ4ho=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="C/0eh1RB";
	spf=pass (imf24.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773318418; a=rsa-sha256;
	cv=none;
	b=8XZmljjfInFwfmn1/mqE/ziasvnCFb8yeLP1on8EL4wEmzPhj+2V3BZ7Mw+l82+Ba/zg1E
	XluumVFBvYCuJWwpCx0sWEWxohCrqL1Z40dnznbO9umIfxZQdq6XVCtOG5N+pcUv1IdLCs
	sXZdkCpWaxnYxInXFnVmwIVhXVoZSRE=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62BMVq5w2278406;
	Thu, 12 Mar 2026 12:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Y4e5DFl5siWIhnuxg
	ccuPdSzyDnLoJB3bmNN+u1miYM=; b=C/0eh1RBMF1yUyCpP2ePstZuumJZYW5Xq
	v8P5R3peYXQo89huDfnhZEugvCORSIMAxOgRlrBt3VnPu0mC6tyMVxkNSd91bZry
	NLQ3hLDWwxnnD0unHaBs/yW/r0xe4on7p1gaQiK2Ltv0EL/ccOo4xnXmK8Xw08eV
	ccSmcsnwWNV1jlLnICyeeJeq+KAVva2FTlL+lSrwJKrPl3hVKwwLosUyN3Iwiujm
	KmIxxC84ayjqVX8nvK2IrdLY7t2nu4u7V+LsE5JGKzpqB9z5XXmqc2mv5Uej5MVZ
	zLatWKwVMO39a5ncO15v9rWW4QxEuNqRunU8eQYNfKE67/CqNy3fQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cuh91jm2x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:45 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62C9ZAmR014631;
	Thu, 12 Mar 2026 12:26:44 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cuha8a8u0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 12 Mar 2026 12:26:44 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62CCQgZQ47513976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Mar 2026 12:26:42 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2919A20043;
	Thu, 12 Mar 2026 12:26:42 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 161E42005A;
	Thu, 12 Mar 2026 12:26:39 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.in.ibm.com (unknown [9.109.243.201])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 12 Mar 2026 12:26:38 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Sayali Patil <sayalip@linux.ibm.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH v2 12/13] selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Thu, 12 Mar 2026 17:55:39 +0530
Message-ID: <35a44ccc4d1587255e8f920b22e983f74c024f2e.1773305678.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1773305677.git.sayalip@linux.ibm.com>
References: <cover.1773305677.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -4pIdlppxyqzTJZJKqAjAXzEJT4ik-7G
X-Authority-Analysis: v=2.4 cv=E6/AZKdl c=1 sm=1 tr=0 ts=69b2b105 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8
 a=QWbft6qDQSdZu_5rdncA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzEyMDA5NSBTYWx0ZWRfX6HTZkZX6Uuz9
 r423AdpuJXda5Dk4Sdkv1O7v1mXXqhC+Ttb9xad8jUTEP/eFTtIHKgvFXQQVqqMGIYiGN84pnGp
 kLYNsRKNMUhJ2CKqoNWF4lGcax03V80JBZjSrQ3GKLJnhnL+5lMhIyb19ZTt1E+E9qWC6K594ua
 gt4YI4tn9bGnTrVmS0jsZtZkiXk96UcLdINqzACX/cpX6L52nb2C4Zpb/ejpa0tdka1kIXUvr38
 M5IaOFaHrxQc9rvtZ/S64Na6QPH4+xL+01m54+s4u6gox+AF5Q1DP6QbOyh+0dxSu+yZQSzplES
 acS5o5qUDLT+yhAR2lQPmz7oubA+ci3Le0rSp2WeoEmzGJF0sEeNAsoGPhUQ1w2HhIhrQh9XmCZ
 g8omQ02s3wnlqhtvWdDgPVLxMqTlFUiQ9Y9aiRnl9oZJmwlL/KcVfVu/EZIYVqTnlfJs+yczEux
 Hko5BFpGzAdYj2il3EA==
X-Proofpoint-ORIG-GUID: Q3CaJOTqwSzc-HTzDttj7c7yIAnlKCjj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-12_01,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1011 malwarescore=0 phishscore=0
 suspectscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603120095
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D4371180003
X-Stat-Signature: r8d67jowx1drb8tgo541zho3mdh7qjr1
X-Rspam-User: 
X-HE-Tag: 1773318417-60392
X-HE-Meta: U2FsdGVkX18K/AFeQRp52iIQ4sKg4PZcGgsbeU9DoSoWa7almpGyiWT49FeoXi6YpCaSuUUDnzT4EAuPX6haJ9z9kLdw6fAOWiIukO3yjTHzUM+vpB11O2K+IF6Ato5q//AHkvOTdz3Px9n/YGqGakGmiJ1j8v+mdwhVKET8nJiol26ZHlScKQq7o9TUJUYkwmLuIY7q7IscWUXXAMJQUYxiGt1MeEOG4lEp14F5YV3N+HjYJdmamDhNCbQzCFRvap9OfImynIF4AUVR4EKiLcQGR21Q6IRtFycFlAwgT4b3i0z+IHppbGAz2+GP6AJ/qBs5ouXxQYfaPV7TYQsY2AYXH1ljdaEBRxZ9X8GsG1HhAx1KwVq6fJmybUoNzLxTfs70ecattZsi9mswDROfi/t9JjVK6r916nVI5otY3I0jdi+z3tQo0GPfw0C/Q6kHiCz3cR3t4hGdHxfuhy7pPOxxHSAe/TRRO218eJUhyxWvJYg9WcVfKphIsTdwEaWmy9hEXxWN4c/UB2iLM4q4FM8tT4ytlhe3HHuaTK8ffllM0z39CxWNn+vYUHkOgqEkz6RIvhi3Gxid4cL1YXsnm8YjSj+0UCvv96VvJ5IHN1ncHGU2T/83Inyy2TmjJnQZ5w7SSKC3uraQc9derRpEt5k8NMewfdc+p7AEp1ge39VHljIdAilq+SFheR3/7+SMu27SpIbZe9fKbEsbKFTC6Laa6dLI+4BN0RRQ2fUun7sBwO60yqwaxrJQeiXbkd1TQrdbnc1OZ/UFoI/QWLjSZee7OBjICLcN2AnOF4JRzqDUnpaeKrsbVDIfpniAojIktJyLmPfnDNnK0OdY2cG92+v8083ffFpOGEfZfr07YiwJDV7LhwQiU6MvNyD7T8hyX+c66+DsQXLV4tgTO3uy+MfyfOx9lwVw1g0WXHo5YA/GC8oDwotvwpiKsF9uUB33izQpGvOJfnHCwvW9Ffx
 aFfksCKw
 gYj95qsp66eglkEBdU09aGH5eoSrN/SiUam3XDmLsHZ2k1bWAXAdahefl2N0VZW0grYqrNY1JjLjA/dedxVKaQfC9ID9PmxilqNKBohomMf8+wOho84b6YvIwsjXYM5qGTUg9IsrmyXIRIebiME6iRBajSfjfsKoUc2L3mYVBpjoBPWW3Ry7FzGBsfBf+bdtpQcYV8bUyAJOVBinqymJu85S0VcXyBQPH7ulrUDGbh9UXiOtyJB2k7JWG3NNde4uBwAabr/AKzF+aXmEJa7MSP3HW59FpA2n7gODzyxMaruANWdy/PTd3hSTLhPWhCWmq0nOOLVaohVQ7iQHJk1odNH5V21KcQiSdOyQY3qCp6/PnB3WjyLRJoBuwzg==
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
Acked-by: Zi Yan <ziy@nvidia.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/run_vmtests.sh | 46 ++++++++++++++---------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index eecec0b6eb13..606558cc3b09 100755
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


