Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BB97E67A9C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C64D16B0005; Tue,  3 Mar 2026 03:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33086B008A; Tue,  3 Mar 2026 03:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B355C6B009D; Tue,  3 Mar 2026 03:50:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A28CA6B0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:50:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A6131B79A8
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:50:41 +0000 (UTC)
X-FDA: 84504131082.05.425D245
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 85C2B20003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:50:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRRJr7WX;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772527839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC9e5v6+jkPb+OFVKVc1ctROV4qKJmhZ/7MGoT7HTlc=;
	b=u9y20jQHtL0BZjtXQsKBMcL/uGdODV43MukbfLz2DkVk7ubj1esXtH27c/stn3UP0WBAEe
	CBoy3bmKnFR6XIO0jE1ldZsiCwZBH6lpBMfCTZBndpHZTfB2pDlzjHzXlHxJ8V2wL7v9D6
	EeiINWrgAUblvs0LtCBCYO5P/IkBlW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772527839; a=rsa-sha256;
	cv=none;
	b=vNXSirW4FfsSnrZFhCijjgV4ip+Z+SA7JUL9YAcVes4WosmkG9gdf9vOLgPCDGloun0Sds
	2Ul7cB8VkJqNQ/VrMgMhHMS0kWZrbyAqPERuy8xLEEDh/YI1qjRL66uK67H54oXE8t/dpq
	Z7Xh5+5vwirYIxWaBlAsCOSPXyH6fPk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HRRJr7WX;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 804884408A;
	Tue,  3 Mar 2026 08:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59612C116C6;
	Tue,  3 Mar 2026 08:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772527838;
	bh=r87qOY77XSbIU/UY4K8bEMsqNQIs4ZK2kU3+22aYxro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HRRJr7WX3U+HslYZrW4zj5LwAwTyLP1FAwli/qKgJc4vfgD3Y9U5iR0l30qeRxdn/
	 FXyVKofRRFXyPHPylxSqYp9x4ejqAgV8WmcbwbYIctfycq4cjD2/TSxLi8B4//hzan
	 5YOOkdJh696gs5AiOwNcTe8lwiUgKJxUGHR8dcb/4g3LpeFSPgPSFH51xGYnEAGGr2
	 vaRa6MHO1IwsUzgo55iQmw8Zo8eYXFARXjRNDtj8rRUTXj9IP8ec6kMpT/OEKTfFm9
	 dfuwfF5VzLXSdEVqp4loxaFbK4Lr6S8P89wjl78nW0WIK/TTNcE15s60mHMP4gjOHQ
	 Z7PZfRCZDtdcw==
Message-ID: <e372b7e0-fc65-4296-a246-a14ff0856f4c@kernel.org>
Date: Tue, 3 Mar 2026 09:50:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/rmap: fix incorrect pte restoration for lazyfree
 folios
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: riel@surriel.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 harry.yoo@oracle.com, jannh@google.com, baohua@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable <stable@kernel.org>
References: <20260303061528.2429162-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303061528.2429162-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: on966bwzzywssqjbnzowtnb9kmsw5ayt
X-Rspamd-Queue-Id: 85C2B20003
X-Rspamd-Server: rspam03
X-HE-Tag: 1772527839-365943
X-HE-Meta: U2FsdGVkX1/+EDIX+YA0zu4zuxhzPcaSl+7yDzHmwBiBZH3qCuVo97vd+Tvd95V8WaYV0XYhQblLNthcHakwYESEHtMxevinEkEW0a/Z/6ENKRYBbWEFNdpxfeENeEOJjec0Yw3sLtICbKz5VlcDuKk8KK0jkRQvUp3krWe5msFSvPxHB14uInjQ3HDf2jeG7GsMRF+awQ2uZSgt3OCM6u2rExatIzhuKaiUvn7zytVx4MLaesJS8fJXPiQWkRz6scxyDXuh87B8ZHKQdNi+qVzuMbiUC6hppJ/IeJVUH3mCtlNdI8LXgmG4A5C1u2jASzCIYt0UYgcp6f5PGq0nz1m7nJHaY32Q3/rOTgqMsrnmYlHJqAJd+c0lxxDjDXdmUaG20cruVLm/kYPkGTMRCyPRPfTfsXWWMfvP6pZa2wBQrB9FnQBf24zBtt4MqQaKmZLdvxaHsGOpnLnOmsQf0ZVSIsXUu02gzlqxJCvtL8dLQh+01BNf/GDa/UnXkxlS9qmG4pth9aigfkFQ1uRz6ufrvfYUFbb07pFc90zOTDIfSJcW22BDcpypR4nUteiIMgcnonS10vdy67IAqK2tv9a8zBhez/PBBV2mcNrzr2WoBSMXIj7lzJHAAdZDeGsq/JXEj3J/YGxfW1uEv37xqcgvWnYC9AjczJkyLy5FD8q7NB4rfZU5cHU9yPkX7iND6j2lufF9JscCngxChzTCP/o6lpoeAAl6HNmJ+4+GoVWLGwPPInvymLZzcrvx+xWduSODRSG0qGyVCBZPAK599J+dUTxLL9DyGtkl1wWzlZawr3+hp7vX4ShHT9MpeZAz51UpltV6FXHePvF7dWbqssHJ9nZ8ib2lfYzCHtQlMP9n42i38rt0MumNyMwYIGdvib+cdqnVUmDIiMhmY2HqZ3Ym9TT7c793Ox4euiYtcYmGROSzsfqGOGaeyfv/dW3kn67xRfAIGpkv54oYloF
 abc25QTZ
 t8YnI3b8UYcVA4BTEZnM3l+VYZACwzaXt8NoMXDAGs0lqrJ9B2DOyKyAL2q1jMPzYIDbiPBk/0nB9tso5OX2nkET0TYd5qWDw733GX/S92H3W8TTlCgh9/1pADS22Zra0hsCmi1cYAOCTzylkWKiV50ahwZDk8Z4YU3CHEH3LnBuWKIrDPDsbjk+2wQyJZR5doVSRyck9HBUyJqhaFHefKI9qO5AVpLxF9cpJlhhgC6Pzcuy9Dq+AuD+qE2jl2wsBKXS/yiTgSl49b+eHrVVIkupHlCN54xCp82HkBKzKGP8xCtWn1RewJ78z0EZ6cY/RKeeYEcSaPmB9NuOKNbgh9Imqug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 07:15, Dev Jain wrote:
