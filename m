Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACE38606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrQGH092
Received: by kanga.kvack.org (Postfix)
	id C8E5C6B0971; Wed, 25 Nov 2026 04:51:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C651F6B0973; Wed, 25 Nov 2026 04:51:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C286B0974; Wed, 25 Nov 2026 04:51:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C0FF6B0971
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:51:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB4C980C69
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:51:22 +0000 (UTC)
X-FDA: 85473173604.27.78EA53E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D18881C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:51:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrQGH092;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795600281;
	b=NV45wmhNyG8OvFME7nFthj67V/bsnKpM+X9lC6rNuygzya65XUpeIO8wb87iJ3cXd20ZGm
	HecDEAcKMK9SYY482m/gzY3vzgsI3G8X4RmaFRfCAdWvCyOcZJgABupKiak3T3qoqZM09r
	+PuSEDlVGefWWIN7WGsjjX7NhxsHYiQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795600281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmv3xb9lOeaRoTV64ecOUClydQWqD2s7c0t2Kcqyx58=;
	b=zqmAKtLGwLDQJFF/SlNcX44owVYmqJDmdvSytU2XzX7dy/b2GsAT8kEQ1nqb2z0NA1ruUK
	QoEB7yVGzvYiITDAjHZCGNU1iTvNs9ivoLEZMIo2Cg54fNMl8I+ydZyrMtdPniaG//sTe4
	65LQTw7asStyQSh4zLaopOyrirrRpO4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JrQGH092;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CE0543526;
	Wed, 25 Nov 2026 09:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CAC1F000E0;
	Wed, 25 Nov 2026 09:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795600279;
	bh=jmv3xb9lOeaRoTV64ecOUClydQWqD2s7c0t2Kcqyx58=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JrQGH092cVLRi1EcK8jsjJHfMRa2+y6DzBtkyAf0SKwERUjn8oCMoJ5Mb750q5oW4
	 j+sbY10+0MrPs/z6eeyFkXnyIuuXM6ArGznK/IwW6tOy8udwwRV2XIw1r8DYuvy60E
	 ipePbcMubCYDljc5MQfnapIUq6c8jKF83FI3CrRusUfHDoesvj9bWSrlmJMejQZvbS
	 WmHh1IXHGSHbmhLKpjpQMCXv9vzJyQdhClOZv5TxLOMZuCWohdWnss0Y8KxBq25FHJ
	 rLc0XRkAFpXEYQy2lDuTEAu2X/wweeD999lm4ocAq9FAsSBm5G2mSP9e34M02R8Q+q
	 ++Hn/eC1H5JWg==
Message-ID: <5b47ee1e-0b0c-4b0c-9db9-43c9fbaaec96@kernel.org>
Date: Wed, 25 Nov 2026 10:51:16 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18.y v2 0/2] mm/page_alloc: fix iomap buffered write
 regression from 5d8edfb900d5
Content-Language: en-US
To: Salvatore Dipietro <dipiets@amazon.it>, stable@vger.kernel.org
Cc: dipietro.salvatore@gmail.com, Sasha Levin <sashal@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20261113110259.2901456-1-dipiets@amazon.it>
 <20261116111734.3798483-1-dipiets@amazon.it>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261116111734.3798483-1-dipiets@amazon.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cnyrxowu9mktm7jkosozsjgcqf3k56h7
