Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7FFCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:56:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FC88E000A; Mon, 20 Oct 2025 04:56:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 199BF8E0002; Mon, 20 Oct 2025 04:56:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A418E000A; Mon, 20 Oct 2025 04:56:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAC3E8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:56:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A508613BB02
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:57 +0000 (UTC)
X-FDA: 84017887674.03.C3ADFB0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6F531100009
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hysJY61T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yphqrgjp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EpSYi1MA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jrfKw8GG;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760950615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0eKocUC4aWPoU3oJsUDdbKkljgX7L699KQPGrl9Fq+c=;
	b=GFQpPXIBa5uu2MeOfKphMMzaaQPVoys/pU/fRT0Dc85PgMzXVsoLPb+bkDDKvSfRMgwBrJ
	skf9c599YKCCs9yO3NLtYSCBfvE8fr4pjRT6UhYC0WiomACLCNwNDXndGM6Sf3KfpkL7UR
	Xtd7YR0ceYmOfnreX36o8VE9XvB8ia8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hysJY61T;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yphqrgjp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=EpSYi1MA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jrfKw8GG;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760950615; a=rsa-sha256;
	cv=none;
	b=y9wg4E/V6IjTMOXuEycp5gV7ldAkxVSHOasHcT/vsF0oG58rrK1woifuSmLCG010TeGuK5
	nNtgMtn6rurHE3OZSnAzHYoOWQNhQ9E7WRFIZAJrgbLtcrBcjYp2uHuMPgDXI/V4jScbpd
	FzYcMpmfs2NfqLHYhaqptBnnJwjPrlg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A1FDE211C4;
	Mon, 20 Oct 2025 08:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950603; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0eKocUC4aWPoU3oJsUDdbKkljgX7L699KQPGrl9Fq+c=;
	b=hysJY61TD2iuyWjQVvb5FPwtn981mOlDkrB441JsmqUX2OVDVI4zg/zCz1S42k7fR1cfpP
	bjgQdVacBY/DmcwZjtCAOnBLZZ+Lr31cLe4Ufk3eOfOK0Rtiyd3v96Lb507KbggzyXLOlm
	5e7L7Fu7xIkXn1ikN81nkjkU6FUsXkE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950603;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0eKocUC4aWPoU3oJsUDdbKkljgX7L699KQPGrl9Fq+c=;
	b=yphqrgjpQ136lF9ZFjK7Fnee0a8FAXTtPw8WkJPvDwNzcE8imxq4sehvIj4b9tDbh4feKY
	aO3kGbnh+JlzUJDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950599; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0eKocUC4aWPoU3oJsUDdbKkljgX7L699KQPGrl9Fq+c=;
	b=EpSYi1MA5UN0J3n/KeHJ1nJ97rrmcBfsN9lz7pvVhcliLpA+8ReUeiuGGUaRPow5jzxg/Y
	4HM36omUklV/9RZsO5RUPAeHULkeBdHSOYEwFvYDhJH7cSD2XiUWAq9po2Yxaj8Ppo89wU
	8sG89rYgbei04SKZODB079q94d+ALek=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950599;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0eKocUC4aWPoU3oJsUDdbKkljgX7L699KQPGrl9Fq+c=;
	b=jrfKw8GGk70Lm1J5gwt/b6DyGS0j3iaiNjS9Gyn9IJ8GuAJZ9Kygon57sY3/AdOmIuP1A8
	WS+2ykGKNs+yvsBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 272AD13B0B;
	Mon, 20 Oct 2025 08:56:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HI+HCUH59WhmZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 08:56:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id ECD6FA28E4; Thu, 16 Oct 2025 18:21:19 +0200 (CEST)
Date: Thu, 16 Oct 2025 18:21:19 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aubrey Li <aubrey.li@linux.intel.com>, Jan Kara <jack@suse.cz>, 
	Matthew Wilcox <willy@infradead.org>, Nanhai Zou <nanhai.zou@intel.com>, 
	Gang Deng <gang.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>, 
	Vinicius Gomes <vinicius.gomes@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, 
	Chen Yu <yu.c.chen@intel.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH] mm/readahead: Skip fully overlapped range
Message-ID: <mze6nnqy2xwwqaz5xpwkthx3x4n6yd5vgbnyateyjlyjefiwde@qclv7inpacqe>
References: <20250923035946.2560876-1-aubrey.li@linux.intel.com>
 <20250922204921.898740570c9a595c75814753@linux-foundation.org>
 <93f7e2ad-563b-4db5-bab6-4ce2e994dbae@linux.intel.com>
 <cghebadvzchca3lo2cakcihwyoexx7fdqtibfywfm4xjo7eyp2@vbccezepgtoe>
 <6bcf9dfe-c231-43aa-8b1c-f699330e143c@linux.intel.com>
 <20251011152042.d0061f174dd934711bc1418b@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011152042.d0061f174dd934711bc1418b@linux-foundation.org>
