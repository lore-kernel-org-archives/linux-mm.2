Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289A2606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jb96h4h0
Received: by kanga.kvack.org (Postfix)
	id EB78C6B05B2; Tue,  3 Nov 2026 21:49:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60386B05B3; Tue,  3 Nov 2026 21:49:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F076B05B4; Tue,  3 Nov 2026 21:49:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A220E6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:49:24 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19ADA1203CE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:49:24 +0000 (UTC)
X-FDA: 85395905448.21.E8592E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5D59720006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:49:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb96h4h0;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793760562;
	b=OCgWMel3xlvEPUEUvBtTgggSreVC/cA9suDr09OHkI9gbvcDJ62VtK4irgRM6Mm1OCHVOr
	tps5OYpFLIDXVw4kT3N0gHuEge47SZELDYm4StItV2hIMBDQzhSm9s7xnb5yHYC6opdva+
	FxXCpQa3eblstOgKNXseCnB37YrjeRQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jb96h4h0;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793760562;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGl7bC3fWAoAUhJbWEmSTM5Y06Elv8KWXkaBb9P48hA=;
	b=PDvIVBiDQBlXjBUYLCtrzSPbyeOhsxzRvcifBG+KQOif7sz1RH6I8vYeu4lXj/iA2323qn
	B0uuGPSFpjL9p+rTitinSwnlPEfj6KuBRXXwCN1u6VnI3bfL9RqLkUGjgdM14DP13i/W1a
	ZHBvJwvTzrrjlkeW5cJTijBtQfjfD/U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DDAF43B2D;
	Wed,  4 Nov 2026 02:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 657D51F00919;
	Wed,  4 Nov 2026 02:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793760561;
	bh=cGl7bC3fWAoAUhJbWEmSTM5Y06Elv8KWXkaBb9P48hA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jb96h4h0oM3x4HuMId9uj2LqKZoeAZgCuatFL0X+g/wCJ7W3yMOe0X+dGWF5LZ1Bh
	 RJgMrUz3AHHIUC+Z4+HAGKWnlgwAZ9sGm1hChg1XwsbZwTUL/TrZPNINyYw/XIX/ZG
	 G30TzK2SZ8L+TUdKRouOFuOavuK9HgEczJgXAsaU0LjsPd6BEZYiIs9ndCujj6YC3M
	 74rzfop9P769vcC6l+1fnC6yfgQwNV3B8wKFg0bvJLdTiJ6mZxinQL54u8rpdtn6et
	 ThQeKLK7GDRuz9JleE7CZdoIlyEP2yoD0Isb0vVwMAbdqEsQGFhpadeotBCvbBSezs
	 SepM0zq9kLE7w==
Message-ID: <sashiko-outbox-196525@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 2/5] mm/show_mem: Avoid blocking on zone->lock
 during Oops or panic
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aaron Tomlin" <atomlin@atomlin.com>, pmladek@suse.com, john.ogness@linutronix.de, rostedt@goodmis.org, senozhatsky@chromium.org, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev, david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, kees@kernel.org, anna-maria@linutronix.de, frederic@kernel.org, tglx@kernel.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <20261103024453.922373-3-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
 <20261103024453.922373-3-atomlin@atomlin.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 02:49:19 +0000
