Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65934CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 21:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B583B6B0099; Thu, 28 May 2026 17:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08866B009D; Thu, 28 May 2026 17:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1E376B00A1; Thu, 28 May 2026 17:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4E36B0099
	for <linux-mm@kvack.org>; Thu, 28 May 2026 17:45:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B823A0A07
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:45:07 +0000 (UTC)
X-FDA: 84818159454.19.91FF62A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F35C44000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 21:45:04 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1D3p3fU;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780004705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/hmRzBBegpzhry5lne7It+TrGap2MWq6h+hhKaTIuQ=;
	b=xJawOPb8zep27bBn1ZPcQSvucFbVyERSOBKnRdgy0BUv7Grjf884w+XBZ01zyeNfuEtb+s
	FJB/Yb0EYG4Q00OnqpVZYTM08qJM6tcBGGMw+PrxpCUueH8wn5hYQNiaJXVew7UEa/Ohy9
	MKup5wlH9MCUPwhxdnNIqs76E9rOKds=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=t1D3p3fU;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780004705; a=rsa-sha256;
	cv=none;
	b=VTDogQA3e7Mo6R7ezAmjSHCUrL2SLM7oKyAQ/xEaZjpQrZynVi4NqDCNhyuQGt9mrtiDnu
	Y/BFsMNdKE+H4X5IiO78FyL33ZXnqCR2PfcmS42Tsz3K3tj6Szro44xhoE5jmRSOd29948
	h3E02KBHMSnXtS5oT5d/cFyoOGvN2gA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E933544225;
	Thu, 28 May 2026 21:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637F41F000E9;
	Thu, 28 May 2026 21:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780004703;
	bh=T/hmRzBBegpzhry5lne7It+TrGap2MWq6h+hhKaTIuQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=t1D3p3fUYTz13Y/1X2Ddt/Owx9g7PCHJ4UibSTPCgBR0VYK4aY0aurH9R8E/7Gm99
	 uihO9PJS+JxjM6JU6p5zWhT3gQV1IXXryri9yqX2hll0U5ycz70bv91yHejTzNNtWH
	 4tDnwBx/KFPDMuI0DX4ny6N9IJ8tW6yQ3lmvaxi4=
Date: Thu, 28 May 2026 14:45:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Kairui Song <kasong@tencent.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Subject: Re: [akpm-mm:mm-unstable 199/420] mm/memcontrol-v1.c:651:24: error:
 call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not
 support implicit function declarations
Message-Id: <20260528144502.dd586e865b677051ac7c776b@linux-foundation.org>
In-Reply-To: <202605281711.bSeZlErK-lkp@intel.com>
References: <202605281711.bSeZlErK-lkp@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nbnn5ab8gn89w9yqfbewbrharkyin45q
X-Rspamd-Queue-Id: F35C44000C
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780004704-134877
X-HE-Meta: U2FsdGVkX1836cSk65WGcxB5IYBN6iGDHcnZ/6SejJOheEHK9yropBZbFManDJk5rw/5LLZzc76Xc+uZVuO7NLaRy62XQmoJk21I9UkSI2kJP8X2YE17MCQ8CGgFnwenfYnczK0mWsiJxO/B7jGubY9OCYXi7xcCRwQ7i8Xk/hEfCIXbxzOPKKj8k8BgrzC2UzF/Re+faSrHLFmmwFAwjDM/5p21Qli63Gu/wZu2Z0KGuHitFUroZSpsGIkeiKtuBxhMhQoja2Oil9awGhNiE9Gtm9jhbU6xM86eYzMdKjLUsvjkPRKQURv7mDvNt3QF7L72h/xccga/OcLZsWmERDged97YdKZ8qteGgm7Om1U/QYO8QzKG/6ZHYsSosQqL8e2wwjqbakTkrtCOATPPLYaL4RIICxe+g312AA7wG5MmsjTcObBioa4kV03S4q2qh5UBKxIvQzfA0XJBjoyn3FMJBLEvIzEysSrT+YEFtzmh7YJBSjc54MKi4XhBfeicUQp83y4r0I4x95zPaUN34MFPr44djCP5DVeITuHS/ITDsB1p/CdxPNLj3kDhCVeD+DNid6EYPhX1q+eJBnGWuq6JQa9vTQbnhd4i+nTEscsi8VLZ+LxbIlNw1R+nzA2Jh8XZJJh1wBPv04UwzKsJam99rCFga2tm6023NDsQu/4WI9SEtJvpZdCkPeAHKPPvMLXBv3sGuOW4IInFxpGBa33mn8uiUX7jZSNnuDvKr157qAsCPsXtyLkhwuNjPA5OXNtLE6Lr9AOgz8JFyoEAjAr6oe0jfVdCanATgyk4DKfJR7F3eZzAUup3+jIrUKOhqPu8zFaicblGGfsAZGkcPggpJw0Ok/YYkxscVS71OvDem9crJdiOcF5+4ZX9z4Vs8xbSYaS2wvShyhu5KVbSY01oys/lwnIToNT7/N+NRXCaXDphrkQWrHKecI4qLBvjZdDLynyA77TxJDUMaJD
 d9ek4HrQ
 z1tULdNtiDRIaFYbZyFi8VyP/tp7xOYJZHSqeXo0mi2j0wwUxuBuZg7gOgDs56saE+nn+bUK+fMgmvbeDh99AFTAVHSw5o8TrtwPQY4JjNOeS44AgoJEX0THuBWKERsSNxSLr7IrUeXFEV82uNPeqyZXaQwweJtLSLp+wOh5z1RCdI0jBt5oj/8DS+O3K6w5f8VX0iaaH2UvKvtwCGRmHeczQMK5ZZ/SeHspTHliJd0xRhfufdxH0bt8K5CXgf85S4jJTee+NVu8ufJj3eDC6y4CoRDirlOHFLmEGE9SjaNZxoeZX/7dpOYvYrEC3cr6GKwcatVlxKgN/k1+1xrJT6bAo2Un5XfJTiQPyzghq325wjD1MlxPUj2p3P9irkj522TEUdIubs6luPg3bW2MEQQhbimRr9bGTlB4noOoLL6ifXYeOLnCUS3eUDP1gCGM9m1K9IPTqjN0OX6zTW9Oel8rmxmPgMub8j2hH8KeEepI4owk4KJj7RxcaR+q1hbkhQxERbJsreJEWhHsX7sF6eACgeetMvAnj4VZHo5SYHoE5phXk2/MrCc8XT0qsGvJKnlTXbOR1+6uXLbDy23tEMwVLHtFaQxnk73+ckWwY9AUkrQcrBFe4mwe3Jxyo4g//0GHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 28 May 2026 17:58:34 +0800 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   8a74e22643189e0ae339afc91110ddb4cab1941b
