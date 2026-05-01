Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17631FF886F
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 00:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5583C6B0088; Thu, 30 Apr 2026 20:48:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5091A6B008A; Thu, 30 Apr 2026 20:48:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EAB6B008C; Thu, 30 Apr 2026 20:48:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31F706B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:48:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C46C51C029E
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:48:35 +0000 (UTC)
X-FDA: 84717015390.16.E0C53BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0C23C1C0014
	for <linux-mm@kvack.org>; Fri,  1 May 2026 00:48:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TCc/Eje4";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777596514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSpXi3GcuPokEj/jtwVxY7gCEXqW/ewCvPs/eOl2TDQ=;
	b=IIfC6ATxvnrQ20bfI2IBPAtIrjgwjLSUHc4uqCpnip6JMA2wUnKasefcfEgP7ONqnLZ+2C
	Dd4tg4++qQOSOTrZJkTP18BfXLkTgczL2ENMlrSE7YDgBdzD71UfS3D3cQPkeht2cdSMuM
	ClJRlFqlgNWeHA0tLsL3yxHCdAGOdIY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TCc/Eje4";
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777596514; a=rsa-sha256;
	cv=none;
	b=B4HyJV8N17N0apQtWxf4vK9BwPCSjlCx9ktXPWGF7XvrNS5zz80Zn3nmxywKnYIJZz4H3w
	MnHwptFpUS3i/+7ghAHj0LC+jUsRl8uOuEV9ukANV9pbJ+ZcfNCGeuwF72H7kY6MqwYQtk
	3prvk95eK/GUyGictjyIw5PtO0jcobU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E928B43288;
	Fri,  1 May 2026 00:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58751C2BCB3;
	Fri,  1 May 2026 00:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777596512;
	bh=QYE+u2FdAXNX5PHivfzb78bycey5Sr9+axN8eMvgZ5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCc/Eje4Chjgo2zyRCKBH8S0cTpX4fnADHoRHjEO0waIJ8DBK2QQzd0H0BVvbQR/d
	 BI3N+3UuMSfoGwJUCsUJUAUaAORV+eBJGhcypZDEIjFEHidpl3eXtDwsaDAdbemT/U
	 T4Bp92SVyn3OGefNn/BV3bQACapuVLYgmI2I2WiZZJijjuqgAXv3JqBAlxIwj1x00H
	 sy+hBDoQskyxoNUpHpP1ai/9/2jlvk3DmJOIOvXqOKRZvrw4BCC0CUs1/YHrqRGcSu
	 Ft1XnNfF/bpBV2+YyRLtpQvdCKCku1Q06wCizNnVh0KQvBw5NMZeygJUWAqrOCRAIl
	 4+N55HASG72Lg==
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
Subject: Re: [RFC PATCH v1 2/4] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto tuning
Date: Thu, 30 Apr 2026 17:48:28 -0700
Message-ID: <20260501004829.79016-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260430134139.2446417-3-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C23C1C0014
X-Stat-Signature: j8nsij3u7ejcpxme1cr39r1syskfgxzk
X-HE-Tag: 1777596513-359474
X-HE-Meta: U2FsdGVkX1+aJHzS6Izd/YZg0KgwdEYhn7p3zynJPAdhhaWiBRaEtlJmn7Jzlvj3nBW6U4UgaJKZRS7lBwSpuw//5OgXgsLHJiAmmT9oaLTSwAvGxBEGlVov2mdyZ8vhqtzZ1FaAvwTM+XkljtlThVyaZus6c37ADolp2L+HN6+zoDdL/QjIaMm+Xc7kDiM1dBifjvnfpRiO75VCWNFnVgNGM4rcsJ09EbAeEWwt5jaYD61hDHJaBG7nXn4NxNN28uanDsl9wqlcnxqL3FVeHMcuTQVOKhjn61hypR/m8E7QkzFlL4YQw3k+4Wy5VYUQXQ/sMw3u1aE0st68CLfpXdXTQ11BDbqqWybn2OcFkeJLM694n9aMAhm+YVFsYcaFJ26Q2UH8F3uLaENv1p4/BjUtesWq2ZVhAlQSYdlACancQzlzWr6sS83c568teIjJi98dfwz+KJdxoK909n9DiOvd1rDT7pA/TH+5Nu96sy5zlaUyACFf30VAJXSQqvPrfTzXXN65dapRdlpn2H+/Yf2un/X2z5COjHeg4uEAN3BOavv8Ir40KPeyvfG5UWezzeDWVRQMb/xj3Zrb+Dr5cYWSmjFAdwpvpesMlFD2sMyFlVFBV93dmG6LkChXpYgQTfCQM0zX/UDw7gDjL4doKm18SBioE28aZBdTJY40GMP3eaSnfedvPwNRHk3hwG1KIn2H1wCWkCSWJ2aNEl6Ql1wrvAaPgNIBg65cJrs4Qopzpe7z6bQ/kGvmKrdtdgIaQ+Cr3KhsoYXGii1oPxO3+R9x7XidoeisOLKPlzd+GAFThufQ92jcAGYNIVKB0wd3UYEdGuNo11BFHt0NkkJmuKAn8k04tGjukRHNBjpa0ra9F8tOAkxB0LniOsvRoZXtUWkhEirfaQxUHEiUQQjzUi6bO+I+O7qtQzhC0WCefwv+5Orp/R5IgdRWd96Db6pmDrRuQQcDRuRop9NXfnA
 J5ibFrf6
 p+7Wybdl9uEuNCUhr2m4VPA9u9uUGAhFCeyM+/J/cpUCfxYuP64xox8ycYyksiwpLzy+K4ElJd65xDWUIFI5rWaRhrwPvhgkitfX6OPqdAumjRDSltsnKVHXyNzbRsYL5pcdkmQapbxonem+05VaUP6rIVJT6M0pXu0NeLNsTkxordqmkLX8zgDuxGHIADtccCNeA/oGJ3ghgHuCDC5zsN0znPa+JVQh8LFMdZ5JqXRDSRm7z1o0rgSNB/tRdOytr3a1LKWmKltwI8In6NC70EU+Mz5kLXYj/IEdUG07fI/0nFCUMk5PmDgUgMh7q4oQ2TkKF4PrLOaJh3yjvM7PJxw5qwiUvQuRs6xg5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 13:41:37 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> Introduce DAMOS_QUOTA_HUGEPAGE auto tuning

