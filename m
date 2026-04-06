Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77E3AEF4EC2
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:21:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4B36B00A1; Mon,  6 Apr 2026 05:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCC3E6B00A2; Mon,  6 Apr 2026 05:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE16F6B00A3; Mon,  6 Apr 2026 05:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC5196B00A1
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:21:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 904E113A92A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:21:01 +0000 (UTC)
X-FDA: 84627586722.05.B41CBF1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 34E4316000A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:20:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AePv7Mh6;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775467259; a=rsa-sha256;
	cv=none;
	b=rK5rC3se2PaexxrB+fTcgqTyDzewfESAqOzqWmFKmcDI+aE1D67obNu6Aao+NXtKXrv3GA
	dP3y55pzbd1gylOCX81C71MYxd7Qvncm0ZRSKKjHzb2/sebGq3GIQCrReCtd9EKeCQU8z4
	RQA5AWtpo9bFZpPePai1NLbch4MBnro=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=AePv7Mh6;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf08.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775467259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw+rjcKVM5h6GXjQfCYysJfzzPt4h5VbBFTgu6oDlxM=;
	b=emQ4USSh5GGI2LPpCWwYaupnwB084W4zmHcDQPWdt5wvXx+W8K1UbynJNdrSA0tS37aMPl
	dts5WNPW5i1lMrRv/FBRehUZ1SFd5qbAGLGPncOE8U+AakpnDU8mCN/jB1sporXSWHjB6c
	Fa7y+XADHoOunE5gsL3hHtuqCLFCNFY=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 635HrobP3217351;
	Mon, 6 Apr 2026 09:19:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Gw+rjcKVM5h6GXjQf
	CYysJfzzPt4h5VbBFTgu6oDlxM=; b=AePv7Mh6wpi2Ed/SBNZJotX5rwyc0O+jF
	SAXfk9LfzF/c2OGiHrJOejx2ejRWqXITtv5AEm0xyQAO28r+nZmEsr1wSN9NNZwM
	8WByYFGgucrBIzac9VrEf78nNVcrR2jr+56RBFck+/9kIR0l+At2YXRCUORGoNEw
	w/L3XztUrez4u/9R1Id0BBoE2x5/B78qRsoIgsQ+BnYv030v1fRXZEgk6qIpB5+0
	gzvBNbAa/Hcowou+7NEM2uwRiv9L5mqhX+NLxCbQBg6eGX65kPP52vKE00vW6eqS
	e7D98FLTJj1I43XFxrmlEKiVuiUdC0xEw0NSMHnUTk+eZdTDWvrGQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4datc2nwgu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:50 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6364jCgR018517;
	Mon, 6 Apr 2026 09:19:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dbcysv7at-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Apr 2026 09:19:49 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6369JkDX28246616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Apr 2026 09:19:46 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15E3220040;
	Mon,  6 Apr 2026 09:19:46 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A83A20043;
	Mon,  6 Apr 2026 09:19:42 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Apr 2026 09:19:42 +0000 (GMT)
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
Subject: [PATCH v4 01/15] selftests/mm: restore default nr_hugepages value via EXIT trap in charge_reserved_hugetlb.sh
Date: Mon,  6 Apr 2026 14:49:20 +0530
Message-ID: <8beb895ae46c3e817e80cdd5386933cdcf8e233f.1775466329.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1775466329.git.sayalip@linux.ibm.com>
References: <cover.1775466329.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA2MDA5MCBTYWx0ZWRfXzyKLtulSDSth
 IFqReIpcfgL8hR7NqxmS2WDI6atp0Tuwnpsep9+D7WP5qLtCinM6WdACbnC2x7ZZgR/4Z9mpqbP
 upl/AOBOoEiCZyb33rW9p1as55zdcD6nUk0vuJsWgJ6U78oM0IULBQo1hPPUHawmgr2B0rUOn1h
 QqqvTCNv3d+tRb77WvDuPh/AqVxnA8D6oPBsNd4+p/wFa/mtiWv9UvMVGqqbm+DABCRgT01TdjP
 9MBEN6AOsPnSRR+IHqw/1aXEGvOJSHKSbwAsK0hAkDVdzJ+4mvWIWk7nre7dHhoGRR/hL083x0n
 2s1jdLxeEHgRbQZ1LUn6zzYheeBIBY/tBnAPmp8DanxWJavbaDkq2klA/IFelFNhhqSPEXezsxS
 s1xpsAKk0SBvswls3ZZTPIvXRUxqUw0ws+JjRw5SCxH0xbo940n0DYnAaW7pCy9MLvhwAGhpbK5
 K3zpVns/DplhG1DRvgw==
