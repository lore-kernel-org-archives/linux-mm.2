Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982FBCD6E57
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:58:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C17B6B0443; Mon,  1 Jun 2026 11:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081346B0445; Mon,  1 Jun 2026 11:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB2876B0446; Mon,  1 Jun 2026 11:58:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DB33A6B0443
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:58:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 94BBEA0711
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:58:49 +0000 (UTC)
X-FDA: 84831801978.06.253A63B
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 57BB3100013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:58:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=q2QdkTfq;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780329527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KVDcpE8o3uuZ0QtgmIrSs5gbQcnW7ufMsS7wcVBG0y0=;
	b=RKyicT+cyJiYRs0VQ/YDGgd2ehpd95oyKIOh3O0GNmBO0n95Q6SK7O5azFjqJRQaHRuzBW
	IwhC5Bne34HoJWodvefHmxW1T3jXcwz20iixbhnFsw/Ps8z8hU3xabEzbUGEHECBqMBtkz
	L9Bv/FQs+3ROguQwlOl4PemfN8EiCY0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=q2QdkTfq;
	spf=pass (imf14.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780329527;
	b=r/lTzzFjUYmhzwqfgjPIgNg6G6CyMjvgGvzfdEVMQVj6uYvnjjC839wQszZCp8vHml8eEJ
	B4hZZGjAhGkzeqYglx8z+ExmYndypHFThCjho8i/MYFaDe8t2oweGp6wTIKykk263KOf82
	e+4w24Ywzgf5yxeBQYa/f50vUYrk/E4=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651FjTT21175050;
	Mon, 1 Jun 2026 15:58:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KVDcpE8o3uuZ0QtgmIrSs5gbQcnW7u
	fMsS7wcVBG0y0=; b=q2QdkTfqZHAjJj6NGKVw3J67mUzCoAuC+MTAV8GC3/zaW9
	XtLE487z/NKZ5qKkyDwv/S+6iMMlw3V6LRpHuLxSFLtIp6BQl3jJvIFpXtKP80+Q
	cLSwCTjO92d+3x1Qk+5xIAALBeY++i85qezZua8O+5XpRiS0M68ocS40QVLS8PO8
	E/By7XAg35tBjAmihLn2f4jbL8zn3E3/Br3GnKBevJtGaQ7cYYwYTIxnvgIgnLfX
	8eXASZjqtx2pEYKqSazX2A6CopNEMhVPguYg3JQSunWtGFSrvvo4vawgTdUrS0oB
	oDKTVD/tdAuasZ4Ln5rLPbPZHZoEtzGHhUQ+yoWQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqht172a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 15:58:13 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 651FsA8U031542;
	Mon, 1 Jun 2026 15:58:12 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egakvq0j1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 01 Jun 2026 15:58:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 651FwAUK17236468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 1 Jun 2026 15:58:10 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEA1C20043;
	Mon,  1 Jun 2026 15:58:09 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 338FC20040;
	Mon,  1 Jun 2026 15:58:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  1 Jun 2026 15:58:09 +0000 (GMT)
Date: Mon, 1 Jun 2026 17:58:08 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
        anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, byungchul@sk.com,
        catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com,
        gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz,
        jackmanb@google.com, jannh@google.com, jglisse@google.com,
        joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
        liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
        matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
        peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com,
        raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com,
        rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org,
        ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com,
        surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de,
        usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com,
        wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org,
        yang@os.amperecomputing.com, ying.huang@linux.alibaba.com,
        ziy@nvidia.com, zokeefe@google.com, linux-s390@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes-unstable v18 00/14] khugepaged: add mTHP
 collapse support
Message-ID: <20260601155808.2755103A59-agordeev@linux.ibm.com>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522134724.f4f11941a85ef18b307d16ae@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522134724.f4f11941a85ef18b307d16ae@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: zz9MilW9xXFOzhEU9qIKtRU9aLy1QnrY
X-Authority-Analysis: v=2.4 cv=fv/sol4f c=1 sm=1 tr=0 ts=6a1dac15 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=20KFwNOVAAAA:8
 a=0zv6X75myPOFEK8-PwYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAxMDE1NiBTYWx0ZWRfX0G2anm6Vr3Tg
 FnBeiiLFKss3NmUYJabVHvzgxZlzFUdopz3CFGWsaz16v+NfjFYyWWKVWUuMIyS6wbMHdySM0XS
 EpkQ/E6SDF5X76V99R0yTVd4ya1k/DnsWBJox4kZ7TKLs2QUetkDWYIMSZuERfq7NXaE4qk9nQE
 or/Hban403oWACFu2jc/NQi3wc9do598+g+RKZ+rhV2Duo95+NDsKaFiW8yZTcSaK0ugDiP45kT
 LZlIf3NvUpqmzCLTufeT39myliAQCworD4TMiHEIKVECPljCJHj1PdjN17v9TWNIH0Q5h8IOlRG
 38KQXn4H+2ZU0VZCzLpquosBR2Yu5u5cPNF3dxyUJM+BN0L7Axd+ZGAHiFa2MWh32V24sIfCtTd
 Cdmj/gWHyJ4QLHlcUNUZIqcuhL5weJfO0VzwIlnPq4O04fEoWX7ne7/v9PaTXYPEbKHs/5Xw+It
 xkJMdfgX4+6Oo5kFlBw==
X-Proofpoint-ORIG-GUID: Gis_J_AWXVxuOO3_TimOrEpJ2AcZY6SH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_04,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1011
 impostorscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606010156
