Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF78F557E8
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 08:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B856B00DF; Mon, 20 Apr 2026 04:45:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53696B00E0; Mon, 20 Apr 2026 04:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FB16B00E1; Mon, 20 Apr 2026 04:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B50A6B00DF
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 04:45:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 34EE21A07D4
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:45:32 +0000 (UTC)
X-FDA: 84678300504.15.8A694B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74C41100012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 08:45:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VjShxqIz;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776674730; a=rsa-sha256;
	cv=none;
	b=7wb4JSN0DfSP4kSM95WjpUhzoJcBjYat6vBtTk/UtaLlQbgkKROkAF/HKqSVNQjgJXyfGV
	wRLnmCgfDLj12KxhwdsUYKqk9Fwj/q9sAyy+tW00GvDUfLw4ejtTaQZeIpnPWLRbgf32i5
	wx7IbbH7ICAlZyScLAoU9fHjn3LyAvY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=VjShxqIz;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776674730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ADHqF46w1tMo4iag7Loj+WMyyc0ycxl9bQDzCQwYW90=;
	b=hT22bQMLu9bPetpIoNKNYaSsPJieQd9gns6Et/7atb8p+/1WMaJ+DJufcj0UXB8c/Z2o2x
	a+EQU44OtnwFan1xqyIG2T4Q45RATdV5qGtVcx/uXGGoVk2K4sQK4s2puHkC8EB0kt78yU
	bjkXZSDCn5OUMg0EsK23zsQf+Tz8YSA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A7101516;
	Mon, 20 Apr 2026 01:45:23 -0700 (PDT)
Received: from [10.57.63.177] (unknown [10.57.63.177])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 099303F641;
	Mon, 20 Apr 2026 01:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776674728; bh=aslz2yLWAjdD4IGDrGw5HHuwwhSvb0pvA4zxjSBGvVs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VjShxqIz/6pMdOJQItTXiMxAPrFkmVWqvoYYBHd0AMUOhK0k5/62F2MGuWywZJEqs
	 wfSc/fxt60OjpdpVIgxBXM16uOXIBtA0G7dqIgeBasDbjK/LrEuN0RJ0U4NKryvprH
	 V9PtftScrn0LGxfrb3BFXmLddSwKvVQZWCibDzXY=
Message-ID: <4dc47078-0f8b-4388-9715-744c18590a00@arm.com>
Date: Mon, 20 Apr 2026 10:45:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] mm: Make lazy MMU mode context-aware
To: Alexander Gordeev <agordeev@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <8809412aaed8a515fe2e149c822543d640060936.1776264097.git.agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 74C41100012
X-Stat-Signature: i5u4xf5w8g5qzsq4jhcdk63194ofinot
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776674730-629444
X-HE-Meta: U2FsdGVkX1/6R3Auzg7ShUZqEUBW2o2e2g+yRJ+5SVPVNIByIxO9oDo5V1xJ9hjJIgmO26teCot8pm2mdtcSatY8UYajcnFQ21vfiFC8hePA2vuuIJHVFrNLqrISO+UpC/7Y/BYP+Xm39B6Cx/YodyzkbVXVXn6GFODz5OF8mkkVH+WCDoOHaD8IPj/+53hBOEfd5n90/gk1RPpTjpk2eeh1KdRJq1YkdrJWdToFygGehVZd1GW771khb/VzbqLqjm190ifpKCM7XJJLjSf+hQpshvOfU011BePL6gx7OsU7qK/4CpyxPGw6288x5n4WVtG2WreABmoUWEt5zGFp1o085wzl6uDm/x2NWfk1RWWQMl43N3VtQL1/j6Jji/gxneu6kq+RYUr1GecjhJmieVje3qf68s7dIOjs7eVO02ODAmJNHe11tGdXQ6zW2yiwgj00MRQ9d5Pu5iiTLL4E+kuhycM1KtoaD6UmuLaTfH0AbOGKcc5JH6LAnjVrD55xAtX1aTE33RePOmHiXfARSVxoX0bIERfQiPrWeWhlnbYpyTSI/M4Wv+CNfikmcpuESNPUCU0seLILTrcjsgOn9uqIQ+CLo8kk9ti9D2h02cxu+Hi3wA4UFt6NZGDPpCTkZdRbG7l1v1aAN8CyRiYTJ53v64YP4BZm9NIvgsnJ3ptllxXHEqdSlBqdUflTmNYbRNzVO3PMn409PnoBS5g9Bvpefh+GhnQ1v6da6N0oFn9kAitLNfdaRAdLTVP3G+bwOWVDdPvnSVyRFNgomyzhkLEFJXk2YStpaUuGJ1rJYzLrjpwyq5juODdJK+rqpUnYLtz+htRuXPVNffCJAAnJWHmoNAF0p5m/FKLJDUX8vV4LHjnmeotI6DOnTipPSS0SIUQ/FqMN//gxiD/TV1yihm+QWx0YVhHw+kc5hdsV/oQNSGTfVuTG2qT09DTehWQjKC4OYIGTPKacHucpfD2
 hqlrUYBb
 6p0fDJoD3++Cksqp6aYkYZCwWe6BYgHAAzHKHtcgrDNxLTqtBRSWMidjzkaoXcMvVp3cYgchozWx2uhupkbxHorruhdJKE8JKjdJWuEZMRHkDtYDFhjiJUDU0+GJJgMRJAvlsmJKXMC+pE039GolHofvW1dQzvP2B7nW8srg/X+Pq1LUz45TzXPNf0yizyswHbmT3fXx/O2BsH/bkOfm08/NSEOSDGUopiGKkuZSVmzhEFkFH8WqHEH7ECJ41A24jcINRxakOQaIzLcrDJwifEcSqdrRVrEBqd9+Lvxpyhw2tSvblbS5sftxE6PFhfQhVf01F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/04/2026 17:01, Alexander Gordeev wrote:
> +/**
> + * lazy_mmu_mode_enable_for_pte_range() - Enable the lazy MMU mode with a speedup hint.
> + * @mm: Address space the pages are mapped into.
> + * @addr: Start address of the range.
> + * @end: End address of the range.
> + * @ptep: Page table pointer for the first entry.
> + *
> + * Enters a new lazy MMU mode section; if the mode was not already enabled,
> + * enables it and calls arch_enter_lazy_mmu_mode_for_pte_range().
> + *
> + * PTEs that fall within the specified range might observe update speedups.
> + * The PTE range must belong to the specified memory space and not cross
> + * a page table boundary.

Does that mean that all PTEs mapping [addr, end) must belong to the same
PTE page? I think the wording should be more specific.

LGTM otherwise:

Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>

> + *
> + * There are no requirements on the order or range completeness of PTE
> + * updates for the specified range.
> + *
> + * Must be paired with a call to lazy_mmu_mode_disable().
> + *
> + * Has no effect if called:
> + * - While paused - see lazy_mmu_mode_pause()
> + * - In interrupt context
> + */
> +static inline void lazy_mmu_mode_enable_for_pte_range(struct mm_struct *mm,
> +		unsigned long addr, unsigned long end, pte_t *ptep)
> +{
> +	struct lazy_mmu_state *state = &current->lazy_mmu_state;
> +
> +	if (in_interrupt() || state->pause_count > 0)
> +		return;
> +
> +	VM_WARN_ON_ONCE(state->enable_count == U8_MAX);
> +
> +	if (state->enable_count++ == 0)
> +		arch_enter_lazy_mmu_mode_for_pte_range(mm, addr, end, ptep);
> +}

