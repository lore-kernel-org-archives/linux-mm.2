Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6767CD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 21:38:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D064A6B0088; Tue,  2 Jun 2026 17:37:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C90326B008A; Tue,  2 Jun 2026 17:37:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7E9C6B008C; Tue,  2 Jun 2026 17:37:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2E756B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 17:37:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C7288AFF8
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:37:59 +0000 (UTC)
X-FDA: 84836285478.04.8CC728C
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 11C414000B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 21:37:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M8lWh5+g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cGUK5jrQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ei+a51m/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvWaNZL3;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780436277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSF02Sys3oVPf3cWJGRWD+ZLq8fEyAUMeudt9t44hp0=;
	b=egqCXxTzu+Hor892M8ZwLBLaTIAoJUpoouJohzoiIMAQ3yPjQ4LkD4VNGHCp8H216RIm6+
	ex6LOXLxPBFs4nGisQLWZ6/7disbavu9lj0FYmqtfl1LACul3r9pfvIqsIWt+FMhnfwU4z
	8EbFLr47sPdjOffTkVK8Orh8fkQMtZw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780436277;
	b=63npzEPUQqvWswoqCFKfyXS1ffYcooBA6XfDXF4TNNpT0msZdT778Q7wxaQvDkViKiUcfT
	0v+0R/u05tw37M+UxX2CrAuHu7UHjxicVMBzMQbHB6lGdzjAAoCm2P9/kDyk5+X3mKLTcD
	Eg7waPzL7bRtW+lOiUv9jHR4NGYGiP4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=M8lWh5+g;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cGUK5jrQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="ei+a51m/";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LvWaNZL3;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74D596ABFF;
	Tue,  2 Jun 2026 21:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780436275; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zSF02Sys3oVPf3cWJGRWD+ZLq8fEyAUMeudt9t44hp0=;
	b=M8lWh5+gTYn+cX72Ntq1+YGiMGcx6YZmz1dmG9Wrx9B/274KkcNZp5X/tS8oulRC2FmIg7
	xdojLIred0QPr9SZY+H/crZU7e/BuSRXZZQXbbkSafomj0Ybe8clQLVJXRznCwHMZhgyYh
	yCtmpnSWs675bUrW7Cx9JmU87Di+rPM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780436275;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zSF02Sys3oVPf3cWJGRWD+ZLq8fEyAUMeudt9t44hp0=;
	b=cGUK5jrQZioFApFgCcvA2bgc35fJD9djwlafuGa9Hn74YwjeZeQcfOklZ7tTfptgjcVcd0
	Yqa098xA+NDP2PDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780436271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zSF02Sys3oVPf3cWJGRWD+ZLq8fEyAUMeudt9t44hp0=;
	b=ei+a51m/ruJ9TbtcRdBQqkNkuhAFbXg/qwTdVkjG41yfbFcn04w4R2kjvNru6yEevyLYql
	L0QWalNPOCu17ke+5l08d8jgRto1iF/1mC4xoqBaAAIdxgJpAHl+jXDVPO2i8wzzrDHIN0
	mXhzzJVGXNvsZdROmv7jSZrE+R4GGe8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780436271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zSF02Sys3oVPf3cWJGRWD+ZLq8fEyAUMeudt9t44hp0=;
	b=LvWaNZL33lAkRhyyL80fTL5EWeSVk0ezIztFD6kqOYSfa+FvCYHDzo2ljQiJvY8No3/fyg
	v5GNFqyrx+YbcnBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43128779A7;
	Tue,  2 Jun 2026 21:37:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id o9UKDS5NH2rCCQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 21:37:50 +0000
Date: Tue, 2 Jun 2026 22:37:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, 
	willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ah9LaPQayJ6tBE53@pedro-suse.lan>
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
 <20260602211242.13870-1-safinaskar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602211242.13870-1-safinaskar@gmail.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 11C414000B
