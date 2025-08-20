Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12145CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6F596B00BA; Wed, 20 Aug 2025 18:44:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1FD58E0031; Wed, 20 Aug 2025 18:44:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9159F6B00BC; Wed, 20 Aug 2025 18:44:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0B46B00BA
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:44:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EA905691B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:44:03 +0000 (UTC)
X-FDA: 83798615166.10.425CFD3
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3AAD5160004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:44:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZM2lI3i;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755729841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HIBMbsV17r3lKNlQBpoJQUHEqmYE5Up+KV862pg9Yp4=;
	b=uy8Mp0v120x6TAdNu2gJOJUxMEPK+dJVbOKxjRcOq0gea68V7MWx+3lzVTiH9UD8mhjgUm
	BweQGm9O28Szpm0McLvewSfs0dWlGeEjTqFp9SIw4AYYNjMzKG9+L/DTm0+be4WFmPhg6P
	AyFfphSh+Rmd0oU0Gcn3V3lraRyeEOQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UZM2lI3i;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755729841; a=rsa-sha256;
	cv=none;
	b=q1ycknaGhEUlJ4zv8oUBWquvCh0Hp1WH8i9iufq7QwCk5yPk3UoNyNo0VVa81oY0BvF+xt
	81CvjaxV0oh4G1Ode54AwCNJnwgvPyjS9OBnQTLMJKJaRfxizbXRSoMZx+1/joDdfHPRLd
	EGe+8HMVK03H+r5GB79jKvWhKmuDHvE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755729839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HIBMbsV17r3lKNlQBpoJQUHEqmYE5Up+KV862pg9Yp4=;
	b=UZM2lI3i6LGEVcl88gfvKWNdhERvfxCPdeyXhhcpp6sf9wz0lyTEz9gchUtQJBcJHZUwHq
	b4dUlPv4LO2OSlHxptKoAQ0+m2qa6C4s1kbKKuqAy6vX+C48KlC5vBDZZ7spT/8Jloygxc
	IouxqrgwYt1sJWqrmzXRJUbgYy4+aYE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: linux-mm@kvack.org,  bpf@vger.kernel.org,  Suren Baghdasaryan
 <surenb@google.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@suse.com>,  David Rientjes <rientjes@google.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Song Liu <song@kernel.org>,  Alexei
 Starovoitov <ast@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 04/14] mm: introduce bpf kfuncs to deal with memcg
 pointers
