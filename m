Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7CDCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 06:13:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A5B8E0008; Tue,  2 Sep 2025 02:13:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01BF8E0001; Tue,  2 Sep 2025 02:13:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C95F8E0008; Tue,  2 Sep 2025 02:13:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74B2E8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 02:13:38 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7F7F13B66A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:13:37 +0000 (UTC)
X-FDA: 83843293674.17.69FFB59
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf13.hostedemail.com (Postfix) with ESMTP id 11D3D20007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 06:13:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cgWnL1jU;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756793616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXpO31qXeYVn+ZP52IVAUF/F/TwtGC3fKI0WbpDerJE=;
	b=P4J9OdR+ajaor8/FQKLzyZ0Jv5ju5ET6Ms03XLevnuuMtvAck/CpCjJxDphP6XfaY/JqWY
	QsHKIcIAZQyVWMXzloxoRUyZ2JOIk4Vg/P6LjyuYAd24aCVpHMUEdyHLKjisCa4+UZOY+L
	JsNGfqugFMGHTNBUk0vxKDc5mHqDiJM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cgWnL1jU;
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756793616; a=rsa-sha256;
	cv=none;
	b=BP/l6AxAE3+aYycX0h6jcxqjyaan2sNiRogZXGL+UWG7+2hLSwDvBJmprehFUSlTnNnc0p
	mYOOe7kFgaXUlrD50SGWc4SB5kKTwST+WG+PutF/Ye5aVFq/Sxxd+XcurEd7emoWk+RaP2
	L6/5AV183nW9pK/+pTcIrZW4eyWV60s=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b0454d63802so36563066b.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 23:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756793614; x=1757398414; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXpO31qXeYVn+ZP52IVAUF/F/TwtGC3fKI0WbpDerJE=;
        b=cgWnL1jUEVjP7LPaVn1aQlU8C7AvPwgAGwqmak825rErFqIugM+EPNLpWzFkC17j9q
         tJDPqN8rtI+ify6cN81Wr6PkQOIsAZZdVxyhlhaCcJ83NvZ9sxTqbBOUOMfB59eDAoiq
         8F167eAf7aKFgax9Qsfw5vNhfuxshQBv8OyTf+Fbk9v8NNn1gLrRxwcIVLD6A5stjsiq
         5gPh2Dw5XbsOcGtHFdifrxww+D/CGdfewMc2xCgQK5D1iOWbdvMdbW1Bt5W77Ab4Ug6+
         HJjh1xyluL5Vz/bqa07iOWRb/g+yYOoL0eXUnieXu3SswPa93NCdlYML/e46WUyTDSYn
         jk9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756793614; x=1757398414;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXpO31qXeYVn+ZP52IVAUF/F/TwtGC3fKI0WbpDerJE=;
        b=HRowh3kLfy4mOaJbbck3mIoaqv6MDU7ecgs8QyPhBVjYW1lg6dw+OpwFpTl9dDdYvF
         bhVJAsWUV8m9CvNFYlKvLXDrKNs8JjyATewYIuWIj+rhEQRd15Tgiz5Cm3iC4/BDfg5k
         PiP8haIvF2fj927EiGUcv2qsTwi6gSTbdpyhTkO+RF8GihyWXigjUiXAiPZMc2dVSH9L
         2AwRCrYcFbhR+/LdWsyDyB08svROPAPPEWnTo8lv71LRBdGZJ+hL0D/lQUR1vGiLpAJ5
         LVPq2mLCmt+uVJoZqwmjmVy647s9LspliAPaF1x3DZdGRUzdthqHFFPogrSY7Yg84kf+
         GZEQ==
X-Gm-Message-State: AOJu0YxTkRH17IkbK6bxp0WScq1sFFxOztt63gmo3O9ERbxSZpohGBlx
	U+LAkJljyjrCsuTJfoNwH0if+tp+n9k2gOGsAN82AYXhesJUiAjZFmkCz2VROvci8UJX/OslWxw
	CLTHdYjFrruiYqjfTaT7cnMHINSimaAc=
X-Gm-Gg: ASbGnctbivwkQ14gujmLPUboJEV/hJuItmUZ/9zCeSLeb9/iD/2PDfizKjkmR48iAGE
	W0ElGlOtJU4LfuETuLo1SmG2PNq2O8KvPGR7grrHWLAqR0Db35qthWzPydHfVyV+1X6u5CE88EH
	DO37AdiJniZxyCUa6XmObZW/DwUMH3JnP14X+08G+IKoR/uAyfawd/nGcEQsN266thrCqfRZ1YS
	blZirxDP8TVTpPDazU+kA==
X-Google-Smtp-Source: AGHT+IFditCyGR6d3RrnKjk54ELZjip4tSsePu5eIAfrFlKYOz3nmi1u2hedAsaela6WNYcSOUPTayCPxoWIfadjBDg=
X-Received: by 2002:a17:907:bb8b:b0:b04:1d07:40de with SMTP id
 a640c23a62f3a-b041d074816mr660378266b.23.1756793614053; Mon, 01 Sep 2025
 23:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <CAGsJ_4xoN35Av2H70o+dwGzhKrAnm7gppEseG0MgAUPQt2TygQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4xoN35Av2H70o+dwGzhKrAnm7gppEseG0MgAUPQt2TygQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 2 Sep 2025 14:12:57 +0800
