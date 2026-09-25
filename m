Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D5ADC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 10:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2275D6B0088; Fri, 25 Sep 2026 06:35:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FEDB6B008A; Fri, 25 Sep 2026 06:35:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117B26B008C; Fri, 25 Sep 2026 06:35:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E27386B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:35:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6E5921A05C6
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:35:05 +0000 (UTC)
X-FDA: 85251926970.19.1194064
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2DF6A000B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:35:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sHDDZXOH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EWyleEm2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mbSFHP01;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AGIdiRXb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790332503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=GACQDYoEqcySdBpj4tWk6EE2AZUpFFn30txiohKMjlxgJ7vEVo3V8irQHaW8KfwhrC3X9I
	wrn/upjhG6NEUMcdT0fy6qG9kYTLsCr5BaEAp3j+oQ5Dn2FH4rZkfsUfEwMiIcxNeg2ORj
	sAj5zsBz5Mwxc3yy6dXh+7420KgtuLU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sHDDZXOH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EWyleEm2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mbSFHP01;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AGIdiRXb;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790332503;
	b=sTBRhD6y3ezX185EdmEQsHxevXd+xv3qrn0adsWKzpl5qfHWKwlhWcn/qbkuiBL2HGbJEv
	xcij/jD7xefA7li4LEc4C9wp+Lvj6H1FDVdcJImIjp1Gc+3bHXukGqiY1xC+dMyduoHJBz
	P9mkrsrtZK1Npfq/2lM83oVbu/UJufA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0FB2020173;
	Fri, 25 Sep 2026 10:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790332497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=sHDDZXOHSyUK2kf6s0YAqGzmTi1vLCDLNNZgXmrEbKyCLWk3J7pAlehfU+wKV/sYOePY5o
	ETEWt3g8dwmv9uvSNGzI4He+yjtRQ/5iPCQdf668Wuk8tfuF5w5ROa/ErRXmeA2J1LL4PE
	lrNZsZS/6b9cpZWAx0vHk+yo9/tJFJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790332497;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=EWyleEm27YWVXBqG2SbnDiPzTHLoUvyQvU3QF4ME+bjunA7e3IHn3i/g9pTQTCxgQsSiK8
	L6bm0pzL+BJ6NUDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790332493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=mbSFHP01JNXU2AmaGwx4rwSzdR2m/ZlwshNNgiCJeWxKEtYfHICYb5ediWc41eQsBCcxtR
	ZJJitcTfNXFcg3VB1IsTLFJow0UNrZxUkMmf8fFlJbpbjMY8psqZxrKzV0RFDTk85zyht0
	saOm6R7j44wAcGono2I2vZPYhf33VJU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790332493;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmWBmGiYLCBQGGp6qkvxtGAccccpy3zMvAj3zCRN2IA=;
	b=AGIdiRXb2jxsg3XbV7X5oEoMi5jXS9fP7pcbs03Qq08ABTAbG8C1K6tBCcZlDVd5d09IBA
	ARdF+jmpZ93xVxCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DC338136F7;
	Fri, 25 Sep 2026 10:34:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id nq/PLExOtmr+bwAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 25 Sep 2026 10:34:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 67281A13DA; Fri, 25 Sep 2026 12:34:52 +0200 (CEST)
Date: Fri, 25 Sep 2026 12:34:52 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Julian Sun <sunjunchao@bytedance.com>, linux-block@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	axboe@kernel.dk, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <3w6vfwfkojmfqy2qs5j4q2s2366ajqiwmqf624lyn3odrv42v2@va2r7a6ngfz6>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
 <arYaMbJUh6unvz_t@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <arYaMbJUh6unvz_t@infradead.org>
