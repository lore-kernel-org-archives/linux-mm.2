Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAD44CF45D7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 00:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5657D6B0005; Mon, 12 Jan 2026 19:29:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512816B0088; Mon, 12 Jan 2026 19:29:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41BD06B008A; Mon, 12 Jan 2026 19:29:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CEC46B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:29:59 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2D5C13C814
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:29:58 +0000 (UTC)
X-FDA: 84325058076.10.8074F38
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0E1061C0009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:29:56 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EvUkrcnM;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768264197; a=rsa-sha256;
	cv=none;
	b=peNVo2dqRcM4rcZjHCWAhFHzVU2RF2Ykylbtsy8oi6mOvTOf2HVncjwiqe+iEGbut6lhOq
	D6GmoWO/4WDCw1BhqE/iLzGEHBxIrfLlalwUeg6zWLmVD3D0JIajaLTkSFCZNQdi0TnUQD
	z+z8sVq2dLnbREXnrl/qJn/OryVA8TU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EvUkrcnM;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768264197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2pyL7GzwiaWM5TrGRV41/bPY6bHAncpMomm47aXJ9I8=;
	b=0rTRt/UfWSdF0OUDZyT0wtiWv7mJg9vDr9Z0s2BgB09kOdX5L9TnjV6MCSo4eN1jW0yCRA
	DYFwFSVaWZtVqVMjuV+0havZp6j0ya88jAEqKjMiJwVZVscxdz7oF1gB4bSM7zg2dY4UNc
	CmWKwifXz+3HW/sQa7aFzyjKmmufi/g=
Date: Mon, 12 Jan 2026 16:29:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768264195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2pyL7GzwiaWM5TrGRV41/bPY6bHAncpMomm47aXJ9I8=;
	b=EvUkrcnMUbeWsrOdO4eoWuoOIbsPsFlpzJoGQGrQj0hpHaUfq3oz259SJnKbfSTOsz1Dw/
	GzfWv0wGyzkppJaCZtMOFUguWxJNEVnTXO7VPXob+wIOQHqRPtOngBo/gsKAm/gfc7Oo7M
	nIOkO3f+1Ts9XcpPHIq+csfBlqeTmdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: optimize stat output for 11% sys time reduce
Message-ID: <wzanjpb5fb3cff6jaissuzx3yxghgd5n4l4ekgpltytbdb6new@6v2uhp3oka5t>
References: <CAJxJ_jioPFeTL3og-5qO+Xu4UE7ohcGUSQuodNSfYuX32Xj=EQ@mail.gmail.com>
 <20260110042249.31960-1-jianyuew@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260110042249.31960-1-jianyuew@nvidia.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: q86o9fke3i968w5qeut98n9wtedbkbns
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E1061C0009
X-Rspam-User: 
X-HE-Tag: 1768264196-985144
X-HE-Meta: U2FsdGVkX18Smn68xWLI/siYgMVA3VKih6/MQCBfnrV5ne6/z70OkaJNIGzSXWMJmUm44AG8tzeV4FxIfrmN8xcVID7zbcvDi2wmtsTs4R5/sW7WSLeKdwnqcGCa1A87P+YyU+q1ZvlulvJylJhjnqv8RZo4C6/aERU580j0or5RctRvEbj4sqXWBWhRnlMobnV6VG4MPttuYZwzmTX3yoBPCQYGUM99hGbILF3Q3koPa8YifmF3rCoVNmTMtPgEnx0RWlWZE0GS6sVJDFyOz7uiELWvdGCjN/Ow4VkehvY2r4gFmXpsftDWxwjOC6N6ffFPxCmq1mcH3wWp01Wyh+IF/JQl3EGe3kCUQlF5hmVlJa1df5N5f/YyySfakwmlp8HWr6vQvCg9NWJVEIko9M16Omia8QDbwBQ+ruAuWkAWgA8+d32oSpU15WiOG6xQtcY+L9+ocpJzb+K/dgkZBIyqnihHJ95N4gJGT95jhG92B7zfh+IT/6iefT0GFHgE87Z7WHKtJLpfvsOq8xontK2PIyeNTDZS/GpKoQMSo9Oy9jUvRllTo1u8aynGwXYR8ptPjfJtK1BIyfqxG9Om59rXBlTquh99URG2l/aGISk6HpZoYpq6BxNfKVkIhEzEgRs9RfnDb3pgUoNTZxccMnpt+2I+xX+Vc3uXc5QUJw/LVFukISs1geBTmbOtrlUZybaLN3z3Jedbsmipma5AKUkdmuN5tUkvRLn6vSGh+CHstPC8RDb6ekNu9kX9gWgSg5je9h5gv+GmcSiDV32HAAkw2CWreWjhRNVE4Z+GJ+D+HuNxsBbNWYU9A6gTIncxjGM1hP/d5iy2Za9DhCH1/GGva90duPNb8igtXPPj9rM1rrvQVzYi6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 10, 2026 at 12:22:49PM +0800, Jianyue Wu wrote:
> From: Jianyue Wu <wujianyue000@gmail.com>
> 
> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> printf parsing in memcg stats output.
> 
> Key changes:
> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> - Update __memory_events_show(), swap_events_show(),
>   memory_stat_format(), memory_numa_stat_show(), and related helpers
> - Introduce local variables to improve readability and reduce line length
> 
> Performance:
> - 1M reads of memory.stat+memory.numa_stat
> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> Tests:
> - Script:
>   for ((i=1; i<=1000000; i++)); do
>       : > /dev/null < /sys/fs/cgroup/memory.stat
>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>   done
> 
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

With a nit below, you can add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

>  
> +/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
> +#define MEMCG_DEC_U64_MAX_LEN 20
> +
> +static inline void memcg_seq_put_name_val(struct seq_file *m, const char *name,
> +					  u64 val)
> +{
> +	seq_puts(m, name);
> +	/* need a space between name and value */
> +	seq_put_decimal_ull(m, " ", val);
> +	seq_putc(m, '\n');
> +}
> +
> +static inline void memcg_seq_buf_put_name_val(struct seq_buf *s,
> +					      const char *name, u64 val)
> +{
> +	char num_buf[MEMCG_DEC_U64_MAX_LEN];
> +	int num_len;
> +
> +	num_len = num_to_str(num_buf, sizeof(num_buf), val, 0);
> +	if (num_len <= 0)
> +		return;
> +
> +	if (seq_buf_puts(s, name))
> +		return;
> +	if (seq_buf_putc(s, ' '))
> +		return;
> +	if (seq_buf_putmem(s, num_buf, num_len))
> +		return;
> +	seq_buf_putc(s, '\n');
> +}

Move the above functions to memcontrol.c and add documentation for them.


