Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56341C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:03:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1CF6B0092; Thu, 31 Jul 2025 10:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8AE36B0093; Thu, 31 Jul 2025 10:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC68B6B0099; Thu, 31 Jul 2025 10:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEBD66B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:03:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 60CA71A07AB
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:03:07 +0000 (UTC)
X-FDA: 83724726414.17.096077C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9CF0E180015
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:03:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="XR/CQQqI";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=jWUiEbiO;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf16.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753970585; a=rsa-sha256;
	cv=none;
	b=S/8IimX4QwiGVwzH0Mb/MM8LFM6Au27BOBnMcwj8YY+GXXR35yBp8TGCyD7HIP3A21gUQ/
	hQzpWDJZq6aakXERAzmfB8TWK8x2BuJfT3TfV7bpuK6NE6njohT+n1Eek3c9fhZzSTKZM6
	SJ7DJS2rQFiry4YzRYPrIHQlhiS7jUg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="XR/CQQqI";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=jWUiEbiO;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf16.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753970585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/jUB7+mqJ6vOu9bYPCfa2+TuZR2QobbeGi99NqhPw0=;
	b=Rfec5UDDqK8tidronhlCTzqeHcMQPWK7au3KnII7Og+C8NM9Di0zPIlOvNPr5Hy9olczjT
	guOFMzUh+SJoz/5Er6H9kuXohzbphfxQ9prw+4+x325zmMubCrGQIz9roW6YD7z2of0tLz
	EXJoHLaSpUuT7XdLiHZwGV9g6jk1Gjk=
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753970582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y/jUB7+mqJ6vOu9bYPCfa2+TuZR2QobbeGi99NqhPw0=;
	b=XR/CQQqIxkjhty4gyYn0+QF9INSWICBtL2FypdYnrwc4hg2mR4T9S+zZ2RpJGGtJt7Ft+B
	sKLh8ShWlR3Jvf24Cps5Pq46OPAA/VHZlQfU7ggBUIrpGBRzVtl1Njq9NQ8rSgDTBt+OR7
	n4LQJCSzIfAEK1CiQ6mS8waHwJcuGsrOVw3YoeAGu51bDB8Gwv19kcFdAYliNmHpFUmPS9
	NYoeReZdwFq1Xicy1srlPhNUl7q9KIj07FjoRlvb+folf54IJ2ABloMhov//8jQ//kQ5yt
	mTCzCRgepYusHQRG4xj9FgVK2LX0hRHEPO3BkW/pmLwUfYoMzM8IAdVQCzeS2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753970582;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y/jUB7+mqJ6vOu9bYPCfa2+TuZR2QobbeGi99NqhPw0=;
	b=jWUiEbiOLeOjbqF1VT1CubB8dEPFjkaZ1Lx4rkLHzDxAoyhUrhkiOwsAdjM3hLCBAjM/8u
	k1YesinPBnEyc7CQ==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <87cy9gilo8.ffs@tglx>
References: <202507231021.dcf24373-lkp@intel.com> <87a54usty4.ffs@tglx>
 <aINKAQt3qcj2s38N@xsang-OptiPlex-9020> <87seikp94v.ffs@tglx>
 <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020> <87wm7ro3r7.ffs@tglx>
 <aIrJipeLsGUM92+R@xsang-OptiPlex-9020> <87cy9gilo8.ffs@tglx>
Date: Thu, 31 Jul 2025 16:03:01 +0200
Message-ID: <874iusihka.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9CF0E180015
X-Stat-Signature: h7i3yz3ha7uqaffomp1596hpczmtuszk
X-HE-Tag: 1753970585-50769
X-HE-Meta: U2FsdGVkX1+CcGgAhiTkvYtcCR1+OtLV0Bx7TU+P84cJvg+s7ycv4sov6AEjVUP+U3KPvmjIqEjs7NDMip1s1nxhD2LPVFZSxp3mWziIgh8q1wwMWpD+HJPMxuLky2HkdTf1zQV0EvJBHpr2AAwhAZwvDgej9ZFHjkZjFuI7W84pV6rG51TKJbaKTvC3hB28fynHcLU7W9RwHjETtRm7hIJQzdcxKqchEg5Z0ry1d2HgfR/sXg4dkHOlp9QQJ9J3mzBYSxxqU+/s6uj2Iy+VdhOlTeCec1cKMNE7rFnmnrjS8pUBPhZ8oUSBMhGFUPJRZZ9ToeUmsfRqIntnjWB4PF4FsN/YcSnlJKP6vr3NxoFfbmk5S73W+WTobTSJ68jfEfWh8eoxM3vvpuByJv4bk1z0bE5dKsPmWbb/f4CArXdPe1rR1BUNiWdaJMKrV90a3ofYbyJogjfTm1k0DdvfXweoVFJgoHNSfUaRWiOLsWoyO0RR3NDT7NHP07q024QwYZGLRpwHJae27sfuVmE34/oxWaQAnMt7L+DT+hvmClcxZKsJTBka+lYRVKTHbtGwLuMQYldvOJMCtV4fmIJmhTlbodYTNw+cIF8xAnyua/sXQeWsWTGb4JCbI8bo7Qi0atKuAu2La7pxUvplagt22/N7kUrJgLYWoH35Nfkbg+31kTF+JUf47z5HnXhJd1x08E0vNwQAR22tSgUNz2xdmzQJLcUuqEVSdoVk5SBOPFX4Im1C3wM70wrlI1yAFzbpzFT4TtbRhIdOPIcXmaygDIJaXt0WkoXcEAFbwb5hb1ZSl4iaZyKaavX54LT4tVVlCSj7QYZSbzaJpKVBkW83y0/Mx70j5YRlw8vrUJPUffxzvx+Ihe5gNHe1ymmexc2flfprCd39aoYYlmKMrz5OvuZN3TCO2qPUWZGEVg1Uj9wngFI4A1NKYxaff4K44ppVoe6BlqE5oEyeytrS5un
 u9xW+KWT
 RLCRbzHqtE8hW2+ugb2Rp9bFBj/pPMBTZ+aZ0xawpbt4uHrtNJFXhO085CmUSX51WzZnXJEpv52CwL+UOWJ7qpdeEqyDneAbnWgfo13PQsIyAoqFThoXNSilXq5tBXTld+OtuYS8qbjwQYa/EYdPGBIqjBZPmo3n5QqW5xp0+XjrzrwUmTlD4AW9hHVWOm7irlhFw8Ojrojjl8GFjIfwc8OrSC/hWisqF/pNNcAWvVQo2Z2g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31 2025 at 14:34, Thomas Gleixner wrote:
> On Thu, Jul 31 2025 at 09:40, Oliver Sang wrote:
>> On Tue, Jul 29, 2025 at 09:27:56AM +0200, Thomas Gleixner wrote:
>>> > but bot seems not be able to capture other new dmesg stats.
>>> 
>>> Ah. The tracer does not dump on warnings by default. You need
>>> 'panic_on_warn' on the command line as well. Forgot about that earlier.
>>
>> attached one dmesg FYI.
>
> Hmm, that trace dump was cut off before it completed by a reset
> (probably your test timeout).
>
> Either you make the timeout longer or try the following on the kernel
> command line instead of 'ftrace_dump_on_cpu':

  instead of 'ftrace_dump_ooops'

obviously

