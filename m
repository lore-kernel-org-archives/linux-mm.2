Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5EA606A334
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 14:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=M+zsClbe;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ypqcMtH1
Received: by kanga.kvack.org (Postfix)
	id 3079C6B05B0; Fri,  6 Nov 2026 09:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DF136B05BD; Fri,  6 Nov 2026 09:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5FF6B05BE; Fri,  6 Nov 2026 09:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F380B6B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 09:38:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 85B4012072F
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:38:05 +0000 (UTC)
X-FDA: 85404948930.04.5463E7F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 18FC710000C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 14:38:02 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypqcMtH1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypqcMtH1;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793975883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=fFLdXEH7thAPsN0ru42tSevYS5RPwejAqSDHMl+b3m5oUX2lQXy8sf3urKx5v8bCcq6qtR
	epYzzLBQUpm3B7EINIUheLbv+pWSYIgmp8++V+OUFSpJ1mp8Lvq0eCY0IvVdXkkEM84wRP
	fdl8w0nn8swhzaxq8AM2sSZsL46M4WY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793975883;
	b=HhuDLGbA9+elp0O+eBe463V1QPdZq2Xvfs+uUlVZLRtficXmyYFtQMM7ht+KmZ/98KshQC
	wrDvBWaS057CrHLQq7CWYWHb36BXOQNeahx1dWN+r7EowDnv90ypnT5a4LleXNFnLtIeMn
	zL4MgxuufFaz97KrNNSD6gdw+dkgx4M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypqcMtH1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=M+zsClbe;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ypqcMtH1;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7646B221EB;
	Fri,  6 Nov 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=M+zsClbeXawKRmbSoqHB8vSnhYLKmJu0p6scG/XFngMrof4NKMW5WU57BX+ALDhhWh8zdA
	HiEoHs64z4KRdRn/SjV56lAOiqqKPdqQGCnXOc/vTupbZySjLolBP6yyT+KwgH4B3PayaS
	a/utAwrfz6visoWpK4l3sJhLXQi+t/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=ypqcMtH1se1Qo38hsRbeYY9AZlO51QMWCAFqrzHQSnRWsVHs7k2atX/I9V1UzcS1gJuH3q
	u6mepYdynYhyV5BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793975881; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=M+zsClbeXawKRmbSoqHB8vSnhYLKmJu0p6scG/XFngMrof4NKMW5WU57BX+ALDhhWh8zdA
	HiEoHs64z4KRdRn/SjV56lAOiqqKPdqQGCnXOc/vTupbZySjLolBP6yyT+KwgH4B3PayaS
	a/utAwrfz6visoWpK4l3sJhLXQi+t/o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793975881;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U1z9CMMlVvK3cpazVIozIjM4XgDTPtKDlnzc7HGPx3U=;
	b=ypqcMtH1se1Qo38hsRbeYY9AZlO51QMWCAFqrzHQSnRWsVHs7k2atX/I9V1UzcS1gJuH3q
	u6mepYdynYhyV5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D2FA132C9;
	Fri,  6 Nov 2026 14:38:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GgbfCknm7WrifAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 06 Nov 2026 14:38:01 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id CB2B421B95; Fri, 06 Nov 2026 15:37:45 +0100 (CET)
