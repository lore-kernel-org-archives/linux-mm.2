Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A90CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 18:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9668E0008; Wed, 24 Sep 2025 14:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990B38E0001; Wed, 24 Sep 2025 14:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880688E0008; Wed, 24 Sep 2025 14:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7606B8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 14:12:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2E26136DA5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:12:34 +0000 (UTC)
X-FDA: 83924939028.15.FF3ABF9
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 72B4740011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 18:12:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AjTofCm9;
	spf=pass (imf17.hostedemail.com: domain of charante@qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=charante@qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758737552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O4omulLn5ZHPtQYuvLDXZ8azyeT5lmg6t828yfUSfUI=;
	b=WJVV4YNK9Jlkv9AO3V9KCV7MlXpPXgGMIzbAPwSP3TGPMNAoTcAkY2MwlnmrFONvsc4ZKD
	x7gk1JNwifnLvnmPbniQ74yPlm/IKVYpXEVsExyHMmZ1SHORK/M3EI2ZWUUjBCfT+QtFop
	/3dvGPiGUxhzKmXZJ4OGseOv574QbeA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qualcomm.com header.s=qcppdkim1 header.b=AjTofCm9;
	spf=pass (imf17.hostedemail.com: domain of charante@qualcomm.com designates 205.220.168.131 as permitted sender) smtp.mailfrom=charante@qualcomm.com;
	dmarc=pass (policy=reject) header.from=qualcomm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758737552; a=rsa-sha256;
	cv=none;
	b=V0YoQYnFknhnPwU3OltLRVuaT3EiLRZL/Dt6zqrQGWARfItUSofsyTuoDlHPrksuZIgDAU
	F+0hIvUpwQ37o0UHxCo6nyuFaNFbLWvNEh8BFaZQpAQJRC1r3hHD3xA+2iVQmbEHz+H5tv
	Hd8tCFzdK9xIj7ComwBOwChGcjKG8rU=
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58OCGQbE016438;
	Wed, 24 Sep 2025 18:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=O4omulLn5ZHPtQYuvLDXZ8azyeT5lmg6t82
	8yfUSfUI=; b=AjTofCm9BD6MIJMh5eDp0Y84ZOJ90EQV59K+Lfzp1xhAzYw+NHw
	pNnKC9xfE31tSM7PATWD/w4CSN6eufXg9N/HnRtb/hrbNUBTF70whL9N2oU7GDzk
	jMXvn6F54JDjc1n2THvOse7SQMjkQMTac82CEa4A0mKW+poX0aYqyDvRyZKl+6Ni
	5kd2bs8dl1JmwzSn1QOIVrX8dctRhUPsECwVErI4YC/b8+ykygSJLTYaFr3IjdHj
	3wDyY90Z1FAzKA+PygQhKnahk1/Nvr9Xh81SfundLL2mwluGXxYfsdYflWBN79eU
	XkytPJTruEj9bRGTaoyLRoUFoZWVVym3BHw==
Received: from apblrppmta02.qualcomm.com (blr-bdr-fw-01_GlobalNAT_AllZones-Outside.qualcomm.com [103.229.18.19])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49b3nyh64j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:12:10 +0000 (GMT)
Received: from pps.filterd (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTP id 58OIC5bY011808;
	Wed, 24 Sep 2025 18:12:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 499nbm3xxj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:12:05 +0000
Received: from APBLRPPMTA02.qualcomm.com (APBLRPPMTA02.qualcomm.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58OIC544011802;
	Wed, 24 Sep 2025 18:12:05 GMT
Received: from hu-devc-hyd-u22-c.qualcomm.com (hu-charante-hyd.qualcomm.com [10.213.97.134])
	by APBLRPPMTA02.qualcomm.com (PPS) with ESMTPS id 58OIC4P1011797
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 24 Sep 2025 18:12:05 +0000
Received: by hu-devc-hyd-u22-c.qualcomm.com (Postfix, from userid 389980)
	id 00BB1578; Wed, 24 Sep 2025 23:42:03 +0530 (+0530)
From: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
To: david@redhat.com, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
        akpm@linux-foundation.org, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org, zhangpeng.00@bytedance.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
Subject: [PATCH V2] mm: swap: check for stable address space before operating on the VMA
Date: Wed, 24 Sep 2025 23:41:38 +0530
Message-Id: <20250924181138.1762750-1-charan.kalla@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QCInternal: smtphost
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=EuPSrTcA c=1 sm=1 tr=0 ts=68d4347b cx=c_pps
 a=Ou0eQOY4+eZoSc0qltEV5Q==:117 a=Ou0eQOY4+eZoSc0qltEV5Q==:17
 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=COk6AnOGAAAA:8
 a=20KFwNOVAAAA:8 a=EUspDBNiAAAA:8 a=jVo6M1OS4bf5ToXj5xsA:9
 a=TjNXssC_j7lpFel5tvFf:22
X-Proofpoint-GUID: rAvLsWK55bo77kisLkUd92D1by63XykS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIyMDA5MCBTYWx0ZWRfXxgDJyEgOzTUT
 EhUjGS7R704IPssd/ZKTLopig+3g/IdsZJ1VQ8vOsKcSy/mEtrDdy5UopV9FFz5TRJ5wLpzHG4W
 dxG44dLLO0wYI/JHID1f9lWr+tf9Gm1m5XEsgI0p5VjRpNwPMri6H4IWUdRhp7AWyj56Zj3DV5Y
 hg9Sn1kTySAz0TUovAfbBR/vezVGqpaQs0qRSXQCSrcqmbWbZ2ae5UsX6Cn9tmXniS7rC1Scwrn
 6C5go49eC4AG+dfLng5H1E6LxxTN0/ZX9RWXGBvLH3mSOFctPVE6+Ss9xSogj9XMH8fa7qbb1Y1
 xZPqC/agUDSU4ZU4ZgqhF5dxzL1Su08veIJL7I3BsN+XPbOVzR8i//pNQP9j6oUqDuNKKxi1eTR
 byplllkY
X-Proofpoint-ORIG-GUID: rAvLsWK55bo77kisLkUd92D1by63XykS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-24_04,2025-09-24_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 adultscore=0
 clxscore=1011 priorityscore=1501 impostorscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509220090
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72B4740011
X-Stat-Signature: 1137uiwa6zzizdsxrgypoq8ynr4br74f
X-HE-Tag: 1758737552-257908
X-HE-Meta: U2FsdGVkX1+9+T+v8fFpN+I/f2ih8TAPC+EJThJNPQlNLqAvmWf6VVOkbi2DeCQdsOPtAPmIQRm9k8/6Opmb0zgbit6M5Vpb+SXYxsNsAhj9E4GrynQanFTinEQ2K+Yg9kErVMTsZuu8lqZMEUzqfhkMZnmj7YQlStoOXGaJubyAoYPYoXOEsblsFD26/66l1Qh12yORKq8ndFyxuADCbchI6gn+5uIRc7vdSEzXs1DRJfw2wO2FPBVz2LXFcJ9UcSww9N4omIa8GoqQm6E7IRCvW8IvFZ16IvvaaJc9e9eamQy4Ca+2VBGeiBB76NxxYrB5aRDrzHy0PJ9dUkdXWC409sGCDN5vBYhGDOqK+VHLt4ePaFHl9R0HBjbPEFUvjkbOikoo2OxTYG38u8tF+ylfPTjU2U6jJbjynZBeOB2S6a4RZDw9UP1PeIE2gbIvN3zh7qe65UhD2jAguGfUJR1qJR1bvZ5ZMnB6JEk6RNjYeW51iTc/U93hkE48hRSluKDjmJfXKh75dV9nptUirpvjRpaabFHjEF6Fx6ZyPvtztQYJ//86T+amTpE+2sG2uwL8uTkk3NGzV0mYjJOxhljsVo433DJIsCAR4zYcOtoIzDdQ8YSGH4ttRprW2O3ebHIGpdZf5WBBc0t9APD3jtTowCZdt6a4h9Cg4YfWulsagrokr3ga5327Qv+E5eSyl7Rp33DU/tLm0eQk+x+ia6b6hhDvUg+cEie7AP9wzzKCMJxcBHkp3zP+kIYXHbTyVjYNzLu60Tkg4y3qMjF1yzUjTZ6FeuKceNBQkYTKGrZC6wyrOlqj0C4AuC2YF01aqyLAMAI4TSqzxvnMYGlcmoJ7/50Hjwk6ecn9anY4bxvhMSaUU1m5v0DkSLY8mbUCsI3ljZ6udw4LTFCd8U2F40VenOXyt6TCts19YnNIwZGJg9euDGS6SrUPN/+1n8tiXLGlHvG+vuXreUXtM+p
 VBnHMg99
 EpuQCGTLyL8NwUHHAAgCWJlc+ZEKdWTNkWUuPMPyl7mObOvB1i+eN9BjaZoosfD9LzAlJsSLvs2nm8bisxl5/8lzZSgBOrx0O4f5873TW8+RBHrXW2U5OFK6Pb1Tz5bC2S4OilZ7o22IkaZJBS02X4iABB4YwJRM73tLvFLhcZldSn9b3YkJ9/zOY6ysuBhKw+qR4aOpn1TntcR0XuIz1zdzElM5kISaksdQ4nbMpSAHUhLJeCI/A/Tx2w3aK2vVD6KrDneRFuweyhFSPrctKyUM38H5JjXvaoThd3kyrc6EhLtDthsuYFHQIrHi+85+QTqpp0gr77FA57sINya/VEFvLUiq1SXILt1WH6QKwbHOb9hvnkM684NdvKvXJKlHWcHiP3AairqrKIjmbeElfqy/fhgBUSbJRuTBuJMPHND1gmDyCKBcUbN5dfYYSeqQ+xrzXbG+3ypOabrQzMsA5rHV/cnq0AwSFu7vj1UGBiz/miNicz7VDxdPakWTeHA16w4gden8FhyaO0LNcXJyaOiZE+Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible to hit a zero entry while traversing the vmas in
unuse_mm() called from swapoff path and accessing it causes the
OOPS:

Unable to handle kernel NULL pointer dereference at virtual address
0000000000000446--> Loading the memory from offset 0x40 on the
XA_ZERO_ENTRY as address.
Mem abort info:
  ESR = 0x0000000096000005
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x05: level 1 translation fault

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

The proper fix would be around not exposing this partially-valid tree to
others when droping the mmap lock, which is being solved with [1]. A
simpler solution would be checking for MMF_UNSTABLE, as it is set if
mm_struct is not fully initialized in dup_mmap().

Thanks to Liam/Lorenzo/David for all the suggestions in fixing this
issue.

[1] https://lore.kernel.org/all/20250815191031.3769540-1-Liam.Howlett@oracle.com/

Fixes: d24062914837 ("fork: use __mt_dup() to duplicate maple tree in dup_mmap()")
Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Charan Teja Kalla <charan.kalla@oss.qualcomm.com>
---

V1:
   -- Checking for xa_zero_entry() instead of most cleaner way of
checking for MMF_UNSTABLE
   -- https://lore.kernel.org/linux-mm/20250808092156.1918973-1-quic_charante@quicinc.com/

 mm/swapfile.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 890b410d77b6..10760240a3a2 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2389,6 +2389,8 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 	VMA_ITERATOR(vmi, mm, 0);
 
 	mmap_read_lock(mm);
+	if (check_stable_address_space(mm))
+		goto unlock;
 	for_each_vma(vmi, vma) {
 		if (vma->anon_vma && !is_vm_hugetlb_page(vma)) {
 			ret = unuse_vma(vma, type);
@@ -2398,6 +2400,7 @@ static int unuse_mm(struct mm_struct *mm, unsigned int type)
 
 		cond_resched();
 	}
+unlock:
 	mmap_read_unlock(mm);
 	return ret;
 }
-- 
2.34.1


