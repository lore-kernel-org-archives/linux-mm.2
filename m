Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746471090223
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 13:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5F6B6B04BF; Thu, 19 Mar 2026 09:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2016B04C0; Thu, 19 Mar 2026 09:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9226B04C1; Thu, 19 Mar 2026 09:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8287A6B04BF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:23:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 35830596D5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:23:04 +0000 (UTC)
X-FDA: 84562878288.12.AED05EB
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id 409D64000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:23:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HpFQYugY;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773926582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K4DZV9IVShl8r7RMOIfqrE8nnZaCpbJPb3iBWGHhKxs=;
	b=3WTVr1/MQXnLfjvLP85s+o0driKQfCy5jbOaOe+m87VEgaIy36ZA+QPhIo5EXeDnE2lW/c
	bGj3dcGW7pQA3m+PST+01vPRtK+eDMuFNwZhktAl0TDm1trb6ZG/J62grSpY5KOZefkhaT
	YY7lEGADPCAVUBh37hZvEiAr8+LFPbQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773926582; a=rsa-sha256;
	cv=none;
	b=jMzdLVFH8gwXFsIrfOJTG5ZV8Ly+AS2fEDkWdBG/BvFKd06rn5i5rIg3Nf2dbpmF+mdWks
	V+rKg50wMtSP+lPfOsvuJPO9mp/ByoV2FiMI4WlI3vQ+GYMQdlUlyvn3mZpuaH5ZDFtBVk
	ospWvBHtH2wfprr9cEL9OJHfX3JCYgo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=HpFQYugY;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 4E696B3EE9;
	Thu, 19 Mar 2026 13:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773926580;
	bh=K4DZV9IVShl8r7RMOIfqrE8nnZaCpbJPb3iBWGHhKxs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HpFQYugYCTJcnISd+X4JDGbt1qSBzoGcxkdqKiUjCX728Ajeiv33Df4mGq9q4Q5f9
	 7WuQZjHWCs5IcBhRWQzo6ooZnxaeZTNblIfc7apr0Kyl/DrZFEq7rUj5jbZOqbrlzc
	 RhVXIc0P18ah0acLymFdT9WCT3eHC6BKPU8u45gk=
Date: Thu, 19 Mar 2026 13:22:54 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Shakeel Butt <shakeel.butt@linux.dev>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH v4 0/5] mm: zone lock tracepoint instrumentation
Message-ID: <abv4riGLlubast8v@shell.ilvokhin.com>
References: <cover.1772206930.git.d@ilvokhin.com>
 <aa7G1nD7Rd9F4eBH@casper.infradead.org>
 <aa7XdpIVtLFS3FIu@shell.ilvokhin.com>
 <aa7dgQDMEz34eadj@casper.infradead.org>
 <20260309151317.7bba06dd@gandalf.local.home>
 <aa8xawMxLeUjkyHx@casper.infradead.org>
 <20260309171700.063318b5@gandalf.local.home>
 <abhAoF5EpiPigsx7@shell.ilvokhin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abhAoF5EpiPigsx7@shell.ilvokhin.com>
