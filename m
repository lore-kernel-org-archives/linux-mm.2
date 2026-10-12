Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A55EFCA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 16:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE936B0088; Mon, 12 Oct 2026 12:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F7C6B008A; Mon, 12 Oct 2026 12:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 665596B008C; Mon, 12 Oct 2026 12:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 390C06B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:24:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAAA7161165
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:24:51 +0000 (UTC)
X-FDA: 85314497982.17.61522BC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id 710E240005
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 16:24:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QJ4RfaWF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pgnCnEIV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l+WQ+Eks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lgbjzvSb;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791822289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pcc0K1tU8VYaYGCB04LjAl4+hE6yspZu5PMHTGHHbVA=;
	b=uNEjbMQUdOArEreeqAw88n7REl4jmK5O4HhFYvnuULwYnI/IpvAxuwx1tB0R7roj6iwnky
	FqU0uzrw2tTAk0v0IHy7QxGgQF5qC1glxz/scuANlgHTUg11Tj5UIbLzCibjAlExqGqLy3
	MXUC/+cuphMabb4mIhZYqxLhNDIUmCM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QJ4RfaWF;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pgnCnEIV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=l+WQ+Eks;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lgbjzvSb;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791822289;
	b=d+I16UpQnl9I22IGmH/ZUsUqHCERYBo/m2bDfkyjzfpHvg3HH5MKffNGxLEwBQYFkGm0U+
	hWLM5LXxD+le4ZhOM1XV2cmQeLqsS/utx/QTREeOCEDOSNdseUBgw+aOyTjI/4094yYflI
	VeW2ftpS/gYCLsDeXOBgJDIp1rK7Mz4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 994ED1F391;
	Mon, 12 Oct 2026 16:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791822287; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pcc0K1tU8VYaYGCB04LjAl4+hE6yspZu5PMHTGHHbVA=;
	b=QJ4RfaWFbTqSr18K2OQ4jQfAV5YHEJQyOQavvQJqWF8xTF9Iuv5UIjUUvRcXM/ZF8et/+q
	JZGRRBwUqS/9elC1XFKQ1zUCcTZnyy5YdHCQVNqpqHz0f/MTxmubKHJ3urpOYY40MQkeKG
	f8Zi5GqB+/7FIgNrlGefXA/o+vriefY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791822287;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pcc0K1tU8VYaYGCB04LjAl4+hE6yspZu5PMHTGHHbVA=;
	b=pgnCnEIVoIrGIyZEWolk7/SSq4ugBo1wuT53iEY96I5vlnn0hHDEVeNLa8CELElQw54hHu
	BxO6cjmoxvn0HlCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791822286; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pcc0K1tU8VYaYGCB04LjAl4+hE6yspZu5PMHTGHHbVA=;
	b=l+WQ+EksmllPpEJlz3vP+B7DDfM98YIBgILa/yhS6DwJjhQhzwbGE6YZS/5NJC+JKBj3aJ
	uMoU7mMksZuYcUrAYiyyUB8JxqsTtJo6R4XFlVn1AP9qajRNYHdSYPqaQQ+5tbdHQsngxw
	L0VQYi6+ORuERDJB/EpYfxtobPYFU+c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791822286;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Pcc0K1tU8VYaYGCB04LjAl4+hE6yspZu5PMHTGHHbVA=;
	b=lgbjzvSbuT2abpAcooVITaYyY4upHIm4g2YMifYz64YXqKhwu7S42phkFxS3UZWqlKuZ5V
	k8rXKzdHjCuzjJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FA2F13314;
	Mon, 12 Oct 2026 16:24:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gSNCE84JzWrJOAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 16:24:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F0405A1405; Mon, 12 Oct 2026 18:24:45 +0200 (CEST)
Date: Mon, 12 Oct 2026 18:24:45 +0200
From: Jan Kara <jack@suse.cz>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Subject: Re: [PATCH v3] mm/filemap: annotate lockless reads of
 mapping->nrpages
