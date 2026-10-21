Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CED606A334
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 15:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=kFdhW9k8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=fjGwKxnF;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Afx3HhuS;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=41gz4xnp
Received: by kanga.kvack.org (Postfix)
	id B2D5F6B071D; Wed, 21 Oct 2026 11:07:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE066B071E; Wed, 21 Oct 2026 11:07:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6206B071F; Wed, 21 Oct 2026 11:07:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD736B071D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:07:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0123C80568
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:07:57 +0000 (UTC)
X-FDA: 85346963436.02.3C0690D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id A5F9640003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:07:55 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kFdhW9k8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fjGwKxnF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Afx3HhuS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=41gz4xnp;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792595276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4IL+wAUg2YMioNglotQqAajEtIi50oQ+jrWGTenLzTU=;
	b=lxYopoxX0Wm6DqZoIrCw0M6np9DeUP6DowpfCgyVqACK33Ej8E/y3hHGUJTyX09Pmh1Vp6
	PMBzsEUmN1DuL1LHIBYwDG2BG1o5jvETAJUggqI1CQeVyn2Cd63gIOLaEYdxB9vwZE8Eku
	Kw7nDDJROwUTRD4LLpFcoWYe2cm3C7w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792595276;
	b=V+lMkSKBT5vVPOlsXE38BG4bz/G0r6bO2Xk8e3FsT4VIBqghK0PtlQbvhtqs91CsTS9dv2
	NXvOiKvwcuN8eZctHGTEsNdmnXG/XSV27C1LGm1rSDdbdWEkVRinST4NhZoFqSIGpPdt1+
	JeC11GgHyuS67fuODRVV65kF1Dalvd4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kFdhW9k8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fjGwKxnF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Afx3HhuS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=41gz4xnp;
	spf=pass (imf27.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 04DAA21F93;
	Wed, 21 Oct 2026 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792595274; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4IL+wAUg2YMioNglotQqAajEtIi50oQ+jrWGTenLzTU=;
	b=kFdhW9k85lZxkLuQFkoMN1Di1Ys1mAf090DUb/Ji7ixNmKq/7S+1NpATauaLFaNpF2ZyKE
	tXYT4LFJFLCQW6Wl5eY6+3oDi5TVAEBQBS+HK0BUM8yMIN0itndeky0yVmXyMcz0xLZERu
	JjA5PGnQ6zMwRZ3Avq2mAccSo0Trsew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792595274;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4IL+wAUg2YMioNglotQqAajEtIi50oQ+jrWGTenLzTU=;
	b=fjGwKxnF9K6US9y2Fxt0YOsr+du6LfzBFo8MYsB1tqkvVrOz6L1nti9tJZ0e46/PicKWhJ
	UkJp5qKsFSvUBUAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792595272; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4IL+wAUg2YMioNglotQqAajEtIi50oQ+jrWGTenLzTU=;
	b=Afx3HhuSSFNpkakRqGh9I0RnIMjicwBbxKLXHp6MhGJOvuIdqA/BJL7AlsjoNTaBsB/05H
	z0sM9DHquMUjpDCt6FqUdatEvbRv/JdU/JxnuhdM7WMYaWmTW4LW2MuC06qcQYUS2xxWnX
	3ZCc8J8qQq6KJ/QMrwNHb9GahepSSYQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792595272;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4IL+wAUg2YMioNglotQqAajEtIi50oQ+jrWGTenLzTU=;
	b=41gz4xnpCASbZfXud9a6C7Kcx7fCf3dbp8s0+8/xXgef7skC4pF/NTncrOEb2ewFJVQE7M
	AI7f5EUdBu7Y/pAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CFF70134A5;
	Wed, 21 Oct 2026 15:07:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ixtZKUbV2GrnfAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 21 Oct 2026 15:07:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 59E92A13C6; Wed, 21 Oct 2026 17:07:46 +0200 (CEST)
Date: Wed, 21 Oct 2026 17:07:46 +0200
From: Jan Kara <jack@suse.cz>
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, jack@suse.cz, 
	shr@devkernel.io, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/page-writeback: avoid 32-bit overflow in dirty
 threshold shares
Message-ID: <n6sci6hug3mywpnhcylk5b3fldm3xjekiexwugqgmxx35sotsc@wcdhaetb23jr>
References: <20261021060654.27855-1-dennylin0707@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021060654.27855-1-dennylin0707@gmail.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5F9640003
X-Stat-Signature: h97nn8q6mqbhmsizcnkux4zyjgz1ehgq
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792595275-665630
X-HE-Meta: U2FsdGVkX1/bTCot2w4+hLySTfcmnjXSAnP6xA1b+Vr6A9f7lEEgXcodMSsuYCZf4hx+5d3tT+kjaqGifJvA2/Yt96pgvhsiY0WXqVsyzXXlVYI6vmOXez6wvUnDmfVACy5McvpoT5h65Zu3WuHdyxB2DhQ7MiJlWCwsRxA93a6LVESymxqDIFe0potlfn7eEClOfx/wtIH1QzW3h/PhF5ay+hPNhGbTInx24lhsQUunGolJdAzwePBLd3pjQq88IstmJdHsQRsyM3HbI1TVEZvrdZF+RdmN5v8ukPy3wWbh2Ok8W1uo2ccSpS1B6jo/zAlWXgRo9PmIXW9oF8394Fe8W6x7YO2nw+ENugeshH+dQuBLkA1KC6orSDzVLY6kJFDopeKM8fltbLcyl33fvQJRyDj6sjXEWcaYJG1PGQ6PRfnVGxRtejD/QliVld7xNeans8gqrCGwZd3CnbYSD2gzPj8BuZCrDAjfiy6hSxSHhbZTZXWvz1eggVnFBQcBe5pTNCuCnyX4BPIbOUGcKKsHnVTX/QJWa1xzAbLQJOYqrqdaRCU0ydqxEe+QxvJa3iR8bVDrCurOMvZqJ9yqwINrr76ikYvfUaL3Uh/Gz/VIJHoEZLqE4cDoTKtKQpDO7aWmUTfvLilApaTuSGqZq8YXPtP9Q0msyYex1kbfMzbTUWblCL3D7Aewk+ZmIEgLmPuyQgic5gffFR4cKJuyWhXY14Li9YIibBD30NB5Okg+vQ3vQlydUaxgTZhvnKBorTEWUr0JiePDwHH0ViCpO+m9j4jCh0h7IWUfDhlueeJ+1rCTHnvm2IjipPzGIq5l8bPIUyIEbof/lCHlYzNh6cG/WP1lzRARKJ1c5j3Cgg8OtoiENob2+teozlStMwABI2ycemnP4AOd7uCe7jUFHgyBmQPePDK1CRhdN2dPWlflmYcQm/LBMkXeU7Ha9W6DME5oXrm6f0MIzOiMwL0
 YJ7bW6IH
 U6u1h0O4nLTHcB+L3lLCVsPcbQjXNEG27HprV+u6zpB4f5G4izWr9KkN6IzweVOtm00W1dh4AqGOBFewICNaiaQlsjogc1Dnb+60K6TaDpMLHN4WWLPKEHdafyEhQEyBn5DsW4a8LlNy/lXIujih6S+T/AfxLIM+/e4dyM8u/uzMegRf/OCE/GI+d+ALds3/Ze/N1iZGPFMq3mnXukJXtyQCDHMMMR4I0G4xOHcszlH+Kb1Fp7V571aDlGrChEecoR8Yj2KeG6TOPjYxseZ9IeJ5nFbAzc1GhpL9NPyPmMjWLXYcBeBOO2itmRl4mZJ5hxeBD9qmL3Kze6tSyYwkF05dlC+AFSiCsNKcqbjd79T8xNQ95ENO0N4mnz2Jnkwf9pEpx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 21-10-26 06:06:54, Hungyu Lin wrote:
> The ratios used by __wb_calc_thresh() are scaled to parts per million,
> but the threshold and ratio operands are unsigned long. On 32-bit
> kernels, their multiplication can wrap before the result is assigned
> to u64.
> 
> For example, with a threshold of 25600 pages and the default maximum
> ratio of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.
> The shared threshold and minimum share calculations can overflow in
> the same way, producing incorrect per-writeback dirty limits.
> 
> Use a u64 threshold for the three ratio multiplications and div_u64()
> to retain the existing division order and rounding.
> 
> Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Looks ok. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Use a u64 threshold variable instead of repeated casts, as suggested by
>   Andrew Morton.
> 
>  mm/page-writeback.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index eeab25d6ce36..1d6aab8781a5 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -883,6 +883,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
>  {
>  	struct wb_domain *dom = dtc_dom(dtc);
>  	struct bdi_writeback *wb = dtc->wb;
> +	u64 threshold = thresh;
>  	u64 wb_thresh;
>  	u64 wb_max_thresh;
>  	unsigned long numerator, denominator;
> @@ -894,13 +895,14 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
>  	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
>  			      &numerator, &denominator);
>  
> -	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
> +	wb_thresh = div_u64(threshold * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
> +			    100 * BDI_RATIO_SCALE);
>  	wb_thresh *= numerator;
>  	wb_thresh = div64_ul(wb_thresh, denominator);
>  
>  	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
>  
> -	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
> +	wb_thresh += div_u64(threshold * wb_min_ratio, 100 * BDI_RATIO_SCALE);
>  
>  	/*
>  	 * It's very possible that wb_thresh is close to 0 not because the
> @@ -916,7 +918,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
>  			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
>  	}
>  
> -	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
> +	wb_max_thresh = div_u64(threshold * wb_max_ratio, 100 * BDI_RATIO_SCALE);
>  	if (wb_thresh > wb_max_thresh)
>  		wb_thresh = wb_max_thresh;
>  
> -- 
> 2.43.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

