Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC1CC55A79
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 11:07:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE6A6B0088; Fri, 20 Feb 2026 06:07:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C3B6B0089; Fri, 20 Feb 2026 06:07:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 649DF6B008A; Fri, 20 Feb 2026 06:07:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA2A6B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 06:07:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E11241BD0E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:07:52 +0000 (UTC)
X-FDA: 84464559984.11.3A75B84
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id A616A1C0009
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:07:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KG1fILvH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S5nqOlUo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mX6Zn0tY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pv0E1s3J;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771585671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLv+hA5hd7MVtuLJRJZBuqjxVwO8h8t75XfQY9oDWAo=;
	b=6+qyHG8NYaPT6TSq+9i503f0m+xFeAZRzQxwI4sCsCAUY9wGylFIfP99otBHnF7TYFTrKq
	ag5lmndekFY5qgDsuaKGQFqi6ZScHaeqs588Y2LPy7m+zWqvZkJP5tV2v/DKDuVwfy89Ir
	wWe35PEwlcQO8IMkmUy3ZfdthESJts0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771585671; a=rsa-sha256;
	cv=none;
	b=fTvCI3+CuXY36YANPBS45+jBGGzs8Gq2bVTdAaBqdQX51GiIKK9AIphoEKUs1HEPSedp1Q
	6i6IktdjuMFCh6NSSxihLydW83RlRNsBj8MGb7E6afzlAjvdggNkQg4hW6p2qL/3w89bYf
	L/R+UwCI4P8IDM1ZTHsIppPcdXmbDUk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=KG1fILvH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S5nqOlUo;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mX6Zn0tY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=pv0E1s3J;
	spf=pass (imf21.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B1ECF3E6D8;
	Fri, 20 Feb 2026 11:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771585669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLv+hA5hd7MVtuLJRJZBuqjxVwO8h8t75XfQY9oDWAo=;
	b=KG1fILvHZvhZuKFnwQga7mSrv7B5/ivr5bdAke6Hh049E9a81GFjDaw4SPBKqpsfJp4+Ze
	fd6EMaeBlh/rjFyZoOOOt9LksTeVQKSMN8ADGspachfdZp2K8OEQAMwP15fao/XXeTcD9b
	NdYKQZ44NdgV/jkVqO8ziJqaBhpp5yQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771585669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLv+hA5hd7MVtuLJRJZBuqjxVwO8h8t75XfQY9oDWAo=;
	b=S5nqOlUoY59dooEbrnRQXHpR+eQcDHuF7gej0JWBPdJxI4dbEQqWFsFF3xzvQgNvmWnEWh
	9N2sjew5O/vpWyAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1771585668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLv+hA5hd7MVtuLJRJZBuqjxVwO8h8t75XfQY9oDWAo=;
	b=mX6Zn0tYmj5iBTFHvzo0OzGHKBPS/iRUbzlfiDY4dy6bY19c2wyJbX+/ZwEafzRIbf9ZAc
	UC/ZiG6GiclDyV8bK7QsNHBv+qur+qPVbx06IdSTn1/KWflI3nyPJhvlUwCSOOVf34699u
	PjZtIVinbzA4Rg8ZL1CCg6LWBth32GY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1771585668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLv+hA5hd7MVtuLJRJZBuqjxVwO8h8t75XfQY9oDWAo=;
	b=pv0E1s3Jd5NzINhqD7MZPs8hO4hfhXVGbuvqilxIeepAEbK6GeG5Dp9W0vVJ9QhpWbhIBM
	ENRuA6MTmsbYEjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 250843EA65;
	Fri, 20 Feb 2026 11:07:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jaKzBYNAmGmERQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 20 Feb 2026 11:07:47 +0000
Date: Fri, 20 Feb 2026 11:07:45 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, rostedt@goodmis.org, joel@joelfernandes.org, 
	kernel-team@android.com, android-mm@google.com, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Minchan Kim <minchan@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jann Horn <jannh@google.com>, Martin Liu <liumartin@google.com>, 
	David Rientjes <rientjes@google.com>, Zi Yan <ziy@nvidia.com>, 
	Wander Lairson Costa <wander@redhat.com>, Petr Mladek <pmladek@suse.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/tracing: rss_stat: Ensure curr is false from kthread
 context
Message-ID: <6wljnbdh2tvi5egjd462hel7zkxvxedqgeqbjsdpoibc5n2j43@fsjneenogr3y>
References: <20260219233708.1971199-1-kaleshsingh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219233708.1971199-1-kaleshsingh@google.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: 6c6imijrh5hedmssy5ik93hazgs5g14u
X-Rspamd-Queue-Id: A616A1C0009
X-Rspam-User: 
X-HE-Tag: 1771585670-696333
X-HE-Meta: U2FsdGVkX1/yzw2NdM0fXwk5SnXofBCw/F/pbyJhjh3V3rDfKvZ1CgruEE7CvBh766mWd1YmcroTW4T3UcHBHJBpUy2JD/UfxalTuG5wLoTz9QXJZOnmluO5aoxZ2CDoD28MAnSumJdexG6XZWJe1DX/qxTDhJZ/nPWZS/RGebGEMJ9kBDPhpwIlLDca+6j6KRuHcld2o2qTlrVLjw7GGPbuKhLFbNKBTUlaN/AOhHTXRRcegLFR2GghOS8ZHq4gMQhhKcRXL0Y91aMR0cIFgrShaMEMILE1ce47Z1gKtN7eT+tq9bSY+tOetCdjZ3BY07lD3lkGJHQwm0NpeWhopCkwZZR18ue/3CQzYLaHqFlGe9uKcyqjInkI3FkNHMFZvva1FBf4c288oygqnfnpHxY6fg9jXQZOT0lsJFE/K+4lbhLDDiTjfh1YMhpp2aaBqzsHVuSJzyMFuoI9nkWpQmFMNDpkS7LTLS0+pd3lWE9mnDIRQCC3b7YvPIUkr998AppE3Zr6biST9O4jZk2YGLGn0Q5aY68rNA2UugiP2MsWqRz40dgQ6vb4vd7432wqopLtYHBqElkaS/x+tvzXGS0LpN4mA3eeOJmsEVoaKiF3qk6wbAaj5mWrZQCS/2HAh4ORIHbIosA+9DUqSe9V1iRUhbt3Yio17IOsaLnb67uGkkf4N9OpO6Krc3B4Q7iYFrGCTpUvFdI6GCpLYpvxuNdR2nLfn4JyDCiuPiQ4p3SozMyMssvyNdc5R2dD10cKw6cg9pGE2ylhPzio1JJujtbB7MohRRUaCq37O7M8BV+X+BMPOQdSNiR+x+rEWI+17jo000O6YuGi+gqWK3pD4TUavynz93dzRiQiqD+qOSFVElKgY9OavEfHrKwhCAr5lKjgr+fsYwRcqeknLE1JcVgicbfd+0RXRAdYd2CSKT2xRqSAO1zaC0tCJWXPOenZkLZ+0ggPRj5KTzq1Tg1
 aI2Rijrm
 PjzS1lSU7cmJlD/nWRDSP7GRPlptbl3FtiZGY2CzVT/8l4DkKIkjoaRe+i9EDQgsHMjjxm0K+zSC+3fe0voXMZhE0q5fSa9tXjpWoaiqT3cuMVEMrV+gz8mdSs3mYNqJVZTbOn9gMXp3r0IOGv41PORVCY8zTRDfXyPjh+j39UGg5LhXFyNZC8iTylvU7h209MPz8rTcWD/9zly/e2LtSqLwKLYgQ+AJuvK09YDUWJCIz6r7f3NVJjuF0gNA6xsNyHBuJySMHdUEnuy8Q52q9tRs7eMwcEFvlugAZw1fjr7MsiJmj1uUSaJB9iPno6IIeagy6PslbYy5TqbcIYXj4yeuRlbMCH3TX0dGTscjQ6kuhZP92QANX3sxwVFfq6p4kPoYWajDMcCq9Wczcv1eSCI8czsFdkUDusXUDF2IsLuKuhuhaUXhJLqNgW4zzpTGy/+3gOcfqtFN0n9CS51O8z+Kod0owLbbnjNb+kSI7/kmuU6kxNQl7ohJIP4Fg1rzpzTCUhLC8Igomr4sPtIbhQYU9k0JpVdlLFBPHlqnBNin05IaBm1DOxzDHleeCs/hLR9VFbWNjSfGRfkYkOPOmclUsU9TI9nFVKANpBTDfpx/ektx/MZNLINOJK8PqP+UbkQL3qen4JnR30aP/KT/DfE+tYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:36:56PM -0800, Kalesh Singh wrote:
> The rss_stat trace event allows userspace tools, like Perfetto [1],
> to inspect per-process RSS metric changes over time.
> 
> The curr field was introduced to rss_stat in commit e4dcad204d3a
> ("rss_stat: add support to detect RSS updates of external mm").
> It's intent is to  indicate whether the RSS update is for the
> mm_struct of the current execution context; and is set to false
> when operating on a remote mm_struct (e.g., via kswapd or a
> direct reclaimer).
> 
> However, an issue arises when a kernel thread temporarily adopts
> a user process's mm_struct. Kernel threads do not have their own
> mm_struct and normally have current->mm set to NULL. To operate
> on user memory, they can "borrow" a memory context using
> kthread_use_mm(), which sets current->mm to the user process's mm.
> 
> This can be observed, for example, in the USB Function Filesystem
> (FFS) driver. The ffs_user_copy_worker() handles AIO completions
> and uses kthread_use_mm() to copy data to a user-space buffer.
> If a page fault occurs during this copy, the fault handler executes
> in the kthread's context.
> 
> At this point, current is the kthread, but current->mm points to the
> user process's mm. Since the rss_stat event (from the page fault)
> is for that same mm, the condition current->mm == mm becomes true,
> causing curr to be incorrectly set to true when the trace event is
> emitted.
> 
> This is misleading because it suggests the mm belongs to the kthread,
> confusing userspace tools that track per-process RSS changes and
> corrupting their mm_id-to-process association.
> 
> Fix this by ensuring curr is always false when the trace event is
> emitted from a kthread context by checking for the PF_KTHREAD flag.
> 
> [1] https://perfetto.dev/
> 
> Fixes: e4dcad204d3a ("rss_stat: add support to detect RSS updates of external mm")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "David Hildenbrand (Arm)" <david@kernel.org>
> Cc: Joel Fernandes <joel@joelfernandes.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Looks cromulent, thanks :)

-- 
Pedro

