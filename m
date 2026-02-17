Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D66CE9A035
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 18:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AA196B0088; Tue, 17 Feb 2026 13:33:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DE76B0089; Tue, 17 Feb 2026 13:33:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F066B008A; Tue, 17 Feb 2026 13:33:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5F66B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:33:42 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9F4BC5824A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:33:41 +0000 (UTC)
X-FDA: 84454797042.01.9CF29AD
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3E38C140003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 18:33:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BaOnuw0E;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771353219; a=rsa-sha256;
	cv=none;
	b=SLwln3m3A+8j8yeM6wpJsphyF1R0s8QgejTu0Z46YB/ErhFufZOL3DgGoBL8glLpdQPooh
	pSySzu++SiWFGdAWJf0psJ5T4sw2n1gR/NLRHhU+FCKYkwKPDGPmN/MPoJgZVF+lGdUTW3
	6TV1tVIEY0zO8/j3dyE2EFQhm3mcAh0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BaOnuw0E;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771353219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVyY2pafPAeJ/3cdMMOZOfU3VjY/5y+FoFxh4lAINEc=;
	b=qZH8a04CrrG9qUif1WpN3SoxBRlPKHz72H4oA2WovDaj8H8CPZduBheiUIUNP2+cc2HhiW
	Cr7TH0Gt6yTpYcaYvk7BiBioIouML254s2jPFyjHE+bZpYISPdtS6LMdYjLgloh0Ekx1rO
	Cs6V3qZduijn6ELJ69blY73JwN6iJwA=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HFHDxO1907189;
	Tue, 17 Feb 2026 18:33:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=IVyY2pafPAeJ/3cdMMOZOfU3VjY/5y
	+FoFxh4lAINEc=; b=BaOnuw0EEXbA6vc6cNHGqk1+R2dwaurntBo2WxF8NO5g6x
	yhOeLZyELoT2HE+K2XHpz5y5gF3ReQqx/gaQqJccNiXhaddzdLY50uQcz08nGM1U
	7/gD5ftPBgbXOhLPYk1kNLEtJkcNn2dJTRX7430X1+cqKGCv/mLlO3NgJLLInmm2
	mxL4nzyoKsOS4Yub7SKaoHR+82xOeJZN5dNPnMuwLMWmyik3T+oncj5ofrDBPLuG
	5WZoj7Y4ckvtw4RjTG1vVaa0SjvIJ6Cn2APZ91Z4byiFnx6ej0At/nGW3WjxAzi3
	HiYb3pY6NgloaA7xJ3p8VIzgqGuZjScLsmcvwn7A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj4kcr7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:33:29 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61HFffqE012024;
	Tue, 17 Feb 2026 18:33:29 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb26v60n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 18:33:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61HIXQsv49086832
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 18:33:27 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F02B520043;
	Tue, 17 Feb 2026 18:33:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8458720040;
	Tue, 17 Feb 2026 18:33:21 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.222.71])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Feb 2026 18:33:21 +0000 (GMT)
Date: Wed, 18 Feb 2026 00:03:18 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Andres Freund <andres@anarazel.de>
Cc: Pankaj Raghav <pankaj.raghav@linux.dev>, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        lsf-pc@lists.linux-foundation.org, djwong@kernel.org,
        john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
        ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dchinner@redhat.com,
        Javier Gonzalez <javier.gonz@samsung.com>, gost.dev@samsung.com,
        tytso@mit.edu, p.raghav@samsung.com, vi.shah@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC] Buffered atomic writes
Message-ID: <aZS0biD6YKKEMSel@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <d0c4d95b-8064-4a7e-996d-7ad40eb4976b@linux.dev>
 <aY8n97G_hXzA5MMn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <7cf3f249-453d-423a-91d1-dfb45c474b78@linux.dev>
 <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <zzvybbfy6bcxnkt4cfzruhdyy6jsvnuvtjkebdeqwkm6nfpgij@dlps7ucza22s>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE0OCBTYWx0ZWRfX2rdptgqtYMs8
 F+5hs0q3AJgCSXWOn/io2S7+LyVSvEUkprIxF3r0WvuB6MXCFTdkQSVTVnijwKCL3gIaHS+4aQK
 9R8oMH5/Zdi4u73uYSXq6sfNdmfH1NI1wv50/T9ETYRMJ2Thr31lody62rB+BjGsWsg/pEePCFd
 TK1CZSTUXxG2G0btj+Ocss2M6K7RodaC4PY2eQS1vrivR0PXH40vJEvAWn26/hDOBIPLW+yfGIA
 iioAbpqCTyl9TeHUglQFBeiZ8Aq63+XAt2yoszKlSpKymWKy2X7GOdqYgf77upivQSK7iWyV9FK
 MyvHmyj9dvgLQsZ19Yvum+G3Z7T1PwO2XUjDQ1Iw1OmtHH457NPT8r0pP3hcW5sAH3MVxSt+V26
 4tab24ixZtPUz0/rz3wl5tO5Emt1oMcIuSMnz2xGArDRFWemoUAGkwxSuw44HMLJHN5QN43Kbqw
 NfMctKzsGnYr+q4lNEQ==
