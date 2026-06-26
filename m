Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F09EC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 19:39:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E343A6B0088; Fri, 26 Jun 2026 15:39:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4F26B009D; Fri, 26 Jun 2026 15:39:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD5756B009F; Fri, 26 Jun 2026 15:39:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A47436B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 15:39:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 259C6A0585
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:39:52 +0000 (UTC)
X-FDA: 84923079024.17.B5FADD3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0625E100002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 19:39:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wmdH4Ude;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=crCDm4qH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wmdH4Ude;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=crCDm4qH;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782502790;
	b=N7a23dcL3mNU5S5KiNl0EoTAJ9P7bx6cMn6Py+hihn4OLKoHx3msAYarwrDA8Dipir+eHk
	55pYNoAHKD6+RrWzIiHQD8aZxZNSAzzo3XPgTXKWi+CHLZf1blobgLfI5LIBtS9c4ze7i/
	YlxHmvPNN9cUzR1Rvo5rrxbNsGuZUWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782502790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzMGN6lar8EVCdJmNLl2FZFycB2tmO5d97XbhZn13tk=;
	b=QbTI+ceZNdwKTC58G2/BrPxzJDTvTVC3QkB5NVwPdx1K1YpiUrPxpTbfVfVGUZ6jnKh7oW
	0e3hDhSQR+VeOLQGdflqlKK6Y86rMITlVcMwXmrFglpVvPTyyazyZgS+eO6CbNd4/pvj5q
	gybvkZBveFSyG/pb9BGk4j0qi1rYkJA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wmdH4Ude;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=crCDm4qH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wmdH4Ude;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=crCDm4qH;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id AEA4872359;
	Fri, 26 Jun 2026 19:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782502788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzMGN6lar8EVCdJmNLl2FZFycB2tmO5d97XbhZn13tk=;
	b=wmdH4Ude7kEJnm0s+K5NOS5y5+rboGYe1FsdDffm7qAAq3BAtAdN9tM5BFdFG2hFDwgsBx
	jUg15o7/aVhuzxD0BwfLCKU6bKg6yiU7RWPgrEoseGQaGRCgIwnoOMPrYxl6aJ6gVUydod
	5kridDb2cwfJoIJnWikIaKDmOndx4Ac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782502788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzMGN6lar8EVCdJmNLl2FZFycB2tmO5d97XbhZn13tk=;
	b=crCDm4qHjv3HbldHz0umHWyGjLR48IYnhbI4uZzyxzWXwFDT7azZQZ2Jg9YVFL9XvJnExs
	9RRBVKz6zuZmocAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1782502788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzMGN6lar8EVCdJmNLl2FZFycB2tmO5d97XbhZn13tk=;
	b=wmdH4Ude7kEJnm0s+K5NOS5y5+rboGYe1FsdDffm7qAAq3BAtAdN9tM5BFdFG2hFDwgsBx
	jUg15o7/aVhuzxD0BwfLCKU6bKg6yiU7RWPgrEoseGQaGRCgIwnoOMPrYxl6aJ6gVUydod
	5kridDb2cwfJoIJnWikIaKDmOndx4Ac=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1782502788;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rzMGN6lar8EVCdJmNLl2FZFycB2tmO5d97XbhZn13tk=;
	b=crCDm4qHjv3HbldHz0umHWyGjLR48IYnhbI4uZzyxzWXwFDT7azZQZ2Jg9YVFL9XvJnExs
	9RRBVKz6zuZmocAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5643B779A8;
	Fri, 26 Jun 2026 19:39:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wjIqEYPVPmpmEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 26 Jun 2026 19:39:47 +0000
Date: Fri, 26 Jun 2026 20:39:45 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Xiang Mei <xmei5@asu.edu>
Cc: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, linux-hardening@vger.kernel.org, 
	Uladzislau Rezki <urezki@gmail.com>, "Gustavo A . R . Silva" <gustavoars@kernel.org>, 
	"H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>, 
	Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
