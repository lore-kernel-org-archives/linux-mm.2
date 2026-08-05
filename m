Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA8BC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDF36B00A6; Wed,  5 Aug 2026 04:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 967426B00A9; Wed,  5 Aug 2026 04:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856616B00AB; Wed,  5 Aug 2026 04:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 539CB6B00A6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:45:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DD1E01C049D
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:45:19 +0000 (UTC)
X-FDA: 85066581558.15.82F923C
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf20.hostedemail.com (Postfix) with ESMTP id 96E0A1C0007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:45:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=h7UzM6Xy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785919517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JD3nmw7/uCpHKQFNLBdXItUa70PfNLL451+71cdShtI=;
	b=rSEXq0wxe/qYJEkIyXkTWLyspfm5kBCfpbVt5ULYJ9gVzjp7RaBDbIp1mLFD+sHh2wugjN
	iXslYXwoe3emPnHdXdVQxZCRUqNjv8W1Rv3QgrDoSrzGcv6c9Z3f/MRssAbTgbPPLXsVN4
	hTONli6LVhtj+54fZwMItcpMLLxQ1zE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=h7UzM6Xy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785919517;
	b=7qISCeJETCP5tPt+z0RQzeERYJRmMi/6Oc8snUba4q2kARRq4/lHPbgitA2bCx6gGhAPqe
	RqhVD47aZSNxynlALUAGnVXO0sDYjixOWDKbQMO9oMtCgwEw5G1TA3E680lHNIxM00Wy1f
	+akDobMnOyd/0yn1RIjLp+1fFR8F4QE=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mcwH3057752;
	Wed, 5 Aug 2026 08:45:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=JD3nmw7/uCpHKQFNLBdXItUa70PfNL
	L451+71cdShtI=; b=h7UzM6Xyr78usgCRR1hJ7/iAbqW9yfFhu+STygjpydYljN
	KP4FN0nLHlTh6AoQafUPkes4WckzTrFzpTthrjk8SddikrxZI+FfxfDLOdegXd+f
	3OYs4PfOTeMVR0qP/aA0bkcRv8s/62AuwchucxkV/w4a6gpdA5UbfUdPJXpe1ywz
	3iEDLvca6NeK7DmZwCmekFL5oiAyfdqRSp7XngXnkjaHoYPzvBqxCyu0m7bDIwT3
	oONTXLH9weEQc0Xs+7z+Wm/v8RZ3mlhcwismUAWi8qQAhFiDcUpsDDLqTFQzb7QF
	ooirbwHieQ4ADNFD69xKP3Uw8xx+6UC3WanCMwFA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8eusn3a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 08:45:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6758faPa000582;
	Wed, 5 Aug 2026 08:45:09 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtynhe0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 08:45:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6758j5bE17170808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 08:45:05 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 405CE20043;
	Wed,  5 Aug 2026 08:45:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A1B920040;
	Wed,  5 Aug 2026 08:45:04 +0000 (GMT)
Received: from osiris (unknown [9.111.89.228])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  5 Aug 2026 08:45:04 +0000 (GMT)
Date: Wed, 5 Aug 2026 10:45:03 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>,
        "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Yang Shi <yang@os.amperecomputing.com>,
        Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org,
        urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org,
        akpm@linux-foundation.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <20260805084503.37016Aa7-hca@linux.ibm.com>
References: <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <63ea8156-a109-b2a2-6d35-1c17ad7f1a9d@gentwo.org>
 <84b31836-1d10-4bec-a469-468b91fd4645@kernel.org>
 <9f146ce0-4adc-0c00-a2d8-c01b47edc9d1@gentwo.org>
 <ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea268481-d584-4744-99d6-0b05aade7d5d@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: nSjLujXPpUt8SCl8nOyvj029YFqLkigw
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA2NCBTYWx0ZWRfX7fUH1t4maqRx
 //StpMY7nBAPQ+rfUQ94r32tTMY279r1ppR8Gj908SIS0YCI/74Rww5hM9FqqtmS0G6XLIdmRKT
 USc0wMZF7U4lzqn/dcK7OfujfoIqeNM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA2NCBTYWx0ZWRfXzxKbMyGLKx1O
 1Epm2xtvxNNJqwrMSFnXF/YhlbXForSZBwSH+5SDOKDizeDdEGMV20RzHkD8I1ihwB3WfRRGN0f
 k+6ck6dUq3nARmrn+SfcBXLWldNNt8bjgMUMLwGs+/a8PUH84W8E9c/aRgH4b5ikrkEFOFocb8i
 EpK9ooplvHBWL+0uVt2j3KIl+cykuSy4WZy/BMmBYfPXB6wE193F+22le0In+h0b3pR+N/HNNys
 cHhVoq9vfJOkr4dB4lxwuv5bht2c9KveHfaH1e3LA2zEiZxwJoKhWUqIczjdzDet8j0dnPKkMce
 xF0cHZT4wLnV2TDUwtWB94Drdn7vrQBriDfNxhnhne/n03hUi2AC+RUPgPGbBhRfgSeGY1lLxNf
 yutMagTLlbIPLdFF2jVJtqmiZ/06t/F8yJYZ/wl0nUjOw8N6PzsSDL++DKiiRnUxlIyOHDIVKMT
 KMDA68PPKmiR8Tw/Wnw==
