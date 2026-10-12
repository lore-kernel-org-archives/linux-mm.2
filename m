Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E504ACA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:05:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0F7B6B0088; Mon, 12 Oct 2026 06:05:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0306B0095; Mon, 12 Oct 2026 06:05:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A206B0096; Mon, 12 Oct 2026 06:05:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88AEF6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:05:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 13985160A62
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:05:38 +0000 (UTC)
X-FDA: 85313542356.27.341E6EA
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id BEC4440002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:05:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1q0whWV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDfm5WoF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1q0whWV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDfm5WoF;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791799536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I87OenGAaFJnkdPMc0Xbllbvz4ou1kPWUAGZPj9a3zA=;
	b=k2cvE00uvik6aC42tGbtFwStWwK9x56XQI6XjBT9JteMo+u4Eh+bhGVQQxPOCYmy1cc4Yk
	Xv65ZgoDvuvxQCxBxo5ZNaBxid8YSTLmDbG1Vh/BO8ICivKrfa+pbxhW+0Hv5yGpikY1yK
	ZV7cJfA829NwTxe4hOS0G/izni93r3E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1q0whWV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDfm5WoF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r1q0whWV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=oDfm5WoF;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791799536;
	b=wNa0axwk+/tiaHVluXoGv+mdbQsFnTqngORWKcHpaUJskBGR601uFz1XBZeTuUC/CeNBSR
	JWAeC8Kz3klbJu9Evq7My72Ak2smNQ8CLaKMXUjXMPSXFckq5d5I98pX76NK78Chbw38XH
	OgWGc4D3ZHNOhrSMmMLwFdHR2tVRGng=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 3A5E41F76C;
	Mon, 12 Oct 2026 10:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791799534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I87OenGAaFJnkdPMc0Xbllbvz4ou1kPWUAGZPj9a3zA=;
	b=r1q0whWVMl8ij6FoM8TFSzQ29tEvBKGilCKDf2s7GKOQBH9ojsmgGW8fEnGafxn0G7oegd
	30Hkz3oe6lchrA7DnSGyz/goTqes+dhSABldmeAEutxExa+BY1j2GCw74hh7hYzPfFLfGK
	XZXq+ndDB6c0DMYA5ujyrRQIBkdyBo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791799534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I87OenGAaFJnkdPMc0Xbllbvz4ou1kPWUAGZPj9a3zA=;
	b=oDfm5WoFEyBhtLQb32f150ZS2FgTd3I4sGkIipKcBQeMshmC0V8JitB6yhcWDoUvztrrCh
	HCC2ymsTaMsB8rBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791799534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I87OenGAaFJnkdPMc0Xbllbvz4ou1kPWUAGZPj9a3zA=;
	b=r1q0whWVMl8ij6FoM8TFSzQ29tEvBKGilCKDf2s7GKOQBH9ojsmgGW8fEnGafxn0G7oegd
	30Hkz3oe6lchrA7DnSGyz/goTqes+dhSABldmeAEutxExa+BY1j2GCw74hh7hYzPfFLfGK
	XZXq+ndDB6c0DMYA5ujyrRQIBkdyBo8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791799534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I87OenGAaFJnkdPMc0Xbllbvz4ou1kPWUAGZPj9a3zA=;
	b=oDfm5WoFEyBhtLQb32f150ZS2FgTd3I4sGkIipKcBQeMshmC0V8JitB6yhcWDoUvztrrCh
	HCC2ymsTaMsB8rBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11D4C13314;
	Mon, 12 Oct 2026 10:05:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bq/KOe2wzGphEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 10:05:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9F8BFA1403; Mon, 12 Oct 2026 12:05:33 +0200 (CEST)
