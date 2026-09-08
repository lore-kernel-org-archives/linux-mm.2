Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D264EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 13:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9C76B008C; Tue,  8 Sep 2026 09:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AD86B0092; Tue,  8 Sep 2026 09:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70476B0095; Tue,  8 Sep 2026 09:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 950C36B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:37:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2479D1C274B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:37:03 +0000 (UTC)
X-FDA: 85190695926.05.7E10294
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9200B180007
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 13:37:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoiCR7zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VoiCR7zd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788874621;
	b=nyL5NHENbXv3nsi5y7P46/qpFkjNNFM6Pm299oOGSAeXK8qnUQG/2Nyv6D9U1AtR8fHHXy
	kjz/Z6yD95gQoLb/sUKmxNxCH6hF1WGErIcqQ1IkYa+c+8Au/SNUVBNDkwBkZDid0T44DJ
	iOVz6QHj1qtNEKNJSVGnJe7D9FQd/5s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788874621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VWuxOAzpawUbawzTS2dIYwJZv+ozSpJF3kgvkYsVzKs=;
	b=IZz5wplwfudT26Lhc9TNKmOJrlHARz8KIn3a0cMGhzTlgyZ58gKjK2qDQFst6sRoThhY6P
	ygdo46r4YevBKv6Dm0S2N8D9GVrjJQeliT6MLYTXKY38wMVRHP4Q8xC95t1XUmvcjv8dWt
	8LtaKtYvZIumK5NSbDOXL+7N8IpBfdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5BB8601F7;
	Tue,  8 Sep 2026 13:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051011F00A3E;
	Tue,  8 Sep 2026 13:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788874620;
	bh=VWuxOAzpawUbawzTS2dIYwJZv+ozSpJF3kgvkYsVzKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoiCR7zdGqLzzWJEnkFL9mN3l2+qnyZNvOFfxM+dy7uWyBiUrGmDv8tOF9cza0Hz8
	 ghueWDZvT9ePkaFqelpaZOUJYG4pGbb0fkNEhyIpEqAyO+ee3hZ2EMCcnz9ylaYKwT
	 JS30KXaN4pO1DmgLst2SEJgbKHrWQ2PpeuQOjZF6/AN20Ge2gWFxqDJEpDwuENhw/d
	 Sv0MtMbEXPJxHqMtvUMwv+Y3XW92chtVWwrRabeN3uOxb01077FfNOReGyKsg0gdF0
	 rxts7SsF9PPUR3EQV9qVEVWdWRZBDQEgbtspIzXuLg+fUuBT3TP280+FlfApwMlOXv
	 MvgWDyceoL6mg==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Tue,  8 Sep 2026 06:36:50 -0700
