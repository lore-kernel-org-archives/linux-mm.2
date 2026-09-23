Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 527DCC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 09:27:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 572E16B0093; Wed, 23 Sep 2026 05:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54A366B0098; Wed, 23 Sep 2026 05:27:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 486B46B0099; Wed, 23 Sep 2026 05:27:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2372B6B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 05:27:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A008B40665
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:56 +0000 (UTC)
X-FDA: 85244497632.11.AECD2A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id EE9D240002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 09:26:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOsnn8bN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790155615;
	b=7EDKGgtpUJzrJ2cBEO1nUT29nEhZlKBbORokcam7+kTYdrqbXjpfZLRPeETV5f/+nrKtGf
	tmVF6nlCMmWUgJp9gma6lAB4HsygdC33dfTMP1bVN8sYuzJx+8sa1X2zt0qDzssM9/wXSq
	DII60WwNCPg/P5+YSMt4/ScGgU7MVhE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aOsnn8bN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790155615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iS6fZqy0nasmuWNUZomY4SexpmabOMbtDPlLHAiTgRQ=;
	b=0kTiTvS07X5Lg0fueYb7otFppgJb++lDD5MDdbl8wfcuI9XDwW0KMnZ8zDRfxMzttrl8HR
	JJhihh7GvXvQA7O9atIrqjqE6YHrIeJxLqRbLzhhgz6LFhz1WK+kH7pwd4NEDU6TzQlys2
	NsUuUi2NhVCHOcsuma741WlMVt6uEdY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 220EA41536;
	Wed, 23 Sep 2026 09:26:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0FB1F000FF;
	Wed, 23 Sep 2026 09:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790155614;
	bh=iS6fZqy0nasmuWNUZomY4SexpmabOMbtDPlLHAiTgRQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aOsnn8bNahb0daEN6DM4xyL/Vuys+FDKBc6UWtuWf8qiGD29Wd4kh4+H+qOBscR9d
	 I5SQbKnZlHTrUREpEndnAAXAGa35nWjMGuyx9nZt0w0LXAB7Jl1aoXwokuo1ErAbuG
	 5McDt8SGzmhKUxDPUlHLFxwN80jiYyJNuDOpKgcAQeYlrIeHSlJcaNfQxJFuRM2kP4
	 biSdQiHFNzVU9/rllWk4K3eZHWjyqsYfNp9/AkRtQNjSJYKrTvwPQF0/dOFd6U+1wd
	 F4my6bqcV6+xhABvQP7U64+mgTCk9QXZLN+3vW8wPN1f1S2zMVvMktRoobzN+6/Hwk
	 7E/F1E13i7dBA==
Date: Wed, 23 Sep 2026 12:26:46 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Potapenko <glider@google.com>,
	David Hildenbrand <david@kernel.org>,
	Marco Elver <elver@google.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
	Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/5] hibernation: make safe_copy_page more robust and
 remove debug_pagealloc support
