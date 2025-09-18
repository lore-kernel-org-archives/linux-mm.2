Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592E7CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 15:29:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2EEF280038; Thu, 18 Sep 2025 11:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DEFA8E00F6; Thu, 18 Sep 2025 11:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5A3280038; Thu, 18 Sep 2025 11:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9BA8E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:29:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B0E9576ED
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:29:23 +0000 (UTC)
X-FDA: 83902755006.25.F10F16C
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5484D8000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 15:29:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758209361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dnW9UQc/Q0+eAnNrir+Fl2byT744Pila74CtWu5uDNM=;
	b=HyQhlZIULevlet1iQ2s/A4i3lSLSiMwpqqXkPK186Cu4wNzWvsVkZVe5akD/ivsXVR4SVq
	rhoKxqTDaTpzwzICYi29kNNQZWnhgt1Zeg2JvcRzart7CI4HVU/9eAzMIWkhrGcc7tyWX8
	1XJ029Y09EEfPdISCtUIc7EOpuUp8fI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758209361; a=rsa-sha256;
	cv=none;
	b=UeBwwV0W/pWtMtZj3KkxWcHIhE3SfvB+EtVB+lbCm21tNhhsdNRXe/cGaC8cyfUnY18mRA
	YpLUZCxg194fJK91mkoTzF+AOfJdiOY7T3uAVTOqBZ5f5OICVhuBkssdPoyxWvNEtb9FoQ
	k77tkFbn6Rttk1XiorTFhH2rXAnlPb0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	none
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 159DB57397;
	Thu, 18 Sep 2025 15:29:19 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id 8923330;
	Thu, 18 Sep 2025 15:29:14 +0000 (UTC)
Date: Thu, 18 Sep 2025 11:30:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
 Peter Zijlstra <peterz@infradead.org>, syzbot
 <syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, akpm@linux-foundation.org, bsegall@google.com,
 david@redhat.com, dietmar.eggemann@arm.com, juri.lelli@redhat.com,
 kees@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com,
 mingo@redhat.com, rppt@kernel.org, surenb@google.com,
 syzkaller-bugs@googlegroups.com, vincent.guittot@linaro.org,
 vschneid@redhat.com
Subject: Re: [PATCH] futex: Use correct exit on failure from
 futex_hash_allocate_default()
Message-ID: <20250918113022.1b97d977@gandalf.local.home>
In-Reply-To: <20250918130945.-7SIRk8Z@linutronix.de>
References: <68cb1cbd.050a0220.2ff435.0599.GAE@google.com>
	<867144d3-b05e-4ce2-8bb6-da01e10fbd73@suse.cz>
	<20250918130945.-7SIRk8Z@linutronix.de>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+TTPLGd6WX6aq3rap/uZBpfrnji4VecK0=
