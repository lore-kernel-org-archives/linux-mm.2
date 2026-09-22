Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A24C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 07:22:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EAC26B00A0; Tue, 22 Sep 2026 03:22:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2266B00A6; Tue, 22 Sep 2026 03:22:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8EF6B00A7; Tue, 22 Sep 2026 03:22:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 053096B00A0
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 03:22:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83EC0A03E1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:22:23 +0000 (UTC)
X-FDA: 85240554966.04.5F26D72
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 35917C0003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 07:22:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DWGtr7PF;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790061741;
	b=CkIeyAjQ75sUIQDJf5qfh3o0ZMubXXa/KqSlSmHfKPETBDsFNzKJJ88cvSbj1U4m8eO2Ti
	onmyD/KPdhHFcacKFqdXkCyJrn59FcC9xW9pihP/7nu3kyKQI51SUzjJq8f2WVXx9bsMag
	8qArznNutlVEs5r0S3W9iT+vGCE7Cn4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b=DWGtr7PF;
	spf=pass (imf22.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790061741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D4O/+js0VFa0QVJKCFXfhOl2hsauxjVReI0OW+GgIjU=;
	b=X4I0gvx4iUsgo+VmzdCR6589SGcQOOv0asYMhWzdD2W87M902cDQYs/nJisljF9QDN9yRb
	Es23aUi94cRnB/TO/cmgHbLTRR91UB1XGfV7vtdYCDTBAJt5QNapt8XeUy7lzqurRWCPPF
	AyW/IEhXn6/bYrOPjWH2zPDusGmBCQk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=D4O/+js0VFa0QVJKCFXfhOl2hsauxjVReI0OW+GgIjU=; b=DWGtr7PFOztE1CkDEDs7zTSwkq
	/Qwknsw2rToEPRw1LFp/aj6mTWalhDgWM8oqYu1+loY2jiJdxnzzZ2lHi9KTGLAI9QcgAVWIDCdKj
	YaNtkIKBiRHInmbuDTdSywj+ZpAg55uzCAz0F0wLqxowzAFm4e+UejlyvM4WqEFrMTXv+QBLXoR57
	NSsziakePeYg57e/LG+9JXAOO2A1Z9/ARr+0DRPM8i8sTHGfFRxq/Z+ZasE1712hFrgBE+NHcDsMI
	JGj6zLPa3lPeyh5fkaNTj07BuUdB2v1eL15lpxkNjUN8y/xzijku4RKY3QpoWNfumqOyx9NDBHd+R
	Fc+HBt/g==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1x8upL-0000000DCmh-1yMj;
	Tue, 22 Sep 2026 07:22:07 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id B074F300708; Tue, 22 Sep 2026 09:22:05 +0200 (CEST)
Date: Tue, 22 Sep 2026 09:22:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>, Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Kayra Cizmeci <kayracizmeci@gmail.com>, stable@kernel.org
Subject: Re: [PATCH v2 1/6] sched/cache: Keep nr_pref_llc_running in the
 runnable domain
Message-ID: <20260922072205.GV4121339@noisy.programming.kicks-ass.net>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
 <06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06af61afedac32e6477f57feb4d658f6c411c3af.1790035273.git.tim.c.chen@linux.intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 35917C0003
X-Rspam-User: 
X-Stat-Signature: 9r8opoaay3nnzz5oeqwdoeinefy8omnh
X-HE-Tag: 1790061741-495942
X-HE-Meta: U2FsdGVkX1++pPZEBPiVQRsaGqMummSpQq0jfYIjrQDmC8NFBCUoMVwWHKPSZb1LgX/2xDp6QYYIegEn/0CcrEQPjZezxbg64b46l11/w9l7hwpWSY5g7Xq4JC7kdHQaiGRU/O//rGuVxMMzM0qYmqXHenjMbOZaBe19kPinICOC+Pvq/FJ09xf6RwoYRhpN9AulL6wbsLalT2iFrleQF3XygGVOYi/vDof8QETJZU2uHZd1TfFIuLZARg5v8mJLQ2xXGvgyIBcUtd7Wb0lzRSXpZMGOZCJNejVzpa/xvuk3Um8PslLb5BIUzF+B3X3CVH7Eq/7YlfskR7QKCuz7eq+5EzYm7Pz3mRuborK1dc4zD4mW3Tmpj7ugTKkMjN6qYiBul7yCmG36labyBsUo4jV6Nh7Pd+caNCXaTnmxEyBigCbeaMcTdVPpVTwHkuNMYjhb3H0sz0iXxToTI6jgtjNm8rSwDBax+t/eSfjI2sM/jJa5xiaERCLrTNRos1TdWa4ToeeQ+Quf881rAX8LY/Tg/oByb8GwSWco6uAVfPFEqxq9+w140kdKWIIoKgSTuRJ25ikeMNyJNXH071K1AR6aa6Vq9dO8dBaisOqGHvcgPv66ByjLGTVFq0PTuIrOAWISjd6m9G2IRQKgBSZgLQbhfFxO+pIFmUbgcqJZf0p3zXGcZuHOR60FWLSRRoyTIF4Gvkvrr3VtdbpiEoWPJxsbv3ygabfDGkwcf/MXCZ7H5ueoRL5RWXMYyG1a8MIshrxnFk6qTJM1cpJO5TSBw9mc0wHnFyhdxDzwK3OVNrKNj2+JmXPxXdT0OcWP0vaCP873rIJEPFM53zFCgIMvAgWFmUmrBBCTNuuG3oI5BstCZAccD+TzOWZNDOJmRIlXx82/oZIKfw05aVXiGKQwHKebL3IiK3AsLWUb94kG0ZDq0twx6k7Em1BeE49samPOJ8X6EsspPEsxWvhu91h
 E6Sp1iHB
 o9oDMrIRcGKia1NAa7GmJytyKbBOzammkrsI/Hnz4rcV2tFrUbi77A30l1x0BoH3Ukr+wZqedBh+Lrnrxh8RElPmxtJ8ON1rQjHi2xJt1QQ6D9yAFvLE3LnK8763nxDtvRXRO1rULeLZxRSsdyUa8jTmNzTyewJIOorZwVYhdEYdQ7XqEVVVGYzRdCBLw1JWqdtj6Wo6kc+paSFjc7jzjIIl+fTdTr5BUP5y/pDnc68WuEDpD3AOvm1+36wRyk4HZds/74CqRa+no3rscyA9TcyaYzXYnvLH8pcy0nzEpmOqwy/esOx5JHG6hCxndw3DeDGIM0uel2H8ZqpX2eLhjgveJbPp8dgcoqUXezn4IpeWNv3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 05:37:22PM -0700, Tim Chen wrote:
> @@ -6395,15 +6429,27 @@ static __always_inline void return_cfs_rq_runtime(struct cfs_rq *cfs_rq);
>  
>  static void set_delayed(struct sched_entity *se)
>  {
> -	se->sched_delayed = 1;
> -
>  	/*
>  	 * Delayed se of cfs_rq have no tasks queued on them.
>  	 * Do not adjust h_nr_runnable since __dequeue_task()
>  	 * will account it for blocked tasks.
> +	 *
> +	 * This check can be removed because when flat pick
> +	 * patches get merged as only task can get delayed,
> +	 * same for clear_delayed().
>  	 */
> -	if (!entity_is_task(se))
> +	if (!entity_is_task(se)) {
> +		se->sched_delayed = 1;
>  		return;
> +	}

This is dead code. In Linus' tree, where this will be applied, this can
never happen. A possible backport of this fix however will need to take
care.

> +
> +	/*
> +	 * Drop a task leaving the runnable set.
> +	 * Needs to be called before sched_delayed is set.
> +	 * clear_delayed() mirrors this after clearing the flag.
> +	 */
> +	pref_llc_running_dec(rq_of(cfs_rq_of(se)), task_of(se));
> +	se->sched_delayed = 1;
>  
>  	for_each_sched_entity(se) {
>  		struct cfs_rq *cfs_rq = cfs_rq_of(se);

