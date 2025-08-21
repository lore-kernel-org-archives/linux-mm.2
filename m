Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DAFCA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 20:49:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AE58E0058; Thu, 21 Aug 2025 16:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3B7B8E0056; Thu, 21 Aug 2025 16:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A2B8E0058; Thu, 21 Aug 2025 16:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AA4008E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:49:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E2A91DDA4F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:47 +0000 (UTC)
X-FDA: 83801956014.01.A4BB64E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6C6E71C000B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tCgTS1FU;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755809385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LmqX97eu+MlKqIUBukvGfeJmHSN7bn3Db50MPY9O+uo=;
	b=e38qDkCF5L75re5cWGlT5e2uiBMpd9h/bsBl36tbAORtLoJW3F9EPGOKH7ag4EFSdwm9KX
	QCR4XBt85dVkm0G8RITQOW3SJ6dmNcgtBUDBjvKg5nbcpao+IhjbDCmlokc7gZE75dgQhd
	TR0o2uBjzsDPfaQRZCPdCj/hAS9m8n4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tCgTS1FU;
	spf=pass (imf21.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755809385; a=rsa-sha256;
	cv=none;
	b=oZbyayomUfutp3exA1XEHDkybuCn9tZHwv/jWM1R6XHWCtiy8MAoRPtvsyWvboZJ/m8uUy
	Hi9bb/5SLBta2ukzrZUtR03qjfF0z/dpmVF/nI4tsDxtdwfovH5BnfQMWUBZo9Ll/LEVfW
	Q+iro7unlcbtuco0uAvfJyi0f6yy77s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 515B344A86
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210A4C4AF0B
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 20:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755809384;
	bh=KoIUInjX6RJEpDrGgIm4Hycfp7oY5456rd0zqjDmfjs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tCgTS1FUJED5X7BKRr1G1uHmLLdl2HxWV5HWRiudFUmEweu/0jCZzpVj982pmN3wF
	 gfbUDV19byGg11HLjIC5AfMnYxgUY0L1tgD/fSWTRJ6I3UoJsMxFBZ/fQrDHdJvTIu
	 9OWEVWE8BSh7wJSI0KcSbmH2xyGYUlRUMkKsNbxWjrs4Yysis6wjO5KQExw7xGsSoQ
	 N0h1ax18NzJuLok/Pdp+GDtqhqyFwbrJWSWluiJLAHNypBucs1ID6K25VIcRm40Yrs
	 cQwUFKd3RNpYQIthqljoUWy/M91EqpwgQCtsrrpv2cWo8VpgbTtb5tjayZvwzXJQ3P
	 EvUEBo5C56kxg==
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so20705e9.0
        for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:49:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJNfpk+N7puFO3CqV8F2Au1bJRoLiCaIBnVjHSPKNv5WzjeSN5rJS4bvbJpyjuvSJB1v+FVhueRA==@kvack.org
X-Gm-Message-State: AOJu0YwBzjg01OOuIYFdUd974wrejfOiLBL2yh/1qqdoBkFzdEPYemgk
	3Ne9+aehSve2tzFIPbLkUnLc4Wozkoyd+DeR0DC/1WOR3BmkjUUh/j9DswdYvI+0EgE3ZqQSA9d
	uQ+yaFQ0cYNmhPOs9NFQe1hfKfGt9p2KLdPTfUWLn
X-Google-Smtp-Source: AGHT+IHl0pS9R9FTkQgIv/5Hdf1X8d4Nj3rq1y1QABgTLUekN9baPu7Uk8DZ+Euo3lzu+Y1TgqaNMZRejMKp976OXZ4=
X-Received: by 2002:a05:600c:2d47:b0:45b:4acd:836d with SMTP id
 5b1f17b1804b1-45b52128850mr12145e9.5.1755809382698; Thu, 21 Aug 2025 13:49:42
 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4yLDLvOZ2=3iVcQhu2jnbWQ+iTQsqVefJsx4_YT4bnEZg@mail.gmail.com>
 <20250821164255.78596-1-sj@kernel.org>
In-Reply-To: <20250821164255.78596-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 21 Aug 2025 13:49:31 -0700
X-Gmail-Original-Message-ID: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
X-Gm-Features: Ac12FXyGjYZaF6MgM88P2QEJUWcwgSvwYevAX28lXk8lha2JfaULLr54VhuGvAI
Message-ID: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, Nhat Pham <nphamcs@gmail.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, 
	David Hildenbrand <david@redhat.com>, Baoquan He <bhe@redhat.com>, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6C6E71C000B
X-Rspam-User: 
X-Stat-Signature: bkb7jpqa6eyqnxrbi9ppgt4w9yuey83z
X-Rspamd-Server: rspam09
X-HE-Tag: 1755809385-990694
X-HE-Meta: U2FsdGVkX1/tVE7DO7CyIj4OWrB63rHd6yuTFqAfUobxzu8t/IFX+N9iNAuq+znZkWPcUMxcOXGYl5SvHPEM2XYg0rIJyHV16S07afazvPWx/jL4lB1mvXezb2ScV1y6xVjyVg0Qtjpao4KHL/OzDUAYIiBMs4b/sFofMW7CuffN1RQAPTdeoUDaS64xtF4RgXZimhEF4cu/0BDyOJKh2k8bZxVDQaWTVd2zmvVt8/l1NWspS6JtBiJeavpRAaw1Lmo2DN+LuxiHSM4rQoW946MOzR9btdR+Txk7u2/KVFe7yxjh7GV4pcvQvFkaOUoF7geZiC5CCVwpQsm6XN11MuHHhD98np7Gpm5Fl6TjMntsc4a6pOIE1ZGl8In41AZRmi0U9e1fqyK6KPpvDrieqNq6tayOT1gC3RMJJcNF65MMkNehaLNzaDdyjI10Dqa7cTZIaiNpCSW7IA6WAyGFdxPHEaSGXA59+Wi2v4JoQEDnJM7c6N1t5ubBWbXa5zjtZWrR3BtYW4bZW+sANIU0aWFUDHy84xN/BrADxgODxmoQi2qfAzFYmLpM9T3QLufAkP4BBDIxycjEjVbA62UtJa25iPcphwfsEU2XnZLbAkJFqGh2nsZesc+sbR+UQQhE2NLz9hjv0mL/MnAXGnpowKI+NLF/XwqpC85vy4sPN5jSL7FoEJzhbJkRcRPynEu/EVknzMpx6dap4nyLYkySUSE3Zo9LYAieCKMXY4stoqI+Hh5wtjtM/cWc+mUhGlCUjyadVw1rgO2cgJ2RUDOKKTOZDiDsqAd3DLBy5ZJKk9Gs4GOyU/s5wngZuGus1D6CoFY3HGQvH4nCfOTb4v6jV0v1h4IWvm0dYbxsUnq2KxVh7r1QfJ3sAPl+U8SjhvAOXhU02X/W+ZIMYFd1ASjnwRyMgFiJuNozVy8GFO4R3iQFnoMnKI7FVRhAeSg8XDhJwaSUi/M6zYCkn30/Tbk
 InzI+B+q
 OwbqGRW4qLEKVvCRZo+h2aVCLf3LopJ9gIv/aa+aNELhFqDmG0/ylZ91zATAl3gxfHD0Ejb7RUWWvRyPdzoDAQxG3Y7dRfT7W2K85RLIx/DZYPvTHJUv6j/cVuT/oOxS4wNTSEtgIlKrOCNKIiC13/jaf6jTzz0TsDBLU9WDfn5mFok/J0rG/N6m6pzBJ9UcIDdkH9cRndXNeYZwZNGMmkDG/wdogyYWKzQU9pLJI5a7igMLjV58NITwMXsWT+ce43mUA1j20FUGCafS8HfzKY9R7+FVLZM05A58BUQZgVFJmYU9oOVyuCOsR1qJ/Dy3PseRuVUWgVpTZaSeRaQBTbreTrPvi0Y+KDHYQh8yW3lpFnLBagsvtNPW/kkkL2z01F2Hf9MLLulD4jOX7AevX0wCmBrqildb0qLPYstlno/3r4PgZXRRNxsXROw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 9:43=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Thu, 21 Aug 2025 18:27:52 +0800 Barry Song <21cnbao@gmail.com> wrote:
>
> > On Thu, Aug 21, 2025 at 1:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Tue, Aug 19, 2025 at 6:37=E2=80=AFPM Herbert Xu <herbert@gondor.ap=
ana.org.au> wrote:
> > > >
> > > > On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
> > > > >
> > > > > We might want to revisit the old thread to check whether it is no=
w safe for us
> > > > > to move to PAGE_SIZE in zswap now.
> > > >
> > > > It's perfectly safe as LZO was fixed months ago.
> > >
> > > Perfect. Then I'll revive Chengming's patch (see [1]) to reduce the
> > > compression buffer :)
> >
> > Nice!
> >
> > But perhaps we should wait until SeongJae sends a new version that
> > addresses the counter issue?
>
> Is there a reason to wait?  I was thinking those are orthogonal problems?
>
> Anyway, for the counter (crypto_compress_fail), I don't have a strong opi=
nion.
> To my understanding, the options for path forward are...
>
> 1. remove it,
> 2. keep it as is, or
> 3. keep it, but account only -EINPROGRESS[1]
>
> If I'm not missing other options, I'm tempted to the first option (remove=
 it)
> since it doesn't change any existing things, and we can revisit later.

I am fine with 1) removing it. Maybe add a log once print error on the
error code if -EINPROGRESS, just to know such extreme error has been
triggered.
>
> Please let me know if I'm missing other options or if you have other pref=
erences.

I just don't want to hide the extreme error case but I am also fine
with just removing it. It is your call.

Chris

