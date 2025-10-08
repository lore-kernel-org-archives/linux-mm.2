Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E55CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 15:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774708E0043; Wed,  8 Oct 2025 11:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7244F8E0002; Wed,  8 Oct 2025 11:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613718E0043; Wed,  8 Oct 2025 11:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3698E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 11:48:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D04E140649
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:48:27 +0000 (UTC)
X-FDA: 83975379054.09.0058BA2
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3A0518000E
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 15:48:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BsGbWJ+d;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759938505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jnz0wfzGjq/RWuaaZQleG175ixspg2bx6DBLy2dhJEw=;
	b=D7EYTEvs10VS9JK0SKIg/9c2tukGbQM9mBu1HMJ8frS3wwOVIS477ivJfUhbLc+3OjZpbN
	VLebuOD7noPKsC+/etnfKprfE3TeYEaNWJphIXJ18drxhBHwfgGXc8hLPF1WRdsrZKvmIW
	pImGyr97whFrQ3l6UvWPoM7nz3STEtA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BsGbWJ+d;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759938505; a=rsa-sha256;
	cv=none;
	b=2LFHAMm7COJd4QJULAaXnUxOIPsj9mdmnLqeBBKTIbTWZct1yKrXYF+0PVPW1ShefxizvH
	HmAKcDHDT/meER3gHWZ1xzDH9+1b/pq4psHpAkqe07mVlUpY6RHMjQZT1XTT/68H+rXjBO
	wvz89edv8BJ8UCabpbDD2RdJgMn0qF0=
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-91fbba9a8f5so626755339f.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 08:48:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759938504; x=1760543304; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jnz0wfzGjq/RWuaaZQleG175ixspg2bx6DBLy2dhJEw=;
        b=BsGbWJ+dFO5kbJnjvGmbMXJq1gHAcsI/XHebocC2I5O5s+nMSDL6N0LXqpZ7+zniDv
         mK1PaTG8g2JL5rKCj+tDHya/0G35oR/lJUsAPurEHg205DUykUv4ZLlXF6tU2bFYgfWC
         EP8PZmNKHs0tE6C4AhB2NzTAhQ1r3nhPJKLAZlNcUMY/DqM77UGwh7FvrEVeqah1qbFU
         g3zlLZglgoWmA3WbNtvmL7S0031FoQL+lsyC8g2O0AM9bM03yCPsRclcQgADzPjfaQ6M
         GfRnsHE6q35Ub+WxLcVadcPboQ/jDxW+GCzUky5+qXKZrqz6rHONa1/LnIJu8gcYNRC0
         wbuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759938504; x=1760543304;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jnz0wfzGjq/RWuaaZQleG175ixspg2bx6DBLy2dhJEw=;
        b=uPD5/COV97BpYWzlMBVahtZwU4Q/85ocqrAJ+perIN2RHylyUhedjfxoVGhHT6HJvl
         FyYRQDhhfLbZmj1AFvHlKTpMVOWmwRqKEVdlJYKMl0M8QwgffVmYxouMZlnGCWsVLj/Q
         zFIAqCvFhnUrlGT13URqmetV5SRa/sc/sKsYLaYSbkAAy+LGLl9qMnrJ5FtWVXV+47mN
         V7v3p5EzsVoRCedPJwWB+CesGP6nJ7CmUnjj1Qv+Lu8kPgiMpXQB1f5bUyOjqpF/UJ+D
         eGBCyn5EDcc1YS1sP8IlHSr6m5sI6ZquQKuKVzqKwu8ceyVtF+zSI1XasJHNIwEaYFSv
         if3g==
X-Forwarded-Encrypted: i=1; AJvYcCUk8S1ueFWe2g2slg0F8kFxw16muStSyIsGUSL5Pr3J9g/m6uHKfla631XDw/Speff5RKAXVDqdAA==@kvack.org
X-Gm-Message-State: AOJu0YwgVaCWOnpCjKpmbO6cxfElVEFq4yJc0n5eyduJJGcEw0Uzn3XK
	d8f9o6AlI3TDw1YX7jAU0GD9pFwvKLnhMSaFon7iv0sGNBImaFG2edW1VewBtCOEQheVk3xgYQD
	c/xIl7f4Jgsr6Jm+6WlvT3u6tw7gEH74=
X-Gm-Gg: ASbGncv9jihmg1pDXbUBIg5bNFdGiPH2Ma66LZTRNtcn0fsbCSZfCE/znkdMuDKHgRa
	4e2vUvnux50ryNYpUHZLAY9tollEMt3J6k0kHIfXqvUkLmQdrsjoHYRtkOyMfSxC74t1BvHELFw
	YYMsx1FzHRqTBkU8RZ6XTDTAyl41WGxx5QjxALKXAw3vidR87Qusr7crewn54Jc99vB0CFcoeYb
	gvs00dRoH5+EDnKpnhu/pKXssJl
X-Google-Smtp-Source: AGHT+IEkR8j835l36xMLsRghzDg6ytuUIEPKbr6li+EEc40XA820BGG77XOwW3X2r8mrb0/M/8veOVpZAajhmXsAn5Y=
X-Received: by 2002:a05:6602:340d:b0:8d3:6ac1:4dd3 with SMTP id
 ca18e2360f4ac-93bd18b16bdmr434509839f.6.1759938504211; Wed, 08 Oct 2025
 08:48:24 -0700 (PDT)
