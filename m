Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458BCC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DA116B0092; Tue, 25 Aug 2026 03:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B16F6B0096; Tue, 25 Aug 2026 03:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7B66B0099; Tue, 25 Aug 2026 03:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B0656B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:59:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88349C02C2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:59:17 +0000 (UTC)
X-FDA: 85139041554.14.59E861A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8083CC0002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:59:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0CGHFwao;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wzWFMzHs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejcDYF8o;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xcviFUOY;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787644755;
	b=lmfWh660aTCU/nFo/rv2C0PrI6VXG2DLXCK61GU/l/HI026FfuGNQeoUQ6g8rn7ju0K+9O
	gwwClrC7g0QeXZRowCUz36sVmNFT/gmB+9cDFiLttIo5m5x1CCMHyMAM4s1+NklN+YgiCR
	NnDNYebwmDp7ImKBgWZBjZ4YY19Lbug=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0CGHFwao;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wzWFMzHs;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ejcDYF8o;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xcviFUOY;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787644755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=A5WN8WVdhxrkIXEU4mCP39rKf2qmD/1axAu3TxF+K8NkSNYoq601S0z6HBpQDwfUBcumCc
	7RXmS3pH6mUJ1TjUw211U0yY54wzHhABILkXLeNRRrL4Sy33TgIVdc+zR9SxwXzAHcsB0i
	P/x3QhiyqhEMJW3u0RJa2LTW4+Q9nNc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E124E86D73;
	Tue, 25 Aug 2026 07:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=0CGHFwaoWm7q5XPbizZrjrEEmhZxSYM8K8G206/zLI19IzemgvLdq5t7T2QLT8DUG2Ctdc
	cuwpc6wJDzs2STPCTEP03APDHWg8gWn08PaGN+M2+2iLhCHpdZVBTAy1EaDOuQNlQ3oQAU
	i/aoEkLKiMy2CLn/yG+Nt/yHuS8Pnog=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=wzWFMzHsk/+iPH0SX3CW/v7SVM4ql+8QOqiO3b/4mzZi3QmHTvhxZX6nwlXuogVYKIf8pK
	3l5GkiJkHpZ/jICg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787644745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=ejcDYF8o8x7QWlAQNDisoLJNh26DKtQQmIE5Cgr7JM8Pii2nbdpQYM11aphcMrtCBVEeNE
	Tj9XHndboopHuaVIFem8QRP9LIpLbERg8wWNNwlMcgJYlvY82A4Naz10g+z9qKKuFvjyYq
	aQ21vQTC6lmy2Gb4tx+ctir7coTGQIE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787644745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X5pkgJRID5oSKj0ZfWF+KOtBr1NU4ZpOVE3ZapgsNXc=;
	b=xcviFUOYu9qnGpVA+fmFz9/SxZ/wGd6G3cp34iELyzBa9ZmroK2UNmsCjOEbLmYXuofl/j
	M9sR+JSaOGL9eNBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0D2F713332;
	Tue, 25 Aug 2026 07:59:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NydOO0hLjWrWbwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 25 Aug 2026 07:59:04 +0000
Date: Tue, 25 Aug 2026 08:59:03 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>, Christoph Hellwig <hch@lst.de>, 
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>, 
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <ao1Kbcu4Mmtrr_Sa@pedro-suse>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
 <aoye694JQLwUuqxC@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoye694JQLwUuqxC@casper.infradead.org>
