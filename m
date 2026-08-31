Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D461CC624C6
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 13:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4946B009E; Mon, 31 Aug 2026 09:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E65AF6B00A1; Mon, 31 Aug 2026 09:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7BA86B00A2; Mon, 31 Aug 2026 09:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BDF8F6B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:24:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 56FFF16012E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:24:22 +0000 (UTC)
X-FDA: 85161633564.06.FC9845B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2887440003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:24:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=avtLy9AP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788182660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DjtUTQ2G6VSAPLZAzQdu2hdsnEafVFpdgPC7S3/2EY8=;
	b=U8wRmvEhtXOTw6Cv9WBBXZAKZ3qei9k353h4v9vTc77yW+oAG5j1AYDLgiQS6Fiqadx9Qw
	MhXxtpkmyjmH0tWxyZI+bXkRZGtkgzuJC+g7+/tvvH13lAoUvoxx7oM6HLvP+/jgL/91xv
	dANZhqzRFLT6YWlWoZMDd9Q77yTu2lw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=avtLy9AP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf04.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788182660;
	b=FDYGQmKauoLv2dm9RTRiS6mxADZ/EwMhzDz54V90KB1l4edoUC9izhxLDJrxsQ/A+oFagL
	YF0qUGVSuRDUONVGiLIfqp3ZGBz2/YB8zjHa/5riiMANYdPMuUAmhm+NTdJvLM479nrz8w
	v++nPKlLSsP0pzRUSnhBA2zkItzgFfI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DjtUTQ2G6VSAPLZAzQdu2hdsnEafVFpdgPC7S3/2EY8=; b=avtLy9APyyqf0a/7L/3CS5ngrt
	d9th/eG7Oqdnvo3kDIumpon9Yk4XjiiC1PpwpqatnjLGhoMBI3Zp+CZPCYQFG0OFg8gWNvoNqLVY4
	mIguqF+OtvpADKFIfwGVJQw6+q8QjOru9rce9ae6mYR9caBJWWiKUAu51Yp4fzp87eA+K+ND8m5DG
	5Ezt0s4jlZDzo9fOOGyc8mS3pLe56rl+BNYxlicmu2F/d79bPwLjoM2MInvV+sLQsJwtOxa/7WuNX
	mElPlTVvoK/KieaxRVI29JVD7WzLDNvesDzsahrocRXHeca8XvoSoieFOwbm5L8V6MB6JMcUFYSbc
	vOmXoYqw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x11zj-00000003Iux-0F8o;
	Mon, 31 Aug 2026 13:24:15 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id AB0E3300E7E; Mon, 31 Aug 2026 15:24:14 +0200 (CEST)
Date: Mon, 31 Aug 2026 15:24:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jianyong Wu <wujianyong@hygon.cn>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Chen Yu <yu.c.chen@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Phil Auld <pauld@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, jianyong.wu@outlook.com, zhongyuan@hygon.cn,
	huangsj@hygon.cn, wangfengyu@hygon.cn, yingzhiwei@hygon.cn,
	justin.he@arm.com
Subject: Re: [RFC PATCH v2 08/23] sched/topology: Introduce a per-CPU tasks
 NUMA preferred counter
Message-ID: <20260831132414.GN4120091@noisy.programming.kicks-ass.net>
References: <20260827122816.756234-1-wujianyong@hygon.cn>
 <20260827122816.756234-9-wujianyong@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260827122816.756234-9-wujianyong@hygon.cn>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 81r7u6smabuksinr7fasxgdcqqm1cx7n
X-Rspamd-Queue-Id: 2887440003
X-HE-Tag: 1788182660-793269
X-HE-Meta: U2FsdGVkX18MzfVrXxX4U/Dc55ZEYZHdKsezQTgQKPYhvxwgqVdAZcwYFiWoKrtcRJ/afl9IW+gkUbKW6P4pQMb8U1sLFW/fVwAh5WE6HPEL2wfjGduDcjX00OG2UvO8N0cJ2uq5+O79UVgeha3XT58S7RAUo55B2FqNmDTrxwLGJgqXIRpuZhAWlqGr/KpwAgixmqrMe8hVhABmjk1oTzDQE2CaM7AgTNIJUj0Muezndx8FlHYck1EzqpOPOCUxcbdgN4Wo/lnJfa6EQqtPZLbFZX9HeZGL2+kVQiknMKJZT/PRSIpVmSWAQSoSebP7XjRWAo6RvuDPdghap4JmeVJ+XPZVdedHF/AxpnkINsGLbcQUl6v310yYhQACi1nw6cEfOhAwTOkQJH85Y35OS98GRlq21ySLpEm56Dietrrf5r+kfluiggGWP3/vx3bEF1e3ebAbYEi4wbx2TUU4uGOjV7CnkJSVM4JXNi5sIDkzt8LFtjKKFM14BUHGqxjCW2FBR4pG1MV4U501IiSSGl1FgBBG55e1ALZy2IKPQN1J/w903XyA5soZsknaESR3VXIfxHJzG3KQM09do7qER2pwTMZq3mdt4tZ3l1GmwurnX3rLyOVUlUIK0Q3CylisyYlxCoB5yGfnBf3VqlvWVUIJ2uPNDKtAgFA/G9MdNaf32Ryw7OjxrGzo3azEuGFmYfgUuUwfWSfOttlruOQQ4IU/joj0Bhs2y8JAVSmwIxVH6F90nPq1oKFsP3ylGeWq2ySCItgK1w/AKh+nlGIua7OjeP09cXuTDE6SpXuOokclfRlwt38YTRiVZlbcCISHvHaNxhoGxiKkfdKJhpUe5AwzOJnOuTb0lxQsMAR5C8mlUb6VTeSGBB5PiGZ4gEkAhv04OEveBd+CLX4ep36oWjVGM1FLqpMQC2aaioat4jZzW/fmYcMro8cRWMymUUaUGwTArMiPAtDol6cVK3C
 OGo21FJc
 JvjPm0TSqUMVy13z69NpnryVIhzrLfwO91FS803nLyAUIorRsr0r/3HtXVshyAkKdGLhZqq/yAV4DhiK3HBZF6ABAfrsP7/YMf7r8qnRSLPzZUuLw1fRoODL38hY58oPESmNjxMGkZ6J8G1YOgFEP5NmTB2sxAEwsNg5mj7CnDTqWHKj6x2YEIYC4Z4HfYtykKqu1UAbZMt0Uo7ugIE/GSdZtwuE3yDvM7lbwnvhLmDTzpQo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 08:28:01PM +0800, Jianyong Wu wrote:
> Like the existed task LLC preferred counter, sd->llc_counts, introduce
> sd->numa_counts to denotes the task number that prefer each NUMA node in
> a certain rq.
> 

To what purpose? Is not the node occupancy the direct sum of its
constituent llc occupancy?

