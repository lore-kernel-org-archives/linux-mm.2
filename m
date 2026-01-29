Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA5FD6B084
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 16:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328516B0089; Thu, 29 Jan 2026 11:10:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF936B008A; Thu, 29 Jan 2026 11:10:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EBEF6B008C; Thu, 29 Jan 2026 11:10:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE696B0089
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:10:40 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A038D1A0256
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:10:39 +0000 (UTC)
X-FDA: 84385489398.10.0B1F962
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 084B4140014
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:10:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNZlHJMA;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769703038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOtIHjCo+i3OA21452XjGntWGgC1V9VcfF6yswSS/jc=;
	b=AlQOkT8IJp7v4SrFONsifcPM6mgdS21zHEXz77t2+8XuIou1sxyUeUamtCorBk8CIblXaD
	CHp7ZwDxj6h2lKq269NqqGmCJJVvXb3XBghY8pcyI3U/y97K8wbemMJCNpyeY8WjoAM6cu
	VNcIJuHpWFMkwXBnZsDU9Utt3uXyQxg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mNZlHJMA;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769703038; a=rsa-sha256;
	cv=none;
	b=YAfNQDszX0plstBi7Bfxus7aaTcpP18Pgal5oILN1XfsPClcjdK8xm7nwUy9EtZFCZeVw5
	RioOr7nGXxLZS/GiKCNgMUk6NXyF1EQkdant/AZMxO4LBS2OlxLAV1wKv2+j6lourYE5YE
	ItED05LkxlQdvkFbU1+C0dcDQMtBEOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AAF46001A;
	Thu, 29 Jan 2026 16:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 924B4C4CEF7;
	Thu, 29 Jan 2026 16:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769703036;
	bh=7qUXCNz5uw4XhHflyWVkqQxP0L7Oakns3jaa0oz4FYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNZlHJMABc5rWCv62g5iBM+MpPrnRpom0IY3QzYKejxZmdThV4je8u0JIbodyIMcu
	 ypizCps2nk/cAm0nWn0xnYhEbYV55ic3UHkkm3y6w8q1syW+WITLFyNxC5gyeL7aJj
	 +WdBpPMf4NIOnhrdgfMk0D3rtX8tbPZNYX9siB+zrhdpLnB5/UiwCFCQRvnc1BB6ZQ
	 ExbqDWX46aFuE5B6UIYs9SiSq0XjEtl7Un+s+1coGEEt7T3lEGN/wIh6MUvATLyEZa
	 XeWmZCaPzj2kGgW4SQcKdFZMKUivHHacR2pSyks3lGBjz3U4GbFAVZFRbWGkQzWFKS
	 d+lvh7A6D4oqw==
