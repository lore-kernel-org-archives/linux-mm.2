Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D11CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 21:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BE088E0006; Fri,  5 Sep 2025 17:50:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D028E0001; Fri,  5 Sep 2025 17:50:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 282EF8E0006; Fri,  5 Sep 2025 17:50:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 159BD8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 17:50:27 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C528CB857E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:50:26 +0000 (UTC)
X-FDA: 83856540852.28.614C977
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1508280006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 21:50:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AsvpR/nI";
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757109025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i+4lbkYAVJItZbl2lUeNDlNahLiQUZCJiaL54ViPkiY=;
	b=xmg6pj1Cd1ET4TB43m+KsO2N1jdlAdtzM+zgYoaSFKhhUMhQXct8eapidt+5EOyTLXJjWB
	p7URuJtC5nt62aaxnsrXGTEQvALtxtDKt8dyttjJUCxhmp67fyOaKNsAc+uRJS6W7DHIlT
	FZo/ZecOHwih3gvESphXPJtfoOljRwY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AsvpR/nI";
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757109025; a=rsa-sha256;
	cv=none;
	b=YsOKw8BdiZX20yCzMO2wgvQqDqsyel+3EnhgyVwOJE3izuN3RVlTatR03qvbwlGxi0nNNS
	3YGfBhluXfBp/fqO3gWnMGhNZD4qQ0GYFIVW3meWjdR4QxGs8Od4s/7RvDqHXPrrwbgo60
	9OSfuizD1g7hLQVGgBi96isAarMlUTM=
Date: Fri, 5 Sep 2025 14:50:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757109022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i+4lbkYAVJItZbl2lUeNDlNahLiQUZCJiaL54ViPkiY=;
	b=AsvpR/nIzurNpoIFa6XwntMf4OD07BIqdrNjj5pHASfxQjM6hDQZxoKF+RNqMmjRn+bwxD
	QavQmwYEnsXt2x7J0YcXG8R67lsjb9n5gKD4blTaP7+Qk9IW5ox/72XJLYPBLhcvy0J3Vq
	6nEtKlfioHa8Yera73WK9RMGQRYsHEE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Peilin Ye <yepeilin@google.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, bpf@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: skip cgroup_file_notify if spinning is not allowed
Message-ID: <6bcjnhdsbyfmlua2x7olz6w3gheejfatnrtn5qu7ls5svegrok@zeatti7whrnq>
References: <20250905201606.66198-1-shakeel.butt@linux.dev>
 <87y0qsa95d.fsf@linux.dev>
 <mai3ndkvqrpkfpblkazbyejvpkizrp7dh22374tpkmepfji32o@3troawzsuvqe>
 <87ecska85y.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ecska85y.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mw594hk44zd1xacmeuutzdaimgskak6h
