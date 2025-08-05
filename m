Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C6C8C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 01:22:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7681E6B009E; Mon,  4 Aug 2025 21:22:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F2176B009F; Mon,  4 Aug 2025 21:22:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9C96B00A1; Mon,  4 Aug 2025 21:22:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4893E6B009E
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 21:22:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F3B75C074
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:22:37 +0000 (UTC)
X-FDA: 83740953954.13.F457460
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id E132A1C000F
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 01:22:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2hqfmH+c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jyescas@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754356954; a=rsa-sha256;
	cv=none;
	b=DKCE0dl5jJBq/3Ze24qVYaYA0ZC2oMp7Kv/Dx+tFFLuRFDm5SLcLGB6HHct/hm0tbEh7dd
	FameQt2AULTlNgXZA9IZSbPs6ubg+Rpw7gotlsCLo6T138EKGFdyrEoYD5DNAeGtFRfhZr
	esn4BdXSYJdtLUGdRkttDW0xvxUgPZg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2hqfmH+c;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jyescas@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754356954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAJ4RHocJtdCibwUW7vMzbUCC5UcCNRUv+aRR+ZSOM4=;
	b=K6V/R9oEoq+W68xr9reaWhFxq/R1vPyrpFyMl3XSjDD5ak/h7/PM93U+mxaRuCPJh+sA16
	JorcM4h17k3zWqTwEyxypCxN/5CLzOohUfnkKPMoOHxutTp7utMuOi+t3u3vk4poAnJD4a
	net/xUWIWGW2shP+Mpr7ssBEh1Q444g=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24070dd87e4so76815ad.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 18:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754356954; x=1754961754; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hAJ4RHocJtdCibwUW7vMzbUCC5UcCNRUv+aRR+ZSOM4=;
        b=2hqfmH+c372pIWcjXsBepOXNxxPEsFVGxkWOyDpIxbmNgw5NqdoNpNz4Ul+vBjdJIP
         UutolEv9uMMsFirq7xrx+EQ1wYgn1tapNt10C+nPQ+sGf24C/I+IjzkAUPBNDl8pbVPi
         BnUUbfHWJi9IEvWXqZd35UB0/aNdFaP4mSA7aHhYF6m5MsZqynxqSHq8ndvJ1Hsfxknw
         vys84wGimptLcp7w3DP5/dXFbi4meisNXEv1lzitErxRR6ffmSw3UepOyAtD8ReCtlws
         mVA6jUyKXCIyqY5/ObarkpU2b68KxkkElVjWq58DpEBiuVY957ypEcFCRtIhBs07n6p1
         I6sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754356954; x=1754961754;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hAJ4RHocJtdCibwUW7vMzbUCC5UcCNRUv+aRR+ZSOM4=;
        b=IP/2vQbt0x5No443YWRcDBg0iG3n5HwZ9CjDVMTYn9up+GiuZE/ls0yt4/eP9IsTpJ
         60kF3+bWcxuJ2T/9f3NrylU5sQPFZlqMfJnx0FbxpKJHw2ZnPlBJx5mzcXYTHYsX2wPb
         sRLJ5p7iBx47MUD5GvcV3qb7lSpnaAHiWKVg7jSO0dfkS+6QNDIP9QeIm0Csy67EsrVN
         QUk5GGMf6wgqE1aG+EN7Qwrheg0LT0TlFQQGIWXDgrn0aOfGbJdleAhxMyT4e4aKS+DD
         DXqOrT+wUesh+ldWKF2zOVBX+BzyTRcBpmvCPYL6c0YKlxFk5vayiQLhKWt6vzGjwykW
         Ppeg==
X-Forwarded-Encrypted: i=1; AJvYcCX5Bq/t1z3qSFc5bh7XpWIno7743+Ru+K5+f/u949EszSKTHID0zr7DiDrfon7yBcUNgM8/L86pXA==@kvack.org
X-Gm-Message-State: AOJu0YySHXgY8EYLUO59KqhdyyBO5nwJnxbgbGFeyRWHqv0nvnth1o+r
	cICvFBiUPIWu/ptk+q35aWaSUvSFprZg1KHKJyynlR6A7UvYxua3Vo4TkAz+fb9/MvjUO23vr16
	rEtucF9mcIgpmR524kHQSoG0SO9+HcfQzb8cg/1WZ
X-Gm-Gg: ASbGncuM3AmCMDmIGjfgeTIhSPKX/xlU/8jqVOxgOO/LZ+IR3B/5dxGlFGslZ0wDnj2
	jJ66+4uUL+cp25UjIDKjVBfi2N64az31HnNBVlOAQHWOqv4bknSS0i6iS7nszQ1l6bQ3vHujyHZ
	HSrP5m0vMgEZcbb8oQBIE9HDQqorJjyUENXb6DW7VlT4MOmB0kq3Et59XfpZ4599T79RU8l5iu0
	RXOVfZY+Ii3DUSQzJBmMIxwBwO2o7nH1UlSWIaU
X-Google-Smtp-Source: AGHT+IHUNdtQwZDC9iJcA9U28t/KjMRhfY0lm9oTiYDKuEahIO/YtsfurNp2t+vB8T6wdGKdYuKho7IuX7hBOXsBD6M=
X-Received: by 2002:a17:902:d50b:b0:223:ff93:322f with SMTP id
 d9443c01a7336-2428e9b08e0mr357745ad.2.1754356953205; Mon, 04 Aug 2025
 18:22:33 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
In-Reply-To: <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Mon, 4 Aug 2025 18:22:20 -0700
X-Gm-Features: Ac12FXz6D7iBBMFZt4PN7BOj1xXY8Im3BiqcIN-p29imUt-Q6tjBh8yWlEWjeZQ
Message-ID: <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: David Hildenbrand <david@redhat.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>, 
	angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org, 
	Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com, 
	Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: es1m7ngzubaqsp14b9wft3f4af44sfs6
