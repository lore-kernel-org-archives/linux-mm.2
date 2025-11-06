Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92ED5CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 14:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2E008E001A; Thu,  6 Nov 2025 09:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F054E8E0002; Thu,  6 Nov 2025 09:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B538E001A; Thu,  6 Nov 2025 09:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D125E8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 09:28:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B28E52538
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:28:03 +0000 (UTC)
X-FDA: 84080411646.16.E68FDF1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1FA4018001D
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:28:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xGxtWHQ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D0OaQQNg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xGxtWHQ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D0OaQQNg;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762439281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AuuUdnWkxyCHK93yhogM0GpeOIixS0TwW2AXgBsT1zU=;
	b=y+c3PlVtlIpIvMyUCx11bxvWqkxVAEcYGAbFcN1lMt04OKVML+Ro+oaCVAkhtOE7EzCXGc
	lIwZLBWwBftbehu2wItNqKKx3ZRCnkgnujqpZdWeCneypoeasLoyIes3kSlYqMs2kURco4
	hN7A2qqNuxHBa2AG5YEZFp/I2ozV1mI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xGxtWHQ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D0OaQQNg;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xGxtWHQ2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=D0OaQQNg;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762439281; a=rsa-sha256;
	cv=none;
	b=XwTgPWt76Vhmyd5RbV5n1Qx0wRSCij0R6P5nPWokmnf812roT9NLvV7SpcabyVpfQ3ULEt
	ZbU0k3+VRlDbYwT7s4zi6cdvbi3l72f2W6F4buUSLSfSL5HvO96eqtgyVBeqCfztFul9rX
	siiFJ3SluPN7EA2ftO3bw5YVZ0O+sJ4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D94D211FA;
	Thu,  6 Nov 2025 14:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762439279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuuUdnWkxyCHK93yhogM0GpeOIixS0TwW2AXgBsT1zU=;
	b=xGxtWHQ2uld6xSLMvFvEFTNRtGmbFTMDR/KhcZ9qZDr1mc8KvPcrTDk+GRTNohsm7UXX/0
	YaA4GOzFlmslU95Kd+zOAKXA+ih6Hi7LcFx8oaTxoQ0TzbzvlrneHF0JWXbVYttyaU0ozB
	qCeKTANYWIxZ278NEITvmfyADVdY5Uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762439279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuuUdnWkxyCHK93yhogM0GpeOIixS0TwW2AXgBsT1zU=;
	b=D0OaQQNgQZcmZpSNShYML4vLRxJdK8LQSYg3Qw52p082UUP7rVVlVjMejAyNWlZrAcblz7
	sKc8jk20pNLiL/CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1762439279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuuUdnWkxyCHK93yhogM0GpeOIixS0TwW2AXgBsT1zU=;
	b=xGxtWHQ2uld6xSLMvFvEFTNRtGmbFTMDR/KhcZ9qZDr1mc8KvPcrTDk+GRTNohsm7UXX/0
	YaA4GOzFlmslU95Kd+zOAKXA+ih6Hi7LcFx8oaTxoQ0TzbzvlrneHF0JWXbVYttyaU0ozB
	qCeKTANYWIxZ278NEITvmfyADVdY5Uc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1762439279;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AuuUdnWkxyCHK93yhogM0GpeOIixS0TwW2AXgBsT1zU=;
	b=D0OaQQNgQZcmZpSNShYML4vLRxJdK8LQSYg3Qw52p082UUP7rVVlVjMejAyNWlZrAcblz7
	sKc8jk20pNLiL/CA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38E6513A31;
	Thu,  6 Nov 2025 14:27:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1yZSCm6wDGlERQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 06 Nov 2025 14:27:58 +0000
