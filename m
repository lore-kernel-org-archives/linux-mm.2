Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FCF7C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4259C8E000C; Mon, 11 Aug 2025 02:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FCF08E000A; Mon, 11 Aug 2025 02:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC158E000C; Mon, 11 Aug 2025 02:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA9A8E000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:53:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E7C5C061C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:53:05 +0000 (UTC)
X-FDA: 83763559530.27.ECEE0AE
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id BA6214000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:53:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtGwCEY8;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754895183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/fVsUY08ipVRtRLpv10uWhZA7wsDSRqCmbwogA870dE=;
	b=emjX35jVI8d/bNgp72Uohd7HWbHD0dWH1qzYKdlT1CO0SM4ISaATlDA/O+PqOHcrkXdC5a
	0EQr15RMBu7NFc/73XzCp55WpRLei2KC7c7gctnmYXadClP+QOuGJ1+IEMHvLvMhZwLOnx
	whKxIVqaFzum3ywQEXnJ6cYs4OtLYMo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754895183; a=rsa-sha256;
	cv=none;
	b=cSQeTbG7we98E/ZFFpH5VZnwMskoYfg6VkIa36D3md3jEQ0/pYZVpQXClmIeP2V00DQUX5
	dSH39gxgnpyS/4hXLPYXbEvaevSYCUbG/oMZvpszKUFO6hl+GRHHLV06+6Xjs6CIXMEaKJ
	FcDJhLoGRzjKD1pwu97FjZ7o4xs017s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CtGwCEY8;
	spf=pass (imf07.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-5396c1d72dbso3182764e0c.2
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754895183; x=1755499983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/fVsUY08ipVRtRLpv10uWhZA7wsDSRqCmbwogA870dE=;
        b=CtGwCEY8b3n9dUnZYQMHBRUEwD7vxju0tyAGpqxa1aGzfddvoFNmd/0pdWjfRK3osE
         SMju6yvzaMntW/rrLwjg5Bpddd3jOcLRgUgOZiQWcckmxwVoB9nXXoHur17owrBJHrZT
         HoGR8uBlWAi3nleebwxQ09wcmhxfxqZ8x/GEMSDF1oAh0Ghs0VQpIKtuIR5vXOVfLeD9
         JFJEQqMoc7qdUY4GTwrkmcn47/LWv7hROFxUFV89zDQzJxF3O5/7xjmHaCIYvHo/EWEl
         xgN/dqQ9c85dknrHKUvIgtwQb3cvw+6Dw7PuSyU0dfA8vjho1bnehMrsbp2eDVp+jxgs
         KXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754895183; x=1755499983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/fVsUY08ipVRtRLpv10uWhZA7wsDSRqCmbwogA870dE=;
        b=uhpCu6XbJG5S7P/Qtko0lP3qWO6qySEq5Zq+6wzSg2tkWrh77eRfvODVbCoGJRMA7A
         NyLZR+6psNKBnBXu5YUlqLhGD+9fXhdulYoxi4156w5tF8c/an/OvpLuSIIJxB5taIkS
         4E/J8V048PJf+ixGArGBvnbIKXsAsuPKToLmonW/Aob7af1Cx06Ti6i/X/xQhLpI023W
         DOP92u6GTcErDZ7z77AyGNH3SVZQnCVtK2pHcQQ3yJoAuS/0dur+/cbutT0q10vnCOh+
         VALvwvib82uyyPwOm0ZukkuRa4At6R+wxH2GGrT9ARXa7BvZHUhP+lF2Zbu/9dMzi0QU
         1P2w==
X-Forwarded-Encrypted: i=1; AJvYcCViBuLwA9dtb92wM1i9ximSX5W6/rYHUJw4QjSjA47JuhRTu8dxEnVswJDvxr8IAw+OnK1CMAu6Aw==@kvack.org
X-Gm-Message-State: AOJu0YzPEzm7IbumdTH25Z8MhQ7yUQKWhOaquffezLrX5DcyPBbN3v7/
	DvoAITQBH68WIW1Soiox+qWcIMb6hBpQZK6LqukpqISuAj43N1pB8dUHUnwz5OhE9DAOgdRz+Km
	cdh4NuUdvDiYR7xWSXtdTwl/wkWOf5+s=
X-Gm-Gg: ASbGnctDpmK53KsarrLoBaCjHTy73Mazlh6pFv/6WrMc0SeCdozA2uZOXlC4EeGdre8
	4wkErusZHbA58GZ4sm5eSka/X1Wl5oVx4cyqQ7TffYKKPQcvft2SgUa56xhL29LUM7aKbo+IaCs
	8cAVNbvTVrBlhWlM68HPuAI8iqDCW4vs9YZz1x8fRzOPje87LfLy25o1Bc3FbqRtNELvCmWhPU9
	Cq2iso=
X-Google-Smtp-Source: AGHT+IGGDVcXKzHiETBGgnAZpGCC0gWUGYjDWg/fG11MB7bORpn/RJDutDW1kYazG5raVFO+qTH8hQX/k+xxbhGLSxg=
X-Received: by 2002:a05:6102:c91:b0:4ec:c548:ee2a with SMTP id
 ada2fe7eead31-5060f8b41b7mr4400160137.17.1754895182668; Sun, 10 Aug 2025
 23:53:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250807185819.199865-1-lorenzo.stoakes@oracle.com>
 <CAGsJ_4zuEcgg7U0yCMu6ayKqRPACtvuzUsC9vUxBk2PgMzaf_Q@mail.gmail.com> <47ce3db2-38ad-4a6b-917a-c6300fc39543@lucifer.local>
In-Reply-To: <47ce3db2-38ad-4a6b-917a-c6300fc39543@lucifer.local>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 11 Aug 2025 14:52:51 +0800
X-Gm-Features: Ac12FXzg7m8LhV-73jU_CYSdeBumfCC_Ufk6bjZHFOVKRLYHVyElDAX-Y3qBP2Q
Message-ID: <CAGsJ_4w_c3AY1Nw7EhYH3rf0jjqgZ6AYLdr3xuonF9SNgWckDg@mail.gmail.com>
Subject: Re: [PATCH HOTFIX 6.17] mm/mremap: avoid expensive folio lookup on
 mremap folio pte batch
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BA6214000A
X-Stat-Signature: 6mbusgmirun6kohsa4o4ti1tcu17w77p
X-Rspam-User: 
X-HE-Tag: 1754895183-937356
X-HE-Meta: U2FsdGVkX19iWSGJLERgq9neJHGHER0jp88nBfZcOl7sIvKqwkUnmUXUsNW5kB/xl6XZ9R308j47zsDjkF3eXkJCyRcMfiWTMkxsrgXX4MzuL4+kRoAOtLJXgFE2SQQuv0t8NCHUBP72QXST552ra8xpCzhOqGzMTUT+8tqd+aez/S6FlQX50Y9rbfhZ9+xzC5Z1+jtKl61qNvKeiNWqgEzvG9NJ5tuyz8fHRF21BX3iCYyKJLv9nOUGEGQCJGDcvdD1YMieR5sKH+413HxbnZlMc9DSmLzNPPFtcDAXuefLZE0TuLfCpuohqidFqrLhni7P8X37gcvNqjVIuL/+6k+i1RHGGjj9TzjUHsMuonzGGFWS1WbFkkVDQON01aGs4HfziHr7MfL7ICOXJ7+vlBplrNVIZOuIOPEc6viD5R7BtMnbCX9GQ2BXac3HwqNyTWi/MmBWsX0sqXh03llM8gNBWKmBSTPe5R97lRjCRpK/x842+A3TGfonIolKUvJqnKlNjgml8IRZwU6dJtG9TiPYNmO9jIYG0AUzJC8gAiXaABgRLPMIg2FiDqeJ46XpP6JZCgdnSzhnWYjGQ6ao716tiHHL6bzb6RFYwMtJVqD/8fOEHWIUtikj6eOjkERP6c9pbbp2MegAL49VPy840/fVt6GmtDOryE9KNWcbIb9g8GWAKWO655SgxbtPlafTeRnc1r+pDp8c/yfV5MKROCWrTF7dcieEbY7zIig+0UrApQTT9XMjX3g4Hn3hE9HU/gIC/SOlNsv+HydsJDn3DKAsLu/eFBCClBss9l1la8v2Tj3e1S4jl/gS1Qfj/UGQLVkrPDB4UgkJi/B61QM2y8O5nylDj9P9bJCRz7yMe9EVVrDem//bS35ZZ3cnYivC4KMo7huMAZqOmGQAeewL9GbvNhznF9NVL6PZ+ZFIcOVLbttk5ABiIY3l3I8bV+Xf1LrVBTSuZ1HHLdL5lzJ
 s/Gbo/MN
 yaNRw2KgUbzVkgOrDYePTRC5dBsbnh0tLcIy9rhpkbDCvoBKmzobUKDjWXYl/REWUPFVv9GcAT3kWeEevWA3PtZFZ8kL2lK2KhJdGNuHrvqGW034U8FfURcVds9MlhJZfpp0kQiejA+uBO969HrUJp1YENqCQ6F0PEvM6I5up3QCP1HJmEjakVSsK3NeT4KqXzB7J4Vb7zqMkbuAATSWK7LV3JCvRNGHaBF9Khm0GvGWIf1vPsvx5aPFzM1eVUtb9MkKFUcY0Z+mlTueUP0PJOjk8Ihq9uI8V8VWDMRZC8YMZz+TfLxZCOfMrDocVy97dbR6CQdWcI1mFIO76kht6ZWmLYwKv3TdiN4guzyw2cUjOAXnR+6ef/fhfHs1KfBNIgUAl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:57=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Aug 11, 2025 at 10:40:50AM +0800, Barry Song wrote:
> > On Fri, Aug 8, 2025 at 2:59=E2=80=AFAM Lorenzo Stoakes
> > > The expectation by those discussing this from the start was that
> > > vm_normal_folio() (invoked by mremap_folio_pte_batch()) would likely =
be the
> > > culprit due to having to retrieve memory from the vmemmap (which mrem=
ap()
> > > page table moves does not otherwise do, meaning this is inevitably co=
ld
> > > memory).
> >
> > If vm_normal_folio() is so expensive, does that mean it negates the
> > benefits that commit f822a9a81a31 (=E2=80=9Cmm: optimize mremap() by PT=
E
> > batching=E2=80=9D) was originally intended to achieve through PTE batch=
ing?
>
> Not for arm64 apparently. And the hint check introduces here should avoid
> regressions even there when small folios are in place.

I still don=E2=80=99t understand why this is fine on arm64. We do have fast=
er
folio_pte_batch(), get_and_clear_ptes(), and set_ptes() with contpte, but
are those benefits really enough to outweigh the disadvantage of
vm_normal_folio(), given those PTEs are likely in the same cacheline?

Unless the previous contpte_try_unfold() was very costly and removing it yi=
elded
a significant improvement, it=E2=80=99s difficult to see how the benefits w=
ould outweigh
the drawbacks of vm_normal_folio(). Does this imply that there was already =
a
regression in mremap() caused by contpte_try_unfold() before?
And that Dev=E2=80=99s patch is essentially a fix for this regression on ar=
m64?

Sorry, maybe I=E2=80=99m talking too much, but I=E2=80=99m curious about th=
e whole story:-)

>
> In similar series to these in other areas, it appears we need the folio
> anyway so there is no additional overhead to deal with, in mremap() you'd
> otherwise just be looking at page tables which makes so this egregious
> here.
>

Thanks
Barry

