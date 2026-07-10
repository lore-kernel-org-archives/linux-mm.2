Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94C2AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 17:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0C56B008A; Fri, 10 Jul 2026 13:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD036B008C; Fri, 10 Jul 2026 13:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEAB6B0092; Fri, 10 Jul 2026 13:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4542B6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:59:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C09291A0521
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:59:00 +0000 (UTC)
X-FDA: 84973628040.19.00B4A64
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F065180005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:58:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRLKMdLm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fj8lmu1B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRLKMdLm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fj8lmu1B;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783706338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3qdjxGZy8Qv4WzY+B8ukWnDTD5tkUtlsYdD4cIzwMaM=;
	b=qQfWpVnMTjyok676gipFgpL6GsWsoh0pguVAQP2GqLfTRhC0yUx7OidR4nc2t9YbkVfJPI
	egJxbA+RCSlfG5U72SOZ0YNyvllMXYSK+foLn2SuJbq3E0p0pbJqKNtG5O7eN7D/1qzqp3
	1bbatmNP/YeSvZiqFRHVSTgcYTx4b3A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRLKMdLm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fj8lmu1B;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=RRLKMdLm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Fj8lmu1B;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783706338;
	b=giOVIhzwVLAA+smmsWdec5OcImwuG6x08dHMdFSOKKQyqKfnH6BA6bhUDNdZZ1+kt5gr3v
	1qQW0WixhZDTXKddFFdYxneGTAiiLvApiqHPk2u3zewOXQoYHxTWCA3TZrz7j2RUl4bltC
	r8RVPO+cQPgtvePHmABcczBBQO8T2IE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5AB84768AB;
	Fri, 10 Jul 2026 17:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783706336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qdjxGZy8Qv4WzY+B8ukWnDTD5tkUtlsYdD4cIzwMaM=;
	b=RRLKMdLmjQpkBc0z1jE9eDk79r9fwZuIUZGtzOsFuqZFCVZOEaiItby7LmjnYcsGPlNSjM
	sBexDruisZmtJ8vWaENaeB9K+/uQIfsQUaAyhUEUqse4jTOdwhl8NPDnFmHYIJxKhLYaSx
	Gskb+XTvNzkm4fSOek28cKr9wwuMMRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783706336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qdjxGZy8Qv4WzY+B8ukWnDTD5tkUtlsYdD4cIzwMaM=;
	b=Fj8lmu1BSsZKb+k7AA/Nyc1EninbYd7LYJHW2y7h9JCDpr7UjHmRLleYUDuiMlpwjt6Kco
	hdw8nH8lNfwWIDAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1783706336; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qdjxGZy8Qv4WzY+B8ukWnDTD5tkUtlsYdD4cIzwMaM=;
	b=RRLKMdLmjQpkBc0z1jE9eDk79r9fwZuIUZGtzOsFuqZFCVZOEaiItby7LmjnYcsGPlNSjM
	sBexDruisZmtJ8vWaENaeB9K+/uQIfsQUaAyhUEUqse4jTOdwhl8NPDnFmHYIJxKhLYaSx
	Gskb+XTvNzkm4fSOek28cKr9wwuMMRg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1783706336;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3qdjxGZy8Qv4WzY+B8ukWnDTD5tkUtlsYdD4cIzwMaM=;
	b=Fj8lmu1BSsZKb+k7AA/Nyc1EninbYd7LYJHW2y7h9JCDpr7UjHmRLleYUDuiMlpwjt6Kco
	hdw8nH8lNfwWIDAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 53219779BD;
	Fri, 10 Jul 2026 17:58:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DVRCFOAyUWqsEQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 10 Jul 2026 17:58:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id F3943A109F; Fri, 10 Jul 2026 19:58:51 +0200 (CEST)
