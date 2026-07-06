Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF1AC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:34:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280066B009E; Mon,  6 Jul 2026 09:33:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25CE06B00A2; Mon,  6 Jul 2026 09:33:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BCEC6B00A4; Mon,  6 Jul 2026 09:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0C3F6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:33:58 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D671C221D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:33:58 +0000 (UTC)
X-FDA: 84958444956.18.AE8FCE5
Received: from relay.hostedemail.com (unirelay05 [10.200.18.68])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8A2FC8000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:33:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783344836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jbzpa0JLExNRKhSqIi7fbV0IBtHeu1HXD7oJs43Cgrs=;
	b=8BWXQ60erZa96NCInb1UOGuLgu5d0xh9coP8ZspNYXIEnD9skncQgUBnFBCEsKOUQlWnlL
	Yj0FDyjUJOullmpWgsm4XHa6f1qc9Wpg4fFXa8a8mLpkDG+rZAAFW3S+65qvdkgOsmDsdo
	+idOMNUU90f2ywSt4r0RR/W34ETnRjk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783344836;
	b=k8r74ZLc2yTkollbuU0lw0ZnqbydCiWKW3XsA+PB1UsCsF5Kaaum+BkQhm2eAD+AWbxWjI
	Hkxs9eoN8ZO6v2JS3NZ+ImNfy9CfM9W2ao+ZQeabsTpdzsXzud6paDyBfxzc0JKMuHDSqh
	CCrgQXKhbTPJRdqQoUc95MPi+ADCNkQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	none
Received: from omf03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D89C340306;
	Mon,  6 Jul 2026 13:33:54 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf03.hostedemail.com (Postfix) with ESMTPA id AE0AC6000B;
	Mon,  6 Jul 2026 13:33:51 +0000 (UTC)
Date: Mon, 6 Jul 2026 09:33:52 -0400
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
Message-ID: <20260706093352.02bd08c0@gandalf.local.home>
In-Reply-To: <20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev>
References: <20260705-refcount-final-put-trace-v1-0-cdd0014626a9@mavick.dev>
	<20260705-refcount-final-put-trace-v1-1-cdd0014626a9@mavick.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1/NhqJtYjnkM7IHOrlFdiTHVk2lDmEUh20=
X-HE-Meta: U2FsdGVkX1+2clslqU1OwznXkTDevv7qXlbJtfY4KlGfdEb7QptnmTpeFWuCHtOPBTrStmj0VnGLcxq1pK+heA/i94/tcxiFMu00LCktHex6zrsBHlFBafommHpHadV4wQ8DNvl1SQyH4HXp8XRxjf1bPsMtE37aP73hbCUJVoUumi7MjSkv78bR1fWm7y84AwhZNCeBm5U31Zv4rjO6YMIGjMDgmcL2z6vBgbUYf4a6wiNF0PvvfCbUS70CvYxneatoS9T1TUucGwm3XMH4qzWXTyAp1dHzrj8/qTwQQt4+Zpqc2ehb9Kg5PodJ5FHR
X-Rspam-User: 
X-HE-Tag-Orig: 1783344831-930887
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A2FC8000B
X-Stat-Signature: 5erqpubq9jsuajceo78ixh69y1iipa7u
X-HE-Tag: 1783344836-734050
X-HE-Meta: U2FsdGVkX182RjZXj4FP2EwKiWzhcCKYEjqk9t52PvwvYqy3hA42EXy+jIehhCs5DVmtohs9x+Ck2RolLRScc7zXk5tKl/tbAW8dxYSHiiJlou+PxoJHQqTtSXrp7tl6g0AcgYsyQzg2Q0VRcTkUImtT+/P4zDOwDb+O0dK3ZQQLmn/QqC1rB/K80ZnGP2ZgKrEfk6vnlo7XBwwIrADQc0qf0kLMD6o5QHFe1Vu87cCNg7jPReiEE8VKtLsIPevRcrB5B0nXgDlcmN75Gs+VYk3sEO52k10jeggr+f+f1jyLP58FKhwDCQpN1HnlYkjpUc1avUO25zmm6Sl3GmasI58kaaPOxcGmXoQqz6C2tdEWPykhUsw8j9CUAdQYQzzTqhrLeXkVpo5WvNCGJhhEiATrZDWjKdRbYgxz7/UZ/OZulWPJjA0TXGhcQmKstjHntlOv9fmrP6UbmDIPp5qeIZmcOXbpivoh+GL02xmTEymmFS9IX5TODk9GCdy2PfuLVwL/TzDb3EFCT+/FocGJxDjCZ+WA+dHEPEED5QK0v7/ivjFJgkqSdYx18rO9UXrp2p4OZqbgHfOYm9giLYFbUhr42wDK1jr2MdEWbN9TddRqUo131YwdN0nNnjORfuEVgGVCOwFocc2eD7vZ5EIg7dX3MCrpEbP8zZoDSq7Suvwz1DMy/y6WyZdfSJoDz5B9EsoSTtdd0PWT/Ym3BobPTXASRLvnpYtDAcu9G3g2K4A2ZRXvrALJXxMt4wCfOk7/K4X+471nX7lhEaxdNRcc9fXHRCgKkgZEg4fnVRoahwPUnG2duJ0B+lb89WnVvcCRPLVyOaJmlbHmuj8qvV0acl2Oks6QlsBcdfD3DIn2jxrovVC8qpeURHUpeNq9zDu9izlC0sfgmQmPq+gl2le4H5rH0Ycgus9oYoORCFhWYTgnPtiLR8OyhOWq+zCyL95jEhb0qs7hPAfeLFeeDNV
 I8LKm9oR
 zX+rpLwVQS4do4JM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 05 Jul 2026 07:19:20 +0800
Eugene Mavick <m@mavick.dev> wrote:

> +++ b/lib/ref_trace.c
> @@ -0,0 +1,12 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/ref_trace.h>
> +
> +//Wrapper function for functions defined entirely in header files
> +void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj)
> +{
> +	trace_ref_trace_final_put(caller, fn, obj);
> +}
> +EXPORT_SYMBOL_GPL(do_ref_trace_final_put);

Since this is only called when ref_trace_final_put tracepoint is enabled,
you can use the direct call that doesn't use the static_branch(). The above
should be:


//Wrapper function for functions defined entirely in header files
void do_ref_trace_final_put(unsigned long caller, const char *fn, const void *obj)
{
	trace_call__ref_trace_final_put(caller, fn, obj);
}


-- Steve

