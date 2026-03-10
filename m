Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C671FD2D62
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 12:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5738D6B0103; Tue, 10 Mar 2026 08:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520E06B0104; Tue, 10 Mar 2026 08:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42CF56B0106; Tue, 10 Mar 2026 08:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31ABB6B0103
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:13:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF834877FD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:13:23 +0000 (UTC)
X-FDA: 84530043486.19.FA56EAF
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id D45BAC000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:13:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSf4yTdc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773144802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IVbDBC/gXLUKjiFKFntQ3YXB8R/aXBWwbD87Qad6a5M=;
	b=DhJEpH+0Axsp+3ePLDPweNfzk6d1w8LseZcjzwYTQgOnXbXn8rKKRbTGIfk1g6p8YX4JmO
	fawhE7z5s6Ke3ijbutDDfezKhVZuVnH/MXmQ/kuST6JVYderhGick5OCTCn6LO06euJLuz
	qejQtF/D2sKsCq1B9zpKhD+sGgLBULU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773144802; a=rsa-sha256;
	cv=none;
	b=uXdLoBvwCSyXi9i5LwZXuf0FQS9BW31Zqi3lyaBfdsGodvpd52YbTQ0nXFMRNlD5GF5+rH
	7JK0Yzzm4Mbs7n6kFE1pTtYSypQdncvmEdILxpHkjToOAF3m+OSu+EHUCAwVVKc6GVJaYk
	5p5Ag2NXXn1o9FH5lILYyttXMyTkXT8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lSf4yTdc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773144796;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IVbDBC/gXLUKjiFKFntQ3YXB8R/aXBWwbD87Qad6a5M=;
	b=lSf4yTdcBxPuznlEYDAK9BVXAUirWopBvZQprwXkWE7MxH9ZpZ02jVh+Shf79NA451GlDh
	uZOlBVwtkFmf+ggl881gdGBps+hIbZszB9FyD5DshVg2AwAQZrbR2m8OtU0jVWJB4Fx74E
	FYIkUitsoOF5k5iwpchkHV28MGDTdPg=
From: Lance Yang <lance.yang@linux.dev>
To: dev.jain@arm.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	david@kernel.org,
	harry.yoo@oracle.com,
	jannh@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	riel@surriel.com,
	ryan.roberts@arm.com,
	stable@kernel.org,
	vbabka@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree folios
