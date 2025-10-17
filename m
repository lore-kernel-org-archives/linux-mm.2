Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E850CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 15:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C23078E004A; Fri, 17 Oct 2025 11:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD3F18E001F; Fri, 17 Oct 2025 11:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74CC8E004A; Fri, 17 Oct 2025 11:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 919BF8E001F
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 11:54:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1297D13A0CD
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:54:55 +0000 (UTC)
X-FDA: 84008054550.09.41FB33E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 979FE40007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 15:54:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Law6VkvY;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760716492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQ1TtLHokmslhzFjee4cGuD5m+V7qM5aPPie4zC6OAs=;
	b=cmlNyZQybWUBDRy9MxbbzSZ27jQGs3Ss2r4zDfwaI/f2ZTIfHSNTIU5awkOGyJV1i0o5SN
	dgLbmzd+JVKflSJC+eZXKw+DdqlhrI5ARiPmTiuSRUi3xJTSRIsV6fxljUwy61Oe3v/Kcx
	Ls6GogrtJgBA+FfE95d+0QN0+G3sSeY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760716492; a=rsa-sha256;
	cv=none;
	b=ZT5tMdRolKFPiQKxyXNzQmUB3S8S26f++eGv3VYX2w1qU/Z5t5xWv70Y0Xz+cQGow3Qb7v
	rssOOr5ETNawwUFO5clRxQMQjJfvdqWZsA1C5AOa+yPdKmSIbP7DFrfJH6uX7HTYZ9TgkN
	CB3pOD0bNalYcR52uRENE8/C5rxZRdw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Law6VkvY;
	spf=pass (imf27.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HEGCDs001269;
	Fri, 17 Oct 2025 15:54:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ZQ1TtLHokmslhzFjee4cGuD5m+V7qM
	5aPPie4zC6OAs=; b=Law6VkvY0ICKNKchLEppxjum8vOcIanSKnBL7OT7PTmQg0
	/6qxbBVReHS20QCrAw8Mw10mAM94rLvvh5tD8wbUb+e/utZivGuGVMyuc5GqkixP
	9WWXmRLKv6pzkRAEKw2FfWsg1p5GZVTfuvuxnFm6T98IRMQAUQ+8yc/rD5Z5b3uH
	X8d0zz6VYhOyCbAzuvtAz8NrnXH38xtQ7MCVtxDrzdSoscnaYPFy05mStbIeDDtp
	SKaXWeccmeQ4KD9PLzrxCjVQVpjNf13uY8Trn2RjdAn/nkDZsccyOmP07vNlXyJ4
	AsYtlADdQJJL2sQy3nsR9lxvDfusEAX4XJPoEovw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp8em13-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:54:20 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59HFmLFW024554;
	Fri, 17 Oct 2025 15:54:19 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49rfp8em10-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:54:19 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59HFlK7X015010;
	Fri, 17 Oct 2025 15:54:18 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49r3sjwvr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 17 Oct 2025 15:54:18 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59HFsGL659048250
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 15:54:16 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 503512004B;
	Fri, 17 Oct 2025 15:54:16 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 980F420049;
	Fri, 17 Oct 2025 15:54:15 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 17 Oct 2025 15:54:15 +0000 (GMT)
Date: Fri, 17 Oct 2025 17:54:14 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Subject: Re: [PATCH v3 06/13] mm: introduce generic lazy_mmu helpers
Message-ID: <55f8b155-5468-43fc-b6fc-f509f4becd5b-agordeev@linux.ibm.com>
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-7-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015082727.2395128-7-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2uFWZ81CE4CiNc9aZu2A8JlAcBwqq-tc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDEyMDA4NCBTYWx0ZWRfX2Zriy77SuQpm
 /GHNuVH/UFB6mOfHOC2AuP5g7c+urTyXE81dQ6L6B0AwkiPLgihig9dwBQiKw0AYwvyn2/UBXXe
 VcGvFB11D3W4lhURudq3zaSM9GHtCo5XdEsYeLbFUmnzVB67HZP20B2Uxwsqr/DnC0GUNt8pn+Q
 lYbw9Nsugz7aigNaGXWz8mjQ5H0X7sXZm5KLMDqasP/WlwVPUM+i7GhB70V9ACBzBfu/gATiLsp
 HWtKR/YcgMc3XVsjOXDXb6rwcyJoPiLdVPL4d9Uovyfy1Y+6KXUtJGTOvjrlEvC+BEx9y22ul4M
 iyiO9mTSInwQOYOlHV2G1yBHcLyrhGstPiwazxXG+Q1pEZlUKx7CHtMC4Sa0JzAFx3fiGUVZ0Ll
 LSljgWznsRluu1F2sKhweaOdRoS3mQ==
X-Proofpoint-GUID: B3M2xirfIqNJrZzR03DBgN9gZToY0y4x
X-Authority-Analysis: v=2.4 cv=af5sXBot c=1 sm=1 tr=0 ts=68f266ac cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8 a=1KDjgaeL6VvqQMJ9c2UA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 suspectscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510120084
X-Rspamd-Server: rspam05
X-Stat-Signature: uw5anyobdg7ib6h96ipagagjhj46j479
X-Rspam-User: 
X-Rspamd-Queue-Id: 979FE40007
X-HE-Tag: 1760716492-428746
X-HE-Meta: U2FsdGVkX19ewXTNcYhyFJ0ta6xke1UZPje98Stm+0JJVpvqjKYxT8IZ8C3/qVTy9cifJdSnct51/yK6oM7zE0MJxlCMX0ZTBHVusEUVv38SKGDqvfhujg+bsjJf9Hj6VxBRJyC6WbBT3J3JXFjdZuLI8b15iocYEusmtXPZhOVRRPvsBbzLTmFS2EtlDWjIS8s/Rbap8AxMxiZL9mq1KEdbFomPYiTU3dxl+dQ0zJVA7v+p42DKsT65AXzuhjkTk/B/6YL0TMuevHVUwTXFYvAOeIhxX6X66uD5uQQA6SFC8gusrXWN96vKJ+ilegLsB8asykmulI6/vKO75vQpiT2cGLJiowQJjrO+w4e0DOz2vKbjEP1mhCHaKJMtVyjxAPWZMA5ymG/miCF59YAayajwXf6Jc/6o5Fcfpv2XphnJCeGN9GggczAzhZHc2khcWeyv2bNCZ3nub7k+zLtNhzw2G1UkYkJREqLd3t61NKiX3VwgT1EDK971sr5yTnUYaHoLttPeN+XR3OE4QaN6sF6rYOpbIPj5EaAtauFn368XMDjqVYXsR5r1PtKkKKYFPWBtoCA49GMZFR9y/TGP4HOxM600eQkHzwpGPZxiiY8+kpxjYrvUtbidtjK8bGaqhyszbl72D5TY7INAmxPGxu7JTCZ0ddtubm4MlJWa1nVdTiWvn7x0u8yCjF1DNiG9G5lR1ExSbk7CJcVs8GtOKX8lkKtDpxhcTfSvGhQwU/zpUmLZDHuTywf6c4QMODEh/BppqN9AbdboUADtNA/VfCSEAjy+n7CjKukMOE/I2aW24KchiWSmLWhsQDPIzzfMm0YCEdiPtSNrECCawrUTUimO0CSCWCIiRC8SzWvBwFm4IHKiXGfUKa9RsiHKdAtgpjdKA+sm6JBkxPO4WmzLFnJTC7EWGZVxFa2KQt/j90cVZk1PFjavLhGV26C43q/bGNAo3FnCtQ9jv+Yle1u
 NGWLss7/
 jiiKUAYORsCiKWLWF7qBOudpMNEPvgI2khAe9tT/TydB/LMokZLOioTy+69+WZ483AnQYDMouPNEPDuK+I939ySEcK1J04iwe++lCv4VDIHfJT6zRkzaceQ/6gPoVbE9EuMsg3K1TWA6Oi9RPh4hKTw9kgioR1tUUoIabWzmMlK3axSAoQb4Pc6gsbQHOe3+wA92ybvp3uDybWiAIuejYUCsAhTAVEouzwaildxFLb1SXtROJLHr4Jr/GDtkYyToELVh1PqjuAxB5rVsbjYS6gjgtZvwpB7mo7H+3MKzijXvntBMQ8jaScUPWAhD9hapoG/kNJDJERa1pp5dZuQ4bk58URQ3iUnWGOmZcSMlDJKb90mnDkHOrRa9q8TtDWrbRVCLqMJkQEo6aPih6B/V32uxEEdLR90oBSSXj8N6R/uPgfDZHEJXLFYaUAs5aLSSkr55Oox9xtHeezCIv/zaYgjkIoBQCCKvfRI9fLmdR1/jvGEE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 09:27:20AM +0100, Kevin Brodsky wrote:

Hi Kevin,

...
> * lazy_mmu_mode_pause() ... lazy_mmu_mode_resume()
>     This is for situations where the mode is temporarily disabled
>     by first calling pause() and then resume() (e.g. to prevent any
>     batching from occurring in a critical section).
...
> +static inline void lazy_mmu_mode_pause(void)
> +{
> +	arch_leave_lazy_mmu_mode();

I think it should have been arch_pause_lazy_mmu_mode(), wich defaults
to  arch_leave_lazy_mmu_mode(), as we discussed in v2:

https://lore.kernel.org/linux-mm/d407a381-099b-4ec6-a20e-aeff4f3d750f@arm.com/#t

> +}
> +
> +static inline void lazy_mmu_mode_resume(void)
> +{
> +	arch_enter_lazy_mmu_mode();
> +}

Thanks!

