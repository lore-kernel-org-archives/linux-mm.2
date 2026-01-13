Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01509CF45D4
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 01:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EBF6B0005; Mon, 12 Jan 2026 20:49:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEB66B0088; Mon, 12 Jan 2026 20:49:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB496B008A; Mon, 12 Jan 2026 20:49:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8846B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 20:49:33 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D24A913C9E4
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:49:32 +0000 (UTC)
X-FDA: 84325258584.02.2FA52FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 470CF40005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 01:49:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cq6nkmJp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768268970; a=rsa-sha256;
	cv=none;
	b=di2/h9wpYUvRqLwiNXpayUoYFE4nuMMxqLeCpIYdQppQXlE+k5lIFi5gE2ZazHKUE+irnL
	V7t8VIhTsP+oMOz+xj+FYq2QxXWrli2b6yYiXzn9bfyurBon6P+o63oobfsaznOyryLX4L
	JDBI97SKh/K7J5+zQ02ixVuEVm4ZUi0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=cq6nkmJp;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of llong@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=llong@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768268970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ipl04u3803c/IO8SDz5fqTBlvGqq/KbVl3bI4vEOEvs=;
	b=qyRIwYPkPGzmZ8xjNa0TY1tKhC17XM7/wGkNDWLovjotQQoMKKGRuHYkeBgpluFkEO46c4
	4EkC5rTdGJFG4qPbxQiBLM0PKkwIteH+jXj3Uv8X0ivQB484pltCKghnSSEBa/16soKBww
	otwvW5AcpEozkf0YEol5xQtFyPeSZ2U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768268969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ipl04u3803c/IO8SDz5fqTBlvGqq/KbVl3bI4vEOEvs=;
	b=cq6nkmJp7XLRu0u2mCD9I2beSGedYDfd9LPLQ9XCfMqI/PB7Rt9yH3Ij37aeKtX0rCD8UL
	D2UIGBmfqyPr/Y9e2JwccJ89HvJa6KaVgb+pJgaXFCTW9kGWyxYxGHuszs/9TatQnxK5m/
	4PyJU0YXmPaFYk77eIo2gUCuIWlAHG4=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-156-pjN96lgSOpiXE_8ba98NXw-1; Mon, 12 Jan 2026 20:49:28 -0500
X-MC-Unique: pjN96lgSOpiXE_8ba98NXw-1
X-Mimecast-MFC-AGG-ID: pjN96lgSOpiXE_8ba98NXw_1768268967
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-5635a9e4998so4740524e0c.3
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:49:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768268967; x=1768873767;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ipl04u3803c/IO8SDz5fqTBlvGqq/KbVl3bI4vEOEvs=;
        b=TjvtqsIn93q7rckspRA4afdPYWKfomZKJG6/x33qaJa2du2IpjcTvJESTKAGixofbj
         pswWaHRz+L+VItf1DGq3jhuurqQKAHEVCeDy1Tj9/x0z2sTL73iI6txGRFm9yIf7Z4qW
         QrCE/6FlIoaJkzNidrTaZofzvd7bQuBlusD+rkneTvV02nikZme233UD4KbgfhRFaxu/
         FLMtY/L0Q40V6ULyR91Plr0TAlsFvTfiJfVs0T+n8Jvojv04P/xuTph1GDKpOnh7dM2z
         QUQ7k/JJy1WtF1MD/9mrJ94jxedrnjFd6HZGOPx+jy+czgorz882b4gC1oHY9qahKYO8
         A7Tw==
X-Forwarded-Encrypted: i=1; AJvYcCXR2l4OJLX1QRcz/IUB16FpdV4XqZls/NBtOs2TG8CsB6YtUer/U9+TrtoPccI02rNAGGWPB0HP1Q==@kvack.org
X-Gm-Message-State: AOJu0Yyh7UoBV1Sw4jLlXmijNALx2CCHDBMEHSgqfHAer9CbbhH8unBI
	HF/mK1sjhBXBCoVSijVZL++WAzJfGNcv7IWdeHafnh6iMVmmXCsU+B5N3FcnwWUf1qAQZ2pTEyC
	bOOStR77b98OW+hJZBtgUiflZM9NY9SR0kGhon218Tsg+Z0Qno/f/
X-Gm-Gg: AY/fxX7y5aO4pPJyB5izS6C383irumtSd9fw65gxaGZcXBbvap6FO68Mt73bcxcxZm4
	Fhm0uNDIVnoWojPKsNxkj/JE60de1Z/WrrSCbWrXDwqkE7Y34b1W/96vExt0LfBbWyYYd/UV8XL
	ql55mhy6yVIGg+AoiarL514uCgHeU/eV/k06evHqH/ju6NRX8sdio68WbnYIo7uNiRYePpRm/CT
	1BHRDk1q0BRFTwlkrLWH3wZgVOHmysreMIbeQG0+dk6EaLq52bCMHaaV00og/w7HXQ0qWBRC470
	wlR3Ut5vzFwU4urcvSp4nFc2YCBmHwy9Ub/DQRPhAixRBQTB4tNW95LXDo/zrxVMtOI7GNya/Dd
	3hy604dl1+Mu4+xTM0m6jwbFISqYrz+9gb0W/T8/yX9qlwLeNkUPiZ9rw
