Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC6EAE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 07:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF83F6B0088; Wed, 18 Feb 2026 02:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA61C6B0089; Wed, 18 Feb 2026 02:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B878A6B008A; Wed, 18 Feb 2026 02:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A2D746B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:10:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31DB58BA99
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:10:44 +0000 (UTC)
X-FDA: 84456704808.12.95C170A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC834C0009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:10:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="tSqb9du/";
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771398641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wukgO5j/8aNavjZq33Drvjb9PS5A9guZ5fwgIH2CROE=;
	b=kqOzGQiFQnKNif9ALq9lluZdNknKFQudsmJGCgR81Jqxk6vCvBbYIBTJeFrEOAhjmhN6XG
	XbQvjyrIIiN95lUUgkchDKazuYpOngBdE7cFrV61KXI+Iq/kBO81+faQEZUcgm53daHkc2
	InJGdNjv+ugmLjztQ6NP1o7JpFZes1w=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="tSqb9du/";
	spf=pass (imf28.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771398641; a=rsa-sha256;
	cv=none;
	b=nR++L+FCf9MH4cSH8FX0oiAg/YizFz4QxqPxYv1dBSQSXEHtGxBAUOPkduxd3IR/CLeu+H
	MvF6PGCPdgZQ/jE0dTSKeQ/7J//k1j7qtkgvttog/tSxZnKX9y2+r2WsP550ZkO6cLSCD0
	Rl9lz10hH3AXvg6bVoyTCdlfTQUTvcI=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HHJtU63183117;
	Wed, 18 Feb 2026 07:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=wukgO5
	j/8aNavjZq33Drvjb9PS5A9guZ5fwgIH2CROE=; b=tSqb9du/lZex2lVtiYWD4f
	4+NKT9c72HZeLfQEX58ryWHQ3hvgyuWLaSUMpdHZtt2JntnhH2u+IZ/QC/icgL+A
	Tg5dA6p3JDM5tB3B29LFqlyYWbWWoO5OCxWTnmWovrTDnZG77upkcWMHISKqegoL
	vxjPiSH4wle69PTZzRLhc5XhZObUv7+hv1JJi9u9Bw5lqOjBxArce1guC7Wq2+Ge
	SyMBmoO0/8UabAQS290vPdEpNVy+KD32N+npTFPYEhfN8HvdwzA/BK06bVBOLfAn
	ccNndGaf2xlrUDjvj7wHsT9fnZR4Ma6Ec3ONIukB68qW8WRZIjxzXmf0/EQQRCyw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6ur280-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 07:10:22 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61I34Ffg011961;
	Wed, 18 Feb 2026 07:10:21 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb26xvbw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Feb 2026 07:10:20 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61I7AGkO10879402
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Feb 2026 07:10:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C72FC2004D;
	Wed, 18 Feb 2026 07:10:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19AE12004E;
	Wed, 18 Feb 2026 07:10:15 +0000 (GMT)
Received: from osiris (unknown [9.111.88.61])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 18 Feb 2026 07:10:15 +0000 (GMT)
Date: Wed, 18 Feb 2026 08:10:13 +0100
From: Heiko Carstens <hca@linux.ibm.com>
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
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260218071013.12861A0b-hca@linux.ibm.com>
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-4-surenb@google.com>
 <20260217191530.13857Aae-hca@linux.ibm.com>
 <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpGxsX6kZAzZJZo7aGNxEbeqOhTV8epF+sHXyqUFOP1few@mail.gmail.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=699565de cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=gGe32zGur58IqnNnNnwA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE4MDA2MSBTYWx0ZWRfX1GbVKY+hQw/0
 xMtVyPtOGHwPd3EvY3nh6LAsZThMFJsu5ApLK0jWevZKbg8TbjdxYIQecUxKtVhACccLtW3/zOX
 oXfxEgPkBvBgxXpdYd4IiGZO6F6kxXCTlXhpq8QxhGoMU/i+eNxWKBdnJrgxUW13IMkTmMUU8Jy
 PE2PznWt7Z0CFRkIA9b4M1T2JSLNkyHoRD36p5g21pqtvSoDnC3ZF4OV3qSIUEkMDjr5OU6QQU8
 kbq35WpgDeMM3zXcuij2KgAt/FMKzfQkWjGWjXhhHaH45znBtDSdRxTPUnj4IoF9PL4C0U7v9vn
 qoBxoxHMJrgrOptI0h/YGNJTGe/dEAWaHLCAURLaZvUSSY/hXZgobo9hhruCwnnI+2L3b4+mOSV
 yyhCj4oZT+xipsWn8sM1Ji+oTx+mUeiXxi/G6CAeTdIuoBs0LXQgfIUFLqHLFZgKFP9rmV4Z5dA
 QQp6GdcAZOyxDFd0iAA==
X-Proofpoint-ORIG-GUID: PrNeiywUXSPNpfowIMohoR-adwD3XkAW
X-Proofpoint-GUID: 7NyzMkwUS6QnxMs17XYqyWDlVFmp7jpO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_04,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602180061
X-Stat-Signature: f8kc6adwsohabku4z75dha4q4subh4sj
X-Rspam-User: 
X-Rspamd-Queue-Id: AC834C0009
X-Rspamd-Server: rspam01
X-HE-Tag: 1771398641-126144
X-HE-Meta: U2FsdGVkX1+H0xQbeYwIjYmL7yrF0K7ZgfL/I9odLfamxIASbJKcXnWPm0b4t5xJJhUzaedVSFgxvMngoiBk5qPmdGHKuIRPwiV+Dya9d6UnQHjRljMvFIK8ljLvhSJuCosJcvKEdnDvNYjnNs6c6n4qOpgS0oIXVGc7mQ+S2t9VPaqqBxfm7DUeCTH6/hhewPImbdmBU89AHZaQoiYStUTZB7tm5U02HkoM+e30OLCPuC6OKLlrsOGkTmMjRhXDvmesvfV3GOHAbY1T9noT283xF9UHgXKkpFGMzdPZmXvA6fzXx07nM7hHvrdKnw9AKh3SwltwNFw/te+z5ULxECWEyuUCRrBCkB5jif4sqUwk8j1obfHIJFsKdWIiwzQbd9QSqdUSyHbWJsuWFJ//7SUXbIL+cHdffZUQ3kN9T2s8n+ZZv+gm1auMT+/IWTBL0GVX8B428hBVy3St03LAdtcFhhKV36pHDuUhqS0fzgHm5C2Rb8ggscDWBVhE97u7ItyNcNxioDi3MVgTOQWA8VqxnX1JjLDNO/gCWUsLkC/YdhEQWo2AzqtVU8buO8YqBDyLnBtCwRIv0TNec0fTK5f5Npje7mVuVbmebjVR+lE7YoKej9IvZNIxGC1+KqlDaDwbUfACQ6aEBvdFlwmuYA0xO++EWV+z4TgcEcDU1BFKs9+PYlu/OIH2/pEADPcrM8k2GaI69EdoIyilgjWEatWWkk/6RURIAVYZa5/n0Tjm/z9GbhicT5LFrAh9bI41SzC3HDxclOvUcM08g7xOVY5fmLYpD620mbwslafrvwWJZ7XV8wnKTq9V3YGR2R2ZOjklt9LrnfN1Do4+cel8nv9WkNKxqrWZbMHphz8FAH94FsPhiyB0vQvzd7DL4k0OfvFfO7YFhGId1ylgbU0AeOd6RYTZmviTRV9g0p1pi/zjRkD9MuQp16KeKPkt/w9ut+tQKrd3HLwEl4FBqpd
 IW2VQNYs
 Vq6ZSisv1YBxl9KUT7RKurRFqncMNnmAUEkDc/ye+U50JgeedYcmhbURX0EsaBUZ/vmcJ+MnKsJFxTC89C8Vydu0R4i3Ze5WOJ4rZthf7BI3/JivkZ4WGrgWSFSySRaqWTAz5U3n1WvsPdY2hnUOiAG/g+xJk1alk97YY+rHoOFfnxyeNiGH8ZkQTljVuF2/sdUdWftJ5aW/UU0Q521WePqglqUY+0GrVJffnGzjOBm69S0gbuVWpEyfiP74aRAaj6a8K6+6hGJ2xvXWglFSHQaaFu2uxmIx7hqtDNZmHPzpfB2iQXAI6XhlS0K2wE0yaD2K9tS8v1Wn9FYpbJqlABdpwl4SUP7tAaWhVpUszPECMklsAtpX0/DAd7FbnwMeonOBwHhA0HOVEVYkuAU+Bt7OVh2NDUVcq3dKeqGU5e5brT84MpjJIpKtz8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 12:31:32PM -0800, Suren Baghdasaryan wrote:
> On Tue, Feb 17, 2026 at 11:15 AM Heiko Carstens <hca@linux.ibm.com> wrote:
> >
> > On Tue, Feb 17, 2026 at 08:32:50AM -0800, Suren Baghdasaryan wrote:
> > > Replace vma_start_write() with vma_start_write_killable() when
> > > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > > Adjust its direct and indirect users to check for a possible error
> > > and handle it.
> > >
> > > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > > ---
> > >  arch/s390/kvm/kvm-s390.c |  5 +++--
> > >  arch/s390/mm/gmap.c      | 13 ++++++++++---
> > >  fs/proc/task_mmu.c       |  7 ++++++-
> > >  mm/pagewalk.c            | 20 ++++++++++++++------
> > >  4 files changed, 33 insertions(+), 12 deletions(-)
> >
> > The s390 code modified with this patch does not exist upstream
> > anymore. It has been replaced with Claudio's huge gmap rewrite.
> 
> Hmm. My patchset is based on mm-new. I guess the code was modified in
> some other tree. Could you please provide a link to that patchset so I
> can track it? I'll probably remove this patch from my set until that
> one is merged.

This is the corresponding merge commit in Linus' tree:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=b1195183ed42f1522fae3fe44ebee3af437aa000

