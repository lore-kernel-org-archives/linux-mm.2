Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D832ECD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7B86B009D; Wed,  3 Jun 2026 13:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 077856B00BA; Wed,  3 Jun 2026 13:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8D46B00BC; Wed,  3 Jun 2026 13:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D74DA6B009D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:00:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8139C162743
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:00:12 +0000 (UTC)
X-FDA: 84839214264.09.288EAD6
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D0B314000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:00:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780506010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4sLBQ0qVtHGVNtBqDY0zu4lY5V/1X2mWI7hTBTS1blc=;
	b=QjViVoNYCy7Yviyjwm7SgSU2AlVw/aVbTg/6N9DGmgwPNcAbXMWX1YKX7OvTHO7CXinrJT
	rGupqzkKjglRRHCKcXIFx+8nhtr5v2v6FN1hivIqLJoRwV3y2gIeWp1rZmqLbfaA1t3DPY
	PPyLIDbyBuycDro8U1lV7PiVwQgid2M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780506010;
	b=7Q7el/DMddcXhR3ffpIJ52m2o3feU4oIFBNCoUnu1HbJC2Dh5mBO5xA697Yac0EE/fDoD5
	XyA6hYeNv7xX0E1LWCo1OOxrjMphkTUpoSB983IXpOv39IUMicD9N6gh1GGo4SIXqjQn2k
	os7stBSPSV4JXj84DdAgdZDPNvzX9kY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	none
Received: from omf20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D262B1C1AAD;
	Wed,  3 Jun 2026 17:00:08 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf20.hostedemail.com (Postfix) with ESMTPA id C376D20028;
	Wed,  3 Jun 2026 17:00:05 +0000 (UTC)
Date: Wed, 3 Jun 2026 13:00:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>, "Luck, Tony"
 <tony.luck@intel.com>, "akpm@linux-foundation.org"
 <akpm@linux-foundation.org>, "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>, "Lai, Yi1"
 <yi1.lai@intel.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "linux-edac@vger.kernel.org"
 <linux-edac@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
 Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
Message-ID: <20260603130006.7d2c4a62@gandalf.local.home>
In-Reply-To: <0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
	<b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
	<20260603121707.7eccb9fb@gandalf.local.home>
	<20260603161947.GBaiBUI7C8WWPwD84S@fat_crate.local>
	<0c16bf3d-7c6d-4e28-b200-03b7d0ef714a@kernel.org>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19xlonrAeS5YcJm5nHtKlz55w5G3g5ZuEc=