Date: Thu, 6 Nov 2025 14:27:56 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Message-ID: <yja2mhwa4bzatbthjjq5rolqlkfgcbmppic3caaiwi6jc63rbc@cims6rqnotvj>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1FA4018001D
X-Stat-Signature: hzaqrwj45zxcwuo3dputms48w8ezihtc
X-Rspam-User: 
X-HE-Tag: 1762439280-677946
X-HE-Meta: U2FsdGVkX1//VGQVMnQ1kcnqlfHbTma0nps86hfjmlTftk2kkFadyRnndLPtpCMNSjod3R9QE3A1zSr4xOOaCu3B8Xui9xnfcroYahZ0ugiBQz4nW8zH4RLP8o+tVOGWuOq5ajdfECS5NO6umvlzpSzpQvg4EES8q7fM1lN+R4EW6hChUpWCWXBgQ7tGjtzDbWK4r94gbTv958kK+42v9ExP1oFMLz1tlscooO5bvTgkwYege/SecBwtvLx7j2+A3luirZroffVQualwm5qS1AyTiuBXCZES/LbIAIdyKptEIyoDBjrfHQT29QW8eDscB8POIcTzCzXXOoKcR9EUB7iZzCLNrTvx9+IUREk3svIBhXbhLkh+Uhv4xo/Z+7tjILcbw9ZqrO5t2s55DJMGpwI10Y6G3zMxgzMRXDYoa3T8LuN6nO2iH8HTHA9CRZ1XTAr+Pj6nT0tlTTMjeREGJeBbeQxy4ySw9yFTPhrRfNtO5NYHcRbVuy4XpG8SuYxSeiJL6B79OqvW3CiSy/dtPz/zQnVUGxYYyb57cuAxSQEDkLnLL/jKs5VBKDSXHd85X8pYvpA5YFIkOoSzfxvrH6XIqakbxS/TmYMci3TbskdaGkmd6U+zz4Ovt8pD0DZ0qlfNT/V+0XKRaURunTBvCbClogHH6HGEkwOTi3wap74P+r+fTj5Q+X3qlDiBui73mz6ta1ObCwScipmc0ihmTsyBGf6EjZaMMpZGsuQlRjZZlnwuIDxWIBjzKlDWDmjsIKjhLgan5n3Z4RlOF7rIJliRBj2vOhEfaUdUKiHtcpcKVBiNGu9/ho9p+jh7slYKwgUlN38S/ykDTJVBGtKN7KZbPDCKXtuRrsdZPipYyjjepGKSxLABv49o38WFTYfGrE2+ExIs8sezp0gJ/Uqt9CzsaMizpY1YLvDOGlEljvl1K1iJ6KzN1dWZ9dTFAigmsyB+ubBHFVbBAdGG0N5
 dK1ytdBF
 Pd5gXaVf3SHElSwK57ImlpMBhfeulKah82lTpFZrNoQrQMyA4GyHheEDyI0cL52CFxpNeVCAwobuK7K5W037vJv7oDq2kHMs6Y5FIL5Yy/emdVzcMq1y81YSoNOM5jsbbG8/iSokSu6bIHdU7CB51H8ZpRs+/ZXn2IVj5599e3fYN5xX8UMFoOGZG7inBrX6P4r+gkREXoISaq80iKtvAbW09Q+1tE7YkyCNupeRr+bl5EFbs/CPXAD96gPkUELKWjTdmdXSZpga7Blb8vu37DXrLiheXimA9l+6LCVtW+Vy2HpghIVhH88aQByitPYTZvZewnY6bLm4kaQGRdOpQ6gdE0iZmvZ520CXxQrbElLmdZ4wd865SlNy5s4i52n7HEVLkSMKzYtvJvqw/eP0rWpyMupgwHxs5BBdE8EB9BI92eHI1VPBTlA2gDBt04DBZiLJo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 10:46:12AM +0000, Lorenzo Stoakes wrote:
> Currently, if a user needs to determine if guard regions are present in a
> range, they have to scan all VMAs (or have knowledge of which ones might
> have guard regions).
> 
> Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> operation at a virtual address level.
> 
> This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> that guard regions exist in ranges.
> 
> This patch remedies the situation by establishing a new VMA flag,
> VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> uncertain because we cannot reasonably determine whether a
> MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> additionally VMAs may change across merge/split).
> 
> We utilise 0x800 for this flag which makes it available to 32-bit
> architectures also, a flag that was previously used by VM_DENYWRITE, which
> was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> bee reused yet.
> 
> We also update the smaps logic and documentation to identify these VMAs.
> 
> Another major use of this functionality is that we can use it to identify
> that we ought to copy page tables on fork.
> 
> We do not actually implement usage of this flag in mm/madvise.c yet as we
> need to allow some VMA flags to be applied atomically under mmap/VMA read
> lock in order to avoid the need to acquire a write lock for this purpose.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  Documentation/filesystems/proc.rst | 1 +
>  fs/proc/task_mmu.c                 | 1 +
>  include/linux/mm.h                 | 3 +++
>  include/trace/events/mmflags.h     | 1 +
>  mm/memory.c                        | 4 ++++
>  tools/testing/vma/vma_internal.h   | 3 +++
>  6 files changed, 13 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 0b86a8022fa1..b8a423ca590a 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -591,6 +591,7 @@ encoded manner. The codes are the following:
>      sl    sealed
>      lf    lock on fault pages
>      dp    always lazily freeable mapping
> +    gu    maybe contains guard regions (if not set, definitely doesn't)
>      ==    =======================================

The nittiest
of nits:     =============================================================


>  
>  Note that there is no guarantee that every flag and associated mnemonic will
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 8a9894aefbca..a420dcf9ffbb 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1147,6 +1147,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  		[ilog2(VM_MAYSHARE)]	= "ms",
>  		[ilog2(VM_GROWSDOWN)]	= "gd",
>  		[ilog2(VM_PFNMAP)]	= "pf",
> +		[ilog2(VM_MAYBE_GUARD)]	= "gu",
>  		[ilog2(VM_LOCKED)]	= "lo",
>  		[ilog2(VM_IO)]		= "io",
>  		[ilog2(VM_SEQ_READ)]	= "sr",
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6e5ca5287e21..2a5516bff75a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -271,6 +271,8 @@ extern struct rw_semaphore nommu_region_sem;
>  extern unsigned int kobjsize(const void *objp);
>  #endif
>  
> +#define VM_MAYBE_GUARD_BIT 11
> +
>  /*
>   * vm_flags in vm_area_struct, see mm_types.h.
>   * When changing, update also include/trace/events/mmflags.h
> @@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
>  #define VM_UFFD_MISSING	0
>  #endif /* CONFIG_MMU */
>  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> +#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */

Don't we also need an adjustment on the rust side for this BIT()? Like we
for f04aad36a07c ("mm/ksm: fix flag-dropping behavior in ksm_madvise").

In any case:
Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

