Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43620D116E2
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 01:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440426B0007; Fri, 28 Nov 2025 20:01:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFF56B0022; Fri, 28 Nov 2025 20:01:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2923F6B0023; Fri, 28 Nov 2025 20:01:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0ECAF6B0007
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 20:01:25 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A24B0132129
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:01:24 +0000 (UTC)
X-FDA: 84161841288.22.AFD25A9
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id AFCF44000E
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 01:01:17 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764378082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L+Sm016XecfIRVb9f02G8NevCS17Unuerb4iXY+i7jo=;
	b=cTm0zT94RZxGSDbYp1GDxwSjFdqual7wtsv2DGY9XrTp1I7vYbGNtjXsXAMw5XWJViAoGD
	2j8NtckZpq/2X8gnVZ4ysfONcLohUfiAHR0BiQV7GqyM78Sc2L3j2YbGab0GPMzfXSWFNn
	wce1YwBm90orIwaxPnDH3mueyl2epQ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764378082; a=rsa-sha256;
	cv=none;
	b=aQUTw1P14ITEZk0kpirJ5J9Lrd9QGU7qvCJUXLOoLE7LnRL37YMuWZY9VIX2+uwXPryrl3
	iekpi4lffK8RrZQyiK4VS8AczAWQvZXTreNKIowVsn8QD6mRGa3+8TEZDaMw82w45Vgr9P
	17eN1ZsVHy6LgS0bHl2Eld8ZKuIgc4s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dJBfS47F9zYQtjw
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:00:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id AB9AB1A10E0
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 09:01:12 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgCH5XvWRSppIhd8CQ--.54714S3;
	Sat, 29 Nov 2025 09:01:12 +0800 (CST)
Message-ID: <3d590a6d-07d1-433c-add1-8b7d53018854@huaweicloud.com>
Date: Sat, 29 Nov 2025 09:01:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Linus Torvalds <torvalds@linux-foundation.org>,
 "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Zizhi Wo <wozizhi@huaweicloud.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 jack@suse.com, brauner@kernel.org, hch@lst.de, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 yangerkun@huawei.com, wangkefeng.wang@huawei.com, pangliyuan1@huawei.com,
 xieyuanbin1@huawei.com, Al Viro <viro@zeniv.linux.org.uk>
References: <20251126090505.3057219-1-wozizhi@huaweicloud.com>
 <33ab4aef-020e-49e7-8539-31bf78dac61a@huaweicloud.com>
 <CAHk-=wh1Wfwt9OFB4AfBbjyeu4JVZuSWQ4A8OoT3W6x9btddfw@mail.gmail.com>
 <aSgut4QcBsbXDEo9@shell.armlinux.org.uk>
 <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <CAHk-=wh+cFLLi2x6u61pvL07phSyHPVBTo9Lac2uuqK4eRG_=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCH5XvWRSppIhd8CQ--.54714S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw45Cr1kXry7trWxJF47Jwb_yoW5CFWrpr
	Wjk3ZIk3y7WF1Sya4xAan2vFyxA3Z5Ar45GF90krs5uwsrWrnFgw4Sgws0y3429rnYga10
	vr4YvryUuwn8GaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjTRNJ5oDUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: AFCF44000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 186o4jkz67in8114up4ch3aws9reg6ey
