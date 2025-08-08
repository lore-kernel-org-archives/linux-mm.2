Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169FAC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 09:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8195C6B007B; Fri,  8 Aug 2025 05:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA896B0088; Fri,  8 Aug 2025 05:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8E96B0089; Fri,  8 Aug 2025 05:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A11D6B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 05:22:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BF6CC16F5
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:22:53 +0000 (UTC)
X-FDA: 83753050626.08.F57F55A
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3174680009
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 09:22:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=itt6dD8W;
	spf=pass (imf02.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754644971; a=rsa-sha256;
	cv=none;
	b=Y3rSdCU9U9YvA3oeGlZguDMcQkttSh0BrigmKs4goGnBW5ObDOkK5AxF2651B9q8nBways
	R1MvrMCL81cdegxN96WnXracg2kKJomgxIeTucoajKL7OkM70CrU/2cxhweuVXw2HIwFzi
	0efuOwAtlbmcaT7Ht6gvh7onbKC2dPM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=quicinc.com header.s=qcppdkim1 header.b=itt6dD8W;
	spf=pass (imf02.hostedemail.com: domain of quic_charante@quicinc.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=quic_charante@quicinc.com;
	dmarc=pass (policy=none) header.from=quicinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754644971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rADHQ2onuJoaMUQ4Gf6jGpgSR531YEDNO1qihPw7vMk=;
	b=EIS89XEowQEJQFRM8FodiLN0i3kOCkNAUvA1nns8fM+bI0gmr6siJRvc7wnZTFJ31YD5OD
	+ocMwfsTEyar/yPFkmA0MCjNVKNIyjWDyLwwfNd+yNipu++e87SZlITd8o/496vffmuM23
	ArZgp5vzy+KBzsQwZcuLg3hstQ2BcQo=
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5786uOUr022560;
	Fri, 8 Aug 2025 09:22:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=rADHQ2onuJoaMUQ4Gf6jGp
	gSR531YEDNO1qihPw7vMk=; b=itt6dD8WfUk4+pl/jWNaWJ3hnIMz1M0TWHliyv
	j/Po7k1OiT6i+YXCMcjzaQqTj6yme9DKibQ1WjdDz4SnFDxsvzswmk2WPFI10StZ
	xlR558LatVB9ht6/vvSIOI2ImPlNWjeGXJS7Z/CimK2FBmIS7l388x3tjU+vvxD1
	87HvtXMzpdTBP8HiP039Cn7vh23GazL7Fw6gNveUynf7Saz0Mv5zxvk9YPh/inCv
	10W7rY1v3PR0NTjYbBvswYyurTiiFl5EVGe3pMReQes9iHFHjdxRdaT/QJYXjwVw
	71YNXGtG4dE/lhxAVsWbTEyBdIM5Tl0gpe/nxXYVxoXU11Cw==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48cs5nbsmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Aug 2025 09:22:41 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 5789MeJV015029
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 8 Aug 2025 09:22:40 GMT
Received: from hu-charante-hyd.qualcomm.com (10.80.80.8) by
 nalasex01a.na.qualcomm.com (10.47.209.196) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 8 Aug 2025 02:22:37 -0700
From: Charan Teja Kalla <quic_charante@quicinc.com>
To: <akpm@linux-foundation.org>, <shikemeng@huaweicloud.com>,
        <kasong@tencent.com>, <nphamcs@gmail.com>, <bhe@redhat.com>,
        <baohua@kernel.org>, <chrisl@kernel.org>, <david@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Charan Teja Kalla
	<quic_charante@quicinc.com>
Subject: [PATCH] mm: swap: check for xa_zero_entry() on vma in swapoff path
Date: Fri, 8 Aug 2025 14:51:56 +0530
Message-ID: <20250808092156.1918973-1-quic_charante@quicinc.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=Q+XS452a c=1 sm=1 tr=0 ts=6895c1e1 cx=c_pps
 a=ouPCqIW2jiPt+lZRy3xVPw==:117 a=ouPCqIW2jiPt+lZRy3xVPw==:17
 a=GEpy-HfZoHoA:10 a=2OwXVqhp2XgA:10 a=COk6AnOGAAAA:8 a=cHbpGygnT8J20diWkpEA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: RrDrs7NntZPuiiyarxSr-9jkJetaHlJU
X-Proofpoint-ORIG-GUID: RrDrs7NntZPuiiyarxSr-9jkJetaHlJU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDA2OSBTYWx0ZWRfX6nl+HntHDx2g
 3tNKtu68JV+0+m2fuG9u+8CD2st9vk7aiNIaZP6v6fG/BTM2DNTVQoG/NOqVfcPOyBQwZnx+fOM
 x4DqHE86D7zqwfNxAdBkfPORrRU5ITECD7ACa6xIwnE3F4MVMLvKv4nwuEf/TmWTAKDs1vYi2PW
 Plj6foQJhBz39frsw7cQzS7qlnqn3yXbI//Tj2wuTFl/q2r3qxNVPabQUOYUsjGeYu1xKPIjBVa
 ykps7F+Ws7Lcfc0eQnWI8cNwNup9NTJurT3QyRhTsKSm9FGgeGCNZHin/tR70JdM/Pf8RObOLHX
 fjeaOwHn4F6WeH57MC43A8WEd/V0j7BwEgiFKPaGzbFG5ja1IpthKHWBwCliFITC5cXozOWZ6/V
 ls5/8+Nr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-08_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0
 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508070069
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3174680009
X-Stat-Signature: xu7nmk3fpxa9ffyx8p34tj5brka9tjik
X-HE-Tag: 1754644970-534346
X-HE-Meta: U2FsdGVkX19h/I5Jb+TKlP8q1JyskEJRXGOE4kVTgdc+8QdmRZO02nPplMZridiEMHNNLTNMz9w57CLQ2gNynvixNvDetnCpXezyJ7mahGfjAn3NI2mAF+Vlpx+dZf+uJgv9js3vfPCD63NBIyw8tng4uWCPdhwPrB2arRVcIJI2HEQypW7HF5aEUwNP1roCK7QOmdSKMdIjTTiKN0jBjeIrNyGtjfA7jaGrsuK0vzezvOwo6U0E1NZ7IE3SWSi8MVsU6ejDJagrAhWFkjPeBpfZFcdxyKb7mLsLh87zOUyc0H/nJ/uB7JvgnFXDqcztnrXxmGVs6b7xiOiV1tkjTYd4VmxEwlVMwHAdyNK9GoUR0mqRvD4F4fWZ0WKa2qfP6XDMvVxXybMFV+KHlMI/P2G59NFjGA0uVQVuZLFFHiHx+Qnk6xOYFVCSwQ4oJPDG21b0SOukLUiiD4fHBBdp4e2ATeWUTjkJViHwP0Ud1Dn+MuKsiGhnABTm77yyirC2cn02KdO1c/i1BJdfueWBWcwAr5kKiYJJSWuHxlRCey7CfJiY2kVyWFoUJ0/pTqPzWnYpMJ5j2ksCxw0goVp4yGhygo964hkjNpx66ffXG6H0pcPxZBHAKWZXnFy76xfhsTaaEAZMK1Q69rSkWGx7Vq9lz++yawCUJ3tyMmZV4T39kklMMWmwIIuACUuy4ZFlH9quDE/23NLLZOvCnzBg5TqSVIAdSQmls2gmtadp3HhJhMYmVJ7tZeh7SufAC8hCOcgRexYNona09oE3GntQ4J2mxFjCfod7wUuznzjz+KEw6dB1NBZOu4Hdz15qr6cQItKLPY4bekOFcVCh0CT25fXQv0y2mjmb65Tl7coHc1sfQpEKlaTJiFJJ2djsyAb/FNfEddfF2zGuLztTIdI2cwVLGhRAp83smFmoJtNXVhcPSE4jUvWn9YKTKh02ipB4QW4QuWA2VoH7gTTLOcf
 AXyQoTyQ
 kGLdP1KBICWe3vJEyKRwsT08mny8xuGwcfJYkrRmS/I5KVNxKG9Qo5ORC7y3AaWfT8rlfR28xTqDGI4ni2XDcQYgauY8nf7jp+MjSEeNKP5jLb9aEYhaglBFGwIU+/5KFinQQ41yXY9/lna+jrexRmuxggOA5DF2LnHr6o6ySSC734KZJrywbqLvpwOFkLV0K8pshc8WcX01AQGG1Zz/CMA9GY9zI8zSP9fYxuPgOEmAvYpstCuuvQxp/Bbo9YSprDzPOwppkpb+xWM0zVtkRPkalq3INpuguRO8wApK5ygSg3HLL/2EO8O0wBxzwwkQKYxgGA1cLR76AE5dlkWXdJ5IRRD3AUtV0S2MgRBUxrzz9+OoBYOpt3TAiajoqhJZoyeFq0oPBEVvITAsn3D4H+CZU+7qvJUi9GqGa3DoGQkV1FZRnmdb3DDaFJ6u/3g4USOJd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to hit a zero entry while traversing the vmas in
unuse_mm(), called from the swapoff path. Not checking the zero entry
can result into operating on it as vma which leads into oops.

The issue is manifested from the below race between the fork() on a
process and swapoff:
fork(dup_mmap())			swapoff(unuse_mm)
---------------                         -----------------
1) Identical mtree is built using
   __mt_dup().

2) copy_pte_range()-->
	copy_nonpresent_pte():
       The dst mm is added into the
    mmlist to be visible to the
    swapoff operation.

