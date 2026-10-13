Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 336C5CC6B08
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3136B008C; Tue, 13 Oct 2026 05:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393E96B0095; Tue, 13 Oct 2026 05:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282FA6B009B; Tue, 13 Oct 2026 05:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 012806B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:36:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D3BE1C3CBA
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:36:20 +0000 (UTC)
X-FDA: 85317097320.08.29DB372
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7989C160005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:36:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J9+2Ojr9;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884176;
	b=FF+S37nBBDRxXzud29BCVTdf9gmQ43AoF3plA3aCiPKthilJca4MOoVNJxQRkiT9Knj1Fv
	dVNsFe0d03kIddKZaSF6OX5cmZJO08jWKW4EyqYwoAt8H/HQ9vCjdxLQYM1NDM/AZpYjwU
	yKuN/q7uxTWNzTSrnqiULt1XHXe/+84=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=J9+2Ojr9;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tf91INvadMxOEv4mOizUmAwHCMyZFOULLoKUW7s5VsI=;
	b=Apu0jBdOvqG7SyeU3arp5rTghCIIyt11hYwDhiuZETeb7o6CMcAp0DU9M6mLOh+H1kIjDb
	uln8DQ9+EFMN8ZU8Rdq3VAWRz7D002OFAUBjGdxnSwVM9aKbdKPMRQJw2EL/BDm5fCba0T
	FQowcQKBDNe/S8wsCQFsTpELkQ20DR8=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791884170; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tf91INvadMxOEv4mOizUmAwHCMyZFOULLoKUW7s5VsI=;
	b=J9+2Ojr9iZS9CDblEqXJXr0A1iD10L+ACh2smo7aV2SCwbxylzbw59BBaEK8fOZmXuCgqtuNPfWp2VnEQRo3YPMaj6CQJWRDoLHLdxapqBZfjUDbkv2DgNbR/ZBXNJlaYdkS3Hk/kyPBxoYJX2g9exlTVjvjZhVHVbHUKcZwzWE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XClKMcb_1791884168;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XClKMcb_1791884168 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 13 Oct 2026 17:36:09 +0800
Message-ID: <405811f5-ee36-4b3c-80d0-7dc6827ab5d4@linux.alibaba.com>
Date: Tue, 13 Oct 2026 17:36:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: memory: fix truncation removing mapped folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev, jack@suse.cz,
 pfalcato@suse.de, ayushr@modal.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <542c97482eae84f86704bcee56482633d1b32321.1791616645.git.baolin.wang@linux.alibaba.com>
 <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8245424a-f068-4be5-9e58-713cbff1f8ae@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7989C160005
X-Stat-Signature: 98fxpw5ugz75ohrf18kiji94siwk76ju
X-HE-Tag: 1791884174-421905
X-HE-Meta: U2FsdGVkX19U0WdvfiNMQA76udPuBhiMugT7Ge92sNzVsfVkKJaKl01L5AGJYBu89lXcV1cw2v9piu3ZrcDHQTCR5ndDv5ChAirS/qzLRzKNjvwV58U8W9k4B6fIMnpr2lwXYQOj1tGsjUAeYuvMLQNQPNzv3ME4L2nXj3QQpXTZjg3DJmEaDqoubjPNKcYDjlx2M7XvoNLZ3BUqJdJAHnbzfHyRvXcRQWeCpl72LE/wmK6tWQuUgbxmeBpdx4Qo1BfXMBaugxdaUaGuAQxuEuWF3sW0mtC5ma/zkwSSnTOOZEDP02A/tGALA7jLQNfowMkErubtpbQvAxQI99j8R9eIBOmfnYI7+19rJOwJ0YQNw60dAq3V4XXem3LF4BwK9g3sqBnFT1yCeTKBYISoWoCrQ0NgqOSur0y2+Mtkbtd9rnluWxgxwXKdmWens50rJ6S8//lB3TG7FWnEj06jp0TWLNj9jNZPMjlKnsbJjTsyIJPZ1fqN9rGxpdvdrPaZ+Zkzye/ztaZPdBbOU166DUoKCwwTWDqNwqIJAVB8POThL3eN0dEahGCG3cPfAntHZSs2etniJTgqjRiiq9qYOKAhB7ACp+t+rVV/vI/V4rewXgGmwdrsf3CHkQIynevYatpr2PKyTUbkCjZE42mn3OtBet/48m0HRF2CQDm70jjy1Lf3tHB7RiQrPA/zmIsSvimPEK0w7pH58C7tN3jfxI3jE9Ym2UD4npWAsGrGGyJ7HWr7GsPho90Uj3bsywmotCd2XVO3NqUQ5mQyy1vE2YlBahva3RCai1pqH/t/i2wFJA05ESkNH3YSUugdgaC3KqY1nkpiNRflOn6eQM+HJQzeL3DGuIyUVqfJoWduFJEXvJSKpw9I4YyknmN5yarMdvjAvRhYpxggwq1ERBdtmYE07DNqDNCt8rNUhKLKu7rdKTDpXjzi35HM9LuVgD2tbFksQNWaDpoOzPPYT1i
 +fb9kA46
 pr/C0D561/V8VmzcpC+wC3SJHF8Sog65cC0eCuktTYTaObo84ldpx1zsYkdC6Pj99rzFZ0hcRVIgb55UJnOHvQyrHquJHpkVx7b970Mdgg0e1gMVSOKFj0+m4Zw3TEzZDZoVPJrvHU7uLjmv5qSv2jb6mlc1xn8nEemkCvsabA3C/Z3QdwNflA+XbNDGIrge7uq5x0tMFUBLPQfhb3tlAG4yVlTJ7F+Nq9OTSTJKFX6lym3HTvQGVj/wtQzjG61tXDso6jU7ZFAkNWcYYRDJiHCBDje+RN2OhHWYZufYIaFjamHEksH84V5FCnz77MfoK8TU0WhvMWbGDszI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/12/26 6:23 PM, David Hildenbrand (Arm) wrote:
> On 10/10/26 09:22, Baolin Wang wrote:
>> Ayush reported an issue that shmem/tmpfs folios are still mapped when
>> truncating them on production:
>> "
>> BUG: Bad page cache in process ...  pfn:...
>> page dumped because: still mapped when deleted
>> "
>>
>> I reproduced the issue with Ayush's reproducer [1] with the latest mm-unstable
>> branch, and I got the following crash info. From the dump message, we can
>> see that truncate_inode_folio() is really trying to remove mapped folios,
>> which is incorrect.
>>
>> "
>> [  189.171977] page: refcount:3 mapcount:1 mapping:00000000fe168ee1
>> index:0x3880 pfn:0x191647
>> [  189.171995] memcg:ffff0000cc073d40
>> [  189.171997] aops:shmem_aops ino:3c01 dentry name(?):"memfd:runsc-memory"
>> [  189.172006] flags: 0x17fffef0002022d(locked|referenced|uptodate|lru|
>> workingset|swapbacked|node=0|zone=2|lastcpupid=0x3ffff)
>> .......
>> [  189.172017] page dumped because: VM_BUG_ON_FOLIO(folio_mapped(folio))
>> [  189.172026] ------------[ cut here ]------------
>> [  189.172027] kernel BUG at mm/filemap.c:155!
>> [  189.172057] Internal error: Oops - BUG: 00000000f2000800 [#1]  SMP
>> .......
>> [  189.177721] CPU: 3 UID: 0 PID: 5521 Comm: repro Kdump: loaded Tainted:
>> 7.3.0-rc4+ #277 PREEMPT(lazy)
>> .......
>> [  189.183986] Call trace:
>> [  189.184124]  filemap_unaccount_folio+0xf0/0x1e8 (P)
>> [  189.184391]  __filemap_remove_folio+0x34/0x160
>> [  189.184633]  filemap_remove_folio+0x4c/0xb0
>> [  189.184859]  truncate_inode_folio+0x34/0x58
>> [  189.185087]  shmem_undo_range+0x220/0x658
>> [  189.185308]  shmem_fallocate+0x2f0/0x470
>> [  189.185527]  vfs_fallocate+0x128/0x328
>> ......
>> [  189.187078]  el0t_64_sync+0x184/0x188
>> "
>>
>> After analysis, I believe the race exists between truncation and MADV_DONTNEED,
>> and shmem's ->map_pages() merely makes the issue easier to reproduce. Since
>> MADV_DONTNEED synchronously releases the pagetable page before calling
>> tlb_flush_rmaps(), this could cause another thread's truncation to skip
>> zap_pte_range() (due to pmd is none) but still observe the folio's mapcount
>> as non-zero. A possible race scenario is as follows:
>>
>> CPU 0                           CPU 1
>> shmem_fallocate                 madvise_dontneed_single_vma
>>    unmap_mapping_range            .......
>>    ......
>>    (filemap_map_pages() remap folios)
>> 				  zap_pte_range
>>    truncate_inode_folio		    zap_empty_pte_table(pmd clear)
>>      unmap_mapping_folio
>>      ......
>>        zap_pmd_range (saw pmd none, skip)
>>
>>    filemap_remove_folio
>>      BUG_ON(folio_mapped)
> 
> That reminds me of sync_with_folio_pmd_zap() usage in page_vma_mapped_walk().
> 
> Isn't that the better approach?

I had considered this approach before, but it is not feasible. IIUC, the 
sync_with_folio_pmd_zap() is used to address the race with 
zap_huge_pmd(), and both the PMD clear and the folio mapcount decrement 
are performed under the PMD lock in zap_huge_pmd().

However, the race here is different: tlb_flush_rmaps() is under the PTE 
lock, while zap_empty_pte_table() is under the PMD lock, and reordering 
between the two functions is also possible. That is, the folio mapcount 
operation could execute after the acquire barrier (spin_lock()) of 
zap_empty_pte_table(), allowing a reader on CPU 0 to incorrectly observe 
that the PMD is none while mapcount > 0.

Also, we need to consider the possible reordering on the reader side on 
CPU 0, as discussed earlier [1].

[1] 
https://lore.kernel.org/all/1b77c2d7-acc6-476a-b5cd-547471a46409@linux.alibaba.com/