X-Proofpoint-ORIG-GUID: L8sVc87YA1mFTXVl3y3VQeqlnSOtigRu
X-Proofpoint-GUID: HWQGutjQOx2X8ofTyO-Lw0eQYzK-9clZ
X-Authority-Analysis: v=2.4 cv=M7hA6iws c=1 sm=1 tr=0 ts=6994b47a cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=4oGJD3Fq_HDPk2gAZpMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_03,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170148
X-Stat-Signature: t7139y8uo8nkf8nsmefbprfxjn31kpcp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E38C140003
X-HE-Tag: 1771353219-325141
X-HE-Meta: U2FsdGVkX1+ht0PIVEa8dXiX0ul77lcCOR3Tb/cUK4gvTw0Si4LnhzT786/t62w+rEGm2Nia3fUxiM/W18infoeo9vJJrVe7BzLzVHq5DcqcsNyaUjhXB9aB3/ImxvHCSK7BKtpQQZd2SZBNHfAsV2oLkNR2TJKbYeS2KSfoPIq87QTHotS/i6AItK4l+cCZMlcMWz+bTsmJwQr7I2yTBk3NnY5cU8Nyxm4hbqzZfAEnik6ztr180q/+COT0VxqFQOP+zQQNQEIY0+c1JXIDOgnI5ULDKfCZRmOrUfLFEsbuYWHZlf70WGQevtNL0sRfT/mxW4jwCnlF9FIe5PVw1Cv1QepBYonytaoJEC5S333QxxCLTC9EOnkp0SxW5wiUpnnItqzNOqk5ElzPz6XdhmSO0dWJFI/Ufl/g7AjgP7H5vSO218lb4HRUrD2ld6CSEXTn3TA3Pu4IQYwB5bLeANcuEEywKc22XioM9hvemPF7Rratfz+S4eJG5Gyghl5D5IsM769T682bg5rfU5QpD6TikKAkTlya5o+5OJ0NYWZBVfBbbZFo9oy8vKnZ9XEn0KUz8LDZeOemCELMJ9jj1LjvozGkd1Asc+2H3Dzojk76MUHZJiPj8/dqABllBdmlBjd73X1bVefZplkdO/Y+fdaZFrcqxyJmeYMWWj3nGPsffog+IGOU4+BvopnBsEGL1KgrNxD8jYJax497p15VqvUWi23KDikO4lV8VgW0wZssBV+rFFN5uraZbVZpLF4tUs+kndTv2B1mgrO/ZXSVBMJ9oJjvX/qLAZbFobJh7vg3Ea5tHQn7erArg5TrdFs/Z0DITyC6goGg0TwxqR1cFKEEUWJqdmya3uP4qWmbQIZxTOKe0JUnr3aqaojEdHvoid+Q9syuZil90zDOiFsv3zQO/GnN42/C/4fmm76nCoRD0kshKBokeKrLlr4CjCgn6pPK8RFbKAGJ5f3sw/c
 g1C8bYo4
 tW9OKIxD44DB3KrE7aVfWook0O8yoFo5YwD66S7Cv4mG4W3h5Nivse2Yr1YVUtA0t7fN4SnSCS/qtnTcR2gqL/RaCIfQUCGqNBt+A43RYbtHKgSzZ3KRMoPG89dTySytisOImxESWeGYJFysLiMv2/TY1x5CAYbFyrnwCDZPfr5wjj2LYWlSRLJ3tWHEizHRYuhwb2//QbCbRGttChNzik9xd/JIshblN0E+00hhxJNZBq2q1+DVn0cmktJAMlNsmOPc7V0S/zSXGZLoSRXyB4Er7P4O4hn+TvEkkekKE5uxXylriFhB/CCzrOliKftYW+oiYUWnjGwBLSWSsXtdSxAWT2+u4RmH+73IG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 10:45:40AM -0500, Andres Freund wrote:
