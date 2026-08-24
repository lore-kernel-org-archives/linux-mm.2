Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C8B0C5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 19:43:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0E96B0092; Mon, 24 Aug 2026 15:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0925C6B0096; Mon, 24 Aug 2026 15:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5696B0099; Mon, 24 Aug 2026 15:43:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C47A36B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 15:43:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 424E2A01D5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:43:52 +0000 (UTC)
X-FDA: 85137188304.24.5888358
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 19C751C0002
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 19:43:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s2e7dRQg;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787600630;
	b=abBjcvsFrtBI/tnI4wYWFp3o8dYub92hNnCsBXEC0Fk9W2rCtioHLSbxMfbiA0X81lV9S3
	npVr4k+qeyn+4UUsp4Z78vInA/859pMhwenxOdtQBlMpo1RqXnVDhmEcWrNJV7a3skMqAS
	QPmdlC4mMMkyWFRLXNWeGanWId1fBq8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=s2e7dRQg;
	spf=pass (imf20.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787600630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UA3EZoKUHtS+TORu65/C86IU676beKnyC7uoY8ic93A=;
	b=K68jxuzBYUH8Hl1gO/CnNhUjJeFTq+neYE6iQwONJlRRe6AgGscQ4HUWCd0GUTxdF+Im/y
	Tx9J4Sg4MgsQJJGPnaKCaNTzkgS9MhFWqYUubwFWt7Msqa9il6dd0S76WnHSEOwNS2mmh7
	3XX3dMim4b9nnYbfyT5pDGY3b2Y1P0c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UA3EZoKUHtS+TORu65/C86IU676beKnyC7uoY8ic93A=; b=s2e7dRQgS+B9c/EGBNkjfoRUTN
	B4lKpe8gxCGePO01hYuQ3rMXebQOHCUrtKbdIsM4dKQ3K9g3A39BI8Sy0yXRvtiqTJaYAcI6vpR6F
	kTxG2YL/f7lwgKex29Q1N1IfpZa5msDJDl0VV915ozDnRwVH42I+wRney+/eRG0Kjy6264A4eYsU1
	qU0A2+xNQYvg9yIoGxm2AOoLbE8yyJMybPLA5/n6v78tAVU2lJOe1DLb8/fjE8A14Q9MAC3YBH4HV
	Z+07vsQhPO5vSh8hgfDYyQBjCGZwxC5M6MjanAVvIOL6sDUaRwP9b80KIzCvO6OlOD3zYUTeHuZCB
	ne8Q/VoQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyaa3-00000007iyS-3fJN;
	Mon, 24 Aug 2026 19:43:39 +0000
Date: Mon, 24 Aug 2026 20:43:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>,
	Qu Wenruo <wqu@suse.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <aoye694JQLwUuqxC@casper.infradead.org>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
 <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f4ed03c-e91f-4641-8964-cca0391971ba@nvidia.com>
X-Rspamd-Queue-Id: 19C751C0002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zqf5juqw867iwfcsraewmc7jsaz6hjkp
X-HE-Tag: 1787600629-533935
X-HE-Meta: U2FsdGVkX19SCepYtydAwgVHhphkMbK6JEFcXafhvJpIRnobafaOoGHETSwUUK4w/PWlox9X8FGPvLdzyuU9aTi2EQKjGTgBu+6UXaUot71pQ9Ur18WvHvapbtHClt3dbyCel5PAMDjTgakUYOJFImsHRsVDl53LwWXGDtMrG56JbZAuS9Fgcl2CZ4/EH/e6/VKrMA/gVABYr9lq180vBxtzH2TVg+AeDk/aqhXsF5ecWjQGz62tB2oS5bl3CDgJ8PNM9VtlWXNMKxJMaUX/cuh0TqawUzPywIgwnwHG5UCxc+z+bzlGwEzKJLY9qvdpKe1IenONzK+rweCQboEyG1h+XGx9o5DTtjqtNt8t7LFmZg/coUj1KXGfi9ndHNYBNNbneE2cKz3UhMZ1zfUnec1X1zJkqqHnUU2aJPfNXAl3p8J17HIHzzX+sUUA4+Q9McZYRwQY+zwnxwmlfALubhCZ4uamMgyNwmIZvTwUBjTdiO4gmQSm5kIfkgxC2+KtamsQZcylWoyyxfg8YTpPeaRDz9MsA31iDeUlk7j14TK1m2MGihg4Ufj2r3CzYkDF7a4L6bTI4e5x7XFv0z4CsWfiml0Gb9J8yxOqFlIuTvgJtmD8hCgxxU3cpgYxrDUtiSh94MyoYeV+Ca15ekEk0LVlJC4pmKB3AFO4OHE4qYjMBIwMCmTMIfKJCKYkDtrjy0Jo3k5v2yc4Kl/BBSWlrZvwqslPPEWNaTuLHFnd8mMKtPj/tFui73qTNAW3z3n1bNiPxcYKPFDvqGH+G7xeqXBLEINbpHykMG8cM5PzYEdd/ORMQBF0j7zXZvUicvqKmDtddeIgB86bP9Pi7LrXA5yZSz4KTkFZ3FpSCgSUIl9S06t8E+9k0F3BiIK3opGbnAJ8sJSxBzDCGArApC3CczuSa0+hx/yxLsHffvLWSoi1AZWFl9WgIzzvOjv9qFxgS/zK9SUq9Yz08H/dS/F
 0XGu2MyW
 9A4/WM/u8K6OfYlV9qDHYSHezfJFCZLpG9soDyAtVzx0o74SX1lw+w3aLDGETx7v4L6ncYCM2OkRNvqx7rYTGUFsKj+SdujnR02xN1AIaaawJ3I+F1RqmOfypsSyTZfcEQYwGThSH1/phhszJB85iPw66hnO+hmojuMmlKZI8lsJuVJbyhpTzSbh/uFZ33kFMcYkvBf5gy5kZiLgyNrq684RHKLU0wtLjhpF4txK2Q4N9kMWVDV6YU8P2DpxECVPm+R3SZPjuZs0XeOz2UDH9C/c9EE7i62VlUx20i51ioiJ+6CN60lhpWi6GmiEE7PbhAVOp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 12:25:42PM -0700, John Hubbard wrote:
> > My proposal is this:
> > 
> >  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
> >    If it's true, do the writeback, but retain/recreate whatever data
> >    structures you need in order to write the folio again; behave as if
> >    ->page_mkdirty() had been called again for each page in the folio is
> >    marked as dirty.
> 
> Yes, that would work nicely.
> 
> >  - The MM behaves similarly; we do not clear the writeback flag for
> >    folio_maybe_dma_pinned().
> > 
> > This will have the effect of writing pinned folios back every time the
> > inode is scheduled for writeback.  But since we have no idea whether
> > the folio is actually dirty (because the GUP user won't tell us),
> > this is the correct behaviour.
> > 
> > I'm probably missing some stuff here.  Let me know.
> 
> OK, so working through the end of the pinning, I think it still is
> correct: device finishes writing to pinned memory, device driver
> unpins the memory but the page has been left marked dirty the whole
> time and still is, so the next writeback still does the writeback,
> but this time sees no pins and so it marks the page clean.

Excellent!  By the way, what would you think to this?

@@ -2717,7 +2719,8 @@ static inline bool folio_maybe_dma_pinned(struct folio *folio)
         * Here, for that overflow case, use the sign bit to count a little
         * bit higher via unsigned math, and thus still get an accurate result.
         */
-       return ((unsigned int)folio_ref_count(folio)) >=
+       mapcount = folio_mapcount(folio);
+       return (folio_ref_count(folio) - mapcount) >=
                GUP_PIN_COUNTING_BIAS;
 }


It should improve the accuracy of folio_maybe_dma_pinned() for folios
which are mapped many, many times (eg a page of libc).  I'm a little
concerned about races turning that number negative since we don't
necessarily have the folio locked at that point.