X-HE-Tag: 1764378077-487892
X-HE-Meta: U2FsdGVkX18Aol6dyl0HwqaGlyQdaF++H6JpQoeAr1p03W8ou9GfNjiaglovuvt1RdCTDjGvvfdYNZ3G2Jlhp3wKnkcoYOf+6Lrzawa4uFJ0z76Yo+mzFMsiRIFyBkcpo3eGlZ3QZAAywmUXMSEvIHGorustURLaGcKqbjiF/u8vW1PLL0jNz91dVQPmvikAFDQ49SENrPr8eDt4+pTk5Hk9nYFsXF7Lt95dgrvLJKDyF6uNtiC45qZO0MFE8mmCrjJpZEv16lwFLyMcuIvkB+bUuZZ0O5iq0RIR7lsq/5GrSceuizSnh8Q2lFz8wDrJVEBLUmVJjR2yFnVd/MqAGU4F+ysD/iEPFYRgVxmC699ZnMf6OzHD36JphnnoZlHuVBcQBmPuxioxncny47LexuMSxwCG0Rdw3h9qF/d95B4hENX0TdX496v3jZRAcsnahRr5Y25vUKWYS5RF8wFT4cvDdO0pqpGJ7SPJIL2fIAILSAKgHWJVhJxW3zxD+c9Rtmhy+VvpaNaOB+tnjKr9QEceRxewLNXT055id4nMdoN1WldOlDPTxrHkWtH4nkMnXCtPm6gW1eK6NYndKMd4/5m2d/y4RqApbrSEwg1l1jKf9lJp4nWgS3k7Iw4OCPW2PpoZvQmIkZ4SVhWpgwt7BTq+aMRnaIeSNkBk3Ufw7b+Al945uCTne5MAK70PGQ77/KkA4WK/5fqVR4RHq7aoXcCCWQxq9oCQSpURYlXM5vjmJJHZ2z0Tn8OamIe8qv210FMHxELU3N0J9VDS5qFIz5YDhwUM9TWpv2IgdLMxC5dX2bFSAPdM2Z921lCC/IAwd5neRNbQqs4du/qYf3VEmKHOReT7LEzUfVRcEG4tamQsvn7Bjlk0A4f0ri8G1QAFIrwhDoFxDmLQYu6BhZdjbgPT/fLg/HzHJlJ4WMpUwjS8VAl9kZxDalw0i43i0G7gxBj1nNMYTijnFJvcHzr
 iVzwXJZ2
 QglIcbAZVnebOTyR6ZMD99ZahAjfrGFU/9kdXtE9yD1/2IoWdVxUfadU0ujshApH6aGOc/HU2Y9ajiNqqXDXZ2wxZUrvr76p1I0C3PsicAxnwfYCAJZL83mob8Ss/f6rNQL4nRSnlELnJhN4K6v9AQCoraRr+bzXlU+cIsJnMVRt/vLJ/uAqG3Pzqj6UYeCh6GLCZ6CSmoCo6HqhdyDFi5nSsmVUDOBUbFm3RinhlvTt+5rejazJMjZLVK+OnXokvGeoX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/29 1:06, Linus Torvalds 写道:
> On Thu, 27 Nov 2025 at 02:58, Russell King (Oracle)
> <linux@armlinux.org.uk> wrote:
>>
>> Ha!
>>
>> As said elsewhere, it looks like 32-bit ARM has been missing updates to
>> the fault handler since pre-git history - this was modelled in the dim
>> and distant i386 handling, and it just hasn't kept up.
> 
> I actually have this dim memory of having seen something along these
> lines before, and I just had never realized how it could happen,
> because that call to do_page_fault() in do_translation_fault()
> visually *looks* like the only call-site, and so that
> 
>          if (addr < TASK_SIZE)
>                  return do_page_fault(addr, fsr, regs);
> 
> looks like it does everything correctly. That "do_page_fault()"
> function is static to the arch/arm/mm/fault.c file, and that's the
> only place that appears to call it.
> 
> The operative word being "appears".
> 
> Becuse I had never before realized that that fault.c then also does that
> 
>    #include "fsr-2level.c"
> 
> and then that do_page_fault() function is exposed through those
> fsr_info[] operation arrays.

Yes, it enters through fsr_info.

> 
> Anyway, I don't think that the ARM fault handling is all *that* bad.
> Sure, it might be worth double-checking, but it *has* been converted
> to the generic accounting helpers a few years ago and to the stack
> growing fixes.
> 
> I think the fix here may be as simple as this trivial patch:
> 
>    diff --git a/arch/arm/mm/fault.c b/arch/arm/mm/fault.c
>    index 2bc828a1940c..27024ec2d46d 100644
>    --- a/arch/arm/mm/fault.c
>    +++ b/arch/arm/mm/fault.c
>    @@ -277,6 +277,10 @@ do_page_fault(unsigned long addr, ...
>          if (interrupts_enabled(regs))
>                  local_irq_enable();
> 
>    +     /* non-user address faults never have context */
>    +     if (addr >= TASK_SIZE)
>    +             goto no_context;
>    +
>          /*
>           * If we're in an interrupt or have no user
>           * context, we must not take the fault..
> 
> but I really haven't thought much about it.
> 
>> I'm debating whether an entire rewrite would be appropriate

Thank you for your answer. In fact, this solution is similar to the one
provided by Al. It has an additional check to determine reg:

```
if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
	goto no_context;
```

I'd like to ask if this "regs" examination also needs to be brought
along?

I'm even thinking if we directly have the corresponding processing
replaced by do_translation_fault(), is that also correct?

```
-       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page 
translation fault"           },
+       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page 
translation fault"           },
```

> 
> I don't think it's necessarily all that big of a deal. Yeah, this is
> old code, and yeah, it could probably be cleaned up a bit, but at the
> same time, "old and crusty" also means "fairly well tested". This
> whole fault on a kernel address is a fairly unusual case, and as
> mentioned, I *think* the above fix is sufficient.
> 
> Zizhi Wo - can you confirm that that patch (whitespace-damaged, but
> simple enough to just do manually) fixes things for your test-case?
> 
>             Linus
> 

I tried it out and it works — thanks!

Thanks,
Zizhi Wo


