Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AC85CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 16:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C7E9001A9; Thu, 14 Aug 2025 12:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3F6900172; Thu, 14 Aug 2025 12:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD33C9001A9; Thu, 14 Aug 2025 12:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C97A900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 12:43:17 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 42B1982FD1
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:43:17 +0000 (UTC)
X-FDA: 83775933234.19.FEA997B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97F65A0017
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:43:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AapH0SWr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of djwong@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755189795; a=rsa-sha256;
	cv=none;
	b=kGhls55SY2BtIxJ3KXsH6QYg74DbtHyUCdBGmaitS6DXwZpLHx8hkQ8Im8/fFWfIp3q+RA
	0RaIKUOCO4QmVhGTWgMe1LM2Ndt3oejXD+ZioMvVB1gPhPMKV11Zh5za4ZZNX/y8XX0QLF
	biehoEjqoZsro3F/Ev+U64ClDzUEMeY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AapH0SWr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of djwong@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755189795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/c4b2/laLm554xHhGOVQJhLHj+gQ4nRTMLUoIaMzFE=;
	b=6tTuXjtbRTbjDNfSj2j9+lZ0sxG6pwJeDUT1TRdRyUMJPchQ2gu3q0hYq/YcS0PjAn4fTu
	0DPQU8bF/A9omVYsalM3tTz/56egmOW6b3ttnC5MZYvJDwlHvL84NTiVVJglkr1vFcHGEO
	oPZ/WzhO8AArZ9BfMwvr/2tD5eSZ5O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id EAAC2A570EB;
	Thu, 14 Aug 2025 16:43:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DA1C4CEED;
	Thu, 14 Aug 2025 16:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755189794;
	bh=cVYpcTsjTeAvvi4JNeURuCo2newojqCTC+yq6X3j8tM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AapH0SWr4OT/uvhWFMhjowdkBCTUfuG1U7McDeYP/IGs4ijBpVPTJHeOWUyOs6nXN
	 Ts51KwUR92rHiLap2ctiKRBYxKJd+7zVtRYFbLMhU7p4aLJ54Y3yoOlyZi2YAZMhhs
	 SN9TYtk5vvcJDTOo9ohMjZnG7u4yEll6W8AxE0TWGfcgb7tU6mUmvggfLQTu4FW6yl
	 vUSUwuTxB4WqjNQuoRo/xHMZ9NNGdmCBYoaK+Ggi5zgUoDGJN6iQFjk9OCRvCLGmwp
	 w1qHXAMwtrGK/zpDUXco9/wXAoOqy61Xf/lxa/2/zFoCu743Zkru3aDUAhthHb4gs5
	 XtdDP6T9DVD6A==
Date: Thu, 14 Aug 2025 09:43:13 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Zihuan Zhang <zhangzihuan@kylinos.cn>
Cc: Michal Hocko <mhocko@suse.com>, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>, pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>, xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>, linux-pm@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: Re: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to
 address process dependency issues
Message-ID: <20250814164313.GO7942@frogsfrogsfrogs>
References: <aJSpTpB9_jijiO6m@tiehlicka>
 <4c46250f-eb0f-4e12-8951-89431c195b46@kylinos.cn>
 <aJWglTo1xpXXEqEM@tiehlicka>
 <ba9c23c4-cd95-4dba-9359-61565195d7be@kylinos.cn>
 <aJW8NLPxGOOkyCfB@tiehlicka>
 <09df0911-9421-40af-8296-de1383be1c58@kylinos.cn>
 <aJnM32xKq0FOWBzw@tiehlicka>
 <d86a9883-9d2e-4bb2-a93d-0d95b4a60e5f@kylinos.cn>
 <20250812172655.GF7938@frogsfrogsfrogs>
 <8c61ab95-9caa-4b57-adfd-31f941f0264d@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c61ab95-9caa-4b57-adfd-31f941f0264d@kylinos.cn>
