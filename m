Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBA6ECA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FA788E0011; Wed, 20 Aug 2025 18:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D19B6B0088; Wed, 20 Aug 2025 18:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5105B8E0011; Wed, 20 Aug 2025 18:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 388276B007B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:23:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D036416018A
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:23:07 +0000 (UTC)
X-FDA: 83798562414.05.60C3C8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3D7E214000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:23:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udK2mbzA;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755728586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4Wt9gFxhyQAvUnobzL0ar5fjob0HKRgeFfA+4buFKY=;
	b=0/pRBQSKzJfYRC3sGloLJEMjDdWJ5YB7E97t+TcqPcNYHOM7nML9YtibZVzDlibqD2s/Pe
	8mBzQ2+bTJOs+0kG+QyNbvwPi3R+Qh1oLCUZvfga8fTIzhzcQhNNst4FwOS5TNWEGy3/Az
	nYepCNQIydlV+U/CnPK81hAHtp9s0os=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755728586; a=rsa-sha256;
	cv=none;
	b=kag+Bm8CKI8s7aZ/qZBBs5Kt/PCqXDp6EKY035wE0+3eIKifP3QM+cH5l5d48aJG9/xUTV
	QOaLggkcxfbLPWsjUYFm7IpoLpHmVcNdZKgyIAGFFRH0L0aZUdLYIQNAz3moXJqDkGNot3
	nGIm9/PhQsCYyzkI423eBseSjD/HvxA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=udK2mbzA;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A25861444;
	Wed, 20 Aug 2025 22:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C15DC4CEED;
	Wed, 20 Aug 2025 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755728585;
	bh=0Hc+hko8FrAVekC8D7wSPp0TYD0KKnzwUrEEEtQlhss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udK2mbzAU+s690sSPA6XyE6lYsAdDFYHRihpYv1DVf0JRR9xVx5w8fsm0tuMskO/E
	 HKA1KLmxnYLKX1h3fLRGekAuL3qGChKObdbmBv3+tGXf3BSwC0grnEuyWVPdEz+6CW
	 YcleCkwqNssHpsbJpyfDKX3E9p/tEtFflJQlkj7mcY6GGVF3D7E5wRHV9f1FBJPVEF
	 /n4/iXFInEnYS8weecgEFBSruLLmYTkCavSgdUcj3pXHbeCSGm5IqZ6BQF+qbcc2Ky
	 XgvgiieJ01HlBslka2sY/OCzDoA3PNE16qxbEM4gQcnG0ntz4q23O8uR5DbgKXw+GF
	 c5zGm1wTdxgpw==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH mm-next v2 00/12] mm/damon: support ARM32 with LPAE
