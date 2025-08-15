Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0517BCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A43A6B008A; Fri, 15 Aug 2025 19:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0DB6B0093; Fri, 15 Aug 2025 19:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2016B008C; Fri, 15 Aug 2025 19:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 652218E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:41:06 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 207F7137FB3
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:41:06 +0000 (UTC)
X-FDA: 83780614932.03.6C815AF
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6CF60A000D
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:41:04 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yP4pyInp;
	spf=pass (imf25.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755301264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eC+hmy8FxOOZt0BUy+LXGgoJOiZCGQ/IiVXODEc3P1o=;
	b=Azzn3vbk8neJ4LX5EHyS/d6rNPmvE7qr98TlOPgcOdDSdc2g0M+KA57zfA6xDdutTX/blQ
	yT7cNP53842FKON+Zd3ote3KOp3ukh/DAHgtEUxhDw32Em5naZlxm3P1m0IssrMy6DA7cO
	psyNJpS327pdSPiZnS1G5lj0MK6uR+o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yP4pyInp;
	spf=pass (imf25.hostedemail.com: domain of axelrasmussen@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=axelrasmussen@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755301264; a=rsa-sha256;
	cv=none;
	b=ybQrMVQNVP/jEgBcE5HAeYai/APtXyjIicPZaaarqFA32gbysRa1TNf00owDG0BB1zvIVW
	bxPymZUa/nSdo+1fd8QNGfbaZLybaM8zS7ApkVQnFB3gblS3Gw8NIV9wI3W7KhtD7GqYSp
	rsofWtw2OKez6AtmWIMi8vVCp2Ll2SU=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4b0bf08551cso88851cf.1
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 16:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755301263; x=1755906063; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC+hmy8FxOOZt0BUy+LXGgoJOiZCGQ/IiVXODEc3P1o=;
        b=yP4pyInpVFIblTCOvmRma7osIvRlHOl5RqeZiT5oVVwNrO+tgf4K2P4rkiYkWMzTmm
         ae2nFPe+2PtnnOJMeE9zDwxdPvoQ/7MySD3Re2uKThFqZRtVME1t4YitZVJLtgp56JfZ
         82kTeazMEZ0oHrrZCft2ExiIcz+m9ItyD+YZM9Xn8QIjdtDZgWwccI+ueac1RByxfeEQ
         gxBfYSZwS0L0ZxbAqNTJw+gAAthA5N0w6RiAp9OmB+u1p6MaMt2fWRJgeIMDGVNQ7PPw
         M/Tdo4LtSs8/m3UBcPU086cehKIYmIC8LmFJpKHgMA3A29GhLdJJocULUXuE2IyiQwHc
         4hcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755301263; x=1755906063;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eC+hmy8FxOOZt0BUy+LXGgoJOiZCGQ/IiVXODEc3P1o=;
        b=dN13sAQbV1MEplJofveB8ALo12qmKKm1SrZryXGt+VI5q9LBd/ieR3ulIF8hZxn10V
         42IrCvEMWgPGaU8+Pit5FN0i35Ut+VxkW4Zpdz/yvIjhB/Ys5yY5XCcabO8r0iRcRENx
         cFBEKzd4birTVmU3AJcTQ8EfAcYw4h+quhrUaecDotzUFWqY2yVsJFWErmmEHYddQy4i
         EX2WVy4K8mQMEGrqju7EfgX0H2Fn1WkOe+t9c6ZyPPLnfS5YI0i3CTiI6wq+S6tyH6Nx
         bi/hQVi64HGTWaRmQt2LZmZuS8SWDd5QgI7ZdRnn8edMruayuhT289I71O7cwJFhzxq4
         2TTg==
X-Forwarded-Encrypted: i=1; AJvYcCXrg6dtQEsfz55S/nkLOntMC3wVj/0kPdDJOLSdfUmLq1+LbOj4/C5VD03JtxsAXPUdpR6kIPFhVg==@kvack.org
X-Gm-Message-State: AOJu0Yy9xXy69774uXbQC65W8MIhAi2OUQ7CMtz+tnezP/7wweRDdH25
	xiVBwl5h0GpafYg/pLZd1iAhEwPdXfYsu0jsgJUfaYasQfXpzAxkrYTIhCzoSokyBswHHB4MckW
	8Gcfu2vgqPzqgdcFlCMe382sj4uqERb3Pf9/Zsbbs
X-Gm-Gg: ASbGnctI5ChGjD4U5FF/boRTxYZSRLWP3WBYD7q6KrYKKaYm6I/6mZbD/BqgKT+8Rg4
	ih8JzabAQoRDcKeQORbWoXFrLOvFggFWxbV7uEtlFo+qd8ce2ICA4pBGJe+EDzGN7J/QPfXOTWf
	IzSChvmbrqNgBdl407/d/jLVSHFo93OPvtx22CtciAH7pCIg+HfumFboI+oSXzjs0SZxlv9+7wv
	Wnh7ClK9xWP8Zlfp6njJiQ=
X-Google-Smtp-Source: AGHT+IGrhyPvvxTOfa6TjnEQTZi75pbn9usZY5vdhT1RdyXHVbBFYpxokexBB2Fw8B3UMydhkThzOeMQPkqiMVkwmJU=
X-Received: by 2002:ac8:7d48:0:b0:4a6:f525:e35a with SMTP id
 d75a77b69052e-4b12bac1cd2mr671791cf.9.1755301263038; Fri, 15 Aug 2025
 16:41:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250815215914.3671925-1-axelrasmussen@google.com> <7a46f7jwlwgkbdjvbxjaalrrdamgtxkptmytllhkr2qv4ovbge@nbugfzavwh5w>
In-Reply-To: <7a46f7jwlwgkbdjvbxjaalrrdamgtxkptmytllhkr2qv4ovbge@nbugfzavwh5w>
From: Axel Rasmussen <axelrasmussen@google.com>
Date: Fri, 15 Aug 2025 16:40:26 -0700
X-Gm-Features: Ac12FXw_HFPZ095gKMlHpRFMN8lgcVFvzndQzLXfmu0HxmUJr4sDsvsxZ5Xh-Uk
Message-ID: <CAJHvVchYa-vUcQo92awyHE663n-iMsLK31o+1FKrMvdLMAuUOg@mail.gmail.com>
Subject: Re: [PATCH] MAINTAINERS: mark MGLRU as maintained
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6CF60A000D
X-Stat-Signature: sseonzegrzas936xehuxk9xco14nbs58
X-Rspam-User: 
X-HE-Tag: 1755301264-522318
X-HE-Meta: U2FsdGVkX19nIof6ZIEl+QKIhfVxCHFvHdAPTDhwIv+Xs/fN37wFD9/4kq5duOY7IouEEnQU9MLKF8auIskYPtsEP7i3usmfFdudpgO+iITlIA2rj2ltF7m6wC6lMemvw4tMh7WPv1jwZaoF3POuKsgMzIXDSpGOtuKSIdoxDJ5/MTYkXddsGd9qLLQajGfuessQtYlPrYrQcGWrGiI5YVMHJLLvVBFkt9D78nLUEowvnnlwnvnY4cqhee5Z6ASbhE01UWnaF2qXKkI/s7dNAgNKdDZ56a35EPxkIdU1/EP5YBI1qFwP6yyuhEeKeKF3fOfF5YhjVVgENHsivVq/tb4fbpr7hyL4ycGOsmIaa0gu1kKgpy0EpWJCnZqYlbuywIY52oN1eDUsSeBhOg8VTgxxcvRe3QKCZCqY++8LB0HfYafnMa4xZEAiXptEy05FNgslmiWQUOuSjCdGPoFy2oWJtj1UI98XnsWwOStw+/bWglfG0ledA6oEjvAvYV2rpKEtJMLbSbIJRDmjxepDQ0ivtbvrFwlZpXXqjUBRXd9ZB4uniZ8CmMPXtVLZy7O/9PUDGD3mw0OgaP87IpX9yYr4FSXAqb31wbVUQWe0xcyizRmYczWVk4D9qa2solPJYNHM8048MBAB1xuE90r8G4K7QWU2WHCDWBQ51Euc2EUE+dDwIYLcpr7ahz2FIMHyLp9KyhSYWA0beb6PkoEzZNWOQDEkzlSWoz/6SWEId47tX31A+QpeXz9vg552CrBqukOBdhLlWlgBPsT6k6ZtW4wZibaBSK8Y4nGwlyb7P03oZxJBpkPqAt4kuOyy0JFz8uZskHAGXY4ZcdTVQz9r5ls7huERzvYrnqLEcv9vsT9M3wIk7sVm+tfEXKgxnXRyL4RzR2CFf9vG6xO98i4J4K+XqUyNYvuV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 4:13=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Fri, Aug 15, 2025 at 02:59:14PM -0700, Axel Rasmussen wrote:
> > The three folks being added here are actively working on MGLRU within
> > Google, so we can review patches for this feature and plan to contribut=
e
> > some improvements / extensions to it on an ongoing basis.
> >
> > With three of us we may have some hope filling Yu Zhao's shoes, since h=
e
> > has moved on to other projects these days.
> >
> > Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> > ---
> >  MAINTAINERS | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index daf520a13bdf..8e987f2668cd 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16058,6 +16058,23 @@ F:   mm/mempolicy.c
> >  F:   mm/migrate.c
> >  F:   mm/migrate_device.c
> >
> > +MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>
> Why not just add yourselves (and the missing files) to the existing
> reclaim section? Eventually we want a single reclaim solution, so why
> not start with single reviewer section?

Sure, I can see the argument for that.

I suppose the case against would be, perhaps the folks already listed
in the RECLAIM section don't want to additionally get e-mail for the
extra files listed in this patch? (Perhaps mostly the MGLRU
documentation, the rest of them aren't necessarily MGLRU specific.)

I don't have a strong preference either way, I think mostly I'd be
interested to know Andrew's or the other reviewers' preference. Note
Lorenzo suggested a separate MGLRU section here:
https://lkml.org/lkml/2025/8/14/271

>
> > +M:   Andrew Morton <akpm@linux-foundation.org>
> > +M:   Axel Rasmussen <axelrasmussen@google.com>
> > +M:   Yuanchu Xie <yuanchu@google.com>
> > +R:   Wei Xu <weixugc@google.com>
> > +L:   linux-mm@kvack.org
> > +S:   Maintained
> > +W:   http://www.linux-mm.org
> > +T:   git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> > +F:   Documentation/admin-guide/mm/multigen_lru.rst
> > +F:   Documentation/mm/multigen_lru.rst
> > +F:   include/linux/mm_inline.h
> > +F:   include/linux/mmzone.h
> > +F:   mm/swap.c
> > +F:   mm/vmscan.c
> > +F:   mm/workingset.c
> > +
> >  MEMORY MANAGEMENT - MISC
> >  M:   Andrew Morton <akpm@linux-foundation.org>
> >  M:   David Hildenbrand <david@redhat.com>
> > --
> > 2.51.0.rc1.163.g2494970778-goog
> >

