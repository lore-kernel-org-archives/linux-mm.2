Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89BF8FC9EC3
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 03:28:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABF866B0005; Fri,  6 Mar 2026 22:28:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A42E76B0089; Fri,  6 Mar 2026 22:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9450A6B008A; Fri,  6 Mar 2026 22:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8517E6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 22:28:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E842BC27C1
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:28:03 +0000 (UTC)
X-FDA: 84517833246.01.DFBF4CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 578F44000C
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 03:28:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXvemofJ;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772854082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eC7TeH+JML5hvQRhRMoY6HZP0E0BrRXfDc84SWcCmvk=;
	b=YV6KyqrNJo/MiygodwsTKix9tYqAUQNAWlNF7jCIQPj77Qke5cj5n/IBTAaRv6Csxdoy06
	WEFHURUtP/Eee6DnRQNPRvYZUOgCBk/09lCwCFDOYtSERbRwJqirxelMwR9zr4qmaFppKV
	1NMQcVahbOySgdbb15YW+5ha3HcORLA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BXvemofJ;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772854082; a=rsa-sha256;
	cv=none;
	b=km3gFiW2nWj3096wFSa39hAYQkoB7MKdA5Mismddj/yfXPHLKtpekxrdvWTlfbNWyP3KxW
	86cdhbs/eu3nlnfZ6LFju4kj/CcnxvZUq7mSDhsmmsjDaF6FYn5vgS2qRmuJxxRWLn4KC6
	k3XiQ7vkYY8XJT96ZVaAIYJ5jliHJWA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E1DF60018;
	Sat,  7 Mar 2026 03:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7688C19422;
	Sat,  7 Mar 2026 03:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772854081;
	bh=XSY0RglEN64n9U43+fR8Oah0dHCIZP40nqmbgL8bEdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BXvemofJV3TLQz/8HqUT4pHQ9j+A+om0GqwG8KoD8BAR9KEOOIyGHzQoD9I59E2+g
	 DGSV485DaT66aPMYg8swPqZsVCFMYhLUgHn41efx6RkbWoZDtSQJon/e/+rZN0udwX
	 Wfjl5c5L3gxNBXEhmrEj3FM0UlED/2BaTEFKWxM+lkGPWrk55jRtkAQ36UGzeFbzDA
	 AmKq83K3dGMzPYWVJglGFQW2Jb+3ZTHdoV+FOVuJoV4dG7JjA9vfwU02YwGkeBCSSJ
	 PjgRCYwtuTJUgmYh7FnynTNcDyyFVaF+ZDo84NPK38Qe5znSyTWUUZAbP+NFx6nPNl
	 cYN+dN3v3qY7A==
From: SeongJae Park <sj@kernel.org>
To: Jianhui Zhou <jianhuizzzzz@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jonas Zhou <jonaszhou@zhaoxin.com>,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Fri,  6 Mar 2026 19:27:57 -0800
Message-ID: <20260307032759.100915-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306140332.171078-1-jianhuizzzzz@gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 578F44000C
X-Rspamd-Server: rspam08
X-Stat-Signature: k3pcis4z7ejofkz1t1zio6ajj6yf4fnp
X-HE-Tag: 1772854082-676105
X-HE-Meta: U2FsdGVkX18KOKal1qCLBd+Vp8yv/moaOh9UDYFO2uH0Py9LZUHl/HYtYHauDvBUgpP5GB3EImdF2Yy6lQqOFcF/E2Xfp2jQBhDfpDTE3HHPDoHb6Oc3ZU/3GT/eZ2R6EKZaheeIMOqVVkQFJISv+B9C+EY8+cOkjIb9mzARmTQO5G2LSQd+vArFC8rjnZ17+VuWt03zKk6n5l1r6GW0gyKqcUNXIuBbFa6AsjodlzIKYt8NfEj0ilhDZvp6cCRrXiiqfjZeKFyUMaEfExBTxKTPa/0nCAy/HaGGmET21fZuYkvuXkueiROFfD/3+Q2cvIzM7kjgW0nUQM1fNWyA8GgVQoaL6zACaweoNsgupqFnWqBI2fb1GZCCa/MHuLKtTmRAEXRIng08YuWEwDVD1qGFRwmR0tgSQ6BzHlyiP+l+3CVFx17coT/lFU5gMRrow9I39V3kuh5Wf8pVOYgS5NtSLqNMDUbVpCHUmT4y+ItFr7mKDRHQbIZaCt9UeuTsJPh4WLHJ8yvHMdVhqSzzCPLC54pdX/wrNXNb1IqIlrOxhvGgSmPHP4aAoptqH5h643OcGO8ViI4S1/8crjmuKXg/gGQvVn28nPC8qH4sSPiOcynYV4ogUD5cbsBHMZ2j0aKtMBBrDiQLydlYmj7R3WkytyrpKHBMe7jL2sqRDoiSMzlJHA25rJIaLBFnBd0uBWWq4ZhV5X13kCpExPOhN7dDG/Pb/XDQ79OV+Ild8MfnvDvIcAYBSAWFsLcZtDkfEX+cpsQLqqKqCPkKQWUOzWXhk1akvGJfH3ZY6RIG5umpQwD+63wUxY/b6qu4++wYXkn8Yhp2ROw5z7nC3ZaAjfj1/FQzIqvTk3DLQEEGmarLFPsmJoyA+CZk2/RRxZYHkJiEeiA/ptGiTaPPBu+Hy1lu2MNY4UATP62GxywlrY8FfMXj51vr2AcESqXUYN/+tudou7xOoof2UNJ5U3g
 riaeSTxD
 /BlQcSYUcI2lOvNd4UxuqRnJFjXHM0RcqDR5cdOILaVZl1upT/2+iuzrSJR71Bhbta4lEeigaBBmoybdMZrvYUpHR5otvcAWSj3SSxl3IrZzz4yDYvaea/jJ25ZatSopW2DBf39Y9Fnnu48UHTrNQADm27npcy07liDTNONWyzo75LkUYy2TNXcISsgb3KUaSSr/UWLFBurluSx0AwF1o7EiOJGizoZ789hXOwjBOnRX7R9cMlxPHmKf2xtjgIWJO1TWWqJFt9gUUE14C1SIRDTuCKF++J5VOw0Mvqnz1UIeyRfBbfFA5kfnyOpGQ/a632suxQsQv2vCbttEJMPd7400y3p97nXum6AC0QU9zxAy7s/UJEytIak+D4WlzbaU2hZGmyJCdx6O9n+n1vyWy9xDTPOOAVbtmMQzeGnX9hXx2yBnlJ2EAfiH3kNQUurCdmpTOZwzq+ikB2jVqEutLkpyXsf+TOmM4MhjZsrziKJbx2xyJuAwN4RrbC/PVJ11rH8vxAuJGGD99jn9o9MMg/ooCBgwr9ofL4Nu3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jianhui,

