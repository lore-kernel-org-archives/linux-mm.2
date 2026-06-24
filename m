Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80276CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 21:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408D86B0088; Wed, 24 Jun 2026 17:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B9C66B008A; Wed, 24 Jun 2026 17:58:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A85A6B008C; Wed, 24 Jun 2026 17:58:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A6746B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 17:58:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 807E51C30EF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:58:01 +0000 (UTC)
X-FDA: 84916169562.26.C46502A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8A6291C000C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:57:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+XMExJ9;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782338279;
	b=XvWmOALEXHVggLs1WxdPuGVnPmjTHXdwe6RZx8KcVZaOBOQ4oUkww43+wAwsv495ikGt5E
	rtt2w/l9F65v/i1+6RrZtxx/6oC4eTIVulUjvXR++6J7fm6OpPCTq+scqbguS350wtSVdm
	32ebtHjNil0rHsMwjtC3hvqm2gjGkpY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782338279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0C1yMRpKeD5JvRnuL+qSeQd35ysnZLqVLwF0iVlRts=;
	b=8e7XqCtQt59JtM2uCtZsK1m2GYmRFFnbM+t6RypBsMsq3RKMatXIqsqd/Wkf6jw2TiLMmg
	gWzJbBRAQVHqFyrL1lTEq4Gag7z6iz1HfosA59oHge/rwlnAC+1zkhPO+lHM/zM7QmAWbz
	7j+DUIpBek0zAAi7jp66A+aCIpAYNS4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E+XMExJ9;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B27F44404E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBD01F00A3F
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782338278;
	bh=f0C1yMRpKeD5JvRnuL+qSeQd35ysnZLqVLwF0iVlRts=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=E+XMExJ9h8QHyhOPy4/ew6ly076p67eMqtzSy5L+5AfKlPcygVh/jmtQr7MC6ThUc
	 B8rIFAd09a6alSSEZus0HpW7TTw3DnZKUMxuNY4Bu0WEnCwHm/e+Ew7tKmanKoMUWQ
	 IiLwg7LEKwNdLPd+YeqOIuSWsyxnHtkbdkQJsmx0QSZGRLMcaIfnenndz+y1XKyTt5
	 mtT9eSeXwEyoWnoc+e8i4CFTn0uRxLrYuH66jL8h/AaJYFx9Zw5oUUsGXN3fMPpWAg
	 B/5XgeRoJIBuc4cd5srXiekoT51BEiH7yW/neBocqZfw7+vzNjRj8eRlHymAUJibZ2
	 PpX5bfRvpJkLg==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-9157b949fc7so147876785a.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+jqiep1PdOA/ehMGurf2r05aBbNQVwRhdPetm0RZ7htB/qv17ayrU8r8oBivl9ky6nDOT5EgWggQ==@kvack.org
X-Gm-Message-State: AOJu0YwnH9ko66Lut6Uy8huSX/WUlEbqKug6bnAD7O9ItQbGxOfqVn1o
	2RDKfpY8OeRV2oU1LK1TemW3fkhu3MolZZUA76SRIlZJBd73IroQMv2QEfJjcCNugdIiNmRfF2/
	t51wlEdFip8YbTH5n/ADrP1XS7X7x1ls=
X-Received: by 2002:a05:620a:1a04:b0:915:a347:e234 with SMTP id
 af79cd13be357-921d2fe7c48mr3333686985a.38.1782338278011; Wed, 24 Jun 2026
 14:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com>
 <20260616031309.3036234-3-haowenchao22@gmail.com> <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
 <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com>
