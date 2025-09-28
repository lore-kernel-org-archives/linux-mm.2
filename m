Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AF43CAC5B5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 15:01:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A55FA8E0014; Sun, 28 Sep 2025 11:01:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CFA8E0001; Sun, 28 Sep 2025 11:01:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943208E0014; Sun, 28 Sep 2025 11:01:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80F4B8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 11:01:57 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38EB416012C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 15:01:57 +0000 (UTC)
X-FDA: 83938973874.21.A392676
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF22F1A000C
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 15:01:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DNzfMAlV;
	spf=pass (imf19.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AYfXGsQBDFXJRcKXSfquRb1hEODFJZgk+R+FxXnl0Ss=;
	b=1s/+QFu2V3Eqxs/6++bKvwf17f9KBBdHBiKhcTAvQ+40sCp2Svh4py9BHCJOyavWjYoaSA
	FALGfRjOLySO5ZLISufElhkxKyj2nHTS5T0/8NavhECtsSMQpYMHgOQSVgq8yQVSuAlFNw
	ZYxPX1DU3FxExKXc61HBjPKWn/EcrvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071714; a=rsa-sha256;
	cv=none;
	b=ytMCQ3UPSVqeegWAcCeA6lBtOULHZsSzlu+Vh7EGrkOIDwget5z1IRHKTiWMvZq36gDvhC
	lKflc2s06sQ1kgZylPOBlwEMhqtxUtanv5ChLyDwUq/GLQrCTpqTedWPkCollaf6+INot1
	1Ru8X8IYJZvNiYke50l0RE8ULYY3pQs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DNzfMAlV;
	spf=pass (imf19.hostedemail.com: domain of nilay@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=nilay@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58SAK5B8008510;
	Sun, 28 Sep 2025 15:01:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=AYfXGs
	QBDFXJRcKXSfquRb1hEODFJZgk+R+FxXnl0Ss=; b=DNzfMAlViGI4y+gaDZYfVF
	1dlYtUUl3iJE2rXQK3QwvHE0fTa2PMQ5OPQwkzWZDwRIRSn+1iDfxTq+NwGqlZIN
	9RHOVkYLJ1xC5pwut9uIm8lAICySSaEmJl/L/OZt5WDAp6PMlBj0rajiveqCg8rq
	M5A/EW4G2VNw2mu/ouY89tIyEQFb4UIv/xroDJd0xQr8uYufNWl/hEvvWSSd8oXU
	97AgV9JP5r/tV8CXldlL2NNev2e2UnpnDVhg+7UvbR6BT1i+tCjH2EC/ZvJjZATC
	ydrHA1NUE2RaeT2tqF9G44Vx8lHQUBpgYLrMOLWYj691R5Jpq1mBozSyP0p4clJA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49e7ktwypd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 28 Sep 2025 15:01:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58SEaq74024121;
	Sun, 28 Sep 2025 15:01:49 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49evy0ss44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 28 Sep 2025 15:01:49 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58SF1m6G15794870
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Sep 2025 15:01:49 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D8C3E58045;
	Sun, 28 Sep 2025 15:01:48 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42A4A58052;
	Sun, 28 Sep 2025 15:01:43 +0000 (GMT)
Received: from [9.43.71.234] (unknown [9.43.71.234])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 28 Sep 2025 15:01:42 +0000 (GMT)
Message-ID: <84f405e1-8726-4c90-aa40-dacbb28ee29f@linux.ibm.com>
Date: Sun, 28 Sep 2025 20:31:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] Double-free in blk_mq_free_sched_tags() after commit
 f5a6604f7a44
To: Niklas Fischer <niklas@niklasfi.de>, linux-mm@kvack.org,
        linux-block@vger.kernel.org
Cc: vbabka@suse.cz, akpm@linux-foundation.org, axboe@kernel.dk,
        ming.lei@redhat.com
References: <37087b24-24f7-46a9-95c4-2a2f3dced09b@niklasfi.de>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <37087b24-24f7-46a9-95c4-2a2f3dced09b@niklasfi.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=T7WBjvKQ c=1 sm=1 tr=0 ts=68d94dde cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=8QDA8OVxI78L4LCaHNkA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
 a=HhbK4dLum7pmb74im6QT:22 a=pHzHmUro8NiASowvMSCR:22 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-GUID: v5Y98ae59iHT99A7FWHGbFXIt84RXoJ-
X-Proofpoint-ORIG-GUID: v5Y98ae59iHT99A7FWHGbFXIt84RXoJ-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAyNSBTYWx0ZWRfX4jqWQW6W4b9b
 hO7k3ij3cq1RBtqVCkzqSFIjgjtRre+e7tz66cvYniYxrwbAANt6tDE1QCPK5fiNKGjuH/OwS4S
 cMX8heqDdidjvM65anmaBGAyc+Nl5d/7NrRWEsgIQilJlJfrr2scPrG2oITMY9Q8xnF56gDni4q
 oxMFW5KJ1CGgrSr8Dapjgg5zt21XXexdrx1J/fDyp5fYl0c2+9j5Gx4NQca+dDMURdqL6WVvYLd
 K7HOQkWF6WSRpKro+NMXJd76pTWY0sFXnIo2mIgfIGkQhQQjYiEdO5Oz+ngIS/jeKR2PsTRUU8+
 qAGa4zMGeSapWisfVaEBuwex8Oe1kBlWQ/rFCCiISjE+qEZ7PdL7MYffD9A1Fp8UugQ+3F/xwLl
 f7fg//vShxN6IZ06X/K2M9MrM+a1kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-28_05,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270025
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF22F1A000C
X-Stat-Signature: fbgax41rgiaaokgu6wbwucwgw774aggo
X-Rspam-User: 
X-HE-Tag: 1759071714-551876
X-HE-Meta: U2FsdGVkX18qks+JWuJVwRmF6xV750H/+ED8LVaKkxTteNFIsW1jfAiMw3sTwjCe5sHSFdrIBxDxCdM8ofpB+Hum6M9xkTU+VLuhjM6/G8SGLii3zajOdK2zMncLAbX8T/f0KuMpHFfm49gExJbIn2qi5LQlfbl15bMPD2YOKvEBowrJJ3dimkF6Eto4XGAALqf6rDE61E+VjcxO0Tz5yY7RQK4aVPXKRgcF5msnYLu5X/a0WfUs1bBMq6ESUiVDBPGsMAzdwTeeHHBmU2ATXGnn6lyrTYV0joFFnoe6QYMkXNP4/ts/GMVPirjK3AtfaT94hCvDbMFZDlkIrKKBtYSCt3lkPgo7e5j3oza8bt4Pw0zwDu5LU4ALiqVN+JP0pxb6lmSFOU/jD7zqplWgNKUy4ztamDIQrLbXisRkJ9wYw94GqpP4Sgy+AZqv/qUk7RVhLN13Mud8vexLgNeqzm3gO/A8EFjeUXkzH/8L0RJOZjCtVXjWPyOJlVr5ldNLNjZ7kwjKn7C4rOuCC1YISqRtY7tEOalhEyLUkbTQapbqRETIp7ulDJlHhStxT+iGkb75a0fMIhVqe5vsk+LY4Vv652PARmQ4KleMdZXyIl1z0AeA8BasUQwTngGSOrjl3sFYZiQwOY9smsWrggIKh9blbZcm/qFWUOEZwDVt8ZPiaYfeflkUbhbP1c6c3w2gx7hrQSzFWm5xmIXd4vt4dWBJwynU1VTkHGGHLbakw7u2jGNLU++vgv8dOZjpk3FLqZfb+ADK3lZa/e8YNMdZIDe31j7bxkacR9KK0PLD8eAV0JVcAUMC0nTHM3054hTg9PYeBFYFlzLmyLaA6cShiq62ZObzHVf3yw+IwCOpfnCamjD/DrH3h34jy6PdFgAFVO07s7P7CIpv2N/mxa8Vr7VBoc7ZmCpvfNbfhP1lAm74KcAPrs2jj1Ds/8Iovlt6cI4wu8cjk9Ixwahhfdj
 tLb5BgPu
 KdlpSyI44pRq7byXL68Ja6GsEGe+hNdIC8c0pAdbvx7X+3rZzOhs0aisTXb/N29R0jSyxv/vUC8Ioj6NSMk21oTieVIsapc6jh2uQSFO9SE7jD4Q2TtSBHozB7F67xEUORhPFz9gDFORD/w2iFPOrvI21WkCPm/5m2csoQQGCKI2TjTF2aAAfBFSkIcGFhpOuE+CQBeu3ZDxbeHWC6AobZBAW+2vqk9bbmEjW07ygue2wtwbwHRmOCaREJGG2vSZ3NeyWnuWs3DF/iaTGQJmsPUiYLh83pJ/Gd2Gf9qTbJk9rh2tiBIIMwEnH0q4ZJIYmxcZ40MDiBPwlacRcrIIRPtxaZKatrLQrmHmPa0DYx6hV9h8hdOPN+He6zQGH0zWpfnSir/sR5782kBmwrDi2r3iIOUylp8jiDyXOKA+sJpaV8bl4BTu+MoMkueqyxz0M9gPe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/25 5:38 PM, Niklas Fischer wrote:
> Hello,
> 
> I'm reporting a kernel crash that occurs during boot on systems with multiple storage devices. The issue manifests as a double-free bug in the SLUB allocator, triggered by block layer elevator switching code.
> 
> === Problem Summary ===
> 
> The system crashes during early boot when udev configures I/O schedulers on multiple storage devices. The crash occurs in mm/slub.c with a double-free detection, traced back to blk_mq_free_sched_tags().
> 
> === Crash Details ===
> 
> Multiple crashes occur during boot, showing a severe race condition. Seven separate kernel oops/panics are observed:
> 
> * Oops #1 (CPU 13, PID 928): General protection fault in kfree+0x69/0x3b0 - corrupted address 0x14b9d856a995288
> * Oops #2-4, #6-7 (multiple CPUs/PIDs): kernel BUG at mm/slub.c:546 in __slab_free+0x111/0x2a0 - SLUB double-free detection
> * Oops #5 (CPU 1, PID 952): General protection fault in kfree+0x69/0x3b0    - corrupted address 0x2480af562995288
> 
> All crashes share the same call stack pattern:
> 
> elv_iosched_store+0x149/0x180
> elevator_change+0xdb/0x180
> elevator_change_done+0x4a/0x1f0
> blk_mq_free_sched_tags+0x34/0x70
> blk_mq_free_tags+0x4b/0x60
> kfree+0x334/0x3b0  <-- crash here
> 
> === Bisection Results ===
> 
> I bisected the issue to this commit:
> 
> commit f5a6604f7a4405450e4a1f54e5430f47290c500f
> Author: Nilay Shroff nilay@linux.ibm.com
> Date: Wed Jul 30 13:16:08 2025 +0530
> "block: fix lockdep warning caused by lock dependency in elv_iosched_store"
> 
> This commit moved sched_tags allocation/deallocation outside of elevator locks to fix a lockdep warning, but appears to have introduced a use-after-free or double-free bug in the process.
> 
> Reverting commit f5a6604f7a44 against the v6.16.7 tag results in merge conflicts due to subsequent block subsystem changes, making a clean revert test difficult without significant manual conflict resolution. I have therefore not tried this.
> 
[...]
> P.S.: This is my first kernel bug report. I've tried to follow the proper conventions, but please let me know if I should format or present anything differently.

Thanks for the report!

It looks like you were running a tainted kernel, and the kernel version
differs from the stock upstream version. This likely means some modules
were modified, built out-of-tree, or unsigned.

I recommend trying to reproduce this issue on a pristine upstream/stock kernel.
That will help ensure the bug isn’t caused by external modifications. Otherwise,
you may consider reporting the issue to your distribution. Bug reports get the
most attention when reproduced on an untainted, upstream kernel.

From your log, it seems the tagset (request queues) being freed had already
been freed, or memory may have been corrupted in between. If you can reproduce
the issue on a stock kernel, I suggest enabling KASAN (CONFIG_KASAN) and 
reproducing the bug. The KASAN logs will be very helpful in identifying the
root cause of any memory corruption or double-free issues.

Thanks,
--Nilay   


