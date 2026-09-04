Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16444C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C4466B0088; Fri,  4 Sep 2026 18:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 874EA6B008A; Fri,  4 Sep 2026 18:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78C0A6B008C; Fri,  4 Sep 2026 18:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4309F6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:44:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3B72401DC
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:44:26 +0000 (UTC)
X-FDA: 85177560132.14.7CB3E12
Received: from mta0.migadu.com (out-136.mta0.migadu.com [91.218.175.136])
	by imf16.hostedemail.com (Postfix) with ESMTP id 02535180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:44:22 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIA8Ldk9;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788561865;
	b=fHBaH1SJJzBRMKxLlC02VWlzPMl9fbHvteP8AsoNzDi56pE4Ihjus/9609rPRB0zKPc43H
	fueiNFFA+jYvREOT8Uj3E3m1a5xplOcUH7tp1+ipaX+vdeTVGvgQUvSNdLq7QU0Xh4phGZ
	pSNhZLl+FNumERtD85jCTit099aFMho=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZIA8Ldk9;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.136 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788561864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i3ccFdMbIeMRLpQb7lQSI2xHgvfmQ31LlLgC3Y7zGvk=;
	b=f+0s89nV6Smbq+LW1bCIv9hfyurCaU7x2hnMlBCyPJT/3kkqme7VD058TiiwvHU7JHo+nZ
	NRAWGL28e8uqYSWNcdq2+QjTZmCUVJP0hnwb1fAo11iU8OHtEnsKFytktnkqpe2gceByvO
	aDEeVjirmUbnsPnGFQmpeA8B0Ayr77I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5JJslb5aQZAIHz9ntL7bFQFlu+8A9jB1du1N6SMHrzU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788561859; v=1; x=1789166659;
 b=ZIA8Ldk9XPWXPLAo8tDRa5rgZE4OdAOVKrKRmI6UkSsOz3kApmQfiVELn7SzroBR6ADMNMa7
 1MUCl9YC6DCVamiDxZ3Ekce4/v0BLLM7dcxcKUAdWbfDSWvKeoUbxkE2qvJeRGQMiHBWwuEhAEq
 aHTVBYIvPVtHUBrjEqDTMvk0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9c0fbca0130c8bd5;
	Fri, 04 Sep 2026 22:44:09 +0000
X-Mizu-Trace-ID: 9c0fbca0130c8bd5
X-Migadu-Flow: FLOW_OUT
Date: Fri, 4 Sep 2026 15:44:04 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <aptIy7R37n5C-o6z@linux.dev>
References: <20260904173145.2028377-1-stevensd@google.com>
 <apsTohKZNnZuWIxC@linux.dev>
 <CAOiLmNGdPk+7v6Aqm9ctQV9J3YKti50gVTP00P=-3cZ8-x5cUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOiLmNGdPk+7v6Aqm9ctQV9J3YKti50gVTP00P=-3cZ8-x5cUA@mail.gmail.com>
X-Rspam-User: 
X-Stat-Signature: 347wntxhfncxst4z3a1ehqr6qp4axscw
X-Rspamd-Queue-Id: 02535180003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788561862-155034
X-HE-Meta: U2FsdGVkX19d4lBAYvBlquBxE/sEiPc+TOnaXByIIl8F3TCFSACBHTga5T1SJoUB2X26bhODVcyJDS4plVAyt9UXQm9/vUZ0LFxGeLHZ1/bd8RrySgydpMAMFKvaHD3Iv76WLeF8anoK+J8Q0B8QY/eMHON41gf7AaPQX8koFjxNeFREmPfkVBBsr80dMCMDFFJHKbeb7Hp/5Ybxe40gfkDlmwcuKk/EXTb8LkwN6IpMNBLTW2hA62GOgN3FCjAHzmbtIp9jwVPNz4c4uKLdPtfsJAbmzpSZaGrLnM1VkrtITlv/v5n+8IWdE37UZMSeGy3BYnwzdJXI6ZbXdESS30cfsjAZyKJIbZrwLpy5KHz2ih13kKVty/0MMqIMrliooVd+VyGUmhXV8DFI0NJmK0kAP4UN53zu61PNFliD2bDZc8jc9Eb86ClaX0vGI45L9rkgK0yita11VbqzIMC+d3O64ZJCGS4Yja3C9LlLdjTw+T7hjcdrH+q2yiQgJKwCSyToGlw9DGYQSbUElSV2deKi12piuZnoWRBlLHENzK+XLzGeyVobkjZCXNfZxOm/+ySIsKJkC+H9R0gMLmZUWboHkVDOjAA0J+ZGDZ7W9hFI/0o8kKP1kx1y45Efq29W2rSXTBEuKSeGZsOuoYv+7pn24ekX9skzhwKmiYxJHDDt5mv0aY7NQ4yERvbjJlEOXGtrvSsoNfDeeG47XRVyKh6Ysz5NrqdcaB0rRQqvMHwy6C/voHd+kwI4hHpIvF3I5C/e/vfnVUEEkSs2gxn8jlh70gVV+XFCzJXVk7I5ApH0yk23w4BD2mViQMRhgHICD3/ykwSeOWxPEO9BsfMcdJOw8/qnbemt8eWp7vfqjd2VJyqo0r3nTQiM+izQeWrOx7riy6RP4N55JTSXfyaLa5L06HWQNETNjJsBefF+1XbBwNUT42mj6V99zVBEGHCDzkBiFtM2BjuNt7oAgom
 Ub13uzdT
 wZREqfLCghPWQDdKWkjey9xwEgnpy5WTWjCA4smNgZlEEbALQ8yjkA4jhKPq/EDtDiGFF3mpCo7aJuVJheQYKMiTifqBYLjZtPbOM+fKTgODhDzNjGies3JqGINcc5hUsz4jXC56IO+USoNHFSeP+ZtSnP5N7XUKCASQ4d864ilKUXdCm69OMXD8efH5WY+g18hbYaStGMaZlhp//mo7mrcoB9Z5ehBhGmXFLr6v2/UupKn+Npw7tqm1lJUzKKt9521oMdpW9QlKJKWgcgRe2mvcqR/FBmDvZFvQoLtlZkDP6pvb75S5TtLqanrJj5DrQmZ4j5ZyqoTxoJjYsjcxTWOLotIfNlUNJJ2O9qwE5lKt8L2VIzUWntzRjQGdygz0CIYYEeiBdnDk66FYgiTKuUjuNFz+vl3beYSRH7aCPIlPD7mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 03:15:54PM -0700, David Stevens wrote:
> On Fri, Sep 4, 2026 at 12:03 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Fri, Sep 04, 2026 at 10:31:45AM -0700, David Stevens wrote:
> > > Memcg charging can be done from any context, but calling schedule_work()
> > > isn't safe from an NMI. If memory.high is breached from a context where
> > > spinning isn't allowed, use irq_work to schedule the reclaim work.
> > >
> > > Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> > > Acked-by: Michal Hocko <mhocko@suse.com>
> > > Signed-off-by: David Stevens <stevensd@google.com>
> > > ---
> > > v2:
> > >   - Added missing includes reported by Lorenzo and kernel test robot
> > >   - Added Acked-by
> > >
> > >  include/linux/memcontrol.h |  2 ++
> > >  mm/memcontrol.c            | 13 ++++++++++++-
> > >  2 files changed, 14 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > > index 8170bb8066a2..4a5ef0aba475 100644
> > > --- a/include/linux/memcontrol.h
> > > +++ b/include/linux/memcontrol.h
> > > @@ -23,6 +23,7 @@
> > >  #include <linux/writeback.h>
> > >  #include <linux/page-flags.h>
> > >  #include <linux/shrinker.h>
> > > +#include <linux/irq_work_types.h>
> > >
> > >  struct mem_cgroup;
> > >  struct obj_cgroup;
> > > @@ -219,6 +220,7 @@ struct mem_cgroup {
> > >       spinlock_t       peaks_lock;
> > >
> > >       /* Range enforcement for interrupt charges */
> > > +     struct irq_work high_irq_work;
> > >       struct work_struct high_work;
> > >
> > >  #ifdef CONFIG_ZSWAP
> > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > index 6dc4888a90f3..0e8b302ca9ad 100644
> > > --- a/mm/memcontrol.c
> > > +++ b/mm/memcontrol.c
> > > @@ -62,6 +62,7 @@
> > >  #include <linux/seq_buf.h>
> > >  #include <linux/sched/isolation.h>
> > >  #include <linux/kmemleak.h>
> > > +#include <linux/irq_work.h>
> > >  #include "internal.h"
> > >  #include "swap_table.h"
> > >  #include <net/sock.h>
> > > @@ -2360,6 +2361,11 @@ static void high_work_func(struct work_struct *work)
> > >       reclaim_high(memcg, MEMCG_CHARGE_BATCH, GFP_KERNEL);
> > >  }
> > >
> > > +static void high_irq_work_func(struct irq_work *work)
> > > +{
> > > +     schedule_work(&container_of(work, struct mem_cgroup, high_irq_work)->high_work);
> > > +}
> > > +
> > >  /*
> > >   * Clamp the maximum sleep time per allocation batch to 2 seconds. This is
> > >   * enough to still cause a significant slowdown in most cases, while still
> > > @@ -2752,7 +2758,10 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> > >               /* Don't bother a random interrupted task */
> > >               if (!in_task()) {
> > >                       if (mem_high) {
> > > -                             schedule_work(&memcg->high_work);
> > > +                             if (allow_spinning)
> > > +                                     schedule_work(&memcg->high_work);
> > > +                             else
> > > +                                     irq_work_queue(&memcg->high_irq_work);
> > >                               break;
> > >                       }
> > >                       continue;
> > > @@ -4129,6 +4138,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
> > >               goto fail;
> > >
> > >       INIT_WORK(&memcg->high_work, high_work_func);
> > > +     init_irq_work(&memcg->high_irq_work, high_irq_work_func);
> > >       vmpressure_init(&memcg->vmpressure);
> > >       INIT_LIST_HEAD(&memcg->memory_peaks);
> > >       INIT_LIST_HEAD(&memcg->swap_peaks);
> > > @@ -4337,6 +4347,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
> > >               static_branch_dec(&memcg_bpf_enabled_key);
> > >
> > >       vmpressure_cleanup(&memcg->vmpressure);
> > > +     irq_work_sync(&memcg->high_irq_work);
> >
> > On RT kernels, this will put rcu grace period here while we are holding the
> > cgroup_mutex. Easy fix would be to use IRQ_WORK_INIT_HARD instead of
> > init_irq_work() in mem_cgroup_alloc.
> >
> > Something like:
> >         memcg->high_irq_work = IRQ_WORK_INIT_HARD(high_irq_work_func);
> >
> 
> This executes as part of css_free_rwork_fn(), so it isn't under cgroup_mutex.

Oh yes, css_free_rwork_fn does not take cgroup_mutex. Though synchronize_rcu()
is still something to avoid but not a blocker.

You can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

