Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9134DC5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 16:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAA26B007B; Tue, 11 Aug 2026 12:42:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B6B6B0088; Tue, 11 Aug 2026 12:42:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681A76B0093; Tue, 11 Aug 2026 12:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 417CF6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:42:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFDAAA0BC1
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:42:45 +0000 (UTC)
X-FDA: 85089557490.23.CBC1C49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E675F140003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:42:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RCxvqgRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786466563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ea87HC6oyLzMunIqS3kHNBEttwJX8sETvIYH3PZoPmc=;
	b=2I7lXisfc8+OohQ/5R9/LNYEEPJCcXJRnLZ4JPXewbPPEzrpTTjqJS2i2Oq6TnLYqDTm9o
	QXknKNMx7UHUaJi/th16BTpBCTF/mT5eq3mFCtVCIdNHa6mvkscHHagveb/VRJ7+mPmGn1
	3WF8A9wYKeV5xWBj+htwpaOmiIfIdZk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RCxvqgRw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786466563;
	b=cxllGGHjs5MiBD0fW7HQLqJ6zwR6WfuVKWWsp5PYmvgAdSfOgqKRJj7x6RjYOjQgIeVpw3
	LNFNvAfkqlr5QJoNED6s96QlNAnF7NyLlFYsKEAagat23W90afgrivOsc3EaxWLftcqm2v
	yIbs2yJG3EUB3hirCzhalVUJUS0S2FA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 72757600BB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282631F00ADB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786466563;
	bh=ea87HC6oyLzMunIqS3kHNBEttwJX8sETvIYH3PZoPmc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RCxvqgRwA5e0fE86guQE09SYANw1cQ69l6QAfgydtFtKJQJ/2QHw8JqmGt1FXPQc0
	 vhehfTuoGIv2Ou9cINGY/ra8GCKgH4Y/Q6IuW9Wbth3nwF5AYbYwT9OtJEeUf3yoer
	 GYoHABiXIlFPufT9eKmXkAMINRjU+g0AAEDURimVRtt5xCNy5C3BuYSoIQBJd3NjTg
	 iIeoQ0NdKdCwsG8ZnOjQilaezzDH/QhpSAgBDAwdfOwo0sY7OGyDwFM/YvmwSGMEdF
	 qx85fUnf086AC3MsFLBjTU1aF7gSji5KWRWjs8vUjMoWpd/Ox+HqegVmm5k1KalIT7
	 qENHdDhHGkbDg==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2020421077so5796466b.3
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 09:42:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqgjQjEBdGL+0t2fdLcG71k5xVX8MzcT2fGJODxCZVPGXXda2ZZCD/OfuAjXAVP/nJ8j5R6uD1/Qg==@kvack.org
X-Gm-Message-State: AOJu0Yy+0V2IVS5MpacevGR0ab5+nDRdE31WNxvV1wVtgqWiTF1Rdycp
	lLlzvINWy12b4l0XZp351M3FhZRSuJgWwiMFCSy9Yazng70HnGSoGnrscdCJPJXI8PRfYdUPq1y
	Ihb22+3goKJN9YcSvTpJbyiegK/gDXFo=
X-Received: by 2002:a17:907:d15:b0:c1f:e9d3:a3f0 with SMTP id
 a640c23a62f3a-c20e60df3a8mr259519366b.7.1786466562078; Tue, 11 Aug 2026
 09:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAO9r8zOiwgG80EjqdZFgWQvODUe1RzecLemxcB7xXNm_f3XfbA@mail.gmail.com>
 <6ecf5579-0b3b-4e8c-a625-bbf0a4a48f94@kernel.org> <CAO9r8zP6JrZcBnzb8A3A9V8so4gJMWLvrJQ7VwPyyU417GikQg@mail.gmail.com>
 <CAAnvDSyNbV5xSH0hrX9Tgw_wXU7Neo-XSJ1enebxJXvjOheHWQ@mail.gmail.com>
 <CAO9r8zODSyYTipACxdEzoheMrNKzfFt_tjBzrB+2tSCHA82WWQ@mail.gmail.com>
 <CAAnvDSziZM9TOExkFrF9vNi4VN=7T6yofS-=4rmFqc3jXncveQ@mail.gmail.com>
 <CAO9r8zPuX0j_fZsgRsaNQFyJqY4rZxERLya69TcCF83HrpHy-A@mail.gmail.com>
 <CAAnvDSyDYU4MvRo1rNwxQcnmwHe2_UW43-hZEU-Zf76B2euYQQ@mail.gmail.com>
 <CAO9r8zOPMNDQWZ8z+RsApbA0cddE1au5hTHdRT0NYe-EjmP4aw@mail.gmail.com>
 <20260810200915.8461c16060fe1b79c18bced2@linux-foundation.org> <anqmAJKQ61CDlBiR@linux.dev>
In-Reply-To: <anqmAJKQ61CDlBiR@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 11 Aug 2026 09:42:30 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPu-puruvL7Mj99HEaGb+oht_Tx0w-5yHxWhTK9wsMNWw@mail.gmail.com>
X-Gm-Features: AUfX_mynB-aAjI8LAARZvE6OEKj39irxVokcwmwe8AjBCOsvswPmwS3reAXZozM
Message-ID: <CAO9r8zPu-puruvL7Mj99HEaGb+oht_Tx0w-5yHxWhTK9wsMNWw@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: use ratelimited stats flush in zswap_shrinker_count()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Yunzhao Li <yunzhao@cloudflare.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	nphamcs@gmail.com, yosryahmed@google.com, zhouchengming@bytedance.com, 
	James Houghton <jthoughton@google.com>, kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E675F140003
