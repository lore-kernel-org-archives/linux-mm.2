Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E78BC87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 16:11:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224386B008A; Fri,  1 Aug 2025 12:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D49C6B008C; Fri,  1 Aug 2025 12:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3BC6B0092; Fri,  1 Aug 2025 12:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF5336B008A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:11:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A0D051A0219
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:11:24 +0000 (UTC)
X-FDA: 83728678488.30.C357ABF
Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	by imf23.hostedemail.com (Postfix) with ESMTP id D5DC4140010
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 16:11:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2BWe3Hb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754064682; a=rsa-sha256;
	cv=none;
	b=0hv48AvInZNFAKQgyta9W4HDQie2g8PKRhIhJtdFdQ/PQpY4Lq9n5ifA6TkVRHsbCQiJUv
	dHPYOSokbVxh4pCnYlFfF0oRkp9T+EH/CYAunxdYZcf6EBTH2ePdjQpIDG5a1FEQs4kSaq
	UMyf9lVgfu3SgiNINjALnotxCH4pZK4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P2BWe3Hb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.160.52 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754064682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDM74AkLUFGDbMniQpaGkJ4N3t+PhBITmSskxxmk844=;
	b=Lu6zDre2b/fdNTvBoIXVSNhGHCWB5gT4eEChPugBLt2Kw+8S26+qAVb/0E7Ds3wSDIrfTN
	1WC9gLPPACGLXNJo9TY7O1UT+Lk7XtCAVCyHGSi7l6nqxqas4AYhwuv0sgCJxMziVdD8+2
	Tj6TK1rJxk75YQh0kfY44pKzsJeByHw=
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2eb6c422828so2453938fac.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 09:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754064682; x=1754669482; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDM74AkLUFGDbMniQpaGkJ4N3t+PhBITmSskxxmk844=;
        b=P2BWe3Hbg75n3994NDElRwsJbRsDRHaLFqmuEKLTZyzk90iT6L1Djh4eC65yW1BTLH
         oOaBIkucLdzGSfhiLqFhH8q59F0xCqV0aIw6yOJjnDAND2pAdFf/515H1LAZ+k6r5rSl
         gvQKPqJbvkOIyR7EqlS1cuRE4iO9Jp2L9vbVq+k6C/isJALG9KKxzpFXejukvrk9bh56
         ncO3DK1Xs7/dZO4ARms6B2TyDP6cSYX6q/VfnMIosi15PuGCrkbBW2DhcZym+quoDNyn
         0kjr1gupMr4i6t2fWuuU3sk+BXQ/SwTGkGl0+kte8lNXwwnybEUqNwOrc4om7M/LdDtM
         bL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754064682; x=1754669482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fDM74AkLUFGDbMniQpaGkJ4N3t+PhBITmSskxxmk844=;
        b=EGGwz5pm8d0eaH69nZ4Vj009KCJsyDhDDJ9MclxUnucza87cb3suo5wjgmtZbwDFZ1
         upohMdXABufCg5ozbhkkzR6qS9pPqSjqnuOqPwkFiOJEpYaHx0BsCKNvpSFYw2a6aSv9
         KWEefwk+TMNzHVqC/EpJ7I13rYBr+OW4G77MpJpzbQU5nYnXE4yIERo2+qsxrgiY8GAs
         flDdDMicwz0DDOozkWwhKHawfsPj6yg7RZ+Td+iS0joJ1Jls/WajEVaEH0xE5kSDTk8o
         GgFOagXE9P7adU3rduiAh4TroIf6j4zewO4xPYJcKqn32KzDIlIOLs1yb4FGZEvyFAaF
         o66g==
X-Forwarded-Encrypted: i=1; AJvYcCVOKcdPO/bpkaoDTuGCf+aSvCBgaVH/CpuhBn928nBuo4suuHVXJ7/3EcCrl5GmmC9LF6WupZp4Lw==@kvack.org
X-Gm-Message-State: AOJu0YwRUF4w1wQ+9izKv9hPdmYCFniawVw1wTtKb8ffC8/3AyFBuKqd
	u89O+HeAiqQH5HKZT5XXYrhkONGtxasrcuTLc7foOjHiS/wPDOHQek/BJ8H8n9YL0voM9ZDvZsT
	L/2nlLSlvYzXnSg2/1VcQ1fRaSgHPXRo=
X-Gm-Gg: ASbGncsI+Rtsr2Oc6iwBek81JHYXA9guQiN0eZDXxruu5fjSMZscU7GMd8pbc7hJCMA
	yJXCovX5wsKkOrkVV4ECcjeMBbTXJgCL595I39pGCGjr3OM7t/ri9rNUjcTcrYHWpN6tYauudOQ
	Razk6+vg6FsObOVdXQGyE9C3PxrowhiATMq4X/YL1pyJi6o3HJmzRf5hpaKHPBCEy/3Fjq2j8wu
	qbw
