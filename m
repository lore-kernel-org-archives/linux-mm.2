Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74FEA10BA432
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 07:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8086B0096; Fri, 27 Mar 2026 03:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D886A6B00DD; Fri, 27 Mar 2026 03:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EC46B00DE; Fri, 27 Mar 2026 03:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BD1036B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:18:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C95EE1674
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:18 +0000 (UTC)
X-FDA: 84590989476.15.383ACAD
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1B21A140011
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 07:18:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qli0IKIY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774595896; a=rsa-sha256;
	cv=none;
	b=NwAggv9eJsbL7gZrIuT2MK3L8vzMsvVxoWMIL0jR+min8FhQ5H9C73Rnfwu37po5RyjgPP
	8xEYBAjb1AF6llm/iK5Hgzik1c/AeE7yMzhfiyfkHFACK9UomO/YWhildl0z63q8niDsz2
	XTL2XKLpZ/ZrY+icJTe27d9AIIebce4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qli0IKIY;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf23.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774595896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJ3WnIZnYp7/93bz2uXrV1uWdvqmlu0SCudoqGbLeGc=;
	b=MjOcqJoSEa5SEtpXNXzVFFW14JCc9/HMPG4/iz3Kwnp8sdzJv3s5jH9ZkAgdJJzPGrW12l
	q2/MCQ8Yp8nXT7QIh2shGUouZTJfkbfy0UK1vIwnLKiobJGGHbBGcuJS3WjptUiF6684GL
	LFHX4UuUwPD7f3vrVw74bvfetF0JdHU=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62QIe7fP2646739;
	Fri, 27 Mar 2026 07:18:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GJ3WnIZnYp7/93bz2
	uXrV1uWdvqmlu0SCudoqGbLeGc=; b=qli0IKIYDwTRmYljX4QoapFFBZYe7v9u8
	JXFWSBCnJa3Ms+SmWXkPqc+7EKEllmYQEBCT1J/7ZuFjQD//6KhJc+GHT9WihuZy
	sbXesRrEC7+VmIqNlu005ec3jYYbUu+aN1IBukt/uemNfTv3lReBnU0PIfLcyYTQ
	ka1mvgJ2iMyPsxPs3y1Z9f4V4hPU2VXIoDxeUF4MAat2f0naR35BHROxL5tg2Fkq
	zUvokZRBwgRncTU7TAL9WjY7pTBpQESTHKQJPkk9Di+1aCcgXJ/bZOscOfKkL6tU
	PyFQ6ASlzOKgNteaDeVyCSTLKTaaJlwDJWXxLoVhK2xNKYXl7HTQw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4d1ky0fsa3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:06 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62R6Vxs8012213;
	Fri, 27 Mar 2026 07:18:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4d27vkeada-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Mar 2026 07:18:05 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62R7I1uY51577146
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Mar 2026 07:18:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D991620040;
	Fri, 27 Mar 2026 07:18:01 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3696D2004B;
	Fri, 27 Mar 2026 07:17:58 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.124.208.5])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 27 Mar 2026 07:17:57 +0000 (GMT)
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
        Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Subject: [PATCH v3 12/13] selftests/mm: move hwpoison setup into run_test() and silence modprobe output for memory-failure category
Date: Fri, 27 Mar 2026 12:46:06 +0530
Message-ID: <a157c2f91d8fa94b14dff44ce5c0dfcce1f8328e.1774591179.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1774591179.git.sayalip@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA1MyBTYWx0ZWRfXxgzcIl45FDQR
 Ye9s6RoLv2Ss5WFiMd0DDouIwu1MEHTjMJtqvtszlboh/AVf8uDOZESH4FdvyofTsqBP93B8UiC
 Aozm1KVJWmLAkXv/HvznLto0dyZu2cbnBO/Gz9xI8q/DNHmG3gRe1HD/DU0ob5HooJaT3gRk3yS
 /fkpWULGl8mF8pIj2X23eqAgkMsFW1e7ammPeZfXphdzZUz4L6vcj9wqIbeBO9YictV9DMHkWlk
 L8/Nj5kp/0BPFIBLY8Tt48OoP6MF4MaJ61IlNlEFYrcK+aVXoa2wtDr2e62m+9QQJBGDdOFm+q8
 Q8//ip/kTwfK0r5SrOkgNylNP7F1m9MxWOKtNc3Hk2ITyH6WyvsbJmKLW4wTjeOTWjWfVx4nlJw
 72iB/PBTABEfidnukRDQ6YDF4e2X9lh7C6NaJyU8tP+VnFwPOQ2AUOCJDlYWnWKrpjzZYTkeuWm
 EFBkYCggokx+Wk0Lo2w==
