Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D18CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 08:25:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1666B008A; Mon,  4 May 2026 04:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A23D6B008C; Mon,  4 May 2026 04:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390D46B0092; Mon,  4 May 2026 04:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 282F46B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 04:25:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9C171603C2
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:33 +0000 (UTC)
X-FDA: 84729053346.20.8E4ED90
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6A901A0007
	for <linux-mm@kvack.org>; Mon,  4 May 2026 08:25:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ovj+vNNt;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777883131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2yZGEA3lho6ftsaxVq+LrAKP95Gff3FxI3cY3B/TaU=;
	b=kGduUybpFecHNjBbmYMjWyI7rqiFi6WXO5kLsPwl5u3dgYOecpCQj+mC1WKFmXiSopL/bu
	J8UKquQ79ukbwuO6h7HUt2UGRWfelpm7hBvWbFoX2a70azeLGeTy4QYw5u1SK0gWS+ns0w
	f6aEoN2ycdWpdSA9s0BsvPpOKBbTgmo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ovj+vNNt;
	spf=pass (imf19.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777883131; a=rsa-sha256;
	cv=none;
	b=nvwNCrmElVMwJN0T7M71MsK2PN4cgYznwr9l4e3JwGVl4HvXtI/Xr8EcW6sn6XJxknQdTo
	0Pqb2K3PwerFSKHoceF0Jjkya8G2EhjNLH7lyRVx8OzQbjq9eJrl8VBLMhR2AftaBzB125
	tVzrE3sqMgFHrnE+0+zwTTByGnD3RJU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 643AFnkE1812526;
	Mon, 4 May 2026 08:25:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=w2yZGEA3lho6ftsax
	Vq+LrAKP95Gff3FxI3cY3B/TaU=; b=Ovj+vNNtUfZC/45O0hXPVqBkNYrv19xZt
	RNQixeCn4w+mVPra7kTg83rKsdZ1f/UY2Uexl7uDc7AdD8pcCe8eSP2Jnt2+3iHM
	ugbh5i9YunYWkY5ZXUuYyLYPamBg9kLazHbmVMT8oOa6FRgTnG354OgWJeTd3TXG
	Gj+ogfzrtxhWoZXS6VZW5o7SzlygBD97yeykhc1f0Cd1806BBdXALLx/AA5y5Hrk
	uX6jYqBh7n/Ii6BkrKsL5JWyQW2MhindRkto3OyjFaObXYgjtNJRjhdCi/t4iiWG
	cL2ICV0YdBGw1H+4w2II48ikWbjH0gWBj5iIP7O8CjGbWxiLCpDVg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9w65y16-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6448OOKk023532;
	Mon, 4 May 2026 08:25:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwuyvve85-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 May 2026 08:25:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6448P9KA48824702
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 May 2026 08:25:09 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3AC920043;
	Mon,  4 May 2026 08:25:08 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3B89620040;
	Mon,  4 May 2026 08:25:05 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  4 May 2026 08:25:05 +0000 (GMT)
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
Subject: [PATCH v6 01/14] selftests/mm: restore default nr_hugepages value via exit trap in charge_reserved_hugetlb.sh
Date: Mon,  4 May 2026 13:54:38 +0530
Message-ID: <94e79f92aa370c2551cd909bc9ecc0cb8910492c.1777877814.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1777877814.git.sayalip@linux.ibm.com>
References: <cover.1777877814.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=XPQAjwhE c=1 sm=1 tr=0 ts=69f857e9 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=Ikd4Dj_1AAAA:8 a=VnNF1IyMAAAA:8
 a=vtM6K80SjIFNW2yxelUA:9
X-Proofpoint-ORIG-GUID: q-7WBIXm0DtVv2ifKTsa82aV2XnFn8tc
X-Proofpoint-GUID: XLwWjEuZuHE0OgZG4nLZ8eFzXm6GFpDl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA0MDA4NyBTYWx0ZWRfX2rd8cF30XI7q
 rr0hD1TdGSEA1lpoqCEAtAm1XLD1JZ8CSJoYS3KmSYJ1mp/5jI89tnPBtjW86L3//dejv7iG4rt
 W6+nVMPVD549wKKWOQX8GkxmlF68RKxEMoNvnsZscDrS36VXRRYDIxS0eh6D3dkwsU2dIwVrapB
 QuQHpF4ceqJ9sUQjz7VeGNRm8D1SHN91UQUcrhcEm3AaXHlOwqJseE+fgz7kHOv0mdMhOjSGGUm
 TiF4JfH5MRINeAiefHYurps90lwMk2lk89+zFslJeskxrcLE1/2N8H+iUQtiwJAWKvziF/DDOd8
 TGxbXvB+27rjcP2odUcIe34jl53I8Z/kMORMfRaQdMEZhpUwxhZjA8UkpPZHe0tgku+YjQiSw5R
 navsIcxU/4SkgVsLFjYMRyo8PIX0/Ib7k+54NUnpFNaqeB8cK+flsO4uXmGAiSupYbSlVXHdIRT
 GQGSNGoYhfN+4jXlBXQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-04_03,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605040087
X-Rspam-User: 
X-Rspamd-Queue-Id: A6A901A0007
X-Rspamd-Server: rspam06
X-Stat-Signature: iu1widamqnrju3secw65h6n3qs4u18xy
X-HE-Tag: 1777883131-644985
X-HE-Meta: U2FsdGVkX1/TYoagc8xHUcTwYTO7L8S5ABGIJ2tZKLLCLZEDh5Ry5PvKTny3lzkZemKsJ7pFNLvKUVAzKO1hc0dE/YItYvNXEF8+Th/PqP+ewK8g7Qg0UPth6dhvr6wnj43CGcB/szqalLBxZARSbiZRw0QLKXwK77BYY+rIAak7cQyMzGBrwDp8N8MgzGGkjO3lD8T2QBR/VEW8Tm6BJm413x6ycBDEWOcT6M07WW8cQeWfLVut7fOYnVaQJ5EZ3PrNZ83uCEPAhAH36GSLPleyMPXZYklNB9QsYW5qQwIdLNBD4V1MrBFP1Rn+bwEYvhjd5eJp4ieO2TYXUENimSPIJjIRXk3Ndrm1QXuSIgqMJlx2BWLl+oeFLEJ13zmV5AzEzc33npSTVkiIPly8+0fJ0NxRQzQpQZ54z61tfEDI96WC8M9W+EMycO3LFEAULI9uv9WfJNxH0r8yAcd9ai6VTo6NRMPeUqqIf+DaN+Rn4Kn3Msy+aM754A+9OAFxUkidMt8ZKUcAMvU38aMzUrZFwQhMrBqIP5UxqmEEaVUwCYbtHs1sexWVj0337vmg7Wdf+kfu6j8Z0JoJE9DnK3QRlGNkv7NhH0cKSPMHojIuppF83eIVPeGu4CRq1kAaH7ULQr9DWjwCpK9gtVOe/PSw6LhoGZnW0mAvmBBiRg4R2Ikq6ibVlWxSahhuTVsa1G5kr2Us+fSj2SnvlmXRVYYZXYvPnZGa7UDRll8vZdORba1HN76KZYk20NBfiNonS+8qejgeQFvO3QPIQBHZeoL/MGWo66kS4zqVN4LkDl+VofQ38f24cpEbRI91lWjtchhBkhh0ZjiJz6IIGfgJMQxsrbMd0wc4353nfqio+O/sohyGdxEc/QL2h+Qvy1MQUTFDSImud4w8Yj1sfC07lyUPkxHeCvECxPSUNEZ333a7wYU+aV+sXHkTSx0INQw3I98HnrPfU0wFMUFgarN
 u1IQGZkP
 nuCY6u/9lQ+mVyT7QTl9ybWYREfe9vTE94Y6iSpeUweGmJYWu9Hd4+l7J6ofRlLgHdReJw2wnXVG7HR9sMBIR8wVObTRj86X3P8CpQXmuDfZ1MPxvwodJqL7CJ2vMqTcCTzwfjgNSiMbofrz8locQYHg0vrhNW3paBcOpsNR6AYTpTHI+BBH9jGDldpJfkCgOM6m/KHoi4xQoH6/l38GHeLOXzNu/cKi785gSIeajsss14a840yai9P0z3jfqm3hwYXJ0AklxzZKfMDEE7KxyAhXe5MlNzT5tHbzKKxBOVNTOR9q0Rmtu6ZYO8o/k6gFl00qPXC57/sJYiHPKBmsGpMr6gw==
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

Introduce a trap on EXIT, INT, and TERM to restore the original
nr_hugepages value once at script termination. This avoids
unnecessary allocation churn and ensures the original value
is reliably restored on all exit paths.

Fixes: 7d695b1c3695b ("selftests/mm: save and restore nr_hugepages value")
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 44f4e703deb9..e1945901fd20 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -17,6 +17,7 @@ if ! command -v killall >/dev/null 2>&1; then
 fi
 
 nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
+trap 'echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages' EXIT INT TERM
 
 fault_limit_file=limit_in_bytes
 reservation_limit_file=rsvd.limit_in_bytes
@@ -70,7 +71,6 @@ function cleanup() {
   if [[ -e $cgroup_path/hugetlb_cgroup_test2 ]]; then
     rmdir $cgroup_path/hugetlb_cgroup_test2
   fi
-  echo 0 >/proc/sys/vm/nr_hugepages
   echo CLEANUP DONE
 }
 
@@ -599,4 +599,3 @@ if [[ $do_umount ]]; then
   rmdir $cgroup_path
 fi
 
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
-- 
2.52.0


