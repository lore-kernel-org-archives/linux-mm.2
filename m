Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B103CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F74F6B00A3; Wed, 20 Aug 2025 05:21:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7D78E0002; Wed, 20 Aug 2025 05:21:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848EB6B00A5; Wed, 20 Aug 2025 05:21:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 71C946B00A3
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:21:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E0C62140406
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:21:49 +0000 (UTC)
X-FDA: 83796593538.08.07D9EA4
Received: from mail-ed1-f66.google.com (mail-ed1-f66.google.com [209.85.208.66])
	by imf10.hostedemail.com (Postfix) with ESMTP id 08DDBC0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:21:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl1BoI2D;
	spf=pass (imf10.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755681708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S4lyKlFc5v1BTxRNLlaeXyBr7nmibh9oA3mYYzwZ4Lw=;
	b=5mK4/ggTEA9ALHRKUztzQzSLgT9H04KSOPlAf6tmxVrOC2UJgqXjlzaaPWB8wyZWF3gnN2
	VNGazG1CL/eFQyVRufggXAj6TMB/JuQCoxqH3rB1nnZjoT2NA1xjNc2aK2fAQ+ZF7WZ8Zu
	gsekrWBjZyh6okNYXgvJE6ekecu8qbo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dl1BoI2D;
	spf=pass (imf10.hostedemail.com: domain of memxor@gmail.com designates 209.85.208.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755681708; a=rsa-sha256;
	cv=none;
	b=8WNWebLHpS4FM95HoU0FGFhaTg+LEWk6QgrFZx0dhPgexWCTZQtE+WmsyySD06Pxiz3gQe
	xYV3T38egwRAFZdqiiLFrCKY9/rb57StKSCjxCOjHuf5uZjwbOBnieHdRLDqEvoPgFvcSR
	eYBdIqJ8VKdVgDBEq8vKKxZe5h+WNgA=
Received: by mail-ed1-f66.google.com with SMTP id 4fb4d7f45d1cf-61a94bd82a5so1800502a12.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 02:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755681706; x=1756286506; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=S4lyKlFc5v1BTxRNLlaeXyBr7nmibh9oA3mYYzwZ4Lw=;
        b=Dl1BoI2D2Ty1y9wMOOumKXSZgwltYHYzmojae2aFYFwxNWp5blTGjHGObEvi4ySYJz
         p6PIVLJKDMZgRrvrVoFZdIk2lrGCldSZCCxdFpXCMKMJUGvY1srDUVbMP+7X7OFy3NP1
         8XdfX1u1xqZNAG0IeDknT0onreLe/I7XDCmwIYb3qnUPqZvMdQDZXH30R9LARrBW02IN
         pZSjW2nTQ2RvAiPoWJ5BC4o5Z/iUzV8wkw+6fqPwzZ6oG2oCMndV1D9vqsyFLTXsP6yi
         j22XlzCxNCl5yd7kitx/0DlghD78uGNQYR5bIffbz/FSCub2vuifI44U8f/ZfFFwOiFm
         8/ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755681706; x=1756286506;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S4lyKlFc5v1BTxRNLlaeXyBr7nmibh9oA3mYYzwZ4Lw=;
        b=YQPE3XPXxZFJY3A/fXoCFd7hTvFNFncYRxZ8tD7bIBMSyh6XRjJgmT3V1e6sNAaVsa
         S9XRyL9eJsRicZwtNVTiUB9+6n05619qqoNcGPOB/1kgaouEUUIbi0CY0ORD+vwcZ1UG
         WOEspm/q4nmgdKeY9C+u8RigJpFwatM7o0O2DruPNFtGeb0YtTO35roBA0Vaq0r5MIcV
         j6bQzjrTvWjst9bYw7700U95hSKHe3bAiCzB5VsUdfv+8go7PtJHmELiDqdBjYNmnmfc
         APUbCdI/FkR5t8JWTs0VYSwtMUO5sP+0UnUQ4a7JoMmsWeAmf90FOwRCG0Lw1bivg6pj
         3kgQ==
X-Gm-Message-State: AOJu0YzhnpnB9/AuWERPf+A2dnUSkYY2XfNtDI4rATCXNGMWf950NxK/
	vUrgA5QHGoBbV0PTYaSg277RUeGuIiltoOT15WAB/UBzhYKWuag/6y32i5/cQXMnAXLqlnnxE2c
	2cy2GtxWZDfpC36LVN8GWrHFatANn6yI=
X-Gm-Gg: ASbGncsMjC97vxyL8w/CxPhivZK8mZ9Fr9XgL407JonL2EX0mAU2CMl1Tce+ZBilYN0
	KRYovUxuNvi9eNzFfvlKzStwxPDiWBogDwo6Fa8y1sXFsMSLIOonFLD7535Bb0p/S/yu2c4sPTh
	Vx9C9MHcS08OHlgSylCkPqJvqS7eiDv0j53nquDUsjDD3IzqSsOCgWFi1b8qqZUsXiD5dy2rB8Q
	f25wxJCJg==
X-Google-Smtp-Source: AGHT+IG7xFTR4UZZQ4LFfHSulkCxAXFm3BGoaxsisWYUoJ1W6e9lz+bYlaZjjlP5HNP2olIECE2JZ2EVwHUYHLksKFk=
X-Received: by 2002:a05:6402:254e:b0:615:a3f9:7be5 with SMTP id
 4fb4d7f45d1cf-61a9782b6bbmr1710180a12.25.1755681706290; Wed, 20 Aug 2025
 02:21:46 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-5-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-5-roman.gushchin@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Wed, 20 Aug 2025 11:21:10 +0200
X-Gm-Features: Ac12FXwos2sMHUp8zbWnk19WXsIHgjajQlczEbHOuQC7H311cCFHvdp7izscD3c
Message-ID: <CAP01T77yTb69hhi0CtDp9afVzO3T0fyPqhBF7By-iYYy__uOjA@mail.gmail.com>
Subject: Re: [PATCH v1 04/14] mm: introduce bpf kfuncs to deal with memcg pointers
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 08DDBC0007
X-Stat-Signature: pwmyfyjsj7fe4kifsq4zgtxhy5fs958a
X-Rspam-User: 
X-HE-Tag: 1755681707-832514
X-HE-Meta: U2FsdGVkX18Qahh5Mk6tBcLDEdRvqjOeFvmmHtzxOHaK2Gq99FaK16X09zjtVykcwPDP4Qe1J4GFMbkHwHwyqggzjre2teFuCIwZvHQv3Z633e4NwqH8/U7eiXttFf9yktXQ5r8ZoQPW8LBroAob1csTa3OtzUmOxgQScbMTVRg1Ba6KgGYQQTwS2M9oS6sotuBOWSFXJiMYvyfCeUP64m3I39rFqRtvjoYM6wpiiUsoucmemqwjat+qJdbFQawcWMHhpYctBA3s3mYWnLnQta/Y0nvgNIHnI/cbUBH7W6+FqeZ0jlLBi4/tlAaoitV8EB5E0t/aeUXpbihw0U4X/iSaEBcmEuU3Xcx5UHGy9euh7EXx5Feo+kNir1Htf8tuFUHO4sVGZDWds+x5zN8vO1NRTQsOjPiIBH6IVVgjhr9nR3Jq9Cp/8hF/0oZz1YafseoTuvFY9c4mJmmFyaqn+o2KAavJ2ti/QeXtf6C/VYJXnVhkTuVt1rH0We/XdNpS7fT8opTzAXAwEf3pZ5dKYAZLzWNu+9X3gQjZWpwH/EbFCZie5vwk5tmljGofdYbpIJJ4gGoVa3Ovtg8MEIvgEANia04GGpw/CYQ6Z3mOUt9P/5ULVHeIPsPm7JrYoG+A6QRq5tRUdHxjzbAjy8YvoS6rnQZkmae3CEOBpD91Gk7SUzHsfTShP4yX6dqAYF+8FQvpJmfjvWJbEt2wXMFhX8CLQCSDK8zwciZAivkiHahlBpee2iWNWUnnNpIR1UpMizYyDACLhqSEEkmcUMso5hsi1cMd8Y6tK57A58Okfg2j7quoFUFK3MIDzHpeYkUOTmBsBxlTdN2Cqw1yFdhGl+gVVf/6YCoxtZi0zIatc4aoPlr7nLda8jHhDy89cqIIOgDhZSZ4tNIuyJzgfBdJe0vPABmzYjyNQm2pdJdQ/D+GUDCZBLHVMA39TQkfoPeZqXpj2UBWt3tN+A/NgWi
 BUjxPGuO
 WBCXYKJNdbaWkUvxyE12R7279cLA2msKKkLbOZ4wHto/ejegh+wfGS5M2KvQ9BTgvO3pFXQC8PuWd+H8YMRruoxuhZXrfIJcOIYyHEhi1+LHbZ+esRzPepu9VMGIIUDdQkDvbdOPvshtgJiRW2Kg8ftYEhRTbUdbwDuCrnyziJtYQM1w1mC1cVfG3srCaHzZ2Hpvg0YDIkS8ubg+h+3J8kHtFkaJrDpVZ7HVmQOPJJ2Rt1K5gGPf7KrgVfqTmh6SxDuGottdsgLUzIqX7gOoALKKNiHJUXrCYZyUWg5hEEBzIkRanOr3bwEnfleexto1qlwy/J4W1IVKntAy6fkiL+ZyL/KR2ck7lnKuisYe+MkniPYHY7Gu9Pw4Q1j8c7YcAWdvudQ/oDvJdYQDy9wdBjD/mlFBsOxqYKDhg38+AIeDrn90lEcLeH7KxL8RYWKZrnILy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> To effectively operate with memory cgroups in bpf there is a need
> to convert css pointers to memcg pointers. A simple container_of
> cast which is used in the kernel code can't be used in bpf because
> from the verifier's point of view that's a out-of-bounds memory access.
>
> Introduce helper get/put kfuncs which can be used to get
> a refcounted memcg pointer from the css pointer:
>   - bpf_get_mem_cgroup,
>   - bpf_put_mem_cgroup.
>
> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
> cgroup's "self" css. It allows it to be used with the existing cgroup
> iterator which iterates over cgroup tree, not memcg tree.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  include/linux/memcontrol.h |   2 +
>  mm/Makefile                |   1 +
>  mm/bpf_memcontrol.c        | 151 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 154 insertions(+)
>  create mode 100644 mm/bpf_memcontrol.c
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 87b6688f124a..785a064000cd 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -932,6 +932,8 @@ static inline void mod_memcg_page_state(struct page *page,
>         rcu_read_unlock();
>  }
>
> +unsigned long memcg_events(struct mem_cgroup *memcg, int event);
> +unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
>  unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> diff --git a/mm/Makefile b/mm/Makefile
> index a714aba03759..c397af904a87 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
>  endif
>  ifdef CONFIG_BPF_SYSCALL
>  obj-y += bpf_oom.o
> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>  endif
>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>  obj-$(CONFIG_GUP_TEST) += gup_test.o
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> new file mode 100644
> index 000000000000..66f2a359af7e
> --- /dev/null
> +++ b/mm/bpf_memcontrol.c
> @@ -0,0 +1,151 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Memory Controller-related BPF kfuncs and auxiliary code
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/memcontrol.h>
> +#include <linux/bpf.h>
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> + * @css: pointer to the css structure
> + *
> + * Returns a pointer to a mem_cgroup structure after bumping
> + * the corresponding css's reference counter.
> + *
> + * It's fine to pass a css which belongs to any cgroup controller,
> + * e.g. unified hierarchy's main css.
> + *
> + * Implements KF_ACQUIRE semantics.
> + */
> +__bpf_kfunc struct mem_cgroup *
> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> +{
> +       struct mem_cgroup *memcg = NULL;
> +       bool rcu_unlock = false;
> +
> +       if (!root_mem_cgroup)
> +               return NULL;
> +
> +       if (root_mem_cgroup->css.ss != css->ss) {
> +               struct cgroup *cgroup = css->cgroup;
> +               int ssid = root_mem_cgroup->css.ss->id;
> +
> +               rcu_read_lock();
> +               rcu_unlock = true;
> +               css = rcu_dereference_raw(cgroup->subsys[ssid]);
> +       }
> +
> +       if (css && css_tryget(css))
> +               memcg = container_of(css, struct mem_cgroup, css);
> +
> +       if (rcu_unlock)
> +               rcu_read_unlock();
> +
> +       return memcg;
> +}
> +
> +/**
> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
> + * @memcg: memory cgroup to release
> + *
> + * Releases a previously acquired memcg reference.
> + * Implements KF_RELEASE semantics.
> + */
> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> +{
> +       css_put(&memcg->css);
> +}
> +
> +/**
> + * bpf_mem_cgroup_events - Read memory cgroup's event counter
> + * @memcg: memory cgroup
> + * @event: event idx
> + *
> + * Allows to read memory cgroup event counters.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_events(struct mem_cgroup *memcg, int event)
> +{
> +
> +       if (event < 0 || event >= NR_VM_EVENT_ITEMS)
> +               return (unsigned long)-1;
> +
> +       return memcg_events(memcg, event);
> +}
> +
> +/**
> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
> + * @memcg: memory cgroup
> + *
> + * Returns current memory cgroup size in bytes.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
> +{
> +       return page_counter_read(&memcg->memory);
> +}
> +
> +/**
> + * bpf_mem_cgroup_events - Read memory cgroup's page state counter
> + * @memcg: memory cgroup
> + * @event: event idx
> + *
> + * Allows to read memory cgroup statistics.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> +{
> +       if (idx < 0 || idx >= MEMCG_NR_STAT)
> +               return (unsigned long)-1;
> +
> +       return memcg_page_state(memcg, idx);
> +}
> +
> +/**
> + * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
> + * @memcg: memory cgroup
> + *
> + * Propagate memory cgroup's statistics up the cgroup tree.
> + *
> + * Note, that this function uses the rate-limited version of
> + * mem_cgroup_flush_stats() to avoid hurting the system-wide
> + * performance. So bpf_mem_cgroup_flush_stats() guarantees only
> + * that statistics is not stale beyond 2*FLUSH_TIME.
> + */
> +__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> +{
> +       mem_cgroup_flush_stats_ratelimited(memcg);
> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)

I think you could set KF_TRUSTED_ARGS for this as well.

> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_RELEASE)
> +
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_events, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_usage, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_page_state, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_mem_cgroup_flush_stats, KF_TRUSTED_ARGS)
> +
> +BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
> +
> +static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> +       .owner          = THIS_MODULE,
> +       .set            = &bpf_memcontrol_kfuncs,
> +};
> +
> +static int __init bpf_memcontrol_init(void)
> +{
> +       int err;
> +
> +       err = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
> +                                       &bpf_memcontrol_kfunc_set);
> +       if (err)
> +               pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
> +
> +       return err;
> +}
> +late_initcall(bpf_memcontrol_init);
> --
> 2.50.1
>