Date: Tue, 10 Mar 2026 20:13:04 +0800
Message-ID: <20260310121304.17173-1-lance.yang@linux.dev>
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
References: <20260303061528.2429162-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D45BAC000D
X-Stat-Signature: inm5pawikb6a4f9kn89wo9pt9t9piytb
X-Rspam-User: 
X-HE-Tag: 1773144801-426840
X-HE-Meta: U2FsdGVkX19nSTGDUqkhEXFuKLbGdVyIvLI/8zK6q7PcO0fZbLXLwNL/v487ZgZmD4y0QwhGZutepVWsIHgc+u6RzMXB5lBgKnkg3RgLM+IwTbiSyPJmHs5G1vAKle/jD1goEFrJQ2vkRbSFU5I9/DNQjHGgNW98u+2oE++4zMTGdqeqnvO3FwDqqFdvgft7lEllVxpM4l9RJqfnKJTfTp/9WF5VOOXOj8vdJX+J5kdEMag02pfYMBnDC60cmfOFojd9qS1yUJXIYU4xNdCZ+Mx594W5HfFBhV4vRai7uWlyPWIH/bFhX/ntT9pn3G4r7InGyxNwWTohjk0o7uHcQL50beTbRZ1W0gzI4UDEXje8lDzbxpnKkbw4Gq7daseIEdmzpi3uvCt21XQ3aHDzh75DLYqBRnL/sF5goUBky7tYgbzkFGl0RHRAbS4sTv+r+Lks1b4QkBgCv/WFbB2FDAqXSNli8+uEw7tIeR1dLYt1sMvCgvXNw6ZNU48w46mhPK3ToqvBbpbBNZHwLJ3JJSmFNbAkJRkpFtuheQPrPIlYNbGRQq2hfrz7/eq0CZ4VtJr3BrTDkOp7hJTL+x7AHLABsLNit9S4ZWL5cPmi7OsuhlUJSOvxBZIwlF0CFz3DcOFmpx3t50LsNCzHlo6DqY6TjC9tEaCyn+TMmK85ka0KhJtx5Q0j8g9Ipo6F1BT/TcDqpanP6ed58mTpBImZCI29L0V32W20amp0L17t3X9CoWY+o/TMGKrBjqC+wJcME6R0gR0bfHTaf0VmYUYi0Uaa8SP5HMeRo05kslQ7lPhJJpqEHqZu8iP+OObqiBIzECw0chBkwWJ9Scy+WoRUcaxDVYlpsMvzR4zoSyW8bRU8Qsh20tUFv6cI0oI9g+C/iOoPIUQc3PWQem/I3pqArF8CtXtFR3eVXZXwgTS52B9vycm05hMmUmK++YVl1rO2u1rg3T1z9MWL6qtdNZ2
 adl3IG38
 O+A99xeL9Fm4mCadbdsX4JHW6lvuHSDMwuNEbg+sm6iQVi49k7RjY2ZmyTXjmFW2l9ucMUWerzAeVBAjNtxjzsKn+VkjNkpjSbzmpGUmct1+EXuqxCIgwskZju+onCP7uzKh7qaLwqJwybo6iK7oDhSU/RE6GhnmZQpkkVlxykvTU4edXZYhBQn6sPGmJ7Au0JZeWGXK6n5cFCE5le4YRsxNn4uCO7nSnnCzyhwK0qlNB3TV92yABzjviwLSFUhJUPo6Iufr+c05yhPYwRQ3h+N3rsyXFaZ9sbrot
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue,  3 Mar 2026 11:45:28 +0530, Dev Jain wrote:
>We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
>If the batch has a mix of writable and non-writable bits, we may end up
>setting the entire batch writable. Fix this by respecting writable bit
>during batching.
>Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
>lost, preserve it on pte restoration by respecting the bit during batching,
>to make the fix consistent w.r.t both writable bit and soft-dirty bit.
>
>I was able to write the below reproducer and crash the kernel.
>Explanation of reproducer (set 64K mTHP to always):
>
>Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
>fork() - parent points to the folio with 8 writable ptes and 8 non-writable
>ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
>determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
>the folio as lazyfree. Write to the memory to dirty the pte, eventually
>rmap will dirty the folio. Then trigger reclaim, we will hit the pte
>restoration path, and the kernel will crash with the following trace:
>
>[   21.134473] kernel BUG at mm/page_table_check.c:118!
>[   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>[   21.135917] Modules linked in:
>[   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
>[   21.136858] Hardware name: linux,dummy-virt (DT)
>[   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>[   21.137308] pc : page_table_check_set+0x28c/0x2a8
>[   21.137607] lr : page_table_check_set+0x134/0x2a8
>[   21.137885] sp : ffff80008a3b3340
>[   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
>[   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
>[   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
>[   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
>[   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
>[   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
>[   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
>[   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
>[   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
>[   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
>[   21.141991] Call trace:
>[   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
>[   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
>[   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
>[   21.142766]  contpte_set_ptes+0xe8/0x140
>[   21.142907]  try_to_unmap_one+0x10c4/0x10d0
>[   21.143177]  rmap_walk_anon+0x100/0x250
>[   21.143315]  try_to_unmap+0xa0/0xc8
>[   21.143441]  shrink_folio_list+0x59c/0x18a8
>[   21.143759]  shrink_lruvec+0x664/0xbf0
>[   21.144043]  shrink_node+0x218/0x878
>[   21.144285]  __node_reclaim.constprop.0+0x98/0x338
>[   21.144763]  user_proactive_reclaim+0x2a4/0x340
>[   21.145056]  reclaim_store+0x3c/0x60
>[   21.145216]  dev_attr_store+0x20/0x40
>[   21.145585]  sysfs_kf_write+0x84/0xa8
>[   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
>[   21.145994]  vfs_write+0x2b8/0x368
>[   21.146119]  ksys_write+0x70/0x110
>[   21.146240]  __arm64_sys_write+0x24/0x38
>[   21.146380]  invoke_syscall+0x50/0x120
>[   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
>[   21.146679]  do_el0_svc+0x28/0x40
>[   21.146798]  el0_svc+0x34/0x110
>[   21.146926]  el0t_64_sync_handler+0xa0/0xe8
>[   21.147074]  el0t_64_sync+0x198/0x1a0
>[   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
>[   21.147440] ---[ end trace 0000000000000000 ]---
>
>
>#define _GNU_SOURCE
>#include <stdio.h>
>#include <unistd.h>
>#include <stdlib.h>
>#include <sys/mman.h>
>#include <string.h>
>#include <sys/wait.h>
>#include <sched.h>
>#include <fcntl.h>
>
>void write_to_reclaim() {
>    const char *path = "/sys/devices/system/node/node0/reclaim";

I wasn't able to get this reproducer working with node reclaim, but using
memcg v1 memory.force_empty worked fine for me.

[...]

>
>Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
>Cc: stable <stable@kernel.org>
>Signed-off-by: Dev Jain <dev.jain@arm.com>
>---

Thanks!

Tested-by: Lance Yang <lance.yang@linux.dev>