X-Rspam-User: 
X-Rspamd-Queue-Id: E132A1C000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1754356954-329735
X-HE-Meta: U2FsdGVkX18Gq+n9xQJ6/vKbaK4hHfuBhx4v48cYWWd9zyFyJ1/a6pDx2zFb5noVu0x6ezXNPyxqfu94LvncQO4Z7/zzUlMa8qxzWrrNV71NvmksPHG7R808FZKXM3rOiRPlvgAFwUenXnk8TjfYs4aNC5DmMAPBlGTt2sBopo96VD7zaKGWQkZ6vThJkrg62yCzw2VQp4Nys27raGF20t/m3YSLGxYUmpWgem9VX2jVX+eezYwtH8R+b+jFXgzvz3Op/3gsaWCLfs2ktAXq4Ny4rlaRLugaQ95XxfYdvyGVzTYXei7kj6MvXqr9j50O9MLoVSy9XPq1xdaz5lDdN9hcirJAMszXDygG93y7W1HwNlM3XlQ1zFbElAQ8YyxmDo5RQwNw3f8AkRP7EMawducNl6T//k5nY7wHKogEvZewdbB9WrK6Ebw08u4OhekM12iD4U33VZC0+/ha590oig0zwGgeVU1Z05ReJ66nJ8f2woNQ6SuJlnZ+xU6psKbMIzvvqBPWLcyjUUiLUI0piL4jzdqdLI7jQj03qm+J2j7hkrlEiMI9Xsp10VTNdNSi/ehpN0p4c4dzuG3u4xORMT8IfI6e+LNao5EIUpuzkT0EHlKCMPo/miOPcNu89tvHLGWLjMNECSR6AHFXcfR17TMVq7vjsGKKgELvxGnYaLP/Ss9JNW8tgaOTNHW9KXSOpkKJ1GEQCkX2AcUw/xoPsaR+H216M6rBUfBvlfhzsNRO+5hgSWcQsP4jhOWOFq9uBCprOi3BCp9snm+e3kIjQ5E+hmSYd3aBPZuRxxMbkGbztn3iRicqg6zpya9lTaNe4wphqBfLMiO+Nc8zUSvl8+2MmRYH77FMh6HGrOarAGo5D37qTohEmDysCOiYCjXcDDFCvVScnNaYRGDESZPy2PYJ0jXu96AwMnBLTYvlMAg3T38UuOyOsXRPr8IALzQCOj4E3eKfa0ShGo6HMqL
 1Qq9N1Qk
 AStiV4DTC5nlhTol8Zc8yAbNx/6t1vf9ZXB6fvqEZBHDi8lX0T7hlKWEqQAndQ9umTAJPqzZqXVtLRSnY/ZQy8r13swv2G5M0aipBcddeXuehZqrz58/eMXkAyDMy3RFXukLvZCUCdOpf6v+5fzw5TIuzI3F+LEBto2FeM36fFamGwno77h6BEv612dnY3x9j11vjpldnTUhAGZurCLAcyReySLt3XNZxWC9Lny6n9LGBJHeY5CkrJS25FmwIxKgXUUnfK7Og72yCYYm02Qcj2fZyNTYML88oFiAMw3odp2cIF0lGv3+YPUQehDiam308RXt+BaYoOOJiuOPh995NnGUkDFhAA8Wp9NIuFfJmay189jXbrf+Pt7V2kFk/za3+ollJZ59vZFYpZKrOxuv7Fr5I6YSvG0lR7QJG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 04.08.25 20:20, Juan Yescas wrote:
> > Hi David/Zi,
> >
> > Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?
> >
> > There are many devices that need fast allocation of MIGRATE_CMA pages,
> > and they have to get them from the buddy allocator, which is a bit
> > slower in comparison to the PCP lists.
> >
> > We also have cases where the MIGRATE_CMA memory requirements are big.
> > For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500=
MiBs.
> > These cases would benefit if we have THPs for CMAs.
> >
> > Could we add the support for MIGRATE_CMA pages on the PCP and THP lists=
?
>
> Remember how CMA memory is used:
>
> The owner allocates it through cma_alloc() and friends, where the CMA
> allocator will try allocating *specific physical memory regions* using
> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
> page from the buddy (or PCP) lists. Doesn't work (just imagine having
> different CMA areas etc).
>
> Anybody else is free to use CMA pages for MOVABLE allocations. So we
> treat them as being MOVABLE on the PCP.
>
> Having a separate CMA PCP list doesn't solve or speedup anything, really.
>

Thanks David for the quick overview.

> I still have no clue what this patch here tried to solve: it doesn't
> make any sense.
>

The story started with this out of tree patch that is part of Android.

https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T=
/#u

This patch introduced the __GFP_CMA flag that allocates pages from
MIGRATE_MOVABLE
or MIGRATE_CMA. What it happens then, it is that the MIGRATE_MOVABLE
pages in the
PCP lists were consumed pretty fast. To solve this issue, the PCP
MIGRATE_CMA list was added.
This list is initialized by rmqueue_bulk() when it is empty. That's
how we end up with the PCP MIGRATE_CMA list
in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
allowed to contain
MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
for THP MIGRATE_MOVABLE
making later allocations from THP MIGRATE_CMA to fail.

These workarounds are mainly because we need to solve this issue upstream:

- When devices reserve big blocks of MIGRATE_CMA pages, the
underutilized MIGRATE_CMA
can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
we require MIGRATE_CMA
pages, the allocations might fail.

I remember that you presented the problem in LPC. Were you able to
make some progress on that?

Thanks
Juan





> --
> Cheers,
>
> David / dhildenb
>

