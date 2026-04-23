Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7365DF99368
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:08:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B976B0005; Thu, 23 Apr 2026 06:08:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD596B008A; Thu, 23 Apr 2026 06:08:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2996B008C; Thu, 23 Apr 2026 06:08:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDD96B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:08:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AE28160562
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:08:40 +0000 (UTC)
X-FDA: 84689396400.16.0BB9DB0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id AE30BC0008
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:08:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rP5rZayy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776938917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IxktJseZTkju4U2M5faDB3wvvH5jvSdDn7i3mvBckg=;
	b=f8hh1nad6Wx6guQcaSZWAUT+sLWYFAy1exbOKf8sNKfX1z7NVvVbiabaP+PkWT12QRJdnq
	fxbQyoruXAitk9HSFUi3+X3qBRqA7ZutfrrvSayQvQLzKso9y4sUwoFuJt3ToV/OEM+URd
	AfGAtZu16mXklIQYDPS0czhS0UV+L9w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=rP5rZayy;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf22.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776938917; a=rsa-sha256;
	cv=none;
	b=4qG2IOrMX4x5wxmyzR5KEyglDsc5t7HbJdq0nKFTN/ixZaLC6ve08/jTXSo3q9tWH7lUKv
	Ly2OyqAN1obx3VaVV5+p1hCRqLHKPNIHrwSd39LvC9KE8YWHCaMfA2Sus8XzbvRjy2f066
	HJtEIwFk2IVa1atHpItgAG7GVVeikR0=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63N894Zf3944516;
	Thu, 23 Apr 2026 10:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=5IxktJseZTkju4U2M5faDB3wvvH5jv
	SdDn7i3mvBckg=; b=rP5rZayylIkjv9F2O3s2doRp51/NLYmJ2hnI3ce7oc81yZ
	KjXSYMjCehyU+VVZBtbIrXRZYlyMci1jzUN5yuaYWpwhnZdV8pEUEIB2j4QARxqK
	ah8e+7e6BVKNTAqEsYoGT9EnSvLoM5D4FBQSq8HMOwjFMS9+L457GCirV0um45kP
	52qGRSp/6mSGp9a6fz7GwQKy/OHGvqlcfH+emLzmB32LrbgVSdQhmIZZ6/w17q4n
	12KMxNQ54yxYrONQ2YkpuJX7PTYU/oAjiHkd/KJxo595CEp37VFkuxknn23Li/cI
	k7hKunvWkXtUfLM7Mqt79imHW+LVXgY5zkNOMQ0w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dpeu3qg18-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:08:21 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 63NA5Ge6025799;
	Thu, 23 Apr 2026 10:08:20 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dpjkxx49t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Apr 2026 10:08:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63NA8IVM16122232
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Apr 2026 10:08:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D12CB2006B;
	Thu, 23 Apr 2026 10:08:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A8C720067;
	Thu, 23 Apr 2026 10:08:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 23 Apr 2026 10:08:15 +0000 (GMT)
