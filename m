Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C3ACD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:09:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82FE6B0005; Fri, 15 May 2026 13:09:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A466B0088; Fri, 15 May 2026 13:09:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B70796B008C; Fri, 15 May 2026 13:09:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A05B16B0005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:09:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 405171C0060
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:09:25 +0000 (UTC)
X-FDA: 84770290290.17.4DC510B
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4DBCEC0015
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:09:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/kZ4iVB";
	spf=pass (imf22.hostedemail.com: domain of 3QVMHaggKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3QVMHaggKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778864963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4j+Q0zH3Q5kFFK5vsy53vLNdCIJ/Ym2kWbS4XlUAWKY=;
	b=LxyRbw1QI4gKuaveqw46HBan8ALpKydBVVE/W9pAWg7EndwmA6X0jc6d5EQuoz4qco2Mcj
	4aufZVWCgzkvasDvBOsNpfOesla+jKKar48iCSWGjCFUPOW/Us8NUEHBjAlsjN4py1mQI2
	SuuFcK1D9Zg4vuPoGxT8DCHp+wwU4WE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="T/kZ4iVB";
	spf=pass (imf22.hostedemail.com: domain of 3QVMHaggKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3QVMHaggKCFwD46EG4H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778864963; a=rsa-sha256;
	cv=none;
	b=WozRZY0P1bFB2PJ5aQpGK75giKh0lKQMjvlrrYgJtyRMhvInOwxuD8rvtPRIoljfAygF9F
	8CPzL71st24veQaH1tcxZK6wdHACl5x0GqM5snU1QawFQc/2lswZJY1DIaI29vGHB27Viv
	OoCLy5MsWDnPcHO2KU6bQ+j92Y8frRk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48eb0da933fso1159685e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 10:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778864962; x=1779469762; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4j+Q0zH3Q5kFFK5vsy53vLNdCIJ/Ym2kWbS4XlUAWKY=;
        b=T/kZ4iVB1lr4TKV9KzHKASdhlIYwg4j4BXjZ9Fy7lE90tI78GOFt0cxUzDSrfS/8ZX
         NDj8JTUvFvGCWYmKGav8n90SIr673CU0pF0i9MSrf9LW4J+QpTW3eJ5/v7v3jfJT4wZE
         21Nk+pAbiLuBqqIrqCZbbjG5gIjbmndUcBy3cJSMqHc52ilVENhu23O5AN8edD5jt+XI
         SwRpNb+i2rJQalB/tJRFz4SRTC+cdirgH8NykV81yosiEJJ5VY+8GxOdxHuwy1TWgpub
         7CPfpgPUGqj6XaajRs/RyDumZJb9MT7AgHbWlau3EAHSm1GIE/wwgTw50u4fuygfpUfx
         m8Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778864962; x=1779469762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4j+Q0zH3Q5kFFK5vsy53vLNdCIJ/Ym2kWbS4XlUAWKY=;
        b=JDCuie1Px8E/xb3TajmGYQcEClauqv1PPgCbVoxhrpupqPol5lrjNSzYRLSzb/PnAW
         9XtvSYjFEVPXJKKxCNPxB1z39xfUs85m3Q4zAtVRlDRVNfc7UEwruzB/ZkLsWwtMvmZL
         LMa9kZzfZv4ZvpUfGIjltB3qdWFiut4zK9Yr2cz0V2h4WomYinT/OE4M9XSvuGeih4ip
         yPuVI15VUOrpR27Hjzj0+OzfseYLSYZtToHbA9PDJ+Dga29jRGskQt1XjHhmkOkcJ+xv
         Nc+U5NpiLIzfhOxDlKX4go5U81+oRcZeWP/0liuUg+Fo0x2I+RBQEF7F1HVUI9EM6Njh
         7lQg==
X-Gm-Message-State: AOJu0Yz7a+JeWCuCuB4GvrFvoel7M9C8PACbk/21bF8TCaTv0L4Xjzyh
	eEmnRKhw2dGEhjTx4MFiS/SpycONtYjlINYh4yACAhSocqWpCpfJxZ8MuahYLWdLWwQfVPmXX5i
	y2I2DH784ObbMpw==
X-Received: from wmbb25.prod.google.com ([2002:a05:600c:5899:b0:48a:93d2:60ec])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e47:b0:48e:707f:cdfd with SMTP id 5b1f17b1804b1-48fe60e54f4mr75054275e9.2.1778864961620;
 Fri, 15 May 2026 10:09:21 -0700 (PDT)
Date: Fri, 15 May 2026 17:09:21 +0000
In-Reply-To: <agdAZQ4sEdGItwc2@gourry-fedora-PF4VCD3F>
Mime-Version: 1.0
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F> <DIJ5IBGSO0OC.1S6AARO01CD6T@google.com>
 <agdAZQ4sEdGItwc2@gourry-fedora-PF4VCD3F>
X-Mailer: aerc 0.21.0
Message-ID: <DIJF01KNX2V6.23MF18D4X99EX@google.com>
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
From: Brendan Jackman <jackmanb@google.com>
To: Gregory Price <gourry@gourry.net>, Brendan Jackman <jackmanb@google.com>
Cc: <linux-mm@kvack.org>, <kernel-team@meta.com>, <vishal.l.verma@intel.com>, 
	<ira.weiny@intel.com>, <dan.j.williams@intel.com>, <longman@redhat.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <lorenzo.stoakes@oracle.com>, 
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, <osalvador@suse.de>, <ziy@nvidia.com>, 
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, 
	<byungchul@sk.com>, <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>, 
	<axelrasmussen@google.com>, <yuanchu@google.com>, <weixugc@google.com>, 
	<yury.norov@gmail.com>, <linux@rasmusvillemoes.dk>, <mhiramat@kernel.org>, 
	<mathieu.desnoyers@efficios.com>, <tj@kernel.org>, <hannes@cmpxchg.org>, 
	<mkoutny@suse.com>, <sj@kernel.org>, <baolin.wang@linux.alibaba.com>, 
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>, 
	<baohua@kernel.org>, <lance.yang@linux.dev>, <muchun.song@linux.dev>, 
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <jannh@google.com>, 
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>, <pfalcato@suse.de>, 
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <riel@surriel.com>, 
	<harry.yoo@oracle.com>, <cl@gentwo.org>, <roman.gushchin@linux.dev>, 
	<chrisl@kernel.org>, <kasong@tencent.com>, <shikemeng@huaweicloud.com>, 
	<nphamcs@gmail.com>, <bhe@redhat.com>, <zhengqi.arch@bytedance.com>, 
	<terry.bowman@amd.com>, <owner-linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DBCEC0015
X-Stat-Signature: jh47q9z8wym3pgswt9qrijmfk37wfuhn
X-HE-Tag: 1778864963-734374
X-HE-Meta: U2FsdGVkX18R/zhEOLZRKp2ShWIivZoR3cVTY0WP+MiyntNUV/3owoF5Tm6yOC7Lp054XfnTGKHMC6AWzz6X34n/tozPjwJKCn1aaAx6BIvxvyEqtMaP46PfYvbnk933+ap7CDrCsWe5r/24iJpuvKRHwlCxP/yzIUvdwnFfw4DMVTHDXvNl/V9wEnkInZ2edWD+ybDQ0MeyilKOwlQRSLvZqVlpZfxsMlEI3dC5tyHWF+SDcb53vpE0hYexWyv6lLbTgxKdV5DO9CI6hZwnEtBzEE5jAsxhI5XIe8Ov0RZARsh5fAks5z/FeldnVOHYsZSR+baAS5+Zl5pNOcvzEeL9MFXAy80/Lgw1az1Jl8dgZW48Txpq/bcsgnShGRBwBltMjbM9KWmdKIrkzHmSiz29yQ4fstPj8cjZ0+Bfe+x5Prk8ajL0VWyP3N9WQknWnJmrEpVK2+Ac3TNhzJN6fJqDM6TAENie8EbnFWr9g/zHJ/+HuC/V8nO9drm3zw8CcHeyD8Wgr3rKsSWdHydhsMnSe90RvjDQoR2QTphORE0P73vgblIM6HOBZkrMo79JnsizZpFzy7oC4AHkolzZK8I8C4mpCyOC9bt9p0+s+iBDSRxW8rX6rX49umpd+sqNWxRRN+cEldLnz/mHpggVCFtzj667YQ2vOafyWmi4uAwS0X2eSWFoYFZVZfP1PLwZm8jKY6whf9WOndNUOa6dnY0LPOm9EbKmBDwQuZogBrYJRbivISPuVYKUJVmqHVeu+BTG10J5Mug1J3+fvXGitJt11i4KU27kk1A+G05bYB+nlGmk+vlLY9NIlAtlEovu++gCOz+PV+9rLrcfHX/JEmp8jeLpsKmeYqPlD/ewal5VKBfPyPz0DuLseT/24t5JTbMWwca6dFrCz3R4TK0zSuBcxMq0pyE0cBknaRHPr0ky/93UYduaOvU+n05Pi2QHdCOgBSXSYWwbl5Eaty7
 nW3kklzo
 dhEbhgjbKK+Xq5d3DfNvTm4vebyugHI2Nt+xZBmS6Ek+qSV7rBYegXIqFgmFYlFVRrQtQ7Jw2PP+dKNEz90VMHMeZKEQU5IK2JG//FdGgs/hxEwl0Xy9VjsZx35jNYmSWljok/OmbBPQCKckjbNR4DLeloBfboJKx5ogg/kY8SOp2S1jORCGj3LDeTzq3NuWk1uCHKPL+L2BLmZNnvxOU3eFC+GdGeb49S2rImdzBwBXpxbz/r6ichugLx/0IcSYpgnSEdhN9uCpJPRzhGGC+ZLoePiQS09hNxfgaamr2j0e7P98TFLPdkFFFIlCbCCObuUebXjj+q1upTi1eiQpyRIiMvLIDrOZIX6CwEmRCWQIeoKg6URvDPfbcBTB7H2/UwP7rZncyGbvi3ILp6eUSG4Io9QVrXgJc8XvhYKPXcqdYWFURVOgrYgKxBRWYOPH0ZFB5M08NG0AXW/d6E+BDVFQ7NHiK1bTl09j9nKz1o5lMVy76lDSL2wrmO9MSDPI2oLFsNT3y3r+2JYW4bAzDU49NkGCG6nTA7CZVKTDKy32aNq26diic0VnNzYgAPuYoGhjoSOcwSCLaVEGiscnzAjHO8yH884CsvsFcicH+RulQ+TnIUDF/DXB4V0Nh4lcBomX3xISqDjIvoN2xyV7+iDEAKP7tZsaLUMsYU5FvYt1cqXOhd+CAV8UbAJZjwReaAn37BDIEz4yVOxJoaKpXUsFHLDOifSgEwBTGYTgZi+9u72MfzxaJZbhd3BrDTBD6C+74mmdn8thDG7/mKB6oAilFZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri May 15, 2026 at 3:48 PM UTC, Gregory Price wrote:
> On Fri, May 15, 2026 at 09:43:02AM +0000, Brendan Jackman wrote:
>> 
>> Yeah, I have had a similar thought before. In fact, I wonder if we could
>> have a pointer in there that effectively allows you to replace
>> NODE_DATA? I think that would be a more general mechanism to achieve
>> that `managed_node` thing?
>>
>
> Well, alloc_context already contains a nodemask.  I could see even
> pulling that argument into the struct if we seriously consider exporting
> alloc_context.
>
> I'll have to think about the NODE_DATA replacement.  I don't know if
> that's really feasible consider that this structure is used statically
> all over the kernel for runtime node-data lookups from pages/folios.

Oh yeah I wasn't thinking of replacing it completely, more that the
global NODE_DATA is the "default" node data (and the pointer field being
NULL would probably mean to use that), but then private node datas could
also exist.

>> My original motive for that was: if we could get the allocator to stop
>> [unconditionally] mutating global variables it would make it easier to
>> test.
>> 
>
> Can you expand on this a bit more?
> What globals are you referred to exactly?

IIRC it's just a few, the vast majority of the global mutable state is
ultimately downstream of NODE_DATA, plus there are some tuning knobs.

> There has been a desire on our side (Meta) to make mm/ more testable in
> general (for both performance and correctness) - include page_alloc.c
>
> But with everything so tightly coupled the best we can presently do is
> runtime testing of benchmarks and workloads.
>
> The same issue exists for things like LRU/MGLRU, where you can't really
> isolate a change because you get emergent properties.

Yeah basically just this; if you try to write a test that constructs
some specific condition to try and hit the nastiest possible fallback
case, you are racing against the real system. Ditto if you wanna check
your code against page_group_by_mobility_disabled=1, well you'd better
figure out a way to actually boot a whole system with that property.

I spent a few days trying to solve this in the way that VMA and xarray
etc have, i.e. by making the page allocator a library and then testing
it from userspace. I think that would work but it needs much more than a
few days to make it happen (admittedly, I had tried to do this with AI
at the time and it failed miserably. Maybe with today's models it would
work, which could massively accelerate the grunt work of e.g. splitting
stuff into new files).

But anyway, if you could carve out a distinct node data etc you could just
write KUnit tests that operate on a completely isolated "instance" of
the allocator, even though it still runs in a real kernel.

