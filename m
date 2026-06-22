Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD7FACDB46B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 09:55:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50706B0088; Mon, 22 Jun 2026 05:55:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01E86B008A; Mon, 22 Jun 2026 05:55:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C9356B008C; Mon, 22 Jun 2026 05:55:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6866B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 05:55:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E83F3166FE9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:55:42 +0000 (UTC)
X-FDA: 84907091724.10.D72B45B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 100AC100002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 09:55:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEYqsQ3T;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782122141;
	b=NCdvrYUWecWHMEk6b7hOrRv78cmjQk1qz8W8l+HzcwLyai/AfyYiPNrOrvUND5b7dNexUJ
	1GaE7MMkFoEZjPbQLd3lxWiMc7BiicszPq3HrEM2RIo9piafxu9LbPPsPHOV1bjT6cPIcB
	NKtdrAAPIEVPnC2TQZ7lI5+qVGkVvOE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EEYqsQ3T;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782122141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/V21/Y3QZfwVUdB3NIeBi+XnD7XL4Xt67aol7kqmo4c=;
	b=U2kIyd2wE3gbTFW2tA+q395n6+V+2gy//EY7306+Xqn4gnxwgqraWI6k991Pd66VEZDBKS
	0pbVk/bRnaHEvCIVnsvrVfhPrhSZXfvZj70Y10Z3pdjtJRBo+/SkioPcBx9mQAdJL/+U+N
	21Bgf3mQhBlQdYPhqmhbDhEiUpVfY1M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3933A40DDA;
	Mon, 22 Jun 2026 09:55:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C543F1F000E9;
	Mon, 22 Jun 2026 09:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782122140;
	bh=/V21/Y3QZfwVUdB3NIeBi+XnD7XL4Xt67aol7kqmo4c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EEYqsQ3TRB2hMmbU7Z79YG2RHRf9MC51VSumhuqrt6HrdNifmpdbgiXdj+mPOOuZn
	 cGHRNhUuRMFgZbU1FsE0Knbg9l762v4L1xpLsjiqiLdYo1UjsVXFx8uNL0eSjfJv/V
	 5JN+cQOhPTaqHR3nQdb1YKbrcAPE2GMgKGtj7ImzzeGN7tGBabXgNdAhpFhA1Hhwog
	 QunbjMB9l0vA19HXJW3S2zAexHyQyNTuyvQMRklcEFQVJl92ZZdE8v0UUyEj0SYGYx
	 /wzt36/BFphiOGtrnRSXv/NkfcMiAKOwFfnjThiNUnfmtxxmy/qTB025Ec/hFKr/cq
	 TRd3NUImRxD/Q==
