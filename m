Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DDD4CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE6DB8E000C; Fri,  5 Sep 2025 05:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E971A8E0001; Fri,  5 Sep 2025 05:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85FE8E000C; Fri,  5 Sep 2025 05:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C17E38E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:10:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6573711AD4F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:10:17 +0000 (UTC)
X-FDA: 83854625274.11.AA2B28D
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55840C000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:10:15 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YOOlD4WD;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063415; a=rsa-sha256;
	cv=none;
	b=UsSW/hregrGO/LFpg4RokUpaFkB2ivlmlaGOYwP20FSmuBvCb8YFwRcjqX8MxWZTCwBrsW
	J1P9qObpoIcxkH7uHebdCjQmqEBA426FjDWSvwK5bPiE8y50xm4m0KRxzvvxjCkDwovU+3
	i/pGw4D6ss9SD+g2d3wm80qIYMriFd0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YOOlD4WD;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMRIr/PshIEhnyVR0PjTCDKG8wZjNyfPtvv0kJr15Os=;
	b=UQs5QpasYDpHy71H6iN/iqcPUsliMYBU2c03MX3QTu/YMh30iIdSnj5WVh/YpHa6Ste4xs
	KDZA1Ss4I9qbJYN9PQnNE6x3NFI+tRFWjpG3Et39q/60EV9NWOTxUv9lXZvg1jr52oJUE4
	D8gHUZHexZIcEW6EHv+ImJeUaqkZifc=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b87bc67a4so13623455e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063414; x=1757668214; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WMRIr/PshIEhnyVR0PjTCDKG8wZjNyfPtvv0kJr15Os=;
        b=YOOlD4WDQLe9d+AL5+TZNJe/TOh3db+r42Kmty71QYX9gHxzSLvN7amM6oftS5ub9N
         gJdXyDWFFjGUwwUQq0op0ixWtKfFcVeUIB37XR3eSEnMgFMT1vLySA6KGgww4rt7c5Dk
         jAUjnwqcC84wBFT1Cxs3qnhYopahRGA+mifT4y7VGfa+nubvlAQPT8rO1pm4yPWVxUd2
         P/l+rwLRx7futf2GvvltfJ+Zw4/YiOInLb2ZLTBQaRfx9CyHURPF7RHQeg4HUV1+B3Lo
         PhipZ9wTPyRjiLAMtt15aHwx9KORlprQNE6ImVDDuH1PTXVEE8Unm3fOdLanBcn9kujx
         O78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063414; x=1757668214;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WMRIr/PshIEhnyVR0PjTCDKG8wZjNyfPtvv0kJr15Os=;
        b=DbBLJUC16yNGeYZPtWUTIhopFh/76lD5eeaEOvpY8CsNq6KuuUKzNyNHBsV5I+T4dt
         QcpApzsqeoLE3ibTZJ/Kl/96XHXgMpN+ofQ3Eu5btwXRHd6YY2ajmab2AM86Z88TjIoq
         nTLSD1/ZHFKC/8x9ltE+H6kjRMKeEBSeWKXWseA48+I+SgoThQVw7p8bAomBwGf16BAk
         rPxtkRzBvjH5iCv/13UE4tcoMmQyByzV57voBAI1lUATJ8i4lyiibFyo/oCnydOCduT9
         L8Fy5GjMn6pSDhSPPlGoV5BKqqsmwQoECiX68kNTX7YFSYEBy8vE1IIWOO03cEnQsxzu
         +KEw==
X-Forwarded-Encrypted: i=1; AJvYcCVHadWgLJvcAMFKiiheFwDKCFcWu0evtlJ+TE3nCHKJDpUpsg9sBs3NzpMlB9i8MPsOJr9Ciak10g==@kvack.org
X-Gm-Message-State: AOJu0YytbUWBq+AyMny1q5CYvaw/K4wIpTeS+kEY8YwfCJg4ZUDwLGOo
	DWjU8qDd3jcJb+BGwrCsKTjJUIIz16FXRrOesJwi2dD5N16iOEPFKKLlcgZ5qTIM6Bs=
