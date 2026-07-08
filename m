Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCB0C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:31:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 357B76B0088; Tue,  7 Jul 2026 21:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32FD56B008A; Tue,  7 Jul 2026 21:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246696B008C; Tue,  7 Jul 2026 21:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1A276B0088
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:31:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A3EC40625
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:31:23 +0000 (UTC)
X-FDA: 84963881646.25.11E79C4
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf01.hostedemail.com (Postfix) with ESMTP id 521B340004
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:31:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kcoy+4C3;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D/LQLPuILxjB411/fYFouWHdkKkRbW9iZLAYWIeHak0=;
	b=B4N8pTAr0I+GRBsxg27G9iHcqnLp8owHuO/C0nDKJasfOcWK0kEuNlAs5SjNP1GLxPjewB
	6xc7H6UMvHoOQYzQ0yyjD7V3A+JogniHwSnjx1r9EK3g8yM+46LhRNO9fcVHpCIb+VUixW
	/1dlPLwBYsplAnYyj2MDfUnpI+hiyCU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Kcoy+4C3;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474281;
	b=t9p3het7I2TzXIKNZN58tFM4GmA+pvuow/EGDhURlTf1VQt7u4IvimPkbDe84PmqXIshcG
	sQ4OQ/8HLXjxXh1XRuYn0It7P3Idoq+zs+sC57JnF+VgqyagffgB3ZAcpVa3vzwkoX/gkq
	JSHEk9grvBV19WshnLjIO2IIdo7TBsg=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-ca034c989e2so65423a12.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 18:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783474280; x=1784079080; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=D/LQLPuILxjB411/fYFouWHdkKkRbW9iZLAYWIeHak0=;
        b=Kcoy+4C3pNHePhFxImNs7kVVd1tUWfw8jsSKBmF/IC1cJ0Ey+M+rTKMNRKWp7Pbt0S
         HMvCJUSxo17dpVJ1SMia52psn5qgNKe9kUCAZuQQb1kGjRPndxuZJTLLIJZmzcUbBOYi
         Vli9SGos9IH4MiywMQpi7PK2I/GERsDPq+4FfLBETngrOHNVrr7p3C+L/OkWq1h1+zsn
         iZnNv1gQoixXKoodKg3g6GrTLs9V1Gehnuf3PIYztsAASng0duE2XBy2uMDqwr8yCfpX
         M3i6GOPNhCA36ye1ppqfuy1Z4Y0fVQgic3ftpfhSdpEZ90lC2M5zHWKGnyltVf9G3Tdl
         qYNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783474280; x=1784079080;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D/LQLPuILxjB411/fYFouWHdkKkRbW9iZLAYWIeHak0=;
        b=dpyrgE929GtPY7jhI7Bkoe3goWGGuSZZ9dMb+qlyGmkFMsRbOi32cc6F1xmN/mYhvr
         ZPfJrX+Vwl6fXgL+eOVpZtTEJDc1f/9BtOFgurP1cyVneB+LCpfbFxi5VQDDwuioJx3e
         xmmnPEhWiSv1gq6IRV2f6snL3ZMeR4/Bf7Rr9Rjp3kByb3PRGAs1/EW5bJX7Zs1OhxlK
         VasM4EEVsmuV+1n9+OdZUguuwG9t0LloBNqq+47gQerFMbjr+5tkF2gQBrWzfND4oRvq
         hmcPaz3P7rpS8PTZHtkZXA6AXLVhB/jP7PVOLxNThTZRtIJgG6lIPZC3aXwsg68FCn5S
         OBQg==
X-Forwarded-Encrypted: i=1; AHgh+RrkDTO3PEEVCPL/6CYyLYbNqyR/EktUOrq36MsFesFViPasUpXyOYZgGy29JJURxKMfvQX2CrPXnA==@kvack.org
X-Gm-Message-State: AOJu0YzCqaPS7/o22lNSLVg5skEcOYQZ9pBNrY0XoVNelLZiSsUJGw5e
	L8o2rbtNupfWVOCF5cRm2xlGzjHRXzhfVwMOITjhM5Twtc10gHm8dBJ9
