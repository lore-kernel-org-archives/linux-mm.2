Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADE9CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 17:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D426F8E0064; Wed, 17 Sep 2025 13:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D195A8E0002; Wed, 17 Sep 2025 13:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56DA8E0064; Wed, 17 Sep 2025 13:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2D708E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:12:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76DFD13B6DC
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:12:53 +0000 (UTC)
X-FDA: 83899387026.12.D1C7040
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 88AE91C0006
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:12:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zc22X9eD;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758129171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBDy5aQknT2LjcTft4G9rYWB+eajw8KCcFNFSIDc2js=;
	b=Fl2ntzqVXv2BmeNe+CbBEb1NkMV8S93a+wk67DX/BwXJSWKeEpELisPPOWdORmcL1niEzf
	eKsQ9/gbGqutPcM+N5+GblNPd73i5LEcmdry9yH7BtrGiThy3dsAC5f6YPjerDG4Hbfu0R
	DRScv5ORNJiyQhWpCOaYPghxEylU6nI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758129171; a=rsa-sha256;
	cv=none;
	b=sGqDh9H8OqiITikmtM8duFfSI4VspyRSKLLcx27hdiApE+U5gRLDxQQa7/7vkxcEDXD2Ob
	46307Ozv96kfvEyM3wAHhUUGs/IhdR6KX3JknpH2Rrx3Pwto8DLz/U12y9CkM52AuaD0Zj
	ucpJB923fVvc18Qz5y2YGGiIm4cAsVE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zc22X9eD;
	spf=pass (imf20.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B08844F41
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5678CC16AAE
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758129170;
	bh=6yuEuVQsyw6TlrxFPqJhgc7eImQajVyZhThJ1SvONOg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Zc22X9eDpdOL4W4eBKizdfaCC0VttxSHXAwiSQtGB3WvAm/uQvG2TQwRUtL3kV9W7
	 4+efetiASPjcbftC1O/BYj8sk+STgg+zhMHnLgQWh/4VQVSdfYnPQjc7xW0g1biXSi
	 bzkNVcBIuYl3T/5SHZ6YHA78P3MboYUUodLEdcvgGM5/OjojHxwJ+OUqNVvB9BmJIb
	 gk+Krxh82BdxEfUhItMAftlmWQgGxgEgec+PU5xCjQSGnwha0xXo8evW+A74WrT3vY
	 xaC693d7aQ7Ggvwj6eLrrBCTRA9d7RzsTdpoQlxwQf5WCtldaekecAoAyypN0lVcqf
	 QtOHtsceJmxFg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-71d60501806so735147b3.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 10:12:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU6paELWD4rr58DyKlABeA7tyEPprr34CsmoKoLfs+VzsXR2XlemRgnlEV4Uzqrjki2HRTXr8iJLw==@kvack.org
X-Gm-Message-State: AOJu0Ywf5oHoIprXw4LhcZ+7nmOV6bcbztHxfDHfwVfVxxgYZBkEvuI+
	sFBZSHBgi0tn7gI1HfHbM+Cf9ETDua2rVkwuIoBBkZ24jRem5/HRIXz2BaWxo0cH+4+qyMB5Rkr
	XVbMLWwlIY1Z0yK3oFx9Rjsfenj5ncggXm4I7EwaXjw==
X-Google-Smtp-Source: AGHT+IFd888IRBE4Sf82BHMCQfDhWqTS3ION4XiTCcKYpkm4cn07bM0uPiFHOr4mYnxepbYWwhnWlnLG5H94D/W/SNY=
X-Received: by 2002:a05:690c:48c5:b0:729:f78b:4261 with SMTP id
 00721157ae682-73892549c74mr22655067b3.38.1758129169547; Wed, 17 Sep 2025
 10:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-2-ryncsn@gmail.com> <20250917161432.53960-1-sj@kernel.org>
In-Reply-To: <20250917161432.53960-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 17 Sep 2025 10:12:38 -0700
X-Gmail-Original-Message-ID: <CACePvbVq698sKmH_oWi448HybDS0EB8DKXte-pFVB5mwvcNA+w@mail.gmail.com>
X-Gm-Features: AS18NWCm0IEjP5lKC3pZd8YW-DiiHhyK2Pdy3yyGTDhxAVu8k_fGiPAVahiFVEo
Message-ID: <CACePvbVq698sKmH_oWi448HybDS0EB8DKXte-pFVB5mwvcNA+w@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: SeongJae Park <sj@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 88AE91C0006
X-Stat-Signature: cfrxwi43ttixahith6uu96pzfs6fjjwi
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758129171-324390
X-HE-Meta: U2FsdGVkX1/WwlzYSiXlwAeyk4A7V/RvnJDDjy5egL+jFh9rdFIHkBpaKTK5b8AU18DeEPDsHpesetGzSZafX/T2Ya3fifRcEv5KrpoaDyjdRPFmA3WwbCJFeMczZyX7lk4W3eNHlXLlU1A+kBY8UmGlQOOtz5s/uzvbYq0gX6T6Xo7nkjzsAMq56J1HsCh7YoaIvsNb69+ebE69OlEZ9kvac/8uH0sIhZkmfO6SbqCqtBYQP7CisKlqbi74uSkFYvhVux/nEj2Iu/JudDyiXgFH8G9xpl0XZZNwWun+VsNau4sV9lZrudE3L6Mo97Gyx7qQvLilfjRCdVR9lekZNvLbtlbHYTzzQhhkOH7LWZBdefo5axINVGZkzu/cLlToU+Yw/C3Pg9VT/bszLWVpdZc1CuRY8j/3u1L/EQVAATBwjAN4KQh7bof6TB2iqjA/TBvkLDZkf0sTa3r6a7JYI2m3tpoWW+4Fyl1BqUdkmCbVM5ziBkd5E3/3msHL20dpiz/mc6kxzMLDaI9cgLEJDpL7pgfFcYLc7X2c4gHXOAOMjqEMn0+pBI2Ef9pPEN8TYGzgXI4uT6gY13PYeo1L3IG3ArIg+MqNHotjajeXEtPw5Q4iti8W5jZ9sdKJMwLgHzEOyxfdlXQSVT6kQsdpf8I/Zw6H5hsTV8lwIQ7InTbLZdhEwOJ5P4U/eD4KllQeqmg6X1VySxDJwHZQ8Ovbz8cPXwCXUw09DVtOuKDjsGyodR8cGLdQubSaMRvnA58auytv04quKmspSY/9cJQ+GLXNboR7UGroeAI1qh7ZwQB+LBOT4R6F7vlpUydgfuPXfVb3TuUlzFvttKj7tjx9V2HC8ILU/wvRq1ERYlSx5WAvzarhH/rN3WtYgNBv1WzkOAVq5OLlyqjqyccvwJMYiDDEQoKf29lz41QbRi8AqBy3dlKFx1vXrO4+e4DR/KI13aYNYlyovvg3Yi4PtbO
 lFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 9:14=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Wed, 17 Sep 2025 00:00:46 +0800 Kairui Song <ryncsn@gmail.com> wrote:
>
> > From: Chris Li <chrisl@kernel.org>
> >
> > Swap table is the new swap cache.
>
> Thank you very much for doing this great work!

I only did the prototype. Kairui did the heavy lifting.

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
>
> The above diff is adding this great document on 'Unsorted Documentation'
> section.  Could we add the document on the main section?  I think swap.rs=
t on
> the main section could be a good place, and wondering what others think.

That is a good idea. Will do together with another minor fix reported
by Barry. I will move it after "swap.rst".

Thanks for the suggestion.

Chris