In-Reply-To: <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 25 Jun 2026 05:57:46 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com>
X-Gm-Features: AVVi8Cf9d8kSa5QVnuU0BSJ8UDVs8bRN4Xh48F_MkpmFGipcLKDUaYilVHzVs94
Message-ID: <CAGsJ_4zmfXg_ub913S_uYeziU+mj_+Cks5iS22oTRRt2Y3LYyQ@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8A6291C000C
X-Stat-Signature: qj918kk8eufj9xony6jtkp68dhoign1j
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782338279-21374
X-HE-Meta: U2FsdGVkX1+xK0CiRKKAMT6hOIr7i9IPN8RYQTsksiWgb7xMlSB2Bhjb29yX4B04OxJqqCHgrMDk6ecsp+z8KC5hQOA/0/VjFj/vwKoVVX49KmDhWtWA4FqC8/AYUVdhnnFJf1hTIykMqMxEFQLc0cEw3n+nbOtWxjoKDrYbyo9SbGaZXS6ttOL6zwNVLlub7UdLUVBgLfH3tBg35nMIROiAITVl0doDXLcnoN4ta+4L0j94OtgnB4kV+smddVY+ZLCELTyQh04XUI2srjT0DNtf6uOuzPWIULqmrmDWopYYfL+TVcc5VT/4Kgvi5KUpP93ZXn7EsUScdSA1Ks/eZAl3927NUnmZVubbVXEJgaCbdFAM22bdFxNlK+MBAP+4RRt23kwbE2f36td4AyJZCsjDNBT5+Y4qfrPlucmLWucIo/PypHrwDyzvlxZLI68o9/obg+VTO9Jztj50Zhlg1Q+TZVhA+xGs9W6J5VnDEjtu1Eb+eN31yddc8p0NvBCBl2oB22h5WMHlR2XzUY6q1KqM88uGxBXMA30mdn8fGkl1pOEsniGV+q0mFDY6fO+ezuKP7IozQri1iNrI1ck7uuBYPTlBi/x2dwJTcfhh5DTMvuHPbpiHkpe1pYH1CJd7MqjX23Lj8Z91QKEdPaeXt0oltaU6cl+sYHy+OvhkuPa37cIrv0zECcGBqEa6QFXm/vwh+3X+luGNoQicPt+PvVnGQS9wQgr3jywVeGMXKZolNXGkoCx3JCNBY2UvYaLQWH3aUYizOWF8O5ej+Q387H/yUpg4D5X3kQ/UQKUFRpKlBs1rikzru14K1mN15qk1TcArMDzrGSnpM2GdfXU95kYnG7N2+wr73EMEdBEA1T4BzmyA+1q8t4XxiQl8QBdzxk/IlMHLONxDA7AZFTfNtC9hkCmx4+nW97ZvT+MgsOZYOQTAB4f3xfWR0m2//ToL9W3MPO1XK2r1qHbkeK1
 jE+bNTzt
 ZvQ+7X+dleXz1zIsd4ONfACHaT/QKjlNpB8aFZ0mHJxU0QO7TNxEF1JQ+h5ADONsnBctkLmU2kyl3YBbJUqSldyC1lM+1fH71mIZuGLXAp6syo4dv9oE2L/gQ82Uo0y1KzGtWE1XobsVZmXdEKoG8r64hEmAZni4DZJ73QZZR6HWMR18wrrRJiYeW3RtlOlhkbY7yi0a8QdXAz0D9leuLmsxkKvNubl9cxbVDPZz6yPhMbF+Yrn6L73TUt7zImgPmWnpvnDvN+8akMH4ypR4fXpAVFoBKpgKgyf1Pf8Gr2fQsQnsramJaQjgHGZhXNYqJFq909+P07NwY0LH3yj6bkxrCsq58NK89nAUJqAhtsq0yS0wVp/Anpb6BEt0Eq9mNMqM+bUEiOePDsnEuRlCDsnrBQPITg6UzV2AJzVIak6rb2MkLN8l2PqLuP3BeAN5r/L21AcZ14ymmdq3Yx78elyr5qe5IbVKrdFhl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 2:15=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> On Tue, Jun 23, 2026 at 7:15=E2=80=AFAM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Tue, Jun 16, 2026 at 11:13=E2=80=AFAM Wenchao Hao <haowenchao22@gmai=
l.com> wrote:
> > >
> > > From: Wenchao Hao <haowenchao@xiaomi.com>
> > >
> > > With class_idx encoded in obj, zs_free() can locate the size_class
> > > without holding pool->lock on 64-bit systems.  Page migration also
> > > takes class->lock and only rewrites the PFN field of obj, so:
> > >
> > >   1. read obj locklessly,
> > >   2. lock the size_class derived from obj's class_idx,
> > >   3. re-read obj under class->lock to get a stable PFN.
> > >
> > > This eliminates the rwlock read-side cacheline bouncing between
> > > zs_free() and migration/compaction on multi-core systems.
> > >
> > > Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() t=
o
> > > prevent load/store tearing on the lockless read path and silence KCSA=
N
> > > data race reports.
> > >
> > > When ZS_OBJ_CLASS_BITS =3D=3D 0 (32-bit, or 64-bit with obj too narro=
w to
> > > hold class_idx), zs_free() keeps pool->lock.
> > >
> > > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > > Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
> >
> > Reviewed-: Barry Song <baohua@kernel.org>
> >
> > [...]
> > > +static inline void obj_handle_class_lock(struct zs_pool *pool, unsig=
ned long handle,
> > > +                                        unsigned long *objp, struct =
zspage **zspagep,
> > > +                                        struct size_class **classp)
> > > +       __acquires(&(*classp)->lock)
> > > +{
> >
> >
> > Somehow, I feel that obj_handle_class_lock() is a misleading name.
> > The function clearly does more than just handle class locking=E2=80=94i=
t also
> > retrieves the object and the zspage.
> >
>
> Thanks for the suggestion. How about obj_to_class_and_lock()?
>
> This name reflects the two key things the function does:
> 1. Resolves obj -> class (via class_idx or zspage, depending on arch)
> 2. Acquires and holds class->lock on return
>
> The "to_class" part captures the lookup/resolution, and "and_lock"
> makes the locking responsibility explicit.

I think obj_to_class_and_lock() is not a good fit.

The issue is that class is a noun, while lock is a verb, so the
name mixes a transformation (obj_to_class) with an action
(and_lock) in an inconsistent way. It reads asymmetrically.

maybe just your original name if we can't find a better one:-)

There are only two hard things in Computer Science: cache
invalidation and naming things.

Best Regards
Barry

