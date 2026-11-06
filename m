Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73543606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NP4yg95p
Received: by kanga.kvack.org (Postfix)
	id 5C5686B05B0; Fri,  6 Nov 2026 15:37:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576956B05B1; Fri,  6 Nov 2026 15:37:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46BA46B05B2; Fri,  6 Nov 2026 15:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E65046B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:37:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5F0931601FA
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:37:41 +0000 (UTC)
X-FDA: 85405855122.05.E79D857
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id C29D3100002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:37:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP4yg95p;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997459;
	b=2z54ZNDSLFQNGyNIGGueVaF5YRh6iAeB7FQBpH9k/dPH5C2OpFq+fhXrPeQ8B5LF1oNJ9R
	hQQ1DXp/1Y9OpgbxQ+5VN6YW+CvdEtTIat+zPFUQ4tolvgEQ6XTp3Az3wz5DTGIyrR0UjF
	85Z/8Hvp0xctaqdGK4YsOKqdRx17COs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP4yg95p;
	spf=pass (imf14.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWYW9Jgrcl2gGnqyPsWBDQDSCZ0rVrf6t2LCxBUN6Ak=;
	b=ePPmCyv7+nPKG/gA2aJ5Mz4kxtonphNIWwMQ6Hi40kDZs6IuFlmzRRBQ/bfPqWtJOXT30R
	YCfhQ2Iv7W3xqROqsJIHddUZngfp4tEyf8SO9gXPOh+m4Glk3Nx7VAeh8oTswrgEYw+Ps+
	1FBO3jV97oDcFFboICmjpxgdLUmyAK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0E8D7601BF;
	Fri,  6 Nov 2026 20:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65201F0089F;
	Fri,  6 Nov 2026 20:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997458;
	bh=BWYW9Jgrcl2gGnqyPsWBDQDSCZ0rVrf6t2LCxBUN6Ak=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NP4yg95pp77J9I3+9dIx6Id5Ggm8gNQIz2izKKVMHv0vw7kDx8VIfyKmqJHnmsCug
	 hBZ5jehsIN4zS1HxdMHTb2p08EmTIKk6z5HQjqEcu8vrBe6xOX1Cp5sD+z2AER2fTZ
	 Cm8aOaSbqLkt4mvsx6fnENUDZUfTfae+9fFcilrGWl3T1hFky87QuPueb+qv0P5iHW
	 Eco9wj6XjPSK5kqya9tZKw/Y6W4JDvHVqTOAW0xuqdpFBU+Lgf0Q3bDpIxI8ZWo1ES
	 CHrrTz8MyLffHaqT88/W/aqyuzDiephCvxHY3m/KUFs2FJikGqQ2oN2SVWF4CXZcTU
	 oOzvxVP2TAlJg==
Message-ID: <sashiko-outbox-202244@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v24 06/10] lib: percpu_counter_tree: add lazy tree
 activation
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Martin Liu" <liumartin@google.com>, "David
 Rientjes" <rientjes@google.com>, christian.koenig@amd.com, "Shakeel Butt" <shakeel.butt@linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Wei Yang" <richard.weiyang@gmail.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "Yu Zhao" <yuzhao@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Mateusz Guzik" <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>, "David Carlier" <devnexen@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20261105203639.1459524-7-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
 <20261105203639.1459524-7-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 20:37:36 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C29D3100002
