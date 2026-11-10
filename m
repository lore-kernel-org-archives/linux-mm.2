Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F6E2606A9E8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=qKQcYFUJ
Received: by kanga.kvack.org (Postfix)
	id 83A116B05B7; Tue, 10 Nov 2026 08:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9C46B05B8; Tue, 10 Nov 2026 08:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1EF6B05B9; Tue, 10 Nov 2026 08:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A4866B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:27:22 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C135F806E0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:27:21 +0000 (UTC)
X-FDA: 85419285882.14.90429E0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 62590100004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:27:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qKQcYFUJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qKQcYFUJ;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794317239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=Bi68UrD9+YFLEsQHoY1HsUiE03XExZ+CfWn3DTp9rzrJzFkQIVy0tjI1tOrWUquElQ2+Rf
	ayTxNZE+2ZrSnkc+PLzfDH/FNxwSkanwQMgtU6lgP8TTQhw9qC0pQVpsny0CXrwGgG3Poa
	+uXDgSF5Zj6GI9QbNVtytNP5YQvSxXY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qKQcYFUJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FSjbyIy9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=qKQcYFUJ;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794317239;
	b=4kzKQ4QUKtQpcDt7UIbWeWFNzVW4G0mF3nl9Uu55H5JUEplcBccaclSIxawpFj0zV2Mb7b
	/BimMAMNwKeAtB4c0M2Ozxw8w1TtDrK8s+jZ41kbvD4WFziqjucnESZIq80vCfOBlrgLDn
	AaFm3MOO43mHb/zYiiOSWhOkTBI4D1M=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F1D6521EB9;
	Tue, 10 Nov 2026 13:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=FSjbyIy9Eh1iq1WYwFosAs5h+QdUj3JseqQK+/Fyngw44MBKrqZiWFoCj6JPHfk+Yor7Yv
	Ef5CjXcET1VuoMjCctjuHDtpjbgZxWKDM3CGgXt37JOHFI5plgNG9+eiFs1UOtmBezmV/9
	jBnnqcWbLq3hzUNPZS5kkwXUdmqfEuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=qKQcYFUJwJDWgKs0ErrbPdtu7yBepQbcQ6AITcH4Or8odAuLrS/V+qsslwZsMkhAvyIErp
	kS7QeLuGL42NmECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794317238; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=FSjbyIy9Eh1iq1WYwFosAs5h+QdUj3JseqQK+/Fyngw44MBKrqZiWFoCj6JPHfk+Yor7Yv
	Ef5CjXcET1VuoMjCctjuHDtpjbgZxWKDM3CGgXt37JOHFI5plgNG9+eiFs1UOtmBezmV/9
	jBnnqcWbLq3hzUNPZS5kkwXUdmqfEuA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794317238;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OEj0ekxd6A5KeTUcTn8WVZemqTJFfGo7oDr4aSPmVaA=;
	b=qKQcYFUJwJDWgKs0ErrbPdtu7yBepQbcQ6AITcH4Or8odAuLrS/V+qsslwZsMkhAvyIErp
	kS7QeLuGL42NmECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CE66B13479;
	Tue, 10 Nov 2026 13:27:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Bx7ZKrUb82paYwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 13:27:17 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6146B2250C; Tue, 10 Nov 2026 14:27:17 +0100 (CET)
Date: Tue, 10 Nov 2026 14:27:17 +0100
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
Subject: Re: [PATCH v2 2/4] writeback: name the bdi in the slow writeback
 report
