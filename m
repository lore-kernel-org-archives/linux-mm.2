Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6909ED7B8A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 08:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FE96B0092; Tue, 14 Apr 2026 04:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 172AB6B0093; Tue, 14 Apr 2026 04:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB83C6B0095; Tue, 14 Apr 2026 04:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D9EB86B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:22:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A13EFE34B8
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:39 +0000 (UTC)
X-FDA: 84656470038.19.10F065D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 606751A0003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 08:22:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pTv0IWnX;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776154957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OL43+Qixq8NgL8gKJjs/kQOtTy1xSAJwjYGBdErthg=;
	b=xUWilZJv7quqMrhS4rN6LsUFpPFwg5x62hlCZDhjb9pUZlFhvGJKrm4Eg2/n8QHzkAm92H
	WEOT1hy2G284fOzsUAz/Yjv3sgCs4nAHr76+sjIzliZmFWgAbo0GNj8RQIMUTNatiMrFqi
	eyTpRmM8EEhpq0jr6uV6+ge78SpWtfg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pTv0IWnX;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776154957; a=rsa-sha256;
	cv=none;
	b=QFbMb2l8ggD6b/kIP/4/QCHO2kzJUa5eIMyIFjbv+VZ6xrzxEc/ktSmPRM4VPyg4inGePq
	YGqfjx8pbkz7YA7mAkR75FXoJyoLxn479n5USYksjG1B+OE7/7nWOwV5KLpvy4EiIrWc3L
	XvW7ubstkqoPBt2e79TD2pZ2Z0mEahM=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63DLIRmT1804741;
	Tue, 14 Apr 2026 08:22:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9OL43+Qixq8NgL8gK
	Jjs/kQOtTy1xSAJwjYGBdErthg=; b=pTv0IWnXpJoJqvZriVYqS/+RtB/NIgEXO
	00ZUSX5ZGZ7wVmXfaYJsnIJnx0ctYppJxDv8KkAOZm5kIdwpeYyQpTRGP/Hxi1OK
	5aZTRfdlOPfR4Fm8e2CGICnIloSHoYi6fjO82aAF0wZImyGJk43YRH/EtIZK7BiD
	1ylfOb/vJ2T2zgdTJMnAnWi0PD7aacaHk9nnS8i7Qt5/9Hl9eqaHaE1q+KOpOd8W
	q5cw9MnSEF9+zS/jXZkBELh8z6YaOFElQpcW8HLzE5pKVgkShFiEtUda5ZmtdGoL
	jXmcg+tjmZRXZegBMnN2KeOPU2N6+nAN8qqs3pJo8Ba1WnJovlwhQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89k1pfp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63E63xgp025837;
	Tue, 14 Apr 2026 08:22:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg2ujgeac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 14 Apr 2026 08:22:27 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63E8MOmB40894782
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Apr 2026 08:22:24 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 114C22004B;
	Tue, 14 Apr 2026 08:22:24 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 12CDD20040;
	Tue, 14 Apr 2026 08:22:20 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.ibm.com.com (unknown [9.39.26.223])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 14 Apr 2026 08:22:19 +0000 (GMT)
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
Subject: [PATCH v5 01/14] selftests/mm: restore default nr_hugepages value via EXIT trap in charge_reserved_hugetlb.sh
Date: Tue, 14 Apr 2026 13:51:55 +0530
Message-ID: <8beb895ae46c3e817e80cdd5386933cdcf8e233f.1776150071.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1776150071.git.sayalip@linux.ibm.com>
References: <cover.1776150071.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: snjbpVxXPWmC0-popVHGrUdo3dzWp4xd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA3NyBTYWx0ZWRfX7OCa65BG7/Li
 g2sMpDT5osBrLXUoiQ+qLn4mCYifZ1Zje+u66AgYbVJQruN3ZXtX6kfs5NjsNvhS6pUKienNHbK
 ttbDQw8o+3j8GxTp0qEq3ZDdM/wuJ7ZVIjH5mnngjTGqrv6d8j6Fh2E2I+ENvWibgzAUobbhuIY
 L1CDV0OyVOKaExArVKov2lvBZhv3z/xaHCl0ZKiDn3YQ6kioCAIk9pt5wAN4tt2X+u8waAv01+N
 SD6tcfKEAE51HpdNi+1I7Xv3NYlpeKdx8zk2oD0L31w0izDxTtmgRPY0R8ayl3p3Ye79SzgHKTL
 DzTpJuJ5wxaMIlUSWYIdaACwmxFkqjvY5doICefEsVcBy19ZZ+TdJI4OUZSeZLreaRAL9b01vah
 apdMHHtdFEhODncIeHoMjW1/v+Wbxcs9F7vkvclryCqspfN8VquonuXz8wNwgtZZagJr/ltvKo6
 PC8BpvXxCFnX6M5Gmaw==
