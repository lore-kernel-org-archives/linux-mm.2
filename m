Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97354C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CFDE6B0101; Mon, 29 Jun 2026 16:28:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7596B0102; Mon, 29 Jun 2026 16:28:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF8E6B0104; Mon, 29 Jun 2026 16:28:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED336B0101
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:28:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7D3C9401B4
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:28:28 +0000 (UTC)
X-FDA: 84934087896.30.E373F87
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9B33B80003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:28:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DhAOD2Jh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782764906;
	b=7gBH+jCCRdP1Y2Jx8x5xuhFRxteEZUn0HoElfjyDT6hBm8hfXwHQpvlWiEh4KE9rIwuQ+y
	wUIxEbwY/o9FTgHkTdEYK5SoPfoUbCDwKPPnOTQdIo2+IgwORoVQ0s+iqQx+RpXeT7PrRL
	ComZigRrIQtrnUOVtGG4QegWMhSZ2XU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782764906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RwBM1U8dWRy21no+IYOBvhWWP+kmvdE1hw/PUPXb+Vo=;
	b=adbaahqF9Tl3uBWgDjsnPOQjiNjGTxYXrccHBWO5Gozetm9BF8bubgopboDAw+J9BUJNzS
	dW6jzG+YD+aqq3cf7dssYA2C4B5EjVzK7JlqHX1QpyWGrrl4TQzMEXCkd14aVKc/nhDgrX
	LR1N2LRv/pm/8UxOK6jm4NbHJifp68E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DhAOD2Jh;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4939a809b24so21844785e9.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782764905; x=1783369705; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwBM1U8dWRy21no+IYOBvhWWP+kmvdE1hw/PUPXb+Vo=;
        b=DhAOD2JhDyiofDmm+izKks2Ic/iDxCkixIk6tKKi/2DCfSSdVQt9sizpCHAe1hmzZE
         DU2LF1oFh/bLkHU2GDRiduhOBHqYwaf+Q6x2ABhAfFp+hhKGLCRnt4Dsca/D8AyPFXnR
         tGhuQygyllmzxiFU7utZMPTIJu8yXAKDpzdPRqXbcO5/Xt96cB663HsoLuAAUeNv7b1k
         MkhBxIFV8oE2qG0wcYLC9siihAiaBpUsJoRcbcwopuakFNExx05IXdSWHy9XInouL4Jy
         D1gWW3w2Zk6ANAcDABvrJFYqwQ94c4AaD5Jb5ARfvzmIBC9BSrCG/cAUe5dFVoROZB/X
         po9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782764905; x=1783369705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RwBM1U8dWRy21no+IYOBvhWWP+kmvdE1hw/PUPXb+Vo=;
        b=JiRA6OLoijZ8R+mAz7f2S/WYiL6ECSeKBKhvkKNbrc12n30c1d3LhkelIZJzuFfFKl
         NNMjdJqgA/7rWoVY1jV0XzQgjf2yDn7fsvrhxb2W6qBNDNqPodCBF+Ha70/4ehBewgU/
         Qabf6/9mU/Di5Lzt9y5E4FqBCGA2sIad2QtBsg6lkp0EPLas7qzbbUvz4CXdV8pujEvm
         gSMNdyvGJtbA/tdTjK82A4N8cYNNlfpJ65xEMbPS7GhGGpfUGJPWPTdW673QJB4Qlle4
         plIBUWCV4s8T4YgI6OUALzaUxXG5IajAzztg85ucZCHiSPwwFKSgf8YgK//anqn8xtPP
         eobQ==
X-Forwarded-Encrypted: i=1; AFNElJ9kyaPYnZcacE/+Zx0Fy6B2SYFHBJa9IBYLJYGtFTvL91n+esszLxFyKtjGE9mNwRLJ2Cv831Kekg==@kvack.org
X-Gm-Message-State: AOJu0Yz0psii+B6jRqPoh73dKq7Dv/+kOQZUk6OXdqS9ZX4QvfC+ZoiV
	69QpOMMyvkz4tdO4YFU92GBgn8qE84oWPAZzQOUcr8FqhLwVQBokXa9L
