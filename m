Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B90CC6B12
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 18:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 465FB6B0095; Tue, 13 Oct 2026 14:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416986B0096; Tue, 13 Oct 2026 14:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E0186B0098; Tue, 13 Oct 2026 14:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBE136B0095
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 14:56:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A7EB1401F2
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:56:26 +0000 (UTC)
X-FDA: 85318508772.28.B5D47F0
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 635B414000E
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 18:56:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYQlHLTP;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791917784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+LzBHj4tBeipNi+QlNyJEU/f9POJz901L8zWPKLrZks=;
	b=LUDfCbYcqx8J/CsUnQXDoj2HqmgsMlz7bqbW7XsmiT/lbXs8MiV4G2NiC7asfsg6i7bo3B
	RvOHt30R/uP7e0tospCqd0Keh1q3+SPVgw9e3maBsOHNrFMdtmGhC6/DP0Uw5lTXSAMRv/
	y/2Go8MgrGJYqscmUGYDW26ktfaBKwM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791917784;
	b=L3QYyHk4WAScryuIdpoeBFv4m74+BexKRr+7y+tONwy7xl/qC/hgekMJFpbhYTXGfx3KA1
	5plkWwDgMdvH4UzSy/b4GlG/lJpPVP+olDOvmbYv4JvgJIVDxubGUjnAmGjDr0DRHqIjnj
	IVyuyihs8kfIO1ENeYRt0N5X7ZyrsfI=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cYQlHLTP;
	spf=pass (imf26.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e69aa07c3so34539466b.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:56:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791917783; cv=none;
        d=google.com; s=arc-20260327;
        b=qmE977KLfThjECAQyD0LAUeEZk52ENTOiHhPSoS1Jo95tIUeE1EewSvinpmvg8V83h
         +iPuI/943q5uftNc+XE/fHVVZ0J03dYkDYX1ffvDa3j/qOHFufYKL4eKok0qZ03oqjV9
         6WoqSfPBKLjpESRQbdOwYbQWW7wTtllxwOqyFaQDmsf4YcneotfCVKkbSL7jo9lF79bb
         0UQHsLSSbhbRkYJI+3gltqO372AJoTjsa00T8HeK8U5qJI+cItO5hIyTR/7g86ltg7DB
         VyomOjX7eLonkLVTua1bgDkAFGtPCQJ1OWZ/MP9Lx1sxS+46okP7q1csbd0I/5ncv1oV
         iyAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+LzBHj4tBeipNi+QlNyJEU/f9POJz901L8zWPKLrZks=;
        fh=FiwXBTFSBSax4bMSIab4GL9hG8uju3CDcS0kV2p6Gm4=;
        b=GUzgyKXlF4lM4C4FYinSAbShsXkSeBB68VCk/GngrHaK3CNsf9ZWzHSWKvVNHwQxzp
         GFi4ArmN6DWRwv07XpGqJqpk9v0KhyBTLD7w2ZDsMtaGJZNo6zS3pQPZtiuFkk4qi65M
         FGm/LjAoGs73esnT0jgxIdJu0dCdiR1vSDTytrfO0//jMuoePVih1a5bkbua/+Hzh6f3
         PYek5akgRdY6EdqVd87Vrgqe25QAU8GNzH9cg+lZdGRNjtT2fVU6Lg1hUh6HCi9NLlSW
         i1o+JX/1Dyun4U6YISS6q1wNVXwIZR4Fp4NSJkseulpoLh/2jOxJujOINUCm6VQ6jFDc
         ifYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791917783; x=1792522583; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+LzBHj4tBeipNi+QlNyJEU/f9POJz901L8zWPKLrZks=;
        b=cYQlHLTPExtKpu2MOAYWqycSxGte7e06dANKSlaMu3KWvWjsldrN1Fo41LyBIb4x6k
         Y6Fy0Fs5pFhkc+p8D/aIgprxWT1Cv+Y4x8tGNYqukqvsxWAfbhRjYjItkT5TPcICXiNB
         38p3K2q6IusOqDJ/xt/XUHKqndNLO+DZjH1Gli7ULiWnBhbNaEm/7X1NwLKk2KJEyL1h
         kRpHvwulD+5snF/5gRvZlUSpILLmw5Ar4Mv6sOUjjosmp/FebwLjlL5mJPUeQbhqdcWn
         1q616qfezBuiPfOvG/47GDBPW0M/lhkgNGs24CfM4gaoBLiDkzBnPO3naS6U/aHCdpoO
         JnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791917783; x=1792522583;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+LzBHj4tBeipNi+QlNyJEU/f9POJz901L8zWPKLrZks=;
        b=ykII0EmVhSlngj9+/jWJYo5++dSiIISaCiAEjP8YP9grsHT8Fhhr4mlWN989T5aUzR
         IhVHlT43EvNEn85zTWL4tR8dhDqofk59+1HdgfVfVb9E2QbkArXY9/szhFqqFi9HpmOR
         4yHRZUWIzDJq1rygvxSI5MF5wNoStU5+7O7Cv4kdKm+S0bU79glLm5XlHQX6jguJcVBm
         eQrXv1YrDQxdpZ3/Q7ItftIIiP7YF4f97s31p+NfeQbPeDGlRWqkKG7D8XOGnZQgHp5W
         ckUovypmmp3FMF8YPGbRLnaUrVk6JsnqNwXwTTzLWY+0Yx77xL2r3Po3YxB7KHsMsCuc
         HT9A==
X-Forwarded-Encrypted: i=1; AKwUvBwTqcuGmLBg/LvJSBQPcO1MWe/0ZVI0tbRxWKC6Glsh18fqMpPefB2iVyTIuimPpp6gAsW18WaqaQ==@kvack.org
X-Gm-Message-State: AFq9FYIL9TpC8d6LiD5ci9Jwg5QFDo99x8HuJZ4mCCYIL4kvPlm9K9re
	up/FE/qwwuOC/wRFC+QEIOzImp2Z27o+K8OZSwrLYheJgu7jS8dweeyf6/U56mEGlCEgS4h6WQg
	kX8F9nj+sw+rGWRHUu7H2tcfmF5Od+XA=
X-Gm-Gg: AYBFou0I832HJyCcKxUTQY0Si75BET3DCj1wrLgZXmyomNyCWgfnm9DHDCi5Su7TTWB
	/0UY6a112+lV+I9D1+cDgirpRsbeX85QzCeLMoGdyu95EUSGAaAwC6bPpLJOH6HtBu7p36ZW9O4
	V4QUbdWphEt688A5li0AnKPBS6MaD+6vh4a1YdQDemxd5C6Eq1jfhx07ASpbMYiUQxkpoWhkW2+
	8rSmZkpGtvMeC2UtXz5RAvBwzOVAa/mHgL5m4iIbPA/V/bqr1gVfu8B0Quy6cyvuv2A0cdzRItR
	ihG/R5JqgjIPniHPwi5KxW6lqTXX5miBlqDQqJwfXRX29pRM1XRf2/F4wupn4TolC1qP8cslTfU
	sfOVPXFZ6OlAJ
X-Received: by 2002:a17:906:2081:b0:c33:ca5e:8ddb with SMTP id
 a640c23a62f3a-c33ca6dd72emr527062066b.28.1791917782642; Tue, 13 Oct 2026
 11:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr> <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
 <CAGsJ_4x3JL9JW2cBXPo0j_8-2d6XQQGSpBAkSf-8Hw9N=0o=6Q@mail.gmail.com>
In-Reply-To: <CAGsJ_4x3JL9JW2cBXPo0j_8-2d6XQQGSpBAkSf-8Hw9N=0o=6Q@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 14 Oct 2026 02:55:45 +0800
X-Gm-Features: AclHuK_93vX_-JC5eTa0q4jdwYD54NRJQ--m2zl_el2v0JWsmNB2dSzrEZ0gUQ8
Message-ID: <CAMgjq7Dfeh9xV+qbooO_8y00WbCuuEvRRa-62d_YGvprVY+WPA@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Barry Song <baohua@kernel.org>
Cc: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, chengming.zhou@linux.dev, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, chrisl@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 635B414000E
X-Rspam-User: 
X-Stat-Signature: bqu8cam67xakn9t6eb5p6n9pcgon1yp4
X-HE-Tag: 1791917784-39100
X-HE-Meta: U2FsdGVkX18rvco85gA4bG9J/FZtPrrWZzgJNCJZc7k+Z1F3ZgiszImv7vna2wnvkE+u3g1ijRYgS2DXe+rH2vU+mgM3rIkE4WLFhOO+aFrto61fdj86CDGWK0PrsgoMwmW2fZoBOF5wTJbrf9XoYJIrBWqM/xDEdshYznzUfkmQWx+GqXaV7kqHx+Vrylc9t2yWwoq3Egs70Nn9apji4VC3u/m+/XP0te/B2YJQi7YjKj4tIDxOmhlgpZlEBqAcg/q56izG4ATb8TygRGyeHT6pGvbvo/bRY+mTrVBcZ9Qm8YyGkzEc1E0Tz8tqYbHnlu0fB5upQFAj2Vug/f42PlTAcam/9vCxVst7VZ8PXPjrLsSTlhxmABAmTora3iMXAE2SyR1sQrU9sp0BKi5NTnLSZohqzi9pf15chNr1bD6Q5Qu+3Ufusie6+3hkAGZd6se00PjQpoCKB/PlLQOBGIndQRuqYDHEFZeCFIE9ZCg9KT+YxPPceKzEVX8m0DrqSafoKPSWvyE1PrBSLJX3O9rpCDG3246eBDsPM0HOPZ9zkd6z8jbhYQ91nIeYt3zfpOILjtI1psWX3iQks0Syb6XnKRXYABncA4eaDhTkivxdg1eXwNL7kiWnauiIaNthNj0cgbhVvq/0hQBCqcf3+bfgBUGpljrGGEb36qq5j4GKbKq19NIZCxB40e5DNB/XgvH6F8Kjdq2O61zrT/UL1l2zY7w14WcZAchtns95X0SSppFwOlkNhgzkQRKXGfJC7W/fhAxZl+q47Mhf9m716kvL2tydR7YtqXNq6aY2UZciQVABa8Lxj5DL5l5HQWRGVD5V+SNhtuiZu29ZJ6529bwHrDJrqoHfknuCI48q2gPLepLMl3pire1y87nSiiY6qDxmI2qoNmXUMfWlZjmHPpQzhWjBsvZ/1zOLDEZ3uYAA6Kyl3oVSDmqhT/vZBJTNNvXntghtNIN6NZ5aaof
 HtElOqlR
 JRFoBE/uFX+nnvzLQPKgXSYfhbUpXZqhcGVhWao7lVcYtoZG41GvVublCkPxBNZzJSXhKLeMbpsY2/NalCFvtvVXAMl37Y2U14xBtSJCKTZb88VTvJjmWr20UO24+MxSV3rYhcNwWl2GkIgR1fkh/3v3Luvd+i6PhTJsuGwQ9sz5HTzOpG8xb2eeMqX74Gt4VffZyiPnstFSyzRnRes60Kt5KHxoPxCykFusciICPR9sNK2A1wts0p6yuj/FAQxQVVtv0WMS/lJdzJOCexgZNYM5IQqMQdLu+AIVehhG/z/aIDuUcIbe96gOTT/6b3XD0RPTWtSBnV/Sdp0g0U4xUG359QH9jqGotXXcPZz2F8AZ18RyyAoUeA3wStl/iv+aXdJCrdt5btd4lirqn1aV21PQD/XrMN9U0kzppyxaHS1xkQ33f5l/pYAzgfifhHv0Uz+uCK0FmgiHXwPRNAJ5IGQs1jTSa6wHYukXaZag1u+5UOkSLLU7XxEahwYLUyn2y1qBMJG0ETi7q64h0mogI+N3mnukjRcLEqQWi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 3:57=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Thu, Oct 8, 2026 at 5:37=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> =
wrote:
> > >
> > > Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchron=
ous
> > > device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readah=
ead.
> > >
> > > zswap is the same kind of in-memory, synchronous backend as zram, not=
 a
> > > swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> > > swapin_readahead().
> > >
> > > Here are the results from bypassing readahead for zswap too: it was
> > > measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, sh=
rinker
> > > off, on Sapphire Rapids and 3 iterations.
> > >
> > >   768M memcg (sustained swap thrash):
> > >     metric                 mm-new    + bypass    delta
> > >     build time (s)          405.0       341.7    -15.6%
> > >     zswap-in (GB)            79.5        53.0     -33%
> > >     zswap-out (GB)          144.8       115.6     -20%
> > >     swap readahead (pages)  6.79M       0.45M     -93%
> > >     swap_ra hit (%)          72.1        89.9     +18pp
> > >
> > >   1G memcg (light pressure, build not memory-bound):
> > >     metric                 mm-new    + bypass    delta
> > >     build time (s)          177.7       176.0    ~same (no regression=
)
> > >     zswap-in (GB)            10.2         7.5     -26%
> > >     zswap-out (GB)           27.7        25.1      -9%
> > >     swap readahead (pages)  1.07M       0.08M     -93%
> > >     swap_ra hit (%)          68.6        87.2     +19pp
> > >
> > > Similar gains were observed on an AMD EPYC 7D13 host.
> > >
> > > The gain is from no longer prefetching pages that are pointless for a=
n
> > > in-memory backend: readahead inflates anon residency and thrashes the
> > > page cache (file pages get evicted and re-read), lengthens each fault=
 by
> > > synchronously (de)compressing a cluster of neighbours, and adds
> > > compression traffic when those extra pages are reclaimed.
> > >
> > > Bypassing swap readahead for zswap therefore makes sense.
> >
> > No objection here, I am just thinking about Kairui's LPC presentation
> > about how compressed swap can (in theory at least) still benefit from
> > readahead: https://lpc.events/event/20/contributions/2421/attachments/2=
116/4689/Better%20Anon%20(Swap)%20Readahead%20(2).pdf.
> >
> > Seems like a big portion of the fault cost is still outside of
> > decompression and can benefit from readahead, but that isn't the case
> > today. I assume any future improvements to readahead and re-enabling
> > for zram would also cover zswap?
> >
>
> In that case, if we can develop an accurate readahead algorithm with a
> high hit rate for readahead folios, we will probably also need to map
> them at the same time, as proposed in [1]. For example, if we readahead
> 4 folios, we should map them all together in `do_swap_page()`.
> Otherwise, the cost of future minor faults can still be comparable to
> the decompression cost. Readahead alone would therefore increase the
> total work, which can be quite significant for synchronous I/O.
>
> [1] https://lore.kernel.org/linux-mm/CAGsJ_4xM=3DWnFO-OuwVude-DQ_UkaCi_zF=
_bXBP9Li5+ZPNy0VQ@mail.gmail.com/

That's a really nice POC! We should do that IMO, maybe with better
support for (m)THP readahead too.

We first need a better readahead policy though, or else unmapping
these folios might cost even more.

For the readahead part I'm thinking about evaluating using shadow as a
stronger hint for readahead after MGLRU-FG which helps distribute the
folios based on frequencey more evenly among gens, also with a more
proactive aging (async aging, or maybe lru_gen_imbalanced as Barry
once suggested somewhere) so folios in the same gen with same freq
will be much more likely to be reused. Or something similiar to file
readahead's PG_readahead based readahead. Well more
experiments are needed first though.

