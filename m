Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA3EBEDB7E0
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 09:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2878F6B008C; Tue,  7 Apr 2026 05:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210416B0092; Tue,  7 Apr 2026 05:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7ED6B0093; Tue,  7 Apr 2026 05:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F0D3F6B008C
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 05:43:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8B3A9E23EB
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:46 +0000 (UTC)
X-FDA: 84631272852.29.636F685
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CC28820009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:43:44 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oy+fdGfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775555024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glojXBxf1S74GCvt9zV8LHtvp5fi9djiLIAGS3d9sX0=;
	b=6OmyFQLOQO5wvrnhdMd0Ke9LM6k5Q6kaqbaPYdFm2YKKVZFdA49O/UryMXrLlgvpEq4lJX
	Y1VPSROmBAFJXjpohTmqKd4Fa8TNor5Dz466d5swPrd3Gltxibx8dpHgzeyWg+oyDPLBPJ
	gH4QSObu+zoYgdUAv+u1Uy4CII9ULlU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775555024; a=rsa-sha256;
	cv=none;
	b=qfae6/bmAQ/3WfsWu4DNXajO3675ylObbFtZ/yPegPOVuYa8Z2kZXx9fah3y8uuNU9P3lT
	6YYTjhAZvzrZ0VulhPDAfo8eFV5cKQQmIAYb87Yg68fYwdVddefVz8J3NSUkxTux1OHBKs
	EqT9nS+WHLv6UJQcVg7bf/OWSJawT7I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Oy+fdGfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02EE0442DD;
	Tue,  7 Apr 2026 09:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216EEC2BCAF;
	Tue,  7 Apr 2026 09:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775555023;
	bh=EwEjTTNP/TghfPguIZpceN9n0hrpprwTXMdl6yRuKtY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Oy+fdGfT9pNC5sRTlF29VC+GlBoQy1TzjK2OKa7cDKDILyJ/QQU4PtTVuqOgLnkPC
	 lG0PChHsApIeaWPgeBkskK3IM8HyKeC1OAvWVSnVRY7UDawSiNGKWkTbvqr/UDvlHq
	 +FV15HMFE/gpdmPX3l4dWGUvuCvy4Nv/KN9LMp7dcCBg8AKqbQLgn5BhKOdPEm0aNE
	 R4U0asPI8FtqJGqWrSCf11pqMpsSVwItkayno6xxGEIl5GmTeiwFrnU4LD+fdevo/R
	 zrfKsLXfPy8a+Z8D/6TXxolno+qVnaPVIUfzDh9V5DX/GrBRIn4zYOkzUlu8Qkv2PX
	 ud2wrkyYlYmbw==
