Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42B38CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 18:57:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF8A6B0005; Wed, 24 Jun 2026 14:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C79846B008C; Wed, 24 Jun 2026 14:57:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B68146B0092; Wed, 24 Jun 2026 14:57:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A26F6B0005
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 14:57:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD70A40476
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:57:56 +0000 (UTC)
X-FDA: 84915715752.15.6D89BF1
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf20.hostedemail.com (Postfix) with ESMTP id 048201C0002
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 18:57:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fL/0ysjt";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782327475;
	b=0RTv1Yl4sy+ZAlM1FPxOEjHgCDpdmerjCua9/zeM7a+dGWReiYiURaujT5jPWk1bGI6FFJ
	J9UrP1F6rOXM1o1Slq5NFlDpa4p14ZeZecxoAEIgbHS9N0+1nqOjAVHNkT3Htw82Uoxt5q
	wJCLsf098dpgqWaVk28vZWzbJWZsYO0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782327475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mo93bdWIfXadU3JlsmoTA9FAy2jJ63ni0Cp8m8DNffo=;
	b=CDPhROidAwQJNoySq0SEHBfRYXytFDSV3Q1ThZ4fqyNccgdOtIyQNGQG6YcRj4LHfDsI0J
	VSrtePgVeeVazj7GH5CebRrJmxjjWTkUQXx7Ss1JokY1Z1x2thDT7/aiiEL+rO/3m+qL19
	cvwWZc0H/GQ86OtYuWif3xpI68Gw2gc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fL/0ysjt";
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 24 Jun 2026 11:57:41 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782327472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Mo93bdWIfXadU3JlsmoTA9FAy2jJ63ni0Cp8m8DNffo=;
	b=fL/0ysjt6s9uWnDzOcDwXWqPM58Y7CMtfrbAA9+HN8in73/dhNpk+zxZHeIUBA8iwJ74df
	SzX5+jJv+YFvcE/18lRg4UTiRNkjMbU1p3zwVfELA4p1ixdvivlx0503Kxoo+NAKF9i4pu
	Pso6VJzxjK9MykKA7wFVzKyw/Tgx4Ac=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-kernel@kvger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro
 and cleanup
Message-ID: <ajwojYJ9hzOXYaet@linux.dev>
References: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 048201C0002
X-Stat-Signature: oa77yuzckczgr7mssjziye9ogffgtzka
X-HE-Tag: 1782327474-833790
X-HE-Meta: U2FsdGVkX18EKIkwIOzUGZzfZi+9P2HbKHRrUVUdgdsTxiXaDL2JWvBaBxnhGgzUMEvO+wRbomMQLyCHOPiEDoCUq+zpWDZwyQF7lHRctbd6DFNSFz1xaktjJI1QktGtgH6/7Cd3AJ4tLuDKlEJdc9gfunF8KLzaAXD4WLYsbgXObhjaMnfpMO1yiOlOCDw5uAHRECM05hNpVPjEUVHbtqeMtagQPPNUYFqQFR0Xo6lT5AyKTLygVHfYe0UT4I1abxU9R71iUpq1DIPgmjDd/1qolZ5t3gfhorCUWskmEHBovFJd9iB+wF9zys41hSaR2N+yawUqXDo8ybTK72Ud/gAeCa0CtGrGGp3mb7Y1aYOQGKlDWnL6a/ZQRZ9p+0+BfELQbMuluNzAJv01j4BDheB0xK/7hetsOCjZQgiiGWFIDY/4KbEPmBtmNTIhVHVf1zCMA6uLPxGdXsYowdTSnQY5NlS4SsCwTEq9h49jY+54918iOyUAaknCcA9/JGEnJLrtWDB3d4rylDXVEOiaxWkpLrjflbvMo4jJS8Brb78IDMrh5KBgV2zMedK/HyZfCNqXA7SDufuzoFGnYZEyAqaprJ5jiUqy0FDKuP5qgaIoiOGzBhYUbMgUy6Mhooc3SHuJXusOAnmC+fy8uMhuu++6g5jq+kX34CSGliEDRupt1cR4dTGV+xJ9IvGdyGJMGCJPWjgrKF3Tr0XMlMVcxswLRo/ykHGznapU3VgCv1rqfkGQbQVTLYA71uc+jRp6SobNAZ2LZeHAqnFpTM2WiTEyc6Muinl2FSntIoZ/TGZ4PHoDniImG6HwN0NusK2c1tYcies5w7CKSNF9pFchkn/0y1F7hV0XBsnx+zvJs8YVs0Y19i2N4SKIj0+vjD0yvBE8GL+rYLOiODFQ97AyzdgdawdgANhVx83X/JIPjnXnPeH11qPOotB44k0MR29a+3qFl4FIz/9bxrlHqUS
 HInY+1/t
 xkgLXv9hfljbS5GK/ygaSnRqmBdNanQw8V2jAvSVfUKnJiANuiQO7/kMBxxUlx3rhujgWl3xM6+vkGaOz7smzfFUFTd0K/8r1oI2q8vyi90O70bKc435b4Y8ujoEVgdnZOL1ol6132oEhO2YdYQpVhowE5Eizfl0w6A4qurc6ULM0j8H9iRGd8IuBfHRNKht2OM8u24zktcxDI87DMH1v4jDRxBniqu6gPi+HfSZItcBDFSDr6VP1R+ei/I//aM9FW/fn7DoqYBb/PtvkXoJ0//5tmEpzn4KexfceiyuuqWt06ZyTB5PIgOMj9J/DZwk3dIGVDS4VCMrIdQ0vHPBK095mD1dX19+HComAX/849FgxiFgW6tB1SMmRcyWB47etf64m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 24, 2026 at 11:36:59AM -0700, Joshua Hahn wrote:
> Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
> last caller of for_each_mem_cgroup back in 2021, and there have not been
> any new callers since. Remove the macro.
> 
> A comment in mem_cgroup_css_online has also been out of date since 2021,
> when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
> code") open-coded the for_each_mem_cgroup iterator. Update the comment.
> 
> Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
> statistics and events") added a second declaration for memcg_events to
> include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
> Let's clean that up too.
> 
> No functional changes intended.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Thanks for the cleanup.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

