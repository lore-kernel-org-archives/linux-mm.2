Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2C44C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD216B0092; Thu, 24 Sep 2026 13:24:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DCC6B0093; Thu, 24 Sep 2026 13:24:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B60246B0095; Thu, 24 Sep 2026 13:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 809746B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:24:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E03BD1A0431
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:24:33 +0000 (UTC)
X-FDA: 85249330026.17.71BB3CD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D7A2180002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:24:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dhEWgyGx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VC50vUiM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LR6NReq+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pzdn+HWp;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790270672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nvmWxh/7sadN71Ry+teJ71fIRtn4jq4tR13Iaa3OJy4=;
	b=aJJGWIrKj+mzuIfeV5gvbV6NdL7Co2l5eL3hldQqf6/78QpoOqyt005WdyTVNPGYj0+y5s
	K+PW480jDn6yEGMrKQBpUllROBckkteKDxaXkkXHAKugQ098rQyUKGk9SVX8xqeIlQYjYC
	IZuoZyYzJpzG3SYsPfLoJDNJ5sdHYLA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dhEWgyGx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=VC50vUiM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LR6NReq+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pzdn+HWp;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790270672;
	b=4VFAyT+ewIs2ANs0X1llZeEwz0YYMKJ2/+BW7AEqOHhQdh0gKk34+nsZifF1zUC0r+NU8p
	fVnNgxiIXOq1n44oJB25hfZ+/EdceSgrnFqU6U4cc+v46g8nimz9VTcPuRvNYdNkCAlXaR
	GA2pWohN8nUQlncLSsorqDq/PePWa8E=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4757721E73;
	Thu, 24 Sep 2026 17:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790270665; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmWxh/7sadN71Ry+teJ71fIRtn4jq4tR13Iaa3OJy4=;
	b=dhEWgyGxS5Z5ctqdR0yICoWzdBB0/evYvqjpk5eOD1jcIcU4aOxCPylklMp5aBo/6Rmq5I
	dUXZ62pEbl3eetWcqBF0MgLnil7RZTifdXtkp/gE+M3+zD8xTqFzsvM/pq/kkK6t0qV4N8
	VPUIl6MH31xZUMUAowWjb1qWMhkknyw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790270665;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmWxh/7sadN71Ry+teJ71fIRtn4jq4tR13Iaa3OJy4=;
	b=VC50vUiMtbYDIbX0z7mDu1x6GjouR4gRpsmavETWMf7FxDOkkNtaAVSvfw7hMqFmDfFvoc
	xCrnojy1ZCfzhBAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790270661; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmWxh/7sadN71Ry+teJ71fIRtn4jq4tR13Iaa3OJy4=;
	b=LR6NReq+TnUe5fdXqufVbr4D3bjuLwcDrpW2pU5O3+qenfciV90e6EhHdfYQPbhFZWo4FV
	ta1usx9+3SVdWMDBaYY4ThbqIs4HZ+B4HbHXslThf0OXSFXTeNHoIahAtWZuOZPozfxvJd
	ovyj1jVSV3EpC7Nvd4rpdichfy5LO3s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790270661;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nvmWxh/7sadN71Ry+teJ71fIRtn4jq4tR13Iaa3OJy4=;
	b=pzdn+HWptHAnoGOU288Z97sHw5tQ7d/athgrR1UmFoXDnphsjPqP6U+o/LPuaivqTfyN4z
	0i9GFyYTvdSFZSBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EBA3C13354;
	Thu, 24 Sep 2026 17:24:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YW4xMMRctWrdCwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 17:24:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6C4EDA132E; Thu, 24 Sep 2026 19:24:16 +0200 (CEST)
Date: Thu, 24 Sep 2026 19:24:16 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christoph Hellwig <hch@infradead.org>, 
	Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH 0/5 v2] fs: Deferred inode reclaim
Message-ID: <pu4x4cgddu7pcb6gm5bue3eksr5rarbcqu4h3un2z56txi7p6x@ydiql33kyvtb>
References: <20260911081309.14137-1-jack@suse.cz>
 <20260917-entweder-limitieren-kiefer-f033614058bd@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-entweder-limitieren-kiefer-f033614058bd@brauner>
