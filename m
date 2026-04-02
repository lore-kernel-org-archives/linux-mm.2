Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87620CC6B0E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:28:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2F86B008C; Thu,  2 Apr 2026 03:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53966B0092; Thu,  2 Apr 2026 03:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91096B0095; Thu,  2 Apr 2026 03:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CD2276B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:28:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ACA313B0DF
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:57 +0000 (UTC)
X-FDA: 84612789114.26.227E421
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6732C140004
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UC0OtezJ;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UC0OtezJ;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775114935; a=rsa-sha256;
	cv=none;
	b=i9M+lrn+vLbKUcY8PsGiEWtL/nQPVLkzEH4ibMQkJ3YqraUharY2GBjUY0OIuXPsJXekaY
	0BaBkyc2JkKZhPjAVcdZ/5+UtMyc9/RgCSDUVVIR4BVehV+4uGr9Eol1E5uiNP74Yjehht
	3zCizL8mpaVLjc2lC+Ycu/ZIA3AaJ0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775114935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4mCO4oHu8hSU7UWPA1qKrOULI/J9COwYisqjUNjGifU=;
	b=vlvs5RyNvdlGo/LQzt1hOkt7rifQQor2GvRzu8MNI/IawRbj0j8zCCikFVKy4hTJbvAxjJ
	sQx+Avr0z3/orPj4ZnI6j00OqMYHvBLLeYfmm7fF4/iUAyOl0RJnzfkKEYSdKCbhfSQvWV
	p3JQvztN2fGJf9mLLUVtEdd3bwsjwAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BF58441BB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A15BC2BCB6
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775114934;
	bh=8SqcQrKrPoaqAc2XWSd5pIcLYrCmQSpuDeu9nsIhBLE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=UC0OtezJmSUHauCrYvNIGBNcYqsKQX0u6ZOT0gLDpC0yamNVqrRdbIH/JUpa6ugqG
	 RtgZV9Hb2g9KdhyffAbi2h7w+RSqQuPzwpwuQ/tLKZC1K77nbuZhY1PrZLKAa+vlYP
	 DFYPDvl8cRYZRsPxRtXDRo3k5BSmoGYpU7TTRjweqZ+yDgjmTUjVBTHHGU9AZXnN0s
	 TRQ5v7yW7VghwghS8Uar91h4HSxOOKwSwV5tjLz5cOtuyZoG0VYTrwT19H6Pfp1XKS
	 ODLttjD71R73BfNSBRAerqw18E2oltsTpwsTK0PLDTGQGFQK9C/yW9lZ190sD6pZSA
	 xfjy+9wbxsgjw==
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-50d2945e6adso9539261cf.3
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 00:28:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWprLoCX1aN/dyGlG7tiXMChY4HeHHwbiJ3bCyeNoDby6dALLl4bRKovgURry2jF+KKUNLG94wjWQ==@kvack.org
X-Gm-Message-State: AOJu0YylJVSdb3kq5AgAuOaTw+nelwe1WAAs/m1oTHLqu9vgw6wfJbAQ
	K7qZ+cCQmD131ZyTROykJoM1Ah9TElowK+j1tqMB1Z3k77dE+jcQhc0L+Bjjc4wtdUJ0Gkbhxsr
	diZdgxeAYvdRcge++lZgziV8NidVhJ24=
X-Received: by 2002:a05:622a:5590:b0:50b:3ff3:f494 with SMTP id
 d75a77b69052e-50d3bc8d6edmr96888171cf.36.1775114933529; Thu, 02 Apr 2026
 00:28:53 -0700 (PDT)
MIME-Version: 1.0
References: <CAGsJ_4wCDW=3YdPboinTNUp5qvcSR8LM+6vEhFM5q8FXHVNzHg@mail.gmail.com>
 <20260303082952.477277-1-zhanghongru@xiaomi.com>
In-Reply-To: <20260303082952.477277-1-zhanghongru@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 2 Apr 2026 15:28:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z_2ytLf8cHZ62-k5D=mKteJBrZjjuOVSqkr9+ugK+uxw@mail.gmail.com>
X-Gm-Features: AQROBzAq9EepD1wljDys_euGBeW-3GTPay0mnRZwM3qWg1x2kmnjWd9o6XnsOPc
Message-ID: <CAGsJ_4z_2ytLf8cHZ62-k5D=mKteJBrZjjuOVSqkr9+ugK+uxw@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: optimize free_area_empty() check using
 per-migratetype counts
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	axelrasmussen@google.com, david@kernel.org, hannes@cmpxchg.org, 
	jackmanb@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, mhocko@suse.com, rppt@kernel.org, 
	surenb@google.com, vbabka@suse.cz, weixugc@google.com, yuanchu@google.com, 
	zhanghongru@xiaomi.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6732C140004
