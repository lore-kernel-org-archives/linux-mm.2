Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A035CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95FE88E0010; Thu,  4 Sep 2025 02:45:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9378E8E0002; Thu,  4 Sep 2025 02:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DBE8E0010; Thu,  4 Sep 2025 02:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F1A58E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:45:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01FF41A09C5
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:45:00 +0000 (UTC)
X-FDA: 83850630402.06.285E78D
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf12.hostedemail.com (Postfix) with ESMTP id EDC3F40003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:44:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=LV+1vr5T
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756968299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZmrHXi/l2Bu3uwxMTV4r6fmpaXludQwzjRHMWeCses=;
	b=emOKq4s6j69WeUK945EpOFnCRvKCgStj1dCO7RVAxHViRWp9GWwlzTcm5uM/s2rku22znM
	B5eI4baAKRUqeQm3xje4wQBW/Pux5fuuotFizo3qHMRlNVe+JYgMCDAY5oaIIvgYw6BjkT
	irbZoxuX95RS8+68Asnvrc4+L3YwgGY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=LV+1vr5T;
	spf=none (imf12.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.92.199) smtp.mailfrom=peterz@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756968299; a=rsa-sha256;
	cv=none;
	b=EpPWRA+K680qqg/Ol7ZMGUiV/NXWt2ZBFZMARAQf7Z/4jYmeUBcOv+YfIiH6Jm6ej8Swcd
	yXbZhyK2iZA1NMPG4Vu+1JnlZPQ8OOK8xkiqIHjJkwnsYUNGdrlElx3/NetR/jW1AJD5rS
	eER137Yd4K7SIkfkQ8FyF3hiMCTnakw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=gZmrHXi/l2Bu3uwxMTV4r6fmpaXludQwzjRHMWeCses=; b=LV+1vr5TnEbOLwYDucpF+T7OIM
	LWIWn5X6Bnn9lXD+SOBNZPAjiFQE9u79hY8ceIoaYVBB+rG4wxes3Rm2SIO/T9SMXtDz1WDDJMAgR
	sEqyVAiZ8dOIT3rwh/d00dqxQja9pydA/vSzSy2tGohH0cMhzwqcl2EOSnawGlVX5x1IoMtLugTxx
	knHvZleoFEyGIIr00wSpr62kKCud3XmrUPYtIXF21hHRhmNQqk8Cn3ZbMtE3wh9dH+km5SACk+lgx
	OZSQvvdwMxJdlJ327jl9dk44f6BgII0+XrrASFOQRMxTzEYlx2jX3U6L47hw44gV4EoJHUl0mah0s
	hU3DEftg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uu3iD-00000004IW4-1Zu6;
	Thu, 04 Sep 2025 06:44:50 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 78BB03002BF; Thu, 04 Sep 2025 08:44:48 +0200 (CEST)
Date: Thu, 4 Sep 2025 08:44:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/18] perf/hw_breakpoint: add arch-independent
 hw_breakpoint_modify_local()
Message-ID: <20250904064448.GU4067720@noisy.programming.kicks-ass.net>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
 <20250904002126.1514566-7-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904002126.1514566-7-wangjinchao600@gmail.com>