X-Gm-Gg: AfdE7clkyULJQeoZZP0npOhceXE7hggnNSbEQ+vDTwHYGwwdzJF0+pYEp4VGyUsLLUX
	eK+53EAteBtkCNHW3q7TJdZQziSM+bT2nINRanJWOST2Z0wuVi6HZFEg+Ce7AJjtrrxiPnxd4Z5
	gh3tXotbptDk3xzKx2NV7TqgXBQy1mdhNAnFTZ/iqfNE+O8VvhM5EdP4ANa49gyc4wYL3LQ0uc8
	4iRPLEBzk3eBE09j80jNW3gBjjcrpfN9aKxkYk79BQZs1IvhDMUd6B51VJ4SkFjLwMsEJKW2Y0m
	UD1mAiI5MD6Bp0spXVX1I/wAhB63ZzrAhK1pdlQIHUNBdPdDeOBAye3J35NHXI0RdBEc+SYs4XO
	kb4Ndo/bs7SsAqItbSxrKiKiYdv+RJsV8ILtyz0XfVrvvGg/4Gpd0HxjQIwVh3JwartuZbX6HVi
	v054hcPV4joD8JfYAFSqwB
X-Received: by 2002:a05:6a21:62c6:b0:398:837a:7af0 with SMTP id adf61e73a8af0-3c0bd04207cmr152449637.30.1783474280029;
        Tue, 07 Jul 2026 18:31:20 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-ca5af7d58f3sm1656435a12.1.2026.07.07.18.31.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2026 18:31:19 -0700 (PDT)
Message-ID: <e4761ca0-21d2-41d5-8d0f-ec14d0a5d3b9@gmail.com>
Date: Wed, 8 Jul 2026 09:31:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when
 compact_unevictable_allowed=0
From: Wandun <chenwandun1@gmail.com>
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
 <05d7369e-341c-49f4-ae13-df3d0ad930d7@gmail.com>
Content-Language: en-US
In-Reply-To: <05d7369e-341c-49f4-ae13-df3d0ad930d7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 521B340004
X-Stat-Signature: nexcwyhicc3hn9fpf5mfezojfm68tezk
X-HE-Tag: 1783474281-524850
X-HE-Meta: U2FsdGVkX18l0XE/S7Z7j4ZoYw4EBD56hnLm5bYPJjfsE4VFRr5CQnlhtEZFdE4z4/y3MvojOsEg5Y13cm5n4cF3zaEA2VFL0V5HZT/adAUeKORlw+Y4wbR2cwyr/Sweo5+KZANp5I1akeK8uHGFMEfZRMgG80/B0gLUlxqn+GZztlOQGC80ZH39r5qkyoXR2rCpoOOQECNxk00QHTvxCbBlsvrKy8+mzkpTOHSVndbpYu934G7kI+28ssEOUJU00nws0AYcV1ctVbxs/2yvtRvR9LlOc5z5Fk0yJh6oEMqnecaTrIFKSw1t7+oETLwZOz63sxRzxszAuMTCvrklVfrg9uhprZjoxLUYdXrSsgmzUItjmmpurnjCV1AE08caNOxc+8WofqDzIv10jvKVIiiIXBbG3ni1JA1Z/KG6uMnYwlTzY+L85tuhPAwDi532srFyWDdh6lbmxjG8M7YMxZeQTiTZZ5map7Nb6C9oZqEC3P5Q9ut2IISt6+xc1o6S5TaNYN71kHE5x2AsibdlJcfyorm0s1f3zR63Ia0TVH8euBXH42lKUQLJTQY1sOnyyK7Hd0CP88T6C1WJ4LJtNsmhsLS1yo1eoQGnujE51h2+6W6SajjTgi4kUQKdylYnGIcSj3TmKMAo+qvhjoMaCHj8ME1Kv16BCe0gqf2Dos0fMaGMG/cQIUcInKfbTcjlwzWDUTks2jp7SZkhDaBmULLoZ11isA0dRrr4aaOF8nrw87IpgxqhUusw3Pb4G8qKmUDRqBa7CYmAlflvLKOMLsFhnp1rsL227ePdJT00p8Y8EKF6S1m1Ag+Hxf6s1uFpK1AdOs0qpv/YCPOOk7vow1eSy6OVflRpEfoB2tt2c/kLDPjlRyBJcfw6weUaZ3ROcTH3iQDvy0wtrRdbqOYfKdCzeOKGobhiU/04whlgo2IPXUD8dnq4sFqbfp1vPj3IX/C3qicpa9Pw1hB0c+v
 9thhgrQt
 Wqhopov8vMxoDczMGvu2T5EG1QnUK3qdygU2IPI/8TykqpJK3QD242wFFdozV0dsUduWbOKa++nnzBp5arMYORv9d7392ZEjgIqWXUYek9GojU8q8zgsabeVqusnFII+ZH/3RoWEnsuuS2xPy9LYLfqZscvRgYPQn6FSFDKHov0i2LlUG0yEX2DAlHWKpKYmFYgMdNgTanEtIuMPTIqFVlqQjnzzgLtUMYZnNl++gY9rA+RL7ngGEsb3nGW86BGFW9Ujoie/rB+RwjSj779Ld6MQ6yp6Cgo2v5FMYl/ad5inNN7EYUP9hP1gWQI135AeiB3O359KY4NrZ5uy2YUc+qH/81HNX0HVqGqpO3wjNcVYolYJopyviOSvSZsRZSXsGde7DWQcngwO0Dp44k644EbH0jfmRexntDuS6cPPZMmFuooAZisvRCzbWTjokUFKTzswmBYdzELDTQgDO+rcodSNB1dgp0jZVP6w9oK9AsHQJrym20Ezc7YVOXudeLl/Olo+oWcVGCUSSfIKlvgeQwLg8fNCFH1j3nAnM9cLE/dIjU56ctZUxGMy4ImfzAMvhhMDy6si6tx5o9BgvWtEjhzuyDMjzv1Q9JODFSW7MX/mCPmA6q6pGCVt3+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/29/26 17:07, Wandun wrote:
