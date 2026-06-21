Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A596CD4F26
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 03:24:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4D66B0005; Sat, 20 Jun 2026 23:24:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B955F6B008A; Sat, 20 Jun 2026 23:24:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86EE6B008C; Sat, 20 Jun 2026 23:24:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81CC36B0005
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 23:24:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D39B28D1DB
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 03:24:27 +0000 (UTC)
X-FDA: 84902476974.29.845958A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id A47BA140003
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 03:24:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ql0NSVmN;
	spf=pass (imf09.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782012265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Yu2mki38BefPDLre6bXeAKMaOu1RLSJX8hzP70eax4=;
	b=ZSt62kWZfFkDzW5508hhHH1ud8cWuPvTbcnlD1Fu3nihqcOuZM61RlLbFPmBnN8bxVOPqM
	Yb7RToKrV1aGcQqaA5m4KyDiqh219hZevbS5Ntq14O3F6nk7ZQi7+x5MVUUlh7Fn9vkiYC
	yPouX+cZHl5KNryK+xquS7bQ+OjEr9M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ql0NSVmN;
	spf=pass (imf09.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782012265;
	b=rPwRCYhpvq1YA+Zu6I1RvrZJMCvSiVTV2pihOL70mBIY5qCCFRg1a+M3Yd4p1Z3eoD4n9/
	Kr9oG1bodbUlC/dBt53VmGaKpMZ1A7f/jKd7fwTHNhVE/fzA93HfbTwuU8mHCyi53amOMJ
	HkpReB9PKmEb3Tozw/w8XIpV0CRlZ2I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1782012265;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Yu2mki38BefPDLre6bXeAKMaOu1RLSJX8hzP70eax4=;
	b=Ql0NSVmNNSKeQlb1dmm/fN0Zt4fyvV0VdkaA5z9ZHPPt1fg8F3E2DX5yenjzU3DdMhavMs
	Tu6J1lWo6ivjp0rZHkx/Jivr6aBVixe1URlLrAuYhg4OCkdLFBGLH59pgDFv81c6JCOoXE
	nHTC3sqd32SljTuw3jv9Q9l4/tBS7xE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-537-HmnhANAkPfSLuV-PbR185Q-1; Sat,
 20 Jun 2026 23:24:21 -0400
X-MC-Unique: HmnhANAkPfSLuV-PbR185Q-1
X-Mimecast-MFC-AGG-ID: HmnhANAkPfSLuV-PbR185Q_1782012259
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 448821956060;
	Sun, 21 Jun 2026 03:24:18 +0000 (UTC)
Received: from [10.22.88.8] (unknown [10.22.88.8])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id AE5FA1686;
	Sun, 21 Jun 2026 03:24:14 +0000 (UTC)
Message-ID: <9d8b650d-6faa-425a-8db7-1e206cb25158@redhat.com>
Date: Sat, 20 Jun 2026 23:24:13 -0400
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
 <c61c7925-b9e7-4a6f-82e2-398849ad9f27@redhat.com>
 <38578aea-61c3-4328-aee9-8e7421672647@kernel.org>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <38578aea-61c3-4328-aee9-8e7421672647@kernel.org>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95
X-Mimecast-MFC-PROC-ID: 6cQVd_mBMY2Yf6gVxr7g72uRAcTDb54paRLr6yQXSOw_1782012259
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A47BA140003
X-Rspam-User: 
X-Stat-Signature: j7b5rqqtsagwb843aofd8kxo38y1uus5
X-HE-Tag: 1782012265-749676
X-HE-Meta: U2FsdGVkX18l44Yie1RkeXDMxT/tnc/hF4ueic9ndY86o3VWxXiI2c282/cxJUOr1OK8n8y4xuomxNDdNd4i8El+crIRF8tY0XISYOg1DiWfrXCZFJbjkUo0mw3+0BQBDBehbZQzsdOwwV+AGVbMD4yZAyd/RkRmy7tOw3Y0eQR5RN/WNEEud7zY1UUwj4M6WAwgqz13NF7wm7jFwO9ZP3XyCWFURpsvT3rh504UG3ToD1KOfOzaF/GksqgxHswt7xZf0wvSqMykdAtF+mOKJjTUQTY6QT0uJklhkfvWcas4xTFIP4ikX7sfe7hVGs+wRjV4ntVAl91IrT1FqKI/yXVGyGfXb5xofls5TmFjUM92weM+XHC/psZ3oncVvFdXMQOE2tMxScuX2YIZvW022QpanQKJ/ggZ0CixMKqa8NeaE/KVtN1n8oRljUuQJS79XsCq1GRh98kqwr2qvi6lqmtwrssa3m+0Os2owDH2TpMJ0L8BnZJ+HGtGTRpYTHrgwjnaDLxnwVDgUmEzffl8NApPKdQsK8MChWz0FZrLQVXaurVgFGtbu8VjMf/iZiajWPIJICA3pfiMvZ6DDmrG6agYX9b8ZYW5aIeGi1LDB+LnaoymZetM68EKH0sRy1MeA3Seev98lXDzHPU4LQvCO+wP3kzpdog+EttoauiNrmMl1jsTMIFFLAa9fQilt8nAcTfgy45InI1UOp/Q31kkSXpdA0H3GQe+ixrIxS0lk2FFtJew4ZsIMrNSpD+QnzKKvl8tDcw164lk/ZZxwN05mhtIjglQBlYEFRmE5OUT2shUDbIgOh++rYEB0qT7U+LXYfBJz/9tKDzwuBGuKK4DkFmO3hPTEqicnJUxEeSoTmDas5kJj/hjgkTFamzBFkCweUtFSmth5na20WlqiVpYHSF2zxesPQREYvcoI7gip89yitbT+RmIwzYwMzl1qPQ4nWovG+Bv7koZ3T3uze7
 kxJJvnE0
 ZBMseqmm0doMxIJNxiJDUDXxjDKiNMZlcgyCbMbxAOqcyLb3wwZ4zwuqxSXpAPVssp4tfCJyqLDSknMjyzqUWF4isOJ3EC6ye0IPpwB7ixqyuW5RrRCBG33+bzJnRDVfBp/qTGJ+6triwoLc1gSwEUcw89BqBhZi8/AHmTQOC550JlF7IJYia5VjfBwCs1g1dpCZNm+QKEXXfU19EpXc5xAx6OE7HWSa/u1FF72hZ1Ieix+sno0lDgak7q5Yc0uF2W3uwzrdppFAP2uQ0rz1n4i5hKcct1qCvfe3bNZoaDZqOfS8qi8cqZCeJa9BkHdZxWRFV8qY4LKEHd32JfhWQ6onhwcnI1BugOmNByR4epJJGUajXWx9poKlKCw8xn5UotC+lytPtiWBUTSr2byrVI95dNvCkqn/hbuA7LITrR7eAe+a63Gz+MqtS36xq89nCWjr8V0yJFHkVXDn/wkMLLao+2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 4:41 AM, David Hildenbrand (Arm) wrote:
> On 6/16/26 17:23, Waiman Long wrote:
>> On 6/16/26 2:59 AM, David Hildenbrand (Arm) wrote:
>>> On 6/16/26 05:43, Waiman Long wrote:
>>>> BTW, I still prefer the v2 patch. If it is decided we should use the
>>>> guarantee_online_mems() value instead, it will have to be a separate patch with
>>>> changes in the relevant documentation like Documentation/admin-guide/cgroup-v1/
>>>> cpuset.rst.
>>> newmems is "obviously" correct, so I really don't see why we should add
>>> something that needs half a page of text to explain why it is fine -- if newmems
>>> just does the trick?
>>>
>>> Please enlighten me.
>> Yes, taking newmems is a reasonable choice and there are pros and cons with each
>> options. My focus is more on not changing how v1 cpuset behaves as it is well
>> defined in the v1 cpusets.rst file:
>>
>>      Requests by a task, using the sched_setaffinity(2) system call to
>>      include CPUs in its CPU affinity mask, and using the mbind(2) and
>>      set_mempolicy(2) system calls to include Memory Nodes in its memory
>>      policy, are both filtered through that task's cpuset, filtering out any
>>      CPUs or Memory Nodes not in that cpuset.  The scheduler will not
>>      schedule a task on a CPU that is not allowed in its cpus_allowed
>>      vector, and the kernel page allocator will not allocate a page on a
>>      node that is not allowed in the requesting task's mems_allowed vector.
>>
>> v2, OTOH, is more vague as to what setting cpuset.mems will mean and we
>> generally follow what v1 is doing, but we have more leeway of what we can do.
>>
>> Using newmems will make the above text not totally correct. At least the offline
>> memory nodes will be filtered out which will not be utilized by the task when
>> the offline node becomes online. That is why I am saying that we will have to
>> correct the documentation if we want to make this change.
> So IIUC:
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 1335e437098e..cdfc615f35a5 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -2645,7 +2645,13 @@ void cpuset_update_tasks_nodemask(struct cpuset *cs)
>   
>                  migrate = is_memory_migrate(cs);
>   
> -               mpol_rebind_mm(mm, &cs->mems_allowed);
> +               /*
> +                * For v1 we can have empty effective_mems, but we cannot
> +                * attach any tasks (see cpuset_can_attach_check()). For v2,
> +                * it's guaranteed to not be empty.
> +                */
> +               VM_WARN_ON_ONCE(nodes_empty(cs->effective_mems));
> +               mpol_rebind_mm(mm, &cs->effective_mems);
>                  if (migrate)
>                          cpuset_migrate_mm(mm, &cs->old_mems_allowed, &newmems);
>                  else

That is true, but I don't think we need a VM_WARN_ON_ONCE() here.

Cheers,
Longman

>


