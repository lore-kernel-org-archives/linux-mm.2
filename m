Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D85C7CCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:28:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9314E6B008C; Fri, 16 Oct 2026 15:28:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E18A6B0092; Fri, 16 Oct 2026 15:28:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D4406B0095; Fri, 16 Oct 2026 15:28:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 436B46B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:28:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E224A0391
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:28:41 +0000 (UTC)
X-FDA: 85329476442.13.2AA2E05
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf31.hostedemail.com (Postfix) with ESMTP id AF8B720003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:28:39 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Scjqun/J";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792178919;
	b=tmjR3ypA89f2MLiJLQJrFfKWMRb0EZr6WjcgvftlGlJM4jrrZabhHhb6uSq35ZomQOmwrS
	zfm8XEMqDHlAVRUj2wLwCwzEQhW4Kw8vvmF7cBoiq7mVGbSQBHynKUMpCqRYPufSaR5yMe
	sNriqLZCgrhkZ0ShDuVcIAbTq/Wjv2U=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Scjqun/J";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792178919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gTm2vhKjxaNKyr2bSUGCE5oU0QWQpVTbCRBZYWrgf1M=;
	b=TRziESnw2+lHbgypahQYUttXekH/ubA+vHChJP290J30WLv1CGb9zNbeRSpEPlDEZ3APoI
	HxQK0/JQp8K01vZeDfuR1Z5fe/VJkgM3xtVp5NDastwpyBaX2Ct1KyxThsJGR2KpeM0W0e
	hGmGRZaP3vq/fbmiESZLKWlD8c2Q0K0=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48c4649b35bso151995f8f.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:28:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792178918; cv=none;
        d=google.com; s=arc-20260327;
        b=SAAGb8/jDknjjEBenMO9rtPBmVSUKQREaeI0JEQLLRH76RUt5Y25L77T81pdP7X0RC
         aDKLIIrkIWp3n9c+Q8Nmj3DIiyqPKbiBTs06F4WgMUWQEo1voBaDz2KS1pGOkoEUvjVf
         We3ql8UzLHJuI+b9AGt3q3+/0CPrKmciTiDGKN+c1l3qIKSlApWrmnVUjFbhrOJbz4W8
         2NzMP8wKGx3XaljwIqkoTctCPCh9moE/UNaaKdO464NvEZheYkW4PeFU6z7MC3B9vLuo
         hsTEASVE7ea3MqocAaPv1jjx9dGpFIt4AE++wx8LlHdH7eQ+MPhYX1xmzmRvHl9bN0qw
         xAlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gTm2vhKjxaNKyr2bSUGCE5oU0QWQpVTbCRBZYWrgf1M=;
        fh=d+IojjZfeaKwqKtrZB8dQd8r4Lz2TYT/2BVZqzCSxjc=;
        b=fkCtsc46vUhy8XcAdGuIfp5notnaL8HdSExk9EFVBDXD5MoGPufeLbmMour0oEpXa1
         likFilwEzD/wNCAuHyZ0celzQZwRwcTax5GRsNSYOIUQ9di2VH7GcCJ8jXo50y2Ntkdu
         aQHro+rMKqkHwr8X6zct7vGtacj0ydnZMdCNmJ8QHQqFyaxkB+DnJ1HwobF29A7cY159
         zYYiBVixymYW2wZzTNSU6a3Mh+EW8Rg8w/bel/Zsq9eC6xa9sZTNCZ1H0a7eXftAemyX
         91iJqXqr36nswfC4WDIPUZ8jbrrXV24pHQcG2eMImaTQTyc6UkS/iyaTpqV/bA28iJfA
         uDiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792178918; x=1792783718; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gTm2vhKjxaNKyr2bSUGCE5oU0QWQpVTbCRBZYWrgf1M=;
        b=Scjqun/Je4F7I7JP5WrIWGdcshp88upS6qRsqvUAu3h8HSJyfX2Ezg6v38Q8xyosZY
         CzpvP0hWYOnlSOL6DPlY+SV9/fHC0Q9QigrMiAHtx3LYVgB63fzCTK9lc5nWzPORq9Ax
         M915VQRwMq6SEziBRlp6P3p8qag0LqnXosP53GO6QgXp4U5qqff1EImeEMtRgF7AhfTF
         v2YYaRAimxf3GBihYK20Yo6WNzFxKeIj5ooSmQWrZ7+cgELKHjeSs07t03thB1CO7eJL
         bEaxuASJF6iw3+UXhHz3nn067bgjQt6JhX0aRXqqzXnCCxkO/Og4PtacZvybLbJpZbVS
         jINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792178918; x=1792783718;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gTm2vhKjxaNKyr2bSUGCE5oU0QWQpVTbCRBZYWrgf1M=;
        b=HBrwx/LLzJrseDT2OgVhNcH+nyBAdcQlA4mh5DVzmKdFbsMKYJOzOvIiCiGxIC3n+I
         a5EyMKn/LbdOJyEh2SB29AkVCNpGvt25EezhUEqSGc80InGhGRhH462rhfMmMUFf9yuy
         ++UeeygQXhG3ykZeWMZEaDUnZZz/HsNc0mb2onjNtBTCql15mYJXep32I/M6SGysNJ5O
         UH9v08UBis9xqTQiPFi+fujc9kNRymPg1845SObQ2xt9i12F5Q6a8CxhZga+IW8MdIdI
         T2OOKvkHbmpdFRCV5wOh2aCZqC1q91rrVswnv4G9OBbg3Q4usu/d1k06A+xZlwuO+Njp
         RCzg==