X-Rspamd-Queue-Id: D18881C0008
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795600280-375603
X-HE-Meta: U2FsdGVkX19Giip+zClIKFXhQv134044aQajw5Dayzn4KIUJ8BTlTorUrL3zKAkt8dT3u4BcruFtnnatDAtr8muRXuUKuhDUwCA2I9nRIenk+n9BXsCqvJfCUlNgmy7CzgTIdCHW6EQ0oF4RMWKVgTENtPq5ZCu0JwJYWE7eBSsIqX5J0GOT+vXtu62HUV5tQ9s947RtPI6Qa2IXYvS2ylOnxZtWMJ401+/mtJG7Q/mlzjiqU5vWqGt62t57zJbh6uqDGzPqvdpHg80V7xhSImtBl0t3CZ/WBHf0xwkpf0Jy0VyxMqdpVAmTkxpRq3Io9t6P5DEIsobyRwZ2WE90TMgwH+RSB3fNTPUviOy2eutasYap0lweR71jlVnE47pIFcsAnkMIh5zQ+FdcOBTQKf8zoB8AV6naFjrT9s6q+ETAbZLGPd5eww3niaiDYL+Q+a7wxN0x8Tj8kdfbsI2BDBFjJDohQO+6js9htB//ZR9ip7FArTHQB46szOcA20gjSdY4T0jtONQ9CW7DbXqrQ1Tem1pXYS2kWpUMevK/YW5VbUZCx1Cam9+/gGjOpiR/Mx/JazKGX/rfp70q9LL7yLKDIc8BR+Wynm5IQgWJOaOXjLvgskC0zP7uerA2Fw/1mId/+Kn6PN/gLfBuXeTBglGAiRyltpbL7P+xm5D56FJXs/X6TEEYHXNk2fwuFR0U2VBIRxwFCscxiFmwfHB/gRYqoqHqQiSLA4lscUHnw6JhhuwZHGO9wOrGS+AZ7Vw/vtfl5z5OXDuXDaB3+4C0G8P0LvfJvfJBH8WqaXMqJFDE0shOv08fPhRyB8uRUMEiAKgm003+XbIHROfh2+1M+vMi67ifdiXaQRJDA3vFEcbbARmu1xL+K4h+oWxXCfIPFOb8YKfQDJr0JtTPaalEFA/ONqWiE3fQ/6LDk2EC4RTm5K8zraDhnCtaj5qo/+qMcRVTKeF1X6tYi9pKQuO
 jOx2h3yh
 DqUBZnqT5tdcO9pQ3EyAMmZsMuTRZJCI7VrA233eaafFwFB9Y21pHHDgFC/TDTjDvIezuN8HkI8iOk5l8WuZ0GLmCF93GSCSrAJ9ajb9EiU9qtt/Ru4Qo7t8Q4/YEYH55JJGBBqYZ2T9a0nQsG9rIlo6vICP83Vi39W961/aZWe2M0LiYhGMkHw0CASFST0YwdzjSxf9Hc2hqoBE+EdFXBsxFVzc4bZPfzQTklUuY/my1qb0Od/ZJh93T7hC9JJdcTUfd36W+ker6LYRFR4UeRHgn1ks27N+lBrpZ9PNnMQB27o5CCzi2I8OqfjsYbBfy+bhyOezw5+ObFxQ+Kq+nuiUhS9bhTya+hgAKsdfOkY3tkgRY0LB7VEBHh7xwAUnZbBDUO8ztmMELLLZzRNLx6VxBi+XhWsPArr6bMuzP42BqnO77EdxwwzBr3rh2ZBn1lac531LUdLnKJj2GfzRuLER/oq5sI5SFnJW0gpcZmYB7WT8uvnqSTThFsPrIx6IUioGX09CGK0X9GJcB0MqWqYx32RH1h1oFaiUj3zzZ9TQXkSwul/GWRzAuH7IVsybicKNFFbh9Ju7BYMls65Bbh6qTZXRXQA1hp+njeovBKh52YmyTdKwkJXBzo0YoO3np6w6d
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 12:17, Salvatore Dipietro wrote:
> Backport of 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and
> compaction for costly __GFP_NORETRY allocations") to 6.18.y. It fixes a
> regression from 5d8edfb900d5 ("iomap: Copy larger chunks from userspace",
> v6.6), which slows buffered writes under memory fragmentation.
> Andrew and Vlastimil agreed it should go to stable [1].
> 
> The series applies on top of Sasha's backport of 6ee3d87b9408 ("mm:
> page_alloc: do not give all non-blocking requests reserve access") [2].

Oops, while checking that I realized I don't like that this was backported
without also b480cbb071020bd590a0dc0166635b448e9fc46b and especially
9f2fd03c9bde366c928c9242fc9b2e2c5111a134. We didn't initially thought those
worth backporting, but now they should, otherwise we have a weird
combination of behavior for highatomic pageblocks in the stable kernels.
Sasha can you see if those apply easily wherever 6ee3d87b9408 went, or need
help? Thanks.

> Patch 1 is the other prerequisite, fe21f930d1e6, only moved from
> mm/page_alloc.h to mm/internal.h. Patch 2 is adjusted for this tree, see
> its changelog. Acks from Vlastimil and Johannes on these adjustments
> would be appreciated.
> 
> Patch 2 keeps the mainline behaviour, including the THP defrag=always
> case raised in the Sashiko review of v1 [3].
> 
> Built, booted and tested with pgbench simple-update (PostgreSQL 18.6,
> 1024 clients, 96 threads, 1200s) on m8g.24xlarge (96 vCPU arm64),
> 12x io2 RAID0 XFS, mean of 3 runs:
> 
>   v6.18.63               87,278 TPS
>   v6.18.63 + series     154,670 TPS  (+77.2%)
> 
> Changes in v2:
> - Dropped 6ee3d87b9408, now queued from Sasha's backport [2].
> - Added my Signed-off-by to both patches.

LGTM.
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> 
> v1: https://lore.kernel.org/all/20261113110259.2901456-1-dipiets@amazon.it/
> 
> [1] https://lore.kernel.org/all/1fc0caa5-43b1-487f-94cf-0d1aff4c03fd@kernel.org/
> [2] https://lore.kernel.org/all/20261112171543.3069410-1-sashal@kernel.org/
> [3] https://lore.kernel.org/all/sashiko-outbox-214380@kernel.org/
> 
> Johannes Weiner (1):
>   mm: page_alloc: remove ALLOC_NON_BLOCK from ALLOC_RESERVES
> 
> Salvatore Dipietro (1):
>   mm/page_alloc: avoid direct reclaim and compaction for costly
>     __GFP_NORETRY allocations
> 
>  mm/internal.h   | 11 +++++------
>  mm/page_alloc.c | 12 +++++++++++-
>  2 files changed, 16 insertions(+), 7 deletions(-)
> 


