Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49ADACD4F54
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 20:11:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C99E6B0005; Tue, 19 May 2026 16:11:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752866B0088; Tue, 19 May 2026 16:11:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 680D86B008A; Tue, 19 May 2026 16:11:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56FE96B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:11:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 05C0F1C1FF9
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:11:30 +0000 (UTC)
X-FDA: 84785264340.08.975D149
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3B1C31C000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 20:11:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KYuDwzpS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779221488; a=rsa-sha256;
	cv=none;
	b=fmFJhpH5FD8a9dvzDPlVYuwp0bVSWGTLgQP77hSHw0FqzauUlSzDOmeTpTHC5Nia7P1Ws7
	aVmR83mPcaie5XGnoTXV1ouoZCIp0kFxvZTLowlM2k70HKvjNa+taZLawha5fnj+QFwn0j
	bANPkbEjv0JKi7syaNXKcgjeGb5Wc+A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KYuDwzpS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779221488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJMO1B/wUheToiDYWGSoEg/sxiAds2iQg3Hn7Ds6K+k=;
	b=sO/4PCWNyn/5rq9Tz1Z7iz6MLCqcfDbpSKsgd1Jy1P+1oE0CIF7wd5PaEqNiJb74BGIT77
	l/7gqyMapE3StHRTzd7pVcyRFn6TXOn468TlQuyOSbUXTQr9mhQDIlH9In4zrDM1jkwpge
	cAUz4H63NYfJWxHbIawPTH9ktCTCrIc=
Date: Tue, 19 May 2026 13:11:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779221486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kJMO1B/wUheToiDYWGSoEg/sxiAds2iQg3Hn7Ds6K+k=;
	b=KYuDwzpSkEYfETezMt32EYxbA2JTy87z0DUyz+R+kSus5d0zTzU0bVqZhwtWU58dFApu2N
	bW3HqDPkx3r9pO4t8OJ/VjsAHHjf/lRGkT3eOKY2cY4Sabm+DDBvC9+ceMHul2yeKYgHWL
	dDyda6ZhpNc3f5yuJi2e9LKBP5rw/48=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH v3] memcg: cache obj_stock by memcg, not by objcg pointer
Message-ID: <agynzVVBb4CYJTYG@linux.dev>
References: <20260518222827.110696-1-shakeel.butt@linux.dev>
 <aguiSnY3ie1y4nEl@linux.dev>
 <4e296262-fbbf-4ac7-aecc-3ef831583704@kernel.org>
 <agxszIIN6FtK0fEb@linux.dev>
 <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca8e655d-5fe7-4957-8a36-6667616be8b6@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pymh9hwu1qz9zmi9huos586ik1z78j1n
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B1C31C000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779221488-745851
X-HE-Meta: U2FsdGVkX1+xytVBPZi9je5vFSj0h58Pj0Zz3UkUth/rjl9srcIFe09iPSBH1QnoIudnYx9ep8KrbA8oOFpBIRETOcNjZSxXthvIV0jvwDVRkfs1eapmHv6Ors7FgWz+vU5jgLMwK5gQEJ4BtbrFQDKSqbBVrNkDPE5qdNC4DAId4MVWD8MQDtELKfwLz+oI8MMmdF+AQi7/Bhn+5AadIHw+482nmaAVLgAHIsUL78vXFnqu0IucuZS1soVLZW6YG5GgNaKbg1TiVx1Zr5nQ0/FClFH8QsnIJwAWl+iTAUKoNysvY+fohEqcqKmVc87Z35sWBBGqy96gNapAfv+QwdG6TglGQvKwWlsO1/i/8wap5YMgPMLEh7sZkFBzO7aNHKQAHBJzfoy5aCfWL7L/HvUtWAm3OWDilzZcECydmtphqoY5fVCTB4YBkTRBLusvnlcR5G6OW/BF6GNaFE9/GMR3MMBxd8IMQut+x8DSY0S3+eNzTKHMIdwe7AECjk/1D2s/avqIhHftRmSMGvlp9hPgxLRtFx9UfD4kWXlAhntbmtmAhsJWmKnBdBnwaALj0xHmje6bksHmwILUil+KL+0mq8MU0MLSp9VYvPihMXYC81TQLbMMmJHGAaODbxJcypootTpB0zBqEUJJdVItqxRqQpebY3Is2LfswHLATZ0rMffBgZeUsB8mJy8dmolfoOSGsF9gfye8b1rHWFbjExWVRrm3Gi954KLLBiYdGx3S1/tjNWby9xoIpNv0YQ2A0Gfgx0vlfIivY6ShddmBFg0FXfPyxtvQWWeMWB1dxrMJNJumxP4sU2AjCuazwTjjCsUuh1bAvENaBt9wFDihAUz9Gviza4HtN2KgDhE6Aqwnqjn8Wlrrj+6JY/JriVqSQtJzIqKbbiXkvCsMGjvIR/f8I/OvkygQT8YKQ6LlDjZO05jXiPdTGYTjeNU978wSW+qWT5tCWeJaHjutCvO
 OPAiprD2
 xA73ITBEu7D7LFUJR7YmDU3pl37dKoxuLPecnxIkKdaZTv0iS+mRHUW2PDp40uQXdqnglptiaiFlsP7wm3iRTTdbNbJL/DTvVSGHBH26MtKBnEZpSNewLidaAISPHZRGFf+sISDMcZfeCGIl/l3Ark9K6mOWrKnJwZV3g63jTPwYgLAJ4jrLT2b0RQZ90FQq3Qj3bazQWTMtuY6oxuZSnbwu84ZNhI99O1WTfSsQE4AvYmkeuBLZQ2ePwbHCIt394PKB/b0ByyPulGqnBv3+YryJ2hsBv1I2rgky6WpwA9sJtKs3DxW8v1WfqfIPitUVUhujDzIdEQWxMxO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 12:00:16AM +0900, Harry Yoo wrote:
> 
> 
[...]
> > 
> > The full clean solution might take one more cycle and I think we can not just
> > ignore 67% regression on 7.1.
> 
> That is valid point, unfortunately.
> 
> One more thing I have to ask... for v7.1, wouldn't it be a safer option to
> revert the per-node object change and re-introduce it once we have a cleaner
> solution?

The issue with that revert is that we reintroduce all node lru locking in the
objcg reparenting path.

> 
> This change was introduced in v5, but the implementation before v4 had been
> exposed in -next for a while, and I think we don't have enough justification
> to keep the per-node objcgs change, at least for v7.1, given that we have an
> unexpected last-minute regression and
> correctness concerns (albeit slight).

I am waiting for Oliver to test the multi-objcg patch I sent. If that also
resolves the regression then we have one more option i.e. backport that to 7.1
to fix the regression.

So to summarize, for future kernels we will be having multi-objcg in some form.
For 7.1, we have to decide between (1) do nothing (2) this patch or (3) backport
the multi-objcg path to 7.1.

Andrew, please don't send this patch to Linus until we decide on the option.

