Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB9D6CDB470
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 06:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D066B0088; Wed, 24 Jun 2026 02:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12DB16B008A; Wed, 24 Jun 2026 02:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01EBD6B008C; Wed, 24 Jun 2026 02:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF6466B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 02:15:25 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03CD2C137E
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:15:24 +0000 (UTC)
X-FDA: 84913794210.24.BCF5978
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0A60640002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:15:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CP98feVd;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782281723;
	b=P+TeIad0gYph1hEs/sNTtDZYbJtdVybrK5ucuImmBMlDoBtvlkDngYcIz38TY+hitpjguI
	jV5I7NhHebR87Db4fm3n2Mm/lxMYWWRa+8xxj/fM+bAGsmVjk+VINQ7tOpmB8IwaaizHtn
	zUScctBiOAE1J+GI/rKzSECG5vZ4t1Q=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782281723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8fCxQ6aZ8RO4gcP0e/e0gDjMMrWbsxoEjk9D9ZrtPCg=;
	b=LZJwLfFGrQeLwSGQdkp34GSI0N3EtQc0A5KT4Yj5sAmR/D1Z3Q1c0HMBXevpionSZLakGI
	+QAZmgn48h7hw+GrGLiJ7/bPG+bGLyULHWqOTumu81dJ+F9d64c/11GNMzvzGhOhfUU5QW
	Hye01BlRFR8djJkydmlb8TEYpKPQ+7I=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CP98feVd;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.54 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-662df6a4fe4so882352d50.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:15:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782281722; cv=none;
        d=google.com; s=arc-20240605;
        b=NDSnAU2YrPPjklEBwncRnuN3OxgLGc13kVTxBTKoilNWLaP3uk1x0K1bjCfvIqRESl
         qNztC1QnOJ/n2JgtGIZWeKmjyXMt2GCb+6X5qdlwKzNT5fy6xVK8peJaEPzmYaNWeuso
         gbXi6O+Q1yKHLgtHxFyEsj2zclg9vD+WdAt4EfzZTikZUBtwmBTXL1utgUYQNv+1H1MS
         +3IMzIDK5hB9O7YwfYjwzcMdVWV41wX4SfUKhE1wQKJFXxowM72Ccq8vcz84ByKJI0IH
         oKWwYeiwyKwivlByxKPKqNovfncRpjfGbfx8viYJptAVHFNqW0hW4u3GP315s0Mbkig0
         ryxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8fCxQ6aZ8RO4gcP0e/e0gDjMMrWbsxoEjk9D9ZrtPCg=;
        fh=k2siU9HyvNz8aOzARA/KzViAGFB76ctvOIFLYfMSBfc=;
        b=TSirFbMVl83yApLuBT2h85oFSjrZr/qCowgqRYnkdKKuceQcKiU7stQsOVetxqVzwM
         UjZQU/X2vgh6EhqXaEZyX0l1e3llMYNkFAZL2zhEhXaKnNXLNIdSwKHVeLqGh0kQNl+0
         TkCxFr3SOcfkU9g9i1iptiEnf/RUwGzhfEUMvT+lyna2KaVgV9+IsS7dEeAw6y3HN3Ok
         8Vk7J2Fv+DEp9GvMvKUg6P1/F9AowugCgRaj+fXGbRkbxhEXEHL8Fj95qHvW6Plge50B
         SSdv/RpHK3LLqJT3dXP8rgks7z6T78Kk/MmhmJTcRFFSJxjc4802Dcm9osaKkT+GecY6
         6QzQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782281722; x=1782886522; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fCxQ6aZ8RO4gcP0e/e0gDjMMrWbsxoEjk9D9ZrtPCg=;
        b=CP98feVdb5D15P7SLTV9a+QFFZzIGaIKFKFeNSohx49f2kkajCTzG7sP1vOUc1hELW
         bA8ekL3HagyRMOMdqHXvEtB++K1j5Z9jchFAo6pJdKRb+Xe38qorCg9yauZPu6zB7QBf
         Eo9syx2sAOdFDwyK6ZGimWisjZ7LZqFoRArHO16V2xz+ort7G7S7bDvMNAFn+VZzp+kW
         PKzMqftAiaFhsb9RLAx5BQLbz0NBWQ7yQ9h8VI2ZJIiQREE4W61VFT2VPviAmQivBLEt
         MO+LqFqKZ+lvZ8E8ln8I7S5fd3SUJMd5YJGdr/RJ9/ChFdBQTb8X1fn9I0KKE+vvCzPu
         BPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782281722; x=1782886522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8fCxQ6aZ8RO4gcP0e/e0gDjMMrWbsxoEjk9D9ZrtPCg=;
        b=JvR9ZNUVle7S/+2DK70aXzieUwbo6/wq88QCfZilvSMIxGMquGKgP221glbthCI4Fv
         kUP3MhKgbydJ7x1o0G5nAVDQ73RBc9s9g4vbCJ7WKGZWxb0Vj4JoD26HTW8RDmFiMyiz
         5+oiH82wao/AfJzxXvRg/quj0dEJzjUf7Y6/8L1RNcPbN9GLmOHM3th+azOf/hWO9XzG
         chBT+xJbMTUu9g5Gt5S14vAlmeU31ePw682K3qWWHB2PLxvwwYa4hVZ51OUpIOv68W34
         RpFC8t7/8nkv4HKkoWjzQF17dhvwSGqbAuLX9LYMFhIASoJsS5bQ0sthJqEEVJ1N8m8w
         8WOA==
