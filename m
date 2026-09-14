Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2716C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:13:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBD1F6B0098; Mon, 14 Sep 2026 09:13:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95246B0099; Mon, 14 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3BB96B009B; Mon, 14 Sep 2026 09:13:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5886B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:13:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02C9E40116
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:13:57 +0000 (UTC)
X-FDA: 85212410556.18.889B258
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2D27220006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:13:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JzAsP9EQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789391636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aokfXWqf4Omn2K37qVJrtEDTPmx21fzHBeWcZX5PiT8=;
	b=MdIuBzoFS4/3WJlLtz8q2e7OwiyKc1YAGHNd8VYBr5yN7hgy33e4KJ67up4LBdWqpYck0m
	Ehod669fhXDfRGkQvPGQSrfd9Ea+4xYw4J0FtjOdhh1OZV7g2sRMBgBNr4h471iV0rdWcD
	RE6EDc0zKL14IKmNPb2zTu+w2btK9Ig=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JzAsP9EQ;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789391636;
	b=5MdXJxKpi0xlHSF0VsX3IioJtoZepCPZxrMAc4QZaWCh3QB/2CIMR9JRVngxFhkkSN5hoH
	wqNQHSVd7Nl5SVxIH9aOpdYKwFzdHHkX4San6bgs46+pjNz9Fk+tw1o0sMTtG4s0IU3okw
	FMeD2y3lOeCOpBqCNCN9fKAzdqAdowo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 55FCA42148;
	Mon, 14 Sep 2026 13:13:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1CD1F000FF;
	Mon, 14 Sep 2026 13:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789391635;
	bh=aokfXWqf4Omn2K37qVJrtEDTPmx21fzHBeWcZX5PiT8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JzAsP9EQNmpip2IZ+1q8uGwSdivHJf+BN/OhzW1IaEaPCudr1HooaypwLQohvGXv2
	 7EMESu+dvEtamAjVtby1qT5sJixIEGSv8hlBEOqetJjVjRQ5cIvvjXssGZ7pE/WTJK
	 Fa9U5+RvLMRMN8BEOyMiXpN62lmeMgPRysI5vtN9p8LOS7sNyTBu3KUXK0404RYp6A
	 jq428PaaR6zzj3KU0V+OO8RiIAbFrvEig6jI7OZyxd7ESt8ngMAPLM90tU11+Qkpkl
	 sqyf9GD1Up+PCvK3oYl4S3C9dG4dM33q/LB1Dc988vQQrpl0C3bGq2eXN2wMDCZ295
	 f134ji6phSFrA==
Message-ID: <e63e6edc-245a-4c83-8a0d-e419f6a8bd46@kernel.org>
Date: Mon, 14 Sep 2026 15:13:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] md: Use folio APIs in free_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-raid@vger.kernel.org, linux-mm@kvack.org
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260914041830.2072626-2-willy@infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914041830.2072626-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2D27220006
X-Stat-Signature: ftg4o8kbq8obr6k5ng8d5x3bpwhzfyy6
X-Rspam-User: 
X-HE-Tag: 1789391636-219134
X-HE-Meta: U2FsdGVkX1+pdNb+SLEnGROb8Azj9Rwe8/3Vr8y2xrce7fB7s/jhlSK4TD7SZcCzrc3VdPJG7JwRbwhcIlZdJEVf0EgPklw0Mv39JekpTJ92jvQ5vcaSWPaq5Tf/Z2QR93GqyyW7+eoaUn3iitWRQjLng2z9dCJ2cxcU3jrZEoR5TR6yl4yUuNVI6npT2TybPr3giu1WMCyKN6xi2+g3EvLSEinIvfyX3zAeVodMl2prJHM2WBat7EqP4A1UrVZr6UJnyJ4BuIPXH5kkXdEz1F54zLvOuyDMN+XYAqzouDwWjlBzBpoZrvSNlgOoSW0nN33ia/FcxpjdMe2R0V6BFF1+GhxXEd86erX0W7T26sZ3RxajnQq8+JI3V5PD0jt9wQPjxLB/SRMDbPuIVqGosC6f8/8yzmiMlVYsFahebvZyx0+bUBbXfRT3hIm59CB+VU0yEwMCmWFUjeM+QpRbX6GqEGpF0U8PeqtenyQtst0/k4IBITyQfUMlGSPSy2VOWfRe9aF/3RK4OeYYYjGfjp+U9f3hzVVaBeu8tYO2o6wFil6M5c7AvT2uI6zHUvRSFevxlsdFGEAibXQxwzKPLdqr+f6MocuxYYubaid9PiI1ZN7w04BU7Df6HDywkvzpN8FVLAIXWjZ8AGtyCfm9/3AwmRevUMHzXXQn3U2YM1g8FpPX+KakHg3wEDnPKqdVGk/6g9sUkHSVJKWjxdo1qG6xuGN32THNaFt8cmLWPnT8Z6dKyMm03F6rmXmLiOyxyhqH5s4Shy+/K6al/B3ALVMzBwexR1Rbd2TWWU4elX+IcN7guLMcIeIXTb1ZRrDS9mRtBCKGDavdx8P7a2BDGm89ubz6L2CJsGdMhMxgL4qffkGT4pLqYRtQwygl+IFOWWapA9LGClPQVvdYDxa8hlwyOmBuVfaEw+WeUym3Be4Z6HGEzego9Y9q5rhsk3kQ1OXLo0ln5Jd7DzbosCF
 CMemNTUd
 3eEaJmX9Ric1m8UJ9DUdARlreN+gcPf35x/VybELEO0vWua9MvW5v6sFAXO0fxZfBQXP0jHh5jG9g0u9yiiYjKstacxMIklLaZWCLYMmRKYtkiA7Ka1s++wUYqoJEeYqRuaJX0zYFH/shZ6xS0whuFBIESYL7tRH9QWR1N2kFwgoUVSL/V8EMKFxGJG3Bm/TT0nkIN3StF6icTCs9PfQ9WJNfjWYNmZQYCTflGnqwyb5UdwwkceZR7U5YT01qXI4dP7bVm/h60h+QBrJK97Ww58e/Yiiecd85Cuos/KA4aONo0zcs8ciHq3rxkkooxfC6uLMBZVmeCvLuVyxzHlRU14TscimfXoKXloMvk5qkmroZOHixjqPsVXmjgiTzBzOYPGIa7DJV/+7mECA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 06:18, Matthew Wilcox (Oracle) wrote:
> Convert the page to a folio.  This removes some of the last uses of a
> few page APIs (detach_page_private(), page_buffers()).  Replaces two
> calls to compound_head() with one.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

