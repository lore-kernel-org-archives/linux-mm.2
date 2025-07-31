Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9744FC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 17:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170F96B007B; Thu, 31 Jul 2025 13:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121C56B0089; Thu, 31 Jul 2025 13:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037FA6B008A; Thu, 31 Jul 2025 13:55:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E83A46B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 13:55:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A04251609CB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:55:31 +0000 (UTC)
X-FDA: 83725312062.17.E6DD05A
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf03.hostedemail.com (Postfix) with ESMTP id EB60820017
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 17:55:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0wHEkWO;
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753984530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wVrijOVqXabiYrzUQhdzPJUGFhK5FALErjn8B1gY8U=;
	b=1YGH82fHgOEcsx8Wz0tvSp4vMkKYHcyef8EEBymWYF5vVQEzJy7vBA0bdozfPpTMBd/nV9
	XkhXiFGaNYIZ1BAR+zdrZt41oC3btN3knhvnTZwmP1IqYcl5rEw7xW4CiUWItyc0xSYukN
	GnAKBF94TF6D8Ih/8URvXn61RqpmE5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753984530; a=rsa-sha256;
	cv=none;
	b=TuQPtlBSpfIS59jkI3yqWqkqjo0e4CgP1s3oe29zCIoDAHJyAlH7+RIj/AxNTYc0GOADRi
	sYb397ueipOO5Il1eNcs2AmQkUSc3WXivGqG5H/AjMGkRg1rSlEgQvac916EldlZkKU4Vp
	7OXc+/sjrNzKya0Dd1yiehLj9KJwOCo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V0wHEkWO;
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 3AA19A5558E;
	Thu, 31 Jul 2025 17:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9EAC4CEEF;
	Thu, 31 Jul 2025 17:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753984528;
	bh=Z5UzNfgCvbQzqAOZgYLFcpqZt5sWTBYy/CuK+i39Cqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V0wHEkWO955rWC1W6YyU8XfGrfMcbzuflsMREyIZ385ngwBsP5c08d2X84I03d8wf
	 MJgrl6Tv2Y1QWzZgZd3DREvx4bKmVYholx3m8ZLUPTyq2tThvAAfdcY/z4elBErAI/
	 7GXXMYB20OO+GytFQBj8gCPhM5uuqd7u+fZ9+LZXiqX5ZSGFfrHwNCq/O4cJN523nf
	 w0moHsqlSuYcwkEAihIgMhdU9L4UZR3yV88bFFwTRLPjVtMPkySSZQ3+DcTXUSOVHN
	 p9UZ1r5B8nLRSnobosh9DrexkKKxoK/fz4YjlbaQNgEs/VUUr6C6c7/sifV8JaW03d
	 uW08miaSZ7QFA==
Date: Thu, 31 Jul 2025 10:55:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Message-ID: <20250731175528.GM2672070@frogsfrogsfrogs>
References: <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
 <20250728171425.GR2672029@frogsfrogsfrogs>
 <CAJnrk1bBesBijYRD1Wf_01OSBykJ0VzwFZKZFev0wPn9wYc98Q@mail.gmail.com>
 <20250728191117.GE2672070@frogsfrogsfrogs>
 <CAJnrk1bTgTcb4aUWqczXEH+7+SWQAdppxYbSAPNCVY6xXb-=hQ@mail.gmail.com>
 <20250729202151.GD2672049@frogsfrogsfrogs>
 <CAJnrk1ZXN40WEwKXn7ycy2topGTvxFh_UfsM_vwhM+0CtTsJKQ@mail.gmail.com>
 <20250729234018.GW2672029@frogsfrogsfrogs>
 <CAJnrk1b691Z3=_V0dU2Vb2qbiQd+0JUMj1ABDMip6vzzGZAf3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1b691Z3=_V0dU2Vb2qbiQd+0JUMj1ABDMip6vzzGZAf3w@mail.gmail.com>