X-Rspamd-Queue-Id: 6F531100009
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4d4kp9p3mau6srwweo3h597qxwkeccq8
X-HE-Tag: 1760950615-4900
X-HE-Meta: U2FsdGVkX193oX6MMMAalAzg6wgOjR8gnKyhnLPMnd0o+srVP2eRjIrSC/NUSxkVOYyg7esR/t3OUUj97pDnRBcT1GaMn+f/hPcxz6rng666hOVzdoN8dGKnWh4QyBl95JmQzDg89Sx48Ru5JG77SjrjnS9ntFwlqZRCcwq2CsIl2w7v3IIS5MQ50qc6oxIvv91g4jKXy4JshdxXOnNqtEkUHdTsz87A2X7LyYfTlFX5lzyNLZqHqSSH8Hvyp3ug0j0558Hu4BJHYKlkeql7aoa+CECj6YVTfhwYvai7X4MYGjzf3yImdrsocJsxnf9b5sgDuDbMa4WxXmmh1zxew8d2bhI1cbVU3mxqqxsNhEWKm60HxfxmvTZnC8AAq3iv6z5UcyuuMmRJ/Qz3Orfe9pLQ5vPi0mDCdqyNUjUltb2o4u5czIabGEnS68Q2L719E+hRAEsr9DHGUV4/pr8QqKbkod99WQL0W9d8T/YDFHTUgtB5T6JK9JTxIeY34mwfidXfReDQZYxEO5WURqwCursU7C1zQP/41UMUpdnAerDaTkHMd1CBsdKnB4eKtGIfDA+FEJT07WPQz5HG2QlwY7o7HgsDwX6ICaDiNEnDvfV8urfTmGZEBEo9Lv1W9l2eQGLtAeDQsjI8JL1VQxfuxfJXg7nsONViGGyp3qgogOesAfyDDy1Cu61+QLQkQPXZ0pFWE0pc1s1awa8Zzi0BLhxp5xuuo2EqaWQGknNo60SRh0swC2B8ZNdyJhO79O7Nz1vOtVPrHGym9+ElNkPkrGwrlZH2elkM09MVUeg2zlGgUwvB882xlWHLE/bARKqiWVXqtydprGlL6Ld8YGlkfwRs9iR2sSMBsqBLeNa4w36cBD946735KaLwzzU5660BTODcVJ2i9gqseCp60g9Ju2ZLvdFTN+5qs9Vhz/+gxLlAgCW4P0Dnmjg7pi1C19XX5HedJQ3/0XrWJxFOZuk
 Nu5jBB4O
 goBL/u9+0U1oidl4k/i6uz2v8RzSkNURcwLq7t/3Yslv8XuHMFAn19fnKgl8Tgggo3nZ4lTWSLUsLP+7PmMsC7bfQu7Q2sIYozHesN328uhti22zF1oqzziXODUZYfRAEe+e3rH73aZQSvWQeTJQ/aPE8CNXTzOjJXG9HnWANGXbpb2UAvGWuvcnjgueIyGKZr6mbxAJk/JxFq4t17YrhF7TmC9m6snQoi6S9ofkzloWnOiIxzcJFXOMlDVU3GY/KAA/aEmDQnV4mkQ6kEja9Wy1uGzzu1RSvjfjhwRsSaT6I9+4NL8O4FLJxlrUjX9B2pMAe7hh+fDcKbjvDAbxDlbj77g2ZvXn3RDjrVrggWStK+4KL0QRw8cnt0NDpkA2BRbZ0DZ4oWwJkJcjbbe3w4gm9hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sorry for not replying earlier. I wanted make up my mind about this and
other stuff was keeping preempting me...

On Sat 11-10-25 15:20:42, Andrew Morton wrote:
> On Tue, 30 Sep 2025 13:35:43 +0800 Aubrey Li <aubrey.li@linux.intel.com> wrote:
> 
> > file_ra_state is considered a performance hint, not a critical correctness
> > field. The race conditions on file's readahead state don't affect the
> > correctness of file I/O because later the page cache mechanisms ensure data
> > consistency, it won't cause wrong data to be read. I think that's why we do
> > not lock file_ra_state today, to avoid performance penalties on this hot path.
> > 
> > That said, this patch didn't make things worse, and it does take a risk but
> > brings the rewards of RocksDB's readseq benchmark.
> 
> So if I may summarize:
> 
> - you've identifed and addressed an issue with concurrent readahead
>   against an fd

Right but let me also note that the patch modifies only
force_page_cache_ra() which is a pretty peculiar function. It's used at two
places:
1) When page_cache_sync_ra() decides it isn't worth to do a proper
readahead and just wants to read that one one.

2) From POSIX_FADV_WILLNEED - I suppose this is Aubrey's case.

As such it seems to be fixing mostly a "don't do it when it hurts" kind of
load from the benchmark than a widely used practical case since I'm not
sure many programs call POSIX_FADV_WILLNEED from many threads in parallel
for the same range.

> - Jan points out that we don't properly handle concurrent access to a
>   file's ra_state.  This is somewhat offtopic, but we should address
>   this sometime anyway.  Then we can address the RocksDB issue later.

The problem I had with the patch is that it adds more racy updates & checks
for the shared ra state so it's kind of difficult to say whether some
workload will not now more often clobber the ra state resulting in poor
readahead behavior. Also as I looked into the patch now another objection I
have is that force_page_cache_ra() previously didn't touch the ra state at
all, it just read the requested pages. After the patch
force_page_cache_ra() will destroy the readahead state completely. This is
definitely something we don't want to do.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

