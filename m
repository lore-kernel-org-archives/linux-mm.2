Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB4AB109C05C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 20:21:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2232B6B0088; Wed, 25 Mar 2026 16:21:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4316B0089; Wed, 25 Mar 2026 16:21:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9FA6B008A; Wed, 25 Mar 2026 16:21:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F232C6B0088
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:21:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D02DE0FA7
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:21:37 +0000 (UTC)
X-FDA: 84585705834.16.F7A99D7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 87D0B4000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:21:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DM6Wvfqy;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774470096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KeJTrDz0ZERUb53okI56kxVXYWflMwMqTR1ZZSCDXMI=;
	b=C3/KctWPr5wLnD6tRNWUHGtHX8+sf/dufi88dXreO6hUXxxhpHKwu8LGNjkM0Dge5uLhvI
	pQZb3DFoH7BjbLGI+7575L9y/9I9oNvAibpb1cc9F23uQlRzKYX5wUCohHFM0WnlveMGMp
	1bYjdsaXHWFYPjH+fTw1/AYKNSFBAJw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=DM6Wvfqy;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774470096; a=rsa-sha256;
	cv=none;
	b=4fnSP12suPQH44yDU/N4pwb0R/JuoZaNYFmh7XMmhLPFxjtbexBr5Mm/mzRAQuQ0bKEU0p
	Nt2HneGNWzEkEuLp0nC6+M/5lbbtfHFDACx3R/chFmqGn4vh4hUGAaSFLdwObSgxs/iK5n
	5wz/oRq4xSB7AYp5jmTplNQ7rYOXx58=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=KeJTrDz0ZERUb53okI56kxVXYWflMwMqTR1ZZSCDXMI=; b=DM6WvfqywEbRbUFcvSVOCmaTHT
	aVny9M8t9l80xxaOAw1UaOdFSR5Ar49FQWmbvBFSCKUh0ApwBIBg/QXAkwToKrJU0GOscNN5teXtA
	Ye0W5MSDX+QcsCaEfHOISraJFZgugWBerE278/7b1HXHAsHrH7VASlgBsveK5NjwSVrb5NNmKN+BJ
	yDE5iV2917oILPrH3EVbpz7hNABlLV6/YdU27BTTwOXjzGGvHNzP61lpyJpdCzFVoPSfgHcFpinxb
	LquoV5sPsNV1JFL7RmVGyfch1BJ1l3XZtZ/wqG2aE1QX9lXSsuJEfr1S4kbWofLo+3YLEz9Affatk
	rCW+zEGg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5UjI-0000000GUsO-3sZs;
	Wed, 25 Mar 2026 20:21:28 +0000
Date: Wed, 25 Mar 2026 20:21:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH RFC v4 2/3] iomap: use BIO_COMPLETE_IN_TASK for
 dropbehind writeback
Message-ID: <acRDyJrkJhnHHMSe@casper.infradead.org>
References: <20260325-blk-dontcache-v4-0-c4b56db43f64@columbia.edu>
 <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-blk-dontcache-v4-2-c4b56db43f64@columbia.edu>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 87D0B4000B
X-Stat-Signature: 1ja97cbt9b8r95oaf9b4nrtkmfx131w4
X-Rspam-User: 
X-HE-Tag: 1774470095-12007
X-HE-Meta: U2FsdGVkX1+dzFDj/Ltgv4qUAyUVBRv+9I0pdxCWugbhk7vaEOO6sDHjc8zjnGxvMG7OQZPOly9dGs4bIwcQznjHZLU5+C5VmdQIb/LqmoEh/rlfBnIZB0JkIj4RGJF89BxeHWTnocmVsHQVl6dNNvHK94IOqsEH/I4+atiyIhP+4hdx8la80p/za7oyPrq0iJAWsy1rslOfgZsrToyLAXCO7HjNmVs5quuC7BP1U1wcPnxKh1f7B4722obV6rKMc60XRtOMDc0Jug4gPMjO4AsmxNdObNWc7NsqMpjm/WMlOURS17cGSsH/4tvlHmjoI9bgbavm+JPKk85PXE7SgfVuaK5rTVWcy+AHIPAAv7UPfCII/1W6IILbP3Cp/nqZpNF5INsTW+KuU/YWUISPfIBS7UBKiD+rVSTHpGUbNDH72tOq0LXLeuIQBFRwSL1I7eViEVOdGhKoTlyMWdUmVlR8BUb72T0NmCw5EnAwImVCvrQFotwqRjBi45WkFvGB8qdZW/Yp0JNTQNgMzDHTxSh8h7l9J4UW4qYgcKPPaoqFwCN74roORGGLD2Qx3SD9BWm8lqiizCzschB9OfHGHS/5IiU5sWeJ2znCYaNYhCWIWXMzjdZR8PMbrcOQ4Imn9Vh9cY2Mm5WPcJl9r8o2rebzg5I+TEoBa5dqdwEwfY7JP9mdhcmdzreW8TiFYWJKSBdgnx5MIZ7tf25t/IRfzevS4zbrJD4hr/ZvZ+mWjmVzJIzown56AF+ujIuVHB96KsQibfvy0tjEypFP9YKdtDWnaPgLN0eljeIoxtwuFmCBLKPiqGRXjqRa+Su3j2mZw4FjkxLdI7tVZPcl5mDQbHZEGHZUzK9EICf5v0aczje0OqbP6O+WVUXHaO79OF8J2bOu8vW7HhFK4iUbnJCmrPIys9wRjTdtsG1bcNas+5j/rbwrG9ELq8nFNJ4jTVW1azy7pMtJ/+uiNrN7Dqb
 zqCQeIb4
 Pfwbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 02:43:01PM -0400, Tal Zussman wrote:
> Set BIO_COMPLETE_IN_TASK on iomap writeback bios when
> IOMAP_IOEND_DONTCACHE is set. This ensures that bi_end_io runs in task
> context, where folio_end_dropbehind() can safely invalidate folios.
> 
> With the bio layer now handling task-context deferral generically, XFS
> no longer needs to route DONTCACHE ioends through its completion
> workqueue for page cache invalidation. Remove the DONTCACHE check from
> xfs_ioend_needs_wq_completion().
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>
> ---
>  fs/iomap/ioend.c  | 2 ++
>  fs/xfs/xfs_aops.c | 4 ----
>  2 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/iomap/ioend.c b/fs/iomap/ioend.c
> index e4d57cb969f1..6b8375d11cc0 100644
> --- a/fs/iomap/ioend.c
> +++ b/fs/iomap/ioend.c
> @@ -113,6 +113,8 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
>  			       GFP_NOFS, &iomap_ioend_bioset);
>  	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
>  	bio->bi_write_hint = wpc->inode->i_write_hint;
> +	if (ioend_flags & IOMAP_IOEND_DONTCACHE)
> +		bio_set_flag(bio, BIO_COMPLETE_IN_TASK);
>  	wbc_init_bio(wpc->wbc, bio);
>  	wpc->nr_folios = 0;
>  	return iomap_init_ioend(wpc->inode, bio, pos, ioend_flags);

Can't we delete IOMAP_IOEND_DONTCACHE, and just do:

	if (folio_test_dropbehind(folio))
		bio_set_flag(&ioend->io_bio, BIO_COMPLETE_IN_TASK);

It'd need to move down a few lines in iomap_add_to_ioend() to after
bio_add_folio() succeeds.

