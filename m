Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 000B3C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB336B009F; Mon, 27 Jul 2026 12:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6BE96B00B1; Mon, 27 Jul 2026 12:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5AAB6B00B3; Mon, 27 Jul 2026 12:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A44A96B009F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:56:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30F05A0115
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:56:06 +0000 (UTC)
X-FDA: 85035159132.25.1C23EB5
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3ABDF40008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:56:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S8Ram/PS";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785171364;
	b=6K7I89C5X+XWLMBXaae2nLyyUWUlSQe0O+8ZdFShulPZF0f+xaSSUA/TeCfOMix9VEHBqw
	Z3iv5v1Np1fdLdR/Css8CSeBoiOj6fxgFLOl/KIBq+0S9Yp9gb/OJX2Su6TnZw+3u9hvU9
	Y0RafZBCBRTZUJ+U8oF2Las5vA3NZFo=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="S8Ram/PS";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785171364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ARjITWoUolIuducF3rQoy6N9TOWHeL+Se/rDZzCYmQ=;
	b=r/5YzXWWsDzgK2gW71ybLPhh0EwbUX94VFV+wipjP2e405j/YFqp5jNPe2YP9jT7oAa49V
	jGCJ8f4ORNtu8QoCEFXNl1aDVYcZye4BbbMhv2B+f1+QHrTdaStYz6HqvpQs9AnVpbAreR
	iT35CmRRQszdcoPO9l9zD/DotPiQydE=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-4720f3bf164so53945f8f.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 09:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785171363; cv=none;
        d=google.com; s=arc-20260327;
        b=iv3OwhIR3eJY+Srhrn0wK99ccrJDzhIdrYkE8N/fQEtSKkoxk/ffkTApT7d5oihiuI
         FKxc+S2kQAhPUEntMRnpX/sHPKUQKI6OQMJKF5u9mYPKmlYmKJUlWxmI1kh97eFZKiKA
         5/8UB3JQvly8elID2+DtoX4j/7/5IDyDxpA+E/lAIGgo8hW3nZ/DsSyO7ZVY2u3tiRa7
         3I9nOKyrhO+1h2+roxbbVcG6UEx9zNCS70TOIHcaSjRV+R4+EMLxHhIWZpHcdYggWJZg
         1356Ez84uUCN7lEx+Fds9K+ikZfmuQ0HzDgMgKVlG2I2GuKe2bvRwRBZK12JjlAQ412T
         qNfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8ARjITWoUolIuducF3rQoy6N9TOWHeL+Se/rDZzCYmQ=;
        fh=BXDIw5sVTUu8TsBq6kJ87T00RvMXVxDqimi8i4O06+8=;
        b=ky0+rabR6OZPk/DTJGrNBrJsr3kHhNDpgVEdSpN8WS4ja8orSQjkgHUkfSISNWg3Xb
         BzpmC9yEeJkqx6BX5hgPiriGQOzdLal2h63QP95wO2uale2Wa4CAUCFZmjeMwEj0x6kT
         MSAs8a+ms3hEnYQAAXuFQoS5n0Mn3bielRiel5FTKAwbAllmvIbJrskVSYCt9mkZnIpP
         hWgUr37nR1T2Xr+Cgr8mvyxvTev1oEHK5u9Rhcbg4MfIsEad0hngvk4c2h5EcqRgh9oX
         YR6oeRokru+xUF5RIZw13aeWM+9TtySyMOu0EMLFfKABqZO3OElXtnQ3+goWrmq7xVaf
         v06w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785171363; x=1785776163; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8ARjITWoUolIuducF3rQoy6N9TOWHeL+Se/rDZzCYmQ=;
        b=S8Ram/PSqn2YIv3gLIhAFFnrpeYyM2wP4cUCFeQGhbkFWmdmdvocqXH7W6nZeu0728
         hqmYGwfp9okXV0STQH0YgDN/yOVrY8VR7DMcoGNOS3vHg3YKme0ERm8qTZRM5G/O1Equ
         CKEB7ulu30KkrqjgQPO0NB9kdAfStF1xW+KARCQIB2gl4YZobXW645MKDgar8zjBgI24
         lBKXnh4AW7vl80TO4hXx0JhkeBhzj4zz7FSRBtVmjeqYlsP4XyHoiRKO3PhovAh/MpVr
         fuFY3AoFA6TKXzgqdDxs0i3A8265He/kSUVrfOPgtokhw4bxuiF+1bN0Lu/4TTfL4z2j
         Chrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171363; x=1785776163;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ARjITWoUolIuducF3rQoy6N9TOWHeL+Se/rDZzCYmQ=;
        b=ghD0QjoWI2mZYZGmPj1iCnSSc9ygtURTp7/9bKCpf8BgHJqqff+wQV2l/CrFzd/AH/
         M4IaypM2zKd6rrY5ZML9u4Dv6MV5A+cXd1wTC4tHorkI5xhheB9+8asdM82ljK5bFexb
         cjZ2iKCj5+h1iDKilJx6Ozep8go7y7Rc+yQq84tFw8uiDJJNnV3PB76pa0cLx6ZaGfBs
         4WkMbVwnfumjCNiidHRok/aoYpBpREN9LbqzdEExHWsNnBWDdnUvfgERQjZYsjfIitdA
         Xk9ey+znveYoM1+Cs9tRnJ65tgXmKj/EaUsC3xvqvWDKbfOc3gdJyDwtip10yFwzfi1O
         yTBQ==
