Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753BCCD6E56
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 17:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64A906B0164; Sun, 31 May 2026 13:48:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FB796B0165; Sun, 31 May 2026 13:48:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 538AE6B0166; Sun, 31 May 2026 13:48:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42F806B0164
	for <linux-mm@kvack.org>; Sun, 31 May 2026 13:48:02 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F11DE1C0709
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:48:01 +0000 (UTC)
X-FDA: 84828448362.05.4ACB68E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F286140002
	for <linux-mm@kvack.org>; Sun, 31 May 2026 17:48:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iuDXv0f1;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780249680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SRhng7ZwRas2P1ADM7h74381kykfPa3pcL8IR8Sgsag=;
	b=mCDN4l95h0l2BqM7IFO78A200cA/xg/JHlKbBkpGJXfQkLSmKg2AIr10bnRtKYmkeGoyZz
	RdwNxI3YCMapR1WM0jPWwG30WGChqQo8MxyFUdQ11WXK6SObQdYQQ7yNKNzx2Sm446N7LB
	RZCk8nOAGxy0tloDhD2Lij+Ao/bOSnc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780249680; a=rsa-sha256;
	cv=none;
	b=n8YSDUpaaavWydmP9lTF2AXymMZJVWzODDSxI3QHhPYGCGLRI6gmHEhn9eHFWV4JcglpaJ
	VMoCkimtTXT54nZ3SdkwbCgn2560vhJiIFbLS4itcBvmknkmndDChYsU3gMn7i3d5voGRA
	l8fd4efIiR2jPDpPbxBKXqAQ6sxsicQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iuDXv0f1;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDA4D6008A;
	Sun, 31 May 2026 17:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA811F00893;
	Sun, 31 May 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780249679;
	bh=SRhng7ZwRas2P1ADM7h74381kykfPa3pcL8IR8Sgsag=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=iuDXv0f1iop3nim+N4Thcks0PngriNRgeVPiAgKtBxzypHnxoTMMjLjp/89E9JBRZ
	 J7oClLQY++qvZPFaL7cOm6gepiOYfT3domo4RNKpi6RmfTbt4FORCfaHxm2ETsL/xi
	 NqGfxszFTID7uGZw41CWjkVP7+KI1W5ueUQrg5fHeWOpaiKiMbpzVIWCNV/G3S/Kfz
	 uXzOBEF+equVHqy2k6NFGA1UG/FPQnRZteKEQgm4iUUEcJYruwNY4f+ZMsHxOi6u5J
	 GhlaseKU9FawVQ+Iy2xlZSW+1IvWgPYeLqfjhqyspX4s4XfERaakiGk82QYGyeXAx+
	 lTa3BvBR6Kovw==