Date: Mon, 12 Oct 2026 12:05:33 +0200
From: Jan Kara <jack@suse.cz>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/filemap: mark lockless accesses to mapping->nrpages
Message-ID: <u6yseen7xlqfudkps37rizde44u4yhfiqsoe4vvse734fsgrg4@mdfdypi2xgd6>
References: <20261011112940.455497-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261011112940.455497-1-ngocthang2710.1999@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEC4440002
X-Stat-Signature: anaqi6zm97wuwtt99efk3pr1kxfi555h
X-HE-Tag: 1791799535-7638
X-HE-Meta: U2FsdGVkX1/e86amHm91OKPMn/1LLxKqnNQp2kzPNMxbwBGhFa3UeWgDJ7vwjMjiF00rFP79/XHdRCJd/z1a6h3Sa5p8KDvwoF5IeQDablJ803Gr7uJ4rsDJRGhPzNWM9wEF2an8SNqzDcYFPDtFhERg15DGeMYLjrkDBJb0wILUo4z7Z/PauFyDDEa6Cx+gqYy+uWa++wX7o3hH0tP2TBO/PtNGRxoa75YdC6t9h0lIOVWburM4kKmGNLLz/X9XLI4HYcrpg7/jKQjzdkfsQks+cbbZ9K0Ld1U8/Zin5ZP4xNqDUOEoHMylj9lVkUoej6ED5THZICda9Rc/bcS3SZP/M1rtL0EEmFz9d2AyJ7WnEgF+1Y15oDWArwe46F7lsWJcTf+JvMZccrUdGL3/fwvBUrK3N6GXDLXF8oBkTrMzEFgUCJXipYg1pPgnk9/C/Yx3yM9Q+vmX37NWSkVmLNvgAEI8XXwl1f1kiPgjbxORKXM/0prLgsBHJiIjWJhPd0EfFUYyMzg/3aTClhaR4SVPkt8u2k5FQZy/hluI0ncPqWel2BSMaAA9y5FjFuQchx6csyKsWqCoHP9xIAxAro2NLlgeO8mP9k7blH/tkT/dWgP5+SD5RJ/nKvpXfE2+zz14Z4wSlpTq6pNeqfzD82U64T/lcYRiQAH5EgVFNZ0pB0jVSG/uQLe7gQsG/P83qZb6UfeL6LolD3oPCy1sZeQtQ+rYbYzHekTwxAVehgj2BNXrDRDJS+DiwpUGyhY7k8hOu9QvU+M/o9h62tau0Pz9nCleDYgWdvw24MN5gPVlj2qJ9hELM5Jy29qTQrizllzBfTqMU/UAsvietRe7N7LPqMQJdz6P4bbzYFgVdt/Dnb2kt9LtdmD1n9cJGfMwLOBkRqaJYGXR4VBpLMNHpNaMtqDTkyhW5z++BO6H1X/UbeF2L+DwdZDrMt+1Yg+5Q9cWFkI7XmCzzcxk40V
 1GDFC6N2
 xx8lqvkvk8ZwKJTOsi5wOjNF1Gvfg+/+7KP29irEVHJeh5QhidaXBfdH0ExhPVox2gtTB7ImX6XLdkZ/O8+VBzHfRRAgehqaIlRnYLLCVW+GjnK5bSIcuGCxr4TB37/nWVDpMFS0Tx4BxPFCzaKjD0sc/6/nCFtMYEzptavRJ2v1q2q9X7gEZBeBj7K7SGMnYcETUCtKioMOR8dz00j7+D96PcfYsfhfj29igFK0mocx9AdaYNSyROXTUVULTzZhOHliYosXbaSnWEkQfjed/kwdJaAwMPMIZuPtCn0FxzCPuK2q1UGW66csGCo3E25msnmulZxNp3HBaKqDcHX5HK0HTeEvBD1yPgul+UutxA2KqLoczwUtWfuDH/BUKIzLvs+K2H36FMi9l3cCyaWLaD0k/Gm+BQ/dlyjOKTSc47bex1gZ7fQdH/IpB2LsIZUMsy3BmlTto0Mn5SHVMJaOyvqNyJHIO6lY2Hru3yG20r6hdvUd1nDqbutf0JKm0D5m7NdBtFziMMzXOY4VnrfMzP5BmbNf9sEPd4eeziUy/UDhYJUPSgZc0byw8GX6WY3OGbjLlJTTdFFuFah0nFvO6MlaC48XONLUTiJXt4qvr16ViuSg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 11-10-26 18:29:40, Nguyen Ngoc Thang wrote:
