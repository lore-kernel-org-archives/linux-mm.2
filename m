Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C26BCAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 15:51:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425668E0007; Mon,  6 Oct 2025 11:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FD238E0002; Mon,  6 Oct 2025 11:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313528E0007; Mon,  6 Oct 2025 11:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 20BD88E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 11:51:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C753F8624D
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:51:17 +0000 (UTC)
X-FDA: 83968128594.23.82EEB85
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf04.hostedemail.com (Postfix) with ESMTP id 93A8140003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 15:51:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=c+eexEed;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759765875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sMoomnihbSwUNorrh09eu+PuWRV7U6fAeqINMFRwMBE=;
	b=Cv4GlbAZPSpP3D2gIVYJmFTYu7Oy1sVjQdBlXTrmKlXOZhLbnm6AfBJy6ixeZLhu3Fj9Cc
	aRyrAK/B3VgMC7zHG7644dtlCWobNyVw18jL0ZowNynkGCKDAht2AkGGbfRBkxaB+eXj4x
	xVsxzyfJmOnpgnonzK9vBl8jIyDdVXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759765875; a=rsa-sha256;
	cv=none;
	b=fZnQPM6alibgNl8sD0EVqSbeFOQC+JAVii7E8Asqlj5l1rUP82NZamFmU+04crg/7aBVhN
	tl0on7GUOR2+q7PKy+f91/YsDLAhwGK3R9RHmFsQmQbgRDYCJcNbdLnw0V8pJv8dGua5hT
	3mznlX4PzOBo0QIQBcvPBrh+YqYQm+8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=c+eexEed;
	spf=pass (imf04.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b3e44f22f15so754868966b.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 08:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1759765874; x=1760370674; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sMoomnihbSwUNorrh09eu+PuWRV7U6fAeqINMFRwMBE=;
        b=c+eexEedcauZzX5AnHvSLgBqZibjrdq41Gta4tiZnQwQGK1/go7MXmCDwEvsaARfGm
         Ayazt3zD+PDDYzMDpX/f88HMRJEiOLqryg9Sf2S5ENhWooybt5IyL8gv9FNOkQOEhWPJ
         Ze6PaM1JCdieUUnX4B+HdfsKQ7zoxTl9s7S1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759765874; x=1760370674;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sMoomnihbSwUNorrh09eu+PuWRV7U6fAeqINMFRwMBE=;
        b=wBy9vLVKex6QvBHJD1culJ3rqUwuv0wcwS/E0fkShnfa1CcPKsdQjazUlyOxBCejC0
         eKx88yG4mrDEW8ugptHIlwiMlzsVfT/s/8vv5Q/mOMi1syqIyv8AmcwSGzZtKezLKw8v
         nqdO+mPhf2/y2zaktLwvrzWDrN6I4Q7quBpsMk0lkPWqTM50+vGiWIMIrtL2hns+AXIG
         i6km46KaEn+MhMKnz3MX5sbv5kIbVRNoPQ8H2uhlvPX3yivuQ5XaWu+uE9jI9RqPEUtl
         JVZrt9FqDMORi07S9Wj8L8xAlBtOaXIWvWWNeDjuWgvEal3HpBLMWPOcgkd+PxtVdvO9
         2atQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCIv72xOyqYAABGSZn+41h6OJ+AxVbvyfWLO02PlO7QCBxQJm2TP0606uPsPLb4HGH42wJ2tD7dw==@kvack.org
X-Gm-Message-State: AOJu0YyM18dwcaKebGDJuwacnWyRkZCmr4vOzEfsdS1KLCWD/IQQKJb/
	V8YymHgnYQeA41yHwXxBVIHmgy1Jz+by9CfYtPFujwap0d8saUouevMhPgmQL16var4YxLNzBe8
	LSK6/Et8=
X-Gm-Gg: ASbGncvhGw9RlAZt88Rkty/qrIICl5fUUcEP0HeLGBn3V4PbdZWjhlHEG7WP+dKXazQ
	Paft3Ahu/6T1e6W8UVqtSPga/iK09RZDKzFTw75cBjXZDMeSVBGNvJJ7oMegM+iPCS08FH+irj0
	8lsn7Da6ZVax5Nvjsx83OmXHRkJmxhJbohPeNYEArkd6eiFsuOA5i2W6oZsJ9svL1vOggV41HT+
	C1UoWaseN0yvffkcx8pQMRCyjbRpvYI6W3Dkj4Wv6w4m95mb6wzViDyNf05g3aMfSjV3SYXs4Jz
	Fc34C2Y/sVxhJ1eTUFNNTdoXBn4oknF6H29bIiua1DxhEaQetAPp/DyPYPCiEmPEBHGER89knQG
	pEQB68hgHQE1/elWbM6PXK7ToI8Jn6w1kIJ17/HFDgiTa/3Yx2dUwlm1/oR337mvIawXgwV0TKn
	F3PQql238t1+biUc1PlKdH
X-Google-Smtp-Source: AGHT+IEQyJpeax/q5rNVVvubva3c3U+2cLMOO1G4Z2wS8VAW1d4Zc2D90u/Amo+etWX0ht+wo6PmeQ==
X-Received: by 2002:a17:907:3cca:b0:b3d:d6be:4ca5 with SMTP id a640c23a62f3a-b49c146e781mr1461252366b.1.1759765873657;
        Mon, 06 Oct 2025 08:51:13 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b486970b2desm1199145466b.48.2025.10.06.08.51.12
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 08:51:12 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b457d93c155so904051566b.1
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 08:51:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXEZLuAPiDpjmbKH+0iviAQbavwUTCkWlmE+zle6kOtkxNw3mIDlFs6QFxRl7S9twyVg6+xZ25JDQ==@kvack.org
X-Received: by 2002:a17:907:3ea1:b0:b04:563f:e120 with SMTP id
 a640c23a62f3a-b49c3d71bbfmr1705204466b.53.1759765872029; Mon, 06 Oct 2025
 08:51:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com>
 <flg637pjmcnxqpgmsgo5yvikwznak2rl4il2srddcui2564br5@zmpwmxibahw2>
 <CAHk-=wgy=oOSu+A3cMfVhBK66zdFsstDV3cgVO-=RF4cJ2bZ+A@mail.gmail.com>
 <CAHk-=whThZaXqDdum21SEWXjKQXmBcFN8E5zStX8W-EMEhAFdQ@mail.gmail.com>
 <a3nryktlvr6raisphhw56mdkvff6zr5athu2bsyiotrtkjchf3@z6rdwygtybft>
 <CAHk-=wg-eq7s8UMogFCS8OJQt9hwajwKP6kzW88avbx+4JXhcA@mail.gmail.com> <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
In-Reply-To: <4bjh23pk56gtnhutt4i46magq74zx3nlkuo4ym2tkn54rv4gjl@rhxb6t6ncewp>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 Oct 2025 08:50:55 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
X-Gm-Features: AS18NWDwictm2mx4ddQEHSIlRgCT4GuM73mcD9dZ1kxxXns9_MP73AOoOkea4BU
Message-ID: <CAHk-=wi4Cma0HL2DVLWRrvte5NDpcb2A6VZNwUc0riBr2=7TXw@mail.gmail.com>
Subject: Re: Optimizing small reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Matthew Wilcox <willy@infradead.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Stat-Signature: u17cc67kzo41845bm9wcp664yf3kfbe6
X-Rspam-User: 
X-Rspamd-Queue-Id: 93A8140003
X-HE-Tag: 1759765875-544305
X-HE-Meta: U2FsdGVkX19jaETkHSoGh5BThgRuU2wQnkJJBtjkTVaRaepfI+HgmsazjQihRJj3zfHKDGvHTNs/49kyj7mVQLLrdPEutVrlbTUYCjdK9wdl4huwCuuTwtaW6mT2bXydx9Yw1AOgpanDrMkt+n8rJ7FE5DplNfS+uZRotk2IziBgfr2LRIFjnTaosOMnk7adH6elozx5YNZImL6yC0HuCusOzHg1tFvnkIb4o1iuWNL0vEQIQiMr8CT/8de+KPdI1uoRBOqKKxAFihNlMzBgi3pebmEMosxkzFzciZgs/NQeNzSIlsv4frS8tqZVz4VJzLuUOqy31RkSKafS9AfM5Kg9hidwBeRK5cgeGZABqLyFuRKsBHQfNuWx6C/E/48e3KQoeS6wPpqH9gWhmO0r5rHObWPpvanU9QrvpCGseQN0r9lUbHDIpxkB6qrtP7GyoxQxHpUX6hUKhBSOXA7MV0bbKZpmF6Wmd+iQ09MRu3Nkzoq3DQlm6/ThUsDsxp6dElzGJRTKFXQi64HnRma6A4N63tGLoZZl9UKsS8HBbbpxFEeYECnrXfqHwcvn7LzMcPgAhhDaqH/2gR++kskehTjFzD2YOUnGrzNt+9svNkXWuaFyTjkvkG1itLOWkUGzWoJynCW9zho9DGMSUNNH4BDwWkAyEler3jrJaohDxXoTHbcemtjLVh7RXfXZRRijkkj7xjK9QUQF689coOIr4v5Api3oIaE3FKHs6e9B1B/yH+nY31mA+R3T4Md4FJpv2N4ej1BkDEW+1tIkx9KGi+QOzex4LSofTJsWp8lbPHK846W08QltLDUfAV38gaWT4TFsKKN6ifi+AHiDW4RWOjyvvekQLfy4bMXvW11ffdl8Q8dT3b1X/KNo5BBpR22e8tCKwetZY1qIG2jAIE2j2FdeKDtnPQiclHQzV2r+Jr8ZwO92eW1TIGlU5TvcJEwo5hlwLmAvYqKFkTTP7/P
 Jn73gfNp
 slc6R2vcyhAeVLKsEgSuOt2sgM0vQXoGYI02mcTEUi3bK6YnW9WiEsZ/3MpM2+2lGlGO0BFSebA1VGZkElkhJ+7DhFj0stQKRHlxwb9Iq41PmtDQIAG/7CyWsh1AzVFIpUt24zynvFi4Pngx18D5rz5NJRnD4io7pAxrS9T5tGiBaptZuccraxD0fyjHkDQEzcdokL4j8QK7BylCtnd2/cXCtgkcP3LLjakVqsBejMShHFPXJvkpkArQBB0ll3e+GC5OZe9Fx/r/b5thblKqbOq4iFXuHYGeNLALnK7wP7zID6OZ7nEXzN7iVdrdDZQ/Th0oBLIYEZzYHZoWqQ+TtUrPgiEor17lVuCe0DdIW3jGCdaCuAi3Ppg9bK1TomCyqVdvA21A5KQwKAzVkhiSxvWs6kZUkYPIBHI7JlocQZHU9eqOdEn1fgvf1bsBHOhg4TpIbOiA/nyRGCPBdNlagZXDQ7Vo8NiLGxNp6WjTAtMaimCiuw3FWSCQ9cAoNAfperAam
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Oct 2025 at 04:45, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> Below is my take on this. Lightly tested.

Thanks.

That looked even simpler than what I thought it would be, although I
worry a bit about the effect on page_cache_delete() now being much
more expensive with that spinlock.

And the spinlock actually looks unnecessary, since page_cache_delete()
already relies on being serialized by holding the i_pages lock.

So I think you can just change the seqcount_spinlock_t to a plain
seqcount_t with no locking at all, and document that external locking.

>  - Do we want a bounded retry on read_seqcount_retry()?
>    Maybe upto 3 iterations?

No., I don't think it ever triggers, and I really like how this looks.

And I'd go even further, and change that first

        seq = read_seqcount_begin(&mapping->i_pages_delete_seqcnt);

into a

        if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt);
                return 0;