X-HE-Meta: U2FsdGVkX1/urWqjcd2GFQknJ54dZpoXNJwoQqbuoC0perxLalFSrYy7kgiLvkmLA8YVWi6aGxg4bBNLTzGZ8BkLZKhgn9VtkWHRwcN81nmT7hUTth99wPdPbHq7dUSpNOz+uBYU2BNyfLKGy1dXqjXZOEVcOyod3Tr3ctFjSjm3MW3hmYF5b+bl4i5c0vn9qdPhJKlKV2i0Ye/HVqkXMEOf66vD1KSjP8pdk4bbLvaVSpLGYPTmtofZnOoGL+yjgmBQznEKfyXoRbdo9ewufM62EB/SNVcAYkZnlp3lEgQAkB0JHKhXkJu/EtzJc187JPtT99aGZfZ8/EgOZVKW3odD+3YZZo2ZFvlrRcPHinZFtq/qKaBaW7r5dgdn4v7AV9j9nqKyiVpRW5LhzEibPOnyGCg/Va5B0PpgX//V24mdY22wZpJiDkhxalHzhvS2JJ+qs9MiKKSt8xQDs0kDWGDyLzEjOZJPumDQxRLTGbw=
X-Stat-Signature: 5k3m8kciftd13nqeeizubc5uj35nansc
X-Rspam-User: 
X-Rspamd-Queue-Id: 5484D8000D
X-Rspamd-Server: rspam10
X-HE-Tag-Orig: 1758209354-859747
X-HE-Tag: 1758209361-194479
X-HE-Meta: U2FsdGVkX192t/zUe1jREBZu9B7s/4EgnzlOYlNEq+gfj/wwFLvqj4bjSphKzCccndEtSPgjhhCK19ivvQJxbpHL2TCAqrl2ItPjCjOqVnEu+Nqa0iZwUyqxY9lMCKmvw97mpUJWgN7sYFuA3h5EBp51UdhnhvqaYmPfSbmhr9+/xmMN/MLzGPY7D4d8mO6xbsQ0BEe62hgTDKiPRVH1Ct7SLODbB/YrZVYa+p+qUTxRQWwtZkonGgKmBwIs1UW9BfNiEI0ta9+/+2DNHtOjnAb1reYm7aTM3KqVUKDbUsHdaPfxKSJBg0iRNhsbFvEB6lULrlv7slXsF2TRizNh8ZnhUVUus2rTN4lElvjA25w1F7w5HKtYvr5YxfzKFnwyU1Vc4BoMR2ioGHul8RZWUEwQ9k9o9Rw2MwLLYEboJlKTvsfEahM9S75fOZQSGQDAeCDmU3KepDeg2m1wFZWzlQewlZcD1Fo2XkRjzEPAYXPK9ea7kmO03nBT2uYb6WiSSpYkBdqcbTze+5C7gFoZqj+VKtO1eYnrrrsgMU3tPDH5zXDRsAQiFqL2qMaQHLR/FXXasz/WXqiZtKw1tXeGBikQXyiWtkWxiOT5ADsUS0o+uqx600/Y6cP3l9QGq/B2u2DuH9bnM4fB8sLjpB2lbsITKInpxV3mXeAug6Nsw/DH7DQz4GgMe5i4TDVPeAcyWKy659Ag6rKyfFe2oRZ2++59r0haAGZbUt0liArDV1uomeiyIvMBqG56KT40WnyfOeoPW/BzLNvZnqr/f9nXu2735dzytqNwGhF9AFw4T4YHVj3CQzqixKt6hKO3bU+2wKlh7A5Itv8WxglyaaHOYGpR5ECNG4DvmzzcyG50qMGtC0b6e5dNROwFJiEDhea0A6MsMbpIGvnVItjgJbaLa0PdddadM9hDogRc7Kh6frqN9y5Vg6X9/WfbRpaKdCDNDW9YGgqS1C29TC4wjPe
 /j/KCaQI
 xS2pYYoq9CkldHbHLeGyLON7LgiOmod9SzXuEUEOYiP2RltDrA1gIv467LMSHko34S/Axh6YmYGdUYzdJoO+iVenbLGvDQHAZ1lVqfq3ND+F+2j2sUKOeP9kDJcRRdqQwNaRRC5PeXAkQx3kL/xb9UitXMJEucn61a1NcjkkwgJZzt1pgntnVGrb4bKNQv1QeZtO+hY7ovKyLpSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Sep 2025 15:09:45 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> copy_process() uses the wrong error exit path from
> futex_hash_allocate_default().
> After exiting from futex_hash_allocate_default(), neither tasklist_lock
> nor siglock has been acquired. The exit label bad_fork_core_free unlocks
> both of these locks which is wrong.
> 
> The previous label, bad_fork_cancel_cgroup, is the correct exit.
> sched_cgroup_fork() did not allocate any resources that need to freed.
> 
> Use bad_fork_cancel_cgroup on error exit from
> futex_hash_allocate_default().

	if (need_futex_hash_allocate_default(clone_flags)) {
		retval = futex_hash_allocate_default();
		if (retval)
			goto bad_fork_core_free;
		[..]
	}
	[..]
	write_lock_irq(&tasklist_lock);
	[..]
	klp_copy_process(p);

	sched_core_fork(p);

	spin_lock(&current->sighand->siglock);

	[..]

 bad_fork_core_free:
	sched_core_free(p);
	spin_unlock(&current->sighand->siglock);
	write_unlock_irq(&tasklist_lock);
 bad_fork_cancel_cgroup:
	cgroup_cancel_fork(p, args);

Yep, looks bad to me!

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve


> 
> Fixes: 7c4f75a21f636 ("futex: Allow automatic allocation of process wide futex hash")
> Reported-by: syzbot+80cb3cc5c14fad191a10@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/68cb1cbd.050a0220.2ff435.0599.GAE@google.com
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
>

