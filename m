Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58790CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 11:10:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6C1D8E0043; Mon,  1 Sep 2025 07:10:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B434A8E003B; Mon,  1 Sep 2025 07:10:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8E38E0043; Mon,  1 Sep 2025 07:10:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B3428E003B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:10:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C4DB1DEA72
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:10:20 +0000 (UTC)
X-FDA: 83840412600.13.64CB261
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id B9E82120010
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 11:10:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VjFiCT0w;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756725019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+5CubNWcmQ4tKQGllscaqN5xA93y5xyzPP40mFbmOA=;
	b=NCJ2jKnI1mkwWyI+askqR8IWleSkr5NG5MF2kq7A4zTXWp63NG/iTalOgFplrlHbVaQt4p
	/t2F2Z8Eq9eOj9yxQuE14Tbg0ZaUR8k8mBQrgHQDkzf0Ll/vgr+MhNsxNcap/8GMpCZnc7
	Ppp8BKGDlk8nrT4IeqK1Gt/u2k2F+qY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VjFiCT0w;
	spf=pass (imf29.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756725019; a=rsa-sha256;
	cv=none;
	b=GB290xJ+3X8s3Bh2vCmD7omxifqfxbRWSsvQPkaFLo2sCemVkdyLFM3t7Kk7JqKS2NH4+I
	bBIsqpG7kYS52N+zKaqgJ6m0W/yy2ppV2QNnARj2u+yuDzt1bdiE1s6sYRFBli3kqT1qpl
	S7u2tUMMiQbygnOf3r8RzE7fImHJIYU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1756725014; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=2+5CubNWcmQ4tKQGllscaqN5xA93y5xyzPP40mFbmOA=;
	b=VjFiCT0wRGHaMapK+RWlhrJWrvzjRGgI8ro+POy5PYwm19Wy2Lnq319CnmCNpltk8k4ED/++6JM31hT5hNd3rIiGByfIAZUCSGtzHfFGQtLXs/R7yFx/xs7RqVOUokYFNTwtgnqCjm+tRQfFWQSKUc4/hTRZHU9WMUC9+hf+Mpg=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wn23mIs_1756724995 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Sep 2025 19:10:12 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Ruan Shiyang <ruansy.fnst@fujitsu.com>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  lkp@intel.com,
  akpm@linux-foundation.org,  y-goto@fujitsu.com,  mingo@redhat.com,
  peterz@infradead.org,  juri.lelli@redhat.com,
  vincent.guittot@linaro.org,  dietmar.eggemann@arm.com,
  rostedt@goodmis.org,  mgorman@suse.de,  vschneid@redhat.com,  Li Zhijian
 <lizhijian@fujitsu.com>,  Vlastimil Babka <vbabka@suse.cz>,  Ben Segall
 <bsegall@google.com>,  stable@vger.kernel.org
Subject: Re: [PATCH v3] mm: memory-tiering: fix PGPROMOTE_CANDIDATE counting
In-Reply-To: <20250901090122.124262-1-ruansy.fnst@fujitsu.com> (Ruan Shiyang's
	message of "Mon, 1 Sep 2025 17:01:22 +0800")
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
	<20250901090122.124262-1-ruansy.fnst@fujitsu.com>
Date: Mon, 01 Sep 2025 19:09:55 +0800
Message-ID: <878qiya0os.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B9E82120010
X-Stat-Signature: ano1cchrckwt4oqsqqkpaahc7yshnqtp
X-Rspam-User: 
X-HE-Tag: 1756725017-842687
X-HE-Meta: U2FsdGVkX18e+/6Y3rRQI6hn1XF7u91kw6geBrno7PCDutrs31JGGnbo/vEgIwq58na/3bOOhVX7lVeRBSEBEd6sl7weuS2W6X/uxcR7UEUoM/H+RpYA96OdpxjvFfUZ76BGHqzAJbjkM7utTuSrxGT4KHAby5AzKTspipclMyuCuJIJ8hvS7/5NpieZp0oaA6BMb5dxw2g5Uki2oZmvwXO91cgLIwbINTIicB/cKDh7YiaAP09n917YxxdPkAB3aXZjCJl5E3YpcX/ePu4Gwd6I4dh4gYisjmXIWfPcjuBxwR5pEhmHpwGSj5V79pVfdKXzSggXfD28cLplvGkzSY4Nx0e5mpNEjAAogx7Cz9i8xf4lcI0BFNGo7YHWcAuEScqJTIeczsmjqAdHWx9OrHhnJzR7yOJBkELHEby/4RL+zvcok5G7sCA9xkLdSduIMV/gWOcZPsloq+IbK5SevaillIUl7lRmpf6fP56ZKTIthudxAP/YL0aDLAT13GHgYF3lGgsIloHQy4QPA8LO6yaaj6ofCfBy7so+PqOrtfylwCEOhmKSOrOzluyPGL7vurXTFIx3C04UmiokafpSG6Wm9DUH19vpKk+4p1arQQO8n0JblRGqVjD3n+8AWuTC/g1sIUIqxtzTapBxo96L4IYJ/hQJwPUZn4OZvuwuAzUWayCvqDR6sMU4Af+hDrAg+wrMMoWitI0bfTc817iQI2B/CG99fpVTLFUNoFhFSq7fLZcDfcsFQCr6Z9qA6+F78gj6JwkfObVVdqaWBIWzyOsPgY87SHxrvBM+GrfOYeBKlTBcr6+tnIhmWFIjuQ92asRbnLG7hikzSBsJ2hk0k/x5oyHUdkDgBY3DGG5Px1Wjl3iSXNPHq0hPDSt6I/RZio+xYCIvyNzFrDErtdr6RjN0RTwGki8qQlH+wa600IAwYp53iJQGNMN0ndFyGt+n+bBIpjk8BHCzJZZ7CXQ
 2Q4w6evO
 ye4xYAZCC6S5O11ofYpxF3AS/3LylfNOxhMcIze4xb/s7q0IbBlXdgI+NZ3barObO23AMzgGWRpN5HgY8IX8ET3NevjP+DDRFwxaZqUCDgIlv+RlU3mA4tDe5kTmqlmQdZqwPnrqPXrVu5d6V1GaiXOCb6DU518Ajuqsb7xHWDTx5SjTB8WHKxi/qVxdEj1ZJr6xk9TckN9LMX4hZQWz+KfesdBzQ1DijXKtuqGEZLWm17aEtFaTILf6Gu7IrDQ+NqNwYImPD13qaL6M+9tVtt9J6yqgVvfooNJHoLZIqb9Gma85+hXCnUjY6Vtje0CE6AdMlb1BgVu6BgA4VwP68tEwzicLp/z4hdwxTKseMDu/V+YUQP1YNIdiOypwP/O5lib63qe0M1e7wExyOy+sD35xNaYdEuj7ZBGMh2Wk148Oz1saG4GtmRc1AzAkyqU7muPQPWAEdct72vQaChnhe9BQz3YLbwWO/NB0jjC15LkLIdc9ONc0GUpcIQ+zo2wS3gEUU86//UnflAnAKfCTxe1vtBoCX/PKVmaVlvob4Q3LCU1IOeAcNDyLK6NUp/cHkHjomjMvtr2Z/nAwpLVmWkjpVvQcBBME+tF7OMV0X230ILBTvOYQfsAS2+8KpGVApf9yrDGjHoEQxdsN+jYWplZw4wACeVNVQBrgRMswHvAwwZpeTUDJQGlv3p2si/UL2BfHS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ruan Shiyang <ruansy.fnst@fujitsu.com> writes:

> Goto-san reported confusing pgpromote statistics where the
> pgpromote_success count significantly exceeded pgpromote_candidate.
>
> On a system with three nodes (nodes 0-1: DRAM 4GB, node 2: NVDIMM 4GB):
>  # Enable demotion only
>  echo 1 > /sys/kernel/mm/numa/demotion_enabled
>  numactl -m 0-1 memhog -r200 3500M >/dev/null &
>  pid=$!
>  sleep 2
>  numactl memhog -r100 2500M >/dev/null &
>  sleep 10
>  kill -9 $pid # terminate the 1st memhog
>  # Enable promotion
>  echo 2 > /proc/sys/kernel/numa_balancing
>
> After a few seconds, we observeed `pgpromote_candidate < pgpromote_success`
> $ grep -e pgpromote /proc/vmstat
> pgpromote_success 2579
> pgpromote_candidate 0
>
> In this scenario, after terminating the first memhog, the conditions for
> pgdat_free_space_enough() are quickly met, and triggers promotion.
> However, these migrated pages are only counted for in PGPROMOTE_SUCCESS,
> not in PGPROMOTE_CANDIDATE.
>
> To solve these confusing statistics, introduce PGPROMOTE_CANDIDATE_NRL to
> count the missed promotion pages.  And also, not counting these pages into
> PGPROMOTE_CANDIDATE is to avoid changing the existing algorithm or
> performance of the promotion rate limit.
>
> Link: https://lkml.kernel.org/r/20250729035101.1601407-1-ruansy.fnst@fujitsu.com
> Co-developed-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
> Signed-off-by: Ruan Shiyang <ruansy.fnst@fujitsu.com>
> Reported-by: Yasunori Gotou (Fujitsu) <y-goto@fujitsu.com>
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Juri Lelli <juri.lelli@redhat.com>
> Cc: Vincent Guittot <vincent.guittot@linaro.org>
> Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ben Segall <bsegall@google.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Valentin Schneider <vschneid@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

LGTM, feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

[snip]

---
Best Regards,
Huang, Ying