X-Gm-Gg: AfdE7cn3kUtgRA60zXWFOPzmZSLiRvuQ/XdpMVTvEoJYK0EAy7vevlul81g/ypiDEWG
	mm8WMkRQi0bva0CHx4knGfA5UFqJqGUMWJ08m0dAjjGtU3uPsgbWIEsiSeHS2fBNkJ9/V6fQGY7
	JX3wSMBq52lmXQQrRDKKiGSAScP41WG7UeB46TAKG26sCt3c9yElTCR1RAXNOzY90krKc40QRy0
	tPobQWeGYLXJSD6AReX1lZ0Gv/inJ3+uBrW/YCdWawKB3USzLoRRbx55PUdeW1vIxrsH1cipRld
	MyR+Irl53BpSwD40/cp6tMjP1nR1NSA5V9sh/rzQdfqdPuQT4DM1vwrBi0HfJeSa7VZvyiK9MFQ
	kZHW7peT4Ls5Zx8QCQPwzdMP1ujmKM2NzH+Zx1qZBCT9h1NtvSm/bN8th0vr48UkcTA2bYWASFx
	/pWMIMe3oQXaubnUBVCjgk65Dz+Z2XjWBKPks3GI/fjjAopeQwEZJxI9t4
X-Received: by 2002:a05:600c:4f82:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-493b82af9c7mr16475685e9.20.1782764905029;
        Mon, 29 Jun 2026 13:28:25 -0700 (PDT)
Received: from pumpkin (host-92-21-50-228.as13285.net. [92.21.50.228])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cde2sm798992f8f.20.2026.06.29.13.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 13:28:24 -0700 (PDT)
Date: Mon, 29 Jun 2026 21:28:22 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Zach O'Keefe <zokeefe@google.com>,
 "H. Peter Anvin" <hpa@zytor.com>, David Stevens <stevensd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij
 <linus.walleij@linaro.org>, Will Deacon <willdeacon@google.com>, Quentin
 Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <20260629212822.14dbb27f@pumpkin>
In-Reply-To: <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
References: <20260424191456.2679717-1-stevensd@google.com>
	<da9321ad-4198-494e-b9fa-30d69bd29be3@intel.com>
	<6369e5ce-74e3-4c68-8053-d7d7d21b6955@zytor.com>
	<dbeeea58-16cb-4383-b8e8-91a8ca84e88a@intel.com>
	<CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
	<c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
	<87pl1md7h0.ffs@fw13>
	<CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
	<87qzm2b39k.ffs@fw13>
	<CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
	<87mrwon5uw.ffs@fw13>
	<CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
	<87cxxgly12.ffs@fw13>
	<5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B33B80003
