Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B428CCD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 11:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEDD56B0088; Tue,  9 Jun 2026 07:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9E956B0092; Tue,  9 Jun 2026 07:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D1A6B0093; Tue,  9 Jun 2026 07:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B762C6B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:58:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A15D164959
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:58:09 +0000 (UTC)
X-FDA: 84860225898.18.A4255F2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 11077160002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 11:58:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i1R+foiG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI0SK3vP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i1R+foiG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI0SK3vP;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781006287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGM5g7plYNXIvzStQgV2+Kq6MgppG+RuUZMfu/hF50w=;
	b=AXTT6zUbA8ZqUIMLzdCeJ+0W1zglXe0ySDUugZQql6aGLAq5iFtyJprIL1PkU6/OgZHESj
	2AIyrUexq1MvtZFRGc168NH7g1JWUbPSfJfGbFj6y5VoNXXGoPyNlpt469yafZsEwd4V0V
	puTs4aAT1XO2CBdTUORrtojip5IdMuA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i1R+foiG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI0SK3vP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=i1R+foiG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WI0SK3vP;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781006287;
	b=7Mky9KWdIsJ6ZBkPAgqFkzIqZTKRE/qG3dG2dQUS4+K3s7geWKjvVRxJqSwUJuThq+B1as
	qYq26MTXHM2i7e1urXJ2xdxpCDXXX5AEuQX5h4su3b0q4rBKtuerKn1f8Kb9VRz0rJN9Ht
	Cj8kSrYgswxe5um87VTQY57MzPSXvKE=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7A24F75A2F;
	Tue,  9 Jun 2026 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781006285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGM5g7plYNXIvzStQgV2+Kq6MgppG+RuUZMfu/hF50w=;
	b=i1R+foiG020sX6wgKzA1tQWnfup4eIKcWpbh1RHHWqP5KudcF90KLsSPZUehbJgTKpd6N7
	a75LbM1JpkHQ6md0Uk63tcSvpeso9xmyUeJM/rY9GWS2OgMHmCNfL0oTnta+oxGwxiCgFr
	Smp1dvumA+I/wXXsa2HTL+r8oblOtcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781006285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGM5g7plYNXIvzStQgV2+Kq6MgppG+RuUZMfu/hF50w=;
	b=WI0SK3vPhqyUSFCB6q36lkKhj7b1CP9oUo8CPvQQXpEMsB+wihsRmtzz6UlMaCkCgrdQL1
	FFXCE2gLDis7e4Bw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1781006285; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGM5g7plYNXIvzStQgV2+Kq6MgppG+RuUZMfu/hF50w=;
	b=i1R+foiG020sX6wgKzA1tQWnfup4eIKcWpbh1RHHWqP5KudcF90KLsSPZUehbJgTKpd6N7
	a75LbM1JpkHQ6md0Uk63tcSvpeso9xmyUeJM/rY9GWS2OgMHmCNfL0oTnta+oxGwxiCgFr
	Smp1dvumA+I/wXXsa2HTL+r8oblOtcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1781006285;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xGM5g7plYNXIvzStQgV2+Kq6MgppG+RuUZMfu/hF50w=;
	b=WI0SK3vPhqyUSFCB6q36lkKhj7b1CP9oUo8CPvQQXpEMsB+wihsRmtzz6UlMaCkCgrdQL1
	FFXCE2gLDis7e4Bw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6F0D4779A7;
	Tue,  9 Jun 2026 11:58:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sif0Gs3/J2onOQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 11:58:05 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 02A7DA0A90; Tue, 09 Jun 2026 13:58:04 +0200 (CEST)
Date: Tue, 9 Jun 2026 13:58:04 +0200
From: Jan Kara <jack@suse.cz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, David Hildenbrand <david@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] invalidate_lock not held in read_cache_folio()
Message-ID: <xlli3piwrcqbnjvl2bcksafr3epl2keaub3ee4si25l7x34cvh@y5i7knph247o>
References: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
 <aiazUtNaS5mVlaCy@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiazUtNaS5mVlaCy@casper.infradead.org>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 11077160002