Message-ID: <llelav5t3bcbtyiujoe6lmqrzlgfcgc7oq7o2mfrzpio4c34d3@6ak5d4z7jqmz>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-2-9e0ed75074ca@debian.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-writeback_stall_report-v2-2-9e0ed75074ca@debian.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Stat-Signature: agixmp7k8ukws8hu5uosgdzh1tb93kmi
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 62590100004
X-HE-Tag: 1794317239-593347
X-HE-Meta: U2FsdGVkX19b0MGdZPlbfAsbgodb3OEEdIPQUNGWy9ui58nQilSKjNEzel1EfHI5zCRKvDQja+vYHgK+u46Kf3WaiE0tJkdqzDbuQbVhJpIyV//drJ+pnRyinROmmKx9WZOijDE6+x5RXoIsWviKg6BGb3BhSF95iOwqH6wWONy3zwooK/OdDcNlhkOwO/5XCmty+caq8Jd9fBz+5Tp8SCd2evobLs14RkPZ+wjtksIQDbLWcYgr7dhFuAjasPT3QdrfqwzIc/Z+5AzM25Ntjyq9oYe5UH0Pro8NSbsDBhqNnWCnqP/lxfbRvVahGtFiilNGC2RCYZm2khXBoByZOCrGUXwdNHuWs2A7GoDAqAq0YCHgyhEVTYdeSuwI03FN2I7V0GPsFwtWbWCZRcgQm1TCI+ly4Ps9JTs75UAa3OV6Qufl9/U0vIL6+fV/x7/aZpAgkVq7IAEgH6Q/ayMmd27ld0ZpG/ylD/GzxA2hnnjjMNrhxBc1jWEbaEPMaM5vJG9nK9yW1N0fUcC9K14IxWLhknFeASgg2BuP9rxxV1ta6nBpDD9cQrc36pR0JkpHlZkPZ0GmSRluWJqt4ljXpkPv0JD23OLxkL8llzg5LjfNiR/PqBJKUZNqczPf0R1DmZRxyhmbanlVRH32XWh/M/AZdREW9Gb7PNnN/Fvlw/6DnXKJXH8VVJI83uIK5dPbQke/7gK1vEz5ikviDt7FdCv6/FdJut79na7xKRTjTVAAriEZjjJgu3tiPh4dZrjhMkhOYW3byNAi0uUiLRC8g7IUakUrfdOmt7FfHFFTcBRiUwTNFnXLw/BZ4+NLLWSB4/fxtVCObwxHnPI8SyalNLAmJChMVSmiWvKNw9xbuGsVUupynx0urBDYcLo4AhKroRwgpOIriuCaZ1524g0qShOpuIQlldGgZ1vojGgWtYuSF485NT1adFAzJbBjLbNcQgwLnqzj1w8dZtXiQLk
 Hvt4y7p9
 Qa5O23sXGHc4tKuFTo6gvmeFhXMYuKFG9qmjSlRRxz7HiiPeG6p7bkIzZQjtZdI6fR09JSGYrFqf35i5/rjJQJ6ybhO1HOXArsZIIQ/BXncX1ZKy9VEJDnVedVDBhBN8vdXLZWJ4VBKtkH6yvi22YnhAYWyo5HTEJ1uwu34/7dJ4rDZ9Nmt2+z81DUa9nxBC3BgM0d9aMDSzpE99eDI8nex2vHij+lFvTeeeJbAqiyoikCUD3U761RSGUIWvxL8BEOiRhQQOhlYYwxjoR0dbg3ljYhnGgCFWsG+hzoS9CU/b8P0n/j/adSyCr5nO0tDdA0lDujeHbu4Sd8prj45L4oGvJIk4E1qH9Mg3lEsa2ZSoct/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 03:39:28, Breno Leitao wrote:
