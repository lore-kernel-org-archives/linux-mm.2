Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56536C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D1FF6B0096; Tue,  7 Jul 2026 20:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AA6C6B0098; Tue,  7 Jul 2026 20:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F013F6B0099; Tue,  7 Jul 2026 20:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C165F6B0096
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:58:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23443168FD2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:58:38 +0000 (UTC)
X-FDA: 84963799116.28.E100685
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3ADE780002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:58:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JbyAjCYL;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783472316;
	b=0PfcO6bofxn5pSJJQ1iDFH4jXO72xzlIej8YXgIep1roc2T845F7BhegLSzH51XvljFB1O
	VW/8jeHM2V/TLzqHAum+LmdEV+gjKRUAqyYYHaIH4YvXx8SQJytrez6TP8n69kYmIYhP0K
	PkOoX/hI/RHIfebhvYwY5ArYCp8F89A=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JbyAjCYL;
	spf=pass (imf02.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783472316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ilqlfxB1qMrIlQQgTnVlWL8ZHvza4jm7iDlYLXPmfM=;
	b=aTZOnUMZqoDCW/Np3fdk8oaV2E7YlCcaCVzX9BjbCWqFV3o8xXLyzlLFOsKuuzBcTRQzgF
	7AuyAB0/vFpky+kxuAqLFloBPlmhz16wfeW6H/TbdwqiIixQiHB2eITf4KrPpw4epXy6Wi
	yms8cE/CGMBRinoCAtvFht+2aQrjo1w=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b00d1e7082so100854e87.1
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 17:58:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783472315; cv=none;
        d=google.com; s=arc-20260327;
        b=ou7RTYCS4U2z41qRYXIayRrb2brOU/ZTu9lD6ukUDE5A8wrv+UBUAk5SjSPMjnHKsd
         g0f8ltO1C5qiQ0Ot7liHd0LjLVvTJ2s/+dbQMnBPz8m1OuWORESwMvVUrxk8pnNQBlqS
         la7pEG7b4U3Fc9h2M1hZ2SAN1PqlG0CYrggHHRLqQroUtsJBnR5YhC/eoKcUvo/SnceY
         TvqjbF8aC3wqsiHYUd7lk3qai6jdTeQPoIsuziBa5LUJ9IUhu5CG9/UfhaKMvfM9K8Mh
         WDO9acO60ieRS23MCthnJ1nBjlHMgW22GKqdZEtSUnVLf8JskiFpSlAK1gEpaXu1Yfgs
         b+kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4ilqlfxB1qMrIlQQgTnVlWL8ZHvza4jm7iDlYLXPmfM=;
        fh=4MPpANw3LhiggrpoIA3+Foi/0+UeUagf7yoZN1atp7w=;
        b=LWaEr0mA0d/MOAh8x0bRk3pBrRLHTLfq7RTXyym8thUnds4VJyL8hppoKSXHRu+G56
         JA6C+ZWpMLZPGmAsB4Yw8NQMydH9HnIw4Hcro/Bw0tn3V0mgL2rkriRNsA4lYyAGMfhN
         D/v4oJNpWwJBVKmH6JNnzVd5ziKimD6PlKnRF9BEpTee7Vf+QSocAfwIiCiKsf2qm9Ix
         HjIy7zSqr2vxYd+hJ4aTmbsA2gaVTU1iomyzEek1aOeTIqf+ljq1oJasYMiFTBfibHRf
         r/Q4AmRI3VcWPSZecrmw7g2CyvJNvpPce5brWwFDGABS78yLGjYcaNXyIvkWWrs8drIl
         cwtA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783472315; x=1784077115; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ilqlfxB1qMrIlQQgTnVlWL8ZHvza4jm7iDlYLXPmfM=;
        b=JbyAjCYLbzF+O4Lcs1jdPz1Lw2chDIkfSTwSfTo2tSzRNyHfmeYV0wxcTtcRbfMoDF
         VCFX3QvmBmFpaLEQ2BcqA9fuVMQYvWiEYjN5/OQgFf7febtzmzlLQzepzGiTsiQRXFt6
         /keAsHpxVoM67Qv9IQJVjJBgvWZZYk6UJue8VEHW8zoItqSBHl6SZNznVKqvoEOpeUfD
         3+UlaqMi9V64remUEUuT8rIZ/7f3GUzri1KKT104CMHfRkBFMc1JzBI9khp3aKk49jZd
         DTeZpm3EarpGBbSwE6PoaA4TvQTNW+sS1ZvBrgRICIN5c3fsGwKpu5SqMWPmniuywjJL
         c2PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783472315; x=1784077115;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ilqlfxB1qMrIlQQgTnVlWL8ZHvza4jm7iDlYLXPmfM=;
        b=nyS+zXZQ3HGzBs22/6VSr1SBFPuyqunKDUkz1Zex1rOfg2g4FYvbymxzRm49Oo+tii
         fX5rVouDxe+/WWsMFUFPNfj6RQADbmIlYXRhrMuO2H79xmj2EtTxagOs8GCWUTImQDbR
         VO1xTGgjGuJTNquSIuo03ND4036fXWt0HZeZi5x4Q58X72Ao86Z+8BFYWQKx9LyfEtfj
         FgYjeaUnVFDV+644XpsQ+uWA7EVcPJUwdhUOsjD3/jRgbADbUop3+b/+qkfYNOHTe5nx
         jeRFUQHIqBMQ3iOa/FFLPWwnmaL69SA6muL5cLG/LqzogZnZU5E55yCffe2RrzGOg5MZ
         MxHQ==
X-Forwarded-Encrypted: i=1; AHgh+RoP1gA0RSsqPNau1w7g1eW0/TRB4gLb5oTdYacT4/shpHClTDppSD3Hle/sjN0HZhCuc10hcHkkPA==@kvack.org
X-Gm-Message-State: AOJu0YyDfnSgbvS7OP7JEJYFyT6xdUinn5Ptypk6QOt9eVjpp+qe20dJ
	D7KUBmXdlObE81cQfuempK0w4BN817yOHARRnxV+HYMnewkhy/igI9zf2pUNyyiYxaLn1VDnVRP
	q6IkRmqdtDY42KJptMbfUqqz3IFSSeEw=
X-Gm-Gg: AfdE7ck1uNgU2B29LrGMY92sNywHCVxQ+Uo2oqRoAYNw3DTywwVuqua4k3RnlPDMQz2
	8rxfX8ZwF2W9lSMN04KfU1oqo1JYjXbA0DSXR1HxDbKDPxYTiI+lrHrws7+SbRK/J7CGtSqSBbs
	ojCqmR5rmxdteYoGVts3p2T6y57Ckzt5smJBsmQv/q8XZocihh9c75JUJ9M0L5AejCPA28rvw4X
	psCWITHYiCL4X/w/A3G8ObXDTZklXbzxPVoVcnbFwtxWHGEcS919H69aaGDyud50mngKs8eMu8D
	5tZvX6eIKc0D4EPQQ5NDOGpOXw==
X-Received: by 2002:a05:6512:3e06:b0:5ae:b36c:81c7 with SMTP id
 2adb3069b0e04-5b01145e9a8mr71155e87.35.1783472314305; Tue, 07 Jul 2026
 17:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-0-e816812698a8@gmail.com>
 <20260708-ch-swap-series-plus-folio-lru-cleanup-v8-1-e816812698a8@gmail.com> <ak0sOv4UN1ug9-cN@casper.infradead.org>
In-Reply-To: <ak0sOv4UN1ug9-cN@casper.infradead.org>
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Wed, 8 Jul 2026 08:58:23 +0800
X-Gm-Features: AVVi8Cc5Zmf35Lf-bssS054JLk4GyeUvRR4EIUvxF7JfQqBByqntSP6BB9Yr0BQ
Message-ID: <CAJxJ_jg3JtTFFcVPp0iYf+hF+k63d_spiMumLyovA_w5UuUQyg@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] mm/swap: colocate page-cluster sysctl with swap readahead
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3ADE780002
X-Stat-Signature: yt9mmk9quggtg1ue58bdhxyn397umazx
X-HE-Tag: 1783472316-705728
X-HE-Meta: U2FsdGVkX1+BsS+ZdJYssdUkpsiCJXV8XAJCuM2Q5yr9Cr3E9gACe4z4oEuDqV78dJ/giXm2TLVAeerhlX26lOYCq5e6T/mqJo7GdBG7Sd3z+6u2f0gtmMdn1Y61ldfAnNTsmCAzSxSLjp7twdgqBVcGLy14DQfDPnKxJPIshSOdD6kY/61CjRk9OwAfJssv1Xui/acJmwHH2WBa0zjckci491s4QVMp6u4WHL3wprwbXY5UzY+8eaLlmidn1oNewI3DwGclJ7hYvLUTKuxHPlcd4M3CKpOzWUJP5LR0GjeP+a3FwAfFCoplkv+Ry7sArew3VovHBATVYDoVhThylb6oyZJPn4BpsNvARIbLcCyAIh/MpgwJEPD5Q+kNP1it8QGYDOlDwVvtUQmQz7mFkQDlL5MbHfeQ49446uCKfWRTiyHa8yndmWpkYNvNuDsyRjva9Vf/hvQlm2Df/DQxo3RREgO9a/T9W4atS7gxTUQKeZG7o0XJk4jEzeqxtOaaFrAqqrVXKnXvn+z1/EsXKrENx6fVAizgReH4RSpcEBKHryrkycr3dObEw7cDIQLctJOOHWnohD9jRHdgn6soPCPS4l6Rm45/7oMKD+hRjuRo7oqoxmsnFIl68rJtRqL9AMcizUsEVAbsTanF72Tkk4EsfNPF79xim4DsDEcn2WqmNZwRR+CVb2qPWVylC0UaJnbhysWboJCGr8teUtKlAEzNYhIfRe36jb1XCx5Fu4nSfdJZo4skdcqosJ1xhsM2Z6oEFqDWR1WNzAjL9TgUEuvTWQFBhyw9owhlkikgK7PgeWQ8+pno54FE0EordHaeYl4Sh1uH7JO4ZaV46ZHSbj1wkn5AQpG8+QrIHCR39X1CcwmF7p0r5ElyCfGmRKodVktxJYaxSZts3erqvekUAjEoEB3v0FRovdTMAG4bsgTOEe5zU4BcRzS9vinWec/kh4bAgjAaYfY+xmjGODl
 Bf4qBg4r
 GFHJLwXJ7OiYTjsCCYoJghp2tUtkX806M0YlXmHJ8I1qbuc1ItHhl1yDS32Oju6HzFG/pqsnvIdw623+GWnsHPejYLmkiqlFh/DtpxCXp0JpX7onjacFtW7q8TubhZP8bC+07yGELs3vlHrAmYQxRtIDa+c3cMz0sJHIZaay4tl0GfJstfrnCm4budWLGxDIYYKQpKvux2DhRNqx24aLm/4oGhHzHkCTCmNHQ/GXBv+SeqtMbOuKSsKYhxrpExd5Z34br536Q71r1dwUDfnMYldTOi8q9J7XJKrfq3wctfJYEJtR2DDUAyArkFhGyT0+KilQISi4EqujlswVg7pjVWsUsQ2aX46DC4DVdDNzpPKkJMpB96SUAFm1OkD0J7dHquIpoYkzcYUc6mHi4lt30YOFUgtbmPY/f2TtgNzMxWssBlFhl11FlZ3KOtbHp1djVHB722ZP0dDYYy6Fr3xIXUCvSvuJeDVbBedtuADx59/n7bm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:41=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Jul 08, 2026 at 12:11:27AM +0800, Jianyue Wu wrote:
> > +++ b/mm/swap.h
> > @@ -336,6 +334,7 @@ static inline unsigned int folio_swap_flags(struct =
folio *folio)
> >
> >  #else /* CONFIG_SWAP */
> >  struct swap_iocb;
> > +
> >  static inline struct swap_cluster_info *swap_cluster_lock(
> >       struct swap_info_struct *si, pgoff_t offset, bool irq)
> >  {
>
> This change is not related; please drop it.
>
> > @@ -985,6 +990,38 @@ struct folio *swapin_readahead(swp_entry_t entry, =
gfp_t gfp_mask,
> >       return folio;
> >  }
> >
> > +static const struct ctl_table swap_readahead_sysctl_table[] =3D {
> > +     {
> > +             .procname       =3D "page-cluster",
> > +             .data           =3D &page_cluster,
> > +             .maxlen         =3D sizeof(int),
> > +             .mode           =3D 0644,
> > +             .proc_handler   =3D proc_dointvec_minmax,
> > +             .extra1         =3D SYSCTL_ZERO,
> > +             .extra2         =3D (void *)&page_cluster_max,
> > +     }
> > +};
> > +
> > +/**
> > + * swap_readahead_setup - defaults and sysctl for swap cache readahead=
 clustering
> > + */
>
> This comment:
>  - Does not need to be kernel-doc formatted as it is static
>  - Only contains information that is obvious (at least to me).
> I would drop it entirely.
>

Hello Matthew,

Ah, yes, sorry for that, both make sense. Thanks, I'll drop the
unrelated blank line and remove the redundant comment in
the next version.

Best regards,
Jianyue

