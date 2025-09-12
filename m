Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FB0CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 12:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813C18E0015; Fri, 12 Sep 2025 08:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB648E0003; Fri, 12 Sep 2025 08:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727FE8E0015; Fri, 12 Sep 2025 08:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 64A7A8E0003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:37:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EAE487092
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:37:19 +0000 (UTC)
X-FDA: 83880548598.20.522EF85
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 247C64000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 12:37:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f5+UqZE/";
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757680637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wz/C46Psvq2kfhwsNdlDHKUjeKS7S+kzKfzTRC5fRVY=;
	b=4nbFNqPJPm1xvmqZbc/S8gasCTfTeCdj29b13z743TZJQbc2WPrIEbmNCMXQ21nKK2hu+4
	EmuhV5tSeNE5CHYVLD7YLfB+XzekJu6wZoXdek5WE+LwZeYNT3BHtPSWoXON2q9Hov3xDU
	EuZJJu1nqdWN7ilsvseMOLjs5R5kQVY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f5+UqZE/";
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757680637; a=rsa-sha256;
	cv=none;
	b=KjIlq9sn3Am1YsrSOgLmExfKicichcNa5NeO5VNHvBSy5s327t1pRnD4QD0wvqNmrQAwR4
	NRzFcCln9smX4YwrE3qo0YjR0kKggTtuQ5qT9V39PiWMLJHeDvQH6sALk3Xm97bhGTA4+7
	RBvj3e5E/Z/5KueH42YVBLU2tyBCqEU=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-61d7b2ec241so2271880a12.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757680635; x=1758285435; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wz/C46Psvq2kfhwsNdlDHKUjeKS7S+kzKfzTRC5fRVY=;
        b=f5+UqZE/5UukyCzxO0jNc35RJMu9aTFvZmy6KL92Hyzo43naEmznfcj4TIhc1WUwFM
         7fQeTf5/0z+NT/dD/7mW0UXWe2ZTZKABNW7FE5+ZAzhDazJnfbReVKIkSXnniFJ+5vGZ
         GD/yb9byI4dpfv7p1rQKv+juVxgpGnHNYu6KOLBjf8TuG9+Qtrwha62BWAKlAEOpS6fR
         gdLCGXoLmFV/7RcuE9IbGeskHMqWW4s9X0DIw+BH/fTkTwUcvXWNLyTZFCp75oatEYig
         k1yOa8qbXvvIRl6AcgWqrz3kjQf4DykxR6MGv2PoaI1e575+keoB1ybMqsqjO9Y5R2Ra
         Q87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680635; x=1758285435;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wz/C46Psvq2kfhwsNdlDHKUjeKS7S+kzKfzTRC5fRVY=;
        b=QtzMFpykz0qhHaCpcY0UADeQuNR7Gow+r+A5ITWXehyrKoGsFEh3B1zRJpu4nDMGZ4
         T8liqS/4twV5p8zrntRhRDm1MyuiPeoBLxy/zdt+7woq7Q9r17ZVRyJ23d13qkTcOlk6
         NH5Ju+Jw0uL1uQVyKvLv753ZZE8maB1lbUmuXkE1knGiJ/DnoSwRIUrVUwmdyXp69qHn
         ilpNU5n0y9wmemhOF/y/zLaYht2hputvoXz+82SxEwhyRvJ+ud/4RU6wtYwxbQ+08/it
         VFAdvtJQaP+z/+YIhxVVezrqvxk1SZhm+AiHvsw0aCSaaAVYRXU5aKSzHoDnPNQkjdgX
         KGsw==
X-Gm-Message-State: AOJu0YznSB8reNqcc5Jhj5F3Ot41iMXhZPao42XkRhUW/SIQeTI4FXsn
	Gbx1tg4rsVScxrdtuRp7sEcvLH0KztOIFNTQ/Hdfe4z5vVKSh3aOeEkeRvwixA/iNneq9T1dxsq
	ojPSBRvUhpxEqZZgWnMyvz3SrJkpB2hY=
