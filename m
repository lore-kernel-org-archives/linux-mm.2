Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D22CDCA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 23:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CF29001EE; Thu, 14 Aug 2025 19:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653569001D5; Thu, 14 Aug 2025 19:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590189001EE; Thu, 14 Aug 2025 19:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 47C5F9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:13:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 061D0836CD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:13:50 +0000 (UTC)
X-FDA: 83776917420.23.1F82810
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf12.hostedemail.com (Postfix) with ESMTP id 43F7C4000A
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 23:13:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pONeTZiZ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755213228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w6k5/Q/shK0VDN0eaW0mLPiE0MlWp4ZCoi0cTl4gBmI=;
	b=qgKD8uyh46NCOzplXriOKc56Cv4qLIUJ7kDQurSl9sy99hFMP1jFvgYoPNzlhHPhc/WTv+
	EiprWkbvKdq1zsztKF4605Sku4I6Uv/ImesRKOMXD5Bu7NBRo2ZUTvHQbgUM8V0L+2FOLy
	t5uOO1KidAyVQiib713aip945qoXfBE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=pONeTZiZ;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755213228; a=rsa-sha256;
	cv=none;
	b=sPPD9UbxIkwiE+99W9LJDfAJi1drH60sOdVh98ORcOoABKqX6MZ0cPNi9m4CCkK6wCVFTu
	vs+oMB2Vt/jSZQCk88BRt6UiqCFlctNhUcZqPnduvGBXLQ4RkzwaCAEvTYYltWfPt6Pvr0
	gnIrzdXYBhZ89rAREnVlgLD0NiPxRzA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 635A15C5DF2;
	Thu, 14 Aug 2025 23:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602FEC4CEED;
	Thu, 14 Aug 2025 23:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755213227;
	bh=QDuybNx730xQBT3wod57laf9u9iTM7rHjUvW1T2v/A8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=pONeTZiZjNbzBFiiZPEIM2iR6kPyC71xQPFcDNY7Xl5VTFDYMMwzfV6aeXw6EYmIg
	 QN8UhlLAm6z2zfYK+Y8bSzg1m19jWmKEVpgCJlyQdJvsXzxoziN2aShH1YGhk+Az5v
	 YwJI3SQFXeUZEUmPp3C4zuamATd1QhSAuH7/1bvc=
Date: Thu, 14 Aug 2025 16:13:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <zhongjinji@honor.com>
Cc: <linux-mm@kvack.org>, <mhocko@suse.com>, <rientjes@google.com>,
 <shakeel.butt@linux.dev>, <npache@redhat.com>,
 <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
 <peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
 <andrealmeid@igalia.com>, <liam.howlett@oracle.com>, <liulu.liu@honor.com>,
 <feng.han@honor.com>, Joel Savitz <jsavitz@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>
Subject: Re: [PATCH v4 0/3] mm/oom_kill: Only delay OOM reaper for processes
 using robust futexes
