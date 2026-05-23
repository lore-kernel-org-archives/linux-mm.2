Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44681CD5BB8
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19D3B6B0092; Sat, 23 May 2026 13:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14E726B0095; Sat, 23 May 2026 13:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0639C6B0096; Sat, 23 May 2026 13:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E32066B0092
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:17:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4C7B9120B54
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:17:22 +0000 (UTC)
X-FDA: 84799340724.08.A926947
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9592A40006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:17:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQmb0Gmx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779556640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OXIP3uevryXlgmeqtC306B6tRAZiG3v9yrRQuwLGRPw=;
	b=lxpNLZSX4Hmt8jJ7gRzLFUhTiiNBA15SgDvBVcpt/TZaL6GDbIZ6ocWr0/ijxtTRRM25lv
	dAEAXyUd6jZYHu/tqWf3XyKyBYBPVHYQMOadrg9F+0M5ZYpsfyTCEx5FksdSIfQBE6CQQi
	ivnKvN4Lc33oJ+qS2NjGzIxY38lKLys=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZQmb0Gmx;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779556640; a=rsa-sha256;
	cv=none;
	b=4iaQUN/pUmswPgPMk6mJsC3aXFkCoJJRR9UFSduT4YVwn7iXA3htSUKOjTj1YT7OCyN0wr
	G8AejPfjaXVtytmtXOEecl5zXe9IT1dpE460r/Tkw6wRzxawOVS4txC3OhY3HWgV6cvgQo
	5xUS6DOxv2P4xxsDoNCUvPMURocAwE4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6980142DF7;
	Sat, 23 May 2026 17:17:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1971F000E9;
	Sat, 23 May 2026 17:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779556639;
	bh=OXIP3uevryXlgmeqtC306B6tRAZiG3v9yrRQuwLGRPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZQmb0Gmxnfh5Ma1pZDTnnBiQZia86MlVzRVFyjwlqmdy+NpBiXz8F+9cYNI+PUHjz
	 ydDHlJcJ969gaivVO7pn44LYI3chi238Wl7UJlmYY4U5AII/+7ljjp9OZakDT4NfWU
	 hhyfhx30yen89U8doweD7NI2xc5BOQCpbnQzkg0VAT9r/csBO+Fkmghs86vAQiaqlI
	 ioPyUhcYs06N++M4pvrIrCdBF0vscGw67JvFIH/xf0Fe6+xl2DhuWuRUZ1+Kr+NRT8
	 1OP2UIbK1cFrVM/+uWV+8oTNz9dey3pvCpfpA3IbNMwYRe4dFS4umcmHzwz+CAZxSv
	 Ieos+MWTHJmLw==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Sat, 23 May 2026 10:17:10 -0700
Message-ID: <20260523171710.88918-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522145518.158910-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pbrrn1u9zckmnyt6kknhxkp4zyep8rxf
X-Rspamd-Queue-Id: 9592A40006
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779556640-787049
X-HE-Meta: U2FsdGVkX19E9d49/k4ZnaP2xaAODkKLwd9EPllEYUPYS1R+4QLdCyngxOZoFHB5CQcs0ARa0oVVgp7l5gaHmUkbwyQOYsFJIvC6UmVGd72s2S3N1aBd0Gr3whWslqd7XBW8DpFq7cyPt6GaM1BrmijiytKulhl9HRjlSIYeRbZQ750EOHf3OdnPGe8PaYytWa/K/sLpHxnhs5xYGdCdLpb8Y1y6G9Lsbio2ougRM2f8O6bgpE56IxOYZ8QVzCkUlWIbafIjXeF2/I/8aNwtAsPrSf6378oCOBJP+0DiTH9fK2GmshU/+OraSZA33QlywqfMrP07M7Bxbmxd8jLQ/ir2gQIhSh05I8bkOARNqqci9lFciHNlmBAET+AmtqR32V0xEyUOkkjXiU05AJq1aWUTAGMxyL1/L5FhAfKqKVVGpYOYODsKxFrPplWIDufKij0Jb04OeCBWkFrnz86WSknJS5eB5Fj1yRV1jGzzxpPWT0QHVRuTb/wyQX8P+2iLYB2FFNOeTX8IXQkxSpMocy9UfQ6RJFfCo6Wvg4ud2m+X1xl37Pcjs+CPHELic1sQp8NUWVcHFrNiyg++MoscL+P6Amn8L8C7mFIV5Bbv9j7mzG4lQ/0lYz7wMYGixI/3WZSiQNAO3rTdh4XoJTddeYvNjNF24pAUrNO6QjPRwWNCv9EVjiik79PteOiYulfIm5gogBMZrg4zZVDb1BIceH9FCRGqSrBDfr2XRQ2buZUB2XuxeMqGZRm6fghSrgD/StRXUt6l82t4sGcU74Zw8KVx1WEF2XLSS0zTRwNmProGH31wgJFsf4VM0nKgMhWx2Uu0bbnmCVge6PgEXYRjIOXGzjoOsQ1rKbXliNd+whXVzfg+AuyuusfUJNNNG1I6FtYG7Ayn2S3/sfnjuKqhl2FyOT5U8CaJ+wW5R4uHDwUZ4JTh5C52iI53LSEs4Rf5HgpwnWm3ed/b0l8m0Qi
 B6acLOxP
 8NpweGg+2/gJFXohtx+BAqTEEGzk7mVg9G7bLvSiAmq6ChdyJSmobhya2OyWsVDP5ArE1oDBSV4h4zwuUg3CpRKREOXtXlR2PjfruTgxbpIPIOurC1GVZQNU87xayjbLN5cqrgWxpHSgdKIV8Flh/2QZGb1llC64DJHmjC0TQSd07JfFbsRL+cL+cf9uXQj1C36ECKLIFFIBPP58rYVBpkdAceriCY3hydI/Jz1646V8XuQ47nDUkuqTwNviPh5kYjcySAsrgc7bJHJYeYXH0Mtt/nIe28loR4dXl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 14:55:14 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ========
