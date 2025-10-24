Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B200CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 17:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9954B8E00E1; Fri, 24 Oct 2025 13:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96C738E00C9; Fri, 24 Oct 2025 13:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AA868E00E1; Fri, 24 Oct 2025 13:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7AD7B8E00C9
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:43:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2D2448D93
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:43:49 +0000 (UTC)
X-FDA: 84033730578.30.D983421
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf06.hostedemail.com (Postfix) with ESMTP id 16632180002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 17:43:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761327828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EW1LjEPKCRY/etQyaioUw8y2wQlPfkhezOORMkuj/t4=;
	b=LqIPbhii+wvQXkckgtyoWAgMJv0m1nP6aNyb4rOGjpusBxY9bM4UWp5ATM4dIiB1b205ED
	vqh5QNkH9zogKmFkdJ8JnxuOPc3h2ww8MorxYcEAdIg+LVL0nDZMcVPl8WjiAqmNFVTyFp
	dwqHPwhZley2VJdveE5xr3WH3wp5JPY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761327828; a=rsa-sha256;
	cv=none;
	b=opGJKCFCvH625zra44/nZ0QI+x8pG05EiAV1skUJCEk2E+ufGmnKZkc0qjCi4nRRjktYJg
	gyrEsZ11XRvjH5sV5ltymEbowLj72yglGQTDPCKW42imw4gWDGu5y9BKZKtP9t7Wc0N7wn
	t9muyhpocwhLuTiYDHFpFQ0PsmiP7IM=
Received: from omf15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C157ABE5AA;
	Fri, 24 Oct 2025 17:43:45 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf15.hostedemail.com (Postfix) with ESMTPA id E11351B;
	Fri, 24 Oct 2025 17:43:40 +0000 (UTC)
Date: Fri, 24 Oct 2025 13:44:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 bsegall@google.com, david@redhat.com, dietmar.eggemann@arm.com,
 idryomov@gmail.com, mingo@redhat.com, juri.lelli@redhat.com,
 kees@kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de,
 mhocko@suse.com, rppt@kernel.org, peterz@infradead.org, surenb@google.com,
 vschneid@redhat.com, vincent.guittot@linaro.org, vbabka@suse.cz,
 xiubli@redhat.com, Slava.Dubeyko@ibm.com
