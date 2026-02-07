Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D40AEE6B6F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876516B0005; Fri,  6 Feb 2026 20:35:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D6A6B0096; Fri,  6 Feb 2026 20:35:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776EE6B0098; Fri,  6 Feb 2026 20:35:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 688266B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:35:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 11E75B810F
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:35:35 +0000 (UTC)
X-FDA: 84415943430.10.8B9117E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 546E340008
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:35:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOBVLw19;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770428133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K089xnRX7q2FeLqzY5IRMuOpJ+hk8ZA09ZMjR+SZawA=;
	b=rb9NilM/9OigEiBiBW+LtzMtQuUTP14KJ4kfcIfzM5tldjK3Nh5naSz/wol5wV5ZolnxLh
	f0F56lLBeEafz2AmhYzY8t0iYsDRSmzujzefHQppzjNjktvV4JWWhP8BsDUFLLwIfv3L9W
	SNvwOaHvVeatmzXYRkDUIjy1NvKuBDI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hOBVLw19;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770428133; a=rsa-sha256;
	cv=none;
	b=2C8w26PfAJrCNhMMxQi9jxHMStaBzvaMTB8uxYkZMlAF7GB7Ds9f16jxWUhb60fsKJ/sTb
	XoOd0xgOuaXj//5u6WQ/yIFFebEH/NmMBtcox/lCfj/Jzu3C9mqRJEBaaJye8fxBjCykQ6
	NGL5paeG6U7WGGntyP5b4FyAX3ENt1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4005243C49;
	Sat,  7 Feb 2026 01:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB27CC116C6;
	Sat,  7 Feb 2026 01:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770428132;
	bh=UQZjrgT2+C5sGvrewfIsj+BiY95FtrloV3QjcSk1pj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hOBVLw19hzyNdvsmQFl6r4uIKKUUC1+sKGnWq80YxOP0V9mrY7/cfavno86LKYHvC
	 o2u/2IvPeLCTwpr1u69Gd2OZgXkYL42bXtGUrDIwhqd3UOwtWE0mB7m5cl52QAK6R8
	 xMCsnFfJ+YDVX/JfqVs0QW+mix1NbuE4CaB1U1CcoAZ1MgJSK+lbqP4bezSjfJ4/26
	 W3lx+jo1IkzWOnMHhIJcmYqTlxA7wUQM41TlV1ykOEz+Xq4xVAlzkC6jiK5HhwK6cE
	 5QnJQSd6q6cEsYsLPl2jtGtCxxqtmDQUmn2NOXUSII1asL/H0uqKNJdVEwSYAC10wO
	 oVXHqRg9SbsZQ==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: add test for zswap incompressible pages
