Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F061DCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:46:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAD9A6B00A2; Mon,  4 May 2026 04:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5E5D6B00A3; Mon,  4 May 2026 04:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D406B00A4; Mon,  4 May 2026 04:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5F1E6B00A2
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:46:17 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F5598B929
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:46:17 +0000 (UTC)
X-FDA: 84729105594.28.F620F08
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 08081100002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:46:14 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nnfowVV7;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777884375; a=rsa-sha256;
	cv=none;
	b=D88n43jiB5VgSpSfxN3GRUosx8tH6hPUgF7gRKpaHhhw5eJQyr9Xo3gAsluvT0e+JgjWF+
	G4emm1WsUEcTl56K8HK5RSlgGGTDEE60EHyJiteyxYBQuRqXEDFumoZaOUUPtLQV3p82fi
	5exEGkTKk0mHYqsqfBr+jl2T7CN719A=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nnfowVV7;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf14.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777884375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wuvm835NB4tDr/INmAj8E4pEfzootxPjtudzVh0pFns=;
	b=GF6Pd7rCzK4XJBKDpwZYr7yg4BTS6AalmC+wrD3ix7zctqoCK5pnGyu+EnltsmuDjoPbIE
	25YuK4Tr2/LRBPoNoiiC0pvpAplJzrr9iPlnua8uR2iS+UyZ9zo/Odb8A6FLS4onJBo0rp
	9uQDCvZ0svLsL1ClTxQwFtQe8ZoNy3s=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643MtCS23253820;
	Mon, 4 May 2026 08:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=wuvm835NB4tDr/INm
	Aj8E4pEfzootxPjtudzVh0pFns=; b=nnfowVV7WJ0ujKFmSjLiu1dLngaC+0h56
	Km+tYpg0unsCgZDcWTqxiOUrwJSxFviuQIL3RQqUVgI6bSqmiUxVf8EdYUkhyqG5
	368yL7orJcs9MTBsj2QswopQspv2dnRqR7YDX4zYIWc1KeBtarXnNd2Da2wJ+Jll
	ixpCROJJTp+L3mmc1vnh5Q4ryMvQ5y0nuGXNOohnMiXWp2ZtG9O9EABT4fqRiU7R
	N5MoS185VQHoFK7IAZgvbBXgGxw8R9vmchNkbR/50kSOXDBlebmZxMssmv2zatW+
	ZXjgAej/ZhuNg4S1nvxbW9NDM3Uw8h8H03M7ZocRLk8saFMs5PsCg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w65y1k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:20 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OUKN031522;
	Mon, 4 May 2026 08:25:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjma9s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448PFWn16515564
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:16 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D929520043;
	Mon,  4 May 2026 08:25:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CD84420040;
	Mon,  4 May 2026 08:25:12 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:12 +0000 (GMT)
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
Subject: [PATCH v6 03/14] selftests/mm: restore default nr_hugepages value via exit trap in hugetlb_reparenting_test.sh
Date: Mon,  4 May 2026 13:54:40 +0530
Message-ID: <5694336b36daa4426d9ef83a1490f122c611ffc7.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f857f1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=dU9eaedoi-733nYHt2kA:9
X-Proofpoint-ORIG-GUID: ESZ1Ww9ACOP4Pa1VMq2a4JFPKu5oYwYF
X-Proofpoint-GUID: -L5JNt0udyTeDt7vPIB-9fZNtLT5KFVd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX3M6CEdDyariB
 TxeB5wSllbrbWi4qnb3rm20bxKWylCxk9SwPQzxDe/+GsT2LyiZB7PaEHqPQPP/wShRhSL5FCXj
 tndcvPVo82ondwC5x58MgcCOFoayRK/sl7URMoK3gnZkDy8zzIHMN09enND7gSRDVoevi1GSSl8
 TsdN4EVUqJrylOdQT3IPiOg2SIPj23yWPm1KVrgu3T0W8xhDM8bwjHymRIEKkt51PvFBBLp+nDY
 CCLXq1wfckS8LIh35oc+BHOPJPKVpfR3ZcJLgikN5W/RwoqG+K89F20FP/JUoxws5yytRioGm4p
 YDi+axohVazuQHQoDJ503CgdRiln2nYU5F3VBgfrOFKLgshhkczKo2Yo9k65NdO0Wr2QDtMSk1P
 bh4tnN7morVtSLEJlLrUPwhcM6sgFx6gu5ectj83MKp4QSbROTOueqBUNoVFC6qteGMYFUPrV6r
 u3CJ+3kZ5oFQDTMh38Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Stat-Signature: ptiem6bmujjmkmh34iaue896gcogr9q9
