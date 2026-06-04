Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E788CD6E6D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 14:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1B9F6B0005; Thu,  4 Jun 2026 10:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA5146B0088; Thu,  4 Jun 2026 10:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45BA6B008A; Thu,  4 Jun 2026 10:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFAA26B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 10:32:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31CC640789
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:32:00 +0000 (UTC)
X-FDA: 84842469600.17.AE8D031
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 07C15A0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 14:31:49 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780583510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jHCD/usXrKJEgEC7iBTBFv6T3P+9p6Aw20cG/HazQio=;
	b=DzA6EnL2Fg+WNGTDkpSkcZrGD6JfI1pvOyK9/q5J99UAG9q234PlvfY/ZsBHbA6Kzf9y8e
	sONicIzMapJ8Orslny5X+yo1E/Hl3P6dHzkgb41X/oWR3z6JQeHG7r8RIPwPEacWI9Qy9k
	0V1XNpPPFZsdbZmSjJWuVktuYo+SHtM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="fkNxj/BS";
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.50 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780583510;
	b=v3+E7IvEADlkW1BtiV1A2sjrFQtY7ICtiHedBfey1p6pjm3UEmBzLjCtOWDWy4gt3Kj4nm
	N34ew1Y53sqzXw0fhfHUrexZMZ9r0eY98iF6629njakfbiqDHKcR6DnH8kueZh5j0yb11P
	grzEs/i9axrgWOJS6FNkZJLlDHujixQ=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-bec3ffb95dbso126174766b.0
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 07:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780583508; x=1781188308; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jHCD/usXrKJEgEC7iBTBFv6T3P+9p6Aw20cG/HazQio=;
        b=fkNxj/BSFj4qa8Az1PODgVS6LOi8Vx7Od1DGnw/K5Wkjk199tuM0vQMyP84CyASsDH
         4BjxWrJX0PRTAljAjHyimj1wJn+ptD9XQUKW88pgxubGeMHGavPIG2WAWkB+TQV5zllt
         yWnKj+yU7c81G4X9LUZLaw+Qy9wVU+b6vUIJM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780583508; x=1781188308;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jHCD/usXrKJEgEC7iBTBFv6T3P+9p6Aw20cG/HazQio=;
        b=fC9DGUcSNhZh5OT39NvQdIZfcNE2EFpX4BzUTKj/PcceiIZ1usjgtmht1KpEQxGJRb
         3o5Gs97gi8Tc3V6EOqX1TfjzitI/mCRZ6GTMseClHBSSOZtksot0JneTQGTVYg90bPjA
         X20rYYDgWhaxMndH+3Z+Leq4Nyf2ZqtmqafZ8yEfCWOB94Ih72MjQuBrFNlkaI+pqfmb
         C4IwTIxjLQFItLLCCz70O06rVdeG/PJI35EOkcgTenUMCpb4XjZ3u3a9Xg0G2R3cm/FD
         0ZTJuOXhOE6SRPhSZv71jGQeesY61Stg8OKR+bwR3uS549Kg3o6ekESKGyr0SmWDs3WF
         Qc8A==
X-Forwarded-Encrypted: i=1; AFNElJ82CD2dQAGg5AwEKA/i1o2/f6cR9Pddr+ba0jNtRdPB2CF5OrjfohkrPxOSUak+D3EDKGjmbbONsg==@kvack.org
X-Gm-Message-State: AOJu0Yy5Gn5f60Fg7dZ2dGIje9aXsR/0G8bLV0Krpj5Wh+NyONMbh+vl
	C81UHptKqmf6rvKn1a4hLf0eWA29zXJlDwcet78zfSvU6ImhIdEvVSWmqFRSQ+5R0CDlWb18vtp
	ZJmZ1nesugA==
X-Gm-Gg: Acq92OEpf5V2GNpteadXqHqDE4uvtKVaSpUmD15XF7d0bY7gEWZKPuAr1YPrfQAxjVb
	+sbVRj1lBbtIzTo+EUZ9Tanhtpx4GgIk+44u3IqGSSTl1zx8Tp1sf4r758lAfVAHKa8OQNiBusz
	UJpPzYUhr8OaI1DwLhTwhYRonErVfD0QnPg/wDeA7Bk2s8P5vYqzb+OQehiQVCSpe9Y4RuTcbjK
	4P/BLNBTvEbdSVfRgLf1b2LDOUjTGsDjDO71YRK5RKbHDJf9P18v81g3yKt4Fnp0XebqXW/5mBh
	vQuDE4AnfNFuL1+G26Kq8mk8T45/s4QLxEjqM1sHVSf3FdHlYiBfaj/OmeHKBJZJqxFAjX22q23
	OHRJ+nXDGytHol745VmKXwbjpzWXIt/WLT8BeMguhSiIxEZDqoZjO6Cs2IMHo05TSXl2bJmABdD
	HS7KTXbgKHL7uVauR0AiU0958NMLWOEliHsvY+zNPg31gorcpRW6M/Yjy3x5djn2/Zh5nv5V+mC
	Aa/uVsejpc=
