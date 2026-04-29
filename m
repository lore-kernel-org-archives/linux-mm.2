Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18BE5FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86BF96B008C; Wed, 29 Apr 2026 14:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBC16B0092; Wed, 29 Apr 2026 14:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE7F6B0093; Wed, 29 Apr 2026 14:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 59CB36B008C
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:01:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 133F01C05E3
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:28 +0000 (UTC)
X-FDA: 84712360656.06.239CF30
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf30.hostedemail.com (Postfix) with ESMTP id 07D938001A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:01:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MNS1CBKL;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777485685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nr8aDAlOr0TZyX8GAjW1YzW8YmGzApJfxtMlvZWK2Gw=;
	b=ujO8HSTde1VEGephN36QuUiTLQDjnRH4zuptwUbp/1zUR35qydl2FphXbL1MmSSnFosWIw
	+izqXR+fowBBXnKuEFqBMsXwOIB5GcbI0HQPYj4uVK/plruHYbMbh9eqcdwPEgOhVpRPww
	BEut6rn39VH//WQanH8aZOnsW/qbU/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777485685; a=rsa-sha256;
	cv=none;
	b=EXDT0HkTclQwP7bF3nYqqhoM+XUo5rrEQU5OedwuhR/jhfUmqCr9B9KA4HXQZo3uBBYxrG
	4yYZdHoLo9VwLfkxKzFskaOf7K5GIXu0PU4upA9tZw3+SqdXighF4eYDqpvEfXjFkW5Fsv
	LAbSwrqro8mmzekAAmEkqD65NOiRPgY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=MNS1CBKL;
	spf=pass (imf30.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id D170CC7AE4;
	Wed, 29 Apr 2026 18:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1777485683;
	bh=nr8aDAlOr0TZyX8GAjW1YzW8YmGzApJfxtMlvZWK2Gw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MNS1CBKLiIHC72rn5utxv4+xfalJ82zNcleJqz/wcnQyYR05TH8ACIiFhljicn8Pd
	 iLLLjqRZjlXrwkZ1jT27BSd1/I563YvWmBMm68udCy3AwbJLUP7ELWAWLHd7aA67CN
	 BRwJX7vEF/Z28mndEUJGVjTYziLKhbogM0N7qV84=
Date: Wed, 29 Apr 2026 18:01:19 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dan.j.williams@intel.com, Vlastimil Babka <vbabka@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/8] mm: use zone lock guard in
 reserve_highatomic_pageblock()
Message-ID: <afJHb21JImQvVMJP@shell.ilvokhin.com>
References: <cover.1772811429.git.d@ilvokhin.com>
 <cf489e5e79f5e9ba450111ee655d9924fe7a1620.1772811429.git.d@ilvokhin.com>
 <20260306095336.a79fcc869a7f6d2b2e97501b@linux-foundation.org>
 <20260306130052.7da8eab3@gandalf.local.home>
 <ce0e53e4-52e2-4e56-889b-adb01ede6fe7@kernel.org>
 <20260307131641.GX606826@noisy.programming.kicks-ass.net>
 <aawxpQDPpqX2k5z8@shell.ilvokhin.com>
 <20260309164516.GE606826@noisy.programming.kicks-ass.net>
 <afCS4d4YccQFtvpi@shell.ilvokhin.com>
 <20260428114721.GV3102624@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260428114721.GV3102624@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 07D938001A
