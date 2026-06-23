Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C626CCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 19:02:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D5F6B0088; Tue, 23 Jun 2026 15:02:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE6C6B008A; Tue, 23 Jun 2026 15:02:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D37A6B008C; Tue, 23 Jun 2026 15:02:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 679EA6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:02:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB0691A05BC
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:02:05 +0000 (UTC)
X-FDA: 84912097410.19.D8BBF4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id C77964000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:02:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgWyZwwj;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782241323;
	b=bV4kgkvoc+LgA0wKwLe1++wXKehxRWCYqFp4agW8sxhheFCM672QfN9qMZtWQviK/HXsmU
	XURCMPIhgSvIo4XDZ/cH0mpbBkIzhHLLXZWEb1KFCVlGidXsdundT2X5gPpEfifLZ1eLDf
	ALvEsLklYtKh/v5XIv2V57oqtA82Ojk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782241323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0u6nVtK/qnX+X7yL0jwUT2bDPnwgnxx/Mcp9KbGIeI=;
	b=OFmq8FWg4kFFfr6SGCqfB4+V9018yotPgr6rs5Excg6WThRKq5owlDFS9Lj4DbvUn1wRWg
	mR9dOThhVjeEkUkmid0IvvQp9SHrQUTJJMDj2W0x2uEC5iSIQhabqhnHMVk0aS/3L1drxa
	jhEkEQnPJWJHei7XEdNTCFdbhbQEBiU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgWyZwwj;
	spf=pass (imf12.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 235D260126
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF5D1F00ADF
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782241322;
	bh=y0u6nVtK/qnX+X7yL0jwUT2bDPnwgnxx/Mcp9KbGIeI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WgWyZwwjocbxiwbsfkw8IuWztr3YfbY15fMNWJ37Z23Zkc7NA3jpaSd6zhxlIZL9M
	 jJB7MsNwc6ThiBC8POBmIPCXfLrjXjmIJPQhSQsD9P1oAVfRdjhTSVqH0YH4nCcQCX
	 i1U9uIr2DASjbrmOiZnWsqsHC6BVfRbGGX/e+NdUhcjNOtuqKZIn/uc3HePQnl2lc9
	 r2T3pr1VY5JZ+70JLDNHb6HCVrksr+7t1JaB67WVdOCOmxwXr8KUqKbgFx1jDuUa2i
	 ouFqMOZBhIuH4DBBrSDfSOh0wHXX7gJzVhT37l2Gpf4aAD//rsWDDkVIKxVriUUDGs
	 evQw5R0Dfrc/g==
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-697bd21fdc2so294335a12.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:02:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/zjRJHgfeEmSU6QN7a9GtmyFr6te6UX9Q5AUQUpjGuXxtVoNq+75zKw7Ntc6DKARDfBclwyO7+eg==@kvack.org
X-Gm-Message-State: AOJu0YykzydVax9vAWdsMNQ4MvQjtONrxbzrwZktAo8tQCaQlJBO7P+h
	knIhTMlQnlWJti3ECLIo0K6SwFMP8KhsniaRo4ZJ75IPbmojIDm6VVgXo4rinHB/22Y0kh+JZj6
	dar8lUoydSvRggLEtqsZvOL+ox7M6X+c=
X-Received: by 2002:a17:906:9fc5:b0:c06:1310:21cc with SMTP id
 a640c23a62f3a-c09901dce24mr1220373466b.47.1782241321011; Tue, 23 Jun 2026
 12:02:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-4-nphamcs@gmail.com>
In-Reply-To: <20260612193738.2183968-4-nphamcs@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 23 Jun 2026 12:01:49 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPXk2eRbVcEMQDTCH1j-w241h189=p04FenAfKAjkkQtA@mail.gmail.com>
X-Gm-Features: AVVi8CeMEsmSPhPPFsXFa4O7MYG4Joyu2sWMWrZwPnhH3H9VtouH8kf4mAa2ZTQ
Message-ID: <CAO9r8zPXk2eRbVcEMQDTCH1j-w241h189=p04FenAfKAjkkQtA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/7] mm, swap: support physical swap as a vswap backend
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C77964000B
X-Stat-Signature: 6rcebth61mmtponh1ikq8w61f9jfobgr
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782241323-495486
X-HE-Meta: U2FsdGVkX183m1EMmBACoobvC69tRgE54TKgFqJnu/6F/3negRiuo6eCTrrtiF/E+CrKqFwQHnm9IATOVoLSobZw7KAVqTABG92A75LTdXXrNmYVpcnNL/PbNRigZk0E8TdKQgEY2CFRu17dDRB/vHqPa8VYftRhdnap0ZpiPAJQ5qjf60s7gGDnpV6jzRj9Tz9Psbn836Vml7jCgIc0goZs39tcjMwNjFvWM3dc1jVemkTRKX8pvEs6DB0G08vWKg23SelA21LGpcCuLxcVj3QZtoZ+RRnwBOvzoZg6MieQuHjOkp/lETHCACiA2l8yjAZwpbQYy1MMWqk0gjEesRp+/Wl1pMV+0uvDwutm0NKnvmwEV9+HKwX49NCrK0oCZiybeQD3eSCzZJ2T4PqFAHWZzDTVmpm4NpWNO7O7JbXO6DH+s0JGaWBeomrfm28pW2pXgq2RfANKgWgjinRaxNesUToPE0XWVjP2/af67N52T3mUhl/V6vxrfd+jw2w/S5jyhgOWZfaC98TYpnQCuQlcBhu1BGes2cge9lZ5acFGfgZLozdAovRYoN62Y5dTWKfXcp8vPAjvNUCWk+rmm3lBYcEMxzRFYkSs6gPTdYy9miWkwbyacDu1AuYRBDrJBoijW3WuiuAFes8v9c4vKnukZMFp1RxloeqDHQERUtvfV5wnarKiddSpqr8NUBp0ogeBOVmToblKRmcgRqWP605RsdgPgdhbSIPvsakmglPzvrtbEsdLWvMXF+7etKMLmY21oacHsN1uDv7qnbPnqkDDB059Lnh3AnuyUWRsCylJYzg79pVit2QPCuZCmS5ygFSUlt2GXRlzz2S1nvWuPVafxHmfcynMHcwVW0evzjP+f9VrXHDlzQw0pzrBBolwhr1To63j3inhmjA4GDdJOS0vcjZN7Dd+grYvcJ2Wu16/J48GbdT9VsT4ATJaK6tj1fTHDRLTA9vD+ShSBwt
 rhQwddM+
 hFJqFAOjQ283gn6GeAOenV8RzyaBExKZfH1dfROQVi+IQkjLkPXYBhnQOX7F73dkSPcWLY/NXRsh5GhDs8jzeSAJXi1+j/QXi4ixxUKnWnNGwmo0rt1UYK0MZJ1GbTArVwINf6sTUGFXrIF1Zjfg51UwarXM6JW4FQGjPEZjY6vlbj6bxanpt6tDpmtSMm9syaKijABX72FKSP751ORR/DQI9oON29qr8gfCJBZbs1K3+s0YdbZLvQXoe8wC4sOBs8aphy6sODzdh22940yYFp0VePE4iuBoXKYYP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 466f8a182716..5daff7a25f67 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -993,6 +993,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>         struct folio *folio;
