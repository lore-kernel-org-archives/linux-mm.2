Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50C7AC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:37:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D4C6B00A3; Tue,  5 Aug 2025 08:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DD06B00A4; Tue,  5 Aug 2025 08:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C526B00A5; Tue,  5 Aug 2025 08:37:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDB396B00A3
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:37:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3291857A7F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:37:55 +0000 (UTC)
X-FDA: 83742655710.05.E42859E
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf25.hostedemail.com (Postfix) with ESMTP id 48170A0009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:37:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ih/m4fAJ";
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g04Ntcer02isH2W2d5Orye+n2oyREPifdCN3kZL60nA=;
	b=IGfEQxcQ9sn7XgLozhiNTjIdYI4m8515S3q+MYZDNimqFRu4k3O6RrbuY0r76PMNpvAC6z
	+9CZwZlfdLD5H/FksFVa+B/ovqo14dweg6RyDnqBPeK/tlSlFTA123TlBg7vVsHeTp86PY
	tcbdvK95Wh8Pv2CrGoSMFlK64d3k7Uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397473; a=rsa-sha256;
	cv=none;
	b=6NAOt4OhWSf88+teeEPIXP7tyX8WnQbi79palOtbxrDXN++oqx/w6AxUeNYRtZ53eqar3C
	0BqM5BDKaysPmEFkMzlrLdxg3RYM+5e675LZ/46lFpSWYFpAldytlqye8q49t7yX+sYSuJ
	KyY95kxuWrbYdZnii+vYoj1F6Xejb0s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="ih/m4fAJ";
	spf=pass (imf25.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-30799a41109so1931541fac.2
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:37:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754397472; x=1755002272; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g04Ntcer02isH2W2d5Orye+n2oyREPifdCN3kZL60nA=;
        b=ih/m4fAJiWgWh1/SJmdn5eAJ+Azqh6Vy9dX0L+wDNeTRApLiesOvkXUrFXi6bIyqD+
         m7LfbdTYvRQwGye/er4sx7oRuf1ThJF6gRVTndhkGMyfzILz/RsfcZ38IQxeeKK1OohP
         3mYU+4SygNuQnp3+pl1PUGk8Y+XLcMhfU3EOKBWLQorlSKlSDHNW8MobWxOdhVI7B1rO
         11tl3QoEC7IU6kNK/lT+oMBNDK1uQn4ceCp5X4yDlJo/SebA5bJTDn7vnUgqtcQLVt/M
         ysTmMzSdBF1WraPJf4qUdd2Zmq3Zwp0DxZ6g5Ay/VqellRfBWugYys54z18M2d9O3rVE
         ZWYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397472; x=1755002272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g04Ntcer02isH2W2d5Orye+n2oyREPifdCN3kZL60nA=;
        b=WZMzBs7g5gBY+FpeJNvC2lzKq9eOELcASmjv0u1vgXU1MAwJY3XPKV0SBxJ9Tw2w93
         bJZwyMkuPUkmgPlR0mO/mQnuUicL8vghG6I3spRTtuZRylOaAalN7ufN0wBXglRwUREl
         OQNV+viVpgLLRHfbEjghNb63gySgJHRpf8VVCPzQEwzwqkEr6jadC2KDzjaHJP1Ab7Lc
         8x/zniWRly2JcSnESwn0ua5MyL/317aRxmh1OOGkxt8PLaiY3UNuXR+I+cwwvvQo72NF
         6t+htIVrQriDTqQgxfeyE+VBCTYRpUUHBguDJ0YeU3qCVQBjQuwjl4hodLH0GsDxRGUX
         Dhzg==
X-Forwarded-Encrypted: i=1; AJvYcCVnH9ueOBToMyElTAXM8E35gjK1J5//zyAfg+UEofrC5rPE+GiM3R781j6XnzyTlz3daaRQJNMrSQ==@kvack.org
X-Gm-Message-State: AOJu0YyGzOSyIg7OO3AQeUKYSjoJShJT4DinjeHC/tylft0lPk7klhhG
	+UWaHRHhUzBcU24ReB6q8V6/WI6n/0kXjGPBMA53R0EDUxT6gV3tXNb9zKDBcf6tW9l0mE6cVVC
	+VYZVZqw3RfbTzh+jarZ2S8gv/PeO9PU=
X-Gm-Gg: ASbGncvs2wfaJFoxiKK7IlMti3ETn8vNlqxzzCH9lbhtvTckyebWdJICZBofWtW+Gp/
	MjNzbL/0CiKu/SREWaFMOQgZvQcepe9SkpeO96+uXhZzz04ZtwNO3sdAgNJlPd7HXCJ0onB0ZqS
	liUVr8m6JH0dJOqcSCSO5NjzDcoG9LgjtHfHAots0Seuc2pv1b5Gfu0eYuo4ip9xPrrddhVmCmS
	s9O
X-Google-Smtp-Source: AGHT+IE2TCmwmnktzW4aemXVrlZio5sEcPKysq6nKYup8QSAvfo1joiLW8JM7EYoY51P414A+9V2D5wy/ebY7W4HZIU=
X-Received: by 2002:a05:6870:6492:b0:30b:c1a8:448f with SMTP id
 586e51a60fabf-30bc1a844b3mr1709511fac.31.1754397472093; Tue, 05 Aug 2025
 05:37:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250804143816.29654-1-ekffu200098@gmail.com> <20250804165005.55515-1-sj@kernel.org>
In-Reply-To: <20250804165005.55515-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Tue, 5 Aug 2025 21:37:41 +0900
X-Gm-Features: Ac12FXwHdDXIzK_0THrv08uFiQk4ZLmdovdST6hSwmwefsjdGtMk5MskX2zfudo
Message-ID: <CABFDxMGZQYS68L45N1hKKWkxTK=XUmNCpeQWpzK02RwnHcuYAg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon: update expired description of damos_action
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 48170A0009
X-Stat-Signature: uqchidejpfugux33py3gu311x4bman7u
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754397473-147503
X-HE-Meta: U2FsdGVkX1+rz+DGcyBI6MzBMyapG1BHXgPLrF8NQ86G6cEwAuXPrEuJpfwDCsI9qUL5e9LGKXylzw268GPSk69x7jz907PkgDGXQ2XVg2OdEr70yuqWYjngqTt0ZSY99ddeleGG9PuDtAjx8JR6cvLJ1YCHq+qbBjxE0FIeNVjLU+ymhrPChdzOYiAUtiocCXrVrB8omeResTLycVvdJpR7OBFOXg+1s/GwfPScn1WsibDP+1qpZAOw4i/coNkTUOjPrU+qy1aTU9aglZplkGWUvUDH3qGbj5U3pm5KXx1kJGR7PD4aSEtWZk9QMPvGBKoitSvtW1pDAZ7NbQR2IZFgSEFMi+LQ1TNNg2PAV0A0qpzqyRCC0P6/JUPizc7nWda69zDkIOoVhPfJJYn3ze6rBPDGHxmRH7zAxojky/PnNjeAKkcNvgtMa3Hokr98Ed16asTYFkDrJN5W5QSieOBzy+MrCIjUAK/V8yClgQwqB9f/f2lW4LdJfxlZ6cPtwfgPqK03vxMy/B/3DFLi3edRKXGwG6VbE0ptufRHEkUcZ/gXttHbWYo2bnZ3gxV10pn6L4SnrGvDMXMGW9AWqGy/b+iX9ZwI1SVPBD2tV4tBOKVxgUdd85+g70DYmZ61GrLDLTh3Zz9kucz5wY1nUqcJCEu5AWl+gMNitjDzMwvBETYWZjCS4DIkwBRNNgGUm8ptVVanE+pgRt7KY/++5x5Si4n/08Hh96/nG6pk/z+kbLGw9zpjx8YPmFeK2FTVmplCrZyT0K2NC4+v5F6keQ5s2WKaVbhTsE/hIb/rdF0addbyGSCBsppx2kd+ICYfEP/HsDfz6LMj6JofcMfVwHMwSfpm6jFjQC4qxhQLhnt/PNhXMrmHlI9ipfpPBgQhP/NkkEJEKu50WXBZW+Nc4x7L4lJaJRFcs2ASMjzBhFHWZPQVyR332WKY9eacpeWgo2V4FRxBrQ+WKfMRIde
 2pXMUmHC
 hAJ9Tl6At8Stgl6SL8tqQVGHXLuEqfD4iO6cN4/dT5wDTooBH1/twgJ5wKma6HadDVsC86PVuAjKdbaQoVrI/8wzwbPlw69eYPRS3tEL0GiucN80Ys1bECFHAIvpR0E6cWX8YejPzHxJIbWpOvxE69nR2VLqYehbAhxY7ZZQbwKNHFuDn0CPXejwuvY5UMhmFB1LAucUBCFneHhUrJPm1S7hUX1qmUlfAURMMp2pkWqaV3tiSgmL49XkjueSrYJSqIajcikTxND6T2CSR4QlPYlMJ9b8zS5afiO1fzntz/m4YaC7LeC8yFVyL+MJut/pX7J5c7o0vWl25/4ASSIP+e7zu6Ebkwh4rjd7/lu1rzMK8+2mJayWbdVrgveml8Jn98PDfdcPbl5WaKG/q+KjTxNN6TF7iNOp+bSwJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SeongJae

On Tue, Aug 5, 2025 at 1:50=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Hello Sang-Heon,
>
> On Mon,  4 Aug 2025 23:38:16 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Nowadays, damos operation actions support more various operation set.
> > But comments(also, generated documentation) doesn't updated.
> > So, fix the comments with current support status.
> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > Changes from v1 [1]:
> > 1. change baseline from damon/next to mm/mm-new
> > 2. Add note about DAMOS_PAGEOUT and demotion.
>
> Thank you for making this revision!
>
> >
> > [1] https://lore.kernel.org/all/20250731132230.80046-1-ekffu200098@gmai=
l.com/
> >
> > ---
> > I also watch your comment from [1]. Thank you for not forgetting :)
> >
> > [1] https://lore.kernel.org/damon/20250801233942.1614-1-sj@kernel.org/
> >
> > ---
> >  include/linux/damon.h | 8 +++++---
> >  1 file changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index f13664c62ddd..d4b3ffd6144d 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -110,7 +110,7 @@ struct damon_target {
> >   *
> >   * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLN=
EED.
> >   * @DAMOS_COLD:              Call ``madvise()`` for the region with MA=
DV_COLD.
> > - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEO=
UT.
> > + * @DAMOS_PAGEOUT:   Reclaim the region.
> >   * @DAMOS_HUGEPAGE:  Call ``madvise()`` for the region with MADV_HUGEP=
AGE.
> >   * @DAMOS_NOHUGEPAGE:        Call ``madvise()`` for the region with MA=
DV_NOHUGEPAGE.
> >   * @DAMOS_LRU_PRIO:  Prioritize the region on its LRU lists.
> > @@ -123,8 +123,10 @@ struct damon_target {
> >   * The support of each action is up to running &struct damon_operation=
s.
> >   * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actio=
ns except
> >   * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_P=
ADDR
> > - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
> > - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> > + * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD,
> > + * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.
>
> I think we agreed[1] to add a reference to the design doc, instead of kee=
ping
> this duplicated.  Am I missing something?

OMG. It's my mistake. I'll make v3 patch right now.

> > + *
> > + * Note that DAMOS_PAGEOUT doesn't trigger demotions.
> >   */
> >  enum damos_action {
> >       DAMOS_WILLNEED,
> > --
> > 2.43.0
>
> [1] https://lore.kernel.org/CABFDxMGh7-vDgNzepJKtrhdOF40_U7=3DNT6Jvm85qtd=
wGpBZawg@mail.gmail.com
>
>
> Thanks,
> SJ

Best Regards.
Sang-Heon Jeon

