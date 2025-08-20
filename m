Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF86CCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C3C28E0035; Wed, 20 Aug 2025 19:33:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B968E002F; Wed, 20 Aug 2025 19:33:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B13F8E0035; Wed, 20 Aug 2025 19:33:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2B78E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:33:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 17F121A01BF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:33:48 +0000 (UTC)
X-FDA: 83798740536.06.FEB19B8
Received: from mail-ej1-f66.google.com (mail-ej1-f66.google.com [209.85.218.66])
	by imf14.hostedemail.com (Postfix) with ESMTP id 39F35100009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:33:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EpEMEWf8;
	spf=pass (imf14.hostedemail.com: domain of memxor@gmail.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755732826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMa5hDCcy00DzZK+4d6bk0F5shIXQnXC8ZXi1NtBu6Y=;
	b=esM76oCewOjJ58KAs9raX6QlpV/yoIty0PTkQAQb2ws7vUVq9UdCtOiZEF8H5On3LanOMI
	zaRvaKgUvbds8t7fJU/AuIKd5XhUeBLIHNDA9yA8NkuVS+b9HNP1DgSUg+NElr4BljyoTb
	l4XkizegxIsGBajjAa2fNysLZxVFJbg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EpEMEWf8;
	spf=pass (imf14.hostedemail.com: domain of memxor@gmail.com designates 209.85.218.66 as permitted sender) smtp.mailfrom=memxor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755732826; a=rsa-sha256;
	cv=none;
	b=YejZq8iwXGYkMD99JrYNI0agnmFkQDHnB6osQ8tRNTI9kNUCwKhY3ZVTPAAdBTYireo67E
	W/JqSX13HGzuPBFCM+JHwJ23IJ1FfHdalLU+o1mpcUMacqNXsKHeS5vPypGuw3SJ2uF/wD
	wF0K8WJNgIFLrHdxejyXIfJUBP+m3oQ=
Received: by mail-ej1-f66.google.com with SMTP id a640c23a62f3a-afcb79f659aso66336566b.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755732824; x=1756337624; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eMa5hDCcy00DzZK+4d6bk0F5shIXQnXC8ZXi1NtBu6Y=;
        b=EpEMEWf8icWMltzHW0fzKM2R3m/UKzN6f/6rNNMvpY0e+jcpZyVaomyZA2WJOsXcwO
         JMrZkDuDs1P1oS4VPoPGeyIYkArxFYrHToNU4jbQti7fpF9HAiuyPBKhvvRYuHJYw4NH
         JKmKKKdOGSCPZTVT/fYXCABvBvAGuIHzqocW5EZwIOg2ykkMopFVGMKCcLUg8ltjnQAu
         Y089KjUZNyBlQMSH6XwWfF91iWgMhbHont/RvA0WWFJ6LHhzckeWoS9L5A7XDjoWxqfy
         a5JicyCCdtYfvpCLdtAQeX3dTi7PlkQlkPee5e0ZG5Yin2jrhmbna661od0YwvxKNBlE
         L1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755732824; x=1756337624;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMa5hDCcy00DzZK+4d6bk0F5shIXQnXC8ZXi1NtBu6Y=;
        b=QBNC8GVOhUQ6LC0luv9/yn2ciIcaiOWG8lRhVMeHGTZiSa1MPWCmv/X3AWiHOlagcF
         EaIT6JnJ0v+Y2zKuNzdor8joZxPiz8ECzTrppuBV5akL+2HQW4Opv1Gh1cxTgwGhUVTh
         X1wb8oNUD3QkuAdJLq8+welwolLyhRD5jOcD0YsS5mQ5AmNdizgo5RvmNO9jUrfNUc7w
         pMjeToo4pig6qp7mfrpN+PASrzg/Qws51E0IsyknCJBO9la8DRTMkghy8cIbrLh9aThz
         M0j9Y6S47TGbpxonW9jO9X/91NWVHnr8BFd6CaBh0mpjlpzbedBK9mxIEhOrugCYt47+
         H0DQ==
X-Gm-Message-State: AOJu0YzwF5m95ohupD+05WkCK0Yt3H8PYfV7O6Zap6L/o7b/CtMR/Nrh
	4Q5fLhK0APGzZTbtAMMsahtE0deWRgf8xHmlHAjjVT/oQwNvRnyJTChQjBoCfr6GXRFtUZT/xgv
	xjAKqnA8tg5NUhDxszH0GAATjvQsGDcM=
X-Gm-Gg: ASbGncsVb8f7L7daZrOMGvClhfadI4EzzE4JdZSCOGV0r3HYzn0lFOG4gqiYwBsVrfq
	1OkLegFos6DBEIKLI5k8q8BoK95pUMD/MZ+PAW0zj8R4F2X67rtxlUWWEfmT3kcewptil5KKmOa
	hy7G/TQGJIJKCujKfDtx70lauvFo+U2g3m0bepMFM4u/ZnaD0vHgrwfRgrl3dwUk5cmXIbnHC4X
	2ibsC7Q
X-Google-Smtp-Source: AGHT+IGy7pBJhS/s9zgv7RuaStEj5/bZcNiNoBaaY+sPnjxw6k583h9j3V73e3aXVyd/P0UyTYZWXtPFmoKmmEG7bjc=
X-Received: by 2002:a17:907:3f2a:b0:ae3:f903:e41 with SMTP id
 a640c23a62f3a-afe07e4b6d3mr52682066b.54.1755732824430; Wed, 20 Aug 2025
 16:33:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
 <20250818170136.209169-5-roman.gushchin@linux.dev> <CAP01T77yTb69hhi0CtDp9afVzO3T0fyPqhBF7By-iYYy__uOjA@mail.gmail.com>
 <87y0rdobq1.fsf@linux.dev>
In-Reply-To: <87y0rdobq1.fsf@linux.dev>
From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date: Thu, 21 Aug 2025 01:33:07 +0200
X-Gm-Features: Ac12FXyVgUuTqfIxaQ6U-WHmd3Kj3yK2MQ1qHDQGthNBax58JBZkGn_b0uDcmcY
Message-ID: <CAP01T76t3V_7PDoKJZ04cLfLYmUyAgJ54uyGpQGduWhXrQkXfA@mail.gmail.com>
Subject: Re: [PATCH v1 04/14] mm: introduce bpf kfuncs to deal with memcg pointers
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: b9at5m4pcjyeo1yt44tzu4hqxth9jw71
X-Rspam-User: 
X-Rspamd-Queue-Id: 39F35100009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755732825-220763
X-HE-Meta: U2FsdGVkX186A2jJ3PHqaxX6NtLolX55EHcWavySqY32EHIR9Km1ue11rFiznouTn9ndSt2JCudOdja5xc66RgVL3jI2aGOp35wfb5w/gTrbeMWTlD+xclFPZc5eHOkKnCwHCrSc5HHj4tBmpsus/hMLztwlPUTXCor4ECGkk1rJigbSIbrqitBTrDCfGzb8/OUe7UWp1pz8gwADT475Ht6NpLvrOpaN06vacsNmXpFaSKBi0bbNIP9oIwBG6nFkBEcC8i48p5WHYbk5zkgZ6h7HWHt/QUWNyea3o2sXw2oEKz2V0wmFBLdEgS9RZUIKFhaaIbBdvZMLDE8qPVysSw0vRBHyVVWdMlM3pZPDib5LPeNP5IH1xQNfqGCz0i1699tWmnsB95BRUY9kyIhTUqcs1X94QzQ6wSFGHkoMkP4RSxSzURMtrgZS0g7O5xnedjUB7fKo0GC8e+AIUuENZBTlzcTqU61pRAegG8OlU2Oo5dE14P3os6vQ22rhfYcaYQGS+9szIsWrjD3/vWrGxo9F4KhNUVyF4xqmI6/xKxyaRVSp5mA1b7iowO+cv+zDMxAuiLb3CcjQFfIAXvaFiC2005Wzn700WpKPUv8MMtN8OeIpWXGDgA9l8c3H/i6j5JOEqxCy9Wc7klYv5spDJNWlCJ+uxbDrM4PPKCE8YP4/vShVvnbHvxYbiX2giQQkPubM+z8PjEB8d2KxL+hyHfyhGhYx235QoMPxnbStkd6euZCyQaJcnlsfdaFvIcUqw+pgqq7zDigj8zUDXc9/BPOD4cK067x6FU6MInaPDinclVvUK5dncKFWIBAVPbb+5LUcO2kHMWGfhjQcXn04xuzCGsch59lHycSvrOEHxpfksh10H9L/+W8io3nSj+Ebckb7ATSeF5Np1p/MiirvNwzyepNtG9/KHCShsYOC5bOfGyovOnU6cQ3Sq0is9jTPpJczYRJAIQ4StKS0aRN
 uVnVT+Ur
 S4HYnjoHSbafCXRQjNunNR2qHLt4Wg4EKpluIXpgkR7cNyT2ExSh2Dcr83sdfq+lUQvaKHsIWv0H4Y6ThyCjVi9OV560jgDjILoE9PNGp7tke2vsWYfMVqGB8HRfa5XDLBdE2LMKaE/v/dNrNmmggx1VggDyVpWf0ZU8Yuc1jNd7H2KlHhb//4JzBrxrVwP94k+uILAle9wCbRUqdXajzVSlYwykSyC8gsjMB+TUvQ2TIh5K31dO3c6lu8jG7M0hm9LLGRhV3t0/l+vbqAfklUAhNQfkZu2OVLBZ84/u54VynvUfK1m6vekDLyD9mmuHsl1GDuBWJKLHdphGN2tIpi4QpqLiOiGb/jkMcCjfz8o/H+h1y1UnaTlVa2ORHqzmNpEKBKasFKwS60nMq+QJZ7ENGj4TmpssoLYj7WSF+rnUIGQRPNpMdorVKMJZJuK3T2NCGIq7fBv5/lRbTMzGVP8h3RL8i/9NStTLfSBHTRHCMMt8vduuw4ISVeSoPHwacI+GH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 at 00:43, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
> Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:
>
> > On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
> >>
> >> To effectively operate with memory cgroups in bpf there is a need
> >> to convert css pointers to memcg pointers. A simple container_of
> >> cast which is used in the kernel code can't be used in bpf because
> >> from the verifier's point of view that's a out-of-bounds memory access.
> >>
> >> Introduce helper get/put kfuncs which can be used to get
> >> a refcounted memcg pointer from the css pointer:
> >>   - bpf_get_mem_cgroup,
> >>   - bpf_put_mem_cgroup.
> >>
> >> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
> >> cgroup's "self" css. It allows it to be used with the existing cgroup
> >> iterator which iterates over cgroup tree, not memcg tree.
> >>
> >> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> >> ---
> >>  include/linux/memcontrol.h |   2 +
> >>  mm/Makefile                |   1 +
> >>  mm/bpf_memcontrol.c        | 151 +++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 154 insertions(+)
> >>  create mode 100644 mm/bpf_memcontrol.c
> >>
> >> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> >> index 87b6688f124a..785a064000cd 100644
> >> --- a/include/linux/memcontrol.h
> >> +++ b/include/linux/memcontrol.h
> >> @@ -932,6 +932,8 @@ static inline void mod_memcg_page_state(struct page *page,
> >>         rcu_read_unlock();
> >>  }
> >>
> >> +unsigned long memcg_events(struct mem_cgroup *memcg, int event);
> >> +unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
> >>  unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
> >>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
> >>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
> >> diff --git a/mm/Makefile b/mm/Makefile
> >> index a714aba03759..c397af904a87 100644
> >> --- a/mm/Makefile
> >> +++ b/mm/Makefile
> >> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
> >>  endif
> >>  ifdef CONFIG_BPF_SYSCALL
> >>  obj-y += bpf_oom.o
> >> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
> >>  endif
> >>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
> >>  obj-$(CONFIG_GUP_TEST) += gup_test.o
> >> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> >> new file mode 100644
> >> index 000000000000..66f2a359af7e
> >> --- /dev/null
> >> +++ b/mm/bpf_memcontrol.c
> >> @@ -0,0 +1,151 @@
> >> +// SPDX-License-Identifier: GPL-2.0-or-later
> >> +/*
> >> + * Memory Controller-related BPF kfuncs and auxiliary code
> >> + *
> >> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> >> + */
> >> +
> >> +#include <linux/memcontrol.h>
> >> +#include <linux/bpf.h>
> >> +
> >> +__bpf_kfunc_start_defs();
> >> +
> >> +/**
> >> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> >> + * @css: pointer to the css structure
> >> + *
> >> + * Returns a pointer to a mem_cgroup structure after bumping
> >> + * the corresponding css's reference counter.
> >> + *
> >> + * It's fine to pass a css which belongs to any cgroup controller,
> >> + * e.g. unified hierarchy's main css.
> >> + *
> >> + * Implements KF_ACQUIRE semantics.
> >> + */
> >> +__bpf_kfunc struct mem_cgroup *
> >> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> >> +{
> >> +       struct mem_cgroup *memcg = NULL;
> >> +       bool rcu_unlock = false;
> >> +
> >> +       if (!root_mem_cgroup)
> >> +               return NULL;
> >> +
> >> +       if (root_mem_cgroup->css.ss != css->ss) {
> >> +               struct cgroup *cgroup = css->cgroup;
> >> +               int ssid = root_mem_cgroup->css.ss->id;
> >> +
> >> +               rcu_read_lock();
> >> +               rcu_unlock = true;
> >> +               css = rcu_dereference_raw(cgroup->subsys[ssid]);
> >> +       }
> >> +
> >> +       if (css && css_tryget(css))
> >> +               memcg = container_of(css, struct mem_cgroup, css);
> >> +
> >> +       if (rcu_unlock)
> >> +               rcu_read_unlock();
> >> +
> >> +       return memcg;
> >> +}
> >> +
> >> +/**
> >> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
> >> + * @memcg: memory cgroup to release
> >> + *
> >> + * Releases a previously acquired memcg reference.
> >> + * Implements KF_RELEASE semantics.
> >> + */
> >> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> >> +{
> >> +       css_put(&memcg->css);
> >> +}
> >> +
> >> +/**
> >> + * bpf_mem_cgroup_events - Read memory cgroup's event counter
> >> + * @memcg: memory cgroup
> >> + * @event: event idx
> >> + *
> >> + * Allows to read memory cgroup event counters.
> >> + */
> >> +__bpf_kfunc unsigned long bpf_mem_cgroup_events(struct mem_cgroup *memcg, int event)
> >> +{
> >> +
> >> +       if (event < 0 || event >= NR_VM_EVENT_ITEMS)
> >> +               return (unsigned long)-1;
> >> +
> >> +       return memcg_events(memcg, event);
> >> +}
> >> +
> >> +/**
> >> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
> >> + * @memcg: memory cgroup
> >> + *
> >> + * Returns current memory cgroup size in bytes.
> >> + */
> >> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
> >> +{
> >> +       return page_counter_read(&memcg->memory);
> >> +}
> >> +
> >> +/**
> >> + * bpf_mem_cgroup_events - Read memory cgroup's page state counter
> >> + * @memcg: memory cgroup
> >> + * @event: event idx
> >> + *
> >> + * Allows to read memory cgroup statistics.
> >> + */
> >> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
> >> +{
> >> +       if (idx < 0 || idx >= MEMCG_NR_STAT)
> >> +               return (unsigned long)-1;
> >> +
> >> +       return memcg_page_state(memcg, idx);
> >> +}
> >> +
> >> +/**
> >> + * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
> >> + * @memcg: memory cgroup
> >> + *
> >> + * Propagate memory cgroup's statistics up the cgroup tree.
> >> + *
> >> + * Note, that this function uses the rate-limited version of
> >> + * mem_cgroup_flush_stats() to avoid hurting the system-wide
> >> + * performance. So bpf_mem_cgroup_flush_stats() guarantees only
> >> + * that statistics is not stale beyond 2*FLUSH_TIME.
> >> + */
> >> +__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >> +{
> >> +       mem_cgroup_flush_stats_ratelimited(memcg);
> >> +}
> >> +
> >> +__bpf_kfunc_end_defs();
> >> +
> >> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> >> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
> >
> > I think you could set KF_TRUSTED_ARGS for this as well.
>
> Not really. The intended use case is to iterate over the cgroup tree,
> which gives non-trusted css pointers:
>         bpf_for_each(css, css_pos, &root_memcg->css, BPF_CGROUP_ITER_DESCENDANTS_POST) {
>                 memcg = bpf_get_mem_cgroup(css_pos);
>         }

Then I assume they're at least RCU protected? You could relax it from
trusted to KF_RCU (since I see css_tryget internally).
Otherwise the default behavior is unconstrained (any ptr matching that
type obtained from random walks --- which is something to fix, but
until then we have to actively mark for taking safe arguments).

>
> Thanks

