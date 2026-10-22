Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33867606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ISANbqOA
Received: by kanga.kvack.org (Postfix)
	id 526546B02B7; Thu, 22 Oct 2026 04:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF216B02BB; Thu, 22 Oct 2026 04:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4140F6B02BD; Thu, 22 Oct 2026 04:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2BB6B02B7
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:36:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 05749160799
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:36:30 +0000 (UTC)
X-FDA: 85349605740.11.1DE1E46
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5DE2A120006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:36:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISANbqOA;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658188;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DBrs/gcG5VXg30p8wzsJYiDFPk2IoeJtx8fNzQxlKo4=;
	b=e/1O1ft3eA3oWCau/DghwxoD1IL2T1ga+P22YEozE6Gpu+fovrsoSj7rfaAG21w/ZHY9T0
	TKEdLBqgFCOeUzBulMOLzA3szEV4axmy47sdyw6simbijgFF/Uf6i9mXNtC01YRnr+4RW7
	krRHsgAgQV0ChxQTn1UjJqQIWkEbsqA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ISANbqOA;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658188;
	b=kMrIbZrfg/cQfwz9h9Vy8U48gSr1LzyfPBFlAj8cjf/cGKZlwZhquAC7iDYEEQ0rjM8Bpe
	zY4m12KU5j1+TsDvGAiFBNeI/LsE/nkQe8Q/4BVf5T3fD1/lP18Vrt+ghLnLhBnA754ZDX
	keCHjYny6iS7q9plNBoDrm3OKsNsvRA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DDFD66057A;
	Thu, 22 Oct 2026 08:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA93F1F000C1;
	Thu, 22 Oct 2026 08:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792658187;
	bh=DBrs/gcG5VXg30p8wzsJYiDFPk2IoeJtx8fNzQxlKo4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ISANbqOA8PQc5AHcRbyz1isXLschbrOEXIDHX65NzzgUziwGy+EgfojqKlx+lNbC0
	 G6W95SQPvOEiXOd34eBezFgY+K7ioD438cuqoCsA2OhHWcsK7cEtBfRB5l9iJ0sWFo
	 loaNGY4v/NexCFj5ef+O5W6MTq1JZoI9L7RxJN5qOcKVnjO8rORcKOklOs6c5xkzgS
	 /CGhlR7jeKes+M+6OZf6eZmXyVA1HgaYdUXL4FGtSGvgiNM0AzhOOapPrDUe7+0uOd
	 PkyaM7rqpivL2aZtluh/+EYGRdo1vOLwKafA+1Ups+Vo5UHvjQSrk61PKy5M9adBfX
	 1FlcsbbLlyQHQ==
Date: Thu, 22 Oct 2026 09:36:22 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Danish Khateeb <danishkhateeb03@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: merge: keep the far mremap() targets in
 the carveout
