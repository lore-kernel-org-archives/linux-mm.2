Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE17CD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 14:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7366B0095; Wed, 17 Jun 2026 10:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57606B0098; Wed, 17 Jun 2026 10:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46226B00B0; Wed, 17 Jun 2026 10:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 612466B0095
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 10:53:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD2A64048C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:53:10 +0000 (UTC)
X-FDA: 84889697340.03.3C06E26
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id B7E34180013
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 14:53:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=piUyqm2O;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781707988;
	b=nTcOC71WCwpkOWqJzO2NJhst981RgKkFR65NbV2Tt0CEjxHnZehum4WxCfCAYiLxdQcMZh
	kEwfRd6lfhu+ZJUUWmnKfGaFmxZ1z450D03TewMhiGMdJ/4y0Br9et9MnoBKOCRPHA+hLy
	NCy6ZUyD4A+803qiuY1RJEnS950PYIE=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=piUyqm2O;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781707988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imP592S/J1YQwMh8N5xD0EL+dcF6p17iby1WiuK/NnQ=;
	b=bRHZpvMexNT0i3jHPO3VhgGScb+i1hLdiuVJyauC59NDMuCPhRgoICJGBCmnJy8cbFgJTD
	HgGP7LUbxelTkUZ9Cyxso6w3aA+Cq9zWLfRNKh6ASPlcckHbF4kmjMuEaYfRZqtUcLFgaY
	RIiZ/LEsEuZrt8SWHLD0iLWjWZWbzjw=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-5177d1ff061so269971cf.1
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:53:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781707988; cv=none;
        d=google.com; s=arc-20240605;
        b=KMawlW/sUbhqIeGGzAnHdKyQLmDTtZJE+mmdGmN3CYRuSGaDcpCEB/+jbPKbDZV/GH
         /GbBxiG8KZVbkiplVu5TDvtySq1AqwK/NVF3AkFL/7YCPv7/ZVAPtvRJVSbH13AigJD7
         DdgBppifkenReVkmYsuh+JyGUskVWVtPqzocRVeM4DcSRyT9gG/TRYACITS2P9r+446B
         NNSGOiy/gpvgYppuOJkbFXetB1ZPSNvAkOt2etEy3F9W0V/02DD1hnWttzX5BHqozHd3
         e3CMtMvKPYnhO0c9pKZC1skAwoB5EANCHaQR/fGoEfvMYPuPs7+cb2gxaoLqURL3Oe9v
         guLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=imP592S/J1YQwMh8N5xD0EL+dcF6p17iby1WiuK/NnQ=;
        fh=0Wc+NgYtb8XBtBD/WPP8Vd1YyLExHCaDoDpnJ94TcBw=;
        b=W5XZgfxiT5nyYKwpmz7erJnYGHZ/8fT7dncMuuvi0ixA3j5YRN+KbDNnRQ4kohivjM
         3cuAlBXiBuJE/iyBrWRp8xB3WpQhciBhIJhKUSNa3LAI+/geoRk/bnjxp0urVKmZWC4h
         /PZLuFoN0x1RKhVu0tXuN8AmMsyZ5TKJ/urrJJbp1AsDML1ykQmOQjE0U4o2+Sd2RkV7
         gfi5jICr1fSIuL084Tz4sU7NBgbNckFj2yo46wQTL5kH0SIqqjDNma7T5Ve7vDRUyaFo
         G5FnyesCFHP8EGpWgT2XJNNOxkajL0nz/Y9ReQynCEtIY5Kmdr9MRniOnkH+qCZzQ3YI
         mpgQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781707988; x=1782312788; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=imP592S/J1YQwMh8N5xD0EL+dcF6p17iby1WiuK/NnQ=;
        b=piUyqm2O91jnovFQPssD+9UVX0KmCHbfP85+ZBbx95tPft4ibU+iyFzhwydOx9FQBN
         YHgOZvNCnqYEhlKdl+Ph6zsmLS7tgT5dxTLuag7+StChLj0Ykr4x4KBPV2ppZgsba+uQ
         UJlcXGVk2A//tq+tUu3ZzDDjdArlLEhGNLXZymwi6sOrfkSXdBj9Wn+nOwNZ6i08GUR7
         TNi3AS3K8pYW7HH5jpjsAAYoWTDCGgNKCKr9AqXAxNw+pvEHLTkjUBGM5VBgZZ2dQuNN
         SHglw/t14eABa+xIkxZVPVxmcyldIBnNBTOsN7OYyT1IIzh3mIASqAFLid89IpVk6Bc4
         z0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781707988; x=1782312788;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=imP592S/J1YQwMh8N5xD0EL+dcF6p17iby1WiuK/NnQ=;
        b=V3bAEZjhQx9CW9XvwfGBlMNHjZ6xWYAJT79KWHY2vSWR8QeFOsVdRWbFm/Hyu/keuH
         ZdiTPlurjJ2lwd2KUuyEBjW5t7qK9NxlRa8ld1FZifMm2ah0jR2bvMfT8pPRjG8x9pkw
         g3QM/qCc7OSB1PcEcd3Ag81DGeqKggK7aPc9XkXs5JEYlrDm5Aob4XQDYt8W1hrIE4B3
         D6PCzvOFpEb8cL/Ces2cGdJtRJogRDMkowdsOvo7pQiRh9xK5Kx741Gi4ZDo80z2NP5i
         fjSujLAlE39GB9h6ruw8EPFR+iKCgkd0IAm/eQj+X7o+0soRRwzAgZMJ4r85aW8cgz0U
         Wy+Q==
