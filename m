Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06B0C982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 03:22:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955546B008A; Wed, 16 Sep 2026 23:22:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 907F16B008C; Wed, 16 Sep 2026 23:22:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B8C6B0095; Wed, 16 Sep 2026 23:22:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 635056B008A
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:22:09 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1F501201F6
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:22:08 +0000 (UTC)
X-FDA: 85221805536.02.42E090E
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf20.hostedemail.com (Postfix) with ESMTP id ADCB91C0002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:22:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6nTGN7v;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789615327;
	b=M8xOhr03gOjpLADdWVwZ4RDfOfFjRTU8dYuOz3gViNUauY23RZEFMh1vC2+toLVT1OelOe
	Q7sSIKetZ6jDUTdxZWPg+ytXMjCJ5J9L9uKUmp1rSCGPTzdrNR9XkY2wEK0qu8kUGtSu/I
	TvxEu8DPm0Le4Ya2a+Gn2zWTO5S4DZQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=u6nTGN7v;
	spf=pass (imf20.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789615327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vEzAsg3CChuvyRs1FFhigTZAV14+tupX/ZJnHJrsdY=;
	b=akgHECNMmTt2XoRoNKKHpMy4Trb59wrjdNCqxmbUDwHmakgHovXHAjGNvemeYgRCcJNn4n
	7nqCgSOfHhVjJJlvx6j0mvmJWvkBiBEIPSwV36mrxget9+yyreBrdxeVYUbQyolFFjC2zP
	6ca7v5AaxGthqtrdzkVKq4S8TEW13ns=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yl/KOYtn7JZaIGJ+SR0TQ6PTflOSgSYVMpOp0AALSDk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789615325; v=1; x=1790220125;
 b=u6nTGN7vfwbYe7PCRLE0iIbUUHW2Bf0Z8jwqGG0xde6hwjR2OE7yW+6khwRWfwpf6PwMC06B
 W8vILp7/v3pQE+Pcoe+2Ot5r6i+Pk9MyXjiEkRTswBQj3d6Zg0zu0dl/loB49sVYwklmLO5UOa1
 GublyU9w7HlrtYMy/VRjGwfw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3c089fae2f5f256c;
	Thu, 17 Sep 2026 03:22:05 +0000
X-Mizu-Trace-ID: 3c089fae2f5f256c
X-Migadu-Flow: FLOW_OUT
Message-ID: <f12d0cd4-0704-4231-8199-4a04af367040@linux.dev>
Date: Thu, 17 Sep 2026 11:21:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/mglru: add tracepoint for scan_folios()
To: Baoquan He <baoquan.he@linux.dev>, Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-3-ridong.chen@linux.dev> <aqkoeJvFzqpoGeaP@fedora>
 <e38f2b80-20f2-4787-9e07-fb601552f550@linux.dev> <aqn7h3BVCCRFI2TI@fedora>
 <20260916095122.50cbb620@robin> <aqtBG9Oyu-RVI7jv@fedora>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aqtBG9Oyu-RVI7jv@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADCB91C0002
X-Rspam-User: 
X-Stat-Signature: tqibfk3bfgj7379ouoocz4e98h1gj5kk
X-HE-Tag: 1789615326-567550
X-HE-Meta: U2FsdGVkX1/ECtdl+AQ5Kn8PedM/hYC/T6ZC8Egapl7uyp6KpF0hmX3X6aig29YV9JDSRdHaGSp+8AQ4DSf9GJ3O6ZJEN3LT0TxmuGR7Wnm12VxhWTaPnmjHvzD1Ldsrd8syvG5Z6BkpTATf9x1nHGhRnlB834p9bYQyrLuY1FlIDd6cAyMnEoeF68rSklppHurs7taPeGZo0iOGR4jxum5DEHcuDMNqFV4T7bqTBQA1UBqIa9/WOSh0gWjDuOuTM2pGUS1syAf+CugZVBD0FSGrtcJvsekPiOR24ySMHCkUtbqop+gahj6hVNNNzCP3XY40d86LYMLtB/kKe6TEpPiiFLTVbBZSjkdaQqL2EharJu3GPpnVZlaqzmXGmDvh+wTeSbTPcj5btvR3dAtt5Mz3TV5+Ej5YohNm0flSE5IIWB7AIH8gYpVahntjjIT+DNqeaMNEj36m4AgTKFbChSU6e7TEUird02KfdnU33wpc/6VKzSpbeoiTzPgGL2DOO7nZMYJnOjbDoxJ7eNHoUe6K2O5XeHEOyIsJI3ObDG6aaBRjzLoaqMcNzt3SrdK8C6uK/HUr21Pv4yo/9ujlrkPyFkQ7KU+vVkGhu4BtqOouCAn29dIfAOFefpEFhPZHtBlq+MCd3Vpk8rWoUjQPHa9w5KaaiiTSs9dCjTHDeqUUS2HrS5KE95rC5AM2RCczXNCV3855Jx+XVqeC2z15LUBnoMKLOqWIwbSMs0+tNp5ccO7hQowHRHdtcmI2UAauFHyViexn5TIwuk48o58XLkKLimzzSkR6QAV35SnFgqHIjYgdBQBSc2XXAtUDupN8Gc1gMp3gLkKs+UPFCidsbZWaNJqBzSjIZPzyBOYDGLdY3R01uHxLLu4bzFbyUZKI86yQpwJJqwNxSCNL1jkcL9kdJ6sjBefehmy7H4qycummGZwAV5gcOIyoKAS8sVMiClRP2OtATpdqQivZY1h
 dnzvWWqc
 Kp0RbpblyZhhLwMrpRGWx+0joVx0j/SJJ93vxrMc/sfokayK6/TdOloXc+NaxlM77myjRzsyL5iYibmqt7vLYR9MWf7yswqr1/oRzHBy0F56qTpkZ1wMjf/2F5oFm7zpxI0VrrRk46Xz2YOVmkuNc+uFsMpHJT2tXqdl9u5x1DP4uKnq0x2ghtLEAvbx/vV2ZNZB+FwNMkL/liJTK9/rKqro/tpFqT/c8koHZJJTPVRY4ceYk5vK5xKZWjCos6LLCxEqh//x3ZjkqZHoRplIkw9G2IsU3QldaE0Z8ZAozyaaRXIvHGOda5loB9RcwBCgUpVrT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/2026 9:23 AM, Baoquan He wrote:
> On 09/16/26 at 09:51am, Steven Rostedt wrote:
>> On Wed, 16 Sep 2026 10:14:31 +0800
>> Baoquan He <baoquan.he@linux.dev> wrote:
>>
>>>> However, 'sc' is an internal structure, so sc->order cannot be accessed in
>>>> TP_fast_assign(), and I don't think it is worth making scan_control an
>>>> external structure just for this.
>>>
>>> Agree.
>>
>> Or what you can do is to move include/trace/events/vmscan.h to
>> mm/trace_mm.h (or whatever you want to call it) and struct scan_control
>> into "vmscan.h" and then you can use internal structures within the
>> trace event.
> 
> Sounds very reasonable, thanks for the valuable input.
> 
>>
>> Up to you, but this is what other subsystems have done.
> 
> Yeah, leave this to Ridong to decide.

Thank you for the suggestion.

I think it is worth doing. And we can also use that for other tracepoints that 
are using sc->*.

I will give this approach a try.

-- 
Best regards
Ridong


