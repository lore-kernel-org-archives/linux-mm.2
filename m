Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B536ECDE005
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 00:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 977CF6B0092; Wed, 24 Jun 2026 20:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 928FD6B0093; Wed, 24 Jun 2026 20:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F26C6B0095; Wed, 24 Jun 2026 20:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 586126B0092
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 20:20:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D2DBB1204F6
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:10 +0000 (UTC)
X-FDA: 84916527780.09.CCE6915
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EB3EE1C0007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAzNOd2w;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782346809;
	b=hTbChMdXgKlR+UsZWYzmbPg8Ukdqvsn5wrRVJtbKo8Z+w/6wLskonE2l1Aww7Lfqqj2dR7
	N+4u9cMCqy3XjHxZrCawW2jvBZz5PyCLnbtYuzq/PhqvZ48kw0d/TSXfmhpjpBaHEiM4/B
	YF61VKY8zT197V+T1JpZwT1go82z41k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782346809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaDTHNyPCuwGlJZtEErsLrra/tP7EwBADY16bGtkFLg=;
	b=uP+zvxA5RDWdbHl5puW0VI7e5z0XOm/6gvC4K6SlEsDhi7st3vTKPuC44mj/CO8463k9bV
	D6BCJq0PvCs+iM0Czm+AYw3KFwC8Gr2aFfFMU7Sm//HT0To/HOWQXcl5LpIz2sK222TCZS
	32uoYsInIdX2qotn6XXF9M3J6R8VkRE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DAzNOd2w;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E888E44457
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03431F00A3F
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782346807;
	bh=GaDTHNyPCuwGlJZtEErsLrra/tP7EwBADY16bGtkFLg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DAzNOd2wfalPKQKwUMPXu4+xy4pbvkHFDKb+g31Xtt380+pfYj4MIdv0guKnqhxI5
	 6vXN9SDscGePYOmAkXA4UmcC5XFaP1qGIeaWq1BvHLwScIovSzX/bnLsGAjiWUouGu
	 rdzACn220InIMJ+zuELrQM6MB83joHc0TwYxs6fbpHErLOsxWFTeJrv2WIXQkZ5jOa
	 jQ8D0dagDRoY0llwRjg3pOWa/lgZk7GHon45zEegrqDC7Y0+YtMyVcKrRmahHtBa7P
	 xwhMSgGvUbSwb3LyzAtMGrUZkUKiVi5ifisZHsecYsL9BbR0Fi2wRsX8eGJ8hxg61P
	 vebkJhycHE61w==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c0c5d170ad4so195153166b.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:20:07 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/zQEBJz9hICQRTThTQ2mz3HBpYPAFoDPEkP2qjvefePv0aNo+RPy5oKQSRbggZnoG5ffiT78neGg==@kvack.org
X-Gm-Message-State: AOJu0Yxc4P15nL5/XEIspEsLNvVxtTwnBdYtvPSKYm2SoDxQIBjpgnzO
	2GVPpw2n2kmvHsiIm7cszbX8c8YiH844ixXd2ybulqSvufdGl768DAAt8lcOCS4Gert67wk0Qfl
	VX2QUp0NkrY3ZrsQFWwxO3LxIXZGLSyI=
X-Received: by 2002:a17:907:9447:b0:c06:3880:69fb with SMTP id
 a640c23a62f3a-c1205d9708amr874266b.3.1782346806413; Wed, 24 Jun 2026 17:20:06
 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-4-nphamcs@gmail.com>
 <CAO9r8zPXk2eRbVcEMQDTCH1j-w241h189=p04FenAfKAjkkQtA@mail.gmail.com> <CAKEwX=PT_ABx51--Qv9AAZwkuH+_Wp_TeiUYVQBY=1=SCf1HJA@mail.gmail.com>
