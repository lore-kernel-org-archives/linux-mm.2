Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C034606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 20:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KxFH9toQ
Received: by kanga.kvack.org (Postfix)
	id E74336B05E3; Thu, 12 Nov 2026 15:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD046B05E5; Thu, 12 Nov 2026 15:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E2D6B05E6; Thu, 12 Nov 2026 15:37:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94B806B05E3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:37:52 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3427380CE7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:52 +0000 (UTC)
X-FDA: 85427628384.29.941D32A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 781C5140007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:50 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxFH9toQ;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794515870;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yw2gO9XL3QanNi7jpRFSX/t+Ag1YoMoaq3Ti9/EqKMY=;
	b=a0psWnFXfvPzLI5iDfjbKU1CshooAuUMaY4C5FR18eSSx/Bw4mM8sz3dlF8PFlNy36oxQ+
	5SNvNdobibHpU/IxCueIi5ugqv1VfAf1ILfzxlpjpwB62+EnBjZTP+ENc/27Z3wTBI0ooS
	8nsUdmYarDJt6kE0E5ImNufuHpaFyYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794515870;
	b=0RUPDONmxGbsnt+ONvv9fS+3L62lzkVPKk+tuq6ypYeWh2qF9no62VibiuWSHhdaj6zxCy
	fKLGyTpfpzTEdQSzkOQpd3YhTD+KR98nJTKo2Mg6MvyJOi2SwqJyYSfpCpc4YFAdua2OP5
	hnsVFsYEeM/LewX7T57gwXwTSsUJYYU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxFH9toQ;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C6F8246428;
	Thu, 12 Nov 2026 20:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7541F000C6;
	Thu, 12 Nov 2026 20:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515869;
	bh=Yw2gO9XL3QanNi7jpRFSX/t+Ag1YoMoaq3Ti9/EqKMY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KxFH9toQ1aZCGgiWlOxNjazfYj92Kin92TfhRQFwVjl4/zIas4wKqNPfnPowoKUzk
	 zzqHuzB3XQMakiR+1j90TLR6jZxbCgNhj4XyUZ/EacHloc75At2+pkof3qTLPDMc/b
	 2+r/n+5B2gYgjt7Ox+qcRnmGQfehEpgPm21vcmiVRFrbxRq+6tazW8nUAiTQEBFB/c
	 ngkpUnSvWQZ3XWfYgabV4gYGX1qLibs6K9k+1uCKS1KqZLeeECZtahSz1I5ITZ2grN
	 ht8R+EiGV+0rosu2kmRl+odRTsYEpjGDwlzoUSsp52wn2KlpruZtjbMmzaW4tkFs++
	 0F+6ynx50P5ZQ==
Message-ID: <sashiko-outbox-211804@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v25 09/14] lib: percpu_counter_tree: test the limit
 counters
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
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Kees Cook" <kees@kernel.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>, "Alan Stern" <stern@rowland.harvard.edu>, "Andrea
 Parri" <parri.andrea@gmail.com>, "Will Deacon" <will@kernel.org>, "Boqun
 Feng" <boqun@kernel.org>, "Hugh Dickins" <hughd@google.com>
In-Reply-To: <20261111203626.95838-10-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
 <20261111203626.95838-10-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 20:37:47 +0000
