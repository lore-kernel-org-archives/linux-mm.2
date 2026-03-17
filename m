Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF735FD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31B8E6B008C; Tue, 17 Mar 2026 10:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2F66B0092; Tue, 17 Mar 2026 10:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E25B6B0093; Tue, 17 Mar 2026 10:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6C36B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:05:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4225B70ED
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:05:45 +0000 (UTC)
X-FDA: 84555728250.12.52CAC64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id AEFB34000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:05:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ri6T6pi1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GKS35ceZV45ppQEFdZWxUPfVmHQOGqA3wYGxWtozKwo=;
	b=iBAPMACfnsYpFopc41QVSQ6V/+mJYM45et5Df5BxbpjaIMuaa7bCXJvj8tI93FMIlnGu0D
	lZ8G36dF6jFcXaJT1Z5VRacVSMuvLSGonQYM7iNCEUCXfSZ5/qoNB1Bnbo/Y34PY0msSuK
	tCt2Cn2ah0/M6RovyBPH0xoSfkB79UE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756343; a=rsa-sha256;
	cv=none;
	b=BejumQCmCRZBFCAuUjy38Rdj5LtqbtQzzq7/+ieLm7C1FRPNzM0Ae+2ohA0h6DNVrUydsy
	u8kaz9iPjQRvSCb7oSBtemuu9O9q+5JDDrALoRL7Tn/5MHBfkVIJvxzld6CqoqsMPGGNWg
	z7k7Oefqzy5CzmOWt1oNUt+/5CRQyyg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ri6T6pi1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC440408A3;
	Tue, 17 Mar 2026 14:05:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB0EC4CEF7;
	Tue, 17 Mar 2026 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773756342;
	bh=1sbqgNXyu2WMmYk8by5cABtxizG2nxoEyafVwjmfq10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ri6T6pi1H13WvM/4/umOiNgP5i/JgzzB82JRb0t1zzGpdQMvyBN80YkgubPATmTO7
	 HP5xNuWKCERKeDfphiZH+/rsG31IKv3mM8+EuDxCJRXt4mKCw4faRzLtQwSyeAoeB0
	 JydOwImqSO4RryEZZIv8Homrp+uyrw6wFmvJn+bZ/tg2fmBi0APzds3464luEPdgJS
	 FsZXK0XaJCDsU/YtwJ8wIeuLAlrNqIoFaIssiAcAWO/YR0Dgwf5Ge1W6+keCzILx7D
	 idnwYlgz/mh7uCW1HreKv+tQHviGDo+jm/vcO+vRUcmYeXNwtM9OtNYTWj/yDB7odv
	 1pYtoIwTuf75A==
Message-ID: <12804801-d4f9-42c9-8580-e3897efd15ef@kernel.org>
Date: Tue, 17 Mar 2026 15:05:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
To: mboone@akamai.com, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 stable@vger.kernel.org
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AEFB34000A
X-Stat-Signature: tswxpdi6gyuh1yrsqo6n9fd6eg1czyag
X-Rspam-User: 
X-HE-Tag: 1773756343-35147
X-HE-Meta: U2FsdGVkX19FArkmvNJ1ub9o8kXNvExOYu71W1nQhLOQY4qdee86KTIB3TvnLzne3bmfbQ3ttVtCF+EGoGygiPQI2rB0dhjvBhjgao/SeuaPsG+pRaODP2a1MzxGrtUPUHNgZcs0DxOxKwAIZzxB/K7jim783Q3nn5XnkDGlBkJPpaTrco9oTh+D62HYSv/ywkg6eSdjjbWesmKYVrlBNQWET8rd4ysWfqCNm8xZFecEZoLAWluoQUfcHcnHxLjT/qP7yJP2qEZCnjr0+tYlc6JHM4c0ZGaNYEj0Bunu3W62EO/OvZ9ur3uwFxg5BCDekDzNpU2dvv8AIIdjHJ51FLZarvWNCSKQ0hMgwpiIxgkLBsAVUxCyn8V+508zcajzeqWcffrv0IFcQyyHaIwSYUOWLM2ZrmEQpsh3yRwggTFApUMVBN5Si2Z9fwf7xsSND2w/yMo9VTQCJjNW4Iv5bRrCijxqDF9Pu3iS9rvHmvVTb2lF5kj/oHIbjkZWkvzChuLcQtkEkojX60fG/ZF/ytpJq5ji2LaZx6paVSBJIrXvi7NHlDLF6Sh0szV1ZV2Yo3IgOnI4ZNb8kPLWohJh+f+mLPCQpNaPxE4Qrff7pxIir1yAltMABUoVY7ZEtUewSNdDMkfb/4pkH1iLUn7/p7CGekpnrk+aHduFv9HnV2TGPAxRXwZPcpOGD7en5vB4q+ibte6OH8Ilxx2AgsB/bjWstXTd7o0f7YBsMB7twh/7jEOH5TN3ZiRTpcTxLflucaU8ez4497ErasjnmzT6xGvOpF0Ro5bvne31axEpwbExc5UNFqATaGUZcvpn5uCYzCa2OTfC/MsauuVukFTl+LUqGGxZc2ykuNPfwqcjU45t+tDYELZH1GKXuPTTsdqE1pv7OWx1Vja88pDEsXXPu5FWoONfs2RISOlJoSTUUoGamJrAGIDbPD6wD5lQLLcolsbLzfgegE0SR0o81gw
 InTsiMFR
 +pChECzCoduWER5a5s9kqL1A9ak597JqNCjxDGsWohtZhwJq8/KiCrC3sLUZQZq5gX9uJ4vLHygi5kWjTk0QLltJ06hnY0HgqCZILf8w0IGNwyxW2rICA0NnqNOalU4XNgU7MM/SQl/k4wyDZgF7xJbAnUIBLh4Z5EC0v3dqajWCysdiP6Bv/g/OZsIpeQKGEYdkChlf3aNBsLawgIUaWzWUh8LRwL0TMZ8TSTmEiBiqE2CmMDBqd3KfE93qdgowacXitX+NP6up89upWK+m7zJDhg/NsqhZMPpLlIFZKlciU9tgC1Ow/ApGMMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 15:03, Max Boone via B4 Relay wrote:
> From: Max Boone <mboone@akamai.com>
> 
> The splitting of a PUD entry in walk_pud_range() can race with
> a concurrent thread refaulting the PUD leaf entry causing it to
> try walking a PMD range that has disappeared.
> 
> An example and reproduction of this is to try reading numa_maps of
> a process while VFIO-PCI is setting up DMA (specifically the
> vfio_pin_pages_remote call) on a large BAR for that process.
> 
> This will trigger a kernel BUG:
> vfio-pci 0000:03:00.0: enabling device (0000 -> 0002)
> BUG: unable to handle page fault for address: ffffa23980000000
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] SMP NOPTI
> ...
> RIP: 0010:walk_pgd_range+0x3b5/0x7a0
> Code: 8d 43 ff 48 89 44 24 28 4d 89 ce 4d 8d a7 00 00 20 00 48 8b 4c 24
> 28 49 81 e4 00 00 e0 ff 49 8d 44 24 ff 48 39 c8 4c 0f 43 e3 <49> f7 06
>    9f ff ff ff 75 3b 48 8b 44 24 20 48 8b 40 28 48 85 c0 74
> RSP: 0018:ffffac23e1ecf808 EFLAGS: 00010287
> RAX: 00007f44c01fffff RBX: 00007f4500000000 RCX: 00007f44ffffffff
> RDX: 0000000000000000 RSI: 000ffffffffff000 RDI: ffffffff93378fe0
> RBP: ffffac23e1ecf918 R08: 0000000000000004 R09: ffffa23980000000
> R10: 0000000000000020 R11: 0000000000000004 R12: 00007f44c0200000
> R13: 00007f44c0000000 R14: ffffa23980000000 R15: 00007f44c0000000
> FS:  00007fe884739580(0000) GS:ffff9b7d7a9c0000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffa23980000000 CR3: 000000c0650e2005 CR4: 0000000000770ef0
> PKRU: 55555554
> Call Trace:
>  <TASK>
>  __walk_page_range+0x195/0x1b0
>  walk_page_vma+0x62/0xc0
>  show_numa_map+0x12b/0x3b0
>  seq_read_iter+0x297/0x440
>  seq_read+0x11d/0x140
>  vfs_read+0xc2/0x340
>  ksys_read+0x5f/0xe0
>  do_syscall_64+0x68/0x130
>  ? get_page_from_freelist+0x5c2/0x17e0
>  ? mas_store_prealloc+0x17e/0x360
>  ? vma_set_page_prot+0x4c/0xa0
>  ? __alloc_pages_noprof+0x14e/0x2d0
>  ? __mod_memcg_lruvec_state+0x8d/0x140
>  ? __lruvec_stat_mod_folio+0x76/0xb0
>  ? __folio_mod_stat+0x26/0x80
>  ? do_anonymous_page+0x705/0x900
>  ? __handle_mm_fault+0xa8d/0x1000
>  ? __count_memcg_events+0x53/0xf0
>  ? handle_mm_fault+0xa5/0x360
>  ? do_user_addr_fault+0x342/0x640
>  ? arch_exit_to_user_mode_prepare.constprop.0+0x16/0xa0
>  ? irqentry_exit_to_user_mode+0x24/0x100
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7fe88464f47e
> Code: c0 e9 b6 fe ff ff 50 48 8d 3d be 07 0b 00 e8 69 01 02 00 66 0f 1f
> 84 00 00 00 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00
>    f0 ff ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
> RSP: 002b:00007ffe6cd9a9b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007fe88464f47e
> RDX: 0000000000020000 RSI: 00007fe884543000 RDI: 0000000000000003
> RBP: 00007fe884543000 R08: 00007fe884542010 R09: 0000000000000000
> R10: fffffffffffffbc5 R11: 0000000000000246 R12: 0000000000000000
> R13: 0000000000000003 R14: 0000000000020000 R15: 0000000000020000
>  </TASK>
> 
> Fix this by validating the PUD entry in walk_pmd_range() using a stable
> snapshot (pudp_get()). If the PUD is not present or is a leaf, retry the
> walk via ACTION_AGAIN instead of descending further. This mirrors the
> retry logic in walk_pmd_range().
> 
> Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
> Cc: stable@vger.kernel.org
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Max Boone <mboone@akamai.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