Date: Wed, 20 Aug 2025 15:23:02 -0700
Message-Id: <20250820222302.88000-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3D7E214000B
X-Stat-Signature: 917359nyq3jgz1jgkiyh5rz5uu6edn3z
X-Rspam-User: 
X-HE-Tag: 1755728586-461328
X-HE-Meta: U2FsdGVkX1/CpcvPb4RrvyKfKIYu7m/xFpRGqVpnaIEzxGIQ0C94bgeWuUZs7kCp2CCDChGpfUDJcAqkPQO1pqmkOFO6YufT5eStTWwfyFgICUdQk+H8KFa8DXlVZn/88fBCGZVaG8uVBF3M3ts2UvWwO6kIcn4ul7tUC2TAn0nUIyR9V8EU2CEu5YzrAmWfdmgWg9RV+asHJD+FB5EdzGnGrlevoRwdD6FF1EUD3pwB1gtWUZCZObcUMm4XEHV7HaXx5XmnG78LmsVFuO3GqUkaiKV8xV+oW7b0WpApgRczV5+URTUlmUg7qN4412rG70PiWckOqMnaNGydyqIlC9FUokjlgRTdkkR1+zLkjH32eUji63Dpuwe9AF5mIk200qCcuLhgfXrbEbNtxiwm84JZDt/x1vxjdT397RVVK9z8cgxih9WqGj4Of+r67BPaEbSVnpHeNaalHVbo1UDy8E9pSfLcfMflpJAOjBMxziU/2dppDnvz3yhOK9RGS5wCGLcwaGaIztEifW+HILgpbEp17C+ozCK1JmiQYp+NH9Mx8HbFhsxQtNXfjEQQIMQwaRvEClzKNCS2hLxaCczZNswRTW3cXuNSr9aHcqwCqTZuiYe1dys/D+22VQsPbZVXS0gAdySQnHjfZU5Cg719dfpLJq6OPnxPc32VBkQlouhByHlTwKv4BNxUyfAV8hB30Yay22OCpBhVd8beh+s0I3qJHjGnNRjRnuDtbjkRnKyYMCNaQ9JEHmpXh/F708R4cWn9rQTcPYKIyvhKkxONpyDRH7qYqL8Y4MD+xcgTopuQtEAw9l0nTtBgJ50PwRV48pgx2o7+gEtlDtL+ZJHyzcC2t6/YahSCNgV8s0CSp0xf4Ab986dx7TLG0LdCSmy+a1cIPjDNEjQSMHQhjnkGVmapyI3gSRkbWsHdjqJ/MDfr9NkeyMjeg8BXX3pef8ZthmmqxmDYAopcQpnTE48
 xpxhK4KK
 0gXh0pY1LdfP9MgZGOLLloIzgxanuQVWNycNPnxun7CaPYg9qaQnHno4S9hSIpzX4tUZvCYEapCxbgj5WveJRY1hu7YQL/FSL+NXmT9pzKPPsI2yqujHeIH7g0Ezpx/07OBVF3PZV9V/kR5IIykc5M+cnfyRk5htAuGXLBNS2H+FkMda4iDvDrtdhrcgc60z2Sm1y1waPjpkuNdaATYwbwtGtntgVHQjkUE5atQpxP2AKvKaJeb6FpZYyCgEU/gFE4MtM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 16:06:10 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Previously, DAMON's physical address space monitoring only supported
> memory ranges below 4GB on LPAE-enabled systems. This was due to
> the use of 'unsigned long' in 'struct damon_addr_range', which is
> 32-bit on ARM32 even with LPAE enabled[1].
> 
> To add DAMON support for ARM32 with LPAE enabled, a new core layer
> parameter called 'addr_unit' was introduced[2]. Operations set layer
> can translate a core layer address to the real address by multiplying
> the parameter value to the core layer address. Support of the parameter
> is up to each operations layer implementation, though. For example,
> operations set implementations for virtual address space can simply
> ignore the parameter. Add the support on paddr, which is the DAMON
> operations set implementation for the physical address space, as we have
> a clear use case for that.
> 
> [1]https://lore.kernel.org/all/20250408075553.959388-1-zuoze1@huawei.com/
> [2]https://lore.kernel.org/all/20250416042551.158131-1-sj@kernel.org/
> 
> Changes in v2:

It would be nice if you can also add the link to the previous version, e.g.,
like the revisions history of
https://lore.kernel.org/20250819193404.46680-1-sj@kernel.org

> - set DAMOS_PAGEOUT, DAMOS_LRU_[DE]PRIO, DAMOS_MIGRATE_{HOT,COLD} and
>   DAMOS_STAT stat in core address unit.
> - pass ctx->min_region value to replace the original synchronization.
> - drop the DAMOS stats type changes, keep them as 'unsigned long' type.
> - separate add addr_unit support for DAMON_RECLAIM and LRU_SORT from
>   this patch series.

Thank you for continuing this work!

> 
> Quanmin Yan (2):
>   mm/damon: add damon_ctx->min_region
>   mm/damon/core: prevent unnecessary overflow in
>     damos_set_effective_quota()

I left a few comments.  In essense, let's rename min_region to min_sz_region,
and separate the last fix from this series.

Other than above, looks good overall.  I think you can drop RFC tag from the
next version.


Thanks,
SJ

[...]

