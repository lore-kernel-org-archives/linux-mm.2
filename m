Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 664D7606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=jfspbYxx;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=LxszwG7b;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Mc5SRKx4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sD9sTYYB
Received: by kanga.kvack.org (Postfix)
	id 875146B00EF; Wed, 11 Nov 2026 09:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8242F6B05B0; Wed, 11 Nov 2026 09:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 714436B05B1; Wed, 11 Nov 2026 09:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B80D6B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:37:32 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E518BA7CDC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:37:31 +0000 (UTC)
X-FDA: 85423091502.24.3AEA571
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8BD32180002
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:37:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jfspbYxx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxszwG7b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mc5SRKx4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sD9sTYYB;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794407850;
	b=AvixeYEVmL0+bwKKPaLfwiXu9fQD/2dIpuqAu2ATF0WMv3aeX1VO2LqtibgLN1LvQl1VYt
	fMwkK+bm2InSzB98STD8lTSA5QWgnqGM6lbaJamjoOFvuo6eaZLbA9LqMj+kt9s25QMmm0
	W/9AOiRzOp2Q1QA49NPcHkR6tMN44D0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jfspbYxx;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LxszwG7b;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Mc5SRKx4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sD9sTYYB;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794407850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O+HDSzgsBsov3BG+U6eNO5vEVeoxzMoOfJ4y2pKnmxk=;
	b=2maiqV+TbgrxTTQ9G0S7YM8UI/ZHAaek4flGdBoIwyyauUh/yF9yeOsPmFSP5TFz7Ky4zJ
	6ZgYWxSLWWJSQmlykDph3Fq2ntX/dHcWzQxyZpIV6wyvRJJQEPVGtECVwlT1MWFlIiqyeF
	wUC/JRCp+/YIGGL4BRiIzOepfNz0GOs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79DE633712;
	Wed, 11 Nov 2026 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407846; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+HDSzgsBsov3BG+U6eNO5vEVeoxzMoOfJ4y2pKnmxk=;
	b=jfspbYxxMxn5aSuH4wuf7B7wVb7W0FSEy93AAyuKPvi5wa4biFCwWslailyNYdya94eli4
	HADZ7Spe4yQrMb0HgFXcSlZ+UmfumtTM6AhKKPKJ2zpeOc+Yu1yY2NQaJet4Cj8zS4OOlQ
	HXu4Y0S1HlCnJFRN1gt/rZ8UtN+onlE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407846;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+HDSzgsBsov3BG+U6eNO5vEVeoxzMoOfJ4y2pKnmxk=;
	b=LxszwG7bvoVcQXAAYRVI6atvXtM5yiMvfNxwMoedCsmuRiz22UYp1gxn1vIpiOHVzPL4VT
	krYvuUb16YK+TYDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794407845; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+HDSzgsBsov3BG+U6eNO5vEVeoxzMoOfJ4y2pKnmxk=;
	b=Mc5SRKx49u8+JyKc25u/O2IhCiYywm8wGceXtSYRpAYykKRSjwuhOmV+uriUHqcDDzWlC4
	PRO+14KUinJreN3z30xbe7AgmISTu8u+VPbDwfLtPfJSIcOhsuZuQeVJgqLZQxn/4SQ6xs
	EeuVnWcUgMvODV91UG8btF1jBZNpa1M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794407845;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O+HDSzgsBsov3BG+U6eNO5vEVeoxzMoOfJ4y2pKnmxk=;
	b=sD9sTYYBfwCAiCtwsKWRK7KEbAjqnLnbruL5uXWNOzT3ygig4GZj2/8yqNQrTMpNNh2tg8
	IavcNxUBJujcRuDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 43F81134E5;
	Wed, 11 Nov 2026 14:37:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id O11dBKV99GrZGAAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 11 Nov 2026 14:37:25 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B3D372294F; Wed, 11 Nov 2026 15:37:20 +0100 (CET)
Date: Wed, 11 Nov 2026 15:37:20 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Breno Leitao <leitao@debian.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Julian Sun <sunjunchao@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, kernel-team@meta.com, tj@kernel.org, 
	mkoutny@suse.com
Subject: Re: [PATCH v2 4/4] writeback: report a slow writeback wait once per
 timeout
