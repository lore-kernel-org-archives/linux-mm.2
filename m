Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 289AAC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07A16B009E; Mon, 27 Jul 2026 14:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8D06B00A2; Mon, 27 Jul 2026 14:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0396B00A4; Mon, 27 Jul 2026 14:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B859B6B009E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:39:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33ABC8017E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:39:26 +0000 (UTC)
X-FDA: 85035419532.09.B55AE47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 591A3140003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:39:24 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fdu/YlW/";
	spf=pass (imf09.hostedemail.com: domain of "SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785177564;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tGv4PNK8gfH9jjDfeT/wkQGQeLNwJxNHau6Ei8F2sk=;
	b=pXjtGxF1Td1WJfJotNkoIpgWNLbtOdmT4GXkQlIHT+rbV9OeKrSgHHrhxFlP63LO8aVI4S
	mib3YaS9zURk0mG5ZXdU01iyHOzMN8zYSyyMIw2q1w7TkjHQwNn65bC5A5GHsbtU0Lgzph
	7z59PfmNyAsAS5jh/xMR1qva3KXlgFk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785177564;
	b=yZI/zMxvdPPL2hFTD9gHGLzeBziGr9MycfMHrstP0y+M6S27U0/tWbfLelR0AxS8oHyddd
	y02oCGJkFngok6iWXAlP+WZmQfZoOJ76E91Ba/tWmRtlPBe+kJ5H8XOE93ffjgkK49B2ey
	DcIBd/G7giDDee6LK9bBPK0gnSLMRpQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Fdu/YlW/";
	spf=pass (imf09.hostedemail.com: domain of "SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=SzS6=FV=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AA094078E;
	Mon, 27 Jul 2026 18:39:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F02D41F000E9;
	Mon, 27 Jul 2026 18:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785177563;
	bh=6tGv4PNK8gfH9jjDfeT/wkQGQeLNwJxNHau6Ei8F2sk=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=Fdu/YlW/qMY4wN6+GdvexUUe12WEDiSeLzQTF4frC6TW4i43pAlw0x7Xe3vs9tL8j
	 BdJdN9g5R/W0PrKy1QDw5jLWOu7ag2EM6GuwJ+raCzQ4w7lyCXPLF9elpg8AgUcG6D
	 GdqvrF2uMvMhOGJbFlYDVfULHygkW/b54+8pTmmh+/6/jpFyprUs/3VYnL/XhHTMBz
	 et8iwjjie7mXJS5iatmqPPVC5gSxnGZBhoCpj5LRIWHnywhHnEltcqRgd8c0q7jjsv
	 6uH65kwsXk9YvBiUoiGmaKlkBotjpfq5gqSYjvzXT5+HOD/kuLpxkZNCYg9ooizkqZ
	 TTnDFLPuyhUdw==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id C662DCE08BC; Mon, 27 Jul 2026 11:39:22 -0700 (PDT)
Date: Mon, 27 Jul 2026 11:39:22 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/migrate: report RCU-tasks quiescent states in
 migrate_pages_batch()
Message-ID: <66743574-cdd9-4a4a-9278-b00cad4e2a20@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-kcompact-v1-1-bdfefddd6874@debian.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 591A3140003
X-Stat-Signature: pmjfn3nyam1t5xtdoaexyr56p1q7tgfz
X-Rspam-User: 
X-HE-Tag: 1785177564-185667
X-HE-Meta: U2FsdGVkX19AY1bfK6/oCZxlcLb00xrFI8e4X88n/zg2FhJKB25NMHeKws7ifTZpDbAdu5cVpdC883LHSAuoPOU2WFQhdZVrfNvnwtocG0pU1SL2Y5g9kUX35RZqxGj5n5wHpBiYtRAPFnUc9HaJ3U3/SWv1Q3bK6Saxm8SXj4VyiUfBBeNnurAiVkmasYZ9BZQCqENamSx3wqIuSdKITdaIxXWCLKFjWTseB+BEu866gQESrUTq1aPyd951JgbsGBnARGoL0rIa1LBsZUkpX4d4TxWqSgdg4V3eIGh3ta12uYoNsGAZ4MZQbDmHQtk73hQJhxlL77F9EqlEzA77n19ek2mwcpSac2L90aJzoOBnS7kJ6IZEYWPNmrVPmLibobxQ5BM6POVFcicKg5j0haf2RITvpb8VXQ4tTF7ejz9l+bcOau8+8qA68ta5PAiAAdWk5Nqy3Aq2hcjN/Y7ZfaLHB9cIhL0EElVfPFJVhvo0uft65QluRxUu2b93rODjxvygKxYmbAHYjG1UPpBD6IinY7BovRaig31Vqmaw/jbW2/KZoWNiUw3o0EgOzY0cfn05aqz+DlWSsOA7l4gfJq5nbCjJPY9jagg3LtMAhg4GCSOLhkyIHkNoLOaB4Zd9dAy3lv0lKO98VEz05OJbJoL145L/OCi6bGJ7M1zP317ESdD3b2Qf/L45zsbGu4Ut6Zrlv7ysJhmaDtgggibkusICwxmhO8YR6pIcpHs9AWDG4bUkXd88n+LaxzWXy1cDtnVKZztVhLtZqYxaeDHIfAhZYAZNjoOFXlxyfbo2ivPbASPP0jOfLeXCbE5YN6gjTOas3K20q4hI9Q9O6X1FtXGQnjEDlnwYG07R7vZl5Yq6F+d/R+cm09s1v88KVHqrYmF+bhAC9v5/91TmLsgK8UXMkyVgOMeQcHBi+O7cDTY5tAB8YjC+bq0Pbz/VZYcdsKhp1NGNd9KOaR3jdog
 2jZ5mPn8
 l9qgBiYeasU8mham4JSrSa/ypEaQGqqzENy9w+V/3ltmmovPobxeHa6B9bggRxskMmd9EVFVqX3MaN64jLQlYGZf0EJUCg7Iao8CUetMUue0hNowTjZSyxBQYCigd/HqTKfdx6xmCZ0UZvxUlx+lNDG92YXEgA4+b2PbDqL7EPudNWdcqP0lizftD/Ktx7Gv0pxy7vl8srfKNH3KzEtF9IEp4DnyMjczptuBXjdbRAbfkI4VAO1vqePPHtfFH23IMo9dIM6fHbmxLN7YBhh2T7d6Dwv+v8hw3ZpD93sTEWxeF5I/ieHjTNK3nenrvRbsiTGIZ0E/EHH4/xuhJuMSe+gp/FNi6zWZaOTmx1CXwVWvrtIH8AOaxvLe5F8TpFr856UUmyuRDUD/Xk36en43qwwBIh26cDrxJVMuRTp7NmrXTdl9txF1wLOeA9lJ0K+6qNxnpaBN7UnHftf6resH3KZBaYCz8pHhKhcXK/FWube8zvYg4wAcSyUWSPGNS5bTTKKAnKW72R5+Q36NvTl3eSQSpYXFHRe7QyiP800OgxnGvA5ElN/VmxJkspXzjzAUB0VswzIqmuWUJ9auQ3qx/CbPRBLHmXDOrlMwx6Io2NkEaWh5uCzXyHvEIsQBqqOQBVEqpzwLta+ZrJJHbz+Uc9sNoFrNnsAPa9gRBCTVrTuc7qM75nL2nTityHBeHEMQz/RhBNCPA15O3jMu9Zzhtcv7cxif/GxpjNCzmPwLFQssrqZB19GkQT+1JbIqY47lA4Oda7y9r5iwaYR0TBUftNxm1eMWvkr4w5pwaZz5oslxvytxM1qqS/VTmRL1nv2Hpz0xt6SPHSlmfuVhTgwb4JinGNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 06:50:19AM -0700, Breno Leitao wrote:
> migrate_pages_batch() unmaps each folio before moving it, and every
> unmap runs the mmu_notifier invalidate callbacks.  On KVM hosts
> try_to_migrate() ends up in kvm_mmu_notifier_invalidate_range_start() ->
> tdp_mmu_zap_leafs(), which is expensive, so unmapping a large batch keeps
> the CPU busy for a long time.
> 
> The loop already calls cond_resched(), but on PREEMPTION kernels that is
> a no-op, and involuntary preemption is not a Tasks-RCU quiescent state.
> 
> A long batch therefore never reports a quiescent state, and the
> migrating task (e.g. kcompactd) becomes a Tasks-RCU holdout, stalling the
> Tasks-RCU grace period for minutes, which is common at Meta fleet:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>   0000000055349ecc: .. nvcsw: 1157401/1157401 holdout: 1 idle_cpu: -1/56 task:kcompactd0      state:R  running task
>   Call Trace:
>    tdp_mmu_zap_leafs
>    tdp_mmu_next_root
>    gfn_to_pfn_cache_invalidate_start
>    kvm_mmu_notifier_invalidate_range_start
>    __mmu_notifier_invalidate_range_start
>    try_to_migrate_one
>    try_to_migrate
>    migrate_pages_batch
>    migrate_pages
>    compact_zone
>    compact_node
>    kcompactd
>    kthread
> 
> Use cond_resched_tasks_rcu_qs() so a quiescent state is reported even
> when cond_resched() does nothing.
> 
> PS: This has also been discussed at [1]
> 
> Link: https://lore.kernel.org/all/amdWVTs0WKOxguxP@gmail.com/ [1]
> Signed-off-by: Breno Leitao <leitao@debian.org>

Very good!

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  mm/migrate.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ab15a4dddd047..b937cbd764808 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1843,7 +1843,7 @@ static int migrate_pages_batch(struct list_head *from,
>  			is_thp = folio_test_pmd_mappable(folio);
>  			nr_pages = folio_nr_pages(folio);
>  
> -			cond_resched();
> +			cond_resched_tasks_rcu_qs();
>  
>  			/*
>  			 * The rare folio on the deferred split list should
> 
> ---
> base-commit: c5e32e86ca02b003f86e095d379b38148999293d
> change-id: 20260727-kcompact-ff0550fc0ebb
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 