X-Rspamd-Action: no action
X-Stat-Signature: zi6tfabp7ut4rmpqwa6f8yhowe1ik8be
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E2DF6A000B
X-HE-Tag: 1790332502-794589
X-HE-Meta: U2FsdGVkX1+TdxGnFYHzNFGf6nJSH4D3SbJtj6bcISmDXUkqwRd4lDZheUayeZzRllwGRFHDa2M78Xpg2MFmmp3W1ljNeM2dvWwC275ObMqXjxFwu+9YTkKxG207Yx8/hH3HxsBfL/9M88S9S9rwSxRYqFehhpF4xrt6MyRJJZwlwp5h1FqIWPVAPlLB3wWgqOl5D2vlTN5SuvT0JBS1ztujlufys2sh/ALFs2Lj2pUmTnBODkNZqde27knDF9+dFb26NhAL6uolOuazrAHm2EqlqZDvp9C7g2sWhvM+byf9WPRdvjLB877CyQX0BNG6RhntIYoCDiSgakrmW0yugTqp2dodsQepce2hTdpuuHTzUr1bE3qzY3uFqZN4LtR3ZoCllR4LoFnM9SD437RraPekdZNAA35eEcOjCrQEQFaEbRyQkGEyLc9AxXwx8wDTvQKFnQIyfjdaEUxJ3k8nT4kVmfkMUasRnIdJ8fIIb2yGqlczG+nrazYdgaC+Gs2PNjUbpwKYOE+XLT67jsPH5Vw0Sbf2yzZe73GOkU3CqKBgOEsh9X2HTKL9Dy9x3Hr8N4sDAWQHjKLav+tDW27qu2XAS0yTqCZhQ7g8UCSSTUSiR9/0LfyYYvbPBLM+RyJr2UpDaj47vnmFiqakOqN76XNumRT+2gvPiKLJkYIuS/svN+apRTngnFKDgjQ0QhvvyX+0xzO8nBiwk694tcgPJuAxkJTS3+Knqix1ldeiyKi6NyS9NIosCQcb3cd4Ym7ibVhExsanHh3m7RHOf9acdPxamisTmPKhJIA+pPlUpMQNB5g/s9kUImjB3vVnP9HJvZNhMToliKzpeCFbuGfLAQ41JStj0jzAyS53ZTLbpy27z8TUyhmb9sbnKhfi8vZbiA1be3zQcMADJtDZaLsV+CA7LW2AQ+tm2IUA1vmTTAt/2Fvc2iAVT2vmRJoYVTwxppD3zQXwB7Xqm1qrnlo
 xqb0XO8G
 u+WRkR/TQyLygUhyJ3EYkEnNsYMIq7W0MQQQRSLwRRglCIpUD+14fPna7Yx8qgyOJRJ6STVARwGGukjmeZw/B4rMJC1gBq2G719gKBOqnpRTXkOtezp7oCwio3srEga4koG8/lD0Kx1IgB+KfXJ/W5ncGbEVeGysj/Iw0bqxavj0noosAU1yJhxNEBxcGZRNDUO9WzV4eZMWhq2/UiHqjlg6zeDiKgoYL49CdY2y/xjJ4U0mDsLpixiIaE/xM0759SOyKbWc6lv741yRbRX2kV26XyyRARQp62QJKpZaSQWNEZViFBsapYWJlNzcJ28Xnw5nkQE6c/irDbYbn9j9XI37BL9rZre0tlcVbvQbqV6hHovgFUmoyGwZxrnbdDpNSDUy5OHtnmJO4cWk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 24-09-26 23:52:33, Christoph Hellwig wrote:
> On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> > Add bdev_flush_by_dev() to submit page-cache writeback for a device
> > identified by dev_t without requiring callers to hold a persistent
> > device reference.
> 
> This isn't really a flush is it?  This is writeback.

So bdev_writeback_by_dev()? Fine by me.

> > + *
> > + * May sleep while submitting writeback; does not wait for I/O completion.
> > + */
> > +void bdev_flush_by_dev(dev_t dev)
> > +{
> > +	struct block_device *bdev;
> > +
> > +	bdev = blkdev_get_no_open(dev, false);
> > +	if (!bdev)
> > +		return;
> 
> Please don't add more blkdev_get_no_open.  You can get from an
> bdevfs inode to the struct block_device trivially using
> I_BDEV instead of doing another lookup.  Or just grab a reference
> to the the inode, which would seem even easier.

Well, Julian is explaining that in the cover letter. We don't want memcgs
to hold bdev references just for foreign flush tracking. There's no easy
way to get rid of them so they could pin bdevs for a long time leading to
strange artifacts.

As you write, we could just hold a reference to the bdev inode. Those get
unhashed when the device dies (__del_gendisk()) so memcgs would be just
wasting some memory by holding these inodes alive. But still, transitioning
from inode to proper bdev reference verifying bdev is still alive will add
a bit of hairy code (essentially what blkdev_get_no_open() does plus
verification inode is still hashed). Plus when replacing foreign flush
entries you're under irqsafe xa_lock so doing iput() from there is kind of
a nogo.

So I think tracking devices by dev_t is a good way of dealing with these
problems. But then when flushing you have to transition from dev_t to
struct block_device and blkdev_get_no_open() is the canonical way of doing
that (and note this use is just internal to block/bdev.c).

So how would you prefer to deal with that?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