X-Forwarded-Encrypted: i=1; AHgh+RrSJxwKiH6o1feeiBJzWCqBaVgni/M4XJ2ZQ+PtnmdAOAVIDO/IdfvK2mtqM7bojPqHpKVQWwhQeA==@kvack.org
X-Gm-Message-State: AOJu0YxaLlTER8L2hmQ1pDRgfot3ktERtJrHfUN814uOMvaVmpA7b4Jn
	ApalEOV6m3P7CqOcAUmOAehCoEwLOSlUu8XWkCrjRi2IgVX6XQHvtVTJirYxItD4y9Bowj7DZau
	o79RqW5QqlCxHiNO9Jqa2jeCnSmu0ZNg=
X-Gm-Gg: AR+sD11K2nkuKFcsWDKE9XS/d6EKXgUxh7OBb/k3bFYl0zykx1LTGcNSUfHQZ9NOD18
	06/Q/lb951ycqkdSkAFSDSJm/bYbMKB4TbsMI9G8n2nuzov5CsPJ3YAA9NnSw4IooI0/oZwEhAp
	OwrKI/4USpCOQaessFM2x84P1ctqqhvSFmNY1otzL9aJmxthqP3JxQzTObwOA0msFUXvCdW+vmA
	vp/0o14813IlCdIYzl/SEFPzvgIRYuA7/KLjiC7efUStM7gnzoq/bggNCzO8NudYsbwwFsBObjp
	t2w0K/NzALeAKMR2hCwx5jrBHc2E
X-Received: by 2002:a05:6000:2913:b0:47f:95ce:85be with SMTP id
 ffacd0b85a97d-47faf5b7498mr327723f8f.30.1785171362740; Mon, 27 Jul 2026
 09:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260726-shrink_zswap_entry_v1-0-0-v1-1-30957e4d0cb6@gmail.com>
 <CAKEwX=NLEmRKbgf7e4mQ8ynwGLhe8d3orc_2U8n-K_W6VjOAoA@mail.gmail.com> <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
In-Reply-To: <CAO9r8zNbw4T4O-TtFsd9NMJh2RKRDuXTqfSKgMbe6o05MZxebg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 27 Jul 2026 09:55:50 -0700
X-Gm-Features: AUfX_mwlAtYmpj3eXGxUwXu1zutuWXbbkgUM5rmqlrjXMZVlQnYQYBz_VVbGQms
Message-ID: <CAKEwX=MwhU74Ak01kEa7VL_mKNY1gO_hX_aAPvMkXo-72MB52g@mail.gmail.com>
Subject: Re: [PATCH RFC] mm/zswap: reference the pool by index to shrink
 struct zswap_entry
