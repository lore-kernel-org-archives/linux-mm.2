Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64CC6FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 10:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88E826B0088; Tue, 28 Apr 2026 06:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F576B008A; Tue, 28 Apr 2026 06:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7554A6B008C; Tue, 28 Apr 2026 06:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 664156B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:20:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9601E1C0034
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:20:50 +0000 (UTC)
X-FDA: 84707571060.27.2DA784A
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id A5635A000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:20:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sCOv82sH;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777371649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ir9gkX6ap7Dl25Nv6DGNL7wm/7HC7xIHOVSKox27TU0=;
	b=WSsfZMDSb73ZTGoF/T9qBRz5jt/s+4OTVNv/2WxvLiyemIHcMI0HJl+OBDxEo9es8wYN+w
	ErtLKyE8MeT7XdfqDZJvw7M4RAMi0cHftQF6asSC3H5Plpdrnsz8w8MX9RFcpoVSQ8nZXh
	+SoMNad3OtUwspOt10nuXGPOsf8JnmA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sCOv82sH;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777371649; a=rsa-sha256;
	cv=none;
	b=2F1Jr6HNr5YstvmlKJbElacxg6A42fQvWyeQ83fFNWW4z8jYPceTEXfdUfPV65t+/6DEd2
	P7US5e2KrSOxpxR/UtP6Ebdb9Nq33qZqZ/pt+CDgiMeYjvtkLmAlCE2EEmnVtz5Nym1w+J
	QR/1XfxfZCLYw1AUmF0f8l4CfjR+bVE=
Message-ID: <a7f12e87-2137-49c1-ba0b-0fc03cad501a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777371644;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ir9gkX6ap7Dl25Nv6DGNL7wm/7HC7xIHOVSKox27TU0=;
	b=sCOv82sHo8j5DwFPY6zfrT/QR99Up68p9w56NxjMqvWU9MoK4t3UBvo2YJ2SEk/LeK24W9
	/MOahleMNZtzPj5D/yJlyhVe0QZRZ7/5KWImhYzt5xp3XcOPOtXgrfpDJ0FCC3ZeQdPmgK
	afJq29LB6ZxvF5mhNAo2cF4pPog8lDE=
Date: Tue, 28 Apr 2026 18:19:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcontrol: fix rcu unbalance in
 get_non_dying_memcg_end()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, yosry@kernel.org,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <20260428030621.94470-1-qi.zheng@linux.dev>
 <afCEgUMqhLvrYJe7@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <afCEgUMqhLvrYJe7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A5635A000F
X-Rspamd-Server: rspam06
X-Stat-Signature: crj35aadebjum7o1pikm1j55qn67opn8
X-HE-Tag: 1777371648-107642
X-HE-Meta: U2FsdGVkX1/HLiI0uOtSm/yB4Iqhx6XzMPoVqeWl4SZo8zkOh+wK1omaZg9eidcGKLCU9cEG+iwGbWYFyyNF6kNiNpMDQTfOAC6ucZwFZUsjZe/fC2IVTaWfz2kvojFAz/j1Nubx10y/Wr16AuYctmxrqIEtqrdwvtEEyfaohQlwCOSSSQw0Ayeu0vaxYotXv3BUOpkeTX/gUOXKxHHn1URdAT34Z1z99Ejq2uy9WjrgwNR4n5qn0YPYPWA6cx5WBZY54QOVW6bxllgIvERU7IU8HRKG4CSMp7GaVsgdEhJrfEQXcnOBC6AI1h2Q2tSqT7lNCEVGqq3nAn0fJSnpfczN8raKUVkQW9Khv5ESAqh6lhN1eXkud4rxtOE8McMLlDjKvRjTiaCzCHo763veOpf5bUAlWASFzOT5uJyehqsWMR/lU9B+3GlR3MnEPA6CSRzJM7tTGYEWh1gmD7w/ojflOuNsRRuvutVLW/RA29UanniPZ/VsAKk4UcenJkSKgfK9i8s/n0XTeoEXDFlAr/ZifAldbeZTlnnXVXP8lDMqSZ+l5JurcwFxNxWUhXXQcQyv0lv2C4Dn33O3Q/WfsvecPk8amEwBH+Jq8MM99eS0aJ7kYe/N/z04wB9TwHHCsNr0uMpbpm7fEU+SMOU3PxCnm868m3S9tHDRjDjcIkV28o+mlPh4/I+KFoDkfjC+1Vq3BgkUDjEyZ/XUsUdA/Bkisho4+pmVlbzhsfKTWT18hMUqAh1smB+kpYO1RPdt4u7b53+m8JWmFMe35fAC1pvo8NvsrZitRgN7rF8exDqjnCj39OjmjWNiD0Kr9RxbsqNXAQQC2YUOBc93NDUF8Eq7+9G3pHlCKNahAZQbu1WDcUzamYH45o56dPTUSuZZw5d2AhLyZlk6+LE92aV1iq683CabHD3IqRgSNMIxhRar73z+nUaqnWXmGEds36Dkq22Ha//pnWbfyoNU13E
 x42eXkZj
 XCp/xCcnVpo58RY7bBSKSbeKvFfLhMI8yQapIP2uG6t5tE1FIPqJo7GAJdtWgSvEexHe+HgGkae5Wf/MnzYgAy02qkgVPkI/CEkisI3j1DIPd+UTZ8CgB/aPNjPgv0fSGstxjwR6ZejikhIiBSJYuoX+MZtKJBVk/euJDMRq5OJW40ZaFEL/2RDX65k/qBew22cYTP01+itbfybf8s6kDek5hpsx3u8T0rIEucTHe9+t7C3Zmgqr2Gc6f75ay68P0itxk63z2BikF9MMux5Z08raEIyZXSnZ74/cVl8s+GUqYNnx62dJ7MrRrXbafLO3qnDG/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/26 5:59 PM, Shakeel Butt wrote:
