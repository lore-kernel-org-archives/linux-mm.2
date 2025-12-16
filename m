Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2E28D609D7
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 18:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3EE56B0005; Tue, 16 Dec 2025 13:01:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B336B0088; Tue, 16 Dec 2025 13:01:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3E836B008A; Tue, 16 Dec 2025 13:01:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1BBB6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 13:01:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8E15E1A07B4
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:01:33 +0000 (UTC)
X-FDA: 84226101666.25.D9BCC81
Received: from relay.hostedemail.com (unirelay07 [10.200.18.70])
	by imf18.hostedemail.com (Postfix) with ESMTP id D278B1C000C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:01:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765908091; a=rsa-sha256;
	cv=none;
	b=MERMQ5RT6mYoUdJExQIau0Ohp3PJ6jnDYRaIrOXVVxdQyPnOP5CutaRqrwNN0NCaNN/iUp
	Md6QVH9EImgK28pcjwnL/38LZzNsG86x6prIir44eQdi27USRB9YJDUdIIhOqS+X1Unkqd
	1TOBQtMvdkoL/2DHvtz1XVoRUSFRs/A=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765908091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KG/wkYkFY3DUlBmQbhXcbLHFMaIsIXpJoizUMHOaAa4=;
	b=46euL1o0LELbevxp4njrSyLKLFTyxTL8JVDnkFb5YUpct3PdYAKHp8O+w1QBL15XIJHp1D
	pLQJGIt+W442F9fwgVI2MxuSSV6vxlsRiy83rq8ckUUHAs1lDqPzdrlZSXuKJ9rF2di/6S
	eDT6bIxAySgpJ7GNAK6UsgdokFoW02g=
Received: from omf12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E567416079A;
	Tue, 16 Dec 2025 18:01:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 262161B;
	Tue, 16 Dec 2025 18:01:29 +0000 (UTC)
Date: Tue, 16 Dec 2025 13:03:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm: vmscan: add PIDs to vmscan tracepoints
Message-ID: <20251216130302.5202ca81@gandalf.local.home>
In-Reply-To: <20251216140252.11864-3-tballasi@linux.microsoft.com>
References: <20251208181413.4722-1-tballasi@linux.microsoft.com>
	<20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20251216140252.11864-3-tballasi@linux.microsoft.com>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/gSVUVC1Luhd1KKN6bim/ZsiMZToeGzrA=
