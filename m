Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6C5C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:12:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854A26B007B; Tue, 11 Aug 2026 02:12:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 805356B008A; Tue, 11 Aug 2026 02:12:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F3FF6B008C; Tue, 11 Aug 2026 02:12:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5669A6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:12:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDA0F140332
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:12:29 +0000 (UTC)
X-FDA: 85087969218.10.638D0D8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2118B160003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:12:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aSNZWXmS;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786428748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/UGYQSjnHuc+3UR5baWVKGHThn8rJ4lq4v2DDPLbWbo=;
	b=sJDaFO7DANbCu+4jsLlodWgDnPLoWhTY3VM4hyvVB5FfV+pPCQZDGjjNG6Rpq1MxnaCxw3
	MenHLB1rzVbZrIbkPrpYw7Zg+Lwyn+PzRRQTvYQp4nE15P0A4svI8nbePWKMUr5ZPyDL4m
	eqdIpjnuMQbSZd2mgFIGWCgZ+KjcynQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786428748;
	b=xKkTv6/YNWL1A3h3SwqLkJSmCwy9PdzuGEWYLfXIxSd7L7kkuZAsQOFSqQWgDbqEgCGLQp
	+R4QNC/wb0FJ8/E5tuRsbWmuMa1CY+8yq5gIuB//5lxTP8rF16xj2IcFWYDURxz2zWustn
	3hf+/HAdUq9cL4WpYHkeXxU1SetssgY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=aSNZWXmS;
	spf=pass (imf08.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39E021516;
	Mon, 10 Aug 2026 23:12:23 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6F4743F673;
	Mon, 10 Aug 2026 23:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786428747; bh=YPngkyZQUknL6eYoHM39EKgSPpZsPdOn2PTZAnc+2Gg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aSNZWXmSWFmkhz5NE25zsOFhALiWP2B9LTRmUiAeaFHhyA+TSKo7kPSWV4No2VBEW
	 8hHzttqyDk5R93gYCoK4TR8y+j4yHlD8sr/3yfWtVBO65Fht6gNQigV6EjVZVlj6Xs
	 qpb54kFcwZoJsPnGqvgexc7wYKdLJy4EBDxYKjao=
Date: Tue, 11 Aug 2026 11:42:23 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/cma: remove stray newline from auto-generated CMA
 area name
Message-ID: <jrixr5xgpt5ra4vz6bltlhmk3n7xxu7vamjgvnkk6ite3gjrst@jad4eqg4tcei>
References: <20260810093215.91419-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810093215.91419-1-hongfu.li@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2118B160003
X-Stat-Signature: yp4xk934i86oexwmdmbznj6p49cyssuc
X-Rspam-User: 
X-HE-Tag: 1786428747-198153
X-HE-Meta: U2FsdGVkX1/nL8a/chuDJCzZMac6rzS3WTa81hsFgivyLieUljS+nh6rA+Q0myeY9f6RMZR01dcjnvC3wWFOybESe1Rqr386z8svFa+xp6hNgBGMmLbOS9EczN6f4zEfIQYLzUqLF71dZR5qdEfGnlcvL4ZOfuKoFvHxSBsainwzzm/XF8r5NVIZQZIUtKLo0UQlPVbaTuU7TMAAVwGJYBhdlDa5ZCgI3B7zAJUndbrAINwR6V9PMcYxu01OJWXb6M3nOKnxkov+qgpKCgvpSncorqjtP8lWWnu+T79lecjt8F7qm4FoPZHyaBbqeYQspHu8DNX6tSxrKtXxB75c8MO2DEo2T2G5iXMCVfNOrMrBRSMeSqEYkP91F2CwfMAOjyKtDsfuWxia92Um1paGQF1xfSO03Sc5hzB0vio6o5Cdzmt/zAZsNBHYXtOwWw9aQGXmiVLSXo82IMumTFeiN8gm+0TeYdhuN+fTiQVIBMueiZjkd32Brpgwp47u2DbGIgw7PoP95LkoK35SYTELVKXJgpRkCh8VPwAC56lUO8qX6Wc2Bu0zYFTzA6xtV8uLxFvKc7VWGi3l/OGhBSEn9KrBJdJmMk2WeChyu6inc5nheZTohFjRs8MDoevxHTtlKkfKiR/8DCodmq6QNt2EKlOqZFToiAK13+wY8H77lvszBslm/2Ow354XjWRs5QDjdh2Fp9UaOJirdZqjf0wpLbcLtIVhT+mDxmGHwG36cKyWjGrxWxv057SVh00LYhHc8OcizIV5tBks+M5ESxCyCLmH9Hfi3oeT0KOUqhXgT+PWJ5ZWoHcnEQDQ0zPNmOzEs/4LYP/RSI7mnS48nE9QDxFN4xejJpBYCUuspnPkTkGBFpjr6sI/jfP4pDBpAZpQZc7urtOPqRIGY3XbMiqwFvstn+UT9SoOwVMER24EjfL3Nb6m7v48iTJ9i9tbPoNILoxDxPCCuN95uv72oFX
 gqVBBfc4
 dJSPYkA4UcK1+JWMhqMAjh5vg/AyAO8pkzu+JB33foEKXSpWDuFFO6GFUENcENEjmkAGluaZFUFO0cnJu9O7Aiys8a6mOvlDdyV7Jt5dpkPue1T1dAonM7GJJYmZW4iCLxWlEEvXOvxMbGa+e6OAdNg0lZgy+NXYnuu7cpm3YjH7VSDOrTAJOa5TdZsR9ke3ABMPGSGSKnPLoiRixnIur+aqzbs77efblpBtL85lPQaKcC3skmqJwhoqykjkXamZ6sPXENZ1G9Pd1CLfDqIERX1R9wi2u/YUjuYhg5Tngx3p97QU6SpNy9ytug8sCt7IAzRRpIAB/KoFBmYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 05:32:15PM +0800, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> When no name is supplied, cma_new_area() generates names with format
> "cma%d\n", introducing an unintended newline character ('\n') in the
> CMA name.
> 
> Most CMA regions are created with explicit names, so this path is
> seldom hit. The newline only creates cosmetic noise in debug logs,
> traces and debugfs with no functional impact.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a7929c758df1..a10ea37a261d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -242,7 +242,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	if (name)
>  		strscpy(cma->name, name);
>  	else
> -		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
> +		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
>  
>  	cma->available_count = cma->count = size >> PAGE_SHIFT;
>  	cma->order_per_bit = order_per_bit;
> -- 
> 2.54.0
> 

