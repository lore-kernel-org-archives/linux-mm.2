Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9CF3E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 04:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A576B0088; Tue, 17 Feb 2026 23:50:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C481B6B0089; Tue, 17 Feb 2026 23:50:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4A716B008A; Tue, 17 Feb 2026 23:50:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E4C96B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:50:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3462A1C438
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:50:32 +0000 (UTC)
X-FDA: 84456351504.08.2EE26FE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1C40B18000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:50:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771390230; a=rsa-sha256;
	cv=none;
	b=o3r0ed3qEJbm9AbuZZYXdd52xuH0jC8UJZlSmu22HPcseUUfasDrTbWSPUsqefpCoi7BL0
	MYGht+EDRXriYdbjDk6DADE8sAckn2/jfh90OHORvOZABqwUShgtzT0hpzDM5A7xLd2pfK
	fcluZBpgQkO02sapZJvNPoHDbUMM23A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771390230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QRKLmVWmeBE1n35RnPgSettqMdTarJ3x0ofKR0Onz9c=;
	b=GJG2ysUKf1tlFRYwLSRLlRadaH6gr6FbnTOYVfvlKQMXVAMLI30TP9/qjpWvFYlkd2EEhE
	5SxjbIrUSsnHhmdfbwkLu6TtJlSjT0aAgvx69MKHOSEjbOhnjZ1LHWJZUpHW/V+5CueQvP
	QMdtEzxtPTKc3DVNENF2b5+UMdS3Z5w=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 917C41477;
	Tue, 17 Feb 2026 20:50:22 -0800 (PST)
