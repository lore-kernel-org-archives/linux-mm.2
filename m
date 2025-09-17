Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF12CCAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 21:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F518E0084; Wed, 17 Sep 2025 17:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0E48E006B; Wed, 17 Sep 2025 17:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6748E0084; Wed, 17 Sep 2025 17:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B188E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 17:50:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B65F5140557
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:50:43 +0000 (UTC)
X-FDA: 83900087166.04.0AE8B09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0D74A80008
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 21:50:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHaypvwN;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758145842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3626zjYR6kSuVKvFLDRZwu5RHl5n5ruiIUw8Qv37V8E=;
	b=aTktjrT5Gw354ojsiTnDceAMJy51MCsnDEL4dKLk0GiKv3hDMCsIbJ/6KfrSwtEWBl06Uw
	pZ+gFdoqHqCp9a+/kae5u1u0Fj2YYg5v2R2h1eCtIbu9ryNddCzpMe50SUEV8pCk9PWwWa
	NWyLIVeFZSsq7zD4/mDli+S+rhC4wKI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758145842; a=rsa-sha256;
	cv=none;
	b=LP/AvHuCrGArYbniht1fgooJyfezVyYM+UWrVJEEnT6R2vyvBlgmY524wVuKczJzRPloag
	csUTqBPmNJmEvFZRH1CrYmERGr83xaCHYwCqtVJD+wfTIkiuNz2/g+xP8U60BMaIsdZcrS
	+zOTlTKi5+xPQ+qqCI3MDKTv2v1iTd4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uHaypvwN;
	spf=pass (imf02.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B3AF43DEB;
	Wed, 17 Sep 2025 21:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4199C4CEE7;
	Wed, 17 Sep 2025 21:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758145840;
	bh=PI8Xd/l8ye6DwfFy3MPo+C1Do/Lt5w3dLjCZrDbRvpg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uHaypvwNb8YfyJhz0Bzf2HD0jBCXdV+BPa8TKwZ4bAP4d9B0clPVMoIJ2LdECcuaK
	 vYekqSwdwddF61t2/8IzWsPqAahBL7CKyeA2+GjxOqG/hHC/rT10mSdDgKCdioqSpS
	 jeSb5GIMTVqEbT9mnUNof4LLie2y0gl/If21dzXaw67PaBI/j4ymKyf+1WB46sOubQ
	 qn+LIgjlW3z5eReKvTCxyM0Sw/eNHwUReLk4o/mHB4/hH3C6hxcjv6nhoS61/o3uPU
	 Uj8EXKZsWlWHsrxe3yaOB1CQy8iUsUvBspSvwXz3wcBYfQOGHRsELV1Ko3J0vjKG+d
	 y1dP2ZCiivqLQ==
Date: Wed, 17 Sep 2025 11:50:39 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	muchun.song@linux.dev, venkat88@linux.ibm.com, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	akpm@linux-foundation.org
Subject: Re: [PATCH v6] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aMstLw_ccoveLow-@slm.duckdns.org>
References: <20250917212959.355656-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917212959.355656-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0D74A80008
X-Stat-Signature: 8foih4c1b8aujyswrokusrjz6k1nptn6
X-Rspam-User: 
X-HE-Tag: 1758145841-913436
X-HE-Meta: U2FsdGVkX19Wl6kBMRTulQmfotQp6Kxi7eNM7314XpleTEM5mO8+dDQtQGnV2/6thoX4O+7g/JjUnzQvFzb9cQTUJ/U8fB191ZmolcTvbHcs9xEwbPh1f+wFI7zFHyISQcXPTUFoqdr30o7JpXriQ9vXvGKfN6uzatCZWWSTx9sFGqXXGUiU7wvPpdyv6b73jFH0Jr+jlcw+7AwZsn41A/I6fhVoUOkBA27vdBCqU4aN/+lRdOiZ56scH/SUn7UXJwoHccfqcizvdPneHgnUxusTUqVaDzbcpp0q8gWBiYdnnYCSPw1vW5VlrmxX0B7kYD10x1m6/3jgmYz8Esx9dELjEUumbRRO8GlAPFrawa/g3uRV51XMPV2ZEQ3L2QouNsUnV5brvymhYT598ITC3APXqOF3mVp5NaNbLr3UOTyY4q47eukCtTvruUbvs+NMklfgPkplcHWlTDFLNVZQ4uzMfQNulN6QXyNTqp64e/vupfF5YhYoS7d8yHoW9t/tgbavhBIs/vT3NOey2NCt66VH5lQY2wttummEPQI2rbIc6hjdTUYx5J1QPKG1yapOvG/Ou2dlrGSa5w4svBThYDpTkolne4WLPIvxCd9K4XFOhTSxIY7LebyJyvg7rqIVSQ7Q9CKV50umO2dxZv+8MmaeYHdAFW4Fas5F34Z3QYCWCegEOx8AlnTKzW9PLd2IEo7YuwtkKDRrAGJxuje06cksHQ7qi35FthEzjyOablZx8T3qwuIskcmIZHbDVq2r0B8Af3kWchMEMuf9/rqDHLqnnIGINqkB4Nh8bIjSMNb9z8z7ZXzq7i99CFtitEhsgpcwYg0jVZmZFgi+q9mLzz9Ywt4NZKitz50d58T7fua54UhVN2nX+qm0g7/2sw2AvmneXU0bqOmM8VjkQxYMT49vMUkdjyxQknZBz66A5Wjm9Xqr8v11tjB1UUg9ZRwIQIOhvEDTFYZOgyw67tH
 YQdsPFr/
 KDzG4m4p96hPa/D21gAGyHyu4mBAr0vUCJO5oofNvSMSIS/PmlzztHMzweYlULQa7kwtzqstAUIZaBuEyb/CQoQomeveOIdtAE9vBbHu6wJa0FM2lI3u/PAjLwZcj+La0AW4bEqWuhZnCueBtYnMM7qSUVxyda9C4MpIF1NGce+ojX5O2HZXLweHLEzZCUfIjscJl4XkcTUYZqKqVrsZMpZVPQ6hyXmIi5Ew2RRLSz4WmQ91tXRRb1m5RJWZ7O6Ji3LIK7m0oCo+Iivm97pRo6GF7dcJIT+WhOMIb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Thu, Sep 18, 2025 at 05:29:59AM +0800, Julian Sun wrote:
...
> The wb_wait_for_completion() here is probably only used to prevent
> use-after-free. Therefore, we manage 'done' separately and automatically
> free it.
> 
> This allows us to remove wb_wait_for_completion() while preventing
> the use-after-free issue.
> 
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

  Acked-by: Tejun Heo <tj@kernel.org>

Minor comments below:

> +/*
> + * This structure exists to avoid waiting for writeback to finish on
> + * memcg release, which could lead to a hang task.
                                           ^
                                           hung

> + * @done.cnt is always > 0 before a memcg is released, so @wq_entry.func
> + * may only be invoked by finish_writeback_work() after memcg is freed.
> + * See mem_cgroup_css_free() for details.
> + */

I'm not sure this gives enough of a picture of what's going on. It'd be
better to expand a bit - briefly describe what the whole mechanism is for
and how hung tasks can happen.

Thanks.

-- 
tejun