X-Rspamd-Queue-Id: 8083CC0002
X-Rspam-User: 
X-Stat-Signature: 4og6g3gkutr9bdb3emwyy5mu1ej75thi
X-Rspamd-Server: rspam06
X-HE-Tag: 1787644755-79025
X-HE-Meta: U2FsdGVkX1/Li8hkIN6ZXKFbPjVgY2wtgTQ+G2eJJFh4nBQp8J1D6W7GFRpV3hQUQEMiE9XZx9AIAYw9tfDWSgu5ndCAWU+D1WifgHsS6FeVioPh6zgbmHwwUxNRkRrS+DWq3BMbegYhvEa05OCHEupTQ4Db4A+X8FEvr2Ufsrgod7eS31Xh5ApAiQeTT54JJrOoZIs3FxM6T23Y/EM6VgAjvm/D1Hy5pza3euGmgtBrlnt6sk0230aM3scTD167gewd0wujwBAO9Kuwwu8sQxbjkJd46bBr18VV3F/ov27KedEPVUd50wo+Wk8sdilOhGbTT9FGJGvMmxAPZwi+nVy6z1HoUPK0yS5GYh5hRzI+W1au7wOP7BdnKU1FkU3DbybrSDlabd7XuO1qudWbWwH3+kpYBTskqMaA1JsgKP88mVVGbvoHjylLWhNEL2LrUtC1GKLhwjESi//1cXKxrp4ptoVXxRz7hw15ciACDWjtCk/qA4lf4EJJhHSbPNzX3K8VKLrkkSlF415xfDf7C1UT60/fR/nh0ZpGQULt/LbrsGZdHOCkB6Beokh+BD7x7AbZTOmYNL7t0kKWFrXKq2cTsTsRH9/Ie2ajXynMxKweyfHb5SHCUHiRZbhHaSemC41OcmxvCrU9Qk7XR6J6IgQ7qNnZUqlgunlsWYxOW3HGQY7hl4fsNvMlX7yjS7GaBMKBvIfYqKuUfg+bBNQFWTSfhNevOAIjRt9cTfwSzQv8Xzt3m5bbwH8vP/MvJQHFv54tSDgQ7TIOQcPI9o/dMkfl0Cy261Gd+KnPDQxdWGH00wMEDU3XFWl7sc0gl9SYHFLV663DPCtffZ7QgOktLo4ZxcDrrWr//6n+EIdeR4XuyvidKiIWQCM6Zad1sqnqfJ3J9AM/yGnLA4/tRvJpwhj8+Z5IAPsPJ+2v5UmMGaeu/zr+HeDNXl7u4Nzqylk7PhJaYOML0uQqgzUsDIx
 21JfZQvR
 1PcWd6ImLhVugUsgwAZF0XfKPVWaxVb1hkwAfjCJE594RMvowZfhu4mT23/YtEFMMDWCVpxtbJ3yyydOYGVfAijYv55pjVYdQB+3/TBSgl7d9GSUtuLpEAvdNXKbDmEH4zs0ECty8IUkdF3CXQDfPftsy+6KiYzzUNDtkF9qe5yXqpZeOixBxWMwhzqw/APaL7JaltfZtOApIj3U9IzxX/7CBlX1ir/UH81wWKVKEF2upqhz8ye3n6JFmaFpeeeGGmfqRlTm/ekNkJrYthmn5nd8ZAbcUGRuYvwd+R/oofBtRx09E5NCvNh8H2sB4Hwopq9N728FuKPksZGOaCcODGYc1QwGGcl1zWP55
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:43:39PM +0100, Matthew Wilcox wrote:
> On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> > > My proposal is this:
> > > 
> > >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> > >    If it's true, do the writeback, but retain/recreate whatever data
> > >    structures you need in order to write the folio again; behave as if
> > >    ->page_mkdirty() had been called again for each page in the folio is
> > >    marked as dirty.
> > 
> > Yes, that would work nicely.
> > 
> > >  - The MM behaves similarly; we do not clear the writeback flag for
> > >    folio_maybe_dma_pinned().
> > > 
> > > This will have the effect of writing pinned folios back every time the
> > > inode is scheduled for writeback.  But since we have no idea whether
> > > the folio is actually dirty (because the GUP user won't tell us),
> > > this is the correct behaviour.
> > > 
> > > I'm probably missing some stuff here.  Let me know.
> > 
> > OK, so working through the end of the pinning, I think it still is
> > correct: device finishes writing to pinned memory, device driver
> > unpins the memory but the page has been left marked dirty the whole
> > time and still is, so the next writeback still does the writeback,
> > but this time sees no pins and so it marks the page clean.
> 
> Excellent!  By the way, what would you think to this?
> 
> @@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
>          * Here, for that overflow case, use the sign bit to count a little
>          * bit higher via unsigned math, and thus still get an accurate result.
>          */
> -       return ((unsigned int)folio_ref_count(folio)) >=
> +       mapcount = folio_mapcount(folio);
> +       return (folio_ref_count(folio) - mapcount) >=
>                 GUP_PIN_COUNTING_BIAS;
>  }
> 
> 
> It should improve the accuracy of folio_maybe_dma_pinned() for folios
> which are mapped many, many times (eg a page of libc).  I'm a little
> concerned about races turning that number negative since we don't
> necessarily have the folio locked at that point.

It's perhaps a radical idea, but how about just not incrementing
refcount for mappings? Essentially, for the main state transitions
(mapped to unmapped, and vice-versa):

0 mapcount -> 1 mapcount: refcount++
1 mapcount -> 0 mapcount: refcount--

and anything else doesn't touch refcount.

I think it's worth considering standalone (one less atomic inc :) and
reduces any ambiguity in folio_maybe_dma_pinned() to essentially 0 (unless
you have 2048 short-term pins for the folio, rather unlikely I would say).

-- 
Pedro

