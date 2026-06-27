Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31CA6C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDE566B0088; Fri, 26 Jun 2026 20:25:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5C86B008A; Fri, 26 Jun 2026 20:25:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF3186B0092; Fri, 26 Jun 2026 20:25:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B32A66B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:25:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 224761A0611
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:25:43 +0000 (UTC)
X-FDA: 84923799366.28.34C3556
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87B3340004
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:25:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xa2LIILx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782519941;
	b=N/Kp6ogH501E5K7rlwaDApELErB8wj1ufP+4MlhtFId/z665QHPXMrid/4PFVmAmD5HA4U
	O+Uud0mWePEXFDHE/0DeAnK3t+zTBud4YVREN7zIZ2POF5UG5PeVMBfx3fruX64stnoISV
	tknfG/rSVJzB2amuL+rlynlWvtcop/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782519941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2rtmhvJjinb8DEEiGRho1gz89/v7/dbBZ8zEBhu5q/s=;
	b=Lp2jBBnghdONXsc7WO2NXMcYfCaFrYkpwyuCUsAxrhnmqsrDvmhfA2Oo2pHXQ61KdoZLk3
	z7RwnlZZ+Jq7ZfS3cbq8iapux/AhEbVl43Ys7h+KHTrTvyWy07VGpqLsbxKde3pMnsLVIO
	gRqljQoCtfwrNPk5X3CCS/yMGi/gfpI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xa2LIILx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Fri, 26 Jun 2026 17:25:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782519938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2rtmhvJjinb8DEEiGRho1gz89/v7/dbBZ8zEBhu5q/s=;
	b=xa2LIILxyclfD441FflIQK7j1hGGLliqf33fZ7ZssQWT1pkGKSVCn9Q7fG+XFPaQrZQk5c
	2q9Ia1lSFkmC5hwixcTy2ISERcSMtSRN8gU5yTLQHImyrGqCttWs3hBZU+SM3n6qgV8j6S
	QKw5IoEzyOKykbjEbVEqv2eVD1oQBrw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Breno Leitao <leitao@debian.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm: memcg: initialize *locked in memcg1_oom_prepare()
 stub
Message-ID: <aj8XjtMqwAQM2XNd@linux.dev>
References: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626-memcg-oom-uninit-locked-v1-1-a00175936b39@debian.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87B3340004
X-Rspam-User: 
X-Stat-Signature: uyry7s8ucyt45fd66h3ocqtyj6wp7d15
X-HE-Tag: 1782519940-63848
X-HE-Meta: U2FsdGVkX1+oYikjb7kKEKIMoPsImK8VH2w+KOiSyXq/uVFgZta883pHQAEYqtkb5Db/xnlnd34zLOrgy9vSyf9cvBrSEYdrv0pFQ1P1sMWXpf+dUrNwf62L4eMK4h+C/56XNAZkhn1q0teoDbbaD/zX2pyAfONolMDtr+2WqVuovwNbQQljoCqH1QMGlrLZ7SpJhlkVVODRYFv4htwXMju1/ByN+LO0yTcgfboyoEG1kE5uc6w7o0UEgSxuSZe2gM8ZAhArEcqq+0fJvJ1KEtdkhNrEH2nT8N5VtRORh5/koSNpvgnHgFo7bMSXfgbqMHRlH6zXXKhs6PEo8PFOqvhh1Ko9bwxoKfr+pkJO7x10NnJ4VF5U8k7u8mtEUz8djyzWRzGw+ql1JAIH0eNwxR2eyr/L5rVOINmY+8zPPlbgQR/nKmZ/V6omSgzzLunzF3dRgby7ECSgKnXdtk2ccmnWiYVTrHFlwmqeO0m6R9lWZq2kWgl7vpOANsAPGGSBpYQM9j5TpmlO6YbJRg9rDfTd7TVdY9LQBAabiduhlIFzjIWzThTXLABv2s3LkZtd+8bdxX4K6bbnCg1cSmEEMUqcTArP4L2+W8eZeKNOjU3TX8169nGbR9GjvuG3qlaWwNwi7B2hzDF73ytN4ihtePdXIBzOUJZsVfd9NSXAAzVg0vvT1+98WQKu0nVeku+yRD5a5Ysdh+le02sInt8yUrmkhrlSkg4saUwrgm7CCUl2MMD1bZBurXqTjlLfhVwpZTQpvmJJJ4lhQzpPmf8kB65K/xZhghSPFHTo8YOaq0H49wkHpZlmrCNlKewBA1OusIqW+K+dAo+j/Din9M8j0zck5jpN3D7ZFXmi75am7EGDlZzEfuAyDSs1OPdElNsyTkzHdaUKacIcU+SMabW5M4kYd+75a/WF+sAcRAwpl18/gWMLSP23pGyb1vuNznLPxTa+KKniwYwp+m4UZoQ
 arXrj4ah
 br2f4JFCdHtfUlm4X9Zd8kA+RFdoeZnV++pM6or/vWvDxsu7pFIP/UGYGUOeS6qV4wLVfdcFVArb0QpOZEyI9w+zULRszmR93fu77hl1zIgdWNxDT2ShJkiRBUxjdANR0bfOlBm3jK0xfk+1QUtt1DMrQhYJXtu8rwl47/3l5iPSId5VpXSNhYtmezS7mOZ2egpfi9LrqWR8/bzoAE4/67VaIdGW0F9YATu0+kuwV6Q87jB/lQ0y/8JA3GEk5Wq8LrkXIUG91aszpVOcRE50sbOXtxHBy8roIsncvXsSjxmP0Oy6SoUFtzm6ZgQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 05:43:02AM -0700, Breno Leitao wrote:
> mem_cgroup_oom() passes an uninitialized "locked" to memcg1_oom_prepare()
> and reads it back in memcg1_oom_finish():
> 
> 	bool locked, ret;
> 	...
> 	if (!memcg1_oom_prepare(memcg, &locked))
> 		return false;
> 	ret = mem_cgroup_out_of_memory(memcg, mask, order);
> 	memcg1_oom_finish(memcg, locked);
> 
> This relies on memcg1_oom_prepare() setting *locked whenever it returns
> true.  The CONFIG_MEMCG_V1=y version does, but the stub used when
> CONFIG_MEMCG_V1=n returns true without touching *locked, so
> memcg1_oom_finish() consumes an uninitialized value.

On CONFIG_MEMCG_V1=n, memcg1_oom_finish() is an empty function and I assume
compiler will just remove it completely. Maybe on CONFIG_UBSAN=y kernel,
compiler is not removing memcg1_oom_finish90.

> On a memcg OOM this
> is reported by UBSAN:
> 
>   UBSAN: invalid-load in mm/memcontrol.c:1932:27
>   load of value 0 is not a valid value for type 'bool' (aka '_Bool')
> 
> Initialize *locked to false in the stub; with cgroup v1 compiled out
> there is no OOM lock to take.
> 
> Fixes: e93d4166b40a ("mm: memcg: put cgroup v1-specific code under a config option")
> Cc: stable@vger.kernel.org
> Signed-off-by: Breno Leitao <leitao@debian.org>

Anyways, this is not a performance critical code path, so this is fine.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


