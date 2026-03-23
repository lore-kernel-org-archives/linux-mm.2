Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEDFCF483E3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5D666B0005; Mon, 23 Mar 2026 15:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E856B0088; Mon, 23 Mar 2026 15:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C24346B008A; Mon, 23 Mar 2026 15:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B476F6B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:05:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4EC671B9377
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:05:23 +0000 (UTC)
X-FDA: 84578256126.25.4F5F01E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6AF7318000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:05:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A+XSB7kN;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774292721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEuHXLxrxia/AnP/26XPiXc2topFjXRBR+YJ5/BXxak=;
	b=oUaDmnyWuUInXOxZ6Nu3LJmslIS+VF+8v82b12yUnxV72q1XMRQyr0rnns84efMg+93axt
	9TPVggZF2kjhUwm56AlQEbNVsvkFCJW2zNKOD5/+8SAxQPkyEos+NRbKJOJDBPGUTAY6ke
	nQtfDQM9JRpw1IPoiC3pmoS4uxUx6K0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774292721; a=rsa-sha256;
	cv=none;
	b=7lhiQ6sLQENLvfK7vskei7v1PUEhhr1CZQVHaQB3Rj3xjKgqeU3KkNhIiSrFmg4QWoYuyQ
	l83QYdF7xqYHjKYObltxBrV8d0m4M8K9G0ckDhvsbEXtXwEnYhGw3W55EsxKBcxb6NcA0v
	KPsBBwY0fn5GoKc8BP1lHWi0vFLp4As=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=A+XSB7kN;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B6CC260103;
	Mon, 23 Mar 2026 19:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2886AC2BC87;
	Mon, 23 Mar 2026 19:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774292720;
	bh=pnvnHAkGJX75rQA83KkPyOPaJZ101MU2d5ZMOppOD4w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A+XSB7kNhnNco2ImsJ86BPp+eMjLFpTMmqbEwgXmJY+k/b+enGzv+Dy+F5iPW2LnL
	 i6o8+aSFGYYxoC0cPtSQovfuDR+YtFXTMtcIyqE/x/GKMT3IU86CKcB2hPrjJpaPug
	 K7+2i4NMzNFs2J8AOHtep2nf0bLFQ343sG83OXGY=
Date: Mon, 23 Mar 2026 12:05:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall warning
Message-Id: <20260323120519.7c827910a14ce67f45cd4251@linux-foundation.org>
In-Reply-To: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6AF7318000D
X-Stat-Signature: 8bzm6m1dtn4man4knt3othuu7ohid1kg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774292721-262332
X-HE-Meta: U2FsdGVkX1/Z3WUWiW721XXWepDC+rrb5zwkORZFyq7SiS7h1zB4UmhR5GapjfW3to0RWkWLnNHRJT258HG2ZwpryDpamulQhusGr6Jh7duTzxSL0UZCHQbdrZjndRzH1/lpevnG3FpXHBpE0h531/hCOA72P9U+elGrSZfO6qTiGQHiDK0bpLxzdBv6b3uqycCI8FCTpq0YbVg23fh23zaZs221veMjzbrVsNTDHWEBfQVF35LTOajhwmwuznXrmZ88W4tbxdCDa4hjc4SxvfO3JxnzGxWjZkj4U6sk3TOz1WNvQRWIb99EP3QsoE7XGGFnOljjgxVNQWDNlevYi13FPFHCAwWNHLZzaFvNrCqR4DC7xIX8XrynKtkDBRcDOpyQ+iXvcZuF8sjaWE9IBwnZ5AK1dgDnxSDkBpS6+PDAuGJpjURatUVbFk9kpARD79ErpjAB1p5aZ1UGPVB0Vt2E6dUoyAl1MR1yC1vGXlQ6v0lCX6gKakgcrGCwRxX2L0VWGeW702iEXl1YMOuG9dgXg3/0PAxp/bWgVMV6DIR+QG/6fXtNCV9QcfzRbVCT1tcoBtklsw4kFjxev2EGftE9umlB+Hk6JAXuy5IQ/ldbglRqJrkvm+08f5jda8aaKk97zkiwwL+Jw5d9LdtaSxKlDI4vebVzFnlXQgtC4Uixwd7pLEcuPUSGHtMe2VbZUSTsK2EtIy0q+IXaZx116b4mSmdnj3nECnOgRunFlEo9gCSCjpv89IdZbGWYfrNcjVkW+kgYRluHLGn/6jK0yim087bO1SG3dpDT/XOkCxbLEqF59Q4rfgaJjVWbNpGGllAErnSD0rfJLrlG38ipH+y5Lf4lwxWN2cFFYhTjGz42AotJGTUn7iYBMLDu6izl8v/EkxG8peeJYtgI+2IApRAwXsa+HMS81OfLoKwE3ImotABSzWlazm7U8jE+yU8J1pF+fYn6TINaSP5BPkE
 GX4g/QPL
 uHeH9i4uX65hhPJg8rh0hIw78LhTyWiPQ5gVCCs4HDRTX3nY7esOafeQUBX/Woow6TZ1tv4hKzKE5hP42Sr2BaN3Fa8DfpggpxkqW34p5WgMWJnDa7h1XxdXxz360zFbLWoyf79k8fkf8+mVfnG8Xxkf1Y3/93AAUaEwLrZqdLBxg/b769m7XJfU4DTD3mNyjNoAJfpbyTsm3i1uBOq/aD51lf0dlAYYHg7UROFs+wSfKxjz/yKK1/4dxymuThYF7vp8dYP0v6SdaR4FzCEUaNzYqgPRtbv/8a8yl9kwjttKhx0kXRrew4EbgCB9jo7fzwwi51OM/xKXNyN3AQvlBqp7ZlLVypz603PBRYgE7U0YkS8UhxhmgPYYJUWyaDUoV8Vyc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 20:03:16 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> Previously, we had warnings when a single page allocation took longer
> than reasonably expected.  This was introduced in commit 63f53dea0c98
> ("mm: warn about allocations which stall for too long").
> 
> The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> warn about allocations which stall for too long") but for reasons
> unrelated to the warning itself.
> 
> Page allocation stalls in excess of 10 seconds are always useful to debug
> because they can result in severe userspace unresponsiveness.  Adding
> this artifact can be used to correlate with userspace going out to lunch
> and to understand the state of memory at the time.
> 
> There should be a reasonable expectation that this warning will never
> trigger given it is very passive, it starts with a 10 second floor to
> begin with.  If it does trigger, this reveals an issue that should be
> fixed: a single page allocation should never loop for more than 10
> seconds without oom killing to make memory available.
> 
> Unlike the original implementation, this implementation only reports
> stalls that are at least a second longer than the longest stall reported
> thus far.

AI review: https://sashiko.dev/#/patchset/30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com

The warn_alloc_show_mem() inside spin_lock_irqsave() does sound
problematic.


