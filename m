Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58B03CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5F758E0013; Tue, 19 Aug 2025 02:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37888E0006; Tue, 19 Aug 2025 02:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4D998E0013; Tue, 19 Aug 2025 02:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3DFE8E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:26:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 62BCFC029B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:19 +0000 (UTC)
X-FDA: 83792522478.18.3177F92
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf20.hostedemail.com (Postfix) with ESMTP id B918A1C0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:26:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJNMRDKj;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWGqKczX6nqpvnjx9BbzIUjm7AHsAuAiynKXkFFZHoQ=;
	b=takGQz7kd2IL9145yPHTCGQSoQzW/wqJ9zmz2w77Vv2Z3X2QDdXGFuyPwXlNzQK9+o6XqY
	QEQge2AznA1oN1+lLFnCiV63c+9YXmpK3zymPpHmBfKhCEJwNy99jshgH2ey2xyqo+iZfE
	UAxyD9+NhOhUkQuQRscX4GJ2ft8vnko=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oJNMRDKj;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584777; a=rsa-sha256;
	cv=none;
	b=d7OgteztBXMME0IxPul8ArTPzwXb1KUwaf4jjWCWE7HPfwxNY9OZNfH3lGN48XXW9Yamp5
	ohqfM32pJBaAu4dSlDEbip7P4yfbN8qvG1VhxQM8LrAI7kUKhdZ0KilD0SPIz28kl2yMdz
	W3fhQX5YAiOWEi6h1RVJU57FIsKJ8cs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A218C5C5A2A;
	Tue, 19 Aug 2025 06:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DBFC113CF;
	Tue, 19 Aug 2025 06:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584776;
	bh=cobszW34dvhWuWQ5UgCda75bpk87ATDQHb9EveDVexo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJNMRDKjqIPcBLA4OJc9bVjpJvDuF+hYI4GdaqqyG/t/HDJSwR/kqY4RMJlW/v4Xv
	 UzceS7s2HWXan00E7JtVqPDOLgzr4ewOrSzYfuN7w3TAQGiSUpUzs38mW9jRRZ6iiX
	 9gC9dCT+O2gjrH+g8zyT9RBoDFJOnPxUqBInvA/2pmsCWnuNxoDbE3egdyY6lIhnjo
	 eSOIkHCRewbbBCd53T2Op5MWKi/XKgDBRO+hDRv1b9QKAAdZnOdf2RXupUHzXcBDZm
	 X0hT7nmATPI67fwQaupufQSbKAPv5Un0ujdOl0KBd6XUIcV8Hn7Y7t1ZxBSmukYxsY
	 NOCeDW/3F6p9A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 03/16] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Mon, 18 Aug 2025 23:26:13 -0700