X-Authority-Analysis: v=2.4 cv=JK42csKb c=1 sm=1 tr=0 ts=69c62f2e cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=Ikd4Dj_1AAAA:8 a=i0EeH86SAAAA:8 a=VnNF1IyMAAAA:8
 a=QWbft6qDQSdZu_5rdncA:9
X-Proofpoint-ORIG-GUID: 0c6pInW84zX2FrRSnmRd63okpmylBB9x
X-Proofpoint-GUID: kIFBbHl4zhazTotkjVkZkSpT-f77vifU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 adultscore=0
 spamscore=0 suspectscore=0 phishscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270053
X-Stat-Signature: jd9xq8oeetahhtctugshzub1434uhx4y
X-Rspamd-Queue-Id: 1B21A140011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774595895-782698
X-HE-Meta: U2FsdGVkX19XJe7K10oObPzpcbO+xl1fRk1SZPLX/ZrXFwRPNi/6ja2mbwfcgysL1ZIdq4FDXxXvZwAH8IXofpqRK9/rDmgT6UTa7+CPgeAZgB6NteoVXptPMpf8CcEO16saNeGo2fU0DFa9os/Tgsfi0xMd5Bpvm9lFaxdQktZFsIC2XHptBXE+oN/nSwlugEZ6TR62SVjqdDOZE25XDfba41Ek/2KV9FRK9lbcrllpq3vzyC3KKbNH6FUKmPBgxDTpB7G0b9rQR5NG/ncGjsTnNQ8I8wznPN6H9QEEAV49wMzyJ4lM3rNOPHAHET3tjEZhNTiGjjK6TUaJf2GYuq8lLj1M18Yo5KAUurorSDCKlTXsjIZwITcYb3fuK64XX5REok4BeGu+gmYqVBW04uVUN86G5mINgwLlwQq718SGY0gNoj1WlH+jNB023K+qsExZ9TCWuJlsjZ/KFR/JXWAZN5wz2iEfPmT6YGFHL7IJjju3sCmt8ReeAlcdijf25/+KotJpjXmMplu3R28bawCIfEGEDbGg/AcInyyIj1kvy/oEVnKgt0exXHN74lqeff27h68sRlq9hKn1DdCX6sdZZWGt8gDnU/JmW629vo1jobgqWaBma9doymItETuC6ayhRHlBDWNhTBRQlImldwN4mwT1n/aXYlFY5aJU7w/h7zE+4boogPkm9GLaDqsAg6/uG7MXzemcIEhBFEfiKEwIdmlv/iGutDArYjGwVLgH7tPBz71Nlf9eoimNXZ5Ge/+tURRPqQhGIHeG8hJdJHMqjPngl0QiyO6G6ibDZa07HjbpUzt4p0NYkWS2IgsX7lCsFhRXYGXZKg76huzC6feY1BbRYbf9pcpMS6g8QpG3tATKyJKAJoMaNw7wK4T0yqMrD35PsHWRdwKhJRVw22yAtD6nzQqQoNZspxWEhw/8mHHptSTRelHQOyJz5Z3f00GHxCmy4QUvYwUMYZc
 fgkU0KED
 lF8jSuO0hrZHvrYwLIFfRtuxXm90ILpv8sWk3JUadlYc5YvPZm/GwPERMT4awIN/wh9HPZdnZYjfwToVExzHevLBP67FEyryxyV8ZrAgB1p0KkSxc6z31UflywfKmdsLXpSdJdACjxfyEpIxhXFZj4NA8+IPNpVgTEMUAW8dKHVI2fkv1Pb9csCBn08Ljx6LVsnfp1UP+ufR369rZKi+BaVGxiEWml7bs+P2q0pxIOsJD2SHlUHyK0zPsUDTRIk6T2PPIxBNNUMHJSBofarfS6SvgMsSrzQf4un7zqnNM5vIv1djHgHwARap3ZjCxInE/4aVAxB1ntEvzup2puwjA+x+TEOHyKDVgngbwuyMB0bmcZkMSKHu5havCm62a9e44O6nlXwON5zHP6gzeyxZjSmODW8ocXhJPm9p8p59UsAHN+qll3k/mdx++w9OiS3/VelB2Ecg+mLd0O5k=
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
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
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


