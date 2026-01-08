Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25955D1489F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 05:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6A76B0092; Thu,  8 Jan 2026 00:00:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8651C6B0093; Thu,  8 Jan 2026 00:00:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746306B0095; Thu,  8 Jan 2026 00:00:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 657916B0092
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 00:00:08 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB2C98BFB5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:00:07 +0000 (UTC)
X-FDA: 84307594854.12.FDA4329
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id B4F51180004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 05:00:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tQNMbCmB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767848405; a=rsa-sha256;
	cv=none;
	b=XOFehDCWF+B8MaRh1x/zpLMCnnDNmz9HEc0+jOucDJWJos+bPUlVE7zQ2l/z8PlPufFLt8
	GFoqZngd0uvUuuhsuWs0rEH75dpr+Y9P0pjOODb+C7W0SYCXbOxjyTM5ujY168OJ1E4WB9
	DcP5oj84qxySxzlx7o7scchA9l77HJk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tQNMbCmB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767848405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFj1QpRxtnKGva900kwmPDXo623XZD3xwx9+oMoKODA=;
	b=ksEIncD7EIihD3BzB4TMSSxZx6awBS2h1gVeG7gnxq0swWW+2e+6iqGhuJFUCbgQmJlxsv
	1GuYS0YyvZFFktO2zY5kDzlTt8cTKDU7l6XT1l5LbZPtTck6CZVUQR57PRCOZ816AkDK8J
	rW876S8htZ4++MG7SU3dLrjbC5GtlNk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66719417C3;
	Thu,  8 Jan 2026 05:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8A6C116C6;
	Thu,  8 Jan 2026 05:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767848404;
	bh=1B3KdBEHnVGrwHaFJwXfUoo0ljW4nYwZYlVoHlNtMbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQNMbCmBM9WpAmQhgaPJlGrgLfeeGSplgIBSGEGP6VX90OUNEZ3Ioun9kY5r6qB1S
	 d4QlsO3fYjjFIjM3iLTiHpBuqdNY/3811RGlnhZ68pBR7ElHNt7dkbjsD2JKdpTzNl
	 igdlHBIafM+F+kZjqS0tBRHWmJrOVSMtg665Gks9Y+VZhAy3hrIHYBqJAOTiHlzaYj
	 iXYFMD08wjVySlCJ360/9ZG2vHol3zJRMu+q7JOP6PHkdt+72DvIiK5CUeqLALQuyc
	 cqJ/MPq8UQuy3HsLjtQwUspDb2MiFjdSu7K0zjUduWIyuiSPIqHlFnMTg6ERugEqVw
	 iXCFGyxISnQqg==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] memcg: rename mem_cgroup_ino() to mem_cgroup_id()
Date: Wed,  7 Jan 2026 20:59:53 -0800
Message-ID: <20260108045954.78552-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225232116.294540-9-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B4F51180004
X-Rspamd-Server: rspam03
X-Stat-Signature: yrchz3cd3gixy11potuz7mwydi7nrkwd
X-Rspam-User: 
X-HE-Tag: 1767848405-834637
X-HE-Meta: U2FsdGVkX18Wn+py8ds5jiyOLuNj6yV3Y31TZzoL+rPv6YgR5APKB1qnZ1lr/EkFnp2YdYyTxsFC2vRKJ9J+psa77rHwtxTtrTYP34sM6VlXz/puAyeeM0XLaf3qqPgn0BALpcSb01I5fINXgX+1gunuv3EnKVc940ItYrgtx5FlY51u55Ti7/6lLbNpEB9mII6Kxe1nRrAzmhw6/cxMKeUXzm/OJfMi5T/x6janAqY4MUrh95OivAgAFy4R8F61lCYqNvV5Zf/EXtcO7JOz/nwAAkMTob1+fpUuYMC6AeJuP1QPIZe93qHlnMJUgHqfDRXqke9Uu8hzeTUHCVcNYFR3634TSNzHWPX6//3eJ2ATOFDBkyPrBnGIReLEHbmgBtZlttl6jR1uihjiJb+F2EShcWMnfHpmKcY9ttu+QRGgXiqarpEtgNG+TxFcGR5c6USkg7/XzZysmffOQGFmg3ApUCEamPfipJa+pzrGhboEVFd45Xc+b08jv/xIbu+i/rG2sGFvARQ3QQn9ObzWzaXz31nLATtCja7foagrfJrpyxrAaQ679oIcT0xIIRfJJZgGI18mFOhG3w3xl242Cchh2nRQnrs9ABCTnhAtdALYS8cXOcdbnwVKg3LhSItE5xbbhpj9ZTohtO+84etRJjlysegIBGGv/KoemrjUPmBGOySpi9F18a0+BRldh5yn5JEo/jAQeqWEren2MQLc7/h9iHz//Ca76/qjExSrRjNIGSFGzQtxxMq1ldlU3URePAXvDv+4zkw6Lc+pcoY3O4UtvzxMw/eXXbAki9SdHvMLk0shBtdKEo065xfIlKWEeeQ1WVeETvrti5wIHQmRGD1AR+L9CUVs9ybJJnMxEeKq2loWqaczOgPgNESyaHkZmR+Ipt+14WtMowcR3oWpEKNZMNkuZuuq/4w7/waqkvMAupaunvcpBp09bgU0M+BZvhH/4vCk9bYtzLVwbTX
 455nAmWW
 z056oEIftxeJBFJY/hwooJLnjqJv3222SB5LegpPz0p43yc5sK1by0CC/a/WswIgR8Lb+S9+BnFSGYK0JGZYYp1C5e+6Dx/4cqZYwRemXx4N76ZieXIUkIGj4SzRrmIM8fbrii0eRwrTvVQ8irllqUxzh2xqgnJ0CvKtBJWLt+FzMShLkGCIzF3RB1AqfPpnJ19zQNV5dSFcZTycbfFmNlz9wqH1+P3cVXIl56NT0ZZWEJfepQYrcwMtiXg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 15:21:16 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Rename mem_cgroup_ino() to mem_cgroup_id() and mem_cgroup_get_from_ino()
> to mem_cgroup_get_from_id(). These functions now use cgroup IDs (from
> cgroup_id()) rather than inode numbers, so the names should reflect that.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

I left trivial comments below.  Because those are only trivial,

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  include/linux/memcontrol.h |  8 ++++----
>  mm/damon/core.c            |  2 +-
>  mm/damon/ops-common.c      |  2 +-
>  mm/damon/sysfs-schemes.c   |  2 +-
>  mm/memcontrol.c            |  2 +-
>  mm/shrinker_debug.c        | 10 +++++-----
>  mm/vmscan.c                |  6 +++---
>  7 files changed, 16 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 3e7d69020b39..5a1161cadb8d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
[...]
> -struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino);
> +struct mem_cgroup *mem_cgroup_get_from_id(u64 ino);

Nit.  How about renaming the argument from 'ino' to 'id'?

[...]
> -static inline struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
> +static inline struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)

Ditto.

[...]
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3615,7 +3615,7 @@ struct mem_cgroup *mem_cgroup_from_private_id(unsigned short id)
>  	return xa_load(&mem_cgroup_private_ids, id);
>  }
>  
> -struct mem_cgroup *mem_cgroup_get_from_ino(u64 ino)
> +struct mem_cgroup *mem_cgroup_get_from_id(u64 ino)

Ditto.


Thanks,
SJ

[...]