> We batch unmap anonymous lazyfree folios by folio_unmap_pte_batch.
> If the batch has a mix of writable and non-writable bits, we may end up
> setting the entire batch writable. Fix this by respecting writable bit
> during batching.
> Although on a successful unmap of a lazyfree folio, the soft-dirty bit is
> lost, preserve it on pte restoration by respecting the bit during batching,
> to make the fix consistent w.r.t both writable bit and soft-dirty bit.
> 
> I was able to write the below reproducer and crash the kernel.
> Explanation of reproducer (set 64K mTHP to always):
> 
> Fault in a 64K large folio. Split the VMA at mid-point with MADV_DONTFORK.
> fork() - parent points to the folio with 8 writable ptes and 8 non-writable
> ptes. Merge the VMAs with MADV_DOFORK so that folio_unmap_pte_batch() can
> determine all the 16 ptes as a batch. Do MADV_FREE on the range to mark
> the folio as lazyfree. Write to the memory to dirty the pte, eventually
> rmap will dirty the folio. Then trigger reclaim, we will hit the pte
> restoration path, and the kernel will crash with the following trace:
> 
> [   21.134473] kernel BUG at mm/page_table_check.c:118!
> [   21.134497] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> [   21.135917] Modules linked in:
> [   21.136085] CPU: 1 UID: 0 PID: 1735 Comm: dup-lazyfree Not tainted 7.0.0-rc1-00116-g018018a17770 #1028 PREEMPT
> [   21.136858] Hardware name: linux,dummy-virt (DT)
> [   21.137019] pstate: 21400005 (nzCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> [   21.137308] pc : page_table_check_set+0x28c/0x2a8
> [   21.137607] lr : page_table_check_set+0x134/0x2a8
> [   21.137885] sp : ffff80008a3b3340
> [   21.138124] x29: ffff80008a3b3340 x28: fffffdffc3d14400 x27: ffffd1a55e03d000
> [   21.138623] x26: 0040000000000040 x25: ffffd1a55f7dd000 x24: 0000000000000001
> [   21.139045] x23: 0000000000000001 x22: 0000000000000001 x21: ffffd1a55f217f30
> [   21.139629] x20: 0000000000134521 x19: 0000000000134519 x18: 005c43e000040000
> [   21.140027] x17: 0001400000000000 x16: 0001700000000000 x15: 000000000000ffff
> [   21.140578] x14: 000000000000000c x13: 005c006000000000 x12: 0000000000000020
> [   21.140828] x11: 0000000000000000 x10: 005c000000000000 x9 : ffffd1a55c079ee0
> [   21.141077] x8 : 0000000000000001 x7 : 005c03e000040000 x6 : 000000004000ffff
> [   21.141490] x5 : ffff00017fffce00 x4 : 0000000000000001 x3 : 0000000000000002
> [   21.141741] x2 : 0000000000134510 x1 : 0000000000000000 x0 : ffff0000c08228c0
> [   21.141991] Call trace:
> [   21.142093]  page_table_check_set+0x28c/0x2a8 (P)
> [   21.142265]  __page_table_check_ptes_set+0x144/0x1e8
> [   21.142441]  __set_ptes_anysz.constprop.0+0x160/0x1a8
> [   21.142766]  contpte_set_ptes+0xe8/0x140
> [   21.142907]  try_to_unmap_one+0x10c4/0x10d0
> [   21.143177]  rmap_walk_anon+0x100/0x250
> [   21.143315]  try_to_unmap+0xa0/0xc8
> [   21.143441]  shrink_folio_list+0x59c/0x18a8
> [   21.143759]  shrink_lruvec+0x664/0xbf0
> [   21.144043]  shrink_node+0x218/0x878
> [   21.144285]  __node_reclaim.constprop.0+0x98/0x338
> [   21.144763]  user_proactive_reclaim+0x2a4/0x340
> [   21.145056]  reclaim_store+0x3c/0x60
> [   21.145216]  dev_attr_store+0x20/0x40
> [   21.145585]  sysfs_kf_write+0x84/0xa8
> [   21.145835]  kernfs_fop_write_iter+0x130/0x1c8
> [   21.145994]  vfs_write+0x2b8/0x368
> [   21.146119]  ksys_write+0x70/0x110
> [   21.146240]  __arm64_sys_write+0x24/0x38
> [   21.146380]  invoke_syscall+0x50/0x120
> [   21.146513]  el0_svc_common.constprop.0+0x48/0xf8
> [   21.146679]  do_el0_svc+0x28/0x40
> [   21.146798]  el0_svc+0x34/0x110
> [   21.146926]  el0t_64_sync_handler+0xa0/0xe8
> [   21.147074]  el0t_64_sync+0x198/0x1a0
> [   21.147225] Code: f9400441 b4fff241 17ffff94 d4210000 (d4210000)
> [   21.147440] ---[ end trace 0000000000000000 ]---
> 
> 
> #define _GNU_SOURCE
> #include <stdio.h>
> #include <unistd.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <string.h>
> #include <sys/wait.h>
> #include <sched.h>
> #include <fcntl.h>
> 
> void write_to_reclaim() {
>     const char *path = "/sys/devices/system/node/node0/reclaim";
>     const char *value = "409600000000";
>     int fd = open(path, O_WRONLY);
>     if (fd == -1) {
>         perror("open");
>         exit(EXIT_FAILURE);
>     }
> 
>     if (write(fd, value, sizeof("409600000000") - 1) == -1) {
>         perror("write");
>         close(fd);
>         exit(EXIT_FAILURE);
>     }
> 
>     printf("Successfully wrote %s to %s\n", value, path);
>     close(fd);
> }
> 
> int main()
> {
> 	char *ptr = mmap((void *)(1UL << 30), 1UL << 16, PROT_READ | PROT_WRITE,
> 			 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> 	if ((unsigned long)ptr != (1UL << 30)) {
> 		perror("mmap");
> 		return 1;
> 	}
> 	
> 	/* a 64K folio gets faulted in */
> 	memset(ptr, 0, 1UL << 16);
> 
> 	/* 32K half will not be shared into child */
> 	if (madvise(ptr, 1UL << 15, MADV_DONTFORK)) {
> 		perror("madvise madv dontfork");
> 		return 1;
> 	}
> 
> 	pid_t pid = fork();
> 
> 	if (pid < 0) {
> 		perror("fork");
> 		return 1;
> 	} else if (pid == 0) {
> 		sleep(15);
> 	} else {
> 		/* merge VMAs. now first half of the 16 ptes are writable, the other half not. */
> 		if (madvise(ptr, 1UL << 15, MADV_DOFORK)) {
> 			perror("madvise madv fork");
> 			return 1;
> 		}
> 		if (madvise(ptr, (1UL << 16), MADV_FREE)) {
> 			perror("madvise madv free");
> 			return 1;
> 		}
> 
> 		/* dirty the large folio */
> 		(*ptr) += 10;
> 
> 		write_to_reclaim();
> 		// sleep(10);
> 		waitpid(pid, NULL, 0);
> 
> 	}
> }
> 
> Fixes: 354dffd29575 ("mm: support batched unmap for lazyfree large folios during reclamation")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>


Thanks Dev!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

