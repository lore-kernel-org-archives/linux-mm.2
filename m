Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC9DC9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5B1A6B008A; Wed, 23 Sep 2026 11:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B596B008C; Wed, 23 Sep 2026 11:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD49C6B0092; Wed, 23 Sep 2026 11:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 84B2F6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:40:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 784281C34DD
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:40:12 +0000 (UTC)
X-FDA: 85245438264.20.F3AC729
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8CB2D20009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:40:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=li4hdrED;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
	b=kO4AO51fT1Ib+8AfAYDvX9vlrhoPkO1F72mLUA8G0rNkLtWiXbNfKvndPgVQ4dIkruiB0g
	ejlObLKn0lUlAcP+xdRJHjMELYqbxAcPB+fVufOvsR7P0ehmxUhWSK5oWwAc9cIF5GS798
	zsSJufdPpM+SxraDg4vxzJHq5zO6MP0=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=li4hdrED;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790178010;
	b=Xj+j/4N9491g5vw6FiC7Jy7nYgcAQ71pgzjNXYpBJAme6hH87D2IPUYSGmBRxe5yd7xJsD
	+XgJT6ahCSX8ZcvnGz6mrlZ4BD+Hi1416yxnD37whk/yHJp8qsFBSrndMksyX7FbVEI5Ao
	NbhPSf9x4w9x1WBc/O5u2cxMtIjtFd4=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e66390995so6919675e9.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 08:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790178009; cv=none;
        d=google.com; s=arc-20260327;
        b=lIIYg59rmiXP6geWqcPDz9VY8D28A8sDsvbOZTgRxJ4A9oUMUtPWDDd4CU0uIx9dT4
         DMA8hNDFZJZ1tTFUjHhDIV7BrRBxVr6W6Eo7pT4OAxctSVYMvBukOLv7OhNH8oXdN1t3
         kjh90IF4emGT7mhHyvkAhpKaYAQHST2P0605Iua59TNIJbg3UaQKgk/f2UqiadaajwW/
         Y7YabpT95gxwGdzcpxRZSTApA4e8w7htGQ2a9Sls/aTJDRcVCBjCOljCBR61EYXkZ77T
         5N6olvcMct+HdSunF6Z0PeP8BHiV5w2lRnUcr/qwphDArrAAbIfF7wuA5VtLo45nPNNe
         bETw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        fh=yn4KVZCpw+LoQ23rA1o9TAHmjPVCdTK291G8dFmTF6Y=;
        b=go+RuQvjVQnd0A9xM92gVdaHGv864YRVDTYLNfImJf8QnfYWN/Sbm+v+i51RiFdGCl
         XwIQ3gP2yZJjHoQnVWBqRlCu5iMO8KLrgOzAB6AsVDzXJFLJEHXgo+isVWlmi94zKB7k
         1GN6MO8CnfOKrIdg/udD7snxijezUB+GTamtFx4aRjlEWKMaWa8G6Yh1rjNYerixw3C7
         38uS8p8yKVE/b7lT120GneTDY3nhsj93WhuBRDS19l+WI8kkMsCDC9OBNdnGcedosxGb
         PJZNxK7Qi2wjQQFMB9f9TOTROC7J5vKzvNMQEQltf1AqViPMxfeoS4VUaHMuPCUqsOYo
         XRuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790178009; x=1790782809; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        b=li4hdrEDX/5Z8DHOw/y6qsUi1sUONsyvx3lG12TFxMYvRQoqALfPFpVLf0R//Y0iGP
         WKoL8ksZa5W6nY9JQEVR8U5cMXGhhnZee5X9CVMx4AQpKLBZAPm+vHIKKGg4VZ1ttXtA
         x4tlqWL0hWE/ZPXrneIDeVekssVkXqv+C0BuAsTcxLaCCy4H28tCI7fmZqzPJ9EZX7jj
         DMgfIX1DgcQJSFdbWB+oOn0/4rngbkZAlVRh0QCXMYMfUr2afUVXqiIYe/zHZYn+rY7N
         fs9gXo83wUSLBPndmSFaLWaAi262LzhKhMh26o7XEXLiS7XogKvbr1MEemf/56vDFXIq
         ByMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178009; x=1790782809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oRTF3Im1M+Uz/L6RRIk5YYuOIAwa1Ue8MbZXRrHJCXE=;
        b=23JCi2vbDb7QZobrlU58q7y6F4m4CAVCYTsIuOW/7XobdhCHe8o8/sLJBDTAddxxpp
         8xaJpz+EvXWXEmi+AlFvkMsbJ4Cx5lRUZcbsb5CSZC92kcpCblzO3dYYtWwclM2Th2En
         /dINOSA+8VbyLhE0PnFVZ1YPHUT8TXYM39yk1pjI2Br4HikXDzdyD7yk2CU5+zaEkraA
         VGAUgasTszSoH1Jv1VV18pxuZJtWVW5W9du9tU4R7OUwjPJf1KKrK5+gte3eq369nqUJ
         ZBMINPZGKlrDem9xiowWz77kuaZi30+nElLO+kw7kToQsqX1WMocAAff/bsWgVv5y7Vo
         cACw==
