Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41827FC72C2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 12:10:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963936B00C3; Sun, 22 Mar 2026 08:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 914986B00C4; Sun, 22 Mar 2026 08:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A196B00C5; Sun, 22 Mar 2026 08:10:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6EFE46B00C3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 08:10:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C99941B8A1B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:10:32 +0000 (UTC)
X-FDA: 84573581904.26.E55FE4F
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf03.hostedemail.com (Postfix) with ESMTP id 047272000D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 12:10:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Qcl0bP2o;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774181431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZjLCTldoHNqdz7JJ8YsS0zAIrQjXi1m5vYpjv5kdFM=;
	b=uNt7XFpFdQZjJP7nORPOzEsh0OmuwSdSuBKo3FZsrnTUDSLY9gE2H3mFj+kuaWpytunm3e
	SxW+qIV8z5zN8RLs+orX7rs48j/op6TIJa/nAItwS51xicdjSAflkrPmVhJeyRuJjJRU6L
	3B2j3qN4IEyYe8srVQ5nd4ow0r/SAG8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=Qcl0bP2o;
	spf=pass (imf03.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774181431; a=rsa-sha256;
	cv=none;
	b=F+YqywArE7p1Zznq3RMDU7NOSlGYaFetfc1WDqRRPzep1FvSG9UYuXQAdifoLOTF9wVWir
	hwdLAOF0BOxPBvZrfPnA7oKOzhEKGkEjhCljtt4QM2mR+L4htHxOFySoyNY/4dms3Quksk
	eFEeYZ3ji2wq+0esRuttfUH4cpVBeZc=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 10454BDA4F;
	Sun, 22 Mar 2026 12:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774181429;
	bh=LZjLCTldoHNqdz7JJ8YsS0zAIrQjXi1m5vYpjv5kdFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Qcl0bP2oBpatlqvNm+yjEXVuc6UoiIXQkM5IbecThXTA1g96cn8Xaky6uOovqm5Ei
	 O98Z5/R2ASEx/w1YBH0Ha8pC/WHJymTUxEgeIekclEX2xtx7ttdYBECVkOx6epzdcb
	 bv0yTzJOVwvT8gotogq/m0+/EYJ/3o3NJF3ZjhDY=
Date: Sun, 22 Mar 2026 12:10:25 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>, Waiman Long <longman@redhat.com>,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v3 0/4] locking: contended_release tracepoint
 instrumentation
Message-ID: <ab_cMTd7yN36kF15@shell.ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
 <20260321171002.013ee5a9d8c789e2a4a53afc@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260321171002.013ee5a9d8c789e2a4a53afc@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 047272000D
X-Rspamd-Server: rspam08
X-Stat-Signature: wygdu4cx7j3aih4b4bzfjjg1magueb3y
X-HE-Tag: 1774181430-613219
X-HE-Meta: U2FsdGVkX1/QX+NCrto/XwKbnLw4Vsr1p1EiQgTjpn1tBWCTY6MFmuwQeauODfvI7IZ8mghvvLvWjZIPgP1Yxd9jvwpA5DbABmWPvP1TrZi8JbWeMdj/f2A0m5K6JQVuBJp01h2Kmoy+D+nKQ/1r/ZbX+b0sXhqrCAZ3shJff8tFfjfP9JPdyeWc+FzCuUR4z6Gi9ZfvR/sOf/T8XJz1vbB0AkhQX0RpGp+ftRWjAfBHmzFNA+SQ5g4h8kA4e66cktGqpTevDsLmr8HMkbP8B6+8RwYBjEGkIFWN4+4jlU8MCPSVvAIEaRA7UnABEd3A09P/pRAnYoXngXqh1O4xyNLlJuMjQPqrTWPcy+/jPdhXm4Q2ol+gYg9j0we0S7wETA2XrKxDBqxcr5p/W5wR3qI9zOh/Lp+Qt91nXJZe1WyP/ygWfsWNKWc9jQ69h6EFaf7q5ot9dYwLRdMG2u+Fy2F6EJLyL5Nd8azhgEFx24ByjKsddjeDCnJsb+CtSAv8XdhMpISZ8XNk0gAx36NXZ/r5hZ9wLlxVw8sdToBxsH9S3KBzTfcXe1I2c85OgXs4F/PQddLd2FnwOrBb27Unq5gT/45Sm6h03gwhHH8PEIokRc3WTKoTf1gXY55qBYFZyIFupveJY8YMpZiP2pcpcv3CwpD2FtycDNzTxBV4AkRzSKdMwtv7BTy3iW3RHKhSQm8M6NT4xQdb4xX4pHJh81BG1/TGs5hESUIQKh46/CtEd8OwVCu9/MhFcMltNy3risUTrguQYSmGwQmWh/Dhc243adhGg8Bh0Iw8db4HMcXc/9DLBN0UKw+EPTspfQjBqqFRuCTEQb41Cn3FSeAvDIVNqPf2qup0rPh1ZCqw4QORdOuxn4LZVq42SZEHwB0MURECMJb9kiUBmMdkHSgF+6zYhG1aABBlS4+dd61UpQJBOSJEz8IRrKdNWAt7PPHlNFWYA7jCIVUBo6Apjlh
 Z7gzBkBb
 vBqeLxz4xjZOPKORQPmvWrEMRApBMOiZFNoEqohRnJ747ZfZ2RZj73ufZrwVHUQ4nnRZOxIIq3+ypb0A1d5eoSZnmzZT9iiuivMPbITHQX30vAKcoBB3tWT2AYcSWm7wW26HPJ+sjNbSb9ZD8Jp1zOBF9tRkFm0GycrFXzhSTsrgV4SQvT/XRMlsjIN2EbqaQKzfcUi7nQLVqAAvHF/+PfLCGJ7sJA1EMPSVS0zJSKTWzqSIp8FrY3TSV08eUV4utC45QSIByWWl+M2KrbmOwhKpd3c4BLC74HRcHg5Dxw+I4DqJPeZp/B1UscJnK1me36puhO8ZW/m8DD7MgY81WrpZukA8W3axejQ4gOqpsZQVOcIhcl+ODBgIcmcloEPYzR/GbiOX0ws4EtqRgZCQoItyhlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 05:10:02PM -0700, Andrew Morton wrote:
> On Wed, 18 Mar 2026 18:45:17 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
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
> > 
> > The series is structured as follows:
> > 
> > 1. Remove unnecessary linux/sched.h include from trace/events/lock.h.
> > 2. Extract __percpu_up_read() out of the inline percpu_up_read() to
> >    avoid binary size increase from adding a tracepoint.
> > 3. Add contended_release tracepoint and instrument sleepable locks:
> >    mutex, rtmutex, semaphore, rwsem, percpu-rwsem, and rwbase_rt.
> 
> AI review:
> 	https://sashiko.dev/#/patchset/cover.1773858853.git.d@ilvokhin.com

Thanks, Andrew, appreciate you sharing the link.

The AI review looks reasonable. I'll go through it and address the
feedback in the next revision. The kernel test robot is also reporting
failures on some configs, which seem related to the Sashiko comments.

