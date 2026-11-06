Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFFE606A332
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 20:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lo2URpio
Received: by kanga.kvack.org (Postfix)
	id E78196B05B1; Fri,  6 Nov 2026 15:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E28AE6B05B3; Fri,  6 Nov 2026 15:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D672E6B05B1; Fri,  6 Nov 2026 15:37:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A51B56B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:37:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19F2FA01E3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:37:44 +0000 (UTC)
X-FDA: 85405855248.22.C416CF3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6BFDC1C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 20:37:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lo2URpio;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793997462;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hL/BUrSoards4qYdGTIOreFUsYkypEZCF+8Ircdtmg8=;
	b=1IYYtmtFv3CiW+W77EWBpcZbnEzjtZrvuItAIsYpBeAZbgjcfEvvzVpOgfo1D0plvfhEHr
	kJw62yTi/As30oPUGSR+2CtuGnOcY5st1Rc0S+0TdO145PX9pnF+fVMLa0tmEotGwALYNo
	Pn/qe6opimqjHa6ridxCsQCPi+NGZI0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793997462;
	b=Y4+/Didb9YSaRLFMzf+mMB+fFSxD1Hi2CAQ5zEMQA9FWI9f3W+lIngHUS9V8i0bZFDTjnS
	AorIsZMFw2UNygb91h3qtLJDUSbvUyugUyYuRdW7mc6ac2C7l2uIntqWGI8Xr7Vv3sHyJ3
	s1O1mwnxq3Ay0/28FpIFVVSlZOBxdj8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lo2URpio;
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9EB08414EE;
	Fri,  6 Nov 2026 20:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F47B1F008A1;
	Fri,  6 Nov 2026 20:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793997461;
	bh=hL/BUrSoards4qYdGTIOreFUsYkypEZCF+8Ircdtmg8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lo2URpiocl70MKyDLTSFrmpg8KcAY76MMuNWwwcQvWOehhH5uQV0FyV4Y/FdN8Emb
	 GAGTGMfe2w8upSY/JpFZ4wySfsDQBxcf25rVOUS5emSHbM2rS9M+eBku27OXffpEHx
	 8HsJhOlyfokrRXi+4W9nvRRofp5kVg86OUyjYJHJj6urXwmnbHWZ0SLv0c4OGtwpQa
	 Qje4TovyevPF63aAaIxTfYlyv7eSuaJczPGIpTrQ1oHf4R9r3I9l1uHpxiJ4Dt7r9c
	 xBICCYM3hejhgZPSXfZCG+uIDWFpSOMMsr4BIV6BPIyysCsq//Gs9QPLwLwq8tJHNx
	 CjD6omd884hlg==
Message-ID: <sashiko-outbox-202248@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v24 10/10] lib: add a benchmark of hierarchical
 per-cpu counters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "David Hildenbrand" <david@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun
 Heo" <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>, "Martin Liu" <liumartin@google.com>, "David
 Rientjes" <rientjes@google.com>, christian.koenig@amd.com, "Shakeel Butt" <shakeel.butt@linux.dev>, "SeongJae
 Park" <sj@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Sweet
 Tea Dorminy" <sweettea-kernel@dorminy.me>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Mike Rapoport" <rppt@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Vlastimil Babka" <vbabka@kernel.org>, "Christian
 Brauner" <brauner@kernel.org>, "Wei Yang" <richard.weiyang@gmail.com>, "Miaohe
 Lin" <linmiaohe@huawei.com>, "Al Viro" <viro@zeniv.linux.org.uk>, "Yu Zhao" <yuzhao@google.com>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Mateusz Guzik" <mjguzik@gmail.com>, "Matthew
 Wilcox" <willy@infradead.org>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Aboorva
 Devarajan" <aboorvad@linux.ibm.com>, "David Carlier" <devnexen@gmail.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, linux-mm@kvack.org, "Jonathan Corbet" <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Randy Dunlap" <rdunlap@infradead.org>, "Ingo
 Molnar" <mingo@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>, "Juri
 Lelli" <juri.lelli@redhat.com>, "Vincent Guittot" <vincent.guittot@linaro.org>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, linux-trace-kernel@vger.kernel.org, "Jan
 Kara" <jack@suse.cz>, "Oleg Nesterov" <oleg@redhat.com>
