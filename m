Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83AA6CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 05:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21518E0007; Sat, 20 Sep 2025 01:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8F68E0001; Sat, 20 Sep 2025 01:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936AB8E0007; Sat, 20 Sep 2025 01:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 834858E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 01:17:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EF2881408CD
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:17:58 +0000 (UTC)
X-FDA: 83908471836.08.7ECB8F3
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2746140004
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:17:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j24FtfcM;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758345477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PntaZnDYX/QEEVIWmBGVBGCPkGUIte8JIXB6ZVeo8rE=;
	b=cIfacPLm8A9KnZ9IsaxKLhwlgh1cAWNAeLnsAYhiMzJoiiodZFg+tDw/Pzy9GN59bfbfMu
	AInaYoOnIyLzZQUNIVLGVJi+n98VsoB7MrokGDUzEEQ6XunrdDXiZ2DmQUOIWHqoNKzhnv
	0ddfC5LORSf4FIYyVlHww2rdsiJ1iLU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j24FtfcM;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758345477; a=rsa-sha256;
	cv=none;
	b=bbHG3sV5K14XJqUyTLDqV7/PwhGeOLHH4xnFW8pkNqoxK8X37bZP9BGKCK9Wn4uuKVyij3
	hJCyCisqOO81VJtPQvGHgz5iIfedqKYkMGnVSFDFDL5RKC8SzsCyJtkLISI8/i9PCIfurR
	y0WlzOiMbhdBZsBFnzLd4GVZe5sLL6A=
Date: Fri, 19 Sep 2025 22:17:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758345474;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PntaZnDYX/QEEVIWmBGVBGCPkGUIte8JIXB6ZVeo8rE=;
	b=j24FtfcMKfLk1zGaPV+iRbntXu9JfU3X59WP5fTeivp0kAwohHy32yNT/wbHlQsH5+TUtb
	Kuo9QOj25sVXoZWZ7Ih4rDWMxu59CHcUKRze5iVl5/scgMv3eIKu4xF44s479kyolJLRhf
	BKcFaivHCCQYqzk70bD7M8YqPXGlIoA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: mkoutny@suse.com, yosryahmed@google.com, hannes@cmpxchg.org, 
	tj@kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH] memcg: introduce kfuncs for fetching memcg stats
Message-ID: <ky2yjg6qrqf6hqych7v3usphpcgpcemsmfrb5ephc7bdzxo57b@6cxnzxap3bsc>
References: <20250920015526.246554-1-inwardvessel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920015526.246554-1-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5jsshuch63i45kbfgqre6neadtii8fe3
X-Rspam-User: 
X-Rspamd-Queue-Id: 2746140004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758345476-803572
X-HE-Meta: U2FsdGVkX1/bbM61/TUZC9YzLivwvjxDDwTGfK0eWCYgEDCPiYkgg/+BO13xp0izTGkdTCWYDYaa2QnZYVnmjWaK7G0Fciw1ooor8XEKz14Wv1HLyUx4u00t+4/FSMPHryYn6Ps9j2Jfi5B9l3LUI7gXI4S5MWvamOfF5uo0MNcxiF9McuiA80vKtDCwnYXVOMETPlHLDLhA42gzEy2c4g0kvSBeWblkMqX9SpqGNMlX7TzhD7PhqRrF+pyHV/0ouvpzIZx2dNraN8adH96zBwItA6unAVL2xwrw3HqJKKuVVu1EF00nyGlfFOycyzPEgv/dcvmMpSmksJreNIxpjSU7o1lfpuNY8WaY9gn2j+gXSrZ0CJOZyibL4VQ/zng/qPQjl32f096r7DJ9ca8IQAVzmLufOiR1+nIaYYY3RzO4RJuNgVXT03QxsPvs0hF4sLLR8N0ydaoEutNAVSyjpUsxIYiFbSEfOsQ2+saXzXfkQgir951RlIYOsM7hCDYj4mhS+nMrt9PtCNrTYymbYWUR79SYY/+AdOEhbOJaIZZPCadU3UL/0BLjW4LVTX7E0/Y6ZiezXDj32l6Ua+EdrBuwrE/vGloxG3s7O0uCs1XenI9Mhvivuh05+5CzGMsKeiKKAMzWzbn1AG8ZB6/qAEZ2BkNKXpcUtYWhg4YLJWwOcwRHbgJdEJvDzHJ0Dj0QWDI6Z+Ok/U6JCh2LUZr7Z4Gp+lJDihYXbIOgqcrPXlKNxyhZNNT+LsB2B5PNaN6JK6GN3qpaLMOQuVK6sPx4o7Y50mYXA8+yfbaVcxrMYXrKG7zT/azqa8jsDuDN0uBlB10WJTbtXu7gZF+Rougb7xL7xjKOtyUX5Thr0e6/bynBE2+DnHYhcYQ2a17H1UvYTfrLnNfEpfuxWEu013o+Nz6Mn4h+CL20hw9rw3aFoPYJD11wdUiyCvf35FqOISAlqGmysQGPK9vU2KGASi+
 0wB9qUS5
 8ZVeC3V12B3LWsQOLcipBzcpNduaoDOCGth5TR/2tnNDNFBni/wCFRnjNz6FfA8HDOdUqsDLmMIvg0mlqKswwqoxg0fhhVli8KOO0ihfCHQADIPUSv+EVTEuhgaCsY76ouPM5uApmz7LENrQIkl7hTBr9XWrRDu6vsBA++AR5mUSmsggAnFuYjera7KzI7uplKWkDYnKVKQ9/yzNwtK0sFkQIxNsWqWPvWvAINtqhWFoZY48=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+linux-mm, bpf