X-Stat-Signature: n5mpmuwsqydjhjkk3y5nfcozqsdidyem
X-Rspam-User: 
X-HE-Tag: 1793997459-462577
X-HE-Meta: U2FsdGVkX19S7bpanvK9RBdVsBl7LctRheJRhh0eq6a4+KVNeLOd40YEwVN/4LTN4kjwQdpXx4WDCDSfavObPoffDv6pA3Q/tt8xo1Os7b4RsyDLb/M8zH8w2sX4HI6F2h2VDjxmNFDMBukX9gT83EYUO3HqBuI52hMozfXayMUlfdEwng4YDKBFxF+XeegrQhbVaEClbRAAzzqthF9Uvyzcnap4A4agB4awy2Pn++LI0K/emPfw7lbv1A1jtzIMc8dJ8XNuPKE5/iDxPc5jIPMy5M8yO+vK+S87Wa1zQ+j5vvFMHiNj5NBanH/+Hc2bzuE7T+0L8rt7A75NYr6elSCwbisM/9lB9WplcQvEJbOUbssghgCdWu6U53iFY1XkDfeXycOXprhwHZhFHI9C8hAWXdjqfM0EmEjS3vj0dlayfTCaPDnj5FnxM55bms9Xjp7+F8Ca4FqEwDI8AYhamo1Emf8TywpBn76rur4vZkQ2D7lhIW09XoXfW9G1bGREvKOV+rwBkDBY7PhQ1rjNG6bpcH/+xHI14OxFn71g9xjsqceYuGAlMZUrTpjDzsgI0BNfOIQ0Gbr7v07UxT9RemYA94zcDcb+7dBZzZ0S5n+r1NG7WOeUbvQbQFsjDlMbvDBANLxyYImRqKgGrffJoA8oMcSpj54+hDJo0vvbw++EKzEaDv/rjAnTBkH2gKg3XDBUosf1+wClexjma76SUnZs6GaYpmmjWpZXjcSdiN5/pWHho6bjDMgTV98vDBklUdGwYvy/UKVjS5ycg9dbYKwc932/8wkucM3saBd6jzBuXeu1CHLPDlGYqte2Q1A4IA6D3PjwOSe32K1mEKgnpSqw3mXRsUac0DL3Dai2Txumw7oYXG6gY+DcNHoE0f9mT2p0AZZOZ7qJvi2q7IhAc6wKICaETOH2ZsywadH8puk36S4ZwmHxtmdxQu2QMuYzB2hN5nJpA355QX9o5Qy
 DS143vfW
 XimmaSzgHmKjFPCAXVuxk/a8lmSMVgKbPmRUl7te/VNXG2Yl3Kw5IhJqkxwcFdr54Ds/tTB2crLN/IIe72+5lHz58ucb95TavMT+40MmR/6qNvGXVFGsNZ0NMdUFvCtTedIHnG6w7GwrspcWM8UFaTJzQ3Znvy61D0BMVVhds/BfSyNBu3xlYDsIQKHf9fVIFh1ZzoqY1vq2rP8vU+2YeMxqqB8RrxR1VN1CrvHtCkzzYfD+OMDbiYEAX5bSPa9A23VIKfYIGKQu/CF2TNNNXNaQ4RX1sMahd/lYDiqtprSYo2UAtkUaJUuDzMwUAop4VXvUcjoo33AS7+FxCsMKiXqNvZqyIkJ7wF2nwDn9XestJDYROK5S1kfYuEnSZPGtGVqkNCnkcBUPf3JCfaJjC7ThZ7je6QQdO5i9NWnLUToel9ZU+qH4/hvyHYsBJc0oUmDAY9VrzMKNK1UfCd0/HEalXqUZh4wMcmAE8xf9qc2binsAMH6dmx0UIuA/95eAYylcBUgt11w6DzQxQgp7YDrQ0DMM29vQ1iFOWZEyZSnXpY9VDdnbPR7k3lQAiyb6GXJ7t8KJ9IrfWQAHFrgL1ilIGPbSzWfeaLLqmIE6KlZbhOrsp30kZ1M9DhZOYgVW2ZVPKXxFWvA2fdirtozjlrP6F2p8bmapf6hSG1qqMjDB0cRBvmpKDcIM1BTu5K3FMXVQX/vGgl3DMsJx0AtYOJtqqwZJ52HITk/5ptq3AzZ9MKh+p6Ya1XyBXbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] lib: percpu_counter_tree_kunit: missing release barrier on sh.go
--

commit badb1aea7bc81016992df61a32943f786fc44dcf
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: percpu_counter_tree: add lazy tree activation

This commit introduces lazy tree initialization and activation for
percpu_counter_tree so counters can remain exact without allocating per-CPU
or tree memory until activated. It also adds KUnit and userspace tests for
lazy counter updates and concurrent activation.

> diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_cou=
nter_tree_kunit.c
> index 5774278ea1403..156bb63de3466 100644
> --- a/lib/tests/percpu_counter_tree_kunit.c
> +++ b/lib/tests/percpu_counter_tree_kunit.c
> @@ -796,6 +798,220 @@ static void hpcc_test_saturated_compare(struct kuni=
t *test)

[ ... ]

