Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 392E5C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:36:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E9226B00B4; Mon,  6 Jul 2026 09:36:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14D6A6B00C2; Mon,  6 Jul 2026 09:36:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0169E6B00C5; Mon,  6 Jul 2026 09:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C00266B00B4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:36:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 500FF403D6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:36:50 +0000 (UTC)
X-FDA: 84958452180.09.8165BD1
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8F78240003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:36:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783345008;
	b=6Rs9S12+W+8W9PGZQdFHlPhJ4wqwn/kAHj/reEkZCnGPmIL7Nq7z/0Daw6N+NOZuO08zGU
	tPakLmmt5SN0lBaFuZm1T+T1lONRly5aQQyW2BJVLgjWHeYhd+4KdiYX2YxllMKVgCDjBO
	+sGbgkt3VTvkY3X+X6tNWjpd0HVaKkc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783345008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c2ndOM3kMSsVDy67Fqs0BB257EXA2G+xmIxG//IRASU=;
	b=y6RUgeT5yvoTTmycgISoow1gJCXBZD4K1t9iz6+kNJY9Ni1djqomfFc1bJsfLXJ7BH1wfS
	VR9yRuZ49x1xGlmyQFXwvS3+Iu5ugd6nAsUzbcbQaaWmfQCBy3JfyASV7O1JIjMWWXkAne
	GsfZwmJ7GY/MCTFh6P6YO7IXEZ7UWD8=
Received: from omf12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 54997C228B;
	Mon,  6 Jul 2026 13:36:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf12.hostedemail.com (Postfix) with ESMTPA id 2FEC017;
	Mon,  6 Jul 2026 13:36:43 +0000 (UTC)
Date: Mon, 6 Jul 2026 09:36:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Eugene Mavick <m@mavick.dev>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Gary
 Guo <gary@garyguo.net>, Masami Hiramatsu <mhiramat@kernel.org>, Mathieu
 Desnoyers <mathieu.desnoyers@efficios.com>, Andrew Morton
 <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH 1/4] tracing: add ref_trace_final_put tracepoint
Message-ID: <20260706093643.57c46df3@gandalf.local.home>
In-Reply-To: <20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
	<20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18iOBSd1pnsrPI+vzqJgOb1sapVaUTJDoE=
X-HE-Meta: U2FsdGVkX18T6Lw+/fcbVOH4rtqF7ZifzRFdTKamy0zQqCc6fLRr5ibfZP9wg1GYcku/1WOe9lssZmFPjldoouZRMbWsmB76zw/otz1z60JUzDxmL2DZU4i08KjirFEzfCZiFNoTDgaL4SxKt9Q1m8X6hOQZx1OU/uPuqQeDONqy9NJ7EwrdjmPdcNdsV9mhJueYUEzb5/KQoyrKvLYbOev/FHwtuHJQrf+DT3pYr1a03b4b6P038OVkf/0sNNpXBjJ1lwemilyysDS91do4cvogWTkTYlhzThKAbr2xvrY7D8/JC+fGKHAqQnAcLsC3
X-Rspam-User: 
X-HE-Tag-Orig: 1783345003-529797
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8F78240003
X-Stat-Signature: andbeguc4m75trf83pstuz4ms6oungf4
X-HE-Tag: 1783345008-111350
X-HE-Meta: U2FsdGVkX19A/u83mBd117z18qjFbIMFjBv/4zAH+3zXmX+am5bLradFCZnAT14gxsATo0ELeseesV0yKBwEDH+72ywgMW1gqsSVC3DJAkOTkdc+4cgPaR7b9idhLOkkeid5J4dC7LRg0BCNLcIxHMF6SENCiW0D6GRhvpTgOedm/ZZ7MoyPwlkXCTrKG7visAhJqk4agnEmC5ptuAzVXxPn93LM06/mYBUMz0bNnCk31EIgCz7h/hggt7gCfj7L0VwWtlLmgZDTwHrpkjqQWTIHc78Qr+9WHhKDex1z+rH/HuC/OgGUQRqxRufIGBqp1/aW+sIdlSrAi9U+E9bZBz5oZwJQCk9LdCH1iBjSgqD2Pid+Hbjy/rMDQdiqFyaWaPRMFj4A+NQNUiRFHlkeIHAZyy3skhC6feMKP7TNiz7/4N7I+YD1yLV0RzfuxF7oSF4stPPbdR38JLbl035es730yYwKI0zDfYmxNw12ipVHevASPwiHqVKMEzv++IZV1D+fP0UuM163Z5lC2XKQiXQ7YrieRdZ2W6V6ix7GkoBGPHwzPz1wAK4L3vVdwML4Et4dZpMGEd94QKeOhUWz2HpRw3yKaoXM7VPiRLCf/S2lk1sG/qLVJJXgP3jJX7jDgd003PcJOqQj2jgMSc/RdTYdUZx0znoTzTbrvo9xwuIEFlRNIkZC7JM+LCHLyPQF5H4I3WUqEVhL3RvLW9KixJ8oGCLbVMXAUFR30aorDU2XkmOH+uQaQD82q7evZLpC8WF7kB/nbbIHtQXRh5ML9v4eAQWhIl5nMaKIrojLZAM65CbyoBQIt/lwmb+qKEIEE+CwrwEHeTr5+NblKuFBSemxHgMTs24bYn1C3Zw03av89zliBxP7g5g1GSY/Rm/zLH1R/aDR2cLEFdXjVE+8w8k7sqJfP4wLLVZQjrI3TuybwmRSNTcdEYcp3wVRTaAy9xRs7kSe7GZTdUUrUuA
 tEhaGPlr
 ihiWWkn5eDniFS6w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 05 Jul 2026 07:19:20 +0800
Eugene Mavick <m@mavick.dev> wrote:

> +#ifdef CONFIG_TRACEPOINTS
> +/* Wrapper function implemented in lib/ref_trace.c */
> +extern void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj);
> +
> +#define trace_ref_final_put(obj)						\
> +	do {									\
> +		if (tracepoint_enabled(ref_trace_final_put))			\
> +			do_ref_trace_final_put(_RET_IP_, __func__, obj);	\
> +	} while (0)
> +


Also, you may want to make the macro called do_trace_ref_final_put(), to
show that it is not a tracepoint (which all start with "trace_").

-- Steve

