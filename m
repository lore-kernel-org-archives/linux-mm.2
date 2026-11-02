Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D418F606D813
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9N+2PTBS;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=9N+2PTBS
Received: by kanga.kvack.org (Postfix)
	id D36D36B05B2; Mon,  2 Nov 2026 16:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0D3D6B05B3; Mon,  2 Nov 2026 16:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23B06B05B4; Mon,  2 Nov 2026 16:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 919466B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:47:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1175416023B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:47:01 +0000 (UTC)
X-FDA: 85391514642.20.BF0AE40
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id E508D1C0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:46:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9N+2PTBS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9N+2PTBS;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793656019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xqTp4LSWoKogSLXQV1jsC4CAleeL27EeFUzHSOi+Tkg=;
	b=Ji6Cl00LatVXrve3Pl/77Q65sFbrOamdx8H5HjNrhBOiLifA6YWetIEt0Akqi47qkTQzRd
	mZVd247DQUzrCQmhtbfK+K7d38DsfGeCcZEE9qyyLF+PXF4H3cPjFYmdVvscmM/rv3qxJG
	5EnVDxKf2XH2fUT42F4aVjalIH8G7hk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793656019;
	b=7Lx1Vq5u0wsfCVIi7En/UEqLNuGTr8INwAux3PxNvllcgNdd/+g42i8XtT0E28vjayAuo/
	LTd6fQdvY0DwMHh3SXFtkmrrMRDGqy6pEpNsq97hO9LR7lbWItuSgIvb21q4fd7JCeNJqa
	x1f5oVYJGZ3Hc97WizhuiNdha2Q/Xco=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9N+2PTBS;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=lAoHfyq2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=9N+2PTBS;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 99A0721F8E;
	Mon,  2 Nov 2026 21:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xqTp4LSWoKogSLXQV1jsC4CAleeL27EeFUzHSOi+Tkg=;
	b=lAoHfyq2YEWUia7YxQQobuDYwLg2VBOPGnIkdJZWeK6RLGQBYdE9i9p1mY89wd30XI88hL
	Iu6DjvsLIQps/2WZ9hsFEp8hXDVdMHfiUeZj+NjqmSY+C00PYTvcayX8OgcFPMHuwGhkYU
	ULMHtgBAaa47J6c0eTzYAmV+UdFwzwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xqTp4LSWoKogSLXQV1jsC4CAleeL27EeFUzHSOi+Tkg=;
	b=9N+2PTBSCsTMROOcsHH7pk6wxwSC+Lge5ZM6Z9MOo14iVbHCPxrR3BTfDi/D3VqfUMzxv9
	rLnddyXEVM+DKrDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656017; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xqTp4LSWoKogSLXQV1jsC4CAleeL27EeFUzHSOi+Tkg=;
	b=lAoHfyq2YEWUia7YxQQobuDYwLg2VBOPGnIkdJZWeK6RLGQBYdE9i9p1mY89wd30XI88hL
	Iu6DjvsLIQps/2WZ9hsFEp8hXDVdMHfiUeZj+NjqmSY+C00PYTvcayX8OgcFPMHuwGhkYU
	ULMHtgBAaa47J6c0eTzYAmV+UdFwzwU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656017;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xqTp4LSWoKogSLXQV1jsC4CAleeL27EeFUzHSOi+Tkg=;
	b=9N+2PTBSCsTMROOcsHH7pk6wxwSC+Lge5ZM6Z9MOo14iVbHCPxrR3BTfDi/D3VqfUMzxv9
	rLnddyXEVM+DKrDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7134C134B3;
	Mon,  2 Nov 2026 21:46:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ns86E9EE6WqEAQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:57 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 17FACB16D; Mon, 02 Nov 2026 22:46:53 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:53 +0100
From: Jan Kara <jack@suse.cz>
To: daejun7.park@samsung.com
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Ryan Roberts <ryan.roberts@arm.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/readahead: keep at least half of the async window
 when aligning it
