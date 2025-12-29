Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 189B3D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 10:54:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628916B0088; Mon, 29 Dec 2025 05:54:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E87E6B0089; Mon, 29 Dec 2025 05:54:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB276B008A; Mon, 29 Dec 2025 05:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 419866B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 05:54:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E77CBE999
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:54:38 +0000 (UTC)
X-FDA: 84272200236.19.3CE780B
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 378EC40002
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:54:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Xl3mYaqY;
	spf=pass (imf04.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767005676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yJlbbI284/D8x4Ik/0uEnuc7Flo2SmmRKYLOMZleia0=;
	b=M6BFVB1nz3EPmFCYx+UX98BUGEE3AKnxzG4YkjYyqlcDysO6asP3Si9n/Mc0KZVZKlEMdU
	3wSMpeoiEnQj0u6Y3GaEhYwGmSW/IuHSOql/+837hn2kekJNmda1esgIs6fG+/BXDVxYdH
	RinHuLGl/m++wk+RF9dWGlQ1ELx5HdY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767005676; a=rsa-sha256;
	cv=none;
	b=m/Rv6nD6AsList5CCPK/zxN6OsNeyGigkncyUXJwujHcABffeHIcLYq2Wj2P8hUYixIp+y
	VWl0V8ogYk2i+u1/Kw3QjUVWcGRt8gASuJk/vBSQHoBtVbGICGXE6neHor6fHJKLnqbqQm
	Xhw18DWXhCCHzpbeLmfA25be8XUcAQ4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=Xl3mYaqY;
	spf=pass (imf04.hostedemail.com: domain of tballasi@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=tballasi@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
Received: from LAPTOP-U3CCR7C6.corp.microsoft.com (unknown [108.143.43.187])
	by linux.microsoft.com (Postfix) with ESMTPSA id DC65A200D65A;
	Mon, 29 Dec 2025 02:54:32 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DC65A200D65A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1767005674;
	bh=yJlbbI284/D8x4Ik/0uEnuc7Flo2SmmRKYLOMZleia0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xl3mYaqYJ2gM2xqPep/sY7XF3o6JNO92pGmbiB4Cd1QxH5OUhy7TDzMPHxs8udkH2
	 /ezSr32QYnhPLslrzhFOzyQKS7lwx3naEcyU0blqMwJe/JYk3aQ2GUSQc+jfey3890
	 37ZsECY9rpop0J7J8gL5LTc5OZLPB+C7pUxIq2jc=
From: Thomas Ballasi <tballasi@linux.microsoft.com>
To: rostedt@goodmis.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	mhiramat@kernel.org,
	tballasi@linux.microsoft.com
Subject: Re: [PATCH v2 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Date: Mon, 29 Dec 2025 02:54:27 -0800
Message-Id: <20251229105427.14720-1-tballasi@linux.microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251216130302.5202ca81@gandalf.local.home>
References: <20251216130302.5202ca81@gandalf.local.home>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9isum93jo6txud9cww73iyphc71b3ky6
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 378EC40002
X-Rspam-User: 
X-HE-Tag: 1767005676-151798
X-HE-Meta: U2FsdGVkX1+OCDFPdKmJbkLvu+bW6mtm1r9Gu8MJj8CfAP5InPIN8F0tkNi2JX0a/h8GIWZ41ey77k65uE2rQd6AYj4JABzBZ6m05Li12/upJgvYFf8zAh6oSvVYMzHeizROrr2pKJ18oB9RGUoIKNoK1Z9r3tW5I0EQeDRiv4If/bAmtDmdVP6ssuuDD+ncQ8OQHejErMkbPIyt/cxqrW7bdUQYoy5Gaiu9QnzxNDjXMNdZp1uPMiRpHFRAWXa2S4pmClrDE/AfkGTeHweRl0SvPj4pcUBpGeatKjaKwpUna0+xyN1HsiUwQbt/eKdBJKzt1SCWsYWwUPe8Nx5kMHGk5TGK5OcIohvm8n9sPbAuPQo3x731tu1MUmwokOfyjGgHD7gAG9CCYJMCrRY7pDWZuuvO7ti7dig2aU8uIrBH2X1mHce1x6S9Gas+KiwB9M58/gutcI7Z6d/m/Ph8gdF+hR6MY3RG53wPhEBluDAk8VySefm4hHM9g4YN5bbO3rQ0aIJ9UA6Qo+4Rc2sZt2a2LGSzWbFn/A2r1U73G7sXpeSSk9+PcQNsJCTHf7piZUWCOqluo96WXce9OgOKIHL2eygcAAn9UnLPgoNN8QZgGxHT6M3xwAQMY11g22Ky6QhhLyW6mxpiTCAx6DvDdkSvxF0zdJdmAEqjkc951eDhrjKTSELpV7GlAQsrKFPzugclE5RYHRDSjbWKNqpnQ9iA3y3HpII1wO951ttOQVVa+xLkYb3MjE+njPnzoUN4dKHb6+bZjYJ+qtqcKlFWlKBjhZGWWsg//GCM0RliWh66VHoHna85pS3FPqk3uYFLrTUYyRWzPFNukbbESCfdvQAf68+vonNjhbRoZgmdfyj4E+8+BmURX9NbGUJcG8cqP9t9wThQ6oOXcXkA/nBsj7UC2EYrXBpmSbVM7OV+4nUSTrw+idmA3cJUIplMN/i+dPImgFvfoX3ZICq1BaV
 f7TawOKn
 0JAXq9uQQe9jSE29WsdqGNcsXejGjp39LyejObpwIQ804nm5RGTd5u2xhs2X8ef3tj8PiJ8UGSxHegi5yzL+2QCvuzmRQOUrDld/G8T47x2Fbc1115SqnPmN7wm7dT92wm59ywxtgRasdukYrEDkYMuu1wPwreGDKmm/LextFUV0YR34zjSDUVZgqS15dYFfLC6LpEmhMDswMcd1PLC8qq8BzHYG3GmeieGho4WMIbuuML3q6guJW9K4vm/EJN6boYsVp1O8i23yGOHCUjPdUx/roTyYUT90j5HVK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:03:02PM -0500, Steven Rostedt wrote:
> On Tue, 16 Dec 2025 06:02:52 -0800
> Thomas Ballasi <tballasi@linux.microsoft.com> wrote:
> 
> > The changes aims at adding additionnal tracepoints variables to help
> > debuggers attribute them to specific processes.
> > 
> > The PID field uses in_task() to reliably detect when we're in process
> > context and can safely access current->pid.  When not in process
> > context (such as in interrupt or in an asynchronous RCU context), the
> > field is set to -1 as a sentinel value.
> > 
> > Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>
> 
> Is this really needed? The trace events already show if you are in
> interrupt context or not.
> 
> # tracer: nop
> #
> # entries-in-buffer/entries-written: 25817/25817   #P:8
> #
> #                                _-----=> irqs-off/BH-disabled
> #                               / _----=> need-resched
> #                              | / _---=> hardirq/softirq   <<<<------ Shows irq context
> #                              || / _--=> preempt-depth
> #                              ||| / _-=> migrate-disable
> #                              |||| /     delay
> #           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
> #              | |         |   |||||     |         |
>           <idle>-0       [002] d..1. 11429.293552: rcu_watching: Startirq 0 1 0x74c
>           <idle>-0       [000] d.H1. 11429.293564: rcu_utilization: Start scheduler-tick
>           <idle>-0       [000] d.H1. 11429.293566: rcu_utilization: End scheduler-tick
>           <idle>-0       [002] dN.1. 11429.293567: rcu_watching: Endirq 1 0 0x74c
>           <idle>-0       [002] dN.1. 11429.293568: rcu_watching: Start 0 1 0x754
>           <idle>-0       [000] d.s1. 11429.293577: rcu_watching: --= 3 1 0xdf4
>           <idle>-0       [002] dN.1. 11429.293579: rcu_utilization: Start context switch
>           <idle>-0       [002] dN.1. 11429.293580: rcu_utilization: End context switch
>        rcu_sched-15      [002] d..1. 11429.293589: rcu_grace_period: rcu_sched 132685 start
>           <idle>-0       [000] dN.1. 11429.293592: rcu_watching: Endirq 1 0 0xdf4
>        rcu_sched-15      [002] d..1. 11429.293592: rcu_grace_period: rcu_sched 132685 cpustart
>        rcu_sched-15      [002] d..1. 11429.293592: rcu_grace_period_init: rcu_sched 132685 0 0 7 ff
>           <idle>-0       [000] dN.1. 11429.293593: rcu_watching: Start 0 1 0xdfc
> 
> Thus, you can already tell if you are in interrupt context or not, and you
> always get the current pid. The 'H', 'h' or 's' means you are in a
> interrupt type context. ('H' for hard interrupt interrupting a softirq, 'h'
> for just a hard interrupt, and 's' for a softirq).
> 
> What's the point of adding another field to cover the same information
> that's already available?
> 
> -- Steve

(re-sending the reply as I believe I missed the reply all)

It indeed shows whether or not we're in an IRQ, but I believe the
kernel shouldn't show erronous debugging values. Even though it can be
obvious that we're in an interrupt, some people might look directly at
the garbage PID value without having second thoughts and taking it for
granted. On the other hand, it takes just a small check to mark the
debugging information as clearly invalid, which complements the IRQ
context flag.

If we shouldn't put that check there, I'd happily remove it, but I'd
tend to think it's a trivial addition that can only be for the best.

Thomas