Message-ID: <20260908133651.96278-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260908063635.2208922-1-kunwu.chan@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9200B180007
X-Stat-Signature: zpjkagc8e1fi7juon4imi1g34f91po4k
X-Rspamd-Server: rspam01
X-HE-Tag: 1788874621-230631
X-HE-Meta: U2FsdGVkX185qbJ4maXacxzrV+pnDFxyjBir+NCxkhp0O42PQ/9/V91ghXAKuLE3FMWDHbqcpLrwJMeLaXOeMEUwv8d6ddNwFqat6oJfxdJXA3ld1bsgbLPfv/VcU7cEQ6PQ7eELqSbZCJC/J2TMQ17iVLXYs6UAiDe1g1cUYW3GkScqmVC4QOUJYqiFxGjxCYbelgmn/buaJ8c1oUiDAHnD38rSFoOhqeZNOphqzZD+ApNPYFhgtO53y7FPaqUZlh7QEU2HkPOe5Xz5iG1BQE0Qp+34gM+cIANKSBjXhAjvbaEkkeCCmNc0keTbN/hUa5T8TFT/I+jcUOXW8Yzk6pBetMfnKeGFW5NA8Cpg8qY9H+zFugR8wrI3AlL3brZHEg+FVHgpNYLpcsRl29zT9QKvY4bLrTjHeRFY0EDjemm5bY9ip4Q1LeYotaMXuUWOdQiFoFnIwnf1zuVcvvGuamVl3eSGqByjcwqcURqtpbdsTtzkAvd6y5KqeFg3S7pGYPepbmEgwXJTsaASg6EEg6CtF0lG9QmPjRvq2Tbyoh6XFS1wZ88leQwDLCIAKW06lx5KBeudr3zd+Gr5b5qF68ySbxop4qngm1+xAAS57Ce6N5As7mBzTNJx6VROoXJtmphwGZYCxYVULnKkPIa8RNIFhSOAPULM1V/uGT1NwCzb4QM7qudnXP3QfTWQZyVwjAvPjJp0hrp0qLEyY69bHg8x/RjfJUA/PvjZiNtQFPVbHsgc+XbtqsdRAXWKpxnIUiFb/OW1xRoOLfzJsgLfnOUPosdI8xvuWCgP9c/ZIwAeKOzFo93IGjEDbdT/hg0uU6U4qnMVQ8lSnuFMX5IpelDs6cYO8/JtXYBwzEoCsvTY+ld9iBy2+4YtoVO5iyDAd4N9qUfBuOeFhqGUU6ivbgGKE9vQu5kZxumTv9f78ri9YyKSrw1RwJIsxVdWVoN57qtpHxFQa+F55w35oOk
 yBAwPZfM
 mvbc84dyBVK1M/VJSH1ajD5cKgHXailBcz42LxvtalfDvbILqFzKcLLunjgsXtFVbcryIwTILLbLt0u1XL0nnTMuOGXss8GNjnWQKKmPh2OFCTVKznSgq6MSWMukGDcHypnu0kkQFsRrlzt7gI7ua0qgkxhDMHW+QfChBVFxGRmpjJ8pEsgWiFy1a/se2rVU/MMhwi320kd5rNc8D2YdlpmpTwHFY3FHIwXwUiD8sb0Xn3WhSN5itRgeOJL373V8AYHv6TC9E9HkRYFCfkTnl+TJa4dP2EAWmc/Tm6YE3gCYy/7BlkSP56k1YXfYhfozxFWu4gNdpguj5GXRzdTrfbbW1b06Pa+Z1iyZc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kunwu,

On Tue,  8 Sep 2026 14:36:35 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> The damon_nr_samples_per_aggr() test sets both intervals to zero,
> which exercises two different fallback paths at once.
> 
> Use separate compound initializers for each case so that each case
> tests one fallback path independently. Also make the overflow case
> use an explicit non-zero sample interval so that it does not depend
> on the zero sample interval fallback.

Thank you for sharing this patch!

> 
> Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index c01e6a75cad..ff23208c181 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -627,12 +627,20 @@ static void damon_test_set_regions(struct kunit *test)
>  
>  static void damon_test_nr_samples_per_aggr(struct kunit *test)
>  {
> -	struct damon_attrs attrs = {
> +	struct damon_attrs attrs;
> +
> +	/* Zero sample interval is treated as one. */
> +	attrs = (struct damon_attrs){
>  		.sample_interval = 0,
> -		.aggr_interval = 0,
> +		.aggr_interval = 5000,
>  	};
> +	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);

Thank you for adding this test case.

>  
> -	/* Zero aggregation interval doesn't cause division by zero */
> +	/* Zero samples per aggregation is treated as one. */
> +	attrs = (struct damon_attrs){
> +		.sample_interval = 5000,
> +		.aggr_interval = 0,
> +	};
>  	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);

But damon_set_attrs() disallows sample intervals that are larger than the
aggregation intervals.  Hence this setup is somewhat unrealistic.  Should we
set sample_interval zero?

>  
>  	/*
> @@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_aggr(struct kunit *test)
>  	 * overflow
>  	 */
>  	if (ULONG_MAX > UINT_MAX) {
> -		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
> +		attrs = (struct damon_attrs){
> +			.sample_interval = 1,
> +			.aggr_interval = (unsigned long)UINT_MAX + 1,
> +		};
>  		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
>  				UINT_MAX);
>  	}
> 
> base-commit: d118502628f8b673be9023db8bdf878f64a7ed45
> -- 
> 2.43.0


Thanks,
SJ

