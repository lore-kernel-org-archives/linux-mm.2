Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D806E98E11
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61AA66B0088; Mon, 23 Feb 2026 04:50:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8986B0089; Mon, 23 Feb 2026 04:50:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CB036B008A; Mon, 23 Feb 2026 04:50:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37A766B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:50:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D16D51B6927
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:50:35 +0000 (UTC)
X-FDA: 84475251630.27.05DFED1
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 898ED100009
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:50:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DMDsExE1;
	spf=pass (imf05.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771840233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6vNv/hX8g80QwOpt8JDmmCkaACXnf5hsJBS9C4v+aXA=;
	b=KmTfgWE03kRKv5+Oz6hCC5lzFPvHvurYj+LcRIa8luxEUeAkn0XH+TmL9CSTWDyF2ptajy
	Hd/RoWp6pjnWq18vZwbaJ4CDbUULKcs5Du3LWoVX00suLoj+2X9iHuRek0MOETHJF61FQS
	Wn8JSDKRA6D3J7CHkYSlRRg7tV8bX7Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DMDsExE1;
	spf=pass (imf05.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771840233; a=rsa-sha256;
	cv=none;
	b=5M+yHR24e6Aao0d+GB+qfH0daFgZHkYGJHD6ETvTplQocpELtARumeOKqr1h9Q0xZE6F3t
	hygHu4rH17qrc7VlHfx4f20LrD2TpiQoNTf1PbqJy53M7yCdZphkcxgiVOV1A8Ki8mgOdp
	p0hDwTcJnPGtUgUCEi5J9Big+1Cpe4c=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MKuLEQ2461030;
	Mon, 23 Feb 2026 09:50:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6vNv/hX8g80QwOpt8JDmmCkaACXnf5
	hsJBS9C4v+aXA=; b=DMDsExE1lAev13e0yw/4Z3+y3NuJ5o6nfQWeTHeA28B3tU
	u3GOOzWruP1Shi1i20JGXZ7n5sADfvtFuPa/Foa2J5/VEmqQtGy2KPN3rg+8T3U0
	P/hTF0DJskNKNpIKtiF8OVhLAs0GFqNVZOVvvfdNniVlhzBy4eYyN58DZ6myNOw0
	b4zqWzjJ4c7Rdu3lXUpS777OjBrzdLsZcIlGTrf9COwlzuqBAYUIPYB8XXiXPnSi
	949Hh9oF0Ch7ErkM91uYInARdmBQKK/AqBiBJO8e5rF3AGgBSDN8O9vJELhfdaWb
	ug/JwyjrZn9rnnvOqpyuXOWUvdU7rMNqX+YtdoLw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34bx6c9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 09:50:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61N6jIGv003821;
	Mon, 23 Feb 2026 09:50:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8jm24k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 09:50:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61N9oMad30015990
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 09:50:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3623720040;
	Mon, 23 Feb 2026 09:50:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7CC3B20043;
	Mon, 23 Feb 2026 09:50:21 +0000 (GMT)
Received: from osiris (unknown [9.111.54.98])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 23 Feb 2026 09:50:21 +0000 (GMT)
Date: Mon, 23 Feb 2026 10:50:20 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Yang Shi <shy828301@gmail.com>
Cc: lsf-pc@lists.linux-foundation.org, Linux MM <linux-mm@kvack.org>,
        "Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
        Tejun Heo <tj@kernel.org>, urezki@gmail.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <20260223095020.8139Bd5-hca@linux.ibm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA4NCBTYWx0ZWRfX66bRpwjgWXRn
 Q4+a8tzmO/mA9tq2qYXC1ODUwJ5bOK24ET+vHjWz2MAkFiaCm5p4JMRQy33XxStkdpQqmQpb8ZX
 LeQbgLUtlwKpgqYIn7/dB0Ih6BE7h1zyms772M7Q8goM7tm6kKoLfyd9sDofN9z0fu7ug8n88a7
 AOaCvWyZmkgxlRaDd1pfzD1GbwI3YOIuz7Y5cmmL4iPs+T6OR154Q+eg450Y91ND8pbIjbibl3m
 Y57YZLOiBG6PdXYN5iudg/QuInXu5UK1TWHf500hBRfkU0gB5z7/TxFQ5aXyHs4i0pqb1FeK0z0
 UCmWj5uc3ONJDQFM4eQbJYGbIMskTuZgXgs5skzQfxpBOP3+30pby221U59w4DfD84V+k6Azjqv
 Hjk8k0da3Qm36uboES6OW8u16HAGjsEmrpcUXD8Za8VYAh2K0A2kTHccT6dsTetelVbFsHiI0wX
 TRQcT5VmMAKEfmvfBpQ==
X-Proofpoint-ORIG-GUID: ochqu-XZkKCnlVXvsC_Xl1gV38A75zmw
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=699c22e3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=Xhgu7lUpGomXScTDuk8A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: cqO9iRPjS1shf7Ud8vRYWF-llPJZgMQ4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_01,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1011 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602230084
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 898ED100009
X-Stat-Signature: hdsdaymz1qbhbc7zkh56pb4rng9fq3k1
X-HE-Tag: 1771840233-69438
X-HE-Meta: U2FsdGVkX1+cESeCth5eZ4BnHrZoW8oNK5jbXbNGC3Zr49ngjDXa+hhPUSHx83GQjcxjPQRKSHuYN/uEW/23mQAhHZGj36IKCwDDQAtZtLDoXcOE9K1njF11be6k2xoOKmVm5t1/U43rLlkbPu8XbGyCYSdrQr1rhUTu3qzIKZ+eh0zZpzp2ILKDupd1D9D1tDB9GaWQn3dR6BlcOBktwU75bf2zSWKTydaXBRiUwhuoSldQgCeKGKCy4YhXAzdnOiSrO8+nm2o4JU73dqJTuEnDG0305eCzRhsivhjMnleIcqeax4BPlIkj1Upp6do3LI2cwcf1Z9vwtFb6gmg/f0JdsnpXVHxSBuLGfYsCkOIga2Iuy1yb3iPM8UK+6X1bOPe4VOiyhp+lZ1qeS3W7j2S8JRwCPG2wsMbcna6fsOh4Q8492UkiaZCMwZ+tjjNA8wsNjy1MOnkO6pjRezPFri+QbFFfEWUvjEmXiW0Q82CkC0nR4DBWSXAoHqAE36/VpQKRyvVu3dSuA8ghT1qzIgSSgFLl4Fxqz0lYGY+Ad9OkMn9lebNFuqRLk3bD5FUoxgmXc1m0te+2R+IM2NaeeFdlX1twaWQxVNygK9mhrG+mojT01m6dUtQQtB1VMAQJb/65hbSLE5/HTpVAbl4pvUPC4e6ryBG3kys4vcqaDutcnXOWiz2EOfLo23HIfvMlhG5ldC1cV4ujCWPrlH3x2aEaYjJycgdFs6DfzPCyMu6HhCIbG9NqN29cxJWQCNFFFyiLe2mM+OB8hMWZEx1/hmpcfUtQOhTR9Clbj88/S36i5RlDeLoKSXb0DDMOOQ54RPiwtUwg0qvSl+vJQEHiK0LQEtG1fCfwN/TyP68KWA2HWTMaT83FmuShQwnbKDW2lk94UiE5oyifSLVMJlfL7/tKpuVMn6I7iydAPHu8SrTkt5oFyhwa3MhHfXWvLTPEeoNfQYsw7wzoIIrsNbN
 q/f8gjOX
 Odlo8BCXq8nIdZUJG2l8Wvd7FRMXJk77hEktxVqP762E6POVnTTpZG8qpbVqhTlXFCg58dLUOV2f5nFmKiQQ1jPRzZ2nvqaMF81nzHqAjmmTJLETjHnOghaqbEdtEwndHQpjQivnknv/HQInLhDCH+1zEK+2K/Uba1NOJuJ2zhkU6fJVRPIK2EEpGwUiI8RukOrxh0KPQI2A1bKr7pPRjzt4Yf+K88LZtEGKVHSX+TAEWXwJhXjTVdToKgJtmjxOApEAbmflKhZhX6Uj//F5i9GO5DXJAfhHgIhCi1jUae6lD+UYziNgOpQyEypfg2mDWoGWmrp5PzsR7dSZJP1lLuPFWMd7FsQFGOVjKZiqK+5BVDgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 03:14:57PM -0800, Yang Shi wrote:
> Design
> ======
> To improve the performance for this_cpu_ops on ARM64 and potentially
> some other non-x86 architectures, I and Christopher Lameter proposed
> the below solution.

...

> I have done some PoC on ARM64. Hopefully I can post them to the
> mailing list to ease the discussion before the conference.

FWIW, from an s390 perspective we have been relying on that preempt_disable()
and preempt_enable() pairs for this_cpu*() ops are optimized away at compile
time for PREEMPT_NONE and PREEMPT_VOLUNTARY. Which is what all distributions
did, until now.

With 7dadeaa6e851 ("sched: Further restrict the preemption modes") this is not
the case anymore. So the overhead will be there for every "up-to-date"
architecture except x86. I've been looking at some ways how to get rid of this
extra overhead for s390. E.g. we have an "access register mode", which can be
sort of compared to the x86 segment register approach, but switching the CPU
to this mode and back is more expensive than the preempt_disable() and
preempt_enable() pairs.

To make the long story short: I'm very interested in your approch from an s390
perspective (aka "other non-x86 architectures").

