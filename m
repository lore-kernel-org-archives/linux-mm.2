Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A1FCC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD7B96B00E0; Tue, 14 Jul 2026 14:09:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB4B66B00E1; Tue, 14 Jul 2026 14:09:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CECB26B00E2; Tue, 14 Jul 2026 14:09:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5346B00E0
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:09:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23594A04AE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:27 +0000 (UTC)
X-FDA: 84988169574.08.956D393
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id AC6DAC000E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:09:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784052565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SszLXJMcqYtIVPmkLiJsJnkXN7FFEVXMgQpQ0/gWQmk=;
	b=FU/fhFT7rw0VDpaAVMqaHeF2DpafNZkkClBaq8Y31icfAN15cyUWxXq6Bnt+gb3c5asV5W
	SJmvXjpaZyFaMi7biAF3gTn0YQ2nkV3BtotJrJMKZN9DJ8qxNY8xpeQSd39XGQjmITgbLN
	htICrOmo1ua6aoGNJoxnb11q79umyKg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784052565;
	b=tfUX8wSQq+bcSR2/VAjDl31trEyOOmLVhxYd59XzNVsz6YJkGfAPj3Hr45iU/ktDjEp9CC
	rdoi06lHKSjkY7Py3c+pxapcdybsosSxfZg0pE3K6NwIPqXk8FN/dlvKoSMvsLCWZeKDUo
	wClmhFARmEHhKhb3XqaYzs4d35d4fw4=
Received: from unknown (HELO lgeamrelo04.lge.com) (156.147.1.127)
	by 156.147.23.51 with ESMTP; 15 Jul 2026 03:09:20 +0900
X-Original-SENDERIP: 156.147.1.127
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.127 with ESMTP; 15 Jul 2026 03:09:20 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 15 Jul 2026 03:09:20 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>
Subject: Re: [PATCH RFC 09/13] mm/swap: add priority queue for swap device
 allocation
Message-ID: <alZ7UBXweuuOX4qz@yjaykim-PowerEdge-T330>
References: <20260714-swap-pcp-priq-v1-0-de9b164ed419@tencent.com>
 <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714-swap-pcp-priq-v1-9-de9b164ed419@tencent.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC6DAC000E
X-Stat-Signature: aaikq5ha17jx4w59wbowoh1zsa48wn1u
X-HE-Tag: 1784052564-88798
X-HE-Meta: U2FsdGVkX1/8Morgd+Zf3T1UgC2CRwCMYtoPEu609pXZsktb8+YgJJ+hYs6o0T+c5urgVbpzbfxbqCdWlptNef3NVLmlBWQvfo2OUhrp5ThpOL40zFlXyFNFYz+XcCOhvJ7ixBIyu382p9qwg8nsGoDwInnG/86/sd0iNBcLjhXqe2j5CjbMClpxIR2hz7AznvmbS3CWu1HhrMdTWO+f91ViubszFxewQ5mdsrT6ewAtkWBezG6lJU50LGFxtLcVzGsYSNGvuHmnrIUQqBERUr/phpVZJDUh6MApKGQfXCSoIhHtf/pdtBy2ZFqIVat8mBvTRJOmtvUYzF3kaK/qpnn0y2YHXwRTEtiDiymA0Gv6iYvFOOxVv2WnfwI0t5oDaOjW2uypxr1AI0gtOGkArB+aAyMXlb9L0dbDxfRobHfcpeouNZcH6hbqL2yzncMLtbNjDCvDW6Rd1+tdHxJHUNEfMt71XVUL/2uexrBdkBdLA+cqxeJ0uFc30XyPe22NgkHb84iCYWI0LmxUGQU9dRJwjXxbBMDMLOxpN8+fyNuWQ2TaxXAg1/i3gdpK8gbqk6eKps7kAN7Qo3mieDqSMOLd2/ps7jgojNP1AGP9SHvjDgnbVdZslLtRligBA54XoywIZ3WhPuhs69INm95bUO0oHHydoIXcATF7+lPgObZgaqd8LzXNZeRH87gzwyK0DRmqo8s813i4r30NQoU7AQG1MHOGM1Ca5QR7wrE6C9FnCP1KwEuPWYJh9cz/YtrDxxlbUsXKqzQ81Q2XhrdliyIKIXjwTlxOnzfaDn68FMPq4WBIakvsSfXrSXaVUxZNaCQy/G8HiKjqWJjLKcCM4QAty/qprerHCw/50ge7Wbf8LzKZiBCZAqN+o42HfwMmRgM4nesVL59ImLbsW4lnA4cLo0LhOv9UaXrooYinWGwfgFdr+K9/jr3IpvJg5AOcBNHlCitNlmR4rVAALkD
 yb2sMn8f
 m5VKZt0f5f+m9KhiJJP2Nk004s+86O0vPNseFHKi8gjy6WuApdDgO95PDZ+IF/cXtGArDn7Kk4b1LYaO5E3fYhHPIpkWFcjgiTea/VEdLmNob90qaIuGPU3ybo9G4WZ6ej/8lpjc/mJCjTudGDOYss9iLNbGkYBaFKsucc8qNjbMBcRHiCBnSN4W5X47yqSa6pGe3ufZgfM8LI0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:25:47AM +0800, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>