Date: Thu, 23 Apr 2026 15:38:12 +0530
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
Message-ID: <aenvjOFl9_yI0uTK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
 <52wsh6owrtmznt5xuks6ljwy4zbpyid45x5dbxo5xgssxm4zxy@iue2on3llpfb>
 <aeKNHi8GloNgch7X@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <laegs2jt5ifqmfmdlsl7gsrc64z4nrnwbxazewbr7jk27emdej@l6vhj7pjh3dy>
 <aee8xaz_5x-aQ5BK@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <eqbodkjxxg32ryxsdngx35yhv5fy4p44fmvlnlnoyib6bstlmf@4hzxnfwleynb>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eqbodkjxxg32ryxsdngx35yhv5fy4p44fmvlnlnoyib6bstlmf@4hzxnfwleynb>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: wFoHpIQzqG-mS04jKUbxXfeZHfvwcpjl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIzMDA5NSBTYWx0ZWRfX6mHJU6VhB4e6
 tTDmZIglNbwUqqn+v0ALfQ8t7b7kvO1oTxPfcfzaxzu1SyloLpfDfNRJQCZdXH4YqmE24Jsrrvp
 8ripQzrIiKetvW/PiMOw4kYJN902zP1kNMqS9TLHmjcUAMlLGxF+yQt5ZxNz8gMqW35E3stvzjT
 3alyzOggA90nvPvSd4t99qAjMqMRz53NgQ/5vFmRWNtrLsJgrsYlyoCENIOD6yJ6Gp5G19npO1B
 8g3qakZTjBjIwIEOkBZXmRIQg0YY3tJw6FhwBRSYH0v5LsUgkRbFYUgWXwwHCbis+AYO8RXIfbw
 Pc3xuIBH/M9MiUqaRQJWpAp797JogG2k6Xk+Bzmlg6qRH2Dr2oCPfW4kNsJilsvHNFCn/ITzLfJ
 eY8Q88xstACTvnHukbvIZi9c541WcLcnmVwHgzJ+cCeAbNJkiZKzfZZoMR+E1Wqz2tVpjYgvXag
 +FRh42uFQ9xhYMA3Azw==
X-Authority-Analysis: v=2.4 cv=a6kAM0SF c=1 sm=1 tr=0 ts=69e9ef95 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=iox4zFpeAAAA:8
 a=l9p49PqFwY51bxc8sbUA:9 a=CjuIK1q_8ugA:10 a=WzC6qhA0u3u7Ye7llzcV:22
X-Proofpoint-ORIG-GUID: 96c5PUns6hySA_OuquvA_5hgy5bL7Q7Z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-23_02,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2604230095
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AE30BC0008
X-Stat-Signature: 1g4oghxd9rbarkxqqsryi17sxnyjh6in
X-HE-Tag: 1776938917-470206
X-HE-Meta: U2FsdGVkX1+1n7Esfu3yn1Hz1+UJ2IHuY79xirj/k9hMk3GnM/bl/pCs1rCO4IWro6JHe3HvuNU/OXUXetCsvzG5elQidVnsAsMUuVkqZEtHAV93tDl8+fF3WA4VDm+XmEaAoFonL43Abk5NOYusJquvTqtS5Du5sLDeUsqvw+PXqBLU/P5qSFotb2ooKr5WspHU1BVbq1wlImVG4wMx6tf985OfqQIQoTK8oYg+WFmPjCt1Q0libj1DYWIlOtNp1chVkj944Pxt09WgS6qkVWJwZCpnIQ0G96BFSD83/SSdNWF03aBbEtIXnKLYQgmfHvCKTcrNyZGdv0kPs0fVMerPpAvPXJZF2mxoMN+pJuaBaqUZ9p5ata1UUung003kEcbYe2ZoRp0s6hFvL+oxitg+ClvqitdCE7YwnNrTnUrTmWg/OAPfRf3qYnbU7HisX4v8XYUkmmqOHOHFloJEGWjrIh3ASCI/YgFNzEC/KbwBHlG1BvBkwSS5WNpmZuzRLlC/nMt5mVEj6mByYirkK60K7un6+ZDZqTOjBxUQk6SAJ7ICHour/y02lgXSKDUGjUpk0oLUUlVfggRqDc0koMeVki0DJuaiFeqA31HIzBpml+uaQD6jnwCiXv9EeTf+1NLOux/xTHkzlwk5b7EcUCZ8dpIK1sx9RmEXvTTD6pswamcHrJK24pcnWRi66aEt6jxIzlIXbSsesKSFBF/sy+4/PSPkS975Pr7j5nd4cH0bWcR1Ufm+dRkCHT1yFwBmjvyWbxTxEYPCxS4gtqmsoECvM5JjX2lxe6sGf3uqWrLfZL1WaBmxWVHtEbRb5b7zGecPmR7QrPmgufQVED6XTTANBFXIY4N0MWIlolA4J8cprMjPsGpiYFat5mYeqNw7a/FCrE14rWvjkUOFWD0yW156W6+byT69jKinQPBvdW1pQbMZyoKm95tGY8Rkrr7orsnAs3pWICwNIy3nMBu
 P/adgfXm
 ro9E3i5imp62EcsMEY8s3NqRbdqWqKap8Vv32wDW6KNLCcGpD2WayBuNSVDcGAeXM4fvrxb7au3GCK9ZixDuJpLJ/OW8W0S0CSEqw6Y3ziOffsuDSDkjbiie8wTxqa/Iht3hSNdjKeKVE2o+o1F5WbsUhJ5NFlx9+E4QtizJnMsTS30mI1LyOGKwzfeE7ft5nIO6BjO3TH+vzON+bDsd1TV9tGxOQ6Uvp/CCzjsX5lyKxon+haTd7vKODHLnlbGkBwvHNrk0pvEJqih4L2Mq3QmdgtkuL8jJ9NhPK5GhxToGUk5b5TBboCytrIJZRSxIAscxXJawKzJCkxlQmUMCbdblyeC0RAbetJvYCSS6t62kvmHaj6gWWgdyC+e4iNBcYnqJEFCYWeDcWnoGR+OTHyyHgHKlJDQZXh6j3lFGKNF8cUdFKzai9XTdtQFmaOw2CtxVhkIZrdQWyUnAX1ZaV2GbFVAkl+PZrnooN8NeXq55k2xt67SQMtbyz8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 12:00:34PM +0200, Jan Kara wrote:
> On Tue 21-04-26 23:37:01, Ojaswin Mujoo wrote:
> > On Mon, Apr 20, 2026 at 01:28:18PM +0200, Jan Kara wrote:
> > > On Sat 18-04-26 01:12:22, Ojaswin Mujoo wrote:
> > > > On Thu, Apr 16, 2026 at 02:34:15PM +0200, Jan Kara wrote:
> > > > > > @@ -1096,6 +1097,276 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
> > > > > > +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> > > > > > +				   struct iomap_iter *iter, struct iov_iter *i,
> > > > > > +				   const struct iomap_writethrough_ops *wt_ops)
> > > > > > +
> > > > > > +{
> > 
> > <...>
> > 
> > > > your comment but) after this email, I started diggin a bit more into why
> > > > it is needed.  As per my understanding, it tackles 2 things:
> > > > 
> > > > Problem 1. mkclean's the old EOF folio so that the FS can fault again. This
> > > > allows us to allocate new blocks which previously might not be allocated
> > > > if bs < ps.
> > > > 
> > > > Problem 2. Since mmap writes can dirty data beyond EOF, we zero the range from
> > > > old EOF to end of that folio so that readers dont read junk data after
> > > > isize extension.
> > > 
> > > Correct.
> > > 
> > > > Another thing I noticed is that most users of
> > > > iomap_file_buffered_write() do their own eof zeroing in the FS layer
> > > > (eg, xfs_file_write_zero_eof(), ext4's new changes,
> > > > ntfs_extend_initialized_size() etc). 
> > > > I think this FS level zerooing should take care of mkcleaning the eof
> > > > folio (problem 1), as they call iomap_zero_range() which would flush the
> > > > eof range anyways. So am I right in assuming that for FSes that do their
> > > > own zeroing, 1. is already taken care of?
> > > 
> > > Well, I don't see anything that would writeprotect the old tail page in
> > > iomap_zero_range(). I think iomap_zero_range() calls are there mostly to
> > > address 2. Not only due to mmap but also possibly to clear whatever junk
> > > there can be in the blocks after EOF.
> > 
> > Well I was thinking more like if the EOF page was mmap'd it would be
> > dirty and blocks beyond EOF would be unmapped, so iomap_zero_range() will
> > write it back which shall mkclean() the folio.
> > 
> > But I think the same race we discussed for problem 2 can also occur
> > here.
> > 
> > Thread 1 (extending write)             Thread 2 (mmap writer)
> > 
> > iomap_zero_range()
> > filemap_write_and_wait_range()
> >                                        // mmaps & writes EOF range
> > iomap_write_iter()
> > isize = new_size
> > // pagecache_isize_extended() is
> >    needed to mkclean() old EOF page.
> 
> Yes, this race exists and unlike in the case of zeroing where it is mostly
> harmless not guranteeing calling page_mkwrite() with updated i_size can
> lead to filesystem tripping on assertions, data loss or similar.

