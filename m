Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CD2FC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 02:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD8F6B0134; Fri, 17 Jul 2026 22:58:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4556B0135; Fri, 17 Jul 2026 22:58:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BAAF6B0136; Fri, 17 Jul 2026 22:58:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 151026B0134
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 22:58:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AD95402E7
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:58:56 +0000 (UTC)
X-FDA: 85000390272.25.3222DF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6506C1C0003
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 02:58:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FWepOhTb;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784343534;
	b=QSxT0wlL/kYiwR1KPEeNpUAo4nPlEN89wiDz1KBmf9hvxdAibwtKOyyfza0OhKDCqZncSg
	PECGvkQnEjEBy4ooTosapq0oecLvLY8VkuoBK3JTSJC0NHQMdiw89g8pvxzj5hJQTZAVmY
	iXvmc2M0ej5wyZ+mQLFTOP1AA6tYc6c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FWepOhTb;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784343534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7XfoPT2oMNPE2z0d13/Tu8kgBcJ84oX1g4DISyS+F0k=;
	b=4vC/ixV2B8O/ZYE/TfhucSEjjJN5hxy27JFvkLK3P/G/YaeOdE77SZdnnGzOjQRXCDlC+r
	BC42X3QkExNzyBIOT+J41vnu4QynDOpUFi0BhxSDMCsFkM71pYw1wMrpU+fEDqIG3VdkJs
	Z5Z6pBOoTGQ5zGHvCGYJG0XldLTwPxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A51660A7F;
	Sat, 18 Jul 2026 02:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527D61F000E9;
	Sat, 18 Jul 2026 02:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784343532;
	bh=7XfoPT2oMNPE2z0d13/Tu8kgBcJ84oX1g4DISyS+F0k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=FWepOhTbOgtkwWe0uWCffWMkZAjEQetO4+9YEM2hiBh7+YW8vBOWMlqibhC3MjQhm
	 3W/nxK3uKOVKbhaLsrn9kgLn6c3XXw9JdWUs4+GsTvMgs28jfMgNe/2mx4bBqFDafZ
	 cN5YPCdmPBv9X9WhHUcLMf73fMnxq//FhYIU/07c=
Date: Fri, 17 Jul 2026 19:58:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev
 Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, Hao Zhang
 <zhanghao1@kylinos.cn>, Hao Zhang <hao_zhang_kdev@163.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)"
 <kas@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] mm/huge_memory: unlock i_mmap_rwsem before releasing
 after-split folios
Message-Id: <20260717195851.609269e143b4b9eb857f2a6a@linux-foundation.org>
In-Reply-To: <20260716095424.471052-1-kirill@shutemov.name>
References: <20260716095424.471052-1-kirill@shutemov.name>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6506C1C0003
X-Stat-Signature: eqnk49g9ohyhyq7rjr1xjzfqgo4m3bqh
X-HE-Tag: 1784343534-431782
X-HE-Meta: U2FsdGVkX19qVSJQNdOSm3pt0uc4efyYkHurujVBZrn28z61fiKZgdolg3ZBl3uxWNLq4MpiLFSqe+RSf6W5FRojjB8TFWCcsLDhBm72/z6NrXHYUcfyI/vwuB362oU1wqB4Kcofld7c4cF8x8i2IQ1zD84cC4QTNJtfSJePRg0Kps40H16YrKO2egBTUcYc1oJaWJHj4TNyl0yeeceJQnH1nI1HQQrXo7U/wR2HGJpvLCtWqZUVcV12M9f6mvbS33G4ZGYCAVmz95Hlg77CkimZ9M0A2/wTXXkC4dokAFktCxy73+YQTehi6YdqqVVqSM4KKIXfWnlpppoZ6KIecn8LQS7MkECpvilN4D3TXcQxP+yW/8KLZKcIINy6L74wkzAwUuGuXtag0jK6ASyAoB0y6525qC7gwH/JYauokKLbXg9D7yqe83fDDavWnURITMdsQytUUB37ox+g7LfmaReg8xGoywnHIHARGsReBaljYRGmhrG6lfrZskqIQ9LkKn9pcuehlIhI8HNpWeMohMtD6slWZ8eNIzr7axgkXZe96xJ9u5zM6DimuaUWb6CQXURP7jvCePC6lXNwTrtu3EabG0ES1UTb9KU3LfopNQ3Y4vehztfZATGFt/JpzwpjUcPLs5cMXi9Es58tiYy86ozjdZI2Vbgks2sRq4tZForhGE3spN+eaQSiPCG32LtLCsGfFo5sWYNrj8/HhHsiwKoyVO5NbZQq0IExLxtmAP+FVqgPDx6qlIoF6KOP1GWqAL+JodWSsGz2O9Llt51Oww38UWUclkhNG0JOGL5Gl+zpWlFhFEHnIj0PqOFBzwuwjY5Q8apM6kKphbnufORUtRG/pF8ffZFUMeE3/u7rCOpjOqnTbsKK1ubR0WnIWGhhjHS3xyrMuFCTIR0Dqsve7pwCtH2dZtnrq73TWcjpjqCe1RLKPPEeZbMABJpWn6rpyJH6rVASnsAVROA3fhn
 C9KLDQw7
 q6m4kD8c5L/rcA1H6FL29g6HEJy5WuLk5W9GA0X6TLx242B6gJiDSKFzVPVOlE45eSoMaGL8hcX7xIL2x+gRzJoCfAeSFTCmkkShJLk1XzuKot9l2oaAtuMqYEGPM0GDqYIO/e22h+cpdYqLXJn1sPRpBhQ4AeOtWlA2G7StDjt26B9nW6/2JoXk6ajsJkPyaAMwANohcPDM390K6Fp9aJXT/26NKRD8ixAfsPFhALd0g5lLi764dKc7v8riochKRKnWiRKw+rXpBOJj9/6yyy++Oirk1fc5M8FjGW+FYypXb+onBwJyG9xa+EqxD8wvUlCuomM20v0tIjMMfaD44dmwCbIbbWQU4npNjhwKgxLlkmcmM4CDdw3nVaRcHPk2/WMKEVDv8z1mFiyTZ3nc9Yqeh4nKH1oeQr2S23ZSFOJUmpLBoeusz3W8GoVq1r1PVKz+6fSmnEQGrkMM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Jul 2026 10:54:24 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_split() keeps dereferencing the mapping after the split:
> shmem_uncharge(mapping->host) and remap_page() while the folios are still
> frozen/locked, and i_mmap_unlock_read(mapping) at the very end, after the
> after-split folios have been unlocked and freed.
> 
> Nothing holds an inode reference across that. The split relies on @folio
> -- which the beyond-EOF drop loop never removes, as it starts at
> folio_next(folio) -- staying locked and in the page cache to hold off
> eviction. But the unlock loop unlocks @folio before i_mmap_unlock_read()
> runs. If the caller's @lock_at is a tail beyond EOF, as memory_failure()
> passes when splitting a poisoned tail of a shmem THP that reaches past
> i_size during truncation, it too is gone from the page cache; so once
> @folio is unlocked no locked, in-cache folio pins the inode, and a
> concurrent final iput() can evict and RCU-free it before
> i_mmap_unlock_read() touches i_mmap_rwsem:
> 
>   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
>    i_mmap_unlock_read include/linux/fs.h:537 [inline]
>    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
>    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
>    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

Added as a hotfix. thanks.

>  mm/huge_memory.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)

Sashiko might have found a pre-existing bug in there:

	https://sashiko.dev/#/patchset/20260716095424.471052-1-kirill@shutemov.name

(why is mapping_set_update() a) a macro and b) undocumented?)


