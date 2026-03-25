Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC4D106B53D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0DC6B008C; Wed, 25 Mar 2026 10:01:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287F96B0092; Wed, 25 Mar 2026 10:01:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E216B0093; Wed, 25 Mar 2026 10:01:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084E56B008C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:01:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 921BBC2F73
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:01:02 +0000 (UTC)
X-FDA: 84584746764.01.6DC3379
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id ED9B4A0030
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:00:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uVreSsST;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NF/Fzmt3riyXynsc3GneO0T3XfJ1kmXmj8mDb9HEBzU=;
	b=6MjkZ5LmIh/vaa2qth/O/xR227qtbsp/7QjKnQd62Q99yn6FIAemEi381mjqRNsVH3nQz6
	0rCHh34uOfFdb8YTshjo1/YKqIzZka5eB6YgthDy/0U47OJXnwECh1kMIz7eqWIoyQ61BC
	SIC6lalnnjptciSu5sZ03P5r2MK9NIc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447260; a=rsa-sha256;
	cv=none;
	b=PfSOzx1NBIiNdn/7q+I2XoUZgKxnKI/iFhiKSu6TLJdtIOALMlKkpkRZmu13XT/FDC1cCW
	yzGTs8cv2xPx1zDXDiGyuqy6RKoNLnVduYjWMc+hjCn6N0fw+M21TmrOClygxfEM1zPJQl
	2apCNl1VbxNVv4ARUmiDvICeGzJNne8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=uVreSsST;
	spf=none (imf15.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NF/Fzmt3riyXynsc3GneO0T3XfJ1kmXmj8mDb9HEBzU=; b=uVreSsSTreEtJDOHcz9Zf36/0N
	Xeix1I/f118jkE4t4TN5lnwgOh1w9sp4ljJaeMD5e28uwk+8vGXr434dzkoUleWhb6NYyd1s9+I3u
	dYcpBveNuxRndLYDiv0TgPF/BN89+D6D5s/9W47W5zmalTuUWQS5bb8ypgExMqTy6Z+c0VVeZ0eUF
	BaFltWHK13Z/Iq+EDHsw+XkxOZ0PgqVbBbesavc1BajFsY19yoZx98GdcSvvCT8FCYe7bDOTAJZWl
	yVLWStNjSSBNhC/OQfoP/wLOg0SHShYs6EJyoKeAIhnvijTJFmTgdo7ODwoc61YDZIb2ksi8/Qph8
	TOy8dDJQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5On0-0000000FxLE-03fj;
	Wed, 25 Mar 2026 14:00:54 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 2AE03300400; Wed, 25 Mar 2026 15:00:53 +0100 (CET)
Date: Wed, 25 Mar 2026 15:00:53 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
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
	Zqiang <qiang.zhang@linux.dev>, Tejun Heo <tj@kernel.org>,
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
Subject: Re: [PATCH 06/15] sched/core: Dynamically update scheduler domain
 housekeeping mask
Message-ID: <20260325140053.GC3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-6-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-6-919cca23cadf@gmail.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: hn7ze3r4xn78rrnb56pmzaxgqmwd4b51
X-Rspamd-Queue-Id: ED9B4A0030
X-Rspam-User: 
X-HE-Tag: 1774447259-134437
X-HE-Meta: U2FsdGVkX1+WXoDGD/IZY3azgQoWGVmqEvSkzjy67NdkKzYmaZkbi2j+S9UFJ2A+ZfEx3rcZM1z6vLMhjnF2Rfvvg1EUI872688rErYj5QFqgQ20u4x/UDQdFrDSDCjUe1gFzlWp/zn+9K6r0YMo2U39jefpW65yuJlkrr6p6zYBJv9hZ29A5EEBaRBLwUTR0bCekOxU4DuPG2ZR++f0lM3SOJvR1q8ao5bx4Tdxq3BhEtXLokj9cqBtknXu/YYwBKVsm9iKb9jrC618QuhUUzI9FdwYnYIZGQKBLKcIV2TBaC3QX0dSn+u9Kl7iOiwAWHa94LJhk+LiMZfn/qEvF6htRsgjbo6qk8kKJr6p3zYN9hHbmf/tE9vXh0FwhlAK5WmnnJ0oY2rtFChOWfDO3Eg3vqvGSnfnLELeFrSZPdaUOtxgOjlUFtFm+wW87wO2/XHhdWe39b17SSkKnvPVKnIBiotSR//7i/CNSBCQF4vawfyrmmy5K8KDnBdeTL+M4ZQxaA90EsJ8s/aFM8HWbXlnwSIwdFpYShGR7WMmEoMJMZkMx5PVE6IDJTTgC+jN7ehfnCt1at/TF3EC2KenaDrhbKYbgFawgL88c61bhHcHoHzAT1+/sWcPaEj3A+QKKFKnjLL0eoik8UzuTYM9LechEzpEmXRl5SrmxMKH+YQevhKN9R2lG3Cl31fMZ+ZV0bfz1Pahc4tISsqgzvL7NpqKaimt1Dd3r2LFPBcfbI2GVSzyQebuF4176bmWML46ra6iEPS3sAmWJoE0Xlh4DhjNKZ4w5BDfsxLY/ongyqsXMsN2q8lXbxdS1kX6peoMg823+sQ65uzZ1sj/mggaYAJnSg5i9KRSj3puz783q6K0NY0Cm/wmPEsOuNywI39B98+lFWgV1T04NBvLIEmkt2xn/wfdGbUS4H8TX2NuTT27WskgHrfluCA2xnsVWpwhxctOd4rW4JY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:37PM +0800, Qiliang Yuan wrote:
> Scheduler domains rely on HK_TYPE_DOMAIN to identify which CPUs are
> isolated from general load balancing. Currently, these boundaries are
> static and determined only during boot-time domain initialization.

This statement is factually incorrect. You can dynamically create
partitions with both cpuset-v1 and cpuset-v2.

