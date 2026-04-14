Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053C9F9D0F6
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 21:21:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4580A6B0088; Tue, 14 Apr 2026 17:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409396B0089; Tue, 14 Apr 2026 17:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EC56B0092; Tue, 14 Apr 2026 17:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 202C06B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 17:21:45 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF28EB6D37
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:44 +0000 (UTC)
X-FDA: 84658433328.23.97ECFBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id EED7E1C0006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQorEc5E;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776201703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lIZYY27KZ5YOAbt+7u4b/E/zQ8UqizdoJrNUr2PrF1U=;
	b=Ly2idjnD8PCzEYxvzzFEl2rpKGNLzDoj1UbDpPbtjs6632/BtQpZd1xGu2P0tHZaA4A5V6
	+We6x+LKcaXfV5YZVUYPVl+wrynBesVKDsXJqYQLWR2s5qLjjeEo5yZENpmrObUvxwyavQ
	Eb76/t+O2YCjMh/SuxPvtg5R7ip7jbo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQorEc5E;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776201703; a=rsa-sha256;
	cv=none;
	b=TpL4tKq9GjmaoJ+YDvng0xAecH5IgKFcp3B1w3C86Lmb52l6uQNl6mbZMcoJ8PZ9jv2zdL
	kCofLoN514nx8U4mupNUZ75ISCqeuoA8zv1wT6dBPvAf7OpHFjJ9oAXggS5DX+9C96I1NT
	2PHsGBFN4p95g+3ixPmH3bmoeWNmqHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F50743575;
	Tue, 14 Apr 2026 21:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7142CC19425;
	Tue, 14 Apr 2026 21:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776201701;
	bh=OIzb9nHz1xFXK9FNEuXArnkzgdjXlnxKKe+O2ZtgjBc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YQorEc5Ep7W6OQlLT8ZrecYbkbyIa/mqJbW2/u4/uEt4ksFOLX7dw0kBgRo0mNnTt
	 qPilrsAf+nRMewxnxzVIi/6Es4/ubmEKGOpgwEz6FS7bBfuidjTrQ5X+nU//MQW0G5
	 C13akshGrRpIcC6dtbJyIVWrIf7rKS/DSyaKkwXpR/Uilv9TFcPM4jpn4PFiDqzNLg
	 5Rs6NFXN21FcghPyfNAnUrNoYd/+cs4g7Oaiaxkqo/1AXsbQB37bPU+QyLddomB5R/
	 DFiBTGuxJpYU64fd60pCaBH4VjKNQemCgj5SrQfOh7HNtiWKhqI38sT2RNnu7XAeiz
	 pmF4Sef0k7F6A==
From: Thomas Gleixner <tglx@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Anna-Maria Behnsen
 <anna-maria@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Tejun Heo
 <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal
 Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Johannes
 Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Waiman Long
 <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, Michal
 =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
Subject: Re: [PATCH v2 05/12] genirq: Support dynamic migration for managed
 interrupts