X-HE-Meta: U2FsdGVkX1+gk+gazx2eDsJ3XzzAwEhpCWaX29hVGZ6ozvgJF5ooRvX8OdRQrbwj3Pj+y4Kmjp63iMP+4/bN/rSH4JskNqfI8hywRJ6JCXHNTQ/ksJu53+4ulKQlhzwjnru54A4ZOjrZRjhzYf+FeYNHg9ds3CxPqCg1tqqTexOAgS0fqrCDkzWpTXr1Tdqja3dcKvR715SqbHHDJMQt6F7kHHyR0WNu+KmBpac6WbrAof85DRNVoTU+Bccrh5eR0yRVIKVTQMEZ2IiOJLNpZiVx90MfufblMJwFJboRzphURJMcKP9tWVS8G7KmdMFfHWGFktnMMEvwhnYRyyyom+X3Zp6wRb5H
X-Rspamd-Queue-Id: 8D0B314000D
X-Rspam-User: 
X-HE-Tag-Orig: 1780506005-423012
X-Stat-Signature: 4jfbmuf17sywyyhjxdj6kkzd73mrxhir
X-Rspamd-Server: rspam08
X-HE-Tag: 1780506010-535524
X-HE-Meta: U2FsdGVkX1+i+DUCOHahFgtfLg2l7PUFr8j03erIOvQTvlSA9F9u9+CtjM/r+aY3QxnkLtK7GONkwBq1LSdKavvqopuJcM+cZUBjY0Ff6JPsIJQi2stP59bxHMChPFpHIiPV8oMJcFSuGNRjRk/Eoh8YOr5s7uCjhliCtulc0wq0JCTtaxpjjo9xquANmSVaGIki1mmsevrAUTAbbZK/YGlX3+rsEARBZXsiTU5Oe7DhT8uy4q8OxnM5KL9cYnVXQvgnURh2n4dHZR4vBOzxphfhIZLLcRELHzlRE9BGtNIiJ97mFCr8UEuLFSEip6Go+7fQrOakO3+lZU1YtBrNBQxHfi+7trz+GCyAK7ZmJBwIbuKA+HB7b+rluOtdfKnaYqi6v17Zb6XKKGs6Gjg8vOEXKQROCmhqNQx8S6fWLXohEGCtLDZriFoP7AZ3zV4RSiSD7z5nw4RJDaFvQ/j6wtDknFwQoQ+iY07nsyFW1vpZ18k377ex9roUrn+eMY29ipzH/IJSgj3dnG64XnlyfbnlfhyRAgK8Rrgcv/38GYWv6VpjhYZHKWrRR8VIg5Ekl8FJw2Eb/bi3aDF+XRzSL8OrG6B4RhA66k54mmQl0swwqqtKDTYGo3bW9nxVB8ViiPwLlOQ5sZWUWYpFPlwnhR9Rg0sDJ1XHupK7bxfoKxTQ0dqfIdEfEFSPG/S/Hmc6sB3tQmdn6w1Xh8FaXBWUTEOfo2AWgdjDiKy7VIMOoeyHKD4us7AurWiwTRje/OyJVEgaQy0758j98wd5pbAH4AIjTg/HuMuSoVmnwmB0fFZZ+5E2WBWG4Y7xGFfGdUXb/1gATNXndKh8AZQanaHYCc17x7rlVOp6sCesaX5HSguXXBv9w17rvzUowVbo7jqQQOeEgjXgNEZnl8d4dog9sl0zuL7mh1hgON65OZ/wPcEu6PfBq8bN5uo6EolfXLNOMOnJIxsgkYl9tJRX6ea
 9bi1g+pS
 JDGNBorG9ac5/byE/u68+DJbLtle3EFGiPBe2se8oHYN/eJrGzKUNuU26XeG5+bAqCiCrKMgOE27faFpSORF2gyS468jOfmxRQ5x0SUmuUt3pMkzKHA2yB6DhoapyUUD37rXexCZvxo5KrSUgwLH8Y0hffQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Jun 2026 18:26:24 +0200
"David Hildenbrand (Arm)" <david@kernel.org> wrote:

> Yeah, I was fearing that when I read in [2]:
> 
> 	"It has become clear in the past that this promise extends to
> 	 tracepoints, most notably in 2011 when a tracepoint change broke
> 	 powertop and had to be reverted."

Technically the issue is with trace events and not tracepoints. The
difference is that a trace event is created via the TRACE_EVENT() macro
which defines what is to be collected from the tracepoint and exposes that
information to tracefs which applications can easily see.

A tracepoint is simply the hook in the code that you can attach to. Trace
events create a callback from that hook to extract the data from the
tracepoint to fill in the fields.

> 
> Which means that I now also fully understand
> 
> 	"Some kernel maintainers prohibit or severely restrict the addition of
> 	 tracepoints to their subsystems out of fear that a similar thing could
> 	 happen to them. "
> 
> Whatever the result of this discussion will be, I'll try to document it.

You can still create a tracepoint without creating a trace event by using
the DECLARE_TRACE() macro. The scheduler subsystem uses that quite
extensively. That creates a tracepoint without exposing it to tracefs. The
runtime verifier uses these hooks to monitor the scheduler.

But you can still connect to these tracepoints from tracefs via a tprobe. A
tprobe hooks to tracepoints that you need the source code to find (just
like a fprobe hooks to any function). Thus applications *can't* rely on
them because there's nothing there to tell you it exists or not.

For example, for the given tracepoint:

 # cd /sys/kernel/tracing
 # echo 't:rfail memory_failure_event pfn=pfn type=type result=result' > dynamic_events
 # cat events/tracepoints/rfail/format 
name: rfail
ID: 1894
format:
	field:unsigned short common_type;	offset:0;	size:2;	signed:0;
	field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
	field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
	field:int common_pid;	offset:4;	size:4;	signed:1;

	field:unsigned long __probe_ip;	offset:8;	size:8;	signed:0;
	field:u64 pfn;	offset:16;	size:8;	signed:0;
	field:s32 type;	offset:24;	size:4;	signed:1;
	field:s32 result;	offset:28;	size:4;	signed:1;

print fmt: "(%lx) pfn=%Lu type=%d result=%d", REC->__probe_ip, REC->pfn, REC->type, REC->result

It requires that BTF exists and the above doesn't annotate the result as
nicely. But you can get data directly from tracepoints this way.

-- Steve

