Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E731606A7A0
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Iu/eUn1W
Received: by kanga.kvack.org (Postfix)
	id 8457B6B05B1; Tue,  3 Nov 2026 10:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6AA6B05BD; Tue,  3 Nov 2026 10:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70E476B05BF; Tue,  3 Nov 2026 10:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 511016B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:22:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8345B14046A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:22:47 +0000 (UTC)
X-FDA: 85394175174.04.3C15F7E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 522AC180004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:22:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Iu/eUn1W";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+H98LPenOtXM20iyFs2uc1o5Gjvbk6CvWIcoeiCnUk=;
	b=G+jdqcxCpXVxQZkNxxyqCrt3Uzo57itIG9+kyj059qoH4r8HizKID/CY8NPAXb6YRuXHk3
	hgYad3uVmkIEwuzi9AEo1PzguGcfNAQqswgXUWoNrorw4tSWVEyVIEvSIkTfYPKD87jm86
	IjAtB+TxAb7b/5Y+SJM/WGM6tZ+pRZY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Iu/eUn1W";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719365;
	b=kBY6FER73b9G3PNAkdWyzP+yMBrdxYd5eNcq4BrlK/uu3eoKVdiDAyPQdljqrw0K72BXgD
	NM+rojzV8A3dwbP5aho6eqZDVtKJ8vxOEQC6RXC4nP23YZm1dxkftNwRVWfT3vU3BxZDLW
	3wzbGq5rW0BLdm0DMVIJbc/miEBiPws=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793719364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4+H98LPenOtXM20iyFs2uc1o5Gjvbk6CvWIcoeiCnUk=;
	b=Iu/eUn1WYtB4MmUYpENh4yto/cqyDYmMP/wdyZ8Z8b7cfZ7B8P36YtJiZfu3tGUoWBUqOH
	3sykg3G5yaENEBraxzCGdubsI44dz1zTejNiXGQ86rs90YerukezsOY1cXaLC6iMjAA54h
	0tAN/SMjQRUUL8kFtkEZA29qUzBi2rw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-652-ZpBEt-W5O6Gb3NzZNS-d9g-1; Tue,
 03 Nov 2026 10:22:41 -0500
X-MC-Unique: ZpBEt-W5O6Gb3NzZNS-d9g-1
X-Mimecast-MFC-AGG-ID: ZpBEt-W5O6Gb3NzZNS-d9g_1793719357
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA50219560BF;
	Tue,  3 Nov 2026 15:22:35 +0000 (UTC)
