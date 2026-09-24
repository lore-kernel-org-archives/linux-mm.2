Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE580C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 09:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB9D6B0099; Thu, 24 Sep 2026 05:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C766B009B; Thu, 24 Sep 2026 05:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0999F6B009D; Thu, 24 Sep 2026 05:30:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E22946B0099
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 05:30:25 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7854D80293
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:30:25 +0000 (UTC)
X-FDA: 85248135210.14.DF2640B
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6D6171C0004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:30:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SQp4t2Zu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790242222;
	b=y8Wd/ebX2Sv49kvDLdt4zazg+w2A2SAw+txJcwvDESCaKx6kJZCI4MXLLxFqRQYivmmElj
	8GWmINWTXl2THscL5xRMgKccYgjpI9VpTSbX2cdt60LKUv6chIB3AWPQd3nuJwnEz5zSni
	XW1vK3cmRsrN5HMx+ChJQStJh+myIt8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SQp4t2Zu;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790242222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGFp7vyDRjGA66l3w0r/DNC8ixnBictg/opoX+xyIPw=;
	b=Kl0MOpuKRatBrD9beMNxVTP+oSa9kWx9TlcuzBAu/V9NNbjqi9ASdoxXRXlJzcZrBdcCQW
	T89t9fm4iY8uBRRJgKiNwkuh7EDPPZXp39ybaempDRj0MPIagXR7x3ML6jV67J5wo8VlDP
	eId9BivrVm+NRfBxSQHpdb1+6p1QlTk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790242215; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hGFp7vyDRjGA66l3w0r/DNC8ixnBictg/opoX+xyIPw=;
	b=SQp4t2Zudwwu+YdEaSUQ/qQ55o+ciB2EWhwu8ejYnakt2HO9oYUY7FP7LPUTiW5jiz5eeSI+NUOS5lFCjeYwc9n6mQ9rPubN64mNvS7lLq35ZmoMo+QP5WUCUeW6k9oIBj7tHtjx0fqhZvwiUPwso6dOKuMBJ/QfM4j8FwIJAOg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0XBZH3vE_1790242212;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBZH3vE_1790242212 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 24 Sep 2026 17:30:13 +0800
Message-ID: <61f8a9af-7cdc-4979-bcc0-bcc932f7301f@linux.alibaba.com>
Date: Thu, 24 Sep 2026 17:30:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts
 page cache / rss counters
To: Pedro Falcato <pfalcato@suse.de>, Ayush Ranjan <ayushr@modal.com>
Cc: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924061708.1645968-1-ayushr@modal.com>
 <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: qh49p1ccaiyanxz8qrjxojzmshqhgpm9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D6171C0004
