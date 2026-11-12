Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FB90606A331
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 20:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jnvEyjYh
Received: by kanga.kvack.org (Postfix)
	id 4FE336B05E0; Thu, 12 Nov 2026 15:37:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AF406B05E1; Thu, 12 Nov 2026 15:37:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A0A66B05E2; Thu, 12 Nov 2026 15:37:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F73D6B05E0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 15:37:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78BAF1A15AA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:47 +0000 (UTC)
X-FDA: 85427628174.29.2669CC0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE3AA40008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:37:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnvEyjYh;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794515866;
	b=giEus8aUJLJRa43OKfa6LYZQKbXDekXU5oxCAYDEqQJqSH0oReo6lEHsPhrrqIWm8KHJLn
	Sp2KO2xwggtuRCygmJb1UjKlI35QWyZy8HcIOHjOCFwoAnaW/lsimC1nKT/WZOx4yF3C9f
	Kj6lB+SVsCptj9tvZEJpAxiXZuHcOf0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jnvEyjYh;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794515866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KtLiidr5VBC14PgQKVf13G9N3QIxkXRWFwpONObXDvg=;
	b=mEwpQxKBZ7wpSpSrtYQiU4izZ8QWC+LJagNVRnzHjwAhcHep+7fzHb/ByrI2Q/J8d/pYlz
	LmSSpf0L4epubag2jabjkevOp02TbmMuYgtKhNFuZlciiGcORuUpIHxYK+HLIJctY38d3X
	5zY8W4mRThFtAbwyGFROnjBRZPMYQdk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B0D4462B7;
	Thu, 12 Nov 2026 20:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F4E1F000C4;
	Thu, 12 Nov 2026 20:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794515864;
	bh=KtLiidr5VBC14PgQKVf13G9N3QIxkXRWFwpONObXDvg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jnvEyjYhH510uW4MKIXNvaU9dtuncx+lTjfCm23DYoH31UutWiVa9ZhdpjrV5z5vo
	 dHGoIUBMA4kJXoUrZV5aZXd/PhZtx9t7lI7AihbAdB17YJxlIrQWlNTq+8MUiTDIOw
	 PYluf7eiiCWUyZGZw/Wh8pBO1c9gBQXzszi2yiZjIiWnPPb5MSiWWsNnEaNkkjqO9o
	 uST0GOo0T78AJn4whWqdrOqFljsJHbUbBpyqhkhPl4Sk0Cj7o2bdeUwl4iFE8yGMUp
	 H/m3+EksQSs1UGP03oOa2L/s62YS8R015WDnFaAtecubtZd+VhqASudwmm2N5NfwxX
	 n8UrRz0AdqshQ==
Message-ID: <sashiko-outbox-211801@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v25 06/14] lib: percpu_counter_tree: add lazy tree
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
In-Reply-To: <20261111203626.95838-7-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
 <20261111203626.95838-7-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 20:37:41 +0000
