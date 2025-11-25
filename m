Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E1FD0E6F1
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:39:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A456B0022; Tue, 25 Nov 2025 09:39:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31B16B0028; Tue, 25 Nov 2025 09:39:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D7E6B002A; Tue, 25 Nov 2025 09:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 826DF6B0022
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:39:44 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 27741B6855
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:39:44 +0000 (UTC)
X-FDA: 84149388288.11.C7370C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 678FE40013
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:39:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5mHmPkC;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764081582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgcPAKW8/AcDB7bv75r4Y2kJ05zhBBd229Kt3OWJySg=;
	b=MQDHq421GO7f2vFQJOVOqy6Z4XotGzMp87ZInNTW6HSNcO2XIeFxgIbtcxS4pC1LrU432R
	IDcA/exogFmRBR86AW7zUAi7E3MKxkOZLJFnIOvvKWdT00cO7T3Y/1jtbWEqC8QUsPnS1L
	8BtDbjbszfjRdJdGIMGek3gr50aHSDs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C5mHmPkC;
	spf=pass (imf17.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764081582; a=rsa-sha256;
	cv=none;
	b=Vt3ztDaE6OL2uvb/uGZU3MXKaDDpCY5t5qUk1Ee82Xbk4BXa5KoNyNEwpWpS1HtctWVT0k
	4xh9gG1pm7e4UHw3VTomN8PzGjHdVWmKOjs4+hr8r4A3EX6v+QKtpVkXr0lEe078YSG7r9
	+SevtILndGh9EhD/Dzj0vvsB97B4HCQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C8F040687;
	Tue, 25 Nov 2025 14:39:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9DF4C4CEF1;
	Tue, 25 Nov 2025 14:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764081581;
	bh=2Fuz15zAfjHTIJTPmsenTu/BskjaYoQHHrL2SmjKXYk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=C5mHmPkCKwmvDCHb2AGO/uD6yDIX5wflqjENKOE0u96jTEyroax2/mk6t8VdkkLCL
	 ztU1VizvfxGA+SU5X0ikxVqwRZPC5qw+XUqLp9H1ONehVhi7iD0te/PsPxhYPWmugM
	 B/MBZ9DIXqxy29UEqh1Fi6c/DOWAbkdvvy7GCBXr0flTNCArmLbIWYkWJjyZKnH0HK
	 DYCMiQpV65gWf5Fk1c0Y0YKHA6S0KfLgn2Hs7kZbhd5tX+Ab11mSnzhrtsi7u2Mymc
	 bYTrdQv23UZOHtZEXgr95ilKdM0UIzCA4yJY+h2bTydeagOq0myhwMrw9zqgY74uNA
	 2rVIRQxkN2O6A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Changyuan Lyu
 <changyuanl@google.com>,  akpm@linux-foundation.org,
  linux-kernel@vger.kernel.org,  Mike Rapoport <rppt@kernel.org>,
  anthony.yznaga@oracle.com,  arnd@arndb.de,  ashish.kalra@amd.com,
  benh@kernel.crashing.org,  bp@alien8.de,  catalin.marinas@arm.com,
  corbet@lwn.net,  dave.hansen@linux.intel.com,
  devicetree@vger.kernel.org,  dwmw2@infradead.org,  ebiederm@xmission.com,
  graf@amazon.com,  hpa@zytor.com,  jgowans@amazon.com,
  kexec@lists.infradead.org,  krzk@kernel.org,
  linux-arm-kernel@lists.infradead.org,  linux-doc@vger.kernel.org,
  linux-mm@kvack.org,  luto@kernel.org,  mark.rutland@arm.com,
  mingo@redhat.com,  pasha.tatashin@soleen.com,  pbonzini@redhat.com,
  peterz@infradead.org,  robh@kernel.org,  rostedt@goodmis.org,
  saravanak@google.com,  skinsburskii@linux.microsoft.com,
  tglx@linutronix.de,  thomas.lendacky@amd.com,  will@kernel.org,
  x86@kernel.org,  Breno Leitao <leitao@debian.org>,  thevlad@meta.com
Subject: Re: [PATCH v8 12/17] x86/e820: temporarily enable KHO scratch for
 memory below 1M
In-Reply-To: <80622f99-0ef4-491b-87f6-c9790dfecef6@gmail.com> (Usama Arif's
	message of "Tue, 25 Nov 2025 14:31:54 +0000")
References: <20250509074635.3187114-1-changyuanl@google.com>
	<20250509074635.3187114-13-changyuanl@google.com>
	<a0f875f1-45ad-4dfc-b5c8-ecb51b242523@gmail.com>
	<mafs01plmxngp.fsf@kernel.org>
	<80622f99-0ef4-491b-87f6-c9790dfecef6@gmail.com>
Date: Tue, 25 Nov 2025 15:39:34 +0100
Message-ID: <mafs0ikeyw509.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 678FE40013
X-Stat-Signature: mb8fn37iitpbk8krdz119fuim5z66qmj
X-Rspam-User: 
X-HE-Tag: 1764081582-312468
X-HE-Meta: U2FsdGVkX18eygejxLBqJ7Tcq4/dXeKJAbfL9Dmk8xoybVTTMyP1k40FiC6jtSolM5vuGdVA2ACvXY+5VCkyPWiWu9/J3K94gBfJ7LK0CvDYwDzo6BAXp61It/nUWjfsQ491BG/T8Oj6+rDUYLDM8t5HsoRgu77hwy94X7GvX+iZdrfyrb/VznGRZwftUebeyWwkX1W7gj4mZzBx2sikWHNmUwTptjZnAG24bN0Wifr7gAbhIYGHwnJaeZvCCPQAfACwBwB9g0qAsFi0VNCIRBMo5LBTzdVtiv2sx2xGJ3Fk+UhuhWBqjlfkkRfOrr/Lv6e+AGcMUfPguLk8MAdz0ezxhsPFbAt8UxCmTKrIsp1txww8I6Lfl4DuS+CCKj+g7PnsWdRWAYGvBf3Not/o1/o1+byabx0L7VVae3yZ4Nq6N3c70th7kGnrr6uhGnU3OOTZ6b53azVvrY6EsuvSwC2TXrR1chXACqpQinxEaTwt/oxfIZYZ/qSENYGRoa7aqecrNDKfEbI+RfLxXqXwioqp7cFpP4R0l6qGEraXu6p7Nn5KvMvtebLF1AbPt36FKhElbEip2W0AGqD+ZoG5/LD6YbwJbXJgqEkDrYMEKlpFEwkvm9ASeNaSVfpbjeORk+x2LNaa7Wy0CnXBvnKjI5ZtyMCtI1yhorpOGzWDVFdtg+zxHp7X6owoKtgarp/c4ydyYMZhWx0N4cAngY8gpPXbeV987LkUCjhA/UUrh8AsrBWKIsElWIKb3pBW8HnaEsXO4r7VAD8CzNDD6nUca/aQAqRJLqHC3O34u4Y7zZifpepS4AqM5G5SCFZfAeBV7UDRe5j4TAHwIN41C9LIDxP0HB2ZarVys8zwtqxyUxa1kMTS344e+JK8ndvX4VRcFG+QAK4wScJbUin9GAz6EV4/wEkpuPuQc1bhlDox+wH9HcyO/htx6yHAj47BILYGiew1w+6+yQfVdG5yB6I
 VGklJ1qo
 WtxNFXiHA/IL8N8lnosOpHAC5Ap60FJT1Us9sh2U+blcC32198TXfFKXWGFLIt3tQrLxv7hmwKOWhdNksGhj8wrzcW/jw1RgJMxcsmxQo2X8HzoKKMrnCVtPIpFjPbxLrNi5rtXGt49CMYdFg4smfomnPmfn8NGdEzSujrR3J4hVRKXwxnhBzB9MKsXuzshf6t2/m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25 2025, Usama Arif wrote:

> On 25/11/2025 13:15, Pratyush Yadav wrote:
>> On Mon, Nov 24 2025, Usama Arif wrote:
>> 
>>> On 09/05/2025 08:46, Changyuan Lyu wrote:
>>>> From: Alexander Graf <graf@amazon.com>
>>>>
>>>> KHO kernels are special and use only scratch memory for memblock
>>>> allocations, but memory below 1M is ignored by kernel after early boot
>>>> and cannot be naturally marked as scratch.
>>>>
>>>> To allow allocation of the real-mode trampoline and a few (if any) other
>>>> very early allocations from below 1M forcibly mark the memory below 1M
>>>> as scratch.
>>>>
>>>> After real mode trampoline is allocated, clear that scratch marking.
>>>>
>>>> Signed-off-by: Alexander Graf <graf@amazon.com>
[...]
>> Anyway, you do indeed point at a bug. memblock_mark_kho_scratch() should
>> only be called on a KHO boot, not unconditionally. So even with
>> CONFIG_MEMBLOCK_KHO_SCRATCH enabled, this should only be called on a KHO
>> boot, not every time.
>> 
>> I think the below diff should fix the warning for you by making sure the
>> scratch areas are not present on non-KHO boot. I still don't know why
>> you hit the warning in the first place though. If you'd be willing to
>> dig deeper into that, it would be great.
>> 
>> Can you give the below a try and if it fixes the problem for you I can
>> send it on the list.
>
> Is there a reason for compiling this code with is_kho_boot, when we have disabled
> KEXEC_HANDOVER and dont want this in? i.e. why not just ifdef it with MEMBLOCK_KHO_SCRATCH
> when that defconfig is designed for it?

is_kho_boot() will always be false when CONFIG_KEXEC_HANDOVER is not
enabled. So the compiler should optimize this out.

Only using the ifdef is not enough. Just because the config is enabled
doesn't mean every boot will be a KHO boot. You can do regular reboots
or even regular kexec, without ever having KHO involved. We only want to
call this for a KHO boot. So a runtime check is needed anyway.

>
>> 
>> diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
>> index c3acbd26408ba..0a34dc011bf91 100644
>> --- a/arch/x86/kernel/e820.c
>> +++ b/arch/x86/kernel/e820.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/firmware-map.h>
>>  #include <linux/sort.h>
>>  #include <linux/memory_hotplug.h>
>> +#include <linux/kexec_handover.h>
>>  
>>  #include <asm/e820/api.h>
>>  #include <asm/setup.h>
>> @@ -1315,7 +1316,8 @@ void __init e820__memblock_setup(void)
>>  	 * After real mode trampoline is allocated, we clear that scratch
>>  	 * marking.
>>  	 */
>> -	memblock_mark_kho_scratch(0, SZ_1M);
>> +	if (is_kho_boot())
>> +		memblock_mark_kho_scratch(0, SZ_1M);
>>  
>>  	/*
>>  	 * 32-bit systems are limited to 4BG of memory even with HIGHMEM and
>> diff --git a/arch/x86/realmode/init.c b/arch/x86/realmode/init.c
>> index 88be32026768c..4e9b4dff17216 100644
>> --- a/arch/x86/realmode/init.c
>> +++ b/arch/x86/realmode/init.c
>> @@ -4,6 +4,7 @@
>>  #include <linux/memblock.h>
>>  #include <linux/cc_platform.h>
>>  #include <linux/pgtable.h>
>> +#include <linux/kexec_handover.h>
>>  
>>  #include <asm/set_memory.h>
>>  #include <asm/realmode.h>
>> @@ -67,7 +68,8 @@ void __init reserve_real_mode(void)
>>  	 */
>>  	memblock_reserve(0, SZ_1M);
>>  
>> -	memblock_clear_kho_scratch(0, SZ_1M);
>> +	if (is_kho_boot())
>> +		memblock_clear_kho_scratch(0, SZ_1M);
>>  }
>>  
>>  static void __init sme_sev_setup_real_mode(struct trampoline_header *th)
>> 
>> 
>

-- 
Regards,
Pratyush Yadav