X-Rspam-User: 
X-Stat-Signature: nhj6z55581zrx4hginxirwo519r8463g
X-HE-Tag: 1782764906-727902
X-HE-Meta: U2FsdGVkX18GJ8oEypgGbFVA6HJRcB1pIAEhb5wj/WOjTTi9Zv7RlE7Y1PjbltBSum5oTBo4can4pWGAMa4l0V6B/iZsi8KaGDbmiPIMDTPwBsS1CrqTUqQ5wvNCSqNrYTAiogCvKPcc32St/frAmy985eYHHvyLEx+9ezlMgy6hFas4AIxZVlSIEkCCwVWDB0DdRiVeQBbDS68/vW9F5Zl1E5OzDU95i19EOdJjQ9HCzDGqV615JqVpcErhnEfi2YGTyub6olqy3qv9x3/1wq7XV9JwUFp3TNacd7M2NrkAO9oxIGYOCcX62Erur4AMvgDoFQVLu7iDvnyBqGLebT0BmgWEiEfpwj16gnPuMl578l+2zbO1cD7MeIyIbpQTFifR5RWRnXlI+qi4H44K/hwhArokXcMTuUrPqtDPLmy9SHJpkRwFAVkSShRGUGJ3BFL2+0vx5LnsMwB0YGEbsMorb3hwAEV7oHnacGkq3yQptsN7X+TmrEdKjWKOY3p08zS71Jn4bL4ZUHXhZe8MgCcDzyf1gMWFtMd4uTvHwKDeScsXf3Z92Li3JZ4PNWMmsLcrKWg40gFZ5PUyiWkTnemyWiLWDPESWwG/jKlfYaSMeXNpvrzWnsqJYcxwjhD7x+wENY1tUT2ifCs8mN6yVxSiNE86yBQZ55+r/GoEyqBJMiysc/h5KDE9AhQoKmSlbPA4e498YStw1FAdpcz9uswXzYiQvUr6vKWAf7DSBDLvsCBTiXjrfr5agd7f/it3GVfuKIRk4rDoyMpwIetlEVDXncYFnSsTjxMs8JXMZV8uuMxnB4sVU5Zx2VjTy9+LtZ5L3nh3vrGGBow4pCJjgvmSFYoOpV/6JKS8nNt2hIg9Hl8UB9T4D6qfeqD0k/wM37SBUScvGe5YzHt1qx7nl4AePydpWGFSM0pR9ewWufBW+Zri8Nf3ksdzs+iS6HyEmrAE+LBuzgFGjIfr6TN
 Olvk5K54
 gUckqq4/gReBMaFCeVkrRDHPKJEs3WCy0vAUHrb00lEOQI8x27249IT3D237WIMENd1khF8J5tZ37XRS9v3wtoer2cICqqSvNT1X2pUBjbY3YIWA03gpKszNNGu/YkNRLEA5iZPYD9tVGvq2qATb+ypDBoz1PMjH/loXb4sRVAG1rOX2WSVUIWHT2M14bzXxKnw2gM501vQwaBjKZPNRTROLVkzcC4c/slQr1ONt82O4/trn6sQVqmNrSaidYWPhECUZIZIG5AMdwCHtyi5Ir2nQHK3P6qAmUL60FbHkYW9yv4CYTrJOorNjCBprXWuk225JbctoggsR79niXScGJMs1KB93IETYs/Tzz0YvgKWW/cf6w32YzOiuwvYCYxPAkypgZmCTfWGzGHQHahUENy8Dh4tF4NsxbBvd6CoUrdyqqDZCLpmivghZM4FZHtv/p5VuTEDFq9xLWSOo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Jun 2026 09:02:08 -0700
Dave Hansen <dave.hansen@intel.com> wrote:

> On 6/23/26 14:58, Thomas Gleixner wrote:
> > So as you already confirmed that the number of offenders is really low,
> > it'd be definitely a worthwhile effort to fix that for everyone and also
> > make the compiler people to get their act together =F0=9F=99=82 =20
>=20
> One other thing comes to mind...
>=20
> We have debugging options for looking at max stack depth, like
> CONFIG_DEBUG_STACK_USAGE. But no distros seem to turn that on. There's
> also some ftrace stuff, but I assume none of that is used at runtime eith=
er.
>=20
> Do we need some max stack depth instrumentation that folks will actually
> turn on? It would be nice if we spat out warnings when folks went
> through 12k (or 8k) of stack so there was a chance of closing the loop
> and getting feedback from them.
>=20
> It could be done with really little overhead if the vmalloc()'d stacks
> set Accessed=3D0 on their PTEs and then checked them near vfree(). The
> PTEs are already getting touched there, so the cachelines should be hot
> anyway.

For testing purposes you'd probably want to do the check in other places.
Possibly slow paths that might be called with a deep stack as well as
context switch and return to uses.
I guess you could copy the stack (to global data) so that it could be
dumped for diagnostics (finding the relevant stack trace is left as an
exercise to the reader).
Similarly it might be worth allocating an extra 4k page so that stack could
be offset so the warning happens at (say) 12k.

	David

>=20
> The granularity would only be 4k, but it would be so cheap that we could
> turn it on universally. It would also be 100% deterministic.
>=20
> There are, of course, more games that could be played with stack depth
> checks on normal interrupts or NMIs. But those would be less deterministi=
c.
>=20
> Thoughts?
>=20