In-Reply-To: <20261105203639.1459524-11-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
 <20261105203639.1459524-11-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 20:37:38 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 9pmbr8oh74gondw7yt1xynmzhb98c139
X-Rspamd-Queue-Id: 6BFDC1C0006
X-Rspam-User: 
X-HE-Tag: 1793997462-190599
X-HE-Meta: U2FsdGVkX19WhjMdHztl8NwTgCByl2h9eaB5vwtXTEC7LcnuMQJZ6c3F5wFHTf6w4Z6xqFVy9DNe40UByxoMd9lTqqkZTxgcJKipNo640Iwv2gJTZLH7XGElodzSK5mQjoo8HhcP1hsOt9pUpH6MYKOBaJfMCT88uKNXaWPRuhb7Cj+Y5hOVDgykcrQn5jEpkuI6sEt41Xw8yKV5amBEtc/lohBXKKSfBha/RrfmLUc7fIH+xU0YYRSbF25mczr3JbdCFuSyBNCmXYckFdoF0AI0ZORHJbiCKZ5iWbfwt4Le3zUC0mCvuYTA+gySWrB92W5EK1BPbRN6NO8Y1dwJDTGpP1dVNMwO1DuI+F3M854V9PDnI6JSWl4GFz2NIMLNMjXye3M3VjofCbiudEnsvrGQcfWdzAl2/2hWEPih+9jcCX2hsftNxMPCgkXJ7eIaWXBSQ61bE3SwdMWC2GnuXdSYCYc3p1W8lasqKtHxxUej/h9cvrhAKpF4IpqmQ4l6LMvdnU/ZB6MGtUUatHMEl015VMRoMz/Le/luVv7SZ8h7W7OUZvToMJXHZkkMHHrrdZtLpOuZYKNIkiuY7AtytH0s3//3lh4dmBQn42kZ1Np9M63/ZITBgD3O/s5plAHclj/NHPbVmsJCgdaMt33TW88GhdNs/5VqRGIZbDPQnwcE2vyiibjtfIaFyVuBMr9TXD0imP8cnhBNL77G2lXS6NMgv7CgwXys3hQe51Rpq0fZbYyuCptLLwpn0wzILBXm5cyxzWap2+opwE7VWRTF6Hm0DLHtlqXvSMMHQ1+3+mzWxc3N7+lEDK3dYyMrIvPWObcxRre+QGrw0cA+2gMjTsHWFRBh8S7xtqqMWJLuytAUB5mNOJnMuSA8+PPHwlbD7cYB9ooJFTkZi2RU871wA746OCSwjfwnRrEFCgavio1vQ4o0Ofn58WAM1W05M1qxuY4LnCKtIoQJuc1akWa
 8u2ReUi8
 an2OQo8WTPCnSg4ZOR4umR4rWq3OASYFbdz1jF54buwxRP8K7K120Kq4371Ysu1NjJGLlPL3oAqwcndirXWyb7wBsZf1BB0W+YrkAOtVq0ivtvKNbnP3iMRMdOXVerBfB8s9hraDdbInANLTZBYNIfbHyKA0g1MIR8yEOFy1wo3Ukwr/WNqnsfuaVxvkXFF3sUYReu7R5MA1AHDdH9fa2Fah23AHekYM+SysKcPad5LW8SXWgCkoGoustKP/+0yE4svV5jK0FVb9l3dgXI/3VEgOjDKVbFExdnF+FnCYqa32+P6xcmGURrvUa9WkI2PwZHm3myhdKD+nUTvRbpIHTRPVCsWKAoDuTIMSBkOvPE+Nn3qgP5Po9682HW+IS1ee/vIX5mO3l0dntwxM37sDMa1I7qwDhmhr3Q0xgC4tBbo632eyUZv0yF3Twa08vzGYlEuVSUqhxWMBl1Etc8fkGtKQBaVdA40DJK34VqFGFOPgPD/CA0ML8QJD44Uhma9P88UJtJTSwTNt7jeQ7R2MzyqOyGRgT0VU6I2DCchA7uyyq0e3pUCAk41KF/zHrK9oAU8f/aAlKDTD0e0xXYhXbXzt0W5MLGRh54nzwh1AaPzDUUrvVTiGT48LOirr7UX5llriVHPQKzuOBFuVMcseIOdkCteF6B3Z/1+9AHiMrPn78X3XphIxda0mIxxiuHo6D8AscCA4P57EPqAQdWa9/A3eYbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] lib: missing kernel-parameters.txt entry for
  percpu_counter_tree_bench.batch
