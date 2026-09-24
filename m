Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C56C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 16:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FC946B0088; Thu, 24 Sep 2026 12:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 386516B008A; Thu, 24 Sep 2026 12:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E736B008C; Thu, 24 Sep 2026 12:56:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE6C96B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 12:56:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B0761203B6
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:56:06 +0000 (UTC)
X-FDA: 85249258332.11.91600B4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 391E34000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:56:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ua3RJWou;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wm4A0Jau;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HaNflKyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E7ygGZZU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790268964;
	b=v/4V4gsyR3qnRdmXOySuhi/ncIv+q8MsXsVx48pI7cD2nL4ULRqHlcEqcZ7G3r7Rj5iCfq
	rrp3/45FhIzs1XWuNwyOvamgrmVLpfNCz1RvjN/7bcdHcEiuPvlRa9AQi0iS7hsNHMh7qw
	vBkb3bZvHzl1c1yd6qmoZxqTI3TUgXQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ua3RJWou;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wm4A0Jau;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HaNflKyO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=E7ygGZZU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790268964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7n45gBEqdK6VAZz1DfpvjOQS+V1wZqlT5J+u3UVYPhw=;
	b=PPkwp3PpFVAsY00NO4AXhK9hLLcOmxildE7+s2gpE8tOhYrY2R/0VMvsglp2YyWz1oeAMu
	76goKtCrIBSLIp8ujZ7PjrfM4EPKEu4EYSKqorEFRtaaO3DbdcjaWETqsZqFNjpj9e6j7E
	gum/Vq+8cx4DL1C7/0EgtIThyAjoZQA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7BA47200E3;
	Thu, 24 Sep 2026 16:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790268958; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n45gBEqdK6VAZz1DfpvjOQS+V1wZqlT5J+u3UVYPhw=;
	b=ua3RJWouCsLj2SI68B/ZFenE/7XzJtuAu9zZavGj8+EWsiDKp7bPzGgW5B1hAjGfXiBlH9
	Zd6NWv82M84r2Eeak564gbIxw4PXpp319BfBFgnGTvmeUE0RHPUhZosooPmk1iQQ++i+td
	Z/hBJVdwwALTPJiMwP4MSklkgS2yluI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790268958;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n45gBEqdK6VAZz1DfpvjOQS+V1wZqlT5J+u3UVYPhw=;
	b=wm4A0JautO6WnwDzSjpjcpwVYAVG2B6Qe9+EauDiGXjakBm/0qesXi4WA1GSiDzlPbLbpr
	PfFt2NByGzRscyCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790268954; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n45gBEqdK6VAZz1DfpvjOQS+V1wZqlT5J+u3UVYPhw=;
	b=HaNflKyOBM7aQfnGMbwbpLMYLgCnwhe5++bj1HJUo3xYl5WSEXlI2chPbZZX28eLBDO2Ms
	oE5/ZkluYbW5YzJmFmuR1Yy2F7vza+IJXJfvde/wlEVISybRpwQKq1LSR/Mps3idtVfCAc
	WXgct2PAO8Z3peXx4hJ/TJ5nx6d039g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790268954;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7n45gBEqdK6VAZz1DfpvjOQS+V1wZqlT5J+u3UVYPhw=;
	b=E7ygGZZUsLDUnBCtWigA3rxDWkjc2Kjm7CHD0No1Z4/Xp/qw9mgjO56m/FiIcSUH+eJ8hu
	9oGMuO4NpoSZOSBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F33E13354;
	Thu, 24 Sep 2026 16:55:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0mfIBxlWtWquNwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 24 Sep 2026 16:55:53 +0000
Date: Thu, 24 Sep 2026 17:55:51 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>, 
	Mike Rapoport <rppt@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, linux-mm@kvack.org, regressions@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: Drop the page allocation from
 pud_free_pmd_page()