X-Rspam-User: 
X-Stat-Signature: 9u5y6bnqyspdmzk3ttnxuqz9wf5bj3p7
X-Rspamd-Server: rspam09
X-HE-Tag: 1781006286-722357
X-HE-Meta: U2FsdGVkX1+YT4ncLb4woa+TZR9GQY+2n9eqvO5vd5AtmLNhAnIflM8AFWDWtHRUPbxkxxj1SRc7/4zhgP7LpPzzKmmozTiFmghGlPpVCuKSzm6nJ8TdsKmUeZvk5WzVcDSj1hAc9Z+5uMk1WgnFvx2Nf6wxexa4Tw+wavLjz51sLZQt05IY8czMvID1GpVSvIDWefoRDPDDS+wtX3nMUe1gSQc74cBPAuaO9CEna3dpCYpGsr0ysVXT6Fa+KqCDrGlmVszTtqVHKoXTW95snRzjFOekx+SzwHsIHkI5IoQl2WOvDamPqijvoQww60wuEb85KQ/WD/lsN6mly7cPSdNBzu+rbd94EoKP/Y36kVJiQq8o2XNQWRe2ukDKG7nhhacjyIvfCvmRMD04t1o5d34NqaU5mJM1/JxOJhoKp5yWxBdXL3n3Lg4TQ2xvYaDGWEsTvTXbTBAPyikhknCeN87jCp1KwzQaft4+PLPKibLF9aO9npIN2mBByuvdJ2y0dR0slPnQixkm+Q68/4bUQCbEMiuScwuji7DbjwezT4C/UtQKV6o85Vh9SxqGgtxFTGfapiSNpQFuShGdYOn44YP+AX31fzIlWfqdoy2osw9d/Hs9o9F4TmUBjUCUcdMLqLBlm7Qu7Z2kQL7QOSCZrvttrMJ5aZg3LWqCqNEvpOnmFJLUlXAMdxSCX0/HBVsACc/nIhHrlubwjgl4w2Q9jNvzpAyFfHsPhYMZQ2oQSF5Ej7XiuPUGJT4LqhizUBMe7Oabh20scM+Ul3EeQLfvRnWwuyuu80Uuz2bGINPt/yD4rDJNT+l+4gn4dmHi3brtcAKSmE+I0xT3to+2kgCgzzD1AsoEJwuRlVWo7MOwVchQPZl2PH09kDkpeb8xcd6IXq+BfhLkbRTqJEcehLws2I7LRDYIHNGO667Qd1DnoD5B0El1WQakAU9+vKsraCkk0fYBXronXZbXbClbqgj
 shBrUr9L
 duqOUOTAO7ARskiE+EFCXc7wsRYUDIR/VeHZR9/Dbz+4UG4a9HNFgFm028sSMyl3R9Rex6sr7r2ubH8Yr/S8cMrLQ/Rgv2aVkpmmzTow7pcM2I1H/kaTsu/IOdxQSAZE4BKVxmDEV8uiX1706iG77r1w34kX2ySwIcIjiGE482/rozF+qcxpLaaMV3YO7WwgvxjlEVjSRCGjYlYE1y4tNZE4qqJedkWeutVbO3K7JALO9TubZrKxC+NeogwBVv97peFDQ6CIP4I8kxgcvxgSBqPDNDwIcMzhCfny0V6ArqSXDKarOlb7OerEBnvOQsdNUXIy8UzfbYods9a92e39u0XY+cJUSsLTyn8jvgnGMxL1t5Va/Ppvw4cWDcGtA52DBFwQbpoL+aLY7Ku2phvmagIFPkhsyUswjLbwYbntHmejKdsf50j/YOdn7xJR40Dovm2yZVWosKcIXi6hQ/U55WrxSMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 08-06-26 13:19:30, Matthew Wilcox wrote:
> On Mon, Jun 08, 2026 at 04:54:51PM +0530, Dev Jain wrote:
> > Hi,
> > 
> > My understanding is that there are two ways we are serializing against concurrent
> > addition of a folio into the pagecache (see 730633f0b7f9).
> > 
> > The kerneldoc of read_cache_folio() says:
> > 
> > "Context: May sleep.  Expects mapping->invalidate_lock to be held."
> > 
> > I put the following in __filemap_add_folio():
> > 
> > +       BUG_ON(!inode_is_locked(mapping->host) &&
> > +              !rwsem_is_locked(&mapping->invalidate_lock));
> > 
> > 
> > And got the following trace:
> > 
> > 
> > [    0.115587] Call trace:
> > [    0.115686]  __filemap_add_folio+0x5dc/0x680 (P)
> > [    0.115871]  filemap_add_folio+0xec/0x2d0
> > [    0.116031]  do_read_cache_folio+0x144/0x2d8
> > [    0.116194]  read_cache_folio+0x1c/0x30
> > [    0.116344]  read_part_sector+0x4c/0xf0
> > [    0.116499]  read_lba+0xb0/0x1a0
> > [    0.116627]  efi_partition+0xa8/0x740
> > [    0.116769]  bdev_disk_changed+0x238/0x620
> > [    0.116939]  blkdev_get_whole+0xac/0x100
> > [    0.117090]  bdev_open+0x280/0x3c0
> 
> You can't truncate or holepunch a bdev

You'd hope so but see blkdev_fallocate(). You can punch out pages in the
middle of the bdev mapping. And the blockdev code actually takes care to
grab invalidate_lock around the punching ops. I'd say that
read_part_sector() should grab invalidate_lock to protect against these
races.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

