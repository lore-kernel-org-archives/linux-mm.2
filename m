Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E78ECFD376
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 02:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C089F6B0010; Sun, 30 Nov 2025 21:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE0C16B0011; Sun, 30 Nov 2025 21:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1CEE6B0012; Sun, 30 Nov 2025 21:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A34326B0010
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 21:08:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2BDBBE4BF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:08:09 +0000 (UTC)
X-FDA: 84169267098.20.0ED819F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 52842A000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 02:08:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764554888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yR2ceubSigLLZxZs0jlDpYQK9wEBR7i5QYwCj2yeB8g=;
	b=B2kqOuq6rQNG03LV1wTlVMNmtGvdZABB0JgdGRbTygqpw6jCZbCLUfnDRhZsp7SCv5EvCZ
	XMEZL7X1//sV+5vjsOjLeKHAZWxxeIy+pmhjgkHuHS9lp90/ykEZSZnyFdysORotCmE3LT
	djY+6jrDHMxTiHobzUrANf5IVLr6nRo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764554888; a=rsa-sha256;
	cv=none;
	b=zBsqbYN3zERUZ4Cw8qQ/SXXNihdPFWYgl2Z39VPf7rqKEF83dgsOvUR6aeTe6R4VlLoanL
	FYucvZIk7PMXfdcTSK/zH8+Ypu6IBG2vaf8RrOOIkW0FuxlHpWDKN/4773FzpzzVTaXkfu
	l0B4qYNd+0dsYqtFeehwUJ1V0LMJa5g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of wozizhi@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=wozizhi@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dKS2r1w1GzKHMLp
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:07:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id EA95D1A0A3A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 10:08:01 +0800 (CST)
Received: from [10.174.176.88] (unknown [10.174.176.88])
	by APP2 (Coremail) with SMTP id Syh0CgCnhU+A+Cxp0DS5AA--.50428S3;
	Mon, 01 Dec 2025 10:08:01 +0800 (CST)
Message-ID: <32d0a330-5f14-4c1f-8706-1301a1b66864@huaweicloud.com>
Date: Mon, 1 Dec 2025 10:08:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Bug report] hash_name() may cross page boundary and trigger
 sleep in RCU context
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Zizhi Wo <wozizhi@huaweicloud.com>
Cc: "Russell King (Oracle)" <linux@armlinux.org.uk>,
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
 <3d590a6d-07d1-433c-add1-8b7d53018854@huaweicloud.com>
 <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
From: Zizhi Wo <wozizhi@huaweicloud.com>
In-Reply-To: <CAHk-=wjA20ear0hDOvUS7g5-A=YAUifphcf-iFJ1pach0=3ubw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCnhU+A+Cxp0DS5AA--.50428S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww13AFW7tryftw17Wr4Durg_yoW8trWfpF
	yj9wsakrW8AryIyF97Ja1kAaySkFn5Zr4UGFy5trykua90vFySvw4SqryYyrWqqrnY9a1I
	qw4UXr1Uu3WDtaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjTRRBT5DUUUU
