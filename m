Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA999C61DFD
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:07:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D32A56B00A4; Wed,  2 Sep 2026 04:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3396B00A5; Wed,  2 Sep 2026 04:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF95D6B00A6; Wed,  2 Sep 2026 04:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C36F6B00A4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:07:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 29D58140790
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:07:57 +0000 (UTC)
X-FDA: 85168093794.02.E8B0687
Received: from mta0.migadu.com (out-15.mta0.migadu.com [91.218.175.15])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6C481100008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:07:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrNbpTiq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788336475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZY8R74Fm39i1k0E48gd0fqduJgs7wRK0yUa+fC7PFIk=;
	b=tSdCMPoA7bAGKY9fhv1S5P5YWhzg9oHqYMPS1L7TwhTljXt8GYGTlan8UkXd3iDV9rcRyx
	ccEDQXiMaFIG4nXHPdq6HsKSkMXOQpWK0Gm0n0PTyvaFFxRDC1eXorOQJP3Yp0nBQc6D6F
	kFh10nWt0d8hqQR94NwXTpL0XOx3/IA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vrNbpTiq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.15 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788336475;
	b=orqkqe/nw2/8YqtXhLWYwZLIknFz0f7b0tClaKSuelL7RHzT1RHczbMNGwm0hDOIvoCHHU
	K0M6TnQiYhPSQErP66rWNP30Wy42Dd110Hup8dPKbXhRriiK9Pa7cYAPzQ4iOkZS/c/iLz
	MsBX6aNVq2KhCXW3OINUdic0PERBkOY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=T/bumzJM3d5jlXTPAtKTEE9Yljf9oHesSte5DKZj6XA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788336469; v=1; x=1788941269;
 b=vrNbpTiqYHdEi98jAkI2TgeQLQVqMKzTwNfgq7qJVKczuFX6G8ADAcVEfbfsSc7ICgsZKjX/
 +IOVKpG8Y4awYJBcD7GpABj4QjnzLmdYCOT6M6IWND5o307obZ2OMcjh2t+mFGsLmBHAzKdozCe
 VadzBYRUhvl4Fc19hELvYgkQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f6d858a2dbb51460;
	Wed, 02 Sep 2026 08:07:39 +0000
X-Mizu-Trace-ID: f6d858a2dbb51460
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 16:07:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH v2 2/2] mm/mglru: make retry logic explicit in
 isolate_folios()
