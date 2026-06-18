Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9DBCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:42:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABE5E6B0096; Thu, 18 Jun 2026 04:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96666B0098; Thu, 18 Jun 2026 04:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987366B00AE; Thu, 18 Jun 2026 04:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65EAA6B0096
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:42:07 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0D24A063F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:42:06 +0000 (UTC)
X-FDA: 84892391052.23.003E831
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3566540004
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:42:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7rxWD60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKs9ir66i8mxyfauBkj7MGREb7nDkX7OxGexd1/PnhU=;
	b=7O7S99wiaFpNyHg7+reGWvfb2pARy6Ka5lwHHTtSMX0e3JnYEsDUJ2nPZBEdNAxldNbht/
	5EjLZGoQlkXbM+/hrwDIcsFA92fQlj88b/Nh1tsWNoryL+vqzEBeFTDU+x2yz+I518A1TG
	muvbKglcWGqVRXLAr03iQ+JbaqtsLfI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7rxWD60;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772125;
	b=myDcRhPc0eG881dGhYOUcGQl8b5BX/DUoCGDevHY5NfiQQNk4/nF8l3bi/cPbdj5dW4Kyq
	UE63focvRAVZxRo1nUvIVyYoS2kuZz9dmDs4y1V1GZVbWntrP/yngvdSCTiUKc/Cex/+yr
	C7kMIzi7syubzNUvSx7YRMuFuSPcRX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 893A06012A;
	Thu, 18 Jun 2026 08:42:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C7A1F000E9;
	Thu, 18 Jun 2026 08:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781772124;
	bh=RKs9ir66i8mxyfauBkj7MGREb7nDkX7OxGexd1/PnhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Z7rxWD60Q8cUSuDSV8lzscOFAMbL0aXmzN4C/T0nU7pITDihMCWBx9FFre95Xo+X+
	 4fOejYcQmunAe12DyagZb+Ux+4MvZ8wNZVR4yLW/jP8L71G3jO4U04OzFgQz9eBVr6
	 lSUFxVDQaJ6LDiWOJHYZQ8uKdHMDf3qNLtfCqJbEYBbk4e41s9zk3Tq8Oc9HcTm4/6
	 FZBJU40l58xnf336bnytkrzP94T7P1UmYX1MAUOx1Pr2CbNzUF3ZFlGoNOn1BcX53E
	 h0QeRE3N98Rgx5wo5JRT4WO8QawcVu1i2oWksGP3aa1j0diN4RlKKFTRFmsHmeqm0Q
	 h7J85TSO2JKwQ==