Message-ID: <747jhqta3plrrx3bfikceoltsewshdpejdei2qjpn3onnvtu3p@cptmb4phbn54>
References: <20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-mm-readahead-async-align-v1-1-109dea6851fc@samsung.com>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Rspamd-Server: rspam06
X-Stat-Signature: tdneirh9bdmdefmjwku8ofh5cxn1fewn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E508D1C0002
X-Rspam-User: 
X-HE-Tag: 1793656018-273793
X-HE-Meta: U2FsdGVkX1/ferYVZn/+iYKPR/Qaw4o2sAj1UKTuO01ggLOB/DLRgzMenhvLY0uXISsLLwFZKTSBHOPW79fcUCXFTwRkurHI86vyn60WgOjTwHfzfVDzwlWobqDebzn5O5nMBDcUd0UUurcRrmRHXZoZgNmeTs89k+hc0GVJfd0k0qyRzg3SJVLUkFvAx6rLn08AjJ/ELL6amgwxdWN2NN0yl+Qfc0YYY2pyHGkWLCFJcLq1qX9Z0FeB1OrVtZyuLJ/Xp/TGMwqgaRBsJyYekh5qiVI9KZDb6nap+kzTUuFQ9vDh62jZEZuGvdUIOXThr5G3SCA0MybUXTMeeUHwce8wEZ04H5szNWGfCDLDtMeesG8M6422XSUuKIZoMSmh9SrRqC6/rv0GviyxUomyO4oKjHjU3tMUcjQ0YwripTEJRt+c9Y1SQd7fUY7CsXyvRXyb7aQb7X1FSqhXkxLCWV+5b+VMhAzUu+DOgE+3fORPCWA0kXCzmA1MMdzJrkV6dG0uu5o+819nCU5RtBa8V266E9/3joJa8eEKUwELwyNESMa6yFADPJVRjlCC0F5B2pzv3mKsO43ObOJaPOSapBFKeg/g2j8ox9JUnL2vTjFQxvDyn9/+lMXE8FU95coZb465aboeUhOvu3dy5d6mkufuZiyZWAiyKK/iA/Q01GGI62t3JWTsDC3tgg0yN+A8EcI0Nvvh+93USEH6Aap4rna8yHLV2SuGCvXBYi9GpWSsjpVhmO14Jg7vB6q4mXRqewk5C4UrLEIDiZvimosdH1ajROP+qbS2Dur2OPjaLD2OU6mwOoWPtZZ5OABDxPEJ++64oWJChnxUQSkQ5IMVMi1pZ7qY1Z+htKSEqEevt2KVfHaJo2WBryBObu73R3vX746Ito7eoNjmwUcKOY/KN1zLoRnrJwdwGKP0MnECgmbbgSiUH2g0PDmObgAQceyWQIDeiUY4o1CJOBm+CCH
 TI4il+Yh
 uJSFXl0+SMe7iKs4da6S4MTXcXt0CN+8l1YornOGOD8iXrZumEJaFu62DCIUlwV6uAWS7+y5xsLiNhZeI2Ir6NkkGtQX4bhcnFruofH513ru59EY03qKQia7nQcYeXj8XsjXAgnCNQJXDD8wmj/TtidYwh1OYhpvfygY4qC/zdv7AAiTCHMeehiw2mXeza4S4RoIn2tDklvQYQME0Iodxosn0l1ePxY1eJT3rAxKoaPOjQYuGoyU8I1m3836hStn/mL0J4neQde2qZnqt45Xpz1LgADLvv0L226pfsM8LnJ9m9U9AiDBjHUi5vEUqOMhfdNXKR154hXo2hP46k2M74BG6VkzdWv/E7bTxIv8pQnEr74o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 30-10-26 12:52:57, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> page_cache_async_ra() trims the end of each new window to a multiple of