Message-ID: <apfZQE1X6zGAsBb_@fedora>
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-3-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829074204.45304-3-baohua@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6C481100008
X-Stat-Signature: 4xfmr8n3oco3m4ow7ebxjewmh5errba8
X-Rspam-User: 
X-HE-Tag: 1788336473-167623
X-HE-Meta: U2FsdGVkX18n7YdZUqZNkwl7q/EEC3HeeWuXVZ7mKvayxD2XEARCMp8fuKA04N5VXDk4ulw85ihZh+Oj04YRZSxGmDeGRhMNXspTp7oSteMRD6gdJ6NW9A2of9fM2wIm1SUSpUjU58w3//6JS7Yw04CtI0aHAiZPgqLXCiyjJwdgKfEx8ORvLsSGert6RLYRxIH3Q7YPlAkGhr5SXKtudOX64N7k/SY0Ay46n9gVai2FRjWFts1zDeRf9Hc11/utLjeJ5IsonEthcPIyEt+xfL3+q+E6cKjUFvz0z/wpXs80d4xVaVBElmNNQVIx/zlJHnbnRy4qtHWhoNQ/H5CG4YoCxJruTGfm5bfAzO/Fj2LoQFwqGNUpEW4cZRu/1tBmM6htZu80FApw3ZDoUQBqc3AsR9iV336q7czylV84hG+ekf/7k9bEQZMNyCFCfttGYuT+b/LylVRS/URWV/KkSRs581+bQkGbsQel+XN9SNcBNuCH0ivmr0Yj7ohy8Z64r88c1kIsHAlmbFIhwNUODnk+zMU+umVNJPJVcg/+i2YscSMSrtAicVFckgmZRGozemhQMXwIrAlouC3Fz3PLA+RWUYsnZigxnTF7/tzssMv7fgKxYZdc5q7Peu51Khp690UmB/T+Ke2QCibZyMOclSbN06pGOF05nl6LVCYJ2vtRI97lyDD9jjCd9YJph0xjg4WahIQbFJSbePzYYQxWl6LUisGoavhBdYnGT+eIJ4avYqkblCyTMVxe2UuObWlSeo67PGJLuqz317n0qYGwrW4w5PgKlO3CD9XRrOt6K3xObyp/wFq8KNsHilvP86VEEQiqh77BdiKZD24Jqnxbd/4UM7y+ug35k1u1uCSkKyEr9dud/Gf4K+Ru2BtaqWlyJKZR0W/Nq46bUXX664YQgRzCRiByJsVN1fiTsmvVA2Ce9Ncs67HzQwOHWbEdhEeRz6hvNj8jIyIP2HbEeXB
 mGzENEs6
 +605J+g5MdeBZHkoF5a6H0WtMk4oVurJvIcZY2YGefIX0lJQAk4qKbh4L7ZNiExj88a7RHSeiLBL41H70fxiDiB/kCT1Y1AoVWARPbpJPUvC2+bihbnZ2qpduGKgZuEs5cScdO6faPldjDnm4x6WNpqPHVcJWJVemZ9U46yPDRy4ZGlRV6juEMKx5O4icMADeUxFwDo57Q/B9LVK8/dtneHHpwRDS4RagYnbnqGcH8VBwPmsHeVioipFhulghq69FQCyU6FsNr7SewFAr1prZSaQMWspmTr7dHjv4qjgYmqfN9vB9+EDIdQMwy2m5DSJXkeEiO6la6xbDGtZ0L2MIwN7Jh1aFrpEnazFt7XTsFz8j5w4M6SowMAr22fEsO2MTFlJFr8QqDuWlSVM+d09WNemFyqd8eyk1NVML
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 08/29/26 at 03:42pm, Barry Song (Xiaomi) wrote:
> The existing mainline code retries the same type once in a rather
> subtle way. `for_each_evictable_type()` may provide one more iteration,
> allowing the same type to be retried if we scanned some folios but
> failed to isolate any due to protections, promotions, or races. This
> patch makes the retry behavior explicit.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35a233623368..718f59ffc688 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4852,6 +4852,7 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>  	int type = get_type_to_scan(lruvec, swappiness);
>  	int total_scanned = 0, scanned, tier;
> +	bool tried = false;
>  
>  retry:
>  	tier = get_tier_idx(lruvec, type);
> @@ -4871,9 +4872,18 @@ static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  	 */
>  	if (!scanned && type_fallback_allowed) {
>  		type = !type;
> +		tried = true;
>  		type_fallback_allowed = false;
>  		goto retry;
>  	}
> +	/*
> +	 * We scanned some folios but failed to isolate any due to promotions,
> +	 * protections, or races. Retry once to avoid a larger loop.
> +	 */
> +	if (scanned && !tried) {
> +		tried = true;
> +		goto retry;

Seems patch 1 and 2 makes not minor difference than mainline kernel on
behaviour.

1, if swappiness is 0 because no swap, it will run two times if
(scanned != 0). This is not corner case, but usually seen on some
systems w/o swap device. The 2nd no gain run could decrease efficiency.

static int get_swappiness(struct lruvec *lruvec, struct scan_control *sc)
{       
	...                

        if (!sc->may_swap)
                return 0;
	...
}

2, for swappiness (0, 200), the behavious is minor changed.

Mark one scan_folios() result as one of:
      iso     *isolated > 0
      empty   scanned == 0 && !*isolated
      busy    scanned > 0  && !*isolated

mainline:  T(busy) -> T(empty)         -> return   (2 scans, no fallback)
v2:        T(busy) -> T(empty) -> !T(...)        (a 3rd scan_folios())

Maybe we can go like below:

static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
                          struct scan_control *sc, int swappiness,
                          struct list_head *list, int *isolated,
                          int *isolate_type, int *isolate_scanned)
	...

      for (attempt = 0; attempt < 2; attempt++) {
              int scanned = scan_folios(nr_to_scan, lruvec, sc, type,
                                        get_tier_idx(lruvec, type), list, isolated);

              total_scanned += scanned;
              if (*isolated) {
                      *isolate_type = type;
                      *isolate_scanned = scanned;
                      return total_scanned;
              }
              if (attempt)                /* already retried / fell back once */
                      break;
              if (scanned)
                      continue;           /* retry the same type once */
              if (single_type)
                      break;              /* no fallback for 0 / anon-only */
              type = !type;               /* empty: fall back to the other type */
      }

      return total_scanned;
}

This preserves mainline for 1..200 exactly, keeps the intended 0/201
same-type retry, and cannot produce a third scan. Just personal opinion.

> +	}
>  
>  	return total_scanned;
>  }
> -- 
> 2.34.1
> 

