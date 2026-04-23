Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4A1FDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3916B0095; Thu, 23 Apr 2026 19:54:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB2E6B0098; Thu, 23 Apr 2026 19:54:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E19F6B0099; Thu, 23 Apr 2026 19:54:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D4286B0095
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:54:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C53E7140542
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:21 +0000 (UTC)
X-FDA: 84691477122.23.983ED58
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5251040004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:54:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BqBqBWtJ;
	spf=pass (imf12.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776988459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NyZUs9RcJWsPCXqiAFbbwt3NY3+KB5ydyk2N2aDclQU=;
	b=kBQLHucy1yDLZfMzhDAcUEDZA5O+PVbyhG2i/v5+TIpakuEIbvxrV23tK+3Veq0MJ5qUIN
	niiXXrYewlOmXA+ee+Rqwc+yGsM0DA3ShA7keA639Qxv83Qcc+YdUAyK+0SHRXZBF8Y2VC
	u1APWp88fbgNCfxxaIJaLYX6ZIW7dNA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776988459; a=rsa-sha256;
	cv=none;
	b=NoYHgPB3Rx6CxBBNP200DXAvp43lDh1ickae+jOigFrWn3CML4ooYujWBVPYQ53MDdSFUI
	3sN3EM0VO7B3Jz5n+m0J/mp9V7cZ3Zh2zp/xzlzDFHuMYtBkJJXaHEjwfh1VvGCFOYC1Vg
	17nbnUvqmE4XrQ2oWvcHjPP215tLjwM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BqBqBWtJ;
	spf=pass (imf12.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63NILGAX3229030;
	Thu, 23 Apr 2026 23:54:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=NyZUs9RcJWsPCXqiAFbbwt3NY3+KB5
	ydyk2N2aDclQU=; b=BqBqBWtJ51aKRs1v1ejXoCLyzZgFsyCqN2peRL7cjd/J0c
	rxnuxZgILW8vlzeRiigp1Y9kgbQhmcInD5fWdDx+43KAiXj1KIJzPE4OoEL6U3eO
	b7Qqj9pOacGXuouO/Wy2hrH6I7L0sYdmMPUwr8KXI8KSTAipYBorE0u0NQg4149W
	4x+HL7LGhnBybCjBt4UHM+Zd/cwG7INdnkjPHF9T90c4QzJn0YG/fpfEp5F8HceE
	XDpjly+wE4fqyG4UlPs502Ax72WLIgeVsMpJDaJcJZXQxhsov99lT3X3HmYJfHLp
	e8cMe7s2g1918VKiXuokZjo5G+gmF3EmGWivI/mQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu2b9cm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 23:54:09 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NNoWoH006542;
	Thu, 23 Apr 2026 23:54:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dpjkyrpxx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 23:54:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NNs54142533294
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 23:54:06 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E2F4120043;
	Thu, 23 Apr 2026 23:54:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C0A0220040;
	Thu, 23 Apr 2026 23:53:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.219.54])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 23:53:59 +0000 (GMT)
Date: Fri, 24 Apr 2026 05:23:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
Message-ID: <aeqxFKaw1uOk1GuZ@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4og3axdvzyfpfx4o2rhcnwdsggha2kfoerausxx52vd6jc2hzq@u72iwxrxxble>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: -nl9_K83Kzn9u7skxJWMWCIcGNgHNF2y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDIzMiBTYWx0ZWRfX8PqZYRV+bedE
 hsO8a0m/D+pucfImoyw014nW7oP3jzKYYaf/TJtc3eSY/OQDD2dHyzcMinGRcTvyx4AI/HscdrA
 p6JdEScmepGWWYATYuSuYP5oAtI8JCrZljnfhdEr1SIR+24Ob+ukLdx467L3sCAU5A1avxqqahM
 CIQTvlp8CHdZQz2r+Mpf9151cRifjBS19KhBBZQ8y3kuQelXKdcjebdPlU6+wJrIUZ2b7nPZid3
 ykimUKZl+JP8dwj+rJhitIMXjgDWR9OChwNdNraC9nJn5ssDS463sEyEs9BlBGspEKmLLJdeXQ3
 nNPlZfjYoGhblrIEJozMXrBt11OOVreHNqOPudQkkODpYFeFNwhp2Pf1kDYtZZ9QHzErdUIP7Df
 1tlNGeRk8vpIBTQ7A5tIMmEviO3GjF/QASiwui4MiNMan2zREeDVQSFV8ZhxSXMzQwH5OaU3v37
 kV0SqKEpDdb/zb9x3mw==
