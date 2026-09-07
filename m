Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9054C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96C3D6B008A; Mon,  7 Sep 2026 17:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944A96B008C; Mon,  7 Sep 2026 17:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D8B6B0092; Mon,  7 Sep 2026 17:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1AB6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:55:16 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D87C8802A5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:55:15 +0000 (UTC)
X-FDA: 85188322590.26.2851C31
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id A00F6100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:55:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJdlAp9p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788818113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5vbt3dDTcq0wdPHap0JtL9B1dVtnkBH7soBmqKWLIw=;
	b=fnqJ9VLxDIiGcCaMLWctWFVhkZG7ArvOxBDKDWiDAodA4na8rxoAv+EgQwVMPla5U1IIkX
	IzSB+FB7J/FvVA7BQECuy3qXNEnj4S6eIaidyntmf+/ejix0ZNJgzPWy9s4biPCATq9Coh
	3P4WQWeGKeOhBldZxHBsbtP4OBwv3r4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eJdlAp9p;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788818113;
	b=m3VW+TYQQbHR9FXQ1lt6tsUUDLLq0n9AynRxV2hOMQYHz6U6B4+gDasL2WEbkWxaD1u7Fp
	FWgn5bblo8IAzx3DeZ9ZVQpLOmzU7QFHaYdiwXLL8CHCntX1oTFbrjlEk9yOK55lzQoGTl
	FjY7QTjpJGcJoDFnKsTZhHcDlZvrQw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788818113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=U5vbt3dDTcq0wdPHap0JtL9B1dVtnkBH7soBmqKWLIw=;
	b=eJdlAp9pL8/AkZmsFNcDcH488lEHuOZRyL7mwqYn0eZPYi1qam0Eo5uSt7A0C0yFVtqPnK
	pHcZQYNQA69oXFIBBbmkulB3dWcd7DCMt694WaME4MMHyWMAKvUTT7kpBgJmQsyfsbK0Sb
	0h+Os93nKe1btBgHBM87lpYceJCgUDU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-258-76hC-MuePVOa3a9FHcteLQ-1; Mon,
 07 Sep 2026 17:55:09 -0400
X-MC-Unique: 76hC-MuePVOa3a9FHcteLQ-1
X-Mimecast-MFC-AGG-ID: 76hC-MuePVOa3a9FHcteLQ_1788818103
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 91EAD1956072;
	Mon,  7 Sep 2026 21:55:00 +0000 (UTC)
Received: from fedora (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 8E52D1800257;
	Mon,  7 Sep 2026 21:54:42 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Mon,  7 Sep 2026 23:55:00 +0200 (CEST)
Date: Mon, 7 Sep 2026 23:54:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Gregory Price <gourry@gourry.net>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>, Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, david@kernel.org,
	linmiaohe@huawei.com, nao.horiguchi@gmail.com, gnoack3000@gmail.com,
	ljs@kernel.org, sj@kernel.org, rientjes@google.com,
	shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, tony.luck@intel.com,
	reinette.chatre@intel.com, x86@kernel.org, paul@paul-moore.com,
	jmorris@namei.org, serge@hallyn.com, pavel@kernel.org,
	lance.yang@linux.dev, pmladek@suse.com, longman@redhat.com,
	mathieu.desnoyers@efficios.com, jiangshanlai@gmail.com,
	qiang.zhang@linux.dev, dietmar.eggemann@arm.com, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com,
	mark.rutland@arm.com, Dave.Martin@arm.com, james.morse@arm.com,
	babu.moger@amd.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
	rcu@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 5/8] kernel: convert process/thread iterators to
 for_each_*_rculock
Message-ID: <ap8yoW37GY17pHYS@redhat.com>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
 <ap76-0-hN6CAcYXX@redhat.com>
 <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
