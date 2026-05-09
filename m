Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93566CD3447
	for <linux-mm@archiver.kernel.org>; Sat,  9 May 2026 09:08:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FE76B0310; Sat,  9 May 2026 05:08:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0A96B0311; Sat,  9 May 2026 05:08:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D0446B0312; Sat,  9 May 2026 05:08:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B2446B0310
	for <linux-mm@kvack.org>; Sat,  9 May 2026 05:08:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F0BE4C1B77
	for <linux-mm@kvack.org>; Sat,  9 May 2026 09:08:38 +0000 (UTC)
X-FDA: 84747305916.08.6E69A43
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id D337640009
	for <linux-mm@kvack.org>; Sat,  9 May 2026 09:08:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GxRoKneG;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778317716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVdwEh33FhmGvU050t774z8AFpJQif4TcQfckUPV3TY=;
	b=CtRFenyggL1S+po5C0POBBb1vdvHNW2d9coY+pPtcc9M78wmM6SCt/dvjadM9L2CdCW/H5
	pUa3zqbGRsYc9bUzZDhkDwh5HLggbbMQvwBWx3MjJ9mRC15SqNVPsojg4diwaNVk3Ds1Py
	dCuFvwdyDcSSQGFw2sgbXB/oESD7kRE=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GxRoKneG;
	spf=pass (imf27.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778317716; a=rsa-sha256;
	cv=pass;
	b=urgaguAaojFdKzQeEa7GqtOC1H8jgsznQMXZnBzM8jkN9Ji/jh40SEfBaXkyR23YhprWp4
	wHOtD+Q2toD6I08t6C6sGrPHhw1Qv+mTbIGSYvJ4D6x4GU+MqjMvga28DQZXy0HCdMvB9k
	JEOp2UrCnurFCQwPUQS1acs88hZSAvU=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7bdaa68cf81so27041967b3.3
        for <linux-mm@kvack.org>; Sat, 09 May 2026 02:08:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778317716; cv=none;
        d=google.com; s=arc-20240605;
        b=dZUJHVTfrgZQUCdseAguYUQ5Fq1jYPtwbA/Mce6uJBRe3H6FFfofE+jb2gxgfH8q7O
         bVKdSiC+UtwNUDoz911zHV3Gcc183eEsLoF5qJSGuErLRWN2QEzwNkNSL+bRLiFzKK9c
         2CgnoF84wCoxZROars6jZYAb/hAGbafLJ42Koyvxb2WMgXtBl7p0nBVOBdnRLPygFdRq
         w9p3IeyzVgOaEdygibQy0qHyyjXnkTzYEJdijdbZZuYe6wvNXfDy8+/iqNeP+jnaztSQ
         L6zLFHrhEmD46w+axEY5cx5+FtBowtU+fjShDc7Yne+RVbYIEypbyIaxra7eQXxbx2H0
         xsDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tVdwEh33FhmGvU050t774z8AFpJQif4TcQfckUPV3TY=;
        fh=FqYM22O4tZI2n8icSepTIQJEEdF0iVyG0/C6x0ekYM4=;
        b=UpWVfEeLC7/h2ffpG5mo82EC5endw1gLxAyPtCxhgqfMnWm8CuLooISPx1WyZ4Pfsy
         xL8rUx7P0K+ABC7wtCweinl/Rr4ACEV83cdAYo78/ZY2rMl9UAwjybKJVFd4PrAB2dko
         kERXYkJqUeBiH3cFodxhf1dNaQJkdyH8icDxNceDJ6qrAl5F7uCDV75PKV+xj+xinViO
         0xjQKTQwzpAy8HVecFpl0ms4W6to2o43152QsEkPiVRaNZwq/BSXdMnUSbTxTC5Lm3O2
         w+L0q3+MUcEavhMXTixbPHWd6e+Mctj/NUqSOSjooqqszPY31D1MwOe3KPGVM232UjZF
         jVFQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778317716; x=1778922516; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVdwEh33FhmGvU050t774z8AFpJQif4TcQfckUPV3TY=;
        b=GxRoKneGF/I34DPvgT6cShhQQipz9eDBCrq614NXNPsDkanfUPYzWJpSM7+qL1oevi
         hshKui1dVxhaJDq+6ea4kKGGluRsn+1lUYF6V2rGZru6wgIny+gvgKrwpMFmCXGhvePu
         yhl2N4vIQMq/ceHT7VkS+hn65zhBJzKwhzSsgCE1mato0gp39WtZ9mHwWJCXsFy8H/lC
         jjF3ZNgR+kICiOzPKxrG9K1a1uXHtwqtlsXOhh8jFL9h6qd/dIwJlRyuLV/j6N82qbXI
         p2mTEm+CcHhp+4+mtHGNZmZphbCbxYjsXu9ch1wcPesBP2o01vqpxwP65ODVWgLcFxbs
         uKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778317716; x=1778922516;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tVdwEh33FhmGvU050t774z8AFpJQif4TcQfckUPV3TY=;
        b=m5kY7t8Ljt1BHPTkuZ23ZeT6o2/voUT/+FXdfNxBy7bw/e9PyjIno8fMUHKZm4/fFh
         MOF+ZpTQ+QfNg9eTyh55kb/gegDrN3TlZZ+I8U7gA4g2QizTXqCPO3kM3May1wehr57P
         nidcgJli/dJK4ydoueZ/yyGP4i8r7J3fOm9j0SJePBd94PU6vstaf0htyE63aRf33iZa
         LhR09RXYOcUemoX9TDU9GKOO3mBMruateMe3hG22KU9blQhcGNRoMP02tpOo0ZKpGhqo
         LV7WzELOQN7vF4l/42DXkJPGFkxtw1zTPvwGipSuadBwUMELYHOSnDkghy2S54NJ/1IU
         X8WA==
X-Forwarded-Encrypted: i=1; AFNElJ85uYP08hfzS7iGoIj/X3OMaTOCid66D3CuDNwe1kYUIPT4+FAKCuLra03qkZDPmt9om6wHC+l0+g==@kvack.org
X-Gm-Message-State: AOJu0YwZ/aibnCk5yTYSTn9Hn/3v6I6HDA7mYkwlqanJdmPIg5+i06SF
	Pl9sDw1kpWmEYIRjf9ryBZKGn7vPTM/CEoVA/mbOuNC4d0cvrStYFBvPHGQQpvE9ursYLN8MByk
	hLXVOTme9WN0YdEXY6C8gQxGkVdbqtII=
X-Gm-Gg: Acq92OFFJ83JsUxIhvSBhmOACape39kcxv2vbShD7tcxOvbLlBWH8BQJIaKBACd90DS
	ZU1b/2xwzfFq1bv7yuFdUMjwaPUoBx16Pp+4cRuy8Is5vJy1n4c2jtTpuKZMeW7vQYQHUL1yxTi
	kOD21nq3kaWwLTvpwvIEKiTS4VLG9/110dFowpGwBJXu8/I+pUxNZbtU/EkwPaqxBjsuYlUmocf
	8MIhC38x1pN4ETYF5fkSMYDCf95mmwp83SwqhGhC63m8hQGdZmbQwwEFImViidfPkMHAFzDqwh/
	iG2zNymf
X-Received: by 2002:a05:690c:d94:b0:7bf:107b:f859 with SMTP id
 00721157ae682-7bf107c07f3mr101380657b3.16.1778317715853; Sat, 09 May 2026
 02:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
 <CAKEwX=PrfrNys4ao7-d11J7r4pv5VmE8gTU_7iUHaHAKNaFuBQ@mail.gmail.com>
 <CAOptpSOnRCHo35KK5x3S0f5y9+7+dxfznpjNRH072jZvhYHwww@mail.gmail.com> <CAKEwX=PgsM4Z0URJcF5VSXX_jdy-cAs2JxDCCR1a8CGwV4tCAg@mail.gmail.com>
In-Reply-To: <CAKEwX=PgsM4Z0URJcF5VSXX_jdy-cAs2JxDCCR1a8CGwV4tCAg@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Sat, 9 May 2026 17:08:24 +0800
X-Gm-Features: AVHnY4IXrMEe_-uQNRtiTfBHiBqbclVoh00lPISlO6-0pAUXbq9BaSPyawX3d1U
Message-ID: <CAOptpSMdFwQUxT7bP7s1GWyXvzUQrg3ROtGp3w_zYy2rSkDYRQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rntj8biwhs3jpn1nz8ooybr674gmyr83
X-Rspamd-Queue-Id: D337640009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778317716-69514
X-HE-Meta: U2FsdGVkX1+OQxWQRDo5WEnEHsBoqx1k0qUcydZHElnxggMLs681t3xLUcnvY+RZ0l4gtszKEccCnJnw1akNllGaYyJSefZontBUeVpzpkggkJw6ccDirOLFVYN+xiMXJEG3ddEWlDqvoXAMLyCn08kLj19+yszuXNSOnAbrp+8fWiAaMEplpEWbSTUqjUxdJFPvYhZWpLwhBqlSMh1EdsAUmruavuIiFfAGE6c4EaoXZFtijVfXbkT4sbZQLH8RLjhx9uhvitZZ2kHr4WmKt1KltADTZapYICZ5+I1DBTgPtSZXq748b+SLNsnN6c7QYS3Cy/jV0ujSIpX7SRuhv3EWLC4/NujzcXtJGL5Kx2z0swbWcpQDaaZxoCUi1j2ha/VDSscGZNfTrm/nq953bv6B5fBeXMTjmeu2Q/biOqqAcCSks0kmlTzufAcz1ZY3rR4Pb9y9XWvfhZEfeq4IhCzS9BoGlrY+fhmt9nIzdnS87J4u098NzbKm+13QxcQA7CDxGugCFYmcpncARJwNt7AJxu+eGte0lUq17wXpieXvYIHMNiJU973IEvWYtWOx4ZRmc63sIoCLUqal4Il/iM3cra6jmujMIKm7HvmNoHQegJDfjPvy1FqsW+cf9/6roOWrjkvk6U3QraALxepAZzj3ruPXxIlX+2s5HzD6fnS0FMBGuJP/HA0JJe/WKf4tPX+qnifceHT+wHNXAu3R8IL7O/1FP8nE5yYJ/T/43CD0v9qL6AmtWRd8m2Y+4sY73mWEkK/6pAfrokyA/uGhAyzMvi7+wXUgJOL6nd+izIjI/Y39+Z6XNaYlzTGaF9LhGrU1jubhG2pFcdpGhOX4a1sUPL23Eg0zAwPUSUSiZb00LZQ6ogrKN1jg4EjQaOiIUp4cKUM7Jwf7t+IU1dmYFVcWbJLQG5NmDE6cxJo5jfoItOy9lriUlGDYnkUHnIuYXEs0OYk7yM4XivxGX9I
 u9+ZfpDQ
 +ToTSuNtJ9GNz4hZkH4qB4p8QOmDJOpD2OExz7MN+kl9pMYVov7hI3c/nO5YMdz3BpcgaR+k0dbuzNA8lIRwwazZoEMK3lSQYxpV4k2ZcJIOJ8O3nI938M5roC4U6aAU3M66E/wtv08YlFOqhWKUgKaRwpF3rXpJU/e2cuIe5g53QC2DfyBsOE6IG/YhSDvcVwrrW3KDeoAtH8jOF3bqjGfIdL2CojXiGhzL9rVUcyXa/cNgPTm59mote+ov8sUASCUqAqCeLzRqzpkCcDSyxMzs8Wkuek2Z9mPgAPnc2DLqhZepmyKi7vx5weCvDO5U68auTv+BTHQ5vpYs5CEDD8ekoC53knhqyEShG/+Q/gJ3KTb76GyGVNwYJLcDz34GlM5z1kWSwvcxsJ7H2MmtYJ737cUihNqcsZB26jx1KDjN/034Y4QtpEyibDCv2dcDTvGs6jGz9N1p43gWZS/gqDqBTwh4hI8tZ5/tk3u1MJ4fBROLYbrcSxw+8CtV/xclpaDT3zU+FbyMlTBid0pD1KVIKboYGett9PLnfiQNQGu46YLY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, May 9, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Wed, May 6, 2026 at 6:55=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
> >
> > On Sat, May 2, 2026 at 3:21=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> > >
> > >
> > > Oh man, you are eliminating pool lock here right? This would help my
> > > other patch series a lot too :)
> > >
> > > https://lore.kernel.org/all/CAKEwX=3DM5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWo=
dwbf1Fe=3Dgzew@mail.gmail.com/
> > > https://lore.kernel.org/all/CAKEwX=3DPkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2=
BNNA8RboOFDQ@mail.gmail.com/
> > >
> >
> > Yes, exactly. With class_idx encoded in the obj value,
> > zs_free() can determine the correct size_class without
> > any pool-level lock. The lockless read gives a valid
> > class_idx because it's invariant across migration (only
> > PFN changes), and we re-read obj under class->lock to
> > get a stable PFN.
> >
> > >
> > > /*
> > > * The pool->lock protects the race with zpage's migration
> > > * so it's safe to get the page from handle.
> > > */
> > > read_lock(&pool->lock);
> > > obj =3D handle_to_obj(handle);
> > > obj_to_zpdesc(obj, &f_zpdesc);
> > > zspage =3D get_zspage(f_zpdesc);
> > > class =3D zspage_class(pool, zspage);
> > > spin_lock(&class->lock);
> > > read_unlock(&pool->lock);
> > >
> > > It's basically just this blob right?
> > >
> >
> > Yes, that's the blob being replaced. On the
> > ZS_OBJ_CLASS_IDX path (64-bit systems), it becomes:
> >
> >     obj =3D handle_to_obj(handle);
> >     class =3D pool->size_class[obj_to_class_idx(obj)];
> >     spin_lock(&class->lock);
> >     obj =3D handle_to_obj(handle); /* re-read for stable PFN */
> >
> > No pool->lock at all. We've also added compile-time
> > gating (#if BITS_PER_LONG >=3D 64) since 32-bit systems
> > lack the spare bits in OBJ_INDEX to fit class_idx. On
> > 32-bit, it falls back to the original pool->lock path.
> >
>
> BTW, I've tested your idea with a hacky prototype, when I was playing
> with my vswap series. It absolutely improves free time in the usemem
> benchmark :) Idea is very promising - I won't scoop your work of
> course, just letting you know that at least in my use case, it works
> :) Look forward to seeing it submitted soon!!!

Thanks, Nhat, that's great to hear.

I've split this part out and posted it as its own series:

  https://lore.kernel.org/linux-mm/20260508061910.3882831-1-haowenchao@xiao=
mi.com

Review there would be very welcome.

Also, could you share the details of your usemem setup? I'd like
to reproduce it locally on the same baseline.

Thanks,
Wenchao

