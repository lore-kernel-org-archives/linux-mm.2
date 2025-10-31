Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337A3CCFA02
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 17:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 707F48E0124; Fri, 31 Oct 2025 13:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DFF58E0121; Fri, 31 Oct 2025 13:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D1D8E0124; Fri, 31 Oct 2025 13:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D9918E0121
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 13:45:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D207F1A05AE
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:45:55 +0000 (UTC)
X-FDA: 84059137470.15.A426FBB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0214A0015
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:45:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mm/enWZA";
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761932754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhoQWpvolO9UzIYaw1w/vQ2jhQxqjKsuZQ7Kmxhov9U=;
	b=e4Vw5VY1x/wyap7/qlEV34ad5lh4LaBzD/530A0/AHKGqrfsgmRwHl1siSrham/sj5ZmIL
	Dha6aAzHmVeo+rh1n1u29yUo4cp2HS5ndSjcIaBqv1vga0XdqjQaEwoPuJ6NNdAwf19439
	NOyYlEanV1sFoAdF/Owjp3hgobVmyEo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mm/enWZA";
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761932754; a=rsa-sha256;
	cv=none;
	b=rCadpmlnVcF6Mc2Owqzz0oIzpgxxHaAF9jOnmOtC9kyIoqJSLg6MycUxD57CKj3yKfl6ts
	tnwH36c+JAsMZ0wL3izBxHG39F8e/8TsWQv8hgIbt7MvdAWLs0zYwT+w9reYIaDWo9iKrg
	qk4lgUPFsGKYHVChXEc0DRnWZ7pWt7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6389C601AC
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16647C116C6
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 17:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761932753;
	bh=8Z5thQC+rZDV7YQzns00IgbOSJUd9ppvWPw+j4n6pWM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Mm/enWZAWMDexVX/fM2kYROrmhHpBdzm8nbycEeWDHnO8PA6XXIyNOcJjSWX8bZqn
	 2OdmViUgwKEHTRFYwD5BgZE10XvwxitQi0+ZD61Nzq8aRrVN2lMfT03tG+dKxr1NYQ
	 K92snLHJa+AlDf0mSJvP6DfsWKAU1JkCDOWJF4f6IdAMKIjiKHTH1OLq/3cbELc3DJ
	 wvZCVb1xLk7serWJIZ67u1/RPAd2BS9tZe3GOIFRxb/9dGq4FBY/c/d2Sdm4UkrBLG
	 jF4OR3sbBwvEi1O9WI/OFg/DyDSuQWE5/dryDqJh6Zs3mEygo8hMwQ1rtwsGhBg/iR
	 /i9CZ8dqZ4bkg==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-786572c14e3so5321667b3.2
        for <linux-mm@kvack.org>; Fri, 31 Oct 2025 10:45:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YybdvXK5Y6tzan9gxQ8nP8mkA7NFv2XHJc8P7bf5qPLCoj+vDvu
	ijDTOxEbs6RD7h20MwYM2fcdom8B3DgHGbeR9PbzJx5twZfUJrGz3tWQJUJNtaluzcejzYWedaE
	pgJoE6STRmHSjKLXiJmye+tBbaGF7mCT09VZrV5HZ7Q==
X-Google-Smtp-Source: AGHT+IFqrgTBfMBmVRiXWO3Rn5PwN2T0UvwtVFKxReo6CBC7EejYTOkW7+aB0EyRLa858pu/9lZjhalDMoVSb2xP8ow=
X-Received: by 2002:a05:690c:dd5:b0:785:bfd8:c4c6 with SMTP id
 00721157ae682-78648526568mr44021407b3.49.1761932752205; Fri, 31 Oct 2025
 10:45:52 -0700 (PDT)
MIME-Version: 1.0
References: <20251024-swap-clean-after-swap-table-p1-v2-0-c5b0e1092927@tencent.com>
 <20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com>
