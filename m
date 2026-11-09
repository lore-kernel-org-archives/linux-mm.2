Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7B89606A31C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 13:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nfJm8OHh
Received: by kanga.kvack.org (Postfix)
	id B4D526B05B2; Mon,  9 Nov 2026 08:13:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24076B05B3; Mon,  9 Nov 2026 08:13:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EDF16B05B4; Mon,  9 Nov 2026 08:13:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7077C6B05B2
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 08:13:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DAE841205DD
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:13:51 +0000 (UTC)
X-FDA: 85415623062.26.1CD7150
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 29E1D180007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:13:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfJm8OHh;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794230030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jQJsS30mfWqnutp4T/axVYFvwalLvCNK3lARAafv5M=;
	b=F2GkaziaHMePTvxh3e8qu0ZaC9MsezWLclP+B7bz3sodvPZtTT9QFWvjg9k7E5/rryxAqg
	kYN9MWOwHswJ1XHhj4pA++Ic+Ri7HHtIHweitbniYO5vAeYGSfY//8UEsY8vmOeVj/5cws
	UWcX+Nv2T1fdjfWtNQOl+5wruR06b1Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794230030;
	b=LAg2hKWFx3qjXV4RMll3FZb9pRowybcmzBFRYu5ddmIvUriyvW/FWJ7t8fcIzUk0PwRJvK
	Q5DKeioTTH+wLI4DE2Bq7uFtoqSQZOmyN9FsHwg3VLptNcWUMTDicBLZttC4a1JEudSajo
	6LiSIh41QOila7x8X2IWdhlOEvaASjM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nfJm8OHh;
	spf=pass (imf06.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28162402C9;
	Mon,  9 Nov 2026 13:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3091F0089F;
	Mon,  9 Nov 2026 13:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794230029;
	bh=7jQJsS30mfWqnutp4T/axVYFvwalLvCNK3lARAafv5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nfJm8OHhyNANdak70pijBgAfPa88EnbFGsqwMrmWGsIIpiZ9oe1IOmuKMfkZFtHIY
	 l+EmlByl7y51Sjmkwawrghx/6hUDawrTZFLoQlCNN0lJU1ULlDME2LDFmpn+aBvtfG
	 Mhi3qqSbWZXaybzsgN3VrlHVk6NeaEAfVxWXc0LRpcfE+77roaidWe151Bc1UoYOpp
	 yJQjnoTQeWNQetvIJKRQvREGjwuYukX0EL8jxW9WdsuJGpMtyNnaV4643eo8tgitM2
	 Tb4ftJXCww3eNUNKUyoh6Yt1ieWGe6+17QiBr8kpNPFnGOUg4x+BsX7p40GVd1EWk7
	 kFZ4s4lbqwHtw==
Date: Mon, 9 Nov 2026 13:13:46 +0000
From: Harry Yoo <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Zhan Xusheng <zhanxusheng1024@gmail.com>, vbabka@kernel.org, 
	paulmck@kernel.org, qiang.zhang@linux.dev, akpm@linux-foundation.org, 
	hao.li@linux.dev, cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, rcu@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhanxusheng@xiaomi.com
Subject: Re: [PATCH 2/2] mm/slab: don't queue the page cache work under
 krcp->lock
Message-ID: <avG1Yr9sjswFoJ9E@thinkstation>
References: <20261028134647.3176080-1-zhanxusheng1024@gmail.com>
 <20261028134647.3176080-2-zhanxusheng1024@gmail.com>
 <au2fUYzBLv3uvj_2@milan>
 <au3ELzm_s9vhs7UO@thinkstation>
 <avGzD8CAgg9Hif__@milan>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avGzD8CAgg9Hif__@milan>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 29E1D180007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kepop9fm1qfowoeqi6phc9z3paxy3ppw
X-Rspam-User: 
X-HE-Tag: 1794230030-389108
X-HE-Meta: U2FsdGVkX1/B5LANFDammg7nvBAr4Td9XOpoaHhosEo9kMDRhklO/eqK8zvU0phXtBXb0jYApH3a8Jnd2B4IefkwKwWR2gS/hBnNcsm4G5ss09pP4xJJ0eWD+c1DtIokelsWubtiVsl+x00aqYo4WHx3MYNmK7lkWfqFhOZ6+cpMd5MiR9LuNGGdRuYONMyPZfpYcX++ZaOTLAvI7vDIA1zy6XGntQLiIIWCgAlOMB/CUtl1G9dG70IPY0h/tr4FB6uCmd5Ko189TWxTWrjH8m4F3VKbyEwhcgsWS6ld0TiVdIZDEmp7mnB+HR3IdDrcDOTryIyJrCw3Hh+Xf9ltaRVPp2W8rcOJ4Dkm+uXg1t/fyGbsEFAwjNJ7u0JIzlMYvr+CQ/FVEm+ocq8ZsGndM3FjWOFdZunt8kgHv4cNLrvR89m86U28LV5nyXZ5bmhuDvjvAdE3uUU1rbpS8UxC5gciYGFkFifxOlm/1HH4JxacfK9tI68TLH5qdA9fbt+CAhNjedOStqjWEa2zzoJ/P/hdGp3TMUrA5yboeLsHHpcuOG1rES5hEgcWXqGmKaTIh2P0pCdERvpPB/7yUDzvHTzcXBebTtlGUJvDT0lgR8w9Q6s916UesiAP/I+0cuP/aPtTWReFIsGdTNBz7w+CT7D3lXNpXLvF6Igkh+MA3Uo7zw+awTFLwNfsFTQK5IIKG4Lu8rwfVSOSQ8+xjrnH7DmAgipW/uyztqc7vUzyEo1k+Nz9YuhATLtH1PfS1nyr8bo8dNnYKi1bo277I3AIkb7wRMCs28j0KanhCmJVDbjVuxo3pnJrPLbdc0MNrxhidhnWhMTf2PyjYMfVl6PgRTRNBw4ynGJcVD9ACIVOPhg8B9Ho698A5tUjL3dONEe8AsQj7EzuU1jqhKZrhTo8TXEyDM5fX7f6mLl0bz/C2ltMNeulrkxCTHqzfYrKwl15zFnLktnUzugYleEBMJC
 zrXslVVS
 Hsmveb8MbdF8wgBRrp4dr4XTRufL74xwxaQCqbpHDPqPZC6tARQp5kbd5uAvfgiQnz6MEN9rZAiMBEcZ175N8Stn+GAJmI8Sr/zKTeJ9gsxexGnyUt4NqnZ45+05REYRr70WV24d77kRlTYgNl/ZvonEkUKDLydTF4HnCgmf5pnpXkLMvE6iRlAJXS/aZuQucbMJzkuDOu1Rbzpwo+V/g/s2q/bc0yWN8IY8GUl1lUmwLeE7d4VZyDu2rFfCH6TcFGlFC/z1RJrjGFJDl68rMpviJFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:48:31PM +0100, Uladzislau Rezki wrote:
> On Fri, Nov 06, 2026 at 12:21:28PM +0000, Harry Yoo wrote:
> > On Fri, Nov 06, 2026 at 10:35:13AM +0100, Uladzislau Rezki wrote:
> > > On Wed, Oct 28, 2026 at 09:46:47PM +0800, Zhan Xusheng wrote:
> > > > From: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > > 
> > > > run_page_cache_worker() runs under krcp->lock, from kvfree_call_rcu()
> > > > callers that may hold more, such as set_cpus_allowed_force() under
> > > > pi_lock, so it kicks the refill work from an hrtimer.  Under memory
> > > > pressure it instead queues the work with a delay of
> > > > rcutree.rcu_delay_page_cache_fill_msec, which may be 0, and a zero delay
> > > > queues it at once, taking pool->lock under krcp->lock.
> > > > 
> > > > With the delay set to 0, calling kvfree_rcu() on vmalloc memory under
> > > > pi_lock after a drop_caches makes lockdep report:
> > > > 
> > > >   Chain exists of:
> > > >     &pool->lock --> &p->pi_lock --> krc.lock
> > > > 
> > > > Use the hrtimer when the delay is 0.
> > > > 
> > > > Fixes: d0bfa8b3c411 ("kvfree_rcu: Release a page cache under memory pressure")
> > > > Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
> > > > ---
> > > >  mm/slab_common.c | 8 +++++++-
> > > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/mm/slab_common.c b/mm/slab_common.c
> > > > index 3729aa7a6156..ef5ff0a20249 100644
> > > > --- a/mm/slab_common.c
> > > > +++ b/mm/slab_common.c
> > > > @@ -1987,7 +1987,13 @@ run_page_cache_worker(struct kfree_rcu_cpu *krcp)
> > > >  
> > > >  	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING &&
> > > >  			!atomic_xchg(&krcp->work_in_progress, 1)) {
> > > > -		if (atomic_read(&krcp->backoff_page_cache_fill)) {
> > > > +		/*
> > > > +		 * A zero delay would queue the work right here, under
> > > > +		 * krcp->lock and possibly the caller's pi_lock, so let the
> > > > +		 * hrtimer do it.
> > > > +		 */
> > > > +		if (atomic_read(&krcp->backoff_page_cache_fill) &&
> > > > +		    rcu_delay_page_cache_fill_msec) {
> > > >  			queue_delayed_work(rcu_reclaim_wq,
> > > >  				&krcp->page_cache_work,
> > > >  					msecs_to_jiffies(rcu_delay_page_cache_fill_msec));
> > > > -- 
> > > > 2.43.0
> > > > 
> > > > 
> > > Can we just clamp this to 1 - 100 seconds interval?
> > 
> > You mean clamp to [1:100,000] milliseconds interval?
> > 
> Yes. It is now in milliseconds.

Thanks for clarifying.

> So starting with 1 - means that it can be configured at least from 1 msec
> whereas 0 is forbidden. Also we can drop the extra "if condition" proposed
> in the patch as it never can be zero.

But can we explain why forbiding 0 msec can be justified (when there's
an alternative approach to fix it?)

-- 
Cheers,
Harry / Hyeonggon

