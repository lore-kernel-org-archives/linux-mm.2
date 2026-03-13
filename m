Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FB8107BCEA
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 23:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D641B6B0088; Fri, 13 Mar 2026 19:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12136B0089; Fri, 13 Mar 2026 19:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E156B008A; Fri, 13 Mar 2026 19:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3BBC6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 19:40:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 454811B75D4
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:40:34 +0000 (UTC)
X-FDA: 84542661588.15.4D2DD00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7C3C940008
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 23:40:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C32twsm7;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773445232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yxT+bqrHjRm54SrtynJeTBtNOwz0k8SZ6G2p97G0vyQ=;
	b=ZP+0yhQRpv7SwH55zwXl4KYN/NSNEcNb5EIbNVOsKN4ORiG13n/7k56FP/QO3yfjVKq6A7
	hcV9oP323wyCxTG7WnIUehdtbo4CfHoPEGPj5jrl+JGY1pgbbToDLUSnV6/RJpjD/BJt2R
	i/fcBFQFZFOtNszMivk0c0bD6wRd60Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C32twsm7;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773445232; a=rsa-sha256;
	cv=none;
	b=JkKZD8/a40NPIFsoUELpw871noZMEvGVrTeTY6JLSapGS/ohFKEuw3lV6u7K46k/xGY0a5
	9JLbgTeHmkMREY9ra6rqNgj1Y/FTFZXbjezFGmrdoHsRZpNuwoyP8FpcK15wO4L6cHGyEP
	5IbYlOwHBiWnUg8V/wJ7qH9uVak6xgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 509B14381B;
	Fri, 13 Mar 2026 23:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FB2C19421;
	Fri, 13 Mar 2026 23:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773445231;
	bh=diDZ4t93o+Rf0IOUn0/DF6Qjjum05J/e29qbsPhZkp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C32twsm7DujBauXg1gp2P4PHnRBTfRCqhPncllIb0snO1e4wxE4R1B1L6hUDjunb4
	 XnZGxadolRgl8MOApp6yycb4wCKsjGndxh51lTbLYxJJoeDRMQO02ul6pFZCFnejlV
	 NP7l/LryZ/t6PsvN+QKMMPv0417kHSVYUnAhBDLkTrGp4Amc0LijmB1S8IP2djT/ml
	 8Xn4ku0S9eJ+nvKqikSGyRejkBmbBIFFNai7TtJqcK4pZBF86SEViFe8lcuLqd0LpI
	 eAbWtEPH4oXx14NQuq9uxsqw0lq3lsqWoKz0m41tjQcgXUnQWFIPy/0zBZzXNPgSIF
	 8iJdjQe71Ai1Q==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/stat: monitor all System RAM resources
Date: Fri, 13 Mar 2026 16:40:22 -0700
Message-ID: <20260313234026.48872-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260313044449.4038-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7C3C940008
X-Rspamd-Server: rspam07
X-Stat-Signature: y9p3qi7demj96g8qinpgbgnwhx5m38s8
X-Rspam-User: 
X-HE-Tag: 1773445232-155466
X-HE-Meta: U2FsdGVkX19iOtKeOBnIvkmnu5Tx9PUTJ9Dp5TXT4ff9Sl4nnudQiE/w2i+KK8UZXKp8OoLJmVa1v25Eiu9cnOe2B89Vht0TyPj/fDfJwO5gdFNR0cfM6InR+cZfXqxerqMOYBW0z479hoyDwFQo4D1XSzW9sRsTKpHvj8yesViNHs2jbET4XNkAa7iPbSaR9Hdjz/vLUQezUZ2XK8MvzJQSHe0q6QWLjyo/AnmWfLchIAOFi9CgHMVQJiDlTu0WhFTJtwdLN7C5/M+EQKQ6FZllzTj1gAm9RRL2hYq7KlDivJGybcLcgxowOxdyPJjq3EAIKYQIsr7wPhHX3r2EoSKkaV0PyEu4X+eWP2/IOR+65ma7tQI2KDxpGVauOuYNNvMCSd+7UT74go2pk8bhzQbFzvOPGNRC23X6UulYV/s5XapXH8sqJL05zrlUFqbiy+C5IvYftcL+LVVDczDDal+sYeqKJP0Ggwc/YYcvVCGyrHpdoq+PhZ5iFspiTZ5d85lud9aXJ/+R5lLnwdCaocSzt0RKhwUnEmUpAaq4h38nQMYhnaU8yRivg1yXD+3Zw0EH/+VAqJHjMNHMF/A7K1BvvSrKESNk5WWxSRFjGTfio42Lpo5vXIBKCvpZFT9d0UnoKBVFEbhHTeNh2zWR5hVB4SzS+yrQFKsJARBz15FYomRf7cynjsFzzBNQM++KgkxIhE6AInSQ4m04sd1cQxhiGEFMnerjlBJn3QDymKAUqehMGkmu97zA0pTHoL/ZnYz+gCTRtxuL91xVc5KMlbx4k6KYLFEkZNKRh1KjZvSBglA6EJlIxzn8l7r4V2ekpeAwLnXwfLdYjDVSiWK2kxz/HqYaok/B2qBkLZne/YdLQ//rNASgLtoNIUxo3sG+uIVdFx1r6oNH70fktOb7pFU4GG7YyqKc7tv14S4DqBy+PZeHpVoTP7OnPpuKB2DVsEO31TZZgR6Lx1lAKUH
 XvGUL3cr
 HcqdTb/caEWOo3UdvTrKoADhH1boA4iiZ8+6m6j7fIEquwg9CNJvzJQ3C8PnFkb2w6WX2R9CnxC28MXODGJyQzJFuYZAA4m/C72KNJT0pOhDApeENmV3GSmAbTpDV8Z7NxGEG6SZ3qj6Nt5vT3FAEezMzNVpXGSSVFMjJbCU0ibi4zlXSqAsgU4atnGM0DZ0bIG5b0RoCeP4imuJA3Sz8p0TJtdOq8fWHMXaFTlJgXGIv+g5fCd5o1VVZWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 21:44:47 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON_STAT usage document (Documentation/admin-guide/mm/damon/stat.rst)
