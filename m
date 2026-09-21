Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893C2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:14:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59A526B0092; Mon, 21 Sep 2026 05:14:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54AD76B00E2; Mon, 21 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43AFC6B00E3; Mon, 21 Sep 2026 05:14:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E82A6B0092
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:14:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2EAE12059D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:14:09 +0000 (UTC)
X-FDA: 85237207818.14.E788B0D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA03D180007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:14:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DNa3q/Q2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/S1oWP1";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=knIrBfKr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tUVl2pxi;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i/5Hx42b5N3HMo+IBhECiBj3UiF/OOn1jXG+HpXUr1U=;
	b=mCarhTUvWdzlOf4WMnNZdA7aGJ2NzRN0ZkdlHK8v1rNVJ7BRtVoKuhVQphfpyaNGAM3s3O
	+EqhbSlZeavunpQnLCZ/UZw/ExH+w6c8+9+HypN4AJSHrae2lzcyY2EXPqDFydBuIxe610
	d6jcNqYWasIhut4wQJib865e2MhanNc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="DNa3q/Q2";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="k/S1oWP1";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=knIrBfKr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tUVl2pxi;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982048;
	b=flg5gi2qvbhxh5SVFnta4DX6HDkAhkXRsL6AvElKzUO0GxrJhlq1XVva3rdhuDN8jVTxdd
	mWkMlvh4p8b50ic9p/Dtf37pOPLqiJ3hnyI4eL/rzsQ83qo6Qb7Pw2nB8Vs4WQQxFwIJCG
	RkI2YBas9kwG1rInp6qfNy21X07L4p0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 22D071F7A6;
	Mon, 21 Sep 2026 09:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789982041; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/5Hx42b5N3HMo+IBhECiBj3UiF/OOn1jXG+HpXUr1U=;
	b=DNa3q/Q2mQrdJDulb7ILXu9DQAyp4WnXQOjkCKeVKYfxB8Dy8oj381xE863wWctCCuEmWY
	PaIRD/hmYGQ5FPDv0wa2o/B/qj6Tm37aIh9aaEHrn6YNnuNpoOimH/ooot4V8r9nEDGYtJ
	BSjpQQ4bkh1zKAIDraG5Jfq86AZ3+o4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789982041;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/5Hx42b5N3HMo+IBhECiBj3UiF/OOn1jXG+HpXUr1U=;
	b=k/S1oWP1PxC9GXeq4HKLKMtStzinjSvABUTOHxH29kpIjE413Lme89yTCRz8woozTtS97B
	IuZiIp2XStrcOXBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1789982037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/5Hx42b5N3HMo+IBhECiBj3UiF/OOn1jXG+HpXUr1U=;
	b=knIrBfKrHxOnwGZAq+XJFyc0VZ5gOFAI1fDk4pKI5OlRdzVbArHKtfudFX6UphG9+YiVNG
	pBGSHncjAMjlI9tXWq+yobVeE6bIbVf3i3tOVGg4/ddmQupMNmUiKO5qp8B1wZziS03nYF
	YhI2X0Pgd8o5LpsrTpkZokMk57de/F0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1789982037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i/5Hx42b5N3HMo+IBhECiBj3UiF/OOn1jXG+HpXUr1U=;
	b=tUVl2pxiQhApmw4qVxjXVL3Pgcp9okmZZZ02vOvWVNBV6cCNb1MKt4FxAtaIt+eBoABgTV
	0sfppbXjKKnqCOCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EE4DC13793;
	Mon, 21 Sep 2026 09:13:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZYtQMlT1sGo7aQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 21 Sep 2026 09:13:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 7D1C1A13D5; Mon, 21 Sep 2026 11:13:56 +0200 (CEST)
Date: Mon, 21 Sep 2026 11:13:56 +0200
From: Jan Kara <jack@suse.cz>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	willy@infradead.org, david@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, riel@surriel.com, shakeel.butt@linux.dev, 
	kernel-team@meta.com
Subject: Re: [PATCH] mm: filemap: move lruvec accounting outside the xarray
 lock