X-Forwarded-Encrypted: i=1; AFNElJ/wm66GmkkV4eYOWD+r+izpI8I7envo+zp/PiTIuesrA72ZsD7lLZqz5Jid0vcuyr4zQxCahKQ5Lg==@kvack.org
X-Gm-Message-State: AOJu0YydZr34HewEX1D5b3BhdHCnMJG/4gvOUW+TikarLABz9PNj5Uml
	IuE5nXr1mSF4eM1kh5NJ7ucZN45aZK/NSRSZFnAwqMQMzC2U3VfCixeLsbc+hR1Pc4R40y/xi7R
	2dhdPYR/DUt2JO/mdIyo6FM/nIhrBu+T6KrAN6F9D
X-Gm-Gg: Acq92OEGjsTjxz14D9S+Y5ljFzov40uay+rPzrg4Ry9lCGcfXcA1I1myRzEd2WryJVa
	+1SUbI0AAYzUGhYyXgo/WXctx1H21uHVM2zzWivBhFudhw/9MZABtUlx1v75gl/VCMqrRpKausz
	YialUi5kt+8tvepOzpDO8eqJWZObxSKbK8F0Crqt2XMMSYkeIxrpGVZoLJQR1iak+u3chMvbBeT
	0BPZaNBBLnsAVE9Bk9n5fkRpQTlC668F6rDZqrkJa7tuB+VeG/YyawishGDhbe6M5jRoPXCjuwA
	sqETcESPjmr+LiqFyRRj4MoQKV3emu31Z6SDqw==
X-Received: by 2002:a05:622a:5884:b0:517:5e32:2d14 with SMTP id
 d75a77b69052e-519aa962ed6mr10795791cf.10.1781707987103; Wed, 17 Jun 2026
 07:53:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-11-ce1146d140fb@kernel.org> <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
