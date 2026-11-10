Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E50B606AF3E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8Zm3DwiJ
Received: by kanga.kvack.org (Postfix)
	id 511886B05B1; Tue, 10 Nov 2026 08:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2226B05B6; Tue, 10 Nov 2026 08:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9EC6B05BA; Tue, 10 Nov 2026 08:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117DA6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:29:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 96161807A6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:29:55 +0000 (UTC)
X-FDA: 85419292350.07.32140FF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5564940004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:29:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317393;
	b=G4iOsqEythNJHxkvoPzQxqqzH1l3PQQ7/GyFWR4Px20k9rAdU8/9wJ6yyGKfcjis9Qf34z
	Ksztjr02z+fYQIyW32hlmoX1OGa226a+EBUNWIBFH0H135ttQyvcwosEoNhyqQUPfRXiaG
	yCt6DDwshSPoPJmOHP++ZftAfEA5MLg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=lDXyVJm4owz+Y6f/JXRZ1zN3ZT7HLtMzCw1ZjRiMIX/VSgbvv9dlLAvlXWL+WoUCsQ3hdN
	ahg6NCaG9jRPxR97lUmH1TtvQK0DX/7RxHg+QUBY23u6CvxZfo+uC+XweKi2uFhxhHN5af
	iM2Nq2HXyeLu3rCtV/rsITCYsHZDfxc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6bvVSlZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8Zm3DwiJ;
	dmarc=none;
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0832121F1E;
	Tue, 10 Nov 2026 13:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=r6bvVSlZjxpVnwcFk4kD78MioJsu6D3AlYG2tBRTGMWIwes3h5blfHJfCpSINPK6zNmNcd
	anGTtoIWyzenroZAqMeKs0gZv59sRGNsihzn4eAfkEprnd6rA2NPlflHMUywbNSBSmHFkH
	Gvc42hL59nIU3v1lBVN04OusXU+jLhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=8Zm3DwiJOrYwCmyUyCb5kfOI6SMFHZ/fAo0QthXS82fE1cx9CF1+vEsS5oYJLMLGJ3jtVL
	RwbfsHff24uidGAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=r6bvVSlZjxpVnwcFk4kD78MioJsu6D3AlYG2tBRTGMWIwes3h5blfHJfCpSINPK6zNmNcd
	anGTtoIWyzenroZAqMeKs0gZv59sRGNsihzn4eAfkEprnd6rA2NPlflHMUywbNSBSmHFkH
	Gvc42hL59nIU3v1lBVN04OusXU+jLhs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C4uMTERewdC+9gC+DrjEbRKhFxjcLNPdABLnD4EsWsQ=;
	b=8Zm3DwiJOrYwCmyUyCb5kfOI6SMFHZ/fAo0QthXS82fE1cx9CF1+vEsS5oYJLMLGJ3jtVL
	RwbfsHff24uidGAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A4AF4134F4;
	Tue, 10 Nov 2026 13:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Es4PC08c82o8ZgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:29:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id C59372250E; Tue, 10 Nov 2026 14:29:50 +0100 (CET)