You forgot the sentence ending period.

Also, the cover letter was calling it in a different name.  Let's match those.
Also, as I suggested on the reply to the cover letter of this series, too, I'd
prefer having the unit for the ratio on the name, like other goals, e.g.,
DAMOS_QUOTA_HUGEPAGE_BP.

> Add a new DAMOS quota goal
> metric to measure the amount of huge page consumption to total anonymous
> memory consumption ratio.

Why only anonymous memory?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> ---
>  include/linux/damon.h |  1 +
>  mm/damon/core.c       | 15 +++++++++++++++
>  2 files changed, 16 insertions(+)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index f2cdb7c3f5e6..97201e9fa407 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -172,6 +172,7 @@ enum damos_quota_goal_metric {
>  	DAMOS_QUOTA_NODE_MEMCG_FREE_BP,
>  	DAMOS_QUOTA_ACTIVE_MEM_BP,
>  	DAMOS_QUOTA_INACTIVE_MEM_BP,
> +	DAMOS_QUOTA_HUGEPAGE,
>  	NR_DAMOS_QUOTA_GOAL_METRICS,
>  };
>  
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3dbbbfdeff71..06547e590ff2 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2319,6 +2319,18 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
>  	return mult_frac(inactive, 10000, total);
>  }
>  
> +/*
> + * Returns anon hugepage memory to total anon memory use ratio.
> + */
> +static unsigned int damos_get_used_hugepage_mem_bp(void)

Name sounds bit long.  What about damos_get_hugepage_bp() ?

> +{
> +	unsigned long used_hugepages, total_used;
> + 
> +	used_hugepages = global_node_page_state(NR_ANON_THPS);
> +	total_used = global_node_page_state(NR_ANON_MAPPED);
> +	return mult_frac(used_hugepages, 10000, total_used);
> +}
> + 
>  static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  {
>  	u64 now_psi_total;
> @@ -2345,6 +2357,9 @@ static void damos_set_quota_goal_current_value(struct damos_quota_goal *goal)
>  		goal->current_value = damos_get_in_active_mem_bp(
>  				goal->metric == DAMOS_QUOTA_ACTIVE_MEM_BP);
>  		break;
> +	case DAMOS_QUOTA_HUGEPAGE:
> +		goal->current_value = damos_get_used_hugepage_mem_bp();
> +		break;
>  	default:
>  		break;
>  	}
> -- 
> 2.43.0


Thanks,
SJ

[...]

