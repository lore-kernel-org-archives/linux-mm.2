Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 743F1CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16E48E0026; Mon, 20 Oct 2025 11:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1008E0002; Mon, 20 Oct 2025 11:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68DB8E0026; Mon, 20 Oct 2025 11:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6888E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:07:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 502781401E1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:07:03 +0000 (UTC)
X-FDA: 84018820326.17.FE6607F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id BBA95120002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:07:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPOwehLB;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972821; a=rsa-sha256;
	cv=none;
	b=ewAFYyytMeL4XwExLVzFbNSlpaCIWFIG1hBrvsU+KZ2EPpPmHDTkPG1wdf5NbkB9SxLQHp
	FgMxn1upOrhj8jnIEN+u0Of9mVQzC4E7nLTZBartt8FW4G4+Ew/hlEenFQHe5QPOz5i1W/
	3c9EDtDxaz64IiJfwgibu60N0KSHvas=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NPOwehLB;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsPslgcEKBxpuv5zwLurwPAJQ2++55Eks+Jc0umLUOw=;
	b=QLXXCXyboVfPceZlMN64+0kBVuWrOR0Mjr6khSKot/BAaaBkDSlDqW92Jx0F3qT3Ba2Qeo
	8R87YlWU9AyiMnI1AVycgavw41zRa+CXAa+iQLYB/p5iboY0X1oV1Iba3CF8DjskUYkQU4
	cM5J7pjrWSYtTiyVejFwiVZAAl6xtJI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 488D861FB0;
	Mon, 20 Oct 2025 15:07:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63BCFC4CEF9;
	Mon, 20 Oct 2025 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760972821;
	bh=VkXbnXw/vuCVvpS9dasnvuX64xDMjhUIc9Ev+AKSHzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPOwehLByObcO8jyMl928E2PZUJ+5wmYZZnzHF7xf4EZn86JaSmVPcs6UuAz1sd0Z
	 WUW1oWlxs/yxixr4j+aMNjU9rfFHtlWxcPpGiBP6OFCcsjhsBSxVwsb9GSUWyq7dE3
	 Azu1KpZNz5uwL27U1dHA60JUq9Hzv/25OQ7av08hICgBDacyTVLTABC5YoNiV2PStK
	 15DtZIjlBKzWuJkd1VryrUYi05W/uJpWL/iuisotNI7uTvsm8TPbPhtHIL+3ezxsgh
	 Ezs+HE2EpY9d0k7P3VXjP8mQrl4A+/1TGu9EeCuXLHtc+Wd8lqJ6C2GSvC6lis0PYD
	 GVSRDj3GK80mQ==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH v2 1/2] mm/damon: add a min_sz_region parameter to damon_set_region_biggest_system_ram_default()
Date: Mon, 20 Oct 2025 08:06:58 -0700
Message-ID: <20251020150658.39741-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251020130125.2875164-2-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: chep4e4qqqj1adyi13646gntohuwzdr6
X-Rspamd-Queue-Id: BBA95120002
X-Rspamd-Server: rspam09
X-HE-Tag: 1760972821-815577
X-HE-Meta: U2FsdGVkX1/OSnH63oizuY0kMUgzLolpq+lvEa/CIXqW89cnEnfGJ2vDTd+rPu53QfLZYudmuJrWHf/3YOFsV83Tafk1ZjzvmE3x0QNcVDBOLyPqu9yrhJy4xRb+OfrunTSPMutLP2o2v82ykS7S9MXLVLm6alsLa0XXLQXEGXIJrDSn8dGks3Y4la7v5YHHYK6QNW23C/iYSIflEKVP7GJmxlmgrxzvRE/S0TMrrdT0pg0uaXw0F5MNlml6afWxcDcAGouNKiGJ50vjpjjw4jKBZDoq6/uEM3a6Kmxa/Tx4dsUlqX6/DTDdV/Q+lAq4ZqOKgEFnoAx5ssEPAZMZewx0gQTUPsr9757LoV8zPdGfg/OYne+EzQezPam1h7vNAcjp4RbDDpMdDmVEycm2W7f9KS9nENA0ngiwO5bofu3SojkoTV6xGAn9htVq02sAttafk8Yb1rHqCQOHYMg0ocrJFysIxWH+hdHURbgEFaqCGt0Wyq8NVpN0xcuoGwkykyK53Wnsv/918Ptn4deWld1Jt4bzBo/Vk6wGVhGBt6j05ZpUfo41Dr19J6eJHD50OtvMj3fSgVRBD7Vezo1oLnfGIC9tsdySEamcLxfCPnTsAOvbNRIECIHBjcHS2OEyPPuw51SZH8e+aTbvriNbrdueFtd6iaBAulqb/9sfIt6vYHDSBoShtWPv/LdobBF6BbZNGhFjVVF3NGwqLnKOXwQiwERvKw9NfhTZeGNzAOqFqoBmvVhGHMX/7hbS6eCQDY3y+ERw+gOKAmBNq4vPcEK2WjC6pP8+OuTrU+og5zmro72uhXD3Fmi9pjHyHvJBWpzS1VCrhgaltCS8kg99MLf2xVayi9zMvnK/8KYe0HxFA5QjU14uhLIj7nCmSxvJpSVLMPWyD8GugLnfHvrIP44asSrag3K9PGNcnXvbULASaBv271rROm0b/Qxa1vj4IyLgXULA/HbfDlaX4uL
 PDJXzCUl
 cY1hst0Ffr/n5jzf9LiTubz9VyQWIQAKyh2hkauEHzt1QPWGqH4i14U7B7ie3X/5pXfWduLf6TgJxHJCg8tM/ovkd2HDSu5xBF7O/rnos0zopndqx0AIMpp/w5BGvkG1muCZ4sbHAlXmAupfxZjve94DmZ9IMbyNMuGIra1HnpqmKEsLkXwAqOFuHP4d3S0y2pteIcHu0GNSvC6+jHZKeJ3mNsPiOrzEVplAxpqxLGB1cKs1zPHuqzu0ZPoggC1tg1v6BORNaL2w7DFILO7a7B3gUtcXLaQoqBzdDbK6uNzCGx0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 21:01:24 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> In DAMON_LRU_SORT, damon_set_regions() will apply DAMON_MIN_REGION as
> the core address alignment, and the monitoring target address ranges
> would be aligned on DAMON_MIN_REGION * addr_unit. When users 1) set
> addr_unit to a value larger than 1, and 2) set the monitoring target
> address range as not aligned on DAMON_MIN_REGION * addr_unit, it will
> cause DAMON_LRU_SORT to operate on unexpectedly large physical address
> ranges.
> 
> For example, if the user sets the monitoring target address range to
> [4, 8) and addr_unit as 1024, the aimed monitoring target address range
> is [4 KiB, 8 KiB). Assuming DAMON_MIN_REGION is 4096, so resulting
> target address range will be [0, 4096) in the DAMON core layer address
> system, and [0, 4 MiB) in the physical address space, which is an
> unexpected range.
> 
> To fix the issue, add a min_sz_region parameter to
> damon_set_region_biggest_system_ram_default() and use it when calling
> damon_set_regions(), replacing the direct use of DAMON_MIN_REGION.
> 
> Fixes: 2e0fe9245d6b ("mm/damon/lru_sort: support addr_unit for DAMON_LRU_SORT")
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