X-Forwarded-Encrypted: i=1; AHgh+RoryjarYSi8KYJUJ5DQ6SDQ5cVqnogD4VQTRWZG2SoBl/tsgr02NNhOfsiPdqiVY0nlPTbryoCrBA==@kvack.org
X-Gm-Message-State: AOJu0YwqecvyneJ2WlAxDqmoqGnfUUZK/HsBpOahio8t/73/YNL/j95v
	X+Mg8RS+lklhxCTZmGbJf/k1w+mHN/Z+jt2ebUP8Ut5yANGbKBXo5QrEhmjjJdxIo4CegACLjrW
	Wkp1h/T+C2KjJky4BkQLmmcW5v6QeXwA=
X-Gm-Gg: AfdE7cmP6fVeNW2JY5BCI6f1clV+kP+U6AHOhrHAyuPH/CMtYFzatdYCG+dVSN1t0wD
	PRBJiDPmkfshYiEuQZJU7mwMjcrRQ/0x1j/+S5eNOSF1TH1QlmcsAP+qm/hQb3VTyRpUawKBBF3
	1FMRFMTwII1M3yNWOi2LHHxN8XOhts7CcvL3Edwz+qsk+k7uKItZxJW+oT6jV9UDJJ7GsBBfQMU
	7UxkvMAKHmeLNEkwodVoLFm8GttgN1QnGD95iB2zWb/+48ko62AHudCVCTys/3I1fsBtpvFzO7Y
	g2lw17iR
X-Received: by 2002:a05:690e:124a:b0:660:e09c:d57 with SMTP id
 956f58d0204a3-66359eda206mr5121811d50.29.1782281721906; Tue, 23 Jun 2026
 23:15:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260616031309.3036234-1-haowenchao22@gmail.com>
 <20260616031309.3036234-3-haowenchao22@gmail.com> <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
