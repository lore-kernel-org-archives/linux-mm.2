Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC1DC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF8138E0006; Fri,  1 Aug 2025 11:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF4D8E0001; Fri,  1 Aug 2025 11:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE5588E0006; Fri,  1 Aug 2025 11:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AC9178E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:34:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63BEF577E2
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:34:44 +0000 (UTC)
X-FDA: 83728586088.15.C2CF886
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6CD8010000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:34:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g8/f34sc";
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ofe6Q9A+agjL2oCVwUrX1X8DXac9+wkgPKORpc2QcHk=;
	b=uaWcubQdGGZ+QoB52Zrm3plJ8VmYAWZl87XfUFOoi9MqCxPFrlOwNC3RZsAnwQzw2b8FIy
	Fl0A36Tm/3jCTd0slAbbQSKr6GxhZa76ojnS3YRj34Q9QJ7oBnVVhFFGNV5n65OPKzNi2P
	abbOejVCWOF5yDGOpVGEVDcYHucXbz4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="g8/f34sc";
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.54 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062482; a=rsa-sha256;
	cv=none;
	b=AmNtVIYneXq9tqwpVc95SX4KnLvnWI+ok/CKWoUi5PcXpghN+QNHF4vY+df2hBITJCZptQ
	+lPvoHU1OtqJ4UyoFKZGGxvnAPQVr+0iMdCDUGS2sgAvVmHWXO2xv27NB1Bog8w4+tFw8S
	T6FicjOuPietI+RKQ2zvJx4b9DAMlT0=
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-306b7eb492aso1265324fac.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754062481; x=1754667281; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ofe6Q9A+agjL2oCVwUrX1X8DXac9+wkgPKORpc2QcHk=;
        b=g8/f34scwpj/5DuMjqZtTiz/5obcbdRF0nJdbzwFAHvuwNn6al24kTgHFnUmJ2isuk
         Z0/7BXpAtq4pdWdbPJuitj+3986rq82W49gxbmU4sqMoBk3SgYU8HCJL3U3jynL/eQfL
         kULpupLWGCLGWbuMIb5JISNlimm0jA2FEVN6SfeCgkOxSiQziSbxwVg9AQtN0vjZTgxW
         dUI2osAPi0DUrvqghT/KtycDNR/KDSCfE94uWhwW0752z1VBnrbEsgTDH+oJUhDVpgtG
         DCH2Mv73gJDLTgLMnxlH/BeogTmARIfyatHcPIJUpU7YzIyC0OKFziX83swlvutChOla
         covw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062481; x=1754667281;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ofe6Q9A+agjL2oCVwUrX1X8DXac9+wkgPKORpc2QcHk=;
        b=nBTDOrKwtY+NKfB0dNRKQ961yxlaoRS1Zzb1AHaSY7G0xUIQW9J1P8fK8CLTLjqnQM
         SO/NScfISbEGvvPCZeIWltZqQeVW7+k25/IEx2VbTeOQHntPVvmnZVU63Hypxt6aMWuf
         +3IomRLTdaaaPQaZxZCrHQMJKQz9amSQZMcpFZwR5XaRYT3Xx9COEWGPEtHeOpQqzy1g
         E2ULnqHtPNWiyy+6PwMNjdDPF204JJ+vEr1AoaqXFEzI7XmeFbV1U+TaN/+hcMWPTWRo
         gddBpajCTXShKTwIxh7nspua4jaYDq0gfhBosav5M5vYym8u7I/cq96ZOoqWR252SexS
         LmOA==
X-Forwarded-Encrypted: i=1; AJvYcCVF+8JQxNPYeBQ41rAOFWcyhyZFljFVX2fxYgcTIoe3NPCuvYfb9hReeF12Ki4lTrb6TjeO7193bQ==@kvack.org
X-Gm-Message-State: AOJu0YwX1mM4syoJv5oi1eIYMmmLmOA6BajHTFK2krKjLUfs36J6Mf5J
	ylb6LPEcqYKcEysI8sPlMGnq3T/AuFJeiv3SqBhZNQfhco7VRLS0NwgcXOb328t2iTGLILkMUjY
	276cE4Z4VfUGZmXdhHMFfEEFbTxUu3kjiTLTVzi0=
X-Gm-Gg: ASbGncsbsE6QHPOMwKek3KnINzayyjf6U9dbaXnFC1hjn2qVsI2B39zkUKtyj+DHSxz
	wfMg4I7Wab3QP0kt2csL/7DEPF15OduT5GpHwFsSf4vdP2yb9uUP5gD9UB567fAHUFKqj33nBoh
	BB6mYv9U/1ov4KNmGg7hbjjr7wEACpPQBlkLtN1+50f5Mil449SAIbuQgdcR9ij31tWnyeyck5S
	6BJ
