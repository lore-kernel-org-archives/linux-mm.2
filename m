Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8034CAC587
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 269B36B000C; Thu, 11 Sep 2025 14:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21AA96B000D; Thu, 11 Sep 2025 14:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 157B96B000E; Thu, 11 Sep 2025 14:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1F706B000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:13:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CAEB854CB
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:13:56 +0000 (UTC)
X-FDA: 83877768072.05.A3C920C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4EB0A40005
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:13:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GqAEIMRE
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757614435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zSP6izr/VEjUn6fCSIH28IYDDNkg7u1i9yqVYtbIblo=;
	b=o68E8dIDiZj2n0SJlyRHJKEilvxAmP77szZtQyNVvUWFMf5Sb9ORhw1kVEafd5sCvwIU7g
	P4MK3lF9TZuwgr09dJWQCYSGhytsVWLSJB6aY5iNP/Ofza1EmY7PZ0YUfodPs6cINz04l3
	sHPDJKCRwP/2tmR/FIHqrtRmam3mbEA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=GqAEIMRE;
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757614435; a=rsa-sha256;
	cv=none;
	b=u/c1WrN/900urQEXByMV6+2yBNt9EjAXBc6fshU8CKFwzB9pywOxaZ/bOggLqhMNXq5N6y
	NhL9jGEctz+COTMidrW9gJWW28fIIG+ku4R8GBj+eWteFu7RDd7O0zbrR9RFNAjTmp19XL
	aHS7DpscTssvmy70Wd0sxU6GThzDOSs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=zSP6izr/VEjUn6fCSIH28IYDDNkg7u1i9yqVYtbIblo=; b=GqAEIMREFnKui2qVYNYRHkcNXo
	xZAQ/MaDOgL/MJ7htwYhty4ql2Ut+S84Ersp8JvMxLZ2h9PKSjC5atq21dPoQsfETYYc5LMla6Lp1
	Ae3+FoReyN7BXbI8R/DbtWMK3h1vUSjIbkueVqW+zS/IawABLSVq2n3n4r0FRs+7g74Gv7hCaT91B
	FpO4l5wDwcicsyWJMmPnB17RF4eyUQKdDGdEQN8UqSlBz6WwuRCfS8XC5sVBYTLqkZiP6rbrjw4TA
	lUelUWnmFQ0iYgzHgGHdj3pqr3afXTZ2WNHGNiUEhjFGGK+JR1z/WXY1aPdyWR/r3xVshGw34VuHx
	3YGO/CFg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwlnl-0000000Fj40-0KW6;
	Thu, 11 Sep 2025 18:13:45 +0000
Date: Thu, 11 Sep 2025 19:13:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@redhat.com,
	akpm@linux-foundation.org, mike.kravetz@oracle.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/hugetlb: fix folio is still mapped when deleted
Message-ID: <aMMRWMpTx6jjZunV@casper.infradead.org>
References: <20250911130848.4087211-1-tujinjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911130848.4087211-1-tujinjiang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4EB0A40005
X-Stat-Signature: tfa41kity8zta5h8nb6btg1rpwuad47j
X-HE-Tag: 1757614433-230128
X-HE-Meta: U2FsdGVkX1/I0LBWjPJ3UMreEwjJ5mf5BB2v3YaQy9S82/mJMLg3yje75lj+h/yzEyHW2YpQsAcWg5VtrzuD0eIJajg1zU/u19bW6SkD9rjvqqX0MpF9eqgVAFOop4CdEjnyWu11/Fek54ZCOomS7WVV/z/efT3VbAFd7ACfpMUzQA+OX033Kpg6KIH3EtjtDT3pLGAm2/AdtJ8Db3vIc+EKD6++v3UylDuFVcfVt16azCxjxykzWNPaPWRy7CtEXE53kf8so1XmSLGQy3YXpggabfdDHG+m9anLDgUigcJ5zmmTgf4GtNtvu6g+rWxDPpIFRp1bUnyopcN0DTXjP/sBlm5/03lSvJH+yqPfsLjizyUPcVwx9jBhzhXLWR7EI//rZnj5tc421LHjnz4AFBtm0C2kApoWGdbzXZYEXaT2fUvKVe+fxbhK3vetf3RrDXAr8/+0zc9b+M9QJU5hROLzHmfOLPGEr2UROBZGhVpiTXky6t6tT845SXiqXfRMFmha10FS3jIKgK55eYx313A9tRSFFLSAiuE1enUBVsg60zLwt3F6hiV4OAzpr15mfY02XPU6QHKDzGt7RZGI80WwyjVyksqkfCCXOrGqMy+P+IBxUYP/amD61FqUN41hbD60zryUYdDWqMMvQOY6FP7j3TSg+sMHSdFLSgwPxkwxob3bSb/4kccwtQMU5EKQL425XIR1yhhRhMxPPs6D7DcRDbrpkQMw9JL9RJDREihjhi/e9sHzu4vh6Ue4aWFI8CW3lpQksFPWnAt5Oeah5rYZ+qn/2yOzGv5FFbFuJiba30M7nQfzNE5j7MQwXLeudqMDbY+hBUYI6H5d8NdlCY0+iOaUbpqp13g0/xqL+2ynlkTwLyTqOi47/O977SZH8bCuWenB+4xxTbpfDriLuFgM3iiXgO7lSYUbRKJBI79fXTa+GwZMg6keMN93Zj3LmzaX8qnwKgmtu4A63kG
 Qqc18KaA
 baRFnFDLkf73jpyjFICYX2jZNAYjBShqtvukj4eawiGCG+2E0GkI8FM8WqSYtnFdSctI9eHGnAaxqIfwInA8EU9TVwelaPzYVqhWXPKfU4J+jurFyqtHyGtS5OOToCVkEKCM88mKAOdYnc545KArNtEJ6PTt2nzgjPlBApvmV3OjbM1N5kKPCgGnerIa31dUdZB4F2AIGRThD5LOw0yoTZCGPJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 09:08:48PM +0800, Jinjiang Tu wrote:
> Migration may be raced with fallocating hole. remove_inode_single_folio
> will unmap the folio if the folio is still mapped. However, it's called
> without folio lock. If the folio is migrated and the mapped pte has been
> converted to migration entry, folio_mapped() returns false, and won't
> unmap it. Due to extra refcount held by remove_inode_single_folio,
> migration fails, restores migration entry to normal pte, and the folio
> is mapped again. As a result, we triggered BUG in filemap_unaccount_folio.

> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 09d4baef29cf..d21865d0178a 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -521,10 +521,10 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
>  	 * the fault mutex.  The mutex will prevent faults
>  	 * until we finish removing the folio.
>  	 */
> +	folio_lock(folio);

The comment above is now nonsensical.  Can you correct it, please?

>  	if (unlikely(folio_mapped(folio)))
>  		hugetlb_unmap_file_folio(h, mapping, folio, index);
>  
> -	folio_lock(folio);
>  	/*
>  	 * We must remove the folio from page cache before removing
>  	 * the region/ reserve map (hugetlb_unreserve_pages).  In
> -- 
> 2.43.0
> 
> 

