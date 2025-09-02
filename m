Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65698CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 983EF8E000B; Tue,  2 Sep 2025 08:46:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AD8E0001; Tue,  2 Sep 2025 08:46:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823728E000B; Tue,  2 Sep 2025 08:46:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7DB8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:46:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 175F0138B2E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:46:31 +0000 (UTC)
X-FDA: 83844283782.01.F95A94D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35B7710000A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:46:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VB9JPZA9;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOieBAdKq+Jk/zOQnhoH+w34fueGOes42t8OWIFbIDY=;
	b=M1pB4EnlajCIme14iuKeu3mV+51lSz+GZgsQAv5MeV6cyBjCZq5eTWnDtABNhBCj++mQFd
	Ob2ILxTAPnIimzHcVaKj4VqsgYK4xGSakirSjXXObjjBXNKxrjvXAg/sfiC/klCgScnLqy
	JYs432m+OJkrtdlS520QUN1fKxpeAE4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VB9JPZA9;
	spf=pass (imf14.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817189; a=rsa-sha256;
	cv=none;
	b=bTsI5NAK0A37ba+lK1KSOfRHLog7VKo5PEnTReZ5raqppBffVmryGYeCHxOcjgJzLbppZF
	yZzChOiinMI3yM66TH5tjnHVuLztXh6Wkmbk9pIeJx2+3VZXQTUXdBUO6MYFbeg1wZNr3C
	YQJ4vmEA7WFT8oHWrjkKqFzI0elNo88=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7BCC43749
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:46:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD50C4CEF4
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756817187;
	bh=jOieBAdKq+Jk/zOQnhoH+w34fueGOes42t8OWIFbIDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VB9JPZA9RCu3qjMGQAm74GWgS1xp9XUsEB45Ary6FU82UenY0Zn8adZfIpI9h566K
	 FQVEdDLJuFO1+qrdMgHTfCnzzxVtxxu4Fugjy1a3SgasusIMkYMP+0QpEqhCY6OA7y
	 AK8dyPkQkwJ1JBAOcfyNwStnFC+xn4KBz6NDKc/edNsUE/K9fP3YpdRGaUlgsdfrEH
	 xOhcK/Bt/UDkxPmftvswm/BEzIYw1D9bZLkRneahihjrxpeirCp8jwPubeiRLGITlg
	 Si9IoQc2ztcJ8paiBxL5nDcN7oZoQa7b1q30uAPoK3NoU0RWHfY3ZcjTHKO4lxpJKJ
	 bkiAsKZn7zq8w==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-723ad237d1eso4019367b3.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:46:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUZE7pQA6n4xwpP3zsRCmLzrv0kvBlpoUYRGZ2sI71qwFkp+pZJFibYv52PvqZI7LTlrRXRuJKHhQ==@kvack.org
X-Gm-Message-State: AOJu0Yxy1Q8hTyoPV0oqCX39AjLyt8wtzaMDid24LRS/vXONGHV/AVDh
	n0PwEt7yZbJZh7muPLOdq6sHTK1e/HAfOSEL3kMoso7nj90lN+mRmmFCyMDsqTlFwVFsyhHjyUL
	Ztvek6pEhMAJpvkuJ/RTgzKjiBYfUEUHRnoFqtt/8+Q==
X-Google-Smtp-Source: AGHT+IED0lg2698fOemE35zLVrPDmVbySfg8LCS3cQ4HucMwxzGZ2PHSsimY7oa1U9hph/JcpzmWGJ+uTLEqNf7mybM=
X-Received: by 2002:a05:690c:64c7:b0:722:6f24:6293 with SMTP id
 00721157ae682-722764d1a86mr111055047b3.32.1756817186932; Tue, 02 Sep 2025
 05:46:26 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <911dc3b4-c511-4ef2-a159-091780987965@redhat.com>
In-Reply-To: <911dc3b4-c511-4ef2-a159-091780987965@redhat.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 2 Sep 2025 05:46:15 -0700
X-Gmail-Original-Message-ID: <CACePvbXs3J6qYWFycVW8rGjiaOw9iTFLdWq1Lq4HyaDkSY45uA@mail.gmail.com>
X-Gm-Features: Ac12FXy7nblHn4LKwFgkQrQWVUfFCHgtM428VnsEBAgz8jKNZju1D-xaxLOVN18
Message-ID: <CACePvbXs3J6qYWFycVW8rGjiaOw9iTFLdWq1Lq4HyaDkSY45uA@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: David Hildenbrand <david@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 35B7710000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 759oksgpxwpodwt68etyngyihsqhbong
X-HE-Tag: 1756817188-193977
X-HE-Meta: U2FsdGVkX19Yx1J/OLAEAoGIbQdAzCPQcD8gTPo7eCYGEG5YSOCzIZP6EbtHmJH/lCKxHSceZWnkKj7aroH4NxPx6hAWVQ0CFkVr9TFoEm+W/l9ZrcDExVbA3jEaw4/4JU+IEh1l/TY3yI93hj1b827mvYwX3koRREgf+EtcL9Iw/ue2gb/SzkMJsWtwvWMY87wuSqx6Tt6oMAsjVuy3IW6WdbiUi6uBkvNyoIwoXNo8dtN0sr4A6YVHTHDB5C6kfMa+0XYQ7YkTXv54MWV/TlGkz/sQDVOF6VOIU4aGBCSQYu+8X9ln2jdrQHgww1rV55o5gTVLj/sE3OBj6tkusVtA84tYZuZnUI0AW1ECs8Kcw7NMIVFjxC+duPXytM6mI33jR6r2qQUhZ1MRn34dSY0M7SyLxfeuGCVoShzhz+H9thv6nFsunVTjuZfD1saasHNoQH/LNNLRQTNEVQgm13ais+LIJvVteh25OWndOXFk+7DqHGGEZdUEuwNiUzzmSyihDx0ilEAShPnKVpBUEuytx6sRUDhG4hARiAKKJQFhdJGpLXFAo7PEgHjVy8IKeYf4Y5tZZYkfrKOQlADWOyKq26UNgRU14cUs5/YVGI2mVfisL1lDMzt+MLD0IxaxnVPjXm0V3P/roW+lta+45ecoTxWYBlKlm8lF32Znn1by6pKwfIdwl3ju4/9tU3KT19F51pEhoqWhoKfm4hBFXSLFGuQnysZTYCWTb+GLJq2HX9cl1k7JCuW+AbjD1FzsrxMWIEJ7X2imracvE0QyROcLENvXUaRwK+TyGj0fLeIqH+G3kNOrtDYiGm+e5Ju3POKkYP3tqfgIC8Q1dc2wHvqGozGEI+PFrb/ULzhO59fUS2mf+7PdsKOhvkIIsG8akdK8ZwYSeu1zRY8IQjqsGt5EyarQezM0qR6UBMpVswtsX6ldlzx1Swc53qjLS75fba0Ym52JbDKg9UOaG72
 Z2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 2, 2025 at 3:18=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 22.08.25 21:20, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cache lookup is lockless, it only increases the reference count
> > of the returned folio. That's not enough to ensure a folio is stable in
> > the swap cache, so the folio could be removed from the swap cache at an=
y
> > time. The caller always has to lock and check the folio before use.
> >
> > Document this as a comment, and introduce a helper for swap cache folio
> > verification with proper sanity checks.
> >
> > Also, sanitize all current users to use this convention, and use the ne=
w
> > helper when possible for easier debugging. Some existing callers won't
> > cause any major problem right now, only trivial issues like incorrect
> > readahead statistic (swapin) or wasted loop (swapoff). It's better to
> > always follow this convention to make things robust.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
>
> [...]
>
> > +/**
> > + * folio_contains_swap - Does this folio contain this swap entry?
> > + * @folio: The folio.
> > + * @entry: The swap entry to check against.
> > + *
> > + * Swap version of folio_contains()
> > + *
> > + * Context: The caller should have the folio locked to ensure
> > + * nothing will move it out of the swap cache.
> > + * Return: true or false.
> > + */
>
> I appreciate the kerneldoc.
>
> Intuitively, this should be called "..._swap_entry".
>
> But I wonder if "contains" is really the right term to use here. It's
> more like that a swap entry "belongs to" (was assigned to) a folio, right=
?

Right, in the other design doc I use the word "binding" for the
relationship between folio and swap entry. As if it is a binding
contract, your folio data goes and only goes here. There is no owning
relationship. Other folios might want to compete and win over the
binding contract as well (the race in swap in).

> Sure, we store the information in the folio, but the "contains" is a bit
> weird.
>
> folio_matches_swp_entry() maybe?

Yes, I like the name folio_match_swap_entry() you suggested in the
other email as well.

Chris

