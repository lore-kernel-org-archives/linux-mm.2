Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB0FC83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 18:43:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC8FC6B0089; Mon, 28 Jul 2025 14:43:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA05E6B008C; Mon, 28 Jul 2025 14:43:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8F076B0092; Mon, 28 Jul 2025 14:43:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B0CF36B0089
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 14:43:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84DFD80381
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:43:48 +0000 (UTC)
X-FDA: 83714547336.20.79F6710
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA630C0013
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 18:43:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGonoDtf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753728226; a=rsa-sha256;
	cv=none;
	b=tKfkSYyDT2FbkogjgO7KR9sGpG0+FgXql7NqTTW3OYwiK5sDuqq5ofIADAaSrmlPNQ029U
	H+WS0zMx4DWoEolEpNH5WhQftv7jJIfefb//hHjdkyWK7zvV8J8TaPhkIsSJVGlVm81zj/
	T7BpLYXQWVPLfewY+UFPpbPo7CDR8HE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGonoDtf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753728226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAsS2jWovqhQ/P3dsGkg9jYfwdCiwv5xccdAZ6hHeKQ=;
	b=Jpo1KjGNzb8puWkCXZxUCkjkw7rkiZwJ33Ce1MIzuQL2u/Czaz61LypGOKO4fyDviCUEep
	QjnFeTnR3fDVZ7RdivLzYzI/uPlt2skCaLSR8lGNUP3/nCfcc/UZnqQo+cPLq5R+ecQf/g
	OzKE9jWw0SllE1Sqp4ZnA0lX3mdJKZ4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 38B7B601FA;
	Mon, 28 Jul 2025 18:43:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73DBC4CEE7;
	Mon, 28 Jul 2025 18:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753728225;
	bh=Xf2hz7TOpHiqBdd1wuMT/dAEUrQ8nRBxTAfDXorLxU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGonoDtfZcvl4wAegtfBny9SfyLgEdPZ27t2cNxooJOOn3HuA8bv503WJHRlBWw0/
	 eRHqrzV0jjMHylmDZZNHQmabfShEAPIMCTA+6v1TbNYHmXM5mwc5veRqJOkB9SFatm
	 QgmCQSwmGMSi8qzCSGVdY0s4VM0QW8NWHY4pcn8hrkYlXjTlhvl+KRJFmH0zOQTjB+
	 L4nkGlTuiKbMhtS04JXLwE5XksrSz631g+p6/m+cxUPSNQ6fRCEWFJEVcqadPsa5qg
	 UOmtGppTOwPpVOmC5RhDP0mOrG+qsh2uqkcn2cW7wOipOny757apZjWhLb4uHEWnKM
	 gFFSo9qi/pHyA==
Date: Mon, 28 Jul 2025 11:43:45 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	linux-fsdevel@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
	linux-xfs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>,
	lkft-triage@lists.linaro.org,
	Linux Regressions <regressions@lists.linux.dev>,
	Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <liam.howlett@oracle.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: next-20250721 arm64 16K and 64K page size WARNING fs fuse file.c
 at fuse_iomap_writeback_range
Message-ID: <20250728184345.GD2672070@frogsfrogsfrogs>
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs>
 <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs>
 <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
 <aIe0ouF9tsuIO58_@casper.infradead.org>
 <CAJnrk1aXvVf7jaK9_2PamK5X+1b+crT+kmn8vktv0nxqCtcW8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aXvVf7jaK9_2PamK5X+1b+crT+kmn8vktv0nxqCtcW8g@mail.gmail.com>
X-Stat-Signature: uoghuchzpd1kenj3m7xb8hui3wbs3hze
X-Rspam-User: 
X-Rspamd-Queue-Id: DA630C0013
X-Rspamd-Server: rspam02
X-HE-Tag: 1753728226-908782
X-HE-Meta: U2FsdGVkX19PAtSLrlbXlxAwALqlo9N6m0y2IGLBM22xZ4DpXY4ZywZm1h3nBe+Y1MH/KMqBoDCRPxqS6jpDZ7YxVTzI5FmMh+FCrAlLSjqxeeC/H91xR2LYe1aWJ2kR/ZeGejQY9ASswF+vX19nO31qmCxC79OH8SAy1/NzO3xsV1hy/hd3WU256VZZhGsxBV0J/RWtNJsnAy8L8poHuMdk6AJDf+8nwLf3noKzgsPGcpzs/FsuHcpyeYxmPQGtBivU6z/s/Mtz1wqyMUNIK7MoNwxjIIedXDtKC9gbyYKd5uCb3LwSAa9j1mJJTVa4+Wl4H9yNpSX3IDL4pJ/sZHcpyYw2G59iiVOv5FQlzETIcevV+xq+JHFAGwVWmbpBxhcnVYnkFjrbC3t3Vg7RxjqMrs9JXfz5Q77v6GuKlyPWleNPY+pdt8oVU2HUY0k0g3Y1ea25TWsXISUyRj+jjzph73O+lcIphdnLZ22We/hBuJuFaEWTEh+TqEX5WCee7seOpXKjD1BgFHQg10ZU3hm2b2vkoOMF1Eo4F96jQUbjUM72HbJ2srGc4KMS6QAXZeAd9g71tgp3sNZGKzcb05c94SeEAFqbKrxrUcKF1FfWw3PQqiBXyurLWG53diWlxKxDl+Qy8Lv+Lq52evWFttgIVuegxCVyuuaGSjg4kWt1BR/JpOY8a3imKSeFagn1Jq/pBHTMTaeyoFrWDg0C15OoFcicNMxHWWXFDk+97KBS7mRqyGYzJZVc+3szLQjV7L9jtI9yr9FsVc5WnTJ//sshfBRkYTjnsJinXQCMRlXGQ0lmz48c4Ibyft8+aOuCgDiRQaAwCkT/QY3Yh/oOWjEj/9PrY9jhx0eN5Ih/l0BPefh/z8UIB7uMiRg5oscFJzoHxZY88sQRWtVWns5uZEJdLoUuJuR37q4fvWdkcwd43RQWF1rfLSXBDORiI0jpZoNCYal2oEfofmgWR+r
 o2owG3hB
 LNhld4359gIzQ4IVwW5aGG55XUZQX3lBF2IOllPHpn2jSPI35V3ou8/iJuYY+kIZLJdnX6M28IyjgvNPg5UFfSmOpGGNz+workE9UnIb1fdvaxatSSIKlWOslz/OPEECwwYF4y6lwFFtZ5tL69FnOhsn0gZpeozZ0CX3eNOePg9zdZjS45L+ygZJpeGxkxyZeLxwjYFt9Hy5owm/TEKsyUgaQ5IwWApA8XDrhcICkvXEjeaYHVoze5rv+Y0tv8dtDPyeaSGyidveRQ4bfZrX811vGpA6k5QuS0MwduJXM0IB6Rs7vmmd85DwCfKSR5OYbk/fQBAiNh2irx2kFzj/sjIeS9cPsYnOStT8nMhB9R0W8KTvz5Q54KsP5Ptn+Q+33pTcrswl9jOyQoDsi60rnLXElW/6eZx/vwfUg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 28, 2025 at 10:55:42AM -0700, Joanne Koong wrote:
