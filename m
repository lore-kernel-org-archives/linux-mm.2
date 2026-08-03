Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02558C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 12:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA8C6B0096; Mon,  3 Aug 2026 08:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1F96B0098; Mon,  3 Aug 2026 08:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8336B0099; Mon,  3 Aug 2026 08:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85C2C6B0096
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 08:49:06 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE1DEA207D
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:41:52 +0000 (UTC)
X-FDA: 85059920064.20.009183E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf04.hostedemail.com (Postfix) with ESMTP id A90BD40004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:41:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YndVUhhs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxaAgSfH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T+pUauja;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DUEa6KbP;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785760910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ODL6gCk8lof5B/HMStAKTE/E0Vq5yUl2rgXGKUHBio=;
	b=eHubjXBSXSnWwteNuhvQsK3Y9doSTTpELk9vPKDcyqqHrAGYBZhA38iSNMC6I2Hy/6ch+g
	YiGdBzMYXFI+pE4AHSv5ZD613CTJun/adBoe2VSay5hSLJR5sartEVRqqUZzygsF+XQ4RF
	bKqShM/06Bf49labS7MY17w5sXnwbJg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YndVUhhs;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rxaAgSfH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=T+pUauja;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DUEa6KbP;
	spf=pass (imf04.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785760910;
	b=JO54VD3v+bGRA9XeAoi6p2WR4HLOyd2HBJyXprl21XI7dDnw0aeVqe58D4zWqnBTho0bL5
	9aW/0utXj1hKAOz8cZjWI7qqA5dZVZi0Ee/0pk4jEE98YyUf4JVNkxrwWxIrcLox9Rq6Fl
	PWgjfPqASOMg+6gtN5hiKYx/tNj4VOs=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 18F377F0E6;
	Mon,  3 Aug 2026 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785760905; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ODL6gCk8lof5B/HMStAKTE/E0Vq5yUl2rgXGKUHBio=;
	b=YndVUhhsn6D+xFCay2LMawar+ReWclRkw0K5TrxNoDo7HKj5P8kfn0p0wA/kIrgVjguYEn
	B+7gcaYxJpC0ouMiWbRla7tPefR4OAs8tfvZZUeDV9Of2cI0eqoV7AM/2coLKtyeQ7xSmD
	7T045LAIgwFm39g+PRGd0J6xQ+Pg6ec=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785760905;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ODL6gCk8lof5B/HMStAKTE/E0Vq5yUl2rgXGKUHBio=;
	b=rxaAgSfHajmj2MULUhqVM9DoGPlRJIjG+f6wT/HWG2LWYwll1qfjEjP0FCZ7J/Ivf/QNa0
	F0Mq+25xMD/Oc3Dg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785760901; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ODL6gCk8lof5B/HMStAKTE/E0Vq5yUl2rgXGKUHBio=;
	b=T+pUaujadhUEuzF7AIYqqNeI6LapYg3PXnwUPFVlo/5vy3LGvd9eDpA2VA+oj5/0MAM3Wt
	nkAR7pCNV/J21jLpSIWw8/ri5F+floyzpUlreyhWtzY57kOO0hynLtsAmj/M5aU+VxsOU2
	4XbNneXfDF6WIeoM6SU79ltF5/7nWMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785760901;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1ODL6gCk8lof5B/HMStAKTE/E0Vq5yUl2rgXGKUHBio=;
	b=DUEa6KbPFzZTiB+sI1npko+DVVChlHKpZ9fVEgKgILoCLtiKoqwKNh0nsyLI2RubGfRQEn
	6m+G7cmj6hao5DCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14A75779A1;
	Mon,  3 Aug 2026 12:41:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 98s4AYOMcGpuWAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 12:41:39 +0000
Date: Mon, 3 Aug 2026 13:41:37 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Steffen Dirkwinkel <lists@steffen.cc>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	"Denis V. Lunev" <den@openvz.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Juergen Gross <jgross@suse.com>, 
	Kevin Tian <kevin.tian@intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
	Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org, 
	syzbot@syzkaller.appspotmail.com, Jiri Slaby <jirislaby@kernel.org>
Subject: Re: [PATCH 0/5] x86/mm/pat: CPA fixes
Message-ID: <anCK3eWFMwZqq5ka@pedro-suse>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bh5jbue2ogdsvams"
Content-Disposition: inline
In-Reply-To: <555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A90BD40004
X-Stat-Signature: antuwu7gxh1mt33cakpq1jxnzydzkuzm
X-HE-Tag: 1785760910-397260
X-HE-Meta: U2FsdGVkX1/Bpx2p1FDJRmyVUzUenk2RjXTBEzs+BerUsAOZSHs6218ywsgOl8lmOgj429HlAAM8O0pMNK9jf8ekoMVSyTGacZ1kwfIPUWfGEhiamqfD9LHSYIxTlyW/xcz4xBxyxp4pYUigNQGVCWhittYTg/PWse9KEe7Q6SRT85vAYWYHjWb6hT4bh7tBqg7GxElGaLjSdmf66BMk6PrA5lbAgTdJ3Pb184Bdmm7N5KxUysvqzmxUJJXgj8ILbvhr26/D3RM01IH2RtURQcMXnLnEf9j79Wfcr++AD38FP1VpQRFJAmS2Te3/uplXm9k+jDzvklrK5ioeQKqSd9+ZDQuzIoWQpfmJjoJhCknPIKbCJ2KeXSJ9gAHWyjvXmeHngkHfD8V5NGgJHSrMxPfeKo44V82rz2GeNDN3io+tImSn2Gre3OFt2D0qhXuhBzlyursxj7RJhOaLiN3duifDiuqRNSe0tnnVhVazumXi/LzUu6g2zTck4OjPAxC6vhUoeH2f42zH/Mp4mbJymGYPt+Ce98h3jGVxOaC0hj8GdhYcRebQRp+EYwE7VMMU9AKN1k8ltHv1AJy6ZRifQOcHG5H20ddjZVCGQQIKjTHRr5vE8moi/03WfvNiCvGwpThsiiRJi3iGKwg/wHVLB08TuOkLnVOi6P5mIiJU4NviUZApO5bHq1OJuoBPJZwFv6lLT632V9QtLcUqoFM7wlZXZT31Uy7/ONZDpSk/aQNAENhDVokwoJ8FhCTAzZb5Ukh92sdDz8PVn60TMDc3+fKarakIlhjRoWF/rCsLbCOWLJwEa6puMHU9Xhmx6/e6l6H1xTYRsB8Q+MPPI/Zl8AsPnsrvrzsohA30zii63LdzSQuqq+2eo+0C433LffOmGmaHR3H2lLenqJgxp2aKeIrKlB8DOh43YcMVWr94Vnr/5Lqszbz3sdY1O18ZDHnQa1JUEqEY2ojcGah3B2v
 ZUhr2YNT
 YudAfHPxNQA958bJpiLjSv0sVdJ3faQkM97oAR5s7Dh04wcN2M/hP1CwJ4bDs4l2GfKa1wc5gL2ss67w8QbA9kzDFNznumhkN0Y0TN+bBnOpTyeXvllljrBSwvpfKgQr5USoDlupFJC/01pdlP2lOuD9lfWhIgNtJUwhXleSqKoE6oOpZs9mxNYzRlGN1IyY5YK92XayZlRqI2dgL0hMbU1h/XucHp/ccen6d4AJvmkif++V7j/vUF4oJsSa6ypqo696ztV4V/TiteYMFCgi5tr+9aPmAwI9GIcoS9UI8/l5MBDR8ZszKtk6OuSZ/tW6++zW6Z77RfQSVuSGo4JjDE1LIoHkEeUu1dZcTU8g+tGoVDi3HbKRqNLxNxvALU2OcnPsKZSvMNM81mcHTtYLoPPRZFC55+F9jXXvi80gmogWL9MkyIZrkKibuiAmSaluOKPeXAjCl/9euI0Ds+fzfE9pkx1skhjL5weCaWimxj+e07cyhQ1GP/Q6wUlhMhwR50sbx55dgj34odXqxVDPrRMbXord34qyXT/LT9qSv1VrbBtQyHI1gX9zB9OtlFPkqtxLYIl/BFEteWQI1G+WlaNVzI0ToHfRDu0IFTDqi3peZoi0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--bh5jbue2ogdsvams
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 30, 2026 at 05:53:50PM +0200, Steffen Dirkwinkel wrote:
> Hello,
> 
> 
> On Tue, 2026-07-28 at 16:07 +0300, Mike Rapoport (Microsoft) wrote:
> > There are a couple of CPA fixes floating around:
> > 
> > Denis Lunev fixed races between split and collapse of the large mappings:
> > 
> > https://lore.kernel.org/all/20260715183453.2381141-1-den@openvz.org
> 
> We saw the error below and I was wondering if it might be related to these fixes
> or a similar case that's unfixed still. Seems to have happened during concurrent
> kernel module loading of kvm and i915 (similar to the case in the patch from
> Denis Lunev). But we got it without KASAN and the stack looks a little
> different. I was not able to reproduce this with a ~16 hour concurrent module
> load unload loop so far.
> 
> Kernel: v7.1.5, PREEMPT_RT, tainted because of /dev/msr access
> CPU: Elkhart Lake Atom X6214RE, 2 cores, isolcpus=1-N
> 
> ------------[ cut here ]------------
> kernel BUG at arch/x86/kernel/alternative.c:2644!
> Oops: invalid opcode: 0000 [#1] SMP NOPTI
> CPU: 0 UID: 0 PID: 559 Comm: (udev-worker) Tainted: G S                  7.1.5-
> rt1-bhf-369933-f1a4ee1dd787 #1 PREEMPT_{RT,(lazy)} 
> Tainted: [S]=CPU_OUT_OF_SPEC
> RIP: 0010:__text_poke+0x356/0x3d0
> Call Trace:
>  <TASK>
>  smp_text_poke_batch_finish+0x1aa/0x3a0
>  ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
>  __static_call_transform+0xfa/0x1f0
>  ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
>  ? __pfx_preempt_schedule_thunk+0x10/0x10
>  arch_static_call_transform+0x57/0xa0
>  ? vmx_switch_vmcs+0xc8/0xd0 [kvm_intel]
>  __static_call_init+0x1aa/0x230
>  ? __SCT__tp_func_kvm_mmu_split_huge_page+0x8/0x8
>  ? __SCT__tp_func_kvm_mmu_split_huge_page+0x8/0x8
>  static_call_module_notify+0x11f/0x150

We're also observing something very similar downstream
(https://bugzilla.opensuse.org/show_bug.cgi?id=1271202) on 7.1.3 kernels, on our QA infra.

I wrote a patch that should fix it (I didn't get to test it yet, since
this didn't hit mainline/stable yet), on top of this. Mike, do you mind
throwing it on top of this series, or should I submit separately?

-- 
Pedro

--bh5jbue2ogdsvams
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-x86-alternative-exclude-text-poking-against-change_p.patch"

From 0a483fd05fda6e3953861b722995b58daf4878ef Mon Sep 17 00:00:00 2001
From: Pedro Falcato <pfalcato@suse.de>
Date: Mon, 3 Aug 2026 13:16:25 +0100
Subject: [PATCH] x86/alternative: exclude text poking against
 change_page_attr()

From time to time, the following BUG can be observed[0]:

> kernel BUG at arch/x86/kernel/alternative.c:2576!
> Oops: invalid opcode: 0000 [#1] SMP NOPTI
> CPU: 0 UID: 0 PID: 355 Comm: (udev-worker) Not tainted 7.1.3-1-default #1 PREEMPT(full) openSUSE Tumbleweed  8c1795b03ec64f997e57a8ad38b1161e3b98da64
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS unknown 02/02/2022
> RIP: 0010:__text_poke+0x2aa/0x450
> Call Trace:
>  <TASK>
>  smp_text_poke_batch_finish+0x2a7/0x320
>  __static_call_transform+0xb7/0x220
>  arch_static_call_transform+0x5b/0xb0
>  __static_call_init+0xe9/0x270
>  static_call_module_notify+0x11f/0x150
>  notifier_call_chain+0x61/0xe0
>  blocking_notifier_call_chain_robust+0x63/0xc0
>  load_module+0x1c92/0x20c0
>  init_module_from_file+0xd8/0x140
>  idempotent_init_module+0x100/0x2f0
>  __x64_sys_finit_module+0x71/0xe0
>  do_syscall_64+0xe1/0x610
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e

which matches the following BUG_ON in alternative.c:
	/*
	 * If something went wrong, crash and burn since recovery paths are not
	 * implemented.
	 */
	BUG_ON(!pages[0] || (cross_page_boundary && !pages[1]));

This can happen if vmalloc_to_page() fails, for any reason. Such can happen
if text poking races with CPA, which can possibly result in the collapsing
of page tables (or breaking of PMD hugepages). It is not a problem for most
users of vmalloc_to_page() (they solely own the vmalloc'd range) but, when
CONFIG_ARCH_HAS_EXECMEM_ROX=y, various modules own a single execmem vmalloc
range, and can call set_memory_*() in parallel on it. This can happen to
race against __text_poke and cause havoc in vmalloc_to_page().

Fix it by excluding against CPA using the init_mm mmap read lock.

Fixes: 64f6a4e10c05 ("x86: re-enable EXECMEM_ROX support")
Reported-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://bugzilla.opensuse.org/show_bug.cgi?id=1271202 [0]
Reported-by: Steffen Dirkwinkel <lists@steffen.cc>
Link: https://lore.kernel.org/linux-mm/555ea1d43a12c30a8f1eaf10c899b3790d728f33.camel@dirkwinkel.cc/
Cc: stable@vger.kernel.org
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/x86/kernel/alternative.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 62936a3bde19..9071eb870eab 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -2559,6 +2559,14 @@ static void *__text_poke(text_poke_f func, void *addr, const void *src, size_t l
 	 */
 	BUG_ON(!after_bootmem);
 
+	/*
+	 * Exclude against change_page_attr() collapse in execmem ROX regions.
+	 * These are PMD sized and this module may not own the whole PMD,
+	 * thus breakdown/collapse may happen at any moment by concurrent module
+	 * loading, which races with vmalloc_to_page().
+	 */
+	guard(mmap_read_lock)(&init_mm);
+
 	if (!core_kernel_text((unsigned long)addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		if (cross_page_boundary)
-- 
2.55.0


--bh5jbue2ogdsvams--