X-HE-Meta: U2FsdGVkX18NhAw5Ps3xOJyawPzAkuUVlBj4w4fI5r3yBkKYySUpsLuNVLyYeIt95ZWS8JjABl+wHYKJ5QCqeGuK684kXcrRNodJGid6oeq0Qycggl2j1SN5LgsHkN/VSUpQHDzaGyjVmHaAaaJmbmkFjBFH4ypK4tpcvEJs5pLMKc/SV1qmJWcOp1lgrHZv2lui4aZDnIfuyh4Kw4hApUd02RbgRV99rfWOeAwy2VsxafLHyJgRSBvPVpavRoJnVk+BdIynCNTwPAxxfJ8o6aVJZsLiI3mYIBlfFzaq+NeNzmR4Pqo8mLGX7DXpZ+KxevonZXSzFgSvsWmyeSGrB7sC3QJFIxH7
X-Rspamd-Server: rspam08
X-Stat-Signature: 8khqf5ot3mwjoeino3croj3cat4yjrky
X-Rspamd-Queue-Id: D278B1C000C
X-Rspam-User: 
X-HE-Tag-Orig: 1765908089-601784
X-HE-Tag: 1765908091-345316
X-HE-Meta: U2FsdGVkX1+Q6kBugYNvuecvdfPXEicKR2blEWEBxIK78/6Z3qOSc8f+c20jFccrsdka3AIukyzUeYQDmUw41nE+8IikfQdIETdnfJLQNhTOiZ0KsMG6NSPfzo0zxrSOfuDG/g0kYWiBtc3qJe1l5B8395r+jtgbtN9M3xZMiFUIGXmTXthY7r6wDA2N12RYjWJ7Zj6WLwoqhvH5+cMTgDdFNoS6tkYTZllDtUe3IkvkoOIh9+fULC9GVITCAAHX4+cvXvkX08vn1uoObRy6tzeDkLYesWgOswEvJA/zOvW6A/682akz2eAjsVJoBVCn7kuxf+7cwEDqtBhD1JEoY0C327zKB4KkgXc69DBgZ5rJBNs0735XfcPH7ptVgahAbkeAsDsdT7BBI9idKmvuWLaKHPtXl1htP59MQqg3y0KWtD+3ykUNItyXIlcIx4Zjlxz2rlNuyWM3IV90guV+i+eTA80P+yYCPRwJyfDJa7EzqZ6+auV+6lrHUZi3X29VMYI8YVTdosN1M3GMzj3OhoPlEPnx+5Pmwa0xAH5NU/P36zMkONQ6Shq5+NTkSZASDIVa6ickOdq8T7Ey76nOkXo3lLb+1MuHHngbHW72knzrMyLx+k4nBCAeRL6eHK9ZE3IzslrXDSxNnb2/7l0XJSaXmg6QTQzCn+N+Ajdrk3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 06:02:52 -0800
Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> The changes aims at adding additionnal tracepoints variables to help
> debuggers attribute them to specific processes.
> 
> The PID field uses in_task() to reliably detect when we're in process
> context and can safely access current->pid.  When not in process
> context (such as in interrupt or in an asynchronous RCU context), the
> field is set to -1 as a sentinel value.
> 
> Signed-off-by: Thomas Ballasi <tballasi@linux.microsoft.com>

Is this really needed? The trace events already show if you are in
interrupt context or not.

# tracer: nop
#
# entries-in-buffer/entries-written: 25817/25817   #P:8
#
#                                _-----=> irqs-off/BH-disabled
#                               / _----=> need-resched
#                              | / _---=> hardirq/softirq   <<<<------ Shows irq context
#                              || / _--=> preempt-depth
#                              ||| / _-=> migrate-disable
#                              |||| /     delay
#           TASK-PID     CPU#  |||||  TIMESTAMP  FUNCTION
#              | |         |   |||||     |         |
          <idle>-0       [002] d..1. 11429.293552: rcu_watching: Startirq 0 1 0x74c
          <idle>-0       [000] d.H1. 11429.293564: rcu_utilization: Start scheduler-tick
          <idle>-0       [000] d.H1. 11429.293566: rcu_utilization: End scheduler-tick
          <idle>-0       [002] dN.1. 11429.293567: rcu_watching: Endirq 1 0 0x74c
          <idle>-0       [002] dN.1. 11429.293568: rcu_watching: Start 0 1 0x754
          <idle>-0       [000] d.s1. 11429.293577: rcu_watching: --= 3 1 0xdf4
          <idle>-0       [002] dN.1. 11429.293579: rcu_utilization: Start context switch
          <idle>-0       [002] dN.1. 11429.293580: rcu_utilization: End context switch
       rcu_sched-15      [002] d..1. 11429.293589: rcu_grace_period: rcu_sched 132685 start
          <idle>-0       [000] dN.1. 11429.293592: rcu_watching: Endirq 1 0 0xdf4
       rcu_sched-15      [002] d..1. 11429.293592: rcu_grace_period: rcu_sched 132685 cpustart
       rcu_sched-15      [002] d..1. 11429.293592: rcu_grace_period_init: rcu_sched 132685 0 0 7 ff
          <idle>-0       [000] dN.1. 11429.293593: rcu_watching: Start 0 1 0xdfc

Thus, you can already tell if you are in interrupt context or not, and you
always get the current pid. The 'H', 'h' or 's' means you are in a
interrupt type context. ('H' for hard interrupt interrupting a softirq, 'h'
for just a hard interrupt, and 's' for a softirq).

What's the point of adding another field to cover the same information
that's already available?

-- Steve

