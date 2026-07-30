Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C2CC55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 12:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62AD16B0088; Thu, 30 Jul 2026 08:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B39E6B008A; Thu, 30 Jul 2026 08:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A8286B0093; Thu, 30 Jul 2026 08:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C5866B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:36:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FC7DA0068
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:36:35 +0000 (UTC)
X-FDA: 85045391550.24.0BC146E
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id A016E120007
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:36:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DNT4cL4Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785414993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrlP01wk4hpXDv6jG1ZeykLe/MPKEju1E5lSu+FqJrc=;
	b=6eKBqKv1knOQ5RpNVxxerFbPGGKlgErAzWdMJW4pAMSNf63dnauBqkVlKNSuBk48NIk2PP
	1n3wDXy7WH0IcEZq/kT74xmKT8ciZ3Ty0Qe063XU9eGsqWiamVNmVak2LmBGf8M3Sl+hAu
	DH3yq0cwyUwAuWC3jFDorL+Q4K1lywA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DNT4cL4Y;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf29.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785414993;
	b=TDrahu7oxLYBE4US6EbyTahnvX3rdH+Nd0iP2MGRRZkqCcpiqIexwkYvRwSiklxSqYPfvs
	4fXl/WOw6OG7GExoOQ5uX/7m7opfWffDs4CZd+pwCfB+Y1KX92HkxZtIRDAMBiNHg2fkxq
	tIwJKgMs3yCFldq9MElsM0Gsq92mZu8=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so266520566b.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785414992; cv=none;
        d=google.com; s=arc-20260327;
        b=nCwdU3Lq4qXSYqGaVzev7eEu1KhALJf4hzAe/Paq44fbugQgwHmJS41C0oBeLXwNSS
         j339VKsB4zQF1z2pPvql7aVh2kGCgjls7Ab9hhy5Tj0tPh31X3kesnUyDiXn1Ztn6CdQ
         ovnT7Bgyg0L9TzOm5bcoCeNipjGhhGaNVTkJTcto3kl7zrZ40BjQ0sWxrA+hoXAlyk+f
         51Ml0JAX+co9kSI1LzvB5VVmh/tQzoJsOkConuBro+PJUaik+VIkY0CAQxt3IK3G+FlE
         BU/bdL0W2KbXzXcre2E8gyvGKi0cEQilMwp9kmSbwR87I7NIk+aY+tg2m04upv4N1RN0
         zj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wrlP01wk4hpXDv6jG1ZeykLe/MPKEju1E5lSu+FqJrc=;
        fh=PRuzsvLNzJ7hCM3W2HhBK9c9omPen/nTyqt1eoLVeFE=;
        b=CaadHpb4m/KT4DLI1N8CbMwyewLEdpnVAzImm+yFcWM/Df9KPlJZfnsaYDjNZ5SbZS
         N47d9sI/VYT2ui7RdDWfp4AYMEyocMtALCwoJkcb2iA3YqrD+K/qlwtGwo46B4Rmvuta
         i4RdCoNuVvwlr3GT0JwD2Smo2qpNo+PyWqBoY7xQDyoNAkbbc4RKaX+fW0S7YI5fHNdq
         59jKgP9jzipJcj1gEEfDhSbCaEvI/NyDPEsNmkEkMoOF63PJdD6w5PYsI5NE4JNh5N8t
         wIWsOyaiJGF5PoACbvGQBybhQ16V5I145yVZie95v6WMvhY9w9PInYwaQe3LGa17Ujft
         lxhw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785414992; x=1786019792; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wrlP01wk4hpXDv6jG1ZeykLe/MPKEju1E5lSu+FqJrc=;
        b=DNT4cL4Ywl5IcyKKFW+rQR7ivzd4Br7D7u0aGeBWTsKej0A2DpM2m5vUBjDsdvobtc
         7rs8EWgG69GVAbaTZmHwAr+ZbCEQCzCuQuNYgZzRecOsGiamaH16a8xTylNwqehPSiL/
         0CzbJbWblmtydJ+Ok26tcDGa9Ke7oQwq5w6Y0gvN+enfKvT3unlVvlKrOEdWlMAH/sWK
         L1UtyKeo0NJPzb2bhPnaefegp3NU0xyiUjGOkit9ub+h9LUfgAXYh/y4I09pXPYZ+VD5
         V8KooWj7k8mRFpWciGhXDpCq26LTrZ5ggUE5nY/I184CrYZPAcg3yboEnO0xPL+0M7oY
         W5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785414992; x=1786019792;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wrlP01wk4hpXDv6jG1ZeykLe/MPKEju1E5lSu+FqJrc=;
        b=TPm+vx26Oh3Clfuh0ggpgublVXHL+3Vb3ABX5pcU11aCbldGuY6bo5s0rM94VNWJMP
         rgFtLcOBV1CuXEK8ujDLPcWoI6Xh7B1+EBxA+oRqUe/tHYQVQvy48DamBC0j5lF/sV3i
         nwvdp4cV3X7trE4LWubWjNN6zZXrHKRYt6SIf5eoWBVfQkQnwdirfkbhc0/DDKLw6asT
         vBaPh2XyBADuAMHfXRtmfLInTbFMi+VthD5xoqK9lTV4PeXzVUrT1TJd30pD8mei5V1i
         1kDu84Fs3s28YA4Dfrou4Z+r7x+nHKLFRbfnsK6OO8V9jQhX/cSAyQeGzvzRYIy2p4ms
         zjzw==
