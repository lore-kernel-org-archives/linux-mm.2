Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D06CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 11:15:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57A908E0019; Fri,  5 Sep 2025 07:15:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52B128E0006; Fri,  5 Sep 2025 07:15:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4684B8E0019; Fri,  5 Sep 2025 07:15:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3762A8E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 07:15:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC6861D2815
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:15:21 +0000 (UTC)
X-FDA: 83854940442.19.73864F1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0BE84400D4
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:15:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cjitlPFh;
	spf=pass (imf27.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757070915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wxT2pQWYhuYJ73++NPj5ui9tO52IP4lMTlgtVSpujIQ=;
	b=1Y/2Hp+XMnatC68kQoUfn0I3fnbVqn407KZ0rXKWLVIB+QjUiFQwyNB09F2qgOROzIr75t
	N4Wcu1+zHn3zNHZ43BstkEaRNByi/8+3yXL+yVzjKsgDe3B7VSTDBKid6uCsrE0rZVV1gG
	9Z3H80LgviEc1W0lHnCprvTL8zZeSs8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cjitlPFh;
	spf=pass (imf27.hostedemail.com: domain of bfoster@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757070915; a=rsa-sha256;
	cv=none;
	b=w0I+kdgGmj+O+6A1BRJZUJMQjN3B9ZEeyylMjt2eIwzy+9qaClzmo7uovZaQEKFOwc+mt8
	O2s0Z132UsZY0DxoQtoDnM0I2r8RUDqZeJuLVtvsPcKsRzMlPcKkMK5VlvvP+szDopkDi9
	z2c3XkxRDxMBMGixh5NWg19nJ6S9Ra4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757070914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wxT2pQWYhuYJ73++NPj5ui9tO52IP4lMTlgtVSpujIQ=;
	b=cjitlPFhe7Yk+KgZw6yxTfcfOM1lAj8VRzScZnAkTifXNHOtyYx7u7Ce00xa/H0sSNkZ/T
	ESETMde+IENbRbO/hOvypnM3OVO1+fffw/7R/HABFMWOAR8L2FJFsASzNRAtt/EF1G5XWZ
	Pz2KqyYmu9pL3irDT4DFnbweFSRifZ8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-OHHDcZOkOwGUhpXE5ZDkKA-1; Fri,
 05 Sep 2025 07:15:09 -0400
X-MC-Unique: OHHDcZOkOwGUhpXE5ZDkKA-1
X-Mimecast-MFC-AGG-ID: OHHDcZOkOwGUhpXE5ZDkKA_1757070907
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3978B1800562;
	Fri,  5 Sep 2025 11:15:07 +0000 (UTC)
Received: from bfoster (unknown [10.44.33.64])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77B3F1800452;
	Fri,  5 Sep 2025 11:15:02 +0000 (UTC)
Date: Fri, 5 Sep 2025 07:19:05 -0400
From: Brian Foster <bfoster@redhat.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, linux-mm@kvack.org,
	brauner@kernel.org, willy@infradead.org, jack@suse.cz,
	hch@infradead.org, jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 12/12] iomap: add granular dirty and writeback
 accounting
Message-ID: <aLrG_eOwiROSi-XB@bfoster>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-13-joannelkoong@gmail.com>
 <20250902234604.GC1587915@frogsfrogsfrogs>
 <aLiNYdLaMIslxySo@bfoster>
 <CAJnrk1Z6qKqkOwHJwaBfE9FEGABGD4JKoEwNbRJTpOWL-VtPrg@mail.gmail.com>
 <aLl8P8Qzn1IDw_7j@bfoster>
 <20250904200749.GZ1587915@frogsfrogsfrogs>
 <CAJnrk1aD=n1NzyxgftoQfvC83OO73w2E7ChvGHAh5xfxKrM86Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJnrk1aD=n1NzyxgftoQfvC83OO73w2E7ChvGHAh5xfxKrM86Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: 1ztuyp33t99uugtiawdcezuiyyewyrqe
X-Rspam-User: 
X-Rspamd-Queue-Id: 0BE84400D4
X-Rspamd-Server: rspam05
X-HE-Tag: 1757070914-837429
X-HE-Meta: U2FsdGVkX19QEv34HxBaHH3RdVOkgmgWsCLskU/BsZ4nKZaUq+19Eq4j8wcR2Yl83nxat9XM/yGn0ezpduoSdb0bUg+WPDgB8bdgR/FWM1vIMrWSidhqpcMHc56B/1joP7h0nJci9M+7uIkS+2iBSCONyAO9CS9wdVzYqkG2q9sSw8dCReY8UJSVvZqjKh1qEWnQks+PdAET5xCx5OpqZ8DwlY3YvkSy382ZrEHuckJdnoQ+JPeGyM40VtKExBhMmTjMJHsRJwY3KtvxDBvCcCzchNEgEVr4TOglMszHlVyirEkZvqnNAHSNZpBNhwMhR78EFsfP2W2vqO5c9s5Iib3/ajIQwvVbc5KWqEzoyw4ewzY5u2MpS+zA3PIG3YHiftjyO+yVe7z7Ot5rJvsQKZBlH4t6xMGwe0V+aER85aIlMitex75s7Y+5rLktImpjcrE2xdRvjyLpAy3L4XnNFTP6dN1fBNrXLFTfYoTi3cNJg1zs0JhtqR+wKE8BRMjK5+gDdub96DfTLv73pD1fBucbgDI7R6j1tfoJWu2NN0En/Mf93hDinSyJpSWMlV8zWZ6rttXKdnEz9/Y5eGuuO+cAtfASUaD6ChbbRcHm4FQAWh5JE4OwBQRQ+9qydSr2Xc2omhIV+2gr7KrRPVg3m8Y9S12k77JyNhIYoLPHcolN2fpv47azEAdtH6M5cSxqLQulOz469ahW/EYXj03va3hw4O+HOEStTlPuRqbpTJJN0ZaXIqA8w/yBFrHe2NAr+FB+imKAm6R16wVznBE8SjXrVdTyu0XEu8SXrCCzFedKyNQWFr3MA7cDrunx4Z+jWCbHM+lhveim7WBDhyQfbcfQvJP7V9txTMHH50JZtqmtudUPoTnKN7bZcx4KYsEfzxD7uiFNPSKR/5X100MwY9zJ8HvqyVWxEQps6oXcvKZoj8VBdCI2qstZWQZEi/fWnVJMiG0NX6usSwqCMAK
 8CxfaGrz
 L6TJNmsyoAjFniHsVnWCVrTAWB/TL1HstQ9xcKtJNjtbFK6GMpKMJUzC8GrZwBYIDHWT9bHjyr7ZpxVdUtcAYgKsHhsVJy8giKBBpnZEXqC8mpY6lwlKKVXkRZQDchxHcNVMIkgxvA7F8y8ZnRStNVv9Ckb44mRpe9shJcN+lFJ/i++vMw/AU+JS06sH4/kiW2XrKBIqepkYIKlKvn09lhK4fSuGgbjIqrV8nbLQRrn4JTw3d6xLmDY0kmlZqUw2NLksoeb1MdnSSIvLIq03B/VjnyMQ/m0o52cKXE4nlRpPoahugOo5JBu+jGFsupXwy5OozNuSIHMrqUUmB0NsMrZmF0qgLgxyrBY26VewUy0DHdDEJ9MiVcFPrYDqX8+Po7tgG/Y/Nd7ywapHDDVE9dm/856wQuNjbo+bsPDerWJI5lhlFboj2Xh4vzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 05:14:21PM -0700, Joanne Koong wrote:
> On Thu, Sep 4, 2025 at 1:07 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Thu, Sep 04, 2025 at 07:47:11AM -0400, Brian Foster wrote:
> > > On Wed, Sep 03, 2025 at 05:35:51PM -0700, Joanne Koong wrote:
> > > > On Wed, Sep 3, 2025 at 11:44 AM Brian Foster <bfoster@redhat.com> wrote:
> > > > >
> > > > > On Tue, Sep 02, 2025 at 04:46:04PM -0700, Darrick J. Wong wrote:
> > > > > > On Fri, Aug 29, 2025 at 04:39:42PM -0700, Joanne Koong wrote:
> > > > > > > Add granular dirty and writeback accounting for large folios. These
> > > > > > > stats are used by the mm layer for dirty balancing and throttling.
> > > > > > > Having granular dirty and writeback accounting helps prevent
> > > > > > > over-aggressive balancing and throttling.
> > > > > > >
> > > > > > > There are 4 places in iomap this commit affects:
> > > > > > > a) filemap dirtying, which now calls filemap_dirty_folio_pages()
> > > > > > > b) writeback_iter with setting the wbc->no_stats_accounting bit and
> > > > > > > calling clear_dirty_for_io_stats()
> > > > > > > c) starting writeback, which now calls __folio_start_writeback()
> > > > > > > d) ending writeback, which now calls folio_end_writeback_pages()
> > > > > > >
> > > > > > > This relies on using the ifs->state dirty bitmap to track dirty pages in
> > > > > > > the folio. As such, this can only be utilized on filesystems where the
> > > > > > > block size >= PAGE_SIZE.
> > > > > >
> > > > > > Er... is this statement correct?  I thought that you wanted the granular
> > > > > > dirty page accounting when it's possible that individual sub-pages of a
> > > > > > folio could be dirty.
> > > > > >
> > > > > > If i_blocksize >= PAGE_SIZE, then we'll have set the min folio order and
> > > > > > there will be exactly one (large) folio for a single fsblock.  Writeback
> > > >
> > > > Oh interesting, this is the part I'm confused about. With i_blocksize
> > > > >= PAGE_SIZE, isn't there still the situation where the folio itself
> > > > could be a lot larger, like 1MB? That's what I've been seeing on fuse
> > > > where "blocksize" == PAGE_SIZE == 4096. I see that xfs sets the min
> > > > folio order through mapping_set_folio_min_order() but I'm not seeing
> > > > how that ensures "there will be exactly one large folio for a single
> > > > fsblock"? My understanding is that that only ensures the folio is at
> > > > least the size of the fsblock but that the folio size can be larger
> > > > than that too. Am I understanding this incorrectly?
> > > >
> > > > > > must happen in units of fsblocks, so there's no point in doing the extra
> > > > > > accounting calculations if there's only one fsblock.
> > > > > >
> > > > > > Waitaminute, I think the logic to decide if you're going to use the
> > > > > > granular accounting is:
> > > > > >
> > > > > >       (folio_size > PAGE_SIZE && folio_size > i_blocksize)
> > > > > >
> > > >
> > > > Yeah, you're right about this - I had used "ifs && i_blocksize >=
> > > > PAGE_SIZE" as the check, which translates to "i_blocks_per_folio > 1
> > > > && i_block_size >= PAGE_SIZE", which in effect does the same thing as
> > > > what you wrote but has the additional (and now I'm realizing,
> > > > unnecessary) stipulation that block_size can't be less than PAGE_SIZE.
> > > >
> > > > > > Hrm?
> > > > > >
> > > > >
> > > > > I'm also a little confused why this needs to be restricted to blocksize
> > > > > gte PAGE_SIZE. The lower level helpers all seem to be managing block
> > > > > ranges, and then apparently just want to be able to use that directly as
> > > > > a page count (for accounting purposes).
> > > > >
> > > > > Is there any reason the lower level functions couldn't return block
> > > > > units, then the higher level code can use a blocks_per_page or some such
> > > > > to translate that to a base page count..? As Darrick points out I assume
> > > > > you'd want to shortcut the folio_nr_pages() == 1 case to use a min page
> > > > > count of 1, but otherwise ISTM that would allow this to work with
> > > > > configs like 64k pagesize and 4k blocks as well. Am I missing something?
> > > > >
> > > >
> > > > No, I don't think you're missing anything, it should have been done
> > > > like this in the first place.
> > > >
> > >
> > > Ok. Something that came to mind after thinking about this some more is
> > > whether there is risk for the accounting to get wonky.. For example,
> > > consider 4k blocks, 64k pages, and then a large folio on top of that. If
> > > a couple or so blocks are dirtied at one time, you'd presumably want to
> > > account that as the minimum of 1 dirty page. Then if a couple more
> > > blocks are dirtied in the same large folio, how do you determine whether
> > > those blocks are a newly dirtied page or part of the already accounted
> > > dirty page? I wonder if perhaps this is the value of the no sub-page
> > > sized blocks restriction, because you can imply that newly dirtied
> > > blocks means newly dirtied pages..?
> > >
> > > I suppose if that is an issue it might still be manageable. Perhaps we'd
> > > have to scan the bitmap in blks per page windows and use that to
> > > determine how many base pages are accounted for at any time. So for
> > > example, 3 dirty 4k blocks all within the same 64k page size window
> > > still accounts as 1 dirty page, vs. dirty blocks in multiple page size
> > > windows might mean multiple dirty pages, etc. That way writeback
> > > accounting remains consistent with dirty accounting. Hm?
> >
> > Yes, I think that's correct -- one has to track which basepages /were/
> > dirty, and then which ones become dirty after updating the ifs dirty
> > bitmap.
> >
> > For example, if you have a 1k fsblock filesystem, 4k base pages, and a
> > 64k folio, you could write a single byte at offset 0, then come back and
> > write to a byte at offset 1024.  The first write will result in a charge
> > of one basepage, but so will the second, I think.  That results
> > incharges for two dirty pages, when you've really only dirtied a single
> > basepage.
> 
> Does it matter though which blocks map to which pages? AFAIU, the
> "block size" is the granularity for disk io and is not really related
> to pages (eg for writing out to disk, only the block gets written, not
> the whole page). The stats (as i understand it) are used to throttle
> how much data gets written back to disk, and the primary thing it
> cares about is how many bytes that is, not how many pages, it's just
> that it's in PAGE_SIZE granularity because prior to iomap there was no
> dirty tracking of individual blocks within a page/folio; it seems like
> it suffices then to just keep track of  total # of dirty blocks,
> multiply that by blocksize, and roundup divide that by PAGE_SIZE and
> pass that to the stats.
> 

