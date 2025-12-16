Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EAA8D609D9
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0956B0005; Tue, 16 Dec 2025 13:22:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B9B6B0088; Tue, 16 Dec 2025 13:22:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B871A6B008A; Tue, 16 Dec 2025 13:22:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A516B6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:22:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21230134C45
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:22:10 +0000 (UTC)
X-FDA: 84226153620.15.1428536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2A7AE1A000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:22:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CBJ7C0XU;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765909328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QHLWmSHPuKCi1RegyUsjcxJkQFzgPj7xRg0jevKzAkw=;
	b=IrX18QKO+HcQbmZwoDyDcmhWcukQA5NYy8pIwaL0kMCW0o+2ILD9eB3zizj4FiTX6gT87q
	OuP14YcdmmP2UpX11qWB6WlIq2MvuSF65b48ic9P4NUeFXE7ltA19/bkuI920R6JYT/edf
	ka7Cn3Y/sm32o5o9nOALHpHAq3RYQQI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CBJ7C0XU;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765909328; a=rsa-sha256;
	cv=none;
	b=k2HUCIEd2vFhqbAUrKyYUHn/NLzSd4twnfemnrj5IhHj1m8sWdyFZ4iSYeCUkNWQk/m1o+
	iO5AJf09t4dg5UXUwBNjfTGVFQlE8OLpBuVWTYtEnhSZfZrMYgO7D7dpogWhehEbyWgmeQ
	lgjXlWvm+nGuZKr0yMuEvJVoH1OjbfU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E335F4178E;
	Tue, 16 Dec 2025 18:22:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6371AC4CEF1;
	Tue, 16 Dec 2025 18:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1765909326;
	bh=dIC+ZznaoOTiv5oAaeLi9cu+OEz/nPaAs+LE4Dgg8c4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CBJ7C0XUNfD5bTzVnHKEICoyhB7/dC7JEYsxoRIGLNPwwywo49J0nMgR1iaermaLg
	 5APqDvzJftCztMCRQhrU12WdddqIfjNZu3Kqz8i4Il1gqyMNVv9FeUv6O2WUcxzeKt
	 KDVcoqGwBV4I69sV5NAM8SJLp1K2DwWyL52Wog5k=
Date: Tue, 16 Dec 2025 10:22:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Daniel Palmer <daniel@0x0f.com>, Matthew Wilcox <willy@infradead.org>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan
 <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan
 <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
Subject: Re: [PATCH v4] mm/page_alloc: prevent reporting pcp->batch = 0
Message-Id: <20251216102205.1d008d1432446956b079bfff@linux-foundation.org>
In-Reply-To: <20251216144813.3016985-1-joshua.hahnjy@gmail.com>
References: <20251216144813.3016985-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hac9ggt9cykanrwfbx9y7fypn3fpswm6
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A7AE1A000C
X-HE-Tag: 1765909327-157395
X-HE-Meta: U2FsdGVkX185srIBMRKr3SIHHiypMbG2vzZF724R1lSIGTniOAsHGnOd1vVFFDUHwgzbl8HNyRrZuTYVeH0AjME3sltGak5GIun50AzYdYugf9hD3keJ99Cm8e44hoJZrO/MfyBhwsBm/1uL70/S2lajPziJROdaEu6X9oH206b9uICArbE4lCxFHsh6PTbbfQUW4sSeanO+hJh9A0bcaXLmUshHCCVR66l/m9iNlnxb0WBdtX+DLjp1LkiCxXUC0bplcRo/r8B9RN4xXsUn6VYeRpTxcE3cGmqetunPNpNE2cERl053RBdtLkGoa6RBnz4o69PbPxSk+d7qxkYQ3VsWkrqm8BQAuCqxef4rK+/HQDy2U+j3efDM3pCsN5flwpPz3t0hJhN3kOxn3T578+SZGzfIDUMlFHMskhKjg+zINjcbaqdI6If0EUJ40t9UNl0L2tq+T7za39yKuU1KSF+ErdaXwPIvstP5+ieGHcZcyDuzYso00KYSk/0Deq9ZmtHR30TaGlZtw0159liQ1e0VBuWmwXD2jwfdAdtDF8p15sxZNlu/ggZugvUSRe1SUzo9FLV5arrbe527JqGjF85+EL4dr6xLDxrdmcbVI89o7K1+Y0h5bOyilvKbe1BBUpUz2u8ExtB9dts8WVRG9d0RmAVNyh+HWD45DbEzbJ7utXu9UE8zYPTN54zfiDixpshaJOSWNmeJ1Cls+i2z7aYyATidugTFQyQncWwD7tnR8hw9FCnjE5VYrqRRQOtcxADM3eubNlVv/aPrfYAyrvZ/sXilyNN7/rQwMeq4MzfQ+bFUrxJqPsEIeGrcmKSF9AYiBGmPxhafUv2YdU1TyObnP4/mVFOxbCKBkfcjyrfNYexmw7KBrT0Nqh1p4sMTcC5HPfu1sOehv1480PagmyvZ47AUmGTGI/lmh6IEvs0gFSYjqP8ygXMxXJGsmG0Vft8eJOm248X4isA+1sM
 TWsVTYRX
 i98p/Qh8ATQepqBXmFjiCiGsUkPi0RfzR7RWODd1Fc1Pmn2ttuiBOOVi84nxcBShl+Fx26+evP6akC8xjqwGS9/4XS8khp0JOxBa47wNgVjaX9o7gPOEtdB4BFEpW47paQMWcrchIDEvdR997n3cMbglh3L1t7RCfjFfuSVoVIx5KJLrpl5x0vOcupDQarUh5FN6ioKxiGRhN0dxPEazrnK5XNH6f9dRK+eSZzF7dX/oO1STHYmSCVFjWrbEdLjl4jZHYFT+Z5CmXbAxS1pLeHA/pYoxhZdNTqDr1PmgRDLiQQBRD31POlMDxODQWK0KBIrwtZkW2dH2WY0RJ7Ptz8XbaQdiMTRnjlfselw6ZKVIeNZEWgTXhDG5uR1V/olm9/oWL0W6FUP59FJ0jvZ3gBJY6wJzh99FDhiul8rg+dda5zXAf+1OuDPH9YWlwOlZ71MPNTMDhu3iZFDajIYUjviFtcN2vLGbSPcYy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 06:48:11 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> zone_batchsize returns the appropriate value that should be used for
> pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
> 1M, however, it leads to some incorrect math.
> 
> In the case above, we will get an intermediary value of 1, which is then
> rounded down to the nearest power of two, and 1 is subtracted from it.
> Since 1 is already a power of two, we will get batch = 1-1 = 0:
> 
>         batch = rounddown_pow_of_two(batch + batch/2) - 1;
> 
> A pcp->batch value of 0 is nonsensical, for MMU systems. If this were
> actually set, then functions like drain_zone_pages would become no-ops,
> since they would free 0 pages at a time.
> 
> Of the two callers of zone_batchsize, the one that is actually used to
> set pcp->batch works around this by setting pcp->batch to the maximum
> of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
> incorrectly prints out the batch size of the zone to be 0.
> 
> This is probably rare in a typical zone, but the DMA zone can often have
> less than 4096 pages, which means it will print out "LIFO batch:0".
> 
> Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
> After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1
> 
> With all of this said, NOMMU differs in two ways. Semantically, it
> should report that pcp->batch is 0. At the same time, it can never
> really have a pcp->batch size of 0 since it will reach a deadlock in
> pcp freeing functions. For this reason, zone_batchsize should still
> report 0 for NOMMU, but zone_set_pageset_high_and_batch should still
> interpret it as 1, meaning we cannot get rid of max(1, zone_batchsize())
> in zone_set_pageset_high_and_batch.
> 
> Suggested-by: Daniel Palmer <daniel@0x0f.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
> Reviewers' note:
> 
> This patch was originally a part of the 6.19-rc1 pr, but Daniel Palmer
> kindly reported that this patch causes an issue on NOMMU systems [1].
> Thank you, Daniel! I wasn't sure how to credit here since it was a
> report on an unmerged commit so I went with suggested-by. If this is
> problematic please let me know and I will change the tag.
> 
> [1] https://lore.kernel.org/all/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> 
> Reviewer's note (to Andrew):
> 
> This replaces commit 2/2 of the series titled "mm/page_alloc: pcp->batch
> cleanups" [2].

That series is in mainline.  2783088ef24e ("mm/page_alloc: prevent
reporting pcp->batch = 0").

> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5888,8 +5888,8 @@ static int zone_batchsize(struct zone *zone)
>  	 * and zone lock contention.
>  	 */
>  	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
> -	if (batch < 1)
> -		batch = 1;
> +	if (batch <= 1)
> +		return 1;
>  
>  	/*
>  	 * Clamp the batch to a 2^n - 1 value. Having a power
> 

So this doesn't work.  Please send along a fix for current -linus and include

Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")

and Reported-by:Daniel and the appropriate Closes:

Thanks.