X-Forwarded-Encrypted: i=1; AHgh+RrAodJzr/D1uWmDZ+cMwC4mL4vjLqTxtGZW2xQ2QVPXRTDdNl+arTiCx/+WPcoIIdZACHYqm7ASvA==@kvack.org
X-Gm-Message-State: AOJu0YyAlR/GyQhdCqvmHSm1PM2th/5vkto+tcdkP7CHrh3nSOJaDULs
	QOr2q9hBYqn0thbugPPQHuttkJDqv3LXxDauO5r1rojbIkgF/pjq0eaNR6WPx4/WZ+Dpq1ZfuR4
	cbYShDjTO/J2PabM54b71Wy4kgWVD0Pg=
X-Gm-Gg: AR+sD11bHkFXRUSG12LyWqPgFQrap6C8nONcC+Lwtvzwnc/QsAGAucL17DThnYCu/IW
	rBOOsAqcMsn5M9zzSRE4ceH2eBWhqlFaknbEtzYFDkU8XDLFgkiETfeyVrlad7DRxy370uW/gm8
	bJwdV3/N/oNX9upsx7ix4CuqcdGYR6d7uVMgJILi9e0kZVI1KUPWR1J3HfF1wyRf+BqEjF9gNwI
	HcbDhdlgu+5lnpZGdk5p106tODvgs35MSPGbtMSTP6Yfyur8jwIZbOYK5ft44l4dve6ciHmF8pK
	XC2VjnX0FB3pSm4u4JXcaJ0u/vkY6e+DbdJVRSfiBfkqExr0tJSvQT6KgJEGWaKvhHg+7s9MKiw
	RZw==
X-Received: by 2002:a17:907:1b10:b0:c19:5a94:411b with SMTP id
 a640c23a62f3a-c1fa53ecea8mr130620266b.6.1785414991918; Thu, 30 Jul 2026
 05:36:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
 <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com> <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
