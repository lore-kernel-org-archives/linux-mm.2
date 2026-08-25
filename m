Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63970C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 07:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75E9B6B0096; Tue, 25 Aug 2026 03:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1626B0099; Tue, 25 Aug 2026 03:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AFFF6B009B; Tue, 25 Aug 2026 03:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3934D6B0096
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 03:39:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A0416140360
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:39:28 +0000 (UTC)
X-FDA: 85138991616.21.96131A1
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf27.hostedemail.com (Postfix) with ESMTP id A91FA40006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:39:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787643567;
	b=i89oqFJtcZbnEqDxB8oRFIMtvTwM6zjca3nY633MdYWMDedMVjJPXrWOkF+zns6NO/gE0g
	jW5lKO3ZNrf1Me28J5M9JnYl0s0rKTg/OqBUzpAY06nlkE6iiUuyLQ1yYr6J2sKYxfHu2n
	I6fNoWPlxFJcohNmFEoFqIQBCbnlyWw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf27.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787643567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5g0+j4h8gO4tlGKwvDW9AFMU5qJk6TO5Vrqvxsa+Rq4=;
	b=Ymzq7pDr1ffiFMmWv6vFaPLchD0WyXHG+7DI77UiO4aKfC/9xXqnEARCTUTrInHewHtTuL
	aHvpqV9Ny+/lT5jvdxJ30w4QymA+MOOHCD/+t9NKWxa0mdLsWd+uCjGgPVop30drEvRuSv
	uJryuH9ijtAbFtOqc9OwoZ6qeqCEnuM=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5E5BD68BFE; Tue, 25 Aug 2026 09:39:19 +0200 (CEST)
Date: Tue, 25 Aug 2026 09:39:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Christoph Hellwig <hch@lst.de>,
	Jann Horn <jannh@google.com>, David Howells <dhowells@redhat.com>,
	John Hubbard <jhubbard@nvidia.com>, Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>, Qu Wenruo <wqu@suse.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org
Subject: Re: Removing ->dirty_folio
Message-ID: <20260825073918.GA25441@lst.de>
References: <aoyWln-Gt-yvZQkE@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoyWln-Gt-yvZQkE@casper.infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: A91FA40006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gc9xi85w8chz8zfre538m89y1459yozu
X-HE-Tag: 1787643566-647006
X-HE-Meta: U2FsdGVkX1+a7H73nHhkilZsLU2lgATEduYrLHl1P3mPY5aeZUPy5XeGcxIMSNgPDnZ996izDFMUosN+CQMFO+cNSKj7BcDoKGdzDQHoxE13xE2Ne9jSCJxWwMDtGa6oPHl6NBr8b9hpLKnOaB/mqd9DYX64IVVBgLG24rv+gvTqQI1bbkau7QXjo2pAzex9YJOYzv4yAXhs9SaDsWkgNgVcwMbc6ezDzidsScx86iaxvzw0E/8ektpV5ymaF1nucUhOEbhnW3SdRlEltHXpbgWd7q3waS+CBRycTfwxqNtJr8HQ8Z86jyIOCH+LPz64ES7v/SDnfJqR6U7uQWZmm9wkO8avdQGs87d0nLCN21aHCglfaaPwvhcN6Bl3fW5cdPWLG/uVoJ/+NWV0yNOzusF+FKf7EiRsVn2lq14pnaSXTGMovyvw7yr46cD/ggmZziAin6tf1d7w6dyOcx9UXrlWCTN/FUQ5K0AG9No9onpECFHnVyE9K0F5xciyhPObdbPTvQ9SFvrtWJQ/RTrBAiHN7SCt7rKxazm0NjawacJMzb0mEHStaqCp5tUJZXpLpVrHLxv6mzTVIK+O7Mj9dzBb7zba7sGI9is27CXuoORZZPzgRf8Hpibaaq6HBxWeBKuiCawKb/mLX8KkRFDa+Ig6zsdPGa6af+/nrhRvzULZpNLD3nVjeWhr+k1/T4qZaUpHFyhVrpNiMn+LlxCRM/+yCtA79PJGztE9WAkhWiRVGW7iF1XQEIxNue2XEnicOniTKFxcYrBFbMGI8nYuy0x+dJOJF3NbDYtlPofGXMlD0PLuOvFmcikPIYTIpVXdUN4MQzqet2aTsKP1ucEvqdK4WoLMFn/RSHLLaxaZtdfvkFf76Ec+K9CR84LOjE9ldvesigco9xcutxMaInBfnxOWd2TmFc9Qx+ffZKfMgw041aIIrpU2KqmrxQGLiPgjkNWjvkfmkzsQpeu++jJ
 z0kr+rXd
 pNYaZxfyjLPyoCahwLllbgNFOfn7RhU33WrZLbJgjT388dignhhdHd0lbLiX2C2aBkLE4amfO4dLS/cvZdU7JzgCG5N3FidtD8kdBhk2KZR+3mpm7r1nCYtvB37OMG8rHv3HjCJPCSA8YJSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:08:06PM +0100, Matthew Wilcox wrote:
> My proposal is this:
> 
>  - Fileystems take note of folio_maybe_dma_pinned() during writeback.
>    If it's true, do the writeback, but retain/recreate whatever data
>    structures you need in order to write the folio again; behave as if
>    ->page_mkdirty() had been called again for each page in the folio is
>    marked as dirty.
>  - The MM behaves similarly; we do not clear the writeback flag for
>    folio_maybe_dma_pinned().
> 
> This will have the effect of writing pinned folios back every time the
> inode is scheduled for writeback.  But since we have no idea whether
> the folio is actually dirty (because the GUP user won't tell us),
> this is the correct behaviour.
> 
> I'm probably missing some stuff here.  Let me know.

We've been through this a few times, I remember me and Jan discussing
it maybe a year or so on the list last.  This is what I remember:

 - the best thing would be to just not write folio_maybe_dma_pinned
   folios at all.  Jan brought up cases where that might not be
   possible, so we might have to write anyway.  IIRC the major
   one is that we actually do allow FOLL_LONGTERM even on file
   backed mappings, and those could be pinned forever.
 - when we write them anyway we really have to bounce buffer the
   data.  Basically copy and do something like in-kernel direct I/O
 - Even that can be tricky, because we'd still need a space reservation
   for that write at it would otherwise consume the space reservation
   at dirty time, but we still might have to write it again.  One
   option might be to only do the force bounce buffer write for
   FOLL_LONGTERM as the others should go away, and FOLL_LONGTERM
   gets a call into the fs to reserve extra space.  This would not
   be enough for a lot of writes, but enough to allow for
   "bank switching" over GC cycles.

So, not perfect, but probably better than the status quo.  But a lot
of work that someone needs to do for being a bit better than the
status quo.