--

commit 88946339b389754c894fb27102ddde74cdda534f
Author: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

lib: add a benchmark of hierarchical per-cpu counters

This commit adds a KUnit benchmark comparing hierarchical per-CPU counters
against struct percpu_counter across update, lifecycle, and churn workloads.
It also introduces the CONFIG_PERCPU_COUNTER_TREE_BENCH option and a batch
module parameter to configure the counter batch size.

> diff --git a/lib/Kconfig b/lib/Kconfig
> index 3921177a0d243..6ab9644a4cb83 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -53,6 +53,21 @@ config PERCPU_COUNTER_TREE_KUNIT_TEST
> =20
>  	  When in doubt, say N.
> =20
> +config PERCPU_COUNTER_TREE_BENCH
> +	tristate "Benchmark of hierarchical per-cpu counters"
> +	depends on KUNIT && SMP
> +	help
> +	  This builds a KUnit benchmark comparing the hierarchical per-cpu
> +	  counters with struct percpu_counter: update cost with all online
> +	  CPUs updating shared and private counters, and init/destroy cost.
> +	  It runs for a few minutes on large machines.
> +
> +	  The batch size and the tree shape can be changed with the
> +	  percpu_counter_tree_bench.batch=3D and percpu_counter_tree.arity=3D
> +	  parameters, see lib/tests/percpu_counter_tree_bench.c.

[ ... ]

> diff --git a/lib/tests/percpu_counter_tree_bench.c b/lib/tests/percpu_cou=
nter_tree_bench.c
> new file mode 100644
> index 0000000000000..e041ba8ba8c74
> --- /dev/null
> +++ b/lib/tests/percpu_counter_tree_bench.c
> @@ -0,0 +1,610 @@

[ ... ]

> +/* Like the RSS counters by default. */
> +static unsigned int batch =3D 32;
> +module_param(batch, uint, 0444);
> +MODULE_PARM_DESC(batch, "Batch size of the hierarchical counters (power =
of 2, 2 to 128)");

[Severity: Low]
As reported by Sashiko on RFC v23 [1], lib/tests/percpu_counter_tree_bench.c
defines the batch module parameter via module_param(batch, uint, 0444) under
CONFIG_PERCPU_COUNTER_TREE_BENCH, and both the commit description and the
PERCPU_COUNTER_TREE_BENCH help text in lib/Kconfig advertise setting
percpu_counter_tree_bench.batch=3D on the kernel command line at boot along=
side
percpu_counter_tree.arity=3D.

Should percpu_counter_tree_bench.batch=3D also be documented in
Documentation/admin-guide/kernel-parameters.txt?

[1] https://lore.kernel.org/r/20261102190708.1287100-11-mathieu.desnoyers@e=
fficios.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105203639.1459=
524-1-mathieu.desnoyers@efficios.com?part=3D10

