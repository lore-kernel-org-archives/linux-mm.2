Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0FAC79F8C
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D362C6B009E; Wed,  9 Sep 2026 05:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06936B009F; Wed,  9 Sep 2026 05:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1CAC6B00A1; Wed,  9 Sep 2026 05:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9396B009E
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:56:42 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6D3F1A0177
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:56:41 +0000 (UTC)
X-FDA: 85193769402.01.7F98509
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf01.hostedemail.com (Postfix) with ESMTP id 230684000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:56:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EZmlpis5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EZmlpis5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947800;
	b=pDdjQQKft21yQ10tK4CNeXb67XBkEfRqln6O4nuT9iYU5gEfp10wJgmXXPWwnxlKIbcqV9
	XJfR4mM+QSgfoVyBQpNOk0KANY/MtyZQayRmKMiIMZ0Vil1JYtP+dNpIebhuKfZBUlHR6S
	7w3tSJn+rh+9mYtwnN3Qrpsx6aTvhbM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBlj7x8sD658i+Z+IGaqtSDqi4AT+nBLY3OAnFyQUPc=;
	b=g9mDRq9JajjaTA3tUaMTmlJpTRT8xt+KRYlpR2cg6JN1fTZTqFfxTaXATB6f6j4j1NBp83
	IZd6/WGL65GVwjjHz5s2dqxXcFsi4ugjmJTp2RmnaLLEYhmYPOPM1Po30oddRGN1GB+fa9
	GpDTmGHAaMeD/DS+IGNa7CDEy760l1M=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccafb751so819113a91.2
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 02:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788947799; x=1789552599; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBlj7x8sD658i+Z+IGaqtSDqi4AT+nBLY3OAnFyQUPc=;
        b=EZmlpis5X8M6vKCHbY2EPCsWYSe7+MW9FN0I+7qWovwKGgsyVVjS/pXKoQn+ojFy2M
         bLT1gqQPyX6NkGu038EXPmgc4xvXIgG9V2lRE/b7HdD6yHOCRwz+FBPLZuF+paGt4xOw
         pFoISD5lf2Qma/ZoRSycuYm8KlWk8L0MGXdPbLxlPPzFbH23JzsmqYShAfrUpzLVweJf
         Cq1irGdN1yt4k2GziN6zvPnTzV6dNtOmIlwk+6rx7sKkZzudpDG3OLBANOtInWgIMx0k
         KJDuykwRC0gyDem6fTStcQP78UllOz0MwHQybB5dTcrgkbvFoMuhLdczlzbyDZzt0Chw
         lBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788947799; x=1789552599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=FBlj7x8sD658i+Z+IGaqtSDqi4AT+nBLY3OAnFyQUPc=;
        b=dKn3s5Tm8PMJBVrjIDk0bjhfWDqnWGOu+Udpy4+5QPFOlpLBo9fyV20+V04haBXABq
         frzRG3nw0QIygOTLy4xBkblaf1aF8eb42PeWz97AwYHvZedpmxKRRQEhF1V8rlQPFwzn
         PLe+COk7+kXpd0eP8Jif0gwY80GvY1mBE8Cjfy62Vmgdnz5Im2arATRFmgeFaGfBqP78
         Hr4FzsiE5d0FIxM0hD5zC0QFuE+/cLHK0a5BvegmR0raC54r9jVs7HFdOtfPZvqHLLmo
         UhZeFSfJIOyGdXWRGjUYrswZ5H2isqurcOK59Uu8eqz1upcV0+ny8Ukmtbt9QMGXwku1
         K7sA==
X-Forwarded-Encrypted: i=1; AKwUvBwRmvbh3tudc82gXDtIJzYs2tBVPl/O6TnRC+zWGHMkwowbrKGSS0nqYLfiYcogPHu+VVqqMVr6ww==@kvack.org
X-Gm-Message-State: AFuF++k+sN0NosU99WE9ksAF4HnZpA07meWYvVQpFzFk0vpSeEsFrbd5
	3izfGObB8bIrdSaLmcFPDSsDdYMb2UJtU/zg3jMfKiPPDLwyn4l20zv7
