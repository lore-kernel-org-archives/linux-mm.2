Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBF3C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5B356B00AB; Tue,  7 Jul 2026 09:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0B626B00AC; Tue,  7 Jul 2026 09:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD226B00AD; Tue,  7 Jul 2026 09:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 81AAE6B00AB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:48:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F89B1C80BB
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:48:27 +0000 (UTC)
X-FDA: 84962110254.19.521FFDA
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE67C14000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:48:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jxfgT/1X";
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432105;
	b=MPIbedslTQ4Eg3vPH0HrlR+A0EyS8UFeYOTUSLYq1IVeda2nheSsdiDueq3kuZYhRF4Dk2
	mF0XIEVyp/0BcNJUVFGIV7TAixavE/l9A/dbRsWfH3xJYzBAlOlVzAHUVpvE/p6Kk6/FJV
	UQ/jxeHSlDjgSo4pVQYgefgogam9Zl4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jxfgT/1X";
	spf=pass (imf23.hostedemail.com: domain of leon.hwang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PeXRy5OWREcqxAhLOrbYEMd2NpniYtCVndcj0EJ5z58=;
	b=2owZ7P2fZUJ3lGoIKH7QftAZ4NdYpLeEsaWguXcFmJmBD3L7gjEBrM3BVQ6ajyqdErsY1i
	92VbhkWTa8rqMiUb6tnH1vh/WYrG2q05SZFs6XpzdfrLZzR098VRSZzNUGcfOIZsTawOyg
	ckzXTxUHz8Xi4scV6kBAYEMMrpluK8I=
Message-ID: <4320145e-a0ba-40f6-b99b-f01f32634f28@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PeXRy5OWREcqxAhLOrbYEMd2NpniYtCVndcj0EJ5z58=;
	b=jxfgT/1XOYBNftDoCCQtjO1UTLEGZqcaSM3erJbI5MSNI1hw+uNxPNVFEMZ1k1OYxIlRDQ
	bARn0NHa6HqJR4RgWsVPTof/V3DqEHP8Agcf7McGO5jsUtB+UuoOAeU8Yl+tlkM+J2dtsj
	WHZIZ7UGeXrjpEtk5qwhtCKwL02ZdUo=
Date: Tue, 7 Jul 2026 21:48:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mseal: fix mseal documentation for 32-bit kernels
To: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R . Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Nathan Chancellor <nathan@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Miguel Ojeda <ojeda@kernel.org>,
 Nicolas Schier <nsc@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
 Alice Ryhl <aliceryhl@google.com>, Douglas Anderson <dianders@chromium.org>,
 Gary Guo <gary@garyguo.net>, Anand Moon <linux.amoon@gmail.com>,
 Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
References: <20260703022507.187457-1-leon.hwang@linux.dev>
 <akeDk49-pPgUDek1@pedro-suse>
 <8f75dc18-dd4c-4989-a76c-eec6cc513ccf@linux.dev>
 <akzN_HNJJWBW7htL@pedro-suse.lan>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <akzN_HNJJWBW7htL@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AE67C14000A
X-Stat-Signature: 44ssq96oho6inawd3j4r7ktoi5rqr77m
X-HE-Tag: 1783432103-209437
X-HE-Meta: U2FsdGVkX18eW8JtSO/XmHxDrrbJ5nv8yT1BH7BSZdjiFjkEtsau5H45Ye8EZqoVF5muTT82ylEmNXord9AGXUo2zYKtjbRSBuT5wjO6i01hryI44kg7uHzmlu8h7TVNRGbtAr/sLUQOH4OJLjw4kBIk7k/ANeHGRX2UN/9Hfyqn5SXJXt8hjcdSKtYeJC8cwttU6qaxF7dMwTMjiNEp29cE8Nds3k0yWPpfdi9LrOBq1ErE6MNUUCfZgr2WtAEHBmvzqZPjJLNwVqzdX2nMhmuHyj4M7xwuWGCJp7s8IDtkiSCJR19SYOAC1BO1B/zINCFlss3b02j/j8QKIXzUtM+WPU8LUJBnBHcPAW9Mz8Hw8L+2Pe3qQf1TQtg5yBWRDMsTeBokDC+LD/CmznRzD8DPmo/FXRyvp/OytWLEcJgUFD9ux2Sh3Rnq3oJfF0a0Xr0D2dZ7C6qWQ161rQcgUq+iGGL5Y21tfPEXq6XH/uoUqqtzKXfYQVhCDQWbVEolbUfto9kVHejkD5gVqcmNEHLSEbm+eBYYhP/xWK8nluPQ1jndGEymcr++xDFCllVtXlbIg81JIxEINn5J8HFLZPw8hRQFu1wnCQmBL/w0Zt7KJhZBC1+/49lst4JhWK3E1oLf+Nfx97UTsqgwH1yexDz2EkOk4hhJGlWzYsArB4pY2epYAZo6JAfXk2tG0Tlgm/4SXQzELV4zr01LhGI25+wBkJQcDX4sHD8dq6732ZwusZ32baHOAwySh4RO7/jn2/1Qb30BcPErqAQ9RYOwTQ1beFcmFiPGfuPZ8W++XC7VzHZ4/SiG84vPqU4aBDW3WmJ9v7SrCAM/F4HDt9CSYgleQfinnnk5L3PXsdPrceCNduIavugp/Zy/3yR6eaiguiPtG13z6HzoCUZtkStU0ChihQ9btsaPUbRqz9D0C3hOCtyZzPxMD7xOmIcJVDQquPMDAGf2joQR56SkZuG
 R9xSVJRH
 jyjTJc++FRjjvmltdRM7RwD0ij6i5yGb262783Xsb4q72OyT3Akp2svNL0Ib84hCuCVmWOVsxOQdad6kpG1inSTbIRQVE0XmQ7uJLra9xgXbC0M5nWyrao+TftJwxJqJT0SAupVRT/oRa8XPupV6RHaU4WzW9dr9u+UjcJL9Vzm9m8082RjiISn64/0JTrzT2mji0tJTMCiZ+O8mQeVyuj1YWm+tNfca6Ap65/ptR5udP6itdlxqsY0EawyiMR/Z2zmdjBVyQ+qnNy8FxbIB0R/xHQeG85qiWJSvT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/7 18:01, Pedro Falcato wrote:
> On Fri, Jul 03, 2026 at 10:50:29PM +0800, Leon Hwang wrote:
>> On 2026/7/3 17:44, Pedro Falcato wrote:
[...]
>>>
>>>>  
>>>>    The following architectures currently support this feature: x86-64, arm64,
>>>> -  loongarch and s390.
>>>> +  loongarch, riscv, and s390.
>>>
>>> This is also useless, every 64-bit architecture will support this.
>>
>>
>> Do you mean dropping this sentence, or this change?
> 
> This sentence (this is not architecture specific...).


Got it.

> 
>>
>>>
>>>>  
>>>>    WARNING: This feature breaks programs which rely on relocating
>>>>    or unmapping system mappings. Known broken software at the time
>>>> diff --git a/init/Kconfig b/init/Kconfig
>>>> index 5230d4879b1c..12bb39f637b1 100644
>>>> --- a/init/Kconfig
>>>> +++ b/init/Kconfig
>>>> @@ -2112,7 +2112,7 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
>>>>  	  from a kernel perspective.
>>>>  
>>>>  	  After the architecture enables this, a distribution can set
>>>> -	  CONFIG_MSEAL_SYSTEM_MAPPING to manage access to the feature.
>>>> +	  CONFIG_MSEAL_SYSTEM_MAPPINGS to manage access to the feature.
>>>>  
>>>>  	  For complete descriptions of memory sealing, please see
>>>>  	  Documentation/userspace-api/mseal.rst
>>>> diff --git a/mm/mseal.c b/mm/mseal.c
>>>> index 9781647483d1..0464c7b94ab9 100644
>>>> --- a/mm/mseal.c
>>>> +++ b/mm/mseal.c
>>>> @@ -132,8 +132,8 @@ static int mseal_apply(struct mm_struct *mm,
>>>>   *   addr is not a valid address (not allocated).
>>>>   *   end (start + len) is not a valid address.
>>>>   *   a gap (unallocated memory) between start and end.
>>>> - *  -EPERM:
>>>> - *  - In 32 bit architecture, sealing is not supported.
>>>> + *  -EINTR:
>>>> + *   interrupted while waiting for the mmap write lock.
>>>>   * Note:
>>>>   *  user can call mseal(2) multiple times, adding a seal on an
>>>>   *  already sealed memory is a no-action (no error).
>>>
>>> And this whole header needs to be deleted as well. No one's looking at
>>> kernel code for documentation (and if they are, we did a horrendous job
>>> at actually documenting the thing).
>>>
>>
>> Just to confirm, do you mean removing the entire function comment above
>> do_mseal()?
> 
> Yes. Again, not your fault, just old gripes :)
> 

Got it.

Thanks,
Leon



