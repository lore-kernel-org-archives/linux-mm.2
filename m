Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED28C79FA1
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 00:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E056B008A; Tue,  8 Sep 2026 20:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC7EB6B008C; Tue,  8 Sep 2026 20:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F186B0092; Tue,  8 Sep 2026 20:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4596B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 20:20:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC328A52DC
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:20:22 +0000 (UTC)
X-FDA: 85192317084.14.B2636E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5B44220002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 00:20:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9xr8xsP;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788913221;
	b=sbaE/MxTKCCHAsKinKft2BpmjzyHE06ov43VpdcAkwv9ZVJGVcpVT1Au8pjHj7K1yKZkNJ
	c19PsyY1+2pfUvKiiJUASTmGu81tPN5r2fV8+DazMiFjNsF+4MLTxUzLcum4vwyDRUvkLM
	eOxLfLXbwuZdvZGJblCglW+hN9IbVG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9xr8xsP;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788913221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GnjhAVP/V30TSMfLwyIvSXBQLxYlj9VOI1IVLcD+S/k=;
	b=I5BMQYA8eUyFn+wflrD2+EiFPrwOqA6TVi11QI7q9dKAgglyvmRWGJe4dpgfk/BbKC1uB5
	h1MycuQ9YvfW5dkkRdC3FqW9YBIu3hPc4dZnPIxpF1fp3pXm6Vutx5SfZi1eDjlRMAEv9n
	FKITuX5rODMZDuCH2/3hDh93SdGCI/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C32F41355;
	Wed,  9 Sep 2026 00:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD9C1F00A3A;
	Wed,  9 Sep 2026 00:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788913220;
	bh=GnjhAVP/V30TSMfLwyIvSXBQLxYlj9VOI1IVLcD+S/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9xr8xsPsQajrh7KNO3zQeEHBHiWOotHZ0SrQLVlX2ZYwElLcciKlJZwVz0Tjkvnr
	 d+TRxaTBdCUUQWTQARSgAJPRFD7xNHX+fZz+gvoMyP4urTw/ADH7Sq2s+iqFsaFlBA
	 S5/eWZIBHBJssqlUrv15QhPAS1VVHLGBZG9hjlV3oaJyYNkK/JLcZU7+4oK7SdFpoQ
	 b9wKTHus37Jw4iTqhTW+daFZijKPBRYsnYd9lk3Ajf6L2V4iyt9QC1S1fkLqc0ufPQ
	 5yg04sE+dc931sH6Zyy2MlAlFRqBN3I+t2TPXRrfpF4I2ZySTy9FtZA5xyn4ZmiJHs
	 dKXDsajhL3K0A==
From: SJ Park <sj@kernel.org>
To: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] selftests: damon: add script dir to sys.path for PYTHONSAFEPATH compatibility
Date: Tue,  8 Sep 2026 17:20:11 -0700
Message-ID: <20260909002012.111767-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908214238.2680324-1-eva.kurchatova@virtuozzo.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B44220002
X-Rspam-User: 
X-Stat-Signature: 5o3gmoreepe9yi117n3ckrhf65ejnjro
X-HE-Tag: 1788913221-267051
X-HE-Meta: U2FsdGVkX1//F8SJLa04Xt/ZZhz84MWN5qw9ifYkOkMW8Uf6hjhgdwFkbIKLm0nOVESBAzln0lcvDACyRP7GUagKaR07utqht5M7BB/hEQMGq2mcfKhAW3jrooDYfVBZkzhS0FAX9IJjnw0oV0qxfPkfQxOtlfz4Khs6DzGqshmeq1Kib89bOgFTMGz7YiXG7fdVsX8VDyM87joca6DgTMHXcaKMll2RGiba82QdfIa0fnRP7q8tIQG8QQjEpf7suuRA3cthdf7cTuiQ3eapZg9CkUWy+jl04hs6Vg97fnP39hZ88KIqjQuj7gCXx1wmIf+sQGtYkD/vXD+f73SoHzjv3B6ifE9WlS+SAG2mGBEknEcr+m/ld6d2pMCPUX9Hj50XHhZJDJEqxS2qoe4Fbw4Q2HVe6p8R2WR6h4dfMPrbWC6TpjzCuVxiX4b04uJmuISmMkF4p110i367ly3ctX60HgV16KScZVZZ+39GuWbP6yqclfrlP3sg8H1I1JeeKCw9PmObVDFgqlxj6Tv7igXW5YU/iY+hODI5E2TO1C6ShbBVjsoLhm15Uw9VpFJAY3ZfDXk2RloU6hB8l90o9Os9kQZs+rgGZCokPNvZUkVzI9Tc64v3Du9oJceBszWklfbJEuhdZQ0Tp3IXqPdHvmGAa+ECpe7vV+pX7EMYA9JfoGO2nOMAJdegof9wwUn8MHQF0/JAXyqAkWbLv+XNeeldxzkBXzTcR/YMtp2i5BqKuXgwt5NKRPgQwz6ke+0QsKiH4Ohw8LVpntXQpKilKmD0uqp4tMY18nNsyM0NzrH5hdJMoDEG2ZMXJn1oGPCFySOuUcAtZanuEc79PhtkUwNpjxOtDSx9iObRf2zJNgPkwIwQh6GCKP9M3Z9MoMKZhgsgNXzsZyxldaJE94ElKLs6bjHVAtU3IWrCCNwzIFgA8rOiNCH94ktZpOuW2tCfpWNU/30D89cxdZlwDvK
 AJnydU10
 jdUkpbhSoNgYT953PLVh9oiTflZh/lQkn8pZGevcpKmJC2YkEHy5m9ey4PuIDvquVeKv+Mo6BCtWXvpwmoQ0EKkUGK+K/ZH7/vfBiLkhHmXcnVkqA2olKrsO12I25s9/C6+pckQJUtg/jjLVV34q6w7L2kT9FTmPtD/nfkS8ZG9ZCmgP52vN7YcTl4K2uyuiAeojT4IqPyEN9r6RlBLTH2vjMXHaOykOk7XZEdIHhZhzYxmUuYdoHfm7SEwJGQIGWCfOffMnEn6nh8/J0dIANgTJvOGw3IUR5ZHmQkp0+sSoESbHI3jWRvQDx4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  9 Sep 2026 00:42:35 +0300 Eva Kurchatova <eva.kurchatova@virtuozzo.com> wrote:

> Running these tests under Python's safe path mode, either with -P on the
> interpreter command line or with PYTHONSAFEPATH set in the environment,
> stops the script's own directory being prepended to sys.path. Some
> distributions (RHEL, for example) build the tests with -P in the shebang.
> 
> This breaks all 7 DAMON Python selftests that import the _damon_sysfs
> helper module located in the same directory:
> 
>   ModuleNotFoundError: No module named '_damon_sysfs'
> 
> Fix this by explicitly adding the script's directory to sys.path before
> importing _damon_sysfs, following the same pattern used in commit
> c3b3eb565bd7 ("tools: ynl: add script dir to sys.path") which fixed the
> identical issue for the YNL tools.

Thank you for finding and fixing this, Eva!

> 
> Signed-off-by: Eva Kurchatova <eva.kurchatova@virtuozzo.com>

Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