Message-ID: <67les5imq7hn2my3aiehxdwr43fg6pamqzxz4owrdb7efotgi5@jgvae6eosgqc>
References: <20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org>
 <20261110-writeback_stall_report-v2-4-9e0ed75074ca@debian.org>
 <sashiko-outbox-208900@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-208900@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Stat-Signature: u6zjt1e3pnpk3xr4ckqb1pkdojp9wj96
X-Rspamd-Queue-Id: 8BD32180002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794407849-930508
X-HE-Meta: U2FsdGVkX1+g66GRcuBf7Ms9DyB45dWBfngzQ9xmO8i5fdK5sH8SPmBltAkOwck5NfkhcHs4kRFtBhygb/wNFu4x/7NA5Vl4+ZOF/nK9O0+WGjA4/8H2/kIBZ/AXW6TIGhWq+5iCZgZFsXzFnLtF+muiVq0RfqDZ404O97ynPCjBASVuLe0Q5KbXyZQZHoAoWgS7UV4xrYNGrpia34cqs0A/VsyRPo1qwrGlLo9g8C276N4Ppg5wLc/bLSG5/SEN/iRt5sm0MAxM/+V5edDmHUHySvxywy0hU/1EUa/E2MCsDu5bmzx/hTGOBvByJB9DNgk0u5fyHDMsk35VdJ6RBAgX/d0nzfmi+qf4G+/rjyfkjv7/3Q+QIFWHTBWIbrDbnENLLWprR8F9ATx9ljQcs6DJrmjmK8EGzweOaS+B8VAa3qtYlYoRAbWSPTKJVav4esfU8qN48o+fAVJZrYAKYLaD6IZcOlYrO9P1izys4/o0MDIQQETwNYK7J33EnUkZ3igdIabr8BJ7lO7agHpc2H3kqSyhR9gu5crsWcD7C25t0d80/ZpiZZcX6Gr9wxvepHbbXHB76T3y7vlpuBy1KqI7py3oUyoe3RxEFi1b4YyP+21xNNMQdXPTqnP+BNBJGwHPPT38ApqRDF22ytvkKkUAoMS4m806yhdW+t9RIBWK6ZrnMwS1poGK1nyHy3NQIp3YlyP7zVDiEeMBGXyLQ33XrsWDCUyv4g0XZfUKLZ9n0Jrd/8/aNhZuAJAxWoRT5vT4dg1r5re5WTck0igPLbsNcbEj1e6bHq88R1K2nKUE/FEHQJfM27zECSk/m/qHPNyShkxD5XbXqYGiwbBCmsP5B3yeYkk/qLq3qfC4ukvxSqbKBqGunu6/F0si8FWNjCVdewZH06dOA+5rTFf4z4y04yrpCJllhRRCBUx/+RkHpRefZS4xarnODn3Qmi4oWIDzZKguHE6tNYITTWf
 IQB4QQ2S
 5gGmcL32TzKus7GpUs/NzCW2O8DFPrU3Cwa5PWLTQxNd8LJYa4UqtBtpuEoLtl7tH5J+kEFJ22wNto/9oXJwHCpJ4qaoMrSvCWXex7NNXuLDSmFidicpxkerFmzDH7MLATZatZmT7oEXUeKsCSseM5vziBZ1v/8sFFbYkuK2al3PJp7B2yM63cRk1of5uT+I34SXz2ZBvJjTp0Mw+S2l8qgBUyt6AE7+8pjeRblylX9/68dJIa04U+DXEv/xsxFn5A/nk3wagbe10eDNouLqBKqAls+C9UnimvJlBI1F0P7EdnLPYzCjDzvEC2nJcRIi9zryiL6pbrp2SssRBHIyw7DncwhH2Km6gf5KwezQG5HwYihtzfAQaMWDFoUrdLDrQ0vK4uTKJCZzy7eZmA8M/JFQqVZ0oJUJ5WURNbuyHBQLgQyhAvESHiyv23oo+yyMi6zdHw/no/qDKIJvU0parmBs6Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 11-11-26 11:47:37, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] writeback: hung task wakeup interval exceeds timeout in
