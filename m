Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAEECCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 17:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4D6C6B0088; Fri,  9 Oct 2026 13:27:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FF026B008A; Fri,  9 Oct 2026 13:27:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED9C6B008C; Fri,  9 Oct 2026 13:27:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D316B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:27:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CB47CA04B8
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:27:43 +0000 (UTC)
X-FDA: 85303770006.28.A16D308
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7E1C2000E
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:27:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhZUffgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791566862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CqBnW54Mbv9AWJM08eruBqtBpvvm1r80uZxZrFNmgvs=;
	b=7VenBdk2+1vIek89mRbCBmSuuGp5e02O7tbIkZIoiNENHo5yVv7fSWcwj568tFiGGmfCT3
	Zzyb8DS+z5diA7skBXwcWh8lCWav7O7bgVWzSvGvusfcQkM+6Q2cOlbhqqM8L+Em9Fteie
	ZIy+dVOHcojj6CxOTyVqYZPfmfbZxlg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jhZUffgw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791566862;
	b=6f/6sDJWZwJh+tZakhltX0wCq+DKF67xiDIk6aWGu6KFrdcYQY4Fv2+S6hT/AcK/BK83B5
	NhhBqmdr96FJa6qzAyicHQSNTmvXy4+4adVr82W09+4yYmiecUM+0mEcsY0AivH0TUywT4
	s14ULRheXJJz8Szr8fZfKVmC/BnC2vs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FD53447AE
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA9AD1F0089A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 17:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791566861;
	bh=CqBnW54Mbv9AWJM08eruBqtBpvvm1r80uZxZrFNmgvs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=jhZUffgwlAS6wC2s2xzcHOiq4QUKrA84lp6i/yPUymZq04eYhn3KwWYGRFJGTHbUR
	 NSsDbFf+nmoBxp+JdTUw0UuWMpvxCKK/lGrUYZ+6zmQeZ+icuhCYC6sOmDOZ+YtASh
	 vW1LVRvN9i9HhmTwORiaKaFRSgyJj5hIsAQIu+b7gBU47ZLTUimjkvqrAUWwbdARRh
	 mQYFKRbgl1QoXHbVm0C6hSxL9+vk0bSXlHrki/r3pgMMQKvZ+vQ36Lw+ZkE+hFi7I7
	 /NW9wdElKUEQVP+af6WrkCNMO+tNrLyPIONjqfqSkughEkp8hVw/Dn6Vlc146xLNd3
	 8CLWcevcbsyyA==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91b64fb6010so2827476d6.1
        for <linux-mm@kvack.org>; Fri, 09 Oct 2026 10:27:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByoPUWJfwnsixNIWnowR1683n/3OQOj836Fmrk/NRLZhD9oJ1Ww2n8qlSD4bWw8sIbGT2VDDwJdtg==@kvack.org
X-Gm-Message-State: AFq9FYKgsK4Tnvc7VrefXmKdHjQM0enGGn8wonwOBExvTEoSqMrX5xJS
	nF5Sw9eup+UoVewe7A3oSWpZGT68lS1RCklJNMvfMruQt8+fPCAoHzToq6Zbx3WSoaN59E9vSLe
	3vCU+GF9VQV5C2RxagnGo75pjrca4Mfk=
X-Received: by 2002:a05:620a:2728:b0:93d:23d5:32fd with SMTP id
 af79cd13be357-93ec1499888mr302127885a.27.1791566860153; Fri, 09 Oct 2026
 10:27:40 -0700 (PDT)
MIME-Version: 1.0
References: <20261006002307.2669023-1-usama.arif@linux.dev>
 <20261006002307.2669023-2-usama.arif@linux.dev> <CAO9r8zPm4B1_wtAUMeSR9PQ5ja+kJz14Ub7MCuJit_NSH2DQsQ@mail.gmail.com>
 <3465c889-de07-48b7-b6b4-7fc8dcac4e67@linux.dev>
In-Reply-To: <3465c889-de07-48b7-b6b4-7fc8dcac4e67@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 9 Oct 2026 10:27:26 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMjcmoY_pJtCUGbw39Kq7i_L9qUUQXUSBNAqSmwiaVVOg@mail.gmail.com>
X-Gm-Features: AclHuK-oBA4BdyKvlYo-fUMM-fivKSARBB0CToCpEWZ_rb1EHfIuBapd1xjHTP4
Message-ID: <CAO9r8zMjcmoY_pJtCUGbw39Kq7i_L9qUUQXUSBNAqSmwiaVVOg@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: zswap: use separate compression and decompression requests
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev, dsterba@suse.com, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, terrelln@fb.com, riel@surriel.com, shakeel.butt@linux.dev, 
	alex@ghiti.fr, senozhatsky@chromium.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7E1C2000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: o3f4gknzp3ci1yhs588ajf67asx4zx6n
