Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBE2CD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E3F96B008C; Tue,  2 Jun 2026 23:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794FF6B0092; Tue,  2 Jun 2026 23:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683776B0095; Tue,  2 Jun 2026 23:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 522AD6B008C
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:51:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AB11FC0B51
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:51:20 +0000 (UTC)
X-FDA: 84837226320.02.7070A72
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72CC0140003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:51:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=uPgiIE2A;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.43 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780458678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
	b=XL2r3arPmycJKC6F7Krf2+4cQw20B4F89ZUyiNYoGzPonLgKsL/8BldJh9iHyHqfHG5Xwa
	VyisOMd5qozJRGCfScXvNmdU086fAIYh2+7Iv9q4KxH2b0A3F4qhbYRPiiXWbc7i5kk7Si
	Q+ZNOPAbolhqLlRGqUbvQ/uMd4Lmb/Q=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=uPgiIE2A;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf26.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.43 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	dmarc=none
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780458678;
	b=gEIK9bypGxNEFs5SRaoxyRjj5G64T0wyHAdGb4420V1F5FGsUBaJSF9vhjXz/Ts9n6pmN0
	q28Xw55a3GuzSO6pvB5OprOP/6crk39PeR70KyJBBEwa+R89H8k6+cPjmleeg9Pp82828O
	fwxtIN6so6WJLFlFZpnQlwTrzwOSZHI=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aa5e9a64b4so4377087e87.3
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:51:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780458677; cv=none;
        d=google.com; s=arc-20240605;
        b=kI1z9FYw0l/TQirEYSj0LoDn24VOTR9bLw8pMralQsVISs5jJvcqCIUcrJz9k5EnIY
         hlVgDTo9LhW1rjYvRNOfYbKWw6opwpo+57YjlNWBp1nt0vBV/cG27ayQAUVTvllspZcn
         +w3DUKV/c6Zo/gP8wFIiC6r4Ge0PcQ8+Khd3z8ZCkzvy8d7KybbVu9u10rOteIzDHCen
         3LV4Qryh1beWtkiH53kSRN89T2jVE94kMUt+tJ5BSCA3gci7QM92zonf17tRmGSqKv9T
         ZNtbl8dY0jaekYF3PPY3PXgOSxLJOaP/Sd7tKGUScaQLLzUyyfCwz6J69t4+V5Ad+kEb
         GmAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        fh=JxHJ78iJpjlATbEuByPWrBRMjmnx43J7FgzMUPmz/H8=;
        b=HM2p951A+KT0MC5TvULSA/MJXr4w/XOCTxfK0Ze+LQp1/OkEB4gAI5H5cOLCoeAqHB
         Q3dKOAme+AMOxHABPLETWfDvOmlhLJ0YDZkH5zu0wnJHNvIwFpzAP/bjr37Hi8fxJgaA
         OP9L2sTDutTnnNfvz8RPDBgwo7nCtkgmqSh8XIeOHVtgo1yEIvcROxV+7eeOcIw0rGXa
         7FvTqPn9/b0hmJHmh+q6yRqqBSY69/Nz8KXvdJyzyeVgysJZ9JEEhzR9r3PBnIdywj95
         LwUlkX1eAq0rUgXHbqiJyjWUWYSninqz/gq8UQicfv8XwnNSJOe4q2I8dhAI+leHeE+6
         HQ+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780458677; x=1781063477; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        b=uPgiIE2AcBLtV3FiOs2Lkjg5+Vm+6zMEOySNKCTW0Q8yWMGZT9O/1qTA5WMENuP/K/
         pxs7MHm684JZrNyEgn7p0A9wgg/wm0UukLXAHaOeiEjQXP232gnbeCHaRp/unrzspiOo
         JUSlYCpsi9vBrOm5yH0ssm5UVBt8HIvd/1Twpc7SmSOuBWMa7NVMvztW6vKWYw/LFRpp
         a4TcKpr33So9FHFuX/WDvikKs09vwhl+WxpHwZTF8pw87iib1y51Jc82UXa3HKqtFXc2
         12P4Cv34MvUIwKGpII+1B+JXFUu4efyFp+8Iw29dzLnfII4S8+44RfjfZhksnSbjru91
         SRjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780458677; x=1781063477;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLctvnpeHHKwaBCwCGUFctRGdwexf3XsJleZhrQYpkE=;
        b=WJzsc39xZFQXLfMoqxRNtoJvCdLQpi+pvNMeUBSxRL4fZB9V4WO1dOSMRxcMWksZz2
         8XZU8gCKkW3z5e+5kJvsvT4DdpXSaYLjKkW0WtVIMecnvulBifwOVAYCCK3seBa4LAdR
         2gA0rGjY5Sahb6tV2UAbIKaZZk6mDgZAN8eujgoV3RNAks92SiYqnImDDU5Y7MnAWs0a
         K31aBvqqllYG2VH58zeolM6jlrdpFPJcgTzY1Cww4RxeMWzaTj/Y5e0oy5wQPsudLlU7
         Sje8axIZZ00FLP474kMqIQ2ZOOZemrGCD4LMnQzqwOewUsZ/OqjfokgCTei4uJ76rHZz
         pqiw==