X-Proofpoint-ORIG-GUID: vKpf_qrG8LF6PtRXb_qgjBhkdG5VpAk2
X-Authority-Analysis: v=2.4 cv=W60IkxWk c=1 sm=1 tr=0 ts=69ddf944 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=vtM6K80SjIFNW2yxelUA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 priorityscore=1501 spamscore=0 bulkscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604140077
X-Rspamd-Queue-Id: 606751A0003
X-Stat-Signature: s67ehqat466ariu49y9xuhbtzdywatmk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776154957-741091
X-HE-Meta: U2FsdGVkX189CIYqyj3qgn0zyY4V5WFhq4Lr9gNYmrThntJlbu3ay0smWhU3PGjXh1nuckWTG24v9xVGcP7di+Wxn8iwGLwKv9j5g8MUJv8UA+jCNPNMjd8Sw/ymfcAmJg/9hy0bYRdt9HJPOkiKDl8YSmkUKjk3Lm1FOt/ST+KmLeV14qpDIFzeVxnH5cveghxRYLJFdeDMMkQ6zTyTPOnMxKNq4MFwGgHSdSm27G5XsTeys/Shm2mLtzpZ3KD1V8JxT8zBecZ3Adh7Qah/04ApV9BjDuaYtXfcIMhrjLgOqnBLt4QwuhUDAGvPSFI68hIZBsFOTbC5KZiZde44wzEO2JIHxXP3jM6XL3clRtRadw7J1NBjdYTiT3Q7MvOfYOxzKATo5G/Xezbpm42C0FxW1lWspwp4snyvF/DTl8Z2MxcLBKi3FnAjaGQa1rOML+B0tVvBxrx1uJ7X0S0UNg1m5G6MPrGEnPWx0fIcQVGOSShqFRg+Mg1i5pDt2HqPUadJFNiuMLRZ+DtRD/QeOFsuxTyg0S5xKro08xOBtYlkDd7yweH6h+Ku8ANXD76cvJ28+cpVUjZuYqxMLHrkh59HVcPCJAHIjdWEOqa5gw+AtGUPfW2gQgdTk96IMwlw12JmSQRRCMV4XGaSrn4ySHqQDJaU5FOFwOtQKv0u7AaB9jMoVQYiZXZxpeu1kKSexQx7d38g8/NGrqVne+DyM8SqgRpm5/+1qQiX0U5EV1fZHcyDTfY9m74e1LJRnSGkNm/dOwP0HUbJcrd4/Luhc4zasP4spzxp35uAUT7e39mD4eBeTXNsLpf/AOv/iMeYT5MsRf2nMqUBvWDU7C6EZwjvgVib5e078B+FDYllVnHiscI5o0yeQwBMupSnFOfnI6QggNRItYedP/gtdehtgbRWIAi1TzR71eclp2a5cEmjXSpBrg/7upSLr13v/maXJdSVrqozJt5GQc78nYp
 rZk78NIt
 8enTIi9/Nf/wJ8pBKH1hnhf5wzVqcbggVLQ9S1+JQvNLjmRc557B8KvnRoPl8lNeFqkbzBRdzU9gDsaqBMTi9JHjsHSLtrr7F7VVKcuU/CMKcrGy2es3FjxzMdr8C5Eu5UHOeakQ1tc37Kvo26UlHvTjxyBDeFu+3LA80ufCgKMcPtwVQ9MAKMf0GQGlKaGcGAPc8d0j+B1rNnvhU9SrTzZMAngv4L2jtTeE+KM7n7/DKYCCM3Bqz42ZXNrZLqwT78h9XXDLuvA4QpiCzNh0t2QvlLsF5XLAw3OC5l0Z/pLrG5zRxu/o7J+O0GmUjWNKxdtmWCXZXFHhf4Y0JocaVmndrF2Kv472u8xnsizwcKPmXbee51YVr0g0t0lBiZaItNlu5AAY3VLuoL68RVm7aEGREbf2lRyiBb/FYsIdw3eB9zwwLSk4fuMF4/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cleanup() resets nr_hugepages to 0 on every invocation, while the test
reconfigures it again in the next iteration. This leads to repeated
allocation and freeing of large numbers of hugepages, especially when
the original value is high.

Additionally, with set -e, failures in earlier cleanup steps (e.g.,
rmdir or umount returning EBUSY while background activity is still
ongoing) can cause the script to exit before restoring the original
value, leaving the system in a modified state.

Use an EXIT trap to restore the original nr_hugepages once at
script termination. This avoids unnecessary allocation churn and
ensures the original value is reliably restored on all exit paths.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 447769657634..ca33ec83ebf2 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -12,6 +12,7 @@ if [[ $(id -u) -ne 0 ]]; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -65,7 +66,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -594,4 +594,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


