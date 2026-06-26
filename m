Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F87DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0316B00AE; Fri, 26 Jun 2026 10:54:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91496B00AF; Fri, 26 Jun 2026 10:54:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981CE6B00B0; Fri, 26 Jun 2026 10:54:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 74F136B00AE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:54:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8374C2349
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:54:29 +0000 (UTC)
X-FDA: 84922359858.28.74002DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3A63BC0007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:54:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMBjWOBK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782485668;
	b=aOTvs/votrjZ8ty9XllnkZPIPpRKqYhihNMYZ+aENyZKvP7kDCWlbSRWEMrqwJI58XjhBR
	YvMCMJX56PwDOF+8HzaPeRp6sjrCf2JEcRKWHe8CQuKN/IHNbvfr83v+uO02Y23Jd9gr3U
	3NNupTYA0VQhDY63YJ2a3zci3WCGXK4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782485668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ys5iUrX/oJGm/Bdw8OQUFFBkeX74LvSEyWlQGwdHoSY=;
	b=Ko3fks2QX5TpSY9QGOXwRvTDpZKwk0nKL5xQHAbxO8/9R3v9cNrVawzIYbNpMahWgGkG5i
	IC6gxOcpgV5WB6rzu3BU5Wz/SetFGWG2vtvZomat8jr3Ae6tK//7Z8lmGcvbEkSO4/yP1+
	lCcelSXb2JFFFOO0QaOJzURnr/wuiPs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bMBjWOBK;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55A6340BB6;
	Fri, 26 Jun 2026 14:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDD931F000E9;
	Fri, 26 Jun 2026 14:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782485667;
	bh=Ys5iUrX/oJGm/Bdw8OQUFFBkeX74LvSEyWlQGwdHoSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bMBjWOBKBYrAViDw7U24Nn69r5pzYFtMK1napV2Ak+nBGK1BX/RQEwmNyfnz22oaZ
	 Vc49WPQBUvLHhIH6Fxo/fbdg66jyKx+kPxL0KylrdHUffFZkUOKExhgU8+yhKDWFVS
	 nUF8Ryb1ou1FLRRJifZhgH4wRK526G/8tuHdpYmT/7lCsAyl/OaNjxeTeAPrXXS9tM
	 SpfSECV0tL1+2mSXDE5wZOgIh+92pAOoGiPd14du7JygBaWMg4jlpV03+bvrbRPtd6
	 HMPSkbg+EMuL2hFsiFcerLoI/aQjs2dPOTmbHxw3FohkO7FOWsQm8Z6841otMY7Xsl
	 dvwmEazQxNXuQ==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	jiayuan.chen@shopee.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/damon/tests/core-kunit: test split above max_nr_regions/2
Date: Fri, 26 Jun 2026 07:54:14 -0700
Message-ID: <20260626145415.88225-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260626085851.70754-3-jiayuan.chen@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e4a4xmfnehykpyjixuywkr68fwz3y4br
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A63BC0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782485668-244717
X-HE-Meta: U2FsdGVkX19KfVT2fsPvHZ48MotERFqYLxdFqQVw1GRXKOplBVjBUX9gifWKI3UrwUtb3nz3o5asozQxodfJIC+g0hQnu04BUCVu51sov5WkYukoipXf4FG8iwDY+bWti/EezNNyd32DQOj5qyCl7REXW6taXDqBg+7t8U3Dm+yMEQXxddsJN3jvyVnIjtksPTQYQJNXuS0NsaoIzaOw3hrmz8MyvvFEyVcd0SJfLwuzdJG2gZcoJjjmTwCymFX8oBuogaPO+JqrFVfg7VxeR0ATXDEAocsibw6rkW5+OYPBxNrQ2AOcixNLegDJT+jqpSk+3I9twuEdy/T8umkb4fEL+EBYNHGS0VF8VA2o67ScbVetv8DCf3AKzA4X0tYSnw/QtxC/WTdBnarJ/Ko4Aqg6uvxrAkM9hYAWBgvkprfYWqdkawzNW1wLXTQmIjTDGWbBwUpppzEoJI/XjMMIpqAUekgAAOv9LU73/gLfF2ORKxelD/AQno4OtC+WYPSG0xlciIas6b0f1sNKsJSiu/Mza6WSnBI0SuSbmE9hWu1Uofo85kvMkqCaRKcBdJ6GbuXGMlg+9FBqDTqJRC6F2d7zFBDdbDA8gv5K0LZLftjS84GzTicd5YueWirztmrHA/rJ7N8O8O7vHysKo88GB6u6UuB9+MVUX9awAXceYA6BgJyhj/d2LSBbJc8uTnLzGGpDkSM6nrxQVpu/Pd91rwITfGXzy7Z+7cT5O28vvsb0guhe4Bq8ylCsbiQItcIXB+2sJSohKG4EoWPcXLOQ2yQtMmrpuOfzBe2xom6SVqJVGZS4Nh6M7fkn3zGzbt6U5t3USxSOS+7JGDYzzalj2/qqa9wUO7qe/RXQqLn13IdR2/0t1FGPd6NcrLKhcJq1n66odAqun3kRyA049+Gb7ihu1e+J6pX4XW2sAIvxdUxzXTThsyq0N1LXPEgE5MLCvpvpGO47mD+fXy4VUg/
 1hrLFNiK
 S31T38jxq0sZ5Y1soLkXSmRjzduf5To6frBk4+DSSLPBApJvKSkptZlb0f7VxjV2PJYV06KH+a4XL+/o6pWmJqknkB3bxCwJvUTAk6tts2v+gHuL/5XDDYomzb6Ush9nTPj+KYD/K7AFZ6hqbmjncaSOZqTv1zfxlegBPwn6BPwPO1nGSXiRmxcMutNn6HyJhKcdcZB+ky+fYH0Pqs0jgmXPsLZxsXg+GGGg14WK5kwT/w8CoD5QDcpTDc290PWDR8DeivTv9CHI7BzdNY96enZ68dhSDlj3GCi48UNOTRgnzIWnxeNSpFZhG2gJ1tlbiBA5FwTjcW+6hd1C/7qZVh32uVw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Jun 2026 16:58:38 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> Add a test that exercises kdamond_split_regions() when the total
