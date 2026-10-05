Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BD96CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 05:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D92F6B0088; Mon,  5 Oct 2026 01:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463096B008C; Mon,  5 Oct 2026 01:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3518F6B0092; Mon,  5 Oct 2026 01:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A0FE6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 01:47:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71A3E80133
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:47:43 +0000 (UTC)
X-FDA: 85287490806.08.291B142
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B3BA580008
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 05:47:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLGt33lf;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791179261;
	b=RuHKpkvpjX19Oc6BhV2aW+dm8yln4hSq39hjocyBzwa1W3fDWG6vfCwC2psPRLmFCQCGH2
	kUh+jQjRh1R3iA3MSgajC6ydhuh4t9bsreGMwLU/kwHytF6ugNIRIskI2Ix7buCI8FR3y2
	/m86ExF7pTcgut6+PjKWcWyWWp/2Ues=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WLGt33lf;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791179261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdID9CqCiCBBOkKgGvMyhfoS09YR9XZ5psi88CHqPqE=;
	b=qO68KCqJbdSB0Y8Sf/I9zgNPUfR4ZQiqGBqCms561Yft70i8GYHQ9nNdA+C7QJvSjlZlod
	jwna+emKnBV/IDDM8ez4g/iaA2zhkz51RkNO2VaFJlOPwgMp/YryFKwTXtUqeHHFSrCrp6
	7KkoxTapD/JkxZN2q4MRFhkaG5Tvriw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3525E6022A;
	Mon,  5 Oct 2026 05:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254B81F000FF;
	Mon,  5 Oct 2026 05:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791179260;
	bh=WdID9CqCiCBBOkKgGvMyhfoS09YR9XZ5psi88CHqPqE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WLGt33lfQhis85EhMbNynpfjFZNyIwXjFSFdF+pCNdRzkvKA814/rYRLNpHxSnC6F
	 jo+wc9HEpn8HqriJVcmIk8aXetaWaed83RxyOdVgz0WFtLFEOgoeoaE6XiHQmJg7tI
	 m9YUkYcXqahMPm0Z/PBITQlt2exEEtIPGDOW0/bE=
