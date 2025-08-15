Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9BECA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 15:04:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAE2190024D; Fri, 15 Aug 2025 11:04:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F1790024B; Fri, 15 Aug 2025 11:04:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B84AF90024D; Fri, 15 Aug 2025 11:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A49D990024B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 11:04:37 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29BF9B6F27
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:04:37 +0000 (UTC)
X-FDA: 83779313394.27.B726ADA
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3A5ABA0012
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 15:04:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WyS49w2N;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755270275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gp94pLZripqg6DXdOBsKXQLYLF6BHz1zUMlVq+K/gJM=;
	b=QfEqurNe5If9Ck5XpNG9+UgTMYClTssBbxCKf6XBQ0RDJCEpMy3JOoVuxggsNbjviPugT0
	6NppK0gwQqM3UaLoS31xQcDBh+P7W3z0GXCUt314c64WDYQytyASeDH3IkAZ6Y3irTmbYZ
	5EUG5dQMWTpsQS8x0Zv5uv8JX2dpGdY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WyS49w2N;
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755270275; a=rsa-sha256;
	cv=none;
	b=UJyJQffjabiuijpI9Dg6Ltl1KRdkzPnYb7hGtpepULOiqLVx7X31rSsI7KWvdb/BrU05Wk
	dl6BITbXUrPQV39dvDYJ3jnFo+D+C/4/eOMPiqKf2huJcucVDkRGu1SoHhfSVX99RiZmm4
	R2ox8W1JQ3rck0vaCEvtf/sP6+gegK0=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-55ce526a25eso2139871e87.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 08:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755270273; x=1755875073; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp94pLZripqg6DXdOBsKXQLYLF6BHz1zUMlVq+K/gJM=;
        b=WyS49w2NTqoIO+ZrUPRJ2gDhiONbkDjZC7oPzkl3IHb9gnwp785Lu8VL7g14gqzIEL
         qJsqCQHg5FOw+GPSAmMbZNgr9W0T/wo84x2O10YWTI/MqZcJ9/KV4K+eVQtxbwNR1QtW
         hqVcs3uLqcDN/AILrpmPEHaB+icR0AtS23Wd6iVW4Omgyne9y5AkaQYIRK1wVV/9x9To
         L2y0xZqvGxbj/5QPet999hderqDaIk+fpSSpT7mXNvghimo/hAE/EcufRcAPX5Im1vxP
         YbGzEDLB5MrEh6D1eo6lT2ZbzqbUrmssB+zjeMRY56lq/ajtP13xv7TvakZ520UuiXse
         Sp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755270273; x=1755875073;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gp94pLZripqg6DXdOBsKXQLYLF6BHz1zUMlVq+K/gJM=;
        b=do1kv+xRas72tT8PG/XXH6Z17ZU4a+xlwXWVMSIBPHs9GM9ocqhtJr0l5j46ZiC8QW
         AFW6hDG6xJ8Gyjg33ykiPge/Dp/u2Rr46lN1oLoaih8y1JzrolG9SHyw9XncACtvP3qZ
         A3+Z2OzYOYNeQJL2K1TaHusG9OQoG+oEFqmkvgZJHClWCC7vGF6JG5Z5R5s3Vl/YPErq
         zwC+M8VV38F2U688QnJ+hqkK/CBc8I9CtkckCc7xsFy/uTihmQe9d5MOyXSsjhJBzpeF
         44mnq3TFc02vOCGJlgoooqdsOo8SsJuqWQUQIBaZ8A1zZSHYhcB0amLuXoh7x/F6qJU5
         F82Q==
X-Gm-Message-State: AOJu0YxZ4Nh37ZqTDL/Xq9BY7LstZpmigsNiUX39Vxpuzz+y1xHg14nG
	bQOrGwGxKFjRyDPVRFaHxcQnIcaFrapi0AMHeaaln8dvY/8fiA2yp3osnA3Duqn3vjXsRx4DvDz
	iSJaoDwXkzs2FGtCPjPLtzKJsRmvhH+M=
X-Gm-Gg: ASbGncspBy03pUUdZJeWWvic3v61vUCXuP6Rsx15m8hGcqqnV/3fO4Qel2EoagcljVd
	tMEovNpanY+KdLlnblLezGR2a/lK/O7N76JaHTGWwinbMAYFDRV5Kxj7k/jsBgLY+JBDE+lF1a6
	mcgoY6TEhvDmq1qYKZ7Vg0M6rRxFl2Xf3t/6aFtmpkAPziAUSJGYGYkp4krEwdxJOwxHO6FmUXs
	qTQ+IE=
X-Google-Smtp-Source: AGHT+IE8Qk6BHMFBf9U3IWk6DXLCzSG3SFLdYC+TdgKQVfcghPqI3c01lgGm49VUwUOg3oEbKVySGxlwZy1bUXGI3iU=
X-Received: by 2002:a05:6512:3f14:b0:553:cede:6a9 with SMTP id
 2adb3069b0e04-55ceebb869amr541797e87.55.1755270272957; Fri, 15 Aug 2025
 08:04:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250815121252.41315-1-ryncsn@gmail.com> <aJ8m42sM1NX_wEE9@casper.infradead.org>