X-Received: by 2002:a05:6122:4b89:b0:55b:305b:4e38 with SMTP id 71dfb90a1353d-5634800729cmr7402452e0c.19.1768268967533;
        Mon, 12 Jan 2026 17:49:27 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFK3nQoFNSvzu3p3PMs7jwaVTVycoM8jcu4b27g95LRRVLuycfC94MCTb+8aGEaS+r94nXQbg==
X-Received: by 2002:a05:6122:4b89:b0:55b:305b:4e38 with SMTP id 71dfb90a1353d-5634800729cmr7402411e0c.19.1768268967043;
        Mon, 12 Jan 2026 17:49:27 -0800 (PST)
Received: from ?IPV6:2601:188:c102:b180:1f8b:71d0:77b1:1f6e? ([2601:188:c102:b180:1f8b:71d0:77b1:1f6e])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5635bd72c7esm13437373e0c.12.2026.01.12.17.49.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jan 2026 17:49:26 -0800 (PST)
From: Waiman Long <llong@redhat.com>
X-Google-Original-From: Waiman Long <longman@redhat.com>
Message-ID: <2857c203-96e5-4bf9-b19c-7a80b009cce2@redhat.com>
Date: Mon, 12 Jan 2026 20:49:11 -0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/33 v6] cpuset/isolation: Honour kthreads preferred
 affinity
To: Frederic Weisbecker <frederic@kernel.org>, Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
 Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>, Danilo Krummrich <dakr@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Michal Koutny <mkoutny@suse.com>,
 netdev@vger.kernel.org, Roman Gushchin <roman.gushchin@linux.dev>,
 linux-block@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
 Eric Dumazet <edumazet@google.com>, Michal Hocko <mhocko@suse.com>,
 Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
 Chen Ridong <chenridong@huawei.com>, cgroups@vger.kernel.org,
 linux-pci@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "David S . Miller" <davem@davemloft.net>, Vlastimil Babka <vbabka@suse.cz>,
 Marco Crivellari <marco.crivellari@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Simon Horman <horms@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
 Jakub Kicinski <kuba@kernel.org>, linux-arm-kernel@lists.infradead.org,
 Gabriele Monaco <gmonaco@redhat.com>, Muchun Song <muchun.song@linux.dev>,
 Will Deacon <will@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Chen Ridong <chenridong@huaweicloud.com>
References: <20260101221359.22298-1-frederic@kernel.org>
 <437ccd7a-e839-4b40-840c-7c40d22f8166@redhat.com>
 <aWVxJVQYEWQiyO8Q@pavilion.home>
In-Reply-To: <aWVxJVQYEWQiyO8Q@pavilion.home>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JFLgIbDAymXoyRPMGI_dPIKqjPpk8aN-gCHdNYvWX0c_1768268967
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 470CF40005
X-Stat-Signature: it9zzkeswjd8tm5aninrmsgsx7yjof9d
X-Rspam-User: 
X-HE-Tag: 1768268970-919093
X-HE-Meta: U2FsdGVkX19hTE7K5tJn9zeaEEJT+mlE8KewzCSzfBHTmCeUYcr2O9hzVptlyl2t8bmtEfS9/Tv8tN/zgpdhVfgsrznPvA9XopHisZE/Yz9PsxGmm3jAe6vulclgHrtcaib8VvW3WxvjS8mXO5xpp5GobEEEnXm6pVBiDtyK57NQ7LQPWw0L2HMmCyvq/2ZXLzJJUVWaV2EaDEbjxc5JFvO7IBIMA5IBbjwbzYqaQQuVTNF64hqMQb5XB0D23zt5obTi/SQf8ysnTZKxhgy3BLrS75nrryjOpHp0Mzaltoa/DH1G6GYQzJKxXHpm618Rj4BqcTVv6j3Q6XHQx2bIbKslrLVu93sThWyVABp6FlknJyHqguiB8sUL1I5YOveMO4jdT7YwQlgQqmiihWCL8tUn+Fj2jiBiNF9tXz/X1piYj6VKbXSafUmir+YOt7Oiisdkv1bm+2CTV+XnjR9bGkbPs5HHJ6ReXghMVv4xDi1MMUdRYZOMNBICD+CopYqlRPFd7XSb+fKpZw19e33F6GYSKQhc1xxZhPgGBP7Omrtlw1br4QRcpI6Dzh3V6dLtBD6vhWMfdK3RZAkjRmqbsnHVXfKFglLAeVb7B4xfQZ2U8YPWc5BzHZlYuIn1AYZp5ANJ04ee7OSNB9sXPO7cQUtky8vqSErYYRhl+Lb5cqcLitzr0/vRWnQWWVt34nHLvrEjW0ClxW5dwOOm5KEPVAROpfbOWbHaE1qcJRUvFryMA1hKaN0IrEupgwfAjwWJqL98oMiBQRhIIu+o7JHB3ItHML3+Azd/Kynbn9BGgZMNmOFv9fGH6ZYKJ7JAFx1EDSvqJQraIJLKqDihxIDNAVBfer6jSK22LyiHQILVz2Uhl1blG+LAFcYIM9f4p6/T0HFDVLYPfcvyYfhGh/omCb5jf0siMXiEGcUFolL629Wu+ka8PWOrCn63M+svf9CXLeCd60s6/rfIiOUsRWQ
 fToa1zqh
 o/pSoV0GlzOrdyXRgw/7zx+bPlEAP8dFRehfQ02TaXhKXg38dhPgc8BA1BIhJ6OpzdK40YP7Bz0Jyh7q1JMl8TQOos0nkYcEEVIaQ3IvxmdE4NJH2NChO+/32qjLRdmfC9/3IAJcmwBESCoukXwxU2p5Ycat7T+ltEbrheuJuZoR36KmNUgElCDlmLyD0NgTvMC9FcgxF3SyToxOJ2BWVIqvNSY1T6lSVABy/cGEciS6r56pZDBzD2YmdVnime4uVN8DPRoO0UO5YQYZ0oRi84qPOAsh7bBNy/c/AYpaa2PCgIIol6B/j2s6DBiebaiuwpU0uecim0Nkq1op6emTtM6Cn8DSbNgqsFRueyIMrSxQsWRmiqhkIH4VhzlTDNjWR5EJPGZS7XQgf+Uaczn9Tg35t18GvWgwRvVa4Gs0xrLSSZTBtKPQQYylR2ntPed/9dhGxHqMmNEO5xGTPfU+Wf0TGmaSWyawsKXHrx2WWyLnVYOcSxD1sGXu49oDMWyknjG4fqwzR6YfPxm3HcWLmpDCfYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 5:09 PM, Frederic Weisbecker wrote:
> Le Mon, Jan 12, 2026 at 01:23:40PM -0500, Waiman Long a écrit :
>> On 1/1/26 5:13 PM, Frederic Weisbecker wrote:
>>> Hi,
>>>
>>> The kthread code was enhanced lately to provide an infrastructure which
>>> manages the preferred affinity of unbound kthreads (node or custom
>>> cpumask) against housekeeping constraints and CPU hotplug events.
>>>
>>> One crucial missing piece is cpuset: when an isolated partition is
>>> created, deleted, or its CPUs updated, all the unbound kthreads in the
>>> top cpuset are affine to _all_ the non-isolated CPUs, possibly breaking
>>> their preferred affinity along the way
>>>
>>> Solve this with performing the kthreads affinity update from cpuset to
>>> the kthreads consolidated relevant code instead so that preferred
>>> affinities are honoured.
>>>
>>> The dispatch of the new cpumasks to workqueues and kthreads is performed
>>> by housekeeping, as per the nice Tejun's suggestion.
>>>
>>> As a welcome side effect, HK_TYPE_DOMAIN then integrates both the set
>>> from isolcpus= and cpuset isolated partitions. Housekeeping cpumasks are
>>> now modifyable with specific synchronization. A big step toward making
>>> nohz_full= also mutable through cpuset in the future.
>>>
>>> Changes since v5:
>>>
>>> * Add more tags
>>>
>>> * Fix leaked destroy_work_on_stack() (Zhang Qiao, Waiman Long)
>>>
>>> * Comment schedule_drain_work() synchronization requirement (Tejun)
>>>
>>> * s/Revert of/Inverse of (Waiman Long)
>>>
>>> * Remove housekeeping_update() needless (for now) parameter (Chen Ridong)
>>>
>>> * Don't propagate housekeeping_update() failures beyond allocations (Waiman Long)
>>>
>>> * Whitespace cleanup (Waiman Long)
>>>
>>>
>>> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
>>> 	kthread/core-v6
>>>
>>> HEAD: 811e87ca8a0a1e54eb5f23e71896cb97436cccdc
>>>
>>> Happy new year,
>>> 	Frederic
>> I don't see any major issue with this v6 version. There may be some minor
>> issues that can be cleaned up later. Now the issue is which tree should this
>> series go to as it touches a number of different subsystems with different
>> maintainers.
> It indeed crosses many subsystems. I would be fine if anybody takes it but
> nobody volunteered so far.
>
> The main purpose is to fix kthreads affinity (HK_TYPE_DOMAIN handling cpuset is
> a bonus). And since I made the pull request myself to Linus when I introduced
> kthreads managed affinity, I guess I could reiterate with this patchset. I
> already pushed it to linux-next.
>
> But if anybody wants to pull that to another tree, that's fine, just tell me
> so that we synchronize to avoid duplication on linux-next.
>
> Thanks.

Good to know as I am wondering where it will go. So you are going to 
push that directly to Linus.

Cheers,
Longman


