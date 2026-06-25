Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22627CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:16:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94166B0005; Thu, 25 Jun 2026 10:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C45446B0088; Thu, 25 Jun 2026 10:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82166B008A; Thu, 25 Jun 2026 10:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94A8E6B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:15 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CBA3A00F9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:16:15 +0000 (UTC)
X-FDA: 84918634710.30.4A67AA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 52EBE2000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:16:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlZL41Uz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782396973;
	b=WlaHvfsjF4OWsHmZDNkl5HyT3fnLU0gLQwjdiGBfaO9Qg2cUkYlsL8ghhxtYPJTJIpIXRG
	Gz0xpsYp+iHVJ+u7J1skmPbWgbPj6JMFW+/93WuD4dK/uPJiXlieTaoZ6FLoCB7/ZgFW6k
	qkByToVDKY9FAjjzYs2wFkzwTU8W8M8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782396973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1wRyU/uVNwsp5kIpSXtq4B2ItLSS4KA+rDnr/bqKuA=;
	b=tNZJ46scy3gKZXUaST2t+3hr/RIfEk3/zncP0mUGt/gycM5By6KNlPgzE6ModUTVlXnQ+B
	QiWx6kxT0TBMh6zvLiibPQrJvMzRvgU4G1kk3Y6oKEVg64I1ukBJ3//NyLHG42wRFjc5QB
	4C6+iKnfAx1w4VfOuyusdkBOO2lv52Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WlZL41Uz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B196409EF;
	Thu, 25 Jun 2026 14:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE95B1F000E9;
	Thu, 25 Jun 2026 14:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782396972;
	bh=P1wRyU/uVNwsp5kIpSXtq4B2ItLSS4KA+rDnr/bqKuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WlZL41UzRiX8cjHL5fclbP1oUeUmu/npCkFYFOd7GhvuS2aoGlVBfLYYz+laPX0Qi
	 KZ6mlLuIS7Vz4izOYCLsDds6pS8bhhv0Di9gJfWZTvGEggBRfcqdv4OEZpU5c4xs6Y
	 sfFaHf8RFGZfQqyQTyE9qvz/0zW7DVOXmZGpaJUhdA8rkvemH8791TLDOs/c5lm8Cp
	 DseI9ZRnZRBdbKeTNC+afmL2Wv3zHc4xtU4Kzf6SoH8oBzaVM3tdjyYUo+/5Z96hxX
	 Gc83tx63B3ZdKYuVBHqItKnYkeFpWWCqsqOVBPIBF/cEl6MYG8+FkN5pmo+naq1/oi
	 5Rbvj39cy/Hpw==
Date: Thu, 25 Jun 2026 15:16:05 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ahmed Elaidy <elaidya225@gmail.com>
Cc: stable@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, 
	avagin@gmail.com
Subject: Re: [PATCH 6.18.y v4 0/9] mm: backport sticky VMA flags and
 soft-dirty fix
