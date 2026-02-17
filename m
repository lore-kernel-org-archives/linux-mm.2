Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0519E909D4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DCD66B0088; Tue, 17 Feb 2026 12:20:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486D76B0089; Tue, 17 Feb 2026 12:20:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35F906B008A; Tue, 17 Feb 2026 12:20:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 209256B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:20:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 97AB3B78C6
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:20:20 +0000 (UTC)
X-FDA: 84454612200.21.E74AD0E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 44BC940006
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:20:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UGiuoYtd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771348818; a=rsa-sha256;
	cv=none;
	b=bDx7wG6ApJkXeOZ4NYX7g6AIapLZSBl6GeDgoBQMBuCJ0Gw9K2ghkPJtcaR6/ej3XNusoz
	dNlSj7zdfvKC1qLNlsz2rubea845Cl3cTo6N3bsztHl6OPNczWUhYuspBHV9SwFh+D40Jp
	BruM+z2NRvg1o79qtAkzz7ciU9mx6No=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UGiuoYtd;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf17.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771348818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmGOMae3fX4XdFlpTmh0+LOWdjVWMJ+9sSHJ6/Brpdk=;
	b=nij3K8cgKPdnjVsktuqFc0SmOIZOMC8TcYDf2A3AxWF9jdNRWOeOK2mYQjYWekytq9aL0M
	qH4icMWKxSB8kpz0EE03NdKIGksQeBGMHf2mD1oXW/JctqcgRByKVHEyTEK7kuDfhbv/ln
	q7L32xDpXfTJPmFQrPwswf6UcEyDy6g=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HCO06U3855186;
	Tue, 17 Feb 2026 17:20:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=EmGOMae3fX4XdFlpTmh0+LOWdjVWMJ
	+9sSHJ6/Brpdk=; b=UGiuoYtdmWlRdoRGiihp7EYh1nAKm5pwKwWlfc+ZUNKx95
	kE/Knm1VlD9tSZLeze6ZuofvMy1yGwp/Kokp2qXuCG2BTMDKN0hz5YM/yEO5eV18
	2Rgg00dzbu/5noLaDWPamC0/79Mum4nQGVpET8rD2kU5ismqwZkozUhr2rbLxyD6
	6TugUkU+iBRwSYj3BXYvp5l9hr6iM3ki+q3suUPQXmTUO9QFFrOHYK5E2DYP+r/u
	9Tqq/gZu0BAFoNtG5qYIkD5VOslI5gPv+WSi8UaxBBnSPLW40BuRdidhkVSXjtaa
	eLncdOhFsjVQQXXGCn2gNFnD76upypZpyVg65FtA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcjcge6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 17:20:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61HFq76P015660;
	Tue, 17 Feb 2026 17:20:03 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb453vn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 17:20:03 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61HHK1nZ43188614
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 17:20:01 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 620E32004E;
	Tue, 17 Feb 2026 17:20:01 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E8E3020043;
	Tue, 17 Feb 2026 17:19:56 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.222.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Feb 2026 17:19:56 +0000 (GMT)
Date: Tue, 17 Feb 2026 22:50:17 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Pankaj Raghav <pankaj.raghav@linux.dev>
Cc: linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Andres Freund <andres@anarazel.de>, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
        ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
        Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
        tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZSjUWBkUFeJNEL6@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 2XZd8z_r6WSr7dRH3keYkFv7f7SpVfj9
X-Authority-Analysis: v=2.4 cv=Md9hep/f c=1 sm=1 tr=0 ts=6994a344 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=i0EeH86SAAAA:8 a=a_MmUsLzFZhD-a8PZTIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE0MCBTYWx0ZWRfX54D32x53yALn
 Z6+BkTc5gDISfG0s0bavXrlrm+//B+RiK4PjEppBElALOJ5zOYyJEhnx0Y2zFtDglC4sDQhxkF4
 DX5StOLtI2P5Q0M6Mf/FUEkfPSqwtKQb9uuManDC5le1XMaChc0dSX75VfcpLIDQMK5/WV9zupE
 +RppyrIQz4/iN5OocYHirFn+m3Wy2QjRMPYyStAVb3larOfq5m2MahxMFWvYQcBdTWRLnY0WRgv
 OWWdSaaGEGHpsjL5K2/zIBXbIiWBNwhedB9GJP9F8y6BIr8LCYBBGy8QifvQYqIsaAHVghbKrwe
 RoOC1a8hV4dYHsjX6US1j7lKVB5BOZL1ba5eshAuLRdjVaHmAtjX0sgMUZbKJwtEfY/F7T4jzqT
 AyJjqAXnH8dzin/jcWmaGFgjCxdTtjYel40UZhpJe8Eu0U8gMfQrsl07g/4K45smYfSfY02v28U
 rEDEPAFjwVwnjoI2trw==
