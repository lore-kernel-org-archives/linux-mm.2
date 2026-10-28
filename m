Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9451606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ESPtJ9Fz
Received: by kanga.kvack.org (Postfix)
	id DA11F6B05B2; Wed, 28 Oct 2026 18:26:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53196B05B3; Wed, 28 Oct 2026 18:26:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C422B6B05B4; Wed, 28 Oct 2026 18:26:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE3D6B05B2
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:26:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 140C540256
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:26:22 +0000 (UTC)
X-FDA: 85373469804.29.805246A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6D96110000B
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:26:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESPtJ9Fz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793226380;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PNj4uscEDJA7lFRD26FzmJBYBLYWktEqEUXjZeogWaU=;
	b=3XOZ14nyNRd0xoxqbvFXBZ7pt7Vef5JAe4V0Q51dOLf2eg9Z9h9jLVgdd27XOJ4cHxm8uJ
	gkX2HR2rxG2fPxBfHGVZTL2DCDLSE2fFL9WAGxhyM5C2DF3T1rQGNEhFqmoCsKNDKm4JaU
	qAPFawOfNnJJqVZe9xeiVt8F7OYn6nA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESPtJ9Fz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793226380;
	b=dNJIJZth+t5anFUXIdxplPJJzF1mg6CXBD9jlXTW8ihi4mV3NI9TRBAO3Tqc9srCW8JvNq
	7l82VskCLwxWgk3Fi5wMtvcdIGX+P6XwmhTR2q7Aui/G0DN0iBZ5mAUMNhj5Ns8mlKjVf+
	H9siAa9JdFNeCvuEmxHx35d8jleQGCc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C29CC600D1;
	Wed, 28 Oct 2026 22:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1CEB1F01825;
	Wed, 28 Oct 2026 22:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793226379;
	bh=PNj4uscEDJA7lFRD26FzmJBYBLYWktEqEUXjZeogWaU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ESPtJ9FzTu26amG3egMtt1oIa97coYNKtqPbnqSYykVgjFg/XznVyrXlDnZLRiePV
	 Y9oFJ8fg89/0A0cr+U/paeyPBjyO8KwDNRsBzn9GMsOjncSQveZl/91rAh8aJsontF
	 FCNeiU+017USZyKAUD+O7M2OE0IR3WTuszbCHV6goM/QZCqlnx2tkfRWVOSPNtJ1Qo
	 Kezc1MflAWjSRos/jg8lqXtg/BQY42YNmSrZn/UIXOLjqp8KQyAdzoCibN4IF1Dn1K
	 duuUIS91z6+VYv51/2BbCf7LsOQagaXs84Fc0shPiUOlDwYkEvyurUUtYEliaVTWW4
	 RgxTUciNcwh8Q==
Message-ID: <sashiko-outbox-188501@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] mm/kasan/kunit: Add double-free tests involving
 kfree_rcu_sheaf().
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kuniyuki Iwashima" <kuniyu@google.com>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Alexander Potapenko" <glider@google.com>, "Andrey Konovalov" <andreyknvl@gmail.com>, "Dmitry
 Vyukov" <dvyukov@google.com>, "Vincenzo Frascino" <vincenzo.frascino@arm.com>, "Hao
 Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, kasan-dev@googlegroups.com, linux-mm@kvack.org
In-Reply-To: <20261027222557.1072105-3-kuniyu@google.com>
References: <20261027222557.1072105-1-kuniyu@google.com>
 <20261027222557.1072105-3-kuniyu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 22:26:18 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D96110000B