Message-ID: <38578aea-61c3-4328-aee9-8e7421672647@kernel.org>
Date: Thu, 18 Jun 2026 10:41:59 +0200
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
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <c61c7925-b9e7-4a6f-82e2-398849ad9f27@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: rcwod8e5rdcmdfkdiowzn3jfs617g4ee
X-Rspamd-Queue-Id: 3566540004
X-HE-Tag: 1781772125-91357
X-HE-Meta: U2FsdGVkX1+XQKPzVq3MeB7QfjwXp6mUGhyESWqldv1ssWbhpsqTN5XwAvBuWk9fIXjlIEaScTYYQ9ksuehtz7PlYYPnKJH+zLZ8CH1dlkSBCFNcSMq1HwnRl7Tj2BelicLc9CaULZ/Kt3DQJ2wWeUaBE0lWQSsygrQze+SC5alBKY6b4z02o3TuP7xs3PQ6ZDW2Ud6Qd4f/oe+XgXJnllep/PondPndHlLyyQIoHViTE/FMWnyuQNVTyjGot+fTlqtEAm08hEEI6/Vh3aJsHKanANwk7elfHsD3wswNfEZHyBMNlWnY/7z8WS7Y/nr8W/bWLsMpuoV/Q9blAILvzXQcWVTOG2VD1qgRbfVUosVd0OBgfNbIUwgXS+YP7SaQPGXfAoaeZaemeZW+6TtsFBHc0QJUGPKZAIiVSVACJIumFSpLqSzNTWjT2dPpWOsL14Xk78SP3IjGbQAUGo/OrHTw7s4c8Hag97wovv6vqwHdVQy3dBqOcnPbuIk1y3SKl/UX8leZdG8k134IfCp389P42Pkqs5KPGHz7f+NrqBGGn/Fl70APNjPC/gHzkkv0AiD3UgmjOkrSxnAulnKly9Fl7WFGCtkUlaXQxSFzIHVZmp9i3YdAZQIyqnGEzrh7fEvqIbx+vkh1W1wGEJ8JUrFSb8Bcl6FsF0nMuVA9h+QVp7leZemgub2XK5lWOa8y9q/ju0BqpYeQjJhOVsg4Fg7jOkmijdJEBTZFblFUUS/zlg59rxtOQjOEVAbol1XDjBTH/ySNSjWyg7wpJL9gBSYs0I39bZJvrPSNL9EXwSHYSdZaH1QwOWRpomVlk2G9R6GDTXxRPk9G3DJZpldakpHWYhk4TggatW497Y4qU4axwhd22WDCfEUHjjISDUvqddJrHpRy8u9WLvEI/DN/EpyFacRrcKSygbnMPs1HLmm5YMWNIXlYid1CkyN/SIgPJAeWs2aXADPptahIcUY
 tiwreKrJ
 jPq8oAY20XPRaWbH/j2MsP9OtSyoPshbFH827A9s4d8XRpyjVA9BbjFyhmis3EFC3VWgd2OhSTuSG/gY2FZNxQUSKFFi4bvefXNKnIETNgwcHHWXw5VwUVvd8BY/nmSxS6Z4hBgoRVySkh9b4C4ghuX08HKdhPxc+/RlN8UXNN6Pxj3V1tYFoEcRPG7IvxYKfdLogkOujukVYeXjDlPcZNwTbxpKfXDszEe6cqDSyaa9lovGxeaXoDe8hCFH1SoWtgSx+D2Kq526yOh4IhhDQPZ3GNrNhifUBIDWEr3wot0JngufdrUaBILAZUnfEu6rBxgp5gaonSKgtUD7r7GZnCgQ1z57BqBvdZCFqZRrJ6ets4W92mBkVlBVImQGne/ffaCCUSORd451hejeDxf+lPIC/Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 17:23, Waiman Long wrote:
> On 6/16/26 2:59 AM, David Hildenbrand (Arm) wrote:
>> On 6/16/26 05:43, Waiman Long wrote:
>>> BTW, I still prefer the v2 patch. If it is decided we should use the
>>> guarantee_online_mems() value instead, it will have to be a separate patch with
>>> changes in the relevant documentation like Documentation/admin-guide/cgroup-v1/
>>> cpuset.rst.
>> newmems is "obviously" correct, so I really don't see why we should add
>> something that needs half a page of text to explain why it is fine -- if newmems
>> just does the trick?
>>
>> Please enlighten me.
> 
> Yes, taking newmems is a reasonable choice and there are pros and cons with each
> options. My focus is more on not changing how v1 cpuset behaves as it is well
> defined in the v1 cpusets.rst file:
> 
>     Requests by a task, using the sched_setaffinity(2) system call to
>     include CPUs in its CPU affinity mask, and using the mbind(2) and
>     set_mempolicy(2) system calls to include Memory Nodes in its memory
>     policy, are both filtered through that task's cpuset, filtering out any
>     CPUs or Memory Nodes not in that cpuset.  The scheduler will not
>     schedule a task on a CPU that is not allowed in its cpus_allowed
>     vector, and the kernel page allocator will not allocate a page on a
>     node that is not allowed in the requesting task's mems_allowed vector.
> 
> v2, OTOH, is more vague as to what setting cpuset.mems will mean and we
> generally follow what v1 is doing, but we have more leeway of what we can do.
> 
> Using newmems will make the above text not totally correct. At least the offline
> memory nodes will be filtered out which will not be utilized by the task when
> the offline node becomes online. That is why I am saying that we will have to
> correct the documentation if we want to make this change.

So IIUC:

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1335e437098e..cdfc615f35a5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2645,7 +2645,13 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
 
                migrate = is_memory_migrate(cs);
 
-               mpol_rebind_mm(mm, &cs->mems_allowed);
+               /*
+                * For v1 we can have empty effective_mems, but we cannot
+                * attach any tasks (see cpuset_can_attach_check()). For v2,
+                * it's guaranteed to not be empty.
+                */
+               VM_WARN_ON_ONCE(nodes_empty(cs->effective_mems));
+               mpol_rebind_mm(mm, &cs->effective_mems);
                if (migrate)
                        cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
                else


-- 
Cheers,

David

