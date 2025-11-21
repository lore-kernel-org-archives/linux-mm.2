Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79DBCFC29C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 18:03:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10DEF6B000E; Fri, 21 Nov 2025 13:03:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E5F16B0010; Fri, 21 Nov 2025 13:03:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3E1D6B0029; Fri, 21 Nov 2025 13:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0DD36B000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 13:03:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2031F160689
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:03:13 +0000 (UTC)
X-FDA: 84135385866.14.879F0A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 486A820018
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 18:03:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UVCk28fZ;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763748191; a=rsa-sha256;
	cv=none;
	b=4Di5FYuFJCSgy1AiFCWaBn+4U5jwBnDuEXWhPSKWqtMryFydRcHYMhPZ3Y+qUNYmC+wLeL
	oKpU7fGrwXzKlnS8dKe9Yx3bafAQLxdZiFr9Y8UY4HZfivRDF6pvYrhd1PQoW1aExjO9KF
	IE9BjuaA0uVO6+g8ZgWN+OlfzMSOOdE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UVCk28fZ;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763748191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jTJHd/oI6HAFxUBZ2ga9xvOWXew8PhLyvCtlb3zwrRI=;
	b=NvIZ/rCO7eZsYAtuCorL0dM/HBJ9JQqXrkWilPIKWVQeMqdeIXnQZHZxmCC28JsNvdd9ez
	LXgEz/3nrfGAvImbQBFTvtXM4zlWsOHXRf6jeJRB6jO73m0KVmgNwjajgvvo5npKr1mKHn
	2SPP8NMoQ7vtMJ8CQTmWNRBvvxpM09E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EE7DC417CF;
	Fri, 21 Nov 2025 18:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B58C4CEF1;
	Fri, 21 Nov 2025 18:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763748189;
	bh=mQlZ91jyc7X/wux2C7zhATU5EBZrjXavNWdp7ODBV5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UVCk28fZGnSCPDypK4tq7cV4Hb5MHAuaX8VMyfe2aT25S3UoWIspYmgdE405EDyQQ
	 mW9yDISISAIiaF1QxKvU8KmhzxTIGGFsIlypP0Vvx6Lkeko0DJkOBPGIpPRNm48awV
	 qoovOHu5YjTiGK4ZfdCMb3e0aS4bR+81lSyP5Q6c=
Date: Fri, 21 Nov 2025 10:03:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v9 1/2] lib: Introduce hierarchical per-cpu counters
Message-Id: <20251121100308.65b36af9e090a78a66144c6c@linux-foundation.org>
In-Reply-To: <20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
References: <20251120210354.1233994-1-mathieu.desnoyers@efficios.com>
	<20251120210354.1233994-2-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 486A820018
X-Stat-Signature: wjiyguz5grqtqqe76h91pgkrunbxushu
X-HE-Tag: 1763748191-573119
X-HE-Meta: U2FsdGVkX1/UihFknVyNRZnI4eCCGwyyHjKADIav5wt+CtWaDTLoYZUogDcULX2HKVpubxKoxIP8G2TjlFAdlU+RVQcdF4cQihQHvqBGBp5cvPITBaEE53FiMdFtjNzzJ7uHquXfz/T7jxbOldXO25Pgbd1qczYt6yx05O4PqRNQtbGIXh/5vwI/Eg/Plze+TSdR8nuif7MBnaV++77ccdM1vfbsxSMbxgEqzG+qOff8upZFsrfHfCrNJjQzhPqSGB7XR0tHuetDiZ0HuSQ4VVGyNucXpE3BRf5V46ZfTGTEC6g+gHBuT/S6PqZ4wrm8g3z1b1P+S9tDJHrsWnsNgANKjud1mActjfOJTImpWZ1CgD3kasU/oQLgtywTFp5PtJXttqK2OJQlBG5jZOh6UCVydKaBDpEroZAHLX/+mK6z1OY1GDL1MXvYL+DzlnTS9q8ag/76rp7Y7JfKI5Ohbz7u2ICWrbdA2kjcDgfZc5oK81l9lUw1ehI5si0j7k2Zjss7u9YpOotNpJlOYHWHwl6Mdgp9hix0QGsIgoi2akRQGH9bvk9h6WA0Pk13cIj0xs8yAvgTvgvqSrgR1hbILn8tJmFyiy/qNmaOlcPgpY5e897EdfLpYltri4YE3G10xgnrjuArk2C+A6wZyi7pzITLEFc0eOcUt+gfHSRfLCMt7O2VXm5WTsBEjxhaf6Qn2UOXC46oaU6ROp+myt8sEJ4YxTl8w5ApTsyRZ1+uz58O6vm8dpyzozUgbI9s14t7QuFruvRS7SS3pmTBfCNe8tKnjuRz7WgfeXv2eDefzVNzzWoBXDB3/5PYDrNFJis7q/DZAHKnT6JKjGGYkjgfzb+KldFVAqoqLL0JZgMhy65RBcOayQ7NLTnTYGRyPAagywT5kpumRKH8xeSph4nYfL3h2gWE4PQB43KnbvEgsbAKsLbpYe/BO+OHxCB2R469PCF+pqz87/V1kS/GF5c
 bdh6QzI3
 fM4UWWvJg6Vq6A2qIgki402+9Cu1WOcGzxjJ53GWH2R1WnyUMi6XPbnbeYcWR+GJ3RvOXGXC1x0rMXl67gTNNazRKkC36P75xQBoVTuE7YRL89Ni0safw0KkS/3M5AnYRdKbgGvTQammIIoXQsoQzm6N328wAkodSUXa0q8oGbzJ8IuYqV7EQ1vg0cdPOkQSBxg3o2TP2eQZ9Iu1g/9uwxLEkJDy6A0aiPHa9+L7ZrVPbki07IY8p0rxOmGb0kuPqwhUNgjJR604u9fT0T7sxiuaJzfbHu5j0y1UxjIrrFMakWQkjdiJ5HwHf2zDtMcu6auuWxzKiql3EbstLEj8gj81pFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 20 Nov 2025 16:03:53 -0500 Mathieu Desnoyers <mathieu.desnoyers@eff=
