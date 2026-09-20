Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A816CC982D7
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 01:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B29086B008A; Sat, 19 Sep 2026 21:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA8A6B008C; Sat, 19 Sep 2026 21:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9416B0092; Sat, 19 Sep 2026 21:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0F5A6B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:24:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 499A014033C
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:24:11 +0000 (UTC)
X-FDA: 85232394702.13.A33A31D
Received: from mta1.migadu.com (out-214.mta1.migadu.com [95.215.58.214])
	by imf01.hostedemail.com (Postfix) with ESMTP id A9AB740005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 01:24:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ckAnbcnU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789867449;
	b=JWu7waYzM/xOEpsuHVCfZ7dkeAih6h+DOSMVvEK/vm/vXeaGC9WGyxkVd4+Z9s+FNyNwpu
	AbuUAI8BX4WcKA2XtRt1pRGxHeQzwgmZ8MhaE2cVUUBiQ9SV2XbPXXuKdBUnSONEiRa9Zt
	k3zQhG6pf3uTtgHA/DZ+TdphG49OhzQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ckAnbcnU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.214 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789867449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvLDamAPpKO4oLlJ/2HOif1m04T7n7lQ34uGzirwv9Y=;
	b=jWQ2s/YQLsXsHuBA5NFBQb7tE1LcCVeQ3gEbBmaSB2GkODGfFrrbcr9x0lS0CHHlb+G8KU
	68mBKaiQDdh1/HcmuoDeEBOSo3kp2RCDKCXngjik9abzYILXgMbT0maCAbfOjdZ3BcEBPb
	DFxY2s5uGvXmeama6LZ6nPT4PnKVO24=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=cTTrp9axlZ0to3dCBI38xL4Ohm3ey8g4pSyLYyyl0KA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789867446; v=1; x=1790472246;
 b=ckAnbcnUmIo2zFVOXSRoH5KAorCkTD4kNL0/+8Ki5KdKNduaFVHKt8Uy88E+YTWOUpkDQlln
 Z+sSol+KPF1qSQPlhpztrCPd9kwVi123Z2euTt82yWH+u6iqJ0aKOAybEdrREXeIYZXPV8yQ24N
 EkhlOR4qH7Eo2lUKzOwcKJZI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4d7949eb6cac6f80;
	Sun, 20 Sep 2026 01:24:05 +0000
X-Mizu-Trace-ID: 4d7949eb6cac6f80
X-Migadu-Flow: FLOW_OUT
Message-ID: <e2425a16-d57b-4786-86a2-d0f25537d605@linux.dev>
Date: Sun, 20 Sep 2026 09:23:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260919155716.86019-1-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260919155716.86019-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A9AB740005
X-Stat-Signature: 3ne3t79ibxofruiq8smsj5bgcayfohzb
X-HE-Tag: 1789867447-261859
X-HE-Meta: U2FsdGVkX19be7u64WF3WQAbUdEHqfag4liM3nw6RyN0XngJLXOhGs1A37Yt7JtB4fEuvA4bW+jUNsf3CnY1y9DNbNVaHY55HhXKxuXTsaC/+lIf4LvuvOJqD6SWBUYrvj7LPnlQx2WhRSYIcwmQ9veSQ9Jke7J9TTNLXtIM+83YsR2UvRsfGNk0oWwLwkz6+VJj1hrRW/RRBtbKrNlYphYVMBrjprSc5YPmN7SgLj7ovIWX1S8I5IkrbejuNMDPnV6wPgpPr3fYmAswBhdqtWV4fn/AqKp8aHxIQymhhbts7x4gHCcyCj+KUPEkyraKrgGRdgk79C6kbFEmXQIlw6N778Tmnhf32SSvB64nyQ6Y9pjDsfWmzV7uIduXs743o7TtAi3x+/JfFTR7QarSXeccwJkWD5oUjPDcFeXGhsCSipkD3DARBOhweTq+sAwcBR7KndQK/C7nMPxxek9p3/gRMMhEqSQaEECiqCf0htWrQNHQGZEyutmHIxu58Q0IROC6ScVhU6zavcyGO7UNJliGVN1TYGI/DuxEI8nUQAF2ox27eiyqHvGM+eBjxw2h404a2bK6fLFPnjysNNgSTBUQ4g8Snsajw1S6/hsldou7ktVd0IafuqjU22QmYinhaPtHXHXw0zkDCA9c+LKkkQC5a7UXal1omQLCdtXsFU1rwHWaBx7Bj4VtLBW827ms0PL0ZNzymWNER8y6ToTsdWGS3w81fsaBzxVCgJqHyF7RlbqY+zf5NNGVaRb9+yA1dHOTIBnt7S6ZVmEPsUu/wjuTeiPt3UHMiahZPZgJk0dvJXLM1tHeYQyWqAn7e0bjNhq/1aWQN0RF/BBKj0koyzXxPiDhwp67IZ1AdsIJosmkpdGhlM4G0tifHQJwMSZ5+0j4OPwaWif7fgIb2a27irD9iIOk1KmIvchDhcDcpcYawUTylypcouPGg/6yKmpWXAwoRhi1WHOQ2H7tc38
 8wZg6zoj
 FMyw5qU8DPQqMV6DbMV4794I9vS1xhEL80qnztzykR7hlwQSwBAGyyNIGU4f1WMa+ZKVr6JH9i66SUpQHr5ASCkGSRwQcHeUCH1EUYAQG2eIwRrNleSgThockKdjNcWkQnY+3Ib4aNpQgnoruWdHhYj578EK0tOBCicHFQYQ4QhtpROKf/mdYwsdCUcMuSNAMTKYmp/aPRrgRJR0JoiCRgECGgczRQFj3fDkTpv+bDmdfnt/uLWKCXydr12hPUHFodsi9Po/s1UUYJ7mw+kabWh9l3z1ArtkErllZ7ATwaLaxK0K9oLiAj0lzbdBkAYooGTzN4TKz9p5tNvnvWCmGeZOr2Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/26 11:57 PM, SJ Park wrote:
> On Sat, 19 Sep 2026 21:02:30 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:
> 
> > On 9/17/26 10:21 PM, SJ Park wrote:
> > > Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.
> [...]
> > Similarly we have more definitions of NR_foo in damon.h:
> >
> >  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
> >  * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
> >  * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
> >  * @NR_DAMON_OPS:	Number of monitoring operations implementations
> >
> > and only NR_DAMON_OPS is actually used (I checked mm-new).  If the
> > preference is removing all unused macros, we should probably clean them up
> > as well.
> 
> Nice findings!  Please feel free to post a patch for cleaning those up if you
> don't mind!

Sent out now.

https://lore.kernel.org/damon/20260920012028.9565-1-zenghui.yu@linux.dev

Thanks,
Zenghui

