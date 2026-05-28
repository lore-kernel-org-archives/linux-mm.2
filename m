Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369F0CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1316B00A0; Thu, 28 May 2026 09:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952F56B00A4; Thu, 28 May 2026 09:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8685A6B00A5; Thu, 28 May 2026 09:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75DD66B00A0
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:00:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26FB31A0830
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:00:05 +0000 (UTC)
X-FDA: 84816836370.30.6AA70E1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id EBCE540013
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:00:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T0UXoAWO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8YD1IAhW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T0UXoAWO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8YD1IAhW;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973203; a=rsa-sha256;
	cv=none;
	b=RTxrZJcdutc8bIgTv4hCxvtEKgEIeKsMTbKkIuhIcVnm06Y1DYAXqSVncBZwDbTg7WgeS6
	VcEHOOLwz/pQwV+kiiHByNPlijbuCTYiY/7qVkHHYB0LTsbQhUYSH4LgNGapXqre0tXWap
	DsZxmicn6ovzQDBjrmx4K6qmvC2rh5Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T0UXoAWO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8YD1IAhW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T0UXoAWO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8YD1IAhW;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uWMGPiFFEoPtLga1o3umCg9y3n8wcDkGSWAPBBrAqM=;
	b=0CJyI1ueK/QbYSGgCtLTAGyWJbQQJO61YWR6BmN6GqUiylw66vve9ZxxcPhLtkWoNEn4bE
	poOLbizFLCCXdqsBvOe0E86z2U3SZK9T2P0uKVnMS+Krvlbni9yaOwgO9vfeYRNB1Y1R68
	XPcAHdAtbUtauwwhqvUK0PkcR6Z5bvU=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 94C5166EA7;
	Thu, 28 May 2026 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779973201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uWMGPiFFEoPtLga1o3umCg9y3n8wcDkGSWAPBBrAqM=;
	b=T0UXoAWOAywx9BISEdCcf3/WXeg24b+fopA/2687OMPvMq+T1L4bkOsmXPed8/tXyo/+sz
	v14D2A/Y4OX0cmjC3cmozYCBbTM1hwYxs2ZFZ9h4QA1DEChaz8Nn/D/7JWr+WGa9f3Q3JK
	vlEMTKMVzlyhyYc021FRvFc4vf+gUhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779973201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uWMGPiFFEoPtLga1o3umCg9y3n8wcDkGSWAPBBrAqM=;
	b=8YD1IAhW6s0t9pNmshA3Oj+MGZpmq6wrPMUl6znMwW5j8uImZUj0oPHgoqx/TK99KjMzrv
	EJioN7D2hL59MWDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779973201; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uWMGPiFFEoPtLga1o3umCg9y3n8wcDkGSWAPBBrAqM=;
	b=T0UXoAWOAywx9BISEdCcf3/WXeg24b+fopA/2687OMPvMq+T1L4bkOsmXPed8/tXyo/+sz
	v14D2A/Y4OX0cmjC3cmozYCBbTM1hwYxs2ZFZ9h4QA1DEChaz8Nn/D/7JWr+WGa9f3Q3JK
	vlEMTKMVzlyhyYc021FRvFc4vf+gUhE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779973201;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7uWMGPiFFEoPtLga1o3umCg9y3n8wcDkGSWAPBBrAqM=;
	b=8YD1IAhW6s0t9pNmshA3Oj+MGZpmq6wrPMUl6znMwW5j8uImZUj0oPHgoqx/TK99KjMzrv
	EJioN7D2hL59MWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D16D85ADCB;
	Thu, 28 May 2026 13:00:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /lXmL1A8GGqwIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 28 May 2026 13:00:00 +0000
Date: Thu, 28 May 2026 13:59:58 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Christian Brauner <brauner@kernel.org>, 
	Mateusz Guzik <mjguzik@gmail.com>
Cc: Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	Kees Cook <kees@kernel.org>
Subject: Re: [RFC PATCH] fs/splice: allow for a way to block splice() with
 read-only files
Message-ID: <ahg6JgO0wUkJKjRb@pedro-suse>
References: <20260516182126.530498-1-pfalcato@suse.de>
 <20260518-starten-messdaten-3b8aa670ec85@brauner>
 <CAG48ez0jbSUgT3ZxPKZP7Eu=K7ce2cX7k2NzHCHNMOxQjOGT9w@mail.gmail.com>
 <177918418452.771415.4371785688744608623.b4-reply@b4>
 <CAGudoHFtecdkcYpFrtM5RAAPSU11eL_ALPGp_jhtHW=WxyHE4Q@mail.gmail.com>
 <177918837114.804096.3977912252785122973.b4-reply@b4>
 <CAGudoHGSZOEzbXHOAGqrdp6D06JQQ5Af759TQ+HiQx7=ruQa-Q@mail.gmail.com>
 <20260522-haltestelle-laufpass-volltreffer-3c69a6d84fc4@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260522-haltestelle-laufpass-volltreffer-3c69a6d84fc4@brauner>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: EBCE540013
