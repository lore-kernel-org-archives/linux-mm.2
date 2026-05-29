Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89070CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A13A86B00E3; Fri, 29 May 2026 13:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA306B00E5; Fri, 29 May 2026 13:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFEA6B00E7; Fri, 29 May 2026 13:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 833506B00E3
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:33:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A4FD1C0FAB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:33:59 +0000 (UTC)
X-FDA: 84821155398.21.FB7B5BC
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A330100003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:33:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o7HA8gIt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780076037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Y1XcjOHFQ9UlSj3LLvlBTMnTHneWT6yg0YWoIAFOd8=;
	b=gkhJRbDpKlt9lB+mpyeZcCTqZnOs510AseQ/KP1ChpLVMvJjExbztS6jYxs8HRmxIFFaUT
	BcF/b5fBy7M2MeLrHeporupPYxP1wpJd5tJJCZEM+CFpq0U0v7fWtS0m/QIIbPNIt5KoYi
	XyU7twu/eqS2W/+i5LCqdx4xbDKTJuk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=o7HA8gIt;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780076037; a=rsa-sha256;
	cv=pass;
	b=e1I1CiRV988vic2isjvaMDNTwj0NQqdSGd39Ybn3/ftdlh2TQPxvOoY2ttB2Ejtt63bJYO
	priw0AhYUnDFiJFQ1a69nXhg79LkwBaVBgt7tjU75fzkPpIambCQpx7rs96j7syYjpZAHN
	LOy6kd3R+HsztUW0VGBAjOImFfxkKDs=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so23034206a12.1
        for <linux-mm@kvack.org>; Fri, 29 May 2026 10:33:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780076035; cv=none;
        d=google.com; s=arc-20240605;
        b=jtAgHhIFiVbS5ufofr+Nada88Q8llwzh3h6xXiC1ZVxvFnqS+kDXZK8K2Cew8uEjJd
         bHzZLyqs5n2T5RduewtmgI4EHBUKJRjQF+Ic3ErFkCls2HbtWcxr7pdeVtOZzIzP4/hf
         gZWLcAflXIN8bpvMypHsZs9SBX0Udo321MBrvbzVDIl16p0Ebkv51mPu9cy3b0TYxS6Z
         Aob01RM0Mw1Rgqm2UZkMdByVJGvvGGreTJHee3S/u8QwM5oCdS58iiX+Xxzb8YcAHAsT
         8LSiU84Haxt8iWThxhoEz3LWUKnM+TzF4jefV0SiakqzzIjI91NT1AHmeHMLQFuMePeU
         jX+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6Y1XcjOHFQ9UlSj3LLvlBTMnTHneWT6yg0YWoIAFOd8=;
        fh=kuZ9UaZ18SMPFURGYuEBuH/OcTYzrRbMYY2sLmBHzzc=;
        b=fmPwJ1lUkmJnlf/xlMSsLdvf7JjSzVPHheg1QyS/PNDBzGzcwVUnA2kXADaGf/pOBG
         K0i7VE3ubotILnU8TSuWUFrIbR/cXrZWFUaKBJ/fF0OC63oeiZdXfOmIADxC1DyDpkBw
         orUwDVtI0YJAD16jjnz3n8EQ9d2VQ4zoEhTisR+NyhR+qQbzaxPruwTh2TGQyoW5cmCA
         sE59kvfcSMUckbBVb1oo6ve/EYrSUrs/zBaYAuV9nXMkMffIjyfTYfMJgXCkSO8XINIv
         iz95Ab7p1stYd7WrY19A2XqWTmeM3BSFh5wV+oO7wU5GRcUrmFrmx6+4YNaraHaxZ3HC
         8IRw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780076035; x=1780680835; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Y1XcjOHFQ9UlSj3LLvlBTMnTHneWT6yg0YWoIAFOd8=;
        b=o7HA8gItGJIe1s8gN16DHB3akFd0jZZitlAEDHz2OtRjbQxuas6ILaYUEj6Ku8J8xx
         Ga4ThBXUPrtyU41hKLJQnxozTbhH12YNI1z4xMpqfg6W5e88S42MYMQXvSDnNA5pCEoQ
         see7T+qktoFKhpFrLC0qetGKLG08GR9cZCc0/upptD5CyCfWZBIag20EiU/r3JeAXXFf
         Xapaa2b785zs34xaqWiK87thWtF6hwkw4wjh14kb4s9AMCtc3LQ5cPGU1aA7CUgCDuCF
         r/cZOn6J5uDtNDTfFUoDQt93iilBDI8C49ZBpV5z5OSwJp887lypizEMDXtJXn7uaaD/
         yaEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780076035; x=1780680835;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6Y1XcjOHFQ9UlSj3LLvlBTMnTHneWT6yg0YWoIAFOd8=;
        b=bjZUoPdcgExCkfVGqjaZYz1r2FuzyPvL9BhsiNdXHQ66h30hP7kGw1BuvVkxSqAxuX
         lu7PoOQB9z6ay8Z0cUIiX0MqIefYyB50ygMYwnHAc5rcZVIfpqjdnarxJ9yai3lVoX/A
         MvTq9FmvWuGsWg1Twgbthlp0BAjRu/l3rGgvhtt/1TcF3NxyDP0Nu3m+StY/CttSHTf0
         1SnphoH9ny/x1K/U8nirJxo1XQqztap/iEHWDY0kE3lsI6B0A6zP1HnbvO5x6/1n6MN8
         WGoqwE8tFR4VHstQSdjUgzmqwQKTTDYsSK+vXfnSOh4NsHGiPqh4cMXhxFlhxZkth7/Z
         h9eQ==