Message-Id: <20250814161345.b2ddf7120dfcc420c3199e67@linux-foundation.org>
In-Reply-To: <20250814135555.17493-1-zhongjinji@honor.com>
References: <20250814135555.17493-1-zhongjinji@honor.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 43F7C4000A
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: cwrehhqjswbhskh3yhihp66effprr4u8
X-HE-Tag: 1755213228-121655
X-HE-Meta: U2FsdGVkX18dboHEa6L+He6z2Pb4OElWRNY+OrXyniElKtukiZ7M5lRAM7foLXiq7tU3QKBiEhfOQkR43iQqyLgmsoWFCQgirh0ssN5/4tvFxFG0FNP3oaY0HCTQgV2+DcrZ7QlODAFK3erhA5h95Lnh9hiHuEeBsWeGysEIv5iP0W8vy/01cIBN9BuX0AUgVuqSyWKXNiCAX0NwbtXNv+UxL5y0eT/cat2fjEIW9z3JX0gmjFDugFph063puPPIeKme17YS/c6ApLMsQmQG2ly4o4soKDJDbm2gG9ORj9CwPvKmZ8rrTonX4nk+KunZxGpPwGOB8Fc6DuPZjV7Pe63DRFq3Z0iZQLSiCdcYEXgR4BikqHJHA5N7k7t8iwgQwNyWNdPQu7UH+rzH0UeHTsRUURc4WScbwYqqqup4GD3btvEDx+Kb74vbhERathTU7vHU1v3SvQSNavf04iBRJ3cJZzVldxnZvXzLX8oiTcGg2L3qmAr6Dx7ACzXHuS/cySQg4HSxr9D5aJwac2KsK+Uj9zgRrzR8cqQ4ZZ/tGOiy6MXqsTDCJ2p8IBAmB+Q+ER2hGSzuEHwtOWNsV5WKJg+r7S2Fl73DAMobEtOiHmo9+7nG7zufJ5GhWD/O5/PsycqThvsr0IRXAteJe0WCvJUGTFFB1FlQadekUHO6HGw4MsOukBDgxYkQGrqMJwaW1OJWauQsLrhgMX4axxmxQzh1fswkCd+YV6ZD0DJtGEhZRq4rNRdvfxewd9W1IxAkP/sINKXfs89mvOuGErQpdRNMShkZ+Dl7MAwYjs7hN8M5S8dq1rrvGQe/hAJgDiY8xQ6wxT2T/np92vbLjLH7uzLsCmrQ8F29b0VaYCsrJPzUsATWhYxnu/bEwlbaf8EMmrIRIhVuO6enHpdKXihAvvCZYYdYm9xUcNm9WX85O9dcDnDXahMv4PcizQIuqSZyqtTK2dW9hj8oxCF9BI6
 giCUKJsF
 xcUXaciKcs629EtfDzRiEJiXcs20yyGcDgfpzELRsHIIMuq2IwP2qkj2IiJDCwIn4l+Jb9rV44XuYfFmiyUq700e1OR9KaEuwG7iy62BuKDWO5tfB8iwaX24vXq9xgmVydIRNrrW2ICiLpFJVd6JCFJ+Svm0XKz3FUOvVuIhjmHZD3RQK/REkc6RU3vtIWrnV6M8E5CMLf7K0JFp5kGMllEijNKJcNeS60gxuYRUKitpSIYCWageRAXzwX/+thc8K32CPTDbNSnpNaCZ293nJzsy4isf885nzzf0IKmztNV9WEqkuGwSAJbtDkbGQhiD9SVfMHllwRsZqrpmgTYxy55kagEhmLrvl0OpM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 21:55:52 +0800 <zhongjinji@honor.com> wrote:

> The OOM reaper quickly reclaims a process's memory when the system hits OOM,
> helping the system recover. Without the OOM reaper, if a process frozen by
> cgroup v1 is OOM killed, the victim's memory cannot be freed, leaving the
> system in a poor state. Even if the process is not frozen by cgroup v1,
> reclaiming victims' memory remains important, as having one more process
> working speeds up memory release.
> 
> When processes holding robust futexes are OOM killed but waiters on those
> futexes remain alive, the robust futexes might be reaped before
> futex_cleanup() runs. This can cause the waiters to block indefinitely [1].
> 
> To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1]. Since
> many killed processes exit within 2 seconds, the OOM reaper rarely runs after
> this delay. However, robust futex users are few, so delaying OOM reap for all
> victims is unnecessary.
> 
> If each thread's robust_list in a process is NULL, the process holds no robust
> futexes. For such processes, the OOM reaper should not be delayed. For
> processes holding robust futexes, to avoid issue [1], the OOM reaper must
> still be delayed.
> 
> Patch 1 introduces process_has_robust_futex() to detect whether a process uses
> robust futexes. Patch 2 delays the OOM reaper only for processes holding robust
> futexes, improving OOM reaper performance. Patch 3 makes the OOM reaper and
> exit_mmap() traverse the maple tree in opposite orders to reduce PTE lock
> contention caused by unmapping the same vma.

This all sounds sensible, given that we appear to be stuck with the
2-second hack.

What prevents one of the process's threads from creating a robust mutex
after we've inspected it with process_has_robust_futex()?

