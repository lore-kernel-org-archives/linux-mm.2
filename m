Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85958CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 18:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7081C6B0088; Wed, 20 May 2026 14:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFC56B0095; Wed, 20 May 2026 14:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61C6A6B0098; Wed, 20 May 2026 14:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 527C16B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:19:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F04DDC1A41
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:19 +0000 (UTC)
X-FDA: 84788610438.09.AD39476
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EEC971A0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOpzEP6X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779301158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r8k5uHCoRVBIv1c9oG1U/zO3ZMGj+nRan6mX7s9e7uc=;
	b=5BbvRDMmSrk7N/j3X+dZy13mPM2dX59Kdf9eeaxOzX5l7c1pO3rg8EsOG3NuD8t/41Pz2i
	+bZzS9F4cI3cPPApA+pPdD+NdYwXQspNsSDovhb/LE4DFIprgJvOdGfJ0xO33pnMy+GrFj
	e7KfDjUvjvE1ZukYvY3vka7Z9pqdJ7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779301158; a=rsa-sha256;
	cv=none;
	b=1m52h/wVKzZTXNZ4iHrjsf7PaiuYCcPV0c6Hokq2qln2hHAyHrUMQh/AJwtLgXvsGjpkka
	eU+b33cXJEg1Q1x1XRV56dWDdaXYt4COW6HhQghXEscy987ULnRYv0ZMXfoq33pdpdXLvc
	wGE4E3t6eoFlfO/vT7VoPGZN9TXmoKg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SOpzEP6X;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BF67B4447D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E7A1F00898
	for <linux-mm@kvack.org>; Wed, 20 May 2026 18:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779301156;
	bh=r8k5uHCoRVBIv1c9oG1U/zO3ZMGj+nRan6mX7s9e7uc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=SOpzEP6XeuA3Q3JycuX1HpUG7nAfeozoZvhTBbRJuVxMY2Ise5Iob4+Wo4wr7I8PC
	 vx300lRHoLbEr8v7IiMJrtFD1ezl/jht122a5YzXzA71RbcgSu301QwSPLZmoQBnQU
	 1pzumfmXix892evdkafe343HNAhDb+QZ9lGPy+p8KaVhRYQr9ppVM5znFKx7szL8Rl
	 5cRq79mxg1klZ4CeNcbRWD7oV4QbrTHUvZGUxZRF8wx0UjtGBiF7yjE51jFqKB0fAs
	 6K2jOSaCzkm7RkkfoMY3x/+FN2Rbd3N6ZKywqfeLBGfGN73r+2/uS5M0o2QDHo0msk
	 E0fs5zekeTqGA==
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5a87edf88b3so5541655e87.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 11:19:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+8HFE2VCvy90ay8y8+63nw94+/3VHLeEBdLzt9B0sV/KDxjQTZlNSk2VOFXfhst3UdvwSX5yNkYQ==@kvack.org
X-Gm-Message-State: AOJu0YxDYvKffUMxWBbpsjgOYUNz++d0TX8jUOoudJ3lztVlV3oywE+E
	17rSUaVf0VmG0gs/USqKf/N7sSWi+q4qyESrz4IDapij44PI81kl1Olztgb/W6NiftshFGcqp88
	Ry+5hQcoAgFm0dr2ymxRSJbagbeAwrxo=
X-Received: by 2002:a05:6512:3188:b0:5a8:a555:f57e with SMTP id
 2adb3069b0e04-5aa0e73da54mr9346298e87.30.1779301155154; Wed, 20 May 2026
 11:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260520150018.2491267-1-riel@surriel.com> <20260520150018.2491267-34-riel@surriel.com>
In-Reply-To: <20260520150018.2491267-34-riel@surriel.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 20 May 2026 20:19:03 +0200
X-Gmail-Original-Message-ID: <CAJZ5v0gtkPK7+a3pBgiZRSHp7842L8aaZGOPG+SrdnuNebN0aA@mail.gmail.com>
X-Gm-Features: AVHnY4K_PJZMu_LRCyJ1SsE4uQ8YoN1fMVm-ozSbCHY_r7CEJzG7JEw9O8vu1d8
Message-ID: <CAJZ5v0gtkPK7+a3pBgiZRSHp7842L8aaZGOPG+SrdnuNebN0aA@mail.gmail.com>
Subject: Re: [RFC PATCH 33/40] PM: hibernate: walk per-superpageblock free
 lists in mark_free_pages
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com, hannes@cmpxchg.org, 
	ljs@kernel.org, ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>, 
	linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EEC971A0009
