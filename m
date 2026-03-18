Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7962F103E160
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909EB6B018E; Wed, 18 Mar 2026 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BAE46B0190; Wed, 18 Mar 2026 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9206B0191; Wed, 18 Mar 2026 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 69DEE6B018E
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:47:07 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0BC3C1606A1
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:47:07 +0000 (UTC)
X-FDA: 84559007694.24.5721AA9
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2005514000F
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:47:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NCTN7Hmc;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773834425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXC+9ZKhTZVbYXK2Yzou2mwOrk2yBPN5TmkkaKwC8RI=;
	b=6HR3wk9bmLrtPUJ5Wp8BiwftXhBF/cYVhZPpB7bK7hDN7SR2Y2kQYk0diGrrTj9qr+X2xQ
	mqx26ElNJuQzQ2eyhF6DyiO/8/rrsgR6tZVrMfL8KgdIeyeHmS9UDSr32a9onDiqt9R4WO
	SYq96f3umf2nijN0bmEFBMG0tFb5mQ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773834425; a=rsa-sha256;
	cv=none;
	b=zd2jdpUUXpdoZGIz0DMp+Y1VJ/+3BDC5qiVfIvHuM+KzL8yOI8x05tCwz704rxOvr3NB1q
	aZGE9z/DeDp+MhhNfUoDBbl6RdfByj7pOC4qu3I9adgj6gQHRddHbAL54XSNRalYMFnXtG
	gfPZv16sIkhq9nJVSDXtaSuHMQ2hD6Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=NCTN7Hmc;
	spf=pass (imf09.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b3f91a7abso2236922f8f.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773834423; x=1774439223; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sXC+9ZKhTZVbYXK2Yzou2mwOrk2yBPN5TmkkaKwC8RI=;
        b=NCTN7Hmc6GDutjjjzKfPfAchyxOZtpaxVWPSOxcRsNqDPjsyBo9mnIsP3yoXXRJnzh
         jUJ7huOOZlBchXatZPTYNSoWE0Il4o10OHwk/SfmLT/Vgu+Nrh9da4xU6wFCRLfiawXt
         UX1eyqfVgjph6m8qhx+0/4Qp/bgSJWPinpSac8qU9LXOYpuJDuEXkMxDUBBpRsj66mdh
         3qSu9gv58Oh2WP42DBKaisIT7JLyVL6TLIZynDgE4muJq+JaNheiTHOwmLVjrzAyZDFD
         4ggAQhKFiedOvCsN8CLskEJy095WKTCY05iSon7XPLnN0AA38QPTX3fI6zbx+49V5jby
         ljkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773834423; x=1774439223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sXC+9ZKhTZVbYXK2Yzou2mwOrk2yBPN5TmkkaKwC8RI=;
        b=INSmDVR+giF02S33pD7I00V0TSSrQNwYkCanV4E8vSNSG860xKRqBQXU6MVNaGXWbx
         gZd7JLzryMoNJsb7CP4LsAc7W/jNKtcDSO+JvoG3IrxjGR1rbw2sRuOyICCDSsk7mVB6
         R8/UGhgYDTAvhpctWhtMEHA+md5og3Z9bTCGev0pujqtIM3mN8UVMwHzHz5CCo7r0wQF
         NgJ2gdhbBBvwjQiRFYQz8c5B3FurUPkLDEa9Fc/Tyxa3wRcK4Xl9H2oV06QcGzSlo0fG
         DaFHuyy5lwgF3ctbaEgB+7NVOaGR1DNYUgq6My/fHSiEsVY3MOS7dVMY45nz+osPf2ca
         q2cw==
X-Forwarded-Encrypted: i=1; AJvYcCVMVBFBvsxQ/4cOEZNMrR8noBxG4hBsPj8jB9Hg/4N6je7vE3M4dfYtnp2BkjEpmUgNhZbOSIx3Yw==@kvack.org
X-Gm-Message-State: AOJu0Yxx4wASoyWpImlSpVdBeZnxZG9tsgx6oZSW8p9+JkXhup3kK06H
	j5tg7yqMzBTEpvT5Ia1Woq/zQ11ZMNQfrC6c/3+XyCcHymGXLH3Qb7f8WllnY+bNqWQ=
X-Gm-Gg: ATEYQzyA0dPlDLJaLymvHSJKigAD9AAuxBbNkWdAHqkENGtXQk6x2QZ4d3Epa7WWnXG
	lH/DcjvQhCheHWhyxEhEXX82awNBUSjm6pVOD6FVp+7Y/GH5ZkJyvGIjdTc6F+ae6hZ+zcdX/A3
	zaxi9N98nfbT7jHjfmVadu26W1ee4BdBPCxGBE9ja+s0dyLiJWOpxFDxwLjRnAXEtyqpvQdnNEx
	GGIn2rVkpR8aqqj4kRXsFq9FYgms2+uUTf1vXa4a1byyD6iSAGA5ToAaGIuov4TKYkKnX8mHeqK
	I4ennKCg605kvo0cX5QgTb+1KTPOiBquCKI33FYI4aQ9xr1/EUfEnUasoWh3Mwu8Ma2JBy/qsNc
	kQ8ZZc3QjvOvMrS5ZDBDMIrAC15hyKGAzhvVAngOH24GF78h4KDjnp1VwPsqYjQD125nxtgvTzO
	IsCmgoUOjfxz1FCtPNgFGC/icVb7f4+E3ZSzJD
X-Received: by 2002:a05:6000:1ac6:b0:43b:4362:8ef5 with SMTP id ffacd0b85a97d-43b527cb2fdmr5198029f8f.51.1773834423360;
        Wed, 18 Mar 2026 04:47:03 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b518588a0sm11451811f8f.16.2026.03.18.04.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 04:47:02 -0700 (PDT)
Date: Wed, 18 Mar 2026 12:47:01 +0100
From: Michal Hocko <mhocko@suse.com>
To: Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, yc-core@yandex-team.ru
Subject: Re: [PATCH] mm: add memory.compact_unevictable_allowed cgroup
 attribute
Message-ID: <abqQtcNqxzxiZyf1@tiehlicka>
References: <20260317100058.2316997-1-d-tatianin@yandex-team.ru>
 <20260317121736.f73a828de2a989d1a07efea1@linux-foundation.org>
 <3db237d0-1ee8-44b7-a356-f3015173f7c2@yandex-team.ru>
 <abphjNOYaNslTA90@tiehlicka>
 <7ca9876c-f3fa-441c-9a21-ae0ee5523318@yandex-team.ru>
 <abpue_k_9mjQAP6X@tiehlicka>
 <73322279-c6f8-4319-827b-938c20c96b9b@yandex-team.ru>
 <abp3-iJbazCpygIm@tiehlicka>
 <b9ceff32-1f8f-454e-84ce-b8788b3a4952@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9ceff32-1f8f-454e-84ce-b8788b3a4952@yandex-team.ru>
X-Stat-Signature: de1s159akfwiqzemfmm8fdtuneqwothh
X-Rspam-User: 
X-Rspamd-Queue-Id: 2005514000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773834424-773263
X-HE-Meta: U2FsdGVkX19L9F4/lWULA0EaHQhCrZn1DqSfBAprJonQptK7Sx9IJfxQQJL+6AUlFAF69gzBNlKZTTOamjdhXOqRQDQjGwP949JLbuZ0A82VJd4zpgLYjlJ1b37bfm2Ga7e5Fn4mQmLkyPvzFcUD23dyq4osCYM5EFFyMX4zDMCjkabJOpha1dqBWj+wLFsQXQ+xouOFUpBpbV0ImPw4tw7vDNM9dSvwNRh/b5YkCVJloEW99ZEVO71vwFL419sK8hx56wEXJxykxhMFE46POjuYHBcgpexbufEfwjDrzd7r/bZ7ZGxteovZK6u4LqA+Rdf9vYa483VG9Oj9EwqSTD+ww8c+RU5ApDdJuHYNzgcahrvdrMPxOxFf+OuiJ5wACrLsNOIHh+SocS9rPrMeXO76iXpbj5X6fVMpFIg2WTZ+d6TgyLA9DfjSwjsbe7C1Akxv/jS23L0pS+moQiB9D/Y2y0pQv6YwULepuqZE8wVCfPlmTrQNagbaLVM8AGVwJxLZ9ohzbcZf2Uz5cz/+CDuIWjXSdcGCWTDhLVrFtTWLijKoNnpup3eurQuYRz++dE9MffejcYliBgbhrfueMeEop1kOHb4p4WMYCyaMK9ujC8xIi3glUnMApONmrZwrj12120bF4TGM9F6mX5JA/KsyCeRnVKKFCVuhn0pOgAlc7OHviKPhPsXAd0uylg3pdTiFbrqLn2llIkqg+DxSnY+La8rmh+j0dGkLn0aQPIJN1meMu09fm5ioeL4iqOB0MISPHDccrIJRurkpND5H/DDZ7yB1NUj7VJsYoDlHIFQrDRlNslYKuaBo7U7KIaXAHPitlLLA7SO8hmNStKs5glvBu5D0lvYntO88aHR97YvOH7udwRmR/T+vd90NXyubLhIwDOl3oeqR19CcDIQpVqxX7R11qoAfXIPuoAjZYjQBcUBx6X5CCHhnmpwJZuw1XNJonb1nLu3UIpbXuYr
 Ll/EhCk8
 bjMWYGP8csEo8cl8cZrfvH+c8qn+3y4kW9166msIUnAVcDCkOSLLjGdTReqK0jvOE8NDFtISxKXUfyC6oNcUJXoZzr/Jgmi/J4QCoGSgitME8J7aAUwOgHiQp99KWEj8BenATLmD211TtUm+NdQRq8r9FQrzCY/o3PAfROh5KHGHuWNknAn61xaJHYZ79TyDWsbFEPs8pj8M7/TIPktMmb+Ob1jh+FMIYs+P2oXQid3roYayGe/nJX7liopqh4gr7qte8aFNrSqJVpth8Zp492ItbVmHMBnywl5tEZ3fFZ/gAK8u2vtj5uMZDYAFKO9Bn6bjM4iLGfTGr/66UqjKPbXg6Mlp/em6bIcpMJKsDgic2R/Eu5z5YY994oVK6k1z1uNQZArLAzq5KklAwmVhrOB1+aQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 18-03-26 13:08:31, Daniil Tatianin wrote:
> 
> On 3/18/26 1:01 PM, Michal Hocko wrote:
> > On Wed 18-03-26 12:25:17, Daniil Tatianin wrote:
> > > On 3/18/26 12:20 PM, Michal Hocko wrote:
> > [...]
> > > > Shouldn't those use mlock?
> > > Absolutely, mlock is required to mark a folio as unevictable. Note that
> > > unevictable folios are still
> > > perfectly eligible for compaction. This new property makes it so a cgroup
> > > can say whether its
> > > unevictable pages should be compacted (same as the global
> > > compact_unevictable_allowed sysctl).
> > If the mlock is already used then why do we need a per memcg control as
> > well? Do we have different classes of mlocked pages some with acceptable
> > compaction while others without?

OK, I have misread the intention and this is exactly focused at mlock
rather than general protection of all memcg charged memory. Now 

> The way it works is mlock(2) only prevents pages from being evicted
> from the page cache by setting unevictable | mlocked flags on the
> page. Such pages, however, are still allowed for compaction by
> default, unless /proc/sys/vm/compact_unevictable_allowed is set to 0.
> That property essentially "promotes" ALL such (unevictable) pages to a
> new synthetic tier by making compaction skip them. The per-cgroup
> property works similarly, however, it allows the scope to be much
> smaller: from a global setting that promotes literally ALL unevictable
> (mlocked) pages to this tier, to only promoting pages belonging to the
> cgroup that has memory.compact_unevictable_allowed as 0.

This is clear but what is not really clear to me is whether this is
worth having as mlock workloads are already quite specific, the amount
of mlocked memory shouldn't really consume huge portion of the memory so
you still need to have a solid usecase where such a micro management
really is worth it. In other words why a global
compact_unevictable_allowed is not sufficient.

-- 
Michal Hocko
SUSE Labs