In-Reply-To: <CAKEwX=PT_ABx51--Qv9AAZwkuH+_Wp_TeiUYVQBY=1=SCf1HJA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 24 Jun 2026 17:19:53 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOEceZYXdHTYgt0mtguSxUJSN5J2Bkw-pjrahJ4cZJpZA@mail.gmail.com>
X-Gm-Features: AVVi8CfGQ0RpYqrGMUl9fqUkWLSmyqqq_AxtQ_wAezMJ7rmI0W4t3fPDgzwvfBw
Message-ID: <CAO9r8zOEceZYXdHTYgt0mtguSxUJSN5J2Bkw-pjrahJ4cZJpZA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/7] mm, swap: support physical swap as a vswap backend
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: jkhunz43g8pyoagjhx7rapkoogc4qhrn
X-Rspamd-Queue-Id: EB3EE1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782346808-292366
X-HE-Meta: U2FsdGVkX18tHJEHVsZJzCZLDRszZ8MgUoC4tv9Gl43IuSFUdif+pnpmNBIzx7HLLNsPOpnJh+OkAjjfoWXxHvoK+/rBkKzQVIKoXx9JvcukhAK8Ba+KaEykiGNRtUtkCnWY+foI8hUT6VfuJmPfV10YHM45uXprOJkbBUoJWJ7R+oJOz0ZJWLSR+GDq8mMys0rQ0BZDJHTqygWBpjr7A7MQUZPlKlVHeTciRpzczCLL8uaSNmF8vnxUVdp+dXJpU7v947rEON4Boiys+asPGzCSsccH8OPjIWR+ttPS50ltf/Uaz+F7B6k03MSc6SalIuvLu12XoB4YA7QuSCel1kjoM6/jJdg149R5EEex1JHSKde/Iduga0AAzEd13yySHTdjUqfFANQWsWMizHaj4468gQz56y2tgKURHf0Irjah7IRwqJFihnmOtU+kAA9u9xHy8l0r46/JpoNd0inOuNgr0Ggw1kfmftzAGgka/at3tw025ZP8o8CE4i1KdczAKcHu1HGN0NPTaU7U+J/VjPE92EXMP/+Q8ewUEuACtHviafpPcBK64iLj9zVotVK1Z+ksoHrn4ZjQez30/3nwnKTMuTXYDjC9Klu2OayecF9/aEogF4KexUnCuIjXY55jnC/jK1govVK9DQInXD2yeI5wgkwAtNSzBN2HEIb8ALmREgE1DeNg6GeXaMSmOGP9/UUbe5dheti/TwUtjhbWF+hbXTqJyJymtfNDa/hA9NnmrBO1a7ARBMxcgT8jdYjTiTYFzXk+Sc/VBUyHcNpHxsGFol6GGGBoVbqNp6u0lmgMM+l0op6Hs0bP9L/5bumEvxqrcb7byJNyPxnJaP4bb3YbXwDaLOOjd6F9Ol4NxLeSaR2vD3XRqevDRhngzUScwfB+Lh/B1Fok5ZE8ltp/oR/lZgSpMIEVOoTuAn1ifGjGpmpieFtf6xAMGzFvNN/FxeRgCNGMUGNVw2mZ8kd
 uZf28Nx2
 ghDLzk0r9TrLicG1NxdvL5z4wMJEWraWJRCtj3VR3cw9egveaHX4xfk2jAVbSZ7r0Sq4b02a3PmsHiPQg8DzfjaGJUfddrOLvqQk0JiijZWSxCv8UBi6RzzM2Hi/ck5nJlpu+H4Sq2fW04HgctIvUbkwFJqpwIB6LRwSqTXPwrGyLq03a/7G0hqSnujUks9DDm016lcreIQM+JA9GgIxweluwj/FUBkUV7J5AAtGkOgdUB7C7bRAnoP8zOt2mVUrMgb6qcRWkTZZkOmyBl5Y/0usOMKQq9w938AJv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > +       if (swap_is_vswap(si)) {
> > > +               if (entry != vswap_zswap_load(swpentry)) {
> > > +                       ret = -ENOMEM;
> > > +                       goto out;
> > > +               }
> > > +               /*
> > > +                * Allocate physical backing BEFORE decompress - if it fails,
> > > +                * no wasted work. folio_realloc_swap sets vtable to PHYS,
> > > +                * overwriting ZSWAP - the old entry pointer is only held
> > > +                * by the caller now.
> > > +                */
> > > +               phys = folio_realloc_swap(folio);
> > > +               if (!phys.val) {
> > > +                       ret = -ENOMEM;
> > > +                       goto out;
> > > +               }
> > > +       } else {
> > > +               tree = swap_zswap_tree(swpentry);
> > > +               if (entry != xa_load(tree, offset)) {
> > > +                       ret = -ENOMEM;
> > > +                       goto out;
> > > +               }
> >
> > There's a lot of divergence in the code (in this patch and previous
> > ones). Seems like a lot of it is to do xarray operations vs vswap
> > operations. I wonder if we can abstract these into helpers, e.g.
> > zswap_tree_store(), zswap_tree_load(), etc. Maybe the name is not the
> > best, but you get the point :)
>
> How about zswap_entry_load() and zswap_entry_store()? :)

Even better!


> > > -       xa_erase(tree, offset);
> > > +       if (!swap_is_vswap(si))
> > > +               xa_erase(tree, offset);
> >
> > Maybe this can also be abstracted into a helper, but I wonder what the
> > corresponding vswap operation would be. I think folio_realloc_swap()
> > will have already "erased" the zswap entry from vswap. Maybe have a
>
> Yup that's the right logic. We already change the backend to physical
> swap slot here, so there's no real "erase".
>
> > vswap helper that will only remove it if it's a zswap entry? We can
> > probably do a lockless check first to make it cheap?
> >
> > It's probably silly to do this, and maybe there's a better way.
> > Generally, I think the code would be easier to follow if we abstract
> > away the xarray vs. vswap stuff into helpers (where it's reasonable).
>
> I'm not entirely sure if its worth it either, yeah. Unlike load and
> store, erase seems a bit asymmetric in the sense that we only need to
> do it for non-vswap cases.

Yeah :/

Maybe just add a comment why no erase is needed for the vswap case.

