Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F0BEE2095
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 12:24:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F1C6B0093; Fri,  6 Feb 2026 07:24:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CCB6B0096; Fri,  6 Feb 2026 07:24:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992E26B0098; Fri,  6 Feb 2026 07:24:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84A216B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:24:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14D7555DAD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:24:32 +0000 (UTC)
X-FDA: 84413949984.24.0528AE5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 592F51C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 12:24:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SW+q6pql;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770380670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8YMgaXaKYSTfy6EUgDeRjgdSwu/GV7rRTHtil9VHoQ=;
	b=EsNhR+wqdsSuNiZFI24SoVx+H6bEZIqbOyxzVtnnygVOkcoWV7NbVokJ+aPSmyzJezOPot
	EG6KNckcUsIdy84oFZPl5UtMcDpqfIC2tu1L1hpZxQ8RsR4Zm4gVbfVbHo856+hvpETqQa
	9jWdllcm6c7q5cThSmAOYy6qOSqJac0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770380670; a=rsa-sha256;
	cv=none;
	b=ffJK+uuvtgl3ByMsVKbrgBGsZU3dSGTd21r1h5l1F7K10S7sVM4sE370UHgsjrvwrRRb2L
	RE6rLCRe66cGhJqeEUDEMVi0TtZ9kt11VirTImwSiuHzwoheH+kDcB/nk4Qda94TNTR6Ls
	btb3EJTMlBG0y7kK7CEUZ+W2OOU5AAs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SW+q6pql;
	spf=pass (imf20.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4019A4430C;
	Fri,  6 Feb 2026 12:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9A1C116C6;
	Fri,  6 Feb 2026 12:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770380669;
	bh=rEj8825XpIjLqz10xvZxk8okcCuq9IEOjeV0yzx7rG8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=SW+q6pqlOtbtzBq78J3jdhFMf6Ph2Sc+gZOy2XrqSAb/JkBQ3uH3EkRsULTp4lrBB
	 rK/NElU/XWtGLGNrIGs9BFgubtLpmPtSCJDQxYjniONn1O11ChU3OoeDx2L85Ss929
	 NoANkYGsU8FlVkxnqA1SYr7H2yHfEuzbiqoENd8CtGI9KMXaeVivU2I9qFE6D9RwmW
	 7Owffc2vN0O7bPPv7Inz07gBrc2Tn6Ly91QmCO/vNOP4ptjYwoyqdmDNKWu4ssMtdd
	 IZEZcE2xeJPst/hiOOVd7+Yg/+VxFVJkhCryR5GhRxEy5A94YpJYD8qaNbmY4I9UOs
	 mXv8EZtgZreEw==
From: Thomas Gleixner <tglx@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben
 Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Frederic Weisbecker <frederic@kernel.org>, Neeraj Upadhyay
 <neeraj.upadhyay@kernel.org>, Joel Fernandes <joelagnelf@nvidia.com>, Josh
 Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>,
 Uladzislau Rezki <urezki@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi
 Yan <ziy@nvidia.com>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Ingo
 Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org,
 Qiliang Yuan <realwujing@gmail.com>, Qiliang Yuan
 <yuanql9@chinatelecom.cn>
Subject: Re: [PATCH RFC 03/12] genirq: Implement dynamic migration for
 Managed IRQs
In-Reply-To: <20260206-feature-dynamic_isolcpus_dhei-v1-3-00a711eb0c74@gmail.com>
References: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
 <20260206-feature-dynamic_isolcpus_dhei-v1-3-00a711eb0c74@gmail.com>
Date: Fri, 06 Feb 2026 13:24:25 +0100
Message-ID: <871piy12me.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 592F51C0006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: muyqr5srmmngdynbhowjtkz9usyoa5kw
X-HE-Tag: 1770380670-513936
X-HE-Meta: U2FsdGVkX18W6DvuvvuGOOiHcIq56xW7NrtcN08oBsZsSEqbC8We1u1YOFvYRktqskDewUTYeWp8Ceg0C9cjAx2PsUEfS37X9Y7u7HSMfsVSz0obIwZGM1TQugRCQlXp9RqyyTHK7WQ5sku7rYvhv5AEud1riROj+eOHkEbInzrwkCChZODWEbcQcoCsvAY+gc9kHwyX4seC5kpam3AYcRa56LwMueV0icSNyMN7X34c0bmqbQE3r+Ux8OlTvZylAz+HeveYvz+xh+ZgZMX7ERhe5u5nf4PFWC85hWqGAtrAG7a8NB9q100ZBfiiek8zWOU/zB58FY2BzlQH9KiUp3u5jQvX3AGwwh3Ncyj3zPgpPKH2CD7eDPRQ5eQjVvPqfdczFBTEuNQiNBFsNCrPz7jwjD3IFr2SxKM1YwEvopheMuwc9w9Meu1L1Ae9NUcaTCanq6RBtS9IsbZIOl53axDahZsMY7FVBuFCfW3ejoonIntIeh+hcH2+VP3XLsWU3GQId51wGd4l5TyuBCWPjyNcpO8frX2AKB9CWWEiVLwO75ABtXQ1AiGR9snIPdtdio5LmawjX6rIh8WoiMpfPJVt9oM8xvWue4DjN3r166AkMtRjj07t3x7Zafj7eXymjMCRDjlc6ntD2cmWzQv9vqnTQV/4+S/Pb5xDOWDduB0e0Et/CTfKiq2HkSghNFv6rihHZWXb9jiL09eB38jovRe6I/O1ykhDQHkc8ebDKhRdmFYUISc/ZA/QE/8/rDHhGZvHsrmVl60UV/Gja9yGh8fkfkSuVJvOwvEc58Nz40XmPISM8pDVEhrw5yTUuNizK7h3itLN/irwHlaTm2PQOzag8626CezIVUMb0pvUsvKV1JsaU09Fn3QTRktDhMHC1hTmKZkMWpJyCYEL1K1chStSaVz6dCiUiVUeu5SXtnssIH11hu7OjE1e0iyEyEKFnxq/dNNjm6GRnri8U8+
 Lry+2SJa
 bsr+ns6aXa0p6+wcG9n8LMHKdZPvnLU1Ud1o4VIDLcqZYNT1ziPLmsBARYkpkmQIGgEikV2KV1fiklLYD9A+cNfXGrZRFZvABJXKqBnIhLEgapFvZF4g1MlxRXsh0CvxY2tTCd2Bhs2kUl8HsjBsg68MBD85CIwSSxDbz4w2RhOrIPN4HhjtU2sPV7TgqEqQQRFcMEXjiaYPVx4ECqDsLn8Tf+7viU3ol4YxeAcPKFJY4diuDQHkxpwJbUVXqn4esltfnjxtK0c7wy4EyIQamZOXRa8+ffgGAo8AMzbcel3yTknW+Ggb1CebUP/YIauqEs43ovVTKkQKUdnSbV9NMP5ZVxUBd2YDMzmdDn1rEEZfX8rThsU26m9EukfMVONAlglDRDsqQkOwuRACwJvcvBAa4vue9e3EBnN+D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 06 2026 at 02:04, Qiliang Yuan wrote:

s/Managed IRQs/managed interrupts/ in $subject

> Support dynamic reconfiguration of CPU isolation by making the managed
> interrupts responsive to housekeeping mask changes at runtime.
>
> 1. Register a housekeeping notifier in the genirq subsystem to listen
>    for HK_TYPE_MANAGED_IRQ updates.
> 2. Iterate through all active interrupts when a mask update occurs.
> 3. Re-apply affinity for managed interrupts to ensure they honor the
>    newly configured housekeeping mask.
> 4. Use irq_set_affinity_locked() to trigger migration away from newly
>    isolated CPUs or towards newly designated housekeeping CPUs.

Please don't explain implementation details in the change log. They can
be seen from the patch. Explain the why and the concept of the change

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#changelog

> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>

So you developed that together with your alter ego? Pick one please.

> +#ifdef CONFIG_SMP
> +static int irq_housekeeping_reconfigure(struct notifier_block *nb,
> +					unsigned long action, void *data)
> +{
> +	struct housekeeping_update *upd = data;
> +	struct irq_desc *desc;

Move desc into the loop

> +	unsigned int irq;
> +
> +	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_MANAGED_IRQ)
> +		return NOTIFY_OK;
> +
> +	irq_lock_sparse();
> +	for_each_active_irq(irq) {
> +		struct irq_data *id;

id is really not a intuitive name. Most code here uses 'irqd'.

> +		desc = irq_to_desc(irq);
> +		if (!desc)
> +			continue;
> +
> +		scoped_guard(raw_spinlock_irqsave, &desc->lock) {

raw_spinlock_irq. There is nothing to save here as this is preemptible
thread context, no?

You can simplify all of the above by using:

	scoped_irqdesc_get_and_lock(irq, 0) {
        	struct irq_data *irqd = irq_desc_get_irq_data(scoped_irqdesc);

                ....

> +			id = irq_desc_get_irq_data(desc);
> +			if (!irqd_affinity_is_managed(id) || !desc->action ||
> +			    !irq_data_get_irq_chip(id))

No line break required. You have 100 characters.

> +				continue;

Thanks,

        tglx

