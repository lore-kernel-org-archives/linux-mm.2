Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E2CCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 262536B0088; Tue, 29 Sep 2026 05:12:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239EA6B008A; Tue, 29 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 176E26B0092; Tue, 29 Sep 2026 05:12:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECA386B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:12:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 84538A6B4A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:12:07 +0000 (UTC)
X-FDA: 85266233094.12.C4E92C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id CEACA80009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:12:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDl4xRwG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TlpK6AkQLjGzwcY0xdIG2tbpzGDvPT2iBKRsp+RWEdU=;
	b=zuRhm8bN8KaRWHoBTuPIil+yKl03wMKvhzhlv4tPgeQ6IsRAEluhye+9ANx4JvZbRtCJaL
	ugOJT3JKJ1Pxn4DXhkfhRkXr0oZt8CmWX6TucoA3H1UsIZjzH1HyeWvK7hxF16LJt7dsi2
	S7a7qjKOmZM0kS9x/1FYDByTJIXdE/c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eDl4xRwG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790673125;
	b=kwtfVILwEEf9KIjzBPKVn+08h8AH4Af0ouRgySHqsbC6Y7Bf6RsMCNHaJHpZoH9WESjkBC
	0S9gOHNdRB9e+VeQtA8K9tmAJ+0ti+1DCHq0v1dIHy+yiPt8U6xXwlpJ4XWZqRIDT3oaJ4
	rpLrMReYGI9dmt1JBZ9RZ83XRRG5EU8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 019C54041E;
	Tue, 29 Sep 2026 09:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9781F000FF;
	Tue, 29 Sep 2026 09:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790673124;
	bh=TlpK6AkQLjGzwcY0xdIG2tbpzGDvPT2iBKRsp+RWEdU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eDl4xRwGJfwRtbA4uTiD+Cq5r4o89slV//hSSfqjP9f49gZJY0JvRe6fTjCKAqLwo
	 ihWI4LXh+dqA6G7bWo7yI8feLtzng5NLDv6tQxfBcAJgHB7sBzpBwT5JhyvO+6RdQ0
	 cUNeHDLU772oPvkjpDsH0iQW3TeYJMQJ6YBdBtNW7Q6BKT+OyMkdj2g1AWj/0tckCL
	 qaP2m4VlJX39QSfcQN8CGgoIoiO+Yxbqi61KqYFPpqZZ33Qefras7Pii3rQUc3NiuV
	 LYYZrzbQ882s1zfZUjnegNq6TC79tL18N7zTFzlGCbVTjFdEdAMrT4DDbOP+7fazMb
	 xHWlkTAHQ/OWA==