X-Stat-Signature: rhxnr41q1ix31wmqbbjbtntynds9pnon
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793226380-622171
X-HE-Meta: U2FsdGVkX1+iz/54o1ZZs1QczIGPx17AUmahP65XTJe9SjFWcyZtdIG/0OulFCQLzhAniPzLhDj33Kx5lLZ40u4S41Nw9XKjp0uLIGcvbughAsxe73KV421pqgVd81n3Gw1IJbLhUx2NRvHXklyHUBVkHbWp410+Q5qQ/OkIcmzUEB/dQV3VKzwdf4s3NxN8fwBlCaUQg0Q+FjOctV1CEToFrr2YM/VElLhIqQ6KeAJ9mFglakPXXI4Bi735KECBfM3hMpg7lJTqgBrB6docLZOUfTWkJHcNLUbNgDh5OCcZ5e8y0xE26q8LdLoMmewLkUgHhDFIRIyXjg+U0BDPNp1KQyRlzq1JFXkFF88670daX2Tm4nI9eUoDTMS0W75Wiaop4m7URWVRteAyu+LLD+ckcFJmBoGSACtyGre0zoRzXPBJwQJWJFXqGTshTc30i3hDnBj0/1HmN74KJj6t0kWYfU2bp9L6AyU+GomnQJrU6bFNgH9cgRKzBq/tTeQmuGxaX2ZsyQvAvZH3lCicAszmyKaHL35mDTL3R7TDg2ywjTtMLdb6H+Ti9gGh2DUwCyD0lBFr7iI38UGxi6SHvbBVU42pNoTnhxc3V/vLu1nZlSR6vxO7razZ020AvlLe6EQoGmaFZo2quK6GVKBJCGOzBMB1tcKy5Rwed+DlQCNf0P58DvNmFYcCaJxZzOOnWyDlDx6W8acGuyx+pizv3VJ+gRG9MYVn/XvJ3naohWXpYH0gOw7b6m8wqBWyrMKxUhzYwNWkSShZGP5bbyUIpFngp0qFn8gL1VjHdBPZjjSAd/CIIs4wdgpCs175f3jqf7DXtjA3ZzOQRvSkdnzXqRh21dZifJNXypua5OW4I/h5UTRTUTvMFx/VqefvZMv+EZNahZkgtIbxkSqem5EvwY9MnrCKWPZvYtQKq065z4kwoo0sbvgaFFNZoE9gNkD0X77r+h+6YS9mrPIhkGq
 jH13GJcU
 EIQYs13buPZI4vW//cwbdn1/dbAz5Ioy4kVY38ckXRyflYcBHNxerHRaSMqVNPRssKSYTAnthmnkxfcVnVIxEtDJP1lW77wyW2B2LGEoTAtK8Wg9zuiGanQYqe/6u8x1yKJ+CyRh+2KhbrqZCUCzwZ66R8xOIFqwV5+DBUkiKQ55GZnJaSCm+shwYo3NQ+1RaVvQzWJgq2WvFmuLO4gP1LeKrx8fxXkRAGvzN/WwgyJZvwjaxw5aICqJJBn1aNNZuBkUjHomA+XyqTEjDOY0Vk1CnStUDCAR1FtYw4Vkx1E6STwm8HGEQs9sa51b5QZREd6MjDv+K348zbLGAxsITC8o7KFAaTe6e8ePR8q66TFw7558IM0msK/tERk+8Sc3+I3IOhMzwOBU6ZfWDj51ysvLVUfqsJkfYbBSUi3mk0h96UJT8zSEHASBwZdcQDEGSnEeoOaW95sqyZLLDpcKeLR5uZpNDSfAEUsxfyeOtYSAK9k47qS00cjVBQ4e9ajN2S3Vp17WqfTkb1FOZs/3z32iIoARyurlkc4N4/1xZwZHlRYIVIqFzq3Hj4glf6JPg+Mg+hcHWYk6Pslpn7R/Sj2HhJ2vuYAv1kTrzPZyylyieKqqZZMEggdeSepTgnqzcNgZd9D4HDh9VpBZLJnyAilILNo2c/Fx+d4RTQji97b+QCw4x20KmxYriqsPWfFCf5D0Gf+izL2LeeKeoOJQFxrvSgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] mm/kasan: missing Kconfig guards in __kmem_cache_double_free_rcu=
()
- [Medium] mm/kasan/kunit: CPU and NUMA migration race in __kmem_cache_doub=
le_free_rcu()
--

commit 2267f8620b312bfdd7e76e11214e3ba726322685
Author: Kuniyuki Iwashima <kuniyu@google.com>