X-Authority-Analysis: v=2.4 cv=C8LZDwP+ c=1 sm=1 tr=0 ts=69eab121 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=rsA8cc2tDGwubhWhQn0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: id_LFKqk8OLTXWmlKq-3TLgzfsarewvz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230232
X-Rspamd-Queue-Id: 5251040004
X-Rspamd-Server: rspam07
X-Stat-Signature: bo9min7bboxxack36rjndpdqbjeijcyn
X-Rspam-User: 
X-HE-Tag: 1776988459-20862
X-HE-Meta: U2FsdGVkX187chVUEBd5AFzObH5wNHUN5n1c3hc2NS8mVKSVZN5FKmwjNmosM8lbpazmwsq657RRAvUvE11jvl6ZV/FUZBp4EMr+zSBm9RmESoadx//AdNU1IPt5PMMdM1M78D0EexGIUAR0HxtHp03tYFnJcLqTmpUVvXRBpnLxuoSYXlqFGs0x+Kz+NZRMUijMVxBsPZwuUx7JE2DiQo6afWtty8ew0r4uaMcr+dHDU++ZKNCGqAzT5tL40SS/rj9UPkMWSTmveg8+NyYbefpNHGmiC+ug2A1C+AlwXfITj/K/KBQ7SvE3vx8m1AEnLAU2MnUABa3fbwBQJPKf1PjGbxVKyqKddjLyllrQ6d39Wdweb5BvQ+/Jim/7bg+PIgzEi99PL3oAHLYpQMmjs0buBf9Huv6YK5vhtbhuTbPwN+VQdK+u1rPtf114TT8VLcd0KbVZt0VkN5rYZabsEPq8iW8uZm0zgMrc0/6omOGuzjcWp0jAgetdF6k30U1wd51umgAs/03aT307NZngEkTxdkxpZTqHrSQXhNd+OgZvwAHdRSq2qj9WDweDIn24Ms9+s7RGx5U4VEUjy5NXbIkmwsawyNOxjuzt4YnVI4IiZDfBAhYe+zblWqAO2YIySiM6KF9KbDWNdYOLxkmD7R4E8Lok4SzSWqqo5WuOH5n5begSYK4wOhoXBSac3CjoU+rlcDkxDlQyTKuN8tktsZfjzAcgCOzfu0KUcwzAcHSjqsot0H9GC20beuA33AheoFzTK8aIkzHVWO0HOdzjc2RHCgYNfy7WqolguXXs21lBsixP/J6/xTa+oH2OpOUExRoko+tWNRmTglDxpwkUviKOeTVz9yoDiNxY5aiC49WYkaA8PXbngYdd/LDL9vJilARMYJiyFqvpKe5yBW5gUvnnZ7nQOz1nShbIx8Gc1YsjiSAOEmNu5Zbt8C0mHKgttuQfEuXWlQZWYVw5yc6
 YOZDNymQ
 Ar2IyWulf2878CgdOsW2ukJROatPd9NPA+sFwpsEnX6Wvb0NH36WuT1tS2Gagn3Iw/GF/9awWtTfmR4Re5Yk7YRfB4isiWN9PhHFKl5Dz3vZ2rPDRxj5zmdIGeWHxBQDlWD1SwzloRugjwHRuBrA32QflqY3rYapBdPE2LmCsJmaKQgHoYe5TVb49DUezIHwTSpc4bkLdFUpR4PpHaPB+adlQ2BhOudzAPlGKcftPiDHP17ZLL8y3p7520aUHGqiuUzX2v5oWo15SRGeK0l/MQpHsmAd+qRBRH6vK97EBSezFkVxB8snjQY1HEidhPuzSYzjD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 02:25:43PM +0200, Pankaj Raghav (Samsung) wrote:
> > 
> > 
> > * Testing Notes (UPDATED) *
> > 
> > - I've added support for RWF_WRITETHROUGH to fsx and fsstress in
> >   xfstests and these patches survive fsx with integrity verification as
> >   well as fsstress parallel stressing.
> > - -g quick with blocks size == page size and blocksize < pagesize shows
> >   no new regressions.
> 
> I am hitting a very strange error in generic/127. I deconstructed it in
> to two commands that can reproduce the issue:
> 
> ```
> $ dd if=/dev/zero of=/media/test/fsx_lite_nommap bs=262144 count=1
> 
> $ /root/home/xfstests/ltp/fsx -l 262144 -o 65536 -S 191110531 -N 100000 -L -R -W /media/test/fsx_lite_nommap
> mapped writes DISABLED
> Seed set to 191110531
> main: filesystem does not support exchange range, disabling!
> main: atomic writes need O_DIRECT (-Z), disabling!
> short read: 0x0 bytes instead of 0x6c7f
> LOG DUMP (1 total operations):
> 1(  1 mod 256): READ     0x39381 thru 0x3ffff   (0x6c7f bytes)
> Log of operations saved to "/media/test/fsx_lite_nommap.fsxops"; replay with --replay-ops
> fsx: save_buffer: .fsxgood file too short... will save 0x0 bytes instead of 0x40000
> : Operation not supported
> Correct content saved for comparison
> (maybe hexdump "/media/test/fsx_lite_nommap" vs "/media/test/fsx_lite_nommap.fsxgood")
> ```
> 
> This is on a bs == ps (4k block size) xfs filesystem.
> ```
> $ xfs_info /media/test/
> meta-data=/dev/nvme1n1           isize=512    agcount=4, agsize=2097152 blks
>          =                       sectsz=4096  attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=8388608, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=16384, version=2
>          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> ```
> 
> The same test passes if I pass `-G` to fsx parameters(disabling writethrough).
> 
> The error is coming when we do a read operation which feels very
> strange. Could you run this in your setup and see if you can reproduce
> them? I still do not know where the issue is coming from or it is
> because of my test setup.

Hey Pankaj, I think the xfstests branch I shared might have been missing
one small fix that can cause this issue. I've update the branch with the
fix, can you give it a try:

https://github.com/OjaswinM/xfstests/tree/iomap-buf-writethrough2

Regards,
Ojaswin

> 
> --
> Pankaj

