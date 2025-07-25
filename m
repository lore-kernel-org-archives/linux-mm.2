Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF33CC87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 15:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8896B0088; Fri, 25 Jul 2025 11:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B06B6B0089; Fri, 25 Jul 2025 11:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6166B008A; Fri, 25 Jul 2025 11:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5CBD06B0088
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 11:45:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 073305AC54
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:45:10 +0000 (UTC)
X-FDA: 83703210780.14.5824FA3
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C5324000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 15:45:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nWi+22jj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=2wlev3Mb;
	spf=pass (imf12.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753458308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfNlU9QkQSDk6X3acZW9Zv6watdmS4XLb2lpyLgX3PU=;
	b=Uqav22IX2O4Xpgy1neYgOTkKiHwuDR7xo1Ar7ME9y9IOoY4z/r/SoW8kbmFm9UJM/DmsWc
	6LjT7wdFLOkhR4pPjXvVaEWiwJ7HGjoTU/jSGKCEvxEd2oSlZMhW/4t+5TNwa2AYiiRRbu
	AXp0I+dw4N2jXdmBTz89YI8Nt5Qv3pU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753458308; a=rsa-sha256;
	cv=none;
	b=M2Xi/4/tQHHAJprS2IuD8uqaZdG6241HQDfhG8OISq3/SEvbAuUpWJ2SejB04COnLlo7L3
	xpFJ9GRuoUkpoRgis4ERm1kLexftghYiv0hNd7Vj5JxGPLWfR+qJngAhIuoUx0LB/k2ji5
	Y2BHPf8odlEyNjjdaCy7pqcSLHhEVYE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=nWi+22jj;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=2wlev3Mb;
	spf=pass (imf12.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753458305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zfNlU9QkQSDk6X3acZW9Zv6watdmS4XLb2lpyLgX3PU=;
	b=nWi+22jj/D7vpJ3jHZNLznk1KJL9waj+gQWBvee9c3DCDjBGRQxnd34ePojIYdP6v+eVKG
	yG5tj6U0W7XvzcafeahhiJ7DsZKZL6kJKmzMVL+Ks4v2x2urTkyCLbR1OnkDjrqoOl6sj+
	VnOF6P3Ga+8BpoAwTI8VywKIdWY0K+7xbhld/p0uekv7pnRBIEx6fFFyji+bMunGgJuuVR
	URcoNjbaLEWjMDmaTrtJMO4834tjUkaAgIjqQOLkccuir0WvwA/yq2VibB7phjMZHWuSQX
	g2prDMKR6GuQEP0js+MSZVdBI+cCC7zeSkfA3PhRO2hIPyB1B09Vv+ZLZ/v7ww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753458305;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zfNlU9QkQSDk6X3acZW9Zv6watdmS4XLb2lpyLgX3PU=;
	b=2wlev3Mb1+z/3Pnnum1fsrCZ/wKE+6fI5t7UzhlvwaPmKxn6SEQEbGzJg3YvvNkBEQ1RKj
	qNo7Fzzu1wV4ZADg==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <aINKAQt3qcj2s38N@xsang-OptiPlex-9020>
References: <202507231021.dcf24373-lkp@intel.com> <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020>
Date: Fri, 25 Jul 2025 17:45:04 +0200
Message-ID: <87seikp94v.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 3C5324000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: t14q8ukpkm39bdkz98wjri5xg76y8kxt
X-HE-Tag: 1753458307-169115
X-HE-Meta: U2FsdGVkX1/JKV260IRjHCASRjH0bU9KepYGu7srGkZyv585BbdxDi+AiGKwsP4qkGM0IjNrhoqB3LRG77AENODklKtDYSLjVe7u+OI8DT6lt5WcfyMfpkge6tyeUS36MG0hQc0ajazGZ5w8EgmVG6RAFBtAABxLEBMw+2HWaM3oBjhUaINQPkrDgZaLVnT7AUoKPOk9ppdMHZtd2gh+/y6CDoUyaeUfhAKK2jZ44b0eoL0wjjyquMXdKNT6ryvkYh9WFulx8EEwTrS/APEF8T0uBVN5p4mCK7A6c9f42JMStn/guFLOm3pvmyrhoTXcCBH4SrqulwFnjzx/QA6DhA3sHBjZGu6S0ciUZpbPs7ctd7OMXoL9VULAhelU4Tsf9wLhDSS/TUglmRdlxlQrWh5PTpdI2JImVtzc+a5uvtkUZvY0qzewGiAY/71II9mk6TviKvnOX82i8a/a2VMU+P2JWUJufPYEOpIbdga4USUOtf/bS3zjObL6PqLvtT9lhn3BLSL9Lb5VgYTkcqWQvktQnOSyGv2cbsl8N2idX+y/V3Fr256xKSOc9wm1kWBcEDFLUOcz18LpHtk7uVVX2CqXTjJtndgpo/2ggoELt3T+Z54mB0rfmTfvrCJz1bWrtvw5g1f46DrSVhqH4CeAS2EwEVtoUhNldgojCYD61ojs7e27tPDq9tgUl0AT0/DuHtuM2RaFNxTdBB1RqUxtzpky68twa6IhJJzSO9cKQkGUIOK6XcQ1QYEOQbMEDHGJGVLJTqvFCU6A1sTeC4I+Io0kjtyVPXf40MeuBrqajitmo2YnZ3/QVK6Hyvf25KrwNS7Xn9vNw7rI/RWKid7n1WKIigYP60AHOxeUdTftZ1+SRHXE52NVhbMm4mq+DuRyDQf9um4zsZwEUp9mEr1Tb0y9PiykEXH+9RILs55AjWUHU4LpGeSRcVUpzeSr+WZhk5TwINDLiwfAYA+ZWIp
 9mNBPUa9
 grurY5KuQ0d93eOBsQhgL/Gr8VKHKHCXFCNXUGBKaMWMTW2iW1uX2x5+sW04be1/viYpRPf7jD3tBUjdHq5j4iSTd4VT+c4ayJ1CNcES5TXVUuJjLdS/PK4jl5tQdjM03xPE43fku1jX7qWZAIauyQZ/+2AyRor8lpt7zVG/EabqHtwXjtDvgHS9K7l0C2WWi+ClMd+MlDC64HitFD1g4LjlZdZvamZ7oVa+l68dFClMsJLY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Oliver!

On Fri, Jul 25 2025 at 17:10, Oliver Sang wrote:
> On Wed, Jul 23, 2025 at 07:22:43PM +0200, Thomas Gleixner wrote:
>> > [  286.673775][   C97] BUG: sleeping function called from invalid context at kernel/nsproxy.c:233   <---- (1)
>> > [  286.673784][   C97] in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 6748, name: oom03
>> > [  286.673787][   C97] preempt_count: 7ffffffe, expected: 0
>> 
>> Ooops. That's a corrupted preempt counter, which has underflown twice.
>> 
>> Can you please enable CONFIG_DEBUG_PREEMPT, so we can see where this
>> happens?
>
> after enable CONFIG_DEBUG_PREEMPT, the config is as attached
> config-6.16.0-rc5-00002-g56180dd20c19

Thank you for trying, but I just realized that it tells us only when it
underflows, but we don't see where the actual extra decrement happens
before that.

Can you please enable CONFIG_PREEMPT_TRACER and add

'trace_event=preemptirq:preempt_disable,preemptirq:preempt_enable ftrace_dump_on_oops'

to the kernel command line. The latter will dump the recorded
preempt_enable/disable events and we can pinpoint the function which is
responsible for that.

Thanks,

        tglx



