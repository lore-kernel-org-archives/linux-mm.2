Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3225ECA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCAC8E020B; Fri, 15 Aug 2025 20:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACD1C8E0008; Fri, 15 Aug 2025 20:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A09F68E020B; Fri, 15 Aug 2025 20:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 934288E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:30:39 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10B611602F8
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:30:39 +0000 (UTC)
X-FDA: 83780739798.26.39B65B8
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A433C0005
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:30:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbOy036g;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755304237; a=rsa-sha256;
	cv=none;
	b=chQYXy7bNOJ/yDQ2Lev6tmduYwfyVgJlDZaOBL0r8JiYchvwi1VhXYEcJXnaRMnUlWLPqe
	wzN5/bDQdWkag30OiGRnOdhEycfFkalq+iv1I9QtG3XsByYjtzOgJGBhq64CpNgCbRB/e4
	/30P5LS65c3cGhXKRmY2rfOn3QTuUKo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mbOy036g;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755304237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zr0c1xgwNXekQtHN2lc48XqCJ4abIqil2pZxQirGB20=;
	b=tfe4IZ+/AbeRmcWXvSsjUxOUMIMko4lPZBPzCAoMZG11Dx1QYbD7bZgqd0UzbspXvKVsQg
	/6P+OaXL92YsZWkrYPStjnwec2EEx4txPQh+SNXU6kAASCwEZlo9aX143ui4c8S1qKjySC
	g6ihrHltONBPHKzOKvHA+TW3hn+MZ4E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 9445FA5844D
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02269C4CEFA
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755304236;
	bh=Z5e3w81i1QYEjP2t4DR+Nh/faS/BI9gAJ1KAWdhNjqw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mbOy036gTA6uXt69BED+6kidCAvFSV1H3+OfV++/w00gxVooz5YyVtVozeEQN/v/R
	 6fgMJAmY9vN7XK9t0nq+DClyGZccgJcR8bloRVs4AJtVuj69UhVn/AINnnp12JI9bd
	 wbKBeRaLkXtjITnSimWc5x0vXeS6MhiAh+2SSft4E8aZkz6lr5pinbAG+YpMuCLK8M
	 uXAxEbKENW5VE1a9gHF8pdV0mcJA2W/UOLm+8+mpR8NN8alQl5YIrCbfhkmy3WtGy6
	 ER8Xn49w8T504uYmZZ11If2BcYm+NokAXqNf4KMEOZXyaE/iclQTbLQWBmS0mE3aa3
	 1L2wnT17FdcoQ==
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-459fbca0c95so31525e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:30:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJ2ZFaL87go7CdUw/k5t2FwrBFU2wGzGP4b365EW2tjVzrxV/z3UH3HZ5gp6+iOSR/4KlCrfLbdA==@kvack.org
X-Gm-Message-State: AOJu0Yx3GXsPR0OG0hTBvUxTt/v2OplgaAXOSKHLLUk06fcI2eb6jAF1
	XYq90A1QDO/hpmBss6ny/NfAGot6o4VAGn2e4h/WFGReHfUwr2Mupgc/2/k2vQwUEMLW4EkRyI/
	nAMEyGdTHxlnzUj0KJLcWk8/ZUqC9P10RF4cdPA8Q
X-Google-Smtp-Source: AGHT+IFY1WRQdcnftxzS1o7/PUXOH44z2VYljrz9AIM/qLWltmOGHmMdSv3FrUflxQ5d7A923+VD54FYU6oDpi6eFAw=
X-Received: by 2002:a05:600c:4f0e:b0:453:65f4:f4c8 with SMTP id
 5b1f17b1804b1-45a26efa874mr355735e9.3.1755304234618; Fri, 15 Aug 2025
 17:30:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
 <20250813182024.7250-1-sj@kernel.org> <CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com>
 <CAKEwX=Mtu3KyNUv_oWFo9vNiWKkmbzMXmG3t=XgpVtG9C_v2mA@mail.gmail.com>
