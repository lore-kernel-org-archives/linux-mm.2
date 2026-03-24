Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58388F532C3
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F8C6B00A2; Mon, 23 Mar 2026 20:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF64E6B00A6; Mon, 23 Mar 2026 20:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34146B00A7; Mon, 23 Mar 2026 20:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A63846B00A2
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:40:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ED7B13C40E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:40:03 +0000 (UTC)
X-FDA: 84579099486.09.241766B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C2C9C20007
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:40:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMAN5iao;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774312801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sWvLt0hGu1TRLDvVnbiSlM3TTF52CFw9udxc9qqvTQM=;
	b=uT4pTkCTVbJXdJcURNL4YdG2bFdNdPdqe9PLa/jNhI77ni1IW6nMln3NVoDg+uhA5fQG/N
	ArEGm5UF3ZN46LOLgnfz8o0KEVWybjzR9GvwLVyWQA0FTc47piKm2LhCN1QOCjcX9GsGQo
	cF+zoN0KWKLEH9kiHdeP//rd5EXoj2k=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UMAN5iao;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774312801; a=rsa-sha256;
	cv=none;
	b=Mw/VHRsBUtYXzLRnljqLXW39E8hl1evII7cNf3jwwC+ejSjvPcYXm3Rb0TKTiNEhJP62t1
	FgBEDq0R+X0RFvTqtzlLh4/4BY2l3lSpRdDA7EmTxABSCOW9zxo+Z2loZnk5r9jE4G3H7I
	eiUL7KoHfbnZ6zXJOnwr2So2bOu6tuU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2420060121;
	Tue, 24 Mar 2026 00:40:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB6AC2BCB7;
	Tue, 24 Mar 2026 00:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774312800;
	bh=vjPTBgwRkNPpj8g60XG24l6u4MKrR9E2q9j+xrBCY/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMAN5iaoN2R/H4BluGxXNkZeGXMDBR6YJkTKMNLE+NO961MjiVG2tQEldY0QSzZVn
	 3BiqXbsb3fjMJEViEEfP3uus6I53jVjQR/ymhU2zWmcH/i3j7VKaRBCMwtXbkNJXWr
	 bU6WIKeMBEoHHz2wF4ogzI28eZndPd5G95BmLHe07xgBGMik/oRSuuA6jazLtc6V7J
	 VZpv/e4s9Fx33wHsLnCLYJcz5w6kBvpL7RSVelWr0WDbrFyc0FFYY+UgI8sw8tc9kJ
	 AOMoO1GSXGa1Nea/U4xJEAFGm4a9V6HAyT08GbgzLY8uST8micXKu7GlvNiBQPzks+
	 M8BA39GykcmuQ==
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
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v1 1/1] This patch set introces a new action: DAMOS_COLLAPSE.
Date: Mon, 23 Mar 2026 17:39:51 -0700
Message-ID: <20260324003952.86819-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260323145646.4165053-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C2C9C20007
X-Stat-Signature: pprhkiqcbhebp1ppx4gc3mj936zmkuj7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774312801-35562
X-HE-Meta: U2FsdGVkX1/d8QLUNm7/MIFEwrWwlP064UGbdL4NIKEGfJtu1ciFkasuPBQ4fTXKkmWTvwUVDyuitHHR6ucCtElFD30qPWwp5LN0dbsFLsIld5u9zlI2FQ6NNOOvWPa9XatSKvZg/3+LAJktHN95LU8vRXzOB9I1duCLoH/mp29Ujkrce3D6hHcs6+3LmiLnMNoJbTQTULm69qrq4XGtAbnOztbFgFG4VDzjEjVgdgUhqsAtzGfXGYIZhRdp8+UbIlkRrZ8o0TiO2YM6WynNEwEE1KEEBCPvCvXffOFTfsTMi/JkSn9spwXnhu/TdTD2fKsPS4lblUn/GyEHemjDgfoTrQBJihzNT0vh3zH4IOdehbC0ksAFPb/HtS3i1rf+Mz2+W5oXCQ7Xu8XeTKtws1ILDvsbBYlCqlatZqdCWxQ37f61qpn8zVkTE0k0aFNEzrO+wciabIVg35bQwSdvfKOtHnmEpIjAgNJH7BE1j3mA0bPUDqWj9jcH1Kjlc3FcMeSlJCw1p1/2mCQ3PPQvZxqlR35YnUQd19vqNAO4qkcf21hiI24Cg9rD+XnXk7U6thRXiPhcuEfWN8wNHbFz86hzatYSnBS8DY2ey7acT58tGQ9v/WNC0BaRIr+zMm1Rfo6bDtVFOQYM1rv3S2zjPLNESx2aGz84/t/z0KfIQsoi6K8142vE8bOm3xFBnwNeC6VJUTjntuelnQ4vhpqlm/7FSd3/1sMPMZWHKpSvCkvQT5liyClo0hVf7ABTe3AXgRezcAldo27YDnRgwzrNUbg1Yz+1sJ720jKG+gBJx1qfrzRunqz9M+KE29b7Z1gPQA7Selj8jQ/yTGXVO7hP9HzzMXbroKhfm6i+URsXLuZ6LUfQ3B3G5GHj8EE80je/RdVeh0bpQXfBusWM/Ztfz0OHD7oOIL61qTO5nDyxkJGoaCIGu5dO0Y7u4886LNKET5ba2MkEVFHEc2vPMzT
 ht4dxi3N
 +SxMJa9Ajpl7PtasW9Gq6FWT5hsX1Kv7ugQ0tafCaM+j1EmAfQQ4bfofgcV4o61pi4KK4Da2sErl7QYuv/Go7DzoU93Ud5zASiDJaPyWkJIeXOATSCrB+druaOeFjPBmeHHmjz+/L5M7JDnxSxVc0Us8cH/fniE97vvlWC5XrOUq3cxCJhkqv6H8sxhjSTPnYXxIkn+HPcFIZkT1VWGLIrpkqo+7Sdjn309QvpM8hKxkxnJdQvaEE1eYNSi5c0KAjJekmMowT99nW0B/N8k6DpxP7csaqt1D5HkkEVcKM3/2xM3ZgaOjZe8QvIFrZsr3ygTgFGp6N0KlNTzYlGWBaeb2sEEE2ouxQlzvgGns0Fkg5QJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Mon, 23 Mar 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