In-Reply-To: <CAGsJ_4zjuSnR4K5DS0A6yDaZkvBz-9ODNxr3Yo5_0O53MosiQg@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Wed, 24 Jun 2026 14:15:11 +0800
X-Gm-Features: AVVi8CemaEHq0RU2FRFGBGrtpiWNSHwFALNyVy4S5Cjaoq-Pow0XmcUxHP6_VMs
Message-ID: <CAOptpSO7rLHOCYXgp6sFjbWMD5tf_iK6B5NNrHWb_CU-tuVmpA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] mm/zsmalloc: drop pool->lock from zs_free on
 64-bit systems
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Nhat Pham <nphamcs@gmail.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0A60640002
X-Stat-Signature: ee4p6moso7cx517zoa581s5pud7xpgzx
X-HE-Tag: 1782281722-414761
X-HE-Meta: U2FsdGVkX19+Z7Q2KCyGmmpJTDSwxd5SRuS19ZD1NxAPprOkscdE1owWvdgwY907++jaSRCbZ/zH4O/zbpVrvOky+vujp+ZYkJZgArRLVK3l+kPNar7wSP3sDB7s7iDWExgcT+sG4uXYe+noBgb3SNEbY6cZJR+5kDOfWvZf6mMGYvDFXCaEx1Ed6kgKETIDYA8tJ8kS6DvYArwF6sfswNn1HrYWaceke0OOywBQGS1hjrn6mWWfnbtGHyh46HDBFy/EropyAYhR7UnknIBK+iAWQggwf8iex5ps+ZhEwAJH6fuz4HdKSpkaEUpKRpiPHpu/fCVBjgQE2yvDGUXsLETXfFuFMv0xbyTN2YDFiNpHEisFF/4KREjTCrRzu7Sl1LBMEO/ckF4kyg4OPaZMHgu8jMBP6Ou9ePBsmhJ3OLY8PkYQk7RR1KsuxkbLx2FTZJlpEL69zrZWAcszw6TMJdbV1nsXAGrqdeS6AMkprb2TaImrCRofNAEJjE0UHr0BqBlb/BCodhFYtT+PN3nFktU4nmyICdQJg5No9Mpj/qySbO7vnIT1zJZM+4rg5g38pXZNMb8dZFJiq1jn58DNSlN+6mJk3jzrH/BunwL2fSakZxyz6j/4BevGfCHy0VVTMxsFsGEMIFgBHvBuBCWAH7wbq/RaFMTgsjUUH2XntAG3tKAK99rd74mKcOZy2BMb7VaeBexeCZOM9ASsEavs7iAjk0psA6JaSlDdU+/Ujb7NEeWdKSQGnO7g59wJPRk2GcHeTZCp0jFcG4IruWmgNwqzP7Pl60QQPYl6Eh0nRCtK9Z4xjKE5sK0tdcK8TqmdsbXBvKwRiEWFqqp4aU/IYpGjoQLP6B2LAFM2cSV/XggQBzsR4KcxuPxGAmPynBMCm6TG4sII5kfpg6w1ezgw+Cd5JObgHywCi8r13i93kZ9q7xpsqQzs8UKQVppZyEiAjRXnezfKbdR4yorxh6i
 HpXWqNXi
 R6phggkjyRfshq4p5DXpIrv5LgIiyGqZbHmbXfm5YeSntF/sPAzmeM9cIzNwKQRgyfr9pwAFzicsnvAwDqowoh58z+v+cuMIXBSoM3KRmJ8+MtX6ohqs1OQnSrKOIr6v2Jc71WVFdZpElF4tvcBl2rz4oJj1MyDWL6RpKGLSHqlEnyCepj6fV4aG9YDYNa6Wecq7rpDba1B+YjD8IjUFmswJieNH1AvMfOAx0OkF86vH35TBT3sm/VDl0pJbcyJTBV744Z76y6p7zhG9bvQ2bcOnrdlCJWBG/YNRRWAHu+na6MHd6FIjLKLw/mT3XhBWGHfuqQS1ACbb6EanGz0osrIIdUVwqfkXmxf0mAEya1nba2+lyPT54aPIeVG22PKdGcUe0sm/eVxu+9jTV64CHQRd9TN4EJ60wu2vqh38ajbIeZtip2H44b4NeYz1C8kIfs/zYOLxxLLGQ0vG/fX4IyGCMh91l7lxcWJB370/X4o/Rf5mNDoItiGHMmAxnJcZM74y+jElT92wzvmxAm/8dd79AAKf7DnXR+0Nd68tqRXkR51ewwUBpz4tD7rF70pZkk/S6+uRjJLX+h1i5gC6ezDDIqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 7:15=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Jun 16, 2026 at 11:13=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.=
com> wrote:
> >
> > From: Wenchao Hao <haowenchao@xiaomi.com>
> >
> > With class_idx encoded in obj, zs_free() can locate the size_class
> > without holding pool->lock on 64-bit systems.  Page migration also
> > takes class->lock and only rewrites the PFN field of obj, so:
> >
> >   1. read obj locklessly,
> >   2. lock the size_class derived from obj's class_idx,
> >   3. re-read obj under class->lock to get a stable PFN.
> >
> > This eliminates the rwlock read-side cacheline bouncing between
> > zs_free() and migration/compaction on multi-core systems.
> >
> > Annotate handle_to_obj()/record_obj() with READ_ONCE()/WRITE_ONCE() to
> > prevent load/store tearing on the lockless read path and silence KCSAN
> > data race reports.
> >
> > When ZS_OBJ_CLASS_BITS =3D=3D 0 (32-bit, or 64-bit with obj too narrow =
to
> > hold class_idx), zs_free() keeps pool->lock.
> >
> > Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> > Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
>
> Reviewed-: Barry Song <baohua@kernel.org>
>
> [...]
> > +static inline void obj_handle_class_lock(struct zs_pool *pool, unsigne=
d long handle,
> > +                                        unsigned long *objp, struct zs=
page **zspagep,
> > +                                        struct size_class **classp)
> > +       __acquires(&(*classp)->lock)
> > +{
>
>
> Somehow, I feel that obj_handle_class_lock() is a misleading name.
> The function clearly does more than just handle class locking=E2=80=94it =
also
> retrieves the object and the zspage.
>

Thanks for the suggestion. How about obj_to_class_and_lock()?

This name reflects the two key things the function does:
1. Resolves obj -> class (via class_idx or zspage, depending on arch)
2. Acquires and holds class->lock on return

The "to_class" part captures the lookup/resolution, and "and_lock"
makes the locking responsibility explicit.

> Best Regards
> Barry