X-Rspam-User: 
X-Rspamd-Queue-Id: 1508280006
X-Rspamd-Server: rspam05
X-HE-Tag: 1757109024-842483
X-HE-Meta: U2FsdGVkX19MNTprg/9thPxjoEK2FfCLaKxh+mvaI7lq38E4SWqRx2N2YNbg5usoX1db8tuRxBPJCvyOL7nwrvDFyRLK/bkFW/YZ+0zgd3GDLsG0YoQeI21/HWk9yGFnfbAFdFI4geHS+ADsVN/yp4P4sesN9//uP17L7WJDBhC5Vp5aN5JJWRYw9xknMCPWIHBb+7gqJA+oGZpyjVQa2/2OK4LdyE72jFLHZe84ZbAuaLCcok7KMENyZv9H7zm9CtrmC0+5/tBtZyo7sTmvzLlm1e/M2iZtxqrvIxnjxGYhtZH0MFd2suiuZOPl+YAelciYBu0JhCExcY/wImCRxPTWyrPCJNh9pjJdRfSLikErzFlir2PWb4CAFZs7L2IdVnfz13QoLO9qr9KQoDPRZsc7Na2fBkeyn8lnUd0WfkmKYvaia1GVXkKkPBvDY14OppPo913YTpCNttHx4f3naAHa9+lnN0oF0uIVblm+VvFphcecUpmY8jFHjSm8FSKXDlYxKuOoBiobUUepDZJZFms/9EeNxF0TIHbgwjCVLgqxb+T78T+mxMOg5LhcuezaY4sjWMq3FiAjtVxkkQlVLzhr+EhTeAn5fks4B14hbnjXGOqpCo/3+XCM9sxCjHu1Gx916+lOvc7MDCr8Gu/QXF4RwVFf9Uj1v/Ln1EDc/nw3giQ4G3UpRKDCWquSjmrz9HGt/5eK5tS5sKJf07Mxabcbm0razpBuTLeKlMcDeOOjn/LB94V8RQn0/iUK7qt3iMfmmt8vROohOU0k4Et7AMoONajdEmOvtJSVF9Y+gEiriW3eZGPhf3BZnHdJKurVlMSSU7hEUiKe3Rvh2KSyqrPqVwwWaBmdCX859+AphlfN4FzyBHzk8EjWL+Bj0aNw7j6QXo4gIyHRHa6A8BJVNCD9N1kQ4PcqmvNaaY5JpD93Ml6ni2r50RVzTDOMRwdmnHDb+n8xS6y+Rc6/9XG
 D2IlIK5n
 9kq12vXgitAgsQsmcm8UmtlFC9HxHdk0Cd/pdp993DKVq1UC74GJV/Jlpmw+/NobCrLRgL1qRtzmux9N9Vd2Ae+50tYZHuO+KFQYhFlCdaU2/rY6Kth4kqXlPwaPv9zncATO5oKsIjyrOcLzFsY+h62gHRmqLBYqhUN4E/Bw6/cHvzNFv/OIz9t6M8QG5qHzqHzL5AHO40sxs6iKvKIcOyfmti9sGCoZAiAfICQrvkFcfBT9Vdo36WSSM44TANRQf6oVd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 02:42:01PM -0700, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
> > On Fri, Sep 05, 2025 at 02:20:46PM -0700, Roman Gushchin wrote:
> >> Shakeel Butt <shakeel.butt@linux.dev> writes:
> >> 
> >> > Generally memcg charging is allowed from all the contexts including NMI
> >> > where even spinning on spinlock can cause locking issues. However one
> >> > call chain was missed during the addition of memcg charging from any
> >> > context support. That is try_charge_memcg() -> memcg_memory_event() ->
> >> > cgroup_file_notify().
> >> >
> >> > The possible function call tree under cgroup_file_notify() can acquire
> >> > many different spin locks in spinning mode. Some of them are
> >> > cgroup_file_kn_lock, kernfs_notify_lock, pool_workqeue's lock. So, let's
> >> > just skip cgroup_file_notify() from memcg charging if the context does
> >> > not allow spinning.
> >> 
> >> Hmm, what about OOM events? Losing something like MEMCG_LOW doesn't look
> >> like a bit deal, but OOM events can be way more important.
> >> 
> >> Should we instead preserve the event (e.g. as a pending_event_mask) and
> >> raise it on the next occasion / from a different context?
> >>
> >
> > Thanks for the review. For now only MAX can happen in non-spinning
> > context. All others only happen in process context. Maybe with BPF OOM,
> > OOM might be possible in a different context (is that what you are
> > thinking?). I think we can add the complexity of preserving the event
> > when the actual need arise.
> 
> No, I haven't thought about any particular use case, just a bit
> worried about silently dropping some events. It might be not an issue
> now, but might be easy to miss a moment when it becomes a problem.
> 

Only the notification can be dropped and not the event (i.e. we are
still incrementing the counters). Also for MAX only but I got your
point.

> So in my opinion using some delayed delivery mechanism is better
> than just dropping these events.

Let me see how doing this irq_work looks like and will update here.

