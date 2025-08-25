Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D0A9CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1375C8E0025; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1398E0001; Mon, 25 Aug 2025 09:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1818E0025; Mon, 25 Aug 2025 09:39:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D39CA8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:39:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9730B118767
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:08 +0000 (UTC)
X-FDA: 83815385976.02.DC8C4EE
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf14.hostedemail.com (Postfix) with ESMTP id 17E9E100010
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="Wun4vL/m";
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756129147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1uI8pqsofK/GNmEXp9mUWfXJG229oaayJTNKizO6zrw=;
	b=7RJ8gbqMqGUG5W9iJfAKTy40Jb0/rH8cLQqVyeMcp494JhRGpcVBu3sYUmZbIZGx6dkb9U
	57Iy1BgnqHaE0OeawG2N9EYmdO5obi6DWC+t58dJaz+sPI9ScAzYyWy4FCwEzt4ApcLeQ8
	/f3SWuCAvBEbnKU0XSep3Fcbag2ng1U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756129147; a=rsa-sha256;
	cv=none;
	b=CbFlkQaFK9aoa9FxtqR5YAXfMAHDcgnLjBORpAl2oQcLbzmOnCMYpv5WXzSdjCrDgHhfPo
	qxfMVeYQgpowvFbUgJB9MRxGjSZ9UIaB6DeA49EpPuKRVjBvgNVzYQLzVRPO8TX6IRGYD5
	j18hf8zHBqaFQctO+HZeFI8G/Q2U+Xs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b="Wun4vL/m";
	spf=pass (imf14.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=1uI8pqsofK/GNmEXp9mUWfXJG229oaayJTNKizO6zrw=;
	b=Wun4vL/mvOPwY8ZObukK2adv46/rIqHhWS5r5L9LK+0ogCDWsmQoUrE138XEHxHt2q5sqGkNm
	Z0VUDzWjl2lctQ59IfXNAnf7MYfnPT/gSfQk+999Bds4zQ8+Sj3tjpnfeJXchivXUszgGPyVcQa
	SUOrW960YSrENGB2PyoNu00=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4c9X211S54zYkxf9;
	Mon, 25 Aug 2025 21:38:49 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:39:00 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:38:59 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v5 0/2] Do not delay oom reaper when the victim is frozen
Date: Mon, 25 Aug 2025 21:38:53 +0800
Message-ID: <20250825133855.30229-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17E9E100010
X-Stat-Signature: bhgo7g75ok48onqskt6qpqpz5iyxuc1b
X-HE-Tag: 1756129145-562672
X-HE-Meta: U2FsdGVkX19IpWGufgwjmFP6Jm/BWzYm0cyFofbHh/DD1dkn5386SsabPXU6P1Yq4IF9VgtroA+FyzWi4B9rzdoLtiBGYkAXZACJBl/iUErqDN3spAS+RFs5qsuLMtkmd7AW1KEVofmQ5re8hpNrPuBag90V4CZ+bxfRKqKtVGjcJaLI3OPRx7pGBplG5m5b4jez5hyZZaM+qkOZpbh/qYeMtWxD4v3eM6V2TLYO4XidrKenLZQhF9pT6nAbRU5mUhWykNqS/WZa4NicpZioUEQK2nYPCLywe9TtnUSozqjLkBc27gd8ogJdq1upxaJQ/enWnltKUv22RDPUmoyADpyzDihsgPVxgn0YzFq8wWqtwIIwMuAFfFbmWSzEMo1CLPpzVDhDHd3SnkpbwXvE1IPJPO5nW+fQqEZfiWOHhbsc6UxKAFztEUS4t0EXggdP+FblSwR5N4bimBR3GJl7A6bppl72kY2QvEAuIQvlhhmrTdMvH9D0ghBwaP1mD4hT6L1OicCH9rd7dDYSBdhNOb8I+RYV9lCKbxwetcmxzm3DBmrR5L2eSrrzlpwZf+8DAf2ZbwQnNSN4d3bqLKN8oaF37pGbHLEFHYKSoiyfs8pe9UxYHJhTuSaqFkBZ0xM8oKMhhwrMu3gorncoF9duBrATkAIXekD5axI3kexZiSJ9z6V1fSFD7mt5GX5kBK6s+Aocb8Y6Cf9aNx4eRyqfpC4MDbSTJD/kBK1HoCaDjrVVw2yO3yeQ+w/gKxX4QK8fB1vyqReEHefGzxEcJLpz6uuN68F/5aKoeYfJV3pHnJIBK+y5fFgqB2Kw9rK6EgfNuTgXFN5iPiIo7eosoFwAO70aMKN9bjGkeujACQwvKDxY9huOrY2RsWUvjnxffODWtnYtnAyzheQPi8MdGi3Eh0O7tDhHTEyqDH/PziDfJYq6SpK90IYLI+OO5BYXqnIRW4vRyyTIx15fP7Z/2Y6
 nN31uSnl
 eJqSRyAdngVVvOElSKHzguR1OouajCBwrwh+fjk4XlNKlGkRl1q770HtuzX5XatSd7a71NQgq6d/MQp8/yij9sItP9g4+H8ZnhdHlwVTvoYaTHF8X9aUVW9jC32AMriTPKWnZkAnO2LfXzgjHprRUPXth0Qgtle5wtTKJGSbiMl1AYLUIfDPRXEc2N2LGFQk312U547x12tOjHG5k6CmpuSxD7pl9pgUmZbro8fthIuzLGgU0saKTabEFmb61kKJ6tu8Vupj7uPZe/tEqqq6BcDp4h9IqNqIGsmv14vZtcUQUTGqmg2DuMvGvjdhAcg64Kf+QpBavqFmYTwwY30BI0aFbGnozBmKs0P3p
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

