Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01BC0606A331
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T9F6eGMH;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=T3BliDtd;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=wP9/6bwL;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JTKT7OmU
Received: by kanga.kvack.org (Postfix)
	id 284406B05B3; Fri,  6 Nov 2026 09:29:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233C06B05B7; Fri,  6 Nov 2026 09:29:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCCD6B05BE; Fri,  6 Nov 2026 09:29:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8F6F6B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:29:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78AFDA09C5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:29:55 +0000 (UTC)
X-FDA: 85404928350.04.3DF2748
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4EC5E40011
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:29:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T9F6eGMH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3BliDtd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="wP9/6bwL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JTKT7OmU;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793975393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=qfVX9ljf1lpJifzDYKRQZnSL/i5gD9A5bkpuWsKVAEnKphRiCHDiq/A0dmM5k3JRFdB9d1
	FMIeH39EUnw/uOhMtGdwepuoMCJSgi+r4bkP98/EQ/e1KWEGBbKEizY1TOu6qIAN2ZJIro
	TbVatdfBtgYejHZJdLtBBl89V9aOZkg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T9F6eGMH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=T3BliDtd;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="wP9/6bwL";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JTKT7OmU;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793975393;
	b=3QVbKQeeJfp3oKEjVn3O7jya6pdwr7o3hdWY9onlgqI3vcoUd9p+42J0NEFXPdMS1tjIvr
	J4aEVb1RTJ9j4ZJyrlH82K5xUEhtEYN648OuY6z0yUam5i2HUMJbPwdtfJifQ1z8NXjQHo
	pDp4qPn31wYjrjl0ZJHEeIVp+2KfpYs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C76B222218;
	Fri,  6 Nov 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975392; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=T9F6eGMHRkO93M0BvqGAMusPFNwPVE2nZTwMPcHXoJFTTbB3+4NoLHOv1C+toGGOBKGOsM
	Zk4TdOT631Sy0ozE6svg4m/sffbWzP/QAJ9aPH/eJBtbPI2nO8HVCr3M8wwf69BTk6F+b5
	MK/wZecBX5OFBNb0NhG3xr2Kip7cVRY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975392;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=T3BliDtd9hpp3d6y1F+DcpLXvmp5oYhKc7XGdJvyWIGfamCNevWsZnL5z/zeAONom/Wnl4
	zQDZz8EVxlBqibBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975391; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=wP9/6bwLd7Dg8vz1YAVSAYLlngNth8RT+ABVFG/3gC8noUpc2zJt3wyocGMDkrdQWl7x5I
	WngtzrQB3YSlYjHF4Vl+HeqNxFwnSwYziKY4/4ODYOeCUmuJL3TWzdQFFciBGYPJk3dpMv
	52qK1UnCZMrWr2M1XgV/nQ153kZ26bg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975391;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O3BxtbkW6dUgg0e4SBYmdv0h0k2sMGxdODd1ZfZ8Kws=;
	b=JTKT7OmUoUh5jLYQxMNsM55o6rRZZSOOxNxxzyR4vBWtUM8EmfkSYsSlSJG9eJG0uMLMFu
	FomoGh0SM6bwlGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7AA7D132C9;
	Fri,  6 Nov 2026 14:29:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eDMeN17k7WqTdAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:29:51 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7FBCE21B8E; Fri, 06 Nov 2026 15:29:35 +0100 (CET)