> working, since it relies on hugepage_madvise to add a new slot. This
> slot should be picked up by khugepaged and eventually collapse (or
> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
> enabled, khugepaged will not be working, and therefore no collapse
> will happen.
> 
> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
> the address range synchronously.
> 
> This new action may be required to support autotuning with hugepage as
> a goal[1].
> 
> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
> 
> ---------
> Benchmarks:
> 
> T n: THP never
> T m: THP madvise
> D h: DAMON action hugepage
> D c: DAMON action collapse
> 
> +------------------+----------+----------+----------+
> |                  | T n, D h | T m, D h | T n, D c |
> +------------------+----------+----------+----------+
> | Total memory use | 2.07     | 2.09     | 2.07     |
> | Huge pages       | 0        | 1.3      | 1.25     |
> +------------------+----------+----------+----------+

Thank you for sharing the benchmark results!  But, I'm having a hard time to
understand what this really means.  Could you please further clarify the setup
of the benchmarks and interpretation of the results?

> 
> Changes
> ---------
> v1-v2:
> Added benchmarks
> Added damos_filter_type documentation for new action to fix kernel-doc

Please add Changelog on the commentary section [1].  Also, please consider
adding links to previous versions.

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  Documentation/mm/damon/design.rst      |  4 ++++
>  include/linux/damon.h                  |  2 ++
>  mm/damon/sysfs-schemes.c               |  4 ++++
>  mm/damon/vaddr.c                       |  3 +++
>  tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
>  5 files changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 838b14d22519..405142641e55 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -467,6 +467,10 @@ that supports each action are as below.
>     Supported by ``vaddr`` and ``fvaddr`` operations set. When
>     TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>     fail.
> + - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
> +   Supported by ``vaddr`` and ``fvaddr`` operations set. When
> +   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
> +   fail.
>   - ``lru_prio``: Prioritize the region on its LRU lists.
>     Supported by ``paddr`` operations set.
>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index d9a3babbafc1..6941113968ec 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -121,6 +121,7 @@ struct damon_target {
>   * @DAMOS_PAGEOUT:	Reclaim the region.
>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
> + * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
> @@ -140,6 +141,7 @@ enum damos_action {
>  	DAMOS_PAGEOUT,
>  	DAMOS_HUGEPAGE,
>  	DAMOS_NOHUGEPAGE,
> +	DAMOS_COLLAPSE,
>  	DAMOS_LRU_PRIO,
>  	DAMOS_LRU_DEPRIO,
>  	DAMOS_MIGRATE_HOT,
> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> index 5186966dafb3..aa08a8f885fb 100644
> --- a/mm/damon/sysfs-schemes.c
> +++ b/mm/damon/sysfs-schemes.c
> @@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
>  		.action = DAMOS_NOHUGEPAGE,
>  		.name = "nohugepage",
>  	},
> +	{
> +		.action = DAMOS_COLLAPSE,
> +		.name = "collapse",
> +	},
>  	{
>  		.action = DAMOS_LRU_PRIO,
>  		.name = "lru_prio",
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index b069dbc7e3d2..dd5f2d7027ac 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>  	case DAMOS_NOHUGEPAGE:
>  		madv_action = MADV_NOHUGEPAGE;
>  		break;
> +	case DAMOS_COLLAPSE:
> +		madv_action = MADV_COLLAPSE;
> +		break;
>  	case DAMOS_MIGRATE_HOT:
>  	case DAMOS_MIGRATE_COLD:
>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> index 3aa5c91548a5..c6476e63f4fb 100755
> --- a/tools/testing/selftests/damon/sysfs.py
> +++ b/tools/testing/selftests/damon/sysfs.py
> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
>              'pageout': 2,
>              'hugepage': 3,
>              'nohugeapge': 4,
> -            'lru_prio': 5,
> -            'lru_deprio': 6,
> -            'migrate_hot': 7,
> -            'migrate_cold': 8,
> -            'stat': 9,
> +            'collapse': 5

Comman is missed?

> +            'lru_prio': 6,
> +            'lru_deprio': 7,
> +            'migrate_hot': 8,
> +            'migrate_cold': 9,
> +            'stat': 10,
>              }
>      assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
>      assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
> -- 
> 2.43.0

Other than the selftest part, code looks good.  Please consider dropping RFC
tag from the next spin.  Clarifying more details about the test would be
helpful, though.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

