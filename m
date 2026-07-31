Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F6DC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70696B00D3; Fri, 31 Jul 2026 05:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20586B00D5; Fri, 31 Jul 2026 05:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E93E6B00D6; Fri, 31 Jul 2026 05:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7EB6B00D3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:00:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3A5340398
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:00:36 +0000 (UTC)
X-FDA: 85048476072.20.3C3F741
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id EC551140002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:00:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=buPD5pBU;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785488435;
	b=XGUgQUNLMV/++OKXmV19BIs27fXaWYTMiCPKdjaiCrVXzFnTyUlgJI8etZKtPp4GgTzp2R
	XQHhz2WR9gCWuwzR0yka3VQ+LinztO72pRHC+4uWbhId00XhTCW26V4vafoHCHn4nnR3TW
	ij2d50o9m/gx+Lq7HFhcIyiWh5crhCA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=buPD5pBU;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785488435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v9bG+vIiE6it+YGgnlKUY0r7YZ8/PBqlN9Pij+qz0Ms=;
	b=lI37aqgx9V1xEaXfAiCxNMbzUDS99zMh/JRIEpSwdEqspKlDcRJjGhzR4/Kw3qCTvu38G3
	arcIa8gCf9untqhtF81ngam3r75D/7Q3EiQHqlyaGer/deRp/tdtHtOrWeN7ptcWYJG7tq
	paxDg+V84IGsqqQ9HDM/7FM5BZBrvTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB4A24180B;
	Fri, 31 Jul 2026 09:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A42CA1F00A3D;
	Fri, 31 Jul 2026 09:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488433;
	bh=v9bG+vIiE6it+YGgnlKUY0r7YZ8/PBqlN9Pij+qz0Ms=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=buPD5pBU2xj8IVgHK5cEGIxtlKP1NkDTgZx/oWgI+IgIZHyLPuTHGa6yX1ayhQCoA
	 86+OUSWw8cx6S/OK8mZvATsSlhRSfnk2yBvz5A8BkIZ0zdVykej0L/zvhQLHoSQWca
	 kFPIiGBjspoBwz8aQN5EmwEMaGM0IAcIWM4awTVp3Pjc5ZjuIHrkaStHMcVnS3kuP9
	 Lb8OQBHUqDjX4nhSd9CCTqAOm+DknPUUkgAbW8Xt7+AsLaWhjOghFq6TAhox6zyvF/
	 9Y41wzDNaYGoGw/sUhMVy3D2tJ5TxfwAMZP+0XL/zpVkMzmxbFdIgAmwhtdCwQ+hXZ
	 R6ZbjHL5CwLYw==
Message-ID: <cec6f48d-8857-49d6-a24d-b072482bf0c8@kernel.org>
Date: Fri, 31 Jul 2026 11:00:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch 0/3] lib: add synthetic MM benchmarks
To: David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d6787a7f-3213-2b2c-2de5-af3b02daa21f@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: eabs8xsrmr74hbyb1yhbnn8z7mo33dg8
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EC551140002
X-Rspam-User: 
X-HE-Tag: 1785488434-924030
X-HE-Meta: U2FsdGVkX19i3p1+hmf1v6dUBh0b1wnq+sCHbKJldzatPbC0z1nlNtGmo2PcItuGdLxNP7cg6f7P+WXHfeYkwgG1rdaE+NLMc84P1A4OQDneEhcdXYnoo38oidYaPMXbisBnZRSWzIGn1rzFeLEHQarE2Bh8fWlgnWGgOonEIuEb2+qhWJuLwHgmwxxS2EkmpMBrkElkY8bhxFFpdaRMxwD1SM1e88NZo6dByLlIRxoeNYq2oLGm2k06E/3NJ1Sh5OFb83YutWmEdJivRlaFBJ1/L0R3NyaTONvb9sBCHHnKaz15WA1SzrIIWIuLB9Yj3cq9x78QiMUtk79MvJd90AIEfYLH+DpBFX1qvGqZbvgkVbeen+tSO4ha1hrPViO+9Woh11azCpohTGi8LXiQYqlqxu0rNyj+F2piyIdeHgISMXiUbRyREiUFjTgD6uF3J0GtMPD+ujyVEGJaAVGbhgGQR6IllGTzrJy8WORmISf8xbIBAfQhwj4xkio4BfVHkODVw413xo2ZuPvnJOBQL7nbvRjS875lf7FiZLP96ig+AkW9/4efjOhKuWPHvkvostuLQgeeeGOTHkMA0OGNAg3mzRc1x+j8lXQ4cFJHaevIp5IXuAibUGr35QkxWOGqurfKCHWKPx2HE8N+TFjizKOgIrrztmF00MB4vimGfMJ74Edd382v7BYv9fBO5ZIIwbLffEiJkkLmA+jYbKcJBmIJEMqZ1vgoaYR5nx/8bFM3ARPKvOvQOVv/ro7kRIpEltireOPu6ZOSF6Cwk3YWM5Gj9WDANs3lk/jdzgpI/xGIqFcW2XkkeOaWw5xffggsDzEC3NV/I+cNJPaBHLzkDk4ZV2Gmd5MUizFa9XvBAjiGXhFGcb7Nap7r73Wix9fdKhdyH9T2qQVtWihWUqUJo4vQOA4rXg5UJSHjcJb7FPHFqV6RQpZiRbLLc5PKZcwNR+a2wuq4GxYRTjdT2B3
 vXY2G/z1
 7hCO0xKWKcT+qRauhMD08x+DE+Gi7wScjdRXueHfA4v/SpnKjoca94uWqweNv5xLO+0tmu2IO5s6Z2xB+qQoUhH66JfS67Wt6x1hH44WnXasGuFJY10so4rXYvGniqipM73JzzeERcCo1HoFOBebGvMJqpoCsKcilfmF+ZD91r3SV+mzb8+LuNlas4KxshAmdQ5ZDOCtl/zt+4Yzaqwr70ThzmzX7SO/40KcXkaAE2oyoEePT06m0NUI4fedezJB9Aq2j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 06:26, David Rientjes wrote:
> A blast to the past :)
> 

:)

> We've been carrying these synthetic benchmarks in our kernel tree since 
> 2009 because they've been helpful to identify regressions in hot paths, as 
> well as quantifying any improvements that have been made for new changes.  
> Hopefully they can be useful to others as well.
> 
> The synthetic benchmarks are run by loading the module at runtime.  The 
> modprobe will fail intentionally so that the module gets insta-unloaded.  
> The test results are emitted to the kernel log.


Ideally we'd have an easy way to actually use them in autoamtic tests.

E.g., loading fails -> error, loading works -> no error (and unload)

> 
> Proposed with permission from Christoph.
> ---
>  lib/Kconfig.debug    |  30 ++++
>  lib/Makefile         |   3 +
>  lib/test_pagealloc.c | 337 ++++++++++++++++++++++++++++++++++++++
>  lib/test_slab.c      | 375 +++++++++++++++++++++++++++++++++++++++++++
>  lib/test_vmstat.c    |  95 +++++++++++
>  5 files changed, 840 insertions(+)
>  create mode 100644 lib/test_pagealloc.c
>  create mode 100644 lib/test_slab.c
>  create mode 100644 lib/test_vmstat.c

This looks similar to tools/testing/selftests/mm/test_vmalloc.sh and friends,
that can actually be executed as part of our selftests and do a modprobe.

Can we have similar scripts to execute them?

But I also wonder if these test modules could be placed then in
tools/testing/selftests/mm/ instead (or some subdirectory for test modules).

Last but not least: MAINTAINERS should cover them.

-- 
Cheers,

David