In-Reply-To: <aJ8m42sM1NX_wEE9@casper.infradead.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 15 Aug 2025 23:03:56 +0800
X-Gm-Features: Ac12FXxYXlBYCdJIvWrwehc72wOjc3c-8FR_1vIHreuh2_FrYBGdZYJ_kEHzaBM
Message-ID: <CAMgjq7CYzdmt+mJbbkrskiksfvXuhOhLQ72hTnqGhc5nu8uH0g@mail.gmail.com>
Subject: Re: [PATCH] mm/page-writeback: drop usage of folio_index
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3A5ABA0012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gw7dowjyqdjtbqx67g88837t6ermh9au
X-HE-Tag: 1755270274-61159
X-HE-Meta: U2FsdGVkX1/ETrtAG8ysjtWBOmjT3o03rvY0DoQOfX5S+CtM7agTUIovIQmo7/3ZgDWa+07JcaoYla5S9ycyx2ybTquHMi1CNhvXQ7GjNWE6aI1Vw3LElH3rusnf8wswLEgwSWtbANvYaNnSPYShzjNeeSbUSqFxcsoAdFVgleI/qWj/UCHxuVKjHGugWQK85R57Ao7g/m0t6C9L+ieAr2Yxbrb87b5UGZr1BYaOL1bY9BQ73dsut+9J5eI+686AS7GFoqJyubbvGa+y/5WzoTGlhUTrd1YeCSpS4M1VDWu10bnhcTnRVmFXhTHG4LHoxgNPZ6ypguaT+bcN0Wblaohu+RT/Sf4ilxFpMKk/s1vlO6Aqwqnej3SURwPgSztD40pT6J4bTOvjm7Ewl1g1cI99YMmXCV0KStg0hWjXXOFjcY92r83t0duSDGCrQZ3WDGk47166XN/O6yBxy1PiYBloYV5zWmQ3PUUYunK4X/Iifbzch7skRVME+uCYB3RNCBNXX7A3hzG9RRdpE6kfXY9vGI7dwMgDoDOc6v1MNEIf7UDxMB3FJIQkMZU1Kcz4eJfEubEsFi79M1LVMLM0vfnLFFIGHPsUdbKrpQDdvP4YQ3k3jCUyG/cJeoSi9TlbZuJBLoqeImyHjxcj/KlAtt87UrUhl6pUMJIFZ2Qer7qrtO+S+vz1PnKaNwuZASyI6U1Y1WFObgl+xu1Hj64TsIJHym0kI6FaL47gsZFIf2ZuxOxi8XC4F9g4Wu1uquqNIT5tBSegQsCMiH4YeZ/mUs+FNiRWG8y16ozRhkSoMuslzSqkbbTPiVNf7PtiyTf4Ee3jCEaaB25/D4N9BhqNocNG9t744xR3//laFd3NyXkJnK4rG6PfFCiO4KD3Zg5bySeH66PUg5YbmfGlASxZg5g3uBymkPjMkZ4kBPb3qfLwgpGDmQK7Lno+tShHr47I+UPBi+JOW7Q6wJzSjaI
 w520JG9F
 z5oAHwFEzzyvtpgfMp6gP+34FOMiOJ//G9iqy2g4TmjvZF6dcCa730ivpzBONKxJpJDtBvvGUYruZP9V/AX8PVeM83OUs+zfeBD8V4NyWTN8kuncNwGFRrtc5qkUnJUqp7tte2/990R8yNS8hnpldSAp6vwJG/YNdmw1o/Pk2SWjE4Zv4+cFaAgKFZ71O3FXnJ8nhtJuoz6KE276A1YM8CvEESSZgrYbZo7LQmSdhSFGKA0GY3sWlVM5bF+fIvGcYHIkyhB4tRZnrpPOF1SbjZMONHS5ZHsXjAFADEzTMlq3nNE6fMdEBNzumbs8D7K2moBTMu9uSbop12Y/rcxaB/qY8BRtDvCc8Do+MihtHRW3dSHiFVLWxw7TpRQRWageX+jRl6kaGFsvsko/9T1Bg4YhXq+fLtNDnk7B/OpubQCI7GqmksuZEKimlndWdnOTVEZvm0NmBck7pCCE2qEAUqYCCUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 9:48=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Fri, Aug 15, 2025 at 08:12:52PM +0800, Kairui Song wrote:
> > +++ b/mm/page-writeback.c
> > @@ -2739,8 +2739,8 @@ void __folio_mark_dirty(struct folio *folio, stru=
ct address_space *mapping,
> >       if (folio->mapping) {   /* Race with truncate? */
> >               WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
> >               folio_account_dirtied(folio, mapping);
> > -             __xa_set_mark(&mapping->i_pages, folio_index(folio),
> > -                             PAGECACHE_TAG_DIRTY);
> > +             __xa_set_mark(&mapping->i_pages, folio->index,
> > +                           PAGECACHE_TAG_DIRTY);
> >       }
> >       xa_unlock_irqrestore(&mapping->i_pages, flags);
> >  }
>
> What about a shmem folio that's been moved to the swap cache?  I used
> folio_index() here because I couldn't prove to my satisfaction that this
> couldn't happen.

I just checked all callers of __folio_mark_dirty:

- block_dirty_folio
    __folio_mark_dirty

- filemap_dirty_folio
    __folio_mark_dirty

For these two, all their caller are from other fs not related to
shmem/swap cache)

- mark_buffer_dirty
    __folio_mark_dirty (mapping is folio->mapping)

- folio_redirty_for_writepage
    filemap_dirty_folio
      __folio_mark_dirty (mapping is folio->mapping)

For these two, __folio_mark_dirty is called with folio->mapping, and
swap cache space is never set to folio->mapping. If the folio is a
swap cache here, folio_index returns its swap cache index, which is
not equal to its index in shmem or any other map, things will go very
wrong.

And, currently both shmem / swap cache uses noop_dirty_folio, so they
should never call into the helper here.

I think I can add below sanity check here, just to clarify things and
for debugging:

/*
 * Shmem writeback relies on swap, and swap writeback
 * is LRU based, not using the dirty mark.
 */
VM_WARN_ON(shmem_mapping(mapping) || folio_test_swapcache(folio))

And maybe we can also have a VM_WARN_ON for `folio->mapping !=3D mapping` h=
ere?