X-Rspamd-Queue-Id: 97F65A0017
X-Stat-Signature: h9o6zj61b4k7kerpuzkns7be4rjckasc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755189795-481031
X-HE-Meta: U2FsdGVkX19bWegtdd2IJRoumZl9egVkHMplRM+J7jYxuaHcvDFXFlKaEBjtqkmJdP4laTPU5T9vkgy7GnG4puPvVAPOsgmiROSZFaXsIupcBV/hHgtQ0gtGz+tdDxdaYk2sRMfQBju4yoyQdbVtgicA7YIui1ziHoSsq7l7JSmnuclmWSi2qUndwLd5xrxAp8D6HQX6iq63/W5YutAY6E8S0fvX57VSujaFTGsQnXgc6QgaRXHdQudd8qFjTRivx6lWV90bXzAIodVm6+F4HQlFW5uHnq3p83ZkindHMWsZS1rla+ta60GjY9tkVCqvoMdHZgO2N4rKeWDYPl6VL0LVOdueHONl8NZ8WsF8AbKNP1I3UuiCoSA9TxEjRE1rZdn/7a3tClRLXzQ2UhBNxFqOkTOQ1t2FbGSQFRzjWbCDPAnpz7ugOuLb2PENdx0TUcukErakVaVBbTVPOtFSatHRMC0nyzjD2uIMam3zHzqZKKxHriKSjuA2IpP3wq4D+yX1+/bL793KrOKkJpMIJmEawLmdPYLmsMJ6pDhNOi2qZKlulZybxsiFd+wHrMy1GcbqV0iDw8y6xLrcJGbk9+LHE4tT4lnwExggbOPX3393hpjLwcoEWMCJOHfgfx/sSXVUVhYbSKd3MymWZdki5C68RyqYfq9p0Nz7MEa94tBEvqJs8O2vrb3Ix0j6iX07m59ASJrm+MV43/jqkJVVexAjlaSkPrX13uEtH6SAd82awbT/NDWxoPPYpg5vFjLL0xKk3u3wajAbs4BpFRDTbv342cxwRHMhUj/QcvDE2CRTtpPuk/W690AYwBdRSn4L6PtKs3Y8V0TMfASYNGi7m3VfBIPP0TVarvwhpoKltusUNMF6Q86yg/i9gbP985I3ibNfiQmeoMdj+uJjfXvm5IkaHk5TYX5NFsveJVhyCOweBX5Eqt40fcqjrLzYlk0LhhjdjF32SDKWUW/Vk4E
 05d0XtWs
 0IuelOk4AwLPq2tfySMzTsGbtXaJlWkpecQvhEWlbFyFoqLJbnp86Q0Gd5nq/FlS2018ReNWnyOwAtgvR+f/ca2380PuumkLl3Ws8TDY7lQiKMBWsc8bANrCyir0jxcd5YZQji8ESHz5t8hdPMB9ut2dON4CwRKFXtNz0E4ceT1ZcNQAaiBvvTILwbLW942QWGGRdHlYGMBgSzW0Vke1IYge46tIvvLR9Wqu4x/SUOyatxs/KMnATUqzLRxb+GzwU5LzEshbkx3GMAj+JyzK4asie76EekmTWFJrRXcT0PncrpuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 01:48:37PM +0800, Zihuan Zhang wrote:
> Hi,
> 
> 在 2025/8/13 01:26, Darrick J. Wong 写道:
> > On Tue, Aug 12, 2025 at 01:57:49PM +0800, Zihuan Zhang wrote:
> > > Hi all,
> > > 
> > > We encountered an issue where the number of freeze retries increased due to
> > > processes stuck in D state. The logs point to jbd2-related activity.
> > > 
> > > log1:
> > > 
> > > 6616.650482] task:ThreadPoolForeg state:D stack:0     pid:262026
> > > tgid:4065  ppid:2490   task_flags:0x400040 flags:0x00004004
> > > [ 6616.650485] Call Trace:
> > > [ 6616.650486]  <TASK>
> > > [ 6616.650489]  __schedule+0x532/0xea0
> > > [ 6616.650494]  schedule+0x27/0x80
> > > [ 6616.650496]  jbd2_log_wait_commit+0xa6/0x120
> > > [ 6616.650499]  ? __pfx_autoremove_wake_function+0x10/0x10
> > > [ 6616.650502]  ext4_sync_file+0x1ba/0x380
> > > [ 6616.650505]  do_fsync+0x3b/0x80
> > > 
> > > log2:
> > > 
> > > [  631.206315] jdb2_log_wait_log_commit  completed (elapsed 0.002 seconds)
> > > [  631.215325] jdb2_log_wait_log_commit  completed (elapsed 0.001 seconds)
> > > [  631.240704] jdb2_log_wait_log_commit  completed (elapsed 0.386 seconds)
> > > [  631.262167] Filesystems sync: 0.424 seconds
> > > [  631.262821] Freezing user space processes
> > > [  631.263839] freeze round: 1, task to freeze: 852
> > > [  631.265128] freeze round: 2, task to freeze: 2
> > > [  631.267039] freeze round: 3, task to freeze: 2
> > > [  631.271176] freeze round: 4, task to freeze: 2
> > > [  631.279160] freeze round: 5, task to freeze: 2
> > > [  631.287152] freeze round: 6, task to freeze: 2
> > > [  631.295346] freeze round: 7, task to freeze: 2
> > > [  631.301747] freeze round: 8, task to freeze: 2
> > > [  631.309346] freeze round: 9, task to freeze: 2
> > > [  631.317353] freeze round: 10, task to freeze: 2
> > > [  631.325348] freeze round: 11, task to freeze: 2
> > > [  631.333353] freeze round: 12, task to freeze: 2
> > > [  631.341358] freeze round: 13, task to freeze: 2
> > > [  631.349357] freeze round: 14, task to freeze: 2
> > > [  631.357363] freeze round: 15, task to freeze: 2
> > > [  631.365361] freeze round: 16, task to freeze: 2
> > > [  631.373379] freeze round: 17, task to freeze: 2
> > > [  631.381366] freeze round: 18, task to freeze: 2
> > > [  631.389365] freeze round: 19, task to freeze: 2
> > > [  631.397371] freeze round: 20, task to freeze: 2
> > > [  631.405373] freeze round: 21, task to freeze: 2
> > > [  631.413373] freeze round: 22, task to freeze: 2
> > > [  631.421392] freeze round: 23, task to freeze: 1
> > > [  631.429948] freeze round: 24, task to freeze: 1
> > > [  631.438295] freeze round: 25, task to freeze: 1
> > > [  631.444546] jdb2_log_wait_log_commit  completed (elapsed 0.249 seconds)
> > > [  631.446387] freeze round: 26, task to freeze: 0
> > > [  631.446390] Freezing user space processes completed (elapsed 0.183
> > > seconds)
> > > [  631.446392] OOM killer disabled.
> > > [  631.446393] Freezing remaining freezable tasks
> > > [  631.446656] freeze round: 1, task to freeze: 4
> > > [  631.447976] freeze round: 2, task to freeze: 0
> > > [  631.447978] Freezing remaining freezable tasks completed (elapsed 0.001
> > > seconds)
> > > [  631.447980] PM: suspend debug: Waiting for 1 second(s).
> > > [  632.450858] OOM killer enabled.
> > > [  632.450859] Restarting tasks: Starting
> > > [  632.453140] Restarting tasks: Done
> > > [  632.453173] random: crng reseeded on system resumption
> > > [  632.453370] PM: suspend exit
> > > [  632.462799] jdb2_log_wait_log_commit  completed (elapsed 0.000 seconds)
> > > [  632.466114] jdb2_log_wait_log_commit  completed (elapsed 0.001 seconds)
> > > 
> > > This is the reason:
> > > 
> > > [  631.444546] jdb2_log_wait_log_commit  completed (elapsed 0.249 seconds)
> > > 
> > > 
> > > During freezing, user processes executing jbd2_log_wait_commit enter D state
> > > because this function calls wait_event and can take tens of milliseconds to
> > > complete. This long execution time, coupled with possible competition with
> > > the freezer, causes repeated freeze retries.
> > > 
> > > While we understand that jbd2 is a freezable kernel thread, we would like to
> > > know if there is a way to freeze it earlier or freeze some critical
> > > processes proactively to reduce this contention.
> > Freeze the filesystem before you start freezing kthreads?  That should
> > quiesce the jbd2 workers and pause anyone trying to write to the fs.
> Indeed, freezing the filesystem can work.
> 
> However, this approach is quite expensive: it increases the total suspend
> time by about 3 to 4 seconds. Because of this overhead, we are exploring
> alternative solutions with lower cost.

Indeed it does, because now XFS and friends will actually shut down
their background workers and flush all the dirty data and metadata to
disk.  On the other hand, if the system crashes while suspended, there's
a lot less recovery work to be done.

Granted the kernel (or userspace) will usually sync() before suspending
so that's not been a huge problem in production afaict.

