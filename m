Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0912C1061B3E
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 444506B0092; Tue, 31 Mar 2026 08:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F53B6B0095; Tue, 31 Mar 2026 08:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD756B0096; Tue, 31 Mar 2026 08:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 15D2A6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:32:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A161C56AE0
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:32:05 +0000 (UTC)
X-FDA: 84606295410.07.9CC3A07
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf07.hostedemail.com (Postfix) with ESMTP id DE89C40013
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:32:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sqT6OpXi;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774960324; a=rsa-sha256;
	cv=none;
	b=R8KFQqKzaa3AsDI13Tflau5KLB5F1sjzjNKX34hOON7bZC2aeDNrBuPhldEfNUFUGt1by+
	8tatKAqu0NbeISOWicYivqqiEmVylpwcLsxcIAV0fHzjjyJZVvu848wESPZ8wvEQ0v8L1O
	UcJpJjPqOV5xZDrKhnR0mNXlrANkvAk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=sqT6OpXi;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf07.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774960324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z2eDNMN/atToABrH6ndusX6IX5Tl7QShF5YQMMFudmE=;
	b=6hKm2AS+u+Spi5OqkTe7XwY8qS//87zJF7cA7OMNVxt0jBmTzMRY7ZGGYstuwFD/yQH6a5
	SScXDCGWrJLkHe9vmzc0nMnR9t/KwTHxyS9Gc9kXaoPUfKAqPxVoj1MR0V3VZufxohMT8C
	gSz7WJGNKorDWbXMO+x7Xoe4Jps8VmI=
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 13031BE24E;
	Tue, 31 Mar 2026 12:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774960322;
	bh=Z2eDNMN/atToABrH6ndusX6IX5Tl7QShF5YQMMFudmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=sqT6OpXij7sXEX3lR7XgTL1XcgqS0sbDtamjJbhFSIjtfPZbzbcUFQsqFcFf2rKIG
	 xkuFi6SFXicXAPn0RihX5CqsaIzIdziwT35ZJgVXt9fOj2prKQ9PpypId/QyqhaZ/s
	 /TOW0Qcvg1BqUshPhXmKn/69Wfdtpsvoz2aqbO3I=
Date: Tue, 31 Mar 2026 12:32:00 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 0/5] locking: contended_release tracepoint
 instrumentation
Message-ID: <acu-wAFTVCmI4_da@shell.ilvokhin.com>
References: <cover.1774536681.git.d@ilvokhin.com>
 <20260331102704.921355-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260331102704.921355-1-usama.arif@linux.dev>
