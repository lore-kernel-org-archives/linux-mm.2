Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 431A6C5DF85
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:38:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 561F26B0093; Wed, 19 Aug 2026 05:38:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512516B0095; Wed, 19 Aug 2026 05:38:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DAF86B0098; Wed, 19 Aug 2026 05:38:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1424A6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:38:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9969DA2E9B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:38:19 +0000 (UTC)
X-FDA: 85117518318.09.772B2AD
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id BE158C0004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:38:17 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c5bD3+cx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787132297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
	b=wC09fW4rqCiCYZI683KknCksxfl+XN+C+EUD8O7RqLesoZaVK1I94mZ5dndEODHeS3SeZC
	5GxICg+aiUdxtVpQx7ku7VbPr6Xkxi5Upq89wKZRGIR3lw7QS26hQyoPRt3Q3AGCMXcGxs
	2Wr18T+pxMqqE0+I6VS22nTZ8xhf7mM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=c5bD3+cx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787132297;
	b=wKwSBbnOJB01RQTXP2jPEHWbwu4Yo1Lg/6KskgwH24Sde5B4zaU/JmX1/h/Ei+ti5lGxoy
	7QsoX2JXx3UKC/myzCMUrufcYsIW40zpoJv1otY9Xok2yrU5gzORLcq1kg9VMz4iOvFPmI
	6Z0h/l9jdU7/xKzPUXmHqJPTQNVfWsI=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15ba3a2b4bso100423066b.1
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 02:38:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787132296; cv=none;
        d=google.com; s=arc-20260327;
        b=Z9r16gOj8OZdQJ/0DN663J1LkMIXxKo7E2KLMw2kWwsNXh8aBASpq4uWNA98S4dYCa
         rF1zDA7+TUd8+lgcpqp0q3cCwHaxh6exQvP+OHehN5/QM4gTXc28VYYPpBi4HMGFspuj
         +XGelDsBbQzOCpvoRcNyWstn00dK8AQYihdsO7LEMEtluEMbnYZqP9ZFQceGlgn5Kdfq
         51+fMwzwkL9el08GvLxa/IwM48t2fbdzvKl6wwbKkdgaI8XrlxpyQkGZTbyblaR+tOcT
         6C3Xi45Atda4XjqSmUI2q+5kbjyIKXMididzD9BopAVynA52JbVGILqwARHOWwYsoG5l
         VSnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        fh=Tegm9b/wb9oeluhlaL11P0PiP4fwGOgkoLy+Bqu40rk=;
        b=l4EmbZOEGBIYhBI6ex2gYKPLS70dOoVoSJLrdopFDfzgF4aXxrVUPEJsb5JpBm1lcF
         Pclvy/tYpi4TRTx2usSsISiNGdn23EG96H8yNgEyFBrNNaag8kOKP/D43V199lBBWTGM
         fFYkb4QrUhzPPUzb/5wArPVuYPrbRzMJLbD0R7DujiVK62r/OqLUr/lyfMl8V08wwA9D
         WUMtPWwTrU856J5SqpdGZ8NNFaGxav9Sq9ESGkXKiZiJtDaINfqJTrF48KqVhKAtwjxt
         lQfZgI03IcGIC4kOld+RIrrrWCO+5+qj9hIdev3UY/NxjTpzMzzPAuypgegRJYLF4luE
         BNrA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787132296; x=1787737096; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        b=c5bD3+cxaVRTKt1G51eidDWa1BdtDbolO1XUbSfgLG6VhlWwdPZQGq26OGD4An9Gh5
         +RAwFkz0M5upkCS2pSn5gv2s2byA7NNNRShZsubY39iOoOPAgHh+tbcg3Z6Ppvdrp86Q
         nH59P9Q0LWax/IbiF7gkF3iVEZntkzVXQ1dBm2fiHLARG9FvNrmyj/Z6/L077YQ5NqmI
         rXEiAVzYqOR55NkjGF0/bFS1pfDDsf6qj28+6dR77Am5aIRT6WUelK7Cd50v+xsPZjcl
         yMQK1eWzW81QTCOFx2f/Fbaf2jp7Gsl1m2erhX9JFVGKtYCaxPWvmO6rNumhnFeXwnL6
         63EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787132296; x=1787737096;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WgGv6nXJvnSh4Pf2o6FlfLapyYXpkV1y0u8uDjsQr1w=;
        b=LhKDFzyhHZLKaVLzkb9f9AFLzlmQF8j7GHnB20J7lrTwDUCgbsgToUQhKGl9Ni/J1h
         2o8up8EN/f58o/3RvmFMvexrTqbWJmxkgeVFkK1XH3PdVc18qe6fG+A6Z+pknn7GDlwX
         NVuUVY10Eeh0Al6mb0DsmvRHvdwp9xxgwLjcebkui/JKd4q7H++x5Mp39qe+4/6AV3ia
         QFApsmxA6F0s6s1uz1yAxH8Mk/syqLjNgFcnBDzBeEm6wxSorjz7fcMDCf1uQdKEYuq7
         W7gfiQJVJ6IIGTRi/t4GimYFCGuIMD0JEls0rmxu3/lcZWmD+CTh3PqdwC+epIzSGp1P
         GXJw==
