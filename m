Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A8BAC5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 14:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2789F6B008C; Mon, 24 Aug 2026 10:59:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F396B0092; Mon, 24 Aug 2026 10:59:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 164E56B0096; Mon, 24 Aug 2026 10:59:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D681A6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:59:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6559180178
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:59:36 +0000 (UTC)
X-FDA: 85136471952.02.C17AF34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id C107C14000D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 14:59:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGFVkLHL;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787583574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AccNNgKH6mpdiOZn+TQ6yi+YTRFl1ckABXXlP5qNp0s=;
	b=UvubDwMJ6Vt1nUF0mXaHLN2hGcs+S2nRqIbrikglmYF8/IoedgluIas45heeSx8LGF/bKN
	gxvbYAKePWm9hJm/5Rx4vs3jW+RW5qjRriF0Flpn7tL5i/N5yZqKoDWcqI4rk/XSXUGuxM
	haiGjYnzpJEMMZDBsmJrOlF/cf8fl+I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787583574;
	b=euKLb74p2QJ0Bw+1ii5antwDijYs7yjkLRCaE+NgPomRSQu3/chJGUqw+7plK5P7fAGpsW
	cWSWeDMBr1UzNmfFtNPbBr5jIjSt9/+fsfEEpvVB17dqm/mMdJehTZ9k8DadIjlTFeQkDG
	Eou19QLKLk5QO1ZgiSDscig92ys1lrg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WGFVkLHL;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C5FD600CB;
	Mon, 24 Aug 2026 14:59:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2CC1F000E9;
	Mon, 24 Aug 2026 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787583574;
	bh=AccNNgKH6mpdiOZn+TQ6yi+YTRFl1ckABXXlP5qNp0s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WGFVkLHLt8glwJyNyzpbegLiEczgB3KRRpoxrsKbnYBufxLJsdfqDhjhdP7T16Tx5
	 bqxKzSNDAJCPhN/X/3zf+HiOu+g0MnTXFumI1OQd9LYWSCC54AQS8bvMlvM7Q7DEdB
	 F6+Y9XiTmfKwR+wo5sGnM0dgZnSkFBQxie7k+L7q0HtnN0kovChN6zZm2ic4jGevda
	 Hkd+WMr6ZxnA/yTIZcDJL8LfULRtlUE+8UlWLZyr4gIuAu5E7JTeg9qNc7tLpPrH+L
	 z5FuXi7SjxSz37zwDb/a62Uf6rEkWJgcBNM1Kin4Iwuk7WW72JJ2lAu6X7xGJJIEi9
	 2kVhcK32BgG3Q==
Date: Mon, 24 Aug 2026 15:59:26 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mm/gup: move gup_can_follow_protnone() to gup.c
Message-ID: <aoxcRstdSy99lNEA@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260823-uffd-vm-flags-v1-v1-1-3086981b33cf@kernel.org>
X-Rspam-User: 
X-Stat-Signature: kqpm7pawg6e39y9uodi8q1iezadz8d8w
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C107C14000D
X-HE-Tag: 1787583574-600918
X-HE-Meta: U2FsdGVkX1+StK/bYd62JjfBFrOhFyjQSd8ai5op/rOAokGPajC/0ql1Q0JBsQje91U1imfrd9StyFzYfd+brkEu1XdECsCHMwAdcVbiHACwuUiuW1nBrNdMS+H8dRoKo6hOvy09+1UrAnSwljvZS1ez2RM+URVjgP4r+pdv0O9tDod243YBvKo1UhTamV2xF0z6X4oM20sJvuz44KSRixQ+s0nPzpR/5UlOySdM61byQSsxoWH0aeaPDj6Ao6TUz84VVnOfdIwl5joUz6aadWJRJVSDnCPmxmH8w1yB14LybMcqdeAsemgAFo0GncsffYle3S84Xil6LRTruvn9t70Zk+yGrTq8l/0810YhJ8ryNDCYIV0ZFb0GWhs83n1T867a9rDrwM9T6saJ6CCjNvkhUUr+1CJLlyikHtEjatUi18cAfbsF68NTMgYj1D0lpZWT+irBGjaxAZoEND/jKuOROUwroyQMZLEMg0DeHvIcMocCSStr5+m+dVCc87Qvaq/klqM4odHflQGdBG8bDgCte3TQAyJoSj1S/T4fQxy7UHqUUNaJTlitWbYJHYW6+f5txkOZgxtKD8drtcJo6jYNKdCiok0ANvGk9qx+ws1voI9w/TClk9RDvUT0KIpjrvlxTJDceqnevs+ibVYwwM+3t73n+PhSSVCvSR3+o+sNbOLglU32rcyRqpLJlfQLGWPQy8iZcue2xvk2ddkXQSts8n3Tn3nt/dVho4w+9l/svgH/yByJ6HLgDkQWQPcRyb0stRVCJb5SerQyBYOHYXnNxlT+ymF/4G7VqczLBYbI5zMcy8SwVEVBTerViF0BH1lmdMPa0xS21aEpeMEysjyxfwWUhoWnqQBJIm3/dEMiwZkFGxel160Itcx5fKsfgETe+A2IF9C0CGBbhBoBbiFM87vvGWveRVBgtliP2bi04FkJo1QYpggJHZ6PZ4kXzvKpbKAxQ1dq6D6G1X7
 NQLPNfbk
 oRVnX0GhoeUBczO9N1oTFBN31DBVDPIVo2vIu/S07QCxTe1o2PKW09wmu6Xp3f7Tp0QpOO2ogMo3+0gavxJ1f7dUdS3fJA2hZfdpHx1mXKZt8QPSyiQz0wBPPTxw9jhJtcSptCZ7FvpclP8J5epHZVIgDY0Mzf/uQARkWsqtky3LCzXKdNo46vBD6tjRP0S+OZe69EF4NKWds+pMqUevxDs6e+3JzLZ21s+WcfEkggwt1u0jpXaKbiUgnCI3YEfUPAezT/uHBhiebC64nlKYJkyTM6z5GZxgDwAspgIcFOiAhPvhBEB9SKPOEw2ZC8bBy6Nrw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 23, 2026 at 03:17:38PM +0300, Mike Rapoport (Microsoft) wrote:
