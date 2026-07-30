Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48532C55164
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:57:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056336B008A; Thu, 30 Jul 2026 10:57:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005D06B008C; Thu, 30 Jul 2026 10:57:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5E426B0092; Thu, 30 Jul 2026 10:57:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C6A9D6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:57:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6575F1A01BC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:57:25 +0000 (UTC)
X-FDA: 85045746450.22.B38FB7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9B82E140011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:57:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsQV55i0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785423443;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WkKl3ci3MCuftUDDJxohW0fa4aHGCJW3D+bUpPt0I40=;
	b=4qEsjMQ7pcLAW8VqvbZ8BfNQ1S7SSL6DqljO6YUjFCNljWtrgLBNqbs5ze7xktaJ5HXYKi
	ZpZ4PQVIVwzCG77BgiIiE+A+p4SvzavZnKUUq0VUeN5CYENobuZPNIkh2YrPi/ehRhlZjt
	tzddH9oFU61ka8jyhifJxiUoiDxJBAs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NsQV55i0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of "SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=sCS2=FY=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785423443;
	b=0ipm0FosiIFNtrX6NqwGZeszKK4JMTukeh4k94HC6LDUI11m9SRWUOy3N3KmsiCi+9F6Lx
	sYV8Ebdtti1FAzdxmbBf6muIe4H7KyL5bC9KlLARMYC/EbZdaEetJlh9ZZr9dxapH7OOXs
	NeZ+/ZAv+Z2ejlC46LIaEtqmNsh2MLA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8CEB40AAA;
	Thu, 30 Jul 2026 14:57:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABCB1F000E9;
	Thu, 30 Jul 2026 14:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785423442;
	bh=WkKl3ci3MCuftUDDJxohW0fa4aHGCJW3D+bUpPt0I40=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=NsQV55i0BK3zViDbsYCSN5J+aJlNoLrty9bwn3E4zmMZY8zc30aqqmyB8ysg2yGiL
	 agXR0w0gi3Kc0fDAzHnRgO+CKgHHhcIDcUVMDSB3MsYOtYqGE3yBOnzIaJieAWVuC/
	 P6YrxRnLQiC4BY50DosJjF63bbIl9nQsc6E49JwDic5fyFqoeep5sWz0zLSNDEFCDT
	 tWabWzikFVGfqFucHHTUE1o1mQmM1Gy0s7JKeQdtXANPpBfasR24mydA5y+3IRWbLg
	 mpFS8F0mzP8PmuJIFqFh6L9l060CLLHLyKh1i7iwXY0RpQyffnr1pq2L8QQ9hpOxaX
	 QVg/U66UTMS7A==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id 6D043CE0B67; Thu, 30 Jul 2026 07:57:22 -0700 (PDT)
Date: Thu, 30 Jul 2026 07:57:22 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: rostedt@goodmis.org, pjaroszynski@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>, puranjay@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org, kernel-team@meta.com, dcostantino@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during
 the scan
Message-ID: <743bf971-b4aa-416b-b72b-88b538be727a@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
 <20260720153917.2e428e489cd0873ac6d4e6da@linux-foundation.org>
 <5b83b0a0-708a-458a-bdbd-41c6d4610349@paulmck-laptop>
 <amCT9QEgJRsLIb_y@gmail.com>
 <ffa5d8d2-1157-4a30-995c-ddae3566e3a4@paulmck-laptop>
 <amM1xUOhcpGpqIpe@gmail.com>
 <39c90e82-f785-4b47-9571-dd4b1339d685@paulmck-laptop>
 <amdWVTs0WKOxguxP@gmail.com>
 <amtZNwxZ3gpOsPER@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amtZNwxZ3gpOsPER@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9B82E140011
