Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE5F1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AFFE6B00B8; Fri, 20 Mar 2026 15:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6874C6B014E; Fri, 20 Mar 2026 15:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4BD6B014F; Fri, 20 Mar 2026 15:08:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4EBB56B00B8
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:08:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E50AB56139
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:08:51 +0000 (UTC)
X-FDA: 84567378462.29.B2C8979
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4053C140010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:08:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FinYUhQY;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMMTKvWQyBQMusiMaGv6uhSsy/JGgw6koItJIPNbdGI=;
	b=iO+3guDS+CsGDD/myr+3V698jaL6cmLO+cduz/vppod01K7lvly1qsvXZLFaR1R0tvZGsX
	rVeNqIqev8GJyV1f3m2Wgq5E/feihguYR7aQfvvW+/kRr6l+fYNKl+qcI9G2iwNlEpeXUz
	lY2fQHpJNsaCzYWijEZ2gmtddm6MqUE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FinYUhQY;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033730; a=rsa-sha256;
	cv=none;
	b=ylOSRV2zkGFK28FPkapuLocPeOToa93rNQOGnAVMBGWg/4izBEtc69ZWfcRYdwb3pyLv83
	/imtg47V/rh/k7Z+/PU7S3Se9HKQp4jlRuJV5QGWcYmNjpOedcZogbAVEegmNEGYxbuAkU
	UnGoc8koVhtAph2gSZbrNMxUz7ZQbQs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 996B460126;
	Fri, 20 Mar 2026 19:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DE2C19425;
	Fri, 20 Mar 2026 19:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774033729;
	bh=m0jZbqQJCMjrXNpCUM1V9JA/iSapyeJjj3jNqnE9qe8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FinYUhQYLMVCHVDnIOPHoRyqEv/B9UN37GqnpWWUJoD5ovOprusiYYoRVqJjnk1Ut
	 B/+FjL9W2U6G2iQoEd7ZApycx093vLuHJDN9cv8VBAwvyhRcSbCyJMZy/AeXyBokjN
	 ue3SWlXnNiBUhStbD3RvV4nI7vOcs6JID7prDKzA=
Date: Fri, 20 Mar 2026 12:08:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
Message-Id: <20260320120848.ba7ddc21aaa4edab8c2b5b58@linux-foundation.org>
In-Reply-To: <20260320115214.143933-1-joonwonkang@google.com>
References: <20260320115214.143933-1-joonwonkang@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: c91j4gi75dpesc3e41npyuk66tfixdug
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4053C140010
X-HE-Tag: 1774033730-476781
X-HE-Meta: U2FsdGVkX1/LJMBby39O2YqadF/gGIKjU7eavPD6HeVqiCrEV8Dolz+VCYHhaG4fDv6nKyIlawIJdjAaAuBxSeLXV4TPu9EgkuRLrdK4get9sTc1F4HFgnmuReEA5mzISGQ1On3G7/AzssTPz1NesZymnE6fngL+EjgfVwDs5p1kdpvGjJNStgHgvBYO/UcwSitZMKcuvryRc3HlxG4MfDIkO0cAuGqSYtUjYc+O3UnMEEqEvabBTbE2Tsan1BM2aoga9i+wE94a9OwEAGRcKdT0wRDT3UFqOApIMiRyBHteRoZm0ivRcEbB2tPxdz3PZnuMal1eXpJGRsyXcjr2M7N/Ss0N9yQ5td4RtzXVuHNMlnXx3ECMMosvrEq/pJY1tN0bVR6jR8KoiKlB4WQt+6nULneKKIcaL0qq8eWyvqr5N0Kz2vxAuKBaAjA/FUjOnNJT22UAHyTYDcM3JfP1x5FgYXd0gSn6XQ0l+BH0DRcj9q1tMRuz6JgltvDXJPS2hjcZqbzTvX1aSr1eaU12E9xapZnCPH7/ysKMbZxNjsHsy7eAt1jHx2TVyVNDqDJZoWTVkCVFCGGOGfT1AJYOEzOctYrH5MRAfZZw81126A2y7UnhofUyyOWTX0S0I3BUJqwlIG+AMMNVDm7cNPpI1ZFD7ZCitY7kiT7zImrbzDiNoHb164vcN69pKa5k+DwXLlJhxi9M845diwoUzLsyefU3Qt0bKrYadbGInLi8JWpGWLA25yB4jOQIae+hpTiOydOm0c4CH6WHzHJNJwOsIkCKzbwSwq+/uVCH13m9z532uwiCJ5L0mFCw4Ps+A0a+vPa1JHS+NH8z/zTVS0K3NtePGBMWwHkollX6rIEq8bcsuE34d6Fwct4gjp9Huu1Wzo9IYl9YXcVHWjAgEZkZUPKrrrXWzi47AIfZQfKa2MErAzU4aDnoF1cGOW2PInRnKBYECDM+PgGEG7B7v60
 MCpkP0/A
 wQwPp2sZAaTvA7N8qOd+IwiJSnTkB9i47ef/B8i2biu6A1mFOPr5uVIQ8MUcw18OpNyXIA3B/CHE9vw3YAu224Mq6uYKxUE8SJFjrGeYf3OFmqCy0Cuexl8NOBYJrONvEqGaIVMESHKpRFhtaGHDZGjGf10AfNG63HHJJycyuA9BA4J3hTbWJBEVf19TQZEOOmWsEBuF15KfKlOwFaD//8kXMOjoWBE2NXjiugOHPUQXFfzZIYLhFxnonyvUoIX3ac1auAWxJAqzpcACrDaL6t5QOsDkf61h/aQyzY0MOCYJzyCE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Mar 2026 11:52:14 +0000 Joonwon Kang <joonwonkang@google.com> wrote:

> The invariant "scan_hint_start > contig_hint_start if and only if
> scan_hint == contig_hint" should be kept for hint management. However,
> it could be broken in some cases:
> 
>   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
>     scan_hint_start < new contig start) && the new contig is to become a
>     new contig_hint due to its better alignment, then scan_hint should
>     be invalidated instead of keeping it.
> 
>   - if (new contig == contig_hint > scan_hint) && (start <
>     contig_hint_start) && the new contig is not to become a new
>     contig_hint, then scan_hint should be invalidated instead of being
>     updated to the new contig.
> 
> This commit fixes this invariant breakage and also optimizes scan_hint
> by keeping it or updating it when acceptable:
> 
>   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
>     contig start < contig_hint_start), then keep scan_hint instead of
>     invalidating it.
> 
>   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
>     new contig start < scan_hint_start), then update scan_hint to the
>     old contig_hint instead of invalidating it.
> 
>   - if (new contig == contig_hint > scan_hint) && (new contig start <
>     contig_hint_start) && the new contig is to become a new contig_hint
>     due to its better alignment, then update scan_hint to the old
>     contig_hint instead of invalidating or keeping it.
> 

Thanks.  Does the change have any observable runtime effects?

Was this patch inspired by code inspection?