MIME-Version: 1.0
References: <20251003203851.43128-1-sj@kernel.org> <20251003203851.43128-5-sj@kernel.org>
In-Reply-To: <20251003203851.43128-5-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 8 Oct 2025 08:48:13 -0700
X-Gm-Features: AS18NWC5GQ_ulUnl9tKx3ywuwAWkm3a_xsU1pqdxQwVuJQmPm7aLfdyq0B3aGXQ
Message-ID: <CAKEwX=M1JiHzgLVvROjfd2Pz7E6c4DCgzn85aWHPS+6qKMeS1w@mail.gmail.com>
Subject: Re: [PATCH 4/4] Docs/admin-guide/mm/zswap: s/red-black tree/xarray/
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: b1cxb6egwfx9fn9bs78uwyk6bred1p8r
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3A0518000E
X-HE-Tag: 1759938505-166554
X-HE-Meta: U2FsdGVkX18KS3YeI+mQ6zz3F4Js1fbSGngUEaRgfO23svWoaiKOvEAhVKd2UnEISlHZOUFarWbQsv6pLcVqpfJ4cbl5lWvixtZ94TTkTIIePvMVeLRvE2RWHYqPX9adJ/oDp4fJwSXOq4vciDiPaOSwkimHdOeO5N2RGEkjNwhGsQhvIjexp+92oy98z03TwGj8imXzBWWpoJRvRhdFJcTRsc00uIneoQv8AQPXl+pF9DW6l6YsQ+DiXdVD13Qgy301weKiSMZY8Gj+WIuWp8gY6VNiYcMuH4Sh1q3qLYK2btDBYxXjy7ald6IGMhdEK96dI0FIdLneB4gLEfUCQfLWye0yAqMjtz8cVg9x5DVfThWpv6IhhVgGE3PEAqQ2Wi7GYJ5Inm1wULxW4jwJHuiyTHPb5OWZtiJrj/olujd8bxu3EawEHI74bFOW/nNdJNTIMq3zytpQcrDc980lIxhVLvFNXA6RHYHKK4iW7I/mX03P3+CS/x63olSjdtuDNVO3JRXbzPEwvjKrIbN2ppgnbapaBH6/EjGd9nl68IHCH99aK968rR0kQj849UK7i2a6ltoBVoMAZOi+Yamitsj8Sv9e3gKbaYyq0yPu8+5u4mjMdH+dvt2j1yjD6lGqQmomcQpuU7eob8Y0tRn3MBhl3ck84RrQTuFuYZjlU5YOsyTRYzK+/JgaLFnTeWt9uxD3gh7nxikUj+N9UYdqdMU1Wp8SVcnG5+ekCIGy4F2BsoUQ6iOeJATaEqJVI8hMAmGlg3pJYSRhE7TwrKfcxqWgRw9jnK86JOArRvHWNmicfIjQ5A13ry05jRmoD3g3gmMnjDo91hprbXlnqNVDg8oVAgYFKUrKepMk0ot4qnRrr60Yrqc+kSjY1RfSiu2FCTvGZ21EMwTMtsLJt2bk6cQbu7CcQXqq1pxVY8gRj9H7ygs/YaEYhtX4qA1vBdfaGRDYUZ65e1EFhSt6Lmp
 fKi/tZPD
 xClHqtctO2G9Sx6isHv/SBmVdEB2Fo6LH4uPfcEfP3Px+isFvOGfCo2WsxN49cIG5NpKls/xKF/AZtHMM1uKkxb6WmUjdHf5x7GKjCuhTU5uTLAPvShXDlfkONYdQQu5m5Z+j8OPsdAG342auTnUnkWFrmf/z3r/HOTC5kvw/yugYgqMgSVCLUACfwpAp+S2aaPIYpnPAiODFS1Uib0NNwhyTUKG0YU5WfD5fxSV55AUOToC8YeNK4pqTwM8b3cGsud26EAB1Fb8Amsa5gNOIqqhdgDSNVy82hhoF/WivqQRXOkESyKePszN7favWNwEGv06TfZQ4fxWvdU4bZplxqxQR8oHsp8FJtqlS6J9FyRKc7hOW2LH144D2SUMfyMdh8DCidgb1RBXE+HljhClm6BuziQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 3, 2025 at 1:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> The change from commit 796c2c23e14e ("zswap: replace RB tree with
> xarray") is not reflected on the document.  Update the document.
>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  Documentation/admin-guide/mm/zswap.rst | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/admin-guide/mm/zswap.rst b/Documentation/admin=
-guide/mm/zswap.rst
> index 283d77217c6f..2464425c783d 100644
> --- a/Documentation/admin-guide/mm/zswap.rst
> +++ b/Documentation/admin-guide/mm/zswap.rst
> @@ -59,11 +59,11 @@ returned by the allocation routine and that handle mu=
st be mapped before being
>  accessed.  The compressed memory pool grows on demand and shrinks as com=
pressed
>  pages are freed.  The pool is not preallocated.
>
> -When a swap page is passed from swapout to zswap, zswap maintains a mapp=
ing
> -of the swap entry, a combination of the swap type and swap offset, to th=
e
> -zsmalloc handle that references that compressed swap page.  This mapping=
 is
> -achieved with a red-black tree per swap type.  The swap offset is the se=
arch
> -key for the tree nodes.
> +When a swap page is passed from swapout to zswap, zswap maintains a mapp=
ing of
> +the swap entry, a combination of the swap type and swap offset, to the z=
smalloc
> +handle that references that compressed swap page.  This mapping is achie=
ved
> +with an xarray per swap type.  The swap offset is the search key for the=
 xarray
> +nodes.
>

Acked-by: Nhat Pham <nphamcs@gmail.com>

