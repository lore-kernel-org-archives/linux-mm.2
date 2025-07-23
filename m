Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6EFC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518B26B0098; Wed, 23 Jul 2025 05:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0876B009A; Wed, 23 Jul 2025 05:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D5F6B009C; Wed, 23 Jul 2025 05:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 361996B0098
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:15:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA6A380650
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:15:18 +0000 (UTC)
X-FDA: 83694970716.14.2C0DE64
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 29CC9C000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:15:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rv+Wuc56;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262117; a=rsa-sha256;
	cv=none;
	b=1QG3N8eyTJJB26Y+rrkBT82MngO2a5v+H0ioOBw8Qeyg3BzHg7K0WubThGXDRepbkGBHrB
	oOeF7P+D9qgcS28l7HBVrJnyim/cA1sTsh8qZ0yV7Xpuibs8rXlvVLAi9GOPB3H+t7BGCZ
	ffNPi2JYH7j6IVfgYLSgylraXKFVAig=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Rv+Wuc56;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of liuqiye2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KfmIGalj8HpP9qPJNlYe/A5JdLaudkbT95VyHLqIUDk=;
	b=5tuqAGXuxvgLP6ORFmCXO0vxy6o3I8guHf78Rbt3eQeKUuvUJuwS2KJzgeLkwOD7T/+VdV
	RzhBB8e8Nr+xB/AScZMcKvc39axHOfy2yI9E7zQCjUiicry6yImBvv0aTngO6gGpqK3n18
	fxsxKly7k0xPQ7Hcvmj/8m/w8r0h9QU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:From:To:
	Content-Type; bh=KfmIGalj8HpP9qPJNlYe/A5JdLaudkbT95VyHLqIUDk=;
	b=Rv+Wuc56ztzb31Dd43khMV2ID4Z/PK+JTzL+s0RycDbhKOp3Wxrp4OpyNQmSI6
	57ZXhuWShkP8SVzuSrAVa3jxkyLKijznWnx5Qxr+Ovm9VuyKXFpsaIrpilwqKM91
	MaxKngNic/o/xfNzcZcarHLReLpDQ6OrCE/PivkZ5GLzY=
