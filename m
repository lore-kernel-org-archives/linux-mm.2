Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C7CCD042C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 02:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A6716B008A; Mon,  5 Jan 2026 21:21:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154096B0093; Mon,  5 Jan 2026 21:21:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080E16B0095; Mon,  5 Jan 2026 21:21:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ECCD46B008A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 21:21:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 930BC160338
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:21:38 +0000 (UTC)
X-FDA: 84299937876.18.2F7136D
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9DFA180005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 02:21:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767666096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kXf1oTaolF7BpGN2mL0zZE+L/UHbi/hjC+XSjhVDCEc=;
	b=28agThVT32byy7Mv2mW3YAKDkLks0z9T35Jn7leRlXh6LbRPeasuF6SseB+cRS6lIXQAFj
	OZfi0R3nuvQj5HCUVLpvFa4/q5Ko7T8GAV0UurpAN8np+8cFTIMR0V3WURd1+mfWfJegS9
	0fP8YWrb9BCnQa5CXOa89M60RKMF+3w=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767666096; a=rsa-sha256;
	cv=none;
	b=nJchW7lGnbKP2wQ+InYqnLnDWXFq1v2sUylt+uEcSpllhifZaGI6Sw5sis7WujfBPTCyCY
	mQx945gQIEgMhHcxJoDEBIjSsCgyZyvcNdDnxngya/hN3PEMFFaRoP/9SEznxMJw2E5ZVB
	mGrdikPgZnXzAdhoGk40iFeNr6+W2tM=
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 329EEC1879;
	Tue,  6 Jan 2026 02:21:36 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf14.hostedemail.com (Postfix) with ESMTPA id 6939830;
	Tue,  6 Jan 2026 02:21:34 +0000 (UTC)
Date: Mon, 5 Jan 2026 21:21:57 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Ballasi <tballasi@linux.microsoft.com>, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, mhiramat@kernel.org
Subject: Re: [PATCH v3 0/2] mm: vmscan: add PID and cgroup ID to vmscan
 tracepoints
Message-ID: <20260105212157.503db606@gandalf.local.home>
In-Reply-To: <20260105180640.2072c151c9f1f56458cb2dd2@linux-foundation.org>
References: <20251216140252.11864-1-tballasi@linux.microsoft.com>
	<20260105160423.23708-1-tballasi@linux.microsoft.com>
	<20260105180640.2072c151c9f1f56458cb2dd2@linux-foundation.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/Ras5liyNeNz5fAhJE8zcGxrgBhR/tU1Y=
X-HE-Meta: U2FsdGVkX19LJ3kgQO6B3sHlGOz1ndXlzIrbk28EcFCTzPW8dESrGl1l7tnYBNlXRKMILkXGAhR2hscB+zmT+O7D8yyVVaJlOOdr76FF3H8Y1ChSJEsEogYVE+44mdpz5Byk8MeefL/ygMmQVB+1GjKJxg+yudF1q4zSs5Zt/sc4sMCBHVpeAVRid+6TqPfzLZ1CEFN/xLeu3wgsbAk2ekwSA4YkeUD8rN3Q2MIMZrSgHUA1swNiFQ6kg8cVs4VTnoMPfracbND0M/r8x3BQInCjgyvMxuIB59OWy4KsbTlaOlIKe+5GhrM6Gd6dkljuQ7HihROblc+VXAvvrZg/wMMM99qy7ZPGCdIp9VzgLmWcyG6gQU4wafLNoT6KxF/rvncM7GLPnIZzTKzgc8sC0H5jUqieDWO9oWi1FcE07Ss=
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9DFA180005
X-Stat-Signature: a6jckkp7odd3h8kkgnary3opzd6shgtg
X-HE-Tag-Orig: 1767666094-528518
X-HE-Tag: 1767666096-611137
X-HE-Meta: U2FsdGVkX193iPclJHeK4VrRgXGHD8knEgJdvpes3eQDQENb3R64GdzpUPOAoGrCFtJwIAFR849/VtSexDmU8qy3/q7/i16PAw6dlYZC+V3H56bdhlolPqg6m/m7VcQMhqGtbraIQd1b5pBzwn2D9iAAMjA/KuwAEeKHyW9pA9Sw2lBtCR+cz/vXDivs3tbcXat+S7xUvO/BB0oM7D+6B87H5VemwpBDh8I34cqOl8BbW31+XA6UdEKPPHkbPLE+Rpn5C/18/+BrGEAL/31XYdgVENsn6RqG4DojFwpyrUAaS67yfATiCUfE4W2ljE5AwRDdbIjSdFwHLDjgTkFiexQl/OTdKfptK7SPO+BG2GXoBHyBBCRGv0C+j5oqEZLkwAMIx+zKYKL/BCfCbMvpsBG4LIrtiYpUwU2h3J7Qk5EShCds0eyIolz2s/eOBk1PGo+QvWLI8MkmeJh4nZ5m5eeZLrCa+qwoZ5j4RhsbvFnkPsdNS1nZSsu3kv3KJjbbH2tGKtbQ61uF1SNidb1/OlNrHmNtl5oBi/rYHrAABi9nOa8SxcosfneW40R7ISvORkfUpV5kZRD3KaEHTLmzLYzwAPTFfn6X2O3BcQKD9x5iDwePGycFQZt4gJbdGGfvYUWldfjFfq/76bM+GzhCPhXhUuwiboHWggh2kDp6VpI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 5 Jan 2026 18:06:40 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon,  5 Jan 2026 08:04:21 -0800 Thomas Ballasi <tballasi@linux.microsoft.com> wrote:
> 
> > Changes in v3:
> > - Swapped multiple field entries to prevent a hole in the ring buffer
> > - Replaced in_task() with __event_in_irq
> > - Replaced mem_cgroup_id(memcg) with cgroup_id(memcg->css.cgroup)
> > - Rebased the tree to latest 6.18  
> 
> x86_64 allmodconfig;
> 
> 
> In file included from ./include/trace/define_trace.h:132,
>                  from ./include/trace/events/vmscan.h:569,
>                  from mm/vmscan.c:73:
> ./include/trace/events/vmscan.h: In function 'trace_raw_output_mm_vmscan_direct_reclaim_begin_template':
> ./include/trace/events/vmscan.h:140:17: error: implicit declaration of function '__event_in_irq' [-Wimplicit-function-declaration]
>   140 | +               __event_in_irq() ? "(in-irq)" : "")
>       |                 ^~~~~~~~~~~~~~
> ./include/trace/trace_events.h:219:34: note: in definition of macro 'DECLARE_EVENT_CLASS'
>   219 |         trace_event_printf(iter, print);                                \
>       |                                  ^~~~~
> ./include/trace/events/vmscan.h:135:9: note: in expansion of macro 'TP_printk'
>   135 |         TP_printk("order=%d gfp_flags=%s pid=%d memcg_id=%u %s",
>       |         ^~~~~~~~~
> make[3]: *** [scripts/Makefile.build:287: mm/vmscan.o] Error 1
> make[2]: *** [scripts/Makefile.build:556: mm] Error 2
> make[1]: *** [/usr/src/25/Makefile:2054: .] Error 2
> make: *** [Makefile:248: __sub-make] Error 2

This is dependent on my patch:

  https://lore.kernel.org/all/20251229163515.3d1b0bba@gandalf.local.home/

Where I said you can take this patch. But I don't see it as part of the
series.

  https://lore.kernel.org/all/20251229163634.5aad205d@gandalf.local.home/

-- Steve