Date: Fri, 6 Nov 2026 15:37:45 +0100
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
Subject: Re: [PATCH 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <ysxh2sfvjikoh6cw2qmk2i6p7xripwnqxkx43jj7unxop5tkiw@gws5wezjt34g>
References: <20261106-writeback_stall_report-v1-0-bf0c3b9023a5@debian.org>
 <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106-writeback_stall_report-v1-4-bf0c3b9023a5@debian.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 18FC710000C
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fiw8nhbihnukoia3w7k7pkjgwdheied8
X-Rspam-User: 
X-HE-Tag: 1793975882-892054
X-HE-Meta: U2FsdGVkX18HFzTqfjT/AafIo9O99Q2QMHpscnATHgJbl8PRJH3DFhNTlLEa29H+H5dsdYXjF2is9IngP343LmNmNnZQgqhbk2Qcpnd93Hj3W3m1gd2iU9cl5KWyQNc49Y/OJ25YGQjkU5E0Zbzi0yJx1oY0Y2KFpb3QMyuQDO8Rea11x8icST2E24CHOShDbgze6wYg+C6561wY/TYS08dvPamoIqyZODCuQ5+OIz4VXMEeb+Vz5EmDtyEjBp8Mvw6KpDlKWMzjpP+d88DT06qNZNAF3SsQLQIGOtXoU1HFqk26MD/HTkGVnfi/81xTYUU95AuuDw5CJxm6/jotcm7FqYM8Pc9R4/zEGoDaLf5xjOkxE+qMcbuT25ZG15roL4Qm6CHD0JvgC79WQsPN5lkL68F6XcJKyZdTKtCrwohGlTR1yvyHs+GAqjbwOpmc+R3QxiEr7ujccPcn3mdqZSvCBfhS6T0KKdAJb9DOBO43ol047pTz/HsgoTCAx1jzJwlCBwTc/7+vrijK8X7P3CQOfPvVeu7BJjEbbK0Z1myTyWKTn+zFNbGj43y93xIa4B7lYWtGQJTTUqb7IOsCZ6Hn27S8W6Y1+B5bJdNnXBeG2/AUt9f9sgpffeDnXfgxEdnVPry5X6vMf0xMARpkZASQhE2i6drybxoWiOxPpLSZjuDnsNS1rF3EVl5NE5vX9rqOo1lH+w26/WHHYq1UHwY33qYVhD8NO8/jxFDyEzOA90wjY1X6a/IWCL/+dSnO0l/CWFrWa68X4B5o48MAhbYNPAnZ7ExgDzpMUxEC20zfyF4dtQjvghsoOpJlpcs3Vu3u5WVA0NMNc/XrdHrldCNFQjOualzkrCLz3vAyV5ZwmJjkpIKep9UEj1rHozKl26fXzrqimJcOkxGfLWoOuF54uZam+wfLb6rwQCNWQnM4gD/gVVJ8bGd79Ekk2pVzGRqNfwGOve9I6B9hgvp
 6FNz26Iv
 A/R1IPZJpvQPvPiA3K/+fj4aJIDdjok2iDRa+v2Gu2W1RvuIVUxE8VkQ9R1q4PvtjFZfXGtfImAfL/Odk2JJ1o5rQ4+hI3Xir4A4N1c+ubgly/DyiQ3m8j92O9smK4OY08RcLSAkrAcMZRZ2BGT9/vw7EhiKA6SI/rWSWGYjFCjlNbS5mgBtCEhU8vC40s2r0INsWFIUJgAibKiD0EAsD+iFoA2BSb3Z8h18cTLaS9uXklNMtifcAaVLeMxBih1hWYEw9rnKz84/dWng3YqXLFkS/gOPwLwHuAHM8+q9QAaPvWVViApallaBLapRccnu3tnQqUJUJswisLwQSwbZNB62TlnNaRVYtZ0a0W6dv+vRmKC8LfIH7nWUq5yCSryRFQ4d6v5chKI8dcFcwc09svxvGUqJzmbDi2sCp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 06-11-26 04:26:34, Breno Leitao wrote:
> The slow writeback report is printed on every wakeup of the waiter past
> hung_task_timeout_secs, and the waiter is woken more often than that.
> 
> Each flusher working for it wakes it once it has not run for half the
> timeout. All waiters on a bdi share bdi->wb_waitq, so a wakeup meant for
> one of them reaches all of them.
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk device
> with the timeout set to 5 seconds, gets a report every half timeout,
> each printed twice, 18 reports for a 29 second wait:
> 
>   [   10.327992] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
>   [   10.328000]       bdi 252:0, work items left: 2
>   [   10.328003] INFO: The task sync:276 has been waiting for writeback completion for more than 8 seconds.
>   [   10.328004]       bdi 252:0, work items left: 2
>   [   12.888187] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
>   [   12.888195]       bdi 252:0, work items left: 2
>   [   12.888197] INFO: The task sync:276 has been waiting for writeback completion for more than 10 seconds.
>   [   12.888198]       bdi 252:0, work items left: 2
>   ...
> 
> Remember when the waiter last reported, and report again only once
> another timeout has passed. The wakeups do not change, so the hung task
> detector still sees the waiter making progress. The same test now
> prints 5 reports:
> 
>   [    7.661129] INFO: The task sync:277 has been waiting for writeback completion for more than 5 seconds.
>   [    7.661136]       bdi 252:0, work items left: 2
>   [   13.241102] INFO: The task sync:277 has been waiting for writeback completion for more than 11 seconds.
>   [   13.241109]       bdi 252:0, work items left: 2
>   ...
>   [   31.801068] The task sync:277 waited 29 seconds for writeback completion on bdi 252:0
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Now I'm waiting for someone to complain it gets written out too
infrequently :). Is this change substantially different from
writeback_sb_inodes() waking up done->waitq less frequently?

								Honza

> ---
>  fs/fs-writeback.c                | 5 ++++-
>  include/linux/backing-dev-defs.h | 1 +
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index cdb2631b8552e1..8d354784326f7a 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -204,7 +204,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
>  	int left = atomic_read(&done->cnt);
>  
>  	done->progress_stamp = jiffies;
> -	if (left && timeout && (waited_secs > timeout)) {
> +	if (left && timeout &&
> +	    time_after(jiffies, done->report_stamp + timeout * HZ)) {
> +		done->report_stamp = jiffies;
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
>  			"completion for more than %lu seconds.\n",
>  			current->comm, current->pid, waited_secs);
> @@ -232,6 +234,7 @@ void wb_wait_for_completion(struct wb_completion *done,
>  	unsigned long timeout, waited;
>  
>  	done->wait_start = jiffies;
> +	done->report_stamp = done->wait_start;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
>  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 4f10849373150d..f9fd3b1bf4c609 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -67,6 +67,7 @@ struct wb_completion {
>  	wait_queue_head_t	*waitq;
>  	unsigned long progress_stamp;	/* The jiffies when slow progress is detected */
>  	unsigned long wait_start;	/* The jiffies when waiting for the writeback work to finish */
> +	unsigned long report_stamp;	/* The jiffies of the last report */
>  };
>  
>  #define __WB_COMPLETION_INIT(_waitq)	\
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