X-Gm-Gg: ASbGnctuen4bguJICgraHLkYqGr4scEi3vivrzmmHIP0IHIcHEtUkEtTGuL/8H3y1Kt
	fIcB3itjq8EeBON7NVpoktploCWgMED4zJ8z+YksMxe53NrhPOdBYjjfY1TX2CQcpsVwI7Ki5YB
	9CI/eXs9fqhvJ2MNxwvVUs8wyF4KJnMekedy4VTTkCbQc2yOCBviwSWUJ7jZLY7Y0f6gOXUctQk
	v98UAzVnwySVIILOGsPr3aYyir256eWmvwSwDV2OpQw9nB+3luvOiUiH/LpvOKDspLkQ8KZcLBO
	9c+T5RC6sg18nIPelxd8akqY4TPVuQgcchqB6fBpoTEbE3thN1MGA406fPww5J/PUNBmu/sQY6L
	qHtYZGogBYMX/UAndVv7odYpmtGGpaMzTlvLM+6M3al0=
X-Google-Smtp-Source: AGHT+IEp9VY+vvlwjuhO74WpaZkaJSHtZmf4um+I77qI0S0ih2ZATCtJXrneKXGsg2LVm6uxWv48Dg==
X-Received: by 2002:a05:600c:4f10:b0:45b:8d2a:ccf0 with SMTP id 5b1f17b1804b1-45b8dde6e6bmr135485805e9.12.1757063413546;
        Fri, 05 Sep 2025 02:10:13 -0700 (PDT)
Received: from localhost (109-81-31-43.rct.o2.cz. [109.81.31.43])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b7e68c83asm346444845e9.20.2025.09.05.02.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:10:13 -0700 (PDT)
Date: Fri, 5 Sep 2025 11:10:12 +0200
From: Michal Hocko <mhocko@suse.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: rientjes@google.com, shakeel.butt@linux.dev, akpm@linux-foundation.org,
	david@redhat.com, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm/oom_kill: kill current in OOM when binding to
 cpu-less nodes
Message-ID: <aLqo9NKQ-xDfJ-14@tiehlicka>
References: <20250904134431.1637701-1-tujinjiang@huawei.com>
 <aLmhbjtF0Sp75XXE@tiehlicka>
 <f088cdda-9799-43ef-a4f0-fba563be4076@huawei.com>
 <aLqadzgmyGGjSck6@tiehlicka>
 <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87e085b9-3c7d-4687-8513-eadd7f37d68a@huawei.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 55840C000A
X-Stat-Signature: hofxdcfowuijd1bj3bfmnexzsmzxnc1x
X-HE-Tag: 1757063415-481908
X-HE-Meta: U2FsdGVkX187aOtV4osuKZ/RLwAma9+hgPMDinOVsrd5XCGoqLUFzUMAT2zI3SeqxY3M1cAre0cjsCsLjntAjhmLZZ5dqmixMtCv/tdLl4WeCCDzvwru8pzyAsxcLLG86bN3RnJm0K4wY7JtkA1yKL0Kbp9HxXYzPS4aU6Rth49arQkZ8gvHsa6v7s/QnUjN3fPmg8KZwMuVodaMz7OUfR0eoklZIfk6pRfNZCFctjvX1mXx6cRDdeuDLbTisFME1DbvdWuLWBbGj/hrS+uXdFYO1Z9B5HGKdfyDopZzg7LHB7lzNwkZq721ZIvhRp7s9TnK8F7XbF3TCHmAG5tRqMocP1ylKgIf3wVQq3MEwDif2j4gHbD0/QPzrUojyCIbdbKHTbpbFpZPSiGaZLz0z8sgmMTvDcpLH3vj02onb0HwghS7mJ65G109CpN2chbcXkfYnhEfm8iiabKZQTwMwihZ92EOr/P7fob3zd/G/88n0LufeL5bzkoTMYQJ8F65DcoED1ziCaKEpTqtBwxaInRA2Rt4rpb9L0L2mZQnLnVMTfxdRFl+n24+dfLoIlX0btF0RxSmrklCkt92FgPGSyiPIHErbnXM0sEDgbs3Rz3EG3uewDCj3SaiGosfNvW+LJPR1KiZoRXQEonidVJQ0u+fsKCUxNskbhhuonYjBnRDHveyC0POTaHmv23HpFBPGhxlS8Dox+jTvYIwKsZSBUMKOajPAfnjZ985vswFR+KiV3zpzdYIHsoxpRPZOSjQJ6tTXvaKIHR3CSY/n34E9vf+cy4vUpkUFCZI+Ho7fVc2xfKQ5GihVx02ScK7yIvk1mxHjIT3G74rdQcMePB9uPo4JEhm5jE0V500O0Ya08p/0fBVWs6Fw7atzhUJBnajnYbYzzxXDGF1eZ2wTztAXjmvGB6qJqeeKmApFY5dnyG6G5rH+tAKNE1ZxVC621AGywrWEBEh6XwxsbnJUR7
 CxpgiPK8
 64NUPV1cm48yMeiFGOewaAiMcvVbqPCAWMlijWc/x+aJqcXYTA8UqPQJizMgGC+Q5JbsMQuQCJ312wvFMB/3HXlGHH43EWnq77SGUXODzlbbIksvng/CQMMOKWQs5C+Px/Yt2KXQL8JD8HGWhSJtLX7+OhIdJHWTnuBKijZQmhHQ6JbhBIz5J194bg+0UKP2JwhGawBnAXcQsNw1iGThztr9Z/QexKoWPvuLq+brn5ye2LafQvnBm5ybe2nIO+CASZbZCumcXPTnroLae0uocLZAI881flIDst+zYmYS9byIZfXlhG5nuubwQQNcRyREXP8TVOFIHaAJ7Ou5zPd3AmCEyKAZUCOLpqDfjK87uvdd8naK55M6V8UYjmHkWkB21aHbDsG2Q1QDpYilhb/BIGgFwe2JlB2TzMt65ZJcnISY4rJjH4DUvbf60c4RmB4nnt3GsGJFy8gDGZE8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 05-09-25 16:18:43, Jinjiang Tu wrote:
> 
> 在 2025/9/5 16:08, Michal Hocko 写道:
> > On Fri 05-09-25 09:56:03, Jinjiang Tu wrote:
> > > 在 2025/9/4 22:25, Michal Hocko 写道:
> > > > On Thu 04-09-25 21:44:31, Jinjiang Tu wrote:
> > > > > out_of_memory() selects tasks without considering mempolicy. Assuming a
> > > > > cpu-less NUMA Node, ordinary process that don't set mempolicy don't
> > > > > allocate memory from this cpu-less Node, unless other NUMA Nodes are below
> > > > > low watermark. If a task binds to this cpu-less Node and triggers OOM, many
> > > > > tasks may be killed wrongly that don't occupy memory from this Node.
> > > > I can see how a miconfigured task that binds _only_ to memoryless nodes
> > > > should be killed but this is not what the patch does, right?  Could you
> > > > tell us more about the specific situation?
> > > We have some cpu-less NUMA Nodes, the memory are hotpluged in, and the zone
> > > is configured as ZONE_MOVABLE to guarantee these used memory can be migrated when
> > > we want to offline the NUMA Node.
> > > 
> > > Generally tasks doesn't configure any mempolicy and use the default mempolicy, i.e.
> > > allocate from NUMA Node where the task is running on, and fallback to other NUMA Nodes
> > > when the local NUMA Node is below low watermark.As a result, these cpu-less NUMA Nodes
> > > won't be allocated until the NUMA Nodes with cpus are with low memory. However, These
> > > cpu-less NUMA Nodes are configured as ZONE_MOVABLE, can't be used by kernel allocation,
> > > leading to OOM with large amount of MOVABLE memory.
> > Right, this is a fundamental constrain of movable zones. They cannot
> > satisfy non-movable allocations and you can get OOM for those requests
> > even if there is plenty of movable memory available. This is no
> > different from highmem systems and kernel allocations.
> > 
> > > To avoid it, we make some tasks binds to these cpu-less NUMA Nodes to use these memory.
> > > When these tasks trigger OOM, tasks that don't use these cpu-less NUMA Nodes may be killed
> > > according to rss.Even worse, after one task is killed, the allocating task find there is
> > > still no memory, triggers OOM again and kills another wrong task.
> > Let's see whether I follow you here. So you are binding some tasks to movable
> > nodes only and if their allocation fails you want to kill that task
> > rather than invoking mempolicy OOM killer as that could kill tasks
> > which are not constrained to movable nodes, right?
> 
> Yes. It't difficult to kill tasks that use movable nodes memory, because we have
> no information of per-numa rss of each task. So, kill current task is the simplest way
> to avoid killing wrongly.

There were attempts to make the oom killer cpuset aware. This would
allow to constrain the oom killer to a cpuset for which we cannot
satisfy the allocation for. I do not remember details why this reach
meargable state. Have you considered something like that as an option?
-- 
Michal Hocko
SUSE Labs

