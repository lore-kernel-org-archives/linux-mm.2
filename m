Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD9A9CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86FC6B00DF; Tue, 16 Jun 2026 17:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E9D6B00E0; Tue, 16 Jun 2026 17:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99BDC6B00E1; Tue, 16 Jun 2026 17:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66E8D6B00DF
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:09:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A540A01A5
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:24:26 +0000 (UTC)
X-FDA: 84886298532.03.77D9CD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2845A4000D
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:24:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RjLDQsiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781627064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1AASZfTRVbzLt5I/0GBJdZ/bjP6ci4PfAYJuRBn4WE=;
	b=I6Ft2YVsEZonz4RNWhvmHbxyqXY1qPxjuwkXfa3ybW8YkDdoi5F0zTiGIZOObmOUpAxlee
	BII1SlV5MNLluabINIbjMYrKa0087fnvyUH7dMgf4mPf30h4rgVH/NPX+PosN4PkMMwSK1
	z7FPmYrPJnUbiOeJMQZWa2CmuXt1QmA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RjLDQsiK;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf04.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781627064;
	b=6FZd57/7HgG+cOnWQnqYM7N1Fqr1Mz1LiVWo7JEP9g7pXVBEE29vpldSjnXlywB8noskj3
	BxKidTCN5KHR6VaUOSIeDTI6XNPLhmh/FOmZurn3NQvpPF+VHCOEzFCyqPGNGv6TxPQNfW
	DgfDyoZmFCtJfW4zTxJhKr6mxM/bXsI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781627063;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r1AASZfTRVbzLt5I/0GBJdZ/bjP6ci4PfAYJuRBn4WE=;
	b=RjLDQsiKwhpkEC6fGRrc1cnXviOH13pcAptW4wu2M2GUf0eJw9osSGPoqmSfMkbbhuryrw
	jpwdgQI4fe4W8Ncu8G8MWeuCDxqGHRxuqZqeNGhVw1vNkkmP+pSHrrijV+ZToB9HrGwe90
	4mkzr5EUU0bHvfszHcftt/c2H8kZek8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-362-YOZ8QqoZNdCi67PK60bP_g-1; Tue,
 16 Jun 2026 11:23:22 -0400
X-MC-Unique: YOZ8QqoZNdCi67PK60bP_g-1
X-Mimecast-MFC-AGG-ID: YOZ8QqoZNdCi67PK60bP_g_1781623400
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42A251954B17;
	Tue, 16 Jun 2026 15:23:19 +0000 (UTC)
Received: from [10.22.81.159] (unknown [10.22.81.159])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 12209180059C;
	Tue, 16 Jun 2026 15:23:14 +0000 (UTC)
Message-ID: <c61c7925-b9e7-4a6f-82e2-398849ad9f27@redhat.com>
Date: Tue, 16 Jun 2026 11:23:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] cgroup/cpuset: rebind mm mempolicy to effective_mems,
 not mems_allowed
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Gregory Price <gourry@gourry.net>
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
From: Waiman Long <longman@redhat.com>
In-Reply-To: <51eafe6c-6622-479b-b391-6d3ff9350e75@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-MFC-PROC-ID: n-J17MaXnVdCtLR16qnD-_FFXypxVVn0cZPssFaZzek_1781623400
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2845A4000D
X-Stat-Signature: a4hhqjrh3yu1tjtbtong8czzreah7iee
X-Rspam-User: 
X-HE-Tag: 1781627063-694031
X-HE-Meta: U2FsdGVkX1+ApGMAG1EHqQ3phz4/PZTzfqESFgwhXd2qRJaPA/Tmt+d3ALvewqVyWTgKNclBGO0PtOyK8uhQJGX8TcSWWHyX0UIbSnTqWUBQCE7zyPTaDIEA85SW7ISm/Nf06T8y61OGXGFQVwFR9nf84IWMwo48V1+Vuls180mYODeawpKIbdJkEFOTANTQS/KoqudfA0B/A6l4S+IekcBtLkYP2wpPmNHBZ1WEsjaJFuaTkAHATrUJP9J8x7GJFNhMzMfUyATievyDV2yjs1qr4KFo7SQLNwzdKTGKk/tQptIdWj697Nr7f+8wF9PWJGBGUItetjSr19bV6pz82ILdC6dux2LI3VmhIwe22uYG8CqF+F/Lbj8/GMleXswKLM7OiifRbKavn/xrp2TocQRKfZOutF+kfg8JvQ8cH4hajL9I3FP6b3hT9HJXQyIFp4uJZ6vyOLe14OlP277DdhUn42ZHcAfyXhZoP86MbEul42BOU5kjX5YtAxITKM3fVQf844jqGKzLlOR6vD+cjVYz6bKulyEvdpDsfLzaj5FKQurs0nTa8ZEJ1bTFrovq9q2ab/AuWbWGgL30UeyZRc80q6bmvR+rtNfB+qeE2wC1KhMxS7oUYRCZK82qLpEMUAVTpIsy+2PW7eS2RXsG7hBnbkqqCTidLtamafQcdAvvrq2TYxtAK371firhEgWt2NXuDIMJdaSGTEy6W4fgFtOvvnuhXmXMV5RnNgO5FA+r9SR6PuZ9N0/zcMYGFFy3cZCMZX+Vn3xDXKJEPWkalq1PdpFJFB6rHEylozFBXuDbCYPZTqXPqiqwvXJKvzFwdoAKuJFtNI0eNKN5EwN3Y6SJM+Cgn5a37kK6yQeINoa+whtb/M6L9QNxpNrH4XXTJn5LVaClHoA7wJsgMVXmtdpIcXyhqTKxapLGToz0A0eFic9zIolhR5dW1jgEefwdKaefwZ+jOUkthZ91h/9
 393oUgeT
 278K830UiicQca6Skvhm0O9q8vPvLOxk+fLfQHECC8GZD6DFi1EDv3gzuh7+IgAm61a8exSH2pygIZdHqcVbhLc7c37JW2+bKST05ipMjoS2XG4Vw9jfM/Jj+Pp3Rx7WgQEvo8B7QhacUhxwrQPHH8MQvwD6gZDPjvgn/UBhDBgFAROqoXH0JkHW48G3vMD620ka0o3lsWSYVXz9cxVPrVJEouXszHXzJ4/ZlRCV09v4rkIznykWH18GrFxcRKxrxWW3whQHyul25+cQsDxNrWph0HUO6cMaEjrD4S3aNYRcFdoLD/o5I7WX8V2sAeI29WolRJ3Yr8qNwxzsxvXf+yWhQ4aeqeYzTiBkU3OOnXWXChIzyvxie4R5Fu5Yd6bjQdviflwzvePp8EHExVPMUUACrybHnYqL6aCXycZMMu6Z6EiKLDzVBgV2UsAWkwCsWs6vexbFQd+RO4jaVTM+CvxjWWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/16/26 2:59 AM, David Hildenbrand (Arm) wrote:
> On 6/16/26 05:43, Waiman Long wrote:
>> On 6/15/26 10:26 PM, Waiman Long wrote:
>>> On 6/15/26 5:38 AM, Gregory Price wrote:
>>>> All interactions between mempolicy and cpuset are horrible and
>>>> confusing.  Much like Lorenzo's anon_vma work, I have to keep
>>>> notes on how this whole thing doesn't just spew SIGBUS constantly.
>>>>
>>>> The short answer is: mempolicy is advisory and cpuset is strictly
>>>> followed - in a dispute cpuset wins... except for file backed memory,
>>>> then everyon loses and nothing is consistent.
>>> That is what I believe why mpol_rebind_mm() a bit differently from the others
>>> and it is historically done this way a long time ago before cgroup v2.
>>>
>>> For cgroup v1, mems_allowed can't be empty or you can't put any task into the
>>> cpuset. Also effective_mems is the same as mems_allowed. cgroup v2 is quite
>>> different in how it handles memory nodes and CPUs. Users can isn't forced to
>>> set mems_allowed and cpus_allowed as effective_mems and effective_cpus will
>>> inherit parent version if mems_allowed and cpus_allowed are not set. IOW,
>>> effective_mems will never be empty. Yes, it is a bug with the introduction of
>>> cpuset v2 that we should have replaced mems_allowed by effective_mems at that
>>> time. With v2, effective_mems should contain only online nodes. The only
>>> exception is during the short transition period when a memory node hotunplug
>>> operation is in progress when a write to cpuset.mems is happening at the same
>>> time. With v1, it is theoretically possible that none of the nodes in
>>> mems_allowed is online.
>>>
>>> The reason why I am suggesting to use cs->effective_mems to keep the old
>>> cgroup v1 behavior. If the consensus is to use the output of
>>> guarantee_online_mems() for mpol_rebind_mm(), I will not be against that but
>>> it will be a slight change in user-visible behavior.
>> BTW, I still prefer the v2 patch. If it is decided we should use the
>> guarantee_online_mems() value instead, it will have to be a separate patch with
>> changes in the relevant documentation like Documentation/admin-guide/cgroup-v1/
>> cpuset.rst.
> newmems is "obviously" correct, so I really don't see why we should add
> something that needs half a page of text to explain why it is fine -- if newmems
> just does the trick?
>
> Please enlighten me.

Yes, taking newmems is a reasonable choice and there are pros and cons 
with each options. My focus is more on not changing how v1 cpuset 
behaves as it is well defined in the v1 cpusets.rst file:

     Requests by a task, using the sched_setaffinity(2) system call to
     include CPUs in its CPU affinity mask, and using the mbind(2) and
     set_mempolicy(2) system calls to include Memory Nodes in its memory
     policy, are both filtered through that task's cpuset, filtering out any
     CPUs or Memory Nodes not in that cpuset.  The scheduler will not
     schedule a task on a CPU that is not allowed in its cpus_allowed
     vector, and the kernel page allocator will not allocate a page on a
     node that is not allowed in the requesting task's mems_allowed vector.

v2, OTOH, is more vague as to what setting cpuset.mems will mean and we 
generally follow what v1 is doing, but we have more leeway of what we 
can do.

Using newmems will make the above text not totally correct. At least the 
offline memory nodes will be filtered out which will not be utilized by 
the task when the offline node becomes online. That is why I am saying 
that we will have to correct the documentation if we want to make this 
change.

Cheers,
Longman


