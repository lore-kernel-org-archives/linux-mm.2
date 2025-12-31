Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED8D2EE6428
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 15:30:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613956B0088; Wed, 31 Dec 2025 10:30:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F18A6B0089; Wed, 31 Dec 2025 10:30:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50AE36B008A; Wed, 31 Dec 2025 10:30:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 41E846B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 10:30:46 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F31438BA88
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:30:45 +0000 (UTC)
X-FDA: 84280153650.05.666CBBB
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	by imf08.hostedemail.com (Postfix) with ESMTP id C770F16000B
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 15:30:43 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="Yn6KkKz/";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.46 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767195044; a=rsa-sha256;
	cv=none;
	b=WxVWXsK5ku/pym1MLm/VtBYiUITLJ2O6qnnSmwm4CrRPLdijSGSdrhDq9dBpnB5HtB3sG2
	Foe5nR+TP8ewG9WHPBOpVwSA8AV9kbapIZ7ovnLji4xPad4K1FAvBaNOFFcRA6tkZFo2Hy
	TSS4aHKw+USKSrGlLdgHXvxwwaRS79Y=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b="Yn6KkKz/";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.46 as permitted sender) smtp.mailfrom=axboe@kernel.dk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767195044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7QzVSYweQj11hd6fs/gbMsc1XDMFllelUQ/hmQuDpYw=;
	b=TlB6p4iYIl8JlX7XuOHUSrGv89WGm5GdZ7pPsjaAwdWUH710ONqprixILcc0sd1QXv0LXV
	OAJd2n3afXqrVyerLyJlXo5SfBDd9pigUn71oq843xzqav8adFm8Q/gbebaMnSRKtUD6H5
	kg6z/dA0u5r4m7VRI22zvFAPX0oXiO0=
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c75b829eb6so6911665a34.1
        for <linux-mm@kvack.org>; Wed, 31 Dec 2025 07:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767195042; x=1767799842; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7QzVSYweQj11hd6fs/gbMsc1XDMFllelUQ/hmQuDpYw=;
        b=Yn6KkKz/xQn1rbUSPjcE0dzVmwand6Uz/R7lMr6RXQOcLlqBq1Ap6B3zVT62hZNYOb
         1Yp2AwOXecv1IOgzcj+cOSTkUMFce29OsQ1nUv5uuwHaNF0jDDpEGtFYYB2pID/hAxz2
         /P8umYWOn/u/c1a31nHkL2EFOzIDtXnBUT4wJec9mIOQNxD9+BzGRkghXaEpe4PFavjd
         /hKjSQebSo3BgvuzpI76qk3D37e3TIRv4APnMWuyW7SJs3oszhhhMXEpsrmv1eFfZ+KA
         09dxwhOy9a1+bMo4haIiWyphYYWL+30fXnQyLVKUrbYmpLzqRwx3r4i9cIT/1KmKy1gY
         PIXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767195042; x=1767799842;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7QzVSYweQj11hd6fs/gbMsc1XDMFllelUQ/hmQuDpYw=;
        b=gcdUbFOsBMDK6FkMTSS1N1nnhOX/5Ut+PocRoC6PygCffk4s8r7aScYgGzgicbBzV8
         0Ba2PkF9apgQiJp3k7QzTsGPgVIZHiSUQZFpWYJTj+uXvB7zyiYuEJvL7ZsetvMppIqi
         NX8BA9cYDi7BrgH7plDltH6YU4zwQ6OERzgz6Jtnh2C+fIYqUY6Dzx2h7LK6q3+viNJ2
         yu+SfNc+NhX99iKZyGlupR8jDDdo3znXbhZkQ96yE+p99lKGugOvUMx/ohctzz3ipX5F
         mFIlWLqxHHQS5E/o5ORPe8Sauq4AUXsFnkjkZi0mYWuNBa3cZrV28Ua+JK9ogMwx9p9H
         i9hQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1wd/Rir2L6kk8j6nw6jlzcC1bcuLW7k/mYTRtCfqQb5ntOIvijWoK/Bn/b8xkJeEbVsZbYm5b/A==@kvack.org
