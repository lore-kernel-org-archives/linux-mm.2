Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2417FF60F7
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 09:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35AF26B008C; Tue, 31 Mar 2026 05:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B936B0095; Tue, 31 Mar 2026 05:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 220FC6B0096; Tue, 31 Mar 2026 05:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 136256B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:56:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B701DE16D3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:56:34 +0000 (UTC)
X-FDA: 84605903508.07.4476156
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6FBE14000F
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 09:56:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLzC4UzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774950993; a=rsa-sha256;
	cv=none;
	b=U8htz1D/ZbDi4R1QbaOqHGuwhyJ9jRR3c6XBqPElmMZDtz4OptoWhWLAyfkNPDGZXKBsWq
	510m2VYvaTnM2eDKBMvgwzNkr9h7+Q+QPawKY5Jx1mniNF5cxIS9yodMUBZHHb7wxlE1YH
	Vf89tJKUUG1ED0WPEZRQgCWr0ZZkUTw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mLzC4UzY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774950993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrtHod6G2NIOQlxQr8SlgUPIwSb1/Y2PfSDszpMYCxg=;
	b=bq7eQpagBwsGeRKbPKPZU4KQMlY54thPy61P34O09AVT67NMXE5qLinhH8EulGD1Gcf9w0
	z+T/YBKK3q8hqz9lvKD8z+iHEfrAFuLydVJrk8l+rl/LWhGijh/ieQyGvmFCjddrRzuy70
	A3o3M6KTNXm1aJOwnZUVH4cVSSwoqhE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1F6742B68;
	Tue, 31 Mar 2026 09:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FF1C19423;
	Tue, 31 Mar 2026 09:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774950991;
	bh=q8CqW5RFkwBpnoolLTU8TCC4V54NnoOYDlrd4aVdQcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mLzC4UzYlXj+2XiKOIfVUvr5YGYadO0n1JZ/9MJXaLCrGuCpWwj3hskxdpdzLNEsS
	 una6NVu2Ka+qyoX4/WFSB2eWOG0tVzO2R0rKnBnwdSWnO+C4pub72YIr+u3o22VkgK
	 OpzJ3iikx71JTHJQqK+Kgi6gexrLN1nuRS5qoJqqWS7aZE/kybgF8ct3DLwkCEL4gy
	 eIPmQRyNHxDzSboFxmCj23SzvKI9uGNG8JR8qSqFmahB0kjOulVHDLh2bZWxWTjAIR
	 FTlShI+4m82ouLMWBVs7AtHlFJfm0/C9MMRNCg+42dbwdKATLT6UM2TbO6yl28CmQv
	 R8ZakVZ2aI4Eg==
Date: Tue, 31 Mar 2026 10:56:27 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <68ec6eff-9406-4cbf-a886-ce5646929012@lucifer.local>
References: <20260331073627.50010-1-ljs@kernel.org>
 <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ne3bppkwlk2srskam72k56jq5q63dhnvk67vzztciw2uxxcyr6@gki5bfznhqxa>
