Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0309CCD5BD1
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B61B6B008C; Tue,  2 Jun 2026 18:41:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48CB26B0092; Tue,  2 Jun 2026 18:41:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3A16B0093; Tue,  2 Jun 2026 18:41:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2915E6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:41:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD41CC0558
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:41:46 +0000 (UTC)
X-FDA: 84836446212.07.976C62A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id A585820003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:41:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kkmq6f9i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=e8gJMoYO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kkmq6f9i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=e8gJMoYO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780440104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z4sAf9CWdWRBvdOC/VGUxmfAjIcDMPecq5z6keRuBsA=;
	b=hy+WdNCkpLrIYbuAva3+PMBzeuUj4OMty0/z5WYEZyXDbU0iW029rrP4/HPf28x1TjxN06
	4ko/kka7znIt8piZ7mbR9rFI+gJyneJEy83fPuM5lBxYi9yikcDYhBuoc8OY/Oo0yp0hJp
	cFPJDQWwMwafzyiBwDvewmqsm3YUMKc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kkmq6f9i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=e8gJMoYO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=kkmq6f9i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=e8gJMoYO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780440104;
	b=LSkExS6EF+r8TdDHzovKe3fyH5hCJ2wN+Bx5pOJmlFfzUPU7DVotWtglfnYxYx9gZzAOie
	9QJDrPTul7q8e/6cQISsnGm0d7gmhM9hqh6pW8C9ZZd/tAh6H/LWQdODA4pGo9XBqzjjZ8
	5GGliJZC9j6SBWa8FnKhSyUHw7AQsao=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 266236A8A7;
	Tue,  2 Jun 2026 22:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780440103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4sAf9CWdWRBvdOC/VGUxmfAjIcDMPecq5z6keRuBsA=;
	b=kkmq6f9ix4swGXyI4aIvlOQLaRMo0MKVHP3WZluLcWY353S0mj+eBxx2i2GLMdV+G2nwUp
	DWhx+D/Vb5I46792pYDwOAqnjBt2cwOwdzUEhtD4QENdlGwfkfHMCpR0lnDXia84H/lgFG
	t9VDMQqZX3R5apQ5/iHUPKzmN7eLI90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780440103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4sAf9CWdWRBvdOC/VGUxmfAjIcDMPecq5z6keRuBsA=;
	b=e8gJMoYOEr/U8OOqmLZ51N4lmMQG8SgKb1tCa5m4kViL8ToOpbb/JNnx+hBTISHjRkglpe
	0Pivw3kxEVYE6kBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780440103; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4sAf9CWdWRBvdOC/VGUxmfAjIcDMPecq5z6keRuBsA=;
	b=kkmq6f9ix4swGXyI4aIvlOQLaRMo0MKVHP3WZluLcWY353S0mj+eBxx2i2GLMdV+G2nwUp
	DWhx+D/Vb5I46792pYDwOAqnjBt2cwOwdzUEhtD4QENdlGwfkfHMCpR0lnDXia84H/lgFG
	t9VDMQqZX3R5apQ5/iHUPKzmN7eLI90=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780440103;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z4sAf9CWdWRBvdOC/VGUxmfAjIcDMPecq5z6keRuBsA=;
	b=e8gJMoYOEr/U8OOqmLZ51N4lmMQG8SgKb1tCa5m4kViL8ToOpbb/JNnx+hBTISHjRkglpe
	0Pivw3kxEVYE6kBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D8A4C779A7;
	Tue,  2 Jun 2026 22:41:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pw7/MCVcH2o1QwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 02 Jun 2026 22:41:41 +0000
Date: Tue, 2 Jun 2026 23:41:40 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <ah9Yle5pd6mD9Ugr@pedro-suse.lan>
References: <ahv16ogY8Zx3Rtox@pedro-suse.lan>
 <20260602211242.13870-1-safinaskar@gmail.com>
 <ah9LaPQayJ6tBE53@pedro-suse.lan>
 <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A585820003
