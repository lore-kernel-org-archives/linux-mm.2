Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD408FD8FDA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 18:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363806B012A; Thu, 26 Feb 2026 13:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33AC46B0131; Thu, 26 Feb 2026 13:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 210216B0136; Thu, 26 Feb 2026 13:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6B26B012A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:10:40 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF171B89E8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:10:39 +0000 (UTC)
X-FDA: 84487398198.01.3AF110B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3A3C440007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:10:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A9XozN7y;
	spf=pass (imf12.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772129437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiFUwGlKvPHJc9AsU/Wqf2qX4SDWzVFk7B399xUfI9M=;
	b=xO9NPq7KnxivIJ6Y0YYAk7X7uAiPOHW+1kZoBOyIGV8LMGBLk2wRbPoX5vYrNx04mSazFX
	aYntfhKX62+GeTqO8DIgK1IcjWYUFU3JJAovfkF1pEis4sytN4iNoGA/wW2r2pJVXPfdMQ
	DAf1LIDL8WTEDABp+DUSDpXYm0173o8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772129437; a=rsa-sha256;
	cv=none;
	b=oVPIrBh3uBON6msp/Ksrl1xoJSn+vRCxn7JWifyUpBK3eVbtyq4mbGhRzg5K7WbS1wi/0u
	2gPacvFNLN5/u3mKs7ngRGFFHplz4e6rTFyUNYLLvgX4Lr06zVy0d6nFnQqZtsuukqqoyC
	ei1gkVsxoYs/41P4JlNOQMlHv+6m1Rw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=A9XozN7y;
	spf=pass (imf12.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61QD6Faq2725309;
	Thu, 26 Feb 2026 18:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EiFUwG
	lKvPHJc9AsU/Wqf2qX4SDWzVFk7B399xUfI9M=; b=A9XozN7yADv+w734KoqjJu
	cmY5URUgJGXV1lciduLFTJDjuvpGVRXqNodjYvdRm6srQYfX+JKkyTzLJ6oO3lid
	lt1246JIMpLXN60GlHCw78QYjEclm7RCJaIOga82zWCfa4xr6Hw2ZXeO4gOdxI2k
	6cGeTcMHVR8xSwxLTb7kJhPH4UdNUh4NAQwmwLEeArGnHOukzh7fA7eMLi41cgrf
	zls2ufrfHcFIcmaY9B7hUC5cvbachdn+mq5Qjb9CRIeULa45GKXoDkd7b6ZzEVRj
	LMwmN48tEzzMzCMerpEr7STe88AIe245K5+3VGYVEOWTNTkEXCfDNPyeMNBSCygA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4bs7aa8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 18:10:15 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QI2mNq001607;
	Thu, 26 Feb 2026 18:10:14 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfr1nd82t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 18:10:14 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QIAAwk42991898
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 18:10:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2C5B620043;
	Thu, 26 Feb 2026 18:10:10 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A613320040;
	Thu, 26 Feb 2026 18:10:09 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Feb 2026 18:10:09 +0000 (GMT)
Date: Thu, 26 Feb 2026 19:10:07 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
        pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260226191007.409a7a21@p-imbrenda>
In-Reply-To: <20260226070609.3072570-4-surenb@google.com>
References: <20260226070609.3072570-1-surenb@google.com>
	<20260226070609.3072570-4-surenb@google.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: CtrnfnLFeGbNILvMxH4zz7_6vXcy1bo2
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDE2NSBTYWx0ZWRfX92/iJsyzGWX+
 U7gNleqecboFJWTHpna/+exChG3YePLWbT7HIINpkqg0RRcbAghOgu83/JdENcOYjyMxHXyYS2J
 vxq09Edt50L8rapeL1iGqQfXep6UdFtEScs6PLrjliHJTfK4HkCtLV1f5gYqnr4+oR+P/TmrBrJ
 WHUPRr898gbzAFY0BpdSk4/GWwqKBJ07z/9d2A3JTukzTerEs7+5ySYw7XMrM/MTFa6foacNTwu
 ZzwE1fe97JUOUH3DNbY21+30YHBz0ECn7fkHHJ4mRtDcI9n0YT/WOppk/oEf16FvL4+a4QS/5xY
 UAk4/2ujObMmGbT5ewiKuYjsEYSWdCs29SxYLJCCj4/1z0zdDKNhZ7ATf/bTOCeEEIGocCE7sZy
 PwQ4UxojBvq7LC4FCsLrkANEzgg4tXzL50hIzKkCGgm65w87ImnGgtlyXd+XZXRjtxPBhS5EBYQ
 NQ7T/7hz36hqMdZ4aaw==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=69a08c87 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=8MrrMA2wyEC7cuUn5CwA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 5vfp8VXyeBQAaEvJC7GasClW74sWeMkd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_02,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260165
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3A3C440007
X-Stat-Signature: muwoxqkacgedn4ii384uq7h6wob9mxgd
X-Rspam-User: 
X-HE-Tag: 1772129437-129857
X-HE-Meta: U2FsdGVkX1+t5r3TJgCGMP2Gh55fLFAafnNb125hQbd5V/kqLl27XY4wm0+rK7aBLZRiEQgNRgQ0DXZ+4ZlINDuR1pECfQiCZ3pUNT257CQy2/TEL3LqI/daourqPuKPMIQOtffV80DxZFyx3xnEV7PopwoQkFlk+R8n6Ark+b6cbcptk/L7M1ZzG7lQHbWVrM/2R/sHP6UjSfzSGEVZZytp/MUK3LOfcs/wVAPMYMJo9pX/4719Zr1zTGv0oEOwzQezB3fLd7YVin66yzvfekTsaF47IUxcrTywaoXGf2zlWNN7u8eg8DXUBmDZOOP3ZZq50vK+Da8xkcU3kN+eKH/bX+7+HYuol1I5XA/igMv1CmTMBJD02BcdxG2RFc7Y36rICsb1moRkcKJ+weKwGULAEQD7r3H1IZMFuHVjbf65H9zHfTPOXBL6GNFAHTRSBEoXaebgLk4A38z6pqI9xnGbl456QizRRG3KQ7IyHyo7b0PRnchXVdTLPk19gs4cCJ1mZQ2I3Mz2JPApFWmOJrLPi0lZKP7cg5x4GADzy3gN+EzNMtByPQRmYbDqCYVY28Py97VMJdV78Ib0AB2Nwc1KTG1h8DdjA/XM/Lc2L/LigjPeiz8tOzQKVYXq+1x+YFOcIiktN+8i6hd3NyC+6RNF035uivjKmyPc+sYWgyVR8EQyUtAcYhmpMdURaZalqB/ZfQXNBmf13JSgiZKxaH8C3T+afCGvk/Mp1dgKmy5dLNjXrJRYf9EzxnOksuJQON+4T8MsBpq7LHeDMoxYTI1tBdxxS7vHXcthFwC5+ypT8x+6edX2GmOCkmXZjHFCEv6/LT3Zof64YSkDEAQCo1XG4GHrI2AilS/sPXmSlRsEgycQqcFSbkf8FhfHp2fUOnTE0WWv5VBU5GPam6HGIs0lb/p4O0aE3oXhnwm5v4215USlC5SeQxM8ggxYzPzg2X+sVaNsVRJwTguEQfw
 +12WOeO3
 thp70oU6SvxHSa6Ism/9ydJAiElrzbZDPl4V9mxjUPVJiGUKFKvPL/8GPbPEm/Y5zeAazNi+ahMBJpSF9Ip0C6yy+j0td5zs47T3W2aztB39CGvg++e5R3CLG1F69pzppJ3OkOA8g3i5XpZOhyFhCSeKap8TJtn8UnuElWUuRlmumL1cdzn9tYCU0WmceGYckfI5olMIGb9BmAKO/7w5Vevzl4P7zI8zb7i0aSOVtqILbKP68dx8Wal7RXVsBjiLEBbL6UQjaNYG09Jl71/dXw//eZTRhYHHXCp6b4FrceKZJQO9gR3iPlNp53MumQDe3VDGD0aYt+g8TPLhJeKity2zCYBtmimTgHBpSehEQS0j3InA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Feb 2026 23:06:09 -0800
Suren Baghdasaryan <surenb@google.com> wrote:

> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/s390/kvm/kvm-s390.c |  2 +-
>  fs/proc/task_mmu.c       |  5 ++++-
>  mm/mempolicy.c           | 14 +++++++++++---
>  mm/pagewalk.c            | 20 ++++++++++++++------
>  mm/vma.c                 | 22 ++++++++++++++--------
>  mm/vma.h                 |  6 ++++++
>  6 files changed, 50 insertions(+), 19 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7a175d86cef0..337e4f7db63a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		}
>  		/* must be called without kvm->lock */
>  		r = kvm_s390_handle_pv(kvm, &args);
> -		if (copy_to_user(argp, &args, sizeof(args))) {
> +		if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {
>  			r = -EFAULT;
>  			break;
>  		}

can you very briefly explain how we can end up with -EINTR here?

do I understand correctly that -EINTR is possible here only if the
process is being killed?

[...]