> gup_can_follow_protnone() is defined in include/linux/mm.h but only used
> by mm/gup.c.
>
> First, there is no reason to have it in already gigantic header.
>
> Next, the upcoming refactoring of userfaultfd flags will make
> gup_can_follow_protnone() depend on userfaultfd_k.h which would cause a
> cyclic header dependency.
>
> Move gup_can_follow_protnone() to mm/gup.c.
>
> No functional change.
>
> Assisted-by: copilot:claude-opus-5
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  include/linux/mm.h | 38 --------------------------------------
>  mm/gup.c           | 38 ++++++++++++++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+), 38 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0829e0d3b2d1..4daf9cd6ae8e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4860,44 +4860,6 @@ static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
>  	return 0;
>  }
>
> -/*
> - * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
> - * a (NUMA hinting or userfaultfd RWP) fault is required.
> - */
> -static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
> -					   unsigned int flags)
> -{
> -	/*
> -	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
> -	 * NUMA hinting. GUP must always take a fault so the access is
> -	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
> -	 *
> -	 * Only do so while the VMA is accessible. If it has been made
> -	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
> -	 * below: forcing a fault there would loop, as handle_mm_fault() makes
> -	 * no progress on protnone in an inaccessible VMA, and the access is
> -	 * denied regardless of RWP anyway.
> -	 */
> -	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
> -		return false;
> -
> -	/*
> -	 * If callers don't want to honor NUMA hinting faults, no need to
> -	 * determine if we would actually have to trigger a NUMA hinting fault.
> -	 */
> -	if (!(flags & FOLL_HONOR_NUMA_FAULT))
> -		return true;
> -
> -	/*
> -	 * NUMA hinting faults don't apply in inaccessible (PROT_NONE) VMAs.
> -	 *
> -	 * Requiring a fault here even for inaccessible VMAs would mean that
> -	 * FOLL_FORCE cannot make any progress, because handle_mm_fault()
> -	 * refuses to process NUMA hinting faults in inaccessible VMAs.
> -	 */
> -	return !vma_is_accessible(vma);
> -}
> -
>  typedef int (*pte_fn_t)(pte_t *pte, unsigned long addr, void *data);
>  extern int apply_to_page_range(struct mm_struct *mm, unsigned long address,
>  			       unsigned long size, pte_fn_t fn, void *data);
> diff --git a/mm/gup.c b/mm/gup.c
> index eb898ea1ee22..500e2aa99e48 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -633,6 +633,44 @@ static struct page *no_page_table(struct vm_area_struct *vma,
>  	return NULL;
>  }
>
> +/*
> + * Indicates whether GUP can follow a PROT_NONE mapped page, or whether
> + * a (NUMA hinting or userfaultfd RWP) fault is required.
> + */
> +static inline bool gup_can_follow_protnone(const struct vm_area_struct *vma,
> +					   unsigned int flags)
> +{
> +	/*
> +	 * VM_UFFD_RWP uses protnone as an access-tracking marker, not for
> +	 * NUMA hinting. GUP must always take a fault so the access is
> +	 * delivered to userfaultfd, regardless of FOLL_HONOR_NUMA_FAULT.
> +	 *
> +	 * Only do so while the VMA is accessible. If it has been made
> +	 * inaccessible (e.g. mprotect(PROT_NONE)), fall through to the guard
> +	 * below: forcing a fault there would loop, as handle_mm_fault() makes
> +	 * no progress on protnone in an inaccessible VMA, and the access is
> +	 * denied regardless of RWP anyway.
> +	 */
> +	if (vma_test_single_mask(vma, VMA_UFFD_RWP) && vma_is_accessible(vma))
> +		return false;
> +
> +	/*
> +	 * If callers don't want to honor NUMA hinting faults, no need to
> +	 * determine if we would actually have to trigger a NUMA hinting fault.
> +	 */
> +	if (!(flags & FOLL_HONOR_NUMA_FAULT))
> +		return true;
> +
> +	/*
> +	 * NUMA hinting faults don't apply in inaccessible (PROT_NONE) VMAs.
> +	 *
> +	 * Requiring a fault here even for inaccessible VMAs would mean that
> +	 * FOLL_FORCE cannot make any progress, because handle_mm_fault()
> +	 * refuses to process NUMA hinting faults in inaccessible VMAs.
> +	 */
> +	return !vma_is_accessible(vma);
> +}
> +
>  #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
>  /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
>  static inline bool can_follow_write_pud(pud_t pud, struct page *page,
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

