Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF1AC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 17:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1B96B0088; Thu,  3 Sep 2026 13:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8246B009E; Thu,  3 Sep 2026 13:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E5376B009F; Thu,  3 Sep 2026 13:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9456B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:57:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4452A1205C8
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:57:13 +0000 (UTC)
X-FDA: 85173207546.10.24A20C3
Received: from mta0.migadu.com (out-167.mta0.migadu.com [91.218.175.167])
	by imf09.hostedemail.com (Postfix) with ESMTP id 439BC140004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 17:57:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTMUZ30c;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788458231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qV5V/iJMRpMH/d5wK6xrMA7U1+4qTJmCzwPyZhQWwv0=;
	b=wljppnkcf0ykIy4jaObX+yds6faX7FHmoI4nEpTb6bCz5oFHtEIikQmZAH5Ny29CV3bW7S
	2WtTsmdIF20xtfHGiDDl+4oFO1EuFsRhSIkZmgvlmijG4VYarFb8a73RzoIls1c3jESnIO
	Ie8OlItyoMZFlhe9ziO7fOUlJk/Nx1c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bTMUZ30c;
	spf=pass (imf09.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.167 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788458231;
	b=ySAYDJWg/rNr58429ZoFX/+a8sgE2Ix0zQNGl4Veeqby/w5vt3qSFe07q8s4FVN6wXuSam
	WUcKwt913sTRyoIFSLpQ0d+pw6K+oa4npjSmPSyeSW5//Mun6Cwv/YsPg42eyPDt2m8Mym
	IbAnImZt++5QNSW8eHYJbsbWLIBnJGk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FUgc+fVrFtLC9X8AHnzWDs712XgUX1Jr5Y/gjnGpuAs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788458230; v=1; x=1789063030;
 b=bTMUZ30cKVsb7lFaJXg1dUncaE2NhoDm9kxEGWbjyHWxjKmDvQD+wVlMCwLmX0H557IvgNkd
 v3umFX7EQLH9H4EGDWWg207vlnBWlp61/UyN8uOnPBJdUf/kdBZvXfT240NkGRBIcxg2AUqDpz6
 TeCRs2xMo0F5jYjNkF7MNIik=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id da9ba4cda93ba682;
	Thu, 03 Sep 2026 17:57:09 +0000
X-Mizu-Trace-ID: da9ba4cda93ba682
X-Migadu-Flow: FLOW_OUT
Date: Thu, 3 Sep 2026 10:57:08 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 3/3] mm: memcg: skip the RCU lock when the memcg is
 not dying
Message-ID: <apm0372x4vOtJvSs@linux.dev>
References: <cover.1788169145.git.zhuhui@kylinos.cn>
 <3fc10f32131097bb57efaec72d049d635b227cf1.1788169145.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fc10f32131097bb57efaec72d049d635b227cf1.1788169145.git.zhuhui@kylinos.cn>
X-Stat-Signature: f4ohxdqiroy5xcamcbwd93r8nudb5ww4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 439BC140004
X-Rspam-User: 
X-HE-Tag: 1788458231-87708
X-HE-Meta: U2FsdGVkX19KEN+HtyAxHseaBPHH0M1AifPg9onJmLOPZ862KKxmlvOgIQGxkOLqWRA0WkJ9MuEqGb65nDeelnr0jLblaf3NJ+gt0V169esLFDq65cF1P060uxbcZk7e9jPyGaIxtyrqAOwydsRy4n6xEQlT7T1skIi8Q+i52r785Mgj2sET8sLTjHe24dYZtW6J/JbVfSlAGRg3VSdJvSRiXOljpFo1tZb0Wj3zi1f1MqjRRhLTLR/aGN7TriMENwIiTn6YisLpA6E5RBYYdFXb8MzK4hE6I3m9obilM2/dVtvQSOxNeHYw0fgauNzJWfvXlPd6nqc0CJZ52nJKXhuzHZa5OfsrKtCJFwW4r1rdMY9hCDuvO0zLCip4Ta+NTNiXf4gaVRAC1VKhcvpARrq+SDd2IKeFJ2mo+kETtNm8/yV44KBaITZ2gxHnd1KO/xZgVvr/zDOH4pyhchpKlsRxkBDaSkUd9DyNGG3Yy9lsUW2OcxvyhShLMl9VDWVF0XWH6QLWd+dMdoUxy8xCGRc4R8tCpmkvIU4rovaJlLaeNraSy+0P/Ic3RNdfjCHJFG1U/2lo0593s99Jl8F69/MI5JcTQv5n6OSmLpGW4iJic73tsbHTaQ9srPdG1mE3Cmaeq0JWJWkyFECluKYuP8UXsLBS5I/3uJffL+E07kj8J2PgagvZWNMFmAoASQ5JLsGS7zqNRHtvlLk850+YHiTi+ydDQoXeWTMObcT5lL0i4E4pxxbnWPc7Ee6ur/Ui4kjtaqy13/pDYEQ/uOdaWMnRtA44bfLPd8B9mr4TrumtH+5AAaSKJ2bmK6tMIoK9QwE++GcJhqE0PQ6S+rE2km9fu8cSc1PICCk8DwdyCMvb0JoQ/kk9onan+1456Sq37ZgK6ik4beGq0hQxhjrGFOdzXIfO9V3Pkb+sqVnaqDKNyRaSmcuVOekTCXC72JkVLGqM+LjdQAMkYqidP8Y
 FzXHm3ge
 p2nGUa+VuBJgAxKQL2dy1/0OueWdRfckKgQHVU4n3QLVWtPqrS1RmJQ0LVh3bebNUKDn3IsWULbXAZRxeF7fOMJZ+r+JhcWHNy4IsgeLWW5+Yv4S0Nz5gErKCH0XIyUglQpH+q5E8BtopOh8tEokfiROpmtpd+Xee9uKvl3oSCJar3ph+1Tub+OuyqF9Z29gkIw7egIRFkkF8aTHixILMR45oy2j9BHnQNwLGk8jdszWzngIC/7RJ9w9IFCcBXeRT5K9kYbvEoC6IleEsxOzULmb7PKlM5pj1K6o3NHtUj8bIYaY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 05:46:11PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> get_non_dying_memcg_start() takes rcu_read_lock() on every stat update, but
> the lock only protects the upward walk to a non-dying ancestor, which
> happens solely while a memcg is being offlined.  The dying check itself
> reads the CSS_DYING flag of a memcg the caller already holds a reference
> to, so it is safe without the lock.
> 
> Check memcg_is_dying() first and return immediately when the memcg is
> alive, taking the RCU lock only on the rare dying path.  On an anon
> fault/charge churn workload in a memcg this recovers the ~0.6% overhead
> added by the previous patch (4368077 vs 4343159 pages/s before, back to
> ~4377000 pages/s after).
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

