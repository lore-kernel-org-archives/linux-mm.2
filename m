Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E5A6CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 13:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A456B008A; Wed, 14 Oct 2026 09:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112F36B008C; Wed, 14 Oct 2026 09:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027A66B0096; Wed, 14 Oct 2026 09:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDED26B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:12:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6576D804B7
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:40 +0000 (UTC)
X-FDA: 85321271280.05.E21092E
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8F84C100012
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hX4TMtoV;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791983558;
	b=aztgHK5rytkbMqO+2WLGiNqd1qwXNnVrytTkOquHqGTi59ct+NDyrRlQZTni5qr/mWOm1p
	Cp6aU0y5s9IDWiA/Nzhgg51+tokQiSpgqgaMR+O50t8wT5nlEctJmRITcvPcOeYJ8SBsaG
	7CEy2ZeG2ta5eKMeSJT6LH0TTlpyKdw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hX4TMtoV;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791983558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jEpV9CpjUjV+rZO83DWrS1XtF4LOaO3+hdRBygY+Bw=;
	b=IBArNg9hXdoGTCbjVoi7/O81pTMsj/kHcBffwb35pXDSByuhNyYnFF/dzpGPJxTVAPUpdD
	OYiwSUnzA6AEWoPcyvcAEDJFp4wbO8wRrQrPXvMFd31lqPqlc5gI7Kj1SOILeTeFqOMxHQ
	i0cA74g2buN3OcWKU2Q5VMOSqyg1w8E=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-533861a59b8so3534801cf.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791983558; x=1792588358; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7jEpV9CpjUjV+rZO83DWrS1XtF4LOaO3+hdRBygY+Bw=;
        b=hX4TMtoVb9FxpQ5IWHVGu/ngT801H9kUPlMCVGPYyRSa+pvLkFND9VJ3V0AWqiNtlP
         yZYB6NljCoiOjgR8eypIGOeKZmr11UOAdU/CKz11jGqdz75vZyWzFuROS4K+rQiGWH9L
         ww1iw5ULZWTZDfPBlQUTLtZZMr9pXbuQFPE87Y3nopuaDeIFLiY0kkzSTJuMldgvPSdG
         Dfcc1bMyuBurySubJNiHK0i0kIp5novlXsIsBK36VmBBIWLYIh1lP5N4E8LfDft5HZsN
         gxKhBygx9kN0XD4u+c7mdrPruiY72Aw+fY7+SMW/3PLOiwNb/t64lfq1du+2937q6iJz
         N7dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791983558; x=1792588358;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7jEpV9CpjUjV+rZO83DWrS1XtF4LOaO3+hdRBygY+Bw=;
        b=07aYrZOXbhNFlMT7mQ0EuyU0igbdjfHO5maZvR+oyMKq5Q9PXxQDrKFqMuAQdYaJpE
         MkR2LZ0GaFyuNY3XlUXRTXRMhw/mkJ8KCfomcOIz8Ex8OklPbbHWbG7ROYdOS+/5uioZ
         rLka0GK4hIntWEMUxEwPZhfSxdkdGhI5SjxwUxWI8t9db9q6zAwgMaPDlArZZWyGLUIu
         Q75nGy/MzL8stVBXnCcNCvlZIvTRCmUTaa+InMDZPKU3CeSg+jFaQESmkHznWSwMUyIx
         Wn4SIO4eh0bsJD/NzY1kPVLe2kDTGFHb2JORj5AIXkk84sX7gfrQ3QkIKx222Ca4VCaA
         J6dA==
X-Forwarded-Encrypted: i=1; AKwUvBzdBUq1T1qrKmSa6j5RULXrI4e77mwPhNOFtGBq/nBOh2J+PNoYk0FnjiomobeISWkeNZZBJ8dI1A==@kvack.org
X-Gm-Message-State: AFq9FYJjCO18hUMY2XiYNpO7PI1qYkx/N+kV3Ok9Xu5lTpZxxz2ZtCor
	A/2afX7vpMyixHAWcGeFdT4occHbLw5o09MdmBImhjkx1tKPaIjLFtODpC12RfLjCvo=
X-Gm-Gg: AYBFou1Ot4h5S2rXOCliArsAMbbucMEhRwKQm74XahDbH4F9jT2hDCNO7UOQXzjjgKF
	fAY33A8umFRYclqo4U80uXsKJn0VbO8dbfunUCfpt3Q0aDds3L7pH6WKLJ/Ft4x326+gFe9A3Hi
	y9oHmw/HPcp5L33bwY7U0Orft4TGONNZe3xveEaioq2yeKwB9ZWRzWP8wd2tdcaiq68oluCP4ei
	OFEpdXILY93S2wQAOXgThwQ26P+hsidWJ+XRNpih9rUMOz1U5MFpqOPLkD+MG6ipAZp7DYW806I
	y6yiIaPA9h7zuldaKfvfnm9X8ewZ4nI0jMbKs1VKPgXXAClNC0lzvewJUCwroHFf7cYO5YNYKko
	19yv0mDhVwj2vAbdRlMnFgvNwozGKgK9SgqSSYR3DaC0PjSBuQzxKKBbMBNzLyLootV7k51gjLX
	PSxCNgyp+mgZzewP/2j7bjTHtLGgdhvK9FffQ5rNse0wYkdHDAJvSXtqoxt482Vp2DT5rOi7ol3
	+uu+/GAYYptORPs1e2QyCT2CYg8gl3vvU0kiUP9F27ffY3lJTTqqVs=
