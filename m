Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 249C4606D803
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 11:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OIIJR9F3;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=OIIJR9F3
Received: by kanga.kvack.org (Postfix)
	id 4DAF66B05BF; Thu,  5 Nov 2026 06:12:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B0FC6B05C0; Thu,  5 Nov 2026 06:12:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7116B05C1; Thu,  5 Nov 2026 06:12:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 172F46B05BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 06:12:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EC2AC073D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:57 +0000 (UTC)
X-FDA: 85400803194.23.F69BA60
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06F50C0009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:12:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OIIJR9F3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OIIJR9F3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793877175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHY6y+s2RrJzwaejYRMjR8b7lUTPpigmvDA0dU0XxKE=;
	b=f10iH/sOKPZ9Wm+wG7XmyTu30WZN7ITfpVGI/rSWYLuL07QEiD2tIQCPyl36et1uN7x5zN
	fQTbNO839CcfVpWr53lawMByWdNrbtUYlaA/5aprL5tkznw2G/0GrtgOssgdayhptp4tUQ
	oGMWUCUO/+PyVYNEFH818WbIRl660Z0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OIIJR9F3;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PFN6w7Uo;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OIIJR9F3;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of tiwai@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=tiwai@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793877175;
	b=u+RMV+cohHPpFbzbpSwCbGAAlyVJbQpilWTDtkiRnGA6/agMKNu3xWAFBdOLtCYgwn1eFS
	uzCvcvlXB291IXa2mhb2udYRzqy2jydiQRkZKMOkvFLSQ7DuVcJRFlMIFY32wd417yFyxK
	79OxupzwSYVRKukxQqRkTSlHNS7SfDw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B0DFF21FC5;
	Thu,  5 Nov 2026 11:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793877173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHY6y+s2RrJzwaejYRMjR8b7lUTPpigmvDA0dU0XxKE=;
	b=PFN6w7UogynvDg6wXP5wRfpBkFaml+uFR7+DGPlk44D7H+/LQa+SoO2XJcQjvnSWrZwu11
	0Hu0xVZ/0wl3P3VSS2M4p6oN+AHfLIdMpImDTZLXRA49JKD79Q7UQ54TherVqbDKGvid1C
	dm4w3eHvJSCns3Mg7kqvbfylEJcImJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793877173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHY6y+s2RrJzwaejYRMjR8b7lUTPpigmvDA0dU0XxKE=;
	b=OIIJR9F30Nqs/C66tmGPlHwJsAZoznWM2UgcVCWZi+3xk/7RQOJOBCyTUNyGtkbOhEzr9X
	eWIQGVIGQKlqH2DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793877173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHY6y+s2RrJzwaejYRMjR8b7lUTPpigmvDA0dU0XxKE=;
	b=PFN6w7UogynvDg6wXP5wRfpBkFaml+uFR7+DGPlk44D7H+/LQa+SoO2XJcQjvnSWrZwu11
	0Hu0xVZ/0wl3P3VSS2M4p6oN+AHfLIdMpImDTZLXRA49JKD79Q7UQ54TherVqbDKGvid1C
	dm4w3eHvJSCns3Mg7kqvbfylEJcImJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793877173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZHY6y+s2RrJzwaejYRMjR8b7lUTPpigmvDA0dU0XxKE=;
	b=OIIJR9F30Nqs/C66tmGPlHwJsAZoznWM2UgcVCWZi+3xk/7RQOJOBCyTUNyGtkbOhEzr9X
	eWIQGVIGQKlqH2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E9F83134F4;
	Thu,  5 Nov 2026 11:12:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sAV+L7Rk7GrQVwAAD6G6ig
	(envelope-from <tiwai@suse.de>); Thu, 05 Nov 2026 11:12:52 +0000
Date: Thu, 05 Nov 2026 12:12:52 +0100
Message-ID: <87ld77sf9n.wl-tiwai@suse.de>
From: Takashi Iwai <tiwai@suse.de>
To: Christian Brauner <brauner@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	ntfs3@lists.linux.dev,
	linux-sound@vger.kernel.org,
	linux-mm@kvack.org,
	Chuck Lever <chuck.lever@oracle.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH RFC 0/7] proc: move procfs to what kernfs does
