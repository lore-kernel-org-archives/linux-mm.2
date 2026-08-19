Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D2CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 22:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9CEF6B008C; Wed, 19 Aug 2026 18:02:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E086B0092; Wed, 19 Aug 2026 18:02:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C976B0095; Wed, 19 Aug 2026 18:02:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86B1C6B008C
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 18:02:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 785DB120660
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:02:02 +0000 (UTC)
X-FDA: 85119392484.07.30F6A5E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C9EB180004
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:02:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1Mw2L0m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787176920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKjxAGc7CF63avf73E5SrR0usloMlm5s7Y37wLgMAAU=;
	b=EPHBraURFQlJODcYXxw9u/9u2Y8gbGV99DN/6yOkzGH22OCYlhyZWK3s5MtYNNClu+SzUU
	FjpexY37Z6IsktdHX0Y7P/3ZYFjKnkUl64jqX1agKabSPXND0FuA29z583abXbShZEBuZ/
	ykYrTudZtnZk1dFrEPLckEJxPyei1bQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G1Mw2L0m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787176920;
	b=fORIfBV6t2Osv8boW+OvUh+egKmx5rfzmt73LtlBigddejfF0lkq2EKKL2QgL0illiuPYB
	tZkOJrsm4RUL4Mz/5yqIvSZdT/xVHB0FHxDNS3gR3A9H4ucGxX2aoOs/1+SupqLKTrC9A1
	GJtw6RViPAOwGGnD3W1UvSOs04MHGhI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 884AE43F49
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:01:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 618D41F00ACA
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787176919;
	bh=oKjxAGc7CF63avf73E5SrR0usloMlm5s7Y37wLgMAAU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=G1Mw2L0mIBkzsWeD7c9ra8pKCUyWLO6bxgXd1vapUifjHi1SMXt4YlHZYz9v/Xk47
	 oCSdtDljuzZUjQvdns/MkPbSV66Rk+7qDRV5Pana1ol7fk35N416iZw6fMrLaK1ra1
	 TR6gnX0EwgZ5lzsaFIm9TUsvPn8CzBuI6GIv0LvdKcDwJNPrlfhKlegfjo2NE6L/ZW
	 ZWfKcf/a0pQZ465rD1R9KweqF2BaN9wOZLkKeD8/7Bbp+d0nZ411XxRHmuO1ZJLHoz
	 z2cm8R18ZJWGmoDQRo7hqCqN/EZ7UZQfLQOZmkY2zI6J7F81IbKVvjA+vjXzAu6AtE
	 SmXEiAA9TW88g==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e512a9a6bso88311185a.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 15:01:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoGJDOEP+jd3NK7/yG1S1qBGG8h6Fwux1PpbU5i3Rm8cJtg0BSs+YBImYWi2ywCgQJ3uhQy2vv5UQ==@kvack.org
X-Gm-Message-State: AOJu0YzrLHDsxo9qb2UQDioGCFA/eKcCh1lTbVPtYT70w6f9txkXomQ9
	PSLPUAGAwsE3D6DcomPbtxJb4G//eXMEn3ibNxoXFVtFXUQomIX4xcnqXrbEP1hoo7usWOuTQo8
	myxDb6+Df3evb+XM5yUVZBwMjoj3Yj/Y=
X-Received: by 2002:a05:620a:2683:b0:915:fb92:d599 with SMTP id
 af79cd13be357-9371e309098mr801633685a.25.1787176918711; Wed, 19 Aug 2026
 15:01:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1787056208.git.zhuhui@kylinos.cn> <4b4d4e3065e36f1b60dd69e8276cb92082f393a6.1787056208.git.zhuhui@kylinos.cn>
 <CAGsJ_4xKM1R95TEpKoicGYQB8Qafez6hKJF=Z98A_2j43X5GAA@mail.gmail.com>
 <39871dbf-25e3-4518-9942-a733dbb6acf5@linux.alibaba.com> <CAMgjq7D0KMdg0fKMx=i90b=F-ZEW8+UziiE12fCGxKOtiMn1Ww@mail.gmail.com>
In-Reply-To: <CAMgjq7D0KMdg0fKMx=i90b=F-ZEW8+UziiE12fCGxKOtiMn1Ww@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 06:01:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z4_+T3x0vHdKzZTjA_ewB2KTvLiOwQdrv6uSJ2N5aP-A@mail.gmail.com>
X-Gm-Features: AcwNN1UR_JrJi0IeO1OyPeBhFTeBIHTBKdMnnPsTyWogCQHl4Ozef7xIMoTJOHQ
Message-ID: <CAGsJ_4z4_+T3x0vHdKzZTjA_ewB2KTvLiOwQdrv6uSJ2N5aP-A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v3 2/2] mm/vmscan: apply too_many_isolated()
 throttling to MGLRU eviction
