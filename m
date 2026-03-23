Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45AAAD58CBB
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 01:53:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8F56B0005; Sun, 22 Mar 2026 21:53:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332836B0088; Sun, 22 Mar 2026 21:53:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FAB96B0089; Sun, 22 Mar 2026 21:53:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0B00F6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:53:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A351C1B879E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:53:05 +0000 (UTC)
X-FDA: 84575654730.29.28E7340
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9F2318000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 01:53:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=syGQ+FQn;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774230784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XjaNJhLaaBIoPhY5J1JjBYxu+m0MlojQk+x2VTUDkSE=;
	b=nyvBqCIUrGVLj+mzeoA08qV0Mi/EKDbVp+41O1J30WrF8dkJEL1V2WlOSQlMAYxs0XGNVH
	am7ZIdo9jLjVA3TuO+OYeqm+ZAPJs8/oE1/iI81PPSd6ddh6IS/6VnT8dU1itolWCBS4zL
	L8sEWV/pi5H0oL0W+y/ZiAh89iAKEnQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774230784; a=rsa-sha256;
	cv=none;
	b=QGhF8K8XA2WuRXqMqImjqkSsv8AgNeMKSfY5G+CyMcGeiqS6YBmYzfroU0pKqG6q5ledzp
	1v6Skt8WUia0rX0OXteD0ZR12xdPqZMx1VONYNRlzeY5176RhGjgIlDQtA8XZ7BKOQZAXr
	6fmrofelhDfXxQHrwfLqLWa/efHgRzU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=syGQ+FQn;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A10341949;
	Mon, 23 Mar 2026 01:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154BEC19424;
	Mon, 23 Mar 2026 01:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774230782;
	bh=eUGwd2FAzA5WsiNrJdTb7+mmPtzV/iRzisXP37+yIOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=syGQ+FQnov4Tm8PYgxMjcq3vLADnywVtS9reKDajj0+znmyAerMZrH5Bmdg2FOQw2
	 XrwXDV4R6w20VOZUsdO8d/XtLjnP2PZImEb5d9iQ4Tp5qHQcqvO8JeiCiJ40EI2CNv
	 ghpLImDXY9r6GQe2cWOuYJFdSfySOPJNBKKqX5YqYJglvtSlYXGXV9PGSvickmseIR
	 sy9adD0LWiQEIIjeXZRnwq8SxXJ0mYKuMEuOM+sjPLlokP6XH9C0xno6sX0OmpBkBL
	 bfFA+Bw4VDchWqb2P/HHTW1XjNByKOytC+lK78FWi+R3zqsnqJb1AOLIXyL7UceCmA
	 +pgd2O+Uaif7A==
Date: Mon, 23 Mar 2026 10:53:00 +0900
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
Message-ID: <acCc_AJyxSS98r-P@hyeyoo>
References: <20260319233745.GA769346@ax162>
 <abzKcGiRSR_E8lLN@hyeyoo>
 <7780a471-9d99-40a7-ade7-0c4594ac36c7@efficios.com>
 <ab1J9ODkX5iChu-C@hyeyoo>
 <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7458d8fd-5922-4e0b-9cd5-91880282aaa3@efficios.com>
X-Rspam-User: 
X-Stat-Signature: 1wwxck1y9zq641rbs6cqzekm99qjyex9
X-Rspamd-Queue-Id: D9F2318000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1774230783-860551
X-HE-Meta: U2FsdGVkX19w/E8UbPo0O9u8PVkYYGVsuEuShBkWmW86aHJhOruCbXP0iwfSIZ/pRYk3N4nq6myAPC/NVgblWw72GCERbIJI4sXJ1s0BESXBNCw82JF2wLkDArHpeBt3u0EyfXEx6Q4PFS5No2f1Rb+lZzxUdN1XZkIGEL06zxL1pRtQNFx6KR8XjBNXNESZC51G5JeehtFgHGHbo5QzAAtmcGntZGW1o3PaLzJBL8Jt4rBsLaC6Kvx3p8ixO2BsHs172OHHJ3FrueB+YcxI5zIyvPR+fSjK7HPxaJlTKENS693GlqhAVDhO0SUlizNDBvxTp/1aHLq+R50OgRcm1IMqCzf0VqEU3KqfC3Ht1nKqqSbZxKx7ok9bZv5H5JBA5zzIObrvkRHH3PGeWZtRkkPbzB0ukpXRFQAQ54XD35HL2SCrA6O0rbRPB0RTTGlr+rAQdx6AvKEG0r95ra9pzJIoVYk7ktmzivxdr+NGgejpAB1Z/cmTlcCFLrJvtbExohXo4d839ko27iu2NXdYZbNGLdRSrenTj2Kv+6p+KlUY7LUyvR+yfUbpoUEnAAcHYsl0DZ35WlhVE7yl3UuemdHBMPsm2+IBrqKSlVZteug/Wx8pLZfZOZat0HCDxvWoBza9kJV8teudFNiXVKdTTwOlNf1DNlsGkgVKTs1i4tIobM+S0cbcm2id/ravdCTRjr/DM5DHbFtMipVtwkl5Dr8VEMO8IRAlHUs5BuQHM5PL/qDc7ZARgTwt6MRIfq0oAYBcpy/LkZHnVwmJvP7bzWtDvManbuOhyTsrGaLgtBWx4oipZyoLcwCVZivlL7TYqlShXcbM7N1h+vVAF/H8k1G+6gYXUCyVM9S5/1/mR8BP+BYd+sDJcEjDDoMBPqPpWj1JB4dFa+18oVKskeSsZcFmzn6sRbNH0+UeZof52AzrWqrzgQiZjqsVFDMMbm+60lxLLV2YVj4fhYXVYmF
 rOCTRk3V
 QUGudwCbmm1xHX+ImC6a4uv51HGNTF+5bnI9Kd7IOr9Fd670F/baSj8WDOfE56WaQnfOIgHV5SUIi7smZobVGqncgwZieaUqFeB/djDgz6zKmUZuVwIcO9h0QFgnpXe4IJ2EKu//eyNVGaVX4Qs+lRHDaVaJvW+4fnJBHTSNA1bEQ9DUGnJHOYHHb2wwclonl2/eZGtZp652g7WIhgb0EXwG331WD5zTqdg0Zr206hIVGaOcNPn7zHLlkIgEqrMtMeweJRmLjaMr/9M0O8xtUditnQAg3pV/OD3A2nEZIpsvhOJQNR882WBKxuF0S2jrONH4j84dr+PemdmmLztspvQZMAucC1bFpj1hHVuE+RjTt8bZjCQxBvmokbAujac7pxzFf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 09:31:57AM -0400, Mathieu Desnoyers wrote:
> On 2026-03-20 09:21, Harry Yoo (Oracle) wrote:
> > On Fri, Mar 20, 2026 at 08:35:46AM -0400, Mathieu Desnoyers wrote:
> > > On 2026-03-20 00:17, Harry Yoo wrote:
> > > [...]
> > > > > [1]: https://lore.kernel.org/20260227153730.1556542-4-mathieu.desnoyers@efficios.com/
> > > > 
> > > > @Mathieu: In patch 1/3 description,
> > > > > Changes since v7:
> > > > > - Explicitly initialize the subsystem from start_kernel() right
> > > > >     after mm_core_init() so it is up and running before the creation of
> > > > >     the first mm at boot.
> > > > 
> > > > But how does this work when someone calls mm_cpumask() on init_mm early?
> > > > Looks like it will behave incorrectly because get_rss_stat_items_size()
> > > > returns zero?
> > > 
> > > It doesn't work as expected at all. I missed that all users of mm_cpumask()
> > > end up relying on get_rss_stat_items_size(), which now calls
> > > percpu_counter_tree_items_size(), which depends on initialization from
> > > percpu_counter_tree_subsystem_init().
> > > 
> > > If you add a call to percpu_counter_tree_subsystem_init in
> > > arch/powerpc/kernel/setup_arch() just before:
> > > 
> > >          VM_WARN_ON(cpumask_test_cpu(smp_processor_id(), mm_cpumask(&init_mm)));
> > >          cpumask_set_cpu(smp_processor_id(), mm_cpumask(&init_mm));
> > > 
> > > Does the warning go away ?
> > 
> > Hmm it goes away, but I'm not sure if it is it okay to use nr_cpu_ids
> > before setup_nr_cpu_ids() is called?
> 
> AFAIU on powerpc setup_nr_cpu_ids() is called near the end of
> smp_setup_cpu_maps(), which is called early in setup_arch,
> at least before the two lines which use mm_cpumask.

Right.

> > > Alternatively, would could use a lazy initialization invoking
> > > percpu_counter_tree_subsystem_init from percpu_counter_tree_items_size
> > > when the initialization is not already done.
> > 
> > So this probably isn't a way to go?
> 
> I'd favor explicit initialization, so the inter-dependencies are clear.

Ack.

> > Hmm perhaps we should treat init_mm as a special case in
> > mm_cpus_allowed() and mm_cpumask().
> 
> I'd prefer not to go there if boot sequence permits and keep things
> simple.
> 
> I think we're in a situation very similar to tree RCU, here is what
> is done in rcu_init_geometry:
> 
>         static bool initialized;
> 
>         if (initialized) {
>                 /*
>                  * Warn if setup_nr_cpu_ids() had not yet been invoked,
>                  * unless nr_cpus_ids == NR_CPUS, in which case who cares?
>                  */
>                 WARN_ON_ONCE(old_nr_cpu_ids != nr_cpu_ids);
>                 return;
>         }
> 
>         old_nr_cpu_ids = nr_cpu_ids;
>         initialized = true;

Yeah, as long as nr_cpus_order doesn't change after init,
that will work for HPCC. powerpc seems to be a special case that calls
mm_cpumask() very early in the boot process, so explicitly calling the
init function seems to be fair.

By the way, thinking about it differently - it would probably be simpler
to just eliminate mm_cpumask's dependency on HPCC init dependency by
placing those cpumasks before percpu counter tree items... (but yeah,
that would make mm_struct a bit larger due to alignment requirements)

-- 
Cheers,
Harry / Hyeonggon

