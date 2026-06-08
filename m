Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB06FCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3BF16B0005; Mon,  8 Jun 2026 14:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4C76B0088; Mon,  8 Jun 2026 14:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3916B008A; Mon,  8 Jun 2026 14:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6A526B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:50:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BD271639DC
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:50:04 +0000 (UTC)
X-FDA: 84857635128.12.5B055A2
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 78BDC100011
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:50:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YseYA4z0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780944602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+Xv9Q4t+VBlyLKwVnG1Hwd1DVGfe/IlAI+bIJKn/kY=;
	b=R6V/pImuXf918HcYMwO25b52oS+9Xu0v7F9vKstBJwyBRTfHOZquqInb7pjm1olG5ncmz4
	FbA/vISk/H98Zw9ao3Blr4UAlGJEcpWFb//7FZIYvLL3kHXKIgonoTKG8miIX6FsLXwzti
	U4qA7IjNbFbsGTrUSpQ+3S/JcIGzXnU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YseYA4z0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780944602;
	b=ksIKOizvgaHo1FrCNqxWCc20cFHJwd582fprS7Jjj2Qs9jpeRAge72isFgc4sZRndUKj3j
	PD0yi+rfgKxPWuETIJxhIeR2GNt+rJZxfUd7l0V3TC9WMOAlGNSFklGyX9KkOVNVxZAH33
	32MAyvA0QXtzXN193GrOWv39F/XRLkg=
Message-ID: <750406a5-1819-4ca6-81d8-5a1d82e0644b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780944600;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y+Xv9Q4t+VBlyLKwVnG1Hwd1DVGfe/IlAI+bIJKn/kY=;
	b=YseYA4z0xkuimnZBzr7HwrTpuIwRhRMoR7nDDCVmtZEvN60r60+llojre6LHAPsMTuymtp
	YvcM76NKcaUybZAzzxK9JSMd3ArtO3Jf2tRugc7739wWDyiMx9wrEWlK16/d1X8zE5qIuI
	l6ZNEenxMW5xpCW6OVvZGK3AJcoHGy4=
Date: Mon, 8 Jun 2026 19:49:45 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] mm/vmpressure: reduce CPU, memory and code overhead
 on cgroup v2
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 linux-mm@kvack.org, hannes@cmpxchg.org, tj@kernel.org, mkoutny@suse.com,
 roman.gushchin@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org,
 ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, surenb@google.com,
 vbabka@kernel.org, kernel-team@meta.com
References: <20260606114158.3126210-1-usama.arif@linux.dev>
 <aib11jSWosT6635u@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <aib11jSWosT6635u@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 78BDC100011
X-Stat-Signature: p4jnrgdthyij83iok5ywt4336jidtcxf
X-HE-Tag: 1780944602-496499
X-HE-Meta: U2FsdGVkX1+iHA7yjy5S+eOZ4NgKNGFkKXxQcrpOCQB00fuW8neHzNeZ5yB6pnuRK68jYUDKV/TM+75+kXpOi+QOLDEWMues4iqKx4nf3acjfuG7Z2ZErNarmba9beaov3yfM/j5m1IoL7QDAn83CR3+9mO+JuKCUj9YdSHBjW18I+UHmy7pVyouOgR4ZMIsqUd/xSluURKfQD+FQzX3bvFXjDG/x/UivI2V9AKr8BzkYIsIkipwYhSvembB94XS5TCZa2Ui5ldV0zwb94m3GTRhpAoaBJSLF+bAYoYcVu2hF3NcBVJxOqlWZEcmhWtDd6p9hTyj/BtIvDeFFpu6Sj3JzFFkb8nlcbaAkVjONnB1e97kk8sdVjkSUFAWpeiHO3c5/peedCmlM+i7zVWwnx/W/siYKY6nnNLjb+7Z+IC8K4iiqOa+WgFx1TXEGw/2Idye5123zvM35qGjQ2Rp2x2TC+fFpPpJmIiLAdczSX3Y/M1PlSWvnQlgVTRi+xwYprBiTLtkcFTob3sSZRAtOYwOyWl6+nlpbjEidSz8IaF9Rw0WnYeRkMSBQCx2HzhGsrqNBz32ekCSlFeWvZW1Bw+tv0h0iV/liI99CpFBCbOKgiUuSOo7TJTg3y9rpPmtAciHIh+kFtjTxDkQGZY3GTzVm6lYiQmvzLZQsN0DvdPsnQGrRUsHEhpSo2FinC8/fz9zdpmrYR/aL+/NKCQu8qzVj134OfKc3dXRlj9f3UwjMwRb3h5vVPxfCXVHmlMFGkhcvlGdoy48isMnGtQSlfOikd/5ivHxsdbJk2NNJEQUu1oCN+MPaYu/G3QXuAcUCeruv00mlvF6ELuuJUmYDTUxA+R2giNKZYrNGUsBc9FzBmTMbgR8GZigZRYhxGPn5IHaNoDtt38PgGxwY0lwXWcFof89smaw3LZ/GcY3GR2DJ5PNzAiDKVX2o33WYD1lnCmeHvv8QZCAfjD+Esd
 KMbltQ4u
 4iMhkZvUuPaVhJR3X0zyoDQ9ifZd/MO8TRS4SkRyBCeZzY4Ucstnzmm4WszDxlG3Tv60O6TU+6/ADHrhcdwKrWWib/H9QJkXRRlaVVy3z2pyRgZ1By8Aasid1EtsJx+rTFe3/sFfPMnLI/vKHJhiReOHF8vpps2rt+adKlO8etrR3UaraxhzMBRQNC61MQZo2au27crHchyNxXmp49E7ZmBABTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/06/2026 18:05, Shakeel Butt wrote:
> On Sat, Jun 06, 2026 at 04:41:32AM -0700, Usama Arif wrote:
>> The vmpressure subsystem has two distinct consumers, gated by the
>> @tree argument:
>>
>>   tree=false : in-kernel socket pressure, consumed by TCP/SCTP. This
>>                is cgroup v2 only; v1 sockets read memcg->tcpmem_pressure
>>                instead.
> 
> We should really move v2 away from vmpressure.
> 
>>   tree=true  : cgroup v1 userspace eventfd notifications via the
>>                memory.pressure_level / cgroup.event_control interface.
>>                v2 has no equivalent (userspace gets reclaim signals
>>                through memory.pressure / PSI, which doesn't touch
>>                vmpressure).
>>
>> So of the four (hierarchy, tree) combinations, only two carry data
>> that anyone reads. The existing early return in vmpressure() covered
>> v1 + tree=false; the symmetric v2 + tree=true case was falling through
>> and doing the full lock / accumulate / schedule_work / parent-walk
>> dance, even though the events list it eventually iterates is empty
>> on cgroup v2 (vmpressure_register_event() is wired up only through the
>> v1 cftype "memory.pressure_level" and can't be reached from a v2
>> memcg).
>>
>> Patch 1 extends the existing early return to also skip v2 + tree=true.
>> On a v2-only host this eliminates a contended path where reclaimers
>> can serialize on a single global sr_lock. bpftrace on a 176-core production
>> host (cgroup v2, 285 memcgs, sustained reclaim) showed ~16,200 such calls
>> per minute with tree = true.
> 
> This is good.
> 

Thanks!

>>
>> Patch 2 follows up with a cleanup: it splits the v1 userspace eventfd
>> interface (struct vmpressure_event, the events list and its mutex, the
>> work_struct and its handler, the parent walk,
>> vmpressure_register_event / unregister_event, and vmpressure_prio)
>> into a new mm/vmpressure-v1.c built only when CONFIG_MEMCG_V1=y,
>> behind small no-op stubs in the header. mm/vmpressure.c keeps the
>> shared bits and the tree=false socket-pressure path. The size of
>> vmpressure.c goes down to half and the code is much more simpler.
>> The only #ifdef CONFIG_MEMCG_V1 remaining in source is around the
>> v1-only fields inside struct vmpressure itself. Memory savings on
>> CONFIG_MEMCG_V1=n:
>>   struct vmpressure :  112B  ->  24B
>>   struct mem_cgroup : 1664B  -> 1536B
> 
> For this, I am wondering if we should just go ahead and work towards making
> vmpressure memcg-v1 only unless we foresee a lot of or complex work is needed
> for that and only then patch 2 makes sense.
> 

I think there might be a transition needed? Because vmpressure and PSI
do not work out to be the same and people might notice a regression with
increased memory usage or a hit in networking performance and might want to
opt out? A solution might be to switch socket pressure to PSI while
keeping vmpressure around gated by a defconfig. And then in a few releases
remove it completely for cgroup v2 if no one complaints. If we go down that
path, we would need patch 2 for the medium term.

