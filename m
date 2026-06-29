Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E6CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6D016B0005; Mon, 29 Jun 2026 05:07:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1E2E6B0088; Mon, 29 Jun 2026 05:07:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBFAF6B008A; Mon, 29 Jun 2026 05:07:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D12A6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:07:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 112B7167A65
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:53 +0000 (UTC)
X-FDA: 84932372826.14.9C70E77
Received: from mail-pg1-f196.google.com (mail-pg1-f196.google.com [209.85.215.196])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34AB640002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:07:51 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nAqgfgmJ;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782724071;
	b=b8jbyTgJz7mETc0NEaSDnYl2fZxiQIHdAqkgCHKjXBGKD8sFFipgvZeAu61EQ2Mt3QZvY1
	pSGeyTz08QEFOHtscVM88uqYyJl9poBKPNDJQ60tmZbdqHy1rajnwUq5P08mV6TszAFYCE
	+TFiJzHRlS65qeu2TQkIDkqDMaUKUDY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782724071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83HbAI6qOdVU1QL6jhPAqEWUlv3tiZPtQ6kqfm9JAYo=;
	b=Lnyz5ER45w6zXKHnjX3OG/n7hZI5/LnDX5J472OotUVSmo8yesW3AyXXnrE/1SKGONKd/l
	uptKakEf+TlEyXiialb/3yZvcwhOIkZZ/ifbJVdIxbdyeiR/elq2M8yUPNajrk52A5gsdZ
	+YhBmVO91jbw8Z1eQxbtT/7AWv1O+yk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nAqgfgmJ;
	spf=pass (imf07.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.215.196 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f196.google.com with SMTP id 41be03b00d2f7-c96cb024ee0so396197a12.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 02:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782724070; x=1783328870; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=83HbAI6qOdVU1QL6jhPAqEWUlv3tiZPtQ6kqfm9JAYo=;
        b=nAqgfgmJ+ghhm4wMdIAuARPlt/vlUA5tkvMbJVG6fsAqanUqEdrcnqThL43RTKuSDw
         PVvWQ5elK9p9qlc2OhNPNoYWP1tiZbr81J3JlRY6pd5sdwaP+BiggdAq0lAdHEtI8U/o
         BTXOfaCT8SkTm521rUytzu5IptDfLFnnL6raQkLJAmMgbcjGn3rtWdoNpCF+BSFa8r5A
         5whNg0odY+5NPVfaEPQz1wKF7NIxFtFGiIABDr/y0/+/h3GSWcdy8XQ5HVVGY3XvMgja
         rVLniQLrDhJce3ivwrPT0G8kPUZry56bL1VBHqF6OvUzOkwsi6UTBhzZ69ws87UX0NcW
         xHfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782724070; x=1783328870;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83HbAI6qOdVU1QL6jhPAqEWUlv3tiZPtQ6kqfm9JAYo=;
        b=HCpsEW3tKarOOX5MS4mD+wbMp/FnPKMUD3HMLnUOU8E8KFCSDOLkDYjUfgbzW/c9Qp
         WXaD2nz1z9Sum7iHWPEvRq+EhuB/7B9F55w6JT/301WUG+BYfPApkcOyyNRABpgW5JSU
         fdWbT5UJV8pE++0zINhre8JOFDTMgUZcdV0ztE3RYn5RMrMKxLJ4ZPWFZAQPQH2UhVrz
         KqNMmX05ro3xzlYDte3PCIfr2S9I/I6kCtjwRI0TD8dD2EttAUnO6LzZDqjTKtkc5FzV
         tQYt11lBv59AvMIc/ZGeZAr1uT4iInkOGe0GvMgwrLU/kdc/F1xpg09Bpdc8LlG+kb1j
         kxEw==
X-Forwarded-Encrypted: i=1; AFNElJ9Iq5FtRKcmgLCAqOggC7YB1Hx+MifBBBBAXrOpHS1nVORdUCmlTsVEV4hyuQhAZS+oQbdPJSLUcg==@kvack.org
X-Gm-Message-State: AOJu0Yzz7xO5/h8fCrYnL/YrFbDhz1JZMyBhCeCXw7WxqhhaDu0uK8pV
	fkO47kf4EJ5VygksTj7BFazuHSMEmUjQIHVIxLUSxUqPH06X5CYDdW1p
X-Gm-Gg: AfdE7cllk87GTEwg7orMewX383n26/bia99yvvCppL0sQCJEy/4FCO64XUtXSJYZ5n/
	SYd+jgeRZ7agIyuQijDSH52nTgNpVBEcGbgyP8/As/jKSrbsOZF66F1HjEfsjH5v8qJl0ag0dDy
	AzGsS7yVoSt3Gwl+bqzLh9m9EUNGDQw8/VJ6pU/QK0xfezyC2bHJTUoWk7xqUlGFpoMxTv+9O5t
	aG30FXqlaQ9CLDcnF+FlL/5Zabdxv/w3ZtjMuDffL5/K+lgrQVS9l/G4gnaGTWbV3QxIODUY+Xc
	mXR7hXB/rDGKwFSA1n+z6dlnNysPjyIR1znv3hh13hfjAdHedc4+mQXVdmfEkLytyf5jSYvSlMC
	H2Ak8GQkAJ8h7JULAvy9QDja8pcGDqXGmtlO2P+TYOraAe4JscMT4HfAf+CJhB4UW96c4W3nzQV
	eBuckjhVGiiRq90/XFZtCP
X-Received: by 2002:a05:6a20:3d21:b0:3b4:85db:1be8 with SMTP id adf61e73a8af0-3bd4af22a37mr16709071637.36.1782724069917;
        Mon, 29 Jun 2026 02:07:49 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bc1df037sm7189768a12.17.2026.06.29.02.07.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jun 2026 02:07:48 -0700 (PDT)
Message-ID: <05d7369e-341c-49f4-ae13-df3d0ad930d7@gmail.com>
Date: Mon, 29 Jun 2026 17:07:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
To: Alexander Krabler <Alexander.Krabler@kuka.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 "linux-rt-devel@lists.linux.dev" <linux-rt-devel@lists.linux.dev>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "jackmanb@google.com" <jackmanb@google.com>,
 "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "ziy@nvidia.com"
 <ziy@nvidia.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "mhiramat@kernel.org" <mhiramat@kernel.org>,
 "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>,
 "david@kernel.org" <david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>,
 "liam@infradead.org" <liam@infradead.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
 "clrkwllms@kernel.org" <clrkwllms@kernel.org>,
 Hugh Dickins <hughd@google.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
 <20260604023812.3700316-2-chenwandun1@gmail.com>
 <969cb14b-5b8b-48e6-add6-4dd13101dd89@kernel.org>
 <040788a9-e0d5-478e-bb48-3d22b8b41020@gmail.com>
 <c8793c0f-7156-4cb7-9e6e-7909397e2fff@kernel.org>
 <ca1115c0-1509-453a-8235-08e381a3da6f@gmail.com>
 <PR3PR01MB6666C11E08516555C153D4FD82EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
 <a96b0b24-c405-43c4-96ef-605bacd17cad@gmail.com>
 <PR3PR01MB6666EC8D53E75F742B37270282EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <PR3PR01MB6666EC8D53E75F742B37270282EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 34AB640002
X-Stat-Signature: p3wyty49cnk4gnut56fkm67qr1oh7hem
X-HE-Tag: 1782724071-835304
X-HE-Meta: U2FsdGVkX18k3CAdeiL/erSf0+2p2IaYBTqwf88HKgFpXAi5F9zTBD9wn01YviLThPP3G0PybXgrQcBUht3Tf2m6BP8uT8mdqLQz47Ne2piiTSon/sEEmdU0sTZdklfeClIfja1aRgdxqECYF/TMVEgL83gOr+FEG0lIttkDlQh70B4zVpTpdN5YNtuWo8Wj7XPY57dnbmrV1llxA0CGJz4kTayb2ZkgGlPadRb9bRXOJbaXCW6Ux/uZgmRfBW3pttlMOubGTD408Eyx/nihxyXDZLPW2gLm59SGjg14deHpxajK8JrUaY+vEQchCz6D8T2dxaZrq+SKa8qyjnZ7gxEnRo78gvRPINPbDfRqq9oP6jIGExoesKKmnRf3X/5s4GsZemdpRheOsE8tRJTXgHNy1ZFNGVdWVeT+MDvw0pzCnVMmU5igNRVzO4If5V+V+Im/7YsBWVU9wMfhv5somnJbh+/u4LmDCyO2qWSAa6KAdSZ13HK/UtyBqFCX4t7BLAAx25MRIMIC7rEYzpj71wwXKRTbj3u22YRSgiraUU70WTQ8UItnCK1eIiBRwu/V1Yr42Sn1DvVRnsOJbseUiH+9ebCdvU5Jmi19FclGfZh0EX7xtn6kI3WmlEsSku8rpPOv5HWQB7ysvc6CSzlE4NX2pI9k864APM3PB95W9tTWH5smBQxwOTCCEfN2lY5yx+M1wWr2c/rcO45tXgveQPI6FBRjWVKWNMjekohDTYYPP76DaKjWvQtlSz8Xnd1okxPAz3cOgSF3gJjc6Y0bwVYbv+2gguvDiYNM8dkObypZkgxOPSnIwM1GqO2pMhjuKbriJZ4Y23eqU3cMTxiETL+2OVC5akyVHYJ1PGgKBVpaHFYIyfX1qKBkh/9RqfSh/iCrLOTVI/uGkbVKeUw8oYqBLvpAJFjKOvpS8fD2Gz3SxsUUFZgFuJWW1Dl3fn5DUZbvZTB5CHXGDXinFII
 bGZws8XG
 eGGk3Q47qQFlGuJ5+r/nB6s/xVIpyu9NqNus33KpoW6e66W/SPm1uBMXC8E/JObgLE568bi7Yx7gV3fVCcx7sYnWK+yWl2EMeU9MINyq2Q0k4hMnpBLaxmiTlDf/qSBxfdtc1cslJB0nea1m6AJpR5lcMUS9zAH2/tcWeGvPjfotI4mRdeIf163gEPDjzYclKP4mMamxl+/CZTohG1hFhDgOi4+SqI4lU0bFIgnM4s+nx03+FlDsOwVWKZU5jdw8fDu/mZKgDQk91lLqwpLpQVFwZ8Et8PvQT4a2iLO8aa0uPBfGPKATDOhrHh9hEYFslRsnkjamYnbbw2dQaWKoU187ZLP+K4c6bB9tbDvnhzGchd99rYzsUrgp8JnKBL1zmDiW3qG6+MYFhInrGv668DXuzNX0lPnh/AK4qCFptKHyYJ3sMLrmSerP9cPJUkPjaiTYRUZ1rza8bqL2nBqgpXW2eKKfOKJcfq57mknwUZopYxcg7WPBlcGqY7sbLle0E5DMGi31NHwxz+Xj4VUj8nGr9zJ85ZL5vq5H+Usvfzo4n9qA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 21:42, Alexander Krabler wrote:
> On 6/26/26 11:38, Wandun wrote:
>> On 6/26/26 16:45, Alexander Krabler wrote:
>>> However, we were not able to reproduce the actual race
>>> (mlockall() process waiting on a migration PTE),
>>> not in the past, not now. Might be hard to trigger that race.
>>
>> Not hard to trigger that case, I added a debug message, such as below,
>> lots of messages occur in a few second.
>>
>> diff --cc mm/memory.c
>> index ff338c2abe92,ff338c2abe92..6552b3b14f78
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@@ -4768,6 -4768,6 +4768,8 @@@ vm_fault_t do_swap_page(struct vm_faul
>>                 if (softleaf_is_migration(entry)) {
>>                         migration_entry_wait(vma->vm_mm, vmf->pmd,
>>                                              vmf->address);
>> +                       if (!strcmp(current->comm, "repro"))
>> +                               pr_err("============== hit ================\n");
>>                 } else if (softleaf_is_device_exclusive(entry)) {
>>                         vmf->page = softleaf_to_page(entry);
>>                         ret = remove_device_exclusive_entry(vmf);
> 
> I have a kprobe on migration_entry_wait set and logged into a ftrace buffer
> (including kernel stacktrace).
> Yes, this function is hit, but only inside the mmap-syscall, which is okay,
> memory allocation is not realtime-safe.
> 
>            repro-2090    [002] d....   811.129549: frt_migration_entry_wait: (migration_entry_wait+0x0/0x100)
>            repro-2090    [002] d....   811.129553: <stack trace>
>  => migration_entry_wait
>  => __handle_mm_fault
>  => handle_mm_fault
>  => __get_user_pages
>  => populate_vma_page_range
>  => __mm_populate
>  => vm_mmap_pgoff
>  => ksys_mmap_pgoff
>  => __arm64_sys_mmap
>  => el0_svc_common.constprop.0
>  => do_el0_svc
>  => el0_svc
>  => el0t_64_sync_handler
>  => el0t_64_sync
> 
> The original race was an instruction abort interrupt out of nothing due
> to the migration PTE set by kcompactd.
> And these kind of races I see quite often on non mlockall()-processes,
> but can't reproduce on memory locked processes.
> 
> Example:
>           podman-832     [000] d....   812.447820: frt_migration_entry_wait: (migration_entry_wait+0x0/0x100)
>           podman-832     [000] d....   812.447823: <stack trace>
>  => migration_entry_wait
>  => __handle_mm_fault
>  => handle_mm_fault
>  => do_page_fault
>  => do_translation_fault
>  => do_mem_abort
>  => el0_da
>  => el0t_64_sync_handler
>  => el0t_64_sync

Hi, Alexander

From the perspective of the root cause, there is no fundamental difference
between these two call stacks. I modified the reproduction program, and it
can still reproduce the situation of the second call stack
(although it doesn't occur as frequently). The complete reproduction program
is as follows:


#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <unistd.h>

#define PAGE_SIZE       4096
#define NR_PAGES        10000

static void *worker_fn(void *arg)
{
	int fd = (long)arg;
	size_t len = NR_PAGES * PAGE_SIZE;

	while (1) {
		if (ftruncate(fd, 0) < 0) {}
		if (ftruncate(fd, len) < 0) {}

		char *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
			       MAP_SHARED, fd, 0);
		if (p == MAP_FAILED)
			continue;

		mlockall(MCL_ONFAULT |  MCL_FUTURE);

		for (int i = 0; i < NR_PAGES; i++) {
			for (int j = 0; j < PAGE_SIZE; j++) {
				p[i * PAGE_SIZE + j] = 1;
			}
		}

		usleep(200);
		munmap(p, len);
	}
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
	int nproc = sysconf(_SC_NPROCESSORS_ONLN);
	if (nproc < 1)
		nproc = 1;

	int *fds = calloc((size_t)nproc, sizeof(int));
	if (!fds)
		return 1;

	size_t len = NR_PAGES * PAGE_SIZE;
	for (int i = 0; i < nproc; i++) {
		char path[64];
		snprintf(path, sizeof(path), "./repro_%d.dat", i);
		unlink(path);
		fds[i] = open(path, O_RDWR | O_CREAT, 0600);
		if (fds[i] < 0)
			return 1;
		if (ftruncate(fds[i], len) < 0)
			return 1;
	}

	printf("repro: %d workers, %d pages, Ctrl-C to stop\n",
	       nproc, NR_PAGES);

	pthread_t compact;
	pthread_create(&compact, NULL, compact_fn, NULL);

	pthread_t *threads = calloc((size_t)nproc, sizeof(pthread_t));
	for (int i = 0; i < nproc; i++)
		pthread_create(&threads[i], NULL, worker_fn, (void *)(long)fds[i]);

	pthread_join(compact, NULL);
	return 0;
}




> 
> Thanks,
> Alexander
> 
> --
> 
> KUKA Deutschland GmbH   Board of Directors: Michael Jürgens (Chairman), Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914
> 
> This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorized copying, disclosure or distribution of contents of this e-mail is strictly forbidden.
> 
> Please consider the environment before printing this e-mail.


