Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B342109C02F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 16:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDB556B0005; Wed, 25 Mar 2026 12:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3076B0089; Wed, 25 Mar 2026 12:02:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFF36B008A; Wed, 25 Mar 2026 12:02:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABC476B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 12:02:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1B1ECC1DF4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:02:55 +0000 (UTC)
X-FDA: 84585053910.30.6663E3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 494EA100014
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 16:02:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVFbM5u4;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774454573; a=rsa-sha256;
	cv=none;
	b=0B73Gkn/GCJqpqyIZ5awTk03aLFPzW2kHOIF+7Wr1JtYlcNWfMW+fUOfgpp0a6deWmwxJQ
	9DShpvdXmaDDCL7lAqP1ntSAeQtTyi4iJsyKfkk+QyvTfXwz6qghFe/SK9LxqBU7lwFdZE
	XOl9SdPZXsEfkROfQn4JABV1Yb1fC0w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774454573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqQt+GzM/DRaB8zZaqOuCpXtzjD+exs+ugOTqW32/pI=;
	b=ECFS2HMPIUn/wJyki6oJXvCLZ/g11m9vsMz9lsjzrTOJffHcRfw1rwd/9qiWblP0eh0s3b
	Fq5S+6t8A0xFsuFrOrN/to75BikhHE91yQujF+SbXtbgqTaY6QDSsinA416bGPKONlinLh
	lpghla4lJxZh9LXzq8iHT4YD8pZXmBk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qVFbM5u4;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 59D9C40BC4;
	Wed, 25 Mar 2026 16:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0988EC4CEF7;
	Wed, 25 Mar 2026 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774454572;
	bh=GITsNDMkclAIBjNKnyGg5xvX4405o6x9Qefz9+3Snn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qVFbM5u4OPn3HWPHYzho/hMZVIujEIkAyumg4ZmiBJU0EhVMhrHCltUKyfhNnKJOI
	 ZSx0apo6vy9FR+LCxy6+rF0rhDdKj3ADfENvRcV0lo2jiAZuCKcXK7YU7zPlUUHqz+
	 5J5paHJWH18ceQt+JTFhiLeMKpVHDynyVjE6eM3htcixlLso2yzwaYG8ULhyIv1Fl4
	 o75FuDAHxjm7gxDciwhVAxthJH+7yRxbQsoVMsx8OVCDhnkezBr09vVM2zu3Zdi433
	 Lx3YielnCJXfE2/bPY0vbMeu9vz360kPaJkO1S0aIV8Y8/XdPhTZ2sN9Y4FkyxIA1J
	 NRO6w/7tUFc3g==
Date: Wed, 25 Mar 2026 06:02:51 -1000
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 00/15] Implementation of Dynamic Housekeeping & Enhanced
 Isolation (DHEI)
Message-ID: <acQHKwGhYrpoOH1P@slm.duckdns.org>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 494EA100014
X-Stat-Signature: pojd6sh8grsramo61ahknrmc9dtg9er9
X-HE-Tag: 1774454573-745711
X-HE-Meta: U2FsdGVkX195iGWUxgbBL+oXIGu8GN/Vb7P94xcBXHnlMkYQYr60MU2g2SCH1C4yJRIpQC2vj9B0vfRFZPu8M98QemB2gUF1jcJbOudPW/bSEEJ8AkmFKGYG+MJkt+jTMLOmzF3q1u3hOe6GlqcSMjrAZl4zjPAkfT6wDgipBlgxR4gxVorQsbXRj1dDSuiAIlRtJPr5QQTauBdJI5cgK9T+SbpTII5M2ff0XTyIfhzSh8xswqteWa1QMxYGoom9A9O19oe6Qnyo22umEFsRY6Jd3qMu970qj/jlHuAGqAg2XvtmSTF6E5Q8BgWn/cav6AUF3FcK0O5fqONpZqaBL9ntQxTCvnAMq2puDdGLu6cHhKrRcBP+g75C144qapPO+sPTnMsftWmF/qNxqixhKqiMbRfOsOZP1bDQMiJbiyCcY2rw92MUx/P8n1dUo9qqu676dfs/dnJkyKPG2Tlw7FI7+p0bgAhbWO4s6mEDWVr8GZw4eGgcPNfPTZ4c//bwyr/BKqEzXNV6VDKa/rnovYVt4l9Pn4oq/GtLijGUozIOS/0wArD5fnn8sO5xep/Ish6vL7S72PMCWiqdTGB3mlunY3uJM3pmgiSM+FaUIIRmCPlSLE0tQPMV9tSPXMM/kK3abrdTfrbUkR60mWis9tSieYtCSTHx5tWXOFcOjsLJtABQSLSO6orIxF2rxnK5R199wPofoxQGiJi6miRkzmFxnFA3mCJHXUo1RL/VMw1dOoiXY19N/8h2UNhTADsjRT3Gl1kuKSpUY80X8y/LDgGtAKuZjc1xOfO+eU2FYS3OhqvziOkXwg6+IB562q04fV+mCsCGUJtmc90kKOkyPWMmC1K7RKJ2621mo7Ksm6PwoAWa/lQQ3FAGFdbND4oggHa8sIDCgDjdgAlRxSJeFRLBAIozX1AlET18JEr7EkRl7YN8ZLZOM0jv6unJDf/lw6Lp62oDuA7zTyjfhln
 ukyglPcj
 BK9T7NqJ183Awwlar5IendMw0UIVtJnWYbjs70SgmxeNz+C+T2vkbuBIn/LoWV2Hfw9pUQv1mPYPQ0FgUXLcN/KvHeF0rH9yb3mQK4/4wkmQE+O3wNrPDonpk1Q4ViWxQ5rx+PUxPghDSGb16OQc9TP9mQBuzkSLjduclyT4oV37NOi/Xvd+IqNEknir0cpS08y6F+CkjxOoLZFftg2w3caTVFyCSNLIR3KlXl/alg/lPUqR7xjM5XyjGn6TfS7W7+q342qfhAV5rRB7fHLeoUYxvLyMWrkDNVX41
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:31PM +0800, Qiliang Yuan wrote:
> The Linux kernel provides mechanisms like 'isolcpus' and 'nohz_full' to
> reduce interference for latency-sensitive workloads. However, these are
> locked behind the "Reboot Wall" - they can only be configured via boot
> parameters and require a system restart for changes to take effect.
> 
> In modern cloud-native environments, CPU resources often need to be
> dynamically re-partitioned to accommodate container scaling without
> the performance penalty and downtime of a full system reboot. Similarly,
> high-frequency trading (HFT) platforms require the ability to fine-tune
> CPU isolation at runtime to minimize jitter for critical execution threads
> based on shifting market demands.
> 
> This patch series introduces Dynamic Housekeeping & Enhanced Isolation
> (DHEI). DHEI allows administrators to reconfigure the kernel's
> housekeeping boundaries at runtime via a new sysfs interface at
> /sys/kernel/housekeeping/.

I think I asked for this in the previous thread but please coordinate with
existing cpuset and isolation mechanisms. You aren't even cc'ing Waiman for
cpuset.

Thanks.

-- 
tejun

