Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D0C1088E52
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:28:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E87A6B0385; Wed, 18 Mar 2026 19:28:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2992C6B0386; Wed, 18 Mar 2026 19:28:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AF026B0387; Wed, 18 Mar 2026 19:28:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0ABF36B0385
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:28:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7B9F896E5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:28:29 +0000 (UTC)
X-FDA: 84560775138.17.BA62082
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf21.hostedemail.com (Postfix) with ESMTP id DBFE21C0003
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:28:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tOXpz2X+;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773876508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js6oHi8egyhsbSgRpIpQSUvyw4AU4dc1dagQu73NTIg=;
	b=KaXWDnXvwgxSgzVC3m8zrYRj/EDQDMnaa4w3pL+RoBArzZbUIhnYzSSU52c80l+kXraqju
	XPCYmOkjoV+VwCincMxHFdo86GYpBdd9yncIcn5ZcXox6BFPT7eEyr7zFhEHwdfJCz9I41
	fsjG/D3uYKJ2lqXjUYArs7G7XKjZW20=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tOXpz2X+;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773876508; a=rsa-sha256;
	cv=none;
	b=AdTwY6z8+eL4HvQBy9IqFus+EdPXsrRtLsVY+mXnheXfmIMpQW4WRgoROrsVAE6unkmNc4
	rJnvRMRJr/hgUtCrLpZxbOOj76oww+vl+tcsskJRdN6WRdXDN0lQNckQwhupkQEWYs/3Ij
	92yhBRi3M8FBBZeN5JUPVKRs+IHsfmk=
Date: Wed, 18 Mar 2026 16:28:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773876505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Js6oHi8egyhsbSgRpIpQSUvyw4AU4dc1dagQu73NTIg=;
	b=tOXpz2X+yd20tixpcBzWD7GN28MkeuHwjquOwHJs8Jjm8LdIB/MIZuZFGQoUkREgGLLjcm
	JMXPJ5WtjGAQ7fXBpDPUtfSWUyRxjsSanh8CtuxHpZP4+95zv2yL4NMWgjOl/wy8nwMb0s
	8fLFKx0rj1eSQOHY9kJkK7oUkpzDL6Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Bing Jiao <bingjiao@google.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	bhe@redhat.com, cgroups@vger.kernel.org, chrisl@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, joshua.hahnjy@gmail.com, kasong@tencent.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, 
	muchun.song@linux.dev, nphamcs@gmail.com, rientjes@google.com, roman.gushchin@linux.dev, 
	shikemeng@huaweicloud.com, weixugc@google.com, yosry@kernel.org, youngjun.park@lge.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3] mm/memcontrol: fix reclaim_options leak in
 try_charge_memcg()
Message-ID: <abs03hzUF4rx-RdI@linux.dev>
References: <20260318215629.2849052-1-bingjiao@google.com>
 <20260318221957.2979346-1-bingjiao@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318221957.2979346-1-bingjiao@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DBFE21C0003
X-Stat-Signature: j7taof9tgfshqpywwtemxjryri8pfmae
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773876507-280165
X-HE-Meta: U2FsdGVkX1+uMYWzn0s6CFNUI4b6XCAQJjsWMOX2DFz+AkyB/bsfGWeek8FrKeMP5waI13O91XGmriOpWE1rNFM0PK4aeAMFC+oIB+s8gMAdj0tRU2Ml97jYL0RqDCMVFmsazdoIl1pMPkuNLfr4x949q1yOgPkI8ivPO6Rj23LZe1CXL8xsjn9Wm3QeuT29KvHipObU/+ABPeUhG8VP8mI/vfyanQymvmeThmdCxPshT49heT7bFqiHfy1JCCiWQTacADw/E32CUIyXyiklvMkOZgxnJOotU08kHibjC5VD3/u7WsJKlLN08TkKPAlwJw4WjwQWlf9gfycDYS1KJILN/pNaTxkczxKZDVhjmmxEqY1MwpbHnBg19zeTwrnUOnhqlqU/Il2wxEVEZZ5rzZhUpfBj1omW52Z8Sj4Bot04BQeVAEoWUER4QOqXZdemcg6+KHcLnsBD+8ddJOAoPvwcoJtqWaydYG2O3DCGAMcg4pybq+hWWhQ6+XyIPTsZth0DPzZgd5b3BsEWA3CjvSxD7QpXdUkVe2tzQVIZgk7HtSY43syZgYSKt7IeVPwu3ecNAFtJyAXQF4BuxM/bTxQVk9fny56Ec8umoev4YX2m1VRTH/QeV7c1s6s6+Dj/H6jIg86qwx7KuQh7SEvX1AgSAzWFvnlBDiDvQPp2luum6j0KCY18xPiZT04Iwy9T60932rLH03hqiKYFsOuouIHR6oAhVUyInO75nWNwpoRgQypiTPQ+YRJ8vE96bVH5EBbqDRLAq5yQhEjchP2iv0DbYwh6Vnl/QYIOO3lBXXQ9HMt8D99BndORIuALLlCPmDvJFYxtvCKa/5ptS0CMbShceMcLuBNaiFZ7TVElbLwF7y7gRt0FeMbgX8jixznnG90bKNAunKPAVGNA4EAFVBI+xa8zhJYhCMc/CpSRmuYNHx5qGwjbAkfqTxX339Rjei+yeIu8sNMOLNXtV/6
 me8p0kFV
 OZgqYtl95xzoSGW6LwepzPTUAGKQZj7XtFmDTkJ1AfNHcV9s1RH/EC7Uzu3eF0ZTtDFGlCmNswK3GxeveqPcjlRDZzyecnSdfzBqxw9R8+A5OgQS+hfa03RsXsNg4E1a9SPiWBxuhDAEZq1n5VdMGThY5If44AI0CsnxgEUteIiOCvixJhc6tgBm28EAa1vhewVbw/CqHRmv+3sS0A2zoqez9DB2nYydDRnrZ+xD/vwPb/Fd9/631QalWH7JworFJcGCjjWnl6q6hgdoDvnWiHGnsrtRJ+PLwKjuMdoDCaLWkniQg4GQrC3Xc1CtTsCDfIikAPuyLiVtQ99eZmCdHHkSXA0lNR374YtyhrIgkKMAi588ELjLsU2J8Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 10:19:46PM +0000, Bing Jiao wrote:
> In try_charge_memcg(), the 'reclaim_options' variable is initialized
> once at the start of the function. However, the function contains a
> retry loop. If reclaim_options were modified during an iteration
> (e.g., by encountering a memsw limit), the modified state would
> persist into subsequent retries.
> 
> This leads to incorrect reclaim behavior. Specifically,
> MEMCG_RECLAIM_MAY_SWAP is cleared when the combined memcg->memsw limit
> is reached. After reclaimation attemps, a subsequent retry may
> successfully charge memcg->memsw but fail on the memcg->memory charge.
> In this case, swapping should be permitted, but the carried-over state
> prevents it.
> 
> Fix by moving the initialization of 'reclaim_options' inside the
> retry loop, ensuring a clean state for every reclaim attempt.
> 
> Fixes: 6539cc053869 ("mm: memcontrol: fold mem_cgroup_do_charge()")
> Signed-off-by: Bing Jiao <bingjiao@google.com>
> Reviewed-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

