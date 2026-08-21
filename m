Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D00FC5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 21:58:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DF56B009B; Fri, 21 Aug 2026 17:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF64D6B009D; Fri, 21 Aug 2026 17:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32646B009F; Fri, 21 Aug 2026 17:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A07016B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 17:58:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 205E81A028A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:58:13 +0000 (UTC)
X-FDA: 85126640466.15.58F13AB
Received: from latitanza.investici.org (latitanza.investici.org [185.218.207.228])
	by imf24.hostedemail.com (Postfix) with ESMTP id D8E62180003
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 21:58:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=ftrselUK;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf24.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787349491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=huZrz/6EvjhOI9pDVmyDHIIvpxO8bx9xgXE/fvQ1yO8=;
	b=i9zpjvonekbv10LJtZY03vRIbJv/cWrovJnvFhsOun/6hswmFe6KMncSSAoRUUGq/W7wwC
	pl+9vM9Atj1SriYtbbiJdlv6+s+xlR7RjL/B1RD6/EBPyfecVVP17KZdtbVBeQ94JC+lQ0
	JdFaMdDZ+lv6KY36WOHNe8Mwo3282oY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=grrlz.net header.s=stigmate header.b=ftrselUK;
	dmarc=pass (policy=reject) header.from=grrlz.net;
	spf=pass (imf24.hostedemail.com: domain of include@grrlz.net designates 185.218.207.228 as permitted sender) smtp.mailfrom=include@grrlz.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787349491;
	b=W0TmDV1wZUV8MsjE8H5UMhGJ4u1uBJojyEna8lBoYII8Lcng8qgAPSXmYTehY1OdGN4wQd
	H8t9tVfSNo53MijKfBKwjQ7y6FgBiTEsgoyJQCVPE71urg6xyMKCGGk0tZN0v09ollFAu8
	F5mFRV1O2sORfW06889iTiF2qZaNQRo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=grrlz.net;
	s=stigmate; t=1787349487;
	bh=huZrz/6EvjhOI9pDVmyDHIIvpxO8bx9xgXE/fvQ1yO8=;
	h=Date:From:To:CC:Subject:In-Reply-To:From;
	b=ftrselUKbiNCJW3yRceplhb9llpy7cEaxsT7+dbvoxwIx+falpTAvKO2z+7OYYzhg
	 h2/y/QAdw6Y6i3RngpvFUjwqv5oZtef9Q3urza+bUWBYlwq9hbTmeuenb4J7b4qgeR
	 qAZyUBrU2Ha6R7+gDCy3olVUcVqX9LtqO+lKEMHg=
Received: from mx3.investici.org (unknown [127.0.0.1])
	by latitanza.investici.org (Postfix) with ESMTP id 4hRZ1W3PPNzGpCY;
	Fri, 21 Aug 2026 21:58:07 +0000 (UTC)
Received: by mx3.investici.org (Postfix) id 4hRZ1W003FzGpCG;
	Fri, 21 Aug 2026 21:58:06 +0000 (UTC)
Date: Fri, 21 Aug 2026 22:58:06 +0100
From: Bradley Morgan <include@grrlz.net>
To: jeremy.jean@oss.cyber.gouv.fr
CC: bsegall@google.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com,
 kees@kernel.org, kprateek.nayak@amd.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org,
 rostedt@goodmis.org, vincent.guittot@linaro.org, vschneid@redhat.com
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH=5D_fork=3A_initialize_function?=
 =?US-ASCII?Q?_graph_state_before_copy=5Fexec=5Fstate=28=29?=