X-Forwarded-Encrypted: i=1; AFNElJ9pfmJ+N+PPrPQXrFNKFbLUM0NKlNqLDwXX1fkZdgZ4XiwYNC+L7np5VCu/TT6nVVFXziXyudPVHw==@kvack.org
X-Gm-Message-State: AOJu0YyoAr0yPTjV6algWFbm0phrRN3VEBNb+hZTeGX0SyucW4D3+fFo
	gjYqVf/3ZesNIMDW5kXsnTSwjEVZYLWaNA9cElXBV5NlaQqxeazXx8LC9eJU1AGEsYCUo6w8BNi
	KgdUaV+X9wneLzAM4iDqkoth4iPOelvSnGmI24i76
X-Gm-Gg: Acq92OFZJYKU0g1mYW0m+2tpuneLs2GVKJbPdwhfWlkbW7w2CMuTzmVFRRj9WX7HsOo
	9svONve5YbhG4hH+lx/XwPrRts4Oj077wzpiLBW9/GsMVBaviAZ61rNbgs3exh1t3cHPYcjQtMP
	wUkw8jdt2l74agPPYrXM53qfnAJTRUsXmIFwZNym+JjYz0rQGId3RpeeXfQIyhNeAeAy3IU1ayi
	2nzTwlIatfIQcbca06h1JQQvW6bwsYBOJFpt210yVZgyx7WSI2BAVKaMup+UmI60akRocLjiDGk
	Mv3dRufg6pJTCKc=
X-Received: by 2002:a05:6512:1587:b0:5aa:6d0f:1dc7 with SMTP id
 2adb3069b0e04-5aa7c0bf470mr459675e87.19.1780458676548; Tue, 02 Jun 2026
 20:51:16 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
 <20260602225426.122258-1-safinaskar@gmail.com> <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
In-Reply-To: <CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 2 Jun 2026 20:51:03 -0700
X-Gm-Features: AVHnY4I4B2wg7ilf1zQmemgKARTlVUvTJ9JxDnVBlHgiDg-UsafiWLR7jiVDKio
Message-ID: <CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk, 
	brauner@kernel.org, david@kernel.org, dhowells@redhat.com, hch@infradead.org, 
	jack@suse.cz, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 72CC0140003
