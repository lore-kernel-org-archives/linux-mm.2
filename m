Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3AC6109449D
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 00:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8266B00AF; Sat, 21 Mar 2026 20:10:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0691A6B00B0; Sat, 21 Mar 2026 20:10:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E73046B00B1; Sat, 21 Mar 2026 20:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D34046B00AF
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 20:10:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6ECFD1E3B6
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:10:06 +0000 (UTC)
X-FDA: 84571766412.28.0A916C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id CA32B20007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 00:10:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0odt9qsk;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774138204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XYH57cjPC/sM02ZwJz09DmG2y7NAetLH2DHwAhxwow=;
	b=H4AGtfPLhUOXwAMOmdWCczWIsK/cwXu4r6k44eySS8VBchEdmGa8+dYpjWllMBVMbKUdCv
	G8nEEOp391lAuYS2fRmcg8RXy4woss0FmGoCK8KnQpahIDX+p+gVC/1J05Jm6U5xvUvUf8
	9q776HEfJXUW6Er0c3HRvMaNb2yCKUw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=0odt9qsk;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774138204; a=rsa-sha256;
	cv=none;
	b=WE8BS0aFYIeP8F1GaaRH04FBOZNzUwrXffThS/OsinS6/AMSEOuxTdhgG8KipKydGtWkmf
	AqyMi/kVcX4ZwP8AvCDS1nkNmhADK9pBSaWCoCwpJKWNEJmdgJ9Y5bm4kGj3A8j4JXKuDT
	HRFCnz9cmYw+5nx5ff/ZHuA5LyZyM6k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F01A60142;
	Sun, 22 Mar 2026 00:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F32C2BC9E;
	Sun, 22 Mar 2026 00:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774138203;
	bh=hgkUMA+D2Qwkwv9VIl4EeqfKEgsJF8OR3J/kh9YjtY4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=0odt9qskdT0KVfFDu2lB1AstQjY0/yTp3t9erG637/acag9gjkBcAroCrGjXaphX4
	 yCeeiCY1laOyYchoh7XQ+nX/Tx1bbYVIk8osY5vBFqLTx41EfQ8bOyKTCTZTWtrRB9
	 HJ6WYRiqeB41Cr1Bmaug0k9DGtIfhba8wy+dVbww=
Date: Sat, 21 Mar 2026 17:10:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>, Tejun
 Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra
 <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon
 <will@kernel.org>, Boqun Feng <boqun@kernel.org>, Waiman Long
 <longman@redhat.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] locking: contended_release tracepoint
 instrumentation
Message-Id: <20260321171002.013ee5a9d8c789e2a4a53afc@linux-foundation.org>
In-Reply-To: <cover.1773858853.git.d@ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CA32B20007
X-Rspamd-Server: rspam08
X-Stat-Signature: nhfsm3buc13jc19x3c75ysmdrzgwco6j
X-HE-Tag: 1774138204-213900
X-HE-Meta: U2FsdGVkX18LIlQTozfLI7N9v3pbgJwVqk0FZgbb0hLMFBU83Xpasmr++lDxFkHTclw8RvB4ltzpdwJfhhTQQAEP6K5RfUkBnY+RkgKWHyVrAfum/Tnx92r74+Al6TA24jX/Bvb3x4ltQd+Jf7103/1V3BntEMs2T2H348H9glJ4Fr4UdqgyDelaVfxo4OJ4LOPwKhGyVOc9jti2VUEah1idmVzdTlnglEI9EUwHRlOfYaPwItzcpfCtR0usqzfs7Wv7nLGwlAi0QSVijcvA2vftKB2cGcZ1xT7amLrve0TAB9jhyfFteOloaPbc9AfZrwtdi1b/Y2R8bqEpZwz6RYfzCedDq7JpLeFG/O5wti94kjUDCyqxb4ceGKj+5GBE4g6zcQjVD3KMX4mcvsSWIa0B89JMp5KUeL26/His+jiu0skceuRgO4gWIzuOnO2EGs2kWPyWKptG2Qhs99dnmuczNMo5e0cmorddCspykW6071FtrMd7ymfmXX/jLNmrpRZmI/4pULuQT+5q/wBlYhIVilVZTDwpy2D5PTVWN3Z1gexwdCiyhJs2jbK0xBrbVUwHOQkbo5mqy794psdpv0CzNSdbDk7iTf8I1Rn4Mv9Q/tG2orih1VfJ6lDHB+LWAIXUZhTp1gSHck1WQv2/xH2zlrkv/VVguOA0WKUlMZE3htgcpDvx7+qAfLNn64jdE6a6H7caLIYbi8OJc4dhULRSV3819WqrOopGN+YXldqpztiy+9eKvhVD3xTUa4/GcMkNOTVerWTSwBQsA4nvaPz/rjP+pW3jeGoFS15snBINDxN2Eh8NefIsX3SWHOTr8rEJ0sjALLxyc/yehu7Scundhn0kZ51Q4iS2TinmUpDr6S15wLxR0uqlEDDW3YsDzAJmps6CINV1qtCAVFRmXuj/d/Ofn2m7Zuhf5gFja7p3kHOBqtCNE32IPysba/apH8fvEMy2ldu0/iBnjHj
 x7s3o7bt
 LhK5n1uovEvVM5aE1jYNTzkeiCyloXVdPFVDb8XL9RLSJEOvvhXGZFCDVzbAigQfuLMGNgEZl6JXhhQvB2f7Tz6MMli+p0LXg/3jZJm1J3qnLP6UcUoEhtE34RbkgL/wlOQ1UdD6U5wxQDj02UtDuLcwRYWNeMaAJJRA7htKXHC6v7beEWzJegFgPdOCpoUCPDL2O04fV1aO8pFX8c1V8D1wl6l2jX+3prdH5hgGbFKOWZUJCWBtjvuNZKClxTgbJNJem13WvEJNJL191SZIi9qUjoJCna5oF+F5t0l4URYR7i9CrFrArw2PQzP3ko9R2ps/G4ptkAAg7CcmCUvNMgvxez/NBbN/8YghWartM0zph1CeNoY/4rPEBmLCOajgBdyp5JMg4JNyc+9leGA5hYzqOqj7vsScL/HLy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 18:45:17 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:

> The existing contention_begin/contention_end tracepoints fire on the
> waiter side. The lock holder's identity and stack can be captured at
> contention_begin time (e.g. perf lock contention --lock-owner), but
> this reflects the holder's state when a waiter arrives, not when the
> lock is actually released.
> 
> This series adds a contended_release tracepoint that fires on the
> holder side when a lock with waiters is released. This provides:
> 
> - Hold time estimation: when the holder's own acquisition was
>   contended, its contention_end (acquisition) and contended_release
>   can be correlated to measure how long the lock was held under
>   contention.
> 
> - The holder's stack at release time, which may differ from what perf lock
>   contention --lock-owner captures if the holder does significant work between
>   the waiter's arrival and the unlock.
> 
> The series is structured as follows:
> 
> 1. Remove unnecessary linux/sched.h include from trace/events/lock.h.
> 2. Extract __percpu_up_read() out of the inline percpu_up_read() to
>    avoid binary size increase from adding a tracepoint.
> 3. Add contended_release tracepoint and instrument sleepable locks:
>    mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and rwbase_rt.

AI review:
	https://sashiko.dev/#/patchset/cover.1773858853.git.d@ilvokhin.com

