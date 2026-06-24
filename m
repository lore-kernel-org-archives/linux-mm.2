Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E481CDB47C
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 11:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED2A16B0088; Wed, 24 Jun 2026 07:08:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E837F6B008A; Wed, 24 Jun 2026 07:08:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D728F6B008C; Wed, 24 Jun 2026 07:08:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC2E66B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 07:08:20 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 342121A02D9
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:08:20 +0000 (UTC)
X-FDA: 84914532360.04.5255723
Received: from mail-pf1-f194.google.com (mail-pf1-f194.google.com [209.85.210.194])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2FDE640007
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 11:08:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLMW2Mh5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782299298;
	b=xyq0gHw6DMel6Z5dGjiN5BY1m0l+2o9ZQ/drgjNcthZkHrs/TcS1clrLJFLITbxPYJWQXT
	dselA+9LXBNhxDzyvZTrh7uIcqDiQYdxa89rcqv+8BV0Dk8FtQ1U5GbeK1sa5hYx6Fr7O+
	KcewmVb2C2me98gayy/BJenW8fIzK48=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782299298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXtuRuNUX2Rp2ayyKmvIq6nuFd+B5mhsEfkXh3sxMRw=;
	b=cvRci7Gvj90PWAkXP89bewE3Ms6Q9HQZVdwva1qzUuKTlNF/r6eKC+mxtD0ygT/CCLBJ5o
	09dimYpH+bYkCrLNF1Rgu50P3vczik+HGTSSoP+1IUk66d0lTdp+kj5bkaN+xPct/YtSXd
	5ml88LxtfxWZoSRL1dhFv0rNOEoXF10=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLMW2Mh5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.210.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pf1-f194.google.com with SMTP id d2e1a72fcca58-845a3c05df9so659671b3a.3
        for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782299297; x=1782904097; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yXtuRuNUX2Rp2ayyKmvIq6nuFd+B5mhsEfkXh3sxMRw=;
        b=hLMW2Mh524rz0+rhoM+JJhjib1mCdfV/m6YMHUtEOxj5F/I/PMU3ARnltLE9qURlgJ
         mSZy4+9D/y3c3XK2MvMw1r6t2tYaWvVJwmyF0YgOELcxVCxJOoqLLf4xitragXi3HhZC
         XXZ1nCEtB4Z9BqNNA5VujGPhTyvEAqZI6MKri08lZhwQOF6VHtfkrpddj2oG6QQEYXFA
         CnpJtRF3VCUUSooqE47Cx5HK0PxXc/Esix/pMerlk/0wU5FbD06Q7dSV1emdFtOPhZ/D
         VDturEPrrOoiYamZouemKvZ8U1xLspv1ypbc+FxkQ/zsPSPzYSlviZLzh8Vl0ywoB61k
         FMTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782299297; x=1782904097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yXtuRuNUX2Rp2ayyKmvIq6nuFd+B5mhsEfkXh3sxMRw=;
        b=VpmA80VhrOwns7KKrTyCsfmXOb549qfXmUNYAzTUyOUOi89VLvW+WPvlopFNiabP2u
         xqGjmw0NWmd6YMA0a72PIUlLi4HHAdIeNywbb8gmcosIaIETEwRCoMCQHZZif+5v2Iuu
         rM35vLMel4niu1BTp4tObNDlBDqVTrYUYuFJsehtybLfNjRO9yXl24EzITQh9UYbVi9R
         4+VauaNE8xSVO9mSr9KwTqt2WMwTH5gtTtlHMcbQbA/g8kjdtuuak8kUd0OiyDXCjRCd
         EOJ1NIoWM/XiNjPit/ffm7qSbOLMT0wM5CE3FhpSa72vjG/axKCpz2gORECBGplFyTal
         fosQ==
X-Forwarded-Encrypted: i=1; AFNElJ/mZEijN2bG5bykuXvoc0jtP7x6JEr8sbKg5c0+hbu0SjLuWd8auD5WO05WtFQsDBFjR86EJMgAvA==@kvack.org
X-Gm-Message-State: AOJu0Yxmm9S2gfE5a6eMRdsyKHyE4dDdb1/J5/oW7GNoPFkvw+mKAaY8
	rJw18RVphKlONfo3+xdlwDXQEIherSDtLlZQUAfROYIQU9Ra/xefuwrM
