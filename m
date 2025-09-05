Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07F96CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 12:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492198E0010; Fri,  5 Sep 2025 08:43:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443338E0001; Fri,  5 Sep 2025 08:43:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 331B08E0010; Fri,  5 Sep 2025 08:43:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 198AE8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 08:43:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79F3160189
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:43:07 +0000 (UTC)
X-FDA: 83855161614.18.C73FEB6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 44EDF80003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 12:43:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KysnkI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KFbx6kpV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KysnkI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KFbx6kpV;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757076185; a=rsa-sha256;
	cv=none;
	b=a3p53BJBuAGHxLwToGF31DBgFUdVx8hNkQyA1Snqjg31gixMK65d1EQYDSUK8IoCj966+L
	ABuIa5NXSfg4EVsGMUCgzMZ8126ALxBJF74bB2EV1hOK7FkAU8RkugJJHCTVU80Kq2U1nJ
	JouV6yKCkEgfbGL2P/SgQ3oXE42pp4A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KysnkI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KFbx6kpV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=o7KysnkI;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=KFbx6kpV;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757076185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxmMeXIzJ2Wh9WP8qskRrAQeSVmxcl9C++2LzjV3anA=;
	b=ZMNFRbYKPeQS+sW0kwjBUPLbCASn0LEIOyCtGxJ0azqCdPIGe/92O7FVZ6cHDsKV+3TiOp
	1+GfRBGX4g6i3fNshtpK27pHTHMKTjU+ZPOZIMLRQevodOzgkem2Fr9KjN07XD0hu400HQ
	8DsJVJ7Bqz1dbbrgn5jGlH+7eZOrCMs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9C4E138616;
	Fri,  5 Sep 2025 12:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757076182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxmMeXIzJ2Wh9WP8qskRrAQeSVmxcl9C++2LzjV3anA=;
	b=o7KysnkIOqUfNgWUL1pdAx8jVtfPfL+Fo9MuZLfWBXE+orlUtC9cpIeZLqxrckM5mJY6SJ
	ibttRv/PD5Wu7bJCmkZoCBzE2da2VZrBpGlUTdqU+NPXSFNE+UrfwgqckJ3zaEn5bzlWmS
	56ZiDWZHUiKJjQAlxMX1GnvyqBOxOA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757076182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxmMeXIzJ2Wh9WP8qskRrAQeSVmxcl9C++2LzjV3anA=;
	b=KFbx6kpVfIyZkk2MgvsOPzxDHqwWlYuvUGj7c7pQ/IQx7mHHNlrwcx/uixrxMn+5OHkdlO
	+BIBA1x1p1Q3ayCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1757076182; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxmMeXIzJ2Wh9WP8qskRrAQeSVmxcl9C++2LzjV3anA=;
	b=o7KysnkIOqUfNgWUL1pdAx8jVtfPfL+Fo9MuZLfWBXE+orlUtC9cpIeZLqxrckM5mJY6SJ
	ibttRv/PD5Wu7bJCmkZoCBzE2da2VZrBpGlUTdqU+NPXSFNE+UrfwgqckJ3zaEn5bzlWmS
	56ZiDWZHUiKJjQAlxMX1GnvyqBOxOA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1757076182;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jxmMeXIzJ2Wh9WP8qskRrAQeSVmxcl9C++2LzjV3anA=;
	b=KFbx6kpVfIyZkk2MgvsOPzxDHqwWlYuvUGj7c7pQ/IQx7mHHNlrwcx/uixrxMn+5OHkdlO
	+BIBA1x1p1Q3ayCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7C904139C2;
	Fri,  5 Sep 2025 12:43:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 8cNkHtbaumghZwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 05 Sep 2025 12:43:02 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id A1B2FA0A48; Fri,  5 Sep 2025 14:43:01 +0200 (CEST)
Date: Fri, 5 Sep 2025 14:43:01 +0200
From: Jan Kara <jack@suse.cz>
To: Brian Foster <bfoster@redhat.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	"Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, 
	jack@suse.cz, hch@infradead.org, jlayton@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback
 accounting
