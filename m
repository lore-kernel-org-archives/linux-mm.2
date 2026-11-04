Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8835606EEBB
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xlwy7Q/r
Received: by kanga.kvack.org (Postfix)
	id EB1326B05B6; Wed,  4 Nov 2026 13:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88B66B05B8; Wed,  4 Nov 2026 13:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9E3E6B05BB; Wed,  4 Nov 2026 13:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3F826B05B6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:06:51 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 559F8160818
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:06:51 +0000 (UTC)
X-FDA: 85398217422.13.CACDA87
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 445F91C0004
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:06:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Xlwy7Q/r";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrmLv1n+5oNqFmytsUE4u53hMRh1aIZieVEIUAVdMCk=;
	b=Rg4tIVJ76G4fApYlRolCG7Uu8NhqvgzvpdMZaEG8xeZyAjp+9SVJaBUHMhNd/7eEunuj7x
	wRg3oQ3tsGYLeheMl81zbL37S5E5EImu3k+Sq+h30n0dwMfEJmmBeAS7xbSKtAcsTrbXJf
	whHrcfIy/ZVENF0TvyD7TeoDCE9kGOU=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="Xlwy7Q/r";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793815609;
	b=gZqFUL1GJ/HnbBQXtQgC7ZTG5KZeY26jRBpBhA7I6CtjhLRU7xIfGbCwvg2uw/e60jGshr
	zUxhkvntULgfetwY/Z3gJ6bUlYAVGeWkXxzGglIzrtyt6dgV3sSmTKJ9FOeL47KcSjNusd
	wl2R4J88gKqcV2RUJBC9DioVF6XMI+c=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so7343695e9.0
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:06:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793815608; cv=none;
        d=google.com; s=arc-20260327;
        b=LqCKhbJAJmBirZi6K/EsrtZsH8CgwE4HnkwaI6M6pRam8YHmcznxV7AeK+2g6NhCBP
         OL5uRv+MFBaFV6N7C7MZayRjzX841PKlCV5L4uW33xcOYdoF8wvrWIhaxWHaCev1g4D0
         gSuTyrp2Nrfl16/41kCRbNO1k07tr6iGcgeHnVYxaM7LjKaMf4cbgsAS0NbvRquAvX/G
         pyqZrF4o1ucnu6zVojKuTSeFuV0knmR2s68tIcuUormaXnDQoPfzO5hch2oEIxWQhEd7
         7KiG7zxqmZ4lwo2UQtbYVw6UKKlIiO0Djp6sWajHRn9YK72ywJsCaYE85+Ux+7L2zhH0
         J+oQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrmLv1n+5oNqFmytsUE4u53hMRh1aIZieVEIUAVdMCk=;
        fh=i4EgN9wpq6VUYCt87xcZAR1GGu+Vcd9WwpWFO9vlmyk=;
        b=O5KacsAeTKirFinr4qHKOORzEzqZ38JaPEB6lV7MWoORb8AXh0jIDlZ3Wiqa5YFV1o
         Go72EG/hdJa4P0Af35rWc4icls+e6qiBRHScPzUuZ2P1FAcKMvkQl0cs7y67bFQyU7it
         ofjiYjuFbCD+buyrsQcMB+GXdnuRy4rVgq2dVuBMyg+jxUmYnT9yF4XF0c+bXIgfu70w
         KDtmGlGtIRvutYPoKnlKGKka3KYc5E487zuMFAAmUx6c9N0Fbd2o80SZJatb4+sfgzsP
         RPlyXPQxN/bB2p3dp47kJzrtXrTAPqsA3gVAoH/OAiZN5rLRPkyb89ufuL95ausydEtg
         uTZg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793815608; x=1794420408; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hrmLv1n+5oNqFmytsUE4u53hMRh1aIZieVEIUAVdMCk=;
        b=Xlwy7Q/rHzW5OLr5Z00WDLtmlNGLd2cpfmW2vzqSZO/PFG5q805k19zv7rxyOJ9cDK
         tRYV6mHJgqeOPO6ebYFF3kf6VFi5GCT0m/RoFLO4z0Ga4GRsFthKXLuj1pQTwjh3TqSM
         k6WrHaMC/x2wH02ZUstisDl/b++1s1GtTvOMdId9GzhzO6Ft64ndFBYsmj9GeASS3/6X
         YAxhPjLttnrGh12pNOq4G3Wxf0y7skra7UShq2Gjs3MOUIeHltR07j2JWzBUSimC0lL7
         R6ETKBS9nocOEXCnm91dSqoevzlr2vQKXIZLO/TVXYM6EAVmlnGATCe5R8iGLvfg6k+D
         v88Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815608; x=1794420408;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hrmLv1n+5oNqFmytsUE4u53hMRh1aIZieVEIUAVdMCk=;
        b=yyZszKOO/uiUMntxmN7B5KLXjc3jwFUQLW66ThCSoz0k9Zd5jIQZTullQgJau5Wh/g
         LncLA6QGoW2fakphWXfXatzu/TzCEJugK5hdpOycrpyTRouAb6EtqKygnWkuNNBKJXfg
         YmqF7wnP3CqUpXpVyOkiL4gmGnmG0rfmGgnUAeJxp4bXeuS3EG8pSrxjN8XxxiCZye6S
         EnfubJdg/W/GgVpCiLp/xt2XJrwBNi6qxYJCC+0ZUNCXJ2K6Aqoq1D5HC3umiStAzvBt
         nt6fAS6ko2l4Kn8VlZY1acvP1C0Ma2c9JvM6VoZXW8uTwqyIhdxwyI7/4UNTfqmadbTD
         inkg==
