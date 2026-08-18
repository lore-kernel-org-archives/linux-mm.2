Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D49C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 17:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B2C6B027B; Tue, 18 Aug 2026 13:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F39A6B04AF; Tue, 18 Aug 2026 13:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A496B0743; Tue, 18 Aug 2026 12:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D0E356B027B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:59:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E5BDA0247
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:59:59 +0000 (UTC)
X-FDA: 85115002518.02.294BB12
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf22.hostedemail.com (Postfix) with ESMTP id CB5A0C000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 16:59:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hTjyAQZ5;
	spf=pass (imf22.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787072396;
	b=22BO0Pfv3JAiiUqe+Rew5IW5/3dC2roWzlzX1PqgEC5ZAz6tjILhzyK0sEqnstHiRIlWmy
	VXY5wgD8kECeyECbLDFyUmqr/r1ax7sHOhYUNV1VPHo3cbaFvwXOpZemuyiY97iXS8yCZm
	dSZvUTAAe3VPX06dWVguFjBmC1TF9AY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=hTjyAQZ5;
	spf=pass (imf22.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787072396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjhuD+7fHMoacORpzwa+v4G/gOBUrswHbm+lgOme158=;
	b=WZRo3OorZfljEhawZ9DgN5etok6/OfH+eJ7zN18lDoplDRz6eSh+cQcYhRjefq/e+lqBxl
	qqdt+RnvcRyb9XxsoJ13S+kK6fxft13yCJcvyYFRAlyOibEKqnYbrKydw9EQzzGu2R0/l2
	+l4rYgX/4pHUpSPgCJRlgDxDWhLQZL0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1787071733;
	bh=hjhuD+7fHMoacORpzwa+v4G/gOBUrswHbm+lgOme158=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=hTjyAQZ5wY8qRTt/Xh7TTvHKkJecAjz1LYJrlmFU2BBVR8nAdGDCfM7A785vhWnoc
	 iE8bvWWGtj6/lhtv1mrf1cHM+RCINhw74H5Iqu8EOK5uGEJC2p2tRbfA9PNmLB9ltj
	 4kaH+jkwbD8e6XmF9Zk7WEpKKTjgNxHnZsxeSKeM=
Received: by gentwo.org (Postfix, from userid 1003)
	id 1E4C2402B1; Tue, 18 Aug 2026 09:48:53 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 1B11B40293;
	Tue, 18 Aug 2026 09:48:53 -0700 (PDT)
Date: Tue, 18 Aug 2026 09:48:53 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
cc: Will Deacon <will@kernel.org>, 
    Linus Torvalds <torvalds@linux-foundation.org>, 
    "David Hildenbrand (Arm)" <david@kernel.org>, 
    Mark Rutland <mark.rutland@arm.com>, 
    Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, akpm@linux-foundation.org, 
    hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
    linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
    linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <anTCM94KoxY2nRaf@lucifer>
Message-ID: <5fdbc331-8067-a0b1-6a66-5be9226a3f15@gentwo.org>
References: <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3> <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org> <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org> <anHuLy52o5S9Nlwp@lucifer>
 <CAHk-=wgJ0wO=T+1G5zJwoeE-N4bAptCNo2TFirK364iPhnGG6A@mail.gmail.com> <dadd8268-3cef-3a3a-e277-b593bef3b788@gentwo.org> <CAHk-=wha5um2rB9u7EDeEhZJyaWOUFye-wTKzsykQqJH41RNdw@mail.gmail.com> <anIXr4Kbn59Ac31Y@lucifer> <anTBN7WzVZukl26p@willie-the-truck>
 <anTCM94KoxY2nRaf@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: CB5A0C000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ect3jcgsg5kdxpct51bpthi15z4511ao
X-HE-Tag: 1787072396-649171
X-HE-Meta: U2FsdGVkX1+J/PVsVQ4B/dPd3WWk747h1SH8TbgQh4fIrKC4x3QUf9s7eXu48fBq5AuVll7vIwdBy1XL1MAh3eRKORCt/sS7AONS+loMkXpB6s6f1YJHdVHfDJL482V5T+KEp8yZoxSpL5Jn6rliGjTeNXniNgt1ZTCmm6+GpZ/1+nc6Iwcgj0Fx+8HZhxAlV7M8CUxUYFQnuZ+Y/5uZL8qTFD4v5Oot6jXYsip9ZYgru3YZK/nhGBIW8YRvZTnfRrFKBIPwtC0h510RI0A7y5ljvMqO82vZsdaLt+YHOThm80Bq3H5GKMmiGokmNsxJfZAlOMJ5hdGY8Qe91/1Ho91pJl4m/iPTYOfgx4t0IAH72CwgXvKTfHQLRcW0MlZ1L4Ma/tPzzpHJW/XJ8EkPYoFwcdghLXtlmFB/58wqSsOB8O0DRmtj61Nxz1/FDx/w3PG80hDmec4WAeOTb1EiNFPMbKz+qqdpibkagdtb2rB1x7QTi3vVWyKnKeafJ7CVjYexgSxDJmFsDNfkqTIJoRBsmFfToPqsGlo+1kV/0O3XgWRS0CWOWC9DzPvuu/k4BVWwm5xEF3Z0GhhCWdjA6u+tKX6KS5kAMPs2raXJok3W8EUD7Dwe+UwQ1hUEtfrOQPCEoQ24TNxPoA1oBKOZzIXMGSypj7qXUpTs2ZTAqq9kHvzhe1bha1QwjDwmHsRYULzoX+8XhCF+WbQaxvAXVCIPaqyLXuGUlJj1RoodvMoUZ8uZbUDYh6TOGriXmOQY4UVy2a+c77rea/dCXT3umOzVP4hI16dzcuY2xleiov8M1CauiScBWqoTjfeckWvPHU5cffmtb1zJGNeDxW660yfQPh2Mq6k3nNj+Q3LexPAtd75vFmLE3x7a10EfatqjxyMqnnZf2fojJ5l8+gyuqdUGcktvmYV4aeglrvxPCvTuh/aTUNOpTXa2/xvSd0PlirbY3QFa1PNTa7yg5Ks
 onS82W0u
 Yvmcml1jELlN2Xsgq82FFc7c3niNqLj1aZ2sLAdeChXWrfL04m/p/9WyuyQkYpBFb7a1wFhPC1u5WhWrtd7rGbpXjFWLSjdlUbMEnopbzoLJNJB4Z4n2+PWTg62eBqmbDq1r6rQFyIUh/8PVCnKQvaWvJ8wE9sq1m/ud/w+ykn0iOiWfWZOGvcLpiOR9UPf3OwIR7nI5fjXKvEq2VxzhrH1VTxr8B5BZRryTXmX3SbGbwo0+hSGmmhENeB/ylz9zPE8f9NxRV2L6/TVfYehF5c9Ng4Puekt6ajUpeSzozC2uPp5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026, Lorenzo Stoakes (ARM) wrote:

> On Thu, Aug 06, 2026 at 06:15:35PM +0100, Will Deacon wrote:
> > So the nice thing about having two implementations (i.e. the per-cpu
> > page-tables *and* the preemption stuff from Mark) is that we can pitch
> > them against each other to help us make a decision.
>
> Yes exactly :)
>
> This point has been put to the submitters a number of times so I hope that
> an additional repetition from an arm64 maintainer helps underline it.
>
> >
> > However, I don't see how anybody could argue that Mark's series isn't
> > cleaner and easier to maintain.
>
> I completely agree.

Changing a register used by code sometimes in a timer interrupt is
cleaner than accessing a virtually mapped address?

A simple RMV instruction is simpler and cleaner than prefixing a code
sequence with flags on how to modify registers if something happens like a
timer interrupt.

> Let's hope sanity prevails.

I sure hope so. But there is the ingroup behavior that rationalizes the
wildest approaches as sane.

> > seriously want to consider the per-cpu page-table approach on arm64, the
> > numbers need to be _really_ good and across a variety of hardware, not
> > just the stuff with a memory system made of baling twine. That extends
> > to the kernel text replication efforts too.
>
> Thanks, and equally so for the core mm changes that are required by the
> page table approach (that requirement being attested to by the diffstat).

The numbers are already approaching 20% and will go much higher because
there is more potential here with the ability to localize various memory
accesses in the future.

Scaling to large core counts requires the reduction of traffic on the
fabric connecting the cores. And the per cpu page tables allow that to
happen and scale to high core counts while minimizing traffc.

If you keep on with your hacky approach of changing registers in the tick
then we wont be getting there. We may have entirely new classes of bugs
because now the timer interrupts changes some registers. Think of the
hacking potential. Wow.

Please stop the madness.

