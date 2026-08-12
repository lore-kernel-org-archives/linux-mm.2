Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F075C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 11:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FF006B00D7; Wed, 12 Aug 2026 07:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 188AA6B00DA; Wed, 12 Aug 2026 07:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 050586B00DB; Wed, 12 Aug 2026 07:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CCDC96B00D7
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:46:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6256FA01AE
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:46:25 +0000 (UTC)
X-FDA: 85092439530.07.FCFA696
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55C5C120002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 11:46:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMsqib6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MR7iuXqS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=orB4stpy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zZDwUFpd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786535183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fUx2zvms+OpIRDy5HIRpqYJ3/My2Mv1XMvMmiX+J8I=;
	b=2VRoBZHUqzTfWDCpJskg5t7DNJJTIhWDBptDntAZR+dhWSXlgcpDPldnaiq8WCF8A8ce4f
	m8EK95/PTZMgF3BkfA/Nas9W57U83EDowiD8Aoj222bIeQmKyNLmAxLva7VSjKJj35Ul7k
	KH2KCVzuRJNrPszGbMcxSBxk4vqIPhA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tMsqib6R;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=MR7iuXqS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=orB4stpy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zZDwUFpd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786535183;
	b=Ei9Rbio0GJg43WQlLg+lPu3+bseIS9N8/doQvX7kBb/fR+QRrlGC/3hVb4ODnU/QhQWKG+
	eQN0aoD6JTpIG9A6XLF7Kfag33pxM4ARQNDIt+a9aRBip5Cx6WhIpO1E9qZ35SMMFTCGxy
	d79KBEK/993E9VffK9WY3buGqCxLhxY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C2AB6822AA;
	Wed, 12 Aug 2026 11:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786535177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUx2zvms+OpIRDy5HIRpqYJ3/My2Mv1XMvMmiX+J8I=;
	b=tMsqib6RmoZkk3Fm5B6AWIjHa2Lx4UAbKi9bqOwW3em+d7uQzskBRRF7xJmcrzoTohmJ2i
	vYV5W+rdTLQiGFfAh2xfL+K7Rd8CMQzunmafGerid9n2j9YtJACRVhx1Ox+V9I62wQs3Wq
	3WjflYLgf7UWffEW+qFKh7cbDgk9mAE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786535177;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUx2zvms+OpIRDy5HIRpqYJ3/My2Mv1XMvMmiX+J8I=;
	b=MR7iuXqSIJQx5/oXWxV/aQyZ4sIKS0CcvvPPi1W1rRK+QPBzWFwhz5H5Tzfdcy5a9UzaUs
	bwygh7ZbUl52ZcAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786535173; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUx2zvms+OpIRDy5HIRpqYJ3/My2Mv1XMvMmiX+J8I=;
	b=orB4stpyATSV447DU1enA22k6eamKgRKWo3oEis/EYYmK09OYTpIbQsY/tujfroUbrTdeu
	AJ5MQGm9/FySDKpoPfNRqOPD+ARqds/vsZRjWdjhPZ3geJCLynA5w5LpCHvCYvR3Bh8hyg
	wk84DwKSsTlk+5bpAOxUU7aykEyPC5g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786535173;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4fUx2zvms+OpIRDy5HIRpqYJ3/My2Mv1XMvMmiX+J8I=;
	b=zZDwUFpdaA1fbsWbteSSpBGfBMJoLQfE1xJTR4iZeLzXl18VgvoX6e9qkpAzLkLZgFmosT
	FAk1fpkzfEnhJCCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B1360779B1;
	Wed, 12 Aug 2026 11:46:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i/LyJwNdfGoXfwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 11:46:11 +0000
Date: Wed, 12 Aug 2026 12:46:09 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Steffen Dirkwinkel <lists@steffen.cc>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "Denis V. Lunev" <den@openvz.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, David CARLIER <devnexen@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
	Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anxbSdxDlyq__-T1@pedro-suse.lan>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
 <anCK3eWFMwZqq5ka@pedro-suse>
 <anXvODEvV4f_Taj7@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anXvODEvV4f_Taj7@lucifer>
