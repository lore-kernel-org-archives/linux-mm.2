Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72EAFD3515A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 08:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ED9D6B0005; Wed,  1 Apr 2026 04:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99DE16B0088; Wed,  1 Apr 2026 04:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B37D6B0089; Wed,  1 Apr 2026 04:32:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 795EA6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 04:32:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07E681406D3
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:32:10 +0000 (UTC)
X-FDA: 84609319620.10.EFBE0B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3EB034000A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:32:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aeYzej/w";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775032328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnX9oT/VhP2dm+KTNMx0MS6cbTxjYJRCfj89YTEyYzI=;
	b=surt67eBekFV8uOvFKUAZyNCdSaEOr6ZnwwdBmGrJ8TX5DiBxqC0BF5Ij3Bk+0Zfq8DWsO
	7OfmcbM98aeOz22p90VldiE8g0XfkyWp66e0QIk5/+IXjudnP06xXSRedhOyDlRzJc38yR
	o34ItCUHA8V83vfLKHysDP24Z90OvDQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aeYzej/w";
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775032328; a=rsa-sha256;
	cv=none;
	b=XqtPamUQzhdPLCXuTi8cb0uwig7WB3EN9aLRjG+kI1Zm1sMf8pzRLkVffGggH865HVZGp3
	Xwt5BfVWmidF1EmoudTpaaFbh4JG4DHaPqDCMsuGA2duP4mExvMWZAFJuQKs3vpLkFZXTX
	27Gv+p8WKde3pguD73c/wNaoPkQrf0o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28DDA40677;
	Wed,  1 Apr 2026 08:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9EAC4CEF7;
	Wed,  1 Apr 2026 08:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775032327;
	bh=P0bnyV0hKEXKjl48i1RFmLFy6/VGUnDR9D0oWD/ovfU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aeYzej/wufj38Rvm2EwY2ZDCsCYCIU2RG2HHJwMZcdxfAt7ClH3/zAtXCD0aKnZ6e
	 /o7RXd0ZkJnGolmwdIhN3apX5h/JE/14W66YvQPux2cbRs2aoBHytEFuEaEcQmPDfS
	 CpMwGOCN2zzvsqcdKUlvBEeo+jH+VCTqd/rGXj+J092JllK+GJN4WcFxkRoKiXRh/p
	 MzS44WU9c5ixILdhDq5JyszI48GBAYDHb7ZUeKClDf5oCuDAfBxan9Ceo/Tk8rNqT9
	 /+cix9RddjMiWV1O+4woRGglpG34QFXBXBzSAcnoTUTYrHeL2APBDd+8w0Y1r5iPrp
	 fMRiJMosmR0ZQ==
Date: Wed, 1 Apr 2026 09:32:02 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <2b2eb985-ecf9-4477-a967-872153199dcf@lucifer.local>
References: <20260331073627.50010-1-ljs@kernel.org>
 <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
 <1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local>
 <20260331175851.91867c426e09a5b3eccc1d6f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331175851.91867c426e09a5b3eccc1d6f@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3EB034000A
X-Stat-Signature: nw6oygaziks8pjso9yd9cmmgwigzmg9y
X-Rspam-User: 
X-HE-Tag: 1775032328-497311
X-HE-Meta: U2FsdGVkX1+RXocow3Okpo74vLuILN0HTS7RPW/fROvZbf1BcIdTET+57P/uAw9yOYkuyMnCbqIbYGaG6+bhBTl9h5ISsxIEbP55sIsziG0hhgpoTxdkAYPwitYmkJoSbt55GXGRpxn6yJtj6MTrY7SbQKX0SZ2gl404jU89RB395r/KUaH/u/vrhTrCuUQo9VpV1t8ZXMu38KK/hwBLfPkYd67vne42ncvIkbBnEm9KYZv87s4/tcGXcr09SCUU6ds06fmaJ/J4W8zF3fONtUi/kxBPayhqLoRGr1PCVg99jVi1UOOTO1soZTIaerDatu5uLJT/g7HknbmpdGzT8gw5XjvNthBbTIVS0Cl0jB/9u2YKZ0CeyFH/uRpq2x/S5iYxHmGzD7FjqsimxnZBuZUmFSH2R08Z8Ddz7ID3nefriuwXN9ZIjRzPSn0CKu8YB2xpTYSK1SD33223lQdBE51WrkyxXvNV6cFLY7lVBX90yTqOrNEh6Thbleskzde2HDYDgqYy2LYuUGx+UiLcqZUSGgS7OkjiOZGE0NmCEytEDz44KSgvHo+tiuw7/OOZjZPhptksiEoUM3RCiO5JMgq5BCUSYf5YzD0t2bHm+BPmLimCtL4F7sVqvqjK46iZJJyZTABbvLaD4Z8RZBpUnmFqzK5R2jJE26isghBEpea45LN2T8NcOgaht+6ti6bUVt/meJJ88m8u0+p/qpCg2hG8ugNrQ2k1sUBchF5E1dmai+R2SxA5RGKfhSABKZdGdiNMpoDTNV0KmL91k2jO3lg9epzxTrCyLuY6xH00SFWqqX1LA6Vqax9hg0t/yvCpO9phUKbaEygxwUhRJFQziL/v56yWz4aWY4nOz92DjKdIVcDGY//8UXfS0dYCW7RGHv/fd93ypKM/bCbEmKUHwVtkGhtDus75R6sn2ZygloWnyLaXgBAFQG9J5WQEw804nOHwcsKExEfPhQ42rbR
 VGaYnVIl
 X2J+yRfCQGEZT7lF34+tzUaV/JWvD/P9JMWLKX5DPZjYRaesRUN0tBRgk6YtQD3yMgC0xdEONLVi2zJtGUf7RhhNH7MPsdu0iRA/gdTZArEtNSzthvfIJ99IV+uLzFmS2SwqsNLgmY4gXDxeB3N8T8NBNmU5ka1WiTaKQN7BZk6VqpilBQTUQlXJCWpinndzTaIc2OuztfdRDtJPMUWrNMCdtnOZvjobdNQUCdO7QOyHAgNzHvCQ0r9kEY3QN6H/SRKtYf3xoyxEW07ckm+iaUMQGzE98puj1TWgjzuDredY6UtT+OH2gszbVt2yBII70f+TZPlFqZbF2Y8NRha9XdyIJQ2Ld4UfUxJ2Q/rdWnqMJEZFuR3BIwE+6uPRw7sLHAK+QbUqhYRfn1Z1DkqQWmpqV3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 05:58:51PM -0700, Andrew Morton wrote:
> On Tue, 31 Mar 2026 11:08:03 +0100 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Then again, and contradicting myself elsewhere on fix-patches blah blah blah,
> > since this is just test code, I checked the below and it works the same and
> > triggers the regression.
> >
> > So maybe we can just apply that?
>
> Here's how the two folded together will look:

Thanks, LGTM!

Cheers, Lorenzo

>
>
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Subject: tools/testing/selftests: add merge test for partial msealed range
> Date: Tue, 31 Mar 2026 08:36:27 +0100
>
> Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
> an issue in the loop which iterates through VMAs applying mseal, which was
> triggered by mseal()'ing a range of VMAs where the second was mseal()'d
> and the first mergeable with it, once mseal()'d.
>
> Add a regression test to assert that this behaviour is correct.  We place
> it in the merge selftests as this is strictly an issue with merging (via a
> vma_modify() invocation).
>
> It also asserts that mseal()'d ranges are correctly merged as you'd
> expect.
>
> The test is implemented such that it is skipped if mseal() is not
> available on the system.
>
> [ljs@kernel.org: simplifications per Pedro]
>   Link: https://lkml.kernel.org/r/1c9c922d-5cb5-4cff-9273-b737cdb57ca1@lucifer.local
> Link: https://lkml.kernel.org/r/20260331073627.50010-1-ljs@kernel.org
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Liam Howlett <liam.howlett@oracle.com>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: Shuah Khan <shuah@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  tools/testing/selftests/mm/merge.c |   89 +++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
>
> --- a/tools/testing/selftests/mm/merge.c~tools-testing-selftests-add-merge-test-for-partial-msealed-range
> +++ a/tools/testing/selftests/mm/merge.c
> @@ -2,6 +2,7 @@
>
>  #define _GNU_SOURCE
>  #include "kselftest_harness.h"
> +#include <asm-generic/unistd.h>
>  #include <linux/prctl.h>
>  #include <fcntl.h>
>  #include <stdio.h>
> @@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *
>  	return 0;
>  }
>
> +#ifdef __NR_mseal
> +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> +{
> +	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
> +}
> +#else
> +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> +{
> +	errno = ENOSYS;
> +	return -1;
> +}
> +#endif
> +
>  FIXTURE_SETUP(merge)
>  {
>  	self->page_size = psize();
> @@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faul
>  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
>  }
>
> +TEST_F(merge, merge_vmas_with_mseal)
> +{
> +	unsigned int page_size = self->page_size;
> +	struct procmap_fd *procmap = &self->procmap;
> +	char *ptr, *ptr2, *ptr3;
> +	/* We need our own as cannot munmap() once sealed. */
> +	char *carveout;
> +
> +	/* Invalid mseal() call to see if implemented. */
> +	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
> +	if (errno == ENOSYS)
> +		SKIP(return, "mseal not supported, skipping.");
> +
> +	/* Map carveout. */
> +	carveout = mmap(NULL, 5 * page_size, PROT_NONE,
> +			MAP_PRIVATE | MAP_ANON, -1, 0);
> +	ASSERT_NE(carveout, MAP_FAILED);
> +
> +	/*
> +	 * Map 3 separate VMAs:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RW     |    RWE    |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 */
> +	ptr = mmap(&carveout[page_size], page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr, MAP_FAILED);
> +	ptr2 = mmap(&carveout[2 * page_size], page_size,
> +		    PROT_READ | PROT_WRITE | PROT_EXEC,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr2, MAP_FAILED);
> +	ptr3 = mmap(&carveout[3 * page_size], page_size, PROT_READ,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr3, MAP_FAILED);
> +
> +	/*
> +	 * mseal the second VMA:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RW     |    RWES   |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 */
> +	ASSERT_EQ(sys_mseal(ptr2, page_size, 0), 0);
> +
> +	/* Make first VMA mergeable upon mseal. */
> +	ASSERT_EQ(mprotect(ptr, page_size,
> +			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
> +	/*
> +	 * At this point we have:
> +	 *
> +	 * |-----------|-----------|-----------|
> +	 * |    RWE    |    RWES   |    RO     |
> +	 * |-----------|-----------|-----------|
> +	 *      ptr         ptr2        ptr3
> +	 *
> +	 * Now mseal all of the VMAs.
> +	 */
> +	ASSERT_EQ(sys_mseal(ptr, 3 * page_size, 0), 0);
> +
> +	/*
> +	 * We should end up with:
> +	 *
> +	 * |-----------------------|-----------|
> +	 * |          RWES         |    ROS    |
> +	 * |-----------------------|-----------|
> +	 *            ptr               ptr3
> +	 */
> +	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
> +	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
> +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 2 * page_size);
> +}
> +
>  TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
>  {
>  	struct procmap_fd *procmap = &self->procmap;
> _
>