X-Rspamd-Queue-Id: EB60820017
X-Stat-Signature: h9x4x3apg8im67i3grzwo5ixrcp1yunz
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753984529-995824
X-HE-Meta: U2FsdGVkX1/7GtJLIrao83ztwKDxg1ZWDMAwtrhdWp7qlPj8LCkbIEMHNyVZUln+GnY/Es1bOJgXWU5Ttrh0feLeAJyUtPHCPHpwsjERmj4jAPV3UuEz7oVPibHLIecFrd9iuv0k11Ab5IwoltvF0NEBeiRNqgSJdouGHf3DTDryRU4Je67IOTxsJj4o9Onk3IC+Fyu9PfTtdvQBu/Wkg3BaL4pEyJov+Bw5iHrICym+47RCtr+IByEcvVAuktnp0ZL8Y54eYW+VOSb0lA8UGZ6bO16kc/guI/v6nBAbcb45WskcNJhAehqAyevgcIxfnBK3ESw7oapk+L1qFsvXsSmh8ZBUzncoyYeA1UDldjTUMM7FvzANTdIGyRpEMEwsqVHuivK3q/AHq6Zt3LJBrpgmZNk4MosXVCdox62XtSt4807vbAhPdTnaqWsqZmIPCeHJjqowjjQl05hkpTqYGd9GOvKibDzXH4lwhGRI+2+iOopRbkyEE6dXiDNTqXuidYSdx5GFSj4O6zH8f+iCqO+d6NoNczpxQNsEblWfVkSo3be+rtOq9X/dyk7Is+6wPUJ1jjbucH5hajGH5/yLtEct3MqRkKGPbob4//1W9JfkCHyoZErl9o3kXH+iy3ZycnDYYbv5HdTKAs+W2G96NcW0pTdr4Z69xd0VFsxpWo30yWL9hBDJWazAnGN9qYx1OGPmJU/8bQssKG1mu4KwxvEDkS1hS+OyZhHcTv7px1C2R/98aYzI8n6FwmkHZnh3hF4kXjHZHE4blxXIs5MqcSSAD7BeXCyBCS6g+UJyIoTWEwuFBX8V7jzb7Ix/sksBgRG/FQmIPqcB2oSQli+tX0j4GB5pgz51zTbQzZ4KoNifjjrEQbcdZnJhVAmEN6PfAzruwFIx+DBwhHgn+rHqwb2YH0ebXS6XVNGc/aS+Fl3vuQYK/6hLi9yadoiP/l2wteJZ9s5mKyoNwI0zqse
 xoEPHIxR
 Mj14OdernmminqMrFRYAuVSSJxGOOa2oUOw5cTPXPBZi/YS70MGJcZ/+w75pbdnTLwe3UulhDXVKT6XX5hZtdoEcRgRgmRCQ5dKs3VR/uv4yHqQYfHeR6chzzY8AoC3JLmXGwYowcu83qzoJ9aV+7LooDlcDt40zljMuY6iDL9SmUUGJ8D4S0ZNuAqEA/AC0zVP9WCkat1xeikyiBrSrluQDenajKy2f794vYruJywY0uDA2yUm/BGETj2GZd/9PztUZKxRltMiHeJlC9abMf3vdSjx/IgTigxreNjF8qrPDFCJPTvhNqDMOBOdzkupNaI6WAka71YqeJqPldtq31Ta7qm3+7LBg+gfAELEyEbhpIYksL2vby9OH4a7NdOwTz0Q/nsOxd0180Tndiz2y2xKNqbOaC2wOwPK14m+7b1GlQsxPvQKHwSMiRudQbsUf4nK6IHXZHDtRzmXU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 30, 2025 at 03:54:15PM -0700, Joanne Koong wrote:
> On Tue, Jul 29, 2025 at 4:40 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Jul 29, 2025 at 04:23:02PM -0700, Joanne Koong wrote:
> > > On Tue, Jul 29, 2025 at 1:21 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Mon, Jul 28, 2025 at 02:28:31PM -0700, Joanne Koong wrote:
> > > > > On Mon, Jul 28, 2025 at 12:11 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > >
> > > > > > On Mon, Jul 28, 2025 at 10:44:01AM -0700, Joanne Koong wrote:
> > > > > > > On Mon, Jul 28, 2025 at 10:14 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > > >
> > > > > > > > On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> > > > > > > > > On Thu, Jul 24, 2025 at 12:14 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > > > > > > >
> > > > > > > > > > On Wed, Jul 23, 2025 at 3:37 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > > > > > > > >
> > > > > > > > > > > On Wed, Jul 23, 2025 at 2:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > > > > > > >
> > > > > > > > > > > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > > > > > > > > > > > On Wed, Jul 23, 2025 at 7:46 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > [cc Joanne]
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > > > > > > > > > > > > > Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
> > > > > > > > > > > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > > > > > > > > > > > >
> > > > > > > > > > > > > > > ## Test log
> > > > > > > > > > > > > > > ------------[ cut here ]------------
> > > > > > > > > > > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > > > > > > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
> > > > > > > > > > > > > >
> > > > > > > > > > > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > > > > > > > > > > >
> > > > > > > > > > > > > > /me speculates that this might be triggered by an attempt to write back
> > > > > > > > > > > > > > some 4k fsblock within a 16/64k base page?
> > > > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > I think this can happen on 4k base pages as well actually. On the
> > > > > > > > > > > > > iomap side, the length passed is always block-aligned and in fuse, we
> > > > > > > > > > > > > set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
> > > > > > > > > > > > > page-aligned, but I missed that if it's a "fuseblk" filesystem, that
> > > > > > > > > > > > > isn't true and the blocksize is initialized to a default size of 512
> > > > > > > > > > > > > or whatever block size is passed in when it's mounted.
> > > > > > > > > > > >
> > > > > > > > > > > > <nod> I think you're correct.
> > > > > > > > > > > >
> > > > > > > > > > > > > I'll send out a patch to remove this line. It doesn't make any
> > > > > > > > > > > > > difference for fuse_iomap_writeback_range() logic whether len is
> > > > > > > > > > > > > page-aligned or not; I had added it as a sanity-check against sketchy
> > > > > > > > > > > > > ranges.
> > > > > > > > > > > > >
> > > > > > > > > > > > > Also, I just noticed that apparently the blocksize can change
> > > > > > > > > > > > > dynamically for an inode in fuse through getattr replies from the
> > > > > > > > > > > > > server (see fuse_change_attributes_common()). This is a problem since
> > > > > > > > > > > > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > > > > > > > > > > > > think we will have to cache the inode blkbits in the iomap_folio_state
> > > > > > > > > > > > > struct unfortunately :( I'll think about this some more and send out a
> > > > > > > > > > > > > patch for this.
> > > > > > > > > > > >
> > > > > > > > > > > > From my understanding of the iomap code, it's possible to do that if you
> > > > > > > > > > > > flush and unmap the entire pagecache (whilst holding i_rwsem and
> > > > > > > > > > > > mmap_invalidate_lock) before you change i_blkbits.  Nobody *does* this
> > > > > > > > > > > > so I have no idea if it actually works, however.  Note that even I don't
> > > > > > > > > > > > implement the flush and unmap bit; I just scream loudly and do nothing:
> > > > > > > > > > >
> > > > > > > > > > > lol! i wish I could scream loudly and do nothing too for my case.
> > > > > > > > > > >
> > > > > > > > > > > AFAICT, I think I just need to flush and unmap that file and can leave
> > > > > > > > > > > the rest of the files/folios in the pagecache as is? But then if the
> > > > > > > > > > > file has active refcounts on it or has been pinned into memory, can I
> > > > > > > > > > > still unmap and remove it from the page cache? I see the
> > > > > > > > > > > invalidate_inode_pages2() function but my understanding is that the
> > > > > > > > > > > page still stays in the cache if it has has active references, and if
> > > > > > > > > > > the page gets mmaped and there's a page fault on it, it'll end up
> > > > > > > > > > > using the preexisting old page in the page cache.
> > > > > > > > > >
> > > > > > > > > > Never mind, I was mistaken about this. Johannes confirmed that even if
> > > > > > > > > > there's active refcounts on the folio, it'll still get removed from
> > > > > > > > > > the page cache after unmapping and the page cache reference will get
> > > > > > > > > > dropped.
> > > > > > > > > >
> > > > > > > > > > I think I can just do what you suggested and call
> > > > > > > > > > filemap_invalidate_inode() in fuse_change_attributes_common() then if
> > > > > > > > > > the inode blksize gets changed. Thanks for the suggestion!
> > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Thinking about this some more, I don't think this works after all
> > > > > > > > > because the writeback + page cache removal and inode blkbits update
> > > > > > > > > needs to be atomic, else after we write back and remove the pages from
> > > > > > > > > the page cache, a write could be issued right before we update the
> > > > > > > > > inode blkbits. I don't think we can hold the inode lock the whole time
> > > > > > > > > for it either since writeback could be intensive. (also btw, I
> > > > > > > > > realized in hindsight that invalidate_inode_pages2_range() would have
> > > > > > > > > been the better function to call instead of
> > > > > > > > > filemap_invalidate_inode()).
> > > > > > > > >
> > > > > > > > > > >
> > > > > > > > > > > I don't think I really need to have it removed from the page cache so
> > > > > > > > > > > much as just have the ifs state for all the folios in the file freed
> > > > > > > > > > > (after flushing the file) so that it can start over with a new ifs.
> > > > > > > > > > > Ideally we could just flush the file, then iterate through all the
> > > > > > > > > > > folios in the mapping in order of ascending index, and kfree their
> > > > > > > > > > > ->private, but I'm not seeing how we can prevent the case of new
> > > > > > > > > > > writes / a new ifs getting allocated for folios at previous indexes
> > > > > > > > > > > while we're trying to do the iteration/kfreeing.
> > > > > > > > > > >
> > > > > > > > >
> > > > > > > > > Going back to this idea, I think this can work. I realized we don't
> > > > > > > > > need to flush the file, it's enough to free the ifs, then update the
> > > > > > > > > inode->i_blkbits, then reallocate the ifs (which will now use the
> > > > > > > > > updated blkbits size), and if we hold the inode lock throughout, that
> > > > > > > > > prevents any concurrent writes.
> > > > > > > > > Something like:
> > > > > > > > >      inode_lock(inode);
> > > > > > > > >      XA_STATE(xas, &mapping->i_pages, 0);
> > > > > > > > >      xa_lock_irq(&mapping->i_pages);
> > > > > > > > >      xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
> > > > > > > > >           folio_lock(folio);
> > > > > > > > >           if (folio_test_dirty(folio)) {
> > > > > > > > >                   folio_wait_writeback(folio);
> > > > > > > > >                   kfree(folio->private);
> > > > > > > > >           }
> > > > > >
> > > > > > Heh, I didn't even see this chunk, distracted as I am today. :/
> > > > > >
> > > > > > So this doesn't actually /initiate/ writeback, it just waits
> > > > > > (potentially for a long time) for someone else to come along and do it.
> > > > > > That might not be what you want since the blocksize change will appear
> > > > > > to stall while nothing else is going on in the system.
> > > > >
> > > > > I thought if the folio isn't under writeback then
> > > > > folio_wait_writeback() just returns immediately as a no-op.
> > > > > I don't think we need/want to initiate writeback, I think we only need
> > > > > to ensure that if it is already under writeback, that writeback
> > > > > finishes while it uses the old i_blksize so nothing gets corrupted. As
> > > > > I understand it (but maybe I'm misjudging this), holding the inode
> > > > > lock and then initiating writeback is too much given that writeback
> > > > > can take a long time (eg if the fuse server writes the data over some
> > > > > network).
> > > > >
> > > > > >
> > > > > > Also, unless you're going to put this in buffered-io.c, it's not
> > > > > > desirable for a piece of code to free something it didn't allocate.
> > > > > > IOWs, I don't think it's a good idea for *fuse* to go messing with a
> > > > > > folio->private that iomap set.
> > > > >
> > > > > Okay, good point. I agree. I was hoping to have this not bleed into
> > > > > the iomap library but maybe there's no getting around that in a good
> > > > > way.
> > > >
> > > > <shrug> Any other filesystem that has mutable file block size is going
> > > > to need something to enact a change.
> > > >
> > > > > >
> > > > > > > > >           folio_unlock(folio);
> > > > > > > > >      }
> > > > > > > > >     inode->i_blkbits = new_blkbits_size;
> > > > > > > >
> > > > > > > > The trouble is, you also have to resize the iomap_folio_state objects
> > > > > > > > attached to each folio if you change i_blkbits...
> > > > > > >
> > > > > > > I think the iomap_folio_state objects automatically get resized here,
> > > > > > > no? We first kfree the folio->private which kfrees the entire ifs,
> > > > > >
> > > > > > Err, right, it does free the ifs and recreate it later if necessary.
> > > > > >
> > > > > > > then we change inode->i_blkbits to the new size, then when we call
> > > > > > > folio_mark_dirty(), it'll create the new ifs which creates a new folio
> > > > > > > state object using the new/updated i_blkbits size
> > > > > > >
> > > > > > > >
> > > > > > > > >     xas_set(&xas, 0);
> > > > > > > > >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
> > > > > > > > >           folio_lock(folio);
> > > > > > > > >           if (folio_test_dirty(folio) && !folio_test_writeback(folio))
> > > > > > > > >                  folio_mark_dirty(folio);
> > > > > > > >
> > > > > > > > ...because iomap_dirty_folio doesn't know how to reallocate the folio
> > > > > > > > state object in response to i_blkbits having changed.
> > > > > >
> > > > > > Also, what about clean folios that have an ifs?  You'd still need to
> > > > > > handle the ifs's attached to those.
> > > > >
> > > > > Ah you're right, there could be clean folios there too that have an
> > > > > ifs. I think in the above logic, if we iterate through all
> > > > > mapping->i_pages (not just PAGECACHE_TAG_DIRTY marked ones) and move
> > > > > the kfree to after the "if (folio_test_dirty(folio))" block, then it
> > > > > addresses that case. eg something like this:
> > > > >
> > > > >      inode_lock(inode);
> > > > >      XA_STATE(xas, &mapping->i_pages, 0);
> > > > >      xa_lock_irq(&mapping->i_pages);
> > > > >      xas_for_each(&xas, folio, ULONG_MAX) {
> > > > >           folio_lock(folio);
> > > > >           if (folio_test_dirty(folio))
> > > > >                   folio_wait_writeback(folio);
> > > > >           kfree(folio->private);
> > > > >           folio_unlock(folio);
> > > > >      }
> > > > >     inode->i_blkbits = new_blkbits;
> > > > >     xas_set(&xas, 0);
> > > > >     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
> > > > >           folio_lock(folio);
> > > > >           if (folio_test_dirty(folio) && !folio_test_writeback(folio))
> > > > >                  folio_mark_dirty(folio);
> > > > >           folio_unlock(folio);
> > > > >     }
> > > > >     xa_unlock_irq(&mapping->i_pages);
> > > > >     inode_unlock(inode);
> > > > >
> > > > >
> > > > > >
> > > > > > So I guess if you wanted iomap to handle a blocksize change, you could
> > > > > > do something like:
> > > > > >
> > > > > > iomap_change_file_blocksize(inode, new_blkbits) {
> > > > > >         inode_lock()
> > > > > >         filemap_invalidate_lock()
> > > > > >
> > > > > >         inode_dio_wait()
> > > > > >         filemap_write_and_wait()
> > > > > >         if (new_blkbits > mapping_min_folio_order()) {
> > > > > >                 truncate_pagecache()
> > > > > >                 inode->i_blkbits = new_blkbits;
> > > > > >         } else {
> > > > > >                 inode->i_blkbits = new_blkbits;
> > > > > >                 xas_for_each(...) {
> > > > > >                         <create new ifs>
> > > > > >                         <translate uptodate/dirty state to new ifs>
> > > > > >                         <swap ifs>
> > > > > >                         <free old ifs>
> > > > > >                 }
> > > > > >         }
> > > > > >
> > > > > >         filemap_invalidate_unlock()
> > > > > >         inode_unlock()
> > > > > > }
> > > > >
> > > > > Do you prefer this logic to the one above that walks through
> > > > > &mapping->i_pages? If so, then I'll go with this way.
> > > >
> > > > Yes.  iomap should not be tightly bound to the pagecache's xarray; I
> > > > don't even really like the xas_for_each that I suggested above.
> > >
> > > Okay, sounds good.
> > >
> > > >
> > > > > The part I'm unsure about is that this logic seems more disruptive (eg
> > > > > initiating writeback while holding the inode lock and doing work for
> > > > > unmapping/page cache removal) than the other approach, but I guess
> > > > > this is also rare enough that it doesn't matter much.
> > > >
> > > > I hope it's rare enough that doing truncate_pagecache unconditionally
> > > > won't be seen as a huge burden.
> > > >
> > > > iomap_change_file_blocksize(inode, new_blkbits) {
> > > >         inode_dio_wait()
> > > >         filemap_write_and_wait()
> > > >         truncate_pagecache()
> > > >
> > > >         inode->i_blkbits = new_blkbits;
> > > > }
> > > >
> > > > fuse_file_change_blocksize(inode, new_blkbits) {
> > > >         inode_lock()
> > > >         filemap_invalidate_lock()
> > > >
> > > >         iomap_change_file_blocksize(inode, new_blkbits);
> > > >
> > > >         filemap_invalidate_unlock()
> > > >         inode_unlock()
> > > > }
> > > >
> > > > Though my question remains -- is there a fuse filesystem that changes
> > > > the blocksize at runtime such that we can test this??
> > >
> > > There's not one currently but I was planning to hack up the libfuse
> > > passthrough_hp server to test the change.
> >
> > Heh, ok.
> >
> > I guess I could also hack up fuse2fs to change its own blocksize
> > randomly to see how many programs that pisses off. :)
> >
> > (Not right now though, gotta prepare for fossy tomorrow...)
> >
> 
> What I've been using as a helpful sanity-check so far has been running
> fstests generic/750 after adding this line to libfuse:
> 
> +++ b/lib/fuse_lowlevel.c
> @@ -547,6 +547,8 @@ int fuse_reply_attr(fuse_req_t req, const struct stat *attr,
>         arg.attr_valid_nsec = calc_timeout_nsec(attr_timeout);
>         convert_stat(attr, &arg.attr);
> +       arg.attr.blksize = 4096;
>         return send_reply_ok(req, &arg, size);
> 
> and modifying the kernel side logic in fuse_change_attributes_common()
> to unconditionally execute the page cache removal logic if
> attr->blksize != 0.
> 
> 
> While running this however, I discovered another problem :/ we can't
> grab the inode lock here in the fuse path because the vfs layer that
> calls into this logic may already be holding the inode lock (eg the
> stack traces I was seeing included path_openat()  ->
> inode_permission() -> fuse_permission() which then fetches the
> blksize, and the vfs rename path), while there are other call paths
> that may not be holding the lock already.

Oh nooooo heisenlocking.  Which paths do not hold i_rwsem?

> I don't really see a good solution here. The simplest one imo would be
> to cache "u8 blkbits" in the iomap_folio_state struct - are you okay
> with that or do you think there's a better solution here?

1. Don't support changing the blocksize, complain loudly if anyone does,
and only then implement it.  Writeback cache is a fairly new feature so
the impact should be low, right? ;)

