Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5141FF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 191A36B009B; Tue, 31 Mar 2026 05:37:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BD56B009D; Tue, 31 Mar 2026 05:37:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A9B6B009E; Tue, 31 Mar 2026 05:37:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E30FB6B009B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:37:54 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8C5EA160BE6
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:37:54 +0000 (UTC)
X-FDA: 84605856468.23.EFDED32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id E1D50100002
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:37:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEvHkYAB;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCOBs1WBIQYVMy+oCHFW0oUZuCFk/RTHQQNLRE6aDQE=;
	b=Gmep5Oy5frnm9ogSEFMtduqVVQv8qEgV06u1hgbsMr2uJx9VqB58r+5zP6n/WXYeUYUo1y
	P8mFKxtMZmlNuyEdLKm2cpU8VQYa/nwDrgD8/vLGO1CFm6N/dFuj2an4SnAsLwH9IOLFHg
	7+nrH4SgOzz1Lq+N6K1t7lSSZF6iLWE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEvHkYAB;
	spf=pass (imf05.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949872; a=rsa-sha256;
	cv=none;
	b=IrtWMZlVBoAaboh+4AkLB/aLW8K+78G/7dhd0GMdY39vOe37dsoHIoZly4wAGZcemPFg5+
	z31yAbdbYkW5amGpV88g9wo6pxh8GOcZ/L2JTMHQbrpJvWmLeAwPMeT5biTe8xbAGy9TcO
	KKc89ZpXuzjKNDZ4okDEoNxV5nlAOjk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 434906001A;
	Tue, 31 Mar 2026 09:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77337C19423;
	Tue, 31 Mar 2026 09:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949872;
	bh=qe1fsS6EN1RbtUHByWfENaECxhHVAJNyIfc33jUhTA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CEvHkYABu2ykhLpVPrg5c9nD/W/EmL/3D4L2PXSpINOdvkVdnHg1v0dC62gLsqnW1
	 2BP0xz9zxBJCxQ6pxS69MynZJ17yI68NiDTd3Lx3On0VxdeZ/sdFHBQRD8D2BNVSLh
	 XN+6OYhhExKyax6upW8bxPS5cEWrTPZ4P/B47rQrwGsVU3jaGezy1ygNAHEWGevxtP
	 T3cnPJZHiX3+UMq5CcawDD6IrFJb4slqra59wrOwS4sz2vvj231GGqZejpoCubSvZI
	 zVR3Mr82DUONXdQxRvksPRO6MyIQxi/J6nz1sEut/EojbUfMBn/AAl1ODuMYhxF9SX
	 yfaDoIPFsz4UA==
Date: Tue, 31 Mar 2026 11:37:49 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 04/15] genirq: Support dynamic migration for managed
 interrupts