X-Stat-Signature: kgqoxh1ebzsopb8geko9sz657ahtn4e9
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786466563-739195
X-HE-Meta: U2FsdGVkX19B9i0DOHpk8gnaLlAnTss1wAScKTR2XLA8hm/736N05Ehjz5Im2WTnAsAkNwyX2jyxiem2BNSTVcuCFP9iHX/HNZobNqt5xdrHJeTN2gsfs1ZIhdFCgHVeJJgZ+uJwqDAU0lAxuIHZA/wKU06UXBBbkPN8mLXGXKtrhIw09zTiRmEb/gRrsE8r16G3li/Cx0+w+inpujdjudKRm/cqsxFTukkmlYkcGkDaf2BzbW31g+UDt3meBzjcZLOHRuyYzviZ80u5W/SJ8S1M65FxRJird46E5uUNhhE8d3uMc/kBO1hG1/AyTWaQOtIV5N0kfS4MzKdeLTByYMMKKyo68c5QX0jrNbqdEwXMVNjddIhUtJUp3wDC2Hxb7qp/dwv6TJ/pq315th8gtsZut7xZ68qvpxUQYg4IIxWTIiD11Dhdd2s9SlbgIYE+NKHDHV6S/FqCRYLeqV4m4JOx4rjV80vQqW50deGV4/ZBo9on3+mW2yC+25XNXQf6s12+TMGu208H5pXQVKoKRXziJJVq99Qdvk8Maim9RHv6HQhSx2XDkhVwwfRVYg34IXYNnSTdRgiLYVwTwVuVtKfJhgScoW/tcsLD33LqY7bqeaLkXOk6qv3kgcMeLIzbxgskh+fWretJ39Tr0XhlhZU2kszYBjsUeOuxEqsAfw5wY5aZ+oixafMdO8iw9kQENOJnlO7KbOGEHvFPmzwUhK0hWJIG2mVThGtr6I293ekSRZHpZfZZ96H9wCeGYN8htIbcfclOBE+bcCuWjH9F17QzGE/m/KVF8l3e/FIWaYsdOTrG1SFou5rmuklnNNsS4U4Kj9lJBQ2Ue3904Q76Rr697KKGAWzRHTXUj+qYHo2gYiWudvLCi5Nfiu0+zYFfoJPkH839oRbaIkDVymWpNSGfQPM2WJeKyK/l92r3SMuWtyk58Y4AV4Y227DBLbsHg8miQjT7lN6DR3PG9UX
 v1L10Tyi
 HR656k98yDUkLks0m6bkBYfd2IzI7jl9OtoNhDXDCkjK9IGxKKlmfdWtZAIH1wJm+YHk1O+GxTdYYQSER2ipi4ksynFQdfgCuboCeiVYMhxLecbGtVX+xlFmMINTaEbSzSuaGLhzOEIj0yYTvBGW/j+7fpVnASeZnNprLaRQwq/yR/VjDYRUsXgrBs4y0MnFMf3nj1sEWQmAXnsVBRfwngtgV0Hoeq+BE+dgXzDXgl3g1Uj2qsKpGhPePcX5brAgEIkCYoo+/kJktAfeOqS04hfOrcsbURyo4gD7SBb3tiBpXd5gZCDmzzahSqNNQRyEVSulbzsufv9o5sua7unrCLuKBYTElZyRvqmMlwkIIkUC2KAXlEwys1Ho3Pg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 9:35=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Aug 10, 2026 at 08:09:15PM -0700, Andrew Morton wrote:
> > On Fri, 10 Jul 2026 11:27:31 -0700 Yosry Ahmed <yosry@kernel.org> wrote=
:
> >
> > > On Fri, Jul 10, 2026 at 9:36=E2=80=AFAM Yunzhao Li <yunzhao@cloudflar=
e.com> wrote:
> > > >
> > > > > Yeah the per-fault latency is exactly what I was looking for. See=
ms
> > > > > like most of the faults are not faulting in the pages written bac=
k to
> > > > > disk, nice.
> > > >
> > > > Yeah, at least for our workloads the cold entries seem to
> > > > stay cold.
> > > >
> > > >
> > > > > Would you be able to take a stab at eliminating the flushes as I
> > > > > suggested above as an alternative?
> > > >
> > > > memcg internals are a bit out of my depth to be honest. I can
> > > > definitely test a patch on our fleet though and get it verified
> > > > if someone picks it up.
> > >
> > > I can try to come up with a patch if you can help with testing, but i=
t
> > > won't be for a week or two. How long would it generally take to verif=
y
> > > such a patch?
> > >
> > > > The ratelimited fix in mm-new is working well for us in the
> > > > meantime, so it'd be great to keep that moving forward.
> > >
> > > Hmm we can keep it in the pipeline for now and perhaps drop it if we
> > > can get a proper fix before the next merge window. Does this sound
> > > good to you?
> >
> > So it doesn't seem this will be happening.
> >
> > The original ratelimiting patch seems useful, is well-tested and
> > well-reviewed.  I'll plan on upstreaming it in the second week of the
> > merge window unless someone stops me!
> >
>
> I agree to proceed with the patch. Since this is not exposing any api, we=
 can
> always come back to reevaluate the decision.

Yeah. I don't like it and I hope to get rid of it at some point, but
it's a reasonable fix for now given that the flush is essentially
prohibiting using the shrinker.

