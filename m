Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 922C9EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:43:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A7F6B0088; Thu, 12 Feb 2026 13:43:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04DB6B0089; Thu, 12 Feb 2026 13:43:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1EFD6B008A; Thu, 12 Feb 2026 13:43:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 934136B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:43:20 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4BE3313A074
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:43:20 +0000 (UTC)
X-FDA: 84436677360.18.40EFA49
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8C08D40006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:43:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770921798; a=rsa-sha256;
	cv=none;
	b=5T8JkA2hu5HV9RmWkcEDyiZHEhxmQW+h8mdqiTeJQNZwC3yaTyVL1AYgQQHrteUxOwP4m7
	fPuGy3Bw9Hk0JS0CORzg4wxkNElbFO8f4wBUaQZhIRgbwNzNRB0GPa/jHBolACA2L7Bwh8
	jzfTuZK1MoTWpSvGu6DuI7Smgu6vUcU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf11.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770921798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0sCXdCd8kMiPOKwLmUbOZCBt8WaYlGF3AcNut9G6KZ8=;
	b=K70Y0KHBxPceo+2+Gh9gotVochbVKoOuGda7c74kF2KI3Moplti13G/zulushsPzx94O/a
	Sb91xod+rxCYWF9yrNlEPn7qw4sUGyu/jDzovSaFs011YAJ083jyOdLm7IN7plSpreMBOr
	pDm3oxEWEw+U+WDcMTkGBIgGd0XpVVk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 078B6497;
	Thu, 12 Feb 2026 10:43:11 -0800 (PST)
Received: from arm.com (arrakis.cambridge.arm.com [10.1.197.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 552AA3F63F;
	Thu, 12 Feb 2026 10:43:15 -0800 (PST)
Date: Thu, 12 Feb 2026 18:43:12 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <shy828301@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, lsf-pc@lists.linux-foundation.org,
	Linux MM <linux-mm@kvack.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, dennis@kernel.org,
	urezki@gmail.com, Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>
Subject: Re: [LSF/MM/BPF TOPIC] Improve this_cpu_ops performance for ARM64
 (and potentially other architectures)
Message-ID: <aY4fQOgyx3meku3b@arm.com>
References: <CAHbLzkpcN-T8MH6=W3jCxcFj1gVZp8fRqe231yzZT-rV_E_org@mail.gmail.com>
 <aY0Q7QhGDKwKk2ie@slm.duckdns.org>
 <CAHbLzkoE0UQLZSKQJttv1_XGT-6HPKdj5o7aYnpuiXEyvbAHxA@mail.gmail.com>
 <aY4Ty6G6A3478_JS@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aY4Ty6G6A3478_JS@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C08D40006
X-Stat-Signature: qzsieu1mw5nrnef3jfdgyx9qzn5dsrqo
X-HE-Tag: 1770921798-461569
X-HE-Meta: U2FsdGVkX19f77iQX+JPECWiWo8Vsx6Hh6KdpcBbMSbvqJLZ4bvynm55zxDxZO5hgAaHv3Fy7QEUkNWdgJ9pgT9WPN1zMVXgnX7QS+sRHqeg0NFQe2olNmpMl8W73qMJAWVmIE5TL4JEBzEle1AKJmNra0vwpP5ZqmeifMiFCv9ry31xB11ljmjGmW8F7Mxz+cBvAVeEvfNTKG6I+N35WkSSCu9YGRwJ0OafN3STW66s1130VxpQvDXhP89wAVVMiOId07dGW9spjWN3SOhxHQfWZCfbm28/X966h5YnAs6d06LBM6Ie9JjCR/RYQ2J+8pu4+C/N3i6G4b3V3ukh7nB5vsyshO5usWf5g8B87C97orvRq9bH9QXA1nIK4DbrIA9G5LMbLTg1DRZlTKDp1U249y2EsERjH7wPJwTTm4Mwgt1iUQj5+gC3OnxOSYT0JavAGaHhrnT6truXS8e+605047eUwkRlx3cBr/hEO6RsNp+6og9/u4E8aAQxsO9mvp7+xf8UWAhnYB/akg63107JEyWCXvHvvFMQTO0Y7V6xjLPxIlKfV0T90ipFqdiNbqLEIZLNHUOP+b5B2rJizDzQUwHyKu9EIbwtHWxguN4dVDE1rfmc1mEQs2I9MTzXYt4eQjNBdz9W2rpoYJIoQum/0sLysuOO/U9bpK9uUaYJupSMo1emLym61YnBEJY+cGNPgs59Wy0FxXFulopIITkzayaVU/0WpBa7NLM/fkGWjcbNG0i/L3NkA7MqVBm9QH1YwrcsfRdMkhFvbKJABeyKLAzjZBomO3cP9VF6LDqGbjDro0tPtKcsBLrHnUw0ACqEODc6Xg9c8+5mO+mMApcrL52Mlc14K6nCGa1ygQBbYcKLqAepFf7mBJi6OAFiddm9nA1sdY6DtgtEGdnnpR43nbdRnWODICyyqynanejzha7/ss81RibakhVK2S02O8B3LWEr3U3VItuc3o3
 sa7diVLS
 M6Tg3vYo5O0DdQFyUmsi6tcjQxSxu8KucdoQjBC7YDkE985evheIyeJokQIYIv93Uku9S7qdRZFC4GL2gQRR7VRJFQ/8Alyvf+vN4uhGM7bEpDl4avy2ICW5SWJPj1TQP3aTBzVuY8xV/Rqhm46HD7kdXTtsYtV5IOT6RRcn8AZ+LCGcRomdA2EC7uA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

More thoughts...

On Thu, Feb 12, 2026 at 05:54:19PM +0000, Catalin Marinas wrote:
> On Wed, Feb 11, 2026 at 03:58:50PM -0800, Yang Shi wrote:
> > So we just use the local address for this_cpu_add/sub/inc/dec and so
> > on, which just manipulate a scalar counter.
> 
> I wonder how much overhead is caused by calling into the scheduler on
> preempt_enable(). It would be good to get some numbers for something
> like the patch below

In case it wasn't obvious, the patch messes up the scheduling, so I
don't propose it as such, only to get some idea of where the bottleneck
is. Maybe it could be made to work with some need_resched() checks.

> (also removing the preempt disabling for
> this_cpu_read() as I don't think it matters - a thread cannot
> distinguish whether it was preempted between TPIDR read and variable
> read or immediately after the variable read; we can't do this for writes
> as other threads may notice unexpected updates).

There's a theoretical case where even this_cpu_read() needs preemption
disabling, e.g.:

thread0:
	preempt_disable();
	this_cpu_write(var, unique_val);
	// check that no-one has seen unique_value;
	this_cpu_write(var, other_val);
	preempt_enable();

thread1:
	this_cpu_read(var);

thread1 is not supposed to see the unique_val but it would if it was
preempted in the middle of the per-cpu op and migrated to another CPU.

> Another wild hack could be to read the kernel instruction at
> (current_pt_regs()->pc - 4) in arch_irqentry_exit_need_resched() and
> return false if it's a read from TPIDR_EL1/2, together with removing the
> preempt disabling.

This one also breaks the kernel scheduling just like using
preempt_enable_no_resched(). It might be possible but in combination
with additional need_resched() checks.

-- 
Catalin

