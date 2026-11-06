Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB200606A329
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=debian.org header.i=@debian.org header.a=rsa-sha256 header.s=smtpauto.stravinsky header.b=hxJ0aWWr
Received: by kanga.kvack.org (Postfix)
	id 119C96B05B3; Fri,  6 Nov 2026 10:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F1656B05B6; Fri,  6 Nov 2026 10:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 008186B05B7; Fri,  6 Nov 2026 10:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE9C06B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 10:47:50 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58988120D7E
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:47:50 +0000 (UTC)
X-FDA: 85405124700.25.A07A98C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf13.hostedemail.com (Postfix) with ESMTP id A14D320004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 15:47:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hxJ0aWWr;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793980068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmKUyztNyCKEX6kdM2pzglbfBGyZ6nijYc/+g6Roixw=;
	b=WPi9Dgm1jRQ82ZjEtee+9P5PmlKlA/rphFa/DZTUyykxZkbfC4VMvxtokqHtfrJidE8sKF
	Jv4o4E4IFMul3gVPLpmaytYzT8hFTcXokO09+WwaKDeOxef3rwlFJPx1NI+qWjRUAEkS6/
	kLNmvFTF12NvfdAI60MAXiMxlBsVo0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793980068;
	b=r4vDTxC1/2hkeL3BEEzZ/wS2dOInSpD6JtY4CXSEEgcahkCS4Lq8qFMrnmdwRimrhEShKe
	NJ2OlbtPe1w03xcMZJSNweSpZ2cOx9XUyFqeEE353mmuXk1UT/7nYe38WgFUd8v34UAAP5
	TfW7ylHTct8E18KqVr7/2USPk2nUDlg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hxJ0aWWr;
	spf=pass (imf13.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UmKUyztNyCKEX6kdM2pzglbfBGyZ6nijYc/+g6Roixw=; b=hxJ0aWWrhA/N+kPnh9QdadK03I
	lphqVrug6uscPzlWL2jyy4zJB2rNqXeOEXOLuwmTGBKV3e6eyRkSxZroS7b5nL61OzJDkf2UkX+ln
	0BmB02lmybqsifwdOsPKfRKNklN7Giqov+pGQZVxC5OCfay9a3Wn3EhTRIaImRfCjzT4xtmKEtpzx
	svMGJfZBLYPoYIHp/j8+GM0EpjPZlGl/zWct1qAtM3b9sush4NCM+c1ChfiEjgkhJoDryu9M53/lU
	bWMwwwkvUcLuN3iGCOJ9nqxg6EvJeYKwB+fKWCDpK2kjJFauLIg9FqPkOwViu3y64uaSgBQBi1bJG
	RqdWC0iw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1xPMA3-009OAp-2L;
	Fri, 06 Nov 2026 15:47:27 +0000
Date: Fri, 6 Nov 2026 07:47:22 -0800
From: Breno Leitao <leitao@debian.org>
To: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <au3w4xiaYbEYLTru@gmail.com>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
X-Debian-User: leitao
X-Rspamd-Server: rspam06
X-Stat-Signature: zitngb6c437eixfj54sb4ynif1gnceje
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A14D320004
X-Rspam-User: 
X-HE-Tag: 1793980068-626443
X-HE-Meta: U2FsdGVkX19o3TRT0J1dO+adAM7PFh3KaoeWrE4no7p8iCQ4qLP6zACKj6WGb8nOrcp7qh1rMaAEhT9VtEipPS77T9sFDXGcj/8yHRbzmyuTzTHNkpNw7Ln5xZtVHK8tA2N7+HVUxy5YxiQ5KGys/TIETj/d1U85qbb7mqlKpUcNQheGv3qi9eU/X6mXPrXycg6eFqPMDy4KwThzq0oX0PlK6t2tE/lsKdywOMo8OzqNm0VSmjCriz58BcPU/u05L6L69PZHLzuYZkAjUybCAp3q4jSeGP4fnKDu2JtUvrCY2ZgeJUh4CqhkDowzEO22yKLmdde5ro97NPZYgt8M/GJo/oHB3HNyaQ1qiqvbnvFJkS7KUCH9877KEKPxXZlSHS5KNd9EhKUb97saKEkjiiCdv8xUa/BNVsN20J8mU0T7xjll8LeAEozhTnpPxDmPgfBP7SjWccghvFEwSZXalfcPIbeub25Eaum7tNMHULxgG+UQCrfuHnYNBDZ6eDmV0QWp9nG4XrlnGFdmAzabj6AiQzdYHje4tox4phYN452lxopUOSe05u9ju2trOfU2XWYMQ6lbKp5FNcR9WUy84rh8QubH73+teR1Q7o9ycFn7FG5A7UThfszYBXiow1INqR0aJS+o4Slv2gomdxSgvsrWUNQ0/3t3U5oart9VXZuiqVgW2emBFNzNal6dFrO3AQU+tQoOW4Xcpt6fUJ+3jw2MQ8AwLK7XXN51RCAHPmPgscpXiZqAchEEXSZ8LQPLRXvcGN/oYgqe8gp+jRtb2wqWRbfMXcDdWcU8hOUwACgq8ErQTmB6XDmwLuVRuVUHUVcfKFfuVA6PykqhtwlOU4yOHXoFmz7dCkVMeiIYhjMVYkIlhMVHnj/eW+T5BtWM7Zu+jem0EnuQ7nZsNXxde45KOfQtRzIRok1YC2Kyg+dWAbnMgTDHTb9mn3sJhMn2NPOSk+PVwHLJDeGTRpC
 nRoiaRQx
 lk+tiMFeLc0XqXfKe98UNmScZDqfcAhBY/UYHcmcwSq+WSvNrSLUaWzM2EELV5jUZiphUsmN3LBmMWmWX9D7936XTOR5DWPOTGq6s71MVrp04VIgAQrufufuirWYHyUkvBt34R0jOsa7wJuvo39oqB7NpNiM17TigV2jO1V7plOw4b6/UHc5UZYgzkxwUWnccISVh37NO9BGyANAkE2yHm5k/K+ARG1JPxWBT3peGDoNppUhTCL6I+26lmIg1DNvIjbadHVj2E+bdU4Q9o0iV3quEzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 03:37:45PM +0100, Jan Kara wrote:
> On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> > The slow writeback report is printed on every wakeup of the waiter past
> > hung_task_timeout_secs, and the waiter is woken more often than that.
> > 
> > Each flusher working for it wakes it once it has not run for half the
> > timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> > one of them reaches all of them.
> > 
> > A sync of files dirtied from two cgroups, on a throttled null_blk device
> > with the timeout set to 5 seconds, gets a report every half timeout,
> > each printed twice, 18 reports for a 29 second wait:
> > 
> >   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> >   [   10.328000]       bdi 252:0, work items left: 2
> >   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> >   [   10.328004]       bdi 252:0, work items left: 2
> >   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> >   [   12.888195]       bdi 252:0, work items left: 2
> >   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> >   [   12.888198]       bdi 252:0, work items left: 2
> >   ...
> > 
> > Remember when the waiter last reported, and report again only once
> > another timeout has passed. The wakeups do not change, so the hung task
> > detector still sees the waiter making progress. The same test now
> > prints 5 reports:
> > 
> >   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
> >   [    7.661136]       bdi 252:0, work items left: 2
> >   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
> >   [   13.241109]       bdi 252:0, work items left: 2
> >   ...
> >   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> > 
> > Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Now I'm waiting for someone to complain it gets written out too
> infrequently :). 

Once per timeout is also how often the hung task detector checks by
default, and patch 3 logs the total once the wait ends, so maybe that is
exactly what people need? Not sure.

> Is this change substantially different from
> writeback_sb_inodes() waking up done->waitq less frequently?

You mean the ->progress_stamp field? That is not used for reporting
purposes, right? Should it be?

It could drop the duplicates: a wakeup with work left runs the
wait_event() condition twice (since 84654c7f4730, it is checked right
after schedule() and again after prepare_to_wait_event()), and the
second check would find ->progress_stamp just refreshed by the first.

But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
space the reports further apart than the wakeups, and those have to
come more often than the hung task timeout.

So it is a choice between a report every half timeout with no new
field, or once per timeout with report_stamp. Which one do you prefer?

Thanks for the review,
--breno

