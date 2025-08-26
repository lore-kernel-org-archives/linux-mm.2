Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50EB3CA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 14:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0368E00EF; Tue, 26 Aug 2025 10:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A0AA8E00EC; Tue, 26 Aug 2025 10:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7748E00EF; Tue, 26 Aug 2025 10:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74F318E00EC
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 10:34:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E720C0165
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:34:09 +0000 (UTC)
X-FDA: 83819153418.08.953E52B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74AA1180018
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 14:34:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnPlZeT1;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756218847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oNLq9u2Z+E8t4cZIvpZo46q8jPTTbHKG5bESA492VYI=;
	b=l1IawBd0lU1UYlCtlzFk+8cOfMRSeJmRhQRuIbo2NCmtE2PQ7GbpgnsGVKVz/2NzoXy82P
	9ySHBQ4UjnoHg9aZAeam+FYePzlS6gIs3t2xe+Mo8Cn6f2xsczcrra9xcBlY4ztISJFn7J
	l0/4As8AztzSIPE4tpvL8hoJQbkDxkE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756218847; a=rsa-sha256;
	cv=none;
	b=I7caMBl3mTE6EIvb3rSLQac76kJ97YKr+vM0XtEX3yN8JBeEbe9zR/Uhb6LoTBsSD4FMf6
	ROkp8GoKiU+Cog9ORoS1owE5UcJF4vBitfAu4mOAImfIrJCmm6vglapSWVeAF78q0g+o+k
	WrDo41ApZmybQRQ88DIXkWcOC1i+sqM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gnPlZeT1;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id A51EA5C6203;
	Tue, 26 Aug 2025 14:34:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0F5C116B1;
	Tue, 26 Aug 2025 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756218846;
	bh=3CPQkzt4NICb75OBiOuTfVapvMeLDLHP2WG42NRv1Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnPlZeT12A7JO4iiikyj8vx8JpEqez55iewEUUeoZjdP3ViwMVcOe3tqzcuUThY68
	 3it7q5IAggDs98ad26LHx5dIuIr4Dix6yvQzFIrPcKFi5D/Tkhhc8uZoaJBTdRgXFt
	 RX8nLImLMLg8xltiyiXVh70WmflcOyxmn1ntXwGqO3wzmalTMSntpZMJz2OqmzmDkp
	 +kOxCsQ2vfEOVNr3QPJvg0VFobm3GaJX7dudktQMMa2dQt42n6YrLqPObXij8Cm+Ui
	 uNgi/pMakahoBRCqxmaDaE9bTilG7A+5vHDzbvPmIE+La//I/655cqt8cuRmWIBcq7
	 UqWDBmL0w7V9g==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH 2/2] mm/damon/reclaim: avoid divide-by-zero in damon_reclaim_apply_parameters()
Date: Tue, 26 Aug 2025 07:34:03 -0700
Message-Id: <20250826143404.54232-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250826033653.1208227-3-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 74AA1180018
X-Stat-Signature: fi9pmgp7fqsqe9p964zi46yhu1wip5nt
X-HE-Tag: 1756218847-191250
X-HE-Meta: U2FsdGVkX1858Egg3En1HrtHvNk78HKNK+VS7n9H4dwNFc+O2RYcSxFEJuV2O24MxEZYDKhH4Znn16gqU8HeACr46Vs26rllFrms5wojGDytZOCdncU3bf1KJ7XRriAOWJQH6QdaCYds+74CsKhs/XR5JkY3hWsgqN+e6jCvOyiEUIpPzaag7djJZ/xfsBCH8DNPe2RCm2qMcIvAkwo+tnv9rQsoB3scpVd6UetNpInuGlAAJM9duFQXwLjfJ6pr2sdcN6oh7+m/DqZKPhXZivIzEISPGLB9pYZq50+Nve1WGlyHTuvUUMrt4gUTzswWoJAKCTvMiWlz3RnTYPqSAkSB7C00msbnw4oRTikLKOV15qIb5Zll8s/dorKp8EdO8XME7PcTZqflfVc6/XuuNDWahaiH2YzZxTgdquHHNQhgkFR6YESeIaAJJ9Rxj5auLdXRBvcSi9uArRnaSYxu66BCag5Nu4MlPi5ToDgAOMaj2KYG+GKhelSRwdVAoZ/bU6DivdA3M7X8+IMHd9B9LRGLm2SnZPl2upphIcLS3W6v0o14K12wxP5e0TAgSXxXZQ+HVHMuQz0Qc2Dkgcj0jDDYdaFnQ9d0/WX0hHz0+9JgabGZr99KB5DAMNS3rtu4UHMhpgLAn+x5CaPasiOvIg73oggW3EZOc6SIBAKeyCGJ1Mua4GwDX61wnUg1SoPgDI0ZNE27TDrxTkj1eVGij6+97GPFdrrWgZfy1xtInNyzoV+oW2CiSd2DKFYFM4hx/9fFG1PHLuv4OxoNiuYoYV8vZua2y7hWARJGwfS7TRteSUTheu//07JBuRHmJKseSN9DYLhDxpWimLUjVidauFEgUd4jp+L/r9/u6xWI14yRoxmdaihc/6HbumNc7UqnE2K/1Q0qS6DdIJOp2qqbnzS7l/MEc2OCyUiJHji5ngBHifVPt/ZEfBYhO4X9f6SzCkJbOAHXYNQM8qsX6uV
 q/F/OoA7
 hoCKnPL4GTcdt+jBK6WLsyPY7Exu+95B/DvPMFpnFTv593Z9EZcEwFo1bXyzXDflIoZW3IB+3DVcxl2QnjpXcMWJpouJh+Ewb5w2DGGwGDs99vAYTtMEast66OFhE8IWaMmR3HMIc2vXppWQ5m2oB7Y4feADGcgfMZ8zSSpmZwtNGCa7Weqn8nhRJ9vWxAvzQwI7mcwo9wt2J55SDQu/mSKPn3yU4hg1xs7VfdvAe4p7O3f7skrCLugozj2KOxj9cnrzQwzmKxSqdgJnRv3swsrZVn6mdXt3KCkUAKoplx47kaMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 26 Aug 2025 11:36:53 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> When creating a new scheme of DAMON_RECLAIM, the calculation
> of 'min_age_region' uses 'aggr_interval' as the divisor, which
> may lead to division-by-zero errors. Fix it by directly returning
> -EINVAL when such a case occurs.

Nice catch, thank you for this patch!

> 
> Fixes: f5a79d7c0c87 ("mm/damon: introduce struct damos_access_pattern")

Let's add Cc: stable@

> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