Message-ID: <uomya4f3y667udbs2oht4p5jchbqmqah564infihegebl7jvq2@7h4g2f3gbdhh>
References: <20260916125122.2696271-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260916125122.2696271-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Stat-Signature: eu66k3x7u6ezrk5117rdxco6ee4fhmap
X-Rspamd-Queue-Id: CA03D180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1789982046-228570
X-HE-Meta: U2FsdGVkX18YPZObw89Z/2+q7eqCu0CQtw1uyps8BGgAQrzjmm0ui6UNIzEiCNRSNydK7kO5jKbwE6+GSO9DPmTy2IBU9dwpxVAQZJtPuvYsWRKI8vb8iriJADJnQba2IThHUldvcwlk4990ssmSmBix2zM6jKZLNJExVYTe5CBVKCCcVm3LXYVKNFX6qDXbxWrMX+jo0MKbO/Cur4DfsdaFmJnUN7964UepiUWovJM2GhvE4x1eHjTOoNhla7E8fI1ce3JGC+gEWgMu+E7zrpt6wRZy5+AC5E2EXSi7gPDRh5ReNsVxqeClkm0l2PgXdrwm3FF3SKyElm33Uy9HbMTxYWaqCpmuK/Xzym4vlx5l2jIod7Qv5tzFJosATyoBtsW6a/j86ImzoymjmKa46x/5OAgHRZKXr+XcSu0fh3E/MisnUodgdJUOxn7G7pErSEXLxaPc/MPvZCsZ/OCzTsnq+HDOrM8JdA/9N/swefv4epG3U3dX1cJoxI40P08duFmYmO/SurTqm/RWhnseQy5NDdMI0zr2UOPlk2Lis0I1GD1SIY6uAbCs7w6KEm4Kxf2m/4zOT83wDisytO0nn7xdVcXZCDpLKheihulyDChLKxeeawiq7p8XnzeYg8RsHaD7QPAt60TNtxf3/EClyFfZojEpsMv1XxmpUc0pqI8saXLjdng8JVx8fypGnS4aNx1s1Fhcmuv7LF67aMJ9Q96GcdIQNO6MEbylZUaQCTocglKrzLCGeJtc629Z0EHDoMEIDrJD22kpRJdFlq07QYaEdWyhrZHO+4p6pd1Seumnbef5JZIi7iNvIkMMpD4x0ssCXP5jDWttUvnFvjrx6NZqNYSInZ5IALNGWglKZCWtFvnq1w09H4VrXqihkyzwzsIKU3dTKAz0SoJ2IMvn6vRGPvckr436MUSL/XiZElA1qKpdg+lnXeieoHft4cBNhz4x5UEWF6SRAFL9nVQ
 cFKJVEAq
 94ua4f0gVj6zzVce9D2B/jNzf6KG8Tn4at2DMTTrAX8Cdxbvp0XjXCIjARyABD3FumuZCXEN4mpndKdbjVZ7dnNRjUdzHQQ1bdYBCtWG5ERvwPs+O7hHzygIO/nnPnqp27OOLXrTxc4g0g7xkDIxpep70sPi9BXmwWmE3s9pzdqavCVmzWaxKXD1CdnUfV4fQe9gVcsCCKNFlyLg6Y8A4x2ryqgXCZ3DT3Ur4XI6WSVbRgwHQ168x+GGVgldJvdlWY8EZH1jm9Tk/70eZKEpY1KZDA7Sc/R4uIxJsDeLVpMQWg6tg4ypranAztMZWDXcn8+yMmzgZG3RqyOxbuaYoGPWiIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 16-09-26 05:51:22, Usama Arif wrote:
> __filemap_add_folio() inserts a folio and updates mapping->nrpages
> while holding mapping->i_pages.xa_lock with interrupts disabled. The
> XArray insertion and nrpages update require the lock, but the lruvec
> statistic updates do not. With CONFIG_MEMCG, those calls also update
> per-CPU memcg and lruvec counters and notify cgroup rstat, extending the
> critical section.
> 
> Move the lruvec accounting after a successful XArray insertion and
> after xas_unlock_irq(). The page-cache references pin the folio, while
> the folio lock keeps folio->mapping stable and prevents removal until
> accounting is complete. This moves one lruvec update for ordinary folios
> and a second for PMD-mappable folios out of the serialized section.
> 
> In a 30-second system-wide perf lock contention -ab capture on a
> production host, the hottest caller-stack record attributed to
> __filemap_add_folio() had 20,867 contentions and 557.930 ms total wait.
> That was 14% of the 3.998 seconds of aggregate lock wait in the
> capture. Moving lruvec accuting outside of critical section should
> help optimize it.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 00fd89cf6f550..4720bbfc1a663 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -918,14 +918,6 @@ noinline int __filemap_add_folio(struct address_space *mapping,
>  
>  		mapping->nrpages += nr;
>  
> -		/* hugetlb pages do not participate in page cache accounting */
> -		if (!huge) {
> -			lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> -			if (folio_test_pmd_mappable(folio))
> -				lruvec_stat_mod_folio(folio,
> -						NR_FILE_THPS, nr);
> -		}
> -
>  unlock:
>  		xas_unlock_irq(&xas);
>  
> @@ -942,6 +934,13 @@ noinline int __filemap_add_folio(struct address_space *mapping,
>  	if (xas_error(&xas))
>  		goto error;
>  
> +	/* hugetlb pages do not participate in page cache accounting */
> +	if (!huge) {
> +		lruvec_stat_mod_folio(folio, NR_FILE_PAGES, nr);
> +		if (folio_test_pmd_mappable(folio))
> +			lruvec_stat_mod_folio(folio, NR_FILE_THPS, nr);
> +	}
> +
>  	trace_mm_filemap_add_to_page_cache(folio);
>  	return 0;
>  error:
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