Received: from [192.168.22.151] (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wBH737sp4BouccnGw--.323S2;
	Wed, 23 Jul 2025 17:14:28 +0800 (CST)
Message-ID: <270d8240-fb64-46e0-a534-80790c4cc905@163.com>
Date: Wed, 23 Jul 2025 17:14:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add stack trace when bad rss-counter state is
 detected
From: Xuanye Liu <liuqiye2025@163.com>
To: David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250723072350.1742071-1-liuqiye2025@163.com>
 <202507230031.52B5C2B53@keescook>
 <c7a32d87-efbd-47bd-9a18-9eb51e441a7f@163.com>
 <119c3422-0bb1-4806-b81c-ccf1c7aeba4d@redhat.com>
 <8dd1e8f6-f96d-4d36-ac2a-c258ac842f75@redhat.com>
 <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
Content-Language: en-US
In-Reply-To: <5cdd3e44-3e3c-4697-905a-ecc61093f7bc@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBH737sp4BouccnGw--.323S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Zr18Xr1xWr4fAF17uw45Wrg_yoW8tF1kpF
	1rKan0gr4kJryftrn2v3W0yr15trZ7G3y5W3s5W347Gr90qFy8Xr4xKF4UCFyjkr9Yka9F
	vr4jgF9ruFZ0vaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jodgAUUUUU=
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbibhOTUGiAnoznpgAAsF
X-Stat-Signature: mpuf1zh8gjdwkqiroekdc33o3csyerp1
X-Rspam-User: 
X-Rspamd-Queue-Id: 29CC9C000E
X-Rspamd-Server: rspam02
X-HE-Tag: 1753262115-841692
X-HE-Meta: U2FsdGVkX194jTN0cq82Uu6MqJWk7yUKRLyV2VLx39UEmziteQu8ldFqdYG6hgm0j1T6M+JzMhHfmoPKOtedlWhuD3hdCstl2OCiQiD55PO97StHL+lenKc//E6mJ4idL2soOQvvPAp8waCcopSGGZ2bRlEaCtSzKQiknceWBX94msFKriQwoiKpeLWALaMGm/EZ94QoXXLZIOdqP6YCILCc5xwS+eQBFlUlXTtizcTQuAbywi63PUlurabGnsx5iD95zNuD/PF1RfZaBNC9cyWtDqLbs/rK2+xjq0qz52FOIVT7szhBELK607c4z2MiE/E8OgI50gr621ztNrjWVbdUdb4ZiaOdPajtkMf7qiRhI6dBkKG4EDDr9xyAEL5C9e7kZpDvKH84CdAOpi2WdPiYy2kfFFDUvB0AKjWwfeUarfHb8/Gl8RRKg+MhVAz72cWwDDCx8I3zEW3eKGWZEaepzSKu/Kr8i809yBauF+XP0sMKeOJwVYsFNur5pPnghAtPx1kSoITSTLYnDunoYO2Hcut2ogEU2uyabkW6fBSGygaX+FpdXisExbNBgjs6lDglMHmizcH9bChqjcd0oB4YcaH0sshHShqyy/pEdQoZDnNc+DplNUkXTzuAuCPNXa9iiuX719G0uJbGre09zUA2qXVHs5AmtlC8R+v+O7cX7Fk7A6Wf2dL143IGNLt+xyklrUNZowChQhS5ff2bA6SELbhG/MysW26u2XvJ8ii4eP/6aWHGhWIxsPDcZdjAleNbtWusnMFmuiyBIGeWPlO2Z5CN8QRGBL7t/N7FwXUE9bCFIZbzYb6xjddgDstfROK3NVU5gNZqrsNtpcLAaBv/Dx+KS/vqWPPnZyTFnrV5QVeZqd22SL5lftQkdn8TJxkKmSPzzrhxVno6HGgzzKXlZf6DYYCjXCFWgUjF5ChhYNgHUXpV7rTysVG+GdOdrSIVclSTmupLG4c6JA5
 Ux+fI6j5
 tydAJOkxJUXytd3lsCfbDkxNWu37Yq6jwRvs2rGZXrJCnUBuHwg1dQ04bL2kfLXnmV/rTWf61eQciAPZcFvMeyFxgjCUkNF17/glJv6nFg6uo0OOFyDfjoOrBlneo9hIzsxWVFIw62+KZkOO7Hjj98DjSZNSX74kA/sdLyHcNaCZPBRMQZ9VyowSprYb/GAZQeYqsYrQIIs9hdWe5hnGMSvvek9bR3pCmpD5WwZfusNV6XcAJrSaLlL+eQJxNKahgbwc5KaIxOa6lrsjCBHv/t+g/8A0ekaEmv7bvMQh3IDlFOvNEj5Lvjp5/9Nfo10gRD98x0IMfdPWZQvXdbJ3J1FwNOpxp70WjEebtaK01NAbar+Vfhk+xshXRafOqCZg+qG1Le+fAtZEuurwjULHPLwC43CkXOwGI2vIoKRtrMTaizHePpVWBDrJaYTLDqYip9Wf4a+Ilc9mF9YJEbvAlqVHisplWt7UT9N0+r24Syp7qlJQn0zmsBa9ExA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/23 17:10, Xuanye Liu 写道:
> 在 2025/7/23 16:42, David Hildenbrand 写道:
>> On 23.07.25 10:05, David Hildenbrand wrote:
>>> On 23.07.25 09:45, Xuanye Liu wrote:
>>>> 在 2025/7/23 15:31, Kees Cook 写道:
>>>>> On Wed, Jul 23, 2025 at 03:23:49PM +0800, Xuanye Liu wrote:
>>>>>> The check_mm() function verifies the correctness of rss counters in
>>>>>> struct mm_struct. Currently, it only prints an alert when a bad
>>>>>> rss-counter state is detected, but lacks sufficient context for
>>>>>> debugging.
>>>>>>
>>>>>> This patch adds a dump_stack() call to provide a stack trace when
>>>>>> the rss-counter state is invalid. This helps developers identify
>>>>>> where the corrupted mm_struct is being checked and trace the
>>>>>> underlying cause of the inconsistency.
>>>>> Why not just convert the pr_alert to a WARN?
>>>> Good idea! I'll gather more feedback from others and then update to v2.
>>> Makes sense to me.
>> After discussion this with Lorenzo off-list, isn't the stack completely misleading/useless in that case?
>>
>> Whatever caused the RSS counter mismatch (e.g., unmapped the wrong pages, missed to unmap pages) quite possibly happened in different context, way way earlier.
>>
>> Why would you think the stack trace would be of any value when destroying an MM (__mmdrop)?
>>
>> Having that said, I really hate these "pr_*("BUG: ...") with passion. Probably we'd want to invoke the panic_on_warn machinery, because something unexpected happened.
>>
> The stack trace dumped here may indeed not reflect the root cause ——
> the actual error could have occurred much earlier, for example during a
> failed or missing page map/unmap operation.
> The current stack (e.g., in __mmdrop() or exit_mmap()) is merely part
> of the cleanup phase.

Dumping the stack still has some chance of helping identify the issue — at the very least, it
shows which task triggered the check.                                                       

>
> Given that, how should we go about identifying the root cause when such an issue occurs?
>
> Is there any existing way to trace it more effectively, or could we introduce a new mechanism
> to monitor and detect these inconsistencies earlier?                                         
>
> Let’s brainstorm possible solutions together.
>
-- 
Thanks,
Xuanye


