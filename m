Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88E8ECD8CA8
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 01:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 354496B0005; Sun, 14 Jun 2026 21:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3053B6B008A; Sun, 14 Jun 2026 21:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F4F86B008C; Sun, 14 Jun 2026 21:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0406B0005
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:28:44 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6C36F140860
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:28:43 +0000 (UTC)
X-FDA: 84880412526.25.8FE5112
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6EECCA0006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:28:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dgrrcn5p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781486921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULCiQmh3Fr57rxfPWnrO4oKZXSzYPIWseb5cOe0Q/Q0=;
	b=gfECP43RVJ7mJpR3qYMpwJyefosz+9b540X4A+hKt0tYO+oR/lMgHaA654qH+KMrJexD4v
	zdQ8EU69Stp/AmQ31A0cwuU8BrPoc4yePLjK7p4Xinb9lV+FR/RS4uScuPApAWRzyRkjMX
	rZhOgv1vvo7eGjjrNclgPYdgtxh5sEY=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Dgrrcn5p;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781486921;
	b=pB2y3h6WJ1FwzmVnPhsexXEua5xBn5EkgVxBMejbkOJecJTINTqwD4e+ynkJ2kC4xTXo/M
	kQ8HobDNxqT6l97Gr11zH1F9k8hnmNT3QkcAe+BEdGx6lBhtNnjWlMCtjVJCgGqSt4bZ7M
	E+oOAAhI4tJyRCJdRxNTM5ysxHd6f3s=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51765531803so800131cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 18:28:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781486920; cv=none;
        d=google.com; s=arc-20240605;
        b=iGy7TUxK4siuGtV18IKl4L6GyRJvyRFAgHYkNoXRUY6tk138eExJ8Rzr8Vv+K4lwWT
         AJHbo+sq9YtHUVFSniDVpgNkNv4EHNmf7VLN/eX20sqfD9VamM/Xv1ElCi4E338Dky3I
         6hUSoFFhMar2tvtPpACICnqHf4SuXEYfK91T6Gj/J0uq7uNJ4Y7CeKDF1+6PTcCTCqMj
         XuaOIU+UzSEOPdOD4bnwfLkZb8pNZD5YPKruQ6BT9wutRjgfPokJqJP5vrDrH4YGGnS1
         P9zDDQ+HgeLA3nc0o9xwk4Zp4gZuAP4SAD0wGWIRn/9uoKv53ujN1cVo4YS3aIXbAM7f
         bnng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ULCiQmh3Fr57rxfPWnrO4oKZXSzYPIWseb5cOe0Q/Q0=;
        fh=lSSc7eIzHjgTYn7S436iFgBDNj9qwx2Z5Et4rthUnhg=;
        b=LeTfyTRZUEgp/tig4THuxLCtKdORZ7UiQGsgxPG87e7GsYhhbNlM65YaGyOuUtUXdF
         /kBmXC67RVHCbIvPDhVKPIOXdvmVBKcc1682jgBvhgaWZwPsozHBvNe/IIgXVxy11Mer
         MuUeMew484RK4X9jMyE6pTDL1RNB4pngaCBA+Wx6Q4lnhG8+yYWc0PmUO8v96Les8L9y
         JSCcT5N73uxzkfQGt9xTEkj7V475147llIoFC3C4FOX+mN4WX6MmadBYRayzTJrfHgjO
         PppwkifG/u/5/lY2rZdUXDCwhDXNrIcCeRf+cEiYyMLkP8ZtqrLBewL5f0lIqsfbdt3T
         3rNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781486920; x=1782091720; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ULCiQmh3Fr57rxfPWnrO4oKZXSzYPIWseb5cOe0Q/Q0=;
        b=Dgrrcn5pxGwtT1zcNpGvnkEyLNGOb2NX0thagz8pDJ9syJWxHroYl+h139G/tO073/
         zrip0b+d0BYplHE08sfHsx4JEGmz+0uxV2z1sslABv1H7zv7/EdjNfPAym9gn/jn4K9W
         oPMqJQfLznf4iJ57l7DeOQF+hZsADV+eAr/VrCEJH37GrXMhjrUIDfEZNoxZEh4OT/4a
         as7eM3HBqM7w/MXTx7qcFJ4WGUYPMG2fW5eFHwofSWYyi/qCihBNrmd/vz/06lJSGMgj
         jgQkmAlsXQXzaSMhQkuTM4ENhJ6INuFZUO/ihfOPuFcvahQThYW7m1jerE0v5i/B+xUT
         YrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781486920; x=1782091720;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ULCiQmh3Fr57rxfPWnrO4oKZXSzYPIWseb5cOe0Q/Q0=;
        b=nUwLbQECInfg5hdJdGWnxvMbrgkvqMGRSH3D9ODW25bBzGhQEo2LlYXHR0qZT9PHGX
         q/7TTnkn6UwNxAQ2DyExWtasQ3PNJ8gHoOk+G3KEAVM7OXb0hECgpovKonmC5AVVZPyt
         3ORCId50WJc8lUsDCVWUuSIJ2X3vRZm+MJ6dBV7gX+BsQiKk0GSAm3AZb8K4M8kDZse9
         tbmFdZ49O6Dt3NQ7orRsr7ypQ7wYuq5Hv0OxgKtpDLmdPAvfDAURy5CYe5jfV1at+GRn
         trNejwQ6+JXaL/LJc0ueBRrQrw2HYqzGklUNDJc77kirYPSPtHdpuZmL5m652yKAgz/S
         WH2g==