X-Stat-Signature: uanakd1shr7ai4t9jyozdkwftej79ocq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780458678-458040
X-HE-Meta: U2FsdGVkX18e/dVyYC16HVXWx4X/O9CXosmrBIserOHdDZQn4iTLlLa4GCKja6d499fi2s5wtpJu/dtTmE3X2Y8E2BmuNOd1/eftFwdc8rRP4DbbXTbBZroa7rv9fmB3cdjQ7/FckrI5NyTpSTl7HDz1qqNZu8QH5Jq5o1FnzX9rXPJNPoG1c12HpvHUyoukOSaLNG23s98ezMIpTJtcPNv1P1opDxm8vXyXrK9/cY+0Uf3ZkDK+UtQFZ+MtNRlHQTEQv1Cp0pTlnJgWuatvniH2tMQUCtKn+VwUyj58PSmJkfIyePfummn4eROuNzwil/eYTqM+g2AxbdgdOD5cbV3H0Yv2vk+O4QXQ2+47iVasTG4RomMK5NyHglliVOCZlWKY2XhRr3f4bVvZlJSBcdqkPbMV6m1q+m6Ex8thubiXydHTB8jsIot60mabyVLO34CGU1lUxPysClsu4HEuc2eXJ9+HfiZE3HAhmbYF7/ujLeh5FudBAg9KMlKqPMeOTy8v7h3yE5CoLsA2J6QBzoT/3gdbHaENieZAw2lofJId6H8NXRb6ITbZ1MUK2FzsjyQY1Ko0Ki0VbPJ7H5WwBeLv2hj1sHuKyhWb4qlttU3UxF89n9ista5uVJMbDhPtFHr1fOuD5xZvO1T7YIBDbkHn9tgOhrlnZzU7BuLMj5Wg0ihT/6m4J219F+J+gBkNsOJqHKq3/OkpnXrw4BLMn9xDgZB0/Nk1816I8HdBGjFyHuimB3K5HIqKOfucOPaG0pgkNY/FKTMZ+8VbMVapaoY7O032883dLL+gh2NbiTuCljiA2E7NqoBr6wHdTFXYtnhvpaq5PNzMfSiavUkqNTeMoedyLNEFMtX6JLzcCEuwZ1qmVSH9hV1mfU0IlcXqn3XG0UuFb++zkwWkUMuK3tptM61cvbfeaLBAtX8rMO4gBmsDvgYQ4slfEo1Z3Fx1/XRmsmlFYUV3bQEJMyJ
 VtQVNfCv
 93+fjHbvA2BeCZ3An4GdIj+5tXerXBKFICsYat+vQsduTAvWtsQcggf/lkLQwyX9yKfP174gJCgFAFMiR1Xws8IRJCZjPTksfAWoM6jn5Xij5OF2VVtWQmqxAJjGDdFzOx8OQEOlWSYwyHp5sp31Bn2hwR6FHBfo+oTkiy0uTjIgC3VnDFFHsNp6YyM5fQzxZSAlQ8LrjE+iJwKHNCH10059FuWxYsIqMtWgXm0oRfrEE2ybsEwEBkTnIV8SbjPb895Ar8IHxjfWE3E/TJM4Cp92WXA3mDUAtn6pJ1ZgbFN4dGBddBkd3cESBB0miqxNGpfv6rWBuHef7pjSMmxIRqUe7A3vpNOUu/XSY43PzvaZ7JfecvTMpYIkuLll4u2Yrpcfo2Qhyma5nmnogikVXQXKA5HJy4BxIb+0F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 2, 2026 at 5:12=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, 2 Jun 2026 at 15:54, Askar Safin <safinaskar@gmail.com> wrote:
> >
> > Pedro is talking here not about this vmsplice patch, but about
> > my future hypothetical patch, which will remove splice-pagecache-to-pip=
e.
>
> That absolutely would be my suggested next step.
>
> Something like the attached - get rid of filemap_splice_read()
> entirely, and just replace it with copy_splice_read().

Am I understanding correctly that this will completely break zerocopy
sendfile?  sendfile is, internally, splice-to-a-secret-per-task-pipe
and then splice to the socket.  How much to people care?  These days,
a lot of high-bandwidth network senders are sending encrypted data,
which is not zerocopy frompagecache.  But there are surely some users
that care, for example the person who went to the effort to implement
IORING_OP_SPLICE:

commit 7d67af2c013402537385dae343a2d0f6a4cb3bfd
Author: Pavel Begunkov <asml.silence@gmail.com>
Date:   Mon Feb 24 11:32:45 2020 +0300

    io_uring: add splice(2) support

Now maybe someone cares about a different path?  Splice from socket to
pipe to file?  Splice from socket to pipe to other socket?  Does
anyone do any of this?  One can, of course, recv() directly to an
mmapped file, but then you pay for page faults, so that probably a bad
idea in most cases.  At least all of these cases don't have spliced
buffers that refer to a potentially read-only file.


But I'm a little concerned that zerocopy sends from files to network
are actually important.

--Andy