X-Rspam-User: 
X-Stat-Signature: d7co3qecw9tgyzhqoyrwbi73mk9jdyit
X-HE-Tag: 1785423443-630676
X-HE-Meta: U2FsdGVkX18n/a6eZJDnEJxUda7pad46woWZMdFL0J6F+PZbAzW+4IZkVMbDfPlkjGaOYxX0iTQNDao6oeJDtXVgLDb67S4NRFngCdBTOydcwwkMkCG+ojO6FwKzODDhnycVW5TELIvbOtfvQ/TNRTBDmnDTG1e8aTOWMP2mG9z3TPudxUTw/Jb7UfhpZhzVoIHEVOmwpOk3epZokZG77Vc3pyDHPBP6lN7/+aPYGflZkt7MmwwS6sVKYEvRd7234oQZgybjA32B/ppr73iZwubQwVzPoOIkRCyfiVci73ouVzdtgk7Dt5NfDC/iOZ2TCWE/xyRZKxzWeg6nrecpE2fIBfho4fRaKAa+YyIzc173kM7WoTiMiZNl4bY+20HsR7jms0O8L0lzK5yIh0XFmTJ7o+bJL6HNR9Q7HBv77JHGdMu0qE4OVfWuYvM0e/xqDlMaKZfLKTBxeXl5drWWb8vfUQkAIc3cGZBT8rTaPiWZB4WQgMKu8PhO2DrUT202mkCkSJEFVsk+Ke1B96Amnr0rLt9+NB6VB0CD2R2lj+7ztpwhz8DEEfYHWV82XPu/Lp8VTr019RDdEWg1x5IRY3fBU86eJFStqayjHcr5TTgxIVmPpaayHfgYo7p4erWxsR8SPSYIQ8l45Uw+JzARNK/VTEPBogunft0qVgWLCIPmFcZjaOOOVt21ngtQehkZbmhHS0vMsB1i8yJsSpvundOTNE9+kuwY9wtSJ8DuItcUoilX6sZJDfSv043I0/sWh0cZCUp35tdAkxhMm1a4eyTr0WoVMfgXhlQHw91+TzjgsQAHsAx0HqlFPE+zoxbNci6QO0LMdw7RP0SCyNCnf7FPj6M18JSR7CUHHFfpKKzQ933Gxbt5iBeeY7EEkD2y5qpHgUDPPtcuMcXfY77GpLuk/G4VOBz/fLsXYjbxomQTFVr1fnP028H4Qts13CJUs5f8mHbrTWZBFeJjhrQ
 Ha1dy+Xb
 P5kNi0N9TmnT0aHDUw/Wfu66ctkhRTD6ns3rlmLIoieiICyT0qgJYhfkQWlO3aY66QAqpR5VwHeIMX6DgIwgBx59RS/wobVclVqc5T+mW2nS38j8KlJyEBrNVB3Hgl0B/7jE7MVjRLbJi9pxhub+JpJ1DsQRhn6XI+DDs3U21gPI/cPik7jamlvy1NcKAkf8gT8eHTT4OEpYYR84d1Gm2pI5BGerp3GoRp8qA2R21qyU9RCXOWnUvxUdWtI41DugmQslFeHXjEg5nnpbslap2IDIo/FJM9pLDBF2TT8BKs3khpcyu/cc5eEbzGKcm4QggYFWk4aslt0Faxo2g+e7M/GCuqp+ME8nuqzkM17nJEIEvpiV1vJC4Pe2QyXaK/ot3PhGLkum1kAk5SQM3+FCoNppUn+5NL665MkWLmlZD4DWKTETRxG5DVJXqE3y5kNHNdtGMc2yFf2xh15871rZrgHdrUJYmLhYaG/Mhn8rrwDV8K2wNzonJ5uqNyspTsxsIdtQ1HPyAlpSxwlRqCg+2up/FeeHGaObwCH5uIAX/wosNBQrKR38HtQ/652pyv2kjKH8tw72ktA0t0xtpuB1jqKGn0wac3yamOc+1vgx20Z9Xgmr7Ao7QdOkgrnrteZ0EvNjosHTP2yucHj/wmh3FLqqQvVczepT2iOv7GQqK6raSuvySHWGz7FV/lWggX9IsCzpOfKTRKlir5f13h7WWhx+7wyIBMTlr9B2QvWSvKwR+Nb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:06:44AM -0700, Breno Leitao wrote:
> On Mon, Jul 27, 2026 at 06:04:37AM -0700, Breno Leitao wrote:
> > I found 3 different cases on Meta fleet, where rcu task stalls show up:
> ...
> > 3) Nvidia driver
> >   * stuck in nv_procfs_read_lock_params
> 
> I've investigated this issue. The nvidia driver contains the following
> locking pattern:
> 
>         static inline int nv_down_read_interruptible(struct rw_semaphore *lock)
>         {
>                 while (!down_read_trylock(lock))
>                 {
>                         if (signal_pending(current))
>                         return -EINTR;
>                         cond_resched();
>                 }
>                 return 0;
>         }
> 
> Code at: https://github.com/NVIDIA/open-gpu-kernel-modules/blob/452cec62d827034798072827d3866d1881662b77/kernel-open/common/inc/nv-lock.h#L54
> 
> The lock is never acquired, and cond_resched() provides insufficient
> scheduling relief.
> 
> This triggers a more severe issue with ftrace, which holds ftrace_lock
> across RCU synchronization:
> 
>         mutex_lock(&ftrace_lock);
>                 ftrace_shutdown(struct ftrace_ops *ops, int command) {
>                         synchronize_rcu_tasks_rude();
>                         synchronize_rcu_tasks();
>                 }
>         mutex_unlock(&ftrace_lock);
> 
> Since nv_down_read_interruptible() spins indefinitely, ftrace_lock
> now becomes completely wedged.
> 
> I suppose we want two things:
> 
> 1) change cond_resched() with cond_resched_tasks_rcu_qs()
> 2) Avoiding holding the ftrace lock while calling
>    synchronize_rcu_tasks()? It can take up to 10 minutes on a healthy
>    system to be releasd, right?

I do very much like both of those options.  ;-)

If #2 is impossible, would it make sense to have a mutex_lock_idle() or
similar in order to sanctify the lock synchronize_rcu_tasks() latencies?

							Thanx, Paul

