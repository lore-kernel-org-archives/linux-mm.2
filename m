Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E318EDB7CA
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 07:40:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80E8E6B0088; Tue,  7 Apr 2026 03:40:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BED96B0089; Tue,  7 Apr 2026 03:40:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AE456B008A; Tue,  7 Apr 2026 03:40:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AFD06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 03:40:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E99E9C253B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:40:23 +0000 (UTC)
X-FDA: 84630961926.11.24487F4
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id B2AF01C0007
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 07:40:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G1s+Qrcv;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775547622; a=rsa-sha256;
	cv=none;
	b=HjnRRKKAJ/mboOUT8rGGOHYhRALk5Q40bcwBidmX3qZaeg++rozN/jk/XPB1BWCKowUaiX
	mHyba2GyHQqjMHwjTSY/x+oBdlsjQzabDw3ciQI9Z1GRV5IcrXrnXhJVzxbvjhcu4oYLtr
	tPJH98HKIebSDbLJmtwjtdTqCpbmhfk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775547622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DA1gS7QAqLDq83Q/XySCI7Hpj4QTI9z7098AZR9nD+c=;
	b=EEHeRZF5dAH6F+3uqe8aleQb97Y4eFyJbzYbUW9nL0eiokPTXTPRzo5eVfzo8FNsxdSq1T
	EPQY9r1+EYEh0a0RgtSZA5zlmLqTj8WNuzfLprXLplY0eXiWkrxXiK8TUHKUhbHvSf17hB
	WRna9MaAQaS+IMJBjoT85yc0ZxvU6mg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=G1s+Qrcv;
	spf=pass (imf18.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775547617; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=DA1gS7QAqLDq83Q/XySCI7Hpj4QTI9z7098AZR9nD+c=;
	b=G1s+Qrcv74XrXLHo4PZPgG41qiSVGuxsIOskpnKm0aWRsQYYo0cgammxUvK4OlQeH8DTFleHMahzOqzug27F8FR4J5qNyCpPlF3SvbHK5wbp+o+Xsn5OWQgYGv9frh3AkuVL3P4rCsEk/6M9V3RwmIefWCLt+EV/AlzzjM3CR8I=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R471e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=40;SR=0;TI=SMTPD_---0X0azkhQ_1775547614;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0azkhQ_1775547614 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 07 Apr 2026 15:40:15 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: akpm@linux-foundation.org,  david@kernel.org,
  lorenzo.stoakes@oracle.com,  Liam.Howlett@oracle.com,  vbabka@kernel.org,
  willy@infradead.org,  rppt@kernel.org,  surenb@google.com,
  mhocko@suse.com,  ziy@nvidia.com,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  gourry@gourry.net,  apopple@nvidia.com,  dave@stgolabs.net,
  Jonathan.Cameron@huawei.com,  rkodsara@amd.com,  vkoul@kernel.org,
  bharata@amd.com,  sj@kernel.org,  weixugc@google.com,
  dan.j.williams@intel.com,  rientjes@google.com,  xuezhengchu@huawei.com,
  yiannis@zptcorp.com,  dave.hansen@intel.com,  hannes@cmpxchg.org,
  jhubbard@nvidia.com,  peterx@redhat.com,  riel@surriel.com,
  shakeel.butt@linux.dev,  stalexan@redhat.com,  tj@kernel.org,
  nifan.cxl@gmail.com,  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,
  Mike Day <michael.day@amd.com>
Subject: Re: [RFC PATCH v4 4/6] mm/migrate: add copy offload registration
 infrastructure
In-Reply-To: <70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com> (Shivank Garg's
	message of "Fri, 3 Apr 2026 16:41:06 +0530")
References: <20260309120725.308854-3-shivankg@amd.com>
	<20260309120725.308854-12-shivankg@amd.com>
	<87o6kdzeei.fsf@DESKTOP-5N7EMDA>
	<70414c31-d928-41a6-89db-eeb0f34ec07d@amd.com>
Date: Tue, 07 Apr 2026 15:40:16 +0800
Message-ID: <87ldezfcbj.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B2AF01C0007
X-Stat-Signature: c1fmehrwhgo3kidwb3ksoq1eoukk5fh9
X-HE-Tag: 1775547620-332639
X-HE-Meta: U2FsdGVkX1/5UoO5SvCLEHJag/H/ZyyBIebgoJ1kRqBkEOMhgm4iJ1mIz8dOSwalEhnxw2lYWGmv/eclstaZz/3qCltkJSjZf81K3eTU7cjR6ULg0GU3Jk2jlmlF8si6PMGpXVxkmYEs4TmDmeoQIFdP8G+RQOEhcQKXKSNLVhHwA+M75/cYuemAoXWl8v7kvUvlICP8WThgR8ofPrNvnn9rbajd6GzVuxri2z71lSLsJeFx6bNSqITiKWX/C/mHwN7QR5vVHE6zSZhXCjDw41/VtIgfZpPpEZjr7lyOQ1tjlBj8RyM/XECDjqhgjxVa7YFcISEOUWqXmG+vMiUnBG1yUVHu1RKIYEJ3hdgc7hhqABqSuBLwGqtEIlJ9m1W7MhUpwsvO9xQEhA/HIVvIWXdjAxZbspOanmj9i05uq3qV+R7JC3BzvMIgJBsxr3YkWJL+QR8Jm74piWzE3dOeSyyJOqm5hpUrddlgzRXh5CjepTzLS8UW8pS/UocyrwHlXf/vvFPNuu13z9vaPiulkxYB4IPcC7Bf8EmuA6jo8e6Qu42BoZ6fMWMVElsN4amekpAek+gkQUhPf86jIr3EJ9OFE1hh6bpEWLyb+nWWkpAfUyNlzug3wHxmyeooEvxH+8Qwh51MQ5YdQZaSBwqHaYusnj5UDLGCJsYOXuwwoV/0aRvhagWRA189Hjt0z41HqtVgSB27SGxDHS+awaBnYbI4vkn4JtQZ+AmswkRdWVZ9xk9nHq7xnzJp9FDD1AG7v3KNJDF6D29mGgdZczgRrkF6wwN7r8uq8qFlAjbt/PQ6nxAz2qFzSDG53Ask/iAesmYT2aMzdb8X/RoRqu2yuMx5ziMH9UJkE4kHedmIebXXJvuFf0qZLvoqNwselWy2TDU7fHCtZFp0xG3e6I+BQVYWi15ju3YTLhTfijPlhEsaKnVPATOIZ16iu7tMWcwknMhuJkHaWEAB9LpyuAq
 llSBswiB
 kGeXLhAYqMpxB7sQ2D6wYUXA7bj+pAkhLJsQTky4ZnDQ7Gmuh1YxHV2M9W/c6sTCgmThSDZYst+TdydGGkxRpYJvhD4CfT8ZuQ3Nj1TKJH+S7exSguV2gNH5csImMffoMwHoJf8NJOQhAc1So1bv3h3hBHvAcHAyIxuYgeYI26iiPFObeCsFya3fa3bmnYSzlyqHubNgNmfCEH3KEi8G07UjnBXGBfXwl1EzmqRwcGx94oQQhnyxK7StvoEyaM5JRGVArPpnU4xH4YA5Rkur7QSxgLx8uLtFfIMPSEtEXNdL58/XXBGrrY67Z7Cmycnqub2JJMHiBFKRyISwvDoxH9hDNoN3h9lT2F4SAljZB/tAK23x3sMFThUFJ9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Garg, Shivank" <shivankg@amd.com> writes:

> On 3/24/2026 4:24 PM, Huang, Ying wrote:
>> Shivank Garg <shivankg@amd.com> writes:
>> 
>>> Introduce CONFIG_MIGRATION_COPY_OFFLOAD, which lets offload driver
>> 
>> Do we really need a new kconfig option?  IMHO, we have too many now.
>> Because we have a jump label already, the performance difference should
>> be trivial.  Can you measure the size difference?
>
> BASELINE (offload=n)
>    text    data     bss     dec  filename
>   23577    1632      32   25241  mm/migrate.o
> 39202900        14159750        6502152 59864802     vmlinux
>
> WITH OFFLOAD (offload=y)
>    text    data     bss     dec  filename
>   24444    2568      32   27044  mm/migrate.o
>     676      64       8     748  mm/migrate_copy_offload.o
> 39208218        14163942        6498120 59870280     vmlinux
>
> WITHOUT CONFIG (always-on)
>    text    data     bss     dec  filename
>   24444    2568      32   27044  mm/migrate.o
>     676      64       8     748  mm/migrate_copy_offload.o
> 39208405        14163942        6498120 59870467     vmlinux
>
> It saves around 5.5KB of size, when offload support is disabled.
> Is it meaningful savings? What do you think?

The size difference of "vmlinux" is 5.5KB.  While that of *.o is 2.55k.
Not too big for me.

From another point of view, if we will add kconfig for "migrator"
implementations, we can make this general kconfig option invisible and
be selected automatically?

>> 
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>> +extern struct static_key_false migrate_offload_enabled;
>>> +extern struct srcu_struct migrate_offload_srcu;
>>> +bool migrate_should_batch_default(int reason);
>>> +int migrate_offload_start(struct migrator *m);
>>> +int migrate_offload_stop(struct migrator *m);
>> 
>> Why not naming the function migrate_offload_register/unregister()?
>> IMHO, that sounds more natural.
>
> Ack. I'll rename to migrate_offload_register/unregister().
>
>> 
>>>  
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>> +	/* Check if the offload driver wants to batch for this reason */
>>> +	if (static_branch_unlikely(&migrate_offload_enabled))
>>> +		do_batch = static_call(migrate_should_batch)(reason);
>> 
>> Should batching based on "reason" be determined by the general migrate
>> code instead of the migrator implementation?  For example, if we only
>> batch copying for ASYNC migration, we should determine that in
>> migrate_pages_batch() instead of the migreation implementation.  Or am I
>> missed something?  If so, can you provide an example?
>> 
>
> My idea was that different drivers may have different cost/benefit
> profiles(e.g. setup cost, migrate batch-size, etc..) 
>
> For instance, a DMA driver may want to target only bulk migration usecase.
> And a CPU-thread based driver can be used more broadly, without worrying
> about setup-costs.
>
> But I agree it's premature with only one-driver.
> I'll move the reason check with target usecases into migrate_pages_batch()
> and drop the should_batch() callback. If a future driver needs different
> filtering, we can add it back then.

In general, I think that "reason" based policy should be in the general
migrate_pages function.  While "batch size" based policy can be in the
migrator implementations.

>>>  
>>> +#ifdef CONFIG_MIGRATION_COPY_OFFLOAD
>>>  	/* Batch-copy eligible folios before the move phase */
>>>  	if (!list_empty(&src_batch)) {
>> 
>> Guard with "static_branch_unlikely(&migrate_offload_enabled)" first?
>> Better to define a inline function to shorten the expression.
>> 
>
> Sure, will add the static_branch_unlikely guard and wrap in a helper
> function. Thanks.

---
Best Regards,
Huang, Ying