> region count is already above max_nr_regions / 2, asserting that the
> function still splits a fraction of the regions (makes progress) and
> does not overshoot max_nr_regions.
> 
> The region size and min_region_sz are picked so the split arithmetic
> does not depend on the page size.
> 
> All tests pass:
>   damon: pass:31 fail:0 skip:0 total:31
>   Totals: pass:31 fail:0 skip:0 total:31

Nice!

> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

I have trivial comments below, though.

> ---
>  mm/damon/tests/core-kunit.h | 64 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 29fbe495e532..6fe7abcd670d 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -341,6 +341,69 @@ static void damon_test_split_regions_of(struct kunit *test)
>  	damon_destroy_ctx(c);
>  }
>  
> +/*
> + * When the total region count is already above max_nr_regions / 2,
> + * kdamond_split_regions() must keep refining the resolution by splitting a
> + * fraction of the regions (making progress), without exceeding
> + * max_nr_regions.
> + */
> +static void damon_test_split_above_half_progresses(struct kunit *test)
> +{
> +	struct damon_ctx *c;
> +	struct damon_target *t;
> +	struct damon_region *r;
> +	unsigned long start;
> +	unsigned int nr_before, nr_after, i;
> +	const unsigned int nr_init = 760;
> +	const unsigned long region_sz = 100;
> +
> +	c = damon_new_ctx();
> +	if (!c)
> +		kunit_skip(test, "ctx alloc fail");
> +
> +	/* Keep the split arithmetic independent of the page size */
> +	c->min_region_sz = 1;
> +	c->attrs.min_nr_regions = 10;
> +	c->attrs.max_nr_regions = 1500;
> +
> +	t = damon_new_target();
> +	if (!t) {
> +		damon_destroy_ctx(c);
> +		kunit_skip(test, "target alloc fail");
> +	}
> +
> +	for (i = 0; i < nr_init; i++) {
> +		start = i * region_sz;
> +		r = damon_new_region(start, start + region_sz);
> +		if (!r) {
> +			damon_free_target(t);
> +			damon_destroy_ctx(c);
> +			kunit_skip(test, "region alloc fail");
> +		}
> +		r->nr_accesses = (i & 1) ? 0 : 100;
> +		r->age = 5;
> +		damon_add_region(r, t);
> +	}
> +
> +	damon_add_target(c, t);
> +
> +	nr_before = damon_nr_regions(t);
> +	/* Above max_nr_regions / 2, so the blanket-split path is skipped */
> +	KUNIT_EXPECT_GT(test, (unsigned long)nr_before,
> +			c->attrs.max_nr_regions / 2);

Above KUNIT_EXPECT_GT() feels unnecessary.

> +
> +	kdamond_split_regions(c);
> +
> +	nr_after = damon_nr_regions(t);
> +	/* Still made progress ... */
> +	KUNIT_EXPECT_GT(test, nr_after, nr_before);
> +	/* ... but did not overshoot the configured maximum */
> +	KUNIT_EXPECT_LE(test, (unsigned long)nr_after,
> +			c->attrs.max_nr_regions);

In future, we may do this multiple times.

> +
> +	damon_destroy_ctx(c);
> +}
> +


Thanks,
SJ

[...]