X-Rspamd-Server: rspam03
X-Stat-Signature: ipit79jm1dccirz8bu1mfsx9kthcgemp
X-HE-Tag: 1779973202-487358
X-HE-Meta: U2FsdGVkX1+Lvx1/Ipw/NTgzf9L+6cTLvzQieDk/0fTS95Bu9sxxdWb+xBEW2x3ph07ZEs38yXd9HXE+FuS1TX/ONkUJz/9066RDXkzlkfmfxqgftOH/4LQv6FGTqR59+asO8EaOkDYVivyxxWgN6tv9LfsIah0yUB98aYtKjbyeSG23zQWzBFSTnzCem9Dl8IQtzCGqxdhhDM7gJaGUBYmERp38zwq7mnX2+oCpznuytQ2Spp+JCLXVxFgFZdMmL+KCB8F8DkDrSzfhnTc/I6v+tBqHL9VjuRZ+V9nzBDz+nIer0o8BkKHIfRU6vn1vSIZWhbkNBba5z9lVIppJfU4umHZ7RAejnIXiExvVOSZWn1faAPt9cxbAPuo5ghDkmJ/LVRRCitBQWOe1Nwnc+2S9u93HfLHUJW7oAXynFJCeqUD/o6r+pu2uH5nJh2sbSYUku2lGvHmBfqsGYmZVcTL0PhWJe/XFVW6RcX1NImeu09VQqrzah6X+ULuVV8hhSGOsh3lNB2w+8MkFT77uyQyl28V4PlNSCqCZgLEpGCRFBLrtwSbaAApwFpgJsIyzHztybjSwfeDBpC0oliqekluLN9FamKsHgWU0b2R8RDJeGda24o5+mS5CZAAZymraDesUCI8JtPNLR6YsCareXVtzysFMM+J/LXMa5cHRvqS44ezkj3ox0HLvgsftohjY86Yt4bPfXcp8QInZrS8ag/1kwYoaDpHK7eRLru939PTYgJG4m84gxcMYg68RF/F0J2ji9nnbaz3pkPYyPtqH4pKZ+L9zZll6zrCIHR24bVBm86oIk3/vVUIYXODfoQPzry4JFZ/zvWK30icT5OMnKR8I/sWcQ+Kh8+X+MiACxEyuE40FjJjNdLe69OdyZtWvCYLocx/EHNSloa4p3ysanlH49uGnNNmzVf0va1wHMTsTlUQDx6oh04iA/Vr+flzcuoo8gWXUjRARt3x2PeZ
 z6WM3svv
 6bjf3tRNU8rwOVH3N5eM0LPUkIndch1LVxU0V1x16QZmPrm/7MQQ9xSZrEjf3V75ZbXEBGhqvLxJs2sxFmRCMgWLhV2d43+11NHUIx9SD3Se6Rj7yi8K9gBrakF8rDNQW5il6dBAXzD0f0so5SjkID0w2PfRPdzmVQYdiwcOo0gqvIZ0dTBAC16grQPtKC6YbSQwvvEkAEgNv166NVUoUaIXbRvL/1DTLfY0zhTraeu5hssu5yVoGM8yIQbHKojPKgptkGwbcACzBYr5+nYxg1ClatqlACZB8+H3bSLpn4f+/VL62cUwpfn9A0F1keM0Db+Z2qZOwmk2LT99X7GVlq1xR2hGMJfv8bK2XHQ5Op93374SIf/zIg49ejnb9RiB2xCcz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

Apologies for the delay (laziness^Wconferences, travel and the sort),

On Fri, May 22, 2026 at 03:11:11PM +0200, Christian Brauner wrote:
> On Tue, May 19, 2026 at 01:56:42PM +0200, Mateusz Guzik wrote:
> > On Tue, May 19, 2026 at 12:59 PM Christian Brauner <brauner@kernel.org> wrote:
> > >
> > > On 2026-05-19 12:51 +0200, Mateusz Guzik wrote:
> > > > How about denial of splice usage or degradation to copy are still on
> > > > the table, but based on a different criterion: whether code involved
> > > > is "known good" for lack of a better description. iow the kernel would
> > > > maintain a whitelist of "safe" cases. Random-ass AF_NOBODYEVERHEARDOF
> > > > does not make the cut.
> > >
> > > I had thought about that to but I felt a bit iffy about it. You could
> > > envision an FOP_* flag for this:
> > >
> > >   /* Module may use splice-like apis */
> > >   #define FOP_MAY_SPLICE          ((__force fop_flags_t)(1 << 8))

FWIW, I don't think this works. Sockets expose the same file_operations struct
for every socket. So while it could work for other dodgy fd's around the kernel, I
would hope there isn't many of them... (or at least many of them using splice,
etc).

> > >
> > > But that doesn't address how fundamentally broken vmsplice() for example
> > > really is and that probably no one should get to use it in its current
> > > form.

Right.

> > 
> > I never looked into the area on Linux, I am willing to take claims of
> > breakage on face value.
> > 
> > In this context I'm saying the functionality is used in the real world
> > for performance reasons and just whacking imo does not cut it.

Which is why I wanted to introduce the (admittedly, rather adhoc) approach
of limiting it to files that could already be written to. So hopefully it
could actually be deployed. I'm afraid many users out there will not deploy
a "go slower, safer" flag.

> > 
> > >
> > > > Common-case usage would have to be audited of course, but this sounds
> > > > rather actionable and would provide hardening without much friction.
> > >
> > > And that's the usual problem where rando module will just raise the
> > > flag. Maybe that's fine and we will keep up.
> > >
> > 
> > If this is a genuine worry the whitelist can still be introduced and
> > managed by one person (Linus?) very easily. The implementation is only
> > mildly cumbersome to get going and trivial to spread afterwards.
> > 
> > You could have something like this:
> > struct file_operations funky_ops = {
> > ....
> > };
> > VFS_FILE_OPS_REGISTER(funky_ops);
> 
> Unless someone is going to do that work a sysctl to force degrade all
> the APIs into copies should be ok.

Ok. It seems that the general consensus is KISS and just degrade everything
with the sysctl? I can do that for v2.

-- 
Pedro

