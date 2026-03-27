Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F2C710ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC58F6B0092; Fri, 27 Mar 2026 09:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B765B6B0095; Fri, 27 Mar 2026 09:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A64BD6B0096; Fri, 27 Mar 2026 09:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94E386B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:33:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 472E8BE64B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:33:31 +0000 (UTC)
X-FDA: 84591935022.24.CC3B814
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B5DB40008
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:33:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cc5BiYnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774618409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CRt4vLpf3XwqNdUUK9Gf7zDVAdD75C3Fcq4XRF9cSw=;
	b=0BG6L5nDuu6e5c5WWZ5QYZfrLd7H02WcOQj2aVfs0mGgzyTc8RR466AGtVRPAfDGTqRw2V
	KRziSn06kNVLbcQIl75W+uzcMTIY8CmOlCV7kR2dWzpWfBopzU1kwi8AVTufTeWV3ksm/0
	kcgqkHvg0FJoXhVDuYFOwsKXXaFbnGM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774618409; a=rsa-sha256;
	cv=none;
	b=46NL7u3tKS+6bMy6ju6dhy65ptsdrNMKtrZsa+fXOGni4cEItlSugqhXoD0HpqyQDWQ3ZP
	XHesc5q6Bgtf0o3cmgQ5jO5vDsZsFE455N8PJhyqCdlMxB3K9hAJdsH5F0N/ApQAcPhrbp
	jHU7/iSSeyWCfkQXXmYpspWGSq+JkD0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cc5BiYnK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ECF3E60103;
	Fri, 27 Mar 2026 13:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 100ACC19423;
	Fri, 27 Mar 2026 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774618408;
	bh=xu8W7lqyzSXrcwxaklJNqkyZBDCnCyf4Es5zMCd5B2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cc5BiYnKpzNO+MmAjurOqx/BIjaAxwwZH1CtxzXm7CpdboYZ7p1vv2AviJru2aiec
	 2UBGwR4xERHRPSmHj4bbk0/t6qj1vJ42SsY0W3Q7mQho1A3CC2lo7G7ipEwuXw2iGB
	 V8AXG9/X+1VNdsTSxorfle9MKc5u+58u0T71iWb8DvDJpbSImbVKilgG+0wgElMhBn
	 cBzqK1+Lf8O9tfPM1IXa8jXwreMhNhVFRX/b5narvt7xRqCnSe34/PhWB4aH9MpOGY
	 q8wuo83smG57Pmjw+13lB4SbakPAjCQhSgJ9iGrd+o2LBknQKIp8mlmSlINSLx+c6G
	 8Letxru1FSJCA==
Message-ID: <a7976968-3598-47d5-99bd-a144783c72f2@kernel.org>
Date: Fri, 27 Mar 2026 14:33:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/10] mm: remove READ_ONLY_THP_FOR_FS Kconfig option
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-2-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327014255.2058916-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B5DB40008
X-Stat-Signature: 8x3pzpnhpky7wg7mfbqc5kc6erey4sdb
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774618409-494150
X-HE-Meta: U2FsdGVkX1+tg+0VhsIuGeJAwiEAgYidXqsU0BydyfkWqBAZUtTFD914boJiQsUrng6z2EVtcSU9jdJ+3eJY3hjl4HE5YLRhUaqZSaCmm7GeM5JWMbQVwqG0AUUUNWFw8l6zDyVsGWZ9PhU0YYodkwJ0LI0f0ii7rVE3sH9QS5MtR5UZxp2tCxCBKOIuXTl6JQ6C/ksdxyqpF8CUBV0OUB4WQ8s1eSGQBoCXVbLFqZ1yS/QtnieV+EJU/7+XfNd6AKTldModhgRHyy+LG34UEB4JVeMywYrcG9RlUbm3JcivnSdgjpL5X4ur51SN6m7+fe5CWQvMNiNNwvVEL4S+OQpY7PdV4Ti+mi9GM88OJv/Dprag/PVc7bn+1VXJ8kBC8RMHr8xkaRnh9YwmpSulDz62TAVaRr583BysMnV8zsfv9Dt0HwxUdjXFE9mwb/22vKkL1t7RW8rP+VtGXNuYBikYO86WXkizOH91NofJhsbTKhQ978bl0d/qdEg2hGqWzm1kTP6HG5PQS3esyTnromYiwjrehTzZYpf1znkanrFcissvalFnLNspEOBEoM8SKRbl+lbPddfKrthyZszgYAAMh8BibCPW8AjT9o3+z+8HtJj2FS+sh8f04GSFZ4uoo6KzilNuRREDyo8fCTZzTwDE9uZMqlM0MXFjOOeIH/WwvCm5lQIYPZBCztk6zu1FSze3yuV6wiMysd61MKPDUtu0lJH7KzJEpvwL2MvDjc9YQ+3jajLZSj6Hz61PelBTUrWB5zrNyRYzOHA+TIebnYGcaOQlW2bPltxMcPfQcn0ZSdfHWEymyYFoZViA3dotCPgF4xqFLTWFU0H0WPGeTBr2PVi6h4Z/7bwqWmnqhJkQfSMLgoJkovMFgFyh9UY58ZYPsyFC945QNwSMeCPEJIyYYwAsSs3R0/dao+BYBcET4cGBhmVTkvxBUZFyDgMondmUO7l+khxOApGFX/j
 ut3DQML4
 7+Jx1ouahGLULe+prZCA9JqwQtP1heRD+U9I8yvieX/0xRwSqJ6MySPZ4wkD3wQsfvp0qkgWGUzZd/ZgicE8saQWBxRW1yFOwKWML8Xvmk4GgyxCG+Dw23Q2iTgpZR7izts+32CZNgjNlmszFPztjVqcMYfz4/Me75n1Bs25rA4dnyv1e2yDdwPN++fgpNt7Oix5Y3f8koiU78KagzniV14Mni5OEqTksz9tMyemPmtuyVLjpzBDDEsZHyj5pvFanjVNcVm/u9tPvxgP1ibcuNs8Qa/cd8laAH8q+mnCjDh+duAA5iF+aUWqigB0UziWII8fRBlld/k+1/zg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 02:42, Zi Yan wrote:
> No one will be able to use it, so the related code can be removed in the
> coming commits.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/Kconfig | 11 -----------
>  1 file changed, 11 deletions(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index bd283958d675..408fc7b82233 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -937,17 +937,6 @@ config THP_SWAP
>  
>  	  For selection by architectures with reasonable THP sizes.
>  
> -config READ_ONLY_THP_FOR_FS
> -	bool "Read-only THP for filesystems (EXPERIMENTAL)"
> -	depends on TRANSPARENT_HUGEPAGE
> -
> -	help
> -	  Allow khugepaged to put read-only file-backed pages in THP.
> -
> -	  This is marked experimental because it is a new feature. Write
> -	  support of file THPs will be developed in the next few release
> -	  cycles.
> -
>  config NO_PAGE_MAPCOUNT
>  	bool "No per-page mapcount (EXPERIMENTAL)"
>  	help

Isn't that usually what we do at the very end when we converted all the
code?

-- 
Cheers,

David

