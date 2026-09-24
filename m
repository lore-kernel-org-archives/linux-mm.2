Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 369C9C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:34:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CD46B0092; Thu, 24 Sep 2026 04:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00CF06B0093; Thu, 24 Sep 2026 04:34:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E652C6B0095; Thu, 24 Sep 2026 04:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD4D36B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:34:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54A3EC02AF
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:34:38 +0000 (UTC)
X-FDA: 85247994636.01.398822E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52D7F1C0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:34:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nlUMqdKT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="f/rXNRC7";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PYbSnZWu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=imv5WvY7;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790238876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ls/EHrVUOhbhknjDjl5OIhlbfKMkW9/0aMMdL/w2Spk=;
	b=OgcfIler7wwZaOxTSG6gTDLhIfr0AiSuGk9bhgDGTgTbqffoJJxvE1XtwjuLpatrPxgGTd
	emmWqCNqCnnVjshMhQ7h8Vnbew4RpYr/Z33Nsr7qiS4W3SfjEqr6cY+TSaZN9cuClkKPhh
	shAH2XETRkJCkbu7PvjrA5nNLHvrJbM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nlUMqdKT;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="f/rXNRC7";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PYbSnZWu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=imv5WvY7;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790238876;
	b=zfQsJkOmDTiNP4xeXtuHhpNuZGKxdyTFkKrS9lvasOO+yDedsFG6ENffIM3MkX+H24mEq5
	eIZOM6VnD0j9PDJDEPhImh1PXpFDoarUFUDZDDBpMzuAntuqMeYLEFJpxSMSYLdQpMHEi8
	2uXrW7rlwnZFZD293JmGW+C+xWEP4w0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A185A20056;
	Thu, 24 Sep 2026 08:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790238870; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ls/EHrVUOhbhknjDjl5OIhlbfKMkW9/0aMMdL/w2Spk=;
	b=nlUMqdKT2BVrImBSJG9kkvN6F9ToBKwX0sfXIQwmmNLxYLvDE2hXsDp+rPPd4TgG8Vq60U
	N3bUxwb50MxqYGAZTeyB0elGltSPhWlygShWWuitkSx8sFBBdbkGvaQjHw5dvTb/md7pe3
	oHLvvhhujc1XSvEReVEUs5wHuppuwB8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790238870;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ls/EHrVUOhbhknjDjl5OIhlbfKMkW9/0aMMdL/w2Spk=;
	b=f/rXNRC7XB/nxrdZykyXO4C+JNrJVLCAchmcQqhEEqTBU7CYRRqzaqX5FMc0YF0o6REZVC
	Krf/icMy2Ut5WIBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790238866; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ls/EHrVUOhbhknjDjl5OIhlbfKMkW9/0aMMdL/w2Spk=;
	b=PYbSnZWuSCyOu/Iegg+qwYBaJgBw5ZuLQJRNH0K7b3yKLIhUKXeJHsZejvHSSIQ86R7uQX
	KBRjFvKmmcEfuArvgiYSE8lR3d859wQIdd5Oqbw62+sPT8iDsggrvDkShoKnIGxDWH7uRA
	3rHrOLwW0ag8KgYsfEaKve4Bg2/OpA4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790238866;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ls/EHrVUOhbhknjDjl5OIhlbfKMkW9/0aMMdL/w2Spk=;
	b=imv5WvY7xxCb/TH1dA7EQzvw4LeFBnEYJF5HbD+Co6p0RBCSkW2QV3FOHcxaT0T0YUA41H
	u2hvZv519u1HkzAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B52D313354;
	Thu, 24 Sep 2026 08:34:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OwQGIZHgtGqsYAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 24 Sep 2026 08:34:25 +0000