In-Reply-To: <20260821102207.3626491-2-Jeremy.Jean@oss.cyber.gouv.fr>
Message-ID: <115F081D-7469-474E-BDDD-39FCB6FCFD7E@grrlz.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D8E62180003
X-Stat-Signature: mrfgzpiirrcfoxhyo75jww6ziqqynnpw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787349490-900871
X-HE-Meta: U2FsdGVkX18m07E4r0KwzhmXnCmPLG54URwIvbGKiBJlHWI4TdvhibTbg/vctfUEtQmKolZQrpdud7Bui96H69V20CWfcIUA+JQxtwgVEcGgxhnk52sgBLuUmPLfa9dYTsr8jAmHLe2xXy8Mp1QbICmG6mTafAglkeUUed02qOv+TvW4Y0ZUNSfY1cZ+qETyvwyBCJwdEQuWwFHnDH7IlLgpYlusKYpA3epGx/V2P9dwSRnQ5smeKCA1tTuu3VoppF3S7IT0T1/klqlpShnmFNOO4jAUWvCtRyoXbVru+b1OmAh2wfe6OYB+WjKtkozJG538FOtVL08qm9UHCE0rlaD2Ad+gLHUuAgc67tXKQZfi82oYQ6GYWNYVBfy5uc0NVLopqcDfg9yiTsCNTC0KElTgf4AUTUsBQr6GcvOKpWyHEFbFfoAU1xxQJj/ZNKVFpQe2sOADfMmQ/DDDyIXoZBqARLMmZ0aqQnjpOw2c58xHdBk+7RGdO4kPhZI9P35ZT0IUF3u62De+sS+rzCUYESzApI0W5NxweqWYgTFs2DmnSs4522OzE+HMMG9iyjKXxjIc7hr7TtTZq0739+5CMHBS5E63MnT4b/IZ3+tlD8VALsV8fxcImUXZTuKIA9RgOEjQM+Iufu/whq7fMsXhF6MySFKUhVs5XPMX4UM25v9w99eYF47Ik5tDDcWaesgYvMcwifMdG3npJNP/zOOGJUkGoE4+rmX9+mkZXbC+MY2cOjsCKNOPoB33nU3U7Y2gSdtJ8lAfygtiwDEYQjZSFVgtMaJ+xcToYkyyoEhWbtrWIeb/xolgCJzQSKXI8gnTVclaYyOtqv5ChlqVy74HYq3+33IHN2Zo3z8uMhLTQ+dtlz0FsMNaPynynkE1yb+BqkzmRJlR66srdcTAf16AHuyFDTllp1gb313bio0zy0ADbLqWLYQ6lfYPAvdSWMN+xZ7f7GpgqcOSWkXMHWZ
 7Bq6Tx6i
 nErFZfMtLHGNO7YTT63cQJZHZc6uAKhQLzL66CjeyhjJuMDITxXWSyG1pVQpNBoi1Hs/TwO3zwTNlzlJaKZSERHMn1WQRFCBasjppOaMbufRzmYEcnf1n7zNPt8eW5N5XHDfKUTyYQFCtXwDCUZtcXmCdDIXywHl6cuI2pvBUET6oKyonUQG+u0lzLIDWjn+JBm5sialq2QeqvNIkSu/GwbKHL7wkSlRHbIBwuME03/9nMDVXz9ppj8Os1RXXeoNlZaHt7v/GMJPv5kaxsQ6OV3yZ/zIWBK/a+CA4wlzolvrchHhZ/z/qCu9NlImYbiGI0V2vzn3vL0pUq89MrE+/X4hzl6M9HLAi3YwKIYJePZg+FXwDTn1ReRnzvws/dhUo/HCL0Xyt9WkMPg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 August 2026 10:22:08 BST, Jérémy Jean
<Jeremy.Jean@oss.cyber.gouv.fr> wrote:
>From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
>
>dup_task_struct() copies the parent's task_struct, including ret_stack.
>ftrace_graph_init_task() clears the copied function graph state, but it
>currently runs after copy_exec_state().
>
>For non-CLONE_VM forks, copy_exec_state() allocates a new task_exec_state.
>If that allocation fails, copy_process() reaches bad_fork_free and
>free_task() calls ftrace_graph_exit_task(). Since the child still carries
>the parent's ret_stack pointer, the unwind frees the parent's active
>function graph return stack. The parent subsequently accesses freed memory
>from function_graph_enter_regs(). KASAN reports a UAF.


Ugh, real one. 
dup_task_struct() does
*tsk = *orig so the child inherits the parent's ret_stack,
task_exec_state_copy() can return -ENOMEM, and free_task() calls
ftrace_graph_exit_task() unconditionally, so the child happily frees
the parent's return stack. Exactly as described.

>Initialize the child function graph state immediately after
>dup_task_struct(), before the first fallible operation.

Good! The alloc inside ftrace_graph_init_task() swallows its own
failure, so moving it earlier adds no new error path.

>Fixes: 6b1c66c9cca9 ("exec_state: relocate dumpable information")

Tag is right, before that commit nothing between dup_task_struct() and
the init call could fail.

>Assisted-by: Codex:gpt-5

Love you declared AI

If you still have the KASAN report, pasting it in would help the folks
applying this see it is real and not theoretical.

>diff --git a/kernel/fork.c b/kernel/fork.c
>--- a/kernel/fork.c
>+++ b/kernel/fork.c
>@@ -2139,6 +2139,7 @@ __latent_entropy struct task_struct *copy_process(
>  p = dup_task_struct(current, node);
>  if (!p)
>   goto fork_out;
>+ ftrace_graph_init_task(p);

One small ask, feel free to bikeshed: nobody is going to remember why
this call has to sit before copy_exec_state(), and the next reorder
breaks it again. Something like:

 /*
  * Must run before the first fallible op, so error paths never
  * free the parent's ret_stack.
  */
 ftrace_graph_init_task(p);

With or without that, idc ..

Reviewed-by: Bradley Morgan <include@grrlz.net>

Thanks!

