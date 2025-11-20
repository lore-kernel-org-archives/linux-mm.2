Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 311CECF64A4
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 02:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7605A6B0007; Wed, 19 Nov 2025 21:08:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 710416B0092; Wed, 19 Nov 2025 21:08:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF316B0095; Wed, 19 Nov 2025 21:08:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49E006B0007
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 21:08:44 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0D52E140719
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:08:44 +0000 (UTC)
X-FDA: 84129351768.06.F6686B7
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2157480003
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 02:08:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z6QrqUdS;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763604522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=on03UBhh5CPDB9Oib8iavMmiw4+jLQMJAoENTdtTq7o=;
	b=jpZeiqsGAkKgxTZ7hLY74+kreuVG0RBIQ5Wmch3B/0ZBPJSr1s+muIKLNEzgN8vVzjD4eg
	bYsTlLY7oLmaJNHGggqXca92gLniZiCnlOnSBrBHTYcwuGI3reXo3B3aThdKFSeXvxHe/8
	ge9IppVzYkUjUTlJwryhpr80+YSRWA0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763604522; a=rsa-sha256;
	cv=none;
	b=X2unS6bOOZnpT4baiiA3uHuQYu2YvZlY8mHa+BQlWLwetR0Sk4Gb6zqFyJHMBmEaa8L9J4
	UIUk+DhsW/brw/4hViYUAQ3zqkPKZo39offAzD/l1iaAEktJNNXwYDjudQkN4+4x5AMK4u
	xo2syi5lf4+3NW4QA+NHIKWa642D5w4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z6QrqUdS;
	spf=pass (imf02.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6418b55f86dso565005a12.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763604520; x=1764209320; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=on03UBhh5CPDB9Oib8iavMmiw4+jLQMJAoENTdtTq7o=;
        b=Z6QrqUdS8Oq+d5nZZs5mm+5lXJdSm0ZNQqT1RYnp2dTa9YI/3tkqbwAwgapnH2TVvW
         AjvYHLAOPfYol6Axlh6prmE9ENaQZF2LMIsq9bxAJoZv0HtLXGqMTpo2VX7VpXQYTraI
         3qOqaMpWrUjJsuhreOJOVyRA53af7nkA0DO9sDYuSynWYQ191TitFnDmD4mlZAQsbfmg
         zrpIJKQeEFwXORY0YJPPbicUoZy9VPr2blYndzsLnTB6liuxVUZmrJa03FoDMBjCH2l5
         Je6OgW4cTHHHpNp0eP/v6YgMuogR4S2Q9FnTZlhQ2m2tByhx6BGdI4h61XxscXmgzC2W
         IkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763604520; x=1764209320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=on03UBhh5CPDB9Oib8iavMmiw4+jLQMJAoENTdtTq7o=;
        b=H5Tc+K6hMBua39adSKyNcPdmUyLUVNK37INVYBZKS6xOtNE1vt4hEUzgjwsKY9Th5a
         fgQj9z1Vg1R5lcIdpY2My0zGzAd4kjivMMoUneucyDwhcPwqYNZU769VDzx6lNCGgItb
         AP6FB1iDpsaaV+AlTlzNnnPn2TWmsYfziDgH5tT35kWh/H4nTRAX5yGV2LrVAQbs2REG
         jJeLg4xU4YOXbSbrGR0R3SMZ3fDsjY0qhaLmnH0J9q4OksxYOZtJW+lPpYkprDGwCwEV
         TDeU45254P3FJQYw68PPveJii6Vli/T3AkmyxudEIJ8Y8dwUOAsxA46z0iimcihNrMWL
         /SpA==
X-Forwarded-Encrypted: i=1; AJvYcCUYKm2tb2hqm1OOChJviyTDqGJlwYKOS8Avw3q1JwSTd+S82NtLUNHZP+zWkcK+kowUHkRLbnacVg==@kvack.org
X-Gm-Message-State: AOJu0YwuABlqmbAhw7i1bDJEz902OO+2F/CkxLrruWnijFTkOJ4jdGUL
	CEiN1Du4Nrnqy4XnQ9FvO+yqQaMHgpu+Jh32zjWC1zLYJ48pmJVxVvO62hpoIGEaQlC4wunSx67
	QPccz2AfoeyAwtIb2/0h5mUlqvhxexz8=
X-Gm-Gg: ASbGnctGaGsCi+uPPtpPxGaPF8U2IkRVxzaC2klLpiHPg9gKq0z2Fiir4mHU6/4Pb/I
	PN558xhdfyIGrEFxhrbBTik0/GEg4LJjiqbhvCkAyioC4IdlD5VA45IuHogESaKu36lQ/EDMNc4
	1mKb566/O0zgl22Bcf1zjzpztil5Syc0ERMNQF43j3HzWBUSaSDGTda7YW0LauTrVE3IjykXgRK
	GV1PY4raY/8VBSLhwMVRlnKtsMoZ+ZLUppBMKE6jK4PR4mxCYpG4f4phRpSFSaL432xjvjTHR/B
	QDllJoqNotjmTZEqq4tAjddUsVKtA8o=
X-Google-Smtp-Source: AGHT+IFHrqYjQBWZ77Bm4LG+mhtr5ES85yUdZVUUB/mXZdZrKTh2mF8Z7lSbQxCcvV8OAd1Q+Qz5iASOeU0hcN6GiNE=
X-Received: by 2002:a17:907:968f:b0:b73:9280:2e7 with SMTP id
 a640c23a62f3a-b76553ef521mr105482266b.34.1763604520217; Wed, 19 Nov 2025
 18:08:40 -0800 (PST)
MIME-Version: 1.0
References: <20251119114136.594108-1-youngjun.park@lge.com>
 <CAMgjq7CgwjqE9XVy6EaNe0XARYOJsOER-Ch16wuZxWfq4EdFJw@mail.gmail.com> <aR3yXh2/DhYaN8h7@yjaykim-PowerEdge-T330>
In-Reply-To: <aR3yXh2/DhYaN8h7@yjaykim-PowerEdge-T330>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Nov 2025 10:08:03 +0800
X-Gm-Features: AWmQ_bnvW3U0MgyR2sv92vdsfV04s8VUxbwR2G138YB7mGc2aB1S4DmQtSFDze0
Message-ID: <CAMgjq7Am5bm3Q2_SpbK6_6xYszSDHO2fgFhOKiBjg9K1RGZcrw@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix wrong plist empty check in swap_alloc_slow()
To: YoungJun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2157480003
X-Stat-Signature: dgjhx7u96ac9xnxwou866fbubf89oku8
X-Rspam-User: 
X-HE-Tag: 1763604521-302914
X-HE-Meta: U2FsdGVkX19MT63M+I2GnHqyvyrpaDqRkwep/h+0t5ws7mYCqueMYGMxBk0+Xb8AvcJyiANQCtpnoh2Z9q4YLV3jKw8CLg+q2hcS+ErtJGwJ0awFVyn2ZqSwxQG971P7p0Hkum+8Q9ZH/kUu5TfzBGSvB1S41G4atzqBHfSBt1OzMc+tfQ71Sgzfoij69ayIdNGKNbdudEYxnTlId7sPxpL2NYL4y5S2eZJ40EP2AlIA9W+Z7qkBOga1mKEUr6GK55bGAXQj+gRxNXvBvpQrT+X6Ti3/dlRuOqTzERwE7kGOOnMHMctKFmlwWzZCmi61Z1B6lWkWyGCVkFu0Yh/7yGcuPqmOLlB85OKv03Vs8vNiIdjQV/hCgS6l+51//mjcKsnSpwzNoF+DQsslI3kyVgjbEcjiWfzL4t2CUBueEnYveyFyQnK799aMR22yJgGaZj/tEIpMU3faSuZqg5Y3ZCjAC2OF6+lIVHWQMeGT3QdnP6f+abWAyJbkGTxCQlbtJ+RHE3oIZdJ9v5nX2hK+KbBYoIuYSzhtXdy6bk50cz6L8ksKUk18F5ile8BdhjTblUpEoz8qErsvN3laWMYt5HAuU+nxzMX7mshMEtdv0ecx2PBe13E+8qSCql8NAKP22gM9x6GBkvjJPmr8YEmOe0L0FUdGVUpldmc/w0ds5EOcRlZ001+Br6MDfWGlEY1UewfFRhWjmWEitS1K3E2nMGhPS7UQr8qw/4albx48W/YV/8QI0CPhrdeWD+Ce5jK7DxqFmWhp1HF/aOQzawhYKcjWiCvaZt5XKSsWzHN5Ohf7LBk/nPF1CsImoX5M54IU3pGtClDdAo4+/lpwveX0I24bEhPnlxtlCotldICHl5jO8+cQcpwghAdRvTrGohHp58+QIJBB0Mudt7onw8RVBHCzujKak0KrQ4SBdbKsophLHG9KD5DisWsXHVz3cYlwQRrfYwBbjT25IGoelJS
 UUSdmZVV
 jkIllcyWZgXPEBf2Gcb1j88AEIwAjRHHWLtSCJ/9jU8i7WOPKco5y6RSWd19yA7EcmV3jLxesoe+40O0eBL/g2CruOdd4enGvCSRK4bu4qlUv0xk4zUwcE5kqke41uq0VtwglrZe8E43b1pzJ50/nxc0VHQW9G7GjPB0xLTTJgyX6PZ/UyjgVMc4DMAEoU7o//fV/Dss0N3s2HQQiYr7t9qKVtfbwM35ZQHJlenUeHLtMGvUwJ3faas1CVcZMDTGbP2O+yA05ZNJ4Nw5mqG5MtaJ2lDHocXKYg/jLt+/bDokGou1m0lQzDH/02a3rPi7L9u1e7ozCCqKJlWi4wPQewicERceAhf6if0uemdKAA0O/riydDdpbMJm7TS626UHcqmkFGX1/q1z1qq+RaaQhGf5swsu7/RhHy4gtwzGjQuefm3Oq58y2CMuEwSaeixJ2xPBI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 12:37=E2=80=AFAM YoungJun Park <youngjun.park@lge.c=
om> wrote:
>
> On Wed, Nov 19, 2025 at 09:02:14PM +0800, Kairui Song wrote:
> > On Wed, Nov 19, 2025 at 7:56=E2=80=AFPM Youngjun Park <youngjun.park@lg=
e.com> wrote:
> > >
> > > swap_alloc_slow() was checking `si->avail_list` instead of `next->ava=
il_list`
> > > when verifying if the next swap device is still in the list, which co=
uld cause
> > > unnecessary restarts during allocation.
> > >
> > > Fixes: 8e689f8ea45ff ("mm/swap: do not choose swap device according t=
o numa node")
> > > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > > ---
> > >  mm/swapfile.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index 94e0f0c54168..cf780fefaf7d 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -1374,7 +1374,7 @@ static bool swap_alloc_slow(swp_entry_t *entry,
> > >                  * still in the swap_avail_head list then try it, oth=
erwise
> > >                  * start over if we have not gotten any slots.
> > >                  */
> > > -               if (plist_node_empty(&si->avail_list))
> > > +               if (plist_node_empty(&next->avail_list))
> > >                         goto start_over;
> > >         }
> > >         spin_unlock(&swap_avail_lock);
> > > --
> > > 2.34.1
> >
> > Thanks!
> >
> > Acked-by: Kairui Song <kasong@tencent.com>
> >
> > BTW I noticed the comment here needs update too. And the plist usage
>
> As I think, the first part of the comment is out of date and provides
> wrong information. I suggest we simplify it to keep only the last part:
>
> /*
>  * swap_avail_head list may have been modified; so if next is
>  * no longer in the swap_avail_head list, start over if we have
>  * not gotten any slots.
>  */
>
> > here seems can also be simplified? We never use a lower priority
> > device when there is any higher priority device in the list, as
> > devices are removed from the list when they are full.  And the first
> > thing we do here is plist_requeue. So we can just keep trying the
> > head, until the whole list is empty, seems good enough?
> >
>
> if we can guarantee that cluster_alloc_swap_entry() failure is always due=
 to
> the device being full, then we could indeed improve this by removing
> the "try each device in order" loop and only trying the highest
> priority device, as you suggested.
>
> A simple implementation might look like this (though it needs more
> thought and testing):
>
> spin_lock(&swap_avail_lock);
> while (!plist_head_empty(&swap_avail_head)) {
>     si =3D plist_first_entry(&swap_avail_head, ...);
>     plist_requeue(&si->avail_list[nid], &swap_avail_head);
>     spin_unlock(&swap_avail_lock);
>     if (cluster_alloc_swap_entry(si, order, SWAP_HAS_CACHE))
>        return;
>     spin_lock(&swap_avail_lock);
> }
> spin_unlock(&swap_avail_lock);
>
> For now, would it be okay if I just address the comment update in this
> patch, and submit your simplification suggestion as a separate patch
> after further consideration?

Sure, no need to do too much refractor here. I'm fine with the patch as it =
is.

