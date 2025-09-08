Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E111CCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 425AE6B0026; Mon,  8 Sep 2025 10:34:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5ED6B0027; Mon,  8 Sep 2025 10:34:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29DA16B0028; Mon,  8 Sep 2025 10:34:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 161426B0026
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:34:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4052B6D6E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:34:44 +0000 (UTC)
X-FDA: 83866329288.28.D67548F
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id C24201A0002
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:34:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IvFUuI2w;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbtUk7FrbyMvuG+t0mCuOx9heZkWciOxr2cORrysFDA=;
	b=Bspr9DEAqxNckwD/2XnJyB/GrjpwkBgf6n9jvPWC6vVCK9PNekuxSvTJkfHH2LDzrqfA+L
	zW5ZwaTgUM5bTr45NUWHbS5ceRyvE5nRE1g4nK/5s3jgzV0V00ut+yHA0mwgLGA+2vSYR2
	7WSucYEraN0YusYGBhLidq0Dla/lJac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757342082; a=rsa-sha256;
	cv=none;
	b=W7zeURiIvOXbEAKMcXrKT6FWlfdt3xEsw/BDhvxsFJDecycv+HFMYkxQQjQ3oxaqXQm74c
	EeodMTuBH3RrELCKS+6ix+sFbnhEIgjF2946WSEAzJ/BFCdJTO4vLGyYBuPmh4J8MC2r/6
	6ghMjXL6zRlZNCDmS/thCXvKP0z9Gt4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IvFUuI2w;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62757f4a2ddso2090560a12.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757342081; x=1757946881; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qbtUk7FrbyMvuG+t0mCuOx9heZkWciOxr2cORrysFDA=;
        b=IvFUuI2wjNK9bcVnERnmdZ5LjQsvQhW1j1iBqf025RPiht8zLY3QMTwURp54tO8Ez4
         3QNzmWzcNlhrzeby7k84/ocf2kGdT0m6neg+1zJ/wobPycXXhAIOK6Nv/d0ctGtjIzoW
         rs56ePvoEmuCp0FKnXFr/2+TOU5yjI2versmRlsbnnOpEV5JzeYFZ96ih38atDdjo+Z6
         7LFReeKb4qJ6R0r5VbizJsxLEdy9Ahi+bKaAZvjnXDI6v7sm0iNPFm02FdiD+g62S4vF
         FpxeAC31gaUCDHv/mnz5SVK7NEurdRKItAngufoJ1MZKNZ+4ih8XVHmeCKQOpy8ucasK
         GtOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757342081; x=1757946881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qbtUk7FrbyMvuG+t0mCuOx9heZkWciOxr2cORrysFDA=;
        b=weBCukWIwPJQgYD9yQx/dbsblae3J53AnEjmWj53h4zbTTLggmAM4UbOgU0s18cPPE
         QW0dWDllHnij+qwJxfxpTrRQjOgOQ5nPqCIZvVMRgYhrqhPZQVAm6B7J8+kK/iyebpf6
         oZm5CgAufYlq+0pRfPIztwQg9gA6zv6Jtg4Iy2w/4/+0QDp+EeUiwjMrUJ2He896i6i5
         APmb19AwLvfwijOnrfTg4ATCj2BSYW7QefLIRDwOEot1/wY/bo6XJCTSiO9QiQUoMjoA
         w4XDfYsWa1VDSM/8WGAyTeeAf/cjzMDHuDPagfbJZPJcepJov7zoARaYZMR5UL7A35Dd
         dP2A==
X-Gm-Message-State: AOJu0Yx3+39bgwx4veOJN8Bmh7cOHDBxVd7O/B+z6IrXc/ce8vuhgDoM
	SBuAmVH4vlViOuu8Zn4VPp9q73s63Ew1QKvaPGEe/iVjz8GXyDZr09IpmKNuhUO9I+Aee/mkFB9
	De1kUVgYQLu3CBAZ4Sta/13uGsBmHLfEvMhbHjZxPRQ==
X-Gm-Gg: ASbGncv2z+T3UTm/btpJ6JT8if2dV8j5XhjfA8K5hU6OnpYA4BNeaDkqBNzGV+9tKet
	dMaWI2o/a84II5ZjrOhJGitGgOqm1TJmJLi+x0HFtbVst5QDyOYNH5JpiwZuXqQ2zkp42rk+oQc
	kCgENMVGbTE0sTfJqpNh21+3p+NClv5/LfwXMeppnBDkTfoHd/woaDPvJ7ILUffys7OpfU8HipP
	gd/nsNOvC0=
