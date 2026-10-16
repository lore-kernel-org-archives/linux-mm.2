Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF663CCA466
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:23:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17E896B008A; Thu, 15 Oct 2026 23:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109396B0095; Thu, 15 Oct 2026 23:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F148C6B0096; Thu, 15 Oct 2026 23:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9C13E6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:23:18 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CFFE216030B
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:23:17 +0000 (UTC)
X-FDA: 85327043634.07.5220267
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf02.hostedemail.com (Postfix) with ESMTP id A8AC280008
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:23:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLSgXi2H;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OiLc0o69HjqbZe8oUbdM5P3U8ooGiryBMYhI/e2nG3E=;
	b=oNv50P1JC9sK6TK9c3zh/iGf8MRXlSqLFz2bfWueqiZ6DqgBziz/Rmbz7sycHXFjqisks1
	vgAfryodH857++yUeRGZTtYsbNNS2+JAuhgJ9A7+3iw6Qr12Gn14sR2fXkfy4zQHq0buEM
	er84Dn1sZXuktlh36fqfctG6En0fTPE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vLSgXi2H;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120996;
	b=nm3+yynnDuuQZ6SCs/jF0pXIJnZFlIq8+LT9E3xguYlkqRyAGzkit3wLX2yDkFz86as8ag
	JWTd6eJwgWatxIFKwGq8NVCbsTs3idgJUrjwPNYaGbHpL+1zlDV8RvdxmWYv7siKUempR0
	yK0/NRFZ/kdMj87cXaPjxZi3TBT/yPw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=n105cAOrmvacSuxJV1gCXAOncQUE7phVtbmqqTEizuA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792120993; v=1; x=1792725793;
 b=vLSgXi2HFcPWGFZHyWqR7CzzUbxtfiPkxNictNCq+2DaXzqIJ33NlwInHZdC6DnAO5F3fZMC
 5y9loVWYw8bhTiXODz3frE8xBs/t6Bu5sjgo/Sz8qJHH2j06TOIG/gppeA5afSKD6GSHR+Je4KO
 laOSIuLcmkXMwPc1DsV5Gph8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e7b0a4f9dcce94b9;
	Fri, 16 Oct 2026 03:23:12 +0000