In-Reply-To: <20261105-erbrechen-unecht-bauformen-0794d3cfb679@brauner>
References: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
	<464ef986eab97abf226791c7e19ad111.josef@toxicpanda.com>
	<20261105-erbrechen-unecht-bauformen-0794d3cfb679@brauner>
User-Agent: Wanderlust/2.15.9 (Almost Unreal) Emacs/30.2 Mule/6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0 (generated by SEMI-EPG 1.14.7 - "Harue")
Content-Type: text/plain; charset=US-ASCII
X-Spam-Score: -12.30
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06F50C0009
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: ygmp3scycdjsy6hqoajohay98yzbby35
X-HE-Tag: 1793877174-468049
X-HE-Meta: U2FsdGVkX1+6V/B7W0KQ7Y6u/pxjNcdVLQ0qNV910o57jyJ6tNbMvCFicYxmeugejU8K14hvS7xpyuprLrH97cRH8lwyo1krU3FehPLFNgux0WAY5EV7/kgIS0GFFGtT+mrSB0RH2bsWe3GhcuTTNXfXe21Q2NPm3t6qnAWlSZyCGcULclojVaMsQRKh5PVS6FEA0lGDM3/5JJNThhzRpuLL6kpLqv6ehGjyjzGLs7D0qLzpJ+fYGZS2+prV7dGf2Km9ZAlTRfMdrxaHcJ6mJXjfik2ulBCaLM0bfnPRcUmPFVNNWeYdxJYT2cVs1IIAAk89ZZ9+Fd/QxkmGwaiTnS8e8KV+OlCMFeWYU7RXlkFFDkfkgWQ0bD6vm16k0c06CLMc/ZbtnfjblPHUqsUjyRGxN9TQr18SHr55OTCeWjB1jJjje+/g8V9F0ytSsIGkQDe/uHCdAALJJAblEu27kAFeFIZb+2r9bgphK6XMeXQFJsZqfcJVdxqwnMrDAJRajwmSUc2JWBmiGS49lnGp/uOa7xrvfE+r7PIp8DkcVeGhiZ3ga7jYMcH2TG6D1I5gzC6VAaFEpoKbil56CEIWrl4wfs8EXZTfqMNH9X33ea5GXT5Z+IVWgY16yp3vzyVLLoXR1E4SovH65KRKFy4s79xyAuxYEVCgFx0eMmuwJQD+w7zwnRaX9vqlutTc1zUyM1zaMIA4mfglICYqUix58Unz7+eGmJzAk6ak3w1Mq60SfX/vHHgu98cfQ8MQ7qSDTu8djXgWC92stIVcwa3EstIbKZ0DiGNfofakdfAVAkjmOHFSlOTYYcvxZ4aTsu2rY/ecC8UiEAdyuCKRfX9GG+mq5S37FgJjT7zGZFaLuicVWHeXuCHNWIdURnyHsN12kdIKzGyUuJzPpjM+9WYm/dF03797UWmgWEkXNKRE9wcOVDOWp0DY/7v+0berDhTZOsCoT33t+HxiSN7uF5E
 ArEbwbCU
 RygNh0xCWENAxjLWdpRlIJ7jgszlndenPt6MA1QJvcK23M4n1NcMMshRNlc1HXoM9InxxZmW0mUdIRfY7l8MsGt6yg1js11oUsegb++np1A85ubCmtHcj6IvFrr/EAhcr2y6L2eetqoorO6RUzfRq1yeUPB1Ltxlsy7HyWFsBWuACTgLgOmlT+VzVvCLQiRAyfWKd336u5wmz2EgrphX+tAZDVVeTKmfv9NqA4f1UdV01oBjJ07sH+6Lo0/d2yWfJYVWOeEeNNJv/HQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 05 Nov 2026 11:28:56 +0100,
Christian Brauner wrote:
> 
> On Wed, 04 Nov 2026 22:23:51 +0000, Josef Bacik wrote:
> > - snd_info_text_entry_write() allocates the larger buffer and frees the
> >   old one without copying what's in it, so a text entry written in
> >   pieces loses the start once it crosses a page.  It's been like that
> >   since ffb73b08e794.
> 
> Yay, more bugfixes... You share the blame for more mail traffic now.

Indeed it's a real bug (regression by the commit).  Also your fixes
for old issues should be taken sooner.  Would it make sense to pick up
those for 7.4-rc, then rebase your rest series for 7.5?


thanks,

Takashi

