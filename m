Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DA52CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 856756B008A; Wed, 14 Oct 2026 10:08:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 807486B008C; Wed, 14 Oct 2026 10:08:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6976B0095; Wed, 14 Oct 2026 10:08:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38B586B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:08:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C08F91C356F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:08:30 +0000 (UTC)
X-FDA: 85321411980.17.7E2C7EA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id B937D40005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:08:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L9WkPNia;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H41ak4iP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L9WkPNia;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H41ak4iP;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791986908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSdF7ttMR37qeMo3vVxB7qidb08wbMcip4f6Hc1/wJY=;
	b=l8QMi08iTrB5r7bJaiKqCeQqBxGeaW7JCQRfKAVZi6AfJiFdxnE6a7hrhLGzm2+iss609e
	6v5oibWzgYfSSlFozbkuGxmQgwfiCv6fLyGpeuQgY+HDYADph+F4NmWZ8K2Q+s2hNj2aSN
	mtkHGu7eyT5ahaClY9AThRkXenFaGj0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L9WkPNia;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H41ak4iP;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L9WkPNia;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=H41ak4iP;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791986908;
	b=WrczVZYprh/TMnG2lKUV+bu4NLpTZKMtqAQ2U8mnkcH5gpKtqNcxuzZx2sH2TK2gvpwYf3
	/rdnkoLPc/cFUc+vQKny3LCn0UqTtjHIJe5JtI4rXyGBEqO69CKW3qrR5jDrZOAoLSKMCc
	VQMAawlp4EiLACg7rHCr4ob7sJZ7+9w=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6E04A21E96;
	Wed, 14 Oct 2026 14:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791986907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSdF7ttMR37qeMo3vVxB7qidb08wbMcip4f6Hc1/wJY=;
	b=L9WkPNia6Q3TcmwnQfHGhdvsDvTaKjOetO6Bql1fL7L0TTtb1f7IUiisKubGi0hX/59evJ
	2RFvdt9SDTsHiG+0lSVDw38cTucjUeI3tt061SHRjmhDgXH0YxDVfEjx/7Sxtf4plhNhN+
	EN9Tm7Th/bEf5BHL+VH2wum/w+jIZ5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791986907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSdF7ttMR37qeMo3vVxB7qidb08wbMcip4f6Hc1/wJY=;
	b=H41ak4iPkHuZjrFne99XIiCE1UeQY/aWRL2UXJsQ/QlpknmVLzqYsEuNxymC+ULMGD8f3V
	18B3UZ1h2vVPhmAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1791986907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSdF7ttMR37qeMo3vVxB7qidb08wbMcip4f6Hc1/wJY=;
	b=L9WkPNia6Q3TcmwnQfHGhdvsDvTaKjOetO6Bql1fL7L0TTtb1f7IUiisKubGi0hX/59evJ
	2RFvdt9SDTsHiG+0lSVDw38cTucjUeI3tt061SHRjmhDgXH0YxDVfEjx/7Sxtf4plhNhN+
	EN9Tm7Th/bEf5BHL+VH2wum/w+jIZ5I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1791986907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dSdF7ttMR37qeMo3vVxB7qidb08wbMcip4f6Hc1/wJY=;
	b=H41ak4iPkHuZjrFne99XIiCE1UeQY/aWRL2UXJsQ/QlpknmVLzqYsEuNxymC+ULMGD8f3V
	18B3UZ1h2vVPhmAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B3E38133F1;
	Wed, 14 Oct 2026 14:08:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BXI7INqMz2oUaAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 14 Oct 2026 14:08:26 +0000
Date: Wed, 14 Oct 2026 15:08:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/mlock: use a long for the page count in
 mlock_fixup()
