Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3879CD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 19:12:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDEA26B0170; Sun, 31 May 2026 15:12:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5B06B0171; Sun, 31 May 2026 15:12:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCC246B0172; Sun, 31 May 2026 15:12:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBF436B0170
	for <linux-mm@kvack.org>; Sun, 31 May 2026 15:12:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 46648C211D
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:12:02 +0000 (UTC)
X-FDA: 84828660084.05.2B4960D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7DDAA180071
	for <linux-mm@kvack.org>; Sun, 31 May 2026 19:12:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxsXn3w4;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780254720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j/mmrMqN9cVeiG6v3MT7PKSh12sT3iMOb3Zkg1yWvI=;
	b=vXs0hmvRJr/jnpKxL0Bffeh594u6ZNj5Zox7ujMwVvgaT5HeFeB6kAEbL8xsX3wLH2bxOd
	ZqMfm/DARf/acE4DhIgUJVStHFbjX7L6+ooeewNoclE2xY//x1DiwYXzjpf1B7evWXHojZ
	pl23BFL1KCiTvenQv8DXOb3AToNiPwM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HxsXn3w4;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780254720; a=rsa-sha256;
	cv=none;
	b=C25v+UCCKztU2NBgkTnYUuwM0J03mf/4vYeTKyIz9PaqKaQN9FDYIKZoAUG8CEO71nc4FA
	w/t1COZY6qLnXgeP5u5OhxJwNLr5mfLZfNMHvQzzwWB1OnNj2OBnbq05FEfEdIzJtZmo0/
	9es5fOFa7rq6ZkfovdPF8OiW1sIdjSA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CEB9A60204;
	Sun, 31 May 2026 19:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88FE61F00893;
	Sun, 31 May 2026 19:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780254719;
	bh=4j/mmrMqN9cVeiG6v3MT7PKSh12sT3iMOb3Zkg1yWvI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HxsXn3w48nhvETfvikl1vwgfbymIGXFrRHsZTddKAZCyDvq2pmZaamPZaoMCUGJXw
	 KkL4tM95gB98srql2xgLuVe3Yy9VrSK2K60kSZ0Ey65Qf1/7KWdOGoM+/DGWNulerX
	 psDfrdfKwSMDYer0qdZid69g/TjAhZ3zI/gk5jR5bIJDVfOeGY5AgFOtECP3GF+lZc
	 eqGIL98TbRgqw7Cgc9+3i7LbsyS70CXgaiC9DhF8lbn0/tI3andx0y3zK0jtR34ghq
	 uBxKx3uNpB5BDPsXuAWlMv/TVpsoZbGkZzpfjl2JGeElVdBKisI9DGnfGxDtRXN7fU
	 o3IsqqY0WTr5g==
Message-ID: <a62302f8-24ea-4d21-963d-48bec766766b@kernel.org>
Date: Sun, 31 May 2026 21:11:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration pmd
 entry
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 liam@infradead.org, ljs@kernel.org, jgg@ziepe.ca, leon@kernel.org,
 shuah@kernel.org