X-Rspam-User: 
X-Rspamd-Queue-Id: 08081100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777884374-433351
X-HE-Meta: U2FsdGVkX196gwKZvUxKzQhTIkG0dNMJwzSu6t2B66yIr+6SdaZO17m9dP3egvfipPZcwa/BkWJGPppTpmU7oxlCY6vfh3MU5Oh0NO4j6h6zO60uG1d4pKx6+qQF1zJXhxYndKXRVTE0f4fthW4R+vYRGoNFw8pjCndE4Higfi334YnM2MkJLyivGH9U8JJpFBc/2iWYFUKOFVpVwVnsvqWM3zi7gqAg7jcVOlTO7naxnaymsNPXKjXzyrqjiOzfZN28pXvw0UqrO3JuU0C320VAsRBl510pexue0wL/Cm4QJLFj4tpCJ+bhVJ//GVjMfgoAykoJtj2nRHGsRVAjgsg5/g65a9miCIystcW3XUFMe1qtcA04e+aYd1EFtqJSUPdj4Au1HnMLo7Tan8sctGNmgLsMOVtU6f0VOUb8gpBdH9H/vBAc16Ra12rC7pQLMbWinQvOG7g/xpf52V64oDcRYcQ9Qxrw+Al/oMhj7m+1am5IXvO8rEHKiiBdDg3CAW3hV518aISrGhg4XKhiV5QWOnV5QA/cRddmAEZp5wMw7vQ+dYnblFwgw1EMEb0gNhXnQ+Q8tOANoeMFV0ifUlmrTrDiIXmaPKi9UzYHXu0gIKNl+VnbNiowIEFVgFrxglcmVAKo64owqNBu/KxKBrhFPhhGn+pHtQQm0+APXdQ4ZBrK81AS0UgqLBxLlSYRzls8rQCOGwnxzJx5OeYrcjKnaDYUluNU7O9Il12uiRNJSpF89I0mWIWvaja8Wi0XcZXLPvBWu9gOkO+J3FAqLeq4t7i6e3G5Fbg+3Y56Lb4nQaG7GSdbMBj2twwCs0NR9Dz/Zw1M3GQophDLR74cU1H5jakdIhtsUiX4HwR8ALnYnMtOhsGDdJgqwDvV6Xosn6DUjD+lmCkOsf+LWHpiZr7AzMKTWGertbZo77n7n6ywPuhHuahl4MSjeKkQkfwKSCgvH9ofthEqNXuJaay
 0keOG2I5
 Nx+dgjGTUeNgcmqDhbUUg7Z6WYdhtzhwiNNNYhgGdxdTBn2uc51rl2Svtjta7LkAAcscAyHMwb1/j8+5mCijdcl5RptHIWkEp0/1TKRRyzuJrs7asarGjMyza3fDoerxmVtrXCSPne5uhgtT1qbiW6rGw5NLBRlTDSbeohuDWe/UX/uhqTBr691A+oycJZdk8hyLWjlCBIjlIOSHTlPL78sgmM5QHJqIXlI3JeMMYna+5J8mnVe9Kg2xR5+pEM53NsfMhwAKq2/Nm1VULC5vxyaHPuhmWT9HxXhxkNZZ7ltRW/7kiqUA3WrBMaSp3TqOBdBMLXFsrmYPmoryQMK4+4sXXzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test modifies nr_hugepages during execution and restores it from
cleanup() and again reconfigure it setup, which is invoked multiple
times across test flow. This can lead to repeated
allocation/freeing of hugepages.

With set -e, failures in cleanup (e.g., rmdir/umount) can also
cause early exit before restoring the original value at the end.

Move restoration of the original nr_hugepages value to a trap handler
registered for EXIT, INT, and TERM signals so it is always restored on
all exit paths. This also avoids unnecessary allocation churn across
repeated cleanup/setup cycles.

Fixes: 585a9145886a ("selftests/mm: restore default nr_hugepages value during cleanup in hugetlb_reparenting_test.sh")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/hugetlb_reparenting_test.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
index 0dd31892ff67..11f914831146 100755
--- a/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
+++ b/tools/testing/selftests/mm/hugetlb_reparenting_test.sh
@@ -12,6 +12,8 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
+
 usage_file=usage_in_bytes
 
 if [[ "$1" == "-cgroup-v2" ]]; then
@@ -56,7 +58,6 @@ function cleanup() {
   rmdir "$CGROUP_ROOT"/a/b 2>/dev/null
   rmdir "$CGROUP_ROOT"/a 2>/dev/null
   rmdir "$CGROUP_ROOT"/test1 2>/dev/null
-  echo $nr_hugepgs >/proc/sys/vm/nr_hugepages
   set -e
 }
 
@@ -240,4 +241,3 @@ if [[ $do_umount ]]; then
   rm -rf $CGROUP_ROOT
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