X-Rspamd-Queue-Id: EDC3F40003
X-Rspam-User: 
X-Stat-Signature: 8cr5s6up6ishajofxngwan4xkbs75ac3
X-Rspamd-Server: rspam09
X-HE-Tag: 1756968298-162115
X-HE-Meta: U2FsdGVkX19pcOlSWTv4gDRZoyyPtfK3mWiwtZMGn/Pmf/wXPwUG1YZRyyFaODp9YkMFwj2F46i8fB89hQFSUHU3/UuJH2mYWGDsy45nRwoXPARms6TuT0IHmqyUkZ+eRBJlGPIXE6jp7sGgHzVARkvuN731igURIcmo4s3eQUICXSY7QdwMFDoWNFEniLIfyzoKec7atQowbWbEcrGDIgMvtltVCiqmOK+siY1Zq9HcxTAAJ5BVx2E8g6pZSrGrf/e7jtfarpGj4sefpMS6uMp/ddWduJ8yUnZjfs5A47pOVPUlhwV4otwaniuf9qnVJdEktcef++nc1P7gZMWeRG6mepYZel7AmJCvmEa38f5uRpooeA2Jbq/fk30b8RnZFopCDauRdPo2gr4xUjL77ciFboTxDJ4JwRbPtTihPoQbLgTZjXMzJ9mBdApa38WOFaUx/7pz0x+3BOs677WJrj7yuH/O9n8PFS8eil2IUZi4fRGQLoJNN/k8z0nWxU4j+FfzCK7U0nnQQkkq+Lqr2sLtZ4pyy3lLrCSPUPZc/dPa6kXktWFDN/UYQmqgi1IrVvuZpYc0NcW2decbZ4RL6qrwB0G06R7R/6qzWBZLjBdcnwxITsJ1RKBexy2fbqAXPJXLOKZ5P722GXtSSSB75pkraD873BWife9IKD6WutcXcRB2h6SsmgmtPv+j0kwxftcV+B52x10okzKLB7KSd7/I7kIp/7WUEwgTiMZLOed0SdJB5TG863zYVFTEbrDMvUK7bMKHmT/hKSDfxKfGrtQ5d7Soq+hkSwMTlWZOx7dPE3+edbbRIvY7VUO5fbOyavR0i5jEdBCWjtSM12tB69vkQyPhz01h9aR+B4MOLdBfIX/pdMPj+9pXvv+klQhevUBxY1y9mKJpwWyKV5tuWdSyxqC9TtWm9LdUUz9nItCOo+gBdEQ5qXqmDK7OGFw9I5tbqD8HOxX37JY1kxC
 DZMlKkAe
 GranTL5eSL+IcRL2DZsQ4XLgj0twfEt0pYuCaqk+iTkCe9R8hFrS37xGFl6XC0dGnTVFYKUoRs4f9GL06TxuFKy/2+6ZFopb9nVWoSxfrKVYrQkp5JtAKV1jEXDn+8O3XOix4DVk6lz0mezooFfFQhYPfT+WN5/zs/v7vkfZwo9dtXMXQfjk31wqN0G2PYKNLCJEyTQkXMsLI21600pPFrz477a0PyXugMan5CshrYcheRxzAqkE8A1rZMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 08:21:03AM +0800, Jinchao Wang wrote:
> Introduce hw_breakpoint_modify_local() as a generic helper to modify an
> existing hardware breakpoint. The function invokes
> hw_breakpoint_arch_parse() and delegates the reinstall step to the
> architecture via arch_reinstall_hw_breakpoint().
> 
> A weak default implementation of arch_reinstall_hw_breakpoint() is
> provided, returning -EOPNOTSUPP on architectures without support.
> 
> This makes the interface arch-independent while allowing x86 (and others)
> to provide their own implementation.
> 
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
> ---
>  include/linux/hw_breakpoint.h |  1 +
>  kernel/events/hw_breakpoint.c | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
> 
> diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
> index db199d653dd1..9453b5bdb443 100644
> --- a/include/linux/hw_breakpoint.h
> +++ b/include/linux/hw_breakpoint.h
> @@ -67,6 +67,7 @@ extern int
>  modify_user_hw_breakpoint_check(struct perf_event *bp, struct perf_event_attr *attr,
>  				bool check);
>  
> +int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr);
>  /*
>   * Kernel breakpoints are not associated with any particular thread.
>   */
> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index 8ec2cb688903..ff428739f71e 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -983,6 +983,24 @@ static void hw_breakpoint_del(struct perf_event *bp, int flags)
>  	arch_uninstall_hw_breakpoint(bp);
>  }
>  
> +int hw_breakpoint_modify_local(struct perf_event *bp, struct perf_event_attr *attr)
> +{
> +	int err;
> +
> +	err = hw_breakpoint_arch_parse(bp, attr, counter_arch_bp(bp));
> +	if (err)
> +		return err;
> +
> +	return arch_reinstall_hw_breakpoint(bp);
> +}
> +EXPORT_SYMBOL(hw_breakpoint_modify_local);
> +
> +/* weak fallback for arches without support */
> +__weak int arch_reinstall_hw_breakpoint(struct perf_event *bp)
> +{
> +	return -EOPNOTSUPP;
> +}

Again, so much fail :/

So we have:

{register,modify,unregister}_user_hw_breakpoint()

and

{register,unregister}_wide_hw_breakpoint()

And you choose to extend this latter with hw_breakpoint_modify_local()
instead of sticking with the naming scheme and say adding:

modify_wide_hw_breakpoint_local().

Also, again, that EXPORT is a fail, these other interfaces are all
EXPORT_SYMBOL_GPL().

Also note that modify_user_hw_breakpoint() doesn't seem to need new arch
hooks. Yet you fail to explain why you think you do.