icios.com> wrote:

> * Motivation
>=20
> The purpose of this hierarchical split-counter scheme is to:
>=20
> - Minimize contention when incrementing and decrementing counters,
> - Provide fast access to a sum approximation,
> - Provide a sum approximation with an acceptable accuracy level when
>   scaling to many-core systems.
> - Provide approximate and precise comparison of two counters, and
>   between a counter and a value.
>=20
> It aims at fixing the per-mm RSS tracking which has become too
> inaccurate for OOM killer purposes on large many-core systems [1].

Presentation nit: the info at [1] is rather well hidden until one reads
the [2/2] changelog.  You might want to move that material into the
[0/N] - after all, it's the entire point of the patchset.

> * Design
>=20
> The hierarchical per-CPU counters propagate a sum approximation through
> a N-way tree. When reaching the batch size, the carry is propagated
> through a binary tree which consists of logN(nr_cpu_ids) levels. The
> batch size for each level is twice the batch size of the prior level.
>=20
> Example propagation diagram with 8 cpus through a binary tree:
>=20
> Level 0:  0    1    2    3    4    5    6    7
>           |   /     |   /     |   /     |   /
>           |  /      |  /      |  /      |  /
>           | /       | /       | /       | /
> Level 1:  0         1         2         3
>           |       /           |       /
>           |    /              |    /
>           | /                 | /
> Level 2:  0                   1
>           |               /
>           |         /
>           |   /
> Level 3:  0
>=20
> For a binary tree, the maximum inaccuracy is bound by:
>    batch_size * log2(nr_cpus) * nr_cpus
> which evolves with O(n*log(n)) as the number of CPUs increases.
>=20
> For a N-way tree, the maximum inaccuracy can be pre-calculated
> based on the the N-arity of each level and the batch size.

Looks very neat.

Have you identified other parts of the kernel which could use this?

>  include/linux/percpu_counter_tree.h | 239 +++++++++++++++
>  init/main.c                         |   2 +
>  lib/Makefile                        |   1 +
>  lib/percpu_counter_tree.c           | 443 ++++++++++++++++++++++++++++
>  4 files changed, 685 insertions(+)
>  create mode 100644 include/linux/percpu_counter_tree.h
>  create mode 100644 lib/percpu_counter_tree.c

An in-kernel test suite would be great.  Like lib/*test*.c or
tools/testing/.

> diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_c=
ounter_tree.h
> new file mode 100644
> index 000000000000..1f4938b67730
> --- /dev/null
> +++ b/include/linux/percpu_counter_tree.h
> @@ -0,0 +1,239 @@
> +/* SPDX-License-Identifier: GPL-2.0+ OR MIT */
> +/* SPDX-FileCopyrightText: 2025 Mathieu Desnoyers <mathieu.desnoyers@eff=
icios.com> */
> +
> +#ifndef _PERCPU_COUNTER_TREE_H
> +#define _PERCPU_COUNTER_TREE_H
> +
> +#include <linux/preempt.h>
> +#include <linux/atomic.h>
> +#include <linux/percpu.h>
> +
> +#ifdef CONFIG_SMP
> +
> +struct percpu_counter_tree_level_item {
> +	atomic_t count;
> +} ____cacheline_aligned_in_smp;
> +
> +struct percpu_counter_tree {
> +	/* Fast-path fields. */
> +	unsigned int __percpu *level0;
> +	unsigned int level0_bit_mask;
> +	union {
> +		unsigned int *i;
> +		atomic_t *a;
> +	} approx_sum;
> +	int bias;			/* bias for counter_set */
> +
> +	/* Slow-path fields. */
> +	struct percpu_counter_tree_level_item *items;
> +	unsigned int batch_size;
> +	unsigned int inaccuracy;	/* approximation imprecise within =B1 inaccura=
cy */
> +};

