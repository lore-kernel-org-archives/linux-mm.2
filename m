Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9686EC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:18:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C2236B008A; Thu, 10 Sep 2026 02:18:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55B656B008C; Thu, 10 Sep 2026 02:18:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471826B0092; Thu, 10 Sep 2026 02:18:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6666B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:18:21 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 185A2401CD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:18:19 +0000 (UTC)
X-FDA: 85196847918.19.F547208
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 565931A0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:18:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YWqnZs7f;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789021097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HZvhdr+7QCB5p9rcdZOkfxfILYHQvwBbNCROl0jgk4=;
	b=LA4COk2WvOICvxgnwR2sYCDoM8EP/uhSU6meeCttH437Li3oeSfdGeqaGes2oqpCS00R1z
	PZFLbWd+KWLiXGqqRPX+NYNu1tGyI61KLevLGJMmkS8J29wlKn57GX56i6EOjX/563JAbQ
	wvES151CKr96caEXVho3NPtB0SqRE+Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YWqnZs7f;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789021097;
	b=tVB296mmkO+HVoxqkqEqotCEg9b4B74qjRtvEgvh/rAVLUXCKhDF+lbFen0GuW7ipdBCSt
	2lPSWHnQnadf2wDG5jldcWwGG6C4JQF0nzjehekUZJAXngQGAE07tszSIsAT5wXUmdAIfK
	5VMufg2CIpW73WclBJhnw7KPAgcMFvY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AE5F400B2;
	Thu, 10 Sep 2026 06:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EE61F000FF;
	Thu, 10 Sep 2026 06:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789021096;
	bh=6HZvhdr+7QCB5p9rcdZOkfxfILYHQvwBbNCROl0jgk4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YWqnZs7fu0CKaV9+WSxSx7dskxKIy7WpXa7aoifE6T47KxX6nVVT2B6Ay1y60gxSD
	 2Iei8ksW81V1S+8ZkQzhpOhwF5WSbo4/rLbH76nHxjqMaanxnNz2vKV36TgvXVs6RS
	 PZOpI4sklR5Gx9IqsZUkd6081gQAad2wtfP/cVjg=
Date: Wed, 9 Sep 2026 23:18:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <weir@nebusec.ai>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH v3 1/1] mm/memory: constrain generic_access_phys() to
 page boundary
Message-Id: <20260909231815.bcb1ca6091ae0ba1b5ba54e1@linux-foundation.org>
In-Reply-To: <e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
References: <cover.1788842306.git.rakukuip@gmail.com>
	<e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 565931A0006
X-Stat-Signature: ccq1fs3m6n1a48zeqd5rt8rcwsse9xhs
X-Rspam-User: 
X-HE-Tag: 1789021097-473211
X-HE-Meta: U2FsdGVkX190oXaVMyXolvMbPYvfmS6mxv2/stW7JYDU9oCMqju6xjBpqT3tbE2X04LEOcF6gCoZ2q2vfxRiQuAmVOBgxUT0z24HnkBs63Pfom6NA3YzfA+5056h+1N31Gvf4ZM2jFbpCZzCbePbY33088dxUaXUnEpcoIGgCmqx1EzLt1hpcO94JdHoo8aZSUyKBmU3e+29VLXSUXde2b3uE63MbuMNEFMFauGlZ5j71lVAWod0/BrBEGjidgMWaSEtkPZclzzoXFDturpgQ/DjSQnkQRmnnQ+RKKXcpZcP77SxsnvujS2ARpxjARYEL3/To7zjMxlSQMMFRr/y+mQID/j81Mp4JYro3+VSTcV6DrWj8VOVQI/XevfypvcqZJWFQpEoBJ1OOAWBtIRjtdgQb6SoXQzm2YK1fKtShBclKhm799cFYJZEphQ2rr936rdnH5dUjmWSPof9izQdTF/59xIPTS1AAZj+KRyfDNhmR35iWGGBQhdQiwqb+lEbnYLuRkMoYq98o+eowjKjw1LY9BaMcxdj5Syq7QYrMR7qrxqICG04Wm1cdI1NOuuOEHLzHvKrgizZhVV1VsObYqgKtU8J928otKA5FJjFQjvU29S1BmZujazLaTSDKorOX4edkm5LzysNjOg2FIQ2O9oat6GpAq2fwVNYLrTW6eTg+V3IqB96PKOtRAruRUGK7a+3tkvVgrMaPIwMh2w8zl1Z+2dB0MBtRg2Oknmxtj4htay8opD5MihRLCE+jFMijs8JR/+9J717Gat10DhcdliRJPQTNNQpYXqNiQmCwAlsO1voaDBTqJYr1kQAUIEhj4/eDtXMuosMvQGJANaLO66D57/Pdeb6a/9lku44uNMkCudH54MLxuP0S1HEV2xhqRDAehQq91Yxg2/zHziOlJ2THkXwUZ37x61iFxaJYWEClymvh64Z8lHo2dd0fqnUSnl+GZZLmD4TXlDqS25
 h2uZZCEn
 J9cy+BjqFkgKcucGyYRY7GLAoRWeKVhaXcxeceU7OVPMNEY07rJY4aRcQSXYBZGP8rF8FSf/CcOj9AXBKVyxUPhvBwkhAAKuomHuOrblDl4zh1y7BYWZbX5yJ23P5p2MA3XhchhXYZPV+t4wefbikLelVH4VekawwURJ0mYbMGPYBUl582TKgT/8x+F0aSumLRWd5MrIaGXD8bS59NDmzdfy2PR13sblna7zJIUKoq7UrGEX0IaQV7xTVLfBvk4IHZp37gBbvsUVEVjE9qWw0c7/9GYe5BvIedTyUeCRfA/m1rrXynd1+KprWRF0n26kUiQeINFYARreW6G+de3k9bj9KHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 10 Sep 2026 11:42:50 +0800 Ren Wei <weir@nebusec.ai> wrote:

> From: Luxiao Xu <rakukuip@gmail.com>
> 
> generic_access_phys() improperly validates the memory access range: it
> only validates the start address using follow_pfnmap_start() and passes
> PAGE_ALIGN(len + offset) to ioremap_prot().
> 
> This poses two problems:
> 1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
>    physically contiguous, and individual PTEs may have different access
>    permissions or writability.
> 2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.
> 
> Constrain the access in generic_access_phys() to at most the current page
> boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
> ioremap_prot(). Since the caller __access_remote_vm() already loops over
> the requested length and handles partial transfers, it will naturally
> iterate over the remaining pages.
> 
> Also add a missing (resource_size_t) cast during PFN re-validation to avoid
> truncation on 32-bit PAE systems.

Thanks.

When fixing a bug, please ensure that the changelog always clearly
describes the userspace-visible runtime effects of that bug.

> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
> Cc: stable@vger.kernel.org

Especially when proposing a backport.

The cover letter tells us a bit more:

  This patch addresses an issue in generic_access_phys() where
  accessing memory across page boundaries in PFNMAP VMAs assumes
  physical pages are contiguous, which can lead to accessing unintended
  physical memory or exceeding VMA boundaries.

But how does this manifest?  What does the user see?  Has it ever
happened?  Is there a Closes:?  Any reproducer?

> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: LLM

Please update your LLM prompts with my above sentence "When fixing...".
Let's get this fixed for the future.

> +	len = min_t(int, len, PAGE_SIZE - offset);
> -	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
> +	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||

hoo boy we've made a mess of the types in there, but I don't see a
feasible improvement in the context of this patch.

Also, a [0/N] isn't needed or desirable when N==1!  I'll consolidate
both into a singleton patch.