mm/kasan/kunit: Add double-free tests involving kfree_rcu_sheaf().

This commit adds KUnit test cases to verify that KASAN immediately detects
double-free combinations involving kfree_rcu_sheaf() and prevents a
reallocated victim object from being poisoned when the RCU sheaf is flushed.

> diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> index b9e167ed5be32..83c418c0ef878 100644
> --- a/mm/kasan/kasan_test_c.c
> +++ b/mm/kasan/kasan_test_c.c
[ ... ]
> @@ -1070,6 +1071,134 @@ static void kmem_cache_double_free(struct kunit *=
test)
>  	kmem_cache_destroy(cache);
>  }
> =20
> +#ifndef MODULE
> +static void __kmem_cache_double_free_rcu(struct kunit *test, int mode)
> +{
> +	struct kasan_rcu_info *p, *victim =3D NULL, **objs;
> +	struct kmem_cache *cache;
> +	int i, n =3D 0;
> +
> +	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
> +
> +	cache =3D kmem_cache_create("test_cache", sizeof(*p), 0, SLAB_NO_MERGE,
> +				  NULL);
> +	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
> +
> +	if (!cache->sheaf_capacity) {
> +		kmem_cache_destroy(cache);
> +		kunit_skip(test, "Test requires sheaves");
> +	}

[Severity: Medium]
Should __kmem_cache_double_free_rcu() also check that
CONFIG_KVFREE_RCU_BATCHED is enabled and CONFIG_PREEMPT_RT is disabled?

In calculate_sheaf_capacity(), cache->sheaf_capacity is set to a non-zero
value whenever CONFIG_SLUB_TINY is disabled and debug flags are not set on
the cache, regardless of CONFIG_PREEMPT_RT or CONFIG_KVFREE_RCU_BATCHED.
However, kvfree_call_rcu() in mm/slab_common.c only calls kfree_rcu_sheaf()
when CONFIG_KVFREE_RCU_BATCHED is enabled and CONFIG_PREEMPT_RT is disabled:

mm/slab_common.c:
#ifndef CONFIG_KVFREE_RCU_BATCHED
void kvfree_call_rcu(struct kvfree_rcu_head *head, void *ptr)
{
	if (head) {
		kasan_record_aux_stack(ptr);
		call_rcu(&head->head, kvfree_rcu_cb);
		return;
	}
...
#endif

and in the batched implementation:

mm/slab_common.c:kvfree_call_rcu() {
	...
	if (!IS_ENABLED(CONFIG_PREEMPT_RT) && kfree_rcu_sheaf(ptr))
		return;
	...
}

When CONFIG_PREEMPT_RT=3Dy or CONFIG_KVFREE_RCU_BATCHED=3Dn (for example wi=
th
CONFIG_RCU_STRICT_GRACE_PERIOD=3Dy or CONFIG_TINY_RCU=3Dy), cache->sheaf_ca=
pacity
is non-zero so the test does not skip, but kfree_rcu(p, rcu) bypasses
__kfree_rcu_sheaf() where kasan_slab_pre_free() and
kasan_mark_rcu_free_pending() are called.

Wouldn't this cause KUNIT_EXPECT_KASAN_FAIL() to fail across all three mode=
s,
free and poison the reallocated live victim object during
kvfree_rcu_barrier_on_cache(cache) in modes 1 and 2, and queue the same
p->rcu head twice in mode 3?

Adding KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KVFREE_RCU_BATCHED) and
KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_PREEMPT_RT) would skip the test on
configurations where kfree_rcu_sheaf() is not used.

