Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAE72606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 21:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=o1CTBC5V
Received: by kanga.kvack.org (Postfix)
	id E75046B00EF; Tue, 10 Nov 2026 16:25:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25716B05B0; Tue, 10 Nov 2026 16:25:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13AC6B05B1; Tue, 10 Nov 2026 16:25:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1D236B00EF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:25:35 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D8EC160130
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:25:35 +0000 (UTC)
X-FDA: 85420491030.19.278B11F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4C966A000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:25:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o1CTBC5V;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794345933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0gm0TGoxut+75ypiNOEVMsTMwXFowvyRq5zMv35qXg=;
	b=XDCkKmb/bIU3Kclie/0EQc916GCMK+wHpyFDdugk1URgcPxx2+k36qHx/Sdjjwow1YyxAH
	ixQg1HVDJSEXIdqCNxXoTpYAUKIrQGU1P+oqw6l+GMhPiJCjJk/wqn4JmqcABtFW2x3N8m
	HBWM2kN1N0nAHqWceyr1ZAvhkOWfoX0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794345933;
	b=nHmwxAppc3YXdLIhvqCnBZr8y2BvKdpxbau/f1CFtplR6mK6MD7nvSw2U8+9W1oESo2oQs
	kqXz2ZdT3LkN2zIkKpJdPHsdvHoyuznEbraYTjHPPxLD1nooK6l6Ny8XVnllt/6YNe6kf+
	Fi/mi3uhvjewONO600vczvY6kiSieb8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o1CTBC5V;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB7826339A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D071F00923
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 21:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794345932;
	bh=y0gm0TGoxut+75ypiNOEVMsTMwXFowvyRq5zMv35qXg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=o1CTBC5VQhREW4/n9g1IdTTVaaakAGNQqdYf0hhDAnN04rdPDTtRV8bYQ8UPfo43T
	 5uBuMI3o2+ykYO1/ork2Q4x1AwAB9G8mtxKQ7BRfuG5Xi1HJg/auU9PtK3fHXE4p9a
	 uhQhXLShQ2boZwCPOuYHQ8dJ/tY8XPb+xeYraxeaQtgEqPotudzrSrHPgsb/OQNJUq
	 XqCetp7TDwQqbLoa2EQAwg2SkK/IX8fq5l+IdjmMK4nt0XgSTH5hm/T4Hqsm/qPGev
	 5CfRQ4ficivHYLLF8/Bt+i7LA91fQ+V2D9+D8IyqsTSxqxMNdLT/qOQbUQE7Gy98Ef
	 m05PkPSQ4gUgw==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-93f259cdc86so222403985a.3
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:25:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHfjP9lwPItSTpPnTxmTZFgMJRbi2xBR7YiTaaZ0q5xFGre+CMigV7xfNeEWh0QHfs7ZoPEjOmq3A==@kvack.org
X-Gm-Message-State: APuU4Z/u0Rhh3VR0kD1h7rZz+Kh8fq3aXS1ndkc+dlnU//aW+OfBkgkW
	CpWlHID3UAsH7us2qY0GKIXk2G7G/P/GY6iTsbxzrKQKRuf23ys/D+tseT23so/kUUGAslNNNKj
	Ae8lsBbIp4CulEcewm4ZnUuXlLjI9Al0=
X-Received: by 2002:a05:620a:1d08:b0:93e:e425:22b3 with SMTP id
 af79cd13be357-947b00d6dc9mr39116285a.82.1794345931716; Tue, 10 Nov 2026
 13:25:31 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110202025.25736-1-baohua@kernel.org> <20261110202025.25736-6-baohua@kernel.org>
 <sashiko-outbox-207742@kernel.org>
