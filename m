Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE14CD98CE
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 09:57:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A4276B0005; Fri, 12 Jun 2026 05:57:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8064E6B0088; Fri, 12 Jun 2026 05:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F56D6B008C; Fri, 12 Jun 2026 05:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5EFBB6B0005
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 05:57:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 115B41201A9
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:57:25 +0000 (UTC)
X-FDA: 84870808050.15.0DB1339
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3358D40002
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 09:57:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZOah2sde;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781258243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=40ldlKf5NOiyVD+LSgw0DbXbrN4Mt4O2B8RW5UMcBu4=;
	b=JJ54UhBAtnXo84mF1Qxd3bun+U3PS9CgDj1SfgPN8X5Fslc0+ZgFtBrLnlAdYSld6ARvV3
	Sncxxs8IEuXtMxOKAX7vd6Dxe6UkD1NLwca1gz0R/8WYpEhDuUjAbBj1liy25BZ96GxOpe
	pbsaNPj03KZ1BOdt7Nn7xfsVF81pImY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZOah2sde;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781258243;
	b=qu97ukUAkvbHv77bxcRKgSBj9oM4vIj0t7Q8iStN5j7fAh4dGTukmJPo3j5Uc66lukovUx
	Yu1NM9bvvEfmK9m9u2sHtr0bASxHt70U9oWm91L1zHlwh8usnhT0BHLDKS/SwtPB0W++7Q
	qPBqvJwDQ6/NJFWtfF8G53imkLZ/cJg=
Message-ID: <6bc446b7-8e25-4add-9d72-a3c9e9191533@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781258239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=40ldlKf5NOiyVD+LSgw0DbXbrN4Mt4O2B8RW5UMcBu4=;
	b=ZOah2sdeCuUGurCIybhtURWxH+ixhU/M4kIZymHrTnh2TYnA+vn/hWbbamX9WGdrRoOPmJ
	o1axy3sETPr0P5hOR2ShCEtWCvLO+HIgHTT8WummMAqttk0zCGfJazkYvXTou9ClxrSeZb
	tVoYqx4oHxW9/Y2yvGuQTA4YT+eKUDw=
Date: Fri, 12 Jun 2026 17:57:12 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev> <aivJ5Dv0hAQ1sJu1@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <aivJ5Dv0hAQ1sJu1@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 3358D40002
X-Stat-Signature: h3agmqfbojk8h1whj8fxsauw9cntm7sg
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781258241-486695
X-HE-Meta: U2FsdGVkX1+RFoyI4H94Qbxsjgi7JKrpQeu5vwuP50AyfDQdoBoI3j3IuPF+fKXfk8yvv389zmnynjmywkGCPjXWHQuG7Wv3JhYMMP54bWgUUsBDSxVMS6HWqajUYHQdQYJVDDTUk8ZmRglQWsxIwM80GVOlusKXKQZBEYeTFWrdDP5FaxOX+RCeT8CoRKQVs5+oQribEzrhy5JQMSf3cdEDUJKJLjszpeUk+p6tL7hL97Wr+IvU2+oQt3deowrHqMg8GaZ36fEqrRX0dawcY1hIdnMSy+aOJoivgSUXLvtIzKDBxLdUgQ4JZJbxIyo9vLn58yTePh+pMsZVPDOsCPYMl+LjBzywkN9KDvX4k7LgqOs78IFw+75wZ5pzgHle3PMFZK5N4yZtjXQOmhzi4FvboPzJDCPWcM4GlKUJ/AHqsvc8mdsC6XwCI9syLlhCyvEzXINgMAAPogv26SlFCOpZRkjG4dniR7okqN+iTKgzPsn/nldIi0GPMTGw3wBJjcLR9iMVfpEu42i3pfpSrXPGrVOTj645vb/FZm7h+/NXsy+viUlGO4XcKoKoVlHACxJtOd9J8DGqIRRmhURbEPcFn8tqsy/VePIPBPsHsscRXpaCTna9/UbDsx1cUcaiqCGQHD270kvo/OY253fqW9wwPxq/m03kJMkskwUCkHPrfyMLsTp+AVqSCOE2wGxu46kqAUxHtr+mX5I1TXlfkKy99+JcxV+lNiiUFm/zfE/5Y2a11W3ZR7Uzko4Jt2XRVxABoUq7yd/AXaTzPI12zxFuhrUUvQsx5bWj5NnNDQ2LZYM49ZV0iop+ITkYAAFSX1z9uI1B/uPJynRiw7wH/kYkQdiiYb34xKd6MMx1B/6S5HhUO3N7/2ijPgyZ4ujlqUk8by1+uCYaNCIq9XfaViGcdwziLjBfReW0eUnh7GOT9gddqAJgdy+2YIBlbG31rieMLlvSrXBYBMMZiDY
 ucxcwyh7
 DssVys2Qj/WAdumFA3HSzfRyNEXoP2K2/CbRrCUCR6bcXYv1Tl0THnoIBS6WN53v+XGgFvcWM5jTkyRKTdYPNCN3876nY9gjOLwos11IYxjAH5ThMzBeFQqOSJzkJbMne5kCdW88cSIz01b/FwM6C74CfujOlfRhnoH/WshIjvHWkvC69IY2xAZ62ioekZQn2ZjTnXv/mZRus5LoCZV0Oad5ZPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/12 17:09, Breno Leitao wrote:
> Hello Lance,
> 
> First of all, thanks for ther review, really awesome!

Cool!

> On Fri, Jun 12, 2026 at 11:16:05AM +0800, Lance Yang wrote:
>> On Thu, Jun 11, 2026 at 05:45:00AM -0700, Breno Leitao wrote:
>>> kmemleak_scan() walks every thread and scans its kernel stack under a
>>> single rcu_read_lock() with no reschedule point. On a host with very
>>> many threads -- amplified by KASAN/lockdep in debug builds -- this loop
>>> can hog a CPU long enough to trip the soft lockup watchdog:
>>>
>>>   watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
>>>    scan_block
>>>    kmemleak_scan
>>>    kmemleak_scan_thread
>>>    kthread
>>
>> Neat, good catch!
>>
>>> A cond_resched() cannot be added directly: the loop runs inside an RCU
>>> read-side critical section.
>>>
>>> Split the scan in two parts:
>>>
>>> 1) get the list of tasks (with RCU read lock) in an array
>>> 2) run scan_block() for the tasks (with cond_reschd()).
>>>
>>> Is it a sane approach?
>>
>> Why not use the kernel/hung_task.c pattern here? Seems simpler, with no
>> extra task-array allocation ;)
> 
> I've looked at it, but I am not sure we want to break the loop mid-air,
> that seems to increase the false positives, given we did a half-baked
> scan, right?
> 
>> Could break RCU only when resched is needed. Pin the current cursors,
>> drop RCU, cond_resched(), take RCU again, and continue only if the
>> cursors are still alive ;)
>>
>> If either cursor died while RCU was droped, stopping this scan round
>> should be fine, IMHO.
> 
> I am not sure, this is not the same as the existing kmemleak_cond_resched()
> raciness in the object_list loops. Those iterate the marked set, where a miss
> only means "this object isn't reported until the next scan" -- under-reporting,
> self-healing, and the in-tree comment says exactly that.
> 
> Dropping a *root* mid-scan is the opposite: it makes *other* objects get
> falsely reported. So the "it's already racy, bailing is fine" reasoning doesn't
> carry over from the object loop to the stack loop.
> 
> If we go this route, the aborted round has to suppress reporting, reusing
> kmemleak's existing "scan was interrupted -> don't report" path:
> 
>        if (need_resched() && !kmemleak_stack_scan_break(g, p)) {
>                aborted = true;
>                goto unlock;
>        }

I'd expect the normal case to just drop RCU, cond_resched(), take RCU
again, see both cursors still alive, and keep walking :)

>        ...
>        if (scan_should_stop() || aborted)
>                return;

And yeah, you're right. If we do lost a cursor, bailing out and
skipping reporting fot that incomplete root scan should be the
right thing, I guess :D

> Then an abort means "this round reports nothing; the next full scan
> reports the real leaks" instead of a false-positive flood.
> 
> On boxes with very many threads, where the stack walk is long and
> need_resched() fires constantly, so the break helper runs a lot -- which makes
> aborts (and thus fully-suppressed, non-reporting rounds) plausibly more than
> "rare".
> 
> Since each round restarts from the head, the tail of the thread list is the
> most likely to be perpetually skipped, on exactly the workload this is meant to
> fix.
> 
> The snapshot avoids that by scanning a complete, similar to what we have today.
> 
> Anyway, I would love to get rid of the array, but, I am not convinced that
> dropping the scan mid-air will not cause false positives.
> 
> Thanks for the review,

Cheers!


