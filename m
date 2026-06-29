Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14088C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E735B6B0005; Mon, 29 Jun 2026 05:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23FC6B0088; Mon, 29 Jun 2026 05:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39E56B008A; Mon, 29 Jun 2026 05:57:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CBB36B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:57:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3B4F4061A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:57:13 +0000 (UTC)
X-FDA: 84932497146.05.A818A0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 488BA10000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:57:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kk26YqZk;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782727032;
	b=Y4Ss8p5xoV+bDW0OXGgPZ754UvY9axOiYfWCBfL0Fd9vPVzoh6RGaWP4lhhnUyWhB8zGeu
	KuJetntOP4zQtEhYF35n4YvZWVAF4Fx7nZiaPG2TVKYD2ktArQXl2uN60E+KLfpPVL+i1F
	nYGWXHWBDYs2HBKLyFfO4Oy9ref15J4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782727032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hm7uAuXqV83pH1WcLn0gFqC/C3n5BbfPtcxR9BhAvpM=;
	b=aXRNgSNvXqVM2pAh2I5PKK1KwwCky3SvM4NeHFUFH1OK9BamZbZIqzgBBF/iqXd5AfDFKV
	A77M3iCoofreeiQBMUD/0F51wmfSTJv1bIOQvc+swSF3jPgvLs+JS9EWuNxB9WQ5cAgejf
	bQk9YatNReKpZuGwm03TEoZvLWC2MMQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kk26YqZk;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A457B60008;
	Mon, 29 Jun 2026 09:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 070E21F000E9;
	Mon, 29 Jun 2026 09:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782727031;
	bh=Hm7uAuXqV83pH1WcLn0gFqC/C3n5BbfPtcxR9BhAvpM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kk26YqZkaOzOyHBGvLH2I3k6ZIgsbpejLMKNX1uggbfg00ql+m6ITE5AivlZeIlUe
	 NoYLSoPHX5QnQarNtjvJggAs5ObhB2Ng6sA1FEaj2KYxKS25lGWJDYl8tS5JL+0/LP
	 T657DnAFLnzIEO4DWrYaylDmo7kCY0tWBecCf602uDcy1fstdla7kdT48LvT+OfVth
	 4S2gFKF1BuX7kCGMgoXI1Gh5x2kbURdgGraclZaKVuHTRkPMQeH+WYdlWKOv6oAqKV
	 xDsXNaRkCnpLZyllAbvyiZq/eSxywnXfXPczSic7bQEgQhxPMn1qTOi77AqfY+q3rt
	 E0Z79BLC+0a3A==