Message-ID: <atnKsrZ752uBR6QT@gremlin>
References: <20261021164810.45846-1-danishkhateeb03@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261021164810.45846-1-danishkhateeb03@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5DE2A120006
X-Stat-Signature: sb6597upb5t8xk7czsbce7nu9mjrnzsc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792658188-544361
X-HE-Meta: U2FsdGVkX198RhtwWyDCjZSjjnzrZIfTafFBlAb6rzf6hfBunKoYiegi9VFRyDQyuCAazMaRs2BnOfzfsE9WbUhfRRHtP5BnFvGy3ClWFrZSwx16Sr9CgodABzaQa6zRp2Um1bN462cga3sRPqNFPxIPs4QEtXN9DW4BmdjQLdb2CPDQM9SCX7Ra4+Epwu7cR50KymNebpzfZExtcjF3iIK9s64CAvfLxcApxYMLdma8S4QS41wIkGRq1QeItPJ/9FYzr0Elp3F1ZlJuGNkZECRxGYu/0rIB7gsBQj6nUTYyfW/Cri2uRKwG+1/aJf+svmu17jJYC36B0kuTMFos+HbO/6FHlhMV61a1N9bJJLmtPrL0zWj5JqoM9LEZ+3T3vMB3OE3EHDzIVS20Er9MLCpve+98+KAwqJUI2HK6SqucnVi+N8zUlRQMlw5J3CgxYXkkUpIX3mxCrq2GrG6KmwaJSQaHc3A+MRtaND6brgYkhmGCaWrAM5duvERuDr+ybXhnnd4FmuinMm/eioTXzgNk8Vl7ZPZ7GplrL9I1GPzzvrthsj/+dziJMdw+zlK8BYYIuiIOFqvDyoPZ27UdI4G/aynyv4oetFq3U1AOYcnS52+Kw6e1XqlxVQ/a3+Phs3yMctPiaFfbTgjeWPI0Uvl6k5b97+RwUXCpnT08KKFLH9x/iGzvcSyj1v7aI7Sr4yMUBxsyuaR1Q++4xeAKhvQDbqvr8VDBlkgJSop+udj/5MkkhqeWjriuCJ+4KSk8hifTBMkiIyVCR6c/aHjm7SwRO8Qp4/PoiVkXqWTHO3dMUHi9iIFeZvJ0nSeyVIT8lZ3dDM3hqKqZsc0x7ia1K+x4RfBvAAefe5kvPKWkFgj02KPr7A3vX423x2c2S2LKfdPcHuVTy2F6p29ZnR/Ht3T67YOWmTE63Io6hFybLSMucPRbsbm2NizC5xZvhvzEgrCVpztSY08ySRaXw0k
 0o9aPQCk
 CrmzTve5pdA8xgIDdkYcAQqqLlw7FqV2cCTjCVw6HymQA7pe0+lMXRmTxNZlbiSu3pUNeybFpwsDEqieRKjnnaBajvedPs0W4c4HCHLE7tivO+tFAOZE1258fOL+OwueteqddOF0UHllnlA5WkAv8YJ7+Uy1VUK2c3N3Scw5Q+UqdwXLNZoJg73zHq/8sqCuf3Ti1ROFpg5K87kGCBqAMMfVAGOX0oBt/L71mZXUgHDZPK4G01omBxZoAYTOPTuKHrwC+v6mnIJzhc9ke7fxQX5TJmD51NCD0gxldC1ewVSaf+88=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 11:48:10AM -0500, Danish Khateeb wrote:
> The merge tests map their areas at fixed addresses within a 30-page
> PROT_NONE carveout. Several mremap() tests move an area 1000 or 2000
> pages away to separate it from the others, but those targets are outside
> the carveout, and MREMAP_FIXED unmaps whatever is mapped there.
>
> Under virtme-ng, the shared libraries are packed right above the
> carveout and the dynamic linker starts about 4 MiB above it. The moves
> then replace part of its text with an anonymous mapping, and the test
> crashes in its next lazily bound call:
>
>   merge[6980]: segfault at 7f7ebb3c1e60 ip 00007f7ebb3c1e60 sp 00007ffd35fbaec8 error 14
>
> Two to four of the mremap() tests then fail with "Test terminated
> unexpectedly by signal 11", depending on the exact layout. On a host
> where libc is mapped at a 2 MiB aligned address, the targets happen to
> land above the dynamic linker and the tests pass.
>
> Since the areas are all within the first 30 pages, moving one by 30
> pages is enough to keep it apart from the others. Add FAR_PAGES for
> that distance, move areas by FAR_PAGES or 2 * FAR_PAGES pages, and make
> the carveout 3 * FAR_PAGES pages so that it covers every target.
>
> Fixes: 4e25f85b9f85 ("tools/testing/selftests: add mremap() unfaulted/faulted test cases")
> Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>

Hmm I don't know why I did it this way :))

With the comment dropped as mentioned below, LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>
> Notes:
>     v2:
>     - Replace the 1000 and 2000 page offsets in the tests with FAR_PAGES
>       and 2 * FAR_PAGES, and derive the carveout size from FAR_PAGES,
>       instead of only enlarging the carveout (Gregory Price).
>     v1: https://lore.kernel.org/all/20261021011929.89150-1-danishkhateeb03@gmail.com/
>
>     Tested under virtme-ng (9p root, glibc 2.44) on next-20261020 with a
>     KASAN/lockdep kernel, three runs of each binary:
>
>       merge before:  pass:22 fail:4 skip:1 (SIGSEGV in ld-linux-x86-64.so.2)
>       merge after:   pass:26 fail:0 skip:1
>
>     On the host (glibc 2.44, libc mapped 2 MiB aligned) the results are the
>     same with and without the patch.
>
>     An LLM was used to help with this patch.
>
>  tools/testing/selftests/mm/merge.c | 39 ++++++++++++++++++------------
>  1 file changed, 24 insertions(+), 15 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> index 7dd2933417c1..208ad7e340fa 100644
> --- a/tools/testing/selftests/mm/merge.c
> +++ b/tools/testing/selftests/mm/merge.c
> @@ -22,9 +22,18 @@ FIXTURE(merge)
>  	struct procmap_fd procmap;
>  };
>
> +/*
> + * The tests map their areas within the first FAR_PAGES pages of the carveout,
> + * and some move an area FAR_PAGES or 2 * FAR_PAGES pages up to separate it
> + * from the others. MREMAP_FIXED unmaps whatever is mapped at the target, so
> + * the carveout must cover those targets too.
> + */