> commit: 93680c2b51fa1f84fe50800b71140dbd283372b8 [199/420] mm/memcg, swap: store cgroup id in cluster table directly
> config: arm-randconfig-004-20260528 (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9409c07de6378507397ecdb6f05f628f58110112)
> rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260528/202605281711.bSeZlErK-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202605281711.bSeZlErK-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
> >> mm/memcontrol-v1.c:651:24: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      651 |         __swap_cgroup_set(ci, swp_cluster_offset(folio->swap), nr_entries,
>          |                               ^
>    mm/memcontrol-v1.c:721:31: error: call to undeclared function 'swp_cluster_offset'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
>      721 |         id = __swap_cgroup_clear(ci, swp_cluster_offset(folio->swap),
>          |                                      ^
>    2 errors generated.

OK, CONFIG_SWAP=n.

We could hack in a stub for swp_cluster_offset(), but why are we
compiling __memcg1_swapout() at all when CONFIG_SWAP=n?  Ditto
memcg1_swapin().

How does the below look?

Really this should be done as a preparatory thing, but we'll survive.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: memcgv1: don't compile swap functions when CONFIG_SWAP=n
Date: Thu May 28 02:35:22 PM PDT 2026

Stub these out to save some dead code and to fix a build error with the
upcoming "mm/memcg, swap: store cgroup id in cluster table directly".

Link: https://lore.kernel.org/202605281711.bSeZlErK-lkp@intel.com
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |   15 ++++++++++-----
 mm/memcontrol-v1.c         |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/memcontrol.h~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/include/linux/memcontrol.h
@@ -1900,9 +1900,6 @@ static inline void mem_cgroup_exit_user_
 	current->in_user_fault = 0;
 }
 
-void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
-void memcg1_swapin(struct folio *folio);
-
 #else /* CONFIG_MEMCG_V1 */
 static inline
 unsigned long memcg1_soft_limit_reclaim(pg_data_t *pgdat, int order,
@@ -1930,6 +1927,15 @@ static inline void mem_cgroup_exit_user_
 {
 }
 
+#endif /* CONFIG_MEMCG_V1 */
+
+#if defined(CONFIG_MEMCG_V1) && defined(CONFIG_SWAP)
+
+void __memcg1_swapout(struct folio *folio, struct swap_cluster_info *ci);
+void memcg1_swapin(struct folio *folio);
+
+#else
+
 static inline void __memcg1_swapout(struct folio *folio,
 		struct swap_cluster_info *ci)
 {
@@ -1938,7 +1944,6 @@ static inline void __memcg1_swapout(stru
 static inline void memcg1_swapin(struct folio *folio)
 {
 }
-
-#endif /* CONFIG_MEMCG_V1 */
+#endif
 
 #endif /* _LINUX_MEMCONTROL_H */
--- a/mm/memcontrol-v1.c~mm-memcg-swap-store-cgroup-id-in-cluster-table-directly-fix
+++ a/mm/memcontrol-v1.c
@@ -604,6 +604,7 @@ void memcg1_commit_charge(struct folio *
 	local_irq_restore(flags);
 }
 
+#ifdef CONFIG_SWAP
 /**
  * __memcg1_swapout - transfer a memsw charge to swap
  * @folio: folio whose memsw charge to transfer
@@ -723,6 +724,7 @@ void memcg1_swapin(struct folio *folio)
 	swap_cluster_unlock(ci);
 	mem_cgroup_uncharge_swap(id, nr_pages);
 }
+#endif
 
 void memcg1_uncharge_batch(struct mem_cgroup *memcg, unsigned long pgpgout,
 			   unsigned long nr_memory, int nid)
_


