Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35715C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFA776B008A; Thu, 10 Sep 2026 20:34:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D87EA6B008C; Thu, 10 Sep 2026 20:34:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73186B0092; Thu, 10 Sep 2026 20:34:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95FA16B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:34:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12AF48066C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:34:12 +0000 (UTC)
X-FDA: 85199609544.26.E2BD05F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 64C6520002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:34:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRkCWV+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789086850;
	b=CIlylrLjvNBG84fR2bgaV057G5ndPnKicZy7blnIYRa6v+xyNgf1l0Okc7G9wyOhUMtMr+
	31SlabvZR1gB4xR0ouFMEvXaVzIt6hlyVx8qaKvWGXYgHEVSAgRmM9wABLu8377oKq9d8Y
	0VfbAH6mmfJmp1rd6GVntnyeiBJiKFI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LRkCWV+6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789086850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lHJMx7oqC0abhZJRPC6EZ/lpB5QzLF/Uxrh+RqEfaA=;
	b=6DtCz35wbkqpO++Y07cZwzdlqjiS1Zk+DUiyE4G7h3OwG/1mnFaqlrjlLpiWIJcF2uktt6
	4XDK628bNyu/av5+WEbYqAJHNH6i+7lHj5DgSFprf+gnUycQ51+BQ87Ga3KzVqKCjOiRXb
	93T5IT99zVV0XolZN/IaPtYmwn9OUao=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D653F601F1;
	Fri, 11 Sep 2026 00:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0166D1F000FF;
	Fri, 11 Sep 2026 00:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789086849;
	bh=9lHJMx7oqC0abhZJRPC6EZ/lpB5QzLF/Uxrh+RqEfaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRkCWV+6NtfpT16NZsCqsUyUufxp/ReZ/SfZzFG5LRFFwLcBW0ZGleb+KyBuaCONJ
	 IwH/dXNWfqxbGsaAiRA3Qbq7FTxOQOEhi068OI91SOuJEcrmMLRqA9A3TqzY6LYJ3J
	 A+y5I4Th7POhVnistBnvsfAMKV+R5XlfOXZi6UfDisd153oPhz5CW9GewwvzoBaCKv
	 o4iCfmIErROPPcLPrb9NmDk4y3kuov+RflqMe7SL9zgcqa+dHJNBZqB0ZX4Dk6C7py
	 XpVQayPMRLKp99j+Tz/3xTOQhlG6+mAXVtwFeXdvmcrRJXWlkk3L5L03oflglAoaH4
	 512yHMXAyyGZQ==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akinobu.mita@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	rientjes@google.com,
	weixugc@google.com,
	jic23@kernel.org,
	gourry@gourry.net
Subject: Re: [RFC PATCH v2 0/9] mm/damon: hardware-sampled access reports
Date: Thu, 10 Sep 2026 17:34:01 -0700
Message-ID: <20260911003402.90722-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260910171623.6638-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 64C6520002
X-Stat-Signature: 7ohemdba3pbur7gqnr91u41fagjxok4g
X-HE-Tag: 1789086850-994727
X-HE-Meta: U2FsdGVkX18iGa2FX52Mqw+k0oNQTFcQUUXwCbUCk8Vinp0C54bFHwtf7H9sWSWVEkzpLW5Fx+UFEN+STDRDkvfddU5UZ1Queh1eDfa2POROja9yTWZxgzbacsQdPA0dhU9WfgzsfPk5IMDL/f6Ubb/dNod5jAvVE+3/zGYF+TOApTWHZdZ4tc2wmNpw652KNwNwpR3VIDVmn8KKIhKNYOB2lUyQxVfzwxrFrVKjLTdOZ6RGry0bZDVSrvZUv5M83TzAz/w1brEhNHxVUx5h82wY3uI/7HTfunKrWFTRP97zxMNyCLoBbJoyuUnwskwwxpWvtoGUb9ghcLrKuGwJc6yY6V6T5kx/a2zJNsBhxF65wSxfb7Pb4JqnI3UXfoAZITB6PnU2rY7sINi/PXL6UP5m2/i4Pep3EbX54XMUpGbaE+/1/MJlh/ij/byFNYYbikf64Z1QnT049LE/PxPJPer2fhz/4PinuomxwesOEIioM+wbCWqwWVbSFT0yd1q5BmK7Tj8LcbP8ic73s0vFy3CcFq2hDmSMxFB0w2mZyxW1CeAAtIEMvQDxI5syzJY6K7lx9HxnW6z/80exrMGyB5JmKsrDgQLk9hEkRPjWXiUSxFhD4wSIzp4NP5KTAKpNwWPBo49xXqdoNTTQ5WEq75rgo8GCqOBVGcMVMuFqxaFxw6jcIV+qCJhMSDS3ck5SEe5HUqFKUMvg7tOzBTYoiXLlEEahUEAaLG4+FjvCK8clObZZh78PElW33yv3p1RvchoQpQToLK76MaMn26pGwiACJDUKMMTv3cPgN7Rx45G2/e6B5b7BrM3/MPwvNXXLIfft8/yUTA5X5UgrfnF8aRIgs8N0kze1br13Gpg2Us2QSRqMoWJJNjA94WXCsyrxzNbuV9RTqyFKkhvzrmGfWYNnmi8jxLIiV9B+ECvyKArbW/spb9xKtYozNe/Yx8LDggqLLsFbO1z90q5ap+l
 oScrMx8V
 Ouk/QzoFzhf5uARWKhboiKcnUXIsRvaIZzcJfQSEKE8oYwWoKoIIgzUkaJtqJ4HzWF6aRAmdA1vqM+/YpxdIpLvMS2eIP2ojMYP1Z+go7K+m2nsgiyQCOhCeHfT7VI1OL/o277cQf0p/n/sQ2CQYPbY6om2DP0NiNVjrYrAShsCtBYy1xtMJVYGigSfGG/Iu5LrXle3niHzJPXRxN/Ldyl6+EiFvVQHGvE7CNVVMOSUJ6tn9BLTG84KsuLQrqkJ3/MR6mMdL3AkcPIdcE9rVyWYcy8EmusdFwQ7kFLqDV7mk2HvaJjBe2iIWWpq8+SKrTJtZeCA0dfA6T8v4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 10:16:14 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series lets DAMON take its access information from a hardware sampler
> instead of from a page-table scan, and lets a scheme's score be weighted by what
> that sampler reported.
> 
> The change from v1 [1] is that it is now built on the data attribute probe
> infrastructure that has since landed in mm-new: a PMU is expressed as one more
> probe on a context, with its own weight and probe hits, rather than as a
> mechanism of its own beside the ops set.  The rest of this posting is the same
> substrate reworked onto that, plus two consumers.
> 
> This is not a merge request.  The series is based on damon/next at the
> base-commit below, which moves, so the tree it was built and tested from is also
> on
> 
>   https://github.com/ravis-opensrc/linux/tree/damon/perf-rfc-v2-09-06-26
> 
> It is posted for design feedback, on the substrate and on where it belongs in
> the roadmap for extending DAMON beyond the pte-accessed bit [2].  That roadmap's
> second milestone, now open, is a first data attribute monitored through
> `damon_report_access()`, and that is what a sampling PMU is here.  So this
> series keeps that function and its callers and replaces its body: the reporting
> path a hardware sampler needs cannot take a mutex, and the drain has to reach a
> virtual-address context as well as a physical one.  The shape of the ring, the
> drain and the sysfs surface are what is most useful to review.

Thank you for this series, Ravi!  I will take time to thoughly read and reply
this series by the end of this weekend.


Thanks,
SJ

[...]

