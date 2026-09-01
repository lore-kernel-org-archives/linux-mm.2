Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B726DC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 15:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EE4A6B0273; Tue,  1 Sep 2026 11:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4BA6B0274; Tue,  1 Sep 2026 11:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9846B0275; Tue,  1 Sep 2026 11:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3CF6B0273
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 11:11:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE963C0441
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:11:50 +0000 (UTC)
X-FDA: 85165533180.10.64D0847
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 08D711C000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 15:11:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gl2gPj8d;
	spf=pass (imf18.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788275509;
	b=sqsFDHNAILH86CVmGCPE01i7RaEa0iR1Eri44zPmH4xQXQceBXRYKVPU+4Fma1ZB1/R9KA
	l4MTsRHUkQT5OXRQ1ZHOr3oBGspYy8penF3mvrNN75QjwoyTtcE2v1nwL4fpQucqOCytX1
	6W1O46xtOguJNoDsTHFpN0NadTGD6sY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gl2gPj8d;
	spf=pass (imf18.hostedemail.com: domain of tglx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tglx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788275509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22jciHchDzUkZuvJuLeEwCgemxKYmaE2eCs6YcRWQ4E=;
	b=PA4JVaYsSIor86eFyg6yvJW8I+N45iVFvMQkA2DIsz6+9QBuDkKupx1F5tITqD/YAsHmBx
	KXo+fja3Wvo35t+LcSd020z6cQgpfH/MkZB+6r+6lu++BrHiezwjwcSdJfHKEOgTw8Oa4S
	D1gtuCOeT0vqtsXivnS7+GaGDJG+nB4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 330DC4089C;
	Tue,  1 Sep 2026 15:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716491F000E9;
	Tue,  1 Sep 2026 15:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788275508;
	bh=22jciHchDzUkZuvJuLeEwCgemxKYmaE2eCs6YcRWQ4E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gl2gPj8d218u8GLK01j4chCTENJTXDKp/fS1CPlD6C8C3pM/OQUiSoSO+kU1iFVWN
	 ZoAPupts9dEHBHmcENCWSl0My+R5Znd/6QR9BmjMUvwAwdZAT9FYMST8JaOgrIZEfT
	 P/YrMuEwEZ1UumcG/s6dQHtbo5+RPS2BMingPcoxOgoAjpIHzvU/QbX+4i1oH1ok++
	 51kh8hSI+C77nnUAFyhq3sowBJqCA57wY7T2Ub2AHf5w9nos/bZeaKVyquETMOfoI2
	 vX3MvfaLzuw5Xq5Hi0b0UUplAWARDkuM3wc0LSuvVvwJ/vriE20RiEAKFI2PPP+MQU
	 aoYIWO9nLR7EA==
From: Thomas Gleixner <tglx@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, Frederic Weisbecker
 <frederic@kernel.org>, Anna-Maria Behnsen <anna-maria@linutronix.de>, Kees
 Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, John Stultz <jstultz@google.com>, Ingo
 Molnar <mingo@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, "Eric W. Biederman" <ebiederm@xmission.com>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
In-Reply-To: <87qzjdauv4.ffs@fw13>
References: <ao7Q8miiuLAPVnWv@v4bel> <ao7iQ_wOLghOvTsq@redhat.com>
 <875x0qclcx.ffs@fw13> <apXGzcA9BmrbrQZv@redhat.com> <87qzjdauv4.ffs@fw13>
Date: Tue, 01 Sep 2026 17:11:45 +0200
Message-ID: <87o6ehatvy.ffs@fw13>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08D711C000B
X-Stat-Signature: rtjxizimuebs91yoy6essga3nta9pxt7
X-HE-Tag: 1788275508-265761
X-HE-Meta: U2FsdGVkX19R5GFPuqtoCLU5QN1n0LsZMaNDMoNboDEC8vmX1NivP2anIoKrUQ2kuiae09vSP3vbqFx03HJGzkCbT/oMAfEprVVSH54K0bGfOU7EuFnJGQ/OtOdHIhE1CNAy86K4tRl6lrX+/VI482KD17gE4mnCNW8/nhWndbkbZ73BhW4r6406zpc4ohx2Dhapkc0+XXUN6ei6AHEedGM1L2ctht/liNuerxxmQudVPL19tKEZY096rkEIwradse5gcLBEkKXB4nmua0cn3AR7fhhKBonNKftLeze3n3wI7oZ7InT6fYwXfS5NA3Op+MTd6dkcV2cqYhqa+wb7o5cjUAfjMQJd+hjW9t9DD9ebub9ZWhYfmQhwy2LjrF+rSyjqpDqM139YLEGAuI/Zb99BmAHJTwoi/CPeNwi6BEwzWI9Wj7QQek4H8Km+LXQLsk21mYH5+havOrDy4Dzfm9ZNPKr6xV8SCYzLYNAeQnTsdhPhuXAtyLUH4jcaVLXNGSxE8TqnrdWmjW3gBSXoQfwgB69PnRUr6962NQ+9Mcl974YDaT0t2Ztq9Ay4HBUvdXlyEc0i6LdpdPMvmgjEkgoi2exVIO3uRHQdcGCkGDqQuRx4LZvjGc0KdRAxNAj9EGR+vfSiGmY/7Fa+8/lrj8rkvK6DBonYnQHQEkPSKABAknCyDovx+r5zfE2lNOjkqnxYioAqidy+/BLZ9vLE6/ta9FpFXOK6OuJQWjpAQc+0HNLg3mcdAeit8PrcquOwL2fjU8izp30r7M9jPp0vTOLXGHvDxF+/lExsKXdHB9ZIZq8mtG5iWbBIbIWbDCyRFcSoEmGJvqlSApySDmkXQuowRDH8TAW4FQr5oliUzy1dYoF6cnC1xe15HQ4XGTOJsWRf9xEQ9I9eeQo5V9+eeZx7VC3EX1mZSaTJXN7keb6eyWigL5iSYwYN3ekJG/stbE315e3ax3BEESTPIgG
 BqpfZtdv
 OFVjR8xs3qfYvApudN5H+Gl+ypL64crPf/ZLHsOYugjA5faTDMFNadmAt1VBiTtvgBrJcON29eoZydI0Le8jGpSPTAN0z2UYlpyvmsxbTy9KQ8wcrQU8V1KPzc0Uaz/wf4tVIVNDEWe7VHOzSYgEGRJngdyjHxAsx73AKU9V4LR2UCSvdAxONZQQjm4rbiuzcqqyvKnH2eSUGXRI2fMhrNYjvnpH1RQ4ut3sqo2zqIbpNti0Rc3y7cWaUV64PYa/5MAOx0uoMPV4Tcs1EBQVPKH5OBIoPMzgPUK3jO0gUtpt1z9mT12J+Q2vhAk5C8JfIoI5T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 01 2026 at 16:50, Thomas Gleixner wrote:
> On Mon, Aug 31 2026 at 20:24, Oleg Nesterov wrote:
>> On 08/31, Thomas Gleixner wrote:
>>>
>>> On Wed, Aug 26 2026 at 14:55, Oleg Nesterov wrote:
>>> > Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
>>> > sequence in begin_new_exec() up, right after de_thread() before the
>>> > "if (retval)" check?
>>>
>>> Yes, but that does not buy us anything.
>>
>> I didn't mean this makes sense, I just tried to understand the Hyunwoo's
>> fix, in particular the placement of additional posix_cpu_timers_exit().
>
> Fair enough. But as I was staring at it some more, I thought more about
> it. Yes, we can do:
>
>      ret = de_thread()
>      if (ret)
>      	goto out;
>
>      mop_up_posix_timers();
>
> de_thread() only returns failure _before_ the TID swap, so that's safe
> and spares sprinkling this extra invocation into de_thread().
>
> What a mess.

I'm still thinking that an indicator for a task doing exec(), which is
set _before_ de_thread() and removed afterwards would be more sensible
than relying on subtle ordering constraints.

Along with the nonsense to keep timers queued on a task until
release_task(). There is no real benefit from keeping them around at
after PF_EXITING is set. Sure someone might argue that the precious CPU
cycles consumed in do_exit() afterwards won't be accounted, but
seriously?

Thanks,

        tglx