X-Mizu-Trace-ID: e7b0a4f9dcce94b9
X-Migadu-Flow: FLOW_OUT
Message-ID: <96276015-a1fa-40ef-9780-867652d7b11f@linux.dev>
Date: Fri, 16 Oct 2026 11:23:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: memory: fix truncation removing mapped folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jack@suse.cz, pfalcato@suse.de,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <e2f76ed117b0c22a26b7688fd46a38c9d035336e.1792114445.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8AC280008
X-Stat-Signature: ei3qa9cc8yg5t9kp3zdffpnkbzzkbx3q
X-HE-Tag: 1792120995-895497
X-HE-Meta: U2FsdGVkX1+12zM5AXzHEkBsXDiWPSOLT3M8c7XcyzJYdubVkkBDrSE6ADy7bNZnET0NswvVxLSfrsHJ9Q4IzINVdUzwIOKPVU2/GKFcu99k659SDvWq3+9VoP5uHQ7q2n66zR28FtpKr4HREhnsmRAFhY4Hp9JCFH8uEuZFSg/ESsLU/kOwZCQbagVRpM6B/0Akc7wtUDOdCw/7rABAEv9n2KNG0QScIbz2KEmJkw/8iG9+VnfP13BnQKBqRKflbQ/58kUdstDR4LLwrW+opOjo27CTyfq1bYDtuKDh8V5NU/w7Ch5/ByM1rO0nwF4uoCyBIfsrSzHRJz8P/GKNVmUpNyxtCLSx3aX5BF8kT94EXG/vsFpy5Ty9qpzzG1h5dbJ/uw0ce9f13ZZxH9SHQKLZ8RUiEN5ma7Uk3oWxxFHzsWGN80aoayKA012RkwTg7dbVTeL3twZ8mmbEuk6+Au014coE4gEwmhkMokWakSuTI2Yqc0ZC4lI4pjj/FbziFjb7l8+0wiBGz6XEqbR3ziPWuhbhbAbxGOqFC6jKGrnKqgZD8CefsuIUk1K/8LHoMIxPxgBxinTIWkS8tMPEmaS1V4LC/PcM9Kly/6QBehKEqtpvJRpD8mi1Hkh0Rj674JLZmOTHKeSUzxU9nD2IRvNMH/LZCSFqswX+6f6GsSb+otrW9LYzt5GzBdNGUbKq3Pb0PjzVJQrcymHXSPMX/+iObj5fZpOTOPX4uxdTmcVPrX2MOBE1gkvOmxeBHyfqzuX7IS/Z2U/rl5iYYribSbiqVVxaaYxW04PYuWCQFhHv0jIN1pVdlhoJa2RPlI2b2fz1B0baprg7/Ci4nGvYYtV+9KgCIFuZ/8DV/HeIsKUjpM8MghQebs846kEqn2t3enLqYF6lg6C985KD7HYjPoMn9+Zpzie/F/5XXZ7LU9Ow6xjczKNxw6jr023/4NqRghra4eifqBlIlriCp/a
 /HOUXfDZ
 BLt2E/5OrKi1bKefvwnFgpn2YWrbxuxPipIKDbi+Ru036m0ircM7FnFYVhe+HUDnuvEMnWtfz3vm0vOzf2qPK2OdMARpOdMyTxcGTvEvB4j1dt8cKfJr+2uJsJ0FCvfTEUQHdlgTPiyCmYzuWZL+Qz++Y0wcCLxcoElPjPc6gVEl0AW2VTzmNjbqvX/bHH3Y6/iBtChCV9eNU3Cs2MvJyVLr1diQ1vlJQiQ5jlBZPZHNb+sud3DFTruaZRsZgLv0JqkL6cnSXwXjyI6cJwyANbHEBy7lG3e3ZtP3XUuZYKCDlA1oGITRunOe9dUbDvp2Ax+BrAGN9jXnugRYDo1F5KpW1BCd0PcOkxGrPngFj5PnQ120OVnuuXvnOWJw7MmmHZ7/W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 9:48 AM, Baolin Wang wrote:
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
>    unmap_mapping_range            .......
>    ......
>    (filemap_map_pages() remap folios)
> 				  zap_pte_range
>    truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>      unmap_mapping_folio
>      ......
>        zap_pmd_range (saw pmd none, skip)
> 
>    filemap_remove_folio
>      BUG_ON(folio_mapped)
>                                      tlb_flush_rmaps(remove rmaps)
> 
> To fix this issue, we should move the pmd clear operation (via zap_empty_pte_table())
> to after tlb_flush_rmaps() and use sync_with_folio_pmd_zap() to sync with
> concurrent zapping, so that when we find a pmd_none() while unmapping a folio
> without holding the PTL, the folio's mappings are guaranteed to have been
> removed via tlb_flush_rmaps().
> 
> [1] https://lore.kernel.org/all/20260925065013.3682431-1-ayushr@modal.com/
> Reported-by: Ayush Ranjan <ayushr@modal.com>
> Closes: https://lore.kernel.org/all/20260924061708.1645968-1-ayushr@modal.com/
> Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v2:
>   - Use use sync_with_folio_pmd_zap() to sync with concurrent zapping (Per David).
> Changes from v1:
>   - Add an smp_rmb() to pair with the smp_wmb() (Per Lorenzo and Pedro).
> ---
>   mm/internal.h |  9 +++++----
>   mm/memory.c   | 25 ++++++++++++-------------
>   2 files changed, 17 insertions(+), 17 deletions(-)

Thanks for the fix!

Acked-by: Qi Zheng <qi.zheng@linux.dev>