>         struct mempolicy *mpol;
>         struct swap_info_struct *si;
> +       swp_entry_t phys = {};
>         int ret = 0;
>
>         /* try to allocate swap cache folio */
> @@ -1000,16 +1001,6 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>         if (!si)
>                 return -EEXIST;
>
> -       /*
> -        * Vswap entries have no physical backing - writeback would fail
> -        * and SIGBUS the caller. Bail before we waste a swap-cache folio
> -        * allocation.
> -        */
> -       if (si->flags & SWP_VSWAP) {
> -               put_swap_device(si);
> -               return -EINVAL;
> -       }
> -
>         mpol = get_task_policy(current);
>         folio = swap_cache_alloc_folio(swpentry, GFP_KERNEL, BIT(0), NULL, mpol,
>                                        NO_INTERLEAVE_INDEX);
> @@ -1028,40 +1019,78 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>         /*
>          * folio is locked, and the swapcache is now secured against
>          * concurrent swapping to and from the slot, and concurrent
> -        * swapoff so we can safely dereference the zswap tree here.
> -        * Verify that the swap entry hasn't been invalidated and recycled
> -        * behind our backs, to avoid overwriting a new swap folio with
> -        * old compressed data. Only when this is successful can the entry
> -        * be dereferenced.
> +        * swapoff so we can safely dereference the zswap tree (or vswap
> +        * vtable) here. Verify that the swap entry hasn't been
> +        * invalidated and recycled behind our backs, to avoid overwriting
> +        * a new swap folio with old compressed data. Only when this is
> +        * successful can the entry be dereferenced.
>          */
> -       tree = swap_zswap_tree(swpentry);
> -       if (entry != xa_load(tree, offset)) {
> -               ret = -ENOMEM;
> -               goto out;
> +       if (swap_is_vswap(si)) {
> +               if (entry != vswap_zswap_load(swpentry)) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }
> +               /*
> +                * Allocate physical backing BEFORE decompress - if it fails,
> +                * no wasted work. folio_realloc_swap sets vtable to PHYS,
> +                * overwriting ZSWAP - the old entry pointer is only held
> +                * by the caller now.
> +                */
> +               phys = folio_realloc_swap(folio);
> +               if (!phys.val) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }
> +       } else {
> +               tree = swap_zswap_tree(swpentry);
> +               if (entry != xa_load(tree, offset)) {
> +                       ret = -ENOMEM;
> +                       goto out;
> +               }

There's a lot of divergence in the code (in this patch and previous
ones). Seems like a lot of it is to do xarray operations vs vswap
operations. I wonder if we can abstract these into helpers, e.g.
zswap_tree_store(), zswap_tree_load(), etc. Maybe the name is not the
best, but you get the point :)