Date: Mon, 29 Jun 2026 10:57:02 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Manuel Ebner <manuelebner@mailbox.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	"open list:HMM - Heterogeneous Memory Management" <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] docs/mm: Fix brackets
Message-ID: <akJBDwtGX241WHxo@lucifer>
References: <20260627093258.31265-2-manuelebner@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260627093258.31265-2-manuelebner@mailbox.org>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 488BA10000B
X-Stat-Signature: 4m3zmpnxpdzz3hnk9ud6fyk9uomh8gc8
X-HE-Tag: 1782727032-326842
X-HE-Meta: U2FsdGVkX1/FXUm3SWxbE4LOOO/qyyhIDn3uvd4wIAw8zGQdN+RdA0wTCQfxGuyH6p/4UkMy5evjoKYTgmei5/ULa1HVThNvjVDa1Gik5MXI46QCR8Drr8oNCsXXJ0HTx1RydGeinJlvjGbWUeHUHwtUSrZqrxqrHcKWiWi3Opno/1DLBJshxfTA/87ZqhEHtdPwM48t8+VyuFNeYm1IM+zxf1VvHpRXS9WqjzrYqTR7DBLFV8CDuTZ9XKjBTK5R2bhd0H9IFkrZjXN2DSZrznUCRnziZ6sPAQFL/FSaN+ZduT0UhEgZm7q50IHR9vpM/BqskIOckqiMsBlttExOXuUVi9961tUpyPn6gy3y+ACobweeBILKkxqu3IMWUWDm+uXut09RZ7jypbJlq77an/VPKFfgZMjT+R/BVjXuwu5jFLC40JHwkmEiXn2FJKVhl77JcQAV0o4htybNja7Rt3KqTCzGXMdW4JhjHQIGsNd9tBuJR4dEMYq52qjLkLn2MUdyurhLu1wPLMgavynZrjsTMm0t3u1+9XY+43yelC+7T+ieAdWOw55zCqNa/yf1lBH39P03fyg8G16oEBj9XFCRZHt9c1qSuA7KjzZY2icWOe3ap/5vlu3wRJvPmCTISoY3XtKNkqLbufNTfBND03tw4QKI3zWbU8g3taV5zK9J+NdRFiQnsisyqoW2MjmZchYvCTtVzOTRfZF/xiHGxrWloZdypjKY8kd4wVFOJP5RSSuK8NxItVZIU9GUQIOVB0z8WQ3yMwPvO0Xt6Lqs6zIMOwancHpH18pn+mfbtjfkH2Wrk86TFMchLM1Jja5kqrLva9g/msBXTUxIzguyomdAEbyAgv95NMDqP/LVR4jdyDundGjnUOzvMUsqI8KTJVTicemf511u3eRnOjCZH00ORPsRjrL2sjH1E1v/NpKSOrr+LthaiKRNAw34eB1O6KLzABIQqHGjslOzZyq
 RS5aPH/O
 4kpnqSCfWLK3O8pIa21H9AaIY1v7rrAbROiI6iRpUko0SnBGC8Y25dfbYKy46+06QO/HzmBuuXORkU1+a5nDifQ1p1LLpqT8MgOt/Qz4al9JZo4gh5m0y26mh2O2jNkp1ByRRMTD0FyITvJw9ZgWbr3/SoVSJo66+vANqhaZKvc99cKga/c9bts8g/086nR9NYJkWMOU1+Sgd/5kB78b89J26ZoxvOQbumtVoncVWnlRYQfKLpS1HC/6LeCLgQfrey5qEDjAp4yURtkGUnoofoBvqgJ6KL0UxtOYGwM4CHKSFo8ckxyTiX5CdlaiYRcTXh6tW3PDsWXBJsFZGvAvt4Iy8iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 27, 2026 at 11:32:59AM +0200, Manuel Ebner wrote:
> Remove unnecessary ')' and missing '('.

As per David this isn't correct :)

   "Correct typos in mm documentation by balancing parentheses"

?

<newline>

> Signed-off-by: Manuel Ebner <manuelebner@mailbox.org>

Thanks for fixing this!

With the commit message corrected, feel free to add:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  Documentation/mm/hmm.rst           | 4 ++--
>  Documentation/mm/process_addrs.rst | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/mm/hmm.rst b/Documentation/mm/hmm.rst
> index 7d61b7a8b65b..54c461e7a143 100644
> --- a/Documentation/mm/hmm.rst
> +++ b/Documentation/mm/hmm.rst
> @@ -191,7 +191,7 @@ like a CPU page fault. The usage pattern is::
>        mmap_read_unlock(mm);
>
>        take_lock(driver->update);
> -      if (mmu_interval_read_retry(&ni, range.notifier_seq) {
> +      if (mmu_interval_read_retry(&ni, range.notifier_seq)) {
>            release_lock(driver->update);
>            goto again;
>        }
> @@ -316,7 +316,7 @@ between device driver specific code and shared common code:
>     system memory and device private memory.
>
>     One of the first steps migrate_vma_setup() does is to invalidate other
> -   device's MMUs with the ``mmu_notifier_invalidate_range_start(()`` and
> +   device's MMUs with the ``mmu_notifier_invalidate_range_start()`` and
>     ``mmu_notifier_invalidate_range_end()`` calls around the page table
>     walks to fill in the ``args->src`` array with PFNs to be migrated.
>     The ``invalidate_range_start()`` callback is passed a
> diff --git a/Documentation/mm/process_addrs.rst b/Documentation/mm/process_addrs.rst
> index 851680ead45f..b391502fbfd6 100644
> --- a/Documentation/mm/process_addrs.rst
> +++ b/Documentation/mm/process_addrs.rst
> @@ -724,7 +724,7 @@ the zap and the invocation of :c:func:`!free_pgtables`.
>
>  Since it is assumed that all such steps have been taken, page table entries are
>  cleared without page table locks (in the :c:func:`!pgd_clear`, :c:func:`!p4d_clear`,
> -:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions.
> +:c:func:`!pud_clear`, and :c:func:`!pmd_clear` functions).
>
>  .. note:: It is possible for leaf page tables to be torn down independent of
>            the page tables above it as is done by
> --
> 2.54.0
>

Cheers, Lorenzo