X-Proofpoint-GUID: 2xVSsLtkyg8UVaGyPMgocFxMjtNVlPI4
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a72f816 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=YN_xvx8HUdd5Io_IMJAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1011 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050064
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 96E0A1C0007
X-Stat-Signature: 6757a6dttngy8t9z7cwmddbhghdmcmja
X-Rspam-User: 
X-HE-Tag: 1785919517-53630
X-HE-Meta: U2FsdGVkX19sAupcULY5mnJT8F9+c0+kLk/9bqDrXh1uQ4RD06DSLq2w+q1r2dz3tUR6M+Una7kUrmdH0k0jNfqwCGiARalLAnbVi3GfX9qN9xMTRRj9ovraE5OSvso8K5ZYzIS36oOtPUbgmrcwx2SMSuurMaOHgzlRIWDYZUngJuhToxNSdrbK7Cai/n2WCTFxGQ7DeUuCiLN3c2B9FUgWwb5qeKjGsdohu/wT3G5eYmGByIgtwZrW0aWV74r5mozrypE1l5a4/1d9uGqIdJCeY0MHfFIwqx8BH/QFTzuYa4UKOw6C1px79VKu1kk5Z+0MOsL+ey9u+nZB/lSA2Y5VksNb/9jBS2Zx8npNwOiRpOKIN2OFRq6LQU3TXvAmbjAaloUIcfOtffGKWqg9BOWX40y1oUefiY26x+aJO/LAy/1sGf7ESCFLPKKvqSA2DIzJGQau7WYZrDKpPpLtP7H/9xo8qBBUllHxv1JZI9gzkWq6c7EQ86ISEU7jjSWNIsn0glEZzdvw27I2A5NkZfk5uh7odGjRxHdKlyK511TnMHII4SXg5+d+Jq+8bA39rpasuth99/ey7edjIcHExrNUq6lOneyDxN4paB+8RjuxP9AOdsSok9a73bsZq/KuuEMJNrw8Yl5Gc8mYP9JGGwDizD0vXbg+tB72DxXyne7mILW1R6z1xBtpYf6jvWEI6EkvFnLperhqvj8GCX/t7yjJDDvgwutOk6QaRXdzyFFdQeYN9zSry1KueJWzBZQhLRul+uWq4HpO+yut8vQHE2AMM6IaKGg4S367O7zeh2pxRruvf1egoH4WD6mXCOJezdxgL5pCPW4rBn1xhtbcB9PfAY/y4fuyyeTvUN/5ShYkVZenzAUi4Qee2d8NIG4C4VXQ5DPpJe1xGbc07MjEb+aEJviXALMI6L3bBTkszAaTO0yGxDEUCNViYps5Bt9UaICUUQSk/0lVVadQgSu
 Gt59YsEn
 lggVTppEBPjJqRIejgAjLYI9dHV9DrY3YQ69Ew1QCIcifyJghRzJSg70PwmgfE8YHL+iIadrQjfj9fDA3hQfvNVMeS97mtxv4aATXilMKEK3grO+kZqFQeDhu0tiliBVQhEQdXC+I9lEQB7qu5FS7ArFIwwWhhGINolDPD0SPgm7frDwAxze12hRnbPNA3EoKxy/K2LPgcMdrSptXEeLSwFlZ7SOOHwyOB/ZVbFnT2TNfLUnZ7vkJvaQ64erf7K1Tghjm3S5rPA1MsDSZfow8ayI4aMtp4/RXf4zn1zR5DO6GD1MK7h7/JyLQ5LQ+vspsbPQ2z8Zk7Ng2+Zb2NIFYFx5aAdbcOdAaniNUF0mJ1fudlPdCjlbvN7zkpndNp5oYY8am3x7oVyolEU3KYUtY9T4NL7pu+g24u40K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 11:47:03PM +0200, David Hildenbrand (Arm) wrote:
> On 8/4/26 23:25, Christoph Lameter (Ampere) wrote:
> > On Tue, 4 Aug 2026, David Hildenbrand (Arm) wrote:
> >> Mark's solution is the obvious improvement to the problem, doing it just like
> >> s390 already does.
> > 
> > Well there is interest by the S390 folks to move to what we proposed from
> > what I can tell.
> 
> Heiko said that as reply to v1, bit he's been replying a lot on Mark's patches.
> Only Heiko can tell. (on CC)

I said that before Peter Zijlstra proposed the restartable sequence approach
for the kernel. I took that as input, and provided the current solution for
s390, which does not restart anything, but only fix up register contents if
required. Now Mark provided an improved implementation for arm64.

That said, there are some performance numbers [1] for s390 available as posted
by Mete. A performance improvement is indeed there, but looking at the current
s390 implementation I'm not sure there will be much of a benefit if we now go
to percpu page tables.

Currently we have this code sequence for e.g. this_cpu_add(...)
(%r2 contains the to be added value).

larl    %r4,1b33300     <-- load address of percpu var
mviy    960,4           <-- mark start of percpu op section
ag      %r4,952         <-- add percpu offset
laag    %r5,%r2,0(%r4)  <-- atomic add
mviy    960,0           <-- mark end of percpu op section

With the proposed percpu page tables I would guess / hope we would end up with
something like this:

larl    %r4,1b33300     <-- load address of percpu var (same on all cpus)
laag    %r5,%r2,0(%r4)  <-- atomic add

That's certainly better to what we have compared to now (no performance
numbers available), but I'm not sure if only this would justify all the
added complexity to common code currently discussed.

Read: I'm more or less fine with the current s390 solution, and not pushing
      for percpu page tables.

[1] https://lore.kernel.org/all/18ca706f-ef45-4207-a55d-025f90133978@linux.ibm.com/