X-Stat-Signature: rij8x716jbyc89jfmx7mqsxfpsmya9h1
X-HE-Tag: 1780440104-253671
X-HE-Meta: U2FsdGVkX1+GC3bo0qX+KJnp85fu3jKs0ohO9n7doye4YwS3ww9Ep+HgUjqsIdqWWASZyXiiwDblf/rwJX341joGDkk0IuZwgMfMRG1UK7TXC6diD38POh1/dwNMUKF1DIhpGKNZn+KX8S24sW9QYnGOT5ltZmExy8L/+H8MS/TtNnbrWhrQ7DQZ6/hs+wPxgC4wcPpwRfOAExdMqgyezRK6Bl9KcidfxHLRFOXbw4POTrlSiLtWFJrYP0n2X1YXR5bwDSNEWvBD9tP8KsHfUAPkXrvjt6LqfEYQu/9erDs46OKb1RbEFHEhzTB9sP08gKb+R27BQturBy8Fx+dhkpWxRRiVFZiwPKJ3J+FR+f1OqEe/gnK6AvygsL2eMkqyP9ADYd71k1IGiHeK9fVjYCOaqGb6whDy6m03a5Ix3PSm5U7HJiSFuR9J3OVjO8fFyXXewOZHvknVyXmVJ/fYS7X71YiFWNLhH/XpIrVIvBBKU7h4ROTE0CxozsaNUiGN/LlZjazPDZFmkEUxjyXwZF3iUGDyXJfDcnqJ8Mgj9brAc19gV2Ee2W76JUvDDxlBZ6z142xO2W+Qa+U9irO86AhwogLg5RYVDUyoFZoyNL/Wdb5FXqYRHoh0FSsaucuewK+PCxpXVomHBet5VErfXpwsW+SCaCi9WPjxO9qiifjEuh83/knpYlAe/xuX4WKX46t2sSdoP70w7Y9kJ99v5gG7a8XjbvDU3OhtilX2JdG7B/kZjVjf/wVAoPUiQt8ZBt/e1NntbRCX+EdZfpm8ZdIN9WcvlKIJUIOMPZYWJG0rjTz7ACUn1XSGqT5KwClk4I4lw8o06sCv2wfoAe5I3Lwbah1Nu1jwVvnue06CktfockpTHkREyOjTLZm+wKvHiz8gJqYfysQ7SLfss2hUygBZ3OET3fE9qorNMFUlFsl31dOgZR0zfmujJhKkalKLgEgUDIaMMzjCHO1dPAt
 /pyymIZQ
 82vdpjJe5fkKVwLWN6pseqp+isBrDI/MgAvaDEtwg0ww2M/FOdxRPcSqqlU2mCMlfcujz71W2d6weY7gGa/IGsc4F+fXyBQYCgmsTcCFOJ6RFzBjdBsekjeMGBdcEzfEXHlVEng8E6stNvIQqBbUDyEXjkddCfBreF3nU4wRR2sMtkvmEAHAys+d561IDBiwjZmnTPOujt+EbT8X3NUnXpjW8CAFOz0G4jA81OnDaQwY/1EzqVGJG408lppvf33fGMJlHZ2jSJ6woWs0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 03:06:07PM -0700, Linus Torvalds wrote:
> On Tue, 2 Jun 2026 at 14:37, Pedro Falcato <pfalcato@suse.de> wrote:
> >
> > Well, that's most definitely part of my patch. Also, you cannot outright
> > remove splice() functionality
> 
> That isn't what Askar's patch ever did.
> 
> You apparently didn't even read it.
 
Well, I was replying to Askar's new idea to remove pagecache-to-pipe splice,
which is what he suggested. And directly intersects with my sysctl-to-disable-splice
patch.

> Honestly, I think you are the one out of line here.
> 
> Askar did something I suggested years ago, and didn't remove any functionality.
> 
> It just changes vmsplice to be a copying model (one of the directions
> already was). It doesn't change regular splice at all.
> 
> And yes, it has the potential to be a visible behavior difference - if
> some insane user uses vmsplice and then modifies the buffer
> *afterwards*, then that would be semantically different between a
> zero-copy and a normal copy.
> 
> But that would be insane behavior, and was never really reliable
> anyway even with zero-copy (ie subsequent writes to user space buffers
> would potentially do COW breaking based purely on timing and memory
> pressure etc, so anybody who relied on it being visible wasn't goign
> to get it realiably anyway)
> 
> Perhaps more importantly, it has the potential to change performance -
> zero-copy *can* be a performance win, although typically it really
> doesn't tend to be (looking up the page mapping is often slower than
> copying).
> 
> I would expect it to be very clear in trivial benchmarks that aren't
> actually real loads. And probably not visible anywhere else.

Yes, vmsplice() sucks, and we know it. Hopefully no one else will see the
difference. I don't think we can say the same for splice(), though.

> Trying to make it look like Askar is the problem is only making you look worse.

To be clear, I don't think Askar is the (or a) problem. I'm glad he's
contributing, and getting rid of bad kernel interfaces is always nice. I was
just a little frustrated with a parallel splice-related-unscrew patch.

(Askar, if I was too hostile, I do sincerely apologize.)

-- 
Pedro

