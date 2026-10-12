Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56726CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 10:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633EA6B0095; Mon, 12 Oct 2026 06:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DCCB6B0096; Mon, 12 Oct 2026 06:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CD246B0098; Mon, 12 Oct 2026 06:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286EF6B0095
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 06:23:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49939C0A97
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:23:16 +0000 (UTC)
X-FDA: 85313586792.11.354994E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 744E314000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 10:23:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKW0ZQ5y;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791800594;
	b=dtP9LFoHSHSVSztPK6kYtwbQu+VtWd2N+1ZhoBO5TSp5BGqGXAyXH0TJtfxup10jWd/Mm2
	+sxtIhb0/7oD3WQ/TJKiOYYAFHrqZPtnPN2HsHmBBXF2+FzJHgrH+X9mSgFZouLDXBrPcI
	IusBl77Z0Jqo3GRbrZ2gWk8eJE+pBms=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NKW0ZQ5y;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791800594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3z5VmndhUnm6M1SGNXwdEBCW+kXS3dFLbMdOYvBRK1Y=;
	b=qC5iEmUIUu4Ht3V2UE6R9GqP9snByUrKrrgWSGCPGxhGQBVkNz84ady7oX2u1+PrN1EJCS
	JTOBjNqvRwZow259F6G2dMhVrJinpq2zFV07Cfbt85wJPvrk73EdT1maHx485jlIPMM0bK
	C9hQefUr6n4NmTuVKy8YbOxLr0hZl9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F08174184D;
	Mon, 12 Oct 2026 10:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F191F0089F;
	Mon, 12 Oct 2026 10:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791800592;
	bh=3z5VmndhUnm6M1SGNXwdEBCW+kXS3dFLbMdOYvBRK1Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NKW0ZQ5y5yu1KDZuEBDuq5AHnO+AwF0hXY5f0rqVjf7do3lWR/THYgKzQho7s0jeK
	 MBrHdg5cRFWD2E9foRCc7WCGn85Zp/lHvT6ZvNroYolUnwgskLYqEtD5BxQ+vHYZX9
	 SHpdfxBv70t9HBT0b8smDkNIak8/XmUgNYsIoh4E8MaLt5KDGSRGh/ghhGHW+GsY/A
	 wSX4XJkuCVFay9yP7JJ8W0QxDvqWHNcUUzSIojEMBFShyoJolY4cI3Pio4I2lXDfxG
	 Ey/w3BlhSghn051P12y8YUkfvHW4Et5Xv2JzpBjaQyTH5zs/197ZWd0S+UBDCrfIMl
	 ythKfl/uJSmlw==
