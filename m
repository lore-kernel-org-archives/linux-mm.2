Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89499C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:51:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C7366B008A; Tue,  8 Sep 2026 03:51:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8513D6B008C; Tue,  8 Sep 2026 03:51:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7195C6B0093; Tue,  8 Sep 2026 03:51:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 51BAB6B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:51:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D772D8039A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:51:37 +0000 (UTC)
X-FDA: 85189825434.27.7CA1CBE
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf06.hostedemail.com (Postfix) with ESMTP id BCE43180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:51:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ShATaOIH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788853896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBoYasvQbq5xoJP4LEh5aZoFUz8WO3/k380GGIEYruU=;
	b=G7075Zqjoq97HI32ZJT8bdugMjtbMhIRKxLPqXmSyS3RAIZF0LAKXRQls9+0K77beYbnDq
	HHmmQ3g0jnwfp57x8vYq9RJs8XHBAaLwvCanXM4+OWTB/aSW+zLbD2qGIBNEORVMNzIwjJ
	KcL8JDI4DE+W4giPAXEE58bmsrzoYTg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788853896;
	b=f4io/PAGQ7jpVvKHjrMilTnH0qfHmI7kkOVpJ1Ne3MIHRCoRDe6U8c9z+BL13MjSWwIho1
	PkfayebTIiewpFztFDxKc1Yzu6PIBdKYTaWS/r4pcGtzljz/ZHIyVl+n7nXK1gozbysXUh
	2Yn3exynDqoA+Uq1ZSUJcAjPV0VYSDw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=ShATaOIH;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf06.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aBoYasvQbq5xoJP4LEh5aZoFUz8WO3/k380GGIEYruU=; b=ShATaOIHOybHQY3X3kyZOxABwz
	up0/bGTgYAoJc35INagMHxufwc7WoQYiFd2iEwLBRifANfuGDmfAiX2g6uUgkEb84HCNIf1CjZz3E
	IRqXRBuXtEJ3fKpEdBzp6YWfa9A5YKnGEwbBA+Blekjh3K7dg5e298zVQWMf0fG2Z/a7fKg3vgVY0
	KtBBrjJc8Iz7fOPoBNveIDNOOEm9teTUHvDZ3z2mCv8CfL/qR7HUWKa4qdMexkVHNycrQ6x6s7Rri
	zcm5xAdeh/P1FwccYjz4hjc1Nxcn1gfxmy/aYb0Fi+wwBEklT4UT8d9MhnvxCibQk2i6bqBg8PtEs
	/jSNivGA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x3qbr-0000000H4yl-14M1;
	Tue, 08 Sep 2026 07:51:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E7E223005AF; Tue, 08 Sep 2026 09:51:12 +0200 (CEST)
Date: Tue, 8 Sep 2026 09:51:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Price <gourry@gourry.net>
Cc: Ye Liu <ye.liu@linux.dev>, Thomas Gleixner <tglx@kernel.org>,
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
	Michal Hocko <mhocko@suse.com>, mic@digikod.net, oleg@redhat.com,
	david@kernel.org, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	gnoack3000@gmail.com, ljs@kernel.org, sj@kernel.org,
	rientjes@google.com, shakeel.butt@linux.dev, xu.xin16@zte.com.cn,
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
Message-ID: <20260908075112.GX4120091@noisy.programming.kicks-ass.net>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
 <20260907081334.1152889-6-ye.liu@linux.dev>
 <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ap7dC-LWNaoPYJvv@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BCE43180002