X-Gm-Message-State: AOJu0YxgH94PVMpw1s0jBl55qJ67Ys9WKJlVJk2V7Bst8dAM7vFZ99ld
	wZBi/Lxpo2H06o0WcG53++Xjb+hbZYBB0K+bxhNWIVRrjUyrhuIdYlYLYwpwyqIfXCnXg8tUOwc
	aOt44FAi/iV3iuMRcHGaFkGGMjkRv0IE=
X-Gm-Gg: AR+sD12N1NPJooxUnWz13bVm2qh3VEfs8VtvC281CX4wrLnHf4b0gFXyd6Wlsv0g+iU
	a2VaaEN9BMsmWlFyXiZKsKFK/ZoPGbOKcHdNQYYeZE040oWWwubZuQKm2t3+2trQDa0WrZV5dKo
	Oaqs+jxXYNlhoCxXio4S4k6wlyuhEbqLuEGP7vHOdDxufusLTuVTwMWbUD/cBTeSPiW8qNqiqpi
	8aBlELx74dSiC8m0fy7JyzyBpON7FrCi0tdKa3XeSv4I6bBjZHDXS4VKY6FMsFRzyioBTY83dDC
	8ucP8Ux1G3qC2Qezksuz3oB3ymBpS8+9dR5ubrlEJTv15cV8j8gvbXYTeGG+HEiIZFozCi4/c38
	uRQ==
X-Received: by 2002:a17:907:c08c:b0:c12:8b1c:454f with SMTP id
 a640c23a62f3a-c23f93526e3mr229900966b.2.1787132296096; Wed, 19 Aug 2026
 02:38:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-2-8dbbdac0d28c@tencent.com> <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