X-HE-Tag: 1791566861-395941
X-HE-Meta: U2FsdGVkX19mY/XvHJs/zj3cuPQBOHub8nU1CuyEdLXAfIsOz+AAjSDPG0pupcxeJzmzK4EXf77P1MASvzo6B9qB+pAvaX+shfLkK/barJuxvjUGgE6W+uY72G83ZSYW0TxUCW4V64y0y4fUqw6zAZRof9i6rIw1sLh3G1UcWP3coGC5S+Jqbx5s9C1Wh7F98aZVB6INyEzw4XhOdynsxObrxneB55Yd1gOeINTtCxXBDo+HZRAFY3H0Vjy/AURYP/pE1xz0UaQzlSw8sFIvnP2dI3U7gaYfyA9KU/sRWyblR84EJndDILr+Vt6S72vvjKopreSDXq0wYrjha8sWroAwWvIcM+VoDF2laSEkmn3c16aqQavLZ0BkuHPGYUC9XuiGHoPUmoDpdI0D/uR8DgaEma8MZHeGl5bNmz3iGcYEVk5ClZ+GJ/vEF9BaVS4Cg3bJ3+OALdz+4qwhiv+5yrh5f17K0u6f8Djc1wTw69igdZ03FvoJAmtXFWxTjuX0bteIvvVilKUGzO2GsCe7315ldZ/avPgXDkqxf2wUGab+K6xDHF8EgGC8lxDZEOy//GJ7bB7Xvz76vBpLMonpeC7I9bcqoz1a1Xq3H4umO7Pjml6Y6HKsLk5iDUG1CxTpwMHtOOgWRstBL0aHB72hsfY/IuElfJPPv+Vn449Mcv/XhBF4sQrSPkb54OY03NAOwMyEoG6PLphRl0NycSI4P6XEKK6Ga6VEC8DSh38R0fJafBnHWxi6cNJnreZ3odkobD1IwaQrVq4iuUhs15gD27NAY2PFay/aQ7iC+qaeWyh/Cng17nwNYqtIHv+Z+22ZyNlHS8OQFf7UOm8X5FlXvRxKerYOzw/NHd0QmZrnn9WWY7puvIR82NullcyBBTFUhh2Q4ynUv7In9rL0wJ01qddIvLdEuaXaGQao7MavBTgY+zJCUc2WKcprAEzjy2dK55do78A8CNZR3+APnM3
 XztNCnSl
 BWb9fOdSVQo9FNED7qgqYYsMH/jRR7Ne+9VFyTHWHxb1mcHkJuO8nUkPOHlFJo4lRHV4vPqNNutyj+vX+CaD9uKkGMsk48Nx90vbfmrLycstLupkqK8q8vxoQTLuO+JyhxzEbhy793GJCnNC5S7eUk0BWdpCOxPQQvjsK2FFREdA4S7vO3Q0j+YqeA3MgpwbmTNNRH+lTRON+ZkmTPUs76Ps3VqdtWQ1UrwxJduk5ICqtFc/JenjRIMDX1+jP0FAhzHtURDXaLygXVyT0HjSxnGu16HoIzHXcOakA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 8:07=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 07/10/2026 23:01, Yosry Ahmed wrote:
> > On Mon, Oct 5, 2026 at 5:23=E2=80=AFPM Usama Arif <usama.arif@linux.dev=
> wrote:
> >>
> >> Stores and loads serialize on the same per-CPU acomp request and mutex=
.
> >> A low-priority store can be preempted as soon as the compressor drops
> >> its stream lock, while it still holds the mutex. A higher-priority loa=
d
> >> on that CPU then waits until the store runs again, which can take a
> >> long time when other tasks are runnable.
> >>
> >> Give compression and decompression their own request, completion wait
> >> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> >> decompression APIs from zsmalloc"), the per-CPU buffer is only used fo=
r
> >> compression. The two requests can share the per-CPU transform: no
> >> in-tree implementation modifies transform state while (de)compressing,
> >> and shared codec state has its own locking.
>
>
> Hello Yosry!
>
> Thanks for the reviews!
>
> >
> > I am a bit uncomfortable with this. If future changes modify the
> > transform state while (de)compressing, it may result in nasty bugs.
>
> Independent acomp requests can share a transform. UBIFS already uses its
> shared compr->cc for compression and decompression without caller
> serialization. IPComp also submits per-packet requests on a shared
> transform, and EROFS allows concurrent decompression on one transform.
>
> Drivers synchronize their shared state internally. For example, HiSilicon
> protects its transform-owned request bitmap with req_lock. Unsynchronized
> shared state would break those existing callers too. Separate compression
> and decompression transforms would still leave concurrent stack
> decompressions sharing a transform.

I guess others relying on this makes me feel better about it. It would
be nice if we have protection against it. Not asking you to do this,
but constifying the transform everywhere after it's initialized is one
way to solidify this.

>
>
> >
> > As for the buffer, I would also prefer some protection, but I feel
> > less strongly about this. For example, we can put it inside
> > zswap_acomp_req and not initialize it for the decompression request.
> > Alternatively, we can have an intermediary struct that contains
> > zswap_acomp_req + buffer, and use that for the compression request.
>
>
> Done for next revision. Added zswap_comp_ctx containing the compression
> request and output buffer. Allocation, use and cleanup now go through tha=
t
> context. The compression mutex protects the buffer until zs_obj_write()
> finishes, and decompression has no buffer member.

Thanks!