I suppose it may not matter in terms of the purpose of the mechanism
itself. In fact if the whole thing could just be converted to track
bytes, at least internally, then maybe that would eliminate some of the
confusion in dealing with different granularity of units..? I have no
idea how practical or appropriate that is, though. :)

The concern Darrick and I were discussing is more about maintaining
accounting consistency in the event that we do continue translating
blocks to pages and ultimately add support for the block size < page
size case.

In that case the implication is that we'd still need to account
something when we dirty a single block out of a page (i.e.  use
Darrick's example where we dirty a 1k fs block out of a 4k page). If we
round that partial page case up to 1 dirty page and repeat as each 1k
block is dirtied, then we have to make sure accounting remains
consistent in the case where we dirty account each sub-block of a page
through separate writes, but then clear dirty accounting for the entire
folio once at writeback time.

But I suppose we are projecting the implementation a bit so it might not
be worth getting this far into the weeds until you determine what
direction you want to go with this and have more code to review. All in
all, I do agree with Jan's general concern that I'd rather not have to
deal with multiple variants of sub-page state tracking in iomap. It's
already a challenge to support multiple different filesystems. This does
seem like a useful enhancement to me however, so IMO it would be fine to
just try and make it more generic (short of something more generic on
the mm side or whatever) than it is currently.

> But, as Jan pointed out to me in his comment, the stats are also used
> for monitoring the health of reclaim, so maybe it does matter then how
> the blocks translate to pages.
> 

Random thought, but would having an additional/optional stat to track
bytes (alongside the existing page granularity counts) help at all? For
example, if throttling could use optional byte granular dirty/writeback
counters when they are enabled instead of the traditional page granular,
would that solve your problem and be less disruptive to other things
that actually prefer the page count?

Brian

> I'll put this patchset on hold until there's more feedback from the mm
> side as to whether we should proceed or drop this.
> 
> 
> Thanks,
> Joanne
> 
> 
> >
> > Also, does (block_size >> PAGE_SHIFT) evaluate to ... zero?
> >
> > --D
> >
> > > Brian
> 


