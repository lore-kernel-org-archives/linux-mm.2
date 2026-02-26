Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD61FC5915
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 12:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92E076B00A3; Thu, 26 Feb 2026 07:05:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7F46B00A5; Thu, 26 Feb 2026 07:05:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1116B00A7; Thu, 26 Feb 2026 07:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 664B26B00A3
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:05:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 150BC8CDE2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:05:00 +0000 (UTC)
X-FDA: 84486476760.08.6B871C3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf18.hostedemail.com (Postfix) with ESMTP id A53681C0019
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:04:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jLHmlcS9;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772107497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANcZNjIxQSI14Z7YPaEcHfoSZWvSU/YHaFbMJhg7PNQ=;
	b=P35FobyLJgDxzbNDqFvq2sny01Piayt+iRfYMvlVCNmw1I8cR88lWVZaVJJCpvmnpctwjM
	VK8FM/L6c5hBOGNCEqCyKij8wEy1T2XAnXqm+vsMVysBnUZQjtxdx4LbVw0nCBOppUxGM0
	Qplul/roZEsDZ4OsIZj1aHgohqAN/uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772107497; a=rsa-sha256;
	cv=none;
	b=it7r0G5AbUrhoCgaiXZGxB64/mj0Paqxngu6TCMBaoLcQEzufGsHo4IcSov+cq523rru2X
	42b8W8aCgCjUgSnmM2bHWw9LnDMJYrlFrsVC3aEbSjCDTKiW30aqr74SedZiwY8UCRrmQ7
	Du22F4Q1AJ383sWJMl5aw7AxkhfNQXc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jLHmlcS9;
	spf=pass (imf18.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q7dVOV1887407;
	Thu, 26 Feb 2026 12:04:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=ANcZNjIxQSI14Z7YPaEcHfoSZWvSU/
	YHaFbMJhg7PNQ=; b=jLHmlcS94bfiJNIjThTQYWAfZI8pysuAPgHyjDQn29/kxU
	Yc4qEuOF7oHEezSZLiApUGKKC02/hzl1Ml3+Mgt9MfHsLXPhEkOp7ija10bqoivW
	AYOxzw4uxI2uL7z67ln2IqOylxwdjEjrnE7LzetIx5Tdj3z7w3ICLSfQabjkwHye
	4nU/dHjTT8OihpwvQrhEtMneNEiZ+BNLjGgwDF8bbU5AlQSpb5dFH+S+tGhJWxEd
	09C7D7ETFzkUPu+ulcxdPM6IPkbHKnKQJvvMryt5zHDElweOqa6pnv6x+SY/Zcdq
	WZ5zQ6xEZciUqpzHIZhff0Z8uzURLdEIZf8ZeKUw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24gngyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:04:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q9mwCi013406;
	Thu, 26 Feb 2026 12:04:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdyb7y5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 12:04:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QC4OrB52101570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 12:04:24 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C3E8420049;
	Thu, 26 Feb 2026 12:04:24 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 58AF220040;
	Thu, 26 Feb 2026 12:04:24 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Feb 2026 12:04:24 +0000 (GMT)
Date: Thu, 26 Feb 2026 13:04:22 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@kernel.org>,
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
Message-ID: <20260226120422.8101Cc2-hca@linux.ibm.com>
References: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=69a036ce cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=7d_E57ReAAAA:8 a=Z4Rwk6OoAAAA:8 a=Z2se5BRXh4BkGdnmWtwA:9 a=CjuIK1q_8ugA:10
 a=jhqOcbufqs7Y1TYCrUUU:22 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-GUID: tD1VGSP6HieBCF5wEAHv0bKZIDdXK7aS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDEwNSBTYWx0ZWRfXxnBFMIMGvx93
 NdpWAzHcd9kNIM7tpzuPDi3BSVm5oNJyX6k7U0zZdM32iWRNeKiIIDNyDwhW1ie1R6T7aYFi1O/
 4fTTnuaMtg+xKW1e1SAZWgaAArbF6sYmYRLl0D+MSZtAg1edED7r4cnXS7CPaeMF9mzXf9faZ1z
 qpQdHAJooVMDsMDGOkFzgtGitkCuFBpyeTRc6t74i/nwBL9/4KpF6bQ7on4XWzxPvWRijLBIcOv
 ujVTdWIdcqGk/3fdev5KpkuWBOoop05s2VqEGRalxYfMIHqrcIup+G8zDyxRelcgxsGbr8FC8Cj
 X9bx/fneQd6kt42vykx7myCLplIrWu/25T3vAdeEcbCbhHiXItBLsdtoAwUQ0/+Im47jQZbTkhT
 wN+y90PoLt8pSiXfN5aITpdmy7OKN6jXjHJTn2mvgLfS6k6L2dfKdg7fXZsMgJL27bQk0EH3CkN
 9JG/g+VOAbbevvP5dag==
X-Proofpoint-ORIG-GUID: 8HrdOn9qyY5RT1ScPmZUbcFIKf-LaGiO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1011 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260105
X-Rspam-User: 
X-Stat-Signature: d89x43bg3m3ry6sry6y8575se68oroun
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A53681C0019
X-HE-Tag: 1772107497-9817
X-HE-Meta: U2FsdGVkX1/sgj+mA0rlyUyDVz290Q8mVUXVGubZHz8Hc0kPwGyonPSxmH6pK07dBYHgpSpKUTI28bfDBCWQqsPQu4FNCX+1LqdGK8SmbfUT5zu3GTS8DyQBJWLVqlAftBjUkGY7sBEBf9xxtYkeNvB6EumII+XazdgdfahWVC2DCjSCdpa+G6OWXNxjcT/2Sc1agyRYfXaicmreB4lHNox8fhStdx8z9BYaUsKvV1lZP9IRFxa9XkqQ2/gM4ugEyarSJvp6ra5AgHZB/d9XIw+RS9LuhF90clFimJ0AA60P913VgJm+5kFpdaQKKzvLhfZ9/fYuFSSRM4jk5vY+2XHvVETciXx9IlIPEfcr7fdeaZ/IgU5FdtHvuBviJNatyW2S98WcBLQEZqUpYfFBAWImlHuDEnfrSYDMaxAejFjVyfRP3BixB/YFZfjcPCju+StNuDS1V18eaM/KeR/v0Su9Hg8WY7NV8r0nG4+gjsT1tmtJrKX4tyOVzbvYXP1ZsuAS3ZW2vlhkeO78QS6UHN0k01C0lz24uxvxK5dxMmqZIx4MDxILe74m3m3CwTuxKbO4/U0lHuDcUUfFTOIgxq6M8GJzoQG/WKO8DtFFEYtwKOF8xjy+clteGmTNo58OTnPvi+PlJYw0HG2otETaybiMTgrrFpwOHSEnXtFFQyLR0u5+eSF7Py+drDcD/ECHeyd0oAZnTHGQCvX4IvjtAJAEcubtVR8bteJurWD6ZwhwULnEGRDNbnHyaxW9agPozvPcxciCb8CAKGruuxHQN8snY6W6iAC8Ho0GAnjeMJPUJPpbRreg6CGE349aokJWem6j52XuoTr0I8er40+SWUnX/5SbpZPWOcn0F4mBTtzDIBv3pHyt4nGgSw82MT0LRTuwGG5RrS9CREs1lktcinCOuu5H4OMknDDyQ4/D2rT+sHQ6hIu6NJ7kO0LJbCDgKBFZA0OZunL5DJquvXV
 KteGTuYa
 n+6Su9gM+4kMlDsdIEWT8aRdqdeGLuwBfO0o5LzhEpQSLPWJ/jl6+c/sjg6FAqE+b0g3K2sXH1B/oL50WCsP+UVmodhMKoXHVdcgEJrVoxSvdSFYJtK6WYcgV4Mafb7xT5FS8DYQyyu+t/28CvKxbWOu6BbDnit+cjdxTZcn1/ScvZSzNUJA6sK6JFYPqFj4YPE7sRSV5/+r0m9cGI152iGgVrGffundBHPpBwaJyhHH0aQKE9+hKwGLyYxDAjtbYLxWpjq0Kul+kNKV5kdtq7KfWmYmmGYlYK91BGZcUV5oq7me+FcaM8W9mXuMt0zcoyN1InSXyVvi1FsvVkVix5djWwTRTTIdDIaopnGQnHdKKMJHNQM10kyUopVpGymcRyUQCoNmoa23h6PYerC+BRzKgdVNob7y+QbSWvMhNNt8MAAbCyeMTxHACOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 11:10:03AM -0500, Mathieu Desnoyers wrote:
> This series introduces the hierarchical tree counter (hpcc) to increase
> accuracy of approximated RSS counters exposed through proc interfaces.
> 
> With a test program hopping across CPUs doing frequent mmap/munmap
> operations, the upstream implementation approximation reaches a 1GB
> delta from the precise value after a few minutes, compared to a 80MB
> delta with the hierarchical counter. The hierarchical counter provides a
> guaranteed maximum approximation inaccuracy of 192MB on that hardware
> topology.
> 
> This series is based on
> commit 0f2acd3148e0 Merge tag 'm68knommu-for-v7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu
> 
> The main changes since v16:
> - Dropped OOM killer 2-pass task selection algorithm.
> - Introduce Kunit tests.
> - Only perform atomic increments of intermediate tree nodes when
>   bits which are significant for carry propagation are being changed.

This seems to cause crashes with linux-next on s390, at least I could bisect
it to the last patch of this series. Reverting the last one, makes the crashes
go away:

0acac6604c1cfd7a1762901f0a4abe87cf3a8619 is the first bad commit
commit 0acac6604c1cfd7a1762901f0a4abe87cf3a8619 (HEAD)
Author:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
AuthorDate: Tue Feb 17 11:10:06 2026 -0500
Commit:     Andrew Morton <akpm@linux-foundation.org>
CommitDate: Tue Feb 24 11:15:15 2026 -0800

    mm: improve RSS counter approximation accuracy for proc interfaces

Unable to handle kernel pointer dereference in virtual kernel address space
Failing address: 766d615f72615000 TEID: 766d615f72615803 ESOP-2 FSI
Fault in home space mode while using kernel ASCE.
AS:000000025dc04007 R3:0000000000000024
Oops: 0038 ilc:2 [#1]SMP
Modules linked in:
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 7.0.0-20260224.rc1.git266.3ef088b0c577.300.fc43.s390x+next #1 PREEMPTLAZY
Hardware name: IBM 3931 A01 703 (z/VM 7.4.0)
Krnl PSW : 0704c00180000000 00000216ef164cde (kernfs_name_hash+0x1e/0xb0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 RI:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000000 766d615f72615f65 0000000000000000
           766d615f72615f65 0000000000000000 0000000000000000 0000000000000000
           766d615f72615f65 0000000081212440 0000000000000000 0000000000000000
           0000000080a00000 00000216efcb5390 00000216ef16530c 00000196eeb07ae0
Krnl Code: 00000216ef164cd2: a7190000            lghi    %r1,0
           00000216ef164cd6: b9040042            lgr     %r4,%r2
          *00000216ef164cda: a7090000            lghi    %r0,0
          >00000216ef164cde: b25e0014            srst    %r1,%r4
           00000216ef164ce2: a714fffe            brc     1,00000216ef164cde
           00000216ef164ce6: b9e92051            sgrk    %r5,%r1,%r2
           00000216ef164cea: ec1200208076        crj     %r1,%r2,8,00000216ef164d2a
           00000216ef164cf0: b9160005            llgfr   %r0,%r5
Call Trace:
 [<00000216ef164cde>] kernfs_name_hash+0x1e/0xb0
 [<00000216ef167d32>] kernfs_remove_by_name_ns+0x72/0x120
 [<00000216ef16bbfa>] remove_files+0x4a/0x90
 [<00000216ef16bf96>] create_files+0x276/0x2b0
 [<00000216ef16c15a>] internal_create_group+0x18a/0x320
 [<00000216f09b61c6>] swap_init+0x5e/0xa0
 [<00000216eec7fb00>] do_one_initcall+0x40/0x270
 [<00000216f0990a40>] kernel_init_freeable+0x2b0/0x330
 [<00000216efb5160e>] kernel_init+0x2e/0x180
 [<00000216eec81ffc>] __ret_from_fork+0x3c/0x240
 [<00000216efb5e052>] ret_from_fork+0xa/0x30
Last Breaking-Event-Address:
 [<00000216ef165306>] kernfs_find_ns+0x76/0x140
Kernel panic - not syncing: Fatal exception: panic_on_oops