3) Fatal signal is sent to the parent
process(which is the current during the
fork) thus skip the duplication of the
vmas and mark the vma range with
XA_ZERO_ENTRY as a marker for this process
that helps during exit_mmap().

				     4) swapoff is tried on the
					'mm' added to the 'mmlist' as
					part of the 2.

				     5) unuse_mm(), that iterates
					through the vma's of this 'mm'
					will hit the non-NULL zero entry
					and operating on this zero entry
					as a vma is resulting into the
					oops.

Crash reported:
--------------
Unable to handle kernel NULL pointer dereference at virtual address
0000000000000446--> Loading the memory from offset 0x40 on the
XA_ZERO_ENTRY as address.
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault

 pc : try_to_unuse+0x188/0x79c
 lr : try_to_unuse+0x440/0x79c
 Call trace:
  try_to_unuse+0x188/0x79c
  __arm64_sys_swapoff+0x248/0x4d0
  invoke_syscall+0x58/0x10c
  el0_svc_common+0xa8/0xdc
  do_el0_svc+0x1c/0x28
  el0_svc+0x38/0x88
  el0t_64_sync_handler+0x70/0xbc
  el0t_64_sync+0x1a8/0x1ac

Fix this by checking if vma is zero entry before operating on it.

Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
---
 mm/swapfile.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 68ce283e84be..91513830ef9c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2245,6 +2245,12 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 
 	mmap_read_lock(mm);
 	for_each_vma(vmi, vma) {
+		/*
+		 * zero entries in mm_struct->mm_mt is a marker to stop
+		 * looking for vma's. see comment in exit_mmap().
+		 */
+		if (xa_is_zero(vma))
+			break;
 		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
 			if (ret)
-- 
2.34.1