X-Gm-Gg: AYBFou1ZdzNdO1YepiDPES/I5dTPWVpt8pgG8M+kQ51LR8xow+u0CmkxG171R8J2j+g
	bbpUrGBdvb6IWsC225DNe+6Vm/FW9KxjBozNVUALZLaA6veFAxbZAK30J/z143+XsNZg/9gksDR
	BuaZcqXuttbJbi9HR/3CxSRkEskCciYpzIfdNZg6zaiX0GQiGZIx0abna1PtQiv2wJVYFKLMI5Z
	1OMrrcNjb+pmZ1UXKCoMQUvHVmLSSudFEF74LeJm3AhBuJP8mGfAd/wUVr24vaWTMrSRVqYLUls
	oRiFaIlZJGYOcETJJDuR2KkifnFkXu9zVbBbhB0IDs0O6Xan+9Wgcf1opOt72ysTUVwFxs410UJ
	v8YcLKCSNR4+jiT6BWo4YfZ8BujryvsxMI0wHVnOp5FoGI8vqvcKCZXnyLGiwcHt3AmiF56DzEb
	VAD/lHq7TmCFNgAcEU09HThyMBWk/hmoVyNyiXicoSZCJKuLFHhe4ewuuLv6pr4T1/jeMkbQ==
X-Received: by 2002:a17:90a:d00b:b0:399:221d:63c0 with SMTP id 98e67ed59e1d1-39bac471324mr7523375a91.25.1788947798681;
        Wed, 09 Sep 2026 02:56:38 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b260cd291sm31419062a91.6.2026.09.09.02.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 02:56:38 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: john <love_goo@163.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	akpm@linux-foundation.org,
	liuye@kylinos.cn,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	mgorman@techsingularity.net,
	yang@os.amperecomputing.com,
	zhangqiuhao@huawei.com,
	wangkefeng.wang@huawei.com,
	mawupeng1@huwei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wupeng Ma <mawupeng1@huawei.com>
Subject: Re: [PATCH resend 2/2] mm: vmscan: stop scanning ineligible folios after max_nr_skipped
Date: Wed,  9 Sep 2026 17:56:28 +0800
Message-ID: <20260909095629.2523075-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901084706.3784449-3-love_goo@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 230684000B
X-Stat-Signature: 4n65sc5p741b6kn4kj8479eko8xr85by
X-Rspamd-Server: rspam01
X-HE-Tag: 1788947800-402272
X-HE-Meta: U2FsdGVkX18mNB4ZmXCotfLwpvtT41vgX7j/kn2hKoRzxcu2nWjkeXTh9vw+ryj68TwCPA08g6qAchVPRuI2GfYKUPNT0hDX2djEiCoHdcB0gHsuO1oIIGZoLLvHwryM1y9ZxAVpN8SbXpEP8VVIv1fqVr7QuU9707CMbtdSudN7WAuHNFF2Sju4d6Wze95iU6/mueXQD53SDk8tmuoPHMSwR+rHDSo2Fvz3T9qd2veG6eHhM4+ppJ3tGPpDUKbj2W0KjaWGwPJLZjCQhVsHpTau0hKymLJ4s6JY2DOHTIGlchAQONFL1vLza9Z+aYsyYiro3fff+p/ku6SrBBiTumXR52IvyUtejZtMDppzknEIG5xIlGTl6JEQzXLT61Df4ga7gevgvpwUy/yTy31eWxBuDa4hWyBogqgQvjhjT3AMkgW9hA3Y1nNuNWcJwX1+ODOkAhVY9dGbJ/630PLlcuJe28Qkq9LQ4VS7MrWKuKRxgQEr6wMGKjhH42vzLEWS5/9CAjQJoftFAX6g6jJi1m456ZvAbd5LcHHM+0MRPXGtrc+I79fg1e7kBd8Rx8AV1Y2rSYOJzxVtQNU5BhucTt3pX9IDnf0x5Cf4yjHlwwJrNfHwLK2h6izz6O9zaDtUUe0hgGXk2apfDEEi8Gq7KK/LVHYFM3MmgyQsdT3a4bcCvm9a5K0UkeehWAACjZqUvJ6wwkd7XPctFHzDmy7bU3gUCfocxu1qF+sJ0J1Fwh1dymYWIbiS0eKJv7dMyp2LLwSGTfDOrzW25VdDOnEtGUi7ppnrFMafxSOuJX5b2bOzdznPvYOiEJHVLbDND0CT+KtuVPd1vkyR9h9ajuYtz2TXYcaomsmmF2BbsHVx738xFet1nXCROvMT6bqika10eabdzVHFihc5naRZ7uT+NXl3ybOlXP1a/acIxCYGtuGwagkolBoMtL8HbL7g55UTCehmt47wMNwIbcyR4Wb
 bIcMBI94
 R97v+PkEqGjYmdrOfS8pTZh0EkqNUGb1/sOiDj7EPxUUy2sQoV+69MIBJgoh5Uf5hj29LndIFXmmKxy6vJfkVui/cTkJpXo/RV1+pHO11WRhVSUm1TWmRVtVHVtIc87toHl5IYEMimo8HQXhg8FLNJQ5VAcbMGzQJuXuLWLFFGXGqOkBuzdfnukaBF3ZsnsUi3kTWpTGHkiaVKjho/Givqq/Mb17Q91PNTQhjojPfJ/y23OgUt4ouan/VfeoAmc9lu9iUtmXsMO1pSMvbpKYSb4wIqmXa55qaORrGXJZuGbp3Ft5eGTl3Gsz9EVj7mMBe6rRAAaO7lUw7rnRTdHbqtpydcwz2GPCCgTA4K2uUWfE5DfXj+/jOH8cMNOg1T8pQtKmdBM3RxTbRlT/WgkUvIkjCBKLSQJsmRqB0rnM3Tao1AKWv0o50rLLGNtpJGFqvWxk+4+xkVPMbwbvfdwsWaPJ4TC+eWTNULiFWQChTV8xSPGrAIsluFkDhEkvHUAgPz5Dim6S7Fg43nh8eoEC2l0+lfx2OVhZtFHPU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  1 Sep 2026 16:47:06 +0800 john <love_goo@163.com> wrote:

> From: Wupeng Ma <mawupeng1@huawei.com>
> 
> When reclaiming for a lower zone, isolate_lru_folios() accounts folios
> from higher zones as skipped and, once max_nr_skipped hits
> SWAP_CLUSTER_MAX_SKIPPED, force-isolates the remaining ineligible folios
> to keep the loop from spinning on the skipped ones.  Those folios are
> reclaimed even though they can never satisfy the current allocation, so
> nr_reclaimed is inflated into a false progress that keeps resetting
> no_progress_loops in should_reclaim_retry() and delays the OOM.
> 
> Stop scanning once max_nr_skipped is reached instead of force-isolating
> the ineligible folios.  The skipped folios are already accounted in
> total_scan, so shrink_lruvec() can charge the overshoot against its scan
> budget (see the previous commit) and will not rescan them.
> 
> Fixes: 1c7b17cf0594 ("mm/vmscan: fix hard LOCKUP in function isolate_lru_folios")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>
> ---
>  mm/vmscan.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 823af9e86efd3..375f7cd5aa441 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1701,12 +1701,20 @@ static unsigned long isolate_lru_folios(unsigned long nr_to_scan,
>  		nr_pages = folio_nr_pages(folio);
>  		total_scan += nr_pages;
>  
> -		/* Using max_nr_skipped to prevent hard LOCKUP*/
> -		if (max_nr_skipped < SWAP_CLUSTER_MAX_SKIPPED &&
> -		    (folio_zonenum(folio) > sc->reclaim_idx)) {
> +		/*
> +		 * Using max_nr_skipped to prevent hard LOCKUP.
> +		 * Once the cap is hit, stop rather than force-isolating:
> +		 * reclaiming ineligible folios only inflates nr_reclaimed
> +		 * into a false progress.
> +		 */
> +		if (folio_zonenum(folio) > sc->reclaim_idx) {
>  			nr_skipped[folio_zonenum(folio)] += nr_pages;
> -			move_to = &folios_skipped;
>  			max_nr_skipped++;
> +			if (max_nr_skipped >= SWAP_CLUSTER_MAX_SKIPPED) {
> +				list_move(&folio->lru, &folios_skipped);
> +				break;

One question about stopping the scan once max_nr_skipped reaches 
SWAP_CLUSTER_MAX_SKIPPED.

Previously, reaching this limit caused the remaining ineligible folios 
to be force-isolated so that the scanner would not keep looping on skipped 
folios. With this change, we break out of isolate_lru_folios() instead.

Could this cause us to stop before reaching eligible folios later in the LRU? 
Is SWAP_CLUSTER_MAX_SKIPPED intended to be sufficient to determine that 
continuing the scan cannot make useful reclaim progress?

Thanks,
KunWu

> +			}
> +			move_to = &folios_skipped;
>  			goto move;
>  		}
>  
> -- 
> 2.53.0
> 
> 

Sent using hkml (https://github.com/sjp38/hackermail)