X-Stat-Signature: 4wdfho11axynjy8tm1g6m514raprt6py
X-Rspamd-Queue-Id: 55C5C120002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786535183-151378
X-HE-Meta: U2FsdGVkX1/kQtJHYCwPK6qqQ7J1THkG9dHt3qsd/8ZWHOrqILg8nEM/T30iSCcpmldLR673EXn/nAczToEJcqo+3kGTDhSS1bi1MMp697K0M4gjnGKOuwbVcl305ss9of6y1hocXoYfvf0mdGlYOra7tlbn8kZ9qg3ftgDsBlgIAyXCVCNQM3pLaiJdZRGyqE73HGhR/RtOOTxCyfviGVwQDNJ7ODit3zcXU56SeyvnE37scPhyw5BTaQBMo99u9aG/KAPeKtHj7XHQvywqOWW0iJ7Fs10Wr8k1molsoD0dwAFMJEAV3Asdriq9pSYDjyAtm0EW7jLcNUotetZpQABKu4PRvR2LZkCZswNb50WPOgxx/4g6II3uE2/+fOBRfYeoQM6lwu80fVlZMJw1w1l7zPuo8Tly1Pd3a8Lf9YAaHGrLEIA9GoVDUycwLdLsd5XEOCGCQXcOvHuHjxARTxcrkRyMFSJpAr1sfnNAosZml9pm+dX5tveKVEmpLDg6N/tNkrRvzlpjJ2EV15FiPwDS01PyU6KUVHXPJhY1FZnmLj7lcMfvivuJT4dAQojiYl0dYROXLRIHymoxFc2EreXvkDtpAp4ZizkL6MeS3bz0eXIgUiEUXNVv41jMU0SUti/SOpOmL91ashobLVm+hVW5MZ3Fsb//dQj7m3Lxh6D8zd521IAPfnDVtT0zeD2Wsf5PRYkgT5SOoZ/eI0byNbaKrbkS6eFvUdo2wOolyAVa6EljVSOfE2Rxi9GDZAcBotAG3Rty/GQY5zoO58KghGzSRZit/459Olnympkb01N0UkPFvylLYUK3O1TTZ8VxMWc4lMsyHBu+EqPsMabUuX8zmv1HTyRiSdcyVr1gdQ8aWJN4o9cfQ5OGwlNlgIJ5od7m1YX9Me0VN47A/kZix6KlAoujHjPA+oKIbrzxLsQg9IZC3RJnZZmeyK9kZaZ0RDNgil/ixsCrEPJM9XG
 hkJ8Z7Hq
 h9y2avnG5gwR83bsgZAWlH2Xddv6oewIrcPI7dwYbYUl5Pjjv+XN+G9V77Fkm1uhRcRWOx21tatOl1qCQDPOUd6Gd0L5iINL955VDiBNAnAPdtMfiJ0xKLRWkxvloPzluDQyGWxZG1a2IfTPezusaEshHr+fVpjLKFjSOlRZFilMREkdgQ3HUo2g/GenzaUJMe5yL6BPYq3jvTpn3mSVylV/Y3SzsyNdOtnRXUv1FFVRcGWS3+zEYymvV3AI8T+x+ryHJJwu0OqZEG1jiqzDMrkTpKpHQq4e07Uw5REyZkHu76s77ePk9eRFWaxf9TwEFA9dzcfvTHibX5x00dO1EamJBBsxynyTPBwMK/8AUOCxDgxmQ/Uq1SmBttHmfjaa4m3WB/NKjcHWtJc+g/Vl5JlOHvCpRmJjh7Byx4rJu/gKnZBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 04:36:08PM +0100, Lorenzo Stoakes (ARM) wrote:
> Thanks,
> 
> If Mike's going to respin worth examining this.

Thanks for taking a look!