Date: Fri,  6 Feb 2026 17:35:28 -0800
Message-ID: <20260207013529.69681-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206072220.144008-3-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: o6s3qhynbz1mndg4j9enn8fb6knzcm4x
X-Rspam-User: 
X-Rspamd-Queue-Id: 546E340008
X-HE-Tag: 1770428133-961198
X-HE-Meta: U2FsdGVkX1/kdxVlPz/UWx9A/GvdErrCLx7TyT5Xd6wk44fZ2Iuge/SPUHZF+S+Ye1OomF6yjS3gCnJkWeUutzCu5/rov7EqYLofTOrpg1By5RD+VBbBK5Ht0DlguLN5ljKpjY65xaChEe6pzRErVAZmzs/fgosGbbcbIk/B21K+sR/lb69P4lmFbGdXQi4OrV0P7iV85d6WX7BoHmiL7mBYZY8r2aXvtxOGR+tUQ1TNJAtOjUyBNCinE2yeb5YNqBmHEAN52D+Je0iBfuwnr/JCyaViEGw4MQWIGk08wXQMnZh9hRykQtiu3i/rhaTXz6hT0tbRgPsqdrSARCkhk2s/SRsjEYIfI93ymDunPf2JWJdr02WOIAsp17xJJ2ExoaPfgM8zcexKdKQRP/CMTJlAiFj27j470m92daT7aQ8GAFfgJ6uaHFRBZrWpm0d2RtBG54YaqKRhouZUCjzX5Z23oLV10dhRigsP2FKVbvG/+dQcezf1Attn80XVXRsqY3IJyUuGpkjheb6Z/tU4Nu77lVUNPd4yyJmXBYZOZ3DlvGuZC1bXiCMmGNbFUrzSgZHKgrHg8lUl1FOmjltqbdoVkydAFEOqxqhfX8T+R6FYcsZzGXCEkPp/W/aWcs8t7z7RuDSpJjHqKqxAO393lA4qdb+eRCkpZFr6EoiiLVRdSgVsWt3g1fEZ+VDc9XR522mySUUN0YgB8+oD+JIOk9WnE3KRf7NK3rVfGcqasYR4c5ZZH85xe3E1mVYfKQWPN3AO+hOIJ2XuYOMhM8vvnFqtDGF0MyFmWdb4BhDFlIMX6+rmSlRVUHCtQkD/8FasrP3w8TpKJ5tVtO7FWPpgOvuwuJqWmVvglRjmEkzmqNdcxmBr1K5y2wGTDsGWrRl7cvNzbOaMaYpZNEmvpPmnHWPrdiQwL3EENeV8Pkda8GOmaH+wHDbhnDppJUuhJkdSn1Z9UluZ3BkU4B+7igZ
 SB1nNaYO
 hIutD1SyY8ARF6Txy5VJ8MjPnbE3kgyjJggTamKcQu2hcT6T52ANcFWGBZHp5VCXzFmogPmyVOJ5gdXJxvrn4FpcBBDWGyRZIMWI3bQI5oAfpbbHd2Ct6yIAQIDi1ROWtWnWJwebyx05rdYg2U7ikf+tSM9z1h2EvBjx9+afy7ttjuBPsOYOiPpmGEjxic8QCqs1vZVRvRwtfYIECOU8DROFBEvZ5wGJVh/EDUpdXijWViwNwaD+sFliTToCR8DsHpRoneMzbS/Q8T4WzwHzOKsRkkZkEfvo9J+Jt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Feb 2026 15:22:16 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Add test_zswap_incompressible() to verify that the zswap_incomp memcg
> stat correctly tracks incompressible pages.
> 
> The test allocates memory filled with random data from /dev/urandom,
> which cannot be effectively compressed by zswap. When this data is
> swapped out to zswap, it should be stored as-is and tracked by the
> zswap_incomp counter.
> 
> The test verifies that:
> 1. Pages are swapped out to zswap (zswpout increases)
> 2. Incompressible pages are tracked (zswap_incomp increases)
> 
> test:
> dd if=/dev/zero of=/swapfile bs=1M count=2048
> chmod 600 /swapfile
> mkswap /swapfile
> swapon /swapfile
> echo Y > /sys/module/zswap/parameters/enabled
> 
> ./test_zswap
>  TAP version 13
>  1..8
>  ok 1 test_zswap_usage
>  ok 2 test_swapin_nozswap
>  ok 3 test_zswapin
>  ok 4 test_zswap_writeback_enabled
>  ok 5 test_zswap_writeback_disabled
>  ok 6 test_no_kmem_bypass
>  ok 7 test_no_invasive_cgroup_shrink
>  ok 8 test_zswap_incompressible
>  Totals: pass:8 fail:0 xfail:0 xpass:0 skip:0 error:0

Nice test.  This is also testing the functionality of zswap's incompressible
page handling.

> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 96 +++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
> index 64ebc3f3f203..8cb8a131357d 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -5,6 +5,7 @@
>  #include <unistd.h>
>  #include <stdio.h>
>  #include <signal.h>
> +#include <fcntl.h>
>  #include <sys/sysinfo.h>
>  #include <string.h>
>  #include <sys/wait.h>
> @@ -574,6 +575,100 @@ static int test_no_kmem_bypass(const char *root)
>  	return ret;
>  }
>  
> +static int allocate_random_and_wait(const char *cgroup, void *arg)
> +{
> +	size_t size = (size_t)arg;
> +	char *mem;
> +	int fd;
> +	ssize_t n;
> +
> +	mem = malloc(size);
> +	if (!mem)
> +		return -1;
> +
> +	/* Fill with random data from /dev/urandom - incompressible */
> +	fd = open("/dev/urandom", O_RDONLY);
> +	if (fd < 0) {
> +		free(mem);
> +		return -1;
> +	}
> +
> +	for (size_t i = 0; i < size; ) {
> +		n = read(fd, mem + i, size - i);
> +		if (n <= 0)
> +			break;
> +		i += n;
> +	}
> +	close(fd);
> +
> +	/* Touch all pages to ensure they're faulted in */
> +	for (size_t i = 0; i < size; i += 4096)

Nit.  I show test_zswapin() is using PAGE_SIZE.  Maybe the above code can also
use it?

> +		mem[i] = mem[i];
> +
> +	/* Keep memory alive for parent to reclaim and check stats */
> +	pause();
> +	free(mem);
> +	return 0;
> +}
> +
> +static long get_zswap_incomp(const char *cgroup)
> +{
> +	return cg_read_key_long(cgroup, "memory.stat", "zswap_incomp ");
> +}
> +
> +/*
> + * Test that incompressible pages (random data) are tracked by zswap_incomp.
> + *
> + * Since incompressible pages stored in zswap are charged at full PAGE_SIZE
> + * (no memory savings), we cannot rely on memory.max pressure to push them
> + * into zswap. Instead, we allocate random data within memory.max, then use
> + * memory.reclaim to proactively push pages into zswap while checking the stat
> + * before the child exits (zswap_incomp is a gauge that decreases on free).
> + */
> +static int test_zswap_incompressible(const char *root)
> +{
> +	int ret = KSFT_FAIL;
> +	char *test_group;
> +	long zswap_incomp;
> +	pid_t child_pid;
> +	int child_status;
> +
> +	test_group = cg_name(root, "zswap_incompressible_test");
> +	if (!test_group)
> +		goto out;
> +	if (cg_create(test_group))
> +		goto out;
> +	if (cg_write(test_group, "memory.max", "32M"))
> +		goto out;
> +
> +	child_pid = cg_run_nowait(test_group, allocate_random_and_wait,
> +				  (void *)MB(4));
> +	if (child_pid < 0)
> +		goto out;
> +
> +	/* Wait for child to finish allocating */
> +	usleep(500000);

We might be better to revisit here in future to avoid racy test results.  But
this seems good enough for now.

> +
> +	/* Proactively reclaim to push random pages into zswap */
> +	cg_write_numeric(test_group, "memory.reclaim", MB(4));
> +
> +	zswap_incomp = get_zswap_incomp(test_group);
> +	if (zswap_incomp <= 0) {
> +		ksft_print_msg("zswap_incomp not increased: %ld\n", zswap_incomp);
> +		goto out_kill;
> +	}
> +
> +	ret = KSFT_PASS;
> +
> +out_kill:
> +	kill(child_pid, SIGTERM);
> +	waitpid(child_pid, &child_status, 0);
> +out:
> +	cg_destroy(test_group);
> +	free(test_group);
> +	return ret;
> +}
> +
>  #define T(x) { x, #x }
>  struct zswap_test {
>  	int (*fn)(const char *root);
> @@ -586,6 +681,7 @@ struct zswap_test {
>  	T(test_zswap_writeback_disabled),
>  	T(test_no_kmem_bypass),
>  	T(test_no_invasive_cgroup_shrink),
> +	T(test_zswap_incompressible),
>  };
>  #undef T
>  
> -- 
> 2.43.0


Thanks,
SJ

[...]