X-Stat-Signature: 37td18t5fjrdtk6mfudrnqbg4q9br6rk
X-Rspamd-Queue-Id: 781C5140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794515870-334907
X-HE-Meta: U2FsdGVkX1+ibzyrLbUelkyDyA/z4/RjyLN57BTTNGru9RSYzk5d+ZUvIlA/j+oqBH/mIgQzymhAasKVmT4y6JeFL4BtPxRmbMgWdKYM200iu0stHTp8IOQhzAJiBx42kxurhAyaePhsUFNbPjBwd8U/S8xHNceik/z4u0b1sO1+RtuCDn33leaTxWkEwasPdfYTbZgxWWjwnCuaReEZqmsPA8uyRj3Jk4XmlB1VqtTaUXdWZIXoFWuJDeMeiry6uRpKvip7nfzyCBxfe+yYf0lIZS/jHSmTSrFCFahNCeSxNcq568fSR+RV7lcBScmiYOcqFTzTrLv/B9E3gpyZ6OUEFBcPjcWDSM/iHPQQDkhiRbNtQLuNBaExbrKo8dXJ58tSEbb+4nPB55/gMXHqIGpN8xf3JA/r7UcqByf7O4XSAuiGwHHgLHAq5kTOBxj7J87jw49E447Bt/ArE+U5zQG4S8st2qgczXSUw/SU7Ql+Dl/BuqLKV5fWS6pywkpMuhogpV9IqCAhRxPgyf265CrGoKOmpiZ+rTil38oQRFv2SL91eke2ZGDzdQZgFdCPsBSd4wbtQiLBxj29hONLwczpneX+qh4CUSZGMrcPdx4RNZujR2z1W/750zn5GaX5AkWQhxPFlXfWS/jGrpAf+SFR8G5BcBR6Oz5rkplCyr25HX4KzU0dhJUTWTJz0/4nRIn3REMihTTUn5K16XZnuEN53nPPS+XvpT3mj/NNAkjlOKFAN4llD/DasrQrxhSMfCHmlCJI/J6UKu493p1jA/iEyWUkTbX3jEzI2NGMJoVZs600A83C05LvpyY98p/YJvBQfiB9XtE15gx1PyvMnvJwyvrs6YSMo1yVsWDl00Ir19HtCVOV+8zEk4AaG/l7Fed1rljQSvA8cg1gAvlH5bK8hZYF2Oqx6Du+lLiExvUs5gqVsXyqnI9OUAW3VHh0Qf5qHv4tisn8/QsvuhP
 GBztdmV9
 JNMokKD06ZWqqRCqpjxd2tDjDGkiyBAW0fipJZjv9OZehP91QvtmoFwepa4mVmeHwgFNuBY0vRMme7rLGPiV3FDJX2qvfJO+zjlQ2kt4sQYtr65q9+oN/9GAgL/KzSTguyZIxNfJBykEtbRCeDJch//EK8Oxi32WyO2KjDfL4OPnjxF1KFvKRAKTz9qoRNUoY9NxWyUB+9+Su9ttZUiRLu37ZtOd1gAdj6d9rUiAdKh+xHrgUAt2aOhMC2yVkfuR/+YWBXxJBQspxwwYtghruyvV8HuI8QPBjODAtcmUEflroJ3o3TVIzlWDf6T5GZxKKEARIqoN8jy0gqyAb46FDTktVesmmJdctheuZMLrlc4pyOBQwGoPDvEKtUq32HxQIPq53MFHZfa7gb4s3xxTu6QJfV8h/moAvN+Pef0ctsj7SRzpJrUVQLWDQYj2dEp9QVfUyp90NZz5omBEsQN/0L3K/pB6Uj6sDtz+T9dDbTPv00jv8KXu10NHn1Cw7nZJF7uKR7SeqS0NYgSNmt43AyXyUXM18nAe88IyYLcsyCvDbTvZSAf5he3j3shtWXUIEPxjzMesJLPHS9xfQP2WlUO7jtJUjALHl/nDcuC740o0TplC7TTY/Ar4rVdFslT9sM5Yyr591E+6dpy3sb/BKWRkwvZT2+V8u9pAOAFBgpZr0tDibW4BMZ+sDMz1ixP8/Lr5C0CUY9DTp2s0j4dQHsPNguq23Ea++vSonxqiwkJESPDAFaGpHu09hfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] lib: percpu_counter_tree: unreachable subtraction in
  limit_worker_fn()
- [Low] lib: percpu_counter_tree: unordered sh->charged sub in
  limit_worker_fn()
--

commit ffee3ed89eb2ac6dc7c1033ea104470f2a5faf4e
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: percpu_counter_tree: test the limit counters

This commit adds KUnit and userspace hpcc harness tests for
percpu_counter_tree_limit, along with a stall hook in the userspace shim
to simulate concurrent updates while an addition carry is in flight.

> diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_cou=
nter_tree_kunit.c
> index 12bd5a4bbb459..bd99ab7ca1c07 100644
> --- a/lib/tests/percpu_counter_tree_kunit.c
> +++ b/lib/tests/percpu_counter_tree_kunit.c
> @@ -612,6 +612,177 @@ static void hpcc_test_contended_carries(struct kuni=
t *test)
>  		do_hpcc_test_contended_carries(test, 1UL << batch_size_order);
>  }
> =20
> +#define LIMIT_NR_OPS	100000

[ ... ]