X-Stat-Signature: h58u44gba3jbgd9c5o3h6h91b7uwa6ha
X-Rspam-User: 
X-HE-Tag: 1775114935-720702
X-HE-Meta: U2FsdGVkX1+742EhF63yM1f5G5oTbJE9VL1voEmPJz0R6sD8hBizORxqm9h5uDSIADOhPn7CljYbAFjynusDmvWhMMuUF/QXgDBTjAtB7nbztWAaUdoS+Lp96Pv1CfZDp4Gk60lYUuXBi8gkqzBhJC12fFkNXhelmb07ESp2Me002qN1GR9SUlYnB0QiuD8mMXa1iin0dNYmZyJKU289K0eLVQty8S4yCezUsbwPb5PvnEquXVVpsx0PPkx7daQNMmk7THx2ito9eyKBQRv4oNQ+zNxRCOmPb5NJNKf8Qj2nZjcBJuVj0ROMZTR0JUgL+8mGbq8JklhEg5AlK/KbXr/xsZfhmjoO/j1ipjkHitoEr9/BpqSTWC5nPpgALB6SZHj4a5nuc+PMF+iLRc/PvgzgsghDiT7aZN+h6CcxNHK2g8Y9UbrKbCzRwdpee1nqAhueCKisLLUQXWPMzaDYDaMvH8w4v+hGMRQQa51SQ9fiyKy+VsOHq/RDtZG5hUD/TjxPGgHfrkPrvkU1ripfq3WDvURZUeylYVzZKsP+4FWiyl/6tyi9KygGDRufoW9A9tz1k1nvWADRPcC8U4lkMyWURX44nc9IYaqAwAYEZS/2QwSeZVIF8op/QUAo6+x0i56C2J6OLTceYA9I3Rb2T04NtPP7GrtRKVQcABSFhcFaMsOYXWIwBVOf+hac1Qs9JRB6nxpLaSaP7yVjTXS795JIJGl1I1wI+UDm607a8oPsp5S5YFdTEmkTOxjyuaQpE1fyCG6gjEAvOmTWG5x2PFkVk2Ml5Vyw4kr1DlEF2YrWBA84ynzQPNWn1QLdolg8oU6B0bA7DwYsOWrB5kkH/IH2EYqSmOqSxMa6WrAPuK+iHJm/vheAWhKOONJdK1/JjZHWxB6WOkbYU3flBRAVLszDvWLCTw1VUBvLBp7Q+CQKA3vra1IWqRLru5DRzNGkAUEyyl+JddQmyK5VGgO
 y8w8/dWn
 GemlNdOK1yiFvwmHhRw7y9wlN0t+6FpxddMv2XjUSyG6g9PkK8jK9o620dFYASL9YbxDiBrjgbq3/MZY5Y3Jx7ZkJu52Hfm2gYfzRXcGS4Boh8wVrl4/s/HHd1StXZbSlD9RHYhG7IG1eRI8W+F009oYforD/5Vt1Tp7Yj5H76DSHzsNKlhluSg22VoDkDPftkVMYEtuenCCeFFVR56gUPJ1Rvvb2Mf1lOSIndNGJ3GXW7bYV0NJwDzVFQAz6SnBF2UOCTT3lN1OvAzkMKLpHyhyty8lu3l2ELHOX8Xv7QzaPOPcAu2XR4k0LiEOVsjL5FumtEMK8s3kwlR1+Qn7oQYnJK83eHDDzvlafMDjOw7o6CcylqBQm/gcWSuGV/J3lXjvPNhqt+qPc3ZQOXcub3RYXwT/SWe/nJz35p6h2xD52IvxrtlVC2gNwp18D16uSP0erqDNlTKTuXXWkxAKwqnzJMkeDV3z9Fq9qJ7c+Oyn6S3Xs/IS0ogJNfIZ3/VRP2rMk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 4:32=E2=80=AFPM Hongru Zhang <zhanghongru06@gmail.co=
m> wrote:
>
> > >
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > Use per-migratetype counts instead of list_empty() helps reduce a
> > > few cpu instructions.
> > >
> > > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > > ---
> > >  mm/internal.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 1561fc2ff5b8..7759f8fdf445 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area=
, unsigned int order,
> > >
> > >  static inline bool free_area_empty(struct free_area *area, int migra=
tetype)
> > >  {
> > > -       return list_empty(&area->free_list[migratetype]);
> > > +       return !READ_ONCE(area->mt_nr_free[migratetype]);
> >
> > I'm not quite sure about this. Since the counter is written and read mo=
re
> > frequently, cache coherence traffic may actually be higher than for the=
 list
> > head.
> >
> > I'd prefer to drop this unless there is real data showing it performs b=
etter.
>
> Under the model described in email [1], with this patch (3/3), memory all=
ocation
> performance is 0.36% better than without it.

I'm fine with the data, though my actual suggestion was to place each
mt_free_area in a separate cacheline to avoid false sharing. That one
could be separated if you see an obvious performance improvement.

For this patchset, I feel the main issue is convincing people of the value
of increasing counters in the alloc/free hotpath. As Johannes commented [1]=
,
the new counters should provide more use cases than pagetypeinfo, or as Zi
Yan commented [2], clearly demonstrate the value that userspace derives fro=
m
pagetypeinfo.

Right now, pagetypeinfo is considered a debug interface, so its implementat=
ion
is quite poor.

[1] https://lore.kernel.org/all/20251128130823.GA222920@cmpxchg.org/
[2] https://lore.kernel.org/all/760FBDE3-2724-44A6-A874-BD87F0191C57@nvidia=
.com/

>
> Detailed data:
> - https://gist.github.com/zhr250/4439523b7ca3c18f4a2d2c97b24c4965
>
> Reference:
> [1] https://lore.kernel.org/linux-mm/20260303080423.472534-1-zhanghongru@=
xiaomi.com/

Thanks
Barry