X-Proofpoint-GUID: rzuloAN1tKispq0D7D_D5e-h1yv1f5z9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_02,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170140
X-Stat-Signature: mormgzrh758tq3ty6ef1ycgwm6xqrgqw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 44BC940006
X-HE-Tag: 1771348818-976306
X-HE-Meta: U2FsdGVkX19dfIy8h2N7CfTGVxfUxAAM7u1X9wwN94EBVBL8eIrcU0mK2F/yhy5Bkp6H1ijiXuGF75E3TiYgsKWMBdclsLBej8oxlfDWF+LfdocG50AyiwFA+EA8f0kmkjRmVmEpE/DFFeL8R2kZ6zwgo2Nyx0avVk9To6/kur95LYn5DAt5cQYLdJGI3mDt2e5ajIGUdg+lTsDmONIiNthgL9lml2DEVmcPS5q5M/PGe8wbv5GQIBZPQqFKGaAfyEqgEHm84k2UBENQFmu5JF12vFvAWrBM45Aj+c8rOcAT/rfCsNarjaxb0tavPItfT5YuGkiLd/7Db2NNs2ZHNqJT+IDuFx2JBf/uS3+8fYtY75ew7bHEAm+MYr+Dke37iSM0D2o7omtT01OZb+Z3O1jLY6ruDwIwO2k+SRUgnLLagZ4IlIOH6nV6jbRknC5NEXs8zjW032sHLN0xgD8Q2PKlj6PIoD6MRdn3jdXHz+zFlG3o+eQH2V232Vrugh97fb46sN0LFYmwFiwJfYKS8NxPoZA7QzFlhiWubDRHwtu+RpxPhu29i3P+Xyy8ucoewZjJeI5LwjMWLiPtmRj5Y/4nLuLX6WMQnKEDRQjWmK0SYFNGPjobPgjwFfMaLXIVGaoPD1dVk+qOpLxO+5eGX7xgG2YTXxPmni4h1R8foJm9SJEY8Wf9pkNqGNAK1xq5yM0b5i7PwomsM35IUaIR6PYqjRGRtEPdsPUQRvHPtJ8MjWlf77WVGgQ+8TY5phy1QFdXKDydUwDXVZ5ke5yUgNLtpCXX3xvp99OvIRywHgH8FQIZtIiNjIzehoQnF0HB6CFz4l7R/gY8GbdQnBXKzz2rLdExxj85iBcm1xU49TK7iCFZuGKUMz//olL3ocwGfbxgoWjU6GXbflITvduUdHDgs/p/I4gUKUJTO2MWHRY4U7388zM5HZXyJHVIAT1ZgO+A8Ak8XcCunkGj99l
 DWXY4D/g
 vSAoKYsNEjAvrBkhvEdMCxylKMT2sc/SgClYG9C/604wTf+hkc++/D8uaBHnLKmFTvNETxEs39/8h+GLpYsuZoQckk1B5Nx+We5zafFBcdNuvaCbMqYFmBA28wXlfj0nzXa3JLoEEWWBdJRcXa9yWa/KI356/16g69Wonun2zGemTV8uEW7ZPYD+/+sXqcIc2ViKdJmheUhLe7MmtGHu+09EPPv3zowEiPJOusPYajdbQI7jNYSurk3IbCEwIMYoI4p2IS3Kbee7XKBJFtoA6SaTL7Ps3LA8udrk4un0tEDTZmkLR9O6pmDjUR0qIrxarRoF3LL1xEe/klK9LtyIptmWr7ulcM0z96YTm17/A3u1s3uaJg4fRyFd0Iw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:52:35AM +0100, Pankaj Raghav wrote:
> On 2/13/26 14:32, Ojaswin Mujoo wrote:
> > On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> >> Hi all,
> >>
> >> Atomic (untorn) writes for Direct I/O have successfully landed in kernel
> >> for ext4 and XFS[1][2]. However, extending this support to Buffered I/O
> >> remains a contentious topic, with previous discussions often stalling due to
> >> concerns about complexity versus utility.
> >>
> >> I would like to propose a session to discuss the concrete use cases for
> >> buffered atomic writes and if possible, talk about the outstanding
> >> architectural blockers blocking the current RFCs[3][4].
> > 
> > Hi Pankaj,
> > 
> > Thanks for the proposal and glad to hear there is a wider interest in
> > this topic. We have also been actively working on this and I in middle
> > of testing and ironing out bugs in my RFC v2 for buffered atomic
> > writes, which is largely based on Dave's suggestions to maintain atomic
> > write mappings in FS layer (aka XFS COW fork). Infact I was going to
> > propose a discussion on this myself :) 
> > 
> 
> Perfect.
> 
> >>
> >> ## Use Case:
> >>
> >> A recurring objection to buffered atomics is the lack of a convincing use
> >> case, with the argument that databases should simply migrate to direct I/O.
> >> We have been working with PostgreSQL developer Andres Freund, who has
> >> highlighted a specific architectural requirement where buffered I/O remains
> >> preferable in certain scenarios.
> > 
> > Looks like you have some nice insights to cover from postgres side which
> > filesystem community has been asking for. As I've also been working on
> > the kernel implementation side of it, do you think we could do a joint
> > session on this topic?
> >
> As one of the main pushback for this feature has been a valid usecase, the main
> outcome I would like to get out of this session is a community consensus on the use case
> for this feature.
> 
> It looks like you already made quite a bit of progress with the CoW impl, so it
> would be great to if it can be a joint session.

Awesome! 

> 
> 
> >> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
> >> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
> >> Based on the conversation/blockers we had before, the discussion at LSFMM
> >> should focus on the following blocking issues:
> >>
> >> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
> >>   write might span page boundaries. If memory pressure causes a page
> >>   fault or reclaim mid-copy, the write could be torn inside the page
> >>   cache before it even reaches the filesystem.
> >>     - The current RFC uses a "pinning" approach: pinning user pages and
> >>       creating a BVEC to ensure the full copy can proceed atomically.
> >>       This adds complexity to the write path.
> >>     - Discussion: Is this acceptable? Should we consider alternatives,
> >>       such as requiring userspace to mlock the I/O buffers before
> >>       issuing the write to guarantee atomic copy in the page cache?
> > 
> > Right, I chose this approach because we only get to know about the short
> > copy after it has actually happened in copy_folio_from_iter_atomic()
> > and it seemed simpler to just not let the short copy happen. This is
> > inspired from how dio pins the pages for DMA, just that we do it
> > for a shorter time.
> > 
> > It does add slight complexity to the path but I'm not sure if it's complex
> > enough to justify adding a hard requirement of having pages mlock'd.
> > 
> 
> As databases like postgres have a buffer cache that they manage in userspace,
> which is eventually used to do IO, I am wondering if they already do a mlock
> or some other way to guarantee the buffer cache does not get reclaimed. That is
> why I was thinking if we could make it a requirement. Of course, that also requires
> checking if the range is mlocked in the iomap_write_iter path.

Hmm got it,I still feel it might be an overkill for something we
already have a mechanism for and can achieve easily, but I'm open to 
discussion on this :)

