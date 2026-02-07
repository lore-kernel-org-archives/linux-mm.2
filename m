Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DF7EE6B70
	for <linux-mm@archiver.kernel.org>; Sat,  7 Feb 2026 01:21:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ACE36B0089; Fri,  6 Feb 2026 20:21:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45AC16B0092; Fri,  6 Feb 2026 20:21:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CD76B0093; Fri,  6 Feb 2026 20:21:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22BBE6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 20:21:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A615B58842
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:21:26 +0000 (UTC)
X-FDA: 84415907772.28.E09E7D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id F3B1E18000D
	for <linux-mm@kvack.org>; Sat,  7 Feb 2026 01:21:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3vXRIxE;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770427285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8GEbrg48HFKYiLOxBLtBg6uk/Em5MpAZJBGuXsH9mg=;
	b=tnW9CRIUccUVunw0qHKkjIlN94oszge1cRyTHzufnCCJ1mQrOdhOhdu4565bMuD9OsqiSc
	qqnyyPYsqYEII5iWqEKiBzoDqvNZRuW/SpAbKonIDELTUjmyjM5TknsDWBVVltsGzmmvMp
	HIG1aAsonAW0GWGxLfcj1lkf9duT5eg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770427285; a=rsa-sha256;
	cv=none;
	b=yZXB8NTVkYiV/kiSe1lwL8oqcvMpBTExHz626v5r1sprDI8YunN2eCL3d0A5wcy4xtk+D/
	wxjeq59sAwthpCwDUwHGr1JJZengDbgqkCPJ0Xg/dQVtPfJZVEsRikeAN4pPTZujcz405b
	fRNGJZWUq3An/OiCzs+MZOv2lf1Qe6M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3vXRIxE;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BA00C41777;
	Sat,  7 Feb 2026 01:21:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37092C116C6;
	Sat,  7 Feb 2026 01:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770427283;
	bh=3LezWnJCREdR+u+KZoLLda16qsHeRwAq2hqua8icpYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3vXRIxEpK23GyO+mY6d52E5k2taD8BCE+4O3YDNni+k+sBFyuoUMgr8ra5ibrrtJ
	 hGljfUIJbr952NnmS3sxPS6JxBIJrgD3Qfs+QXEhMnJR6OKeHoPsIdffeXQllAPcQh
	 Z0LkIvHBr4ML8gRRlK3wmdqD80khBT06Vw3NXSMKYDw2Z/isd5nMv2oY0VDuV0llm8
	 UfcP6QfT9aED9bwIIyOyDGENI4vkFicmQsvcQh5hkm/DXnLC0L3GFJ2Mq7lfCKd8YX
	 ftnTl9ivxsChN3MWvH9gV6soMaHw+pftMf05/wytW82F6de4FmSQmS/bsmA+y4bU4E
	 +zQlDgdWwyZBQ==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm: zswap: add per-memcg stat for incompressible pages
Date: Fri,  6 Feb 2026 17:21:18 -0800
Message-ID: <20260207012119.69369-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206072220.144008-2-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F3B1E18000D
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: je3mzrociffpxoki15rsditz5qu83dfs
X-HE-Tag: 1770427284-39635
X-HE-Meta: U2FsdGVkX1/q/2XWZ/jbpeQNrm+uDdvsOxtRsSngGETl+eGyv7DmH5RBD4LK+CLQ2XQEemyPDyaA5C/gLqkflCCLJQFIcRHtuDoZA0ffacAEz7Jevbwbtz++RX1VjyCUF8yvQQHZNf0HHg+fcraYzXLU8BBwUIEB4g/XrxkuTCpAfUMc/gbH6mDTCrYfNhcXArRDiXgJrEIEp0MoxhqJC5olzexhHh81cEcGrG4b6R/BOMcgQOc7Ju7y7Qe9iqxdcmYPD4GXBhfyjES6O4P2EbnDbgOFAJEmXedTvSkTJSm+bFqsDBdRjgB4gH/y+TNQOcGiWDadJ/3ni9b9Mk6zVVaIxWITi/hNoZNWYTUfrJ2f3Fk2dM+HMkrVLSa+L7+p4jiqELGW9cPzNLyJXmqhMRZNlXr6aTN2mUYrkg3hRlwrgQqIoxgFIKRmMM+mW3SLOAcoXi9kRonYTxh+hs/pnpooxudd2aVxfC/CzKUu+srPlGV9LxExSYjhTJkDfSDZmKCfC2FOKh8h1BMv/cVSpQyoNvfH6lG3kK77RXn0HH9g9Y/hae/tCZqNeGJRZJ/PKhJf1qVjMDmqmPgt6wVCdgN1cWlDXfuT8438afzHUDvz1CwjCdxJ+7UFNqGcJqWXaG7PgsIaQQR9WnjvEXV3StelNKdvaxEf1u0dATsFUPI9nXx0gTjKIjkEpAtnfXjIWFbyF/ut/Ge+oZyWWbf6hiZ4/rMKSc36Zwi2153JMeymd108iygf3RdDZP9I6Su+oXpP/mDpq8Xst/U7feCBtSr84QBOzF2oX0se/kCtdiU0ZaPq5TYQBtQW2XwnxxBLiDcEWBdA+4lByyABnPFEPukAFa87qhAZmXPGKtkDaSYla5yGp2OGPb19DFspLAtLYGEz2jEeCMuc9AqNU346vkizT64QBCvh1nfSU9xJq5yWHshkzEOuXgSqSZ3cCHsUYh7991FTPxcCJ10Far/
 1hgI4j2R
 MSzsAW4OpZxnHKmwtNMesJQeZw3HaJZWt4vGcx2nlX3GsCYFEb/xZB9vC//pLUcz6TqWiGbhhso/DQ9vG+9egC8y4K3kSuY2yblXCTm8NXsNlw08h2gWEgPlUTmT5ZoUTorBUnkPQYJLDlHdtlMHTDafytX1hbAaYzmkolxHTzy37zcN3wuQuosXQJ+Gy/Jkblx2pxhpyFZ+gnqjG8SRT7nlNppXNdC1EXKHQ8ToFkT5/PzDmpj65zunhq1y0dVVKeE1cCKuAb5aYQIZW2Qws1MlFMYy39YyduQM1zbgW3/eFYSQ1hPE4Yzguag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  6 Feb 2026 15:22:15 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management [1].
> 
> Add a new memcg stat 'zswap_incomp' to track incompressible pages per
> cgroup. This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
> 
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswap_incomp stat provides
> direct visibility into the latter case.

Sounds like a useful new stat, thank you for making this!

> 
> [1]: https://lore.kernel.org/linux-mm/CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com/
> Acked-by: Nhat Pham <nphamcs@gmail.com>

Nit.  It would look better to have one line before tags lines, or use 'Link:'
tag with '# [1]' like trailing comment for the link.

> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

