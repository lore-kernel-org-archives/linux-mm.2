Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8C9CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1A68E00B2; Mon,  3 Nov 2025 12:13:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4797A8E0057; Mon,  3 Nov 2025 12:13:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5EE8E00B2; Mon,  3 Nov 2025 12:13:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD6D8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:13:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C002B879D4
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:13:20 +0000 (UTC)
X-FDA: 84069941760.09.0D84757
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 06B1E40010
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:13:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jJhFr/4Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762189999; a=rsa-sha256;
	cv=none;
	b=7/UQusBVz67FSEEG5+ZqeJySoDYjcnFhtpgnpaK7H+yDK9SENJxDk5bIAIz2OYmqmnpdpR
	zjvk7aXxrmmffA91CrYokqTrlePxBMEssUklofLXBPOE6OjzmUa8G4xMhaC3popUa0tngp
	OSYkKnNI03hJGwdxtqCQhZljOwMY/dw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="jJhFr/4Q";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762189999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fsufg2mIfAYSTab9OFgsuFbnkDYNgFVYHakn7svNvdY=;
	b=RxZ2kJcm6B7Apyd6F8YeOokO6DTatft7if3tzS225Yh40TA8zH6T0V2Iivy9Uxzel3epgg
	P8dAXHSstAFYLeHp3wyx5+QaUcvU62KKzNlzKAGgC9PNrfUbVLi+s9FrpPRF3+OZboaZug
	LOCq2/SdJBm8HIJjrtHVaiXM+jUbSRE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12C96600AC;
	Mon,  3 Nov 2025 17:13:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DACC4CEFD;
	Mon,  3 Nov 2025 17:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762189997;
	bh=Nfuy/Y5/u2wXbohcwDnEdJwCaH6aPns6pDI6CT+NKiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jJhFr/4QOzl07oYJgTxRVXnu7lH/ADPT5cwLT8TT0RAqTTwD8y7szPqcE45ge8DS3
	 JiB/kaIEV/Fpep2QN3jnRLPozz0+3jDHsMz9xCiiC5WJVUXUKtkm/yLNjDJ4jOlD9C
	 yqlEQXnjfHZMSDuZUnDIcyzWqVC8UhurlXx0UJE9WbFeKFaUPjHTOc/eE4uf80j75e
	 bsp1fsSgNxIM5Bk9gAqLrfwSaIhTS1c3NXbg/FmzOV5aVrOVvYa/oxNVKDsCtYwSMk
	 9jSbYnjSZYhjx5b+yvioev2VaOq/I6LTAN/TqRkthfpZeMAbJA9SK49h30Z2muZ8bO
	 PABGgddLWtCzw==
Message-ID: <6c34ce4e-1212-4dd0-8b7c-6af952dda3cb@kernel.org>
Date: Mon, 3 Nov 2025 18:13:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] mm/selftests: add max_vma_count tests
To: Kalesh Singh <kaleshsingh@google.com>, akpm@linux-foundation.org,
 minchan@kernel.org, lorenzo.stoakes@oracle.com, david@redhat.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com,
 android-mm@google.com, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall
 <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251028212528.681081-1-kaleshsingh@google.com>
 <20251028212528.681081-3-kaleshsingh@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251028212528.681081-3-kaleshsingh@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 06B1E40010