> 
> This patch set introduces a new autotuning which allows to collapse
> hot regions into hugepages.
[...]
> Solution
> ========
> 
> DAMON has now a way to autotune some of the variables and adjust quotas
> automatically, so that DAMON is fired only under the right circumstances.
> It would be nice to have something similar, but for huge pages.

Agree.

> 
> A new autotuning quota goal[2], damos_get_used_hugepage_mem_bp,

Is the name correct?  I think 'get_used_' may better to be dropped.

> is
> introduced, which checks the huge page consumption to total anonymous
> memory consumption. This new quota mechanism reuses current autotuning
> architecture.
> 
> A new module is introduced to demonstrate the use of huge pages
> collapse autotuning. The goal is to collapse hot regions of a given
> process into huge pages. The module launches a kdamond thread for a 
> certain task provided by the user through monitored_pid module argument.
> Hugepage goal autotuning will automatically adjust the aggressiveness
> of hot region collapses.

Having a module for the demonstration purpose sounds good.  But, for the
demonstration purpose, as I previousoly commented, making it as a sample module
(put under /samples/damon/) or just drop when you drop RFC tag would be better.

Let me know if this module is aimed to be as is even after you drop RFC tag.

> 
> This module also has a user autotuning knob which allows the user to
> adjust the aggressiveness of page collapsing.
> 
> Benchmarks
> ==========
> 
> Huge page collapse autotuning was tested in a physicial machine with
> MariaDB 10.5.29 and sysbench as the benchmark framework.
> 
> The hugepage module was set up in the following way:
> 
> # echo 1000 > min_age
> # echo 1000 > quota_percentage_hugepage
> # echo $(pidof mariadbd) > monitored_pid
> # echo on > enabled
> 
> The goal was to achieve 10% of the total memory used as hugepage.
> 
> The table below shows the memory consumption over time. Gaps in the
> timestamp means that no changes in the hugepage consumption happened
> over that period of time.
> 
> +-----------+----------------+---------------+----------------------+
> | timestamp | anon_memory_mb | huge_pages_mb | percentage hugepage  |
> +-----------+----------------+---------------+----------------------+
> | 0         | 2159.761719    | 0             | 0%                   |
> | 28        | 2177.574219    | 4             | 0%                   |
[...]
> | 283       | 2224.601563    | 434           | 20%                  |
> | 284       | 2224.632813    | 450           | 20%                  |
> +-----------+----------------+---------------+----------------------+

Thank you for sharing the test.  What about the performance?  Could you also do
comparison of the numbers against the module disabled case, and THP disabled
case?

> 
> Eventually, the amount of huge pages reached 20%. This is consistent
> with how quota goals autotuning work. We are more aggresive when the
> quota is less than 10%, and less aggresive when the quota is higher.
> At some point, the aggressiveness just fades and no more collapses
> occur.

You are correct.  If the behavior disturbs your test, please note that we
introduced 'temporal' quota tuner [1] to make it easier.  It is merged into
7.1-rc1.

> 
> TODO
> ====
> - Support page splitting for cold hugepages.

Sounds good!  By using two DAMOS schemes that doing collapsing and splitting, I
think we can make more complete access-aware THP system.

> 
> Patches Sequence
> ================
> Patch 1 -> damon_modules_new_vaddr_ctx_target
> Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
>            and the new VADDR ctx creation
> Patch 4 -> Documentation

Patch 1 is only for Patch 3, right?  Let's put it just before patch 3.

[1] https://lkml.kernel.org/r/20260310010529.91162-2-sj@kernel.org


Thanks,
SJ

[...]