Please drop this comment, it's pretty self-explanatory what you're doing here.

> +#define FAR_PAGES	30
> +#define CARVEOUT_PAGES	(3 * FAR_PAGES)
> +
>  static char *map_carveout(unsigned int page_size)
>  {
> -	return mmap(NULL, 30 * page_size, PROT_NONE,
> +	return mmap(NULL, CARVEOUT_PAGES * page_size, PROT_NONE,
>  		    MAP_ANON | MAP_PRIVATE, -1, 0);
>  }
>
> @@ -73,7 +82,7 @@ FIXTURE_SETUP(merge)
>
>  FIXTURE_TEARDOWN(merge)
>  {
> -	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
> +	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
>  	/* May fail for parent of forked process. */
>  	close_procmap(&self->procmap);
>  	/*
> @@ -115,7 +124,7 @@ FIXTURE_SETUP(merge_with_fork)
>
>  FIXTURE_TEARDOWN(merge_with_fork)
>  {
> -	ASSERT_EQ(munmap(self->carveout, 30 * self->page_size), 0);
> +	ASSERT_EQ(munmap(self->carveout, CARVEOUT_PAGES * self->page_size), 0);
>  	ASSERT_EQ(close_procmap(&self->procmap), 0);
>  	/* See above. */
>  	prctl(PR_SET_MEMORY_MERGE, 0, 0, 0, 0);
> @@ -660,7 +669,7 @@ TEST_F(merge, mremap_unfaulted_to_faulted)
>
>  	/* Offset ptr2 further away. */
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -721,7 +730,7 @@ TEST_F(merge, mremap_unfaulted_behind_faulted)
>
>  	/* Offset ptr2 further away. */
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -785,12 +794,12 @@ TEST_F(merge, mremap_unfaulted_between_faulted)
>
>  	/* Offset ptr3 further away. */
>  	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
>  	ASSERT_NE(ptr3, MAP_FAILED);
>
>  	/* Offset ptr2 further away. */
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -870,13 +879,13 @@ TEST_F(merge, mremap_unfaulted_between_faulted_unfaulted)
>
>  	/* Offset ptr3 further away. */
>  	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
>  	ASSERT_NE(ptr3, MAP_FAILED);
>
>
>  	/* Offset ptr2 further away. */
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -1035,11 +1044,11 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	 */
>  	ptr3 = &ptr[10 * page_size];
>  	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 2000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + 2 * FAR_PAGES * page_size);
>  	ASSERT_NE(ptr3, MAP_FAILED);
>  	ptr2 = &ptr[5 * page_size];
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -1075,7 +1084,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	 *                  ptr2      \       ptr       \       ptr3
>  	 */
>  	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
> -			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
> +			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr, MAP_FAILED);
>
>  	/*
> @@ -1110,7 +1119,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	 *                  ptr2      \       ptr       \       ptr3
>  	 */
>  	ptr = sys_mremap(ptr, 5 * page_size, 5 * page_size,
> -			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + page_size * 1000);
> +			 MREMAP_MAYMOVE | MREMAP_FIXED, ptr + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr, MAP_FAILED);
>
>  	/*
> @@ -1168,7 +1177,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	 *      ptr                     ptr3      \       ptr2
>  	 */
>  	ptr2 = sys_mremap(ptr2, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr2 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr2, MAP_FAILED);
>
>  	/*
> @@ -1203,7 +1212,7 @@ TEST_F(merge, mremap_correct_placed_faulted)
>  	 *            ptr                         \       ptr3
>  	 */
>  	ptr3 = sys_mremap(ptr3, 5 * page_size, 5 * page_size,
> -			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + page_size * 1000);
> +			  MREMAP_MAYMOVE | MREMAP_FIXED, ptr3 + FAR_PAGES * page_size);
>  	ASSERT_NE(ptr3, MAP_FAILED);
>
>  	/*
>
> base-commit: fcec4f4bcc1101dbd7e3aff267856b3bbfe128c6
> --
> 2.56.0
>

--
Cheers, Lorenzo