X-Gm-Gg: ASbGncv4671LU2U4Y+WLeB92Ayzz9rFF03JNK/GVUA/t9HiMIn2siYxOAWH/o8RFdeF
	R/v8tCmIbqUbP9maQ8TarUtemKGfw6j3SEpuc+qmErGn3IDa+JTpCDecNZW25+wSnyBgFJGB/Og
	Z6uxbB86L+SvTfv2RL+lu873KUgVFYrGjaJPGaTuxSNofbPUYBSEL09Jt4L7q/z/rDW5ZR/liTq
	TJ2Csb3VNYi99GI4nE13w==
X-Google-Smtp-Source: AGHT+IEXdJoJvW3GTomdscmZ7eiD9XOvoqY091+jg51jVcWuUMkqZA11LP10M+lC0ki/1IzqNTT94B4N5DH/ISeL3v8=
X-Received: by 2002:a05:6402:50c9:b0:61c:3c58:7114 with SMTP id
 4fb4d7f45d1cf-62ed830166emr2931032a12.20.1757680635204; Fri, 12 Sep 2025
 05:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-1-ryncsn@gmail.com> <20250910160833.3464-10-ryncsn@gmail.com>
 <0cb2bc82-1957-4efe-8c85-8558743dcf80@linux.alibaba.com>
In-Reply-To: <0cb2bc82-1957-4efe-8c85-8558743dcf80@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 12 Sep 2025 20:36:38 +0800
X-Gm-Features: AS18NWAeWgoeKJ1UdexxXGmEevDezdhBN-_bRlXVKFhBYiOsW0JEwkek48tjQ-E
Message-ID: <CAMgjq7Bc6r2=BcAPCeVPcVJ_hP8bXTs_pya2fWg8ZL-vTG9SAg@mail.gmail.com>
Subject: Re: [PATCH v3 09/15] mm/shmem, swap: remove redundant error handling
 for replacing folio
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 247C64000E
X-Stat-Signature: awykw4wdpxyb8netm39ybje54qyyt6g6
X-HE-Tag: 1757680636-822582
X-HE-Meta: U2FsdGVkX18yeF6cIU/5IfcdN8YksNccmad5DmB+buJTIzy/Yt57QI8MUq1hXLzxEdH6Tc16lBr7Cwc8oaTOrZps2e7/+cR0E7+TSsSH7cUofFqzxqDdApPMdOYh961Q6VAW5z0kv0icpgP5+N6SfnmgSXoU9U5S/TYTXJw4f0spKqN77TTgx1p4rN2hEF4iHAITquahGRm1wg7KCXWo0f6ijxUESxFAi3336Fdl9ONJVrfQzNacVBDfotP56byhNPuharMIKuI91RV0XfLWuy7Sj5cdoha3fl4Ds8eOQiz1ru+NvtL9G4CLyMSaXY+70w4h4P8BQM66bErG2KZHYgSQoXtr5zBVUlumGcE9W7+cwVpY+dr7mz6PL5pILmcTFolhPLbMCSsxPUN+zW2AE4lhtEtSnvB8WDsqiYM5WOzEobqcM0gdY6aJ2XPBXbPsxPWkdYfFUlBHdDetF8JLvpCmyVbvtw98QjrIxvb9a2T8SoJj0Qjf9E2r28Pr5PJTskPHtH2lcK3mxVLKZ/n/7EPD/Sc7zCdM3FA/W3PJUxaPwzVwtQl7vnd2RttLSeulqoklsP2cbAPBgqmm445Ie22Zq+JcxMa1hL6+2aXibSdgjiAA0mXDjsDMP2egKuFVdCOCwgfeVARDu3xKcRGbZ0zujZTcmlKClzbP3Q83fTKEbo/KHWK4OdyWDn75jjAS9HK8ymJ2FCXvLdm9XSYWf/U826rMCO2ZDPv9Nh5acMmROea7RqJ5EIbaOc3rb+rL/ETMQl/LSUvpqXCrJoPLYlXMfRAUm+u9SQIBWhGPEPprgGcXd/A+fEg8sxv7vvtURdqg6798LJ8mQI2K0UL63EC8jU4vlAUZfXmE7I3La/T/Oqg5cnbqyMV+k9AU7KUXOp2nCaTtl7oeHYVykaqaYmyGC6+ZOB93xSQAPJQ2HoUmADXrz0G2K3otIfF/bPaBTJTjcJ7w03MY79nKIhD
 Tx0kwfs+
 5lL6YTQAER7Q3euCQmws4t09kRczkM4+x7zZoVGnneH7+93Z2qb9jdi6IACcKabnb9j6WBXvGUfty+fhJZH+MUCvlyFq04SKXOhXtmuejHARPphMT+3AJrWvllS++hcRUnR3V82Ajf1O6yHO1Jc0C76MoEmkZTygkH8Qwaq5bGE4xWN/qkTofFR0kRSEVvAO9DBCxavxEigyZzPsX/+uwRcZV4BiBpsKLNswlW8AZzUmChbNS7i+efy4KmcROf+ZEo733k8mQ/xnBM4f4OFe3XPdf7Vzb9+9y/DRZ4CZF+LUmAvgtNsfiR6iNQbJruSoApSM3528PBw3lUzO6xiuYpsdV3F9yAHKO/DBbb8OSWXX5RrCWro4psgazKlbkkGLAYDLVCJj5FjvUYKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 4:22=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 2025/9/11 00:08, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Shmem may replace a folio in the swap cache if the cached one doesn't
