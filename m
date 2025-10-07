Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61BC7CCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 23:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75CE8E0015; Tue,  7 Oct 2025 19:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CFA8E0005; Tue,  7 Oct 2025 19:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963568E0015; Tue,  7 Oct 2025 19:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82A6D8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 19:50:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15B3B140349
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:50:09 +0000 (UTC)
X-FDA: 83972964138.20.1D89FCE
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43A1F12000B
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 23:50:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nlz21O2d;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759881007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7MaOWeH2bJtJufFc8wbY+ts/mqyyc77aroG+z0p8Ow=;
	b=79zX2HX/ugJpFDOziz/OTY+gdWM0X7HtbpHJpYd0nXKKqXMEU2yWTvwA5zXyZWBMQU8QGZ
	IWOjYBfDwYlmQ/I9G8hVrU7sK93iAoWNG+h3rQSOXM0EcmJLlF8oYapXUhygRFt8zbgzzZ
	/qTYlIlFAGCo77PW3q58OyOBfvXH6lw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Nlz21O2d;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.174 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759881007; a=rsa-sha256;
	cv=none;
	b=tIb6yQdP6GIEjlOJ3I82oBhhxtjSMavrzBzyWkPR7tEEs3cAAiIsmuKfTCHg1KOdsSbvIQ
	WLGGV98id0+LwpuWFLPAfViA5WHJ35h2cQ6BgRCHj7woNLuDzOB9y3s8CkR4wvUnEzMTZv
	HkpjFOb3oDezquDe7Anag8AcWgw4BUc=
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-42f68a0a89aso1969475ab.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 16:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759881006; x=1760485806; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D7MaOWeH2bJtJufFc8wbY+ts/mqyyc77aroG+z0p8Ow=;
        b=Nlz21O2dpVMRMOM2RFYMXX6rVxTiQWXLEMfE2TI0oKtdvRZK57lzf0kKXt8sfPGjNO
         tqsN8XeOF/z73oOPLF9NkgIKdRLsBIyOQ6R6YrVf3AJ3zlwVXiRWEpu9Ye/XP4edKfRF
         JiAOq6rDJQ59H71pGA29jFuMWxM3PFS1PBYKjpI6K4iAlpLIn0Zan2zsVLeUonAk3ZLX
         OJ06pcpbrsVOQUxvi57fYHvYIvMC79GGvtbX4r2WyffB5vTIXSzxxdcY2SNddA9MnYpi
         hobjYtVygSD1a8SEkPhSvsev6nlF8CmNS2jUxBcD87Kp+tlquYERe8DJuyuoihvhnis1
         WpvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759881006; x=1760485806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D7MaOWeH2bJtJufFc8wbY+ts/mqyyc77aroG+z0p8Ow=;
        b=aaKQBOp5ZM6U8ltjRi/kxohcAqSH6L/APkBvh7I2oVAM065p36jdxWazFiamoY80U9
         tEMNPVBFAnBd2kbQtoC6JPsXGDpSmqfcuWpYKfpKfRqd+PKibTfu6RT5H779npIxlIPM
         TtQ7UwExg//+aGOlmXtrUpeFv/hWpTFjVz0jopBGmj4FoTgDCCcjQ0t8dqH2IjmiLBfD
         boSSgdsh23uZf3XWe2gQJs6TR8+Ak3omTQe6BmzPCLKDLhdjk5BlK6tU8omcrKSCEadg
         zDps6+W4wrbKL2VqylR0E6gPfT1aTo/v8u8iHUJKTIOBQ/vJC8UIesaDPfkQbJPdTxiG
         cBHA==
X-Gm-Message-State: AOJu0YxTwfVLgWCUuaQZpr4JCaxuiJy4tIOvS3PHVP9R4qvHdREoEIbS
	Vpzd+YAf5XCacs+hoKvsC4/JVlVwEG11kz+tYphyoOykGn8Ta8YVZvm0XGvAKiNBYXHFIcVBUDp
	QirA1WAQ+NMS0GLuWblEZ5e/kNJRXtN0=