> 
> >>
> >> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
> >>   PG_atomic page flag to track dirty pages requiring atomic writeback.
> >>   This faced pushback due to page flags being a scarce resource[7].
> >>   Furthermore, it was argued that atomic model does not fit the buffered
> >>   I/O model because data sitting in the page cache is vulnerable to
> >>   modification before writeback occurs, and writeback does not preserve
> >>   application ordering[8].
> >>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
> >>        where we always allocate new blocks for the atomic write (forced
> >>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
> >>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
> >>        avoiding the CoW overhead while maintaining the architectural
> >>        separation.
> > 
> > Right, this is what I'm doing in the new RFC where we maintain the
> > mappings for atomic write in COW fork. This way we are able to utilize a
> > lot of existing infrastructure, however it does add some complexity to
> > ->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
> > it is a tradeoff since the general consesus was mostly to avoid adding
> > too much complexity to iomap layer.
> > 
> > Another thing that came up is to consider using write through semantics 
> > for buffered atomic writes, where we are able to transition page to
> > writeback state immediately after the write and avoid any other users to
> > modify the data till writeback completes. This might affect performance
> > since we won't be able to batch similar atomic IOs but maybe
> > applications like postgres would not mind this too much. If we go with
> > this approach, we will be able to avoid worrying too much about other
> > users changing atomic data underneath us. 
> > 
> 
> Hmm, IIUC, postgres will write their dirty buffer cache by combining multiple DB
> pages based on `io_combine_limit` (typically 128kb). So immediately writing them
> might be ok as long as we don't remove those pages from the page cache like we do in
> RWF_UNCACHED.

Yep, and Ive not looked at the code path much but I think if we really
care about the user not changing the data b/w write and writeback then
we will probably need to start the writeback while holding the folio
lock, which is currently not done in RWF_UNCACHED.

> 
> 
> > An argument against this however is that it is user's responsibility to
> > not do non atomic IO over an atomic range and this shall be considered a
> > userspace usage error. This is similar to how there are ways users can
> > tear a dio if they perform overlapping writes. [1]. 
> > 
> > That being said, I think these points are worth discussing and it would
> > be helpful to have people from postgres around while discussing these
> > semantics with the FS community members.
> > 
> > As for ordering of writes, I'm not sure if that is something that
> > we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
> > been the task of userspace via fsync() and friends.
> > 
> 
> Agreed.
> 
> > 
> > [1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/
> > 
> >>     - Discussion: While the CoW approach fits XFS and other CoW
> >>       filesystems well, it presents challenges for filesystems like ext4
> >>       which lack CoW capabilities for data. Should this be a filesystem
> >>       specific feature?
> > 
> > I believe your question is if we should have a hard dependency on COW
> > mappings for atomic writes. Currently, COW in atomic write context in
> > XFS, is used for these 2 things:
> > 
> > 1. COW fork holds atomic write ranges.
> > 
> > This is not strictly a COW feature, just that we are repurposing the COW
> > fork to hold our atomic ranges. Basically a way for writeback path to
> > know that atomic write was done here.
> > 
> > COW fork is one way to do this but I believe every FS has a version of
> > in memory extent trees where such ephemeral atomic write mappings can be
> > held. The extent status cache is ext4's version of this, and can be used
> > to manage the atomic write ranges. 
> > 
> > There is an alternate suggestion that came up from discussions with Ted
> > and Darrick that we can instead use a generic side-car structure which
> > holds atomic write ranges. FSes can populate these during atomic writes
> > and query these in their writeback paths. 
> > 
> > This means for any FS operation (think truncate, falloc, mwrite, write
> > ...) we would need to keep this structure in sync, which can become pretty
> > complex pretty fast. I'm yet to implement this so not sure how it would
> > look in practice though.
> > 
> > 2. COW feature as a whole enables software based atomic writes.
> > 
> > This is something that ext4 won't be able to support (right now), just
> > like how we don't support software writes for dio.
> > 
> > I believe Baokun and Yi and working on a feature that can eventually
> > enable COW writes in ext4 [2]. Till we have something like that, we
> > would have to rely on hardware support.
> > 
> > Regardless, I don't think the ability to support or not support
> > software atomic writes largely depends on the filesystem so I'm not
> > sure how we can lift this up to a generic layer anyways.
> > 
> > [2] https://lore.kernel.org/linux-ext4/9666679c-c9f7-435c-8b67-c67c2f0c19ab@huawei.com/
> > 
> 
> Thanks for the explanation. I am also planning to take a shot at the CoW approach. I would
> be more than happy to review and test if you send a RFC in the meantime.

Thanks Pankaj, I'm testing the current RFC internally. I think I'll have
something in coming weeks and we can go over the design and how it looks
etc.

Regards,
ojaswin

> 
> --
> Pankaj
> 