so that you don't even wait for any existing case.

That you could even do *outside* the RCU section, but I'm not sure
that buys us anything.

*If* somebody ever hits it we can revisit, but I really think the
whole point of this fast-path is to just deal with the common case
quickly.

There are going to be other things that are much more common and much
more realistic, like "this is the first read, so I need to set the
accessed bit".

>  - HIGHMEM support is trivial with memcpy_from_file_folio();

Good call. I didn't even want to think about it, and obviously never did.

>  - I opted for late partial read check. It would be nice allow to read
>    across PAGE_SIZE boundary as long as it is in the same folio

Sure,

When I wrote that patch, I actually worried more about the negative
overhead of it not hitting at all, so I tried very hard to minimize
the cases where we look up a folio speculatively only to then decide
we can't use it.

But as long as that

        if (iov_iter_count(iter) <= sizeof(area)) {

is there to protect the really basic rule, I guess it's not a huge deal.

>  - Move i_size check after uptodate check. It seems to be required
>    according to the comment in filemap_read(). But I cannot say I
>    understand i_size implications here.

I forget too, and it might be voodoo programming.

>  - Size of area is 256 bytes. I wounder if we want to get the fast read
>    to work on full page chunks. Can we dedicate a page per CPU for this?
>    I expect it to cover substantially more cases.

I guess a percpu page would be good, but I really liked using the
buffer we already ended up having for that page array.

Maybe worth playing around with.

> Any comments are welcome.

See above: the only think I think you should change - at least for a
first version - is to not even do the spinlock and just rely on the
locks we already hold in the removal path. That page_cache_delete()
already requires locks for the

        mapping->nrpages -= nr;

logic later (and for other reasons anyway).

And, obviously, this needs testing. I've never seen an issue with my
non-sequence case, so I think a lot of xfstests...

                     Linus

