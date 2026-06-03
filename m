Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37485CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E446B0092; Wed,  3 Jun 2026 07:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94F4B6B0093; Wed,  3 Jun 2026 07:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83D906B0095; Wed,  3 Jun 2026 07:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72D786B0092
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:44:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 390431A0340
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:44:01 +0000 (UTC)
X-FDA: 84838417482.19.4864818
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AE6A40008
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:43:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e9TruHKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L+5Da9hO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e9TruHKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L+5Da9hO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780487039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W0eCuaAhCxqMdNJLOaVe8WqPBMsrJRRf6/0fkCn++oY=;
	b=RSK7+n2n5Tg2W8YgLctCRswHFZtJJjSlcMpOKf+q7GnAGYb0gmffeRcHhWD2JWAmtGIwYY
	WcjwkDizz2WirmMnY57qax+CclfhwbS3A4Xr5kau8qK6BO2XXHXBgWkgrn0iu6jNfZvPWz
	rTmbFHKo7Hizpw3IbSapN8Q/Dj1W+M0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e9TruHKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L+5Da9hO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=e9TruHKb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=L+5Da9hO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780487039;
	b=w6bvvyd3UpFQaYqL4OEEkZuyJb2YbiWleB/RKk5QWzsbWdbdH7A9IzyAwRbUBsOaMTC5Df
	HNzxogxnx+NKKK56Yxjb6QqgbTXu2ZyIwXAdj1boTLmUJXLLuxZOiXzj2+6sFaGwXyiQwX
	xNsmFhPYWUujt6CgQwtTzGICOgO6Igs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A8A7067559;
	Wed,  3 Jun 2026 11:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780487037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0eCuaAhCxqMdNJLOaVe8WqPBMsrJRRf6/0fkCn++oY=;
	b=e9TruHKba2Aw8j5znNs7wuEBN6ABAIt9lPHHNKWc10ifZhfTD8lU+Amkj6FyF3IwnwqsOn
	ZJSB/bau0jk/KeED2ljIJWWGmrp4+0ZNlP/gz4LWSh0lEAZqj2+Lm+WHhG7wDQUsUCBo76
	tZ2EMza79/ZhFb4kLqIaWpmw8RG6E6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780487037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0eCuaAhCxqMdNJLOaVe8WqPBMsrJRRf6/0fkCn++oY=;
	b=L+5Da9hOM6Rn3I3fgd338xAE9ha2lU5C4Va8OfuLmzgu2gRs0ZCE33NMTcTqxRbWVALAl9
	NTF3zlbpIv+RVfCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780487037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0eCuaAhCxqMdNJLOaVe8WqPBMsrJRRf6/0fkCn++oY=;
	b=e9TruHKba2Aw8j5znNs7wuEBN6ABAIt9lPHHNKWc10ifZhfTD8lU+Amkj6FyF3IwnwqsOn
	ZJSB/bau0jk/KeED2ljIJWWGmrp4+0ZNlP/gz4LWSh0lEAZqj2+Lm+WHhG7wDQUsUCBo76
	tZ2EMza79/ZhFb4kLqIaWpmw8RG6E6c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780487037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W0eCuaAhCxqMdNJLOaVe8WqPBMsrJRRf6/0fkCn++oY=;
	b=L+5Da9hOM6Rn3I3fgd338xAE9ha2lU5C4Va8OfuLmzgu2gRs0ZCE33NMTcTqxRbWVALAl9
	NTF3zlbpIv+RVfCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 84DC4779A7;
	Wed,  3 Jun 2026 11:43:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOpGHXwTIGqNXAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 03 Jun 2026 11:43:56 +0000
Date: Wed, 3 Jun 2026 12:43:54 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org, 
	patches@lists.linux.dev, viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <aiAREqlHK1llOw_y@pedro-suse.lan>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com>
 <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
 <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2AE6A40008