[there is no 2 :D]

--D

> 
> Thanks,
> Joanne
> 
> > --D
> >
> > > >
> > > > --D
> > > >
> > > > > Thanks,
> > > > > Joanne
> > > > >
> > > > > >
> > > > > > --D
> > > > > >
> > > > > > > > --D
> > > > > > > >
> > > > > > > > >           folio_unlock(folio);
> > > > > > > > >     }
> > > > > > > > >     xa_unlock_irq(&mapping->i_pages);
> > > > > > > > >     inode_unlock(inode);
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > I think this is the only approach that doesn't require changes to iomap.
> > > > > > > > >
> > > > > > > > > I'm going to think about this some more next week and will try to send
> > > > > > > > > out a patch for this then.
> > > > > > > > >
> > > > > > > > >
> > > > > > > > > Thanks,
> > > > > > > > > Joanne
> > > > > > > > >
> > > > > > > > > > > >
> > > > > > > > > > > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits)
> > > > > > > > > > > > {
> > > > > > > > > > > >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> > > > > > > > > > > >
> > > > > > > > > > > >         if (inode->i_blkbits == new_blkbits)
> > > > > > > > > > > >                 return;
> > > > > > > > > > > >
> > > > > > > > > > > >         if (!S_ISREG(inode->i_mode))
> > > > > > > > > > > >                 goto set_it;
> > > > > > > > > > > >
> > > > > > > > > > > >         /*
> > > > > > > > > > > >          * iomap attaches per-block state to each folio, so we cannot allow
> > > > > > > > > > > >          * the file block size to change if there's anything in the page cache.
> > > > > > > > > > > >          * In theory, fuse servers should never be doing this.
> > > > > > > > > > > >          */
> > > > > > > > > > > >         if (inode->i_mapping->nrpages > 0) {
> > > > > > > > > > > >                 WARN_ON(inode->i_blkbits != new_blkbits &&
> > > > > > > > > > > >                         inode->i_mapping->nrpages > 0);
> > > > > > > > > > > >                 return;
> > > > > > > > > > > >         }
> > > > > > > > > > > >
> > > > > > > > > > > > set_it:
> > > > > > > > > > > >         inode->i_blkbits = new_blkbits;
> > > > > > > > > > > > }
> > > > > > > > > > > >
> > > > > > > > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=fuse-iomap-attrs&id=da9b25d994c1140aae2f5ebf10e54d0872f5c884
> > > > > > > > > > > >
> > > > > > > > > > > > --D
> > > > > > > > > > > >
> > > > > > > > > > > > >
> > > > > > > > > > > > > Thanks,
> > > > > > > > > > > > > Joanne
> > > > > > > > > > > > >
> > > > > > > > >
> > > > >
> > >

