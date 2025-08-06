Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E26C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 15:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CCF8E0006; Wed,  6 Aug 2025 11:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DBE8E0003; Wed,  6 Aug 2025 11:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2633D8E0006; Wed,  6 Aug 2025 11:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16B0E8E0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 11:34:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABA2FBAC6C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:34:58 +0000 (UTC)
X-FDA: 83746730676.21.81DB78C
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf12.hostedemail.com (Postfix) with ESMTP id EFC154000F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:34:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=f5UiBCN4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gz7U0UH3;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754494497; a=rsa-sha256;
	cv=none;
	b=WI1eCe9hJ3T81ULEfA6eCYlZqMfI1pBc8xGkAvQwymU+lJOrVK6pEZ1hFz+4vuxBHrESqB
	B381KABJ+ZR0ww0p7yt7dzvsOn79ym1gOzfvJB+6U4fiIjQQwDMwZr9aw8bWLOyYe6F1fj
	URa+DYtor4gzH45Odq952g1PEFgETas=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=f5UiBCN4;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=gz7U0UH3;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf12.hostedemail.com: domain of john.ogness@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=john.ogness@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754494497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IGF3vGHoaV5az/qlqBIi9OrCnbX/sgelHE61GcLMXw=;
	b=pKWCmyM0WbylQtpVgZbGe2CvSdfo2YOA2hiYvkyyRihRYTJydQyxxI39F4hUuyVlIfHuua
	nUWSeDcl36ChweV48IiKbUGvZ31SSe+GYS2CcV3wpe0OzhAb9zjbPknO8ozyFJoutvWDLl
	8biCO39RT0rS0jgoVhiA6KJjMuCs0TU=
From: John Ogness <john.ogness@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754494494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3IGF3vGHoaV5az/qlqBIi9OrCnbX/sgelHE61GcLMXw=;
	b=f5UiBCN4kJ1HFb25h6Vx7h06v5L5ZvrJzxTpOLbwmhrNc1MaPso/s6ShfglUvmMxI6TwN0
	SW5LtbRIajAIeYh91s5H8GzyaxSk370RnKmxER8I7lxJB1Loq1N+t0dZjqXKzDf/m9sH0M
	GI2C8cc0V//XB+6BVOZ6oH3qfOJTte+z83pGI4N4SrwfUR9luIns9x2D6A4YC1Z1nmw4DN
	MSgQKzsofh/u51W427BMan5xO0hRuGZNy5ZJMIVorybIWZFgEDK+6+4nB01mu9I5O2LBQq
	pJjGuMHOG3cATRWPzhAj5ezzyUYkC9O1QB80VXAWCO/6VOoJmgT3M4V4NOx2yw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754494494;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3IGF3vGHoaV5az/qlqBIi9OrCnbX/sgelHE61GcLMXw=;
	b=gz7U0UH3TfuIQPgHoA1kb6pQvMSO5JbdTOEPwixJDow34ugYEJ3hxx8YvpBtdboIdvFU7h
	s0JaK3Ju7uvlS8CQ==
To: Waiman Long <llong@redhat.com>, Andrew Morton
 <akpm@linux-foundation.org>, Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, stable@vger.kernel.org,
 linux-mm@kvack.org, Lu Jialin <lujialin4@huawei.com>, Breno Leitao
 <leitao@debian.org>
Subject: Re: [PATCH] mm: Fix possible deadlock in console_trylock_spinning
In-Reply-To: <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
References: <20250730094914.566582-1-gubowen5@huawei.com>
 <20250801153303.cee42dcfc94c63fb5026bba0@linux-foundation.org>
 <5ca375cd-4a20-4807-b897-68b289626550@redhat.com>
