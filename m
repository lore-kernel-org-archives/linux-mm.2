Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5EED6D22A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 837C36B0089; Thu, 18 Dec 2025 09:12:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF0E6B008C; Thu, 18 Dec 2025 09:12:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B366B0092; Thu, 18 Dec 2025 09:12:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F25B6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:12:43 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0EB241401B2
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:12:43 +0000 (UTC)
X-FDA: 84232782606.09.1F90FD7
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id EBC94180012
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:12:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766067158; a=rsa-sha256;
	cv=none;
	b=iYFFkvwEMkxFCvISEQe6XDl9yV0IOSQgx21ByxCElonP2HGLfvNeZ56BgnhNb4cI6lNyIW
	LTsmpnILovQL038D7rsmeeaHwNSKxMYYRb6ZPVubckogWa3SciiT2A0iLVV3BJwc9WFW4f
	FW2f+ggQrIL5rkltI4fSsCVwxYjm+3M=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766067158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i6DxoM833czUJ+KcwhXDggdqNo3J3fgY7SAPKAavnBY=;
	b=qYVbka51DDgV2QaG58pIkqDIY/AZ4ygJzSNW+op9a8pkdp0wVL5oiLDZ3VB6GhrM++rK1U
	tWbbeFt0hgtdPYM3x+as2ykTfc9yQ2wkteXuiDXnG+na7cfrNCgpvTO8EJ8af/Rk6L+el7
	OeCKCnkTh2q2ZCNOTfaxlYTNwQA7n8U=
X-UUID: 95e66188dc1b11f0a38c85956e01ac42-20251218
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:74ad817f-e5e4-4adc-b7fb-aa51c48f489c,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:74ad817f-e5e4-4adc-b7fb-aa51c48f489c,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:9ef8ef8334ebb20d3180378691087ec4,BulkI
	D:251218221231CLVIRIFC,BulkQuantity:0,Recheck:0,SF:17|19|64|66|78|80|81|82
	|83|102|127|841|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:
	nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:
	0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 95e66188dc1b11f0a38c85956e01ac42-20251218
