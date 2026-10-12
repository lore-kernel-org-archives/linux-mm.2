Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 261F3CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 14:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C686B009F; Mon, 12 Oct 2026 10:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 349AD6B00A0; Mon, 12 Oct 2026 10:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232BB6B00A1; Mon, 12 Oct 2026 10:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01B86B009F
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:11:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8286D1C487C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:29 +0000 (UTC)
X-FDA: 85314161898.07.2B3EC33
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf27.hostedemail.com (Postfix) with ESMTP id B573A4000E
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 14:11:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Q/ItDqlP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LRIAU1qp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Q/ItDqlP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LRIAU1qp;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791814287;
	b=x0dpzCH/Z1VCMCTeJMW+acEQVBaq7S5IxX9Kg5PDGYrxKk1XhjTtgSKa89i0iC//mEJr6N
	X67l99PKQe1CEYs/g73VOP0cEk9iTthT4SwInm/swK/fWVK7wNlC0s3ZOjZ976c48MjpJs
	LItIKIlRjWqAhScczwE9hzveb19It9Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Q/ItDqlP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LRIAU1qp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Q/ItDqlP";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LRIAU1qp;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791814287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPswPjxS+qpu6i6zUA1Kx2e7xk6K1phiFUxlGK+8LzY=;
	b=qYi94IQZZc1kBGTw/MMwNWRBad3Frw6YAoX+q6UH3GogdI5Fr9nePh+8ogSgQihtXoC7+z
	3NQ9PYmXY0GySsEVc8FhhnvdorLOCLgIQNZHjCGKOWJIxPOOpmifmNN5MouW9kNN3ZCgtm
	rDUzIlxOXk9f2ZjxuLIWaiKES/P+ENU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F38631F38C;
	Mon, 12 Oct 2026 14:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791814284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPswPjxS+qpu6i6zUA1Kx2e7xk6K1phiFUxlGK+8LzY=;
	b=Q/ItDqlP4+w6WAkwfX1k0X6ujm7G5QavPCe48S224sz6BsucbPMJNtLmPOqv7Iw1sey5dp
	HztsPyQnoX2GdkoGZJjnTzxEzFj1wb6Q9Ul4k04zOj38m0UWtk/PDuaFk9ML5xEJUxkqxc
	qXo4ZqYGAGyU1KkQ1CnYcNqJ7pdJz+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791814284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPswPjxS+qpu6i6zUA1Kx2e7xk6K1phiFUxlGK+8LzY=;
	b=LRIAU1qpo+jKKhvV0DnAfTof5Tws0j22vsCLRZkQC8mjOBkp6Z2hipd8JsI89ugai94uMv
	zISIs3YOUTzdbABQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791814284; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPswPjxS+qpu6i6zUA1Kx2e7xk6K1phiFUxlGK+8LzY=;
	b=Q/ItDqlP4+w6WAkwfX1k0X6ujm7G5QavPCe48S224sz6BsucbPMJNtLmPOqv7Iw1sey5dp
	HztsPyQnoX2GdkoGZJjnTzxEzFj1wb6Q9Ul4k04zOj38m0UWtk/PDuaFk9ML5xEJUxkqxc
	qXo4ZqYGAGyU1KkQ1CnYcNqJ7pdJz+s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791814284;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DPswPjxS+qpu6i6zUA1Kx2e7xk6K1phiFUxlGK+8LzY=;
	b=LRIAU1qpo+jKKhvV0DnAfTof5Tws0j22vsCLRZkQC8mjOBkp6Z2hipd8JsI89ugai94uMv
	zISIs3YOUTzdbABQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CA4DB13314;
	Mon, 12 Oct 2026 14:11:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mJoYKYvqzGrFHwAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 12 Oct 2026 14:11:23 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 55267A1407; Mon, 12 Oct 2026 16:11:23 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:11:23 +0200
From: Jan Kara <jack@suse.cz>
To: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: axboe@kernel.dk, willy@infradead.org, jack@suse.cz, 
	akpm@linux-foundation.org, linux-block@vger.kernel.org, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] mm/filemap: annotate lockless reads of
 mapping->nrpages