X-Rspamd-Queue-Id: DE89C40013
X-Stat-Signature: g3bhzdz6jtnems1f15yoo58cgmah7547
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774960323-476196
X-HE-Meta: U2FsdGVkX18ZakSaGrLNYRKiqrb7gXCqmmTkD1uOQlf8vcvWiGcTas7JZpq93d+O8wbU4iFCMM1uokeZ0DhPSfZc0gXIZGsj3m7iGxlmN8HYS6yA/AOb5N8qPeyDdH4nfQTjSeigDvgi4ETtlqbIng7mu+EmjCGZVBC9U9cWgDf/iJ509g3z/awz2zfqPPks9K3xr72ejK7JP/5r5a9QXSXKAKb3EuLj00DgN8oN/FUfp7p+XbaqAEXdH/ilSa/XfhTQu3i2yC62zEHmvpiQAJb7CaiNxZ6H38f4O5WryIj7npTD39+VCj+fvupJSTwb9Wd+URAX+J3W+jR8a6IZmJDSbLeYFkHQeQf9jZu2hsZqYkFmxjJbomrqLL969yHNriz0QHQ7zznBajLUVpUeBmIIzOJzeCE2KbsJgXRadweUUAIPg3FqfNIC6PhT5jUlAufG1PMDNHGdCRVcj4Yxvqs2h84WuPMhTfCFT64qw9DNHgXrj1twotvNZ/frxANjSS3D2wvpsnv9kCHS/ASrdzNd8SwR/8d4T+wkrdq6HtKIN9gxBGRCw2Av/BtI+O0Ce1iVKCBBX5Pq/XPv9GJ8i6ciiRp2/qTflYQsyPzsfLr1jAaN767IvCwSu4LoaKA2fYfQuENRRws7U/4xU8PvZEu5D3bsOpvEqffzzIo+OEHpUfFoEWyZe7RwdGea9TOaXuQ9yh1gA2UeyDN/CNoe7X9VEw9QGj/l3JB/tWiVQq7ewColnsOfxj9n5nutUJq1G3/pF+tP0IlhQm8UJ6hZenoraiTy9YhI2u+VMtW2xabAuhfgWiO50LkF45PWKQVby51EpT83tEmSqEFeN1AcGA8i8zz69GA/0QmQlctGHPXJWfazilntiqLo5L+DZJU7z4lOtSTXiSfdhSCPL9bd+kctMW6MJ1YimYCPXpmDtGAg00XcyADq+COJWQWAPLR1oNHYDrhAD2VkaBIxW1e
 ErxRALyF
 eWzicyFwGxZQuejbfAP18fh4iD/dNU2y3OeoXETnZ+yE7XIbgL/XJnG80vCvtjSqwVpxfwiDTEEYPNzcFrLVx7o01T9kHvo+KOxiA3YhUwREL4h3x/SYf6XhXyWQkJzOZTj39CaC+1PvYrlS+yTwrUIHLhqmBwTxY4aN1pyn1wSnom1VLRAxjQ9ZO3ysE2wgqcFYNozDv5LgWBFZrujh0bEAlGTr3+UfTZMSzoabxwL8R8DsLyQ697hf0ocyU2JAVuVDfE2AqNo6ff/+MGKTgtiXRdogtwqVMV+zhLHrBRci16bABl9s5uxxJMdex/jHKGxwsBdUDq9LiYGrqZRFquMG3sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 03:27:03AM -0700, Usama Arif wrote:
> On Thu, 26 Mar 2026 15:09:59 +0000 Dmitry Ilvokhin <d@ilvokhin.com> wrote:
> 
> > The existing contention_begin/contention_end tracepoints fire on the
> > waiter side. The lock holder's identity and stack can be captured at
> > contention_begin time (e.g. perf lock contention --lock-owner), but
> > this reflects the holder's state when a waiter arrives, not when the
> > lock is actually released.
> > 
> > This series adds a contended_release tracepoint that fires on the
> > holder side when a lock with waiters is released. This provides:
> > 
> > - Hold time estimation: when the holder's own acquisition was
> >   contended, its contention_end (acquisition) and contended_release
> >   can be correlated to measure how long the lock was held under
> >   contention.
> > 
> > - The holder's stack at release time, which may differ from what perf lock
> >   contention --lock-owner captures if the holder does significant work between
> >   the waiter's arrival and the unlock.
> > 
> > Note: for reader/writer locks, the tracepoint fires for every reader
> > releasing while a writer is waiting, not only for the last reader.
> > 
> 
> Would it be better to reorder the patches? It would help with git
> bisectability as well. Move the refractoring work in patch 4 and
> 5 (excluding adding the tracepoints ofcourse) earlier, and then add
> all the tracepoints in the same commit at the end? It would help
> in the future with git blame to see where all the tracepoints
> were added as well.

Thanks for the suggestion, Usama.

I'd prefer to keep the current ordering: each refactoring commit is
immediately followed by the commit that uses it. For example,
queued_spin_release() is factored out right before the commit that adds
the tracepoint to spinning locks. This makes the motivation for the
refactoring clear and should also ease the review since the context is
still fresh.

Bisectability should be fine as-is, each commit compiles and works
independently, since the refactoring patches do not introduce behavioral
changes on their own.

