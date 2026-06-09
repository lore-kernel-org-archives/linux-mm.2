Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07E4ECD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:45:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0D56B0005; Tue,  9 Jun 2026 04:45:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551B46B0088; Tue,  9 Jun 2026 04:45:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467DA6B008A; Tue,  9 Jun 2026 04:45:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4086B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:45:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D73E51C2784
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:45:16 +0000 (UTC)
X-FDA: 84859739832.14.26A783B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2145D18000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:45:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hi/s3Jk0fu83IWGFkY1pD87tmixQ/mAIFgVqk/WtsSI=;
	b=HlaGrQo1MSKuOhK0rCYGEhbC+MBLhu/ql56eS2SddWikTUiBacYpj6DTkDUrhET31et9X5
	7obFNBB52qSZZzFfwQerZUha/DQ26qCxN0qSM28/CqRGwwzJwLkNSteD3JI7r+Yz7ZN6c9
	kHAUu1B5yay9Hess2jhFO1Z4ED7j+xI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994715;
	b=Q7oaPnCd6c5k/MLq+/as1istrPnbqCg947L6XGdsiw1Nb7gAcedAWuQr634BNGPbj/Sid5
	7QMwX/uwMYzj2c9//s+Hu4PT8fiitFIATKHB+IFj9O9Dp1stWdkY5Pvv1WYlFMVUs5gev4
	1vbFTReUWO2up6fS87ircVgCaSRl9BE=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 890DC68B05; Tue,  9 Jun 2026 10:45:11 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:45:11 +0200
From: Christoph Hellwig <hch@lst.de>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
	chrisl@kernel.org, usama.arif@linux.dev, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: [PATCH 7/8] mm/swap: remove SWP_FS_OPS
Message-ID: <20260609084511.GB11917@lst.de>
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-8-hch@lst.de> <aiJc5pPU_kvxs0a7@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiJc5pPU_kvxs0a7@MiWiFi-R3L-srv>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 2145D18000C
X-Rspam-User: 
X-Stat-Signature: aqnxpy8whh3bni9nw1hgkfdus8hj1a5n
X-Rspamd-Server: rspam09
X-HE-Tag: 1780994714-635913
X-HE-Meta: U2FsdGVkX19Kpj4oI/gaulkLI6hUijVzc3NiSqbTWAoYHyzzgCiRhc+WNm9r1uQr0EtZtCq03hkuYGv80btS1Xb3BFgG+HYUkj8y+7epeNh5Ogm/rk3WbyR9DjazSu6GHUooupiGZhG9F5HrlGUPoLLFrdu6ub+vpH7dPruHWPfNIH3TUhwIXnZ/gmQFc1vvnGJE7Q8OC6cmJgKUMgqpZ8Hd4wtHpp9iZjPb31+mAJO/6P1xb62NxCoieeeBxDzY5pXX8wvNK7AVV5Cfmrs2hC/Ed0XgfriQvw1rubWXAjHZrYjwmdsJVBxu8XlEiqNrnclM7wvctDD0vONLFwnD9DkeZ0aAy7QH8cF9comilp35aEUNpigBtL7XgOvyAVQc0UeXjeAPF5C/wuU/ujRCfxGplmGIRJOfPJsZTY6wSQg8g3EkhQ/eF3ohpr4oGJBWM86OfmMNAIQ2Q78uw7clVTuVEI+oBzbXwMUKqswDrfS1A1kS9fgByIRDm8M6etgcCgX1LEJ1Ux6pdm5qtYULRu1b8saALgVahttKMrDEMYLZF7mWUydXAQi7/jD5OVLpxlVsPz4fVMF3OMKQf2Sowp7lnf4YftCulrrn7tNCHgAf3z5jcZHouHhK8qtia/0uoxHEVN4QMpHZRRO8jFSTSitGryF0ajRZHpdJLkrYSpZH4kGBXlBTwawoOSESY6vif0E1I4EuQuuQlTG76T0bTUXKzv3wnzoWGBpfuDnLIVwjcgOVnfSFbDC+uW0I2D05UkhUzO/+83UzGKkT5eNSnN6wZwA5oaBe0RpF3HueGVK7KP9gJ/IwoaMhwJ9BkOFTTrqalEE4FhJuuyjd80MR3o+AqSm5CQuPYQbRnkMr0JeI8E55JdicbGZRN5n9KJsO75ttoL/8NKMbfzbAWPQOyx1dopN020kkAjn4WGhZuRsPlH6gBzpxids6j09+6z21UUtrQNMk9jHLoFRV2Cf
 vzX0LLnk
 aUIyGvu2QyFi3VTcNLwyqui1xI+ajsbD4aREIIYkD6MEJYcj6dfX3ZQcSk/DCtAx/cR+gPZYjTladKuyQwzYN2Bc25jCPNNqguKCMCRhs0y3W1UvO39ryVWvFUmYI5QzEZsJEKjrboAv8Ms7LQ9b+l7euonXCuuMXLYVW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 05, 2026 at 01:21:42PM +0800, Baoquan He wrote:
> + * SWAP_OPS_F_NOFS: swap operations that may recurse into the filesystem
> + * (e.g. NFS, CIFS).  When set, callers (specifically reclaim) must operate
> + * under GFP_NOFS / !__GFP_FS to avoid deadlock.  When clear (block-device
> + * swap), the swap I/O path does not touch the filesystem, so reclaim may
> + * safely enter the filesystem even with only __GFP_IO.
> + *
> + * In may_enter_fs() this appears as a double negative (!SWAP_OPS_F_NOFS)
> + * which reads as "not a nofs swap => may enter fs".  This is intentional:
> + * it is bdev swap (the common case) that allows filesystem re-entry, while
> + * filesystem-based swap explicitly forbids it.
> + */

This is very verbose, but not incorrect.  If everyone is fine with it,
I can add it to the next version.

Or if people think it is clearer. we can add a gfp constraint to the
ops?


