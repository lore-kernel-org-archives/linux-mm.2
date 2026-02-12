Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2476EE3690
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D491F6B0005; Thu, 12 Feb 2026 09:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27A06B0089; Thu, 12 Feb 2026 09:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C343E6B008A; Thu, 12 Feb 2026 09:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B2F116B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:38:28 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EBA41B08A3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:38:28 +0000 (UTC)
X-FDA: 84436060296.02.59B0C27
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1283F8000F
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:38:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mC359Kfl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=97qx0vHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mC359Kfl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=97qx0vHp;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7uDhaRO4oEHg/T49tFFB/x95ODaieXVvFOfUWumOZbw=;
	b=U2DyHejuBNg5dY7KbZsDoZ4hNYSEVW80X1lOIO2SujZ47/zdR1J+0EtqMBJpmNCYaQcnTh
	wMwaXs/BsWQkJCLFno5D+BCMZTry1ZDj8yL2ENAvh0q6zjZYUDiX7iE0NNHkhFEott06A2
	GaLKoaYOQ1U1ty9CwmXytMjSse4OMdw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mC359Kfl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=97qx0vHp;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mC359Kfl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=97qx0vHp;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907106; a=rsa-sha256;
	cv=none;
	b=Z4k9ddKWZIPcJ/XK8HLKw4ceQKiEKXBMpgpG29nsNEJSOt5YUVbzA/VGrISyMWE/Kd52py
	UdcGgxoYPFwRjIsELUw5eWewCqTX74+NCFofOln8Q+OIy80sWYfnFt5KU3UjA2PD7VlCoV
	Hfu8t/jnf1r8AqLdk1+HWVl/Zf9+st4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9F1533E6DC;
	Thu, 12 Feb 2026 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7uDhaRO4oEHg/T49tFFB/x95ODaieXVvFOfUWumOZbw=;
	b=mC359KfltbMvc9WmPjvE+steespHWVvPWTi4E3qUU1TEPXaw+wM8l1UC+Y1gaN2LOSAkok
	+YwH725Ye+IQk8YaW2zMncMmRD7t6MimsKRNPI7MYbHRnfCIvt+Y3yUOQVMH2r4AxZE2xD
	jQ125vgulxYoaq+AACrNjVUkSqVFh0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7uDhaRO4oEHg/T49tFFB/x95ODaieXVvFOfUWumOZbw=;
	b=97qx0vHphksQAWDm5t0IV+7AjzEYJiHsUT6bAEWDCxqkPnsOn9TFlXFEVHl+mGbxTE/HWP
	Q+e8d/bK9or/c5CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907104; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7uDhaRO4oEHg/T49tFFB/x95ODaieXVvFOfUWumOZbw=;
	b=mC359KfltbMvc9WmPjvE+steespHWVvPWTi4E3qUU1TEPXaw+wM8l1UC+Y1gaN2LOSAkok
	+YwH725Ye+IQk8YaW2zMncMmRD7t6MimsKRNPI7MYbHRnfCIvt+Y3yUOQVMH2r4AxZE2xD
	jQ125vgulxYoaq+AACrNjVUkSqVFh0M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907104;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7uDhaRO4oEHg/T49tFFB/x95ODaieXVvFOfUWumOZbw=;
	b=97qx0vHphksQAWDm5t0IV+7AjzEYJiHsUT6bAEWDCxqkPnsOn9TFlXFEVHl+mGbxTE/HWP
	Q+e8d/bK9or/c5CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B13A3EA62;
	Thu, 12 Feb 2026 14:38:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hTL1Dt3ljWnNWgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Feb 2026 14:38:21 +0000
Date: Thu, 12 Feb 2026 14:38:19 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, 
	shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 1/5] mm: consolidate anonymous folio PTE
 mapping into helpers
