Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22472FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D93A6B0088; Thu, 30 Apr 2026 20:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463456B008A; Thu, 30 Apr 2026 20:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32AC76B008C; Thu, 30 Apr 2026 20:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1FBFC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:41:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A629D1C0DFE
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:41:54 +0000 (UTC)
X-FDA: 84716998548.22.8716A9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id DABCE80005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:41:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NB3hWGTV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777596113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SW+3Fb119GHY2oeYdcVjxAiI6gsACUjB5MCjVtE/yYg=;
	b=gBtCDl4kXpBkyu5nQ63r+awkMoxIEa6UNflh7+E2FZVpqUm+LmKlkprIJ1mESCJp4NU5Xr
	bd94LfzuaDkqFZp2dITlWHqgcF9YlmtYyM9ySmilZVizQf+Q42d0CUPe3vuGOXPatnw1ah
	482PN6pbPSB8chUq7+dAihsEb/VH8a8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NB3hWGTV;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777596113; a=rsa-sha256;
	cv=none;
	b=1+TmZG5b9RQrafKpW53XfEjk/j935ubA0G5nq7FQGsNDp4TMQWRJYkchvRwMXNz3Zdr654
	MB+djwNfTHuTo6GcZ3pklcNZY2CaJC/SWL/zyGEV4QIWIOxkibDXdqnOgDARy9KiLxDx3A
	Nj39nmNFZ/ZedD4EBLkUwCs2jqgE0tQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D70CF440D5;
	Fri,  1 May 2026 00:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51811C2BCB3;
	Fri,  1 May 2026 00:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596111;
	bh=gn0A/IMKl276FIB3LENO7HJggCV5JRxz4pjAVumVjKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NB3hWGTVp+q+Ls8LF2zgKA0MlM4bGXU7nMaJM6O3ArU64jgTi1jiHz3GZ5E7Jn64D
	 dkYqhYipn/xBf3qVqdHzaTRs4iAlIqHlAAK775YR+PGqA7RYqknYzQYh13xCYf9XuL
	 fct6AWzEVT6U/bxWE4v0LkAG9CCQuCYzkl9r0zU0qutKc6MY/zU1QUWUG+wo6h0CTr
	 tfch0E8+oV5M3zSiFIGAgsrwti6fed0LIz1eAba3TudNKgIVB4PNxajerSZbx5NtLq
	 LTaI0WV1IfrDqKLTD4PzocZT0x7si2hdcYU0edRP7Cs95m73NnoOlpHE6N8f1RixPB
	 DGZzGKacK26Sw==
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
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Thu, 30 Apr 2026 17:41:47 -0700
Message-ID: <20260501004148.78873-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430134139.2446417-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DABCE80005
X-Stat-Signature: twfawy46n5t7mhceh9cgtc3rfjpfpjn3
X-HE-Tag: 1777596112-124986
X-HE-Meta: U2FsdGVkX18vCW6kvQvZPcoXqoIJX25ZsiT/UG+hSpqnta+ElDsuRFFVzJL0pDvpRHgvjiKruHeoyuU+cbH6MmMx/3z6o64MOT019d2zJdScO3l8nm9/axBvWNthgaJ9Lm3lmi6geBaOu3V5GT+/3TmSdEEhR18oD79aG67qiYCpnPDhR+tskiwgunLiOUciSZxtbgxuZEOKn9ZmalWNwcrdeOyn+V9o5ASo9PPuC4Nen29uQJzKRGUrp/4T5RYkZNMvDKEWge1ZsoTKImscxxCzcq74DR6FJxZUHyIo4wjR/dz3PIrHTlQsUUZ//jpzzMxtmRJEEimf5IYkXy/JM3N/hmiFk3TF5uz5wR4LG++qC7Dww2SWtC2rBBCsGc+bY5Pn+eKi9JjKt4JkVT/CQvus7DPAgtNL5xe1n7lvGBJMFvsdhh75GmfE+n42auKZe6QYbr1Iuz0No4IZBAtzYwxkKTjnTOEMFYNG++3/DRGyD7r7qetiYrgBnMYMbddBBqnE+7D5yQR0eTGYiyGbv8Rl4Ut+yOqgl3shChMleXI/E7Xuk/8nywPqw98lVVtvx63EqpgK+2N9gWTN3kHLwZS79YnSI9TYipG+qPAXCpwYDIKbRfVbjV0+/OsUY+0bIE59sy9T+rBlG34/mWt0ye38mlZDs7tnmu6YnNmQidZ4di290FWLtQzqEoC/Fwfr/nU2rvQ6JSQxnNjfqvWLI6z3VIMA5dydN4zid5978kWiXM4KtjPhHQv58lVrL0XImwkXxU/2iCQmm+UNpnZbRTIZDUZUEvmQ1JPoUsfm0ryKz6WmbAIivYOUW7mIa4k2xeiEeKOSawduPE79WlFmb2ga6O0HFrTbiQSLZ0zP45mA7bVx3pcRK8MrCOgDVxOGNttFEcpUCZXC7cbLmyB3gPYeia/9E51jfQYkIaMvTwKlSBBi7x+qMwueOfnvxxvHuhbWM3p05x6MJiyTx+8
 FBy54it2
 TLVk+BwWY8l0GFOX80vPiaRos5zTltddsJqqmRfPPJ/aPvZemUBkRzdaIC9FlA/nEp42U3gWeEC2cddxvqGaI82jk2hBB4dSscTEma3MNhyJHKoePmre2W+Lk+EGGDmjK8xwsA6O37N3ENSVkeVTJ+7HFy0A5aDwSGXq7cCMycQNWwNCBD229w0T/17cVdJ3md/heeDoBiQDs7ba8aPfoxAbmG+cvROUW0RY3gN3MhLxBIEQo7cwTMHoo1GeqJzEBcfyoiLaZdWhWL6cDTFmS63XyMLqEkEdE12yt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Asier,

