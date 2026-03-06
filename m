Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E04F5140F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:55:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F586B0005; Fri,  6 Mar 2026 01:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D036B0089; Fri,  6 Mar 2026 01:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEECD6B008A; Fri,  6 Mar 2026 01:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFCE16B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:55:30 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4EA751A042A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:55:30 +0000 (UTC)
X-FDA: 84514727220.20.767D03E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6498540009
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:55:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q79/OmxY";
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772780128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=USHu/7CpH4LcZ2jIDqDRGYLvrfdbIQMZzBaM4cK+Q30=;
	b=55mIu9+yXYcWsKvtOiz3dS9ut1H/v9YgxMfUUAk4xSCA+dDHPSI947CpH0LGaqgVqapMkt
	bG57YoYbdks8hICYp+jzXlKk76KVSwo6IPYuIzM9vWdHyhDbrNkYjfRK0ktS8KEPOUK39G
	URsE7tjmtCsJ3qCwV/8TK/aBzy+PmXg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Q79/OmxY";
	spf=pass (imf11.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772780128; a=rsa-sha256;
	cv=none;
	b=bAW0HUrJxvAkPKEb8mlvDr7GyzcQZOmlRKPDqUEj2Qnj2mKp69dcpk+zlh1YiMdSkOFdKC
	7HXZLAMcfbnPERPHGavNTLFGOsGF66m5dNMZGgPQcjEtAPU5em/bZVdyR4fEUMtzi638XH
	dJNo9NVfuZGGr5W/d19kJfyPaViEgs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C041A60127
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:55:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7378EC2BCB1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772780127;
	bh=yHP/NYIbCCLTWuIe4vFzOVhL0C1U0S/OpzVwTdv/CSc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Q79/OmxY6Eo1PNX+yKu1uI3WtN+QTyKGjOifmXhz/c1Dlwica4bw/DDJGqdvbDRGd
	 MKWXIzGu5jn01darBCGMT7o9QwAG31wMqnzU//kn6lcUR1ik/+CD5VfUy5W5g0IgOU
	 zRw1Jv+ohuq2g2yjWSDROGyRrhPo99BZIUF+zWGRd796N6p+8JHDAHt+X9KB0sQTkY
	 Tx3EUzyCdIryBVYqKDSfkatFjaA2cqEYhULFr2Pltyz/MgYdxvuCTMOTp/yGsF41W8
	 yHfM6iH0U0MRON9m+M213qRVUY/5vIzCuYYM0WRkoHtpq1DIOgqQ4JRGedcQ4/oe1n
	 tYRE9EkhzfSLw==
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-64c9a6d7f81so8052105d50.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 22:55:27 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV+GemXJFK20AWiUdbR4NmE2ZHYxA2MgHXSeeBKYh63bhi0tt0UqmjhUPI+5WvzvIzhBWHKw2/GCQ==@kvack.org
X-Gm-Message-State: AOJu0Ywpxt8J2IvYT9igdlEEwqzc3mLWD1c/d7Qg90GRAGMtuN6pnoQX
	kSTPxfchwubHQvygXQZLL2CaiNb/lejc59i3IGD1R7PaGmTIrZjOrh1vC2nK5BmQJEuI6Jq3r9f
	aIM+XUapaNtLTHQInOFTvGHKEI8RG09Hosmq5+GPC3Q==
X-Received: by 2002:a53:ee57:0:b0:64c:f4fa:4030 with SMTP id
 956f58d0204a3-64d14147f3emr933485d50.25.1772780126658; Thu, 05 Mar 2026
 22:55:26 -0800 (PST)
MIME-Version: 1.0
References: <20260306024608.1720991-1-youngjun.park@lge.com>
In-Reply-To: <20260306024608.1720991-1-youngjun.park@lge.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 5 Mar 2026 22:55:15 -0800
X-Gmail-Original-Message-ID: <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
X-Gm-Features: AaiRm52ieeZPwVrniCvpmKfN24wjM0j1i-6iz_fJBunHQl3H8TI9XOCSfg6Tl1U
Message-ID: <CACePvbXVvPp_a89UFztZo5nGawpFea9t=NRisf468VcxHgkX7A@mail.gmail.com>
Subject: Re: [RFC PATCH v2] mm/swap, PM: hibernate: hold swap device reference
 across swap operation
To: Youngjun Park <youngjun.park@lge.com>
Cc: rafael@kernel.org, akpm@linux-foundation.org, kasong@tencent.com, 
	pavel@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, usama.arif@linux.dev, 
	linux-pm@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6498540009
X-Stat-Signature: eipoj98m85hg9hbpgacqy9minnq9dwzr
X-Rspam-User: 
X-HE-Tag: 1772780128-731954
X-HE-Meta: U2FsdGVkX19QvvP9D2BylkYzsePHszpOUuPp/FWiQNcKgOWkGY7nRqER8Q1FdeaujiSkRFpWMl2P2FisAVQwXQd8tYyXrRFMYvMLz86NBbWVZjmKr5E2yHMs4TCqGOpGZjZ//JvWbXfM2HDb0e+lAfXb+0xIjBxpRAOsc7oTcWjtYqmYtmibS6Ie00+qx/swsRtbn9d+Ry4Noi91WcsrDwMeHtJsOHFuXVtnrNn1Er1IwZJ0sA3aoMBfkdeb9Q4WnSwVlZfwKEvWdtTH5eEY0L7ueEjUQ/KCrTvl/kN8Q6q50pXWN9ZBb3MKeESIjZbmcxZM67P6iQxZue6zQk2IKlJPDq88K9/GODIBYXKJycOYRjKRaWSiMCjFDjzRhTgDoSysrVhC4VGOw/wfQHyYRkVIwgft9TuAyr2O7WvvDvETt3zS8HLfFDVOAYFF11BjMgwjEeAXDrO3SWiCDJ+BydlJzG1Lnk6TRmXSqcZO0EeNMC6zUoaShtCR5isa7voFFDE7l0BEXsTRcNYLhbdkoyBtnFbg2oEVywZ9pXZLC2YZX/wc3/bAuWavQyzG0LNyRuDQythv9sWhA55Xktp5RDBJE/2CqS9rMAZe+c7ms5SfOqGuT/JBk8aq1qZNcWHp2PHMx2iOFtvL5hDjE7jD3INSNbW4DTeXZEHcC71GrwOy+ae83S6kiCpmhz6t7pDeNM7n58T1KYv0xauTlhkPLCPz0ZG8XqqaNisCE/3Cult5PCb6tGWusq1ZhughXsSXQncIkY/VTZJUnaR2gpK6CoJmRnul/GwdnOQsIORebHa0e/9MZjl0/4aEPUh3cnRYVOMpowiwAoyh3gI25SFimkpCdJd2sVoxI+mUFJRR1rpO/0/Yr/QI1HbkivKlc0tcUcgkw1bfq5qjx0pIzjcgpKSo3K9DOqkecAIA1FlvdV8YfI6HUesQ6VZzB4AoS9NDQrk0+9lf6tskM9GCyft
 gB+Ig+Kw
 pOimoBWGr5Lin1icSEWCjNxF2MGUJHw+aaQpHovOUlJMY162h2s+bFUCOOHqvYZEdmKW0sfmMR6knameJRfU1Du1hpnKNgDQGl/nt1FnfEg5XD8Eb1H1c2Xt3BURnLWmzdfIfMaBsjqIO2CF/QF+LNFnwS16NGVaiUEs74kftQNZTq6TT0565S4bjjCfMv5dL10HfKtAOXMrOj2nxMmBsyMK7m6qmH9gFJ3VdGUnY+1xlkRuFYL2s3HHxT8TF/nUYnSa/mHwU7enJL7UG+0MG0RLncly+rVV/n2jNy6iNb9dhp3dBrvhFYYsA2Nrc7CXsEfLeIa0XL54YI54=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 5, 2026 at 6:46=E2=80=AFPM Youngjun Park <youngjun.park@lge.com=
> wrote:
>
> Currently, in the uswsusp path, only the swap type value is retrieved at
> lookup time without holding a reference. If swapoff races after the type
> is acquired, subsequent slot allocations operate on a stale swap device.

Just from you above description, I am not sure how the bug is actually
triggered yet. That sounds possible. I want more detail.

Can you show me which code path triggered this bug?
e.g. Thread A wants to suspend, with this back trace call graph.
Then in this function foo() A grabs the swap device without holding a refer=
ence.
Meanwhile, thread B is performing a swap off while A is at function foo().

> Additionally, grabbing and releasing the swap device reference on every
> slot allocation is inefficient across the entire hibernation swap path.

If the swap entry is already allocated by the suspend code on that
swap device, the follow up allocation does not need to grab the
reference again because the swap device's swapped count will not drop
to zero until resume.

> Address these issues by holding the swap device reference from the point
> the swap device is looked up, and releasing it once at each exit path.
> This ensures the device remains valid throughout the operation and
> removes the overhead of per-slot reference counting.

I want to understand how to trigger the buggy code path first. It
might be obvious to you. It is not obvious to me yet.

> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> ---
> Hi,
>
> This is a simple RFC quality patch to verify if this approach is suitable=
.
> Per Usama Arif's feedback regarding git bisectability,
> I have squashed the previous commits into this single patch.
>
> base-commit: ec96cb7e4c12ff5b474cf9ab66f2e9767953e448 (mm-new)
>
> RFC v1: https://lore.kernel.org/linux-mm/20260305202413.1888499-1-usama.a=
rif@linux.dev/T/#m3693d45180f14f441b6951984f4b4bfd90ec0c9d
>
>  include/linux/swap.h |  1 +
>  kernel/power/swap.c  | 12 +++++++---
>  kernel/power/user.c  |  9 +++++++-
>  mm/swapfile.c        | 55 ++++++++++++++++++++++----------------------
>  4 files changed, 45 insertions(+), 32 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 7a09df6977a5..37bf7cf21594 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -442,6 +442,7 @@ extern bool swap_entry_swapped(struct swap_info_struc=
t *si, swp_entry_t entry);
>  extern int swp_swapcount(swp_entry_t entry);
>  struct backing_dev_info;
>  extern struct swap_info_struct *get_swap_device(swp_entry_t entry);
> +extern void put_swap_device_by_type(int type);
>  sector_t swap_folio_sector(struct folio *folio);
>
>  /*
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index 2e64869bb5a0..c230b0fa5a5f 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -350,9 +350,10 @@ static int swsusp_swap_check(void)
>
>         hib_resume_bdev_file =3D bdev_file_open_by_dev(swsusp_resume_devi=
ce,
>                         BLK_OPEN_WRITE, NULL, NULL);
> -       if (IS_ERR(hib_resume_bdev_file))
> +       if (IS_ERR(hib_resume_bdev_file)) {
> +               put_swap_device_by_type(root_swap);
>                 return PTR_ERR(hib_resume_bdev_file);
> -
> +       }
>         return 0;
>  }
>
> @@ -418,6 +419,7 @@ static int get_swap_writer(struct swap_map_handle *ha=
ndle)
>  err_rel:
>         release_swap_writer(handle);
>  err_close:
> +       put_swap_device_by_type(root_swap);
>         swsusp_close();
>         return ret;
>  }
> @@ -480,8 +482,11 @@ static int swap_writer_finish(struct swap_map_handle=
 *handle,
>                 flush_swap_writer(handle);
>         }
>
> -       if (error)
> +       if (error) {
>                 free_all_swap_pages(root_swap);
> +               put_swap_device_by_type(root_swap);
> +       }
> +
>         release_swap_writer(handle);
>         swsusp_close();
>
> @@ -1647,6 +1652,7 @@ int swsusp_unmark(void)
>          * We just returned from suspend, we don't need the image any mor=
e.
>          */
>         free_all_swap_pages(root_swap);
> +       put_swap_device_by_type(root_swap);
>
>         return error;
>  }
> diff --git a/kernel/power/user.c b/kernel/power/user.c
> index 4401cfe26e5c..9cb6c24d49ea 100644
> --- a/kernel/power/user.c
> +++ b/kernel/power/user.c
> @@ -90,8 +90,11 @@ static int snapshot_open(struct inode *inode, struct f=
ile *filp)
>                         data->free_bitmaps =3D !error;
>                 }
>         }
> -       if (error)
> +       if (error) {
>                 hibernate_release();
> +               if (data->swap >=3D 0)
> +                       put_swap_device_by_type(data->swap);
> +       }
>
>         data->frozen =3D false;
>         data->ready =3D false;
> @@ -115,6 +118,8 @@ static int snapshot_release(struct inode *inode, stru=
ct file *filp)
>         data =3D filp->private_data;
>         data->dev =3D 0;
>         free_all_swap_pages(data->swap);
> +       if (data->swap >=3D 0)
> +               put_swap_device_by_type(data->swap);
>         if (data->frozen) {
>                 pm_restore_gfp_mask();
>                 free_basic_memory_bitmaps();
> @@ -235,6 +240,8 @@ static int snapshot_set_swap_area(struct snapshot_dat=
a *data,
>                 offset =3D swap_area.offset;
>         }
>
> +       if (data->swap >=3D 0)
> +               put_swap_device_by_type(data->swap);
>         /*
>          * User space encodes device types as two-byte values,
>          * so we need to recode them
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 915bc93964db..f505dd1f7571 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1860,6 +1860,10 @@ struct swap_info_struct *get_swap_device(swp_entry=
_t entry)
>         return NULL;
>  }
>
> +void put_swap_device_by_type(int type)
> +{
> +       percpu_ref_put(&swap_info[type]->users);
> +}
>  /*
>   * Free a set of swap slots after their swap count dropped to zero, or w=
ill be
>   * zero after putting the last ref (saves one __swap_cluster_put_entry c=
all).
> @@ -2085,30 +2089,28 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>                 goto fail;
>
>         /* This is called for allocating swap entry, not cache */
> -       if (get_swap_device_info(si)) {
> -               if (si->flags & SWP_WRITEOK) {
> -                       /*
> -                        * Try the local cluster first if it matches the =
device. If
> -                        * not, try grab a new cluster and override local=
 cluster.
> -                        */
> -                       local_lock(&percpu_swap_cluster.lock);
> -                       pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0=
]);
> -                       pcp_offset =3D this_cpu_read(percpu_swap_cluster.=
offset[0]);
> -                       if (pcp_si =3D=3D si && pcp_offset) {
> -                               ci =3D swap_cluster_lock(si, pcp_offset);
> -                               if (cluster_is_usable(ci, 0))
> -                                       offset =3D alloc_swap_scan_cluste=
r(si, ci, NULL, pcp_offset);
> -                               else
> -                                       swap_cluster_unlock(ci);
> -                       }
> -                       if (!offset)
> -                               offset =3D cluster_alloc_swap_entry(si, N=
ULL);
> -                       local_unlock(&percpu_swap_cluster.lock);
> -                       if (offset)
> -                               entry =3D swp_entry(si->type, offset);
> +       if (si->flags & SWP_WRITEOK) {
> +               /*
> +                * Try the local cluster first if it matches the device. =
If
> +                * not, try grab a new cluster and override local cluster=
.
> +                */
> +               local_lock(&percpu_swap_cluster.lock);
> +               pcp_si =3D this_cpu_read(percpu_swap_cluster.si[0]);
> +               pcp_offset =3D this_cpu_read(percpu_swap_cluster.offset[0=
]);
> +               if (pcp_si =3D=3D si && pcp_offset) {
> +                       ci =3D swap_cluster_lock(si, pcp_offset);
> +                       if (cluster_is_usable(ci, 0))
> +                               offset =3D alloc_swap_scan_cluster(si, ci=
, NULL, pcp_offset);
> +                       else
> +                               swap_cluster_unlock(ci);
>                 }
> -               put_swap_device(si);
> +               if (!offset)
> +                       offset =3D cluster_alloc_swap_entry(si, NULL);
> +               local_unlock(&percpu_swap_cluster.lock);
> +               if (offset)
> +                       entry =3D swp_entry(si->type, offset);
>         }
> +
>  fail:
>         return entry;
>  }
> @@ -2116,14 +2118,10 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>  /* Free a slot allocated by swap_alloc_hibernation_slot */
>  void swap_free_hibernation_slot(swp_entry_t entry)
>  {
> -       struct swap_info_struct *si;
> +       struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>         struct swap_cluster_info *ci;
>         pgoff_t offset =3D swp_offset(entry);
>
> -       si =3D get_swap_device(entry);
> -       if (WARN_ON(!si))
> -               return;
> -
>         ci =3D swap_cluster_lock(si, offset);
>         __swap_cluster_put_entry(ci, offset % SWAPFILE_CLUSTER);
>         __swap_cluster_free_entries(si, ci, offset % SWAPFILE_CLUSTER, 1)=
;
> @@ -2131,7 +2129,6 @@ void swap_free_hibernation_slot(swp_entry_t entry)
>
>         /* In theory readahead might add it to the swap cache by accident=
 */
>         __try_to_reclaim_swap(si, offset, TTRS_ANYWAY);
> -       put_swap_device(si);
>  }
>
>  /*
> @@ -2160,6 +2157,7 @@ int swap_type_of(dev_t device, sector_t offset)
>                         struct swap_extent *se =3D first_se(sis);
>
>                         if (se->start_block =3D=3D offset) {
> +                               get_swap_device_info(sis);

The function name swap_type_of() does not suggest that the function
should take a reference.  This is just about function naming. I am not
commenting on the function logic yet.

>                                 spin_unlock(&swap_lock);
>                                 return type;
>                         }
> @@ -2180,6 +2178,7 @@ int find_first_swap(dev_t *device)
>                 if (!(sis->flags & SWP_WRITEOK))
>                         continue;
>                 *device =3D sis->bdev->bd_dev;
> +               get_swap_device_info(sis);
You might consider moving this one line up.The typical usage pattern
is get the reference then operate on the stuff protected by the
reference count. Here the order does not really matter due to the
swap_lock protection.

Waiting for details on how to trigger the bug.

Chris