X-Rspamd-Queue-Id: 8D7A2180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: zneaqh7cbmfsssf7e7p9kxaz9arxgs3u
X-HE-Tag: 1790270671-721236
X-HE-Meta: U2FsdGVkX19VrrpGAE4U9RA1/0QDc1nXRJHEdWhS4FvhxRXKcnsiGqlcb6XNPWNXhw5+l6dk/yYQZe3iJmCZJUWcTfSf7HgB0vtIBLMrniQ4xpJn7IhpK2CQTcMXRQVWu3yIizspPi2O026Yut7/uC+UvfA5YZk1EeOc5mKwW32380k7clX3lbuZaV6qbYIcHQWXup8cQOdI8TkNroreeIytfRMP+E+v4kGVksEgge9Z75gQ7Bv3aQwiWC45wTYofZsK3mvFbOaei3uqUXXT+yarMJmrT5fjMc95T/hL9wh/PbwrAHf1wz9zYnx35zFrjyUu15QjfMaL6ZgNoiYIOFJppRFQeriI88fHIx2i84MhNLq+Z+nhfnXCijc5/t9shrEommAPiyGN6dG+fqD8wdxQDuAEQ12i1MS2JmwlD40hTxB5qlIt1F543z5Cm0zv8NrfODSXNuWuSjzAlrQKXmqGxkVaHRIFnFPL7hLS7po9sgbsVsp4DSuXRWjySOwL0esdBaFNojqj8vKpxdnFpsZ+LQ8RdY4tNY5WeafaoGShc+cwdwTGudX55YFzBTJ4IjLxG/SUNRsX3zR4xCRFZPhzInp2LgwNFlw6xKmXy9pFzbCoPOuq4kcsklL44X1Ny/T6J2G+N1FZsmXHHUDeHeZ/TdYvR7weUR91mZv3g5qME6wiCgMpx9FvkFsf8aWLq3xRUGsQrUUrhZEz+g+Spx8naUigoIqjyNCzFf8eO3Gx9/zFRuQjVnq+Cu290jXT1wBkMYqoULU7EtuZxpqev6ekCZRCLuUqD+4764RmOfq9Kajpnk1hOw+9+A5i0hr+O6bMUbU7CON7TmqSGkx/MxBLpdgWWd7acG6ogRpKDK11FhLmqk8fMqrAJZW6jpG6zSPzp/kOX35aTSdLqgunV4xqvjJbirCwFUkZcs9rcdQe4m8Qrxr9V0pXuRFUOW3N2AHClNW2rQF9l4KU3Gv
 CuquoFTo
 59wSRHOCSBf4bcNccDz6IPYJqFT9IAEmziZYjqR+hyHuvAxW8aQrRUzhX14hXhaHKBwRLceX0866iBr3BVMaiQMUj/HQT3RfYlDtHiIsf6FgIvwY8UJDl0smselME65Kq2dADzi52hnhAGms34g2l7P/bgtqubfCGSzJr8t/ybLsuEYnyqO0RbiEUXuBGG0i664dbR33nX5/64303+gXlob7mnfrg+xU4DSFv1/Xe3p1j1ClijM3yZhI0uDjoJMKiwmhr89xJc7ctUz8RNmBQFcz1BOmTxVSAQKpH93/hgUfiAgZqQNYPFxFvUiU0mVY1Of6Lq7l05AI7ZC/RRlw4cI963A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 17-09-26 11:56:17, Christian Brauner wrote:
> > Hello,
> > 
> > after a long pause here is a second revision of my patches implementing
> > deferred inode reclaim to deal with MM warnings due to GFP_NOFAIL allocations
> > from reclaim paths. This happens because to reclaim some inodes, filesystems
> > have to do IO including complex operations using journalling and forward
> > progress of these depends on successful memory allocations (which is impossible
> > to guarantee from reclaim context).
> > 
> > This time I have fully tested the patch set. In particular it survives full
> > fstests run on ext4 both as is as well as when marking all loaded ext4 inodes
> > for deferred reclaim to stress the deferred reclaim paths. I have also tested
> > (when marking all inodes for deferred reclaim) the patches by creating a memcg
> > with 128m memory limit and then scanning from 10 processes 600k inodes in total
> > which heavily exercises deferred inode reclaim paths. This also verified
> > efficiency of throttling of marking of inodes for deferred reclaim. Basically
> > we cannot guarantee any particular limit on the number of inodes queued for
> > deferred reclaim as that is bound only by their number in memory and memory
> > pressure. But as the number of queued inodes grows, the tasks creating them
> > get slowed down so eventually some equilibrium is hit. In my VM this was
> > at ~10k inodes (only slightly above the 8k limit when throttling kicks in)
> > but this all very much depends on the reclaim pressure, speed of deferred
> > reclaim etc. so I don't think this is some representative number.
> > 
> > The first patch is a pure fix for a problem I've hit when running fstests.  The
> > second patch deals with lazy timestamp updates which I've decided to handle
> > better directly inside the writeback infrastructure instead of deferring
> > reclaim. The remaining patches implement the inode reclaim deferal. Ext4 use of
> > deferred inode reclaim is there mostly as a demonstration. Other filesystems
> > need to determine which inodes need deferred reclaim and mark them as such
> > which generally requires good internal knowledge of the filesystem. I'm hoping
> > that once the infrastructure is there, fs developers prompted by MM warnings
> > will start using it :). I know for a fact that besides ext4 e.g. btrfs is
> > hitting MM warnings in inode reclaim as well.
> 
> This all looks worthwhile to me!
> Note that Sashiko is complaining about long-term stalls introduced by
> this patchset. If this is intended or bs then please let us know.

Yeah, there are some good suggestions from Sashiko. I'll address them and
respin.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