Message-ID: <rzgqmgmovfkreo5gdl36sxoxixcortjwkii2ilgmwsbhrwqx2z@3ncosg2erpta>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com>
 <20250902234604.GC1587915@frogsfrogsfrogs>
 <aLiNYdLaMIslxySo@bfoster>
 <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
 <aLl8P8Qzn1IDw_7j@bfoster>
 <20250904200749.GZ1587915@frogsfrogsfrogs>
 <CAJnrk1aD=n1NzyxgftoQfvC83OO73w2E7ChvGHAh5xfxKrM86Q@mail.gmail.com>
 <aLrG_eOwiROSi-XB@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aLrG_eOwiROSi-XB@bfoster>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 44EDF80003
X-Stat-Signature: 6zparukzc7fmeznmsbfrss7zdztqczac
X-HE-Tag: 1757076185-808075
X-HE-Meta: U2FsdGVkX19q1ypAa1EGU/i2abI++2Z0iAv+Vl4L6WQxV7QwaOV9TaBa0nMugUn2Jyk/E+K0+iCOAiCptMokvTJ1Fz5VAJCIouLREwdwGFFV7nCUJABNoUcXUtJA9iQxFlunddDIcK+lheJ9zcoqzXpXAyKmjyZ0C4jDHWvPxgXNxm3TiaUp66XXjj2TIhPAKEScjChgbX66ms5v8ZidLheixM8LwyIBu3p6oTN62tt6tGG29MookHvpJl9KT3Rt95VwGiPrhlVxSdBOBXCpVMo2okdmXZynMy7XZ/n3mqSlVHM9LNqL4w23OhyLfkOFXnEkRQezBX7tvF30191oyi12CDt7MZHSROwx/He5sPpsgBeaWes9Q4vauzEx5c0SAeMDQCS253eSg/oyc8P3ByOeKE5aPsGuUq54fiRdhqch7xdeqY9ZBBLaN+4MQo4mdP0XQPhHJVMXiUGDg753pSK04+zyck2GxJgtPwC2PY+FvYq+UcN6b36iST77yUJU7obKowSSz3m32nmnNzklfDqBrn51yKAtf5nskOjaTpY8p68kh+pCDd28TTw4krhDNOzkoknituY1DANAB2OI5bcklDgQrcKk/0xtL7mCM5GAS/vwaLY/sqSrUusFYIAjphAZKz3ZTsat8CWUyDU48nRnYpstOwewvKDsjG8F0G3M9bQwB6DRSKnhx0D1HILJwYk+sVERjKGxNl3KZbioFMYBmFK+27hM6JpvaIflhNwEn/lDeNjBYaGmBeKjSVJiK0T1hy+SImhP2VF3jkZUwnzBRWsO+hjjvgPC38oLVKchQPXJCgpJxVjC9u6yQrPuxoGXq3arKKIfIm1Fo1ikejdlTf0dZevcOKEl/fvpFJZoEMGTAlFFE3v872/imhq2YpTTMP4KragL4u7reKXbtRm9K+c+t0GXg9sBEEGb8ylzN4DjMIbqdYAUaZYbWodELWJpPgM0U0bOJmPmxf4
 faOPhYnn
 7QWvNjBW9z1D/5sTX9LrIajj3joeCbAlKMsgSzAhqfeOS5gvANukmlIAgIU6JmLw+Lu/Pmh5PnoCE9jlVytkaxSIbwuDcWknatgMVP3DB9PguDYgk5W+YPJV3yx7SaBn3rlmNn9mxIwFv3MuEfRmMa2/Rhdc6HJeE0WXyg+D3+Bvst50NEg3OQ8a1O2FJ0C7z1ieEvhhul/UIw0yyFonLfvyaqP/6QRH47aBgDlVuNXffHafXNi/QlYoQ+pxf84cRf5CAM9Hxml82pFoChfN+y9LNJdlyWAdCpkAEuyNtH5zSLARE2osijEZeVdKrAdo62QvGb/Ru3+1IhxGD+ctH7gCoJg4+XRJSLFuodocoxB0FJG9sMbjAL7Q2bmoZjCk3CwX7gahjQTNsW4Sn1H37RdMZxA/3XddUP/jY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 07:19:05, Brian Foster wrote:
> On Thu, Sep 04, 2025 at 05:14:21PM -0700, Joanne Koong wrote:
> > On Thu, Sep 4, 2025 at 1:07 PM Darrick J. Wong <djwong@kernel.org> wrote:
> > > On Thu, Sep 04, 2025 at 07:47:11AM -0400, Brian Foster wrote:
> > > > On Wed, Sep 03, 2025 at 05:35:51PM -0700, Joanne Koong wrote:
> > > > > On Wed, Sep 3, 2025 at 11:44 AM Brian Foster <bfoster@redhat.com> wrote:
> > > > > > On Tue, Sep 02, 2025 at 04:46:04PM -0700, Darrick J. Wong wrote:
> > > > > > > On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> > > > > > > > Add granular dirty and writeback accounting for large folios. These
> > > > > > > > stats are used by the mm layer for dirty balancing and throttling.
> > > > > > > > Having granular dirty and writeback accounting helps prevent
> > > > > > > > over-aggressive balancing and throttling.
> > > > > > > >
> > > > > > > > There are 4 places in iomap this commit affects:
> > > > > > > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > > > > > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > > > > > > calling clear_dirty_for_io_stats()
> > > > > > > > c) starting writeback, which now calls __folio_start_writeback()
> > > > > > > > d) ending writeback, which now calls folio_end_writeback_pages()
> > > > > > > >
> > > > > > > > This relies on using the ifs->state dirty bitmap to track dirty pages in
> > > > > > > > the folio. As such, this can only be utilized on filesystems where the
> > > > > > > > block size >= PAGE_SIZE.
> > > > > > >
> > > > > > > Er... is this statement correct?  I thought that you wanted the granular
> > > > > > > dirty page accounting when it's possible that individual sub-pages of a
> > > > > > > folio could be dirty.
> > > > > > >
> > > > > > > If i_blocksize >= PAGE_SIZE, then we'll have set the min folio order and
> > > > > > > there will be exactly one (large) folio for a single fsblock.  Writeback
> > > > >
> > > > > Oh interesting, this is the part I'm confused about. With i_blocksize
> > > > > >= PAGE_SIZE, isn't there still the situation where the folio itself
> > > > > could be a lot larger, like 1MB? That's what I've been seeing on fuse
> > > > > where "blocksize" == PAGE_SIZE == 4096. I see that xfs sets the min
> > > > > folio order through mapping_set_folio_min_order() but I'm not seeing
> > > > > how that ensures "there will be exactly one large folio for a single
> > > > > fsblock"? My understanding is that that only ensures the folio is at
> > > > > least the size of the fsblock but that the folio size can be larger
> > > > > than that too. Am I understanding this incorrectly?
> > > > >
> > > > > > > must happen in units of fsblocks, so there's no point in doing the extra
> > > > > > > accounting calculations if there's only one fsblock.
> > > > > > >
> > > > > > > Waitaminute, I think the logic to decide if you're going to use the
> > > > > > > granular accounting is:
> > > > > > >
> > > > > > >       (folio_size > PAGE_SIZE && folio_size > i_blocksize)
> > > > > > >
> > > > >
> > > > > Yeah, you're right about this - I had used "ifs && i_blocksize >=
> > > > > PAGE_SIZE" as the check, which translates to "i_blocks_per_folio > 1
> > > > > && i_block_size >= PAGE_SIZE", which in effect does the same thing as
> > > > > what you wrote but has the additional (and now I'm realizing,
> > > > > unnecessary) stipulation that block_size can't be less than PAGE_SIZE.
> > > > >
> > > > > > > Hrm?
> > > > > > >
> > > > > >
> > > > > > I'm also a little confused why this needs to be restricted to blocksize
> > > > > > gte PAGE_SIZE. The lower level helpers all seem to be managing block
> > > > > > ranges, and then apparently just want to be able to use that directly as
> > > > > > a page count (for accounting purposes).
> > > > > >
> > > > > > Is there any reason the lower level functions couldn't return block
> > > > > > units, then the higher level code can use a blocks_per_page or some such
> > > > > > to translate that to a base page count..? As Darrick points out I assume
> > > > > > you'd want to shortcut the folio_nr_pages() == 1 case to use a min page
> > > > > > count of 1, but otherwise ISTM that would allow this to work with
> > > > > > configs like 64k pagesize and 4k blocks as well. Am I missing something?
> > > > > >
> > > > >
> > > > > No, I don't think you're missing anything, it should have been done
> > > > > like this in the first place.
> > > > >
> > > >
> > > > Ok. Something that came to mind after thinking about this some more is
> > > > whether there is risk for the accounting to get wonky.. For example,
> > > > consider 4k blocks, 64k pages, and then a large folio on top of that. If
> > > > a couple or so blocks are dirtied at one time, you'd presumably want to
> > > > account that as the minimum of 1 dirty page. Then if a couple more
> > > > blocks are dirtied in the same large folio, how do you determine whether
> > > > those blocks are a newly dirtied page or part of the already accounted
> > > > dirty page? I wonder if perhaps this is the value of the no sub-page
> > > > sized blocks restriction, because you can imply that newly dirtied
> > > > blocks means newly dirtied pages..?
> > > >
> > > > I suppose if that is an issue it might still be manageable. Perhaps we'd
> > > > have to scan the bitmap in blks per page windows and use that to
> > > > determine how many base pages are accounted for at any time. So for
> > > > example, 3 dirty 4k blocks all within the same 64k page size window
> > > > still accounts as 1 dirty page, vs. dirty blocks in multiple page size
> > > > windows might mean multiple dirty pages, etc. That way writeback
> > > > accounting remains consistent with dirty accounting. Hm?
> > >
> > > Yes, I think that's correct -- one has to track which basepages /were/
> > > dirty, and then which ones become dirty after updating the ifs dirty
> > > bitmap.
> > >
> > > For example, if you have a 1k fsblock filesystem, 4k base pages, and a
> > > 64k folio, you could write a single byte at offset 0, then come back and
> > > write to a byte at offset 1024.  The first write will result in a charge
> > > of one basepage, but so will the second, I think.  That results
> > > incharges for two dirty pages, when you've really only dirtied a single
> > > basepage.
> > 
> > Does it matter though which blocks map to which pages? AFAIU, the
> > "block size" is the granularity for disk io and is not really related
> > to pages (eg for writing out to disk, only the block gets written, not
> > the whole page). The stats (as i understand it) are used to throttle
> > how much data gets written back to disk, and the primary thing it
> > cares about is how many bytes that is, not how many pages, it's just
> > that it's in PAGE_SIZE granularity because prior to iomap there was no
> > dirty tracking of individual blocks within a page/folio; it seems like
> > it suffices then to just keep track of  total # of dirty blocks,
> > multiply that by blocksize, and roundup divide that by PAGE_SIZE and
> > pass that to the stats.
> > 
> 
> I suppose it may not matter in terms of the purpose of the mechanism
> itself. In fact if the whole thing could just be converted to track
> bytes, at least internally, then maybe that would eliminate some of the
> confusion in dealing with different granularity of units..? I have no
> idea how practical or appropriate that is, though. :)
> 
> The concern Darrick and I were discussing is more about maintaining
> accounting consistency in the event that we do continue translating
> blocks to pages and ultimately add support for the block size < page
> size case.
> 
> In that case the implication is that we'd still need to account
> something when we dirty a single block out of a page (i.e.  use
> Darrick's example where we dirty a 1k fs block out of a 4k page). If we
> round that partial page case up to 1 dirty page and repeat as each 1k
> block is dirtied, then we have to make sure accounting remains
> consistent in the case where we dirty account each sub-block of a page
> through separate writes, but then clear dirty accounting for the entire
> folio once at writeback time.
> 
> But I suppose we are projecting the implementation a bit so it might not
> be worth getting this far into the weeds until you determine what
> direction you want to go with this and have more code to review. All in
> all, I do agree with Jan's general concern that I'd rather not have to
> deal with multiple variants of sub-page state tracking in iomap. It's
> already a challenge to support multiple different filesystems. This does
> seem like a useful enhancement to me however, so IMO it would be fine to
> just try and make it more generic (short of something more generic on
> the mm side or whatever) than it is currently.
> 
> > But, as Jan pointed out to me in his comment, the stats are also used
> > for monitoring the health of reclaim, so maybe it does matter then how
> > the blocks translate to pages.
> > 
> 
> Random thought, but would having an additional/optional stat to track
> bytes (alongside the existing page granularity counts) help at all? For
> example, if throttling could use optional byte granular dirty/writeback
> counters when they are enabled instead of the traditional page granular,
> would that solve your problem and be less disruptive to other things
> that actually prefer the page count?

FWIW my current thinking is that the best might be to do byte granularity
tracking for wb_stat_ counters and leave current coarse-grained accounting
for the zone / memcg stats. That way mm counters could be fully managed
within mm code and iomap wouldn't have to care and writeback counters
(which care about amount of IO, not amount of pinned memory) would be
maintained by filesystems / iomap. We'd just need to come up with sensible
rules where writeback counters should be updated when mm doesn't do it.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