To: Kairui Song <ryncsn@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: w6bbi46dr8qsazw587bmb5qk7upagz5f
X-Rspamd-Queue-Id: 6C9EB180004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787176920-719653
X-HE-Meta: U2FsdGVkX18reuULCSLS1c52MEQ20DOyDgE0PRzZ8ZPsMn2G44Vse1h5WAaiIwcNJhuiMBX3iZ2Ht5QSclM7qwlXdhU7s5OFvnBPzm/dZW1E4nj8WYsJK+zDPnQoXwkU+1Ux1HZxlHJ1jUrd/7HGcw56SmjgP9Z8xpL7cwA7FEVns/gp/z8qfNlhS8UzVRL2CBwA4DrbXhxH16cv/KcNo8O29ebFtTiqJ6oCGtibICWjAEeTLfr5banI3mj7cKmmD274tVtOd/QE1FTOY7j+SIp5lzGpwT39iawP/dSYNTB55GTgSHGKmIxGE2bkHtIKASLKAP5h7Ss1qnJyM/3y0tDodq+dW6xQrTpA4dUVbu8ryGTYwyf9RvnFGqweyUb2UANdyTrJjNWjL1lbeJkr+0O62SdlSqCx6gkPsTbVrT4C+Dmi1TWTP0PmijpyOZ1EutoaV2+8Uug66HCDFSBuhiKbfEC/0TOgKBhrrVsN00QnQfMXDVx29SzP/TZroAY0UuHoYIKOWPUQA1OVfiU9uvIXAmu+RXKYj7RLfSGGkblHYPJMsrNk53xzfFf9rNTOCFIanFvtS1z6woHRgfVNpCKuoXat3hXD/EMqWeuKC3xr40CV7eCPjYeHh4XvLwLhlMijcn1TdcCNfFaPvlM0bgzl+fuiXtNvLaW//on93VQrGyirkp1tgWyWbFgSN8AtRDfnIm11GMmKvRhgMidWaQCjOr0c+9rnkiKIR1R+N92ZpZf42CFPy/quxr5cKMZOfB/GK4lHGo96NWiqr+sroeHeQv9By6st8r8dIXbvdOo+5RBtnPWDnHVSgYfIUJldCkC95k9Mg931WGrIVriXtnA7Gb+QNo2jrulaQQlsFCo54r+fBpnK5Z4FGxxRCvu4IpqvCci/HFXcCp7sFbu+PllKWF+7wmRHRact9JlBmsgN+vgf+8aOlNIQpn33KRfT0N2GfjDpHZ+jlBYPewX
 PCSbRWoF
 tv9pOber9IrNscY9j7szyMBZxJ3HiGX5t2VRF05X4bMT4EDwcaUb1T5/kpecLbVyEded6/X869B3BUS1NpZj3pDN/2qtaG+s2IX1GtxLG1pQTe40YvYnPiw+iCx2SXn/VOo1K3tH/a++Ixmev7uT1vawCUzf7ix9OBAvee2VQAjwbu0KoGMjW9LCflz15pchdxYEBoMCsQe63pBjUSaM4ttCK5fO3VC+wz4k2E7R0kP+34Y0WmLwafIlghznji46905thKFXK30RDCDxp6gd2TRQoZsA2+QtKZx4wG4iB75gw81iWthPn+nxLBK6N6rS2+xo9mHEA7m/GwJGEs846FGXyQCylis3UHpp+kG4tIXD+1WOxKckmjGF7BlftMS5beXiHHKAFC+tDYEtmXfR22KVzyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 5:30=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Aug 19, 2026 at 10:15=E2=80=AFAM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> > On 8/19/26 6:06 AM, Barry Song wrote:
> > > On Tue, Aug 18, 2026 at 8:49=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> w=
rote:
> > >>
> > >> From: Hui Zhu <zhuhui@kylinos.cn>
> > >>
> > >> The legacy path throttles direct reclaim in shrink_inactive_list()
> > >> when too many isolated folios pile up, but MGLRU's evict_folios()
> > >> isolates folios without this check, which can lead to unnecessary
> > >> swapping, thrashing and OOM.
> > >>
> > >> With the NR_ISOLATED counters now updated in evict_folios(), extract
> > >> the throttling loop from shrink_inactive_list() into
> > >> throttle_is_throttled() and reuse it in evict_folios(). Since the
> > >> type to isolate is unknown until isolation and isolate_folios() may
> > >> fall back to the other type, check all evictable types with
> > >> for_each_evictable_type() and throttle if any of them has too many
> > >> isolated folios.
> > >>
> > >
> > > I feel this is unlikely to work. MGLRU behaves quite differently from=
 the