X-Stat-Signature: wjf6aww4tzgqx8wfmuwnxrkyznxqzrj5
X-Rspam-User: 
X-HE-Tag: 1777485684-44577
X-HE-Meta: U2FsdGVkX18LxnBCOHxbOhRW3NO4R/G+leABaCpLtG544K1X/iGDVb1Yh+EW28f3DvfncCCpKOPdiy6vWy+goZRTTPL1tnhSNm0srZdJN+/uFtxVbYUQEngc8R1wvB1vysdzN2Cuw+/+nvEQuLC5Makfch5wYHBuO7RpT/SV4tB+Z/Njfydkb9eAF3rO+JFrMQ8hdT7GHgKB5KgjLgfAYJRZUzInoaOyFR5Y2MZ0f2cMJTf2z3thkV/NiuDifbFn4q+Ln1Y5v0wJz1z6nbSWIwytmNFAH8nsGdx4hRcA8pCwv99MK6vf2aa7+vF52li/rjPTvKlsQPNAl0xWrxU78G62CreTMPMSsXTCOff/P0D9qS4GS6k6WimeA7NVYjZq+x7GDW4HiBucB2YZ9rFxk0WwRpELcHZNUYO6F5wbYXIyaIynu8kdku8sKtL5w65Gt0UEs5EGSZHf2rVlVf1fDl28lnW5q7Js2JIcTRs57PYEBOFu+TpWR41JdtsBX2Xg/0KzjMXnCqN8uMeIEOQoEDYDRZGJSjEGkwFDsVtqbNfeR6XAtiWRqBs5HfZ+xO6MC2RzQ+lZQW317rpHSkr1BPcQPCLh3HoWgs2ShE86t2gj7GLPo4pDWEh+jhCLLZpCx754MuM2L+YbgNIt27laivzDhpnImeKbkMuKw8RgIkx0Y1ikwqFerxFDjZyg65TBi0Z2IrXS6vtFvcGgFeJyel8ZPf7mskmKl59T0X3Vdn9m1teuNfZqPS6mppyniqfb+g1GKDh/kdKHdI0nNYLj/4upWm4ALOl0UjeCiRDuF8YpC6gDlCm/Vu2RieUd3Cd7MG5LZ3nn4kuxZ5HNZe0YizYb4PGzCqjvjfO5xwaIACkWmR6hYdilQBJY9zTA4Uf+hoVA7OGixjsQ6av4EY63ahHE71CHgL3a6QXOp0KfdmiswtGAB2WS10haVgR8kLn4YAySfCK+moEofyFFchZ
 dR4tkNsO
 MzhzF57d8nQ6Vf11Tefp8y78BAgvwAGyI3L2YhqSXx0J+O/lQHR8aR3hjRaYC2CRjiKdMcTGvrU571sRhBjcZMbuZwu2tzdBFHKINNH9QotXbtER58j5JDiUaj84PeD/dqhJPkofHY6jUhLQ6nQ2S2Nt+Kg0gWRyfuyhgc8SERYe0fExk9MBXPVDdszcr/ZKEqvyx6r2wloZqfRCNpJNgxsoPcvpjFI2WlJvWEv6hiCKCxUlj7pZZ8WBgGHhM/Lh3g1LF9i0ql1t7rsuPz1oAYQCVmWR9M5LwjOH/ZTtDxiu652OFfFinLOs45C7hM6B5A4mjkAZxJEbwseGhUokZRJzf7EUe5ZIz+b9rXOjCMiMXGdI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 01:47:21PM +0200, Peter Zijlstra wrote:
> On Tue, Apr 28, 2026 at 10:58:41AM +0000, Dmitry Ilvokhin wrote:
> 
> > I re-tested my original patchset after rebasing and can still reproduce
> > the regression (though smaller). It appears to depend on compiler
> > inlining decisions: in some cases the compiler is able to deduplicate
> > the cleanup path across multiple return sites, while in others it is
> > not.
> 
> I'm confused, all this has __always_inline on. And the compilers should
> be able to track the assignment of the variable and eliminate the test
> themselves if value-tracking excludes NULL.
> 
> > Given that, I think we can go further than just removing
> > __GUARD_IS_ERR(). It should be possible to eliminate this branch
> > entirely and simplify the cleanup flow.
> > 
> >     https://lore.kernel.org/all/20260427165037.205337-1-d@ilvokhin.com/
> > 
> > Reposting here to increase visibility, as several people involved in
> > this code have participated in this thread already.
> > 
> > Any feedback would be appreciated.
> 
> This would require very careful audit of all the current users, it's had
> this behaviour from the start.

I did a bit of code archeology to double check I was not missing
anything here.

- May 2023: guards were introduced by 54da6a092431 ("locking: Introduce
  __cleanup() based infrastructure") and DEFINE_GUARD() called _unlock
  unconditionally. __DEFINE_UNLOCK_GUARD() had a NULL check, but it was
  unnecessary since conditional variants did not exist yet and the
  constructor always set .lock.

- Sep 2023: conditional guards were added by e4ab322fbaaa ("cleanup: Add
  conditional guard support"). The branch was added there, because
  conditional destructor directly delegated to the base class destructor.
  When a trylock failed, .lock was set to NULL.

- Jul 2025: ACQUIRE() was introduced by 857d18f23ab1 ("cleanup:
  Introduce ACQUIRE() and ACQUIRE_ERR() for conditional locks") and
  changed the conditional failure value from NULL to ERR_PTR(_RET).

- Mar 2026: 2deccd5c862a ("cleanup: Optimize guards")
  EXTEND_CLASS_COND() was introduced with its own if (_cond) return;
  pre-check before calling the base destructor.

After EXTEND_CLASS_COND() was introduced, the conditional destructor
does if (_cond) return; before calling the base, so the base destructor
is only ever reached for successfully acquired locks.

Peter, do you think it is accurate?

All the commits above are from you, so you are the best person to catch
if I missed something here :)