Message-ID: <arVV9WLXQOwR8Hy8@pedro-suse.tail5790ac.ts.net>
References: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923223116.20090-1-mikhail.v.gavrilov@gmail.com>
X-Rspamd-Server: rspam06
X-Stat-Signature: 4hw4xi3z6xjfp3ybxh6i7hn4zz3zraqy
X-Rspam-User: 
X-Rspamd-Queue-Id: 391E34000B
X-HE-Tag: 1790268964-265388
X-HE-Meta: U2FsdGVkX19yXlvD6LCMNhrbTegJKLmaISFMdPsIze53se+E+RBGdXE4rNyn27skqnMvikhifIf4HseYRjX6DnaSMYfH+RFg1Jt+Fw1Q2UJX/05W8xPpim3/Y//ZsKA3FCMGsag2j3G08qAMiMi823KtWsL6PYZLhvihRprSly+MdW3qQk5wrWTCisTSQ5f0s89bGtc5D0SXrd4B6d9z0YS0dohuoCMrvhAmAaqnjMszxG59fnvqolyQ5DYewIjXXVqsH78b19dLh7IgVaXIGcPYvd6ySJ/Fv+yKfEYVt7ASr49TAZwDeuoEQY9/7DErvWBM8CqgCaMbUXjyWavx4RY5SBiRwlbaVOlDxShEIDXqAIKE460TeVOXWVdeNv7dB04rC5J7Pg3GR7/PxpJdPTcdv/UTgMtjKaSBjJE/dgUfVLS+CcCS+RdTIJkXBsb7lo3OVuWqv1RH6th9ZXChbEhTl6stHHdA/srzlVekeLv6914RzMCvq62+Cmr2uhNmrW0hZwDABscmKL78uOU/EYoD96J6OOIuQtgnB5vaxLtRBWOMeMEYOe23sgCEaw2OwXv7IPeYqUze6EhmpdC0+WNUny8kxalCUcl7L2WNmqA7lAp1cm5gEx7FoH4BoJoQmtZsqfRSgUR10eyh+w63ObTxdTnyefzpR0v9w2lH0cTZ5F8f5I4WS9PSpcfErsxPPhlD0mrzmTryltQFXrlQCSygXEUqIJJn7b/mz8eWWzl3XRS2nceGx9uJ6xmJKEKTGEafG3OCJqBV5KO+4musLvCWI7kr0J8ve+kBBMbxJyI675PpOjp0SKckfnK/gwcu8EZzT+Ads3grTjhlowpH0LtX5HB+gyYv5sdFD39fLU8hQMB8A7eukvjX8qsTSRbS2/lBJ664RRFEEFQ4AgLMErOHFRUTBmhgONAhyB4v0SV0jO17NtWxp4iu57nN0i6MrwAFSFmWh8iXmG5exzM
 PSn5yoTj
 anvnOhH4+aSPE5bKKRdE9dQiAMXe+p3EyDL2vvIQ92tYDCimTrzn96U/gvxxvDOlaS6e6QBlbLZIGKQx1RXTkcThA/YwX/jOrAu88wQ6MDDjY4jLucz+fb6sn/t6zrnWQVn8EQS1wkdW7hjglp0YhEFZ7vJeRWkHs+x1/dJevjM+duMyvgGg6INXNoU1GcA2WUntLEOz8u8JS2s/8J5flBl16zqD5ZOXwogcSr2an6Kxim2KgGEawtDMimLFOva3HkNSyAnBai28+dtFYun9FU4xp1vXg4ECf/LpSVLZWoKfGO6i7PgdMSZ5dr58td2kfrvh6dc6WQgVvXVSXVa//eF+BZSYNYjrAFzFu7n5WNwdq88KqANVSjYC7UiMk1s5dm36wgdDx+QfAVEMygYmLJJIlnfkMdCQ7MfwR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 03:31:16AM +0500, Mikhail Gavrilov wrote:
> On a box with a discrete GPU, lockdep reports a possible deadlock as soon
> as kswapd shrinks the TTM page pool:
> 
>   WARNING: possible circular locking dependency detected
>   7.3.0-rc3-f6e7b42bf05b+ #183 Tainted: G     U
>   ------------------------------------------------------
>   kswapd0/269 is trying to acquire lock:
>   ((init_mm).mmap_lock){++++}-{4:4}, at: change_page_attr_set_clr+0x29a/0x4a0
>   but task is already holding lock:
>   (pool_shrink_rwsem){.+.+}-{4:4}, at: ttm_pool_shrink+0xb2/0x330 [ttm]
>   Chain exists of:
>     (init_mm).mmap_lock --> fs_reclaim --> pool_shrink_rwsem
> 
> The cycle is built from three edges:
> 
>   1) pool_shrink_rwsem -> (init_mm).mmap_lock
> 
>      The TTM shrinker restores the caching attribute of every page it
>      frees, while holding pool_shrink_rwsem:
> 
>        ttm_pool_shrink()
>        -> ttm_pool_dispose_list()
>        -> ttm_pool_free_page()
>        -> set_pages_wb()
>        -> change_page_attr_set_clr()   [ init_mm mmap read lock ]
> 
>   2) fs_reclaim -> pool_shrink_rwsem
> 
>      The same shrinker, called from reclaim.
> 
>   3) (init_mm).mmap_lock -> fs_reclaim
> 
>      ioremap() installing a huge PUD mapping over an existing PMD table:
> 
>        ioremap_page_range()
>        -> vmap_range_noflush()
>        -> vmap_try_huge_pud()          [ init_mm mmap read lock ]
>        -> pud_free_pmd_page()
>        -> __get_free_page(GFP_KERNEL)  [ enters reclaim ]
> 
> Edge 3 is the one that should not exist.  Now that the attribute-change
> path takes the init_mm mmap lock, reclaim can acquire it, so the lock
> must not be held over an allocation which can enter reclaim.  CPA itself
> follows this rule: split_large_page() drops the lock around
> pagetable_alloc().  The huge vmap path, which has held the same lock
> since commit 26444eb71465
> ("mm/vmalloc: acquire init_mm lock on huge vmap to avoid ptdump UAF"),
> does not: pud_free_pmd_page() allocates a scratch page underneath it.
> 
> That page does not need to exist.  It only holds a copy of the PMD
> entries, so that they can be cleared before the PUD is.  But the PMD
> table itself is freed after pud_clear() and the flush, so the code
> already relies on the table being out of reach of the page walker at
> that point - and if it is safe to free it then, it is safe to read it
> then.  Nobody else writes to it either: vmap_try_huge_pud() only gets
> here for a range covering the whole PUD, and ptdump is kept out by the
> init_mm lock the caller holds.
> 
> So clear the PUD, flush, and free the PTE tables straight from the
> detached PMD table - the same order pmd_free_pte_page() uses one level
> down.  With no allocation left the cycle is gone, and so is the only way
> this function could fail.
> 
> The copy came with commit 5e0fb5df2ee8
> ("x86/mm: Add TLB purge to free pmd/pte page interfaces"), whose
> changelog explains the flush but not the copy; the allocation itself was
> already questioned in review back then [1].  The same lock cycle was
> also reported from the i915 shrinker, with &vm->mutex in place of
> pool_shrink_rwsem [2].
> 
> Fixes: d5d8b8662e6e ("x86/mm/pat: Acquire init_mm read lock on attribute changes to avoid UAF")
> Suggested-by: Pedro Falcato <pfalcato@suse.de>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks for the fix!

-- 
Pedro

