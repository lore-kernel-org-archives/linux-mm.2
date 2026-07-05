Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BB0FC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 03:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808CD6B00A5; Sat,  4 Jul 2026 23:44:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA796B00A6; Sat,  4 Jul 2026 23:44:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF2E6B00A9; Sat,  4 Jul 2026 23:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39A7D6B00A5
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:44:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75AF6A061A
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 02:26:07 +0000 (UTC)
X-FDA: 84953133174.21.1DA33F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63F9440003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 02:26:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hLDjws93;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783218365;
	b=DM/TBWtqEwB1agQFCpY64Ozta0c3Bxzwxsd8O/2aiy/RoidGw7uL+rIRib0ZCvRYs44YAZ
	d/Rhg9pbDaUxdgKjGAh5sjSg6arVSFMnHlzXtCFL5aK30IbMROyB5VyF7u1aoSCpKhCN56
	Yrk9J7IE3YoqHytFJzFY1kopZwwS6+g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hLDjws93;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783218365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IbyQ0iR+hLbxRFpsh94ndDa8yRI/8SnokZ5nDNb916k=;
	b=6PiGB9n+Xv9pTgX7tQhcaA2yLTbzvv6SXXeXoVQX8y2UEqlrqrFyehjOXKzrKr8XXB0YWe
	wKHjSYUCs6nSyN2QmIp397tp0183xuqInoVHvZAMOU3lT8SbeLP+SHOzTH+XANEJd56SjR
	1oBqVpsQG4eKkxdpyWRvoYxaORT8mWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 858356111A;
	Sun,  5 Jul 2026 02:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DC81F000E9;
	Sun,  5 Jul 2026 02:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783218364;
	bh=IbyQ0iR+hLbxRFpsh94ndDa8yRI/8SnokZ5nDNb916k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hLDjws93mWeG72Dv1/P30DDLItc7/eTsKBsVHjsfaR9G/HryBZLR/homeeeP/Uwtt
	 IS0o51wd74DPvz/Jvjhj5OJlLebLH6lXdbDlFoPPYhNPX3W1VOfmp8ne+D0qPDU82u
	 nojZEoFAeLBX0T3vzigW1OVrUUrfgJkbcST96G2I=
Date: Sat, 4 Jul 2026 19:26:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/secretmem: disable under HIGHMEM
Message-Id: <20260704192603.40aa80cf9242b77aa75e8d8d@linux-foundation.org>
In-Reply-To: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
References: <20260703-secretmem-highmem-v1-1-30d5ff944664@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63F9440003
X-Stat-Signature: oax7yciq3qz1ns7rbosnp48hmouuw8mj
X-HE-Tag: 1783218365-817660
X-HE-Meta: U2FsdGVkX19jsF3F9yhdab92hjcsB7/rHZf5G1QKhWs5moauPGYM5mm6gwf+XdFfwxmYfNoLTpqt4Dp9ZhdTMzsiUBJQZV0cyFpgsAZH8Nxi18sei/EPb0o5kDKpcbBOysrwEfIJYkFEYKSHRoGDNsTZdb4lVSaxT9U/VjOF97ZHltpnGGzFQWxlhWKX+Y6YnTMxKT1WWQiHzE4YdD7sbOJMlKzw3xlI/6jM/viPOg7MNSmpnGmRFpKR5BYgjNbuAglIH1jFNEKQJxnVMDZbgHcTlgZ+SEGZD2vsh5w7DqdPJDT3HybgPmelmt2L2pgiQhaon29iC9vB8N9//pOG7L7m3WxH7tBnDdwoDoC9sOIkbcyXobPrXYe4WZwUMGEoQtUxFwmWD3iuuSA7czS5OsOkkL7snVS6MmHWq8K44vHv7S/FKAbnVRBloHtUYAhar7z2kLZV1BBIZQ+MJ2ZpzoJh26vUw3fTu+xmJUH3LY4nXo6tIVFW08uG8LML6WL8NIxel3LzzhpoaQU4JzvN/N/BayL7NZ6PuJVj9bzdSuh8MTV5bETEdt4aLFMCQs85QDD4l+AxiSuE+QKBFDbr8rVlW4COQOhVeKKaxmHFONnRLSElgM0TPxXnpLrf3Pd8bINXboYQvvx1QFy4f8vm3dtU41bADp0F82GG5yGPA/IWBn1msdLYIA1W1mD1U0E72/XREV8XBgESRGAW+ykuzzPjW6lnOlLfaacj6wPl5ODUx0hxUeIVa3ou5vtvUdcz/MxyaiXq38sjfKblPNrEBnM+d0bG709C4hMRq8gpO7nOHcstfnpaEp6xtTZqVFXUgSEOzH197/4997lz6jphwjl7EO7v5ZGcbs8qpbkhi8YUjyaWeXiwq2rTuPoukvJSrLHLph4Gjs7OXoSmWvv6cuL8NlgyfH3UCnnhds5CEZjReM6AaQHyS311BoEIrF9wl8JKwGNiMZfLcB/fNVN
 iiMVWLFW
 54wKOsZHcOO0tQ1FbV8w7DXSviCjfiOTucOnhr4KG7vefQXLAlvpqjLl1C2N5fosva0Z74P2VzUv+cPo/W4x7KXk8UMK3L6eyafnVhEdjoo1j1mbzi2qGDDoyYp4bzEh/bK13A+xGzY3Ptvp8FuFpRMOl71W5Yke9e15Dw6DHC4bw2LlPa7CRSddkTxIsCFneeLB5nTjEte/yKgL75bnaG1Hxaahr49BC01EnO65GJHDUv+ZE2SUqfiaIp7NDn8ct6msnXmN1P8rcFlprrbtaZMWZVSPoyF4EZE9BND8qZZYFM9mV4IAfBuFisYqiyCcb5JpMwApHCd5RtRHwutvZUf2APKpNGSeTiurLscmV1fAcM3xT2NLIjadnyG2DAY76VVJl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 03 Jul 2026 14:48:26 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> secretmem_fault() allocates a folio with GFP_HIGHUSER and then calls