In-Reply-To: <sashiko-outbox-207742@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 05:25:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xREpXsexDfepfpM0MOX9iepBe7-fr-WuGAV=da0w2eyg@mail.gmail.com>
X-Gm-Features: AclHuK9NqIDdOADDWra6OtrXoYnbTURFVTVsaxnZwIx1C_wxpmnfiMYIQg1pKQw
Message-ID: <CAGsJ_4xREpXsexDfepfpM0MOX9iepBe7-fr-WuGAV=da0w2eyg@mail.gmail.com>
Subject: Re: [PATCH v6 05/15] mm/mglru: skip zones above reclaim_idx instead
 of rotating them
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C966A000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 8uoswrtyfzj7wkox1onn1979iftihfhp
X-Rspam-User: 
X-HE-Tag: 1794345933-503589
X-HE-Meta: U2FsdGVkX18mEwqZsztU4jtrBZBV3IPRQktHi5mVXQVKhPBK1pUcSj0PPQfgjyG9BSGwKVzIZ1tfApNiGbeerO1aVoQBlO8mb0lzLaj3ki95KYG4mJdlDPa/WzZEx2rLSfkxcDJ2Oi51MOL+GG6VTo8JzQXYxWuFDz8nBZf1fpxV4qoPSFnOI1ctqPiSVqBsS27FYVhLfXdO5S1jUxCU+8URZjWFAr5+AlJg5wcrCnZVBmnjnkxD1EH5tYnMfaJB5fWdQDZ9GhD+FkYRRainblsxuS5d5IQQeP2omKR5yf4Emza/qDSaMSPjetyd+Xf7qes/Q1+ZK3HEMSKztWOcJRmmb+cJnfo3rakB/dpfb/q9Ch/dWkjjs1NplaYGYOYKQP0YD5FdQzcGtTzZ7ftnTWLLIq5K6a6Mv8BkYETpzqwISz/E+MyZPciNV8ZwqXCU78VIExv8II8Yd7MIhhZRzC2pqmL2gZRWcSjJw/opgpyVIfM9tWx649W9sTAbuOeTLskff7jgGSTJrQadq3tuDCRia8qhkL00zSJcO4FOKqRGbGmah6rHY8WqNaupgGuSwH6I9GBCtvdK3Ky6U4CqbFi33l2Z/e+pGUsqAEIW9umh8ZwuNr9PZr/n5F+T8xsGMHUG9ilGXo/0gYsrMUa+xUo/4tyD0rsQgSUTZY46t3vhJHEF/jDEgoWnihK4qKD6ssgYKmAXueisRXXKDKXAuMtzkvQbgPExNav7rtcGAFJdVmu9lWTp8skiFuHJhw4S0hd5tSlNSC4o4cEfQoReWvWlb3VigvP44/XBanf097qqvkO57QjBmBDT1PLbSM0ZRFWMI5pjZgZTrNEuXIMQ8NYs1N8M5G/rVBrKuvRS3vThThKL+NV0bM03fTIuO6t4HXGyuCoBoqppXvEoSAUKyWifupa0cDK+BmTAMThLp5ebsrwdX9HJiV7LI28uINYE+Xay9/GFeCok47lg2U3
 r+m7h6x7
 fiqy+RGr80z4E28VmGo0Lox60rpThagk2LjNx+XXWaBikQHJ1orgP9FXlL7S5Y5KVHl264XBWHAykrc4CNFw+jhg4eqiIAbh2zlqDL5U6lb953//5rnltwocnIH1vBfBmc9Xlif/RFhEx2r7kjRSt2q1wdkKtFn75z1Q+OhUVPfF7AYl/mbrGC9ofdCec44Qb47zRRMUWP1RTbY6nue5+NJGyeXYtcA1Htea/voRmMKhXrqyaNEZlTuIpmV8074b7ETAmtUXaN9AW3jkf3pV2D+QxuyNarwtAesSWVx+HFFZYWBuesQDzdJzEErTI/I1fJ0mI37znJZAKyPb4pZcVU4o8s8Ukgc5W8x+ww8WkZGhrD82u89unb0WAsH6WNDE5+FavvnJdR1LQF2KRsYXhWWczCibzRQLdxapll5Pdhg/oeJwVjDofxYX/cFP6AwD572tCIdTN/H2Uo0ugz6vXy7HfSFQbgeDmVF97kRbTi5eZmdbSZkIkJbOmcifPXTzFFWE7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] mm: inconsistent PGSCAN stat accounting in scan_folios() [1]
> --
>
> commit 91b0962145533fb9dabae36c077150538170ace0
> Author: Kairui Song <kasong@tencent.com>
>
> mm/mglru: skip zones above reclaim_idx instead of rotating them
>
> This commit restricts scan_folios() and lruvec_populated_min_seq() to zon=
es
> up to sc->reclaim_idx rather than rotating folios in ineligible zones to =
a
> younger generation.
>
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index db0a8a3e88872..6b16706779744 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
>
> [ ... ]
> >                       list_splice(&moved, head);
> > -                     __count_zid_vm_events(PGSCAN_SKIP, zone, skipped_=
zone);
> > +                     __count_zid_vm_events(PGSCAN_SKIP, zone_idx, skip=
ped_zone);
> >                       skipped +=3D skipped_zone;
> >               }
> >
>
> [Severity: Medium]
> This problem wasn't introduced by this patch, but should scan_folios() pa=
ss
> scanned rather than isolated to mod_lruvec_state() for PGSCAN_KSWAPD and
> PGSCAN_ANON + type [1]?
>
> mm/vmscan.c:scan_folios() {
>         ...
>         item =3D PGSCAN_KSWAPD + reclaimer_offset(sc);
>         mod_lruvec_state(lruvec, item, isolated);
>         mod_lruvec_state(lruvec, PGREFILL, sorted);
>         mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
>         ...
> }
>
> Folios that are promoted via sort_folio() or skipped are counted in
> scanned, but passing isolated here omits them from the PGSCAN vmstat
> counters and underreports the scan rate compared to the classic LRU path.

If this is unrelated to the patch, could you please avoid
reporting it?

I also think this is a false positive. MGLRU uses
sort_folio() to lazily promote or protect folios, avoiding
unnecessary isolation. We don't want to count those
folios as scanned.

CLRU has no such concept, so nr_scanned is roughly equal
to the number of isolated folios, except in some special
cases, such as folio_zonenum(folio) > sc->reclaim_idx or
!sc->may_unmap && folio_mapped(folio).

>
> [1] https://sashiko.dev/#/bug/linux-ebd28175-5aad-4454-b9f3-a9510e3c4655
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.25=
736-1-baohua@kernel.org?part=3D5

Thanks,
Barry

