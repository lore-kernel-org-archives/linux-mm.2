Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A441BCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105CE8E0008; Mon, 20 Oct 2025 05:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B6AC8E0002; Mon, 20 Oct 2025 05:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E4A8E0008; Mon, 20 Oct 2025 05:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E27EE8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:36:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B65A9160797
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:36:07 +0000 (UTC)
X-FDA: 84017986374.16.5B02674
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A61440005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:36:05 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GgWDHmOi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yYYNxzeN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xC7Vte8B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3phBpZ57;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760952965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZGrk75lzeUcUPY7bXGOuLVFadRTcXNXHKGPKlcJJIk=;
	b=mo7J9GQejHG3pmI9P+EUKTw3+tiJaC7q4a1jL8alTsyDywFbh6aHDQfsSZsDbbOXmRcihX
	CCKrUVfPtcF/hq1NXHxjujAt+Uq+0tyb7TQenILAw9SzWAwD5S1BrHU//gkzGG2XlYueht
	//tHa1JmOHw3uYBGDzGtrn+GwfU3Egc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GgWDHmOi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yYYNxzeN;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xC7Vte8B;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3phBpZ57;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760952965; a=rsa-sha256;
	cv=none;
	b=x/oFZB49wqDticAXZhN/PJkjXRVw+etYPZng1YEJC/v9ni5PJ5lBZsM1eU92JZrVcxarg5
	QDUU6xH812m7Zkcvk7XBspzVtp/CQl9HBiYnCBj4y8oE3s6MFO2/BZewbAKlI/Zrw/NEMt
	bUFufMk/PQvn8Znn6Ww8M2PD9DLePQU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D6A101F387;
	Mon, 20 Oct 2025 09:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952960; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ZGrk75lzeUcUPY7bXGOuLVFadRTcXNXHKGPKlcJJIk=;
	b=GgWDHmOiUNzNWIHKdVaazAdmxYnL/+OrBB0yIZxLTTBB/tZT4vigET2TkWSdwJLXjsXBw6
	p1bCRjTG8SuSV0mxhUDwNgCqR0jSRNyy0s73aoU8ukWk+SGWxH8pV3Q9CEi8XG0DRlpaBd
	W3fPCX9PexXBAdpWxUsiJFspQP0bVuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952960;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ZGrk75lzeUcUPY7bXGOuLVFadRTcXNXHKGPKlcJJIk=;
	b=yYYNxzeNK+imXBRIhQzhMJbwBsLzZlTDL3dGHsG9mZ8cLlSpRrgpr+HOUnYzahsTrd/wDH
	iiPhYlGGmlclZTCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952955; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ZGrk75lzeUcUPY7bXGOuLVFadRTcXNXHKGPKlcJJIk=;
	b=xC7Vte8BQNOemmEq2ZOO8I4JfrXVqsXBnlEYJmqD8gKlTmqcAm4Qq8uJmFKhAOSJJdUWsT
	o2uiiUo7scqHXncEvhIdDYN9sxjxJCkUPE+UEHSHuSUWlpvLdM/flg+wkHPdwxQ4SxBby0
	JvrsEabewyArTBDBzY71AN1xXfmrbIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952955;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0ZGrk75lzeUcUPY7bXGOuLVFadRTcXNXHKGPKlcJJIk=;
	b=3phBpZ57woN99UzJW/kapoO8Am51aDTiUtiu/hDu8dB2Qn1R4UY0X6o5cbjCIqt+OFNa5f
	wXZocNlQujblr7AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CCB5313AAC;
	Mon, 20 Oct 2025 09:35:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Apf3MXsC9mgeDQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 09:35:55 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8C6A6A0856; Mon, 20 Oct 2025 11:35:51 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:35:51 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] writeback: cleanup writeback_chunk_size
Message-ID: <mf4onihgfgioim3c33d4jvcfixi6qvibqvp7ndp5wefocgwdke@vzjltwrvm47y>
References: <20251017034611.651385-1-hch@lst.de>
 <20251017034611.651385-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-2-hch@lst.de>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 7A61440005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: iy4mmj4ifrq8d7o7gqptdhdmre674he3