Hi Kairui,

Thanks for the patch :)
I like the idea. A few questions and comments on the core implementation below.

I'll share my higher-level thoughts (e.g. on a tunable interface for the round-robin policy) 
separately in a follow-up.

> +/*
> + * All available swap_info_structs are grouped by priority rings, the rings
> + * are ordered in a queue by priority (lower prio value = higher priority).

looks like comment updated needed :)

[...]
> +
> +/*
> + * The ring is protected by swapon_rwsem so updating it is costly. To make
> + * the allocator and other users skip full devices faster, the lowest bit of
> + * a device pointer is used to mark it disabled (temporarily unavailable).
> + * This relies on struct swap_info_struct being sufficiently
> + * aligned (guaranteed by kmalloc).
> + */
> +#define SWAP_DEVICE_MASKED_SHIFT	0
> +#define SWAP_DEVICE_MASKED_BIT		BIT(SWAP_DEVICE_MASKED_SHIFT)

Unlike the old plist, full devices stay in the ring, so every
allocation keeps walking past them. When the higher priority
devices are all full, each swap out pays one masked pointer check
per full device before reaching a usable one. That is also the
steady state for swap tiering, so I want to be sure it stays cheap.
It looks like a deliberate trade-off of the static ring design.
What do you think?

[...]

> +static struct swap_info_struct *swap_queue_get_device(long nr_alloc, int nr_iter)
> +{
> +	bool rotate = false;
> +	struct swap_info_struct *si;
> +	struct swap_ring_iterator *ri;
> +	struct swap_prio_ring *ring;
> +	unsigned int queue_idx;
> +
> +	if (!swap_queue_len)
> +		return ERR_PTR(-ENOENT);
> +
> +	queue_idx = 0;
> +	while (nr_iter >= swap_queue[queue_idx]->size) {
> +		nr_iter -= swap_queue[queue_idx]->size;
> +		if (++queue_idx >= swap_queue_len)
> +			return ERR_PTR(-ENOENT);
> +	}
> +
> +	ring = swap_queue[queue_idx];
> +	local_lock(&swap_queue_readers->lock);
> +	ri = this_cpu_ptr(&swap_queue_readers->ri[queue_idx]);
> +	/* Rotate while iterating the ring, just not on the first try */
> +	if (nr_iter)
> +		rotate = true;
> +	else if (ri->rr_counter < nr_alloc)
> +		rotate = true;
> +	else if (ri->offset >= ring->size)
> +		rotate = true;
> +	if (rotate) {
> +		ri->offset++;
> +		ri->offset %= ring->size;
> +		ri->rr_counter = SWAP_ROUND_ROBIN_QUOTA;
> +	}
> +	ri->rr_counter -= nr_alloc;
> +	si = READ_ONCE(ring->dev[ri->offset]);
> +	local_unlock(&swap_queue_readers->lock);
> +
> +	if (swap_device_masked(si))
> +		return ERR_PTR(-EBUSY);
> +
> +	si = swap_device_unmask_ptr(si);
> +	return si;
> +}