X-Forwarded-Encrypted: i=1; AKwUvBzAv3ac5M1JW/ZA7HBMW2riLj9391wDcu+bDfgZkRG/9JWQqPk+8cY4n3aC6jOzQp77ulfjUZSlqQ==@kvack.org
X-Gm-Message-State: AFuF++n1AT3kakSC/qqXGA+UGG0XgUwizCNEpyx73E6YDf18+5zxeWEh
	iMl/wtrCi/2L4hyiK1WDkRcxK2Edj4HsZ2StI5FNjb1YfdkKZrIGaGsAbFYSeN+GtjyLI13xsXP
	XClrDZEby2vbCE4OPDGrP5VL/YFKQ7Lo=
X-Gm-Gg: AYBFou1L0Jn91/E9sbLFqOii8CNP3HyoxihhEnKWGNcYMANZEOiBidyq0/e1IgIF7Ne
	kxtNDdkh4PwBrmA1usg3/wB7vu6oECN8GOxbMFfg0EBy9av/o5BQY9tcNefYzN0EdRz3J/W6ex8
	4oCfi7JQ1oNgPzmSKmdCleifDUh8/X5VnIE8pW1TNHLiqKyp1eYdEO7QIWlBREmvq+7DufVJ32N
	J23fBfGRaYtu2LGj2LTpP7Ieq9GzyrCeKsrbjt2fX5eiRE1JUjXOF1AI5bw+Ct6Xxv/Vy3En/xa
	ijyit9li/AxFiX1S5gUrIvzvHdEpJNFAu7fySy3I/H666duhYKW7n7W9GVobJG10gG0WzN7Kdhf
	B4Man8zgMomNNkBsODhq9dA==
X-Received: by 2002:a05:600c:3b98:b0:49c:ffe3:2b3f with SMTP id
 5b1f17b1804b1-49fdee0b045mr49105485e9.3.1790178008824; Wed, 23 Sep 2026
 08:40:08 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLi6cIjD2wJwk0B@cmpxchg.org> <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F> <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <aq8dja2-timYBwyB@gourry-fedora-PF4VCD3F> <CACePvbXudjxQ5vrrY4D1nOXKaFNQUn-tL+p3O0zfxtHXK99ojQ@mail.gmail.com>
 <e879ac65cb0940325736df7984c737edf1c6be94.camel@surriel.com>
 <CACePvbXThspPYD8DZkAeiJtYuMV79vGgC1SGhpMwhn4COWOtcg@mail.gmail.com>
 <785353ef79844e81a8cd97e87b00ef1f785b15e5.camel@surriel.com>
 <CACePvbXZ4i-DsmbQdNtBQb79y59uwZC9J8qHD2wTWpcYaet3LQ@mail.gmail.com>
 <83539be885f15bb567b30264f5f62e718f4a9fd0.camel@surriel.com>
 <CACePvbXZQERwLF_f2FYTHsv--kq_-Aw2vVVFF+z+ovdnsHy1bA@mail.gmail.com>
 <a75b2eac4297ca6b238dde6f9246d2c1807b935f.camel@surriel.com>
 <CACePvbW_-6M63_a7Cp+09dTmpHeMEdj9VDQZf8g8qoYKQD=wvw@mail.gmail.com>
 <CAKEwX=NrN7-u7gnGvWX3qfHaBQcN6FKsFP-4-k76F=sxM1LJqg@mail.gmail.com> <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
