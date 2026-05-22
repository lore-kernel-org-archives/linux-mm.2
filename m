Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64125CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 19:20:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFC26B0093; Fri, 22 May 2026 15:20:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0816B0095; Fri, 22 May 2026 15:20:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6ED6B0096; Fri, 22 May 2026 15:20:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B04E6B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:20:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAB4D1407CB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:20:56 +0000 (UTC)
X-FDA: 84796023312.26.C78B3C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F23B100006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 19:20:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="A/Xjgqyk";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779477655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t41QCwdiqyuL/UKBS3u23I5KZlwdlxk/ylC/Jp2AbcY=;
	b=zXzFEWH74lQRlCdxj3kAiEtAx4srA3NVQQVIRs5VXvV3bMXWNoYOxiAokti/lJGtYrHuOl
	Sa6VwGyd/ZwkKW29RdTnhf8zIQa6mvUHclec5816iveVcYbSG65YEuLv9TVNhpi3pPzXhJ
	LIQbW6IZmRV/L/CO4DheShIFmYoHPvs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="A/Xjgqyk";
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779477655; a=rsa-sha256;
	cv=none;
	b=uyYQ+UUJpy555MOokpiUSrvwUwHG4tPEx27Vr6smjyxr/O3JJ87Ud/DmhdPTVz6lI+Umcu
	hjuKCvkE2kNS8aT4BWUzkO5Jh3Y1atXvw+IkP5fPkDYRSeVgeJfHCmjFlvq7ivYGsr44kX
	k5ytczxJHlUvx7jVdDvPlsMB4oPN/N4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B45860138;
	Fri, 22 May 2026 19:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E196D1F000E9;
	Fri, 22 May 2026 19:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779477654;
	bh=t41QCwdiqyuL/UKBS3u23I5KZlwdlxk/ylC/Jp2AbcY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=A/Xjgqyk1TMDW6V1BLTgayE9RCsWIE9yAV8Ahj5igvqc76Y0csCoxRzu3JoPPg0lp
	 yZfvgJZZwy96Mlp4rZuIhW+34vQHUx/TiYBJvlzF4SF1yStcC2+jglAgfkotNCoWgg
	 VVERfOMw5o65zBF/g7at8k/EeS+l8Lmn6oI5XxCY=
Date: Fri, 22 May 2026 12:20:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: david@kernel.org, willy@infradead.org, ryan.roberts@arm.com,
 linux-mm@kvack.org, r@hev.cc, jack@suse.cz, Andrew Donnellan
 <andrew+kernel@donnellan.id.au>, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, brauner@kernel.org, catalin.marinas@arm.com,
 dev.jain@arm.com, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, Liam R.Howlett <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, Al Viro
 <viro@zeniv.linux.org.uk>, wilts.infradead.org@hp2.hsd1.ca.comcast.net,
 "linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
 hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
Subject: Re: [PATCH v5 0/2] mm: improve large folio readahead for exec
 memory
