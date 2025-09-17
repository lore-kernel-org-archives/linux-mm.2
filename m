Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18E19CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715108E007B; Wed, 17 Sep 2025 17:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C5C88E006B; Wed, 17 Sep 2025 17:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DBA78E007B; Wed, 17 Sep 2025 17:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 496AC8E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:29:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A65F1A06AF
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:29:04 +0000 (UTC)
X-FDA: 83900032608.03.B669E9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4D23640009
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:29:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yLg4GU7F;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758144542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yL1+28c8hxyPdAn1dl9AIMBdPmshn+lTPMty6d+G4XU=;
	b=ja6TstQRSIdHH9ZIlJipHJ/eeLFlvK1srjgSW4Quxtk+EVXKcifYx9HmeE5NB6DeUrbVdX
	fED3vv13gPVysiuz60VDwrewCjxA8tVqifwOKKKIfhLtLOky9Sz7L/+gOdEuXEdPHCU7E0
	c8VmYUOS3ScNa9S9TYvwbzlBS6RNGO4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yLg4GU7F;
	spf=pass (imf07.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758144542; a=rsa-sha256;
	cv=none;
	b=Lh3u1uZG5f4QzNydoZkdn3XXzdKlpNUFMGSu+FsNqgY2qv2OZRkbcQrj4hkxgLtHZvTrpJ
	snhTw70smnlvXuqsVCyiSYc283OfA//NK48lTCc6VLUzpMtkqxc5rrT+lWHRHmdvvdKwol
	JhlCb2NaWvXQybMRZ2gLpg35Zcbq52c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BF7644118;
	Wed, 17 Sep 2025 21:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FCCBC4CEE7;
	Wed, 17 Sep 2025 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758144541;
	bh=EobuVCZcornWTzPk32AobToyuSJ570AVb66uPA37Js8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yLg4GU7F7QyOOAObovX6UP+sC3Bq/L2Hbo91QRW6t0ygkshD9EF53mfq9VFVXOWXF
	 4iOJJA3mdi1lMYid/Eofx4moGwOTnqub3vHqNxHLAd/BEhwbgyuHkF2++6tK6oEVE0
	 DE3H4Td7LpCtfz0hUght3wWSsVBorI2LdglCbR20=
Date: Wed, 17 Sep 2025 14:29:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 wangkefeng.wang@huawei.com, zuoze1@huawei.com, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3 11/11] mm/damon: add damon_ctx->min_sz_region
Message-Id: <20250917142900.e2915812cd94d9a2b0da3987@linux-foundation.org>
In-Reply-To: <20250917160041.53187-1-sj@kernel.org>
References: <20250828171242.59810-12-sj@kernel.org>
	<20250917160041.53187-1-sj@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4D23640009
X-Rspamd-Server: rspam05
X-Stat-Signature: jzi94cy8exbey1ykj4oksjkumsnffgsw
X-Rspam-User: 
X-HE-Tag: 1758144542-163938
X-HE-Meta: U2FsdGVkX1/ybqfHT4k2FdYzNYj12hZcn30Zfte/YssJACesu7WB/9L6zxVSubt3hM1bHgSoVcOwMLtMuoY7mp7HQ+29qfUXude4vYPtDIFWw9ysc6rM7HqoRxFlQvgmKgR8t90K8n4v3C0PankLFq/sT0eopqTb3JGWJPjnMpIgbS4KMqtyVF3tE5XqY02s34sDjcloPUXwiAG0kR8N96m3EM3mvh0mg8P0cRO0xSFH5qg+Po+l+d/KAuFihRsIbMzntwW4Dl8w3F1/mnYB4MT0VK25IFv/AbV0CRDxS1HT6zsoNWR7x5H0F/kj65tKFA2i25qUYsiCFshvEa7CDJJJm5rKkh5/KiN3ROajsQrHCgpkjmhpqltXlKvlcPZbLoAo4yFqkeq48iKwbI/LlS+Z87h4De6ofO+Rg/LGEvypcnlH6Th1b6Xatr9IwyaP21it+DddwyR1ifFt0lvH6Njh+l11TeyaeGgPSR96NZ9+SptecmrStNCJUyEuQphmPTbQqFKFnOGy/6cji3KAm9O0wi2172k6Gky6fTN8mw9IyUkwbAOts/6wBdTZn0Fa0EARyzDjUAqAJq9+tulfNgMAe0GoB4jIgB9VkTnVcpCP1kHlBAHfOGi17rzoP9cslhc8l2wkOrk0+iI4U0OqGyNM9YNbjmqizntsb2r5ie0T61+Qg9jnSj6v/aAPUWSZMAE7uZSY/nDV6G/nfEzAivQwtYUt3AjwNz5jA6apZz9RFEzBE/bXXGEEYpolbShPacXyoqKsTCX5+FfsNP4S8oRMq/ZfCO42mnb1iArlbfhZxwk7VCO78mYyGdeKBnm1GcRCogfHBddxi2EE8rUPWDCralWGW/Tui1nUdXJy8YMTCcJKuhUl4ZS9khEQiYbJ8+46kEfo+QctYShDLgRsZX9wrj54qQDAfIIC03WITG7cTaMpeXQZ/NNDqnm3y1MmwPZactAl4ooIv9GbOIW
 L5P4sqMz
 V4zundsTAm2gVptmZpcUvlRfNpgt9FUSWrHHyQDptdnmEShJB1cSQn9LhWuzIwORMOzCI/U4xQ1Bjnn4bA6NU6A7Dk1rA5lliGPewx//j9Xda33u2jBra0njQfDlEGVaFRPnTbnQkfCFIJ6QWhFtBU5LxXoPjdgEcdFBJ+O0uKyUzHWjUKyZCXwGmGKCfnNSktnPxNVCHLe1vtFKBmpMqzJRom8AIqXOZQwrEy/nIR1qSoREMJZgQXSyv6H3srHb4O0xRtHtZr1cVlvYKXzf1VDgpJC/cK70ccar+ULdPiKDvdOs7BJg9194NAgd7vRJrsejNsPq8kglUk6NkRMj9QczrTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Sep 2025 09:00:41 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 28 Aug 2025 10:12:42 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > From: Quanmin Yan <yanquanmin1@huawei.com>
> > 
> > Adopting addr_unit would make DAMON_MINREGION 'addr_unit * 4096'
> > bytes and cause data alignment issues[1].
> > 
> > Add damon_ctx->min_sz_region to change DAMON_MIN_REGION from a global
> > macro value to per-context variable.
> > 
> > [1] https://lore.kernel.org/all/527714dd-0e33-43ab-bbbd-d89670ba79e7@huawei.com
> 
> I think I found an issue of this patch.  Please refer to the attaching patch
> for details.
> 
> This patch is in the mm tree and not yet merged into the mainline.  Andrew,
> could you please add the attached patch as a fixup of this one?

The flawed patch is actually in mm.git's mm-stable branch, which is
supposedly non-rebasing.  So I queued this patch as separate commit, with

Fixes: d8f867fa0825 ("mm/damon: add damon_ctx->min_sz_region")