> Hi,
> 
> On 2026-02-16 10:52:35 +0100, Pankaj Raghav wrote:
> > On 2/13/26 14:32, Ojaswin Mujoo wrote:
> > > On Fri, Feb 13, 2026 at 11:20:36AM +0100, Pankaj Raghav wrote:
> > >> We currently have RFCs posted by John Garry and Ojaswin Mujoo, and there
> > >> was a previous LSFMM proposal about untorn buffered writes from Ted Tso.
> > >> Based on the conversation/blockers we had before, the discussion at LSFMM
> > >> should focus on the following blocking issues:
> > >>
> > >> - Handling Short Writes under Memory Pressure[6]: A buffered atomic
> > >>   write might span page boundaries. If memory pressure causes a page
> > >>   fault or reclaim mid-copy, the write could be torn inside the page
> > >>   cache before it even reaches the filesystem.
> > >>     - The current RFC uses a "pinning" approach: pinning user pages and
> > >>       creating a BVEC to ensure the full copy can proceed atomically.
> > >>       This adds complexity to the write path.
> > >>     - Discussion: Is this acceptable? Should we consider alternatives,
> > >>       such as requiring userspace to mlock the I/O buffers before
> > >>       issuing the write to guarantee atomic copy in the page cache?
> > >
> > > Right, I chose this approach because we only get to know about the short
> > > copy after it has actually happened in copy_folio_from_iter_atomic()
> > > and it seemed simpler to just not let the short copy happen. This is
> > > inspired from how dio pins the pages for DMA, just that we do it
> > > for a shorter time.
> > >
> > > It does add slight complexity to the path but I'm not sure if it's complex
> > > enough to justify adding a hard requirement of having pages mlock'd.
> > >
> >
> > As databases like postgres have a buffer cache that they manage in userspace,
> > which is eventually used to do IO, I am wondering if they already do a mlock
> > or some other way to guarantee the buffer cache does not get reclaimed. That is
> > why I was thinking if we could make it a requirement. Of course, that also requires
> > checking if the range is mlocked in the iomap_write_iter path.
> 
> We don't generally mlock our buffer pool - but we strongly recommend to use
> explicit huge pages (due to TLB pressure, faster fork() and less memory wasted
> on page tables), which afaict has basically the same effect. However, that
> doesn't make the page cache pages locked...
> 
> 
> > >> - Page Cache Model vs. Filesystem CoW: The current RFC introduces a
> > >>   PG_atomic page flag to track dirty pages requiring atomic writeback.
> > >>   This faced pushback due to page flags being a scarce resource[7].
> > >>   Furthermore, it was argued that atomic model does not fit the buffered
> > >>   I/O model because data sitting in the page cache is vulnerable to
> > >>   modification before writeback occurs, and writeback does not preserve
> > >>   application ordering[8].
> > >>     -  Dave Chinner has proposed leveraging the filesystem's CoW path
> > >>        where we always allocate new blocks for the atomic write (forced
> > >>        CoW). If the hardware supports it (e.g., NVMe atomic limits), the
> > >>        filesystem can optimize the writeback to use REQ_ATOMIC in place,
> > >>        avoiding the CoW overhead while maintaining the architectural
> > >>        separation.
> > >
> > > Right, this is what I'm doing in the new RFC where we maintain the
> > > mappings for atomic write in COW fork. This way we are able to utilize a
> > > lot of existing infrastructure, however it does add some complexity to
> > > ->iomap_begin() and ->writeback_range() callbacks of the FS. I believe
> > > it is a tradeoff since the general consesus was mostly to avoid adding
> > > too much complexity to iomap layer.
> > >
> > > Another thing that came up is to consider using write through semantics
> > > for buffered atomic writes, where we are able to transition page to
> > > writeback state immediately after the write and avoid any other users to
> > > modify the data till writeback completes. This might affect performance
> > > since we won't be able to batch similar atomic IOs but maybe
> > > applications like postgres would not mind this too much. If we go with
> > > this approach, we will be able to avoid worrying too much about other
> > > users changing atomic data underneath us.
> > >
> >
> > Hmm, IIUC, postgres will write their dirty buffer cache by combining
> > multiple DB pages based on `io_combine_limit` (typically 128kb).
> 
> We will try to do that, but it's obviously far from always possible, in some
> workloads [parts of ]the data in the buffer pool rarely will be dirtied in
> consecutive blocks.
> 
> FWIW, postgres already tries to force some just-written pages into
> writeback. For sources of writes that can be plentiful and are done in the
> background, we default to issuing sync_file_range(SYNC_FILE_RANGE_WRITE),
> after 256kB-512kB of writes, as otherwise foreground latency can be
> significantly impacted by the kernel deciding to suddenly write back (due to
> dirty_writeback_centisecs, dirty_background_bytes, ...) and because otherwise
> the fsyncs at the end of a checkpoint can be unpredictably slow.  For
> foreground writes we do not default to that, as there are users that won't
> (because they don't know, because they overcommit hardware, ...) size
> postgres' buffer pool to be big enough and thus will often re-dirty pages that
> have already recently been written out to the operating systems.  But for many
> workloads it's recommened that users turn on
> sync_file_range(SYNC_FILE_RANGE_WRITE) for foreground writes as well (*).
> 
> So for many workloads it'd be fine to just always start writeback for atomic
> writes immediately. It's possible, but I am not at all sure, that for most of
> the other workloads, the gains from atomic writes will outstrip the cost of
> more frequently writing data back.
> 
> 
> (*) As it turns out, it often seems to improves write throughput as well, if
> writeback is triggered by memory pressure instead of SYNC_FILE_RANGE_WRITE,
> linux seems to often trigger a lot more small random IO.
> 
> 
> > So immediately writing them might be ok as long as we don't remove those
> > pages from the page cache like we do in RWF_UNCACHED.
> 
> Yes, it might.  I actually often have wished for something like a
> RWF_WRITEBACK flag...
> 
> 
> > > An argument against this however is that it is user's responsibility to
> > > not do non atomic IO over an atomic range and this shall be considered a
> > > userspace usage error. This is similar to how there are ways users can
> > > tear a dio if they perform overlapping writes. [1].
> 
> Hm, the scope of the prohibition here is not clear to me. Would it just
> be forbidden to do:
> 
> P1: start pwritev(fd, [blocks 1-10], RWF_ATOMIC)
> P2: pwrite(fd, [any block in 1-10]), non-atomically
> P1: complete pwritev(fd, ...)
> 
> or is it also forbidden to do:
> 
> P1: pwritev(fd, [blocks 1-10], RWF_ATOMIC) start & completes
> Kernel: starts writeback but doesn't complete it
> P1: pwrite(fd, [any block in 1-10]), non-atomically
> Kernel: completes writeback
> 
> The former is not at all an issue for postgres' use case, the pages in our
> buffer pool that are undergoing IO are locked, preventing additional IO (be it
> reads or writes) to those blocks.
> 
> The latter would be a problem, since userspace wouldn't even know that here is
> still "atomic writeback" going on, afaict the only way we could avoid it would
> be to issue an f[data]sync(), which likely would be prohibitively expensive.
> 
> 
> 
> > > That being said, I think these points are worth discussing and it would
> > > be helpful to have people from postgres around while discussing these
> > > semantics with the FS community members.
> > >
> > > As for ordering of writes, I'm not sure if that is something that
> > > we should guarantee via the RWF_ATOMIC api. Ensuring ordering has mostly
> > > been the task of userspace via fsync() and friends.
> > >
> >
> > Agreed.
> 
> From postgres' side that's fine. In the cases we care about ordering we use
> fsync() already.
> 
> 
> > > [1] https://lore.kernel.org/fstests/0af205d9-6093-4931-abe9-f236acae8d44@oracle.com/
> > >
> > >>     - Discussion: While the CoW approach fits XFS and other CoW
> > >>       filesystems well, it presents challenges for filesystems like ext4
> > >>       which lack CoW capabilities for data. Should this be a filesystem
> > >>       specific feature?
> > >
> > > I believe your question is if we should have a hard dependency on COW
> > > mappings for atomic writes. Currently, COW in atomic write context in
> > > XFS, is used for these 2 things:
> > >
> > > 1. COW fork holds atomic write ranges.
> > >
> > > This is not strictly a COW feature, just that we are repurposing the COW
> > > fork to hold our atomic ranges. Basically a way for writeback path to
> > > know that atomic write was done here.
> 
> Does that mean buffered atomic writes would cause fragmentation?  Some common
> database workloads, e.g. anything running on cheaper cloud storage, are pretty
> sensitive to that due to the increase in use of the metered IOPS.
> 

Hi Andres,

So we have tricks like allocating more blocks than needed which helps
with fragmentation even when using COW fork. I think we are able to tune
how aggresively we want preallocate more blocks. Further, if we have say
fallocated a range in file which satisfies our requirements, then we can
also upgrade to HW (non cow) atomic writes and use the falloc'd extents
which will also help with fragmentations

My point being, I don't think COW usage will strictly mean more
fragmentation however we will eventually need to run benchamrks and see. 
Hopefully once I have the implementation, we can work on these things.

Regards,
ojaswin

> Greetings,
> 
> Andres Freund