X-Forwarded-Encrypted: i=1; AKwUvByPugV6baEvVzAQMm+Egawqloezn7GMtilbOs9eRQZqlKtvFsUgdzi8UWzDNypAzfH1WcMjP8bTMA==@kvack.org
X-Gm-Message-State: AFq9FYIWJdLHGew47vTSz+2Gld7C4G/ns/9vTMhnBMmHVUy2ueE0PhkX
	Ys11cK3QIvQ7wf+WZVWHe99/y4sLJ0GPVhZES//POX/1k5UQ8vv3bXdU6yL/oHIRElde7n1OGLj
	m4Hc/6QvMxJ4fe05pv2HKQpaHXTyQzQ8=
X-Gm-Gg: AYBFou0hPAALIMtul+caf4FWhq/XbSWuP7Rsw2LM+pL8hjlDbKV30mltUEUv+yAokjS
	ujte0PFLi+KCJ8rhdrDHdi3S0VQUJQVl5KcU6mWp38lgw1hVA5BuOA0aPqpCQDSX0oeI0rlIaPE
	+4Ef/T5XljAt01LQy+CNQ5OLzHBvidZtjou2liXgfyBWBWR2AmkllQlmw3DMMcEqRuw35+I+3Qk
	V/BgcPFQNlRmfsFKMaLkvvb7+dpCRn4TMZnhCboVRAbcGw8qeT32gTL4XWyVhiFnJUTUjIdC582
	1NV/V1xRCkOjpTTc/QBOt2usC+8cCuRjgJ7gGllWOAihyUyD5iXb6kPXVa+h69EewVzO3tx7Mwn
	2WhMP3JX07nxVCHAFG4SSbk2/pgYS86v6zurBFSI5TzSFDVys9yfRttr/FzW6YHtba87Ry9dAAv
	9wcflYbg==
X-Received: by 2002:a05:6000:40cc:b0:48d:f5c6:1a0d with SMTP id
 ffacd0b85a97d-48e07bb5600mr1302929f8f.15.1792178918026; Fri, 16 Oct 2026
 12:28:38 -0700 (PDT)
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
 <CAMgjq7D50X47JFsTnF2-jYGv7i-Nd3WhQLK-TJGy4XkhMQU4OQ@mail.gmail.com>
 <62d17959-d695-4fec-a87b-8eadaaf995a8@linux.dev> <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
