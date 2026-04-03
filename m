Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AE1FE85379
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 16:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B856B0005; Fri,  3 Apr 2026 12:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C6C6B0088; Fri,  3 Apr 2026 12:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761FE6B008A; Fri,  3 Apr 2026 12:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6329E6B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:19:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03EB81B747D
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:19:10 +0000 (UTC)
X-FDA: 84617754102.07.5A194BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5EF8C140002
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:19:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gElMBkaZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775233149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/x6PubSKBcYK5CvmIxhFsGwLhN/3AOBJI+MPs9EAl5U=;
	b=UX/rlvFrTIvD5PORi9LrKl6nHVaNg/Ko/g1UnfaBUtz5ReNCnS7UF0IrdW7Xwn6PtmB1kv
	1SP9LzZmv73tBJYd98iEq0bQVIrXUKY1M4xi2DlmiWLEFgPp8OiApmKivFzXBS7s/eO491
	QRJaC4KzrT9pL4NvZBl5Li+iSZsyZeM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gElMBkaZ;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775233149; a=rsa-sha256;
	cv=none;
	b=l7erjN413kWOd8t5xwyfssaNbDlB1ztM5na1ORECZ8GJesjyIVQRNLMbFtK/ENn+vJ1xoE
	e7+HstPkqpvAGY/mX/sUL8q+7yXp1mxNIahzgyPvgITNBZBsEwb+uMOrERLXeB0Cx7dapW
	quU6LpjxuHb9fQsl91ZNlwY8/B/f1h8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 731554411B;
	Fri,  3 Apr 2026 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25748C4CEF7;
	Fri,  3 Apr 2026 16:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775233148;
	bh=7zNWqrKWKBGHhtfMs4MAPonKRcJZcjaQjimH+qICKwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gElMBkaZhsPp2UQD5QMhiSn6Gi1LPsK7W5mjeWHtrWDbbuWe/vzrR2H7suSKrSSxE
	 yVTIKTnEodC+Fjb5DcS9YA+YgcjSQ7PdoAcFzUpHJu7z4IKApte6IXAL+eBQnAlqDL
	 dbUDB7i7YNZadu1LkjrQTtoS9vi9gvZvlptx5XDJSZ3MIcVXXhdhuuV0I8Ow3TX+K0
	 AOscofgmFB1h6N54lzj+7hrUifWij/dPRQgH1xk+gL9RPohd0jYjUEEHOBAsxgswms
	 iwTloVCgj1rZDBqk4tWxGI8OV4TPIWDo64W6QJNYceZ7M3+io3VtGuMkzHnL4seJ+4
	 7cm0rwp5B19lA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	yanquanmin1@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri,  3 Apr 2026 09:19:06 -0700
