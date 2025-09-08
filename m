Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8934CCAC586
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:21:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EB68E0013; Mon,  8 Sep 2025 10:21:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16928E0007; Mon,  8 Sep 2025 10:21:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE068E0013; Mon,  8 Sep 2025 10:21:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BBD548E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:21:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9014056A5A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:21:00 +0000 (UTC)
X-FDA: 83866294680.20.9E0CFF0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id A34DE1A0014
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:20:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P074NXYD;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757341258; a=rsa-sha256;
	cv=none;
	b=cnkq9LHbN89bwCZZpvWBfAXRysakbenPXpqOxvpPaTqZjjnTHxYu7ft+52rg8MYlVyLvNp
	7EItdPbzZ5dvDHgOq1NPOjoqpSR9zqz9zbZV2nweYt0Mo/ljKnEdrq8PkztKqF4tT2K+ab
	2wVNwbq/j062OlN9csBnJRviTsp5guo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=P074NXYD;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757341258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOy2TPlN5JXWLcExWt6lVoT6k+kRkkXUKtWGZoNSAmU=;
	b=CXQu0o5IY2gSUs91PD9sJe57/7i4slJhWbWNzSgU6faURyVd9LOJO+ms8Fc956y4/WP55M
	c0uJOBfWyT00eVh9yKQyb4vDI5oWu5eHnCwE/NupjPk4UvdeG1KV7ZKsMpKb8XzN2DQQ5W
	H2vUsYVL+uYWLJzzwQsNaaH4oiBZXSI=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b00a9989633so840550566b.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757341257; x=1757946057; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WOy2TPlN5JXWLcExWt6lVoT6k+kRkkXUKtWGZoNSAmU=;
        b=P074NXYDGg/hXYPggT0zxQYAgXHjShKN5+dD0nxod+us5kPiUARv377eywPA8/ZdHo
         Mab5CG64g0I3jRyrl8KbaD7AUjt4DNKdN02W+so7PKm95qLPS9UA32P46zLNz/zEijXZ
         Z4nGXjy6Rg5Otqj1hUqD+8zMCiR7rNsrqNXuhbNVh8RoewrS/PTixoX51UVjJyNNgJJ2
         yFpALLhI+csFyJdVutHlVU8vI6roW/QBiVCgv0taDKj3aWVsCNz82HIssCxwJGCmJP+p
         sFGZCoUhhYwCvTkL9WucjuMLjypGFmtvxkbia3R2Dt9DxbT/h6GXWHzx0L1aJk0gXlcZ
         0fPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757341257; x=1757946057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WOy2TPlN5JXWLcExWt6lVoT6k+kRkkXUKtWGZoNSAmU=;
        b=DodjPmmmjJt6U9gNYMp2O5Yy5o526+8ONKbs/UmwnN8x8ViUvzKyRfqgHFbTGP42cO
         hFfKo8AX9ZRWOKMQNYBFGfz2xOsIOrhYYckrPY716GghMCc80g7dILN04jzrKuCaVUma
         K2QXKsgsJN/DudHhJ3G1Rpehz8gffyf4WfoAqIHd3ZeskuRZ8xkFbI9u1S9KTzeCcyYi
         eZerjS1hXpjmuuwZWP0hX8+KY1s3ogajk2DSgofO8QRDeK2QqL+rhAmQRTI6llXb2cJC
         E8Z/QgcJlUbay0uJnexl7jyQe99VEf05NL2oHQ0tRQ2hGxPaBoSho/lccckWNahynDZC
         jOgw==
X-Gm-Message-State: AOJu0Yxx0SKl8z8PyYRaxvFZ9Y6+8nVytZlyjxbsYbVVcNtEJPZ+POj8
	ytP/bfcv8Z8RuMZyPi2GdRIU3yTms8XgiRh1ozwaSWVYUZ1YeTIYTziy6Psku/bHRVLIQBzvwcM
	GibAB+8xKHKGGpLr6lZkkBFCpRVRuxGA=
X-Gm-Gg: ASbGncvU/w5+kvZFS0T/K8xTgb9lmmrPYpaHvAW31MPj7lUQeJxH1Pvwqcjow4+1n6f
	iQ94Oykad4iD4gd+sKm/w979YNuWrAmQ8M7UbaanqNxLxPW4P/ddZEX8Qj2YHU1H6Lty1SFtz39
	n46TgxS3Fx2PWU9e21APk9kI5pExRdcrnriYhArGAiVKC7YcH2itjLy07r3j23nYf5YojQhnM2S
	jrelC1t+aI=
X-Google-Smtp-Source: AGHT+IHGFsX570E/VHGBXZt+zZXEXJgo4U38E2ZbxJaZoVpP66CpF09TmzF+SNrTXecT+dNlCcyFYGvP8VrEBxeK46s=
X-Received: by 2002:a17:907:cd07:b0:b04:3402:391c with SMTP id
 a640c23a62f3a-b0493245ddbmr1259469766b.24.1757341253628; Mon, 08 Sep 2025
 07:20:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-11-ryncsn@gmail.com>
 <c2ff433c-35d4-45e4-bf06-e725726fa515@redhat.com>
