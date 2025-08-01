Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FAEC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 23:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7ABB26B008C; Fri,  1 Aug 2025 19:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7836A6B0092; Fri,  1 Aug 2025 19:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6995A6B0093; Fri,  1 Aug 2025 19:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BA9C6B008C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:30:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2AD79134104
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:30:49 +0000 (UTC)
X-FDA: 83729785818.13.E4B0E38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id A1ACCC0010
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 23:30:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhT12GCY;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754091047; a=rsa-sha256;
	cv=none;
	b=M9QP8w/c9Ae2+LM/JXktYoPhFiEukAokMEK4nfYRpD/R4v80ZrUyyZMX/24uDJLph4wvHW
	RuvVfjs8dmmbC3No6m53SRESkSRLCwOaTVfrU6CSWFvcQkH/ORay5AYNkmJjuuU6qLr3Fm
	sBPp8p6U+dOgs8zUdy77vQQFyE3lPFE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RhT12GCY;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754091047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=snoEGBjilpPo5MQRqlwWJb4KTVTcEVFOvS5Y+q7YA4I=;
	b=p5MWO16CZpXIBCTXNy8L80RHbq/usoaMyaUjLBCVcKY5tRVlaYA3TmJxAJ80i64DtxX5hR
	8AnI4plAn90pICJhKPaIOwNyG5tkesGaN50VOH0BwPPZKckc4jI3Gkw25oy+1h+vPxW5a/
	zr6HyCKRqs3/oIKBioQnG/BROo5Z+QA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E211D6112D;
	Fri,  1 Aug 2025 23:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EF6C4CEE7;
	Fri,  1 Aug 2025 23:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754091046;
	bh=ctwKht944Ty5r59IlMbVaQb5+XsFWdWm6fDxZsJiL7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhT12GCYqCttbObWM0kp9mAskV2wLU/cel7pO99XFGSosrg1ezGm1oQhnHIt5rVe0
	 g9E9S4MljV1cYdcivwH0PAW26cDaFYkmxWNaBJ+Yz6RgAOhVfDWq1d29LAW3zZR9rq
	 ZeJLpGy5laJ5wNupnSPF9/Y9NuuKevDafKTeQWBN15P8FoHjzAVjXW/Z6MGcrnM/DA
	 FeMpaOMp85lvPHnef2IeuXMuvTKlzt5ZFe3MQUF5Wb4M5I94SsW2U4ZIxpjsld0rE6
	 RU4S6QaiWPxNFW1tzTMEhZs1iSNpFJdi1Y2Ri8jWgPWHpoYOZRZYKtk5DHT3uUUZD4
	 pRTFDNtF6GJJw==