X-Gm-Features: Ac12FXzRHhSHkOm9GhOsn7XLeGu7L3HAsBD5D0dA66RleOcvQAaQbN42xrE1ngQ
Message-ID: <CAMgjq7Au2n7PO6yb7wyCJbvFceGj6cpQCp+kVTewPjU=WhmXKQ@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uxgq4t65gewyxt43bsnozeqoh6tn8hbm
X-Rspam-User: 
X-Rspamd-Queue-Id: 11D3D20007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756793615-725683
X-HE-Meta: U2FsdGVkX19z3Z9odV18Rkogle/JVy4WeGPqiEogC7DA9jm9d5idofVBaR91glWd4Dr7EzpdaFjrAqO8/LMNkuebOx+Jk3dBsf6dtcRlCIovPr5oune1j2caiw1xhtcZTkY8CY1UpVKwGmSHmghpYo23kxc7ntWaNe8icFFfk7vsVueGdkAmOC1F1bBjQlaQhZbE1U8Dhzjr7btRz/2hRNvJdVKipBiTBLjD6lOW04J2mJ2H7oLE9EfKTviUV1RIx5WyFcJR1TNk1Trcut9nWigmZA9hqYpp/A50mc1rKCwrInzNnz2HauSmwxfB0UFkJi+aAfBiPx5zoHbzjSvvlX5uoodXx6cx2Iz7Xcq6rh63gliRPzh8pis5N2p3JB0GIIM3Yx/nbSaRzUCKojCtmAJdRaXlwrefgsSwK3rbw9PIDJ0JIM9CrF432DJy6+1gajSmtQkYy1Zp7nlqQOFvqajJaxRz/DX3DRflivhnrzY8z5fR30evw1zQdbzp2GQnFQTt4r11NLbyODu3r/qMHUU86rsL0zayau931AnjyX8qSv7Mbg4yziQJAFvUWyffVoNqS+xWYlUSXle/ZE7//NASva6thPpmmmdB7gRwhxvsKnw4X4D5CN/peaov7VySFYj6cwNHSOjBgxtvCdofDpxZQP1ElDHntTzK73sHRfz4xG5730PjFePUe07lADDVCxRiodk4jJJbHFjG4dxk//2/xVtb93Buaa31ZoTCyIOVlmHN2xYQ5TIgp633XVXUmZLFeDE4oq+q5kXaJbHtpMQt/27CHwVL7roQEwCSCGdn6xODH/k6Pd/3oL8noG7XWqyfyeriHJEszqXoslR8ULFqopZYg4LaCjc8VWUZpU3B6eOEG+6DykkFFhNWdsOhNueKOhZPqdND0lt+pZP1yW+dbwqzkqNEGZeKLg6K9lvvJOlwJGpEzEA3DFDhoCYkB9s8zqQtdSNUXhp3fpC
 PA7QzaAs
 LJKkDyECr9PPO1bPwg8KORou3YitsyYLyPJIOT6k8MH6sD+n8YJfuwjgckYvULhTAFmLS5bLDHyhjxvZ0jUy6/e3uAh+lp+SL2muCyJZ3N2LdTUNjX/oWR0b//lci3wXqCbZEuXGc/I6O/3WXPNuQKGvVnU/TFDh4IjUyZUNTNned2Jm3k+nd6KvWKsH8ijC4g6hvf9hTCV+CSXYLvIBaY17pHdbd27sG7y2ddpT3my2hfyDvjjWNpCpUrRLBqyruAUucsRyOYCqwulV9P4Yx5oSPRLCJ8kTPfS7exx4g2MdBrFhlADJuNenqVJ2PBjA+WJPwVgOUWoDANHDvBnxeRZ40n45KWADFvm5fOdOBorvDiyDe92ybfeTQOJ17TvHwDZQPdlrzUm9FcbtnRBH16mBaYy0CxihPjxm0e5sEO8KO/SM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 9:14=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Sat, Aug 23, 2025 at 3:20=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Always use swap_cache_get_folio for swap cache folio look up. The reaso=
n
> > we are not using it in all places is that it also updates the readahead
> > info, and some callsites want to avoid that.
> >
> > So decouple readahead update with swap cache lookup into a standalone
> > helper, let the caller call the readahead update helper if that's
> > needed. And convert all swap cache lookups to use swap_cache_get_folio.
> >
> > After this commit, there are only three special cases for accessing swa=
p
> > cache space now: huge memory splitting, migration and shmem replacing,
> > because they need to lock the Xarray. Following commits will wrap their
> > accesses to the swap cache too with special helpers.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> Nice! This has cleaned up the confusing mix of using
> swap_cache_get_folio with VMA, filemap_get_entry,
> swap_cache_get_folio without VMA, and filemap_get_folio.
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks!

>
> Do we have any potential "dropbehind" cases for anonymous folios?
> I guess not for now.
>

Right, dropbehind doesn't apply to anon yet.

> __filemap_get_folio()
> {
>         if (folio_test_dropbehind(folio) && !(fgp_flags & FGP_DONTCACHE))
>                 folio_clear_dropbehind(folio);
> }
>
> Can we mention something about it in the changelog?

I can add some words about it in the commit message. One can easily
tell that if we want dropbehind for anon, swap_caceh_get_folio will be
the right place to handle related logics.

Now with swap_cache_get_folio being the only place for swap cache
lookup, and in the next phase we'll make the swap cache layer the
unified way to do swap synchronization and never bypass it, maybe
dropbehind will be easier to do too.

>
> Best regards
> Barry
>