X-Stat-Signature: 98yo6y4abr6fgqgmtp8z6mrng1xw3cj4
X-HE-Tag: 1762189998-24445
X-HE-Meta: U2FsdGVkX1+5+ha6CU1vqJUFkbSt7VyL6w2R8UrJdnl4S1tPbVErpEybjrXCL1BXLqrTeFJmaVklATiMOTZr1xBDBUrgiv2cC2sP5CvHZNoth4U6t81f8SZ09B/rqpUBL9ZX3Tsyr28JZngji8NqdSxUaA69BKmcS4VKE3zAD5ShRydwhGbD2qwPwKJz1QMbDmvuIYGHd77uK4/zrgUPYV8EBXy/eXKaHbSEq9wiMUQIPEQMvmp5uws1SrVdzLzs4NPDIp6iDigyyYqqz9eLAuL9/h3Er3teEyO/BxB3YRHFuL1qyp7KSj4xvDp+c+ucoY+rhu1GkAk7iw8XisiVfiz/u+q+BkTlYPUKwNwC3npeTJlO2TAl0ECdmwI35jd/0YwHAqbTv1lOUsLdm11CT+IyCTHnVEOZ+IAY6DDiW/+hErjX6GgAIhSqOfa2vGDtjnczglKJBJEesfidY43t7vGd4AYvhRL+NF5NoA6PAOqdJ4N50EZ4RAW9KhnhkHboL26vDw2bzpFlgOTDhOrrBS3s3tR66LupO8KKgs+C7LfV/1KirROf3frjLffltQBZcxFNJPkva/2QsPFdjv220oFtb/aDnRhYxnjt6Aox0E88LZ6mBFUdxa8TAciQQB+0QHH5HItWTFjPLbef3JaGx62vGI0CNip78HDKgEPWQKFOs43U3a9nsBX3b4m32Eq7RU4tLNfVQtYVj4EfP8iPJ5gmvjIzKZWH76TgWqDxxlbxZb2CY1jiOTxBKe0kT+QTPiDbsvsN/Ou8bA/RI/BGLZlBA2D4Y4O9QSdvGw6/ZR1PUdM43TmLySGB4m+uOG69kyc++zwkgwxypn+03UD2q2nMEZUMVQN7MfzvQfkY0CNqclIsPaNkWA6Fn87sZqNUbl+Fp1SlN04zIelMUPDsUlQEdL7imKL0vuJtAKAqdEb0+cTIiTfwQtGhDZK9nhlhvhXwmd4B4RxsyARYKlL
 +3i5JFF3
 6CRpPhItY0OEHI5KdLbX52hz/mSLTqAZoQy5IJaBz89Jbay/UxNdIFYW8baysjVYG9L33/Xoi3uFpN1oL1397NqWjivjgWvQePvVN49OLG02ZxsLiQwjhSOn6apqWIKoKyPv2G8wOMaZknvnTF2BI88mUL/YAM9IsNKH3W0WAUyJsM+GQ1t91o3ZyOjuKsq8X0TBMO7yEIlj0PPmstJWmegpoqlE8kDlx+IFHmmp9HG8ba1WiJXkGupkP9m1S1FRcXPls2iwLHoeFU6r5+Z1bymWdVy3sK1zswWNMK7V+YaMeP/6WR88zlgQxkYWUEuu2WPWY0M0b+/nrGzRNcyz7tbzWoUVbhdcjyDjVEiKEsaB6Hc3oHkLXFyiq8yYBwe5BXq/bSoZ8jmnlQPiNv9LZZLJBDDjdlkMtaW0uoTCYTsAryE6F4OJ0RIXp5WYW5UtDCarbLggVrTpm38c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.10.25 22:24, Kalesh Singh wrote:
> Add a new selftest to verify that the max VMA count limit is correctly
> enforced.
> 
> This test suite checks that various VMA operations (mmap, mprotect,
> munmap, mremap) succeed or fail as expected when the number of VMAs is
> close to the sysctl_max_map_count limit.
> 
> The test works by first creating a large number of VMAs to bring the
> process close to the limit, and then performing various operations that
> may or may not create new VMAs. The test then verifies that the
> operations that would exceed the limit fail, and that the operations
> that do not exceed the limit succeed.
> 
> NOTE: munmap is special as it's allowed to temporarily exceed the limit
> by one for splits as this will decrease back to the limit once the unmap
> succeeds.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---

[...]

No capacity to review the tests in detail :(

> +
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d9173f2312b7..a85db61e6a92 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -49,6 +49,8 @@ separated by spaces:
>   	test madvise(2) MADV_GUARD_INSTALL and MADV_GUARD_REMOVE options
>   - madv_populate
>   	test memadvise(2) MADV_POPULATE_{READ,WRITE} options
> +- max_vma_count
> +	tests for max vma_count
>   - memfd_secret
>   	test memfd_secret(2)
>   - process_mrelease
> @@ -426,6 +428,9 @@ fi # VADDR64
>   # vmalloc stability smoke test
>   CATEGORY="vmalloc" run_test bash ./test_vmalloc.sh smoke
>   
> +# test operations against max vma count limit
> +CATEGORY="max_vma_count" run_test ./max_vma_count_tests

I'd just call it CATEGORY="vma" or "vma_handling".

Which makes me wodnering whether "vma_merge" falls into the same category.

Smalls like mremap test is similar.

Point is that "CATEGORY" stops being really useful if we end up having a 
separate category for each test, right? :)

-- 
Cheers

David

