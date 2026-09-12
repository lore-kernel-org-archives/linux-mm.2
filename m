Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9354FC88E56
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 20:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB406B00C7; Sat, 12 Sep 2026 16:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 081EF6B00C8; Sat, 12 Sep 2026 16:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9AF6B00C9; Sat, 12 Sep 2026 16:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4DFA6B00C7
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 16:26:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D59B14054A
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:26:55 +0000 (UTC)
X-FDA: 85206243990.07.220F692
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 591D840004
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 20:26:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4SV0qYCZ;
	spf=pass (imf11.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789244814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k80GbC8BsCfGepmIx3SENEY1Kj4sK1tV084haoESIqI=;
	b=rmPb6L6b3dqxNy4Tr/8xkiMJ1ZCcZw/OHpx41rA+s0uCrWR3vtue1SkUiE410y+fISW8/f
	H7P2gVjM2AUDrHvHqovuSNQs2gAqwh8hXfAGw9Ih32iZv+kUxb63uF7ks+vTKn/9au+/96
	UL8ln828e2bc3rvaIw/yvGMrVM9p3Yw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=4SV0qYCZ;
	spf=pass (imf11.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789244814;
	b=nScUcp+xweo9OSSa5jad/eLFXg4ZtH8dpPwkmSyhSFYb8at66PX9lv0q72KeEt0yzX1N2X
	GI1Cgu1Y+VZLh+7jFO8+d2iCYtJfEM88vHkIKbbi4i/Rc1lWUFeWafYLrcbi0XITegcs/m
	z7LFyiL8DS/6N76jGisKGM+73bNDKW8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=k80GbC8BsCfGepmIx3SENEY1Kj4sK1tV084haoESIqI=; b=4SV0qYCZcJLmADDaWKZF+5HVbj
	0kZVZeWr9XaUFTKaFVYHtjcH/BSjFKVpuvpgu1wkUtkqsAH0jyH+n0BYomq8LtzasjuFsAt1LP19B
	repU/d3uHy7nVUuNKSjTGsIdeexv9vU2x7ik1Mz1QdyNMtEYR3d5ZzJpy835AGqAduJoSp1ApAHwN
	JnXZJ6dPji+wc8vekwJQwEkwD5UPYd6kEZsWCP0CD53E8kpoYT0T93Y20A8boKm194aQfYjvapoZD
	/V0/KHeywd8p/RTJsubKoRUbtKPemcsZsFfHjXhDJYhj/SrF/F02xU9D2ya12vX3hw65vuYyNMzJk
	CPrtX2/A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x5UJD-00000001A29-1NQr;
	Sat, 12 Sep 2026 20:26:48 +0000
Message-ID: <d70237f4-462c-47f1-b550-5cfa91e08873@infradead.org>
Date: Sat, 12 Sep 2026 13:26:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 9/9] Docs/mm/damon/design: clarify bp is basis point
To: SJ Park <sj@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 damon@lists.linux.dev, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260912200814.145612-1-sj@kernel.org>
 <20260912200814.145612-10-sj@kernel.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260912200814.145612-10-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 591D840004
X-Stat-Signature: 9a9khny3ofq53befxzgye9naqzii7not
X-Rspam-User: 
X-HE-Tag: 1789244813-267581
X-HE-Meta: U2FsdGVkX1+xyBIzt++tAU5qWAwL6U9XZ9I0WXsOL/r0lEPGMYfBqy39I5MeKbPMmgHsWCZ0jVOp7JOJTTnEs4w3f3JSHFMVjmX+aoUYWJqo20LhCphm06Uxv7LOdZqC7KQOzmeUbVA9O9gp9j9WBiH16ENxOoyEb89NF7P1YSjn2Lzh/w6kWhQrevu6eMnW86sy0f3Z372WOVF6SO08c23huBobCH4X3XNDH7WZGQ4YuznR7d/PgXGnNPu9d3hNlFJLNjF45VZx2OwCl7SpvlBgpGllEcEjrzDW0vIZWGCfMmNDOny4IxtRcxVjncVyN5VqKqij09jUnjCJsJ57v/yeYLZuqJ4vXWL0tRg+3o2lDQsNvPQg40T6/I8QJ2z3rguxT1O3XDHcZxF107HRA+hKFnbMIjkpzmy1k9v+HjbS8OR0JkeeavVQyGTPb0nxL/L+Dpn+2OpytCNpMwAgI7hpwS3lFUv6n6Jr6d7yOWK622zS1CBaQMhZIRDTmF9CVYeBjmYqHiuZe3TpM6SFz+h//ChFq7vfB6EC4AmWez/zNRfSyyix35hHISqWHKyesVVbCSZ33bALssTgd3/Ou2k1DVY5fwS10dLOVEDF6wZ7FhtAz4gJnMkg+ZlHFgifIlEdWt9/vUR3URuyJfP0Szt+HZ/hQJd/EBWC7YtzScrSEUVkQP1URp3V1HsWUsiTd+56A9ZJI31EoknVcp8FfC+jG3gw/Zvpvw5agV5pBd3ZjOpZ019Q3SQ2ca3bGzUOgEmns5RbSgFj1pti34Wcqv2h6Vn5OILXARAAVhakjC5qBCtSBVCqVW8pt6knjKi6tZMAlpepeJ3aNYzpdHLAhLArUFNvjLg1Wd+3sL9cHxO2ZI2wkoHoDDwKGoPIdCpA2omoNMbYHulVD2c2UYIRco4c2v7kcoKQEYQ8VZ8bqLX8rw5wwk1h64C/oB3h4BXWHNH4DOkCJt26HiDa+1r
 ih5m5KEc
 cn+Yp9VUbKmUJfNVw5T0q0JK2X2+ymCVVHxaWBkKv46KMMcBFl7l7FtA+kkGgs2f98+HYjtAI9FlNL5WTSUpCvciBt7WVNv0bracsoOmSzDRLJfTi6eifVyg+ydGQVnyJAhAbeSP8Gt5HwW881uRKw9XO9+fa4Pozq8+ghi0xQUCtA7h+Wr82FHzw4iLAuYzsmoT0CR7tmvlZe17zK3BRPKfP3NDGuBcUmt3VEaaXZQbaLhyrVSF84RIEntGNlAxO1gHfh3/s82Uixf4ffipBa2/snPlzvJtKRQv2GSyLM3+sLsJYt38TggcpBKOu+vVCbxYmfOwu+C/wrquYq02YgV1m74SEMmLrf0+c55NdizxnEtXMVSkvfvGd/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/12/26 1:08 PM, SJ Park wrote:
> DAMON design document uses "bp" for "basis point" in multiple places.
> Because it is not clearly mentioned, it is difficult to understand what
> "bp" stands for.  Add the clarification.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Closes: https://lore.kernel.org/107dc6ba-697e-4b25-ba3e-8ce2499cac9a@infradead.org
> Signed-off-by: SJ Park <sj@kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/mm/damon/design.rst | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
> index 0a86792f90a18..e82390e77a70a 100644
> --- a/Documentation/mm/damon/design.rst
> +++ b/Documentation/mm/damon/design.rst
> @@ -445,7 +445,7 @@ users to set the aimed amount of access events to observe via DAMON within
>  given time interval.  The target can be specified by the user as a ratio of
>  DAMON-observed access events to the theoretical maximum amount of the events
>  (``access_bp``) that measured within a given number of aggregations
> -(``aggrs``).
> +(``aggrs``).  The ratio is in basis point (bp or 1/10,000).
>  
>  The DAMON-observed access events are calculated in byte granularity based on
>  DAMON :ref:`region assumption <damon_design_region_based_sampling>`.  For
> @@ -717,7 +717,8 @@ mechanism tries to make ``current_value`` of ``target_metric`` be same to
>    in microseconds that measured from last quota reset to next quota reset.
>    DAMOS does the measurement on its own, so only ``target_value`` need to be
>    set by users at the initial time.  In other words, DAMOS does self-feedback.
> -- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in bp (1/10,000).
> +- ``node_mem_used_bp``: Specific NUMA node's used memory ratio in basis point
> +  (bp or 1/10,000).
>  - ``node_mem_free_bp``: Specific NUMA node's free memory ratio in bp (1/10,000).
>  - ``node_memcg_used_bp``: Specific cgroup's node used memory ratio for a
>    specific NUMA node, in bp (1/10,000).

-- 
~Randy