In-Reply-To: <e499bab7-9217-4bac-848c-fb1472cd2c00@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 17 Jun 2026 07:52:55 -0700
X-Gm-Features: AVVi8CeovpdgMDaFWVo5H90cEy5_jKLmId74VoKLgJA87ZiYXZ9qXRIxXzrMQ-A
Message-ID: <CAJuCfpHLAnDUrxmVSNL0L-KCO8-dv8-r5ugPJ-naJZ6ox-7CNw@mail.gmail.com>
Subject: Re: [PATCH v3 11/15] mm/slab: pass slab_alloc_context to __do_kmalloc_node()
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B7E34180013
X-Stat-Signature: d7cpiddwmmizt9h8cnb7dwsj77qbew5s
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781707988-353474
X-HE-Meta: U2FsdGVkX198No0Bd9/6j4QAwVcf+73H9AZQBxUFRBR/48CcVJ3e6Z8FWCcC4h4WnbKBz20u4nSn1Qz30wGnM6dWozv40WlSH9vheegf1u1xp5Otyc1L6Sweaf9aeQ+Hh2veoJCa/Evi9hIoqDZedmynreHs7W1KE2NM9y/rL6LRkPGb7drYihN8eGx9i5ClRCOrWAgjZW1w3tbbObvFE9VVoie4lAMi8PnKlLRLQvt3x9E6ONxkbiehxME+dqHudG0Dn4Mu1mwhIg3cVt9cZHqJ63XjexOZRIupmxrTn9SPpohKKRuZ3apNO34RuN3gKtiwM/ziRdqdpkLvLzDbmXDDfW+vy03Glu+gzsnw7IWbOYC9+L85TQrojKZl1WPiJbnVvY7nR1yag9pPQvaG6MHbaYvYhOI0Uy2VqsG8XPkfFniHEymrQZFccEbLk87jXC+wzPETrkXmhv7pWuFD7fNXWbnXRliv8XCbuqeTVF/1oov4/wVy9yxewEqVbTPeUSVOXr2daODLqMsrKRBeG3I9RQJ3JxKwEjZswbXPZ+1o8QnqXVdBTAlfxaXkXu5Es+GyBhVx3458mf0xh8YbHntRc0YO7nm0SALBt14hUwf1F85ECTcYe3bXvpXNGAyDszLsPALkRKVpwTLPPP/++f8LMd78woXjDv1s93CNykrUYkKFi4sYplXTBeYyHzHJNI8EuwL9v9w38NBcp4Fz1K4ChlYYfG/dnWQu3aKktgEnywf8JsKwzxZ8BleurR2zs14A//sAVqkOLuZ0xTNnOTYTDWiZnVOlWiVJp4dhf3kCC++UCx0BKWkNzYd+3qWYh3moWuUKi5ahf59Haphl8RW+dgzRSLSV55WbRaCpB11F18HR4LwBYQ96YhVRyNnjDDZeOyxtBYCW2vtrCjy9t2jHxveISY52iVfL4eXlwB0VSYoXvmeP3D0AkHZM8RoXOWtTGoKAQ5YACQuh27N
 HL8YclN5
 jTQBJNRfbTsFKxS/Gj5HuqqfL7VEX72x69Sq20/RT8+Mya/wRma9kq66U8A0ihnXtjbycMq7QChlOOQssvwOQXvB+DwrOBeprUrGRajIf6dYWwW27zZjTvoa2QQ3kGVmvwPNhrHq0txYzEQytleEi1UQ2zcOfTVYsNW596THGv0esYXdi7CGHtItoP6vUQAGGGPKNJFqVD4A0ZmQwT7nZw3Y0A2jvXslaRbMNYPUDxSCD24EOaY3NidPwedQqMGV9eh4y6+kcZ84d+c4IWogPC+kcnnRBz2XXRRN8CcNR1SN+U15SOf7MYZQqNVHSJ6WxywDMDA85PEZYnZpWD6ziyfrNZLUiJPEiF1kTDySjSL0knxdr1OTI8kQlvkMmWYuWVUdrFXstBkmATqHrzivL7BCP980r8GwZO9WN6uAc1Rf1Mko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 2:36=E2=80=AFAM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/15/26 8:54 PM, Vlastimil Babka (SUSE) wrote:
> > With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> > alloc flag that prevents kmalloc recursion. For that we need a version
> > of kmalloc() that takes alloc_flags and use it in places that perform
> > these potentially recursive kmalloc allocations (of sheaves or obj_ext
> > arrays).
> >
> > As a preparatory step, make __do_kmalloc_node() take a pointer to
> > slab_alloc_context. This replaces the 'size' and 'caller' parameters an=
d
> > includes alloc_flags which we'll make use of.
> >
> > Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-12-7190909d=
b118@kernel.org
> > Reviewed-by: Hao Li <hao.li@linux.dev>
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Looks good to me,
> Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


>
> --
> Cheers,
> Harry / Hyeonggon