> 
> 
> On 6/26/26 21:42, Alexander Krabler wrote:
>> On 6/26/26 11:38, Wandun wrote:
>>> On 6/26/26 16:45, Alexander Krabler wrote:
>>>> However, we were not able to reproduce the actual race
>>>> (mlockall() process waiting on a migration PTE),
>>>> not in the past, not now. Might be hard to trigger that race.
>>>
>>> Not hard to trigger that case, I added a debug message, such as below,
>>> lots of messages occur in a few second.
>>>
>>> diff --cc mm/memory.c
>>> index ff338c2abe92,ff338c2abe92..6552b3b14f78
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@@ -4768,6 -4768,6 +4768,8 @@@ vm_fault_t do_swap_page(struct vm_faul
>>>                 if (softleaf_is_migration(entry)) {
>>>                         migration_entry_wait(vma->vm_mm, vmf->pmd,
>>>                                              vmf->address);
>>> +                       if (!strcmp(current->comm, "repro"))
>>> +                               pr_err("============== hit ================\n");
>>>                 } else if (softleaf_is_device_exclusive(entry)) {
>>>                         vmf->page = softleaf_to_page(entry);
>>>                         ret = remove_device_exclusive_entry(vmf);
>>
>> I have a kprobe on migration_entry_wait set and logged into a ftrace buffer
>> (including kernel stacktrace).
>> Yes, this function is hit, but only inside the mmap-syscall, which is okay,
>> memory allocation is not realtime-safe.
>>
>>            repro-2090    [002] d....   811.129549: frt_migration_entry_wait: (migration_entry_wait+0x0/0x100)
>>            repro-2090    [002] d....   811.129553: <stack trace>
>>  => migration_entry_wait
>>  => __handle_mm_fault
>>  => handle_mm_fault
>>  => __get_user_pages
>>  => populate_vma_page_range
>>  => __mm_populate
>>  => vm_mmap_pgoff
>>  => ksys_mmap_pgoff
>>  => __arm64_sys_mmap
>>  => el0_svc_common.constprop.0
>>  => do_el0_svc
>>  => el0_svc
>>  => el0t_64_sync_handler
>>  => el0t_64_sync
>>
>> The original race was an instruction abort interrupt out of nothing due
>> to the migration PTE set by kcompactd.
>> And these kind of races I see quite often on non mlockall()-processes,
>> but can't reproduce on memory locked processes.
>>
>> Example:
>>           podman-832     [000] d....   812.447820: frt_migration_entry_wait: (migration_entry_wait+0x0/0x100)
>>           podman-832     [000] d....   812.447823: <stack trace>
>>  => migration_entry_wait
>>  => __handle_mm_fault
>>  => handle_mm_fault
>>  => do_page_fault
>>  => do_translation_fault
>>  => do_mem_abort
>>  => el0_da
>>  => el0t_64_sync_handler
>>  => el0t_64_sync
> 
> Hi, Alexander
> 
> From the perspective of the root cause, there is no fundamental difference
> between these two call stacks. I modified the reproduction program, and it
> can still reproduce the situation of the second call stack
> (although it doesn't occur as frequently). The complete reproduction program
> is as follows:
> 
> 
> #define _GNU_SOURCE
> #include <fcntl.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/mman.h>
> #include <sys/sysinfo.h>
> #include <unistd.h>
> 
> #define PAGE_SIZE       4096
> #define NR_PAGES        10000
> 
> static void *worker_fn(void *arg)
> {
> 	int fd = (long)arg;
> 	size_t len = NR_PAGES * PAGE_SIZE;
> 
> 	while (1) {
> 		if (ftruncate(fd, 0) < 0) {}
> 		if (ftruncate(fd, len) < 0) {}
> 
> 		char *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
> 			       MAP_SHARED, fd, 0);
> 		if (p == MAP_FAILED)
> 			continue;
> 
> 		mlockall(MCL_ONFAULT |  MCL_FUTURE);
> 
> 		for (int i = 0; i < NR_PAGES; i++) {
> 			for (int j = 0; j < PAGE_SIZE; j++) {
> 				p[i * PAGE_SIZE + j] = 1;
> 			}
> 		}
> 
> 		usleep(200);
> 		munmap(p, len);
> 	}
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
> 	int nproc = sysconf(_SC_NPROCESSORS_ONLN);
> 	if (nproc < 1)
> 		nproc = 1;
> 
> 	int *fds = calloc((size_t)nproc, sizeof(int));
> 	if (!fds)
> 		return 1;
> 
> 	size_t len = NR_PAGES * PAGE_SIZE;
> 	for (int i = 0; i < nproc; i++) {
> 		char path[64];
> 		snprintf(path, sizeof(path), "./repro_%d.dat", i);
> 		unlink(path);
> 		fds[i] = open(path, O_RDWR | O_CREAT, 0600);
> 		if (fds[i] < 0)
> 			return 1;
> 		if (ftruncate(fds[i], len) < 0)
> 			return 1;
> 	}
> 
> 	printf("repro: %d workers, %d pages, Ctrl-C to stop\n",
> 	       nproc, NR_PAGES);
> 
> 	pthread_t compact;
> 	pthread_create(&compact, NULL, compact_fn, NULL);
> 
> 	pthread_t *threads = calloc((size_t)nproc, sizeof(pthread_t));
> 	for (int i = 0; i < nproc; i++)
> 		pthread_create(&threads[i], NULL, worker_fn, (void *)(long)fds[i]);
> 
> 	pthread_join(compact, NULL);
> 	return 0;
> }

I found there are false positives in this reproducer.
I modified the program a little,  the diff is as follows,
the problem can still be reproduced


diff --git a/repro.c b/repro.c
index b1b34d5..59cb417 100644
--- a/repro.c
+++ b/repro.c
@@ -15,6 +15,7 @@ static void *worker_fn(void *arg)
        int fd = (long)arg;
        size_t len = NR_PAGES * PAGE_SIZE;

+       mlockall(MCL_ONFAULT |  MCL_FUTURE | MCL_CURRENT);
        while (1) {
                if (ftruncate(fd, 0) < 0) {}
                if (ftruncate(fd, len) < 0) {}
@@ -24,8 +25,6 @@ static void *worker_fn(void *arg)
                if (p == MAP_FAILED)
                        continue;

-               mlockall(MCL_ONFAULT |  MCL_FUTURE);
-
                for (int i = 0; i < NR_PAGES; i++) {
                        for (int j = 0; j < PAGE_SIZE; j++) {
                                p[i * PAGE_SIZE + j] = 1;


> 
> 
> 
> 
>>
>> Thanks,
>> Alexander
>>
>> --
>>
>> KUKA Deutschland GmbH   Board of Directors: Michael Jürgens (Chairman), Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914
>>
>> This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorized copying, disclosure or distribution of contents of this e-mail is strictly forbidden.
>>
>> Please consider the environment before printing this e-mail.
> 


