Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9B5C87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 17:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2306B0088; Fri,  1 Aug 2025 13:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783056B0089; Fri,  1 Aug 2025 13:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 671AE6B0092; Fri,  1 Aug 2025 13:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5127F6B0088
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 13:07:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07732140300
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:07:33 +0000 (UTC)
X-FDA: 83728819986.13.4E50494
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id B41DC4001F
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:07:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dTvMd8fP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G8rG1Y2T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dTvMd8fP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G8rG1Y2T;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754068051; a=rsa-sha256;
	cv=none;
	b=LSjYkLWhgtA0ClReovyLPFYv8bkPl2x2Pg68+5MHqOfq34NjLeA8EsTSeazHdnxDiT95PD
	lk4N0n0xRj8ucNRDVe4rIsM9ggomWS7lx+QS4lsrIuiQlLhdyCJ6ayk/9FayuIH2rx9r0V
	64+XMydVmL7nHUGjh7LY6NWqXf3PKrs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dTvMd8fP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G8rG1Y2T;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dTvMd8fP;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=G8rG1Y2T;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754068051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIn07FzSOON6Sss2YzS5j+2jnVsbdr3lR+vtWJREsnc=;
	b=dmzXj7RfcVOKMbQGdMd7A6l9moZpPQyE57PYk1kBpzIBbl/tp23SQcFMoGhs6f+2l00e5s
	xXHPyCgete38nxA7LQbnzw95lE8LDuuK21k1QKBBpnXWct7LGsre/ryg2CgPE2ZPa9keRn
	v5BwzTZR1EkdTZikr3GCN6vUf+STO98=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 28BF61F807;
	Fri,  1 Aug 2025 17:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754068049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BIn07FzSOON6Sss2YzS5j+2jnVsbdr3lR+vtWJREsnc=;
	b=dTvMd8fPb8gGc6GhZknZCTjPtDcLg3ghKhGpoUh4JrdKviglDTsyYpzv/Y5UyiAjDZKO8X
	lW1HIODrh4itndKGaG7oM33oEC+nfhcmCXasa0PF4/nxs3j20Iz2uaQyt33nP1fJxf8u8c
	0+6W5BfWPvnRrrICYtGX8wOOXQzWNjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754068049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BIn07FzSOON6Sss2YzS5j+2jnVsbdr3lR+vtWJREsnc=;
	b=G8rG1Y2TTTfn3/O5bnuG6GmLI9tQj+vFm46NVWyAtcipq5grjegc02U5LSzbty18tkePWX
	cIpN0KuRoFuKn3Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754068049; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BIn07FzSOON6Sss2YzS5j+2jnVsbdr3lR+vtWJREsnc=;
	b=dTvMd8fPb8gGc6GhZknZCTjPtDcLg3ghKhGpoUh4JrdKviglDTsyYpzv/Y5UyiAjDZKO8X
	lW1HIODrh4itndKGaG7oM33oEC+nfhcmCXasa0PF4/nxs3j20Iz2uaQyt33nP1fJxf8u8c
	0+6W5BfWPvnRrrICYtGX8wOOXQzWNjo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754068049;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BIn07FzSOON6Sss2YzS5j+2jnVsbdr3lR+vtWJREsnc=;
	b=G8rG1Y2TTTfn3/O5bnuG6GmLI9tQj+vFm46NVWyAtcipq5grjegc02U5LSzbty18tkePWX
	cIpN0KuRoFuKn3Dg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1414B13876;
	Fri,  1 Aug 2025 17:07:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QAChBFH0jGjxTAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 01 Aug 2025 17:07:29 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 65535A09FB; Fri,  1 Aug 2025 19:07:28 +0200 (CEST)
Date: Fri, 1 Aug 2025 19:07:28 +0200
From: Jan Kara <jack@suse.cz>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org, 
	jack@suse.cz, hch@infradead.org, djwong@kernel.org, 
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [RFC PATCH v1 05/10] mm: add filemap_dirty_folio_pages() helper
Message-ID: <ghghf7cynwbmthtozlthggdscnmgvkmnq6s3gkcl4qp2zxubee@azmf2dxubund>
References: <20250801002131.255068-1-joannelkoong@gmail.com>
 <20250801002131.255068-6-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801002131.255068-6-joannelkoong@gmail.com>