X-Rspam-User: 
X-Stat-Signature: 61dp5pwg1oxk67uhm7syd94oozshgqxk
X-Rspamd-Queue-Id: 409D64000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773926581-941892
X-HE-Meta: U2FsdGVkX18cYX7xn0QrgM98AeSLrQq1l7us3DikNm1aAzzBCxX+VqCx1wDzTBaRWlGsXnaFCGFb81FMG4uqigT+8elPShgy9H4MDlrtRIYvz0YPIQXZ4h1JM/tN5V+NEmQZZ9G/HZJbVTupo1sAdUxNBOrC4fL+Dvm8QIgeh55ip/oInr/olNGCKA+k6myPJ6CmZcAU1Z1iEBbAKHvr1oSshPZIihdIMQK+Jfn69ST0GCUgqCZWF0/nAmL0AKhy59U1CCvKrXtPaXbwX9TjycIv4nCYsFtP6sMTXxYJ04hC13DZV/DYP5XD4z7nv+7u79n75KcsXg4DDxidzHz80UGNbw+t1Iw6vxa/b5BQuE0Bjp/OXJR4xqijQfJcC0ko9Nl16SIxSEpWb4HeSqhEjpCMGPMYCCMK/cQ0zF6LT6z2XrP1IUxsyS3NInsUQhLs0IhSCY5oi5dlyT78r6vMcQ+O8eY7UmlLbVZYSEn1tQjYe1/bqeCegEeWo+49P9/LDLlmnjS9rTIRZ3aR1YDuRWTZy4qpHBuu7Rzf6ppOP/VA31gr+GvE5lpEjsuaqK8GWghnZH2UZriRUg1K7+3Iqok/G8rMiaO3i/QJ9Kh/mvZjTb6tkCgVyz0JRrVD6jCCvfbRvTamjawZpYPG8JudeLoyA0yrRD8NfXIMWbPNypGn5Gg0yUlfQrlWrdTaRDROLmIcM63w2kr3fTNUxiRZ6VYX9lNowYTnGHldi6U8uDE9um+tybRNAq3L3GedllzliQpUUUX03hIAJlyGQwNxZScSU6X3bSenTDYn9NV7/Ao73Ybm39GrNc5tUsCSQGZrcqmhy0is10jckavuN0vr8Z7op7eaB2x+VPYz/kNgraeo5Yqeqynq8Cxdh6RrutD0Yi5AQFhdydrNb8ZrqO8cUiOxRHX6ZbW+uU+OeBK6fj/qlCMA1v5IsylTy8Aa1TYphaGbPdBIzYyPuL4Hl2e
 FCSAM7Qj
 xzAbwGwW7VlOgxhQFBXfVj092BjUbeWSDRU4KuiKr7gFdJ+3TGkZ3rXtvdF60MFozTVrXy8mP7FSyJerMAb+IWfBwUSrH0ONfJRAQuLebzEHC/X7iVXFkqeiXjJlLtSPKQfctxJxdbJLEYnRjycM8m9hRXZl60/DSm/ym6J1yQNOwNHUXZ3TyxL110Pw4N9Jj8wSiaarQLDFx/kCfGucL3ZDNeVgTB+HXsEU4/iUTZUjaydysg3og7bixxxM/MSdEZVxA6xU0m7wcwuOr5lnuCZaoGK/uPnCRrqJ+AOfZgMAjqM/r+hR9v5T1SGTkqy0YggQZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 05:40:50PM +0000, Dmitry Ilvokhin wrote:

[...]

> A possible generic solution is a trace_contended_release() for spin
> locks, for example:
> 
>     if (trace_contended_release_enabled() &&
>         atomic_read(&lock->val) & ~_Q_LOCKED_MASK)
>         trace_contended_release(lock);
> 
> This might work on x86, but could increase code size and regress
> performance on arches where spin_unlock() is inlined, such as arm64
> under !PREEMPTION.

I took a stab at this idea and submitted an RFC [1].

The implementation builds on your earlier observation from Matthew that
_raw_spin_unlock() is not inlined in most configurations. In those
cases, when the tracepoint is disabled, this adds a single NOP on the
fast path, with the conditional check staying out of line. The measured
text size increase in this configuration is +983 bytes.

For configurations where _raw_spin_unlock() is inlined, the
instrumentation does increase code size more noticeably
(+71 KB in my measurements), since the check and out of line call is
replicated at each call site.

This provides a generic release-side signal for contended locks,
allowing: correlation of lock holders with waiters and measurement of
contended hold times

This RFC addressing the same visibility gap without introducing per-lock
instrumentation.

If this tradeoff is acceptable, this could be a generic alternative to
lock-specific tracepoints.

[1]: https://lore.kernel.org/all/51aad0415b78c5a39f2029722118fa01eac77538.1773858853.git.d@ilvokhin.com 

