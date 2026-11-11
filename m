Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84787606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=QH5uqhO4;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lCt4eElK;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=bsXRBU1y;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sHcx6RK4
Received: by kanga.kvack.org (Postfix)
	id A13B76B05B3; Wed, 11 Nov 2026 09:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC636B05B4; Wed, 11 Nov 2026 09:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900A46B05B5; Wed, 11 Nov 2026 09:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 694406B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:31:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01153A7C7E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:31:00 +0000 (UTC)
X-FDA: 85423075122.14.EC20949
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id B85432000F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:30:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QH5uqhO4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCt4eElK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bsXRBU1y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sHcx6RK4;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794407459;
	b=GwagoL9NC2wloxWyxjo44mdpKDwskxV42pp/MPQKaewC6Nnm/mpDSuJ2MBMLMS/WTRekpK
	EwhBPZeHJRNe1b5nPZcwpTV+3hzp39582o7myLZjelVftXBR7qbcCu1xcSyJ1MkZvRdeNH
	dwUMYL4tN4+/VkI4ZbB3DqfgEF1Iu6A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794407459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GY6CJAAsVN6OvG5bSqoRMsKEExnDqerjHHITuI2jmDg=;
	b=19QGtX1cystYjpZw17/57MQczjOxVA+N8uNZxAdibuRpuw7H5fBbe3CB35xdgJGZw2fXDP
	8l3l/DsxIUmCDXlVcqSHFi6c8q3uAtVDZoxTvq1KAFYLQYf9JgqWJ08tOR3UHloPd6cHNk
	AvTE6LvLg45gTljBo5rwS1hDRN9KwFg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=QH5uqhO4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lCt4eElK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bsXRBU1y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sHcx6RK4;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 182841FCBE;
	Wed, 11 Nov 2026 14:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407457; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GY6CJAAsVN6OvG5bSqoRMsKEExnDqerjHHITuI2jmDg=;
	b=QH5uqhO4faMVYcawyral8jKfPo4RlI+1R/Mga7XZXRoANKlr2ZiZSAn/yav7zGKcSgLKfu
	bYmC25JQmHPxVnKPWiwPukj869ZVGo4yyZWQoxjbfZ22NS/JbDMZC/HOMnKgC5Ek/ovGLy
	n7tnbSdLo0Uq1lzPe012c9crUdKwTD0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407457;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GY6CJAAsVN6OvG5bSqoRMsKEExnDqerjHHITuI2jmDg=;
	b=lCt4eElKHPNqVqDroWCfcJHD4Z5hrEGjZVxZXxu4mFZWOKO5dTmCRElBmD3J/BQe3DQDSi
	HDNtV7J+wM5L5MBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407456; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GY6CJAAsVN6OvG5bSqoRMsKEExnDqerjHHITuI2jmDg=;
	b=bsXRBU1yAsyOtvuC3UdiSYyKAioDw8zLUZWYh4d9yGrCqE21NmeDxkQPfeTdNNfEWJA2aK
	kDYv+TAZ4hJRDu7N3sSSru8Zg1nPqmIZtv5YPsS4b6GxLCb5ngBLtSt0QqXUYtffhPSTmb
	ky42u/IifaIVOQDj/pYMbzOpkZLF9as=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407456;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GY6CJAAsVN6OvG5bSqoRMsKEExnDqerjHHITuI2jmDg=;
	b=sHcx6RK4cHikLtoOtPts+bYVPGPDFUTPC8zRdAdxuUSHZZdyThHDDFR6xPETrzrlMUNp3C
	uK0J5xnga/t2X4AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 58C1E134E5;
	Wed, 11 Nov 2026 14:30:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dsdTDR989GqFEgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 14:30:55 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 812F622945; Wed, 11 Nov 2026 15:30:54 +0100 (CET)
Date: Wed, 11 Nov 2026 15:30:54 +0100
From: Jan Kara <jack@suse.cz>
To: Zhu Jun <zhujun2@cmss.chinamobile.com>
Cc: jack@suse.cz, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+c4e217748763d41236ee@syzkaller.appspotmail.com
Subject: Re: [PATCH] writeback: mark concurrent accesses to the aging period
 time
