Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F08606A33A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 18:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=n5MkfNXX
Received: by kanga.kvack.org (Postfix)
	id CAA6F6B05B2; Thu, 12 Nov 2026 13:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5B766B05B4; Thu, 12 Nov 2026 13:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4AD06B05B6; Thu, 12 Nov 2026 13:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84B926B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:22:06 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12DC51C411E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:22:06 +0000 (UTC)
X-FDA: 85427286252.09.EA30BFF
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 51D92120005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 18:22:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5MkfNXX;
	spf=pass (imf29.hostedemail.com: domain of 3ygP2agsKCAks312rw12r22pxxpun.lxvurw36-vvt4jlt.x0p@flex--justinstitt.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3ygP2agsKCAks312rw12r22pxxpun.lxvurw36-vvt4jlt.x0p@flex--justinstitt.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794507724;
	b=BusJJ/jp+H8wGMhYu5oi9OBQH4jvXnTeaPY7qU2k2oqJp4NsEoVUnLfTHtJ++pTUE7rTsB
	ItIBPh0NYCdl4hQHZ9RkxUFQcnkOb+xBMN805N3NKdiysPUUfjZPpNyJTMbJV8ZtdQT5wW
	00nslw94ghvnQHb6KxpdXsFQMcLChbI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=n5MkfNXX;
	spf=pass (imf29.hostedemail.com: domain of 3ygP2agsKCAks312rw12r22pxxpun.lxvurw36-vvt4jlt.x0p@flex--justinstitt.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3ygP2agsKCAks312rw12r22pxxpun.lxvurw36-vvt4jlt.x0p@flex--justinstitt.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794507724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9R53hS2lq3Ijq537Vl1ow/wvMt9akHjDmPhIy8wjS8=;
	b=JKaLpS4a/LuL4fOKoMloJ1s+X142s08EK2CgkZy5Vu5U08w5wMp97CN6Dw5GssH19meQUP
	bQ3aa2npixUJVs6KVOVkZd8ztTpghsUUoZSRx/Op7dy1aMRM7qs07PsvVmHJeTNq2zcapd
	0smk5t4YxcoXiKcqMG5qUX9pvxHtUDg=
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-4574f1cac98so72881fac.3
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794507723; x=1795112523; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/9R53hS2lq3Ijq537Vl1ow/wvMt9akHjDmPhIy8wjS8=;
        b=n5MkfNXX1CissKeu8eYMrt+FvRwwFltof7OMbh9vf9Lvb4J+mYRB1EGXeF74G176O6
         LlKN9/YXwYfGIP2DSJ0AjpaL7ne6IjANZ4yHUK3KGifGeHvepohnLw0v2RqcerXBVzn6
         EuyjOFgP4A8+1w16clSimbfVOsobRV5kC2EJx/LT4ca3j99Ih1iXG3rgL7vUTxx+gei/
         fkNnrVIhmh56HQ+pmC837+wT5/N8xc/sDeWblFy5cc3bU+kn4AOYqqQIvEX3ggQTJv8N
         OW44WdnSHwJ/qnxCGBvr0MJayP3tskyBBiRW41j3skgFFYkoTYjP20lyXXa7Ffe7Pc3F
         HpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794507723; x=1795112523;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/9R53hS2lq3Ijq537Vl1ow/wvMt9akHjDmPhIy8wjS8=;
        b=yBfyXX8/82BiPMke7wtyGOhObgwWDrgkWF+ga0lYy5P7QjgW2tFdmOfJUuWaUMJPV+
         QAKD7DvF1GwTroFd0q3upkydFEQQWAL7PCSpcPLCL1UV3v3WopLVpwddzsKVjTJv9PUH
         YccMHINgn6yTtt/zOFsBMcbBkwb50NuKsm2aKoVkpPRM4sNtaWN0Dril1gGDegQzu/Ck
         URSO2hmHFPJvD0YH/NOISjKaipsI6MRIA/96VY9xKVFzZoWoIxgLy2k/zW0GZAoCIoFk
         vb3nK3YtD14Jg+nzYz3sNCOV6/q2jPAEg3wQU1D6zU2uas57KwNS76WdcU3dbgxz64d/
         G/PA==
X-Forwarded-Encrypted: i=1; AL+hErFY2qq9fU/rYdca/Ht0g5p3TUffZSXtvu1uewstQ7LTN6IGvRIXQASLtRJIQNQceWB1LSPFqlv/zw==@kvack.org
X-Gm-Message-State: APuU4Z8XnMLvzK/p5cXdFwE1JZ5VQBqMmqOE8M6gCkbhPXdvy+a+fZRB
	gJEojt0Dx6VXdhAQoBLsuLWZNdYY4Uhqq+7IxWSyQIoF8ocojkjemGT7vqd1bfcYQ0cShRNL7rQ
	c61gfB1z6kpU5nvSNCznQiD99fg==
X-Received: from iohf17-n2.prod.google.com ([2002:a05:6602:a5d1:20b0:9c7:6dd9:edb5])
 (user=justinstitt job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:6687:b0:4a7:d759:9b8a with SMTP id 586e51a60fabf-4afdf7a6881mr466138fac.53.1794507722962;
 Thu, 12 Nov 2026 10:22:02 -0800 (PST)
Date: Thu, 12 Nov 2026 10:22:02 -0800
In-Reply-To: <CAHk-=whAF3brA9Wrcf3KDhNn_653zhUsoqe1MSneYJWtS5505Q@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260914223212.i.829-kees@kernel.org> <20260914223219.901347-2-kees@kernel.org>
 <20261112004039.GA523044@killaraus.ideasonboard.com> <avWNCC3_Ff0knO6J@devuan>
 <CAHk-=wgYBrhvo2NAG_Ja-0ovPf=xO20Gcopv9Yrr1u=QVxECZw@mail.gmail.com>
 <202611120905.DF88D9849@keescook> <CAHk-=whAF3brA9Wrcf3KDhNn_653zhUsoqe1MSneYJWtS5505Q@mail.gmail.com>
Message-ID: <avYBdaCYclTyX9pX@google.com>
Subject: Re: [PATCH 2/2] devres: Provide kmalloc_obj*-style API for devm_kmalloc
From: Justin Stitt <justinstitt@google.com>
To: Linus Torvalds <torvalds@linuxfoundation.org>
Cc: Kees Cook <kees@kernel.org>, Alejandro Colomar <alx+linux-hardening@kernel.org>, 
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Danilo Krummrich <dakr@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, driver-core@lists.linux.dev, 
	linux-hardening@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 51D92120005
X-Stat-Signature: yphaehnodo4yrxpo5i4ygp8hq5xngp45
X-Rspam-User: 
X-HE-Tag: 1794507724-175354
X-HE-Meta: U2FsdGVkX1/nlpK3SKMckOLy1We/VUluC4O8tITm152Misnzzz00WjLCNwM5TJVkF8ZrYlph0ShZPlFXv/2KjcMM6hQhPOnuz1nP15w+BrZpLhFy+XwLIJoAQm/Q4rtHgh75NtWLqvnvFVMr+Im7cPyn9sdY4iOskYLTvYlgAqAuhNHqwYkK3FJkbT/XbKinMOxsEh9nPf4sYr31ZLH9qjUcCIfVl+v/42NMctJtLDJglmhN3TPGk29ykAfAMBactfsRyu7dvYemjbHAkiqlc/y+B2PkZV5jhX85KMpAB+xPs5oDpgqwWFOZl2RwTC7iYNBnmco5greo9/rq9L0PUyzFugh+2SXRhJRujYojYa87ri5lYRgpMepVsdYVd5Tyv44OEUmkkyPAYKqbOaXUFMRWiCRjfwl5O/fMwANJHcvyJF0Cv3FKEy9Lx8SQfRBc9G9cfX8pNS0lGlla16l0uaau2dC9uxuy6mBArmacEH5lPJn6AEvQopEz3cVakYUKDr6NfrEMCGEEkbVB2Npoiz5BGqrRMIzb60KOOXdhBUBBkUqr9LYD2FxFrgiv/l/9pgnFVAfm7uUowFUO4L2P/cYPTp5/+3cQXzJMZZzUTS6oyfBJMIYX445/sxsaJO7y5e9/WuNDbzU4ve8gpKc2Ystp4QVD/2qENvmRv0h6H5NOmGQdj7PZt8k0x8+DUr2LyUZKlFKntwkh35DU/AIEB7C8PvclqWf2+LG4qVXQnddqYaJ/A4LDC6Y542jseC1dFUxBbAABhfq41MyITHAXVLriS5lmN+0hq+SU5RLe0O52rLb8RLK3pFucc2voYIUKrxeBIGNp0S32l82DTfcFgZw3jhjBPFItLCAeR4yu2KUtOd2qW9OQqyE9BjVAcQF+izXjXkBwelgqzYLIX92VlsX7okh7QSqmbkc0KDrRIrbbz5wOwalonSne39KF45Qra4Luv10G6YEfH+XA0mO
 D9pPxzU+
 SLGMNTooP5l9aa/VSK83sgNJ4WgCxVlsfdv2FcRiXFQxSC0GcpREvRvAviRrk+o1Jf7xjW2OVfEEUIXgZJcVFsaWHCzK3t4+x0DEotbHDBJXEQoSdCSFlArR5klJd51wWaa80go15b2tg+QmDGsWFUIupGDikjwalNcPqmZDa1NV/IsvPcXfbgF0vDwET9H+ebYwuxAggPUierC3rPrrivmi4OEuS+Bg0uIDa3286TV/NYuRaG6TPF9H/j2rW0Z07+0JXzPGXUP3o6G2F/4rLaaleG1ufjBgYYH0NPsH5KGEVrYEPxQrTSqYh2rMJ0Z+c6GmtVhlRWNowkb3A/1ol94YiiZzqeKu2NiFkXFVub9vgHPzkeDjFyxJPROaeBEN5yMiZ23tRvjEMeJ266Fj703QX6hGqhDnYHpixFxjuWJ4oPmK59CxsuiISzpyVFtDlJs2RLMEVTvUHyMuA4/PYhKknNqmFqxzBCUyr0ay+QsNB84MBBi2SjdkBIXHNOpMv2BjixWFVjI5OpIO4CkJgo/omRqLJRpJqmdkuDy3xYtmnx/O+degJ+PbV1oEx79eoKJ3Drmqtp+JEQLfWenhrIESrvs/ynHZqVOU7ccsXQjbAOlPpf80pSEb0cVma46GSg8PiP2edcx5o1XlU67qsYI+oA1NePa0eliHL2JlAzwN0iHqsn/FHtoSFAq45JdNQqA3wEnKBbE/NW82uv6LcJE/6I/HlwQBsuHrOEMGfzdr7l6XdlfkitIgzQ2SHe9mLAb1sgdiBc4JHDWMucAf8rx2WUfhO2yrXsZuZUJqvKnUXJhSBUXIZvHB/Zrip3JhIuwLugPIpgN9sWt4woZLZ5cWV2W+yRG2NxJ4Wacw28alNmFeiVvxHKde5FuKDxhEy4AXLymbmQy5bmQixd3/9DSpRFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Thu, Nov 12, 2026 at 09:23:18AM -0800, Linus Torvalds wrote:
> On Thu, 12 Nov 2026 at 09:09, Kees Cook <kees@kernel.org> wrote:
> >
> > One thing Justin was poking at was adding a "strict" mode to typedef
> 
> Honestly, the sparse setup is superior. It does that 'strict' thing
> (except it calls it 'nocast') _and_ it has 'bitwise' that is a nocast
> that also disallows non-bit type checks (which is *very* useful for
> things like "this is a big-endian value: you can only do bitwise
> checks against other big-endian values).


Cool. I wasn't super familiar with how sparse handled `nocast` and
`bitwise` but your insights led me to look into it deeper. I'll take
these learnings over to clang when I get around to implementing strict
types :)

> 
> So the compiler addition may be worth it, but  even the "poking at" is
> weaker than what sparse already does.

Right but I suppose the benefit is that compiler-enforced things are
caught vastly more often than sparse-enforced things. Plus, like I said
above, maybe I can aim to reach relative feature parity with sparse's
own analysis on this type of stuff.

FYI, there's some prior design with `strong` typedefs [1] in the form of
a wg14 proposal. I've also been keeping a close eye on that stuff as it
develops because it's essentially strict/distinct types with a different
name.

[1]: https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3320.htm

Justin

