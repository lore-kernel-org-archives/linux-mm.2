Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B619F459F7
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 16:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27F86B009B; Fri, 10 Apr 2026 12:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD8F36B009E; Fri, 10 Apr 2026 12:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EEC26B009F; Fri, 10 Apr 2026 12:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91B356B009B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 12:00:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3F03CB9C2D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:00:05 +0000 (UTC)
X-FDA: 84643107570.24.E1B2029
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 398F8C0011
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 16:00:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lZkU3a2r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775836803; a=rsa-sha256;
	cv=none;
	b=pZtM7/rApRXY5Mu7Bpjo9kzMCzIVUa2SuPHl6lUL/FuAkFUaZM9kOfCWfiRLrwdwX/aZNX
	cLY/uBDG6caMtr8f9mGhWm731P3NNUC41ukX0G4LyIvBIJZpYh+ZdO05AlN+9OUarAHS1r
	1T469SbC7sBaBfcevXkSkS93z9wQc9s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lZkU3a2r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775836803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fp69nvi8vfzePQ4r72WtQoyz3vGVsf9eWxbGaVqWFg8=;
	b=QeQ8R4Q2Z94pcN7Lk+W6/vPnITJ7NkxLekZAGUKjsKEXOSolrGWQIpXM+h2j2Q1WaiMco9
	4KqGszwO8bMCZV7OPXX6AxTIqIqkyD0CZGGAyreZj0sgWB7/wGhzjnaj0Zc8uWAf3tXLqK
	zyKN6j+vfVO6C50hqHuDY1Cb5JBveSw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775836800;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fp69nvi8vfzePQ4r72WtQoyz3vGVsf9eWxbGaVqWFg8=;
	b=lZkU3a2r1eBilnZoCEuBaVnKpRHbeu4XB1hX/wQNN0o6A4IkvYn0CdSgIXL8mvywcuamhI
	6Rbl7q36L8b7BREjPmzIk6CWxfiXVXMBV7zYTj0rytk1ezzNfgD130Dayp49686v1a7laI
	lR75D1TZtW8RtqJP+c8wqS8IamWlH9M=
From: Lance Yang <lance.yang@linux.dev>
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 06/10] mm: shmem: drop has_transparent_hugepage() usage
Date: Fri, 10 Apr 2026 23:59:49 +0800
Message-Id: <20260410155949.61736-1-lance.yang@linux.dev>
In-Reply-To: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
References: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: rqjtxmfcc3yhwzie33rpdgt1jbozmwro
X-Rspamd-Queue-Id: 398F8C0011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775836802-920319
X-HE-Meta: U2FsdGVkX196Isk1gjMCzK/6ioBanJ6R8OH8DvE4w1qOlG3UD06UG97TusWKB1P3+KjDbtSvE6/TiWhZRHVXb2lIisSS/aA2I8H1MRMvwK1IsOQZPmquKdP5MLQbBGSggI/Y7LhoTDq/tdoWlbHZPyR9r1qVEGbguLaDQ+N4++j7gxiY+QqrI10J8SaGizoBcZbI0/0wmytyr7/EsF6ZPi8Rn5cpEb1BK7+9AP2cLr9ykdZR0k7Sx/ymwttW1TO2PyFj1KxFbnDoTLAfmfdCBBiDCmKudoP5rGw8v8arsDtahIgo2Hk7xmVgYS0G6SmVleIQYp4ZpCMbZ9pfNunbUM3A9UYOXISsBAiWsnJevWGq3hX4CwYAaqRYYzG2tCithhSlYamjq6SuMqLfmQJEmNblxDzJFfXjwRukVJy7kM5BcPJAnY6SePIxU+8N9TYY/XQX1Ues0D6lFTk+zRblAQ8in5TUgA3lESQ9q0YkBB/zMbLDUkRtOPDUUxLevDf/TzprIAqzcwhl19Arlse15pVIuT+qdyKo9+mMULB7ZRXfx5BefGMQ9Qm2Nktynakr8kEMs314o6M2qDC/u0JaD/YborKBRrO1NWlvu+lhFIImYeDrJhBfZEWaYAK6qa+fV006TQFlQD12s4v6PvuT4/HcKC91sJn9jXiMWeYQxLSFcx341OcBjsiLyqEdgbITVCdg8hoCjZ+HItXwNnCWX5RN4VFCGHhU6QK7uj7XMaHKIO1tCn8ky53nKiItB2rvP9/7kOuOB/eW7GqQWEa2SniEfxrAOhE8kGNVsUDOcuXXfsFqYzg3Vt1F8XJkuSDxkTgiW0Crq0B9wbVz5HxBpNfwA0zS1pJMJ0YwvAZZ7TaR4TDlBin3MY5T9aBGSs73LbXkBCV5e//JaQszeTn1k8zcxCRiffvCMI2KyO8ktxZwZU4ZDMK9u4Jipr0EsA+o/FpTJSFI8pRnpA7XGV5
 7VKO4u7/
 oUhCYHaoqQOSE9MNi0bkHLmFL0zBJXT/3bpNlFuKHci15IWoVwNkzhmjlsrPmkhWpJE6/wres4/iUXXW7VNtvx1uzv1A4mRxfG24VJ1/5Fn1csuphXk32VOrlOR/GRHmKGB3MOH1aNQCq1jB4OzE9vf/xYSY5t2bpvuY35yYWQrR8K/YkPqv+oFmoOeb0pbJ2a4QW7hNP4KXpIyARQI3YUtXGptf9g5pXHJEyiYi4Dbtnke09W5a2eub5jzPqKaPjc/+fyCZIlO2IwinR/WL7lZjcig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 08, 2026 at 04:23:01PM -0400, Luiz Capitulino wrote:
>Shmem uses has_transparent_hugepage() in the following ways:
>
>- shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>  if the CPU supports PMD-sized pages
>
>- shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>  the code block calling has_transparent_hugepage(), the
>  has_transparent_hugepage() call is exclusively checking if the CPU
>  supports PMD-sized pages
>
>While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>in all cases, shmem can determine mTHP size support at folio allocation
>time. Therefore, drop has_transparent_hugepage() usage while keeping the
>CONFIG_TRANSPARENT_HUGEPAGE checks.
>
>Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>---
> mm/shmem.c | 7 +++----
> 1 file changed, 3 insertions(+), 4 deletions(-)
>
>diff --git a/mm/shmem.c b/mm/shmem.c
>index b40f3cd48961..6f8b20d77e07 100644
>--- a/mm/shmem.c
>+++ b/mm/shmem.c
>@@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
> 	else
> 		return -EINVAL;
> 
>-	if (!has_transparent_hugepage() &&
>+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
> 		return -EINVAL;
> 
>@@ -4664,8 +4664,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
> 	case Opt_huge:
> 		ctx->huge = result.uint_32;
> 		if (ctx->huge != SHMEM_HUGE_NEVER &&
>-		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>-		      has_transparent_hugepage()))
>+		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> 			goto unsupported_parameter;
> 		ctx->seen |= SHMEM_SEEN_HUGE;
> 		break;
>@@ -5451,7 +5450,7 @@ void __init shmem_init(void)
> #endif
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>-	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>+	if (shmem_huge > SHMEM_HUGE_DENY)
> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
> 	else
> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>-- 

Although this patch simply drops the early has_transparent_hugepage()
checks from the shmem parse/init paths, shmem_allowable_huge_orders()
still returns 0 when thp_disabled_by_hw() is set.

So on hardware without PMD THP support:

unsigned long shmem_allowable_huge_orders(struct inode *inode,
				struct vm_area_struct *vma, pgoff_t index,
				loff_t write_end, bool shmem_huge_force)
{
...
	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
		return 0;
...
}

1) the fault path still falls back to order-0 allocation
2) do_set_pmd() still falls back
3) khugepaged won't collapse it either

Nothing jumped out at me, thanks!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

