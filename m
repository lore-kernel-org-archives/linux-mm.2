Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6664CCF45BD
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 17:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE14E6B0005; Mon, 12 Jan 2026 12:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64686B0088; Mon, 12 Jan 2026 12:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71106B0089; Mon, 12 Jan 2026 12:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A09816B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:47:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37CE413BE68
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:47:12 +0000 (UTC)
X-FDA: 84324043104.06.3E6FA4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 9E41E1C0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:47:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpZXpoyc;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768240030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6f+Vje3SP7Y7ZWKkHnsimSRoIBLz1yhKzsdQyF6qfo=;
	b=txLWQjBSPApEWnKRXsHRgxiqmMcTOULTBuE4jkUIk21dR9a7Lq3NfVby5FVGYxtbLE/q1q
	uxLQ5ZVNDDS2zb8CO0LQsVjvMKYUn7z/7MQqj/8v3FWGkFW3/bCpjHIcRfJvJztNk1wR4j
	cDPbehT5FcNhwEXL5xnhzsh8Xtl2QGQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=LpZXpoyc;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768240030; a=rsa-sha256;
	cv=none;
	b=m55Qq2CrytWcIkrRV3pM8gzsl7kPWQP3ZBA3f491AxRKgunOaVOrehvGrnA5VBvBk+2X4U
	t1pBkpSZSmkQuQQdYztTgy4NTytNz9cgBxrP+N7VyYD82+nMDgPk65tn8SiWuSrbUYH/DM
	SgOPIeQCqk4Wq0hgB7abRGbW1Y/zlu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9AFD46011F;
	Mon, 12 Jan 2026 17:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097BAC16AAE;
	Mon, 12 Jan 2026 17:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768240029;
	bh=2dTDkiVRgcHJftm9NWhRy0KEikPB7jlsnjfXZvmzkhc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LpZXpoycG9xeQz4UqKy9nE4QofwTeJAeRpTkkEfcOPwezXFimm7Axu0rIjHBOi0uY
	 qb+P6PBEkSCiJHYvlovFkaXAVENCNIZh6zyuRe5RgLZSWNQ/Kj6FRVAN2oB6i6YQ7D
	 Dc25g6UF8eE6GxZ3rjIVBmOgsL4bgOEONPpvcIK4=
Date: Mon, 12 Jan 2026 09:47:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
 <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ksm: Optimize rmap_walk_ksm by passing a suitable
 =?ISO-8859-1?Q?address=A0=A0range?=
Message-Id: <20260112094708.e965f00cb36678f41b840cc2@linux-foundation.org>
In-Reply-To: <20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn>
References: <20260112215315996jocrkFSqeYfhABkZxqs4T@zte.com.cn>
	<20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r699u3sens6np7armyuj3py8rzc3uugz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E41E1C0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768240030-364731
X-HE-Meta: U2FsdGVkX18BV63KuPCJ8x1L+ZBaJ8/JIOeSAEIMN3ieh/tf2EpDyrTTshPgC+t54GydPaEpA/gBKG0v8av00CuPLV3hiVG4AEsZn7HwXg6ciWK8lNBFkVfijSFnDOn4QjzJeLEqEciVCZ28g/eZxNTEMVQR8w9LJjKbYuZ17I7wDQfbJX/wWDBWpZZJ1NeT4xKdYfEMbnETMXUEYVFmh+p+dpGgn88qzvNcGPQGzS/Nk2UTc2GoUiLQhVD69j8Jgsfw4HBeElJquI/YP2Dc8nxQbjnUXxO0ri43Ow+7OkVwcgG7x0f8GUTgmB8w+UMmI7QzWnlRQ3T+XKF7AENPdBfTfvmBixmoqL0ntcZ8fEZVXCh0WX81SIHCLTBPx/YjSDNwbLv4n20DOBeyggDHbbpEO8lUf3iKbbFot5TubOG/cXW9p2gdVS0HA0XzSYN5DWtMcuKbTz0u6W0bieYkZPRRwcutALwQR6Uqy+eFbVAwSECkVPkyNmWylEwx6iM15LdiLgTPF6CSXp3uwZX9ePnQeKZwpcgvPpgXZGblPwaBiWyQk0b/uz7oVCrM5blFNLiX1garx6XzclltFmTuflArUJpUrJ8znokjpgAmLUuYgsl4HjJz+T/QKe9NY+qxfyPKZayJdD/zZDvh36f5qrAlgI+jUMsIQGwCSdNJhexGN+zzcC36qQzZIHEnPR/64VUhqF9sKkY1Ko2XLddn7OBIW/REIBIwSkMOlBrUjE0jG1YqZjUvA7PIhOtrwW5Ol4josZSuHkuyV95JcVKC+qUA3HktLrEofOUlCLzQQi1iHHuROD+zZLUDIZ4lLsZAoPin8r48xruLGCj1adf+kp+OP18a8rO/SwSYDcpGHBYkfr1YPRa42RpP34hw1ZEC4a61xh0Bng6ZjH4TQHTh0g1tDyb/EododAvV1+/kTZhFKvQ7TArgBnEP6YLG5QNlLsjqdGfb/OuAj7k51fB
 kRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 22:01:43 +0800 (CST) <xu.xin16@zte.com.cn> wrote:

> From: xu xin <xu.xin16@zte.com.cn>
> 
> Problem
> =======
> When available memory is extremely tight, causing KSM pages to be swapped
> out, or when there is significant memory fragmentation and THP triggers
> memory compaction, the system will invoke the rmap_walk_ksm function to
> perform reverse mapping. However, we observed that this function becomes
> particularly time-consuming when a large number of VMAs (e.g., 20,000)
> share the same anon_vma. Through debug trace analysis, we found that most
> of the latency occurs within anon_vma_interval_tree_foreach, leading to an
> excessively long hold time on the anon_vma lock (even reaching 500ms or
> more), which in turn causes upper-layer applications (waiting for the
> anon_vma lock) to be blocked for extended periods.
> 
> Root Reaon
> ==========
> Further investigation revealed that 99.9% of iterations inside the
> anon_vma_interval_tree_foreach loop are skipped due to the first check
> "if (addr < vma->vm_start || addr >= vma->vm_end)), indicating that a large
> number of loop iterations are ineffective. This inefficiency arises because
> the pgoff_start and pgoff_end parameters passed to
> anon_vma_interval_tree_foreach span the entire address space from 0 to
> ULONG_MAX, resulting in very poor loop efficiency.
> 
> Solution
> ========
> In fact, we can significantly improve performance by passing a more precise
> range based on the given addr. Since the original pages merged by KSM
> correspond to anonymous VMAs, the page offset can be calculated as
> pgoff = address >> PAGE_SHIFT. Therefore, we can optimize the call by
> defining:
> 
> 	pgoff_start = rmap_item->address >> PAGE_SHIFT;
> 	pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> 
> Performance
> ===========
> In our real embedded Linux environment, the measured metrcis were as follows:
> 
> 1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
> 2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
> 3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
>             and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
> 4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
>             in a loop of anon_vma_interval_tree_foreach.
> 
> The result is as follows:
> 
>                  Time_ms      Nr_iteration_total    Skip_addr_out_of_range   Skip_mm_mismatch
> Before patched:  228.65       22169                 22168                    0
> After pacthed:   0.396        3                     0                        2

Wow.  This was not the best code we've ever delivered.  It's really old
code - over a decade?  Your workload seems a reasonable one and I
wonder why it took so long to find this.

> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -3172,6 +3172,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  		struct anon_vma_chain *vmac;
>  		struct vm_area_struct *vma;
>  		unsigned long addr;
> +		pgoff_t pgoff_start, pgoff_end;
> 
>  		cond_resched();
>  		if (!anon_vma_trylock_read(anon_vma)) {
> @@ -3185,8 +3186,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
>  		/* Ignore the stable/unstable/sqnr flags */
>  		addr = rmap_item->address & PAGE_MASK;
> 
> +		pgoff_start = rmap_item->address >> PAGE_SHIFT;
> +		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
> +
>  		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
> -					       0, ULONG_MAX) {
> +					       pgoff_start, pgoff_end) {
> 
>  			cond_resched();
>  			vma = vmac->vma;

Thanks, I'll queue this for testing - hopefully somehugh will find time
to check the change.