Message-ID: <lp3734pwy5uxmjyblon4m4fij2pngztite3plyc5urhfje6t7v@pju2csdvtjmy>
References: <20261012143921.283806-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012143921.283806-1-ngocthang2710.1999@gmail.com>
X-Rspamd-Queue-Id: 710E240005
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: fjtreu569ys68afhcxmaworti9curq68
X-HE-Tag: 1791822289-781107
X-HE-Meta: U2FsdGVkX1/gzKLKCu6TvOXJEDiXSCPgJl5HnHQHkUKar4xl7V1Z0cMiUIeb+08ycY3OQlasr8Z5A+of/LP0MRzi84Vund52Cq3eQMXErCqM5SFlyOx15k5w3V4OEKlZuXJGDNAF9B07fNJQVzTcPlXOt8JRwbOKCcjjI0RvllVtqvnIXHA87J/oanRMKKMKNvHPywT6S+kdSPkZsDOH8xuSk7C5qPr8EGmxX2pyrMxyEotHOEhS0S7Ghc2ot0wqvbHROYEoByDmY+yXSaYonUuAI7kkwJ1cOqWVVHnX63c7PyhgvtXwSXsdrT98gPf7nN0wKSetFxrZlWIGHpD0kVSR9AFhf646GbkZXqzXejIh4rec8HxpZd8GgB+sj8HGg9dNcESlkqF5IZDFJgnrrHvXSDcKGUMtmvEq/5QWmYlKcp+nCbz4IMeDF11n2ZrP1LmGWuikD/vy7OO1RzUBI54uF9m/WUxxNl4wCsAFefxbIfpkYZtLcdPutDV2xUODIWmWHCy3QKlr901HXxP29Yvt25Hov/+S8Zettflbqcp69dcwGmr5vNbMdhOHDtOLBQhG/UBhixWpduSa9FBRDLf9avTRZsmZjB0SkBWs8Dbi+/L5qXzaxUTM8EsIv5sIBocWC3TV7fca8LjLw9iLxBc7EX4KJDUC6xoYM1KO83/sKh+dPBuyY3EhDpkMz49Jc8xOk1SkkrsJEXXuINVksX264y4d59wAh7Q1kzVWSqqGdgKhW2rwAfLEthI7Rki1ZyJ6TVZcAltspL8O0ztiPLAD/SFh672cHmXd0nvev+pyNB4CZYbg7rYEhRnv7dr4qAmyLy5DldCVV4IDMWrfXqPRqDy103plRB9pGI4Dh3ovWDyGjUjgLtLW385GJxzBureRTzSPPLOpnxE/mOF0WZMB97moPfQ9fES9Mbsm1JmBcMlhh3764VQGkrVgaSMG2/R9HpIiy6GgBf9W8Vu
 DWGqSuEb
 rZL+9XRwkDZ26XNl23JO8NIfxHoNmq5h5dfCXkCkNkwD8hQcTLwoxef9jU+SgZQD5ISm+5DLDipN/qWpgg/v7lahWNW5Mqft3KCS6dPqjAhhsRFQ8cfYditR/SK+Z4Pd9q1PmmnZISmx9C6sqfQWLboxDIktZ30aNZnrBswhoxW+epF3rWijicsSa/QrkmhplhXllS4hvzEhqyemIFwIVQaxbvnkJH2LolPFS6TqhtIE4EkCwsFUVpgOeDIMeMvvsuu7gsjvzPvgXPcbPrxJeZspE9+cRt53/2R2CDlpUdTT3qEe6DF95HnqdGnhg0uRXGIRIYrzN9DImlvGNjIb7ls6gQ4PYmMCkqVcONrsduK/ZDlzHFr/yssiPKmY+yn4zMLxihx3A6mf2SNUwZlJBDvRiVSiYFqjx+ObeGGyTms6ACqfU8RO51v55xy5npIo1nrDqXc2xjPQikxZuh8MtYTxSbBn0PvibVtifwgA2uL3SZYBlgKkCVqR3pznQ96dfqSDWiB0C+qBxFL7J+vSY3L/opRyJKe+vXy5APyltlLlDwOIJ37NcJ/8OhNbIV5PK6o6GHlH1mFYs1qc2B030Nj4n2ASCtNArkwux1t573MMtl2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-10-26 21:39:21, Nguyen Ngoc Thang wrote:
> mapping->nrpages is updated under the i_pages lock but is read locklessly
> as a cheap "anything cached?" hint, e.g. in invalidate_bdev() and
> filemap_write_and_wait_range(). KCSAN reports the race:
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
> harmless invalidate/flush pass. Mark the lockless reads with data_race()
> in invalidate_bdev() and in the two callers of mapping_needs_writeback(),
> rather than inside the helper, so a future user needing a reliable answer
> is not silently covered.
> 
> Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> v3: move data_race() from mapping_needs_writeback() to its two callers (Jan)
> v2: use data_race() on the readers instead of READ_ONCE()/WRITE_ONCE() (Jan)
> 
>  block/bdev.c | 3 ++-
>  mm/filemap.c | 6 ++++--
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..233750f87e6d 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -95,7 +95,8 @@ void invalidate_bdev(struct block_device *bdev)
>  {
>  	struct address_space *mapping = bdev->bd_mapping;
>  
> -	if (mapping->nrpages) {
> +	/* Lockless hint; a stale value only costs or skips a harmless pass */
> +	if (data_race(mapping->nrpages)) {
>  		invalidate_bh_lrus();
>  		lru_add_drain_all();	/* make sure all lru add caches are flushed */
>  		invalidate_mapping_pages(mapping, 0, -1);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f55..ff10ac8f56b3 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -680,7 +680,8 @@ int filemap_write_and_wait_range(struct address_space *mapping,
>  	if (lend < lstart)
>  		return 0;
>  
> -	if (mapping_needs_writeback(mapping)) {
> +	/* Lockless hint; a stale value is harmless */
> +	if (data_race(mapping_needs_writeback(mapping))) {
>  		err = filemap_fdatawrite_range(mapping, lstart, lend);
>  		/*
>  		 * Even if the above returned error, the pages may be
> @@ -782,7 +783,8 @@ int file_write_and_wait_range(struct file *file, loff_t lstart, loff_t lend)
>  	if (lend < lstart)
>  		return 0;
>  
> -	if (mapping_needs_writeback(mapping)) {
> +	/* Lockless hint; a stale value is harmless */
> +	if (data_race(mapping_needs_writeback(mapping))) {
>  		err = filemap_fdatawrite_range(mapping, lstart, lend);
>  		/* See comment of filemap_write_and_wait() */
>  		if (err != -EIO)
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

