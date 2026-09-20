Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CF9C982E1
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 12:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2597B6B008A; Sun, 20 Sep 2026 08:35:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2312B6B008C; Sun, 20 Sep 2026 08:35:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1473E6B0093; Sun, 20 Sep 2026 08:35:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC1576B008A
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 08:35:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8B4C1403F0
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:34:59 +0000 (UTC)
X-FDA: 85234085118.16.21E9A30
Received: from mta0.migadu.com (out-52.mta0.migadu.com [91.218.175.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 39D7B40008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:34:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XaAV6Fw5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XaAV6Fw5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.52 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789907696;
	b=MwZ2oxO5WayhokdlWxXSvguf3FBAZILStpHnCgXMcoRdKf4hnth3Fya0GHmAasFwTZQcjL
	p9vx7IXS+71fE9DhzwsnzuoOe+UxV8MJI0JTh2+c5zTzEgOiGvWy6xD4FwjQxmjpBxCcuL
	2tXj1FtWRRS0ROnoAlf4C/tpR6p0wYk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789907696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0IIS45fbm17SPpy920em8aEcQeb2Dxy8IYiGeQDSOU=;
	b=TuAoBX/0rENe742CFf4AWRLY2SuQ4FRksmNAe9PieDfO4y57TPHa+Wa9ztff7rseG/dINh
	gQ4Ei5KGftQwFqnJPgax8k7+DYbiw51k0xNyfFOoWX48CY62One1V4MchPpu7sMrpK8cgT
	x/4RW8qS1rRZcxTUulA4zp50jxxLqMs=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sdNk5ihNH2e62rxLPJrJeu8kriaPZjukMTNXWfJ6eB8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789907693; v=1; x=1790512493;
 b=XaAV6Fw5xRx9xSLTC/tHHGWs5gPs+wRZbCC5dvevsE2mMbPibZQ0GAJkNOfUtBuwkKshuyDa
 G4qbt8+w1B4gNRE4uCDCNhSdInfWaa+c+OW/bSHvpFhpqLo5BeIHL7tm3FR2TEyQlzGbXTX56wv
 ko/MRAde9HZXgU9+jleslAEw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cbc0d603ec100e35;
	Sun, 20 Sep 2026 12:34:53 +0000
X-Mizu-Trace-ID: cbc0d603ec100e35
X-Migadu-Flow: FLOW_OUT
Message-ID: <e0c63f91-4d33-469e-a584-f97fdf8c3cc5@linux.dev>
Date: Sun, 20 Sep 2026 20:34:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon/api: remove unused NR_DAMOS_* enumerators
To: SJ Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org
References: <20260920100029.46849-1-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260920100029.46849-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D7B40008
X-Stat-Signature: xfkqmro8ej46z5nqng4rgrtkmbr1e69o
X-Rspamd-Server: rspam01
X-HE-Tag: 1789907695-598256
X-HE-Meta: U2FsdGVkX1/KBKHrWT4AY509LWryhiWQXpGWpc4tgg/aCiCc3lLE5Wnz0sOcmrBvqGT4/sKnwGKaRnIq5t+i1DsfdIq5tMSCz/JoCTJl50ifxY/+sVmqZI5vjXm/QyXotkuIoNraIMzdP6nx4P/19ZToCT6OdRPJu1Jciz7FokWTH/un4eoF3w79j5jGgq98c9o1QlBlX8c34Wm+4PsS0RVonTU/LJUrE12+tJZxO3f0U9lL17xSxyP5uNx7g4RaJZ2MunlvVgur2KTeFAvsuwdfgZjx7Iphtswx3/cQiotVc8Vl1/R2xq8cQwMzTAEZ4CeCaqvra9RA7HhA16sFvRpPzoUN9qCG56bzzaOHoJZFqeSIHnKh/+Yl7d3bVZTsaCSEq5VVLlQVhkqIav6fsiNlGuCKyuOOnQm0rmIgNxmM7fB7eGjUW3+7OgK3Jdr6lZ939nnlgxmXy1liX84/m2N/RHVlgqKWZ0EnPFq1Xy0m4E+4TirE4k3n374aYjmBBA2jLh9YgJuI9QtW6chInyh0ms35nmCTq7ODjBif2Y9guc+tkefGbbVxslxtJ0Z4JPUoCi8fhHJW08LqkyXTgKSkgDpC062igZ+rUUAXD63iueLxPtCWIs68O030FVsVg8turImj8JU67l4GcB7qRS2Tfeb+kLdxSZOPBEpCoMoaJkuVIJxDm0E62OuEZRGnLmscrCNTiFO7LSXwiOBAJP8AfbslfogG6POjyh40+3xkJp+Q7ShE9Z2wUPtukZFv+Ai5lUvFNICncevPp1oIf847Q127bdJx7GgSB6aOLBqCDmTCXLbTo+vHvvHp40DYfO0h4NLgsYRb7n8FPkwsVGdsiYJlY/50/uc/mElyUvBL9Uu+fbMw853ILa/DQXQn0vOshaZiU8or4vELe06Qjr0V+bCOzjLZjVOueudvQO7i4KhqvfME0VEAev1KIymu5s0ozh2TiTTDH0bUcXH
 qFM6QYQK
 ILc2hik4UEJ0GtUf8rMvbCnyDIXvsOpEpezR5bJJ1GZRYUn0zhFaKkLLKG+d31Q7bew+ToXPDycI2aTXOqwvpR4K8HM4QucuTg2fdZMBS/sOaNQegLHdG4FiiLLu719RC5rMLm9t48dOWpXxIYdTwBSr3WnNapGt74WvRKiKmxXX9rwh0n6pQsKe6QvlbOR+BsDIOZBBm+9hiiVcmk/LSb8R89nqb/rJO7TI2LnLlt/U7RnYsZN0qWYgrB3yIhS6gPCtqDszxIMOLnu9/ljQADsK2RpUIZzw4exp5XlDiXF5RoPN7F7HRIkMFAWKeU7Mt3LMe8ejzrs2MrhG6suCVYmWOpagm8sPhHxM+LFY2fhhwAEeiJUTIK6CqWsrKpTPRLb/f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/20/26 6:00 PM, SJ Park wrote:
> On Sun, 20 Sep 2026 09:20:28 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
> 
> > From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
> >
> > NR_DAMOS_ACTIONS, NR_DAMOS_QUOTA_GOAL_METRICS, and NR_DAMOS_WMARK_METRICS
> 
> More than 72 columns.

I learnt from submitting-patches.rst that

  - The body of the explanation, line wrapped at 75 columns, which will
    be copied to the permanent changelog to describe this patch.

But I'm also fine with the 72 columns rule for damon patches (or for mm
patches?).

> > are not referenced by any code.  Remove them.
> >
> > They can be reintroduced if a real user comes up.
> >
> > Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
> 
> Other than the above too trivial thing,
> 
> Reviewed-by: SJ Park <sj@kernel.org>

Thanks!

Zenghui

