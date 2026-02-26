Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76998FCE08D
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A456B00B0; Thu, 26 Feb 2026 09:22:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF2506B00B1; Thu, 26 Feb 2026 09:22:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FE586B00B2; Thu, 26 Feb 2026 09:22:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2EF6B00B0
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:22:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3609914012C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:22:44 +0000 (UTC)
X-FDA: 84486823848.09.4A82F94
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FD0E180011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:22:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jKgAMrXK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115762; a=rsa-sha256;
	cv=none;
	b=12O2YhrnlLiNtLgz8itR/5+MaEhsr1y8yeuel9hjn1laASONT8GYQsvqaD6HLQ9BpXrSt0
	4bcAvhOe04lhMq7uPtLRko3nPaeTxIhrrgIbtRFoBhxWvob0SkNWJBt53zbBDcfipBAtLQ
	ILG5kL2snURRTf/dz0WY2to5uTdgBTY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jKgAMrXK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115762;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jb9YPiWuPBlQARNsplGopujxVA0bSVtV2JHBgzvaymY=;
	b=7MzMHnalwLVmcwyhSQO+RMozmzGJjuQ2vbfcJ/unq4qcpWWQcz0+J6+7fD5eF14GqPK44V
	7bOBwT1pm5ILPnqLEBvMlDbiPW6osnfbzhh5MryiZoygZN6BDj2onLCIyqYLmlRrONOIbu
	xfVEqr+C2bjGF8f1ZXe9T3nUgU9MuRk=
Message-ID: <a108bab5-9b53-4b90-a102-cc6fc22bb389@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772115759;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jb9YPiWuPBlQARNsplGopujxVA0bSVtV2JHBgzvaymY=;
	b=jKgAMrXKDp/fFQ5Qy0F4SHLZDHjfhKJDxbbLLtY+pveidJYQS4BwYY5icSGR6bqLh7c5yL
	dRolPPiOmwgxNE75HXCcD1jdE8X5lC5Ks2p9bLaV8lOOd+HsPb3Y+wLrYQFX6TZc3A8yHY
	9Srq/4+a9GOfDAKt9fJHnlcntrkPyq0=
Date: Thu, 26 Feb 2026 14:22:35 +0000
MIME-Version: 1.0
Subject: Re: [RFC v2 16/21] mm: thp: add THP_SPLIT_PMD_FAILED counter
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-17-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-17-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 3FD0E180011
X-Stat-Signature: qwn88hx3anzhs61sep4p9jperbc3ohne
X-HE-Tag: 1772115762-942950
X-HE-Meta: U2FsdGVkX18iTEyu7U4VbDrs3TkpxcqLxGd83vG2LGhKRTEljgrx84AhTR5ygnKVZ62Wall+0a6NAAYrDFayyMTuVUaziIQhJlBxBjMb8kZFL1PsJZ+4XauPoZv/FkgqE+kxxYh66oxMU4KpVmps2NTq11t39CUvf3e4LAMPnnZjVnDEo30YkxUmwKFRoUoWAHN0UaZfp/Vk5sX8OZvV1hXiQXRLfE08f4yG6hFvxMuYephouI5o5ETo9Ne/KwaOav9S3b76V0N2PKRjXUllD7yHrC792LdepQ6zAFqVMxxxUeJk9Rdr4tIbb/4RnW2u2PGyMArdMGX6UtVDwgMoBGsgisvGyK3fDz2EDjwlH8iTnaC1k4j3AFsOcxrPZ9M9RXbMm4PbfrbB+33Mf9qpVhch/ZVUyRx1QTyUENhk9ztXQ9ZpQSRSj44vYz8wpvSNA7iBKMK0M8riaqAfZdFWdi73nNxdGuEnovqgPkLxnml1NJQwXJYQKAAyqut7L/CjMjAY+jRjnE+O0K+4OZXJSMJACmJp87Jvc5iAmg9IybhCoRVMAZ5Yx1uKbCDzajrwm19oN46SMqISWqufjW+TyuViZF8jFJpBuwup5z/p2GhKEtBKdXyk93GrlwF6aPtwoXHSQ0eJw26uRAiRVdomrU2fp6bQ9Oz/WmoDbW576Gy2a6RcC/pJ8jKIrN9dfbJ3bhQ18JMz/FyzUPNU+AFhiBfxVjnQXWEs0swYPUkDAu5IidahH6mbSVaZSduL3XTDLQnIXhhu17947Mak3G5O/92OfxAXay7daolBYySMSloVOH5/x223XQRmPn59imdztKBNjytAEA3rqeA57t+7lQNFRupIdpJ5RXkI9/pBBDnV8HNHTRd2L0Nq54GIvrb6g8lbdmvqlDVaoTJIy8CGvL23ic+o5lC729/9iXMcm+V/YiuJ3Uf0W6oBRjVI6MJwVYBfsLoQjNK20dQ76ER
 +4uIV8Ls
 dA+U1Or1GVdZ4ZW/yqAZMvlA18kB2btGdsPFVl/8SMqrsym/vSfi9wn0Y0R9tKtM5J2sJzE1PJaq2iFqC9kjeAXyBEqyDEunYu35e7l+szatVP6gZGrgM3FoKobFk5kHFq6paPicDD3SgUNihKfMS0A3I2d2VEJ0hSz2X3EowvhgQ/lBshA9KONY+Sw+Daq/532pouoQp4P3HRlc+eKuIfJxsLJkgmlr50n7KrYFytDj5YD4TnRFgk7BxJ2Iex/oWI3dCwwrZ3kGQjnHUYuYKg8zNWpsiskiOQarc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/2026 11:23, Usama Arif wrote:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 2519d579bc1d8..2dae46fff08ae 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2067,8 +2067,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  				pgtable_t pgtable = prealloc_pte;
>  
>  				prealloc_pte = NULL;
> +
>  				if (!arch_needs_pgtable_deposit() && !pgtable &&
>  				    vma_is_anonymous(vma)) {
> +					count_vm_event(THP_SPLIT_PMD_FAILED);
>  					page_vma_mapped_walk_done(&pvmw);
>  					ret = false;
>  					break;
> @@ -2471,6 +2473,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  				prealloc_pte = NULL;
>  				if (!arch_needs_pgtable_deposit() && !pgtable &&
>  				    vma_is_anonymous(vma)) {
> +					count_vm_event(THP_SPLIT_PMD_FAILED);
>  					page_vma_mapped_walk_done(&pvmw);
>  					ret = false;
>  					break;
This will need to be guarded by CONFIG_TRANSPARENT_HUGEPAGE. Will need below diff in next series..

diff --git a/mm/rmap.c b/mm/rmap.c
index 2dae46fff08ae..9d74600951cf6 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2070,7 +2070,9 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
                                if (!arch_needs_pgtable_deposit() && !pgtable &&
                                    vma_is_anonymous(vma)) {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
                                        count_vm_event(THP_SPLIT_PMD_FAILED);
+#endif
                                        page_vma_mapped_walk_done(&pvmw);
                                        ret = false;
                                        break;
@@ -2473,7 +2475,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
                                prealloc_pte = NULL;
                                if (!arch_needs_pgtable_deposit() && !pgtable &&
                                    vma_is_anonymous(vma)) {
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE)
                                        count_vm_event(THP_SPLIT_PMD_FAILED);
+#endif
                                        page_vma_mapped_walk_done(&pvmw);
                                        ret = false;
                                        break;

