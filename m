Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E94ACD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9A46B0005; Wed, 10 Jun 2026 20:07:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0ED6B0088; Wed, 10 Jun 2026 20:07:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE086B008C; Wed, 10 Jun 2026 20:07:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09EBE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:07:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 993661C2DB1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:07:00 +0000 (UTC)
X-FDA: 84865691400.17.D93858F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18183C0007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:06:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nK13vhrB;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781136419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ZiqRq+M7qmIk1c5q+OVo0ETrzZ8J3PZC8bJm21Xrmw=;
	b=pMhb/jbo++mQQtP/nBOQ16K9Akzb6/djTAtoowlmoHgILZ0MSVYWrp+kpRgwH/Rqqei5nc
	b1Hcqu1crqdV2ABMDAKa89gFiImiXjKqlbr+DEqvmwcUKIl1baLaHGevet3Cc3rIdJkM7c
	v3lhJsfHj1hrbxwTbllK7d4rdsfX6dc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781136419;
	b=PoogbIhJTznGeOU7Ha4ycX896p8jq7xR+wIJQfhbT8rIEIjLbig0SmRPgoyl2bQXQADgnq
	5PuqJk3xkbzGI0wgOKhYHCnMA0Alca2ThOSOpqwNdGiaUO8lM+6Ln/WyqsVc8a+KoYlZQI
	askrQkdj+kyVrRPo2x5Y0+ZnJ7f4SdQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nK13vhrB;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6923460204;
	Thu, 11 Jun 2026 00:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95581F00893;
	Thu, 11 Jun 2026 00:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781136418;
	bh=6ZiqRq+M7qmIk1c5q+OVo0ETrzZ8J3PZC8bJm21Xrmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nK13vhrBbVYUK3fkIigBoyZRmWr3HNoCWYLMmEinbOXYrfWmN49FxDfGBMrXf579D
	 UVNQD1X2HKXOqycminDynETvnmfGL96Jvo8Eh8MtMgrpnk01Dr2i6+5/ifOdypM8gn
	 ov923rhoVIr0KBLcylMaataHU/0yi7vhpZXEdLDHhYPmYscQgrQIawaDtY8tKL1gX+
	 sjQuyQkd27ub0DAeRcF+ys8E4DLlWHoPiFxiYwOeZk92kVEwwi9Kt34dH92ZwNfljM
	 K5S8jqnMFA7PDFqEInmlIxRA6N3zv7WeaYvGhgojZb1Uq9BiPY7l8GU+SwoGGjzmUG
	 FxgVS3Q+0UMjw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v4 0/6] samples/damon: handle damon_{start,stop}() failures
Date: Wed, 10 Jun 2026 17:06:45 -0700
Message-ID: <20260611000646.68793-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610135546.64943-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18183C0007
X-Stat-Signature: 86y3x8bo35966hcq4bpaq5j7ioco3xw9
X-HE-Tag: 1781136418-448591
X-HE-Meta: U2FsdGVkX18Vpc/G4FoRVie4aBKw6nnotguOB10dlowdBKYicIuKSFc+OF9FiJtIROArwKJVa3PEmdMHvAHia+XThXJhVPSU6nvch99s9c8TOmaH7owZ3wCD1O2xPUJRmYH80RIo37vuRak4aCnWRwc5zvoRSJn4gnV9tdl3EcWOH7DxnzMtW/7unU8/SOrRlK2Jizy8MIoq1HW15VzFDOwXRSN5hAqktccst9Q80iq2HpmT7LlEdUe0AcjBqMQeVz0JiU6PJuyg8aecxHi+95JGDFWFHMO9dxWJdI6gNZa5f1qZdXbzI8YcX6x/unAViJ2UBnTOcRBCwgJXddpPSTY6nT7SrfSL1Aly4vfnVqOuGqhLGnHTg7K+KX3+F9TZbOEDJtCOHjGVHr2Mss4CHvJvR0F1kW3fDjFhYDJoas1QJuh2ZlwYfyy7KtAXTjkNFOiCumBfS8pvDoRy/h/1VxNBF4sFdmevmo27HcNh7ASaa/B2GUagH7VWTIUHw7YTc8b75/sNG2APzgdH7T30fT0zhgm2ER8wxhtbS5Q/gcnXdSnBNvYoKe/690JiRYPbagQF4WDQMprbvcCfORCWwYlkbSGJJLXR2k0mJkDQnJAoRqnWBwLq8xQU7CgsWIPvEBGDdjtYQdFGgloVu6wubQeU7qn311SdLoVIZpU9OpOmsAegnxXU4foRcxbNWiQEpEeIXKZBlrxm+rrHbi8yd0ouUwNF4XlosE/3QZa0ro9SQ2brkFtGukEMLo+294+58SNDfwm9tOWH0P+SPRTqhaz05mPHEUqLB8FiNkLSpwSOh+UPVp04IJDa/EQ1nJ628tSZU/84VBTBvwZki7TSALQDqXPyTVZSGIPU6SPbRsU7OWJrHzxXE6YvF1JbHAThjfdT+fIHgjKmYHoXy533+z5StAAV/z/i0XI9d4iQWtige0mqd7FZVO0XH0b83sQOHMNNdiKMQjao0IrlROI
 DlG4qpsK
 9lpFE3WD35jeMQ0n7zv418M70K5t4e2FOWpY0IYG+n7qP0GJQpLp0hZfGVF5+YY6sgLJuBwCYuDUaYQ5h1nmAFt+/t8oBpIh2bPP0sU9CF88G5KGS4YEIkqczbIPXQ9Cl3sIABRjAyT31WooSnYd6sAJqiuowhPe6d5UEJzwusKB3eDiLXO3/f2VpZzPxiDZvrjX/fYgT0FpyFHbcOGjuc2SJhQxpAGCKeJ5Tr7cuCaizwvKL0A5+EWxzM5XXwpSZnwkVkso5zU/Hi0tBJoplt7FFfPppKA67J0txkTWGtkglSaA8wgzNTmcihNwhzdk7MW/Ty60oHFFN5DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 06:55:38 -0700 SeongJae Park <sj@kernel.org> wrote:

> All DAMON sample modules are not correctly handling failures from
> damon_start().  Among those, mtier also has an additional problem for
> handling of damon_stop() failures.  wsse and prcl also have a problem in
> their damon_call() failure handling.  As a result, memory leaks, next
> DAMON operation disruptions, and use-after-free can happen.  Fix those.
> 
> Note that only the damon_start() failure caused issues can reliably be
> reproduced.  Reproducing those issues require the admin permission,
> though.

Finally this series passed the Sashiko review [1].  I initially aimed to drop
RFC of this patch series as soon as passing Sashiko review.  But, the size of
this series has been 3x compared to the initial one, because Sashiko was
finding more pre-existing issues for every review round, and I added fixes for
those in this series.

Due to the size and short remaining time until the next merge window, I'm now
hesitatng.i  The last three fixes might not deserve to rush, because they are
relatively difficult to intentionally be reproduced.  The first three fixes
might be better to be merged as soon as possible, since the issues can reliably
and repetitively triggered.  But, still those are sample modules, and the bug
was introduced with 6.14, which was released in Mar 2025.

So I think it is better to give Andrew and Linus more time for the merge
window.  I will hold dropping RFC tag of this series until it seems Andrew
finished the next merge window works.  Let me know if any of you have different
opinions, though!

[1] https://sashiko.dev/#/patchset/20260610135546.64943-1-sj%40kernel.org


Thanks,
SJ

[...]