> +static void lazy_race_fn(struct work_struct *work)
> +{
> +	struct lazy_race_work *w =3D container_of(work, struct lazy_race_work, =
work);
> +	struct lazy_race_shared *sh =3D w->sh;
> +	long sum =3D 0;
> +	int i;
> +
> +	for (i =3D 0; i < LAZY_RACE_NR_INC; i++) {
> +		long inc =3D (long)(get_random_u32() % 65) - 32;
> +
> +		if (i =3D=3D LAZY_RACE_NR_FIRST) {
> +			/* Fully ordered: the first updates are visible before the pause. */
> +			atomic_long_add_return(sum, &sh->first_sum);
> +			atomic_inc_return(&sh->paused);
> +			while (!READ_ONCE(sh->go))
> +				cond_resched();
> +			if (!w->owner) {
> +				mutex_lock(&sh->activate_lock);
> +				if (percpu_counter_tree_activate_many(sh->c, 1, GFP_KERNEL) ||
> +				    !percpu_counter_tree_active(sh->c))
> +					atomic_inc(&sh->activate_errors);
> +				mutex_unlock(&sh->activate_lock);
> +			}
> +		}
> +		if (w->owner)
> +			percpu_counter_tree_add_owner(sh->c, inc);
> +		else
> +			percpu_counter_tree_add(sh->c, inc);
> +		sum +=3D inc;
> +		if (!(i & 1023))
> +			cond_resched();
> +	}
> +	atomic_long_add(sum, &sh->expect);
> +	kfree(w);
> +	complete_work();
> +}
> +
> +static void hpcc_test_lazy_activation_race(struct kunit *test)
> +{
> +	struct percpu_counter_tree pct;
> +	int round;
> +
> +	if (num_online_cpus() < 2)
> +		kunit_skip(test, "needs at least 2 online CPUs");
> +	for (round =3D 0; round < 4; round++) {
> +		struct lazy_race_shared sh =3D { .c =3D &pct };
> +		unsigned long timeout =3D jiffies + 10 * HZ;
> +		int cpu, nr_workers =3D 0;
> +
> +		KUNIT_ASSERT_EQ(test, 0, percpu_counter_tree_init_many_lazy(&pct, 1, 3=
2));
> +		mutex_init(&sh.activate_lock);
> +		init_kthreads();
> +		cpus_read_lock();
> +		for_each_online_cpu(cpu) {
> +			struct lazy_race_work *w;
> +
> +			if (nr_workers > LAZY_RACE_MAX_REMOTE)
> +				break;
> +			w =3D kzalloc_obj(*w);
> +			KUNIT_EXPECT_NOT_NULL(test, w);
> +			if (!w)
> +				break;
> +			INIT_WORK(&w->work, lazy_race_fn);
> +			w->sh =3D &sh;
> +			/* The first worker is the owner, the others update remotely. */
> +			w->owner =3D !nr_workers;
> +			atomic_inc(&kernel_threads_to_run);
> +			queue_work_on(cpu, hpcc_test_wq, &w->work);
> +			nr_workers++;
> +		}
> +		cpus_read_unlock();
> +		while (atomic_read(&sh.paused) < nr_workers && time_before(jiffies, ti=
meout))
> +			usleep_range(100, 200);
> +		smp_mb();	/* Read the counter after the first updates of the workers. =
*/
> +		/* Every worker, the owner included, has updates left for after the ac=
tivation. */
> +		KUNIT_EXPECT_EQ(test, atomic_read(&sh.paused), nr_workers);
> +		/* Before activation, the owner and atomic updates are exact. */
> +		check_lazy_counter(test, &pct, atomic_long_read(&sh.first_sum));
> +		WRITE_ONCE(sh.go, true);

[Severity: Low]
In hpcc_test_lazy_activation_race(), can a weakly ordered CPU reorder the
relaxed WRITE_ONCE(sh.go, true) before the loads of pct.bias and
pct.atomic_bias inside check_lazy_counter()?

Before activation, pct.level0 is NULL, so
percpu_counter_tree_precise_sum_unbiased() returns early after
smp_load_acquire(&counter->level0) and atomic_long_read(&counter->atomic_bi=
as)
without issuing a barrier after reading atomic_bias and bias.

Once sh.go becomes true in lazy_race_fn(), the owner worker immediately cal=
ls
percpu_counter_tree_add_owner(sh->c, inc) without acquiring sh->activate_lo=
ck,
and remote workers proceed to activate and update sh->c.

Should sh.go be set with smp_store_release(&sh.go, true) (or preceded by
smp_mb()) so the pre-activation reads in check_lazy_counter() complete befo=
re
the paused workers resume modifying pct?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105203639.1459=
524-1-mathieu.desnoyers@efficios.com?part=3D6

