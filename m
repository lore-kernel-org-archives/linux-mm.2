Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58888CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 01:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9667C6B0117; Fri, 15 Aug 2025 21:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93E626B011A; Fri, 15 Aug 2025 21:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B876B011D; Fri, 15 Aug 2025 21:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 728866B0117
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 21:18:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1D311174DB
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:18:27 +0000 (UTC)
X-FDA: 83780860254.28.116DCEA
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E7C1C0002
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 01:18:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ULM9TNEm;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755307106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i85A295astkrnsG0olPQxO94kGINVJjCYBUtAM86un0=;
	b=NEpPktusmQ18UvfzGsimyTNaqS/wm+WzJTnOpvG0CVTa9mXxwXjGKw1DSwWUzBwP7wkQ0b
	+hXpciWGYjk3JEQBUvXiFe57/M1380ASSRyacRAoRGg6ndLzNDtBZkN+hgHsK+rbbrhNft
	ghPkmLNjgawfIMxFcmU4m3S5bynzsjk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755307106; a=rsa-sha256;
	cv=none;
	b=INowl1emnW/s50zZszjrIZmQa3SJW43ABqVOYMHUPxOp9j3htbEO19scbLk35IWiUBqRw2
	LEoBW0ZNqhwggkilztRIk1zHXC49OC9LkG907DA/+CG2di/GCfQRvQK/d/gKa3mmPIG+24
	qqxcxKzsY7X/SV2/D72adXS5c90FxSc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ULM9TNEm;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-30cceb83f85so1500240fac.2
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 18:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755307105; x=1755911905; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i85A295astkrnsG0olPQxO94kGINVJjCYBUtAM86un0=;
        b=ULM9TNEm98ZpG3Y2EYKs7rQCr2B2qBmlBFTYKlDPLw5VoeAMxkjyoDWUbEWSnFdvNU
         g4zj+PUEv/pLOwdMi96pFhAVJpYlxx3Bkje6m2yajQMItEnUUmoa/sv/ytVkBizOvBNn
         NqkJkLOFoZJGn+rxv4uW8euttVooeFtgP+El9hSteJWRsAykDiHVQQDr+MdhKwPfIzGs
         D8FkT/E+BnARkpU3UjoyFj+6oo69TThp0C8fEuUH6/wZDpucgdGatLrzXIsYv9bFiFRl
         PpO/3vbuH6zXNn8z8121EKNVjnJFnaLeseqGls8LB45kbMjQWF5wgAdmxq8fG0FKhM89
         zopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755307105; x=1755911905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i85A295astkrnsG0olPQxO94kGINVJjCYBUtAM86un0=;
        b=V9lfwWMZge1Kp4Y84JYQ12XEfoWa1fSQAqY7OnDfJAJPGYQ9breHkRfNOdsu2Z+iZk
         Boq7z+V6BNtJ5p43dAKX8DqIdLokKwezJif7VH9ovQiDHeb81VxjVYNXdNKnA7ptnXg/
         E45G5hrykNYgzO2pjRqxBuBJUCPtozqAMT99G765if9YfJu97n1KoJ/BOemPZWgfUdqV
         9XvUR0q3cURCYqV6xGx5s5WdFUDV87BtJ/wwk6qMGwZIvPygSyexwtmEGFv7XzU2eeB6
         mMFf9xQ5f3RlskC+wOIi0MxFyiLoClWPgg4vfFwgxREKyqv4Ny51iKB28LnDoHwWzdAo
         vZRw==
X-Forwarded-Encrypted: i=1; AJvYcCW4GwdrlTgiVgsxXYuy21QrBL4v4+8YxRTDzsdEvr72HLjw1SIDCI4m2bVWd5ruW3jgWrFPRG/fPw==@kvack.org
X-Gm-Message-State: AOJu0YyvW2vwMDqYlRdGVDeAKxB6m17yoRiBfZQfI6iuohSgvSys8NpV
	RMi7lJyu5aMsPyjCyTNQoohVm6zGSw1I+OSyuS9HQy8KZHAiFDCzFc9DFHg56tKHNy546/rSntj
	Any3SvoyhneqI0Sdyh32Sbl1b99Z3Mk4=
X-Gm-Gg: ASbGncukcVM89B+jn/gDbB+I4IdRV8c0kTHZXaNa7XxCKmmkkT99sMcJ3udBBDShuCu
	n4w1RtcFSWUYS83SaOs/mwcAQHC3NKJ/zjBsQggZk8QpJsfxLBrSRuaplGxYHbxUiCmEiMJuvcs
	CfvWB4/LQGh87G8uo9nMIsSgIH1wO/enkYHpm+4NSiTSwpnOcg5y4Vwdod1C9avayEFeR0nkt+4
	OXR1j1RDep3gFg=
X-Google-Smtp-Source: AGHT+IFqT2oSNVenN+f4QBQCYTnTPaAAwiOulHgCDn55IB+cL8UJfXfdAdPuWYb6zvlfD5igRmVjFo5PjCQutnnxHLU=
X-Received: by 2002:a05:6870:bb12:b0:301:1218:60a0 with SMTP id
 586e51a60fabf-310aaffb0bbmr2472700fac.34.1755307104988; Fri, 15 Aug 2025
 18:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <20250815094059.133769-1-ekffu200098@gmail.com> <20250815172545.16704-1-sj@kernel.org>
