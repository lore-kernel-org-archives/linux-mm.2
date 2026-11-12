Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16721606A89E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Z3ToNYQn
Received: by kanga.kvack.org (Postfix)
	id 1FEF46B05B9; Thu, 12 Nov 2026 03:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D5D86B05BA; Thu, 12 Nov 2026 03:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 113476B05BB; Thu, 12 Nov 2026 03:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E42906B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:13:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 875A440500
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:13:55 +0000 (UTC)
X-FDA: 85425753630.04.1B62913
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B5AE120004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:13:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z3ToNYQn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794471234;
	b=aD9Ow1SOVcYrcsGESOBFR8H2ebnvRrkfTVQv5//1lom8xyZnP6mEb5lu28tek85cTqY9P6
	qmgJkeA28g7g+qpn1wRWnTlEwmNECM0OvtyNEs1sBgANJXzK6F+tdKCo8MmyJ7xHu3j0ya
	uHt31r2KOpcEQbFMswDwTRgCHzJwVBI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794471234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAYDr7E9radjTyRXS1eA7bh71I8p+v4ZRugl/5oWIR4=;
	b=UQjFA345d5uYN1ep/2Oc0eUjFYBiA8xU2qfPQLv0xx6hRgUSIZLz6ybu188u5I1zO5H5kz
	E7aOZ98v3J15l33gMeQlQc2A/DvKUecCPlJeMD7I8WEM+pfm6/2Z37zo+1k/N6HQ+vFuiK
	bMLkpwL88EA2nxUW4gtrXVLtxGbSX74=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Z3ToNYQn;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf29.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=AAYDr7E9radjTyRXS1eA7bh71I8p+v4ZRugl/5oWIR4=; b=Z3ToNYQnxFAsoPoDDgVrvhhZNL
	dtjRUB7EHRxJZcB12yPrzJEf3Ngqlw0EknhtanbLagP2BHoXEGt5bkNXybMgX1AFqdPDnlwyIYsaF
	H4bhBvmrXcKoUorNBozISvXJ5bZ2o3hq0gCZ3Isj3aTArlk9ceAL7hw+dkarnLLHOQB9HxEcTTACx
	B9Oi/xmXR1TfWIEuLoMJi7VPKCzjqBpupX5tUsfflexYI1n9tFkaSPksVvapKky60sOoCErsG9M9z
	bPLDER2K1Dp3oFnvUzQkKjjdpGFAtTwVOQ5JFF5PM4nqvaV+JAmj6r92L10ZOglAf1NIN4Gj9yK58
	Ldn54HbA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xRPwK-00000004ted-44CE;
	Thu, 12 Nov 2026 08:13:49 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 831CB30066A; Thu, 12 Nov 2026 09:13:48 +0100 (CET)
Date: Thu, 12 Nov 2026 09:13:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Huacai Chen <chenhuacai@loongson.cn>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, Tiezhu Yang <yangtiezhu@loongson.cn>
Subject: Re: [PATCH] lib/smp_processor_id: Don't warn if there is only one CPU
Message-ID: <20261112081348.GB2668804@noisy.programming.kicks-ass.net>
References: <20261111092421.3771992-1-chenhuacai@loongson.cn>
 <20261111170600.GS1779021@noisy.programming.kicks-ass.net>
 <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAhV-H6SYOjOw+owmStK7sr-HOiADC1zZ4Cii5hv1q+qYAUETg@mail.gmail.com>