X-Stat-Signature: ja33zr8xfa7nra65mghbr68ngr1r1ykj
X-Rspam-User: 
X-HE-Tag: 1788853895-664792
X-HE-Meta: U2FsdGVkX18mJDK/b6bLNHj+MW/QilrEJbj3U3Fvr1oYWRtcXX97GUdS3bjq0eISimlSGFR7XrxXwmHn59yYlNWK40Pcky+Aa5yL9LIG0PVS3aNV2CJf9p0wlOYMgdgsnb9PBJusTb7A4vZPYLTlsIBgEKu4sXqqRU1Esj9QYRHcjHUjtaWWCineDvIyg/PTwCsDNj7GB+NOdL5+Ug4Jn0pxg5sukVq8E/AS0hiIXkY8eKrtTBNngavabvk3hUYOkf5iS5vk9zke51bF0I+8NHPeGDazIlyQtTeHw24FHYW6sPkOQPSsWyYBdLaTn/uqA2FENaUHpmhF0j/GsqswnEYQIDJqqfR+dgnRSt/AtKpFKx3EQrHsfYL/O5whAnnqWnh1RGaAJb0u7iPT0lyBuFICZjhSubvxENpLIgH/m43wcFCFVqznVMPHXahAXbA9v5Ia+53TYRGyyCk21oe1dEmy3+i2ptUE27TjL2AnSL5ChnNEssqHaLch/VZCJK4A4qghRbcTN+0LGgL/jzsRaWnmUCIbrlAbrqJQ/iAGexyrbHnpXuk3A1C3j3zB/ytmZJn30V3m3jGtC7T7KbmObaTJaoIHGItx6+P+L7oFdqAi4qFdX6tXSFKWgrZfRGEM3sqZ5ogtpjf42S9C24NFJuxDAUnXvXWf4q5/BErELiHknvAh5luIk6T4vspD4e2cwW1zQ8cNAm3C1PnDB0FV7B5zYdyFJ0BGxF+YvuuagsIqiUEWI5xvz4BMB/f+JZaaImEBbaW6/1h2I1u2ba75G1JRSSW0vVJ3uEn42V3kwkfeccH4LttouBDSNbYjway2CGEvAx6c/CLXJEtBDylzGQh9uAhusNlDEqw8qs4QmL4oqsEmfS4CDAVuL+Y09PO9d+oKFmzPx5G48aNXgmIgN5pPlzA6YAapqNFdvnYBL5iIqqrHrcTCp/MGs1Q1daFaoopqm74hoP2kwEpWu9V
 oHSP7A/Q
 xKsIx/v62d3lJH14sXAQKPurYCi/oAvhemhJUhawbu6Hpas06a/OttKHE8xNrONEYVjUH0lFbyiZtkDzGyrWfIrbcstcjNU8O3Oggn/KiCYyReexVPbmJwJOQCSaTocnfmKzit2V7indR56BTX/PROggC/TgjBtf+VabHE3jlzWfQ7HtrOI6v4oiw1jeHwCqiF+soKDrwWrDxyHQYoIrc+3zAhg5pUpayUxeRzspQGcAE2E+Usysi02N4zBqLtY15lDQGthseRkBCNQ7YT5N6TvExb3Rc+77eZ41Q5Jh/NKcnV8UPyUSWutdijzfjDSVXtK6IZhRNEtD18sJ9db5DeIhz8K2XrU8QHPtefXPovgRKziuGFsf9wstKfqQQ2Uzn/Ql/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 11:53:51AM -0400, Gregory Price wrote:
> On Mon, Sep 07, 2026 at 04:13:31PM +0800, Ye Liu wrote:
> > From: Ye Liu <liuye@kylinos.cn>
> > 
> > Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
> > pairs combined with for_each_process(), for_each_thread() and
> > for_each_process_thread() loops across kernel/ with the
> > for_each_*_rculock() macros, which scope the RCU read lock to the
> > loop body via scoped_guard(rcu).
> > 
> > No functional change.
> > 
> > Signed-off-by: Ye Liu <liuye@kylinos.cn>
> > Acked-by: Michal Hocko <mhocko@suse.com>
> 
> Question below
> 
> > diff --git a/kernel/hung_task.c b/kernel/hung_task.c
> > index 6fcc94ce4ca9..73a5ad3be9a8 100644
> > --- a/kernel/hung_task.c
> > +++ b/kernel/hung_task.c
> > @@ -315,13 +315,12 @@ static void check_hung_uninterruptible_tasks(unsigned long timeout)
> >  		return;
> >  
> >  	this_round_count = 0;
> > -	rcu_read_lock();
> > -	for_each_process_thread(g, t) {
> > +	for_each_process_thread_rculock(g, t) {
> >  		if (!max_count--)
> > -			goto unlock;
> > +			goto out;
> ... snip ...
> > - unlock:
> > -	rcu_read_unlock();
> > -
> > +out:
> >  	if (!this_round_count)
> >  		return;
> >  
> 
> The sunken rcu_read_lock()/unlock() + scoped_guard usage makes this goto
> at a minimum very confusing, if not actually broken.

You can use goto to exit a scope, that's fine. Using goto to enter a
scope is not (clang will error on that).

Just don't use computed goto, that goes sideways real quick.

