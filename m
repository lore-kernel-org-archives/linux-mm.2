Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 110B3CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E91D6B0088; Thu, 18 Jun 2026 08:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09AD36B0096; Thu, 18 Jun 2026 08:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBAA6B0098; Thu, 18 Jun 2026 08:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF2386B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:03:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1060440736
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:43:25 +0000 (UTC)
X-FDA: 84892847970.06.5A0E922
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1A28FA0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:43:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a15r0v6g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3uy+wslaGLTlcCcaujHMpqPGyDzguwt0VkdpSQM6UeA=;
	b=5dHgx63yNfnBareaDMqB8zwcIl5UOoOYlLMHKRQtV0jfOcxtGZyHsz0hByH1Nm+/mkLnZK
	z+Gh+GJhQapzfCK+5ZLXtKleaxg5HgHrNwvND9uza1xp6GKJsCbcUcAYSsi3H4nRMjBdH/
	IeH6g315EAImAMNXeKY8hRdTmqK0eEk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=a15r0v6g;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783003;
	b=ddH/lrBMMz5Fi34hzVRATtrcHoRLlV6PDlUqjFF+XhfxV0L0ZM2bjIvTmTpN26yte+txuF
	3NfwyZjVgCcCa8eYTFfV3tm6za+L2qB1RzYRs2UP83wrD/uI5PvXeCtfs1tcR33DhrWgEX
	7NaYuxrvzqL8fWKrtN60gNL9+yn6rhs=
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-36d630c0e35so767832a91.3
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781783002; x=1782387802; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3uy+wslaGLTlcCcaujHMpqPGyDzguwt0VkdpSQM6UeA=;
        b=a15r0v6gjosrhZaABFO2BWoXhQE7nxhxz/+C2axLHzCJUUDXDS7t8ui+IgiMOKWzJN
         jvUXaHh4nbI5P1SqWVAZpcU2vYgKx50bDpfHZsC8Jz2djWIZfQo47jF7GJnIuxRmazcZ
         3CKq0ikHVWqb7KVHBph8B5XszQTX3JHVjdkW5wcMXDfrI2+jKPAHeKH1QEGJqns/C2t4
         IeQwIgPZSKJO1gqsylxu0197k1KaklTdCg3v7Rw+Sy0ZVNBvQkgJRvasqOAPWkVn5Wcn
         Cao8/xsS9yQRbcRAzKY8z+wLtZORB56b0091t/QSCXe5xyqflX2A3Sgbjk437QZLSCeb
         Bfgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781783002; x=1782387802;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3uy+wslaGLTlcCcaujHMpqPGyDzguwt0VkdpSQM6UeA=;
        b=P1QQj+7j6g47resl6xlWc+tnsbH3a50Y0eapwLvMJSyE8faWgi+7VfYxbpdzUHAqBi
         yOqwhlijRYSaBBx59ZlDzyGqKbZ4deIvTw49KdaxDhWIV4Iz0EjWwVAb7pMy78ADYLB2
         kWkNHB25TDO7VIXg1SPkgfE2gaywbx3Igdzc4Ll2hnD5o/emuoIjN1BHIHOXQ+ejESx7
         +z9BsxCJVuLGqJCQxVb2yAvLjEpeEL7nF0U5chticpIzrbfoqPi6EeLq9tp87jSEph0b
         3hVX7NEA5K0V8aceCkb23bJ7vMWkxMS57Ff//X0YsIeG19p/cUCV+EGC5kBJQGLj3i4e
         TcJA==
X-Forwarded-Encrypted: i=1; AFNElJ99gNBqWQMzSgfIT0czCq3OOQNQkb0ETkopGHYUhOBkfWrqea01EDWGuFnqfYWhtG+xa1ybM/SvsQ==@kvack.org
X-Gm-Message-State: AOJu0YwNfF1Kf6qOjo/6kiDGPbXRDQkoiWeSIwGo4QoZNxnqoYD2nO0e
	YSyx08DRr//dTrnzQOo3274CvipBJNc3J6vEtyZ8O8bk4Qo/8HFHIEtY
X-Gm-Gg: AfdE7ckU1N+aT3Btsra9OtkCPouer4UnjQ/JEkEuN+NDPWD2ayGoCH4x1Opvui3bPfK
	XndxDBDgXYwQgo9RP+5i6X3iSRhvX+uDOFGO4yBZnVtVqBdp6GZ12OIBPo08pk3cE2BEHN3rxjn
	5seHQgrCYYcn5+RVRCmsv3mQJRm3V0soPpDLI81xv9y1NcFVoLESoNyf0sI+1EuicFz1+h9y0PZ
	KBODFuPOaymb6Fk1lnjITPaTCojjZBz9M3RbPEgHjpTk5OmImsstbnhzTSx3DQFnm9MipfWEnyi
	P4IojFssvHldLoq0kprFI+0lvXbjFG+3P3XpJ9aFQw8HpYWRq5959AAxB+sZUruz+Anq6mVfRG0
	XlKE1I3oaGdYSTVePsIkrWPOQolEGZyJJ/2b9h4rEKzp7f7ZAz851elYE3vMG3ppuuh+35YVsvC
	oHWYcZ+jnz1Oks2FUqfGdI36EYPmIbC6E=
