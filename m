Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57740106B53F
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93AFE6B0005; Wed, 25 Mar 2026 09:57:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 912FB6B0089; Wed, 25 Mar 2026 09:57:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F9A6B008A; Wed, 25 Mar 2026 09:57:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73DB26B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:57:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 29CD7BB6E1
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:57:20 +0000 (UTC)
X-FDA: 84584737440.01.99B7712
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4BA67140004
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:57:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ttN72k3q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nR03rCeox1WQFtX6asW+4qXpDXlOlPtyI2H1ODatRBY=;
	b=sODzU14sYryM6swwfyMKT4oAU5IfM1LpSfLv+VVhiaxOd26KJs21D1Kc0X/zxvVtOZ7gZk
	OA9TbWTzcK/DvT8ZBEDWaYxYxmzuy98xWj3bStVGDTFiSeSDMWU3cdBGj6xPnjkH5tJZlR
	Gvmr4WJOXqkKcxl3iaz2oCU3QcEol+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447038; a=rsa-sha256;
	cv=none;
	b=n6xLkc01gGbO6sCZB8sy5JP55WPbjp8OdzZyytcXyq4TWZIwFnQfuoygBCGPyRJsBKjL61
	xhNpnMyrqouurR8Dbwjv+vRjuTUg+f50mGx3m6MgbTAHxEeuw9DcJ5SrSUXT6EHVEmxn3L
	ULEnrVIMJ/VV3aUQT1JSExSrupF6D7Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ttN72k3q;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nR03rCeox1WQFtX6asW+4qXpDXlOlPtyI2H1ODatRBY=; b=ttN72k3qRbVy4+xfcMzcCjipIX
	D9UzcHQATgEfHQlr458QEL8AmHNte0GpKytEfgo1wCHBvOKh9X7qAuJmMqFMJQmKARPqhK5klduzN
	njHOfo0MPaY+z3NcMKZ2nnboAfhVqp8bp38+4WEt162/Qj0RCEY0ilrhfXuWGI2tVRrFAvPZrEOsX
	iFLnAAKxS0NiDuf2DPFVmDfRn3XaEigwQL7o6wLGRg8F33uTm9gjexIIsqNyGNyMFYuowxXSPAWKl
	oOkf+xgtIz4rBMJyCpkkt/Mvhl2KJEAQgXojum/LQhOmPl66A9vUko0LnwupD1Ahvjjhv/A+d+oTZ
	8qTBoRsQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5OjM-0000000Fwyc-3yuR;
	Wed, 25 Mar 2026 13:57:09 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 86741300400; Wed, 25 Mar 2026 14:57:07 +0100 (CET)
Date: Wed, 25 Mar 2026 14:57:07 +0100
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
Subject: Re: [PATCH 01/15] sched/isolation: Support dynamic allocation for
 housekeeping masks
Message-ID: <20260325135707.GZ3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-1-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-1-919cca23cadf@gmail.com>
X-Rspamd-Queue-Id: 4BA67140004
X-Stat-Signature: t9z5qfypjx19d1bopfmmfnh8o6chq8mk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774447037-895860
X-HE-Meta: U2FsdGVkX18BIvSQrRnCTgRp0XdX5SXQTRMPoi/aYx4+N1Zs8YdLs5s922k6lx9urJpKmxxYd8lFNjIgMySl6dJFG/oU8j/06LFDxsG/U64xTM0dTh66bsFO0pNxbPzrV0f8f/LncVNYa0cDCXU9zcvTrtzKtzbjYgXdOwx7iNm8wE/SM+aFs17P/rXYKwKwUvnrq/2gJmBSYEw5k0Se2qJJwSxIUWdbWUXBAIV0aPFgrtLxsCpHbJXzoEmlYpW0oVeCi4TId/a6JnjpOpylGDu7WBojBoqzsGDxqaO02/wAFRDYb8VN6w5vMhkN3p+lDv1ussFZZg9tBB6XUq4gtqK34e4reqRnF12zLGMtiGi3az+mjCm4DZuQSh0H63ckDHj3J4eLZUwwBm/gZhRophzL9hVNhsmnDcKmAIPinxBiFPOk4CFDcTQavz5Z1y+dd0YLEThiEVChFnLVc6QwX9MY1uDzdZmPJQN8YLkM4KR7hwcJVmMHVDzaHEbae3Eh2FL4497S2uUzjTJHU8UpDdNvznP9PczljElQ+PB495cmA78KTjhYhCfcQEWzrHMIWEwLTuMr8vyeiW8PQpunSp4NC6W2vZ+C9RU8z+ec8y2LxeYJLvCnEo3vLr0httFecP8g4RlrGQPqbIuu+zS1C23FhYQBl8xas+GQoYghmLaAQzsgg1wYf4SJEc8qFKuk7w53xOZ82ycRTC+zeXvc00oE6a/ikmZGBLQjIMPuLGztSPwuIMHd2AHlCNsLwe3Z0e65esViYNZ5+SpglTrIRmWTZNfpEyVSQS9KdJViNtR5nyFhiCD/lBP2B9ai+bvSImLmOPd8QNWnPJPUEYw/yXvtUQsVNNslqmKNh4rHLL/0y8Tn13eSy4kTOREKJeUO3vZoiWVWADblBKlsABCErOSLGlptWSQJ7lClOENKEseHK6o0xW21YprJrrdkrYIfkYHP/S2LRykE5T/PwjQ
 29bR82pE
 4QmLcicybFdIEF9wz/5w2JBxHIlAAYHkC+qIZbWD1em+gXsGslKFAwkGq948LIBD2aTvaO03oUrgwgHCPqT/B7tmhMzCr59jqk8Ht1WrOxZSNcj46F1nmZ6eycVPTKI4ijIPMWvrAF5bT7G0dv1oWCldC5JgQaAjzFg9g0ARHeHTKzuYMuAVWer3IBAaAzPw9k1iEuhuNXgMDbQMiU0nkHU6E2xRBq8Xt+CE6+6F55s9OUGR2EZK8BMCW51lFasnjGvpDBFVOlKmBtGdK1kPtqResOI39OOyxPTKfkWacNzRN83ypi4EIauhowg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:32PM +0800, Qiliang Yuan wrote:
> The existing housekeeping infrastructure uses a single static cpumask
> for all isolation types. This prevents independent runtime
> reconfiguration of different services (like RCU vs. timers).

I think I asked this a while ago; why do we have more than one mask?
What is the actual purpose of being able to separate RCU from Timers?