Date: Thu, 24 Sep 2026 09:34:24 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Ayush Ranjan <ayushr@modal.com>
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
Message-ID: <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
References: <20260924061708.1645968-1-ayushr@modal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924061708.1645968-1-ayushr@modal.com>
X-Stat-Signature: 6gu9yzof9a7fbdxyx18tjji5czk5rpy3
X-Rspamd-Queue-Id: 52D7F1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790238876-982948
X-HE-Meta: U2FsdGVkX1/mSRVFRCXusLCqqB8PQ2jrhDeiMuv/1dZ45SQsNVOGdmrd3JTJhNunlLhWBnVPADveemikte+iOBBmaOKhZbGLzmTkzBZyy7Ox21X90ERtefzgtDG1Txp2eWkV74MHFGQ9B0HzE8l9EFil5AdRyS/N2xG6cmr26OFvXRoTEf8/4pXc2+EU0mLfirxs+oSOjTddmFvzItuYo0isLUy/UsGBl4jLtSu5NH3DqPmPbxHotSM9fL/1roeanPKGsq0Xi94skXzRY3nWwut7VFLyyYesMjrro5yZGz2hx0gS4pOR4aGZPjrH63Ua+og9slX9XzdXazQX7dS1Gi2M1Vz4vdgS733PC+UyBz0FradZATgcGhOkzuome9zKcJrqcpre6kmT6qj6bP2BZCw0e2PB3WM74wmcCEk8YhO5gtP7a8g7qssLbyLmAQLi52Lto1JSGZIpzMxBOCYdSU3W1dhmrWtzSHIpxgf8dJXqgB5oEg+mC1E2nBk8YK55vIqaVyqIpKgITrHmeCySaesdbSujOleffGAuiKzjI5i0Itt44Y/PmER0/PBTo/dSsIDbLoDTR3oyHdkEwloahfJq9s5rKc0zinvr2yAxI9P8WtzFVujd3SlgcTzfYILQU++9AIszoXjGSBC5ufpOshjN48ptxWgHWdfk4Xk2UT8pN7sskeMF5LD60NH09UGzAR/R5dpIyYzL9KTJXHM8iGEZFzNuo8pIDOeOWXoARWfDmZbxYdyUrpZhBH7cGR3T2WdZ+DDXSvtP+QkOzmbf3iyZA7699j1ku6b2BCF3T1Pw0dnawwtjrd/LEuAiQ2fCcInq2mghxnF0JVoePRoN2LDkkJDs1guKrffWq7ie2zk8iy9nRTMsZsYiNOEitRwswII5p743Rt4tdRaGxmjWsvZF0mjDfqplKZVrUtbhosiZQrL5Zx37E7EBCzvbM431XYDbnzA3u3Mv11PfR4a
 lZ+X4dx5
 Ao8VJvNtPRllotBydJTSbpPzKggPDJfr/ChzwC+L+rN25nhJcx5mG62eJt8msJX+/+ywGoRYYu8lRkroSvAAb7rif+8YgrlT/MRsoN69/b+uUgejl5OG6KIUnrD81YH9D8aTeeyWlbOTbTmTx9PWJsJ0EyCWi86t3gG2zETLJHaljx7HMbcnUbC61oSq/qtU1eq4GGkP10a5DBKDXEjtOYJ3+2woQi8KYEXymCAsppttvJblrHUdHP/8Idj57cqKCC76t8XEUY7A0RGMSxwJFdpEfYbzBSRoKcceIxTFdz8KCfHqj9FBFqSbMKxb8d0Aig515J5wuf5UzUkHHt9jacmzzmGAizkVliRHdyQlMH8VMAB8g42DUyvxTpC4fIyXOBPwFv5imhbWz1EvRD742guDF/TbIKDREg6QoEmUfU3iqkw4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(please use the email I actually use for work, thanks; not sure how
you got to that one)

Hi,

