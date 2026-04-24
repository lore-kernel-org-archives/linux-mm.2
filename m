Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB4DDFED3C3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:30:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CBA6B00A8; Fri, 24 Apr 2026 09:30:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02DB56B00AC; Fri, 24 Apr 2026 09:30:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85496B00AD; Fri, 24 Apr 2026 09:30:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D522D6B00A8
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:30:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 742A987881
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:30:28 +0000 (UTC)
X-FDA: 84693533736.07.2338B16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B644F4000F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:30:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yM9qm7ug;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777037426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qzyxA8leFujOD8aA08/8E4BXAeOhA9yzQcmNFio2TDY=;
	b=bGvy+MmVR1fUHVbR/BPESL/ytW5qFROhWecgtgpWegNHuf1IiucJScUzHtKePyyyP5xARc
	dthITucZVWxhmsGT+ITnuh5QiFBZr8ItUkDExOXlNr091U5QniBDsriJGpE6qKPRbRhApF
	kBz175tN5n0Sx1jcThFeXmDYOJbktG8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777037426; a=rsa-sha256;
	cv=none;
	b=LfaRaVv8hJrqMDZ93wpgdvLjO2ZBhRfgxEisRYM3io80QZoJvqSObYwE32ObVMT56GIXf8
	pMvc8bPyDnfOVCjn+oplZRlvT+dSYHa04aEcK9HKf2PgBh/QDJVPlwVQZiURiXAYdQM99e
	yyYN/dz+aMjc9d4HNxvGU7CHBWffY1o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yM9qm7ug;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27D9F60123;
	Fri, 24 Apr 2026 13:30:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C556CC2BCB2;
	Fri, 24 Apr 2026 13:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777037425;
	bh=yz00f7Kt6rr2yoI71kcabVrEC5OsHYNxJ4SpURtk3YU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=yM9qm7ugRKpa1d+28Z1NjLNSW05C1mgX6m5igCaRKQc7iIRC5yOMCgi/to4dpT5xN
	 bFALWlmn8qT9kIH6Sm5MIHDDZLqnatqEcA4qWIahjKxwhX8TDamvMVHysNvFFVTzB5
	 CG/3tt9EDVRK0WRV9LGfwZR3fkNqcAhp0izUQZOs=
Date: Fri, 24 Apr 2026 06:30:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: peterz@infradead.org, david@kernel.org, dave.hansen@intel.com,
 dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, arnd@arndb.de, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com, jgross@suse.com,
 seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
 virtualization@lists.linux.dev, kvm@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH 7.2 v10 0/2] skip redundant sync IPIs when TLB flush
 sent them
Message-Id: <20260424063024.ce42ee6a5546e4d9337dd007@linux-foundation.org>
In-Reply-To: <20260424062528.71951-1-lance.yang@linux.dev>
References: <20260424062528.71951-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: raraaax9tf64wa3n3idjjahfizpx6b3n
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B644F4000F
X-Rspam-User: 
X-HE-Tag: 1777037426-995112
X-HE-Meta: U2FsdGVkX18ya3CEjRayZU9hyjedTG/Xj/9sdVdtlKi/bLivg/8uW7k99qAI+ojg6A3u7Vz5LKZHTJf1R0VmvNpMoxk3BMW9pVdCmoTLKgR0z4CUJaEUAYBk+eq1Lkn6HU+iA8VbmNY2AA7qxlKWIq6gFMPte3HY13baQhFk2xa9btz76ti1A6fBwJp7Pk62GpC1DVlZ7zY+Gg0o/gGE+FS74OL3/jnIM/OleVT378P8LybzyjEac0+wQVuHtgJ0VA63M2w846BLwmf4obsGfob+0/Pwz/gn/5Z36ofLFy2xYE5ZwulGhOx4UXFCpBFEWQBaYXjiNpJ/rgQyusgbeyWV6LO8WZ9giuovnfRjky4S8Bl7OZuIhPsFwhDS1fXo02T/03akkgB3CVU41S5gC0M5//ueoDfIzVQApxH4kKSsNHwGJodatyGyiHhimRhC7TlA35AF8uRvxxNfIFnYQH6sNgMKlZTH6pS7cdIpbHltXGCfDXMpsyxF6JaY1ASZ4KNn98GhPWsULTe4Dj8yuOU6HH8ShNfomx+GuVWv+B8SE2zWNQ5YOQuwI5asT2AxdAkih7zHdoafcvd6NY7ji1U/oBGWCKg5PSqsNZy0YKBJg0hvz9AXWRxaX8qSqHyniK2oyTydx6dD+ky3pzxerePH+SoXf/5c471QInvBqRqwg8XAPQins1XE0GMCrElZbwHc2Agnm9mduJT63qswzODoras76GANXPvLU45vv6DI95otiIjYTYWIQZoJV5+LFZ4kmYebeJf+i2gX9l+f8UlhLDJYDlD4NYyE9II5xt6ZZk4LSuxqVXTiI67sMhqRAk3Zq/G2rSByXvQNpPyXsqkVaAATcsD8JiudixE3eWatGRWWEU/abXMhy+bQV1GDVcG6zTr4MFCA4EEQbMaGxwRAnFxlm7A65NP6z1C7A0nEw4Ij5zAvyJgwFVJM2ohutX7rYRiW1H4f1a3OSSO
 hmaCKsjz
 StGBYtqzZ1OScKv65zi7z0D8WKrbj/JgtQongIA5qu/AFXTCL47hcVF/6ALIUePAdx1yf5gOHV+BXRo7tz3QIzAQe7ByrhIvZGgQt8AFe/dPQ8epyEbFIgxF/lSxeASua8e6ifAgstL+Lk7bMFZQm9nkH88bLS9YbdMP3hIy+58m+pnW3faAS7Gk+sH1GO3oeKPWnxQGPeqh6h/s4EFfUF9W+lI8/Ry4iqmTL86egvpKL97yaOquV4c1V939PPIulQoMAnqX0wH+Zx2GsLBVKDztMydkkZ7bubIb6DjELaVgSCifDJHyJPIWqzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Apr 2026 14:25:26 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> When page table operations require synchronization with software/lockless
> walkers, they call tlb_remove_table_sync_{one,rcu}() after flushing the
> TLB (tlb->freed_tables or tlb->unshared_tables).
> 
> On architectures where the TLB flush already sends IPIs to all target CPUs,
> the subsequent sync IPI broadcast is redundant. This is not only costly on
> large systems where it disrupts all CPUs even for single-process page table
> operations, but has also been reported to hurt RT workloads[1].
> 
> This series introduces tlb_table_flush_implies_ipi_broadcast() to check if
> the prior TLB flush already provided the necessary synchronization. When
> true, the sync calls can early-return.
> 
> A few cases rely on this synchronization:
> 
> 1) hugetlb PMD unshare[2]: The problem is not the freeing but the reuse
>    of the PMD table for other purposes in the last remaining user after
>    unsharing.
> 
> 2) khugepaged collapse[3]: Ensure no concurrent GUP-fast before collapsing
>    and (possibly) freeing the page table / re-depositing it.

Sashiko questions:
	https://sashiko.dev/#/patchset/20260424062528.71951-1-lance.yang@linux.dev

(I never know if my Sashiko emails are welcome/useful.  Maybe Sashiko
said the same stuff about v9 and it's all wrong.  But better safe than
sorry!)