Date: Tue, 10 Nov 2026 14:29:50 +0100
From: Jan Kara <jack@suse.cz>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Julian Sun <sunjunchao@bytedance.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <bsho4anqsuqew2ao6qlxlccge5hta4fljsdym5jb4l4ry54o5p@i2atspfuwq2g>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 5564940004
X-Rspamd-Server: rspam12
X-Stat-Signature: ssust3brdzws3w6xanqmjnf6663ozj1o
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794317393-90731
X-HE-Meta: U2FsdGVkX19R8GdCNV6I/CiRBP3xlwPTWBGEegYuowon1mLriU0FMRgEuhQKgewRmfFlBwzJn/j4si2BUJpCU9SKet5PNailkA4OSbhtJe76HNrJaPqVkHDgYFCbq2JhM5KVdwwu2qZH5+V39xMU5Ymqixd2hTvRUmCmYdP4GFuKC/WZSIbDYuTkG33m7F6W2fQySEpInLYPKXrw/Y+enj5KNLQWzcYqFF6/hCx2XHPhC6qioU4dcj3R2yioS93BUyaWh4C6AOUWqVXCV2kVjy1t0hFIdTQ27ksKtHkpH/D9p3Qy8oCdX8n4mbwxcZ3Ah2Rby60h3xP87p5zWJUyFf1l+ENmzaHK1eDhXB7yQtkVc0dEdWn2kEL+UftQpm4Onz3UA3wtgf4mHseWx+caYzTkEwkijFHZF76ZvbxQNqIqA+xeebcwabkFvVhAGuiYS1zMu39KTTttPsFt6K9kQVCAPaVotSVg94fbkf6kKDqzZOhofg0sIwlo/dnzcjeSUidEioINqR8HmK2oTYGBAhs4JLRXTI5xXLINeVziHXvV19RQCaN1gT6P4sshAd+rFx6bzrR31CMnFipURAyR2rpTt1eDX2iCNVUWXMgC3ELRtRZun1onktGkYIYu1gsV4qZfGQtNmJNPZDOdw7/y2j7QGVcBfljMmT6GNkDh1W7QPBH297hzqKFg811EoOkUGhVnyQNhGOe6mc1vSjeVc1PoQYAwtegnX/hBdWGlbmSVj/PJrWt7LVENdHRd6EfoCoadMr3VFbl00XkTo5XngCs4k+BDcNcWpCu4yYTw59wSAl9sH26QLLpjrjkoylEbsfHDYibXXp2EjhtOqW2AH8v4M6g/x/tJyJlmVOlMzXO0bmEs/e3Ccnzts+glZ3WdZAKAROGI3fS75qkVz5iVsOAKCwuOGvM0SdzV6wBKFGHcorUGwQ2t+kyk299cogpZm98MwuC9KnttoeKkF25
 dNHMwrRW
 SDXaX0haE+PjocbRk9KAma+NxDLWzlsrvbO/NSqzOTyKw+3fuKx5eWy2q0MBYH36W1w8at6RlLQaSYRpjjrfUJl/y8/gxB0rIZMVUkJ9q2WJSscBqLcY7VOudA+HLhirBFmqSkuqCyRYeW1vLgQg8XkL7hXOYesPj3ZNohJv9eHsaD80ZZx70GejvCYI5fKbhmPDciA+dYaBHrO/2g7JtQGwT56amMZBHU/OyUaok/SJ9xaPoXst7P2cdkuEdPX0hNsitJ2u0ZpiIHLkSzYv7Xqx3eUnaK1vAC+qfipBKUNzoyMH3B/uBB7ts4SPIBSBxY5V4F4eqAuk2ysixTeRCMeEyL2mVYm9famn7V+EjPN7H/U2t6srnYC4ohdkbIuhLA0+IAODuplbp3XbbKgMmAqo3kJJjTqyUS7f8g74r/pPbtUCBrWQqpBl6d8kJ6JzQfwj9lXnd4+dLjhsVgBQ4iWiY+uUiYLGpr1dD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 03:39:30, Breno Leitao wrote:
> The slow writeback report is printed on every wakeup of the waiter past
> hung_task_timeout_secs, and twice each time.
> 
> Each flusher working for the waiter wakes it once it has not run for
> half the timeout, so the hung task detector sees it make progress.
> 
> Since commit 84654c7f4730 ("wait: avoid spurious calls to
> prepare_to_wait_event() in ___wait_event()"), wait_event() checks the
> condition right after schedule() and again after
> prepare_to_wait_event(), so each of those wakeups reports twice.
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk device
> with the timeout set to 5 seconds, gets 18 reports for a 29 second wait:
> 
>  INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:275 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  ...
> 
> Set ->progress_stamp when the wait starts, so the first check does not
> take a zero stamp for a timeout. The same test now prints 5 reports:
> 
>  INFO: The task sync:276 has been waiting for writeback completion for more than 5 seconds (bdi 252:0, work items left: 2).
>  INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds (bdi 252:0, work items left: 2).
>  ...
>  The task sync:276 waited 29 seconds for writeback completion on bdi 252:0
> 
> The flusher only checks for progress between inodes, so the wakeups now
> land on the first inode boundary past the timeout, a bit more than a
> timeout apart. The hung task detector scans once per timeout, so it can
> catch the waiter between two wakeups.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good to me! Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index e2da4781b5e00b..fcb7fb0196208b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
>  	int left = atomic_read(&done->cnt);
>  
> -	done->progress_stamp = jiffies;
> -	if (left && timeout && (waited_secs > timeout))
> +	if (left && timeout &&
> +	    time_after(jiffies, done->progress_stamp + timeout * HZ))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
>  			current->comm, current->pid, waited_secs,
>  			bdi_dev_name(bdi), left);
> +	done->progress_stamp = jiffies;
>  
>  	return !left;
>  }
> @@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *done,
>  	unsigned long timeout, waited;
>  
>  	done->wait_start = jiffies;
> +	done->progress_stamp = done->wait_start;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  
> @@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  
>  		/* Report progress to inform the hung task detector of the progress. */
>  		if (work->done && work->done->progress_stamp && timeout &&
> -		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
> +		   (jiffies - work->done->progress_stamp) > HZ * timeout)
>  			wake_up_all(work->done->waitq);
>  
>  		wbc_detach_inode(&wbc);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