X-Google-Smtp-Source: AGHT+IHqvEea2P3gZapZ7WwlegqtHpa3ecGMHI6Ur9DTfr6rTk3jnzICltbuq7nedWKvU+dhuo0b2dODtNrs673nXtk=
X-Received: by 2002:a05:6402:5242:b0:618:196b:1f8a with SMTP id
 4fb4d7f45d1cf-623725ed8ebmr6204594a12.4.1757342080926; Mon, 08 Sep 2025
 07:34:40 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-12-ryncsn@gmail.com>
 <vj7utcgrseaot6ktpbwgshthmjza7w7vk2glede273tza7yfi6@cyxppxoney5u>
In-Reply-To: <vj7utcgrseaot6ktpbwgshthmjza7w7vk2glede273tza7yfi6@cyxppxoney5u>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 22:34:04 +0800
X-Gm-Features: AS18NWAwbwczGgNQk1yhM1T5cz_8DfGfywC5MgRQgLVIxrrVVLjBFsAmV5awcxk
Message-ID: <CAMgjq7CLSuSfRwMYqNL9ZU3ehpZfR6oewHsYtLD4CTXcvEKOTg@mail.gmail.com>
Subject: Re: [PATCH v2 11/15] mm, swap: use the swap table for the swap cache
 and switch API
To: Klara Modin <klarasmodin@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C24201A0002
X-Stat-Signature: 48hqgzhyk94qby3o88krfnn3et5m3css
X-Rspam-User: 
X-HE-Tag: 1757342082-720679
X-HE-Meta: U2FsdGVkX1/bWANOhrTGstJSGg+A5q/eVV31t/uqze2jPdAfbpXNpIyL9tjO1uCD8zfoC8MdWxs4pTC28ksxYzJ2CamfQuh0n3EPu3P9z+OiFl/gPbDjigPd8PeOnq8FRnFel0D/BJNSnPp//Sf6wlKDOX28fcVs66cJKkc2rUu3rRbWmkFpz2wGsw2EzM4yY0X5kngXRPX4RgWDaSCIgusYwGzrgvSpvbCLi6egz4pf6J83+ggrjG92C0OMGJnQyELi10SJ0y3iLCA+dFrYusKc6wLDybXRIlIK3AaDXGdJMNAls/7B+NYK7rHBhk7EJ1zgY6zgFuxxXh64WRS1JdrgXrLBKvMVSB0mIrFEHGpzu61KHbk76OZE+fL9tPJncuDodm0GqbkLwuF8HDNK01oPV61YIWzlFI11irUqeaashHZDdFT/D+6FlPyUZPdEeDVCCCuw5gh8br0Gj20ftkx9bOgoLS8B5qQj6HBBUO2CMDvcnwXwrgEtVHvZdIGXWHQJEWUWZA8ouqZW1/hlJp1TcsBSzGuYzhhbYkA5pQBw26Q/mDieAyOf0tYSU2DlnIkHkhYwZNHsWBhrLYG+upwvRGN8VyWlyCNFAOPgFsHcNVoXbX7b5irhYmXytTPlguoMQHu9tVsKGVL34BxVKMnmW7C6zyt7ya3dzmFd2ueCaI9BXHt/kda9d6iZE4ABo++N6/mvELeYYSKbFuvnlTe35WDnF1T94SUP/zrSCG8Rt/lnT8iD4BrJyVLcTdEgRYP6U3+bzseOVFSBYqNQcihFmHhgkQVAU/uJOflYq/UexOV53AOGJYff+wwlc00xIZn4+J7ZY04rw7gTCDOK6ln4HQj4ucuAvL3tKbLYxyMqP1wXYQJYfHwyxu09IvdX3QAw3SduToxY8ENGt2yuV5ug1z4/8oyPVh1xl1uCnNrAHbHRag/t+/J8J4+CIGXfUBrmZ4PLLcfcqpO6n3w
 bqKkKN9v
 1yuR7Yai3WZfTIKsFppBUWI+y1dkNObJbo/WivUnd3UdwtDdVbJzgxA6gPpLofLIo2spJvCS+Zs5Z/m/WJChTjm1jXesFb7CrUPCAxWEkGwcZ3u5n4vpTDJIhnCsOropa84FhOCpgdu9zLhNWRz8E+iW9x9NN62gTeKkyV2CvP++1pB2NMjOwOSsyMj/tj+Ig1va4IYYKLya4MqBBYvwq8maYgeo+Y6pfP+y9vFIhJen0YFLGx5i3QbR9OYCk4jD8EN+DrM91mJyC5buabgAaBp7VX4ipqaymCWCMqNZsAuBevP4edrSxDXr6KP1dWA9XbNr4imVZgkiK8glKDHONqTs1/84nKfjJ2hYTRq+vuZcW1h/pduuJzk+/qRp1DsJAVUf7F3Vcc9i+UtFKNWa/rrqhVSXUlVw/m2GISoi6aHit5F2DuSIzuc2w25SStjTSfxqOV90o+XZeaM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 7, 2025 at 8:59=E2=80=AFPM Klara Modin <klarasmodin@gmail.com> =
