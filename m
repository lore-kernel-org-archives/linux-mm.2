Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6F5C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 17:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5592C6B008A; Mon, 28 Jul 2025 13:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 531546B008C; Mon, 28 Jul 2025 13:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 472DA6B0092; Mon, 28 Jul 2025 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 380E16B008A
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:14:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 730E01A0380
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:14:28 +0000 (UTC)
X-FDA: 83714322216.19.18E3CA0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD857C0012
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 17:14:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sjgNLLpH;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753722866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hEg9stipqyHXcE3ATPZMJrOYedjqzkwWSN3XQuzPL/Q=;
	b=CIHTUwvDKihI3ZgNgcjfunCaHL4sNAPySM+jGZUM0cdHpItrSXU+uO/LVWbDWzSv9h2VDU
	rxLIELV+h3phKGvzOFBnnYkr1fPDcD8vXNprJguGKywWLfu09Te7j7Z+qFKyZUX7y4qvX0
	KdgFmYCK3MfCweq/+NzWIG1X5gb4gqw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sjgNLLpH;
	spf=pass (imf10.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753722866; a=rsa-sha256;
	cv=none;
	b=tP238gm9BZD32yjJX9hRRTHHvFxt6zUsS1UryscVGHZ915F68DgEgFIEK93Wtdq9F2eJBw
	f4/dFCYXb5+CkYzPpHcozHpA5MmWJ5sRSHQ+bBr/IM511HUHi5CAx9QN9JVMIpx4Kx0CAK
	qM8h6MX26t/1fgupNtpOBPP4NGhnR2I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 07BF9601FB;
	Mon, 28 Jul 2025 17:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4FE4C4CEF7;
	Mon, 28 Jul 2025 17:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753722865;
	bh=ShS6WZQge780shaKIIz7KkjUpx+cF0xBwdgZKYy9OdI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sjgNLLpH6URyHHPD/ay/v4Krp41qbfpFo1HGb6ethrvAEU3dKj0Z3H+UQaO/vZUpN
	 c7PtAFK4Ozux7kcSJIodKzHjPZMIeC7SG5mZoxG6M9HrOR1aA4OuCEhk9TYxZfV/cC
	 BKAN0sfMT4Zmxpep6xH92usKWGcJOoMz9UwRuSbZlgofRX1csq76jAWTPbLYeH3vbm
	 6JvzdvOp5f5aKBTHAgwolC/ZVS44Xw+kp7BEysDLwwCkO03UZznK+DKcZrrM6KNupS
	 vbsYEKY+aaOxjhQtFOBIywOFDridM8SJlFSwdizBH0phYTtVseRQDsgW5Ex1CmH7Au
	 Io7pc9+ohXafQ==
Date: Mon, 28 Jul 2025 10:14:25 -0700
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
Message-ID: <20250728171425.GR2672029@frogsfrogsfrogs>
References: <CA+G9fYs5AdVM-T2Tf3LciNCwLZEHetcnSkHsjZajVwwpM2HmJw@mail.gmail.com>
 <20250723144637.GW2672070@frogsfrogsfrogs>
 <CAJnrk1Z7wcB8uKWcrAuRAZ8B-f8SKnOuwtEr-=cHa+ApR_sgXQ@mail.gmail.com>
 <20250723212020.GY2672070@frogsfrogsfrogs>
 <CAJnrk1bFWRTGnpNhW_9MwSYZw3qPnPXZBeiwtPSrMhCvb9C3qg@mail.gmail.com>
 <CAJnrk1byTVJtuOyAyZSVYrusjhA-bW6pxBOQQopgHHbD3cDUHw@mail.gmail.com>
 <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1ZYR=hM5k90H57tOv=fe6F-r8dO+f3wNuCT_w3j8YNYNQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: AD857C0012
X-Rspamd-Server: rspam06
X-Stat-Signature: 6fktwzgt3mt9h5qwaxnshwus5aiqfbnx
X-HE-Tag: 1753722866-275636
X-HE-Meta: U2FsdGVkX19I6hZEhP2VoflnGtuafnh4YKFnifOYBF2RSq9oWy1+fO96+HMZuKCZGmCupmMb0XkGlITa4cRtvTMc95PrT4TwVpu89z+9b4BKuYn+4j6fdKX2Rvxxr2oGJrghle3RShd+ORSOrxGdTBbpciYZOQwLCjVJ9em+pKOmf35/7uLKJkHns8IV7eWDWs/vaC/wzmChVmfey0Dp2w9GEV3wBbDcsEdpomhyCV4hetO6uQJwT+KubXPiCrhpCq0GkrQ8R7/AwNZwLkdeJKD636BEC2tcFVfLrpUuK88amkNjgTMFyGXOcdWqthmbEqoThTByfU0qqlG7PK8bhGOEmR2OByfYeJEvizwGFATA/RG8nMe76lDQVdTXsYu3RrXj/fpkE6gzic0B5iv5z7LR7Wgo1515IqoAiSFHXzUSri47oegGcqVp8QnYNkXKm0+2um+P8zFudvUmno42NqJfWo8ciCAL5eNvjNKmA+eX2HHJGCFX/rsGFu79i2VZed4R7cB+5CahInAZDB5fBoeTeqw5+9JUlMjApoUWpzxc71hs/R2NDwlvkasmdIYMFgbm3PlUgbAGoLaPvvlvpaB6jDBWqcQHe2eDDfajkefN7PVHkckIiAlkcOd2IE+RkhzdrEjukrKr/A2ZpFYC1yCDhSsHowGF7vNEEMxnYXXEylbynSUkEwVxJWvEs4D1449+ZISmhK/WVxBVxqGzFuqrecxZMPGXJym2CIgOsnHi036uImSHrDn6oSSV+1AgAkVMqpIWsZWAfVf+GIY1ddBgLQGOcFhBQSUvXw7hvuFZVEK1hXU837BK+k1kiJbgvWlfO4QXxvQ1QS8aN5sQFty+2jUWuP1CLdiBDzQS9T3YSisGWbf1Ftx34/TJ8doSs94l61VJayGnEUJvb+WvGjiW6SWUyFhX6Zrvu5AO76lYXsYgPHcfuLtrHT2/5ViibH0rJh2DCyokj8894JY
 UDrv8J2F
 ogBV3P1zIa/uZut3aXXXVHwNLelok+vPITkcihZehua+OuRfs59Qa8sFmv15l/F+494MBjNE1NF8X61H5tedH2aDUY714oHx6rVv1g81pVjKeG2GPo5/WvMUAtc3DSBAwkVzQy9GAMwPn02MqAPCSyify4qQi6y77cUdLMYyn+sLW5+fns7vZV2IWcUKCBr8dgdBPnGehUUa8It+AVINocynsoWmTVEfkq3Qc8Rb0S2mmhVuZwTPmDRGKEREudwlLG6uhe0nPYOa/xLo/NTG9nvl/vB4Jhz1wll23dKAxKOY0nElZYfJQCA5HzmIHSzPeb4/QcI0othrKuIDIvJt+dsXTO+9+ywQ9jB6iMsn36MR0tLrVtl4dIVJ3LS0Rnaiq5cf/he+Jfvr2aVdtPKlLWHS53BBjhBi99Shlt9E1wmLIiE/2iIg6gROWGB3laTDT6HfE8hufJKO21HU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 06:16:15PM -0700, Joanne Koong wrote:
> On Thu, Jul 24, 2025 at 12:14 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> >
> > On Wed, Jul 23, 2025 at 3:37 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > >
> > > On Wed, Jul 23, 2025 at 2:20 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > >
> > > > On Wed, Jul 23, 2025 at 11:42:42AM -0700, Joanne Koong wrote:
> > > > > On Wed, Jul 23, 2025 at 7:46 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > >
> > > > > > [cc Joanne]
> > > > > >
> > > > > > On Wed, Jul 23, 2025 at 05:14:28PM +0530, Naresh Kamboju wrote:
> > > > > > > Regressions found while running LTP msync04 tests on qemu-arm64 running
> > > > > > > Linux next-20250721, next-20250722 and next-20250723 with 16K and 64K
> > > > > > > page size enabled builds.
> > > > > > >
> > > > > > > CONFIG_ARM64_64K_PAGES=y ( kernel warning as below )
> > > > > > > CONFIG_ARM64_16K_PAGES=y ( kernel warning as below )
> > > > > > >
> > > > > > > No warning noticed with 4K page size.
> > > > > > > CONFIG_ARM64_4K_PAGES=y works as expected
> > > > > >
> > > > > > You might want to cc Joanne since she's been working on large folio
> > > > > > support in fuse.
> > > > > >
> > > > > > > First seen on the tag next-20250721.
> > > > > > > Good: next-20250718
> > > > > > > Bad:  next-20250721 to next-20250723
> > > > >
> > > > > Thanks for the report. Is there a link to the script that mounts the
> > > > > fuse server for these tests? I'm curious whether this was mounted as a
> > > > > fuseblk filesystem.
> > > > >
> > > > > > >
> > > > > > > Regression Analysis:
> > > > > > > - New regression? Yes
> > > > > > > - Reproducibility? Yes
> > > > > > >
> > > > > > > Test regression: next-20250721 arm64 16K and 64K page size WARNING fs
> > > > > > > fuse file.c at fuse_iomap_writeback_range
> > > > > > >
> > > > > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > > > > >
> > > > > > > ## Test log
> > > > > > > ------------[ cut here ]------------
> > > > > > > [  343.828105] WARNING: fs/fuse/file.c:2146 at
> > > > > > > fuse_iomap_writeback_range+0x478/0x558 [fuse], CPU#0: msync04/4190
> > > > > >
> > > > > >         WARN_ON_ONCE(len & (PAGE_SIZE - 1));
> > > > > >
> > > > > > /me speculates that this might be triggered by an attempt to write back
> > > > > > some 4k fsblock within a 16/64k base page?
> > > > > >
> > > > >
> > > > > I think this can happen on 4k base pages as well actually. On the
> > > > > iomap side, the length passed is always block-aligned and in fuse, we
> > > > > set blkbits to be PAGE_SHIFT so theoretically block-aligned is always
> > > > > page-aligned, but I missed that if it's a "fuseblk" filesystem, that
> > > > > isn't true and the blocksize is initialized to a default size of 512
> > > > > or whatever block size is passed in when it's mounted.
> > > >
> > > > <nod> I think you're correct.
> > > >
> > > > > I'll send out a patch to remove this line. It doesn't make any
> > > > > difference for fuse_iomap_writeback_range() logic whether len is
> > > > > page-aligned or not; I had added it as a sanity-check against sketchy
> > > > > ranges.
> > > > >
> > > > > Also, I just noticed that apparently the blocksize can change
> > > > > dynamically for an inode in fuse through getattr replies from the
> > > > > server (see fuse_change_attributes_common()). This is a problem since
> > > > > the iomap uses inode->i_blkbits for reading/writing to the bitmap. I
> > > > > think we will have to cache the inode blkbits in the iomap_folio_state
> > > > > struct unfortunately :( I'll think about this some more and send out a
> > > > > patch for this.
> > > >
> > > > From my understanding of the iomap code, it's possible to do that if you
> > > > flush and unmap the entire pagecache (whilst holding i_rwsem and
> > > > mmap_invalidate_lock) before you change i_blkbits.  Nobody *does* this
> > > > so I have no idea if it actually works, however.  Note that even I don't
> > > > implement the flush and unmap bit; I just scream loudly and do nothing:
> > >
> > > lol! i wish I could scream loudly and do nothing too for my case.
> > >
> > > AFAICT, I think I just need to flush and unmap that file and can leave
> > > the rest of the files/folios in the pagecache as is? But then if the
> > > file has active refcounts on it or has been pinned into memory, can I
> > > still unmap and remove it from the page cache? I see the
> > > invalidate_inode_pages2() function but my understanding is that the
> > > page still stays in the cache if it has has active references, and if
> > > the page gets mmaped and there's a page fault on it, it'll end up
> > > using the preexisting old page in the page cache.
> >
> > Never mind, I was mistaken about this. Johannes confirmed that even if
> > there's active refcounts on the folio, it'll still get removed from
> > the page cache after unmapping and the page cache reference will get
> > dropped.
> >
> > I think I can just do what you suggested and call
> > filemap_invalidate_inode() in fuse_change_attributes_common() then if
> > the inode blksize gets changed. Thanks for the suggestion!
> >
> 
> Thinking about this some more, I don't think this works after all
> because the writeback + page cache removal and inode blkbits update
> needs to be atomic, else after we write back and remove the pages from
> the page cache, a write could be issued right before we update the
> inode blkbits. I don't think we can hold the inode lock the whole time
> for it either since writeback could be intensive. (also btw, I
> realized in hindsight that invalidate_inode_pages2_range() would have
> been the better function to call instead of
> filemap_invalidate_inode()).
> 
> > >
> > > I don't think I really need to have it removed from the page cache so
> > > much as just have the ifs state for all the folios in the file freed
> > > (after flushing the file) so that it can start over with a new ifs.
> > > Ideally we could just flush the file, then iterate through all the
> > > folios in the mapping in order of ascending index, and kfree their
> > > ->private, but I'm not seeing how we can prevent the case of new
> > > writes / a new ifs getting allocated for folios at previous indexes
> > > while we're trying to do the iteration/kfreeing.
> > >
> 
> Going back to this idea, I think this can work. I realized we don't
> need to flush the file, it's enough to free the ifs, then update the
> inode->i_blkbits, then reallocate the ifs (which will now use the
> updated blkbits size), and if we hold the inode lock throughout, that
> prevents any concurrent writes.
> Something like:
>      inode_lock(inode);
>      XA_STATE(xas, &mapping->i_pages, 0);
>      xa_lock_irq(&mapping->i_pages);
>      xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
>           folio_lock(folio);
>           if (folio_test_dirty(folio)) {
>                   folio_wait_writeback(folio);
>                   kfree(folio->private);
>           }
>           folio_unlock(folio);
>      }
>     inode->i_blkbits = new_blkbits_size;

The trouble is, you also have to resize the iomap_folio_state objects
attached to each folio if you change i_blkbits...

>     xas_set(&xas, 0);
>     xas_for_each_marked(&xas, folio, ULONG_MAX, PAGECACHE_TAG_DIRTY) {
>           folio_lock(folio);
>           if (folio_test_dirty(folio) && !folio_test_writeback(folio))
>                  folio_mark_dirty(folio);

...because iomap_dirty_folio doesn't know how to reallocate the folio
state object in response to i_blkbits having changed.

--D

>           folio_unlock(folio);
>     }
>     xa_unlock_irq(&mapping->i_pages);
>     inode_unlock(inode);
> 
> 
> I think this is the only approach that doesn't require changes to iomap.
> 
> I'm going to think about this some more next week and will try to send
> out a patch for this then.
> 
> 
> Thanks,
> Joanne
> 
> > > >
> > > > void fuse_iomap_set_i_blkbits(struct inode *inode, u8 new_blkbits)
> > > > {
> > > >         trace_fuse_iomap_set_i_blkbits(inode, new_blkbits);
> > > >
> > > >         if (inode->i_blkbits == new_blkbits)
> > > >                 return;
> > > >
> > > >         if (!S_ISREG(inode->i_mode))
> > > >                 goto set_it;
> > > >
> > > >         /*
> > > >          * iomap attaches per-block state to each folio, so we cannot allow
> > > >          * the file block size to change if there's anything in the page cache.
> > > >          * In theory, fuse servers should never be doing this.
> > > >          */
> > > >         if (inode->i_mapping->nrpages > 0) {
> > > >                 WARN_ON(inode->i_blkbits != new_blkbits &&
> > > >                         inode->i_mapping->nrpages > 0);
> > > >                 return;
> > > >         }
> > > >
> > > > set_it:
> > > >         inode->i_blkbits = new_blkbits;
> > > > }
> > > >
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/commit/?h=fuse-iomap-attrs&id=da9b25d994c1140aae2f5ebf10e54d0872f5c884
> > > >
> > > > --D
> > > >
> > > > >
> > > > > Thanks,
> > > > > Joanne
> > > > >
> 

