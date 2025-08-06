Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16B94C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 10:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9C756B00C0; Wed,  6 Aug 2025 06:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A746B6B00C1; Wed,  6 Aug 2025 06:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98ABF6B00C3; Wed,  6 Aug 2025 06:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 875976B00C0
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 06:39:14 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A1921DCAD7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:39:14 +0000 (UTC)
X-FDA: 83745985428.26.3C4CCE9
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D5C940003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 10:39:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=1y8ifgKs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=toS1IjGN;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754476752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhKBjBL0r+ZMyH7ZvDnPT8IRUyvC+7V+Yvg1xfVi4zk=;
	b=hy/eGfy7vh7+6SH5ZcWKmZVjgw3E0YeeqwKonNCtGjUK7Q+KRfsfcFEN4I3DJbdB4bYh/z
	cmMNq3ZWKrZNWrXBlX3RSrRO5qczV8GPvUYpU9yT1MHEWQFr6qGyiKs2Xi8WGa1UMuYqfe
	6cB/QX7tvuBTSosC0Ceziz8IjpM0tc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754476752; a=rsa-sha256;
	cv=none;
	b=6M79PuBaugIdIa+9ccd9dyZ2kV5vTTY2Ucb8FXXwx+k8nFSFRCeXjyOvLPGKdzhlNHcn9l
	CsQ1/nFPvq/3D1V9qCth93O4porQB+4Mcojybca5uLAVVqcQ4R7zMW9lUX3N7d32Zg8G5z
	bSINkNaIqcZQA+5CA+AyN0ojMEvj9vo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=1y8ifgKs;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=toS1IjGN;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf01.hostedemail.com: domain of tglx@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=tglx@linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754476749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhKBjBL0r+ZMyH7ZvDnPT8IRUyvC+7V+Yvg1xfVi4zk=;
	b=1y8ifgKsKOhwxKOFaOdd4FhBFUCxw9urKa04WdCdOnVhl2hNkpbnUv96e7kQf4W8Pduid0
	+GT0IBKfm/dWo0GW+3netUezCF1T4zQNjw2vAN8BggMyEj+xu7qmpy5EaVHcvuHI/lsUxz
	KaOS8Tb4dt4do3t/xeyOJQUjFWMc+D8LYw8G6erCR4Yd4XraR/3bAqClxrGba8PTJRr5xJ
	Nn/O5De/zMGIvXLQKZJ1sbAVQIE01rjHAumEkWwqcBN/ArIemkidhb1REzvuvZ9bm/TTsh
	0XApwyQIR9Ht5iJv2FjKDwuxqf1kWJrEgOIeDnc111kJYW8dogBg/iHWBku4JA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754476749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FhKBjBL0r+ZMyH7ZvDnPT8IRUyvC+7V+Yvg1xfVi4zk=;
	b=toS1IjGNfZoqRXGyiwSsAeCZYwQrk6b//DsCVNMJeLwyycx0mPt6dil7hFiSEtMNY+6HU4
	ONdyXmizynHcl7BA==
To: Oliver Sang <oliver.sang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, oe-lkp@lists.linux.dev,
 lkp@intel.com, linux-kernel@vger.kernel.org, x86@kernel.org, Sebastian
 Andrzej Siewior <bigeasy@linutronix.de>, linux-mm@kvack.org,
 ltp@lists.linux.it, oliver.sang@intel.com
Subject: Re: [tip:locking/futex] [futex]  56180dd20c:
 BUG:sleeping_function_called_from_invalid_context_at_kernel/nsproxy.c
In-Reply-To: <aJMT5DsFlOL6V+Nv@xsang-OptiPlex-9020>
References: <87a54usty4.ffs@tglx> <aINKAQt3qcj2s38N@xsang-OptiPlex-9020>
 <87seikp94v.ffs@tglx> <aIgUUhKWesDpM0BJ@xsang-OptiPlex-9020>
 <87wm7ro3r7.ffs@tglx> <aIrJipeLsGUM92+R@xsang-OptiPlex-9020>
 <87cy9gilo8.ffs@tglx> <874iusihka.ffs@tglx>
 <aJML8dcu4vu4rbMR@xsang-OptiPlex-9020> <87qzxoeuav.ffs@tglx>
 <aJMT5DsFlOL6V+Nv@xsang-OptiPlex-9020>