> mapping->nrpages is updated under the i_pages lock but is read locklessly
> as a cheap "anything cached?" hint, e.g. in invalidate_bdev() and
> mapping_needs_writeback(). KCSAN reports the race:
> 
>   BUG: KCSAN: data-race in __filemap_add_folio / invalidate_bdev
> 
>   read-write to 0xffff8881004c4178 of 8 bytes by task 3600 on cpu 0:
>    __filemap_add_folio+0x6b7/0x910 mm/filemap.c:919
>    filemap_add_folio+0x1cd/0x380
>    page_cache_ra_unbounded+0x1a4/0x3a0
>    ...
>    blkdev_read_iter+0x21e/0x2d0
>   read to 0xffff8881004c4178 of 8 bytes by task 3601 on cpu 1:
>    invalidate_bdev+0x25/0x70 block/bdev.c:98
>    ext4_fill_super+0x2ccb/0x37b0
> 
> The same counter also races with filemap_write_and_wait_range() through
> mapping_needs_writeback().
> 
> The race is benign: a stale value only makes the caller do or skip a
> harmless invalidate/flush pass. Annotate the readers with READ_ONCE() and
> the writers in filemap with WRITE_ONCE().
> 
> Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

I think in this case the proper fix is to annotate the problematic read
with data_race() to silence the checker. As you mentioned there's no real
bug to fix so no reason to convolute the code with READ_ONCE() and
WRITE_ONCE().

								Honza

> ---
>  block/bdev.c | 2 +-
>  mm/filemap.c | 8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..d97071160e86 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -95,7 +95,7 @@ void invalidate_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
>  
> -	if (mapping->nrpages) {
> +	if (READ_ONCE(mapping->nrpages)) {
>  		invalidate_bh_lrus();
>  		lru_add_drain_all();	/* make sure all lru add caches are flushed */
>  		invalidate_mapping_pages(mapping, 0, -1);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f55..007fe10b2e1d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -144,7 +144,7 @@ static void page_cache_delete(struct address_space *mapping,
>  
>  	folio->mapping = NULL;
>  	/* Leave folio->index set: truncation lookup relies upon it */
> -	mapping->nrpages -= nr;
> +	WRITE_ONCE(mapping->nrpages, mapping->nrpages - nr);
>  }
>  
>  static void filemap_unaccount_folio(struct address_space *mapping,
> @@ -314,7 +314,7 @@ static void page_cache_delete_batch(struct address_space *mapping,
>  		xas_store(&xas, NULL);
>  		total_pages += folio_nr_pages(folio);
>  	}
> -	mapping->nrpages -= total_pages;
> +	WRITE_ONCE(mapping->nrpages, mapping->nrpages - total_pages);
>  }
>  
>  void delete_from_page_cache_batch(struct address_space *mapping,
> @@ -631,7 +631,7 @@ EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
>  /* Returns true if writeback might be needed or already in progress. */
>  static bool mapping_needs_writeback(struct address_space *mapping)
>  {
> -	return mapping->nrpages;
> +	return READ_ONCE(mapping->nrpages);
>  }
>  
>  bool filemap_range_has_writeback(struct address_space *mapping,
> @@ -916,7 +916,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
>  		if (xas_error(&xas))
>  			goto unlock;
>  
> -		mapping->nrpages += nr;
> +		WRITE_ONCE(mapping->nrpages, mapping->nrpages + nr);
>  
>  		/* hugetlb pages do not participate in page cache accounting */
>  		if (!huge) {
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

