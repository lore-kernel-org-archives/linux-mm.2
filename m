Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55C27C55171
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 03:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E48A6B007B; Fri, 31 Jul 2026 23:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 794E76B0088; Fri, 31 Jul 2026 23:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AD416B008A; Fri, 31 Jul 2026 23:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46F6F6B007B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 23:29:25 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC5DBC01EE
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:29:24 +0000 (UTC)
X-FDA: 85051270248.02.39DA5E3
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf14.hostedemail.com (Postfix) with ESMTP id 914EB100005
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 03:29:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785554962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tm7PyOogKDuImuMfp/Jfq3/mFgj3o0HKG8Kidl6div0=;
	b=6qixIlzfr05ofILoD9z/RwYSpHJcRIVaWy349t+c8CktQVAPCScXLx3lB+PBBxO5NisE8m
	v1a8zcsDig8+HOHP4xOKSEwFUDKrPH8aZIb9mtXBQ7D1gFma/eiA8ZndVk+Gdq8HJ7oD7T
	bg3u6wLS3vyrrmq3X9azDIBI7x7ICoM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785554962;
	b=Flk7pF4x5yc+Ciu0GQa0v1d7y+Olt0moiFTBQkjlf9DBtRctdFGDuDL1s2rr/FF36HAIlp
	W1zcQcyzQobuwFUqMY5wbqB6N33rFmJ9uf3YxIaEuguyzj/3abA6qjarGHGJ5kI1G3TOmH
	Mr07tgMQSy63tQqNoFJsp2xPIweLtPM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8Axx+oLaG1q9GwJAA--.31594S3;
	Sat, 01 Aug 2026 11:29:15 +0800 (CST)
Received: from [10.130.40.83] (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJDxDccJaG1qf3YfAA--.37140S2;
	Sat, 01 Aug 2026 11:29:14 +0800 (CST)
Subject: Re: [PATCH v2 2/2] LoongArch: Skip address pairing for non-exec
 sections
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org, loongarch@lists.linux.dev,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Mike Rapoport <rppt@kernel.org>
References: <20260721090606.8982-1-yangtiezhu@loongson.cn>
 <20260721090606.8982-3-yangtiezhu@loongson.cn>
 <11c42b7c-7805-cce7-305d-6e52c14db20e@loongson.cn>
 <CAAhV-H47kc-=A2syzJNLWOD1=TWumvyYWObL+xutrbSRy=WpWA@mail.gmail.com>
From: Tiezhu Yang <yangtiezhu@loongson.cn>
Message-ID: <0471efa9-d2b4-22d1-6059-acfa6a150a94@loongson.cn>
Date: Sat, 1 Aug 2026 11:29:13 +0800
User-Agent: Mozilla/5.0 (X11; Linux loongarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAAhV-H47kc-=A2syzJNLWOD1=TWumvyYWObL+xutrbSRy=WpWA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxDccJaG1qf3YfAA--.37140S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7Zw4UuryDZw1kAF4DJw15WrX_yoW8Gry5pr
	45GFZYkF4qv3yxAFs7Kwn8uFyjgrsYvFWjqr95Xw1vyas0g3ZYy3WDKr15tFWkua9YkF12
	vayaq3yrZ3WDAFcCm3ZEXasCq-sJn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWUJVW8JwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	Jr0_Gr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67
	vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr
	1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUrNtxDUUU
	U
X-Stat-Signature: 3e6br6njfyjridsqc7qi4yshaicn975d
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 914EB100005
X-HE-Tag: 1785554961-44763
X-HE-Meta: U2FsdGVkX19qQHyG1EHvhiVNNWWky1G3/XkTCgi44aZt9gdI9cdDkca/JsYdbFw4l2vHXsuNDZ+KjV8xJeOEc18iVy0mBH0aTnYT1yP0FEjrLMHFaAbfgpYUXMfhY2d5ukqbfwEgLfEghwOplfid8F1gXjZ7XM3MLZXtSxE7mVStiI7LtXwxH8MV4IlXvOoOkAGG8NBqJuSEp7xg5e/E+kUKRnNSoTwWmMq1+x22tdw+BqhVNzZjdHeBb/w6CtQmVeuvJOzWua7tthwJq4s48qRDZpeum00nyt2cHaChaHp4QM062odz5f48Dk6fC1mfABsqC52m6nZiWseeiI7qnyVAX6eR675qbjC4jZyZ4+LYZSUnCFosbBSlAbkyN/6YaiU+Cui2pkOreOlQdv6Jvy+xN4CIaArqIHoXa+bkS8/jVb68cU+Ub8vYjY5FhP6ApWExZeib1CYhjFX2qMQ7WdDOtqpc/wlHpnZfYuBBppkILUndt+M6bPSUqET0YMp4yFvq7aFlSD0J8aRrRg5Auaict8pV6GiCfjvcX2eVQnz2kPrfzMFfYcqSjoIJ3YgwhR41HRLQXQPAaS3QaRiJvc2FyZhYHk0s1KaOUTZxVPiZ8MBqPKS7b4pdepC2uITqa0qKRPp5buixVz72dGVI3ZOuxpWnxFDude/jiWa+GdO0U1aY3MNJjOXirHWu6v3C40O0EUwAg6AeZNNGuopHr9D7OxTkAvJMkIvVsAvfBBZuLfPN2470LOAzOAJoY5Vy8NMCpqBI4wn1X+ajvtTbryOSG1C48kaAr4no2IjhCRip7+WNAJHeoBL3paCVaOufEDK9ppJtqLaz+JZJHDb+RNzIROcKhBN66fTGLcAeTnT2fq+5d24YZkLsKwr7iELiC+mbEBZGd2BdZpb6yySQEJG+la+Ka5bavzJsjUIo70YNSIaXxcwdIJTghDOrVL68VW+dSnzMR17vTa625A4
 ECGDa/RE
 0sHuPsGv94eVUtez4iYBFJUB82daziNcOjxUkSBieJmCsMGEx3v/2NnPVLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/31 下午3:38, Huacai Chen wrote:
> Hi, Tiezhu,
> 
> On Fri, Jul 24, 2026 at 2:07 PM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>>
>> On 2026/7/21 下午5:06, Tiezhu Yang wrote:
>>> The module loader currently runs expensive address pairing logic for all
>>> sections blindly during relocation. For massive modules like amdgpu, this
>>> causes the loader to waste lots of CPU cycles analyzing non-exec sections.

...

>> Using the section flag check reduces the operation to a single check for
>> massive data sections; otherwise, the loader would have to perform six
>> redundant type comparisons across the if-statement and switch-case for
>> every single relocation entry.
> Please just drop this patch and make the first one better.

OK.

> Now the first patch has a risk that the distance between .init.text
> and .text of the same module exceeds 128MB. I solved it and you can
> verify:
> https://github.com/chenhuacai/linux/commit/f87f9d82869ebc71dca4c02bdff1cd203913a98f

Looks good to me, I think it is safe.

static int module_memory_alloc(struct module *mod, enum mod_mem_type type)
{
...

	if (mod_mem_type_is_data(type))
		execmem_type = EXECMEM_MODULE_DATA;
	else
		execmem_type = EXECMEM_MODULE_TEXT;

	ptr = execmem_alloc_rw(execmem_type, size);
	if (!ptr)
		return -ENOMEM;

...
}

Thanks,
Tiezhu