In-Reply-To: <CACePvbVuFULQVvi4UOrvKaJ-5kdWWU5iJH20gH-9nZ-6ZbEqMQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 23 Sep 2026 08:39:57 -0700
X-Gm-Features: AclHuK9yzZQ8knvLntjCBA5cf9Cy4ULZiHDGlI6Lczzxd1aMzXh7STrzunZTFqw
Message-ID: <CAKEwX=NHikpXLJio+c92EVp=uSqPgS4_JFkWg-9smkGM=XTo4g@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Chris Li <chrisl@kernel.org>
Cc: Rik van Riel <riel@surriel.com>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Baoquan He <baoquan.he@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m414ieh99n5bbwbek1m7bhppwz4mhmep
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8CB2D20009
X-HE-Tag: 1790178010-2090
X-HE-Meta: U2FsdGVkX1+F0K/zCMO4f59rDWUSZJBulP39c5l09y83TNcGRO8/8mhfin+QAoo9WurCHIJjeWV7e5fhUZt2OBwrubMK2u/yvZwMA6yBDQo27S3ZCSzPbLuSwMFuLNhv/oXrw+xrVwMc2AkSuMeHefczAvHGXvd9yksThrYUw9gq75H3VKBR1gdDj8ck7R8NASbQ9N8PXQShp6KH5dr6Nsu0XZJyw+VcO62re1dLU8eVQpCDQ0Jlw6BhmLwUJV90vf83JJsIc7qMpD+YVxMVZgqlnLNtLmzA/J2iP0h+ZKPod3Letda2GBhA2/LvP70ORhBXW46P2GoYdcmX+Ma2KvRwzlggwWNuSvUjRgRLENJkU3PYMC6Mte5CYbxVZDRDIy742Ak6wCTaAdbp+KyppQNlgC+HwF2pU0r5qtr3N1iTzBL8Q+gMiG5WJ3QnuBBpEMwfQj4EMfetEngxJ6LQbEF5YmNBX2f4S3VfmZppbnjtzizaMg0bXoFGkaAIAqtdWYm6NvowE5BfzPyLIzt8cxS1w8CBHiODQ72zOw/Kl4BWG1cyci0jie7hsD4ca1N7ykRiGSCR4HckbLlZ581Mm5AB+9lgViy+uADXDvvlcZ/LERfuq5wshNwRsPH2PnflceeLvP4oKFGy9OArYpES7zl6V5KcHGMR5ieEMQ2W7lYbH+/n4fEIX3H7fxq+9JstIEWbBq8bEElh8V5ohu/Vgyf7deciPvbGQ5JOHt8R0xOpy6C4g9bbOvhQQtlSpuM+4Yk/hbF6ribFqAYhUTBw68odCVCldcPVtoJEp37UUzqf/LOBUTNGvSYLexD3/vuECwfWRBion/JpVTDJOnFUrztdAn700ePX21AuK/h08w6mRy1f/9UY+IuWlzIYdEvFn28wI0xM3zt3bpQJjxfmDDVX841U0kGOXBV5OcXRPXHVYPSsLCK54STSO5Uz/qAIGR9hDB6WE11Q587/jke
 3a8ongYf
 nU2GZbwT0q5byUwOhqOHN/SK2QSIj7PXJMMUZwrmR6GeUWQCePh1IaCAj1ItiZ/Cstd/C0ZWZwXOSCqLFU+xQRMTnjDuxrB8KRGITO2EpIm1LRoOgcn8Mxtcg6Ko2UaNzYsOXxO92vRYLpgF23YX+KbPxSEmvGxp+WnPDGewVCLWh5OJLa7JTaD+xEdj3FdqNoDHUnkjmvcq0sj6GOPtaPs9cBLVDL/OPMfktQyHEohXtY1K14kDjNsE88CtiEPhRa8EuMgsPfE4OkGnv68vaWILTw2RX3AtRVbQq6fjTuBJLmU4Q/Mlfk1iuciApaHcURbMMqViSJ6L8jpXv0BpM9mHLN9NxsKhaGzCdnz8FB9CRPTzOJOuTE+ouhwq7HB/fI6Y/RcsOxmK01uQccZa7stjoCO225uIgM1CffaYDN7YMhokk3TcTVEXc3A2jht5q7tC+zcJ91d4LHO+UTnrZOG5+6QdJ7j1HxdL9bHyjmU0UctM31Rpe3M2vTpWxoT2ykAzdlY1C0H9EuyYl+HHcCW0042XK/pvQDyVfwEGVUAaD/nn/OZkDht6/zFfgomrrkbeqPBJ2SDrXjD9oHYIrKI/b8KXejIWYPTROe9I0a05g9p+KjP/J6Scmog==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 23, 2026 at 12:38=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Tue, Sep 22, 2026 at 7:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Tue, Sep 22, 2026 at 8:23=E2=80=AFAM Chris Li <chrisl@kernel.org> wr=
