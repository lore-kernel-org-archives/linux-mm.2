Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF8BF94CA3
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 18:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A84236B0088; Tue, 21 Apr 2026 14:07:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A346B6B0089; Tue, 21 Apr 2026 14:07:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 922DE6B008A; Tue, 21 Apr 2026 14:07:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 813C76B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:07:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 388E41B9733
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:07:24 +0000 (UTC)
X-FDA: 84683345208.03.B28C468
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf07.hostedemail.com (Postfix) with ESMTP id E000640006
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:07:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RBZ5lDDk;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776794842; a=rsa-sha256;
	cv=none;
	b=56L+/3koEHZM7J2O1CIsqOmxDCx8A7ZZTlf6uQlGaSNajrHPUV1rHcnuOZtsBoMFu3Nkfb
	Teqh8FR8xHajr/h89CO2KnVj59VWbk9qN7kLEKLvp5QM49cxA8GJhqkA6Nm7mgx/kEqLXH
	Rw6CQO+JHFnavFdLByjCkc5pRlSRDr0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=RBZ5lDDk;
	spf=pass (imf07.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776794842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Pt5l+YeIZm/5ZIBblpz6/ApkaoGzkNTvoXkafxhSeE=;
	b=bNbz49pV3RhtHp3i84Ta3GDGRaCxYI6c9zbT+B7mXSdTVuyDoKEoBh7FylAKKzv6+2qPTs
	OYDX7CIIt56DU5Zz+EItHdaCWowEjHVGQ/krLRvr3aHrRzKwX4WL57FaTW51oL3CbcUPiK
	0m8Y1uHBQ+z9sC4InrKhVAz4BK3gl/0=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63LHoghJ555400;
	Tue, 21 Apr 2026 18:07:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0Pt5l+YeIZm/5ZIBblpz6/ApkaoGzk
	NTvoXkafxhSeE=; b=RBZ5lDDkBpFu03Ta/Ehbrp5IJOGzRIMDq8/tYQi0xa9SQB
	HdAkxziqwa+lj2iZ2G7tQWnVRuhbzHJOyyStjNLtbJhg6C7IpBs2pTxi9YjJYno8
	LjiJjY6mhFuZYhveHpJJU9HSXfFGTmFjog6NrKiSXDYV13RVfHDsA+uqKx98fd2h
	U29ZgvUZAAidC/VP1borbg3yFExpwVMF0eOZvtLmgFsomNAiCvEYfReqd5qiWmTh
	7IvullZ5ks1Debxub3OxVzbZ/Mf8lqAKO1TOXgiDsc5zZ7wpt4DrcZ67KNpJQoDI
	QDb9i2RYlxl1nasjJ7u45jz9dXJZ7dB+4/gWIXDw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dm2h9mvj8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:07:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63LHZVjZ009930;
	Tue, 21 Apr 2026 18:07:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dmn9k1sxy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Apr 2026 18:07:09 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63LI777I43319592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Apr 2026 18:07:07 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C7B222004B;
	Tue, 21 Apr 2026 18:07:07 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3898A20040;
	Tue, 21 Apr 2026 18:07:04 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.29.146])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 21 Apr 2026 18:07:03 +0000 (GMT)
Date: Tue, 21 Apr 2026 23:37:01 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: dHOxqXuPqUDabJGUbCrDd0E8Lkxm8cBb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIxMDE3NyBTYWx0ZWRfX00Qi2ArFdy8g
 X86YPDh3hHrYDtOGYrAYeUIiu69c4eGoJjnRZ8hQMcE8ycxWxpFFgrA2RdKyA+dkts0lcguDoYA
 TKSaQAG/UDOl91qcMDhq11SyMh7fkX/q1ehkV5fOX1pui0ZCO+WEYuuFqdrElecmRHIaD4zItqF
 YAuL0IBuoHNFqenr6VnIpzCD9VS6IfFyb+X65vRlF53JjtvWr1iNrkQkNsjSDBVgWdM7UY75MNk
 +X/O59LUhRiFpwqFXWzWRwUHo1nE1bxLKicnsYdt58lEqIDqEm3kf+voGoEZ15t79BjgPmzuL/G
 Jd7ne98rUWIAriYhW3Qws7rTM2bed2/sFfk777XITx+eDzgbr0qbuPGBu8rvgyJPk4KMKt0gmMW
 ECOhEI9/g25rsV0YMAYOnQB1sLnfMi3Ry70R9rF3wZe4z1GCaX6NUwY8mpmQQod4iWQ7AyJjSES
 M8j7IBASUfyBaxC41TA==