In-Reply-To: <CAGWkznEuXnYMyFkkQM6fx1MVE8p=oGjg_VTZK7SJsCBDrcap+A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 30 Jul 2026 20:35:54 +0800
X-Gm-Features: AUfX_mxlO-HvIU2_BAPOBwZ-i1F7EWlKX8vUTZH2FxAl6MjSqYqI7E_yvj0xAxQ
Message-ID: <CAMgjq7DjFt+TST4WV9rsYZJ-Brq_E4YFVkbBoWXbKpEyzyzvLg@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: Zhaoyang Huang <huangzhaoyang@gmail.com>
Cc: Barry Song <baohua@kernel.org>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A016E120007
X-Stat-Signature: b3poha85hgg7x47tg8tjybo5uqdqu18g
X-HE-Tag: 1785414993-523478
X-HE-Meta: U2FsdGVkX1+jmrxALmZRF339HAXG4eAaTpU0iSzyrgGQficBaF0apLFV+QUnuRRkz1JAv2+DVY1kmkP+2YeSQVjSmzwzcgb6BEYRT04jscBNwJFvjDkQqQtvWD10PiWKra8wQCXl6m3bISc5Ut72KQRZ0jrq2fLPis30kaJqaUy1hLjwL2nJ+2+xwaRwV9KLK1t9S6eQtpnruqwf63sfH4JpDZBsATZ0lUtIWtvRE8SAhrzhsYGr5Rk+A9Q04zOVfuGCkeUlLdZ6HRFi2Cvcalyr93Ub8mFOPAWmn5qNV/uM3VAFTrCKwMVWWZqjcEY7Sf/koMYhynsPdiaTAeU23nPEFwxS2SzelCO9peXZtEF5lxZSq81kyp5C0dgw9KFurx9kuK5kUyQbgF5RjYh7/WByaOE81YtyHmVkSgpbnUvP6MQbqbm/E9zqAPZb52Oe6BV+BPmW4TCfGkzP5xsHd/8hf2DCHN59YFsPkS9DsAkArsJbjUFOqo7UEJp8d6VAGr43YggPMMJK+OVDs+u2WNgayGMOz0r3Jc7RR+M3NqwTiYv+yKwAi82cRoPFNJLiJgaPhU6ZUAwPOqYjxShumHoduIbP0CpqaQBM/s9qMtKzcjg7KTHuGjzZu+JS3b6RP2A2pNz+IBj0iQyRmruiEoPqGc2gO62E3T1lu0KCcmjmzjSjq0gmeWZ1wGVRl5q58epuz7YnaoZriKWo0N8H1fl7Pd2CxfNUAoXvtrPjN8fPv1b7QSHOIHGCP8bB+m/Nabx9NtZVzNUVrau0PzQfoOzy/CSCZ7LRZuqA6lLWjJx0GLzUJLYOAdo1FGdpRyfH4Us0JT20w5RT3D4uomXbV07NyGCp4fyc4qwqCigo2QutEatqfWOsLcI6hXWDfVJHC1LA8R5eGe/AjIjTnon1w8dHlQDF8Cg1aDk8rEinV8fuFApFhmA+HpO5+Lo0Zp9tTEsvD4DAUlof8Gb+uWh
 0R8t0JhL
 VDEMOOefJSQcuGROxxHt1MTM8DR0poeH1P+3RPcxUAObEt3Uy5yEbGCxaN8RYZE4neqD+9La3tdq1DgRYRujYgABzokh5dM1XJwWCnliSfbtA/m4W4Y3MMOEUznzuqJSOdzdL8OTs86Ko4FcIAEWqQ8jYiT3BElPrSd/2abYD9Zy7ettCZAYKA3nTv4e2U8OdRhlKna1UeOPcts7/SloWm6xfKvdud6je9UAcu/7bldKRKpXz0B/JRWTwZS4+ekImxqUXQ60f6xGsqJqnglIw603dmghm6VIfCWm+rJ5r2NuzV+8pAMVVcqS3ZNvIJnljVZpq6L3NHaZsIqBgwaQLZeRzixSTMfM1soEYTWRHBugk8nq124Y1qoFHj8mjEMDRKVq64M9lFRGqrrMMSBywdRzyV3ouV74b6GEIq6Wjs4xPa8rb/8aVD3nMhMC4NgSJC2Vnhiaqa+R6tnfzdnn2VXc2Ej7Kgsth8BNTiCjxdfKTnKE4Lb5l/Gd2BGBC3EOYyYNRRBIO320jcWjZtcK8joPvJe5IiC/8yI5UjMc0yu4y4dE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 5:33=E2=80=AFPM Zhaoyang Huang <huangzhaoyang@gmail=
.com> wrote:
>
> On Thu, Jul 30, 2026 at 5:06=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Thu, Jul 30, 2026 at 3:24=E2=80=AFPM zhaoyang.huang
> > <zhaoyang.huang@unisoc.com> wrote:
> > >
> > > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > >
> > > This submission addresses an issue where the memcg MGLRU's min_seq is
> > > pinned by an orphan page=E2=80=94a page that resides in the page cach=
e but
> > > lacks a corresponding reference count, while the number of GENs has n=
ot
> > > yet met the criteria of aging. I believe such pages should be detecte=
d
> > > and handled elsewhere rather than affecting the LRU in this way(legac=
y
> > > LRU could move forward by bringing this kind of folio along with).
> > > Therefore, I propose moving these folios to the next generation when
> > > isolation makes no progress at all.
> > >
> > > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > > ---
> > >  include/linux/mmzone.h |  6 ++++++
> > >  mm/vmscan.c            | 45 ++++++++++++++++++++++++++++++++++++++++=
+-
> > >  2 files changed, 50 insertions(+), 1 deletion(-)
> > >
> >
> > This is very weird. This seems like using a sledgehammer to kill a fly =
:-)
> >
> > Do you mean that isolate_folio() fails, the folio is put back
> > into the oldest generation, and the next time it is scanned, it
> > still fails to be isolated? As a result, scan_folios() makes
> > no progress at all?
> > And is it because the oldest generation contains only this
> > folio, leaving no other folios for scan_folios() to scan?
> >
> > Why can't you simply promote the folio?
> > Do you know why isolate_folio() keeps failing? I suspect it's
> > because folio_try_get(folio) fails repeatedly?

Hi Barry and Zhaoyang,

Thanks for the patch, but I agree with Barry, this is overkill for the prob=
lem

> Yes. As described in commit message, the orphan folio is an abnormal
> one as it is on page cache but has folio->refcount=3D0 which makes it

What? A folio stays in page cache but has folio->refcount =3D=3D 0? You
mean a freezed refcount for a long time? Then that's a problem that
need to be fixed, but not on the MGLRU side. A lot of things could go
wrong of a folio like this stays there for a long time, e.g. a simple
filemap_get_folio call will just livelock, and many other parts too.
I've met this kind of problem several times and that's really whoever
froze the folio's fault, You'll keep hitting this if you just paper
over the symptom instead of fixing the root cause.

