Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17CFECAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 16:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766248E005F; Wed, 17 Sep 2025 12:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 717068E0002; Wed, 17 Sep 2025 12:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654998E005F; Wed, 17 Sep 2025 12:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 520038E0002
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:49:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 00E6BBA505
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:49:02 +0000 (UTC)
X-FDA: 83899326924.02.B3F1253
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id ED3A918000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:49:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OjwqC0BK;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758127741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUPC1zdWN5kKx+k6dBvxwjTFs2977h19xDLTjdHgTTw=;
	b=WG0HFDEe46ASOml0KwvdXGN1rhMexGidAjOpx9RSLababwcTQkSJahO4X7RFQftLYKEXBc
	5iHYoMxXX3xUhc27MIbGSxXlHn3esGhyOI4ttISshRjV5+xrmtAYw34wR7dMo/MnBIqICA
	DiyyR9dliuQRSPsKjnI9h9+qJIvx2As=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758127741; a=rsa-sha256;
	cv=none;
	b=4JrEizxqavkYLEiG5Y9BltfeQm4Jxsm+K2MhkN/OlbXMubFZT2iUi5+xlMZdVPaXX05uiD
	nXY6/v+yCHQ32TQAjPUOloTNwWH6xsgYfIO4EEKBgqs4Amf4N42c43KjMqxrxI1uwu62u+
	Unoq/7rVncHTBQa0wa21MS8r/tZHTe8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OjwqC0BK;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AACAA45056
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9094CC113D0
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758127739;
	bh=yUPC1zdWN5kKx+k6dBvxwjTFs2977h19xDLTjdHgTTw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OjwqC0BK5syFJ4ucBTiiaVfcojW8yy4lWxQUj0EGvgLResgn5JCf6ls1LuwvzPhY6
	 Nxfxshvnn0chhXgjaGus7TyRITxO9UUnSa5fE/e3MQnEO4fyiioga+673diyYidIwR
	 VLpJ6m1aJ0LKl3IVzbcoNhZ04l5ieFGqC3tVHkZcKaetueQrpK6yZBTiBgd4shU1wd
	 sKzkv291oAbLsZgP1r80MzbcGz5vvZfVJGWq4+eMkvMdJ4EOAeU3F6p2xcS1QVI0o8
	 ixN96A8J+gaaRlkIRBauPV0qGNSwOVpJeD1TkfHvl7rtdht7JcGXE3J/RlRDKWVYQ8
	 NJd6jVM4KjBMw==
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-71d603b674aso542997b3.1
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:48:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWXsFYcu78aydovhVM9ZWKV/TodD+I8HMXffIP+r6Gken2mhXMl7yX/mOkOLwnKt9VD+gWSBzTIjA==@kvack.org
X-Gm-Message-State: AOJu0YyB7vaiuuesCJ2KhhjsUh03fkXeTXDiTwNteOy0hiaqJyqkGd01
	Y08U1MTw/c1Cju9tK46VhqjfGn1sVEAZQLug9z1rEJYqrVX+klFDekyew2haOzesSHWXANLwMQW
	VPlHpudd+foPoOwDkGEOc8kiehER3ORo5mQeeiy4B+Q==
X-Google-Smtp-Source: AGHT+IF0pKHAAeegJZZWoeLW97bU+nM2aZay5XgoAAF9236iZFlM4qN22XQNvUtyEBR/AyicnuDETAMdJbBTFlco/OA=
X-Received: by 2002:a05:690c:4b07:b0:724:bcb8:7d57 with SMTP id
 00721157ae682-73893141fe3mr22032967b3.54.1758127738739; Wed, 17 Sep 2025
 09:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com> <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