> The slow writeback report names the waiting task and how long it has
> waited, but not what it is waiting on. On a machine with several
> filesystems there is no way to tell which device is slow.
> 
> Pass the bdi to wb_wait_for_completion() and add its name to the
> report, together with the number of work items still outstanding. A
> sync issues one work item per cgroup wb with dirty inodes, so the count
> also shows whether a single cgroup is holding up the others.
> 
> wb_wait_for_completion() took the bdi until commit 5b9cce4c7eb0
> ("writeback: Generalize and expose wb_completion") made it usable for
> the memcg foreign flushes. memcg tracks those by bdi id only and passes
> NULL, which bdi_dev_name() prints as "(unknown)".
> 
> A sync of files dirtied from two cgroups, on a throttled null_blk
> device, now reports:
> 
>   [   10.043698] INFO: The task sync:276 has been waiting for writeback completion for more than 7 seconds (bdi 252:0, work items left: 2).
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c           | 20 ++++++++++++--------
>  include/linux/backing-dev.h |  3 ++-
>  mm/memcontrol.c             |  2 +-
>  3 files changed, 15 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 01a00d7542b371..c5e9e5c0d506a9 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -196,7 +196,8 @@ static void wb_queue_work(struct bdi_writeback *wb,
>  	spin_unlock_irq(&wb->work_lock);
>  }
>  
> -static bool wb_wait_for_completion_cb(struct wb_completion *done)
> +static bool wb_wait_for_completion_cb(struct wb_completion *done,
> +				      struct backing_dev_info *bdi)
>  {
>  	unsigned long timeout = sysctl_hung_task_timeout_secs;
>  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
> @@ -204,8 +205,9 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  	done->progress_stamp = jiffies;
>  	if (timeout && (waited_secs > timeout))
>  		pr_info("INFO: The task %s:%d has been waiting for writeback "
> -			"completion for more than %lu seconds.\n",
> -			current->comm, current->pid, waited_secs);
> +			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
> +			current->comm, current->pid, waited_secs,
> +			bdi_dev_name(bdi), atomic_read(&done->cnt));
>  
>  	return !atomic_read(&done->cnt);
>  }
> @@ -213,6 +215,7 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>  /**
>   * wb_wait_for_completion - wait for completion of bdi_writeback_works
>   * @done: target wb_completion
> + * @bdi: bdi work items were issued to, NULL for the memcg foreign flushes
>   *
>   * Wait for one or more work items issued to @bdi with their ->done field
>   * set to @done, which should have been initialized with
> @@ -220,11 +223,12 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done)
>   * are completed.  Work items which are waited upon aren't freed
>   * automatically on completion.
>   */
> -void wb_wait_for_completion(struct wb_completion *done)
> +void wb_wait_for_completion(struct wb_completion *done,
> +			    struct backing_dev_info *bdi)
>  {
>  	done->wait_start = jiffies;
>  	atomic_dec(&done->cnt);		/* put down the initial count */
> -	wait_event(*done->waitq, wb_wait_for_completion_cb(done));
> +	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> @@ -1164,7 +1168,7 @@ static void bdi_split_work_to_wbs(struct backing_dev_info *bdi,
>  		last_wb = wb;
>  
>  		rcu_read_unlock();
> -		wb_wait_for_completion(&fallback_work_done);
> +		wb_wait_for_completion(&fallback_work_done, bdi);
>  		goto restart;
>  	}
>  	rcu_read_unlock();
> @@ -2972,7 +2976,7 @@ static void __writeback_inodes_sb_nr(struct super_block *sb, unsigned long nr,
>  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
>  
>  	bdi_split_work_to_wbs(sb->s_bdi, &work, skip_if_busy);
> -	wb_wait_for_completion(&done);
> +	wb_wait_for_completion(&done, bdi);
>  }
>  
>  /**
> @@ -3069,7 +3073,7 @@ void sync_inodes_sb(struct super_block *sb)
>  	/* protect against inode wb switch, see inode_switch_wbs_work_fn() */
>  	bdi_down_write_wb_switch_rwsem(bdi);
>  	bdi_split_work_to_wbs(bdi, &work, false);
> -	wb_wait_for_completion(&done);
> +	wb_wait_for_completion(&done, bdi);
>  	bdi_up_write_wb_switch_rwsem(bdi);
>  
>  	wait_sb_inodes(sb);
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c2284466e7aa66..808d939d2ca7f9 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -39,7 +39,8 @@ struct backing_dev_info *bdi_alloc(int node_id);
>  void wb_start_background_writeback(struct bdi_writeback *wb);
>  void wb_workfn(struct work_struct *work);
>  
> -void wb_wait_for_completion(struct wb_completion *done);
> +void wb_wait_for_completion(struct wb_completion *done,
> +			    struct backing_dev_info *bdi);
>  
>  extern spinlock_t bdi_lock;
>  extern struct list_head bdi_list;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ac6c43ea8c5a6d..df462d279a655e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4525,7 +4525,7 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
>  	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> -		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +		wb_wait_for_completion(&memcg->cgwb_frn[i].done, NULL);
>  #endif
>  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) && !cgroup_memory_nosocket)
>  		static_branch_dec(&memcg_sockets_enabled_key);
> 
> -- 
> 2.53.0-Meta
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