X-Forwarded-Encrypted: i=1; AFNElJ9YuwaeBJytIlEj7VQn1HKM/0SVuyHzit0fp1Pu+OuOjrH8qy25H8PMj/zpTScO4yGvti29Xff0ig==@kvack.org
X-Gm-Message-State: AOJu0YzZ4BD3gWwa+A/jRlqFl2zwRIaOzPNshX2bOnebjtxl6b5uj00b
	DA3Ty/GnZLws8H5My10muRr4TSkNyTEeYq+nARMuflvQ89QDdR/9Xmja58S4SxEoHBB9s32deJS
	ZoSnUCZ2EfWstymD/g2/DWv4/aFNQtEiKCO/EAWhY
X-Gm-Gg: Acq92OEbHfzqu2XNpfKJ0YD/o8Ywrpce8VAZ27k5qGDVzJGLgsL2RIZEEeoFhOVwbZY
	Hbwx0TNh7XzP7r9POOQV0FxCXlR5AIaYBwMNcJx8DPFnvEONdLXL61tZFYy8l7xHqNG7IvWmooY
	3Zgo3KX+nNM9cW/ClTZTmtr+dtVGrU7FQzGjlNr/4po9mwOf47pF14E/NU2mm5CynEe2fzWLqGE
	BTXodQmkWeXXHdrt1TNMkLH8QR4uywivV2NHBND6j5phREsuXZlWEgjM/FbT+z8qbSlHkAufwx1
	EMoRtQ==
X-Received: by 2002:ac8:5785:0:b0:517:38aa:c2b3 with SMTP id
 d75a77b69052e-519549f8a99mr12415291cf.14.1781486919930; Sun, 14 Jun 2026
 18:28:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-2-7190909db118@kernel.org> <b6530e92-d648-4028-9e77-0df8c3ab166d@kernel.org>
 <159d1e20-5b21-4329-ac9a-f7a5cb0fd56a@kernel.org> <e71bfc13-c233-4f85-a6ec-76327d3c6510@kernel.org>
 <74adf668-78c2-4989-a6c6-c6ec7bd68855@kernel.org> <4cf98483-ae35-4ad0-8f77-5a46194eb65f@kernel.org>
In-Reply-To: <4cf98483-ae35-4ad0-8f77-5a46194eb65f@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 18:28:29 -0700
X-Gm-Features: AVVi8CeJscivUYBempgvh_YTouGssLUsWYrE-XuqGN36nJ9_C6J7p37pzGF9m8A
Message-ID: <CAJuCfpH8g9mNGV_ke-mhVZ=J9J05PZg-ozPTA=5WQrm_eViVpA@mail.gmail.com>
Subject: Re: [PATCH v2 02/16] mm/slab: do not init any kfence objects on allocation
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6EECCA0006
X-Stat-Signature: p9irny7hhemrtr7d17pdsmygkjmy54zd
X-Rspam-User: 
X-HE-Tag: 1781486921-438350
X-HE-Meta: U2FsdGVkX1/HuSVXegnH/Y4urEcJMYF0NToVs4eB99EirZci9Ysyx5j3xNsfdS1/WaNz7E0byixr9n+ohfZ+B0kVWtHXvpmffvIEt2kV7zphYE2UZ+tFai/QebWsX6UEfMDUwYzXJZxP5fRx3rm3StkRPWC832WpmCL2JxlL/RHL9iCD8NlqpXXMTa86yqnAWn9ucbWKU0uFisaTAV2AUeCMnMwLpnx6Sa1esRp7PYH3+jVydv9Fg37GZOAbpaEvfOOtDjmlOkRUWWWhgMe4ENLcVDqZJpVgUX6QFJiZW6mS9uNoHTbI4KSwaWCoC5uZR7wuVJcFb+v2J8FNpJNW9FcwuKOXePlRqPT35Mg+STGSXbemdh3TcjUYqKSqhVvJTE+Fmha5s7FN0sqXPpQ6fx8lEzTNngXu8jRVjlv6U2mKXcTG9VzxmUznqfw8eZb/LRAD5uSn5LYFnoyeHei74RmzQhTN5PXNyXh7nPQgiZfiFOg8IJUlWefuWQeZCnBvng02ydrcwcDQqO7szIvPHWBxRLj9OZYmHtEgFDrBc5YNayYsNea7R08+9Mm14qEBkXan/tjyIzScTi50bK46Kv/4bl0rLRPFCfAhqwDUXxWd2XfErDQaH2xH+CQS5lKuOcgk5IZ2GprqqhUD1HHHH0/0OOacXEo7/M3FtFhlvAWpsAsZhXT1BY/tqlQtO9cetwrUjmubrrlFMMYOGoytb6eMADDozYpPFuiBqIHAx0C76uvZGGW2AttnmDmQRvtYIvLEUW3qwTTPlG+80JZ1wRpOeN4v9oB9kQUJS3TMmksMpjnQf+O1o6bu6YGFMuSrwqhmyVkc1c/Iy+VeNuhzUlmmOAmt60oQv6dOhVEMP2pFoFc/NMzpdZWyDsLVTITFHUYAwEjIi1Q/zUWL01Xkps3Q2pSwdSh8ixsB9R7WGx9GSAEtIui+RgASiMEYlrkz6yS/d7VmM61fWUI+SYO
 Fhc/dW69
 PDbcZue+GA6yc3wFIRPjjsJrJUlMBkI3eWsiA7ssY6xVz5xv33wG/F2IRv8JQhGCsLH74fhHfyWfZb8do+8Old7IHBKePXWugTZgl5E9WMG+hQhVL4ur0zldw/2BsPBHyGjvo0ozzH+elRtus/9cYaGchOhZV1O8VACuT20Sy3yV23eFcXvP290jrg4hcrnFl9F5OM9Gaow2eOUuLwnfqw462V7SGSnVy8ibI+BjLEJebO7F84/k1noJsC8xXlRA0q5jpfOdLE5aC3bYaZ2/8O65+OoGfQCOiDIdmCusDvv+yR+pth7bCEnAktodP7sLMYnDWkwnW3k1pclPpOGHYmWuWOvrCQ5HMvu7rHaEziuZgc2D0BeiAeEQQvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 9:37=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/11/26 17:11, Harry Yoo wrote:
> >
> >> From 3a1c4398ce9f361a4e6f4d9946eab6237eea89c2 Mon Sep 17 00:00:00 2001
> >> From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
> >> Date: Wed, 10 Jun 2026 17:40:04 +0200
> >> Subject: [PATCH] mm/slab: do not init any kfence objects on allocation
> >>
> >> When init (zeroing) on allocation is requested, for kmalloc() we
> >> generally have to zero the full object size even if a smaller size is
> >> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
> >>
> >> When we end up allocating a kfence object, kfence perfoms the zeroing =
on
> >
> > nit: perfoms -> performs
>
> Fixed.
>
> >> its own because has its own redzone beyond the requested size. Thus

nit: s/because has/because it has

> >> slab_post_alloc_hook() has an 'init' parameter which has to be evaluat=
ed
> >> in all callers (via slab_want_init_on_alloc()) and should be false for
> >> kfence allocations.
> >>
> >> For kfence allocations in slab_alloc_node() this is achieved by subtly
> >> skipping over the slab_want_init_on_alloc() call. Other callers (i.e.
> >> kmem_cache_alloc_bulk_noprof()) however evaluate it unconditionally ev=
en
> >> if they do end up with a kfence allocation. This is only subtly not a
> >> problem, as those are not kmalloc allocations and thus the "requested
> >> size" equals s->object_size and thus it cannot interfere with kfence's
> >> redzone. There's just a unnecessary double zeroing (in both kfence and
> >> slab_post_alloc_hook()), but it's all very fragile and contradicts the
> >> comment in kfence_guarded_alloc().
> >>
> >> Remove this subtlety and simplify the code by eliminating the init
> >> parameter from slab_post_alloc_hook() and make it call
> >> slab_want_init_on_alloc() itself. Instead add a is_kfence_address()
> >> check before performing the memset, which will start doing the right
> >> thing for all callers of slab_post_alloc_hook().
> >>
> >> This potentially adds overhead of the is_kfence_address() check to
> >> allocation hotpath, but that one is designed to be as small as possibl=
e,
> >> and it's only evaluated if zeroing is about to happen. This means (asi=
de
> >> from init_on_alloc hardening) only for __GFP_ZERO allocations, and the
> >> zeroing itself comes with an overhead likely larger than the added
> >> check.
> >
> >> While at it, refactor the handling of evaluating when KASAN does the
> >> init instead of SLUB, with no intended functional changes. A
> >> non-functional change is that we don't pass kasan_init as true to
> >> kasan_slab_alloc() if kasan has no integrated init, but then the value
> >> is ignored anyway, so it's theoretically more correct.
> >
> > Right.
> >
> >> Thanks to Harry Yoo for the initial refactoring attempt, and for updat=
ed
> >> comments that are used here.
> >
> > No problem ;)
> >
> >> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-2-7190909d=
b118@kernel.org
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >
> > Looks good to me,
> > Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks!
>
> > Thanks!
> >
>

