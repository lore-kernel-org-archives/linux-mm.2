Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32077606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P58p1Jdp
Received: by kanga.kvack.org (Postfix)
	id 36A286B05B1; Sun,  8 Nov 2026 14:49:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AF56B05B2; Sun,  8 Nov 2026 14:49:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 230B66B05B3; Sun,  8 Nov 2026 14:49:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F231C6B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:49:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 83E2240461
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:49:44 +0000 (UTC)
X-FDA: 85412991888.22.83689D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D17A240002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:49:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P58p1Jdp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794167383;
	b=7CuncQou1OqMm4NoyhlxrJrHnP/ZQccx/AEM6GucUptGtWv7k5mcwQXzwwEvNrvLWdRHsG
	EpLQmeXT48ktOSpHB1JfnhriTSNhDJwCdwxbkaOGA6f1dM3EpukOtPjJbz8nAjstA0prH5
	Sgr8fQaKRDFMY0ZYjFaDGKid6dE6gXM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794167382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2C/GvKXAk+pYFZ4vmrAiRb4WyuL7H3om3GAG5pFiS4=;
	b=Gi1mNG3YugMx2ZEaXbG/sptnaQGTjr9bmS0zqVexuYtiF15Yh9+tcrM35rFefez/11X1AT
	3/8nuL7G0t5oE6UddBbgjHdJkhbL9134UX49Wbq7djBGKrzwIhhxiaX5fF+a3lGGp06ur+
	XJilT1AfTBIlG7y3iN9AhBvDb2mNQ8A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P58p1Jdp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FEE561909;
	Sun,  8 Nov 2026 19:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD83C1F0089F;
	Sun,  8 Nov 2026 19:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794167382;
	bh=n2C/GvKXAk+pYFZ4vmrAiRb4WyuL7H3om3GAG5pFiS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P58p1Jdpmst40sGJSxTlkBW03mhyY57bZXMEomEq9m6JwA17nfaqaD0WlzTT8IPVb
	 33gLkQEBIfk9JSroVmS4GjCMePxSXk2hbYohuaHJmxT+Uy09AMVsxzcDiUQ4FHHTOw
	 hUwVK7QK31hdTL5bIZo0kVqrQ8erbbsuCKAdTuK3kOal5BdQ5bLDwV9bZ10THDJ3Po
	 frW9yPxJW556+oDWKuV8eIDUh9mIUSMsbIvET83aPhLrRsbBZb9Ds6mdCPy1Qq/GtK
	 Kklx0S1K8Rn0TIMugKLJhOdRcKpXoXMVbPqa5dEwTd3m6GMOqloTQg1TeNmASQT6Ry
	 0nm6yNER8AGbQ==
From: SJ Park <sj@kernel.org>
To: sashiko-bot@kernel.org
Cc: SJ Park <sj@kernel.org>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Brendan Higgins" <brendan.higgins@linux.dev>,
	"David Gow" <davidgow@davidgow.net>,
	"Usama Arif" <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH 6.18.y 3/5] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Sun,  8 Nov 2026 11:49:33 -0800
Message-ID: <20261108194935.115238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <sashiko-outbox-203953@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D17A240002
X-Rspamd-Server: rspam12
X-Stat-Signature: fudsm7jy84krmh96ci31j893jghdwcoo
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794167382-944847
X-HE-Meta: U2FsdGVkX1+PoSPli1DdSRe+aGRNgG4wUE05a5ImaiKpY7Syim9elDQkeT1rPtzRcO2BQ2Jrob1tQ+TrlsxkP8ytT2FiRLY/hbRN+loIuvO6afJCltFpPAdDEmZ+fpKDrtsTGD97/X1VYcHDeJChOVK3xHlV13Fmlx6hYCXjZCBNVVnEiGELzYTv49mxRamziVR68R4K0oGTrS29O8MnpO7e+3bYjrD+USBpniQo75Xk+CSCSZzx90vLj3ptBI4sQRrmq1aP9HlzbcocjnEV2nXDkjDLvKddzoXYmBvRVcmsS+eO0fyrvhG5n/1CsQanWqHdzYKIL135cs8fdrJjiM18fr8f+0stV3hRXlAM9IMurQJxFQ4BdHVhGIxaSefFmw8Ry/u10TyKyorYRDktML4CNCsmLP1mRO1IBUBgqlyIerqKqnB8w/qpmWf/pgfribNQmK5mEM4DGLzC3CMUz3GYMDB3scMK34XkLOAip8e0vXcL49RL4Y5uMP8Fwvh4v2BaaAf9GlSkYhiGFMrabQXuCEf7yoCUG6gdbFdNoz1F5vc2AXu9t+pmx0KBK6E2QPZoS2NgzOneE1OuU1Ac/OoGfrxZcG3OKuxHBACtM25pv7LygUF2IX3kDZZ0+S+gYyMpeSf2yljBBTJ3B4lVaLznbxs08naworh6TJCkXWeAvkcVrngZvgXgw1fub7DAYCnzWYF8F/WeDgj8ATwDoIqKwokePtqDEtrjgbWRHKi7vZ1sRHL8ziMDkQjJj4PNruf7TDJAfjxgz3YoZT0mojSCq9HOA5T70O0VHo2maemMFPLIrY1WxMHoWPWoupXKz5HXFmymcWGBXXp08/MarGqIusSGPYlXdRJiu1F4bZdudOYdeyaqm/j4DwmOaubMM2+Qgb9Aj+eXuzOFYUi79XIpFyAnsg18Z/Ll20j26gYU5hCUm7j4gf4d6sk7+BrE+kekI53+5VrhgY8nkVG
 DgjzgrWL
 f17SoTgekCXI+ZxozV4LOg0znyjvkVkg+waC5p8uIGlR9XhNxBbLPuqYmMY+cjMAgajyCO2O3UfcBMZIMQ0Ej7xj9gZ/uT9BwA+dUzZQSKa+XOhozi7JovdW9XxAx783AXEaH/FVickL4fyQvdllvJgmWP8yvvi+XE0SlcnD3geu7RLRb/MyuTxVShPZJCT88VG/tO9eRjAs8+6LZnGNSkpwm5G88xYYEhTcKrcBmHn4BIUPo0Ou9ZLVoAIuG6jftZweL4LAUpNTn7DvTboaS11Ow4zswViEya7bAw1lbg2LC9+4F5/RWriRDsUvpa1xIcBk80GQ5KexigkCxp6+ldm8dkE84+P79QWf8sOwbQtNtJMXl+ILtCHsBfyZ14kqt8V2kXY/yrqmjWHx8/UMBQ3sZCk+IMNu7h1TA1k7u2ZCwekyanyeP5ITVuV6Ez0/SkIIj6vYXp2ISft3XTAfEkbDrD+KWzf0i8Ik7TWcsr1HI6Ns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, 08 Nov 2026 19:30:36 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [High] mm/damon/sysfs: TOCTOU race in damos_sysfs_add_quota_score()
