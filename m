Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED5CBC624A4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 03:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DB566B00A1; Mon, 31 Aug 2026 23:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B2A6B00A9; Mon, 31 Aug 2026 23:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3956B00AA; Mon, 31 Aug 2026 23:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4205C6B00A1
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 23:00:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA0361602A0
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:00:35 +0000 (UTC)
X-FDA: 85163690430.06.54D7E55
Received: from mta1.migadu.com (out-206.mta1.migadu.com [95.215.58.206])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7A6914000B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:00:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZw8JTd8;
	spf=pass (imf26.hostedemail.com: domain of chen.yu@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=chen.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788231633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQqRLqtekv/pvaJlQnc+x+ZRETcfWFchzSG3UgYD/7g=;
	b=hUqlFK7MIiuYdQ0nVlvFLLkquD1uVxUXEvJlsxjDuCCyJXlQGvaiMJHyFh0uH/RLrb+O3T
	1NOESyDVws7pZzY5Q6xGeanm5xeZOJt5pSWqjxjgKGUlQhIeSit2lVYGc9bdk8JJMBd+Ni
	wJ9ITZC33nfnSsUfi6dGbnS8X4DxffE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788231633;
	b=JGV35Ive08HCuWOhcbhrEtOvYmrpQO6ZTRH6OFo4pG+noWsLKsVtFmBTDdz0xJtilGbgVf
	j/0j8XPgf1s6tdk8tMss6ymAzz+YqoFaV5hUs0UhZTCejGUfLe3X540INOgFTwqA9D92e5
	wqDJowud1ajXC8msUIlCK3G9rw8nRv0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PZw8JTd8;
	spf=pass (imf26.hostedemail.com: domain of chen.yu@linux.dev designates 95.215.58.206 as permitted sender) smtp.mailfrom=chen.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BA1fZXNdm9XbdzD3T6eEi7wnLpD4meMpKZQWYa6zg+c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788231632; v=1; x=1788836432;
 b=PZw8JTd8jw+hXPFos4eRuFz2nLD7dKrnHv4AP1ZYofnYiHDdv8fz/vSjbTqe/1Hin9AbjykY
 CMdkWyqJHn62VKxdrsyaaw7rAVdVp2vekOU66mDEzhcA6LHViqTR3xmWn2aNhQZdUVMmkypuxLj
 Ukaya9b83aouGj8/9migBCUA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 481fa12d78614b3a;
	Tue, 01 Sep 2026 03:00:32 +0000
X-Mizu-Trace-ID: 481fa12d78614b3a
X-Migadu-Flow: FLOW_OUT
Date: Tue, 1 Sep 2026 11:00:14 +0800
From: Chen Yu <chen.yu@linux.dev>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Hyunwoo Kim <imv4bel@gmail.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched/cache: Fix use-after-free of the mm replaced by
 exec
Message-ID: <apY_vvPExYP6qMZS@three-body>
References: <apPb-Dr4nPYuHQOK@v4bel>
 <825d9dcc-b052-4367-a9c7-15efc4b354f8@intel.com>
 <apXV6t-7drLDf-lL@v4bel>
 <a1a0bc24108e68656041dc17824d6b88b4120058.camel@linux.intel.com>
 <apX1ufR1reYZ9LBc@v4bel>
 <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db2436d91e2e04a8a1063553ce64acc74b533f5c.camel@linux.intel.com>
X-Stat-Signature: 6to9fxrfirf31gk8frho1apuimse6oew
X-Rspamd-Queue-Id: B7A6914000B
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788231633-984541
X-HE-Meta: U2FsdGVkX18EBkMdT5NG2rL9aK2MdGvDJF48iR1zJsgTI908OZlhGAFKjCqcmMBAd6Wud+aDPjEbBTDfB6nghRFXZVxLtsK9Mnt4adoYFMZt/aKDklbDz6cIJ51w3IzFdx4nbOUyu8zrgH6J29Ul0xR9PeOMFF3Lf1dxIn3kLegrGJy8Jfbt0968VKMWaCqYyyO4T2870XyVNjhtS0G35JlKv6W/SRyKqoyM+H/WB3pEAZwWcpAFdCy4R8TrtIVaduL7TpoZqjixiRhgJm69ND1XlDuIFolE0MxivxWSWUc91zH17gg522Ui609jYIlZn4Mmxh89xFUTR1IQVUIyyt9U8SfZeZzsATKSUj0uIf7uqlM+MArYbtOdrrqQ1pH97BByy96XOh8GvnF/K66CmJNuBuYwwl6Z6VSaPoHgQbr+b0m1eFr8XPmKL+vUVRz62hFKzQWIVLmTq2YGruU9OQmqEXvYXryvIcnpXp9os9El6KcU9FsBHrj+ORERWRUDYuzsJ7+A2s9wAYG8BsfNnj/6E6FKSL7tW+YdMQOF6jqCbyAA+T9feD6hHCQgKIhh+6zlQ/wnDkKaGt2BscDxYtfeWSGAgUnShkf55Fk4ZgCr+x0EMW7AazNHgmrOAh7Ti3vwifEM2i9Rcq+q+3QNESjtmVgQ5elq8DQqribtlo8/6IRRIxnXdMzhuHhklSYimqfrvoiL5xb2kz8DbN4X4dctxrphj0uI7HmNngwJY5wuGVE1aty5VL8W4oLWgA25iqFIdJKEpStuecwAgOOIoOu1hzJG0TNZWg3Rv0deGFk5lYlDq/iD0IPTOllX8pIUlE3OVYCaZ3pvlqHFyBiJigSFrN5b5ctRPmrY5GwuHKJ07xBkGj7K4S12BeXPH5XNwVtU11405AvxXGMDyc/ZwJ0uwqzT1goSWLtGVaKJFaVcgEcDaahwNczFAX++Z+Yx24Tfi7zPaFpwdurvXW2
 iBMKVQ3k
 8nJhpETh394TR6zmGVQPtpOnsx0eMTo2LtiDOVGcsAG86En/0UKMdXE6+i2vv81R8c3XXwisyWVRu+j8uJ1HSxGbOWUUGvCGZtB5fEPGJ2BmRbqZXEPehSX5J2w/e9x80KC49/eJUzS4OVqz8HkDdvU6kia7oAN1Hlyzl5G/iQ3npcP06QEG+TK8GNZGjlLSuHLT6r+TVyUADEDJQqQgs2vFTHGgL0gXY9R2MS01P+qO7tf3J9IUsRdIF2f60MuGRt8z/chzppBub16Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 03:10:40PM -0700, Tim Chen wrote:


[ ... ]

> > > We should probably prioritize to merge the first couple of patches from
> > > that series now in light of this issue.  It will make maintenance and future
> > > modification of the cache aware scheduling code easier.
> > 
> > That is a fairly large change. 
> 
> However adding rcu synchronization will slow down the launch of a new process
> too much.  The rq lock solution has less latency in my opinion.  But I
> think decoupling sc_stat is the best solution without adding latency in the
> exec path.
>

OK, I see. In decoupling patches 1 and 2, the lifetime of the sched_group is managed via
a reference count, and it is freed using the non-blocking call_rcu() instead of
synchronize_rcu().

thanks,
Chenyu

