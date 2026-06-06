Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62ADFCD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 09:16:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F6386B0005; Sat,  6 Jun 2026 05:16:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A7576B008A; Sat,  6 Jun 2026 05:16:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED81D6B008C; Sat,  6 Jun 2026 05:16:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7ECF6B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 05:16:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 096BFC1ADD
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 09:16:27 +0000 (UTC)
X-FDA: 84848932014.01.55295F5
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf09.hostedemail.com (Postfix) with ESMTP id 16FE1140017
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 09:16:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qwJkU1Xz;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780737385;
	b=rAXDJpIsIR2TYCW9u96MoMAopxoZg5BuwXl0qHHQaIPVYQVOAz8NwDTk3SSEdCH3K7HX12
	/lrNqTdDwcUlNoVJU0eCbmv/2IC8TeolJxbtK8wlCeJCmp6/GAYhnTnEss8WRoN+xk8BqJ
	CPxERoGfiJQ8mmh+9VeGm3PJSAvn2wU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qwJkU1Xz;
	spf=pass (imf09.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780737385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SxOH3sBqh56WyqC7iKaRtAkj2hv0SNo09/WoL7JuhE=;
	b=A31U34Id2BoSfvjCHnhH92sQJACgl6KuMnPH3ej0579v4tPCy4UNuPGW6NMHbOeN8f/kNc
	yK+599CFTFmWoCWM8j0+BKIMUa26NZKWwnQX1nk+ROs0T2zopQLDk1zAz7kxX5cf+8yZPd
	qEIVrL/f5NErSc+IDc+Ox8jTK5ihiio=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490b64c8311so30649515e9.3
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 02:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780737383; x=1781342183; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/SxOH3sBqh56WyqC7iKaRtAkj2hv0SNo09/WoL7JuhE=;
        b=qwJkU1XzFYYNg0tT/7shcIW4AGUhqtSwj2incrF4+svjFMfx4aMsQU2mb+t3aymW7W
         6ZLKFRrgOiZvO3jkX0J1nvEnD3EXYRm/bf9PVeCFVdiCfceVc3/OPaEF9wiVWu8XLNn1
         AfDChdVv2DWnYOLH1/8Qd4i7vMxkZcdGOxgJR+vZutSCxYAnKqyXaj2UNmpt/85YUJEo
         VVO9U4QJcWFlzIZ0e0c6dDyWaf/O4d9N6s8SJAMZSYhnYPCgsVJaSqSAkmBP3+4gm791
         4dP8cmG4Vrh5rJHd7GLWMSuVcj7j8SLwWrPAfNy5YrVrg8WiHTA4KBvPgHMhcPx+zYVE
         /kng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780737383; x=1781342183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/SxOH3sBqh56WyqC7iKaRtAkj2hv0SNo09/WoL7JuhE=;
        b=Ctu0QmKx6s4tRFLcTqCtw6zVZnHTTtqB6VxatJcwHUXeH7aAKr0bfkUaFil4WBSp9+
         itMLSIOUuic4NC85PMPs1wCD8FPaUAA7EpMOHhwbEC1F2FGCOEK7vNS89FBpYlIa9/Ug
         y8I5LXcohY1957OyLgT1lugN9SSuIMhzixb7SqFKwPhvo0OUwP85NQuMB+F02d1ylZSP
         ylFgXQjymbKXKs5+Yh/6PIks0bi+v6wNERoMKfGRLT3boVPbhjMsCwUI4KOjppjGgA5b
         +Ego00dBGMzVjQbL9fTsh0elDhwjDjduKDAgxG6/7pp/crCiwP3xwZcQAy8FISKs+Jml
         g6Mw==
X-Forwarded-Encrypted: i=1; AFNElJ8FKKYutw4iNlD35LhlsJSWQIJ/ETM+MHrx19tI7rZ1ehSYf7Z+FfKW3UQY5vfH9jq7iJFrn80U/w==@kvack.org
X-Gm-Message-State: AOJu0YyOWNow2b16NzTCYGpecxMKMtxYJbNmPKzY5RTk/ecWfHjkPZ+5
	uzoU7Kt9Bj5WPMT6h3SNuxkF28v0Bwjua30DGMPvmr7HSh55SDNypx+9
X-Gm-Gg: Acq92OH5toDi7TMaPyhqj2omtoJunGJmfLrzBCMTWFKuoANJGkju301DOJhrsj95T5h
	XCj5Yb9K2+IIGhjxmoJU9mcWYiksUnHyel3Xzlw3K22HaAtZjYk4N/zp7MF5wIEmJ39ibhxEU6f
	95M/Q1xBC7i+wW7zhjhfSTJPu5HeE25OEI26PcqqMy8Bt+7emFgEFPm488bv9M726sbokCvqGtK
	xd7Q/t6/gpvc1+oG7xYFQNwrxQc0VY/oRJxcVBoa0Wzh/5b4i+FX7+W4YuD2GxYY1zzHBrvHoZ1
	63Xh7CLAewSwGiYu6F7lgP9eXDAfWb96ItUNlPefXADXggZXEHemvZezVhwONfrgGfwaGJJHGN7
	TsLiwa+ZDnTB9gz50VxfH4QvgTPPyDdcwrA8tzbq/nDDS2PDNWPoYbA41AEXd+RwojarX9+HC3e
	Kc7sVdDJgjlAGU9mSbk5xSPhiDuyoVG13TjdknzAieIC0szx/AUsiTUloHx3sUVBeFP+YUCJg=
X-Received: by 2002:a05:600c:83c3:b0:48f:d612:3c59 with SMTP id 5b1f17b1804b1-490c25a21a9mr135656445e9.9.1780737383320;
        Sat, 06 Jun 2026 02:16:23 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3fd663sm247272215e9.10.2026.06.06.02.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 02:16:23 -0700 (PDT)
Date: Sat, 6 Jun 2026 10:16:20 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Florian Weimer <fweimer@redhat.com>, Askar Safin <safinaskar@gmail.com>,
 metze@samba.org, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260606101620.602ed92d@pumpkin>
In-Reply-To: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
	<20260604223216.73468830@pumpkin>
	<CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
	<87se71jps4.fsf@oldenburg.str.redhat.com>
	<CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
	<87wlwdhrvr.fsf@oldenburg.str.redhat.com>
	<CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 16FE1140017
X-Rspam-User: 
X-Stat-Signature: dogqqdzwjbjxhah65bmq5e3u31q1brj5
X-HE-Tag: 1780737384-899098
X-HE-Meta: U2FsdGVkX1/D1ZQlmIOknryjC/tgo8wMCpVLLJ7jCFAKX2YqF4fpNmbck7NEzIcp8s8gouIyOmU5OhZK/yCemd3UwJe0w3ruuPR9fElcOkM3Tu3B082c5A3a09NYo1H8Nk4kgJ0MAOI5/LzbJg4q+OoQtXA8fmX9Kj7O0F54eVoM0Raed4bxed/02nnEqE4un8ZxbafzVD8QNJpRbEDAgrK94Ql0cxHPBxYgKcdXg6hiYyjus6s2q8ihltzNzQ5MFRX/4tS/xPNbebX+GheptR+r+A7lluXH2wDhvZs0rlZ69EvaIVrHQB0rOVjRzDvp4pWdP838MUh8wZ8ef1acyPBbg7zCxcdSRJQmEAAyt5bOxd0mftJgplyrk9XL3OV+ko8LmU4j+jNglMASAshIv0qmQGHk/ffxqmMoPYuI5/GTH2fuoPUszm/AUFvGD/rJJrovitvKYFa49/zu6FK6p6f9oeGrzae1aQh1ycvmZtB+zNqRo0U+Pr473++zNNTjKzVU92nhWHokY/pXOYepHqLmxDoUFLab0FjHmn++i8ROsoIry8Fx3q8lV6e4MoFJJyoqtgY0DxqGaGRIVu+MwMFKFvPY3MN0bMbG8USwG7WOHl/BXgwKTjpVHe68AGqoUMzhbA0Tqf3EtzBTwea8gjdt2qZAVqhv27FrPPU4OhdHj+6gUh7G/cBz+UaV0piK9yHAyCvrVxn6aOkPweAIgJl/vdvjIqCcqFZVeju9VaceSWtZOXyfSqlWl/unNSpx1Yj+y9huAvxv14GE3u/R6/1/N1GbmeFAbdd1mf9vKjO/PiULxRVjLDgNX978iAM3YImDovizxvsc/8mn4KAl8y4tz7H2KoACptJeVlqcQfQGIVu++KSpQJ+DXqDqMnrwiZHwJRLMraViJcwZSclB7IR7w2Ig+encykwceEvBZgdwhaUQYqCDmAt1VfEdlzz8Om1ZQLwtZVfpjqToSyo
 odeKFwOQ
 qDt6Op+LoB0zDFZc2RPJgnKcW3onXuxZwx/3ItdzM2Yz31pH0bmJke1OF8TDUZAnqaYf+obE3f3FqFeM3G0UF4RKcuS/6j0IxZbtduzEs+S5XlGeTyyPRP/P5b6Zvc4UPD9kKOCp0m16aJW9OgEOD1fj31xXvmDTmAUnc+u8raQL8L8LzMwS6iZ1l0oU83X+ckMg36dj7cQBvHkuhqn2GDyA+WKWzdEuNy0l56gWUMNjiG15Ohvq/Aha7f62q8hStT6LKtrXH0VnzwOB5bO/h/UWVjymLvucunpq+R6THBqIM9+IunM7vzDdygs9g08VMsJ3YTGjjziglHOLJfqo9op19RIr0gLfmjQNVXlTo2q3QHlQRj3l2AE+tizd1DGpHv8zL3HHabIrH3pZKC4OuQ4B5dFoxTfgurIL8yf6TjTYU9s5OCPyooTHoLAmfMQOXjyXgQfAml07Lgv2KK9+bfllcg1QNJa3Mf8y4UuCxQEkdz8cILxw3dsUOkyOcl6Tu4XFuRWghPkubBzo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 10:12:05 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, 5 Jun 2026 at 09:30, Florian Weimer <fweimer@redhat.com> wrote:
> >  
> > > Uhhuh. But that is only specific to 'bool', right?  
> >
> > Also char and short.  
> 
> That sounds like a complete ABI violation as far as I can tell.
> 
> Scary. Because I would not be surprised if we have code that assumes otherwise.
> 
> Now, the kernel *seldom* uses char/short types, and since compilers
> are typically at least self-consistent in those cases and we don't
> interact directly with untrusted sources.

There are plenty of places where char/short are used for function call
parameters/results (and not for single characters or similar).

I'm sure some people (even some who should really know better) think
the smaller type will save space.

I've always worried about whether the calling or called code is responsible
for ensuring the unused bits are zero (or maybe the sign extension of a
signed value).
Clearly the compiler should obey its own rules - so mostly it is just
extra instruction to do the masking.
But for interactions with asm code, and possibly code that gets mixed
between gcc and clang (maybe for out of tree modules) it does matter.

You also don't really want to be doing maths of char/short (and there
are quite a of of those as well). I think it is only m86 and m68k that
actually have 8/16 bits maths instructions (is s390 old enough?)
everywhere else the compiler has to explicitly mask the high bits.

Maybe it is time to 'nuke' all the 'short' locals/parameters/results
(eg from htons()) as well as all the 'long' for values than aren't
dependant on 32/64 bit builds.

-- David