Date: Tue, 29 Sep 2026 10:11:57 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos Llamas <cmllamas@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	kernel-team@android.com, linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
Message-ID: <aruA14n4S_gnCRd9@gremlin>
References: <20260927162419.820609-1-cmllamas@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927162419.820609-1-cmllamas@google.com>
X-Rspam-User: 
X-Stat-Signature: xp9af84cgzuwrww3mg5e4u9nntmy79si
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CEACA80009
X-HE-Tag: 1790673125-338005
X-HE-Meta: U2FsdGVkX1925uHC7lVUxkTJjF0EBYR+3QzxHrYHyS7s3i1rDL9s4wGAE3utPIWbsgco/P8GMNEwjpPcZyYUYh7J7J2tKXBXHwpt1y5UNfXkpcNv9pBOGwOfLLQ3X4TSN98XQUjxF/uyb6jVTxaUkO7WiSJNIZntxOWWggx/jMO6nP2U36TbPYwwteupIDHe3MnTg25++rRVT8p8/PqCgMwY0lKXwWld528T0G94O83b05O/LEAVyYniMkXmhq2EJ2gSRTwVCVydZVRwgeamB8EA8gOwEIB+PEE4qtdVN6fooXGY/4SrnorRpU80s74fWNKmKi3M0u4CbusQgDXwSLe/XdW+egZq7Ndwjj9UJDcg39doYhH1MHiNh73I7QFS5diksc5EhDuzweCuOp87VtomdAu5/JxFu1TypC/3+K4/byLqDLH9qdbb8I9CdFvn8buCOV9sVKVI0ogsTd+G5TnDrci4qZrwaOZLq4d37FEguXg+F7pv65vqFsJ0rKUls3oOlRPC0M37lvhgGjSRFRWxFWQPcIVruDEP/H6w/SjuNPpJxNIwypbePbT7dudinrnSujm2YAeJ4Y5tShWqE2JBQ6uycb9dx+6jJTQCC4iZd7z4UaVYPObipyQE1pQ0BdPndcujXUEp1xB4qQYXT/zp7QBQBgZbRwvUR9yXu1VntNDg3n/+EMtGjDLOUUm0KE3HvCjZAy8e9dQ/79JVGjHEqoxu89JXu/5CYCWuA/kgCVxHl51KxcKaApWc8Rr8V4oTwWnFdXJs1muVDYROQsUh5Gkbj1ygB4mggfKiLeNJihp6gxX2GTIJt/IrEWBSJp64WEnRkIgHXuHOYGqF1Ewpv06DBYf44wn71CsgedaQUixl3oJlOx+E+LbaE62fKl1UbXyDYnGo6Wi+XpZ6y5tExZy4AyWtPBqNr4SqSJuUjA66YXn/t3L2OJSehQr2DSeXsYxX/H8aHm4az5S
 rN4kaB/5
 QJIQXYosOg2VnfhN2RWigfK+deQn7YMPvq1yldk3+mh/EfsUtwSaWtp2MAJHLUbz2LAS3o33hEex1+eNF8YXZLy4C3ViXoUMk5NDLlNCeP8wELUv2Y7cSXXqqIs8apwEdTAB07pI9GBzP0yhCJWSZIaKwMLkf8ji1Eut8JrauTBqd0aq4Yv4s3rAifizab4WjJfIzErOUzlCaADfinoLEwNfPMd/q/FiKnNWbLzwle27Ri2ynYF4dIMVU8rAyaJ0j3X3qHlla3seIyPhgBkuDEzrjczNUj9wvIz+hsF8gqp0Ywj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 27, 2026 at 04:24:18PM +0000, Carlos Llamas wrote:
> Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
> pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
> hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
> However, the incorrect format specifier '%lu' was used which triggers
> -Wformat warnings when building for 32-bit:
>
>   hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
>         |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
>         |                                         %zu
>
>   hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>         |                            ~~~              ^~~~~~~~~~~~~~~~~~~
>         |                            %zu
>
> Fix this by switching to the expected '%zu' format specifier.
>
> Cc: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>
> Note that I intentionally skipped the 'Fixes:' tag as I've been
> previously suggested _not_ to use it for kselftest patches. However, I
> can certainly add one if someone prefers it that way. Thanks!
>
>  tools/testing/selftests/mm/hugetlb-mmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/hugetlb-mmap.c b/tools/testing/selftests/mm/hugetlb-mmap.c
> index 0f2aad1b7dbd..2edbc992e6bc 100644
> --- a/tools/testing/selftests/mm/hugetlb-mmap.c
> +++ b/tools/testing/selftests/mm/hugetlb-mmap.c
> @@ -122,7 +122,7 @@ int main(int argc, char **argv)
>  		hugepage_size = default_huge_page_size();
>  		if (!hugepage_size)
>  			ksft_exit_skip("Could not detect default hugetlb page size.");
> -		ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
> +		ksft_print_msg("Default size hugepages (%zu kB)\n", hugepage_size >> 10);
>  	}
>
>  	/* munmap will fail if the length is not page aligned */
> @@ -131,7 +131,7 @@ int main(int argc, char **argv)
>
>  	hugetlb_set_nr_pages(hugepage_size, nr);
>  	if (hugetlb_free_pages(hugepage_size) < nr)
> -		ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
> +		ksft_exit_skip("Not enough %zu Kb pages\n", hugepage_size >> 10);
>
>  	ksft_set_plan(2);
>  	ksft_print_msg("Mapping %lu Mbytes\n", (unsigned long)length >> 20);
> --
> 2.56.0.rc1.315.gc6ed9934b7-goog
>

--
Cheers, Lorenzo

