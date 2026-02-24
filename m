Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B86E9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831BD6B0089; Tue, 24 Feb 2026 06:56:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC326B008A; Tue, 24 Feb 2026 06:56:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF1B6B008C; Tue, 24 Feb 2026 06:56:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5AA1C6B0089
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:56:04 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5D17C2002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:56:03 +0000 (UTC)
X-FDA: 84479196606.13.BE3FCC4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 53A2740006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:56:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=frg9bYUz;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771934162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jZbApCE7aKfGQAJ5QYtHKFYfwUek4AYedGrEYuPbu4o=;
	b=4qvxpwm7MfBn1Gqw8RjKT13NyGmWbCMPDaDGvRRC2cji/l4rVRa0VSsFrKBgqTcH1kW83T
	x2WlIwVDiF4zemSiF69D9Xe9CKxsbxvb9OQvhbH3ASwX//i1mFvA+V0gvCTTSAiY+rfviy
	Xlh+i+bv7KLsVBgbv8C6zxR3oKdKybU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=frg9bYUz;
	spf=none (imf17.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771934162; a=rsa-sha256;
	cv=none;
	b=h3iDORra6aSkC4repzgvmKYGWr5dLhtSSF0nH72wt3IgE1k016oIlHnmSDj2snDxn8OL2N
	aKch3xHi/SeIizD0J0SQoqqLPOtPCbwpHhLtdWg8BsQJk9ocRMJaiPlTDwK9RBmNeWdfZE
	HYQ17vBLV4zhu3ueSvBty1Cd5jsiL/8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jZbApCE7aKfGQAJ5QYtHKFYfwUek4AYedGrEYuPbu4o=; b=frg9bYUzHcb76/JI/1FsMqNH4K
	pLRGr2stwD4MXQEu+8ZXB0ZgGRK7ykCXStgirFWMsUYzmhWv5PJw1WOkwyqHeWDcbY45mmOEei5TO
	LLHVst7OZ5GAC7fWSbYGK2UxhvrUNUleXThNDbd2EAfL326rPapEkBZhkUUhISa+8yUUN9XsOstey
	Z3cijP6YBgzO0gUHizujJx8+k7V3yfpzOhAunvqnRXjoBTi5wdJDzSbyJrgqG1oR3B1rLqZnpqOf/
	/Sr3B9GfELbkHD0O4NjJcWAVp5HR+6cvnHHcJOApF87C8PfhOYo+B29nTd6gnQbdjbsTnTpYafdUy
	ZkxuiH3Q==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vur1B-0000000GmLl-41uX;
	Tue, 24 Feb 2026 11:55:58 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 811F930095A; Tue, 24 Feb 2026 12:55:56 +0100 (CET)
Date: Tue, 24 Feb 2026 12:55:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm/mmu_gather: replace IPI with synchronize_rcu()
 when batch allocation fails
Message-ID: <20260224115556.GU1395416@noisy.programming.kicks-ass.net>
References: <20260224030700.35857-1-lance.yang@linux.dev>
 <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224114152.GX1395266@noisy.programming.kicks-ass.net>
X-Stat-Signature: dqnrh9msarb7cwk43ykxkgirj97zoswj
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 53A2740006
X-HE-Tag: 1771934162-102902
X-HE-Meta: U2FsdGVkX19Bx/oiJ7L16HXADXgQzCmyEYtvkku8JkQjmROnRsIYUF2GfDKeIU9kxfSUg7QyM8LNw9iuyBJDRvsUQh0LI/XrGPpxN9kV6GI9YuebQG67KBw7+KXXZj0PDUuLX7m/PyrOe5qyFwAWtUTK0i9A6/q1H2kwk0mV05eKba7Wh6Tjgg958yGP6s7f0/eA78GourCJgf2Yytcpstip6gWBstuNnD1MR3iAaJeGo0UW3yNDmnhI9PyohuWWtROtTMruDx1lbx5XKKYIiK9d/lzFFra1R52TGqLGNP7OlSs9Kv8CnAwI4+KMe5mD/decw6Gobq6Q239mbxwm31KGmTO7/njaAfsmIT/UJEwhTfWWZZTgrISM7iJHg9YbEBdA+neGaoCqc4TYO+JbpMbCsXGPsepkAfdkIkLXVAWskL2CERub3Sav+Z3rI97283CxnFjyRDuOtSeT21wmuKGCHgujHANk06tk6sAf2T20wJzPoNdHixNYtI4IdXuzkuZnpQutvi6u0moczX3fszj1GEVE1Ccm2JcWiagQzywjN5PD8PBhrPYOn7jX/tkdXH8PSm3JfqstFasUHmwGRi9kZ8gFdfrI53J323bNmICQ5XIBRaJsX5c7KBtpI9w9P7gN3zu3lwfBoFky32A7Uc0NfuvCdX+dUdN4/4oAxBfw1N698EHmHN1SgVUxaY6pzQlrd8ORMCzHjJfKx3+eOnJfYRmn1wSovEFWL1rqRzuTWtHkjlSQ2IgG7hAVxOjVm9bHLf8L8DsyZA5tVanUmSU1A8Bkkyyl4WJrc2pZ7kfNG25VyVuEVeGkzpodxGes2tg8NC/KCOrYDMESqpViWb+izYMCqRWb3lncJzIbQKjXO0XFILQtKEbZLCnHBts91h57ugBmUiLdPul70Tu7XQvrEoOCb5XXTW7udCKlYYP+UHk2eoc0ahwhUTQbHHmhO3Aia7xPZE4oIPG081+
 ioQ/Wae0
 dmJ5nMT5LZ24apl1u2qLutcXU28n+ElAYguku1xukuYsSHLqdH0keXtW7BSuP54JUP3+xY/OAoSenAXV1aSfjQEoWx2pKpyJ7tLrdqL92I0lprhBZiCn3fL0aTCTtcqO355nGq8eTBVWWg93v8ohyBj2+Jc9sOBEHGGCyzfibaZaTVkGCU7yJdXjcoX9ZzY0zzIoUIC8+49tV5W9Ba5Mo/j2M7fJZSFWokS4y/aJAByR3vldVEv4NuMUTJTeFNTJmls/MdReamJs6DbBqrnGjHEhVnz8XwKpYu2eS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 12:41:52PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 24, 2026 at 11:07:00AM +0800, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> > 
> > When freeing page tables, we try to batch them. If batch allocation fails
> > (GFP_NOWAIT), __tlb_remove_table_one() immediately frees the one without
> > batching.
> > 
> > On !CONFIG_PT_RECLAIM, the fallback sends an IPI to all CPUs via
> > tlb_remove_table_sync_one(). It disrupts all CPUs even when only a single
> > process is unmapping memory. IPI broadcast was reported to hurt RT
> > workloads[1].
> > 
> > tlb_remove_table_sync_one() synchronizes with lockless page-table walkers
> > (e.g. GUP-fast) that rely on IRQ disabling. These walkers use
> > local_irq_disable(), which is also an RCU read-side critical section.
> > 
> > This patch introduces tlb_remove_table_sync_rcu() which uses RCU grace
> > period (synchronize_rcu()) instead of IPI broadcast. This provides the
> > same guarantee as IPI but without disrupting all CPUs. Since batch
> > allocation already failed, we are in a way slow path where sleeping is
> > acceptable - we are in process context (unmap_region, exit_mmap) with only
> > mmap_lock held. might_sleep() will catch any invalid context.
> 
> So sending the IPIs also requires non-atomic context, so change there.

s/so/no/ -- typing hard