X-Stat-Signature: 1eaund7ehj98gy4a67iajpryx44cc915
X-HE-Tag: 1780487039-237292
X-HE-Meta: U2FsdGVkX19BziMzdgd5ixpArnPaKNP3nVE4JgIwVj4vdv/Hx+rl5sSwm5wWyJnNGWjVv3TwVAxE73b/TAqlPmHg8fLq6BNAh5RXtjlTV5OqN1gwkbBMqWGI/3e2YjPVpY9aZ0wVdCiZwBQJdVNJvxKBghPuv7iGSbRG9JKYyiebSNC8h/hZtxuDzXnoiLYa5lWW7La2m8APuBGLUa0yB8cx0FS5fUpSTz21zxUshWhHKXYJ7HezbsYvwKX0Ppro6i1xGdWxsxEmLgxF5yWrlb0od81tHKjDlpqSes0e9L+MEKqG3cnNXwpEh0iKUDzSQNCKloENOL9NVZZ1hptLVNPJr5ckFZr1kOeg+Adhs1JueLzr17Lzmfa1yZIpC4nll2r5bSSOL+uvqMpEUnwbq0m8BTH6p7HY9/vI/Pben1orjnpVxo1oZ8STLMnlus4OF0ET95051ERW33HMy9M2OuXRubNPs6YfC5nytGsZw4D9Igg++1IPagxaHhkpZubZMA5VLIH4DRjG0p3E6hlcVrNRSThNBJ6j9qleYYEgdXNt2X7K3bjxIg0vteZ6WbCuy7XmUgcyq6s/r9UKgHDIyIAh0wwEinJYrrpisUnHhXUqS7aAaD3nNFJ5vXt98a4rKBIjTeyRhb0dKN4uxQV6/sES3UXQxOCNAJ788NoSB+JjsESuAUn7HXaBHYaEizIQb2kIxmH2vN6t1tXrV3uRh1AjrfFMvJ75ensvs8T0RR97ONNn+jZ1unI7usdwTuL9lBwBrrobBEQmc240vIcBLYY8HavIq3GBQNPdxQIoS6dHyL2MaZb5yGTwxXgw0UaYeCICbqa2cOxUTyO+DpcXrUOIePUd+ZfB7baiBQC5WxkBLMRXcQ5xCrjq5N82GgVZ7rjNzUz/Oi1/xivTnQZJRQWg+NRzQ9mLycFxJQZqVlGZISw2ZY75tDkyqn85cE0++9RrmlXQczpQQlA6rLS
 mtPT+Cvm
 ATBpeKpDxMnx1RE0EMIDbCFkfGI6jIUTI4uYus9+8DZ0yUYqEeOpZx04dEuOkwNG10veykZLJBVZXurQYfD4oHbTQa54uyEw5WNuVk/7XgesghlbS7OWSbq6UDTST0QsVQPI0BgcDaboKenKqMaytgtZoxlJLoxFgKYAHtIaeYdK/2m0G/EBQg/VcLXkkGltduOEZbzp4a3hkXvU3S9afPA/sEGHjHbJfW5Fc+LO2OkR1mViDJJJqozdKQDiUFbMwjuR08EXGOviVt8q6lYWY7vur8EALKOZfBp6rRWuu6/+kmKTb/xXBKkR3klJR60ubcuG4oxkd3h36JA2LXIMkTCFzS/iXI8HmAI7kOnjfCBBtjzt0AVLk58rquIyfy2K9J1yvmkOpFks2Z78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 08:51:03PM -0700, Andy Lutomirski wrote:
> On Tue, Jun 2, 2026 at 5:12 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Tue, 2 Jun 2026 at 15:54, Askar Safin <safinaskar@gmail.com> wrote:
> > >
> > > Pedro is talking here not about this vmsplice patch, but about
> > > my future hypothetical patch, which will remove splice-pagecache-to-pipe.
> >
> > That absolutely would be my suggested next step.
> >
> > Something like the attached - get rid of filemap_splice_read()
> > entirely, and just replace it with copy_splice_read().
> 
> Am I understanding correctly that this will completely break zerocopy
> sendfile?  sendfile is, internally, splice-to-a-secret-per-task-pipe
> and then splice to the socket.  How much to people care?  These days,
> a lot of high-bandwidth network senders are sending encrypted data,
> which is not zerocopy frompagecache.  But there are surely some users

You can do zerocopy from the page cache, even with TLS on top, by having
your (fancy) NIC do TLS offloading for you. See https://people.freebsd.org/~gallatin/talks/euro2019-ktls.pdf.
Linux works similarly. Slide 26 is particularly interesting.
(No KTLS I assume is using simple sendmsg()'s from user memory, SW TLS
and NIC KTLS are both sendfile(), per the slides)

TL;DR I really do think it matters.

> 
> Now maybe someone cares about a different path?  Splice from socket to
> pipe to file?  Splice from socket to pipe to other socket?  Does
> anyone do any of this?  One can, of course, recv() directly to an
> mmapped file, but then you pay for page faults, so that probably a bad
> idea in most cases.  At least all of these cases don't have spliced
> buffers that refer to a potentially read-only file.
> 
> 
> But I'm a little concerned that zerocopy sends from files to network
> are actually important.
> 
> --Andy

-- 
Pedro

