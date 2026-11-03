Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E60A606D821
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=ccOpwd2t
Received: by kanga.kvack.org (Postfix)
	id 57B766B05CB; Tue,  3 Nov 2026 09:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 552DE6B05CC; Tue,  3 Nov 2026 09:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492F36B05CD; Tue,  3 Nov 2026 09:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 262976B05CB
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:55:30 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0154A8001
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:55:29 +0000 (UTC)
X-FDA: 85394106378.25.73EDDB6
Received: from relay.hostedemail.com (unirelay03 [10.200.18.66])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2329C0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:55:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717727;
	b=pFBR7c7RjOnvYSNj4q7qacxaDEjq/Vs2ZRmztI8idzM46gOeT9fOkbUb6aHxulGdtkztNF
	RMpSPXUsZiiRyyoyIxrbOfKgeY92thgC/3Yc4X17yd3HD22m4Eb2ibAjKKsbuhVMCId4Ea
	NjYcjskuHjGu60tciqZDDtDTTNVGWLg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfddeYQH6ujsdtrqW+DK7nJG3jSGc85HvZV3WQ41HAI=;
	b=SBwYfh49zIJR+7a55TE2dDRb3CZJPO4MAozhNq2qHo4kzZT41uFk63G5kQ074YGkzonuD/
	507rPERbP9fbiYUCV+mdgFyg7co1cKzAoWfsXd4ZdAUJ9norh3BGwV66mNsRYCwKR+zyYU
	bMD21rhQHm96Q2h65ZAzv4Ptc7mqF80=
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CF50A0427;
	Tue,  3 Nov 2026 14:55:23 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf19.hostedemail.com (Postfix) with ESMTPA id C284720028;
	Tue,  3 Nov 2026 14:55:13 +0000 (UTC)
Date: Tue, 3 Nov 2026 09:55:12 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Aaron Tomlin <atomlin@atomlin.com>
Cc: pmladek@suse.com, john.ogness@linutronix.de, senozhatsky@chromium.org,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, bsegall@google.com,
 mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
 akpm@linux-foundation.org, baoquan.he@linux.dev, rppt@kernel.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
 surenb@google.com, mhocko@suse.com, kees@kernel.org,
 anna-maria@linutronix.de, frederic@kernel.org, tglx@kernel.org,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com,
 bigeasy@linutronix.de, clrkwllms@kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC PATCH v2 4/5] printk, tracing: Support console flush
 suppression and tail pinning
Message-ID: <20261103095512.7b8c2d3f@gandalf.local.home>
In-Reply-To: <20261103024453.922373-5-atomlin@atomlin.com>
References: <20261103024453.922373-1-atomlin@atomlin.com>
	<20261103024453.922373-5-atomlin@atomlin.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18bF8bDrvU8IQ31ZfoMj2/1FBDtsGgnaNM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:cc:subject:message-id:in-reply-to:references:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=yfddeYQH6ujsdtrqW+DK7nJG3jSGc85HvZV3WQ41HAI=; b=ccOpwd2tRjlDkvLbOszT0B1ym6UiYCfrRWT0qA4+g9GnoqpEdGbtdba9bNqnSGo8WEXhJAmxC0nC9r/jQRz0ydIwgnnbdbE+fkNtv7+eOe9CahVZ9Tf38wAfwDUrGkJffHQpfufHMkf6c76Qt5z5WupeU0bID+ji4KLPijQfrbw=