X-Google-Smtp-Source: AGHT+IH2Nb7B8EopMRNCEjFAeodu4t1D/XqmvTxU9PJF2g4XsvjezeiAFWqhc86hVcoLxEDqbT84ahs9DxtNkrc2VWw=
X-Received: by 2002:a05:6870:9e95:b0:2ea:83c5:1e27 with SMTP id
 586e51a60fabf-30b66ad7e05mr167005fac.12.1754064681671; Fri, 01 Aug 2025
 09:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250731175827.16060-1-sj@kernel.org> <679e90f5-cbeb-4078-ad76-a075fa5d7afa@sk.com>
In-Reply-To: <679e90f5-cbeb-4078-ad76-a075fa5d7afa@sk.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Sat, 2 Aug 2025 01:11:09 +0900
X-Gm-Features: Ac12FXwjNZJQjbIOiTgT3KYsCiAQtRxXi14dWMv04SFrqWS0XfUeDLfizECzg_M
Message-ID: <CABFDxMHamJ0m8Nq1L-4WNz4OwLaLVQdwV=X4_ZpK7Vd+RSTHVA@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: update expired description of damos_action
To: Honggyu Kim <honggyu.kim@sk.com>
Cc: SeongJae Park <sj@kernel.org>, kernel_team@skhynix.com, damon@lists.linux.dev, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D5DC4140010
X-Stat-Signature: b3nmhy7rn696ccqqjr6ws46zwyzc9fgq
X-Rspam-User: 
X-HE-Tag: 1754064682-279607
X-HE-Meta: U2FsdGVkX19rUvYyswQyzzLk3NDj0XeaXyJhh24kCfbDcdIEUCLtgGL/KpX5V8AWcZnIduCo/VwKyg2hnQhudNOLXWKWn+PbVL3d2PsuKHKvBw+5L0nR6M++usnM5/oKaFXeNeOHu+MoYoPRrP9+YfXCSMYkzGo3YvAqXnXWJPrkPP1vlooLPbaVFFbqj6wPEjI5U3hYEFDKUqOzUEvdcn2atOpgHmcMk8M78dnvdaX/a87JtIUmtcaN2feSTk015MOfff5q6138a3mBR//RgV8YFpQwKmlRPnjGWLykOQM29LGxDpsun6HfH/DfBehCNlxSBQVqIfYBjgzlGpw5o7z3hcf7tYsxb8GImWitQKc7dMzQ7EeVifSjWdERsk5/5+p+5Uq++JsUEgfJ+AZVEmP6ki4AwKD+htXMFkDrZTiLuCismht+wTGANzB58YdbZ+wzz7eDGOhmszwTBFgTGzQTkDcn7avz3WFMLuXPdo5Q0iDFSNUSob+eeAWEDHTqG6Ykq+NJp6BG+Uu858zcKYMxJRg3BchD1GCaSUB0c839Zh+uOBaomFWVUJBkPRoYK9VuQOkYCKLr82eJQIUTnW75TztM0hf3pvNHn5KGRJp3L16IpJKo5YimiIAznl5eGRbzJzK5gbvbyNHuNpmUNEq5a1QYm/SihG+N+bn3Q/WN+XzL0CLsjcH77lanRGglMjJKPW0BX9O44MqW3rrKVnpMUG0jh7mS0bRm7bcAeYXMtI8Za/OozIGO1xyMv9iRiOAP9IEbUA6TYcYfPiUdUPeL76kvJjndqJLkSL2PP+zo/787t7br4ivpztsf+OxLbRtQa26j+eOwspvPGRo35/+pQZcYu1Gne3mcSXjgUCyJHPHsRglJJz8p7c/046ywfPoBddtXotiwx2O2xFLK1qiyTcEgekYThfl2nfNfcujHJ1jzUG6Fs++IC+k1CPauqHHBLQZ9gKQi9aLM1/1
 S4GPO9Jt
 sOLLvixDor0gSxdDmXZQM+qd93EJcxyjmWI/EsXaVwTifALZlKAPZ8EAeyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Honggyu