X-Stat-Signature: 7osmapmjm1bbotrx7qmh9sbhuay5m44a
X-Rspam-User: 
X-HE-Tag: 1779301157-703186
X-HE-Meta: U2FsdGVkX19zYq5YHh0JIaV5gPLwwPBa/eH3XbC1OETsJQz30PlWKiMn0V7FfJOYQ/5HaxuWGUAiGvvpTZpn7obAWl4RYeGDnX0pIRQPX7YH7AGOJgwribkWOoqU9vd8K4isOEH2tim/XugBtbw7LpRlLY/e5HbjzzTTXBN9jNvlVzKB0CW0n5Am1XCvkn8TFAf2PNuem1EPil3T+iWRnN8YXr0aqlflCguPQcu2vJ1KDEIahJH76oK3mFAUvjOkHhiT6CwOMVqJxCFtYNzQYXQdvJ/5Vrub9tTlohsMwS4vh6VUgnRcszxSNeZknJCtHEnrAgtzBEHqeUv3kox0ZhAbAQFMYP6TeWd0WW9vzTPHe+jAM2NsQzSLZTTvWHJ/oNMaqk2aywawvJoKGm4Cj2EEqpXNAoHfAQYYsDmZL8oE5Rz3y2qMVXKAewrYDt1tCHxJzjUWgRVdHfJ7SoSvObzGzyW1ipnT7kfi4XrbrjfnrEiGi6eZF3Vu5i2KWgY/RMOE7AncveHaas8Ln6Ajaye5y/+R52VF0QJ2UK6musDi7QXNDIWF9hO8zYrPf9MA1xrgc2NzVnT/17Y9aDxOgYQXsGNkjW/BwDqPnbX90SwiciKikqSiHhiNk7KSkuCY1LFakbGAeDRkXDeuwW0v/byW1hd6xEWmIlqjSOUFIu8oGGINWvqsra2MOal14NCPumGzoZTYA8YczOSsGqiYbf3eNRxT/4JNlsWHhzy8ZbVQ8klaFfdtAY/M2I8T7foNMQGstLTXyQSspgde0HgB4/BJAmCBxxj8hWxcg3FGWcxqMApC+ruOfCWMyHX+3OUBcBy84R/W1i37tZPIlRoKXIzA0NfGlkR3aqvLQ4x0hp+2w8SOM1DmOpoP38rlR+SX6DXcLYAvVZpFFAgQNXiu3HwmPbFZujqCmhBVDMLGxMJGlcHZlnR5GTw+n7MugfznVobqO+R06PqdVkio5FW
 VXlvfPeZ
 AT3IoVuVBBhDKzxKG07v0CbBVVHbHXPa7OTspUETHvNlX+ZrERYxzN63+dUPsyS5rIMM7LIlTqOWtM6j/hYdra/IdLw0vODg1hpW3PC4DBlyny66r50vH6P4gX+zBHMQyp+3VHRqI3UvvqT63GItxlJ4Y1IekvSXT4fkmpZ8V0jJnubNz0qh+KoO5y/nEyFsMyaxUsWtRK3ETxxmqF7bMjBYh7aeKo6TmGrhE1Kbc3GVwWDp0LIz5hvjHfLQQKXOXOYzjlvaE+0AAWJN7uElYIFUHxjB/zTqEyBKc4v9bbwgM7zgkmtiZssnpCJuJSlU5sgtYFGbTWqeDqreUZ6tvPL0hgf5XFWzv52sGOhGt4k02RoAU8EJXpAtTqRVPn+7ptIAUnSxBxkObN7fZYSiWmvuOrT/M1HUAWqx5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 5:01=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> mark_free_pages() walks the buddy allocator's free lists and calls
