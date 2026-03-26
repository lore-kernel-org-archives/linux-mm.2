Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3361010A88F5
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 17:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87A616B0005; Thu, 26 Mar 2026 13:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851F16B0088; Thu, 26 Mar 2026 13:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78EDA6B008A; Thu, 26 Mar 2026 13:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF7C6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 13:47:16 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1F5AF13C24A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:47:16 +0000 (UTC)
X-FDA: 84588945672.06.30D1223
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6C7B41A0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 17:47:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cWmsQBbi;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=cWmsQBbi;
	spf=pass (imf19.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774547234; a=rsa-sha256;
	cv=none;
	b=VeB2Ya4oG199x7KnMRk/HlezPZqUu3/v/maCNyYeB40mIC83iESU5M6o17lCM1ulUAia2B
	+50QtTpxEi01PHNKeuFn6kr/Bnb5NXTqR8TD3e/EgTv0CRg/uDa44d4i2n3lZukjhtBya8
	Htxbklo2lU3tbBbHt8E4YWmarI3UHJU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774547234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HajYBUhAMQvYpmUDUOrZF12EybtGDD0VRMp/h9GItuI=;
	b=i6eMUFzh6wxTTIEJMbGlxnKbdFdDYf2s95jKLJyIOuJPoDtbrSr13nAhocR3W35OmadR5g
	5uConQ2e5AiDH+0eqcoERCv3LV4VPQDm4xwJVk81CvYa3L4iCmqs1D9fpTGVZy8icJwMEt
	DdTUYMfWbvsTr6BIyY9ld4dk5yc5/7c=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4D7D7BDE5F;
	Thu, 26 Mar 2026 17:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774547232;
	bh=HajYBUhAMQvYpmUDUOrZF12EybtGDD0VRMp/h9GItuI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cWmsQBbibf2QgNdBv+y0h3RK2/59H9eydWIBxQQ/Q8ag2qRAQ1v6K0wUCTXAFnYQx
	 slWOiGujhroPzV8XedWtDbXU5Ie8M9N7hNJgF5VHtUliCz64Aj4glFbHKvCamgE00C
	 9Yl24qMjjoDzdp8XtlZnmEmNqNuRTSb/jAa5mVMo=
Date: Thu, 26 Mar 2026 17:47:08 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint
 instrumentation
Message-ID: <acVxHOXgbPXeT6A8@shell.ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
 <acVW6eFGwqACD91Y@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acVW6eFGwqACD91Y@casper.infradead.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C7B41A0005
X-Stat-Signature: f4o6wokgmt4caapz7xy8cgqcssxeo7bj
X-Rspam-User: 
X-HE-Tag: 1774547234-972552
X-HE-Meta: U2FsdGVkX1+7hm7yffh7nceliwvSVYmTe5mXWcxDHbw1JO7ZYQ8koQ5RllSVhl8sEREBTkYjcJED2qtLhiuzu+wonG8z+DltI+2nuVr9x5hnyI5kklYS5Jb2em4Wgkt5HO48F3EqQq13mxsw3p197C5vwt/N5hSTcXIFOEV6Y7KYAfXEOKgd/952+e1uf/7XHSb4hSSjD/1I/Tgxim2x2ucV4j1Watv1iIz30ypi4z7J0FuFg6dIAyF5jpZFUaCdzhiX3KsIxh3Fm8Fhajdl3PO+rYIq9yRMSTQ2L+6hvjdYmlf+rKC7vCrRqQpr42DxqGgpTW6A7/C29Xnot+jxaH/XZ60431o6i7pTv/Gl0pRZYbyTYxz7L61s81rhGYfL7cjHVLIQbBJd/ngfTG2LcBBamCa0Y5otE1W25FxwfjS6g72zoKB1HqykAJVKXjLEnlpJysR2q6/HpEZFsippQ3v7a06XelnYoeMolbLb4SE/ZnUXjT61kQujkDJUiw7nbGvYya6WocxkMQn+gOJipzhnfs/AaA22Z+UPUiLqpsj5enlTx9ebtbWbe6mNroPTuih389IT5sP1ctn2A9eA9KAnC8HDz397JgMhZU/DB4wmrppL+ljTvo/4caUtAX7r4lfJT1ccEYDZIIQrZdBP2BP3kUlqx2ua/04jiaFT+xM0wQgldtsfAGnoPi6y/0kZ2YVt26aN336RpET/ev+d7NUtuVq/M8OozPICoJ6UQCDOgGHZXqMz+txNhDKW4kaHwbXnfHPS+hJNIxmsWuXknIvtr6nUiBPZk0j7L5Qwky5+SqUHcNVjhJORbla+HL2Jv1qKAMZz4gMsTYrM5ld/INvGrHdMGOgsI/IdSB1ghFpda4SZvWqIIkGHgB7yt0dNfYza2bPfQx7qSRLhPeK59jfBBUyBlKOy6SkA0afkCGO2BrMg/QZBNZcUeIZG7WmzeFadGdH4Bms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 03:55:21PM +0000, Matthew Wilcox wrote:
> On Thu, Mar 26, 2026 at 03:09:59PM +0000, Dmitry Ilvokhin wrote:
> > The existing contention_begin/contention_end tracepoints fire on the
> > waiter side. The lock holder's identity and stack can be captured at
> > contention_begin time (e.g. perf lock contention --lock-owner), but
> > this reflects the holder's state when a waiter arrives, not when the
> > lock is actually released.
> > 
> > This series adds a contended_release tracepoint that fires on the
> > holder side when a lock with waiters is released. This provides:
> > 
> > - Hold time estimation: when the holder's own acquisition was
> >   contended, its contention_end (acquisition) and contended_release
> >   can be correlated to measure how long the lock was held under
> >   contention.
> > 
> > - The holder's stack at release time, which may differ from what perf lock
> >   contention --lock-owner captures if the holder does significant work between
> >   the waiter's arrival and the unlock.
> 
> As someone who's not an expert in this area (so please use short words
> to explain it to me), why do we want to know how long this holder took
> to release the lock from when it became contended?
> 
> I understand why we want to know how long any given waiter had to wait
> to gain the lock (but we already have tracepoints which show that).

I think the simplest way to think about it is the following. Waiter time
is the symptom, while holder time is the cause.

The waiter-side contention_begin/contention_end tells us how long a
waiter waited, but that time can span multiple holders.

If a waiter waited 10 ms, we can not tell whether one holder held the
lock for 10 ms or five holders held it for 2 ms each. These need
different treatments: the first means shrink the critical section, the
second means reduce lock frequency or split the lock. Today we can not
distinguish between these cases from waiter-side data alone.

> 
> I also don't understand why we want to know the holder's stack at
> release time.  The stack at contention-begin time will include
> the point at which the lock was acquired which should be correlated
> with where the lock was released.
> 
> Perhaps examples might help me understand why we want this?

Holder's stack allows us to understand who exactly waiters were waiting
for to release the lock.

The stack at contention_begin time does not always include the holder's
stack. The --lock-owner feature works by reading the owner field from
the lock struct, but it only supports mutex and rwsem. For spinlocks,
queued rwlocks, semaphores, and several others, the waiter has no
visibility into the holder whatsoever.

contended_release fires in the holder's context, so we get the holder's
stack at release time. For spinlocks, this is the only way to get any
holder-side information.

Original motivation was zone lock contention (a spinlock) in Meta
production workloads. We could see waiters were blocked, but had no way
to identify the holders or what they were doing.