Date: Wed, 06 Aug 2025 17:40:53 +0206
Message-ID: <84h5yko44i.fsf@jogness.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFC154000F
X-Stat-Signature: ph9ei9y3kqu1numr7u6ojy9rad7tnr9x
X-Rspam-User: 
X-HE-Tag: 1754494496-679054
X-HE-Meta: U2FsdGVkX19Pb4xtXYQHNVtj4na0DlKlNFlqP9lsZ2xBnrNqY0E4MKGrg7wSMLcFtqWWW47vf6Gh1Ld3hDLUlyfzFRgPzKxKWew16gJKENNAwL37qfl/2FyTpZpT/Y3vNHwCS0V6KanGrAY8y6QvbE8tXBHCXfcm95u7prq+3+hH1hW7oSwXU01lDrDnhGGRANBI3Dvs0BCl8SKbFio9yJGLK5899FugJYbhbSuVDTfmTatK/IOxM/J9eLrV/Ek/afzE4+YTMbRQNhYPQ4LoiQlD7YaXffDtGmxkgHKEkQcitdcmVPAmwg9WV2EgbaG2uoQ8Gasi9CnlBMG/2E9ZUDycmR7ZwRQ/mc6ufq+gpKk/hLNzU0S98Ghw+XwHdj4p/IkQzgAo9/Tcq6i6KXZ8G3ChcxyOoDlALkMI/AaJdajHeBAWfF0vhUPZ2DE/g3AVGd+w2atpltsYXQPf/e78wwqwUDZczkEYIuHhHQSTow2D/ts9JQ6MVTH5xbQTZiMr7p8ppwbPXRqe1/rr3DWfc+yhKiwHgvYFrsaD3dnTmIu6SH9+wWIKo1J7Lecvcb22XTWDKsMQyzJYBPjkvDZsJhOaWYmtxP7mmKmXAeyhYzOvcs3SadmE1KCz6QfhzZ1OYLZ6PO8TBRth9pY9TKPOIqgoNfLPPIT30hO7quBg2MGsIuD/0DWXqChE8E/YQoyqdkGUr9+XuyTUsJPUEU4lm4xGz5a8gjPoIAoboTxLo5kS/8V3RauO33MJ0n6eIoIfljEm75cFKdlXPf2z12+AOAddrxnqZLZO1TIjFiE9pUJxs1uFkOmBapc+HJEuqdvZ/LQqabOsBMBvDibn1hH0doiMx8bpgjtsYZ7r0m+we2JBlLj44+KpnJUvszRNNGzYbSaWHb5BHzHSb/hiy+pGLzi8nGfXpW17dujZHDICxBTZ9TOqbOT3DCSTs/Z/j03RueLZxychvMFYh/EYKYo
 1ncCfbuX
 AtCIu6obBFE2gMyG9IW6qqtPFjfToB1EsYyMY9kCi6yR6et0XdfAycGwJc3LTX8RATWYBraD6mRPoZg969npH12ZsUoSUCynBm7mlg/B0AeP08hOuv+h2fIvkBbmnmST245VnXEaVPmVZhlsXKWkMveHDYAIME3CU6xiWsk8f8OEnihb04H4Qz8CmiE89EFmrhxaSPY5twMZiGrOlVLAEXR1hZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-01, Waiman Long <llong@redhat.com> wrote:
>>> kmemleak_scan_thread() invokes scan_block() which may invoke a nomal
>>> printk() to print warning message. This can cause a deadlock in the
>>> scenario reported below:
>>>
>>>         CPU0                    CPU1
>>>         ----                    ----
>>>    lock(kmemleak_lock);
>>>                                 lock(&port->lock);
>>>                                 lock(kmemleak_lock);
>>>    lock(console_owner);
>>>
>>> To solve this problem, switch to printk_safe mode before printing warning
>>> message, this will redirect all printk()-s to a special per-CPU buffer,
>>> which will be flushed later from a safe context (irq work), and this
>>> deadlock problem can be avoided.

printk no longer works like this. There are no special per-CPU
buffers. As correctly pointed out by Longman, the proper interface is
printk_deferred_enter()/printk_deferred_exit().

With the deferred interface, the printk message is still immediately
stored in the printk ringbuffer (which is lockless) and only the console
printing itself is deferred.

John Ogness

