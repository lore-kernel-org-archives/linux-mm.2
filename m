Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57937CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 19:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EEF76B0005; Wed, 10 Jun 2026 15:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49FDA6B0088; Wed, 10 Jun 2026 15:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B5966B008C; Wed, 10 Jun 2026 15:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0086B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:38:40 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C2BD5120283
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:38:39 +0000 (UTC)
X-FDA: 84865015158.18.1D37473
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50E4980009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:38:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNkgL23Y;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781120318;
	b=Zs1UHOvU/Xa8dPYluCpL6ak5aFJzwEcYsUk3oq4SWWsgXjtR+msgLDE6x81gQnB8zrU8Cz
	yNReO1U3LaQYoODD6B3DHuUMW0PB4seHe7VBiIOXFipXkSW3lDboEn8MM8ETglVBCG/8DE
	RvWfFq1kJqm4faNa17f0YwLexMf7JI4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MNkgL23Y;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781120318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlqXfjmgJLP/Q6k6kAvLcMiBTA3fQFMIe/Jy/ZMH6YY=;
	b=GCzSG54cWkraoGgxjY1q1gWV+50svVh4M/aI0g4oRpdh6sENdHDg1q5mGpaOw7jkCWCp9X
	UrNkvZQg5ylFY+MgJK+a3qQ5qXlPGudR+6Ymqsuiak2h8zsCldDhOgpx6nUoTZ1R0dG2pa
	NbfMjoYK+tYfO1G9LlkP3dkQYTmZI04=
Date: Wed, 10 Jun 2026 12:38:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781120311;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NlqXfjmgJLP/Q6k6kAvLcMiBTA3fQFMIe/Jy/ZMH6YY=;
	b=MNkgL23YGeQs7rdqJ/NzOA1ozu1wl7Gki/fXyrtzOFf0AN4RNNuWsTzbOH/GeE6KBpRGnV
	pLqAUiPCEabrG1q+3xcmO2u6AqNjiIRcj6S91RWnhPUak7RKpy/MFyh/K2Av0p04RczBX0
	N/LgJqjNapYS99MxamG+tyqk5sa1xGw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	willy@infradead.org, usama.arif@linux.dev, akpm@linux-foundation.org, 
	vbabka@kernel.org, mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chrisl@kernel.org, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/lruvec: trace LRU add drains and drain-all queuing
Message-ID: <aim8zKzCH7p-6v1h@linux.dev>
References: <20260609041156.31127-1-jp.kobryn@linux.dev>
 <CAGsJ_4xk2Q3xTkQYMPb7rnvnvVsjp24uXRcOja5RxqSbQpdoEg@mail.gmail.com>
 <3e55e520-b979-4b1c-874c-3b4e5ca629e2@linux.dev>
 <d676cf78-4b0a-4d6b-b322-f64826aaca75@linux.dev>
 <aii7WWFmAyoXn9rk@linux.dev>
 <6e7739cc-327e-4ca9-86f4-17729b624632@linux.dev>
 <ffdf9b07-487b-4668-a91b-27b0ab29c70d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ffdf9b07-487b-4668-a91b-27b0ab29c70d@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50E4980009