In-Reply-To: <CAP01T77yTb69hhi0CtDp9afVzO3T0fyPqhBF7By-iYYy__uOjA@mail.gmail.com>
	(Kumar Kartikeya Dwivedi's message of "Wed, 20 Aug 2025 11:21:10
	+0200")
References: <20250818170136.209169-1-roman.gushchin@linux.dev>
	<20250818170136.209169-5-roman.gushchin@linux.dev>
	<CAP01T77yTb69hhi0CtDp9afVzO3T0fyPqhBF7By-iYYy__uOjA@mail.gmail.com>
Date: Wed, 20 Aug 2025 15:43:50 -0700
Message-ID: <87y0rdobq1.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nk7ukgpt9oga1tjjd6dmiy9ikniqu3th
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AAD5160004
X-Rspamd-Server: rspam01
X-HE-Tag: 1755729840-75027
X-HE-Meta: U2FsdGVkX1/n517Rg0NrL8B6g4/HXUoeiVGmamYWs8lFXrjKnUZqW/UGyGmEIQWDeYqewQbmapF/b0l4XYn6lgC9kv7rvaP4RwTOT8XQ711VmGyIGsMdYIl03bObEFRHIO4QPHnsqnArCn/5noc5cTOMOx9V3rPtBilTVcHVA0BdAd1o3bD475+FoWMMLadezBdvq1eLFWja31suVyWcFasT7Vx2/oiDS7U4SRhI/KKy1TW5HKgWjJFG6IvIzEjt5imnLXyNYWg3DoXIytbz1ZK31CMg3v7JZMIO984SqcVl1v7d/kCqtqmG0DQLQwNt+JzX3oSaVUQf+SUICYoQyfd0VAHSb1kJxm1oqbZ/g4HHTaChuk4HrJB5BL3mYVT+N/E7SwIWWpyH5+6bQECarJ41hUvd/JhH24ZWznKYUfawf3kS+Ggi/GhpKY5sXDQcgA+xxX6LePEIP87gfl7sTxM1REfdx0WY/2KvLGJZl4a3zARvY2mHq4VJ9ZS1uIpr/yY8iLIk5G12rwzRvOLArQ/1EXzWQHwpKTKO3ZkSB3e1j0WOCTiiNAcTf1kNaERiHOEPyQYOfvfj+TTY6iAt7JF3JSP6jeo9Xe/8bubf3/O7phkKRIC9+dIpoF8PaA70O4gERydGRNXUSwOH4fXoQywt00NOAUFFmjngNH5BwB2t4v5RC1by1VMvDIN6qM6RqEMDo0g2CEkXN54SKleI0m2maq2cTo/ay7B3toMx48tyt0l9zZY+KA6IcJ5EpV0n1BAwjHdrkNyhR/crnyVVUw3XNTIkCYavdI6xNOwDSY+n8REkQObYIfXXJ+Z/6Vi7gH0c74DzkKxWKR3tWuqgIkkhAHIJrHmUmBQEWp7v0oJUiccwhPqtRg6kJb9J2M4/OLwLx9ECHmC1JI+QMtdFkD0qsSeUTSU3EmyzQFWv4eYdcoD/xuHZ6afzTpMgOgkNVBfSBirBEYugZmnDwpu
 qjETalAO
 hMMDToZ5V7IwslSsxKm68+U5TKVnO6tKqNHGWh63Et2jbWRXsZXm+pNDu3IQiiOmPhI+0QNfmYz9i3mHT3ovhsHt/5TKvUfiN0g7lyfZ0GTEAhJsxy6+9cQpetCPZgzCsiX5BsPI2/O/RPNxjn72UfT05EG592tHqjpQ4cS5PYzQgOutFQWqvlsIlRP6VCnQunbzu2H79eR77uEO0DPy4+v7s3/9fhRdL4lrpZuP8IALmUvBDC+vtSiYa31jPD+LsXIDF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kumar Kartikeya Dwivedi <memxor@gmail.com> writes:

> On Mon, 18 Aug 2025 at 19:02, Roman Gushchin <roman.gushchin@linux.dev> wrote:
>>
>> To effectively operate with memory cgroups in bpf there is a need
>> to convert css pointers to memcg pointers. A simple container_of
>> cast which is used in the kernel code can't be used in bpf because
>> from the verifier's point of view that's a out-of-bounds memory access.
>>
>> Introduce helper get/put kfuncs which can be used to get
>> a refcounted memcg pointer from the css pointer:
>>   - bpf_get_mem_cgroup,
>>   - bpf_put_mem_cgroup.
>>
>> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
>> cgroup's "self" css. It allows it to be used with the existing cgroup
>> iterator which iterates over cgroup tree, not memcg tree.
>>
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  include/linux/memcontrol.h |   2 +
>>  mm/Makefile                |   1 +
>>  mm/bpf_memcontrol.c        | 151 +++++++++++++++++++++++++++++++++++++
>>  3 files changed, 154 insertions(+)
>>  create mode 100644 mm/bpf_memcontrol.c
>>
>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>> index 87b6688f124a..785a064000cd 100644
>> --- a/include/linux/memcontrol.h
>> +++ b/include/linux/memcontrol.h
>> @@ -932,6 +932,8 @@ static inline void mod_memcg_page_state(struct page *page,
>>         rcu_read_unlock();
>>  }
>>
>> +unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>> +unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap);
>>  unsigned long memcg_page_state(struct mem_cgroup *memcg, int idx);
>>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum node_stat_item idx);
>>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>> diff --git a/mm/Makefile b/mm/Makefile
>> index a714aba03759..c397af904a87 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -107,6 +107,7 @@ obj-$(CONFIG_MEMCG) += swap_cgroup.o
>>  endif
>>  ifdef CONFIG_BPF_SYSCALL
>>  obj-y += bpf_oom.o
>> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>>  endif
>>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>>  obj-$(CONFIG_GUP_TEST) += gup_test.o
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> new file mode 100644
>> index 000000000000..66f2a359af7e
>> --- /dev/null
>> +++ b/mm/bpf_memcontrol.c
>> @@ -0,0 +1,151 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Memory Controller-related BPF kfuncs and auxiliary code
>> + *
>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>> + */
>> +
>> +#include <linux/memcontrol.h>
>> +#include <linux/bpf.h>
>> +
>> +__bpf_kfunc_start_defs();
>> +
>> +/**
>> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>> + * @css: pointer to the css structure
>> + *
>> + * Returns a pointer to a mem_cgroup structure after bumping
>> + * the corresponding css's reference counter.
>> + *
>> + * It's fine to pass a css which belongs to any cgroup controller,
>> + * e.g. unified hierarchy's main css.
>> + *
>> + * Implements KF_ACQUIRE semantics.
>> + */
>> +__bpf_kfunc struct mem_cgroup *
>> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
>> +{
>> +       struct mem_cgroup *memcg = NULL;
>> +       bool rcu_unlock = false;
>> +
>> +       if (!root_mem_cgroup)
>> +               return NULL;
>> +
>> +       if (root_mem_cgroup->css.ss != css->ss) {
>> +               struct cgroup *cgroup = css->cgroup;
>> +               int ssid = root_mem_cgroup->css.ss->id;
>> +
>> +               rcu_read_lock();
>> +               rcu_unlock = true;
>> +               css = rcu_dereference_raw(cgroup->subsys[ssid]);
>> +       }
>> +
>> +       if (css && css_tryget(css))
>> +               memcg = container_of(css, struct mem_cgroup, css);
>> +
>> +       if (rcu_unlock)
>> +               rcu_read_unlock();
>> +
>> +       return memcg;
>> +}
>> +
>> +/**
>> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
>> + * @memcg: memory cgroup to release
>> + *
>> + * Releases a previously acquired memcg reference.
>> + * Implements KF_RELEASE semantics.
>> + */
>> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>> +{
>> +       css_put(&memcg->css);
>> +}
>> +
>> +/**
>> + * bpf_mem_cgroup_events - Read memory cgroup's event counter
>> + * @memcg: memory cgroup
>> + * @event: event idx
>> + *
>> + * Allows to read memory cgroup event counters.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_events(struct mem_cgroup *memcg, int event)
>> +{
>> +
>> +       if (event < 0 || event >= NR_VM_EVENT_ITEMS)
>> +               return (unsigned long)-1;
>> +
>> +       return memcg_events(memcg, event);
>> +}
>> +
>> +/**
>> + * bpf_mem_cgroup_usage - Read memory cgroup's usage
>> + * @memcg: memory cgroup
>> + *
>> + * Returns current memory cgroup size in bytes.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>> +{
>> +       return page_counter_read(&memcg->memory);
>> +}
>> +
>> +/**
>> + * bpf_mem_cgroup_events - Read memory cgroup's page state counter
>> + * @memcg: memory cgroup
>> + * @event: event idx
>> + *
>> + * Allows to read memory cgroup statistics.
>> + */
>> +__bpf_kfunc unsigned long bpf_mem_cgroup_page_state(struct mem_cgroup *memcg, int idx)
>> +{
>> +       if (idx < 0 || idx >= MEMCG_NR_STAT)
>> +               return (unsigned long)-1;
>> +
>> +       return memcg_page_state(memcg, idx);
>> +}
>> +
>> +/**
>> + * bpf_mem_cgroup_flush_stats - Flush memory cgroup's statistics
>> + * @memcg: memory cgroup
>> + *
>> + * Propagate memory cgroup's statistics up the cgroup tree.
>> + *
>> + * Note, that this function uses the rate-limited version of
>> + * mem_cgroup_flush_stats() to avoid hurting the system-wide
>> + * performance. So bpf_mem_cgroup_flush_stats() guarantees only
>> + * that statistics is not stale beyond 2*FLUSH_TIME.
>> + */
>> +__bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>> +{
>> +       mem_cgroup_flush_stats_ratelimited(memcg);
>> +}
>> +
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_ACQUIRE | KF_RET_NULL)
>
> I think you could set KF_TRUSTED_ARGS for this as well.

Not really. The intended use case is to iterate over the cgroup tree,
which gives non-trusted css pointers:
	bpf_for_each(css, css_pos, &root_memcg->css, BPF_CGROUP_ITER_DESCENDANTS_POST) {
		memcg = bpf_get_mem_cgroup(css_pos);
	}

Thanks