Message-ID: <acuV7V_7Z7X3dhhV@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-4-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-4-919cca23cadf@gmail.com>
X-Rspamd-Queue-Id: E1D50100002
X-Stat-Signature: oow64a188we9fowyucmtm3p96kzantfz
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774949872-504822
X-HE-Meta: U2FsdGVkX1/9f6Ay+MJfX0m37GAmpzzl0sJe+RIJcyZubtc+3lT+Esr5rHVai9aVK2afWQsYREjIrvb0QwAw62pkx3HYThhHIsJBjFoT4ar/JBWkuvTN1FzaKOW4/1cMELcp1nV6Xv593E1Jd+AgciuhhNwiZw9RNK7ot5P9RV32Oai1dRdZiLU+cl+e3Q2acZBnbiqVBytmIbJCtmGa9YBALpkEXjDiXOUjptb2Ex280WeMJaqPuAIwkFBost59DdIzODcZgtHsLlMW1SetVYTrTetwWErrfxJJd/kGcHCYDXfysmO2wYYOaIfAPiguFSEhoF1TwzDnF260sjSGneXhRclxpMtAoziSb8NMpcZpdbTDqwCN45A291ygmujnGPoongUg4xEiaUhnRF49VSXvscaMtJdb7eaIorcQytGqxTowWtdjRrWt2ns6uIxttstDeUjhNFBgo9xTR0nCuFnHTXDaJiq4kY4CWl/UDe1eO56Q+lk2k7YFmA7Qge9IUUEPE5C2DMxwB9lR13uWUKd5SYsyhYo2As9DX95y7QmVq+CD5iY5CNRmVZMy79u/Cum+5UDhFDGZf4WsctAzuqpmQnra3KsiIh96Af2+z6k6/SsTrkwcoCT9jCAugqnv4TnQAJ5luWgWWNx22iR/5z4QT0VWEkZK4jq2SBovCgaZsBtAA57B0Px78SUvJsTwrMmtzLDe+RfDrVmyVnkG85ogVPuAYZwTU2X5jULoYLf/IMSPmqtMQkMxPmLDg9RcwVe4GdGXLQiXVpUHPDiFl4KRJD6b8Fq8tyykh995n6Qg+SEqbrevahUiGCcefk+/S9skQGv3VbiNbGH0RcqW8Fckebw+Akhz2NXjQN/uK+m1KZ7wy4h+sQhx9G/W8r30VLj/jMIwAp2ikwIW8TwV/NEkQd01MkDnEWKG2wZc6T8lPLvDfC8Nf1z52Z+nVwKosrF4/nesQ1ThN2hGkUz
 JdEX6Ets
 a5VVG10ZOslWwtUb4mcbcSuL0omBoWg7XeVd+IWXb1Y5NmfBU7zg/0pJwbR2wSfFBCkq44hvg66KLg9BOPJNTrzZ2fB5Z5madJmm6rfXnbFeVRrFTRju6+frVcFVX18Y68/oXYAzla1QAqPnfQGI5kFcjjDRa7UK+zr+wznA2ISNIan0vunkDQc89lcRo3zpKESqdSAkWQueSblLoBODhG9g8hUj+q2TYebhSFXrJUpeiEk1BDFIcXvuMWesah6oAi8b98tssOUSgBWHcTCoJMTR6SVMiEEOHdOP0cLaXcTIa1TSTS/8nMnTWFcMdIBc+rmaq+69APJXLeKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Mar 25, 2026 at 05:09:35PM +0800, Qiliang Yuan a écrit :
> Managed interrupts currently have their affinity determined once,
> honoring boot-time isolation settings. There is no mechanism to migrate
> them when housekeeping boundaries change at runtime.
> 
> Enable managed interrupts to respond dynamically to housekeeping updates.
> 
> This ensures that managed interrupts are migrated away from newly
> isolated CPUs or redistributed when housekeeping CPUs are added.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  kernel/irq/manage.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> index 349ae7979da0e..f2cba3d7ef624 100644
> --- a/kernel/irq/manage.c
> +++ b/kernel/irq/manage.c
> @@ -2811,3 +2811,52 @@ bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
>  	return res;
>  }
>  EXPORT_SYMBOL_GPL(irq_check_status_bit);
> +
> +#ifdef CONFIG_SMP
> +static int irq_housekeeping_reconfigure(struct notifier_block *nb,
> +				       unsigned long action, void *data)
> +{
> +	struct housekeeping_update *upd = data;
> +	unsigned int irq;
> +
> +	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_MANAGED_IRQ)
> +		return NOTIFY_OK;
> +
> +	irq_lock_sparse();
> +	for_each_active_irq(irq) {
> +		struct irq_data *irqd;
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
> +
> +			/*
> +			 * Re-apply existing affinity to honor the new
> +			 * housekeeping mask via __irq_set_affinity() logic.
> +			 */
> +			irq_set_affinity_locked(irqd, irq_data_get_affinity_mask(irqd), false);
> +		}
> +	}
> +	irq_unlock_sparse();
> +
> +	return NOTIFY_OK;
> +}
> +
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
> +#endif

We probably want to do that for HK_TYPE_DOMAIN update on housekeeping_update().

Thanks.

> 
> -- 
> 2.43.0
> 

-- 
Frederic Weisbecker
SUSE Labs