X-Rspam-User: 
X-Stat-Signature: 5dymg6as38r8xa38ucfuamcpcpng4dr1
X-HE-Tag: 1781120316-341397
X-HE-Meta: U2FsdGVkX19xdRSeKs2KgaJ82y7zRvXv9dbwy20l6fBCPhPNtyJrG6jvIFIItmJfms0uUKJZ1hLel+Ib3PH/CKdHI91PT1hoXLXPo81TSLgsCWqlwS8IZB460hwJ3EFo3+FbaKX00RansoxYu0krdEBSl3yw8+A7LjlFma8lTXKGkbvu711bv6/kN68Zl4x7hFWryYq9NY6+AJlMfNXwqBZzeo9V7g3j8d+fWWI6Xnfjr/alLKc/uDsTIQZnScyrYKta4CXmid8PHqA48eyNEJvz8HVx7celKWVMNG974JJFRzi7sixLiQKKDUp9WAIUNOCs+CMGOfQLW6xlHK1ju8nskUn3Re2GWx8yWCZJMQn1Uj83q+WoAcRGXcb6OAphs8I246RsFY6aTWJA2KD2fhkHfiQSSK9L8nDvnU1HvWY7YqR5BaDWUFY3ew8kAKcKsMaPyzY4z5eXwsCPG+izMZd7yPcrKjv9OcB/SIzu9vIIPqIhVVUdPmezPfc+Xdti1vkDG2BL9fJAj6F5hlMoy+cZGflX0my/V1UXzTkufzyUK0hmVKoxD0DCh8zTWbxeJ4Ja2Eq7vnttANudpBOHz+bbO4LrLRCRfv6Z5vIThGVo4dZGdS8u91/xTUe9DJ1lcgOQHqlhj1Lm9QGXIAVcvP7NUKTcwaJkjh7jrHYy6irjwbEMaK1BASVxCAHSYC/Kitg+GsgUBD61lFuF/1XtnnC1wh/ijDYndfrG5ku97ptOQfA2dZUDi81yAk25T8nJPanPPtOHMIlNDWPAKcxL+Q/teWBurpa/GJZQZ5m50HQFRqBxNx9ODLK82r+JRnV/Uuw1yUFyjVUw6a4MYRv0Ozo2NGgBeFRFdnOzhp+dVd+1+0ZRqNE16dZMhcNXbIQxzOQLQRJRnmcuLGkrbXRjuAABF+bgOgwFBPit+2emrbzbR7LUchM2KCDMJJqSB8Cqexe8YewFSkkFF+kCjEC
 JX1anddw
 5lPIy6Xw9yEeKuFHlNSYHWLTzwAlaQyaea1eOEvqtA15XQWgv7RXced9C6SEyerTMgTOHhQ9EF5ZWGj2xzoZ2mS7CoXk1/mzzS8z1zpy1Wg0pHGkHFq9/9RSQjABealrCkpQFJ+4U2M1G0jD1kTsgNmlrN++o47enWDnPePO0YeaQ1tjcGxxFpvrJKMHwTFDkCp+Gt/PWycR18ohyjS15JiHmTs/wjgfT/+NMIWmNAfTwbIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 12:20:19PM -0700, JP Kobryn wrote:
> On 6/10/26 11:54 AM, JP Kobryn wrote:
> > On 6/9/26 6:21 PM, Shakeel Butt wrote:
> >> On Tue, Jun 09, 2026 at 05:16:15PM -0700, JP Kobryn wrote:
> >>> On 6/9/26 5:07 PM, JP Kobryn wrote:
> >>>> On 6/9/26 12:44 AM, Barry Song wrote:
> >>>>> On Tue, Jun 9, 2026 at 12:12 PM JP Kobryn <jp.kobryn@linux.dev> wrote:
> >>>>>>

[...]

> >>>>> Do you need tracing on each CPU individually, or is tracing the
> >>>>> entire __lru_add_drain_all() invocation sufficient?
> >>>>
> >>>> I think the latter would be fine. The remote work will invoke the
> >>>> mm_lru_add_drain tracepoint, which will show up as kworker stacks. Since
> >>>> the event already has the CPU, we could see where queued drains actually
> >>>> ran.
> >>>
> >>> Actually if it's just a single invocation and the only event data is the
> >>> force flag, a tracepoint may not even be needed. Other probes can be
> >>> installed on function invocation and read the single argument. I can
> >>> drop this from v2 and keep the single mm_lru_add_drain tracepoint.
> >>
> >> No we do want to trace the callers requesting to drain from all the CPUs. If you
> >> trace just lru_add_drain_cpu() then you will only see that the drain is
> >> requested for a given CPU but no information on the requester. 
> >>
> >> Also as Barry said, I think single trace for whole __lru_add_drain_all() is good
> >> enough.
> > 
> > Right, but couldn't that already be done with fentry or kprobe? If we
> > only need the calling stack and the argument value of force_all_cpus I
> > don't see a strong need for a dedicated tracepoint.
> 
> Nevermind that. I see it's declared inline so I'll add a tracepoint and
> send v3.

Thanks. BTW even without inline keyword, compiler can still decide to inline
a function, so kprobe/fentry are not always reliable.
> 