Message-ID: <2abd59ba-bdbe-4f5e-86b0-bf8edb908439@kernel.org>
Date: Tue, 7 Apr 2026 11:43:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 0/2] slub_kunit: add a test case for
 {kmalloc,kfree}_nolock
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260406090907.11710-1-harry@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260406090907.11710-1-harry@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC28820009
X-Stat-Signature: r9rj98phpmoioszd31onhamoxpruwupu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775555024-645630
X-HE-Meta: U2FsdGVkX190j2JcoZrRpZWVtlLKR+xbMSlzrTknC0vFECVL1+tHjFk0OZGP8omn22U7ettrhRwdUCsy4MHBM6qV2yypVwguoJM+4pql/3kDOLhoaQc2q39rXR2ujj1Wbp7o62jbG3r1DrGxBLqZCfqlRnL2T31oAmB9jib5H1ASjbAbaIPkqow6m7JC8CJk1UrGYlZR+rVen804XYytJziVhVRENw3dt82h2JszFUv4Nhs8PLX3/iZz8AJaicgPvMwrVTDMWB0UaVt6YpdEA4ksrzyd39/mZxZVHEnW7DQMXJyb50bILhamwEt1MEgtX6xMFvkKVEQrMoCanrayDNeo19RyUngCmcL0G+E1tzfd7kcflCOFk9l0vds7qY3M+pn+qLsTlMipalbQKHg9ycm5+2PhCstYEMCHw2ECjopoGNzgKyFQmbiduQiAPMgS9o1Wzuev0umTbHwoEWoyS3OS0aV9l8cGkFk81JbovAFAb+L8qTWhm27+A/g6vMbMJNTCyQTBdNIJf1ZKqRMzl1Mx9fKQoKtqPl+0KUi2QeQ4kjRnDQENbJcNaC/uLOplOslMczMa+fq3RYpffcvCo19ey/gbyyxS/ItaFQRGM12Pq8LkgmUg3igmR8XLjcdMPinJGFELfpCbEiVAX95hcgwI6E7ktRj8Gv8DlWl8lMiFBzlFSY2+t/oYfkBnRJSFf4KS3mQVa/CK3aVc8Uik3/easfSbUib1KFYh0gFbw/dBnTga3EZSsuxNHClSX3+2yC6AaTBuzq8smxI1ZCsPrqLCvV+v7fY9uKF/ryMUNVnJnM1Ynp5uicPDJnFFfz7a6ebz5sKa6SR5Kn+WpjdGR5Jn0DpkQbmXtYmqjsXpFlxqkxlN7gH292ZSTvIs4r5KfXg0y0XtEpgjGSfsgKMy3jVdFwDhRBdTYhzaKZKW8YpOcRUjqHKq+Hxk2q4C+1t+tI3lokN8ca2x10EB3uu
 LVyUUH6x
 XMADFMfufexL4aiQa5G/OBrEQCLGD2IvbbfDzttFqFZ9AkqeyExJe4x4BuItaAax68qcLu2SmQ3USb4PIY//+K9oLAVQvABnJhQeIM3VTUbbmf37WkGXqx9KK1fALK4fw6eq/h1saJzF/drEsrUPbHFfQbauu48cqOmZfRB0gEbKK8qpukkmqCL6CWq5SlDULivAiBjprNkGrTvuQG9BjqLNqrwTI7JoY54PYPRPwgd63ok5stzVfd0bzzAS9aBpU0fVfnpPBi90AHY9SE2mneTrD7Il5Ibz000IuYL/yHzg2ypUCk/pwKiYVxgtlfZHWTySLB7fozJhptus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/6/26 11:09, Harry Yoo (Oracle) wrote:
> Test bots don't seem to test kmalloc_nolock() and kfree_nolock(), so
> subtle bugs are discovered late. To make it easier to test, add a kunit
> test case that stresses these paths by combining a tight alloc/free loop
> with perf-triggered interrupts that invoke {kmalloc,kfree}_nolock() from
> the overflow handler.
> 
> While at it, also add the missing MAINTAINERS entry for slub_kunit.c.

While it's late, this only adds a tests, so added to slab/for-next, thanks!

> v1->v2:
>   - Fix build errors on arches without CONFIG_PERF_EVENTS (Thanks
>     Vlastimil)
>   - Rename some identifiers
>   - Use GFP_KERNEL_ACCOUNT or GFP_KERNEL for kmalloc(), instead of 0 or
>     __GFP_ACCOUNT (that was unnecessarily restrictive).
> 
> p.s. I was writing this test while developing kvfree_rcu_nolock(),
> let's add a test case in advance.
> 
> Probably a similar test case for the page allocator is worth adding
> but I'm not sure where the right place would be.

lib/tests/page_alloc_kunit.c? ;)

> 
> v1: https://lore.kernel.org/linux-mm/20260330120517.104743-1-harry@kernel.org
> 
> Harry Yoo (Oracle) (2):
>   MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
>   lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock
> 
>  MAINTAINERS            |  1 +
>  lib/tests/slub_kunit.c | 92 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 93 insertions(+)
> 
> 
> base-commit: dbc785fb4d9cfa0115e69e614fe20b4ab90f8366