In-Reply-To: <20251024-swap-clean-after-swap-table-p1-v2-1-c5b0e1092927@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 31 Oct 2025 10:45:40 -0700
X-Gmail-Original-Message-ID: <CACePvbVEaRzFet1_PcRP32MUcDs9M+5-Ssw04dYbLUCgMygBZw@mail.gmail.com>
X-Gm-Features: AWmQ_bkBLbpzK-7LQwl8d_11rWtB-YUCktamd5vXceO5ofoa6GX9KxB-9BfXeC4
Message-ID: <CACePvbVEaRzFet1_PcRP32MUcDs9M+5-Ssw04dYbLUCgMygBZw@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] mm, swap: do not perform synchronous discard
 during allocation
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Ying Huang <ying.huang@linux.alibaba.com>, 
	YoungJun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j6gbx7ama5f5bg55pou9dbip8kxz8d8o
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0214A0015
X-HE-Tag: 1761932753-267332
X-HE-Meta: U2FsdGVkX1+kdcSImkOXzwchnPMtcMGm/ldMqNP41NtHCrrdBW4V7CBpWA5s6Y5wPVgodN7KAl0LhJwvERvuDexqVLmd9SucSR6akXJf1pyzqMM+wDG75/ZsO33VGVW6G9wMFC+ory0klDd+CfKV5HeMzkNjyeY6SgpszjpYJkqQFmvYx09T0euO9DogADLTAZjymC37p50qpHMagvSwN9XnisFDu0kpBhePLJQr77cVph7XcNsON4a3fcbaRzWNly8lnzZ0ufZsyaCC7+zbJ2X3QhldSIBAhKlkjoeHfDwXfir0J0ZNrNMFTbz5wh9fPGLM8WfkZdgy9LqCfeQCJMHQv+7oo0axGruTXjNA8kGH6TEcp5CLIJimlTum2pSJXPn43ixg5QtufD4FTnSzB3AOFzluiyITg++2ACJF+bY39HOwQOu3jH/XQP88cfgq4ItFMTAUUarC/1lr5qezdgcJ/opsQ+UuogTGexQmvmq9EzxcBkU8gq2BmLN14BObaWD4X+V/Y7cB/yOqnNlZRi+onOw7hPX5RVPtqy393nVF8ElYNnRQZiNDfjOvuipFMFwdeDB2UVsbu5CS68k4cuArNWqsIet/NmAxx2dOOc6UNKCq685sEfv95zBpawZ1CVNVTIYuV5qsY/aIynHZ1xzt8zUz0OyxBI+aUc5IOVScyrJgLdpZ6MI7HybAYCQnCBN/y8aba9vTJQ9+7ehst2UxWpkV2sOqseq+ZZs4U4RNbhqsA92S0wxt+fnyOWEBcxbN5rrSDMGhQKi+YD590eJpoTLFapdTtpA7JzJwRQk1Tc47mZKAZqwZVNQYulcc+aHf1tW1e1DZGqDJPR7qTUUuHoGqWu7L3TwQ9E5sliMHuYOpnd3IU3BHDuhPsXsMiLGZj3ev5pMcVpvOc6uWMfDNMOSkMGMprdTIqhB6r5z1rOSG05Yd6iJSgVvtuNRURz03U35VwnACixMs5G2
 IcgghioP
 bQFPbWvRhg/23TR6kE9akk/33QvKlmpd05pyIEcyAqkOnM4spONBE+O1hHxEDZUEWsO+FXN762SDzG45ttY5FRHeDeIQerk33P/7On1mT/jSvh8yOh42s6tZKPDEIlarbla5BZT3MSWABqoSMlKJ6ZV3EeaTCHmuvDp59e0ruNFNk69EcRLY8dYQG2qbujLMIzgtOzx8eAW9VZQhme/VneSzA7wsGhXm9sec7+JFsRSUduAjt4uIgCpkAXfPySa9ENPfmicHnDrWlIaBlYxZLPJJ8ArFDKplcNdvHcSTwl7xYJqKXOCPr9qq688TQIX0aeuFIHdyIrOFqynmLVjDtRCkdSZtfmavBD6JN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 11:34=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> From: Kairui Song <kasong@tencent.com>
