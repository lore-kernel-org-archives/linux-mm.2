Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47224606D818
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 21:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b9Dy6Zmv;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=b9Dy6Zmv
Received: by kanga.kvack.org (Postfix)
	id 40C4A6B00EF; Mon,  2 Nov 2026 16:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BDC86B05B1; Mon,  2 Nov 2026 16:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF286B05B2; Mon,  2 Nov 2026 16:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB3056B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 16:46:47 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60B4F140211
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:46:47 +0000 (UTC)
X-FDA: 85391514054.29.27C6899
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 34A4B40004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:46:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9Dy6Zmv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9Dy6Zmv;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793656005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbOlEoeEjn4AmnKwJIfj7iQ/wucai9bwBp3Ox/nzMzA=;
	b=3YJmuvOq7ZIlExrgCSUrojMFumBjU+GjIX4tDlhCjOE5zdhW1jCV9XLtmPIE6Lpqmqi8Ik
	c0DAQjnICCAbMjhA+XmHhQieIYmD2qOHJhjBWVMtnelTTypLi7Dt5qsu7F171e9pAFzFr3
	9566Pwmsn8v/SfVcPdEhyW8PfoSvFiI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9Dy6Zmv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KnQgBc5L;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b9Dy6Zmv;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793656005;
	b=XIVGhewQRVaQx4HVfAIGe8xWCGNp8n9oOPgxv89b8H0p7vbtpU8sAsKDlvztAyEZoSBZve
	MFs2IrRZ6dT024hSBzZOpEE0fVeCSa3erpADbUIJpHuXDbWf/nuON4mJ6cPL+LkW1cpqn5
	bOs/31J2NCHwkAT9F0Fsa8QfuNNMlbg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3A411FB0A;
	Mon,  2 Nov 2026 21:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GbOlEoeEjn4AmnKwJIfj7iQ/wucai9bwBp3Ox/nzMzA=;
	b=KnQgBc5LSsfJB0vBErHP4sXiwRevi1h4AwYob2DboFHAo2gNhr4DMvTb/zodgjrfgN08h0
	xkSaev+zFffkbIepELvuAWCWQ7bZbqK3uE+15+MBwXr8Gu7WDJVi20W7eXK8R6RTmz+VFu
	mq3hjR+FGMzjR98w9uDe3yyK+Hcmjjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GbOlEoeEjn4AmnKwJIfj7iQ/wucai9bwBp3Ox/nzMzA=;
	b=b9Dy6Zmv6zas3gtle7HmkEI71NHDs135kPvAFgqTESsMQP1iAfIAOKsOC066PRJG2GxyLM
	0WCCYUoyS7Df5CDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656003; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GbOlEoeEjn4AmnKwJIfj7iQ/wucai9bwBp3Ox/nzMzA=;
	b=KnQgBc5LSsfJB0vBErHP4sXiwRevi1h4AwYob2DboFHAo2gNhr4DMvTb/zodgjrfgN08h0
	xkSaev+zFffkbIepELvuAWCWQ7bZbqK3uE+15+MBwXr8Gu7WDJVi20W7eXK8R6RTmz+VFu
	mq3hjR+FGMzjR98w9uDe3yyK+Hcmjjc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656003;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GbOlEoeEjn4AmnKwJIfj7iQ/wucai9bwBp3Ox/nzMzA=;
	b=b9Dy6Zmv6zas3gtle7HmkEI71NHDs135kPvAFgqTESsMQP1iAfIAOKsOC066PRJG2GxyLM
	0WCCYUoyS7Df5CDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A917E134B3;
	Mon,  2 Nov 2026 21:46:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id E7BdI8ME6Wp3AQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:46:43 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 58D03B16B; Mon, 02 Nov 2026 22:46:43 +0100 (CET)
Date: Mon, 2 Nov 2026 22:46:43 +0100
From: Jan Kara <jack@suse.cz>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: clear page cache marks once when removing a
 folio