Message-ID: <msw5tajltjgyynnpoixzhikfnumbgkoywxje7e552wdh5vpxfu@2g272xypjxmv>
References: <20261111064642.17114-1-zhujun2@cmss.chinamobile.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111064642.17114-1-zhujun2@cmss.chinamobile.com>
X-Spam-Level: 
X-Spam-Score: -11.30
X-Rspamd-Queue-Id: B85432000F
X-Rspamd-Server: rspam12
X-Stat-Signature: n8gbhrz3gcik8fb9kmd51wk4kirby9q8
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794407458-667419
X-HE-Meta: U2FsdGVkX1863wCUyLW/RYH7PxmnIZVzOiHSL8NBbiFq8u4KJUHj/mveUiDQ0eROkYpzdHz//emIZ0bPpUiGu0Z+tn0J6ElPfzSs1v1WPiMNIe0EgciVmuP02P/D5F1cN8/nEnM5RHdL0qfC81riDx9pWxhya6492MDgcTElpRcLxrzyFK76lMiPyjBigJZUOqbAJjMYQrFZxd+5aYpIG4E0FghczivKJYgmjA+yUTQ4FzWvEDTEoPTRZy3KK4SXjtGD0e3lpBxGsyhto+3EYDCzu/ubzAdGvum7IqnjyIaogdwUiTHT19lLlQ4MwEmSVMfp/MhyleN0W3BhCBy0wPh2FCXFbhzkA0SKRKjPP2Ta5/DdKryNap739khPcIrQWzWEXLND2tJYPXd0gENk5P5EWI7+KBSnDcykNUmNnZrZfeAshMzFdmPyYiy7B+alGdyp8F3TWvWegvYjYmZxB7W8H9Wq2IYyvgJZaug8tqy9Q/lnOyE443rzS9h8GMKJGn1V67/HWPPra7WHLJGGpP1zAgxg22eVQjI7SSLmPcPjcSHIxEr9sT7KUA9ikDZYym57dZD8Ap3vHdabCNqbhQdjnP1DGvZ+i3Hcb88nyYevvBeLXw2XdLCb3Lpx+6OxczPcehV8rhK2XQE5Ruma57MmsACVGXjKLXQCbhfE+92FSZrQorEXXZzDeQkJ9yEBNTOlciVPl/huTK6vHSryJ3pbGDV8UKbDRLzj9gu5BS2Qjw66Gg+dJwsYi8HMLiW0iG3eb2l6ibdGaVEAuScOBUhSGVUsyVoo/iM+kJBfNQOxZfuW1Ee5RtEKrvu8mPj0bW697hPSJ2UwVyowdZui2s+s6Rf8soMhVCII/W1OrNlntz+m+u94mKYSBuGZEB50FBPq1YWPRmgFlSLAZgFX9bRsH88zJf/86QqnOSRnWg5sYR2oxVH0mZ5Oe1Lf08Hn6+Apa8xwNJ1TuAmwVVr
 op4huui4
 Nf0A4tEoZaHHiwDCNdUuc1cJ6kIwmBjZP1xikR+IXkmqjPtu2hDl475CyuwSo5PdyCOIxc6DtfFL6aCOXQDEfT70uEu/9FZIfPZ0WxU4ntRm9ZUVmMQycG3rXcn+p24dcPhNGhUIlccN1pV3yxjs3jTPcABCHSPElgi7DNmSBzVuwBvvoMn98W7//gPZX7RhhRuFk5wvPYpIIM7Z6RH+aPwR7Oc1qs9ebmPkGemRkxoAJvfok01uBlZ7nT+tCoLeVu9ph94Io1HZGR57zXEPa6O2AtMdcB7nKXvbLcNu/rgSUJOZY3buC7PF42/5SgV+qnh5XGP0g1RGCSPZ/4rhYM7BPwcNHaCRtlLxUaeN/Z5LOxAQ4psko58lmicfcscVg1a+ia9nrEdeKhyPm7X31+JG/+Us+BNCf7MlRnZkeBV15l7wQiQu5Dvl2lmZusr1+AlmBypdztAYtg8hHHtOvVvvgwcIXUhQ0I3esjrkKFBWqkgY31xFuL7VZkZRawh/lZNMwTHu6/K3xiAPKGklqDUArZ7kmquvb4LzNUGT8RS5GIN6FaQiGRxq1ZmhCE3Z+1ZYpkyIMdkhxe+3mWByCgNF+enw9R0eJo0wd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 11-11-26 14:46:42, Zhu Jun wrote:
> Writeback completion and the aging timer access dom->period_time without
> a common lock. Concurrent restarts are deliberately allowed, since an
> approximate aging deadline is sufficient, but the plain reads and writes
> cause KCSAN reports.
> 
> Use READ_ONCE() and WRITE_ONCE() for the shared deadline. Keep a local
> copy when calculating and scheduling a deadline so that each calculation
> uses one snapshot.
> 
> Fixes: eb608e3a344b ("block: Convert BDI proportion calculations to flexible proportions")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/page-writeback.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 0694ec4098f6..fd75f46f744a 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -550,18 +550,21 @@ static void wb_domain_writeout_add(struct wb_domain *dom,
>  				   struct fprop_local_percpu *completions,
>  				   unsigned int max_prop_frac, long nr)
>  {
> +	unsigned long period_time;
> +
>  	__fprop_add_percpu_max(&dom->completions, completions,
>  			       max_prop_frac, nr);
>  	/* First event after period switching was turned off? */
> -	if (unlikely(!dom->period_time)) {
> +	if (unlikely(!READ_ONCE(dom->period_time))) {
>  		/*
>  		 * We can race with other wb_domain_writeout_add calls here but
>  		 * it does not cause any harm since the resulting time when
>  		 * timer will fire and what is in writeout_period_time will be
>  		 * roughly the same.
>  		 */
> -		dom->period_time = wp_next_time(jiffies);
> -		mod_timer(&dom->period_timer, dom->period_time);
> +		period_time = wp_next_time(jiffies);
> +		WRITE_ONCE(dom->period_time, period_time);
> +		mod_timer(&dom->period_timer, period_time);
>  	}
>  }
>  
> @@ -590,19 +593,21 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long nr)
>  static void writeout_period(struct timer_list *t)
>  {
>  	struct wb_domain *dom = timer_container_of(dom, t, period_timer);
> -	int miss_periods = (jiffies - dom->period_time) /
> +	unsigned long period_time = READ_ONCE(dom->period_time);
> +	int miss_periods = (jiffies - period_time) /
>  						 VM_COMPLETIONS_PERIOD_LEN;
>  
>  	if (fprop_new_period(&dom->completions, miss_periods + 1)) {
> -		dom->period_time = wp_next_time(dom->period_time +
> +		period_time = wp_next_time(period_time +
>  				miss_periods * VM_COMPLETIONS_PERIOD_LEN);
> -		mod_timer(&dom->period_timer, dom->period_time);
> +		WRITE_ONCE(dom->period_time, period_time);
> +		mod_timer(&dom->period_timer, period_time);
>  	} else {
>  		/*
>  		 * Aging has zeroed all fractions. Stop wasting CPU on period
>  		 * updates.
>  		 */
> -		dom->period_time = 0;
> +		WRITE_ONCE(dom->period_time, 0);
>  	}
>  }
>  
> -- 
> 2.51.0
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

