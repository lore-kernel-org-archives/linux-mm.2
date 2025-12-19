Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB693D7496F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C60E6B008A; Fri, 19 Dec 2025 04:30:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F9D6B008C; Fri, 19 Dec 2025 04:30:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4760F6B0092; Fri, 19 Dec 2025 04:30:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 38F7E6B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:30:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D70BC13B17D
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:29:59 +0000 (UTC)
X-FDA: 84235698918.26.FAFB498
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C4B040008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:29:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWBUCWFN;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766136598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzhJp2fZAldpoQgk5qXzLZeAHqHFzypu2o+9jwq6qhM=;
	b=Gyz9/bY9eBRtTRIwT01xGXzyk2TYIy/1oRU3ku7ld0OHfZaXCFHyUQ1oXC3F/PhUAsNy2a
	Du+gBfysmDMEsaK17icqc1XMuJqav6sQmH4h1QxXxXnzwvkPyQ/5QzZGTUElUXNFPOSC/4
	MyvaHfqf485ZRAGM74ChAgntkIiu45I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bWBUCWFN;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766136598; a=rsa-sha256;
	cv=none;
	b=f5Y8zjvyqNbbE63gdwPpGv4DByDkUH0CehFoyAOtyxyi7nSJtxxQKn85MXItqtdHaDmgwu
	6IUyqXPUc2/ZiHOtZ+/6iTmWS25i1y3Lek18H/ASu1GB12Pzt7WfDLBIG/6DMAWngfnJvO
	4AnukPtxi/L+FNmHl2WiPX00v+tXb0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B9C436001D;
	Fri, 19 Dec 2025 09:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41525C116D0;
	Fri, 19 Dec 2025 09:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766136597;
	bh=V/6lQG6kh+DJ+F+maEx/cpf9+v1suaX8xw+gTbpt5Cs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bWBUCWFNVeHiQZOp92aMo6bJbzBD3M61Yti8z0C2cvo71wg0c7Gm/GjgYbma3XIKE
	 N1UEqpp2lVbUeK1kfjsENB3Aowo0dor0psKQ0UCYvTu+r/KZJkEcrl6S3yM25gTFXK
	 SeUhIB4V40M5wckR4NtXg8/X4Sz5OAvyf06uzMdy27IdKtG9snvKJd1Mdn3Gp4G6kY
	 uGTKpP2e0pzCzYAu7Irg6lhs6HBjpVLoekXOcawnSk3VkrWe6csdbLEAcDYQYyxqVJ
	 HCviAwXQYxoQSZiIYwQVv20tigNKIG2g1h7aywqG4UHItiVTtXIDTUpoN9E3gGxH5Z
	 g9MraE2fxb15A==
Date: Fri, 19 Dec 2025 11:29:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: chengkaitao <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, kevin.brodsky@arm.com, dave.hansen@linux.intel.com,
	ziy@nvidia.com, chengkaitao@kylinos.cn, willy@infradead.org,
	zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] Generalize vmemmap_populate_hugepages to sparc