X-Received: by 2002:a17:907:aa1:b0:bee:4c9f:187d with SMTP id a640c23a62f3a-bf0af1095d5mr295474566b.39.1780583508210;
        Thu, 04 Jun 2026 07:31:48 -0700 (PDT)
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com. [209.85.208.41])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0558f3885sm307732466b.54.2026.06.04.07.31.47
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Jun 2026 07:31:47 -0700 (PDT)
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-68cc6c7df99so1098606a12.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 07:31:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8L6UOVoM7b9w92FNeACxRzKvsT8cXhukmOs87jHTfjqALErhdg7pH9NBH2Mqms1xVAWrKo4vGQwA==@kvack.org
X-Received: by 2002:a05:6402:43cf:b0:688:12fd:789c with SMTP id
 4fb4d7f45d1cf-68e70412737mr4177929a12.9.1780583507075; Thu, 04 Jun 2026
 07:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
 <20260601173325.GH2636677@ZenIV> <20260601160455.2c187574@gandalf.local.home>
 <20260601172825.a51a588ec1c32617a0e12d78@linux-foundation.org> <aiEb8CTM-ovMIq7-@1wt.eu>
In-Reply-To: <aiEb8CTM-ovMIq7-@1wt.eu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 4 Jun 2026 07:31:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
X-Gm-Features: AVVi8CdMcH2Yi8zy-bOiW7jRaCCsKof-RnAg4JQ3nwUYFdve2Wu3l5Vz6H4KhIU
Message-ID: <CAHk-=wiQB-j53cTs9kM4UeXoXPaFj78aJe3D6Yp1Fohg7i4tWA@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, 
	patches@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-HE-Tag: 1780583509-814556
X-HE-Meta: U2FsdGVkX19QDgN4+T9ooYfMCreNP1uwE0bwXTn8c+tq+/17g1dhFNWqutKO1lq8jSX15o1d9wjmTiGXRfK4eHVLxaUOW0YkHVe4B71hZtolVCaMyHSDQsYehj0GCFhCfNqdxT/ZtTkEBI7KlkSt4EiX/+XPqeqj2nNkY+JuHpVlKIzL8VqYjd1Kfzj6sq7oYNppVOjK+tmkmpX+FmSye0PWD0kOARx2gzvlRjpAoUVFpwP6sSePwqetlNCD9uNuCCKSylHne46cP4/PhNpSJQeiCwYjJM28SQXxGzUX3UbkhbhUO9ANkuqj65uNaDR+8K2/xM/m9wKn9hu58MBV+6v7JyuLPbWn6qKwdsDY+Y60Feu+1J4LAatZi10SWZ97OpflQkMTaEeDV1YMj+aFVTnA23IR2ZyGg7cz/i84khZS2ZPVLtkE7mbVRa7oamiNHebCERww634=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 at 23:32, Willy Tarreau <w@1wt.eu> wrote:
>
> I'm using vmsplice() + tee() + splice() in high-performance applications,
> load generators to be precise, and soon a cache. This is super convenient
> and extremely efficient:
>
>   - vmsplice() is used to prepare a "master" pipe with data to be sent
>     over TCP or kTLS
>   - then for each request, we do tee() from this master pipe to per-request
>     pipes.
>   - the per-request pipes are those that are used to deliver the data to
>     the socket via splice().

So most of those would actually not be affected by any of the existing
patches: the pipe->socket splice would remain, the tee() code would
still just take a ref to the page count.

The vmsplice() would change, but looking at your haterm.c sources, it
looks like it's mostly a fairly small thing ("common_response[]" being
16kB).

That is typically *faster* to just copy than look up pages.

HOWEVER.

It looks like you're actually doing exactly the thing that I thought
was crazy and wouldn't even work reliably: you change the
common_response[] contents dynamically *after* the vmsplice, and
depend on the fact that changing it in user space changes the buffer
in the pipe too.

So that would break *entirely* with the vmsplice() changes if I read
the code right (which I might not do) simply because that looks like
it really does require that "wrutably shared buffer after the fact".

Interesting.  Because the vmsplice() code uses get_user_pages_fast(),
and honestly, it never pinned the page reliably to the original source
- it breaks COW randomly in one direction or the other after fork()
(and I thouht even after a page-out, but thinking more about it the
swap cache may have made it work for that case).

Uhhuh. That does look like it makes the vmsplice() changes untenable.

But I may be reading your haproxy code entirely wrong.

               Linus