To: Yosry Ahmed <yosry@kernel.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3ABDF40008
X-Stat-Signature: jwo7u8wgqzz4nyzyk8q67pd5bhaabbaw
X-Rspam-User: 
X-HE-Tag: 1785171364-495793
X-HE-Meta: U2FsdGVkX19HNtwNlWXjpYCEdQDhQTR5XNY6QNKbDYoKaDrZf0tFger2gWa3TZz+d2un44kW2LLv/WT9buQN8HcGy6e/zRbMWfb+v0xNnjH74h0AVams0N0sDdvWCgDxCuH+CKtnvvuVpcIUt/ZjBbrSR/BDYmhm/COZ0deAYoSMe2DfspI0t9i/s4ShJ7X8iDxE0cVHuq69oihyIB7qKjDNWvA9KgbgQyXpQrRRwJiAZtn7bPDF80PQDslpYnaS2kfL/4MtPdUOAj91+VW2TNJSYBn87b4qUlnhoKpMYZztNm5xxY7mICqXlpcovEJi4LDbT/7lKJBqHldkH5F3QIWRUYf4JZitfz4yFYttpMB/JrcA8M7bST2BIgvBx9pKbt4fyZ+XGESlW3NmgGql8bxKDKVzl5sVehUrxSSqoKrJMicKJvkbzXJQ8P+gHSW7Cn8YBlBjv9+0Fakv9knCE6GWX/oaXFrASc/+W3FNcvoNnhLaEoPIMPGnEJzlgwyTKtKRBlkArdwrc0NDMVrKVBILGK7+QxKoW5XUQPyEIAIBWEM5lfa84wTFLQBsL/cdCOK8Sb4WgnMYrb5E+ygOoHOzQiKOHsHgmcr4SKEiDK1PoiI3d17IIpp8BO1Ypov0WScVAgNN5mdVGengFdeuNUN++8uKEspSPV38IwX1/siSwWN1OhMmsp8TXfMM+AbzeVX0ypOs6faBkRMhE059o9pQFm29ByBV3FNFDBlc/c662yOeny8ag0YXsfvEVCCwor41cvqoMM7bL9mMKcZAvNnhu4YXr6IAkrEXDU0L79gCYXWKnzKbfiSZWOaRSTt+xKKzsCHCIyiZh81j02wLtNPCaT0OTu9EEFWWehKdiIySUfYWNJP7BTnsg2HLGYFUI9ZRYZ9NmMXEcCXHsSimvvtIFVUdK/I7KcGB/Au6OZAopCWj6l+XlkpU7t3+uNyqN0SgaztgFYSzBOyuY/h
 FQi1tZ7U
 zVKezJ7UNGMKbjgqvA71DD/A0Qk/KVLfzbTFQ8h+wqPwQLl4iheWJEcr18u+uvtgWv4/cz2AHnp/SfPKRHS0e+zJw2T5fxlzSLAyd71uCJqvvmFOTpA+YuHL+WLqCRClErEyeY5bWo19CMWRaFFzRPrkPwHmQOMKMKqbo/+pwtOA8di0PXWgkUU/gPPsefdhFpCBRyWJvDlrIcIBF5aYasXCfxjWsCsyVV8h3ah8ZmXOtUtsNithIRIZKJpgCpWEe4BJKYqY1/OyfCU1UULVMXPXKfAW1AWFmPLCs1LLmWhGaVyztzrFrYIos69r8aw55jDDD9RbMYH72I25IV1CNM9h4/IVPW2myY72IU49QstAEUPbUXahDlf92p1WdIxtws9vKKW1le8LKJyvjCV+jLy9BCblJ3x72WsWhENgPxMxA68JDUUye8kp+e3zGHZl8yIGvNdvApzRZi7vklxxqTTt1bAMOxilHGvKZzuW3X/5BcQ72Cagu5IXzgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 9:46=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Mon, Jul 27, 2026 at 9:35=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Sun, Jul 26, 2026 at 8:18=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.=
com> wrote:
> > >
> > > Every stored page has a struct zswap_entry, so its size is a per-page=
 cost
> > > that scales with how many pages zswap holds.  It currently embeds an
> > > 8-byte pool pointer.
> > >
> > > Replace the pointer with a u16 index into an allocating xarray of poo=
ls.
> > > The index is allocated with the pool and remains valid while entries =
hold
> > > references to that pool.
> > >
> > > On x86_64, the zswap_entry slab shrinks from 56 to 48 bytes per objec=
t,
> > > raising objs_per_slab from 73 to 85.  This saves about 2MiB of metada=
ta
> > > per 1GiB of data held in zswap.
> >
> > TBH, that doesn't seem that major... It's like one huge page man.
> >
> > But Yosry might disagree?
>
> Well, it's free memory :)
>
> >
> > On the design aspect:
> >
> > 1. How many pools can there be? My understanding is it's bounded by
> > the number of compression algos, and most of the time the system just
> > use one, no? Maybe just add a fixed array and call it a day? :) Seems
> > like we can probably get away with, say a fixed array 16 elements.
> > That seems plenty. You can reduce the number of bits it takes to
> > describe the index to 4 (saving the spare bits for future usage), and
> > you can avoid the xarray overhead...? Just fail and warn when you have
> > reached capacity, maybe? :)
>
> Hmm yeah good point, we do reuse the pools for the same compressors. I
> don't know if crypto defines an upper limit on the number of
> compression algorithms. If we want to be really conservative we can
> use an array of 256 elements indexed by a u8. That's 1KB of memory,
> probably mostly wasted. We can also just define an artificial limit on
> the number of compressors based on what we currently have implemented
> and increase it when needed?
>
> Not sure what's an easy way to determine all crypto compression
> algorithms we have tho.

Seems like we only create new pool when we set a new compression algo right=
?

In a sense, it's not really about how many compression algorithm we
compile or support at runtime. It's the compression algo that we
actually set (zswap_setup() and zswap_compressor_param_set()). And
it's usually 1 (or 2 if we misconfigure the build config, lol).

I think 16 is already plenty for this purpose, but who knows :)

>
> >
> > 2. Note that the zswap pools are also organized into a list. If you're
> > adding a new data structure, maybe remove that. Or maybe the other way
> > around - can use it that linked list for your purpose?
>
> Also a good point, I think we may be able to drop the list, and I
> think that's ultimately more valuable than the memory savings. It's
> unneeded complexity.

Yeah seems unnecessarily dynamic.