Message-ID: <aj7UNceukU9zYeGH@pedro-suse.lan>
References: <20260626173444.2252041-1-xmei5@asu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260626173444.2252041-1-xmei5@asu.edu>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0625E100002
X-Rspam-User: 
X-Stat-Signature: o136wwgsiud1n3fxdn8kc8m17uwbfo7d
X-HE-Tag: 1782502789-544690
X-HE-Meta: U2FsdGVkX1+MAma1nwKvd4/Am3+Y3zlnIlKjFSkUksIBVGJ5313+WJtirrMtSFk1i4xx+ECXGsxVwfrhMlc2LKuOdkjzMX5j0dfcDhY3eOdSnc9GmJLLv8HUegigwZAVBNr63d3SbbkHEM5/RHkFZNPXThyDPGzoan9+QR/+KzOnNaGAo9stBzcNmKyVqOKLCHYI2MC7H2TD9Et+jQImiJmXyfeapOAAQhExBRWoHb8H+p6xlHE57JTrRB1j8gunc4SlfOzurThKV1igghextfemLaPVmbpc+83pe4L42I/f3mAvT/ElGwYmUhNBr7tGBAq23NkV04tmKV1qd0mlno1Kev5LrGg3cwFPn7YXlifdHNoJoGKcdvEMA0GzbLO5ZOe2P9h/KBi7fUziuuyOgOpq5lKZmLz8IWULNwDqTZqtyg7poimTEgOLtI1hPDsm+BOiSSkLoZHkoIo1ibQBHg6E4USp8cqGMRAd2bZ8Vx5OG6XkMpBHUzGxt6NnvMflyMNTvl+O/NoHm2MWid8rghi0nlo0OiW3Y9mQdMyH3xciBXOal7N/wBS2oZB1cTi4t2wAoLpYiH/PXd/iBX9JhTZtUcB9oCdIxswAmZi6yQrtld8NAIUB7UEl98ptas/Ou2MtwJ7XID50lNS7/q4DfOYZbD2Va3Qld2CPrT8q25OvxLlRwz2O9qmb9Gks3eiytAXYuzgjN2N4iKNM/PZCSL64nhbf/Lq9o3FDyamrZ98qpmW9nAGeflFDxJ/zvSKsAU+jLM5dh5NkxC6PZqdNEbQxbtvm61hEW294oH2yCcLTP9roMKn8znBM5h82mjtkwjLwzn/wo9jwgnLb4CA9c49juQKETo6ImsRZzR0RU3hxVGaeRhlrgEPmk43K08y0Nm4Dn0DDCRYl8e3nqLCieBNnWUdMkJE4hNu3S7N/nC4eUXr/5bpYHd7bk2eTjjROxXIzpFJcM/9ozBpEZol
 ydaKQy1M
 7rqbUdKexsPh0p/F5pU8YapuICldo1CQXO5fc+3Ga7L76SLXhQPG9eXMa+AKWpkxx7r7lVHXUbrwCVrq1Kn2K20k0FtZZRXsM0LPMuBxpUmHcvlL926fljjLm+7UFZeWGRRhmLDcauSdnMWc3RBLlFCYAnX0atJRZRs3hHVVeboe02B1kaj/lzEtrr8pO2B3IC5BfL0zFG8WBbLd3P+w2dNvwJ+mZ30lGG42Hp+S/ukmOBaEPA8Ls4YzzY/Ge+H2ivPnYW45HYm178jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 26, 2026 at 10:34:44AM -0700, Xiang Mei wrote:
> With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc area,
> which an unprivileged user can surround with attacker-controlled data by
> spraying vmap allocations adjacent to a target stack (for example via
> XDP_UMEM_REG, though other vmalloc spray paths work too). Today each
> guarded vmalloc allocation is followed by a single unmapped guard page.
> 
> A single guard page is not enough to contain the x86_64 ENTER
> instruction used as a one-instruction stack pivot. ENTER imm16, imm8
> builds a stack frame and lowers RSP by:
> 
> 	imm16 + 8 * (L + 1),  L = imm8 & 0x1f
> 
> imm16 is an unsigned 16-bit operand (ENTER never raises RSP), and L is
> in [0, 31], so the maximum displacement of a single ENTER is:
> 
> 	0xffff + 8 * 0x20 = 0x100ff bytes
> 
> That is more than enough to step off the current stack, across the
> one-page guard, and into the adjacent sprayed pages. When those pages
> contain a return sled feeding a ROP chain, reaching any ENTER gadget
> (opcode 0xc8, abundant as both intended and unintended gadgets) turns a
> control-flow hijack into full ROP execution without any register control
> at the hijack site, making it a one-gadget-style primitive that
> significantly eases exploitation. The pivot happens after the control
> transfer, so it is not constrained by CFI (kCFI/FineIBT).
> 
> Widen the guard region from one page to VMAP_GUARD_PAGES (0x11 pages,
> 0x11000 bytes), which is the smallest whole-page span exceeding the
> 0x100ff-byte maximum single-ENTER pivot. A pivot off the top of the
> stack now lands in the unmapped guard and faults, instead of in mapped,
> attacker-controlled memory. RANDOMIZE_KSTACK_OFFSET only perturbs RSP by
> a sub-page amount, so it does not change the required width.

What's so special about enter? Why do we need to design our guard pages
around it? FWIW, I can't find enter instructions in any of my kernel builds,
nor can I convince gcc (on godbolt) to generate an enter instruction.

If it's just "this is a single instruction that adjusts RSP", why is e.g.
sub imm32, %rsp ok?

FTR, I think it's fine that you're proposing more guard pages; virtual address
space is virtually free on 64-bit architectures (apart from lower page table
density, which may take a little toll on memory usage and/or page table
caching). I'm just wondering why enter is being used as the concrete target
for this.

-- 
Pedro