X-Gm-Gg: AfdE7cnvI6HaMvHAGeGW4oKJ6lIgU13RB0Jix24yhwBP8qoavoMxJkWmF7gk+Q/2/9t
	58Zl0MLEhH1uWn3+OG1EIT9Hd0u27zCoDlPzl5gFKn0zpzwCrDQts9zoLy7LwhpFsExwB/Mway+
	l5Odhxl8vfwIgIjUxILEpuCITjW+Qk5uJ/f0KNzGyW6VE5gAAdZsWDFUuOT5FImxRXserNytbp8
	dlAtmj1W52W7vN1tCdvgAtvtnenUtdRJjyJusF7aL+5AMAJzZh5BDZwp9+1SeKFqibjgzf8Lqee
	L3jxdrVusKAQK13AmC5lpgO2CJqeoPHbk+2o3Vt5DXMDRI6e4s0zzjHhQf4xqAF1+lDuul9/cnz
	jgzVphWlT/ydv9W237idnuJhaWimacKbjz7pUeRdDr/7Mc3n289fB5SlI8Mea7wFiXlx4539rUe
	b8bgGsBAd3/zaFpU35JT2v
X-Received: by 2002:a05:6a00:a112:b0:82f:50cd:e586 with SMTP id d2e1a72fcca58-845a2ae22e4mr3475551b3a.13.1782299296908;
        Wed, 24 Jun 2026 04:08:16 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-845a4002c51sm1926735b3a.27.2026.06.24.04.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 04:08:15 -0700 (PDT)
Message-ID: <ca1115c0-1509-453a-8235-08e381a3da6f@gmail.com>
Date: Wed, 24 Jun 2026 19:08:06 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 david@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 bigeasy@linutronix.de, clrkwllms@kernel.org, Alexander.Krabler@kuka.com,
 Hugh Dickins <hughd@google.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
 <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
 <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
 <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2FDE640007
X-Rspam-User: 
X-Stat-Signature: pdx3sukpny3k4knnq7dss4coddzr7f6s
X-HE-Tag: 1782299297-177517
X-HE-Meta: U2FsdGVkX18pIsfr4VDkZkznB8VjDC6KQTJiLQ3soSPFAkovqb6ANl7T9XaU2j3hVSXtufMuEGE34dUPbX82ovz0nV9DRBUxp/eIQsN8hXcbxPs3nFG8EqKAI/MZbcvAQIjIYl45QY07q83Tx937CD/yMNQxBDALk4tklDgc/Z+6HxDsAfoGxwas6UzJa2y9JGRGqHSETiVhd9wqPjSo0QFneKwiMk1Iv8P7J/acs6mjxcSGMiMkN9FLscFrpap6zLIqo8Li+l7OgO0i+iDJhKbHolkAPS5mRYdWuASqspZiINWngY64KPgRt4e0hC192nNvFsxzB7/DjhNsJs+sqfficAaIJFGnNv/I8UQetqOnPMdWRvjonqnA6ULjOAlDgBXwvxr5Q90TN27btXKPop7nZmh9ATY7hC6gUYA2jumT2gpPqU+EHEZZ9HIa6FjeitgT6xXTPZYbtVh8TkbmrE2ZmKN5HegLtiDOAZgkvLnskvSDqHzLGKPL5HTa5xgIXCQ/4bU0RClAi+Txp85LTsiWs7XFFB/jONGwT8aiaXJaK4CKCvTSR/kN5KJXhgkSTUXx3RONol2V+j3KOJhh4kJmoILlPkyhFBP1siwTv1vJEtmEn+sNddEuWs/uU0ntdPDs4AF+ZPs27Z2EcYN8jqhKjWcdHk+BvpoedGvK9epsD2r/PaWwpra9iSeAeuqRTrJtfeT7SHf317x3y8Iof1/6vEKUaQ5Y19wCtluRdqt47+nXn1dTWbuUwLmM//ZAffkCnLJxPzu0LDf/fFcmEH88L0XbTde3f9Q8DP+Uxmb3FSSCDEQL0WghY/OotEAB2iuzSvRWqTZMX6+W7k3eSFz4jHKDzUKz3JJUd211hT/cnWzOD9QKNkIE/p6ZBVwewHb3Z4PkQjI74KiuSp+2t0/ag///rEwKoAevfCcmW9XnXzdQyih2kIGMA6iEaUsDV5+V2sc59kMNRS3nXa7
 zK6t7rGI
 H4JJ1XzEcywQBakij6Qv8M9SSnhvHnyaWrcApUcYZ5x9dgbsymYAEmVGzh97lsh+GzZgDo6QIBJDTLeyw3R1leA0pYd5hmcsgsJYHUtKR1MdxbHDSgwOw2iODelIKgClP2ZEUeIupSSlar1dPXwDmjEBUeRCCgxis/t8XhqzD75cLTQ7hTFJrGYs9ZeN4zVVs7EawhbxFsujgxeNuZ5nX98yDlxhXW06npfUpA352qHXTy1642+ewUzff24AiqxQl+Yl5TOfbaJOKNTUzUIwCJtR+8Ifr6UWqnsPwTW40QEYPiFFUVwJBHF2CPslVHDMu9mCUdbrNXGbsnK5CT7bisqUsPtSxxeR03C1pdkoUcDGuMgwAoUblDEy/hXLtcDAF4BLbWaTAa0LEOxsW7V8jJB+q3GweXI7gG0kwXUJu+sVRwtnk7QggAVsAYPXfX+BJaIYf1uXpMNuKHLaJKnqxXvbVrJlOZGDyJdZ4jY8lXGfyckVCbauLOMXinFFW+egmZTq5kM3G0rwT1RFKJA9nRf9su/8jqdpO1wMvbrk7GlqvVueWu0zcNx52XGlEiGMXNaGpRfodDyWPBifQHGzMuQo2rERfa/TvilAa0aLzo/Kvs+RdvgEeZ5Z4+2zqytwmHQ1L2BKsczo7yik1/yOa933lsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/22/26 17:55, Vlastimil Babka (SUSE) wrote:
