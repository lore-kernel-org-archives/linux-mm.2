Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AEACC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DAE6B0099; Thu, 30 Jul 2026 10:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 336666B009E; Thu, 30 Jul 2026 10:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226026B009F; Thu, 30 Jul 2026 10:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E91576B0099
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:55:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90335C01AC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:55:27 +0000 (UTC)
X-FDA: 85045741494.24.FB3694D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf15.hostedemail.com (Postfix) with ESMTP id 49052A000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:55:25 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rIC1RNki;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Z0uQxvmNrLSRCmkr4D1+JE0i6yoiQLKgFJIdlFFf+4=;
	b=Ip+9t+Cupz23MocPNc2wsilYjwU2mvvyUCuDi/p2xvI3s8AmDuFYJ6xRIibtCgYs8nFYYi
	xX57JMt6aZLdK2j0w7eosPnLb8aPUowNRwwl/pT5H+TXeJxSXqQ+MGOOo4bS1mK4272R/w
	wOWYrWfRibV3COE/v2ZBfqZPr4iJd4s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423325;
	b=XUoOFe96IldrJbIOMq2NX5OGSxpkkYJF4O1a3PfcGMCGAI4wdI3z2IdX/6MljkpqSCT36h
	03gKWfcsLXzzIeSgYGl8qOarRZJEQ+qaR3zGrdsE+0pe3VUKB346Hq7ESM/bXz5mrQy9BX
	d8Wt2TaLWty12mFJ1BfYXeYSU5hwk5I=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rIC1RNki;
	spf=pass (imf15.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66UDHhhZ3020677;
	Thu, 30 Jul 2026 14:50:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=9Z0uQxvmNrLSRCmkr4D1+JE0i6yoiQ
	LKgFJIdlFFf+4=; b=rIC1RNkiW8+mftZFmsFq2DCH60j8D5rFTPBUOEU1qi/MNc
	FABo72XhgHK1N4MWNYEKgaS2W6spwj+GmTCkopTjo0auw+1lxsAbZoIESaN5Larm
	51E0Ias37FjxUwGFuYtT7ZKFjmM2lUOa7TpGRMfMwXKgdTyYJuUAxwft+cUafTvz
	k6eZS75tnc9h6qXX4seLVH5z26vt1sYD+OsdwfVnLq/zwg2yp+iLVXIL07/tCr+/
	2CAzD6EBxSUaHLHzQgRUaJgbX0NFVGB4MZli2CTD+xxS5Q6pHHZC4syB1dqvAX1w
	3zMfdaVOiqgf/A6OBd+BN2AbzbFnJ67FavkEjSow==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0nydwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 14:50:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66UEfLeY006361;
	Thu, 30 Jul 2026 14:50:08 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fkbtaf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 14:50:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66UEo6g047186296
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 14:50:06 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 725772004D;
	Thu, 30 Jul 2026 14:50:06 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 590A520043;
	Thu, 30 Jul 2026 14:50:06 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 30 Jul 2026 14:50:06 +0000 (GMT)
Date: Thu, 30 Jul 2026 16:50:05 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Pu Lehui <pulehui@huawei.com>
Subject: Re: [PATCH] mm: use proper PTE accessor in move_ptes()
Message-ID: <b7947b4a-7cbe-4b8c-9ae1-fb45660a7db6-agordeev@linux.ibm.com>
References: <20260720141633.501799-1-agordeev@linux.ibm.com>
 <7f60a20f-7293-489b-8539-847fa1b96789@kernel.org>
 <51102823-ceab-499f-8b6a-162e392f864f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51102823-ceab-499f-8b6a-162e392f864f@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDExMiBTYWx0ZWRfX/35g+J0LkFlX
 8xVdto5GtSbSr2OoyON3SyaZi3Vx12y9NUpgYphp/kI0Cum4Mm5QaovT2yd8O6wDaPigfXKeXXu
 iMBAAyrMI72ZWgc7XzviKj3/D1CtTy8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDExMiBTYWx0ZWRfX/nYNa++3prAB
 r3L8RIDNZjfTuFoHlfZ5tjPqIqhXa4gmSZtM0Ja59gNsScNVCp9kRrzVbSu9osZb/1Cr/yWEAk1
 w/ccbsxzTTeBEuMPTVUxrIs+E3E/VvwbJOjD+uoo7PQmftcOSAH4//+DDBfQoBKHZyQiiS/BRMB
 G1LLAsCUy4g3A2TlgixGWEdbSmhLGVgJcG7gokqQ/oLM2UfGMOgzpubDptnDJfzRgtEYMx6bGZX
 xpSbn591FuTiTcDIZ0wdRGEBxEoDBwujLPnDT4HEIH5fbL7u7HTauiL5g5RnlJL1thL8r7yfr6Q
 pLsGjmevY28b59+mu23N7aJuwKcQXsV+eQVYc8/sS/B/j46+vy0TRuM4sx4MMtiOY/luKFuSpKQ
 Ue/pxjs8970yVc6KHZ8Gm1yX2pVtlF5XZjCyzw/7UaqOiTaiDB4ub+4TKu19J09SL8wbA4b9jgi
 PTeAGyBPKs6wqOetNDg==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6b64a1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8
 a=VwQbUJbxAAAA:8 a=CgfZsCgG6mTAnALvW7wA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: g30uzBDJJit5SmXkJpWfX_IHS0WiqhTT
X-Proofpoint-ORIG-GUID: g30uzBDJJit5SmXkJpWfX_IHS0WiqhTT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_04,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300112
X-Stat-Signature: pr7h95u3q9rgrrfx89w7r6o4dm99xazk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49052A000D
X-HE-Tag: 1785423325-596038
X-HE-Meta: U2FsdGVkX19BZwLRuyNaigk42SrWCFB+f/Nmqx4ppSn/CliQQHrZoP7DEhJbhNRMCUi0E4ERf5z2b++zejwrKXnQtcWwVpCcRYMEXWNQ1jlNK4WICFggTIbRZ3fBxUuIFUs6ESnr7SbwQsYpTzUove8DgXr/LT4gRwkQtnB/TsddMmDuQ2qc3RGClM1Ii3IHHz7OhatNwnOQ2V6Gd81VT9z0NgfJVvYBLguoT9hYlsmQ89Nt+g0VDxyaGf2xF7rcgFosE2WVX0NB7QFxQmOLLzwDdt2IAP1Y3TaRd1GOJYZ5cj+FRk7KqRfL4pJQEzLhUWeQdnR74jy0scd3BLiQ3b478yhcY6eZtToB37sJIYPYbIqhWV/veX7Qizn6LpuhHnNTy74p09ap5+ldw8foqFLLYFdTQGzSi/HWfEZVO5FLebuoVfXK4yjPpMkogSoNZC5x5l78fQ+l1KVxYcM4BPTqiPNFV2fl1OEUCIdJu9UgdcMtsgitu5Gp47cyUuwcJj8DImMqRyGrPkqM0vbDLOsiBTogYRwmGgXLCiJBiNs2FOjgwo+04YYqAqObbZ7FA6XFuqOojpyZyodLZMnSTpw+Py7b1/qjzhsndyCTIXzmT4bN/YPN1pTSrvcFMCN3cZd0+LsONYNQaT3W+IOpASXWglCD9b44rIYYsuoDpuMWoZmGPBDHrbJE2kCQawoR0xfYDfYKHoPsteQYJHfuuSH9TXNbAtK4ZnSc4/es1GDIXeANEWT8GtneDyYlLkCQtmBhh1vGGuDedqLQOTF09zt6D0PZZvir4O3jTJnKC1eIz5o0bpdGRgVugLjtij+Aokv7SWN0TDzMM5ee8Htj3qgj6a6x5o7nQYD6dfG36UJUJLMDAeylfW6NhnUt//r/OvLuTBjq2HBH/XhYL7lIHO2+3QGy5jcRHjcDy7JGYq4RuEC9AqWMgS7qPtti0xytU9+vRwY6O5AuBdqgd6T
 /aQga3I/
 ejlCDImumQUhdIKaYqa4gQwvcP9q+rnNCLTVz23vyusawM1rbLVx++S9TNnc7dxCja6QcJG3qrM5aa4HxRCDaUGLBK9pDL5bPSf6jBgbmbeGz1DbS9KfonBe5DnvzgNSuzQyxXC1IKKI4ZtfGMG+gu1mitE6r3j5XBMFcaK8bumR2e3UauRdQ4VnFQ+DnJ/4p8vWBqAh2P7ZG20fuZnYQv9eMDSoBGKpSC6vSdlh/PRSGe/ncQ9TDekLbGMlz5NU+cVK7ZZR5ePgrlBHgY8B+ybUi6pfHioCRJ2nRe09v2u+yHCFDax/QFvtb+Y7Qm4GO+O6k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 03:08:04PM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 15:07, David Hildenbrand (Arm) wrote:
> > On 7/20/26 16:16, Alexander Gordeev wrote:
> >> Follow the pattern established by commit c33c794828f2
> >> ("mm: ptep_get() conversion") and use the proper PTE
> >> accessor instead of a direct pointer dereference.
> >>
> >> Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
> >> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> >> ---
> >>  mm/mremap.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/mm/mremap.c b/mm/mremap.c
> >> index 0dfe3de39ccc..e99b19a9850b 100644
> >> --- a/mm/mremap.c
> >> +++ b/mm/mremap.c
> >> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
> >>  
> >>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
> >>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
> >> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
> >> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
> >>  
> >>  		nr_ptes = 1;
> >>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;
> > 
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > 
> 
> Ah, but I think we should drop the Fixes: tag, or am I missing something?

No, you do not. I confused it with ptep_get_lockless(), so no bugfix
here. Should I send v2?

> -- 
> Cheers,
> 
> David

Thanks!