Received: from [10.164.19.71] (unknown [10.164.19.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B4E3B3F7F5;
	Tue, 17 Feb 2026 20:50:25 -0800 (PST)
Message-ID: <b7ad1462-4672-448a-920d-ace9cef689ab@arm.com>
Date: Wed, 18 Feb 2026 10:20:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Luke Yang <luyang@redhat.com>
Cc: pfalcato@suse.de, david@kernel.org, surenb@google.com,
 jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 willy@infradead.org, vbabka@suse.cz, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
 <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
 <dhoz2eeqdx44sf2epeorxs67v5zohutgxniourumsouz22qbl7@gijuj43edjb4>
 <CAJuCfpHJyHH4=kcQcc_RUPhmLBN8HckoDW0DHiUe+FdQ+tr2NA@mail.gmail.com>
 <764792ea-6029-41d8-b079-5297ca62505a@kernel.org>
 <71fbee21-f1b4-4202-a790-5076850d8d00@arm.com>
 <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aZSoyjQHvVWFBZdZ@luyang-thinkpadp1gen7.toromso.csb>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1C40B18000F
X-Stat-Signature: buftai6djyf5ip81m1ku8g3d65fghs7w
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771390229-27850
X-HE-Meta: U2FsdGVkX187rumg5dS8oq5zMhv3eX2DBjOgZ5l02YoRT4BKmm0UkYPnRnPmcAFzqKrHV6Cg3Hm1T9zBDGPribzxMgEFS6CviNYBudao7J9GSi/wWP51OBkU3YjN1LgpFyZT61ZulVpZSIwxhZ1+o9gPaGU3tIebUL9UpGN/1TIZdAMIItBrhwO97D+/MmNe2Gby9ixupkEipMvYKwdBlGXd8bLJCTgPlPbtXst1kX7PFQZvbkJfjVqA5u26X9nXFW8dL7RUQmeHJ29SzTGuMB1VRlxHjTCwy1bCJjJO6R4AMCFiGr0G3rhCT8OBE1UG+xHNXpKCvomLGoIzrvltsvYHaAc2dD5XWmPMjTxl9rTg4MFIzhOfmng9uYoP05LRzNM056loKv3gNVVnt7jY7Xjb3W1/oYJ6cT1Qa3RVhSpDU5GxG5hlpdHjYl8ID0PgDwkrcWE9Wdkkhfw+fnSJNjylwO7tic+B+4k1qTLeJQ6eoPbeHX0xMEiokBSB99fyLVfAA2fiuQlf85xctPFGBpDa481qNsCO84taexVE7JKeE0C4xQKaBQHa00jwfwksfQtu/m9mhepV16/PpwT6HgpWBQ5g/Leh5OUgzgUmj+ty7F/C4bXai0fe9eBFwYM5mxzFk8qFbVaVx0LifHJHgoDjsdAMdES12VuuHxQLw+7ETs7ablpnqP33vmImXMq9+f93k6j9/H5yobQgMjFaZWqpQvK9bMPTdJ3w0gyXq+nYLEGYha1Ys1ZBxArDwzbOSjBbvzfyzl7/fGfwS0nU74hGKDss7jZ8cIWGuLf+2H0LSkIlDFyFX+jIMSbewcSovzhHsn0JOn6NaZ6yVxtbIXPpwGTZwRLfTh0eKqgAeOgvBk30lYYLQHMNcnmDPnsXuM3ItmW8R3gr5giHRtU+J9liaFcU8O5OhtExbXTifDyQT+lluzATK3JvHZZwFJGEcPOX33RFYg6bW1JREaf
 ZTAopGw3
 hBMSlgUWblRjSReGyF8hF+QGw43NzPhMCM+/vOm2o1N+SBRLKH8yvm0RR2MrxjyJGIbuS48/w8SGjafBBHG/PbLGzxUJGlTq5HU6iPqV5d6f5bnPNp4B/uFwfzoihXk+sarEqZ3OfOVfk74ByuP4zu+yIHaAhLYAlEqmgIBQ6H8F5/KKDRnL7PAsGWXkZbkbuyIK6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 17/02/26 11:13 pm, Luke Yang wrote:
> On Mon, Feb 16, 2026 at 03:42:08PM +0530, Dev Jain wrote:
>> On 13/02/26 10:56 pm, David Hildenbrand (Arm) wrote:
>>> On 2/13/26 18:16, Suren Baghdasaryan wrote:
>>>> On Fri, Feb 13, 2026 at 4:24 PM Pedro Falcato <pfalcato@suse.de> wrote:
>>>>> On Fri, Feb 13, 2026 at 04:47:29PM +0100, David Hildenbrand (Arm) wrote:
>>>>>> Hi!
>>>>>>
>>>>>>
>>>>>> Micro-benchmark results are nice. But what is the real word impact?
>>>>>> IOW, why
>>>>>> should we care?
>>>>> Well, mprotect is widely used in thread spawning, code JITting,
>>>>> and even process startup. And we don't want to pay for a feature we can't
>>>>> even use (on x86).
>>>> I agree. When I straced Android's zygote a while ago, mprotect() came
>>>> up #30 in the list of most frequently used syscalls and one of the
>>>> most used mm-related syscalls due to its use during process creation.
>>>> However, I don't know how often it's used on VMAs of size >=400KiB.
>>> See my point? :) If this is apparently so widespread then finding a real
>>> reproducer is likely not a problem. Otherwise it's just speculation.
>>>
>>> It would also be interesting to know whether the reproducer ran with any
>>> sort of mTHP enabled or not. 
>> Yes. Luke, can you experiment with the following microbenchmark:
>>
>> https://pastebin.com/3hNtYirT
>>
>> and see if there is an optimization for pte-mapped 2M folios, before and
>> after the commit?
>>
>> (set transparent_hugepages/enabled=always, hugepages-2048Kb/enabled=always)
> ----------
> amd-epyc2-rome
>
> # before commit
> $ uname -r
> 6.16.0-65.eln150.x86_64
> # after commit
> $ uname -r
> 6.17.0-0.rc1.17.eln150.x86_64
>
> $ cat /sys/kernel/mm/transparent_hugepage/enabled
> [always] madvise never
>
> $ cat /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> [always] inherit madvise never
>
> Before commit: Total = 6895988972
> After commit: Total = 2303697782
> Percentage change: -66.6%
>
> ----------
> amd-epyc3-milanx
>
> # before commit
> $ uname -r
> 6.16.0-65.eln150.x86_64
> # after commit
> $ uname -r
> 6.17.0-0.rc1.17.eln150.x86_64
>
> $ cat /sys/kernel/mm/transparent_hugepage/enabled
> [always] madvise never
>
> $ cat /sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled
> [always] inherit madvise never
>
> Before commit: Total = 4006750392
> After commit: Total = 1497733191
> Percentage change: -62.6%
> ----------

Thanks. So after all, batching improves stuff :)

>
> Luke
>

