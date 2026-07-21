Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FD3FC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 05:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5FA6B007B; Tue, 21 Jul 2026 01:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F2E6B008A; Tue, 21 Jul 2026 01:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5EF16B008C; Tue, 21 Jul 2026 01:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0A5E6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 01:38:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F02B40395
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:38:54 +0000 (UTC)
X-FDA: 85011679788.30.3EB092F
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf08.hostedemail.com (Postfix) with ESMTP id 429F0160006
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:38:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784612332;
	b=pdNzZolbDLCYkLG6OS5Pciw5bthEe0b8ls1viT2HbduHMDIvLgHMYOq73XifOUfGYgXUj1
	gBqEzUH3tfKGuX8kxTAlaq0Ergg0bIu8rORJMG3YscWVgv/UQWfaBbibQCjPO85ZDA+DIz
	Ah/nHnIGFOeNSp87Yu7OJkaiQ/rMUok=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784612332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m9ap0OQ5Th+sWhnTjktF9ikt1SDACuCV68rFWr+fKxw=;
	b=5KZ1IVH99O3aAUhIWg2FwsdthCRZ7LXpUq2KenM6ege7bsnsQb3QOdzXPFFG826v/o9dk2
	lZ7hQlz6Qt2TpGvFykkwwZsJJSP0mkv1mzC2eo4YEVbd97b3ZkYJZA8PFlEGJdIH78ROzb
	mhMSro5wktWWD36E/wep9Mh/M76/0XY=
Received: by verein.lst.de (Postfix, from userid 2407)
	id A180E68C4E; Tue, 21 Jul 2026 07:38:48 +0200 (CEST)
Date: Tue, 21 Jul 2026 07:38:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kairui Song <ryncsn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
Message-ID: <20260721053848.GA7538@lst.de>
References: <20260713093350.2154226-1-hch@lst.de> <20260713093350.2154226-4-hch@lst.de> <alZ0fgRSy0RpHxcT@KASONG-MC4> <20260716121953.GA28985@lst.de> <CAMgjq7BLD+OV3OUcWZidkbKwmb3dCeLdAWP-BOpgRQSM3SLrSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BLD+OV3OUcWZidkbKwmb3dCeLdAWP-BOpgRQSM3SLrSA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: zkofhefh37bzp7g43m44jaibppgx5jzb
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 429F0160006
X-Rspam-User: 
X-HE-Tag: 1784612332-672696
X-HE-Meta: U2FsdGVkX194+ifmRUPX+cIUmNidAa0vWdHfuW0hewuKW/iuyFLZBeuZWgDKYz5qPJXOWV5fYZ3XHEYkN/qj+Qhm7v8NmYLNQCV4ij74zGHEZ/Qj3RYSlQnp5Sjljs3rTbB1OMGCh4ehPHD1Z+nXGKzdjqw4a7YTfHpO1Ey4zHu8hWfpqW8to/YqB3VTd4hcIM1lWJLMoiasucErColKPvymkzfi2w2qrQZZdlBC0itK9O217Qp0oqKD5jWUmd1N5p+bcdWNLzeWBmwwLkYacrXbsdmvmTqc8RNQlJGsOStX/HGv99EXVAUxQx5YU/FEOQKFWrEtPGNHsgJ4h/+bzD+PjjULJXwEVELis3oVhPOiLcGEzSqnPxX8AubKXNjn9GsfZWU6C1k5Rg2/vOlOZ3iLFeM+18N+TFwXIXivddTPls1S1QQ/otgS32nfPUKSRrFZqt6XaL+ROr4Ists+ONx8IAS9r3N8ZtQnzI+sqIIP/e2vM/GopJOVDtL0SeOcrAVZBM+UmBf5Jpk6kthNiTYbDEAMqGug9I3iewCtVpcsvmhvsn1THBGUahyggukOmADUniLC+JZn76un2A6I7/79DrbSVS2YXn9w7FUPp1gM7Sw9PmMc+o7p49WvI2OeBthUP5qKVM343rEj/a10GPx0ZTJMyYkORX2GRDhlVVFpzoEyFfenUHnfDyn55nfIL5i94bLVcjHVRDbDGUVN+j5A4UqqSql2veI3bNhaAX+b0P9eiCdFfexePUq6OJ3JVyMacctSf5lab8Frqed1i+xqEzuPMOmu8akE7wCnpos0kMXGX4oG/PYuGgHVnDQauuIuePJ/Zeic9ML2B9yIuVbuXTQ0BxXXVTSEE/frtFLfdsSuSTLiMqjCnPWyIpT7+b5t/ORPjPCdJrHDMJM+anYdO8xqPkXloWF/p3ODnHMfL7vljeljGMGAZqd2uw0/DUMt8tg8KIytqgOJZf2
 Mnn9F2sJ
 mdV9oSJxsVzAPo9Q4zUH90eZQAf53KFwEAZTlAiaTPdlWQHPvu0Qq9saew/OEpzRrSAUUDMQch+3by1eyWoK2ozeBq54Lkiz5L1RFJJ/sparijRQNI32/7grmTzL4FlF6eWt1qNcNsvJYEkY1TMy7d+L5otoADIdMK/W0tEahCJ6HpCM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 01:02:27AM +0800, Kairui Song wrote:
> On Thu, Jul 16, 2026 at 8:19 PM Christoph Hellwig <hch@lst.de> wrote:
> >
> > On Thu, Jul 16, 2026 at 12:03:22AM +0800, Kairui Song wrote:
> > > > -static void sio_write_complete(struct kiocb *iocb, long ret)
> > > > +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> > > > +           int rw)
> > >
> > > Will a bool rw suits better?
> >
> > Not really.  Bools as arguents always have the downside that it is
> > really hard to guess what they mean based on the callsite.
> >
> > While READ/WRITE really should be enum, it's probably the best we have
> > right now.
> >
> > > > -   bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
> > >
> > > bio_add_folio_nofail also increased bi_vcnt, now it's open coded and
> > > bi_vcnt stays zero, it's not used right now, could there be any user
> > > of it in the future?
> >
> > bi_vcnt only exists to assist bio_add_page*/bio_add_folio*. So if we
> > assign the bio_vecs manually we don't need it.  If we ever switch
> > to using bio_add_folio_nofail we'd need it, but then we'd already
> > maintain it in there :)
> >
> > > So this removes swap_writepage_bdev_sync (which was calling submit_bio_wait),
> > > we are replying on a later swap_write_submit, and just add the folio to ctx.
> >
> > For SWP_SYNCHRONOUS_IO, yes.
> >
> > > Before the series, pageout will detect for writeback finished and clean
> > > pages under PAGE_SUCCESS, if the IO of a page is done and writeback flag
> > > cleaned, the page get released immediately. But now, almost all pages
> > > will be put back to the LRU waiting for rotation. This also make the
> > > reclaim have a stronger bias towards reclaim files, and anon reclaim
> > > become less effective.
> > >
> > > I do observe a real performance regression with classical LRU and ZRAM,
> > > ordinary swap seems also very slightly effected but could be noise,
> > > test is done on my laptop by building the kernel using make -j12 and
> > > tinyconfig in a 2G VM with mild pressure:
> >
> > > Before this series (with 8G ZRAM only):
> > > 175.39user 125.89system 0:40.54elapsed
> > > 26581840inputs+0outputs (1186391major+22698964minor)pagefaults
> > >
> > > After this sereis:
> > > 165.59user 216.02system 1:04.06elapsed <- the problemic one.
> > > 53531464inputs+0outputs (2550441major+31974007minor)pagefaults
> > >
> > > Because all anon folios will be derfer freed on next iteration of the LRU,
> > > which caused a much higher memory pressure.
> >
> > So this is zswap which does set SWP_SYNCHRONOUS_IO.  I guess forcing
> > a submit after each bio_vec for SWP_SYNCHRONOUS_IO might make some
> > sense as a workaround, although it is a bit ugly.
> 
> Thanks, a SWP_SYNCHRONOUS_IO check here sounds good to me. This check
> can be dropped if we also drop the writeback check in pageout by
> letting LRU / MGLRU have a unified batch free after pageout, things
> would be pretty by then I think.

Does this look good to you?  It has passed some basic zram sanity
checking here:

---
From 31c1466eacefb68d41848cfbb5dcd4f86073256a Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch@lst.de>
Date: Tue, 21 Jul 2026 06:42:26 +0200
Subject: mm/swap: revert to single-folio writes for synchronous swap devices

Kairui Song reported that zram benefits from submitting each folio
directly instead of batching up I/O because the classic LRU scanning
benefits from clearing the folio writeback bit in the scan loop.

Accommodate that by kicking off reads for synchronous devices for
each iteration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/page_io.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/mm/page_io.c b/mm/page_io.c
index e4fa7ffffe8b..c984a4023a65 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
 	}
 	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
 	sio->len += folio_size(folio);
-	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
+
+	/*
+	 * Write out the iocb if we filled it, or if the device is synchronous.
+	 *
+	 * The latter is to work around expectations in the classic LRU code
+	 * which make synchronous clearing of the folio writeback flag in the
+	 * reclaim path beneficial.
+	 */
+	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) ||
+	    (rw == WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
 		if (rw == WRITE)
 			swap_write_submit(ctx);
 		else
-- 
2.53.0


