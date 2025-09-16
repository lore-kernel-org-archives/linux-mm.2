Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2898CCAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 22:42:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D2A38E000D; Tue, 16 Sep 2025 18:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 682D08E0001; Tue, 16 Sep 2025 18:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFDA8E000D; Tue, 16 Sep 2025 18:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49B008E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 18:42:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4A841A0356
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:42:23 +0000 (UTC)
X-FDA: 83896588566.26.28F0F04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id EBEAE120003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:42:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KZkcLUZC;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758062542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cTXCjeRSO9rjJLboLAcqVsVu34C/0IlWeYDqZf+91m8=;
	b=TMnG8HtOLP4UVm92at9Lo22kGL0b3FqGxfiqOBJEbXevbsomHb0zsreHKliG9wG7Q5aIEo
	dmFOyjCSErnaStEJ5zy1kqljdgiRZACk1NV1J4Lrm3ddN5tZD1LWHcXE2pB8SUd1QtNFxq
	jwvS4ZJMLjmpiBSkB/i0veXRNEtyVM0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KZkcLUZC;
	spf=pass (imf29.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758062542; a=rsa-sha256;
	cv=none;
	b=lZwHNLLAc+0YTzfMts7g8il9GXV1MJCV3zrHlIJ/pG7dXTbCKGM6mKQURJtgtuOBvJ16lS
	RWDKcQqs9qYJfiuuPWcjRT48m+HnlAarb4XlCEKX5SETWN5VPQHffNBE/pMmCEJPmLVOXP
	wKF41LEyofi9slGKxzUEGL7Ihy/B65o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A26D244C81
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D4AC116C6
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 22:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758062540;
	bh=t4iTrV+CqcFLDpG4Gp8BKSUYWO2Ix48fUK0eR2N/m20=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=KZkcLUZCDSstkZ3Ty026dyokebf5jPCTNbVbbw7XSxBv6QWqs0Jw4YBWjxIU+INE6
	 IEf/UAFqrndL9634RW5NgSlYc2z2ei242KeZvvWQWiuMeyz3Tmqo5XsX/ydqQ4BDYt
	 MhtLjbwffmITqL4fEi4olcX82T906tXyWejOQQ8OUO9Jt2iG9IoiBspEm+Cxc8OFCs
	 xmUvJNkv0YJSo11UnyBYw2LLI3BhYT5lmWDYOZ5OXlXtVxG7ODY3E5HaAJNlpJkWD3
	 Yj20CyNOmHf8qZM5+Kk56wGchd7ZVguUAOjGDbGP2TEpNHfX65n1OPwHr++3Iqpoj1
	 beoT7wy6y1J5w==
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45f28aba94cso30825e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 15:42:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV71F4fWUiDIX6PnD5gV1C2bdPvpq8xZUkVQl2YM5bAxUHSPAIXfn0swTjlAs3dSLhq/lIHWtPobg==@kvack.org
X-Gm-Message-State: AOJu0YyFlR4zcPh4HW4LalJ6ASBlSed8o1ZjoBzWkIIuKrrSu8o+pb3P
	S9wjFu1gsQQu8Kq0jVi7A1NPEXYYeDckWYASsZQqyFrUMgtamVTVHqePq74bHuhmFP6S9nI0GuX
	YDzmwICX//E40PaPeqXzfbyAWrtEP6fCKqiW3D2hy
X-Google-Smtp-Source: AGHT+IHWLOmuD/tU8v3ni2BKIAlWeib4S+ucs/1zjlARg1seSLctmJGnrUIwP3gUbQopXbQ3T+B3asPvoCAu+Yfk/Lg=
X-Received: by 2002:a05:600c:26c5:b0:45c:b4fb:f0b3 with SMTP id
 5b1f17b1804b1-461a07c7283mr159535e9.3.1758062539040; Tue, 16 Sep 2025
 15:42:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
In-Reply-To: <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 16 Sep 2025 15:42:07 -0700
X-Gmail-Original-Message-ID: <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
X-Gm-Features: AS18NWDQO70jEWQyR-tJB4PbRe5EI87TY1HG1tDIFqnOkXu_DbegsZNLqYZwqoM
Message-ID: <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Barry Song <21cnbao@gmail.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EBEAE120003
X-Stat-Signature: bgca8jhmshdej1zq6w46k1pqmo7pgarf
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758062541-678988
X-HE-Meta: U2FsdGVkX19Qdqx+B0qa9DBmWB3LplvQb1GOAuq4zj6Yjarm+Hs6XedTDgOuL2Kj2sL0e8V+u0Zv6Kg3reypAa4wsjA9obVqo/tMZ3tJCHOZKKuPSu2eflhHaI6nnoJv7pdVvOJHIoge3+mTLxgedKSRiA1/voIeUmAUCM+tSCTyHIVsbpsx+6yI6HpO7cDSCl+LFKvq54OJMEoVE7s9G+XVed+zQMvl7tzPMY09y8kLyRerlBYcL4Yco1/6NwRd2X77QeAjolfGVLGZ3FG89+3jyKEViLdncenf8iButUwNUCa8NEYQIndmT4nBKOZ9YD4JAQ70+nfyP3ECAHpG/44CaCdRc2JjgcTjIddl7L84BcNCN5/aIY+DYf6uiG84JVQelz0axaPLGWKgG41QXuBXFUUrhdEsPaHfmveoDlJG2TJkbaAQ0Pb4Lp0zLKE0yNFeju72a/DguvDglw2t83gyfpp/7abtIhR1PtZdTJnqyd7TNfNgtKWjkira2c/skk4b7hE+ZAUGocRKF5u5iQ0TfNag22XYbsW+j8NTkeHJuqaxziHsW58UB2ztotzLCDl8fd7FS1rE5fR5FUZkhxeu055Q5Iu1R7p6rm5Y/H1vs1DWY9KVEQwCmiml1lh/mbDlceIOiH8lR47N7fjId48eDG5kE6+YmZiyIboLCwuSJ8u7dkH2CemHXnN23NFysxp8CzP7WUlHTmRa/4/tPrNpNn/OdoFX+mT6QITm2IVQwOgiYkpvWaFxLYu+tg2HXVqbxCnmwCRzcPksoxwETZd4bx5Cm1KVaP7xFwCNNrw9v8sZn6ZnsT6pN9tS9F5u5QvgfpTlzXTvUIkanpqssD1J6nMhRH0PZbFzGggHp4iU7JvuSXYmysDHojs6DXrgYljGVFt39qhETpZVBv7eQtjvPYcnBRHgvwiE9T4BNDA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 3:00=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Sep 17, 2025 at 12:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Chris Li <chrisl@kernel.org>
> >
> > Swap table is the new swap cache.
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  Documentation/mm/index.rst      |  1 +
> >  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
> >  MAINTAINERS                     |  1 +
> >  3 files changed, 74 insertions(+)
> >  create mode 100644 Documentation/mm/swap-table.rst
> >
> > diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> > index fb45acba16ac..828ad9b019b3 100644
> > --- a/Documentation/mm/index.rst
> > +++ b/Documentation/mm/index.rst
> > @@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpos=
e.
> >     page_table_check
> >     remap_file_pages
> >     split_page_table_lock
> > +   swap-table
> >     transhuge
> >     unevictable-lru
> >     vmalloced-kernel-stacks
> > diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-ta=
ble.rst
> > new file mode 100644
> > index 000000000000..acae6ceb4f7b
> > --- /dev/null
> > +++ b/Documentation/mm/swap-table.rst
> > @@ -0,0 +1,72 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com=
>
> > +
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +Swap Table
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Swap table implements swap cache as a per-cluster swap cache value arr=
ay.
> > +
> > +Swap Entry
> > +----------
> > +
> > +A swap entry contains the information required to serve the anonymous =
page
> > +fault.
> > +
> > +Swap entry is encoded as two parts: swap type and swap offset.
> > +
> > +The swap type indicates which swap device to use.
> > +The swap offset is the offset of the swap file to read the page data f=
rom.
> > +
> > +Swap Cache
> > +----------
> > +
> > +Swap cache is a map to look up folios using swap entry as the key. The=
 result
> > +value can have three possible types depending on which stage of this s=
wap entry
> > +was in.
> > +
> > +1. NULL: This swap entry is not used.
> > +
> > +2. folio: A folio has been allocated and bound to this swap entry. Thi=
s is
> > +   the transient state of swap out or swap in. The folio data can be i=
n
> > +   the folio or swap file, or both.
>
> This doesn=E2=80=99t look quite right.
>
> the folio=E2=80=99s data must reside within the folio itself?

For swap out cases that is true. The swap in case you allocate the
folio first then read data from swap file to folio. There is a window
swap file that has the data and folio does not.

> The data might also be in a swap file, or not.

The data only in swap file is covered by "data can be in the folio or
swap file", it is an OR relationship.

I think my previous statement still stands correct considering both
swap out and swap in. Of course there is always room for improvement
to make it more clear. But folio always has the data is not true for
swap in. If you have other ways to improve it, please feel free to
suggest.


> On a 32-bit system, I=E2=80=99m guessing the swap table is 2 KB, which is=
 about
> half of a page?

Yes, true. I consider that but decide to leave it out of the document.
There are a lot of other implementation details the document does not
cover, not just this aspect. This document provides a simple
abstracted view (might not cover all the detail cases). One way to
address that is add a qualification "on a 64 bit system". What do you
say? I don't want to talk about the 32 bit system having half of a
page in this document, I consider that too much detail. The 32 bit
system is pretty rare nowadays.

Chris