X-Stat-Signature: 689yxa3xqe317hfu1gyoa1bpm41945jc
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5D59720006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793760562-964284
X-HE-Meta: U2FsdGVkX19VXQTUY+YuuIG20ezo/kxhvBj2KJ4GOVDUrVnUDNP8Ltc9OMdzjNDZhuGSFL0ieR4XV9oZTroSPAT1D52Lk0lUZw6+cH1u614mJzF7AQzItiUuf+D27mLqpNe8O4mlDCbeoe9uuNEC6ViplB/55l0tKLkWaRHhxEi2zvAe81pGmDFXr8/A44eE1LtpXPI1XII5hAcBmX3+F+LnnaMFLAkspaRgD4yQw440phwN4mMAMr0jRpiZB5SAndmocA6tIbXarCgv30cG2WesrONkOgDfaheHRyOAw2NwPYlhQPLR+8+PrHJRa/jXz3DrBzwR9v9F1wxgASW6spSAuvjDFB40eCfIOT/xImPEQzNgZigbQRvMLksohdeBEJ+VSPF+0Pu6KrY3jkI2Gr2SngPYzWcOdYWo+m32dJq1fxMzoBn+HrJoenwhs1+DxIWM3C2XlbqReVUyr6jtql9V99Tt436RWu9zcQbjEYaESaPujhKW8UeNND3kLQ/MBRV5ZOuyk/f/MKFdn8nqgmo0ZIzLrNgxruARtpvwGo+JPxgqdnAQIBtLPSLJEqm96oHqGq97RhF2wPZG8dEK2M0+/oGJthPIqkepu0cLuFant/S2fxvo1P5CP36JyYyHpFNqODDVJW9yfR/b/gmf7UX2bGF16Aiio6j/pVmz07miXG8BbIkN/FM185pfv8y7EeqT2YJHTuJvBOciMbsvGPxnZFT8tQC9K6UhKPGJcVcyaj4wtjC0ngLuN9TQ4cxd6HXlnd5s/dppKppxhHFGNww/dO5cFwj0/Td54s7hudcqjbJl4Lb8/oMLl6VmdgoEoE80EhY/B/pKbPFG3S7Of7kPRNn7z7BakylHNX1AkLj3iWFVgbFMNU9ypFuwC0usA1H3sqZKvZQLvZNMv428xu1/snRA/s7WZ6KG8GakUwdRJKJyjCoe40zlJ1OLO/BwL/0E1zAoidh6o8+whJy
 VbCUVPLr
 eDWVxERDdwkGdMkwxvqv2RkWCynlW6gWKTL8pShauc6R2VqwSD0a9nLnLtnzEocL/TKElN27vWw4RFL7xCPayBM+eNXP4EzY5nBbKZWXy5VNy9IX3lPNNVFpHIvDitiG5OJ8ILtH2qO+JrBsj3ZIL4PYXEkLHaXe2heUdjlgjAsd5wtBSkEZvRjUJ2gZc0IUcZe14PqbbO8VKD5Pl1jntmzSYg/6bagdiVR0bgX97oHROyWWEBXsvK2niA9xA5kg6QAnhSM5gIa7a8qsiAehcGB3pAvIvUGiU3uF9jhwPRB9/kAWPHOruoHv0q07WDEpqc22U6ImdIEKckN+0VFHpSrEvCGEIob/dQMCBJtLVyYy7Do6o9KCjzTikx3QVB7qgXwbFGjHhZZDwtgow872lvbBN2hrEJzIkQQ4PDJl4RtiB+TdpVnL4c4ZikfxRQhs2CNQVhFAhKDUshIfnMMrDHffRAqL1aJrzUSorICzOV+c1DBgpKcrkdtGB2y4kzMrcj4jaUd3y/G77/h9Lqvgz8JCwaATuQN6MW6bq6cECwrtD92Oa8VQO16cRaG+u7eERFpzvanEh08GhRs4ogPa5LbCFDlXKwdQ86PkkGgbiAaUGTZsgzqbT4ReZB6T2a14Tq+4GKnSPq4wIVXi3uLqWV/B4WfyGh9tr0FlQuS+oSaqczWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/show_mem: false lock contention warning in show_free_areas()
--

commit e1c6e11316c0b99b2f700b8251c5ed2b76aad84a
Author: Aaron Tomlin <atomlin@atomlin.com>

mm/show_mem: Avoid blocking on zone->lock during Oops or panic

This commit updates show_free_areas() in mm/show_mem.c to avoid uncondition=
ally calling spin_lock_irqsave() on zone->lock during Oops, panic, or NMI/a=
tomic contexts, skipping zones when acquiring the lock is unsafe or contend=
ed.

> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index b938cbcd774a1..77098077523a9 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -367,10 +367,17 @@ static void show_free_areas(unsigned int filter, co=
nst nodemask_t *nodemask,
>  			continue;
>  		if (show_mem_node_skip(filter, zone_to_nid(zone), nodemask))
>  			continue;
> -		show_node(zone);
> -		printk(KERN_CONT "%s: ", zone->name);
> =20
> -		spin_lock_irqsave(&zone->lock, flags);
> +		if (!can_spin_trylock() || in_nmi() ||
> +		    oops_in_progress || panic_in_progress()) {
> +			if (!can_spin_trylock() ||
> +			    !spin_trylock_irqsave(&zone->lock, flags)) {
> +				pr_warn("zone %s lock contended\n", zone->name);
> +				continue;
> +			}
> +		} else {
> +			spin_lock_irqsave(&zone->lock, flags);
> +		}

[Severity: Medium]
In show_free_areas(), when can_spin_trylock() returns false (such as in NMI=
 or
hardirq context under CONFIG_PREEMPT_RT, or in NMI context under !CONFIG_SM=
P):

mm/internal.h:can_spin_trylock() {
	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
		return false;

	/* On UP, spin_trylock() always succeeds even when it is locked */
	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
		return false;

	return true;
}

the inner !can_spin_trylock() check short-circuits before
spin_trylock_irqsave() is ever called, yet still prints "zone %s lock
contended" for every populated zone even when zone->lock is completely
uncontended.

The commit message also states:

  Check can_spin_trylock() and use spin_trylock_irqsave() when
  !can_spin_trylock(), in_nmi(), oops_in_progress, or panic_in_progress()
  is active

Additionally, because show_node(zone) is moved after spin_unlock_irqrestore=
()
below, skipping a zone here only logs zone->name (for example, Normal or
DMA32) without the NUMA node ID on CONFIG_NUMA systems.

Should the !can_spin_trylock() case avoid claiming that zone->lock is
contended (and match the commit message description), and should the skipped
zone message include the node ID?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103024453.9223=
73-1-atomlin@atomlin.com?part=3D2