X-HE-Tag: 1760952965-462639
X-HE-Meta: U2FsdGVkX1/IDhYunL4KVRntQnCv1gAUuKQYpRzTMrBy3shtzH1N1xqtAj+akxahs7AOWIMH2DPLJj3150Gkx7HAqJjYzx7eRj98FHMTjG0SivjZmrlD3dVygUeA65yyPbRLqGSudeeIbWpBCdjz8QiqGmFqz0mAhWjYf252LNcNGXZVCpEO2X69KvgbvuHO9U5p5Y4sLr2xf4Zh28GK9P3dmXZ/fKFEhBYfqwrsUkls3qXX5DzHdspYB6iAtd7czicqdTltTbknd0S0fnKaFxF6bfvJdwlydi0zMOChFcY/+crei+kgkV7aB1l7klkf/3VmvXbj+FdXk5zsB1N+R7eztwZLx8hzez/9/yBXC6VGNzUhw5t1KgdErSf/8QIcI57APRZiBTDcJlTI+ZmWT64X2H9DKr46lTqW+MTrV5z5r3nCsImsufmjbSpgdZuIdrQVhdQGmDIh3kyiLq+GjnntQKA+bgvAAVbCW83WbhsmrIC3wBYZcyrF3gzWOxkoUyIrTWXH6hrnrqTkwaFrO2wxjZaJC8K2RzTpHlDdzETB/arZQWOZMvx3G2gaqRmVSz4t7aGsq6RF2ivqv5KzSis9vw1poU4ItPgz8HaaNKeTab4YZu0j1De1Q2Tuw+yiC+fovepeFXulZz2Ykvy/Y6o3DL0RLQhPMBgGcwhjYMhJ0Jq7ZQbsZSpoRggRRf+JAHcXFVNmG8z7PaRC95W3xo8Ogd23pmBYJRhtGFVJUgo+QLvvKtxXZoTPJEG2BiZSWAhzbdWiGF3rFWFBxjr5EoPuS92sc4QHmikir1/oqQ5OFq01TC+W/NUu4iXg0t1iGqqWuOCGQPsvA6In/LIiPVhaKDe2IWzYBw/1SppdfrILv+r3xubqFFXZxNFUwSHm9v5Qhtg30q5H2f0gtGesJYPNx6EcNvaFTyI4T8Ag1UOZAXHfkmztr6Mly0o37vAABUMpVoPYdf7j1FoMCXb
 BMcMpSUu
 56F1I+wRqpJHCx1ts6Pf+hnnV8y0rFwcr1NVl4FTwvMj419Qa3Yqh8TKtzbG4ZjTJhDswEbHO0ClQ3e/Oa9Q5oyOetq9z+EMU5tPaIHBNjYs9k1oAkoSNJnRPDn9nm0AXreher32Hhs7eFhiOkU6Syq4MYkfHFJZvqgnLIWmWq1hfXRCz2yGA5ytVYUqE40S4tOpS0YdNQX72QlF0g24Tb8ASCbuLFQEwSWn0LTtraoqYXCnnQiMjuqqCR7qy7qkKC7GfPyxUpGkc0nJhDaYLbeRfhFf9Yb1obm0iCguUw/q68p6Ex038fp22CaPkrxHF1YzspNsm9wXXoH2r6DTUn0tjEPLZgZNBG0eEZgX4rZbHygC3I/3qEJhs1W9uFreQhZPdM+RUqlBL3btELeiVYkiJkz2iPAGoLIVg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 17-10-25 05:45:47, Christoph Hellwig wrote:
> Return the pages directly when calculated instead of first assigning
> them back to a variable, and directly return for the data integrity /
> tagged case instead of going through an else clause.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good, feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza
> ---
>  fs/fs-writeback.c | 14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 2b35e80037fe..11fd08a0efb8 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -1893,16 +1893,12 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	 *                   (maybe slowly) sync all tagged pages
>  	 */
>  	if (work->sync_mode == WB_SYNC_ALL || work->tagged_writepages)
> -		pages = LONG_MAX;
> -	else {
> -		pages = min(wb->avg_write_bandwidth / 2,
> -			    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> -		pages = min(pages, work->nr_pages);
> -		pages = round_down(pages + MIN_WRITEBACK_PAGES,
> -				   MIN_WRITEBACK_PAGES);
> -	}
> +		return LONG_MAX;
>  
> -	return pages;
> +	pages = min(wb->avg_write_bandwidth / 2,
> +		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
> +	pages = min(pages, work->nr_pages);
> +	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
>  }
>  
>  /*
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