> 1 << ra->order pages. A window that starts just below such a boundary
> keeps only a few pages. With read_ahead_kb=128 and max_sectors_kb=512,
> 1 MiB reads after a 4 KiB read at offset 0 hit this on about one window
> in three. They issue three times as many device reads.
> 
> Halve the alignment until the trim keeps at least half of the window.
> 
> Fixes: 18ebe55a9236 ("mm/readahead: terminate async readahead on natural boundary")
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
> Tested on mm-new in a QEMU guest with XFS on an emulated NVMe,
> read_ahead_kb 128 and a cold cache.
> 
> - max_sectors_kb 512, median of 5 runs: reading a 512 MiB file this
>   way takes 0.247 s before and 0.180 s after. The device sees 3329 and
>   1032 reads.
> 
> - Other reads with max_sectors_kb 512: without the 4 KiB read, and with
>   64 KiB reads, the times do not change. Random 4 KiB and 64 KiB reads,
>   two interleaved streams on one file, and 2 MiB reads at random
>   offsets also take the same time. They read the same amount from the
>   device, within 0.3%.
> 
> With the device's transfer limit at 2 MiB:
> 
> - max_sectors_kb 256: 512 KiB reads after the 4 KiB read take 0.626 s
>   before and 0.322 s after. The device sees 6147 and 2056 reads.
> 
> - max_sectors_kb 1024 or 2048: 1 MiB reads are not trimmed.
> 
> - max_sectors_kb 2048, 3 MiB reads: the device sees 343 instead of 271
>   reads. The time is 0.120 s instead of 0.118 s, the median of 40 runs.
>   The interquartile range is about 0.10 to 0.13 s for both. The window
>   stays at 3/4 of the maximum, off the 2 MiB boundary. mm-new reaches
>   that boundary by trimming deeply.

OK, I can see how it easily happens once that we trim the readahead
significantly due to alignment. I'm not fully clear how it happens
periodically. Is it that you do 1 MiB misaligned reads and so we
periodically end up triggering async readahead from positions that are not
aligned to the current value of ra->order?

Anyway, what we want is to align the readahead so that we avoid creating
folios of unnecessarily small order at the end of the readahead window (and
I actually miss evaluation how order of folios changed after your change
because that's also an important metric for this logic). I think the
problem might be that the attempt to align in page_cache_async_ra() is
actually not reflecting what page_cache_ra_order() will end up doing 
(it may reduce ra->order based on readahead size, starting index, etc.) so
the alignment we do in page_cache_async_ra() may be unnecessarily large.
Instead of trying to second-guess the logic of page_cache_ra_order() in
page_cache_async_ra() I think we could pass a flag to it in ractl telling
it it's allowed to shrink the window instead of allocating small folios
and then handle the alignment in page_cache_ra_order(). Hum?

								Honza

> ---
>  mm/readahead.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e55632902..f4da9b4606 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -713,6 +713,17 @@ void page_cache_async_ra(struct readahead_control *ractl,
>  	align = 1UL << min(ra->order, ffs(max_pages) - 1);
>  	end = ra->start + ra->size;
>  	aligned_end = round_down(end, align);
> +	/*
> +	 * Keep at least half of the window when aligning its end. A
> +	 * window that starts just below a large boundary would otherwise
> +	 * shrink to a few pages and cap the folio order. Use a smaller
> +	 * alignment instead.
> +	 */
> +	while (aligned_end > ra->start &&
> +	       2 * (aligned_end - ra->start) < ra->size) {
> +		align >>= 1;
> +		aligned_end = round_down(end, align);
> +	}
>  	if (aligned_end > ra->start)
>  		ra->size -= end - aligned_end;
>  	ra->async_size = ra->size;
> 
> ---
> base-commit: 9c449f885765cf8d80b2c60b1971e774bba51a3f
> change-id: 20261029-mm-readahead-async-align-e491b3dc16a6
> 
> Best regards,
> -- 
> Daejun Park <daejun7.park@samsung.com>
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