In-Reply-To: <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 17 Sep 2025 09:48:46 -0700
X-Gmail-Original-Message-ID: <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
X-Gm-Features: AS18NWAcw0qwgnqmnCF1ULPrhYr_hOxdDMPg7RIERdgeixYVmG8XAhG_ABvnJZU
Message-ID: <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
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
X-Rspamd-Queue-Id: ED3A918000C
X-Stat-Signature: w7jyqowwupfmas359pgud6ts4fbkor5b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758127740-520013
X-HE-Meta: U2FsdGVkX1+PWeAeVXJt4TlKB3DGRNPJ3QR2+2DDc5BYcz5Q9euH91rlpIEfwBPg1MI3gKl2OzN1/LhH9NpZJ1U4Is/n6X2QJqlayIzHhVoNB7+0KeaZqmymxup5LIYwm1gW7qKlKlALmCkzgwCq0TymbiZHJ4j+E8+RpEZ+NWW+nk/U9e6fVXlEPVIZb/e1+xNfGiSSSN1a33LdZ6QR35NMOLoQi2iGSBL3+1b67p3hNScD8A4aggnVw2wi8UzWZicchoQ+aJzVA/YSS1oFDbjIiJil0S6WgXQx4tfBTzadAFW3onPBzA6B+iRrUF0zaCUOnRnB8mTa3DNIDuT4sn4AKXhL8k96aFCafqCINZ1FxDMX7TruYtHlNqBtjIVM5y6PDAsoIb4UxH6XIzx3kFePJ7BKZh+0MUnAL0gMpMlIvJnsgYk+y99f8p79UiI8YQw21S9Zqe+gL/q8ZgPwROE+ufsKbhFXKVv/MoE4Nhu7e/+r7nJLXJwWZe/uu9RdYqXDgf1Kw6o+iTmKtTVAIgNSn9QZc+dTqiB0WGYaH0xdLAaKAYKBpGQBQpUMuWct1HzUKZaHvqg5qXMLyM7dg/BRSIBJmjTCcYsIUdi6coVy8azEYH12eyuHfMw8akMHDHe6uBT9tkHw/sc0GCBukOVx0Ng+g3JJ/y5nYAHWeIpgtj6LNQ9ZuD4KySLF1flqyRtqabGgW02y8RVjJe2iLqTdoE5pBgoimTG0IK460Eq2cmnh4CscU2IcMNYxHTU96EhD2goSqho3iNiidR86nOUAXF0nAvO88SUbVX04ZIJE+aabLj/Ggc08d6LbiZGPRuSZvr8hIvcm/mgjBJEvlEZJ9mepBZgQOxSUZtd/QUhPwbJj5QcZMeXg9tFsN/h20P7+Pe4ICAAmyeFrtrgJN3BgP5zmPOc88egVuZ6sTgcsd8lWnlKVdpMhzflR1FfBfJn4FjWT1vML0eNHKW2
 vFZ7BQLs
 bdlFxUDFN3A7j69LGNIutIJjedVvfnXUuf9RW+pK4o+X9KDO8lC4vpUVHI4eJJwk/NO5wGHyKh3OE+EY1VQC4s39qsrhU2wh+xoKyv2x8zDfU7DsJ8Z1iKTLc+mawEI+fuTRtNapBqUUtID6G0yYSLfb0fvho5XxJ72Wr08JPayz/EFKle7ZHTAnW0PTYwvQgi84lWx0XqmkWMTX6naPmuiKi+Wb2j44qC+NYQCBoChU5th8ovvX/mUAvnhI+TiN0sarSLIzv+GlQkRXNupwmcHPwg8vprZF5GgHvDEIpEq29AolchH2QlnyqQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 4:48=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
> > In your above two examples, what is the respected swap cluster swap ent=
ry size?
> > In other words, how much entry does one swap cluster hold?
> >
> > Sorry I am not very familiar with the ARM page tables.
>
> Oh, my mistake=E2=80=94I recalculated:
>
> For a 16 KB page size, SWAPCLUSTER_SIZE will be 2^11 =3D 2048, so the swa=
p
> table is 2048 * 8 =3D 16 KB.

So my original description is correct in the sense that, the 16KB page
size, swap table is 16KB, this is not coincidental.

> For a 64 KB page size, SWAPCLUSTER_SIZE will be 2^13 =3D 8192, so the swa=
p
> table is 8192 * 8 =3D 64 KB.

Same here. For 64 KB page size, the swap table is 64KB as you just told me.
I am just trying to give a bit of a glimpse of where I get the
intuition for swap tables.

>
> This approach still seems to work, so the 32-bit system appears to be
> the only exception. However, I=E2=80=99m not entirely sure that your desc=
ription
> of =E2=80=9Cthe second last level=E2=80=9D is correct. I believe it refer=
s to the PTE,
> which corresponds to the last level, not the second-to-last.
> In other words, how do you define the second-to-last level page table?

The second-to-last level page table page holds the PMD. The last level
page table holds PTE.
Cluster size is HPAGE_PMD_NR =3D 1<<HPAGE_PMD_ORDER
I was thinking of a PMD entry but the actual page table page it points
to is the last level.
That is a good catch. Let me see how to fix it.

What I am trying to say is that, swap table size should match to the
PTE page table page size which determines the cluster size. An
alternative to understanding the swap table is that swap table is a
shadow PTE page table containing the shadow PTE matching to the page
that gets swapped out to the swapfile. It is arranged in the swapfile
swap offset order. The intuition is simple once you find the right
angle to view it. However it might be a mouthful to explain.

I am fine with removing it, on the other hand it removes the only bit
of secret sauce which I try to give the reader a glimpse of my
intuition of the swap table.

Thanks for catching that.

Chris