X-Google-Smtp-Source: AGHT+IHN/OaWoq1Bl0J7hNhQm2fN8vIhDjZXkH9pvZf1y8Kg55hrcYAt9FM7VpJ1+NJ7ArOll3YbDfO7FWH0OYoFrVY=
X-Received: by 2002:a05:6870:63a0:b0:2ef:88fa:e0c3 with SMTP id
 586e51a60fabf-307aa6cfa18mr4334721fac.13.1754062481183; Fri, 01 Aug 2025
 08:34:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250731132230.80046-1-ekffu200098@gmail.com> <20250731175827.16060-1-sj@kernel.org>
In-Reply-To: <20250731175827.16060-1-sj@kernel.org>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 2 Aug 2025 00:34:30 +0900
X-Gm-Features: Ac12FXyO7ed5ZJI89Xk8AfdlvOmHKkfzcePLUQXPj3FxvakC6lnlPmJPlnQCHP4
Message-ID: <CABFDxMGh7-vDgNzepJKtrhdOF40_U7=NT6Jvm85qtdwGpBZawg@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j5rjcinsybsmrmh9mqdh9njnsjw9o96m
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CD8010000A
X-Rspam-User: 
X-HE-Tag: 1754062482-892687
X-HE-Meta: U2FsdGVkX1+iYp+O+dAj95Gnv+Inz5gFM1fguYkI2HD/yOxYZybD6Ieil0LFjfrj06gZm8qMqpwvbhKz2Zo/yGiCCgxBJq+sxYyUUpAlOcSDISVlhYjkEESjT8VlN5W7pB8QBZK9noHAN8OTIxiqKI5m0SWo/wtUHEeTfHNi1yS8cxflvdtWdFf+gQan6l3NtHKVMO0eKJCqbQXdWyzbtvIGvrKYhKZe0HyDuHDb15X0Umar6UdcDdWnA/OujW+Gsn0OxdV5O7w7eFvjyu6nE2Q8k2ZK7vCHR/aBGa5N+4yOz5C+UcnfJdmORsRoYasDDV+cA4sEAi5cpD3Q0u2Ro9csbyYbicoHGpTdQxXu88mV2SSeSScE6FWe8N5Q/pAfYs2wKBfe7+9aGCI/96cjq+P86GJjjlLVwILnynWK7TCxh3R29WiWvdb3tttwiI6Ec+f/2EzhsB225Ogo2N77ebgBrgzUiL9FBMQtIkklrs0CTSizxvko10Ux5aXh+m6FMtcjBc4w7cqDsRqL3aAm07vbiuaEuQ6uR1LC/gDwsT51LQMJSKeOUVV6Zoby+csl8RVr0AjDiaFgpWxaqgRiYRN5M5bkFalZGNMpcu1mzLdd3QBM5iOP4HIJ/SYLJKO1Zb6hejvXWM4bmag/cZH2LMco6MkTAZN+S7PFUvdbMhzNTMKEwVk2ku8AIvA2hTZOQ1Ng2PvkBtmzxmxVukpMN08q1bYXII81y06zm7HLkT/04j0o5kzKwF/TaDAclXAdoF4vaihkhZFZeyvhiUqc/qqgt5gYq2FlwKabUnSUyOkyU6YaVdQOEWjOO5WESUQ+rpHvK428yc0u6VTWrGqSJZJ+9RdvRdBEpWvKQhlAMHLi9WoK7QUeqslUMqjUGYdkkJ5Wa/m41gmdBCWkSFr1/qe8+vszpwUrsPDoHOXYbZctxPIgYrBEDjKpuJQ9VfesM7CywsBkF/4WaWsCBTF
 3gxhOmqv
 lIfmMbuIl3BT6pisxNadA5OKPDkVgQKK1zlUBO47c9V2+w96fUYuOpsbn1fIRc/nzk/39CCCRQcfJgsb3dHjKILJNTIa1VT15A8gw/0zyZrgZwRTRi42MDR48S60o11x3tXRmyB5qdw4LcdGoA3f8lUS22FtNjbSuaUdWgM6lVDg5/SDpFSbbzEucjJUEK+4DeBawJB3BhqfVib/bIMN0JaZcrmSYGg7FdDJ2n1JwspVb8IJodO7YZsSYyS+U8vGQI8WaOhnsEtPQgaLbL2QcgOLB2A73yvHI+zCCl1EfQqujiTdrqqtL5RPuHvCzmDxiIu3P9OxMgIqoaXqsuU7hDnKcyXHgRTsmds7HmAUSeAimhsS3eq2fxF+dR2ffI3FVwbjQYA2Wgrse8b2+rjeS+P8uVbbSJDEB0qRRkaPurT3W8NgyffqJ/OvzqKmwCqq+pjvsd4B34CCidhyT5FsvVnM6Hn+Kw8XK5M2Q0n37jY5IFj6bO4eB99rTLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, SeongJae

