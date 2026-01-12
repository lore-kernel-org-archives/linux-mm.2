Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F51C9EC63
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 10:33:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 919046B0088; Mon, 12 Jan 2026 05:33:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6EF6B0089; Mon, 12 Jan 2026 05:33:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2B06B008A; Mon, 12 Jan 2026 05:33:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 68E4B6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:33:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CB78BBCAB
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:33:07 +0000 (UTC)
X-FDA: 84322949214.07.159C192
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC1C8100008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:33:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768213985; a=rsa-sha256;
	cv=none;
	b=otVabjxNjHV5uEHktmAVjvVxy4LJuirPr7BTyvI2pchFZ72f2OLkTW2zui/OKW1qIrgpOh
	vLA3aOe/Pl6atEzTBtD766LlJ/28cT7eqByA29q9RbLEkS3PtGhNI2jLTHxf7ATQxs+XSi
	8EalyxOMlvj2z2j5BVlvjpNNypTsMVo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768213985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mvctVaxd4sOFsJWNCQFbgfuy74b7e3luqQHncMBZ6OE=;
	b=aRMlxti8UftVoF+7635x63P4JYRjhgLet5+m9Xmv/LEprzzZuXDU/ilYx1qO0Q/Xz3KZSq
	QNqZQKZZhOh41jkUtiiCBleyKvNNUsE5OLzdRoO/jGonv2ggujPUjvFHDcVAQ9bKKHLeAZ
	NZdheccZ3hQpgKK6AUt3VsZekrQU3Z4=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqTGn1pKBzJ46F8;
	Mon, 12 Jan 2026 18:32:49 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 772AE40539;
	Mon, 12 Jan 2026 18:33:00 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 13:32:59 +0300
Message-ID: <909dbaad-f0da-4372-a151-a393619da6ec@huawei-partners.com>
Date: Mon, 12 Jan 2026 13:32:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1] mm: improve call_controls_lock
To: JaeJoon Jung <rgbi3307@gmail.com>, SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <artem.kuzin@huawei.com>,
	<stepanov.anatoly@huawei.com>
References: <CAHOvCC4FhpLrknhvWbDd=cxaLUyxHFkFxBDYSC3waeg4FC+TBg@mail.gmail.com>
 <20251231045948.77624-1-sj@kernel.org>
 <CAHOvCC6ZPyi=tMK9YhcuWPEzdnTje1ADCWzhs7uJCwHh3SMHpg@mail.gmail.com>
 <CAHOvCC602B=SSU+4HQ-Q6fuFEfxuA08G9zLLQy64gPfMK=mY-Q@mail.gmail.com>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <CAHOvCC602B=SSU+4HQ-Q6fuFEfxuA08G9zLLQy64gPfMK=mY-Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500003.china.huawei.com (7.188.49.51) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: DC1C8100008
