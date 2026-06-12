Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EE3CD8C9D
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9376D6B0005; Thu, 11 Jun 2026 23:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8A06B0088; Thu, 11 Jun 2026 23:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE916B008C; Thu, 11 Jun 2026 23:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7213F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:47:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E09F61A03ED
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:47:28 +0000 (UTC)
X-FDA: 84869875776.09.B9FD0C9
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id EC1B4120007
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:47:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mYQDZ7X9;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vlsXwbdv4YLsjOvBE7ppjfwl98GoswDXJt/chitc04=;
	b=bOrLdBowOPtnl93/DO6nA1/YGzE6WcybKGbIyM90lWg9Cdhyt1pgH/bLUt1k8SkohBn3Rj
	TNB4MjK8bB+D1Pj9o2F/gsjTQ9fQeTWJ9vhZyi056LJ9VZtYYXAlZgkER2b/EQsEGQRR1s
	75/+f+4znkrg3njj7BpNvyUsZ5pWZhw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mYQDZ7X9;
	spf=pass (imf29.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781236047;
	b=qd83IDUK1gkOkWR/iD3qbj9E+GCcXQ9orBvet5D29tTQEl0RRIh9Pt4/VJ50zqVKk7K+mW
	WYZTP54OsSbDzY11DqmqSX4Bg2vBKK5e0LkOZYaUGAoYFJhPGxnPkQ5ac6Fq5eaApj/2re
	kXfXNplBbvs9fmXqYjLmquLDiBLXHNE=
Date: Fri, 12 Jun 2026 11:47:10 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781236045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3vlsXwbdv4YLsjOvBE7ppjfwl98GoswDXJt/chitc04=;
	b=mYQDZ7X9hjPoIXj3GM2UvtX4VuTFvaVx9H8Va2kBNqeVRS+KhX8YbfQWTKX6CKUSn/JbsR
	Q/HbJRrr7Bx+6xwbxAWOn7dj5Me/RWlWWZBXtGRUGNchUT/9Ep+78HAik1d+0j+SlaRAX5
	zKxzweN8o+wR+3NAcFL5PD8rlrEooYc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/16] mm/slab: do not limit zeroing to orig_size when
 only red zoning is enabled
Message-ID: <aiuArH73S7k_jQ5L@fedora>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EC1B4120007
X-Stat-Signature: rayzi93y83oac6szxyzg7wcxrkmx8mzd
X-Rspam-User: 
X-HE-Tag: 1781236046-281498
X-HE-Meta: U2FsdGVkX1+fzC22fBCFMdOuAeu+339BX7SnMq4/A4LJ9WpSkGSbbPzkY/P55/JA4pMquk+3b7EzPI0+kqr4qycbLSPUGw5DfRLUd6KrLnuK7EgY4DTJn+3IgccLSgyUKrld/9Ds1FtIqyx5yDctntDqluEOpVWwYSzvInMiM/foUYeB4LnzH5H6FeKWe2HrAtm/sOQpI1UK5OZw4L28YnoKDUvXucT3ru5AUhn+h+Nhns70423Z9VxdEEKZawE9eAbmelpMN1IClBdGEajReysQKW7pc6JoZCnftlc3RUP4UZVvpxLrihoUu0Zinbis0Q4N1CnoAOpuy7VBbTzJdIGku3c7rICkrTVuk8nhXmkVbed9l3q+UA9rNfS4xxbPfUmYC40kuYAJ4OZqYKPqHHswXewbCZdNzgwNLN4bFKSPA3U9wpOfOgd2JIlQZUIrA4+9MwNQiSawQb+74USYFpItzfqSBtIkaRkc1lgwalId/UVaw8msfmeKcr9nWXWNnwapYl2y2raO7UKbquPSFNQKm3aNtMF7MZ//WNx9Buj5KTiSSdp1kONQ0s/ysX0gATnCF97i+mUdGg4Sys+Be6ccDLqdAOeWUoWPg1h71RB40gAtwqZjRPZko0oR7zsVq87DJzuSK9tpEmJ9TFpuXBPtRdVqu8WhabvWf85iRC1V2eJL/tc56SwtfW20eA/ZbH6MVntEzDcgw4E1yHT9MYMcMz2KDiWNWNtFCt4MsNik3ZGVqqwWZxUDdorUPpXZeGBIzZcguanCsNa/cHvShmeybqCn/FjUSvawYrSanV8LnLok9jyErCqx5yJheBCdNPAFvDw/dI1ZZxPDGkHY1mGA+lY3nAs77IvEJXVXQp6l6s3tZc1c16pKD3I/NREQlM+xdtkM3OyVRQLxtBVEBj3iaxFYhwhcjvvmXghDIIoBul/PHqkffqbDFC5spwz6ky6dP9BCjdtJfuYq6BV
 68Xv/uo8
 GThPU2//RSPH7R0lkbEafLyOgiSN0hk0y9fJYD4+IecgagIpONTk8luMy9P9xVauQv9e06LtGC3Aix0b2AMiidhi+ABMQiySrVrjAPh3rnEWeILPSCv5Po5QKljqANVhj8sD4FcyJ0DHUQep7DK1a3iTwHg0VwdeTJeixwdkyIMf8LpebcnYLNYLgdqbNOPqNQJlv/fdn8YYkTmX6kY4cKGxQCtlcpSmE/HSPkM3+mgdHSxWnhxa73YyjTBR5JMa9aBZOrC7qnnjNk1XtWlDQUsddEr8VI1YOToldo5+CU/AMLrZJKlBwxwJlHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 05:40:03PM +0200, Vlastimil Babka (SUSE) wrote:
> When init (zeroing) on allocation is requested, for kmalloc() we
> generally have to zero the full object size even if a smaller size is
> requested, in order to provide krealloc()'s __GFP_ZERO guarantees.
> 
> But if we track the requested size, krealloc() uses that information to
> do the right thing. With red zoning also enabled, any unused size
> became part of the red zone, so it must not be zeroed.
> 
> However the check is imprecise, and will trigger also when only
> SLAB_RED_ZONE is enabled without SLAB_STORE_USER. This means enabling
> red zoning alone can compromise krealloc()'s __GFP_ZERO contract.
> 
> Fix this by using slub_debug_orig_size() instead, which is the exact
> check for whether the requested size is tracked. We don't need to care
> if red zoning is also enabled or not. Also update and expand the
> comment accordingly.
> 
> Fixes: 9ce67395f5a0 ("mm/slub: only zero requested size of buffer for kzalloc when debug enabled")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

