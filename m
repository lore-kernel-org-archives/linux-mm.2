Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0505BC531CA
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 04:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C0F6B0088; Thu, 23 Jul 2026 00:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6529E6B00AF; Thu, 23 Jul 2026 00:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591616B00B2; Thu, 23 Jul 2026 00:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9836B00AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:52:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A01CCC014C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:52:36 +0000 (UTC)
X-FDA: 85018820712.27.1ED2B4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id DA79A140003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:52:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784782354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Brv9y6V5w0MiExnU3TiEoog1ZvKke2eRspfqamq76bo=;
	b=MU4hqmcsktKRfa2E4reQUbxFP5P2M8JVOHbLe6dkJBLbRNpXxExpRpAtk/ehsFfon4G1uL
	BdVuQgHLvIDUEDZ7ALzhSZWJZbtzk+PIdSjps46mf+KsSVGBrg8SB+xqk7rjnYdQvObUiu
	euW022qrYcHA0hjF6NLtPKdiboSvWGM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784782354;
	b=GMcraoJWMEbuAEcGEXTA9+dv4Q6eIhSH7lYQhaE2FVYvj5FIlmFjSegMlHqa14OHvnharp
	Sj3TTepWmbXE1X8yCuHcHYWyfERnlzEtY3dhCMeDW1VJeVykyPnuCeet05JnJR+bCTqUs2
	nDfw1LXkN9rQAV6WQYIc3W5ipuBSyZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42C03600AF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F8C71F00A3D
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 04:52:34 +0000 (UTC)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-69c7ab350e9so385225a12.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:52:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrWATr8qWdqe6mspvI+ryWTq1SEoh2rJvuPAaJQfSvwxn1kfAFrgNOlapjk1wW62ByGCDFqjDlTPw==@kvack.org
X-Gm-Message-State: AOJu0Yy/7RRovuJMwZR221ooZvk5GtT7rADYV3r61AX2ZLC906m6OwJ4
	2eWukCQM6fyjFZYVzWDdDwrMYUylVA70uSRDNzljDrEbJgwegAzgaDyLWslg6Rqxdf+fCgfcYfO
	T+QE1YUeZr5/U2kj9XONqazHRj+c9dOc=
X-Received: by 2002:a17:907:709:b0:c16:581a:2a51 with SMTP id
 a640c23a62f3a-c1c508a5af4mr68122066b.12.1784782349803; Wed, 22 Jul 2026
 21:52:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com> <amF7_GB5Rl6OJmt4@cmpxchg.org>
In-Reply-To: <amF7_GB5Rl6OJmt4@cmpxchg.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 22 Jul 2026 21:52:18 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
X-Gm-Features: AUfX_my3zrri2W3U_84gLS9FldggdRqywrOu5bVpTll4NFvwZ9XNk7xwwgEDTek
Message-ID: <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, akpm@linux-foundation.org, tj@kernel.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DA79A140003
X-Stat-Signature: dps6fx9qwoosty8fpsmsbbsfsq6pc8f5
X-HE-Tag: 1784782354-905089
X-HE-Meta: U2FsdGVkX1+D8xqm4dmyXUEo7dMQoSo7iDpONlGQih7m6ETzRuOuTRH1Fhy9ro5MYP18Fm2wGKgy/PWwUaB0TU7ltgf6B19GLpcf8OxzneWbZVJc5jZASkKgbT00q6p1gwCCmaPp15kJ19t/4X5iR0VPBWatVTvM123qhanuUjrZPiyN2kRsR5AqQxLeRN2Db6r+hkGE1JqL5H3VAtHTEHen1o8EKZG74I4T1V6wvHi3hwC352myxQkl7Lbs4SID0MHvs3MMn/Trilv73ixQwODkGniotV9wgOJx45erxBrOiVDxgkaBKJlsOEUwf615HrXbUv2sTgXx03KEXA8GmU79J3C+171TWhTVGECB3wWQTVPMaytDtpJn46TAyqwGo+I7z0FiCCEQimmxW7bP8soiNnyU8civ2A7UqwigaSyhSJYb+cpASPbiJQ/EPx1zn27v+uVPmxORKDhaY2qgB3DVvg4/np79EZxw3ZtJt/d0ajs8MkKc2lAvKzQPNxLfIa0x3XYLopwqLFMwVhEzmOwPYBnINO0RpMW+Lkf9p71s3ysUOtsLqb4Qht05cJcH4iu/alIqtuKwBUaJXwBYgsOhxV9CseL/VeEYRWbYU5OsbXJMJx66e8BE2BHihyuLKn/tb7J2LfkCESPRq+MigJbVmiCD/iNmi4A9owYF1S+3F/9gxso9N4wgwEa9RdIkNYjpsFFljdYisclBLDQscER8DXGpbEG0Oh6nPLBxhjHRC29GgAHtUQXdjmZ6e9/3dzE6AijLjbl8bEKfSIFgJpjsp4mJG5xRHU2JDyyyF3Tj8cRgqGdvROArxX/g51wPLSzwbS+1ddxR/NUMzJx45S+5H1oHZTKywvKdnSRTrd8C8ffAood8J1QyCdL5ucT51Zi730xPSss5S80nTEp0JT0Z0A+FK8gEMwwlouKqZ2rg/+RS3EZ/tjqmH0ckuHiPNvWzrZSqrMlWm4HeOhd
 6NRaIf4K
 Xu4txoomgVAETSGioP6ku0qASIAQowDODSop94r9lE9xt9dXlCx6Kaz1XI5c3ikbdDx3iT8Kn7hNjUa1QqLy0zGRH+S1yXoNO6K0ZGSKCWEcGU4fnCVzCTQqfivO2V3+ekEkCw1OSv2DlpscUS0FV3U5RTkouKVYXpK2AsPK/bdUfZQ6yKTfU/uLI+gXW0zeib1QMZOCCj16RUSkvyylhwh0uhfgR1zKDa3biEPqDGJL3m0LVaIN4dAAf3hqIBcBN3opMW31rX0vNwz5PNOPoJtRBa4vT1vTjhNOdlwHtZeyKo7/JMh8FUeZipaUMjhi0eNhsPtjMbxSgkpOZRWqU6dP5/Or0iIm5fX7+BBgBW6TyXhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 7:27=E2=80=AFPM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> > @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
> >                       goto resched;
> >               }
> >
> > -             ret =3D shrink_memcg(memcg);
> > +             ret =3D shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> >               /* drop the extra reference */
> >               mem_cgroup_put(memcg);
> >
> > @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> >       objcg =3D get_obj_cgroup_from_folio(folio);
> >       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> >               memcg =3D get_mem_cgroup_from_objcg(objcg);
> > -             if (shrink_memcg(memcg)) {
> > +             if (shrink_memcg(memcg, 1)) {
>
> Why 64 for the global limit but only 1 for the cgroup limit? That
> seems arbitrary in multiple ways.

I suggested that we keep the writeback here without batching and do
that change separately, mainly out of abundance of caution as
writeback is done synchronously here so the extra latency could be
problematic. I think we probably want to measure the performance
impact of that separately.

That being said, this path is potentially too expensive anyway due to
the flush, but I would rather we do some basic measurements before
batching here.

What do you think?

> Direct reclaim, kswapd, proactive reclaim, cgroup limit reclaim use
> SWAP_CLUSTER_MAX for the batch size near-universally. It's magic too
> to be sure, but at least you wouldn't have to make up new magic?
>
> Otherwise, the patch looks good to me.

