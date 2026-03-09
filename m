Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0485BF417F3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 16:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41DD86B0005; Mon,  9 Mar 2026 12:14:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F55D6B0089; Mon,  9 Mar 2026 12:14:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B6D6B008A; Mon,  9 Mar 2026 12:14:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1F3886B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 12:14:37 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9CBE9B7684
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:14:36 +0000 (UTC)
X-FDA: 84527022552.11.0A43971
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34305120003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 16:14:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=rIHyROpF;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773072875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1jDg/PoZE134/hvzAZp30erwJqRyaAnX8Tci2InXOo=;
	b=1+YMgzUz8othdkEIRNByY2DtVr0hseDhihwsNi7S0mCBxFDQQhEje0QyZYH2JzgieuKRYm
	v/4JQ8sega1raSFoiByDwXrgIgB2At6RIuXhOFK0J2gJL2A+xRf5Aaf+MmXYKcA2bASDrz
	O7SFQxkVYB/74g4TsuLshDz/BAh2QFc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=rIHyROpF;
	spf=pass (imf29.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773072875; a=rsa-sha256;
	cv=none;
	b=xyVCD6wNTWAev/E1BJJolTW5cIvw4z2/fGJzYtENiGIGMcfE37844fL4yFZM3DhS3WIr7Y
	2TDWb+pLx9cIw2Wjewz0VbqsohulXfAGP68WRmjVAM5CQrFWhHDRQPlsU+v8H6QWVzxRtU
	ZgYpRGhRmDGnw3KheNamkjGcophwWX0=
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 7913540C9C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1773072871; bh=p1jDg/PoZE134/hvzAZp30erwJqRyaAnX8Tci2InXOo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rIHyROpFd/tKHNE2cNLLgwSlk7bC/Xbm5umP3AawrfzYgfiuvY/yRdDBI5REo6fKC
	 +niFUjJQGCUOuG4AC4Q06wb2V5v+NFkg3x6MoeuryvNSOn+xU2cZmFraCDAVHY3v3j
	 7CbmunT6w4hBHEsE6QGd2xBiaspuz1WRDboznSeWWZ+5DUY4nAl9adTmdqCM9/HCCi
	 l5W6THUrTQqmjNw+WVSUrxTnRQzSOT1wJQx3M8ngkpRb0prHUuR2dvaw1RegGHjKcb
	 PuJ6ZAR7/qpWekypRt7R7VGDHNDZPamBJznl1wPy42xS23XRyIfvr3pl6BdyJDRwjO
	 gnApntLob1Wwg==
Received: from localhost (unknown [IPv6:2601:280:4600:27b::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 7913540C9C;
	Mon,  9 Mar 2026 16:14:31 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, Vlastimil Babka
 <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Dev Jain
 <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Shuah Khan
 <skhan@linuxfoundation.org>, Usama Arif <usamaarif642@gmail.com>, Andi
 Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
In-Reply-To: <20260306081916.38872-1-david@kernel.org>
References: <20260306081916.38872-1-david@kernel.org>
Date: Mon, 09 Mar 2026 10:14:30 -0600
Message-ID: <87ms0hvv2x.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 34305120003
X-Stat-Signature: magayux1zrf37rqcuhdiaye3ji934ysj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773072873-301971
X-HE-Meta: U2FsdGVkX19ZmsfUfa/V5oaOP/cz3sNB17YIXA1BpsTZH6st02TPq1+af2zhXrxPv5HcVwixiX2r60E/DwfEJ+N9Q5837scYLfgEdUfzVszJiCe8q6JE9chOO5QF9jeykyqpOmPePTzWLxQMqcgDQxfLak3Mlq50ELSIl8XIbocUa9hpE+umc0xOfNcEthuzs/dtpXadf57d06NFvFJjjb12AvXPMF15/o+cZ3Mvl2EKas/LQ0IeBYbD/9+voIRTRMQ2TcwTcij1AVWtu2XFt+3mDwGhpEY+++hB3SlvD6ofmJh6Tyvo5fDFNrIu73ZDiv4tKMGlKHrYPhI2W7GP2jmXy7AE1L4PQV+Z2lSKdqcK6qYaIfwepIJ0QN/IsLquHx1xcKOYQoJFVWJlYtYPoL9INXzk6X1fRNQKvQvPiZczBW6w+0PKzzB3WG05TFaIjLbUMYn15k5Za+SDm1W6yGH93UrF7OTQrz9ta9MpxGlnT4XFP9ZewloN2eyC4meRZYyOZFLZ8EYWEAjx/AMeA69HW/l5ty6SFZakr6QZNw4196/+vF9izvoKs4jGeGUCDCmBI9TU2uQ2bIvGRHz2zZT0h7Km59Kx72j12WOEgjamZzgg6Gn4fIqNNL81MLcJNnSlNRKuohcEp3mM1EtIR3ukRbbJC3+ffHeJG9CMYxnbdDfFCfCamF8ArlldswCQ1hq/+VBCdQocl+CZzLkcwtecI+ji3LEguoBrBi8bY3hEMIQFpe/1W8ZzJmgodhYE8MVNfmKAVPTT6NkkKat7bjKe4zGjz/X5uJqEgUE3XXFAJJHPu0T1e98aPsU+MYRd+ELTD+TuxpKNfFbFjCrFVqXU5wuCmpo/bPfi5BLsJ+o5rIkVbq4Jk6kZSVENcVrbft87ieQu+tDzlldf14xlzpCzQMEbWx+QB6ooaumLrkFbq2rY+yDxpG7FnxUNCQNBNL8FGb2TGiEsBUsXfJ3
 bLoYLCvO
 n3hLItLtqyq5EnsK8urDQi6EGO+yeLDqdCiugUTmWfzPULLTgkGfqWE3X6ueo8EIMpIKaZ9bJ5nDFCMjX3srAPNa9COuakteBtJ7M+E0yYgnU4Jhylsuu0MrIUgImM3fyIQEdlysbs9zLI5EP4Nu2m4z5zs3XrwWSaH1ISyajBb4sXZWlJ2DQGKYkCfkEL+HQxGetPkfRi/lB8+4wSwAegYHJ1XpXFLEEH7xqVuemtmMJSUkXVEqlQ42f9knatwT48Gzr8FA9W6QjBLSm7w4feROzKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.
>
> Ever since we added THP support many, many years ago, these entries
> would keep reporting the smallest (fallback) granularity in a VMA.
>
> For this reason, they default to PAGE_SIZE for all VMAs except for
> VMAs where we have the guarantee that the system and the MMU will
> always use larger page sizes. hugetlb, for example, exposes a custom
> vm_ops->pagesize callback to handle that. Similarly, dax/device
> exposes a custom vm_ops->pagesize callback and provides similar
> guarantees.
>
> Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
> and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
> regarding PMD entries.
>
> While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
> and "ShmemPmdMapped" entries really mean, and make it clear that there
> are no other entries for other THP/folio sizes or mappings.
>
> Also drop the duplicate "KernelPageSize" and "MMUPageSize" entries in
> the example.

Applied, thanks.

jon