In-Reply-To: <CAMgjq7CJ+bwKgwUmCzO9Hr7TrL68bDjgAsLx-4AGuXo6zowh9g@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 16 Oct 2026 12:28:26 -0700
X-Gm-Features: AclHuK_hp_b8zp120YCuqjyWWJ8sGDHX6zBYEepjMwfG9dhLe1x58p6Tgmfo-f8
Message-ID: <CAKEwX=O4sPx5MtGL4-JwLzD4TWm7fNycFMiuOqLk4ADFUUipNg@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Kairui Song <ryncsn@gmail.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: AF8B720003
X-Stat-Signature: njy4wuin65p5ftcepwescbkjfqaq4kkt
X-HE-Tag: 1792178919-598703
X-HE-Meta: U2FsdGVkX194D/3hi23OG/xujbqTEoBCtSRGf0yd/ivtLwxtdh6rRGvNBUJmhDsMdFDFeChYZYSSxKiVJf25P2m4I5YwJHw9WhJb80Y2rhphV794L8CrHKMm8F8Zur1oVrkpMjLyYy2kKociz09/Wp/MLDwyp5VHrYXl8/czTFPlWXCVkvv6aAttAguco6LQilri0QThITC6xc243QGuha+nbIZgdPv8Ok0VuD9Upy8YKxsFoRS+MNecDrQzzCWrc/vuSGRk185AWThA7eA3gHbYeaterk0pSOHWNlLDYHeNzhIw+Xht+sx0VPE5NYqd9G8S+yPrQ0Uk/Tb2OGtZvKUCGXuB1MeZLisx9giiCAs1oGi4hObHq5emy7AcWT7hR6PYX08U5ixnlIznVy3ILlxKI4mUedAMuuMdisHRBvQNsqMkzVf5lL3gGTllhYKDCZQ+ENnyuxRd/APYpjLS75fLZBNIBqLEKj766LNG8DRIGJeWsNlIkw34NKQ+FWZ7S9Q0tW8hpXBwuOj93+9NpxhWrSUXRP2X1fnt8C6abF/gqsIbImDcNTwZ5AhlLAa+fdaIl5HXbCSeH0mYFaGHu4YmsW5IbqfSznM/Rp5Nz19HcGVO8w5Bv2uL/x6VMIzhGR6QbX3Q3oKMKze4YXphr7/ikYcmgg7Y/Gpk+FFJcrcnfU5OJguiKit95PWbVwkSp1kdAT1lAFZox+Eb74yk3Yf2ql4cOWH/96xn6ZGe2C7l9cP++xVHwR4UIe297nSdfovFSQHkhrqm5v3thcimKGycUo/ZPfX5N9O812Zm5c6BI+QiHa0bVTxPVgxrg3bz9cukpftxVLRlMsL12VRp9KERD6z2C8PViJO47u8+i3y4FzZuPnDDAf6+Ax9GHkJnHk/MZO0jfSjN9PViAuXHWH2GapBUO2X2KNcuVykayzKS5SHhqCeTy4GZm9AC9VxF7+hsM8/GUPbUezEMmGh
 LyNoIl34
 G/zERzbML6u+UFY5BXIxEnLnbQRzhNYv9pst6qKKCpoAHqIyXIhfC4VI3hB/fbrCzwtQTu4uVgJFdsE7uxj7J/vgtMZ6UiBR5zy+JtuiR5zwBlOpBE3dVXFPk+iOu54FXE+8wmuk4poeexpf1/9iSsTsuAGGuxG0sWIfs4LWGluTtkvR8PFivpW0b99rHZCG/0qbie4NBi6oNxVfr6a+J5RUdht5R+j0bVeZczbLOPy+t+dpTTCUBTdwVQ5ue38xQrlQ5M4dEVcmU7F/mZWP06nXdz8/LTIHadKtVkVNoofwoLu38x2Wu0WaLh9SxghvsI8t6EN2cqspOneLLxQYKC8CGD1u+cHBZpZ5yZ9Rzn4hA6MEiUdiA6JIiSIa9CHQBf6q/T8jPqGhVBg7t+dfoDLIlFwoqhKW17QfJmj8/S1oDQarWOFv67Y6W2uzbXyZ2a+OKc+7qu9TEBws3s9rWbgqhxG9r/rpnuIqasdbgLpVVE/c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 11:24=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> On Fri, Oct 16, 2026 at 4:42=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.=