wrote:
>
> On 2025-09-06 03:13:53 +0800, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Introduce basic swap table infrastructures, which are now just a
> > fixed-sized flat array inside each swap cluster, with access wrappers.
> >
> > Each cluster contains a swap table of 512 entries. Each table entry is
> > an opaque atomic long. It could be in 3 types: a shadow type (XA_VALUE)=
,
> > a folio type (pointer), or NULL.
> >
> > In this first step, it only supports storing a folio or shadow, and it
> > is a drop-in replacement for the current swap cache. Convert all swap
> > cache users to use the new sets of APIs. Chris Li has been suggesting
> > using a new infrastructure for swap cache for better performance, and
> > that idea combined well with the swap table as the new backing
> > structure. Now the lock contention range is reduced to 2M clusters,
> > which is much smaller than the 64M address_space. And we can also drop
> > the multiple address_space design.
> >
> > All the internal works are done with swap_cache_get_* helpers. Swap
> > cache lookup is still lock-less like before, and the helper's contexts
> > are same with original swap cache helpers. They still require a pin
> > on the swap device to prevent the backing data from being freed.
> >
> > Swap cache updates are now protected by the swap cluster lock
> > instead of the Xarray lock. This is mostly handled internally, but new
> > __swap_cache_* helpers require the caller to lock the cluster. So, a
> > few new cluster access and locking helpers are also introduced.
> >
> > A fully cluster-based unified swap table can be implemented on top
> > of this to take care of all count tracking and synchronization work,
> > with dynamic allocation. It should reduce the memory usage while
> > making the performance even better.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  MAINTAINERS          |   1 +
> >  include/linux/swap.h |   2 -
> >  mm/huge_memory.c     |  13 +-
> >  mm/migrate.c         |  19 ++-
> >  mm/shmem.c           |   8 +-
> >  mm/swap.h            | 157 +++++++++++++++++------
> >  mm/swap_state.c      | 289 +++++++++++++++++++------------------------
> >  mm/swap_table.h      |  97 +++++++++++++++
> >  mm/swapfile.c        | 100 +++++++++++----
> >  mm/vmscan.c          |  20 ++-
> >  10 files changed, 458 insertions(+), 248 deletions(-)
> >  create mode 100644 mm/swap_table.h
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 1c8292c0318d..de402ca91a80 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16226,6 +16226,7 @@ F:    include/linux/swapops.h
> >  F:   mm/page_io.c
> >  F:   mm/swap.c
> >  F:   mm/swap.h
> > +F:   mm/swap_table.h
> >  F:   mm/swap_state.c
> >  F:   mm/swapfile.c
> >
>
> ...
>
> >  #include <linux/swapops.h> /* for swp_offset */
>
> Now that swp_offset() is used in folio_index(), should this perhaps also =
be
> included for !CONFIG_SWAP?

Hi, Thanks for looking at this series.

>
> >  #include <linux/blk_types.h> /* for bio_end_io_t */
> >
...

> >       if (unlikely(folio_test_swapcache(folio)))
>
> > -             return swap_cache_index(folio->swap);
> > +             return swp_offset(folio->swap);
>
> This is outside CONFIG_SWAP.

Right, but there are users of folio_index that are outside of
CONFIG_SWAP (mm/migrate.c), and swp_offset is also outside of SWAP so
that's OK.

If we wrap it, the CONFIG_SWAP build will fail. I've test !CONFIG_SWAP
build on this patch and after the whole series, it works fine.

We should drop the usage of folio_index in migrate.c, that's not
really related to this series though.

>
> >       return folio->index;
> >  }
>
> ...
>
> Regards,
> Klara Modin
>

