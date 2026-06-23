Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E246FCDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 19:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 985666B0088; Tue, 23 Jun 2026 15:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95D926B008A; Tue, 23 Jun 2026 15:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84B216B008C; Tue, 23 Jun 2026 15:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDAF6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 15:44:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55B987871
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:44:13 +0000 (UTC)
X-FDA: 84912203586.07.F8B55A7
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 14217C000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:44:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pq1Gvijn;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782243852;
	b=nl5MmpKhCh5S4j7sIZdXmIqZ037ZuZgK8puCXMkB9vbRwYvt1HWSFdtzbGLEx7mJipJ4S+
	5tEXI+R3H6HC68KryoB+XzDWmvIN16TKMPzAMkq9dX2+Pe7PGXgkLULarw9SmGA9fZjMPs
	PNE+gUv2cpEQB68rJZ1KYSM0FFAgABI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782243852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lgm2YIBlwTOJsnhELmj9Lon+JAOK9Kqtj3LT2AgOXNE=;
	b=8iCRMQ+kV6J4mOWOqKq9anIbm5NPz1QloTVW91VMT7pRRsXPS0DwRmw6nV/rnVckuC0mlU
	NzHzoaPvF5zNQVKU7OZ1RnWJj65GlVDYq5dSm+TSKOyjl4PrvfqyMbUCnWsMwwY8r9Epd3
	ZOoi4bmpDdqJST8v1pyLehsVwML6VvI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pq1Gvijn;
	spf=pass (imf22.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.48 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-44104dac6f5so980663fac.0
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:44:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782243851; x=1782848651; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lgm2YIBlwTOJsnhELmj9Lon+JAOK9Kqtj3LT2AgOXNE=;
        b=pq1GvijnhMXP7ArYBU8YX5s1J2JMrA0jEejbQ6vU0KVqhRzHFE9mRYEW/OYBt4UZb7
         SAxaOLvLH9NtgajwAlS8qw8LG0PADeA5Sf0PyrabxK+K2YEtE8aiVMn/xPmoCUc2X43V
         00Le7CYUISnMut6zVrWddHRF78FafOGtdDYifOcFWfEmOUzlDaFPs41FcovkiagMiE6T
         HGvmSOAN/jSTLXM4SaiLgfg5mwmrL3B1eRjJ2FwP1/UH32xJeIa35EPxX5F8BTWeJlkG
         5WIq+uPg2cukOKcV2PxB0wzkYO1G9CPTih4+imuOcTf6lc40LRoeSfadrFMbHAhazbdL
         xSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782243851; x=1782848651;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Lgm2YIBlwTOJsnhELmj9Lon+JAOK9Kqtj3LT2AgOXNE=;
        b=ru5iiOGKh8LR2b+8QfpRC6GXCGIj9i273PH6xk0f/950tA5+5B5bCTVQ1gjKA+IOmQ
         5udqh12TWpdIDjLP0UgD6fI9ar6EfiVVnUWKABiPvxOgDWbJSG2zPZdbXugvHwFVoZ45
         6YhyrHnQLl4+cdE9VIRKXaq8NcsAqETsNwWtU8uAmoe5GuDyNmACh016FzLlvibJejJ3
         ch6FfROmyZl+u6GPwXjPYD6x7Qutvhzonj+rqZAPbaGF+mx7lPeqwDZ+Qaa/CSCv4yBK
         lNLYCMk0WZpWamOz/zaNMZHtMzI7femgGtxedCI3piU2lI/AW8XfW2P461V2hDKWkfzi
         CjHQ==
X-Forwarded-Encrypted: i=1; AFNElJ9RBmwfpvMfZBlbKHfbfsHlNkDotAdotEAj/6YBw+M0VTOIpJqozp4eETNw0Xo404wInsNKTNVkXw==@kvack.org
X-Gm-Message-State: AOJu0YwyuN1Fy3A1AVZIxp/+5OjVJyFXvkfbNGjAvj5RZKtN/g8FXQwg
	hVe3Wtm2V1BY/BVboGUVpUf08I6msM2iPOOmTFlFOadM957iGBwF8Vd2
X-Gm-Gg: AfdE7cltY9p1wPW2SRayNPF1XzSMb9/nlJtjTqC5okvkrtRVZO4S22oYuS2SkjPIJnH
	ErYxxiW0qJmTiC5YsxNTRg95rJHpZT2YsoZo4UE0P+P7V/ySrzpknTmh9ObVVuOs9iPRHyDoVvK
	65FNbYQfh7EoX4XfjDBCX7R5MidyfR54Y9drlTk/in/vIn7WnsliwYZz/HvxOMa4sC6KjBAXJhV
	bpsgaeaaoEWQW1HyVK52yMbcUBIxadbNbatYm3RRzV681j4ukGrG+Bopxvvf1t3VSkuaIkhhb4R
	pp5tNU4HUQmbf0/lMGqVwbAg7nBv8iuKpoBQu5Yqo7q94PIya3UImM1VPs48qRmpyxrKykdOT56
	Sio2tIy/JdoVTPMkT86sWiX4SWYYJVgt0Y1zkKnGA4glOXs/q5M9i4xwJpR7eTmuvTWFgNey/nu
	6pvL6TSivQB0FokdqkHI/x7P0IuOjFlFCDMDlyWfaQDac=
X-Received: by 2002:a05:6808:3a0e:b0:48a:b42c:6f08 with SMTP id 5614622812f47-48ee2f53500mr3588132b6e.10.1782243850984;
        Tue, 23 Jun 2026 12:44:10 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:41::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944007d7fsm9481926a34.2.2026.06.23.12.44.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 12:44:10 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Charles Haithcock <chaithco@redhat.com>
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: Re: [PATCH v2] Respect mempolicy when calculating surplus huge pages.
Date: Tue, 23 Jun 2026 12:44:08 -0700
Message-ID: <20260623194409.2034390-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260623184548.1245488-1-chaithco@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 34fwa8iu89qw9yeyrx3jcd5ghnyx5erw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 14217C000B
X-HE-Tag: 1782243851-705812
X-HE-Meta: U2FsdGVkX19VDJxOyQMoURS+IRrd4iCRWr15IuvDmO9m04UOcBRxo95xMZGouKskRCWWQaJRZ2rE0JREc8hO3Lv1eYqFol8TS7xENHbwI3+J1TtYTVjd43VwlKvr3VRrJ/QVzeQmVt1XekIZhVhl5Rg/iwdqq8blPRJ/ehEAbBcUL6np70SVcE4EaTZE/58OCgItWY7N/VXuaoHUutvj9LxforjsoJg9At0RDSyrN7V5AJSKw0FXbEO4r4ZwauIK8WuKnfaJH5A1WbrTQYYBHZEN80JaC9SQzV2IJtPZWHCc/8jfkuDHidXJpn3p+x2qnbzyRqFkaD0jCAAS4gxBTdbRZ7A6GTvP0zuFlvb52HzqQF9Z8VwldJ7bTxT4HHz+zivamMyMBtjIiIwnXP2PdCJe0jd2kWePhvS73HPt57JpBFvlkFsUMllWnkUyRQkSAv/XFQK9HHY8O/s26RJCF9KJ/gVEIvgc0esCX51HoCp/so1Eqq65EIOBi4ocyZQJzlFLo2NmNXBIFlnSU8ZlY81ATzBtfDGoNHRJjDDxj8gwwpK3EddyN3ZOA6CHyOxYtE132Sy3i2tMWVt39dpdZy2u1e7Q+/ZfpaCMGxrKcx0G+4cINEgV37o8exNgH6r1e3MRNdT/CqNMBiCTVTk4RFvSIMFc1pZDGfQr1cz+yKahV+gJ+tRuHAs7G3EBK4HqAvtnGaNjmQOcwLPWrQv/PF2tZbMT7gn+seR+HMBXr9oCwS+o8XjrnZwqe07xD4Od+mCaBbydAsBytP3Dklqll8FHWAIFG1Fk6q1MVjFbgpMvtxzZ0/2P5UhTa5X2epVC8ZdubAJLwk2X8ooZm6C8N5HfIXcsG1olpjWWF8pFQvVhJLC9fbAlOVzOEmZYLqZKHgrHrUsRhRhgQRAzCrHU7rriy7XkjquxJKkO8ctugYff+nUvg26PRa9I+BG3A9jU5g/Gco7giSGKEVCXOhb
 fULlcB4S
 PqyaxckdkEptbfCIpBSz6aSmhe5cLqqydVAAGTfRvwN2tIai5//xSyLerpiP6VhJVP/E/9GXcefazS9AXgCmQT2CmXrJp5GZzCDioqhv4kUVHd8qYicfyQ557TDVN7eKyFapZzbFIBBeZsFCz8mJbWIooo2LBmZwz3jPbk+GizpRHxpGzlvGrrOhnuazjFiMZcAUhRmDqjauVZb0jmnB4RIbrswwjjZv/jxVvQV5dVuP7UQatkD1Pm926IOwqrSMiMuFYKb6TfdgALg/ZmyHElbun+NqTjO+s/rAnVj3XTshVcQPk4gEC/rivTXqGHOTlEYcW5MBOWrZaKFeaMBS+ObP6WQ+Xl+/jOQVCIEdEm4JbEivDxVQh71KmoyXheUB+K5K6nLgwBWtUI9LTcjz9uV9w8ubce5fwOK0znIy2Q+bcfEq3ZuPPhQ+BqSOSvnaUyjeWfIOuk8dWE1V53ShrV6Y0x0Bkx/BZCozfgMSX+yLidaPIGZKiY9zfq6Zlg68tLPBu5ikkjiycQFz9Kdb6bFtHhVK8khJpx0/2yg/64DMejQdK1tgAcKXSBJkJp1Lpacd4p++MydE8ufNPPXImRPL1/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Presently, when calculating how many huge pages are needed when
> reserving surplus huge pages, the global count of free huge pages
> are used. When reserving with a mempolicy, the global count of free huge
> pages is used even if some/all of those free huge pages are on numa
> nodes outside of the mempolicy.
> 
> Reserving surplus huge pages is ultimately best effort even without a
> mempolicy. Restrictions from cpusets and mempolicies further complicate
> calculating correct numbers of surplus huge pages to reserve and
> maintaining which nodes those reservations belong to (see the comment in
> `hugetlb_acct_memory`).
> 
> However, we can do a little better when reserving surplus huge pages
> with a mempolicy. This patch changes how to calculate the necessary
> amount of surplus huge pages to reserve by considering the max of either
> the amount of free huge pages on nodes in the mempolicy or the global
> amount of free huge pages. We may still attempt to reserve huge pages
> outside the mempolicy, however, we end up being more likely to reserve
> from nodes in the mempolicy.
> 
> Signed-off-by: Charles Haithcock <chaithco@redhat.com>
> ---
> 
> - v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
>   to consider free hugetlb pages in our mempolicy.
> - v2: Folded in Joshua Hahn's recommendation [1] to further modify 
>   `needed` calculation to take the max of either the available hugetlb 
>   pages in the mempolicy or the globally available hugetlb pages. Allows
>   allocations to prioritize nodes in the mempolicy but can still fall
>   back to offnode allocations. Also added selftests to check only for
>   the edgecase which caused this to initially be reported and sanity
>   checks.
> 
> [1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
> 
>  mm/hugetlb.c                                  |  42 +-
>  tools/testing/selftests/mm/Makefile           |   3 +
>  .../selftests/mm/hugetlb_surplus_mempolicy.c  | 472 ++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh     |   1 +
>  4 files changed, 498 insertions(+), 20 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/hugetlb_surplus_mempolicy.c

Hi Charles,

Thanks for following up with a v2! The change to hugetlb.c looks good to
me, I left a small stylistic nit below.

One request I have is that we might separate this commit into two,
one for the mm/hugetlb.c change, and one for the selftests & related
scripts/Makefile change. That way, reviewers can sign off and review
the change separately from the selftests that are being introduced!

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be0..bd97f0f434 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
>  	return NULL;
>  }
>  
> +static unsigned int allowed_mems_nr(struct hstate *h)
> +{
> +	int node;
> +	unsigned int nr = 0;
> +	nodemask_t *mbind_nodemask;
> +	unsigned int *array = h->free_huge_pages_node;
> +	gfp_t gfp_mask = htlb_alloc_mask(h);
> +
> +	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
> +	for_each_node_mask(node, cpuset_current_mems_allowed) {
> +		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
> +			nr += array[node];
> +	}
> +
> +	return nr;
> +}
> +
>  /*
>   * Increase the hugetlb pool such that it can accommodate a reservation
>   * of size 'delta'.
> @@ -2277,7 +2294,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  		alloc_nodemask = cpuset_current_mems_allowed;
>  
>  	lockdep_assert_held(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
> +	needed = max((long) (delta - allowed_mems_nr(h)),
> +		(long) ((h->resv_huge_pages + delta) - h->free_huge_pages));
>  	if (needed <= 0) {
>  		h->resv_huge_pages += delta;
>  		return 0;
> @@ -2311,8 +2329,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  	 * because either resv_huge_pages or free_huge_pages may have changed.
>  	 */
>  	spin_lock_irq(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) -
> -			(h->free_huge_pages + allocated);
> +	needed = max((long) ((delta - allowed_mems_nr(h)) - allocated),
> +			(long) ((h->resv_huge_pages + delta) -
> +				(h->free_huge_pages + allocated)));

What if instead of casting each argument separately, we use
max_t(long, (...), (...)) instead? I think we could make this part look
a bit better : -)

The logic itself looks good to me. And thanks for catching the
+ allocated part, I think I missed that in my original response from v1.

I'll take a look at the selftests in the future, just wanted to get
these comments out first.

Thanks again, I hope you have a great day!
Joshua

>  	if (needed > 0) {
>  		if (alloc_ok)
>  			goto retry;

