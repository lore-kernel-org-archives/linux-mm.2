Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA577CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 03:41:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D737A6B0088; Thu, 11 Jun 2026 23:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24B86B008C; Thu, 11 Jun 2026 23:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C625A6B0092; Thu, 11 Jun 2026 23:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7EC56B0088
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 23:41:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 522F81C2707
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:41:20 +0000 (UTC)
X-FDA: 84869860320.09.88A6D7A
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf19.hostedemail.com (Postfix) with ESMTP id A00441A0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:41:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6wKqtK1;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781235678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJOwCe0Kl8GvUtCfKaSs2MlOZ0Hb5owPZVvPNWzaZCk=;
	b=f6YNUwJv/MZeDollAXogJnodbsWGWkVy3Q32N68SwFe3H0kkwUOF1lXptunhHhTzB+IwQw
	ybNyMg/YK9pwc/xpyhvk7RXiMSmvxv5zyAsc6/yCs/0j6rTkyFDR0yunvg0P7tIHyYCSUm
	LUiE0vOKy4uZfaqvVIWNqd+utQeJJI8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781235678;
	b=Vcs4T7kCStgLcWs1QTNLy4faVPMzdtT6bnlTz4OaqKl/QARJIvVdNvZlOJ4/YTRFqp2NIy
	1yT1uA4UxFEXdBUXfPUcpH9AQA/V5335mzxCwAVFl9Ee6vAtlt9bdITIxN3jnpQLYVteeS
	dg+uuZzOgiyZ2HNRIu8qWUefJamsz/s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f6wKqtK1;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 12 Jun 2026 11:41:07 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781235676;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PJOwCe0Kl8GvUtCfKaSs2MlOZ0Hb5owPZVvPNWzaZCk=;
	b=f6wKqtK1twAg711k9HqipdHkDjn5F7o/YP5t/eRdU3Oo5pk7f9JEafL029yE0SDngLzMdU
	RNz26eEOyhZRjz5beMQOBLN24LmHwGaaC6jr87YBi956J3SVw1A3LWpJnNyK5Rns4w0E2b
	LPC688doy/06UlKnIlQ5rAEDXDuZ4hQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev,
	shakeel.butt@linux.dev
Subject: Re: [RFC PATCH 1/3] mm: avoid unnecessary lru drain for
 wp_can_reuse_anon_folio()
Message-ID: <ait_01Liow4hbndZ@MiWiFi-R3L-srv>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-2-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A00441A0005
X-Stat-Signature: iahowcwuw8rscizm5y6gyg6bsa6rg4yz
X-HE-Tag: 1781235678-809443
X-HE-Meta: U2FsdGVkX195VfM4wTPYCeAXvQzhed7yY7bJ2WYiMSESRhDTrgnm8uW6L4GG92NiD9GiLSx9NQpDjl9hRErA5L88KROkJAzSlhFC/Ex6L1DJ2zEir8ES4itg1o1iPNCVH26C7oBDPrF0Ra5SR7H3h+6Rbg0QjLc1PrTLCDapcZMcF/etVr/B9WzWKbwxXvpYlfyJzlVKXhXwjijJE+mtmuwI7MbtWZgkuUMx8dRPfaJG9Yr6CpITawbowkC80caKKMmz8Bvaw8QsNbOfCsXyHym0+yCpJP7em/jFvkkLh1/a5SJNjcSjWq1cGUl9I4/HSmb7TF0mY6E6+tRKwMXQzeh4V//6/mkfI4llOakRAxsNT//RTdGKjkXeO2MGkZ8YFf5XBWc4OQuAwZZdEFSs9BD55fRNCx4OS0/qRsRUMBGeA5C0Rd0rvwkibz59KMD/BEd74whZCzia/jWoPvY3QNzeR29X7UCnkFW/j0s6uIdhcDBRvWfg+d/2tfguJihTr9qL/hLeidT6CjotTAi3FzTi7RmPZs/uv7G6dW8dlVFtOn2VsC+uk5heXPhk54IYqKz44vmDWs62Af+w3s3S45EKWQ70qSK4UD2kP3L5NuqUbv97RSheRtbryAFIXlpI+zfXpfCiaQ7FTU86zMCLN/FE4LqU69wk4af8Odzi+cHV1UFThzedaPxlkOURuUUP9FiEoJeztUx9/miDxkJL5k9ly5QjBLBSh2OvZlG0TWqhhdKVimFNaviYGS01M6XHMZsjnqgcJkwtzUWM0v9xRLD66gMHTOO1BylVzT/pjy7jFgJm8mE1bqS9etk+N9VRn9kp4M6TkJoYQ4PzGtPjzqHZHLugZopeT/Ob+JZsSOp/JqTfIGDG+WdPJSW2ArE0geUctweb1nr9+n8Yt2Lxcw5IKn5GzZYU2XaTaE7r/Zsjsfg9efBmzWJSVfNZYUMaq2NJC4YFF33zU1PEHp6
 UXvmbhLw
 ZIeHB/dmm/u1dy+Anc+O6Aw1LC5WFtgM2p3UJZq1hqeDqtJRisCUW5nGcml2TVT3HItA/RD90Sj8gHuLZRYJGP0mBabSVNez3gd7IFhc1jiJ8ykD8LyeHaodovB4OxFx6EoaS4lr9I4hd/XVrKHJ7aQQf0vLMjpubCxNrHPNhi0eMai5ZK2Dyo+ElpARUuoIHIyINMzi4tIFHYiGaPB7UVP1fC6j7ijAHsrcgZtiIoHKtJACeC8gq7UHDMsLf45xr7aDsdPkqPW5lhmuzQL8xCaAPzd2n4GIsa4z0DVEZOjp24RU2O8QyLldyXg9EeYwYoEG1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/11/26 at 06:51pm, Barry Song (Xiaomi) wrote:
> We always unconditionally drain the LRU before retrying anon folio
> reuse in wp_can_reuse_anon_folio(). Instead, assume !LRU anon folios
> are in lru_cache, and use the refcount to avoid many unnecessary LRU
> drains.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 56be920c56d7..487a34377a7b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4193,12 +4193,18 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
>  	 */
>  	if (folio_test_ksm(folio) || folio_ref_count(folio) > 3)
>  		return false;
> -	if (!folio_test_lru(folio))
> +	if (!folio_test_lru(folio)) {
> +		/*
> +		 * Assume folio is on lru_cache and holds a cache reference.
> +		 */
> +		if (folio_ref_count(folio) > 2 + folio_test_swapcache(folio))
> +			return false;
>  		/*
>  		 * We cannot easily detect+handle references from
>  		 * remote LRU caches or references to LRU folios.
>  		 */
>  		lru_add_drain();
> +	}
>  	if (folio_ref_count(folio) > 1 + folio_test_swapcache(folio))
>  		return false;
>  	if (!folio_trylock(folio))

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> -- 
> 2.39.3 (Apple Git-146)
> 