Message-ID: <aj04FzkKa-9kqVrJ@lucifer>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 52EBE2000D
X-Rspam-User: 
X-Stat-Signature: 8mfmuhtnxnf7mgdro59x6qfo8nmt5p11
X-HE-Tag: 1782396973-122434
X-HE-Meta: U2FsdGVkX187ENAr1+BUuI3H4IAgohH9EFYAnpiHJfpbmtCjOl1lt+MZatXSyPVzpENLmS49rerZgdljd1H5so+ujNT6uccg6mQWj8OhOoa/tqIU8yiSG+DP3rnImepfujYRNw0AtTCuBsgv7dE5m+wNk9l1QIkmP3MauYy8AEHVmQ9ax5uzRo+BytHFjjGcKbhHCWRDS3CJNBAczycpp4jzmyE8zFBAOph/EwXu3dBW0GQKMLE0QbETw2CpdFsqEOUr9jPnDdQ+efSL+VjGUu2icTm/DzYXqj2wJNWiP7Jya4AzKmK9YBilrONCa+fMvcYn+ZM1A5/wJJLYt7WmFwvaxFCbjm3gbawlLMtc0Fe5RUNJvkUEkeWUe++6bJTjxLqUwDEfB64gbaLMy+0OIFAA+to7BAYGpFPNu8VbkaZoUq7x0MM3AV9zc7rEq3ofciCkoi6RvYqCPjy9D/7Qo3y7oXICZnpmRb8tf5N9nnV0hDuHDY1QL2/kILmrhHq6rqlfoyshk+iZnJMf8kshbuKzNHS6bxaF/1vCSRaLLWQjQArbhmu0tVVSOcxNMjl4wjOohYUGtbxzaSFcZPUx1V2D83AsbUWzACO4S8nbpRAN+SNrmLIg9xgRLZEuzWndSK7aseaDrQNwaQka7vrMDZnsQX9R3hEpX1gWZXZH4M2dN1KtXJYRLoKWlkeiNg45l5LtgZa47InBY2H8gkZ8+UB02gYYeETWMvf50z6z6lqZyHknHr0PEmUjb1aug58cR6OtEwAhITSKAi1Lajo5rznBHdwpVX8nGNBxp0bU1E1tHMaXprh1Wm6lY2QYQJjLTjVEbKJF9tmMm+qq/yvLR7uSg54doYKK5UtfEo6N3NOjCw2q1hUQaqMcNjUIitd3JWvEzkoIOty6ghdfgowXZ8C7Um6X9mAq98yr12gzh6iNlnHfIKxdfScY5YJbnE6FIlobTZNiuf63vl80PiD
 JEK8vW+o
 VXq2AWEG5anoHQgHXBIW2PpagOGAYSTfGLnKGlP3DKpobbAs6XVgLcvGJV4lWXC9OBNKXJI+ZoCBpTIwEDSQvieRzZzFCSX8tCly2vvnaVlefGg7nqHsiYF3a3iPhM2GN6b6GGHt0XAr+g0dpWJrzTwsf8oEKCQLSXxpA2h75DyDT6DMkW4w44iAOCZ9uM/eBh3vcRA829ZrkS2wZkJwJIqc1SJ7Pc7WCcsUWhC4H8JXlD3eaaz5rJvs8t/iQ7TLbxC9XgiN4pP1ToCSKderO7TzbZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 03:42:10PM +0300, Ahmed Elaidy wrote:
> This series backports the sticky VMA flags infrastructure and the
> VM_SOFTDIRTY-on-merge fix to linux-6.18.y.

Thanks again for doing this Ahmed! :)

Cheers, Lorenzo

>
> Motivation: CRIU incremental dump/restore can hit a missing-parent-pagemap
> failure when VM_SOFTDIRTY is lost during VMA merge operations.
>
> Patch 8 is the target fix:
>   mm: propagate VM_SOFTDIRTY on merge
>
> The preceding patches provide required dependencies on 6.18.y and are included
> to preserve upstream behavior, as requested by maintainers for stable backports.
>
> Changes since v3:
>   - Reverted to sending the full 9-patch series as requested by Greg KH and Lorenzo.
>   - Updated Lorenzo's email to ljs@kernel.org across all patches.
>   - Added Cc: stable@vger.kernel.org # 6.18.x to all patches.
>   - Added Fixes tag for soft-dirty merging in Patch 8.
>
> Lorenzo Stoakes (9):
>   mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
>   mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
>   mm: update vma_modify_flags() to handle residual flags, document
>   mm: implement sticky VMA flags
>   mm: introduce copy-on-fork VMAs and make VM_MAYBE_GUARD one
>   mm: set the VM_MAYBE_GUARD flag on guard region install
>   tools/testing/vma: add VMA sticky userland tests
>   mm: propagate VM_SOFTDIRTY on merge
>   testing/selftests/mm: add soft-dirty merge self-test
>
>  Documentation/filesystems/proc.rst      |   5 +-
>  fs/proc/task_mmu.c                      |   1 +
>  include/linux/mm.h                      | 100 +++++++++++++++++
>  include/trace/events/mmflags.h          |   1 +
>  mm/khugepaged.c                         |  71 +++++++-----
>  mm/madvise.c                            |  24 +++--
>  mm/memory.c                             |  14 +--
>  mm/mlock.c                              |   2 +-
>  mm/mprotect.c                           |   2 +-
>  mm/mseal.c                              |   7 +-
>  mm/vma.c                                |  81 +++++++-------
>  mm/vma.h                                | 138 +++++++++++++++++-------
>  tools/testing/selftests/mm/soft-dirty.c | 127 +++++++++++++++++++++-
>  tools/testing/vma/vma.c                 |  92 ++++++++++++++--
>  tools/testing/vma/vma_internal.h        |  49 +++++++++
>  15 files changed, 579 insertions(+), 135 deletions(-)
>
> --
> 2.54.0
>