Message-ID: <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
Date: Mon, 22 Jun 2026 11:55:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
Content-Language: en-US
To: Wandun <chenwandun1@gmail.com>, linux-mm@kvack.org,
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
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dptw33c946pdgwn7ba6ggg9y74n76s71
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 100AC100002
X-HE-Tag: 1782122140-533858
X-HE-Meta: U2FsdGVkX1/veo+IXV2i+qLdMWMDN++TeDJJD85UjYcaIj+sUw4JjJ3OpAqLDzMCYogo2v8YGxf6FnKlEIAFRCJflBEspZZG6KuaBCxylhbkugUjoF++WnUgnqG5WPnZf+2MG5JlBtEWVNKxmIlVq8sDmhkZvRVDQ8Y8BfnzYpqYmTw2eRWK/WpkYw9S2BhQ7/93IkBGB91CzzE1u/fbEcx1W/Ybz/MKLrOJ5ZRXUsspktcNBe12aqPIi2lQaBV+o6WCXl/yMoKNyS1wNA4WhaxhUIGsjc+mJaEVK6lX6/cMgHJuI2j/JB5ClcPriFEImTmEYU9OE33V+m99MncZBstfmtT3q7t6Kyucoauutcgxe6ezpSDubltiZZlJeyJRS3q8ddIqyXcr6/nU0T6g18CbVy4MN7tOb1mI0+PbgNksWZ/I9eh7U30UF9PWuB/OTnosCbNZD2J9ZCjsIwsPl6n8Pl3vQcJj1ZSI5AkzCF8vPdLBFc8JYs49O4wDQgxkavcyhCCe0LC1r1sRG3eGi+KAcQHdio0t7+wkGbgA0y2UOL6g8j8UiwYevBywUypA138NPPlgMQSlqjhsTw8frkvC7oFnLjSWWbP97khmcmZd/dijunNfAUE2sQMB9ExVq842AVjr7Sq7ReXXDCAejaQ/cOrAN8LoNqjp5tXtkYpVMyjcEF50v7bQzoD2o7JdB7zYec+a0Lf7dRwW1Vat5KZ+uiphpX2+kakxntpLwffPITC349n3nJyQayDi9iSbN8MfTLoQWrovjlgs6h0B1GP192xHngcX0FLpG5hHB6MBpMTxPejOmzHum2NIL5tRKAHHFFtoLZOTm1gVhDJpqudKZFL9uicDRCXvJpLRZHEMCx01HFZKKOCDkFX/FBJNJp1seZjjMTmaatyzZqTrmiq//dHhz6XCjo9WZnYH+DtjlFZ+TvV0jqknx1Va3CcY+YRbQNG2xJtWFuVD7wm
 hO/v1SFO
 IIwayYJM54/rK17Zt56fJgRd3KSDzTlRUmBTOzsFdJtgNzAk/VaGOkRGW01n9ON1M3BG6w1U1lRCn2TWWSciq8KfCMK/S0oBShW4XcqsvGfqk9P0g+WHYGRl3k1Lt8pp4xrGpq+aP3ZLI93GV8ueWoShWNaCcRiTPKECFpiRq4I0Z72F6TDMXePQNoaGPxLYzfFqflL0w9qTlLQunj7Q4lo4+WpC+/N5jLOJ/e+CsVSDFNy+bqD9/5MdGYsx/WLugggPQzOHA0Di0kYYPI0qkLdRLtEMd5znbQ4Klr/TsfhSYjcmPnRWjr+604AOCqSelx3yk4rZRFbYLkmfTicYMPU8ypKhK6Bc1l9gzbTRLkhOs09vCxdNWKcBLAxRpJPD5kja3MiSih1hyqraKMsxj7Dc8pS92rgLZLLKfdnNg+Kxp/Hc3JCS4dUGU/81MM8PD++21RH2Fzy84ZNrToZKedgNsNqpnzRIkhC3WrOhn+3juaqP4O8UWeF2WsiFA6hSYJQHs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 13:43, Wandun wrote:
> 
> 
> On 6/18/26 02:52, Vlastimil Babka (SUSE) wrote:
>> On 6/4/26 04:38, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> compact_unevictable_allowed is default 0 under PREEMPT_RT,
>>> isolate_migratepages_block() skips folios with PG_unevictable set.
>>> However, mlock_folio() sets PG_mlocked immediately but defers
>>> PG_unevictable to mlock_folio_batch(), result in a folio with
>>> PG_mlocked=1 but PG_unevictable=0. Compaction will isolate such a
>>> folio.
>>>
>>> Fix by checking folio_test_mlocked() together with the existing
>>> folio_test_unevictable() check.
>>>
>>> A similar issue has been reported by Alexander Krabler on a 6.12-rt
>>> aarch64 system. Vlastimil suggested to check the mlocked flag [1].
>>>
>>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
>>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>>> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]
>> 
>> Well in that thread, Hugh doubted my suggestion and then it seems we didn't
>> concluded anything. Did you actually in practice observe the issue that
>> Alexander had, and that this patch fixed it, or is that theoretical?
>> 
> Yes, I wrote a test case that can reproduce it in a few second.
> 
> The test case contains 3 steps:
> 1. mlockall
> 2. mmap file(2GB) + trigger file write page fault;
> 3. during step 1, trigger compact via /proc/sys/vm/compact_memory
> 
> 
> My reproduction environment is qemu with 4GB ram, 8 core, aarch64,
> preempt_rt and includes the tracepoint in patch 02.
> After running the reproduction program for a few seconds, the
> following output appears.

Ah, nice.