X-Stat-Signature: uge3r7dn581yqu6d4q811n1iqbkhc7ow
X-Rspam-User: 
X-Rspamd-Queue-Id: B41DC4001F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754068050-69147
X-HE-Meta: U2FsdGVkX18DkwCA+pcmXO6sPJC2M1QcXrXYeOYXBGJc088F8R8/7yK2774hs/btwQkGQmB65CpAMYLgqN+zm9N46gWpYDSnS74uWBBONdtw3Z3m+LWB4bENDV0wvNhN7FzFWI6gbTLDyhhRlo7bSJQR4ooTF5egzUfjICGSKucmFAwCr/HOjoOd1r/rmhvPrKO/Te7Gdb7dXxj0KKhrMM7dMXPA8oZczhRliRHCLA+WxykT+SXF6Tj2pBF12JGC64xKvFbPzjqJDDvBiAJKWL9TzpCEyTAfxS4rF57uWp7pNHSBXZMFkI29LmtaTNB4FfZoIryPgDd3o0idDzdYLGeJMnmMfrdIohbfI9pTHzNzv/THNyq1m8olWdwRTkN6HvremloQKTH/FUzXDOr4niMT3VLJQtMS/WFwVTa3T0KBCmNxk0dQMXIpPUF5jIGKXBEmU6Vn1PhrKLpH+2JaYJ6MqGsngB4R4ufQN8Kz4Xn8vmL28xQbC0chQNjqdnOJX2czpHPIx/9aMDsmhCaQ8RwY1mWJJW9+kgST2b4cs0B7ME2CFV2Oy08+MDOteOXUjSJMS9t2+4tJdiEa+mzKRuRbbPRz6GIMxPAcQ8a7OXcXuG5TYfdM0aVIofhQogmTnS+SDI6JDiUWsohxxzsOB3wubTx/wT4aDnP5RZru3AnCjJmdfr6ELV3Av5eNFj/H5UmjQPkBsAgCMN15CePpQg5rr0pUq+1geadv54GUx2QT+fAa5jIMCC9+ltm+b1KZd4uaVci/C5ZYNuYdhAmeB/yPKpRiYPBoZsXqG7iD/yyfk0EmC/zGGapWAZdGtOY+SlcYPA2Q97vMKid2I+StRfxg2DHZkcOaxpBp0k1xgEJmDcN0A8ewRlN17HZOdeHpRWG+0HmUxQxRm6v0VciSKBC2+1drJMRB+lVin5ig0veWhcW5AZiKjUYA1J5nU96fkgOMG7hnSFGDcIoGtth
 EiVP8xoL
 MXEfnqvA83HZYvZRh28Yb5ja3hUoF7GGIuSLy5zobz14L17ZRhOKCNEI+ln7BI+93LjEMEuDG5ftkWYI5JOLpt0ZXfKcsPEYkYPzj6OlmmWc0BSbiC/lZ+cSrIWkSbaTSLFGuk0upJQkyj4pwk8EvNXJ1mIliT2bMgXGh/7NTnpG3FcCb8EP3Y2wu2SaufXU2Z8ZIXKiNh8i5OUzC/mlat/a5RYkCpM+9O6fdV/u6Cmw2v0/sV/z4COMLY8M/6KBd+iYaZ92mgI6CWX+2rI0kdJ9rIstQgQQGxLlwugK60u5KUFtbB63Y/O4jBlBe0GPd8fTPe5oukGti0UjYir236gZBtBPHaIFuiaiohc2cFd4miQ3rU+uyHWS/7ziCvii/EExtu/6pp5WE4qaM2LOKesl3Uulvf/B8kkUC+sFj2kCxE3jIEYwfJcVpi5yqhJeaDHA1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 31-07-25 17:21:26, Joanne Koong wrote:
> Add filemap_dirty_folio_pages() which takes in the number of pages to dirty.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
...
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index b0ae10a6687d..a3805988f3ad 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -2732,7 +2732,7 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
>   * try_to_free_buffers() to fail.
>   */
>  void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
> -			     int warn, long nr_pages)
> +			     int warn, long nr_pages, bool newly_dirty)
>  {
>  	unsigned long flags;
>  
> @@ -2740,12 +2740,29 @@ void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
>  	if (folio->mapping) {	/* Race with truncate? */
>  		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
>  		folio_account_dirtied(folio, mapping, nr_pages);
> -		__xa_set_mark(&mapping->i_pages, folio_index(folio),
> -				PAGECACHE_TAG_DIRTY);
> +		if (newly_dirty)
> +			__xa_set_mark(&mapping->i_pages, folio_index(folio),
> +					PAGECACHE_TAG_DIRTY);
>  	}
>  	xa_unlock_irqrestore(&mapping->i_pages, flags);

I think this is a dangerous coding pattern. What is making sure that by the
time you get here newly_dirty is still valid? I mean the dirtying can race
e.g. with writeback and so it can happen that the page is clean by the time
we get here but newly_dirty is false. We are often protected by page lock
when dirtying a folio but not always... So if nothing else this requires a
careful documentation about correct use.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