>
> Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
> fast path"), swap allocation is protected by a local lock, which means
> we can't do any sleeping calls during allocation.
>
> However, the discard routine is not taken well care of. When the swap
> allocator failed to find any usable cluster, it would look at the
> pending discard cluster and try to issue some blocking discards. It may
> not necessarily sleep, but the cond_resched at the bio layer indicates
> this is wrong when combined with a local lock. And the bio GFP flag used
> for discard bio is also wrong (not atomic).
>
> It's arguable whether this synchronous discard is helpful at all. In
> most cases, the async discard is good enough. And the swap allocator is
> doing very differently at organizing the clusters since the recent
> change, so it is very rare to see discard clusters piling up.
>
> So far, no issues have been observed or reported with typical SSD setups
> under months of high pressure. This issue was found during my code
> review. But by hacking the kernel a bit: adding a mdelay(500) in the
> async discard path, this issue will be observable with WARNING triggered
> by the wrong GFP and cond_resched in the bio layer for debug builds.
>
> So now let's apply a hotfix for this issue: remove the synchronous
> discard in the swap allocation path. And when order 0 is failing with
> all cluster list drained on all swap devices, try to do a discard
> following the swap device priority list. If any discards released some
> cluster, try the allocation again. This way, we can still avoid OOM due
> to swap failure if the hardware is very slow and memory pressure is
> extremely high.
>
> This may cause more fragmentation issues if the discarding hardware is
> really slow. Ideally, we want to discard pending clusters before
> continuing to iterate the fragment cluster lists. This can be
> implemented in a cleaner way if we clean up the device list iteration
> part first.
>
> Cc: stable@vger.kernel.org
> Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast pa=
th")
> Acked-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Acked-by: Chris Li <chrisl@kernel.org>

Chris


> ---
>  mm/swapfile.c | 40 +++++++++++++++++++++++++++++++++-------
>  1 file changed, 33 insertions(+), 7 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index cb2392ed8e0e..33e0bd905c55 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si, int o
>                         goto done;
>         }
>
> -       /*
> -        * We don't have free cluster but have some clusters in discardin=
g,
> -        * do discard now and reclaim them.
> -        */
> -       if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(s=
i))
> -               goto new_cluster;
> -
>         if (order)
>                 goto done;
>
> @@ -1394,6 +1387,33 @@ static bool swap_alloc_slow(swp_entry_t *entry,
>         return false;
>  }
>
> +/*
> + * Discard pending clusters in a synchronized way when under high pressu=
re.
> + * Return: true if any cluster is discarded.
> + */
> +static bool swap_sync_discard(void)
> +{
> +       bool ret =3D false;
> +       int nid =3D numa_node_id();
> +       struct swap_info_struct *si, *next;
> +
> +       spin_lock(&swap_avail_lock);
> +       plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail=
_lists[nid]) {
> +               spin_unlock(&swap_avail_lock);
> +               if (get_swap_device_info(si)) {
> +                       if (si->flags & SWP_PAGE_DISCARD)
> +                               ret =3D swap_do_scheduled_discard(si);
> +                       put_swap_device(si);
> +               }
> +               if (ret)
> +                       return true;
> +               spin_lock(&swap_avail_lock);
> +       }
> +       spin_unlock(&swap_avail_lock);
> +
> +       return false;
> +}
> +
>  /**
>   * folio_alloc_swap - allocate swap space for a folio
>   * @folio: folio we want to move to swap
> @@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio, gfp_t g=
fp)
>                 }
>         }
>
> +again:
>         local_lock(&percpu_swap_cluster.lock);
>         if (!swap_alloc_fast(&entry, order))
>                 swap_alloc_slow(&entry, order);
>         local_unlock(&percpu_swap_cluster.lock);
>
> +       if (unlikely(!order && !entry.val)) {
> +               if (swap_sync_discard())
> +                       goto again;
> +       }
> +
>         /* Need to call this even if allocation failed, for MEMCG_SWAP_FA=
IL. */
>         if (mem_cgroup_try_charge_swap(folio, entry))
>                 goto out_free;
>
> --
> 2.51.0
>