Message-Id: <20250819062613.39988-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250819061826.39289-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B918A1C0005
X-Stat-Signature: h4hdi1rfm7kgt4x85xttzwjtbng3wz78
X-Rspam-User: 
X-HE-Tag: 1755584777-314988
X-HE-Meta: U2FsdGVkX1/BZnc0SwdNV79sVNWbFU6vUgvHLE3GJ8bgUHmLGo1n4/M+jj6o5UdsMT8jk31g4FZH8V20sXnvO0+M9KglEniwaJrahpx6O2WGF1bO8cjhmINu6noAJOpZUKQ++MkCaTb5G0Zq6dTH00+3MfuF53iDL/0XuhNRltXW9maAQp3HWzMGnUiuk5qItCCZ87++ORJzyils1xAxnTooGrYrT9unlVMIB8wNfJW68+jDUwxyVmjDBF/xDaNiP4yC3H/O3c8gQML5WV2+bbaq6NCdfp2OKeyL9IqGRbpp24oBocnGh0wkBALdQdUrCQjCdbcOaxZ6ngzu6p/rgsAz0IOk8V3UZCenyagfy1pB0Qx6v0EYXtMcrM+RqR6rszuYEy7fKcdAIXmRYUNCoCU7JevuS2zS11snhbB2WghrikCOfh6zTxI8U/hMvJmrVhWykIH5guWtMewP+tBjf1JJPqGp8CoY6JwmAg5vD5XcwJRebubgd5z0FwhnTXxh7KRfWErW04C5eUeI/Lw1GfBXkqKcvX2oksVyA9tawhxhep3h3gTYUnvsyxFfeJSOBVDiK643eM3etg1SAjKqAE7VxxMV6A1ghVpa6mrtk/yCG2q7gOWTKaNiJ+oBjYNnGwl+jc32yAiQFhD9QJaXG7eU8uQ0T+5Q5FI7KVTF+yIXIlRk/MxY72I+kiQYy8NOimbBDPKSPvW7pdFN1CCoRBqhKGzyifB+DOJ+1g80sSup1slgs2DsXKSwe5v8SxyXh7A6jvrkhTE82cpln/jG2SBnm91fai7cJPfvusP7cphis4tWtDlOy0Wf7F6rMaXQpYDVrTb7XEltWxV+8ZUnIYXTCg6pPwGAAj6vEoBqTbUa3wURVHD5YtEw9K9ZbqEAg9OH9gv88mq2pUgfzJS36yTbx7BXBD5wNs2C6hDHvyGGY88hWm28gbfVbKT7tKJkQrJlH9JqW1acpbmX42k
 JotgmeXW
 Nt0vcMpdky96CbJQZOtd8BqciDjXlgmAhSvcwQ32YS3QIKJhYTz4h4McRDAP1de+ve4rmsI6j2SRkvf7gPl42NRUM5uiS2TDjcf4US00dW4458inRYvUaKRmj2Ks8sxq5r9/jag+9As7XOkulz7ZSrJCQxqA2Mc/cciELS/e2dUp/D1rcQm+4J2LjM5TD7yHvsS9qO0bA1ou4q2XFrLevyXIMW+1FaklEDukeuvzZb2zGiqadZ4XKlaTlnwklM8TzDYYARr5YdOgUBz8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 23:18:26 -0700 SeongJae Park <sj@kernel.org> wrote:

> Hi Quanmin,
> 
> 
> 
> On Wed, 13 Aug 2025 13:06:53 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> 
> > From: SeongJae Park <sj@kernel.org>
> > 
> > Add support of addr_unit for DAMOS_PAGEOUT action handling from the
> > DAMOS operation implementation for the physical address space.
> 
> As I suggested on another reply[1], please squash attaching patch to this one
> when you post next version of this series.
> 
> [1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

Sorry for the above wrong link.  Plese use
https://lore.kernel.org/20250813170806.6251-1-sj@kernel.org instead.

> 
> [...]
> 
> 
> Thanks,
> SJ
> 
> ==== Attachment 0 (0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch) ====
> >From 525b3d1d9dd53f4ca6b4d2254e5cc7f99c8eae0d Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Wed, 13 Aug 2025 21:24:35 -0700
> Subject: [PATCH] mm/damon/paddr: set DAMOS_PAGEOUT stat in core address unit
> 
> Operations layer should set DAMOS stat in core layer address unit, but
> paddr is returning that for PAGEOUT in paddr address unit.  Fix it.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/paddr.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 98cb6930c183..826c2064dbfd 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -139,8 +139,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  		unsigned long addr_unit, struct damos *s,
>  		unsigned long *sz_filter_passed)
>  {
> -	phys_addr_t addr;
> -	unsigned long applied;
> +	phys_addr_t addr, applied;
>  	LIST_HEAD(folio_list);
>  	bool install_young_filter = true;
>  	struct damos_filter *filter;
> @@ -172,7 +171,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  		if (damos_pa_filter_out(s, folio))
>  			goto put_folio;
>  		else
> -			*sz_filter_passed += folio_size(folio);
> +			*sz_filter_passed += folio_size(folio) / addr_unit;
>  
>  		folio_clear_referenced(folio);
>  		folio_test_clear_young(folio);
> @@ -191,7 +190,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
>  	applied = reclaim_pages(&folio_list);
>  	cond_resched();
>  	s->last_applied = folio;
> -	return applied * PAGE_SIZE;
> +	return applied * PAGE_SIZE / addr_unit;
>  }
>  
>  static inline unsigned long damon_pa_mark_accessed_or_deactivate(
> -- 
> 2.39.5
> 
> 