> set_direct_map_valid_noflush()

set_direct_map_invalid_noflush()?

> without checking folio_test_highmem().
> This causes a warning and process crash (vibe-coded reproducer in Link
> below):
> 
> Su[   30.071284] ------------[ cut here ]------------
> ccessfully allocated and mapped 2097152000 bytes at 0x3a449000
> Populating memor[   30.074614] CPA: called for zero pte. vaddr = 0 cpa->vaddr = 0
> y...
> [   30.078636] WARNING: arch/x86/mm/pat/set_memory.c:1840 at __cpa_process_fault+0x34d/0x360, CPU#5: allocate_secret/570
> [   30.084789] CPU: 5 UID: 0 PID: 570 Comm: allocate_secret Not tainted 7.1.0-14063-g4edcdefd4083-dirty #10 PREEMPTLAZY
> [   30.090937] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [   30.097543] EIP: __cpa_process_fault+0x34d/0x360
> [   30.100514] Code: ff ff 85 c0 0f 89 7d fe ff ff e9 3d fe ff ff 8b 03 8b 00 c7 04 24 c8 ff 64 c1 89 44 24 08 8b 45 e8 89 44 24 04 e8 53 7
> a 00 00 <0f> 0b c7 45 f0 f2 ff ff ff e9 fc fc ff ff 90 8d 74 26 00 55 25 00
> [   30.110829] EAX: 00000000 EBX: f64afe98 ECX: 00000000 EDX: 00000000
> [   30.114799] ESI: 00000000 EDI: f64afe98 EBP: f64afe04 ESP: f64afdcc
> [   30.118785] DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068 EFLAGS: 00010246
> [   30.123020] CR0: 80050033 CR2: 46c48ffc CR3: 038c8000 CR4: 00000690
> [   30.127010] Call Trace:
> [   30.129078]  __change_page_attr_set_clr+0x5e7/0x870
> [   30.132275]  ? console_unlock+0x99/0x130
> [   30.135069]  ? irq_work_queue+0x36/0x70
> [   30.137853]  ? page_address+0xd3/0xf0
> [   30.140421]  set_direct_map_invalid_noflush+0x52/0x60
> [   30.143782]  secretmem_fault+0x128/0x210
> [   30.146560]  __do_fault+0x25/0x90
> [   30.149053]  handle_mm_fault+0x6d1/0xcb0
> [   30.151759]  exc_page_fault+0x135/0x3b0
> [   30.154487]  ? doublefault_shim+0x150/0x150
> [   30.157416]  handle_exception+0x130/0x130
> [   30.160137] EIP: 0x804d29f
> [   30.162307] Code: 89 54 08 e1 89 54 08 e5 89 54 08 e9 89 54 08 ed c3 0f b6 44 24 08 89 7c 24 0c 69 c0 01 01 01 01 8b 7c 24 04 f7 c7 0f 0
> 0 00 00 <89> 44 0f fc 75 0e c1 e9 02 f3 ab 8b 44 24 04 8b 7c 24 0c c3 31 d2
> [   30.172936] EAX: 5a5a5a5a EBX: 00000000 ECX: 0c800000 EDX: 3a449000
> [   30.176927] ESI: 00000000 EDI: 3a449000 EBP: bfbbae18 ESP: bfbbadac
> [   30.180897] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00010246
> [   30.185161]  ? doublefault_shim+0x150/0x150
> [   30.187979] ---[ end trace 0000000000000000 ]---
> Bus error                  (core dumped) ./allocate_secret_i686 2000M
> 
> The equivalent bug was pointed out by a local Sashiko instance on
> https://lore.kernel.org/all/20260410151746.61150-3-kalyazin@amazon.com/
> 
> This hasn't been reproduced it on older kernel versions but from code
> inspection the bug seems to go back to the original introduction in
> commit 1507f51255c9f ("mm: introduce memfd_secret system call to create
> "secret" memory areas"). If this configuration has always been broken,
> dropping support is not really a regression, so do that.

Well OK, but the secretmem code is still wrong.  The patch protects
people from hitting the bug but leaves the bug in place.  Surely it would be
better to fix the bug?

Is that as simple as adding the folio_test_highmem() test?  Or switching to
GFP_KERNEL?  You already have a reproducer (thanks), so this doesn't
sound like a lot of work?

(Should set_direct_map_invalid_noflush() WARN if passed a highmem page,
something like that?)