X-Forwarded-Encrypted: i=1; AKwUvBwH3nC9pc0Pt6xrRv7jQbTXUH03CkVtxZnPZrK9wYx71Z36LEgYpe+aJAFphsXegGhYr1o0lSLTuw==@kvack.org
X-Gm-Message-State: APuU4Z8kPOlRlUqC1FJYuEyDEIo7yQMwsKg5ZaxbBHcsfC+vZ9Nm/Wej
	fh0LbBPGcYEFIzht0EOxa5o6WzuQv0fPXKPJCZeuqkVfDh/7WTdPwughV2an6Qomwi+MzBWNQdj
	St3SVbfVBqS4xvlBeQOERNjX2NJ9BL0w=
X-Gm-Gg: AYBFou2TGMYKaBRzn82lObMd3704pnk9/0uxtkI018DP37f127G3x9ph9RB9CAGZm1r
	X4PeSL0bHRIrMgvsaTXMulueFca43OTgmSO0e4og8H/zNX+zfRTYzV5u/hbade7w+ADWNvmkwyY
	QWPmt1mhEh7KO1W7L2GqueKN1GY1DfNWxQ0+ytdvDPBQTU6h7Fvd20GxThM1SAY2iW2WQ1h2w41
	bHTLZMqMNpDvDNphOUPF5dQEqb+4RvskOWK8sGywYw6Zo89CtMxxtJevbymLEl7rV4NusTIOzuY
	Bb+pGyTB3Cb+LghLM4Mvaq2Krpya5hvPcn88XuLH7Ffw6tN9zlYMAWBMyhQJ3xme57ZEFUieqvX
	scYtNkPv4YWgNuubxn0kozsLcOM8GGTqazjTm5KNUzilyRtYhm6P1tsVnOgqFe9OiIBnl1zGXrT
	QnrTn1vaB6kAHJ8QTyeSvU7mTqWVdWDXQD0n+N1VeVMAPsnc1f+Y5Y
X-Received: by 2002:a05:600c:4e13:b0:49c:d019:70c5 with SMTP id
 5b1f17b1804b1-4ac1228978cmr355749615e9.0.1793815607361; Wed, 04 Nov 2026
 10:06:47 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1786003779.git.xueyuan.chen@vivo.com> <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com> <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKjuiRxQwtsZF_0@google.com> <auKlTdFbOZmAuheo@google.com>