X-Gm-Gg: ASbGncvvH2Z1bfP98zMqg1U2gvolRZv+u8ia5y8HaKGStgFbG3y/QQtrtSmG79GEXR1
	zZkeOtC2/pN9aocUvOfN7IwNTtNV770S9X6Tf/cLIzfmSmqb0FHmNSiU5kpurrdmH7P4bfpsur+
	gxi7kW+VuQz3ExRBb1i3ABzGSk5ZNSzTnFyJLk0bNPxbV0b5MxR+lg5zZ5TdEHv3yjCKbtfbAPv
	gMCSjGdcUMCV4ElVRJZfQ1b66bE1Tq5yc0LedoUZHek8DLLyumGgVzMyA==
X-Google-Smtp-Source: AGHT+IFBiRrszCSdm2e4UZUihptdfJo3Fri0WVzryFNC37wuwOz3s4UYIiQEXK8bC+A9qU2S65sV1Ia3TEa3U3VJiZ0=
X-Received: by 2002:a05:6e02:1a8b:b0:411:6759:bfad with SMTP id
 e9e14a558f8ab-42f7c38ea02mr67276615ab.10.1759881006089; Tue, 07 Oct 2025
 16:50:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
 <20251007-swap-clean-after-swap-table-p1-v1-3-74860ef8ba74@tencent.com> <CAMgjq7DGy_ZmPqcqUO6s5BN381Zuee_g3KWjVqM3amLhpwE=2g@mail.gmail.com>
