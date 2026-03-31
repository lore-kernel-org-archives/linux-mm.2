Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C344FFF60EF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C89786B008C; Tue, 31 Mar 2026 05:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C61366B0095; Tue, 31 Mar 2026 05:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77066B0096; Tue, 31 Mar 2026 05:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4CF36B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:34:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4672A5C974
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:34:37 +0000 (UTC)
X-FDA: 84605848194.23.44A3F7C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 70935A0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:34:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pt4Un6f0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774949675; a=rsa-sha256;
	cv=none;
	b=tK0A5OeLSBSQuS5tHWTNm1otolIwHSmAqIC7Eei11vE9v9lT72QlImKG5JR91rn8pi6yk8
	UHbPjwNKszjpEND7qGhH26ofvi2fasWeOQ3Bl/TP9CRcQxKsms+WW2ThwIruABC4Svaau7
	O9ZdJo8fPiUf6omS5qHZ8C8wB5SZC+k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pt4Un6f0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774949675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jyqY3z+aPj21hTjn6N+xn2uM7++O+X+o9kHGBI101tM=;
	b=8PkoNpYGI/+aStO9sIsLgCF88PJC3HvJzdB0o0r2GlGfUnMzfYy+kQ+kYzfqhW2TxdrsAU
	4Zchvkhnx2LYjBIJHPQpM1D4X7WKtxx6FETI5aTyJFcGO3VFdJttrkc16KnIXkFR/1RphX
	x7iN7GK2iU16qOTW1aE0Q2xwqrXIzD0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E41D43E76;
	Tue, 31 Mar 2026 09:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C10C19423;
	Tue, 31 Mar 2026 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774949674;
	bh=TNVBpCJN6vg8JkQHOX7FUtr9yD8HwVf8QJDF0J/CUy4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pt4Un6f0Op8HHkDpNUCOcnt0nI7PmGlADhRN9a3BHHhBdXimG4XTdhMnFMNlwYd0n
	 M1KK3OQINGKqwKjlhSli3nyu3fHdGRIWVyvGQb0Wpp1XVEvLGnhEtIM9wlCNVU0J56
	 srdjODdV+zfUmZ321/7YRdXx+NhMPa1+txEL7mRSNHZWjkAB03bqthr4ezbEp2wSY3
	 ejVoz6IwnqXh/oSzej6g4dQlE4tQ9fDA4wlv0frT4FQ83qSaXAFA/LN+Xcwzu8ey5C
	 OREep0Om8Mvfyh/P5cdhESKZIGcAgni8Jyc+dOdldCXDvD0omK6hlaZqxu3W/B9zpE
	 mF9a2CE1hR70g==
Date: Tue, 31 Mar 2026 11:34:31 +0200
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
Subject: Re: [PATCH 02/15] sched/isolation: Introduce housekeeping notifier
 infrastructure
Message-ID: <acuVJ70bXAxFg-Zr@pavilion.home>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-2-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260325-dhei-v12-final-v1-2-919cca23cadf@gmail.com>
X-Stat-Signature: ai59n9egssdb574dndq6texabdemnnks
X-Rspamd-Queue-Id: 70935A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774949675-767202
X-HE-Meta: U2FsdGVkX195OA45RO3s9swef+Q3aTRHaTP6QWpjTffpAovCada2eIU0/XBPXOsE3LSmqTT6iJBzTULb4eg239smrwf6TzWVhZwM50YvBfmrVf/egQINHvDnRWtBxeQsB0DcZDF3mUO/BwdUo6qiUu1KRvv0j0J2XdIIraQEyrPuUBMUd+Cm+Qo95QXlunap342PwiVBO26ZcOG4nGrerkrZ76V70NCF/UdDxsrPLvc3Eoag3Koal6M8d87NfI2eCrTqVsmwSRR2lUvF9zmER+RasQL3gDT4IMEpOdRTkq1E/DA05rY6YB6NeVnFAI4/ILraAUmSDhq7eLBjJwQ19iqxIV4XDUrl0rMgspQjBkJYW0gYCYoAhTd7TLNZRS3ffoQMCAZoNWKM4jtgTHq8116r2JbqVL/lqnyzLdLrMZ28bPjWH+frDphVxeWihFQm7UiUO8f9sUAt2xVcqmMWGVEBJfxNPZPXmUgog2ou4puIqdZCZnsazT72S0+ffEpW3u43qXV9oOCR3fS+NyOUljV4TeiKBBmuAuWT6Ya73AQ23gVchQGcZ0IU4qNKWEFRSDatbOme95J7h//iHHBFMoSgmFUW9fHgCvpriwgXYtMf6HNtHDRwZjhjV8Pi1o6+wNZIF7U1W8NdQuz+TGEeg4BVxomXw0upCD12fbBVNbzx0RjDHTZgOnqg4nLHfKMmxDyVfphYkr9Nsjw15LRTD/hJKrZLuuv8GQTLpEel6X7B2d3fWOqIDXVZDoBLIHjJM7DGKEg4WqL2gMVmbutcD22kyBOV+Y5P3A+lqn8iGodI7SeTlnKKCBmRUAfadsJfV4XoTDJlbKHaj1zPdCXUejYjVVpqca3G5EJGcRB2LjI+2uMLvg/u11CYFdi0bqKNTCwcqXZFVUevb7rYjKa5LwDf4hlaFHK31cVFcC8pR3SV9YH3ct13OhzCSIswr3+LWtc6Y3DanDLsoPlirza
 Crj3OG7G
 0aHlyD9b3NLkPQGmEUd9EKP0mqf/uYuUl6ffHSvK3vzLsyP9VrmG55wT5Qd+GOvsVR+b/XVtfiv3Y1a81MzZGDEH7qWeLHqncEuZdvgA7Xt5B57XRwxPv3Od/BmPnYpqg7br+9H3Kn14YnlbGgCDN2+FM6/V4RhO93xBBrqIWYdZF2H2GVSPw30HRYeDI+y+wJ7LC+Dvn2yuEhL/lS+n0sKC0GiqUIObjNVwsb0kjpVUlHEtgAPU5G387WIWXhwk78dbv7eTfoHpQOJIFGIwrhRgMzI1EhkyU8vrsy5y2tfKIWueG+AesMKZoNdVGbGh+ZS5niA06RuNrrsQ9z0TegVbhtrhuhPfgE4qNXxYaYwqXprCpSPnmu5D+YYnHz2pC01K927cs2ffTeqI+68cmT1eqSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Mar 25, 2026 at 05:09:33PM +0800, Qiliang Yuan a écrit :
