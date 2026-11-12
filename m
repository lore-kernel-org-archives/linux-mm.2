Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E605160A5BDA
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 11:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Qc8cqb2R;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Qc8cqb2R
Received: by kanga.kvack.org (Postfix)
	id 1B3196B05B0; Thu, 12 Nov 2026 06:21:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18BC16B05B4; Thu, 12 Nov 2026 06:21:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A18A6B05C4; Thu, 12 Nov 2026 06:21:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DAA866B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:21:46 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5C59780524
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:46 +0000 (UTC)
X-FDA: 85426227012.19.40191FB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2E0D220006
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 11:21:44 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qc8cqb2R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qc8cqb2R;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794482504;
	b=UNfa+ZNW364Ho6+U3HX00fdI7nxmJc3v8clyUceQ0Jrr48um5HJLBAVP+ILXB0f3GXBoWt
	W9kn85g62kIBxRvtmybMd6NrXUv3akh4PDDGPhTLFhu3WbFllWmq5yj6wiQJBdj67n707E
	WWSYr62JGzXeg0QB8i7MtX9tWxkPg+M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794482504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b68hR85FMy64ZLKPI+SkETJKcoWTtrleDFFCwxd3C7E=;
	b=hMXe+onxYWWOsVV3uqrVhmSBGEp27u0FPugKb7sXgvtktAEBlRnfOLMFdR4FiwAtTguESZ
	wvON/P0Hf7YGUgBzgUAdhKHeFknqy8CpZaam9wBKkyph+nPRhOXn8yInrLALxjg8SGzsGa
	qLGIn70TwDnrzC5z7dnjYU84/8T/ryU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qc8cqb2R;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=f8PKmcO3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Qc8cqb2R;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 83E481F74D;
	Thu, 12 Nov 2026 11:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b68hR85FMy64ZLKPI+SkETJKcoWTtrleDFFCwxd3C7E=;
	b=f8PKmcO3THEm97E0clNHriq4Z64U95UVpQJKVzAHSFQsf2uA8U5cIRr+Kz2zuNFySoOqlP
	3/9gmJ7WZkgL7nmxglnkqVcbIcqwyepaDSFJL9+m2XXYD4mn0Yp/i1+4uEaZ+yUYK3bBAO
	Z/Zk+ThUwR6EC8Xo9kGfRh86noaXH6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b68hR85FMy64ZLKPI+SkETJKcoWTtrleDFFCwxd3C7E=;
	b=Qc8cqb2RCIXsDmnVlLXr1Rg/oe9HO72E9kGX41HXI6G+yK09O6MWVLkmK8wuduiymKcucb
	szOlGWoh9SGsTfDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794482502; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b68hR85FMy64ZLKPI+SkETJKcoWTtrleDFFCwxd3C7E=;
	b=f8PKmcO3THEm97E0clNHriq4Z64U95UVpQJKVzAHSFQsf2uA8U5cIRr+Kz2zuNFySoOqlP
	3/9gmJ7WZkgL7nmxglnkqVcbIcqwyepaDSFJL9+m2XXYD4mn0Yp/i1+4uEaZ+yUYK3bBAO
	Z/Zk+ThUwR6EC8Xo9kGfRh86noaXH6Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794482502;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=b68hR85FMy64ZLKPI+SkETJKcoWTtrleDFFCwxd3C7E=;
	b=Qc8cqb2RCIXsDmnVlLXr1Rg/oe9HO72E9kGX41HXI6G+yK09O6MWVLkmK8wuduiymKcucb
	szOlGWoh9SGsTfDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D635A134A0;
	Thu, 12 Nov 2026 11:21:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fxoaJEOh9WodfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Nov 2026 11:21:39 +0000
Date: Thu, 12 Nov 2026 11:21:38 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Jann Horn <jannh@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, Chris Mason <mason@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Mark Brown <broonie@kernel.org>, 
	"Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 01/13] mm/mmap: free gathered pages before MMF_OOM_SKIP
Message-ID: <avWgulaWoKBfIFlo@pedro-suse.tail5790ac.ts.net>
References: <20261111-mason-migrate-et-al-fixes-v1-0-3d2454362e8d@kernel.org>
 <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-mason-migrate-et-al-fixes-v1-1-3d2454362e8d@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 2E0D220006
