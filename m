Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 962A0C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 04:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1EC76B0092; Wed,  2 Sep 2026 00:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF77F6B0095; Wed,  2 Sep 2026 00:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 998F26B0096; Wed,  2 Sep 2026 00:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD106B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 00:06:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7FD2A074C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:06:53 +0000 (UTC)
X-FDA: 85167486306.29.5223638
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5457480007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:06:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZ1AADmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788322012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCDBGWhjOow6BVaXEWKL/bvhPOmCcwouuBw7qgvnDDI=;
	b=WkFQ7tIRJevVu330QTLMW5tAYJrbVTuaOoYBYmKRUh2JxY2nXh7PwYq14rtw6BAhRX3vCg
	HKR815v6C5UaLZHUuhLMzu1+EVjhZi6WhAO2AQoacFgKLFFAoaf4AbKfmpUk7WOdSqLs7z
	JfLmKt9iB4mlGh8PRG0ww7VRFdIyHMY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WZ1AADmm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788322012;
	b=L6z7UiTh8gDKOODIo+FFHIEQHDXH8m+8rQ2GDL1ku9wfMd263lwNncoXNh6gGXYJE4A1xY
	ZfVCW1DbtDzZRQtrNiXBFCO2X8zyH180S/nGevqo6ibE3WHy1FoZlKv192JjYTgDkp3vQx
	TTlHGGW5B+ltfJBn+KTvZT6HfsmJWhc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E3BD600C8;
	Wed,  2 Sep 2026 04:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27D81F000E9;
	Wed,  2 Sep 2026 04:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788322011;
	bh=rCDBGWhjOow6BVaXEWKL/bvhPOmCcwouuBw7qgvnDDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WZ1AADmmQSSKkceQoWmcRuNr2I+ritEKK0lzbaH2WL8WAtsQRXEA/HP/1V8mTLmA4
	 wY9glCWTT9p+9d5dc10HVqE3WbWRdPCriT4WIU46oMIVfv/hsHYGOuvvWH2Ehbzv2c
	 T4zotcImWkaRHriM4rztuOff+Szmh1twI+Xs3XaM4NC1Ja+1sU4PUEK3jPAdsMIU6+
	 vqlM/Sd/wF7jDMqQrJEDfPoVKoEB1IaamSynXftgSEe1Ax8mgFUblaS1Jckrt3Bvgw
	 KVq0umxJ5deFr4I8vpZCO83MgKUIYiqS7iVOqcvdZlC1UJag7Bb8sVJ2wUQISczts4
	 YnhepOW6Ry6yg==
From: SJ Park <sj@kernel.org>
To: Nathan Gao <zcgao@amazon.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	ryan.roberts@arm.com
Subject: Re: [PATCH v4] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Tue,  1 Sep 2026 21:06:42 -0700
Message-ID: <20260902040643.83720-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902031655.84721-1-zcgao@amazon.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5457480007
X-Stat-Signature: 61og8jczqu8adqqhtp539qn9tjo9dgp4
X-Rspam-User: 
X-HE-Tag: 1788322012-536759
X-HE-Meta: U2FsdGVkX19mZG/6ki5NLW0VHgETgSftgOKqpq53cLwtgf4SWDWTBeSl0PQ1Lu0wHin41xXe8G5H/Amze1ETWEYxvPXHluh9MFQ664SdFqVILdEBx1Gou6IFh1DqY72PDHtmpDhL1lxM/0I8AV6LPplsNp4ltXiLyOLCbZj3tGX1NEQqabMQozE/y5jhBJlfpghnVBoYjLtyOeVIbYb2MRrZQlFvZ+mFw+HNOgMaU7eSI2q84dBm4K6n4EMeSXHiqb2Ipe6sb8E8GhOJ6Mp3A0gsbbInHJheiNYiJiq+rXUOubQU8/66pzpcXu6k0vlWE2WX4AqZob+love5kP07g0XSbXpkA9nPHIcVimls6QUt/2s4eoM+I0uTo7Ev9GR5uXgZuiaoWhAwcdb+apwI1jwy0NDuQpTY3hkVlJGI2o+3e5Gm63DrPXeEnnoJz1vetVup0yaPjPEos4jBI5YawjBcVvdPRlODOLFGcxeWf2gNv45dxFqwhmlCJ1s8r2Z8LX8JTGxtiW4YCTM/NXTN7w9+fcW6wxLzRm/Ge9pzGFgnRM/P+1rjw17nqDrUMt9dtwjyfVYHg6vWy19jFdoAkTPahEVbwSU75iO4PRKcuPkyH5zMdnQcg+6BORwGHr9AkjF4b/6WdZIzEpV1SUScP7vEWshaUGalz4jyou5EoOjMJ9iknNd0AEFPaKUEG9hEHITJgmZsmkL9EPRJr9uAXLgnYY6StlRzPCTHFGKLm/x52xtOcV0+F4ml0stks/9JEDSVqVpu3xbvTqQi7F8dRxO1K0BclK7bNiaSgXuCLn88XJ3KxGVakMro4K+axr5LdC887ryY5V4amuUq85/3Wf/OLDKMPXKyBLqKRIFBlL/oAKQP+7uv7oPpMt/+Nx5ohW5zLpkL3/rNPKrq6Uis6zgnl4oU2pitsP9Ch1huAuLSKpHmbPfPvmEAo6gQ4WBPYXMkMPAwe01ZH02fSs6
 qarrtTdB
 eKqKuo22ZsRsJ1B1npBVqRFK5YWyq14qcUFyUmt1p8XF51P3IYDudUjmvb0z+E5PpMRv/hE+wc9YEN0XUqsxx8kFJHR1Ulmj7+K16QPYpVLRB3xwl0amPcyyMR9MfcUk+J+nddZm/DBsNHmLfuTD/GWlWBamefBWm2rrH176iMzSxWDkaN86JVtJRbBTfhkLiJ1Ku5Llec9mPX1dZw9Deq6m0bpM82x6i95Z59nOJrevOl+0t96Pw8e0pb3FyFcJSodv9Ds5SHg3XGHOhS8/oI1B8C/VEMqG+m1WKuzNyMuUmDGfp7Dx2gBvaSOU0seSJMGJ3tF+OszuphELB71sGn1fQTjJrLH8gn7Kf0UskYxMD4xsH2sQIEf2WBpzFGhopsP9+ZlpeFubuB94DfEh0hO3/MS075LVr1Ycb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 20:16:55 -0700 Nathan Gao <zcgao@amazon.com> wrote:

[...]
> Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
> c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
> DAMON test.
> 
> What the overrun does depends on the page that happens to follow the
> page table, so there is no single signature. If that page is read-only,
> the write faults in the sampling path itself:
> 
>   Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
>     FSC = 0x0f: level 3 permission fault
>     CM = 0, WnR = 1, TnD = 0, TagAccess = 0
>   CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
>   pc : contpte_test_and_clear_young_ptes+0x70/0xc0
>   lr : damon_ptep_mkold+0x1e8/0x1f8
>   Call trace:
>    contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
>    damon_mkold_pmd_entry+0x150/0x170
>    walk_pmd_range+0x110/0x2b0
>    walk_pud_range+0x10c/0x208
>    walk_pgd_range+0x134/0x258
>    __walk_page_range+0x98/0x1b0
>    walk_page_range_vma_unsafe+0x90/0x148
>    walk_page_range_vma+0x28/0x40
>    damon_va_walk_page_range+0x114/0x2b8
>    damon_va_prepare_access_checks+0xec/0x1a8
>    kdamond_fn+0x534/0x770
>    kthread+0x128/0x138
>    ret_from_fork+0x10/0x20
> 
> Otherwise the page is writable, the PTE_AF clearing succeeds silently
> and the damage only surfaces later, in whatever happened to own the
> page, so the backtrace is unrelated to DAMON and differs between runs.
> 
> Pass a page-aligned address to the ptep_test_and_clear_young() call in
> damon_ptep_mkold(), which is the only place DAMON can reach
> contpte_test_and_clear_young_ptes() from. Nothing else sees the aligned
> address, and r->sampling_addr itself is left as is, so the sampling and
> region bookkeeping semantics are unchanged.

Thank you for finding this nasty bug and sharing this great fix, Nathan.  Also
appreicate again for your revisioning efforts that accepted my humble and picky
revisioning requests.

> 
> Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Nathan Gao <zcgao@amazon.com>

Reviewed-by: SJ Park <sj@kernel.org>

> ---
> V3 -> V4:
> - Align only the address that is passed to ptep_test_and_clear_young(),
>   rather than @addr for the whole of damon_ptep_mkold(), so the
>   mmu_notifier_clear_young() call keeps seeing the sampled address (SJ)
> 
> V2 -> V3:
> - Move the alignment into damon_ptep_mkold(), instead of aligning in
>   damon_va_mkold() and damon_va_young().  The ptep_test_and_clear_young()
>   call in damon_ptep_mkold() is DAMON's only path to
>   contpte_test_and_clear_young_ptes(), so damon_ptep_mkold() is the
>   closest place in DAMON to the function that requires an aligned
>   address (SJ)
> 
> V1 -> V2:
> - Align inside damon_va_mkold() and damon_va_young() rather than aligning
>   r->sampling_addr itself, so that sub-page sampling addresses remain
>   possible for future non-PTE access check primitives (SJ)
> - Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
>   unaligned address was harmless before that commit (SJ)
> - Describe how the issue was noticed and what it does to the kernel (SJ)
> 
> v3: https://lore.kernel.org/all/20260901201001.33271-1-zcgao@amazon.com/
> v2: https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/
> v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/

FWIW, I insisted on this version to make clear the intention of this pin point
important fix.  I still believe this minimum and clear change is better as the
hotfix.

Meanwhile, to v3, Baolin mentioned it would be prefered to keep page alignment
from callers.  As I replied to the comment, that makes sense to me.  And it
seems some DAMON code has unnecessary unaligned address usages that could be
problem in future.  I will try to revisit such DAMON code and fix/improve as a
followup.  As a result, the resulting code might more look like v3 or v2.  If
you are interested, please feel free to send patches, too.

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~2 days?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