> +static int limit_worker_fn(void *data)
> +{
> +	struct limit_data *ld =3D data;
> +	struct limit_shared *sh =3D ld->sh;
> +	unsigned int i;
> +
> +	/* Pairs with the release of started: max, target and nr_workers are se=
t. */
> +	wait_event(limit_wq, smp_load_acquire(&sh->started));
> +	/* Start together, so that the workers hold their amounts at the same t=
ime. */
> +	atomic_inc(&sh->nr_ready);
> +	while (atomic_read(&sh->nr_ready) < sh->nr_workers)
> +		cpu_relax();
> +	for (i =3D 0; i < LIMIT_NR_OPS; i++) {
> +		u32 x =3D limit_rnd(ld);
> +		unsigned long amount;
> +
> +		if (ld->held < sh->target) {
> +			/* Mostly small amounts, and one in 16 of a huge page. */
> +			if ((x >> 4) & 15)
> +				amount =3D 1 + (x >> 8) % (4 * sh->batch_size);
> +			else
> +				amount =3D 512;
> +			if (percpu_counter_tree_limit_add(&sh->limit, sh->max, amount)) {
> +				unsigned long charged;
> +
> +				charged =3D atomic_long_add_return(amount, &sh->charged);
> +				if (charged > sh->max)
> +					atomic_long_inc(&sh->nr_over);
> +				ld->held +=3D amount;
> +				atomic_long_inc(&sh->nr_added);
> +			} else {
> +				atomic_long_inc(&sh->nr_failed);
> +			}
> +		} else if (ld->held) {
> +			amount =3D 1 + (x >> 8) % ld->held;
> +			atomic_long_sub(amount, &sh->charged);
> +			percpu_counter_tree_limit_sub(&sh->limit, amount);
> +			ld->held -=3D amount;
> +		}
> +		if (!(i & 63))
> +			cond_resched();
> +	}
> +	atomic_long_sub(ld->held, &sh->charged);
> +	percpu_counter_tree_limit_sub(&sh->limit, ld->held);

[Severity: Low]
Can the relaxed atomic_long_sub() on sh->charged be reordered after
percpu_counter_tree_limit_sub() on weakly ordered architectures?

The comment above limit_worker_fn() notes that a free subtracts from
sh->charged before it reaches the limit counter so sh->charged never
exceeds the limit counter.  However, non-value-returning atomic_long_sub()
is unordered, and percpu_counter_tree_limit_sub() updates the per-CPU
level 0 counter via this_cpu_try_cmpxchg() without a barrier when there is
no carry:

CPU0                              CPU1
limit_worker_fn()                 limit_worker_fn()
  atomic_long_sub(..., &sh->charged) (reordered)
  percpu_counter_tree_limit_sub()
                                    percpu_counter_tree_limit_add() -> true
                                    charged =3D atomic_long_add_return(...,
                                                              &sh->charged)
                                    if (charged > sh->max)
                                      atomic_long_inc(&sh->nr_over);
  /* sh->charged sub becomes visible */

This can cause a false-positive KUnit failure on sh->nr_over.  Using
atomic_long_sub_return() or smp_mb__after_atomic() before
percpu_counter_tree_limit_sub() in both the loop and the final cleanup
would enforce the intended ordering.

> +	ld->held =3D 0;
> +	complete_work();
> +	return 0;
> +}
> +
> +static void do_hpcc_test_limit(struct kunit *test, unsigned long batch_s=
ize)
> +{

[ ... ]

> +	accuracy =3D percpu_counter_tree_approximate_accuracy(&sh->limit.counte=
rs[0]);
> +	/* A limit of twice the accuracy, oversubscribed twice: mostly within i=
ts accuracy. */
> +	sh->max =3D 2 * accuracy + 1;
> +	sh->batch_size =3D batch_size;
> +	init_kthreads();
> +	cpus_read_lock();
> +	cpus =3D select_worker_cpus();
> +	sh->target =3D 2 * sh->max / cpumask_weight(cpus) + 512;

[Severity: Medium]
Does setting sh->target to 2 * sh->max / cpumask_weight(cpus) + 512 prevent
limit_worker_fn() from reaching its in-loop subtraction branch?

In limit_worker_fn(), a worker only subtracts when ld->held >=3D sh->target
and never frees any held amount when percpu_counter_tree_limit_add()
fails.  Because the total held across all workers cannot exceed sh->max,
no single worker can ever reach ld->held >=3D sh->target when
sh->target > sh->max (which holds on 2 to 8 CPUs for both batch sizes, and
up to 64 CPUs for batch_size =3D 2 due to the + 512 offset).  Even with more
CPUs where sh->target <=3D sh->max, all workers start together at
sh->nr_ready and average sh->max / nr_workers each when the counter fills,
so once total held reaches sh->max with every worker below sh->target, no
further addition can succeed and no worker can subtract for the rest of
LIMIT_NR_OPS.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111203626.9583=
8-1-mathieu.desnoyers@efficios.com?part=3D9

