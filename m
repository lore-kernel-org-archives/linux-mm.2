Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26AC2CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 13:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835F08E0006; Sat,  6 Sep 2025 09:32:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D8D8E0002; Sat,  6 Sep 2025 09:32:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 723B68E0006; Sat,  6 Sep 2025 09:32:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C5B38E0002
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 09:32:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 114328678B
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:32:08 +0000 (UTC)
X-FDA: 83858913936.30.A4F0B7F
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 315B0140015
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 13:32:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+8RlDeu;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757165526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qOjr16z3iFFG0GZCJDInNOhhVNmobQ6kWnPwwzJcCqk=;
	b=XxDjiiXZH3LQEQ4yV2LP0NJSZwmcIhWDqyQMPnpQdEuP5uzp+S7xlQDceEfRJN5bDsozKV
	YrgmIwAvMV2riMOXRY79V0aqoyWe+VfiJQaq8IXrHk/Rs6+O7adolLLOrE1/I5mW1d0TqL
	T8upbj5C+3ied1bUvCTeRladX2swrrI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=S+8RlDeu;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757165526; a=rsa-sha256;
	cv=none;
	b=0WfkJ9ow3o17u9TBblKCmQl97/Lj2KBHrMvIZf+53X5b5HXOqtiw2ypg68iTDm05Ziq9v0
	wE8AV2S+41gcvYDveomvH9QaKwurYDs1bqoQuQq/AspGHpko87yOWIL2FNByvoJrZDYLU5
	Y0rHfog2Z8A5KaOOy/w8JAj9Bfe9z7k=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6188b6f501cso4009557a12.2
        for <linux-mm@kvack.org>; Sat, 06 Sep 2025 06:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757165524; x=1757770324; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOjr16z3iFFG0GZCJDInNOhhVNmobQ6kWnPwwzJcCqk=;
        b=S+8RlDeuUsF1lhWYSX6c6zOn5BdquDkIn21fx5hNs6nGIV7Gpp6IL8BsGIPilHMYKJ
         yJJszMVhG54akcTtDyD0891lErhnzK+TwxeyaA7ClwgLnHHI3+vhVvTcv8BMJWzlQ3fr
         x6F2/Ips8tQcVZlfs37WfgzXm+/PK7vO7VrGzvsoXxpQ1wrBE2EjQov8w7PwILnF5LUD
         4F4iKO4GbBWRidX17vgZvroIe8dSGB7IPLnAKTzaZ405dlHvGQsGXolUTvuIByQS2qtG
         yCRfRYJxFR4rhgP+4/K91bhum9XT2L0xzTzZhCzG9W7YkSHAvaTxB8albfFf4RAUs4/i
         aOGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757165524; x=1757770324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOjr16z3iFFG0GZCJDInNOhhVNmobQ6kWnPwwzJcCqk=;
        b=FxJgKdXo3IeDaiRJWIOXnH/7uEUOahbZ0AmRnsRa/PeA/8LdJc/41a1DOylcAQyBX5
         sBvKP6zQLw1tFlTzgKJq5D9kh0QPDNETsTJbR5LTJs4viQTpQSWUmdU/3zCaQf4QZle3
         HDrRZzgDTCjQzCsSQ9JrBlETe+GEWNC0U7TIRR8/17wpYMySk9n/YUTLBBYX7iyHPDP+
         V3HKcGnmSXrxZcm57EGHOl+Nd59COT0i+cMGjnseGoaOVHh/tlB0Ipold7tGVBeJxCaE
         l6q8kDqZrJdZzg4ZRQX1qn7f4V+pL6tIQ6x6n1uaZ9QltuiOeaWhPQpwnDyplCknxNco
         e1bA==
X-Gm-Message-State: AOJu0YwTKgBeNUd0KSW5xQePChHrkguBlDSc6v1Y+pIYfI/dX1qWPuir
	xuCuF2vbvJgOxN1+66KUDPCCt1lo8ZeGRXhO6wodzLP9DdErjKC+NBy7o7uqortVFUa5nM29tMW
	pOoDN3U4a/3u/lOmRMXVOpwbtuQdu/O0=
X-Gm-Gg: ASbGncuX4NDdUW+vdRcs2G0H1tLAh+cfHVYbjmNzvlXLvauNh973Y6Rp8oaqTGRUNel
	B+XQjXlCRV6om7u066SzMNS40ICmHAmMlkyuNjrTs9Gra1bCm+lRWkRwELn7JFh6rf5NyJ4tq/i
	JFkBQyi4TyNtkqWpkRoUUVHc/v7JU7YcPEwnlSr4UxLypSAjFevubrUTgoLixROlO4H56aXD1Ys
	4lGWe5/WgM=
X-Google-Smtp-Source: AGHT+IHG6G4gWpwGqJxGHLfIICndYKim+2bE+CSRWqJCCNL3LoUe3y6m0/pSNCmqqsFFeG1iBJd4Ef2O5yds5STYhhQ=
X-Received: by 2002:a05:6402:348d:b0:625:aaae:c199 with SMTP id
 4fb4d7f45d1cf-625aaaec3a8mr1264054a12.1.1757165524254; Sat, 06 Sep 2025
 06:32:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250905191357.78298-1-ryncsn@gmail.com> <20250905191357.78298-2-ryncsn@gmail.com>
 <CAF8kJuMsGGtOuPpDwFKq0sNhX7HKbQWWK31uWpqeqW-RGTo-0A@mail.gmail.com>
