Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B326BFA1FE1
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 18:25:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117B36B0088; Wed, 22 Apr 2026 14:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7DE6B008A; Wed, 22 Apr 2026 14:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8196B008C; Wed, 22 Apr 2026 14:25:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DA40C6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:25:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 83F381B7457
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:25:58 +0000 (UTC)
X-FDA: 84687020796.16.163D333
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A4E83C000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 18:25:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/+NyOPv";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776882356; a=rsa-sha256;
	cv=none;
	b=fuS2ppLp0/+TRGIACMbYuGdR0hOZS2lpTBTuzI4mTj0lr0r9lAYlpAFWfG40OViK0dBuQp
	xZ1nF/weG6Oo02kEnBgDU5lpGJGI8j8VNkUOQlJpWZLMpLVHJat9WPz5QBlBXZYUVmZO5n
	TLPEdKau4VvApZFeIWzijM9UnBjRi2I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="e/+NyOPv";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776882356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eJJjbkaNqXwn+guaj4W42BUnWH3LVJ85xVUl0ifV0K8=;
	b=ZcgWg266nN3C6Iz1+vy6TFzkn8J+FFvFFgc672m/W54DHQeN0VKIgBFTnEsoWfBabT08Gf
	6yEGQzKpj9O9IV3WcUavyjRo0Wiir4dBDQF46C5vl2KlrN49E4vVRxLmNOH+SqTz0jIGGG
	vLMcAmOMfCDSRrFlmrmgR1q7uDJCnVI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5AB74373E;
	Wed, 22 Apr 2026 18:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD1EC19425;
	Wed, 22 Apr 2026 18:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776882355;
	bh=xiGG7jgIF7pLqLmsu6Dker8kDFGD8xhSO9MbaoWa4Qc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=e/+NyOPvnKLr2hmkxcEGLNU2AwVc8jV0jl2N4Y46EsujQ+RIyuK6tNdYh3/T0rfyi
	 7FT8eo6BT3t0ej/WKd44pEToKZcGwEfvOs/x1Nyt86vjWYLnbNBrS8LPxjiUG/Fe0d
	 6F0HGTCMdJzbq9xjP/2hh5qNkxxbbaSiYwtlmaUc2sxJFBDNPDds8D7p9dFdSzdLiC
	 ilYeBoSaSxmLbx+8OrwNt+lDiRC9W02dc/yaocFn85e6zD/gDbp5X1sakqLckC2wVf
	 QgvWgZbJPrEN9E4ifdUyySZ4nfHEpNiRCMFxGj4Zi9ln+GE+9MOFhXQTsEZ05z+6Kw
	 3AjCdTwQBF13g==
Message-ID: <be256a32-dd9f-4dcb-b9b4-3f2a7fcde70c@kernel.org>
Date: Wed, 22 Apr 2026 20:25:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260422102729.166599-1-hsalunke@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422102729.166599-1-hsalunke@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A4E83C000D
X-Stat-Signature: czi9dg6f1iufr3tuyryiaqhzjeu4kjxc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776882356-942460
X-HE-Meta: U2FsdGVkX1+CTwtSM9U1/AMpWam05HmpiAfz1X3qY5EKYvT/6p58V/3RtN5NdgFcKBUxpYN/9SaTY6oz9DDrm369PWg+TNoJnOYYjFP62kBeXFxuCacVjiFuPDL9RX7LiArJ84skOhQ6Wka6rNxnP2CjcXGJedG3PTp7Prxf/sOEXoyklh/+3CPxGoc6a2Nbnu8HCGGCSSWnY1RI0S2xpKvcg/tHiC8NXqHj4e4lTj9oF7VwL1ut35e5kbIr/Q7Stub6p7h4Lv4ETO+yawQo3CbLvGwrkg102VrZiQdH4WIwBpTeBs7XVjCYdMilOhiv3ciF7mxJPXvq+Lr+6FdtwKCOSYX/ywfdZY+95KryAb00W66qlKYKA5UJHlKIWBfmSDMjTTKcjc3BjoZAIByFYFiPAAPm35CJdT6aSje+8TZ59rIil/N+uSBt1it3NDXVju7moN5KPUJy37L/ev+8s6wjRsFgeTlNPebjk5GbPMkZAWFhhF/TSVhon5JlnWKJ0Mu1KAff9ZIVGCzxX26heqjo+XA2Fv2Dg478P2m4tEnI+OuPrZ8K20xRWQcgwFfixAx8Gt1hi9xKfEBAHUJEKWXOvDZPA8xlXUXCMMNpz9S6jUCmTsFDY2zhWa0T4wFCodHUPBqb+Xn1/epy6/T93ZXgRE/p3CfX5ez1W8aN+MqnB366saf6YJKMJb3ER5xh4RVdDfuwt6+/N3vMg2C4GwZNRFVtluYQKX88j38s1ShpxULgMc8X2N7jG4F+jfslewTC8uKRygUGHI1YkQB91DMir0dxmzjbSSueuLgWtLnL2jYA/Btue45gCYIUzs7qOkg6ef2F6gMb8+RKSmxxEKHBIsJjfzy7PdGYbYhsd6b3bLUWuQ4uDL6ofZpJj0gVk8N7xe43ENi1+mAxTj0gCnWfwMV2XcDjbuAr0qqWSasVAszrNX6TzPS0rdU05ZStx5MOOYNILpSJV2ygUZC
 dGwLd7+c
 aNuhRYGN+K6Tg4GSGhGZSIQpEdGmAuGUfL7Odz+Dt/wnDBUfnijy0qKsw1lTZre0MexAVdtj3TghSuoVkBVxgRNqiCYfwUq+t+oE7XJiku8syBCp3GprfIfipYzsM+X2/3tAE9cJTBkIBtXg6YuM9cJaulk/KEOoAeAjn+mmygSp737vc9XXOkC6+AcdApXCyFivMmUL8SeVmcF5dR3kWPj0EmYSF1OXPhmiQDTW4ci+GesPUPL//waav4dE14qGbHndeaSIe7j8L1qSo/omBzKleveIeW+PA4HclTjkLMr159wYkQ93gzvouW/m9nRJA7aBEMaJi4A2OEUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 12:26, Hrushikesh Salunke wrote:
> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
> 
> Introduce clear_highpages_kasan_tagged() in highmem.h, a batch
> clearing helper that calls clear_pages() for the full contiguous range
> on !HIGHMEM systems, bypassing the per-page kmap overhead and allowing
> a single invocation of the arch clearing primitive across the entire
> allocation. The HIGHMEM path falls back to per-page clearing since
> those pages require kmap.
> 
> Replace kernel_init_pages() with direct calls to the new helper, as it
> becomes a trivial wrapper.
> 
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
> 
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)
> 
> Kernel time (sys) reduction per workload with init_on_alloc=1:
> 
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%

We do have some elaborate handling in clear_contig_highpages() to chunk it up
(and to call cond_resched()). But that function can get called with much bigger
ranges.

I'm not concerned about the cond_resched() -- we wouldn't do one here before --
but I'm wondering whether we could end up triggering a HW instruction that is
uninterruptible and takes a rather long time.

But clear_contig_highpages() breaks it into 32MiB chunks, and only x86 supports
it so far. So we won't exceed that with the maximum buddy order of 4MiB on x86.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