> +
> +	objs =3D kunit_kcalloc(test, cache->sheaf_capacity * 2, sizeof(*objs),
> +			     GFP_KERNEL);
> +	if (!objs) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +
> +	p =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +	if (!p) {
> +		kunit_err(test, "Allocation failed: %s\n", __func__);
> +		goto out;
> +	}
> +
> +	switch (mode) {
> +	case 1:
> +		kmem_cache_free(cache, p);
> +		/* p is already in quarantine. */
> +		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> +		break;
> +	case 2:
> +		/* The actual free order is inverse. */
> +		kfree_rcu(p, rcu);
> +		KUNIT_EXPECT_KASAN_FAIL(test, kmem_cache_free(cache, p));
> +		break;
> +	case 3:
> +		migrate_disable();
> +		kfree_rcu(p, rcu);
> +
> +		for (i =3D 0; i < cache->sheaf_capacity - 1; i++) {
> +			objs[i] =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +			kfree_rcu(objs[i], rcu);
> +		}
> +
> +		KUNIT_EXPECT_KASAN_FAIL(test, kfree_rcu(p, rcu));
> +		migrate_enable();
> +
> +		/*
> +		 * Move the 1st full sheaf to quarantine, keeping the
> +		 * 2nd in pcs->rcu_free.
> +		 */
> +		rcu_barrier();
> +		break;
> +	}
> +
> +	/*
> +	 * Move p to quarantine if not poisoned yet (case 2,
> +	 * or fallback in case 3).
> +	 */
> +	if (kasan_byte_accessible(p))
> +		kvfree_rcu_barrier_on_cache(cache);
> +
> +	/*
> +	 * Evict p from quarantine and reallocate it as a live victim object
> +	 * before the RCU sheaf is flushed.
> +	 */
> +	kasan_quarantine_remove_cache(cache);
> +
> +	for (i =3D 0; i < cache->sheaf_capacity * 2; i++) {
> +		objs[n] =3D kmem_cache_alloc(cache, GFP_KERNEL);
> +		if (!objs[n])
> +			break;
> +		if (objs[n] =3D=3D p) {
> +			victim =3D objs[n];
> +			break;
> +		}
> +		n++;
> +	}
> +
> +	for (i =3D 0; i < n; i++)
> +		kmem_cache_free(cache, objs[i]);
> +
> +	KUNIT_EXPECT_PTR_EQ(test, victim, p);

[Severity: Medium]
Can task migration across CPUs or NUMA nodes cause spurious failures in
__kmem_cache_double_free_rcu()?

Because kunit_try_catch_run() executes the test in an unbound kthread, the
task can migrate whenever migration is not disabled:

1. p =3D kmem_cache_alloc(cache, GFP_KERNEL) runs before migrate_disable() =
in
mode 3, and modes 1 and 2 do not call migrate_disable() at all. In
kfree_rcu_sheaf() in mm/slab_common.c:

	s =3D slab->slab_cache;
	if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa_mem_id()=
))
		return __kfree_rcu_sheaf(s, obj, SLAB_FREE_DEFAULT);

	return false;

If the task migrates to a CPU on a different NUMA node between allocating p
and calling kfree_rcu(p, rcu), slab_nid(slab) =3D=3D numa_mem_id() is false=
 and
kfree_rcu_sheaf() returns false, falling back to the non-sheaf
kvfree_call_rcu() path. This bypasses __kfree_rcu_sheaf(), causing
KUNIT_EXPECT_KASAN_FAIL() to fail and queueing the double-freed object into
krcp.

2. Following the switch block, rcu_barrier(),
kvfree_rcu_barrier_on_cache(cache), and kasan_quarantine_remove_cache(cache)
can sleep with migration enabled, and the victim reallocation loop also runs
without migrate_disable(). If the task migrates to another NUMA node before
or during the loop, refill_objects() only refills from local_node while
__refill_objects_any() skips p's node because n->nr_partial <=3D s->min_par=
tial,
allocating a new slab instead of p. Even on a single NUMA node, if the task
migrates to another CPU mid-loop after refill_sheaf() moves p into the first
CPU's pcs->main->objects[0], p remains in the first CPU's per-CPU sheaf and
KUNIT_EXPECT_PTR_EQ(test, victim, p) fails.

Would it make sense to wrap the initial allocation and free sequence in
migrate_disable() / migrate_enable() for all modes, and either keep the task
on the same CPU/node or use kmem_cache_alloc_node(..., folio_nid(virt_to_fo=
lio(p)))
under migrate_disable() when reallocating victim?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027222557.1072=
105-1-kuniyu@google.com?part=3D2