> > fit the swapin's GFP zone. When doing so, shmem has already double
> > checked that the swap cache folio is locked, still has the swap cache
> > flag set, and contains the wanted swap entry. So it is impossible to
> > fail due to an XArray mismatch. There is even a comment for that.
> >
> > Delete the defensive error handling path, and add a WARN_ON instead:
> > if that happened, something has broken the basic principle of how the
> > swap cache works, we should catch and fix that.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Reviewed-by: David Hildenbrand <david@redhat.com>
> > ---
> >   mm/shmem.c | 42 ++++++++++++------------------------------
> >   1 file changed, 12 insertions(+), 30 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 410f27bc4752..5f395fab489c 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1661,13 +1661,13 @@ int shmem_writeout(struct folio *folio, struct =
swap_iocb **plug,
> >               }
> >
> >               /*
> > -              * The delete_from_swap_cache() below could be left for
> > +              * The swap_cache_del_folio() below could be left for
> >                * shrink_folio_list()'s folio_free_swap() to dispose of;
> >                * but I'm a little nervous about letting this folio out =
of
> >                * shmem_writeout() in a hybrid half-tmpfs-half-swap stat=
e
> >                * e.g. folio_mapping(folio) might give an unexpected ans=
wer.
> >                */
> > -             delete_from_swap_cache(folio);
> > +             swap_cache_del_folio(folio);
> >               goto redirty;
> >       }
> >       if (nr_pages > 1)
> > @@ -2045,7 +2045,7 @@ static struct folio *shmem_swap_alloc_folio(struc=
t inode *inode,
> >       new->swap =3D entry;
> >
> >       memcg1_swapin(entry, nr_pages);
> > -     shadow =3D get_shadow_from_swap_cache(entry);
> > +     shadow =3D swap_cache_get_shadow(entry);
>
> Again, there are still some issues with the patch split. The swapcache
> related APIs replacement should be placed in Patch 8, otherwise there
> will be buidling errors after applying Patch 8.
>
> With this issue fixed:
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>

Hi Baolin

Yeah you are right, I need to move these few changes to patch 8.

BTW I also found that the WARN_ON and irq unlock needs following fix,
the stats update need to be done with irq disabled:

diff --git a/mm/shmem.c b/mm/shmem.c
index 957e40caba6e..c4d491c93506 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2121,14 +2121,14 @@ static int shmem_replace_folio(struct folio
**foliop, gfp_t gfp,
        /* Swap cache still stores N entries instead of a high-order entry =
*/
        xa_lock_irq(&swap_mapping->i_pages);
        for (i =3D 0; i < nr_pages; i++) {
-               WARN_ON_ONCE(xas_store(&xas, new));
+               WARN_ON_ONCE(xas_store(&xas, new) !=3D old);
                xas_next(&xas);
        }
-       xa_unlock_irq(&swap_mapping->i_pages);

        mem_cgroup_replace_folio(old, new);
        shmem_update_stats(new, nr_pages);
        shmem_update_stats(old, -nr_pages);
+       xa_unlock_irq(&swap_mapping->i_pages);

        folio_add_lru(new);
        *foliop =3D new;