> On Tue, Apr 28, 2026 at 11:06:21AM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Currently, get_non_dying_memcg_start() and get_non_dying_memcg_end() both
>> evaluate cgroup_subsys_on_dfl(memory_cgrp_subsys) independently to
>> determine whether to acquire or release the RCU read lock.
>>
>> However, the result of cgroup_subsys_on_dfl() can change dynamically at
>> runtime due to cgroup hierarchy rebinding (e.g., when the memory
>> controller is moved between cgroup v1 and v2 hierarchies). This can cause
>> the following warning:
>>
>>   =====================================
>>   WARNING: bad unlock balance detected!
>>   7.0.0-next-20260420+ #83 Tainted: G        W
>>   -------------------------------------
>>   memcg-repro/270 is trying to release lock (rcu_read_lock) at:
>>   [<ffffffff815f57f7>] rcu_read_unlock+0x17/0x60
>>   but there are no more locks to release!
>>
>>   other info that might help us debug this:
>>   1 lock held by memcg-repro/270:
>>    #0: ffff888102fa2088 (vm_lock){++++}-{0:0}, at: do_user_addr_fault+0x285/0x880
>>
>>   stack backtrace:
>>   CPU: 0 UID: 0 PID: 270 Comm: memcg-repro Tainted: G        W           7.0.0-next-20260420+ #
>>   Tainted: [W]=WARN
>>   Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
>>   Call Trace:
>>    <TASK>
>>    ? rcu_read_unlock+0x17/0x60
>>    dump_stack_lvl+0x77/0xb0
>>    print_unlock_imbalance_bug+0xe0/0xf0
>>    ? rcu_read_unlock+0x17/0x60
>>    lock_release+0x21d/0x2a0
>>    rcu_read_unlock+0x1c/0x60
>>    do_pte_missing+0x233/0xb40
>>    __handle_mm_fault+0x80e/0xcd0
>>    handle_mm_fault+0x146/0x310
>>    do_user_addr_fault+0x303/0x880
>>    exc_page_fault+0x9b/0x270
>>    asm_exc_page_fault+0x26/0x30
>>   RIP: 0033:0x5590e4eb41ea
>>   Code: 61 cc 66 0f 6f e0 66 0f 61 c2 66 0f db cd 66 0f 69 e2 66 0f 6f d0 66 0f 69 d4 66 0f 61 0
>>   RSP: 002b:00007ffcad25f030 EFLAGS: 00010202
>>   RAX: 00005590e4eb8010 RBX: 00007ffcad260f7d RCX: 00007f73c474d44d
>>   RDX: 00005590e4eb80a0 RSI: 00005590e4eb503c RDI: 000000000000000f
>>   RBP: 00005590e4eb70a0 R08: 0000000000000000 R09: 00007f73c483a680
>>   R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>>   R13: 00007ffcad25f180 R14: 00005590e4eb6dd8 R15: 00007f73c4869020
>>    </TASK>
>>   ------------[ cut here ]------------
>>
>> Fix this by explicitly tracking the RCU lock state, ensuring that
>> rcu_read_unlock() in get_non_dying_memcg_end() is strictly paired with
>> the lock acquisition, regardless of any runtime rebinding events.
>>
>> Fixes: 8285917d6f38 ("mm: memcontrol: prepare for reparenting non-hierarchical stats")
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   mm/memcontrol.c | 31 +++++++++++++++++++++----------
>>   1 file changed, 21 insertions(+), 10 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index c3d98ab41f1f1..38f48a45b7ae5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -805,12 +805,17 @@ static long memcg_state_val_in_pages(int idx, long val)
>>    * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid race with
>>    * reparenting of non-hierarchical state_locals.
>>    */
>> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
>> +							   bool *rcu_locked)
>>   {
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +	/* Rebinding can cause this value to be changed at runtime */
>> +	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
>> +		*rcu_locked = false;
>>   		return memcg;
>> +	}
>>   
>>   	rcu_read_lock();
>> +	*rcu_locked = true;
>>   
>>   	while (memcg_is_dying(memcg))
>>   		memcg = parent_mem_cgroup(memcg);
>> @@ -818,20 +823,23 @@ static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *me
>>   	return memcg;
>>   }
>>   
>> -static inline void get_non_dying_memcg_end(void)
>> +static inline void get_non_dying_memcg_end(bool rcu_locked)
>>   {
>> -	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>> +	if (!rcu_locked)
>>   		return;
>>   
>>   	rcu_read_unlock();
>>   }
>>   #else
>> -static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg)
>> +static inline struct mem_cgroup *get_non_dying_memcg_start(struct mem_cgroup *memcg,
>> +							   bool *rcu_locked)
>>   {
>> +	*rcu_locked = false;
> 
> We don't need to set rcu_locked to false here as we don't access in !V1 build
> option.

Will do.

> 
> With that fixed, you can add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!