X-Rspamd-Queue-Id: 5B5AE120004
X-Rspamd-Server: rspam12
X-Stat-Signature: gxgoas6yss5jy8dz7ct6nsh3cc5fqpdy
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794471233-50914
X-HE-Meta: U2FsdGVkX192y/Eb/CmKRP3SkKdMfCjgRBiMy6EHcqdjPPIU7cYKkPR4DM+OBksS0qp3GARN92Ejn9qMCVg5FcbpTeOCApOI+TSomve4q/oyocnE+eWmYpajuXBi4XNiHye9d/Q00qqFRc7vPC+2OhaWd3FrgCqLnScLsIMPBhQ2U9s9zr/i+62cM3kGehR2YmCHsyP2evbB8OdyaG8r53kPYl43O/FfzDjg2BPM93ebhdU2pvCbLxk0NwuDsNlYpXhaYdPUiHN+JFQDyEeFOpZnPbTRAPsIZbJUPsf/cMa8pHaHVZkzKvdurbBvBtnFxSVJzMxNcHpEPvDFPMw2oACUHmkFLQzYFQqxQRq5t9m7jT5VgDUVAThvHzsXbQ/kdEHni3PWmsCFl8WuBM4KH/BdbQ/UT5aiZO/MiK45Fepy8t7isOycw2mm2bUl3Dz22/IG53R7RxC9k08hu3eSVHa5/mrjWQq8cKM/O2rEoHuiZ7hrweJ3D0sf3zczsMUaHGFPOwn6dIzK33ObhDzpp+QfxMwRRiagCogHrbQtq50OSL8E09kzH/nSq6XFr4F9HsuUGzNqPenUqIE5lLg0L0vlaGEtp5r1Mpem8vhjZmhiUGrppZ2RlaEMTpfOnzo7LOHuag+cjeFBm1cyd3B/MuDRN3wHUZDURojpxKzd2ttzC0CiKiiYlYXv4rs6zS7zShTl17cv91nvWE5zTvHgQDFhBLp4RDMHp868XuLivZsVxC7W7AoIuQQqUU1hzl3LS9lOUah47CvWWcEALB2LKKcPvBD2pKD1BgaUX90BoihUAZxAy3TVTkgcVSyziqOiw5jnFo45QhmNTyd/ufiRzB2WlpyKDvoY0q9Pu5NBqKnHza5UrXQdo8tU42U197cYuXg32Z7ZuqSLACAePbtWx786ADTQWs758bkta6vHNErr4cY0U14RyekdTZmjtK4V/kGbKJqVeFcTLUTrFeu
 etCM7GxC
 R42uSswI2kA8G9efJR/t5FHsHijH4Dwmsmmna9QfjGVvKbEXdGGTzGXdzyYZ0UD0F1umO2whekvfydKk6xkpJZ/jt2vbKG7j0/efX5rK3kkna8oioWPoeJ1Jqc1P61H7okltUHs388g4rPwQcv4arWhal0FT1u1HiSk3wFKkLLSy56wOwemuMArit2pKNXY0clocPF8B6sFQgEdtx49448rCm7LvxOMemU+kEqJZxa8xRVq+Z7n+IFuD7/Yk25gCEXyVdfGuamRvXWN6CLMk1R+FAPBZnP7em3AJq6kvNvfUHQvra0SX2jtojamKLB5oXapjnWtzKNs85pgeYmMW+E+WZYUZkk3c7W/uAgyAt8E6ossKncbSDva9Lq9DGdgejsI4bUZCOFcpXsGqChX80dgH0pwCeB+JbszDnak7LFv27ZDc+5Rxji8kzzs9HN+zMuXtTdJKA6R2HqT2NEAE0rKb7hGGj+p2stORd+KpIiPpart6hWSdggLbTIzijxzZvVN/vligAyXYzs8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 11:14:57AM +0800, Huacai Chen wrote:
> Hi, Peter,
> 
> On Thu, Nov 12, 2026 at 1:06 AM Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > On Wed, Nov 11, 2026 at 05:24:21PM +0800, Huacai Chen wrote:
> > > When CONFIG_DEBUG_PREEMPT is enabled on a Non-SMP (single-core) kernel,
> > > calls to smp_processor_id() in preemptible contexts trigger some false
> > > positive "BUG: using smp_processor_id() in preemptible" warnings, which
> > > are harmless noise because the process always executes on CPU 0 and CPU
> > > migration is impossible.
> >
> > The check is still valid, you don't want to have any code that uses
> > smp_processor_id() outside of preempt_disable(). Such code would be
> > invalid on SMP, even when ran on UP.
> Thank you for your reply.
> 
> At first I also think that smp_processor_id() should always be called
> in preempt disabled context, but after investigation, I found:
> 
> There are 5 existing skip conditions.
> 
> 1. if (likely(preempt_count()))
> 2. if (irqs_disabled())
> 3. if (is_percpu_thread())
> 4. if (current->migration_disabled)
> 5. if (system_state < SYSTEM_SCHEDULING)
> 
> Condition 1 and 2 is to make sure smp_processor_id() is called in
> preempt disabled context, but Condition 3, 4 and 5 is not.
> 
> Condition 5 can make sure no context switching since the scheduler
> hasn't begun to work, but Condition 3 and 4 can not.
> 
> In other words, Condition 3 and 4 can only make sure the current
> execution will not be migrated to another CPU, and I think my new
> condition is exactly the same.

It is not; your patch would suppress any and all checks when ran with
just a single CPU. Even when the code is clearly buggered.

> > All code must be SMP ready.
> This is why I use "if (nr_cpu_ids == 1)" rather than "if
> (!IS_ENABLED(CONFIG_SMP))".
> 
> >
> > Aside from that, nr_cpu_ids is the wrong number to check.
> Correct me if I'm wrong, do you mean checking num_online_cpus()?

num_possible_cpus() is what I was thinking of. Notably, there is no
requirement that the CPU bitmap is dense. You can have nr_cpu_ids at 256
and use 255 for your boot CPU. It would be completely daft to do so, but
it is still valid.

