Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D500E8537A
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 16:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88CA66B0005; Fri,  3 Apr 2026 12:08:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D446B0089; Fri,  3 Apr 2026 12:08:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77A226B008A; Fri,  3 Apr 2026 12:08:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 679D66B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:08:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D1C7E1C15
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:08:50 +0000 (UTC)
X-FDA: 84617728020.26.0ABAE40
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 521A81C000E
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 16:08:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeiwlwZq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775232528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IGbBI18wVzLFyxt3QsRT6i38t9eZVxhcIhIZ+QJTAIk=;
	b=rJrThKv7g9zj6csX/mw0pDskNVT4RHFXMt47OGWVoWJyAncC1qZZzvq1w61TfUSFVdZSc9
	uZcfVwXEr80sv62y91TH3GtPkYRvI3qdfI9m5YA93/dtSPVEwIlbPHknFlmOrLpwYplN9E
	tnXJMJERuO8Za4t8mURfUeCRBUVdCcI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775232528; a=rsa-sha256;
	cv=none;
	b=wVlEe8BGXR5J4M1DJ98x5JvK/N2Wv+yjXC6MKpY9E7MgCb2S+lbh5qHcPUopSJLU/W2nN+
	JlpY4WVqKbUoO7YuESsJy+EDpDUqi8k36eAkEHf51J2ssCGfxpVebgIGdP1hDuuRkt1T98
	AlMCiQSXCxqRAyA5rQ4ZacTuJfkHQl8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aeiwlwZq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E205409B3;
	Fri,  3 Apr 2026 16:08:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C01C4CEF7;
	Fri,  3 Apr 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775232527;
	bh=VypwSWNnwhAnxziBrzK7w7AlYaT+GC1ix3L+HwsKnPI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aeiwlwZq2d4EHooxsbiD30vbJoWhfP670Jcs1U161O3MNaQcnYdL119IrMWJZ1Sid
	 RM+qsTBhxYAhskPSDVDeE4wM8/o+dN2yfi003VMNbzvVdM6UbnyO4EWr4PmCQlp59U
	 QaXxvFwFXKpXdw3ktRdOT/Rp9KI173qnyUtqyXpPUgGVcQ+/pNkffB7GBAwJIFdURS
	 UhxfEm9MY1+X6GOJtUQyKghbYu69SNCaDfM3iXqHE4zLSkl8MUhe3yZfpzC2l1cdom
	 uyxavX9Ry4Ot08+lrR0USLpItFlYRiQCQT8Axu6SfVhRexqHqqhQa60FTV+vS6fjAT
	 nbJQtTKKc2T1A==
Date: Fri, 3 Apr 2026 19:08:40 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] tools/testing/selftests: add merge test for partial
 msealed range
Message-ID: <ac_mCIUQWRAbuH8F@kernel.org>
References: <20260331073627.50010-1-ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331073627.50010-1-ljs@kernel.org>
X-Rspamd-Queue-Id: 521A81C000E
X-Stat-Signature: 5i3drr3rmcx5xeo4d5beh9dhpmkdn6ts
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775232528-449448
X-HE-Meta: U2FsdGVkX18MMDynTGjOw0c4d4lIbiwSRHSKRQ++UFRhJ6CWtP935Eu+yB2impJMy8BThN9ynuU1Ac9t/J20uN9EWqk7jTxHPEW0Gys6nG4RcuaVDcVsHdHuwR5Tpl9wDZMimlaTZxGSKG+lfHG/wjzPpshT3PGEwMSAUXaUooPvQUmIkFMHqeR0kblLRoMe41+eYuRN6vVzq7VmTCxxzs9lJIsVRghH74CzRGTutoZV6DtObrjum52qs52n9B3THy6s1ouq0XTNh5qeGxzxqDbSmfCM4epP30lAZ5dUE1OOIE/d5bfw2M/oUAWnvpbTyYkY/m0Nxc1AYagw29F75MDgegi6oSkfIOfdYJAjZ2htqNBGHPCBGiTf/t2ujVmZIhQ8PaA1fNyIf1bC6KB3X7kv2hY9klEUNH/HDlKVTEeM8ukv4T2fPK387MC8UX8mxXo9DiA90aA3ikl3XsSzlRIsa/Ii4Rs40e3WwKuGjDrsCqsnptre6Mm818yY0Ou0ADKlnaQbHQwsc+mftDSnQixeuFhbs8MBewocTzDFoMoBk/VwxxrXJ4xTWjZoTyQtqXbqKZv7zn37pkbnhmTneF22YQzrlK70knMXqlvoTvQUrTfN10dvXp7DvxY5xa1KAAj9zl38Y1bcPpH58T4j6cf+LaGd12Jz01wlxYZw1VlLbcKEVoamZ6LJPk4L+zEPbwr5W0h4eUrc3BnBlODtP2uXoDuIZM+eiQ8f33lfsChQHd1MaWtQtF/4l3Lnl3mTXv7tqSxV5lbNxdavabLr8sG3/8zo7Hh/QUs2Ii04M581V1GprEWQ2dvIQPPdT0rUmXOhys1G+44Or1IFafDfAwQShCMHC47XoKYoEnPP3r0TWC10tOhujl6zTDTMO/YeQGQ/5fsCCJy8rRJxgqcbrgnMgG0dqisLkmTIg7TbaAL/4XVzIKBBddD/9rhzLT0Kt2SiJtd/7S8I+9CkZ5N
 88m71BS8
 7otvTo+dlNQe4gKZxnOMfvUQkwDKQsbD6qesl8zN663exx+0XTpNBk2J/ouYusmxKmOAamskOTxf/Swy5LcaqyoVlidcJT7WVscRrgyDfHwEpAdN+RdAuYMj1Luj4hK8lehlTEAOVr0SOEhvP6cw8B3elqWbDauAEhVBgpjZ85mynz/JF67KZyakhtga4bCX4iicrNjqEZwbLYI6ySIE7SGvDqi0XUPoY0GqDc1O/dpQ5WbnwVkHIkoZZSkU6xF0DtxVhOqMO/FyZ3AYKs4Vs9NHCfKQaZaCq7sj1KWaGmcpxomlcKeI6HydIqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 08:36:27AM +0100, Lorenzo Stoakes (Oracle) wrote:
> Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
> an issue in the loop which iterates through VMAs applying mseal, which was
> triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
> the first mergeable with it, once mseal()'d.
> 
> Add a regression test to assert that this behaviour is correct. We place it
> in the merge selftests as this is strictly an issue with merging (via a
> vma_modify() invocation).
> 
> It also assert that mseal()'d ranges are correctly merged as you'd expect.
> 
> The test is implemented such that it is skipped if mseal() is not
> available on the system.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
> v2:
> * Added tools/ based header so __NR_mseal should always be available.
> * However, for completeness, also check to see if defined, and assume ENOSYS if
>   not.
> * Thanks to Mike for reporting issues in his build on this test!

Unfortunately it's not the only one :)

The header inclusion actually causes handle_uprobe_upon_merged_vma() to
fail because of mismatch in definition of__NR_perf_event_open in
<asm-generic/unistd.h> and the correct definition from
/usr/include/unistd.h

With the patch below handle_uprobe_upon_merged_vma() passes again and I
think it's not needed for mseal tests as well.

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index efcb100fd865..519e5ac02db7 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -2,7 +2,6 @@
 
 #define _GNU_SOURCE
 #include "kselftest_harness.h"
-#include <asm-generic/unistd.h>
 #include <linux/prctl.h>
 #include <fcntl.h>
 #include <stdio.h>

> v1:
> https://lore.kernel.org/all/20260330135011.107036-1-ljs@kernel.org/
> 
>  tools/testing/selftests/mm/merge.c | 89 ++++++++++++++++++++++++++++++
>  1 file changed, 89 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
> index 10b686102b79..f73803b3679a 100644
> --- a/tools/testing/selftests/mm/merge.c
> +++ b/tools/testing/selftests/mm/merge.c
> @@ -2,6 +2,7 @@
> 
>  #define _GNU_SOURCE
>  #include "kselftest_harness.h"
> +#include <asm-generic/unistd.h>
>  #include <linux/prctl.h>
>  #include <fcntl.h>
>  #include <stdio.h>
> @@ -48,6 +49,19 @@ static pid_t do_fork(struct procmap_fd *procmap)
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
> @@ -1217,6 +1231,81 @@ TEST_F(merge, mremap_correct_placed_faulted)
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
> +	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
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
> +	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr, MAP_FAILED);
> +	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
> +		    PROT_READ | PROT_WRITE | PROT_EXEC,
> +		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
> +	ASSERT_NE(ptr2, MAP_FAILED);
> +	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
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
> +	ASSERT_EQ(sys_mseal(ptr2, 5 * page_size, 0), 0);
> +
> +	/* Make first VMA mergeable upon mseal. */
> +	ASSERT_EQ(mprotect(ptr, 5 * page_size,
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
> +	ASSERT_EQ(sys_mseal(ptr, 15 * page_size, 0), 0);
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
> +	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
> +}
> +
>  TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
>  {
>  	struct procmap_fd *procmap = &self->procmap;
> --
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