Date: Fri, 10 Jul 2026 19:58:51 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: willy@infradead.org, jack@suse.cz, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove wb_writeout_inc
Message-ID: <4eureaes3mp7uhjpdd3sbcvrtgqorbfo7flr3yisbivom2bvoy@elrlq6ommqax>
References: <20260710051052.1839523-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710051052.1839523-1-hch@lst.de>
X-Stat-Signature: m8ybdmufg4m1fnc59rw5aqw8otuwjy1w
X-Rspamd-Queue-Id: 3F065180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783706338-499146
X-HE-Meta: U2FsdGVkX192/kVAHM8B3cYltam0Vt6GRNRqMeGGObHKuKDAVPvR+rPmOtBiD2G8+3NigZICPdb9pX1TJ2OkY1SYx+pX3bTyej9Oo6XsRmQ5AGYG/HQM9shGGsxQCz2Gyuta6ynicQflsGVKo5FMewc6KK9kQMlEOsfMwH1XqrH3IhcdQSgacieNxhj8acF/yINtMNLN8Okh/q/KPEVMgse/HCjt8VEoT26wYBJrhhqc4S3jNbWcdnFWEUVaiCqe5ikAZjgUYdCIgt4Kkh8velzL7iy8SeQYnZKODw+gA/MGS1FL9bYCNp/c5gC003qvys80l+YttiHecoThqsc4GS4KVRFsx/aSW8qKpuf9OPgogmuP2V2numXrfLS4FCvU8cZG+hn2Z8X05olN8W/RZP84sWY19mYI0cgNIXmi9DcqnxgINerBP2cuW7koGS/72ACaBrEmDUutCIfG0aK/22kxDZOh1JmB/KjSz96sP3/pyKaLtt0yeri6HoKTuSVAULGLOUDJvFjYuHnghltbtRBus96FBLgL5YYPVXXpZwruKltl0YPDgONy0dyZVWlLo0uRqAnj9xdlvjGiZeveTsbvRPZBAQuAkGWAeoGYuyfbfvIhn14X23/0jLQ1yDqLgVSxoDcAyPNUdT2BE1ItuSby/9G3Ac8TvRDAD8OQTaraujFQbvKXa2wlsOyG2cOUl6xLPwUFrN9t7O1UPxt+cVQBnd23JpAV/lvwupT1cSz1mrpcqB0yQWfb+5oKZFd3FtDMdjARBamylW/KmF2kJj3sfRLKASAf+RDmPFhhMiMwhKeF3cb/imc1FFXpmC5/ab1KX8Qi6TFLI5N4WocWCDBc6I6Db/woguz9zQU62ZTMTkqZSqBYBjt/VPpF4DJEi+esmvNRVCoELOhHug1BO2Rk6LqTIvvxNr08BQtEyHS1cLa3iPM3uwfmAQeKLJXmYAE5qX4TtJFGiKKHd4V
 FJVn9+yU
 BlpM+pX66xaPG0OLJkyNs0V7AGq4D+uNm6Y3iwJDsitr+u0mal2sdskX5ggf3WhmbrrVd522O3sFM/PWB2wnrQ1JpZ5Wubqcg6i6wRtHZP9+dNrGYzcIUf6cIuE8wGdaHS+Q3HrWu5/30/KJzA4x6TQE2Bk3U7AE4v9J0/h8tZFfT0dbJo/9siz9/b6h5H2w+L+aErpWwHV+wd0ITAfXQzaoG1qRtyxJg/cSjzgtJYNk/WrqI7Xsh3Y+o09lPWu8pWxiMO0Y69Y5lk5cmhszAXqPc3iPg+U4o+Od4cUkOK8FWIqNdpQnVVRfHtJu5vOEcR/1T1GUW0df+ZkKLqB4wc+cg6AATFYmmwKuc4w9AND2ZDKZo5Gptsi/puUhpdmzVeeE3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 10-07-26 07:10:52, Christoph Hellwig wrote:
> Remove this entirely unused but exported function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sure. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev.h |  2 --
>  mm/page-writeback.c         | 10 ----------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 5b7d12b40d5e..c2284466e7aa 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -76,8 +76,6 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
>  	return percpu_counter_sum_positive(&wb->stat[item]);
>  }
>  
> -extern void wb_writeout_inc(struct bdi_writeback *wb);
> -
>  /*
>   * maximal error of a stat counter.
>   */
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index e98748112d1e..47495be68598 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -584,16 +584,6 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long nr)
>  				       wb->bdi->max_prop_frac, nr);
>  }
>  
> -void wb_writeout_inc(struct bdi_writeback *wb)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__wb_writeout_add(wb, 1);
> -	local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL_GPL(wb_writeout_inc);
> -
>  /*
>   * On idle system, we can be called long after we scheduled because we use
>   * deferred timers so count with missed periods.
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