> Subsystems currently rely on static housekeeping masks determined at
> boot. Supporting runtime reconfiguration (DHEI) requires a mechanism
> to broadcast mask changes to affected kernel components.
> 
> Implement a blocking notifier chain for housekeeping mask updates.
> 
> This infrastructure enables subsystems like genirq, workqueues, and RCU
> to react dynamically to isolation changes.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  include/linux/sched/isolation.h | 21 +++++++++++++++++++++
>  kernel/sched/isolation.c        | 24 ++++++++++++++++++++++++
>  2 files changed, 45 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index d8501f4709b58..9df55237d3901 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -5,6 +5,7 @@
>  #include <linux/cpuset.h>
>  #include <linux/init.h>
>  #include <linux/tick.h>
> +#include <linux/notifier.h>
>  
>  enum hk_type {
>  	HK_TYPE_DOMAIN,
> @@ -24,6 +25,13 @@ enum hk_type {
>  	HK_TYPE_KTHREAD = HK_TYPE_KERNEL_NOISE
>  };
>  
> +struct housekeeping_update {
> +	enum hk_type type;
> +	const struct cpumask *new_mask;
> +};
> +
> +#define HK_UPDATE_MASK	0x01
> +
>  #ifdef CONFIG_CPU_ISOLATION
>  DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
>  extern int housekeeping_any_cpu(enum hk_type type);
> @@ -33,6 +41,9 @@ extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>  extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>  extern void __init housekeeping_init(void);
>  
> +extern int housekeeping_register_notifier(struct notifier_block *nb);
> +extern int housekeeping_unregister_notifier(struct notifier_block *nb);
> +
>  #else
>  
>  static inline int housekeeping_any_cpu(enum hk_type type)
> @@ -59,6 +70,16 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  }
>  
>  static inline void housekeeping_init(void) { }
> +
> +static inline int housekeeping_register_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
> +
> +static inline int housekeeping_unregister_notifier(struct notifier_block *nb)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_CPU_ISOLATION */
>  
>  static inline bool housekeeping_cpu(int cpu, enum hk_type type)
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 67a5ff273ea08..e7a21023726df 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -9,6 +9,7 @@
>   */
>  #include <linux/sched/isolation.h>
>  #include <linux/mutex.h>
> +#include <linux/notifier.h>
>  #include "sched.h"
>  
>  enum hk_flags {
> @@ -18,6 +19,7 @@ enum hk_flags {
>  };
>  
>  static DEFINE_MUTEX(housekeeping_mutex);
> +static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
>  DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
>  EXPORT_SYMBOL_GPL(housekeeping_overridden);
>  
> @@ -86,6 +88,28 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>  
> +int housekeeping_register_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_register(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_register_notifier);
> +
> +int housekeeping_unregister_notifier(struct notifier_block *nb)
> +{
> +	return blocking_notifier_chain_unregister(&housekeeping_notifier_list, nb);
> +}
> +EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);
> +
> +static int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
> +{
> +	struct housekeeping_update update = {
> +		.type = type,
> +		.new_mask = new_mask,
> +	};
> +
> +	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
> +}

I much prefer explicit function calls over notifiers so that we control on
which order things happen. housekeeping_update() does that for HK_TYPE_DOMAIN.

Thanks.

> +
>  void __init housekeeping_init(void)
>  {
>  	enum hk_type type;
> 
> -- 
> 2.43.0
> 

-- 
Frederic Weisbecker
SUSE Labs

