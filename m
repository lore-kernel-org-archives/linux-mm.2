Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190511098783
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:22:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82B636B0092; Fri, 20 Mar 2026 09:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD326B0093; Fri, 20 Mar 2026 09:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB766B0095; Fri, 20 Mar 2026 09:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5CFA56B0092
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:22:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4597B56348
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:22:00 +0000 (UTC)
X-FDA: 84566504400.18.7E5A292
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6684100010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:21:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sH1bvS66;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774012918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NHJLB6RqXbmu79OACaXm+sS5FaUzCpW4jfGy2OheQBc=;
	b=8n2Wy9Ta6uui9R1Ko5jGXrJfaxRUCioFCJzUwxBysZQJ2OBxgXQi2+w/5Pq/NNEhfpxFp7
	rnaflUPEjnCaA1SVN97zFfGXWKZsFR8e86LcoBGXTZ0tmFXVoI/xT0ul6M+Xg3VbC/fQJn
	1q8IihMGV5VfytuQhn6nIKI/HPZRr28=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sH1bvS66;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774012918; a=rsa-sha256;
	cv=none;
	b=R2g1wvA+r55/aAnwZxnEi3KQWNTPQMHYBhnSuwHeEdkOR83/Z4gVSpSujMKhzPZ0tZZN3V
	eleFlvEWryO7xHI6re+1VA5CMPLHsMpXEZfwKly9Od+dYP83165GHwx/F94eEG7jnNRwTS
	RomEXHRS4i5mZBr2mb7B0fDTVeHIC1s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3FC0061861;
	Fri, 20 Mar 2026 13:21:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA160C19425;
	Fri, 20 Mar 2026 13:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774012917;
	bh=MOZqXSoMb5xgzqgJiD9GpmF7ivqWpyudHypDRzlzmWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sH1bvS66tYWyssScB5U5W+6yI64kW9PEgpfUF/sWtKjITnZDYvB9r9QWkxb43jfGM
	 zenGTMnJrUvbUYr7BSjNH3xYrX4QeMHcdJAG7n0vfv6vC/IDPMlmvZxw/BlGXhfnew
	 1vxTLMpqKhkujwTmBBc249LCJkqMOZnddRHtuPmR+4mEei4v9vGfiCX0WOveVD5mqE
	 sBmQz/YP2sxDQxTC+6T+ielbgQmhmOE6GuOPD+Pu/cot6sy7RANs08qGzCmHWcwXja
	 /XVffeAKWummLz4xiHeuy1RW2l6/RTQxM2PKsI7m5/9UNTGBCav96JgY0HLDtUTu/u
	 H8NCahNA8DG4Q==
Date: Fri, 20 Mar 2026 22:21:56 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Nathan Chancellor <nathan@kernel.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
	Michal Clapinski <mclapinski@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: NULL pointer dereference when booting ppc64_guest_defconfig in
 QEMU on -next
Message-ID: <ab1J9ODkX5iChu-C@hyeyoo>
References: <20260319233745.GA769346@ax162>
 <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: C6684100010
X-Rspamd-Server: rspam08
X-Stat-Signature: cmcm49389kraopn4gccyicqmhaej1nce
X-HE-Tag: 1774012918-834812
X-HE-Meta: U2FsdGVkX18Rijsaz6ZIubsvxeHTYaxPmBywG03CIRE5iwpB/2a4bSDTB2EY9T1JTbIq9aRyRRDQKcDjp8/ijmKauRaieUneNGhOcEYXCKKM/l31ITJ8PNcI7HF6TcDJ6zsLnZabtnszwT4fVQwe2sO5nXbo6H+F1tKf6dmwMNlF7jly7CrK1wtLE86CUb0PZXts41HM/0E5F0f3hGGY6ScZXdeALeRK87dhKWyw4Icue/3eHRvT0UqhK4HCD4eRJxOXx87EXyYQIWy6PUCFgzhUC3NZVREZAGh2MO+p0EaBKG1f6q+w0A6BaBktEQRSzBa6YPQ7DrE8/YlYJGAbS4KMbO3a9QBqISud/rY0PGRckAq0EhYgvg66OD5ufBPOQJOfuX6u9D2Ch3xJ9qysT8bsuQLaBVkekHaY08B9H6rK7jEe351IXsrork2ieUchq97wGmn1bWcc0cgqK0NLx6CZJNDmP1tTxJQcEnqaCwzX1BjY4HedzuzfQpqQYirAmyqp9GbjNEaEuxNOrM6Vb59KrM5+42pz8Dc3wOGtiZ3wUzvx3tWTFv+VCN+cOBEqZWgoMV2Qt/wlJPvibtZHuFREbQuVuXugyq5m/u75xcvVi9PxAQYTYBSvpz4HgH0W1gOEnrlksiJuY7BJi5XbhCwVSJeAzrp/qCM3Jt1BKAPLpN/aeummf7DYDJJ9eYs+4VIpxUk5ovfNkmSPieNkl3+R1QNy7jOuxV9kP6hUFZnRiiIk4U4XtRqjDJrU1AfJHygv8j8BjFgheRk7nmPmOdW1UYwFXkeUDZBpiu5tt3Tk1R7kQ96xn4BxAbQhZOcVPBHbuHa7U5UwRDpDe/ryiZfukp0uDqCnlVI++XlrdfG222Aer1La3Z/7O2+rqnP6eGjqiSrqxOy3DZQylxyONqSCDe3jggw0loX1lj1DX5Tq43OFNfrCU/h7lc97ebrQY/UHXEKdL2wB2cZarlc
 CDLaHnHU
 /MM4G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
> On 2026-03-20 00:17, Harry Yoo wrote:
> [...]
> > > [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/
> > 
> > @Mathieu: In patch 1/3 description,
> > > Changes since v7:
> > > - Explicitly initialize the subsystem from start_kernel() right
> > >    after mm_core_init() so it is up and running before the creation of
> > >    the first mm at boot.
> > 
> > But how does this work when someone calls mm_cpumask() on init_mm early?
> > Looks like it will behave incorrectly because get_rss_stat_items_size()
> > returns zero?
> 
> It doesn't work as expected at all. I missed that all users of mm_cpumask()
> end up relying on get_rss_stat_items_size(), which now calls
> percpu_counter_tree_items_size(), which depends on initialization from
> percpu_counter_tree_subsystem_init().
> 
> If you add a call to percpu_counter_tree_subsystem_init in
> arch/powerpc/kernel/setup_arch() just before:
> 
>         VM_WARN_ON(cpumask_test_cpu(smp_processor_id(), mm_cpumask(&init_mm)));
>         cpumask_set_cpu(smp_processor_id(), mm_cpumask(&init_mm));
> 
> Does the warning go away ?

Hmm it goes away, but I'm not sure if it is it okay to use nr_cpu_ids
before setup_nr_cpu_ids() is called?

> Alternatively, would could use a lazy initialization invoking
> percpu_counter_tree_subsystem_init from percpu_counter_tree_items_size
> when the initialization is not already done.

So this probably isn't a way to go?

Hmm perhaps we should treat init_mm as a special case in
mm_cpus_allowed() and mm_cpumask().

-- 
Cheers,
Harry / Hyeonggon

