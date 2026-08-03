Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5618C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823816B007B; Mon,  3 Aug 2026 12:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4DE6B0088; Mon,  3 Aug 2026 12:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C3FD6B0093; Mon,  3 Aug 2026 12:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4834B6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:00:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CD501A0788
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:00:47 +0000 (UTC)
X-FDA: 85060421334.24.5BB5EBE
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 815DD20026
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:00:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=CSEMl0Fv;
	spf=pass (imf03.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785772845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5royt46sB2EApVX7lNdh4bb6KePS6qMXeTl3J2Aw6/A=;
	b=xqZNjJ2WcWLgngoxhapMAuZnXFc2om9fH7d8garnlFJzeCTeDilt0s4AJUxcLQ6KLvj/gU
	FjhJeM9e1nkHwg+lLMj0jyYEJmRh70MipmPXso1P1TPcTEP9Rnj6dyrjRsi1dNWGg6r5Wg
	2WQHczhyH1wkkywadKdhljdNS+XDsSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785772845;
	b=poy39FBFSRJHtvL+ypVRoJOXZd8x87Xyedv62NP3+2/9wKIm/4DCpHt53SP52MFmohobtL
	8GDJFi6vzktYYWO9brN465bEq+tf5obL7w3y8/hpqZvWs+EkjzQ8KRo1tPJTZ2ITlCi8Ew
	tQSZGXSOxf41VfAzG+k0SiNXiRosBs8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=mavick.dev header.s=MBO0001 header.b=CSEMl0Fv;
	spf=pass (imf03.hostedemail.com: domain of m@mavick.dev designates 80.241.56.172 as permitted sender) smtp.mailfrom=m@mavick.dev;
	dmarc=pass (policy=quarantine) header.from=mavick.dev
Received: from smtp1.mailbox.org (smtp1.mailbox.org [10.196.197.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4hDLxQ09bwzMlDb;
	Mon, 03 Aug 2026 18:00:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mavick.dev; s=MBO0001;
	t=1785772842;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5royt46sB2EApVX7lNdh4bb6KePS6qMXeTl3J2Aw6/A=;
	b=CSEMl0FvXjgg5rH2tEQ4H0KlBTTB+pvEiSLP//gNLi4BAHeLvCxiBaWWj9PcwTOy9Pnq8g
	H32SNxwD81JajS7NQ1CB6g3uD+l4tX6Ia0Z1tu6/ynmdVkBBSsYBfmVSVUWKD3+FTfq92w
	19oEutkvJ4fYYyR8OWlwK4yRJR3YBru5+U7OnaD97G8yHhQT5yF1xIwAgBp1ISr2gf/QFZ
	tw3q+/rZ4EjbWb/oFTJjoTvcwUgU0S/AyMo0Y5Rwuc0G34662Z2H+LxzNYIkmOEVEPJeV7
	Q9nog+1Vp7tUCOqMZY2wmhDg/9v2P4rhjVe1BTcGyIiq4s/2Mepp4d1uUJoGfg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 04 Aug 2026 00:00:02 +0800
Message-Id: <DKFFMJZBB5MU.3G8Y73IDRTTC3@mavick.dev>
Cc: "Will Deacon" <will@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Mark
 Rutland" <mark.rutland@arm.com>, "Gary Guo" <gary@garyguo.net>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Dennis Zhou" <dennis@kernel.org>, "Tejun Heo"
 <tj@kernel.org>, "Christoph Lameter" <cl@gentwo.org>,
 <linux-kernel@vger.kernel.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>
Subject: Re: [PATCH v4 0/5] tracing: add ref_trace_final_put tracing
From: "Eugene Mavick" <m@mavick.dev>
To: "Peter Zijlstra" <peterz@infradead.org>, "Eugene Mavick" <m@mavick.dev>
References: <20260801-refcount-final-put-trace-v4-0-2e58678f0ffd@mavick.dev>
 <20260803083750.GA49951@noisy.programming.kicks-ass.net>
In-Reply-To: <20260803083750.GA49951@noisy.programming.kicks-ass.net>
X-Rspamd-Queue-Id: 815DD20026
X-Stat-Signature: wj516a4fynq6d1hdxgc7m8u4zfwqs4sw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785772845-620108
X-HE-Meta: U2FsdGVkX1+sAkfidZePLV+wsp7pgOQLQP+wchKpgJEmfV4nWM72YlW85hQTIL6CWk3UsEXEgo//pTXms76My2G5WlSZ7+6NHFBP3fjlVloHwBm0PzXeXAKe9zDqgJOSFkVEjBNYxB2UTdww+LpMbn4LD/c8nvXkefVn4l1NOINvNqTK0IA6/GnlX5Zeqhnmx2gmOI5qA+qNR+L3wXtROJF+I1aWBisgolED8aJpcn9ksa1vlwDyL47giLZlQNZzsbiah/QOdJiB5X0xPlgeGLR64qLW+4KorY0Gr80HTTNbRMuB7VMOLFvoN0r31WmEW4c5+DEW63YAd1eujrDUDPPvC4Y30lEGIGRaQfHsQYErxMKmS/k6XfJz546c/ZhKGU9BqiB+Uzkm6agmPTvnuJl79tlCioZdeCrQd3xXcVvS/7NJAC/luTJUllAgzRQv3L3CNG9e1lbsCyYKxFcjFPgI57mJi98DpuQcCf//jfHnFprPa8SsfdHuH/tnVYDzUH5Pn8lxtQen3FAmHy+u9YX+6R3t8a+Vpk+ruwHIvHLHsC17jQpqt9RDwRplwb8I3zU4GWImxamj9l+88OEij70+V5tllOX2RhqKr3QpwnWqCzuIk/iwTnAHL5iLSDU0fHBUcL5+ANILqH7aFIUsrf8BkQZlsw/QXlBuZ8npiwYvs9nAMevmVlgE47LZ/T9gVS1hgv7npj0hnWI1XdDJiUQC7NRz1QocZFtGUBmldXv98Blvm02R5QzYK+vvxoDu8IKxyhRPsmxMzt7rcOdPp0pUiXl2NB0a+HognwbuKVIAhWOLlNfWsGiD0zpkU+tTb24MGp0HUyFkpbutOBuBytY6O5dNOb6v7rYDeQarjFKOigI/nwve2UuOvBiHkSJe/7vi6GsoLsZrsvvdHxf7Fvtbmw5EV5o+ifpw1ihxaKl0C7CfCxFwRI3MbPpUPT/l/SkFa4lo8kFKqBMTRpG
 nFqHLpbT
 /2YRMBmWZg6yGnuHYjFv0XF81neNMEcmbc+5/sIwIVx0rXucgJqkuQuXlRZZ1nDzIPE6tV8dkU56ICh8WXC6SgAw9jSJBkpo9cgsEdC9cr23F+K22ytzg5cq5ZKBx1Wu6K2MoweCICLROFyvPRuB0GWeCKYE2fOKsyxWE+vESVRB9bT7iikscWxjWhrSvmbrKzBoZ+cSHdmr0RCAG25ZhlsBhEGV96lJNEU5/oJXw7UbHNJnv28rveH/XRqjtJO3H9TFejDq7kdSDJIQ9JWfUbjjWJnfoLz0E6AFz824EkbAgt8eHTMgLEeh5D1HDD1aSByevcIY7MbmS8JM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 4:37 PM +08, Peter Zijlstra wrote:
> I'm not sure this Changelog is convincing me. To me this just looks like
> more weight / bloat without benefit.
The overhead is negligible; like other TRACE_EVENTS this is an if
statement when disabled.

Knowledge of when an object is considered
end-of-usable-life by the refcount implementation is one of the
first steps in UAF debugging. Alternatives to obtain this
information (GDB, watchpoints, manual instrumentation)
require live analysis.

When debugging from static information of remote origin,
like syzbot, this may not be practical. Live analysis requires bug
reproduction and manual effort.

Bug reproduction, especially in rare timing-sensitive UAFs that
thus require many iterations, may require significant
time/hardware resources.

This tracepoint eliminates significant effort/time cost, and
removes a hardware barrier for a common debugging scenario at a
negligible performance cost.