X-Forwarded-Encrypted: i=1; AFNElJ8aoNkmZ1r95Ct9+OeJsgvIZ1iXsu/E9F+nolfy3vXPl+/uoq0hfYwFYS03dgSsG5S18xLYNcxNDw==@kvack.org
X-Gm-Message-State: AOJu0YxWHE5dCSiEWkXQpcJBI6R/8eeyLtsDRXZ5uicQdYezdCjNcLhC
	QS3ArCt6Hj3H12sfSIIUlIlclsKD6wXyL0Z465GjtzEncQHRoOuafzWQXUPYbNm7DE5xjGKndo2
	aTMT2NZWxOA88S1eisQ+LlnX5Wq6yh8g=
X-Gm-Gg: Acq92OFhsoRodYBOPQb7uKstt2nwl+uYj0wcj3tvsGOt0CFtoiQZ7/CCZeNWEOZjwm2
	X2B8BokZgbbPE8yxZ0qQwcgC8aR2NnoG70jSkvhS67MNEkwocna3BE72XcKKr1scuxUST74wK2v
	uYfNzj/Qmmk5ulFxQGSz0GziPnMSH+6HeMivEHfhfvsc9lLdJbCYVcwy8mCPwoGYS5OPKPssvvX
	KclUEH8pseDXlAYXuz9x6A0fD267mZ/jIHTY/C9lM1muPwRUiwWfU1jTLeDUM8efAtlnmilxD1d
	coQnPCp9MAahMczCAgETes268twZKaTJOpZPFpyCw70CAUYxlC8Ibul/EhptyA==
X-Received: by 2002:aa7:c1c6:0:b0:68b:539c:d269 with SMTP id
 4fb4d7f45d1cf-68c8c56029bmr262541a12.12.1780076035166; Fri, 29 May 2026
 10:33:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260527204757.2544958-1-hannes@cmpxchg.org> <20260527204757.2544958-10-hannes@cmpxchg.org>
In-Reply-To: <20260527204757.2544958-10-hannes@cmpxchg.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 30 May 2026 01:33:16 +0800
X-Gm-Features: AVHnY4KkmKr_Dg7RuDhDe1BHG_7cHKvDQIjkTdZbfzW_BPAuMIyLPUW-Nsl3cwc
Message-ID: <CAMgjq7BFUrZ_nwENUycWZD2Fy2zBH4vms_GLTbp9ahYuA6SiHg@mail.gmail.com>
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mikhail Zaslonko <zaslonko@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iiuuxeghse15zo5oe5ubc5mqhkh7xwzs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A330100003
X-HE-Tag: 1780076036-99856
X-HE-Meta: U2FsdGVkX19eGABzIKAMif57KqDTlfykiQqBaXSyyHCOCk3SpcaQGNKGO//HZr7p8VMwsULgpu3r2ljqMSqNdBU2y0C5+MthxX3e5rfKsxlmw/KG+CzlLp1LOl+spzBZzM3rTLr7fnK2T4yqdw4nYIGiOWkPY6ko05Dbc7cQvx76kBDDI7O1Y9xAUeUIpKCefaLZUQKTpptGbhd4jYIODoxLoEl8MUJHNgSdQOiUidIb0q5u54qc3Q4BBrKDN0Ohw16EsvK96WX3gBK/QtaxDBAv1AXDoyeLlgsdhQ3aw9Dk6XTOdK0za0ThydxI+OwwtqQeejzB8kEe0d8aG1NjMIvY6SAsrsiJ7x4J1vufkYUConNhpZFsPQzKsa4Kz6k2tWQUlyrtui5/O9/Bm/ScWrjHchb0pXk6difsdRX+QsjYAlfeY3AsmA7Y8z/2eWFMDShyyalsMphoVIUu6MH5qU5OVEYkzWYVpV0dC/AfYDSguI4N3HMwf2vOyMIJOx0xowJST7sppnrIVZahZdGpXu1jOyB4nlbh1ef+tJEnZGnn1YGiMAKqFfDN/QGZm8+iatSspj/u7yf3uQk6axPLtYlU2jITCbvmWkmR819ula9gO/k4FtVrtwk7goUcLZjWbY2XVIs1PSeG69ZnPNxvTeOh57pLFSGbjZpaaKrOlLrbf23DJDPUp9+VUm5fkjIuylx8xhepUUa1wYFBpY8Yj4JdW3Zny2Mo/KzZjqBBOTnedbyPJUeBkv3SlFfr/GLK3u0hSVlzgL078IssFChY2kjk0i90fzRBiFioagrJPRsOoF7NstyNLGSJRvwfYUvFRY9hjotju2kHhJne2qnha4SK2psoqO1KA4JVeCE0ECqRlDwguAkZJv1vUxLg6XGZt8dX6jDrFn8itNSK9vi7YR0BKBj5FCy8xmcOTPB4vbzJawrgTFDxs5RDBvIYJ158vqRyJS/w3+GjaigOC7P
 DX4+rQ95
 orfuO/pAdI4X+fuMCRxWzk6L0ldsnwTsXcrQucjh9sFEpAMG+8fVzhQ4B1bLaic43nXaGFbvtX5beQkRMAz0wnQTx5OZlhDsft605zN5RsAlVIvfKhaKEyj2ioQRNjtEsCeFrxGd8nrKREgIqiEyyRWPhZD4r3rmJ0yoQNdYI5rduv4T+N9U3TNeSzmdAwyjGlpbOXzEAa1HwAjkmfAy3EKH2jEgbS9Fbz3bbKFjQSpyzZkChw8sKNUl3KLMzOS7SJ0jAN+aWbQ0JwOB9YBCmU5F2KorW+HiJhjIjHrZKoyA2FBVDAIIO5vygB8jybRWwbjNyYzC8z3v9Wi6Nvh8Z+4GhEs9nYTsuJ1AAElVqKLoNttDV7NGtWgGL9IjhoVux+qVbN40b7GLoslyWMpJSAaaW63ppGfgbCoe3kbaUD2CiUxtCHeHMv83atwBzEyxe5PvQMC5+J4LKW61uEqSoydVCxeKJ4FCquvjEcgwBwtQvKMNwJApvT8BIoGwFcbhrnJSTkGrG3svit03+jHU0O7qebTy7Yz+rTRs332S+qpyVzGeAa5c8zN2+UDhSwVALDgBKcg4zA2N2Jnd3kNqtkyoFwSMAKftCSY2T+O//21GSJ4zSinsBEp4U5zMKoDcFaAPOD006bS5T4Nee7m2dvYeBCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 4:48=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org=
