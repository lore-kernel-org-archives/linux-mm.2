Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8DD1CDB471
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 07:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FB76B0088; Mon, 22 Jun 2026 03:12:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350E36B008A; Mon, 22 Jun 2026 03:12:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23FD36B008C; Mon, 22 Jun 2026 03:12:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E860A6B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 03:12:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 719FBA057F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:12:47 +0000 (UTC)
X-FDA: 84906681174.30.BB9961C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id BD03E1C0003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 07:12:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4PNXIa9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782112365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPDKWUY1v1INodMedwDx7DwR6GeDNvta1xVixbP8aME=;
	b=k7Ba1InMoVYa3kva14LAMiDcltRDj+htSQFnegkk+jFsMWXIz6VCsDxluz1eJ5Z/T4XZIS
	ocW6JYTdXj4e59+kXwImXuZ70tUlwHBZEjtyGNXERMTpBkAPqMiWbzFRNGHvF6JFobfgKR
	G8t/phBixisyBdeTJFBV5X9PqQie2II=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782112365;
	b=n1v3xDAUhi97db0XgapBZfNADioxslWAuUi8pkDDiKwmum5XNHwU3B7qAbUgHGIUYsFl8S
	Qe8Q+/Uh7TkH0JoWTZBruxfdZiAfCQWuW5BOQ1rYux+sruxC39pTPkY5GwPK2P49dQ3Sz3
	lnTO1AC1DDFSXGHmCOqvgpB805aDxpo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L4PNXIa9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 129C4600AF;
	Mon, 22 Jun 2026 07:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A371F000E9;
	Mon, 22 Jun 2026 07:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782112364;
	bh=JPDKWUY1v1INodMedwDx7DwR6GeDNvta1xVixbP8aME=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=L4PNXIa9Zw4w4w825y5AbRuIkOOgKjEMz0H/IY6pmo0/6ndTOJFPljNEwX3AL7dbj
	 plw6zBxzTfQaZ/UroLuI54iZKHPFrPnF3lAqPwgK92ea6EP595egePsMrZLYbUJJoU
	 168UWkvIZs2O/Ux0HkhEJiGWOLIT53MX63q3eL8x0Hhha674hOrFnrSs35GDOW2/Lx
	 CSSgZC2lV8LlJN/6+qpsxBWDeUwGAGbcZWTnr89VN2ut3cW8PKou1Rl9C1+nzzIlw5
	 6g7rbChB8u464k5hXQt7m1oerM34BEUDf/rr49Uy6trcC8HiyUQtylGI43wb1argWM
	 rOa11sg/oUJ/w==
Message-ID: <e629ca4a-69c8-4288-802a-9150ab9da4ee@kernel.org>
Date: Mon, 22 Jun 2026 09:12:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: Waiman Long <longman@redhat.com>, Gregory Price <gourry@gourry.net>
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Andrew Morton <akpm@linux-foundation.org>, Farhad Alemi <falemi@asu.edu>,
 Yury Norov <ynorov@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, stable@vger.kernel.org
References: <CA+0ovCg05rUk1-3k2ysdxmbcER8aG-wVh9SSTrrbp6LPWpPHYA@mail.gmail.com>
 <CA+0ovCgfHJHv5d1mzapWWvF-LhjppzDX8NPPLvCPZxPKg8RiYw@mail.gmail.com>
 <8d3b4561-92cd-4ebc-8462-5fb0fd659e8a@kernel.org>
 <ai_IHvyptWPcTD0y@gourry-fedora-PF4VCD3F>
 <70f486ce-5ef6-4d72-8cc3-7086f4eea930@redhat.com>
 <c1495b1b-9dee-4cd5-ac8e-eeb7a2d968ed@redhat.com>
 <51eafe6c-6622-479b-b391-6d3ff9350e75@kernel.org>
 <c61c7925-b9e7-4a6f-82e2-398849ad9f27@redhat.com>
 <38578aea-61c3-4328-aee9-8e7421672647@kernel.org>
 <9d8b650d-6faa-425a-8db7-1e206cb25158@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <9d8b650d-6faa-425a-8db7-1e206cb25158@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD03E1C0003