> 
> Let me paste in the attached patch to make life easier:
> 
> >From time to time, the following BUG can be observed[0]:
> >
> >> kernel BUG at arch/x86/kernel/alternative.c:2576!
> >> Oops: invalid opcode: 0000 [#1] SMP NOPTI
> >> CPU: 0 UID: 0 PID: 355 Comm: (udev-worker) Not tainted 7.1.3-1-default #1 PREEMPT(full) openSUSE Tumbleweed  8c1795b03ec64f997e57a8ad38b1161e3b98da64
> >> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
> >> RIP: 0010:__text_poke+0x2aa/0x450
> >> Call Trace:
> >>  <TASK>
> >>  smp_text_poke_batch_finish+0x2a7/0x320
> >>  __static_call_transform+0xb7/0x220
> >>  arch_static_call_transform+0x5b/0xb0
> >>  __static_call_init+0xe9/0x270
> >>  static_call_module_notify+0x11f/0x150
> >>  notifier_call_chain+0x61/0xe0
> >>  blocking_notifier_call_chain_robust+0x63/0xc0
> >>  load_module+0x1c92/0x20c0
> >>  init_module_from_file+0xd8/0x140
> >>  idempotent_init_module+0x100/0x2f0
> >>  __x64_sys_finit_module+0x71/0xe0
> >>  do_syscall_64+0xe1/0x610
> >>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >
> >which matches the following BUG_ON in alternative.c:
> >	/*
> >	 * If something went wrong, crash and burn since recovery paths are not
> >	 * implemented.
> >	 */
> >	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));
> 
> Ugh yeah, it seems the CPA code is just teeming with this kind of thing.
> 
> >
> >This can happen if vmalloc_to_page() fails, for any reason. Such can happen
> >if text poking races with CPA, which can possibly result in the collapsing
> >of page tables (or breaking of PMD hugepages). It is not a problem for most
> >users of vmalloc_to_page() (they solely own the vmalloc'd range) but, when
> >CONFIG_ARCH_HAS_EXECMEM_ROX=y, various modules own a single execmem vmalloc
> >range, and can call set_memory_*() in parallel on it. This can happen to
> >race against __text_poke and cause havoc in vmalloc_to_page().
> >
> >Fix it by excluding against CPA using the init_mm mmap read lock.
> >
> >Fixes: 64f6a4e10c05 ("x86: re-enable EXECMEM_ROX support")
> 
> You'd need to somehow state the dependency on commit "x86/mm/pat: acquire
> init_mm write lock on collapse to avoid UAF" from this series because this
> depends on that.

Yeah, it's supposed to be queued up on top of the series.
> 
> That only goes back to commit 41d88484c71c ("x86/mm/pat: restore large ROX pages
> after fragmentation") so you'd need to somehow indicate the backport would need
> to port my change even further back...

Hmm, I think this is the correct Fixes:...

> 
> >Reported-by: Jiri Slaby <jirislaby@kernel.org>
> >Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1271202 [0]
> >Reported-by: Steffen Dirkwinkel <lists@steffen.cc>
> >Link: https://lore.kernel.org/linux-mm/555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc/
> >Cc: stable@vger.kernel.org
> >Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >---
> > arch/x86/kernel/alternative.c | 8 ++++++++
> > 1 file changed, 8 insertions(+)
> >
> >diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> >index 62936a3bde19..9071eb870eab 100644
> >--- a/arch/x86/kernel/alternative.c
> >+++ b/arch/x86/kernel/alternative.c
> 
> Should include cleanup.h.
> 
> >@@ -2559,6 +2559,14 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
> > 	 */
> > 	BUG_ON(!after_bootmem);
> >
> >+	/*
> >+	 * Exclude against change_page_attr() collapse in execmem ROX regions.
> >+	 * These are PMD sized and this module may not own the whole PMD,
> >+	 * thus breakdown/collapse may happen at any moment by concurrent module
> >+	 * loading, which races with vmalloc_to_page().
> >+	 */
> 
> Worth saying what this pairs with. Right now the comment doesn't really explain
> why you're taking this lock.
> 
> >+	guard(mmap_read_lock)(&init_mm);
> 
> This is problematic.
> 
> text_poke_kgdb() -> __text_poke() can be called from pretty much any
> context it seems. It's another debug_pagealloc type situation :)
> 
> Claude tells me there's a in_dbg_master() variable you can check to avoid this
> and all other CPUs are stopped when it does this so it's safe anyway.
> 
> >+
> > 	if (!core_kernel_text((unsigned long)addr)) {
> > 		pages[0] = vmalloc_to_page(addr);
> > 		if (cross_page_boundary)
> >--
> >2.55.0
> >
> 
> I attach a patch (hand-written :) that addresses all this. Feel free to use it

Artisanal!

> as you like.
> 
> Cheers, Lorenzo
> 
> ----8<----
> From 2759f0ea4457e572c2972c7e5a0bbb39f2a9a2e5 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
> Date: Fri, 7 Aug 2026 16:23:40 +0100
> Subject: [PATCH] fix
> 
> ---
>  arch/x86/kernel/alternative.c | 39 ++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 62936a3bde19..cafcac95e90e 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -6,6 +6,9 @@
>  #include <linux/vmalloc.h>
>  #include <linux/memory.h>
>  #include <linux/execmem.h>
> +#include <linux/cleanup.h>
> +#include <linux/kgdb.h>
> +#include <linux/mmap_lock.h>
> 
>  #include <asm/text-patching.h>
>  #include <asm/insn.h>
> @@ -2543,6 +2546,30 @@ static void text_poke_memset(void *dst, const void *src, size_t len)
> 
>  typedef void text_poke_f(void *dst, const void *src, size_t len);
> 
> +static void poke_vmalloc_pages(struct page **pages, void *addr,
> +			       bool cross_page_boundary)
> +{
> +	pages[0] = vmalloc_to_page(addr);
> +	if (cross_page_boundary)
> +		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> +}
> +
> +static void poke_vmalloc_pages_safe(struct page **pages, void *addr,
> +				    bool cross_page_boundary)
> +{
> +	/*
> +	 * execmem ROX ranges are shared between modules and can be collapsed to
> +	 * huge PMD entries, and this collapse can happen concurrently with a
> +	 * racing set_memory_rox().
> +	 *
> +	 * Prevent vmalloc_to_page() from racing by acquiring an init_mm read
> +	 * lock which pairs with the init_mm write lock in
> +	 * cpa_collapse_large_pages().
> +	 */
> +	guard(mmap_read_lock)(&init_mm);
> +	poke_vmalloc_pages(pages, addr, cross_page_boundary);
> +}
> +
>  static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t len)
>  {
>  	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
> @@ -2560,9 +2587,15 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
>  	BUG_ON(!after_bootmem);
> 
>  	if (!core_kernel_text((unsigned long)addr)) {
> -		pages[0] = vmalloc_to_page(addr);
> -		if (cross_page_boundary)
> -			pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
> +		/*
> +		 * If called from kgdb cannot sleep, but all other CPUs stopped
> +		 * anyway so safe.
> +		 */
> +		if (in_dbg_master())
> +			poke_vmalloc_pages(pages, addr, cross_page_boundary);
> +		else
> +			poke_vmalloc_pages_safe(pages, addr,
> +						cross_page_boundary);
>  	} else {
>  		pages[0] = virt_to_page(addr);
>  		WARN_ON(!PageReserved(pages[0]));

Hmm, yeah, this looks More Correct(tm), thanks!

(for the record, after this email I tried exploring if we could feasibly
Just Hold the mmap lock on callers, but it becomes messy quite quickly)

Mike, if you get to queue up my patch then please replace the diff with
Lorenzo's (with a Co-developed-by:, I guess, since he went to the trouble
of moving quite a few things around). Otherwise, I'll figure out how to
re-submit it after your series lands.

-- 
Pedro

