Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D7EEC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 16:19:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B7F96B008A; Mon, 31 Aug 2026 12:19:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468466B008C; Mon, 31 Aug 2026 12:19:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380D66B0092; Mon, 31 Aug 2026 12:19:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19F146B008A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 12:19:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A77A1C06B6
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:19:11 +0000 (UTC)
X-FDA: 85162074102.30.AB341C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 127C140011
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:19:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGJbox2L;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788193150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHhHAXohzn8l8P7iQ2bTOcRyRwykV6bPfvLQtf0G7Ec=;
	b=eAhyWirVjInB58ho2XoZ5z0rU73YbVcdRJKUfJHwkSVNUXgNGMeeGw45znIA4W6kuQ5ivE
	F6MfLseyrab8y+z3VpPjL+G/y1hEPMgFRpKW5/U2Vkp8vhxVambL3OyJhNbUWuPX3t1N+m
	VX3HXWc08veaVqXH84/2ZVYmDR9Pu08=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788193150;
	b=bd62hBJzqTekDOezxPRNvln8b/FNAaP61KEHwF6CbaxCdtYeknO+Yh/ww7pRhtJDfG17rO
	9TDAGgDDWpgWzkKOMWdR64MDi9bFrn2nsFPQYLUbW+vVf7w4d2ThLRg1nrGMQJfuWVw+Zw
	NUO/qf6Sz9L9mO1X3gRvRjl8eePfAUk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jGJbox2L;
	spf=pass (imf27.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7636C404A2;
	Mon, 31 Aug 2026 16:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911111F000E9;
	Mon, 31 Aug 2026 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788193148;
	bh=SHhHAXohzn8l8P7iQ2bTOcRyRwykV6bPfvLQtf0G7Ec=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jGJbox2LSWuG5z7srjqQgIsOFUWtGu+aUDw6+QB45QEGMNTx4Q6d9Vlf1c9HHU1/U
	 wLNMf8Zcnydr4bbADfj2JmEmrBVXcl1+tHRdFreJIjBendMpiNugCA019BhzUTSJWp
	 zW5Vsl0fPmcWy3lKl+wGIhuEtwymF0rmvIRKSZ+DXlVJli27XQGHt/sk/l24iinReR
	 OggJ0kToqFctARCDPnCzcW5ufJT9zGgZ1cNz5eWFCbjQGPpRWLtWvyXjXh5IS3fuar
	 Xm0iOHFhYFMK4YcTICYElXpfQ+pxpXeab9fW81u6d/cycjk83mKzhmpp/4l92ZEnhP
	 Kt1ATiRml5+yQ==
From: Thomas Gleixner <tglx@kernel.org>
To: Hyunwoo Kim <imv4bel@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Kees
 Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
 John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, "Eric
 W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Hyunwoo Kim
 <imv4bel@gmail.com>
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
In-Reply-To: <87bjaicxm0.ffs@fw13>
References: <ao7Q8miiuLAPVnWv@v4bel> <87bjaicxm0.ffs@fw13>
Date: Mon, 31 Aug 2026 18:19:05 +0200
Message-ID: <878q5mclfq.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 127C140011
X-Stat-Signature: hxy5bsykdg6qfozo5bijyfw5tdt7tz8g
X-HE-Tag: 1788193149-220085
X-HE-Meta: U2FsdGVkX1/zLM64GwZ3yk+3Kf1NYqwbJVi+aVJDJGSworHwNrITl4Pk7adgb5Z15s8CXytFg177ANSzri/9jGUn0kvKcAPyEtEUDdEnexaMuITjmJTpFZ/SqY4oiuuuorukWlB2RyebMjEPNxceSlndpccvTEw1hHUCulxtSZrADv2F/AEIFA9XWyP9owKrmoMf/U4KfGU5vmAZDHR1WIMhgeJZtiY8olObMYhOIgPaHJDUSUkVtI/8K9+ackHAlMF6tcix+Yz4vWQ5z7JhfNWQRgFLIdfNGfnrX7BGuHkK9CZiSJMm5BZiV8fw56toNFiRz7V3PSII2051CRuVoXsl4pGtsTwfZRmMKUH8imPuoH0n+GqjywZDfFBbf/ruPD66Mamcvw66A9VCa/nYz1sNY8NpH3VRF/3Fl5q52VGT18RjvvUZiztSLPK3/CnQ/R5FTOmPwoXWMui1TjCaplO139CW7dT2LKi+43jTaRIqG7BTU5jynWVyuC1VjNsn/m3cMwaqeiMIGxFjrGL0lpEHCmHpEDv3Rn60R6DfeHpXCyU2xVUByHKU4+/mY0z0pBV32mnHxbcxksyltejvNdGD5ou96Dhc7CVdGvMeptmCcwLWgXTLsEPPlbra/XY5jWVvJxiCCfq3ibeuBr/Fe0QElcL1REl7oFxIP7uAF0LvCjh7YSyEiw9fZa9QhbFzpBRKj6NtRs30YJexxoX0Gam1H0Xd47u/lD3NjTtuk9NnaKvUnbGZMe7dt8WUMDIGvXYEWlMEobEvm6X4OyoFYvbxxBjaVqjmFk317/r38UpImnOPwrmpYM8yA/+MQVWrMr1y8MfHITP8eQfXY/Fl+6KwKJ80DhTjfmmIUXb/XZ+59Tb38LvbgD8Sj7IuZbENkU0c890Bgi2hUOIkpMPmUdl2/zaQ2whTtILfUK9W4Zxm1ZLQYbIpgWr5Wjgo4b0/1IvGrPg7v/x0nhEiYNO
 cnpQ5Bau
 w3SP20ju51OPKWNW5p0i8k4wLJkD3zFhIj0ULOOL5OIULEdq9Op+ot1k6vqrGdi04/gs/FZ0Eo0WikHVDfhCrlHDiKZuz0RyYWkFBIDEZJ2IHT72JOMhn6rAWsaqyEE0NRuGrW60L1YFQDAi/ZmShn4vT5mdVnxTrvOxtsjxxZ2AaofViLfGsLgmOP9Jx6bT3Y9HR4Km3dFOnqBYFP0+9djSAO36Hg6r3fZMyZMNGvcbhfVftvvbV6xtARdTm5JMhFaadEK26kLF/FJZWOzerfo3Yc+fMkZeg06st9rZ5Y1lTmfDt7PyqCSDiCI1uACLy0MvU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31 2026 at 13:56, Thomas Gleixner wrote:
> On Wed, Aug 26 2026 at 20:41, Hyunwoo Kim wrote:
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 745f6eb5279e6..9b2d140bd9f2a 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1003,6 +1003,18 @@ static int de_thread(struct task_struct *tsk)
>>  		 * the former thread group leader:
>>  		 */
>>  
>> +#ifdef CONFIG_POSIX_TIMERS
>> +		/*
>> +		 * exchange_tids() hands this thread's PID to the old leader,
>> +		 * which is reaped right after. The PID lookup in
>> +		 * timer_lock_sighand() then fails while the per thread CPU
>> +		 * timers are still queued here, so dequeue them first.
>> +		 */
>> +		spin_lock(lock);
>> +		posix_cpu_timers_exit(tsk);
>> +		spin_unlock(lock);
>> +#endif
>> +
>>  		/* Become a process group leader with the old leader's pid.
>>  		 * The old leader becomes a thread of the this thread group.
>>  		 */
>
> Similar to the other issue vs. POSIX timer signals this really wants to
> be solved in exit() independent of non-leader exec(). Let me have a
> look.

Duh. That's about the non-leader itself....

Why did anyone think that swapping TIDs is a brilliant idea?

I still think that this should be done differently. There is no point in
doing the disarming in release_task(). Let me think some more.


