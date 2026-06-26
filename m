Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7112CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 09:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1FA76B00AE; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE1D6B00B2; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F116B00AF; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5535B6B00AE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 05:38:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB1621203CE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:29 +0000 (UTC)
X-FDA: 84921563538.06.44BA6D3
Received: from mail-pj1-f65.google.com (mail-pj1-f65.google.com [209.85.216.65])
	by imf01.hostedemail.com (Postfix) with ESMTP id E3A254000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:38:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOP9jG30;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782466707;
	b=NDanr3b4dhFaHwfQ+pT76pXVtAadOnaxlF9Kb6z3kRowRnmAbYAJN/r/+kPv3ZkL7d7TXm
	vK+pD1ebbmIVg+OEozo0HGWX4UBwtDDMoXyG/HNF8cmOSc0dcgf2W18C/jQXTRJNEVwGu4
	SouPdUzlnRrHZS7lKjHD62rDZMjbZL4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782466707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmGOCogUDtb4VYXfazs9AlgEqBwqwIaiss/qmncz56U=;
	b=NRjdfwteOk7RdivpX5JYHFDcByVHPcVXse7jxGh2N1gKGF7henzgLpH7N+tZf36H4K/yGj
	+m3HEu/W8S/uTuuSUHFgIiXv3sOCwkVxowGqj+P7+rxUDO36aZ7/DrAIaLKlB0GDUTiGVX
	ya2tNk2zK7dAO6hErUNGOLBr0D5hubU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EOP9jG30;
	spf=pass (imf01.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.65 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f65.google.com with SMTP id 98e67ed59e1d1-37d7c265ca5so631149a91.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782466707; x=1783071507; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JmGOCogUDtb4VYXfazs9AlgEqBwqwIaiss/qmncz56U=;
        b=EOP9jG30Y+CovXBtq4EK9GZ7dXzAjwv3/EGlQRfzLLS1J2RGiSBt+GXfq0UBxWo32u
         Cw+X+Lk01j5tGRtQPBYMXH/sI+2TMn8xXw5AZ9gH+kYL4AyAkgOHVsn6bIzS9Ka6by++
         0wr1KQA6OmvDu4Uz72o8vwra17WaVhvJyAzVmYYdZe3WFJOz0CHOQc1Gta1U37aeyWVy
         v9yYQGFGkjDWG7KCapqRuF3USxVG/9oko7rOBhaiWEgz3n9yxwJ9O1DQfQwADvob4mDX
         aVLOaK7OneOErmLt1Z23wIPGv/KcrYxbY0EkD61kxqhY/pTAKe7vNEtvTIxcmuW7A948
         F7Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782466707; x=1783071507;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JmGOCogUDtb4VYXfazs9AlgEqBwqwIaiss/qmncz56U=;
        b=o6yfQNl830n9PZHz9ONkdPYFWtHgIwsKv0a90zJlKn/h+eyHrbard2qVne0q6Dakcq
         i0OK5neIsBiZgSG+HE6dGUr9tklmYtkgdLQ2VIlmURdnWwD9Oaq4y7Xf/riQIrhrEbZr
         nDxbI4zQCOxX7F7EpYiDrBm48fDtmG854bDlfOyLliDuN8yFZdFF3L9K91QNMtlqVwpS
         F2jo3Y3N8dbB/3SPOQlBVzpuIUi6Guzy5GaM/IX9FmV4le7j0cFNTotXFK+2c+0WL165
         np8HMzqKwaa2+UioXa+wpVzQQW/zMLl7E9rF4jIiGi9T09Ptnx5uVqFpyfpA+sFk6eDZ
         uAFA==
X-Forwarded-Encrypted: i=1; AFNElJ/7NmaA0SB/+Z1tN6fLEeAXeu3HyRS1IoL/Y0LReH349TXwVNzkKLzwZLeBfD4SORfJPFqVkj+VmA==@kvack.org
X-Gm-Message-State: AOJu0YyswZj/9CCEEq1em8rE1bxOThAvdPtQegT2LjNes9HWroNU56QU
	F5jxOkXkentLPi5TdAHPNpiAEVNNHCy1RQ1ukb5XZ4rnMQ3s0WlhLQkR
X-Gm-Gg: AfdE7cnMv0pseT5Bqcy3YkRECpGOJVw06FCb4Vu3bGyZ1qCPD6BEu/UK+xk2yDUJImW
	R3nVdzXiQxx12Y8x+xLBsvKWEuHG49Tmc3pJKfBrpshiwXxBUclVwau5lc7TRYgPi4WYEFoIkV3
	+dF59XxC1VEzz8binlBfHePGwEP5FuG23xZoJ7N/SzojTaDiz82TWJBQglR/SP3DIm0AxzeCqUm
	z50njetVaDVDh8sC1OiKaDUtDKixdbRHZB57YpR7xwIDC+7VFhty2AXieyaYEBeU5Fn/wfZcffl
	lH7bywsH6+lMa5R9GxeKN6hz1jeOss6Mdhg1CgNdGEekjhMb9I9O/tUFSWAxz3mrllQcbYQtTzm
	kzoq/z2ot9XrawZ6InlpookxmKtiNQNV+k+uP2kAvhvANoItVUG1nln+MStlVsDaz8JhdTkZSx1
	3DynfEPWGxwaUXrHrFhazP
X-Received: by 2002:a05:6a20:7f8d:b0:3b7:aefe:4367 with SMTP id adf61e73a8af0-3bd4af031e2mr7074117637.33.1782466706836;
        Fri, 26 Jun 2026 02:38:26 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c92bcb9b749sm3025866a12.23.2026.06.26.02.38.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jun 2026 02:38:26 -0700 (PDT)
Message-ID: <a96b0b24-c405-43c4-96ef-605bacd17cad@gmail.com>
Date: Fri, 26 Jun 2026 17:38:17 +0800
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
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <PR3PR01MB6666C11E08516555C153D4FD82EB2@PR3PR01MB6666.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m5igs3xxe9xrcpnygecunznxtqyt1qyq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3A254000B
X-HE-Tag: 1782466707-226186
X-HE-Meta: U2FsdGVkX18avJKqlJ90XNFY9ZKmekhSbEUOCQm0+34NU7bL3Sizv7yYsp0U71f/rajwia2VEJKYacg6jbgDtNguyN1Zq6oe2DlgPlyj3W+ttWlrcQ0AVNpn+KmocMVaVYA8RrW4YAOSdQST1uTi9653kN8jay6dQibreCGVVFr0W+h7fC/6jho2yoijUN9494wI630E8XBzZS1J/hiqsgrRC3X9hCSxgKEM2WDO8VWL/hP+/VWFOzPptNRGEaFkWDUwEe+ireJFG42h7m77QGm4g4T/E+C27k3vAJboPh0EE8fmIwW+hP8qiLA6gPH2J+C3HV2fTQTGPYRSWPNBqT6E2q2Ej8nyHs14Yt3w/8YQFc+diAIjrTwcLwqnzbABOUHUfVOi27KIuCqezbPQ1FyYnkLRQLZtp3KqC3x7PyCNEdGfMcwnEEi5RqHV4wC71MwedG4gz2H01BqOe7ZVpcpn0dU494YkznHxr04r8MCmYcQvf9H6n/3YUR3LkV10kY70DsiFau6HFqUwN1xlzSdyrFp0YrwweuALQ6hKQUvYdCZkz/tGx4gDDlFRxemecOQK6sNrkRV6JbGo3d3ZjY3eVM7HKwStNWdpbSQ4kk3cD+ilFwqN25d6ePk/6gdexZ5/kMRCSIpU6h0Poa8SrcRqk3fIb3SmfFoPlo7M23dxeCx20hdLnorElTuWwCiuDuV56D+ewwhwoJ+NTJwuTX5VbQwMRtQXgpx5VZtqk9+vRcCG3hazBBnnpJExmY/bCvty9QXI8wHg5vuDCt4CjiGOhGLWRoPvYScgbPGFQCOkyoxS/E59+GrBv5a3W3QbPe51QEeyEd8ROwROJHbkGqWyIalEw9K6/Efr5XsdtwLAJZ6yNWvhyUQ0Or15m6him76c+rHu1CjKW4oIINOMX+0AY1b6m3HScd8vWVGTROicGWjpWLY7kxoWYVJcajEP1h+rMTD4V5oRuF2mFPr
 eUdMW6+R
 cFjRGTTU5Wfm7edZVl7diuFNj+85I7ZYpRtvdZRfdkFD8H0zsoEyjUDibJS2o1J5yvM2Gi05t6RoKegFJEQdRN79o/a7zVY+qwPlLLbSi3gtDNLN3Qz55DrnDKoIRQWuWcfDKg9TECIkcXM5lF818fjymRyUtgWsjCeGH1YlNby6N7TBvXJdyFwe9bBxNzKyIwBVTYJMJ88/AOjOt7rrFA2IDnkx43GNaYgfiOGyFFCagbV2FlGd4t+l+Vr5lnqrYDq4e/axGJkTR2MVeCjQaESQsLCGy9kCXSOTIQdSr5DjRXaYzw1wfdYtxI62+SGc13lxrAx+Q3hkek9Xf8ZSGPKGw/sLDZGJp1z+3/yvpPjva4NEaklM6dK1sW8hikrf0zPh0fXx6IyWRyYjCZm0KF/P8e0YWvWv0NKrcPnxAjqgpEFE2YggRc7Gic2alijOd4ofi0pq9H6rhzFRfzuykSo6yfScsbg7pXErhb1XsaQ9j9fiB2hhjbiWZxNXLWhGBnnx/xbV6hcR1JXX61uijVjDiIohltHMJTYVllTs5DZRwG5o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/26/26 16:45, Alexander Krabler wrote:
> On 6/24/26 13:08, Wandun wrote:
>> On 6/22/26 17:55, Vlastimil Babka (SUSE) wrote:
>>> On 6/18/26 13:43, Wandun wrote:
>>>> Yes, I wrote a test case that can reproduce it in a few second.
>>>>
>>>> The test case contains 3 steps:
>>>> 1. mlockall
>>>> 2. mmap file(2GB) + trigger file write page fault;
>>>> 3. during step 1, trigger compact via /proc/sys/vm/compact_memory
>>>>
>>>>
>>>> My reproduction environment is qemu with 4GB ram, 8 core, aarch64,
>>>> preempt_rt and includes the tracepoint in patch 02.
>>>> After running the reproduction program for a few seconds, the
>>>> following output appears.
>>>>
>>>> repro-403     [004] ....1   101.270505: mm_compaction_isolate_folio: pfn=0x71e3a mode=0x0
>> flags=referenced|uptodate|mlocked
>>>> repro-403     [004] ....1   101.270507: mm_compaction_isolate_folio: pfn=0x71e3b mode=0x0
>> flags=referenced|uptodate|mlocked
>>>> repro-403     [004] ....1   101.270513: mm_compaction_isolate_folio: pfn=0x71e3c mode=0x0
>> flags=referenced|uptodate|mlocked
>>>> repro-403     [004] ....1   101.270515: mm_compaction_isolate_folio: pfn=0x71e3d mode=0x0
>> flags=uptodate|mlocked
>>>> repro-403     [004] ....1   101.270517: mm_compaction_isolate_folio: pfn=0x71e3e mode=0x0
>> flags=uptodate|mlocked
>>>> repro-403     [004] ....1   101.270520: mm_compaction_isolate_folio: pfn=0x71e3f mode=0x0
>> flags=uptodate|mlocked
> 
> I applied your PATCH 2/3 to our kernel and checked with your reproducer,
> I get similar output, e.g.
> t_compact-2148    [005] ....1   515.320221: mm_compaction_isolate_folio: pfn=0xe66c2 mode=0x0
>                                             flags=referenced|uptodate|active|swapbacked|mlocked
> 
> With your first patch applied, the amount of these messages decrease.

Parts of mlocked but not unevictable pages has been filter out, so
messages decrease, but racy is still there.

> I was not able to apply your third patch to our (older) kernel.

Patch 3 is meaningless to you. The problem in your report is caused by kcompactd,
not cma alloc, so it is of no use to you.

> 
> However, we were not able to reproduce the actual race
> (mlockall() process waiting on a migration PTE),
> not in the past, not now. Might be hard to trigger that race.

Not hard to trigger that case, I added a debug message, such as below,
lots of messages occur in a few second.

diff --cc mm/memory.c
index ff338c2abe92,ff338c2abe92..6552b3b14f78
--- a/mm/memory.c
+++ b/mm/memory.c
@@@ -4768,6 -4768,6 +4768,8 @@@ vm_fault_t do_swap_page(struct vm_faul
                if (softleaf_is_migration(entry)) {
                        migration_entry_wait(vma->vm_mm, vmf->pmd,
                                             vmf->address);
+                       if (!strcmp(current->comm, "repro"))
+                               pr_err("============== hit ================\n");
                } else if (softleaf_is_device_exclusive(entry)) {
                        vmf->page = softleaf_to_page(entry);
                        ret = remove_device_exclusive_entry(vmf);

Best regard,
Wandun

> 
>> IIUC, more accurately, the migration entry in the page talbe is real a bad for
>> RT process, because isolate page doesn't modify the page table, so memory
>> access continues as usual, therefore a new idea occur.
>>
>> S1. In the mlock[all] syscall, if mlock_vma_pages_range hit a migration entry,
>>     then, it should wait for the migration to complete.
>>
>> S2. During the unmap phase of memory migration, prevent a page from being unmapped
>>     if the page's associated vma is markd with VM_LOCKED, similar to how reclaim is
>>     disabled for pages in a VM_LOCKED vma(try_to_unmap_one).
>>
>>
>> For a page handled during the mlock[all] syscall:
>>   - if migration has been already finished, there is noting to do;
>>   - if migration is in progress and the migration etnry is already filled, we
>>     wait (S1)
>>   - if the page is in-fight, going to be isolated/migrated, S2 prevents the unmap.
>>
>> For a page handled during a page fault: VM_LOCKED is already set on the vma,
>> so S2 guarantees it will not be unmapped, hence no migration entry.
> 
> I do not understand all details of this, but it looks good,
> especially the S1 case makes a lot of sense for me.
> 
> Nitpick: I suggest to switch order of PATCH 1 and 2 for the next iteration,
> introducing the tracepoint first and then improve the situation.
> 
> Thanks a lot for looking into this issue!
> 
> Best regards,
> Alexander
> 
> --
> 
> KUKA Deutschland GmbH   Board of Directors: Michael Jürgens (Chairman), Johan Naten, Hui Zhang   Registered Office: Augsburg HRB 14914
> 
> This e-mail may contain confidential and/or privileged information. If you are not the intended recipient (or have received this e-mail in error) please notify the sender immediately and destroy this e-mail. Any unauthorized copying, disclosure or distribution of contents of this e-mail is strictly forbidden.
> 
> Please consider the environment before printing this e-mail.