X-Stat-Signature: kx9z4ps6qshhjwkwt1tcyxurjb8u7ejh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CE3AA40008
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794515865-909619
X-HE-Meta: U2FsdGVkX1/PUc1+nQu90QVuOfAMrsYzEtPqhHgC9hCZjnzwZKPuWQf9sbf4AJmBb5ERlE1+gp/iAQOJpD3pcKwxiBtAIwRtPpjM6TE5kTyBy6rpfej6zDg1dKRTlhhqK4PTAEZAp4aEFy1a0D5D9hGABk1H1TA1pi/2xIzUV007kid5vhcJuFBtbBHnpWGE+XyOJguf4zGUbnc6lPykt5bTdtqmBz3hwb6ERCK1JcMODOKG6mZ/WyyoPjTZ4tvEe8jWocDogGRDadYU30j4sH1NvCoZ8Wa2G/jKB8ZMqLcJMKXj+5cRNN0i5D3nXOCAWfCkt3ILA1KnKU1jtqn9Htx72bf1rD3Mwd+2Me3x3mfOWbaUzznNfof1tfMZj1onsmOgKpgJJaCVB7TQu9YjinJ/mM12Dis8g3is0YjqfS+JJqSmoKD2go8pPYdhJ4kT7vpasYOBXpXNbOEPgoyPQxfCNA9rlGA1/EORELpfWEQTii8d3aIaePO3u5M66pAxzr2vLzbGVUCpkQgLdc/Py5WoTwwVkIyaSZ9m+hhhWMqzRY1/6PrfFGEEJ308Ajb+C5AI4+vw4dQ+/4fgB5TRcdnLKeeCyJNe74Nd4MbKCL5BDLXSr65KeGLRCVMXc/PFRsHpHX0xnfhLyk4DMRLQ6S81UvH7iZQHeQXATJZ+hH6K8ynhf/PeKQFz652gVhjUBA+dqh1ACA0C16/HO1Cx6FCDhcccOnDglYa6XPNM6EgWMJ27+2c8kNzrUs0gVWXXDSIB+64Js4kSIGdX4YSMl9tICaBIIAvP95i+6bGqPeivcN7FWdLA5LFDN0COwAKqNN9NuILlWRPdB326pbix9fR8xEUmsBcimV/3o2JVZkt1d5+c/Nae6sJt/DBtSN2ZgFQPYO2vA3X0rLjzqkIQXB8rJUzaH4SylMZW+PCSglbrirAyuVcsIGli/5zdfYgkCmMf/V/cb9Ron11Lpz4
 TdkSk0+/
 AJ2ZeaeTbCQfF5ha5KrJuV14Mv06SVPdf5emk1QoafBJDd6K3l53kIsfXmvlzqeLD2ofzyITGywTQYRyMefKyicb3+0pAdWx29FUnnMVU9DkiUyKvXUSpe/4vkrFv9al3RkwJff4JmZA1hu5+FQimO2LnTUxexdTVsb4AOTyGhYk+Zryp00BOEMG6xPYnTQQv/leMG2hAvEeP9K+Cx5Z/e8gI7kFxXpxy8F7GvXqSp7BYphjgiKXmzGgFQJ4+ojTEymlHoNZh41ysuCDEjzMmiGb0JNMHFIUe3tRax8TQfLpzvolHHn4/26tmh4GnVfpvGcVm3JTfMWc5Ar1BvGRs5tq5/q3GTmhdlOs5kmpQlTa3HtyzmSHtvHJaR+Khi/ivKkgRG76bKdeZ2MsqTYfQYVAok5x2oeklogpx8qAznAHLbxdBzp6zz1DaeTfj985eUZxkfk8uLryZRJPM4GS2OwZaN19IiksnVOWgAqE9p4A9SN9sSTQ1XokJnufiXcORXmdrsrBvEdTT0u2Lts3ayznAZ0IyBPfb+D8rr+p4HLXRCsPWVJ7fCbn3V0ssviDFJ8lsWoE8EF3qNLXYruj2OU5h776PUEosJzD1MxNH7/0ZpEIAmnl4lQbUVO2VOz72z9use9qrybmYNCyZ3O7Dlrp6LMIHHqc9/6VK+DZk+oOeTE9llTdnIcTqkVALpvIg1oGPUgls0ieYLn6Mq8VfkjiHJZ97to/4URW2ZQKo8oDW9LJxAgcyc23sMw==
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
- [Medium] lib: percpu_counter_tree_kunit: lazy_race_fn() serializes
  remote updates
--

commit 5130476e081ef221464be8ba2bb48a1905d08dcd
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: percpu_counter_tree: add lazy tree activation

This commit adds lazy tree initialization and activation for hierarchical
per-CPU counters, along with KUnit and userspace tests.

> diff --git a/lib/tests/percpu_counter_tree_kunit.c b/lib/tests/percpu_cou=
nter_tree_kunit.c
> index 5774278ea1403..12bd5a4bbb459 100644
> --- a/lib/tests/percpu_counter_tree_kunit.c
> +++ b/lib/tests/percpu_counter_tree_kunit.c
> @@ -796,6 +798,225 @@ static void hpcc_test_saturated_compare(struct kuni=
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
> +			/* Pairs with the test's release of go. */
> +			while (!smp_load_acquire(&sh->go))
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

[Severity: Medium]
Does acquiring sh->activate_lock in every non-owner worker right after
sh->go becomes true prevent percpu_counter_tree_add() from ever racing
with percpu_counter_tree_activate_many()?

Because both the main test thread and all non-owner workers serialize on
sh->activate_lock immediately upon release, the first caller to take the
mutex finishes activating and publishing the tree while the remaining
non-owner workers wait on the mutex.  None of the non-owner workers can
reach percpu_counter_tree_add() until activation is already complete, so
only the owner worker's percpu_counter_tree_add_owner() calls actually
race with tree publication.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111203626.9583=
8-1-mathieu.desnoyers@efficios.com?part=3D6