Received: from [100.91.18.181] (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 5C78C26C;
	Tue,  3 Nov 2026 15:22:30 +0000 (UTC)
Message-ID: <e2b45603-fedd-43ef-b3ee-63846b05bbd3@redhat.com>
Date: Tue, 3 Nov 2026 10:22:29 -0500
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when
 cpuset.mems is written with O_NONBLOCK
To: Tejun Heo <tj@kernel.org>, Matthew Ruffell <matthew.ruffell@canonical.com>
Cc: Frederic Weisbecker <frederic@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Caron Wills <caron.wills@pulsar.com>,
 Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
 Jay Vosburgh <jay.vosburgh@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
 <20261103075940.110308-6-matthew.ruffell@canonical.com>
 <aun2vUjloJjH3Hpb@slm.duckdns.org>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <aun2vUjloJjH3Hpb@slm.duckdns.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: e3N5h_ekvm_sUq_jM415ScA33KECQdGW8h3V5tMXf9k_1793719357
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 522AC180004
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ggx3odwpi1c3y3px6x7r46c5i5agikbm
X-HE-Tag: 1793719365-917606
X-HE-Meta: U2FsdGVkX18cXaKYzNWMozy/yf9Z0xpKLfXFvE1ZGhl5WT7f8F7Waf4ZgCdZWwoIVIrncKp0skPH1xMf3txqSP303KJYaQqK2cTlbMh94vgS6yxXU6080XSc/pgRleVKgJJKu+aD7i1Gw4BMSmrVArAHdjkjG0+szFsJdYEAn/zD0oLolkTtNsXR89i7bAxCBkQhXdBg3lxdb+AxSXZAIu2p/13cFh4rS4/sDEMESZL58Yj7SBWGRtoOAo6C7oYalM4en1HEho+woH9NldtcazRRUdAZx23hvTVx7W38aDUW4AjMk033QrMU7szLCcfg/2I4zLniuf6Hnx3JmS9bkdLFHD52gkcA8EP2HYosAbe4vOOCCivwwtB9KmY45ImS3VW0Vep8O6c7Xcb/kFxdEY03l8weej6abYb4zwPJQgwdbmHC9UpTrr8qFjAGMDluK0FY1WZdyZD2bvBmBYtkaJodOmovAC8o0HvExHdKFSMIZA/t07sLer3T2/Zao514oFg/OVdGXM5bSG4TFtTe0AGFzVZ8/VjEaKQIf1CyyW5kSPGc2+LCTS6R62bWBdkG0dou8IMXrMjZnW4RXb90rsnPaQC8KXghXTpr2bz/oO/xNMqr9j3Pi+WfNBKMTWx2+MQZ7h0R7WT5+2o6QH48wD/J8ly69i6N/y03yH2wgDHn+CJiSVXMCE/OPE9GdZGnRv+5dU7cjPYiTE5ot+Xxt1ejS27kKQa6768okZ4t0bHW9lo879RsntXzIyjMyAVD8wqZvaFI/auy2cGo85YcgQPsksW5wnqOokwDFlNWvyWG+LcoIDsRauEkrS55JAR0Ml/JzgCC8KS7onwQYDA/VdfoIKNFqyiEYcOEiFCf9kCvR8UzM3jx9arHYZABHc59qLWCsKWme0a7O+oFRMPlEiWdBtfODKTyROB0hodT/pzehsBTmzcecjrgD2V9UmqpzHgMWvEPIPwBX/y4Nd/
 e2/hlR6/
 gd04lvo7Cx9Z+QC3G94jPhKMRFRXHFyZF9jaHTu98KjKcAfFgaWhs7uay8zeHN8mcDjIxpc2JZhBV6kVBfgKcJ7bjUxeTl4LTIfpvZVLOUZ9x8bsAnppGQQ6K5YiE1kFs2tqqpHb1+P4iKPo5jY2B33/x5LNY3zBgfsfrggfKnVgNWcScqhgJp8apgRueCQXs+F6caEXMqs9hs6vQLokABgu+008nIaq6zNOKBTLlT3Xyc1CqVkyuG0cUMWSLial4Rb/LU0m1JD6vAWTJOVRuQHDg+AAkcMyODYic5HEKU/Q+s/l9QBRpBBhP1MJAH4XAHhoCOx+O4uZY/YesCHmozqAyBdBGhT7vk5f+s+pD4dM6SEL4+zW8jMKdiQKOFgJwJNmqa2cXoOsY0nb/Axrie30A4dFP1EBPnCAf5+hzEGXTofWhKoXaLawhxxLFmHa2+0mTvuO1vhrlft4E6DC6r+eXEWEuhUBuOHmzLq1Ja2/C9TkxzKgxa5SMsCvDZIEowayR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/3/26 9:59 AM, Tejun Heo wrote:
> On Tue, Nov 03, 2026 at 08:59:39PM +1300, Matthew Ruffell wrote:
>> From: Caron Wills <caron.wills@pulsar.com>
>>
>> Writing cpuset.mems migrates the memory of every task in the cpuset on
>> the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
>> ("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
>> writer flushes that workqueue from task_work before returning to
>> userspace, so that the write appears synchronous (the design of commit
>> e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
>> therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
>> migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
>> that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
>> in principle: a migration blocked behind a starved kworker or a slow
>> expedited grace period holds up every migration queued after it.
>>
>> The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
>> itself, and since v259 it opens every cgroup v2 attribute file with
>> O_NONBLOCK precisely to opt into asynchronous semantics wherever the
>> kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
>> the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
>> introduce non-blocking limit setting option")). While PID 1 is stuck in
>> the flush, logind cannot create sessions and SSH logins fail.
>>
>> Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
>> the file was opened non-blocking and let the migration complete in the
>> background. Blocking writers keep the synchronous behaviour and the
>> cgroup.procs attach path is unchanged.
>>
>> This does not make the migration any faster; it only stops the writer,
>> in practice init, from being held hostage by it.
>>
>> Link: https://bugs.launchpad.net/bugs/2165410
>> Signed-off-by: Caron Wills <caron.wills@pulsar.com>
>> Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
> This makes sense to me. Waiman?
>
> Thanks.

Yes, that looks good to me too.

Maybe, we should also update the cgroup-v2.rst to list the condition 
when synchronous waiting will be skipped when updating cpuset.mems as it 
is a behavioral change.

Cheers,
Longman

>