dev> wrote:
> >
> >
> > On 10/16/26 11:05 AM, Kairui Song wrote:
> > > On Wed, Oct 14, 2026 at 5:10=E2=80=AFPM Jiayuan Chen <jiayuan.chen@li=
nux.dev> wrote:
> > >> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> > >>
> > >> On our production hosts we saw swap cache only pages keep growing fo=
r days:
> > >> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB o=
f
> > >> swap slots were held by folios that no process mapped any more, char=
ged
> > >> to cgroups whose workloads had long exited. The only way to get them
> > >> back was swapoff, and with other services actively swapping on the
> > >> same host that is not an option.
> > > Hi, thanks for the report.
> > >
> > >> Such a slot has swap count 0 and an unmapped folio pinned in the swa=
p
> > >> cache, left there after a process exited or did MADV_DONTNEED. No pa=
ge
> > >> table holds its swap entry any more, so nothing comes back for the
> > >> slot; LRU reclaim drops it eventually, and the allocator only reclai=
ms
> > >> such slots once swap is half full. The growth stopped exactly there:
> > >> at 50% of the device, where vm_swap_full() becomes true.
> > > Hmm, I think this indicates a much cleaner fix is available.
> > > vm_swap_full is inherited from the old allocator, we can instead just
> > > let the allocator reclaim the slot if the slot have a count of 0 and
> > > ignore vm_swap_full at that point.
> > >
> > > Will this work? (Just a minimal implementation for reference, will be
> > > even better if we can avoid the overhead).
> > >
> > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > index c3288910b3e3..94670fe82f31 100644
> > > --- a/mm/swapfile.c
> > > +++ b/mm/swapfile.c
> > > @@ -212,6 +212,9 @@ static int __try_to_reclaim_swap(struct
> > > swap_info_struct *si,
> > >          nr_pages =3D folio_nr_pages(folio);
> > >          ret =3D -nr_pages;
> > >
> > > +       if (folio_mapped(folio) && !vm_swap_full())
> > > +               goto out;
> > > +
> > >          /*
> > >           * We hold a folio lock here. We have to use trylock for
> > >           * avoiding deadlock. This is a special case and you should
> > > @@ -903,8 +906,6 @@ static bool cluster_scan_range(struct swap_info_s=
truct *si,
> > >                  if (swp_tb_is_null(swp_tb))
> > >                          continue;
> > >                  if (swp_tb_is_folio(swp_tb) && !__swp_tb_get_count(s=
wp_tb)) {
> > > -                       if (!vm_swap_full())
> > > -                               return false;
> > >                          *need_reclaim =3D true;
> > >                          continue;
> > >                  }
> > >
> > Hi Kairui,
> >
> > I tried it on our box (224 CPUs, 931 GiB swap partition). It doesn't
> > help there: after 100 rounds of the reproducer the leftover is 291 GB
> > with it and 309 GB without, and both stop growing at the same place,
> > 488 GB, half of the device:
> >
> > # cat /proc/swaps
> > Filename                Type        Size        Used Priority
> > /dev/nvme1n1p1                          partition    976561148
> > 489006260    -1
> >
> > # cat /proc/meminfo | grep Swap
> > SwapCached:     489006260 kB
> > SwapTotal:      976561148 kB
> > SwapFree:       487554888 kB
> >
> > cluster_alloc_swap_entry() picks clusters from nonfull_clusters first,
> > then free_clusters; it looks at frag_clusters only when both are empty,
> > and at full_clusters only when vm_swap_full(). A cluster gets onto
> > nonfull_clusters in partial_free_cluster(), that is when
> > __swap_cluster_free_entries() frees a slot in it; after
> > alloc_swap_scan_cluster() has used it, relocate_cluster() moves it to
> > frag or full.
> >
> > A leftover slot has count 0 and a folio, so __swap_cluster_free_entries=
()
> > never runs for it. Once the live slots of a cluster are gone, nothing
> > calls partial_free_cluster() on it again, it stays on frag or full, and
> > cluster_alloc_swap_entry() doesn't pick it until the device is half
> > full. That is what the swap table looked like after the run:
> >
> > list      clusters   leftover slots
> > FULL        106415       54484480   (all 512 slots leftover)
> > FRAG         44822       18471614
> > NONFULL          1              0
> >
> > Making cluster_alloc_swap_entry() revisit those clusters means changing
> > the list policy.
> >
> >
> >
> > > Or, from the LRU's side, put swap readahead folios at the tail. I'm
> > > actually trying to do that and it's not very easily doable at the
> > > moment but will soon be easy to do.
> >
> >
> > That helps the RAM side under pressure but doesn't give the slots
> > back.
> >
> >
> > >> Options considered:
> > >>
> > >> 1. Fix it on the readahead side: after the read, check the swap coun=
t
> > >>     and free the slot. Covers the lock, not writeback, and the
> > >>     asynchronous read path unlocks in the bio completion where the s=
lot
> > >>     cannot be freed. Two places to patch, neither clean.
> > > In fact, readahead checks the count before starts the read. It should
> > > prevent some of the problems but seems not enough.
> >
> >
> > Right, the count is still 1 at that point. The zap drops it to 0 while
> > the read is in flight, after the folio is already in the swap cache.
> >
> >
> > > And another idea, what if we just add dropbehind flag or rotate the
> > > folio, if folio_try_lock failed in __try_to_reclaim_swap?
> >
> >
> > dropbehind would work for readahead and writeback if the read
> > completion honoured it too; today only folio_end_writeback() does, for
> > zswap writeback folios, and swap_writeback_dropbehind_folio() expects
> > the folio off the LRU. It still misses other lock holders (migration,
> > split, ...). Rotating only helps under memory pressure.

Yeah might be worth trying. You'd have to modify readahead and zswap
load logic to check folio_mapped() etc. I suppose...

I'm not sure how reliable it will be FWIW. There is still a race
window right? Albeit a bit smaller - the readahead thread might check
the dropbehind flag before __try_to_reclaim_swap() sets it.

>
> Right.. But I think it will be much better to avoid such folios from
> hunging in the swap cache in the first place instead of having a
> worker to reclaim them. I'm not strongly against adding a reclaimer if
> other approaches are too difficult at this point though.

Also, IIRC, dropbehind can only be handled in task context, right?
We'd need to make readahead bios to complete in task context
(BIO_COMPLETE_IN_TASK). I wonder if this has any perf implications.

Another idea: how about, in swap_read_folio(), where we are guaranteed
to have the folio's lock, we check if folio is mapped. If it's not,
invoke folio_free_swap(), unlock, put, then drop that folio from the
submit batch? That takes care of the readahead race. Seems safe to me
(I assume if a folio is not mapped and swap count =3D=3D 0, then it's a
pure readahead artifact, but maybe I'm missing a case).

The write direction already tries folio_free_swap() before submitting
the writeback, FWIW. So that takes care of both directions. But who
knows - maybe we still have a small race window, and that's bad
enough.