In-Reply-To: <ap8mgnpE7D4TTrno@gourry-fedora-PF4VCD3F>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KuTJyUN-BdeD7s2OgomzeZAazGGqfpu-AaEFYHirQPY_1788818103
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: qt51497c4e9mjzw9fqd6dymoecmfhopk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A00F6100003
X-Rspam-User: 
X-HE-Tag: 1788818113-72610
X-HE-Meta: U2FsdGVkX18thryYkjqEf8J4I60UYGbOrXr7AIA6o4/2CHbrjdZl2p8AyHhq5uHVO1eJDGAduPPyklEDlgoC+gHqmTqijnJlDyIPimDAqg/Ie1PBrbSijRr4XxqvTjAQAVggFsnqFWe0o6dcfxdWEI0BVJ/ALG5BMX6mJbcU7NDRDP20fz/WMRcf83fPUKjLy8vg3huScH8UrmYlkJzb+4ZVJzueKnC0K4qPLBXoYeBzGdIGjKS1ZQjOjJep07mtRzDde6EQqbInTdhoTxl+3YdM7f+5diWJMPpQxLlXoDNqqRKuihXRIGBjt262QeddSBeXexqHRbED1gpvrzhyEm343UNhK6FDu/KrLUVyrlIqMpvjTzZWBM/9u0regi7+o3owR0FPCYfAFZgN86cUX3xxFbkJZWvA3ZIXN3a7XwRU8TU6M5+dG/PHuuaGxys9m7gxNaEKAe+vb8CI7ehaWJWdHhi4Dfz6lHJVSxlHdkA39vFpZnnhXQ1ve27qCrSSNrKe75TGOAdHOlfFdooIUuQe2U8S38Bl6FlfDcq1bNG5PaZc1Y4NeZgK1+nSTHavGqhThPEreqFvVJAQ+Dd8snXf5JDJSizlqdClr9Xud6foagdSOi+DSmCfzOGUs+OnEouussb7NRNlPBdprI/MVVEGmdmLmCORVf1X42sGom6eeKm7SMgZCHOAtwGpGBOxf/pnob6flliAC6ofrauuXpKgzS5n7Xs21BP2i7WPWCAmnFV96XrMUVT635PLvtck9P6UDzXfMTj/MHbsAZ2QJ8JGehA6lNyz1CN9yqpti2FJBZ3pSdWRrpVfUOty2wfFx8drnVDAolAORFYPpoIQUnk7muJWxE02EaaM+3LSC0+7scT7OAUyoHQgRfNt2TzoS4k9vNJ54w9z5DSS9PJqpE//xMkeGgQIwBzB0d/Q9Cpf/79QgQVrce9Ewk1qNzhW+sWjfxs+DUMNmKVZPoj
 I58P4UBT
 SfTav8dvSROycvvQL2HrZi3lCOjIgJ8w5kuk3gfaWdVoJEG2PIekGIlOuarG3mltIdVaWQXeTGNHAMTFC07/m4fOQ134Kge/DLHD/5AQ8/p0YzlsplUNmB/T/S+u8cGx5+YsOTMv4/pdkh/AYzZ+PoK5nhE+DQKD0IFlTdwX4fpdop10W1fob2pQhizRhQRE0R+MAgPfQdiIr5ImsYTviaXmkyVMUuK+G57KOyWTHdfZpc9OVIdr8Ig5okcbFr0w8Cm4C4DLawZnTYbg2doQCDqnaTHBJd4Ps1dqqg9ZH3RAnHkxSV0Ev4Si5E/0oMDZ4KqFYHoUOjhy5HYdIJqlJK2lFw3AjVFppf6qKxESkOyEpZ1d7p7/Q1q0uguqRiKHITYVE3Kww6vs9/hOqjq1QpDbcx8jQyrjZeh0WNtJJtfOTIsqEVaY/VjQsvTYWYBH4claK03jB+/FEg7OkcjCJsQYGfkspjRA9abIL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/07, Gregory Price wrote:
>
> On Mon, Sep 07, 2026 at 07:57:15PM +0200, Oleg Nesterov wrote:
> > On 09/07, Gregory Price wrote:
> > >
> > > On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> > > > --- a/kernel/hung_task.c
> > > > +++ b/kernel/hung_task.c
> > > > @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> > > >  		return;
> > > >
> > > >  	this_round_count = 0;
> > > > -	rcu_read_lock();
> > > > -	for_each_process_thread(g, t) {
> > > > +	for_each_process_thread_rculock(g, t) {
> > > >  		if (!max_count--)
> > > > -			goto unlock;
> > > > +			goto out;
> > > ... snip ...
> > > > - unlock:
> > > > -	rcu_read_unlock();
> > > > -
> > > > +out:
> > > >  	if (!this_round_count)
> > > >  		return;
> > > >
> > >
> > > The sunken rcu_read_lock()/unlock() + scoped_guard usage makes this goto
> > > at a minimum very confusing, if not actually broken.
> >
> > I am afraid I misunderstood you concerns...
> >
>
> This might be my - admittedly shallow - understanding of scoped_guard,
> but does scoped guard handle goto correctly?

Yes, it does,

> and why it's generally discouraged to mix cleanup.h and goto.

Hmm, why? I didn't know...

Oleg.


