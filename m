Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F00ABE668A2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 23:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA2F6B0088; Fri, 19 Dec 2025 18:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371406B0089; Fri, 19 Dec 2025 18:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2702A6B008A; Fri, 19 Dec 2025 18:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 172A66B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 18:07:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B872113396D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:07:30 +0000 (UTC)
X-FDA: 84237759060.11.82150E3
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id E39FE12000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:07:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u39UQgTq;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766185649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UxbH7/QY+8GEwV0rueVzSKiGoEoy6NGLSngPmq+y6I=;
	b=D5mFC85SloHadxxnsb5oVBezX2VIcEGdPQvhnLpJuidbulJigcwkKbYN6DpX4YV790UMnK
	WcE7xEbneB9SELlKPDiSMcxce8LHTIMVdrqf7+Yr9XO2+JNDYKpBpYqYv3bdn4T56dxbjz
	0bulQiht0Tdj6A9Ngw1GFeeKK+BdMGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766185649; a=rsa-sha256;
	cv=none;
	b=gQeLipEWPLiq2Rk0Jef4lCGXtn5EbMwsuiEIE1pc/Pg4dHCZEhFt0Sa5Znb18aH49Nh2cK
	oNC8PRPGKfAS9i1vUCptTihrJPAB7AFr1OVLEJq1WspGLxtHUuJks0ne8BGu4/tisVxcf1
	AszBUOloBPXSkWtLq7PKGkMx/jr4BPo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u39UQgTq;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 19 Dec 2025 15:07:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766185641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3UxbH7/QY+8GEwV0rueVzSKiGoEoy6NGLSngPmq+y6I=;
	b=u39UQgTqEkUaY63z0CDXE/GoT2fL7qAK2LEWgWvC1yEKtwwvSvTK9RkCzrvcUNV9yP45rF
	0ELxSvTgF2yX9Q0ofCaUrk49R/LBVsdMf5o2qjBWyAGmYGChxjZxXwMa7tSUPIcH1b+/UY
	D2XOTVj998YROjj0Sugli2yXd8/YIYM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 6/6] bpf: selftests: selftests for memcg stat
 kfuncs
Message-ID: <2xhmcrporen72rskghn6hmg6obnojptuerwzqgu7mqzhnxaxs5@33dxlwa6rqlh>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-7-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-7-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 63q67dghizzjzkjjaw7ewj1zau8s4jxa
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E39FE12000A
X-Rspam-User: 
X-HE-Tag: 1766185648-994136
X-HE-Meta: U2FsdGVkX18222SmuyRWgfqDaJy96SBTzIkOhJnTPw9IobOCz5wLedAgdEH26vNVqzjW7oHycZRbqynlfb/sbdWd+c+pAG0RxMngIaX+YKFPQpH8pw5rfnBo+J9RuMq57TZMHiI+PnBgHx3UW3XUiajDzhZB9FZEOqTvpf8NuXhA1vZ6LbiAvysg0rFkFqA84zE4ORo/5RIMJMZl9Ai5sHih2wloYFuFSH5zhvNUbXt+Sd2PNjRba/pIK1NX4X8sAa9E62qR9s07Lf3nSybDQd2yuR1qSy1VeWJ6HYhRkxrHDfeYlO1U6acI1+QKbPRjv1qm54rHJIKXyU0+wVe4rryjFBoFoYc4urhLwudADsgsKb0uD5lBy4MEhRwHVRMz/kndZV21SwTdSv2H21rS3//V/get2lasRUOxUrUysRe87nPJEPrgn8K35pXIRVtOU9tK0l92B2WpFrQ4nm19sdNK6AB3e6DYXdvpsMimHoNfTQL4smlu/ippq6ES9yReouQ9c3smBEqie9ZQN4aup1qerH1UNnHdvIELW6wQEFF4p8c/vCrmC27j1mdHCVqKis3ElPDDquP9CuafkI5eP82fYOhRV12rAODaTaFhLfEy/pf6sYRVkGbHSr9Z8qWcBD+HKgCRnmByJstbnOVNy5zvfJC6kb2/4fI5gM6MJziHj7PiHjVVCwRaDGaqqN6MRFRiuoiyNls6pdMEYuoG4De/nUmPszpYZHUqdZZbbqj2GyidXXo6jgdVEvq4xzgsYWyjGJ/XV7JAi+e3IZrJyxfNqc6sXgOrjcq90O4854oGq5UZe+K8IxtVu5czy0X/lKP8DXAzWP14Le87zJUgDt78xGschtBt19O7UxMZucwBiJ0a1g1me6idgswG/x7HhVrsJPQAZliXjiZMnTOW5ptQBxSUSpew4HBIYeSaUVL8I1ktFOW7+n1UlV+B31b1qfJILBln1qWhTsrFNg+
 C2so/VWs
 MfkamdIBLEcrsy/9+mkwEGjIwGnmeoXDaE9TWWn2naA4lYmdlNX7cLC+wXlSr87OvE2VMziL6TCatWwFUGWkT3NJlGwvgvsvzRWINLUbNNxZIOVp+jou+YWb8qsrs95ucldRpDuTKUajt4mF1HwcltWMnm+IUdldK6crE2gPuVbGYW4/5hAZ+NZjFGWoUOiWkcdpPeOHXyZ0K5p99AddONejWRqSCeGIWwDAZaHReb2oDdM6yeDpZePb3TcGE5Zx42yIHdpYotZdhuhQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:50PM -0800, Roman Gushchin wrote:
> From: JP Kobryn <inwardvessel@gmail.com>
> 
> Add test coverage for the kfuncs that fetch memcg stats. Using some common
> stats, test scenarios ensuring that the given stat increases by some
> arbitrary amount. The stats selected cover the three categories represented
> by the enums: node_stat_item, memcg_stat_item, vm_event_item.
> 
> Since only a subset of all stats are queried, use a static struct made up
> of fields for each stat. Write to the struct with the fetched values when
> the bpf program is invoked and read the fields in the user mode program for
> verification.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>

Need your signoff

[...]
> +
> +#define NR_PIPES 64
> +static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
> +{
> +	int fds[NR_PIPES][2], i;
> +
> +	/*
> +	 * Increase kmem value by creating pipes which will allocate some
> +	 * kernel buffers.
> +	 */
> +	for (i = 0; i < NR_PIPES; i++) {
> +		if (!ASSERT_OK(pipe(fds[i]), "pipe"))
> +			goto cleanup;
> +	}
> +
> +	if (!ASSERT_OK(read_stats(link), "read stats"))
> +		goto cleanup;
> +
> +	ASSERT_GT(memcg_query->memcg_kmem, 0, "kmem value");
> +
> +cleanup:
> +	for (i = 0; i < NR_PIPES; i++) {

Instead of from 0 to NR_PIPES, we need to go from i-1 to (and equal to) 0
otherwise we can potentially close() junk values.

> +		close(fds[i][0]);
> +		close(fds[i][1]);
> +	}
> +}
> +

[...]

> +
> +SEC("iter.s/cgroup")
> +int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
> +{
> +	struct cgroup *cgrp = ctx->cgroup;
> +	struct cgroup_subsys_state *css;
> +	struct mem_cgroup *memcg;
> +
> +	if (!cgrp)
> +		return 1;
> +
> +	css = &cgrp->self;
> +	if (!css)

Will css ever be NULL here?

> +		return 1;
> +
> +	memcg = bpf_get_mem_cgroup(css);
> +	if (!memcg)
> +		return 1;
> +
> +	bpf_mem_cgroup_flush_stats(memcg);
> +
> +	memcg_query.nr_anon_mapped = bpf_mem_cgroup_page_state(memcg, NR_ANON_MAPPED);
> +	memcg_query.nr_shmem = bpf_mem_cgroup_page_state(memcg, NR_SHMEM);
> +	memcg_query.nr_file_pages = bpf_mem_cgroup_page_state(memcg, NR_FILE_PAGES);
> +	memcg_query.nr_file_mapped = bpf_mem_cgroup_page_state(memcg, NR_FILE_MAPPED);
> +	memcg_query.memcg_kmem = bpf_mem_cgroup_page_state(memcg, MEMCG_KMEM);
> +	memcg_query.pgfault = bpf_mem_cgroup_vm_events(memcg, PGFAULT);
> +
> +	bpf_put_mem_cgroup(memcg);
> +
> +	return 0;
> +}
> -- 
> 2.52.0
> 