Right.

> 
> > > > As for 2, I think after the EOF zeroing of the FS, there might be a
> > > > window before iomap_write_iter() where an mmap writer can still dirty
> > > > EOF blocks, hence the pagecache_isize_extended() would be needed here.
> > > > But doesn't that then make the eof zeroing in the FS layer redundant? Am
> > > > I missing something here?
> > > 
> > > Hmm, I agree the zeroing looks duplicit (for some users of
> > > pagecache_isize_extended()). And yes, doing the zeroing from
> > > xfs_file_write_zero_eof() is somewhat racy (mmap writer can still come and
> > > write non-zeros before we update i_size) but I'd have hard time to argue it
> > > really practically matters - you are racing mmap writes with buffered
> > > writes so any kind of write atomicity guarantees are not there. 
> > 
> > Yeah, seems like it is not enough to take care of either 1 or 2 and
> > pagecache_isize_extended() should maybe be enough. I was just wondering
> > if we could optimize it away even for normal extend path (no racing mmap),
> > we can avoid the expensive folio_zero_range() calls.
> > 
> > Regardless, Ive not looked at this more closely and its a separate issue
> > so we can revisit it later. For now I wanted some clarity around
> > pagecache_isize_extended() so thanks for that.
> 
> Well, but pagecache_isize_extended() doesn't guarantee on disk blocks are
> zeroed out as well as it doesn't dirty the page. Also
> xfs_file_write_zero_eof() potentially handles zeroing of more than a tail
> page. So you cannot simply drop one of these.

Hmm yea true, xfs_file_write_zero_eof() does take of zeroing any mapped
eof blocks on disk as well.

> 
> > > > Regardless, for our case I think we will also need to do the
> > > > pagecache_isize_extended(), mainly to take care of problem 2, but where
> > > > exactly should we do it now?  We currently change the isize in endio()
> > > > but for aio, it can run outside inode or folio lock. I think this
> > > > function needs to be called under inode lock(). Hmm.. its a bit late here so
> > > > I'll revisit this tomorrow with a fresh mind :)
> > > 
> > > I think mainly to take care of problem 1... You are correct about
> > > inode_lock but since we are updating i_size, we should be better holding
> > > it, shouldn't we?
> > 
> > Yes you are correct. In the aio writethrough codepath, the inode update
> > is happening without the inode lock which is wrong. I overlooked the
> > fact that even aio dio uses IOMAP_DIO_FORCE_WAIT to force isize update
> > under inode lock, and we should do something similar as well.
> 
> Yes.
> 
> > So in v3, I make the change that for extending writes we shall always
> > finish them in "sync" fashion so ->endio() runs under inode lock. Then,
> > after ->endio() in iomap_dio_complete(), I will call

( I meant iomap_writethrough_complete(), here)

> > pagecache_isize_extended() to take care of this. Just like isize update
> > right now, the isize_extension only runs when the IO was successful
> > otherwise we return an error to the user. This gives us semantics like
> > dio while handling extension properly.
> > 
> > Does that sound okay?
> 
> Yep, sounds fine.

Got it, thanks for the review Jan!

Regards,
ojaswin

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