Date: Fri, 6 Nov 2026 15:29:35 +0100
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
Subject: Re: [PATCH 3/4] writeback: log the end of a slow writeback wait
Message-ID: <ftkoesjrylhcmtij2gi63wnrkjdjf2ps65cwhz4g7rejhpjdh3@ieu2t4wtnjwo>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-writeback_stall_report-v1-3-bf0c3b9023a5@debian.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4EC5E40011
X-Stat-Signature: w4n3tn9w7sgp9ngw8fsr1ch59g7b7nut
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793975393-422874
X-HE-Meta: U2FsdGVkX1/F1g77GYo83ElzJghl8Jkx0vwpNIch7YhTbMq5qFZaD1JEoGQ+CUdHOW/rIGOJWQyiM5K0AlAHykXm7bLlk2mSQxUJzPoor6PM1GakTrFOKAv0ZirqShnaAzdkBgYMVkEYRDKvYdBc9Exy7b7Z+r4sbs92LwDnefFH5P2EO5HiOyLNbBGbCJTZdoS7phjnQkQ4Kr4d0/ddhAV4NASJmkcSwhqpu0tCswmWsEecVRXgvHVZZFGz+Bj9cwjCHk7Au3mXLEY46BuZsk/efgmjS54qqvEJ7TYKlVquTXj1y6BS6bU4C6KWba/lln6x0cLz3a9SdfoAFI5+rVYtRdtGf41rZRm7LdDo6ua/qQ9eyHjYQb4gk9caMNOTUE92/A9ywOnXhHNu3hkU618WFVwrEbb/dn1c4CZCQ7RvbBDK9V+t3Eq01ErUZTI339u3Bnz//rowDU/28dhIGIlXczgPBLYAZjt4yNDFOLM6OW7VW/+Tv8ESl/94PHr6hQ+mYe2+Zswk+mg7dZUoOKJXlqqRoW9jn9agobmrH9QBnO+o6BnSzvqF40gEVeyCC6PqDUYFJ3qeF4BDp4oHJ3/bHjamvQ1z+0zbGVPgHtQDtTe0N5Oy4h+w92Q2qS1KssJE4weMbL5ifmcYG2VccperXwFOt278zN1ex2mZn7TXtrDjSrMare87UVIIyycXr/9fvsmAnxuUZFbTi005L+MRbXmLiBMIlePAfrX5wdR8rvFdVlrlOGknLMo0CXiZVaCrSV5/s91WmgHdoCuA3rLAcy3/Be0fmyaPKB2o1a6F/IYKJziyLv79KMLS/2tB55nq6IlbK0v0oA4qJbYeMWTlmLacazxMct+070HCFMMVSVT8R9uN18jsATTBgw9G2NCjmc0DRiQgNrpTjJLs2sOx+OCR5uD84HU8ahZ8Z24vlb+k3Ug2nyro5xK+E6HYWnFX/xdxrNvX8EZqnVn
 yWlARQJc
 LgZtMAmi/FNjDQt6g9nZjBOR6KfmlEA3hP+sV/pMl688LxDVOKFZP5WMjUMws/Im8GajjpvouAwfjcFjiTFgHHiMk7rN4bZi26UG+avLik1pHT8J3/Qla9RmjOdND07pJx3uuNE5eG3/4uKGmf3LqFx9xIa28c5N8aAGGnlioNzPUzHeLAW5GPgTbz+ntL9kAcuxxTNrDkznSIDs6ojee3wxQ1xnQrbrlOjMH0//7BxHXnDQK0uoKuq+Jpazsa3am/yCqeDf2dhLND3lunGNEj2Zm6RfUWIz9uwoKnVJcbTQ19bRvVjv9Va689oVy86OJiDbsuW1wIOO8y+XMIuI2OAfo9UEFRpwEzXWRFJUGLWrqnxCxWXp/qfRFPEapnBDX7N9DtKuacqIJ77wegsfWYmBeQBYUSkiPf9YH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 06-11-26 04:26:33, Breno Leitao wrote:
> A slow writeback wait ends with one more "has been waiting" report,
> printed by the wakeup that sees the last work item complete:
> 
>   INFO: The task sync:180 has been waiting for writeback completion for more than 29 seconds.
>         bdi 252:0, work items left: 0
> 
> That line reads as if the task were still waiting. To tell a slow
> writeback from a stuck one, the reader has to notice that the reports
> stopped, which is easy to miss in a busy log.
> 
> Report only while work items are outstanding, and log how long the wait
> took once it is over:
> 
>   The task sync:181 waited 29 seconds for writeback completion on bdi 252:0
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c | 16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 3dee9d65eaf721..cdb2631b8552e1 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -201,17 +201,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  {
>  	unsigned long timeout = sysctl_hung_task_timeout_secs;
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
> +	int left = atomic_read(&done->cnt);
>  
>  	done->progress_stamp = jiffies;
> -	if (timeout && (waited_secs > timeout)) {
> +	if (left && timeout && (waited_secs > timeout)) {
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
>  		pr_info("      bdi %s, work items left: %d\n",
> -			bdi_dev_name(bdi), atomic_read(&done->cnt));
> +			bdi_dev_name(bdi), left);
>  	}
>  
> -	return !atomic_read(&done->cnt);
> +	return !left;
>  }
>  
>  /**
> @@ -228,9 +229,18 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  void wb_wait_for_completion(struct wb_completion *done,
>  			    struct backing_dev_info *bdi)
>  {
> +	unsigned long timeout, waited;
> +
>  	done->wait_start = jiffies;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
> +
> +	timeout = sysctl_hung_task_timeout_secs;
> +	waited = jiffies - done->wait_start;
> +	if (timeout && waited > timeout * HZ)
> +		pr_info("The task %s:%d waited %lu seconds for writeback completion on bdi %s\n",
> +			current->comm, current->pid, waited / HZ,
> +			bdi_dev_name(bdi));
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