On Thu, 30 Apr 2026 13:41:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Overview
> ================

Let's align the length of underline with the text.

> 
> This patch set introduces a new autotuning which allows to collapse
> hot regions into hugepages.
> 
> Motivation
> ================
> 
> Since TLB is a bottleneck for many systems, a way to optimize TLB
> misses (or hits) is to use huge pages. Unfortunately, using "always"
> in THP leads to memory fragmentation and memory waste. For this reason,
> most application guides and system administrators suggest to disable THP.

I think the motivation should further explain why existing DAMOS features
(access pattern-based targetting and quota auto-tuning with existing quota
goals) are insufficient.  If that makes the text too long, I think the
explanation for well-known THP benefit and problems can be reduced or skipped.

> 
> Solution
> ================
> 
> A new autotuning quota goal[1], damos_get_used_hugepage_mem_bp, is
> introduced, which checks the huge page consumption to total anonymous
> memory consumption. This new quota mechanism reuses current autotuning
> architecture.

The idea makes sense to me.

The name sounds bit redundant, though.  How about DAMOS_QUOTA_HUGEPAGE_BP for
the enum, and hugeapge_bp for sysfs input?

> 
> A new module is introduced to demonstrate the use of huge pages
> collapse autotuning. The module launches a kdamond thread for a 
> certain task provided by the user through monitored_pid module argument.

If it is only for demonstration, I think it is more fit to be a sample module
(placed under samples/damon/).

> 
> This module also has a user autotuning knob which allows the user to
> adjust the aggressiveness of page collapsing.
> 
> Benchmarks
> ================
> In progress, will add them in the next RFC series.

Looking forward to!

I may request not that much test results for the quota goal.  If the module is
not just a sample but for a real world use case, I may hope somewhat reasonable
test resulsts.

> 
> TODO
> ================
> 
> - Since DAMOS_COLLAPSE is not in upstream and this is just a
>   RFC, I have used DAMOS_HUGEPAGE instead. This will change
>   to DAMOS_COLLAPSE in future series.

It is now in mm-new and it is recommended to use it as a baseline for DAMON
patches.  So please feel free to use DAMOS_COLLAPSE from the next version,
unless there is a reason to worry if DAMOS_COLLAPSE will be dropped from
mm-new.

> 
> Patches Sequence
> ================
> Patch 1 -> damon_modules_new_vaddr_ctx_target
> Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
>            and the new VADDR ctx creation
> Patch 4 -> Documentation
> 
> [1] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com

Adding more context about what this link is would be nice.  I can find the link
marker from the above text, but I was unable to expect what this is without
opening the link.


Thanks,
SJ

[...]

