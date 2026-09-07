Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5684AC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 21:21:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49A976B008A; Mon,  7 Sep 2026 17:21:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AE46B008C; Mon,  7 Sep 2026 17:21:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339EA6B0092; Mon,  7 Sep 2026 17:21:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DFD86B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:21:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1084A40306
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:21:07 +0000 (UTC)
X-FDA: 85188236574.13.797242C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7CF0E40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:21:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUQkhQ1k;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788816065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zZDIy90AzlSJ3HlZ3+CMlS3Mw3yleXCGFSv0h6VAF+o=;
	b=yMN4NaN2CFl+m9WZiSVyudFsIo+TQbbcOZUWkTH13K6t3gVyoyf730rtNdpiZ7VJH5mvNP
	uRdvYszTbrwXubo7ee0aytDPmkm8BwtjIqZJLzb8QSnqB0fSpFxXCmfHszIliBvz9t3jKP
	k/vNk82xwEb0k/NjUf10TI4KFmg9HC8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788816065;
	b=j3Zipo1Rbenr5cV8J7R3Gc5AW1Na789i9DYk4elqyf27QWsrKVdIf52SbNSnmaQ8/EpSFv
	Hehxd3zyyQzheS6d3ta12+9e97L+rJd12AfZ4Q4FXEMpXs3jlGIvK1xTAAdBzIBYiyfkUy
	iiUaWkhD+gjk7vtt9b3zR/WYIhTDsaU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OUQkhQ1k;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39B06601DB;
	Mon,  7 Sep 2026 21:21:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 983371F00A3A;
	Mon,  7 Sep 2026 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788816063;
	bh=zZDIy90AzlSJ3HlZ3+CMlS3Mw3yleXCGFSv0h6VAF+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUQkhQ1kaTnohHzsTD/U1pPnsHjT6rvQ3f/w6+onI/QqztgFCl862h/l1jvdiRwGO
	 HIwWitHkFqgczyVPMD14Z+QtwsTHkhMqqUbxZTmikC1VuKKNoy3nLeJiy+uXwLQwAa
	 3DyDfdWZJ9XyTZcRuPQWBYlVsHaY4C1EaxMfbiU/HCmWOu/ESFkhPpzuO5oj4jRwBa
	 igDRSTQq9ByM7IJeQb/Z6uV/dua/ndO2LtrY3DLY6qLqPKTWA3IWuaxix+chZH6P/j
	 2xfJyD0IgfjTwSV8NwnwlgyvrVcA5eYt6cDfWsmzbOKNh51XjwM91R7pkpZu9pwQXM
	 er8pZGGr3aTXg==
From: SJ Park <sj@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: SJ Park <sj@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Marco Elver <elver@google.com>,
	Ye Liu <liuye@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Yi Tao <escape@linux.alibaba.com>,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
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
Subject: Re: [PATCH v2 1/8] sched: introduce for_each_process_rculock and for_each_thread_rculock
Date: Mon,  7 Sep 2026 14:20:53 -0700
Message-ID: <20260907212054.88063-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907081334.1152889-2-ye.liu@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: phkx118x3q5xyu93hd4ngrnr15jndgas
X-Rspamd-Queue-Id: 7CF0E40006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788816065-944678
X-HE-Meta: U2FsdGVkX18omzHT7RN0/9BEhAIeh0bKQIk6IjApYx7se3VHt4T5Jpotmu1vhDI+P8LsIAUi+lkNh6XItrEglm0X4Vs9Amb7EYcvORRWZfSGoQHvYa2Zf+tWVJ5Wyq/HDl5OUj7185XwK5Lp6kPzFPpp1xS+vM8ayHVn5YjbL17VVwgT10YKgZ3LxP4g0D98q8mOVN2fqwLplFUOnQFU1mFV0lHjOBR5Zcb/L8OjpP/uRj1wtsmT/RAJjqFwaA00jZZtdDfEpBfL+sSZwsDHWOhmhaaZnIZeOcUr3bIeAnkMD9nC3ND3cHCK4Dwy5va+XKKGh3Z+CEd2R/q6N5G9d8iyFnufJIm/pDYuShZDQ3gSAGhEOIqFPYGdwNaRge7gEDaC1jrcTYLL9dx5AHS7LQ4JkhSqCJ3IUo3TMop/Hh2MD9zSgHVWAhjCdnS0WKd7ylyPgEuLn9l6Udb6auJm1FhufHYnFubFSoq/4qByt8c8+LsxiIYfKeigmHvowkoM87V2Y6GkEtlouhsful8K6glvR3YTdu8GF+DRbS6OtuGN0S0AUTP+zd2Q3LporTrkklFgEqvyWTWlhL7wkelkvmxGUhdrIaSdIZsOQjlul0Fd4+j6XoC4AB+7yzNDr9NhAlnuQZUbreI7bjh7gVESvZov8ajp/SUlfGEhIi5z4P1/lIfLBtmDYWX3vc8ewrHvGcaiOHf74CbBBO6W5hWlrAz+VDEJwf6YnFgWcK0+t8e+qSoxU5QfTllm3RmKehNICEXk6JgL4Bo7ZOivdTjzOOcHuqWeAL0iEVfzj8MnkjhkYIYAp2V7ogcH5+FTVNm2TxFo6s7JJaFmbFm5z7Wtksa92sc0D2MhXuGv0NBATwLwoZFIvmhIW3bdjVqfrbTh5YqqKV3KjmY9Z6FSp4z6MLelQeSEqZKCPWEfMf/4HSXgT5VGzbFvo4aA9t/cSPs9KbbLCYeQTt80jWGl3LH
 ERSx9CQr
 bnctQHm+TOSSD0Z9frQg+gmIDUx+DfwAMaDTNKh2J6P5EtKpZ0fc+iFIV1wwPq3GKDe69Zfm1SmDiP1nRsye2TkTV/nzlCU0f64Grwob4XYF+gAkBLwqsXsp8wnP+d7XmJrqmsHrF/41VnzbKim802JUTK+BKkvLq5nAyEOjFhZWjw1PkJRpvjjqG3Qgj/4lwE8OvVZeJ2U0njUHxb7k5jbHxVWuZq2lBgF3R0n/T0bg87AiHtOpSOZXFYVrzyyPztI8ZxCZMeCQ3vE977pvAye8axBwMajMu4nN5fuM9O2cwOCTyvAn/pNO1q61MxmXbrzy73hXAJhvgsGgYTKGCTXigvnmtNrt7OD0Wur5HLHrauxZ78OAeob1CFxImhlY1tRtAEBqgg9m7bCsHBuRJPdLaExQZkZZIAGhU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 16:13:27 +0800 Ye Liu <ye.liu@linux.dev> wrote:

> From: Ye Liu <liuye@kylinos.cn>
> 
> Introduce for_each_process_rculock(), for_each_thread_rculock() and
> for_each_process_thread_rculock() macros that acquire the RCU read
> lock before the iteration starts and release it when the loop is left,
> so that the RCU read-side critical section is scoped to the loop body
> instead of an externally managed rcu_read_lock()/rcu_read_unlock()
> pair.

Looks good to me.

> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> Acked-by: Michal Hocko <mhocko@suse.com>

Assuming Lorenzo's indentation change requests are accepted,

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