Here we can then do zswap_tree_load() for both code paths and only the
folio_realloc_swap() needs to be different for vswap. We can do
similar cleanups for the load/store paths as well.

>         }
>
>         if (!zswap_decompress(entry, folio)) {
>                 ret = -EIO;
> +               /*
> +                * For vswap: folio_realloc_swap already moved the entry
> +                * out of the vtable. Restore it via vswap_zswap_store so
> +                * the entry stays tracked (and the just-allocated PHYS
> +                * slot is freed). For non-vswap: entry is still in the
> +                * zswap tree.
> +                */
> +               if (swap_is_vswap(si) && phys.val)
> +                       vswap_zswap_store(swpentry, entry);

Should this go in the cleanup path instead (i.e. in the 'out' label?).

>                 goto out;
>         }
>
> -       xa_erase(tree, offset);
> +       if (!swap_is_vswap(si))
> +               xa_erase(tree, offset);

Maybe this can also be abstracted into a helper, but I wonder what the
corresponding vswap operation would be. I think folio_realloc_swap()
will have already "erased" the zswap entry from vswap. Maybe have a
vswap helper that will only remove it if it's a zswap entry? We can
probably do a lockless check first to make it cheap?

It's probably silly to do this, and maybe there's a better way.
Generally, I think the code would be easier to follow if we abstract
away the xarray vs. vswap stuff into helpers (where it's reasonable).

>
>         count_vm_event(ZSWPWB);
>         if (entry->objcg)
>                 count_objcg_events(entry->objcg, ZSWPWB, 1);
>
> -       zswap_entry_free(entry);
> -
>         /* folio is up to date */
>         folio_mark_uptodate(folio);
>
>         /* move it to the tail of the inactive list after end_writeback */
>         folio_set_reclaim(folio);
>
> -       /* start writeback */
> -       ret = __swap_writepage(folio, NULL);
> -       WARN_ON_ONCE(ret);
> +       /*
> +        * Start writeback. __swap_writepage_phys is void; __swap_writepage
> +        * returns 0 today (async IO errors surface in the bio end_io
> +        * callback). Either way the entry has been moved out of its prior
> +        * location (vtable PHYS for vswap, removed from tree otherwise),
> +        * so we own the free.
> +        */
> +       if (swap_is_vswap(si)) {
> +               __swap_writepage_phys(folio, NULL, phys);
> +       } else {
> +               ret = __swap_writepage(folio, NULL);
> +               WARN_ON_ONCE(ret);
> +       }
> +
> +       zswap_entry_free(entry);
>
>  out:
>         if (ret) {
> @@ -1212,6 +1241,18 @@ static unsigned long zswap_shrinker_count(struct shrinker *shrinker,
>         if (!zswap_shrinker_enabled || !mem_cgroup_zswap_writeback_enabled(memcg))
>                 return 0;
>
> +       /*
> +        * With CONFIG_VSWAP, vswap-backed zswap entries need a physical
> +        * swap slot allocated on demand (via folio_realloc_swap) for
> +        * writeback. If no physical slots are available, writeback will
> +        * fail - skip the shrinker to avoid spinning on entries we cannot
> +        * drain. Vanilla zswap-on-swapfile is unaffected because every
> +        * zswap entry already has a backing slot; gate on CONFIG_VSWAP so
> +        * the check compiles out there.
> +        */
> +       if (IS_ENABLED(CONFIG_VSWAP) && !get_nr_swap_pages())
> +               return 0;
> +
>         /*
>          * The shrinker resumes swap writeback, which will enter block
>          * and may enter fs. XXX: Harmonize with vmscan.c __GFP_FS
> @@ -1558,7 +1599,7 @@ bool zswap_store(struct folio *folio)
>          * writeback could overwrite the new data in the swapfile.
>          */
>         if (partial_store && is_vswap_entry(swp))
> -               folio_release_vswap_backing(folio);
> +               folio_release_non_phys_swap_backing(folio);
>         else if (!ret && !is_vswap_entry(swp)) {
>                 unsigned type = swp_type(swp);
>                 pgoff_t offset = swp_offset(swp);
> --
> 2.53.0-Meta
>