X-Authority-Analysis: v=2.4 cv=XLYAjwhE c=1 sm=1 tr=0 ts=69e7bccf cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=iox4zFpeAAAA:8
 a=DU7pH1NQbppyTea5T5YA:9 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-GUID: nfmV67tfxh-RUfv9CeMajdvGriLKC88r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-21_03,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604210177
X-Rspamd-Queue-Id: E000640006
X-Stat-Signature: 1nyt8mmssmb4wwjkdihoi6w1uipjsutn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776794841-661878
X-HE-Meta: U2FsdGVkX18771wbL/vtyAHs7dritZc9Xmva1j5kZmlWXSYtMIsxAKVCcnH0cbJfCDnslSMtYT4fg8XptQ6084qpnmoGVtinBvnS96tt2Y3iQ+AQLcOPPSY1ynyyKaAETSIh3kCOHrpwrZJsXm9/Neadnm3ahEFuHL99TWQMmAqbbetB34GL2OOU+qRX9oCPYf6fFn+rj8Gc1QWdw1r7Dm1/ieXN2NCaz5iUIH4VcxJIk38DEVq63HgifgEuj/kdflcvOf0VPJFiZ5hjUksOpq27pRPa6sV49nTjviplMaxMlZNHCF/vlh8xH2IdAWWglek1TPBYG0s0MJFYXdF/zlVYCvpa96HaEpIs1Eu4kIJlik3dbMZhsphtDu6ZoI1J8/BDHDLAXMvZdPER6X54fZbHgnSVdIP6dvRfpB2kJOAV74yAmC8Xkujzg3Q4hGjFqd5z/R6eye6hSCqIyGmrNtz8Mo9ZcwIP7fz1edzpHKlIhZxdcbAlDmLKPdgIzrMXhpH5Frx1AWX+C8d2tLpktliWvXQNJ1KGdD+V+D7svIM14wWJotpsclfdU0o4LbbF69Iug4ygkFYP7WU63WfUHET+/sbb7yhO4VF9ybMzVULA3l/X38510PnHMLF9KkmNoBhq52VF+PWoxmVu0OGjNDEuW9pzf1H3yOiLoQjNKRiHZ5zcfxU3otObnRklAzGzOMVIS0VqzK8/00nZWJIuoiLDCMGy28nKLlA93FcX1XoDXY9DqqPMRX2ai7AHm9powsn0eoxBTgClfJNLwCS/Ipp/n4S0grKV+tHMSW55Yk31LNTraJkR6flxEqlvZsJkoUlIlTyJTjntFAL0tug0mBfKS4UBYUlzA4CGL5NkQBTXHr3IYjyo2DSc/B5rvZNDPv0AL5tDoAHxlTleKCfpqpH/eKkOEncfJ5kjWRWvmE60ARgJ8GV+df8/IGwEM17ZkeVDPEEPk1NojSGa473
 ZcqjuUft
 +1ZY9/Fm5oFQMnsZt+1y4frbxPeeStkzRSTVMoJmq95wQu0G7TtxQeNOQbd9I2gI5kbwISlFln4RixrrjSqb69dpa0y0iDVvHnkXit34AP3wgV85SqN/3V7yciNJr/e3SwiIjdF+BCwHqV16ZbUL2wCeP7pIf/koSWOX5DTh4OgjqoTIJs/KcpZngN0rI1wqHuKCfZmaUOAwQDyxCJmCSVJFuD80ATtxzpGZoP+bFJxK9bwYG4TgRnN/JPVtrcfMspMnvJTw14wLR9TbRDigwPazvfmcdaCDud/wk6qACXq+Bp054F8eaJQIozL0VZ73jRn3Raxo5dHaXA9QgY8V9gjsklTOBFlay4dFvwXGcz+T5hxLcHppbEuDnUdJPp2T+V798LneJDugBgx7Yi3Au32FrUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 20, 2026 at 01:28:18PM +0200, Jan Kara wrote:
> On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> > On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > > +
> > > > +{

<...>

> > your comment but) after this email, I started diggin a bit more into why
> > it is needed.  As per my understanding, it tackles 2 things:
> > 
> > Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> > allows us to allocate new blocks which previously might not be allocated
> > if bs < ps.
> > 
> > Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> > old EOF to end of that folio so that readers dont read junk data after
> > isize extension.
> 
> Correct.
> 
> > Another thing I noticed is that most users of
> > iomap_file_buffered_write() do their own eof zeroing in the FS layer
> > (eg, xfs_file_write_zero_eof(), ext4's new changes,
> > ntfs_extend_initialized_size() etc). 
> > I think this FS level zerooing should take care of mkcleaning the eof
> > folio (problem 1), as they call iomap_zero_range() which would flush the
> > eof range anyways. So am I right in assuming that for FSes that do their
> > own zeroing, 1. is already taken care of?
> 
> Well, I don't see anything that would writeprotect the old tail page in
> iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
> address 2. Not only due to mmap but also possibly to clear whatever junk
> there can be in the blocks after EOF.

Well I was thinking more like if the EOF page was mmap'd it would be
dirty and blocks beyond EOF would be unmapped, so iomap_zero_range() will
write it back which shall mkclean() the folio.

But I think the same race we discussed for problem 2 can also occur
here.

Thread 1 (extending write)             Thread 2 (mmap writer)

iomap_zero_range()
filemap_write_and_wait_range()
                                       // mmaps & writes EOF range
iomap_write_iter()
isize = new_size
// pagecache_isize_extended() is
   needed to mkclean() old EOF page.

>
> > As for 2, I think after the EOF zeroing of the FS, there might be a
> > window before iomap_write_iter() where an mmap writer can still dirty
> > EOF blocks, hence the pagecache_isize_extended() would be needed here.
> > But doesn't that then make the eof zeroing in the FS layer redundant? Am
> > I missing something here?
> 
> Hmm, I agree the zeroing looks duplicit (for some users of
> pagecache_isize_extended()). And yes, doing the zeroing from
> xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
> write non-zeros before we update i_size) but I'd have hard time to argue it
> really practically matters - you are racing mmap writes with buffered
> writes so any kind of write atomicity guarantees are not there. 

Yeah, seems like it is not enough to take care of either 1 or 2 and
pagecache_isize_extended() should maybe be enough. I was just wondering
if we could optimize it away even for normal extend path (no racing mmap),
we can avoid the expensive folio_zero_range() calls.

Regardless, Ive not looked at this more closely and its a separate issue
so we can revisit it later. For now I wanted some clarity around
pagecache_isize_extended() so thanks for that.

> 
> > Regardless, for our case I think we will also need to do the
> > pagecache_isize_extended(), mainly to take care of problem 2, but where
> > exactly should we do it now?  We currently change the isize in endio()
> > but for aio, it can run outside inode or folio lock. I think this
> > function needs to be called under inode lock(). Hmm.. its a bit late here so
> > I'll revisit this tomorrow with a fresh mind :)
> 
> I think mainly to take care of problem 1... You are correct about
> inode_lock but since we are updating i_size, we should be better holding
> it, shouldn't we?

Yes you are correct. In the aio writethrough codepath, the inode update
is happening without the inode lock which is wrong. I overlooked the
fact that even aio dio uses IOMAP_DIO_FORCE_WAIT to force isize update
under inode lock, and we should do something similar as well.

So in v3, I make the change that for extending writes we shall always
finish them in "sync" fashion so ->endio() runs under inode lock. Then,
after ->endio() in iomap_dio_complete(), I will call
pagecache_isize_extended() to take care of this. Just like isize update
right now, the isize_extension only runs when the IO was successful
otherwise we return an error to the user. This gives us semantics like
dio while handling extension properly.

Does that sound okay?

Regards,
ojaswin

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