I find that understanding the data structure leads to understanding the
code, so additional documentation for the various fields would be
helpful.

> +
> +static inline
> +int percpu_counter_tree_carry(int orig, int res, int inc, unsigned int b=
it_mask)
> +{
> ...
> +}
> +
> +static inline
> +void percpu_counter_tree_add(struct percpu_counter_tree *counter, int in=
c)
> +{
> ...
> +}
> +
> +static inline
> +int percpu_counter_tree_approximate_sum(struct percpu_counter_tree *coun=
ter)
> +{
> ...
> +}

These are pretty large after all the nested inlining is expanded.  Are
you sure that inlining them is the correct call?


> +#else	/* !CONFIG_SMP */
> +
>
> ...
>
> +#include <linux/percpu_counter_tree.h>
> +#include <linux/cpumask.h>
> +#include <linux/percpu.h>
> +#include <linux/atomic.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/math.h>
> +
> +#define MAX_NR_LEVELS 5
> +
> +struct counter_config {
> +	unsigned int nr_items;
> +	unsigned char nr_levels;
> +	unsigned char n_arity_order[MAX_NR_LEVELS];
> +};
> +
> +/*
> + * nr_items is the number of items in the tree for levels 1 to and
> + * including the final level (approximate sum). It excludes the level 0
> + * per-cpu counters.
> + */

That's referring to counter_config.nr_items?  Comment appears to be
misplaced.

>
> ...
>
> +static
> +int __percpu_counter_tree_init(struct percpu_counter_tree *counter,
> +			       unsigned int batch_size, gfp_t gfp_flags,
> +			       unsigned int __percpu *level0,
> +			       struct percpu_counter_tree_level_item *items)
> +{
> +	/* Batch size must be power of 2 */
> +	if (!batch_size || (batch_size & (batch_size - 1)))
> +		return -EINVAL;

It's a bug, yes?  Worth a WARN?

> +	counter->batch_size =3D batch_size;
> +	counter->bias =3D 0;
> +	counter->level0 =3D level0;
> +	counter->items =3D items;
> +	if (!nr_cpus_order) {
> +		counter->approx_sum.i =3D per_cpu_ptr(counter->level0, 0);
> +		counter->level0_bit_mask =3D 0;
> +	} else {
> +		counter->approx_sum.a =3D &counter->items[counter_config->nr_items - 1=
].count;
> +		counter->level0_bit_mask =3D 1UL << get_count_order(batch_size);
> +	}
> +	counter->inaccuracy =3D batch_size * inaccuracy_multiplier;
> +	return 0;
> +}
> +
>
> ...
>
> +int percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
> +{
> +	return percpu_counter_tree_precise_sum_unbiased(counter) + READ_ONCE(co=
unter->bias);
> +}
> +
> +/*
> + * Do an approximate comparison of two counters.
> + * Return 0 if counters do not differ by more than the sum of their
> + * respective inaccuracy ranges,
> + * Return -1 if counter @a less than counter @b,
> + * Return 1 if counter @a is greater than counter @b.
> + */

It would be nice to kerneldocify the exported API.

Some fairly detailed words explaining the pros and cons of precise vs
approximate would be helpful to people who are using this API.

> +int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *=
a, struct percpu_counter_tree *b)
> +{
> +	int count_a =3D percpu_counter_tree_approximate_sum(a),
> +	    count_b =3D percpu_counter_tree_approximate_sum(b);
> +
> +	if (abs(count_a - count_b) <=3D (a->inaccuracy + b->inaccuracy))
> +		return 0;
> +	if (count_a < count_b)
> +		return -1;
> +	return 1;
> +}
> +
>
> ...
>
> +static unsigned int __init calculate_inaccuracy_multiplier(void)
> +{
> +	unsigned int nr_levels =3D counter_config->nr_levels, level;
> +	unsigned int level_items =3D 1U << nr_cpus_order;
> +	unsigned int inaccuracy =3D 0, batch_size =3D 1;
> +
> +	for (level =3D 0; level < nr_levels; level++) {
> +		unsigned int n_arity_order =3D counter_config->n_arity_order[level];
> +
> +		inaccuracy +=3D batch_size * level_items;
> +		batch_size <<=3D n_arity_order;
> +		level_items >>=3D n_arity_order;
> +	}
> +	return inaccuracy;
> +}
> +
> +int __init percpu_counter_tree_subsystem_init(void)

I'm not sure that the "subsystem_" adds any value.

> +{
> +
> +	nr_cpus_order =3D get_count_order(nr_cpu_ids);

Stray newline.

> +	if (WARN_ON_ONCE(nr_cpus_order >=3D ARRAY_SIZE(per_nr_cpu_order_config)=
)) {
> +		printk(KERN_ERR "Unsupported number of CPUs (%u)\n", nr_cpu_ids);
> +		return -1;
> +	}
> +	counter_config =3D &per_nr_cpu_order_config[nr_cpus_order];
> +	inaccuracy_multiplier =3D calculate_inaccuracy_multiplier();
> +	return 0;
> +}