> We have tested it:
> 
> https://lore.kernel.org/all/09df0911-9421-40af-8296-de1383be1c58@kylinos.cn/
> 
> > Maybe the missing piece here is the device model not knowing how to call
> > bdev_freeze prior to a suspend?
> Currently, suspend flow seem to does not invoke bdev_freeze(). Do you have
> any plans or insights on improving or integrating this functionality more
> smoothly into the device model and suspend sequence?
> > That said, I think that doesn't 100% work for XFS because it has
> > kworkers for metadata buffer read completions, and freezes don't affect
> > read operations...
> 
> Does read activity also cause processes to enter D (uninterruptible sleep)
> state?

Usually.

> From what I understand, it’s usually writes or synchronous operations that
> do, but I’m curious if reads can also lead to D state under certain
> conditions.

Anything that sets the task state to uninterruptible.

--D

> > (just my clueless 2c)
> > 
> > --D
> > 
> > > Thanks for your input and suggestions.
> > > 
> > > 在 2025/8/11 18:58, Michal Hocko 写道:
> > > > On Mon 11-08-25 17:13:43, Zihuan Zhang wrote:
> > > > > 在 2025/8/8 16:58, Michal Hocko 写道:
> > > > [...]
> > > > > > Also the interface seems to be really coarse grained and it can easily
> > > > > > turn out insufficient for other usecases while it is not entirely clear
> > > > > > to me how this could be extended for those.
> > > > >    We recognize that the current interface is relatively coarse-grained and
> > > > > may not be sufficient for all scenarios. The present implementation is a
> > > > > basic version.
> > > > > 
> > > > > Our plan is to introduce a classification-based mechanism that assigns
> > > > > different freeze priorities according to process categories. For example,
> > > > > filesystem and graphics-related processes will be given higher default
> > > > > freeze priority, as they are critical in the freezing workflow. This
> > > > > classification approach helps target important processes more precisely.
> > > > > 
> > > > > However, this requires further testing and refinement before full
> > > > > deployment. We believe this incremental, category-based design will make the
> > > > > mechanism more effective and adaptable over time while keeping it
> > > > > manageable.
> > > > Unless there is a clear path for a more extendable interface then
> > > > introducing this one is a no-go. We do not want to grow different ways
> > > > to establish freezing policies.
> > > > 
> > > > But much more fundamentally. So far I haven't really seen any argument
> > > > why different priorities help with the underlying problem other than the
> > > > timing might be slightly different if you change the order of freezing.
> > > > This to me sounds like the proposed scheme mostly works around the
> > > > problem you are seeing and as such is not a really good candidate to be
> > > > merged as a long term solution. Not to mention with a user API that
> > > > needs to be maintained for ever.
> > > > 
> > > > So NAK from me on the interface.
> > > > 
> > > Thanks for the feedback. I understand your concern that changing the freezer
> > > priority order looks like working around the symptom rather than solving the
> > > root cause.
> > > 
> > > Since the last discussion, we have analyzed the D-state processes further
> > > and identified that the long wait time is caused by jbd2_log_wait_commit.
> > > This wait happens because user tasks call into this function during
> > > fsync/fdatasync and it can take tens of milliseconds to complete. When this
> > > coincides with the freezer operation, the tasks are stuck in D state and
> > > retried multiple times, increasing the total freeze time.
> > > 
> > > Although we know that jbd2 is a freezable kernel thread, we are exploring
> > > whether freezing it earlier — or freezing certain key processes first —
> > > could reduce this contention and improve freeze completion time.
> > > 
> > > 
> > > > > > I believe it would be more useful to find sources of those freezer
> > > > > > blockers and try to address those. Making more blocked tasks
> > > > > > __set_task_frozen compatible sounds like a general improvement in
> > > > > > itself.
> > > > > we have already identified some causes of D-state tasks, many of which are
> > > > > related to the filesystem. On some systems, certain processes frequently
> > > > > execute ext4_sync_file, and under contention this can lead to D-state tasks.
> > > > Please work with maintainers of those subsystems to find proper
> > > > solutions.
> > > We’ve pulled in the jbd2 maintainer to get feedback on whether changing the
> > > freeze ordering for jbd2 is safe or if there’s a better approach to avoid
> > > the repeated retries caused by this wait.
> > > 
> 