Date: Sun, 4 Oct 2026 22:47:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
 hpa@zytor.com, riel@surriel.com, linux-kernel@vger.kernel.org,
 qi.zheng@linux.dev, nadav.amit@gmail.com, thomas.lendacky@amd.com,
 kernel-team@meta.com, linux-mm@kvack.org, brendan.jackman@linux.dev,
 jannh@google.com, mhklinux@outlook.com, andrew.cooper3@citrix.com,
 Manali.Shukla@amd.com, mingo@kernel.org, stable@vger.kernel.org,
 toshi.kani@hpe.com, david@kernel.org, mikhail.v.gavrilov@gmail.com,
 pfalcato@suse.de
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Message-Id: <20261004224739.e1049f07332d388169f7ef08@linux-foundation.org>
In-Reply-To: <20261005052302.43042-1-lance.yang@linux.dev>
References: <20261005052302.43042-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dxneyhcoqa7mz59goqxmnpcyc494ok3f
X-Rspam-User: 
X-Rspamd-Queue-Id: B3BA580008
X-HE-Tag: 1791179261-961372
X-HE-Meta: U2FsdGVkX1+iw6NG3JynmDjUxoxpgM8/iZJLoYfoaLapm8E8/3Li4uGq7XaMZ2ue6CMdOTRDWzYRb1XYiCEynJcQuJbgNWimBYxBmb+GHYRZWjBQ6IQdxNSEzxDa7PJkmmIqWcmaJxRa1AxPUQMU9oBQWNWkeC+d4lO2OY9f8O/P4inT5Pmk8XKsOWNEbax0YG0pAG5q9///Hm4uLTTxL1RafRwdGfgyKBTravjQPlXQkE7AXrSltVo/OS+ITI86W9B0hiZ6ClY+iG7EPyE3qKj0iLGO63GjmUCQaQTPPGENUL2RJriKo3/guFkqKzPOGjWJjuHhMmYqfuGeK2JnUfV0Zykbfj0OzDY50fQsNVhzUzre7ttW9aBqPqTHVCTeC9vr0oNBV5dIkSFeOHgFyo8vz6TSDQ65BFdBsnV7zLjqD48/GAAvxWVOX4vMh6250w0wg0XX60DM7G9aKUTOhdLB5qk3BioRrfkT7gZFABUIyGrolBzrJ6yitRmrczrXnPYK+8BNXIRq27470W7shjz763i5IpqfEw7STWUSBLntywrqd+mHDBVloUmA7roNBltsHrRvC6tqLirhyZpNV3Q+E1DjhhZr1jTjx5rzPOn1nkpyOQtEIBbHrRPjr6JYioJp1Giykvm2HqVygXEwdDvYxgueCEffo3eU9yqYv5U3b8XzZvoBFgpJB12U22zQcTmVYeis58AoIsgbnwWPgw4jnae0Ki9AEvh52g4b8Mcz8fLhkX/brZ0qsLnG/4nwR66Eu3XzSAVpMntuyl3QEeaPAeWnRX2aoRrFs30fJI3zu95yIn3vOz8rSPe0sExpC0kEuqkzqgftYF1aFoGyTcNUPWpWYhde9DrElP/tvZ6UsJjjQixuSBNnWbmRLFZP+lxbzJrTIKxE5UONScFxt5U3BXT2sQjFr3WNROcbhWij/vMQOWZsLpyAXDBSxI6YsVtt46wlrFfpBbZ1Ons
 p0LFRCVz
 OWXww5JqgTBI8jMzyy3OrxLZF6RYNpbvbBNYe8amki9GojaXscbcvP+57z/3Qnmz+Y2igBRuwQqYvYU059qxeAOMzxODrFpqCyXCXYnJ2gUSDO0R6zSSBYvJcBZhhNj6nRSPlDt1WsYb8qCIGj76X6ujRHoKLWmXNJC9kjmtdJ6ysg/SVc9xVx/lhRnssUifaKsRci7JDENHMsHGfXpH/O2IYGrMhD757XbgUl0F4XrKHdnOz/0k+dpOIsCTSQR0etL9oBLtZ570KDsku52lsfcWkpmVVt3Phoy5H6ymPzYiMjSXDWLg3yF91STok/2ZUsJ41GpgfCvwyZKXwBlO5JQIuPUV2tyAYT+r5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  5 Oct 2026 13:23:02 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> pud_free_pmd_page() uses a single-address invalidation to flush the
> paging-structure caches before freeing the page tables. With AMD TCE
> enabled, this only invalidates upper-level entries associated with the
> target address. Cached PMD entries for other addresses in the PUD range can
> still reference the PTE pages being freed.
> 
> The AMD manual quoted in the commit enabling TCE says these instructions
> remove
> 
>   "only those upper-level entries that lead to the target PTE in the page
>   table hierarchy, leaving unrelated upper-level entries intact."
> 
> Even with all PTEs cleared, speculative page walks can cache present PMD
> entries after the earlier TLB purge.
> 
> Use a full TLB flush before freeing the page tables on CPUs with TCE. Keep
> the single-address invalidation otherwise.
> 
> Fixes: 440a65b7d25f ("x86/mm: Enable AMD translation cache extensions")
> Cc: stable@vger.kernel.org

Sorry, but my usual complaint applies.

Check the first 32 lines of
Documentation/process/stable-kernel-rules.rst.  They're very simple,

I'm sure x86 people can immediately grasp the importance of this
change, but nobody else can.  This includes -stable maintainers as well
as a large number of other downstream users of our work who are
wondering "why should I apply this to my kernel".  Let's tell them!


iow, and not for the first time: when fixing a bug please fully
describe the userspace-visible runtime effects of that bug.

Thanks.