In-Reply-To: <CAKEwX=Mtu3KyNUv_oWFo9vNiWKkmbzMXmG3t=XgpVtG9C_v2mA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 17:30:22 -0700
X-Gmail-Original-Message-ID: <CAF8kJuO3-Wuf567cLmudG9+ioaB+u8Yt7EiFaMMROK8R-2KCUA@mail.gmail.com>
X-Gm-Features: Ac12FXwN9TsUI5EtBxH8CEorrxtYJMzJGqp57urXPhBGDcsYR-3AyDVGZvRJrUs
Message-ID: <CAF8kJuO3-Wuf567cLmudG9+ioaB+u8Yt7EiFaMMROK8R-2KCUA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A433C0005
X-Stat-Signature: 96e8xb4by64ckkehyted6fqtm14wwhwz
X-Rspam-User: 
X-HE-Tag: 1755304237-163902
X-HE-Meta: U2FsdGVkX196e6SGLrNeuRav4CQ6A11wzS2o3O8qEpBjxBJU5cke1JvbPsllNoDsjm3E1bRXvE41lE1yiqAatiDdal+Y77TVxKGaGlE7b6KZbn3aqF8neFv6KAxyKbqVM4WMMu4HvMLWwkQVzBqJ6reyAg0JX4vhnhYgeIEA53cH0NNHhMniVDyRCs+VlIc94iKgjLNtrpTMu5mhFma2HhRlDZgz2h3PbXhMFyzaZ7VWFeledDRQsigc4+gmdRRraCto8TlJKEtFLplPaEXOdBLOkze5kbbWApG7MAI8cLZGGsQI1vfWSbuX94+3agA/qu5scy6ncKXLMruehV5zVMMtJfPHZUMRGmJeCZPOXqHk7nsHK5abOnCPsCvlF0Y4dx8nSq+4JcxWFXek/lgjTKCxZGu8tLbjv6uzvmrZ2ori2lJjUcUn0h4sZuzqvQiogznboA0yARSvfOxJ+CxeOQrM9mcmi1x4StDKbAXLW7uQX8h38BU7LWyZnZ/CAG4+zCGZq+29WGLHHXB3n3wFcIG0qmoyQ8jBLDIw9GClHImSKVA9o5Z5gg1jEXjKoplDn4WS8KMe31te7oykkm7pscsHtVCDeM/95Q4K58w6/CD6xbeTO5ELHPRff1vJRSeZKBVO7BrXxqBeAWSOjwQkcjjJnTCteHeUzvaE7Sazppo5bdbFXGUmjyK5ejIhmh3wcejbaPsmnZiqhbcalNb/3/ZGBIbFvtYAWExnaFLMGkMR2tn9AR3UuVsLEn3H3XQM5cwJd3ntEJkAVicaE64Y8tDhThqAx+WRjL2/3NRN9L1eq3XRcq5q0lvTyrmo4ViruE1bbCGCRZh0OUeLxIefnFoYat2BAb9YLVno5+8na2FVHaNC0HP8MqlrOkcRl73E6YBRBs31+yE3UFmbl7PaOxODgAeOq2LQPujidwL8hHe87UgiJ79I2nRvB8IJsd7m2hLZ6Ft4YZaGRAhd4LG
 3WuwZMLt
 ohFc5C89+TDAweG+QkqINtzz3pHBqV6G0bvN0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 4:09=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>

> > Keep in mind that is more than just metadata. There is another hidden
> > overhead of using zpool to store your full page compared to directly
> > using the page.  When the page is read, because most likely the zpool
> > back end is not at a position aligned to the page. That zpool page
> > will not be able to free immediately, those fragmented zpool will need
> > to wait for compaction to free. it.
>
> It's been awhile since I last worked on zsmalloc, but IIRC zsmalloc
> handles these pages PAGE_SIZE sized object by just handing out a full
> page. I skimmed through zsmalloc code, and it seems like for this
> size_class, each zspage just contain one base page?

Yes, they have to be full size for the page class that contains the
full size. That is exactly what I expected. What I previously
mentioned the page might be fragmented and not able to release from
zpool is wrong, now you mention it due to the full size.  That is also
why I make the other point that the ideal cut off threshold can be
less than PAGE_SIZE. e.g. after compression 95% of a full page, you
might just as well store it as uncompressed. Those 5% will waste in
the class margin anyway.

>
> (check out the logic around ZsHugePage and
> calculate_zspage_chain_size() in mm/zsmalloc.c. Confusing name, I
> know).
>
> So we won't need compaction to get rid of these buffers for
> incompressible pages, at free time. There might still be some extra
> overhead (metadata), but at least I assume we can free these pages
> easily?

Maybe, or steal them into the swap cache.

> > We might still wait to evaluate the lost/gain vs store the
> > incompressible in swap cache. Google actually has an internal patch to
> > store the incompressible pages in swap cache and move them out of the
> > LRU to another already existing list. I can clean it up a bit and send
> > it to the list for comparison. This approach will not mess with the
> > zswap LRU because the incompressible data is not moving into zswap.
> > There is no page fault to handle the incompressible pages.
>
> We can always iterate to get the best of all worlds :) One objective at a=
 time.
>
> BTW, May I ask - how/when do we move the incompressible pages out of
> the "incompressible LRU"? I believe there needs to be some sort of
> scanning mechanism to detect dirtying right?
>
> >
> > > slightly improve it for incompressible pages case by skipping the
> > > decompression.  Also, if we take this way, I think we should also nee=
d to make
> > > a good answer to the zswapped-page migrations etc.
> >
> > Yes, if we keep the store page in the zswap approach, we might have to
> > optimize inside zsmalloc to handle full page storing better.

Sure. Ack.

>
> I believe it already does - check my response above. But I can be wrong.
>

> > I slept over it a bit. Now I think we should make this a counter of
> > how many uncompressed pages count stored in zswap. Preperbelly as per
> > memcg counter.
>
> Actually, yeah I asked about this counter in a review in an earlier
> version as well, then I completely forgot about it :)

Ack.

>
>
> > I saw that you implement it as a counter in your V1. Does the zsmalloc
> > already track this information in the zspool class? Having this per
>
> Kinda sorta. If we build the kernel with CONFIG_ZSMALLOC_STAT, we can
> get the number of objects in each size_class.
>
> Each time we read, I believe we have to read every size class though.
> So it's kinda annoying. Whereas here, we can just read an atomic
> counter? :)
>

The data compressible or not is very dependent on the job. A per memcg
counter will be more useful than a global overall counter. As a
devil's advocate to challenge the per memcg incompressible counter. If
most of the data is not compressible, the per memcg overall
compression ratio, compressed size vs before compress size can reflect
that as well. Depending on how fine grain we want this data.

> > cgroup information we can evaluate how  much zswap is saving. Some
> > jobs like databases might store a lot of hash value and encrypted data
> > which is not compressible. In that case, we might just pass the whole
>
> Hmmm actually, this might be a good point. Lemme think about it a bit mor=
e.
>
> (but again, worst case scenario, we can send a follow up patch to add
> these counters).

Agree.

Thanks

Chris


Chris