X-Received: by 2002:a05:622a:511:b0:533:3ec8:a834 with SMTP id d75a77b69052e-5359fb3dce3mr261396561cf.40.1791983557461;
        Wed, 14 Oct 2026 06:12:37 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5359b6fa173sm124088821cf.7.2026.10.14.06.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 06:12:37 -0700 (PDT)
Date: Wed, 14 Oct 2026 09:12:35 -0400
From: Gregory Price <gourry@gourry.net>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	joshua.hahnjy@gmail.com, ziy@nvidia.com, mingo@redhat.com, peterz@infradead.org, 
	mgorman@suse.de, riel@redhat.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, vschneid@redhat.com, kprateek.nayak@amd.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/6] sched/numa: fix scan-period adjustment for shared
 faults
Message-ID: <as9_SwmLxAcTovnl@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
 <20261014094347.99157-4-lizhe.67@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014094347.99157-4-lizhe.67@bytedance.com>
X-Stat-Signature: tr3cbunx13fmatd8i87awfiep1qzgcx9
X-Rspamd-Queue-Id: 8F84C100012
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791983558-351812
X-HE-Meta: U2FsdGVkX1/1QFlbrFgDW7sM7IqoiAEEHaN7fC9GGnRczXYn4nzTKsIVfGxNqWY9XYPv246ybI0WtdKhRkbVuWgYSspNVFvO3qfr1zcugAOW9NXRd8T85+Lta7jUm5ZQj70JbJrlZNiN5VnH4aM0/lvgN4QU0n5trABBS0fFsO0Q8bH2ZeJNTUSUV30BTFe8OCWTUTKM0tGjX27FJm9LsmMx+3I48z+WFgxP6NgKGCCiGhen484Q7OsmIZqUCRRy/4dOgehIh/8ckHecOY6/3bFvUuC8ugKKdur8omNISw7Vl9DqcVX2RgexPTjMw2yCYSOIAtomW1RSp2N1S9iYc5oNOOZkgelhUUT/OS81A/BUnMQKKpLaKBDotbo/JkzAG2zNqPaa3pMZlRIs4wSakqXGYZPtH5S8iLEhSTcAiwGpP6lZmwxvmfMtG4sVobnaSgm+Zac9SM3L7bzWgDdnUt3dNuzLqpp5I9Wxkj5mbYhsMkA7tdQi5LEDW0brndbPoMM8VN5gmZ2DliD6XNOHa4qtzt922OyHdIsJEcQlpBMUEogyI4rSsXgIIMzrpCSTbBnHXiIM+lqCiU/28lUnr+QT+L2N4WeppXPQTvAZREtO04lDXpPBP9ZOKbSv3FR+wfAjpXw0C1FNBiJJCVPIdzwh+TJxq4pPtZet8uWrwmlpkaIsCVyw+bh1nyG9x8ZzId7tNmO3E9JVybYfqyCb1WBv6BjPVT09f+MZbxvXPwbCBvMcv+PefzJiJk39oJGK4cKB3yG4lOKu87ercl8+dP67ogRmZrQTRRGRPTa8NLswIshoqHdBXEZtS/WwTIZMXw/pPFDc6h536CJ228x1bCCGsngW1NvDF0ssiyxdG6RB9FYUg9SaACynA6Lx1d2lw8wAEt5MujBAU5rW+jbZDRUUiBZZ2hHOBe8QVdY+axXs6oaqhIS4rh3WA/rAd9DiDobwQje5fKsKT8foRbA
 JI0h5R3j
 ZP9E4bP1HFR1dq1FbOGJbSgu9BiVBI65qYkI86x5KLDimTagXfhyHKcKs/m+nROgKTNd1RRUHBUMiDSTGs5cacWnf4lUEIeB0HjyJnaLB/Zfn0k/UL9zDm6kDwrOAxkXNSvyZ+nsjNxIwsa+mu8rMRCH0g/u9ywuqziSpPTgGkuBIpKcqZhzXFaWzoMDM4HF9MQetE9hM48LHhmc/H65zwYLcH9GYd1uEmPL2MmkPd9yOiyZRVtGohOBPhmvNIhPvWoDChm9Z0lbxEzXdcNsQe+heInCuIjkZyciD4FJJEOcrdCpBv1wWy4HKApyc4j5OKz4Ycrsoa1FZ1HcCz/8zphSrG8pgZKIjyC/fwOTd97knv1OEwuPG7TwSCCWK671mnMv9+IXQSR5KXTO7zw69trkhcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 05:43:44PM +0800, Li Zhe wrote:
> Commit 37ec97deb3a8 ("sched/numa: Slow down scan rate if shared faults
> dominate") intended to slow scanning when either shared or local faults
> dominate, and to speed scanning up only when many private faults are on
> remote memory pages.
> 
> The implementation uses the private-fault ratio as the slow-scan signal.
> That makes private-dominated samples slow scanning, while
> shared-dominated samples can still fall through to the speed-up path.
> That does not match the stated intent.
> 
> Replacing the private ratio with a shared ratio fixes the
> shared-dominated case, but the scan-period code still only has separate
> locality and sharing ratios. Those ratios cannot distinguish a window
> with many remote shared faults and only a few remote private faults from
> one with substantial remote private faults.
> 
> Track faults that are both remote and private, and only speed up scanning
> when that signal is large enough. This keeps local or shared samples
> slowing scanning and avoids extra hinting overhead when the remote
> activity is mostly shared.
> 

This changes NUMA balancing behavior that's been around since 2017.

While it's not the stated intent, it's been consistent since then,
and i'm concerned that this could cause unexpected regressions.

Do you have performance numbers on this change to show it's actually
beneficial compared to the existing behavior?

~Gregory


