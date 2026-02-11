Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4E83EB597A
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 07:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F72B6B0005; Wed, 11 Feb 2026 02:38:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07AD36B0089; Wed, 11 Feb 2026 02:38:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC9496B008A; Wed, 11 Feb 2026 02:38:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D733E6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 02:38:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AC7A57CFA
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:38:34 +0000 (UTC)
X-FDA: 84431373348.08.8DBC8F9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 719D118000D
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:38:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770795513; a=rsa-sha256;
	cv=none;
	b=bE8b+b+auO6P0Wbz4WKHvzVrgc+Yi4f7MDcZKrh6BlZr4tc+yN616mZ5xh8NMyK1XuRHCq
	2yCwA9feANfjbtGzroVItEaYkvLUecFjVw3YVJtWUKhx+BBUxEN5ufsaZRmwXG0KzAZoOm
	g5vXuDA1EAqQMlsci/OZY9fvX5Uk/bE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770795513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GAkarDMktkvxBtofa6covm2ijqXRZyt7eZFDlrvkohs=;
	b=3Deoq1ya+z5Dn6CXsOZ3EdwpZB9kbZCHU1a2o0RDvF6ZcERmNjNMw+88+1Oc5vAIvGLos3
	yxpfdYZAhCvDx8zhaR2pdXqMkmc3nrErh8NoNYKC7JDjqpgb0lTxl4sVxwAcu09uYUVYKA
	9sLiacwwt2iPlbdbU00i5UVibFMatQI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DEF4E339;
	Tue, 10 Feb 2026 23:38:24 -0800 (PST)