X-Stat-Signature: 71omb9wxou1swjza9ud7k77rmtnddxuc
X-HE-Tag: 1780436276-459926
X-HE-Meta: U2FsdGVkX1+ogkh7IQV02QdWjqRh2+PRlev5Jhu63nHtm4STkkDADIoSxPddHaN5eT+NgDYHPPmQkS68dSLnol5tG6jZawxAPc2yy21UHHNcusE6tHBFEpbKN9LSkP5SHmMk/udr9onJXyd2gSZUib2UK/D/Z/yGT12WxM0s+Pu1YJtk5nrlZvENdEvEVVy9zbNOEnFB5BrQZQ/7xOdaGvgyO/mpSCYWg4aiKFnCZuZLYVMV5BLhOQy1ayQ7ohnpodlraN/JCZZ7ArVCZHYi2QP7C78RvzU7xnJDkO/bJcVi88f36YnpaW3fm5GbnmvlueXPHDZ4ZX94thHFvmhCvegxLEC2jzPttZ72LoIWj4753O72PCvgoFLtexccaNoB+cjNvjdBSKdJ1qysO9igYb7VOxW8N+9JApXxRQf7biVO20D0HxWxVOf03uRKk2cqmmFhODlOd5q6IGYY3KXVuCNTOa9YASTsbsortN/4H3IDVpfVhUq4/AtgWvj/CdedPcK6qfSwbJMG+X9YyHiOr/kDvuXCFkJ5F3aYI2z5zmzGT9EQUd1qjgWm0h+yCIuBHSzjjK4Jl4vT384KF2t7n5vQdUwAHJX4uo7cnS0matf9UGQmOxIo8DvEkThD4PXOLAPWK/j3Vp15BiPGSJQoYIjJ8t0091Kii5jRJ9Hi3cMYPasIh9Ks04pcJRPv1Iz5LO8uh/UIlYlx0JuJWY2xdiRVl5FVWw52hk7LIFK1pEqA3Q8eZ879eAcRrfrE/Xp+YSotoz1+bnI2NX7gmuyeXO7Ey88E0+3DzkVAyianJFnEK/xtYFThPdWkQ+dQjAcKqL1jLfXzLyp+ucwBdG78ca726aUjUDLDabJNJOfOZ880rKqi+D+fEjYrkE6gIgQMIFR21kgXBVqHPZKHzhnswnoxBcfGpeVOAIuVzZ/XfLKImlYOGsWF04unPdTuW35SLKrYRsmtAbTwygm+rO4
 +Xz3v2pg
 6aGtsKZ8hxtiVImYmRAtGud4K8ss7jmkmvwSWQjsGaHPSAFmz3q4jhL3Wt1zL3hIxVMaHDwhjJicl+eLKJDIiGzvRvX/UAdqcznJTBF9TKSXfVYUQkjRhKBZ18ojF0n/n6mu2bTd1akhvrkVu8S+dIz/fbXWTu+FMvVaUGnLQZUeq5IQ+9VJ6E/nCfkefY8AGAjaFvXYHbHQCfjSyk30xkUJ25Cmo6AgnCgN85cID00vmTPr/YwsBLCrNZw+W0YEFbfpFCCYV/k2IOx1dLO7jaX4dx69uOeSpcKZD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 12:12:42AM +0300, Askar Safin wrote:
> Pedro Falcato <pfalcato@suse.de>:
> > On Sun, May 31, 2026 at 01:01:04AM +0000, Askar Safin wrote:
> > > See recent discussion here:
> > > https://lore.kernel.org/all/20260516182126.530498-1-pfalcato@suse.de/T/#u
> > 
> > So, you took an ongoing discussion with an ongoing RFC patchset, and you
> > decided to reimplement part of the idea on your own, as a concurrent patchset.
> > 
> > Riiiiiight.... I don't think I have to NAK this, do I?
> 
> Okay, possibly this was indeed inappropriate.
> 
> So this time I'm asking explicitly: is it okay to post new patchset?
> 
> I want to post patchset, which will remove pagecache-to-pipe splice.

Well, that's most definitely part of my patch. Also, you cannot outright
remove splice() functionality, it's pretty important (besides people doing
funky pipe business, it can also used for stuff like "take these pages that
we just got on a socket, put them on a pipe and then ship them off to an
actual file" with minimal copying; doing stuff like sendfile() also uses
splice() internally).

So, I guess I'll be sending the v2 soon.

-- 
Pedro