X-Rspamd-Server: rspam12
X-Stat-Signature: kk8cx4zkyc9t41xkfik4kyrmq4ah6po5
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794482504-544038
X-HE-Meta: U2FsdGVkX1+Z9HhdFfmaUtzQu/YUxdeHl4TnvegNKcm8PNr2WTvrqwPcG+FIskU4jD4Bjucy13BEGUG0IvfErAJG1s9XlNgG23SbaG2rFzgFmL0JNcHseZQOH+l3jt9j8VfVhTR58sh2bMcRFWnrmmDxioDA/Id23rst3CY88FLCH7tYp0LVhPRtcXrWHRoTvrOkGNMQpbljcOFiQZQAFHji7YQQZk8JR+fF+nJ9aLVfihD4UfNx8wx/eWC2OqjwhhLdwoQHbIGc0sdbj1FvfNIHQVTNecgp0+/2GtB/Iw3JCh/3ke7vs2RRbnIWF+bIkz8YxqY056PF8/mp13zGxRvJiYxtBpMDPsmjXTBZuplU582L1ZSQR51+X+wV9YwhC9cAakT3Zs/QlMUa8HBP4CGr5wvTN6VFznJf/OHr5XEu/Bff0jNn6MEV+2M8F5jA5YwgoIFslGAm9GT139ZCgxvNw5EVu3DuKHNMbgUNs3IfWFHUXVlEVOi9l9HAYXpCdaiMSspMdQSW8jUX6P5d28ZOjPyqV9gXA7hjgnJGGO48ho0D8Y7xZj+ADS3lkXcrloSY4ekpQU/j+7Wv6AIWsf1Wyw4ej6OL4AgyDc006YVKrMOr5JLeE3Fmirt5/l9Ye7Tt/gWaFjXgqbPqs9OtvZBlAHEnD0VYsSQPXDxMENefzEdIeDzwVg0wEVC2Z11j/pVfaJstFGWgpvz3gaijaHFIlDsFVyPR7v2EGs/tRvisfEalylvrjHhwiO9jfkxdndLBaajTKZRnfk0tXY8uoL/cU2vlFgGAeq4pMOm6aPo7+S3WpPe9NDJVDtDfwJGMmljHGcG0Rrh0eUvuf9d55ULu+OWq64+yoXlaNl0OsiT0yRASvDyuuwz5cgQ35v9e/8pmAPQF7TYGY/eOsrU+1TmZ6SYQ+WLIrrX8DYEFOadn50f87je3S65ViUq4S57vqm/NlMZA2iJ+eZVf4HU
 lmKIDn1i
 aYoLFhu/zQnBm2w2FZMxs9YCx0owH68pDhFQalGwX8jBPmuJ8RUgs8VwndgSaXHmWqJ1yp5l5sGKP6UXQQl48MxOZYsL6PiFUjRQO0hXRmrNb1a4sCs334N/nF8SIk1bVFspjqqiBiVDVwH3g4sqAqEAHcBtG9fc6Gm22+1enouQ2RpDdO62rFLeeYzq065s8Aw0Cvouwmh20tsgKLlZmRwsinidDvtK8OrxqQRywDY7RrrXTu13jOO+qdYju2ovX/rhvONAqMnC3PqLnDckw6lBoI31M7T63GGOnC1R81RTHsTyxPlQkt/7uhSpwOjO/yttY+uMUdjmdbawYwAXsCTJqBNyim6PQC1e9EpVI6OGbypFQEIN/1VovoQpNEELPYAQaVM8mVzoEUSZ7COYLXdT3+9o3Sak2m3/cFuwDuRKeEYZgBQERoYtME/wJjblwh/RiHUEGb+jYQ/OWptBHbN8lDVnAx3iWigkZFc/ywmUcuxlUEruXG9m5TlPvIJCPAIe906FvwBJP9k3hrjJXkQemIcFFD6ClxkXaXxYz3YvQy4To8GY61slRpHHaYUGbGuAa/Lu5g75I+zRdgzz6o3awO0YC2Da+D4FH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 06:13:15PM +0000, Lorenzo Stoakes (ARM) wrote:
> The OOM killer can quickly trigger again after having selected a
> victim. That victim might not have freed its memory yet, but its mm will
> be marked MMF_OOM_SKIP by this point, so the OOM killer will ignore it.
> 
> This can cause the OOM killer to kill an innocent process when the first
> might have freed enough memory to relieve the memory pressure.
> 
> Fix the issue by freeing the memory before marking the mm MMF_OOM_SKIP.
> 
> Note that the task which calls mmput() might not be the victim - if it
> took a reference on the mm (e.g. ptrace), it may hold the last reference
> and release it when it calls mmput().
> 
> Therefore we cannot rely on current to tell whether the mm belongs to an
> OOM victim. Instead, partially revert commit b3541d912a84 ("mm: delete
> unused MMF_OOM_VICTIM flag") to reinstate MMF_OOM_VICTIM, which
> mark_oom_victim() sets on the victim's mm, and check that.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bf3980c85212 ("mm: drop oom code from exit_mmap")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Looks good, thank you!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  include/linux/mm_types.h | 2 ++
>  include/linux/oom.h      | 9 +++++++++
>  mm/mmap.c                | 9 ++++++++-
>  mm/oom_kill.c            | 4 +++-
>  4 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 1ed35d258d2e..09e63ff12b04 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -2030,6 +2030,8 @@ enum {
>  #define MMF_TOPDOWN		31	/* mm searches top down by default */
>  #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
>  
> +#define MMF_OOM_VICTIM		32	/* mm is the oom victim */
> +
>  #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
>  				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
>  				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index 00da05d227e6..a9390cb70541 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -76,6 +76,15 @@ static inline bool tsk_is_oom_victim(struct task_struct * tsk)
>  	return tsk->signal->oom_mm;
>  }
>  
> +/*
> + * Use this helper if tsk->mm != mm and the victim mm needs a special
> + * handling. This is guaranteed to stay true after once set.
> + */
> +static inline bool mm_is_oom_victim(struct mm_struct *mm)
> +{
> +	return mm_flags_test(MMF_OOM_VICTIM, mm);
> +}
> +
>  /*
>   * Checks whether a page fault on the given mm is still reliable.
>   * This is no longer true if the oom reaper started to reap the
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7618e72766a5..4cb18b217048 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1313,11 +1313,18 @@ void exit_mmap(struct mm_struct *mm)
>  	/* update_hiwater_rss(mm) here? but nobody should be looking */
>  	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
>  	unmap_vmas(&tlb, &unmap);
> +
> +	/*
> +	 * Free the memory before marking MMF_OOM_SKIP so a re-triggered OOM
> +	 * killer will only skip this mm if it's already freed all it can.
> +	 */
> +	if (mm_is_oom_victim(mm))
> +		tlb_flush_mmu(&tlb);

I see there's a different tlb_flush_mmu() call below (in the actual function).
Is tlb_flush_mmu() idempotent?

-- 
Pedro