X-User: lienze@kylinos.cn
Received: from [192.168.3.106] [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 936259664; Thu, 18 Dec 2025 22:12:28 +0800
Message-ID: <dad50753-576b-4c4d-a805-2b7d70a46c3d@kylinos.cn>
Date: Thu, 18 Dec 2025 22:12:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/damon: fix typos in comments
To: klourencodev@gmail.com
Cc: linux-mm@kvack.org, SeongJae Park <sj@kernel.org>, damon@lists.linux.dev
References: <20251217224610.8814-1-klourencodev@gmail.com>
Content-Language: en-US
From: Enze Li <lienze@kylinos.cn>
In-Reply-To: <20251217224610.8814-1-klourencodev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EBC94180012
X-Stat-Signature: dzdmfr37e8ms6qe4p7xs9uzxxn8x5qyh
X-HE-Tag: 1766067156-186553
X-HE-Meta: U2FsdGVkX1+eVfyCRQ9qQ9RYjEtvgYby2YZYC8Sgnn4DyBfsqaPw9vAHK4bEHoXYqD8nG1VSmblvwgdjz1BXuaq8+lc7bciI0V1V14PzG8OJ5ObqPuypp+aEcUoG7mkk6MO9LLNHWvaAleIuGAu/MMgGpDn6zkYNxNrDgyqltQDX0l+koSe1NgEZp+F6DC7ymOJ5wDIvj93caLg7/n8EQC2w2b/95xQS2huCOk9/eWr37ZruATw9ZbEaySzrK1AIwknKEdHEBxKGqgF+kpgBVeZfPqQxYfO81wKLZU9sAbSKNRR3WG4mv+Fl9fZ/PN1A9CMypcmsglRzNB5yLNqvJThOXZS0fXOXLoolUA9N2sbmJCD2WXCZpoWu6O+X08jP4sgKs/aciNgrhrvQZqXCl6JswnuxzCpdNNssVwAYcR1CGBCcYRCAbpK4OFuqnvWDBaWIXIQn4wbKOIKiH/Wg5tsRgv0vdmqQFc7PAbwR2oIumU3mDSjD7U/yUooU8KCVVskdWoKWVw6v18jV21/+/nEZhQNjOUDefXslh/6icVdJMJZRe/5HzcIm6DgaUxtgcVcMPJOU+0W+osC2aQHFyjnkgKAdUrmzmKZMsBuZ/FtXulztuRH/9+YUBsu1cqPx/kpeFPVX++G+OX2vUSnl/8Lo0PXUmtd7Vjb/1limijKKs6dce8sREC6sNNQ6+u4uXXj0rHlVtmV8tASOwCnt0G0qhnmxgiPSqrpi8+JhFlWqLZEPYmlKQ5PVWGXJCLNwA0jh+wDnkwGMZ5RTael/JYPClrT0yYyoJg1Wdzby6AYmIKX88671Prs7Zrh6y2j0rG2xvVYWhZqTExDEfUhYdHuRSuHn3TZBnAIL7xk3JCqsHP92FYY3hyl9OB1Ax6XCz/pSEBuJwrMGgQbforRZFvuOwKGJ0gyqk4e6ypqR5S9efCVbOGBTa1CIYhvo3pbSzezq/0M6FguWoDx1kGI
 wphv73Xp
 34i8WY/gFhuSX/631C3c+ddK+4JYowis/BkTlqEg28k/wmTefH/CaQ9R6hZ7z5+VB+3IaHzQvTtMb/HcTjOvl7sdiBdHaIQ8UtlO/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/18 06:46, klourencodev@gmail.com wrote:
> From: Kevin Lourenco <klourencodev@gmail.com>
> 
> Correct minor spelling mistakes in several files under mm/damon.
> No functional changes.
> 
> Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
> Reviewed-by: SeongJae Park <sj@kernel.org>

LGTM.

Reviewed-by: Enze Li <lienze@kylinos.cn>

> ---
>  mm/damon/core.c             | 6 +++---
>  mm/damon/lru_sort.c         | 2 +-
>  mm/damon/reclaim.c          | 2 +-
>  mm/damon/stat.c             | 2 +-
>  mm/damon/tests/core-kunit.h | 2 +-
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 68dd2f7acba2..da4820110e48 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -284,7 +284,7 @@ struct damos_filter *damos_new_filter(enum damos_filter_type type,
>  }
>  
>  /**
> - * damos_filter_for_ops() - Return if the filter is ops-hndled one.
> + * damos_filter_for_ops() - Return if the filter is ops-handled one.
>   * @type:	type of the filter.
>   *
>   * Return: true if the filter of @type needs to be handled by ops layer, false
> @@ -1586,7 +1586,7 @@ static unsigned long damon_get_intervals_adaptation_bp(struct damon_ctx *c)
>  	adaptation_bp = damon_feed_loop_next_input(100000000, score_bp) /
>  		10000;
>  	/*
> -	 * adaptaion_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
> +	 * adaptation_bp ranges from 1 to 20,000.  Avoid too rapid reduction of
>  	 * the intervals by rescaling [1,10,000] to [5000, 10,000].
>  	 */
>  	if (adaptation_bp <= 10000)
> @@ -2756,7 +2756,7 @@ static int kdamond_fn(void *data)
>  				 *
>  				 * Reset ->next_aggregation_sis to avoid that.
>  				 * It will anyway correctly updated after this
> -				 * if caluse.
> +				 * if clause.
>  				 */
>  				ctx->next_aggregation_sis =
>  					next_aggregation_sis;
> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 49b4bc294f4e..9388b091deb7 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -34,7 +34,7 @@ static bool enabled __read_mostly;
>   *
>   * Input parameters that updated while DAMON_LRU_SORT is running are not
>   * applied by default.  Once this parameter is set as ``Y``, DAMON_LRU_SORT
> - * reads values of parametrs except ``enabled`` again.  Once the re-reading is
> + * reads values of parameters except ``enabled`` again.  Once the re-reading is
>   * done, this parameter is set as ``N``.  If invalid parameters are found while
>   * the re-reading, DAMON_LRU_SORT will be disabled.
>   */
> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 36a582e09eae..8463a5a5032f 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -34,7 +34,7 @@ static bool enabled __read_mostly;
>   *
>   * Input parameters that updated while DAMON_RECLAIM is running are not applied
>   * by default.  Once this parameter is set as ``Y``, DAMON_RECLAIM reads values
> - * of parametrs except ``enabled`` again.  Once the re-reading is done, this
> + * of parameters except ``enabled`` again.  Once the re-reading is done, this
>   * parameter is set as ``N``.  If invalid parameters are found while the
>   * re-reading, DAMON_RECLAIM will be disabled.
>   */
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index ef0a1195a584..5e18b164f6d8 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /*
> - * Shows data access monitoring resutls in simple metrics.
> + * Shows data access monitoring results in simple metrics.
>   */
>  
>  #define pr_fmt(fmt) "damon-stat: " fmt
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 8cb369b63e08..f59ae7ee19a0 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -1159,7 +1159,7 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
>  	damos_set_filters_default_reject(&scheme);
>  	/*
>  	 * A core-handled allow-filter is installed.
> -	 * Rejct by default on core layer filtering stage due to the last
> +	 * Reject by default on core layer filtering stage due to the last
>  	 * core-layer-filter's behavior.
>  	 * Allow by default on ops layer filtering stage due to the absence of
>  	 * ops layer filters.


