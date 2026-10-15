Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C12E7CC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:10:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745896B0099; Thu, 15 Oct 2026 10:10:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6556B009D; Thu, 15 Oct 2026 10:10:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E58B6B009E; Thu, 15 Oct 2026 10:10:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9BD6B0099
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:10:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A3EEB1C402D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:10:03 +0000 (UTC)
X-FDA: 85325044686.01.546F13C
Received: from mta1.migadu.com (out-216.mta1.migadu.com [95.215.58.216])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41F3D100008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:10:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rz+Utc8b;
	spf=pass (imf14.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792073401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wHWQIfIdYYbchY13VQLsb4nd5Znh60XR6PR+paQNlo=;
	b=Ho0uPOC13hGxghY3zUXNtJPRylAcVPQkhPYRzscehMUiJtSjdqZbdPg2CVzIuNJELXwAlq
	VFKVwrrJmL1PQb2VutXZSOdIprUBjPIXCvcl9wksjNvBIkbdWozCxuwcHziJcMXG2+rK7l
	sJOCJKtgH5wSYvYNX+1tFXI+PozYJlM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rz+Utc8b;
	spf=pass (imf14.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.216 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792073401;
	b=yF1LvrevMwctK9BHFkJrkMxT6SjxqQiPQMwEQPY/6WRzlmjuCFg/a0NOZvYve3jg8PnEE5
	rZbDcg51KzR6cIT17M0bsaUaCz6ge+tN9n1Az1sqJRCOYHRiV131uIVYtbxBMjBZUmzScM
	WRHKLyv/NyRhtbhJCa5iTX8tbnvZbCk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IoHF48dbE7mSf4cxc6kAiqoGLhZGegSeGkb8H4uroPU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792073399; v=1; x=1792678199;
 b=rz+Utc8bAGijsFCr/QEl8LzFZmlaXbdU+3KQ3TSCpCvY0NCBAVrqDDFHlDy9pKg1g4YOoEAy
 Q2F0H1awh18TQ2zYMDsIv97QFBbg+/gXwf1gB4N5daxMpDk/kLiOdTYOTiJlAyJHTJGL1nVvL5q
 M4Hjn4R55sL1v33sffhObyDs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a2a20668fccf1d9d;
	Thu, 15 Oct 2026 14:09:59 +0000
X-Mizu-Trace-ID: a2a20668fccf1d9d
X-Migadu-Flow: FLOW_OUT
Date: Thu, 15 Oct 2026 16:09:50 +0200
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	Zhang Yi <yi.zhang@huawei.com>, Christoph Hellwig <hch@lst.de>, 
	Dave Chinner <dchinner@redhat.com>, Daniel Gomez <da.gomez@kernel.org>, Theodore Tso <tytso@mit.edu>, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andres Freund <andres@anarazel.de>, Dave Chinner <dgc@kernel.org>
Subject: Re: [RFC PATCH v4 05/12] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <as-BQAbk7U43vkqs@quentin>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
 <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c76f9babf1b00f4574e37db156621edc6c078969.1790596383.git.ojaswin@linux.ibm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 41F3D100008
X-Stat-Signature: 515s98ad1n7pxkat15at5j15hmt3thur
X-HE-Tag: 1792073400-948094
X-HE-Meta: U2FsdGVkX1/LhRYAApFm/jCS9tnop5327TkFXcsy9ka9sFnkUM+70gJfuDw1ZIZnsK5wErOeh1MAB09rpAU9wvD8ku4fJtUnpfmnMP6g1w9GM+Ly18IYmyxiaewkdY4r3FOZv0hPffxE4OgUiYOTkQwi6gUOd8CP9OcAfytPiXQD+nskk4FZ4+09Uk8DKZExL6BYR4i4C5otHZD0lZbT3Vc9M2h0vl7nJPNwAhuMsAsyKFFdMWXyQYRFkp63ru71KrUGVGfHhZhGLoygo7UkH23ohImcI2u226k16lC0/ug7cAUPOXB42k3UGSTJybP5fAp1y3xYd4b9PeYDM4e4mghmHM3SV0BG/mGXWOnFuL0XS2t4u6Zp5gohc4Qus0461t9IYzjn+QtER98oHoY3x0WEWIjmfvF+TmmLeBxTU/K0Z6NUVsGPwadIHA12Q6Ca8mXDSDg7Z0XArBAjDOO4hFv+9yiBb6e8kP95IIfnrqOqKCqhzbm5Y5ZYJiCJ5FfqCOh/kMcrmf697hEmK/HwC9wAOqOBFmHy6/RSs1J3NU46fbGL406MesnM2HbSmFb16apaNtTJz+hzOCcmqohRvEqW/gVovZRREJh2R1UZA08qCQRqs50nGR8F1CdmjYlYRUtoQkNC/CsC4iFSGSp87ISriHNg+1bB1lOXAmH3lcG/ldkVtBbMs4wiOXBYawFiPehNK2xZmxxQBx5BDaoMSdZ/ffPSFJ99YRYVJovMbC/vOSKN+oowKwdsarW2m3WQzwvkqXa+jpNiP6OlkrfxQVaudk7fOLC7tJfcc5sVKbN/KGHzkECGCQHEn4JRlquW/3vmywvEc3q40nYsq1Y6PAFvNkA0hW3EKbOtdl8EJU2Oq671Pi00R1N/KMpDQtV4CiiAkOMGwhUHipLEk7VHa0FU2h/MvFzZj/wzBPdqGkqOZZYp6T4pQvCK36/1SMO0XYagWDp1zhdkNM/R4Om
 6S+fuSUd
 pyGi/VLNNQa97yK4MTtnAu0DJo11xPjRA0uaCkkFDCBKvpqvPt1Tk46yK2yfLQSdjAUeqBvQcCh94T26q1AmDV6NltU8gv1lSipgqr4aLZQHixoaT+dHayk0Y5hnIGwZGCcKZPqDM+6jHbPSaTuZkun7KBUm1E2hBXebtXceFsbSJOI1RSztJasS26l0yHJ4XyHiWnLQtgQVgZNeEt/xnLhaen8KeF1xtUrmq52oDtYlbHD7hQjwvt1wyTtZCGRA+PmFQdYqYv5e4zPvyrd+7u07qNFDNq/dzyD9VCIIe2G5woA08K0q+WaaLtTld8drSY5ZnM7T7n5BD6yyYraZc69Mb2qMKt4PmwrqMiU2kET6ONfUqjdJzfXPi0P35Iyi1peLs+yFkoYzfUS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ojaswin,

I was comparing normal buffered IO scenario and writethrough.

In a normal buffered IO scenario, for unwritten extents or CoW extents,
we first convert them before ending the writeback on the folio.
xfs_end_io calls xfs_end_ioend_write().

static void
xfs_end_ioend_write(
        struct iomap_ioend      *ioend)
{
<snip>
       /*
         * Success: commit the COW or unwritten blocks if needed.
         */
        if (is_zoned)
                error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
                                ioend->io_private, NULLFSBLOCK);
        else if (ioend->io_flags & IOMAP_IOEND_SHARED)
                error = xfs_reflink_end_cow(ip, offset, size);
        else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
                error = xfs_iomap_write_unwritten(ip, offset, size, false);

        if (!error &&
            !(ioend->io_flags & IOMAP_IOEND_DIRECT) &&
            xfs_ioend_is_append(ioend))
                error = xfs_setfilesize(ip, offset, size);
done:
        if (is_zoned)
                xfs_ioend_put_open_zones(ioend);
        iomap_finish_ioends(ioend, error); // #1
        memalloc_nofs_restore(nofs_flag);
}

#1
iomap_finish_ioends()
  iomap_finish_ioend_buffered_write()
    iomap_finish_folio_write()
      folio_end_writeback()


On Mon, Sep 28, 2026 at 05:33:06PM +0530, Ojaswin Mujoo wrote:
> @@ -1185,6 +1186,384 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
> +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct kiocb *iocb	= wt_ctx->iocb;
> +	struct inode *inode	= wt_ctx->inode;
> +	ssize_t ret		= wt_ctx->error;
> +
> +	if (wt_ctx->end_io) {
> +		int err = wt_ctx->end_io(wt_ctx, wt_ctx->written,
> +					 wt_ctx->error,
> +					 wt_ctx->flags);
> +		if (err)
> +			ret = err;
> +	}
> +

<snip>

> +static void iomap_writethrough_bio_end_io(struct bio *bio)
> +{
> +	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
> +	struct folio_iter fi;
> +
> +	if (bio->bi_status)
> +		cmpxchg(&wt_ctx->error, 0,
> +			blk_status_to_errno(bio->bi_status));
> +	bio_for_each_folio_all(fi, bio)
> +		folio_end_writeback(fi.folio);
> +
> +	bio_put(bio);
> +	if (atomic_dec_and_test(&wt_ctx->ref))
> +		iomap_writethrough_done(wt_ctx);
> +}
> +

But in the writethrough patches, we first end the writeback on the folio
and then call xfs_dio_write_end_io(), which converts unwritten or CoW
extents.

Is there a race possible as we are doing the other way? What if folios
are reclaimed between ending the writeback and conversion? A new read in
that area will return zero filled folios as XFS still sees IOMAP_UNWRITTEN?

I don't have a reproducer, but my hunch says we can run into this if we
have a lot of AIO as the end_io will be run via a workqueue?

Do we do something similar to buffered IO where we do
folio_end_writeback after extents conversion?

--
Pankaj