> On Mon, Jul 28, 2025 at 10:34 AM Matthew Wilcox <willy@infradead.org> wrote:
> >
> > On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > > > > Also, I just noticed that apparently the blocksize can change
> > > > > > > dynamically for an inode in fuse through getattr replies from the
> > > > > > > server (see fuse_change_attributes_common()). This is a problem since
> > > > > > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > > > > > > think we will have to cache the inode blkbits in the iomap_folio_state
> > > > > > > struct unfortunately :( I'll think about this some more and send out a
> > > > > > > patch for this.
> >
> > Does this actually happen in practice, once you've started _using_ the
> > block device?  Rather than all this complicated stuff to invalidate the

For most block device filesystems?  No.  And as far as I can tell, none
of the filesystems actually support changing i_blkbits on the fly; I
think only block devices can do that:

$ git grep 'i_blkbits\s=\s'
block/bdev.c:150:       BD_INODE(bdev)->i_blkbits = blksize_bits(bsize);
block/bdev.c:209:               inode->i_blkbits = blksize_bits(size);
fs/ceph/inode.c:81:     inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
fs/ceph/inode.c:1071:           inode->i_blkbits = CEPH_FSCRYPT_BLOCK_SHIFT;
fs/ceph/inode.c:1076:           inode->i_blkbits = CEPH_BLOCK_SHIFT;
fs/ceph/inode.c:1180:           inode->i_blkbits = PAGE_SHIFT;
fs/direct-io.c:612:     unsigned int i_blkbits = sdio->blkbits + sdio->blkfactor;
fs/direct-io.c:908:     const unsigned i_blkbits = blkbits + sdio->blkfactor;
fs/direct-io.c:1110:    unsigned i_blkbits = READ_ONCE(inode->i_blkbits);
fs/erofs/fscache.c:527: inode->i_blkbits = EROFS_SB(sb)->blkszbits;
fs/fuse/file_iomap.c:2327:      inode->i_blkbits = new_blkbits;
fs/fuse/inode.c:304:            inode->i_blkbits = new_blkbits;
fs/inode.c:234: inode->i_blkbits = sb->s_blocksize_bits;
fs/libfs.c:1761:        inode->i_blkbits = PAGE_SHIFT;
fs/ocfs2/aops.c:2123:   unsigned int i_blkbits = inode->i_sb->s_blocksize_bits;
fs/orangefs/orangefs-utils.c:320:                       inode->i_blkbits = ffs(new_op->downcall.resp.getattr.
fs/smb/client/cifsfs.c:411:     cifs_inode->netfs.inode.i_blkbits = 14;  /* 2**14 = CIFS_MAX_MSGSIZE */
fs/stack.c:72:  dest->i_blkbits = src->i_blkbits;
fs/vboxsf/utils.c:123:  inode->i_blkbits = 12;

> > page cache based on the fuse server telling us something, maybe just
> > declare the server to be misbehaving and shut the whole filesystem down?
> >
> 
> I don't think this case is likely at all but I guess one scenario
> where the server might want to change the block size midway through is
> if they send the data to some network filesystem on the backend and if
> that backend shuts down or is at full capacity for whatever reason and
> they need to migrate to another backend that uses a different block
> size then I guess this would be useful for that.

Maybe, but it would still be pretty extraordinary to change the block
size on an open file -- any program that tries to do its IO in blocks
(i.e. not a byte stream) has already stat'd the file and will be very
confused.

> fuse currently does allow the block size to be changed dynamically so
> I'm not sure if we can change that behavior without breaking backwards
> compatibility.

<nod> For fuse+iomap I'm not going to allow it initially if there's
anything in the pagecache ... but I could be talked into it.

--D