From: SeongJae Park <sj@kernel.org>
To: Enze Li <lienze@kylinos.cn>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com
Subject: Re: [PATCH] mm/damon: unify address range representation with damon_addr_range
Date: Thu, 29 Jan 2026 08:10:28 -0800
Message-ID: <20260129161029.48991-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260129100845.281734-1-lienze@kylinos.cn>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 084B4140014
X-Stat-Signature: 636dzbw1bj9dqxbkea6ru5jg8wozet4c
X-Rspam-User: 
X-HE-Tag: 1769703037-865096
X-HE-Meta: U2FsdGVkX194zdoLpyxZAinSPG0JpFyn4h9I/Esthux8ODBZ5VWCE8jXZx9+qNS2e7fFoqArI3bFRBC2vYRecHZrXidjP8nndFLhlTzcDm9tH1sXbzndd5uXb0s9/gaEqWC1Hyh5ZajnCBkg5nXjXpEn1S2hvwcNM3d9L9oPQh8qWtgPVcD1brRQQKybLlXryqAKQZP+OT32s3RLw4GvKJMMZtg6FxDh2sNHUy1GrgrNPsVISq9VGredQpVduGf+j8UNiIcvl8jL+SJspMIHQMG5xoTscODfdrY081ECYNXYJ6ACW74tYoeF+7FUZW+i6GdiF9HYWSKJAYDveU1p/hDfcFr0VOhtXHdPdpSEZNiiMomCOjgyNxvCsSBe3KytqCm0BMfhPm3lr6cSpg9T6ZZo9eZUuqet7k5noky/MvFCiTKloABBnrPo/tIxLvOAEzmONBJHgS1ggK4Er30vWgj1+lk22peWCoznLOq+PsiQCwmIdDdBbsbZGoTN0Qsgu2cb2vzatn9SNT7UlXbTx2qY6gdwaWybPFWjWex2lxzfi89duEsk0Lhkt57ZOH0k5UNEJVOVXLStMIIse+CQWXuP22XjWEDTg/kmVGNfG6+xMLFf/K+RV/I5Q6d9fJSBclup0fPcifJk+xR687JTQEkk9ObV7k6KusvhUiJWsxMAkJ9dILwksteTzZ+sSDAcGGKWXNZbfZhV/jLtDfNkU1yeMeDhXXfnJBk5yGluTaR69eTvEy+fJcHWZKnXTYRYqCm6Nm0VeYwPCsgSDOsZk45MH3yh+oHtZFsufNN5nQtG7Ud6nDrt+98y5yR1IUJpkYeM7iLa/pIYCSWoI8KleNGzebs21oBjjZX+0ZEzuTBYNe1LDFMCEz7TT0l9ue87EOCZxKQWzVmWyz23l719HiB9PUGucyyK3BLEmXO2kTw3dfs+KVzsqB78jA4EoFxzPUjyCRZie2SFadYWZgA
 i1siDC7h
 kdLF9K0DyRh46WjMajSYN8ddrtaGIDT8EP60ohyDHQeBfxDm6EU5dvGwjjDwL60GjYkSsmsm/DaWeIzqKsoCMx7ZQMZ2k3ZMbOl8p6WFVcRkIheOAfWDIy2/E8md9Qa77PbPBYFpWW13TAOVN5kvW12BW4gueLyh0c4+O3pvbEZpeHwakYSWApKThePXB1/MJyS7c/E8cQpxiHYKeNUn/Nksu/xrlwoaA6ju59pOGUNWf3OmJza/+U6h8ZaUd/AGOLp2gmK+E8/gK5rMDW594VGybyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 18:08:45 +0800 Enze Li <lienze@kylinos.cn> wrote:

> Currently, DAMON defines two identical structures for representing
> address ranges: damon_system_ram_region and damon_addr_range.  Both
> structures share the same semantic interpretation of a half-open
> interval [start, end), where the start address is inclusive and the end
> address is exclusive.

Nice finding!

> 
> This duplication adds unnecessary redundancy and increases maintenance
> overhead.  This patch replaces all uses of damon_system_ram_region with
> the more generic damon_addr_range structure, ensuring a unified type
> representation for address ranges within the DAMON subsystem.  The
> change simplifies the codebase, improves readability, and avoids
> potential inconsistencies in future modifications.

Actually, there is another bug that need to be fixed.  Nonetheless, that's
orthogonal to this patch, so it is not a blocker of this patch in my opinion.

> 
> Signed-off-by: Enze Li <lienze@kylinos.cn>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/core.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 70efbf22a2b4..5e2724a4f285 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2856,20 +2856,9 @@ static int kdamond_fn(void *data)
>  	return 0;
>  }
>  
> -/*
> - * struct damon_system_ram_region - System RAM resource address region of
> - *				    [@start, @end).
> - * @start:	Start address of the region (inclusive).
> - * @end:	End address of the region (exclusive).
> - */
> -struct damon_system_ram_region {
> -	unsigned long start;
> -	unsigned long end;
> -};
> -
>  static int walk_system_ram(struct resource *res, void *arg)
>  {
> -	struct damon_system_ram_region *a = arg;
> +	struct damon_addr_range *a = arg;
>  
>  	if (a->end - a->start < resource_size(res)) {
>  		a->start = res->start;

The above line is storing 'resource_size_t' value to 'unsigned long' field.
That shouldn't be a problem on 64 bit environments.  With introduction of
damon_ctx->addr_unit [1], however, DAMON started supporting environments that
'unsigned long' is not enough to represent the whole physical address range,
such as 32 bit environments with large phyiscal address extension.  On such
environments, this could be a problem.

Nonetheless, this is orthogonal to this patch, as I mentioned above.  So it
shouldn't block this patch.  I will fix the problem unless someone steps up
faster than I.

[1] commit 09a616cbb371 ("mm/damon/core: add damon_ctx->addr_unit") 


Thanks,
SJ

[...]