Message-ID: <20260403161906.65008-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260403052837.58063-2-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5EF8C140002
X-Stat-Signature: etpjgox4ysouybcos5ynekxhtomhd74m
X-Rspam-User: 
X-HE-Tag: 1775233149-819904
X-HE-Meta: U2FsdGVkX18Df+FrL+PkLlPIBCItmraLaOItHcoJh61gwPn1eKfuC+Neil5h/S8zZ5xOXuz2kYk3AwamivD4Y/nX5HOQM7rHnawEWsoAZjdtUm1bE+3Ml4J6BcW7HipROBs8zr/iwS5fHvU7UQAtHD0V/wLVdEB6hDAxBD4c4PPathQA6VauYJS55Sv5l9Dl2Udb7R6aoCIHsz0DJJw1FfIpezsSEe4ATKC2cgZJMWd11ZHCl5p3NLiEkEs5if2LF3seVM3mVhVGgg/ZYkfHxBjb/uVQOph/80Ua5y1ImaUHbQvTQ4Zj0cZh5lRNiBkukhJ2fkfPQNge2U7s211CJDmaq4z2zlF4fttWTtNf4BrGvPbfue9bUrZnZs30A6F1StO0RwJrrCWwgWlo7CBNIkJI4XIclbaLhyUdKEtR3U/PiXO/Mzs4h31Z+Ij+SnRQkMKx8p8V+sUKNrFWB78/7EYtlsmX+VRF9Qvf/oZ4eRM/WinPoA1O/S1HDds8NyWzB6bXn5SJ3IC2fkO4kV0rNIvcAu30DC5yUdKVv357nrKI586NVr9HqBCDeSupR1Rt08VnmLdd58iEmZ4imqguqxhmZMPls5Ob+6tzDbz1KiBXNTR98hmgjLsucvBjxc+mo+jeXeDRTVj49vBudzUVy0mQdC2RaI21vsXYLRtVS4L/Yyi4CLYei5kcyl5y/ectpTb0Oc3pzFhd82ZBQ8Bo/D8EQ5l60R8tciRPhDvpDtVG0bxnJV1ifLm8yJw3uPWMpR6Bp0aEerggh6N2AvILzHlREHYL7NpyM5ZC5ojfK6RyTewGyWGjF/UBh2UggcbJhgokwnjdwayCOUugDxPvaTGu8M5pXahz256MRgMwzySzMjnrT06SYYxR2gtsWnWPprEXVLTIvTKpOfPkZ+qBD0/GkfN3atFM5oq4EgMOOsSX2tdUCR58Ri4jaBFjwfwITi/ephC0Y+UjI0TLJED
 V6nIAg1i
 +NlzGc3XXw3sXINvqu3Eppq7Fu4F23EivmgVViwAbetFI4GpMlLWwHccMES8YqNd4o6YIgxMPyZzdmozmAaEFXgVDBw0dNcrTgZ+PKsQa7WxasjZAc0qlLhbUGZoMxDUF40b+1tGM52q+GtjEcmsFUJZTId51SlLsY0kSn05hPa/ASarSfiLm00+D80D+PflFLgn2mFScnmm4u1VuU3QE2zJTsckybE6k41KQkXpkGtNKwnOnViYU/cP/ljl0b79ZGq4+HF7Vv7oDTRsHEH3lfh0PYBkOWgPXSWzjgqqrND1wdiQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 13:23:49 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> The damon_commit_ctx() checks if 'min_region_sz' is a power-of-2.
> However, if an invalid input is provided via the DAMON_LRU_SORT
> interface, the validation failure occurs too late, causing kdamond to
> terminate unexpectedly.

As Quanmin also asked, clarifying the unexpected termination would be nice.

> 
> To reproduce:
> 1. Enable DAMON_LRU_SORT.
> 2. Set an invalid 'addr_unit' (e.g., addr_unit=3) so that
>    'min_region_sz = DAMON_MIN_REGION_SZ / addr_unit' becomes
>    non-power-of-2.
> 3. Commit parameters, and observe kdamond termination.
> 
> This patch adds an early check in damon_lru_sort_apply_parameters() to
> validate 'min_region_sz' and return -EINVAL immediately if it is not
> a power-of-2, preventing unexpected kdamond termination.
> 
> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> Cc: <stable@vger.kernel.org> # 6.18.x

I remember I suggested adding stable@, but only if you think it deserve.  I'm
now not very sure if this deserves Cc-ing stable@.  As I mentioned before,
there are multiple patches to review in parallel (you are also having such
multiple patches in the queue).  Please don't expect I will follow full
contexts especially when a single person posting multiple patches in parallel
every day or two, and bear in mind with me.

Sorry about the limited bandwidth from my side.  You could also simply slow
down your pace, though.

For stable@ Cc-ing patches, more clearly describing the user impact would be
nice, and helpful for judging if it deserves that.  Could you please elaborate?

> Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> ---
>  mm/damon/lru_sort.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..3fd176ef9d9c 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -294,6 +294,11 @@ static int damon_lru_sort_apply_parameters(void)
>  	param_ctx->addr_unit = addr_unit;
>  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>  
> +	if (!is_power_of_2(param_ctx->min_region_sz)) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
>  	if (!damon_lru_sort_mon_attrs.sample_interval) {
>  		err = -EINVAL;
>  		goto out;

Code change looks good to me.


Thanks,
SJ

[...]