X-Rspamd-Queue-Id: 57BB3100013
X-Stat-Signature: y54rgz7734fgwa3hact89ybapbbwkqah
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780329527-553205
X-HE-Meta: U2FsdGVkX19648PsuhQBY/YoA6qZq7Pm0vU2ZzcsXI3B4bKTGQdu+s9U1IjsTbmpuaPRBTylLS85FSc3gNxjM73eEKtq1YDRx4mDnhpxkdA/q3jndx999YHRcIxWBOwoENyjr8DZaiHqUg11bWHu3sjs+wBPfOCSIj6Bu7/qCKINiIVJsew5wP+AzUufTefRIY1ItmRLIMoLxm7jWr202IPvC9L5wqetYBv5u1Q7NJnShfNpI3KdEGIwYg60huKdJAOz8YJhbX/a8qZCLifJ3YXi9tW8SuGp//n4BN3+kmdb1DpssJblCkpjIKafNbaIH2m3u5nv8smI4A19WKb4tv+ftxSGZDwfLryXoHidxQWcpG1iefULQ1vbfDUhkXGMefQPIdxYnWVEueFamSBSbRiAIc1SSYbDG0ZrrfwgAUVI6hlMHuRawwsXkJPwg4EjXtBYL0M59I5zYKQQk6xfSMiLPKL2GvmOS9TxrVvertDNArd+UwlSPvY/frLlMkjPr46bAVA439cK1+JDjqNbkHttQP1wsd12Rs+4qG+xAZvJBbUCaIKRUUVhbesl4hMoqvUZ+RDseTJXQ9dQUzNek3NSc1vljFZs98Ys7GsHOhrFShpLv3NRTVs9A2QJFrXn8MpBMRIaCmA6wu2hzdr6oOay/vO6D/5CU9MMuai50MCa6R7hsOIbmtsRt3+RPIRMAo/BlGl8dIbC4paEaoORhFC0gntn2yiAu1WT0MeyxYzx+UCzJFyv5x8knJeUAP605tCXhx1wO/4eP9dMBubLPi52GT5BZkY9u5Wqb7ERwkGc1kck6lSAICDKdnma6uHvsK8DtcaVhL/6IYeFglfBD/vPf2ziPvG92PetV3ThAWFzUKk6GwbeW8FAXx3wAsKYREiS9Ot38X3BpDh9UWkZrEan/0X04UlUA17jwjPX8Qu4ze70pYKlCaVQUsKkiAwKcdcrW8dr7FFSvSsOUu9
 HisfWePp
 4Xj/8QhenfLUKqpK0rqLf+oO1GBW8wR52cbX/PQXG+JVct19X1F8vxyAHFgY+MuDG1hBVkjWdtK4JoUg2lcneijGHFEDZ/9zmeq78g+7W/6L6XThW8XrUJoTAs868Q4ykP1oJz3BSnnZ/gVYh1LjtIIPUBzG268q+A5ecDtcAaGl5yqB7cQ1sE/74NAqTprOtIIp+n7U2Zds6lK6ihMRblPRQf85kUxPdMmytVjV0I3kgrGytKOGkpL18YLQpwLUDFppgaPCqURSOXJLTsQnWnGp2EhfwWAzufWBXLKoPDetnWNDsxPdjiGl37UFV/b6tILvh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 01:47:24PM -0700, Andrew Morton wrote:

Hi Andrew et al,

> On Fri, 22 May 2026 08:59:55 -0600 Nico Pache <npache@redhat.com> wrote:
> 
> > The following series provides khugepaged with the capability to collapse
> > anonymous memory regions to mTHPs.
> 
> Thanks, I've update mm.git's mm-unstable branch to this version.
> 
> It sounds like I might be dropping it soon, haven't started looking at
> that yet.  But let's at least eyeball the latest version at this time.
> 
> Sashiko was able to apply this, so the base-it-on-hotfixes thing worked
> well, thanks.  The AI checking made a few allegations:

This series appears to cause hangs on s390 in linux-next.
The issue is not easily reproducible, so it is not yet confirmed.
Any ideas for a reliable reproducer that exercises the code path below?

    [ 2749.385719] sysrq: Show Blocked State
    [ 2749.385730] task:khugepaged      state:D stack:0     pid:209   tgid:209   ppid:2      task_flags:0x200040 flags:0x00000000
    [ 2749.385735] Call Trace:
    [ 2749.385736]  [<0000017f63c8b226>] __schedule+0x316/0x890
    [ 2749.385740]  [<0000017f63c8b7dc>] schedule+0x3c/0xc0
    [ 2749.385743]  [<0000017f63c8b888>] schedule_preempt_disabled+0x28/0x40
    [ 2749.385746]  [<0000017f63c902ea>] rwsem_down_write_slowpath+0x2fa/0x8b0
    [ 2749.385749]  [<0000017f63c90910>] down_write+0x70/0x80
    [ 2749.385752]  [<0000017f6313407a>] collapse_huge_page+0x2ea/0x9e0
    [ 2749.385755]  [<0000017f6313491e>] mthp_collapse+0x1ae/0x1f0
    [ 2749.385757]  [<0000017f63134fda>] collapse_scan_pmd+0x67a/0x8f0
    [ 2749.385760]  [<0000017f6313751a>] collapse_single_pmd+0x15a/0x260
    [ 2749.385762]  [<0000017f6313792c>] collapse_scan_mm_slot.constprop.0+0x30c/0x470
    [ 2749.385765]  [<0000017f63137cb6>] khugepaged+0x226/0x240
    [ 2749.385768]  [<0000017f62db3128>] kthread+0x148/0x170
    [ 2749.385770]  [<0000017f62d2c238>] __ret_from_fork+0x48/0x220
    [ 2749.385772]  [<0000017f63c95d0a>] ret_from_fork+0xa/0x30

Thanks!

