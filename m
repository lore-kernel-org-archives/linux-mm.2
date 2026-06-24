Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 555BCCDE002
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 14:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CC986B0098; Wed, 24 Jun 2026 10:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A46A6B0099; Wed, 24 Jun 2026 10:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB376B00AF; Wed, 24 Jun 2026 10:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1185B6B0098
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:23:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8267A120195
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:23:30 +0000 (UTC)
X-FDA: 84915024180.01.E06543B
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7FBFF18001B
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:23:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C5WHhDy7;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782311008;
	b=066wpRjd8GOPLc2J1YRLI4fPNXfyWBwOllxL7gxulGUFk0FgP4DCOS2kXr+QX+ytcy4pmJ
	aal4+IK6MlyKMzt3dF5IdOyNQSP8w7f7zklaAiLJnawAdDUVLkHAXA8ZqANMJ4VF96BZPp
	Io7pcpksEnMarm4VloNQ4kj9ueYBQ0A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782311008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Per6MI6n5CBZ4jce2Yah0coKW3mXxHCaIKwWKmwmsgQ=;
	b=QU4lOSSDpOswKlR1VTSNxlDtWmgsPZAQfUc6rY7m2LIWjbHrUtUl95RRn1ZZFbGF6MWc3+
	h/dY0p5MEiUi9zVi1oSczQGlCQCxTYb7BrI51bxwhnGaSN1FwDvTZMu9q5Xjjb4MsvaKGP
	c2zLJP5LjWrKFv5vu4y3WTjJLY+9lco=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C5WHhDy7;
	spf=pass (imf06.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4629051c946so786348f8f.1
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782311007; x=1782915807; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Per6MI6n5CBZ4jce2Yah0coKW3mXxHCaIKwWKmwmsgQ=;
        b=C5WHhDy7lRvhnToAzrYPxqGuV8zPPpoKMnXTKEZnAITwltyY3HLip5CELJmL7S3bWr
         fO6zd14PLUn+3kmxR9qqA6+WEwa2u4gXhX9z+h4OlXmw0TAfaIJfgAw4xKGAS/YIWwRC
         ZAFBZsMablnzg8lE/IISa5eZweVSsYrlySn4yCwPaXvffnMsPAKGpa6Eg4IgpxNBeg7U
         OiAZ8TjQf2gAlzROU7mb7OIISShM2g9Jjmr6737EGLef+UHBL8EdQzU/gwmjLF5VffWC
         B8OICnaPNeqCMd86o5VgK/6cV3sUY8n7nZQ5YSeYEjRZzCYCz8Tq+OYS9yhvhLfBjrjQ
         bHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782311007; x=1782915807;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Per6MI6n5CBZ4jce2Yah0coKW3mXxHCaIKwWKmwmsgQ=;
        b=HD1ZmTTIpEIisjEKPIRaASiM357vwEJfb2l07ICceg3uQ3FaceoDxuxIIrIqfYaYql
         x/5DBc63LHMjgp3COL8proMiFKJi5ySgP1lUL3uveVHSiE2Yt5oTGcoUTaeHXr7366ii
         KhJ9AiIffzvrtKkm/8wkAQNc14W83IrwAV75R+1616HIV1OLul0+xFB9R9XwOWhpP2Yr
         ooJkj1efz3YkbE6WbmQCB59SVJtn6JTjlNojqXmhGMd28iilKfQ2cw7kBTlA/z6XQHwx
         OIPNbSbU5jcQeq56MvMzHumuqdBRHGhac1kWvr4S0MHjpteSgAT9vZd3Oo4hZhi7fJ4m
         HlSg==
X-Forwarded-Encrypted: i=1; AHgh+RoluOHGSjrqPSNFSM/G7LlUlPORxPpuyjC6jX07hVpW5gMvMRjCKEfs0h5CiMj5CCJhKIPSKvqa2Q==@kvack.org
X-Gm-Message-State: AOJu0YxJVsRNeTS+kbpMYAEQb2QLrfG5mOoXJdemmxMmvcnMihNLpH8Y
	j9i/cVxwOtqCG6EqwW+LJxpbMMfOd19hZwjGoMgJZtD+xp6iVrOoAPSU
X-Gm-Gg: AfdE7cm5bL/i19XiFiCpzLIbKAW95UTSHt2d+L63PDrh0pQKb0pioRLVd6l74O256ng
	i1pY/0Ok5ysSlf0y70kC6vRz69nsiXXOZ3ZeTu3LEzsLq+d0rJAQG1/tA2Y14PXaeD7X4xYYvqc
	u8lpZHBoNxZwRuDMIREI6GHEyvsPPHlAc6/QZ1mWB7CcLs7lfGo8z443Wj1/ss+Yglsdpouvfg8
	qrmxrRS4zyAkIqKRJQtxsgxJ5oYEvhuAF9u3DFqxvOtPP4bqSTK+/lKMKZp4ykgdqrYm6lb74SM
	HTtpjf2K/QSEbvj4zHyCogdnD3f9mmmrXMJpDPfv+vZTme095er7Ri1wEqBHgxz604dRuGXay3e
	W2JsGzwKY2o7UiqtxTWDfEnMZOfmrKyllOn6QUIxDr8TbXnhNVOJQZd9ZDmjSOUlOU5N7w7jLko
	YSgaQhmVaT/FdJoZcFxwFj8FcuN+/fqvbMmXbhiMDwa50oDilPAQ==
X-Received: by 2002:a05:6000:471a:b0:460:2e53:a6f6 with SMTP id ffacd0b85a97d-46d04583b35mr1261972f8f.12.1782311006854;
        Wed, 24 Jun 2026 07:23:26 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46c221d9405sm8183744f8f.22.2026.06.24.07.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:23:26 -0700 (PDT)
Date: Wed, 24 Jun 2026 15:23:24 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Kaitao Cheng <kaitao.cheng@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Jens
 Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
 <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Juri Lelli
 <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Paul
 Moore <paul@paul-moore.com>, Andy Shevchenko
 <andriy.shevchenko@linux.intel.com>, "Paul E. McKenney"
 <paulmck@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, David Howells
 <dhowells@redhat.com>, Simona Vetter <simona.vetter@ffwll.ch>, Randy Dunlap
 <rdunlap@infradead.org>, Luca Ceresoli <luca.ceresoli@bootlin.com>, Philipp
 Stanner <phasta@kernel.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-ntfs-dev@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, audit@vger.kernel.org, bpf@vger.kernel.org,
 netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kexec@lists.infradead.org, live-patching@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-crypto@vger.kernel.org,
 linux-pm@vger.kernel.org, rcu@vger.kernel.org, sched-ext@lists.linux.dev,
 linux-mm@kvack.org, virtualization@lists.linux.dev, damon@lists.linux.dev,
 llvm@lists.linux.dev, Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: Re: [PATCH v3 1/7] list: Add mutable iterator variants
Message-ID: <20260624152324.3def88ce@pumpkin>
In-Reply-To: <cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
	<20260622040533.29824-2-kaitao.cheng@linux.dev>
	<20260622094242.64531b9a@pumpkin>
	<351a6b67-b394-4c58-aee2-88b6c8089ad5@linux.dev>
	<cf8467c7-b98f-44a5-9cf9-60b43b5da711@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7FBFF18001B
X-Stat-Signature: jjdh1o4topfbgtfoss11wpi1dexgwbt6
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782311008-470846
X-HE-Meta: U2FsdGVkX19pgrauXWktga/53X3oLvBEKUzSg0ue5GpgOMIgTulrbaGJzZbVgK3X4tFrbTAyzKPJnpDxuTSxp9o6GTFA9YgAobXPG95xe7rpIMU3ZgYvRiBEkn3YlVoOVvUZiY0Su8J6KOHXy6k1p1NNLUFm2fu65uArNfPgPv/qeQ98vrZAORyNHzwHHVIyN97t8nPgYd7kwTCPo/lDB5jtfldqiYqOhlcKmBuKDnl5jhVq6olMT2T1YN6C2gmxi7S4SKak8cOECu65XHxGZP8NbJnnrnFpXdsmySlX4r721tAyhOAKL7B2VK5UyMXk60nKPg4XPMVUFuS24AlYJWT+5dXOMOBM71csky2p+eXwDbOFtLZnHOmEMtjCouQaMzxIIHATQWZuw4Lcv1JW3vOpSigyjTWeksW+Q8J/GrG30tYdpIivNBSLtYmkw91QltljsFsB6Twol3mZAliq4UPDG8CYvwttkeZmINHW16XkkYbipbuc/bmOO5Yflvhw7XtRO+sOivxdLA3U3vFB4KM+oy62gFM+RqyfH/EBawgYLp3BOcn4F6Mw3ei7FecBDsLrK3zQamBlEbjk/4MX/BnQb00CrnaT/F657ozqXgpG5o2D5uCkUEAuGlIpcGV7VYAVhzs+87n4tbm6nQ/IL++NvoDBwfX96HGQxGRXZNwIayV6UQejgfcgu6R9AfuJHlJtYKftCwR+EdCNFuWpUkMHKYV5UtiLMNboIEouACF5MOQqB3/CjwruMUZ087cpAZwRgpu3sSJSZzdMiod3q4dF+Lay6E6xQFxpx3rmVZjmR6B9NQl0buDZIMQ+wz6vRqyfmAeR7epZZBrNBpWAzQ4G/lfYukhiLf3QaxhseWmmgI+DonO4E6ql9NU7Or42PmWoomSVEZ0M7t4UqeQ1oPy34W/nGt954+kFLp1mKYcVeTdeB5iqpHpzyLm/C1XXWOtuNlxy9rslbIRFebl
 iPmznv3n
 C2Q79hZjercD/yufna0xsyR/nVS7T+zo28vThlDJbAg18gy9pm8SPcmjp2oT7IFz3XYMfIKOMwcFEgqkQrh8glEBuinZg9/Dusfiw83HOwqygsV8UKgSIrgxqudRzJXnNvWUEIIib8rp5gWR5Bbm1hkxgfDZb2kv0awTWE6aodJO4+f/Mdig2JZn79MwaCMjhLOs2Wdh09m4MizpBHla9b/eIruZNNYKN6CKjqwdA3caFH0vf2wQnBOWBwa+jUOATWn9Hu1foRB9eSLc/7RdNP5Le0WBu9JJ2lc/c7l+fpngH3f5AWhWEj67e5qJ85K5rEceT4M1Yy92GuV8S8aIz8cuo65l1Wpg5cTWplo0kcldHVihm3nLssokqLQ3KtPiedVTJLpoVGp40X29bGQhOxrdn3FLXXLsBjnA/Vp6t3ghDbWi4aUGxoNlbuTk1xLmgvYJEiBhug5tIewsrKQhNSe+/vgTDuvIrt44R2rWaYLFCN5FsmRMM8A7+oYgD/LBSREkZTcDmc7uRMO4l2AHZAYNGNV8V7zlc+yJK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Jun 2026 15:23:47 +0200
Christian K=C3=B6nig <christian.koenig@amd.com> wrote:

> On 6/24/26 15:14, Kaitao Cheng wrote:
> >=20
> >=20
> > =E5=9C=A8 2026/6/22 16:42, David Laight =E5=86=99=E9=81=93: =20
> >> On Mon, 22 Jun 2026 12:05:31 +0800
> >> Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> >> =20
> >>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>>
> >>> The list_for_each*_safe() helpers are used when the loop body may
> >>> remove the current entry.  Their API exposes the temporary cursor at
> >>> every call site, even though most users only need it for the iterator
> >>> implementation and never reference it in the loop body.
> >>>
> >>> Add *_mutable() variants for list and hlist iteration.  The new helpe=
rs
> >>> support both forms: callers may keep passing an explicit temporary cu=
rsor
> >>> when they need to inspect or reset it, or omit it and let the helper =
use
> >>> a unique internal cursor. =20
> >>
> >> I'm not really sure 'mutable' means anything either.
> >> It is possible to make it valid for the loop body (or even other threa=
ds)
> >> to delete arbitrary list items - but that needs significant extra over=
heads.
> >>
> >> It might be worth doing something that doesn't need the extra variable,
> >> but there is little point doing all the churn just to rename things.
> >> =20
> >>>
> >>> This makes call sites that only mutate the list through the current e=
ntry
> >>> less noisy, while keeping the existing *_safe() helpers available for
> >>> compatibility.
> >>>
> >>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
> >>> ---
> >>>  include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++----=
--
> >>>  1 file changed, 231 insertions(+), 38 deletions(-)
> >>>
> >>> diff --git a/include/linux/list.h b/include/linux/list.h
> >>> index 09d979976b3b..1081def7cea9 100644
> >>> --- a/include/linux/list.h
> >>> +++ b/include/linux/list.h
> >>> @@ -7,6 +7,7 @@
> >>>  #include <linux/stddef.h>
> >>>  #include <linux/poison.h>
> >>>  #include <linux/const.h>
> >>> +#include <linux/args.h>
> >>> =20
> >>>  #include <asm/barrier.h>
> >>> =20
> >>> @@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct=
 list_head *list,
> >>>  #define list_for_each_prev(pos, head) \
> >>>  	for (pos =3D (head)->prev; !list_is_head(pos, (head)); pos =3D pos-=
>prev)
> >>> =20
> >>> -/**
> >>> - * list_for_each_safe - iterate over a list safe against removal of =
list entry
> >>> - * @pos:	the &struct list_head to use as a loop cursor.
> >>> - * @n:		another &struct list_head to use as temporary storage
> >>> - * @head:	the head for your list.
> >>> +/*
> >>> + * list_for_each_safe is an old interface, use list_for_each_mutable=
 instead.
> >>>   */
> >>>  #define list_for_each_safe(pos, n, head) \
> >>>  	for (pos =3D (head)->next, n =3D pos->next; \
> >>>  	     !list_is_head(pos, (head)); \
> >>>  	     pos =3D n, n =3D pos->next)
> >>> =20
> >>> +#define __list_for_each_mutable_internal(pos, tmp, head)		\
> >>> +	for (typeof(pos) tmp =3D (pos =3D (head)->next)->next;		\ =20
> >>
> >> Use auto
> >> =20
> >>> +	     !list_is_head(pos, (head));				\
> >>> +	     pos =3D tmp, tmp =3D pos->next)
> >>> +
> >>> +#define __list_for_each_mutable1(pos, head)				\
> >>> +	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
> >>> +
> >>> +#define __list_for_each_mutable2(pos, next, head)			\
> >>> +	list_for_each_safe(pos, next, head)
> >>> +
> >>>  /**
> >>> - * list_for_each_prev_safe - iterate over a list backwards safe agai=
nst removal of list entry
> >>> + * list_for_each_mutable - iterate over a list safe against entry re=
moval
> >>>   * @pos:	the &struct list_head to use as a loop cursor.
> >>> - * @n:		another &struct list_head to use as temporary storage
> >>> - * @head:	the head for your list.
> >>> + * @...:	either (head) or (next, head)
> >>> + *
> >>> + * next:	another &struct list_head to use as optional temporary stor=
age.
> >>> + *		The temporary cursor is internal unless explicitly supplied by
> >>> + *		the caller.
> >>> + * head:	the head for your list.
> >>> + */
> >>> +#define list_for_each_mutable(pos, ...)					\
> >>> +	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
> >>> +		(pos, __VA_ARGS__) =20
> >>
> >> The variable argument count logic really just slows down compilation.
> >> Maybe there aren't enough copies of this code to make that significant.
> >> But just because you can do it doesn't mean it is a gooD idea.
> >> I'm also not sure it really adds anything to the readability.
> >>
> >> And, it you are going to make the middle argument optional there is
> >> no need to change the macro name. =20
> >=20
> > Christian K=C3=B6nig and Jani Nikula also disagree with the variadic-ar=
gument
> > implementation approach. If we abandon that method, it means we will
> > inevitably need to add some new macros. If mutable is not a good name,
> > suggestions for better alternatives would be welcome; coming up with a
> > suitable name is indeed rather tricky. =20
>=20
> I don't think you need to add a new macro for the specific use case that =
people want to modify the next element of the iteration.
>=20
> If I remember your numbers correctly that is a really corner case and kee=
ping using the existing *_safe() macros for that sounds perfectly fine to m=
e.

IIRC currently you have a choice of either:
	define               Item that can't be deleted
	list_for_each()	     The current item.
	list_for_each_safe() The next item.
There is also likely to be code that updates the variables to allow
for other scenarios.

Note that if increase a reference count and release a lock then list_for_ea=
ch()
is likely safer than list_for_each_safe() :-)

list.h has 9 variants of the 'safe' loop.
The bloat of another 9 is getting excessive.

It has to be said that this is one of my least favourite type of list...

	David

>=20
> Regards,
> Christian.