X-Rspam-User: 
X-Stat-Signature: b51tnckhwzj7xrhqc6xok8azireb6mcj
X-HE-Tag: 1782112365-235227
X-HE-Meta: U2FsdGVkX19Lp5tQNlcxhpGQ+tmWJLFRHudnOYqhFEvtnWa8NFa+ImeZSTbnjf3Unqhu6MoD2zplkMr0eSOmBgu/rdLSEd0pXjDOCjVBKpiqwQf+czP39uS9L/s0I+N/coBoPdvtBf6GDTNhb/9RKmtrrMOnAwNXmC1m0uCRNh+5QkpUZK/5VWgQOPBiPtiA6gfHXD7Qe9xGRiavZ9uF3G/jvJnMA+NB+WASIOUi1ujRPzF66rbI45C3R7lXxRsqZxTdEP+0fnbeYyoiwd1OrJO5SRcSLSsx5sLqgcUaIH0aZ5Tff9bUICmaVr5Tjh2NyRw4TFZA2/BTXwE8V6h01bnJF56WrESxd0wZxzT9rXl2puuTdxI7MAcpTHBpAbprfB0WAx6J3S9zQMvbcEfokjU3k2KXatgwX++LFUrKralAEXKStVNUt1j6US1+5aGkfy61uihnyyzLdmwR0hvbQr4sRQ8pKW9w3NcWN24uBXYnuWHRcUkXreFBUxxPZ2jdI6xqFZg1xuLlW2VVp5BESTpsxQIEXNEYhB3qMpRachXWON93C+8szQQfZbNRmjvm+Cp6ZNCLMJIXyz8Jc/9VZQNEFd/qNeN0+ygeynMJomVDC/Lax5qaErxZMq3Q9c1MVzJGFy8GspUUTEx4zZFRkn3ASSGCLqhP2Kff/u0t23gy+P+rpkDVyC/PGTpqR6FcSnLL9vy6j3rHmJlFcqQIi2sAEm+CKd5pisyIiGYqHjaeZqH5ohbn7XK0Ni6ckGAaGZ/fxl4yp/ueWkYUhAhN28I3NAtOHb6ejXkRRqjXmAQNNyAU3bZ2WHnsXWq00ConzN/vcJ0lHnsD4wgj897QEqLm0mpCqiIAvbPQ5FB6vZIaK2Y1yeooi9yDfmoMAJ8z0dY6vlq6/m0G2SLv+MMmDwzApDCVvsD8eh9Dn5j5v7ZZhvP5NfC3MQIkV3QUyGaxCqqJaFaOAoklE/pyG+T
 z6J6n/01
 K6gnJDUjbdQzxU1YSF8nz6tB1BKMiI8DBeVjYKYA3xTQdJunNi6F7OLtR9/Z/ef1qCWW6u90TePt1BHE6OMgbaOVb5epvKG7Em55SJew9NTdeKlezzJSLbMux5wYOqSEOEfVS5LgHx1xDRVlrUoYNlNRojm54G/EPfJrSlyH3MDBAxkXYUoH9tp/Ebo9lLvg7wcMkEMWhX1mzvXSvZkhHDIYwKF7gUv2fasXvjU6CswlrUkVhUkhBGwyLaZhVGfNsYaNMQsBPdQUwdsX6KI1Mmk3HKhs+42Kr//jbSjfNC/RuNErxSmQ5hPwMCcvt2v30CBYvQmG4axhhH6MHNwjJ4+itCDd8lZpKKe5ZOi41AiCsBMXIUsDAhNu7ck93ZY1Us1qIDvcxrFpQzxy26pazkrfZkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/21/26 05:24, Waiman Long wrote:
> On 6/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
>> On 6/16/26 17:23, Waiman Long wrote:
>>> Yes, taking newmems is a reasonable choice and there are pros and cons with each
>>> options. My focus is more on not changing how v1 cpuset behaves as it is well
>>> defined in the v1 cpusets.rst file:
>>>
>>>      Requests by a task, using the sched_setaffinity(2) system call to
>>>      include CPUs in its CPU affinity mask, and using the mbind(2) and
>>>      set_mempolicy(2) system calls to include Memory Nodes in its memory
>>>      policy, are both filtered through that task's cpuset, filtering out any
>>>      CPUs or Memory Nodes not in that cpuset.  The scheduler will not
>>>      schedule a task on a CPU that is not allowed in its cpus_allowed
>>>      vector, and the kernel page allocator will not allocate a page on a
>>>      node that is not allowed in the requesting task's mems_allowed vector.
>>>
>>> v2, OTOH, is more vague as to what setting cpuset.mems will mean and we
>>> generally follow what v1 is doing, but we have more leeway of what we can do.
>>>
>>> Using newmems will make the above text not totally correct. At least the offline
>>> memory nodes will be filtered out which will not be utilized by the task when
>>> the offline node becomes online. That is why I am saying that we will have to
>>> correct the documentation if we want to make this change.
>> So IIUC:
>>
>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>> index 1335e437098e..cdfc615f35a5 100644
>> --- a/kernel/cgroup/cpuset.c
>> +++ b/kernel/cgroup/cpuset.c
>> @@ -2645,7 +2645,13 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>>                    migrate = is_memory_migrate(cs);
>>   -               mpol_rebind_mm(mm, &cs->mems_allowed);
>> +               /*
>> +                * For v1 we can have empty effective_mems, but we cannot
>> +                * attach any tasks (see cpuset_can_attach_check()). For v2,
>> +                * it's guaranteed to not be empty.
>> +                */
>> +               VM_WARN_ON_ONCE(nodes_empty(cs->effective_mems));
>> +               mpol_rebind_mm(mm, &cs->effective_mems);
>>                  if (migrate)
>>                          cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>>                  else
> 
> That is true, but I don't think we need a VM_WARN_ON_ONCE() here.

I'd prefer if we catch such stuff in the future more easily than running into
late divide-by-zero. Maybe we should check in mpol_rebind_mm() instead.

-- 
Cheers,

David

