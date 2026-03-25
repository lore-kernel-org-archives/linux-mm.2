Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 504AC106B53D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:04:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BABB6B0092; Wed, 25 Mar 2026 10:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 992D26B0093; Wed, 25 Mar 2026 10:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D04E6B0095; Wed, 25 Mar 2026 10:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80F606B0092
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:04:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E424A1B8D8E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:04:42 +0000 (UTC)
X-FDA: 84584756004.17.AF7A98D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id E9A4E160027
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:04:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cYYVo4mP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774447480; a=rsa-sha256;
	cv=none;
	b=L5Dvve+b0fPLUW+nmN5ZlR4TO47gYVOqaMCwLVDReoFU8CnMSJMubSS1zr3usuFv8ftF32
	aQfDRN7ANN6RYrP+A/RkjfRWZXNgR8Pknf9m3UYiCjQHaS7r/GKF7kJ3o0SALeFzs0cTIV
	aZdFedzxYHZ1Nzdya386C2bF1Te9EFc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cYYVo4mP;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf08.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774447480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4hYkSjHXLlG/lE5YtgFwfQzyiouzhk/stE8uZzNUns=;
	b=E1nK8Qi/YzZ8OXGWmJMowligLI4WNQeVePH0Yd8rJL/xj3fArJWsHZzl+6udMFOTwDS7Au
	orBS8ZitVaKnA/URQ1nC7/SmuDAaScQQYfkDv1XNNLY402gASxkdFsegoxVIJBwf6jXmQb
	MTF4lWeY9pxctizl0PSPovJe5x+ewRQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=C4hYkSjHXLlG/lE5YtgFwfQzyiouzhk/stE8uZzNUns=; b=cYYVo4mP2OcLhkLMLgnRlVDiEF
	9AvuTzF5T7Kvd1ShLQUTaSmF+gfsg/5R3+oiXFfJEdEcmB5USWlZa2IwOzaOEqZ1EcxES4esSOJkE
	IiH41k0iX+TIHwPfwscNPXmDtsMWsHF4wkJAhRSuXqpUm1fDr7MHi50UvuMFxjbmDrhuBRgD6b/ZM
	xI6esliOzQmKU5ZwPIGeDpmE2k8jJieIPJ3BQzZTiI32O7JEeLmbGcMc+1oO2szXXZyzPZ6eZufXt
	xkBcRkO+6V7j6qqpejq1FEMh/TSemHA268NiOOrSZpd5+jZzzyvboZMbbnQ9AvGlaPHMupsB0wDM0
	yunp/kXA==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w5OqX-0000000FxZh-16yX;
	Wed, 25 Mar 2026 14:04:33 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id D298D300578; Wed, 25 Mar 2026 15:04:32 +0100 (CET)
Date: Wed, 25 Mar 2026 15:04:32 +0100
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
Subject: Re: [PATCH 13/15] sched/isolation: Implement sysfs interface for
 dynamic housekeeping
Message-ID: <20260325140432.GE3738786@noisy.programming.kicks-ass.net>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
 <20260325-dhei-v12-final-v1-13-919cca23cadf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325-dhei-v12-final-v1-13-919cca23cadf@gmail.com>
X-Stat-Signature: 1cghxf58ferneaodsohag6g13rrwk6ho
X-Rspamd-Queue-Id: E9A4E160027
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774447479-607076
X-HE-Meta: U2FsdGVkX1/+aAwnAmodk4JuupacihjwDugsxBCwTm9ZImB4rvtixEX3bPj5uTfMt/mL1LilqpJCv02aLvwwjkTmsEn5w9E0A4q/Dltwt9nuYpUPNYNhZkgtyqPs946LIkGEdwx6bHbivMz6UYOA97JkGJ8cu9q6jv24QZo6rCCGxw1WhQRrteF0ZfI+3AJN8vkkLO0zz9CIz8azxz6G+4F1150ceaCHEiKqtRO+y9RSkzec3i7n+B7vDCU87iZJllYzOsxsJiGtaoTFn5thSbLw5snD2LDk4Hxb5rpMAXA7zpW1NiLa9Wp/S/4GXhQl9Uk2fQvuykUBgRBWY+p/3qbY5xwoiK2j5sUt7N5MrWvEiHX1eyKfSn+wxUpaWQa+baYa0FnShVODrGTrWcWM1U+az0tUbAKPOXyzP0kZsPlbj0fMCHQqHxoSLiDQ+BzZHm6U5TxSAagA7yzlrGsfvep3LIyCLZa8eCM6bIBsSs91cHVwIjrWFBtRF9QStp26XwnFQJ/NtDhJRiYCzFDiwx9vGMmA2LbmGwly77H8gWtK6/PuYfJ2wXYck2STU+pYK+LXJtAfhcn2jvbtxtewEdQ8QqvOerZB4dI/Jzv27R9PZtLcn3gGX2Q9mQvoOpg3O9PjmwSzMjZSPywuGsjsl2HWvsJz69Glx8jpVwEFiI8sP4Cv8SOFAKHwtLH/epp1D7/0Wu3zJWSGsf2nGBmR1WcoArrNQpNfybEhIATYqiQqTItSSkLmP9inAOEtqXJ/QHG6yp5nGVBhls6iMQtmvpuvMKUan3eajnqml4z5nLjlo4rVinw0frEj1rikTWdQLlwqyHkuw0kbB0SuJuK1qrtm8PB2rFde+6VTGCOsucJFhTeDisS//W8jkP5atSia8Tc2y8v8t1KvamTUZ9zdLR9qkGw7WtDmc5WVb8KbxF/rF6k7tWJKhgiKQWqsHpDUZM/zEHG/EHHmiYDzHKv
 MxJP5XlI
 j7QiFEj/PA3Xbi8yeOXzCAH6ZEWrbrafTAQCiygTd27k6Urx+zOuTWOnIvL9U21IY22Srpzb73aYJ8C1iLzODZcanSN5/UaoEbGxjrrqTSpXj4BoXdf+QUEFu68KykLXApsEtYYWEpffihkVDWyrimn1nlt2mIqxPzmJXHYi5F1xcBZQJIQlMtk6OWw752NJ0KbSCEgFGRxPadM7cReT8TlHgH7QIT0vlQn7W8/fLSCigX7va4WQIfr1IfcejTbvoWWJLnBKI7thfg1uD8ME4HGZZXPLnWQdKHcTiHc5yjwypuxMoiBeGKJkGyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 05:09:44PM +0800, Qiliang Yuan wrote:
> Subsystem housekeeping masks are currently static and can only be set
> via boot-time parameters (isolcpus, nohz_full, etc.). There is no
> userspace interface to reconfigure these boundaries at runtime.
> 
> Implement the DHEI sysfs interface under /sys/kernel/housekeeping.
> 

Why? What was wrong with cpusets?