In-Reply-To: <c2ff433c-35d4-45e4-bf06-e725726fa515@redhat.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 8 Sep 2025 22:20:17 +0800
X-Gm-Features: AS18NWCLmEE5VtBcECnw9xE7lkKHrNT7pK6YNCKNupmeqEcDIpM6mw3F9Q4YvgQ
Message-ID: <CAMgjq7AsYz+pDTCU5PWoNPN1VJ5Vx8ZLQgF6MT26JUSXr=6__A@mail.gmail.com>
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a helper
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A34DE1A0014
X-Stat-Signature: 933iqnossxttbmbrcz6gomed8ma9kh85
X-Rspam-User: 
X-HE-Tag: 1757341258-250064
X-HE-Meta: U2FsdGVkX19y6+FfgfIDGJHeSpo6Rp67FbLVv+Y+CY6emqoG5ZCzbCbpzcXDVurgrq+LjacE246wSm5L8twIeyS01oP13+daxbROtmerlHG08MdJEEMht704YXfK8hiIBGH4kiptm59kcWDt6CXjwT5UuRb53l3B2Sbrzmfna1n86/OHbbBMdPowKyfjolQLTgghh9m9kOLxbs4XrTZSKy507jzosB1mOwzWCKuhECdztqOc5WyBsFmurHVcGDTTpf5wCNXn/GkEv7BD/eiMUwaMMXnLjcmDai2ivtyAGcrqOQznEcrvtkMkYuk2MTw7osaFs9bEOdKL+AYOqQZGVnQUsivE/Qi0+IeABRGzlV0AGEzRx7r/7iEmyWEe1H61JyzZO9AtM8DllYZprItGf1cKM0roWeCSIDuX2GXJUFMZpGcRpuXTHYqm2t/ghYNf3+nBLe1mt5h6ggdz3R+FW5PI4YkcnQATosi/jgenrZopY5qXt0CwO5av7tL7LjBC1rrk3OOTsGlLfDrcWAlypmqDqw7h+FrcJLMtjBBl5InCa3LxdGP8yl/fTUNmucLRiB4zgtxytebdIorZglchZxpAaKjCIqcKIsI1ZSe9Y4nLdWdxgnezNUPruJqDny7qFevSOGyi9PzEcstGvEbAU6MB78nd51V0QbPUhRZqzQBWLz2uQti8g92JLsIJClEe/5PoBw9t6qi8rJ5AAQODYTxjSZbw/UxnveaLHVUvY7Gh3eyTCn8eD9zHm+OCTqCq/hcbuv1/cjhbrwhxkSkIfO7SiKGYiXrlzhcnbWAJ3yhq71ziVS5d8HtZ8mDoWU5CRK5wM3IjUp/fwyHb4WBC9Fk2tGluibikA4WbJH7DZ9BOnZonHipgLSeJiCzy//nkJpA9FlseOS8EyfciRZmcOt3h3STUZFS7gOlViD8nK472gACrgbA8PkORh+gt0pJAwUHrf1/6V4vbk67DYPH
 2MUh6ZHx
 CB5ZeJLPQg6QQlgz5+MXybwcwKhsCwPEHW9zMhqqfRKGBjKDHdX7yTfq7ORx1kij+ixYuX+tXMJpoyh78ZjTFcLQTTZCy3UOZ2B52r/pcVyyTqrSxuTxKE7tUEmJEQvqigdrYPXA5pyiV07zbppQf62/0LPLK1hkkcCx2zpUwSqu0vjtfFY9XAlLD6y/1E8alSipxkKaiXEyfyWA5VuJzDBbZt8wAnwF9pb83L8JFzNAxerOl7gcPVqj45xwk3DAE9Mfh04w08FGi7FJXB+UB468+iPyjKrXVwSuWJpYQUQ3julF0o8NFmJhvb52X0t71ODS2OG30XtcRtq5xZf0t8jf7bupA5NQbsBoe/oMOkxheuWlujxioYdJ97w3dxm4SV+xI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 8:35=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
>
> >
> > +/**
> > + * __swap_cache_replace_folio - Replace a folio in the swap cache.
> > + * @mapping: Swap mapping address space.
> > + * @entry: The first swap entry that the new folio corresponds to.
> > + * @old: The old folio to be replaced.
> > + * @new: The new folio.
> > + *
> > + * Replace a existing folio in the swap cache with a new folio.
> > + *
> > + * Context: Caller must ensure both folios are locked, and lock the
> > + * swap address_space that holds the entries to be replaced.
> > + */
> > +void __swap_cache_replace_folio(struct address_space *mapping,
> > +                             swp_entry_t entry,
> > +                             struct folio *old, struct folio *new)
>
> Can't we just use "new->swap.val" directly and avoid passing in the
> entry, documenting that new->swap.val must be setup properly in advance?

Thanks for the suggestion.

I was thinking about the opposite. I think maybe it's better that the
caller never sets the new folio's entry value, so folio->swap is always
modified in mm/swap_state.c, and let __swap_cache_replace_folio set
new->swap, to make it easier to track the folio->swap
usage.

This can be done easily for migration and shmem parts, the huge split
code will need a bit more cleanup.

It's a trivial change I think. But letting __swap_cache_replace_folio
setup new's swap and flags may deduplicate some code. So I thought
maybe this can be better cleaned up later. So for now I just add a
debug check here that `entry =3D=3D new->swap`.

And the debug check does imply that we can just drop the entry params
in this patch, there will be no feature change.

> Similarly, can't we obtain "mapping" from new?

This is doable. But this patch is only an intermediate patch, next
commit will let the pass in ci instead. Of course the `ci` can be
retrieved from `entry` directly too, but it's the caller's
responsibility to lock the `ci`, so passing in a locked ci explicitly
might be more intuitive? Also might save a tiny bit of CPU time from
recalculating and load the `ci`.


>
> --
> Cheers
>
> David / dhildenb
>
>