X-Proofpoint-GUID: nK63GTggKdNRTYW7Z81LZfRvqmynf4OA
X-Proofpoint-ORIG-GUID: J-QzRBArbcHki7t0X32IBjJIHzxx8zwY
X-Authority-Analysis: v=2.4 cv=HJvO14tv c=1 sm=1 tr=0 ts=69d37ab7 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8 a=C3DWCGp_6AllTJ2cH5YA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-06_02,2026-04-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 phishscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2604060090
X-Rspamd-Queue-Id: 34E4316000A
X-Stat-Signature: fcrg7cjtgix6k9iimat7td13as7gda85
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775467258-962655
X-HE-Meta: U2FsdGVkX1+eQ+wy5bBadC6kmbxgC8+ApFljEzNMYySI/R1c/sHlHzkl6YNYQ4wOO4kjNCRSLb2e+MXM5Iv9ZVvMuA2XrxOjfhMCaTz/4zCQvnteIR9b6kzxVUi7xHhOvP6tp7oco09G17ugBagF6xGcdsAjuAJgRkUkUJ6GKkTYsFRjx1BROVUX9gINj4I28ximpAYQxRRMXJ2FFueB4RGSFvIECaki6oL3otvfeKxy6LsjEu/T2IjkU0f6PrtGQYJAntRR9phqzgC1oFIJG1zMzjhPBFXVBLkbAHjF8oBh/gtT5IbtnAncYW4wDO6jjD2xMQ1Mhsl6MpkjolmFStfHMsq0vSJDbY+DWSfn+wxPTYDTHiESoKSM8mYO4Zm6LEEWo1MgyQnR3qgldJ4iPvuAup70C1NiUZo69UylUYtIkManlOhid3+7J07zRjlvjT6KnUnv8tRiByAFNm1cyNE/aXzTqmL0EuD3GCHgp9sEaNdtTEhPVdHWLliV5dgRTAmFrjG5dOZbzLPvzH9ycnV1PC+e0nmQXJ9wxZoDje8K+g9Ug5FXB58gvz5z8bs43mQIyujGjoQaV7M+fCiJZnsaC41qY88h3IkHNpfhriAlOGMJZ8JMObmrGTvPzX5MEVCMY5PvNvFOpZVJUpOOnIajqCZFxpZIXrkYzK1ixQTvgavbPa/1ziqrJm/ses1+Jc3kJ+A1Quy/2MLC1mvuN7gRKFBgER+EJSMh3uSv8JGh3Ru7hcErlTUJ7QSzKtuxFZVPKSwAZi6PiX3G3lJiM02JbolVAUsxy9MVhXs19vUMMovqkzmnhSMlngQvN7yFzTQpb0nprFfA+sVz2FuwJ4JCzmTjve+Btcpsr1HurTKXsrtTjNw/0WJ5BujfAIee+OvSTOJFeBAZ+J3zeUBhtIpHQWGy3Sj9u/iWHrpc2MrFxOZ4670AMN+81VMAWNUz9V2ftPVXGO5d+/rDdiA
 0lA3hNaE
 KPNZ1P+gZqP057irUePy3WKv9mkh60NHicJvyQL4C+cPWMyDJ5KhijkBU+0Li5SGuVM5fE/eXyO1UMLO+OaN3wS6YLZOOJEY1ODDArKaqYpYb1ZeA8iIdOXiiGJao5axuysN1s80giVa61I0ohHeEZ4eENEBKIky8PrcpTBT1RZOD1A+NrrBYPt4MXzvl6ApKs8Hp2V4LwefUlBgpTY0p54jYuRcZc+W1hSqAtNdy7oBrYzAAT3ValmrTf51FVltwXYwZ2BXK9wu3xceqFnADsQjlQxa9POQ9MOlYm7eUxtfS3BZZsBojjPfSn9JTEna3hHEnvw83HgCljdu3IZDkEk/Fz3Zryqk5jEfrixlJ5h0QQfbO1ODpGtI6XHNNdTVBHQmKE9hGkPDPryjuou97TWr9/ruzYx6ls5ts
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