On Fri,  6 Mar 2026 22:03:32 +0800 Jianhui Zhou <jianhuizzzzz@gmail.com> wrote:

> In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
> page index for hugetlb_fault_mutex_hash(). However, linear_page_index()
> returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
> expects the index in huge page units (as calculated by
> vma_hugecache_offset()). This mismatch means that different addresses
> within the same huge page can produce different hash values, leading to
> the use of different mutexes for the same huge page. This can cause
> races between faulting threads, which can corrupt the reservation map
> and trigger the BUG_ON in resv_map_release().
> 
> Fix this by replacing linear_page_index() with vma_hugecache_offset()
> and applying huge_page_mask() to align the address properly. To make
> vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
> include/linux/hugetlb.h as a static inline function.
> 
> Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
> Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
> Cc: stable@vger.kernel.org
> Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
> ---
[...]
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
[...]
> +static inline pgoff_t vma_hugecache_offset(struct hstate *h,
> +		struct vm_area_struct *vma, unsigned long address)
> +{
> +	return linear_page_index(vma, address);
> +}
> +

I just found this patch makes UML build fails as below.

    $ make ARCH=um O=.kunit olddefconfig
    Building with:
    $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
    ERROR:root:In file included from ../io_uring/rsrc.c:9:
    ../include/linux/hugetlb.h: In function ‘vma_hugecache_offset’:
    ../include/linux/hugetlb.h:1214:16: error: implicit declaration of function ‘linear_page_index’ [-Wimplicit-function-declaration]
     1214 |         return linear_page_index(vma, address);
          |                ^~~~~~~~~~~~~~~~~

Maybe we need to include pagemap.h?  I confirmed below attaching patch fix the
error on my setup.


Thanks,
SJ

[...]
=== >8 ===
From f55581ba154d6c8aaaf1f1d33cc317b5bf463147 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Fri, 6 Mar 2026 19:23:28 -0800
Subject: [PATCH] mm/hugetlb: include pagemap.h to fix build error
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Without this, UML build fails as below:

    $ make all compile_commands.json scripts_gdb ARCH=um O=.kunit --jobs=8
    ERROR:root:In file included from ../io_uring/rsrc.c:9:
    ../include/linux/hugetlb.h: In function ‘vma_hugecache_offset’:
    ../include/linux/hugetlb.h:1214:16: error: implicit declaration of function ‘linear_page_index’ [-Wimplicit-function-declaration]
     1214 |         return linear_page_index(vma, address);
          |                ^~~~~~~~~~~~~~~~~

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/hugetlb.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3f994f3e839cf..63426bd716839 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -15,6 +15,7 @@
 #include <linux/gfp.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/nodemask.h>
+#include <linux/pagemap.h>
 
 struct mmu_gather;
 struct node;
-- 
2.47.3


