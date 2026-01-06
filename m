Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051ADCD042A
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 02:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A9B76B008A; Mon,  5 Jan 2026 21:06:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5355F6B0093; Mon,  5 Jan 2026 21:06:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482A26B0095; Mon,  5 Jan 2026 21:06:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38B2E6B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:06:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7AD21A033C
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:06:43 +0000 (UTC)
X-FDA: 84299900286.28.231497E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46F9018000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:06:42 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CHY+rQUx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767665202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U00dwAGNhGy3U3J3Y1ePgwj4J4Apr64VGJv5fnMQMic=;
	b=28i1n3/uB6PzEPvYm6YNMIzcxbysTi2Jbu6GSjCW1DjhPGP+UmNI0mJLSDCm4gID6VNC3f
	TXunhScT8Su0beV2utKZEnx7lXERfuoYLj4dm/99yJdRewLjoeQhrCbT0xpV5DvMkBWDBU
	c01WepmIhtoEAdPuyPyooHBHzqghZCU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=CHY+rQUx;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767665202; a=rsa-sha256;
	cv=none;
	b=kEobeJN3lTPtusIkzgvrL2Tq+1tH8yY+qcm9YYVkvv1v2yV8/e0bdbdZGBtLb4AeMUUrWW
	V4Z/PcQm67M1rFFg8jAbps4XbbX6VUiFIAZGJztGvKSP+Ix04eHih9OkKSfWnsFo5lKRcX
	dXeEVS3cQUdX5WPc69Tou/oi3Ki8mcw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5835E4396C;
	Tue,  6 Jan 2026 02:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B0DBC116D0;
	Tue,  6 Jan 2026 02:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767665201;
	bh=QEbYplCVttrTtBYcJLlm+VKM8wXQFuG1VSUfXM16bd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CHY+rQUxltiMZhvB3+dF6jriEi0UEq0CJDi81YM7Pdew8aNUkIkpow81t3QhGtZtF
	 FjesyL4jecXI3kHoDPjzfs1fxdjTEIncSnfcEpuFH3qh0Zp05vUJp6f/7ot7Y7wcWh
	 wKmGxHVqpQWXbD4hPrN6iBDCF/c/ESAKAPNiiVnI=
Date: Mon, 5 Jan 2026 18:06:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Ballasi <tballasi@linux.microsoft.com>
Cc: linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 mhiramat@kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH v3 0/2] mm: vmscan: add PID and cgroup ID to vmscan
 tracepoints
Message-Id: <20260105180640.2072c151c9f1f56458cb2dd2@linux-foundation.org>
In-Reply-To: <20260105160423.23708-1-tballasi@linux.microsoft.com>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-1-tballasi@linux.microsoft.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: kocncmh386jqqsjr5xkc5db85d3euk7q
X-Rspam-User: 
X-Rspamd-Queue-Id: 46F9018000E
X-HE-Tag: 1767665202-451274
X-HE-Meta: U2FsdGVkX1+9Wk1FxEE5S53s7uK81OinzuIz66SnkTjY55WeLxZWGiZNpj8Q0/71HuUWPpiLvpd1ICXUFDUq5uuvkJeuQ5ELAWke018vkVhz45nHiF+okHNKiRe929JuiZzLdIlkUyPDD8ZJj3AXhhceMqGQBGlVhVeFinx+1Z7TulFuFC812cl30ZJ8ZM19p0TA83dGpNR5Hkkwon6yqBrxmRoDgwduA2jeXFnVSxTnSalFs45DoqWCt08xg38D2uNl/BQJMZRVLeI17s0mmg23LD6Z91F0PVkEJWtNT/msmtwb4ONauz/VH+QOnSRQwT1Vz6KqTyVWlpgbuiN+iwNdeqSo/Wz88u1ZDMTbR9dvcDHC29a7gLxXcFjwxwyPy7C+NeFO2TVREB6UHLiIkR8dJCdb5EMWyafAYOI2iwy3aRlyFwJVgY6QKl3JfKC7eryjz65eWVaGoSxceKjWUUV73sDH1bYAGrR4ja3YzbhuIJlvCLJSC2Dmqm2XLrR/Snj3TGKTWwLQurFmPBpPQ4HdL3lfjJYqpgAUhQLYFqHrDPPx/5IVwpDA/HV+2VKO6v0OzQMKM4sDSQqIYBDVlKcS60HFePCEBcSHCsbmJ/zjB+oCYqfB0ukqymB5WDKF+mTjirGtEWww90riKaZVc4+TB5OhPivWQo+Jme8BaRtgP7zBncC4bXQblxLGExT+1VCLf1KmuRV7VDWuY4aI+NsELd//hY+bBn5Lr1XtXKysafY1wSOSS27lA7EGgp7WHt90kzIA98Z7ytT57CVvWkWEMOj5WqFLK0sjIOqmocYjuMiW4vuSlheJqRvbsRg/wDtxcrL+MCZsoYfjLzmNc7Bbzdb3jh3wT1P30gNwbepN866+YdlYOmsb8aaeU5wK+M6IbDu5ttkA5ODCRujPoPCjDBOJOBXiJWK98dM4Jbw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  5 Jan 2026 08:04:21 -0800 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:

> Changes in v3:
> - Swapped multiple field entries to prevent a hole in the ring buffer
> - Replaced in_task() with __event_in_irq
> - Replaced mem_cgroup_id(memcg) with cgroup_id(memcg->css.cgroup)
> - Rebased the tree to latest 6.18

x86_64 allmodconfig;


In file included from ./include/trace/define_trace.h:132,
                 from ./include/trace/events/vmscan.h:569,
                 from mm/vmscan.c:73:
./include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_direct_reclaim_begin_template':
./include/trace/events/vmscan.h:140:17: error: implicit declaration of function '__event_in_irq' [-Wimplicit-function-declaration]
  140 | +               __event_in_irq() ? "(in-irq)" : "")
      |                 ^~~~~~~~~~~~~~
./include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
  219 |         trace_event_printf(iter, print);                                \
      |                                  ^~~~~
./include/trace/events/vmscan.h:135:9: note: in expansion of macro 'TP_printk'
  135 |         TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%u %s",
      |         ^~~~~~~~~
make[3]: *** [scripts/Makefile.build:287: mm/vmscan.o] Error 1
make[2]: *** [scripts/Makefile.build:556: mm] Error 2
make[1]: *** [/usr/src/25/Makefile:2054: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2