Tasks interleaving on the same CPU can rotate the ring more than
once for a single failure, since the lock is dropped between two
get_device() calls of one allocation. A retry walk can then visit
one device twice and skip another. It is transient and looks
harmless, and every fix I could think of costs more than it is
worth.... 

Unless you have a better idea, how about noting it in a
comment?

> -/* Rotate the device and switch to a new cluster */
> -static void swap_alloc_entry(struct folio *folio)
> +static int swap_alloc_entry(struct folio *folio)
>  {
> -	struct swap_info_struct *si, *next;
> +	long nr_pages = folio_nr_pages(folio);
> +	struct swap_info_struct *si;
> +	int nr_iter, ret;
>
> -	spin_lock(&swap_avail_lock);
> -start_over:
> -	plist_for_each_entry_safe(si, next, &swap_avail_head, avail_list) {
> -		/* Rotate the device and switch to a new cluster */
> -		plist_requeue(&si->avail_list, &swap_avail_head);
> -		spin_unlock(&swap_avail_lock);
> -		if (get_swap_device_info(si)) {
> -			cluster_alloc_swap_entry(si, folio);
> -			put_swap_device(si);
> -			if (folio_test_swapcache(folio))
> -				return;
> -			if (folio_test_large(folio))
> -				return;
> +	percpu_down_read(&swapon_rwsem);

The local lock is only held inside swap_queue_get_device() now, so
the task can migrate between device selection and
cluster_alloc_swap_entry(). Then rr_counter is charged on one CPU
while the pages land in another CPU's cluster, so the pacing of
one cluster per visit does not hold anymore.

Since you want the loop to stay sleepable, how about
migrate_disable() around the loop?

> +	for (nr_iter = 0;; nr_iter++) {
> +		si = swap_queue_get_device(nr_pages, nr_iter);

When a ring has a single device, which is probably the most common
setup, the iterator does nothing useful. Would a fast path that
skips the local_lock and just reads ring->dev[0] for size == 1
rings sequentially be worth it? swapon_rwsem keeps the queue stable, so choosing
between the two paths should be race free, I think.

> +		if (IS_ERR(si)) {
> +			ret = PTR_ERR(si);
> +			if (ret == -EBUSY)
> +				continue;
> +			break;
> +		}
> +		cluster_alloc_swap_entry(si, folio);
> +
> +		if (folio_test_swapcache(folio)) {
> +			ret = 0;
> +			break;
>		}

[...]

>	del_from_avail_list(si, true);
> +	percpu_up_write(&swapon_rwsem);
>
>	/*
>	 * Swap allocator doesn't touch si lock, so looping through all
> @@ -3042,6 +3375,9 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>		return err;
>	}
>
> +	percpu_down_write(&swapon_rwsem);
> +	swap_queue_del(p);
> +
>	/*
>	 * Wait for swap operations protected by get/put_swap_device()
>	 * to complete.  Because of synchronize_rcu() here, all swap
> @@ -3062,7 +3398,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>	if (!(p->flags & SWP_SOLIDSTATE))
>		atomic_dec(&nr_rotate_swap);
>
> -	percpu_down_write(&swapon_rwsem);
>	spin_lock(&p->lock);
>	drain_mmlist();

synchronize_rcu() can take a while and it runs here with the write
lock held, together with wait_for_completion() and flush_work(), so
a single swapoff can stall all swap allocation during a little bit long time.

Only swap_queue_del() and the final teardown seem to need the write
lock. If my assumption is right, how about dropping it after
swap_queue_del() and re-taking it for the teardown? 

> @@ -3700,6 +4035,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>
>	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
>	percpu_ref_resurrect(&si->users);
> +	percpu_down_write(&swapon_rwsem);
> +	error = swap_queue_add(si);
> +	percpu_up_write(&swapon_rwsem);
> +	if (error)
> +		goto free_swap_zswap;
> +
>	swap_device_enable(si);

Thanks!
Youngjun Park