> says it monitors the system's entire physical memory.  But, it is
> monitoring only the biggest System RAM resource of the system.  When
> there are multiple System RAM resources, this results in monitoring only
> an unexpectedly small fraction of the physical memory.  For example,
> suppose the system has a 500 GiB System RAM, 10 MiB non-System RAM, and
> 500 GiB System RAM resources in order on the physical address space.
> DAMON_STAT will monitor only the first 500 GiB System RAM.  This
> situation is particularly common on NUMA systems.
> 
> Select a physical address range that covers all System RAM areas of the
> system, to fix this issue and make it work as documented.
> 
> Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
> Cc: <stable@vger.kernel.org> # 6.17.x
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/stat.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 48 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index f9a2028483b05..3ed71db33e899 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -145,12 +145,57 @@ static int damon_stat_damon_call_fn(void *data)
>  	return 0;
>  }
>  
> +struct damon_stat_system_ram_range_walk_arg {
> +	bool walked;
> +	struct resource res;
> +};
> +
> +static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
> +{
> +	struct damon_stat_system_ram_range_walk_arg *a = arg;
> +
> +	if (!a->walked) {
> +		a->walked = true;
> +		a->res.start = res->start;
> +	}
> +	a->res.end = res->end;
> +	return 0;
> +}
> +
> +static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
> +		unsigned long addr_unit)
> +{
> +	/*
> +	 * Use div_u64() for avoiding linking errors related with __udivdi3,
> +	 * __aeabi_uldivmod, or similar problems.  This should also improve the
> +	 * performance optimization (read div_u64() comment for the detail).
> +	 */
> +	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
> +		return div_u64(ra, addr_unit);
> +	return ra / addr_unit;
> +}
> +
> +static int damon_stat_set_monitoring_region(struct damon_target *t,
> +		unsigned long addr_unit, unsigned long min_region_sz)
> +{
> +	struct damon_addr_range addr_range;
> +	struct damon_stat_system_ram_range_walk_arg arg = {};
> +
> +	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
> +	if (!arg.walked)
> +		return -EINVAL;
> +	addr_range.start = damon_stat_res_to_core_addr(
> +			arg.res.start, addr_unit);
> +	addr_range.end = damon_stat_res_to_core_addr(
> +			arg.res.end + 1, addr_unit);
> +	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);

The third argument of damon_set_regions() is the number of ranges (length of
the array passed by the second argument), so '1' should be passed.  But the
patch is passing 'addr_unit'.  It will not cause a real issue since the value
is set to '1' in this case.  But it is an obvious bug.  I will fix this in the
v2.

FYI, I found this issue from an AI code review result [1] that published on the
internet.  The review also added two more comments, but those seem irrelevant
to me, so ignoring.  I don't know who made the web site.  I only got the url
from a social.kernel.org post [2].  Whoever made the web site, thanks for the
review.

[1] https://sashiko.dev/#/patchset/20260313044449.4038-1-sj%40kernel.org
[2] https://social.kernel.org/notice/B4E8DdeZY07PseemfI


Thanks,
SJ

[...]