On Thu, Sep 24, 2026 at 06:16:21AM +0000, Ayush Ranjan wrote:
> Hi,
> 
> We are seeing shmem/tmpfs page cache corruption on production hosts
> running a workload that punches holes in a memfd (hole-punch based
> memory reclaim) while other threads and forked children fault the
> same MAP_SHARED mapping. The kernel taints but does not oops:
> 
>   BUG: Bad page cache in process ...  pfn:...
>   page dumped because: still mapped when deleted
>   ...
>   dentry name(?): "memfd:..."
> 
> and, more frequently, a paired rss-counter imbalance when the mm is
> torn down, always exactly one PMD-order folio (512 pages):
> 
>   BUG: Bad rss-counter state mm:... type:MM_FILEPAGES  val:-512
>   BUG: Bad rss-counter state mm:... type:MM_SHMEMPAGES val:512
> 
> Seen on 6.12 and 6.18, x86_64, bare metal and VM, with
> /sys/kernel/mm/transparent_hugepage/shmem_enabled = always.
> 
> This looks like the same corruption Gregory reported in March, which
> as far as I can tell stalled without a fix; that report needed ~100
> ballooning VMs to reproduce:

Well, I thought (from the lack of replies) that it was probably a bug on
their side. Perhaps that's not true :/

> 
>   https://patchew.org/linux/20260326162611.693539-1-gourry@gourry.net/
> 
> The reproducer at the end of this mail trips it with a single memfd,
> no VMs or ballooning, within a few minutes on a large machine, so
> hopefully it makes the race easier to confirm (and to test a fix
> against).
> 
> Here is my best understanding of the race -- corrections welcome:
> 
> shmem guards faults against an in-progress hole punch with
> inode->i_private: shmem_fault() -> shmem_falloc_wait() waits while
> shmem_fallocate(PUNCH_HOLE) holds i_private. But shmem's .map_pages
> is the generic filemap_map_pages() (shmem_vm_ops /
> shmem_anon_vm_ops), which does not consult i_private and does not
> take invalidate_lock, and shmem does not use invalidate_lock to
> serialize faults against truncation the way regular filesystems do --
> the i_private + waitq scheme stands in for it, but only shmem_fault()
> participates in that scheme.
> 
> So while shmem_fallocate(PUNCH_HOLE) is between
> unmap_mapping_range() and shmem_truncate_range(), a concurrent
> fault-around can (re-)install PTEs for folios that are about to be
> truncated:
> 
>   - filemap_map_pages() samples mm_counter_file(folio) once per batch
>     and applies it with add_mm_counter() after mapping; if the
>     folio's swapbacked state changes while it is concurrently torn

But that cannot happen? We hold the folio lock in filemap_map_pages().
The folio (naturally) cannot be torn down while we have the folio lock.

>     down, the map-time counter (MM_FILEPAGES) and the zap-time
>     counter (MM_SHMEMPAGES) disagree by exactly one folio -- the
>     +/-512 imbalance above.
> 
>   - a folio re-mapped in this window (by fault-around directly, or
>     via a child VMA whose PTEs copy_page_range() installs after
>     unmap_mapping_range() has already walked the i_mmap tree -- the
>     dup_mmap() variant discussed in the earlier thread) can be
>     deleted from the page cache while still mapped -> "still mapped
>     when deleted".

No, I don't think this paragraph is true. Page cache truncation (via
truncate, or fallocate PUNCH_HOLE) takes the folio lock for each folio
that is about to be truncated out. Mapping folios takes the folio lock
as well, except in the fork() case where a myriad of weird interval tree
+ PTE lock interactions make it safe (AIUI).

> 
> Reproducer
> ----------
> 
> The race is on PMD-order folios, so khugepaged needs to scan
> aggressively (with the default 10s scan interval the punched ranges
> are not re-collapsed fast enough to reproduce quickly):
> 
>   echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
>   cd /sys/kernel/mm/transparent_hugepage/khugepaged
>   echo 1    > scan_sleep_millisecs
>   echo 4096 > pages_to_scan
>   echo 511  > max_ptes_none
> 
>   cc -O2 -pthread -o repro repro_shmem_punch_race.c
>   for i in $(seq $(( $(nproc) / 3 ))); do ./repro 60 & done; wait
>   # watch: dmesg -w
> 
> On a 112-CPU host this trips within ~2-5 minutes; this capture is
> from 6.12.0-204.92.4.4.3.el9uek.x86_64:

Awesome that you have a reproducer! Have you reproduced this on a mainline
kernel? Enterprise kernels are not supported upstream.

In any case, I'll take a closer look ASAP.
 

-- 
Pedro