X-Gm-Message-State: AOJu0YwhTZ8ZGBg/EUUJ+o+iw17zvvUHE9pvJq/0Mwj3dLxtHtfysmkP
	+28HysreELAPd0XF86X7hYByI/uP2WDkVS1xuU0WTmC/Yk5xxltHUmQxSkrdiss12w4=
X-Gm-Gg: AY/fxX4EnO+5wdq1FvTmphI/QQr7XTltCHeXuvK6jV54N+ppRUhUyDTEbhayh2PH4/X
	YUwXEYQ58C6At+nDcMoEoM1XfMUUCbu72NK3AkzJLnLBoFJvm+cP5GXnWoLgv3WrMTd8hBeuscy
	PVzby7pDBW/oTagY1k3j0NEi2ktMr4AbsBZ/x1nCS3y8sDzhldgVLxLADUmy6JgZZj6VaqJQUuX
	4sxi+BTpjGruS7WsWWnjvdxvRvkia8Tu5VuMPgVgM4ZIt7jomCdAOwI1NhD7DkIn+zjGTb/zPOE
	m48spLwmml4n1eUQA9fuW8g2MmDnFmcvtyl61BJLHQWgWr3RlNG5MqjJOW7OpiU3OchGJk0Nq3z
	j+9GJKCmphoATQhUAniqwzscWD5Cq/EKakEXty0IEeLT153BFyezt5q93nfDd6b6IpxWf6SbxCu
	mjOrxWly1o
X-Google-Smtp-Source: AGHT+IFQ7Da3Vy7sb0sZ+gCFV6iNdLzjxsj+GHoPQqPF4ECDqs6GBYGgCjzmLYkOn7cGzscuabT/Ag==
X-Received: by 2002:a4a:e252:0:b0:659:9a49:8fcc with SMTP id 006d021491bc7-65d0ebdd6e8mr11816060eaf.69.1767195042368;
        Wed, 31 Dec 2025 07:30:42 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65d0f4cd66csm20954575eaf.7.2025.12.31.07.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Dec 2025 07:30:41 -0800 (PST)
Message-ID: <4156bbde-754b-470e-9dfb-a1e45bee81fb@kernel.dk>
Date: Wed, 31 Dec 2025 08:30:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/33] block: Protect against concurrent isolated cpuset
 change
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Marco Crivellari <marco.crivellari@suse.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-10-frederic@kernel.org>
 <0f65c4fe-8b10-403d-b5b6-ed33fc4eb69c@kernel.dk>
 <aVUs-mFYCO2qGmqT@localhost.localdomain>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aVUs-mFYCO2qGmqT@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C770F16000B