In-Reply-To: <auKlTdFbOZmAuheo@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 4 Nov 2026 11:06:35 -0700
X-Gm-Features: AclHuK8O0RVfLvv4wNWjy3TZpDm45BdNUGxoFz9O-SyvP0_8LTONh-wQ2RREB4U
Message-ID: <CAKEwX=Ox9S-hinxCQTPDiJg6ta4yjsHKLQeN079+y_A0-xPt+Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction budget-aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen@vivo.com>, Barry Song <baohua@kernel.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, xueyuan.chen21@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 445F91C0004
X-Stat-Signature: 3tqtw7tfwnpuphj5ox4u6yuyfzrnpcr8
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793815609-183189
X-HE-Meta: U2FsdGVkX19yXxeeX3987OSOADiJFNAn07xsHDlw31G82qZKrNe1LIzQGxYF6UTmzk5Y/0piC8tOJg6Eoiy7rVHcSQw/f/gzP69tulJ8kYf7QBnZWuo6WfGpmzfUdQLQwbl61HGla5m/dNtmumdbGsCNqm0CxOnoqVvqSTa5eRyjg6mfk1WG3T7qwbLDjpPKr/maX6gCAFWFhDgf+TeSQ2ky2ol2ditM7XHeHJ2GgTaixiRUNxFlimkSkjLeuNeQ1SDlVIZwSgI64JrNvoSZNw8J2nc2aNZQQL++lfvwXIbp7CI5pvFsOyCPamAfRjOedTlBMO/+X6i0jy3hHecCpoGtASKXwzdpI89bPWiCNN3Y9KlhqANTnhLK1TtUGtu+OnA8+MBzqiv+YStqEY9oFT4eTiky47Um8LTjz+YrH8sTpxNdVFyiYqnytm3wmh9Vk7ElLlEkv5Y6YMiVVTFd+M7U1FLCWYvauMUeuPT1V0XMUfG9TxZD/CI8DMOeMIyLhwVBcuw/P7QFPWsE/A280L0zc7vnQ79ITTs4vTCsYtRF1DbrGldCDedHz2Z8llcv6EO12kpn65+NNSIF87L2kOcPPcoKN0P0O2aBL508hdUthBAhj40ZJYg4iL7UnP3uM2pN083OQVb9/kjRWUF4TIG37fscl/Q1UOyJMqjCmZ63wXCpW+hjt4z07cHev6/GU0tvcb+qFOJBRx0tsjbL72lJQfn+Si9V8jTKGY+PUP7Xx3Wla4j+7VDMoZFe/loohfAGveF87xC5F2QMATt5lgHXm7jNkSKjWIaMJrpiHI4rT1uLnhklvmIZ1WErCEsOMGPLg6SyBIDXIyvVxBfMvsjy5xU6gVRKA0QZcHuj0i/ikc8HryFgL39qjcS3lCHOt44G5gGRa7QYkmYVr9fm9R/qcafb6k/cg10vj8dkcgSD/fpBKe0/uOe6FSDog9jM4VxqUhJHOnvJ/9tnHab
 JpB/hTkk
 3XDe0aWGvSPkiYbG0n8SuJDK9QgjacYr7itA5rlYwJEPpOlzUHs4PcHVU4PCzW3fXSR6spedOMqLJfztaDnKDi7JJhI3gTeM0ruGbrjz+Ki0xY6c83hA42A+T2LGNNAqFP82yewipP+i3fI0RePWdlhJ9FNZmFR03nahsT0LxB65iee/A7/p2Epyq1WeOyPH6LlVHPikK+XvXSQ94tgrd5Lyo39pf+WV9doWyGmhEYCfQwiLCIZi/dzeYQCMHdauuC0T+0oylK1cGqzT5HMIFWBKKMje5JGvxgWPaP7WOs5YDnGSYrs2hc55H/ACXZlhj5cgqPbpzbEmYbcW90xa8lPxtbBrTeyrxjImV0kkEvBjjbb+HhmA4F9rNfwtyqEWn5Ut2dblbRoqv3I38CqA/5tO4uD58ycOxlkbk5TCar6yVTjNRTZvVLi41l82AdQmeewb8WQ1DGtfM2w1MV9G37FIC0vNDe0ctQAI5JUckVJPikqFFdjKzlEDx8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 6:48=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> On (26/10/29 10:43), Sergey Senozhatsky wrote:
> [..]
> > > Hmm we'd need to collect more data in our workloads to determine, but
> > > if we can compute compactable ratio (freeable_pages / total_pages) on
> > > a per size class basis, can we just skip the size class whose ratio i=
s
> > > too bad? Would that at least cut down on the vast majority of
> > > fruitless memcpys and lock acquisitions etc?
> > >
> > > I'm always a bit hesitant to over-rely on userspace, especially when
> > > kernel has information to do something smart about it. It might not
> > > react in time, and many proactive reclaiming schemes back off under
> > > heavy memory pressure.
> >
> > Apologies for the delay.
> >
> > The thing about shrinker compaction is that it's sort of on the
> > wrong end.  It doesn't trigger compaction when memory is plentiful,
> > no matter the internal fragmentation rate, and start firing compaction
> > scans when memory pressure hits.  The problem with this is that, now
> > compaction moves objects (if can compact zspages) and releases empty
> > zspages, in parallel with potentially heavy swapping out activities,
> > which can simply allocate those released pages back.  Which seems like
> > a useless exercise and needless memcpy-s.  So I was thinking about
> > either putting it under config or just removing it (this might be a
> > harder decision).

Hmmm I suppose if the new objects belong to the fragmented size class,
then there is no point in doing defragmentation, because the new
objects will fill the holes.

If they are of different size classes though it's a win to free these
fragmented zspages and reallocate them to the size classes of the
incoming objects right?

I can't really say which is more likely without data... And it might
be workload/reclaim-behavior dependent...

(The size class check for fragmentation level to skip internal
compaction is nice here because is agnostic to distribution and
trigger points. We should land that regardless).

>
> In embedded (android/bookOS/etc.) there is a daemon, that triggers
> various zram activities.  We can wire in pool-compaction (once under
> memory pressure), which is a zram sysfs device attribute, instead
> of pondering zsmalloc with scan callbacks.

Internally we use senpai, which trigger memory reclaim when there is
no memory pressure, to reclaim cold data (which in turns trigger
zsmalloc compaction).

It still does both zswapping and zsmalloc compaction in the same
round-ish though.