Cc: vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, balbirs@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260529111704.1078346-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260529111704.1078346-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7DDAA180071
X-Stat-Signature: oob8dcm3iixuf9r1yrbtqdimjmyhcrq5
X-HE-Tag: 1780254720-808425
X-HE-Meta: U2FsdGVkX19U143pqNxyDANcBlRKwTPP48C/Wh1KWSms163pI9m2brDvSzvuD/Cb9CtgNFLrafEDyA7YXj5eLdBrHTb+mBHHvgmyS/N5E1VCvMJinMF7d6yoimnVkMQ0iOKqvnh8ZH66VYYeAAwNUaIKbj+4bFUYvX8YuKgERnVr4682R3JfMje+q56IriSbUu7JK86VNTUixer8NPa9/8geV4rFspWAGSWrem8CAz5x01jWCR13RQb7hC+YDNawutObV2nEm2m0P/wuv9cqIcgHrZ90gmDOw53iz/Zdzp3zee2jdiKKL1jHcCSQzAut+WW5eI21IMW1r7uU87zVcpJ3+xfVnCSXAyEj1EVg3gWrleXGqGZd+vQ6RMyy43+vb4cAccVf3wwnL/n7G0zCGkAxdFA6TwNIah46NdgECw1ian9jgTNS8enhJb+qA5Xf76DsrKOxtt41NTv/Md9m2il7vENpwewWDWCltVxihhxWxyal143O5ZoJu2GhQrzqwa9ZRnBsxbof66knZyTuXfW5Ql04r1FP7AdDj5i4Y5cVmd5wtDZ/mAsBLB8+w9pGzFCTh2VQDvRqg3wyLQkks9piNIQuHU0DHmVeR/KiNAbm/r4/15RCsbvc1tMOu0aA81abzx8p8EYrtN7DJPHJ8UhMelsjiSDQ08ZKYgxUpMFhxjU3KoZuJGJlO3ae3IghVETSaJS4T9U8beZThnDZl1FVhV3Ht7jMmG3eJTo+3glLsDAe/U047GE9QulyiJJsFjTCU3jYITACPeHq5X/sFDfyxUb5wDIcIXOPeIwG3wY6Wo1n0e81OhWFffHuy9Vinm8VGiRcqWcXKaE7vNy4+VNeLERqZqrtk6ZcP0DMCYiSzNAWTMRSGf3hgNTNWweHesJoofDUxf+Tmm6Ssm8fI54bTdWfmTGgLDna2R8ObvHXxFymFRW8FjjZwt4iy+cnD00vyroS2m/iwTZzDJG
 T0Wow/sr
 Ee4Tnr9Wg61GUSfUgxvpxMcqLIg4KnfBg54SG26tKNScXD93RBHijjeIkmPNj46zD/jOqyW/1B1mQd/6c4udndJnpq80RMcGGS5ScGNpvFjBWBfWSfDn4jeZ39ejWzQooUd2MBlQKYES6K4O+28u5ah6eW2CV3KFuhxTT6UVFSvIDwYqQUblXiqxA7YTCJutPU5/eG3y2TmEevEQyVuISDqzdTkIu8oZM0IZuurvz95yf2315daJk4P/xky41C9YsDYzT84JT2pLY7i22M2emLOQRZRSyc0JtbeJ3Sd1zWaPtj+FEqLuEiwIKuReBe85VnXc+BCNjYohB4IcIOafpD3FRc65U5sw1DO2e+bqpBKXCcUT85oazMhReIU8S8XEiD5vVH6Cjq+en3Tcl2xdZ4KD/0tcmbK7f762ncb1XpezTYU2mZfBrTiJjOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/29/26 13:17, Dev Jain wrote:
> pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
> entry. This became false once device-private entries at the PMD level were
> added.
> 
> One can hit the warning by patching hmm-tests.c with the following:
> 
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e1c8a679a4cf3..7f0a3384f3c5f 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -209,6 +209,37 @@ static int hmm_dmirror_cmd(int fd,
>  	return 0;
>  }
> 
> +static int hmm_read_self_pagemap(void *addr, unsigned long npages,
> +				 unsigned long page_size)
> +{
> +	const size_t entry_size = sizeof(uint64_t);
> +	const off_t offset = ((uintptr_t)addr / page_size) * entry_size;
> +	uint64_t *entries;
> +	ssize_t nread;
> +	int fd;
> +
> +	entries = malloc(npages * entry_size);
> +	if (!entries)
> +		return -ENOMEM;
> +
> +	fd = open("/proc/self/pagemap", O_RDONLY);
> +	if (fd < 0) {
> +		free(entries);
> +		return -errno;
> +	}
> +
> +	nread = pread(fd, entries, npages * entry_size, offset);
> +	close(fd);
> +	free(entries);
> +
> +	if (nread < 0)
> +		return -errno;
> +	if ((size_t)nread != npages * entry_size)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  static void hmm_buffer_free(struct hmm_buffer *buffer)
>  {
>  	if (buffer == NULL)
> @@ -2314,6 +2345,10 @@ TEST_F(hmm, migrate_anon_huge_fault)
>  	ASSERT_EQ(ret, 0);
>  	ASSERT_EQ(buffer->cpages, npages);
> 
> +	/* Exercise pagemap on a PMD device-private entry. */
> +	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
> +	ASSERT_EQ(ret, 0);
> +
>  	/* Check what the device read. */
>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
> 
> 


> Therefore, remove the stale migration-only assertion.
> 
> Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> Applies on mm-unstable (404fb4f38e8f).
> 
>  fs/proc/task_mmu.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 1e3a15bf46f4e..58938e62154d9 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
>  			flags |= PM_SOFT_DIRTY;
>  		if (pmd_swp_uffd_wp(pmd))
>  			flags |= PM_UFFD_WP;
> -		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
>  		page = softleaf_to_page(entry);
>  	}
>  

The whole thp_migration_supported() guard is a bit shaky, right?

I guess device-private entries currently imply thp_migration_supported(), but
that thp_migration_supported() check is really questionable and should likely
just go away (else if -> else).

Staring at pte_to_pagemap_entry(), likely we'd also want

if (softleaf_has_pfn(entry))
	page = softleaf_to_page(entry);

to prepare for PMD swap entries.


Anyhow, both are unrelated (can you send patches to clean it up?)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