>   [1]
> --
> 
> commit 244e62bfada7cc56b0025da40ea03dad6d9c6420
> Author: SJ Park <sj@kernel.org>
> 
> mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
> 
> This commit copies sysfs_filter->sz_range into filter->sz_range before
> validating it in damon_sysfs_add_scheme_filters() so that a concurrent
> sysfs update cannot pass an unvalidated size range to the core layer.
> 
> Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
> 
> > diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
> > index 37e0a8bef4b1f..0f945ef043709 100644
> > --- a/mm/damon/sysfs-schemes.c
> > +++ b/mm/damon/sysfs-schemes.c
> > @@ -2493,12 +2493,11 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
> >  		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
> >  			filter->target_idx = sysfs_filter->target_idx;
> >  		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
> > -			if (sysfs_filter->sz_range.min >
> > -					sysfs_filter->sz_range.max) {
> > +			filter->sz_range = sysfs_filter->sz_range;
> > +			if (filter->sz_range.min > filter->sz_range.max) {
> >  				damos_destroy_filter(filter);
> >  				return -EINVAL;
> >  			}
> > -			filter->sz_range = sysfs_filter->sz_range;
> >  		}
> >  
> >  		damos_add_filter(scheme, filter);
> 
> [Severity: High]
> This problem wasn't introduced by this patch, but can
> damos_sysfs_add_quota_score() just below hit a similar double-read race on
> sysfs_goal->target_value [1]?
> 
> mm/damon/sysfs-schemes.c:damos_sysfs_add_quota_score() {
> 	...
> 		if (!sysfs_goal->target_value)
> 			continue;
> 
> 		goal = damos_new_quota_goal(sysfs_goal->metric,
> 				sysfs_goal->target_value);
> 	...
> }
> 
> target_value_store() updates sysfs_goal->target_value without holding
> damon_sysfs_lock:
> 
> CPU0                              CPU1
> damos_sysfs_add_quota_score()
>   if (!sysfs_goal->target_value)
>                                   target_value_store()
>                                     kstrtoul(..., &goal->target_value)
>   damos_new_quota_goal(...,
>       sysfs_goal->target_value)
>   ...
> damos_quota_score()
>   mult_frac(...,
>       goal->target_value)  <-- divide-by-zero
> 
> If a concurrent write sets sysfs_goal->target_value to 0 between the check
> and the second read, damos_new_quota_goal() creates a goal with a zero
> target_value, which later causes a divide-by-zero in damos_quota_score().
> sysfs_goal->metric is also read twice in damos_sysfs_add_quota_score(), so
> a concurrent metric_store() between damos_new_quota_goal() and the switch
> can leave goal->nid or goal->current_value uninitialized.

No.  damon_sysfs_valid_start_ctx() [1] avoids the divide-by-zero.

[1] https://lore.kernel.org/all/20260903010722.94244-2-sj@kernel.org/

> 
> [1] https://sashiko.dev/#/bug/linux-7f814c9a-986f-4103-a55a-ef9537dcf62b
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261108192221.114362-1-sj@kernel.org?part=3
> 


Thanks,
SJ