> repro-403     [004] ....1   101.270505: mm_compaction_isolate_folio: pfn=0x71e3a mode=0x0 flags=referenced|uptodate|mlocked
> repro-403     [004] ....1   101.270507: mm_compaction_isolate_folio: pfn=0x71e3b mode=0x0 flags=referenced|uptodate|mlocked
> repro-403     [004] ....1   101.270513: mm_compaction_isolate_folio: pfn=0x71e3c mode=0x0 flags=referenced|uptodate|mlocked
> repro-403     [004] ....1   101.270515: mm_compaction_isolate_folio: pfn=0x71e3d mode=0x0 flags=uptodate|mlocked
> repro-403     [004] ....1   101.270517: mm_compaction_isolate_folio: pfn=0x71e3e mode=0x0 flags=uptodate|mlocked
> repro-403     [004] ....1   101.270520: mm_compaction_isolate_folio: pfn=0x71e3f mode=0x0 flags=uptodate|mlocked
> 
> 
> Unfortunately, I recently found that there is still a bug in the
> fix patch. Setting mlocked in the mlock_folio function could happen
> even after the page is successfully isolated, so it still cannot
> prevent migration. Because of this, I need to think more about how
> to fix it.
> 
> Perhaps we should double-check whether the page is mlocked during
> the actual migration phase.

So IIUC the isolation+migration might be started between the folio is
allocated, and mlocked? In that case the check during migration could still
be racy, and if the page is isolated, it's already bad for the RT process.

So this would only be a short-term problem after the mlockall, but we don't
have a way for the RT process to know the moment it's all settled, right?
Probably the proper solution would be for mlock[all]() itself to wait for an
isolated page, and only continue once it knows it can't be isolated anymore.
This might howver would go against some of the folio batching optimizations?

> What do you think of this best-effort approach?
> 
> 
> Best regards,
> Wandun
> 
> 
> 
> 
> 
> The full reproducer is as below:
> 
> /* gcc repro.c -o repro -lpthread */
> 
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <unistd.h>
> 
> #define PAGE_SIZE       4096
> #define NR_PAGES        32
> #define FILE_SIZE       (2ULL * 1024 * 1024 * 1024)
> 
> static void *worker_fn(void *arg)
> {
> 	int fd = (long)arg;
> 	size_t len = (size_t)FILE_SIZE;
> 	char *p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
> 	if (p == MAP_FAILED)
> 		return NULL;
> 
> 	for (size_t off = 0; off + NR_PAGES * PAGE_SIZE <= len;
> 	     off += NR_PAGES * PAGE_SIZE) {
> 		for (int i = 0; i < NR_PAGES; i++)
> 			p[off + i * PAGE_SIZE] = 1;
> 		usleep(200);
> 	}
> 
> 	munmap(p, len);
> 	return NULL;
> }
> 
> static void *compact_fn(void *arg)
> {
> 	(void)arg;
> 	int fd = open("/proc/sys/vm/compact_memory", O_WRONLY);
> 	if (fd < 0)
> 		return NULL;
> 
> 	while (1) {
> 		if (write(fd, "1", 1) < 0) {}
> 		usleep(5000);
> 	}
> }
> 
> int main(void)
> {
> 	mlockall(MCL_CURRENT | MCL_FUTURE);
> 
> 	int fd = open("./repro_largefile.dat", O_RDWR | O_CREAT, 0600);
> 	if (fd < 0)
> 		return 1;
> 	unlink("./repro_largefile.dat");
> 	if (ftruncate(fd, (off_t)FILE_SIZE) < 0)
> 		return 1;
> 
> 	printf("repro_largefile: 1 worker, %d pages/batch, Ctrl-C to stop\n",
> 	       NR_PAGES);
> 
> 	pthread_t compact, worker;
> 	pthread_create(&compact, NULL, compact_fn, NULL);
> 	pthread_create(&worker, NULL, worker_fn, (void *)(long)fd);
> 
> 	pthread_join(worker, NULL);
> 	return 0;
> }
> 
>>> ---
>>>  mm/compaction.c | 3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>> index b776f35ad020..7e07b792bcb5 100644
>>> --- a/mm/compaction.c
>>> +++ b/mm/compaction.c
>>> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>  		is_unevictable = folio_test_unevictable(folio);
>>>  
>>>  		/* Compaction might skip unevictable pages but CMA takes them */
>>> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
>>> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
>>> +		    (is_unevictable || folio_test_mlocked(folio)))
>>>  			goto isolate_fail_put;
>>>  
>>>  		/*
>> 
> 