Received: from [10.164.148.41] (MacBook-Pro.blr.arm.com [10.164.148.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 40B2E3F740;
	Tue, 10 Feb 2026 23:38:26 -0800 (PST)
Message-ID: <5a6782f3-d758-4d9c-975b-5ae4b5d80d4e@arm.com>
Date: Wed, 11 Feb 2026 13:07:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev> <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com> <aYOuCmjQ5lGm8Mup@linux.dev>
 <4847c300-c7bb-4259-867c-4bbf4d760576@arm.com> <aYQuj6Ot-JS4tXvY@hyeyoo>
 <7df681ae0f8254f09de0b8e258b909eaacafadf4@linux.dev>
 <b77dc11e-fe09-4f0c-a912-d05faa01ff1c@arm.com> <aYtbevHEwx_3fn0Q@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <aYtbevHEwx_3fn0Q@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 719D118000D
X-Stat-Signature: jehy7bquhxjqqqzozerkkqwidd7ie4fi
X-HE-Tag: 1770795512-997148
X-HE-Meta: U2FsdGVkX1+vNIk8FWJL+IiCQjhGu58IT4pPoqYQKVaLsNe4651PwY1gyBSVNI+RnOcxvzuCHZ5VLuNOlBXy+r2ZSSWJqXmNL4S7X8rFOZm67NqeKg5q+Ueq9YVlPSWkpqOlDazty1iYPw2Yg58gHz08f9aUH9Aa0bdpif4L9eNL5zg3wPTwSFjqHoJq5ZcfHia3X0fU2f8ggIr2bWEHjv7mkpxxZwihcetEdnJ9x4AYdTIDWJ4vFrMU+cekNFWCHYzAplP5xSohUeABk2zZuGWQIz5+mhYrz2qWTZtMEUFXTSArnUU1OUJsnCweFh5ZC6cRtU+f2WFC80HHSn6Nj3bjDec4vl7UTtkIODXKUUglYxUqAcXaVnXarH180AW6FvBA6nc114wIuR8bLEqXxzshFjhvfo1q9vrVlk1VZWvqhVSfsrCSDlbIfbNX4Pgq7Vt7xKNkoV7LX31gEfcREyozwTH/SfJLH9kWgGsuMvtbjK6/moQzzWo6NlnCAk74T363J7RorDk4xNvrqxG3nAOrVohgUo0zpui0uAidy20Iu94vqmyWP3+RAQUNE7QjdND2aDmk7QbXqOTXd/LpWlSBEe+zIs2G/vvIMFdfGoKUrbQiUu8+NTEHv1VeWI9DWZA/3dARM8OJY8Zj7J/CamHUi77wPwN14RckDjyYgnFy7TPCqxpvSxL4jy3G5vXbj2J81hdRaEw2Q0Di1XoSmDgceo6uPzsbZjAkudzOl9MmNPO/M3gXjHFQ2CWXneK284B5VG2attKW7xQ/fYF4n6dP76u1L3tqv8ZdaU8fLKAPvOKEBYRAdCw8RebK4ZNBP8YzlpIFPRVQwDlSEoSQlvXmjdIOzPZYfoYUCFp81Eqn0Xbit8UDDT10BK/wZSKq0vuJe8nT48Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/02/26 9:59 pm, Shakeel Butt wrote:
> On Tue, Feb 10, 2026 at 01:08:49PM +0530, Dev Jain wrote:
> [...]
>>> Oh so it is arm64 specific issue. I tested on x86-64 machine and it solves
>>> the little regression it had before. So, on arm64 all this_cpu_ops i.e. without
>>> double underscore, uses LL/SC instructions. 
>>>
>>> Need more thought on this. 
>>>
>>>>> Also can you confirm whether my analysis of the regression was correct?
>>>>>  Because if it was, then this diff looks wrong - AFAIU preempt_disable()
>>>>>  won't stop an irq handler from interrupting the execution, so this
>>>>>  will introduce a bug for code paths running in irq context.
>>>>>
>>>> I was worried about the correctness too, but this_cpu_add() is safe
>>>> against IRQs and so the stat will be _eventually_ consistent?
>>>>
>>>> Ofc it's so confusing! Maybe I'm the one confused.
>>> Yeah there is no issue with proposed patch as it is making the function
>>> re-entrant safe.
>> Ah yes, this_cpu_add() does the addition in one shot without read-modify-write.
>>
>> I am still puzzled whether the original patch was a bug fix or an optimization.
> The original patch was a cleanup patch. The memcg stats update functions
> were already irq/nmi safe without disabling irqs and that patch did the
> same for the numa stats. Though it seems like that is causing regression
> for arm64 as this_cpu* ops are expensive on arm64. 
>
>> The patch description says that node stat updation uses irq unsafe interface.
>> Therefore, we had foo() calling __foo() nested with local_irq_save/restore. But
>> there were code paths which directly called __foo() - so, your patch fixes a bug right
> No, those places were already disabling irqs and should be fine.

Please correct me if I am missing something here. Simply putting an
if (!irqs_disabled()) -> dump_stack() in __lruvec_stat_mod_folio, before
calling __mod_node_page_state, reveals:

[ 6.486375] Call trace:
[ 6.486376] show_stack+0x20/0x38 (C)
[ 6.486379] dump_stack_lvl+0x74/0x90
[ 6.486382] dump_stack+0x18/0x28
[ 6.486383] __lruvec_stat_mod_folio+0x160/0x180
[ 6.486385] folio_add_file_rmap_ptes+0x128/0x480
[ 6.486388] set_pte_range+0xe8/0x320
[ 6.486389] finish_fault+0x260/0x508
[ 6.486390] do_fault+0x2d0/0x598
[ 6.486391] __handle_mm_fault+0x398/0xb60
[ 6.486393] handle_mm_fault+0x15c/0x298
[ 6.486394] __get_user_pages+0x204/0xb88
[ 6.486395] populate_vma_page_range+0xbc/0x1b8
[ 6.486396] __mm_populate+0xcc/0x1e0
[ 6.486397] __arm64_sys_mlockall+0x1d4/0x1f8
[ 6.486398] invoke_syscall+0x50/0x120
[ 6.486399] el0_svc_common.constprop.0+0x48/0xf0
[ 6.486400] do_el0_svc+0x24/0x38
[ 6.486400] el0_svc+0x34/0xf0
[ 6.486402] el0t_64_sync_handler+0xa0/0xe8
[ 6.486404] el0t_64_sync+0x198/0x1a0

Indeed finish_fault() takes a PTL spin lock without irq disablement.

>
> I am working on adding batched stats update functionality in the hope
> that will fix the regression.

Thanks! FYI, I have zeroed in the issue on to preempt_disable(). Dropping this
from _pcpu_protect_return solves the regression. Unlike x86, arm64 does a preempt_disable
when doing this_cpu_*. On a cursory look it seems like this is unnecessary - since we
are doing preempt_enable() immediately after reading the pointer, CPU migration is
possible anyways, so there is nothing to be gained by reading pcpu pointer with
preemption disabled. I am investigating whether we can simply drop this in general.


