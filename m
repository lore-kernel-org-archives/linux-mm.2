Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5549C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 20:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 821688E0006; Tue, 22 Jul 2025 16:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8BE8E0001; Tue, 22 Jul 2025 16:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E718E0006; Tue, 22 Jul 2025 16:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61D178E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 16:01:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FC878050F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:01:23 +0000 (UTC)
X-FDA: 83692970046.03.AC6D66C
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1CCD240014
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:01:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jTe/uMKk";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214481; a=rsa-sha256;
	cv=none;
	b=GpktYB+QsfwRfu7WYt2RfYHPqBy3pps9ZNL4AaTX0ko47uhdiDJXv7Dx+iHGsHowLAbsgG
	RsOVffKQYwc6JaxRVKHuGigeGhTD31YN5fojNmi5eQtvBq26ZV0oi2mwv+/sfKGrYAMNjO
	uOd35lyuntIxvtknkLwhb/1YILRSOLM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jTe/uMKk";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vgd2rD9RabSwUS4iapZN19usxQFXsWZrQ2L3/K0TL5w=;
	b=ccftj4o9Aj5JXpsW9DaednTXkhNhbdM2ZG+oCkKVfH3gLkeUifeZwpVV5GVxndMtIS08bg
	aLeeQcv5eRjFDnw88mg13+mBfSGwanVTiP6pSb+aXheIPbG08MFZjhmpLN2U8qKw4U+o9J
	lt1sC3Aupiap3YnZsnza+UtOKh8aicM=
Date: Tue, 22 Jul 2025 13:01:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753214477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vgd2rD9RabSwUS4iapZN19usxQFXsWZrQ2L3/K0TL5w=;
	b=jTe/uMKkOBVTHV1tnwHtGBUlgzNehHh+YAelWWXxmQh4DOnowCwSlolBltLwqsnvFwNrLp
	eyKBHdSB0CmhyPNsb4IizZ7gPi2gwSUt8N4e6aGLYTKxrjIcsDjZe5252m9lnBx2eOy+0q
	1R98FKxpUFnUIsizj1L74FGBKILFW2M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] MAINTAINERS: add missing file to cgroup section
Message-ID: <bdetq74tgtlekfzxjzfpv2cu6kgwarzez6tfzui7fopznzpn53@x3kjfgkggjua>
References: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722181409.154444-1-lorenzo.stoakes@oracle.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5c1grb1igznw16t1c1udggf5kwup1u6f
X-Rspam-User: 
X-Rspamd-Queue-Id: 1CCD240014
X-Rspamd-Server: rspam02
X-HE-Tag: 1753214480-81396
X-HE-Meta: U2FsdGVkX1/6brdwSzvy2UeOcbPpX9Bu2Hcv+yr0Nwy+/ZZx5ILUNLvYqPBzAAdgANsU17mJkPzL/2pzOszzI6VvyKUvH5XvwR8v+Hx2BsITHwx09+HAtiP1htL28rAs0/BSUDMq6pJZOi4oCu/hh6Tww3/heS8SbQaYbfq4CE3/sl9XgYlzbfaC6qC9aQhZtGGygci4Dt7ydRuO0+9o6R6D4FOifTZAo+77Xeyb04HOpJhWMiJgqyI8mvSoaeXUlCI/kgrzlKCCTh07YG5O/usVtY/QLhMtgiHn2s+CC/VQEXh5cWDs/hkY2+uQSCbukbZ6Gu5bMeMNGnnxTITvKNHIwzoxbBPeMDpJ/moS7sbthm+rCxhMh2IIUVUupb9aWCfELguF2VF35O2ZezUHQ2EDgjHHWwvcEc5M0iuovBy7bPZqZ7o/cbx6gOnGPaiciws2+w67EAf4iZ/A6QbQ0+dSDiI86A0M9S8Ro1+gRTbljTc+8Og4gfBYp+h0Y2vJvxixPwysZETzJOIGqWXhS74QtcOVfbgRL1wbFHMvE4Fs8BR6LWJPsE+Q8xYvcrrhjbZwxBWuY8uk2qnvUtkVnVq/JKX05Ja04GyMVut4K8Dg/ysWzrJl6BH/3BzfyIpIm7J9qYF1eAH7cFKmixyJRPssIs26gQAueJQ7Oo7wjNYu+nC+SxNmsCnL1XUmVZaANeEptpj7ei3t50OSSxKpTXFZco+3+VBApe6dV6SR3E0JlgKUfSby9Gk8VIPNb+DvEbUPdxO+zLs5Yx/ObbO5kOy7GUuJ41F1khwG+ZGe6lK0HFFRHhI0NIiQcxgbcSzkHVwprQtSbQI3FnuQ9neLIhhJ/zC52trBYFQEjtHqmLVkWvlu3x4vhIrA+lo/90GdGkRJKtXlA5/pa2CmbNT136bWJo8HcAPhedlV+k/iy9fXyXI05XO/3ksEhWeABt83IchwHzlKG5riNdrZVdb
 Wupe4SFW
 Ov/L/JaZ4rEAU3eLiHhHaRE3/Aoy81Zo0MAdtuU2MBlTwyXQZj0WLkAxX/zLk9Hct/EHKf1SHA5su3UfDsIu+w0f6uLytAZ7ZK4ONQNl4BE4IK2FAz4wKTD4ufzGkJC5DIq1DmjIhndwlPG59woG4BbljlOXNiexLOoBfiLgcydgJ9GASs82JtX5zKqKpMXfwy4+1ugmU+z4eU43ABLAhH7HCR4LuegwJtkYbTkTuIIy4xI8UAwfPlYejPQp0s15IKxO/8t5SA8AZG44=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 07:14:09PM +0100, Lorenzo Stoakes wrote:
> The page_counter.c file seems most appropriately placed here.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Let's add include/linux/page_counter.h as well.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 837bc5cd6166..d062318b6d09 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6166,6 +6166,7 @@ F:	include/linux/memcontrol.h
>  F:	mm/memcontrol.c
>  F:	mm/memcontrol-v1.c
>  F:	mm/memcontrol-v1.h
> +F:	mm/page_counter.c
>  F:	mm/swap_cgroup.c
>  F:	samples/cgroup/*
>  F:	tools/testing/selftests/cgroup/memcg_protection.m
> -- 
> 2.50.1
> 

