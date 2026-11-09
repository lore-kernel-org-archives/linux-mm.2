Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 456D4606D833
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKVJ+W/M;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IKVJ+W/M
Received: by kanga.kvack.org (Postfix)
	id 5C7346B05BB; Mon,  9 Nov 2026 09:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F1E6B05BC; Mon,  9 Nov 2026 09:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4236B05BD; Mon,  9 Nov 2026 09:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28BF96B05BB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:12:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A40621C405C
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:12:24 +0000 (UTC)
X-FDA: 85415770608.28.2236BA3
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id 733692000B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:12:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="IKVJ+W/M";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="IKVJ+W/M";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794233542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=oidkhkOVvVCMBdLTqu+Qp1jFL2O88Hb5Sz3oYYJc+ErcxW+Lgg4M8Uv6GdUko/D47T22ax
	fzM0cDfEnmAoec9u4z0WQpGFAicDSupCJfNg9A74YVEG6W1Ql9z96aBnhkRoOS7BPFtnDf
	ELlf98UuIc2moirvZzORoqE52Mm61WM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794233542;
	b=77drvXyhP2pjQn2T3YaxBhRRTOrAXJii4Zkl+X+ZEtFoMtVWN8nEwd9OJhvl3WI02UUe3F
	dbULnzlHD0PlfqSaSIde4nD/5O9A0P4sgByFI1kHi88XKcT0WP0TvSFN9G6uG5TqWKcaKy
	K+I8+cQ+z6JxGYN7MJ9IoM9rBhPZnss=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="IKVJ+W/M";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yXVd9FmK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="IKVJ+W/M";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1049B22030;
	Mon,  9 Nov 2026 14:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794233541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=yXVd9FmKe7Ob1knMgsssG3E8dnqPFa0gh0va6UsPFrZNmfpwf1CGYY+ZQYXkADBkD6slxB
	71n5bXMvrrwP4ZchHaoQfbg40Eeu+HVyE3/eNsiDOZSJ6ZOYWf8QOyxxM/7gowQf95PzJ/
	BAp2h3EXcZ7YjBAnFxrWWFX5wvcwr9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794233541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=IKVJ+W/MQJeGL8bBUobOAWe/cGORmXeK3Btk4btV+VroK8l0OkQR0+TNMZjS3RTsQVA/5I
	Wp8jupL4693KM3Ag==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794233541; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=yXVd9FmKe7Ob1knMgsssG3E8dnqPFa0gh0va6UsPFrZNmfpwf1CGYY+ZQYXkADBkD6slxB
	71n5bXMvrrwP4ZchHaoQfbg40Eeu+HVyE3/eNsiDOZSJ6ZOYWf8QOyxxM/7gowQf95PzJ/
	BAp2h3EXcZ7YjBAnFxrWWFX5wvcwr9c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794233541;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O2aI15BvczZ+7OEGQ6YiBMp3R5vW+5w4ZDD7M1MqN48=;
	b=IKVJ+W/MQJeGL8bBUobOAWe/cGORmXeK3Btk4btV+VroK8l0OkQR0+TNMZjS3RTsQVA/5I
	Wp8jupL4693KM3Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9D0E13319;
	Mon,  9 Nov 2026 14:12:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id otPMLMTU8WofWAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 09 Nov 2026 14:12:20 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 689BE221F7; Mon, 09 Nov 2026 15:12:16 +0100 (CET)
Date: Mon, 9 Nov 2026 15:12:16 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, 
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
Message-ID: <xehz3f62chf5ivwbh7f5chapypp5md5vasdtsnxfwzsebontf3@roqs5cwjk2va>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
 <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
 <au3w4xiaYbEYLTru@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au3w4xiaYbEYLTru@gmail.com>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Server: rspam06