Message-ID: <zzneb5ezerl2353crj7xzivjbpdv5vgvqqvxkbvg77nwhdmldn@fenjftsskl34>
References: <20261012120636.16106-1-ngocthang2710.1999@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012120636.16106-1-ngocthang2710.1999@gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B573A4000E
X-Stat-Signature: ax9o685w1h4tbdjhc8w6a79typt9e3s3
X-HE-Tag: 1791814286-746524
X-HE-Meta: U2FsdGVkX1+UCel/KHr12KBHPjCdLprbuYSxSZ6Rb3ouCfolHJCUxc4LkqozcaF9BwTWVyowaowsodn2yOXnwGAZi7R8CrfsJHkdfbA11WQmRMsDnzurMkYMLpLC2Xf3ZLW52EG9TGF51iL2I1QkFV5lMlPb6LknA2enuNgMga4flcoWWd6SNSFSCTHzQ7YxufVeoJvhfAzC6v1PNL2tjP7mQCiFATYYvF09kCIfjJl+ZIxhvGtPy+DR3OssCJUwScBJ/jD4WFRn1ztPDevMm3oMqDNKzPGCkMBwOBqbxRoNj74+t2Df372PUuyBxn4uvNUltwIovDsa0sKsmx95a9inqd42I+7nqDqROr/pMhXCetZzpci+eNF/HmJVoqFAGYCVCOXH1fK1IDb75tM0HK5/Dx5m8YGZGtl7tX8DOXSKnqrw5cGinofxGLbl+baxKRxlb3eHvoBq2KnpsNmNknrf4Isf9G7zxNhyZ7qN3E17dHrKAxGi/Z8wjo1EMzYq0FeGQ4Kl9gYuk+s8d6Zhj0BC+pHqA3j8SIoMGf3kw5MED4iEZpCCKAqfrXRV2sOWW966K4a8dkkBSqDYUZRnByGahFnnWAzJJvZrxNJ51Gsr9VZ2s2ZLmlaYDWB26O+72dFiRubk7HISoc8r46/0Y8YYcnHLj9Oeng05zrEHhYYBB1uCUOED8ksHYkOjiiEtxXrI6QGc9eHuBRHjrAjA4unyZYA+voojRdeEctmIC/D0DqZeqq+wpGNNahONy4wckzwxCV7xPmKLLFxzeuDME+4Q0QJ3o90vPq3jZfzn4Mwwj6DHCzfN/SSpwL02CAI/nBA6N9ZLaKI+T7hgHR/oyOOUnMpyq0S2h9kXWqwGmrKV1A/+osw3nRgd8XyF2SVW1Qg7nJ71IY2NoPN25Pk7E7LhoZXLj1qxav6eZN/4gqfrZro1B8T6KAQjEkl6hMPrEQk8rHrNNvFIBad0eSy
 DYk8mE0Y
 3X0Fy/oR/nTJExSoKup+G/jXVbIGmUhP4z6iRUvrSQHYyY8Yy8FrKK6DM+Nqd8sFwqiU2DyrZtkDPltFX1no7FX3aKCAbjxDkKof9W5XHfZJlqko97gz/QWP/9tagDMXp71ytJTjYY0PyiRyiZaLYQlQZIyetv5nsA8HMIo3r9U9adxWGcBpMwW9pKeacUeh3rIx8A7RoVOtGqYEUrXJ/HOA7ql7M0smAkwMHeGrHPcRtc+JJyz4lcbkJqFjo+gPhdw9l8bE+b++NrIcLsLacoypG5QTE71rqALB0OAxPrP9qaf1oxPu8LPeE++qATUj4H1Fmuz55gl/335+RBi4spaXXCv5oLH8WkaD1VK5Q8Wzt3lppDDbbWEKTGmc43SCM7uFLXWZLmr5ETHXd81kCuFBw/YloN/FvzpaVeo4XLf+jFfScnztCWI//npLfA/eo7nT6QwuapAEKRiKsUx88K5Ad276aZqPKKRJtVbEs/nCDzd2VANPvsUSMGIQtCbl0iHuF4/3CzdNIoUXk+TdPqcFlZm+3rnC+IvXFRcUqwhLAbNz1cG5CW/eytr0BVV/h5RKnGizTU6maNSatTJx37qbPBWG7/w6kDtTXO51d88wiB2g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 12-10-26 19:06:36, Nguyen Ngoc Thang wrote:
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
> harmless invalidate/flush pass. Mark the two lockless readers with
> data_race().
> 
> Reported-by: syzbot+e0624b5bf72b99131402@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e0624b5bf72b99131402
> Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>

...

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f55..4c9d98efb7fb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -631,7 +631,8 @@ EXPORT_SYMBOL(filemap_fdatawait_keep_errors);
>  /* Returns true if writeback might be needed or already in progress. */
>  static bool mapping_needs_writeback(struct address_space *mapping)
>  {
> -	return mapping->nrpages;
> +	/* Lockless hint; a stale value is harmless */
> +	return data_race(mapping->nrpages);
>  }

Rather than annotating inside mapping_needs_writeback() it would be more
future-proof to annotate the two callers of mapping_needs_writeback(). Just
in case some user which require reliable answer appears in the future...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

