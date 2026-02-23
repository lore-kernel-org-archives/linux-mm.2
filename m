Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F9FE98E10
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 09:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12D816B0088; Mon, 23 Feb 2026 04:19:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8CE6B0089; Mon, 23 Feb 2026 04:19:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F30AB6B008A; Mon, 23 Feb 2026 04:19:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E15D96B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 04:19:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87D83BBA92
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:19:35 +0000 (UTC)
X-FDA: 84475173510.04.8E44A2D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id 451D01A0002
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:19:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k5WprDZ1;
	spf=pass (imf19.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771838373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1vvgdbabvq4XUBn6fv3p47LMst074M9ZInSRkAhcpA=;
	b=E+YqyKv+f/WA/Lj6kkV6ouT44hbpjVb8xalSJp5+MZQIz0PjSzek56fDOIDhXVBhmLOORY
	ovKW2b2ZrGojNz5VQ/NJnlYYXq7T6+jnGcCDN8kqdAHJiwzC3kwptu0nUf/1kZAg7XLosv
	w5cHKgRKKs9JSSw5DT+gaw29/8g7AmQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771838373; a=rsa-sha256;
	cv=none;
	b=rlj9dI7LHzFtU7C01slBKBFtq1JGA8sWmAEY2g+Fy5ZbVXz1DRV097ZR0yItDKLqzASFyi
	HZN7FlJtOh2lbJSLXLzBIEFYTYLfwVIhkTgKIzLZGeUPIOJY7267QopSyaGv1GCZHKWAFa
	W91O8IiKOzVCjQdsT0jTgT4TNszcWs0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=k5WprDZ1;
	spf=pass (imf19.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61MLlYc62582842;
	Mon, 23 Feb 2026 09:19:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D1vvgdbabvq4XUBn6fv3p47LMst074
	M9ZInSRkAhcpA=; b=k5WprDZ1OuWFkzw34uw/VqQN4SDbnUpXhgPcUv5GQ/8JWv
	LYMA+BWoTROdpG9+CUJPx1K06atld6Rd9241y7ca0eyMRc6V9PRxIXrG4kjFyK0M
	6GCegn6N3jWZztUqiGAxbrz5MVhE02JqPQT8yHXDSwVge1Ph3UYpnvOGcne7pJnk
	C/T5SWgQIdr0k+2u3ajk/k0uV217kUjC08s0SqTI9gMz8fyiw4fhXvFiEVz1KEhR
	mJKHx5JK+7A1FQNKaRjtzGV9Tj8hsP4keY56owiRj1rFA6BNKNqP7yAo7I/PN93m
	Za1+Cm8j4K3Xb2MpvLwERAef26u9HoMl4H8D5qDQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24g68ts-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 09:19:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61N4R5Pf015750;
	Mon, 23 Feb 2026 09:19:18 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfq1sc99r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 23 Feb 2026 09:19:18 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61N9JGKm45809994
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 09:19:16 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F162E20040;
	Mon, 23 Feb 2026 09:19:15 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A18A20043;
	Mon, 23 Feb 2026 09:19:15 +0000 (GMT)
Received: from osiris (unknown [9.111.54.98])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 23 Feb 2026 09:19:15 +0000 (GMT)
Date: Mon, 23 Feb 2026 10:19:13 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Dev Jain <dev.jain@arm.com>, Will Deacon <will@kernel.org>,
        Jisheng Zhang <jszhang@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, maz@kernel.org
Subject: Re: [PATCH] arm64: remove HAVE_CMPXCHG_LOCAL
Message-ID: <20260223091913.8139A0b-hca@linux.ibm.com>
References: <20260215033944.16374-1-jszhang@kernel.org>
 <aZL46z1UZkQlF3Dd@willie-the-truck>
 <89606308-3c03-4dcf-a89d-479258b710e4@arm.com>
 <6d30176d-9673-287e-4658-a5e9e6e5d649@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d30176d-9673-287e-4658-a5e9e6e5d649@gentwo.org>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=699c1b96 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=FhHsSIHnO-3NYp-ZkXEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: FfOG356PllBGcL4cFZoTPHDdr2AldGay
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDA4MSBTYWx0ZWRfX0UoJva7jCva3
 z9d41zV4OBne2pTiVEEhjv5cb5YHPlpt7K+P7rSz15b1qEQbW6Jpo1ge+Lm0BQnyW9fRhYP6CKH
 HZ4QpIfQeGXfj0tMd8dV418IKUdcq3Po6Pupx9dfAuHhwBNGdeClkWUlMyDWoOiTiDR6rcY7wuc
 vXv9v9qaDOiTso5w+px82r4J+peiUdh0seZCfNv5dpd7V6Uj7Ga1Q1b8LWI1Lz2ruVLoDE596f0
 syF+WAvv8JDYUhxBiRTPwpUb+jqhJ9sszEReTuGuaR1EgSDm2G/DYqc1r4JZjinn//lh0rs9+4v
 bMiNTEFjFxLhP0AP40LRn/Y5G/hoR8wiOfFhxXQqOArg/fiGa2e+aY0aq2qlg5ApL594CKGpokb
 1+5lJ7fV0ZJ0QTk5Xp+HoK2sJC08hinckBU0MK6gvELhay5aXl5h+EE9v8Lc/2kXUYR/lTHa6LH
 wqV6Ki6fO0bOxge9ebA==
X-Proofpoint-ORIG-GUID: FfOG356PllBGcL4cFZoTPHDdr2AldGay
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_01,2026-02-20_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602230081
X-Rspamd-Queue-Id: 451D01A0002
X-Stat-Signature: igahead4f5k4j4id3qyzoy19t471frq4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771838373-418621
X-HE-Meta: U2FsdGVkX1+aBvnMGXggVZolWAXWimuZaARJQCuzwG4r50anZmpsjVWYu0SUSuHol1W55TaUXyjTYkinsdhSi07Uys0IFe4Dkuz6Dgrg2TyyAvv9OrWlVMo4Wwxwpn5plBjPknrYDobIKpt6CcgV3gClmH3yFRyN7rk1NadBH76ihrTvFExAGQJfRmA+AgJxbEiQLnWsQJqSPxFc8V5Nquf8lyQ3J69m/AXsIgiaeeVBgHxPDLn/BK6dPuFxQ8jxuuTsCf7l07mRmv9OproMWePPZWYMD+Sl+3+cjZqkMDFG+3GWaso/53o8aRqiWnzTysPzaBYnPmcio0W4MTWS/TWOee7DX946NFfQy2YOabyNjgf0tHk23QpEmkH1qEfmg6ZklRvBRGnrKkragPKTQeb6wvQIUas6RL2G2BiItc8yW1DXbzy67tkiylMinoM+0QmT1s7I6powVvPq4P03yOV8S6PNKY/ZyJoGsHaRjS2s8E7YoqskKAkbX+Rs5F/aYBgyXBqUkpp2UhPb7eD4k6rk3N+kg2qesRcSs6yvmfunxQqZugtCdLmjGj8oaMC4v4HWf17rNiezBavSYBgy3yZCSMt64TtVnVHVYYmjhAoGxoIBz+UhTcFVAkTkWMJfkI7Qexfu9ftwCgsB+nghQvPiCELlpAtvnbg7tMWBr3uPlCb8A7nt+xrzNtTQ1UTrNbXlHt0hQl1FCnJrPE3DQwDEdYlzDU0Q8NZ0jtf8S8QLAAj9gaDjtez2sjtDFSfs8Yi1dzXFmtXDBcZVejs0o3Ll1KUkFZAfSCZIw6d/tD0TkTTw1HfxadtxxU3Ue06RwbE7zqpWBY2DshpjfHZoff7e9/7NSRUWCaveo+J8z6RcE1E4JKmrFOKjDIZQNXbNbkjuS0yB/EmpujprPeXs6YtnYE9WF4DB2zVd3VQQXKyBvTenWJfj98hs6AXA8h0z3510Zi3evhEdLsWcxKC
 Zq6/JOqr
 aWEmbsEBDfhQwBdH444aWglZB4Dzl5OS+ctU43WLUVglsW5m7f5U3xy6W1fNJfmfd1THYkphT8v4OTj0TXJVwjXw6PSZoV0aeoUWDYMjLEysEEecvnN8woWuZkRJ/8rOXHdpxu87XHEtSyhc8ltU8wfICie1H5e4TfgtxMFfXWU1bqV01TPBmQuQ3E58Wqbylb5SquzwXdwGMX0s3f6yKr8+W5QYid0WV7Wm/zZlgxKwg5fr1XHOdctYYi30f9HcDGopEkN6l2VbabQS2MGIuZax7VmuG4TkulOneHD5oWGOseuz7oKFWOoXQRckzfN8OUtpJspVPD0cDlYm8Ge985HtgXwHgncxZTdoWTysvZLnBmZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 09:19:22AM -0800, Christoph Lameter (Ampere) wrote:
> On Mon, 16 Feb 2026, Dev Jain wrote:
> 
> > By coincidence, Yang Shi has been discussing the this_cpu_* overhead
> > at [2].
> 
> 
> Yang Shi is on vacation but we have a patchset that removes
> preempt_enable/disable from this_cpu operations on ARM64.
> 
> The performance of cmpxchg varies by platform in use and with the kernel
> config. The measurements that I did 2 years ago indicated that the cmpxchg
> use with Ampere processors did not cause a regression.
> 
> Note that distro kernels often do not enable PREEMPT_FULL and therefore
> preempt_disable/enable overhead is not incurred in production systems.
> 
> PREEMPT_VOLUNTARY does not use preemption for this_cpu ops.

Note that with commit 7dadeaa6e851 ("sched: Further restrict the preemption
modes") at least PREEMPT_LAZY is enforced, which comes together with
PREEMPT_BUILD and full preempt_disable()/preempt_enable() overhead for
this_cpu_* ops for every "up-to-date" architecture (except x86).

PREEMPT_NONE and PREEMPT_VOLUNTARY are gone for those architectures.