On Fri, Aug 1, 2025 at 8:35=E2=80=AFPM Honggyu Kim <honggyu.kim@sk.com> wro=
te:
>
> Hi Sang-Heon and SeongJae,
>
> On 8/1/2025 2:58 AM, SeongJae Park wrote:
> > Hello Sang-Heon,
> >
> > On Thu, 31 Jul 2025 22:22:30 +0900 Sang-Heon Jeon <ekffu200098@gmail.co=
m> wrote:
> >
> >> Nowadays, damos operation actions support more various operation set.
> >> But comments(also, generated documentation) doesn't updated.
> >> So, fix the comments with current support status.
> >
> > Thank you for catching this and fixing!
> >
> >>
> >> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> >> ---
> >> I also found below patch(https://lore.kernel.org/damon/20250730200239.=
60984-1-sj@kernel.org/T/#t)
> >> So, Is it means that DAMOS_STAT is only supported by paddr now?
> >
> > No.  'vaddr' supports DAMOS_STAT.  The patch is not adding DAMOS_STAT s=
upport
> > on vaddr, but extending the support for DAMOS filters.
> >
> > Thank you for checking the thread and asking this question, though.  I =
see this
> > as an important signal of another rooms to improve on the documentation=
.
> >
> >> If my understanding is correct, then we need to fix Design documentati=
on
> >> and comments both.
> >>
> >> However, since it will be fixed soon. Keeping current status is also
> >> affordable. So could you check this point as well?
> >>
> >> ---
> >>
> >>   include/linux/damon.h | 6 +++---
> >>   1 file changed, 3 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >> index cddf82eaac4e..0870e9f48b0f 100644
> >> --- a/include/linux/damon.h
> >> +++ b/include/linux/damon.h
> >> @@ -128,7 +128,7 @@ struct damon_access_report {
> >
> > Seems you are using damon/next as your baseline.  If there is no real
> > dependencies to damon/next, please use mm-new as your baseline.  For mo=
re
> > contexts about that, please refer to the DAMON maintainer-profile[1].
> >
> >>    *
> >>    * @DAMOS_WILLNEED:  Call ``madvise()`` for the region with MADV_WIL=
LNEED.
> >>    * @DAMOS_COLD:              Call ``madvise()`` for the region with =
MADV_COLD.
> >> - * @DAMOS_PAGEOUT:   Call ``madvise()`` for the region with MADV_PAGE=
OUT.
> >> + * @DAMOS_PAGEOUT:   Reclaim the region.
> >
> > Nice!
>
> But doesn't it make confusion about whether this pages out to disk or doe=
s
> demotion to the lower tier memory?  It's because PAGEOUT action doesn't d=
o
> demotion, but it looks "reclaim" includes pageout and demotion together i=
n my
> understanding since /sys/kernel/mm/numa/demotion_enabled was introduced.

My intention was just to synchronize with the Design documentation.

So how about changing the description to `Page out the region`, Would
this be also confusing?
I feel like it would be clearer than using word "reclaim"

> Thanks,
> Honggyu
>
> >>    * @DAMOS_HUGEPAGE:  Call ``madvise()`` for the region with MADV_HUG=
EPAGE.
> >>    * @DAMOS_NOHUGEPAGE:        Call ``madvise()`` for the region with =
MADV_NOHUGEPAGE.
> >>    * @DAMOS_LRU_PRIO:  Prioritize the region on its LRU lists.
> >> @@ -146,8 +146,8 @@ struct damon_access_report {
> >>    * The support of each action is up to running &struct damon_operati=
ons.
> >>    * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all act=
ions except
> >>    * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS=
_PADDR
> >> - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
> >> - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> >> + * supports all actions except &enum DAMOS_WILLNEED, &enum DAMOS_COLD=
,
> >> + * &enum DAMOS_HUGEPAGE, &enum DAMOS_NOHUGEPAGE.
> >
> > Thank you for updating this!
> >
> > But, now I find this place is having outdated information that partiall=
y
> > duplicated with the DAMON design document[2].  I think the design docum=
ent is
> > better to maintain this kind of details.  What about keeping the high l=
evel
> > information but giving a reference to the documentation for details, fo=
r
> > example, like below?
> >
> >      @@ -143,11 +143,9 @@ struct damon_access_report {
> >        * @DAMOS_STAT:                Do nothing but count the stat.
> >        * @NR_DAMOS_ACTIONS:  Total number of DAMOS actions
> >        *
> >      - * The support of each action is up to running &struct damon_oper=
ations.
> >      - * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all =
actions except
> >      - * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_=
OPS_PADDR
> >      - * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
> >      - * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
> >      + * The support of each action is up to running &struct damon_oper=
ations.  Refer
> >      + * to 'Operation Action' section of Documentation/mm/damon/design=
.rst for
> >      + * status of the supports.
> >        */
> >
> > Thanks,
> > SJ
> >
> >
> > [1] https://origin.kernel.org/doc/html/next/mm/damon/maintainer-profile=
.html#scm-trees
> > [2] https://origin.kernel.org/doc/html/next/mm/damon/design.html#operat=
ion-action
>

Best Regards.
Sang-Heon Jeon

