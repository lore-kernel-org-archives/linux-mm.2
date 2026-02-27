Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 313C2FEFB56
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 15:14:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194CB6B0005; Fri, 27 Feb 2026 10:14:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13F9E6B0088; Fri, 27 Feb 2026 10:14:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 038786B0089; Fri, 27 Feb 2026 10:14:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E38496B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 10:14:29 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F39EBA727
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:14:29 +0000 (UTC)
X-FDA: 84490583058.13.359F122
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3F1541C000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 15:14:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UCTh0ROF;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772205267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJDWBfSNCysRUwJvl2i5MmHHSkPTb8ONqUHCHbTZpy0=;
	b=vwr9exMBrP9i1zI27JeMriUi70qzllZmk36e5m615pLOwyysqvGl7taswpStjuJojSSqWw
	tIWVpIRWHoUq99P9qQbtX4A1MQD9PnW254XQnUM2ESY/gmiCs8QRi6+Cgp5Mf5XI4c300s
	LTPuM2iL/CvcuV0FrZyVD7Zhzl2guQA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772205267; a=rsa-sha256;
	cv=none;
	b=nWGp1GVeK+pJfITn+4h106tmst2Y/eKwqjAeLZ9HUIywfK1vQBlU4NxiJNx/e9JButQfVd
	sphyoBkmKpjTfV7SOpUMSQNhvzqn/oV+axlpgom94PwmeeFLTaV05ezMMe+/IRXIBZGf9J
	xeWke+Ex4mavV4kj7dFdKTpOAbT1MYM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UCTh0ROF;
	spf=pass (imf21.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61REYGqc1136392;
	Fri, 27 Feb 2026 15:14:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=JJDWBfSNCysRUwJvl2i5MmHHSkPTb8
	ONqUHCHbTZpy0=; b=UCTh0ROF2uP873dNINdMUwKgoIeLMZ198DQ3ExuA7TX3Td
	yJ3LXkrXF0aA6oLQQpdQMPOnUx7UKWBEwaAFweF2KZFQRZAyQCH5B7/YmPrjJaL3
	vV5YQ8FBsgWcwllKh2ek+Mc7QbFmrUwLm6sVGBDSSgllP9CNFNPLiifRrzqyN31o
	ZWdgTS8Yb2WRckcYLNG3NKTwhrNL6ZN+UWLdAg7Q6YZ8pw/79nQo/V6p/TWoveF3
	/OqbG6RPoL+zYe0HHl70wWsyKFySJpIVnqAIm4eUOl6UBJwit/bEScReLYK1she2
	UzKVpP8T4k2tG1QW+broDKURbvZ4UFpO3PUURARQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4bsc9y0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 15:14:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RBTx2t003836;
	Fri, 27 Feb 2026 15:14:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfs8kahmy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 15:14:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61RFDudb45810010
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 15:13:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A10F20043;
	Fri, 27 Feb 2026 15:13:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6C81920040;
	Fri, 27 Feb 2026 15:13:54 +0000 (GMT)
Received: from osiris (unknown [9.87.152.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 27 Feb 2026 15:13:54 +0000 (GMT)
Date: Fri, 27 Feb 2026 16:13:52 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Nathan Chancellor <nathan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>, Martin Liu <liumartin@google.com>,
        David Rientjes <rientjes@google.com>, christian.koenig@amd.com,
        Shakeel Butt <shakeel.butt@linux.dev>, SeongJae Park <sj@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <liam.howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Christian Brauner <brauner@kernel.org>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        Yu Zhao <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>,
        Mateusz Guzik <mjguzik@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Aboorva Devarajan <aboorvad@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v17 0/3] Improve proc RSS accuracy
Message-ID: <20260227151352.10882Ca0-hca@linux.ibm.com>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
 <20260226120422.8101Cc2-hca@linux.ibm.com>
 <59b28cb4-4fff-4888-b562-7b7236e29d27@efficios.com>
 <e0af317a-d6ad-4de4-8bb1-215d5dce7351@efficios.com>
 <73e6fea9-caf2-4404-b511-11646013f8db@efficios.com>
 <20260227011201.GA1577380@ax162>
 <20260227131128.10882B8b-hca@linux.ibm.com>
 <b3447e37-89a0-4482-886b-dde87733fb86@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3447e37-89a0-4482-886b-dde87733fb86@efficios.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: -3T30V_MJlKG4EfyyLoPMq8lNEDS26Os
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDEzNSBTYWx0ZWRfX3nfVMoCIh2SS
 ucYO/H6Pgh/q+6vOm9ka1cfkWtOnJLyjSyOSLoRlMfW6wAvxXKJ1XacSWMeg/510bIvlfZa9/sw
 9K0RoTB+wmJi5cRqACCnPFxxO9yTArgS8raaLgsw4DHNm+k53nQ8f3OLphR3yUw8EDeayFr0g7c
 Fwmy/PE5p8I62l9msrWp7XHvbBWtbtXxsUDRgmCLwDgtyMc0BAHyAtHbx2j1mdXxlurDAZxxvC9
 OtWA/RfN0BOBPNFi1o/hK/RJu+Ersis0q1SDZA8LjpBWd5lq5TyXG4lPUhUOMOe2Op/M3YsbzNr
 RufkWhmWgk3XjF12baRIsxjLh+3roHIhlymjMEs5mvnxOKqVW5BEEFayiMLhEa3W+8YTttBf52t
 VH7W3+BBGslFFHs8GzH1NfusGc7LUkN6FXEuzp8JiPnC8dF/37wUo+K73EM/cNr331yzdcYF7rU
 W9r+TfR0TpCpcx0POnQ==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=69a1b4b9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=crcK52EdEUAz85siLdIA:9
 a=CjuIK1q_8ugA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-GUID: 7nyTaHxWFMAMGrOcBXMXoawwBqgiTdoY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602270135
X-Rspamd-Queue-Id: 3F1541C000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 1gpiitptct3gm11o3beuhuos6k6cd9i9
X-HE-Tag: 1772205267-907266
X-HE-Meta: U2FsdGVkX187KXoByY7iaDtI42YodOrru8LD/oO6LNiq2SKE3aZQn+kf7HRZ1ij5NLz7pkH3/pseamp8VFTu9CSWQzk7q7vMMftJrJk5cdvjVznxae/hZDg33Dd+vShzWP4GCUIgFqvl7U1ySfZlzrx17J+eSiSpljUpHdcLL4w/L6v/rCmcjtEsIFti1dP1anujEyzTzAQX9YeJ8ebuPBEPDF6IkW562lfWNHCB9BEzVkcG3uGGx8Mrzf1/uBjZPezfRGpljBPlYV41OA00v4jLZXSaBH/tRDcGSwVvRW1Zy9sBMUcMmORu2tZCz2ylm5RtIKL66HRUALJlO4iJRUZZNfOy504YjfWEZhEv1TjbHTs+NOQTL3O/24T7ugA+xWiYz9hsdwR7Ax65GXGxD7CiWy6fu1IuZxJQT9H61cjjQb4CBGRUJ8rgsNrNO4AZc8YWYbBFOn191EbuELe8fgPzCB3MdcvSq49LBLxUvnipkgyc9OmGSXCdW9FjcmZqIyy5Ysxmm4G1X2akFCvejevPndzhONRAst+JoGTIyBYrIIeLxi9eWMUqzzPF6biKfHfMCjeoreZnjgvNDPWxtiycU36OQfc4YWADXLHcyAWUckZTUSt55LZtWf9/UYGZ/LF5O1Mhvjjvo6FMbnxHv+fOBeZj9A+l+lx58UAuJmv1jj33DxMuSF523rSza8Y++Rjew+f42UYz+1YGkR437npRBzMWJnl+zsSKekkb4V7/Xv1qX4Bl93rDwNDZb5tPNSdIGbOtboindhsXU+m9ULprd+0TLzWATQtgLDJh1uK4OaKdmY++xqGIj1BCTyUYVv+cUJ56Bo95Hupa34yQpbOEQeOkW4D0yWbSDdmU97xHhQ5+OhNnXJHMiFw9NV6MEA3y2pZ8voDQhFXCnvg8NETzVpRGq7EG4mQp77tYPHerDwRGGxmd2k3pX/zOgx89hykbcDf0O7cvSJXU6QG
 BH+/EEiq
 QebQRi3TaQoJqTIIEmWt3IOGAvivBFjQrm903M4ixu1o42C2XSljpUdKLSHzimFLMTX+oXefvGme7IJpuqX+CAW6/nwsdGV4GVqocr6/K2KNQGspzGeCg1B20QvkNisXMbxm17ny/KzLfUV1wPB7rjGFPMf7TSu4shXxvch3ODzxjjKbLU81SLVdEJwpngB4KUgvuFSeXYpI7cXYpPqV65v7TEdxFg2tG1XbKDlmO7D5f6z5Te7G+AOUn/JpC20FYA1R02YDRwBUd0zzL3DmDe3xH/V+2OxW0MEecJNEbW8i7mH8NUVvyx+FMWC7FAOrxROnU1CLPVeVswfpOqZmhjxuNeqhuyRztinPCXnPhvkdHejF+AEojdHX1OE0j5lbnTi1KiIryuqnn5XqzQ/xTGdul56PBsfYkbHYt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 08:25:46AM -0500, Mathieu Desnoyers wrote:
> On 2026-02-27 08:11, Heiko Carstens wrote:
> > This seems to happen because the return value of get_rss_stat_items_size() is
> > larger than PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE:
> > 
> > PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE: 18688
> > get_rss_stat_items_size(): 21504

...

> Which fails to account for NR_MM_COUNTERS. Does the following fix your issue ?
> 
> #define MM_STRUCT_FLEXIBLE_ARRAY_INIT                                                                   \
> {                                                                                                       \
>         [0 ... (PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE * NR_MM_COUNTERS) + sizeof(cpumask_t) + MM_CID_STATIC_SIZE - 1] = 0  \
> }

Yes, this works.