Date: Sun, 31 May 2026 07:47:58 -1000
Message-ID: <8cc56c7a4aa29628b7d17d85be7eadb9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>, David Hildenbrand <david@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>, Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, Martin KaFai Lau <martin.lau@linux.dev>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev, bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
In-Reply-To: <ahnedQ33ZH8ogjbC@slm.duckdns.org>
References: <20260522172219.1423324-1-tj@kernel.org> <20260522172219.1423324-3-tj@kernel.org> <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org> <DIUMP21RASZI.2VNQV45RIL209@gmail.com> <3901fe0537edee9d7acdfd91695ead28@kernel.org> <CAADnVQJ+CqAszS2sSVu7gSfA_g4oaTR+SWmLNMX3_8c=OdR7NQ@mail.gmail.com> <ahnedQ33ZH8ogjbC@slm.duckdns.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F286140002
X-Stat-Signature: 9o84msmr9hs7633t1ukuh3hawht18qsp
X-Rspamd-Server: rspam06
X-HE-Tag: 1780249680-809507
X-HE-Meta: U2FsdGVkX18KpUrkOF6HH8oOhrwWmOTlnME4xltICWS0AGKl84FPAhYFXVgwKA5VnNEb+Tff2SDOYYla75ZYm/olrrAMcZ7lLUko9wKaXrrqHQQhR6lWkC0j9TDyqYtpr2W1thvDS3np7wyFvPmoni9h19abdO7IhZQzDPSwxrgITKXQauKE8BzeuBkm6iTn4VCsNK5TNKLE3BftjM+V/2Ix+RhHupj3cUYlUdR0DmKIGWZ+ioVe86uQEf53cEntiyNoZk+vAe7uPS7xKbpCCPbyuw9yshPN+INJ4JNdOreAs75JswLTBSFaZ5yHFH3TuycW/FsMLbRSYfS4w/NC6gYKX1SOngPKyZW5OoqGU/aZ/rix5pPkVlWfGef/MAwh+EJZAgrAi/wk+gmGNXMnXdb43jZc5V8yG4m0sSjatNKwSwXGh1b3TZezEJoV5E+2rycx/itM7SFqUgV4an+w1R0JYx80OgmVpH77LKQuaZvc0xc+yuMLaGBPR38eB9g1TWcr1a/iRLXQzj4RzZzTeCM1+K4D/poU3i728KgkM6J0VidbkdBqy2zh54sr1JycTpDA3g761H4UFlqfARC1BMAuVzrdHN0bnI9wwLNkcBFtxltEx3Lqs/XBSGJ5R/jVKNh9hDxCDvmtY0mencaLG/O6rXtyfD/9LCcWRO2PJgjvKkgeqHIi1ZonmB4MLgvdUp65m+K936Yl2aOZFynHsfFfcrJzcksx33xi7xRwbSPfEQg83Iye6xkwAo/4NCbVkmUa8/7MV9f6Q5/yLI8xPrXTTzbt+Ig7yJFl0mg46V/j4XtFPohtnW/vi38a1k/a5jJTW2HEQpmYK7Zl4B3FwKk3sKsyVDkHwt9NrcpQnCn+zvEIElL51hWC1cmoL+uUZhMzJ+DwNcVfyy4tZMa77YRiVdxR+8Q2FxxZeUDQxyUA/c/hpKVr5JYpB4OClpdyhrgecEa9r9v/A6wnuY8
 bUl6MzfF
 GBhiPgHLHRJ4l2TVQ6DiemAOSRxKasURSCEh/zbBB5mP/DeP1HYf0f5C7mUzIrF6NSz3yvK2W6abfXthZHtAbGYBK0n2d+hfAoDRL+GmKRz5xd1onjc5k4b6f0V07gtumApuq4h1EbOKovFiNG4V1JoKK1oH0sV7W3mMrJuXxX2HOKESlk7o4aVobmErhsxN2E+o7KJAMWxrU+TwVU+1SE50c7fQmiUla2370JeHXoPflx4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

I posted the check removal [1], and Sashiko's review flagged a
break-before-make problem with it [2] that I think is real.

The scratch page is a present PAGE_KERNEL mapping, so having
apply_range_set_cb() overwrite it via set_pte_at() during
bpf_arena_alloc_pages() is a valid->valid PFN change. I'm not familiar with
arm at all. David, my understanding is that's a break-before-make violation
on arm64, and that on any arch the stale TLB entry keeps resolving to the
shared scratch page until it's flushed, so a later access can hit scratch
instead of the new page. Is that what you were worried about?

So instead of just dropping the check, the install should route through an
invalid entry rather than overwrite in place:

	while (!ptep_try_set(pte, mk_pte(page, PAGE_KERNEL))) {
		old = ptep_get(pte);
		if (pte_none(old))
			continue;
		if (WARN_ON_ONCE(pte_page(old) != arena->scratch_page))
			return -EBUSY;
		ptep_get_and_clear(&init_mm, addr, pte);
		broke_scratch = true;
	}

ptep_try_set() only fills a none slot, so the slot goes scratch->none->page
and never valid->valid, and the loop copes with a concurrent fault
re-scratching it. This also closes the set_pte_at()-vs-ptep_try_set() race
I raised earlier, since both sides are now cmpxchg. A broken scratch entry
was live, so the caller flush_tlb_kernel_range()s those pages when
broke_scratch is set, like arena_free_pages() already does after clearing.

[1] https://lore.kernel.org/r/20260531165852.555930-1-tj@kernel.org
[2] https://lore.kernel.org/r/20260531170854.31EA51F00893@smtp.kernel.org

Thanks.
--
tejun