ote:
> > >
> > > On Tue, Sep 22, 2026 at 4:59=E2=80=AFAM Rik van Riel <riel@surriel.co=
m> wrote:
> > >
> > > Yes, I can agree on what you observed. You are using anon + zswap on
> > > that app alone. That is not what I originally asked.
> > >
> > > My original request was for the whole system: what percentage of the
> > > total system RAM size has been swapped out to zswap.
> > >
> > > Because when you have 100% of zswap out, it will likely trigger
> > > different kernel code path on allocating memory. You might suffer
> > > global memory pressure you did not observe in the single app memory
> > > pressure case.
> >
> > What does this 100% figure refer to? Pre- or post- compression size? I
> > legitimately cannot tell.
>
> The 100% I mentioned above refers to the pre-compression size. See my
> previous email in this thread for details. I have been asking for a
> max(%) number in your fleet for more than six emails now. My point is
> that 100% is not a usable metric. I suspect your deployment doesn't
> have machine zswap even close to that amount. Glad to be proven wrong
> with some real data points.

My point is that it's an invented problem because of the interface you chos=
e.

My interface does not require setting any such number or cap from
userspace perspective. The only cap is based internal
implementation-driven.

You're the one proposing an interface with static limit. You're the
one who have to justify a) why we need that limit in the first place,
because that's more work for userspace and b) why the default value
makes sense.

>
> >
> > "Trigger different kernel code path on allocating memory" what do you
> > mean by this? This reads like you're referring to post-compression
> > size, where one cgroup eats up the RAM of the host, affecting other
> > tenants in that host. But putting a limit on the virtual device
> > capacity limits the PRE-compression footprint. It is a very
> > unpredictable way to prevent the effect you're referring to above,
> > because compression ratio is unpredictable ahead of time.
>
> I mean triggering the direct reclaim path because zswap itself can't
> allocate memory for the swap cache to serve the page fault.
>
> Chris

Then it's out of memory...? If you couldn't zswap those pages then it
would just OOM earlier?

If those same pages are not in (z)swap you would have bigger
footprint? I don't understand what's your concern here.