patch 1 do not delay oom reaper when the victim is frozen, patch 2 makes
the OOM reaper and exit_mmap() traverse the maple tree in opposite orders
to reduce PTE lock contention caused by unmapping the same vma.

About patch 1:
Patch 1 uses frozen() to check the frozen state of a single thread to
determine if a process is frozen, rather than checking all threads,
because the frozen state of all threads in a process will eventually be
consistent. There is no need to strictly confirm that all threads are
frozen; it is only necessary to check whether the process has been frozen
or is about to be frozen.

When a process is frozen, if it cannot be unfrozen promptly, the delayed
two-second oom reaper cannot guarantee that robust futexes will not be
reaped. So the processes holding robust futexes should not be frozen.
This patch will not make issue [1] worse.

About patch 2:
I tested the changes of patch 2 on Android. The reproduction steps are as
follows: Start a process, then kill it like oom kill does, and actively add
it to the oom reaper.

The perf data applying patch 1 but not patch 2:
|--99.74%-- oom_reaper
|  |--76.67%-- unmap_page_range
|  |  |--33.70%-- __pte_offset_map_lock
|  |  |  |--98.46%-- _raw_spin_lock
|  |  |--27.61%-- free_swap_and_cache_nr
|  |  |--16.40%-- folio_remove_rmap_ptes
|  |  |--12.25%-- tlb_flush_mmu
|  |--12.61%-- tlb_finish_mmu

The perf data applying patch 1 and patch 2:
|--98.84%-- oom_reaper
|  |--53.45%-- unmap_page_range
|  |  |--24.29%-- [hit in function]
|  |  |--48.06%-- folio_remove_rmap_ptes
|  |  |--17.99%-- tlb_flush_mmu
|  |  |--1.72%-- __pte_offset_map_lock
|  |  
|  |--30.43%-- tlb_finish_mmu

It is obvious that the lock contention on the pte spinlock will be very
intense when they traverse the tree along the same path.

On low-memory Android devices, high memory pressure often requires killing
processes to free memory, which is generally accepted on Android. lmkd, a
user-space program that actively kills processes, needs to asynchronously
call process_mrelease to release memory from killed processes, similar to
the oom reaper. At the same time, OOM events are not rare. Therefore,
reducing lock contention on __oom_reap_task_mm is meaningful.

Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]

---
v4 -> v5:
1. Detect the frozen state of the process instead of checking the futex state,
   as special handling of futex locks should be avoided during OOM kill [2].
2. Use mas_find_rev() to traverse the VMA tree instead of vma_prev(), because
   vma_prev() may skip the first VMA and should not be used here. [3]
3. Just check ishould_delay_oom_reap() in queue_oom_reaper() since it is not
   hot path. [4]

v4 link:
https://lore.kernel.org/linux-mm/20250814135555.17493-1-zhongjinji@honor.com/

v3 -> v4:
1. Rename check_robust_futex() to process_has_robust_futex() for clearer
   intent.
2. Because the delay_reap parameter was added to task_will_free_mem(),
   the function is renamed to should_reap_task() to better clarify
   its purpose.
3. Add should_delay_oom_reap() to decide whether to delay OOM reap.
4. Modify the OOM reaper to traverse the maple tree in reverse order; see patch
   3 for details.
These changes improve code readability and enhance OOM reaper behavior.

v3 link:  
https://lore.kernel.org/all/20250804030341.18619-1-zhongjinji@honor.com/
https://lore.kernel.org/all/20250804030341.18619-2-zhongjinji@honor.com/

v2 -> v3:
1. It mainly fixed the error in the Subject prefix, changing it from futex to
   mm/oom_kill.
v2 link:
https://lore.kernel.org/linux-mm/20250801153649.23244-1-zhongjinji@honor.com/
https://lore.kernel.org/linux-mm/20250801153649.23244-2-zhongjinji@honor.com/

v1 -> v2:
1. Check the robust_list of all threads instead of just a single thread.
v1 link:
https://lore.kernel.org/linux-mm/20250731102904.8615-1-zhongjinji@honor.com/

Reference:
https://lore.kernel.org/linux-mm/aKRWtjRhE_HgFlp2@tiehlicka/ [2]
https://lore.kernel.org/linux-mm/26larxehoe3a627s4fxsqghriwctays4opm4hhme3uk7ybjc5r@pmwh4s4yv7lm/
[3]
https://lore.kernel.org/linux-mm/d5013a33-c08a-44c5-a67f-9dc8fd73c969@lucifer.local/ [4]

*** BLURB HERE ***

zhongjinji (2):
  mm/oom_kill: Do not delay oom reaper when the victim is frozen
  mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple
    tree in opposite order

 mm/oom_kill.c | 49 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 46 insertions(+), 3 deletions(-)

-- 
2.17.1


