Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEE0E6ADFE
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 21:15:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B09F6B0005; Mon, 22 Dec 2025 16:15:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05EB16B0089; Mon, 22 Dec 2025 16:15:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC5A6B008A; Mon, 22 Dec 2025 16:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAEFE6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 16:15:20 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3B33140388
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:15:17 +0000 (UTC)
X-FDA: 84248362674.14.5A56EB3
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id B0FF84000B
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:15:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WE8nga14;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766438116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ATsIATBoJeVgCe1Tzh5PiqnUB5qkUlOyxITDdU158Pk=;
	b=ZWYUdzH8ZCdzNXx/1XIdI5O0VmkRooER5s97cDgs8AEx0CJ39honuBtZTlt5BNr0N/oAuM
	IZ+U5WTSyAnppYHU2e3Tz4u4JwZh+GZ5JvMj56CJRqZg4aC1gHO6MWB3aHJEOwBj5vMw6i
	Hmhb+VD7IJUS265/0s5wb5GBCPRMxL8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WE8nga14;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766438116; a=rsa-sha256;
	cv=none;
	b=3ku0kiC4UyETj5RMTPYReCuAboOlDu0Xah20KV9hldBJAE8FdGHDau5gJdut6UZxzQsvnU
	/24tTgIcaxZGk/6ITQPkYx6nFfVi/G/jfM7HyJXPYZhoWtJtHhd/5SU4J/9kNMaCliFWTB
	I877KF4QVPvMD2Th06RQRwHj2POuZNw=
Date: Mon, 22 Dec 2025 13:15:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766438113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ATsIATBoJeVgCe1Tzh5PiqnUB5qkUlOyxITDdU158Pk=;
	b=WE8nga14GpM8tvT93TdK/ER3FepFBXX8xOYtIhzuAqC9PIoF1t+3bZLkDE03HqIiLIlXWf
	JJ+lJQFsNTLbsBS2HE+P0b22fyMDYypMmUE9vxqXpDwXpsTQDxB7Lhm0F3goFmcyq7DhFN
	HvLaAqtaxltcM3z3ZQN+nSuMA0YeF+g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251222122022.254268-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 69fuak85e3jeqq1w5ar3d51end6y6ctm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B0FF84000B
X-HE-Tag: 1766438115-905857
X-HE-Meta: U2FsdGVkX1/v+kwzWGRWkr4Otviq+YH3Htqqfuk0MULepLuhAB4Hc6znPXLMuYU5Aiq8evT79uKBv68McItErkMLnNuJ3XyEGCYfr3KLv0ar8RFBKbdnUHsxpz5lP+mF03GF5n0OpXYUAIUxlEXTesheN9qhUbd/smKFVd4tKJ+esYNER/mEysi0MM5vOEqzxbHdxhQniU5uYQbgQpjdDGdz9eAEBMWDxf+03bgt3uL13L5XA3tjUnm/5RA7EqXXuoAs2w9j4QGlkpXFH/vhUi6ydA0A0Wb9fMsAsfMdaDureH0rDWNm9jxSN6lcBbEpkRQzYTZvr1s8bZkM9Ajp/4/UQ37fKB9nk19J6C+21/0myei8YV19/Erz/s3WA7ZHG/XAQrwylhNY7zFScfTP9kmyDA4BsmDGKvcIRwfypEXU5cqY1mQjPuMN46Qr2ru/ergGyyhpPpxTEy+b3xXGCy/gBSN1wAyvOVavcvjNVkzWK3Lf/kQpoFcHevPImapzvAJ0kA3JskmxY6j2i0J/uW5GLHD3EKSAuc+jkYXL7d7MCpH6dJgaofX4oBbJb51v8aRL+kV7560oEQ0Ek843aHCE41N64wz215ShQ/gmVZb2B5xGLQqNCWUUOnJNBi7awFN2sGNRX4gYsWa9xIh4Hh7j9SPLS/cmGXz7SKgegHKISdqLi6zPlXmVm9sjT/jpeTzgI+rZw0tKEJaPkc3NWOmz4b+Q+lBSCOUebcEgzR2LSSeF3gStG+kpDqHQPurfrUnvI2TIUiS/47KnRk93ybYpNYAd7/s3Irf6UxIocFp0pF7AQezWHpHVgbInsp/O3mq2+Y8y5MNBRMy2b2hX6ntUfZRkwcHg6xoZYlrWrM2iyOUzEXASM7BrQai10bizJFAI5L2GQ9p/AKUbct4Z8EEapfYJ0ETDnUBQGDC+98io6+KvmBXzIIYTRQMjOyvPloRKJvC09WBfjJDdx0Y
 skuDAlWY
 +uxREAtrRhOYYRd5p1bjfyIPU1+oE5iyJSipoKm71UaxwT0oaSCKDjFFTD7h4GWb4JYJcKVHzoGZgQnnyNbuvE6ZRuHdyuvIlSBpFXcMJGnkeo88eBJHdvsRgjgLsdCrH/NX8YIn7akosbdVSZMCRAx0Dn+NcUnLn9WXS+TWEFCUzblOAuvr7Gbpgz8DQW9TkTWHHkmLYlRI68t0QVfV1g2iOFZNoMN+/W6o7tXSMzid5M3AoEnkyUg8hNdohtbc6u9KeQjerCGQWzo5D+3+UCkyuo9aEqpLSahFDetPTCgWIqWS+iGAjRSszD40fgnLulxG4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 08:20:21PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> When kswapd fails to reclaim memory, kswapd_failures is incremented.
> Once it reaches MAX_RECLAIM_RETRIES, kswapd stops running to avoid
> futile reclaim attempts. However, any successful direct reclaim
> unconditionally resets kswapd_failures to 0, which can cause problems.
> 
> We observed an issue in production on a multi-NUMA system where a
> process allocated large amounts of anonymous pages on a single NUMA
> node, causing its watermark to drop below high and evicting most file
> pages:
> 
> $ numastat -m
> Per-node system memory usage (in MBs):
>                           Node 0          Node 1           Total
>                  --------------- --------------- ---------------
> MemTotal               128222.19       127983.91       256206.11
> MemFree                  1414.48         1432.80         2847.29
> MemUsed                126807.71       126551.11       252358.82
> SwapCached                  0.00            0.00            0.00
> Active                  29017.91        25554.57        54572.48
> Inactive                92749.06        95377.00       188126.06
> Active(anon)            28998.96        23356.47        52355.43
> Inactive(anon)          92685.27        87466.11       180151.39
> Active(file)               18.95         2198.10         2217.05
> Inactive(file)             63.79         7910.89         7974.68
> 
> With swap disabled, only file pages can be reclaimed. When kswapd is
> woken (e.g., via wake_all_kswapds()), it runs continuously but cannot
> raise free memory above the high watermark since reclaimable file pages
> are insufficient. Normally, kswapd would eventually stop after
> kswapd_failures reaches MAX_RECLAIM_RETRIES.
> 
> However, pods on this machine have memory.high set in their cgroup.
> Business processes continuously trigger the high limit, causing frequent
> direct reclaim that keeps resetting kswapd_failures to 0. This prevents
> kswapd from ever stopping.
> 
> The result is that kswapd runs endlessly, repeatedly evicting the few
> remaining file pages which are actually hot. These pages constantly
> refault, generating sustained heavy IO READ pressure.

I don't think kswapd is an issue here. The system is out of memory and
most of the memory is unreclaimable. Either change the workload to use
less memory or enable swap (or zswap) to have more reclaimable memory.

Other than that we can discuss memcg reclaim resetting the kswapd
failure count should be changed or not but that is a separate
discussion.


