Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97E55C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8932B6B0095; Mon,  7 Sep 2026 17:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843DF6B0096; Mon,  7 Sep 2026 17:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 732136B0098; Mon,  7 Sep 2026 17:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4908A6B0095
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:43:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBB901402DC
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:42:59 +0000 (UTC)
X-FDA: 85188291678.10.90883B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2F4A91C0008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:42:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=asDN0pcU;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788817378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3ajM7rRzZOM6WqeLBJOEovDBaOSN37HTunc0pSzZyk=;
	b=QENMwzsi3lZnCIPB9pRk1OXU9d+O/ipDn38MIdBVd4umCKn64b9oZA+zg7eXyW35Jpbzh1
	WQQMgmEQUgsE+wzrYobJ2o/pu6DCRbyqpwQYCeIfYpBVn1X+3gAtf+kdtZkcwlU+HOi2kD
	DpRsrISpIYorD8L5hcFMqcBQpMbHPco=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788817378;
	b=LibDhDb901i67K6JM7MnQMls66ikzxd24xeU47BgkkaDcJ4yXfcXgb1lVjHWNc4TxjqEvk
	/+qwWN61W4C/+cOnTegJWuNIqKLte4wNwaaIm4o8T8ae1KdaQ5syeU9Z8ju7ncOTUtbufu
	3rTBYkB86tDAPz7OR2XFwg2iHrThHsk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=asDN0pcU;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1583C601DB;
	Mon,  7 Sep 2026 21:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26331F00A3A;
	Mon,  7 Sep 2026 21:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788817376;
	bh=O3ajM7rRzZOM6WqeLBJOEovDBaOSN37HTunc0pSzZyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=asDN0pcUJqeixbW9qwJ4pDOEFYm5UGI9pIRPC8d5sBq7b8Bs/RHMxQQxTh5MfSyPm
	 nav/N1Oam468mk5mYmVWd31bUW3zoeqbPCiOa5OyFY5cuGbjnxSZzmcqLnuaVwIT/w
	 piofhmeIXbNYytfqNCV1gAfRs7wxr9N2gOjFPp0G6006oG94WFURp3ZaCgySKW/5yd
	 Y7oncOZb93PUxXjRDW6LlJCPUi5u5biyjZdMT1FqmBT4zvrnShofyMbn824cgXxfFV
	 zPZBNIIQ00tuq9a9hdYjcM9C5eILXth/Bb3AXDIxO7ssRULtQ7HIjUeRqrQy1E/lxq
	 x3gwELKMoP1Jg==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	ljs@kernel.org,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 7/8] lib: convert process iterator to for_each_process_rculock
Date: Mon,  7 Sep 2026 14:42:47 -0700
Message-ID: <20260907214248.88838-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-8-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2F4A91C0008
X-Stat-Signature: xzsq3szbb4waqain5pjjc6fmptiroznk
X-HE-Tag: 1788817378-737036
X-HE-Meta: U2FsdGVkX1+hc3Uzvq02645BeY/5h7y1BJWNsL7GwQC6AswbWfzlDu/hdo6ygAT56HEZq0xuw1vmJGS0clt6xvIcT5FdLNOpdPyMZpHcbI9I2fXW1FK+L6pPi+WMpgIkrLy+WUOOvWvWtSLBR3y+B07Vzq5+C4mWW634xluyz4kRTcC26n3sybeIn3OTt3ygL4Cs51+M+ZR7xb5c5DrDde0MmI7VyDbXNLDoeLXF7XxFr2cDxE2i1VowIThIYVylcc8/PS2xgHRskC+YO6adFqTU0X1xnFcnArUz3NtAP6P+OiyVOgjzuQU2cjyMe3EQDCCg33CaeFtRhnIflTJ23kXBS/0DhEXpDSUTC2bTg4W5YDb5Gc4woq4gvpLMpynDugzYahWWqvTYVOUQJlRQGgi9W3k+P2IvSiDigpI/EFdkNXZ46fdty4nMslCcNMwfKKdfDDOaBn4Fwsq7PzLcQgOgW8knkpKo5u01xE8T2PxclJvmtXxeHZZ7rUEP8OSGFZTDVtqVrrzUAAriN0q7jV41J1IBUi6I9zkWbjvV006cVocgCMMT7wpSVC9auw4YDR0iunY3Kr9EwKXLZR4kmz0D/nOtqVeRZ2T7Pu2Ggr1rjiETKaoEbvD5Olny1OOyWqzbObFTU7uijiQaSD5BVeou/xtK+vrji8AaSyK2Tapy1EjacOtm6PVbtfgTzK+zvXEOqsM5FmkIOCq+69GVaE6XfvVMxkR6QnRsUcKA1vxdrrXsXt+eEmc65visFCr1QcvaWDuqVcb59UiL7YYIzZOTmkjDtMfNQFK0pPAAW4psDN23zQDOXxu+HWwE8TStsBrdRtjA+UFpOZfzBRO/Bf8agM+aT5KP1otzYs5T5xyknEWcKHo8ZSPx8SItc9fMwymHhUtno4KnFSss40rUUOag7guj2j5Uh94/BIvrmB0ZNaM2riLF18ptdmNJ2EtM1Loiw9ukO33OV9aFpB3
 E5A76NLT
 MS4LO+h4Rg5JoJxYlEv/qS+BuIULZ6VaPAVbgog8IJmP11La62hrYAacGa/p5f330rtMTPOQFsHDS+4iQKt8KWV+0QHOw3qzHg2yzPAxp4wP7IxcXCdc9F41ZPicTNwGsz1n+0wmD/iENTDUW6hwSv13OGndNboil1ekpDocJijwnv8gtqumxtNZeCpFw+BDYiPXV0UpBXQhCvrhScuPD6Udgs7dA4UtgXWEN7CQmBc+C71jDTNu+F20xzc7l3tfqDe+0eFP7Kuwy2wKhWLxjsWpiQXtvaM69vfeH2OeD9inyZf3LRcbnvs88OM2/GpuRE2g+X17/OG1nt3C67GcDHhF9y400qpWTd9AGubYMnwJTd9ZPWkMyw22kzmHMuiZvgB7Xa/9y8YWeIhYuTRflqejEyqNZIasvngV6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:33 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
> with for_each_process() loop in lib/ with for_each_process_rculock(),
> which scopes the RCU read lock to the loop body via scoped_guard(rcu).
> 
> No functional change.

Looks good and correct to me.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