> > > active/inactive LRU, and its `NR_INACTIVE_FILE` accounting is also ve=
ry
> > > different.
> > >
> > > With the active/inactive LRU, shrink_inactive_list() ensures that we
> > > always have an inactive list with pages available for reclaim. With M=
GLRU,
> > > however, a generation can legitimately point to an empty list, so thi=
s
> > > assumption does not hold.
> > >
> > > try_to_inc_min_seq:
> > >
> > >          /* see the comment on lru_gen_folio */
> > >          if (swappiness && swappiness <=3D MAX_SWAPPINESS) {
> > >                  unsigned long seq =3D lrugen->max_seq - MIN_NR_GENS;
> > >
> > >                  if (min_seq[LRU_GEN_ANON] > seq && min_seq[LRU_GEN_F=
ILE] < seq)
> > >                          min_seq[LRU_GEN_ANON] =3D seq;
> > >                  else if (min_seq[LRU_GEN_FILE] > seq &&
> > > min_seq[LRU_GEN_ANON] < seq)
> > >                          min_seq[LRU_GEN_FILE] =3D seq;
> > >          }
> > >
> > > At that point, we have no inactive pages for the type, so the
> > > throttle will take effect when the following condition is true:
> > >
> > > too_many =3D isolated > inactive;
> > >
> > > With MGLRU, however, we can still fall back to the other type even
> > > when there are no inactive pages for the current type.
>
> Hi All, that's a very insightful concern.
>
> But on a higher level, you can fall back to the other type regardless
> of the LRU? That's not something limited to MGLRU I think? I mean
> throttling on one type seems like a good idea if the other type is
> very reclaimable.

I don't know how to throttle a type, since the throttle applies to a
thread rather than a type. Once the thread goes to sleep, it has no way
to fall back to the other type until it wakes up again.

>
> >
> > Yes, that's a valid concern. So I think we can check the isolation of
> > both types for MGLRU to avoid this case:
>
> ...
>
> >
> > The typical 'isolated > inactive' case is that we've tried our best wit=
h
> > aging, but cold pages production can't keep up with isolation speed,
> > especially under concurrent reclaim from multiple processes. In this
> > case, I think throttling is reasonable.
>
> Just an idea... How about we simplify this: just check the isolated vs
> total memory size? At least for MGLRU. MGLRU maintains NR_INACTIVE_*
> only as a compatibility shim for reporting meminfo, so it does not
> track the immediately reclaimable set the way the active/inactive LRU
> does, so the inactive value is a poor trigger for MGLRU: Aging moves
> the folios in batches so anonymous reading can be very jumpy. For file
> folios, PID can only promote unmapped page cache to the second oldest
> generation, meaning most file folios are considered inactive. This has
> been causing trouble for our dashboards for a long time and I think we
> can fix this by using the tier number intead of gen number as the
> inactive / active reading, that 's a different topic though.
>
> And in fact I don't quite get why classical LRU only compares that
> isolated number to the inactive count only. The reclamer can move
> active folios to the inactive part anytime, so throttling when we are
> low on inactive doesn't always seem like a good idea?
>
> I remember this was discussed sometime ago that in the long term we
> might better throttle it in a different way, it was once mentioned by
> Shakeel:
> https://lore.kernel.org/linux-mm/ahncWUAJlPZhNGr8@linux.dev/
>
> So perhaps we can throttle MGLRU more gently? e.g. just compare to the
> total number / MIN_NR_GENS, which means half of the memory is isolated
> for MGLRU? This doesn't look too pretty but I think it's better than
> using the inactive count for MGLRU. And if we introduce some
> gen-balance-based aging (whether that is a good idea is also another
> topic), the ideal goal of MGLRU will be evenly ditribute folios among
> gens so the current inactive reading will always target half of the
> total memory.

Yep, I think we can probably find a way:

* Throttle if the total number of isolated file and anon folios is too
high compared with their combined totals.
* Throttle if both file and anon have too many isolated folios compared
with their respective totals.

Either approach sounds good to me. Also I agree that inactive
accounting is really unreliable in MGLRU.

>
> Another thing btw is that the function name throttle_is_throttled
> reads a bit strange to me :)

Best Regards
Barry

