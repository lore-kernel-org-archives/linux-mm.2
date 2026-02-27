Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85612FEFB47
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 13:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9B6C6B0088; Fri, 27 Feb 2026 08:17:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73A16B0089; Fri, 27 Feb 2026 08:17:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D72C96B008A; Fri, 27 Feb 2026 08:17:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C67506B0088
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:17:10 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 79F2E1C83C
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:17:10 +0000 (UTC)
X-FDA: 84490287420.23.73A92A9
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1BC0440006
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 13:17:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BTJR2vm0;
	spf=pass (imf17.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772198228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6WjlJpHQKzBlWKVpwqyUEHBeZgBzSxY5388W5FkL58k=;
	b=lrKmkQ8wOE0JvClcWO9YItdB4yNyPtbuYWsbHbozLecne62DbuoXOJwwk0dU0WmKNOZJV4
	jCLgkycnfoyRIpZQ40B8TIk0ERtaP4JSDm2uLlZ7tp8jEFcnqMhq0zpV4AUbTVWpg5HYBt
	YwM2J3kg96s2HHl7A1JrChpputW6/Rg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BTJR2vm0;
	spf=pass (imf17.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772198228; a=rsa-sha256;
	cv=none;
	b=c1iVr9Tmky/sT4LDRouthdrSBEbteJZl5O7U23atKEUvtcmPxGSlR9oyug+Dqdu1Q4EaAv
	24bvKCxAPLKEa43TEauA0GuDIzof4EqlR9ln3PTamSU0g3B872+WRSMoDmgEzE68+jLIEo
	u/k8lUMF9DqXzJ9bowu+BgiAgm7Sjs8=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61R9viZC2757367;
	Fri, 27 Feb 2026 13:11:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6WjlJpHQKzBlWKVpwqyUEHBeZgBzSx
	Y5388W5FkL58k=; b=BTJR2vm0fDzeENYLqFYQ2dDe9icMrOXI9wTnvA2kiCnRXT
	gH1/CO/zfo9nMNHYB//RjWvssL7Jz3YhxGCku3qzLac2LDUj+0dZfWUUqhhdJmNg
	CPy2NxjTo1PaiA9DGaX+nGmfBW+JE7YTq0LUKBKIkNuBgL7s8XZQX723E/+JUjM1
	WPGJGeayO4+Vg6u421YBaKJdFhjDfFUZdz9yRVNimgY+KXBROLbUzWiXYB6+DUJG
	br1pKLQCMoWE/yOg38mNMsGzlQFbBUZ2JqRh/H/TJTEUqHcC95Fq8kug6evVHJVf
	RoKAFgmg2zFe+LSbyCw3GXu81pVbzuwIaLvGK1kg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24gv1u4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 13:11:37 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61RAXfZm013419;
	Fri, 27 Feb 2026 13:11:36 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdyjdvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 27 Feb 2026 13:11:36 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61RDBWJM31785484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 27 Feb 2026 13:11:32 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB4192004E;
	Fri, 27 Feb 2026 13:11:31 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 05DDA20040;
	Fri, 27 Feb 2026 13:11:30 +0000 (GMT)
Received: from osiris (unknown [9.87.152.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 27 Feb 2026 13:11:29 +0000 (GMT)
Date: Fri, 27 Feb 2026 14:11:28 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Message-ID: <20260227131128.10882B8b-hca@linux.ibm.com>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
 <20260226120422.8101Cc2-hca@linux.ibm.com>
 <59b28cb4-4fff-4888-b562-7b7236e29d27@efficios.com>
 <e0af317a-d6ad-4de4-8bb1-215d5dce7351@efficios.com>
 <73e6fea9-caf2-4404-b511-11646013f8db@efficios.com>
 <20260227011201.GA1577380@ax162>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227011201.GA1577380@ax162>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=69a19809 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=WbwKx_aOVzRSyFeedoMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: engyVFzmJTSGnUMACbHisbjpzir_4QkW
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDExNiBTYWx0ZWRfX9eYZTNcw6g2P
 XnyXHaBQR2w4S6iIaEjeDrN3Tl4S5BS+b1ccOVoqOrlenCRnbcJI+UGA52lDiHrjUnH5IgtJvno
 d0GTfXcVAxMB/eamnwOZGZFB7lbsEi3zYsqCwtCIYQ+ZDgMsrX/4I4pAouHpsCK5YmueKAuLNcH
 Aiz5gXF6j5bgA7nUYcWI8UnfAa4vScjmTd5e4HOaO/GL0LociGszGw9NtkE0lk68neAlORVgXKf
 BpFR7pTI+cPo5bZgVIWD1cQ80vJbpxWQF1jQKVRiBKz6UbY/VqCRzMqgnCaYHKdqEylsBwIVZxO
 VUAKK+iSCqiklIaXW/E/vASlTdW8tIVGp8Sm+hg1oVqhqBrzzbMBalfblTXv3OUbfikLM2OxZYX
 IBVMMGaHAImkE/4DMwKPhkA/cITJnZKPWrx7DBFizU7qdDkdyMAST2awCKBLDs7GqhBDL9p2bE6
 LQ+dt6dcbyObu2cSLkQ==
X-Proofpoint-ORIG-GUID: jr70vzbDxhadr_F2vwxMHo9jZkWB_9Ig
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-27_02,2026-02-27_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602270116
X-Stat-Signature: 3bqj79nbktu75pf7j8pifo7dssp7osri
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BC0440006
X-Rspamd-Server: rspam04
X-HE-Tag: 1772198227-848771
X-HE-Meta: U2FsdGVkX18r7TFhsHXoM0wl4xAtbgEE+68CA7L5c+DzwrPi/2/yKqaoecWlrdCvdRV+Dl1Z8hXx4qEUCrwceFOeuy5OpJ1t6kF7TBZxhIupimPSY7mWYE8PVriQQ45hNw7YOYLbaKDiXRLvPypSBWhZtkd471oliLHs6SD3TxsQSldSOdpFpaljCHSsHXFqzMoQLxzosweVNa7wfZYhjhAuxO08Fdp67Z2Cq6jW8xw0Cvm4mSoXkoKXf/7SOuI5a4lAYRsxpE+iYufF5bRia0fiCGcCih4StY04kSs3E0nQUtMrxpjVdfpr1/JROWdxFXPK68NZpTnGcuIdwQf/HdGClaizWITHZBexNT3Zch1GXjxYxQUhYBTLw8EWbEa49+vA1oSNjdizKpO8YVQort5ROOIjEAC017PXDEfHiPijh8R3oGa0ACjukxxp0qzwtouNqsVMnFO3lCJ8JCU6qFfo/j9AVGHCEtpqNCwxboZXf/iiPwfHkmoy9x192Mb3+YMH94EfGtR6dQAgrGTDb/cgq1yEYKQ7XPkbU2XrIi+iAo/CE3gdHWeafB5x0itmX6MesURYt6jJnNhS4rjGM16G+lwd+Sb1AxZeOGB8PXlNmXbM5p0mYhFa9A5k7iM0er5jQglQZLqN+NwwyBOqcxGKpeuMxbGRFtrBPFUMngCfsLy+kp2Lxve/BZNLjuZ8XlDSd8mtVy0LkKYOBGVKQyGGB26GOkL7w3MdoY/5PNJx6kW9AYZaTDoptMj1esBzgtqYKif/XcF6cEhmraIt/7XmxtWMCy/19U4OJnMlbsIr51jUPxD42rrELwZy231UvtkEDtQC82+EPfyQTOOG8jBE+jPbzgDVasoNIhgZMEU5AvVnJDwj15JFRycc907iaH7vnhRK+Zu7LPcOC6qsp64dYrR1JppQjjkjQxMaqPg7P4AS8iFd12QVSIKW7E8pFOnOJ6M+anwnO9p/+Qi
 glDWT063
 e1ShMyKaR1BUs7QR6o+lpWnBPRf8G1Ah7K/TfFyf407ZDuUx5KG5u4JHRU+ULYGgDZg1N9BuUSZVgarJHu/dadi1CgfJFDTD93oDaSqGap76uVjEQcKO9LiRIFMc/4aCpoMyBPqK5SKCljQ3EDgu4sSc5hDoSu6H/+3wPA5WZTMJcJh5bhQYLFN2tgKonqMHkyQasXXOaEB9k9yzQ43UCLBp+C1+bl9m/sJYPhyf7SEzDzXpmXthZNKx/D4iAP9n94Fl7ZizkQtXvof6xHT70NqCLwGIc62n5HdtC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 06:12:01PM -0700, Nathan Chancellor wrote:
> Hi Mathieu,
> 
> On Thu, Feb 26, 2026 at 02:38:04PM -0500, Mathieu Desnoyers wrote:
> > I've successfully booted a defconfig s390x next-20260226 kernel in qemu
> > with 1 and 4 CPUs, and within a nested s390x VM on 2 cpus.
> > 
> > I guess I'll really need more info about your specific .config and
> > command line args to help further.

On s390 cpumask_set_cpu(0, mm_cpumask(&init_mm)); in arch_mm_preinit() writes
out-of-bounds into swap_attrs[] overwriting the terminating NULL.

This seems to happen because the return value of get_rss_stat_items_size() is
larger than PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE:

PERCPU_COUNTER_TREE_ITEMS_STATIC_SIZE: 18688
get_rss_stat_items_size(): 21504

Here I stopped looking further into this. I guess you will figure out
immediately what's wrong :)

