Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5344ACA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAAC39000B4; Wed, 13 Aug 2025 13:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5BC8900088; Wed, 13 Aug 2025 13:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C989D9000B4; Wed, 13 Aug 2025 13:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6CFC900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:08:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32FEE14042C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:08:12 +0000 (UTC)
X-FDA: 83772367224.11.F930D80
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 851F5C0011
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:08:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3X3gxJN;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755104890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KajAc3xxRXbjVbO9JBFGociNxPz6AQVv4ipiRGJtOtk=;
	b=OqPi4BKLz4MSmhjy8T9Q24CXvTTQEDsPbqOoFKxvB7tDpoKOM6ncN92ZjeN+7qyIs6xnct
	k/DKu2Z80k25nQs8jTpEkiyPADluiV+sllXcdPziXaypJnwHuID3V9St28Q40XdU4KsZJg
	d+9KnfiSAvEqF2LAQK4fX+lKjp2Nb4o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b3X3gxJN;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755104890; a=rsa-sha256;
	cv=none;
	b=xS0LWlQLHtvniu2pFgpKUz4nKXzqLX7w+uM6DQL8aPqQxZf+jQKhHzZODOn3ATzN8l5lDy
	hQznnPW3ZJeJTOpL6Hf11xphl94Oo7Vw0kytiWAh9lC3MrDjKjVswpBQDO+0nBdkll9e0X
	6/vdVDNDNVFE6JpVUtqvsuUwgP9j/p8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BE3D45A4B;
	Wed, 13 Aug 2025 17:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010EFC4CEEB;
	Wed, 13 Aug 2025 17:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755104889;
	bh=0wMHb0ikQWLuZKUXgXzxLD9DLMSFgGq3hkc4J3eh53k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b3X3gxJNG1yf8cWJ9B+2UL4wPC0Bh9O4ATYHfByAdIGQxRqHyoL8m2+CDxSFEoLNE
	 WZ51s5OrrvEvCArbvDMfmla1rxY84nGex6V4iQADi8/2Qm5GurLkcA5a3WZ3haK2Ae
	 szYA8tsootOEpcNGBI53NFt/7v5x14tCO/Umca4Mdh4fKw0kmQRC89lCeqnkM1C0yS
	 K8nvF8OqJez2HBYoS0B1gAsNzhUqRL0hdbfTM1jLW1AVwVMH/84MMa4Kb3x9szQvVg
	 V3tkZxAcXGNpw9yWT11s+6yjLIB2eOkaOF55Ixd+0fu6OD9NXHmgmN2Yidgd5kA2Cy
	 CuvQ+Q531b0Yg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 14/16] mm/damon/core: convert sz to byte units when updating state
Date: Wed, 13 Aug 2025 10:08:06 -0700
Message-Id: <20250813170806.6251-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-15-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 851F5C0011
X-Stat-Signature: q1ciowzjtgkj8zq5jrrb1pfehz6wk47o
X-Rspam-User: 
X-HE-Tag: 1755104890-500538
X-HE-Meta: U2FsdGVkX19rZoRKW9YM8jn7P8q+44YYLqmU6+iA6g8zyoJ8oVktfbhwviiTMxTWbB1eE9Hk6HAaPoslDLiotYliuQLtybZ/HurNZhhhwvlK3rGuS8Rfk0098GZRH+7LI5IPY34I2h3bf3o8gSE/G/tCYqAnoaBYmliONI+4HQPipUz+bUF8eQqhvlvRSrkNvU0fhGIaHSaGh0GDUfOuDDM2v6WFHbB8REatEOwm3ef0kvHBdlU7XM0z6YdoSx7dfWghCDibnXJ32K0q59nnulnlIbgJNBkFIq/EGzkH9M5Z587L12/HTp9Jwiwh0qfcGFlQZzAxhht+0kxaS/69nLuWo8NloIIjQJAXdIyuI17il1z8bikTFfvKe3HQZJtcXymTPhqmWzVuS05iwssn0nRlvfXBWhaHQ/J8J5bjYxXUrjBZVFHm2J4v3RiWBwrKlxSLP7+09kMl/ug6wafTdUi6dYpsItjkmlcf0YldZ3CKFgFMtD7nRdLpKPALFSnjC5UvvkGwGfqE2duXojQMlHrreUy53Lewci0GFY5U9ODKLWa+RaxT0wfxL6XakLnf9l/ikAfa2KlEND3ypbVypQyrrU7MBwmr259TWRkqRLBAEmFxMz2BdBjrV6cV6Gk4GHNbsniea2sO6JxSN77aKpmk51qzB7RVkN5VU2YGxTDAzEgjpOJ/8CxKNfdzwqkVifn8INp0lqfNyomCZkAw/zgoS45Lo/XlR4E6jM6UB8VEc4ZO0hauoqcmxmzuJWcOF07X5x9RhAx/gDvKtYjtOUqKO0tjyYe9/aXadyCfWu8ov98LkIgc0y0KcgWCII0F9aVrpRd5+ALVfXNxfOCsh1HRnp6Q/SRGEJB4iGbi/2Od4tepo7R7397x+IkBhHcOOOwkb8sIa4L5AQz3MM5Zc7Bu5PPXfEtrzcr54cFainyMljgUO5ZMUQYU9/EJbzUytl2l11nG1S/K+rJpVqd
 AeANkr/5
 8GEWcgwdJ0fe2RkJmX8t9YLnQkAlxS+zqC7I30kyqiTEg43QzWQJItZo8qL6PHOMezGxeHDhed2e2CwlnlNOuTyn8aeajlex9RLJHeBbCrMvWXh9ffvq/C/KMfP79cv+9Fzs9I7wVDtxfMqu1sUiD0Rjc/Bo7INYrdlloFWXGdZh4itvqM1wGWFvvfVFPJZXsepDFnF0uIVLSJbcBDQL0CN5DHzW9oNTRh6Yiwukr+FKmO0E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:07:04 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> After introducing ctx->addr_unit, the unit of sz might not
> be in bytes. However, sz_applied is returned in bytes after
> processing by paddr.

This is not an intended behavior, but a bug of my code.  Let's update patches
3-6 of this series to return sz_applied as core-layer address unit, instead of
bytes.

> To maintain external consistency, sz
> is converted to byte units when updating the state.

Users could keep the consistency by multiplying the addr_unit, which they set
themselves.

> 
> Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> ---
>  mm/damon/core.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index b162aa1156fc..bc764f9dc5c5 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1889,7 +1889,9 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
>  		r->age = 0;
>  
>  update_stat:
> -	damos_update_stat(s, sz, sz_applied, sz_ops_filter_passed);
> +	damos_update_stat(s,
> +			sz * (c->ops.id == DAMON_OPS_PADDR ? c->addr_unit : 1),
> +			sz_applied, sz_ops_filter_passed);
>  }
>  
>  static void damon_do_apply_schemes(struct damon_ctx *c,
> -- 
> 2.34.1


Thanks,
SJ