X-Stat-Signature: 9yfzedmxk6bukuyqhenztcu517ajgi5y
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 733692000B
X-Rspam-User: 
X-HE-Tag: 1794233542-828033
X-HE-Meta: U2FsdGVkX18vQFAfj82AeVgYwI8Cdfzr4DogzIHfWk/wjCiDs4O0v6IC83CbbetWZAf8ZLopdfIPV9eNfGQjE2BnBsRionIeRq3JJsLjU3VyY7WPBaZbD3EiRT9xaf7Bsrr01VqKogWiYo0L0wuq+xfIO+t26v1d6Fh5YCDnuzKNOZFOtuk9CiDUp5s19t4Lf8EJWU2wQxC0PoHGXyMKTnLm1+e/Ri2oA7lYO31H70qld5m8LFnx02e/cIn3ThfFbZQmJeatz+qCs1Cf/jw5FCcBrdiU5QMy3x1v0hbVaRNAUmAnw0ACn74rsoKw7RGmcT8oe4mTfqAXbPxEsJcadRvxqLhtLPayt6QNwk25fRgvLglF34P1GtetuK/i8+TjzSDUcm1CJI51rnE51PeCeNvz+A6lhlAdA98wCEVFX3D0w9z4kVrvYQNBWwJWZMbSv2VQATyn5jZY0bxCl0/G26Z9rXYf6JXtseTuwTP4mXYa6Ng7r+Dv328QIMnLb6um5YnGgsBMXUxJff3PJ5D9TMFUIT2jxQGyD1NGvnvftsxPZd0XhZ7VFx/HQx+Tlf8rB/cYuY0Pbi48lS2Qbp5cajV+AXEL8kET4ULO9cqLaFngZLmAOQdyxs8yh8U3y6tLWR5Ni+50hPGpbs/ZnFCZlN5H5a+TMXlGgOwhd9unm0yR/gZowHIXGFleTs37/u/vy46iVvvpvHpmkxebK8OypQbdhA8xCqHNGOVvW0jVyu0WtRxrPG9ub4qLJZDyPjcy6D4RIINNRoX/wdtoZ+KYcLivRk+n1q0zzTYB1iqKuyQoCvjKowBYwk0fXAc3U7ej209FV5519iFzd1maIEr0F3QfNKir/jGFPI/uyK3AjKF/JLH45254Qe6pklU997AD98Y/ja+6sHjz88XnR5MuFJMnCkAqbTQv/lJ3WXBmmKuL1OsLasEjGn5XwIDaMMMMHCJixO961TIPmDNhBpE
 4iteoJnF
 fH4Ub1BJ8H7PaLUmPR8d/T12m4J8RsrA3Wga5EYuHpHbdCD5OtKWveimbMTm0vvfKqMMgGrFkT4Ux9vck3EXhFCEpfvPlS9KhEGU3r6EYCfEy7uJYjwan+H75IuT0J+PIFP+SNSchAhup+9wSe2OUpmjJwd8rkHIqS+o8HlrPbyOe+QMJvzS47YZ+RceuHmPn1HnsJxnZVvQI9YDQYRF7akx8mHKMeZ89WKXb+/8KBu/FI4I7GQenBH4UJXjjTnK5JTQgyE7izvQmXF4WAIBdAEDtprKUun81YGdVDiTbK342tuOxhfI6BQBrIxd2OJ0KLNC7Qe45UnLixZZmjrhwUnBXkVASOpouTta+uVvyJBIzkQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 06-11-26 07:47:22, Breno Leitao wrote:
> On Fri, Nov 06, 2026 at 03:37:45PM +0100, Jan Kara wrote:
> > On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> > > The slow writeback report is printed on every wakeup of the waiter past
> > > hung_task_timeout_secs, and the waiter is woken more often than that.
> > > 
> > > Each flusher working for it wakes it once it has not run for half the
> > > timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> > > one of them reaches all of them.
> > > 
> > > A sync of files dirtied from two cgroups, on a throttled null_blk device
> > > with the timeout set to 5 seconds, gets a report every half timeout,
> > > each printed twice, 18 reports for a 29 second wait:
> > > 
> > >   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> > >   [   10.328000]       bdi 252:0, work items left: 2
> > >   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
> > >   [   10.328004]       bdi 252:0, work items left: 2
> > >   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> > >   [   12.888195]       bdi 252:0, work items left: 2
> > >   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
> > >   [   12.888198]       bdi 252:0, work items left: 2
> > >   ...
> > > 
> > > Remember when the waiter last reported, and report again only once
> > > another timeout has passed. The wakeups do not change, so the hung task
> > > detector still sees the waiter making progress. The same test now
> > > prints 5 reports:
> > > 
> > >   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
> > >   [    7.661136]       bdi 252:0, work items left: 2
> > >   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
> > >   [   13.241109]       bdi 252:0, work items left: 2
> > >   ...
> > >   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> > > 
> > > Signed-off-by: Breno Leitao <leitao@debian.org>
> > 
> > Now I'm waiting for someone to complain it gets written out too
> > infrequently :). 
> 
> Once per timeout is also how often the hung task detector checks by
> default, and patch 3 logs the total once the wait ends, so maybe that is
> exactly what people need? Not sure.

I was mostly making jokes here. I agree reporting once per hung-task
timeout makes more sense.

> > Is this change substantially different from
> > writeback_sb_inodes() waking up done->waitq less frequently?
> 
> You mean the ->progress_stamp field? That is not used for reporting
> purposes, right? Should it be?

So my thinking was: If we change the wake up condition in
writeback_sb_inodes() to use HZ * timeout as a limit instead of HZ *
timeout / 2, then we should get one report per timeout, shouldn't we?

> It could drop the duplicates: a wakeup with work left runs the
> wait_event() condition twice (since 84654c7f4730, it is checked right
> after schedule() and again after prepare_to_wait_event()), and the
> second check would find ->progress_stamp just refreshed by the first.
> 
> But the waiter refreshes ->progress_stamp on every wakeup, so it cannot
> space the reports further apart than the wakeups, and those have to
> come more often than the hung task timeout.

Why do we want to wake up more often than hung task timeout? We evaluate
the condition after each inode so the error shouldn't be that big?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