On Fri, Aug 1, 2025 at 2:58=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote:
>
> Hello Sang-Heon,
>
> On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.com>=
 wrote:
>
> > Nowadays, damos operation actions support more various operation set.
> > But comments(also, generated documentation) doesn't updated.
> > So, fix the comments with current support status.
>
> Thank you for catching this and fixing!

:)

> >
> > Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> > ---
> > I also found below patch(https://lore.kernel.org/damon/20250730200239.6=
0984-1-sj@kernel.org/T/#t)
> > So, Is it means that DAMOS_STAT is only supported by paddr now?
>
> No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT sup=
port
> on vaddr, but extending the support for DAMOS filters.
>
> Thank you for checking the thread and asking this question, though.  I se=
e this
> as an important signal of another rooms to improve on the documentation.

Thanks for your kind review. I really don't want to bother you
anymore. But I would like to check my understanding.

So the basic operation of stat is covered by outside of
`damon_pa_apply_scheme` and `damon_va_apply_scheme`.
If it's not too much trouble, could you point me to where they are?

And some extension stat (maybe it only renewed that filter exists) is
covered inside of upper functions. Is it also right point?

> > If my understanding is correct, then we need to fix Design documentatio=
n
> > and comments both.
> >
> > However, since it will be fixed soon. Keeping current status is also
> > affordable. So could you check this point as well?
> >
> > ---
> >
> >  include/linux/damon.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/damon.h b/include/linux/damon.h
> > index cddf82eaac4e..0870e9f48b0f 100644
> > --- a/include/linux/damon.h
> > +++ b/include/linux/damon.h
> > @@ -128,7 +128,7 @@ struct damon_access_report {
>
> Seems you are using damon/next as your baseline.  If there is no real
> dependencies to damon/next, please use mm-new as your baseline.  For more
> contexts about that, please refer to the DAMON maintainer-profile[1].

I see. I'll keep this in my mind. Thank you for telling me!

> >   *
> >   * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WILLN=
EED.
> >   * @DAMOS_COLD:              Call ``madvise()`` for the region with MA=
DV_COLD.
> > - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGEO=
UT.
> > + * @DAMOS_PAGEOUT:   Reclaim the region.
>
> Nice!
>
> >   * @DAMOS_HUGEPAGE:  Call ``madvise()`` for the region with MADV_HUGEP=
AGE.
> >   * @DAMOS_NOHUGEPAGE:        Call ``madvise()`` for the region with MA=
DV_NOHUGEPAGE.
> >   * @DAMOS_LRU_PRIO:  Prioritize the region on its LRU lists.
> > @@ -146,8 +146,8 @@ struct damon_access_report {
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
> Thank you for updating this!
>
> But, now I find this place is having outdated information that partially
> duplicated with the DAMON design document[2].  I think the design documen=
t is
> better to maintain this kind of details.  What about keeping the high lev=
el
> information but giving a reference to the documentation for details, for
> example, like below?

I totally agree with you. Unexpected duplication sometimes leads to
unexpected expiration like this one
So, I think that I need to send v2 patch, If that's right, which way
would you prefer?
reply to this thread or make a new thread?

>     @@ -143,11 +143,9 @@ struct damon_access_report {
>       * @DAMOS_STAT:                Do nothing but count the stat.
>       * @NR_DAMOS_ACTIONS:  Total number of DAMOS actions
>       *
>     - * The support of each action is up to running &struct damon_operati=
ons.
>     - * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all act=
ions except
>     - * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS=
_PADDR
>     - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
>     - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
>     + * The support of each action is up to running &struct damon_operati=
ons.  Refer
>     + * to 'Operation Action' section of Documentation/mm/damon/design.rs=
t for
>     + * status of the supports.
>       */
>
> Thanks,
> SJ
>
>
> [1] https://origin.kernel.org/doc/html/next/mm/damon/maintainer-profile.h=
tml#scm-trees
> [2] https://origin.kernel.org/doc/html/next/mm/damon/design.html#operatio=
n-action

Best Regards.
Sang-Heon Jeon