Hi JP,

On Fri, Sep 19, 2025 at 06:55:26PM -0700, JP Kobryn wrote:
> The kernel has to perform a significant amount of the work when a user mode
> program reads the memory.stat file of a cgroup. Aside from flushing stats,
> there is overhead in the string formatting that is done for each stat. Some
> perf data is shown below from a program that reads memory.stat 1M times:
> 
> 26.75%  a.out [kernel.kallsyms] [k] vsnprintf
> 19.88%  a.out [kernel.kallsyms] [k] format_decode
> 12.11%  a.out [kernel.kallsyms] [k] number
> 11.72%  a.out [kernel.kallsyms] [k] string
>  8.46%  a.out [kernel.kallsyms] [k] strlen
>  4.22%  a.out [kernel.kallsyms] [k] seq_buf_printf
>  2.79%  a.out [kernel.kallsyms] [k] memory_stat_format
>  1.49%  a.out [kernel.kallsyms] [k] put_dec_trunc8
>  1.45%  a.out [kernel.kallsyms] [k] widen_string
>  1.01%  a.out [kernel.kallsyms] [k] memcpy_orig
> 
> As an alternative to reading memory.stat, introduce new kfuncs to allow
> fetching specific memcg stats from within bpf iter/cgroup-based programs.
> Reading stats in this manner avoids the overhead of the string formatting
> shown above.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>

Thanks for this but I feel like you are drastically under-selling the
potential of this work. This will not just reduce the cost of reading
stats but will also provide a lot of flexibility.

Large infra owners which use cgroup, spent a lot of compute on reading
stats (I know about Google & Meta) and even small optimizations becomes
significant at the fleet level.

Your perf profile is focusing only on kernel but I can see similar
operation in the userspace (i.e. from string to binary format) would be
happening in the real world workloads. I imagine with bpf we can
directly pass binary data to userspace or we can do custom serialization
(like protobuf or thrift) in the bpf program directly.

Beside string formatting, I think you should have seen open()/close() as
well in your perf profile. In your microbenchmark, did you read
memory.stat 1M times with the same fd and use lseek(0) between the reads
or did you open(), read() & close(). If you had done later one, then
open/close would be visible in the perf data as well. I know Google
implemented fd caching in their userspacecontainer library to reduce
their open/close cost. I imagine with this approach, we can avoid this
cost as well.

In terms of flexibility, I can see userspace can get the stats which it
needs rather than getting all the stats. In addition, userspace can
avoid flushing stats based on the fact that system is flushing the stats
every 2 seconds.

In your next version, please also include the sample bpf which uses
these kfuncs and also include the performance comparison between this
approach and the traditional reading memory.stat approach.

thanks,
Shakeel