In-Reply-To: <167ad235-253b-4bfe-9b60-265262be34f8@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 19 Aug 2026 17:37:39 +0800
X-Gm-Features: AcwNN1XIO7w1cQkVglUK5M4lcFYaaWx4tr5pD5YpKIBS4-hwuLixwZYGsbWPDNY
Message-ID: <CAMgjq7A1nK5EiRvN-o1Lg_Q2+Ek7oj4Fnm1qAy5A=ULfLz+t+w@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm/mglru: introduce helpers for manipulating gen and
 refs flags
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d7ewhndb664rpjffjot463fj9oyoe8kt
X-Rspamd-Queue-Id: BE158C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787132297-98268
X-HE-Meta: U2FsdGVkX19XJ3oADfqaVf/7fbZ9Qkq+3B5GgXC3vdGAeJBNI1t5PnVWMsoNPxFjqfn+LIgZCbHWPCK1iwWWK29//u5+fX9zA+d04pSO2/1HjeR0LxlMRHYJzv/SNa8iExYNBpdZNsDfvgTIVIJQLZ/rQPE1a2kd+SSzz6kDwFPJXUpw4bwrLIdPb1hvu2RUGsjL6t9NUnebVI+z9KMEtPWyTgTMpGEfQy6BpUHHFrJ3OtspZ8O4VoU9IFoJuDLHRw5roUcpYa07/K1ZobbFvrw42LnuA591kU63KmXoRRUlAwjL03leVSH80RDLIhecoxc7UyDpWiD1FvTyRtNisAXtmLDVUHaB2mgUF7cjctuvfVsocqYGsF+eVmAQJZgtIdRh2AyB53wd9d8ULD4wXW86V41LGi7bjlDi44P2eeye+Tb915EokgJbtQaWQ2AjiNM/oDNfgOxyZ426JMyZb0nwLKrIohm2w6y1S9sEyV8A5dm/9eKWe8h+WqmwMYhpbYnKZA4lLQfyn6K/7NHq5IcaHHKMh7nPyeIZzRBdxMtqh6ouTWADODXHSDvuBYjdcpC/OuXlsY+1iucKwPf+PnsgicUqGIgiPfeczL+ReuW5DNQm3TE2UP6+Vk98V8L35BHXQhNwK58xmf0tKLQPe8cY6pY53ZAN7bmJuE+8ragA7Sux4ne98kba/+Md6kp0gviogWqDL2c4qa+JRJg6v7TNUeeCpFPNqrC8NowHJ79wIx3TxVI6fvpawEQbfrMN6Fa54Lx8JVYq19v7Z1d5W0kZEZ/s6Mm/NI6eSc5K3Q5FcB/mLf81TOQh7h2SHnJ6AxbubR6fvIAO09HNMqU5lfK5fx5P8OkkIrpEPzq0EZzvsEoH8kH/2m09cg08CFiOACvZY+NMlBK15jK0zvxw1ecBgKyIP7dzq83wsMzzj7Fr2lBz6XtiZ6YzGg9Zcyi0mJ6y76gLll9Pz6oyyJd
 hk3vbREl
 1nA11tpIwLcdEMmPCl3xEmmkSp5zJb/8VCPo1q4HzHcyrgEqXKetYKDfmSY4gdrS2YX1oDO32D1BNk/qNhWs10OuCroxTyg/8e9E7WEXHj0IohB2gZseB1FJMemKCThZ/bcjKvw/Nj+GfkMRQQZzY6Rq9kYwTNwnBbON0f1XoR9GUjpxrG5PYCZfbGnIxhMsUwoUShfB4L7zLDTPnNj02+YCtauChrv0m+wT5ceT3Gn3dMDJ9WMgTEnnRx+vTj/hXxz6n66eq0WLLRKkMnVHtJTlDGmoSFndCdGYsQRqai8UVL5+vCEczjLwJdBkoJjsMmOes4s+JP4VcNuIZ/bpsXHVnWUU/zvDIP4xmAOOzG55LEg+SRBJPPiGCXAYT8MpwLIQRZmsyt8kdHIHpLENV4p2wdtLH5k0ixvaa/lL73RitTvyXcmIhBz6S9J/9HjCiG7vd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 5:03=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting folio's refs and gen info, make the code easier to debug and
> > understand.
> >
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> Thanks for the cleanups. One comment below.
>

Thanks for the review!

> > diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> > index 94f9c3ff5416..32d9354a754f 100644
> > --- a/include/linux/mmzone.h
> > +++ b/include/linux/mmzone.h
> > @@ -496,7 +496,9 @@ enum lruvec_flags {
> >   #ifndef __GENERATING_BOUNDS_H
> >
> >   #define LRU_GEN_MASK                ((BIT(LRU_GEN_WIDTH) - 1) << LRU_=
GEN_PGOFF)
> > +#define LRU_GEN_MAX          (BIT(LRU_GEN_WIDTH - 1) - 1)
>
> There are still many places using MAX_NR_GENS to compare gen counters,
> so I'm concerned that introducing a new macro would make the use of the
> max gen counter even more confusing.

I think I'd like to get rid of all LRU_GEN_MASK and LRU_REFS_MASK
users, MAX_NR_GENS is fine I think? Manipulating the bitmask looks a
bit hard to follow for me since:

set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, <number>);
set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_active));
set_mask_bits(&folio->flags.f, LRU_REFS_MASK, <number>);
new_flags =3D old_flags & ~(LRU_GEN_MASK | LRU_REFS_FLAGS);
new_flags |=3D ((gen + 1UL) << LRU_GEN_PGOFF) | BIT(PG_workingset);

Things like this are everywhere and I found it really hard to follow
what is actually going on. And adding more operations to refs/gen
looks ugly and painful to do, and, it's impossible to add any sanity
check. With proper gen and refs helpers, we can ensure every time
gen/refs is modified, the value is valid (in debug builds).

Mean while, a "% MAX_NR_GENS" or "/ MIN_NR_GEN" seems not hard to understan=
d.

Oh and this LRU_GEN_MAX is only used for sanity check for now.