In-Reply-To: <20250815172545.16704-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 16 Aug 2025 10:18:13 +0900
X-Gm-Features: Ac12FXzKzp0T7fzOIpiV_MJ8ZJ6of-v-S2DlMbu45VJeqoAZcVxgwHGqVvqyj3c
Message-ID: <CABFDxMG2Mr+zO6i7a2_J5S5j7+4etiQYFur=0a+U3oNOS8TMMA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon/core: fix damos_commit_filter not changing allow
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stablee@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1E7C1C0002
X-Stat-Signature: kh1mw6re5c6fe141d11ojyhmkpbwqbhw
X-HE-Tag: 1755307105-669154
X-HE-Meta: U2FsdGVkX19WO/XbYwLnCdKSJRGOLIpuMK+V6H3F5j2myhqtQZBP+b8Zzh8BbjI9R4LdMhF428V2rLijbl+lmNHuHll8XNhasul/j4jq+97q0f8xi8Je0YLiz5XXdq3aZkcto/ICq0w6/ohvEFtDl1y4sIWQ6UTe/TQqwz7IoLgQ/orVAKHmy5ewofnHlSeHNc5enS1dkTEHPsWhEAY/ykZBP8kAizY/WciSTcbnCmTEVL6+wqyqbYirfyxh0akXHQ+hGklD5/SqfOmH5kI1A6NQBtmA8e8xxi85RNq5ORIRH1pQ+B2Sf7zAamhvDGsDYEN2YvWl4GbnSNRe8IDFgJ4iK4wo2nwAzKzNmfzMLTt16ll2tFwwJPw9MeE9c2eR2HChoR26uYnjOhGmTqrGggqvUwZtDp25v5updfRkIHorA34lACexcwvGZJiHP/RuRwAIiGAUfh5ogrpo5wmaJl85qRJ7y59aVGt9aRQFxp7HBR6C1ANIX67UniJZTohgyE6tsiCnkkZOjQVQ/bvd01uRzN7yKmaGljC3nV8lbdjOtb9n5j67HJlUOR8D/wv69jXZe9W/9DNusyWn+JU5ddBaWncP2bUeievVZJt+BAHmP3+GV17bZmDtCXhEatGSW9srzqggFyUmCQm6/6CcLKBxieiBLeCyUMmg2t5BEVnParAhXewv2bSiYXetfswh5ESiPXi1dYs9/SE3v28V/Wpc1+jJfl/8ACpFYAYD0AAP5BcDIcm30trGeffuJtmD8BynvOiElBzCUkAEk1OQorYf5QRogfA1qxsSHPoEksZ8L4A/ItlA2od/JVkikndiAWZXDLFy+P3RwCThdfP3/O4OQHqCosNzcpLffXz41jIM5p1m/0thn4lDuRR4TDEaWM9LkEQdltuS9pY4FnIvtbf5xI8iQHI4Jd0XHmu7VmdBCheaPeSD73iX6wHRSC+94+uhiderxOghTlnUgvH
 8qoI/Aly
 ieXQ33F/V+RbTuKJMwqFpZrh687VyteSqL+ZHaiqnKgOvpNEqN4kCkYqx5hxbdydyM2Wpd2wPF0Hrw7NyLeDKr1Gba1xTxQNbf6rKTqnRCGjc49LETBjXFEg71MLBe1HEokkpTDVyICnB4K53fCSSy6vJV9W7S9iqHwKnOcnCqz8EhBG9q2FjNoWypS4qeU1pF55tZgFq6rNwn4G4BBJmIexGQnjdN6tkx0RY3/80qIGdF9uRVUEeiVzmGzo4b8Eiqcn5NE67ML5B9TYGL4fNo0alykb3CyZ+K2wlgf0/Cepdm5n6lDdllzd1ORLDb5NlsVnd1fRr+mNvEmN3JbJ4rS7in66p/yFlTO07XtNRAbZbE+JLmoHKZjpuBBnPBINePYhWsBbChYCce5YsAUm7SqHZVm96d8CwcHYad6Jszy0kt+9HrQv0U6yN4KsnQJTnDEsg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae

On Sat, Aug 16, 2025 at 2:25=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Fri, 15 Aug 2025 18:40:59 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Current damos_commit_filter() not persist allow value of filter. As a
> > result, changing allow value of filter and commit doesn't change
> > allow value.
> >
> > Add the missing allow value update, so commit filter now persist changi=
ng
> > allow value well.
>
> Thank you for finding and fixing this!
>
> >
> > Fixes: 9cb3d0b9dfce ("mm/damon/core: implement DAMON context commit fun=
ction")
>
> At the time of the commit, damos_filter->allow didn't exist.  I think bel=
ow is
> more correct.
>
> Fixes: fe6d7fdd6249 ("mm/damon/core: add damos_filter->allow field")

I found a wrong commit, I'll fix them.

> Also,
>
> Cc: stablee@vger.kernel.org # 6.14.x

I'll also add them.

> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > While fixing kselftest, I found another bug and succeeded in
> > reproducing. I think this patch is similar with previeous patch [1].
> > Also instead of sending patch with test, should we check which is bette=
r:
> > a seperate patch or patchset?
>
> Separate patches are better for me.
>
> I'm not sure how you will make the test, but I'd usggest making the test =
as a
> kunit test.
> Please refer to mm/damon/tets/core-kunit.h file.

I made kselftest with drgn, but I think that kunit could be a solution as w=
ell.
Honestly, I haven't used kunit test before, so i need to look into of
that. Please just wait a little bit.

>
> Thanks,
> SJ
>
> [...]

Best Regards
Sang-Heon Jeon