X-HE-Meta: U2FsdGVkX19lBMKb7T+S15I1bJ1yR/TpScDr1lLD4QbN59L8ZM4I0NZGtNhm2A8c1bmSxupnsLnRAsBUwVGiAfWzpLEfSX3Adc9DNtb6PKQ5qJNeVEATThLVWUurVwo9CE5t/iLx93jzKYVjROq1YZpyEKFbbFeS0fkiZcRmgC2kbjBnXH6i1894/YQUb3zmpt9AzD9eP/WJIIhyybCls1BbTVchuLjJ9gzzG6y6eMRLctFBr4SOmLD53JvLUC49y8ZRAywfuklEeeyZQgz1N8jIf42a2Jf292eBO4csSC2VZy7+hRLMlrdiX2PfR5HNPn57OrUIwJiwWiRoeehnpiHDKniSg9g5+r1a5FR/JVhzWytRVeYOTvnpX6+QVIy/
X-Rspam-User: 
X-Rspamd-Queue-Id: E2329C0009
X-Rspamd-Server: rspam07
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: nc4kisin8m3wyjdgtdpom7c1au41iqa3
X-HE-Tag-Orig: 1793717713-47761
X-HE-Tag: 1793717727-446471
X-HE-Meta: U2FsdGVkX19CuxCBnNNQQdb7IqxFzXNLr+1iqLjYQzyNSfVWB0z/ZUhQdT9JKZLxbMZNWQcxIco+sdoEtwA109yERWbRPcz7ZJUvjq0kmjtgO3WyHukIY6a/6JW0PyX69nP2f8VVBdkbZuLRZng9DcsjBFlbzA5UyHWeFW+AjIB1WL/jQdaHpUBtHUD5lWO4gdRwODDPQ51nfwOwoFJCbuFGi1bpPDEVmcsfdvMDcQtTFeol6Fq2MBnWz6lc/m1UHhvEZq7e71kVZ2XrgoEvOYtpEaaKOAhyW+fCPL38HI5hZ1COvqX9IAEC/XYr9kFoeiZesTShL+EneE7vZiBNSNkYCL8lPDryFcLRe14LSf0OzpWTxA/8SNO5wU8Vib64dPKt5AZm8Z1BW9Z+13urhpD8UfK7I8e9ZXM8AQm+cb9o2Mu71vLVm8bVkVnSOuK4ZQPds0mQ5G7reKory5QIr24qA9aNZ7yUvNzAQy50Z8ngCjzCQsQnxJFixO+G0rwwObKwtIADAw0IhIsTEt2BNQ3XJ81T3hEccp61lS+jSvhgp75jmPI+Z4+bnfaXTQs/4s767NCK3PeRgkeMGElllZ0hBMudw1DEe1CqmUETOpyejvyEKcR9/mWeuQG+3JMMxY23xvC0S5M30xb3LMCMLDRSG1FxRRzn3LGR7yxNqBV4y6mZkaBukgVzJkhwuiIjklzOKDGGfbqbR+TZClxrupu3LWFbQ9sLIk89uddehjme8WNzg+zru1qNUUSjkAHJ4aEBfnG1aVoVfs/W9W8Q8fdxJoa1rwDKH9zA0p2C6GBUvPuBsEZ6XaZRotLvxP6n4hXNhss48Jl52+NwL0hrYdyhJ6SFjqM5kqbLiKXAW/E1P/xugnbrOj7Z5hrC1KTz3CyLv4YXOFWsIxh+Ru54TILlHCIj4a2gwklIHC70QtgJlMaNpTVLb0WaxCJlmOfPz8Xq9lwj0VHSr+Mj5Bu
 bmDT7Dc9
 mHfwd1SdkWMgnb53cKnPIuPDsqAKoRJGbDt2lheX6dqGbfj7BbSBXR1y/F55xxY27ml49MazxFiMHDTySqeiV3vd/nfKE0bWIGcEpzaX4ly3YCmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon,  2 Nov 2026 21:44:52 -0500
Aaron Tomlin <atomlin@atomlin.com> wrote:

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e8c4efa8107b..35a56f04e9b3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -9519,6 +9519,9 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
>  	else
>  		iter.cpu_file = RING_BUFFER_ALL_CPUS;
>  
> +	if (printk_is_tail_full())
> +		goto out_enable;
> +
>  	if (tr == &global_trace)
>  		printk(KERN_TRACE "Dumping ftrace buffer:\n");
>  	else
> @@ -9537,10 +9540,13 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
>  	 * and then release the locks again.
>  	 */
>  
> -	while (!trace_empty(&iter)) {
> +	while (!trace_empty(&iter) && !printk_is_tail_full()) {

Wait? Is this to prevent overwriting the printk ring buffer? If so, this
is wrong here!

In your change log, you mention not losing the initial oops or registers.
But if someone is using ftrace_dump_on_oops, that's not what they are
after. They want to know what happened that lead to the crash. That output
is at the *end* of the trace.

By stopping the output of the ftrace buffer early, you just lost the
information you are looking for.

-- Steve


>  
> -		if (!cnt)
> +		if (!cnt) {
>  			printk(KERN_TRACE "---------------------------------\n");
> +			if (printk_is_tail_full())
> +				break;
> +		}
>  
>  		cnt++;
>  
> @@ -9551,19 +9557,25 @@ static void ftrace_dump_one(struct trace_array *tr, enum ftrace_dump_mode dump_m
>  			int ret;
>  
>  			ret = print_trace_line(&iter);
> +			trace_printk_seq(&iter.seq);
> +			if (printk_is_tail_full())
> +				break;
> +
>  			if (ret != TRACE_TYPE_NO_CONSUME)
>  				trace_consume(&iter);
> -
> -			trace_printk_seq(&iter.seq);
>  		}
>  		touch_nmi_watchdog();
>  	}
>  
> +	if (printk_is_tail_full())
> +		goto out_enable;
> +
>  	if (!cnt)
>  		printk(KERN_TRACE "   (ftrace buffer empty)\n");
>  	else
>  		printk(KERN_TRACE "---------------------------------\n");
>  
> +out_enable:
>  	tr->trace_flags |= old_userobj;
>  
>  	tracer_tracing_enable(tr);