Message-ID: <as-MrR-l80xoMnWE@pedro-suse.tail5790ac.ts.net>
References: <20261014131358.780240-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014131358.780240-1-nickolai@csail.mit.edu>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B937D40005
X-Rspam-User: 
X-Stat-Signature: iygxz363iodchs4dbnqsf7qtsj4erd3b
X-HE-Tag: 1791986908-136679
X-HE-Meta: U2FsdGVkX1/xyhv8PMZs3zC3ntekM6RyHNXLVgK8Wj9Zq9ZPWfgtMuJ0SAIlb88JFiQlbMfYkLG0lj0r0yeCq/94um5JTsDjnEdV9f6cVU8/tKrGcUUa7VhWUkQG3W/1QV634G9yE8UG9xHWDKPSqPZv+YSyvIlDzxfYFbLNfn2JAOhj+vt+N2IYf+Y0bNAwAH0WiqVdsq/M818y6hvHYGl/rTBTKu0Dn4xs4wPdOSnOyVHNgxe6vZRD8PwaifhRh2B41RocZNcg3I7o+UCdeaU7YgnYwBBygo+wic83FwNsbZfgc7mOuiEU74Zifw7x+ThwxSL302/bYRd0E6SLud8dRffxcdE3Z4Fnr9UTTt3vb1QQ1mY2zqriPEaDZgBtyFZelRL/dEXHl8TPe+GzzKhmbGPBtv2s5P7YFf0T0TJXYNMrXHjZr5B+iHSDe5/Nrm0rEyvW7U0BI1JTsAInSCFUii3B2hwY6iAPm4UPJcKWL+CIO5NzW5nF6B29tOSjo4Y5CKl0QquWB/sUPMxJtFPt8KY0of+5kJtooeVAGuzhWQsrCYq0nLX7c96XRJbuhne6fhcpCBWUtVHp2cub2DQaiRGktmzouYCVy+ZPrT/4wJz4ZzOO+u5AbefzEL6oU0zoY7CgEdY5A4HfjZ4r+L4jmE6WfLhclh6Z2W7fBTSJ0mdHpFkk0XRnd6ETfFho3KQkPa5hvfjiEiBBvIvL5NPLUTEb4wqPvO0mSuQW/3oc+uVNIHi+F9RxaoRt3ERd4ofcdiqf+ENLoGVDfDpTmM6SXUjvnP6Yht3d5b0c+Lfuf1RNKedOQGrxsNxdxWerSPs7o+byV20WobBKFzD0jucg1se5OMHlPdGGqBQKBQYKSxnTS4x2Y0nJS46kXECcOkRbqqYeBXRpsmG+pcdjR/07TcBDDurk75xqabvPVBZ/7ClgeaEevRC9zsuxO/4YxaXDX90ZCtwMwzk6SjC
 r6f0pNc0
 EIcM3x3gv2LKIQyG/6OtSoJJIVAjJZSwaQsW3HkGLOABts9dWAOe3p7oPdahMKie7NSZZUg9SygPpf2kWUEdxU+c+r+oN+J5zJuOcHhO2PWatN1UfDgJ7Ydc1gSFqqta9tChJNh9UugVVz8FR8vab8yPTjWQqTeIMvI3xTWy3ZpzgAgSdJ2ofqnbISzrh9IUeGVuWyJtoFDWIO+EiLk0j6YyYCE5qmgPr7UyK18GfQBX6/T44SY9f30tbRm2lNF7+BAvGVTiuMye1HHW++uq4ksQGPkS9TsrvDNTZzl9DLcdY6S4KSUegG8maVTTGEinbSovUVTiN6YPKo/N6ph4gaN9LFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 09:13:58AM -0400, Nickolai Zeldovich wrote:
> mlock_fixup() adjusts mm->locked_vm, an unsigned long, by the number of
> pages whose VM_LOCKED state it changes, but computes that number in an
> int:
> 
> 	int nr_pages;
> 	...
> 	nr_pages = (end - start) >> PAGE_SHIFT;
> 	...
> 	mm->locked_vm += nr_pages;
> 
> When a single VMA range of 2^31 pages (8 TiB with 4 KiB pages) or more
> is locked or unlocked, the count is truncated to 32 bits and then
> sign-extended, so locked_vm is changed by the wrong amount, while
> munmap(), mremap() and the other paths that maintain locked_vm use the
> full unsigned long page count.
> 
> Such a range is reachable on 64-bit architectures with a 47-bit or
> larger user address space (x86_64, arm64 with 48-bit VA, riscv64 Sv48)
> by a task with CAP_IPC_LOCK or a raised RLIMIT_MEMLOCK, which do_mlock()
> checks against the full untruncated length.  It costs nothing with
> MAP_NORESERVE and MLOCK_ONFAULT/MCL_ONFAULT, since then no page is
> populated.  On x86_64, after
> 
> 	p = mmap(NULL, 8UL << 40, PROT_READ | PROT_WRITE,
> 		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
> 	mlock2(p, 8UL << 40, MLOCK_ONFAULT);
> 
> VmLck in /proc/self/status reads 18446744065119617024 kB instead of
> 8589934592 kB; munmap() of the region then subtracts the true size and
> leaves VmLck at 18446744056529682432 kB instead of 0.  With 16 TiB,
> locked_vm is not changed at all, VmLck stays 0 kB, and after the task
> drops CAP_IPC_LOCK or lowers RLIMIT_MEMLOCK, mlock(), mmap(MAP_LOCKED)
> and the other mlock_future_ok() and account_locked_vm() users enforce
> RLIMIT_MEMLOCK against that count, so they let the task lock memory
> beyond its limit (or, in the 8 TiB case, refuse every further lock).
> The error persists for the life of the mm; unlocking the range in pieces
> skews it further.  The wrong count is per-mm accounting only: it does
> not change which pages are locked.
> 
> The int has been there since before git history (the variable was named
> "pages" until it was renamed in 2.6.28); every other updater of
> locked_vm uses an unsigned long or long count.  Make nr_pages a long,
> which holds the page count of any user range and its negation, so the
> existing sign handling is unchanged.
> 
> Found by formal verification of mm/mlock.c against the kernel binary.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

LGTM, thanks!

-- 
Pedro

