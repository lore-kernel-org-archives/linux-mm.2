Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88648CA101F
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CED718E0006; Wed, 10 Sep 2025 22:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5238E0001; Wed, 10 Sep 2025 22:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C021C8E0006; Wed, 10 Sep 2025 22:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABD668E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:20:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5578D85C05
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:20:11 +0000 (UTC)
X-FDA: 83875364622.17.45BF7EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B9D20100009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:20:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8iv+T9E;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757557209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WFEaNhB4wOCVM7qn3yZJUm+dE1XI2c3iy407jkWJVNg=;
	b=gm/FkyE2pXAWvNeBD2xwmDaXLm2QXAuoe8hUl8GpAjj1kMNaZEElmtTo+unHRJ7V1e3YNJ
	DrWyi9/wpZWku0HKRa7Tj4Yw0vnjmKw5xd8Pq1GVt8e63EcfChOYURw8N8Us07TPDYJfJs
	9xduy/bvkN4dbJ7RvH9wbmk8tZf+7QQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757557209; a=rsa-sha256;
	cv=none;
	b=Y7YvS7tv6ZJ+/x5KkIfAsPaEPn9ud60Ox2ektFyl0EFQgTN+HpsGNOrcc1nvAqqy0V1pl5
	l50zAj/IavnCtHaMk/ujU7ZdzPXhSiui7u9T7MPAP4gB7vQEX6eG0Auwj0VCUoUlXe713p
	L11TryyA/5tDRtOF1I+Q+X3es9rrqp8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H8iv+T9E;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02B4E6013D;
	Thu, 11 Sep 2025 02:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BACDC4CEEB;
	Thu, 11 Sep 2025 02:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757557208;
	bh=gzoQPAa+x4LUkdH2/K+iEEXp8aL1F5QGIdfpEeE8pZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8iv+T9EwQ1WOb70zKJt/vaaA3UhHacDQoOSk300InOCwIAXE7vIfRF+DZAbAO7i5
	 gVDLMyqp5LVcSXVWHf6DHb1QLeW9m8N5tth3K5/j9FaVxqYZptXkIteMUdaqeKBEMh
	 AU35TEwdK1LdXKHC7pG+0SkHc7afKQdFS7xG0fy1IGW6Yet94CBAEgCJO1F/1LyMYh
	 SQKhcTePIbDM0+PIePuWSzEPk4qekuKK+z43Gas5jxq6JeP7BszJfCrmgmpnCDfbZ0
	 nxyt1VB8YPPvmS6i5lJ3Eo5RcEr04D1qFzjrgCq4V62ylZh4y5p3svQPgtw/8Hp4gJ
	 cUe75tmGnS2CA==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH 2/2] mm/damon/reclaim: support addr_unit for DAMON_RECLAIM
Date: Wed, 10 Sep 2025 19:20:05 -0700
Message-Id: <20250911022005.52673-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250910113221.1065764-3-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B9D20100009
X-Stat-Signature: msukogcea4u9fmf6me93bu9rsiunwrt6
X-Rspam-User: 
X-HE-Tag: 1757557209-446101
X-HE-Meta: U2FsdGVkX18wVlr1PAizm5IK1Q/6r++zds7nXYtqVUcbtUWY68oFeVzXbNmEXcjbCUXfrg/DZuRBxbHlwBFKV8c6Z08ynW7ramI28yS7owK2DZeXG5zL7wIUA5T24KgaFnDjSNVMs1+dMY0CODdlZ9Bne56oQRyz+3KJhuqS5vhVtVtHyWU6lCzcf4i3U2DsMO39VFXDBUfm5btuYfblUyXkdsMxdgdmfgcy6jm5mLDYoxDviXTTAsmsHWNPNN8SsdDZiB/xaIXW34mzU8Ux5AUJGHmdiUEmKPwn1F64mxwVwsybv9KOg35A3XYc1zry5qsSRWGU99S2ANB0StU5XqnreJPkxeEvor15Vaug9r7P1eqLV+UYclaGIb82FtbV3MvO2FtgzQ7vOaqs7wYaMu0HTCRse76+UUejxNv9fzxNO1IzDvgD/6orGZxLqZY2jMnkg5dajI+WCBeWs4hb/zqLAqAsCErInQq6NZqYbu4ibrEhbijRTFz2C1Cphe0vj3lOIaob8YVim4oFg+dDTlCiTltVJXmrXX505GPOUQBFT2lHhXh3pINyzCqaBQfJFeZ3bk1kagye7v1oIewe/qdjUeetbcOEeN8OPm0IiIBRtwdZwWNn6jodDme5vZSvLBoUs+Tjk+/QBNbj6cKYj5ketrDqD7A957DxGymo1+PFKfY4YNcnWaI1WRHLcZPUZ2eHTlrQoy8cxOgVkWbHIiRhJML35qkfjec41sBgOWuaKkQfTcCR0itvhgi905Nl2gIVT34RapNFc91k1LT0mVhxUWsmL4Z2lJvmdV9ZUVAwPGMQNDr7imk7X4tr7KqsByZ5S4GuE+wErWQOwRZJgaDlZ38fkFdUDxlkmLmuEVSDKMehVhsNhp4bvhh7JyY+XlfwB5XpbLRNU9SEXY7mdQiT9et8hcLq3udmhy7HGPPaafj/WG0j0HHYLjPtziRdoNaIy0P6aWc/UteV7uy
 alvSuQNL
 hp2FlipnZzNrQZyRVfuwOiVs/2qPeeywxTtiL2XzhGUsiBzdbvZ6XoxhEYs6tTc3YZRAt3ge86qyX5ra/UdpEBLPMjHHocL7Y+lkoN/X1IoGZxkhqD9awNnIbjJvABnSKZK9Wbf+CdBT3IVLqegyRfe/FPgeAz0BEbw0n+whFVwz+BUGJjcMHhDMipOUBLysFMu765WUIHIfIgVRcrgjx6m2Q7m8GdGHMAjhJUuV4D7u35fklIVZB4qTbdv1f54QXU6/UwUVt44+D8Y2XHWLCFgr6st95zL1qu3yi2N6/adcsq5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 19:32:21 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> Implement a sysfs file to expose addr_unit for DAMON_RECLAIM
> users. During parameter application, use the configured
> addr_unit parameter to perform the necessary initialization.
> Similar to the core layer, prevent setting addr_unit to zero.
> 
> It is worth noting that when monitor_region_start and
> monitor_region_end are unset (i.e., 0), their values will
> later be set to biggest_system_ram. At that point, addr_unit
> may not be the default value 1. Although we could divide the
> biggest_system_ram value by addr_unit, changing addr_unit
> without setting monitor_region_start/end should be considered
> a user misoperation. And biggest_system_ram is only within
> the 0~ULONG_MAX range, system can clearly work correctly with
> addr_unit=1. Therefore, if monitor_region_start/end are unset,
> always silently reset addr_unit to 1.

Again, sounds fair to me.  Also this kind of information is helpful at
reviewing.  Thank you Quanmin :)

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