In-Reply-To: <CAF8kJuMsGGtOuPpDwFKq0sNhX7HKbQWWK31uWpqeqW-RGTo-0A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 6 Sep 2025 21:31:27 +0800
X-Gm-Features: AS18NWDELQkUGhXFIMgs5YM77ANpVCaP_i9mrVBu93dI7V9Pvwt8b0jXtcdeeYk
Message-ID: <CAMgjq7CtEwBMVz67nA7wL6PryZuTmaOut4yPhUyhQV0xkuc=1Q@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 315B0140015
X-Stat-Signature: b1mw5fgeguqz11fcqjpfwto1psoun4oq
X-Rspam-User: 
X-HE-Tag: 1757165525-897530
X-HE-Meta: U2FsdGVkX1//WFy+rLKFKk2EnARHoOUcM/jBi/fCpAgwmn/4rAd6DsBFvw8ay6Cmp2E+rFNBB9XdoO/TW4Jo9MWrfW0Kvd4DzERTQUeFdY2JlYaHnA+J9MnZvUub+gvp21urc38r1fIi7keocbaTWs0Itj0ayKozhDEgjmpjw4yS5TM5EcoWhVDr0RFK8Xc1zwqiZhr3pE0ytvuUeEbPzWs7I7mR0gEPskWDQ5fdNd39EVUCCxpP3UfVZfg9xL7CQ8iyN8K83AdzjAsDoIEYHd4s6s0gNhjM066f6UxwR6Gvs+pjQf9ESMTuPdHsfj4/efWMci6EvWucfQHPe8gRUztIy8Cg1zbSYh43CXnp03B7bitNHf12clpgFFR65LED1ERN6gAOUtw8kELCmXokZBYiknU8KBf1rEbNphq8yQChHagpSYLhE0QcvS9fMfsaN1Fvce0SBlj5LfFhzyUXWo1Ri6eZYkoVZel7t4uG7iH+/ZwwfbWKssaR/0qznG37CNTAk49nY/NaFycEWN3gP/UcmyOoJfMvB+Q0OFL0E892nzxZr4LFrc/iK5nhA4CBl9KhfiiNC51s/QbyLVBrGMzj4KlKj+If0l6qTnKpfntT9zrguW3fjD9fe4Z20lW4GxRDf5qNveOyQwrtQkPFx042maRdzySE8uvIGC/B4AEmrZnIAsjdDTNJqXgFfDK0VAVcbikeXue67DsWtubRpYuBNELn4WVHQh1PfVIDb/hBA0F/4EaIyjdgOd3xHhWM9jCXinWiyw/wsg7AVSukLawXDDGUeN1+W/vUiFiYVNswFDI3R1NsTQbSjXjoFDcNHcIr6M0pxOpMaaM8NxgNTwDtCmnANEXqTKWVrlVcB8YHgTgyzS5PYRsLKbdZEMYnFSgQGBDgnlxaypVFJU8fLURxLfM9z2pBluoBOE2rCs4/EqCw6OwpA0FHznfgyn6X/i4qYdm7af/rFo7WzvZ
 i/wDeUxb
 xOoZeLIPwATWKAM8VfnhmsMyaESl9U8STg9KIJmIyhkRY76CORr7cS+H6OvyZFOJhQbHHDTg8rQVxiPN2D0qeox+OpnTaRrmib+zsnocxaZDymSx/VT4ekhvajMjH5u/nPwviA3piZmIq48xKBZeJzW2hjNRFMTMR8UewqFaYIBJz2oROCGKDOCAWB7Gp07s61re2PExufvFo/fy98lwGl7BzbfyXJCiRG8NL4vahWzNxxCDP0+FBomB3D9nZQd3ZlI3PGVkJOa2fFnBt8vXLi2IH+tNNyOYUvhVh95Qa3N5y9kiw0QuxifqqwzufrKznlFhFVF3Nixp57uMyWNq9CGpqZEpRQErWF8ZKiO2r96p7rguq4hjUjr4s5V4XLkcnZip1Rj3rpF1w9ZOp8T1T3FRr1fzlkXR1y2Zq8bGksm6Q0Kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 6, 2025 at 8:05=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Sep 5, 2025 at 12:14=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > From: Chris Li <chrisl@kernel.org>
> >
> > Swap table is the new swap cache.
> >
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
> >  MAINTAINERS                     |  1 +
> >  2 files changed, 73 insertions(+)
> >  create mode 100644 Documentation/mm/swap-table.rst
> >
> > diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-ta=
ble.rst
> > new file mode 100644
> > index 000000000000..929cd91aa984
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
> > +
> > +3. shadow: The shadow contains the working set information of the swap
>
> I just noticed a typo here, should be "swapped out page"
>
> > +   outed folio. This is the normal state for a swap outed page.
>
> Same here. "swap outed page" -> "swapped out page"

Thanks, I used some grammar check tools and it seems they are not
perfect with kernel terminologies.

>
> Chris
>