Message-ID: <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
Date: Mon, 12 Oct 2026 12:23:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 744E314000A
X-Stat-Signature: 43yt47w8qx5o4rioeywmeagnir5heh3q
X-HE-Tag: 1791800594-65827
X-HE-Meta: U2FsdGVkX18Yvi03UQyINovGKaUaB9DaZXbAizD0Qvr02X8ApVU1jf4xLZ+cSQbmoCpnjxxphGTPb43zK4ZoJChKgGBVZDOj8z3sXdoqq8ePaqKWBeiyBA5ILY9U/0SfYm3R+A4YinRz5BmttQ9z4qEEtQcW9gdKXWGRkvtJqrsX1PBqKSk6+RH2VyYIBMj3tJJQ/ys7qTswN0aMDEWQp36mOBFTfh1i2wxHP3VYe1FWvjFQN9NQM53DWWe1ZP6MjOF2CGL9ZKprRT4wpGX2E4P4+d0j6hbrSVKojNQJdi5MouRXBNU3I49Ri+jNZX+qZXr7ZF+azzTNUlVHcK2yXAtg4CvPE4q8cCfFevP6rh6+6Z3Y6fjMoqGQrmSQxTtuvf+0Gc2BF/lAc7/6r3CA7SdAIqGL5XyJ59X1/7uATUCSXbJ6C8GfOsFm1xLE/5s0hLOl6uJE/o1SnCX36zi25Vm2uA/xVOIF09VMLIP5e3HrKvok0Pp4jPQn//ogHlQTYjs3hCw6lQnDQJtDlP5+w+Gc8waqiOI5pQKe+dRj8fBdagnk6z9yuTqN4xLraxMxgwyMBzfH0SKUoEi1aAdkuledu53kTd5vnCS6GLWRs4LxqGhTgWGLguyeWBQirJyKpCO28D/9ukzsAD+HZBAYyRAJH1jlP6XT+TwPQa5oVYBOQxOfL+kNAqaKBHDuIKUXyJ6gX9aJetIEY+5r0GR7wyQrRepR9/QrS3Jz6iz2WpWretYBvEIDKx1Y9Z6UY4Df7X7b2M93NOE02Q4VllG0Zl66WcZdSLIHUvXOlDJdEH7wZZxjna1grmaNlJsS8vIo0IqeQhBFqpCpwN6cP1NGK9b6eYM569VHc5HQ2Rey+FG5k+/woji17vbqyfc/sglSYmfpS3FHv0b83vc81+8qtUZ4QumjNAdiS6Y5zewqEZXjZtyI5z/jlqQzQhbAS2xa7EX6ZKCI6+RYpKdKJe0
 uev5sHSv
 QlGNjn8NNsAjgVFAgUmrY8AeA8agq10rJsloQ4mk9R9BLZ7w9rBYWBZt/nleqh0EU/TrCmF7pzYy2x/Yn1gJMRsosu+6C0ks/y/Decz9aS7qoCctfoNzOQslzARS/FY7My0d/MEX6tdHwbDAFt8hKnxhDJCz8plR0qK0A5G9Yj/PumGGuEnpofv9RWKt/xJ64tCLJ9qTkMpJE2Z4/f6vSage/b1tlL0+5IjpmjZgcK/7mOaAsJZIhj2HG4b5HrMIZOHLI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/10/26 09:22, Baolin Wang wrote:
> Ayush reported an issue that shmem/tmpfs folios are still mapped when
> truncating them on production:
> "
> BUG: Bad page cache in process ...  pfn:...
> page dumped because: still mapped when deleted
> "
> 
> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
> branch, and I got the following crash info. From the dump message, we can
> see that truncate_inode_folio() is really trying to remove mapped folios,
> which is incorrect.
> 
> "
> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
> index:0x3880 pfn:0x191647
> [  189.171995] memcg:ffff0000cc073d40
> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
> .......
> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
> [  189.172026] ------------[ cut here ]------------
> [  189.172027] kernel BUG at mm/filemap.c:155!
> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
> .......
> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
> 7.3.0-rc4+ #277 PREEMPT(lazy)
> .......
> [  189.183986] Call trace:
> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
> [  189.184391]  __filemap_remove_folio+0x34/0x160
> [  189.184633]  filemap_remove_folio+0x4c/0xb0
> [  189.184859]  truncate_inode_folio+0x34/0x58
> [  189.185087]  shmem_undo_range+0x220/0x658
> [  189.185308]  shmem_fallocate+0x2f0/0x470
> [  189.185527]  vfs_fallocate+0x128/0x328
> ......
> [  189.187078]  el0t_64_sync+0x184/0x188
> "
> 
> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
> MADV_DONTNEED synchronously releases the pagetable page before calling
> tlb_flush_rmaps(), this could cause another thread's truncation to skip
> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
> as non-zero. A possible race scenario is as follows:
> 
> CPU 0                           CPU 1
> shmem_fallocate                 madvise_dontneed_single_vma
>   unmap_mapping_range            .......
>   ......
>   (filemap_map_pages() remap folios)
> 				  zap_pte_range
>   truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>     unmap_mapping_folio
>     ......
>       zap_pmd_range (saw pmd none, skip)
> 
>   filemap_remove_folio
>     BUG_ON(folio_mapped)

That reminds me of sync_with_folio_pmd_zap() usage in page_vma_mapped_walk().

Isn't that the better approach?

-- 
Cheers,

David