> swsusp_set_page_free() on each free page so it is omitted from the
> hibernation image. After the SPB rework, free pages live on per-
> superpageblock free lists rather than the zone-level free list, so
> the existing list_for_each_entry() walk over zone->free_area[order]
> .free_list[t] found nothing. The hibernation snapshot then treated
> every free page as needing to be saved, wasting image space and risking
> OOM during the snapshot.
>
> Wrap the existing per-page walk in an SPB iteration loop. When the
> zone has no SPBs (e.g. an unpopulated hotplug zone), fall back to the
> zone-level free list. The whole function still runs under
> spin_lock_irqsave(&zone->lock) without drops, so there are no lock-
> order or hotplug concerns.
>
> Build-tested as part of the full mm series; kernel/power/snapshot.o
> compiles cleanly in that build.  An -Werror=3Dreturn-type warning in
> enough_free_mem() exists on some configurations but is unrelated to
> this change and predates the SPB series.
>
> Cc: Rafael J. Wysocki <rafael@kernel.org>
> Cc: Len Brown <lenb@kernel.org>
> Cc: Pavel Machek <pavel@kernel.org>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Rik van Riel <riel@surriel.com>
> Assisted-by: Claude:claude-opus-4.7 syzkaller
> ---
>  kernel/power/snapshot.c | 35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index a564650734dc..f96885bc46f8 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1270,17 +1270,32 @@ static void mark_free_pages(struct zone *zone)
>         }
>
>         for_each_migratetype_order(order, t) {
> -               list_for_each_entry(page,
> -                               &zone->free_area[order].free_list[t], bud=
dy_list) {
> -                       unsigned long i;
> -
> -                       pfn =3D page_to_pfn(page);
> -                       for (i =3D 0; i < (1UL << order); i++) {
> -                               if (!--page_count) {
> -                                       touch_nmi_watchdog();
> -                                       page_count =3D WD_PAGE_COUNT;
> +               unsigned long sb_idx;
> +               unsigned long nr_lists =3D zone->nr_superpageblocks ? : 1=
;
> +
> +               /*
> +                * After the SPB rework, free pages live on per-superpage=
block
> +                * free lists. Walk every SPB's list for this (order, mt)=
 cell.
> +                * If the zone has no SPBs (unpopulated zone), fall back =
to the
> +                * zone-level list head so that any pre-SPB pages are sti=
ll
> +                * marked.
> +                */
> +               for (sb_idx =3D 0; sb_idx < nr_lists; sb_idx++) {
> +                       struct list_head *list =3D zone->nr_superpagebloc=
ks ?
> +                               &zone->superpageblocks[sb_idx].free_area[=
order].free_list[t] :
> +                               &zone->free_area[order].free_list[t];
> +

Suppose the code below goes into a separate function returning the
current page_count value and taking list, buddy_list and page_cout as
arguments.  Say its name is do_mark_free_pages().

> +                       list_for_each_entry(page, list, buddy_list) {
> +                               unsigned long i;
> +
> +                               pfn =3D page_to_pfn(page);
> +                               for (i =3D 0; i < (1UL << order); i++) {
> +                                       if (!--page_count) {
> +                                               touch_nmi_watchdog();
> +                                               page_count =3D WD_PAGE_CO=
UNT;
> +                                       }
> +                                       swsusp_set_page_free(pfn_to_page(=
pfn + i));
>                                 }
> -                               swsusp_set_page_free(pfn_to_page(pfn + i)=
);
>                         }
>                 }
>         }
> --

Then, what you seem to be wanting to do is roughly

if (zone->nr_superpageblocks =3D=3D 0) {
        do_mark_free_pages(&zone->free_area[order].free_list[t],
buddy_list, page_count);
} else {
        for (sb_idx =3D 0; sb_idx < zone->nr_superpageblocks; sb_idx++) {
                page_count =3D
do_mark_free_pages(&zone->superpageblocks[sb_idx].free_area[order].free_lis=
t[t],

   buddy_list, page_count);
        }
}

which would be kind of easier to follow.

