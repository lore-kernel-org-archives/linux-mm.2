Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F574109E522
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 23:20:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24066B0089; Wed, 25 Mar 2026 19:20:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB7A6B008C; Wed, 25 Mar 2026 19:20:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38666B0092; Wed, 25 Mar 2026 19:20:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 92EAF6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 19:20:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2791E1B9054
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:20:08 +0000 (UTC)
X-FDA: 84586155696.26.AB899A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5DC4A40012
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:20:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UGPBngko;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774480806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZrMyhrPOAGrE9eZcdeVznfB9fxB+P77m+kugv/xJK0=;
	b=8Ts0tUeT8Meu/g+dJaxKJsDyXYQ0kdHh+1t/eoOrLpsNRMwCLdfZ8ULXFxdc8+wglRiJeS
	NnYaBtLbrlD5xWsvqEV+dCygdB31uGbx3MjOgGClYMT+vbj3sJQOzAmm1tvgc9g6+r7ztr
	bOYsbZll1nwWTzOsl4OkK2vCkBDi8kg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774480806; a=rsa-sha256;
	cv=none;
	b=yDJUqhLoS4kcNuZUKWCz+M0E/oVNMyLEIHjmEYmi0RLwt1Kn2CNQJbjZkg5N4syJbwu5/o
	QjDZdy3VCJoeoDoB72zu0clDGgapTO9uWPLViSdJMXX+t8U4dzHCyuiDjXU1zxf/VOYrwt
	PuKmr8mkvk33q9u3nm26VVzGUXdXQW0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=UGPBngko;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 385D343886;
	Wed, 25 Mar 2026 23:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A89C4CEF7;
	Wed, 25 Mar 2026 23:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774480805;
	bh=9s00olhICAUUbLnAIWavWFOvPO+7LJvV6aw+2t+Tz1M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UGPBngkoEYosW/NnjPjNa5ydoYzla43Bwu9Hf7K8VvGyw1KnWKVVge2ZOw6+orvd8
	 nlg3rdGKT5SJCoMUYkBH+IDURtV47KARSb0umR3PAPvYwRxsDajCGQifkujroH3hvB
	 muTNsLeYiQlROjTXLUK0ODgZzNXdzIjZ+gchS9AM=
Date: Wed, 25 Mar 2026 16:20:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com,
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
 taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-Id: <20260325162003.136dc86796eb124d3c7210ac@linux-foundation.org>
In-Reply-To: <20260325175453.2523280-1-youngjun.park@lge.com>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5DC4A40012
X-Stat-Signature: ht3g4aqu16we5xka4cea7aujoajnpzj7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774480806-960655
X-HE-Meta: U2FsdGVkX18VJXEK6hedXovP/XMf0t0qBhxTIVvG68xexQHJdRvScsVx+MPmHc5oIqMMYb+/R6+gGPHZbzRVVG9Pwoarkt9b+lw1Jg9mhCdM2Z/Xn5naY9KzdPY9NkjgtaRjrWIc389TiHsEHMt827E6VLgbBtgXelmztobDSBqM0JQPbM23gFfK1qFbGtpPAsRhOTP9T+953g2PU7K/UmcZkmhXH4wXYhR28jREinyxqvwnQqyEthG9v512UnFQgvpnAaIFrMbTTSxp0/kJmpUTeXrOFUEfAZt0OCYeKfbWvmwQ/90odTdbLu9umNhYAt/E7XtsvqZDFGPJpIIS6CILKD5jZ9xEkhTU/i+Gmxv3Jqg9Wn24EtlL7iN4gpRCMIRpAlByR2DpWQZSsWGh0cCuuCKujfwa8z4Ftmeqo/ibzAnn/KYilMQs/8EiMGyuwjzMiBwF5JpqmuTitM33L5wf12ntv7uWmUNnQWceMqpit9KRZa0UjUwXIH85yqhk57qCbS/weetWxGsrothcfwzWOokT0ztIGs8KbQtmPyfclmGo3XH6am/ugfmPZHe9jJ6ZX5LiBxzoKsqHzKKyHWWDWQBNUcnIcdMLqdzwmsgfJT/xv0Iitw8CvNVWQvpfZJwrCTZ33fav+5rWhZMIepXLrYLGfsfJ//nr59gIjztbzHEjM5pGn4ElRAF43gd9CZu89YpkUkMwReuP49dA8qdogJLDGsjvi560w7GUSkEiT+keCdgHU3YwGRny0TCuTFiwLQM6LqcbFKIzVC3gDzAcBFSDYPih+ICDOAXl3VA715aB2jvbrsS+7PDSLnbb2zz2qbW/VfYDH3XCsbV53bfsN6byivdznsZvZ+KM6iK13pZAZJRB5FB/VJfrM9HDv0/XZEjjVBWH70PrWCQWayW7y6WOfU1Be6J7O7sIDjOQD4l2MEr9yBwGmvgQl7+G1odCuDLWpwEBRewqtrC
 YW3P+5Gd
 0RD8QOCgqqps5gUOs6xgstxRIs3v9umWOS4P+SDeuO8imvuDuBlLAli57sPky4yfrAb0DyPILN0gV06ThTkg8CTSn/YgmmdgJad8SZWECQuAMBc2+tN3Lq0IQa6bKg8PL2wz6WIOz8Ou8h/KgKxvTCOkuD31IgJT0nu+/0WLm/wdKBt6sL7u/tvlImLs2dSJP3I3DITMcKGpRsAm2o+ijJJ82r42DgTnZBDYRjDf1jpFGC2YGD4cJt1b/oHul0qnAaiQMNbxsky87XaRi9LNh+zhzWdjXzLeE16UvNJQIYoY9Wa7bSHSHgP0bFhhrth16aYQ6bZq1LNqUE9xf9REI2sh8keNX5lA/Zi29oALs6gB23Gud5PjHQaRLPtJyg9yCU/dCsf1F6muqXjvo9Pph2fL3IL8s0SJxrg6nd2A0nvktS71EDdhk8hO7BQTRg3uVBsvi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 02:54:49 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> This is v5 of the "Swap Tiers" series.

Thanks.  I'd prefer to hold off until the next cycle, please.  As I
mentioned in 

https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org

Also, AI review had a lot to say, Please take a look.  Should you do
so, I'm interested in learning how much of that material was useful. 
Thanks.

https://sashiko.dev/#/patchset/20260325175453.2523280-1-youngjun.park%40lge.com