>   writeback_sb_inodes()

Aha! Indeed this was the reason why we chose half the hang check interval.
So we really have to go below that. So maybe just fix the duplicated
messages and put up with report twice per hang check interval? Or we could
use 3/4 here if you think it would be better.

								Honza

> --
> 
> commit f3edfd7b6ff429943317ab66c7dd1c29f9226156
> Author: Breno Leitao <leitao@debian.org>
> 
> writeback: report a slow writeback wait once per timeout
> 
> This commit rate-limits the slow writeback report in
> wb_wait_for_completion_cb() to once per hung_task_timeout_secs, initializes
> done->progress_stamp when waiting starts, and increases the progress wakeup
> interval in writeback_sb_inodes() from half the timeout to the full timeout.
> 
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index e2da4781b5e00..fcb7fb0196208 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -203,12 +203,13 @@ static bool wb_wait_for_completion_cb(struct wb_completion *done,
> >  	unsigned long waited_secs = (jiffies - done->wait_start) / HZ;
> >  	int left = atomic_read(&done->cnt);
> >  
> > -	done->progress_stamp = jiffies;
> > -	if (left && timeout && (waited_secs > timeout))
> > +	if (left && timeout &&
> > +	    time_after(jiffies, done->progress_stamp + timeout * HZ))
> >  		pr_info("INFO: The task %s:%d has been waiting for writeback "
> >  			"completion for more than %lu seconds (bdi %s, work items left: %d).\n",
> >  			current->comm, current->pid, waited_secs,
> >  			bdi_dev_name(bdi), left);
> > +	done->progress_stamp = jiffies;
> >  
> >  	return !left;
> >  }
> > @@ -230,6 +231,7 @@ void wb_wait_for_completion(struct wb_completion *done,
> >  	unsigned long timeout, waited;
> >  
> >  	done->wait_start = jiffies;
> > +	done->progress_stamp = done->wait_start;
> >  	atomic_dec(&done->cnt);		/* put down the initial count */
> >  	wait_event(*done->waitq, wb_wait_for_completion_cb(done, bdi));
> >  
> > @@ -2135,7 +2137,7 @@ static long writeback_sb_inodes(struct super_block *sb,
> >  
> >  		/* Report progress to inform the hung task detector of the progress. */
> >  		if (work->done && work->done->progress_stamp && timeout &&
> > -		   (jiffies - work->done->progress_stamp) > HZ * timeout / 2)
> > +		   (jiffies - work->done->progress_stamp) > HZ * timeout)
> >  			wake_up_all(work->done->waitq);
> 
> [Severity: High]
> Does raising the wakeup threshold from HZ * timeout / 2 to HZ * timeout cause
> khungtaskd to report false-positive hung tasks (or panic when
> sysctl_hung_task_panic is set) during slow writeback?
> 
> In kernel/hung_task.c, task_is_hung() stamps t->last_switch_time with the
> time of the scan that first notices a new switch_count, not the time the
> task actually scheduled:
> 
> kernel/hung_task.c:task_is_hung() {
>     ...
> 	if (switch_count != t->last_switch_count) {
> 		t->last_switch_count = switch_count;
> 		t->last_switch_time = jiffies;
> 		return false;
> 	}
> 	if (time_is_after_jiffies(t->last_switch_time + timeout * HZ))
> 		return false;
> 
> 	return true;
> }
> 
> Because writeback_sb_inodes() only checks the threshold after
> __writeback_single_inode() finishes, consecutive wakeups are spaced by
> HZ * timeout plus the time spent writing the next inode.  That wakeup period
> is strictly longer than khungtaskd's timeout * HZ detection window, so a scan
> that runs right after a wakeup can be followed by the next scan at
> last_switch_time + timeout * HZ before the next wakeup happens, defeating
> 1888635532fb ("writeback: Wake up waiting tasks when finishing the writeback
> of a chunk.").
> 
> Keeping the wakeup threshold at HZ * timeout / 2 while tracking the last
> pr_info() timestamp separately from done->progress_stamp (or only updating
> done->progress_stamp when logging) would avoid waking the waiter late.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261110-writeback_stall_report-v2-0-9e0ed75074ca@debian.org?part=4
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

