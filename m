Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E29F1CD5BC8
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 22:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CA1A6B0005; Mon, 25 May 2026 18:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953DD6B008A; Mon, 25 May 2026 18:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 843536B008C; Mon, 25 May 2026 18:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EA0B6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 18:57:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A21A31A0219
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:57:15 +0000 (UTC)
X-FDA: 84807454830.19.55B667E
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB2D1A0002
	for <linux-mm@kvack.org>; Mon, 25 May 2026 22:57:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbE68e+u;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779749834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GvAHNAxC6rDU5yUwP8byqCJ4phTBIMQ7rInOdnEr2YA=;
	b=dKotaNUzghOI8hTHsYkxdRr+b3Dlv9PGVUQ0bqKuznxoqYOdWASjFDt/cxXsrQ/tN4CLTn
	kZnkI73WdP8FerjxTBds8A2bwl+846ctTQfwj5xOJvVGWGKRyyntV5G7NGyL+o6kfhKbzp
	2v+A3pYrg6ooZwyGjhqC0aQUhVNihuo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LbE68e+u;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779749834; a=rsa-sha256;
	cv=none;
	b=LJOtda0CCmk2zHHkSfNi59659XtxypTvHVPwCZCr4iDQtcEWQY2eSIlDnUHaAvBWHXxUxh
	YXMbpW72EKiuj7mgmCbQOsrf2cPJ5xEOIMmXfjsl8wSZXG0Jn/2T1kDUJvZ+UZfVKCL5hD
	Trm6JYse4AitMiNpATFa9WffeSbYzzU=
Date: Tue, 26 May 2026 06:57:03 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779749829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GvAHNAxC6rDU5yUwP8byqCJ4phTBIMQ7rInOdnEr2YA=;
	b=LbE68e+uwRgBhWHdTgPTc2kfRUtHSQ7kfDDN5iimq8ExxqmwnnDaC8GhsR1Wo0iimoE1CO
	XcdpFk16wzEkwVI0RHqWjb/g7IxTrlXxapmw24TPeCxMiTZucuHMmxxlNbOU1EDPxTiiPV
	MfP3/sV5DVZwc3MW/yi7xaAeppM2Y3Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-2-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: infxrpq7u8xd3uf11s4a4crpu1nwrbm9
X-Rspamd-Queue-Id: BB2D1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779749833-820659
X-HE-Meta: U2FsdGVkX19xHQeIih9dm8vucF1EzGmY5hC27YgUCDlggbSn8/1pyZeBv7PkYxMQfU4q8uKhAZgQJ94G0rLjJMLui56nk0tB97U5XxZZplgZeqwElWYvbyOmEh8SrewKdFbnqVL7REnUF/cWv5ccw2RO9mLpGkSLLpbln7W/2HLnNt5pGBpDkeqSAN5G5hSzHWlBTTRSsKvwHSsoShkDvOyKZ+3FyrzlK+RNM4JN4yYQaI3S9Wl6z1a839u3w+XqQmGrFyIb/PRGQdfUB8zrbTvZnlHeVlNvI10WuxXz1tT9SzsysfSd/Uy5x9Y7qrEJ5Y7BuVMCJjXtquqV1W280WZr1b6hPmRXZDsa44ozg5RRu/jpJNdOxyU9y2fgxFtnYD/3fxbHlKy0RJVUCKLuRbDpEpeYooh3m2KZe2X5Hwr9w5RuBdd5ngbq3lsjVrHBSiT7Gb2DzUFZAkEvc+N5pON06hA/ReR21XQ4gnLz46Rb/eR7rNsRzEGf54kJAMSM8aZTETY9ncMCEE2sPMahNlWBc7LtwItzkPzvuqIw4uNEtXrLZQF8GTLI4Wg3L6C0HEc9CeqievzUm7p4RwjSfNIIKWBiN21eKwQRdrGJ271mTpV5DSAH4vaXzUIQkZQRZn7/1dW/vCT7UBlcS3DCIKDCYfTVjcBgXx/UhnDlvCZLrXYSR5dQbpl2jyciMmXX9SdBoZbyOejNkClImIG3vQ/GXKCJq0fW5kZSZcsqH8CIJDnrHRi0RL9EJznONzPY8RqS0fXYr5KGDTatGJqSyxywtIFOOkGeV5zXNLCOMMTq0H9l+LsI6yK9DPluHHMf6y7wYkhU6QSrgVbNyeXLfYuzCHIi3n9ySCA43f0o+shLgkCIFTKsceZcPCHP1DpTju0Ydv++OZY0gTadGbB8McKSzau5X76kczFHQoiVBXWXuW5ZCl++eAPJeypTWNs65U5fI1ScowWH68/Du2p
 fSW8UBlL
 CXQF4upJ5DkzzTLB5WGO89oWzKqzAeOuRnjim9r58SN6X3TpFgRFlD7sDrQSQbQqAeQeEQ2futEY0wcCFWWRjOWdP37ZF3RWfwCy3tqdnGmRpeCMPGHy7MuRNfsrwKCVkKMnrr0IqaqidBJ5YR/ITq4L5XUz3ruB5mEafSoVsRUg+8PgmlxhWU3ZODChQdHMuyzgA706fnCqbGyRTt4rgDeL8T/OGp6GUyoEpMu7qj4QVwdE2EoEOqlyJsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
...snip...
> +bool swap_tiers_validate(void)
> +{
> +	struct swap_tier *tier;
> +
> +	/*
> +	 * Initial setting might not cover DEF_SWAP_PRIO.
> +	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
> +	 */

If so, do we need check if the upmost boundary SHRT_MAX is covered?

> +	if (swap_tier_is_active()) {
> +		tier = list_last_entry(&swap_tier_active_list,
> +			struct swap_tier, list);
> +
> +		if (tier->prio != DEF_SWAP_PRIO)
> +			return false;
> +	}
> +
> +	return true;
> +}
...snip...