> On 6/18/26 13:43, Wandun wrote:
>>
>>
>> On 6/18/26 02:52, Vlastimil Babka (SUSE) wrote:
>>> On 6/4/26 04:38, Wandun Chen wrote:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> compact_unevictable_allowed is default 0 under PREEMPT_RT,
>>>> isolate_migratepages_block() skips folios with PG_unevictable set.
>>>> However, mlock_folio() sets PG_mlocked immediately but defers
>>>> PG_unevictable to mlock_folio_batch(), result in a folio with
>>>> PG_mlocked=1 but PG_unevictable=0. Compaction will isolate such a
>>>> folio.
>>>>
>>>> Fix by checking folio_test_mlocked() together with the existing
>>>> folio_test_unevictable() check.
>>>>
>>>> A similar issue has been reported by Alexander Krabler on a 6.12-rt
>>>> aarch64 system. Vlastimil suggested to check the mlocked flag [1].
>>>>
>>>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>>>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
>>>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>>> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]
>>>
>>> Well in that thread, Hugh doubted my suggestion and then it seems we didn't
>>> concluded anything. Did you actually in practice observe the issue that
>>> Alexander had, and that this patch fixed it, or is that theoretical?
>>>
>> Yes, I wrote a test case that can reproduce it in a few second.
>>
>> The test case contains 3 steps:
>> 1. mlockall
>> 2. mmap file(2GB) + trigger file write page fault;
>> 3. during step 1, trigger compact via /proc/sys/vm/compact_memory
>>
>>
>> My reproduction environment is qemu with 4GB ram, 8 core, aarch64,
>> preempt_rt and includes the tracepoint in patch 02.
>> After running the reproduction program for a few seconds, the
>> following output appears.
> 
> Ah, nice.
> 
>> repro-403     [004] ....1   101.270505: mm_compaction_isolate_folio: pfn=0x71e3a mode=0x0 flags=referenced|uptodate|mlocked
>> repro-403     [004] ....1   101.270507: mm_compaction_isolate_folio: pfn=0x71e3b mode=0x0 flags=referenced|uptodate|mlocked
>> repro-403     [004] ....1   101.270513: mm_compaction_isolate_folio: pfn=0x71e3c mode=0x0 flags=referenced|uptodate|mlocked
>> repro-403     [004] ....1   101.270515: mm_compaction_isolate_folio: pfn=0x71e3d mode=0x0 flags=uptodate|mlocked
>> repro-403     [004] ....1   101.270517: mm_compaction_isolate_folio: pfn=0x71e3e mode=0x0 flags=uptodate|mlocked
>> repro-403     [004] ....1   101.270520: mm_compaction_isolate_folio: pfn=0x71e3f mode=0x0 flags=uptodate|mlocked
>>
>>
>> Unfortunately, I recently found that there is still a bug in the
>> fix patch. Setting mlocked in the mlock_folio function could happen
>> even after the page is successfully isolated, so it still cannot
>> prevent migration. Because of this, I need to think more about how
>> to fix it.
>>
>> Perhaps we should double-check whether the page is mlocked during
>> the actual migration phase.
> 
> So IIUC the isolation+migration might be started between the folio is
> allocated, and mlocked? In that case the check during migration could still

Yes, in that case it still be racy, it is not a good idea to check page flags.

> be racy, and if the page is isolated, it's already bad for the RT process.