X-Stat-Signature: mikj64shzme7dgpjms9n5ewnxjzaed48
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767195043-243005
X-HE-Meta: U2FsdGVkX19Edpg7Xjotu+u1L0JT0bNthTBFj1SkKWgLhkfOZhimLcxhHuVqqDU9L2CX5CrUWE997/6ius48ashnYgACBj/1E6/Tfa2Yzwj3CViQDRcBgKdzYQCBiB1/6zQgYPdhRswTPpf8mZUkAbgErz0TqfCGr/YZJlUtl19x024V+/pQ7D83i5+Hett4cmkeR0EplyQZ6esSe9doOuhIetUomdeaYKSTF/dqufDwdVInxheJpgY2T/NBQuU55x0G05HT8aLJ4YfoXQigodEw3+wvbJ/NYIJIAap5/YjK1wupiD3VXEK9yYsRdQLA4X2qjFzhwhyVRctXNqE/mCybTU8cs7dU4EBc3gjCvF/DsERoPNCHWCeGvm8ZSN4oBqmGLOVo1Per2D6Ah6RpWXC8B6o/QfwBKQF1CXi5WcxBMuAhRKKYb5bmOYaKL/tFWuskjqD1k4XK4prIBvet2vW3IDZINnw2DrchTvCjHAlwyNeGTW+0WiabxA7NubYaUtOrMN/TKhlBBeXfW2iz58HdaXGfNsWaE9bQ22l5WasCfA5VnEpELeIJDqhqslCOYQ2jKdyp3mMU1p3SjKh9IhLFoR06X6ieQqqyYsNEVVX9g01EfhlNwz5WWGb5i8h/sl6G8c9KT4/0s+4wGPjj8M8QIBytC4Br/Eoz13BqRM/6bozG6e+QCenztV3Q+GUD2bHagoqJwh4IPnthZcAty4j1YFMXEH8lGb7GX/4fM1wRPc9kSdA3IvScvFADODA6t9qNUz71s9tVOaFjX+3Fwt2nkJhH3rXzGYJq35mdrVbrIKw+XuthN+hxD8xlhzd2SgrHROuv1SnvrC4C9PJVrazJFdqGRdiqghHtNeMabhUqZqAjwLYMMaG9SBdLZCO1WTYNUgLqX4rnDMgK526dvXh5zOXQjnvVO5oD4EY7cKhGR7QEu89S6tANpuAA5FVFXxDwmwP8AFiqHZIVp92
 a58U3B04
 Sgci/YdPGCh0iprhGJgPmHBCRwYt3UE9K8eOqDSvlDpC7kLK+sy+gwzu6LHHIDfSATtZqQROt/mejModQM6D3GMbS264CN3QphzW0uohBdsrlnXEP1vGaJ0yW7PoPsg+WKRpwyWrSQjX5syC5iaAQOfd5T5hDm0tMPyWfbJssdjGFrhYcQj1fN+YpUxBCkKZzyuvuVWNt6L4HIYr+4atr5eEJVh1+OznCSUnMP0BOaCpl7wsF48AVyQKOV/xjnA0KKfq/TaG8FWdNLD5qbdcfwjHnwQHuoRqC+ceUe+NVyu1GFPFg1ea7PXWtGbICAlli944n9JPWufbLE2LkTL7Lpy/nOoxfi0spotTq8wwIMrN5mxolJiqxaold7c1fvxSaALDC3Zq4CW/jqlCjQ8DLNRH0pk2mfY6lDIai
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/31/25 7:02 AM, Frederic Weisbecker wrote:
> Le Mon, Dec 29, 2025 at 05:37:29PM -0700, Jens Axboe a ?crit :
>> On 12/24/25 6:44 AM, Frederic Weisbecker wrote:
>>> The block subsystem prevents running the workqueue to isolated CPUs,
>>> including those defined by cpuset isolated partitions. Since
>>> HK_TYPE_DOMAIN will soon contain both and be subject to runtime
>>> modifications, synchronize against housekeeping using the relevant lock.
>>>
>>> For full support of cpuset changes, the block subsystem may need to
>>> propagate changes to isolated cpumask through the workqueue in the
>>> future.
>>>
>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>> ---
>>>  block/blk-mq.c | 6 +++++-
>>>  1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>>> index 1978eef95dca..0037af1216f3 100644
>>> --- a/block/blk-mq.c
>>> +++ b/block/blk-mq.c
>>> @@ -4257,12 +4257,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
>>>  
>>>  		/*
>>>  		 * Rule out isolated CPUs from hctx->cpumask to avoid
>>> -		 * running block kworker on isolated CPUs
>>> +		 * running block kworker on isolated CPUs.
>>> +		 * FIXME: cpuset should propagate further changes to isolated CPUs
>>> +		 * here.
>>>  		 */
>>> +		rcu_read_lock();
>>>  		for_each_cpu(cpu, hctx->cpumask) {
>>>  			if (cpu_is_isolated(cpu))
>>>  				cpumask_clear_cpu(cpu, hctx->cpumask);
>>>  		}
>>> +		rcu_read_unlock();
>>
>> Want me to just take this one separately and get it out of your hair?
>> Doesn't seem to have any dependencies.
> 
> The patch could be applied alone but the rest of the patchset needs it,
> otherwise it may dereference freed memory. So I fear it needs to stay
> within the lot.
> 
> I appreciate the offer though. But an ack would help, even if I must admit
> this single patch (which doesn't change current behaviour) leaves a
> bitter taste because complete handling of cpuset isolated partition change
> will require more work.

That's fine too:

Acked-by: Jens Axboe <axboe@kernel.dk>

> Speaking of, is there a way that I missed to define/overwrite the above
> hctx->cpumask on runtime?

Only spot where it's set/manipulated right now is as part of setting up
the hctx <-> ctx queue mappings, when the queue is configured (or
reconfigured).

-- 
Jens Axboe