Message-ID: <aUUbC4QWMZn_BO8L@kernel.org>
References: <20251218174749.45965-1-pilgrimtao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218174749.45965-1-pilgrimtao@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C4B040008
X-Stat-Signature: h6r7czb7ffkzjsbf5a65edo1pjjc4x41
X-Rspam-User: 
X-HE-Tag: 1766136598-977065
X-HE-Meta: U2FsdGVkX1+Q1mZn5D59HsG7kFbjGYFrjORDzRbVrbgaouxaIYbXXvTvNqoq1sumq8ANEBJEpeU1w9anWIBrx0NPc+oo+556Sr4lr+JXgH7Dn7MOgeCWQTuSq6c/RfQAu2MoLOeDQEaF0I8Ihy2QnNCD651hti9CeG8HMdt1nkVaVkVyUJcMN79Ej/ssBgNlpmRXaDhuO2q3i+8KsJtXgIgxBza7GmH5hkMAhJZprCBDbEPSZdlCZzA3sDC8EGQJlzIy9DrZlpjSCz7as8X0XhQVWNrZphAfZGwz36tiLWPfK4UrW5pI7UcZc5AI3FI9d1uMcvIJq5zu+7xtvhP2j5RBRKFNf4ZCAYdOrwtOae7AF5ni+G+7AceuRkbPtR4u4wVDUsDSd4VdrP1DSKXbUydOaO+M5DoeDPIT5WpVjxSZdzYaQGHvaqUaTFQ9WzhtfORuuWYj6xGCJ+QDUhNzZEHIuc52BGiN80N98biYaJApCQHyuQJgaHC6HN+yrWl2deo5BvSDzx6XnGnaVoMBgZgJ2FuwcYdvp0hbDL9elbPbqJ98MXJEQCgQAv7HlG0Jo8+2m654OiuSiGITfasw+A6wEmeW8g0a/zcluJAP44B+Lyvb1DMIhux/gpRmXUqDEuW/xvFzihyS3Pprs9t8GoBPEEQQ0dHlFG9SMFeGbgYO1hxi/VCeVTJn2bWdvyfXyNnBTjiyJMuOp31K8ZZ6Y5aUN+pB60K+M2zzUdfXEQ8VaJAhBBfmOEh3D52VJUe79Ayzy2ssnx0sTkYxN/XfbtC+ahQxKKo1pprvl8EWWVnWoCPtWmaIIwO8Sw6P8hREJjDp0ACE8I9XNiZvbq7yQOCD/YKD5OTb9H3tMCHuSQKOCSjjf/VsRaj+xTRgNUZsroDa4m0XILhRmR979jDF3le6zerfLhKQghQ4syUO/lH8uCH7KT7pgNnQfX0RrgHWmEoNNdAbFNhiPBQ3ZIL
 95kZxA8Q
 An4/xR0Pei0/KN0AfHEBkw8g+KIZ4vokwkLwsbGAwUQTtGTb3tfgVgytlPQZdBqxR8ry743wtO+d/OeRMBrlAoHF0p3l0edQYlpU38L84N++IqrbTbBRnaSMiIvpBjX7T17E2RNU5oJNe/qXs13SribZzCi9bE5h9ld2h7QysVzD9AzvWwZ+2lpm3ZO0M5rhfUcJwb6UJuKoccwaKkbzlx9H1ejzGK1nS6wD+2Q+q6gW8UiAgyURhGhPWwie/iQBs+tZxvbozQfAaMbgqUt3eo8zkjZD9eGHOipksjJHXyY0raDdCM8PHGJDGFcsY68DBA9SUGzGOQ0MddwbaKzGs+bYNizlCc2uXG0ML
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 01:47:46AM +0800, chengkaitao wrote:
> Sparc implement vmemmap_populate using vmemmap_populate_hugepages
> to streamline the code. Another benefit is that it allows us to

If this is merged via mm tree, the cover letter would be a part of git
history so I'd suggest slightly rephrasing the first sentence:

Change sparc's implementation of vmemmap_populate() using
vmemmap_populate_hugepages() to streamline the code.

> eliminate the external declarations of vmemmap_p?d_populate
> functions and convert them to static functions.
> 
> Since vmemmap_populate_hugepages may fallback to vmemmap_populate-
> _basepages, which differs from sparc's original implementation.
> During the v1 discussion with Mike Rapoport, sparc uses base pages
> in the kernel page tables, so it should be able to use them in
> vmemmap as well. Consequently, no additional special handling is
> required.
> 
> Remove unnecessary whitespace from sparc.
> 
> Changes in v3:
> - Allow sparc to fallback to vmemmap_populate_basepages
> - Convert vmemmap_p?d_populate() to static functions
> - Split the v1 patch
> 
> Changes in v2:
> - Revert the whitespace deletions
> - Change vmemmap_false_pmd to vmemmap_pte_fallback_allowed
> 
> Link to V1:
> https://lore.kernel.org/all/20251217120858.18713-1-pilgrimtao@gmail.com/
> 
> Chengkaitao (3):
>   sparc: Use vmemmap_populate_hugepages for vmemmap_populate
>   mm: Convert vmemmap_p?d_populate() to static functions
>   sparc: Remove unnecessary whitespace
> 
>  arch/sparc/mm/fault_64.c   |  4 +--
>  arch/sparc/mm/hypersparc.S |  4 +--
>  arch/sparc/mm/init_64.c    | 53 ++++++++++++--------------------------
>  arch/sparc/mm/io-unit.c    | 12 ++++-----
>  arch/sparc/mm/iommu.c      |  2 +-
>  arch/sparc/mm/swift.S      |  2 +-
>  arch/sparc/mm/ultra.S      |  4 +--
>  include/linux/mm.h         |  7 -----
>  mm/sparse-vmemmap.c        | 10 +++----
>  9 files changed, 36 insertions(+), 62 deletions(-)
> 
> -- 
> 2.50.1 (Apple Git-155)
> 

-- 
Sincerely yours,
Mike.

