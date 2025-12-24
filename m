Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3FAE74902
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1228C6B0005; Wed, 24 Dec 2025 00:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CFD46B0088; Wed, 24 Dec 2025 00:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1DC86B008A; Wed, 24 Dec 2025 00:26:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E268C6B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:26:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 768F8BA41E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:26:18 +0000 (UTC)
X-FDA: 84253228836.14.7B7DBC1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id C9794140007
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:26:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcOL2azk;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766553976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L14ottMXfh3PL7h/axcZBGvHy8SFM8xTHCzNkVgEeAk=;
	b=si3x+Ft9tkZOrw8vpTuj1oRz0NfYwiSj037arIQnhUBy6toWXfiuDhK3V+0FM3L4kvVfHm
	omTODNgYGJUBEOc4ATquqhlx4kbM7S4m29mAqtZRNPdO/pX+oWvY55bf8WUm+QcwHYzQ8O
	h6nLWS5pEuelHzhp/1HdaPyQsCe5Erw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dcOL2azk;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766553976; a=rsa-sha256;
	cv=none;
	b=0gCWmwD4dFympadumtcUekaXQLtS2FY9T8GJ2FeTma3vNT8i6RzMkyJS8CrNLLbB/Bq5Ue
	MLQMi4orvGQ1vPW9D7BEuZss6c6Y4R7K0Mf8YAG/asK+eSOIV/YCYvdqTC7fvj8IXCduti
	mFzzDQdv+N907Su+Dr/HUcRNcDnD1Lw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4E424034C;
	Wed, 24 Dec 2025 05:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759AFC4CEFB;
	Wed, 24 Dec 2025 05:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766553975;
	bh=w+yqxVPmNSXi64h9c/SbjrKYVAMQ3Vg9fRqikGkucIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcOL2azkZYxadIUBw3zX8ZlWM8l/iXVQI74TTFk60eFTUwk2LT+yXfrTzhev0j9Ag
	 JmG31EbftpPHFsF7TPoeJOe2Eu+3CvQPdQOyX/uLRjjrQHLAlRfyEY1DmaS9zTY481
	 q/tlBIuGFrVFulWdUpIIvIyBpp9uUvpYnpHNyow4WC7R/H0c/xVv2jdRlwl/QZmTH9
	 XNekgrgtd4E6XomwSbKaP6gAbXzYOOqKlqRSDTXS6hVg0fU4EDLuE/03AqTPQa+4Dm
	 tGlz0ZfWl4OoGhzUhxUZYcYx8Uxl5JzNpEkM5P56doPg7BlbXrmELBZ9f043jJFv2n
	 mLm7L4MPoh8Zg==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/damon/tests/core-kunit: verify the 'age' field in damon_test_split_at()
Date: Tue, 23 Dec 2025 21:26:10 -0800
Message-ID: <20251224052611.81594-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-2-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C9794140007
X-Stat-Signature: p8bujfzrk6dwwmqchx8b6667uykknioc
X-HE-Tag: 1766553976-870357
X-HE-Meta: U2FsdGVkX18PXvql9JOr4+iikm7D9lSI0Nmrq80sF4j1k/9ZrM9IRjLgjwvroT1u2dIVyQDMq2d3UbbQoSUmuJIkCrkD395ZMenECn5X8LukmSF/swBsNGPlUHVaEIhOSxV4+LRsWpluHd2z3gYjfHlLF7VHjD8hU0BKXU+RdR9vMDK9T/uleJ1xTHbyu9JwreyZB3yPlsJQHRAdw5rVF3oI98ciejqVmyydxbRtmuaKhbl9tlK5Qojtx4L8aU03MY0PY5Ag8c+AKlfSKBhdVlvlg7xX9I8zyEwR1Y7Fc8vvY/0fgmEllg7RpKSc8DEG43HbtWRNMJzz43/m+Oq/T2J7gNvPDyNde2nemowF3dJCmi7TJy+AgOX1lT0t6aNukwDmJrC+dT0zOtD1n7Gf2wJTBi/11ZZX60p6Ez97VcblfFl8Wv0izpzyLDVksgYb8YY1FGMb5BSRurppffKr3qAN/2vnmQz49r6YrW76esLAtTKkOcPPrRULnOHTT/MwUumNBy40EcHjxd5hlzM8qzftzoS0FFG5QrqaxtSW17mI1gHgpXfC7pDc5joXDoXKELBDZncUV73AmMUYlS+6FuNDyfEuvhwUxXqnivzh17nK7MPklZgaG12UDIwDB+77edNYURwV0KenBqGDH1kIkeSrmCStX3xGL9U/TAaujXB8BBHcQeQSf+4ua9e9tG1xDeaw8Ozm1352i+NPhT/9x+BMdEUGqkx2XbVvT4R10M7TN15I9imnTcvxJ8Aj+g1XEG5vYc6xwYgMGmqIvOctjyH1EC/P6xVtv8AEoqBaA7h2J5Itl/GCosj8Wh/t0vn+Imr1Ovzx+FQFFAEZOqVn1qW88KO50k2x+3mceI90G5zSgtN8bSo1WsTPgNmWoyFZVhYA0YlLjpeUDWSVcWXPky7YFKC1MvckFibfgX7x1w82sYCcaWqcK194d98KjX8kDf2TxiqO+M+XMpvY4ih
 8Xe2q9hM
 m3oQW/planJE2nvPGY0YGSqzU3MTKpRzqNdj6vB9qiLitlOHncJo/WEKq8PuiN8YsqteR/CKq0V6CF0LUiISKSQfAWnWi9BdFTc67hJp2rKBnWp3oJN60XY0UImdUmB55GlA64OlaM79YVvRCKdLfpppSDhvsLDPbTyGIUhey2IQU2oMTNbcqQOmytt3nlhBUdypRVV5KG5nhGHSA4tf/VqgDwqw5lZ0+akX8WAuoHHdkN3EEUKnZf9Xl0stquxHac0RKlWnvMzMQIK/yyiJdbdRmE4/OFwiEWe4I0o/VM5Vm+cU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:21:56 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Extend damon_test_split_at() to verify the 'age' field.
> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
>  mm/damon/tests/core-kunit.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index f59ae7ee19a0..88ec046f4942 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -158,6 +158,7 @@ static void damon_test_split_at(struct kunit *test)
>  	r->nr_accesses_bp = 420000;
>  	r->nr_accesses = 42;
>  	r->last_nr_accesses = 15;
> +	r->age = 10;
>  	damon_add_region(r, t);
>  	damon_split_region_at(t, r, 25);
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
> @@ -170,6 +171,7 @@ static void damon_test_split_at(struct kunit *test)
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, r_new->nr_accesses_bp);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, r_new->nr_accesses);
>  	KUNIT_EXPECT_EQ(test, r->last_nr_accesses, r_new->last_nr_accesses);
> +	KUNIT_EXPECT_EQ(test, r->age, r_new->age);
>  
>  	damon_free_target(t);
>  }
> -- 
> 2.43.0


Thanks,
SJ