X-CM-SenderInfo: pzr2x6tkl6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 52842A000D
X-Stat-Signature: e8u5n9u3gixr4cxkc7yy3rqa9yw51h9e
X-Rspam-User: 
X-HE-Tag: 1764554885-708078
X-HE-Meta: U2FsdGVkX18zh1p1yBANsi90gJy+W8XsKjPxUsYZ7BZxXxwmCt/v+sMLvKx9TdKoKQmSahk0Kg3F4xqBCiK6PKTVbSK1lJgxqR/9HYb7mMaDroNbZLQiOHcsqTBCn9RCdlWOsV2eRpsS1/SukdgrXGSsEqTQm7QTpvLoiY7ikQGLH6p39Xe83uX3qrFU8E4qBDQVSCbAo1mtoul288CYjqVOScXAexECE3U+Il+5lkXZGUPyeEMLt7feAmUF19fmn39rbobZfIxaHh658eBuhlunZUtAqI9as3CZTBXHzXJVXNxujNc/eD/QdCyVi0RzOomXgRNzf161SmoohdgkO5Zvwrn32WKCAjXcmz0TsEIPL+/KSvMTUDQtmWphLu4zot5gpZq0fae8rF4Ma/QfmT2juXcmo6s4kC+sGEZIdGa9cGpBFu5rDxb9uYxIBQCXDESujhK5tWpAOiFnZQbc+qSZEQcgwHdAwls0XgHfHU5e+UHRyYrPeF2UV8Z971m5hh0SdhJlsShBdwfjl4RnTIMT5bB3YrJozUpquS/W5LYtMR4VAaMcqqciLZ3OXhI3wLEHY3ND6dizjdbPrVSttj89MBX6ozlnj5fQgN7zx+Rix/9JjhER96m0e6DZtxt3zsRxxIphxfJKS0zLRgU9dPGtXNvO5agb0OTzz/Cv+YaFpC//4jBi+uhdUwn4st8W+DkPmqufYE8UhERcA6ensJEGn6eJOicRJZDqP9+7Irp2SLfpkNF5HGHhBmuzNhPrCSH8aITWLq+6UD7PG9Y6jmRfvZiwMKdLqvqtBCWykueEdz4/yySuDdiq3bNT3AAWeu7hPf9My07qEiZSPvh34FeCmQP2yi2l8xCD2MGRYwioXdrJWPtuctgLqZ404ocYE85Dg3B/2PTwnBsx1jl+O6OQ/ic9N63OYERBucHzKSRgdr+67DNY/af5YHDUAupA69/pa8st+wxLfzn1LME
 cd7S/7/y
 E4hV+cUYUIMLcfHEQGFBXnaZjkT3N6B0r7uTn8c9cej6R3aa5iRIMsJBUt5ZyYeIkTZSBQYq8JyaHPJh1u2iH2IiXdHTUnyIX9wjQvN83KrZYNc7GFXrgbQbKKmRWN4/uhkRG+g4DwhGsqIVjn4aYnc3eXmL0hEFcOAh9fWLCTXgS2h/r+oP+rYkVIi9RoTdvpwqORZK+TvwYDsX7j8b3gg8OvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/11/29 9:35, Linus Torvalds 写道:
> On Fri, 28 Nov 2025 at 17:01, Zizhi Wo <wozizhi@huaweicloud.com> wrote:
>>
>> Thank you for your answer. In fact, this solution is similar to the one
>> provided by Al.
> 
> Hmm. I'm not seeing the replies from Al for some reason. Maybe he didn't cc me.
> 
>> It has an additional check to determine reg:
>>
>> if (unlikely(addr > TASK_SIZE) && !user_mode(regs))
>>          goto no_context;
>>
>> I'd like to ask if this "regs" examination also needs to be brought
>> along?
> 
> That seems unnecessary.
> 
> Yes, in this case the original problem you reported with sleeping in
> an RCU region was triggered by a kernel access, and a user-space
> access would never have caused any such issues.
> 
> So checking for !user_mode(regs) isn't exactly *wrong*.
> 
> But while it isn't wrong, I think it's also kind of pointless.
> 
> Because regardless of whether it's a kernel or user space access, an
> access outside TASK_SIZE shouldn't be associated with a valid user
> space context, so the code might as well just go to the "no_context"
> label directly.
> 
> That said, somebody should  definitely double-check me - because I
> think arm also did the vdso trick at high addresses that i386 used to
> do, so there is the fake VDSO thing up there.
> 
> But if you get a page fault on that, it's not going to be fixed up, so
> even if user space can access it, there's no point in looking that
> fake vm area up for page faults.
> 
> I think.
> 
>> I'm even thinking if we directly have the corresponding processing
>> replaced by do_translation_fault(), is that also correct?
>>
>> ```
>> -       { do_page_fault,        SIGSEGV, SEGV_MAPERR,   "page
>> translation fault"           },
>> +       { do_translation_fault, SIGSEGV, SEGV_MAPERR,   "page
>> translation fault"           },
> 
> I think that might break kprobes.
> 
> Looking around, I think my patch might also be a bit broken: I think
> it might be better to move it further down to below the check for
> FSR_LNX_PF.
> 
> But somebody who knows the exact arm page fault handling better than
> me should verify both that and my VDSO gate page thinking.
> 
>             Linus
> 

Thank you for your reply! Regarding the existing discussions in the
community, I will re-examine the logic in this regard and digest it.

Thanks,
Zizhi Wo