> wrote:
>
> The deferred split queue handles cgroups in a suboptimal fashion. The
> queue is per-NUMA node or per-cgroup, not the intersection. That means
> on a cgrouped system, a node-restricted allocation entering reclaim
> can end up splitting large pages on other nodes:
>
>         alloc/unmap
>           deferred_split_folio()
>             list_add_tail(memcg->split_queue)
>             set_shrinker_bit(memcg, node, deferred_shrinker_id)
>
>         for_each_zone_zonelist_nodemask(restricted_nodes)
>           mem_cgroup_iter()
>             shrink_slab(node, memcg)
>               shrink_slab_memcg(node, memcg)
>                 if test_shrinker_bit(memcg, node, deferred_shrinker_id)
>                   deferred_split_scan()
>                     walks memcg->split_queue
>
> The shrinker bit adds an imperfect guard rail. As soon as the cgroup
> has a single large page on the node of interest, all large pages owned
> by that memcg, including those on other nodes, will be split.
>
> list_lru properly sets up per-node, per-cgroup lists. As a bonus, it
> streamlines a lot of the list operations and reclaim walks. It's used
> widely by other major shrinkers already. Convert the deferred split
> queue as well.
>
> The list_lru per-memcg heads are instantiated on demand when the first
> object of interest is allocated for a cgroup, by calling
> folio_memcg_alloc_deferred(). Add calls to where splittable pages are
> created: anon faults, swapin faults, khugepaged collapse.
>
> These calls create all possible node heads for the cgroup at once, so
> the migration code (between nodes) doesn't need any special care.
>
> Reported-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Tested-by: Mikhail Zaslonko <zaslonko@linux.ibm.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/huge_mm.h    |   7 +-
>  include/linux/memcontrol.h |   4 -
>  include/linux/mmzone.h     |  12 --
>  mm/huge_memory.c           | 364 +++++++++++++------------------------
>  mm/internal.h              |   2 +-
>  mm/khugepaged.c            |   5 +
>  mm/memcontrol.c            |  12 +-
>  mm/memory.c                |   4 +
>  mm/mm_init.c               |  15 --
>  mm/swap_state.c            |  10 +
>  10 files changed, 150 insertions(+), 285 deletions(-)

...

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 04f5ce992401..9c3a5cf99778 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -465,6 +465,16 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>                 return ERR_PTR(-ENOMEM);
>         }
>
> +       if (order > 1 && folio_memcg_alloc_deferred(folio)) {
> +               spin_lock(&ci->lock);
> +               __swap_cache_do_del_folio(ci, folio, entry, shadow);
> +               spin_unlock(&ci->lock);
> +               folio_unlock(folio);
> +               /* nr_pages refs from swap cache, 1 from allocation */
> +               folio_put_refs(folio, nr_pages + 1);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +

Thanks!

Nit: I think it would be better if we move the error handling under a
label to be shared with the charge failure above, but it's fine this
way, can be simplified later.

Reviewed-by: Kairui Song <kasong@tencent.com>

