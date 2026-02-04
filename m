Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 692D9EA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:42:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78156B0089; Wed,  4 Feb 2026 14:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B257D6B0092; Wed,  4 Feb 2026 14:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A34846B0093; Wed,  4 Feb 2026 14:42:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 947E96B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:42:21 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CF0B1602C2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:42:21 +0000 (UTC)
X-FDA: 84407795682.21.DD22453
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C24C2000F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:42:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v8BIrl7o;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770234139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YXuTWPhBn/fcrrZIAcldZt0q8cY6i+fknSQwHkO497A=;
	b=B4XIbq5BisLFjogWC2uM5UOYgZMjKFtSWdbHNCiq0MjrSImd60kEI9JOAhag9RpnazD2oc
	M1uMGBRZmkfp/NZveIQ46TN9bEodmqPmO7DZ3APZktOoHhMoFv5j1H0x2rEscFoRkpjxla
	ijnLj4TJSPiiecT6hmt9YvNwbVIdky0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=v8BIrl7o;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770234139; a=rsa-sha256;
	cv=none;
	b=36TRdzPokHobJXtEbR+RSdivrAyHOz/sACbbCQAa2dhnGeDvwl9nK4a4n9sg3GfgxKIgVe
	39TzLsaImXTkjrzuivzh62Mqn3V/az2j0YI2s2xvXcPJdjyK8hg+TZk1OrqSDvUbLZiY1C
	MN6HdN1fjnS3Xrh3z/R8Bz/2lUWecFw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 42ECF43EF5;
	Wed,  4 Feb 2026 19:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1089C4CEF7;
	Wed,  4 Feb 2026 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1770234138;
	bh=0TzhdRBQGftv+E99NUPcByUdvUYMke8M4HMH54RM9zg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=v8BIrl7ot6Or7V27kK7fHjxxDPkk6dg3sSHtxaj6MYNdSXzwlhiaV/WGHgRWsmD0v
	 sW/9/7fw85Eyd4DNe0zXQmpx+WkDFqfxmgd07HVqJpyT019wqbbNIt/R3+l3Rhx8nv
	 o+98W/XFjQP4ZFBUCXLAhHNxug4/3TZGbCzzSlC0=
Date: Wed, 4 Feb 2026 11:42:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, ziy@nvidia.com, gavinguo@igalia.com,
 baolin.wang@linux.alibaba.com, linux-mm@kvack.org, Lance Yang
 <lance.yang@linux.dev>, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
Message-Id: <20260204114217.6da3e05ee5fbfac3a5f4c16a@linux-foundation.org>
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kfdwfb36ty7x8sxadtqzrpwc9bpd7qes
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C24C2000F
X-HE-Tag: 1770234139-107845
X-HE-Meta: U2FsdGVkX1+Qve9FxH64TFrjJuyIKHa1k1HPOh+rtOatWkVw4AgSaaLMJnK8Yvc0889TO+Honr/GzKnKdGjReL+vecmdMUdGuGMuZU9Jw6W8Bo0y8ClqFcklSRnhF6S4eEJWb5+hk2pAESETew8noolAZmQo6qmXMGpk0AXdxiILCnhF8DgalYITAA74T2XHq6+IdALY7Bxe2E7neEZ2Lz7y9ZBBBcLZO/EEwyLthx08GZtt+Cg2Hv1lSqpTTjPdCftyd1ZkcJlxew1b9fPLHTY/H3D4r2Brg8pnB56uM5dlC1YaP16IkUgVNgjfBlzPmvcJgDYikAhwmxIilj9jFzQjl/iYO4h6QKfJuiSzHaYBiFKGmF22qmM/V43b4lD0Jmy0elFcQdNVs8OUjJ+6LlCGlvsMey6pwUtpe8dHNBzuyMlcygUjzkuAo8k18baM8gVUN3IsAZaHG8CaZe6DzYsMkF3COwOfus9thFXZZRWmYg84QILQ+bBu5FoHS+CcRZG7W10fCQGHvNkE6FuXmnkQZJuNoNHnn2P7svQi6U4UTVKxjjOoeFUfRTmHhx9OKYXPYOgYZEvB7+lyRiii15pqrX9WRbcwcxLTeqQTLHSYc/33QHL0ua3Kg+tVETtZCg82UxGs8a3ez/sN+E92qfoEq3epinEBtHrK7AKtzzp3dTQY9yp1sMs33gaznsGJK9hckMLUwBedZ8jZjJCM77qkQ6boVzOUk5TINdQvPaJnyowEs9WWyNazDWK7vCW3LGe+ygi/68jXrcJ9B6YPaO/8rPzGXRvC3/bmhqA+ku4HnA2y2l1dUKAp6F1P7990lr1vmNJWsLSAZkVBXZJP0jknDdmcUKl7KTMNjq2ZyJWRBWDhmEpg3U0IjTxZ7DMScCsEn4p9bdNtYl5nXUjZ95igkQCkvzEcIYzsayFSRtyo2xU2hp5ybzXKgkpyHLY5XjTtWbsh1YwX22PJs17
 ErzClRuk
 oTb0H8IsMZMGVcMP6VbjOG3DBbIwO+rOj5POjkcNR9gVkTZFNwzLI+jlDseXc4PR9D9F7HaozIPYkYvcgM92WQozXY+H5HKuPqQHjI6ZBB5P2Sa/wEgwDkovZqhk3JxrPAik1pQd5CIQMIP7B9nN2SfwDU+AB/wGNBXgw7rmNad3iQKfmNluYfNbJG88jTd22/hAup7dP/bLJJSpkp/yO8gFFqYDk2kQmssrg5GkbBRKr4TF4UJtMSnL9RDSW/3E5IDyuXXAMz+pTenM+OHCCk+3dk2GEvlSuIPZY7J69A0tA9ka7Iuc2Z3srGqieNStOltuwWLNdutarYmf7T9fwLEY3Qa6SZmAB492kDS96q2qStB4AOmn7f3bWNIa1PM2ExCPGBuwLc9CDxYUvXi1PhQK0ALb7zUlQXPFH3W3AOwJ8HxkzXSmTdJMqLz7zryvpg36PQGpaITURpgMnPpN06FQWSn963KHMWXaUxnqe1ECudtEIMtimEzG3frjiwXXi8gjRAXBj93xes3w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Feb 2026 00:42:19 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> split_huge_pmd_locked()") return false unconditionally after
> split_huge_pmd_locked() which may fail early during try_to_migrate() for
> shared thp. This will lead to unexpected folio split failure.
> 
> One way to reproduce:
> 
>     Create an anonymous thp range and fork 512 children, so we have a
>     thp shared mapped in 513 processes. Then trigger folio split with
>     /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>     order 0.
> 
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
> 
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
> 
> The tricky thing in above reproduce method is current debugfs interface
> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.
> 
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
> just split instead of split to migration entry. Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")

Cool, thanks.

> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>

Why cc:stable?  In other words, what is the userspace-visible runtime
effect of this bug?