In-Reply-To: <CAMgjq7DGy_ZmPqcqUO6s5BN381Zuee_g3KWjVqM3amLhpwE=2g@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 7 Oct 2025 16:49:55 -0700
X-Gm-Features: AS18NWASkxLWQ0qk4dUy_pmlvoui4cUusggLIc1AOPTDWupkf8jL8C9LXWOawGA
Message-ID: <CAKEwX=PLfQCWZV7i9YP9UvcTmnHZXr635t3BX9D2uLEVr-Fnqw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm, swap: cleanup swap entry allocation parameter
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 43A1F12000B
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 1y9s9tupzcokxxb47cyeos4rdmsjjypd
X-HE-Tag: 1759881007-684357
X-HE-Meta: U2FsdGVkX1/lC/aw8cY+fGBkXtbhQKsGpZLFRTHyLp43LALqZDwk+F/KFqI7dKuspRQ2YUHhC3ZAgbdOH1XjT0LIyQZW8PeH/p9K0aYJtIjDM4LzTXyqszAvYysDvsk6aORWSqSYkJgFvSb2XbteFvWbVqLcAtOX7vbUrm63qJjG2sn8FSz7UG5zMkcfbB0GkgWKfYhRJEcGrQs/ZwClxaLN9ayZveLmD9ryptFzRlNxdUyokfY5oHsa+rh5HerEtnWoLcItTSkmrqc4/gn+RU2MUxDP3M5p4fOQUqn90QWnt8aSQzCTUev0SJzjbAHKW6DEl+gztUARTBMLDo9dcgHOrDQ/ccKYbFahh6SkdbQN9WXU1p/R2hK6fkl+LMH4KXD1PM6m4XmObWOlK2fjjAAwLA8RWUU9QtD73YTjgyvrWOeLmJuhA048/n0Wc+Fp+e2sphHRateKSEBwcj+xlqPjsAc5x78tceT/tzIAIMhTslrbbauTK2KLZZLnv0+7+XhxW9sxGvU3Lori7eju98RxTl0v9lG5+sMURUlme//SNpRRQHPGf88o6exz1s5oAQIbCD1pwpkGr1GVEw790MvJleTk0lu1tqmiNowIL5oUqL98o+UpWXONJE5fHkeJZQrhuhJftAPnPPH9x7Isto9eWStCQEtdNFCCtq3lFObtuVx4emxS+KVQiVnVu/Jf/uo2uowVPw5/T5bmPsSHKtpprRiwbfxoxlKH1Yxntr+s8aiggbresS8ycj8mfyiYzieJeoKQT4BwqezGF/Gvq17pdl67ElgBfirUmzYpm2DX2GAn9BgqB1x90R/J5EVGjjQAEJD4S/4caIlIdOC+9KJhqBmpL/xicgjvsRHzQYhwO180Pe6J1wFFx0OQOOIS00CkBFHavUBNZCAGPMsD+bMYnkTNs2KBnr7y/96Q6P68HL/uHzJ1q9nhKMrNIZws81enWkNq9k6XeN7/8Qy
 FtEYfVPw
 6UIoRbqvYDaUVsoeFTUuEJBSpxlk77c6i3S9dM4K3OQYckTQ2WGOrSeITRiw1/WWu0CL50kn0AQzC21yxBje7ZXVKfKlTvf5yS33fbPPrU/jZeUKdUwKilb8pUpO7eE+n5aJQehRfxdlUJWbcc9kEiJFzPaPCs0Usl6Clfq1HkJx/hZrmc3zfqHHw7V+IO9pz1kcDeMbkDZskCNL0HJyK+0W7MrM1tW4nKnDszc1SATO123VMfbECZJCQF/hhfrUsPnCJLjWVkdxfruvm2s6GcQbb04HnDpC5MaK6xRZeh7gTrd9+8HIx7RB9zq1vIdql1xBYDQnXoMJgeV3SFKW7GEVoBBD6bHM9Bhv1KP/SDN4MvPsPZmcsd/QV7RMo9BA6PUbNEJTbSBzN/SV3Erj/F+o0K63SfbEIT32YAz4cWvxYxjaZ75oFaHe2gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 6, 2025 at 1:08=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Tue, Oct 7, 2025 at 4:03=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > We no longer need this GFP parameter after commit 8578e0c00dcf ("mm, sw=
ap:
> > use the swap table for the swap cache and switch API"). Before that
> > commit the GFP parameter is already almost identical for all callers, s=
o
> > nothing changed by that commit. Swap table just moved the GFP to lower
> > layer and make it more defined and changes depend on atomic or sleep
> > allocation.
> >
> > Now this parameter is no longer used, just remove it. No behavior
> > change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/swap.h | 4 ++--
> >  mm/shmem.c           | 2 +-
> >  mm/swapfile.c        | 2 +-
> >  mm/vmscan.c          | 4 ++--
> >  4 files changed, 6 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/linux/swap.h b/include/linux/swap.h
> > index e818fbade1e2..a4b264817735 100644
> > --- a/include/linux/swap.h
> > +++ b/include/linux/swap.h
> > @@ -462,7 +462,7 @@ static inline long get_nr_swap_pages(void)
> >  }
> >
> >  extern void si_swapinfo(struct sysinfo *);
> > -int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask);
> > +int folio_alloc_swap(struct folio *folio);
> >  bool folio_free_swap(struct folio *folio);
> >  void put_swap_folio(struct folio *folio, swp_entry_t entry);
> >  extern swp_entry_t get_swap_page_of_type(int);
> > @@ -560,7 +560,7 @@ static inline int swp_swapcount(swp_entry_t entry)
> >         return 0;
> >  }
> >
> > -static inline int folio_alloc_swap(struct folio *folio, gfp_t gfp_mask=
)
> > +static inline int folio_alloc_swap(struct folio *folio)
> >  {
> >         return -EINVAL;
> >  }
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 45f51745ad88..63092cc0b141 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1617,7 +1617,7 @@ int shmem_writeout(struct folio *folio, struct sw=
ap_iocb **plug,
> >                 folio_mark_uptodate(folio);
> >         }
> >
> > -       if (!folio_alloc_swap(folio, __GFP_HIGH | __GFP_NOMEMALLOC | __=
GFP_NOWARN)) {
> > +       if (!folio_alloc_swap(folio)) {
> >                 bool first_swapped =3D shmem_recalc_inode(inode, 0, nr_=
pages);
> >                 int error;
> >
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 732e07c70ce9..534b21aeef5a 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -1425,7 +1425,7 @@ static bool swap_sync_discard(void)
> >   * Context: Caller needs to hold the folio lock.
> >   * Return: Whether the folio was added to the swap cache.
> >   */
> > -int folio_alloc_swap(struct folio *folio, gfp_t gfp)
> > +int folio_alloc_swap(struct folio *folio)
> >  {
> >         unsigned int order =3D folio_order(folio);
> >         unsigned int size =3D 1 << order;
>
> One trivial issue for myself, I better update the kerneldoc too...
> sorry about this:
>

LGTM, with the kerneldoc update:

Acked-by: Nhat Pham <nphamcs@gmail.com>

