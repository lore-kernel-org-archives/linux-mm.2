Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB118E6689E
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 05:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 394026B008A; Sat, 20 Dec 2025 00:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E146B008C; Sat, 20 Dec 2025 00:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28ED36B0092; Sat, 20 Dec 2025 00:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1792B6B008A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 00:22:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A0F688A3C8
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:22:35 +0000 (UTC)
X-FDA: 84238704270.30.1DDEE68
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCF5C40002
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 05:22:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KH+wF+o5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766208154; a=rsa-sha256;
	cv=none;
	b=IPegsFxZSZ8AgJxZiygT5/iANZKJrLCSUU1KivMIvZWw6nbsKgTx5HIME28FYqeSDBNbhO
	uqjWY3dEzQDiQcv0dCNhfIg54K5prVMQfUn1JKW4qt3NT63EhJRykT1DvcbTK1RGNBxXsv
	esbR2bhOlFF1C6r3OlDINgDcqlm+C6U=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KH+wF+o5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766208154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YRJJnVvo1S8vGlvcaON1dsHnBa7Zy6UwXo4KZ5weDA=;
	b=lmwoEiZVO0+3AAYeIoNzEMHAbj/w6P1jcQWr+DuOU82hVe7byGti30hHMNAtsZ9uw0Ibbg
	hAV5drn50m6/lckvxXGZRqGbpHPsFTMUwDxTYLDfpxcaak0yN4QsC4JR1GHY3ggNnArgJa
	ajKTM80q2BPWEZT8LXo5U42jRG/6HXo=
Date: Fri, 19 Dec 2025 21:22:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766208152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3YRJJnVvo1S8vGlvcaON1dsHnBa7Zy6UwXo4KZ5weDA=;
	b=KH+wF+o5MLgKaRSa3fuoj/1RbF++SdkafoEGMVQtW2FX8PLapm6LcbCyJMGTxFxbkJDC+A
	hp4fbJw1/lMwFmdOCNO8O6rTscBhajVKqWroTXppCdSQqJGH1BKTh0hgTdiDBQAtMJImkJ
	ZhL7vLxfVQ+gspHosx4z9Oeyd83sZss=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH bpf-next v2 4/7] mm: introduce BPF kfuncs to access memcg
 statistics and events
Message-ID: <ydnm423ogjcs5bb4d7b34hrz75spau4tehdhv6s4qdhyftwjot@moug4iitzgzw>
References: <20251220041250.372179-1-roman.gushchin@linux.dev>
 <20251220041250.372179-5-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220041250.372179-5-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: DCF5C40002
X-Rspamd-Server: rspam10
X-Stat-Signature: f3zxxjft8bhwmcd1mtqcfgbmym8wgfyz
X-HE-Tag: 1766208153-469375
X-HE-Meta: U2FsdGVkX1+G+tr9G/O37cbSwfP6i30v74tNOMa0G6XYTdrhQ50OusCa/HSmk2di2X3Mt+j6knmFCWBlwBf02elwRQtsAJLAsSx7uF7B8+EKCvUZwkv82sVSWf+hUoOpSe8IvpGNqBAg4uH2g1mKjM1q+X2tb63P8icxXQxfz/PzlEEU+SQwcfn3rombwS/r6CdzQbJ1iXzEsZw2eaEzBClZnwU55nLia9die48IUHd3qbEUR0l8IxlGPFXQJLOrm29PbIFe1Sxtm+ROGLcRGQLEkW+qHKkd/nQYk602PPvmyoGxLt9UCWTwXE2LMNlkPJ7sSsuHDDhhY9xzSktXrdAR9/M19wdvG4zhpclAje6kWeUjLdDOlYVqFZl8yUyMGwaIt0tMPBtEDkUrZCPScu3ztwJ/8r3IsLJfoS1byqdF46mpYkPx7xTWiX3YsDeI4sgGOffst9vJIqfieEi5sSz/t9jyaGNTNBgymgD0hzE4adjIZLK1Mxdlc5ES0UaCbbUXu2Y7KdzZagvMilEi9CFgtPLJRW3bau5a/mCtII/it6ogVb27dlkHAF6PxjpmxurjQjXn0ObKzG6eML2i+Cqk/vQxLcA49xl2kUN7Jyv0QScLlxMGVWAGSvxtLtrHeTkeHRwZiz0XbO1+x0BfMKRwJcEMcc2rNIMUJks0SXaxHHYdBC02qqvHCqd0NptcFBK3cKL4e/uESSs7txwrlILW547FeGv7dKn0zh4JNoCCtYBNw0Hy/MWbTiFRBKhRq/mWYz31kId/x/xgWPfgyrRCy/XWvb8D9dPDCp2APOigxgZhTQZP/Ok5gkwzNkSS4+5pDirophOFnlEccZOMZuJ64DuHzlIsDqHtaI6Mq8PvHi27tpisWcazuSCIjN3uEAXjPlMCHh8s2kdlXB+knoNoa25Qz/GeP4kw7g2KDtk78/GPFV1D87tD0n6KzsJNbUjrVf6wsc1hTuWd+S+
 5kq70fKE
 wJnVsIwnPMU8i/OAXwtleJNIwK7TtGKoYkXbHpc9j7ziXznOpuxlrsX11FGFdknrz9vJKNi7rN+mzxyn1PMFST1qAt9X2uQtXQ3vgC9iwGEulhW0r3+ienwoqPso4THRpqIycq/fQShxOEgOr8UQJLzV6j2s7PeJyoieAAVJHuGOAULS+GN09B3dUiNtBFH41A+KJKoLrh3Bx6VXeT6zr58t/138USGjrx04qfKY81ibLPcr4BD5Ps+/Y5Zw1948AVqt8KlT5jbrm7CqFKTIV5LMTf+Lmru/QpOwu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 08:12:47PM -0800, Roman Gushchin wrote:
> Introduce BPF kfuncs to conveniently access memcg data:
>   - bpf_mem_cgroup_vm_events(),
>   - bpf_mem_cgroup_usage(),
>   - bpf_mem_cgroup_page_state(),
>   - bpf_mem_cgroup_flush_stats().
> 
> These functions are useful for implementing BPF OOM policies, but
> also can be used to accelerate access to the memcg data. Reading
> it through cgroupfs is much more expensive, roughly 5x, mostly
> because of the need to convert the data into the text and back.
> 
> JP Kobryn:
> An experiment was setup to compare the performance of a program that
> uses the traditional method of reading memory.stat vs a program using
> the new kfuncs. The control program opens up the root memory.stat file
> and for 1M iterations reads, converts the string values to numeric data,
> then seeks back to the beginning. The experimental program sets up the
> requisite libbpf objects and for 1M iterations invokes a bpf program
> which uses the kfuncs to fetch all available stats for node_stat_item,
> memcg_stat_item, and vm_event_item types.
> 
> The results showed a significant perf benefit on the experimental side,
> outperforming the control side by a margin of 93%. In kernel mode,
> elapsed time was reduced by 80%, while in user mode, over 99% of time
> was saved.
> 
> control: elapsed time
> real    0m38.318s
> user    0m25.131s
> sys     0m13.070s
> 
> experiment: elapsed time
> real    0m2.789s
> user    0m0.187s
> sys     0m2.512s
> 
> control: perf data
> 33.43% a.out libc.so.6         [.] __vfscanf_internal
>  6.88% a.out [kernel.kallsyms] [k] vsnprintf
>  6.33% a.out libc.so.6         [.] _IO_fgets
>  5.51% a.out [kernel.kallsyms] [k] format_decode
>  4.31% a.out libc.so.6         [.] __GI_____strtoull_l_internal
>  3.78% a.out [kernel.kallsyms] [k] string
>  3.53% a.out [kernel.kallsyms] [k] number
>  2.71% a.out libc.so.6         [.] _IO_sputbackc
>  2.41% a.out [kernel.kallsyms] [k] strlen
>  1.98% a.out a.out             [.] main
>  1.70% a.out libc.so.6         [.] _IO_getline_info
>  1.51% a.out libc.so.6         [.] __isoc99_sscanf
>  1.47% a.out [kernel.kallsyms] [k] memory_stat_format
>  1.47% a.out [kernel.kallsyms] [k] memcpy_orig
>  1.41% a.out [kernel.kallsyms] [k] seq_buf_printf
> 
> experiment: perf data
> 10.55% memcgstat bpf_prog_..._query [k] bpf_prog_16aab2f19fa982a7_query
>  6.90% memcgstat [kernel.kallsyms]  [k] memcg_page_state_output
>  3.55% memcgstat [kernel.kallsyms]  [k] _raw_spin_lock
>  3.12% memcgstat [kernel.kallsyms]  [k] memcg_events
>  2.87% memcgstat [kernel.kallsyms]  [k] __memcg_slab_post_alloc_hook
>  2.73% memcgstat [kernel.kallsyms]  [k] kmem_cache_free
>  2.70% memcgstat [kernel.kallsyms]  [k] entry_SYSRETQ_unsafe_stack
>  2.25% memcgstat [kernel.kallsyms]  [k] __memcg_slab_free_hook
>  2.06% memcgstat [kernel.kallsyms]  [k] get_page_from_freelist
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Co-developed-by: JP Kobryn <inwardvessel@gmail.com>
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