Message-ID: <zchm3kq5yykwhxbqgdr5sqkws2bp4qjmah4pcka5ancv4isk2t@co2erj67xpoe>
References: <20261030-bug-mm-filemap-init-marks-once-v1-1-699835fc6690@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030-bug-mm-filemap-init-marks-once-v1-1-699835fc6690@gmail.com>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 34A4B40004
X-Stat-Signature: wwi7hqr81o5166b3suus9roz6cbzczo5
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793656005-235974
X-HE-Meta: U2FsdGVkX1/2Ixg8cClC/3C4ZKzE3z2JjMzbnfCLgh8fw9wvSghsLB8geTdBtHyzCboJGh8KW5fkYz/mF3epZivHRaSaQXjcuDTd9p7sDzrY2d4N9Das1oiBlj3gGqoXCe4+Vz3pHsFnvIkVyGIsyQB77mujis8/5TtnsXaXI7islzM7op+YWTnEj7KDRJ31sBXVqhVKLCbOmnEVT/ots0JeBxggtdOgayNfiaXdJZYZUxdgNBeR7gK7eJc/rKn4yVQ3c+8WgSWhvzTkihABR60KH08zYSKbhQYBgHrWC6ZFS8GbK38eCOFL7Q8Il7S6TtrHBSGqdIrSLfd8NKMqjQh3fyUNsoXffA7UlppkVU4pgScH6r9cBSS6g8JfKL4VVrKKfNHPxFBosRsEO8odKmJJUfbRF5L0dsv2QKRFwVLKPUGd1WAwdZCaAgzJ9qnlA3lp2xb5Qi9mYjO3mH21QVj4f0hdmp69oL7WFizbppwRInTuNEfH70vVmze5R1ZCZA1nH5249YUOIDDB5qye5HN99867+KehbgYRE1RcEqrHr/oRNNtNSd0Phy7Sbe+SzeJGNRWUXrmnxj6UfppAx5wM9ZWpYkCgod1PwQtaWAOwtKizrpqmr0y22Z4uTuVnsyzKk+/67GtP85k1VTTO4wGZ3td7tHuhbl2gYQiB6eHnm3AZuY/sZg+G1RsrXabhnWn5ZmgcsJpWUBJKaDjSsnJvHQnI9eUKKiZgwJWFHB8k10zc/vvUYXoUnAcDVZHvSXd5BEkKenqFD1r6sCBnRI7wcJzCaI+TvbioKpMlzBT6ZYQfXmw/iojw8PNj0DTQVc6BVd6rLwyltHhZolv7hs/kmTZi+HjAwKO8WgPDaWFk7y84CbKwTxORpluaG/TzatuWHDtxTeLM73TTvCDg683WarxY9f2NLG+ZysE0rJI8iEfy/eOsSqcgJ2JyzjTmTnj14Ib7zF4eDeiFQP8
 ukUExFg5
 zA2jPrlM6tFeOaz0mWCZitFSisXqvkeFDfHD+MSLG/38K8h+cLHij7O7BAU9fvFwQYU8ZLLXeVl5v86t4CRRPh+wIZCqGiSq7Qief9hTomQJ7HCAq/fdIC5tLZdgWMtt0LEel3Sq7/Huu7TlRx8xs5720fJ5Fm9F6AxogT2Rm0M/gTkPX0hKXB0vxb6huTEp7OoCar8gK7ZUXPUD7X8C/n5L3JoP+7yh9zrHJFzxVXiNTV6wTUL9vjnbfoL9Nc8xC/TiWa4M1jdIkHoutduCSJ3TgMTLp+YDzi7zc3g7/XyOfzPXBTt/qFrff0PgVbkgWceTpQPb5DTQdMgQq1lTlgLvb4A/3JjR4UBs0FBF38fnkwIWGwfFqBYz5LHquB6zuz/j2uo1gWMZo6ChNSiGYTol6RcLHyqoasyS7/V5x7RGhbpvLWAYmFrGEGQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 30-10-26 01:52:38, Qiliang Yuan wrote:
> xas_store() clears the marks of an entry before it replaces the entry
> with NULL.
> 
> page_cache_delete() calls xas_init_marks() after xas_store() whether it
> stored a shadow entry or NULL, so a folio removed without a shadow, as
> POSIX_FADV_DONTNEED and drop_caches do, has its marks cleared twice.
> With 4K folios that is about 6% of the time it takes to drop clean page
> cache.
> 
> Call xas_init_marks() only after storing a shadow entry, whose marks
> xas_store() leaves alone. Dropping 8 GiB of 4K folios, median of five
> runs, averaged over two boots of each kernel, in a 32 vCPU VM:
> 
>                           before    after
>   POSIX_FADV_DONTNEED    1517 ms  1423 ms
>   drop_caches            1515 ms  1422 ms
> 
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>

Correct but please add a short explanation before the condition like:

	/* If xas_store() didn't clear marks, do it now */

With that feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c6..a0c959e74533e 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -140,7 +140,8 @@ static void page_cache_delete(struct address_space *mapping,
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  
>  	xas_store(&xas, shadow);
> -	xas_init_marks(&xas);
> +	if (shadow)
> +		xas_init_marks(&xas);
>  
>  	folio->mapping = NULL;
>  	/* Leave folio->index set: truncation lookup relies upon it */
> 
> ---
> base-commit: d89e1d186ec9271bf78e62771779e9fc03bf0fc3
> change-id: 20261030-bug-mm-filemap-init-marks-once-b83c6aa67bab
> 
> Best regards,
> -- 
> Qiliang Yuan <odys.yuan@gmail.com>
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

