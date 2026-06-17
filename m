Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01F7CD98E6
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 03:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801FB6B00A9; Tue, 16 Jun 2026 23:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8D36B00AA; Tue, 16 Jun 2026 23:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDD66B00AB; Tue, 16 Jun 2026 23:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3662C6B00A9
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 23:31:15 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 974DC165BD3
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:31:14 +0000 (UTC)
X-FDA: 84887978868.22.DB7D61C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D648918000A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:31:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFSc5IUu;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781667073;
	b=ese3dBh+VTG4KQB39pYiwOTLbXSTr+vpptIkjxILviMEimvEV6W96p9bwspdTtY2auCg0k
	a1dgHHt2DfnWfIFXiZKdG0PBFMA1ccUkv1I6Nx6CFHkuKXiLINQj46ktHQqFFAewrXAuwr
	5d9S5PU6kniIqkAzswj6Vv+rtQFOVxc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFSc5IUu;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781667073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRk5REZ1sq8yz/FEd2MRrPo8/o6v1rgYxnNAIv2TPNA=;
	b=aqk/IJ1q9+FipG3cydd4dEy5Xcm51ZVQl+/mqDdWwyxHVExEoqIaSzj0PFhKBCNTZwQtsz
	Gi1ynqD3sRu5CHmmKEtv278Iew9WEESJwbmB4faRo9spW8HPyEanYnTK8asZGYvqfIFC4W
	QOqt140VRSQfU1Qw++ysfl0HeUMUonU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBDFC43FB5;
	Wed, 17 Jun 2026 03:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AA21F000E9;
	Wed, 17 Jun 2026 03:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781667071;
	bh=oRk5REZ1sq8yz/FEd2MRrPo8/o6v1rgYxnNAIv2TPNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFSc5IUugCDmljlonMMQqY1wbqP+8d8ppLolDixCmob043Rpc25zvnPMzTg6tJkTf
	 /Da6IpoogaOI9xqf/fEm+gsmViQmX1sqFEy105e+cDLOtEEVHkFmBc/YXDEL4ZVTxp
	 brmx2SveZyDtG17HgiFXfl/jBW5FOk0nSL8o44JqxsY46pgzKPiON+Rer7hJcZwlH4
	 fBOllj/UKLXIQx8Ko0Xf1EaqAv09xo3CbcApTo0dkX1QPFvKROfFGVLVzLhPXsonQY
	 KTrM1LNBEHpNmuEzj45MdLW/IF7uq1nKngzldKqLVn16RiNg2m0C+qHxLQKCQ+KFVc
	 IjA6o+vaTHp6w==
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
Subject: Re: [PATCH v1 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Tue, 16 Jun 2026 20:31:03 -0700
Message-ID: <20260617033104.98334-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150316.580819-2-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D648918000A
X-Stat-Signature: 1mw1dwmiyjwdmqtdw98qmgsuji8fqef8
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781667072-228292
X-HE-Meta: U2FsdGVkX19a8seiHMZDo06057ylOctDC+ZxMv345J0uIpxzZdpYSBPG4TcshVP7sAuvnSa/vdWcS1kycltMVXICdi0UXdKUtwnla2ekVt2oryEj+hu7Cf1DQ8g03c9FR1m9HEtKx5jkYpWGkiZ4MLRi8ymPNFOvi7FmNX/ZaH7AI7o3Um5bQHq2vI1sE4uqVQHoBalpp9ceKPNlGLVBzEyhiHu2j+5gtQorN0OsTTYPVTv9HM3+LMQLweCiQFEB+ReS7m0gL4KM7vU46PjOBOkvIH7GX7OQHQ9WA2LKnOGaA0YI4W60I8zoD0kzJTKtNjGjYl+oJMJIGtZs0vXACn2OqImPey1k5/jYbYEVWXnSgYHtXqbv8Dg+lmXyVwgsish824cW1PAf/ZlolT+CUzyR2COjMiX/K5tMzCGL9/rJcDZAMg+WZfiIvascEBsb8g/OB2X4dXIIWYZXTquprhc0L6ibtSTpXAC8RdRP/xSOX5R49IM3ikYu7i3y02Mz4U3FktYqxKSI/v5yexX154PocwV7HwpnEO8LxRGE+GWafXnVPSkR2eH8JtHv1a73Bu5PXU9gCDYFRTnwfni2/XvZIB+X1MZT5zPxfC3Ku/dmDfFye8P+/t1kKt1kjum+MzTff5Okntm0+oWFuUScqJOWUy7xf1UtIrGDmF1Htv1Z70WsO3G3dlwbloaz3PHJTBTOiAY/xiVoZbQGIy91zVmYyOUt2UqDIsDXF2yGmyIZ32/M5RJbYXlub4Cmy7G29QBrpY/JAv1rTTpwhHtiiBR5ayhH3sgyIRXASVBYoccQA8Ow1YDF9CrEzu3wuel16en1m1PX53rlTXCsa9W/+VZgk21mPDSbUdC7azUBsqzBkaP8a18n+ys0EKtX0oKeFq5gVhqxUBwlr2aSTAyLsx9g7zGpPI6pmni2vczSzh731A5kX7PLvXLkr9p8kg6aWMDU/nEkatMbfSgV0El
 eGKfCUEU
 3C/kcf0fc+l61coIi6ihMsGCG5CuE0KIe64djZPoHOdYOC+C/oQsIhitdSGEeJCFDdK8d3NyE1SEW/1pdad+H5+VPmTc/G0fvxh3a7A0oUJUeizz4HD7IF/AoSLYBF3oOTb7GnrOovo7Rqp/VsKCGWXKbXAagqUFaRCPJCH7Eu9fhmlFJejDYTdNWdJyOj8FCiyvheEaOAHp/uMYi0TwHH5jUM6EojJ1i7H7C/v7j1BdNuAPfpwGiCv4eIRJJ6E06yz0cc8n71vNbOr6uFjUD4LRoEGox0Zq2oke99p4EcOg/qYJkv91svcCWIRPBT5ojYo+tMfVFcQ2/FwbkovCvxdgu6McvV+IT7Fi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:03:14 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning Add a new

Please fix the name of the quota, and add the ending period after 'tuning'.

> DAMOS quota goal metric to measure the amount of huge page
> consumption to total memory consumption ratio.
> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  include/linux/damon.h |  2 ++
>  mm/damon/core.c       | 14 ++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index 6f7edb3590ef..23a9cec05033 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -162,6 +162,7 @@ enum damos_action {
>   * @DAMOS_QUOTA_INACTIVE_MEM_BP:	Inactive to total LRU memory ratio.
>   * @DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP:	Scheme-eligible memory ratio of a
>   *					node in basis points (0-10000).
> + * @DAMOS_QUOTA_HUGEPAGE_MEM_BP:	Huge page to total used memory ratio.
>   * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
>   *
>   * Metrics equal to larger than @NR_DAMOS_QUOTA_GOAL_METRICS are unsupported.
> @@ -176,6 +177,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
>  	DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP,
> +	DAMOS_QUOTA_HUGEPAGE_MEM_BP,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 7e4b9affc5b0..b001f80681b1 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2795,6 +2795,17 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> +static unsigned int damos_hugepage_mem_bp(void)
> +{
> +	unsigned long thp, total;
> +
> +	thp = global_node_page_state(NR_ANON_THPS) +
> +				global_node_page_state(NR_SHMEM_THPS) +
> +				global_node_page_state(NR_FILE_THPS);
> +	total = totalram_pages() - global_zone_page_state(NR_FREE_PAGES);
> +	return mult_frac(thp, 10000, total);
> +}
> +
>  static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		struct damos *s, struct damos_quota_goal *goal)
>  {
> @@ -2826,6 +2837,9 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
>  		goal->current_value = damos_get_node_eligible_mem_bp(c, s,
>  				goal->nid);
>  		break;
> +	case DAMOS_QUOTA_HUGEPAGE_MEM_BP:
> +		goal->current_value = damos_hugepage_mem_bp();
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.43.0

Code looks good to me.


Thanks,
SJ

