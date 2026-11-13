Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57FCE606BDA8
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=umgMFbRV;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TlBq/+CO;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=umgMFbRV;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=TlBq/+CO
Received: by kanga.kvack.org (Postfix)
	id 66E7C6B06AE; Fri, 13 Nov 2026 05:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E596B06AF; Fri, 13 Nov 2026 05:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554DE6B06B0; Fri, 13 Nov 2026 05:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C1FE6B06AE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:55:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BB2D0A8425
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:55:20 +0000 (UTC)
X-FDA: 85429789200.04.DAEFE39
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 880391C000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:55:18 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=umgMFbRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TlBq/+CO";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=umgMFbRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TlBq/+CO";
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794567318;
	b=KpMzz5Mom4A0DLSOvGR2qhHXw+rf/LAR6J1qC8ou+IYD3WIPREzqslWffl0/6G7lsDvfLw
	lVEtChvnSKAr3CVeUXJj9+L5O43M7+Oegh0gyrflVwrNpFPSYiE3hAD4QNxWhI3APgft00
	1wEwGP7pM42I9/ABjovBLtZGFUcthzU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=umgMFbRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TlBq/+CO";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=umgMFbRV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="TlBq/+CO";
	spf=pass (imf20.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794567318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBrh96JneCB85QRwSH0ue44D5aaTmYW0dbY0hlT+9E0=;
	b=lfoSgWM7IyH7P0Ja3Rs++ofJA+UXL3qHpFVGDQ2BHO9WUcpQzwrlqNfA1v5PiFeQy2EWx0
	YnHr1TdjLT2RD3OxoRthy0qU8jqiffHasaSaivlEIxG8blEwEdhrC14QR2HQjOxfF8uSfB
	+DLkfduZb1qW3ryFCTwHkiAXbVodNQc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0F3351F88E;
	Fri, 13 Nov 2026 10:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794567317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oBrh96JneCB85QRwSH0ue44D5aaTmYW0dbY0hlT+9E0=;
	b=umgMFbRVOQPm7ehXwpvWXZpEFAs863cWC/2ZQwGrgu0F7Vcaar4nmsQ5kvPZk7l7K5rw/A
	yRxIm/BZccK4dRlCtO565LhfAab2lGF0Y4kvjIQ66bDesY1sioh5A3u0Bd9Z5X5mUzTXMu
	fDm/Ha4bbSr8PEme402AnjzFpzuBHB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794567317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oBrh96JneCB85QRwSH0ue44D5aaTmYW0dbY0hlT+9E0=;
	b=TlBq/+COzaMY0uiXRfDSQGdNPyu/YjLzQKM37Jd2LmZKy0L85wS+kQxNPWDodjKFJhXiOE
	+XLddAk3tkl9C0Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794567317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oBrh96JneCB85QRwSH0ue44D5aaTmYW0dbY0hlT+9E0=;
	b=umgMFbRVOQPm7ehXwpvWXZpEFAs863cWC/2ZQwGrgu0F7Vcaar4nmsQ5kvPZk7l7K5rw/A
	yRxIm/BZccK4dRlCtO565LhfAab2lGF0Y4kvjIQ66bDesY1sioh5A3u0Bd9Z5X5mUzTXMu
	fDm/Ha4bbSr8PEme402AnjzFpzuBHB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794567317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oBrh96JneCB85QRwSH0ue44D5aaTmYW0dbY0hlT+9E0=;
	b=TlBq/+COzaMY0uiXRfDSQGdNPyu/YjLzQKM37Jd2LmZKy0L85wS+kQxNPWDodjKFJhXiOE
	+XLddAk3tkl9C0Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DA095134C3;
	Fri, 13 Nov 2026 10:55:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SbO5K5Ts9mpIHQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 13 Nov 2026 10:55:16 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 67FD522C8E; Fri, 13 Nov 2026 11:55:08 +0100 (CET)
Date: Fri, 13 Nov 2026 11:55:08 +0100
From: Jan Kara <jack@suse.cz>
To: Gopal Malaviya <gopalmalaviya53@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	p.raghav@samsung.com
Subject: Re: [PATCH] mm/readahead: don't skip the fallback after aligning
 index down
Message-ID: <ks3uy5pvacectdtlbqnz2bmchocfw2atkx6cvvfrjxsx47i4qe@rhnp4qu3ayhs>
References: <20261113072711.235264-1-gopalmalaviya53@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113072711.235264-1-gopalmalaviya53@gmail.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Stat-Signature: xesaz1wfi1h8ikabuqomyms9muoygs4r
X-Rspamd-Queue-Id: 880391C000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794567318-59604
X-HE-Meta: U2FsdGVkX1+skgDU27RCXHe87hiBciLfCFZHOtQXIIwmtlVNYYua2zhNBxL48hAgDZPXaoBF5qyW3ScV5sL75AfZKwLKibDe/VSTMaDjBghLIN8rFxTBuTdlp1mhNErDYtLTH5z4G3Jfn2wDpBxYG7LoC6cDn3uQp8cMZVWBW1soxQ/mgW2UnaHU7Cxp+DzxZTR5Y2SvdKS3DrlLSqZ4iGIsxjNmP3tHNH7fvHQ2sH5Pss7iZ5AXYJfDBBlSFBifG/+rhutLTXfdf2E0m7MWr1sHPA0/5DZn4QdkGWMZ9MEav39wLk/0m4DkgQsFzhcTywVToLSjC4udoHFAoaIWihZVSKVVTfolTjzKYo8fnDiOOMOs4K9fegJKtlze73LSMvfNgO8/ZK9u3IeAioFqe9+wKKkvhm7QmJQYhlttNwD1K6AM7WNhpe2zaBYjmzhmwC1jTUUAOI2qM7p3eWd5y0Qw/u3Gglnnmjp4aVvV7pFoxGVwaHwkWiargxpIYvK88V4wBj0gdo2b+/fgO8aoK3UfFUDulHQxswRKH+71husylQMAHqKLs9rTgCXhgVVn3aj53dmy2GoEq6afL2rXg5xNG3tR8rbwdiQow/3dNjq3M7w83dqwLmpRYjW7axj8/yWyk6Gqk1giNFqJLQSRg7KH3x21YEFExuxSfXDQqQV/7XaRtgdjVU1dDx4KSf6un/DcByEc6QN7CZMnalwDa/e55gGJHYsLlfmgTuKYui4Z5rBR34krP184fqbRW4vSo3kW/xlVDqVVGR/KBVL8zaPW3Z1PJvZ/vW/Ssl28GCcNsjcP4/eKhjxtNCSsWQ5LHULH7LrIJw8gOguJ7oiyeGP0hM3yjqtv+iubrPLPc3LdNCb9vhAAM353CcBw8fml9uq5GJDlq0AQkB3kklJP1aji0lL1jVy8Fl4XVGDYg0BG9UvV5tPFhR4XwqhnhB8zRzNFWaw3hWfZout/lUs
 7spoIMpi
 9JainVObRaomw6oHn9Nnyp6UldzU/pMl/b5h9r5serby+XXKChTjzVbdDyHlyXY6dLudRq0YMl5+hvLK9a0ni2uY4fcwiif/EL3PITchsCQFBa5NuAjynmQ0kFqiKdqYRy/G5nY9JgUZXZHA16HPZgPjqXWF+UW7FkpcIz+m4ymA3Ui/T4KSGffgUTVOCXx4rdmQNN5z7e6Xz1eBTQQvfjoF+aLQfugABskch6Qg8H1wSD6jvlMvyaEYQXge5SYEh51Kzq+tyQLA4FGui9SpQiGfDYWDRbLbQDqHEw0buLHOCSmiwsVgsA7dzkhJX9hSIcjqRoVup4v2r/rWilQzIuS0wEWAd1tBgWlYPyREEy5i2YHK6/70rhAQWHruA2I5ScSrXcNquTuT5GxRIwr1541BIOAxX1F/yp2EDBkczDN7AfLvIe+oj0mEWqosqPxLXUCek
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 13-11-26 07:27:11, Gopal Malaviya wrote:
> page_cache_ra_order() rounds the start of the readahead window down to
> the minimum folio size of the mapping, so on a file system with blocks
> larger than the page size, index can end up below start. If adding the
> first folio then fails, for example with -EEXIST because that folio is
> already cached, the loop stops with index still below start, and the
> check before the fallback
> 
> 	if (ra->size > index - start)
> 
> wraps around, so do_page_cache_ra() is not called and nothing of the
> window is read.
> 
> For example, with read_ahead_kb 128 and 16 KiB blocks, the mmap
> read-around window for a fault on page 1042 starts at page 1026, index
> becomes 1024, and if pages 1024-1027 are cached, pages 1028-1057 are
> not read ahead.
> 
> Compare with the end of the window instead. Where index is not below
> start, this is the same check and the same number of pages as before.
> 
> Tested in a KVM guest (x86_64, 2 vCPUs, 3 GiB) on mm-hotfixes-unstable,
> with XFS with 16 KiB blocks and with ext4 on virtio-blk, read_ahead_kb
> 128. A test caches page 1026 of a file with pread() on a
> POSIX_FADV_RANDOM descriptor, then faults page 1042 through a mapping,
> and counts the cached pages of the window [1026, 1058) with mincore():
> 
>                                        before   after
>   XFS, 16 KiB blocks                      6       32
>   XFS, 16 KiB blocks, nothing cached     32       32
>   ext4                                   32       32
> 
> Tracing shows the fallback now running after the -EEXIST, as
> page_cache_ra_unbounded with index=1024 and nr_to_read=34.
> 
> Touching 1% of the pages of a cold 20 GiB file on XFS with 16 KiB
> blocks, at random, at a stride of 2053 pages, or as random runs of 2
> or 4 adjacent pages, reads the same amount before and after, within
> 5% over two runs each, at read_ahead_kb 128 and 8192.
> 
> Not tested: other block sizes, other file systems with large blocks,
> and other architectures (built for i386 only).
> 
> The problem was pointed out by the Sashiko AI review of an unrelated
> patch [1]. An AI assistant (Claude) helped with the analysis and the
> test, and drafted this changelog. I reviewed, implemented, built and
> tested the change.
> 
> [1] https://sashiko.dev/#/bug/linux-da6e8836-f808-4b39-9f04-de52995a0162
> 
> Fixes: d5ea5e5e50df ("readahead: properly shorten readahead when falling back to do_page_cache_ra()")
> Signed-off-by: Gopal Malaviya <gopalmalaviya53@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/readahead.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 6e55632902..afcde18316 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -552,10 +552,12 @@ void page_cache_ra_order(struct readahead_control *ractl,
>  fallback:
>  	/*
>  	 * ->readahead() may have updated readahead window size so we have to
> -	 * check there's still something to read.
> +	 * check there's still something to read. Compare with the end of the
> +	 * window, as index may have been rounded down below start to the
> +	 * minimum folio size.
>  	 */
> -	if (ra->size > index - start)
> -		do_page_cache_ra(ractl, ra->size - (index - start),
> +	if (index < start + ra->size)
> +		do_page_cache_ra(ractl, start + ra->size - index,
>  				 ra->async_size);
>  }
>  
> 
> base-commit: 76f5384740b2fd9ee5d71da9d49b271d37c5a51b
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