Message-Id: <20260522122052.7b4ad7c482a0e4826296e392@linux-foundation.org>
In-Reply-To: <20260522162422.3856502-1-usama.arif@linux.dev>
References: <20260522162422.3856502-1-usama.arif@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0F23B100006
X-Stat-Signature: 43wrmf8spsxjf3egxrjawgoxm6bzp4rr
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779477654-542239
X-HE-Meta: U2FsdGVkX1+RJjJvRqDHCtYIeMZWwtdMKrUQNFSMjd3X8dxhuJckXn11TVv01tz5nnNbBSusWOTzo5fvhQ18S6bVVRi6PuA2DIj0C1cEGtCBgBmwU2a39BQmUO/ReU4zTZVp34/8UoAz0o+gSW4KfeUoKGJ0CQ7gwd2ebyh0Y8eDbE2vVjG3dA3Oxd0TNLY+yay37PugPO2hxSRlhR4V9CPHgV44ncz57QorJlEVh9adfVCss6URXLbI9hrT5gpKcVUW2MwQZT5qAgbAbboCHPiKaK9nBnTE3AwnciwELyol/VIOj71uHCbAWyXtWD3cgdd/FGNd6cUFAEz2yBLqRzgC64zg07OxYlm85Pg7H/hN90SWo4wtcyS3/UUgtqbBcFaJA51y5CSbagLnVCbkVxORMB8cVrCMozwHZNboSSYQi6FDQBK7byfMe5TBCuPQ5e8LqQELMfYIYP39j1egnllnE/GGcljHIyHman4i4r96lhA047ehfNYNo5O9ydB+tRDcg3lY1+jvxiys85/cGOl15gU8356Xg2fr3W4QMucg+DYjXaq36Q+4dJrmwYxH0l62dcK0WCitIRVltpyxYwBC4O4UPF4Yivfd+XN7TanGkD6g+kDZKP8KV2OkRjGS5nckNrFSylP2Ne0YNwv2oGwwdjJKk5rgEJ31KAiSodHYIBHHrdWWAZoVbRkbAXwyunmkhpu9VOZ2KITYD4yT1V41sexB6FyvjAtQNxKNTOvarWyGnXtMA5PDhGK98NWxILyR3yXiQ0Ad7eHfbf/YHGavjvSbciD3wb7GnhW5r+R0oXe2J4E0ZgcS7Qf2ItSuOYSefdzZmDxRzhcAFGeiKMjNdElom69Tl3fhVS5fjyvTwoY/esB64iA+Hor6S1f1aQRQoapLE2egka4uRb1bbq9GTLfx5MAI6dp/4wW0FOTev4M98UFNJc20Qp9b+mwufw8EvCp44d/XDHvUsLM
 lDKsPXxW
 up8ZDsGjOXcPkXWUsZ3BFmtXZruxjAI5MxQoAmtoJfjQH3tMEVDGf9NPcjQPi5VTSHgZ1Vkx3Y67lNXXL0VO3TsrgL8CK8M020MFaIyT6EUt8nw4bzcjW8utvoBXtdFIAMhtOCf6yK32dLp328jVAW286JArUrSV3zaZWEfQrFSm4IGY/IxKfTXOklMzXP56H3n+X+J0W52cGPKfz0/qY0I6nJtR1YEjR72IsCNo9uAR5MjFZa7VDw/yHIs2KQPwaYcsN7bZGvd5SVOzC4KVJ9FW77G9r8tXZPlMTKtK7tzYJFAf+ixH7vqonpzMgfXmsePISyGRCRmqxeVy/dNLpFAjWnvHfMRI5Sg0/VmcWWiOhiumh69nSKtuN+4oslqU0+q3K
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 May 2026 09:23:46 -0700 Usama Arif <usama.arif@linux.dev> wrote:

> Two checks in do_sync_mmap_readahead() limit large-folio readahead:
> 
>   1. The mmap_miss heuristic is meant to throttle wasteful speculative
>      readahead. It is currently also applied to the VM_EXEC readahead
>      path, which is targeted rather than speculative. Once mmap_miss exceeds
>      MMAP_LOTSAMISS, exec readahead - including the large-folio
>      order requested by exec_folio_order() - is disabled. On
>      configurations where the mmap_miss decrement paths are not
>      active (see patch 1) the counter only grows, so exec readahead
>      is permanently disabled after the first 100 faults.
> 
>   2. The force_thp_readahead path is gated only on
>      HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
>      readahead at HPAGE_PMD_ORDER. Configurations where
>      HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
>      path, even when the mapping itself supports usefully large
>      folios well below the cap.
> 
> Both issues are most visible on arm64 with a 64K base page size,
> where HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER
> (11) -- and where fault_around_pages collapses to 1 disabling
> should_fault_around() (one of the two mmap_miss decrement sites).
> However the fixes are architecture-agnostic: patch 1 reflects the
> nature of VM_EXEC readahead regardless of base page size, and
> patch 2 generalises the gate so any mapping advertising a usefully
> large maximum folio order can benefit.
> 
> I created a benchmark that mmaps a large executable file and calls
> RET-stub functions at PAGE_SIZE offsets across it. "Cold" measures
> fault + readahead cost. "Random" first faults in all pages with a
> sequential sweep (not measured), then measures time for calling random
> offsets, isolating iTLB miss cost for scattered execution.
> 
> The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
> 512MB executable file on ext4, averaged over 3 runs:
> 
>   Phase      | Baseline     | Patched      | Improvement
>   -----------|--------------|--------------|------------------
>   Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
>   Random     | 76.0 ms      | 58.3 ms      | 23% faster

Well that's nice.

AI review might have found a few things:
	https://sashiko.dev/#/patchset/20260522162422.3856502-1-usama.arif@linux.dev