X-Rspamd-Server: rspam06
X-Stat-Signature: exgepnmus5uwrqpyha78pdcbrz6oxw4i
X-Rspam-User: 
X-HE-Tag: 1768213983-546832
X-HE-Meta: U2FsdGVkX1+X63gMFQ7QflxXAwqRopoVYGShz4oKOVpCkQF1ERC7RjE5hctUzo/XHjGoKQK/o5QmeLUwUUfG5NsKgmcvauQah25u50f5HwPGF5ZReZAuMKY3h1b6voGJN1zU4mPDHg67Mw4Y+JCd60m2rIV9MXE5ROXz0pYdsvX/DF+CZdkWhFx3ZGgbw0Z58wFSyaB3G5N0T3l83meycL0gqqFm++tUUoTmTMsYHMjD0XsmKSuwbpvsfGyoXFMZg8HfsnuFVZlxYhqF3hXKiDmlfyiBsIFrs1nosFekx5Wa7mO58Puo3nngx0YGmyxcssTSnFi9CdE1kUwQbv4XqsxSQC4Dhnvbj1dbMPv7BdUZlEumKoX6aoGXF7hz8hj05ZwKJDqg7/PtJ5HlzZiY1pcmiKpHx/gLT5oOw3uMPe5WGYp8u6yRUcmiWOo5+64ddmk4TbnqpkxJ+h6elyEPMiz4y3L20/NN5c1wq1uKDu5HvxQxQe2c2L1he3I3bwHsV5ZZPUbSeFhzeRPZFcJUYxiboN8NDXMUYncEKe4cHgSJnd0dPzocjR5G3jaGkmGhN2P2ESOjSvdfLLalsAp1fnZxFmNc1RWwbuw8/N8a/p8qcox6jkaiDFE+jPZHa+fnYZj/LKxAPd3qGU8xmSzMmK2z0x/qr8FDZk8UF1ENFFBI6WMl57DgSzq+K2zz7jicV5r6NM1snv3ArM0aA0t5uXK7KtSZSOgxedQOFIL75PyNn3MMcth55U69rrTn6wtRB2iLu8sysTLvHb8uH8CYU6hXS7QdoyTtS6r7raP8nszrpvy0sf23H+ak8ulVaVPZ7oDeUCgM/6ETtQGh7lxnJlxid/jczLXh5V1dzRIF4Xa2wYfd+UlxRZkLALr8VQtWnWFdR+2vfi6F/e1XSGhdLPZMBX82LzUdJU0NM/VG3nz8uJjfuUweFcPRsqmRVNXkK/Q8GpdlADUR1QlqavH
 v36fNRJo
 plGO7nedRAQp2b15qFVCw+n9IC9ipeIP7+f9p6mpFvYVdwL3jH1+PblGmHdarTNmGukmWtHhFKRoYZUQYdyaYO1b8ezepfE9Aa16W3F0/HSYK5OrHfEEuvOfMzAW3Y9PxMmJgvKyiqYW7gYxqfy1tfNrDmSz4IQglE+D1G0ikS1gDG3SDZIi1eO6ow22VpoVFc5SwO6hJRFaxsS7CC01TPi34QUqekg1yb+G4CyMarhYa7daxKvNoJhlLd2/Gt1avmhHr3PuZqXRC2jgZpg2e5WdaihsJZb66XO6ldL84zkijprmuzNwN/cFag3MWQfR3lybiNmPKgZQgTAutI7yrwQ5sliC01qdSZa9FPepZTtYoMTNNPKRGLmCQKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/31/2025 10:51 AM, JaeJoon Jung wrote:
> On Wed, 31 Dec 2025 at 15:10, JaeJoon Jung <rgbi3307@gmail.com> wrote:
>>
>> On Wed, 31 Dec 2025 at 13:59, SeongJae Park <sj@kernel.org> wrote:
>>>
>>> On Wed, 31 Dec 2025 11:15:00 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>>>
>>>> On Tue, 30 Dec 2025 at 00:23, SeongJae Park <sj@kernel.org> wrote:
>>>>>
>>>>> Hello Asier,
>>>>>
>>>>>
>>>>> Thank you for sending this patch!
>>>>>
>>>>> On Mon, 29 Dec 2025 14:55:32 +0000 Asier Gutierrez <gutierrez.asier@huawei-partners.com> wrote:
>>>>>
>>>>>> This is a minor patch set for a call_controls_lock synchronization improvement.
>>>>>
>>>>> Please break description lines to not exceed 75 characters per line.
>>>>>
>>>>>>
>>>>>> Spinlocks are faster than mutexes, even when the mutex takes the fast
>>>>>> path. Hence, this patch replaces the mutex call_controls_lock with a spinlock.
>>>>>
>>>>> But call_controls_lock is not being used on performance critical part.
>>>>> Actually, most of DAMON code is not performance critical.  I really appreciate
>>>>> your patch, but I have to say I don't think this change is really needed now.
>>>>> Please let me know if I'm missing something.
>>>>
>>>> Paradoxically, when it comes to locking, spin_lock is better than
>>>> mutex_lock
>>>> because "most of DAMON code is not performance critical."
>>>>
>>>> DAMON code only accesses the ctx belonging to kdamond itself. For
>>>> example:
>>>> kdamond.0 --> ctx.0
>>>> kdamond.1 --> ctx.1
>>>> kdamond.2 --> ctx.2
>>>> kdamond.# --> ctx.#
>>>>
>>>> There is no cross-approach as shown below:
>>>> kdamond.0 --> ctx.1
>>>> kdamond.1 --> ctx.2
>>>> kdamond.2 --> ctx.0
>>>>
>>>> Only the data belonging to kdamond needs to be resolved for concurrent access.
>>>> most DAMON code needs to lock/unlock briefly when add/del linked
>>>> lists,
>>>> so spin_lock is effective.
>>>
>>> I don't disagree this.  Both spinlock and mutex effectively work for DAMON's
>>> locking usages.
>>>
>>>> If you handle it with a mutex, it becomes
>>>> more
>>>> complicated because the rescheduling occurs as a context switch occurs
>>>> inside the kernel.
>>>
>>> Can you please elaborate what kind of complexities you are saying about?
>>> Adding some examples would be nice.
>>>
>>>> Moreover, since the call_controls_lock that is
>>>> currently
>>>> being raised as a problem only occurs in two places, the kdamon_call()
>>>> loop
>>>> and the damon_call() function, it is effective to handle it with a
>>>> spin_lock
>>>> as shown below.
>>>>
>>>> @@ -1502,14 +1501,15 @@ int damon_call(struct damon_ctx *ctx, struct
>>>> damon_call_control *control)
>>>>         control->canceled = false;
>>>>         INIT_LIST_HEAD(&control->list);
>>>>
>>>> -       mutex_lock(&ctx->call_controls_lock);
>>>> +       spin_lock(&ctx->call_controls_lock);
>>>> +       /* damon_is_running */
>>>>         if (ctx->kdamond) {
>>>>                 list_add_tail(&control->list, &ctx->call_controls);
>>>>         } else {
>>>> -               mutex_unlock(&ctx->call_controls_lock);
>>>> +               spin_unlock(&ctx->call_controls_lock);
>>>>                 return -EINVAL;
>>>>         }
>>>> -       mutex_unlock(&ctx->call_controls_lock);
>>>> +       spin_unlock(&ctx->call_controls_lock);
>>>>
>>>>         if (control->repeat)
>>>>                 return 0;
>>>
>>> Are you saying the above diff can fix the damon_call() use-after-free bug [1]?
>>> Can you please elaborate why you think so?
>>>
>>> [1] https://lore.kernel.org/20251231012315.75835-1-sj@kernel.org
>>>
>>
>> The above code works fine with spin_lock.  However, when booting the kernel,
>> the spin_lock call trace from damon_call() is output as follows:
>> If you have any experience with the following, please share it.
>>
>> [    0.834450] Call Trace:
>> [    0.834456] [<ffffffff8001b376>] dump_backtrace+0x1c/0x24
>> [    0.834471] [<ffffffff800024e0>] show_stack+0x28/0x34
>> [    0.834480] [<ffffffff80014f4c>] dump_stack_lvl+0x48/0x66
>> [    0.834493] [<ffffffff80014f7e>] dump_stack+0x14/0x1c
>> [    0.834503] [<ffffffff800032c6>] spin_dump+0x62/0x6e
>> [    0.834511] [<ffffffff80087376>] do_raw_spin_lock+0xd0/0x128
>> [    0.834523] [<ffffffff80de9378>] _raw_spin_lock+0x1a/0x22
>> [    0.834538] [<ffffffff80255c0c>] damon_call+0x38/0x100
>> [    0.834548] [<ffffffff8025f022>] damon_stat_start+0x10e/0x168
>> [    0.834558] [<ffffffff80e21ab4>] damon_stat_init+0x2a/0x44
>> [    0.834568] [<ffffffff800157c0>] do_one_initcall+0x40/0x202
>> [    0.834579] [<ffffffff80e015f6>] kernel_init_freeable+0x1fc/0x27e
>> [    0.834588] [<ffffffff80de0a9e>] kernel_init+0x1e/0x13c
>> [    0.834599] [<ffffffff8001716a>] ret_from_fork_kernel+0x10/0xf8
>> [    0.834607] [<ffffffff80deab22>] ret_from_fork_kernel_asm+0x16/0x18
>> [    0.943407] NFS: Registering the id_resolver key type
>> [    0.948996] Key type id_resolver registered
>> [    0.953614] Key type id_legacy registered
> 
> The above occurred because spin_lock_init() was not performed.  The problem
> is that spin_lock_init() was not added while deleting mutex_init().
> Please refer to the contents below.
> 
> @@ -539,6 +539,7 @@ struct damon_ctx *damon_new_ctx(void)
> 
>         mutex_init(&ctx->kdamond_lock);
>         INIT_LIST_HEAD(&ctx->call_controls);
> -       mutex_init(&ctx->call_controls_lock);
> +       spin_lock_init(&ctx->call_controls_lock);

Right, my bad.

I can submit a new updated patch with this small change. However,
I believe, as discussed before, that the improvement in general will 
be small and it may not be worth it.

>         mutex_init(&ctx->walk_control_lock);
> 
>         ctx->attrs.min_nr_regions = 10;
> 
>>
>> Thanks,
>> JaeJoon
>>
>>>
>>> Thanks,
>>> SJ
>>>
>>> [...]
> 

-- 
Asier Gutierrez
Huawei