In-Reply-To: <20260413-wujing-dhm-v2-5-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-5-06df21caba5d@gmail.com>
Date: Tue, 14 Apr 2026 23:21:37 +0200
Message-ID: <87zf35dyqm.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: EED7E1C0006
X-Stat-Signature: xm4qsj633jish6ef4ctk38aujzx9655q
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776201702-158976
X-HE-Meta: U2FsdGVkX1+DnVh7MI3H6oQsKF2Y5byeqzFxm0IIervzhp4SWeO/TZ8Pp+jh12o+FFXJnxQ06mxYfeJzy4UOiWwD6db/qqpGeI+J+KKFanjmiY4v4SJIsay4F/37gELE62wJKz8qnUJL45S3S7e2ACEtREv6shLvgXXHAqffoJ6/9OcQARP208sB0+CJ764E2z0DE/rGYS8TuxKvrT0pixF2K+ebRPorro6TzcPlQF/6rA6ExKcTJ+LYtFTGXcZPFI6Z9u0V9fh/FN+8/npMKvjDKWxYZPgfPIXvW7M+07/iUGD8wHC9ldbQ00q6IvxEQv0eCeUh02km/5MjJIxaNpy5a0zdO4AMM/TNXI8q6xJfMJs3Es4lBVj7SnrPR2YTXpmrAA7IdrP7SFOdteebZP+EBAKSIm0ywEOWrVcg4NG4LWGb2wZh2sk71pY8K/MUbwpHRX0SBFEjsU6Bjmc9U3jBlVxo30VS1FvQ/CLl2qTgwBhsRnPo4pnL2QXUGgpFs8O4fIomdVkOI6Pf6Pno52Djo8PURZ8YWUnJHcix3kV6fMX5mI1lUI+RAMxuQIU9DRFL2eMiRH0D4iru66bE1HYeJvSJILnuWz+gllgD2Xv+Xq0Yt5ByRsbfyHhu/uUh/1i1wIiA5rHSQ+VB4qA8Dj47jzHt1xp75eSYJhkAhPcj/Pe1U5dL8ud2Dz3iB9ryGk4UEXUSRuNy42tuvHfBBnfCp598MbFbPQAPHdr4bCHDNUKoEZtbgW+QYsbz8m2q1ZahEDSZW984y1qDG1RuxsKq4Rlito0NTfBYOwghvqAIx0N7nkTSHA17WPuTchiZc/EoMXanGEDtO1IpHcQQ5ox82cZ4cCrKXC021lVVzqtsXAWo3qhHZkY470PM87K3Meftb9SmnZVDfd6zDfkZsP7h6HBjvEYHKJfaRopxt0HsMeGSOHhyJcqWL5R3BDvcKFokDnJ2CKZpPsWT/WE
 qV4zdJfL
 OUNUmiiL0xccU/TBQgqG62Zld+G+SlxLnQRG85MA2rd3snWFQkoLE80bfLjlY8xG1wBjgoBlTBiaYV+gf2jgYccTnfU0k3FWE2UZK0Q1wqqBnQChHjGUUaab5AaVmeI6HEu1AuqIdZboumZ39LSsktRkgggFXPhwDZLAd8fR+mn2wuWADGwDuXeyty/YGLq8q0nMCCkq8As2ukOsiCAHeQy2yCwFiLATgo46Llm0ZbIGvZx+4+Nx+VBeXDYnA/0fRExZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13 2026 at 15:43, Qiliang Yuan wrote:
> +	irq_lock_sparse();
> +	for_each_active_irq(irq) {
> +		struct irq_data *irqd;

Please move the declaration into the scope where it is used.

> +		struct irq_desc *desc;
> +
> +		desc = irq_to_desc(irq);
> +		if (!desc)
> +			continue;
> +
> +		scoped_guard(raw_spinlock_irqsave, &desc->lock) {
> +			irqd = irq_desc_get_irq_data(desc);
> +			if (!irqd_affinity_is_managed(irqd) || !desc->action ||
> +			    !irq_data_get_irq_chip(irqd))
> +				continue;

That's a pretty random choice of conditions.

> +			/*
> +			 * Re-apply existing affinity to honor the new
> +			 * housekeeping mask via __irq_set_affinity() logic.
> +			 */
> +			irq_set_affinity_locked(irqd, irq_data_get_affinity_mask(irqd), false);

That's not sufficient. Assume an interrupt was shut down before the
change because there was no online CPU in the affinity mask, but now the
affinity mask changes so there is an online CPU. What starts it up?
Same the other way around.

> +static struct notifier_block irq_housekeeping_nb = {
> +	.notifier_call = irq_housekeeping_reconfigure,
> +};
> +
> +static int __init irq_init_housekeeping_notifier(void)
> +{
> +	housekeeping_register_notifier(&irq_housekeeping_nb);
> +	return 0;
> +}
> +core_initcall(irq_init_housekeeping_notifier);

I fundamentaly despise notifiers especially when they are just invoking
something which is built in.