X-Rspamd-Queue-Id: E6FBE14000F
X-Stat-Signature: zqp6xkpqp3z95qe4qo7cehxaw49t5uos
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774950992-489745
X-HE-Meta: U2FsdGVkX1+as6xAtJI9OmBaok04xGFVzr8wJzIU7fdt45RaPP3TWZHWFv4qByTWwJsLpAdgZh7E4d6h85fH0xDe95hO+040XiRJ7smq4JY5807J8gFepiPVeAOtIy10M++R9haosuamwpaC4sVRZh6ig6Z+rf6uiSMigH3HzF8VxNDXxAZecAx5szGpDZ7DvAjHZYVJ42VShbt6yVIEQY+OWp2eelI0kB1qm1w0hBdCUNIvj0f3gBFl22YdOs808LvR/CpShdgYebLq31gC1vkGFSrk3iK0FenqYAV/FTD8TPGwLi7H1Fh0+I/0J5xse5GtKdWWWnecH2GiBHJa/pEYpoNTVWWjp2lpvXNvfDGXwwGc3jbIqWC0njIUspyLCy5AHGMhp3parDXETu4JhvQ1PRMKMfwCamKuzDDASktyE2hHlIKRKElCPYPAmgFGZniJz6dTb3CZ+iyPWQ7hTtkqsstbYUThtQdwg3tYf0OKsRhLFBr7TrPjkJaeo7XzjLSXKML9BuKd+/dYdNqyNPEPDVtpFdrkUCwsEJyBkOeTNMi2L3h1dkMTZoy5PAjE+r0xSzWrpRdAcGwFIw8z+MN9rYNJoyh1w0y/ISJpDfuva48ZhduHvbjbgkXuqrrwlihZwYPmtoWliKYzREgR8ViP++zvvpF/5KCLW/nEXh06eg2ekA/3znGBqMygPXMbrRAj6sMGxtMKkh8rD4XEKVKaCIKbyV9QPyh3O1lII+hIdxFlG7q8FoQVUCGQwMsKdg4BTwBou9K9xBysbG3zWCUbiYNIGGL0GbjiahDHCK++IO7tQcnii4AUSCG7XwGHhP91XqGOSVrr0SRVS10ZZrjq5KqwYT8HNbOdQAIfSDcp5puEaWjVvrbN08FtxOPa+5d+FjFwfTSXElmWJTZKHFWNOfXIBExLPeeSHrqtu/1B0bFEJI4/Ms1xakhraYHY1pg7Ew8zsVyIStDqUTv
 E1BYmOoT
 mKbJRgd/EPIKMc6JKwr6bQ7O2mCB1nAHCk8aXjkKVSgS6jc2dpuNk//ydqm1rOnQvaLsE3G09AMPt6ZjkmjBcblPScDoewhcuWfYSnb2Izitqm9bRQXIg2c4Rz6wC8aXN/3qbns4hJTbINu4QHgAB4vP8AkkeZx2IJOCv1WdVezp3BZ0myvq9rEstSRmdEe3QI1CKhNnmoXvpdb/3Ojsq6MC8QPz2t5YKaNEsXb9iCE51Vjqzr7fYyZjRmuItVl04gu3GtcuAlj9/CWw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 10:35:33AM +0100, Pedro Falcato wrote:
> On Tue, Mar 31, 2026 at 08:36:27AM +0100, Lorenzo Stoakes (Oracle) wrote:
> > Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
> > an issue in the loop which iterates through VMAs applying mseal, which was
> > triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
> > the first mergeable with it, once mseal()'d.
> >
> > Add a regression test to assert that this behaviour is correct. We place it
> > in the merge selftests as this is strictly an issue with merging (via a
> > vma_modify() invocation).
> >
> > It also assert that mseal()'d ranges are correctly merged as you'd expect.
> >
> > The test is implemented such that it is skipped if mseal() is not
> > available on the system.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> > v2:
> > * Added tools/ based header so __NR_mseal should always be available.
> > * However, for completeness, also check to see if defined, and assume ENOSYS if
> >   not.
> > * Thanks to Mike for reporting issues in his build on this test!
> >
> > v1:
> > https://lore.kernel.org/all/20260330135011.107036-1-ljs@kernel.org/
> >
> >  tools/testing/selftests/mm/merge.c | 89 ++++++++++++++++++++++++++++++
> >  1 file changed, 89 insertions(+)
> >
> > diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> > index 10b686102b79..f73803b3679a 100644
> > --- a/tools/testing/selftests/mm/merge.c
> > +++ b/tools/testing/selftests/mm/merge.c
> > @@ -2,6 +2,7 @@
> >
> >  #define _GNU_SOURCE
> >  #include "kselftest_harness.h"
> > +#include <asm-generic/unistd.h>
> >  #include <linux/prctl.h>
> >  #include <fcntl.h>
> >  #include <stdio.h>
> > @@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *procmap)
> >  	return 0;
> >  }
> >
> > +#ifdef __NR_mseal
> > +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> > +{
> > +	return syscall(__NR_mseal, (unsigned long)ptr, len, flags);
> > +}
> > +#else
> > +static int sys_mseal(void *ptr, size_t len, unsigned long flags)
> > +{
> > +	errno = ENOSYS;
> > +	return -1;
> > +}
> > +#endif
> > +
> >  FIXTURE_SETUP(merge)
> >  {
> >  	self->page_size = psize();
> > @@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faulted)
> >  	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
> >  }
> >
> > +TEST_F(merge, merge_vmas_with_mseal)
> > +{
> > +	unsigned int page_size = self->page_size;
> > +	struct procmap_fd *procmap = &self->procmap;
> > +	char *ptr, *ptr2, *ptr3;
> > +	/* We need our own as cannot munmap() once sealed. */
> > +	char *carveout;
> > +
> > +	/* Invalid mseal() call to see if implemented. */
> > +	ASSERT_EQ(sys_mseal(NULL, 0, ~0UL), -1);
> > +	if (errno == ENOSYS)
> > +		SKIP(return, "mseal not supported, skipping.");
> > +
> > +	/* Map carveout. */
> > +	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
> > +			MAP_PRIVATE | MAP_ANON, -1, 0);
>
> I think it would be simpler if we did 5 pages (1 for each VMA, plus the two guard VMAs around it).
>
> > +	ASSERT_NE(carveout, MAP_FAILED);
> > +
> > +	/*
> > +	 * Map 3 separate VMAs:
> > +	 *
> > +	 * |-----------|-----------|-----------|
> > +	 * |    RW     |    RWE    |    RO     |
> > +	 * |-----------|-----------|-----------|
> > +	 *      ptr         ptr2        ptr3
> > +	 */
>
> And now carveout += page_size; would leave us with
>
> mmap(&carveout[0 * page_size])
> mmap(&carveout[1 * page_size])
> mmap(&carveout[2 * page_size])
>
> and we don't need to deal with the arbitrary 5 pages below, which looks a good bit nicer.

OK I mean I'm not sure I should be sending a v3 so fast and it's too much for a
fix-patch.

Given it's cosmetic do we really care?

>
> > +	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
> > +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> > +	ASSERT_NE(ptr, MAP_FAILED);
> > +	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
> > +		    PROT_READ | PROT_WRITE | PROT_EXEC,
> > +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> > +	ASSERT_NE(ptr2, MAP_FAILED);
> > +	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
> > +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> > +	ASSERT_NE(ptr3, MAP_FAILED);
> > +
> > +	/*
> > +	 * mseal the second VMA:
> > +	 *
> > +	 * |-----------|-----------|-----------|
> > +	 * |    RW     |    RWES   |    RO     |
> > +	 * |-----------|-----------|-----------|
> > +	 *      ptr         ptr2        ptr3
> > +	 */
> > +	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
> > +
> > +	/* Make first VMA mergeable upon mseal. */
> > +	ASSERT_EQ(mprotect(ptr, 5 * page_size,
> > +			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
> > +	/*
> > +	 * At this point we have:
> > +	 *
> > +	 * |-----------|-----------|-----------|
> > +	 * |    RWE    |    RWES   |    RO     |
> > +	 * |-----------|-----------|-----------|
> > +	 *      ptr         ptr2        ptr3
> > +	 *
> > +	 * Now mseal all of the VMAs.
> > +	 */
> > +	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
> > +
> > +	/*
> > +	 * We should end up with:
> > +	 *
> > +	 * |-----------------------|-----------|
> > +	 * |          RWES         |    ROS    |
> > +	 * |-----------------------|-----------|
> > +	 *            ptr               ptr3
> > +	 */
> > +	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
> > +	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
> > +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
> > +}
>
> Apart from these nits, the test LGTM
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Thanks.

>
> --
> Pedro

