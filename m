Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B1A9C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86C26B0088; Tue, 15 Sep 2026 04:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C388F6B008C; Tue, 15 Sep 2026 04:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F456B0092; Tue, 15 Sep 2026 04:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA906B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:44:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C055A140376
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:44:50 +0000 (UTC)
X-FDA: 85215361140.12.AFF4A62
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8BB36160006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:44:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5nWwBKv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7VmnpfzvPXSofFi8P4eMsLyUzS5eaNuDWdEobHGPKk=;
	b=fKVN4tOqbJpoeRli7jgNnbJB888ChvT32I9kF92/fCitaBCCk+HwTR3fnT6weyzIIF7Gbk
	8st/lXlznJL6Z+SLZ+0jemiia7cUHjUDWOM7TcZpyG+pu1RrumPoBW3swXWBqVw2soIOQX
	PFIEcsm6iByS8mr94tjROj7qvvUl6RY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461889;
	b=Kz8h8/xASsHskHiC0yTAyoZnDWO3m9FVmVEK5U89PRpjMgIwFJp1XY8OAU8jq+wqEyOMja
	NmL+UgfQnLQl4rsgxi8yzLarm4qWzeVaVpG+uycU/2fSLvhZyiK94OTYh/bsgFLA2OwkW5
	FMqRd35BJYIkPHJeAj6uaVDuIarKlvg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H5nWwBKv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OdmaTEvWPgfTFD+u4aw06O2FSYvZjnGVMGwImr7GHt4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789461887; v=1; x=1790066687;
 b=H5nWwBKvXlQCIvrgfqP7aqsb1BOfq7cA2Dftrighr1kpCMGwYShZVKBJiIfe1RSUDQatmhH7
 VINOJ0Z5LJJAG2Yj6t2fzpksqmvxdNmm0EsE1B8t8eSf6PijQsuffYbYmFLhU/N2JY2blpNjuIf
 JQ2Qrs61fgn+3nd9YJ/2Yz8s=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 96d8f489691b383c;
	Tue, 15 Sep 2026 08:44:46 +0000
X-Mizu-Trace-ID: 96d8f489691b383c
X-Migadu-Flow: FLOW_OUT
Message-ID: <e018e3a0-349a-4f36-90e0-8fafb001da43@linux.dev>
Date: Tue, 15 Sep 2026 16:44:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Jiayuan Chen <jiayuan.chen@shopee.com>, Zhou Yingfu
 <yingfu.zhou@shopee.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, David Rientjes
 <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-kernel@vger.kernel.org
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
 <aqg-oG2HDIUeK5Us@tiehlicka>
 <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
 <aqjsPW92SgcHONKO@tiehlicka> <3c8d1d8e-0e67-4d1a-b73d-4eadd6266aa6@linux.dev>
 <aqkAbBpYheX2DEHg@tiehlicka>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <aqkAbBpYheX2DEHg@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8BB36160006
X-Stat-Signature: geq6s7nf7tuh1ad7fzhhbojzgtb5r4bx
X-HE-Tag: 1789461888-832390
X-HE-Meta: U2FsdGVkX18RIVk0i2mQ8K3r/+e6fhJ0tsT19mjgPNQ89Xc9DIUR2DCWeF5qnSr+8iwMmqTXDm1wirFDaAcLMYcCC7HmcnKC2xgidqaPV2nBbgLUTcpCZ3/Xz02wU8HJ2NMs7d7PldxnUfQtL2v1OBuPA74C0JDfZX3l054MAFDwuIxN5f5kHvKTamAm6JX5leA8DxICjnmL0NFx5lAyROC0SJXCAOzTXcBt2+iE6m8qEDBASy3xTV9Ch7NYRkmWGoG2cUiiagjsyXN3JI8v/hRf5DFbm80QK1ocjWigFaxuZEiNOjgmHVd7JgAJPkKkmpxfjrrYKOM6VVgs5ycEhhgSkS/BIQuyRqM2OmPd/SyVUTYLpZuPna8dfK9ggYn1gqWB2FLzvumIJ3jzSXcINKuCTOUbSmgaP0EdwPMLcpMw53dyxdqLbuoTVx7rlLhKrKFutC5kVNXh6IEUF2UjBK+2Q5PIKQi+kBW6cm6TZJ4lX4AGYu+wUNeeUsk2ledIv9zRKRLjBdm+DZuDmqaJky3ESSSFn/Jc4tOXbYzolJVs3H2awqdLCV7kSTCxtAwiTDSQsh6K/npHmv5eXVyd5Y27S5B4BQNyPDpNp/mrK3rUM3z4kxR+Y2fAqP3GKZEYKf3xqP4zFocOQXA6ndBZL5VFnUsDb97DdPMe9viaBAvkSS4lIB43zp+NaezMOyF6PrRvUu7OkP+DEy/wCkSHO/vmsHuxLtbxJhV6ZyW0Rh9zM78Xa+w5GeZlvD9maD7oYhXvK1T1oBXA0uBivi96vaV7UUQkIVG63twLt+Ezyp0IiKM8ITSGhWlPy0KuOJgz0Ihw1ucssl9baT+xl3BL94oNX51V2kH1od6qcHepXnm/b5wCmVT2jQL1UNO3gXBIdBR016xuNVyfqMBiHZsyyT+iIJEMNgi6hx0tU0V4lsj0mjHvIenyG+uIHq3WinGRUxOlsYHVLOTf64Osoka
 ewnknYcc
 QORRXDcvuw683g9LSCSjZ2xsqcDxXbQzPoh5Xdk+ZezzGneMXOoJnExO0mNIn2fKhmOh82TK9KCQv6ZvTL//nW2o9I6tAvY+RUmosEuA/IpuS6bScSUl43tYlhtogIGJUX9DJSgzObr1nbfKT1j31SQgrKHWMUp7umpHRLz6VAQ9pE2H1nWRH3imMUuZDiU2iUIDEc6pxUI+oCXKVfQ8lk9B8Gcp/jrUto8zsCkn1OvxgDGk+UjdKyDe9UDLbhXzN93TPimyOfvcVN37ZnUi7T915FiE2UKhEfmAo98kfJYuqZvTnttoyeJZ3u3kYpArspHbSnyffHdjSH/LTISSXFKUXyB5jpj9JBiA76+QoKOG3GUvlqb1nrXVLn2+leluSqxsavzAcgnjQMgtzbt4655fNUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/15/26 4:23 PM, Michal Hocko wrote:
> On Tue 15-09-26 16:13:11, Jiayuan Chen wrote:
>> On 9/15/26 2:57 PM, Michal Hocko wrote:
>>> On Mon 14-09-26 20:35:33, Andrew Morton wrote:
>>>> On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
>>>>
>>>>>> Call Trace:
>>>>>>    <TASK>
>>>>>>    __schedule+0x487/0x1870
>>>>>>    schedule+0x28/0xb0
>>>>>>    schedule_preempt_disabled+0x16/0x30
>>>>>>    rwsem_down_write_slowpath+0x1d4/0x750
>>>>>>    down_write+0x60/0x70
>>>>>>    __ksm_exit+0xb4/0x230
>>>>>>    __mmput+0x12c/0x150
>>>>>>    mmput+0x1e/0x30
>>>>>>    do_exit+0x283/0xa30
>>>>>>    do_group_exit+0x34/0x90
>>>>>>    get_signal+0x952/0x960
>>>>>>    arch_do_signal_or_restart+0x41/0x250
>>>>>>    exit_to_user_mode_loop+0xd3/0x560
>>>>>>    do_syscall_64+0x385/0x470
>>>>>>    </TASK>
>>>>>>
>>>>>> KSM is just the one LTP happened to hit: __khugepaged_exit() has the
>>>>>> same write lock cycle ahead of exit_mmap().
>>>>> Why is this a practical problem we need to care about? It is kind of
>>>>> natural that the oom victim exit path might race with the oom reaper. They
>>>>> share the same lock that is mutualy exclusive. The whole point of the
>>>>> reaper is to ensure there is a forward progress achieved. So before we
>>>>> start modifying this let's talk about any practical/real life problems.
>> Hi Michal, Andrew
>>
>> Agreed, the hung task warning itself is harmless, especially for a dying
>> task. The real problems are what sits behind it.
>>
>> With a 500G swapped-out victim the reap takes ~600s, and for all of it:
>>
>> 1. The victim cannot exit. __ksm_exit() needs mmap_lock for write and
>>   queues behind the reaper, so the process stays alive in D state for
>>   10 minutes and whoever waits for it (parent, container runtime)
>>   waits too.
>>
>> 2. ksmd and khugepaged stall. Once that writer is queued, their
>>   mmap_read_lock() on this mm queues as well, so both daemons stop
>>   for the whole system for the same ~600s.
> Right. But why is that a problem we need to fix? OOM reaper is taking a
> prortion of the exit time by doing the leg work of tearing down the
> address space. Exiting task would need to do the same so it is unlikely
> to terminate much faster.

Hi Michal

Sorry, the subject is misleading.

The total work is the same. But with the patch the reaper and exit_mmap()
free the memory at the same time, so it takes about half as long: 264s
instead of ~600s here.

The hung task warning is not the point either. If that were all, masking
it as Andrew suggested would be enough.

The warning showed that ksmd and khugepaged stop for the whole reap, and
that only happens with the reaper. A plain exit takes the write lock in
__ksm_exit() / __khugepaged_exit() first, which also removes the mm from
their lists, and only then holds the read lock in unmap_vmas(), so nobody
waits on it. With the reaper holding the read lock, the exit's write lock
waits behind it, and every mmap_read_lock() on this mm waits too, ksmd's
included.

So the patch is really about the reaper not holding mmap_lock for the 
whole reap.