IIUC, more accurately, the migration entry in the page talbe is real a bad for
RT process, because isolate page doesn't modify the page table, so memory
access continues as usual, therefore a new idea occur.

S1. In the mlock[all] syscall, if mlock_vma_pages_range hit a migration entry,
    then, it should wait for the migration to complete.

S2. During the unmap phase of memory migration, prevent a page from being unmapped
    if the page's associated vma is markd with VM_LOCKED, similar to how reclaim is
    disabled for pages in a VM_LOCKED vma(try_to_unmap_one).


For a page handled during the mlock[all] syscall:
  - if migration has been already finished, there is noting to do;
  - if migration is in progress and the migration etnry is already filled, we
    wait (S1)
  - if the page is in-fight, going to be isolated/migrated, S2 prevents the unmap.

For a page handled during a page fault: VM_LOCKED is already set on the vma,
so S2 guarantees it will not be unmapped, hence no migration entry.


Thanks a lot for the detailed feedback, Vlastimil.

Best regards,
Wandun


> 
> So this would only be a short-term problem after the mlockall, but we don't
> have a way for the RT process to know the moment it's all settled, right?

Yes, some pages may have been isolated and will do migration.

> Probably the proper solution would be for mlock[all]() itself to wait for an
> isolated page, and only continue once it knows it can't be isolated anymore.
> This might howver would go against some of the folio batching optimizations?
> 
>> What do you think of this best-effort approach?
>>
>>
>> Best regards,
>> Wandun
>>
>>
>>
>>
>>
>> The full reproducer is as below:
>>
>> /* gcc repro.c -o repro -lpthread */
>>
>> #define _GNU_SOURCE
>> #include <fcntl.h>
>> #include <pthread.h>
>> #include <stdio.h>
>> #include <stdlib.h>
>> #include <sys/mman.h>
>> #include <unistd.h>
>>
>> #define PAGE_SIZE       4096
>> #define NR_PAGES        32
>> #define FILE_SIZE       (2ULL * 1024 * 1024 * 1024)
>>
>> static void *worker_fn(void *arg)
>> {
>> 	int fd = (long)arg;
>> 	size_t len = (size_t)FILE_SIZE;
>> 	char *p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>> 	if (p == MAP_FAILED)
>> 		return NULL;
>>
>> 	for (size_t off = 0; off + NR_PAGES * PAGE_SIZE <= len;
>> 	     off += NR_PAGES * PAGE_SIZE) {
>> 		for (int i = 0; i < NR_PAGES; i++)
>> 			p[off + i * PAGE_SIZE] = 1;
>> 		usleep(200);
>> 	}
>>
>> 	munmap(p, len);
>> 	return NULL;
>> }
>>
>> static void *compact_fn(void *arg)
>> {
>> 	(void)arg;
>> 	int fd = open("/proc/sys/vm/compact_memory", O_WRONLY);
>> 	if (fd < 0)
>> 		return NULL;
>>
>> 	while (1) {
>> 		if (write(fd, "1", 1) < 0) {}
>> 		usleep(5000);
>> 	}
>> }
>>
>> int main(void)
>> {
>> 	mlockall(MCL_CURRENT | MCL_FUTURE);
>>
>> 	int fd = open("./repro_largefile.dat", O_RDWR | O_CREAT, 0600);
>> 	if (fd < 0)
>> 		return 1;
>> 	unlink("./repro_largefile.dat");
>> 	if (ftruncate(fd, (off_t)FILE_SIZE) < 0)
>> 		return 1;
>>
>> 	printf("repro_largefile: 1 worker, %d pages/batch, Ctrl-C to stop\n",
>> 	       NR_PAGES);
>>
>> 	pthread_t compact, worker;
>> 	pthread_create(&compact, NULL, compact_fn, NULL);
>> 	pthread_create(&worker, NULL, worker_fn, (void *)(long)fd);
>>
>> 	pthread_join(worker, NULL);
>> 	return 0;
>> }
>>
>>>> ---
>>>>  mm/compaction.c | 3 ++-
>>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>> index b776f35ad020..7e07b792bcb5 100644
>>>> --- a/mm/compaction.c
>>>> +++ b/mm/compaction.c
>>>> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>>  		is_unevictable = folio_test_unevictable(folio);
>>>>  
>>>>  		/* Compaction might skip unevictable pages but CMA takes them */
>>>> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
>>>> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
>>>> +		    (is_unevictable || folio_test_mlocked(folio)))
>>>>  			goto isolate_fail_put;
>>>>  
>>>>  		/*
>>>
>>
> 