Date: Wed, 06 Aug 2025 12:39:09 +0200
Message-ID: <87bjosenua.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: utc4bbt9zcp1r76ht79cf78ttt1zibrt
X-Rspamd-Queue-Id: 9D5C940003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754476752-84260
X-HE-Meta: U2FsdGVkX1/myHN4APn1oUiRKoIkrJOCZ+xlHXJn3EdOkiHBJWotKS8+0DS5po1SCNQNY4uvf8s2q67Ri78c9vZvahisNYSVjOi5AVKKbTBf8f2OSrnFTBScFwCLOHqJpUJbIq5IvoBw4dX/1TGfezNpoVLk7EI06+7JSi47nj5/6T6mdJawtqbl0nPfRpD95tAKfWSRFKLp6fsvZs37IKhShyO9xJLciiRi+0f3LNqCYCZrBpqPBEb+qEycKU5J/OcLKSmELzOiiAr9uVXFHMmDLjxkjlItH8jfofCbyz8o25wAFTxNXyGZGCrDPejQCXpRVWCrcTnjuhwKWxpjcEjk/REfWX9bZeeitLwUY5ZTE/RWHXjseUhrufLkRsgQcx+8aGpdgIzSx3g6I+y20KiY6CFNWDYg6xgw/H34rD0cAN6vjMRA5/vwwwP/QNRyYGCtSl1LLTfwklOAeACDwhATVoPiI8IYCAWYztqn3AB1b+6Az+F9470WN8+HQhQKbrNPsyF0GZjN+XgY8YUDnPQvR+T+QOHH3jTQGBIxBVdy+3VpSt9ynpifUeBrMhtJZX+zw3kE9FJ10QIz+lqtJxk3J36U51Wu7WRjbEt555HoylWFux3XbsLy5qi8lTt3/KndWdxd8rCajL+OtbZPlQwWmd2LJ4gqRvjEwS04lnIqCVLLc6jEjJ+K+RMz7x8/kApMO3hL11iAKwss2cwO3Td6rafujMBnoGi24YttdGsIP+re5Gp/d4d+Y2ZzdazkIFhC6uj6ue5LYTamLmpAz4AMlN/1rHQkl1LMWV/9za8sP6leiQJ33uTDE6yIxK1MXDhSa8Iby8xWwyfRxRmvFwF3Zefhnorhlm87xo2mtNpu+lA9HIWaP3jU6kWRUtq6XALeLFKcu5YEqC7Cww4VZKxo9+FiZ0nsV3QrRLNTYC8pqZmfwmGdYdVjQ6H5xcI4lEdG+lC1tr3g/wKhPBJ
 amD1KWXq
 P2awk7pSrWemUE6Z9DEutTLDQvsK+OjyY3g6d4RX5aT/hLUvzK6DZBLM41hacQIoNvteZh831Pb3v5eGMBDpn2erHMXFk8N4FVG3vf2nAfkKnV1/aDfi0lgRFrYCsdvb2DW8/2kMtnsGx5YJ7tIHsNdNe1oqiBeeQnKjybJ8c3fOKteM1OoPdrnf4WPGyek0rKgaz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06 2025 at 16:35, Oliver Sang wrote:

> On Wed, Aug 06, 2025 at 10:19:36AM +0200, Thomas Gleixner wrote:
>> Oliver!
>> 
>> On Wed, Aug 06 2025 at 16:01, Oliver Sang wrote:
>> > On Thu, Jul 31, 2025 at 04:03:01PM +0200, Thomas Gleixner wrote:
>> >> On Thu, Jul 31 2025 at 14:34, Thomas Gleixner wrote:
>> >> > Either you make the timeout longer or try the following on the kernel
>> >> > command line instead of 'ftrace_dump_on_cpu':
>> >> 
>> >>   instead of 'ftrace_dump_ooops'
>> >
>> > sorry for late, I just took several-day off.
>> 
>> I hope you had a good time!
>> 
>> > attached dmesg FYI.
>> 
>> Thanks for doing this. Now the buffer is too short and as nothing stops
>> the tracer the interesting stuff goes out of sight.
>> 
>> Can you please apply the patch below and try again?
>
> got it!
>
> just want to confirm, still use below params or need some modification?
>
> trace_event=preemptirq:preempt_disable,preemptirq:preempt_enable ftrace_dump_on_oops=orig_cpu trace_buf_size=100K panic_on_warn=1

Those should be good. Let's see.

