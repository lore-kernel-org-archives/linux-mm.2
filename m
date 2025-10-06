Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F352ACCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 06:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EE428E000B; Mon,  6 Oct 2025 02:48:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39E848E0002; Mon,  6 Oct 2025 02:48:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4938E000B; Mon,  6 Oct 2025 02:48:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171CA8E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 02:48:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B79F61604BC
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:48:57 +0000 (UTC)
X-FDA: 83966761914.22.68D40F2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id CFD901C000A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 06:48:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759733336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4LdrZ/Ts5Ga6sHozSf8hV4b1Pia2AMnKln9zjgT6AY=;
	b=ezKE0S46gLgRFwsLRZycKshYyypu5WkUk2sOapDUCOjH1kX3Aze0ksR1dgOgKykOdhxRo8
	8J6atORiYT9nQww/hBf0nLQXJ/u3Vib10fL0dofFz3rD6HcICJvsnHt6fFrYgHo0g6ilsh
	jmhJMN7nLz3c4kkujf9Qz5b/r1kWKLU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759733336; a=rsa-sha256;
	cv=none;
	b=INAel0k0kuxkPGsmXQomhWZqrjn7ud/lxi/Xcy2TFWb1a9sABZgpUMnuwEFx5igzTacxyU
	I0VUFlhIzwjfJWkh29SVdmDhe7XLHgg/4lFjEBtJyUEn0CXgR294KZRLYGlv0+mtEnRC70
	UN/OU2bzgD6CeAisWj86mdbEofbKz9o=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0F54E227A8E; Mon,  6 Oct 2025 08:48:49 +0200 (CEST)
Date: Mon, 6 Oct 2025 08:48:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <hailan@yukuai.org.cn>
Cc: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>,
	tj@kernel.org, ming.lei@redhat.com, nilay@linux.ibm.com,
	josef@toxicpanda.com, axboe@kernel.dk, akpm@linux-foundation.org,
	vgoyal@redhat.com, cgroups@vger.kernel.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, yukuai3@huawei.com, yi.zhang@huawei.com,
	yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 08/10] blk-cgroup: remove radix_tree_preload()
Message-ID: <20251006064848.GA10829@lst.de>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com> <20250925081525.700639-9-yukuai1@huaweicloud.com> <20251003073724.GA12933@lst.de> <497b2eb9-a214-4887-ac89-bd2ddff3cb7d@yukuai.org.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <497b2eb9-a214-4887-ac89-bd2ddff3cb7d@yukuai.org.cn>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: CFD901C000A
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 58yg7n68mmg8ik7zmpddf1sgszdfnfjm
X-HE-Tag: 1759733335-121618
X-HE-Meta: U2FsdGVkX1/OtIuClNFYKbaCq6zjp1q7ikEBfLEoywx8vFgyvpZsmrNeL9gGb0b0Rr586uwtWKLn6CnH5yrb4iyateGKAD0K7SxCrv6/x8uQsHVrJYdDWfko9+5v7ag1JnZt4R7tkNsl36p1ypqOnOBs8J7w3OTDqs9j9OaGfNvm4PaUiZUNVEHqozfcQujCIQAWQG5qPGYtI1DQhisFZm8oA6uG602khggG4S4bBwA1hxRNcdMpxZpKDiIxcJOBAi0Q+k0HyPoNsKDBAjThEVKqxG1hYmfahJipsRHtEYY9JffaMU8/LO9apN26QwoOr0Y38hKzAzQXymRZAgQ12lrsFZQk8LE9trAVSVty5nlToXJgl1gTP+wEOjJpveO/wVFM/UjWUrn90j4b4rEvXTEwDtCwlzMgY/UqLNyqj3lEyOiDL/XTpcLsuSDFQGvA8pPeNMjn9ssxeKZoINF+T/83wlGAf33zxu7OvVruLB16zCw6pIyW92UOt9CdeL1TzIEdvuT/mzlzlpGrq1/6bwo7Tr+tgd/+BgZJ2U6lbPsDzNuvNXOOi5C40iBEqqdOOQuiOGIBFSCuw7BUjS6WfH0nYeAEIs9dtmNWD85SSsV2bCFDWDP52s/88KF3V/IaAwJCqwck11r9oKN49IbbgdbXtiraJPhbQ8GokUn1yVOxVrMbggsPRWwwzdrTGQT++cdl8FPwHxmjUcRjx5h4rjjqixA4+Vs25dX8ETvdPp4UFwcZUNopsSIUPfkciHeudnDbh9Ab3nPTTVbDAz7hSPwHSVkJxmAdwVDrK7HLhwtUJphzKsO4YPrYawekwWdmN+x0Y91UArPO5zFZwM+1n1p6M/CsDLzp0jd5WCnFxAWemeyzAtKoy1t9oqvInBpZ+7EPM9emA0aQlf/wxbt6GH8wQ9rJ4bSszy/jllvUYl3216vfn1xslxWKGqepCjV3sqli7LZlEHwDSu21vXD
 GQARAepq
 SrWjeFRxiOFU99qWIfZYz0QX9iiyDYAi7miIV+ntB5TTfxujDqrppDJso5M35bamDe041nR8SMiGRVZ564aEswmOla7zdR0W3t1kHv4C309CoJ36sl39kBFx6EAhuz5gTkJXnIFDu+qSTFVA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 06, 2025 at 09:55:39AM +0800, Yu Kuai wrote:
> Sure, I can do that, perhaps after this set and cleanup blkg_conf_prep apis.

Yes, that sounds sensible.