X-Received: by 2002:a17:90b:3a43:b0:368:7c0f:ebf7 with SMTP id 98e67ed59e1d1-37ce45455d8mr3452661a91.16.1781783000992;
        Thu, 18 Jun 2026 04:43:20 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c866325e477sm16709082a12.10.2026.06.18.04.43.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Jun 2026 04:43:19 -0700 (PDT)
Message-ID: <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
Date: Thu, 18 Jun 2026 19:43:09 +0800
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
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 7wjgongec5bi8f8g45mruyhez1du7f6i
X-Rspamd-Queue-Id: 1A28FA0005
X-HE-Tag: 1781783002-962547
X-HE-Meta: U2FsdGVkX1+VdSv5RGzZWs5OR5XVe5rqMudRRW+mX2mHhUFy+Bn75sz6/oU9qYV0dmqmq+gX2fOBVcyrxzO4s83ZMV1mWwxfty4naB2mw2xg+FJE/bea/3Dh9PDtgoM+f336ikmIEJzgi/USzF4FnyCc/QEiJfJnpWpqjuzmIXAapDEn+xnSscap5P3jMDthKeNxdDI9NlVk6bJ72eOCPuC1jpC6BU6uXSLwI4Yp/vG4yHvpxdXZmDwVrJ/uA5bJy+GkYReIDQWMMCQbd4NQB+2HYGSt4Q4ONzlRlU1o7/M7jPN+eQoNH7MsRVNb5KtDBsnK7B/gC4Sv+V1gTPUAbRaIeEf3VDHUee1IlcWra9LgMNMC1r98QwnufLXcCNAdLlBSAfGmUVeMiOwihBiQXH5K4nTTAnaeNK9sKlTVbC9VOzhIqRrDT4ItkRG0Pd3RTuFe2m1NJxlTvdyf9lfFtooUe46O7YJkIwpWxbzYzPKfcvsG5B6VZouaVaZ6uT6XPshdI9qHonDPC6qLzwqBjLaXrYaE7PSO+6djFtDPs3aeXGAnzTLbBYzbQcrNUR3MP5MHMrKNvNwOWrUrPf0eVNS8s03m68+kOTFVMK6FaqnSqrN9W43arHOPaczUO8vImC0lC+0zTTQruhdko+DeR4MyQi36oo6cjHfjNNZmfaegGnW706BB4/XKDZNhlcU3WY8firPyCvHFVXuTT+29KnQwjVnjCUw9RIdG46PCyJ/bOCE8yzrzPyCBhZtwyyIIrqGGx3Cuo/af6pc/l/uJ+gqo9xByaV1fic27vk1UDsyKe8CPxWS8WvrFQE/lLdZWm6ErB7BUPOmLDDd9OFv9is2CzS04RY7ADJtQZy1UvpecNCB0aqauNJkS5V+oOEy+SO6yNUkEiu5GQu1P2B0SRLsjZ73nIm8/jBuQIojLMcrBbSFO/AIn86I0K/9+RD/DCy2NUXZcipKzScxxBCe
 m76XV29G
 X8R+pTOicHUH3neV0Bp2g9lzY3ZIcplU8oabl0BvkotiylEMt0OL+nULM0toeBQ5BBehdzkw5Q3ZugO8oFIwz3JTiSDk/zhafb27rKJ308gvXv/0VsO4JAbM/C6MhwMqLbyCpoNAVDp5I6tDbxJZfOeoppy3IRxtzcS4Z3+l5J9/KBXFJuwCYkQwq5/QhutvLbb9ABoQwdUQdO5Y6Mwjp0xzmZR1pZHNAlFjTNzr7SqegNBpFhMjJB8gYe2vrdTzcK5ZXFeY9jx6jCGBFBJBWsAyEQAPp3wE7EaafPVthJEllVhrDf/CvVrk7cvXOzbTa8ZE7GsLQpONNYkoIPBG+wLkKTTtt5EP8Kk9kFR+ZydcdZpOrM13Wp66hzJPIyeyFoSa4yceJnKV/nDEN17kU5p8IaMazwib2LgztAytFauvtcSCK8dkIu/m94wxlVmWB1tLJRga46hWs4R/6K8SFjzlOnIgv9VrV1Pvr1/KYbKOtkroQCxlim34zW5177g0CljmmgqgGuYsDmRk1HvFsGOnQZ9ZHvU048YTj5wBzv3/aPKBza+RiwhRIfT/yoNRwqSv65ZITYPAPdAjzmIRyV4AtiGQ/yN3tgEafVzYR6xjFWj2OqNm8pixRMRzD3RBj5jfdeCOhRi/XozhRctsythtDJBV/9ibJgfH+aXhgxv65eLJpyw8qMGhNAOFtHf8B2kkXeSR66Dg+aPntkkapL4lQFZxmJOjGVyHUA/E2Mjt1hUo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/26 02:52, Vlastimil Babka (SUSE) wrote:
> On 6/4/26 04:38, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> compact_unevictable_allowed is default 0 under PREEMPT_RT,
>> isolate_migratepages_block() skips folios with PG_unevictable set.
>> However, mlock_folio() sets PG_mlocked immediately but defers
>> PG_unevictable to mlock_folio_batch(), result in a folio with
>> PG_mlocked=1 but PG_unevictable=0. Compaction will isolate such a
>> folio.
>>
>> Fix by checking folio_test_mlocked() together with the existing
>> folio_test_unevictable() check.
>>
>> A similar issue has been reported by Alexander Krabler on a 6.12-rt
>> aarch64 system. Vlastimil suggested to check the mlocked flag [1].
>>
>> Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
>> Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
>> Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]
> 
> Well in that thread, Hugh doubted my suggestion and then it seems we didn't
> concluded anything. Did you actually in practice observe the issue that
> Alexander had, and that this patch fixed it, or is that theoretical?
> 
Yes, I wrote a test case that can reproduce it in a few second.

The test case contains 3 steps:
1. mlockall
2. mmap file(2GB) + trigger file write page fault;
3. during step 1, trigger compact via /proc/sys/vm/compact_memory


My reproduction environment is qemu with 4GB ram, 8 core, aarch64,
preempt_rt and includes the tracepoint in patch 02.
After running the reproduction program for a few seconds, the
following output appears.

repro-403     [004] ....1   101.270505: mm_compaction_isolate_folio: pfn=0x71e3a mode=0x0 flags=referenced|uptodate|mlocked
repro-403     [004] ....1   101.270507: mm_compaction_isolate_folio: pfn=0x71e3b mode=0x0 flags=referenced|uptodate|mlocked
repro-403     [004] ....1   101.270513: mm_compaction_isolate_folio: pfn=0x71e3c mode=0x0 flags=referenced|uptodate|mlocked
repro-403     [004] ....1   101.270515: mm_compaction_isolate_folio: pfn=0x71e3d mode=0x0 flags=uptodate|mlocked
repro-403     [004] ....1   101.270517: mm_compaction_isolate_folio: pfn=0x71e3e mode=0x0 flags=uptodate|mlocked
repro-403     [004] ....1   101.270520: mm_compaction_isolate_folio: pfn=0x71e3f mode=0x0 flags=uptodate|mlocked


Unfortunately, I recently found that there is still a bug in the
fix patch. Setting mlocked in the mlock_folio function could happen
even after the page is successfully isolated, so it still cannot
prevent migration. Because of this, I need to think more about how
to fix it.

Perhaps we should double-check whether the page is mlocked during
the actual migration phase.

What do you think of this best-effort approach?


Best regards,
Wandun





The full reproducer is as below:

/* gcc repro.c -o repro -lpthread */

#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <unistd.h>

#define PAGE_SIZE       4096
#define NR_PAGES        32
#define FILE_SIZE       (2ULL * 1024 * 1024 * 1024)

static void *worker_fn(void *arg)
{
	int fd = (long)arg;
	size_t len = (size_t)FILE_SIZE;
	char *p = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED)
		return NULL;

	for (size_t off = 0; off + NR_PAGES * PAGE_SIZE <= len;
	     off += NR_PAGES * PAGE_SIZE) {
		for (int i = 0; i < NR_PAGES; i++)
			p[off + i * PAGE_SIZE] = 1;
		usleep(200);
	}

	munmap(p, len);
	return NULL;
}

static void *compact_fn(void *arg)
{
	(void)arg;
	int fd = open("/proc/sys/vm/compact_memory", O_WRONLY);
	if (fd < 0)
		return NULL;

	while (1) {
		if (write(fd, "1", 1) < 0) {}
		usleep(5000);
	}
}

int main(void)
{
	mlockall(MCL_CURRENT | MCL_FUTURE);

	int fd = open("./repro_largefile.dat", O_RDWR | O_CREAT, 0600);
	if (fd < 0)
		return 1;
	unlink("./repro_largefile.dat");
	if (ftruncate(fd, (off_t)FILE_SIZE) < 0)
		return 1;

	printf("repro_largefile: 1 worker, %d pages/batch, Ctrl-C to stop\n",
	       NR_PAGES);

	pthread_t compact, worker;
	pthread_create(&compact, NULL, compact_fn, NULL);
	pthread_create(&worker, NULL, worker_fn, (void *)(long)fd);

	pthread_join(worker, NULL);
	return 0;
}

>> ---
>>  mm/compaction.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index b776f35ad020..7e07b792bcb5 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>  		is_unevictable = folio_test_unevictable(folio);
>>  
>>  		/* Compaction might skip unevictable pages but CMA takes them */
>> -		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
>> +		if (!(mode & ISOLATE_UNEVICTABLE) &&
>> +		    (is_unevictable || folio_test_mlocked(folio)))
>>  			goto isolate_fail_put;
>>  
>>  		/*
> 