Message-ID: <arObVuHDoloyEOpa@kernel.org>
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: o6p4fn59b59jbnedbzhwf8fsq77ieffj
X-Rspam-User: 
X-Rspamd-Queue-Id: EE9D240002
X-HE-Tag: 1790155614-153340
X-HE-Meta: U2FsdGVkX1+ucHTq7Tkez73pWVdPOAzz4dctzQihLqJlOVTzeb6BaLPOtBDUyZqrX1k2h9U24BrFtX+WeF7uP6IErGiZwdaDF2z6nKwAILOG1q0c6QGSKQUqwS5JgrecWwyMxTPwmJgG63XZQM3/29DE4xT6TbrUf27f7kWcaIiHeLnrUG2SYt6xEhFmoD2OCjqNg6VmQHKLN7i4+RZu63jCZ4elntmIt1LIMSu2wBj0Ki5v9hPMOj+OcDtVz9FuhPzt8/wVoaSJkJ9i5k1PeRyun+TTNQ+FH6KWMkxJO4b1J/pxktudIA9xK4CpauxOR4ql3GJZ7tkWeu7YCByBh9Bheo0425Z/mzOBLzBhKJL2Hkq/fFG81FHCE1JCFmi6ea8DjIdvVypXudIOGS+1+Tk38NQyl0fEFnNFoRSl0FnGZGCoHl37h/CCK6GKOiHY0ngDndDbTw3kg7TEv5qpMwmVvSfozrOAAt5aJS1qKAa3YVqCf/KWFQpeHT/QyQp9D+6hveh2Zz4EXeyupm1qfLCzKqP2uwfWtncAv9ngxG3M1YJFD3riZGN5oQDrnYdPwJwGvRYMPXiwdvJD4M9m0LYVDqajLxg6OLhKOBtAekfLrqhQ5zUMxcOq24Jqv+OmaP4waogRmeULi7hi8Dsu1mk0ISM63Py94SfV0e77ijU4DOJBY5AY+a/NNw9aiquNXIhTX53T3ag1u8V7w8mZ+wzrVOgT+POrZbwIP+y8Pnoe4fNZbF+kXB49FkNcrTKbcZA7m6Vmb2CmJcwajDWwmPEXgfsFqTm2n9X+nQrkx81lTUmvWb/WxVqmamVDcgiAaUrBdnZHTAL1PlTWjTiCf7D8xTXID+XcRRqmzTXCujmBQAkujV3I6b25YS1UpE8kjLnLOQz6C5Fqmoivmm1wbD3R0JxOmEm8Sg889IGzZskoxWrNJgdPn0dncWyZyynuc8VwVfwgMlC4t8qQpbg
 PVRQDTT7
 uF7wKm5d6qDh16o1qAnHTfbChhnwwalmM0ieugMH81kGsYlcnu+HKNGSfuBsFG+cpOmgUuJ0TplBkH12aByp1fMOiD6OcxQqCmsNd+vMPGmL9AMNvXaqs7SWAN5He74xgk78UVgF6X/MXeoRxeAXWDkMCfIbo1vpEEbvZkQFUjHeF21AY6hR2Fi+jYBjRTRvSM/70Fc0dr154kuGX6H/+QpG0Miv4fZyXZi6hUPAJF0eWwPJhMjTG2UI11QYOTTjnvh2ur0MEs2NrtXxitfPZ6a6xDt5CbFu0AyxwWExS7u+wXY5Hx8KhP1QrNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

gentle ping

On Thu, Sep 17, 2026 at 09:07:02AM +0300, Mike Rapoport (Microsoft) wrote:
> When hibernation creates a memory image, it uses set_direct_map() APIs to
> temporarily map pages that are marked as not present in the kernel page
> tables.
> 
> Initially, this was intended to support debug_pagealloc along with
> hibernation on x86.
> 
> With the increasing desire to use set_direct_map APIs for hardening
> features and with their inconsistent implementations across architectures,
> using kernel_page_present() + set_direct_map_valid_noflush() to save
> non-present pages in the hibernation image is not very safe, to say the
> least.
> 
> Worse, some combinations of debug features, such as debug_pagealloc and
> PAGE_POISON cause a crash during restore.
> 
> Keeping debug_pagealloc compatible with hibernation requires a complex
> infrastructure for tracking free unmapped pages with a page flag/page type,
> verifying that it is actually a free page that hibernate_map_page() tries
> to remap and making sure there are no stale or failed page table updates.
> With init_on_{alloc,free} and/or PAGE_POISON on top, this also requires the
> ability to map and initialize these free pages on restore.
> 
> This complexity does not seem justified for a somewhat niche debugging
> scenario.
> 
> Instead of a complex fix to support hibernation with debug_pagealloc, make
> sure that copy_data_pages() and its helpers properly handle errors that may
> happen during page table updates, explicitly enable saving of KFENCE pages
> and disallow hibernation when debug_pagealloc is enabled.
> 
> ---
> Mike Rapoport (Microsoft) (5):
>       hibernation: make swsusp_page helpers static
>       hibernation: ensure secretmem pages don't reach a snapshot
>       hibernate: handle potential errors in hibernate_{map,unmap}_page()
>       hibernation, KFENCE: explicitly map/unmap KFENCE pages
>       hibernation: make hibernation unavailable when debug_pagealloc is on
> 
>  include/linux/kfence.h   |  29 ++++++++++
>  include/linux/suspend.h  |   6 ---
>  kernel/power/hibernate.c |   6 +++
>  kernel/power/snapshot.c  | 137 +++++++++++++++++++++++++----------------------
>  mm/kfence/core.c         |  52 +++++++++++++++++-
>  5 files changed, 159 insertions(+), 71 deletions(-)
> ---
> base-commit: 0820e2e85e8aafde66256c567ad37a5b15708d4d
> change-id: 20260916-hibernation-7603b86eb981
> 
> --
> Sincerely yours,
> Mike.
> 

-- 
Sincerely yours,
Mike.