From: SeongJae Park <sj@kernel.org>
To: pyyjason@gmail.com
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] mm/damon: Move has filter to ops-common
Date: Fri,  1 Aug 2025 16:30:44 -0700
Message-Id: <20250801233044.1392-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <a290e7913a1c39f605b8cceafd86d41c2dbebf82.1754088635.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A1ACCC0010
X-Stat-Signature: f465sewnm5j6hww7e6ebkqjicfsx6r6t
X-HE-Tag: 1754091047-184337
X-HE-Meta: U2FsdGVkX1/5HxTu4gvjVZpluV43SQnOSFt4FOoLc3dHK8Aa/0Xkysy8iG4B0EN6bylDXJf65O4y/9AAJce4ArMMVtDI7+Y/cJiDbH0DBE29CuwXyUa70JlDC3w/+7CvzROL8u6McYWm382zZ1d6aOT1upc+CNajuI9+GbzUxf9So8iBITetaGeWRzywXPbh0PHPh7s7JA3t8v5aiwRZwQwqju3HTE4B94pMzIofelWTNW2c7RpP2SPQTgB435b65ME87g9jMFFawlocm1l2DUN7cI0og26uWXyna+sU2ef6sDfMgTED0dWXJ0SK1y8+A1TFnH1nXSM2T6LXrZ79h8vA3JqShOd0/a4mgxFQQJ54YCx10teI3XywxMzg96jCUAkJHCu3jseW2z3BegdWrT/86iiuILiVAxpnwlfAKugbs0IV9rxTKWVqH0O3O0hBDRFVhXZWPJRPiTHG+HfL44YLnEmS3BwU80TQK+3N3q3mN3Hv/29Y5SM3gKb+/kowpGfhNwaBXhgzh/t1MXVV4au7YpXbP5og6Ms2EiW3GJWDwkG0Keke2bQs/p1lcXSBW2z4p3GfipR5MRN2g+bGZHA86BVpMmruSza+37ZvR1Kh4QpbFSfAYQwkinLnZ4USw9YISWWQzeI6N7A/VjDDWn0jaOVuc4ShTiYYzFAFWeVkGk+wKRA5I6gt0ZCOIAu2BytD9gR8Dhgi3cxS+5C1dicWCerd1YOaZxCXnZeI9Yn4Ku497I9G2yTAa7qzE9vzPYwGjBAcpmtbJWWWoIrHhfqw1OKka6vVtOB0niJvx+vz+qKLczWqx0ceZM43xt+cVOhczJPNLA2DjNlUPkKukHPb+pAfUs75hcPmSuog8J3kLfqhHhICQBPae3FV/s6MPAx+XprfLVP30t2YpHdrQSjV0LiEYM//AzZZiXNe2LFe4fPAMHV9rh+a8QCMefO8+Syga3q/Btp1z9+ABr4
 Gcfsrx04
 z9vPQclPfDyHT2bXEntF4KIl9cnxkMN/AUR6YDWjsqF1YltGJ64k5fsqlU2+KPVlMsKn01M3zLUM6lQ999ucLDf5icJ0Lsa3KrvVLqI2klOkogMwM4zRVfJP4WMyc9df0TboPtGfubSpftNzU2dXTMW3raz6DoTeNSCv+YI9JBh20Gyq7nt9n2uTBZ1eUJpvuJRFC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  1 Aug 2025 22:59:50 +0000 pyyjason@gmail.com wrote:

> From: Yueyang Pan <pyyjason@gmail.com>
> 
> This patch moves damon_pa_scheme_has_filter to ops-common. renaming
> to damon_ops_has_filter.
> Doing so allows us to reuse its logic in the vaddr version
> of DAMOS_STAT

Let's update the subject to better reflect the change, e.g.,

    mm/damon/paddr: move filters existence check function to ops-common

> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/damon/ops-common.c |  9 +++++++++
>  mm/damon/ops-common.h |  2 ++
>  mm/damon/paddr.c      | 11 +----------
>  3 files changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index 99321ff5cb92..de5404477242 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -412,3 +412,12 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
>  
>  	return nr_migrated;
>  }
> +
> +bool damon_ops_has_filter(struct damos *s)

Thank you for renaming this following my suggestion!  My suggestion was
damos_ops_has_filter(), though?

> +{
> +	struct damos_filter *f;
> +
> +	damos_for_each_ops_filter(f, s)
> +		return true;
> +	return false;
> +}
> diff --git a/mm/damon/ops-common.h b/mm/damon/ops-common.h
> index 61ad54aaf256..d3d36bca90b9 100644
> --- a/mm/damon/ops-common.h
> +++ b/mm/damon/ops-common.h
> @@ -21,3 +21,5 @@ int damon_hot_score(struct damon_ctx *c, struct damon_region *r,
>  
>  bool damos_folio_filter_match(struct damos_filter *filter, struct folio *folio);
>  unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid);
> +
> +bool damon_ops_has_filter(struct damos *s);
> diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
> index 53a55c5114fb..9d9cdcc10b8e 100644
> --- a/mm/damon/paddr.c
> +++ b/mm/damon/paddr.c
> @@ -262,22 +262,13 @@ static unsigned long damon_pa_migrate(struct damon_region *r, struct damos *s,
>  	return applied * PAGE_SIZE;
>  }
>  
> -static bool damon_pa_scheme_has_filter(struct damos *s)
> -{
> -	struct damos_filter *f;
> -
> -	damos_for_each_ops_filter(f, s)
> -		return true;
> -	return false;
> -}
> -
>  static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
>  		unsigned long *sz_filter_passed)
>  {
>  	unsigned long addr;
>  	struct folio *folio;
>  
> -	if (!damon_pa_scheme_has_filter(s))
> +	if (!damon_ops_has_filter(s))
>  		return 0;
>  
>  	addr = r->ar.start;
> -- 
> 2.43.0

Looks good otherwise.


Thanks,
SJ