X-HE-Tag: 1790242220-783317
X-HE-Meta: U2FsdGVkX18xueElcl8O84SMntDvFShBy1R8ixKUbW/Cqb/LPOdnUTr/pCshRgWiy+FkNd9qC27hX7aslrXXMnAY3iGDphtZhoMd6/acR9auT2XMA8kIRP+f2Ya8NsrT664c3Ds+L+Pf7lf0x1KATGkr3rCz193/58WAww7uwPmtGYKG9/mXzn/eYvwdcar9KM4jra7e/mD8BUlZ7q4qXtqp9T+/hO9d/T3nmWAaV5dOyR/9G+3vCWGs/qkjy7JYvX0vaIDMjyTbzeVDxNtg+AdaaKq86TrXisTtNR7yUQmsv4ek66Pj+pkqoHHxgKboTiOL2+Bl5Pj3XXZ38Y3GasUJuUb04tVNRLMnqBoiMkrzO79TaAigLI0VYzcAe0lSBHfMExUqXnuLVoWGAv0rJ4NAlyqtjuKvDI0Ja0oaKn97nT3xlDVphIZdWp4R1DKRLYUWGAULgivi7OfeJ+vk6IlPtvTYMbJ+kVneLgpJh9kYgtSEIE0YBV609HD36yAvpnxRjGY6fYrPXugi70Y9MTnua/hHGx/BH2ZYElbSuk1sSmePGIGt1apS3u+u79S746l6WeBSov5+IEyryYcYJnPMgx6l3QjJtVwwpLI1pReO7afdSA0mxbFEDU5MhfcPQxYODiSY3LxsUV0IMmb2xSmGK5JT2xf4zZT14vFY3zjKXh5sIbl4ZZICDwFTKiss3FzFX9qpOYdNVaUNSnm7KIJhRznTceepLvTb8+obyRe1S99jnoIXt497ZyHMeVho0K7Vc/khZEPhbu1N7UPwMbVvpW8VrPISNRzRQouRyGSgyt1GL7FQV3HOxT1GpSxC9u4x48TJyURier33YoyeQU9OoxC1TBSjNLuRczsB0Arz3C9vaOeMOgoLss3Ep1D1ouLXZS7CVK/uQpMpWetU4hWYSO2immo9am0idC30CAX4EqZiSDQDBD1tT+Jpoll3xhcOHnWJopmd4RxBsd1
 8jxjO52d
 UrivvacFLT4UR0njfyCqMFoQl3YIYEu6srNrgak8mlgzcd3zn1X/OACuoaxGKFWEO/yeDlFnHCHiReJHPsumcGyGzdpJ+6CuEi5v9kH2XJ9blAJiYDmKl4IYNqKHMUNkNjzg/OhlVvTEkNPCDNlgJWXxADh0UtRXsMUB+LNkMbmFZp61NVHru1PHDvwHSyBXb4Y3dSUz2sNz1ZJ3opm03yqkJOTXmR3vCQzK4yk3SsI4zocDDY17ngEJHnT6u/v+btPQEjUGr35369ECc9131PgaSHTLSjAgeV5KslF1AVPhPyR2/iC/g7eZVtxMQWOdc0Q+Rfd7o8hSQOQ2zlHcX4K6DozlyI4lRqxCoN4pU7TaRVLPItpkkmkCkKZ5A4f8/EUU8yIHafG1EwxjDSV4DUDdQFgpnxs10QK4Z9Tt1v0n5qJ1ARi+YhECsenufrAFeGkvITQzKgcApQQ8fhpDSiXnRvYB6xF43PggO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/26 4:34 PM, Pedro Falcato wrote:
> (please use the email I actually use for work, thanks; not sure how
> you got to that one)
> 
> Hi,
> 
> On Thu, Sep 24, 2026 at 06:16:21AM +0000, Ayush Ranjan wrote:
>> Hi,
>>
>> We are seeing shmem/tmpfs page cache corruption on production hosts
>> running a workload that punches holes in a memfd (hole-punch based
>> memory reclaim) while other threads and forked children fault the
>> same MAP_SHARED mapping. The kernel taints but does not oops:
>>
>>    BUG: Bad page cache in process ...  pfn:...
>>    page dumped because: still mapped when deleted
>>    ...
>>    dentry name(?): "memfd:..."
>>
>> and, more frequently, a paired rss-counter imbalance when the mm is
>> torn down, always exactly one PMD-order folio (512 pages):
>>
>>    BUG: Bad rss-counter state mm:... type:MM_FILEPAGES  val:-512
>>    BUG: Bad rss-counter state mm:... type:MM_SHMEMPAGES val:512
>>
>> Seen on 6.12 and 6.18, x86_64, bare metal and VM, with
>> /sys/kernel/mm/transparent_hugepage/shmem_enabled = always.
>>
>> This looks like the same corruption Gregory reported in March, which
>> as far as I can tell stalled without a fix; that report needed ~100
>> ballooning VMs to reproduce:
> 
> Well, I thought (from the lack of replies) that it was probably a bug on
> their side. Perhaps that's not true :/
> 
>>
>>    https://patchew.org/linux/20260326162611.693539-1-gourry@gourry.net/
>>
>> The reproducer at the end of this mail trips it with a single memfd,
>> no VMs or ballooning, within a few minutes on a large machine, so
>> hopefully it makes the race easier to confirm (and to test a fix
>> against).
>>
>> Here is my best understanding of the race -- corrections welcome:
>>
>> shmem guards faults against an in-progress hole punch with
>> inode->i_private: shmem_fault() -> shmem_falloc_wait() waits while
>> shmem_fallocate(PUNCH_HOLE) holds i_private. But shmem's .map_pages
>> is the generic filemap_map_pages() (shmem_vm_ops /
>> shmem_anon_vm_ops), which does not consult i_private and does not
>> take invalidate_lock, and shmem does not use invalidate_lock to
>> serialize faults against truncation the way regular filesystems do --
>> the i_private + waitq scheme stands in for it, but only shmem_fault()
>> participates in that scheme.
>>
>> So while shmem_fallocate(PUNCH_HOLE) is between
>> unmap_mapping_range() and shmem_truncate_range(), a concurrent
>> fault-around can (re-)install PTEs for folios that are about to be
>> truncated:
>>
>>    - filemap_map_pages() samples mm_counter_file(folio) once per batch
>>      and applies it with add_mm_counter() after mapping; if the
>>      folio's swapbacked state changes while it is concurrently torn
> 
> But that cannot happen? We hold the folio lock in filemap_map_pages().
> The folio (naturally) cannot be torn down while we have the folio lock.
> 
>>      down, the map-time counter (MM_FILEPAGES) and the zap-time
>>      counter (MM_SHMEMPAGES) disagree by exactly one folio -- the
>>      +/-512 imbalance above.
>>
>>    - a folio re-mapped in this window (by fault-around directly, or
>>      via a child VMA whose PTEs copy_page_range() installs after
>>      unmap_mapping_range() has already walked the i_mmap tree -- the
>>      dup_mmap() variant discussed in the earlier thread) can be
>>      deleted from the page cache while still mapped -> "still mapped
>>      when deleted".
> 
> No, I don't think this paragraph is true. Page cache truncation (via
> truncate, or fallocate PUNCH_HOLE) takes the folio lock for each folio
> that is about to be truncated out. Mapping folios takes the folio lock
> as well, except in the fork() case where a myriad of weird interval tree
> + PTE lock interactions make it safe (AIUI).

Agree.

However, I did previously fix a race between filemap_map_pages() and 
truncation that caused incorrect folio mappings, and I believe this race 
also exists in shmem. Ayush, could you check whether that fix is present 
in your kernel?

f58df566524e ("mm: filemap: fix nr_pages calculation overflow in 
filemap_map_pages()")

>> Reproducer
>> ----------
>>
>> The race is on PMD-order folios, so khugepaged needs to scan
>> aggressively (with the default 10s scan interval the punched ranges
>> are not re-collapsed fast enough to reproduce quickly):
>>
>>    echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled
>>    cd /sys/kernel/mm/transparent_hugepage/khugepaged
>>    echo 1    > scan_sleep_millisecs
>>    echo 4096 > pages_to_scan
>>    echo 511  > max_ptes_none
>>
>>    cc -O2 -pthread -o repro repro_shmem_punch_race.c
>>    for i in $(seq $(( $(nproc) / 3 ))); do ./repro 60 & done; wait
>>    # watch: dmesg -w
>>
>> On a 112-CPU host this trips within ~2-5 minutes; this capture is
>> from 6.12.0-204.92.4.4.3.el9uek.x86_64:
> 
> Awesome that you have a reproducer! Have you reproduced this on a mainline
> kernel? Enterprise kernels are not supported upstream.

I've been trying to reproduce the issue on v7.3.0-rc1 for half an hour 
now with Ayush's reproducer, but haven't been able to trigger it.