Message-ID: <b27vb7b4ntj2xagzbdnvt5p4snh7c36mwmaosvat6lztj5cywn@ppnq2i4akaxu>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-2-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212021835.17755-2-npache@redhat.com>
X-Stat-Signature: 3aufm1syztgaw5jbuiku3qqq6rckgef8
X-Rspamd-Queue-Id: 1283F8000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770907105-511994
X-HE-Meta: U2FsdGVkX19a4zGPjH9bVfoLxsgEXSC3gjRTVJh/FqSYJYs1Hta1k7QKZvtGZ9SzCnVj4NNgzaO5D3cEMR7Y6ZlGv57nfk1qcZwuWxZlleSIJW/hgXseDzezp9NFJCfO4Cgk/M6Zlj70fMFHNpfFAl35NFI0iUjzmEvjHHSPI8HNwwle06ERiugcRFVK+LGLGhwEULkM1cP1Mde8mK8bUfX3H1md92KI8Lq8sZ6+eEeDcVYUgz/QOfsWZ6UxS+o4FBDf+ZrMw50JhzPApiJxcI6Yb5qkMaZO3A6qCwKbMu5JvzuGwVrzaDXiWkHJZmgYJmfykCFzYYqxmEEqeiVcsJ2M+YPhhxbXYRR7umkUuP4WaK6Ci0YwKAu9ujfaIQZgXA/X68kCoDLnG0q2Ad0SsGLCC3QJAy8mr8Ovj73TADsqCguKmhAHzechjT/fDSoYHNhOAAAYZ5R0lwgJ9UlYVnLMCCqdQIy+JB84mACnNRCupr238wGq+J7BM6uC3L7utU/Ysx45CYYrE6nmkSnRYAQpsjI9al93gfXA9Sdoc1O+iIMCCvUR2POLpGVX1TFkjQIrGWax3Ll7/oQn4AkFtkmqmjYAffi0ciBzj1iLTiOURMu69Tx9q/O1EHOMJHmM5CHiCl/iswklXlUy/iW88XzEcSWD/D9mY+43JXXxP95sHFU6UBq2+JuUlLDAZYl+PGbchhsV78paiIEpl9pPZStcp9d7KtKWFriqZVAlv2Sf3otB7XvpgSVjYdwZhgWaixbgTlMatxixFPZjmSHQ410Al3i9j84Pvq8PsUku3UfStLYa/lviFRsg/9MuwK1vyGRwpvWJPagB1IjiAu4maqAGgT2JZGQ9JQxTzaX4H2YM0syNgfZTcyNhLADnFhJQb88uftUbVqBLD66lXXWotdt5W9xUBXdqSTxdGjMNyiMdZ6fZk9GCesjbNVEyLwM1BuTKxR0KaCwIXpDm9x1
 NPVe0Tu4
 EBjCgswMv5Tu4j0FVx9n/wSjzaHiIkR4039wiECFd2wq3sLa3sPv4hd+rZdpNv81yPgyVEd527dzqbDBL//uXU5iRQLtjXzfE5jJvQDYpJmsGRXro3iWW0+ykdCc7t27ET03xYTb5R+Q8QLK7rHYCXFg3Sy2PblROBG+1R5CaOHQL+pgGeYoqwk8xD5Fp4zpAMhl7sXeBgomq+ODQBjIXJoxPLuqca3GGOzsHPVum82S9eHsIOqNIvuaRvBFdIkGT3Yz8nyLNw4ZiutVbK5Ywfz9ngHMUxz6FcxGFHuf0eaqdKHngvlZbw6Ru+MZkFGlTa663ZjHwKPPJqUGMMCdDve7Ag8FGEZ1JgmhX+RriE1jgByisrDzrTiaiIkOawTLXEq3QeEweJWPikxU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:18:31PM -0700, Nico Pache wrote:
> The anonymous page fault handler in do_anonymous_page() open-codes the
> sequence to map a newly allocated anonymous folio at the PTE level:
> 	- construct the PTE entry
> 	- add rmap
> 	- add to LRU
> 	- set the PTEs
> 	- update the MMU cache.
> 
> Introduce a two helpers to consolidate this duplicated logic, mirroring the
> existing map_anon_folio_pmd_nopf() pattern for PMD-level mappings:
> 
> 	map_anon_folio_pte_nopf(): constructs the PTE entry, takes folio
> 	references, adds anon rmap and LRU. This function also handles the
> 	uffd_wp that can occur in the pf variant.
> 
> 	map_anon_folio_pte_pf(): extends the nopf variant to handle MM_ANONPAGES
> 	counter updates, and mTHP fault allocation statistics for the page fault
> 	path.
> 
> The zero-page read path in do_anonymous_page() is also untangled from the
> shared setpte label, since it does not allocate a folio and should not
> share the same mapping sequence as the write path. Make nr_pages = 1
> rather than relying on the variable. This makes it more clear that we
> are operating on the zero page only.
> 
> This refactoring will also help reduce code duplication between mm/memory.c
> and mm/khugepaged.c, and provides a clean API for PTE-level anonymous folio
> mapping that can be reused by future callers.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

Looks a little nicer, thanks :)

-- 
Pedro