Subject: Re: [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task
 lifecycle
Message-ID: <20251024134409.72275dd4@gandalf.local.home>
In-Reply-To: <20251024084259.2359693-2-amarkuze@redhat.com>
References: <20251024084259.2359693-1-amarkuze@redhat.com>
	<20251024084259.2359693-2-amarkuze@redhat.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19CRueCw1nm5uT9RZSPlGEKzC/t+oG4hig=
X-HE-Meta: U2FsdGVkX18hDnsr4TkruwiFojbQTdlVwxH+CtBQ+69mybQlxSP/NF57Bx/vKlv0n4Fh6saZcnBJAwvpzxaBEholvuYmbRZbFXHJuRuvVxt5K2/gBoYSDPi4S4hcpP3sVHxcMJYYWBxgUDYmOzgc2VUR/LCvcFlI8wHIMqM5LY4frd8vuPH+u+hYpku7Cxe+BWkUUCnfEjDdpXOYdB+Y/rVQjgiYxCbE4g8kGBpP9r9ASG1M0PVCWH8xefZLyQhz6L5nS/XjRorGJJKUIEIQjbhjnendjVQJBjh/E0NfJif17t0CtiMF/iDeok9mAbaGHOnFgNBhQ6h+Mnjpp73ixlJRBz7e1vDU4P++/gqlVS8lxCqmgP6fuw+4G2tJuLSN
X-Rspam-User: 
X-HE-Tag-Orig: 1761327820-638118
X-Rspamd-Queue-Id: 16632180002
X-Rspamd-Server: rspam03
X-Stat-Signature: ar6o6riuok1aty8pz3n5m6kata4mwf8q
X-HE-Tag: 1761327827-45827
X-HE-Meta: U2FsdGVkX1+TFmMfzLTIRcVukpTOsOQz3tWvqJpfg3ypQDBGcCZf0msuyESOR6UOa212WhSAI352O9MXYCWXoFJAZ33T5Lg48CHznWJ4Ql7/fi2NjboyoQsTFJLbTiJhcl+Dab2zK50dfkqx1RQY2OZ87Rmt2YWanVrnQoJTlXRSG+zXJQWSFvH6zDl9+/5Y4ppfBoswPFHgyhg5Yitc70vQJ8fQVqu0/Y53HbdvgWf+/lQIMSarGDnxjAPIXvOtvRu//FzhydsM8CT3DnaqHP7bGdlgGpv+Tfyr/EGEbc1raRpcRanx4EZiwtNH7C0p3cIWm/3kqpp2yeY+gmns00iNV3+ysdWXSveRpMYzBIiYirbL3YoBnx5cR74X7uad0vwYthORQKMNYq2HOemNRKTwSnHhtUjSOuJfeJjr0TgpWXPeZ1pxTzpIlSkKEBK9TvWSLFFLZkXroJtbV16zRDYDlOdWNc8HRIGkZB3Bfx5e7zobTg9JP61CimOTikPUNipOfXvnFdI1+8kQIVvNNkxpWV3uGCGbLrN2WbGgDitmDSC/HKHiz2r6BMj7nKsxyMwswr3jadD+N0vP6zzsHxAioRqDBQeD+Bljva0J5RfVxxbMhQWa1TWc2eyPtF/deYGHYI+o/DLAz+oBX8/OtYPgN8chA6+cgmXGRMBIa6xuA+XUbiKzDGzdVI1tGegfJ6KPKgBMyQhFTZd6GuMcwMY/cxFqFwsBTNkdcsxOEeSeMO7dnS1h/DkpjOyGnqREL9uYwhiWZOZXI5hCFckSG4ByT/mZPaugd9fw7gQbKTr7Wmh+EAzieh9UVKA5fgGXe1efDtpAao6H8EbbvYGeVDADsP1A716A81LPG+3FYzDfKNpt7RHi/AoVRlUrDt21H0N17t/sViEVABLH07wU0f9YU9ajmXpnbua/GwUupx5460Zoil4h4abk/LSf2w2dtdhL8xIZoozsJ54vo88
 1mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On Fri, 24 Oct 2025 08:42:55 +0000
Alex Markuze <amarkuze@redhat.com> wrote:

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 07576479c0ed..e381f8421a11 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1278,6 +1278,13 @@ struct task_struct {
>  	/* Journalling filesystem info: */
>  	void				*journal_info;
>  
> +/* BLOG support - max modules defined here for use by other headers */
> +#define BLOG_MAX_MODULES 8
> +
> +#ifdef CONFIG_BLOG
> +	struct blog_tls_ctx		*blog_contexts[BLOG_MAX_MODULES];
> +#endif
> +
>  	/* Stacked block device info: */
>  	struct bio_list			*bio_list;
>  
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a9..b06843af05a9 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -24,6 +24,9 @@
>  #include <linux/sched/cputime.h>
>  #include <linux/sched/ext.h>
>  #include <linux/seq_file.h>
> +#ifdef CONFIG_BLOG
> +#include <linux/blog/blog.h>
> +#endif

The proper way to do this is to have the #ifdef in the header file and not
in the C file.

>  #include <linux/rtmutex.h>
>  #include <linux/init.h>
>  #include <linux/unistd.h>
> @@ -186,6 +189,29 @@ static inline struct task_struct *alloc_task_struct_node(int node)
>  
>  static inline void free_task_struct(struct task_struct *tsk)
>  {
> +#ifdef CONFIG_BLOG
> +	/* Clean up any BLOG contexts */
> +	{

There should be a function that gets called here that frees up the context.
This does not belong in the fork.c file.

	blog_free(task);

In the header file have:

#ifdef CONFIG_BLOG
[..]
void blog_free(struct task_struct *task);
#else
static inline blog_free(struct task_struct *task)
{
}
#endif /* CONFIG_BLOG */



> +		struct blog_tls_ctx *contexts[BLOG_MAX_MODULES];
> +		int i;
> +
> +		/* Step 1: Atomically detach all contexts while holding lock */
> +		task_lock(tsk);
> +		for (i = 0; i < BLOG_MAX_MODULES; i++) {
> +			contexts[i] = tsk->blog_contexts[i];
> +			tsk->blog_contexts[i] = NULL;
> +		}
> +		task_unlock(tsk);
> +
> +		/* Step 2: Release contexts outside the lock */
> +		for (i = 0; i < BLOG_MAX_MODULES; i++) {
> +			struct blog_tls_ctx *ctx = contexts[i];
> +
> +			if (ctx && ctx->release)
> +				ctx->release(ctx);
> +		}
> +	}
> +#endif
>  	kmem_cache_free(task_struct_cachep, tsk);
>  }
>  
> @@ -2012,6 +2038,17 @@ __latent_entropy struct task_struct *copy_process(
>  	p = dup_task_struct(current, node);
>  	if (!p)
>  		goto fork_out;
> +
> +#ifdef CONFIG_BLOG
> +	/* Initialize BLOG contexts */
> +	{
> +		int i;
> +
> +		for (i = 0; i < BLOG_MAX_MODULES; i++)
> +			p->blog_contexts[i] = NULL;
> +	}
> +#endif

Same here.

> +
>  	p->flags &= ~PF_KTHREAD;
>  	if (args->kthread)
>  		p->flags |= PF_KTHREAD;

-- Steve


